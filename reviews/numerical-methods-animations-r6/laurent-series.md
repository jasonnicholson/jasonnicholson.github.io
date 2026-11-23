# Laurent Series — animation review (round 6)

Page: `pages/numerical-methods/laurent-series/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no error, no misleading statement and no minor issue that meets the review standard.

Things I looked at and judged not to be findings:
- The animations never draw a nonzero principal part: every frame is a Taylor polynomial, and the legend says "Laurent = Taylor, N = n". The page says this outright, twice ("is the degree-N Taylor polynomial. That is what each frame draws … no frame contains a negative power"; "a different Laurent series … holds in the annulus … the animations do not draw it"). It is a limitation of the content, not a false claim.
- For odd or even expansions (cases 08, 09, 12, 15–21) consecutive frames N = 2m−1 and N = 2m (or 2m and 2m+1) draw the same polynomial, because the skipped coefficient is zero. The legend reports N correctly, and the page claims only that N increases frame by frame, which is true.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `laurent_animations_all.jl` | 0 | 30.5 | 27 GIFs (laurent01.gif … laurent27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | Laurent series $f(x)=\sum_{k=-\infty}^{\infty}a_k(x-x_0)^k$ on an annulus $r<\lvert x-x_0\rvert<R$ where f is analytic | Standard definition | confirmed |
| D2 | Negative-power terms form the principal part | Standard | confirmed |
| D3 | When f is analytic at $x_0$, the Laurent series on the largest disc of analyticity has zero principal part and is the Taylor series | Standard (uniqueness of the Laurent expansion on a given annulus) | confirmed |
| A1 | "reuses the same 27 function/interval/center cases used on the Padé page" | `pade-approximation/*.jl` lines 24–50 vs Laurent lines 25–51: same f, $x_0$ and x-window for all 27 rows. Only the y-limits of cases 01–02 differ, and the page does not claim those match | confirmed |
| A2 | "draws truncated series about $x_0$ instead of rational Padé forms" | Script line 352 evaluates the polynomial $\sum_{k\le n}a_k(x-x_0)^k$ | confirmed |
| A3 | All 27 functions are analytic at $x_0$ | sqrt at 1, 4, 5; $(1-x)^{-1/2}$ at 0; log at 1, 2; log(1+x) at 0; entire functions; tan at 0; atan and asin at 0; Γ at 1, 2, 3; $Y_0$ at 10, 5, 2: none of these is a singular point | confirmed |
| A4 | Two-sided truncation equals the degree-N Taylor polynomial; that is what each frame draws, N increasing frame by frame; no negative power | Lines 344–352: frame n uses `coeffs[1:n+1]`, no negative powers. Legends in frames read N = 1, …, max (montages grp0–grp6) | confirmed |
| A5 | Entire cases are 08–11, 13–15 and 18–21 | sin, cos (08–11), exp, $e^{-x}\cos x$, cosh (13–15), $J_0$, $J_1$, normal pdf, normal cdf (18–21) are entire. The others are not: 01–07 (branch points), 12 (poles), 16–17 (±i, ±1), 22–24 (poles), 25–27 (log branch point at 0) | confirmed |
| A6 | Otherwise the series converges only within the distance to the nearest singularity and diverges beyond it | Cauchy–Hadamard | confirmed |
| A7 | "every such plotted interval reaches past that distance" | Radius R and window: 01 R=1, [0,10.5]; 02 R=4; 03 R=5; 04 R=1, [−1.5,1.5]; 05 R=1, [−0.5,4.1]; 06 R=2; 07 R=1, [−1.5,1.5]; 12 R=π/2, [−π,π]; 16 R=1, [−2,2]; 17 R=1, [−1.5,1.5]; 22 R=1, 23 R=2, 24 R=3, [−0.2,5.2] (left end −0.2 is past 0 in all three); 25 R=10, 26 R=5, 27 R=2, [0,22]. Every window passes its R | confirmed |
| A8 | "Case 03's window passes that distance only on 10<x≤10.5" | R=5 about 5: the disc reaches [0,10]. x=0 is on the boundary, not past it | confirmed |
| A9 | "case 06's on 4<x≤4.1 and −0.5≤x<0" | R=2 about 2: the disc reaches [0,4] | confirmed |
| A10 | On 10<x≤10.5 (case 03) and 4<x≤4.1 (case 06) "the error falls from each frame to the next" | `claims.py`: on 1000 grid points in each interval, $\lvert S_N-f\rvert$ strictly decreases for N=1..10 at every point (True for both) | confirmed |
| A11 | Case 03 at x=10.5: error falls until N=15, then grows with every further term (checked to N=80) | `claims.py`: argmin N = 15 (err 0.023191), strictly falling for N<15, strictly growing 15→80 (err 0.94182 at N=80) | confirmed |
| A12 | Case 06 at x=4.1: error falls until N=20, then grows (checked to N=80) | `claims.py`: argmin N = 20 (err 0.066293), strictly falling before, strictly growing 20→80 (err 0.31538 at N=80) | confirmed |
| A13 | In case 06 the divergence shows only for x<0, where log x is not real and no f curve is drawn | A10 shows none on (4,4.1]. Julia `log` of a negative Float64 throws, `safe_eval` returns NaN, so no magenta curve for x<0 (frames confirm) | confirmed |
| A14 | For x<0 in case 06 "every term after the constant is negative, so the blue curve sinks with each frame" | Term k is $-(2-x)^k/(k\,2^k)$ <0 for all x<2 (checked numerically at x=−0.01). Left-edge partial sums decrease monotonically from −0.557 to −7.031 | confirmed |
| A15 | It drops below the bottom of the window (y=−6) at the left edge in frames 9 and 10 | Minimum over [−0.5,0] by frame: −0.557, −1.338, −1.989, −2.600, −3.210, −3.846, −4.527, −5.272, **−6.0997**, **−7.031**. Only frames 9 and 10 are below −6. Frame 10 PNG shows the exit near x≈−0.43 | confirmed |
| A16 | At x=−0.5 the partial sum is −6.10 for N=9 and −7.03 for N=10 | mpmath: −6.0997, −7.0310. Script copy: −6.0997, −7.031 | confirmed |
| A17 | For tan (case 12) and Γ (cases 22–24) the nearest singularity is a pole | tan: simple poles at ±π/2. Γ: simple pole at 0, which is nearer than −1 for $x_0$ = 1, 2, 3 | confirmed |
| A18 | A different Laurent series with nonzero negative powers holds in the annulus between that pole and the next singularity; the animations do not draw it | The principal part at the nearer pole(s), expanded for $\lvert x-x_0\rvert$ greater than the pole's distance, gives nonzero negative powers (e.g. tan: $-2x/(x^2-\pi^2/4)$ gives $-2/x+\dots$). Not drawn, as the page says | confirmed |
| A19 | "same case ordering as the Padé suite (Case 01 through Case 27)" | Same as A1; ids 01–27 in the same order | confirmed |
| A20 | Source link `laurent_animations_all.jl` | File exists, and a scratch copy regenerates all 27 GIFs byte-identically (cmp: 27/27) | confirmed |
| C01–C27 | Each heading's f, $x_0$ and interval; image `laurentNN.gif`; alt text "Laurent-series truncation animation for case NN." | Every row in `coeffs_script.tsv` matches its heading: 01–03 sqrt at 1/4/5 on [0,10.5]; 04 $1/\sqrt{1-x}$ at 0 on [−1.5,1.5]; 05–06 log at 1/2 on [−0.5,4.1]; 07 log(1+x) at 0 on [−1.5,1.5]; 08–09 sin/cos at 0 on [−3π,3π]; 10 sin at π/4 on [−7π/4,9π/4]; 11 cos at π/3 on [−5π/3,7π/3]; 12 tan at 0 on [−π,π]; 13 exp at 0 on [−2,3]; 14 $e^{-x}\cos x$ at 0 on [−2,4]; 15 cosh at 0 on [−4,4]; 16 atan at 0 on [−2,2]; 17 asin at 0 on [−1.5,1.5]; 18–19 $J_0$/$J_1$ at 0 on [−10.2,10.2]; 20 normal pdf and 21 $\tfrac12+\tfrac12\operatorname{erf}(x/\sqrt2)$ at 0 on [−3,3]; 22–24 Γ at 1/2/3 on [−0.2,5.2]; 25–27 $Y_0$ at 10/5/2 on [0,22]. GIF titles (read in grp0–grp6) show the same function and $x_0$ (0.7854 = π/4 and 1.0472 = π/3 for 10 and 11), and each embed points to its own case's GIF | confirmed (all 27) |
| Counts | 27 cases. Frames: 10 per case, 8 for 12, 17, 22–27 (from max_order). The page says "ten frames" only for cases 03 and 06 | Manifest frame counts and the last-frame legends (N=10 or N=8) agree | confirmed |

### 3. Implementation checks: `laurent_animations_all.jl`

**Is it the method it claims to be.** It draws truncated power series about $x_0$. Because every $f$ is analytic at $x_0$, the Laurent series on the disc of analyticity is the Taylor series, so drawing the degree-N Taylor polynomial is what a "Laurent truncation" correctly gives here. Script, legend ("Laurent = Taylor") and page all say so. This is a legitimate, explicitly named special case, not a substitution passed off under the Laurent name.

**The numbers are right.** I instrumented a copy (`lib.jl` + `dump.jl`) that dumps every coefficient used by all 27 cases (`coeffs_script.tsv`). I checked them against `mpmath.taylor(f, x0, N)` at 60 digits (`indep.py`). That check is independent of the script's closed forms, which include the binomial series, log, tan constants, $\arcsin$, $J_0$, $J_1$, the normal pdf and cdf, $\operatorname{Re}((-1+i)^k)/k!$, the Γ log-series recurrence with Hurwitz zeta, and the $Y_0$ derivative identity. Maximum relative error per case:

| Case | max rel err | Case | max rel err | Case | max rel err |
|---|---|---|---|---|---|
| 01 | 0 | 10 | 1.4e−15 | 19 | 5.6e−17 |
| 02 | 0 | 11 | 3.0e−15 | 20 | 1.3e−16 |
| 03 | 8.3e−17 | 12 | 5.6e−17 | 21 | 1.3e−16 |
| 04 | 0 | 13 | 8.6e−17 | 22 | 5.2e−17 |
| 05 | 5.6e−17 | 14 | 6.7e−17 | 23 | 6.4e−17 |
| 06 | 5.6e−17 | 15 | 8.6e−17 | 24 | 9.3e−17 |
| 07 | 5.6e−17 | 16 | 5.6e−17 | 25 | 9.8e−17 |
| 08 | 6.7e−17 | 17 | 5.6e−17 | 26 | 9.2e−17 |
| 09 | 8.6e−17 | 18 | 5.6e−17 | 27 | 5.8e−17 |

All coefficients are correct to double precision. Cases 10 and 11 differ by a few ulps because `sin(c + kπ/2)` is evaluated in Float64, which is negligible. Where the true coefficient is zero, the script's coefficient is zero or below 1e−16. For example, a_8 = 0.99810569 (Γ about 1, matching mpmath) and a_8 = −0.00029134474 ($Y_0$ about 2). Partial sums from the script copy match mpmath at the points I tested (A16).

**Reference values.** The magenta "y = f(x)" curve is Julia's `sqrt`, `log`, `tan`, `gamma`, `besselj`, `bessely`, `erf` and the like on Float64. These are the true functions to plotting accuracy. Values at the red marker were confirmed implicitly, because $a_0$ equals $f(x_0)$ in every row of the mpmath check. Domain failures (log or sqrt of a negative number, asin for |x|>1, $Y_0(0)=-\infty$) become NaN and leave gaps, which is correct. NaN is inserted at the listed poles (±π/2 for tan, 0 for Γ), so no false vertical segment crosses a pole. The frames confirm the breaks.

**The picture shows what was computed.** I checked first, middle and last frames of all 27 GIFs (grp0–grp6) plus case 06 frame 10 at full size:
- The blue curve is the partial sum.
- The red dot is at $(x_0, f(x_0))$ on the dashed line at $x_0$.
- The legend N matches the frame index.
- Titles name the function and $x_0$ from the case table.

Values are not clamped. Curves leave through the axis edge, which is honest. No feature the page talks about falls outside the window: the case 06 left-edge dip below −6 in frames 9–10 is described on the page as leaving the window. Committed GIFs are byte-identical to a fresh scratch regeneration (27/27 `cmp`, exit 0, 30.5 s), so the frames reviewed are what the script produces.

