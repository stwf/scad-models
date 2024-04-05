use <../rpi.scad>;
use <../screens.scad>;
use <../hinge.scad>;

show_base=true;
show_cap=true;

module __Customizer_Limit__ () {}

$fn = 50;
slop = 0.01;
slop2 = 0.02;
expose_card=false;
expose_hdmi=false;
expose_usb1=true;
expose_usb2=false;
expose_ribbon_cable=false;
expose_gpio_pins=false;
base_height=52;
drive_height=30;
floor_height=2;
corner_radius=2;
post_height=18;
p_top = 14;
usb_hub = [114,47,26];
usb_hub_overhang = 14;
usb_drive=[116,22,74];
cpu_bay=[86, 65, 26];
cpu_bay_height=12;
wall_thickness=2.0;
base_depth=usb_drive.y*2 + wall_thickness*3 + cpu_bay.y;
hinge_rotate=58;
cover_offset=[-60, 103, 20];
front_tray_width=164;
front_tray_offset=12;
front_tray_front=95;
front_tray_back=56;
tray_wall_width=6;
far_back_wall = -usb_hub.y - 2*wall_thickness + 20;
base_width=front_tray_width - 2*front_tray_offset;
excess = 2*wall_thickness-corner_radius;

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
        chomp_display();
}

module chomp_display() {
  rotate([180,0,0])
  color("lightblue"){
    union() {
      difference() {
        rotate([hinge_rotate,0,0]) 
          translate([60, -97, 0]) {
            case_floor();
          translate([0, 0, 2])

          translate([0, -6, 86])
          linear_extrude(4)
              base_part();
              
          translate([0, -6, 30])
          linear_extrude(60)
            difference() {
              base_part();
              translate([0, 4, 2])
                offset(-3) base_part();
            }
          }
        // wall above frame
          rotate([180,0,0]) {
            translate([-46, -30, -68])
              cube([222, 177, 60]);
          }

        // rotate([180,0,0]) {
        //   translate([6, 20, -16])
        //   cube([122, 78, 20]);
        // }

      }
      
      rotate([180,0,0]) {
        translate([-26, 8, -8])
        five_inch_touchscreen(frame_top=0, frame_bottom=6, frame_front=10, frame_back=10, frame_right=25, frame_left=25);
      }

    }
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
        translate([-usb_drive.x/2 + 12, 0, 1]) {
          processor();
          usb_hd_bay();
          usb_hub();
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

      translate([-front_tray_width/2 + front_tray_offset, front_tray_back, 0])
      square(6, true);

      translate([front_tray_width/2, front_tray_front, 0])
      circle(r=6);

      translate([front_tray_width/2 - front_tray_offset, front_tray_back, 0])
      square(6, true);

    }
}

module front_floor_cutout(r) {
  linear_extrude(r)
    hull() {
      translate([-front_tray_width/2, front_tray_front, 0])      
      circle(r=3);

      translate([-front_tray_width/2 + front_tray_offset + 3, front_tray_back, 0])
            square(6, true);


      translate([front_tray_width/2, front_tray_front, 0])
      circle(r=3);

      translate([front_tray_width/2 - front_tray_offset - 3, front_tray_back, 0]) 
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
      translate([-70, 50, 0])
        cube([140, 20, 60]);
  }
}

module base_part()
{
      hull() {
        translate([-base_width/2, far_back_wall, 0]) 
          circle(6);
        translate([base_width/2 -3, far_back_wall, 0]) 
          circle(6);
        translate([-base_width/2, front_tray_back, 0])
      square(6, true);
        translate([base_width/2, front_tray_back, 0])
      square(6, true);
    }
  }

module rpi_cable_bay() {
  translate([30, 24, 3])
  cube([60, 16 + slop + p_top, 10]);
}

module processor()
{
  rotate([-90,180,0])
    translate([-116 , 0, usb_hub.z - 8])
        rpi4( padding_top = p_top,
          padding_front = 2 + slop,
          padding_back = 24,
          padding_bottom = 8,
          padding_left = 13,
          padding_right = 15,
          buffer_top = 0,
          buffer_back = 0,
          buffer_right = 0,
          buffer_bottom = 6,
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
  translate([-1, -4, floor_height])
  difference() {
  linear_extrude(46)
    usb_hd_bay_shape();

    translate([1, 0, 0])
      cube(usb_drive);
      // side cutout
      translate([-10, 6, floor_height + 20])
        cube([76, 10, 90]);
  }
}

module usb_hub() {
  translate([-3, -32, slop])
    union() {
    difference() {
      linear_extrude(base_height - 4)
      {
        hull() {
          square(corner_radius, true);
          translate([usb_hub.x + excess + 4, 0]) circle(corner_radius);
          translate([0, usb_hub.z + excess]) square(corner_radius, true);
          translate([usb_hub.x + excess + 4, usb_hub.z + excess]) circle(corner_radius);
        }
      }
      translate([4, 24, floor_height + wall_thickness - 3])
        rotate([90, 0, 0])
          cube(usb_hub + [0, 30, 0]);
      
    
      // side cutout
      translate([-10, 3, floor_height + wall_thickness - 2])
        cube([16, 17, 90]);
    }
    }
}

module back_panel_punchout() {
      // front cutout
   translate([2, -34, slop])
     translate([8, -10, floor_height + wall_thickness - 2])
        cube([98, 22, 60]);

}
module usb_hd_bay_shape() {
    hull() {
      circle(corner_radius);
      translate([usb_drive.x + excess, 0]) circle(corner_radius);
      translate([0, usb_drive.y + excess]) circle(corner_radius);
      translate([usb_drive.x + excess, usb_drive.y + excess]) circle(corner_radius);
    }

}


case();









