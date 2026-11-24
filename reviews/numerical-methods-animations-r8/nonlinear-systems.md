# Nonlinear Systems — animation review (round 8)

Page: `pages/numerical-methods/nonlinear-systems/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Severity counts: Error 0, Misleading 0, Minor 0.

Every checkable claim in the Animations section and the method description was confirmed against independent computation (see ledger). Cosmetic observations that I judged not to be findings: the legend label is built as `"x⁽$(frame)⁾"`, so the iteration index renders as a normal-size digit between superscript parentheses (e.g. "x⁽2⁾"); the current-iterate marker is red, the same colour as the f₂ = 0 curve; in frame 0 the red current-iterate marker covers the green start diamond. None of these changes what a viewer would conclude.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonsysaa.jl` | 0 | 8.2 | newtonsysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonsysab.jl` | 0 | 8.2 | newtonsysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Jacobian J = [[∂f/∂x, ∂f/∂y],[∂g/∂x, ∂g/∂y]], J_ij = ∂F_i/∂x_j | standard definition | confirmed |
| D2 | Fixed-point 2D row-sum condition at X* with start sufficiently close implies convergence | matches Mathews' theorem (archive Case (i)); row-sum < 1 is ‖DG‖∞ < 1 ⇒ ρ < 1 ⇒ local convergence | confirmed |
| D3 | Row-sum condition sufficient, not necessary; local convergence whenever ρ(DG(X*)) < 1 | standard result (C¹ G) | confirmed |
| D4 | Newton step: J ΔX = −F, X⁽ᵏ⁺¹⁾ = X⁽ᵏ⁾ + ΔX; four-step algorithm | matches archive Theorem steps 1–4 and both scripts line 30 (`pts[k] - Jv \ F(pts[k])`) | confirmed |
| D5 | Quadratic convergence near a non-singular solution | det J at the solutions: −37.84 and 32.08 (non-singular); error sequences below square each step | confirmed |
| D6 | Comparison table rates (linear with factor ≈ ρ; superlinear when ρ = 0; Newton quadratic) | standard results | confirmed |
| A1 | System f₁ = 1 − 4x + 2x² − 2y³, f₂ = −4 + x⁴ + 4y + 4y⁴ | scripts lines 12–13; archive gr_221 / gr_275 identical | confirmed |
| A2 | Blue curve is f₁ = 0, red is f₂ = 0 | scripts lines 52–55 (`Z1` blue, `Z2` red); frames | confirmed |
| A3 | "Their two intersections are the solutions" | resultant in y has degree 12; exactly 2 real solutions: (0.061770126338607, 0.724490515347217), (1.556097484322053, −0.575650769618843) | confirmed |
| A4 | Each frame adds one Newton step (J evaluated, linear system solved, iterate moves) | 9 frames = start + 8 steps; scripts loop | confirmed |
| A5 | Over 301×301 grid per window, >90% within 1e-10 of a solution in ≤ 10 iterations | window 1: 91.32%; window 2: 93.21% (identical in numpy and Julia `\`) | confirmed |
| A6 | Starts near the det J = 0 curve thrown far outside the window, need dozens of iterations | starts needing >50 iterations: 100% leave the window and reach ‖X‖ > 100; median start distance to det J = 0 is 0.029 / 0.038 vs 0.55 / 0.72 for all starts | confirmed |
| A7 | Over 200 iterations for the slowest start in each window | 246 (start (−0.1083, −0.6908)) and 203 (start (−0.2, −0.675)); same in Julia; no non-convergent starts | confirmed |
| A8 | Unanimated Mathews items: Example 1 fixed-point on same system, Example 3 equivalence, Example 4 Newton as fixed point, Exercise 5 3×3 system | archive module lists exactly these; Example 1 G (gr_75) rearranges to f₁ = 0, f₂ = 0 | confirmed |
| C1-1 | Case 1 heading: start (0.5, 0.8) | `newtonsysaa.jl` line 19; GIF title | confirmed |
| C1-2 | "just above the red curve and well above the blue curve at x = 0.5" | at x = 0.5 red curve y = 0.7182, blue y = −0.6300 | confirmed |
| C1-3 | converges to Solution 1 ≈ (0.0618, 0.7245), upper-left intersection | 40-digit: (0.06177012634, 0.72449051535); script prints 0.06177013, 0.72449052; frames | confirmed |
| C1-4 | distances 0.44 → 0.24 → 0.024 → 3e-4 → 5e-8 → 1e-15 | 0.4447, 0.2367, 0.02374, 2.923e-4, 4.569e-8, 1.116e-15 | confirmed |
| C1-5 | each error roughly the square of the previous one | ratios e_{k+1}/e_k² = 1.20, 0.42, 0.52, 0.53, 0.53 | confirmed |
| C1-6 | alt text: converges to ≈ (0.062, 0.724) | 0.06177, 0.72449 | confirmed |
| C1-7 | link `newtonsysaa.jl`, embed `newtonsysaa.gif` | GIF byte-identical to regenerated output of that script (manifest); title "Starting at (0.5, 0.8)" | confirmed |
| C2-1 | Case 2 heading: start (2, −1) | `newtonsysab.jl` line 20; GIF title | confirmed |
| C2-2 | converges to (1.5561, −0.5757), lower-right intersection | 40-digit: (1.55609748432, −0.57565076962); matches Mathews' value 1.5560974843220556, −0.5756507696188449 | confirmed |
| C2-3 | red curve rightmost point (1.5579, −0.6300), solution close to it | ∂/∂y of x⁴ = 4 − 4y − 4y⁴ zero at y = −(1/4)^{1/3} = −0.629961, x = 1.557854 | confirmed |
| C2-4 | distances 0.61 → 0.21 → 0.034 → 1.1e-3 → 1.1e-6 → 1.1e-12 | 0.6141, 0.2142, 0.03367, 1.051e-3, 1.058e-6, 1.076e-12 | confirmed |
| C2-5 | each error roughly the square of the previous | ratios 0.57, 0.73, 0.93, 0.96, 0.96 | confirmed |
| C2-6 | alt text ≈ (1.556, −0.576) | confirmed by C2-2 | confirmed |
| C2-7 | link `newtonsysab.jl`, embed `newtonsysab.gif` | byte-identical regeneration; title "Starting at (2, -1)" | confirmed |
| F1 | Fidelity: system, two solutions, Newton method as in Mathews Example 2 | archive gr_221, lnk_3 ("solution near … ", twice) | confirmed |
| F2 | Fidelity: starting points (0.5, 0.8) and (2, −1) are Mathews' | images holding the starting points (gr_223/224 etc.) are missing from the archive | could not determine |

### 3. Implementation checks

Both scripts are identical apart from start, window, title and file names (diffed).

**Method.** Plain (undamped) Newton for systems: `pts[k+1] = pts[k] - Jac(...) \ F(pts[k])`, 8 iterations. Jacobian lines 15–16 `[4x-4, -6y^2; 4x^3, 4+16y^3]` match sympy's Jacobian of f₁, f₂ exactly. This is the method on the page and in Mathews' NewtonSystem subroutine (gr_220).

**Numbers.** Independent 40-digit mpmath Newton from each start (`indep.py`) vs. the iterates shown in the GIF legends:

| k | Case 1 independent | GIF legend | Case 2 independent | GIF legend |
|---|---|---|---|---|
| 0 | (0.5, 0.8) | (0.5, 0.8) | (2, −1) | (2.0, −1.0) |
| 1 | (−0.1731282, 0.7537126) | (−0.1731, 0.7537) | (1.75, −0.6666667) | (1.75, −0.6667) |
| 2 | (0.0380716, 0.7258586) | (0.0381, 0.7259) | (1.5896911, −0.5779170) | (1.5897, −0.5779) |
| 3 | (0.0614778, 0.7244936) | (0.0615, 0.7245) | (1.5571445, −0.5755536) | (1.5571, −0.5756) |
| 4–8 | (0.0617701, 0.7244905) | (0.0618, 0.7245) | (1.5560985 → 1.5560975, −0.5756507) | (1.5561, −0.5757) |

Script stdout: "Solution 1: x = 0.06177013, y = 0.72449052", "Solution 2: x = 1.55609748, y = -0.57565077", agreeing with the resultant-based roots to all printed digits.

**Reference values.** No separate reference is drawn; the "solution" is iterate 8. Both are true roots (above) and both are the only real roots (degree-12 resultant, 2 real roots).

**Picture.** Inspected contact sheets for both GIFs and frame 3 of Case 1 at full size. Contours of `Z1`/`Z2` at level 0 on a 400×400 grid reproduce the known features: blue vertical segments at x = 1 ± 1/√2 ≈ 0.293, 1.707 crossing y = 0; red curve bottom at y ≈ −1.22, top ≈ 0.72, rightmost point near (1.558, −0.63). Path polyline joins iterates 0..k; green diamond at x⁽⁰⁾; red marker and legend at x⁽ᵏ⁾ with k = frame number. All iterates lie inside the windows (Case 1 x⁽¹⁾ = −0.1731 > xlim −0.25). No clamping or masking. Committed GIFs are byte-identical to fresh regenerations (manifest).

