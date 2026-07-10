// Pocket fit test for 6×2mm neodymium discs — find the clearance where the
// magnet presses in snugly by hand (for pause-capture inserts).
// Poke hole underneath to push the magnet back out.

magnet_d = 6;
magnet_h = 2;
increment = 0.1;

block = 10;
block_h = 3;
pocket_depth = magnet_h + 0.2;

for (i = [0:4]) {
  pocket_d = magnet_d + i * increment;
  translate(v=[i * (block + 2), 0, 0]) {
    difference() {
      cube([block, block, block_h]);
      translate(v=[block / 2, block / 2, block_h - pocket_depth])
        cylinder(h=pocket_depth + 1, d=pocket_d, $fn=64);
      translate(v=[block / 2, block / 2, -1])
        cylinder(h=block_h, d=3, $fn=32);
    }
  }
}
