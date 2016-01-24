use <MCAD/array/generic-multiply.scad>
use <scad-utils/transformations.scad>

/**
 * Convert vector of points to vector of translation matrices
 *
 * @param points Vector of points
 * @returns Vector of translation matrices
 **/
function mcad_points2translations (points) = [
    for (point = points)
        translation (point)
];

/**
 * Generate vector of points that represents grid
 *
 * @param grid_size 2- or 3-vector indicating grid size in terms of elements
 * @param separation 2- or 3-vector indicating separation in respective axes
 * @param center Boolean or vector indicating which axes to center
 */
function mcad_generate_grid (grid_size, separation, center = false) = (
    let (sep = len (separation) > 0 ? sep : [1, 1, 1] * separation)
    let (g = grid_size)
    (len (grid_size) == 2) ? [
        for (x = [0 : grid_size[0] - 1])
            for (y = [0 : grid_size[1] - 1])
                ([x * sep[0], y * sep[1]] -
                 ((center) ? [g[0] * sep[0], g[1] * sep[1]] / 2 : [0, 0]))
    ] :
    (len (grid_size) == 3) ? [
        for (x = [0 : g[0] - 1])
            for (y = [0 : g[1] - 1])
                for (z = [0 : g[2] - 1])
                    ([x * sep[0], y * sep[1], z * sep[2]] -
                     ((center) ?
                      [g[0] * sep[0], g[1] * sep[1], g[2] * sep[2]] / 2 :
                      [0, 0, 0]
                     ))
    ] : []
);


/**
 * Place children at points
 *
 * @param List of points.
 */
module mcad_place_at (points)
{
    mcad_multiply (mcad_points2translations (points), keep_original = false)
        children ();
}

/**
 * Test mcad_place_at module
 */
module mcad_test_place_at ()
{
    mcad_place_at (mcad_generate_grid ([10, 10, 10], separation = $t * 10,
                                       center = true));
}
