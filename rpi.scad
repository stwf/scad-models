


 // include <./RPi4board-modded.scad>;



// translate([5, 61, 5])
  // rotate([0, 0, 270])
   // board_raspberrypi_4_model_b();


// rpi4([2, 2, 2], [0, 0, 2]);


slop=0.01;
module rpi4(
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
  rpi_screws=[58, 49, 3];
  rpi_size=[88, 58, 13];

  difference() {
    gen_rpi(rpi_screws, rpi_size, rpi_buffer, rpi_padding, expose_card, expose_hdmi, expose_usb1,   expose_usb2, expose_ribbon_cable, expose_gpio_pins, head_room);
  
    // usb 1
    translate([92, 6, 5])
      cube([16, 16, 18]);

    // usb 2
    translate([92, 24, 5])
      cube([16, 16, 18]);

    // ethernet
    translate([92, 42, 5])
      cube([16, 18, 16]);

    // power
    translate([9, -slop, rpi_padding.z + rpi_buffer.z])
      cube([14, rpi_buffer.x + 2*slop, 7]);

    // hdmi
    translate([26.5, -slop, rpi_padding.z + rpi_buffer.z])
      cube([9, rpi_buffer.x + 2*slop, 5]);

    // hdm2
    translate([40, -slop, rpi_padding.z + rpi_buffer.z])
      cube([9, rpi_buffer.x + 2*slop, 5]);

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

  gen_rpi(rpi_screws, rpi_size, rpi_buffer, rpi_padding, expose_card, expose_hdmi, expose_usb1, expose_usb2, expose_ribbon_cable, expose_gpio_pins, head_room);
  
  
  
}

module gen_rpi(
  rpi_screws, 
  rpi_size,
  
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
  rpi_envelope=rpi_size + [2, 2, 4];
  sdcard_allowance= expose_card ? 0 : 2;

  mezz_height= max( rpi_padding.z, 3);
  rpi_cutout = rpi_envelope + rpi_padding * 2 - [0, 0, rpi_padding.z];
  rpi_origin = rpi_buffer;
    
  difference()
  {
    union()
    {
      difference()
      {
        cube(rpi_cutout + rpi_buffer + [rpi_buffer.x + sdcard_allowance, rpi_buffer.y, head_room]);
        translate(rpi_origin + [0,0,0])
        cube(rpi_cutout + [0,0,rpi_padding.z + rpi_buffer.z + slop]);
      }
      
      translate(rpi_origin + [rpi_padding.x + 3, rpi_padding.y + 3, 0])
        screws(rpi_screws, mezz_height);
    }
    
    
    
    
    // graphics ribbon
    if (expose_ribbon_cable) {
      translate(rpi_buffer + [-rpi_buffer.x - slop, 7, rpi_buffer.z + rpi_padding.z])
      cube([rpi_buffer.x + rpi_padding.x + slop + slop, 17, rpi_cutout.z]);
    }

    // sd card slot
    if (expose_card) {
      translate(rpi_buffer + [rpi_envelope.x - slop - 1, 11, -rpi_buffer.z - slop])
      cube([rpi_buffer.x + 10 + sdcard_allowance, 15, rpi_cutout.z + rpi_buffer.z*3]);
    }

    if (expose_gpio_pins) {
      translate(rpi_buffer + rpi_padding + [7, -rpi_buffer.y -slop, 0])
      cube([rpi_buffer.x + 12 + 39, rpi_buffer.y + 1 + slop*2, rpi_cutout.z + slop]);
    }

    translate(rpi_buffer + [1, rpi_envelope.y - slop, rpi_buffer.z + rpi_padding.z - 1])
    {
      // usb slot
      if (expose_usb2) {
        translate([5, 0, 0])
        cube([11, rpi_buffer.y + slop*2, 8]);
      }
      // usb slot
      if (expose_usb1) {
        translate([19, 0, 0])
        cube([11, rpi_buffer.y + slop*2, 8]);
      }
      // hdmi
      if (expose_hdmi) {
        translate([44.6, 0, 0])
        cube([16, rpi_buffer.y + slop*2, 8]);
      }
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

