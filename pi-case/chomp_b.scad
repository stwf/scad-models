use <../rpi.scad>;

expose_card=false;
expose_hdmi=false;
expose_usb1=true;
expose_usb2=false;
expose_ribbon_cable=false;
expose_gpio_pins=false;


module __Customizer_Limit__ () {}

base_width=116;
base_depth=140;
base_height=60;
drive_height=30;
floor_height=2;
corner_radius=3;
slop = 0.01;
post_height=18;

module chomp_stand()
{
  difference()
  {
    base();
    hd_bays();
    cpu_bay();
    cutaways();
    usb_hub_bay();
  }
  screw_posts();
}

module usb_hub_bay()
{

  translate([2, -28, floor_height])

  cube([112,46,24]);

  
}

module cutaways()
{

    translate([  -4, 24, drive_height])
    linear_extrude(base_height-drive_height + floor_height)
    square([123 + slop, 24+slop]);

    translate([  -4, 48 - slop, post_height + floor_height])
    linear_extrude(base_height-post_height + floor_height)
    square([134,220]);


}

module screw_posts()
{
  translate([16, 52, floor_height])
  screw_post();

  translate([16, 118, floor_height])
  rotate(180)
  screw_post();

    translate([102, 63, floor_height])
    rotate(180)
    screw_post();

    translate([102, 109, floor_height])
    screw_post();
  
  translate([98, 65, floor_height])
  linear_extrude(18)
  square([8,42]);

}

module screw_post()
{
    linear_extrude(18)
  difference()
  {
    union()
  {
    circle(4);
    translate([-4, -4])
   square([8,4]);
  }
    circle(1.2);
}
}

module cpu_bay()
{
    translate([-corner_radius - slop + 23, 48, floor_height])
    linear_extrude(60)
    square([83, 92]);

    translate([-corner_radius - slop + 14, 48, floor_height])
    linear_extrude(60)
    square([9 + slop, 74]);
}

module base()
{
    linear_extrude(base_height)
    {
      hull() {
        circle(corner_radius);
        translate([base_width,0]) circle(corner_radius);
        translate([0,45]) circle(corner_radius);
        translate([base_width,45]) circle(corner_radius);
      }
      hull() {
        translate([12,46]) square(corner_radius);
        translate([base_width - 13,46]) square(corner_radius);
        translate([15,base_depth]) circle(corner_radius);
        translate([base_width - 13, base_depth]) circle(corner_radius);
      }
    }
    linear_extrude(floor_height*3)
    {
      hull() {
        translate([0,0]) square(corner_radius);
        translate([base_width - 3,0]) square(corner_radius);
        translate([3,-27]) circle(corner_radius);
        translate([base_width - 3, -27]) circle(corner_radius);
      }
    }
}

module hd_bays()
{
    translate([0, 0, floor_height + 30])
    linear_extrude(60)
    square([116,22]);

    translate([0, 24, floor_height])
    linear_extrude(60)
    square([116,22]);

}

chomp_stand();