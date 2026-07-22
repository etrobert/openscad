// Clearance checks for acorn-earring-chain.scad — every combination below
// must render EMPTY ("Current top level object is empty"):
//   for p in 0 1 2; do for g in 0 1; do
//     nix develop --command openscad-unstable -o /tmp/check.stl \
//       -D pair=$p -D grow=$g acorn-earring-chain-check.scad
//   done; done
// grow=0 checks exact contact; grow=1 checks 0.35mm minimum clearance.

include <acorn-earring-chain.scad>
show_chain = false;

pair = 0; // 0: ring∩link1, 1: link1∩link2, 2: link2∩(loop+acorn)
grow = 0;

module maybe_grown() {
  if (grow > 0) minkowski() { children(); sphere(r=0.35, $fn=16); }
  else children();
}

if (pair == 0) intersection() { big_ring(); maybe_grown() link(c1); }
if (pair == 1) intersection() { link(c1); maybe_grown() link(c1 + pitch); }
if (pair == 2) intersection() {
  union() { stem_loop(); acorn(); }
  maybe_grown() link(c1 + pitch);
}
