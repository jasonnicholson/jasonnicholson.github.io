# Verification: newton-raphson-method

All numbers from verify/check.py (run with /usr/bin/python3 -I; mpmath findroot at 40 digits, numpy for iterates). Frames checked: committed/newtonaa/sheet.png, committed/newtondd/sheet.png, committed/newtonee/sheet.png.

## A1 — confirmed
- What I checked: high-precision root of f(x)=3e^x−4cos x near the start point, and the final iterate label shown in the GIF.
- Evidence: mp.findroot gives x* = 0.25485005902885...; Newton from x0=1 reaches 0.25485005902899 by x5. GIF frames 4–5 legend reads "x₄ = 0.25485", "x₅ = 0.25485". f(0.2910) = 3e^0.291 − 4cos(0.291) ≈ 0.181 ≠ 0. So both "x* ≈ 0.2910" (line 20) and "x≈0.291" (alt text, line 25) are wrong; correct value ≈ 0.2549.
- Severity: Error is fair (wrong number, contradicted by the page's own animation).

## A2 — confirmed
- What I checked: sign changes of f on [−60, 2] (600k-point grid) plus root refinement.
- Evidence: 20 sign changes on [−60, 2]; roots include −1.38121, −4.71908, −7.85369, −10.99559, … (for x→−∞, 3e^x→0 so f ≈ −4cos x, which has infinitely many zeros). f has infinitely many real roots; only one is positive (f' = 3e^x+4sin x > 0 on [0, ∞) and f(0) = −1 < 0).
- Severity: Error is fair in that it is literally false; practical impact is modest since the plotted window [0, 1.5] contains exactly one root. "The only positive root" / "the root in the plotted window" would be correct.

## A3 — confirmed
- What I checked: the computed iterates and their errors relative to x*.
- Evidence: iterates 1.0, 0.479752, 0.285738, 0.255577, 0.2548505, 0.25485006; errors +0.745, +0.225, +0.0309, +7.3e-4, +4.2e-7, +1.4e-13 — all positive, monotone decrease from the right, no sign change. This is expected: f is increasing and convex on the interval (f'' = 3e^x + 4cos x > 0), so Newton approaches monotonically from one side. GIF frames show tangents all landing to the right of the root. The quadratic-convergence part of the sentence is correct (error ratio e_{n+1}/e_n² ≈ 0.4–0.8); only the "overshoots then undershoots" part is false.
- Severity: Error is fair.

## A4 — confirmed
- What I checked: real roots of x³ − x + 3 and its critical points.
- Evidence: numpy.roots → −1.67169988 (real), 0.83585 ± 1.04687i. Any real cubic has at least one real root. The "minimum value above zero" is the local minimum at x = 1/√3 ≈ 0.5774, f = 2.6151 > 0; there is no global minimum (f → −∞ as x → −∞). Newton's failure from x0 = 0 is caused by the starting point being trapped in an attracting cycle on the positive side, not by absence of a root.
- Severity: Error is fair. Also affects the section heading on line 44 ("No real root") and alt text on line 51 ("when no real root exists"), as the allegation lists.

## A5 — confirmed
- What I checked: Newton iterates for f(x) = x e^{−x} from x0 = 2, and the map analytically.
- Evidence: iterates 2.0, 4.0, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188 — monotonically increasing. Analytically N(x) = x − x/(1−x) = x + x/(x−1) > x for all x > 1, so iterates move rightward forever and x_n → +∞ (f(x_n) → 0 but no root there). GIF frames confirm: legend x₆ = 10.0188, tangents step rightward. The script's own header says "Diverging to Infinity". "Large jumps leftward" and "convergence is eventual … to the root at x = 0" (lines 55–56, alt text line 60) are both false; the heading "Convergence with vanishing derivative" (line 53) is also wrong. (The sub-claim that f'(x) = (1−x)e^{−x} is small and negative for large x is true.)
- Severity: Error is fair.

## A6 — confirmed
- What I checked: long-run behavior of the Case 4 iterates (200 steps).
- Evidence: iterates 0, 3, 1.9615, 1.1472, 0.00658, 3.00039, 1.96182, 1.14743, 0.00726, 3.00047, 1.96188, … ; after 200 steps they settle into an attracting 4-cycle ≈ {0.007446, 3.000498, 1.961897, 1.147502}; max |x| over 200 steps = 3.000498. They never diverge. "Cycle" is correct; "or diverge" and "divergent cycling" are not.
- Severity: Misleading is fair ("cycle or diverge" is a hedge, but a reader would take divergence as a possibility here, and the alt text asserts it). Minor note: it is a 4-cycle (0→3→1.96→1.15→0), not a 2-cycle "between ~0 and ~3" as the script comment says; the page itself doesn't specify the period.
