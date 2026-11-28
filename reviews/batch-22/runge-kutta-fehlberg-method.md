# Runge-Kutta-Fehlberg Method — batch 22 review, round 1 (overview mode)

SUMMARY: 2 Error, 0 Misleading, 1 Minor

Review of `pages/numerical-methods/runge-kutta-fehlberg-method/index.qmd`, light-pass batch 22, overview page, action *extend*. Evidence folder EV = /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22/runge-kutta-fehlberg-method. My scratch files are in EV/reviewer/: check.py (order conditions), run.py (controller replica and the numeric claims), half.py (halving ratios, float vs mpmath), stage.py (Case 2 stage arguments), cex.py (counterexample).

I consulted the Mathews archive: `n2003/RungeKuttaFehlbergMod.html` and its formula images gr_2 to gr_5 (stages, y_{j+1}, z_{j+1}, and the s formula). I did not run MATLAB or quarto, and I changed nothing in the repository. The diff changes only index.qmd, with no script or GIF, so the animations were not re-reviewed.

## 1. Findings

**F1. Page text. Error. Hypothesis for the order claims is on the wrong object (line 51; also line 48).**
- **What the page says now (line 51):** "In general, if the solution has six continuous derivatives, one step of the 4th-order formula has local error $O(h^5)$ and one step of the 5th-order formula $O(h^6)$, so for small $h$ the difference $y_5 - y_4$ is dominated by the error of $y_4$". Line 48 says the method needs "the solution smooth enough for the orders below".
- **What is true instead:** the local-error orders of a Runge-Kutta formula need $f$ itself to be smooth near the solution, not just the solution. The stages evaluate $f$ at points off the solution curve. A smooth solution does not imply a smooth $f$ there.
- **How I know (cex.py, mpmath at 60 digits):**
  - Setup: $y^*(t) = \sin t + 2$ (C^∞) is the unique solution of $f(t,y) = \cos t + (y - y^*(t))\,\varphi(t)$, with $\varphi(t) = \sqrt{t - 0.3}$ for $t > 0.3$ and $0$ otherwise. This $f$ is continuous and Lipschitz in $y$, so every hypothesis the page states holds.
  - One RKF step from $t = 0.3$, exact start, $h = 2^{-3}, \dots, 2^{-10}$:
    - The error of $y_5$ falls by 30.9, 30.5, 30.7, 31.0, 31.3, 31.5, 31.7 per halving. That is → 32, so it is $O(h^5)$, not $O(h^6)$.
    - The error of $y_4$ falls by about 34 per halving.
    - At $h = 2^{-10}$, err(y5) = 5.1e-20 > err(y4) = 2.2e-20. So the conclusion "$y_5 - y_4$ is dominated by the error of $y_4$" fails as well.
- **Effect on the page's own cases:** none. Both of the page's $f$ are C^∞ along their runs. For Case 2, every stage argument of both runs stays ≥ 0.008118 (stage.py), so $f$ is never evaluated near $y = 0$.
- **Suggested correction:**
  - Line 51: change "if the solution has six continuous derivatives" to "if $f$ has continuous partial derivatives up to order six near the solution". That costs about +3 words; the Description is at 399 of 400, so trim elsewhere, for example drop "for small $h$" or shorten line 53.
  - Line 48: change "and the solution smooth enough for the orders below" to "and $f$ smooth enough for the orders below".

**F2. Page text. Error. The ratio 65.4 is a floating-point artifact (line 52).**
- **What the page says now:** "halving … divides … the errors of $y_4$ and $y_5$ by $27.9$ and $65.4$".
- **What is true instead:** the error of $y_5$ falls by **65.56**, which rounds to 65.6. At $h = 0.0125$ the error of $y_5$ is 4.873e-14 on $y \approx 0.51$, which is about 100 ulp. Float64 rounding contaminates it to 4.885e-14, and that gives 65.40.
- **How I know (half.py, mpmath at 50 digits, one step from $(0, 0.5)$ against the exact $\tan(t + \arctan 0.5)$):**

  | | $\lvert y_5-y_4\rvert$ ratio | err(y4) ratio | err(y5) ratio |
  |---|---|---|---|
  | mpmath | 30.707 | 27.887 | 65.561 |
  | Float64 | 30.700 | 27.886 | 65.402 |

  The other two ratios on the page (30.7, 27.9) are correct.
