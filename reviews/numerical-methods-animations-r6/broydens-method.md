# Broyden's Method — animation review (round 6)

Page: `pages/numerical-methods/broydens-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings. Every checkable claim on the page, in the script comments and in the frame titles matches independently computed values. The evidence is in parts 2 and 3.

Non-findings, recorded so the owner knows they were looked at:
- Mathews' plot (gr_669) draws f1 = 0 in red and f2 = 0 in blue. The page and script reverse this, and the page's own statement ("blue curve is f1 = 0, red curve is f2 = 0") is correct for the GIFs. Colour choice only.
- Mathews' printed Case A iterates differ from the script's by up to about 6e-13 (P1 x: Mathews 0.0610386164426676, script 0.0610386164432668). The exact-rational Newton step gives 0.061038616443266723…, so the script is the correct one. The difference cannot be seen at any precision the page or GIF shows. Case B iterates agree with Mathews' to about 1e-16.
- Case A ‖F‖ ratios over steps 0→4 are roughly constant (24–43), which looks linear over that stretch. The page says only that the whole sequence, including the two last ratios above 1000, is consistent with superlinear convergence. The error ratios e_{k+1}/e_k do fall to 7.7e-4 and then 7.9e-6, so the claim holds.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `broydenaa.jl` | 0 | 10.2 | broydenaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `broydenbb.jl` | 0 | 12.5 | broydenbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `broydenaa.gif` | 7 | byte-identical | broydenaa |
| `broydenbb.gif` | 8 | byte-identical | broydenbb |

### Page references

- Scripts linked: `broydenaa.jl`, `broydenbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description, Newton | J(X)ΔX = −F(X), X⁺ = X + ΔX; quadratic near a simple root | Standard | confirmed |
| D2 | Description, FD | M_ij ≈ [F_i(X+h e_j) − F_i(X−h e_j)]/(2h); 2n² extra function evaluations | Central difference. 2n vector evaluations = 2n² component evaluations, which matches Mathews gr_72/gr_73 | confirmed |
| D3 | Description | Secant condition B_{k+1}s_k = y_k, with s_k and y_k as defined | Script line 59 update gives B·s = y. `indep.py` asserts B@s ≈ y at every step and passes | confirmed |
| D4 | Description | Rank-1 update B_{k+1} = B_k + (y − B s)sᵀ/(sᵀs), the Frobenius-closest matrix satisfying the secant condition | Broyden's "good" update. The script (line 59) uses exactly this formula | confirmed |
| D5 | Description | O(n²) update, no extra function evaluations beyond F(X^{(k+1)}) | Script evaluates F once per iteration (line 49) | confirmed |
| D6 | Algorithm Step 0 | B₀ = exact J(X⁰), one Newton step to X¹ | Script lines 43–44. Jacobian (lines 20–23) checked against sympy: [[4x−4, −6y²],[4x³, 16y³+4]] | confirmed |
| D7 | Algorithm steps 1–4 | Evaluate F, update B with s_{k−1}, solve B_kΔX = −F, X^{(k+1)} = X^{(k)} + ΔX | Script lines 48–64 do these steps in this order | confirmed |
| D8 | Convergence | Superlinear near a simple root | Error ratios e_{k+1}/e_k (errs.py): A 0.023, 0.030, 0.025, 0.038, 7.7e-4, 7.9e-6; B 0.10, 0.089, 0.027, 0.095, 0.017, 8.3e-4, 1.9e-4, tending to 0 | confirmed |
| I1 | Intro | f1 = 1 − 4x + 2x² − 2y³, f2 = −4 + x⁴ + 4y + 4y⁴ | Script lines 16–17 and contour grids lines 78–79. Mathews gr_213/gr_660 | confirmed |
| I2 | Intro | Blue curve is f1 = 0, red curve is f2 = 0 | Script lines 98–99 (Z1 blue, Z2 red). Frames: blue open curve passes (1, −0.794) = f1 zero; red closed loop = f2 | confirmed |
| I3 | Intro | Exactly two real solutions, near (0.062, 0.724) and (1.556, −0.576) | The resultant in y has degree 12. Real roots: (0.0617701263386074, 0.7244905153472166) and (1.5560974843220530, −0.5756507696188434), refined with mpmath findroot at 40 digits | confirmed |
| I4 | Intro | Both lie inside the plotted window | Window x ∈ (−1.75, 2.25), y ∈ (−1.5, 1.25). Both roots are inside | confirmed |
| I5 | Intro | Each frame adds next iterate, connected by a line | Script lines 100–104. Frames show a steelblue path with the current iterate in red | confirmed |
| I6 | Intro | After the first (Newton) step, iterates are too close to the root to separate at this scale | X¹ error: A 1.06e-3, B 9.8e-3. Scale is about 110 px per unit, so these are about 0.1 px and 1 px. Frames 2+ show the markers overlapping | confirmed |
| I7 | Intro | Right panel plots ‖F(X^{(k)})‖ on a log scale | Script line 108 (yscale=:log10, residuals = norm(F)) | confirmed |
| I8 | Archive note | Example 5 poses this system for Broyden. Its archived copy is missing starting-point, result and graph images | gr_213 (system) is present. gr_214–gr_241 (all other Example 5 images) are missing on disk | confirmed |
| I9 | Archive note | Starting points are those of the standard Broyden runs in Example 8, whose printed iterates these animations reproduce | gr_676/gr_682: P₀ = (0.1, 0.7) and (1.5, −0.5). Printed iterates match the script to ≤ 6e-13 (A) and about 1e-16 (B) | confirmed |
| I10 | Archive note | Examples 1 and 3 are Newton and pseudo-Newton. Example 8 is the improved (Sherman–Morrison) Broyden. Exercises in 3D and 4D | Module text: Ex 1 Newton, Ex 3 Pseudo-Newton, Ex 8 "improved Broyden" after the Sherman–Morrison theorem, Ex 2/4/6/9 are 3D, Ex 7/10 are 4D | confirmed |
| A1 | Case A heading | X⁰ = (0.1, 0.7), root ≈ (0.062, 0.724) | Script line 26. Root (0.06177, 0.72449) | confirmed |
| A2 | Case A | Starting close to the upper intersection | ‖X⁰ − root‖ = 0.045 | confirmed |
| A3 | Case A | Initial Newton step moves iterate by about 0.05 | ‖X¹ − X⁰‖ = 0.0464 | confirmed |
| A4 | Case A | ‖F‖ from 2.5e-1 to 7.8e-3 | 2.484e-1 → 7.762e-3 (script and indep.py agree) | confirmed |
| A5 | Case A | Rank-1 updates, no new derivative evaluations | Jac called once (line 43) | confirmed |
| A6 | Case A | ‖F‖ down to about 1e-15 (machine precision) at X⁶ | Script 1.355e-15 (numpy evaluation 1.99e-15, exact evaluation of the float iterate 1.65e-15). Error to the true root 1.85e-16, which is at ulp level | confirmed |
| A7 | Case A | X⁰→X⁴: shrinks by between 24 and 43 times per step | Ratios 32.01, 24.55, 42.25, 25.67 | confirmed |
| A8 | Case A | Each of last two steps by more than 1000 times | 1304, 1.65e5 | confirmed |
| A9 | Case A link/embed | broydenaa.jl / broydenaa.gif are Case A | Script x0 = (0.1, 0.7). GIF frame 1 title X_0 = (0.1000, 0.7000) | confirmed |
| A10 | Case A alt | Iterates close on (0.062, 0.724), only the first step visible, ‖F‖ falls from 2.5e-1 to about 1e-15 in six steps | 7 frames (X⁰–X⁶). Last frame title "≈ 1e-15 (machine precision)" | confirmed |
| B1 | Case B heading | X⁰ = (1.5, −0.5), root ≈ (1.556, −0.576) | Script line 26. Root (1.55610, −0.57565) | confirmed |
| B2 | Case B | Starting close to the lower-right intersection, converges to it | ‖X⁰ − root‖ = 0.094. X⁷ error 6.3e-15 | confirmed |
| B3 | Case B | ‖F‖ falls at every step | 7.32e-1, 1.05e-1, 1.11e-2, 5.23e-5, 1.06e-5, 1.92e-7, 1.60e-10, 2.96e-14, which is strictly decreasing | confirmed |
| B4 | Case B | From 7.3e-1 at X⁰ to 3.0e-14 at X⁷ | 7.315e-1. 2.956e-14 (script), 2.96e-14 (indep.py). Mathews' printed F(P₇) has norm 2.955e-14 | confirmed |
| B5 | Case B | Only about 5 from X³ to X⁴ | 4.95 | confirmed |
| B6 | Case B | More than 1000 times in each of the last two steps | 1198, 5424 | confirmed |
| B7 | Case B | Starting-point dependent: a different initial guess finds a different root | A → upper root, B → lower-right root | confirmed |
| B8 | Case B link/embed | broydenbb.jl / broydenbb.gif are Case B | Script x0 = (1.5, −0.5). GIF frame 1 title X_0 = (1.5000, −0.5000) | confirmed |
| B9 | Case B alt | Only the first step large enough to see, ‖F‖ falls at every step from 7.3e-1 to 3.0e-14 in seven steps | Step sizes 0.104, then 0.0107 (about 1 px) and smaller. 8 frames. Last title "‖F(X_7)‖ = 2.96e-14" | confirmed |
| S1 | Script comments | Header: system, starting point from Mathews' Example 8, upper / lower-right solution | As above | confirmed |
| S2 | Frame titles | Plot titles "solution near (0.062, 0.724)" / "(1.556, −0.576)". Left title X_k at 4 decimals. Right title ‖F(X_k)‖ | All frame titles match the instrumented printout, e.g. B X_4 = (1.5561, −0.5757), ‖F(X_4)‖ = 1.06e-05 | confirmed |
| W1 | Wiring | Page linked from section index | `pages/numerical-methods/index.qmd` line 27 | confirmed |

