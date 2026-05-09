// Measured diameter 11.65mm
perfume_sample_with_label_diameter = 11.65;

// Test ring for perfume sample fit verification

wall_thickness = 3; // ring wall
height = 5; // ring height — enough to hold steady while testing
increment = 0.15;
ring_spacing = perfume_sample_with_label_diameter;

for (i = [0:5]) {
  inner_diameter = perfume_sample_with_label_diameter + i * increment;
  outer_diameter = inner_diameter + (wall_thickness * 2);
  translate(v=[i * 2 * ring_spacing, 0, 0]) {
    difference() {
      cylinder(h=height, d=outer_diameter, center=true, $fn=128);
      cylinder(h=height + 1, d=inner_diameter, center=true, $fn=128);
    }
  }
}
