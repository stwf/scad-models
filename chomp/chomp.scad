use <../rpi.scad>;

expose_card=false;
expose_hdmi=false;
expose_usb1=true;
expose_usb2=false;
expose_ribbon_cable=false;
expose_gpio_pins=false;


module __Customizer_Limit__ () {}

base_width=116;
base_depth=135;
base_height=30;
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
  }
  screw_posts();
}

module screw_posts()
{
    translate([8, 28, floor_height])
    screw_post();

    translate([8, 94, floor_height])
    rotate(180)
    screw_post();

    translate([4, 98, floor_height])
    linear_extrude(18)
   square([8,12]);

    translate([92.5, 38, floor_height])
    rotate(180)
    screw_post();

    translate([92.5, 84, floor_height])
    screw_post();
  
    translate([88.5, 40, floor_height])
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
    translate([-corner_radius - slop, 24, floor_height])
    linear_extrude(60)
    square([110, 86]);
}

module base()
{
    linear_extrude(base_height)
    {
      hull() {
        circle(corner_radius);
        translate([base_width,0]) circle(corner_radius);
        translate([0,base_depth]) circle(corner_radius);
        translate([base_width,base_depth]) circle(corner_radius);
      }
    }
}

module hd_bays()
{
    translate([0, 0, floor_height])
    linear_extrude(60)
    square([116,22]);

    translate([0, 112, floor_height])
    linear_extrude(60)
    square([116,22]);

}

chomp_stand();