// Boomerang from a friend's bird drawing. The silhouette is the designer's
// vector outline (bird-boomerang-outline.svg, the single path extracted from
// their Linearity Curve export); the surface detail (feathers, head, eyes)
// is bird-boomerang-details.svg, potraced from their line-art render with
// the border strokes masked off so only interior lines engrave.
//
// Profile: flat bottom (printed on the plate), edges rounded with a
// quarter-circle profile via stacked print-layer-aligned insets. Symmetric
// cross-section — fidelity to the drawing over per-wing airfoils — so it
// suits either hand; expect gentler returns than a true airfoil.
//
// Exported rotated 45° so the 280mm span fits the 256mm A1 bed (216x216).

$fa = 5;
$fs = 0.5;

span = 280;
h = 5; // total thickness
edge_r = 5; // quarter-round edge radius
step = 0.24; // slab height, two 0.12mm print layers
groove_depth = 0.6;
bed_rot = 45;

// measured bounding boxes of the two imports (probed via --summary):
// outline import: x 296.13..545.59, y 243.24..370.48
// silhouette of the details raster in import coords: x 293..1154, y 837..1276
svg_center = [420.86, 306.86];
svg_width = 249.46;
jpeg_center = [723.5, 1056.5];
jpeg_to_svg = 0.28977;

k = span / svg_width;

module planform() {
  scale(v=k) translate(v=-svg_center) import(file="bird-boomerang-outline.svg");
}

module detail_lines() {
  scale(v=k * jpeg_to_svg) translate(v=-jpeg_center)
    import(file="bird-boomerang-details.svg");
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