- **Suggested correction:** "$65.6$". The sentence's conclusion, "near $2^6 = 64$", still holds.

**F3. Page text. Minor. "the first step" names a step that was not Case 1's first step (line 52).**
- **What the page says now:** "On Case 1's problem, halving the first step from $0.025$ to $0.0125$".
- **What is true instead:** Case 1 starts with $h_0 = 0.1$, and its accepted first step is 0.1 (run.py). The test is a separate single step from $t = 0$. A reader may take 0.025 to be the step the animation used.
- **Suggested correction:** "On Case 1's problem, halving a single step from $t = 0$ from $0.025$ to $0.0125$ divides …".

## 2. Claim ledger

The ledger covers the + lines of the diff, lines 12–59 plus the two heading ids. No sentence was moved out of the Animations section.

1. **L12** The IVP is $y' = f(t,y)$, $y(t_0) = y_0$. **Confirmed.**
2. **L13** Embedded 4th- and 5th-order approximations come from the same stages, the error is estimated from their difference, and the step is adjusted. **Confirmed** (script and module).
3. **L16–25** The six stage formulas.
   - They match the script line for line and Mathews image gr_2 (read off the image).
   - Independent check (check.py, exact Fractions): row sums equal $c_i$, and all Butcher order conditions hold.
   - **Confirmed.**
4. **L29–34** The $y_4$ and $y_5$ weights.
   - They match the script and Mathews images gr_3 and gr_4.
   - The $y_4$ weights satisfy all order conditions up to order 4 (1+1+2+4 trees) and fail at order 5.
   - The $y_5$ weights satisfy all conditions up to order 5 (9 trees at order 5) and fail at order 6.
   - **Confirmed** (exactly orders 4 and 5).
5. **L36** $|y_5 - y_4|$ estimates the local error of $y_4$. **Confirmed** under smooth $f$ (ratio estimate/err(y4) is about 1.08 at $h = 0.0125$). See F1 for the general hypothesis.
6. **L37** The estimate shrinks like $h^5$, so the estimate divided by $h$ shrinks like $h^4$. **Confirmed** (halving ratios 29.1, 30.7, 31.4 → 32).
7. **L38** A step is accepted when $|y_5 - y_4|/h \le \varepsilon$. RKF45 carries $y_4$ forward and RKF54 carries $y_5$.
   - The script tests `err <= tol*h || h <= hmin`. The $h_{min}$ branch is never reached (item 9).
   - The RKF54 naming matches Mathews' remark and subroutine.
   - **Confirmed.**
8. **L39–43** Accepted or not, $h_{new} = s\,h$ with $s = 0.84(\varepsilon h/|y_5 - y_4|)^{1/4}$. **Confirmed** (the script updates $h$ unconditionally; its err = 0 → s = 2 edge case is omitted, which is harmless).
9. **L45** $h$ is clamped to at most 0.25 and at least 1e-6, neither case reaches 1e-6, and a rejected step is retried from the same point.
   - Smallest trial $h$:
     - Case 1: 2.83e-5 (RKF45) and 2.82e-5 (RKF54).
     - Case 2: 2.74e-2 (RKF45) and 6.39e-4 (RKF54; this is the final truncated step).
   - All of these are above 1e-6.
   - Rejected steps leave $t$ and $y$ unchanged.
   - **Confirmed.**
10. **L46** 0.84 rounds Mathews' $2^{-1/4}$. Mathews gr_5 shows $s = (\varepsilon h/(2|z-y|))^{1/4} = 0.840896(\dots)^{1/4}$. **Confirmed.**
11. **L46** If the estimate scaled exactly like $h^5$, the new step would bring the estimate per unit step to about $\varepsilon/2$. The scaled value is $0.84^4\,\varepsilon = 0.4979\,\varepsilon$. **Confirmed.**
12. **L48** The method needs $f$ continuous and Lipschitz in $y$ near the solution for uniqueness. **Confirmed.** The clause "and the solution smooth enough for the orders below" is **wrong** as a hypothesis (F1).
13. **L49** In Case 2, $f = 1 - t\sqrt[3]{y}$ is not differentiable at $y = 0$, but the solution stays above $y(5) \approx 0.00812$.
    - $\partial f/\partial y = -t/(3y^{2/3})$ is unbounded at $y = 0$.
    - $y(5) = 0.0081199205$ (solve_ivp at rtol 1e-13).
    - The minimum over [0, 5] is at $t = 5$.
    - All RKF stage arguments are ≥ 0.008118.
    - **Confirmed.**
