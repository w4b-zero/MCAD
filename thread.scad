

// Parameters
radius=5;
depth=1;
pitch=10;
length=30;

facets=36;
slices=48;


// Math Functions

function trapezoid(o) 		= 4*(floor(o*4)==0 ? o:
								floor(o*4)==1 ? 0.25:
									floor(o*4)==2 ? 0.75-o:
										floor(o*4)==3 ? 0:0)-0.5;

function threadProfile(o) 	= radius+depth*trapezoid(o);

function threadX(i,facets) 	= radius*threadProfile(i/facets)*cos(i*360/facets);
function threadY(i,facets) 	= radius*threadProfile(i/facets)*sin(i*360/facets);

translate([0,0,-length/2])
linear_extrude(
		height=length, 
		center=false, 
		twist=360*length/pitch, 
		slices=slices*length/pitch)
	union()
	{
		for (i=[0:facets-1])
		{
			polygon(
				points=[
					[0,0],
					[threadX(i,facets),threadY(i,facets)],
					[threadX(i+1,facets),threadY(i+1,facets)]],
				paths=[
					[0,1,2]]);
		}
	}