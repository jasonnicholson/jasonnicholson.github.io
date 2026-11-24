# Midpoint Rule — animation review (round 7)

Page: `pages/numerical-methods/midpoint-rule/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: "From 4 sample points on" is true of the animation but not of all n

- **Location:** `index.qmd`, Case 1 Behavior paragraph: "From 4 sample points on, the midpoint estimate is closer to the integral than the left- or right-endpoint sum with the same number of subintervals."
- **What is there now:** an unqualified statement about every $n \ge 4$.
- **What is true:** it holds in all 18 animation frames with $n \ge 4$, and for every integer $4 \le n \le 1622$. It fails for every $n$ from 1623 through 5206, where the **right-endpoint sum is closer** than the midpoint sum. The right-sum error changes sign between $n=3000$ and $n=4000$, so it passes through zero in that range. The midpoint is closer again from $n=5207$ through at least $n=20000$, the limit of the scan.
- **How I know:** `python3 review/lr.py` scanned every $n$ in $[4, 20000]$ and found 3584 exceptions, the contiguous block 1623 to 5206. `python3 review/lr2.py` confirmed both boundaries at 40 digits:

| n | M - I | L - I | R - I | Midpoint closest |
|---|---|---|---|---|
| 1622 | 6.47786e-6 | -2.85831e-5 | -6.48099e-6 | yes |
| 1623 | 6.47122e-6 | -2.85583e-5 | -6.46982e-6 | **no** |
| 5206 | 9.29304e-7 | -5.95692e-6 | 9.29290e-7 | **no** |
| 5207 | 9.29007e-7 | -5.95546e-6 | 9.29433e-7 | yes |

- **Why Minor:** the paragraph is about the animation and every frame satisfies the sentence. The exception lies far beyond the 120 subintervals shown.
- **Suggested correction:** "In every frame from 4 sample points on, the midpoint estimate is closer to the integral than the left- or right-endpoint sum with the same number of subintervals."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `midpointaa.jl` | 0 | 8.1 | midpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `midpointaa.gif` | 21 | byte-identical | midpointaa |

### Page references

- Scripts linked: `midpointaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Reference value used throughout: $I = \int_0^2 f\,dx = 2.0162797196170963$ (see section 3).

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | Midpoint rule "evaluates $f$ at subinterval midpoints instead of endpoints" | Script lines 21, 37-38 | confirmed |
| 2 | $\Delta x=(b-a)/n$ on a uniform partition into $n$ pieces | Script line 20 | confirmed |
| 3 | $M_n = \Delta x \sum_{i=0}^{n-1} f(a + (i+\tfrac12)\Delta x)$ | Identical to script line 21; degree-of-precision test in section 3 | confirmed |
| 4 | "each subinterval contributes a rectangle centered at its midpoint sample" | Script lines 35-41; marker pixel check | confirmed |
| 5 | "often much more accurate than left/right endpoint sums at the same $n$" | `smooth.py`: at $n=120$, $e^x$ on [0,2] has L/M error ratio 718, $\sin x$ on [0,1] has 2638. For this page's integrand the ratio is only 3.0 (L) and 2.4 (R) at $n=120$, which "often" allows | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 6 | Function $y = e^{-x}\sin(8x^{2/3})+1$ | Script line 8 | confirmed |
| 7 | Interval $[0,2]$ | Script line 9; frame axes | confirmed |
| 8 | "Each frame increases sample-point density across the full interval" | `n_seq` strictly increasing; partition spans [0,2]. Frame 1 is an intro frame with the curve alone | confirmed |
| 9 | "and updates the integral estimate" | Annotation in frames 2-21 equals the computed $M_n$ (table in section 3) | confirmed |
| 10 | Follows Mathews: "the same function" | Legacy `gr_178.gif`: `f[x_] = 1 + E^-x Sin[8 x^(2/3)]` | confirmed |
| 11 | Same "interval" | Legacy `a = 0.0; b = 2.0` | confirmed |
| 12 | Same "sequence of sample counts (1 to 120)" | Legacy list and all legacy GIF frames: 1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 50, 60, 70, 80, 100, 120, identical to `n_seq` | confirmed |
| 13 | "each midpoint sample marked by a red dot" | Script line 44; `pix.py` found a red marker at the computed midpoint for all $n$ of the 20 frames | confirmed |

