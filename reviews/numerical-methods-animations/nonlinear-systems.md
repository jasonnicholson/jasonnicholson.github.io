# Nonlinear Systems — animation review

Page: [`pages/numerical-methods/nonlinear-systems/index.qmd`](../../pages/numerical-methods/nonlinear-systems/index.qmd) · Scripts: `newtonsysaa.jl`, `newtonsysab.jl` · GIFs: 2

**Result:** 0 error, 1 misleading, 3 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — The row-sum condition is presented as necessary for fixed-point convergence

- **Location:** index.qmd:38 "When these inequalities are violated the iteration typically diverges, regardless of how close the starting point is." Also index.qmd:65 (comparison table) "Convergence guarantee | Requires row-sum condition".
- **Now:** The page says that if the row-sum inequalities fail, the iteration diverges even from starts arbitrarily close to the fixed point, and that fixed-point iteration "requires" the condition.
- **True:** The row-sum condition (∞-norm of the Jacobian of G < 1) is a sufficient condition for local convergence, not a necessary one. Local convergence depends on the spectral radius of the Jacobian of G at X*. The row sums can exceed 1 while the spectral radius is below 1, and then the iteration still converges from every nearby start.
- **Evidence:** `python3 reviewer/geom.py` uses G(x,y) = (0.6x + 0.6y + 0.05 sin y, 0.1y) with fixed point (0,0). Row sums at X* are 1.25 and 0.1, so the condition is violated. The spectral radius is 0.6. Starting from (5,-3), 60 iterations give (6.5e-14, -3e-60), which is convergence.
- **Suggested fix:** Line 38: "The row-sum condition is sufficient, not necessary; if it fails the iteration may still converge (what decides local convergence is whether the spectral radius of the Jacobian of **G** at **X*** is less than 1), but convergence is no longer guaranteed." Table row: "Convergence guarantee | Row-sum condition is sufficient | Requires good starting guess".

- **Independent check:** confirmed. Checker's own counterexample: Jacobian row sums 1.5 and 0.3 (test fails), eigenvalues 0.6 and 0.3, converges from nearby starts. Error would be defensible for line 38.

### F2 — Minor — Page match — Case 2 Behavior describes the geometry wrongly

- **Location:** index.qmd:90 "the intersection near the bottom of the curves. This solution has a large negative $y$ component and lies at the outer loop of the $f_2 = 0$ curve. … the first step brings the iterate close to the solution".
- **Now:** The page says f2 = 0 has an "outer loop", that Solution 2 has a "large negative y", that it sits "near the bottom of the curves", and that the first Newton step lands "close" to the solution.
- **True:**
  - f2 = 0 is a single closed curve. For each x, the function 4y^4 + 4y is strictly convex in y, so it has at most two y-values. There is no inner or outer loop.
  - Solution 2 (1.5561, -0.5757) sits almost exactly at the rightmost point of that loop, which is (1.5579, -0.6300). It is not at the bottom: the loop reaches y ≈ -1.22 and the f1 curve reaches y = -0.794.
  - y* = -0.576 is not "large". Its magnitude is smaller than Solution 1's y* = 0.724.
  - The first step reduces the error only from 0.614 to 0.214. The iterate is within 1e-3 only after step 3.
- **Evidence:** `python3 reviewer/geom.py` gives a minimum of h(y) = 4y^4 + 4y of -1.88988 at y = -0.62996, so f2 = 0 spans |x| ≤ 1.55785. Sampling at x = 0, 0.5, 1, 1.5, 1.55 finds exactly two y-values each time; at x = 0 they are y ∈ {-1.2207, 0.7245}. `python3 reviewer/indep.py` gives Newton errors for Case 2 of 0.614, 0.214, 0.0337, 1.05e-3, 1.06e-6, 1.08e-12. Frames 1, 3 and 9 of newtonsysab show Solution 2 at the right-hand tip of the red loop.
- **Suggested fix:** "...converges to (x*, y*) ≈ (1.5561, −0.5757), the lower-right intersection, where the blue curve crosses the red closed curve f₂ = 0 close to its rightmost point. Again convergence is quadratic: after two steps the iterate is within about 0.03 of the solution, and each later step roughly squares the error (10⁻³, 10⁻⁶, 10⁻¹²)."

- **Independent check:** not run (minor finding, unverified).

