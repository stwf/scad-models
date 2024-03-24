use <../rpi.scad>;
use <../screens.scad>;
use <../hinge.scad>;

show_base=true;
show_cap=true;

module __Customizer_Limit__ () {}

$fn = 50;
slop = 0.01;
2slop = 0.02;
expose_card=false;
expose_hdmi=false;
expose_usb1=true;
expose_usb2=false;
expose_ribbon_cable=false;
expose_gpio_pins=false;

base_width=116;
base_height=56;
drive_height=30;
floor_height=2;
corner_radius=2;
post_height=18;
p_top = 14;
usb_hub = [112,47,24];
usb_hub_overhang = 14;
usb_drive=[116,22,74];
cpu_bay=[86, 65, 26];
cpu_bay_height=12;
wall_thickness=2.0;
base_depth=usb_drive.y*2 + wall_thickness*3 + cpu_bay.y;
hinge_rotate=60;
cover_offset=[-30, 101.2, 20];

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
      chomp_display(hinge_rotate);
}

module chomp_display(hinge_rotate) {
  color("blue"){
    difference() {
      union() {
        rotate([hinge_rotate,0,0])
          translate([30, -101.2, 0])
            case_floor();
        rotate([180,0,0]) {
          translate([0, 18, -8])
          5_inch_touchscreen(frame_top=0, frame_bottom=6, frame_front=10, frame_back=1);
        }
      }
        rotate([180,0,0]) {
          translate([0, 18, 0])
          5_inch_touchscreen(frame_top=0, frame_bottom=6, frame_front=10, frame_back=1);
        }
    }
  }
}

module chomp_stand()
{
  union() {
    difference() {
      union() {
        chomp_base();
        base();
        front_floor();
      }
      hd_bays();
      usb_hub_bay();
      cutaways();
    }
  }
}

module case_floor() {
  union() {
    difference() {
      front_floor_piece(116);
      translate([0, 0, 2])
        front_floor_cutout(116);

      translate([0, 0, 2])
        linear_extrude(16)
          translate([2, 40, 0])
            square([93,20]);
    }
  }
}

module front_floor() {
  union() {
    difference() {
      front_floor_piece(20);
      translate([0, 0, 2])
        front_floor_cutout(22);

      // translate([0, 0, 2])
      //   linear_extrude(20)
      //     translate([20, 40, 0])
      //       square([93,20]);
    }
  }
}

module front_floor_piece(r) {
  linear_extrude(r)
    hull() {
      translate([-20, 95, 0])
      circle(r=6);

      translate([102, 56, 0])
      square(6);

      translate([115, 95, 0])
      circle(r=6);

      translate([-11, 56, 0])
      square(6);
    }
}

module front_floor_cutout(r) {
  linear_extrude(r)
    hull() {
      translate([-20, 94, 0])
      circle(r=3);

      translate([99, 56, 0]) square(6);

      translate([115, 94, 0])
      circle(r=3);

      translate([-8, 56, 0]) square(6);
    }
}

module front_floor_old() {
        translate([-31, 54, 0])
        cube([160, 42, 2]);

}
module front_nose() {
    translate([-31 - slop, 97- slop, 0])
        cube([162 + 2slop, 8, 40]);
}

module rpi_cable_bay() {
  translate([30, 24, 3])
  cube([60, 16 + slop + p_top, 10]);
}

module chomp_base()
{
  rotate([-90,180,0])
    translate([-108, 0, usb_hub.z])
        rpi4( padding_top = p_top,
          padding_front = 2,
          padding_back = 24,
          padding_bottom = 8,
          padding_left = 26,
          buffer_top = 0,
          buffer_back = 2,
          buffer_bottom = 2,
          buffer_front = 0,
          buffer_left=3,
          expose_hdmi1=false,
          expose_hdmi2=false,
          expose_power=false,
          expose_audio=false
        );

}

module usb_hub_bay()
{
  translate([(base_width - usb_hub.x) / 2 - 12, usb_hub_overhang - usb_hub.y, floor_height])

  cube(usb_hub);
}

module cutaways()
{  
  rotate([0,90,0])
    translate([-16, 4, -12 - slop])
      linear_extrude(4 + 2slop)
        union() {
          circle(10);
          translate([-9.8, -8, - 6 - slop])
            square([19.8, 8.1]);
        }
}

module screw_posts()
{
  translate([4.5, 52])
  screw_post(true);

  translate([4.5, 101.2])
  screw_post(false);

  translate([62.4, 52])
  screw_post(true);

  translate([62.4, 101.2])
  rotate(90)
  screw_post(false);
}

module screw_post(sqr_it)
{
  linear_extrude(cpu_bay_height)
  difference()
  {
    union()
  {
    circle(4);
    if ( sqr_it ) {
      translate([-4, -4]) square([8,4]);
    }
  }
    circle(1.2);
}
}

module base()
{
    translate([-10, 0, 0])
    linear_extrude(base_height)
    {
      hull() {
        circle(corner_radius);
        translate([base_width,0]) circle(corner_radius);
        translate([0,usb_drive.y + wall_thickness]) circle(corner_radius);
        translate([base_width, usb_drive.y + wall_thickness]) circle(corner_radius);
      }
    }
    translate([-12, 0, 0])
    linear_extrude(floor_height*3)
    {
      hull() {
        translate([0,0]) square(corner_radius);
        translate([base_width - 3,0]) square(corner_radius);
        translate([3,-32]) circle(corner_radius);
        translate([base_width - 3, -32]) circle(corner_radius);
      }
    }
}

module hd_bays()
{
    translate([-10, 0, floor_height + usb_hub.z + wall_thickness])
    cube(usb_drive);

}


case();









