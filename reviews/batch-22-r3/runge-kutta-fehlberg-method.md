# Runge-Kutta-Fehlberg Method — batch 22 review, round 3 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

# Overview review: runge-kutta-fehlberg-method (batch 22, round 3, overview mode)

Scope: the `+` lines of `EV/diff.patch`. Only `pages/numerical-methods/runge-kutta-fehlberg-method/index.qmd` changed: the Description was rewritten (lines 12–59), and `{#case-1}` / `{#case-2}` ids were added to the two case headings. No script or GIF changed, so the animations are not under review.

I consulted the Mathews archive: `n2003/RungeKuttaFehlbergMod.html`, its formula images `gr_2` (the stages) and `gr_5` (s = (εh / (2|z−y|))^{1/4} = 0.840896(…)^{1/4}), and the module text on RKF45/RKF54. I did not run MATLAB or quarto, and I modified nothing in the repository. Scratch work is in `EV/reviewer/`: `order.py`, `ctl.py`, `c2.py` and `neg.py`, plus PNGs of the module images.

## 1. Findings

None.

Observation, not a finding: the Description gives the acceptance test |y5−y4|/h ≤ ε without saying that it is not the module's. The module's subroutines accept on |y5−y4| < ε. The Animations introduction (line 67) states this difference explicitly, and the Description is describing what the scripts do, so this is not a Fidelity departure that misleads.

## 2. Claim ledger (diff `+` lines)

