/**
 * Duplicate children and apply transformations. There will be one copy of
 * children() per transformation matrix provided.
 *
 * @param transformations List of transformations to apply to children()
 * @Param keep_original Whether or not to show the original child
 */
module mcad_multiply (transformations, keep_original = true)
{
    if (keep_original)
        children ();

    for (t = transformations)
        multmatrix (t)
            children ();
}
