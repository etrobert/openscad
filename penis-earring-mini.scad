// Small penis stud — penis.stl scaled to 0.67 (~13.4×17.4×23.4mm), the
// smallest size whose base walls survive the Ø6.2 magnet pocket (at 0.6
// the pocket broke through the sides). Print standing, no pause — press
// the magnet in flush afterwards with a dot of glue.

$fa = 4;
$fs = 0.25;

magnet_d = 6;
magnet_h = 2;
clearance = 0.2; // verified snug with tolerance-test-magnet

model_scale = 0.67;
model_offset = [-126.16, -133.73, 0]; // center the base outline on the origin
bore = model_scale * [-0.04, -4.93]; // existing bore center after offset and scale

difference() {
  scale(v=model_scale)
    translate(v=model_offset) import("penis.stl");
  translate(v=[bore.x, bore.y, -1])
    cylinder(h=magnet_h + 1, d=magnet_d + clearance);
}
