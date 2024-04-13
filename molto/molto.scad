$fn = 50;

use <../rpi.scad>;
use <../screens.scad>;
use <../hinge.scad>;

show_base=true;
show_cap=true;

module __Customizer_Limit__ () {}

slop = 0.01;
slop2 = 0.02;
base_height=52;
floor_height=2;
corner_radius=2;
p_top = 14;
usb_hub = [114,26,47];
usb_hub_overhang = 14;
usb_drive=[116,22,74];
cpu_bay=[86, 65, 26];
cpu_bay_height=12;
wall_thickness=3.0;
base_depth=usb_drive.y*2 + wall_thickness*3 + cpu_bay.y;
hinge_rotate=58;
cover_offset=[-60, 103, 20];
front_tray_width=164;
front_tray_offset=12;
front_tray_front=95;
front_tray_back=56;
tray_wall_width=6;
far_back_wall = -usb_hub.y - corner_radius;
base_width=front_tray_width - 2*front_tray_offset;
excess = 2*wall_thickness;

module case() {
  if (show_base) {
    chomp_stand();
    if (show_cap) {
      embedded_chomp_display();
    }
  }
  else if (show_cap) {
    chomp_display();
  }
}

module embedded_chomp_display(){
  translate(cover_offset)
    rotate([-hinge_rotate,0,0])
      rotate([180,0,0])
        translate([0, -0, -0]) 
          chomp_display();
}

module chomp_display() {
  rotate([180,0,0])
    color("lightblue") {
      rotate([hinge_rotate,0,0])
        difference() {
          union() {
            translate([60, -97, 0]) {
              linear_extrude(86)
                difference() {      
                  display_shell();
              
                  offset(-3)
                    display_shell();
                }
                translate([0, 0, 86])
                  linear_extrude(4)
                    display_shell();
            }
          }
          rotate([-hinge_rotate,0,0])
            translate([-46, -88, -14])
              display_cutouts();
              step_shapes();
         
        }
      
      translate([-26, -109, -8]) {
        intersection() {      
          translate([-10, 114, 13])
            rotate([180,0,0])
              five_inch_touchscreen(frame_top=0, frame_bottom=3, frame_front=30, frame_back=20, frame_right=35, frame_left=35);
            
          rotate([hinge_rotate,0,0])
            translate([86, -32, -88])
              linear_extrude(90)
                display_shell();

        }
      }
    }
}



module display_cutouts() {
            rotate([-0,0,0]) {
            translate([-26, -30, 17])
              cube([222, 177, 80]);
          }

}


module display_shell() {
     union() {
       front_floor_shape();
        translate([0, -6, 88])
          base_part();
     }
}

module display_shell_cutout() {
  union() {
    translate([0, 0 - slop, 0 - slop])
      front_floor_cutout(100);
    
    translate([0, -6, 88])
      offset(-3)
        linear_extrude(44)
          base_part();
  }
}




module chomp_stand()
{
  union() {
    difference() {
      union() {
        base();

        translate([0, tray_wall_width, 0])
          front_floor();
        translate([-usb_drive.x/2 + 3, 0, 1])
          processor();
        translate([-usb_drive.x/2 + 10, 1, 1])
          usb_hd_bay();
        
        translate([-usb_drive.x/2 + 11, -usb_drive.y - 3*wall_thickness, 0]) {
          usb_hub_bay();
        }
      }
 //side panel punchout
      translate([-usb_drive.x/2 + 6, 0, 0]) {
        translate([-30, -28, floor_height + wall_thickness + 6])
          cube([16, 17, 90]);
      }

      translate([-usb_drive.x/2 + 6, 0, 0]) {
        back_panel_punchout();
      }
      step_shapes();
    }
  }
}

module case_floor() {
  union() {
    difference() {
      front_floor_piece(90);
      translate([0, 0 - slop, 0 - slop])
        front_floor_cutout(100);
    }
  }
}

module front_floor() {
  union() {
    difference() {
      front_floor_piece(20);
      translate([0, 0 - slop, floor_height])
        front_floor_cutout(22);
    }
  }
}

