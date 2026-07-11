// Penis figurine (mini-pe.stl) as a rigid magnetic stud: the slim disc from
// magnetic-earring.scad clamps the lobe, the figure stands on its face.
// Same print recipe: 0.12mm layers, face up, pause at the last layer with
// open pockets (~z=2.6), press the magnet in, resume.

use <magnetic-earring.scad>

$fa = 4;
$fs = 0.25;

model_scale = 0.7;
base_d = 12;
base_h = 3.08; // total_h in magnetic-earring.scad
embed = 0.3; // sink the figure into the disc so the union is solid

earring(0.6, base_d);

translate(v=[0, 0, base_h - embed])
  scale(v=model_scale)
    translate(v=[-0.28, -9.38, 0]) // center the model bbox on the disc
      import("mini-pe.stl");
