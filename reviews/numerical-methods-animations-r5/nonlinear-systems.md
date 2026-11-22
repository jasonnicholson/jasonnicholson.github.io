# Nonlinear Systems — animation review (round 5)

Page: `pages/numerical-methods/nonlinear-systems/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Page match, Minor — "Linear (when it converges)" for fixed-point iteration

- **Location:** `index.qmd` line 63, Comparison table: `| Convergence rate | Linear (when it converges) | Quadratic |`.
- **What is there:** Fixed-point iteration for systems is stated to converge linearly whenever it converges.
- **What is true:** Fixed-point iteration converges at least linearly (rate = spectral radius of the Jacobian of **G** at **X***); when that Jacobian vanishes at **X*** it converges superlinearly. The page itself (line 80) cites Mathews' Example 4, "Newton's method on this system written as a fixed-point iteration", whose G(X) = X − J⁻¹F(X) has zero Jacobian at the root and converges quadratically. So the table cell is contradicted by an example the page names.
- **How I know:** standard fixed-point theory (G'(X*) = I − J⁻¹J = 0 for the Newton map at a nonsingular root); the Case 1/Case 2 Newton sequences computed below (which are exactly that fixed-point map iterated) shrink the error quadratically: 0.44 → 0.24 → 0.024 → 2.9e-4 → 4.6e-8 → 1.1e-15.
- **Suggested correction:** "Linear in general (rate ≈ spectral radius of the Jacobian of **G** at **X***); faster only if that Jacobian vanishes, as for Newton's method written as a fixed-point iteration".

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonsysaa.jl` | 0 | 7.4 | newtonsysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

