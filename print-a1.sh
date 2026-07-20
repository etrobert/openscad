#!/usr/bin/env bash
# Slice an STL and send it to the Bambu A1 over LAN, optionally starting
# the print. Uses OrcaSlicer's bundled Bambu profiles (A1, 0.4 nozzle,
# 0.12mm High Quality, PLA Basic, textured plate).
#
#   ./print-a1.sh model.stl           # slice + upload only
#   ./print-a1.sh model.stl --start   # slice + upload + start printing
#
# The LAN access code is read from $A1_ACCESS_CODE or ~/.config/a1-access-code.
# Note: mid-print pauses for magnet inserts are not supported here — designs
# that need a pause must go through Bambu Studio by hand.

set -euo pipefail

host=${A1_HOST:-192.168.0.101}
serial=${A1_SERIAL:-03900D613106171}
code=${A1_ACCESS_CODE:-$(cat ~/.config/a1-access-code)}

stl=$(realpath "$1")
start=${2:-}
name=$(basename "$stl" .stl)
work=$(mktemp --directory)
trap 'rm -rf "$work"' EXIT
cd "$work" # the slicer drops log files into the working directory

profiles=$(nix build nixpkgs#orca-slicer --no-link --print-out-paths)/share/OrcaSlicer/profiles/BBL

# The bundled profiles are partial: they point to their base profile via
# "inherits", which the CLI does not resolve — printable_area and friends
# would silently fall back to defaults (200x200 plate). Merge each chain
# into a self-contained file first.
resolve_profile() {
  nix run nixpkgs#python3 -- - "$profiles/$1" "$2" "$work/$(basename "$1").json" <<'EOF'
import json, os, sys

dirpath, name, out = sys.argv[1:4]

def resolve(name):
    with open(os.path.join(dirpath, name + ".json")) as f:
        node = json.load(f)
    parent = node.pop("inherits", None)
    if parent:
        base = resolve(parent)
        base.update(node)
        return base
    return node

with open(out, "w") as f:
    json.dump(resolve(name), f)
EOF
}

resolve_profile machine "Bambu Lab A1 0.4 nozzle"
resolve_profile process "0.12mm High Quality @BBL A1"
resolve_profile filament "Bambu PLA Basic @BBL A1"

nix run nixpkgs#orca-slicer -- \
  --load-settings "$work/machine.json;$work/process.json" \
  --load-filaments "$work/filament.json" \
  --curr-bed-type "Textured PEI Plate" \
  --orient 0 --arrange 1 --slice 0 \
  --export-3mf "$work/$name.gcode.3mf" \
  "$stl"

grep --max-count=1 "total estimated time" <(nix shell nixpkgs#unzip --command unzip -p "$work/$name.gcode.3mf" Metadata/plate_1.gcode)

nix shell nixpkgs#curl --command curl --silent --insecure --user "bblp:$code" \
  --upload-file "$work/$name.gcode.3mf" "ftps://$host:990/$name.gcode.3mf"
echo "uploaded $name.gcode.3mf"

if [ "$start" = "--start" ]; then
  echo | nix shell nixpkgs#openssl --command openssl s_client -connect "$host:8883" -showcerts 2>/dev/null |
    awk '/BEGIN CERT/{n++} n>=1{print}' >"$work/ca.pem"

  payload=$(
    cat <<EOF
{"print": {"sequence_id": "0", "command": "project_file",
  "param": "Metadata/plate_1.gcode", "url": "file:///sdcard/$name.gcode.3mf",
  "subtask_name": "$name", "project_id": "0", "profile_id": "0",
  "task_id": "0", "subtask_id": "0", "md5": "", "timelapse": false,
  "bed_type": "auto", "bed_levelling": true, "flow_cali": false,
  "vibration_cali": true, "layer_inspect": false, "use_ams": false}}
EOF
  )
  nix shell nixpkgs#mosquitto --command mosquitto_pub -h "$host" -p 8883 \
    -u bblp -P "$code" --cafile "$work/ca.pem" --insecure \
    -t "device/$serial/request" -m "$payload"
  echo "print started: $name"
fi
