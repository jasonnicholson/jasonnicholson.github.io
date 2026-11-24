# Aitken's Method & Steffensen's Acceleration — animation review (round 9)

Page: `pages/numerical-methods/aitken-method-and-steffensen-acceleration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.

I found no errors, no misleading statements and no minor issues. Every numerical claim on the page agrees with an independent computation at its stated precision. The wiring, the parameters, the legends and the stop reasons all match the frames. The page discloses its departures from the archive and gives reasons for them.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `aitkenab.jl` | 0 | 22.0 | aitkenab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkencd.jl` | 0 | 17.1 | aitkencd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkenef.jl` | 0 | 20.5 | aitkenef.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `aitkenab.gif` | 23 | byte-identical | aitkenab |
| `aitkencd.gif` | 23 | byte-identical | aitkencd |
| `aitkenef.gif` | 23 | byte-identical | aitkenef |

### Page references

- Scripts linked: `aitkenab.jl`, `aitkencd.jl`, `aitkenef.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | l.14-18 | At a root of multiplicity m, Newton's error ratio tends to (m-1)/m | Standard result. Measured Newton ratios in all three cases → 0.500 (e.g. C1 3.115e-7/6.230e-7 = 0.500, C2 4.727e-8/9.454e-8 = 0.500) | confirmed |
| D2 | l.20 | ~50 iterations from error 1 to 1e-16; 2^-53 ≈ 1.1e-16 | 2^-53 = 1.11e-16 (53 halvings) | confirmed |
| D3 | l.20 | Expanded polynomials of Cases 1 and 3: f is exactly 0 after 28 and 25 Newton steps, at errors 1.5e-9 and 2.6e-10 | `newton_long.jl`: C1 f==0 after 28 steps, err 1.521e-9; C3 after 25 steps, err 2.554e-10 | confirmed |
| D4 | l.24-28 | Aitken formula x̂_k = x_k − (Δx_k)²/Δ²x_k, Δ²x_k = x_{k+2} − 2x_{k+1} + x_k | Algebra checked | confirmed |
| D5 | l.30-42 | Aitken theorem (|A|<1, x_k≠p ⇒ (x̂_k−p)/(x_k−p) → 0) | Matches Mathews' theorem. (x̂−p)/e_k = 1 − (r−1)²/(r r' − 2r + 1) → 0 as r, r' → A, for \|A\|<1 | confirmed |
| D6 | l.46-50 | Steffensen = two Newton steps q1, q2, then p1 = p0 − (q1−p0)²/(q2−2q1+p0), repeat | Matches the archive text ("two steps of Newton's method ... then Aitken's process ... set p0 = ..."). Code lines 42-48 (ab) and 46-60 (cd, ef) are identical apart from the guards | confirmed |
| D7 | l.46, 52, 60 | Superlinear / roughly quadratic convergence at a double root | mpmath sequences: C2 3.8e-2 → 3.08e-4 → 1.68e-8 → 4.97e-17 → 4.4e-34; e_{k+1}/e_k² ≈ 0.21, 0.18, 0.18. C3 2.76e-8 → 4.4e-16 → 1.1e-31 | confirmed |
| D8 | l.52, 60 | Each outer iteration consumes two Newton steps | Code computes q1 and q2 per outer step | confirmed |
| D9 | l.58-59 | Table: Newton is quadratic at simple roots and linear with ratio 1/2 at double roots | As D1 | confirmed |
| A1 | l.64 | Two panels: the top shows Newton tangent steps (one per frame, x_k in legend) and Steffensen iterates on the x-axis; the bottom shows log10\|x_k−p\| for both | Frames: legend reads "Newton x_k = ...", red diamonds lie on y=0, bottom panel shows both curves; frames 0..22 add one Newton step each | confirmed |
| A2 | l.64 | Tangent steps are shorter than one pixel after the first 8, 5 and 4 steps in Cases 1, 2, 3 | Plot area measured as 599×342 px (ab, ef) and 596×342 px (cd). Horizontal step lengths: C1 step 8 1.05 px, step 9 0.53 px; C2 step 5 1.34 px, step 6 0.66 px; C3 step 4 1.83 px, step 5 0.90 px. Vertical segments are shorter still | confirmed |
| A3 | l.66, 75, 83, 91 | Each case links its Julia source | Links point at aitkenab/cd/ef.jl. Each GIF is produced by its own script (manifest) | confirmed |
| A4 | l.68 | Cases 1-3 use the functions of Mathews Examples 2, 4 and 6, with his starting values for Cases 2 and 3; Example 2's stated p0 = 1 is the root, where f'(1)=0 | Archive images: gr_58-60 "p = 1, f = x³−3x+2, p0 = 1"; gr_138-140 "p = √2, f = sin(x²−2)(x²−2), p0 = 1"; gr_218-219 "f = x⁶−7x⁴+15x²−9, p0 = 1.5". f'(1) = 0 | confirmed |
| A5 | l.69 | Examples 1, 3 and 5 (Aitken applied to the Newton sequence) are not animated | Archive lnk_2, lnk_4 and lnk_6 are those examples. The omission is disclosed | confirmed (disclosed, so not a fidelity finding) |
| C1a | l.71 | Case 1: f = x³−3x+2, double root p=1, x0 = 2.0 | aitkenab.jl l.13, 16, 17; (x−1)²(x+2) expands to x³−3x+2 | confirmed |
| C1b | l.73 | Newton converges linearly; ratio 1/2 | Errors halve each step (instrumented run) | confirmed |
| C1c | l.73 | Steffensen errors 1, 5.7e-2, 2.8e-4, 6.6e-9 after 3 steps | Script: 1, 5.747e-2, 2.805e-4, 6.556e-9. mpmath: 1, 5.75e-2, 2.80e-4, 6.56e-9 | confirmed |
| C1d | l.73 | Newton at 3.1e-7 after 22 steps | Script N_22 err 3.115e-7 | confirmed |
| C1e | l.73 | At S_3 the expanded polynomial rounds to exactly 0, the Δ² denominator is 0, and the animation stops | Script f(S_3) = 0.0, n_done = 3, stop reason "Δ² denominator = 0". The frame legend from frame 4 on reads "Steffensen (3 steps; stopped: Δ² denominator = 0)" | confirmed |
| C1f | l.73 | The factored form (x−1)²(x+2) takes a fourth step to the root | Julia: S_4 = 0.99999999999999967 (err 3.3e-16) with the expanded f'; S_4 = 1.0 exactly with the factored f' | confirmed |
| C1g | l.77 alt | Steffensen stops after 3 steps at error 6.6e-9 | As C1c and C1e | confirmed |
| C2a | l.79 | Case 2: f = (x²−2)sin(x²−2), double root √2, x0 = 1.0 | aitkencd.jl l.13-17. Near √2, f ≈ (x²−2)², so the root is double. f' was checked by hand | confirmed |
| C2b | l.81 | Steffensen error 6.7e-16 after 4 steps (8 Newton steps); three ulp | Script S_4 = 1.4142135623730945, \|S_4 − fl(√2)\| = 6.661e-16 = 3.0 ulp (ulp = 2.22e-16) | confirmed |
| C2c | l.81 | Newton is at 4.7e-8 after 22 steps | Script N_22 err 4.727e-8 | confirmed |
| C2d | l.81 | Measured from the exact √2, the final error is 5.7e-16 | mpmath \|S_4 − √2\| = 5.695e-16 | confirmed |
| C2e | l.81 | Stops at S_4 because \|f'(S_4)\| < 1e-14 | f'(S_4) = −8.79e-15. Script stop reason "\|f'(S_4)\| < 1e-14"; the legend shows it from frame 5 | confirmed |
| C2f | l.85 alt | Error 6.7e-16 from the double-precision √2 (5.7e-16 from the exact value) after 4 steps | As C2b and C2d; bottom-panel point at log10 = −15.18 | confirmed |
| C3a | l.87, 89 | Case 3: f = x⁶−7x⁴+15x²−9 = (x²−1)(x²−3)², double root √3 ≈ 1.732, x0 = 1.5 | Expansion checked by hand; f' = 6x⁵−28x³+30x; aitkenef.jl l.14-18 | confirmed |
| C3b | l.89 | Tangent steps are shorter than a pixel after the first four | As A2 (step 5 = 0.90 px) | confirmed |
| C3c | l.89 | Steffensen error 2.8e-8 in 3 steps, then stalls | Script S_3 err 2.759e-8; mpmath 2.76e-8 | confirmed |
| C3d | l.89 | Polynomial values near the root are of order 1e-14, comparable to the rounding error | f(S_3) = 2.13e-14, f(S_4) = 7.8e-14; largest term 7x⁴ ≈ 63, and 63·eps ≈ 1.4e-14 | confirmed |
| C3e | l.89 | Steps 4-6 errors 5.4e-8, 2.1e-8, 1.5e-8 | Script 5.442e-8, 2.148e-8, 1.458e-8 | confirmed |
| C3f | l.89 | Plain Newton is at 2.4e-8 after 22 steps | Script N_22 err 2.402e-8 | confirmed |
| C3g | l.89 | In exact arithmetic, step 4 would reach 4.4e-16 | mpmath (80 digits) Steffensen from x0 = 1.5: S_4 err 4.40e-16 | confirmed |
| C3h | l.93 alt | Levels off at a few times 1e-8 after 3 steps | As C3c and C3e. Frame 23 bottom panel lies between −7.3 and −7.9 | confirmed |
| W1 | l.77/85/93 | Embeds are aitkenab/cd/ef.gif under the matching headings | Frame titles "f(x) = x³−3x+2 (p = 1)", "(x²−2)sin(x²−2) (p = √2)" and "x⁶−7x⁴+15x²−9 (p = √3)" match the headings | confirmed |

