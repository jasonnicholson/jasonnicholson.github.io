# Laurent Series — animation review (round 3)

Page: `pages/numerical-methods/laurent-series/`. Reported findings: **0 Error, 1 Misleading, 0 Minor**.

## Findings

### F1. In cases 03 and 06 the frames show the opposite of "diverges beyond it"
- **Kind:** Page match
- **Severity:** Misleading
- **Location:** `index.qmd` line 30: "Unless $f$ is entire (cases 08–11, 13–15 and 18–21), the series converges only within the distance from $x_0$ to the nearest singularity of $f$ in the complex plane and diverges beyond it, and every such plotted interval reaches past that distance."
- **What is there now:** The sentence is mathematically true for every case. It tells the reader that each non-entire case's window goes past the radius of convergence, which invites them to look there for divergence. In two cases the frames show the opposite:
  - **Case 03** ($\sqrt{x}$, $x_0=5$, $R=5$): the only part of the window beyond $R$ is $(10, 10.5]$. At $x=10.5$, $|T_N - \sqrt{x}|$ for $N=1..10$ is 0.2255, 0.1127, 0.0733, 0.0545, 0.0439, 0.0373, 0.0329, 0.0298, 0.0277, 0.0261. It falls monotonically in every frame, and in the last frame the blue and magenta curves overlap at the right edge (see `committed/laurent03/sheet.png`). The only visible failure is near $x=0$, which is inside the closed disc (error 0.394 at $x=0$ when $N=10$).
  - **Case 06** ($\log x$, $x_0=2$, $R=2$): on the right, the region beyond $R$ is $(4, 4.1]$. At $x=4.1$ the error for $N=1..10$ is 0.332, 0.219, 0.167, 0.137, 0.118, 0.105, 0.096, 0.089, 0.084, 0.079, also falling monotonically. On the left, the region beyond $R$ is $x<0$, where $f$ is undefined and is not drawn, so the viewer has nothing to compare the polynomial against.
- **What is true instead:** The series does diverge at those points, but only for much larger $N$. At $x=10.5$ in case 03 the error is smallest at $N=15$ (0.0232) and reaches 0.942 at $N=80$. At $x=4.1$ in case 06 it is smallest at $N=20$ (0.0663) and reaches 0.315 at $N=80$. With $N\le 10$ a viewer sees convergence where the page says the series diverges.
- **How I know:** `python3 frames.py` and the inline check in `review/` (mpmath Taylor coefficients at 60 digits, partial sums evaluated at the points above). Output lines: `03 10.5 [0.2255, 0.1127, …, 0.0261]`, `06 4.1 [0.3322, …, 0.0794]`, `03 sqrt@5, x=10.5 error minimal at N= 15 min err 0.0232 … N=80 0.942`, `06 log@2, x=4.1 error minimal at N= 20 min err 0.0663 … N=80 0.315`.
- **Suggested correction:** Add a qualifier after the sentence, for example: "In cases 03 and 06 the window reaches only slightly past that distance, and with $N\le 10$ the partial sums there are still approaching $f$; the divergence appears only at higher order (beyond about $N=15$ at $x=10.5$ in case 03, and beyond about $N=20$ at $x=4.1$ in case 06)." Alternatively, drop "and every such plotted interval reaches past that distance", or point readers to cases 01, 02, 05, 07, 16 and 27 as the ones where the divergence is visible.

- **Independent check:** confirmed (independent recomputation and frames; see checker verify.md)


## Reviewer's notes (not findings)



