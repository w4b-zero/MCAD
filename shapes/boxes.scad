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
