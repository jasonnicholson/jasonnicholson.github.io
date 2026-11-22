# Romberg Integration — animation review

Page: [`pages/numerical-methods/romberg-integration/index.qmd`](../../pages/numerical-methods/romberg-integration/index.qmd) · Scripts: `rombergaa.jl` · GIFs: 1

**Result:** 0 error, 1 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — The animated integrand defeats Romberg acceleration, but the page presents it as showing rapid diagonal convergence

- **Location:** index.qmd:21 "This builds a triangular table whose diagonal entries converge quickly for smooth integrands, often outperforming raw trapezoidal refinement for the same function evaluations."; index.qmd:26 the integrand $f(x)=1+e^{-x}\sin(8x^{2/3})$; index.qmd:37 alt text "...diagonal estimates converge"; rombergaa.jl:9.
- **Now:** The page's only example uses $f(x)=1+e^{-x}\sin(8x^{2/3})$, which is not smooth at $x=0$: $f(x)\approx 1+8x^{2/3}$ near 0, so $f'$ is unbounded there (the vertical tangent at the left edge is visible in every frame). The Euler–Maclaurin error expansion $c_1h^2+c_2h^4+\dots$ that Richardson extrapolation relies on does not hold. The page never says this. Read alongside line 21, a reader would take the animation as an example of the "converge quickly" behaviour.
- **True:** For this integrand both the trapezoid column and the Romberg diagonal converge at the same algebraic rate, $O(h^{5/3})$. Halving $h$ divides the error by about $2^{5/3}=3.175$, not by 4 for the trapezoid rule, and nothing like the rapid diagonal convergence you get on smooth integrands. Extrapolation only improves the constant, by a factor of about 4.4. The final displayed estimate $R_{8,8}=2.016007$ is right to only about 3 significant digits (true $I=2.0162797196$, error $-2.73\times10^{-4}$), against $-1.20\times10^{-3}$ for the raw trapezoid with 128 panels. On a smooth comparison integrand ($1+e^{-x}\sin 8x$) the same table reaches an $R_{8,8}$ error of $2.2\times10^{-12}$.
- **Evidence:** `reviewer/indep.py` (mpmath, 40 digits; reference integral by substitution $x=t^3$, which removes the singularity, checked against two other subdivisions; all agree to 40 digits). Successive error ratios, trapezoid column, n = 1…8192 panels: 0.0046, −1.67, 1.95, 2.95, 3.12, 3.15, 3.16, 3.17, 3.17, 3.17, 3.17, 3.17, 3.17. Diagonal: 0.0035, −1.03, 9.99, 5.72, 2.93, 3.18, 3.18, 3.18, 3.18, … (→ 3.175 = 2^{5/3}). `reviewer/smooth_contrast.py`: |R[k,k] error| for k=4..8 is 4.6e-2, 8.1e-3, 2.8e-3, 8.7e-4, 2.7e-4 for the page's f, and 5.6e-2, 1.4e-3, 7.5e-6, 9.1e-9, 2.2e-12 for the smooth $1+e^{-x}\sin 8x$.
- **Suggested fix:** Either (a) keep this integrand and say so on the page, for example: "Because $x^{2/3}$ has an unbounded derivative at $x=0$, the trapezoidal error is $O(h^{5/3})$ rather than $O(h^2)$, so Richardson extrapolation cannot remove it: the diagonal improves on the trapezoid column only by a constant factor (≈4×) and $R_{8,8}=2.016007$ is still $2.7\times10^{-4}$ from $I\approx2.016280$." Or (b) switch to a smooth integrand (e.g. $1+e^{-x}\sin(8x)$) if the aim is to show Romberg's acceleration. Either way, consider showing the reference value $I\approx2.016280$ in the frame so the viewer can judge convergence.

- **Independent check:** confirmed with correction. Checker: the diagonal converges at O(h^{5/3}), the same as the plain trapezoid rule; R[8,8]=2.01600675 is off by 2.7e-4, while the same table on smooth 1+e^{-x}sin(8x) reaches 2.2e-12. Correction: the 'converge quickly' wording is only on line 21 and is qualified there by 'for smooth integrands'; line 26 and the alt text at 37 are literally true and only frame it.

### F2 — Minor — Page match — "The diagonal entry $R_{k,k}$ provides the best estimate at that stage" is false at stages k=2 and k=3

