production = false;
show_base = true;
show_cap = true;
show_face = true;
cap_rotate_angle = 0;
face_rotate_angle = 0;
cross_section = 0;


module __Customizer_Limit__ () {}

small_base_radius = 2;
big_base_radius = 3;
slop = 0.1;

rpi0_screw_width = 58;
rpi0_screw_height = 23;

rpi0_width = 65;
rpi0_height = 30;
rpi0_buffer = 1;
bay_depth = 9;
base_thickness = 2.4;
bay_buffer = 2;
bay_start = [2.4, 4];

screw_diameter = 1.25;
screw_mount_dia = 3.5;
screw_mount_height = 4;

hinge_inner_radius = 2.0;
hinge_outer_radius = 3.0;
hinge_rise = 7.6;
hinge_width = 8;
hinge_buffer = 1;
hinge_inset = 8.2;
hinge_1_height = base_thickness + hinge_rise - hinge_outer_radius/2;
hinge_1_offset = 60;
hinge_2_offset = 3;
axle_radius = 1.6;

face_hinge_location = rpi0_height + rpi0_buffer*2 + bay_buffer*2 + bay_start.x*2 + 3;
cap_hinge_location = -3;
base_length = rpi0_width + rpi0_buffer*2 + bay_buffer*2 + bay_start.x*2 - 2;
cap_height = 5.4;


face_top_width = 82;
opening_v_loc = 40;
opening_large_s = 24;
opening_large_r = 28;
face_height = 6;
face_inset_x = 56;
face_inset_y = 64;
face_inset_z = 3.84;

leg_height = 44;

intersection()
{
union()
{
  if ( show_base )
  {
    color("red")
    difference()
    {
      union()
      {
        difference()
        {
          base();
          bay();
          hinge_bays();
         }
        rpi0();
        hinge_axles();
      }
      gaps();
    }
  }

  if ( show_cap )
  {
    color("gray")
    translate([0, cap_hinge_location, hinge_1_height])
    rotate([cap_rotate_angle,0,0])
    translate([0, -cap_hinge_location, -hinge_1_height])
    cap();
  }

  if ( show_face )
  {
    color("green")
    translate([0, face_hinge_location, hinge_1_height])
    rotate([face_rotate_angle,0,0])
    translate([0, -face_hinge_location, -hinge_1_height])
    face();
  }

 // translate([-7,-75.5,8])
 // rotate([-90,90,0])
 // front_plate();
}
  if (cross_section != 0)
  {
    translate([-130,-130, 0])
      cube([260, 260, cross_section]); 
  }
}

module leg()
{
  linear_extrude(6)
  union()
  {
    polygon([
      [0, 0],
      [leg_height-23,18], 
      [0,leg_height - 1]
    ]);

    translate([leg_height-23,18])
    rotate([0,0,-140])
    square([2.4, 3.8]);

    translate([leg_height-21.2,16.1])
    circle(1.3);
  }
}


module legs()
{
  union()
  {
    translate([base_length, 53.2,face_height])
    rotate([0,-90,0])
    leg();

    translate([6, 52.8, face_height])
    rotate([0,-90,0])
    leg();
  }
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
    face_hinges();
    face_top();
      legs();

}


module face_hinges()
union()
{
    rotate([0, 90, 0])
  translate([-hinge_rise - 0.8, 43.8, hinge_1_offset + hinge_buffer])
  hinge_two();

     rotate([0, 90, 0])
 translate([-hinge_rise - 0.8, 43.8, hinge_2_offset + hinge_buffer])
  hinge_two();

}


module face_top()
union()
{
  difference()
  {
    bevel_length = 4;
    translate([0,face_hinge_location,0])
    cube([base_length, face_top_width, face_height]);
    
      
    translate([-1,face_hinge_location + bevel_length,face_height])
    rotate([0, 90, 0])
    linear_extrude(base_length + 8)
    polygon([
      [0 - slop, 0.6],
      [0 - slop, -bevel_length - slop],
      [bevel_length - slop + 2,-bevel_length - slop]
    ]);

    
    translate([base_length/2,cap_hinge_location + 52 + opening_v_loc,-slop])
    cylinder(face_height + 0.2, opening_large_r, opening_large_s);

    translate([base_length/2 - face_inset_x/2,cap_hinge_location + 52 + opening_v_loc - face_inset_y/2 - 2, face_height - face_inset_z])
    cube([56, 64, 3.84 + slop]);
  }
  translate([base_length/2 - face_inset_x/2, cap_hinge_location + 52 + opening_v_loc + 21, face_height - 0.8])
  linear_extrude(0.8)
  polygon([[0, 0], [9, 9], [0, 9]]);

