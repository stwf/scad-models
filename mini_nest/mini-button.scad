use <../rpi.scad>;
use <../hinge.scad>;
include <BOSL2/std.scad>
include <BOSL2/joiners.scad>
include <BOSL2/screws.scad>

$slop = 1;
show_base = true;
show_cap = true;
show_face = false;
cap_rotate_angle = 0;

module __Customizer_Limit__ () {}

small_base_radius = 2;
big_base_radius = 4;


rpi0_screw_width = 58;
rpi0_screw_height = 23;

rpi0_width = 65;
rpi0_height = 20;
rpi0_buffer = 1;
bay_depth = 14;
base_thickness = 1.2;
bay_buffer = 3;
bay_start_h = 0;
bay_start_v = 0;

screw_diameter = 1.25;
screw_mount_dia = 3.5;
screw_mount_height = 5;

hinge_width = 8;
hinge_buffer = 1;
hinge_inset = 10;
hinge_1_height = 10;
hinge_1_offset = 49;
hinge_1_location = rpi0_height + rpi0_buffer*2 + bay_buffer*2 + bay_start_v*4+ 2;
hinge_2_location = -6;
base_length = rpi0_width + rpi0_buffer*2 + bay_buffer*2 + bay_start_h*2 - 2;

rpi_padding=[2,2,2];
rpi_buffer=[2,2,2];


union()
{
  if ( show_base )  {
    union() {
      difference() {
        rpi0(
          buffer_top=0,
          buffer_right=12,
          buffer_left=8,
          buffer_bottom=6,
          padding_left=1,
          padding_right=1,
          padding_bottom=9);

        translate([0, 20, 8])
          rotate([90,0,90])
            usb_panel();

        translate([83, 20, 25])
          half_joiner_clear();
      }

      translate([83, 20, 25])
        half_joiner(screwsize=3);
    }
    if ( show_cap ) {
      translate([0, 50, 42])
        rotate([-90,0,90])
          cap(hinge_2_location, hinge_1_height);
    }
  }
}

module rgb_button() {
  color("blue") {
    cylinder(1.5, d=22);
    translate([0, 0, 1.5])
      cylinder(4, d=17);
    translate([0, 0, 5.5])
      cylinder(24, d=24);
  }
}

module usb_panel()
{
  color("yellow") {
    linear_extrude(7)
      hull() {
      translate([-9, 0, 0])
        circle(d=8.25);
      translate([9, 0, 0])
        circle(d=8.25);
      translate([-6, -6, 0])
        square([12, 12]);
      }
  translate([10, 0, 7])
      rotate([180,0,0])
        screw_hole("m1x1",length=6,anchor=TOP, teardrop=true);
  translate([-10, 0, 7])
      rotate([180,0,0])
        screw_hole("m1x1",length=6,anchor=TOP, teardrop=true);


      linear_extrude(20)
        translate([-6, -6, 0])
          square([12, 12]);

      cylinder(35, d=7.5);
  }
}

// module front_plate()
// union()
// {
//   translate([0,0,2])
//   cylinder(h = 16, r = 1.75);
//   translate([0,0,58])
//   cylinder( h = 16, r = 1.75);
  
//   union()
//   {
//     hinges();
//   }
// }

module cap(hinge_2_location, hinge_1_height) {
    difference() {
      union() {
        difference() {
          cap_top();
          translate([6, 20, 0])
            rotate([0, -180, 0])
              half_joiner_clear();
        }
        translate([6, 20, 0])
          rotate([0, -180, 0])
            half_joiner2(screwsize=3);
        
        translate([46, 20, 10])
          rotate([0, -155, 90])
            cylinder(14, d=28, center=true);

      }
      translate([46, 24, 18])
        rotate([0, -155, 90])
          rgb_button();

      translate([14, 0, -10.5])
        cap_top();
    }
}

module cap_hinges(hinge_2_location, hinge_1_height)
union()
{

  hinge_arm(hinge_2_location, 61, 
    hinge_rise=hinge_1_height,
    base_height=5,
    hinge_width=8.8,
    axle_thickness=0.8,
    base_reach=2,
    height=0.0
  );

