# CLAUDE.md

OpenSCAD designs for 3D printing on a Bambu Lab A1. Each `.scad` is rendered to
a committed `.stl` (`nix develop --command openscad -o out.stl in.scad`).

## Printer

Bambu Lab A1, 0.4 nozzle, at `192.168.0.101`, serial `03900D613106171`. LAN-Only
Mode + Developer Mode are enabled on the printer — required for local MQTT
control; without Developer Mode the cloud-paired firmware rejects unsigned
commands with `err_code 84033543`. The LAN access code is in
`~/.config/a1-access-code` on tower.

`./print-a1.sh <model.stl> [--start]` slices headlessly (OrcaSlicer CLI, 0.12mm
High Quality, PLA Basic, textured plate), uploads via FTPS, and starts the print
via MQTT. It cannot insert mid-print pauses — designs that need one (e.g. magnet
capture) go through Bambu Studio by hand. Monitor progress via MQTT topic
`device/<serial>/report` (`gcode_state`, `mc_percent`; the printer's CA cert
must be extracted from the TLS handshake and passed as `--cafile`).

## Magnets

Stock: ~400 neodymium discs 6×2mm, grade unknown; grip through an earlobe is
validated. Press-fit pockets for them: Ø6.2 (verified with
`tolerance-test-magnet` in pink PLA at 0.12mm — re-test per filament).