14. **L51** If the solution is C^6, the local errors are $O(h^5)$ and $O(h^6)$ and the estimate is dominated by the error of $y_4$. **Wrong as a general statement** (F1). It holds for both of the page's cases.
15. **L51** With fixed steps the global errors are $O(h^4)$ and $O(h^5)$. **Confirmed** (standard result, given smooth $f$ and Lipschitz).
16. **L52** Halving 0.025 to 0.0125 divides the estimate by 30.7. **Confirmed** (30.707).
17. **L52** … and the error of $y_4$ by 27.9. **Confirmed** (27.887).
18. **L52** … and the error of $y_5$ by 65.4. **Wrong**: 65.56 (F2).
19. **L52** "near $2^5 = 32$ and $2^6 = 64$". **Confirmed** (the next halving gives 30.1 and 64.8).
20. **L52** "the first step" is 0.025. **Wrong in wording** (F3). Case 1's first step is 0.1.
21. **L53** The animations show the step-size controller, not these rates. **Confirmed** by my look at the frames: the contact sheet of rungekuttafehlbergaa shows trajectories with marker spacing only, and no error plot.
22. **L55** The tolerance bounds local, not global, error. **Confirmed** in the sense the next sentence makes concrete.
23. **L56** In Case 1 the accepted estimates add up to 5.6e-7. **Confirmed** (5.5879e-7 for both runs).
24. **L56** RKF45 ends 4.5e-3 from exact. **Confirmed** (4.5168e-3).
25. **L56** $y(1.1) = 139.88$. **Confirmed** (139.88284).
26. **L56** The pole of $\tan(t + \arctan 0.5)$ is at $t \approx 1.1071$. **Confirmed** ($\pi/2 - \arctan 0.5 = 1.107149$).
27. **L56** An error at $t = 0$ grows about 1.6e4 times by $t = 1.1$. The sensitivity is $(1 + y(1.1)^2)/(1 + 0.25) = 15654.6$. **Confirmed.** It is consistent with the Animations intro's 1.1e4 from $t = 0.25$: $(1 + y(1.1)^2)/(1 + y(0.25)^2) \approx 11181$.
28. **L57** From $t = 0$ with $h = 0.25$, $|y_5 - y_4| = 1.7\times10^{-7}$. **Confirmed** (1.6731e-7).
29. **L57** The true error of $y_4$ is 34 times larger. err(y4) is 5.737e-6, a ratio of 34.29. **Confirmed.** This is consistent with the intro's "5.6–5.7e-6" (err(y5) is 5.570e-6).
30. **L59** Euler, Heun, Taylor Series, Runge-Kutta, ABM and Milne-Simpson pages all solve Case 2's problem with fixed steps. I grepped each page for $y' = 1 - t\sqrt[3]{y}$, $y(0) = 1$ on [0, 5]; Milne-Simpson has it as Case 1. **Confirmed.**
31. **L59** Adaptive Simpson's Rule uses the same compare-two-estimates idea. **Confirmed** (the page exists; the description is accurate).
32. **Heading ids** `{#case-1}` (L94) and `{#case-2}` (L111) are added; they are the only change in the Animations section. **Confirmed** as allowed edits.

## 3. Checks

- **Six points of the standard:**
  - The problem: L12–13. Present.
  - The core formula: L16–43, as display math in the scripts' notation ($k_i$, $y_4$, $y_5$, $h$, $\varepsilon$). Present.
  - What it assumes: L48–49. Present, but with the F1 flaw.
  - How accurate it is: L51–53. Present; the general statement has the F1 flaw, and the case-attached ratios are verified apart from F2.
  - When it fails or misleads: L55–57. Present, with two concrete failure modes tied to Case 1 and the intro.
  - Where it fits: L59. Present.
  - No proofs, theorem or definition callouts, or Mathematica or MATLAB procedures.