Evidence keys: **[IND]** = `indep.py` (sympy resultant + 50-digit mpmath Newton); **[INST]** = instrumented scratch copies `inst_aa.jl`/`inst_ab.jl` (script's own Float64 code); **[GRID]** = `grid.py` (numpy) and `gridjl.jl` (Julia, script's own `\`), identical results; **[SLOW]** = `slow.py` + `detdist.py`; **[FR]** = committed frames; **[ARC]** = legacy archive.

### Description (method statements)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | Solutions are the points of intersection of the curves f=0, g=0 | Confirmed | definition |
| D2 | J = [[∂f/∂x, ∂f/∂y],[∂g/∂x, ∂g/∂y]]; J_ij = ∂F_i/∂x_j | Confirmed | standard; matches script layout (rows = functions) |
| D3 | Fixed-point: rewrite as X = G(X), iterate X^(k+1) = G(X^(k)) | Confirmed | standard; matches [ARC] Example 1 form x=(2x²−2y³+1)/4, y=(−x⁴−4y⁴+8y+4)/12 |
| D4 | Converges from starts sufficiently close to X* if row-sum condition holds at X* | Confirmed | row-sum <1 ⇒ ‖G'(X*)‖∞ <1 ⇒ local contraction (continuity of G'); same as Mathews' theorem [ARC] |
| D5 | Row-sum condition sufficient, not necessary; spectral radius <1 suffices locally | Confirmed | Ostrowski's theorem |
| D6 | Newton linearization F(X+ΔX) ≈ F(X) + J ΔX = 0; J ΔX = −F, X⁺ = X + ΔX | Confirmed | standard; scripts line 30/31 `pts[k] - Jv \ F(pts[k])` is the same update |
| D7 | Four steps: evaluate F, evaluate J, solve, update | Confirmed | matches Mathews Steps 1–4 [ARC]; matches script |
| D8 | Quadratic near a non-singular solution; digits roughly double | Confirmed | [IND] error sequences below |
| D9 | Quadratic rate lost if J singular at the solution | Confirmed (standard result, generic case) | — |
| D10 | Same algorithm in any dimension, only linear-system size changes | Confirmed | standard; Mathews' NewtonSystem subroutine (gr_220) is dimension-free |
| D11 | Table: FPI rate "Linear (when it converges)" | **Wrong (Minor, F1)** | see F1 |
| D12 | Table: Newton rate "Quadratic" | Confirmed (locally, nonsingular root) | [IND] |
| D13 | Table: cost low vs higher (Jacobian + linear solve) | Confirmed | — |
| D14 | Table: FPI guarantee = row-sum sufficient; Newton requires good start | Confirmed | D4/D5; [GRID] shows bad starts |
| D15 | Table: starting-point sensitivity High vs Moderate | Could not determine | qualitative opinion, not checkable |

### Animations section

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | System f1 = 1 − 4x + 2x² − 2y³, f2 = −4 + x⁴ + 4y + 4y⁴ | Confirmed | scripts lines 12–13 (aa), 13–14 (ab); identical to Mathews Example 2 (gr_221) [ARC] |
| A2 | Each animation shows the Newton iteration path in the xy-plane | Confirmed | [FR], code lines 62–68 |
| A3 | Blue curve is f1=0, red curve is f2=0 | Confirmed | `contour!(…Z1…lc=:blue)`, `Z2…lc=:red`; legend in [FR] |
| A4 | "Their two intersections are the solutions" (exactly two) | Confirmed | [IND]/`grid.py`: resultant in y has degree 12 with exactly 2 real roots; real solutions (1.556097484322053, −0.5756507696188434), (0.06177012633860738, 0.7244905153472166). Mathews also states 12 roots, some complex [ARC] |
| A5 | Each frame adds one Newton step (J at current point, solve, move) | Confirmed | 9 frames = start + 8 steps (`n_iters = 8`); path built from `pts[1:frame+1]` |
| A6 | Quadratic convergence is local | Confirmed | [GRID]/[SLOW] |
| A7 | 301×301 grid covering each window: >90% within 1e−10 of a solution in ≤10 iterations | Confirmed | [GRID]: window 1 (x∈[−0.25,2.25], y∈[−1.25,1.5]) 91.32%; window 2 (x∈[−0.25,2.75], y∈[−1.5,1.25]) 93.21%; numpy and Julia agree exactly |
| A8 | Starts near the det J = 0 curve can be thrown far outside the window and need dozens of iterations | Confirmed | [SLOW]: starts needing >50 iterations (394 / 280 of them) lie at median distance 0.029 / 0.038 from the det J=0 curve vs 0.55 / 0.72 for all starts; each such orbit reaches radius ≥ 3.9e4 / 5.0e4 (median 1.6e7 / 5.8e7) |
| A9 | Over 200 iterations for the slowest start in each window | Confirmed | [GRID]: max 246 (start (−0.1083, −0.6908)) and 203 (start (−0.2, −0.675)); no start fails within 5000 |
| A10 | Not-animated Mathews items: Example 1 FPI on same system, Example 3 equivalence, Example 4 Newton as FPI, Exercise 5 3×3 Newton | Confirmed | [ARC] NewtonSystemMod.html text and lnk_2/4/5/6, formula images gr_216, 274/275, 288, 357–360 |
| C1.1 | Case 1 start (0.5, 0.8) | Confirmed | `newtonsysaa.jl` line 19; GIF title |
| C1.2 | Start "just above the red curve" at x=0.5 | Confirmed | red curve upper branch at x=0.5: y=0.71825 (start 0.08 above) |
| C1.3 | Start "well above the blue curve" at x=0.5 | Confirmed | blue curve (single-valued in x) at x=0.5: y=−0.62996 |
| C1.4 | Converges rapidly to Solution 1 ≈ (0.0618, 0.7245) | Confirmed | true (0.0617701263, 0.7244905153) |
| C1.5 | Upper-left intersection of the plot | Confirmed | [FR] |
| C1.6 | Distances 0.44 → 0.24 → 0.024 → 3e−4 → 5e−8 → 1e−15 | Confirmed | [IND] 0.4447, 0.2367, 0.02374, 2.923e−4, 4.569e−8, 1.116e−15; [INST] identical through step 4, step 5 = 1.096e−15 |
| C1.7 | Each error roughly the square of the previous (quadratic) | Confirmed | e_{k+1}/e_k² = 1.20, 0.42, 0.52, 0.53, 0.53 (constant ratio) |
| C1.8 | Alt text: Solution 1 ≈ (0.062, 0.724) | Confirmed | 0.06177 → 0.062, 0.72449 → 0.724 |
| C2.1 | Case 2 start (2, −1) | Confirmed | `newtonsysab.jl` line 20; GIF title |
| C2.2 | Starts in the lower-right region near Solution 2 | Confirmed | [FR]; distance 0.614 |
| C2.3 | Converges to ≈ (1.5561, −0.5757), lower-right intersection | Confirmed | true (1.5560974843, −0.5756507696); Mathews quotes (1.5560974843220556, −0.5756507696188449) [ARC] |
| C2.4 | Crossing near the red curve's rightmost point (1.5579, −0.6300) | Confirmed | rightmost point from d/dy(4−4y−4y⁴)=0: y=−(1/4)^{1/3}=−0.62996, x=1.55785; 0.054 from the solution |
| C2.5 | Distances 0.61 → 0.21 → 0.034 → 1.1e−3 → 1.1e−6 → 1.1e−12 | Confirmed | [IND] 0.6141, 0.2142, 0.03367, 1.051e−3, 1.058e−6, 1.076e−12; [INST] identical |
| C2.6 | Quadratic: each error roughly square of previous | Confirmed | ratios 0.57, 0.73, 0.93, 0.96, 0.96 |
| C2.7 | Alt text: Solution 2 ≈ (1.556, −0.576) | Confirmed | — |
| W1 | Case 1 link/embed → `newtonsysaa.jl` / `newtonsysaa.gif`, which start at (0.5, 0.8) | Confirmed | index.qmd lines 86/88; manifest: committed GIF byte-identical to regenerated |
| W2 | Case 2 link/embed → `newtonsysab.jl` / `newtonsysab.gif`, which start at (2, −1) | Confirmed | lines 94/96; byte-identical |
| W3 | Julia sources linked under each case | Confirmed | — |
| H1 | Script header (ab line 5): converges to x* ≈ 1.5561, y* ≈ −0.5757 | Confirmed | [IND] |

### Fidelity to Mathews

- System, the two-solution picture, and the list of non-animated examples match the archive. Mathews' Example 2 does Newton "near" two points (one per solution); the page animates one case per solution. Mathews' actual starting points are in missing images: **could not determine** whether (0.5, 0.8) and (2, −1) are his. No fidelity finding.

---

### 3. Implementation checks

Both scripts are the same code with different `p0`, window and title.

### `newtonsysaa.jl`

1. **Is the method claimed:** Pure Newton–Raphson for systems, no damping or safeguards: `pts[k+1] = pts[k] - Jac(...) \ F(pts[k])` (lines 28–31). Jacobian (lines 15–16) `[4x−4, −6y²; 4x³, 4+16y³]` equals the sympy Jacobian of (f1, f2) (`indep.py` output `Matrix([[4*x - 4, -6*y**2], [4*x**3, 16*y**3 + 4]])`).
2. **Numbers right:** script iterates (Float64, `inst_aa.jl`) vs independent 50-digit mpmath Newton (`indep.py`):

   | k | script (x, y) | independent (x, y) |
   |---|---|---|
   | 0 | (0.5, 0.8) | (0.5, 0.8) |
   | 1 | (−0.173128205128, 0.753712606838) | (−0.1731282051, 0.7537126068) |
   | 2 | (0.038071590057, 0.725858577763) | (0.03807159006, 0.7258585778) |
   | 3 | (0.061477808008, 0.724493571739) | (0.06147780801, 0.7244935717) |
   | 4 | (0.061770080651, 0.724490515556) | (0.06177008065, 0.7244905156) |
   | 5–8 | (0.0617701263386, 0.7244905153472) | (0.06177012634, 0.7244905153) |

   Residual ‖F‖ at step 6–8 = 0.0. Printed "Solution 1: x = 0.06177013, y = 0.72449052" correct.
3. **Reference values:** no exact reference drawn; the limit is the iterate itself. Independently confirmed as a true root via the resultant (A4).
4. **Picture:** [FR] frames 1, 2, 5, 9 inspected (contact sheet + frame_002). Path segments connect `pts[1..frame+1]`; green diamond at x⁽⁰⁾; red dot and legend label `x⁽k⁾ = (round4)` match the table above in every frame (e.g. frame 2: "(−0.1731, 0.7537)", frame 9: "(0.0618, 0.7245)"). Contours at level 0 from a 400×400 grid; both intersections visible; first iterate x=−0.1731 inside xlims (−0.25). No clamping or masking. 9 frames.

### `newtonsysab.jl`

1. **Method:** identical code to aa (lines 13–32); pure Newton.
2. **Numbers right:**

   | k | script (x, y) | independent (x, y) |
   |---|---|---|
   | 0 | (2.0, −1.0) | (2.0, −1.0) |
   | 1 | (1.75, −0.666666666667) | (1.75, −0.6666666667) |
   | 2 | (1.589691077157, −0.577916982642) | (1.589691077, −0.5779169826) |
   | 3 | (1.557144460948, −0.575553596832) | (1.557144461, −0.5755535968) |
   | 4 | (1.556098540666, −0.575650704608) | (1.556098541, −0.5756507046) |
   | 5 | (1.556097484323, −0.575650769619) | (1.556097484, −0.5756507696) |
   | 6–8 | (1.556097484322053, −0.5756507696188434) | (1.556097484, −0.5756507696) |

   ‖F‖ at step 8 = 5.3e−16. Step 1 by hand: F(2,−1) = (3, 12)ᵀ, J = [4 −6; 32 −12], det 144, J⁻¹F = (0.25, −1/3), so X¹ = (1.75, −2/3) exactly.
3. **Reference values:** none drawn; limit confirmed as a true root (A4) and agrees with Mathews' quoted value to ~2e−15.
4. **Picture:** frames 1, 2, 3, 9 inspected. Labels match iterates (frame 2 "(1.75, −0.6667)", frame 3 "(1.5897, −0.5779)", frame 9 "(1.5561, −0.5757)"). All iterates inside the window; legend box covers only the blue curve's upper-right tail, no feature the page discusses. 9 frames.

### Regeneration

Per manifest, both scratch regenerations are byte-identical to the committed GIFs, so the frames reflect the current scripts.

