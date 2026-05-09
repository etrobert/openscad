wall_thickness = 5;
height = 10;
outer_diameter = 55;
inner_diameter = outer_diameter - wall_thickness * 2;

difference() {
  cylinder(h=height, d=outer_diameter, center=true, $fn=128);
  cylinder(h=height + 1, d=inner_diameter, center=true, $fn=128);
}
