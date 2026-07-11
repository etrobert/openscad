// Penis figurine (penis.stl, 20×26×35mm) as a rigid magnetic stud.
// The model's base bore is Ø7.5 — wider than the magnet — so it gets
// plugged and a Ø6.2 pocket carved into the plug, opening at the base
// (skin side). Print standing as designed, no pause — press the magnet
// in flush afterwards with a dot of glue. The bare back magnet goes
// behind the lobe as usual.

$fa = 4;
$fs = 0.25;

magnet_d = 6;
magnet_h = 2;
clearance = 0.2; // verified snug with tolerance-test-magnet

model_offset = [-126.16, -133.73, 0]; // center the base outline on the origin
bore = [-0.04, -4.93]; // existing bore center after offset, Ø7.5 × ~11 deep

difference() {
  union() {
    translate(v=model_offset) import("penis.stl");
    translate(v=[bore.x, bore.y, 0])
      cylinder(h=12, d=8.2);
    // fill the oversized bore
  }
  translate(v=[bore.x, bore.y, -1])
    cylinder(h=magnet_h + 1, d=magnet_d + clearance);
}
