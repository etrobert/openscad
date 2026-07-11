// Magnetic stud earring — no piercing, earlobe clamped between the printed
// front piece and a bare 6×2mm neodymium disc behind the lobe.
// Printed face up (skin side on the plate) so the visible face is a top
// surface, not the plate texture. Heights sit on the 0.12mm preset grid
// (0.2 first layer + 0.12 steps) — slice at 0.12 only.
// Magnet is pause-captured: pause at the last layer with open pockets
// (~z=2.6), press the magnet in fully, resume. Polarity doesn't matter —
// the bare back magnet flips itself to attract.

$fa = 4;
$fs = 0.25;

magnet_d = 6;
magnet_h = 2;
clearance = 0.2; // pocket diameter extra — verify with tolerance-test-magnet
pocket_d = magnet_d + clearance;

face_d = 8;
cap_h = 0.32; // skin side, against the plate — compressed by the magnet, 2 layers suffice
recess = 0.28; // deep enough that the steel nozzle can't lift the magnet into the bridge
floor_h = 0.48; // face layers bridging over the magnet
total_h = cap_h + magnet_h + recess + floor_h;

// flat disc, symmetric edge chamfers, 0 for square edges
module earring(chamfer_h = 0.6, d = face_d) {
  difference() {
    union() {
      if (chamfer_h > 0)
        cylinder(h=chamfer_h, d1=d - 2 * chamfer_h, d2=d);
      translate(v=[0, 0, chamfer_h])
        cylinder(h=total_h - 2 * chamfer_h, d=d);
      if (chamfer_h > 0)
        translate(v=[0, 0, total_h - chamfer_h])
          cylinder(h=chamfer_h, d1=d, d2=d - 2 * chamfer_h);
    }
    translate(v=[0, 0, cap_h])
      cylinder(h=magnet_h + recess, d=pocket_d);
  }
}

chamfers = [0.6, 0.4, 0.2, 0];

for (i = [0:3])
  translate(v=[i * (face_d + 6), 0, 0]) earring(chamfers[i]);
