include <MCAD/units/metric.scad>
use <MCAD/array/along_curve.scad>
use <MCAD/general/utilities.scad>

/**
 * @deprecated
 * Copy everything $no of times around an $axis, spread over $angle
 *
 *  If strict==true or angle==360, then spacing will leave an empty at angle,
 *  otherwise, no will be distributed so first is at 0deg, last copy at angle
 *  degrees.
 *
 *  NOTE: axis works (rotates around that axis), but pass parameter as lower
 *   case string eg: "x", "y", or "z". Alternatively, use units.scad vector
 *   definitions: X, Y, Z
 */
module spin (no, angle = 360, axis = Z, strict = false)
{
    divisor = (strict || angle == 360) ? no : no - 1;

    mcad_rotate_multiply (no, angle / divisor, normalized_axis (axis))
        children ();
}

/**
 * @deprecated
 * Duplicate by rotating a copy 180° around `axis`
 */
module duplicate (axis = Z)
{
    mcad_duplicate (axis = axis)
    children ();
}

/**
 * @deprecated
 * Evenly multiply children `no` times by translating by `separation` distance
 * along `axis`.
 */
module linear_multiply (no, separation, axis = Z)
{
    mcad_linear_multiply (
        no = no,
        separation = separation,
        axis = normalized_axis (axis)
    )
        children ();
}
