/*
 * Multiplication along certain curves
 *
 * Copyright by Elmo Mäntynen, 2012.
 * Licenced under LGPL2 or later
 */

include <MCAD/units/metric.scad>

// Place children $no times around $axis, with the first duplicate being unmoved
// from its original spot. $angle is the angle of rotation between children(n)
// and children(n-1).
module mcad_rotate_multiply (no, angle = undef, axis = Z)
{
    angle = ( angle == undef ) ? 360 / no : angle;
    for (i = [0:no-1]){
        rotate (angle * i, axis)
        children ();
    }
}

module mcad_duplicate (axis = Z)
{
    mcad_rotate_multiply (no = 2, axis = axis)
    children ();
}

module mcad_linear_multiply (no, separation, axis = Z)
{
    for (i = [0:no - 1])
    translate (i * separation * axis)
    children (0);
}
