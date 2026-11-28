# Runge-Kutta Method — batch 22 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/runge-kutta-method/index.qmd` (overview page, light-pass batch 22, action *write*). Evidence folder EV = /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22r2/runge-kutta-method. My scratch files are in EV/reviewer/ (check.py, tail.py, wc.py, and zoomed images of Mathews' theorem). I did not read anything under `reviews/`, did not run MATLAB or quarto, and changed nothing in the repository.

I consulted the Mathews archive: `n2003/RungeKuttaMod.html` (as text) and its formula images gr_1 to gr_23.

## Part 1: Findings

None.

Points I looked at closely and decided were not findings:
- **"Large steps fail on this problem in two ways."** The first way is the linear stability bound, which is crossed for m ≤ 74. I checked whether this is a real failure for m = 60 and 70, where the run does not turn upward. It is. For m = 60 the error at grid points grows inside the shaded region from 2.8e-5 at t = 4.667 to 3.43e-4 at t = 5, about 12 times. The step amplification R(h·fy) there goes from 1.00 to 2.52. For m = 70 the error grows from 1.39e-5 to 2.77e-5, with R from 0.88 to 1.27. So the error is amplified even when the result looks fine, and the framing holds. The Description also sends the reader to the Behavior note for the breakdown of causes.
- **Related pages.** The Description says Euler's method animates "the same sweep." Euler's Case 1 uses m = 10 to 150, not exactly the 21 values used here. Its Case 2 (modified Euler) uses the same 21 values. All of these are step-refinement sweeps on the same IVP, so the claim is loosely true.
- **Mathews' precision theorem.** The image gr_12 appears to read "y(t) ∈ C²[t₀,b]"; it may be a C⁵ drawn badly. The page does not attribute its error hypothesis to Mathews. It says "the error result needs more" and gives f ∈ C⁴ near the solution, hence y ∈ C⁵. That is the mathematically correct sufficient condition, so this is not a Fidelity finding.

## Part 2: Claim ledger (the + lines of the diff)

| # | Claim (the page's words, shortened) | Verdict | Evidence |
|---|---|---|---|
| 1 | RK4 solves y′ = f(t,y), y(t₀) = y₀ over [t₀, b] | confirmed | Mathews module text; script |
| 2 | t_i = t₀ + ih, h = (b − t₀)/m | confirmed | script line 22–23 (h = (T−t0)/m) |
| 3 | four evaluations of f: once at the start, twice at the midpoint, once at the end | confirmed | k1 at t, k2 and k3 at t+h/2, k4 at t+h |
| 4 | k1 to k4 formulas (display math) | confirmed | match script lines 28–31 and Mathews gr_7 to gr_10 |
| 5 | y_{i+1} = y_i + (k1 + 2k2 + 2k3 + k4)/6 | confirmed | script line 32; Mathews gr_5 |
| 6 | if f depends on t alone, k2 = k3 and the step is Simpson's rule on [t_i, t_i+h], which explains the weights 1, 2, 2, 1 | confirmed | k2 = k3 = h·f(t+h/2), so the step is (h/6)[f(t) + 4f(t+h/2) + f(t+h)], which is Simpson's rule |
| 7 | Mathews' theorem assumes f is continuous and Lipschitz in y, which gives a unique solution | confirmed | module text: "Assume that f(t,y) is continuous and satisfies a Lipschits condition in the variable y" |
| 8 | in general, if f has continuous partial derivatives through order 4 near the solution, then y ∈ C⁵, the local error is O(h⁵) and the global error is O(h⁴) | confirmed (correct general hypothesis) | standard result; y′ = f(t,y) with f ∈ C⁴ gives y ∈ C⁵ |
| 9 | for small enough h, halving the step divides the final error by about 16 | confirmed | observed order 4.12 for m 600→1200 (ratio 17.4); 4.07 for m 1200→1600 |
| 10 | Case 1: f = 1 − t∛y, y(0) = 1, over [0, 5] | confirmed | script lines 11–14 |
| 11 | the solution stays positive, down to y(5) = 0.0081199 | confirmed | mpmath odefun: y(5) = 0.00811992046486796; DOP853 agrees; the minimum of y on [0,5] is at t = 5 |
| 12 | f is smooth near the solution, so the general rate applies, but only for steps smaller than the animation shows | confirmed | observed order is above 4 at frame steps (5.47 for 100/120, 4.90 for 120/150) and nears 4 only at finer steps |
| 13 | the observed-order formula log(e_prev/e)/log(h_prev/h) | confirmed | correct definition |
| 14 | observed order 4.90 between m = 120 and 150 | confirmed | 4.9022 (errors 5.247e-7 and 1.757e-7) |
| 15 | observed order 4.07 between m = 1200 and 1600 | confirmed | 4.0742 (errors 2.409e-11 and 7.460e-12) |
| 16 | ∂f/∂y = −t/(3y^{2/3}) along the solution reaches −41.3 at t = 5 | confirmed | −41.2554; |fy| is largest at t = 5 and increases monotonically for t > 3 |
| 17 | every step longer than about h = 0.0675 (m ≤ 74) makes h·|∂f/∂y| exceed 2.785 before t = 5 | confirmed | h_crit = 2.785294/41.2554 = 0.067513, i.e. m = 74.06. m = 74 crosses at t ≈ 4.9987; m = 75 never crosses; m = 70 crosses at t ≈ 4.908 |
| 18 | RK4's general linear stability limit is 2.785 | confirmed | root of R(z) = 1 on the negative real axis: z = −2.785294 |
| 19 | f is not Lipschitz near y = 0 | confirmed | ∂f/∂y is unbounded as y → 0 |
| 20 | in every run from m = 12 to 52 some stage value falls below 0 | confirmed | minimum stage from −1.154 (m = 12) to −0.009 (m = 52); m = 56 to 150 have none (smallest 0.005 at m = 56) |
| 21 | ∛y has an infinite slope at 0 | confirmed | |
| 22 | in those same runs (m = 12 to 52) the curve visibly turns upward in the tail | confirmed | largest tail rise 0.184 (m = 12) down to 0.027 (m = 52); m = 56 rises only 8.05e-4. The frames (sheet.png) agree |
| 23 | the run ends at y(5) ≈ 0.588 for m = 12 | confirmed | 0.5883471, which matches the frame label |
| 24 | the case's Behavior note separates the causes | confirmed | the Behavior paragraph covers local error versus amplification, and the cube-root convention |
| 25 | Euler (order 1), Heun (order 2) and the Taylor Series Method animate the same sweep on the same problem | confirmed (with the note in Part 1) | all three pages use y′ = 1 − t∛y on [0, 5] with step-refinement sweeps; Euler's Case 1 uses m = 10 to 150 |
| 26 | Runge-Kutta-Fehlberg pairs embedded 4th- and 5th-order formulas to choose h adaptively | confirmed | that page's Description, lines 12–13 |
| 27 | ABM takes its starting values from a one-step method such as RK4 | confirmed | ABM page line 28 and Case 1 "the first three steps by RK4" |
| 28 | heading id `{#case-1}` added to the Case 1 heading | confirmed | the only change outside the Description; it makes the anchor for `[Case 1](#case-1)` |

