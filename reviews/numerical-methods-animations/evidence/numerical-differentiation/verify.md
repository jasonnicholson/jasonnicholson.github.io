# Verification: numerical-differentiation

## A1 — confirmed with correction
- What I checked: I recomputed the max error for each frame of numdiffaa.jl in numpy, printed Julia's `round(maxerr; digits=6)` strings, and viewed full-size committed frames 7-12.
- Evidence: verify/check.py. True max errors: h=0.01 -> 3.33e-5, 0.005 -> 8.33e-6, 0.002 -> 1.33e-6, 0.001 -> 3.33e-7 (err/h^2 -> 1/3, so the math is correct and second order). Julia formats these as "3.3e-5", "8.0e-6", "1.0e-6", "0.0". The 760 px-wide title (size set at line 40, title at line 42) is clipped at the right edge. Frames 9/10/11 show "max error ≈ 3.3", "≈ 8.0" and "≈ 1.0" with no exponent visible. Frame 12 shows "≈ 0". Frames 7/8 show "0.00" and "0.000" (truncated digits, still small). A reader sees the error drop to about 0.000 and then jump to 3.3, 8.0 and 1.0, which is 10^5-10^6 times too large.
- Severity: Error is fair. The number shown on screen is false.
- Correction to the allegation: Frame 12's "0" does not come from clipping. `round(3.3e-7; digits=6)` is already 0.0, and clipping only removes the ".0". The digits=6 rounding also hides precision in frames 10-11 (1.0e-6 vs the true 1.33e-6). So a fix needs both a shorter or wrapped title and significant-figure formatting such as `@sprintf("%.2e")`. Line references 40 and 42 are correct.

## A2 — confirmed
- What I checked: In numdiffab.jl, line 37 draws `secant_y = y0 + msec*(x - x0)`, and line 58 plots it with the label "central secant slope". I computed the drawn line's vertical gap at x0±h from f(x0±h), and I viewed frames 1 and 3.
- Evidence: verify/check.py. The gap at both stencil points equals y0 - (f(x0-h)+f(x0+h))/2 ≈ -(h^2/2) f''(x0) = 0.078 (h=0.6), 0.033 (h=0.4), 0.0126 (h=0.25), 0.0045 (h=0.15). The y-range is only 0.65. In frame 1 the dashed line passes about 0.08 above both outer orange points (it sits near 0.34 at x=0.4, where the point is at 0.26). The gap is clearly visible in frames 1-3 and closes as h shrinks.
- Severity: Misleading is fair. The slope is correct and the legend says "slope", so the line is narrowly defensible as a parallel line through x0. But the page alt text (index.qmd line 40) says "central secant lines", and line 36 talks about "the symmetric secant". A reader expects the chord through the stencil points and sees a "secant" that misses them.
- Correction to the allegation: none. Aside, not alleged: the numdiffab titles are also clipped at the right edge (frame 1 shows "true = -0.11079"), and the rendered legend shows only "f" for the label "f(x) = e^{-x} sin(x)".
