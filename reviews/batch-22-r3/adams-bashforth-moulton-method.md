# Adams-Bashforth-Moulton Method — batch 22 review, round 3 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 2 Minor

Page: pages/numerical-methods/adams-bashforth-moulton-method/index.qmd (batch 22, overview mode, round 3). Diff changes only index.qmd: the Description (lines 12–40) and an explicit id `{#case-1}` on the Case 1 heading (line 53). No script or GIF changed, so the animations were not re-reviewed. Mathews archive consulted: n2003/AdamsBashforthMod.html, including theorem images gr_25 (y ∈ C^5[t0,b]) and gr_29 (|e_k| = |y(t_k) − y_k| = O(h^4)). Scratch work: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22r3/adams-bashforth-moulton-method/reviewer/ (check.py, case.py, tail.py). I did not run MATLAB or quarto, and I did not modify the repository.

## Part 1. Findings

**F1. Page text, Minor.** Line 32: "up to $m = 70$ instability sets the $y(5)$ error, which falls 190-fold from $m = 70$ to $m = 80$". Line 33 then starts at "For $m \ge 100$ the error does not grow after the frames' shading begins".
- **What the reader takes from it:** the instability stops setting the y(5) error after m = 70.
- **What is true:** at m = 80 and m = 90 the y(5) error still comes from growth after the shading begins. The error oscillates in sign and grows in amplitude, which is the parasitic-root pattern:
  - m = 80: the error is −7.9e−7 at t = 4.00 (onset 3.985). It then runs +1.7e−7, −3.7e−7, +5.1e−7, −1.5e−6, +5.6e−6 and ends at −1.1e−5 at t = 5, about 14 times the error at onset.
  - m = 90: the error is −4.4e−9 at t = 4.28 (onset 4.139). It ends at −2.9e−7, about 65 times larger.
  - Only from m = 100 does it not grow: last pre-onset error 8.25e−9, largest post-onset error 6.23e−9.
- **What is right:** the sentence's main point holds. The y(5) error ratios are 190 (70→80), 37 (80→90), 65 (90→100), 7.9 (100→120) and 4.2 (120→150), against h^4 ratios of 1.71, 1.60, 1.52, 2.07 and 2.44. The boundary "70" is wrong, and m = 80–90 fall in a gap neither sentence covers.
- **How I know:** tail.py, which prints the per-step errors after onset for m = 70, 80, 90 and 100 against a DOP853 reference (rtol 1e−13).
- **Suggested fix:** "up to $m = 90$ instability sets the $y(5)$ error (from $m = 80$ on it is too small to see), and it falls 190-fold from $m = 70$ to $m = 80$, against 1.7 for $h^4$." Alternatively, keep "70" and say that m = 80 and 90 still show small post-onset growth.

**F2. Page text, Minor.** Line 30: "if $y \in C^5[t_0, b]$". The symbol b is never defined. Line 12 gives only $y(t_0)=y_0$ and the grid $t_n = t_0 + nh$, with no interval. Mathews' theorem has the interval [t0, b]. Suggested fix: add ", on an interval $[t_0, b]$" to line 12.

## Part 2. Claim ledger (+ lines of the diff)