  translate([base_length/2 + face_inset_x/2, cap_hinge_location + 52 + opening_v_loc + 21, face_height - 0.8])
  linear_extrude(0.8)
  polygon([[0, 0], [9, 9], [-9, 9]]);

}


module cap()
union()
{
    cap_hinges();
    cap_top();
}


module cap_hinges()
union()
{
  translate([hinge_1_offset + hinge_width + hinge_buffer, -3, hinge_rise + 1])
  rotate([180,90,0])
  hinge_one();

  translate([hinge_2_offset + hinge_width + hinge_buffer, -3, hinge_rise + 1])
  rotate([180,90,0])
  hinge_one();

}




module leg_snap()
{  
  rotate([0,90,0])
  linear_extrude(8)
  polygon([
    [2.4,2.2],
    [6.2,2.2], 
    [6.2,7], 
    [4.8,8], 
    [2.4,8]
  ]);
}



module cap_top()
{
  difference()
  {
    inset_cap = 3.6;
    cap_top_width = rpi0_height + bay_buffer*2 + bay_start.y*2 - 0.6;

    union()
    {
      translate([0,cap_hinge_location - cap_top_width])
      cube([base_length, cap_top_width, cap_height]);
      
      
      translate([0,cap_hinge_location - cap_top_width - 8])
      rotate([0,90,0])
      linear_extrude(base_length)
      polygon([
        [-5.4, 8],
        [-5.4, 5.6],
        [-4.2,4.6], 
        [0,8]
      ]);

    }
    translate([-7,cap_hinge_location])
    rotate([0, 90, 0])
    linear_extrude(base_length + 8 + slop)
    polygon([
      [0 + slop, 0 + slop],
      [0 + slop, 0 - inset_cap - 1],
      [-cap_height - slop, -inset_cap - slop],
      [-cap_height - slop, 1-slop]
    ]);

    translate([rpi0_width/2 +2, -10, -slop])
      cube([22, 6, cap_height + slop * 2]);


    translate([rpi0_width/2 - 14, -cap_top_width - 8, -slop])
      cube([38, 12, cap_height + slop * 2]);

    translate([base_length - 7.9,-23.4, 6])
    leg_snap();

    translate([-0.1,-23.4, 6])
    leg_snap();
  }
}



module hinge_axles()
{
  union()
  {
    translate([0, 0, hinge_1_height])
    union()
    {

      translate([hinge_1_offset, face_hinge_location])
      rotate([90,0,90])
      cylinder(h = 13, r = axle_radius);

      translate([hinge_1_offset, cap_hinge_location])
      rotate([90,0,90])
      cylinder(h = 13, r = axle_radius);

      translate([hinge_2_offset, face_hinge_location])
      rotate([90,0,90])
      cylinder(h = 13, r = axle_radius);

      translate([hinge_2_offset, cap_hinge_location])
      rotate([90,0,90])
      cylinder(h = 13, r = axle_radius);

    }
  }
}


module hinge_bays()
{
  union()
  {
    translate([hinge_2_offset, 39])
    cube([hinge_width + hinge_buffer*2, hinge_inset, base_thickness + bay_depth + slop]);

    translate([hinge_1_offset,39])
    cube([hinge_width + hinge_buffer*2, hinge_inset, base_thickness + bay_depth + slop]);


    translate([hinge_2_offset, -7])
    cube([hinge_width + hinge_buffer*2, hinge_inset, base_thickness + bay_depth + slop]);

    translate([hinge_1_offset, -7])
    cube([hinge_width + hinge_buffer*2, hinge_inset, base_thickness + bay_depth + slop]);
  }
}

