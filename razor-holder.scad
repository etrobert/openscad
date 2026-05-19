include <gridfinity-rebuilt-openscad/src/core/standard.scad>
use <gridfinity-rebuilt-openscad/src/core/bin.scad>
use <gridfinity-rebuilt-openscad/src/core/gridfinity-rebuilt-holes.scad>
use <gridfinity-rebuilt-openscad/src/helpers/shapes.scad>

$fa = 4;
$fs = 0.25;

// 2×2 gridfinity bin, 2×5 holes
// 10 holes for 10×10mm razor handles, height 56mm (8 gridfinity units)

clearance = 0.2; // total extra per axis
hole = 10 + clearance;
corner_r = 1; // small radius to fit square handles

bin = new_bin([2, 2], 56, hole_options = bundle_hole_options(refined_hole = true));

depth = bin_get_infill_size_mm(bin).z;

bin_render(bin) {
  bin_subdivide(bin, [2, 5]) {
    translate([0, 0, -depth])
      linear_extrude(depth + 1)
        rounded_square([hole, hole], corner_r, center=true);
  }
}
