include <../rpi.scad>;
include <../hinge.scad>;
// include <../RPi4board-modded.scad>;

buffer = [4, 4, 8];
padding = [4,4,4];

module __Customizer_Limit__ () {}

tray();


translate([20, 103, 0])
  rotate([0, 0, 270])
    hinges();

translate([-20, 103, 28]) {
//  rotate([0, 90, 0])
  //  cylinder(r = 1, h =200);

    rotate([0, 0, 0])

  
    draw_screen();
}

translate([0, -80, 0]) {
  rpi4([4, 4, 4], [0, 0, 2]);

// translate([4, 61, 5])
//  rotate([0, 0, 270])
  // board_raspberrypi_4_model_b();

}








module hinges() {
    hinge(0, 12, hinge_rise=18, hinge_reach=4.3, axle_thickness=2, hinge_width=20, hinge_gap=1.2);

    hinge(0, 108, hinge_rise=18, hinge_reach=4.3, axle_thickness=2, hinge_width=20, hinge_gap=1.2);
}

module tray() {
  difference() {
    cube([170, 94, 28]);
    translate([4, 4, 4])
      cube([116, 80, 24 + slop]);
    translate([122, 4, 4])
      cube([44, 80, 24 + slop]);
    translate([119, 36, 4])
      cube([4, 20, 24 + slop]);
  }

}

module draw_screen() {
translate([20, 13.8, -28])
  difference() {
    cube([170, 100, 6]);
    translate([13, 11, 0])
      cube([124, 78, 6 + slop]);
    
    translate([19, 8, 2]) {
      cylinder(r = 1.25, h = 4);
       
      translate([113, 0, 0])
        cylinder(r = 1.25, h = 4);
    
      translate([113, 85, 0])
        cylinder(r = 1.25, h = 4);
    
      translate([0, 85, 0])
        cylinder(r = 1.25, h = 4);
  
      translate([135, 65, 0])
        cylinder(r = 7, h = 4);
    }
  }
}

