- **Location:** index.qmd:33 "The diagonal entry $R_{k,k}$ provides the best estimate at that stage."
- **Now:** States without qualification that the diagonal is the best estimate at every stage.
- **True:** At k=2 (m=3), $|R_{2,2}-I|=0.475$ but $|R_{2,1}-I|=0.357$. At k=3 (m=5), $|R_{3,3}-I|=0.463$ but $|R_{3,1}-I|=0.214$. In both stages the diagonal is the *worst* entry in its row. From k=4 on, the diagonal is the most accurate entry in its row.
- **Evidence:** `reviewer/indep.py`, "errors col0 and diag" block, row-wise minimum error vs diagonal error.
- **Suggested fix:** "The diagonal entry $R_{k,k}$ is the usual estimate at each stage; once the mesh resolves the oscillations (here from $m=9$ on) it is the most accurate entry in its row."

- **Independent check:** not run (minor finding, unverified).

### F3 — Minor — Implementation — Romberg Table panel truncates the rows, so the triangle and the diagonal column are never visible

- **Location:** rombergaa.jl:61–71 (table panel is 0.32 of the width, at font size 8); visible in committed frames 5–9.
- **Now:** Each row prints all k entries, but the panel clips everything after about the 3rd–4th column. In frame 9 (k=8) rows 4–8 show only $R_{k,1..3}$ in full, then a cut-off fragment ("1.969", "2.008", "2.013", "2.015", "2.01"). The header "R[k,1] ... R[k,k]" promises the diagonal column, but the triangular table described at index.qmd:21 and the alt text "the Romberg table fills row by row" never appears. The diagonal value is still shown in the left-panel annotation "R[k,k] = …", so no number is lost; only the table structure is.
- **Evidence:** Read committed/rombergaa/frame_005.png and frame_009.png at full size.
- **Suggested fix:** Widen the table panel, or print fewer digits or only the last few columns, so that each row up to k=8 fits. Alternatively, print just $R_{k,1}$ and $R_{k,k}$ (plus the error against $I$) if the full triangle cannot fit.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `rombergaa.jl` | yes | 3.8 | rombergaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Romberg integration accelerates composite trapezoidal approximations with Richardson extrapolation" | Script builds trapezoid column (L19–28) and Richardson recurrence (L30) | confirmed |
| 2 | 13–15 | $R_{k,1}=T_{2^{k-1}}$ | Script: n = m_seq[k]−1 = 1,2,4,…,128 = 2^{k−1} panels; values match independent trapezoid sums to 10 digits | confirmed |
| 3 | 17–18 | $R_{k,j}=R_{k,j-1}+\frac{R_{k,j-1}-R_{k-1,j-1}}{4^{j-1}-1}$, $j=2,\dots,k$ | Identical to rombergaa.jl:29–30; degree-of-precision check: column j exact through degree 2j−1, not 2j (print_R.jl) | confirmed |
| 4 | 21 | "triangular table" | Computed table is triangular; the displayed table is truncated (F3) | confirmed (display issue → F3) |
| 5 | 21 | "diagonal entries converge quickly for smooth integrands" | True in general (smooth contrast: R[8,8] err 2.2e-12), but the page's integrand is not smooth and its diagonal converges at O(h^{5/3}) | confirmed as a general statement; misleading in context (→ F1) |
| 6 | 21 | "often outperforming raw trapezoidal refinement for the same function evaluations" | For this f, from k=4 on, R[k,k] error is 2.4–4.6× smaller than the trapezoid error at the same m; at k=2,3 it is worse | confirmed (hedged "often") |
| 7 | 25–26 | "Each animation below shows the Romberg refinement process for $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$" | rombergaa.jl:9–10; curve in frames matches f (f(0)=1, peak ≈1.92 near x≈0.08, min ≈0.36 near 0.43) | confirmed |
| 8 | 26 | "The graph and table are updated together as the trapezoidal mesh is globally refined" | Frames 2–9: panel count and table row advance together; uniform mesh | confirmed |
| 9 | 26–27 | "sample counts $m=2,3,5,9,17,33,65,129$" | rombergaa.jl:12; frame annotations "Sample Points = 2 … 129" | confirmed |
| 10 | 29 | "Julia source scripts that generated these animations are linked under each case." | Link at L35 → rombergaa.jl, which produces rombergaa.gif byte-identically (manifest) | confirmed |
| 11 | 31 | Case 1 heading: "Romberg Table Construction, $f(x)=1+e^{-x}\sin(8x^{2/3})$, $[0,2]$" | Matches script | confirmed |
| 12 | 33 | "Each frame adds one Romberg row from a denser trapezoidal partition and then applies Richardson extrapolation across the row." | Frames 2–9 each add one row with panels doubled; frame 1 shows only the curve (no row), which is harmless | confirmed |
| 13 | 33 | "The diagonal entry $R_{k,k}$ provides the best estimate at that stage." | False at k=2,3 (diagonal is worst in row); true k≥4 | wrong (→ F2) |
| 14 | 35 | Link "[Julia source](rombergaa.jl)" | File exists; it is the case's script | confirmed |
| 15 | 37 | Embed rombergaa.gif | Exists; produced by rombergaa.jl (manifest: byte-identical) | confirmed |
| 16 | 37 | Alt: "trapezoidal panels refine globally" | Frames 2–9 | confirmed |
| 17 | 37 | Alt: "the Romberg table fills row by row" | Rows added one per frame, but columns past ~3 are clipped | confirmed (display issue → F3) |
| 18 | 37 | Alt: "diagonal estimates converge" | Diagonal 2.0179, 2.4913, 1.5532, 1.9699, 2.0082, 2.0135, 2.0154, 2.0160 → I=2.01628; converges, but only at O(h^{5/3}) | confirmed literally; see F1 |