Note (not a finding): the bottom panel plots Steffensen's outer iteration index and Newton's step index on the same "Iteration k" axis, although one Steffensen step costs two Newton steps. The page says this (l.52, l.60, "4 steps (8 Newton steps)" in Case 2), and the conclusion holds at equal cost (for example, C1 Newton after 6 steps is at 2.0e-2, while Steffensen after 3 steps is at 6.6e-9).

### 3. Implementation checks

### aitkenab.jl (Case 1)
- **Method:** Newton x − f/f'; Steffensen as Mathews defines it, which is Aitken Δ² applied to two Newton steps and restarted from the accelerated value (the Steffensen fixed-point scheme on g(x) = x − f/f'). This is the variant the page describes.
- **Numbers:** Script Steffensen 2, 0.94252873563218365, 0.99971951186750685, 0.99999999344396751. mpmath errors 1, 5.75e-2, 2.80e-4, 6.56e-9 against script errors 1, 5.747e-2, 2.805e-4, 6.556e-9. Newton N_1 = 1.5555… = 2 − 4/9 (exact); the ratio tends to 0.5 and N_22 err = 3.115e-7.
- **Reference:** root = 1.0 is exact.
- **Picture:** The tangent path runs from (x_i, 0) up to (x_i, f(x_i)) and on to (x_{i+1}, 0), which is correct. The legend reports x_frame with the right index. Steffensen diamonds are shown for S_0..S_nS, and the S label shows S_nS. The bottom panel's clamp at 1e-16 is never active (minimum error 6.6e-9). Axis limits contain every feature discussed.

