use <../libtriangles.scad>;

//all of these follow the (X,Y,Z) syntax

translate(v = [0, 0, 0])eqlpyramid(10,20,30);
translate(v = [20, 0, 0]) rightpyramid(10,20,30);
translate(v = [40, 0, 0]) cornerpyramid(10,20,30);
translate(v = [60, 0, 0]) rightprism(10,20,30);
translate(v = [80, 0, 0]) eqlprism(10,20,30);