- **Word count:** 399 by my own count (inline math counted as 1 word, display math excluded, link targets stripped). This agrees with the manifest and is within 150–400 with no room to spare. The F1 fix must stay within 400.
- **Links and anchors:**
  - `#case-1` and `#case-2` match the explicit ids.
  - `#animations` resolves to Quarto's automatic id for `## Animations`. No other heading on the page produces that id.
  - All 7 relative page links point at existing folders under pages/numerical-methods/: eulers-method-for-odes, heuns-method, taylor-series-method-for-odes, runge-kutta-method, adams-bashforth-moulton-method, milne-simpsons-method, adaptive-simpsons-rule.
- **Scope of the diff:**
  - The Description was replaced wholesale.
  - Outside the Description, the only changes are the two heading ids.
  - The Animations introduction, the Behavior paragraphs, the scripts and the GIFs are unchanged.
  - No sentence was moved.
- **Consistency with the rest of the page:**
  - The Description's 1.7e-7 / 34× figures agree with the Animations intro's 1.7e-7 and 5.6–5.7e-6.
  - The RKF45 4.5e-3 final error agrees with Case 1's Behavior.
  - The $h_{max}$ and $h_{min}$ values match both scripts.
  - Mathews' different acceptance test is described only in the intro, and the Description does not claim it.
  - No contradictions found.
- **Script cross-check (not under review):**
  - My Python replica of `rkf_integrate` reproduces 259 points for Case 1 and 80/81 points for Case 2.
  - It gives final errors of 4.517e-3 (RKF45) and 3.154e-3 (RKF54) in Case 1, and $y(5) = 0.008120$ in Case 2.
  - These agree with the page.
- **Fidelity:** the stage and weight coefficients and the 0.84 factor match Mathews' module images. The module states no smoothness hypotheses, so F1 is a Page text finding, not a Fidelity finding.
- **Could not determine:** nothing.


## Independent check of F1 and F2 (a separate checker given only the allegations)

Both allegations are confirmed. I ran nothing from the repository, no MATLAB and no quarto. My scripts are in /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22/runge-kutta-fehlberg-method/checker/ (chk.py and f64.py).

**F1 (line 51, with line 48): confirmed. Error fits.**
The page states the orders under a hypothesis about the solution ("six continuous derivatives"). The Runge-Kutta stages sample f at points off the solution curve, so the orders depend on how smooth f is near the solution, not on how smooth the solution is.

- **Counterexample:** f(t,y) = cos t + |y − sin t|, with y(0) = 0. It meets every stated hypothesis: f is continuous and Lipschitz in y with constant 1, and the solution sin t is C^∞.
- **Test:** chk.py runs one RKF step at 50 digits for h = 2^-3 down to 2^-9.
  - Halving h divides the error of y4 by about 31.9, of y5 by about 31.96, and of y5 − y4 by about 32.0. So y5's local error is O(h^5), not O(h^6).
  - y5's error (e.g. 1.05e-12 at h = 2^-6) is larger than y4's (7.19e-13), so y5 − y4 is not dominated by y4's error.
- **Control:** with the smooth f = cos t + (y − sin t), which has the same solution, the ratios approach 32 and 64 (31.1 and 63.9 at h = 2^-7), as they should.

So the "In general, if…" statement is false as written. A correct hypothesis is that f has five continuous derivatives near the solution, which also makes y C^6. The page's own cases are unaffected: Case 1's f is a polynomial, and Case 2's f is smooth wherever y > 0. A smaller gap: "dominated by" also needs y4's leading error coefficient to be nonzero (y' = 1 makes every error zero).

**F2 (line 52): confirmed.**
One step from t = 0 on y' = 1 + y², y(0) = 0.5, against the exact solution tan(h + arctan 0.5), at 50 digits:

| | h = 0.025 | h = 0.0125 | ratio |
|---|---|---|---|
| \|y5 − y4\| | 1.9990e-11 | 6.5100e-13 | 30.707 |
| error of y4 | 1.6795e-11 | 6.0226e-13 | 27.887 |
| error of y5 | 3.1950e-12 | 4.8733e-14 | **65.561** |

- The page's 30.7 and 27.9 are correct; 65.4 should be 65.6.
- **Source of the error:** the same calculation in Float64 (f64.py) gives 65.402. The y5 error at h = 0.0125 is only about 440 units in the last place of y ≈ 0.53, so double-precision rounding shifts the ratio by about 0.24%.
- **Severity:** Error fits by the brief's definition ("computed wrongly"), since the figure is wrong at the precision stated. The consequence is small, though: the point that the ratio is near 64 still holds, so Minor is also defensible. The fix is to write 65.6.
