/*
 * \brief     Meccano-like 2D parts.
 * \author    Vadim Cherenev <sl@anhot.ru>
 * \version   0.1
 * \date      2018
 * \copyright Public Domain
 */

//Examples:
//  mec_rounded_panel 3x4
//    mec_rounded_panel(3, 4);
//  mec_wheel, r=3
//    mec_wheel(3);

mec_unit=10; //distance between holes
mec_diam=4.5; //hole diameter
mec_half_unit = mec_unit/2;
mec_bend_stroke = 5;
mec_bend_width = 0.5;

function mec_units(n) = n*mec_unit;

module mec_basicHole() {
  circle(d=mec_diam);
}

module mec_longHole(diam = mec_diam, length = mec_diam, mec_angle = 0) {
  rotate(mec_angle) {  
      translate([0, -length / 2]) 
        circle(d = diam);
      translate ([- diam / 2, -length / 2])
        square([diam, length]);
      translate([0,length / 2])  
        circle(d = diam);
  }
}

module mec_bend_line(size) {
  for (x = [0:size-1]) {
    translate([0,mec_units(x)])
      mec_longHole(mec_bend_width, mec_bend_stroke);
  }
}

module mec_hole_grid(sizex, sizey) {
  for (x = [0:sizex-1]) {
    translate([0,mec_units(x)])
      for (y=[0:sizey-1]) {
        translate([y*mec_unit+mec_half_unit,mec_half_unit]) mec_basicHole();
      }
  }
}

module long_mec_hole_grid(sizex, sizey, mec_angle) {
  for (x = [0:sizex-1]) {
    translate([0,mec_units(x)])
      for (y=[0:sizey-1]) {
        translate([y*mec_unit+mec_half_unit,mec_half_unit]) mec_longHole(mec_diam, mec_diam / 2, 90);
      }
  }
}

module mec_square_plot(sizex, sizey) {
  square([mec_units(sizey), mec_units(sizex)]);    
}

module mec_basic_panel(sizex, sizey) {
  difference() {  
     mec_square_plot(sizex,sizey);
     mec_hole_grid(sizex,sizey); 
  }
}

module mec_chamfer(type){
  rotate(90*type)
    difference() {  
      square(mec_half_unit);
      translate([mec_half_unit,mec_half_unit]) circle(d=mec_unit);  
    }
}

module mec_rounded_panel(sizex, sizey) {
  difference() {
    mec_basic_panel(sizex,sizey);
    translate([0,0])                       mec_chamfer(0);
    translate([mec_units(sizey),0])            mec_chamfer(1);
    translate([mec_units(sizey),mec_units(sizex)]) mec_chamfer(2);
    translate([0,mec_units(sizex)])            mec_chamfer(3);      
  }
}

/* heuristic formula to check if hole too close to others. 
* @param rows total mec_wheel rows
* @param r current row
* @param j current hole in the row
* @return true if hole can be placed
*/
function mec_mec_wheel_hole_available(rows,r,j) = (0==(((1/rows)*r*pow(2,(j+2-floor(j/(2.5-(j/10))))))%1));

module mec_mec_wheel_holes(size) {
  rows = pow(2,size)*4; 
  mec_angle = 360/rows;  
  for(i=[0:rows-1]) {  
    for (j=[1:size]) {  
      if (mec_mec_wheel_hole_available(rows,i,j)) {
      rotate(mec_angle*i)
        translate([mec_units(j),0])
          mec_basicHole();
      }
    }
  }    
}

module mec_round_plot(size) {
    circle(mec_units(size)+mec_half_unit);
}


module mec_wheel(size) {
  if (size<=10) {
    difference() {
      mec_round_plot(size-1);  
      mec_mec_wheel_holes(size-1);
      mec_basicHole();  
    }    
  }
  else
      echo ("ERROR: Max wheel radius of 10 alowed.");
}

module mec_angle(size) {
  difference() {  
    mec_rounded_panel(size, 2);
    translate([mec_unit, mec_half_unit]) 
      mec_bend_line(size);
    long_mec_hole_grid(size, 1);
  }
}

module mec_angled_panel(sizex, sizey, angle=0) {
  difference() {  
    mec_rounded_panel(sizex, sizey);
    translate([mec_units(angle+1), mec_half_unit]) 
      mec_bend_line(sizex);
    translate([mec_units(sizey-(angle+1)), mec_half_unit]) 
      mec_bend_line(sizex);
    translate([0, 0]) 
      long_mec_hole_grid(sizex, 1);
    translate([mec_units(sizey-1), 0]) 
      long_mec_hole_grid(sizex, 1);
  }
}
