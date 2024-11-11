use <MCAD/shapes/polyhole.scad>

// @deprecated
module polyhole (h, d = undef, r = undef, center = false)
{
    _h = (h < 0) ? undef : h;

    mcad_polyhole (
        d = d,
        r = r,
        h = h,
        center = center
    );
}
