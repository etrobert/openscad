// Small penis stud — penis.stl at 0.6 scale (12×15.6×21mm, the size that
// fits the ear). At this scale the base is too narrow for the magnet: a
// small Ø8 collar around the pocket keeps it from breaking through the
// sides. Print standing, no pause — press the magnet in flush afterwards
// with a dot of glue.

$fa = 4;
$fs = 0.25;

magnet_d = 6;
magnet_h = 2;
clearance = 0.2; // verified snug with tolerance-test-magnet

model_offset = [-126.16, -133.73, 0]; // center the base outline on the origin
bore = 0.6 * [-0.04, -4.93]; // existing bore center after offset and scale

difference() {
  union() {
    scale(v=0.6)
      translate(v=model_offset) import("penis.stl");
    // collar around the pocket, chamfered into the body
    translate(v=[bore.x, bore.y, 0]) {
      cylinder(h=magnet_h, d=8);
      translate(v=[0, 0, magnet_h])
        cylinder(h=0.8, d1=8, d2=6.4);
    }
  }
  translate(v=[bore.x, bore.y, -1])
    cylinder(h=magnet_h + 1, d=magnet_d + clearance);
}
