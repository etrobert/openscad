// Magnetic stud earring — no piercing, earlobe clamped between the printed
// front piece and a bare 6×2mm neodymium disc behind the lobe.
// Print face down. Magnet is pause-captured: pause at z=4.2 (slim: z=2.8),
// drop the magnet in, resume. Magnet sits 0.2 below the pause surface so
// the nozzle can't snag it. Polarity doesn't matter — the bare back magnet
// flips itself to attract.

$fa = 4;
$fs = 0.25;

magnet_d = 6;
magnet_h = 2;
clearance = 0.2; // pocket diameter extra — verify with tolerance-test-magnet
pocket_d = magnet_d + clearance;

face_d = 10;
total_h = 4.8;
cap_h = 0.6; // skin-side wall over the magnet, 3 layers at 0.2
recess = 0.2; // magnet sits this far below the pause surface

pocket_top = total_h - cap_h;
pocket_bottom = pocket_top - magnet_h - recess;

spacing = face_d + 6;

module pocket(bottom = pocket_bottom) {
  translate(v=[0, 0, bottom])
    cylinder(h=magnet_h + recess, d=pocket_d);
}

// octagonal frustum flaring from the table to full width, like a bezel-cut stone
module gem() {
  difference() {
    union() {
      cylinder(h=pocket_bottom, d1=face_d * 0.54, d2=face_d, $fn=8);
      translate(v=[0, 0, pocket_bottom])
        cylinder(h=total_h - pocket_bottom, d=face_d, $fn=8);
    }
    pocket();
  }
}

// hexagonal prism with a chamfered face edge
module hex() {
  chamfer_h = 1.5;
  difference() {
    union() {
      cylinder(h=chamfer_h, d1=face_d * 0.7, d2=face_d, $fn=6);
      translate(v=[0, 0, chamfer_h])
        cylinder(h=total_h - chamfer_h, d=face_d, $fn=6);
    }
    pocket();
  }
}

function star_points(n, r_outer, r_inner) =
  [
    for (i = [0:2 * n - 1]) let (a = 90 + i * 180 / n, r = i % 2 == 0 ? r_outer : r_inner) [r * cos(a), r * sin(a)],
  ];

// chamfered disc with a five-point star engraved into the face
module star() {
  chamfer_h = 0.8;
  engrave = 0.8;
  difference() {
    union() {
      cylinder(h=chamfer_h, d1=face_d - 2 * chamfer_h, d2=face_d);
      translate(v=[0, 0, chamfer_h])
        cylinder(h=total_h - chamfer_h, d=face_d);
    }
    translate(v=[0, 0, -0.5])
      linear_extrude(engrave + 0.5)
        polygon(star_points(5, 3.5, 1.6));
    pocket();
  }
}

// plain disc with a wide chamfer, minimal
module disc() {
  chamfer_h = 1.2;
  difference() {
    union() {
      cylinder(h=chamfer_h, d1=face_d - 2 * chamfer_h, d2=face_d);
      translate(v=[0, 0, chamfer_h])
        cylinder(h=total_h - chamfer_h, d=face_d);
    }
    pocket();
  }
}

// flat disc as thin as the magnet allows, edge chamfer optional
module slim(chamfer_h = 0.6) {
  floor_h = 0.6;
  slim_h = floor_h + magnet_h + recess + cap_h;
  difference() {
    union() {
      if (chamfer_h > 0)
        cylinder(h=chamfer_h, d1=face_d - 2 * chamfer_h, d2=face_d);
      translate(v=[0, 0, chamfer_h])
        cylinder(h=slim_h - chamfer_h, d=face_d);
    }
    pocket(floor_h);
  }
}

slim_chamfers = [0.6, 0.4, 0.2, 0];

gem();
translate(v=[spacing, 0, 0]) hex();
translate(v=[2 * spacing, 0, 0]) star();
translate(v=[3 * spacing, 0, 0]) disc();
for (i = [0:3])
  translate(v=[i * spacing, -spacing, 0]) slim(slim_chamfers[i]);
