# 2D Trapezoidal and Simpson Rules — animation review (round 7)

Page: `pages/numerical-methods/2d-trapezoidal-and-simpson-rules/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: the rule definitions write `≈` where the page means `=`

- **Location:** `index.qmd:25` (`I_{T} \approx hk\sum...`) and `index.qmd:33` (`I_{S} \approx \frac{hk}{9}\sum...`).
- **What is there now:** $I_T$ and $I_S$ are introduced as only approximately equal to the weighted sums.
- **What is true:** $I_T$ and $I_S$ are the values of the rules, so each is exactly its weighted sum. It is the true integral $I$ that is approximated. The page itself uses them this way at lines 63 and 76 ("whose integral is the trapezoidal value $I_T$", "is the Simpson value $I_S$"), and the GIF titles print `I_T = 4.749087736` and `I_S = 5.106262624`.
- **How I know:** the script's `approx` is the weighted sum itself (`trapezoidal2daa.jl:32-39`, `simpson2daa.jl:33-40`). In `review/interp.py`, the exact integrals of the piecewise-bilinear and piecewise-biquadratic interpolants equal those sums to at most 5.0e-14 for all eight meshes.
- **Suggested correction:** at both lines replace `\approx` with `=`, giving `I_{T} = hk\sum...` and `I_{S} = \frac{hk}{9}\sum...`. Optionally add "with $I\approx I_T$ and $I\approx I_S$" in the sentence that follows.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson2daa.jl` | 0 | 9.9 | simpson2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `trapezoidal2daa.jl` | 0 | 8.0 | trapezoidal2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpson2daa.gif` | 8 | byte-identical | simpson2daa |
| `trapezoidal2daa.gif` | 8 | byte-identical | trapezoidal2daa |

### Page references

- Scripts linked: `trapezoidal2daa.jl`, `simpson2daa.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "numerical approximation of a rectangular double integral with the composite 2D Trapezoidal and 2D Simpson rules" | Weight stencils probed from the script routines (section 3) | Confirmed |
| D2 | "Examples 1–6 of the archived module use" $\int_0^1\int_0^1 8e^{-x^2-y^4}\,dy\,dx$ | Archive images `gr_43`, `67`, `87`, `108`, `132`, `153` each show this integral | Confirmed |
| D3 | surface $z=8e^{-x^2-y^4}$ over $R=\{0\le x\le1,\ 0\le y\le1\}$ | `gr_44`, `45`, `109`, `110`; script line 9 and limits | Confirmed |
| D4 | $I_T \approx hk\sum\sum w_iw_jf(x_i,y_j)$ | Sum is correct (stencil, exactness). The `≈` is F1 | Confirmed, relation symbol **wrong (F1)** |
| D5 | $w_0=w_m=\tfrac12$, $w_i=1$ inside | Probed stencil: 1/2/4 pattern after scaling by $4/(hk)$; matches archive `gr_20` | Confirmed |
| D6 | $I_S \approx \frac{hk}{9}\sum\sum a_ia_jf(x_i,y_j)$ | Sum is correct (stencil, exactness). The `≈` is F1 | Confirmed, relation symbol **wrong (F1)** |
| D7 | $a_0=a_m=1$, $a_i=4$ odd, $a_i=2$ even interior | Probed stencil 1,4,2,...,4,1 and products; matches archive `gr_40` | Confirmed |
| D8 | $m$ panels of width $h=(b-a)/m$, $n$ of width $k=(d-c)/n$, $x_i=a+ih$, $y_j=c+jk$ | Script lines 20-23; `n+1` nodes on each axis | Confirmed |
| D9 | $w_j$, $a_j$ "defined in the same way with $n$ in place of $m$" | Script builds `wy`/`ay` identically. Scripts only run $m=n$, so $m\ne n$ is a statement of the formula and is not exercised | Confirmed |
| D10 | "For Simpson's rule $m$ and $n$ must be even" | Each parabola spans two panels; all `n_seq` values are even | Confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | "Each animation shows full-domain mesh refinement on $[0,1]\times[0,1]$" | Overlay spans x and y in [0,1] in all 16 frames | Confirmed |
| A2 | $f(x,y)=8e^{-x^2-y^4}$ | Script line 9 in both; plotted surface equals $f$ at every sample (max difference 0) | Confirmed |
| A3 | "archived benchmark $I\approx 5.04756680717$" | Archive `gr_90` shows it. Independently $I=8\cdot\frac{\sqrt\pi}{2}\operatorname{erf}(1)\cdot\frac14\gamma(\frac14,1)=5.0475668071675$ | Confirmed |
| A4 | Source scripts "linked under each case" | `index.qmd:65`, `:79`; both files exist | Confirmed |
| A5 | "archived snapshot is incomplete for some intermediate image IDs" | Referenced but absent: `gr_46–66` (lnk_2), `68–86` (lnk_3), `154–187` (lnk_7) | Confirmed |
| A6 | "reconstructed from the available formula and checkpoint assets" | Surviving `gr_92`, `94`, `124`, `131` hold the 10 and 20 panel values, and the scripts reproduce them | Confirmed |
| A7 | Example 7 applies composite Simpson to a double integral with inner limits functions of $x$ (non-rectangular) | `gr_193`: $\int_0^2\int_{x^2}^{\sqrt{8x}}e^{-x\sqrt y}\,dy\,dx$; lnk_8 uses Simpson with n=20, m=5 | Confirmed |
| A8 | Example 7 "is not animated here" | No script or GIF for it | Confirmed |

