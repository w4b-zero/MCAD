// array functions
// by david powell
// licence LGPL V2 or later
//
// this lib provides 2 functions
// Cubic_Array() , and Radial_Array()
//
//Cubic_Array(sx,sy,sz,nx,ny,nz,center){childobject}
//  produces a cubic grid of child objects
//  sx,sy,sz = spacing for each axis
//  nx,ny,nz and number of objects on each axis
//  center = true/false on if geometery is centered or not
//
//
//Radial_Array(a,n,r){child object}
// produces a clockwise radial array of child objects rotated around the local z axis
// a= interval angle
// n= number of objects
// r= radius distance
//
// remove // from following line to run test
Cubic_and_Radial_Array_Test();

use <MCAD/array/polar.scad>
use <MCAD/array/rectangular.scad>
include <MCAD/units/metric.scad>

module Cubic_and_Radial_Array_Test()
{
    //center referance point
    #translate([0,0,0])
        cube([5,5,5],center=true);

    //cubic array  of  5*5*5 objects spaced 10*10*10 center relative
    Cubic_Array(10,10,10,5,5,5,center=true)
    {
        sphere(2.5,$fn=60);
        cylinder(h=10,r=.5,center=true);
        rotate([90,0,0])
            cylinder(h=10,r=.5,center=true);
        rotate([0,90,0])
            cylinder(h=10,r=.5,center=true);
    }

    //a linear array allong x can be derived from the cubic array simply
    translate([60,0,0])
        Cubic_Array(10,0,0,5,1,1,center=false)
    {
        cube([5,5,5],center=true);
    }
    //a linear array allong y can be derived from the cubic array simply
    translate([0,60,0])
        Cubic_Array(0,10,0,1,5,1,center=false)
    {
        cube([5,5,5],center=true);
    }

    //a linear array allong z can be derived from the cubic array simply
    translate([0,0,60])
        Cubic_Array(0,0,10,1,1,5,center=false)
    {
        cube([5,5,5],center=true);
    }

    //a grid  array allong x,y can be derived from the cubic array simply
    translate([0,0,-60])
        Cubic_Array(10,10,0,5,5,1,center=true)
    {
        cube([5,5,5],center=true);
    }

    //radial array of 32 objects rotated though 10 degrees
    translate([0,0,0])
        Radial_Array(10,32,40)
    {
        cube([2,4,6],center=true);
    }

    // a radial array of linear arrays

    rotate([45,45,45])
        Radial_Array(10,36,40)
    {
        translate([0,10,0])
            Cubic_Array(0,10,0,1,5,1,center=false)
        {
            cube([2,3,4],center=true);
            cylinder(h=10,r=.5,center=true);
            rotate([90,0,0])
                cylinder(h=10,r=.5,center=true);
        }
    }

}


/**
 * @deprecated
 * Produces a cubic grid of child objects
 *
 * @param sx Spacing for X axis
 * @param sy Spacing for Y axis
 * @param sz Spacing for Z axis
 * @param nx Number of objects in X axis
 * @param ny Number of objects in Y axis
 * @param nz Number of objects in Z axis
 * @param center true/false on if geometery is centered or not
 */
module Cubic_Array(sx, sy, sz, nx, ny, nz, center)
{
	/* When center=false, Cubic_Array translates the first element by
	   [sx, sy, sz], whereas mcad_array_rectangular leaves it in its original
	   location */
	compat_offset = (center) ? [0, 0, 0] : [sx, sy, sz];

	translate (compat_offset)
        mcad_array_rectangular(
            grid_size=[nx, ny, nz],
            separation=[sx, sy, sz],
            center=center
        )
        children();
}

/**
 * @deprecated
 * Radial_Array(a,n,r){child object}
 *  produces a clockwise radial array of child objects rotated around the local
 *  Z axis, starting at 12-o-clock
 *
 * @param a Interval angle
 * @param n Number of copies
 * @param radius distance
 */
module Radial_Array(a, n, r)
{
	rotate(90, Z)
        mcad_array_polar(-a, n, r)
        rotate(-90, Z)
        children();
}
