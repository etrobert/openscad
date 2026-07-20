// Returning boomerang from a friend's bird sketch (right-handed thrower,
// counterclockwise spin). Planform traced from the inked left wing of the
// sketch; the wing is duplicated in mirror across the head so the beak sits
// forward on the centerline. Wings sweep 45° back each side (~90° between
// them, matching the sketch's pencil right wing).
//
// Aero: flat bottom (printed on the plate), airfoil-shaped top. Leading
// edges alternate outline sides like a propeller — outer edge on the right
// wing, inner edge on the left — which is what makes a mirrored planform
// spin consistently. Feather slits from the sketch become shallow engraved
// grooves; tips are smoothed.
//
// The model is exported rotated 45° (wings along X and Y) so the 280mm span
// fits the 256mm A1 bed.

$fa = 4;
$fs = 0.4;

span_rot = 45; // bake L-orientation for bed fit; 0 for symmetric preview
planform_scale = 1.076; // traced planform is 260mm tip-to-tip; stretch to 280

// wing stations traced from the sketch, scaled to 280mm tip-to-tip:
// [x along spine, trailing edge y, leading edge y, max thickness]
stations = [
  [0, -23.6, 23.7, 5.7],
  [30, -22.0, 25.8, 5.4],
  [60, -22.8, 30.3, 5.0],
  [100, -24.7, 26.9, 4.4],
  [133, -17.3, 20.7, 3.9],
  [162, -9.0, 12.0, 3.4],
  [174, -4.5, 6.0, 3.0],
  [180, -1.8, 2.4, 2.6],
];

te_by_x = [for (s = stations) [s[0], s[1]]];
le_by_x = [for (s = stations) [s[0], s[2]]];
th_by_x = [for (s = stations) [s[0], s[3]]];

// airfoil in normalized coords, u: 0 = trailing edge, 1 = leading edge
airfoil = [
  [0, 0],
  [0.97, 0],
  [0.995, 0.15],
  [1, 0.45],
  [0.99, 0.75],
  [0.95, 0.95],
  [0.8, 1],
  [0.6, 0.85],
  [0.4, 0.62],
  [0.2, 0.38],
  [0, 0.16],
];

// top-surface height fraction by chord position, for placing engravings
top_by_u = [
  [0, 0.16], [0.2, 0.38], [0.4, 0.62], [0.6, 0.85],
  [0.8, 1], [0.95, 0.95], [1, 0.45],
];

function surf_z(x, y, nose_plus) =
  let (
    te = lookup(x, te_by_x),
    le = lookup(x, le_by_x),
    u = nose_plus ? (y - te) / (le - te) : (le - y) / (le - te)
  ) lookup(u, top_by_u) * lookup(x, th_by_x);

// thin cross-section plate at one station; nose_plus picks which outline
// edge gets the blunt leading edge
module plate(st, nose_plus) {
  te = st[1];
  le = st[2];
  h = st[3];
  pts = nose_plus
    ? [for (p = airfoil) [te + p[0] * (le - te), p[1] * h]]
    : [for (p = airfoil) [le - p[0] * (le - te), p[1] * h]];
  translate(v=[st[0], 0, 0]) rotate(a=[90, 0, 90])
    linear_extrude(height=0.2) polygon(points=pts);
}

module blade(nose_plus) {
  for (i = [0:len(stations) - 2])
    hull() {
      plate(stations[i], nose_plus);
      plate(stations[i + 1], nose_plus);
    }
  // smooth rounded tip in place of the sketch's feather slits
  hull() {
    plate(stations[len(stations) - 1], nose_plus);
    translate(v=[182.5, 0.3, 0]) cylinder(h=2.2, r=1.6);
  }
}

// engraved feather strokes, spine toward trailing edge, swept tipward
grooves = [
  [[25, 5], [42, -7], [60, -18]],
  [[60, 6], [78, -8], [95, -20]],
  [[95, 4], [112, -7], [126, -13]],
  [[128, 2], [141, -3], [152, -7]],
];

groove_r = 1.2;
groove_depth = 0.65;

module wing_grooves(nose_plus) {
  for (g = grooves)
    for (i = [0:len(g) - 2])
      hull()
        for (j = [i:i + 1])
          translate(v=[
            g[j][0], g[j][1],
            surf_z(g[j][0], g[j][1], nose_plus) + groove_r - groove_depth,
          ]) sphere(r=groove_r);
}

head_outline = [
  [0, 35], [5.6, 21], [12.5, 12.5], [16, 7.5], [17.5, -2.5], [12.5, -12.5],
  [0, -17.5], [-12.5, -12.5], [-17.5, -2.5], [-16, 7.5], [-12.5, 12.5],
  [-5.6, 21],
];

// dome rises above the wing-root crest so the head reads over the junction
module head() {
  hull() {
    linear_extrude(height=1) polygon(points=head_outline);
    translate(v=[0, 0, 6.2]) linear_extrude(height=0.6)
      offset(delta=-5) polygon(points=head_outline);
  }
}

module boomerang() {
  difference() {
    union() {
      head();
      rotate(a=[0, 0, -45]) blade(nose_plus=true); // right wing
      mirror(v=[1, 0, 0]) rotate(a=[0, 0, -45]) blade(nose_plus=false); // left
    }
    for (side = [-1, 1])
      translate(v=[side * 5.5, 15, 7.8]) sphere(r=1.8); // eyes
    rotate(a=[0, 0, -45]) wing_grooves(nose_plus=true);
    mirror(v=[1, 0, 0]) rotate(a=[0, 0, -45]) wing_grooves(nose_plus=false);
  }
}

rotate(a=[0, 0, span_rot]) scale(v=[planform_scale, planform_scale, 1])
  boomerang();
