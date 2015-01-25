/*
 * Multiplication along certain curves
 *
 * Copyright by Elmo Mäntynen, 2012.
 * Licenced under LGPL2 or later
 */

include <MCAD/units/metric.scad>
use <MCAD/general/utilities.scad>

// Place children $no times around $axis, with the first duplicate being unmoved
// from its original spot. $angle is the angle of rotation between children(n)
// and children(n-1).
module spin(no, angle = undef, axis = Z){
	angle = ( angle == undef ) ? angle / no : angle;
	for (i = [0:no-1]){
		rotate(normalized_axis(axis)*angle*i) union(){
			for (j = [0 : $children-1]) children(j);
		}
	}
}

module duplicate(axis=Z) spin(no=2, axis=axis) child(0);

module linear_multiply(no, separation, axis=Z){
	for (i = [0:no-1]){
		translate(i*separation*axis) children(0);
	}
}
