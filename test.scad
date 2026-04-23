// Measurements
alex_drawer_wall_height = 117;
drawer_inner_depth = 524; // kind of
drawer_inner_width = 292;
folded_sock_average_height = 105;

// Constants
wall_width = 5; // thicker to allow an inset rail groove
sock_space_width = 100;
height = 100;

// Rail groove parameters (cut into the inside face of each side wall)
rail_center_z = 35; // height of groove center from bottom
rail_gap = 4; // groove opening height
rail_groove_d = 3; // groove depth into the wall (wall_width - rail_groove_d = 2 mm remaining)
clearance = 0.3;

// Derived
front_panel_height = height / 2;
interior_width = sock_space_width - 2 * wall_width; // = 90
wall_inside_x = sock_space_width / 2 - wall_width; // = 45  (inside face of each wall)

rail_y_front = -(drawer_inner_depth / 2 - wall_width); // = -257  (stops at back of front panel)
rail_y_back = drawer_inner_depth / 2; // = +262
rail_depth = rail_y_back - rail_y_front; // = 519
rail_y_mid = (rail_y_front + rail_y_back) / 2;

module insert_body() {
  difference() {
    union() {
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

    // Rail grooves — one per side wall, cut from inside face
    for (sx = [-1, 1]) {
      translate([sx * (wall_inside_x + rail_groove_d / 2), rail_y_mid, rail_center_z])
        cube([rail_groove_d, rail_depth, rail_gap], center=true);
    }
  }
}

// ── Pusher panel ──────────────────────────────────────────────────────────────
// Body fits the full interior width; side tabs extend into the wall grooves.

pusher_depth = 2;
pusher_body_w = interior_width - 2 * clearance; // ≈ 89.4 mm
pusher_body_h = height - wall_width; // = 95 mm
tab_ext = rail_groove_d - clearance; // ≈ 2.7 mm  (into groove)
tab_h = rail_gap - clearance; // ≈ 3.7 mm  (fits slot opening)

module pusher_panel() {
  difference() {
    union() {
      // Main body
      translate([0, 0, wall_width + pusher_body_h / 2])
        cube([pusher_body_w, pusher_depth, pusher_body_h], center=true);

      // Right tab — slides into right wall groove
      translate([pusher_body_w / 2 + tab_ext / 2, 0, rail_center_z])
        cube([tab_ext, pusher_depth, tab_h], center=true);

      // Left tab — slides into left wall groove
      translate([-(pusher_body_w / 2 + tab_ext / 2), 0, rail_center_z])
        cube([tab_ext, pusher_depth, tab_h], center=true);
    }
  }
}

// Render insert
insert_body();

// Pusher shown displaced to the side for printing as a separate part
translate([sock_space_width + 20, 0, 0])
  pusher_panel();
