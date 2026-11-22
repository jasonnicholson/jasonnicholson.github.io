# Chebyshev Approximation Polynomial — animation review (round 4)

Page: `pages/numerical-methods/chebyshev-approximation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every case-table row, every caption, every GIF title and every checkable sentence on the page agreed with an independent computation or with the frames. Totals: Error 0, Misleading 0, Minor 0.

These were looked at and are **not** findings:

- **Case 12/13 caption vs GIF title.** The caption says "interval [-3pi, 3pi]" and the GIF title says "[-9.425, 9.425]". The two agree, since 3π = 9.42478.
- **Silent interval trim in `chebyshev_nodes`.** At lines 89-104, if f is non-finite at a node, the function shrinks the interval by 1 % steps. It would then draw nodes on a narrower interval than the title states. I instrumented every (case, n) pair: the trim never fires (attempt index 0 for all 294 node sets). It is a latent hazard only.
- **Legacy "Convergence Regions" overlay.** The legacy GIFs show tolerance bands (±0.05 / ±0.001) and a yellow "convergence region" bar that the page does not have. This is content the page does not yet have. The standard excludes that.
- **Legacy node counts.** The legacy animations step through degrees S_2, S_3, S_5, … S_13/S_14. The page uses n = 2…16 nodes. The difference is not material.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `chebyshev_animations_all.jl` | 0 | 43.1 | 29 GIFs (cheby01.gif … cheby29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Chebyshev-node interpolation uses clustered nodes near interval endpoints to reduce oscillation compared with equally spaced interpolation at the same degree." | Case 08 function on [-1,1], max error from my mpmath barycentric interpolation: n=16, equispaced 4.85e-1 vs Chebyshev 1.38e-2; n=32, equispaced 1.40e+1 vs Chebyshev 9.47e-5. Nodes in every frame cluster at the ends. | confirmed |
| D2 | "…a standard remedy for Runge-type endpoint blow-up." | Same numbers as D1. Case 08 frames converge inside [-1,1]. | confirmed |
| D3 | "$n$ Chebyshev nodes are the mapped roots $x_k=\frac{a+b}{2}+\frac{b-a}{2}\cos\frac{(2k-1)\pi}{2n}$, k=1..n" | T_n(cos θ)=cos nθ = 0 at θ=(2k-1)π/(2n). Script line 97 uses the same formula. Script nodes vs my mpmath nodes: max diff ≤ 3.6e-15 over all cases (table in §3). | confirmed |
| A1 | "Each animation steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes" | Instrumented `node_count_sequence` gives exactly that for max_order=15. Manifest: 10 frames in each GIF except 08. Titles in the frames read n = 2…16. | confirmed |
| A2 | "(case 08 continues to 20, 24, 28 and 32)" | seq=[2,…,16,20,24,28,32], 14 frames. frame_014 title reads "n = 32 nodes, degree ≤ 31". | confirmed |
| A3 | "for a fixed function and approximation interval" | Per case, span and f are constant across frames. Titles show the same interval in every frame (all 29 contact sheets read). | confirmed |
| A4 | "With $n$ nodes the interpolant has degree at most $n-1$" | n points determine a unique polynomial of degree ≤ n-1. The script's values equal the degree-(n-1) Chebyshev sum to ~1e-15. | confirmed |
| A5 | "for an even function on a symmetric interval and even $n$ it is at most $n-2$" | Leading Chebyshev coefficient c_{n-1} for cases 08, 13, 17, 20, 22 at even n = 2…16 is ≤ 2e-39 in 40-digit arithmetic, while c_{n-2} is O(1e-7…10). Case 08/17/20/22 frames at n=2 show a horizontal line (degree 0). | confirmed |
| A6 | "[Julia source for all cases](chebyshev_animations_all.jl)" | The file exists. It produces all 29 GIFs, byte-identical to the committed ones (manifest). | confirmed |
| C01 | Case 01: f(x)=1/(1-x), interval [-1.6, 0.9] | Row 28: `1/(1-x)`, span (-1.6,0.9). Title matches. Values verified (§3). | confirmed |
| C02 | Case 02: f(x)=1/(1+x), interval [-0.9, 1.5] | Row 29. Title matches. Legacy GIF Chebyshev02 shows the same interval (green lines ≈ -0.9, 1.5). | confirmed |
| C03 | Case 03: f(x)=1/(1-x)^2, interval [-1.5, 0.8] | Row 30. Title matches. Legacy GIF Chebyshev03 shows [-1.5, 0.8]. | confirmed |
| C04 | Case 04: sqrt(x), [0, 2] | Row 31. Title matches. Legacy text "[0, 2]". | confirmed |
| C05 | Case 05: sqrt(x), [0, 8] | Row 32. Title matches. Legacy "[0, 8]". | confirmed |
| C06 | Case 06: sqrt(x), [0, 10] | Row 33. Title matches. Legacy "[0, 10]". | confirmed |
| C07 | Case 07: 1/sqrt(1-x), [-1.5, 0.95] | Row 34. Title matches. | confirmed |
| C08 | Case 08: 1/(1+10x^2), [-1, 1], up to 32 nodes | Row 35, max_order=31. Title matches. Legacy "[-1, 1]". | confirmed |
| C09 | Case 09: log(x), [0.02, 2] | Row 36. Title matches. Legacy "[0.02, 2]". | confirmed |
| C10 | Case 10: log(x), [0.02, 4] | Row 37. Title matches. Legacy "[0.02, 4]". | confirmed |
| C11 | Case 11: log(1+x), [-0.98, 1] | Row 38. Title matches. Legacy "[-0.98, 1]". | confirmed |
| C12 | Case 12: sin(x), [-3pi, 3pi] | Row 39, auto_span gives (-9.42478, 9.42478). Title "[-9.425, 9.425]". Legacy GIF uses the full window. | confirmed |
| C13 | Case 13: cos(x), [-3pi, 3pi] | Row 40, same as C12. | confirmed |
| C14 | Case 14: tan(x), approximation interval [-1.45, 1.45] "inside singularities" | Row 41. Title matches. ±1.45 < π/2 = 1.5708, and poles ±π/2 are NaN-broken in the frames. | confirmed |
| C15 | Case 15: exp(x), [-2, 3] | Row 42, auto_span = (-2,3). Title matches. Legacy GIF Chebyshev15 has nodes on the full [-2,3]. | confirmed |
| C16 | Case 16: cos(x)*exp(-x), [-2, 4] | Row 43. Title matches. | confirmed |
| C17 | Case 17: cosh(x), [-4, 4] | Row 44. Title matches. | confirmed |
| C18 | Case 18: atan(x), [-2.2, 2.2] | Row 45. Title matches. | confirmed |
| C19 | Case 19: asin(x), [-1, 1] | Row 46. Title matches. | confirmed |
| C20 | Case 20: besselj(0,x), [-10.2, 10.2] | Row 47. Title matches. mpmath J0 agrees with node values (rel ≤ 1.1e-16). | confirmed |
| C21 | Case 21: besselj(1,x), [-10.2, 10.2] | Row 48. Title matches. | confirmed |
| C22 | Case 22: normal_pdf(x), [-3, 3] | Row 49: exp(-x²/2)/√(2π). Title matches. Legacy formula is identical. | confirmed |
| C23 | Case 23: normal_cdf(x), [-3, 3] | Row 50: ½+½erf(x/√2). Title matches. Legacy formula is identical. | confirmed |
| C24 | Case 24: gamma(x), [0.05, 2] | Row 51. Title matches. Legacy "[0.05, 2]". | confirmed |
| C25 | Case 25: gamma(x), [0.05, 4] | Row 52. Title matches. Legacy "[0.05, 4]". | confirmed |
| C26 | Case 26: gamma(x), [0.5, 5] | Row 53. Title matches. Legacy "[0.5, 5]". | confirmed |
| C27 | Case 27: bessely(0,x), [0.5, 20] | Row 54. Title matches. Legacy "[0.5, 20]". | confirmed |
| C28 | Case 28: bessely(0,x), [0.5, 10] | Row 55. Title matches. Legacy "[0.5, 10]". | confirmed |
| C29 | Case 29: bessely(0,x), [0.5, 4] | Row 56. Title matches. Legacy "[0.5, 4]". | confirmed |
| W | Wiring: heading "Case NN" embeds `chebyNN.gif` | Every embed number equals its heading number, and the GIF title reads "Chebyshev Case NN" (all 29 contact sheets). | confirmed |
| L | Legend: magenta f(x), blue interpolant, red nodes | Plot code lines 252-254. The frames show the same. | confirmed |

### 3. Implementation checks (`chebyshev_animations_all.jl`)

**What it is.** The script draws n Chebyshev points of the first kind (roots of T_n) mapped to [a,b]. It interpolates f there with barycentric Lagrange interpolation (`barycentric_weights`, `barycentric_eval`). Outside the node hull it uses the first barycentric form. This is the same polynomial as Mathews' "Chebyshev approximation polynomial" P_{n-1}(x)=Σ c_j T_j(t), with c_0=(1/n)Σf(x_k) and c_j=(2/n)Σf(x_k)cos(j(2k+1)π/(2n)), from the legacy module's algorithm. The script computes it in Lagrange/barycentric form rather than the Chebyshev-coefficient form; this is a legitimate variant. The page's Description presents it as Chebyshev-node interpolation, which is accurate.

**Numbers are right.** I instrumented a copy (`review/inst.jl`; it dumps nodes, f(nodes) and interpolant values) and compared it with an independent 40-digit mpmath computation (`review/indep.py`). That computation uses Mathews' c_j formula, Clenshaw evaluation, the page-caption intervals and mpmath's own special functions. It covers every case and every n, at 41 points across the span and 21 across the plot window:

| case | max node diff | max rel f(node) diff | max rel interp diff in span | outside span |
|---|---|---|---|---|
| 01 | 3.3e-16 | 1.5e-16 | 8.7e-16 | 1.3e-14 |
| 02 | 3.9e-16 | 2.1e-16 | 1.1e-15 | 1.9e-14 |
| 03 | 4.4e-16 | 2.2e-16 | 2.3e-15 | 1.6e-14 |
| 04 | 2.8e-16 | 0 | 5.9e-16 | 8.7e-13 |
| 05 | 1.1e-15 | 0 | 5.9e-16 | 8.7e-13 |
| 06 | 1.8e-15 | 0 | 7.5e-16 | 1.5e-14 |
| 07 | 4.4e-16 | 2.2e-16 | 6.7e-16 | 2.5e-14 |
| 08 | 2.8e-16 | 1.1e-16 | 6.4e-16 | 3.3e-12 |
| 09 | 3.3e-16 | 0 | 1.1e-15 | 2.3e-14 |
| 10 | 8.9e-16 | 2.8e-17 | 1.1e-15 | 6.5e-15 |
| 11 | 2.8e-16 | 1.1e-16 | 7.7e-16 | 6.1e-14 |
| 12 | 2.7e-15 | 1.4e-17 | 4.0e-15 | (none) |
| 13 | 2.7e-15 | 1.1e-16 | 2.6e-15 | (none) |
| 14 | 4.4e-16 | 1.9e-16 | 6.7e-16 | 1.7e-14 |
| 15 | 7.2e-16 | 2.8e-17 | 9.9e-16 | (none) |
| 16 | 9.2e-16 | 1.9e-16 | 1.4e-15 | (none) |
| 17 | 1.1e-15 | 2.1e-16 | 1.1e-15 | (none) |
| 18 | 6.7e-16 | 2.1e-16 | 5.8e-16 | (none) |
| 19 | 2.8e-16 | 2.0e-16 | 6.9e-16 | 3.6e-14 |
| 20 | 2.9e-15 | 1.1e-16 | 1.0e-15 | (none) |
| 21 | 2.9e-15 | 1.1e-16 | 9.9e-16 | (none) |
| 22 | 8.9e-16 | 5.6e-17 | 2.0e-16 | (none) |
| 23 | 8.9e-16 | 1.1e-16 | 4.2e-16 | (none) |
| 24 | 2.2e-16 | 2.1e-16 | 1.8e-15 | 1.4e-14 |
| 25 | 4.4e-16 | 1.2e-16 | 2.7e-15 | 3.8e-14 |
| 26 | 8.9e-16 | 1.6e-16 | 1.6e-15 | 8.0e-13 |
| 27 | 3.6e-15 | 1.7e-16 | 1.5e-15 | 3.4e-14 |
| 28 | 1.8e-15 | 1.1e-16 | 9.1e-16 | 1.2e-12 |
| 29 | 4.4e-16 | 1.1e-16 | 4.2e-16 | 4.6e-11 |

"(none)" means the span equals the plot window, so there are no points outside it. Commands: `julia review/inst.jl`, then `python3 -I review/indep.py review/dump.tsv`. Because the script's interpolant equals an independently coded Chebyshev series to rounding, both the formulation and the special functions (gamma, J0, J1, Y0, erf) are confirmed. A property check (`review/props.py`) gives the even-function result: the leading coefficient vanishes, ≤ 2e-39 in 40-digit arithmetic. It also gives the Runge comparison numbers in the ledger (D1).

**Reference values.** The only "reference" is f itself (magenta). Its 29 definitions match the legacy formula images exactly (`review/legacy_formulas.png`), and its values match mpmath (column 2 above).

**Picture shows what was computed.** I read all 29 contact sheets. I also read cheby08 frame_014 and zoomed into cheby24 frame_010 near x=0 (`review/c24_zoom.png`).
- Nodes sit on f in every frame, and the interpolant passes through them.
- Titles report the right case id, function, interval, n and degree bound.
- Display devices:
  - The y-window comes from f; nodes are always inside it. Example: case 09, log(0.0219) = -3.82 against a lower limit of -4.20.
  - The interpolant is clamped one window-height beyond the limits, so it runs off the frame rather than along an edge.
  - Poles in cases 01, 02 and 14 are NaN-broken.
  - Case 03's pole at x=1 has both branches going to +∞, so no false joining segment appears.
  - The gamma pole at x=0 (cases 24-26) is broken because the 1000-point grid hits x=0.0 exactly and gamma(0.0)=Inf becomes NaN. Checked: grid points -0.0054, 0.0, 0.0054 give -185.6, Inf, 184.4. The zoom confirms there is no vertical connector.
- None of these change what a viewer would conclude.
- Interval-trim fallback: never triggered (attempt=0 for every (case, n)).

### Legacy archive

Consulted:
- `n2003/ChebyshevPolyMod.html` (method and algorithm: Lagrange–Chebyshev approximation, c_j formulas, Examples 1-18)
- `a2001/Animations/Interpolation/Chebyshev/Chebyshev.html`, the 29-animation index the page mirrors. Its formula images were rendered to `review/legacy_formulas.png`.
- The 12 legacy animation GIFs that exist (02, 03, 04, 06, 10, 12, 15, 24, 26, 27, 28, 29), extracted to `review/legacy/`.

Results:
- All 29 legacy cases are present, in order.
- Functions and plot windows match on every row.
- Node intervals match on every row where the legacy states them or shows them (02, 03, 04, 05, 06, 08, 09, 10, 11, 12, 15, 24–29).
- For cases 01, 07, 13, 14 and 16–23 the legacy page gives only the plot window, and no legacy GIF survives for those cases. I could not determine Mathews' node interval there. The page's choices are mathematically valid: full window for entire functions, which matches the legacy convention seen in 12 and 15; avoiding the singularity for 01, 07 and 14; [-1,1] for asin.

No fidelity findings.

