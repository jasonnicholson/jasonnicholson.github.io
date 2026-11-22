# Laurent Series — animation review (round 5)

Page: `pages/numerical-methods/laurent-series/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Outside the review scope (not counted)

- F1. Implementation (display), Minor: the f curve is joined straight across the poles of tan and Γ — excluded: Jason decided after round 4 (fix-plan decision R4-D) to leave the Laurent pole lines as they are (recorded, not counted).

## Reviewer's notes (not findings)


**1 finding: 0 Error, 0 Misleading, 1 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `laurent_animations_all.jl` | 0 | 29.6 | 27 GIFs (laurent01.gif … laurent27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (page's own words, abbreviated) | Evidence | Verdict |
|---|---|---|---|
| D1 | A Laurent series about x0, valid in an annulus r<\|x−x0\|<R where f is analytic, is Σ_{k=−∞}^{∞} a_k (x−x0)^k (line 12–16) | Standard definition | confirmed |
| D2 | Negative-power terms form the principal part (line 18) | Standard | confirmed |
| D3 | "When f is analytic at x0, as it is in every case below, its Laurent series on the largest disc … has zero principal part and is the ordinary Taylor series" (line 18) | Every x0 avoids the singularities: sqrt/log at c>0, 1/sqrt(1−x) at 0, Γ at 1, 2, 3, Y0 at c>0, and the rest are analytic at 0 | confirmed |
| A1 | Reuses "the same 27 function/interval/center cases used on the Padé page" (line 22) | `grep '^### Case' pade-approximation/index.qmd`: the 27 headings are identical in function, x0 and interval | confirmed |
| A2 | Draws truncated series about x0, not Padé forms (line 22) | Code lines 337–346 | confirmed |
| A3 | "All 27 functions are analytic at x0" (line 24) | As D3 | confirmed |
| A4 | The two-sided truncation equals the degree-N Taylor polynomial (lines 26–30) | Follows from a_k=0 for k<0. Code evaluates `coeffs[1:n+1]`, which is degree n | confirmed |
| A5 | "That is what each frame draws, with N increasing frame by frame; no frame contains a negative power" (line 30) | Loop `for n in 1:case.max_order`. The legend reads N = 1 in the first frame and N = max in the last, for all 27 (`first_*.png`, `last_*.png`) | confirmed |
| A6 | Entire functions are cases 08–11, 13–15 and 18–21 (line 30) | sin, cos, exp, e^{−x}cos x, cosh, J0, J1, Gaussian pdf and ½+½erf(x/√2) are entire. The other 16 (01–07, 12, 16, 17, 22–27) all have finite singularities | confirmed |
| A7 | Otherwise "the series converges only within the distance from x0 to the nearest singularity … and diverges beyond it" (line 30) | Cauchy–Hadamard. Radius estimates from high-order coefficients: case 12 1.5708 (π/2); 16 1.043, 17 1.065 (→1, slow); 22 1.0000; 23 2.000; 24 3.000; 25 10.17; 26 5.08; 27 2.03 (log branch at 0, estimates approach x0 from above). For 01–07 the radius is the exact distance to the branch point | confirmed |
| A8 | "every such plotted interval reaches past that distance" (line 30) | R vs farthest window point: 01 1 vs 9.5; 02 4 vs 6.5; 03 5 vs 5.5; 04 1 vs 1.5; 05 1 vs 3.1; 06 2 vs 2.5; 07 1 vs 1.5; 12 π/2 vs π; 16 1 vs 2; 17 1 vs 1.5; 22 1 vs 4.2; 23 2 vs 3.2; 24 3 vs 3.2; 25 10 vs 12; 26 5 vs 17; 27 2 vs 20 | confirmed |
| A9 | Case 03's window passes that distance only on 10<x≤10.5 (line 30) | R=5 about 5 on [0,10.5]: \|x−5\|>5 ⇔ x>10 (x=0 is exactly at R) | confirmed |
| A10 | Case 06's window passes on 4<x≤4.1 and −0.5≤x<0 (line 30) | R=2 about 2 on [−0.5,4.1] | confirmed |
| A11 | On 10<x≤10.5 (03) and 4<x≤4.1 (06) "the ten frames do not show the divergence: the error falls from each frame to the next" (line 30) | `div.py` with exact mpmath series: monotone decrease for N=1..10 at all 43 (case 03) and 20 (case 06) plotted grid points in those ranges, and at 2001 dense points. No exceptions. Both cases have max_order 10 | confirmed |
| A12 | "At x=10.5 in case 03 the error keeps falling until N=15 … after that it grows with every further term (checked to N=80)" | `div.py`: argmin N=15, err 2.319e−2; strictly decreasing for N≤15 and strictly increasing for 15<N≤80 | confirmed |
| A13 | "at x=4.1 in case 06 until N=20; after that it grows (checked to N=80)" | `div.py`: argmin N=20, err 6.629e−2; strictly decreasing before and strictly increasing after, to N=80 | confirmed |
| A14 | In case 06, for x<0, "log x is not real and no f curve is drawn" | Julia `log(negative)` throws DomainError, so `safe_eval` returns NaN. The frames show no magenta curve left of 0 | confirmed |
| A15 | "there every term after the constant is negative, so the blue curve sinks with each frame" | a_k(x−2)^k = −\|x−2\|^k/(k 2^k) < 0 for x<2 (checked numerically at x=−0.3, k=1..10). Partial sums at x=−0.5 decrease monotonically, N=1..10 | confirmed |
| A16 | "drops below the bottom of the window (y=−6) at the left edge in frames 9 and 10 (at x=−0.5 the partial sum is −6.10 for N=9 and −7.03 for N=10)" | `div.py`: S_8=−5.2719 (inside), S_9=−6.0997, S_10=−7.0310. Frame crops (`c06_left.png`): frame 8 stays above −6, frame 9 meets the bottom edge at x=−0.5, frame 10 leaves it at x≈−0.45. Frame k shows N=k | confirmed |
| A17 | "Where the nearest singularity is a pole (tan x in case 12, Γ(x) in cases 22–24), a different Laurent series … with nonzero negative powers, holds in the annulus between that pole and the next singularity; the animations do not draw it" | tan: poles ±π/2, next ±3π/2. Γ about 1, 2, 3: nearest pole 0, next −1. In all the other non-entire cases the nearest singularity is a branch point (sqrt, log, 1/sqrt, atan at ±i, asin at ±1, Y0 log branch at 0), so tan and Γ are the only pole cases. The script draws only Taylor polynomials | confirmed |
| A18 | "Each case below follows the same case ordering as the Padé suite (Case 01 through Case 27)" | Heading order is identical to the Padé page | confirmed |
| A19 | Source link `laurent_animations_all.jl` | The file exists beside index.qmd and produces all 27 GIFs (manifest) | confirmed |
| C01–C27 | Each heading's f, x0, interval (lines 36–142) | Case table lines 21–47 checked row by row: f, c and xlims match every heading. π/4, π/3, ±3π, −7π/4..9π/4 and −5π/3..7π/3 match exactly. The GIF titles show the same f and x0 (0.7854 = π/4 and 1.0472 = π/3 to 4 d.p.), and the x-axis ranges in the frames match the headings | confirmed (all 27) |
| E01–E27 | Embed `laurentNN.gif` under heading "Case NN" | Each script row id NN writes `laurentNN.gif`, and the GIF title reads "Laurent Case NN" with the heading's function (all 27 checked in the montages) | confirmed (all 27) |
| Alt | "Laurent-series truncation animation for case NN." | Accurate, though generic | confirmed |
| Color | "the blue curve" (case 06) | The partial sum is drawn in steelblue; f is in magenta | confirmed |

---

### 3. Implementation checks (single script `laurent_animations_all.jl`)

**It is the method it claims to be.** Each frame draws Σ_{k=0}^{N} a_k (x−x0)^k with a_k = f^{(k)}(x0)/k!, evaluated by Horner's rule (`poly_eval_asc`), for N = 1..max_order. Because every f is analytic at x0, this is exactly the Laurent truncation Σ_{−N}^{N} on the disc of convergence, as the page states. No Padé or other substitution is involved.

**The numbers are right.** I dumped every case's coefficient vector from an instrumented copy (`review/dump.jl` → `coeffs.tsv`) and compared it with an independent `mpmath.taylor` expansion of each f at x0, with f written independently in Python at 60 digits (`review/indep.py`).

| Case | Order | max abs diff | max rel diff (nonzero coeffs) |
|---|---|---|---|
| 01, 02, 04 | 10 | 0 | 0 |
| 03, 05, 06, 07, 12–17, 20–27 | 8 or 10 | ≤ 1.1e−16 | ≤ 1.3e−16 |
| 10, 11 | 10 | ≤ 1.7e−16 | ≤ 3e−15 (on coefficients ~1e−7, i.e. absolute 1e−17) |
| 18, 19 | 10 | ≤ 1.5e−19 | ≤ 5.6e−17 |
| 08, 09 | 10 | 6.1e−17 | — (difference sits on the zero coefficients: `sin(kπ/2)` in Float64 is 1.2e−16, not 0, divided by k!; invisible) |

Every coefficient agrees to Float64 rounding. That covers the hand-written closed forms (tan up to x^7, asin, atan, J0, J1, the normal pdf and cdf, e^{−x}cos x, binomial series) and the BigFloat `taylor_coeffs_exact` routine used for Γ and Y0. The Γ and Y0 routine also gives radius-of-convergence estimates of 1, 2, 3 (Γ) and about x0 (Y0) at order 60 (`review/radius.jl`), which matches the true singularities. The partial-sum values the page quotes (A12, A13, A16) were recomputed independently in `div.py` from exact closed-form coefficients.

**Reference values.** The reference is f itself, evaluated with Julia Base and SpecialFunctions (`sqrt`, `log`, `tan`, `gamma`, `besselj`, `bessely`, `erf`). The red marker at (x0, f(x0)) sits on the curve in every frame and matches known values: √5 = 2.236, log 2 = 0.693, Γ(3) = 2, Y0(10) = 0.0557, Y0(5) = −0.3085, Y0(2) = 0.5104. Points where f is undefined (log x for x≤0, log(1+x) for x≤−1, 1/√(1−x) for x≥1, asin for |x|>1, Y0(0)) become NaN and are not drawn, which is correct.

**The picture shows what was computed.** I inspected the first and last frames of all 27 GIFs at full size in 3×3 montages, plus frames 7–10 of case 06 cropped at the left edge. Titles, legend `N`, the x0 dashed line, the red marker and the axis ranges all match the case table. The blue curve is the computed partial sum, with no clamping, so it visibly leaves the window where the series diverges. Frame counts are 10 everywhere except cases 12, 17 and 22–27, which have 8, consistent with `max_order`. The only display issue is F1: f is joined across the poles of tan and Γ.