module front_floor_piece(r) {
  linear_extrude(r)
    hull() {
      translate([-front_tray_width/2, front_tray_front, 0])
      circle(r=6);

      translate([-front_tray_width/2 + front_tray_offset - 3, front_tray_back, 0])
      square(6, true);

      translate([front_tray_width/2, front_tray_front, 0])
      circle(r=6);

      translate([front_tray_width/2 - front_tray_offset + 3, front_tray_back, 0])
      square(6, true);

    }
}
module front_floor_shape() {
    hull() {
      translate([-front_tray_width/2, front_tray_front, 0])
      circle(r=6);

      translate([-front_tray_width/2 + front_tray_offset - 3, front_tray_back, 0])
      square(6, true);

      translate([front_tray_width/2, front_tray_front, 0])
      circle(r=6);

      translate([front_tray_width/2 - front_tray_offset + 3, front_tray_back, 0])
      square(6, true);

    }
}

module front_floor_cutout(r) {
  linear_extrude(r)
    hull() {
      translate([-front_tray_width/2, front_tray_front, 0])      
        circle(r=3);

      translate([-front_tray_width/2 + front_tray_offset, front_tray_back, 0])
        square(6, true);

      translate([front_tray_width/2, front_tray_front, 0])
        circle(r=3);

      translate([front_tray_width/2 - front_tray_offset, front_tray_back, 0]) 
        square(6, true);

    }
}

module base() {
  linear_extrude(floor_height)
    base_part();
  difference() {
    linear_extrude(52)
      difference() {
        base_part();
        offset(-3) base_part();
      }
      
  //front punchout
  translate([-73, 50 + slop, 0])
    cube([146, 20 + slop, 60]);
  }
}

module base_part()
{
  hull() {
    translate([-base_width/2, far_back_wall, 0]) 
      circle(r=6);
    translate([base_width/2, far_back_wall, 0]) 
      circle(r=6);
    translate([-base_width/2 - 3, front_tray_back, 0])
      square(6, true);
    translate([base_width/2 + 3, front_tray_back, 0])
      square(6, true);
  }
}

module processor(){
  rotate([-90,180,0])
    translate([-128 , 0, usb_drive.y])
        rpi4( padding_top = p_top,
          padding_front = 2 + slop,
          padding_back = 24,
          padding_bottom = 8,
          padding_left = 6,
          padding_right = 9,
          buffer_top = 0,
          buffer_back = 0,
          buffer_right = 0,
          buffer_bottom = wall_thickness,
          buffer_front = 0,
          buffer_left=0,
          expose_usb1=false,
          expose_usb2=false,
          expose_ethernet=false,
          expose_hdmi1=false,
          expose_hdmi2=false,
          expose_power=false,
          expose_audio=false
        );
}

module usb_hd_bay()
{
  color("white")
    translate([1, -4, floor_height - 1])
      difference() {
        cube([usb_drive.x + excess, usb_drive.y + excess, 46]);
        translate([wall_thickness, wall_thickness, 0])
          cube(usb_drive);
      
        // side cutout
        translate([-6, 12, floor_height + 20])
          cube([16, 10, 90]);
      }
}

module usb_hub_bay() {
  color("blue")
    translate([0, -1, floor_height - 1]) {
      difference() {
        cube([usb_hub.x + excess + 1, usb_hub.y + excess, 46]);
        translate([wall_thickness, wall_thickness, 0])
          cube(usb_hub + [0, 0, 100]);

    //    side cutout
        translate([-10, 6, floor_height + wall_thickness - 2])
          cube([16, 17, 90]);
      }
    }
}

module back_panel_punchout() {
  translate([2, -34, slop])
    translate([8, -10, floor_height + wall_thickness - 2])
      cube([98, 22, 60]);
}

module step_shapes() {
   //side panel punchout
      translate([-usb_drive.x/2 + 6, 0, 0]) {
          translate([-30, 26, 36])
            cube([16, 34, 30]);
      }

      translate([usb_drive.x/2 + 40, 0, 0]) {
          translate([-30, 26, 36])
            cube([16, 34, 30]);
      }

}
case();









