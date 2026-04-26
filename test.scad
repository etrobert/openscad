include <gridfinity-rebuilt-openscad/src/core/standard.scad>
use <gridfinity-rebuilt-openscad/src/core/base.scad>

union() {
  // Bottom 5 rows: 5 units wide
  gridfinityBase([5, 5]);

  // Top 1 row: 3 units wide, shifted up by 5 rows
  translate([0, 5 * GRID_DIMENSIONS_MM.y, 0])
    gridfinityBase([3, 1]);
}
