# Broyden's Method — animation review

Page: [`pages/numerical-methods/broydens-method/index.qmd`](../../pages/numerical-methods/broydens-method/index.qmd) · Scripts: `broydenaa.jl`, `broydenbb.jl` · GIFs: 2

**Result:** 0 error, 0 misleading, 3 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Minor — Page match — Case B root y-coordinate is misrounded as −1.665; to 3 decimals it is −1.664

- **Location:** index.qmd line 80 (heading "root $\approx (2.808,\,-1.665)$"); index.qmd line 86 (alt text "the root near (2.808, -1.665)"); broydenbb.jl line 29 (`title_str = "Broyden's Method: solution near (2.808, -1.665)"`, which is the title of every frame of broydenbb.gif); broydenbb.jl line 2 (header comment).
- **Now:** −1.665.
- **True:** y* = −1.66448698091455, which is −1.664 to 3 decimals. The stated value is off by 5.1e-4, just over half a unit in the last place. It looks like a double rounding: −1.66449 → −1.6645 (this is what the GIF legend shows, correctly to 4 d.p.) → −1.665. The x-coordinate 2.808 (true 2.80845705) is correct.
- **Evidence:** `indep.py` gives the solution (2.80845705219506, −1.66448698091455) at 30-digit precision. The script's final iterate (`instr_bb.jl`) is X_7 = (2.8084570521950516, −1.6644869809145124), |F| = 2.2e-13. In frame 8 of the committed GIF the title reads "(2.808, -1.665)" and the legend reads "X_7 = (2.8085, -1.6645)".
- **Suggested fix:** Change −1.665 to −1.664 on index.qmd lines 80 and 86 and broydenbb.jl lines 2 and 29, then regenerate broydenbb.gif. Writing (2.8085, −1.6645) in all four places would also be correct and would match the legend.

- **Independent check:** not run (minor finding, unverified).

### F2 — Minor — Page match — "the second solution": the system has four real solutions, three of them inside the plotted window

- **Location:** index.qmd line 82: "the same Broyden algorithm converges to the second solution." The script comments (broydenaa.jl line 2 "solution 1", broydenbb.jl line 2 "solution 2") use the same wording.
- **Now:** The wording implies the system has two solutions, upper-left and lower-right.
- **True:** The circle f₂ = 0 (x² + (y+2)² = 8) and the hyperbola f₁ = 0 (2(x−1)² − 2y² = 1) meet at four points: (−0.088126, 0.827054), (1.742852, 0.227660), (2.808457, −1.664487) and (−2.463183, −3.390227). The first three lie in the plot window x ∈ [−1, 3.5], y ∈ [−2.5, 2]. The intersection at (1.743, 0.228) is clearly visible in every frame of both GIFs, and the page never mentions it.
- **Evidence:** `indep.py` finds the resultant in y, 16y⁴ + 64y³ + 8y² − 80y + 17, which has four real roots, and lists the four solutions above. Frames committed/broydenaa/frame_007.png and committed/broydenbb/frame_008.png show the blue and red curves crossing near (1.74, 0.23).
- **Suggested fix:** Say "converges to the lower-right solution". Optionally add to the Animations introduction (line 68) that the system has four real solutions, three of them visible in the plot window.

- **Independent check:** not run (minor finding, unverified).

### F3 — Minor — Page match — Case B is said to illustrate that the method is "dimension-independent", but it does not show this

