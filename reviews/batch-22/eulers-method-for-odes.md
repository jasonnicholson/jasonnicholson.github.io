# Euler's Method for ODE's — batch 22 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Review of `eulers-method-for-odes` (light-pass batch 22, overview page, action *extend*). Page: /home/jason/Desktop/jasonhnicholson.com/pages/numerical-methods/eulers-method-for-odes/index.qmd. The diff changes only index.qmd. It changes no script or GIF, so the animations themselves were not reviewed. I consulted the Mathews archive: /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/Euler'sMethodMod.html, including its theorem and algorithm images gr_15–23, 28, 32, 33, 39 and 40. I did not run MATLAB or quarto, and I changed nothing in the repository. My scratch files are in /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22/eulers-method-for-odes/reviewer/ (chk.py, thm.png, alg.png).

## 1. Findings

**F1 — Page text, Minor.** index.qmd line 45: "In general, on $y' = \lambda y$, each step multiplies the error by $1 + z$ (Euler) or $1 + z + z^2/2$ (modified Euler)".
- **What it says:** the sentence is labelled as a general result, but it leaves out the local error that each step adds.
- **What is true:** on the test equation the global error obeys e_{n+1} = R(z) e_n + (local error of step n+1). Only the error a step inherits is multiplied by R(z).
- **Where the page says it correctly:** the Case 1 Behavior paragraph (line 89) gets this right: "multiplies the error it inherits by about $1+h\,\partial f/\partial y$ … and adds its own local error". The two places do not contradict each other. The Description is only looser, using the usual shorthand for error propagation, and the stability conclusion (limit 2 for both methods) is unaffected.
- **Suggested fix:** "each step multiplies the error it inherits by $1 + z$ …".

I found nothing else. Every number and behaviour claim in the new text agrees with my own computation, the frames and the Animations sections.

## 2. Claim ledger (+ lines of the diff, plus the moved Heun sentence)

Reference used throughout: scipy DOP853 at rtol 1e-13 / atol 1e-15, with my own Euler and midpoint loops in chk.py.