### aitkencd.jl (Case 2)
- **Method:** As above, with |f'| < 1e-14 guards on S_i and q1. In the 22 Newton steps the Newton guard never fires (N_22 = 1.414213515100939, a valid iterate).
- **Numbers:** Script S errors 4.142e-1, 3.802e-2, 3.077e-4, 1.677e-8, 6.661e-16. mpmath errors 0.414, 0.0380, 3.08e-4, 1.68e-8, 4.97e-17; the float run is floored at a few ulp, as the page explains. Newton N_22 err 4.727e-8.
- **Reference:** root = sqrt(2.0), the correctly rounded √2. The page separately states the error against the exact √2 (C2d, verified).
- **Picture:** Legend stop reason "|f'(S_4)| < 1e-14" is correct. The S_4 label sits below the axis. The bottom-panel minimum is −15.18, above the −17 limit and not clamped.

### aitkenef.jl (Case 3)
- **Method:** As for Case 2. No guard fires (n_done = 6, stop_reason empty), as the header comment says.
- **Numbers:** Script S errors 2.321e-1, 1.942e-2, 2.186e-4, 2.759e-8, 5.442e-8, 2.148e-8, 1.458e-8. mpmath errors 0.232, 0.0194, 2.19e-4, 2.76e-8, 4.4e-16. The two agree until rounding at f ≈ 1e-14 takes over. Newton N_22 err 2.402e-8; the Newton stall occurs at step 25, beyond the 22 plotted.
- **Reference:** root = sqrt(3.0).
- **Picture:** Legend reads "Steffensen (6 steps)" with no stop reason, which is correct. The S_6 label overlaps the curve slightly but stays readable. The plateau after step 3 is visible in the bottom panel.

### Legacy fidelity
The functions and starting values agree with Mathews Examples 4 and 6. Example 2's stated p0 = 1 is the root itself; the page changes it to x0 = 2 and gives the reason. Examples 1, 3 and 5 are omitted with disclosure. I could not compare against Mathews' computed tables or graphs because those images are absent from the archive.

