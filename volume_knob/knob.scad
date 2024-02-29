show_base = true;
show_cap = true;
show_face = false;
cap_rotate_angle = 90;
face_rotate_angle = 0;

module __Customizer_Limit__ () {}

small_base_radius = 2;
big_base_radius = 4;


rpi0_screw_width = 58;
rpi0_screw_height = 23;

rpi0_width = 65;
rpi0_height = 30;
rpi0_buffer = 1;
bay_depth = 10;
base_thickness = 4;
bay_buffer = 2;
bay_start_h = 2;
bay_start_v = 4;

screw_diameter = 1.25;
screw_mount_dia = 3.5;
screw_mount_height = 5;

hinge_width = 8;
hinge_buffer = 1;
hinge_inset = 10;
hinge_1_height = 10;
hinge_1_offset = 49;
hinge_1_location = rpi0_height + rpi0_buffer*2 + bay_buffer*2 + bay_start_v*2 + 3;
hinge_2_location = -6;
base_length = rpi0_width + rpi0_buffer*2 + bay_buffer*2 + bay_start_h*2 - 2;




union()
{
  if ( show_base )
  {
    difference()
    {
      base();
      bay();
      gaps();
      hinge_bays();
     }
    rpi0();
    hinge_axles();
  }
  if ( show_cap )
  {
    translate([0, hinge_2_location, hinge_1_height])
    rotate([cap_rotate_angle,0,0])
    translate([0, -hinge_2_location, -hinge_1_height])
    cap();
  }

  if ( show_face )
  {
    translate([0, hinge_1_location, hinge_1_height])
    rotate([face_rotate_angle,0,0])
    translate([0, -hinge_1_location, -hinge_1_height])
    face();
  }

 // translate([-7,-75.5,8])
 // rotate([-90,90,0])
 // front_plate();
}



module front_plate()
union()
{
  translate([0,0,2])
  cylinder(h = 16, r = 1.75);
  translate([0,0,58])
  cylinder( h = 16, r = 1.75);
  
  union()
  {
    hinges();
  }
}


module face()
union()
{
    rotate([90, 90, 90])
    face_hinges();
    face_top();
}

module face_hinges()
union()
{
  translate([-10, 47, 57])
  hinge();

  translate([-10, 47, 7])
  hinge();

}

module face_top()
union()
{
  face_top_width = 80;
  translate([0,hinge_2_location + 57,0])
  cube([base_length, face_top_width, 5.5]);
}


module cap()
union()
{
    rotate([90, 90, 90])
    cap_hinges();
    cap_top();
}

module cap_hinges()
union()
{
  translate([-10,-5,65])
  rotate([180,0,0])
  hinge();

  translate([-10,-5,15])
  rotate([180,0,0])
  hinge();

}

module cap_top()
{
  cap_top_width = rpi0_height + bay_buffer*2 + bay_start_v*2;
  translate([0,hinge_2_location - 45,0])
  cube([base_length, cap_top_width, 5.5]);
}


module hinge_axles()
{
  union()
  {
    translate([0, 0, hinge_1_height])
    union()
    {

      translate([hinge_1_offset + 3, hinge_1_location])
      rotate([90,0,90])
      cylinder(h = 14, r = 2.2);

      translate([hinge_1_offset + 3, hinge_2_location])
      rotate([90,0,90])
      cylinder(h = 14, r = 2.2);

      translate([4, hinge_1_location])
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
  translate([6, 42])
  cube([hinge_width + hinge_buffer*2, hinge_inset, base_thickness + bay_depth]);

  translate([56,42])
  cube([hinge_width + hinge_buffer*2, hinge_inset, base_thickness + bay_depth]);


  translate([6, -10])
  cube([hinge_width + hinge_buffer*2, hinge_inset, base_thickness + bay_depth]);

  translate([56,-10])
  cube([hinge_width + hinge_buffer*2, hinge_inset, base_thickness + bay_depth]);
}

module screw_mount()
difference()
{
  linear_extrude(screw_mount_height)
  hull() {
    mount_size = rpi0_buffer + screw_mount_dia;
    circle(mount_size);
    polygon([[-mount_size, mount_size], [-mount_size,-mount_size], [mount_size,-mount_size]]);
  }
  cylinder(r = screw_diameter, h = screw_mount_height + 1);
}


module rpi0()
union()
{
  translate([rpi0_buffer,rpi0_buffer, base_thickness])
  union()
    {
    in_height = rpi0_screw_height;
    in_width = rpi0_screw_width;
    start_x = bay_buffer + bay_start_h + rpi0_buffer;
    start_y = bay_buffer + bay_start_v + rpi0_buffer;
      
    translate([start_x, start_y])
    rotate(0)
    screw_mount();

    translate([in_width + start_x, start_y])
    rotate(90)
    screw_mount();

    translate([start_x + in_width, start_y + in_height])
    rotate(180)
    screw_mount();

    translate([start_x, (in_height + start_y)])
    rotate(270)
    screw_mount();
  }
}

module gaps()
union()
{
  union()
  {
    starts_at_h = bay_buffer + bay_start_h;
    starts_at_v = bay_buffer + bay_start_v;
    solo_usb_offset = 5;
    
    front_gap_w = 56;
    // usb side
    translate([(rpi0_width/2 - front_gap_w/2) + starts_at_h, (starts_at_v - 4), base_thickness + screw_mount_height])
    cube([front_gap_w, 6, bay_depth]);

    // usb port gap
    translate([starts_at_h + rpi0_width/2 - solo_usb_offset, -(starts_at_v + 5), base_thickness])
    cube([20,20,bay_depth]);

    // sd card slot
    translate([starts_at_h - 9, rpi0_height/2 - 1, screw_mount_height])
    cube([18,18,bay_depth]);
    
    // ribbon cable
    translate([(rpi0_width + bay_buffer*2 - 1),rpi0_height/2 - 3,  base_thickness])
    cube([3,19,bay_depth]);
  }
}

module hinge()
union()
{
  linear_extrude(hinge_width)
  difference()
  {
    hull()
    {
      circle(r = 4);
  
      translate([4,-2,62])
      square(1);
  
      translate([9,-2,62])
      square(1);

      translate([9,3,62])
      square(1);
    } 
    circle(r = 3);
  }
}

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
    translate([42,0]) circle(small_base_radius);
    translate([48,8]) circle(big_base_radius);
    translate([-6,8]) circle(big_base_radius);
  }
}