axle_gap=1.6;
hinge_gap=1.4;
slop=0.01;
hinge_rotate=0;
module __Customizer_Limit__ () {}

box_width=60;
box_height=10;
box_depth=20;
hinge_width=5;
hinge_seperation=4.8;


module test()
{
box_a();

translate([0, 0, hinge_height])
  rotate([0, hinge_rotate,0]) 
  translate([0, 0, -hinge_height])
  box_b();

hinge(0, 12);
hinge(0, 48);
}

module hinge(axis, offset, hinge_rise=4.0, hinge_reach=0.1, axle_thickness=1.2, hinge_width=5, hinge_gap=0.4)
{
  hinge_arm(axis, offset, hinge_rise, hinge_reach, axle_thickness, hinge_width, hinge_gap);
  hinge_bay(axis, offset, hinge_rise, hinge_reach, axle_thickness, hinge_width, hinge_gap);
}

module hinge_arm(axis, offset, hinge_rise, hinge_reach, axle_thickness, hinge_width, hinge_gap)
{
  axle_radius=axle_thickness*2;
  outer_axle_radius = axle_radius + axle_thickness + axle_gap;

  hinge_height=box_height + hinge_rise;
  translate([axis, offset - hinge_width/2, hinge_height])
  rotate([-90,0,0]) 
  linear_extrude(hinge_width)
  {
    difference()
    {
      hull()
      {
        circle(r = outer_axle_radius);
        translate([hinge_seperation - 0.1, 0, 0])
          square([hinge_reach, hinge_height]);
      }
      circle(r = axle_radius + axle_gap);
    }
  }
}

module hinge_bay(axis, offset, hinge_rise, hinge_reach, axle_thickness, hinge_width, hinge_gap)
{
  axle_radius=axle_thickness*2;
  outer_axle_radius = axle_radius + axle_thickness + axle_gap;

  hinge_height=box_height + hinge_rise;
  hinge_bay_width = hinge_width + hinge_gap*2;
  translate([axis, offset - hinge_width - hinge_gap, hinge_height])
  rotate([-90,0,0])
  union()
  {
    rotate([0,0,hinge_rotate])
    difference()
    {
      linear_extrude(hinge_width*2 + hinge_gap*2)
      hull()
      {
        translate([0, 0, - axle_gap])
        circle(r = outer_axle_radius);
        translate([-hinge_seperation-hinge_seperation - hinge_reach, 0, 0])
        square([hinge_reach, hinge_height]);
      }
      
      translate([-hinge_seperation-axle_gap, - outer_axle_radius -.8, hinge_width/2])
        cube([(outer_axle_radius+axle_gap)*2, hinge_height + outer_axle_radius + 1, hinge_bay_width]);

    }

    translate([0, 0, hinge_width/2])
      cylinder(h = hinge_bay_width, r = axle_radius);
  }
}

module box_a()
  {
    translate([hinge_seperation, 0, 0])
    cube([box_depth,box_width,box_height]);    
  }
  
module box_b()
  {
    rotate([0,180,0])
    translate([hinge_seperation, 0, -box_height])
    cube([box_depth,box_width,box_height]);    
  }
