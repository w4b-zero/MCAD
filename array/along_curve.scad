/*
 * Multiplication along certain curves
 *
 * Copyright by Elmo Mäntynen, 2012.
 * Licenced under LGPL2 or later
 */

include <MCAD/units/metric.scad>
use <MCAD/general/utilities.scad>

// TODO check that the axis parameter works as intended
// Duplicate everything $no-1 of times around an $axis.
// If no $angle is given, space $no-1 items evenly around $axis.
// If $angle is given, rotate $no-1 items around $axis by $angle.
// children(0) is not moved.
module spin(no, angle=360, axis=Z){
	angle = ( angle == 360 ) ? angle / no : angle;
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
