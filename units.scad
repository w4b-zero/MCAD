/*
 * Basic units.
 * 
 * Originally by Hans Häggström, 2010.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

// Default unit of measurement is the millimetre
nm = 0.000001 * mm; // nanometre
µm = 0.001 * mm; // micrometre
um = µm; // micrometre (alternate)
mm = 1; // millimetre
cm = 10 * mm; // centimetre
dm = 100 * mm; // decimetre
m = 1000 * mm; // metre
dam = 10000 * mm; // decametre
hm = 100000 * mm; // hectometre
km = 1000000 * mm; // kilometre

// For the purposes of compatibility with Chinese, Japanese and Korean (CJK)
// characters, Unicode has symbols for:
//    nanometre (㎚) - code U+339A
//    micrometre (㎛) - code U+339B
//    millimetre (㎜) - code U+339C
//    centimetre (㎝) - code U+339D
//    kilometre (㎞) - code U+339E
㎚ = nm;
㎛ = µm;
㎜ = mm;
㎝ = cm;
㎞ = km;

inch = 25.4 * mm;

X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];

M3 = 3*mm;
M4 = 4*mm;
M5 = 5*mm;
M6 = 6*mm;
M8 = 8*mm;


// When a small distance is needed to overlap shapes for boolean cutting, etc.
epsilon = 0.01*mm;
OS = epsilon;  // Over size