  hinge_arm(hinge_1_location, 61, 
    hinge_rise=hinge_1_height,
    base_height=5,
    hinge_width=8.8,
    axle_thickness=0.8,
    base_reach=2,
    height=0.0
  );


  // translate([0,-6, -1])
  // rotate([-90,180,90])
  // hinge(0, 12, hinge_rise=0, hinge_rise2 = 1.0, hinge2_reach=0);

}

module cap_top()
{
  cube([88, 42, 10.5]);
}


module hinge_axles()
{
  union()
  {
    translate([0, 0, hinge_1_height])
    union()
    {
      translate([hinge_1_offset + 3, hinge_2_location])
      rotate([90,0,90])
      cylinder(h = 14, r = 2.2);

      translate([4, hinge_2_location])
      rotate([90,0,90])
      cylinder(h = 14, r = 2.2);

    }
  }
}

module hinge_bays()
union()
{
  translate([6, -10])
  cube([hinge_width + hinge_buffer*2, hinge_inset, base_thickness + bay_depth]);

  translate([56,-10])
  cube([hinge_width + hinge_buffer*2, hinge_inset, base_thickness + bay_depth]);
}

// module screw_mount()
// difference()
// {
//   linear_extrude(screw_mount_height)
//   hull() {
//     mount_size = rpi0_buffer + screw_mount_dia;
//     circle(mount_size);
//     polygon([[-mount_size, mount_size], [-mount_size,-mount_size], [mount_size,-mount_size]]);
//   }
//   cylinder(r = screw_diameter, h = screw_mount_height + 1);
// }


// module gaps()
// union()
// {
//   union()
//   {
//     starts_at_h = bay_buffer + bay_start_h;
//     starts_at_v = bay_buffer + bay_start_v;
//     solo_usb_offset = 5;
    
//     front_gap_w = 56;
//     // usb side
//     translate([(rpi0_width/2 - front_gap_w/2) + starts_at_h, (starts_at_v - 4), base_thickness + screw_mount_height])
//     cube([front_gap_w, 6, bay_depth]);

//     // usb port gap
//     translate([starts_at_h + rpi0_width/2 - solo_usb_offset, -(starts_at_v + 5), base_thickness])
//     cube([20,20,bay_depth]);

//     // sd card slot
//     translate([starts_at_h - 9, rpi0_height/2 - 1, screw_mount_height])
//     cube([18,18,bay_depth]);
    
//     // ribbon cable
//     translate([(rpi0_width + bay_buffer*2 - 1),rpi0_height/2 - 3,  base_thickness])
//     cube([3,19,bay_depth]);
//   }
// }

// module hinge()
// union()
// {
//   linear_extrude(hinge_width)
//   difference()
//   {
//     hull()
//     {
//       circle(r = 4);
  
//       translate([4,-2,62])
//       square(1);
  
//       translate([9,-2,62])
//       square(1);

//       translate([9,3,62])
//       square(1);
//     } 
//     circle(r = 3);
//   }
// }

module bay()
union()
{
  bay_width = rpi0_width + rpi0_buffer*2 - small_base_radius*2;
  bay_height = rpi0_height + rpi0_buffer*2 - small_base_radius*2;
  
  translate([bay_buffer + bay_start_h, bay_buffer + bay_start_v, base_thickness])
  linear_extrude(bay_depth)
  hull() {
    circle(small_base_radius);
    translate([bay_width,0]) circle(small_base_radius);
    translate([bay_width,bay_height]) circle(small_base_radius);
    translate([0,bay_height]) circle(small_base_radius);
  }
}
  

module base()
union() {
  $fn=50;

  rotate([90, 0, 90])
  translate([0, small_base_radius, 0])
  linear_extrude(base_length)
  hull() {
    circle(2);
    translate([32,0]) circle(small_base_radius);
    translate([28,8]) circle(big_base_radius);
    translate([-6,8]) circle(big_base_radius);
  }
}