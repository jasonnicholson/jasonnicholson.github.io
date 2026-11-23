# Nonlinear Systems — animation review (round 6)

Page: `pages/numerical-methods/nonlinear-systems/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim in the page passed against an independent computation (section 2), both scripts implement plain Newton's method for systems with a correct Jacobian, and the frames show what was computed (section 3).

Observations that I judged NOT to be findings (recorded so the clean result can be audited):
- In frame 0 of both GIFs the green start diamond (x⁽⁰⁾) is drawn underneath the red current-iterate marker at the same point, so it is not visible although it is listed in the legend. From frame 1 on it is visible. This is cosmetic and does not mislead.
- The current-iterate marker is red, the same colour as the f₂ = 0 curve. The legend distinguishes them, and the marker is a large dot, not a line. Cosmetic.
- "each error roughly the square of the previous one": the measured ratios e_{k+1}/e_k² are 1.2, 0.42, 0.52, 0.54, 0.54 (Case 1) and 0.57, 0.73, 0.93, 0.96, 0.96 (Case 2). Squaring holds to within a constant factor of about 2, which the word "roughly" covers. The intro already says that quadratic convergence is local.
- The comparison table's "Starting-point sensitivity: High / Moderate" is a qualitative judgement and cannot be checked as a number. I did not treat it as a claim.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonsysaa.jl` | 0 | 8.1 | newtonsysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonsysab.jl` | 0 | 7.7 | newtonsysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Evidence key: **[C]** = `review/check.py` (sympy resultant + 50-digit mpmath Newton); **[G]** = `review/grid.py` (numpy) and `review/grid.jl` (Julia backslash, same arithmetic as the scripts); **[S]** = `review/slow.py` and `review/detcurve.py`; **[F]** = committed frames; **[A]** = legacy archive; **[R]** = script source.

| # | Page claim (page's own words) | Verdict | Evidence |
|---|---|---|---|
| 1 | Jacobian J = [[∂f/∂x, ∂f/∂y],[∂g/∂x, ∂g/∂y]], J_ij = ∂F_i/∂x_j | confirmed | standard definition; matches Mathews' definition [A] |
| 2 | Fixed-point iteration X⁽ᵏ⁺¹⁾ = G(X⁽ᵏ⁾) | confirmed | standard; [A] Definition (Fixed Point Iteration) |
| 3 | Row-sum condition \|∂g₁/∂x\|+\|∂g₁/∂y\|<1 and \|∂g₂/∂x\|+\|∂g₂/∂y\|<1 at X*, start sufficiently close ⇒ converges | confirmed | this is ‖DG(X*)‖_∞ < 1. By continuity it holds on a neighbourhood, which gives a local contraction. Same as Mathews' theorem, case (i) [A] |
| 4 | Row-sum condition sufficient, not necessary; spectral radius of DG(X*) < 1 ⇒ local convergence | confirmed | standard (Ostrowski) |
| 5 | Newton linearization F(X+ΔX) ≈ F(X) + J ΔX = 0; J ΔX = −F, X⁽ᵏ⁺¹⁾ = X⁽ᵏ⁾ + ΔX | confirmed | standard; [R] lines 29–30 implement exactly `pts[k] - Jv \ F(pts[k])` |
| 6 | Four steps of one Newton iteration (evaluate F, evaluate J, solve, update) | confirmed | matches Mathews' Steps 1–4 [A] and the script [R] |
| 7 | Quadratic near a non-singular solution; digits roughly double; quadratic rate lost if J singular at the solution | confirmed | standard; ratios e_{k+1}/e_k² settle to constants 0.535 and 0.96 [C] |
| 8 | Same algorithm in any dimension; only the size of the linear system changes | confirmed | standard |
| 9 | Table: fixed point is linear when 0<ρ<1, superlinear when ρ=0, as for Newton written as fixed point (G has zero Jacobian at X*) | confirmed | DG = I − J⁻¹J = 0 at X* for G = X − J⁻¹F; standard |
| 10 | Table: cost per iteration Low (function evals) vs Higher (Jacobian + linear solve) | confirmed | by construction |
| 11 | Animations system f₁ = 1 − 4x + 2x² − 2y³, f₂ = −4 + x⁴ + 4y + 4y⁴ | confirmed | [R] lines 12–13 in both scripts; Mathews Example 2 system, gr_221 / gr_288 [A] |
| 12 | Blue curve is f₁ = 0, red curve is f₂ = 0 | confirmed | [R] `lc=:blue` on Z1, `lc=:red` on Z2; [F] blue minimum at (1, −0.794) = (1, ∛−0.5), red crosses x=0 at y = 0.7245 and −1.2207 |
| 13 | "Their two intersections are the solutions" | confirmed | the resultant in y has degree 12 and gives exactly 2 real solutions: (0.0617701263, 0.7244905153) and (1.5560974843, −0.5756507696) [C]. Both lie inside both plot windows [F] |
| 14 | Each frame adds one Newton step (J at current point, solve, move) | confirmed | [R] frames 0..8 = start + 8 steps; 9 frames per GIF (manifest); [F] path grows by one point per frame |
| 15 | Quadratic convergence is local: the error roughly squares only once the iterate is close | confirmed | see 7; first-step ratios 1.2 and 0.57 differ from the asymptotic constants [C] |
| 16 | 301×301 grid of starts covering each plot window: more than 90% get within 1e-10 of a solution in ≤10 iterations | confirmed | Window 1 (−0.25..2.25 × −1.25..1.50): 91.32%. Window 2 (−0.25..2.75 × −1.50..1.25): 93.21%. numpy and Julia give identical results [G] |
| 17 | Starts near det J = 0 can be thrown far outside the window and need dozens of iterations | confirmed | starts needing >30 iterations: 1133 / 842. Their median distance to the det J = 0 curve is 0.038 / 0.041, against 0.55 / 0.72 for all starts. Their median max excursion is ~1e4 [S] |
| 18 | "over 200 for the slowest start in each window" | confirmed | slowest: 246 its from (−0.1083, −0.6908), window 1; 203 its from (−0.2, −0.675), window 2. Identical in numpy and Julia LU [G]. These starts lie 0.060 and 0.044 from det J = 0, with max \|p\| of 1.9e29 and 9.1e23 [S]. Margin in window 2 is thin (203) but holds in both arithmetics. All 90601 starts converge within 3000 its |
| 19 | Mathews' examples not animated: Ex 1 fixed-point on this system, Ex 3 equivalence check, Ex 4 Newton as fixed point on this system, Exercise 5 3×3 system | confirmed | [A] main module text; Ex 1 form x=(2x²−2y³+1)/4, y=(−x⁴−4y⁴+8y+4)/12 (gr_75) is algebraically equivalent to f₁, f₂ (verified by hand: 4x = 2x²−2y³+1 ⇔ f₁=0; 12y = −x⁴−4y⁴+8y+4 ⇔ f₂=0); Ex 4 uses the same system (gr_288); Ex 5 is 3D with "four solutions" |
| 20 | Case 1 heading: Solution 1, starting at (0.5, 0.8) | confirmed | [R] aa line 19 `p0 = [0.5, 0.8]`; title in frames [F] |
| 21 | Case 1: start "just above the red curve and well above the blue curve at x = 0.5" | confirmed | at x=0.5, upper red branch y=0.7182 (start 0.08 above), blue y=−0.6300 (1.43 below the start) |
| 22 | Case 1: converges rapidly to (0.0618, 0.7245) | confirmed | true (0.06177013, 0.72449052) [C]; script prints 0.06177013, 0.72449052 (run.out) |
| 23 | Case 1: intersection in upper-left portion of the plot | confirmed | [F] |
| 24 | Case 1 distances 0.44 → 0.24 → 0.024 → 3e-4 → 5e-8 → 1e-15 | confirmed | 0.444688, 0.236709, 0.023738, 2.92334e-4, 4.56884e-8, 1.11648e-15 [C] |
| 25 | Case 1: each error roughly the square of the previous one | confirmed | ratios 1.2, 0.42, 0.52, 0.54, 0.54 |
| 26 | Case 1 alt text: converging from (0.5, 0.8) to ≈(0.062, 0.724); blue f₁, red f₂ | confirmed | 0.06177 → 0.062; 0.72449 → 0.724 |
| 27 | Case 1 wiring: link `newtonsysaa.jl`, embed `newtonsysaa.gif` | confirmed | the files exist; the committed GIF is byte-identical to a scratch regeneration of `newtonsysaa.jl` (manifest) |
| 28 | Case 2 heading: Solution 2, starting at (2, −1) | confirmed | [R] ab line 20 `p0 = [2.0, -1.0]` |
| 29 | Case 2: starts in the lower-right region near Solution 2 | confirmed | [F]; initial distance 0.614 |
| 30 | Case 2: converges to (1.5561, −0.5757), the lower-right intersection | confirmed | true (1.55609748, −0.57565077) [C]; matches Mathews' quoted 1.5560974843220556, −0.5756507696188449 (lnk_2 text) [A] |
| 31 | Case 2: blue crosses red close to the red curve's rightmost point (1.5579, −0.6300) | confirmed | rightmost point of x⁴ = 4−4y−4y⁴ is at y = −(1/4)^{1/3} = −0.629961, x = 1.557854 [C]; distance from the solution is 0.054 |
| 32 | Case 2 distances 0.61 → 0.21 → 0.034 → 1.1e-3 → 1.1e-6 → 1.1e-12 | confirmed | 0.614102, 0.214201, 0.0336699, 1.05148e-3, 1.05834e-6, 1.07574e-12 [C] |
| 33 | Case 2: quadratic, each error roughly the square of the previous one | confirmed | ratios 0.57, 0.73, 0.93, 0.96, 0.96 |
| 34 | Case 2 alt text: from (2, −1) to ≈(1.556, −0.576), lower-right intersection | confirmed | |
| 35 | Case 2 wiring: link `newtonsysab.jl`, embed `newtonsysab.gif` | confirmed | byte-identical regeneration (manifest) |
| 36 | "Julia source scripts ... are linked under each case" | confirmed | |
| F1 | Fidelity: system matches Mathews Example 2 | confirmed | gr_221 [A] |
| F2 | Fidelity: two Newton runs (two solutions) as in Mathews Example 2 | confirmed | lnk_3 text has two "find ... the solution near ___" runs [A] |
| F3 | Fidelity: starting points (0.5, 0.8) and (2, −1) match Mathews | could not determine | the starting-point images gr_235 and gr_256 and the graph gr_234 are absent from the archive. No .nb file exists either |

### 3. Implementation checks

### `newtonsysaa.jl`
- **Is the method it claims to be:** yes. Plain (undamped) Newton for systems: `pts[k+1] = pts[k] - Jac \ F` (lines 28–31). There is no line search, damping or safeguard. The Jacobian (lines 15–16) matches sympy's: [[4x−4, −6y²],[4x³, 16y³+4]] [C].
- **Numbers right:** script iterates as shown in frame legends vs 50-digit independent Newton [C]:
  | k | script legend (frames) | independent |
  |---|---|---|
  | 0 | (0.5, 0.8) | (0.5, 0.8) |
  | 1 | (−0.1731, 0.7537) | (−0.1731282051, 0.7537126068) |
  | 2 | (0.0381, 0.7259) | (0.0380715901, 0.7258585778) |
  | 3 | (0.0615, 0.7245) | (0.0614778080, 0.7244935717) |
  | 4–8 | (0.0618, 0.7245) | (0.0617700807…→0.0617701263, 0.7244905153) |
  Final printed value: x = 0.06177013, y = 0.72449052 (run.out). The true root is 0.0617701263386, 0.7244905153472.
- **Reference values:** the script draws no separate reference. The page's quoted root and distances are checked in the ledger (22, 24).
- **Picture:** contours are drawn with Z[y,x] on (xg, yg), the orientation Plots expects. The curves agree with the analytic landmarks (blue minimum (1, −0.794), vertical tangents of blue at x = 1 ± 1/√2, red x-intercepts 0.7245 and −1.2207). The path joins pts[1..frame+1]. The legend label shows x⁽frame⁾ with the right index and value. The title's start point matches p0. No clamping or masking is used, and every iterate lies inside the window (min x = −0.173 > −0.25).

### `newtonsysab.jl`
- **Is the method it claims to be:** yes. The code is identical to aa except for p0 = (2, −1) and the window.
- **Numbers right:**
  | k | script legend (frames) | independent |
  |---|---|---|
  | 0 | (2.0, −1.0) | (2, −1) |
  | 1 | (1.75, −0.6667) | (1.75, −0.6666666667) |
  | 2 | (1.5897, −0.5779) | (1.589691077, −0.5779169826) |
  | 3 | (1.5571, −0.5756) | (1.557144461, −0.5755535968) |
  | 4–8 | (1.5561, −0.5757) | (1.556098541…→1.556097484, −0.5756507046…→−0.5756507696) |
  Printed: 1.55609748, −0.57565077 (run.out). The true root is 1.556097484322, −0.575650769619, and Mathews quotes 1.5560974843220556, −0.5756507696188449.
- **Header comment** "converges to x* ≈ 1.5561, y* ≈ −0.5757": confirmed.
- **Picture:** same checks as aa, all passed. All iterates lie inside the window. The final frame (frame_009) shows the path from (2, −1) through (1.75, −0.667) to the lower-right intersection, labelled x⁽⁸⁾ = (1.5561, −0.5757).

### Reproducibility
Both committed GIFs are byte-identical to fresh scratch regenerations (manifest), so the frames reviewed are the output of the scripts as committed.

