// Alignment plate for two side-by-side wooden key trays.
// A thin plastic plate with two tongues, each nesting in the shallow
// decorative recess on a box's underside, joined by a bridge across the
// seam — so the two boxes stay aligned and can't drift apart.
//
// Axes: X runs across the two boxes (the bridge direction),
//       Y runs along the seam between them.

// Measurements — TO VERIFY on the actual boxes
recess_x = 50;         // recess size across the boxes (X)
recess_y = 50;         // recess size along the seam (Y)
recess_depth = 5;      // how far the recess sinks up into the box bottom
recess_corner_r = 8;   // rounded-corner radius of the recess
recess_spacing = 100;  // centre-to-centre distance of the two recesses
                       // (= box width, when the boxes touch along long edges)

// Fit
clearance = 0.4;       // per-side gap so a tongue drops into its recess easily

// Plate
tongue_thickness = 4;  // <= recess_depth so the boxes don't rock (aim just under 5)
bridge_thickness = 4;  // if the boxes touch, ANY thickness here lifts them along
                       // the bridge path — keep it small, or set = tongue_thickness
                       // only if there is a real gap for the bridge to sit in
bridge_width = 30;     // width of the connecting bridge, along the seam (Y)

// Derived
tongue_x = recess_x - 2 * clearance;
tongue_y = recess_y - 2 * clearance;
tongue_r = max(0.5, recess_corner_r - clearance);

$fn = 48;

// A rounded rectangle of size [x, y], corner radius r, extruded to height h.
module rounded_slab(x, y, r, h) {
  linear_extrude(height = h)
    offset(r = r)
      square([x - 2 * r, y - 2 * r], center = true);
}

module tongue() {
  rounded_slab(tongue_x, tongue_y, tongue_r, tongue_thickness);
}

module bridge() {
  // Spans between the two tongue centres; overlaps into each tongue.
  // Cross-section (Y-Z) is a half-ellipse: flat bottom, arched top like a
  // bridge, peaking at bridge_thickness in the middle.
  r = bridge_width / 2;

  scale([1, 1, bridge_thickness / r])
    intersection() {
      rotate([0, 90, 0])
        cylinder(h = recess_spacing, r = r, center = true);

      // Keep only the top half (z >= 0) so the bottom stays flat.
      translate([0, 0, r])
        cube([recess_spacing + 1, bridge_width, 2 * r], center = true);
    }
}

module plate() {
  union() {
    for (sx = [-1, 1])
      translate([sx * recess_spacing / 2, 0, 0])
        tongue();

    bridge();
  }
}

// Render selector: "all" for the full plate, "bridge" to test just the bridge.
part = "all";

if (part == "bridge") bridge();
else plate();
