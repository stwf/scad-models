parts="all"; // [all, granite, cement, wood]
show_orig=false;
show_floor=true;

/* [Size] */
EW=3; // [0.5:0.5:4]
NS=3; // [0.5:0.5:4]
/* [South Wall] */
south_wall=true;
sw_corner=false;
se_corner=false;
south_exterior=true;

/* [West Wall] */
west_wall=true;
west_exterior=true;
sw_corner=false;
nw_corner=false;

/* [North Wall] */
north_wall=true;
north_exterior=true;
nw_corner=false;
ne_corner=false;

/* [East Wall] */
east_wall=true;
ne_corner=false;
se_corner=false;

module __Customizer_Limit__ () {}

width=EW;
height=NS;
block_size=25.4;
half_block=block_size/2;
grout_height=2;
grout_inset=0.8;
block_height=3;
block_inset=0.6;
wall_height=42;
wallsize=[block_size, half_block, 6];
debug_pad=0;

module orig() {
  if (show_orig) {
    translate([0,0,0])
    rotate([0, 0, 180]) {
      import("/Users/steve/Documents/models/DD/floors/floor.2x3.stl");
      import("/Users/steve/Documents/models/DD/floors/stone_wall.stl");
    }
  }
}

module spheres(count) {  
  random_vect=rands(1,block_size,count*3);
  for(i=[0:count-1]) {
    translate([random_vect[i*3],random_vect[i*3 + 1],block_height])
    sphere(r=random_vect[i*3 + 2]/24);
  }
}

module floor_blocks(w, h) {
  for ( x = [0 : (w + 0.5) - 1] ) {
    for ( y = [0 : (h + 0.5) - 1] ) {
      translate([x * block_size + block_inset, y * block_size + block_inset, grout_height]) {
        difference() {
          cube([block_size - block_inset * 2, block_size - block_inset * 2, block_height]);
          
          spheres(31);
        }
      }
    }
  }
}

module floor_clip(w,h) {
  translate([0, 0, 0])
    cube([block_size * w, block_size * h, block_height + grout_height]);
}

module draw_wall(length) {
  intersection()
  {
    {
      if (parts == "all") {
        draw_wall_blocks(length);
        draw_wall_base(length);
        draw_wall_grout(length);
      }
      if (parts == "granite") {
        draw_wall_blocks(length);
      }
      if (parts == "cement") {
        draw_wall_base(length);
        draw_wall_grout(length);
      }
    }
    cube([length * block_size + block_inset, block_size / 2, wall_height]);
  }
}

module draw_wall_base(length) {
  color("#333")
    cube([length * block_size, block_size / 2, grout_height]);
}

module draw_wall_grout(length) {
  color("#333")
    translate([grout_inset, grout_inset, grout_height])
      cube([length * block_size - grout_inset, block_size / 2 - grout_inset*2, wall_height - 4*block_inset]);
}

module draw_wall_blocks(length) {
  color("#aaa") {

    row_offset = half_block;

    for ( x = [0 : (length + 0.5)] ) {
      for ( y = [0 : 3] ) {
        for ( z = [0 : 1] ) {
          translate([x * (block_size + 2*block_inset) + block_inset - z*row_offset, 0, (2*y + z) * (wallsize.z + 2*block_inset) + grout_height]) {
              cube(wallsize);
          }
        }
      }
    }
  }
}


orig();

if (show_floor) {
  if (parts == "all" ) {
    color("#333")
      cube([width * block_size, height * block_size, grout_height]);
    color("#aaa") {
      intersection(){
        floor_blocks(width, height);
        floor_clip(width, height);
      }
    }
  }

  if (parts == "cement") {
    color("#333")
      cube([width * block_size, height * block_size, grout_height]);
  }

  if (parts == "granite") {
    color("#aaa") {
      intersection(){
        floor_blocks(width, height);
        floor_clip(width, height);
      }
    }
  }
}

if (south_wall) {
  
  ext_offset = (sw_corner ? - half_block : 0);
  west_length = (sw_corner ? 0.5 : 0);
  east_length = (se_corner ? 0.5 : 0);
  translate([ext_offset, -debug_pad + (south_exterior ? - half_block : 0) , 0])
    draw_wall(width + west_length + east_length);
}
if (west_wall) {
  ext_offset = (sw_corner ? - half_block : 0);
  ext_length_s = (sw_corner ? 0.5 : 0);
  ext_length_n = (nw_corner ? 0.5 : 0);
  rotate([0,0,90])
    translate([ext_offset, (west_exterior ? -half_block : 0) + debug_pad, 0])
      draw_wall(height + ext_length_n + ext_length_s);
}

if (north_wall) {
  w_offset = (nw_corner ? -half_block : 0);
  ext_length_w = (nw_corner ? 0.5 : 0);
  ext_length_e = (ne_corner ? 0.5 : 0);
  translate([w_offset, height * block_size + debug_pad, 0])
    draw_wall(width + ext_length_e + ext_length_w);
}

if (east_wall) {
  ext_offset = (ne_corner ? - half_block : 0);
  ext_length_s = (se_corner ? 0.5 : 0);
  ext_length_n = (ne_corner ? 0.5 : 0);
  rotate([0,0,270])
    translate([-width * block_size + ext_offset, height * block_size, 0])
      draw_wall(height + ext_length_n + ext_length_s);
}






