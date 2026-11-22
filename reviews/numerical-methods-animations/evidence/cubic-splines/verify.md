# Verification: cubic-splines

## A1 — confirmed (with a small precision note)
- What I checked: I measured the max-norm error of the natural cubic spline on equally spaced nodes as h is halved. I used the script's own `natural_spline_M` / `spline_eval_point` (copied into verify/copy.jl) and, separately, scipy's `CubicSpline(bc_type="natural")` (verify/rates.py). Both give the same errors to all printed digits. I also measured the error on the middle half of the interval, away from the endpoints.
- Evidence (`julia copy.jl`, `python3 rates.py`). Error ratio each time h is halved (16 means O(h^4), 4 means O(h^2)):
  - sin x on [0,2π] (the animation's case, where f''(0)=f''(2π)=0): ratios 16.9, 16.2, 16.1, 16.0, 16.0. Rate 4.00.
  - cos x on [0,2π]: ratio 4.0. Max error 2.958e-5 at 257 nodes, against 9.451e-10 for sin.
  - sin x on [0,π/2] (f''(0)=0, f''(π/2)=−1≠0): rate 2.00.
  - exp x on [0,1]: rate 2.00. 1/(1+x²) on [0,2]: 2.00. x³ on [0,1]: 2.00.
  - Middle half of the interval: rate 4 in every case. The O(h^2) error sits in a boundary layer near any endpoint where f''≠0.
  - Same f = exp, other boundary conditions (verify/other_bc.py): clamped with exact f' gives rate 4.00, not-a-knot gives 3.99, natural gives 2.00.
- Severity: Error is fair. As a general statement, "The natural cubic spline converges at O(h^4) for smooth functions" is false. The O(h^4) behaviour in the animation comes from sin having zero second derivative at both 0 and 2π, so the natural condition S''=0 happens to be exact there. This is a coincidence of the test function, and the page never says so.
- Correction to the allegation: "only O(h^2)" holds for the global (max-norm) error. The interior error away from the endpoints is still O(h^4). Also, the 3–9 nodes shown in the animation are pre-asymptotic: their ratios are 9.2, 5.4, 2.2, 2.2 and 3.8, so the frames don't show a clean rate of either kind.

## A2 — confirmed
- What I checked: line 21 in context (lines 15–21). Lines 15–19 introduce only the natural boundary conditions. Line 21 then says "For smooth functions, spline interpolation error typically scales like O(h^4)." I tested which boundary conditions actually give O(h^4).
- Evidence: verify/other_bc.py and verify/rates.py (numbers above). O(h^4) holds for clamped with exact derivatives and for not-a-knot. Natural gives O(h^2) for every test function except one with f''=0 at both ends.
- Severity: Misleading is fair. Read narrowly, the sentence is true ("spline interpolation" in general, "typically"). But it is the only rate given, it follows directly after a description that covers only natural splines, and line 31 then states it outright for natural splines. A reader would conclude that natural splines are O(h^4) in general, which is wrong.
- Correction to the allegation: none. Line numbers and quoted text are accurate.
