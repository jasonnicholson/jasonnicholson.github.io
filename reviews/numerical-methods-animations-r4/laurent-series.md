# Laurent Series — animation review (round 4)

Page: `pages/numerical-methods/laurent-series/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, no Misleading item and no Minor item.

Observations I looked at and decided were not findings:

- **The f curve draws vertical segments across poles.** In case 12 (`tan`, at x = ±π/2) and cases 22–24 (`Γ`, at x ≈ 0), the magenta f curve has a near-vertical segment across the whole window. This is Plots joining two grid samples of opposite sign on either side of a pole (`safe_eval` returns finite values on both sides). Readers will see it as the usual asymptote line. Nothing on the page depends on it, so it is not a finding. If the owner wants to remove it, the fix is to set ytrue to NaN wherever |f| is much larger than the y-limits.
- **Archive.** The brief says there is no Laurent topic in `n2003`. That is true. However, `c2003/LaurentSeriesMod.html` exists: it is Mathews' complex-analysis module "7.3 Laurent Series Representations", with Examples 7.7–7.9 and an Extra Example. Its formula images are not in the archive (`c2003/laurentseries/LaurentSeriesMod/` holds only `Links/`), so I could not read its functions. It has no animations. This page was not built from that module. It reuses the Padé page's 27 cases and says so. So I do not count the missing c2003 examples as a Fidelity finding. The owner may still want to know that none of the 27 cases shows a nonzero principal part. The page says this openly, so it does not mislead.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `laurent_animations_all.jl` | 0 | 29.9 | 27 GIFs (laurent01.gif … laurent27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `laurent01.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent02.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent03.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent04.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent05.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent06.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent07.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent08.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent09.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent10.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent11.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent12.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent13.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent14.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent15.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent16.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent17.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent18.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent19.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent20.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent21.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent22.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent23.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent24.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent25.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent26.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent27.gif` | 8 | byte-identical | laurent_animations_all |

### Page references

- Scripts linked: `laurent_animations_all.jl`
- GIFs embedded: 27
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "A Laurent series ... valid in an annulus r<\|x−x0\|<R ... on which f is analytic, is f(x)=Σ_{k=−∞}^{∞} a_k (x−x0)^k" | Standard definition | confirmed |
| D2 | "Those negative-power terms form the principal part and capture pole-like behavior." | Standard | confirmed |
| D3 | "When f is analytic at x0, as it is in every case below, its Laurent series on the largest disc ... has zero principal part and is the ordinary Taylor series." | Every center is a regular point: sqrt at 1, 4, 5; 1/sqrt(1−x) at 0; log at 1, 2; log(1+x) at 0; tan at 0; Γ at 1, 2, 3; Y0 at 10, 5, 2; the rest are entire | confirmed |
| A1 | "reuses the same 27 function/interval/center cases used on the Padé page" | The `cases` table in `laurent_animations_all.jl` lines 21–47 matches the Padé script lines 24–50 row for row (f, c, xlims, ylims, order). The headings on the two pages are identical. | confirmed |
| A2 | "draws truncated series about x0 instead of rational Padé forms" | `render_case` draws `poly_eval_asc(coeffs[1:n+1], x−c)` | confirmed |
| A3 | "All 27 functions are analytic at x0, so ... a_k=0 for every k<0, and the two-sided truncation Σ_{−N}^{N} = Σ_0^N is the degree-N Taylor polynomial" | Follows from D3. The code uses only k ≥ 0. | confirmed |
| A4 | "That is what each frame draws, with N increasing frame by frame; no frame contains a negative power." | Loop `n in 1:max_order`. Legends read N = 1..10 or 1..8. Frame counts are 10 or 8, matching max_order (manifest). | confirmed |
| A5 | "Unless f is entire (cases 08–11, 13–15 and 18–21)" | sin, cos, exp, e^{−x}cos x, cosh, J0, J1, the Gaussian and erf are entire. Every other case has a finite singularity. | confirmed |
| A6 | "the series converges only within the distance from x0 to the nearest singularity ... and diverges beyond it" | Radius of convergence = distance to the nearest singularity (Cauchy–Hadamard plus analytic continuation) | confirmed |
| A7 | "every such plotted interval reaches past that distance" | R and window per case: 01 R=1, [0,10.5]; 02 R=4; 03 R=5 (to 10.5 > 10); 04 R=1, ±1.5; 05 R=1, x<0 and x>2; 06 R=2, x<0 and x>4; 07 R=1, ±1.5; 12 R=π/2, ±π; 16 R=1 (±i), ±2; 17 R=1, ±1.5; 22 R=1; 23 R=2; 24 R=3 (only [−0.2,0)); 25 R=10 (only (20,22]); 26 R=5; 27 R=2. `beyond.py` counts grid points past R and finds at least 34 in every case. | confirmed |
| A8 | "Case 03's window passes that distance only on 10<x≤10.5, and case 06's on 4<x≤4.1 and −0.5≤x<0." | \|x−5\|>5 within [0,10.5] means x>10. \|x−2\|>2 within [−0.5,4.1] means x<0 or x>4. | confirmed |
| A9 | "On 10<x≤10.5 (case 03) and 4<x≤4.1 (case 06) the ten frames do not show the divergence: the error falls from each frame to the next." | `beyond.py`/`claims.py`: on all 43 script-grid points with x>10 in case 03 and all 20 with x>4 in case 06, the error falls strictly from N=1 to N=10 | confirmed |
| A10 | "At x=10.5 in case 03 the error keeps falling until N=15" | `claims.py`: argmin of the error is N=15 (0.0231915). N=14 gives 0.0233391; N=16 gives 0.0231937. Strictly falling for N=1..15. | confirmed |
| A11 | "and at x=4.1 in case 06 until N=20" | argmin N=20 (0.0662930). N=19 and N=21 both give 0.0663719. Strictly falling for N=1..20. | confirmed |
| A12 | "after that it grows with every further term (checked to N=80)" | Strictly increasing from the argmin to N=80 at both points. At N=80 the error is 0.942 (case 03) and 0.315 (case 06). | confirmed |
| A13 | "In case 06 the divergence shows only for x<0, where log x is not real and no f curve is drawn" | `safe_eval` turns DomainError into NaN, so there is no magenta curve for x<0 (frames). On x>4 the error falls (A9). | confirmed |
| A14 | "there every term after the constant is negative" | a_k=(−1)^{k−1}/(k 2^k) and z^k=(−\|z\|)^k, so each term's sign is −1. Checked for k=1..59 at z=−2.5. | confirmed |
| A15 | "so the blue curve sinks with each frame and drops below the bottom of the window (y=−6) at the left edge in frames 9 and 10" | Partial sums at x=−0.5: N=8 gives −5.272 (inside the window); N=9 gives −6.0997; N=10 gives −7.0310. In frames 8, 9 and 10 (`review/c06.png`) the curve leaves the window only in frames 9 and 10. | confirmed |
| A16 | "(at x=−0.5 the partial sum is −6.10 for N=9 and −7.03 for N=10)" | −6.0997 and −7.0310 | confirmed |
| A17 | "Where the nearest singularity is a pole (tan x in case 12, Γ(x) in cases 22–24)" | tan has simple poles at ±π/2. Γ has a simple pole at 0, the nearest to c=1, 2, 3. In the other non-entire cases the nearest singularity is a branch point (sqrt, log, 1/sqrt(1−x), log(1+x), atan at ±i, asin at ±1, Y0 at 0). | confirmed |
| A18 | "a different Laurent series about x0, with nonzero negative powers, holds in the annulus between that pole and the next singularity; the animations do not draw it" | tan: π/2<\|z\|<3π/2. Γ about c: c<\|z−c\|<c+1 contains only the pole at 0. Its principal part is nonzero. The code draws only k ≥ 0. | confirmed |
| A19 | "Each case below follows the same case ordering as the Padé suite (Case 01 through Case 27)." | Same as A1 | confirmed |
| A20 | Source link "Julia source for all cases" → `laurent_animations_all.jl` | The file exists and produces all 27 GIFs (manifest: byte-identical) | confirmed |
| C01–C27 | Each heading's f, x0 and interval | Each heading compared with the `cases` row: 01 sqrt 1 [0,10.5]; 02 sqrt 4; 03 sqrt 5; 04 1/sqrt(1−x) 0 [−1.5,1.5]; 05 log 1 [−0.5,4.1]; 06 log 2; 07 log(1+x) 0 [−1.5,1.5]; 08 sin 0 [−3π,3π]; 09 cos 0 [−3π,3π]; 10 sin π/4 [−7π/4,9π/4]; 11 cos π/3 [−5π/3,7π/3]; 12 tan 0 [−π,π]; 13 exp 0 [−2,3]; 14 e^{−x}cos x 0 [−2,4]; 15 cosh 0 [−4,4]; 16 atan 0 [−2,2]; 17 asin 0 [−1.5,1.5]; 18 J0 0 [−10.2,10.2]; 19 J1 0 [−10.2,10.2]; 20 Gaussian pdf 0 [−3,3]; 21 ½+½erf(x/√2) 0 [−3,3]; 22–24 Γ 1/2/3 [−0.2,5.2]; 25–27 Y0 10/5/2 [0,22]. All match. | confirmed (all 27) |
| G01–G27 | GIF titles "Laurent Case NN: f(x) = …, x0 = …" and the x-axis range | Read at full size on the last-frame montages (`last_1..3.png`). Every title's id, function and x0 match the heading. Cases 10 and 11 show 0.7854 = π/4 and 1.0472 = π/3. Axis ranges match the headings. | confirmed (all 27) |
| W01–W27 | Embed `laurentNN.gif` under "Case NN"; alt text "…for case NN." | index.qmd lines 38–142: each embed and alt text number matches its heading, and each GIF's title carries the same id | confirmed (all 27) |

### 3. Implementation checks (one script: `laurent_animations_all.jl`)

**It is the method it claims to be.** Every case is analytic at x0, so the Laurent series on the disc about x0 is the Taylor series. The script draws the degree-N Taylor polynomial for N = 1..max_order, and the page says so explicitly (A3). No variant mismatch. Coefficients come from closed forms (`series_coeffs`, lines 209–317). For Γ and Y0 they come from the BigFloat routine `taylor_coeffs_exact` (log-Γ/Hurwitz-ζ recursion; Bessel derivative identity).

**The numbers are right.** The instrumented copy `review/instr.jl` printed every case's coefficients (`coeffs.txt`). It also printed every plotted polynomial on the script's 900-point grid for every frame (`curves.txt`, 254 frame curves). Independent check (`indep.py`): `mpmath.taylor` at 60 digits on the actual function, about the same Float64 center:

| Cases | max relative coefficient error, script vs mpmath |
|---|---|
| 01–09, 12–27 | ≤ 1.3e−16 (correctly rounded or within 1 ulp) |
| 10 (sin about π/4) | 1.4e−15 |
| 11 (cos about π/3) | 3.0e−15 |

Sample values (script = mpmath): Γ about 1: [1, −0.5772156649, 0.9890559953, −0.9074790761]. Γ about 3: [2, 1.8455686702, 1.2464649960, 0.5749941689]. Y0 about 10: [0.0556711673, −0.2490154242, −0.0153848124, 0.0416003721]. Y0 about 2: [0.5103756726, 0.1070324315, −0.2819459442, 0.0336119368]. tan about 0 with max_order 8: [0,1,0,1/3,0,2/15,0,17/315,0]. The 62/2835 entry is k=9 and is correctly excluded. Errors of order 1e−15 in cases 10 and 11 come from `sin(c + kπ/2)` in Float64 and are invisible in a plot.

Plotted curves (`curvecheck.py`): on the script's grid, every frame's polynomial agrees with my partial sums from the mpmath coefficients to a relative difference of at most 7.6e−14 (all 27 cases). Frame counts: 10 for max_order 10 and 8 for max_order 8, matching the manifest.

**Its reference values are right.** The reference curve is `f(x)` itself (Base / SpecialFunctions `sqrt`, `log`, `tan`, `gamma`, `besselj`, `bessely`, `erf`, …). Non-real or non-finite values become NaN through `safe_eval`. The red dot is `f(x0)`. The functions match their labels: the mpmath coefficients of the same named functions agree with the script's, which would not happen if a label were attached to the wrong function.

**The picture shows what was computed.** The montages of the last frames of all 27 GIFs, plus frames 1, 5, 8, 9 and 10 of case 06 and frame 10 of case 03, show the following. The blue curve is the degree-N polynomial with the legend's N. It is tangent at the red dot (x0, f(x0)) in frame 1. The dashed grey line is at x = x0. Titles and legends are correct. Nothing is clamped (the comment at lines 329–330 is accurate): the polynomials leave the window through the axis limits. The behaviour the page describes is visible, and inside the window, in cases 03 and 06 (A9–A16). The only artifact is the vertical segment across a pole in cases 12 and 22–24, discussed under Findings and judged not misleading.

**Archive.** Consulted. `n2003` has no Laurent module (`taylorpoly/` and `pade/` exist). `a2001/Animations` has no Laurent animation. `c2003/LaurentSeriesMod.html` (complex analysis) exists, but its images are missing and it was not this page's source. See the note under Findings.

