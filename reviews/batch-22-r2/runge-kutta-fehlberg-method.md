# Runge-Kutta-Fehlberg Method — batch 22 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/runge-kutta-fehlberg-method/index.qmd`, overview page, light-pass batch 22. The diff changes only `index.qmd`, so no script or GIF is under review. I consulted the Mathews archive: the text of `n2003/RungeKuttaFehlbergMod.html` and its formula images `RungeKuttaFehlbergMod_gr_2.gif` to `gr_5.gif` (the six stages, y_{j+1}, z_{j+1} and s). I did not run MATLAB or quarto and changed nothing in the repository. My scratch scripts are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22r2/runge-kutta-fehlberg-method/reviewer/`: `rkf.py` (my own Python copy of the script's integrator), `case1.py`, `case2.py`, `stages2.py` and `brk.py`.

## Part 1: Findings

**F1. Page text, Minor. The explanation of Case 1's global error leaves out that the error estimate itself is too small.**
- **Where:** Description, line 56: "In [Case 1](#case-1) the accepted estimates $|y_5 - y_4|$ add up to $5.6\times10^{-7}$, yet RKF45 ends $4.5\times10^{-3}$ from the exact $y(1.1) = 139.88$: near the pole … a small error in $y$ at $t = 0$ grows about $1.6\times10^{4}$ times by $t = 1.1$." Line 57 then shows the estimate failing only for a step Case 1 never takes: "from $t = 0$ with $h = 0.25$ …".
- **What is wrong:** Every number in the sentence is right: the sum is 5.588e-7, the final error is 4.517e-3, and the growth factor is (1+y(1.1)²)/(1+0.25) = 15655. But the sentence suggests that growth alone turns the accepted estimates into the 4.5e-3 error.
- **What is true:**
  - If each accepted estimate grows by its own factor G(t) = (1+y(1.1)²)/(1+y(t)²) up to t = 1.1, the total is only 2.16e-3.
  - The true local errors of the accepted RKF45 steps sum to 8.02e-7, not 5.6e-7. Grown the same way, they give 4.517e-3, which is the actual final error.
  - Nearly half the gap comes from one step that Case 1 does take: the step at t = 0.1 with h = 0.1360. Its estimate is 1.72e-8, its true local error is 1.81e-7 (10.5 times larger), and it alone contributes 2.08e-3 of the 4.52e-3.
  - So Case 1 already shows the "estimate holds only for small h" failure that line 57 illustrates with a hypothetical h = 0.25 step.
- **How I know:** `case1.py` and `brk.py`. The true local error is measured against the exact local solution through (t_j, y_j), which is tan(t + atan y_j − t_j), in 40-digit mpmath. Output:
  - "sum est*G 0.002163917…"
  - "sum true local 8.022e-07, sum true local*G 0.0045166…"
  - step 1: "h 0.1360 est 1.722e-08 true 1.814e-07 ratio 10.54 contrib 0.002078".
- **Suggested fix:** On line 57, use Case 1's own step instead of, or as well as, the h = 0.25 one. For example: "In Case 1 itself, the step from t = 0.1 with h = 0.136 has an estimate of 1.7e-8 but a true error 10.5 times larger, and that step alone accounts for about half of the final 4.5e-3."

No other findings. On fidelity: the Description gives the page's acceptance test, |y5 − y4|/h ≤ ε. Mathews' subroutines use |y5 − y4| < ε or h < 2h_min instead. The unchanged Animations introduction says this ("The step controller is not the module's"), so I do not count it as a Fidelity finding. The stage formulas, both updates and the s formula match the module's images exactly.

## Part 2: Claim ledger (the `+` lines of the diff)