### Case 1: 2D Trapezoidal

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| T1 | Heading: 2D Trapezoidal, this $f$ | Script and all 8 titles | Confirmed |
| T2 | "coarse-to-fine tensor grid updates over the whole square each frame" | n = 2,4,6,8,10,12,16,20; $2(n+1)$ polylines per frame, full range | Confirmed |
| T3 | "converges toward the archived reference value" | Error 0.298479 → 0.002868, decreasing at every step | Confirmed |
| T4 | "visible second-order error decay" | Observed order between successive meshes: 2.047, 2.011, 2.005, 2.003, 2.002, 2.001, 2.001; 10→20 ratio 4.003 | Confirmed |
| T5 | "black lines join the sample nodes with straight segments" | Overlay has only node points (18 at n=2, 882 at n=20), each equal to $f$ at the node | Confirmed |
| T6 | They are "the grid lines of the piecewise-bilinear interpolant" | Overlay minus my own bilinear evaluator: 0 at all points, all meshes | Confirmed |
| T7 | Its integral "is the trapezoidal value $I_T$" | Exact interpolant integral minus sum: at most 5.0e-14 | Confirmed |
| T8 | Link and embed are this case | `trapezoidal2daa.jl`, `.gif`; byte-identical to regeneration | Confirmed |
| T9 | Alt: coloured surface, straight black lines through nodes, 2x2 to 20x20, convergence to benchmark | Frames 1–8, `n_seq` | Confirmed |

### Case 2: 2D Simpson

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| S1 | Heading: 2D Simpson, this $f$ | Script and all 8 titles | Confirmed |
| S2 | "weights are recomputed on each refined mesh" | `simpson2d(n)` is called per frame | Confirmed |
| S3 | "reaches high accuracy with fewer refinements" than trapezoidal | Simpson at 6x6 (error 6.68e-4) already beats Trapezoidal at 20x20 (2.87e-3) | Confirmed |
| S4 | Black curves are "the quadratics through the sample nodes over each pair of panels along every grid line" | `quadpieces` code; overlay values equal $f$ at all nodes (max 1.8e-15) | Confirmed |
| S5 | They are grid lines of the "piecewise-biquadratic interpolant (one patch per 2x2 block of panels)" | Overlay minus my own patchwise biquadratic evaluator: at most 3.6e-15, all meshes | Confirmed |
| S6 | Its integral "is the Simpson value $I_S$" | Exact interpolant integral minus sum: at most 7.2e-15 | Confirmed |
| S7 | "On the 2x2 mesh they differ from the trapezoidal straight lines by up to 0.51 in $z$" | Max over all six grid lines 0.51095, on $x=0$ at $y=0.25$; closed form $\lvert 8-16e^{-1/16}+8/e\rvert/8=0.510947$ | Confirmed |
| S8 | Link and embed are this case | `simpson2daa.jl`, `.gif`; byte-identical to regeneration | Confirmed |
| S9 | Alt: coloured surface, black piecewise-quadratic curves, 2x2 to 20x20, convergence toward benchmark | Frames 1–8, `n_seq` | Confirmed |

### Script comments and frame content

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| K1 | `trapezoidal2daa.jl:16` "archived checkpoints at 10x10 and 20x20" | Archive `gr_91–94`; script values match all printed digits | Confirmed |
| K2 | `simpson2daa.jl:14` "n=2 quadratic along x=0 peaks at about 8.30" | Peak 8.29734 at y=0.1907; inside `zlims` 8.4 | Confirmed |
| K3 | `simpson2daa.jl:16` even counts "including legacy checkpoints" | Archive Simpson m=5 and m=10 mean $2m$ = 10 and 20 panels (`gr_26`, `124`, `131`); script n=10, 20 match | Confirmed |
| K4 | All 16 frame titles (mesh, value, error) | Table in section 3 | Confirmed |

---

### 3. Implementation checks

Instrumented copies log the plotted series and title of each frame (`review/inst/*_inst.jl`). Routine-only copies with a swappable integrand are in `review/inst/*_rt.jl`, driven by `review/inst/exact.jl`. Independent computations are `review/indep.py` (mpmath, 40 digits) and `review/interp.py`.

### Values: script against independent computation

Independent values use the product form, since $f$ separates: $8\,R_n[e^{-x^2}]\,R_n[e^{-y^4}]$.

