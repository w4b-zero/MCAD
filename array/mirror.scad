/**
 * Render an object as well as its mirror.
 */
module mcad_mirror_duplicate (axis)
{
    children ();

    mirror (axis)
    children ();
}