Consistency with the rest of the page: the Animations introduction is unchanged. It still gives the RK4 formula and the O(h⁵)/O(h⁴) orders "for smooth f", which agrees with the Description. The Behavior note's numbers agree with the Description: 41.3, h = 0.0675, m ≤ 74, 2.785, negative stages for m = 12 to 52 only, 0.588 for m = 12, and 0.0081199. I found no contradictions.

## Part 3: Checks

- **Scope of the diff.** `git diff --stat 147040f` shows only index.qmd (+34/−1). No script or GIF changed, so the animations are not under review. Outside the Description the only change is the `{#case-1}` id on the Case 1 heading, which the standard allows.
- **The six points of the standard:**
  1. Problem: present (L12–13).
  2. Core formula: display math in the script's notation (k_j = h·f, index i).
  3. Assumptions: Lipschitz and continuous (Mathews), plus f ∈ C⁴ for the error result.
  4. Accuracy: O(h⁵) local and O(h⁴) global with their hypothesis, plus Case 1's observed orders, which I checked.
  5. Failure modes: the stability bound and the non-Lipschitz negative stages, linked to Case 1, with the numbers checked.
  6. Where it fits: one sentence linking Euler, Heun, Taylor, RKF and ABM.

  Nothing excluded by the standard is present: no proofs, no theorem boxes, no Mathematica.
- **Word count.** The manifest gives 362. My own rough count, with inline math as one word and display math dropped, gives 385. Both are within 150–400.
- **Links and anchors.** `#case-1` matches the new explicit heading id. These folders all exist under pages/numerical-methods/: simpsons-rule-for-numerical-integration, eulers-method-for-odes, heuns-method, taylor-series-method-for-odes, runge-kutta-fehlberg-method and adams-bashforth-moulton-method.
- **Independent computation.** I wrote an RK4 in Python (EV/reviewer/check.py) and checked it against a high-accuracy reference (mpmath odefun at 30 digits, and scipy DOP853). Results:
  - y(5) for all 21 frames matches the GIF labels: 0.5883471, 0.3876236, 0.2891074, 0.1108585, 0.0834665, 0.0604713, 0.0376958, 0.0084630, 0.0081267, 0.0081213, 0.0081201.
  - The stability onsets match the frame labels: m = 70 from t ≈ 4.908, and no onset for m ≥ 75.
  - Tail error growth for m = 60 and 70 was checked in EV/reviewer/tail.py.
- **Frames.** I checked sheet.png for m = 12, 16, 20, 28, 36, 44, 52, 60, 80, 100 and 150. The upturns are visible for m ≤ 52, there is no visible upturn at m = 60, the shading appears only for m ≤ 70, and the labels agree with the computed values.
- **Mechanical checks** (from the manifest): none found.
