// Extra-slim 8mm discs printed face up, chamfer ladder 0.6 / 0.4 / 0.2 / 0.
// Slice at 0.12mm; pause at the last layer with open pockets (~z=2.6).
// Geometry lives in magnetic-earring.scad.

use <magnetic-earring.scad>

$fa = 4;
$fs = 0.25;

for (i = [0:3])
  translate(v=[i * 14, 0, 0]) extra_slim([0.6, 0.4, 0.2, 0][i], 8);
