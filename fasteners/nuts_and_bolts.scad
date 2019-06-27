use <MCAD/array/along_curve.scad>
use <MCAD/array/rectangular.scad>
use <MCAD/shapes/2Dshapes.scad>
include <MCAD/units/metric.scad>
// Copyright 2010 D1plo1d
// Copyright 2017 Chow Loong Jin <hyperair@debian.org>

// This library is dual licensed under the GPL 3.0 and the GNU Lesser General
// Public License as per http://creativecommons.org/licenses/LGPL/2.1/ .

module mcad_test_nuts_and_bolts_1 ()
{
	$fn = 360;

	translate ([0, 15])
		mcad_nut_hole (3, proj = -1);

	mcad_bolt_hole (3, length = 30,tolerance =10, proj = -1);

}
//mcad_test_nuts_and_bolts_1 ();

module mcad_test_nuts_and_bolts_2 ()
{
	$fn = 360;

	difference () {
		cube (size = [10, 40, 10], center = true);
		union () {
			linear_extrude (height = 20, center = true, convexity = 10,
			                twist = 0) {
				mcad_nut_hole (3, proj = 2);
				translate ([0, -15])
					mcad_bolt_hole (3, length = 30, proj = 2);
			}
		}
	}
}
//mcad_test_nuts_and_bolts_2 ();

module mcad_test_nuts_and_bolts_3 ()
{
	$fn = 360;

	mcad_bolt_hole_with_nut (
		size = 3,
		length = 10
	);
}

//mcad_test_nuts_and_bolts_3 ();

// ISO 4032 nut width across flats:
// http://www.fasteners.eu/standards/ISO/4032/
METRIC_NUT_AF_WIDTH =
[
	[1.6,  3.20],
	[  2,  4.00],
	[2.5,  5.00],
	[  3,  5.50],
	[  4,  7.00],
	[  5,  8.00],
	[  6, 10.00],
	[  8, 13.00],
	[ 10, 16.00],
	[ 12, 18.00],
	[ 16, 24.00],
	[ 20, 30.00],
	[ 24, 36.00],
	[ 30, 46.00],
	[ 36, 55.00]
];

// ISO 4032 nut thickness:
// http://www.fasteners.eu/standards/ISO/4032/
METRIC_NUT_THICKNESS =
[
	[1.6, 1.3],
	[  2, 1.6],
	[2.5, 2.0],
	[ 3,  2.4],
	[ 4,  3.2],
	[ 5,  4.7],
	[ 6,  5.2],
	[ 8,  6.8],
	[10,  8.4],
	[12, 10.8],
	[16, 14.8],
	[20, 18.0],
	[24, 21.5],
	[30, 25.6],
	[36, 31.0]
];

// ISO 4762 cap screw diameters:
// http://www.fasteners.eu/standards/ISO/4762/
METRIC_BOLT_CAP_DIAMETER =
[
	[1.6, 3.0],
	[  2, 3.8],
	[2.5, 4.5],
	[ 3,  5.5],
	[ 4,  7.0],
	[ 5,  8.5],
	[ 6, 10.0],
	[ 8, 13.0],
	[10, 16.0],
	[12, 18.0],
	[16, 24.0],
	[20, 30.0],
	[24, 36.0],
	[30, 45.0],
	[36, 54.0]
];

function mcad_metric_nut_af_width (size) =
    lookup (size, METRIC_NUT_AF_WIDTH);
function mcad_metric_nut_thickness (size) =
    lookup (size, METRIC_NUT_THICKNESS);
function mcad_metric_bolt_cap_diameter (size) =
    lookup (size, METRIC_BOLT_CAP_DIAMETER);
function mcad_metric_bolt_major_diameter (size) = size;
function mcad_metric_bolt_cap_height (size) = size;

module mcad_nut_hole (size, tolerance = +0.0001, proj = -1)
{
	//takes a metric screw/nut size and looksup nut dimensions
	radius = mcad_metric_nut_ac_width (size) / 2 + tolerance;
	height = mcad_metric_nut_thickness (size) + tolerance;

	if (proj == -1) {
		cylinder (r = radius, h = height, $fn = 6, center = [0, 0]);
	}

	else if (proj == 1) {
		circle(r = radius, $fn = 6);
	}

	else if (proj == 2)
	{
		translate ([-radius/2, 0])
			square ([radius*2, height]);
	}
}

module mcad_bolt_hole (size, length,
                       cap_extra_length = 0,
                       tolerance = +0.0001,
                       proj = -1)
{
	radius = mcad_metric_bolt_major_diameter (size) / 2 + tolerance;

	cap_height = mcad_metric_bolt_cap_height (size) + tolerance;
	cap_radius = mcad_metric_bolt_cap_diameter (size) / 2 + tolerance;

	if (proj == -1)
	{
		translate([0, 0, -cap_height - cap_extra_length + epsilon])
			cylinder(r = cap_radius, h = cap_height + cap_extra_length);
		cylinder(r = radius, h = length);
	}
	if (proj == 1)
	{
		circle(r = radius);
	}
	if (proj == 2)
	{
		translate([-cap_radius, - cap_height])
			square([cap_radius * 2, cap_height]);
		translate([-radius, 0])
			square([radius * 2, length]);
	}
}

/**
 * mcad_bolt_hole_with_nut - renders a cap screw hole with corresponding nut
 *
 * @param size Diameter of screw
 * @param length Fastened length (distance between screw and nut)
 * @param nut_projection Direction to project nut in (axial, radial)
 * @param align_with Alignment of whole set (above_head, below_head, center,
 *                                           below_nut, above_nut)
 */
module mcad_bolt_hole_with_nut (size, length, nut_projection = "axial",
                                align_with = "above_head",
                                screw_extra_length = 9999,
                                head_extra_length = 9999,
                                nut_projection_length = 100,
                                bolt_tolerance = 0.15,
                                nut_tolerance = 0.001)
{
	cap_head_d = mcad_metric_bolt_cap_diameter (size);
	cap_head_h = size;

	nut_thickness = mcad_metric_nut_thickness (size);

	elevation = (
		(align_with == "above_head") ? 0 :
		(align_with == "below_head") ? cap_head_h :
		(align_with == "center") ? cap_head_h + length / 2 :
		(align_with == "below_nut") ? cap_head_h + length :
		(align_with == "above_nut") ? cap_head_h + length + nut_thickness : 0
	);

	translate ([0, 0, -elevation]) {
		/* screw head */
		translate ([0, 0, cap_head_h])
		mcad_bolt_hole (size = size, length = length + screw_extra_length,
		                cap_extra_length = head_extra_length,
		                tolerance = bolt_tolerance);

		/* nut */
		translate ([0, 0, cap_head_h + length - epsilon])
		hull () {
			axis = (nut_projection == "axial") ? +Z : +X;

			mcad_linear_multiply (no = 2, separation = nut_projection_length,
			                      axis = axis)
			mcad_nut_hole (size = size, tolerance = nut_tolerance);
		}
	}
}