### F3 — Minor — Page match — Case 1 start is not "between the two curves"

- **Location:** index.qmd:82 "Starting in the upper region between the two curves".
- **Now:** The page places (0.5, 0.8) between the two curves.
- **True:** (0.5, 0.8) lies above both curves. It is outside the closed curve f2 = 0, whose top at x = 0.5 is y = 0.718, and above the graph f1 = 0, which is y = -0.630 at x = 0.5. No part of either curve lies above it.
- **Evidence:** `python3 reviewer/geom.py` gives f1(0.5,0.8) = -1.524 and f2(0.5,0.8) = +0.901. On f2 = 0 at x = 0.5, y ∈ {-1.2182, 0.7182}; on f1 = 0 at x = 0.5, y = -0.630. Frame 1 of newtonsysaa shows the start marker above the flat top of the red curve.
- **Suggested fix:** "Starting just above both curves, …".

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Page match — "|g'(x*)| ≈ 0" is scalar notation that this 2D page does not define

- **Location:** index.qmd:82 "demonstrating $|g'(x^*)| \approx 0$ — quadratic convergence in 2D."
- **Now:** The page uses a scalar fixed-point derivative to explain 2D quadratic convergence. On this page, g denotes the second equation g(x,y) (line 14), or the fixed-point maps g1 and g2 (line 30). Neither has a scalar derivative g'.
- **True:** The 2D statement is that the Jacobian of the Newton map N(X) = X − J(X)⁻¹F(X) is the zero matrix at X*. That holds here, but the animation does not show it. What the animation does support is that the error roughly squares each step.
- **Evidence:** `python3 reviewer/geom.py` computes the Jacobian of N symbolically and evaluates it at both solutions. Both give [[0,0],[0,0]] to 12 digits.
- **Suggested fix:** Replace it with "…in a few steps; the error falls 0.24 → 0.024 → 3×10⁻⁴ → 5×10⁻⁸ → 10⁻¹⁵, roughly squaring each step (quadratic convergence)."

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `newtonsysaa.jl` | yes | 3.5 | newtonsysaa.gif |
| `newtonsysab.jl` | yes | 3.5 | newtonsysab.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 22 | Jacobian is the 2×2 matrix of partials ∂f/∂x, ∂f/∂y; ∂g/∂x, ∂g/∂y | Standard definition. The script's `Jac` equals the sympy Jacobian exactly (difference is the zero matrix, indep.py) | confirmed |
| 2 | 34–36 | Row-sum condition at X* ensures convergence for starts sufficiently close | ∞-norm < 1 at X*, plus continuity, gives a contraction near X* | confirmed |
| 3 | 38 | "When these inequalities are violated the iteration typically diverges, regardless of how close the starting point is" | Counterexample: row sum 1.25, spectral radius 0.6, converges (geom.py) | wrong (→ F1) |
| 4 | 44, 48, 52–55 | Newton step: solve J ΔX = −F, set X ← X + ΔX; four steps | Script line 30: `pts[k+1] = pts[k] - Jv \ F(pts[k])` with `Jv = Jac(pts[k]...)` | confirmed |
| 5 | 57 | Quadratic convergence near a non-singular solution | det J* = −37.84 (Sol. 1) and 32.08 (Sol. 2). The ratio e_{k+1}/e_k² settles at 0.535 and 0.960 (indep.py) | confirmed |
| 6 | 63 | Fixed point linear, Newton quadratic | Newton part as in #5. Fixed-point linear rate is standard | confirmed |
| 7 | 65 | "Convergence guarantee: Requires row-sum condition" | Sufficient, not required (see #3) | wrong (→ F1) |
| 8 | 72, 74 | The system is f1 = 1 − 4x + 2x² − 2y³, f2 = −4 + x⁴ + 4y + 4y⁴ | Script lines 12–13 are identical in both scripts | confirmed |
| 9 | 76 | "The blue curve is f1 = 0 and the red curve is f2 = 0" | Script lines 52–59. Legend in frames 1, 3, 9 of both GIFs | confirmed |
| 10 | 76 | "Their two intersections are the solutions" (exactly two) | The resultant in x has degree 12 and only 2 real roots, each with one real y. findroot from 625 starts finds the same two points only | confirmed |
| 11 | 76 | "Each frame adds one Newton step … J ΔX = −F solved" | 9 frames: frame 0 is the start, then 8 steps (n_iters = 8). After about step 5 (Case 1) and step 6 (Case 2) nothing visibly changes | confirmed |
| 12 | 76 | "error roughly squares each step" | Case 1 errors 0.237 → 0.0237 → 2.9e-4 → 4.6e-8 → 1.1e-15 | confirmed |
| 13 | 76 | "reaches the intersection within a handful of iterations from anywhere in the basin" | True for both starts shown (5–6 steps). Not checked over the whole basin; phrased generically | confirmed (for the shown cases) |
| 14 | 78, 84, 92 | Julia source linked under each case | Lines 84 and 92 link newtonsysaa.jl and newtonsysab.jl, the scripts that produce those GIFs (manifest) | confirmed |
| 15 | 80 | Case 1: Solution 1, start (0.5, 0.8) | Script p0 = [0.5, 0.8]. GIF title "Starting at (0.5, 0.8)" | confirmed |
| 16 | 82 | "Starting in the upper region between the two curves" | Start lies above both curves (f1 < 0, f2 > 0; geom.py, frame 1) | wrong (→ F3) |
| 17 | 82 | Converges to Solution 1 ≈ (0.0618, 0.7245) | Script limit (0.0617701263386, 0.7244905153472). Independent value (0.06177012633860737, 0.7244905153472166) | confirmed |
| 18 | 82 | "the intersection in the upper-left portion of the plot" | Window x ∈ [−0.25, 2.25], y ∈ [−1.25, 1.5]. Point at upper left (frame 9) | confirmed |
| 19 | 82 | "reaches machine precision in a few steps" | Script ‖F‖ = 4.1e-15 at k = 5 and 0 at k = 6 | confirmed |
| 20 | 82 | "demonstrating \|g'(x*)\| ≈ 0 — quadratic convergence in 2D" | Quadratic convergence confirmed (#5), but the notation is undefined here. The 2D analogue (Newton-map Jacobian = 0) holds and is not shown by the animation | wrong (→ F4) |
| 21 | 86 | Alt: converging from (0.5, 0.8) to ≈ (0.062, 0.724), blue f1 = 0 and red f2 = 0 | Matches #15, #17, #9 | confirmed |
| 22 | 88 | Case 2: Solution 2, start (2, −1) | Script p0 = [2.0, -1.0]. Title "Starting at (2, -1)" | confirmed |
| 23 | 90 | "Starting in the lower-right region near Solution 2" | (2, −1) is lower right in the window, 0.61 from the solution (frame 1) | confirmed |
| 24 | 90 | Converges to ≈ (1.5561, −0.5757) | Script (1.556097484322053, −0.575650769618843). Independent value identical to 15 digits | confirmed |
| 25 | 90 | "the intersection near the bottom of the curves" | At the rightmost tip of the f2 loop. The loop bottom is y ≈ −1.22 and the f1 bottom is −0.794 | wrong (→ F2) |
| 26 | 90 | "large negative y component" | y* = −0.576, smaller in magnitude than Solution 1's 0.724 | wrong (→ F2) |
| 27 | 90 | "lies at the outer loop of the f2 = 0 curve" | f2 = 0 is a single closed curve, so there is no outer loop | wrong (→ F2) |
| 28 | 90 | "Again convergence is quadratic" | e_{k+1}/e_k² → 0.960, steady | confirmed |
| 29 | 90 | "the first step brings the iterate close to the solution, and subsequent steps nail it to full precision" | Error 0.614 → 0.214 after step 1 (only a factor of 2.9), then 0.034, 1e-3, 1e-6, 1e-12. ‖F‖ is 6e-16 at k = 6 | wrong in its first half (→ F2). "Full precision" is confirmed |
| 30 | 94 | Alt: converging from (2, −1) to ≈ (1.556, −0.576), curves intersect in the lower-right region | Matches #22, #24 | confirmed |

## Implementation checks

### newtonsysaa.jl
- **Method:** Plain Newton's method for systems. It computes X_{k+1} = X_k − J(X_k) \ F(X_k) with an analytic Jacobian (lines 28–31). There is no damping, line search or other safeguard, which matches the page's description. The Jacobian `[4x-4 -6y^2; 4x^3 4+16y^3]` equals the sympy Jacobian of (f1, f2) exactly.
- **Numbers** (script from `reviewer/newtonsysaa_iter.jl`, independent value from `reviewer/indep.py` at 50 digits):

  | k | script | independent | error |
  |---|---|---|---|
  | 0 | (0.5, 0.8) | (0.5, 0.8) | 0.445 |
  | 1 | (−0.173128205128, 0.753712606838) | (−0.173128205128, 0.753712606838) | 0.237 |
  | 2 | (0.038071590057, 0.725858577763) | (0.0380715900567, 0.725858577763) | 2.37e-2 |
  | 3 | (0.061477808008, 0.724493571739) | (0.0614778080084, 0.724493571739) | 2.92e-4 |
  | 4 | (0.061770080651, 0.724490515556) | (0.0617700806507, 0.724490515556) | 4.57e-8 |
  | 5 | (0.061770126339, 0.724490515347) | (0.0617701263386, 0.724490515347) | 1.1e-15 |
  | 6–8 | unchanged, ‖F‖ = 0 | unchanged | |

  The ratio e_{k+1}/e_k² is 0.42, 0.52, 0.535, 0.535, which confirms quadratic convergence. det J* = −37.84, so the solution is non-singular.
- **Reference values:** The scripts draw no separate "true" root. They print the final iterate, x = 0.06177013, y = 0.72449052. This matches the independent solution, which has residual 0 in double precision. The degree-12 resultant shows that the system has exactly two real solutions, and multistart findroot finds no others.
- **Picture:** I looked at frames 1, 3 and 9 at full size and at the contact sheet.
  - The blue and red contours are the zero sets of f1 and f2, computed on a 400×400 grid over the plot window.
  - The steelblue path joins pts[1..frame+1].
  - The green diamond is X⁽⁰⁾.
  - The red marker and its legend label "x⁽k⁾ = (…)" show pts[k+1] for frame k, so the index is correct. Frame 3 reads x⁽2⁾ = (0.0381, 0.7259) and frame 9 reads x⁽8⁾ = (0.0618, 0.7245); both match the printed values.
  - All iterates fall inside the window: x1 = −0.173 is inside xlims −0.25. No clamping or masking is used.
  - The left part of the f2 loop (x down to −1.558) lies outside the window. This does not affect anything the page discusses.
  - The current-iterate marker is red, the same colour as the f2 curve. This is cosmetic and readable.

### newtonsysab.jl
- **Method:** Identical to newtonsysaa.jl apart from p0 = [2.0, −1.0], the window x ∈ [−0.25, 2.75], y ∈ [−1.5, 1.25], the title and the file names (checked with `diff`).
- **Numbers** (script beside independent value):

  | k | script | independent | error |
  |---|---|---|---|
  | 0 | (2, −1) | (2, −1) | 0.614 |
  | 1 | (1.75, −0.666666666667) | (1.75, −0.666666666667) | 0.214 |
  | 2 | (1.589691077157, −0.577916982642) | (1.58969107716, −0.577916982642) | 3.37e-2 |
  | 3 | (1.557144460948, −0.575553596832) | (1.55714446095, −0.575553596832) | 1.05e-3 |
  | 4 | (1.556098540666, −0.575650704608) | (1.55609854067, −0.575650704608) | 1.06e-6 |
  | 5 | (1.556097484323, −0.575650769619) | (1.55609748432, −0.575650769619) | 1.08e-12 |
  | 6–8 | (1.556097484322053, −0.575650769618843), ‖F‖ ≈ 5e-16 | same | |

  The ratio e_{k+1}/e_k² is 0.73, 0.93, 0.957, 0.960, 0.960, which confirms quadratic convergence. det J* = 32.08.
- **Reference values:** The printed result, x = 1.55609748, y = −0.57565077, matches the independent solution to all printed digits.
- **Picture:** I looked at frames 1, 3 and 9 at full size and at the contact sheet.
  - The curves, path, start marker and current-iterate label are built the same way as in newtonsysaa.
  - Frame 3 reads x⁽2⁾ = (1.5897, −0.5779) and frame 9 reads x⁽8⁾ = (1.5561, −0.5757); both are correct.
  - All iterates are inside the window and no clamping is used.
  - The frames show Solution 2 at the right-hand tip of the red closed curve. This is the visual evidence for F2.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/nonlinear-systems/`](evidence/nonlinear-systems/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
