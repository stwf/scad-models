include <../rpi.scad>;
include <../hinge.scad>;
// include <../RPi4board-modded.scad>;

buffer = [4, 4, 8];
padding = [4,4,4];

module __Customizer_Limit__ () {}

// tray();


///translate([20, 103, 0])
 // rotate([0, 0, 270])
//    hinges();

difference() {
  union(){
    translate([0, 72, 3]) {
      rotate([120, 0, 0])
        draw_screen();
    }

    difference() {
      rpi4( padding_top=22,
        padding_front=0,
        padding_back=8,
        padding_bottom = 4,
        padding_left = 54,
        buffer_top = 0,
        buffer_back = 14,
        buffer_front = 8,
        buffer_left=6,
        expose_audio=false,
        expose_hdmi1=false,
        expose_hdmi2=false
      );
      translate([30, 2, 18])
        cube([114, 10, 24]);
    }
      rotate([0,90,0]){
        translate([-113, 34, 0])
        linear_extrude(6)
          polygon( points=[[0, 0], [80,0],[80,50]] );

        translate([-113, 34, 147])
        linear_extrude(3)
          polygon( points=[[0, 0], [80,0],[80,50]] );
      }

  }
  translate([-slop, 88, 26])
    rotate([0,90,0])
      linear_extrude(200)
          polygon( points=[[-2,2], [-2,0],[-11-slop,-3],[-11-slop,2]] );

  translate([22, 88 + slop, 19])
    rotate([90,0,0])
      linear_extrude(8 + 2slop)
        circle(d=12);
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
translate([0, 13.8, -28])
  difference() {
    cube([150, 100, 6]);
    translate([13, 11, -slop])
      cube([124, 78, 6 + 2slop]);
    
    translate([19, 8, 2]) {
      cylinder(r = 1.25, h = 4);
       
      translate([113, 0, 0])
        cylinder(r = 1.25, h = 4);
    
      translate([113, 85, 0])
        cylinder(r = 1.25, h = 4);
    
      translate([0, 85, 0])
        cylinder(r = 1.25, h = 4);
      }
  }
}

















