# Nonlinear Systems — animation review (round 2)

Page: `pages/numerical-methods/nonlinear-systems/`. Reported findings: **0 Error, 1 Misleading, 1 Minor**.

## Findings

### F1: Page match, Misleading: the claim that Newton needs only "a handful of iterations from anywhere in the basin"

- **Location:** `index.qmd` line 76, Animations introduction: "Quadratic convergence means the error roughly squares each step — the path reaches the intersection within a handful of iterations from anywhere in the basin."
- **What is there now:** The page says that every start in a basin reaches the solution in a few steps, and gives quadratic convergence as the reason.
- **What is true instead:** Quadratic convergence is a local property. It holds once the iterate is close to the solution. Starts that lie inside a basin but near the curve where det J = 0 can take dozens of iterations before the quadratic phase begins. The typical count is small (median 6 to 7), but the worst cases inside both plot windows are 36 to 83 iterations.
- **How I know:** `/usr/bin/python3 review/basin.py` runs float64 Newton with the scripts' Jacobian from every point of a 301×301 grid over each plot window and counts the iterations needed to get within 1e-10 of a solution:
  - Case 1 window [-0.25, 2.25] × [-1.25, 1.5]:
    - Solution 1: median 6 iterations, 90th percentile 10, maximum 36 (start (0.2667, -0.6267)).
    - Solution 2: median 7, maximum 78 (start (0.19167, -0.63583)).
  - Case 2 window [-0.25, 2.75] × [-1.5, 1.25]:
    - Solution 1: maximum 47.
    - Solution 2: maximum 83 (start (0.19, -0.62917)).
  - At (0.19, -0.629), det J ≈ (-3.24)(0.018) + (2.374)(0.0274) ≈ 0.007, so the Jacobian is nearly singular there.
  - 131 to 173 grid starts did not converge within 200 iterations.
- **Suggested correction:** Replace the clause with: "Quadratic convergence means that once the iterate is close to the intersection, the error roughly squares each step, so the last few steps take the path onto the intersection almost at once. From starts far away, or near points where the Jacobian is singular, Newton's method can wander for many steps first."

