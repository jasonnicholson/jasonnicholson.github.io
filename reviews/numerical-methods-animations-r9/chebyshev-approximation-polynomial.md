# Chebyshev Approximation Polynomial — animation review (round 9)

Page: `pages/numerical-methods/chebyshev-approximation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No Error, Misleading or Minor findings.

Every checkable claim on the page was confirmed by computation or frames (ledger below). The case table agrees row by row with the headings, the alt-text captions, the GIF titles and the legacy archive.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `chebyshev_animations_all.jl` | 0 | 62.2 | 29 GIFs (cheby01.gif … cheby29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Chebyshev-node interpolation uses clustered nodes near interval endpoints to reduce oscillation compared with equally spaced interpolation at the same degree" | General fact. Spot check on case 08's function, max error on [-1,1]: equispaced vs Chebyshev at n=12: 0.236 vs 0.0478; n=16: 0.485 vs 0.0138; n=32: 14.0 vs 9.5e-5 (scipy) | confirmed |
| D2 | "...a standard remedy for Runge-type endpoint blow-up" | Same computation. Case 08 Chebyshev error falls from 0.0138 (n=16) to 9.46e-5 (n=32) | confirmed |
| D3 | Node formula `x_k = (a+b)/2 + (b-a)/2 cos((2k-1)π/(2n))`, k=1..n | Script line 97 is the same formula. Nodes dumped from the script agree with mpmath nodes to ≤ 3.6e-15 (all cases, all n). Trimming loop (lines 89-104) never fires (`trimmed=false` for all 29 cases) | confirmed |
| D4 | Page title "Chebyshev Approximation Polynomial" = interpolation at Chebyshev nodes | Mathews' algorithm (n2003 module: coefficients c_j from f at the Chebyshev nodes) gives the same polynomial. My Mathews-coefficient implementation agrees with the script's barycentric interpolant to ≤ 3.6e-15 of window height everywhere on the plotting grid | confirmed |
| A1 | "Each animation steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes" | `node_count_sequence(15)` = 2,3,4,5,6,8,10,12,14,16. 10 frames in each of 28 GIFs (manifest). Titles in the case 13 contact sheet and the first and last frames of all cases show the sequence | confirmed |
| A2 | "(case 08 continues to 20, 24, 28 and 32)" | max_order=31, so the sequence is base + 20,24,28,32. 14 frames. Contact-sheet titles show n=20, 28; the last frame shows n=32 | confirmed |
| A3 | "With n nodes the interpolant has degree at most n−1" | n data points, polynomial-reproduction test passes for degree n−1 (max rel err ≤ 1.8e-15 for all cases and n). GIF titles say "degree ≤ n−1" | confirmed |
| A4 | "for an even function on a symmetric interval and even n it is at most n−2" | The interpolant is even (symmetric nodes), so odd coefficients vanish. Numerical check on cases 08, 13, 17, 20, 22 for n=2..16: \|c_{n−1}\| ≤ 4.4e-14 while \|c_{n−2}\| is O(1e-7–10). The n=2 frames of 08/13/17/20/22 show a horizontal line | confirmed |
| A5 | "Green dashed vertical lines mark the ends of the approximation interval" | `vline!(collect(span))`, green dash. Frames show them at the interval ends in every case | confirmed |
| A6 | "Outside them the blue curve is extrapolation and can leave the frame" | Nodes lie strictly inside the span. The interpolant is clamped only to a band one window height beyond the limits, so it runs off the frame (e.g. last frames of 04, 09, 11, 24, 25, 28, 29) | confirmed |
| A7 | "with 8 or fewer nodes its overshoot can also leave the frame inside the interval (cases 08, 12, 13, 22, 23 and 27)" | Over all 29 cases × all n, I compared the exact interpolant on grid points inside [a,b] against the script's y-limits. It leaves the frame only for 08 (n=3), 12 (n=8), 13 (n=5, 6), 22 (n=3), 23 (n=2) and 27 (n=8). The list is exact and complete, and every n is ≤ 8 | confirmed |
| A8 | Source link "Julia source for all cases" → `chebyshev_animations_all.jl` | The file exists. It is the only script, and it produced all 29 GIFs (byte-identical regeneration per manifest) | confirmed |
| C01 | Case 01: f=1/(1−x), [−1.6, 0.9]; embed cheby01.gif | Table row 28, GIF title "1/(1-x)", "[-1.6, 0.9]" | confirmed |
| C02 | Case 02: 1/(1+x), [−0.9, 1.5] | row 29; title matches | confirmed |
| C03 | Case 03: 1/(1−x)^2, [−1.5, 0.8] | row 30; title matches | confirmed |
| C04 | Case 04: sqrt(x), [0, 2] | row 31; title matches | confirmed |
| C05 | Case 05: sqrt(x), [0, 8] | row 32; title matches | confirmed |
| C06 | Case 06: sqrt(x), [0, 10] | row 33; title matches | confirmed |
| C07 | Case 07: 1/sqrt(1−x), [−1.5, 0.95] | row 34; title matches | confirmed |
| C08 | Case 08: 1/(1+10x^2), [−1, 1], up to 32 nodes | row 35, max_order 31; last-frame title n=32, degree ≤ 31 | confirmed |
| C09 | Case 09: log(x), [0.02, 2] | row 36; title matches | confirmed |
| C10 | Case 10: log(x), [0.02, 4] | row 37; title matches | confirmed |
| C11 | Case 11: log(1+x), [−0.98, 1] | row 38; title matches | confirmed |
| C12 | Case 12: sin(x), [−3π, 3π] | auto_span over xlims (−3π, 3π). finite_support returns the grid ends = ±9.42477796 = ±3π. Title "[-9.425, 9.425]" | confirmed |
| C13 | Case 13: cos(x), [−3π, 3π] | as C12 | confirmed |
| C14 | Case 14: tan(x), approximation interval [−1.45, 1.45] inside singularities | row 41. Poles ±π/2 = ±1.5708 lie outside the span. Title matches | confirmed |
| C15 | Case 15: exp(x), [−2, 3] | auto_span = xlims exactly (dumped span −2.0, 3.0); title | confirmed |
| C16 | Case 16: cos(x)*exp(−x), [−2, 4] | span (−2, 4); title | confirmed |
| C17 | Case 17: cosh(x), [−4, 4] | span (−4, 4); title | confirmed |
| C18 | Case 18: atan(x), [−2.2, 2.2] | span; title | confirmed |
| C19 | Case 19: asin(x), [−1, 1] | row 46; title | confirmed |
| C20 | Case 20: besselj(0,x), [−10.2, 10.2] | span; title. Node values agree with mpmath besselj | confirmed |
| C21 | Case 21: besselj(1,x), [−10.2, 10.2] | span; title | confirmed |
| C22 | Case 22: normal_pdf(x), [−3, 3] | code exp(−x²/2)/√(2π); span; title | confirmed |
| C23 | Case 23: normal_cdf(x), [−3, 3] | code 0.5+0.5 erf(x/√2); span; title | confirmed |
| C24 | Case 24: gamma(x), [0.05, 2] | row 51; title | confirmed |
| C25 | Case 25: gamma(x), [0.05, 4] | row 52; title | confirmed |
| C26 | Case 26: gamma(x), [0.05, 5] | row 53; title | confirmed |
| C27 | Case 27: bessely(0,x), [0.5, 20] | row 54; title; node values agree with mpmath bessely | confirmed |
| C28 | Case 28: bessely(0,x), [0.5, 10] | row 55; title | confirmed |
| C29 | Case 29: bessely(0,x), [0.5, 4] | row 56; title | confirmed |
| W | Each "### Case NN" heading embeds `chebyNN.gif` with matching NN | index.qmd lines 26-140. The GIF title "Chebyshev Case NN" matches the heading in all 29 (first and last frame montages) | confirmed |

### 3. Implementation checks (`chebyshev_animations_all.jl`)

**Method.** Polynomial interpolation at the n mapped Chebyshev roots (zeros of T_n), evaluated with the second (true) barycentric form inside the node hull and the first (modified Lagrange) form outside it, using explicitly computed product weights. This is the Chebyshev approximation polynomial as Mathews defines it (his coefficient formula yields the same polynomial). It is not a least-squares or truncated-series variant. The node-trimming fallback in `chebyshev_nodes` never activates for any case or n, so every node set is the exact formula on the stated interval.

**Numbers.** I compared against an independent 40-digit mpmath computation using Mathews' coefficient formula and Clenshaw evaluation (`indep_compare.tsv`, 293 case/n rows):
- Nodes: max |x_script − x_mp| = 3.6e-15. f at nodes: max relative difference 6.5e-15 (largest at case 26, n=14). This also checks Julia's gamma, besselj, bessely and erf against mpmath.
- Interpolant on the 1000-point plotting grid, after both are clamped to the script's display band: max difference 3.6e-15 of window height (case 20, n=8).
- Unclamped relative difference: max 7.8e-11 (case 29, n=16, far extrapolation where values reach ~1e10 and are clamped off-frame anyway). It is ≤ ~1e-14 inside the intervals.
- Property checks: (i) a degree-(n−1) polynomial is reproduced on each case's span for every n with max relative error ≤ 1.8e-15; (ii) the interpolant hits the data at the nodes (barycentric exact-node branch plus the agreement above); (iii) evenness gives a vanishing top coefficient (A4).
- For reference, the max |f − P| on the interval at the final n is: 01 2.8e-2, 02 2.5e-2, 03 2.2e-2, 04 4.4e-2, 05 8.8e-2, 06 9.9e-2, 07 2.3e-2, 08 1.4e-2 (n=16) / 9.5e-5 (n=32), 09 3.7e-2, 10 1.3e-1, 11 2.5e-2, 12 8.1e-4, 13 1.7e-3, 14 2.3e-2, 15 7.1e-12, 16 6.0e-9, 17 8.1e-9, 18 1.2e-4, 19 1.9e-2, 20 1.1e-3, 21 5.0e-4, 22 7.9e-6, 23 1.1e-6, 24 1.8e-1, 25 6.5e-1, 26 9.1e-1, 27 2.1e-3, 28 1.9e-4, 29 1.4e-6. The page makes no numerical error claims, so these are context only.

**Reference values.** The magenta "f(x)" curve is the target function evaluated directly with Julia library functions. The node values agree with mpmath (above), and the formula labels in titles equal the lambdas in the table, row by row.

**Picture.**
- Nodes are drawn at (x_k, f(x_k)). The interpolant is the computed polynomial, clamped only to a band one window height beyond the axis limits, so off-frame parts leave the frame rather than running along its edge.
- Green lines are at the span ends. The axis is padded by 1.5% where a span end coincides with the window edge (auto-span cases), so the line stays visible.
- Titles report the case id, the formula, the span (fmt_num to 3 decimals, e.g. ±9.425 for ±3π), n and "degree ≤ n−1", all from the loop variable. I checked the first and last frames of all 29 GIFs at full resolution, plus the contact sheets of 08 and 13.
- Poles: in cases 01, 02 and 14, f is drawn with NaN at the poles and shows no spurious connecting segment. In case 03 (pole at x=1, f positive on both sides) the clamp keeps the joining segment above the window. In gamma cases 24-26 the plotting grid hits x=0 exactly (index 38 → x=0.0, gamma=Inf → NaN), so the branches break and no connector appears (zoom `c25_zoom.png`).
- Y-limits come from quantiles of f widened to contain f over the whole span. Every node is inside the window in every frame. Nothing the page discusses falls outside the window.

**Legacy fidelity.**
- All 29 functions and plotting windows match Mathews' formula images exactly (e.g. 1/(1−x) on −1.6≤x≤1.5, Gamma on −0.2≤x≤5.2, BesselY[0,x] on 0≤x≤22).
- Node intervals stated in the legacy index ([0,2], [0,8], [0,10], [−1,1], [0.02,2], [0.02,4], [−0.98,1], [0.05,2], [0.05,4], [0.5,20], [0.5,10], [0.5,4]) all match the page. For case 26 the legacy text says "[0.5, 5]", but the legacy GIF's left interval line and first node sit at x≈0.05 (y≈18–19, and Γ(0.05)=19.47 while Γ(0.5)=1.77), so the page's [0.05, 5] follows the legacy animation and the legacy text is a typo.
- Legacy GIFs for 02 ([−0.9, 1.5]), 03 ([−1.5, 0.8]), 12 and 15 (full window) agree with the page.
- Could not determine from the archive the intended node intervals for cases 01, 07, 13, 14 and 16–23, because there is no stated interval and no legacy GIF. The page's choices are self-consistent and stated.
- Mathews' animations run to higher degrees in some cases (up to S_25 for gamma) and overlay tolerance bands. The page caps at 16 nodes and does not claim tolerance convergence. This is content the page does not have, so it is not a finding.

