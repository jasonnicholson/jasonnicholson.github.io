# Verification: maclaurin-and-taylor-series

## A1 — confirmed with correction
- What I checked: Read `taylor_coeffs` (series_animations_all.jl 68–121), which `render_case` uses for every Taylor case (line 248). It samples f at 2q+1 equally spaced points, with q = max(n+2, 8): 25 points for n=10 and 21 for n=8. It then solves the overdetermined system `A \ yy` (least squares) for a degree-n polynomial and calls the result the Taylor coefficients. No derivatives are computed. The sample window c ± q·h is wide compared with the radius of convergence. My own calculation from the code gives: T01 [0.05, 1.95] (R=1); T02 [0.22, 7.78]; T04 [-0.43, 2.43], with the x≤0 points dropped as NaN, so the fit runs past the radius limit x=2; T08 [0.38, 3.62]; T11 [3.4, 16.6]; T13 [0.1, 3.9]. I ran a copy of the coefficient code in Julia and compared its output with exact Taylor coefficients from `mpmath.taylor` at 40 digits. I also compared the drawn partial sums with the exact partial sums on the script's 900-point grid, clamped to the same ylims.
- Evidence:
  - verify/coeffs_copy.jl writes verify/script_coeffs.txt. verify/compare.py and verify/compare2.py compare the coefficients and curves. verify/beyond.py checks pointwise values.
  - Wrong-sign coefficients: T01 3, T02 3, T03 2, T04 2, T05 2, T08 2, T11 2, T13 3. T06, T07, T09, T10 and T12 have none.
  - Magnitudes:
    - T01 (sqrt at 1): a5 is 0.191 against the true 0.0273. a8 is 0.448 against the true -0.0131.
    - T04 (log at 1): a6 is 2.28 against -1/6, a4 is -1.32 against -1/4, and a0 is -0.0029 against 0.
    - T13 (Y0 at 2): a4 is -0.051 against +0.0064, and a5 is -0.047 against +0.0028.
    - T08 (Gamma at 2): a5 is 0.076 against -0.00027.
  - Largest gap between the drawn curve and the true T_n, as a fraction of plot height, worst frame:
    - T01, T02, T04, T05, T13: 0.8–1.0
    - T06, T07: 0.80
    - T08: 0.97
    - T11, T12: 0.46
    - T10: 0.13 (order 8 only)
    - T03: 0.058
    - T09: 0.047
  - All 13 Taylor GIFs exceed 2% of plot height (about 8 px) in at least one frame. 11 of 13 exceed 10% (more than about 40 px). Only T03 and T09 are mildly affected, and only at high orders.
  - Seen in the frames:
    - T04 order 7 (committed/series_t04/frame_008.png): the curve turns up to +2 near x=0. The true T_7 is -2.59 at x=0, and every term is negative for x<1.
    - T04 order 10: the curve follows log(x) out to x≈2.4, well past R=1 (x=2). At x=2.4 the script gives 0.880 and log gives 0.876, while the true T_10 is -0.741. This is the "appears to converge beyond the radius" effect.
- Severity: Error is fair. The page states T_n = Σ f^(k)(x0)/k!·(x−x0)^k (lines 17–19) and calls these curves Taylor polynomials, but the curves are least-squares fits.
- Correction to the allegation: The "converges beyond the radius of convergence" example holds clearly only for T04, the one case whose fit window crosses the radius. In T01, T02, T08 and T13 the fitted polynomials diverge faster beyond R than the true ones. For example, at final order and right of R, the error is 1.6e9 for the fit against 4.9e7 for the true T01, and 77 against 9.7 for T08. For the entire functions (T06, T07, T11, T12) the fit tends to look good over a wider span than the true T_n at the same order. "Many" undersells the scope: all 13 Taylor GIFs differ visibly, 11 of them badly. The Maclaurin GIFs M01–M18 use hard-coded coefficients and are not affected by this routine.

## A2 — confirmed
- What I checked: I tested the line-12 heuristic against the convergence of the series for functions on this page. The heuristic says: asymptotes, or growth unlike a polynomial, mean local-only convergence; "behaves like a polynomial" means global convergence. It also says the series, like a polynomial, has no horizontal or vertical asymptotes. The real criterion is the distance from x0 to the nearest singularity in the complex plane.
- Evidence (verify/a2.py, verify/a2b.py, mpmath at 60–200 digits):
  - Functions with horizontal asymptotes whose Maclaurin series converge everywhere:
    - e^{-x^2/2} (M10, M17): error at x=8 is 2.7e-8 with 100 terms, 1e-74 with 200 terms and 1e-163 with 300 terms.
    - The normal CDF (M18), with asymptotes 0 and 1: error at x=8 is 9e-77 with 200 terms.
    - J0 and J1 (M15, M16): error with T_120 at x=8 is about 1e-60.
    - e^{-x}cos x (M11): error with T_120 at x=8 is 5e-58.
  - Functions that grow faster than any polynomial but whose series still converge globally:
    - cosh (M12).
    - exp, the page's own example of a function that "behaves like a polynomial". It also has the horizontal asymptote y=0 as x→−∞.
  - These same series sum to functions that do have horizontal asymptotes, so "a Taylor series has no horizontal asymptotes" is false as well.
  - The cases the heuristic happens to get right fail for a different reason: complex poles. 1/(1+x^2) and atan have radius about 1, set by the singularities at ±i, not by their asymptotes. tanh is limited by its poles at ±iπ/2.
- Severity: Error is fair. As stated, the rule is false, and it is contradicted by M10, M11, M12, M15, M16, M17 and M18 on the same page, as well as by its own exp example.
- Correction to the allegation: none.