1. "Euler's method is the simplest one-step numerical solver for an IVP $y'=f(t,y)$, $y(t_0)=y_0$, on $[t_0,b]$." — confirmed. It matches Mathews' theorem statement.
2. "$y_n\approx y(t_n)$ at grid points $t_n=t_0+nh$ of $m$ subintervals of width $h=(b-t_0)/m$." — confirmed. Script: h=(T−t0)/m and ts=t0+i*h. Mathews uses the same.
3. Display formula $y_{n+1}=y_n+h f(t_n,y_n)$, $t_{n+1}=t_n+h$ (unchanged) — confirmed against eulersmethodaa.jl `euler` and Mathews gr_32/33.
4. "Mathews' modified Euler method is the explicit midpoint method: half Euler step to the middle, slope there" — confirmed. It matches Mathews gr_39 and eulersmethodbb.jl `meuler`.
5. Display formula $y_{n+1}=y_n+h f(t_n+\tfrac h2,\ y_n+\tfrac h2 f(t_n,y_n))$ — confirmed. It is identical to the script line and to Mathews gr_39.
6. "Mathews' theorem for Euler's method assumes f continuous and Lipschitz in y" — confirmed (module text: "continuous and satisfies a Lipschits condition in the variable y").
7. "his precision theorem that the solution is in $C^2[t_0,b]$" — confirmed (gr_18: y(t) ∈ C²[t0, b]).
8. "Then, in general, local truncation error $O(h^2)$, global $O(h)$, so halving h roughly halves the error" — confirmed. It matches Mathews gr_20/22. Observed Euler order is 1.01–1.02 on the page's problem, and 1.007 / 1.003 / 1.002 for m = 150→300→600→1200.
9. "For smooth enough f, modified Euler's global error is $O(h^2)$: halving h divides it by about 4" — confirmed as a general result (Mathews gr_28: O(h²)). Observed p on the page's problem is 2.04–2.26, tending to 2.02 at m=1200.
10. "The animations use $y'=1-t\sqrt[3]{y}$, $y(0)=1$ on [0,5]" — confirmed against both scripts.
11. "$y(5)=0.0081199$" — confirmed (DOP853 gives 0.008119920; the frames show "reference y(5) = 0.0081199").
12. "f is not Lipschitz near y=0" — confirmed: ∂f/∂y = −t/(3y^{2/3}) is unbounded as y→0 for t>0.
13. "the solution never falls below y(5)" — confirmed. The minimum over [0,5] is 0.008119920 at t=5; the solution is monotone decreasing after its peak at t≈0.8836, and starts at 1 before the peak.
14. "the five finest m that Case 1 and Case 2 share" are 80, 90, 100, 120, 150 — confirmed. The shared m values are {20, 40, 60, 70, 80, 90, 100, 120, 150}.
15. Observed-order formula $p=\ln(E_{prev}/E)/\ln(m/m_{prev})$ — confirmed. It is correct for E ∝ h^p ∝ m^{−p}.
16. "about 1 for Euler" — confirmed (1.011–1.017).
17. "2.1 to 2.3 for modified Euler" — confirmed (2.142–2.257).
18. "falling to 2.04 from m=300 to 600" — confirmed (my p = 2.044; it is 2.090 for 150→300).
19. Table column h: 0.0625, 0.05556, 0.05, 0.04167, 0.03333 — confirmed (5/m).
20. Table, Euler largest error 4.25e-2, 3.77e-2, 3.39e-2, 2.82e-2, 2.25e-2 — confirmed (mine: 4.24846e-2, 3.76923e-2, 3.38609e-2, 2.81583e-2, 2.24733e-2).
21. Table, Euler p 1.02, 1.02, 1.01, 1.01 — confirmed (1.016, 1.017, 1.012, 1.011).
22. Table, modified Euler largest error 6.27e-4, 4.81e-4, 3.83e-4, 2.56e-4, 1.59e-4 — confirmed (mine: 6.27474e-4, 4.80994e-4, 3.82980e-4, 2.56287e-4, 1.58906e-4).
23. Table, modified Euler p 2.26, 2.16, 2.20, 2.14 — confirmed (2.257, 2.163, 2.203, 2.142).
24. "The error at t=5 alone misleads (Case 1, Case 2): late in the run ∂f/∂y is strongly negative and damps the error made earlier" — confirmed, and consistent with the Case 1 and Case 2 Behavior text. At m=150, h·∂f/∂y at t=5 is −1.375, which gives amplification −0.375 for Euler and 0.57 for midpoint. In Case 2 this applies from m=80 on, which the Case 2 text says and which the Description does not contradict.
25. "At m=150, Euler's error at t=5 is −1.7e-6 and modified Euler's 1.8e-6" — confirmed (mine: −1.72e-6 and +1.82e-6; the frames show −1.7e-06 and +1.8e-06).
26. "Euler's largest error is about 140 times larger" — confirmed (2.24733e-2 / 1.58906e-4 = 141.4).
27. "on $y'=\lambda y$ each step multiplies the error by 1+z / 1+z+z²/2" — confirmed for the inherited error; imprecise as worded (see F1).
28. "for real z<0 both have size at most 1 only for −2≤z≤0" — confirmed: 1+z+z²/2 = ((z+1)²+1)/2 ≥ 1/2, and it equals 1 at z=0 and z=−2.
29. "$\partial f/\partial y=-t/(3y^{2/3})$" — confirmed by differentiation; it matches the scripts' `fy`.
30. "reaches −41.3 at t=5" — confirmed (−41.2554, which is also its minimum along the solution, since it is monotone after the peak).
31. "for m≤103, h|∂f/∂y| along the solution exceeds 2 before t=5" — confirmed. The threshold is 5·41.2554/2 = 103.14. The onset is t=4.9978 at m=103 and does not occur at m=104.
32. "the shaded region in the frames" — confirmed: frames for m≤100 are shaded, frames for m≥110 / 120 are not (contact sheets).
33. "Euler's runs for m=10 to 40 zig-zag and dip below zero although the solution stays positive (Case 1)" — confirmed. The minima are −0.4624, −0.1702, −0.1315, −0.1163, −0.0322, −0.0452 and −0.0174 for m=10…40; m=45 has a minimum of +0.0067. The frames show it too.
34. "modified Euler's runs zig-zag for m=12 to 24" — confirmed (repeated sign changes after the peak; frames for m=12, 16 and 20). This agrees with the Case 2 Behavior.
35. "and turn upward before t=5 for m=28 to 60 (Case 2)" — confirmed. The upturn from the minimum is 0.350 at m=28 and 0.0150 at m=60; it is 0.0008 at m=70 and 0 at m=80. This agrees with the Case 2 Behavior.
36. Moved sentence: "Heun's Method, which corrects an Euler predictor with the trapezoidal rule, is also of order 2" — confirmed. The words are unchanged from main; only the final period became ";". Heun is a second-order method.
37. "Big O Truncation Error explains the notation; Taylor Series Method and Runge-Kutta reach higher orders; RKF adapts the step size; Predictor-Corrector such as ABM use several previous points" — confirmed as general statements. All target pages exist.
38. Heading ids `{#case-1}`, `{#case-2}` added to the Case 1 and Case 2 headings — confirmed. The links `#case-1` and `#case-2` resolve to these explicit ids.