1. ABM is a predictor-corrector multistep scheme for y' = f(t,y), y(t0) = y0, on the grid t_n = t0 + nh. **Confirmed.**
2. One-step methods (Euler, Heun, Runge-Kutta) use only the current point; ABM reuses f_k at the four latest points. **Confirmed.** This matches the module's opening paragraph, and the predictor uses f_n..f_{n−3}.
3. Predictor formula p_{n+1} = y_n + h/24(55f_n − 59f_{n−1} + 37f_{n−2} − 9f_{n−3}). **Confirmed.** With sympy it is exact for t^0..t^3 and not for t^4, with error constant 251/720. It is identical to script line 57.
4. Corrector formula y_{n+1} = y_n + h/24(9f(t_{n+1}, p_{n+1}) + 19f_n − 5f_{n−1} + f_{n−2}). **Confirmed.** It is exact for degree ≤ 3, with constant −19/720. It is identical to script lines 58–60.
5. Both formulas integrate the interpolating cubic over [t_n, t_{n+1}]: the predictor's through four past slopes, the corrector's through three past slopes and the predicted one. **Confirmed.** Each rule has four nodes and is exact for degree 3, so it is interpolatory.
6. A step needs only two new f evaluations, at p_{n+1} and at y_{n+1} (PECE). **Confirmed.** The module says the same. The script recomputes all four f values each step, which is only an implementation choice, and its scheme is PECE.
7. Mathews' theorem assumes f continuous and Lipschitz in y; the coefficients assume fixed h. **Confirmed** against the module theorem text.
8. ABM is not self-starting; y1, y2, y3 must come from an O(h^4)-accurate one-step method, usually RK4. **Confirmed.** This matches the module's remark, and the script starts with RK4 (lines 40–49).
9. Precision theorem: if y ∈ C^5[t0, b], the local truncation error is O(h^5) and the global error is O(h^4). **Confirmed** against module images gr_25 and gr_29. The symbol b is undefined on the page (F2).
10. Halving a small enough h cuts the error about 16-fold. **Confirmed** as a general result. On Case 1 before the onset, the error ratios at t = 3.0 for m = 100→200→400→800 are 20.7, 19.1 and 17.7, approaching 16.
11. y(t_{n+1}) − y_{n+1} ≈ −19/270 (y_{n+1} − p_{n+1}) for slowly varying y^(5). **Confirmed.** From the constants 251/720 and −19/720: (−19/720)/(270/720) = −19/270.
12. Case 1 does not show the h^4 rate. **Confirmed.** No consecutive pair of frames has a y(5) error ratio near the h^4 ratio (see F1).
13. Up to m = 70 instability sets the y(5) error. **Confirmed but incomplete (F1).** At m = 70 the error is 1.1e−5 just before onset (3.82) and 2.08e−3 at t = 5. The same mechanism continues at m = 80 and 90.
14. The y(5) error falls 190-fold from m = 70 to m = 80, against 1.7 for h^4. **Confirmed.** The ratios are 190.3 and (8/7)^4 = 1.706.
15. For m ≥ 100 the error does not grow after the shading begins. **Confirmed.** Last pre-onset error against largest post-onset error: m = 100, 8.25e−9 vs 6.23e−9; m = 120, 1.12e−9 vs 1.03e−9; m = 150, 1.66e−10 vs 1.58e−10.
16. For m ≥ 100 the largest error is truncation error near t ≈ 3.3. **Confirmed.** The largest errors are 8.53e−6 at t = 3.35, 3.49e−6 at 3.333, and 1.20e−6 at 3.30. All lie before onset (4.28, 4.55, 4.89), and the pre-onset error scales toward h^4 (item 10).
17. The damped tail cuts the y(5) error faster than h^4. **Confirmed.** From m = 100 to 150 the ratio is 33.1, against 5.06 for h^4.
18. The pair is stable on y' = λy (real λ < 0) only while h|λ| ≤ 1.285. **Confirmed.** Using my own companion matrix of the PECE recurrence, bisection gives 1.284816, and a scan of [−2, 0) finds the stable set to be the single interval (−1.28482, 0). This agrees with the script's zlim of 1.2848. The 1.285 is ordinary last-digit rounding.
19. Case 1 solution ends at y(5) = 0.0081199. **Confirmed.** DOP853 gives 0.0081199205.
20. ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5. **Confirmed.** The value is −41.2554.
21. h|∂f/∂y| passes 1.285 before t = 5 in every frame. **Confirmed.** At m = 150, (1/30)(41.26) = 1.375 > 1.285, and the bound is m < 160.5. The onsets run from 2.826 (m = 12) to 4.890 (m = 150), and frames 1, 16 and 21 show the shading.
22. For m = 12..60 the run leaves the reference in the tail. **Confirmed.** All runs are close before onset (pre-onset error ≤ 2.2e−3) and depart after it, as frame 1 shows.
23. For m = 12..60 the largest error is between 0.096 and 0.74. **Confirmed.** The minimum is 0.09555 (m = 60) and the maximum is 0.7364 (m = 12).
24. For m = 12..60, y(5) lies between −0.363 and 0.632. **Confirmed.** The minimum is −0.36284 (m = 20) and the maximum is 0.63215 (m = 16).
25. At m = 12, y(5) is off by 0.013, while the run is off by 0.74 at t ≈ 4.17. **Confirmed.** The y(5) error is +1.33e−2 (frame 1 shows +1.3e−2), and the largest error is 0.7364 at t = 4.167.
26. Milne-Simpson is the other fourth-order predictor-corrector pair. **Confirmed** in the module context: n2003 has Milne-Simpson and ABM modules and no Hamming module.
27. RK supplies the starting values; RKF is a one-step adaptive alternative. **Confirmed.**
28. Links ../eulers-method-for-odes/, ../heuns-method/, ../predictor-corrector-methods/, ../milne-simpsons-method/, ../runge-kutta-method/ and ../runge-kutta-fehlberg-method/. **Confirmed.** Each folder has an index.qmd.
29. [Case 1](#case-1) and the heading id {#case-1}. **Confirmed.** The explicit id is on line 53.

## Part 3. Checks

**Six points of the standard:**
1. Problem: line 12. Present.
2. Core formula: lines 16–22, as display math in p/y/f_n notation that matches the script. Present.
3. Assumptions: lines 27–28. Present.
4. Accuracy: lines 30–33, as a general result with its hypothesis, pointing to Case 1. Present.
5. Failure modes: lines 35–38 (conditional stability, and an end value that misleads). Both match the Animations section and the frames. Present.
6. Where it fits: line 40. Present.

There are no proofs or theorem boxes, and the one-line intuition (line 24) is allowed.

**Word count:** 400 by my own count (inline math counted as 1, display math excluded), which matches the manifest. This is at the 400 limit, not over it.

**Consistency with the rest of the page:** the Description agrees with the Behavior paragraphs on y(5), the ±41.3 value, 1.285, the 0.096–0.74 range, −0.363/0.632, the m = 12 figures (0.013 and 0.74 at t ≈ 4.17), and the below-1e−8 pre-onset error for m = 100–150. I found no contradiction. The script's RK4 reference (h = 1e−4) agrees with DOP853: the m = 150 y(5) error is −1.36e−10 in mine and −1.4e−10 in the frame.

**Links and anchors:** all resolve.

**Scope of the diff:** only the Description was rewritten, and the one change outside it is the heading id `{#case-1}`, which is allowed. No sentences were moved, and no script or GIF changed.

**Markup:** KaTeX-safe. It uses \bigl/\bigr, \tfrac and \sqrt[3]{}, with no stray `$` and no \tag.