- **Independent check:** confirmed (checker's own grid of starting points: some starts near the singular-Jacobian curve need tens of iterations)

### F2: Fidelity, Minor: Mathews' fixed-point example (Example 1) is dropped without comment

- **Location:** `index.qmd`, Animations section (lines 70 to 94). It contains only Newton cases, although the Description has a full "Fixed-Point Iteration for Systems" section (lines 26 to 38).
- **What is there now:** Neither case illustrates fixed-point iteration, and the page does not mention that the archive's fixed-point example was left out.
- **What the archive has:** Example 1 in `NewtonSystemMod_lnk_2.html` applies fixed-point iteration to the same system, written as x = g1 = (2x² − 2y³ + 1)/4 and y = g2 = (−x⁴ − 4y⁴ + 8y + 4)/12 (image `NewtonSystemMod_gr_75.gif`). The point of the example is that fixed-point iteration finds the upper-left solution but cannot find the second solution (1.5560974843220556, −0.5756507696188449), and that the row-sum condition explains why. Example 2 then uses Newton's method to get both solutions. The archive images that held Example 1's starting points (gr_76 to gr_114) are missing, but the map G and the solutions are complete.
- **How I know the example works as described:** `/usr/bin/python3 review/fixpt.py` evaluates the Jacobian of G at both solutions:
  - At Solution 1 (0.06177, 0.72449): row sums 0.849 and 0.160, spectral radius 0.160. Fixed-point iteration converges there.
  - At Solution 2 (1.55610, −0.57565): row sums 2.05 and 2.18, spectral radius 2.09. The fixed point is repelling.
  - Fixed-point iteration started at (1.55, −0.57), very close to Solution 2, still ends at Solution 1 after 60 iterations.
  - This contrast is exactly what the page's Description covers in lines 34 to 38.
- **Suggested correction:** Either add a fixed-point case using Mathews' G (for example, one start converging to Solution 1, and one start at (1.55, −0.57) being pushed away from Solution 2), or add one sentence saying that the archive's fixed-point example is not animated.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Checked and not reported

These issues are cosmetic and do not change what a viewer would conclude:
- In frame 0 of both GIFs, the red current-iterate marker sits exactly on top of the green start diamond and hides it.
- The legend label `x⁽k⁾` puts superscript parentheses around a full-size digit, for example `x⁽2⁾`.
- The current-iterate marker is red, the same colour as the f2 = 0 curve.

The Animations section also does not cover Mathews' Example 5 (a 3D exercise) or Example 4 (Newton viewed as a fixed-point scheme). Both were exercises rather than worked examples with recoverable parameters, so I count them as content the page does not have, not as dropped cases.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonsysaa.jl` | 0 | 7.0 | newtonsysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonsysab.jl` | 0 | 7.2 | newtonsysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | L14–16 | Solutions of the system are the intersection points of the curves f = 0 and g = 0 | Definition | confirmed |
| D2 | L22–24 | Jacobian J = [[f_x, f_y], [g_x, g_y]]; J_ij = ∂F_i/∂x_j | Standard definition. Both scripts use this layout; sympy's `jacobian` gives the same matrix `[[4x−4, −6y²], [4x³, 16y³+4]]` as the scripts' `Jac` | confirmed |
| D3 | L28–32 | Fixed-point iteration X^(k+1) = G(X^(k)) | Definition | confirmed |
| D4 | L34–36 | The row-sum condition at X\*, with a start close enough, gives convergence | The ∞-norm of J_G being below 1 implies a spectral radius below 1, which gives local convergence. Matches Mathews' Theorem, Case (i) | confirmed |
| D5 | L38 | The row-sum condition is sufficient, not necessary; local convergence holds iff the spectral radius is below 1 (stated as "whenever") | Standard result. Illustrated at Solution 1: row sum 0.849, ρ = 0.160 | confirmed |
| D6 | L44–48 | Newton step: J ΔX = −F, X^(k+1) = X^(k) + ΔX | Scripts compute `pts[k] - Jv \ F(pts[k])`, which is the same update | confirmed |
| D7 | L50–55 | Four steps: evaluate F, evaluate J, solve, update | Matches the script loop and Mathews' Theorem steps 1 to 4 | confirmed |
| D8 | L57 | Quadratic convergence near a non-singular solution; correct digits roughly double | det J(X\*) = −37.84 and 32.08 at the two solutions. The ratio e_k/e_{k−1}² settles near 0.535 (Case 1) and 0.960 (Case 2), as quadratic convergence requires | confirmed |
| D9 | L57 | A singular Jacobian at the solution loses the quadratic rate | Standard theory; not computed here, since neither solution of this system is singular | confirmed (theory, not computed) |
| D10 | L57 | The same algorithm works in any dimension; only the linear system's size changes | Script code is dimension-agnostic apart from `Jac` | confirmed |
| D11 | L61–66 | Table: fixed point is linear when it converges, Newton is quadratic; cost per step and guarantee as stated | Rates and costs are standard. "Starting-point sensitivity High/Moderate" is a judgement with no definite value | confirmed (rates, cost, guarantee); could not determine (sensitivity row: not an objective claim) |
| A1 | L74 | System f1 = 1 − 4x + 2x² − 2y³, f2 = −4 + x⁴ + 4y + 4y⁴ | Identical to `f1` and `f2` in both scripts (lines 12–13 and 13–14) and to Mathews' Example 2 (`gr_221.gif`) | confirmed |
| A2 | L76 | Blue curve is f1 = 0, red curve is f2 = 0 | `lc=:blue` on Z1 and `lc=:red` on Z2; legend agrees. In the frames, blue crosses x = 0.5 at y ≈ −0.63 (true f1 root −0.62996) and red at y ≈ 0.718 and −1.218 (true f2 roots 0.71825 and −1.21825) | confirmed |
| A3 | L76 | "Their two intersections are the solutions" (exactly two) | The degree-12 resultant in y has exactly two real roots that give real solutions: (0.0617701263, 0.7244905153) and (1.5560974843, −0.5756507696). Both lie inside both plot windows | confirmed |
| A4 | L76 | Each frame adds one Newton step | Frame 0 shows only x⁽⁰⁾; frames 1 to 8 each add one point of `pts` | confirmed |
| A5 | L76 | Each step evaluates the Jacobian, solves J ΔX = −F and updates | Script lines 28–31 | confirmed |
| A6 | L76 | The error roughly squares each step | Ratios above (D8) | confirmed |
| A7 | L76 | The path reaches the intersection "within a handful of iterations from anywhere in the basin" | Worst starts inside the window need 36 to 83 iterations; see F1 | **wrong** (F1) |
| A8 | L78, 84, 92 | Julia sources are linked under each case | `[Julia source](newtonsysaa.jl)` and `(newtonsysab.jl)` exist | confirmed |
| C1-1 | L80 | Case 1 starts at (0.5, 0.8) and goes to Solution 1 | `p0 = [0.5, 0.8]` in `newtonsysaa.jl`; the limit is Solution 1 | confirmed |
| C1-2 | L82 | Start is "just above the red curve and well above the blue curve at x = 0.5" | At x = 0.5, red is at y = 0.718 (0.08 below the start) and blue is at y = −0.630 | confirmed |
| C1-3 | L82 | Converges rapidly to (x\*, y\*) ≈ (0.0618, 0.7245) | True value (0.06177013, 0.72449052) | confirmed |
| C1-4 | L82 | The solution is the upper-left intersection | Frames: about (0.06, 0.72) in a [−0.25, 2.25] × [−1.25, 1.5] window | confirmed |
| C1-5 | L82 | Distances 0.44 → 0.24 → 0.024 → 3×10⁻⁴ → 5×10⁻⁸ → 1×10⁻¹⁵ | mpmath: 0.4447, 0.2367, 0.02374, 2.923e−4, 4.569e−8, 1.116e−15 | confirmed |
| C1-6 | L82 | Each error is roughly the square of the previous one | Ratios 1.20, 0.42, 0.52, 0.535, 0.535 | confirmed |
| C1-7 | L86 alt | Path from (0.5, 0.8) converges to about (0.062, 0.724), where blue and red intersect | True value (0.06177, 0.72449) | confirmed |
| C1-8 | L84/86 | Wiring: Case 1 uses `newtonsysaa.jl` and `newtonsysaa.gif` | Script title "Starting at (0.5, 0.8)"; the GIF is that script's output (byte-identical on regeneration) | confirmed |
| C2-1 | L88 | Case 2 starts at (2, −1) and goes to Solution 2 | `p0 = [2.0, -1.0]`; the limit is Solution 2 | confirmed |
| C2-2 | L90 | Start lies in the lower-right region near Solution 2 | 0.614 from Solution 2; lower right of the window in the frames | confirmed |
| C2-3 | L90 | (x\*, y\*) ≈ (1.5561, −0.5757), the lower-right intersection | True value (1.55609748, −0.57565077) | confirmed |
| C2-4 | L90 | Blue crosses red close to red's rightmost point (1.5579, −0.6300) | The rightmost point of f2 = 0 is where ∂f2/∂y = 0, so y = −(1/4)^(1/3) = −0.629961 and x = 1.557854. The solution is 0.054 away in y | confirmed |
| C2-5 | L90 | Distances 0.61 → 0.21 → 0.034 → 1.1×10⁻³ → 1.1×10⁻⁶ → 1.1×10⁻¹² | mpmath: 0.6141, 0.2142, 0.03367, 1.051e−3, 1.058e−6, 1.076e−12 | confirmed |
| C2-6 | L90 | Quadratic convergence, each error roughly the square of the previous one | Ratios 0.57, 0.73, 0.93, 0.957, 0.960 | confirmed |
| C2-7 | L94 alt | Path from (2, −1) converges to about (1.556, −0.576) in the lower right | True value | confirmed |
| C2-8 | L92/94 | Wiring: Case 2 uses `newtonsysab.jl` and `newtonsysab.gif` | Script title "Starting at (2, -1)"; GIF byte-identical on regeneration | confirmed |
| S1 | script header `newtonsysab.jl` L5 | "converges to x\* ≈ 1.5561, y\* ≈ −0.5757" | True value | confirmed |
| G1 | frames | Legend labels x⁽k⁾ = (…) at 4 decimals | Checked frames aa 0, 2 and 8, and ab 1, 3 and 8 against the instrumented output: (0.5, 0.8), (0.0381, 0.7259), (0.0618, 0.7245); (1.75, −0.6667), (1.5571, −0.5756), (1.5561, −0.5757). All match | confirmed |
| G2 | frames | Number of frames: 9 per GIF (x⁽⁰⁾ to x⁽⁸⁾) | `frames.md5` has 9 entries per GIF; `n_iters = 8` | confirmed |

---

### 3. Implementation checks

### `newtonsysaa.jl` (Case 1)

1. **Method:** The script runs plain, undamped Newton–Raphson for a 2×2 system: `pts[k+1] = pts[k] - Jac \ F`. There is no line search or other safeguard, which matches the Description. `Jac` matches sympy's symbolic Jacobian of (f1, f2) entry for entry.
2. **Numbers:** In the instrumented copy, `julia review/newtonsysaa_instr.jl` prints iterates, with the independent mpmath 50-digit Newton run (`review/indep.py`) beside them:

   | k | script x | script y | mpmath x | mpmath y | ‖F‖ (script) |
   |---|---|---|---|---|---|
   | 0 | 0.5 | 0.8 | 0.5 | 0.8 | 1.77 |
   | 1 | −0.1731282051 | 0.7537126068 | −0.1731282051 | 0.7537126068 | 0.947 |
   | 2 | 0.0380715901 | 0.7258585778 | 0.03807159006 | 0.7258585778 | 0.0868 |
   | 3 | 0.0614778080 | 0.7244935717 | 0.06147780801 | 0.7244935717 | 1.09e−3 |
   | 4 | 0.0617700807 | 0.7244905156 | 0.06177008065 | 0.7244905156 | 1.71e−7 |
   | 5 | 0.0617701263 | 0.7244905153 | 0.06177012634 | 0.7244905153 | 4.1e−15 |
   | 6–8 | 0.06177012633860736 | 0.7244905153472166 | 0.0617701263386074 | 0.724490515347217 | 0 |

   The two runs agree to every printed digit. The residual falls quadratically.
3. **Reference values:** The script draws no separate reference. The "Solution 1" it prints is pts[8] = (0.06177013, 0.72449052). It agrees with the resultant/nroots solution (0.0617701263386, 0.7244905153472) to all 8 digits.
4. **Picture:**
   - The contours are drawn at level 0 of the correct functions on a 400×400 grid (checked at x = 0.5, see A2).
   - The path joins pts[1..frame+1] in order.
   - The start diamond sits at pts[1], and the red marker and its label sit at pts[frame+1] with the matching index.
   - The title's start point matches `p0`.
   - The axis limits contain the start, every iterate (the minimum x is −0.173, above −0.25) and both solutions. There is no clamping or NaN masking.
   - Cosmetic only: in frame 0 the red marker covers the green diamond.

### `newtonsysab.jl` (Case 2)

1. **Method:** Plain Newton–Raphson, with code identical to Case 1 apart from `p0`, the axis limits and the title.
2. **Numbers:** In the instrumented copy, `julia review/newtonsysab_instr.jl` prints the following, again beside the mpmath run:

   | k | script x | script y | mpmath x | mpmath y | ‖F‖ (script) |
   |---|---|---|---|---|---|
   | 0 | 2.0 | −1.0 | 2.0 | −1.0 | 12.37 |
   | 1 | 1.75 | −0.6666666667 | 1.75 | −0.6666666667 | 3.58 |
   | 2 | 1.5896910772 | −0.5779169826 | 1.589691077 | −0.5779169826 | 0.527 |
   | 3 | 1.5571444609 | −0.5755535968 | 1.557144461 | −0.5755535968 | 0.0160 |
   | 4 | 1.5560985407 | −0.5756507046 | 1.556098541 | −0.5756507046 | 1.61e−5 |
   | 5 | 1.5560974843 | −0.5756507696 | 1.556097484 | −0.5756507696 | 1.64e−11 |
   | 6–8 | 1.556097484322053 | −0.5756507696188433 | 1.55609748432205 | −0.575650769618843 | 5e−16 |

   The two runs agree. The k = 1 step can be checked by hand: F(2, −1) = (3, 12) and J = [[4, −6], [32, −12]], so ΔX = (−0.25, 0.3333). This gives (1.75, −0.6667), as printed.
3. **Reference values:** The printed "Solution 2" (1.55609748, −0.57565077) matches the resultant solution, and it matches the value Mathews quotes in `lnk_2` (1.5560974843220556, −0.5756507696188449).
4. **Picture:**
   - The geometry and labels were checked as for Case 1 (frames 1, 3 and 8).
   - The window [−0.25, 2.75] × [−1.5, 1.25] contains the start and every iterate.
   - The red curve's rightmost point (1.558, −0.630) and the crossing are visible and distinguishable at the scale shown.
   - There is no clamping.

### Legacy archive

- The page's system matches Mathews' Example 2 exactly.
- Mathews' starting points for Example 2 are in images that are missing from the archive (the lnk_3 images are absent), so I could not compare the page's starts (0.5, 0.8) and (2, −1) with his.
- Mathews' fixed-point Example 1 on the same system is not represented in the Animations section (F2).