## 3. Checks

**Six points of the overview standard:**
1. The problem: lines 12–13. Present.
2. The core formula: Euler and midpoint display math, in the scripts' notation (h=5/m, t_n, y_n). Present.
3. What it assumes: line 25, plus the remark on the Lipschitz condition for the page's problem on line 30. Present.
4. How accurate it is: lines 26–27 give the general results with their hypotheses, and the table checks them on the page's own problem (Case 1 and Case 2 links). Present.
5. When it fails or misleads: two failure modes, the error at t=5 (line 42) and the stability limit / zig-zag (lines 45–47), both linked to cases. Present.
6. Where it fits: line 49. Present.

The optional worked example is a 5-row table, within the limit of about 6, on the page's own problem, and it adds the observed orders that the animations do not show. There are no callout or theorem boxes and no proofs.

**Word count:** 398, within 150–400. I recomputed it myself and got 398 by counting tokens that contain an alphanumeric character, with each inline math expression counted as one word and display math and table rows excluded. It sits just under the limit.

**Links and anchors:** every page it links to exists (I checked each `index.qmd`): heuns-method, big-o-truncation-error, taylor-series-method-for-odes, runge-kutta-method, runge-kutta-fehlberg-method, predictor-corrector-methods, adams-bashforth-moulton-method. `#case-1` and `#case-2` match the explicit heading ids.

**Diff scope:** the only changes outside the Description are the two `{#case-N}` heading ids, which the rules allow. The Animations introduction, the Behavior paragraphs, the alt text and the source links are untouched. No script or GIF changed. The Heun sentence moved within the Description with its words unchanged.

**Contradictions with the rest of the page:** none. The table agrees with the Case 1 text (5.7e-2 at m=60, 2.8e-2 at m=120, 2.2e-2 at m=150) and the Case 2 text (6.3e-4 at m=80, 1.6e-4 at m=150, a fall by a factor of 3.9). The m≤103 threshold, the −41.3 and the "about 140" ratio are the same in both places.

**Markup:** `\Bigl`/`\Bigr`, `\sqrt[3]{y}` and `\text{prev}` are all supported by KaTeX. The math inside the table's pipe cells contains no `|`, so the table should render. Judged from the source only; quarto was not run.

**Fidelity:** the hypotheses (continuous and Lipschitz in y; y ∈ C²), the orders (local O(h²), global O(h), modified Euler O(h²)) and the midpoint formula all match Mathews' module. There is no fidelity departure.
