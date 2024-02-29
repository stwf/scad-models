use <../rpi.scad>;


$fn = 50;
show_caddy=false;

module __Customizer_Limit__ () {}

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
slop = 0.01;
post_height=18;

usb_hub = [112,47,24];
usb_hub_overhang = 18;
usb_drive=[116,22,74];
cpu_bay=[86, 65, 26];
cpu_bay_height=12;
wall_thickness=2.0;
base_depth=usb_drive.y*2 + wall_thickness*3 + cpu_bay.y;

module chomp_stand()
{
  union()
  {
  difference()
  {
    base();
    hd_bays();
    cpu_bay();
    cutaways();
    usb_hub_bay();
  }
  chomp_base();
  }
}

module chomp_base()
{
    translate([25.5,48])
  linear_extrude(3)
  color("red")
  square([65.9,57.2]);
  
  translate([25,0])
    screw_posts();

}

module usb_hub_bay()
{
  translate([(base_width - usb_hub.x) / 2, usb_hub_overhang - usb_hub.y, floor_height])

  cube(usb_hub);
}

module cutaways()
{

    translate([0, usb_drive.y*2 + wall_thickness*2 + 20, floor_height])
    linear_extrude(20)
    square([12 + slop, 26]);
  
      rotate([0,90,0])
    translate([-16,4,-2- slop])
   linear_extrude(4 + slop + slop)
   circle(10);

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

module cpu_bay()
{
    translate([-corner_radius - slop + 14, 48, floor_height])
    cube(cpu_bay);
}

module base()
{
    linear_extrude(base_height)
    {
      hull() {
        circle(corner_radius);
        translate([base_width,0]) circle(corner_radius);
        translate([0,usb_drive.y*2 + wall_thickness]) circle(corner_radius);
        translate([base_width, usb_drive.y*2 + wall_thickness]) circle(corner_radius);
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

    translate([0, 24, floor_height])
    cube(usb_drive);
}

if (show_caddy) {
  color("blue")
  translate([74, 40, 8])
  rotate([270,180, 0])
  import("/Users/steve/Documents/scad models/chomp/chasis.STL");
}

chomp_stand();









