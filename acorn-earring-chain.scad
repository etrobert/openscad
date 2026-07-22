// Acorn earring — chain: print-in-place flat chain with an oak acorn pendant.
// [big ring] — [links] — [stem loop] — [acorn], printed in one piece.
// The big ring (Ø5 bore) slides onto the C of acorn-earring-hook.scad.
// Interlock: half-lap steps — where two links cross, one wire runs in the
// top half and the other in the bottom half, with gap_z between them.
// Print any decorative color, 0.12mm layers; the steps free themselves on
// the first flex.

$fa = 4;
$fs = 0.25;

t = 2.2; // full link height
gap_z = 0.5; // vertical clearance at crossings
half_t = (t - gap_z) / 2;

w = 1.5; // link wire width
slot_r = 1.25; // half slot width: mating wire + 0.5 clearance per side
slot_l = 3.5; // distance between cap centers
cap_d = 2.0; // engagement distance between facing cap centers
pitch = slot_l + cap_d;
ext = 1.2; // step zones reach this far past the cap centers into the rails

n_links = 2;

ring_ir = 2.5; // bore that slides on the C (1.8×2 section)
ring_w = 1.5; // must thread the links' 2.5-wide slot with 0.5 play per side
ring_d = 3.25; // ring center to first link's head cap center

c1 = ring_d + slot_l / 2; // first link center
loop_cx = c1 + (n_links - 1) * pitch + slot_l / 2 + cap_d; // stem loop center

module slot2d(l) {
  hull() for (s = [-1, 1]) translate(v=[s * l / 2, 0]) circle(r=slot_r);
}

module link2d() {
  difference() {
    offset(r=w) slot2d(slot_l);
    slot2d(slot_l);
  }
}

module ring2d(ir, wr) {
  difference() {
    circle(r=ir + wr);
    circle(r=ir);
  }
}

y_tip = 0.3; // full-height band at the cap tips: joins the two half-height sides

// tail rule for x > zx: y>0 keeps the top half, y<0 keeps the bottom half
module tail_cut(zx) {
  translate(v=[zx, y_tip, -1]) cube(size=[30, 30, 1 + t - half_t]);
  translate(v=[zx, -30 - y_tip, half_t]) cube(size=[30, 30, 30]);
}

// head rule for x < zx: mirrored — y>0 keeps bottom, y<0 keeps top
module head_cut(zx) {
  translate(v=[zx - 30, y_tip, half_t]) cube(size=[30, 30, 30]);
  translate(v=[zx - 30, -30 - y_tip, -1]) cube(size=[30, 30, 1 + t - half_t]);
}

module link(c) {
  difference() {
    translate(v=[c, 0, 0]) linear_extrude(height=t) link2d();
    tail_cut(c + slot_l / 2 - ext);
    head_cut(c - slot_l / 2 + ext);
  }
}

module big_ring() {
  difference() {
    linear_extrude(height=t) ring2d(ring_ir, ring_w);
    tail_cut(0.9);
  }
}

module stem_loop() {
  difference() {
    translate(v=[loop_cx, 0, 0]) linear_extrude(height=t) ring2d(slot_r, w);
    head_cut(loop_cx + 1.1);
  }
}

// acorn lying on its side, axis along x, stem toward the loop
acorn_z = 3.2; // axis height: cupule r3.6 minus a 0.4 flat trimmed on the bed
acorn_x = loop_cx + 4.2;

module acorn() {
  hull() { // stem, rising from the loop to the acorn axis
    translate(v=[loop_cx + 2.2, 0, t / 2]) sphere(d=1.8);
    translate(v=[acorn_x + 1.4, 0, acorn_z]) sphere(d=1.8);
  }
  translate(v=[acorn_x + 1.8, 0, acorn_z]) scale(v=[0.9, 1, 1]) sphere(r=3.6); // cupule
  translate(v=[acorn_x + 4.2, 0, acorn_z]) scale(v=[1.35, 1, 1]) sphere(r=3.3); // nut
  translate(v=[acorn_x + 8.5, 0, acorn_z]) sphere(r=0.9); // tip
}

show_chain = true; // clearance-check harness includes this file and disables it

if (show_chain) difference() {
  union() {
    big_ring();
    for (i = [0:n_links - 1]) link(c1 + i * pitch);
    stem_loop();
    acorn();
  }
  translate(v=[0, 0, -50]) cube(size=100, center=true); // trim below the plate
}
