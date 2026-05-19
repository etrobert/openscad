// Clearance test for 10×10mm square razor handle.
// Print this first, try each hole, then set clearance= in razor-holder.scad.
// Holes left→right: +0.0, +0.1, +0.2, +0.3, +0.4mm total per axis.
// Corner radius matches gridfinity bins (r_f2 = 2.8mm).

use <gridfinity-rebuilt-openscad/src/core/cutouts.scad>

$fa = 4;
$fs = 0.25;

base_size = 10;
test_depth = 10; // just enough to feel the fit
wall = 5;
n = 5;
pitch = base_size + wall; // 15mm center-to-center
block_w = n * pitch + wall; // 80mm
block_d = base_size + 2 * wall;

difference() {
  cube([block_w, block_d, test_depth]);

  for (i = [0:n - 1]) {
    s = base_size + i * 0.1;
    // compartment_cutter is XY-centered, extends downward from z=0
    translate(
      [
        wall + i * pitch + base_size / 2,
        block_d / 2,
        test_depth + 0.1,
      ]
    )
      compartment_cutter([s, s, test_depth + 0.2]);
  }
}

// Labels on front face
for (i = [0:n - 1]) {
  translate([wall + i * pitch, 0, test_depth - 5])
    rotate([90, 0, 0])
      linear_extrude(0.6)
        text(
          str("+", i * 0.1), size=3.5,
          font="Liberation Sans",
          halign="left", valign="bottom"
        );
}
             halign = "left", valign = "bottom");

    translate([wall + i * pitch, 0, 0.5])
    rotate([90, 0, 0])
    linear_extrude(0.6)
        text(str("+", i * 0.1), size = 3,
             font = "Liberation Sans",
             halign = "left", valign = "bottom");
}
