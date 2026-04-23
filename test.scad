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
front_panel_height = height * 2 / 3;
interior_width = sock_space_width - 2 * wall_width; // = 90
groove_bonus = 1; // This is used to help visualisation. Set to 0 for exact dimensions.

groove_depth = 3;

// TODO: Check wether back needs support, for example by sliding the panel mid-print and adding a back panel

module insert_body() {
  // Bottom
  cube([sock_space_width + wall_width * 2, drawer_inner_depth, wall_width], center=true);

  difference() {
    group() {
      // TODO: Make walls not sharp in the front, for example with angle from front of panel
      // Walls
      for (sx = [-1, 1]) {
        translate([sx * (sock_space_width / 2 + wall_width / 2), 0, height / 2])
          difference() {
            cube([wall_width, drawer_inner_depth, height], center=true);

            // Bottom Groove
            translate([sx * ( -groove_depth / 2), 0, -(height / 2 - wall_width)])
              cube([groove_depth, drawer_inner_depth + groove_bonus, wall_width], center=true);
          }
      }

      // Front panel
      translate([0, -(drawer_inner_depth / 2 - wall_width / 2), front_panel_height / 2])
        cube([sock_space_width + wall_width * 2, wall_width, front_panel_height], center=true);
    }

    for (sx = [-1, 1]) {
      // Elastic Band Groove
      translate([sx * ( -groove_depth / 2 + sock_space_width / 2 + wall_width / 2), 0, height / 2])
        cube([groove_depth, drawer_inner_depth + groove_bonus, wall_width], center=true);
    }
  }
}

// TODO: Create the sliding panel, with bottom stabilizer plate

// Render insert
insert_body();
