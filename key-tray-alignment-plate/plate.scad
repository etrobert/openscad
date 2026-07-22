// Alignment plate for two side-by-side wooden key trays.
// A small plastic plate: two locating tabs, each nesting in the shallow
// decorative recess on a box's underside, joined by an arched bridge across
// the seam — so the two boxes stay aligned and can't drift apart.
//
// Axes: X runs across the two boxes (the bridge direction),
//       Y runs along the seam between them.

// Tab — the rectangular locating rail on each side; sits in a box's underside
// recess and runs the full length of the bridge.
tab_w = 10;            // X, across the boxes
tab_thickness = 10;    // Z; exceeds the ~5mm recess, so rails protrude below
                       // the box and lift it ~5mm off the floor

// Bridge — spans the seam and joins the two tabs.
gap_x = 20;            // bridge span between the tabs (X)
bridge_thickness = 3;  // arch height at the peak
bridge_width = 70;     // bridge extent along the seam (Y); tabs share this length

// Derived
tab_h = bridge_width;                   // tabs run the full bridge length
tab_center_x = gap_x / 2 + tab_w / 2;   // tab butts flush against the bridge end
bridge_len_x = gap_x;                   // X length of the bridge bar

$fn = 48;

module tab() {
  translate([-tab_w / 2, -tab_h / 2, 0])
    cube([tab_w, tab_h, tab_thickness]);
}

module bridge() {
  // Cross-section (Y-Z) is a half-ellipse: flat bottom, arched top like a
  // bridge, peaking at bridge_thickness in the middle.
  r = bridge_width / 2;

  scale([1, 1, bridge_thickness / r])
    intersection() {
      rotate([0, 90, 0])
        cylinder(h = bridge_len_x, r = r, center = true);

      // Keep only the top half (z >= 0) so the bottom stays flat.
      translate([0, 0, r])
        cube([bridge_len_x + 1, bridge_width, 2 * r], center = true);
    }
}

module plate() {
  union() {
    for (sx = [-1, 1])
      translate([sx * tab_center_x, 0, 0])
        tab();

    bridge();
  }
}

// Render selector: "all" for the full plate, "bridge" to test just the bridge.
part = "all";

if (part == "bridge") bridge();
else plate();