### Case 1 heading and Behavior

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 14 | Heading: Midpoint Rule, $y = e^{-x}\sin(8x^{2/3})+1$ | Script line 8 | confirmed |
| 15 | "Over the first few frames the estimate jumps above and below the integral" | $M-I$: +0.7116 (n=1), -0.7851 (2), -0.00516 (4), +0.0430 (6) | confirmed |
| 16 | "from 6 sample points on it stays above" the integral | $M_n > I$ in every frame with $n\ge 6$, and for every integer $5 \le n \le 400$ | confirmed |
| 17 | "and decreases toward it in every frame" | Strictly decreasing across all frames from $n=6$; also for every consecutive integer 6 to 400 | confirmed |
| 18 | "$\int_0^2 f(x)\,dx \approx 2.016280$" | 2.01627972 by three independent quadratures | confirmed |
| 19 | "the last frame (120 sample points) gives 2.016771" | 2.016771455; frame 21 shows 2.016771 | confirmed |
| 20 | "still about 0.00049 high" | $M_{120}-I = 0.000491736$ | confirmed |
| 21 | "From 4 sample points on, the midpoint estimate is closer ... than the left- or right-endpoint sum" | True for all frames and $n \le 1622$; false for $1623 \le n \le 5206$ | **wrong as worded (F1)** |
| 22 | "$f'$ unbounded at $x=0$" | $f'$ contains $\tfrac{16}{3}x^{-1/3}e^{-x}\cos(8x^{2/3})$ | confirmed |
| 23 | "$f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near $0$" | Ratio of $f'$ to this: 0.99431 ($x=10^{-3}$), 0.9999972 ($10^{-6}$), 1.0000 ($10^{-9}$) | confirmed |
| 24 | Textbook error order "does not hold for this integrand" | Measured local order 1.64 to 1.666, not 2 | confirmed |
| 25 | "error shrinks like $O(\Delta x^{5/3})$ rather than $O(\Delta x^2)$" | $(M_n-I)/\Delta x^{5/3}$ = 0.45219 (n=120), 0.45639 (1000), 0.45797 (8000), 0.45871 (64000), approaching the predicted leading constant $8\zeta(-2/3,1/2)=0.45943$ | confirmed |
| 26 | "halving $\Delta x$ divides it by about 3.11 (from 24 to 48 subintervals)" | $E_{24}/E_{48} = 3.11248$ | confirmed |
| 27 | "tending to $2^{5/3}\approx 3.17$, instead of 4" | $2^{5/3}=3.17480$; ratios rise 3.1125, 3.1475, 3.1592, ... 3.17336 at $n=24576$ | confirmed |
| 28 | Source link `midpointaa.jl` | File exists; it is the script producing this GIF | confirmed |
| 29 | Embed `midpointaa.gif` | Exists; byte-identical to a fresh scratch run (`cmp`) | confirmed |
| 30 | Alt text: "each frame increases partition density, marks the midpoint samples with red dots and recomputes the midpoint-rectangle area" | As 8, 9, 13 (frame 1 is the curve-only intro) | confirmed |

### Later sections

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 31 | For $C^2$ $f$, global error is $O(\Delta x^2)$; doubling $n$ cuts the error by about 4 | Script's routine on $e^x$: ratios 3.9945, 3.9986, 3.9997, 3.9999 | confirmed |
| 32 | Worked Example: "the frame-by-frame approximation ... converges as $n$ grows" | Frame values approach $I$; error 0.000492 at $n=120$; convergence rate shown in 25 | confirmed |
| 33 | "The script keeps axis limits fixed" | Script lines 15-16, 25; one plot box fits all 20 frames in the marker check | confirmed |
| 34 | "mirroring legacy animation behavior" | Legacy frames have fixed axes (`PlotRange {{0,2.01},{0,2.01}}`). The page's y-limit is 2.1, which changes nothing a viewer would conclude | confirmed |

### Fidelity to the legacy archive

- The archive's only animation for this topic is `Midpointaa.gif`, which is Example 11. The page reproduces its function, interval and sample counts. All 20 legacy approximations agree with the script to the 6 decimals shown (table in section 3).
- Examples 1 to 10 are static worked examples on other integrands (Example 1 uses $2+\cos(2\sqrt{x})$), with no animations. Not reproducing them is content the page does not yet have, so it is not a finding.
- No Fidelity findings.

---

### 3. Implementation checks: `midpointaa.jl`

**It is the method it claims to be: yes.** Line 21 is the composite midpoint rule on a uniform partition. Run through an instrumented copy with `f` swapped (`review/instr.jl`, lines 8-22 of the script verbatim):

