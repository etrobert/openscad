// Measurements
alex_drawer_wall_height = 117;
drawer_inner_depth = 524; // kind of
drawer_inner_width = 292;
folded_sock_average_height = 105;

// Constants
wall_width = 5; // thicker to allow an inset rail groove
sock_space_width = 100;
height = 100;

// Derived
front_panel_height = height / 2;
interior_width = sock_space_width - 2 * wall_width; // = 90

module insert_body() {
  // Bottom
  cube([sock_space_width, drawer_inner_depth, wall_width], center=true);

  // Walls
  for (sx = [-1, 1]) {
    translate([sx * (sock_space_width / 2 - wall_width / 2), 0, height / 2])
      cube([wall_width, drawer_inner_depth, height], center=true);
  }

  // Front panel
  translate([0, -(drawer_inner_depth / 2 - wall_width / 2), front_panel_height / 2])
    cube([sock_space_width, wall_width, front_panel_height], center=true);
}

// Render insert
insert_body();