- **Location:** index.qmd line 82: "This case illustrates that the method is dimension-independent and starting-point dependent".
- **Now:** The page claims Case B illustrates dimension-independence.
- **True:** Case B is the same 2-D system as Case A, with a different starting point. It shows starting-point dependence (a different start gives a different root, which is confirmed), but nothing in it bears on dimension.
- **Evidence:** `diff broydenaa.jl broydenbb.jl` shows the scripts differ only in comments, the start (x0, y0), the title and the output filename. The system F and the dimension n = 2 are the same.
- **Suggested fix:** Drop "dimension-independent and". For example: "This case illustrates that the method is starting-point dependent: a different initial guess finds a different root."

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `broydenaa.jl` | yes | 3.5 | broydenaa.gif |
| `broydenbb.jl` | yes | 3.5 | broydenbb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | Broyden's method maintains an approximate Jacobian "cheaply updated at each step using only the change in function values — no additional derivative or finite-difference evaluations are needed after the first iteration" | Both scripts call `Jac` only once (line 40). After that, B changes only through the rank-one update built from s and y (line 56). | confirmed |
| 2 | 18 | Newton step $J\Delta X = -F$, $X^{(k+1)} = X^{(k)} + \Delta X$ | Standard. The scripts use it as step 0 (line 41). | confirmed |
| 3 | 20 | Newton converges quadratically near a simple root | Standard result. Not exercised by the scripts. | confirmed (standard theory) |
| 4 | 26–28 | Central-difference Jacobian $M_{ij}$; "$2n^2$ additional function evaluations per iteration" | The formula is the correct central difference. It needs 2n evaluations of the vector F, which is 2n² scalar component evaluations, consistent with the page's "n² partial derivatives" count. The scripts do not use finite differences, and the page does not say they do. | confirmed |
| 5 | 34–36 | Secant condition $B_{k+1}s_k = y_k$ with $s_k = X^{(k+1)}-X^{(k)}$ and $y_k = F(X^{(k+1)})-F(X^{(k)})$ | The script defines s and y this way (lines 50–51). `secant_*.jl` gives relative residuals ≤ 1.5e-16 at every update in both scripts. | confirmed |
| 6 | 38–40 | Rank-1 update $B_{k+1} = B_k + (y_k - B_k s_k)s_k^T/(s_k^T s_k)$, the matrix closest to $B_k$ in the Frobenius norm that satisfies the secant condition | The code at line 56 is exactly this update ("good" Broyden, Broyden's first method). The minimum-Frobenius-change property is standard for this update. | confirmed |
| 7 | 42 | Rank-1 correction, O(n²) to update, no extra function evaluations beyond F(X^{(k+1)}) | The code evaluates F once per iteration (line 46). The update is an outer product. | confirmed |
| 8 | 46–48 | Step 0: exact Jacobian $B_0 = J(X^{(0)})$, then one Newton step | broydenaa.jl and broydenbb.jl lines 40–41. Jac at lines 17–20 matches the sympy Jacobian [[4x−4, −4y], [2x, 2y+4]]. | confirmed |
| 9 | 50–56 | Loop: evaluate F, update B_k with s_{k−1}, solve $B_k\Delta X = -F$, update X | Lines 45–61 do exactly this. Each script iterate equals the independent `indep.py` iterate to every printed digit. | confirmed |
| 10 | 60 | Converges superlinearly near a simple root, faster than linear, slower than quadratic | Error ratios e_{k+1}/e_k from `indep.py`. Case A: 0.041, 0.033, 0.11, 0.10, 1.8e-4 (the next one is at roundoff). Case B: 0.071, 0.099, 0.21, 0.043, 3.9e-3, 3.8e-4. The ratios tend to 0 without being monotone, as expected for Broyden. Both roots are simple (cond(B) ≈ 2 and 4). | confirmed |
| 11 | 66 | System $f_1 = 1-4x+2x^2-2y^2$, $f_2 = -4+x^2+4y+y^2$ | Matches F at lines 13–14 and the contour grids at lines 74–75 of both scripts. | confirmed |
| 12 | 68 | "blue curve is $f_1=0$ and the red curve is $f_2=0$; their intersections are the solutions" | Code lines 85–88. In the frames the blue curve is a hyperbola (f₁) and the red curve a circle (f₂). | confirmed (but see F2 on how many intersections there are) |
| 13 | 68 | "Each frame adds the next iterate $X^{(k)}$, connected by a line" | Frame 1 shows X_0 alone. Each later frame adds one iterate, joined by a steelblue line, and the legend names X_k. Seen in both contact sheets. | confirmed |
| 14 | 70, 76, 84 | Julia source linked under each case | Line 76 links broydenaa.jl and line 84 links broydenbb.jl. Both files exist. | confirmed |
| 15 | 72 | Case A: Convergent, $X^{(0)} = (0, 1)$ | broydenaa.jl line 23 sets (0.0, 1.0). The run converges to \|F\| = 6.9e-13. | confirmed |
| 16 | 72, 78 | Case A root ≈ (−0.088, 0.827) | True value (−0.08812598994886, 0.82705390997334) from `indep.py`. The script's X_6 agrees to about 1e-13. | confirmed |
| 17 | 74 | "Starting near the upper-left intersection" | (0, 1) is 0.194 from the root. Of the three intersections in the window, this root is the upper-left one. | confirmed |
| 18 | 74 | "the initial exact Newton step lands close to the root" | X_1 = (−0.08333, 0.83333), error 7.9e-3 against an initial error of 0.194. | confirmed |
| 19 | 74 | "subsequent Broyden quasi-Newton updates converge superlinearly" | See row 10, Case A. The GIF cannot show the rate: after X_2 every iterate falls under the root marker. | confirmed (computation) |
| 20 | 74 | "approximate Jacobian is updated cheaply by the rank-1 formula without any new derivative evaluations" | Line 56. Jac is called only at step 0. | confirmed |
| 21 | 78 | Alt text: GIF starts at (0,1), converges superlinearly to the root near (−0.088, 0.827), f1 blue, f2 red | Frames 1–7 of broydenaa.gif. For the rate, see row 19. | confirmed |
| 22 | 80 | Case B: Convergent, $X^{(0)} = (2.5, -1.5)$ | broydenbb.jl line 23. The run converges to \|F\| = 2.2e-13. | confirmed |
| 23 | 80, 86 | Case B root ≈ (2.808, −1.665) | True value (2.80845705219506, −1.66448698091455), which is −1.664 to 3 d.p. | wrong (→ F1) |
| 24 | 82 | "Starting near the lower-right intersection" | (2.5, −1.5) is 0.35 from (2.808, −1.664), the lower-right intersection in the window. | confirmed |
| 25 | 82 | "converges to the second solution" | The system has four real solutions, three of them in the window. | wrong (→ F2) |
| 26 | 82 | "illustrates that the method is dimension-independent" | Same 2-D system as Case A. | wrong (→ F3) |
| 27 | 82 | "starting-point dependent: a different initial guess finds a different root" | Case A converges to (−0.088, 0.827) and Case B to (2.808, −1.664). | confirmed |
| 28 | 86 | Alt text: GIF starts at (2.5,−1.5), converges superlinearly to the root near (2.808, −1.665), f1 blue, f2 red | Start and colours confirmed in frames 1–8. Convergence confirmed by computation (row 10). The root's y-coordinate is wrong (F1). | wrong (→ F1) |

## Implementation checks

### broydenaa.jl
- **Method:** "Good" Broyden (Broyden's first method, a direct rank-one update of the Jacobian approximation B, not of its inverse). The initial Jacobian is the **exact** analytic Jacobian at X^{(0)}, not a finite-difference one. Step 0 is a full Newton step (lines 40–41). The loop (lines 45–62) applies B ← B + (y − Bs)sᵀ/(sᵀs) and then solves B ΔX = −F. It stops when ‖F‖ < 1e-12 or sᵀs < 1e-20. This is what the page's Description (lines 32–56) states.
- **Secant condition:** checked inside the script's own loop (`secant_aa.jl`). The relative residuals |B_{k+1}s_k − y_k|/|y_k| at k = 1…5 were 8.2e-17, 1.3e-16, 1.5e-16, 0, 0. cond(B) stays between 1.9 and 2.3.
- **Numbers:** script iterates (`instr_aa.jl`) beside the independent ones (`indep.py`, numpy Broyden):

  | k | script x, y | independent x, y | error to root |
  |---|---|---|---|
  | 0 | 0, 1 | 0, 1 | 1.94e-1 |
  | 1 | −0.083333333333333343, 0.83333333333333337 | identical | 7.90e-3 |
  | 2 | −0.088150289017340996, 0.82731213872832365 | identical | 2.59e-4 |
  | 3 | −0.08809724745923854, 0.82705643402428919 | identical | 2.89e-5 |
  | 4 | −0.088128867769534866, 0.82705371459896204 | identical | 2.88e-6 |
  | 5 | −0.088125990458832751, 0.82705390992447692 | identical | 5.12e-10 |
  | 6 | −0.088125989948707545, 0.82705390997334716 | identical | 1.52e-13 |

  The errors give superlinear ratios. The run ends after X_6 because ‖F(X_6)‖ = 6.9e-13 < 1e-12, so there are 7 iterates and 7 frames.
- **Reference values:** The script draws no reference marker. The title value (−0.088, 0.827) agrees with the 30-digit solution (−0.0881259899488592, 0.827053909973337). The Jacobian in `Jac` matches the sympy-derived one.
- **Picture:** I read the contact sheet (all 7 frames) and full-size frame_007. The blue hyperbola is f₁ = 0 and the red circle is f₂ = 0, which agrees with the code and the page. The path and markers are built from `iterates` directly; there is no clamping and everything is inside the limits. The legend label "X_k = (…)" gives the current iterate rounded to 4 d.p. and matches the computed values for k = 0…6. The underscore is printed literally ("X_6"), which is cosmetic. From frame 3 on, the new iterates are indistinguishable from the root at plot scale, and the 4-d.p. legend stops changing after X_3. This is honest, but it means the GIF does not itself show the convergence rate. The contour curves have no legend entry; the page text gives their colours.

### broydenbb.jl
- **Method:** Identical code to broydenaa.jl. `diff` shows changes only to comments, the start (2.5, −1.5), the title and the output filename. So it is also good Broyden with an exact initial Jacobian.
- **Secant condition:** `secant_bb.jl` at k = 1…6 gives 1.1e-16, 0, 1.5e-16, 0, 3.1e-17, 1.5e-17. cond(B) stays between 3.8 and 4.2.
- **Numbers:**

  | k | script x, y | independent x, y | error to root |
  |---|---|---|---|
  | 0 | 2.5, −1.5 | 2.5, −1.5 | 3.50e-1 |
  | 1 | 2.8333333333333335, −1.6666666666666667 | identical | 2.50e-2 |
  | 2 | 2.8072916666666665, −1.6666666666666665 | identical | 2.47e-3 |
  | 3 | 2.8083157428400178, −1.6639955176817034 | identical | 5.11e-4 |
  | 4 | 2.8084614598932833, −1.6645084334413696 | identical | 2.19e-5 |
  | 5 | 2.8084570688624013, −1.6644870647583865 | identical | 8.55e-8 |
  | 6 | 2.8084570522020909, −1.6644869809460237 | identical | 3.23e-11 |
  | 7 | 2.8084570521950516, −1.6644869809145124 | identical | 4.29e-14 |

  There are 8 iterates and 8 frames (‖F(X_7)‖ = 2.2e-13).
- **Reference values:** The 30-digit solution is (2.80845705219506, −1.66448698091455). The title's 2.808 is correct, but its −1.665 is misrounded (F1).
- **Picture:** I read the contact sheet (all 8 frames) and full-size frame_008. The curves and colours are as stated. The legend values match the computed iterates to 4 d.p.: X_3 = (2.8083, −1.664) and X_4…X_7 = (2.8085, −1.6645). There is no clamping. The title shows the misrounded −1.665 in every frame while the legend shows −1.6645 (F1). The third visible intersection, (1.743, 0.228), is plainly drawn and the page does not mention it (F2).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/broydens-method/`](evidence/broydens-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
