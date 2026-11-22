# Chebyshev Approximation Polynomial — animation review (round 3)

Page: `pages/numerical-methods/chebyshev-approximation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1: Case 07 approximation interval differs from Mathews' example (Fidelity, Minor)

- **Location:** `chebyshev_animations_all.jl` line 34, `with_span("07", "1/sqrt(1-x)", …, (-1.6, 1.5), (-1.6, 0.9))`; `index.qmd` "Case 07 caption: f(x)=1/sqrt(1-x), interval [-1.6, 0.9]."
- **Now:** the Chebyshev nodes for f(x)=1/√(1−x) are placed on [−1.6, 0.9].
- **Legacy:** Mathews' module Example 7, which is the example behind "Animation 7" (`chebyshevpoly/ChebyshevPolyMod/Links/ChebyshevPolyMod_lnk_15.html`), reads "Find the Chebyshev polynomial approximation for 1/√(1−x) on the interval [−1.5, 0.95]" (formula images `ChebyshevPolyMod_gr_499.gif` and `ChebyshevPolyMod_gr_500.gif`). The code image for this example (`gr_501`) is missing from the archive. However, in every surviving example that uses a sub-interval (sqrt `gr_460`, 1/(1+10x²) `gr_516`, tan `gr_593`, asin `gr_641`), the node interval `aa, bb` equals the interval stated in the text. The plotting window [−1.6, 1.5] matches the legacy window. The page gives no reason for the change.
- **Why it matters:** the right endpoint sets how close the nodes get to the branch point at x=1, so it sets how fast the sequence converges. I computed the maximum interpolation error on the interval with `scipy.interpolate.BarycentricInterpolator` at Chebyshev nodes:
  - page interval [−1.6, 0.9]: 0.251 (n=6), 0.0032 (n=16)
  - Mathews' interval [−1.5, 0.95]: 0.768 (n=6), 0.0316 (n=16)

  With the page's interval, the animation converges about 10 times faster at 16 nodes than Mathews' example did.
- **Correction:** change the row to `(-1.5, 0.95)`, which makes the title, caption and alt text read `[-1.5, 0.95]`. Alternatively, keep [−1.6, 0.9] and say in the caption that it departs from the source example.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `chebyshev_animations_all.jl` | 0 | 43.8 | 29 GIFs (cheby01.gif … cheby29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `cheby01.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby02.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby03.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby04.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby05.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby06.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby07.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby08.gif` | 14 | byte-identical | chebyshev_animations_all |
| `cheby09.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby10.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby11.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby12.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby13.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby14.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby15.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby16.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby17.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby18.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby19.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby20.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby21.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby22.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby23.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby24.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby25.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby26.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby27.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby28.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby29.gif` | 10 | byte-identical | chebyshev_animations_all |

### Page references

- Scripts linked: `chebyshev_animations_all.jl`
- GIFs embedded: 29
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Every claim was checked against evidence I produced myself: the instrumented run (`review/dump.jl` → `titles.txt`, `dump.tsv`), the independent computation (`review/indep.py`, `review/degree.py`), the caption cross-check (`review/caption_check.txt`), and the frames.

### Description

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | "Chebyshev-node interpolation uses clustered nodes near interval endpoints" | confirmed | The node formula gives cos-spaced points that are densest at the ends. The frames show this, e.g. cheby08 n=32. |
| D2 | "…to reduce oscillation compared with equally spaced interpolation at the same degree" | confirmed (as the usual asymptotic statement) | For f=1/(1+10x²) on [−1,1], max error equispaced vs Chebyshev: n=12: 0.236 vs 0.048; n=16: 0.485 vs 0.014; n=20: 1.07 vs 0.004. At n=8 Chebyshev is slightly worse (0.165 vs 0.135). This is low-degree noise, not a contradiction of the stated tendency. (`review/runge.out`) |
| D3 | "…a standard remedy for Runge-type endpoint blow-up" | confirmed | Same computation as D2: equispaced error grows with n, Chebyshev error falls. |
| D4 | Node formula x_k=(a+b)/2+(b−a)/2·cos((2k−1)π/(2n)), k=1..n, "the mapped roots" | confirmed | The formula matches script line 97. In 50-digit arithmetic, T_n at the mapped nodes is ≤ 6e-40 (n=3, 16). |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "Each animation steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes" | confirmed | `node_count_sequence(15)` = [2,3,4,5,6,8,10,12,14,16] for all 28 non-08 cases. Each of those GIFs has 10 frames, and the frame titles read n = 2 … 16. |
| A2 | "(case 08 continues to 20, 24, 28 and 32)" | confirmed | Case 08 sequence = [2,…,16,20,24,28,32], 14 frames; the last-frame title reads n = 32. |
| A3 | "for a fixed function and approximation interval" | confirmed | `span` and `f` are fixed per case. The trimming fallback in `chebyshev_nodes` never fires: `trimmed=false` for all 294 (case, n) pairs. |
| A4 | "With n nodes the interpolant has degree at most n−1" | confirmed | n-point interpolation. The GIF titles say "degree ≤ n−1". |
| A5 | "for an even function on a symmetric interval and even n it is at most n−2" | confirmed | For cases 08, 13, 17, 20, 22 the leading Chebyshev coefficient \|c_{n−1}\| ≤ 5e-40 at n=2, 4, 6, 16, while c_{n−2} is non-zero (`review/degree.py`). |
| A6 | "[Julia source for all cases](chebyshev_animations_all.jl)" | confirmed | The file exists beside the page and produces all 29 GIFs. Regenerated GIFs are byte-identical to the committed ones (manifest). |

### Per-case captions, alt text and embeds (all 29 rows)

For every row I compared the heading number, alt text number, embedded GIF name, function and interval with the case-table row and the GIF title. Titles were generated by the instrumented copy and read visually on the last frame of every GIF (`review/last_0…7.png`). Verdict for every row: **confirmed** (`review/caption_check.txt`).

| Case | Page: f, interval | Script row (f; window; nodes interval) | GIF title (last frame) | Verdict |
|---|---|---|---|---|
| 01 | 1/(1-x), [-1.6, 0.9] | 1/(1-x); (−1.6,1.5); (−1.6,0.9) | 1/(1-x), [-1.6, 0.9], n=16 | confirmed |
| 02 | 1/(1+x), [-0.9, 1.5] | (−1.5,1.6); (−0.9,1.5) | same | confirmed |
| 03 | 1/(1-x)^2, [-1.5, 0.8] | (−1.6,1.5); (−1.5,0.8) | same | confirmed |
| 04 | sqrt(x), [0, 2] | (0,10.5); (0,2) | same | confirmed |
| 05 | sqrt(x), [0, 8] | (0,10.5); (0,8) | same | confirmed |
| 06 | sqrt(x), [0, 10] | (0,10.5); (0,10) | same | confirmed |
| 07 | 1/sqrt(1-x), [-1.6, 0.9] | (−1.6,1.5); (−1.6,0.9) | same | confirmed (page/GIF/script agree; see F1 for fidelity) |
| 08 | 1/(1+10x^2), [-1, 1], up to 32 nodes | (−1.5,1.5); (−1,1); max_order 31 | same, n=32 | confirmed |
| 09 | log(x), [0.02, 2] | (−0.5,4.1); (0.02,2) | same | confirmed |
| 10 | log(x), [0.02, 4] | (−0.5,4.1); (0.02,4) | same | confirmed |
| 11 | log(1+x), [-0.98, 1] | (−1.5,1.5); (−0.98,1) | same | confirmed |
| 12 | sin(x), [-3pi, 3pi] | auto span = window (−3π,3π) | [-9.425, 9.425] (= ±3π) | confirmed |
| 13 | cos(x), [-3pi, 3pi] | auto span = window | [-9.425, 9.425] | confirmed |
| 14 | tan(x), approximation interval [-1.45, 1.45] inside singularities | (−π,π); (−1.45,1.45); poles ±π/2 | same | confirmed (1.45 < π/2 ≈ 1.5708) |
| 15 | exp(x), [-2, 3] | auto = (−2,3) | same | confirmed |
| 16 | cos(x)*exp(-x), [-2, 4] | auto = (−2,4) | same | confirmed |
| 17 | cosh(x), [-4, 4] | auto = (−4,4) | same | confirmed |
| 18 | atan(x), [-2.2, 2.2] | auto = (−2.2,2.2) | same | confirmed |
| 19 | asin(x), [-1, 1] | (−1.5,1.5); (−1,1) | same | confirmed |
| 20 | besselj(0,x), [-10.2, 10.2] | auto = (−10.2,10.2) | same | confirmed |
| 21 | besselj(1,x), [-10.2, 10.2] | auto | same | confirmed |
| 22 | normal_pdf(x), [-3, 3] | exp(−x²/2)/√(2π); auto (−3,3) | same | confirmed |
| 23 | normal_cdf(x), [-3, 3] | ½+½erf(x/√2); auto | same | confirmed |
| 24 | gamma(x), [0.05, 2] | (−0.2,5.2); (0.05,2) | same | confirmed |
| 25 | gamma(x), [0.05, 4] | (0.05,4) | same | confirmed |
| 26 | gamma(x), [0.5, 5] | (0.5,5) | same | confirmed |
| 27 | bessely(0,x), [0.5, 20] | (0,22); (0.5,20) | same | confirmed |
| 28 | bessely(0,x), [0.5, 10] | (0.5,10) | same | confirmed |
| 29 | bessely(0,x), [0.5, 4] | (0.5,4) | same | confirmed |

For the auto-span cases (12, 13, 15–18, 20–23), `finite_support` returns the full window because f is finite at every grid point, which I checked from the instrumented `span`. So "interval" equals the plotting window, as the captions say.

The page has no "Behavior" paragraphs, so there are no behaviour claims to check.

### Fidelity to the legacy archive, row by row

- **Plotting window:** for all 29 rows the script's window equals Mathews' window (`Lagrange_gr_*` images). This includes ±3π, [−π,π], [−0.2,5.2] and [0,22].
- **Function:** all 29 equal Mathews' functions.
- **Node intervals stated in the legacy index ("unequally spaced nodes in …"):** cases 04, 05, 06, 08, 09, 10, 11, 24, 25, 26, 27, 28 and 29 all match.
- **Module examples with code:** sin and cos use a,b = ±3π (`gr_560`, `gr_578`); exp uses [−2,3] (`gr_608`); tan uses ±1.45 (`gr_593`); asin uses [−1,1] (`gr_641`). All match the page. The "[−10,10]" and "[−5,5]" in the sin, cos and exp example text are the green marker lines `a0, b0`, not the node interval.
- **Case 07:** see F1.
- **Cases 18 and 20:** the example text says [−2,2] and [−10,10]; the page uses the window, ±2.2 and ±10.2. The code images (`gr_626`, `gr_656`) are missing. In the sin, cos and exp examples a text interval like this turned out to be decoration, so I **could not determine** whether these are departures. Not reported.
- **Cases 01, 02, 03:** no module example exists, and the index gives only the window. I **could not determine** Mathews' node interval. The page's sub-intervals avoid the pole and are mathematically sound. Not reported.
- **Node counts:** Mathews' animations use 3–6 or 9–17 nodes depending on the case. The page uses a uniform 2…16 (32 for case 08). This is a presentation choice with no effect on what a reader learns. Not reported.
- **Method:** Mathews builds `NewtonPoly` through the n+1 points t_k = (a+b)/2 + (b−a)/2·cos((2n+1−2k)π/(2n+2)), k=0..n. That is the same node set and the same interpolant as the page's n-node formula.

---

### 3. Implementation checks: `chebyshev_animations_all.jl`

**Is it the method it claims to be?** Yes. It interpolates at the n mapped first-kind Chebyshev points (line 97), using the barycentric formula with weights w_j = 1/∏_{k≠j}(x_j−x_k) (lines 108–118). Outside the node hull it uses the first ("modified Lagrange") form, l(x)·Σ w_j y_j/(x−x_j) (lines 130–133), and inside it uses the second form. Both are exact representations of the same unique interpolating polynomial. This is the "Chebyshev approximation polynomial" in Mathews' sense: interpolation at Chebyshev nodes, which he also writes as Σ c_j T_j. The trimming fallback in `chebyshev_nodes` (lines 89–104) could silently shrink the interval, but it never activates: `trimmed=false` for all 294 (case, n) pairs.

**Are the numbers right?** I instrumented a copy (`review/lib.jl` + `review/dump.jl`) and dumped the script's interpolant on its 1000-point plot grid for every case and every n: 294 (case, n) pairs, 294,000 values. Separately, `review/indep.py` computes the interpolant in a different way: in 50-digit mpmath it computes the Chebyshev coefficients c_0 = (1/n)Σf(x_k) and c_j = (2/n)Σf(x_k)T_j(t_k), then evaluates Σc_jT_j(t) at every 7th grid point. Results over all 294 pairs:
- max relative difference on the approximation interval: **2.8e-15**
- max relative difference anywhere in the window, including extrapolation, for |p| < 1e6: **5.7e-11** (case 29, n=16, far extrapolation, off-screen)
- the interpolant reproduces f at every node: max \|p(x_k) − f(x_k)\| = 0 (instrumented `maxnodeerr`)
- degree property for even f and even n (A5): leading coefficient ≤ 5e-40

**Are the reference values right?** The magenta f(x) curve is the true function. For all 29 cases, I compared the script's f values at every 7th grid point with mpmath (sqrt, log, tan, cosh, atan, asin, besselj, bessely, gamma, erf, and so on). The max relative difference is **2.3e-13**. The caption names normal_pdf and normal_cdf are implemented correctly as exp(−x²/2)/√(2π) and ½+½erf(x/√2).

**Does the picture show what was computed?**
- **Elements:** red nodes = (x_k, f(x_k)), blue = interpolant, magenta = f. This holds in the frames for every case (last frames `review/last_0…7.png`; full sheets viewed for cases 08, 14 and 24).
- **Titles:** each title shows the right case id, function label, node interval, n and degree bound.
- **Display devices:**
  - (a) The y-window comes from quantiles of f, widened to contain f on the node interval. The interpolant is clamped only to a band one window-height beyond the limits, so where it leaves the frame it runs off the edge instead of sliding along it. It is never drawn on the frame edge as if that were its value.
  - (b) For poles: cases 01, 02 and 14 insert NaN at the pole, so f's branches are not joined. In case 03 both branches of 1/(1−x)² are positive, so the clamped join lies off-screen (band top 54.6 > ylim 26.3). Cases 07 and 09–11 get NaN from the domain error or −Inf. In gamma (24–26) and bessely (27–29), x=0 is an exact grid point that evaluates to NaN (`nNaN_true=1`), which breaks the curve. The frames show no spurious vertical connector across x=0 in cases 24–26. This works only because x=0 happens to be a grid point, but that is the case and the effect is correct.
  - (c) The interpolant visibly blows up outside the node interval where the window is wider (cases 01–11, 14, 19, 24–29). This is real extrapolation of the computed polynomial, labelled by the interval in the title, and it matches Mathews' presentation.
  - (d) Frame counts are 10, or 14 for case 08, matching the node sequences.
- **Unused code:** the `xs_lo`/`y_lo`/`xs_hi`/`y_hi` computations in `render_case` (lines 211–217) are dead code with no effect on output. This is not a finding.

