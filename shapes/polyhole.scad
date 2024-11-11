// Copyright 2011 Nophead (of RepRap fame)
// This file is licensed under the terms of Creative Commons Attribution 3.0 Unported.

// Using this holes should come out approximately right when printed

module mcad_polyhole(r = undef, d = undef, h = undef, center = false) {
    _r = (r == undef) ? d / 2 : r;
    _d = (d == undef) ? r * 2 : d;

    n = max (round (2 * _d), 3);
    flat = (h == undef);

    rotate([0,0,180])
        if (flat)
            circle (r = _r / cos (180 / n), $fn = n);
        else
            cylinder (
                h = h,
                r = _r / cos (180 / n),
                center = center,
                $fn = n
            );
}
