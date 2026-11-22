# Nonlinear Systems — animation review (round 3)

Page: `pages/numerical-methods/nonlinear-systems/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agreed with my independent computation at the precision it is stated to. Both scripts implement plain (undamped) Newton's method correctly and draw what they compute.

Two observations fall short of a finding. They are recorded here so that the clean result is not read as unexamined:
- In frame 0 of each GIF, the red current-iterate marker is drawn on top of the green start diamond (legend `x⁽⁰⁾`), which hides the diamond. The diamond appears from frame 1 on. This is cosmetic, and nothing about the method is misrepresented.
- The current-iterate marker is red, the same colour as the f2 = 0 curve. The legend makes the meaning clear, and this is a colour choice, so it is not a finding.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonsysaa.jl` | 0 | 8.6 | newtonsysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonsysab.jl` | 0 | 7.4 | newtonsysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtonsysaa.gif` | 9 | byte-identical | newtonsysaa |
| `newtonsysab.gif` | 9 | byte-identical | newtonsysab |

### Page references

- Scripts linked: `newtonsysaa.jl`, `newtonsysab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Claims are quoted in the page's own words. "Independent" means my sympy or mpmath computation, or my numpy grid. "Script" means my instrumented Julia copy.

### Description section (method statements)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| D1 | Jacobian $J = [[f_x, f_y],[g_x, g_y]]$, with $J_{ij} = \partial F_i/\partial x_j$ | confirmed | standard definition; sympy Jacobian of the system equals the script's `Jac` (see I-1) |
| D2 | Fixed point: if $\mathbf{X}^*$ exists, the start is close enough, and the row-sum condition holds at $\mathbf{X}^*$, the iteration converges | confirmed | row sums < 1 at X* means ‖J_G(X*)‖∞ < 1; by continuity G is an ∞-norm contraction on a small ball. This matches Mathews' Theorem, Case (i) |
| D3 | "The row-sum condition is sufficient, not necessary … converges whenever the spectral radius … is less than 1" (local) | confirmed | standard local convergence theorem (Ostrowski) |
| D4 | Newton linearisation $F(X+\Delta X) \approx F + J\Delta X = 0$, step $J\Delta X = -F$, $X^{k+1} = X^k + \Delta X$ | confirmed | matches Mathews' Steps 1–4, and the scripts run exactly `pts[k] - Jv \ F(pts[k])` |
| D5 | The four steps (evaluate F, evaluate J, solve, update) | confirmed | same as D4 |
| D6 | Quadratic convergence near a nonsingular solution; correct digits roughly double | confirmed | e_{k+1}/e_k² ≈ 0.42, 0.52, 0.53, 0.53 (Case 1) and 0.73, 0.93, 0.96, 0.96 (Case 2) from the mpmath errors in I-2 |
| D7 | With singular J at the solution, the quadratic rate is lost | confirmed (generic case) | standard result; not exercised by this page |
| D8 | The algorithm is dimension-independent; only the size of the Step 3 system changes | confirmed | the formulation is vector-valued |
| D9 | Table: FP linear and Newton quadratic; FP cheap and Newton needs J plus a solve; FP convergence guarantee is row-sum (sufficient), Newton needs a good start | confirmed | standard. "Linear" is the generic FP rate (it is faster when J_G(X*) = 0); acceptable as a table summary |
| D10 | Table: starting-point sensitivity "High" for FP, "Moderate" for Newton | could not determine | qualitative judgement with no measurable content. Not a finding |

### Animations section

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | System $f_1 = 1-4x+2x^2-2y^3$, $f_2 = -4+x^4+4y+4y^4$ | confirmed | identical to the script's `f1` and `f2` (both scripts, lines 12–13 / 13–14) and to Mathews' Example 2 (`gr_221.gif`) |
| A2 | "The blue curve is $f_1=0$ and the red curve is $f_2=0$" | confirmed | `contour!(…, Z1; levels=[0.0], lc=:blue)` and `Z2 … lc=:red`. In the frames, blue crosses x = 0.5 at y ≈ −0.63, where f1 = 0 has its only real root y = −0.62996; red crosses at y ≈ 0.72 and −1.22, the roots 0.71825 and −1.21825 |
| A3 | "Their two intersections are the solutions" (exactly two) | confirmed | resultant in y has degree 12 and a Sturm count of **2** real roots: y = 0.724490515347 and −0.575650769619. Each gives one real x satisfying both equations |
| A4 | "Each frame adds one Newton step" (Jacobian at the current point, solve, update) | confirmed | 9 frames: frame 0 is the start and frames 1–8 each add iterate k. The update matches the code |
| A5 | "Quadratic convergence is a local property … only once the iterate is close" | confirmed | consistent with D6 and A6 |
| A6 | "Over a 301 × 301 grid … covering each plot window, more than 90% get within $10^{-10}$ of a solution in at most 10 iterations" | confirmed | window 1, x∈[−0.25, 2.25], y∈[−1.25, 1.5]: **91.32 %**. Window 2, x∈[−0.25, 2.75], y∈[−1.5, 1.25]: **93.21 %**. numpy and Julia agree. No start failed to converge within 5000 iterations |
| A7 | "Starts near the curve where … $\det J = 0$ can instead be thrown far outside the window and need dozens of iterations to come back" | confirmed | starts needing ≥ 24 iterations: 1813 and 1362. Of these, 85 % and 82 % lie within 0.1 of det J = 0. Their median distance is 0.037 and 0.040, against 0.55 and 0.72 for all starts. The slowest starts jump on the first step to (3.34, −5.29) and (4.03, −7.20), and their paths reach magnitudes of 1.9e29 and 9.1e23 |
| A8 | "over 200 for the slowest start in each window" | confirmed | slowest start in window 1 is (−0.1083, −0.6908) with **246** iterations. In window 2 it is (−0.2, −0.675) with **203**. numpy (Cramer) and Julia (`\`) give identical counts. Window 2 clears 200 by only 3 iterations, so this figure depends on the window and grid; it is true as stated |
| A9 | "Julia source scripts … are linked under each case" | confirmed | two links, both resolving to files in the folder |
| C1.1 | Heading: Case 1, Solution 1, starting at (0.5, 0.8) | confirmed | `p0 = [0.5, 0.8]`, and the GIF title reads "Starting at (0.5, 0.8)" |
| C1.2 | "Starting just above the red curve and well above the blue curve at $x = 0.5$" | confirmed | red at x = 0.5 is y = 0.71825, so 0.8 is 0.08 above it. Blue is y = −0.62996, 1.43 below the start |
| C1.3 | "converges rapidly to Solution 1 at approximately (0.0618, 0.7245)" | confirmed | independent (0.0617701263386, 0.724490515347) |
| C1.4 | "the intersection in the upper-left portion of the plot" | confirmed | frames |
| C1.5 | Distances 0.44 → 0.24 → 0.024 → 3e-4 → 5e-8 → 1e-15 | confirmed | mpmath: 0.4447, 0.2367, 0.02374, 2.923e-4, 4.569e-8, 1.116e-15. Script (float64): same, last 1.096e-15 |
| C1.6 | "each error roughly the square of the previous one (quadratic)" | confirmed | ratios ≈ 0.5 (D6) |
| C1.7 | Link `newtonsysaa.jl` and embed `newtonsysaa.gif` | confirmed | the script has p0 = (0.5, 0.8) and writes `newtonsysaa.gif`, byte-identical to regeneration |
| C1.8 | Alt text: "converging from (0.5, 0.8) to Solution 1 at approximately (0.062, 0.724) … blue f₁=0 … red f₂=0" | confirmed | as C1.3 and A2 |
| C2.1 | Heading: Case 2, Solution 2, starting at (2, −1) | confirmed | `p0 = [2.0, -1.0]`, and the title reads "Starting at (2, -1)" |
| C2.2 | "Starting in the lower-right region near Solution 2" | confirmed | start is 0.61 from the solution, in the lower right of the window |
| C2.3 | "converges to (1.5561, −0.5757), the lower-right intersection" | confirmed | independent (1.55609748432, −0.575650769619). Also matches Mathews' value {1.5560974843220556, −0.5756507696188449} quoted in Example 1 |
| C2.4 | "the blue curve crosses the red curve $f_2=0$ close to its rightmost point (1.5579, −0.6300)" | confirmed | max x on f2 = 0: dx/dy = 0 gives 4 + 16y³ = 0, so y = −(1/4)^{1/3} = −0.629961 and x = 1.557854. The solution is 0.054 away |
| C2.5 | Distances 0.61 → 0.21 → 0.034 → 1.1e-3 → 1.1e-6 → 1.1e-12 | confirmed | mpmath: 0.6141, 0.2142, 0.03367, 1.051e-3, 1.058e-6, 1.076e-12. The script gives the same values |
| C2.6 | "Again convergence is quadratic … each error roughly the square of the previous one" | confirmed | ratios 0.73 to 0.96 (D6) |
| C2.7 | Link `newtonsysab.jl` and embed `newtonsysab.gif` | confirmed | p0 = (2, −1), and the GIF is byte-identical to regeneration |
| C2.8 | Alt text: "converging from (2, −1) to Solution 2 at approximately (1.556, −0.576) … lower-right region" | confirmed | as C2.3 |
| S1 | Script header comment `newtonsysab.jl:5`: "converges to x* ≈ 1.5561, y* ≈ −0.5757" | confirmed | as C2.3 |
| F1 | GIF legend labels `x⁽k⁾ = (…)`, checked in frames 0, 1, 2, 3, 8 of each GIF | confirmed | aa: frame 2 shows (0.0381, 0.7259) and frame 8 shows (0.0618, 0.7245). ab: frame 1 (1.75, −0.6667), 2 (1.5897, −0.5779), 3 (1.5571, −0.5756), 8 (1.5561, −0.5757). All equal the script iterates rounded to 4 decimals |

The closing paragraph listing the archive examples that are not animated is legacy inventory, which the brief excludes. I did read it, and it matches the archive's list (Example 1 FP, Example 3 equivalence, Example 4 Newton as FP, Exercise 5 3-D).

### Fidelity to the legacy archive

- System: identical to Mathews' Example 2 (`gr_221.gif`). **Confirmed.**
- Example 2 asks for Newton solutions "near" two points, and the page has two cases, one per real solution. The starting-point formula images (`gr_222..gr_224` and others) are **missing from the archive**, so I **could not determine** whether (0.5, 0.8) and (2, −1) are Mathews' starts. Both converge to the intended solutions, so a reader is not misled either way.
- Solution 2 agrees with the value printed in Mathews' Example 1 text to every digit the page shows.
- The fixed-point Example 1, Examples 3 and 4, and Exercise 5 are not animated, but the page names them explicitly, so nothing is dropped silently. No Fidelity finding.

---

### 3. Implementation checks

### I-1 `newtonsysaa.jl` (Case 1)
- **Method:** pure Newton's method for systems with no damping or line search: `pts[k+1] = pts[k] - Jac(...) \ F(pts[k])`, 8 iterations. This is the method the page describes (D4).
- **Jacobian:** `[4x-4  -6y^2; 4x^3  4+16y^3]`. sympy gives `[[4x-4, -6y^2],[4x^3, 16y^3+4]]`, which is identical.
- **Numbers:** script iterates set beside the 50-digit mpmath values:

| k | script (x, y) | mpmath (x, y) |
|---|---|---|
| 0 | 0.5, 0.8 | 0.5, 0.8 |
| 1 | −0.173128205128, 0.753712606838 | −0.173128205128, 0.753712606838 |
| 2 | 0.0380715900567, 0.725858577763 | 0.0380715900567, 0.725858577763 |
| 3 | 0.0614778080084, 0.724493571739 | 0.0614778080084, 0.724493571739 |
| 4 | 0.0617700806507, 0.724490515556 | 0.0617700806507, 0.724490515556 |
| 8 | 0.06177012633860736, 0.7244905153472166 | 0.0617701263386074, 0.724490515347217 |

- **Reference value:** the script takes `pts[end]` as the solution, with no separate reference. It equals the independent root to about 1e-16, and the residual is at machine precision.
- **Picture:** contours are drawn at level 0 of the correct functions. The path polyline runs through `pts[1..frame+1]`, and the marker and legend show `pts[frame+1]` with the correct index. Every iterate (min x = −0.173) lies inside the window x ∈ [−0.25, 2.25], so there is no clamping or masking. Frames 1, 3 and 9 were viewed individually; the last shows convergence at the upper-left intersection.

### I-2 `newtonsysab.jl` (Case 2)
- **Method and Jacobian:** identical code to I-1, so the same conclusions hold.
- **Numbers:**

| k | script (x, y) | mpmath (x, y) |
|---|---|---|
| 0 | 2.0, −1.0 | 2.0, −1.0 |
| 1 | 1.75, −0.666666666667 | 1.75, −0.666666666667 |
| 2 | 1.58969107716, −0.577916982642 | 1.58969107716, −0.577916982642 |
| 3 | 1.55714446095, −0.575553596832 | 1.55714446095, −0.575553596832 |
| 4 | 1.55609854067, −0.575650704608 | 1.55609854067, −0.575650704608 |
| 8 | 1.556097484322053, −0.5756507696188433 | 1.55609748432205, −0.575650769618843 |

  Hand check of step 1 from (2, −1): F = (1, −4), J = [[4, −6], [32, −12]], det = 144. ΔX = −J⁻¹F = (−0.25, 0.3333), so X₁ = (1.75, −0.6667), as the script and frame 1 show.
- **Reference value:** same approach as I-1. It matches the independent root and Mathews' quoted value.
- **Picture:** the same plotting code. All iterates lie inside x ∈ [−0.25, 2.75] and y ∈ [−1.5, 1.25]. The contact sheet and frames 2 and 9 were viewed; the path and labels match the table above.

### I-3 Grid statistics (page intro), independent of the scripts' animation code
Commands: `python3 -I grid.py` (vectorised Cramer's-rule Newton, up to 5000 iterations) and `julia grid.jl` (the scripts' `Jac \ F` update). The two agree exactly:

| window | ≤ 10 its | max its (start) | > 200 its | non-convergent |
|---|---|---|---|---|
| Case 1: x∈[−0.25, 2.25], y∈[−1.25, 1.5] | 0.9132 | 246 at (−0.10833, −0.69083) | 1 | 0 |
| Case 2: x∈[−0.25, 2.75], y∈[−1.5, 1.25] | 0.9321 | 203 at (−0.2, −0.675) | 1 | 0 |

`python3 -I sing.py`: the slowest starts are 0.061 and 0.045 from the curve det J = 0. Most slow starts (≥ 24 iterations) lie within 0.1 of that curve, as in A7.

