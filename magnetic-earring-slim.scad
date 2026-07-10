// Slim 8mm discs, chamfer ladder 0.6 / 0.4 / 0.2 / 0 — pause at z=2.8.
// Geometry lives in magnetic-earring.scad.

use <magnetic-earring.scad>

$fa = 4;
$fs = 0.25;

for (i = [0:3])
  translate(v=[i * 14, 0, 0]) slim([0.6, 0.4, 0.2, 0][i], 8);
