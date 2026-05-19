// Clearance test for 10×10mm square razor handle.
// Print this first, try each hole, then set clearance= in razor-holder.scad.
// Holes left→right: +0.0 through +0.6mm in 0.1mm steps.
// Corner radius 1mm (small, to fit square handles).
// Labels are debossed into the top face for clean FDM printing.

use <gridfinity-rebuilt-openscad/src/helpers/shapes.scad>

$fa = 4;
$fs = 0.25;

base_size   = 10;
test_depth  = 10;
corner_r    = 1;
side_wall   = 4;
front_wall  = 11; // extra room for two-line label on top
back_wall   = 4;
n           = 7;
pitch       = base_size + side_wall;
block_w     = n * pitch + side_wall;
block_d     = front_wall + base_size + back_wall;
hole_y      = front_wall + base_size / 2;

difference() {
    cube([block_w, block_d, test_depth]);

    // holes
    for (i = [0:n-1]) {
        s = base_size + i * 0.1;
        translate([side_wall + i * pitch + base_size / 2,
                   hole_y,
                   -0.1])
        linear_extrude(test_depth + 0.2)
            rounded_square([s, s], corner_r, center = true);
    }

    // labels debossed into top face
    for (i = [0:n-1]) {
        s  = base_size + i * 0.1;
        cx = side_wall + i * pitch + base_size / 2;

        translate([cx, 2, test_depth - 0.5])
        linear_extrude(0.6)
            text(str(s), size = 3,
                 font = "Liberation Sans",
                 halign = "center", valign = "bottom");

        translate([cx, 6.5, test_depth - 0.5])
        linear_extrude(0.6)
            text(str("+", i * 0.1), size = 3,
                 font = "Liberation Sans",
                 halign = "center", valign = "bottom");
    }
}
