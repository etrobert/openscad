// Second boomerang from the designer's revised drawing (A42.svg), which has
// outline and detail strokes in one file: bird-boomerang-v2-outline.svg is
// the silhouette path, bird-boomerang-v2-details.svg the detail strokes
// (including the mirrored right-wing group), widened to ~1.4mm and potraced
// to filled shapes since OpenSCAD ignores SVG strokes. Both share the page
// coordinate frame, so alignment is exact by construction.
//
// Profile: flat bottom (printed on the plate), edges rounded with a
// quarter-circle profile via stacked print-layer-aligned insets. Symmetric
// cross-section — fidelity to the drawing over per-wing airfoils — so it
// suits either hand; expect gentler returns than a true airfoil.
//
// Exported rotated 45° so the 280mm span fits the 256mm A1 bed (211x213).

$fa = 5;
$fs = 0.5;

span = 280;
h = 3.5; // total thickness
edge_r = 3.5; // quarter-round edge radius
step = 0.24; // slab height, two 0.12mm print layers
groove_depth = 0.6;
bed_rot = 45;

// outline import bbox (probed via --summary): x 292.08..547.26, y 239.20..370.48
svg_center = [419.67, 304.84];
svg_width = 255.18;

k = span / svg_width;
px_per_unit = 4210 / 841.995; // details were rasterized at 4210px page width

module planform() {
  scale(v=k) translate(v=-svg_center)
    import(file="bird-boomerang-v2-outline.svg");
}

module detail_lines() {
  scale(v=k / px_per_unit) translate(v=-svg_center * px_per_unit)
    import(file="bird-boomerang-v2-details.svg");
}

function inset(z) = edge_r - sqrt(max(0, edge_r * edge_r - z * z));

module body() {
  for (i = [0:ceil(h / step) - 1]) {
    z0 = i * step;
    z1 = min(h, z0 + step);
    translate(v=[0, 0, z0]) linear_extrude(height=z1 - z0 + 0.001)
      offset(r=-inset(z1)) planform();
  }
}

// constant-depth engraving: the detail prism minus the lowered body is a
// groove_depth-thick skin following the top surface
module boomerang() {
  difference() {
    body();
    difference() {
      linear_extrude(height=h + 1) detail_lines();
      translate(v=[0, 0, -groove_depth]) body();
    }
  }
}

rotate(a=[0, 0, bed_rot]) boomerang();
