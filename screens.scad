show_screen = false;


module __Customizer_Limit__ () {}

slop=0.01;
2slop=0.02;
def_frame_front = 20;
def_frame_back = 20;
def_frame_left = 20;
def_frame_right = 20;
def_frame_bottom = 6;
def_frame_top = 0;
screw_mount = 3.8;

5_inch = [122, 77, 5];

// 5_inch_touchscreen();

module 5_inch_touchscreen(
  frame_left = def_frame_left,
  frame_right = def_frame_right,
  frame_front = def_frame_front,
  frame_back = def_frame_back,
  frame_bottom = def_frame_bottom,
  frame_top = def_frame_top) {
  draw_screen(5_inch, frame_left=frame_left, frame_right=frame_right, frame_top=frame_top, frame_bottom=frame_bottom,
    frame_back=frame_back, frame_front=frame_front);
}

module 5_inch_display(extra = 1, hole = true) {
  color("white")
    cube(5_inch);
  color("lime")
    translate([0, 0, -extra - slop]) {
      cube([5_inch.x, 5_inch.y, extra + 2slop]);
      screw_tab(true, extra, hole);
      translate([5_inch.x - 7.6, 0, 0])
        screw_tab(true, extra, hole);
      translate([5_inch.x - 7.6, 5_inch.y + 7.6, 0])
        screw_tab(false, extra, hole);
      translate([0, 5_inch.y + 7.6, 0])
        screw_tab(false, extra, hole);
    }
}

module screw_tab(front = true, extra = 1, hole = true) {
  linear_extrude(extra + slop) {
    difference() {
      union() {
        if (front) {
          translate([0, -screw_mount, 0])
            square([2 * screw_mount, screw_mount]);
        } else {
          translate([0, -2 * screw_mount, 0])
            square([2 * screw_mount, screw_mount]);
        }
        translate([screw_mount, -screw_mount, 0])
          circle(screw_mount);
      }
      if ( hole ) {
        translate([screw_mount, -screw_mount, 0])
          circle(screw_mount / 2);
      }
    }
  }
}

module draw_screen(screen_size,
  frame_left = def_frame_left,
  frame_right = def_frame_right,
  frame_front = def_frame_front,
  frame_back = def_frame_back,
  frame_bottom = def_frame_bottom,
  frame_top = def_frame_top
  )
{
  if (show_screen) {
    handle_draw_screen(screen_size, frame_left, frame_right, frame_front, frame_back, frame_bottom, frame_top);

    rotate([0, 180, 0])
      translate([-screen_size.x-frame_left, frame_back, -frame_bottom])
        5_inch_display(extra=12);
  } else {
    difference () {
      handle_draw_screen(screen_size, frame_left, frame_right, frame_front, frame_back, frame_bottom, frame_top);

      rotate([0, 180, 0])
        translate([-screen_size.x-frame_left, frame_back, -frame_bottom])
          5_inch_display(extra=12, hole = false);
    }
  }
}


module handle_draw_screen(screen_size,
  frame_left,
  frame_right,
  frame_front,
  frame_back,
  frame_bottom,
  frame_top
  ) {
  screw_depth = frame_bottom - 1;
  difference() {
    cube([
      frame_left + frame_right + screen_size.x,
      frame_front + frame_back + screen_size.y,
      frame_bottom + frame_top
    ]);
    translate([frame_left, frame_back, -slop])
      cube(screen_size + [0, 2slop, 2slop + frame_bottom]);
    
    translate([frame_left, frame_back, 2]) {
      translate([screw_mount, -screw_mount, 0])
        cylinder(r = 1.25, h = screw_depth);
       
      translate([screen_size.x - screw_mount, -screw_mount, 0])
        cylinder(r = 1.25, h = screw_depth);
    
      translate([screw_mount, screen_size.y+screw_mount, 0])
        cylinder(r = 1.25, h = screw_depth);
    
      translate([screen_size.x - screw_mount, screen_size.y + screw_mount, 0])
        cylinder(r = 1.25, h = screw_depth);
      }
  }
}