/*
 * \brief     Meccano-like 2D parts.
 * \author    Vadim Cherenev <sl@anhot.ru>
 * \version   0.1
 * \date      2018
 * \copyright Public Domain
 */

//Examples:
//  rounded_panel 3x4
//    rounded_panel(3, 4);
//  wheel, r=3
//    wheel(3);

mec_unit=10; //distance between holes
mec_diam=4.5; //hole diameter
mec_half_unit = mec_unit/2;

function units(n) = n*mec_unit;

module mec_basicHole() {
  circle(d=mec_diam);
}

module hole_grid(sizex, sizey) {
  for (x = [0:sizex-1]) {
    translate([0,units(x)])
      for (y=[0:sizey-1]) {
        translate([y*mec_unit+mec_half_unit,mec_half_unit]) mec_basicHole();
      }
  }
}

module mec_square_plot(sizex, sizey) {
  square([units(sizey), units(sizex)]);    
}

module basic_panel(sizex, sizey) {
  difference() {  
     mec_square_plot(sizex,sizey);
     hole_grid(sizex,sizey); 
  }
}

module chamfer(type){
  rotate(90*type)
    difference() {  
      square(mec_half_unit);
      translate([mec_half_unit,mec_half_unit]) circle(d=mec_unit);  
    }
}

module rounded_panel(sizex, sizey) {
  difference() {
    basic_panel(sizex,sizey);
    translate([0,0])                       chamfer(0);
    translate([units(sizey),0])            chamfer(1);
    translate([units(sizey),units(sizex)]) chamfer(2);
    translate([0,units(sizex)])            chamfer(3);      
  }
}

/* heuristic formula to check if hole too close to others. 
* @param rows total wheel rows
* @param r current row
* @param j current hole in the row
* @return true if hole can be placed
*/
function mec_wheel_hole_available(rows,r,j) = (0==(((1/rows)*r*pow(2,(j+2-floor(j/(2.5-(j/10))))))%1));

module mec_wheel_holes(size) {
  rows = pow(2,size)*4; 
  angle = 360/rows;  
  for(i=[0:rows-1]) {  
    for (j=[1:size]) {  
      if (mec_wheel_hole_available(rows,i,j)) {
      rotate(angle*i)
        translate([units(j),0])
          mec_basicHole();
      }
    }
  }    
}

module mec_round_plot(size) {
    circle(units(size)+mec_half_unit);
}


module wheel(size) {
  if (size<=10) {
    difference() {
      mec_round_plot(size-1);  
      mec_wheel_holes(size-1);
      mec_basicHole();  
    }    
  }
  else
      echo ("ERROR: Max wheel radius of 10 alowed.");
}
