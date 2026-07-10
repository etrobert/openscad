// Pocket fit test for 6×2mm neodymium discs — find the clearance where the
// magnet presses in snugly by hand (for pause-capture inserts).
// One bar, five labeled pockets. Poke hole underneath each to push the
// magnet back out.

magnet_d = 6;
increment = 0.1;
labels = ["6.0", "6.1", "6.2", "6.3", "6.4"];

pitch = 12;
bar_w = 14; // room for pocket + label
bar_h = 3;
pocket_depth = 2.2;
engrave = 0.4;

difference() {
  cube([pitch * len(labels), bar_w, bar_h]);
  for (i = [0:len(labels) - 1]) {
    translate(v=[pitch / 2 + i * pitch, 0, 0]) {
      translate(v=[0, 5, bar_h - pocket_depth])
        cylinder(h=pocket_depth + 1, d=magnet_d + i * increment, $fn=64);
      translate(v=[0, 5, -1])
        cylinder(h=bar_h, d=3, $fn=32);
      translate(v=[0, 11.5, bar_h - engrave])
        linear_extrude(engrave + 1)
          text(labels[i], size=3, halign="center", valign="center");
    }
  }
}