### 3. Implementation checks

Both scripts are identical apart from the starting point, title and output filename (checked with `diff`). Scratch copies are byte-identical to the repo scripts, and the regenerated GIFs are byte-identical to the committed GIFs (checked with `cmp`).

### `broydenaa.jl`
- **Method:** Broyden's "good" method (Broyden 1965 rank-1 update of B, solving B ΔX = −F with `\` each step). B₀ is the exact Jacobian. This is the standard (not Sherman–Morrison inverse-update) variant, and it is the variant the page's Algorithm section describes. Stopping rule: ‖F‖ < 1e-12, or ‖s‖² < 1e-20, or 10 Broyden steps.
- **Numbers.** Script (`inst_aa.jl`) compared with independent numpy (`indep.py`):

| k | script X | independent X | script ‖F‖ | indep ‖F‖ |
|---|---|---|---|---|
| 0 | (0.1, 0.7) | same | 2.484276e-1 | 2.484276e-1 |
| 1 | (0.0610386164432668, 0.7252588370082448) | (…432667, …082449) | 7.761601e-3 | 7.761601e-3 |
| 2 | (0.0617791598344261, 0.7244597836716361) | (…344261, …716360) | 3.162050e-4 | 3.162050e-4 |
| 3 | (0.0617705890624876, 0.7244911570414898) | same | 7.483279e-6 | 7.483279e-6 |
| 4 | (0.0617701091942884, 0.7244904901876605) | (…, …876607) | 2.915405e-7 | 2.915405e-7 |
| 5 | (0.0617701263254559, 0.7244905153279270) | (…, …279271) | 2.235353e-10 | 2.235340e-10 |
| 6 | (0.0617701263386075, 0.7244905153472168) | same | 1.355e-15 | 1.99e-15 (rounding of evaluation) |

  The exact-rational Newton step from (1/10, 7/10) gives X¹ = (0.061038616443266723, 0.72525883700824483), which agrees with the script.