| # | Claim (page's words, abridged) | Verdict | Evidence |
|---|---|---|---|
| 1 | L12: RKF45 is an adaptive-step one-step solver for y' = f(t,y), y(t0) = y0 | confirmed | Script lines 11–46 |
| 2 | L13: embedded 4th- and 5th-order approximations from the same stages; local error from their difference; step size adjusted to a tolerance | confirmed | Script lines 24–45 |
| 3 | L14–25: the six stages k1…k6 and their coefficients | confirmed | Identical to script lines 24–29 and to Mathews gr_2.gif. Halving ratios (rows 15–16) show orders 4 and 5. |
| 4 | L27–34: y4 and y5 coefficients | confirmed | Identical to script lines 31–32 and to Mathews gr_3/gr_4 (y_{j+1}, z_{j+1}) |
| 5 | L36: \|y5 − y4\| estimates the local error of y4 | confirmed (asymptotically) | Halving at t = 0: estimate 6.51e-13 against true error 6.02e-13 at h = 0.0125. See row 18 for where it fails. |
| 6 | L37: it shrinks like h^5, so \|y5 − y4\|/h shrinks like h^4 | confirmed | Halving 0.025 → 0.0125 divides the estimate by 30.7 (2^5 = 32) |
| 7 | L38: accept when \|y5 − y4\|/h ≤ ε; RKF45 carries y4; the RKF54 variant carries y5 | confirmed | Script lines 37–39 (the extra `h <= hmin` clause never fires, row 9). The module's RKF54 remark matches. |
| 8 | L39–43: accepted or not, h_new = s·h with s = 0.84(εh/\|y5 − y4\|)^{1/4} | confirmed | Script lines 44–45 run after both branches. The err = 0 → s = 2 special case is not mentioned and is immaterial. |
| 9 | L45: clamped to at most h_max = 0.25 and at least h_min = 1e-6, which neither case reaches; a rejected step is retried from the same point | confirmed | Smallest trial h: Case 1 RKF45 2.83e-5, RKF54 2.82e-5; Case 2 RKF45 2.74e-2, RKF54 6.39e-4 (a truncated last step). Rejected steps leave t and y unchanged. |
| 10 | L46: 0.84 rounds Mathews' 2^{-1/4} | confirmed | Mathews gr_5.gif: s = (εh/(2\|z−y\|))^{1/4} = 0.840896(…)^{1/4} |
| 11 | L46: if \|y5 − y4\| scaled exactly like h^5, the new step would bring \|y5 − y4\|/h to about ε/2 | confirmed | (err/h)·s^4 = 0.84^4·ε = 0.498ε |
| 12 | L48: needs f continuous and Lipschitz in y near the solution (uniqueness), and smooth enough for the orders | confirmed | Standard result, correctly hedged |
| 13 | L49: in Case 2, f = 1 − t∛y is not differentiable at y = 0, but the solution stays above y(5) ≈ 0.00812 | confirmed | mpmath odefun gives y(5) = 0.0081199205. On a 50001-point grid the minimum is at t = 5 and the solution is decreasing after t ≈ 0.88. Every RKF stage argument also stays ≥ 0.008118 (`stages2.py`). |
| 14 | L51: if f has continuous partials through order 5, then y ∈ C^6; local errors O(h^5) and O(h^6); for small h, y5 − y4 is dominated by the error of y4; fixed-step global errors O(h^4) and O(h^5) | confirmed | Correct hypotheses (f ∈ C^5 gives y' ∈ C^5, so y ∈ C^6). Rates confirmed on the case in rows 15–16. |
| 15 | L52: on Case 1's problem, halving one step at t = 0 from 0.025 to 0.0125 divides \|y5 − y4\| by 30.7 | confirmed | 30.707 (mpmath), 30.700 (float64) |
| 16 | L52: …and the errors of y4 and y5 by 27.9 and 65.6, near 32 and 64 | confirmed | 27.887 and 65.561 (mpmath); float64 gives 27.88 and 65.44 because of rounding at 5e-14 |
| 17 | L53: the animations show the step-size controller, not these rates | confirmed | Frames: trajectories only, no error-against-h plot |
| 18 | L55: the tolerance bounds local, not global, error | confirmed | Accepting err/h ≤ ε bounds Σ err ≤ 1.1ε. The final error is 4.5e-3. |
| 19 | L56: in Case 1 the accepted estimates add up to 5.6e-7 | confirmed | 5.588e-7 for both RKF45 and RKF54 |
| 20 | L56: RKF45 ends 4.5e-3 from the exact y(1.1) = 139.88 | confirmed | 4.5168e-3; y(1.1) = 139.8828 |
| 21 | L56: pole of tan(t + arctan 0.5) at t ≈ 1.1071 | confirmed | π/2 − atan 0.5 = 1.107149 |
| 22 | L56: a small error in y at t = 0 grows about 1.6e4 times by t = 1.1 | confirmed (number); see F1 for the explanation it is used for | (1+y(1.1)²)/1.25 = 15654.6. This agrees with the intro's 1.1e4, which is measured from t = 0.25: 19568/1.7494 = 11186. |
| 23 | L57: from t = 0 with h = 0.25, \|y5 − y4\| = 1.7e-7, but the true error of y4 is 34 times larger | confirmed | Estimate 1.673e-7, true error of y4 5.737e-6, ratio 34.29. Consistent with the intro's 5.6–5.7e-6. |
| 24 | L57: link [Animations](#animations) | confirmed | Quarto's automatic id for `## Animations` |
| 25 | L59: the Euler, Heun, Taylor Series, Runge-Kutta, ABM and Milne-Simpson pages solve Case 2's problem with fixed steps | confirmed | All six folders exist with `index.qmd`. Each animates y' = 1 − t∛y, y(0) = 1 on [0,5] with fixed m subintervals (Milne-Simpson Case 1; Heun Cases 1–2). |
| 26 | L59: Adaptive Simpson's Rule uses the same compare-two-estimates idea for integrals | confirmed | That page exists, and its line 12 describes a local error estimate with halving |
| 27 | L49/L56 links [Case 2](#case-2) and [Case 1](#case-1) | confirmed | The diff adds `{#case-1}` and `{#case-2}` to the two case headings |

## Part 3: Checks (overview mode; no script changed)

- **The six points:**
  - Problem: L12–13.
  - Core formula: L14–45, display math in the scripts' notation (k1…k6, y4, y5, h, ε).
  - Assumptions: L48–49.
  - Accuracy, as a general result with hypotheses and checked on Case 1's problem: L51–53.
  - Failure modes, linked to Case 1 and the Animations intro: L55–57.
  - Where it fits: L59.
  - All present. There is no callout box, proof or theorem box.
- **Word count:** 426 whitespace tokens, of which 28 are punctuation left after inline math is collapsed, giving **398** prose words. This agrees with the manifest and is within 150–400, though only just.
- **Formulas against the scripts:** the stages, updates, acceptance test, s, h_max and h_min all match `rungekuttafehlbergaa.jl` lines 24–45 (`bb.jl` is identical apart from f, interval and plotting, by `diff`). My Python copy reproduces the page's counts: Case 1 has 259 points and 4 rejections; Case 2 has 80 points for RKF45 and 81 for RKF54.
- **Frames:** I looked at the last frame of each GIF. Case 1 has a log axis, the curves coincide with the exact solution up to about 140, and the legend reads Exact/RKF45/RKF54. Case 2 has the hump at about 1.45 and the tail at about 0.008. Nothing contradicts the new text.
- **Links and anchors:**
  - `#case-1` and `#case-2` are explicit ids added by the diff.
  - `#animations` is the automatic id.
  - The seven relative page links all resolve to existing `pages/numerical-methods/<slug>/index.qmd`.
- **Scope of the diff:**
  - The only changes outside the Description are the two heading ids (allowed).
  - No sentences were moved; the Animations introduction is unchanged.
  - No script or GIF was changed.
- **Contradictions with the rest of the page:** none. The Description's 1.6e4 and the intro's 1.1e4 measure growth from different starting times (t = 0 and t = 0.25), and both are correct.
