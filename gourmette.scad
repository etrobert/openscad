// Gourmette — curved bar piece for chain bracelet

// Parameters
bar_length = 50; // arc length in mm
bar_width = 10; // bar width (across the curve)
bar_thickness = 4; // bar thickness
bend_radius = 75; // radius of curvature (larger = flatter bend)
hole_diameter = 3; // chain attachment hole diameter
hole_inset = 3.5; // distance from each end to hole center
corner_radius = 1; // edge rounding

// Derived
arc_angle = (bar_length / (2 * PI * bend_radius)) * 360;
mid_radius = bend_radius + bar_thickness / 2;
hole_inset_angle = (hole_inset / (2 * PI * mid_radius)) * 360;

module bar_profile() {
  r = corner_radius;
  hull()for (x = [bend_radius + r, bend_radius + bar_thickness - r])
    for (y = [-bar_width / 2 + r, bar_width / 2 - r])
      translate([x, y]) circle(r=r, $fn=16);
}

module gourmette() {
  difference() {
    rotate_extrude(angle=arc_angle, $fn=128)
      bar_profile();

    // Hole near start end — radial (front to back through thickness)
    rotate([0, 0, hole_inset_angle])
      translate([mid_radius, 0, 0])
        rotate([0, 90, 0])
          cylinder(d=hole_diameter, h=bar_thickness + 2, center=true, $fn=32);

    // Hole near far end — radial (front to back through thickness)
    rotate([0, 0, arc_angle - hole_inset_angle])
      translate([mid_radius, 0, 0])
        rotate([0, 90, 0])
          cylinder(d=hole_diameter, h=bar_thickness + 2, center=true, $fn=32);
  }
}

gourmette();
