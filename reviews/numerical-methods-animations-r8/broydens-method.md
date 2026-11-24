# Broyden's Method — animation review (round 8)

Page: `pages/numerical-methods/broydens-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No Error, Misleading or Minor findings.

Everything checkable on the page and in the scripts agreed with my independent computation, with the archive's printed iterates, and with the frames. The ledger below lists what I checked.

Two observations that do not count as findings:
- Case B: "This case illustrates that the method is starting-point dependent: a different initial guess finds a different root." This is true: the two runs converge to different roots. Both starts are close to their own root (0.046 and 0.10 away), though, so the case shows "converges to the nearby root" rather than sensitivity to the starting point. That is a matter of teaching emphasis, not a false statement.
- In the archive graph (gr_669), f1 is red and f2 is blue. The page swaps the colours. It states its own colours correctly, so this is cosmetic.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `broydenaa.jl` | 0 | 11.0 | broydenaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `broydenbb.jl` | 0 | 10.9 | broydenbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (page's own words) | Evidence | Verdict |
|---|---|---|---|
| 1 | System f1 = 1 - 4x + 2x^2 - 2y^3, f2 = -4 + x^4 + 4y + 4y^4 | Script L16-17 and contour arrays L78-79 match. Archive gr_213 = gr_660 (same md5) shows the same system | confirmed |
| 2 | "blue curve is f1 = 0 and the red curve is f2 = 0" | Z1 is drawn blue and Z2 red (L98-99). In the frames, the blue curve passes through (1, -0.794), which is where f1(1, y) = -1 - 2y^3 = 0. The red curve crosses x = 0 at y ≈ 0.724 and -1.22, the roots of 4y^4 + 4y - 4 | confirmed |
| 3 | "exactly two real solutions, near (0.062, 0.724) and (1.556, -0.576)" | The y-resultant has exactly two real roots. The solutions are (0.06177012633861, 0.72449051534722) and (1.55609748432205, -0.57565076961884) | confirmed |
| 4 | "both lie inside the plotted window" | Window x ∈ [-1.75, 2.25], y ∈ [-1.5, 1.25] | confirmed |
| 5 | "each frame adds the next iterate X(k), connected to the earlier ones by a line" | Plotting code L90-104 and the frames | confirmed |
| 6 | "after the first (Newton) step the iterates are too close to the root to separate at this scale" | After X1, the distance to the root is ≤ 0.0108 in B and ≤ 0.0011 in A. At about 100 px per unit that is ≈ 1 px. The frames agree | confirmed |
| 7 | "right panel plots ‖F(X(k))‖ on a log scale" | L108, yscale log10 | confirmed |
| 8 | Archive: "Example 5 poses this system ... archived copy is missing the starting-point, result and graph images" | lnk_7: gr_213 (the system) is present; gr_214 onward are all missing | confirmed |
| 9 | "starting points are those of the standard Broyden runs in Example 8, whose printed iterates these animations reproduce" | Example 8 (lnk_12) starts at (0.1, 0.7) and (1.5, -0.5) (gr_674, gr_680). The printed standard-Broyden iterates gr_676 (P0-P6) and gr_682 (P0-P7) match the script's Float64 iterates to all 15-16 printed digits | confirmed |
| 10 | Examples 1, 3, improved Broyden (Ex. 8), and the 3D/4D exercises are not animated | Module index lists exactly these | confirmed |
| 11 | Heading A: X(0) = (0.1, 0.7), root ≈ (0.062, 0.724) | Script L26. Root 0.061770, 0.724491 | confirmed |
| 12 | A: "initial exact Newton step moves the iterate by about 0.05" | ‖X1 - X0‖ = 0.0464 | confirmed |
| 13 | A: "reduces ‖F‖ from 2.5×10^-1 to 7.8×10^-3" | 0.248428 → 0.0077616 | confirmed |
| 14 | A: Broyden steps update by rank-1 formula, no new derivative evaluations | Script L59. `Jac` is called only at L43 | confirmed |
| 15 | A: "‖F‖ down to about 10^-15 (machine precision) at X(6)" | Float64 1.355e-15. The true residual of the 50-digit X6 is 1.68e-15. The loop stops at X6 because 1.36e-15 < 1e-12 | confirmed |
| 16 | A: "From X(0) to X(4), ‖F‖ shrinks by between 24 and 43 times per step" | Ratios 32.01, 24.55, 42.25, 25.67 | confirmed |
| 17 | A: "over each of the last two steps by more than 1000 times" | 1304.2 and 1.65e5 (Float64) | confirmed |
| 18 | A: "consistent with the superlinear convergence" | The error ratios ‖e_{k+1}‖/‖e_k‖ in 50 digits go 0.023, 0.030, 0.025, 0.038, 7.7e-4, 7.5e-6, ... toward 0 | confirmed |
| 19 | A alt: ‖F‖ "falling from 2.5e-1 to about 1e-15 (machine precision) in six steps"; "only the first step large enough to see" | 6 steps, 7 frames. The right-panel title in the last frame reads "≈ 1e-15 (machine precision)" | confirmed |
| 20 | Heading B: X(0) = (1.5, -0.5), root ≈ (1.556, -0.576) | Script L26. Root 1.556097, -0.575651 | confirmed |
| 21 | B: "converges to that lower-right solution" | X7 = (1.5560974843220545, -0.5756507696188373) | confirmed |
| 22 | B: "‖F‖ falls at every step, from 7.3×10^-1 at X(0) to about 3×10^-14 at X(7)" | 0.73154, 0.10507, 0.011090, 5.231e-5, 1.056e-5, 1.921e-7, 1.603e-10, 2.956e-14 (monotone). In 50 digits X7 gives 3.17e-14 | confirmed |
| 23 | B: "by a factor of only about 5 from X(3) to X(4)" | 4.953 | confirmed |
| 24 | B: "then by more than 1000 times in each of the last two steps" | 1198.3 and 5424.2 | confirmed |
| 25 | B: "a different initial guess finds a different root" | The two runs reach different roots | confirmed (see the note in Findings) |
| 26 | B alt: "falling at every step from 7.3e-1 to about 3e-14 in seven steps" | 7 steps, 8 frames. The last-frame title reads "= 2.96e-14" | confirmed |
| 27 | Wiring: Case A links `broydenaa.jl` and embeds `broydenaa.gif`; Case B links `broydenbb.jl` and embeds `broydenbb.gif` | `index.qmd` L79, 81, 87, 89. The scripts' parameters match the headings. The regenerated GIFs are byte-identical to the committed ones (manifest) | confirmed |
| 28 | Description: Newton step J ΔX = -F, X+ = X + ΔX | Standard | confirmed |
| 29 | Description: central-difference M_ij formula "for two dimensions"; "2n^2 additional function evaluations" | Matches archive gr_72 (central differences, 2h) and gr_73 ("2n^2") | confirmed |
| 30 | Description: secant condition B_{k+1} s_k = y_k with s and y as defined | The rank-1 update satisfies it by construction: (B + (y - Bs)s^T/s^T s)s = y | confirmed |
| 31 | Description: rank-1 update formula; it is the Frobenius-closest matrix satisfying the secant condition | Standard least-change property. The script implements exactly this formula (L59) | confirmed |
| 32 | Algorithm Step 0: B0 = J(X0), X1 = X0 - B0^{-1} F(X0); k ≥ 1 steps 1-4 | Script L43-44 and L48-64 match. Archive theorem has the same structure | confirmed |
| 33 | Convergence: superlinear; dense solve O(n^3); O(n^2) with Sherman-Morrison | Standard. The computed ratios (#18) agree | confirmed |

### 3. Implementation checks

Both scripts are identical apart from the starting point, the title and the comment lines (checked with `diff`).

**It is the method it claims to be.** This is standard ("good") Broyden. The first step is an exact Newton step with an analytic Jacobian. Every later step does a rank-1 update B += (y - Bs)s^T/(s^T s), then solves B ΔX = -F. The update is applied to B itself, not to B^{-1}, so this is the standard rather than the Sherman-Morrison variant. That is what the page describes. Analytic Jacobian L20-22: ∂f1/∂x = -4 + 4x, ∂f1/∂y = -6y^2, ∂f2/∂x = 4x^3, ∂f2/∂y = 4 + 16y^3. All four are correct.

**The numbers are right.** I wrote an independent 50-digit implementation (`review/indep.py`) and printed the script's iterates from the instrumented copies (`review/inst_aa.jl`, `review/inst_bb.jl`).

| k | Script A (Float64) | Independent A (50 digits) | Script B (Float64) | Independent B (50 digits) |
|---|---|---|---|---|
| 1 | (0.06103861644326676, 0.7252588370082448) | (0.0610386164433, 0.725258837008) | (1.5631443298969072, -0.5824742268041238) | (1.5631443299, -0.582474226804) |
| 2 | (0.06177915983442611, 0.7244597836716361) | (0.0617791598344, 0.724459783672) | (1.5553520368634492, -0.5751881059424518) | (1.55535203686, -0.575188105942) |
| 3 | (0.06177058906248765, 0.7244911570414898) | (0.0617705890625, 0.724491157041) | (1.5560954228565456, -0.5756271271156214) | (1.55609542286, -0.575627127116) |
| 4 | (0.06177010919428844, 0.7244904901876605) | (0.0617701091943, 0.724490490188) | (1.5560969549092851, -0.5756529705862952) | (1.55609695491, -0.575652970586) |
| 5 | (0.06177012632545587, 0.724490515327927) | (0.0617701263255, 0.724490515328) | (1.5560974941407613, -0.5756507313269783) | (1.55609749414, -0.575650731327) |
| 6 | (0.061770126338607456, 0.7244905153472168) | (0.0617701263386, 0.724490515347) | (1.5560974843138242, -0.5756507696504695) | (1.55609748431, -0.57565076965) |
| 7 | (loop stopped) | | (1.5560974843220545, -0.5756507696188373) | (1.55609748432, -0.575650769619) |

The residual norms agree to all shown digits down to about 1e-10. Below that, the Float64 values are at rounding level: A's X6 gives 1.36e-15 in Float64 against 1.68e-15 in 50 digits, and B's X7 gives 2.96e-14 against 3.17e-14. The script's iterates also match Mathews' printed standard-Broyden tables gr_676 and gr_682 digit for digit. That check is independent of my reading of the formula.

**Its reference values are right.** The "true" roots in the titles and headings are (0.062, 0.724) and (1.556, -0.576). The 50-digit solutions from the resultant are (0.0617701263386, 0.7244905153472) and (1.5560974843221, -0.5756507696188). The resultant has exactly two real y-roots, which confirms the claim of exactly two real solutions.

**The picture shows what was computed.** Frames checked: A frames 1-7 (contact sheet plus frame 7), and B frames 2 and 8.
- The left-panel titles show X_k to 4 decimals and match the iterates: A gives (0.0618, 0.7245) and B gives (1.5561, -0.5757).
- The right-panel titles show ‖F(X_k)‖ with the right index. For values below 1e-14 the title shows the order of magnitude: round(log10(1.355e-15)) = -15.
- The contours follow the correct zero sets (claim #2).
- The log-axis limits [1e-16, 10] contain every residual, and the x-axis ticks 0..n_frames match the frame count.
- Nothing is clamped or masked.
- The frame counts are 7 and 8. They match the stopping test (‖F‖ < 1e-12 is reached at X6 in A and at X7 in B), and the cap of 10 iterations is never reached.