| # | Claim (page's words, line) | Verdict | Evidence |
|---|---|---|---|
| L1 | RKF45 is an adaptive-step one-step solver for y'=f(t,y), y(t0)=y0 (12) | confirmed | script `rkf_integrate` |
| L2 | It computes embedded 4th/5th-order approximations from the same stages, estimates local error from their difference, and adjusts h (13) | confirmed | script lines 24–45 |
| L3 | Six stage formulas k1..k6 with c = 0, 1/4, 3/8, 12/13, 1, 1/2 and the listed a_ij (16–25) | confirmed | Identical to script lines 24–29 (aa) and 42–47 (bb), and to Mathews `gr_2`. Row sums equal c_i exactly (Fraction check). |
| L4 | y4 weights 25/216, 1408/2565, 2197/4104, −1/5 are 4th order; y5 weights 16/135, 6656/12825, 28561/56430, −9/50, 2/55 are 5th order (27–34) | confirmed | Same as the script. Exact Butcher-tree order conditions (`order.py`): y4 satisfies all 8 trees through order 4 and fails at order 5; y5 satisfies all 17 trees through order 5 and fails at order 6. |
| L5 | \|y5−y4\| estimates the local error of y4 and shrinks like h^5; /h shrinks like h^4 (36–37) | confirmed | Halving h at t=0 divides \|y5−y4\| by 30.71 (≈ 2^5). |
| L6 | Accept when \|y5−y4\|/h ≤ ε; RKF45 carries y4, RKF54 carries y5 (38) | confirmed | script `err <= tol*h`, `mode == :rkf45 ? y4 : y5` |
| L7 | Accepted or not, h_new = s h, s = 0.84(εh/\|y5−y4\|)^{1/4} (39–43) | confirmed | Script line 44 runs after the accept branch in both cases. The err == 0 → s = 2 guard is unstated but never matters here. |
| L8 | Clamped to at most h_max = 0.25 and at least h_min = 1e−6, which neither case reaches; a rejected step is retried from the same point (45) | confirmed | Smallest h tried: Case 1 is 2.83e−5 (RKF45) and 2.82e−5 (RKF54); Case 2 is 0.0274 (RKF45) and 6.4e−4 (RKF54, the truncated last step). All are above 1e−6, so the `h <= hmin` acceptance never fires. On rejection, t and y are unchanged. |
| L9 | 0.84 rounds Mathews' 2^{−1/4}; with exact h^5 scaling the new step gives \|y5−y4\|/h ≈ ε/2 (46) | confirmed | Mathews `gr_5` shows 0.840896 = 2^{−1/4}. err_new/h_new = (err/h)·s^4 = 0.84^4·ε = 0.498ε. |
| L10 | Needs f continuous and Lipschitz in y near the solution for uniqueness, and smooth enough for the orders (48) | confirmed | standard result |
| L11 | In Case 2, f = 1 − t∛y is not differentiable at y=0, but the solution stays above y(5) ≈ 0.00812 (49) | confirmed | solve_ivp at rtol 1e−12 gives y(5) = 0.0081199205; the minimum on [0,5] is at t=5, and y decreases monotonically after t ≈ 0.884. Every RKF stage argument in both runs, including rejected trials, is ≥ 0.008118 (`neg.py`). |
| L12 | If f has continuous partials through order 5 (so y ∈ C^6), the local errors are O(h^5) and O(h^6), y5−y4 is dominated by y4's error for small h, and fixed-step global errors are O(h^4) and O(h^5) (51) | confirmed | Correct general result with a sufficient hypothesis (f ∈ C^5 gives y ∈ C^6 and an increment function in C^5). |
| L13 | Case 1, halving one step at t=0 from 0.025 to 0.0125 divides \|y5−y4\| by 30.7 and the errors of y4 and y5 by 27.9 and 65.6 (52) | confirmed | In mpmath at 50 digits: 30.707, 27.887, 65.561. In float64 the y5 ratio comes out 65.44, because y5's error at h=0.0125 (4.9e−14) sits at the roundoff level; the page's value is the exact-arithmetic one. |
| L14 | The animations show the step-size controller, not these rates (53) | confirmed | frames: trajectories only, no error display |
| L15 | Case 1: accepted \|y5−y4\| sum to 5.6e−7; RKF45 ends 4.5e−3 from y(1.1) = 139.88 (56) | confirmed | sum = 5.588e−7; final error = 4.517e−3; y(1.1) = 139.8828 |
| L16 | Pole of tan(t + arctan 0.5) at t ≈ 1.1071 (56) | confirmed | π/2 − arctan 0.5 = 1.107149 |
| L17 | Errors grow up to 1.6e4-fold by t=1.1 (56) | confirmed | Growth factor (1+y(1.1)²)/(1+y(t)²) from t=0 is 15654.6. |
| L18 | Individually grown estimates give only 2.2e−3 (56) | confirmed | Σ err_j · G(t_{j+1}→1.1) = 2.164e−3. The same sum with true local errors is 4.5166e−3, which matches the final error. |
| L19 | Step h=0.136 from t=0.1 underestimates its error 10.5-fold and causes nearly half the final error (57) | confirmed | Estimate 1.722e−8 against true local error of y4 1.814e−7: ratio 10.54. Grown contribution 2.078e−3, which is 46% of 4.517e−3. |
| L20 | h=0.25 from t=0: 34-fold, as in the Animations introduction (57) | confirmed | Estimate 1.673e−7; true error of y4 is 5.737e−6 (ratio 34.3) and of y5 is 5.570e−6. This agrees with the intro's 1.7e−7 and 5.6–5.7e−6. |
| L21 | Euler, Heun, Taylor Series, Runge-Kutta, ABM and Milne-Simpson pages solve Case 2's problem with fixed steps (59) | confirmed | Each page exists and uses y'=1−t∛y, y(0)=1 on [0,5] with h=5/m (Milne-Simpson as its Case 1, Mathews Example 4). |
| L22 | Adaptive Simpson's Rule uses the same compare-two-estimates idea (59) | confirmed | Its Description compares S(a,b) with S(a,m)+S(m,b). |
| L23 | Heading ids {#case-1} and {#case-2} on lines 94 and 111; links #case-1, #case-2, #animations (49, 56, 57) | confirmed | Explicit ids are present. `## Animations` gets Quarto's automatic id `animations`. |
| L24 | Wiring: Case 1 is the aa GIF (y'=1+y², log axis, end ≈ 139.9) and Case 2 is the bb GIF (y'=1−t∛y) | confirmed | Checked against the last aa frame and the bb contact sheet. |

## 3. Checks

**Six points of the overview standard:** all present.
1. Problem (line 12).
2. Core formulas as display math in the scripts' notation: k_i = h f, y4, y5, h_new (lines 16–45).
3. Assumptions: continuity, Lipschitz, smoothness, and the Case 2 non-differentiability (48–49).
4. Accuracy as a general result with its hypothesis, checked on Case 1 (51–53).
5. Failure modes: the tolerance is local not global, and the estimate is unreliable at large h, with a link to Case 1 (55–57).
6. Where it fits: related pages (59).

There are no proofs or theorem boxes.

**Word count:** 399 by the director's count and 398 by mine (prose with inline math counted as one word and display math excluded). This is within 150–400.

**Links:** all seven relative page links resolve to existing `index.qmd` files. The anchors `#case-1`, `#case-2` and `#animations` resolve.

**Diff outside the Description:** only the two heading ids were added, which the rules allow. Nothing moved out of the Animations introduction, and no other section changed. The old Description's content (accept rule, s formula, h_max, h_min not reached) is kept in the new one.

**Consistency with the rest of the page:**
- The 0.136 step and 4.5e−3 / 139.88 / 1.1071 match the Case 1 Behavior.
- 34-fold matches the Animations introduction's numbers.
- y(5) ≈ 0.00812 matches the Case 2 reference and other pages.

No contradictions found.

**Implementation:** not under review, since no script or GIF changed. My Python replica of the shared `rkf_integrate` (same operation order) reproduces the page's Case 1 figures: 259 points, 4 rejections, RKF45 error −4.517e−3 and RKF54 error −3.154e−3 at t=1.1. It also gives 80 and 81 points for Case 2.
