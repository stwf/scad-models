


 // include <./RPi4board-modded.scad>;


// translate([5, 61, 5])
  // rotate([0, 0, 270])
   // board_raspberrypi_4_model_b();


// rpi4([2, 2, 2], [0, 0, 2]);

def_buffer_top = 3;
def_buffer_bottom = 3;
def_buffer_left = 3;
def_buffer_right = 3;
def_buffer_front = 3;
def_buffer_back = 3;
def_padding_top = 3;
def_padding_bottom = 3;
def_padding_left = 3;
def_padding_right = 0;
def_padding_front = 3;
def_padding_back = 0;




slop=0.01;
2slop=0.02;
module rpi4(
  buffer_top = def_buffer_top, 
  buffer_bottom = def_buffer_bottom, 
  buffer_left = def_buffer_left, 
  buffer_right = def_buffer_right, 
  buffer_front = def_buffer_front, 
  buffer_back = def_buffer_back, 
  padding_top = def_padding_top, 
  padding_bottom = def_padding_bottom, 
  padding_left = def_padding_left, 
  padding_right = def_padding_right, 
  padding_front = def_padding_front, 
  padding_back = def_padding_back, 
  expose_card=false,
  expose_hdmi1=true,
  expose_hdmi2=true,
  expose_power=true,
  expose_usb1=true,
  expose_usb2=true,
  expose_audio=true,
  expose_ethernet=true,
  expose_ribbon_cable=false,
  expose_gpio_pins=false,
  head_room=4
  )
{
  rpi_screws=[58, 49, padding_bottom];
  rpi_size=[85, 56, 4];

  difference() {
    gen_rpi(
        buffer_top, 
        buffer_bottom, 
        buffer_left, 
        buffer_right, 
        buffer_front, 
        buffer_back, 
        padding_top, 
        padding_bottom, 
        padding_left, 
        padding_right, 
        padding_front, 
        padding_back, 

        rpi_screws,
        rpi_size);
  
    translate([
      buffer_left + padding_left + padding_right,
      buffer_back + padding_back,
      buffer_bottom + padding_bottom
    ]) {
      if (expose_usb1) 
        translate([rpi_size.x, 3, 0])
          cube([16, 16, 19]);

      if (expose_usb2) 
        translate([rpi_size.x, 21, 0])
          cube([16, 16, 19]);

      if (expose_ethernet)  
        translate([rpi_size.x, 39, 0])
          cube([16, 18, 17]);
    }
    translate([buffer_left + padding_left, 0, buffer_bottom + padding_bottom]) {
      if (expose_power)  
        translate([9, -slop, 0])
          cube([14, buffer_back + 2slop, 8]);

      if (expose_hdmi1)  
        translate([26.5, -slop, 0])
          cube([9, buffer_back + 2slop, 5]);

      if (expose_hdmi2)  
        translate([40, -slop, 0])
          cube([9, buffer_back + 2slop, 5]);

      if (expose_audio)  
        translate([55, -slop, 3])
          rotate([0,90,90])
            cylinder(r=2, h=buffer_back + 2slop);
    }
  }
}

module rpi0(
  rpi_buffer, 
  rpi_padding,
  expose_card=false,
  expose_hdmi=false,
  expose_usb1=false,
  expose_usb2=false,
  expose_ribbon_cable=false,
  expose_gpio_pins=false,
  head_room=4
  )
{
  rpi_screws=[58, 23, 3];
  rpi_size=[65, 30, 3];

  gen_rpi(rpi_screws, rpi_size, rpi_buffer, rpi_padding);
  
  
  
}

module gen_rpi(
    buffer_top, 
    buffer_bottom, 
    buffer_left, 
    buffer_right, 
    buffer_front, 
    buffer_back, 
    padding_top, 
    padding_bottom, 
    padding_left, 
    padding_right, 
    padding_front, 
    padding_back, 
    rpi_screws, 
    rpi_size
  )
{
  rpi_envelope=rpi_size + [2, 2, 4];

  rpi_cutout = rpi_envelope + [padding_left + padding_right, padding_back + padding_front, padding_bottom + padding_top];
  rpi_origin = [buffer_left, buffer_back, buffer_bottom];
  rpi_buffer = [buffer_left + buffer_right, buffer_back + buffer_front, buffer_bottom + buffer_top];

  difference()
  {
    union()
    {
      difference()
      {
        cube(rpi_cutout + rpi_buffer);
        translate(rpi_origin)
        cube(rpi_cutout + [0, 0, slop]);
      }
      
      translate(rpi_origin + [padding_left, padding_back, 0])
        screws(rpi_screws, padding_bottom);
    }
  }
}

module screws(rpi_screws, screw_height)
{
  screw_mount(screw_height, 0);

  translate([rpi_screws.x, 0, 0])
  screw_mount(screw_height, 90);

  translate([rpi_screws.x, rpi_screws.y, 0])
  screw_mount(screw_height, 180);

  translate([0, rpi_screws.y, 0])
  screw_mount(screw_height, 270);
}

module screw_mount(screw_mount_height, rotation)
{
  difference()
  {
    screw_diameter = 1.25;
    screw_mount_dia = 3.5;
    
    translate([screw_mount_dia/2 + 1.75, screw_mount_dia/2 + 1.75, 0])
    rotate(rotation)
    linear_extrude(screw_mount_height)
    hull() {
      mount_size = screw_mount_dia;
      circle(mount_size);
      polygon([[-mount_size, mount_size], [-mount_size,-mount_size], [mount_size,-mount_size]]);
    }
    translate([screw_mount_dia/2 + 1.75, screw_mount_dia/2 +  1.75, slop])
    cylinder(r = screw_diameter, h = screw_mount_height);
  }
}