| n | Script $I_T$ | Independent $I_T$ | Title error | Script $I_S$ | Independent $I_S$ | Title error |
|---|---|---|---|---|---|---|
| 2 | 4.74908773601 | 4.74908773601 | 0.298479071 | 5.10626262445 | 5.10626262445 | 0.058695817 |
| 4 | 4.97534469138 | 4.97534469138 | 0.072222116 | 5.05181162651 | 5.05181162651 | 0.004244819 |
| 6 | 5.01560470555 | 5.01560470555 | 0.031962102 | 5.04823477291 | 5.04823477291 | 0.000667966 |
| 8 | 5.02961321904 | 5.02961321904 | 0.017953588 | 5.04776277735 | 5.04776277735 | 0.00019597 |
| 10 | 5.03608376360 | 5.0360837636 | 0.011483044 | 5.04764458608 | 5.04764458608 | 7.7779e-5 |
| 12 | 5.03959517544 | 5.03959517544 | 0.007971632 | 5.04760371212 | 5.04760371212 | 3.6905e-5 |
| 16 | 5.04308426450 | 5.0430842645 | 0.004482543 | 5.04757830361 | 5.04757830361 | 1.1496e-5 |
| 20 | 5.04469842165 | 5.04469842165 | 0.002868386 | 5.04757148312 | 5.04757148312 | 4.676e-6 |

Archive checkpoints agree: Trapezoidal 10 and 20 panels `5.0360837636`, `5.04469842165` (`gr_92`, `94`); Simpson $m=5$ and $m=10$, that is 10 and 20 panels, `5.04764458608`, `5.04757148312` (`gr_124`, `131`).

### `trapezoidal2daa.jl`

- **It is the method claimed.** Composite tensor-product trapezoidal rule. Probing each node at n=6 recovers the stencil corners 1, edges 2, interior 4 (scaled by $4/(hk)$), the archive's pattern.
- **Numbers are right.** Monomial test at n=4 using the script's routine: exact for $x^ay^b$ with $a,b\le1$ (error 0), nonzero once $a$ or $b$ reaches 2 (for example 1.0e-2 for $x^2$). Closed-form test on $e^{x+y}$: errors 4.92e-3, 1.23e-3, 3.08e-4 at n=10, 20, 40, a ratio of 4. Observed order on the page's integrand is 2.00–2.05.
- **Reference is right.** $5.04756680717$ differs from the 40-digit value by 2.5e-12, which is ordinary rounding at 11 decimals. Double quadrature and the erf/incomplete-gamma product agree.
- **Picture is right.** The surface equals $f$ at all samples with the correct row/column orientation. The overlay has $2(n+1)$ polylines and matches an independent bilinear evaluator exactly. `zlims` (0, 8.2) contain all drawn values (1.08 to 8.00), with no clamping or masking. Titles carry the correct n, value and error. Frames viewed: all eight on the contact sheet, frames 1 and 8 full size, and a zoomed crop of frame 8. Grid lines crowd near the far silhouette at 20x20 through foreshortening; the plot stays readable, so this is not a finding.

### `simpson2daa.jl`

- **It is the method claimed.** Composite tensor-product Simpson 1/3 rule. Probing at n=6 recovers the product stencil 1,4,2,4,2,4,1 with interior 16, 8, 4, the archive's pattern.
- **Numbers are right.** Monomial test at n=4: exact for $a,b\le3$, nonzero once $a$ or $b$ reaches 4 (5.2e-4 for $y^4$). Closed-form test on $e^{x+y}$: errors 3.28e-6, 2.05e-7, 1.28e-8 at n=10, 20, 40, a ratio of 16. Observed order on the page's integrand settles from 4.56 to 4.03 as the mesh refines (3.79 on the first, coarsest step).
- **Reference is right.** Same constant as above.
- **Picture is right.** The overlay matches an independent patchwise biquadratic evaluator to at most 3.6e-15 on all eight meshes, including odd-index grid lines, which run through the interior of a patch. `zlims` (0, 8.4) contain the largest overlay value, 8.2973 at n=2, so the overshoot above the surface's maximum of 8 is shown unclipped. Frames viewed: all eight on the contact sheet, frames 1, 4 and 8 full size.

### Archive notes (no finding)

- Mathews' Simpson $m$ counts panel pairs ($2m$ panels), while this page's $m$ counts panels. The page is self-consistent, and its 10x10 and 20x20 frames are his $m=5$ and $m=10$.
- The archive's Example 1 is worded "composite Simpson's rule" but its solution runs `Trapezoidal2D`. The page correctly treats it as trapezoidal.
- The archive's Example 5 (`gr_137–146`, `gr_151`) reprints the Trapezoidal values and ratio 0.249793 under Simpson labels. The page does not inherit this. The true Simpson error ratio for 10 to 20 panels is $4.676\times10^{-6}/7.778\times10^{-5}=0.0601$.
- All examples are represented or explicitly excluded (Example 7), so there is no silent drop. No legacy animated GIF exists for this topic under `a2001/Animations/Quadrature/`.

### Could not determine

- The missing archive images (`gr_46–66`, `68–86`, `154–187`) cannot be viewed, so the exact printed output of Examples 1, 2 and 6 was not read directly. Their integrand images survive, and the Example 1 values are reprinted in Example 3 (`gr_92`, `94`), so no page claim depends on them.

