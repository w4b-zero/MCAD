/*
 * Dan Kirshner - dan_kirshner@yahoo.com
 *
 * You are welcome to make free use of this software.  Retention of my 
 * authorship credit would be appreciated.
 *
 * Version 1.3.  2013-12-01   Correct loop over turns -- don't have early cut-off
 * Version 1.2.  2012-09-09   Use discrete polyhedra rather than linear_extrude()
 * Version 1.1.  2012-09-07   Corrected to right-hand threads!
 */

// Examples:
//metric_thread(8, 1, 10);
//english_thread(1/4, 20, 1);

// Rohloff hub thread:
//metric_thread(34, 1, 10, internal=true, n_starts=6);

// ----------------------------------------------------------------------------
pi = 3.14159265;


// ----------------------------------------------------------------------------
function segments(diameter) = min(50, ceil(diameter*6));


function rotate_vector (rotate, coord) =
[
	cos (rotate) * coord[0] + sin (rotate) * coord[1],
	cos (rotate) * coord[1] - sin (rotate) * coord[0]
];

// ----------------------------------------------------------------------------
// internal - true = clearances for internal thread (e.g., a nut).
//            false = clearances for external thread (e.g., a bolt).
//            (Internal threads should be "cut out" from a solid using
//            difference()).
// n_starts - Number of thread starts (e.g., DNA, a "double helix," has
//            n_starts=2).  See wikipedia Screw_thread.
module metric_thread (
    diameter = 8,
    pitch = 1,
    length = 1,
    internal = false,
    n_starts = 1,
    thread_facets = 30
)
{
    // see https://en.wikipedia.org/wiki/ISO_metric_screw_thread
    Dmaj = diameter;
    H = cos (30) * pitch;
    Dmin = Dmaj - 2 * 5/8 * H;
    Droot = Dmin - 2 * H/4;     // base of thread triangles
    turns = length / pitch / n_starts;

    // angle of turn from beginning to peak of tooth
    peak_angle = 180 / n_starts;
    delta = peak_angle * 2 / thread_facets;

    // functions for generating the curve
    function normalize_angle (angle) = peak_angle - abs (peak_angle - angle);
    function length_for_angle (angle) = Droot/2 +
    normalize_angle (angle) / peak_angle * H;
    function get_vertex (angle) = rotate_vector (angle,
        [-length_for_angle (angle), 0]);

    linear_extrude (height=length, twist=-turns*360, $fa=10, $fs=0.1)
    intersection() {
        union () {
            // solid Dmin cylinder
            if (internal) {
                circle (d=Dmin);
            } else {
                // magic value copied from previous implementation
                circle (d=Dmin - 2 * 0.3/8 * H);
            }

            // cross-section of thread-starts
            for (start = [0:n_starts])
            rotate ([0, 0, start / n_starts * 360])
            for (angle = [0:delta:peak_angle * 2]) {
                polygon (points=[
                        [0, 0],
                        get_vertex (angle),
                        get_vertex (angle + delta + 0.1)
                    ]);
            }
        }

        // cut off everything outside Dmaj.
        if (internal) {
            circle (d=Dmaj + H/20); // internal relief
        } else {
            circle (d=Dmaj);
        }
    }
}

// ----------------------------------------------------------------------------
// Input units in inches.
// Note: units of measure in drawing are mm!
module english_thread(diameter=0.25, threads_per_inch=20, length=1,
                      internal=false, n_starts=1)
{
   // Convert to mm.
   mm_diameter = diameter*25.4;
   mm_pitch = (1.0/threads_per_inch)*25.4;
   mm_length = length*25.4;

   echo(str("mm_diameter: ", mm_diameter));
   echo(str("mm_pitch: ", mm_pitch));
   echo(str("mm_length: ", mm_length));
   metric_thread(mm_diameter, mm_pitch, mm_length, internal, n_starts);
}