| Test on [0,2] | n=1 error | n=3 error | n=7 error | Expected |
|---|---|---|---|---|
| $x^0$ | 0 | 0 | 0 | exact |
| $x^1$ | 0 | 0 | -4.4e-16 | exact |
| $x^2$ | -0.6667 | -0.0741 | -0.0136 | not exact; $-(b-a)h^2/12$ |
| $x^3$ | -2.0 | -0.2222 | -0.0408 | not exact |

Degree of precision is 1, as it must be. On $e^x$ the error ratio on halving $h$ is 3.9945, 3.9986, 3.9997, 3.9999, so the order is 2 on a smooth integrand.

**The numbers are right: yes.** Script values against an independent 40-digit mpmath evaluation (`indep.py`), and against the numbers printed in Mathews' GIF. "Shown" is the annotation read from the committed frames.

| n | Script | Independent | Shown | Mathews GIF |
|---|---|---|---|---|
| 1 | 2.7279291178 | 2.72792912 | 2.727929 | 2.727929 |
| 2 | 1.2312160095 | 1.23121601 | 1.231216 | 1.231216 |
| 4 | 2.0111183724 | 2.01111837 | 2.011118 | 2.011118 |
| 6 | 2.0592799220 | 2.05927992 | 2.05928 | 2.059280 |
| 8 | 2.0515167833 | 2.05151678 | 2.051517 | 2.051517 |
| 10 | 2.0430303054 | 2.04303031 | 2.04303 | 2.043030 |
| 12 | 2.0369374964 | 2.03693750 | 2.036937 | 2.036937 |
| 14 | 2.0326672908 | 2.03266729 | 2.032667 | 2.032667 |
| 16 | 2.0296063674 | 2.02960637 | 2.029606 | 2.029606 |
| 20 | 2.0256363341 | 2.02563633 | 2.025636 | 2.025636 |
| 24 | 2.0232541563 | 2.02325416 | 2.023254 | 2.023254 |
| 28 | 2.0217081526 | 2.02170815 | 2.021708 | 2.021708 |
| 32 | 2.0206439591 | 2.02064396 | 2.020644 | 2.020644 |
| 40 | 2.0193054930 | 2.01930549 | 2.019305 | 2.019305 |
| 50 | 2.0183745800 | 2.01837458 | 2.018375 | 2.018375 |
| 60 | 2.0178298861 | 2.01782989 | 2.01783 | 2.017830 |
| 70 | 2.0174810172 | 2.01748102 | 2.017481 | 2.017481 |
| 80 | 2.0172427549 | 2.01724275 | 2.017243 | 2.017243 |
| 100 | 2.0169450743 | 2.01694507 | 2.016945 | 2.016945 |
| 120 | 2.0167714555 | 2.01677146 | 2.016771 | 2.016771 |

The annotation drops trailing zeros (2.05928 for 2.059280) because of `round`. The value is unchanged, so this is not a finding.

**Its reference values are right.** The script draws no reference value; the page quotes $I \approx 2.016280$. Three evaluations agree to 20 digits, 2.0162797196170963279: the substitution $x=t^3$ (which makes the integrand analytic) on 16 panels and on 40 panels, and tanh-sinh directly on the original integrand.

**The picture shows what was computed: yes.**

- The committed GIF is byte-identical to a scratch regeneration (`cmp`), and the script is unchanged from the regenerated copy.
- `pix.py` mapped data to pixels from the plot box (x 39 to 618, y 32 to 449) and checked all 20 rectangle frames. A red marker sits at the computed $(x_m, f(x_m))$ for every sample: 1/1, 2/2, ... 120/120.
- As a control, the same test at left endpoints scored 0 hits through $n=70$. At $n \ge 80$ the markers are close enough to overlap neighbouring test positions (7, 42, 70 hits), so the control does not discriminate there.
- Rectangle tops match $f(x_m)$ within 1.8 px on the 307 subintervals measured across $n=4$ to 70. Columns where the outline could not be isolated were skipped, and $n=80$ to 120 were too narrow to measure. For those, the evidence is the plotting code (`h = f(xm)`, line 38) and the byte-identical regeneration.
- Frames 1, 2 and 21 were inspected directly, and the annotation strip of all 21 frames was read.
- Limits: $f$ ranges from 0.3572 to 1.9198 on [0,2], inside the y-limits (0, 2.1), so nothing is clipped. No clamping or masking is used. The annotation (y 1.74 to 1.88, centred at x=1.15) does not touch the curve or any rectangle, whose height is at most about 1.39 in that x range.

