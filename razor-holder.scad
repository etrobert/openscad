include <gridfinity-rebuilt-openscad/src/core/standard.scad>
use <gridfinity-rebuilt-openscad/src/core/bin.scad>
use <gridfinity-rebuilt-openscad/src/helpers/shapes.scad>

$fa = 4;
$fs = 0.25;

// 5×2 bin: 5 cols (42mm pitch, ~28mm gap side-by-side) × 2 rows, all same direction
// 10 holes for 10×10mm razor handles, height 56mm (8 gridfinity units)
// Tune clearance using clearance-test.scad before printing

clearance = 0.2; // total extra per axis — adjust from test results
hole = 10 + clearance;
corner_r = 1; // small radius to fit square handles

bin = new_bin([5, 2], 56);

depth = bin_get_infill_size_mm(bin).z;

bin_render(bin) {
  bin_subdivide(bin, [5, 2]) {
    translate([0, 0, -depth])
      linear_extrude(depth + 1)
        rounded_square([hole, hole], corner_r, center=true);
  }
}
