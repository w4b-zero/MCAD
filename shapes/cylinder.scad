include <MCAD/units/metric.scad>

module mcad_rounded_cylinder (
    // same options as cylinder()
    r = undef, h = undef, d = undef,
    r1 = undef, r2 = undef,
    d1 = undef, d2 = undef,

    // rounding radius
    round_r = 0,
    round_r1 = 0, round_r2 = 0
)
{
    // First resolve all the required values from arguments...
    r = (r == undef && d != undef) ? d / 2 : r;

    function resolve_numbered_radius (rN, dN) = (
        (rN == undef) ? (
            (dN != undef) ? dN / 2 :
            r
        ) : rN
    );

    r1 = resolve_numbered_radius (r1, d1);
    r2 = resolve_numbered_radius (r2, d2);

    round_r1 = (round_r1 == 0) ? round_r : round_r1;
    round_r2 = (round_r2 == 0) ? round_r : round_r2;

    inv_gradient = (r2 - r1) / h;

    function circle_offset (central_angle, r) = (
        sin (central_angle) * r -
        ((cos (central_angle) * r - r) / h * (r2 - r1))
    );

    module basic_section ()
    polygon ([
            [0, 0],
            [r1, 0],
            [r2, h],
            [0, h]
        ]);

    // assume horizontal edge is below, and vertical edge is on the right, i.e.
    // rounding circle 1.
    module rounding_circle (inv_gradient, r)
    {
        triangle_angle = 180 - atan2 (1, inv_gradient);
        circle_angle = 180 - triangle_angle;

        // line up the intersection between circle and hypotenuse with the vertice
        translate ([
                -sin (circle_angle) * r +
                inv_gradient * (sin (circle_angle + 270) * r + r),
                0
            ])
        translate ([0, r])      // ensure tangent with X axis
        circle (r, $fn = 50);
    }

    rotate_extrude ()
    difference () {
        basic_section ();

        if (round_r1 != 0 || round_r2 != 0)
        difference () {
            offset (epsilon)
            basic_section ();

            // cut away unwanted sections
            translate ([-epsilon, round_r1 * 2])
            square ([max (r1, r2) + epsilon, (h - (round_r1 + round_r2) * 2)]);

            // rounding circles
            hull () {
                translate ([r1, 0])
                rounding_circle (inv_gradient, round_r1);

                translate ([-2, -2] * epsilon)
                square ([epsilon, round_r1 * 2]);

                translate ([0, h])
                mirror (Y) {
                    translate ([r2, 0])
                    rounding_circle (-inv_gradient, round_r2);

                    translate ([-2, -2] * epsilon)
                    square ([epsilon, round_r1 * 2]);
                }
            }
        }
    }
}

mcad_rounded_cylinder (r1 = 3, r2 = 10, h = 10, round_r = 1);
