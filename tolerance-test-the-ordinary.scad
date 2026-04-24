// Test ring for bottle fit verification
// Inner diameter: 34mm (33.35mm bottle + ~0.65mm tolerance)

base_inner_diameter = 33; // change this to test different tolerances
wall_thickness = 3; // ring wall
height = 10; // ring height — enough to hold steady while testing

for (i = [0:3]) {
  inner_diameter = base_inner_diameter + i * 0.5;
  outer_diameter = inner_diameter + (wall_thickness * 2);
  translate(v=[i * 50, 0, 0]) {
    difference() {
      cylinder(h=height, d=outer_diameter, center=true, $fn=128);
      cylinder(h=height + 1, d=inner_diameter, center=true, $fn=128);
    }
  }
}
