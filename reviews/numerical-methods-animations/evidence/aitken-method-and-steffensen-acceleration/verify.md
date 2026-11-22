# Verification: aitken-method-and-steffensen-acceleration

## A1 — confirmed
- What I checked: Re-ran the Steffensen loop from aitkenab.jl (lines 32–43) verbatim, without plotting, in verify/iterates.jl. Also evaluated f at the stalled iterate in 50-digit mpmath, and looked at the committed final frame committed/aitkenab/frame_023.png.
- Evidence (julia verify/iterates.jl):
  - Errors |x_k − 1| for k = 0..7: 1.0, 5.75e-2, 2.80e-4, **6.556e-9**, then 6.556e-9 four more times (k = 4..7 are identical).
  - At i = 4, x = 0.9999999934439675. Float64 evaluation of x^3−3x+2 gives exactly 0.0 (the true value is 1.29e-16, which is below the rounding level of the O(1) terms). So q1 = q2 = x, denom = 0.0, the `abs(denom) < 1e-15` guard (lines 39–40) fires, and `xS[5:end] .= xS[4]` fills the rest with copies.
  - Frame 023: the red curve drops to log10 err ≈ −8.18 at k = 3 and stays flat with markers at k = 3, 4, 5, 6, 7. The legend reads "Steffensen (7 steps)" and the label reads "S_7=1.0" (rounded to 5 digits, which hides the 6.6e-9 error). The y-axis goes down to −17, so the gap to machine precision shows clearly.
  - The best error is 6.6e-9 against eps = 2.2e-16. This is the sqrt(eps) limit on attainable accuracy for a double root in floating point, so "reaching machine precision" is false.
- Severity: Error is fair. The page states something that is not true of the computation, and the GIF directly below contradicts it.
- Correction to the allegation: none of substance. Strictly, the guard is what *produces* the copies; it does not cause the stall. The stall comes from f rounding to exactly 0 near a double root, which is inherent and not a bug in the guard. The copied steps are drawn as 4 extra markers and counted in the "7 steps" legend.

## A2 — confirmed
- What I checked: Re-ran the Steffensen loop from aitkenef.jl (lines 37–50) verbatim in verify/iterates.jl. Compared the Float64 f values with 50-digit mpmath values at each late iterate. Looked at committed/aitkenef/frame_023.png.
- Evidence:
  - Errors |x_k − √3| for k = 0..6: 2.32e-1, 1.94e-2, 2.19e-4, **2.76e-8, 5.44e-8, 2.15e-8, 1.46e-8**. After k = 3 the error does not keep shrinking. It goes up, then down, wandering between 1e-8 and 6e-8 (log10 −7.56, −7.26, −7.67, −7.84). No guard fires: all 6 steps are genuine.
  - The f values in that region are about 1e-14, which is the same size as the rounding error of evaluating x^6−7x^4+15x^2−9 with terms around 10–60 (about 50·eps ≈ 1e-14). The Float64 vs exact values are 2.13e-14 vs 1.83e-14, 7.82e-14 vs 7.11e-14, and 7.1e-15 vs 5.1e-15. At i = 6, f(q1) rounds to 0, so q2 = q1. The steps are driven by rounding noise.
  - Frame 023 shows the red curve flattening and wiggling near −7.5 to −7.8. Newton reaches log10 err ≈ −7.6 by k = 22, the same level, so Steffensen ends no more accurate than Newton.
- Severity: Misleading is fair. It is narrowly defensible that Steffensen reaches its limiting accuracy (about 1e-8, roughly sqrt(eps)) in 3 steps. But "converges" followed by a wandering, non-improving tail would leave a reader thinking it converges to the root to full precision.
- Correction to the allegation: none. The stall happens from k = 3 onward, and "rounding in the polynomial evaluation" is the correct cause, as confirmed above.
