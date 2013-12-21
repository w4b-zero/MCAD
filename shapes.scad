/*
 *  OpenSCAD Shapes Library (www.openscad.org)
 *  Copyright (C) 2009  Catarina Mota
 *  Copyright (C) 2010  Elmo Mäntynen
 *
 *  License: LGPL 2.1 or later
*/

include <units.scad>

/*
2D Shapes
ngon(sides, radius, center=false);

3D Shapes
box(width, height, depth);
roundedBox(width, height, depth, factor);
cone(height, radius);
ellipticalCylinder(width, height, depth);
ellipsoid(width, height);
tube(height, radius, wall, center = false);
tube2(height, ID, OD, center = false);
ovalTube(width, height, depth, wall, center = false);
hexagon(height, depth);
octagon(height, depth);
dodecagon(height, depth);
hexagram(height, depth);

rightTriangle(adjacent, opposite, depth);
equiTriangle(side, depth);
12ptStar(height, depth);
*/

//----------------------

// size is a vector [w, h, d]
module box(width, height, depth) {
  echo("USE CUBE[size=[w,d,h,true]]");
  cube([width, height, depth], true);
}

// size is a vector [w, h, d]
module roundedBox(width = 1,
                  height = 1, 
                  depth = 1, 
                  radius = 0.2) {
  size=[width, height, depth];
  cube(size - [2*radius,0,0], true);
  cube(size - [0,2*radius,0], true);
  for (x = [radius-size[0]/2, -radius+size[0]/2],
       y = [radius-size[1]/2, -radius+size[1]/2]) {
    translate([x,y,0]) cylinder(r=radius, h=size[2], center=true);
  }
}

module cone(height, radius, center = false) {
  cylinder(height, radius, 0, center);
}

module ellipticalCylinder(w,h, height, center = false) {
  scale([1, h/w, 1]) cylinder(h=height, r=w, center=center);
}

module ellipsoid(w, h, center = false) {
  scale([1, h/w, 1]) sphere(r=w/2, center=center);
}

module tube(height = 10, 
            radius = 10, 
            wall = 2, 
            center = false) {
  difference() {
    cylinder(h=height, r=radius, center=center);
	 translate([0,0,-epsilon])
      cylinder(h=height+2*epsilon, r=radius-wall, center=center);
  }
}

module tube2(height = 10, 
             ID = 16, 
             OD = 20, 
             center = false) {
  tube(height=height,center=center,radius=OD/2,wall=(OD/2)-(ID/2));
}

module ovalTube(height = 5, 
                rx = 10, 
                ry = 5, 
                wall = 1, 
                center = false) {
  difference() {
    scale([1, ry/rx, 1]) cylinder(h=height, r=rx, center=center);
    scale([(rx-wall)/rx, (ry-wall)/rx, 1]) cylinder(h=height, r=rx, center=center);
  }
}

module hexagon(size = 10, 
               height = 5) {
  boxWidth = size/1.75;
  for (r = [-60, 0, 60]) 
    rotate([0,0,r]) 
      cube([boxWidth, size, height], true);
}

module octagon(size = 10, 
               height = 5) {
  intersection() {
    cube([size, size, height], true);
    rotate([0,0,45]) 
		cube([size, size, height], true);
  }
}

module dodecagon(size = 10, 
                 height = 5) {
  intersection() {
    hexagon(size, height);
    rotate([0,0,90]) hexagon(size, height);
  }
}

module hexagram(size = 10, 
                height = 5) {
  boxWidth=size/1.75;
  for (v = [[0,1],[0,-1],[1,-1]]) {
    intersection() {
      rotate([0,0,60*v[0]]) cube([size, boxWidth, height], true);
      rotate([0,0,60*v[1]]) cube([size, boxWidth, height], true);
    }
  }
}

module rightTriangle(adjacent, opposite, height) {
  difference() {
    translate([-adjacent/2,opposite/2,0]) 
      cube([adjacent, opposite, height], true);
    translate([-adjacent,0,0]) {
      rotate([0,0,atan(opposite/adjacent)]) 
        dislocateBox(adjacent*2, opposite, height+2);
    }
  }
}

module equiTriangle(side, height) {
  difference() {
    translate([-side/2,side/2,0]) cube([side, side, height], true);
    rotate([0,0,30]) dislocateBox(side*2, side, height);
    translate([-side,0,0]) {
      rotate([0,0,60]) dislocateBox(side*2, side, height);
    }
  }
}

module 12ptStar(size = 12, 
                height = 5) {
  starNum = 3;
  starAngle = 90/starNum;
  for (s = [1:starNum]) {
    rotate([0, 0, s*starAngle]) cube([size, size, height], true);
  }
}

module dislocateBox(w, h, d) {
  translate([0,0,-d/2]) cube([w,h,d]);
}
