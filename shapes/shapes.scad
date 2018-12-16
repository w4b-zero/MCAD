/*
 *  OpenSCAD Shapes Library (www.openscad.org)
 *  Copyright (C) 2009  Catarina Mota
 *  Copyright (C) 2010  Elmo Mäntynen
 *
 *  License: LGPL 2.1 or later
*/

// 3D Shapes
//box(width, height, depth);
//mcad_rounded_box (size, radius, sidesonly, center=false)
//cone(height, radius);
//ellipticalCylinder(width, height, depth);
//ellipsoid(width, height);
//tube(height, radius, wall, center = false);
//tube2(height, ID, OD, center = false);
//ovalTube(width, height, depth, wall, center = false);
//hexagon(height, depth);
//octagon(height, depth);
//dodecagon(height, depth);
//hexagram(height, depth);
//rightTriangle(adjacent, opposite, depth);
//equiTriangle(side, depth);
//12ptStar(height, depth);
//ccube (size, center = false)


//----------------------

// size is a vector [w, h, d]
module box(width, height, depth) {
  cube([width, height, depth], true);
}

// Author: Marius Kintel
// Copyright: 2010
// License: 2-clause BSD License (http://opensource.org/licenses/BSD-2-Clause)

// mcad_rounded_box([width, height, depth], float radius, bool sidesonly);

// EXAMPLE USAGE:
// mcad_rounded_box([20, 30, 40], 5, true);

// size is a vector [w, h, d]
module mcad_rounded_box (size, radius, sidesonly, center=false)
{
    module place_xy ()
    for (x = [size[0]/2 - radius, -size[0]/2 + radius])
    for (y = [size[1]/2 - radius, -size[1]/2 + radius])
    translate ([x, y, 0])
    children ();

    translate (center ? [0, 0, 0] : size / 2)
    hull ()
    if (sidesonly) {
        place_xy ()
        cylinder (r = radius, h = size[2], center=true);

    } else {
        for (z = [size[2]/2 - radius, -size[2]/2 + radius])
        translate ([0, 0, z])
        place_xy ()
        sphere (r = radius);
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

// wall is wall thickness
module tube(h, r, wall, center = false) {
  linear_extrude (height=h, center=center)
  difference() {
    circle(r=r, center=center);
    circle(r=r-wall, center=center);
  }
}

// wall is wall thickness
module tube2(height, ID, OD, center = false) {
  difference() {
    cylinder(h=height, r=OD/2, center=center);
    cylinder(h=height, r=ID/2, center=center);
  }
}

// wall is wall thickness
module ovalTube(height, rx, ry, wall, center = false) {
  difference() {
    scale([1, ry/rx, 1]) cylinder(h=height, r=rx, center=center);
		translate([0,0,-0.1])
			#scale([(rx-wall)/rx, (ry-wall)/rx, 1]) cylinder(h=height+0.2, r=rx, center=center);
  }
}

// size is the XY plane size, height in Z
module hexagon(size, height) {
  boxWidth = size/1.75;
  for (r = [-60, 0, 60]) rotate([0,0,r]) cube([boxWidth, size, height], true);
}

// size is the XY plane size, height in Z
module octagon(size, height) {
  intersection() {
    cube([size, size, height], true);
    rotate([0,0,45]) cube([size, size, height], true);
  }
}

// size is the XY plane size, height in Z
module dodecagon(size, height) {
  intersection() {
    hexagon(size, height);
    rotate([0,0,90]) hexagon(size, height);
  }
}

// size is the XY plane size, height in Z
module hexagram(size, height) {
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
    translate([-adjacent/2,opposite/2,0]) cube([adjacent, opposite, height], true);
    translate([-adjacent,0,0]) {
      rotate([0,0,atan(opposite/adjacent)]) dislocateBox(adjacent*2, opposite, height+2);
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

module 12ptStar(size, height) {
  starNum = 3;
  starAngle = 360/starNum;
  for (s = [1:starNum]) {
    rotate([0, 0, s*starAngle]) cube([size, size, height], true);
  }
}

module ccube (size, center = false)
{
    center = (len (center) == undef) ? [center, center, center] : center;
    size = (len (size) == undef) ? [size, size, size] : size;

    function get_offset (i) = center[i] ? - size[i] / 2 : 0;

    translate ([get_offset (0), get_offset (1), get_offset (2)])
    cube (size);
}

//-----------------------
//MOVES THE ROTATION AXIS OF A BOX FROM ITS CENTER TO THE BOTTOM LEFT CORNER
module dislocateBox(w, h, d) {
  translate([0,0,-d/2]) cube([w,h,d]);
}

//-----------------------
// Tests
//module test2D_ellipse(){ellipse(10, 5);}
module test_ellipsoid(){ellipsoid(10, 5);}

//module test2D_egg_outline(){egg_outline();}

// unregular_shapes.scad
// Copyright 2011 Elmo Mäntynen
// LGPL 2.1

// Give a list of 4+4 points (check order) to form an 8 point polyhedron 
module connect_squares(points){
    polyhedron(points=points,
               triangles=[[0,1,2], [3,0,2], [7,6,5], [7,5,4], // Given polygons
                          [0,4,1], [4,5,1], [1,5,2], [2,5,6],  // Connecting
                          [2,6,3], [3,6,7], [3,4,0], [3,7,4]]);// sides
}