#### Checked and not reported as findings
- **Vertical magenta segments.** In case 12 (at $x=\pm\pi/2$) and cases 22–24 (at $x\approx 0$), the `y = f(x)` line joins the two sides of a pole, because the script does not mask $f$ near poles. Nothing in the 900-point grid falls exactly on a pole. Each segment sits where the pole is and reads as an asymptote. It does not change what a viewer would conclude, so it is cosmetic.
- **Repeated frames.** For odd or even functions, consecutive frames draw the same polynomial (for example, $N=1$ and $N=2$ for $\tan x$). This is correct, because those Taylor coefficients really are zero.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `laurent_animations_all.jl` | 0 | 31.5 | 27 GIFs (laurent01.gif … laurent27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | Laurent series $f(x)=\sum_{k=-\infty}^{\infty}a_k(x-x_0)^k$, valid in an annulus $r<|x-x_0|<R$ where $f$ is analytic | Confirmed | Standard definition |
| D2 | Negative-power terms form the principal part | Confirmed | Standard |
| D3 | When $f$ is analytic at $x_0$ ("as it is in every case below"), the Laurent series on the largest disc has zero principal part and is the Taylor series | Confirmed | Every $x_0$ in the table is a point where $f$ is analytic (sqrt/log at $c>0$; $1/\sqrt{1-x}$, $\log(1+x)$, tan, atan, asin at 0; $\Gamma$ at 1, 2, 3; $Y_0$ at 2, 5, 10); script evaluates $f(x_0)$ finite for all 27 |
| A1 | "reuses the same 27 function/interval/center cases used on the Padé page" | Confirmed | `pade_animations_all.jl` lines 24–50 match `laurent_animations_all.jl` lines 21–47 in function, $c$, xlims, ylims and max order; Padé `index.qmd` headings are identical |
| A2 | "All 27 functions are analytic at $x_0$" | Confirmed | As D3 |
| A3 | Two-sided truncation equals the degree-$N$ Taylor polynomial | Confirmed | Follows from A2; code line 345 evaluates $\sum_{k=0}^{N}a_k z^k$ |
| A4 | "That is what each frame draws" | Confirmed | Script frame polynomials agree with independent mpmath Taylor polynomials to a relative difference of 7.9e-14 over all 254 frames × 900 points |
| A5 | "with $N$ increasing frame by frame" | Confirmed | Loop `for n in 1:case.max_order`; legends read N = 1 … 10 (or 1 … 8) across frames (e.g. `committed/laurent03/sheet.png`) |
| A6 | "no frame contains a negative power" | Confirmed | Only `coeffs[1:n+1]` (powers 0..n) are evaluated |
| A7 | Entire cases are 08–11, 13–15 and 18–21 | Confirmed | sin, cos, exp, $e^{-x}\cos x$, cosh, $J_0$, $J_1$, Gaussian pdf, erf-based cdf are entire. The others are not: sqrt, $1/\sqrt{1-x}$, log, $\log(1+x)$ (branch points); tan, $\Gamma$ (poles); atan (branch points $\pm i$); asin (branch points $\pm 1$); $Y_0$ (log branch at 0) |
| A8 | Non-entire series converge only within the distance to the nearest singularity and diverge beyond it | Confirmed (as mathematics) | Radii: 01:1, 02:4, 03:5, 04:1, 05:1, 06:2, 07:1, 12:π/2, 16:1, 17:1, 22:1, 23:2, 24:3, 25:10, 26:5, 27:2. But see F1: not visible in cases 03 and 06 |
| A9 | "every such plotted interval reaches past that distance" | Confirmed | Farthest endpoint vs R: 01 9.5>1; 02 6.5>4; 03 5.5>5; 04 1.5>1; 05 3.1>1; 06 2.5>2; 07 1.5>1; 12 π>π/2; 16 2>1; 17 1.5>1; 22 4.2>1; 23 3.2>2; 24 3.2>3; 25 12>10; 26 17>5; 27 20>2 |
| A10 | The nearest singularity is a pole for tan (case 12) and $\Gamma$ (cases 22–24), and only for those | Confirmed | Every other non-entire case has a branch point (A7) |
| A11 | A different Laurent series with nonzero negative powers holds in the annulus between that pole and the next singularity | Confirmed | tan: poles ±π/2, next ±3π/2, residues −1 give the negative-power part $-2z^{-1}(1+\pi^2/(4z^2)+\dots)$. $\Gamma$ about 1, 2, 3: nearest pole 0, next −1; the residue term $1/x$ expanded in $|x-x_0|>x_0$ has negative powers |
| A12 | "the animations do not draw it" | Confirmed | Code draws only nonnegative powers |
| A13 | Cases ordered 01 through 27 as in Padé | Confirmed | Headings and the case table are in the same order |
| A14 | Link "Julia source for all cases" → `laurent_animations_all.jl` | Confirmed | File exists; it produces all 27 GIFs; regenerated GIFs are byte-identical to the committed ones (manifest) |
| C01–C27 | Each heading's $f$, $x_0$ and interval match that case's script row, GIF title and axes | Confirmed for all 27 | Rows read individually (lines 21–47 vs headings at lines 36–140). GIF titles read on `review/last_montage_{0,1,2}.png`: "Laurent Case NN: f(x) = …, x0 = …", including 0.7854 = π/4 and 1.0472 = π/3. Axes: 01–03 [0,10.5]; 04, 07, 17 [−1.5,1.5]; 05–06 [−0.5,4.1]; 08–09 ±3π; 10 [−7π/4, 9π/4]; 11 [−5π/3, 7π/3]; 12 [−π,π]; 13 [−2,3]; 14 [−2,4]; 15 [−4,4]; 16 [−2,2]; 18–19 ±10.2; 20–21 [−3,3]; 22–24 [−0.2,5.2]; 25–27 [0,22]. The functions in the code (lines 21–47) are the functions in the headings (pdf $=e^{-x^2/2}/\sqrt{2\pi}$, cdf $=\tfrac12+\tfrac12\operatorname{erf}(x/\sqrt2)$) |
| E01–E27 | Image `laurentNN.gif` is embedded under the heading for Case NN; alt text "Laurent-series truncation animation for case NN." | Confirmed for all 27 | `index.qmd` lines 38–142; GIF titles carry the matching case number |
| G1 | Diagram: magenta = f, blue = Taylor/Laurent partial sum, dashed line at $x_0$, red dot at $(x_0, f(x_0))$ | Confirmed (the page does not describe the diagram; the legend does) | Code lines 355–363; frames |

---

### 3. Implementation checks: `laurent_animations_all.jl`

**Method.** For each case it computes the Taylor coefficients $a_k=f^{(k)}(x_0)/k!$, $k=0..N_{\max}$, and draws the partial sums $\sum_{k=0}^{n}a_k(x-x_0)^k$ for $n=1..N_{\max}$ against $f$. This is the Laurent series about $x_0$ on the disc of analyticity, which equals the Taylor series. The page says exactly this. No negative-power (annulus) series is computed, and the page says so.

**Numbers: coefficients.** I instrumented a scratch copy (`review/lib.jl` + `review/dump.jl`) to print all coefficient vectors to `coeffs_script.txt`. Independently, `review/indep.py` computed `mpmath.taylor(f, c, N)` at 60 digits, about the same Float64 $c$. This is numerical differentiation of mpmath's own $f$, not a copy of the script's closed-form formulas. Largest relative error per case, over nonzero coefficients:

| Case | f, x0 | max rel. error | | Case | f, x0 | max rel. error |
|---|---|---|---|---|---|---|
| 01 | sqrt, 1 | 0 | | 15 | cosh, 0 | 8.6e-17 |
| 02 | sqrt, 4 | 0 | | 16 | atan, 0 | 5.6e-17 |
| 03 | sqrt, 5 | 8.3e-17 | | 17 | asin, 0 | 5.6e-17 |
| 04 | 1/sqrt(1-x), 0 | 0 | | 18 | J0, 0 | 5.6e-17 |
| 05 | log, 1 | 5.6e-17 | | 19 | J1, 0 | 5.6e-17 |
| 06 | log, 2 | 5.6e-17 | | 20 | pdf, 0 | 1.3e-16 |
| 07 | log(1+x), 0 | 5.6e-17 | | 21 | cdf, 0 | 1.3e-16 |
| 08 | sin, 0 | 6.7e-17 | | 22 | Γ, 1 | 5.2e-17 |
| 09 | cos, 0 | 8.6e-17 | | 23 | Γ, 2 | 6.4e-17 |
| 10 | sin, π/4 | 1.4e-15 | | 24 | Γ, 3 | 9.3e-17 |
| 11 | cos, π/3 | 3.0e-15 | | 25 | Y0, 10 | 9.8e-17 |
| 12 | tan, 0 | 5.6e-17 | | 26 | Y0, 5 | 9.2e-17 |
| 13 | exp, 0 | 8.6e-17 | | 27 | Y0, 2 | 5.8e-17 |
| 14 | e^{-x}cos x, 0 | 6.7e-17 | | | | |

The 1e-15 level in cases 10–11 comes from `sin(c + kπ/2)`, which rounds $c+k\pi/2$; the largest absolute error is 1.7e-16. For sin and cos about 0, the "zero" coefficients come out at about 6e-17 rather than exactly 0, for the same reason. Both effects are invisible in the plots. Spot values: $\tan$: 1, 1/3, 2/15, 17/315 ✓. $\Gamma$ about 1: 1, −0.5772156649 (= −γ), 0.98905599533 ✓. For the "exactly rounded" claim in the comment at line 68, all 54 $\Gamma$/$Y_0$ coefficients equal the correctly rounded 60-digit values (0 mismatches).

**Numbers: drawn curves.** All 254 frame polynomials were dumped on the script's 900-point grid (`frames_script.txt`). `review/frames.py` rebuilt them from the independent coefficients; the largest relative difference is 7.9e-14.

**Reference values.** The magenta $f$ curve uses Julia `sqrt`, `log`, `tan`, `gamma`, `besselj`, `bessely`, `erf` and so on. Points outside the real domain ($\sqrt{}$ of a negative, $\log$ of a non-positive, asin with $|x|>1$, $Y_0(0)$) become NaN and are not drawn, which is correct. The values match the mpmath functions at the evaluated points: they were used in the beyond-R error computation, and the curves overlay the partial sums inside each radius.

**Picture.** I viewed the last frame of every GIF (`review/last_montage_{0,1,2}.png`) and the full frame sheet for case 03. Every title has the right case number, $f$ and $x_0$. The legend has the right $N$. The dashed line and red dot sit at $(x_0, f(x_0))$. The axis limits equal the case-table limits. Frame counts are 10, or 8 for cases 12, 17 and 22–27, matching `max_order`. Values are not clamped, so curves leave the window where they really do. The only display artefact is the line joining the two sides of each pole (see "Checked and not reported as findings"). The radius-of-convergence behaviour is visible in cases 01, 02, 04, 05, 07, 16, 17, 22 and 26–27, but not in 03 and 06 (F1).

