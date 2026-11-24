# Legendre Polynomials — animation review (round 7)

Page: `pages/numerical-methods/legendre-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error 0, Misleading 0, Minor 0.

Items examined and deliberately not reported as findings, so the owner can overrule them:

- **No `## Description` section.** The page has none, although `.github/agents/animation-page.agent.md` asks for one. The review standard excludes content the page does not yet have. It also means there are no Description formulas to check; the formulas on the page are in the Case 1 and Case 2 paragraphs and are in the ledger.
- **Mathews Example 8(a) is not animated, and neither is the Example 8 comparison.** Example 8 compares the Legendre series with the discrete interpolation polynomial for 8(a) $e^x$ and 8(b) $e^x\cos(\pi x/2)$. The page animates only the 8(b) series and claims only that its $f$ "is the function of Mathews' Example 8(b)", which is true. The archive has no animation for this topic and nine examples, so I treated the selection as scope and not as a silently dropped case.
- **Degree 8 against Mathews' degree.** Mathews uses $n=4$ in 8(a) (`LegendrePolyMod_gr_326.gif`). The 8(b) solution images (`gr_336` to `gr_345`) are missing from the archive, so his degree for 8(b) **could not be determined**. The page makes no claim about it.
- **Legend overlap in `legendrepolyaa.gif`.** In the later frames the legend covers short stretches of $P_0$, $P_1$ and $P_2$ near the top right. The meeting point $(1,1)$ stays visible to the right of the legend box, so nothing the page states is hidden.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `legendrepolyaa.jl` | 0 | 6.7 | legendrepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `legendrepolybb.jl` | 0 | 8.5 | legendrepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `legendrepolyaa.gif` | 6 | byte-identical | legendrepolyaa |
| `legendrepolybb.gif` | 9 | byte-identical | legendrepolybb |

### Page references

