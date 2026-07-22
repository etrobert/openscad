// Acorn earring — front piece, two parts, both printed flat:
// - disc: Ø6.5 pastille, visible face up, glue groove in the back face
// - C-hook: wraps under the lobe front-to-back; its end thins into a tab
//   that glues into the disc's groove; the 6×2mm magnet glued over the
//   back face sandwiches the tab and locks the joint
// Assembly puts the C's mid-plane exactly through the disc center.
// Worn: bare magnet behind the lobe; the C opening sits at the top of the
// rear branch, behind the back magnet, where the chain's ring slides on/off.
// Print in skin-color PLA; paint the C metallic before assembly.

$fa = 4;
$fs = 0.25;

magnet_h = 2;

disc_d = 6.5;
disc_h = 1.2;
chamfer = 0.2;

groove_w = 2.2; // tab height (ring_t) + 0.1 play per side
groove_depth = 0.6;
tab_t = 0.55; // groove_depth minus a glue film
tab_len = 3;

lobe = 6; // front-to-back lobe thickness, pinched
back_magnet_h = 2;

ring_id = 14; // clears disc_h + magnet_h + lobe + back_magnet_h + slack
ring_w = 1.8; // radial
ring_t = 2.0; // across (print height)
corner_r = 0.5;

// C in worn side-view coords: x from the disc back face (front face -1.2),
// y vertical. Rear inner edge lands 3.6 behind the back magnet; the tip
// (35°) leaves ~2.3mm behind it for the chain ring to slide through.
arc_start = 162; // wire ends just below the disc rim, clear of disc and magnet
arc_sweep = 233;
cx = 6.56;
cy = -6;

module c_hook() {
  translate(v=[cx, cy, 0])
    rotate(a=[0, 0, arc_start])
      rotate_extrude(angle=arc_sweep)
        translate(v=[ring_id / 2 + corner_r, corner_r])
          offset(r=corner_r)
            square(size=[ring_w - 2 * corner_r, ring_t - 2 * corner_r]);

  translate(v=[-1.2, -3.9, 0]) // connector: swallows the wire end below the rim
    cube(size=[1.15, 0.65, ring_t]);

  translate(v=[-groove_depth, -disc_d / 2, 0]) // tab, up the disc's diameter
    cube(size=[tab_t, tab_len, ring_t]);
}

// flat, back face on the plate so the groove faces down
module disc() {
  difference() {
    union() {
      cylinder(h=disc_h - chamfer, d=disc_d);
      translate(v=[0, 0, disc_h - chamfer])
        cylinder(h=chamfer, d1=disc_d, d2=disc_d - 2 * chamfer);
    }
    translate(v=[-groove_w / 2, -disc_d / 2 - 0.1, -0.1])
      cube(size=[groove_w, tab_len + 0.25, groove_depth + 0.1]);
  }
}

show_parts = true; // assembly-preview harness includes this file and disables it

if (show_parts) {
  c_hook();
  translate(v=[-7, -10, 0]) disc();
}