## Implementation checks

### rombergaa.jl
- **Method:** Standard Romberg integration. Column 1 is the composite trapezoid rule with $2^{k-1}$ uniform panels (rombergaa.jl:19–28). The higher columns use Richardson extrapolation with factor $1/(4^{j-1}-1)$ (L30). This is the textbook variant that recomputes each trapezoid sum from scratch instead of reusing the previous level's nodes. That is equivalent in value and not an error. Property check (`reviewer/print_R.jl`, using the script's recurrence on $x^d$ over [0,2]): column j is exact for degree ≤ 2j−1 and not for degree 2j. For example, col 2 is exact for $x^2, x^3$ with error 4.1e-6 at $x^4$, and col 3 is exact through $x^5$ with error 1.8e-7 at $x^6$. This is the correct degree of precision for Romberg columns (trapezoid, Simpson, Boole, …).
- **Numbers:** Script (`julia reviewer/print_R.jl`, 12 decimals) beside independent mpmath (`reviewer/indep.py`, 10 significant digits). All 36 entries agree to every digit printed. Diagonal:

  | k | m | script R[k,k] | independent R[k,k] | displayed |
  |---|---|---|---|---|
  | 1 | 2 | 2.017924816216 | 2.017924816 | 2.017925 |
  | 2 | 3 | 2.491261017253 | 2.491261017 | 2.491261 |
  | 3 | 5 | 1.553154682740 | 1.553154683 | 1.553155 |
  | 4 | 9 | 1.969924760068 | 1.96992476 | 1.969925 |
  | 5 | 17 | 2.008174202398 | 2.008174202 | 2.008174 |
  | 6 | 33 | 2.013515556346 | 2.013515556 | 2.013516 |
  | 7 | 65 | 2.015410885100 | 2.015410885 | 2.015411 |
  | 8 | 129 | 2.016006749516 | 2.01600675 | 2.016007 |

  Spot-checked first column and inner entries too, e.g. R[8,1]=2.015080262 (both), R[5,3]=2.007327727 (both), R[6,4]=2.013488912 (both). The values displayed in the frames (frame_005, frame_009 read at full size) are these values rounded to 6 decimals.
- **Reference values:** The script draws no reference integral. My reference is $I=2.016279719617096327887\ldots$ (mpmath quad after $x=t^3$, cross-checked by two other subdivisions; all agree to 40 digits). Convergence for this integrand (F1): error ratios approach $2^{5/3}=3.175$ for both the trapezoid column and the diagonal, so the $x^{2/3}$ singularity at 0 defeats the extrapolation. Final $R_{8,8}$ error is −2.73e-4.
- **Picture:** Looked at the contact sheet, frame_005 (m=9) and frame_009 (m=129) at full size. The trapezoid panels are built from $f$ at the uniform nodes, with $n=m-1$ panels matching the "Sample Points" label (e.g. 8 panels at m=9, nodes at multiples of 0.25). The magenta curve is the stated f. The "R[k,k]" annotation shows the diagonal entry of the current row. Axis limits [0,2]×[0,2.1] contain the whole curve (max ≈1.92). No clamping or masking. 9 frames: 1 curve-only frame, then 8 levels. Table panel truncation → F3.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/romberg-integration/`](evidence/romberg-integration/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
