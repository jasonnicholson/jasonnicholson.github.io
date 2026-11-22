# Nonlinear Systems — animation review (round 4)

Page: `pages/numerical-methods/nonlinear-systems/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and in the frames agreed with my independent computation. Details are in the ledger and the implementation checks below.

(Observations that I judged are not findings: the comparison table's "Convergence rate: Linear (when it converges)" for fixed-point iteration is the standard generic statement, although a fixed-point map with G'(X*) = 0, such as Newton written as a fixed-point iteration in Mathews' Example 4, converges faster. The legend renders `x⁽1⁾` with a non-superscript digit. Frames 5 to 8 of each GIF look the same as frame 4 because the iterates have converged. All of these are cosmetic or textbook-standard.)



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonsysaa.jl` | 0 | 7.7 | newtonsysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonsysab.jl` | 0 | 7.9 | newtonsysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Jacobian of F = (f, g) is [[f_x, f_y],[g_x, g_y]]; in n-D J_ij = dF_i/dx_j | standard definition | confirmed |
| D2 | Fixed-point: iterate X(k+1) = G(X(k)); converges from starts sufficiently close if the row-sum condition holds at X* | matches Mathews' theorem (case i); a C1 map with infinity-norm of G' < 1 at X* is a local contraction | confirmed |
| D3 | Row-sum is sufficient, not necessary; local convergence whenever spectral radius of G'(X*) < 1 | Ostrowski's theorem | confirmed |
| D4 | Newton: J(X(k)) dX = -F(X(k)), X(k+1) = X(k) + dX, with the four steps listed | matches Mathews' theorem steps 1-4 and the script (`pts[k+1] = pts[k] - Jv \ F(pts[k])`) | confirmed |
| D5 | Quadratic near a non-singular solution (det J(X*) != 0); the rate is lost when J is singular at the solution | standard; det J at the two solutions = -37.84 and 32.08 (sympy), so both are non-singular | confirmed |
| D6 | Comparison table rows | generic textbook characterisations (see note above) | confirmed (generic) |
| A1 | System f1 = 1 - 4x + 2x^2 - 2y^3, f2 = -4 + x^4 + 4y + 4y^4 | the same in both scripts (lines 12-13) and in Mathews gr_221/gr_288 | confirmed |
| A2 | Blue curve is f1 = 0, red curve is f2 = 0 | `lc=:blue` on Z1 and `lc=:red` on Z2 in both scripts; the shapes check out (blue: y^3 = (x-1)^2 - 1/2, minimum at (1, -0.794), vertical tangents at x = 0.293 and 1.707; red: closed quartic loop, top at y = 0.718 near x = 0.5, rightmost point (1.558, -0.630)) | confirmed |
| A3 | "Their two intersections are the solutions." | resultant in x has degree 12 in y; exactly two real solutions, (0.0617701263, 0.7244905153) and (1.5560974843, -0.5756507696), both inside both windows (indep.py) | confirmed |
| A4 | Each frame adds one Newton step (Jacobian, linear solve, update) | the frames run 0..8, frame k shows pts[1..k+1]; the code is a plain Newton step | confirmed |
| A5 | Quadratic convergence is local; error squares only once close | the per-step ratios e_{k+1}/e_k^2 settle only after 2-3 steps (see I-1, I-2) | confirmed |
| A6 | 301x301 grid covering each plot window: more than 90% reach within 1e-10 of a solution in at most 10 iterations | Julia, using the script's own `F`, `Jac` and `\`: 91.32% (window 1), 93.21% (window 2); numpy gives the same | confirmed |
| A7 | Starts near the det J = 0 curve can be thrown far outside the window and need dozens of iterations | starts needing more than 30 iterations have median distance 0.025-0.054 to the det J = 0 curve (all starts: 0.55-0.72); 99-100% of starts needing more than 10 iterations are thrown more than 1 unit outside the window; the slowest paths reach coordinates of about 1e29 | confirmed |
| A8 | Over 200 iterations for the slowest start in each window | Julia: 246 (start (-0.1083, -0.6908)), 203 (start (-0.2, -0.675)); numpy agrees; no start fails within 5000 iterations | confirmed (window 2 is only just over 200) |
| A9 | Mathews' unanimated examples: fixed-point on this same system (Ex 1), equivalence check (Ex 3), Newton as fixed-point on this system (Ex 4), 3x3 Newton (Ex 5) | gr_75 and gr_274: x = (2x^2-2y^3+1)/4, y = (-x^4-4y^4+8y+4)/12, which is algebraically f1 = 0, f2 = 0; gr_288 is the same system; lnk_6 is 3-D "four solutions" | confirmed |
| C1-h | Case 1 heading: starting at (0.5, 0.8) | `p0 = [0.5, 0.8]`; GIF title "Starting at (0.5, 0.8)"; frame-0 legend (0.5, 0.8) | confirmed |
| C1-a | Start "just above the red curve and well above the blue curve at x = 0.5" | red at x = 0.5: y = 0.7182; blue at x = 0.5: y = -0.6300 | confirmed |
| C1-b | Converges rapidly to Solution 1 ≈ (0.0618, 0.7245) | true value (0.06177013, 0.72449052); script prints the same | confirmed |
| C1-c | "the intersection in the upper-left portion of the plot" | x = 0.06 in [-0.25, 2.25], y = 0.72 in [-1.25, 1.5]; the frames show it upper left | confirmed |
| C1-d | Distances 0.44 → 0.24 → 0.024 → 3e-4 → 5e-8 → 1e-15 | mpmath (40 digits): 0.4447, 0.2367, 0.02374, 2.923e-4, 4.569e-8, 1.116e-15 | confirmed |
| C1-e | "each error roughly the square of the previous one (quadratic convergence)" | e_{k+1}/e_k^2 = 1.20, 0.42, 0.52, 0.53, 0.53, so roughly C·e^2 with C ≈ 0.5 | confirmed |
| C1-alt | Alt text: converging from (0.5, 0.8) to ≈ (0.062, 0.724) | 0.0618, 0.72449 | confirmed |
| C1-w | Source link `newtonsysaa.jl`, embed `newtonsysaa.gif` | the script writes that GIF; the GIF title and start match the heading | confirmed |
| C2-h | Case 2 heading: starting at (2, -1) | `p0 = [2.0, -1.0]`; GIF title and frame-0 legend (2.0, -1.0) | confirmed |
| C2-a | Start in the lower-right region near Solution 2 | (2, -1) in window [-0.25, 2.75] x [-1.5, 1.25] is lower right; 0.61 from the solution | confirmed |
| C2-b | Converges to ≈ (1.5561, -0.5757) | (1.55609748, -0.57565077); Mathews lnk_2 quotes {1.5560974843220556, -0.5756507696188449} | confirmed |
| C2-c | Blue crosses red close to red's rightmost point (1.5579, -0.6300) | rightmost point of f2 = 0: y = -(1/4)^(1/3) = -0.629961, x = 1.557854; the solution is 0.054 away | confirmed |
| C2-d | Distances 0.61 → 0.21 → 0.034 → 1.1e-3 → 1.1e-6 → 1.1e-12 | mpmath: 0.6141, 0.2142, 0.03367, 1.051e-3, 1.058e-6, 1.076e-12 | confirmed |
| C2-e | Each error roughly the square of the previous one | ratios 0.57, 0.73, 0.93, 0.96, 0.96 | confirmed |
| C2-alt | Alt text: from (2, -1) to ≈ (1.556, -0.576), lower right | as above | confirmed |
| C2-w | Source link `newtonsysab.jl`, embed `newtonsysab.gif` | matches | confirmed |
| G1 | "Julia source scripts ... are linked under each case" | two links, two embeds | confirmed |
| F1 | Fidelity: the page animates Mathews' Example 2 (Newton on this system) toward both solutions | system matches gr_221; Ex 1 names the second solution, which matches Case 2; starting points: **could not determine**, because the Example 2 images (gr_222 to gr_273) are missing from the archive | confirmed for system and solutions; starting points could not be determined |

### 3. Implementation checks

### `newtonsysaa.jl` (Case 1)
- **Method:** plain (undamped) Newton's method for systems, `pts[k+1] = pts[k] - Jac \ F`. The Jacobian `[4x-4  -6y^2; 4x^3  4+16y^3]` matches the sympy Jacobian of (f1, f2) exactly.
- **Numbers:** script iterates (frame legends, 4 d.p.) against mpmath:
  - k=1: script (-0.1731, 0.7537), mpmath (-0.173128, 0.753713)
  - k=2: script (0.0381, 0.7259), mpmath (0.038072, 0.725859)
  - k=3: script (0.0615, 0.7245), mpmath (0.061478, 0.724494)
  - k=4..8: script (0.0618, 0.7245), mpmath (0.0617701, 0.7244905)
  - final iterate printed by the script: (0.06177013, 0.72449052); mpmath (0.0617701263, 0.7244905153)
- **Reference values:** the script has no separate reference; the solution is the converged iterate. It is independently confirmed by the resultant/nroots computation, with residual about 1e-30 in mpmath.
- **Picture:** the contour grid has rows = y and columns = x, which matches the `contour!(xg, yg, Z)` convention. The curves agree with the analytic features listed in A2. The path joins pts[1..frame+1], the green diamond is the start, and the red marker is the current iterate with the correct index and value. Every iterate lies inside the window (the smallest x is -0.173 > -0.25). There is no clamping or masking. Frames checked: 1, 2, 3, 4, 9 and the contact sheet.

### `newtonsysab.jl` (Case 2)
- **Method:** identical Newton code with the same Jacobian.
- **Numbers:**
  - k=1: script (1.75, -0.6667), mpmath (1.75, -0.666667)
  - k=2: script (1.5897, -0.5779), mpmath (1.589691, -0.577917)
  - k=3: script (1.5571, -0.5756), mpmath (1.557144, -0.575554)
  - k=4..8: script (1.5561, -0.5757), mpmath (1.5560975, -0.5756508)
  - printed final: (1.55609748, -0.57565077)
- **Reference values:** confirmed by the resultant computation and by Mathews' Mathematica value.
- **Picture:** the same structure as Case 1. Every iterate is inside the window [-0.25, 2.75] x [-1.5, 1.25]. The labels match the computed values. Frames checked: the contact sheet (all 9).

### Page-level grid statistic (A6 to A8)
Re-run in Julia with the scripts' own `F`, `Jac` and `\` (`review/grid.jl`). The script iterates from each of the 301x301 starts until the start is within 1e-10 of either solution, with a cap of 5000 iterations. Results:

| Window | Within 1e-10 in ≤ 10 iterations | Slowest start | Iterations | Starts over 200 | Starts that never converge |
|---|---|---|---|---|---|
| (-0.25, 2.25) x (-1.25, 1.5) | 91.32% | (-0.108, -0.691) | 246 | 1 | 0 |
| (-0.25, 2.75) x (-1.5, 1.25) | 93.21% | (-0.2, -0.675) | 203 | 1 | 0 |

The independent numpy run (Cramer's-rule solve, `review/grid.py`) gives identical counts.

