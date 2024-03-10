slop=0.01;
2slop=0.02;



module draw_screen() {

  difference() {
    cube([160, 100, 8]);
    translate([23, 11, -slop])
      cube([124, 78, 8 + 2slop]);
    
    translate([29, 8, 2]) {
      cylinder(r = 1.25, h = 6);
       
      translate([113, 0, 0])
        cylinder(r = 1.25, h = 6);
    
      translate([113, 85, 0])
        cylinder(r = 1.25, h = 6);
    
      translate([0, 85, 0])
        cylinder(r = 1.25, h = 9);
      }
  }
}