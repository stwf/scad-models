include <../rpi.scad>;
include <../hinge.scad>;
include <../screens.scad>;
// include <../RPi4board-modded.scad>;

show_case = true;
show_lid = false;

module __Customizer_Limit__ () {}

p_back = 11;
p_front = 18;
b_back = 14;
b_front = 8;

pi4_width = 56;

if (show_case) {
  difference() {
  
    union(){
      translate([0, 70, 4 ]) {
      rotate([120, 0, 0])

translate([0, 13.8, -28])
      draw_screen();
      }
      difference() {
        rpi4( padding_top = 14,
          padding_front = p_front,
          padding_back = 0,
          padding_bottom = 4,
          padding_left = 64,
          buffer_top = 0,
          buffer_bottom = 30,
          buffer_front = b_front,
          buffer_left=6
        );

        front_heel();
      usb_disk();

      }
//      leg_stands();
    }

    cylinder_button();
  }
}
if (show_lid) {
  translate([0, 0, 36])
    rotate([0,0,0])
    cube([150, 34, 77]);
}

module usb_disk() {
  translate([4, 4, 2])
  cube([115, 80, 26 + slop]);
  translate([119, 30, 2])
  cube([45, 20, 26 + slop]);
}
module leg_stands() {
  rotate([0,90,0]){
    translate([-133, 34, 0])
      linear_extrude(6)
        polygon( points=[[0, 0], [80,0],[80,50]] );

    translate([-133, 34, 177])
      linear_extrude(3)
        polygon( points=[[0, 0], [80,0],[80,50]] );
  }
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

module cylinder_button() {
    translate([22, p_back + p_front + pi4_width + b_back - slop + 8, 44])
    rotate([90,0,0])
      linear_extrude(b_front + 2slop + 1)
        circle(d=14);

}

module front_heel() {
      translate([-slop, 79 - slop, 30])
      cube([220, b_front + 2slop, 30]);
}

module front_heel_old() {
      translate([-slop, 91, 38])
      rotate([0,90,0])
        linear_extrude(160)
          polygon( points=[[-2,2], [-2,0],[-11-slop,-6.3],[-11-slop,2]] );
}












