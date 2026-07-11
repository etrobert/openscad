// Penis figurine (mini-pe.stl) as a rigid magnetic stud, full scale.
// The model's existing Ø4.3 bore in the base is widened into a magnet
// pocket opening at the base (skin side). Print standing as designed, no
// pause — press the magnet in flush afterwards with a dot of glue. The
// worn magnet sits directly on skin; the bare back magnet goes behind
// the lobe as usual.

$fa = 4;
$fs = 0.25;

magnet_d = 6;
magnet_h = 2;
clearance = 0.2; // verified snug with tolerance-test-magnet
bore_center = [0.26, 6.68]; // existing hole in the base, measured from the mesh

difference() {
  import("mini-pe.stl");
  translate(v=[bore_center.x, bore_center.y, -1])
    cylinder(h=magnet_h + 1, d=magnet_d + clearance);
}
