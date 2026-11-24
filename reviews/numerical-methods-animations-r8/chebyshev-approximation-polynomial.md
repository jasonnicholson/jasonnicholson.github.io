# Chebyshev Approximation Polynomial — animation review (round 8)

Page: `pages/numerical-methods/chebyshev-approximation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Counts: Error 0, Misleading 0, Minor 0.

Notes that are not findings:
- The legacy index text for case 26 says "nodes in [0.5, 5]", but the legacy GIF `Chebyshev26/Chebyshevzz.gif` draws its left interval line and first node just right of x = 0 (Γ ≈ 17 at the first node), i.e. [0.05, 5]. The page's [0.05, 5] follows the legacy animation; the archive text is a typo.
- The legacy animations go to different maximum degrees per case (e.g. S25 for Γ, S13 for 1/(1+x)) and label by degree S_n (n+1 nodes); the page uses a uniform 2…16-node sequence (32 for case 08) and labels by node count. This is a presentation choice that the page states explicitly; not a reader-relevant departure.
- The Description gives only the node formula, not Mathews' T_j-series form P(x)=Σ c_j T_j(x). The script's barycentric Lagrange form is the same polynomial (verified numerically below); omitted content is not a finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `chebyshev_animations_all.jl` | 0 | 45.2 | 29 GIFs (cheby01.gif … cheby29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | "Chebyshev-node interpolation uses clustered nodes near interval endpoints to reduce oscillation compared with equally spaced interpolation" / "standard remedy for Runge-type endpoint blow-up" | General result; consistent with case 08 (Runge function 1/(1+10x²)): max error on [-1,1] falls 0.83 → 9.5e-5 from n=2 to n=32, monotone after n=6 (instr_out.tsv) | confirmed |
| D2 | $x_k = \frac{a+b}{2} + \frac{b-a}{2}\cos\frac{(2k-1)\pi}{2n}$, k=1..n | Script line 97 uses exactly this; my independent nodes agree with the script's to 3.6e-15 over all 294 (case, n) pairs | confirmed |
| A1 | "Each animation steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes" | `node_count_sequence(15)` = [2,3,4,5,6,8,10,12,14,16]; 10 frames per GIF (manifest); frame titles read n=2…16 | confirmed |
| A2 | "case 08 continues to 20, 24, 28 and 32" | `max_order=31` → [..,16,20,24,28,32]; cheby08.gif has 14 frames; titles n=20, 28 seen on sheet | confirmed |
| A3 | "for a fixed function and approximation interval" | span fixed per case; no node-interval trimming ever triggered (trim attempt 0 for all 294 pairs) | confirmed |
| A4 | "With n nodes the interpolant has degree at most n−1" | Interpolant through n points; titles print "degree ≤ n−1" | confirmed |
| A5 | "for an even function on a symmetric interval and even n it is at most n−2" | Even/symmetric cases 08, 13, 17, 20, 22: Chebyshev coefficient c_{n−1} for even n has max magnitude 2e-39 (mpmath); case 13 n=2 frame shows a constant | confirmed |
| A6 | "Green dashed vertical lines mark the ends of the approximation interval" | `vline!(collect(span); color=:green, ls=:dash)`; frames | confirmed |
| A7 | "Outside them the blue curve is extrapolation and can leave the frame" | Interpolant drawn over whole xlims; clamped only to a band one window-height beyond ylims; e.g. case 24 frames run off bottom right of x=2 | confirmed |
| A8 | "with 8 or fewer nodes its overshoot can also leave the frame inside the interval (cases 08, 12, 13, 22, 23 and 27)" | Interpolant on plot grid inside span vs ylims: leaves window only for 08 (n=3), 12 (n=8), 13 (n=5,6), 22 (n=3), 23 (n=2), 27 (n=8); no other case, no n>8 | confirmed (exact set) |
| A9 | Source link `chebyshev_animations_all.jl` | file exists, produces all 29 GIFs | confirmed |
| C01 | f=1/(1−x), interval [-1.6, 0.9] | row 01; title "1/(1-x)", "[-1.6, 0.9]"; window matches legacy (−1.6..1.5) | confirmed |
| C02 | f=1/(1+x), [-0.9, 1.5] | row 02; title; legacy GIF interval lines at −0.9 and 1.5 | confirmed |
| C03 | f=1/(1−x)^2, [-1.5, 0.8] | row 03; title; legacy GIF interval −1.5..0.8 | confirmed |
| C04 | sqrt(x), [0, 2] | row 04; title; legacy text [0,2] | confirmed |
| C05 | sqrt(x), [0, 8] | row 05; title; legacy text [0,8] | confirmed |
| C06 | sqrt(x), [0, 10] | row 06; title; legacy text [0,10] | confirmed |
| C07 | 1/sqrt(1−x), [-1.5, 0.95] | row 07; title; legacy gives only window (−1.6..1.5), no GIF | confirmed vs script/GIF; legacy interval could not determine (no legacy GIF) |
| C08 | 1/(1+10x^2), [-1, 1], up to 32 nodes | row 08 (max_order 31); title; legacy text [-1,1] | confirmed |
| C09 | log(x), [0.02, 2] | row 09; title; legacy text | confirmed |
| C10 | log(x), [0.02, 4] | row 10; title; legacy text | confirmed |
| C11 | log(1+x), [-0.98, 1] | row 11; title; legacy text | confirmed |
| C12 | sin(x), [-3pi, 3pi] | auto span = finite support on grid = xlims (−3π, 3π); title "[-9.425, 9.425]"; legacy GIF interval = full window | confirmed |
| C13 | cos(x), [-3pi, 3pi] | as C12 | confirmed (legacy interval: no GIF, window matches) |
| C14 | tan(x), [-1.45, 1.45] inside singularities | row 14; 1.45 < π/2 = 1.5708; poles drawn as breaks | confirmed |
| C15 | exp(x), [-2, 3] | auto span = xlims; legacy GIF interval = full window | confirmed |
| C16 | cos(x)*exp(−x), [-2, 4] | auto span = xlims (−2, 4) | confirmed |
| C17 | cosh(x), [-4, 4] | auto span | confirmed |
| C18 | atan(x), [-2.2, 2.2] | auto span | confirmed |
| C19 | asin(x), [-1, 1] | row 19; title | confirmed |
| C20 | besselj(0,x), [-10.2, 10.2] | auto span | confirmed |
| C21 | besselj(1,x), [-10.2, 10.2] | auto span | confirmed |
| C22 | normal_pdf(x), [-3, 3] | auto span; f = exp(−x²/2)/√(2π) matches legacy formula | confirmed |
| C23 | normal_cdf(x), [-3, 3] | auto span; f = ½+½erf(x/√2) matches legacy formula; mpmath ncdf agrees to 2.2e-16 | confirmed |
| C24 | gamma(x), [0.05, 2] | row 24; title; legacy text | confirmed |
| C25 | gamma(x), [0.05, 4] | row 25; title; legacy text | confirmed |
| C26 | gamma(x), [0.05, 5] | row 26; title; legacy GIF shows 0.05 (legacy text "0.5" is a typo) | confirmed |
| C27 | bessely(0,x), [0.5, 20] | row 27; title; legacy text | confirmed |
| C28 | bessely(0,x), [0.5, 10] | row 28; title; legacy text | confirmed |
| C29 | bessely(0,x), [0.5, 4] | row 29; title; legacy text | confirmed |
| W | Each embed `chebyNN.gif` is case NN | GIF title of every sheet reads "Chebyshev Case NN"; out_name = "cheby$(id).gif" | confirmed |

All 29 rows' lambdas match their `formula_label`, and every function/plot window matches the legacy formula/window images (`archive_formulas_*.png`).

### 3. Implementation checks (`chebyshev_animations_all.jl`)

**Method.** Interpolation at the n mapped roots of T_n (lines 86–106), evaluated by barycentric Lagrange formulas (second form inside the node range, first form l(x)Σw_j y_j/(x−x_j) for extrapolation). This is the polynomial Mathews calls the Chebyshev approximation polynomial (Lagrange–Chebyshev). The trimming fallback in `chebyshev_nodes` (shrink interval 1% per attempt if f is non-finite at a node) never fires: attempt 0 succeeds for all 294 (case, n) pairs, so titles and green lines show the interval actually used.

**Numbers.** `python3 indep.py`: over 294 (case, n) pairs, nodes agree to 3.6e-15, node values to 2.2e-16 (relative), and the script's interpolant at 28 sample points spanning the full plot window (including extrapolation) agrees with the mpmath Chebyshev-series polynomial to 5.4e-11 relative. Interpolation property: script reproduces node values exactly (residual 0). Even-symmetry property: |c_{n−1}| ≤ 2e-39 for even n in cases 08, 13, 17, 20, 22. Error behaviour on the interval (script vs f on plot grid), final frame: e.g. 15 exp 7.1e-12, 16 6.0e-9, 17 8.1e-9, 08 9.5e-5 (n=32), slow algebraic decay for singular-endpoint cases (04–06 sqrt: 0.044/0.088/0.099; 24–26 gamma: 0.18/0.65/0.91) — consistent with theory; the page makes no numeric error claims.

**Reference values.** f is drawn from the same closed-form functions (Julia Base / SpecialFunctions); checked against mpmath at all node points (max rel diff 2.2e-16). No other reference values.

**Picture.** Inspected contact sheets for 01, 03, 08, 13, 14, 19, 23, 24, 27 and the full final frame of 26. Titles report the right case, function, interval and n; nodes lie on f; interpolant passes through nodes; green lines at the interval ends. Display devices: y-window from 3–97% quantiles of f widened to contain f on the interval; curves clamped to a band one window-height outside, so they run off-frame rather than along the edge. Poles: 01, 02, 14 break f with NaN at the poles; case 03's pole at x=1 joins only above the window (invisible); cases 24–26 have grid point x=0.0 exactly, where Γ(0)=Inf → NaN, so f breaks at its pole with no connecting line (checked: grid value at x=0.0 is Inf, next is Γ(0.0054)=184.4). 07, 09–11, 19, 27–29 return NaN outside the domain. None of these changes what a viewer would conclude.