- **Reference values:** The page and title give the root as (0.062, 0.724). The 40-digit root is (0.061770126338607374, 0.724490515347216620). There are exactly 2 real solutions (resultant of degree 12 in y; nroots plus back-substitution).
- **Picture:** The contour grids are oriented correctly (rows = y). Blue is f1 and red is f2, confirmed geometrically. The iterate path is built from `iterates[1:frame+1]` and the right panel from `residuals[1:frame+1]`. The axis ylims (1e-16, 1e1) contain every residual. No clamping or masking. 7 frames = X⁰…X⁶. Frames 1, 2 and 7 viewed in full and all frames on the contact sheet: titles match the computed values.

### `broydenbb.jl`
- **Method:** Same as above.
- **Numbers.** Script compared with independent:

| k | script X | independent X | script ‖F‖ | indep ‖F‖ |
|---|---|---|---|---|
| 0 | (1.5, −0.5) | same | 7.315437e-1 | 7.315437e-1 |
| 1 | (1.5631443298969072, −0.5824742268041238) | same | 1.050659e-1 | 1.050659e-1 |
| 2 | (1.5553520368634492, −0.5751881059424518) | (…, …424517) | 1.109040e-2 | 1.109040e-2 |
| 3 | (1.5560954228565456, −0.5756271271156214) | same | 5.231154e-5 | 5.231154e-5 |
| 4 | (1.5560969549092851, −0.5756529705862952) | same | 1.056153e-5 | 1.056153e-5 |
| 5 | (1.5560974941407613, −0.5756507313269783) | same | 1.921160e-7 | 1.921160e-7 |
| 6 | (1.5560974843138242, −0.5756507696504695) | same | 1.603242e-10 | 1.603241e-10 |
| 7 | (1.5560974843220545, −0.5756507696188373) | same | 2.955723e-14 | 2.964774e-14 |

  The exact-rational Newton step from (3/2, −1/2) gives X¹ = (1.5631443298969072165, −0.58247422680412371134), which agrees. Mathews' printed P₁…P₇ (gr_682) agree to the last printed digit.
- **Reference values:** Root (1.5560974843220530275, −0.57565076961884344627) at 40 digits, consistent with the page's (1.556, −0.576).
- **Picture:** Same construction as Case A. 8 frames = X⁰…X⁷. The final residual 2.96e-14 is above the 1e-14 "machine precision" threshold, so the title prints the value, which matches the page's 3.0e-14. Frames 8 and the contact sheet viewed: X⁰ marker at (1.5, −0.5), the path reaches the lower-right intersection, and all titles match the computed values.

### Commands run
- `julia review/inst_aa.jl`, `julia review/inst_bb.jl` (scripts truncated before plotting, with printing added).
- `/usr/bin/python3 review/indep.py` (sympy Jacobian, resultant root count, mpmath root refinement, independent Broyden with a secant-condition assertion).
- `/usr/bin/python3 review/errs.py` (errors against the 40-digit roots, error ratios).
- sympy exact-rational Newton step from both starting points.
- `cmp` of committed vs regenerated GIFs (identical) and `diff` of scripts (identical).

