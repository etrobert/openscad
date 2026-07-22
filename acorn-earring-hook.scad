// Acorn earring — front piece: small disc + integral C-hook.
// Worn: disc on the front of the lobe, 6×2mm magnet GLUED on its back face
// (no pocket), bare magnet behind the lobe. The C wraps under the lobe
// front-to-back; opening at the top of the rear branch, behind the back
// magnet, where the chain's end ring slides on/off.
// Printed lying on its side: C flat on the plate, disc standing on edge
// (bottom trimmed flat for adhesion). Print in skin-color PLA; the C gets
// painted metallic.

$fa = 4;
$fs = 0.25;

magnet_h = 2;

disc_d = 6.5;
disc_h = 1.2;
chamfer = 0.2;
disc_drop = 0.25; // sink below the plate then trim: flat rim chord for adhesion

lobe = 6; // front-to-back lobe thickness, pinched
back_magnet_h = 2;

ring_id = 14; // clears disc_h + magnet_h + lobe + back_magnet_h + slack
ring_w = 1.8; // radial
ring_t = 2.0; // across (print height)
corner_r = 0.5;

arc_start = 155; // embeds into the disc's lower edge
arc_sweep = 240; // tip ends at 35°: ~2mm behind the back magnet plane

// C center relative to disc center, in the C's plane
ring_rm = ring_id / 2 + ring_w / 2;
cx = -disc_h / 2 - ring_rm * cos(arc_start);
cy = -6;

disc_z = disc_d / 2 - disc_drop;

// disc axis along x, body x in [-disc_h, 0], visible chamfered face at -disc_h
module disc() {
  translate(v=[-disc_h, 0, disc_z]) rotate(a=[0, 90, 0]) {
    cylinder(h=chamfer, d1=disc_d - 2 * chamfer, d2=disc_d);
    translate(v=[0, 0, chamfer]) cylinder(h=disc_h - chamfer, d=disc_d);
  }
}

module c_ring() {
  translate(v=[cx, cy, 0])
    rotate(a=[0, 0, arc_start])
      rotate_extrude(angle=arc_sweep)
        translate(v=[ring_id / 2 + corner_r, corner_r])
          offset(r=corner_r)
            square(size=[ring_w - 2 * corner_r, ring_t - 2 * corner_r]);
}

difference() {
  union() {
    disc();
    c_ring();
  }
  translate(v=[0, 0, -50]) cube(size=100, center=true); // trim below the plate
}