module gaps()
union()
{
  union()
  {
    starts_at_h = bay_buffer + bay_start.x;
    starts_at_v = bay_buffer + bay_start.y;
    solo_usb_offset = 2;
    
    front_gap_w = 56;
    // usb side
    translate([(rpi0_width/2 - front_gap_w/2) + starts_at_h, (starts_at_v - 4), base_thickness + screw_mount_height])
    cube([front_gap_w, 6, bay_depth]);

    // usb port gap
    translate([starts_at_h + rpi0_width/2 - solo_usb_offset, -(starts_at_v + 5), base_thickness])
    cube([20,20,bay_depth +  + slop]);

    // sd card slot
    if (production)
    {
      translate([starts_at_h - 3 + slop, rpi0_height/2 - 2, base_thickness + screw_mount_height])
      cube([3 + slop, 18, 6]);
    }
    else
    {
      translate([starts_at_h - 7, rpi0_height/2 - 2, -base_thickness])
      cube([7.2,18,bay_depth + base_thickness*2 + slop]);
    }
    
    // ribbon cable
    translate([(rpi0_width + bay_buffer*2 - 1),rpi0_height/2 - 5,  base_thickness + screw_mount_height])
    cube([4,19,bay_depth]);
  }
}

module hinge_one()
union()
{
  linear_extrude(hinge_width)
  difference()
  {
    union()
    {
    hull()
    {
      circle(r = hinge_outer_radius);
    
      //       toe_back
      translate([hinge_rise - 1, -hinge_outer_radius + 2, 0])
      circle(2);
  
      //      toe front
      translate([hinge_rise - 1.4,1,0])
      square(2.4);
    } 
      translate([hinge_rise - 3.4,2.2,0])
      square(4.4);
  }
    circle(hinge_inner_radius);
  }
}


module hinge_two()
union()
{
  linear_extrude(hinge_width)
  difference()
  {
    hull()
    {
      circle(r = hinge_outer_radius);
    
      //       toe_back
      translate([hinge_rise - 0.2,4,62])
      square(1);
  
      //      toe front
      translate([hinge_rise-0.2,0,62])
      square(1);

      translate([hinge_rise,4,62])
      square(0.2);
    } 
    circle(hinge_inner_radius);
  }
}


module bay()
union()
{
  bay_width = rpi0_width + rpi0_buffer*2 - small_base_radius*2;
  bay_height = rpi0_height + rpi0_buffer*2 - small_base_radius*2;
  
  difference()
  {
    translate([bay_buffer + bay_start.x, bay_buffer + bay_start.y, base_thickness])
    linear_extrude(bay_depth + slop)
    hull() {
      translate([small_base_radius, 0]) circle(small_base_radius);
      translate([bay_width + small_base_radius,0]) circle(small_base_radius);
      translate([bay_width + small_base_radius,bay_height]) circle(small_base_radius);
      translate([small_base_radius,bay_height]) circle(small_base_radius);
    }
  }
}
  

module base()
union() {
  $fn=200;
  
  base_depth = base_thickness + bay_depth - small_base_radius - big_base_radius;
    bay_height = rpi0_height + rpi0_buffer*2 - small_base_radius*2 + base_thickness;

   difference()
  {
    rotate([90, 0, 90])
  translate([0, small_base_radius, 0])
  linear_extrude(base_length)
  hull() {
    circle(small_base_radius);
    translate([41,0]) circle(small_base_radius);
    translate([44,base_depth]) circle(big_base_radius);
    translate([-2,base_depth]) circle(big_base_radius);
  }
      translate([bay_buffer + bay_start.x + 14, bay_start.y + bay_height, base_thickness])
          cube([38,8,10]);
}

}

module screw_mount(screw_mount_height)
difference()
{
  screw_diameter = 1.25;
  screw_mount_dia = 3.5;

  linear_extrude(screw_mount_height)
  hull() {
    mount_size = screw_mount_dia;
    circle(mount_size);
    polygon([[-mount_size, mount_size], [-mount_size,-mount_size], [mount_size,-mount_size]]);
  }
  cylinder(r = screw_diameter, h = screw_mount_height);
}
