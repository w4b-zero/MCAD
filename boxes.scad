use <MCAD/shapes/3Dshapes.scad>

// @deprecated
module roundedBox (size, radius, sidesonly, center = true)
{
    mcad_rounded_cube (size, radius, sidesonly, center);
}

// @deprecated
module roundedCube (size, r, sidesonly, center = true)
{
    mcad_rounded_cube (size, r, sidesonly, center);
}
