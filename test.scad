// Measurements
alex_drawer_wall_height = 117;
drawer_inner_depth = 524; // kind of
drawer_inner_width = 292;
folded_sock_average_height = 105;

// Constants
wall_width = 2;
sock_space_width = 100;
height = 100;

// Bottom
cube([sock_space_width, drawer_inner_depth, wall_width], center=true);

// Right wall
translate([sock_space_width / 2 - wall_width / 2, 0, height / 2]) {
  cube([wall_width, drawer_inner_depth, height], center=true);
}

// Left wall
translate([-(sock_space_width / 2 - wall_width / 2), 0, height / 2]) {
  cube([wall_width, drawer_inner_depth, height], center=true);
}

front_panel_height = height / 2;

// Front panel
translate([0, -(drawer_inner_depth / 2 - wall_width / 2), front_panel_height / 2]) {
  cube([sock_space_width, wall_width, front_panel_height], center=true);
}