- Scripts linked: `legendrepolyaa.jl`, `legendrepolybb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | "illustrates Legendre polynomials $P_n(x)$ on $[-1,1]$" | Both scripts use `range(-1.0, 1.0, length=500)`, `xlims=(-1,1)` | confirmed |
| 2 | Intro | "The first animation reveals $P_0$ through $P_5$ one per frame" | `n in 0:5`; 6 frames, 6 distinct; frame $k$ draws $P_0..P_{k-1}$; pixel check below | confirmed |
| 3 | Intro | "the second shows the Legendre series partial sums converging to $f(x)=e^{x}\cos(\pi x/2)$" | Line 44 of bb; 9 frames $S_0..S_8$; sup error falls to 7.74e-6 | confirmed |
| 4 | Intro | "Julia source scripts ... are linked under each case" | Both links present, files exist | confirmed |
| 5 | Case 1 heading | "Successive polynomials $P_0, P_1, \ldots, P_5$" | `n_max = 5` | confirmed |
| 6 | Case 1 | "Each $P_n$ is orthogonal to all lower-degree Legendre polynomials on $[-1,1]$" | Exact sympy integrals for all $i<j\le5$ are 0; general case is the standard theorem | confirmed |
| 7 | Case 1 | "$P_n(1)=1$" | Exact for $n\le5$; visible at the right edge of frame 6 | confirmed |
| 8 | Case 1 | "$P_n(-1)=(-1)^n$" | Exact for $n\le5$; visible at the left edge of frame 6 | confirmed |
| 9 | Case 1 | "$P_n$ has exactly $n$ zeros in $(-1,1)$" | Root counts 0, 1, 2, 3, 4, 5 for $n=0..5$ (30-digit roots); general case is the standard theorem | confirmed |
| 10 | Case 1 | "computed by the recurrence $(n+1)P_{n+1} = (2n+1)xP_n - nP_{n-1}$" | aa line 20 is this with $k=n+1$; residual against Rodrigues-defined $P_n$ is exactly 0 for $n=1..5$; same as Mathews `gr_305` | confirmed |
| 11 | Case 1 link | `legendrepolyaa.jl` | Is the Case 1 script | confirmed |
| 12 | Case 1 embed/alt | "$P_0$ through $P_5$ added one per frame on the interval [-1, 1]" | 6 frames, cumulative | confirmed |
| 13 | Case 1 alt | "showing their oscillatory character" | Frames show $n$ sign changes for $P_n$ | confirmed |
| 14 | Case 2 heading | "Legendre series for $f(x)=e^{x}\cos(\pi x/2)$" | bb line 44; frame title and legend agree | confirmed |
| 15 | Case 2 | "$S_N(x)=\sum_{n=0}^{N} c_n P_n(x)$" | bb lines 54 to 57; dumps match independent $S_N$ to at most 1.1e-14 | confirmed |
| 16 | Case 2 | "$c_n=\tfrac{2n+1}{2}\int_{-1}^{1} f P_n\,dx$" | bb lines 38 to 42; agrees with closed form to at most 9.5e-15 (table in section 3); same as Mathews `gr_326` | confirmed |
| 17 | Case 2 | "converges to $f$ as $N\to\infty$" | $f$ is entire, so the series converges uniformly on $[-1,1]$; computed sup error 1.24e-8 at $N=10$, 1.56e-12 at $N=14$, 1.2e-15 (roundoff) at $N=16$ | confirmed |
| 18 | Case 2 | "This $f$ is the function of Mathews' Example 8(b)" | `gr_325` reads $f[x]=e^x\cos[\frac{\pi}{2}x]$; `gr_323` reads $[-1,1]$ | confirmed |
| 19 | Case 2 | "it is neither even nor odd" | $f(0.5)=1.16582$, $f(-0.5)=0.42888$ | confirmed |
| 20 | Case 2 | "every coefficient $c_0,\ldots,c_8$ is nonzero" | Closed-form values in section 3; smallest is $|c_8|=1.76\times10^{-5}$ | confirmed |
| 21 | Case 2 | "so each frame adds a new term" | Follows from 20; 9 distinct frames | confirmed |
| 22 | Case 2 | "$S_N$ minimises the integrated squared error" | Residual orthogonal to $P_0..P_N$ to at most 3.6e-15 for every $N$; all 2,700 random coefficient perturbations raised the L2 error | confirmed |
| 23 | Case 2 | "the max error need not fall at every step" | L2 error falls 0.5596 to 0.4615 from $S_0$ to $S_1$ while max error rises | confirmed |
| 24 | Case 2 | "it rises from 0.699 for $S_0$" | True sup 0.6990438 at $x=-1$ | confirmed |
| 25 | Case 2 | "to 1.09 for $S_1$" | True sup 1.0865797 at $x=+1$ | confirmed |
| 26 | Case 2 | "then falls with each added term" | Sup norm strictly decreasing $S_1$ through $S_8$ (table in section 3) | confirmed |
| 27 | Case 2 | "to $7.74\times 10^{-6}$ for $S_8$" | True sup 7.736699e-6 at $x=+1$ | confirmed |
| 28 | Case 2 link | `legendrepolybb.jl` | Is the Case 2 script | confirmed |
| 29 | Case 2 alt | "partial sums $S_0$ through $S_8$ ... one per frame; every coefficient is nonzero" | 9 frames; see 20 | confirmed |
| 30 | Case 2 alt | "max error rises from 0.699 for $S_0$ to 1.09 for $S_1$, then falls with each added term to 7.74e-6 for $S_8$" | See 24 to 27 | confirmed |
| 31 | Frames (bb) | Title values 0.699, 1.09, 0.44, 0.0622, 0.0134, 0.00412, 0.00038, 2.54e-5, 7.74e-6 | Each equals the 3-significant-figure true sup norm | confirmed |

### 3. Implementation checks

### `legendrepolyaa.jl`

**It is the method it claims.** Lines 16 to 23 are the three-term (Bonnet) recurrence with $P_0=1$, $P_1=x$.

**The numbers are right.** Every plotted curve was dumped from inside the animation loop and compared on all 500 grid points:

| $n$ | Max diff vs `scipy.special.eval_legendre` | Max diff vs exact Rodrigues polynomial |
|---|---|---|
| 0 | 0 | 0 |
| 1 | 2.2e-16 | 2.2e-16 |
| 2 | 8.9e-16 | 8.9e-16 |
| 3 | 1.6e-15 | 1.7e-15 |
| 4 | 2.4e-15 | 2.9e-15 |
| 5 | 3.7e-15 | 3.2e-15 |

The exact polynomials were built from Rodrigues' formula, independently of the recurrence, and agree with Mathews' list (`gr_225` to `gr_230`). Exact checks: $\int P_iP_j=0$ for $i<j\le5$, $\int P_n^2=2/(2n+1)$, recurrence residual 0.

**Reference values.** The script has none.

**The picture shows what was computed.** In each of the 6 frames and for each drawn curve, I checked by column that the curve's colour lies within 2.5 px of the true $P_k$ (legend area excluded). The lowest match rate is 530/559 (94.8%, $P_2$ in frame 6); the misses are consistent with later curves drawn on top of earlier ones and with the edge of the legend box, but I did not attribute them column by column. Frame 6: $P_0$ 482/482, $P_1$ 471/482, $P_2$ 530/559, $P_3$ 583/589, $P_4$ 596/601, $P_5$ 608/608. All values lie in $[-1,1]$, inside `ylims=(-1.3, 1.3)`, so nothing is clipped. Titles and legends carry the right indices.

### `legendrepolybb.jl`

**It is the method it claims.** Truncated Legendre series with $L^2$ projection coefficients. The integrals use 20-point Gauss-Legendre by Golub-Welsch (lines 30 to 34). The rule has the expected degree of precision: monomial errors are at most about 8e-16 through degree 39, and the error at degree 40 is -2.8e-12, about 3,500 times the roundoff level at degree 39.

**The numbers are right.** Closed-form $c_n$ comes from exact moments by integration by parts, with no quadrature, and was confirmed by `mpmath.quad`:

| $n$ | Closed form | Script | Difference |
|---|---|---|---|
| 0 | 0.699043843795788 | 0.699043843795787 | 1.2e-15 |
| 1 | 0.387535809393875 | 0.387535809393875 | 3.9e-16 |
| 2 | -0.646504030098766 | -0.646504030098762 | 4.7e-15 |
| 3 | -0.397213547890703 | -0.397213547890700 | 2.3e-15 |
| 4 | -0.0562969811584083 | -0.0562969811584088 | 5.1e-16 |
| 5 | 0.00931625103829338 | 0.00931625103828728 | 6.1e-15 |
| 6 | 0.00377538581963780 | 0.00377538581962825 | 9.5e-15 |
| 7 | 0.000368653487357218 | 0.000368653487362814 | 5.6e-15 |
| 8 | -0.0000176476876689254 | -0.0000176476876597729 | 9.2e-15 |

Also, $c_0=(\pi/2)\cosh 1/(1+\pi^2/4)=0.699043843795788$ analytically.

**Reference values.** The reference $f$ is the closed-form function. The displayed "max err" is taken over the 500-point grid. The true sup norm, from a 2,000,001-point grid with local refinement:

| $N$ | True sup | Attained at | Script grid value | Title | L2 error |
|---|---|---|---|---|---|
| 0 | 6.990438e-1 | $-1$ | 6.990438e-1 | 0.699 | 5.595637e-1 |
| 1 | 1.086580 | $+1$ | 1.086580 | 1.09 | 4.615072e-1 |
| 2 | 4.400756e-1 | $+1$ | 4.400756e-1 | 0.44 | 2.140138e-1 |
| 3 | 6.221755e-2 | $-1$ | 6.221755e-2 | 0.0622 | 2.687548e-2 |
| 4 | 1.343491e-2 | $+1$ | 1.343491e-2 | 0.0134 | 4.241636e-3 |
| 5 | 4.118655e-3 | $+1$ | 4.118655e-3 | 0.00412 | 1.486948e-3 |
| 6 | 3.797058e-4 | $-1$ | 3.797058e-4 | 0.00038 | 1.347695e-4 |
| 7 | 2.538439e-5 | $+1$ | 2.538439e-5 | 2.54e-5 | 6.487570e-6 |
| 8 | 7.736699e-6 | $+1$ | 7.736699e-6 | 7.74e-6 | 2.334195e-6 |

The maximum is at an endpoint for every $N$, and the endpoints are on the grid, so the grid value is the true sup norm (relative difference at most 6e-10).

**The picture shows what was computed.** In all 9 frames, wherever the dashed red $S_N$ has pixels they lie within 2.15 px of the computed $S_N$ (median about 0.26 px); it is present in 406 to 419 of 618 columns, the rest being dash gaps. Blue $f$ pixels lie within 1.81 px of $f$; their count falls to about 193 of 618 from $S_4$ on, because the red curve is drawn over it once the two coincide. All $S_N$ and $f$ lie inside `ylims=(-1.3, 1.3)`, with no clipping. Each title's index and error match the frame's curve.

### Wiring and legacy archive

- The page links and embeds resolve to the two scripts and GIFs. The manifest and my instrumented reruns both show the committed GIFs are byte-identical to each script's output.
- The page is linked from the section index (`pages/numerical-methods/index.qmd`, line 68).
- **The legacy archive was consulted:** `LegendrePolyMod.html`, Example 6 (`lnk_13`, $P_0..P_5$), Example 8 (`lnk_16`, `lnk_17`), the recurrence image `gr_305`, coefficient images `gr_326`, `gr_330`, `gr_333`, and the function and interval images `gr_323` to `gr_325`. The archive has no animated GIF for this topic.

