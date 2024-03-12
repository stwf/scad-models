use <../rpi.scad>;
use <../screens.scad>;


$fn = 50;
show_caddy=false;

module __Customizer_Limit__ () {}
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
usb_hub_overhang = 18;
usb_drive=[116,22,74];
cpu_bay=[86, 65, 26];
cpu_bay_height=12;
wall_thickness=2.0;
base_depth=usb_drive.y*2 + wall_thickness*3 + cpu_bay.y;

module chomp_stand()
{
  difference()
  {
    union() {
      chomp_base();
      translate([-31, 102, 13])
        rotate([115,0,0])
          5_inch_touchscreen(frame_top=3);
      base();
      translate([-31, 54, 0])
        cube([160, 48, 2]);
      translate([-31, 89, 0])
        cube([160, 8, 22]);
    }
    hd_bays();
    cutaways();
    usb_hub_bay();
    
    translate([-31 - slop, 97, 0])
        cube([160 + 2slop, 8, 40]);

  }
}

module rpi_cable_bay() {
  translate([30, 24, 3])
  cube([60, 16 + slop + p_top, 10]);
}

module chomp_base()
{
  rotate([-90,180,0])
    translate([-99, 0, usb_hub.z + 2])
        rpi4( padding_top = p_top,
          padding_front = 6,
          padding_back = 24,
          padding_bottom = 4,
          padding_left = 4,
          buffer_top = 0,
          buffer_back = 2,
          buffer_bottom = 2,
          buffer_front = 8,
          buffer_left=6,
          expose_hdmi1=false,
          expose_hdmi2=false,
          expose_power=false,
          expose_audio=false
        );

}

module usb_hub_bay()
{
  translate([(base_width - usb_hub.x) / 2, usb_hub_overhang - usb_hub.y, floor_height])

  cube(usb_hub);
}

module cutaways()
{  
  rotate([0,90,0])
    translate([-16, 4, -2 - slop])
      linear_extrude(4 + 2slop)
        union() {
          circle(10);
          translate([-9.9, -6.4, -2- slop])
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
    linear_extrude(base_height)
    {
      hull() {
        circle(corner_radius);
        translate([base_width,0]) circle(corner_radius);
        translate([0,usb_drive.y + wall_thickness]) circle(corner_radius);
        translate([base_width, usb_drive.y + wall_thickness]) circle(corner_radius);
      }
    }
    linear_extrude(floor_height*3)
    {
      hull() {
        translate([0,0]) square(corner_radius);
        translate([base_width - 3,0]) square(corner_radius);
        translate([3,-28]) circle(corner_radius);
        translate([base_width - 3, -28]) circle(corner_radius);
      }
    }
}

module hd_bays()
{
    translate([0, 0, floor_height + usb_hub.z + wall_thickness])
    cube(usb_drive);

}


chomp_stand();









