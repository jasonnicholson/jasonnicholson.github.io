# Legendre Polynomials — animation review (round 9)

Page: `pages/numerical-methods/legendre-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, in the script headers and in the frames was confirmed against independent computation (see the ledger below).

Items considered and not reported as findings:
- Frame 1 of `legendrepolyaa.gif` is titled "Legendre Polynomials P₀ … P_0", and the titles mix a Unicode subscript with `_n`. This is cosmetic and not misleading.
- Fidelity: Mathews' Example 8 compares the discrete interpolation polynomial with the Legendre series for 8(a) f = e^x and 8(b) f = e^x cos(πx/2) on [-1, 1]. The page animates only the Legendre series for 8(b), names it as 8(b), and claims no comparison. Case 1 (P_0 to P_5) corresponds to Mathews' Example 6, which lists the same six polynomials. The archive's solution images for lnk_17 (gr_336 to gr_345) are not present on disk, so Mathews' degree N could not be compared. The page only selects examples and makes no claim of complete coverage, so I do not count the omission of 8(a) as a reader-relevant departure.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `legendrepolyaa.jl` | 0 | 6.5 | legendrepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `legendrepolybb.jl` | 0 | 8.2 | legendrepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | Intro: "illustrates Legendre polynomials $P_n(x)$ on $[-1,1]$" | both scripts use `x = range(-1,1,500)`, xlims (-1,1) | confirmed |
| 2 | Intro: "The first animation reveals $P_0$ through $P_5$ one per frame" | aa: `for n in 0:5`, 6 frames; sheet shows P_0 alone, then one added per frame | confirmed |
| 3 | Intro: "the second shows the Legendre series partial sums converging to $f(x)=e^x\cos(\pi x/2)$" | bb line 44 `f(x)=exp(x)*cos(π*x/2)`; max error falls to 7.74e-6 | confirmed |
| 4 | Heading Case 1: "Successive polynomials $P_0,\ldots,P_5$" | `n_max = 5` | confirmed |
| 5 | "Each $P_n$ is orthogonal to all lower-degree Legendre polynomials on $[-1,1]$" | mpmath Gram matrix, n ≤ 5: off-diagonals 0 to 12 dp, diagonal 2/(2n+1) | confirmed |
| 6 | "$P_n(1)=1$, $P_n(-1)=(-1)^n$" | numpy Legendre basis n = 0..5; script values at ±1 are exactly ±1 (aa_instr2) | confirmed |
| 7 | "$P_n$ has exactly $n$ zeros in $(-1,1)$" | numpy roots: 0,1,2,3,4,5 real roots in (-1,1); script sign changes on the grid: 0,1,2,3,4,5 | confirmed |
| 8 | "computed by the recurrence $(n+1)P_{n+1}=(2n+1)xP_n-nP_{n-1}$" | aa line 20: `P_k = ((2k-1)x P_{k-1} - (k-1)P_{k-2})/k`, which is the same recurrence with n = k-1; script values at 7 points match scipy `eval_legendre` to 8 dp | confirmed |
| 9 | Case 1 link `legendrepolyaa.jl` and embed `legendrepolyaa.gif` | the script writes that GIF; the GIF is byte-identical to regen | confirmed |
| 10 | Alt 1: "P_0 through P_5 added one per frame on the interval [-1, 1], showing their oscillatory character" | frames | confirmed |
| 11 | Heading Case 2: "Legendre series for $f(x)=e^x\cos(\pi x/2)$" | bb line 44 and frame titles | confirmed |
| 12 | $S_N=\sum_{n=0}^N c_nP_n$, $c_n=\frac{2n+1}{2}\int_{-1}^1 fP_n\,dx$ | bb lines 38-42 and 54-57 | confirmed |
| 13 | "converges to $f$ as $N\to\infty$" | max error 0.699 → 7.74e-6 by N = 8; L2 error 0.560 → 2.33e-6 | confirmed |
| 14 | "This $f$ is the function of Mathews' Example 8(b)" | archive gr_325 = `f[x] = e^x Cos[π/2 x]`, interval gr_323 = [-1, 1] | confirmed |
| 15 | "it is neither even nor odd" | f(0.5) = 1.1658, f(-0.5) = 0.4289 | confirmed |
| 16 | "every coefficient $c_0,\ldots,c_8$ is nonzero, so each frame adds a new term" | mpmath c = 0.699044, 0.387536, -0.646504, -0.397214, -0.0562970, 0.00931625, 0.00377539, 0.000368653, -1.76477e-5 | confirmed |
| 17 | "$S_N$ minimises the integrated squared error rather than the maximum error" | residual of S_8 is orthogonal to P_0..P_8 (all ≤ 4e-32); L2 error decreases monotonically | confirmed |
| 18 | "the max error need not fall at every step" | it rises from S_0 to S_1 | confirmed |
| 19 | "rises from 0.699 for $S_0$ to 1.09 for $S_1$" | 0.699044, 1.08658 (grid and fine grid agree; attained at x = -1 and x = 1) | confirmed |
| 20 | "then falls with each added term to $7.74\times10^{-6}$ for $S_8$" | S_1..S_8: 1.08658, 0.440076, 0.0622176, 0.0134349, 0.00411865, 0.000379706, 2.53844e-5, 7.7367e-6, strictly decreasing | confirmed |
| 21 | Case 2 link `legendrepolybb.jl` and embed `legendrepolybb.gif` | the script writes that GIF; byte-identical to regen | confirmed |
| 22 | Alt 2: "S_0 through S_8 ... one per frame; every coefficient is nonzero, ... 0.699 ... 1.09 ... 7.74e-6" | 9 frames, titles S_0..S_8; numbers as in rows 16, 19 and 20 | confirmed |
| 23 | Frame titles "max err = 0.699, 1.09, 0.44, 0.0622, 0.0134, 0.00412, 0.00038, 2.54e-5, 7.74e-6" | independent values above, rounded to 3 s.f. (0.00038 is 0.000380 with the trailing zero dropped) | confirmed |
| 24 | Script header bb lines 2-4: "Example 8(b) ... neither even nor odd ... every coefficient c_0 ... c_8 is nonzero" | as in rows 14-16 | confirmed |

### 3. Implementation checks

### `legendrepolyaa.jl`
- **Method:** a three-term Legendre recurrence starting from P_0 = 1 and P_1 = x. It is correctly indexed: at step k it computes P_k from P_{k-1} and P_{k-2}.
- **Numbers:** values at x = -1, -2/3, ..., 1 for n = 0..5 match scipy `eval_legendre` to 8 dp. For example, P_4(-2/3) is -0.42746914 in both, and P_5(-1/3) is -0.33333333 in both. On the plot grid, min P_2 = -0.49999 (true value -0.5 at x = 0, which is not a grid point) and min P_4 = -0.42857 (true -3/7).
- **Reference values:** none.
- **Picture:** frames 1-6 show the right curves in the right order with legend labels P_0..P_5. Every curve lies inside ylims (-1.3, 1.3), so nothing is clipped. Endpoint values and zero counts are visibly correct in the frames.

### `legendrepolybb.jl`
- **Method:** a truncated Legendre (continuous least-squares) series. The coefficients come from c_n = (2n+1)/2 ∫ f P_n, evaluated by 20-point Gauss-Legendre quadrature. The nodes and weights come from Golub-Welsch, using off-diagonal k/√(4k²-1) and weights 2·v₁². Both are correct for the Legendre weight on [-1, 1], with μ₀ = 2.
- **Quadrature check (bb_instr.jl):** Σw = 2.0000000000000000. ∫x^38 = 0.05128205128205075 against the exact 2/39 = 0.05128205128205128, so it is exact. ∫x^40 = 0.04878048780205 against the exact 0.04878048780488, so it is not exact. This confirms degree of precision 39, as 20 points should give.
- **Coefficients (script vs mpmath, 30 digits):**

| n | script | independent |
|---|---|---|
| 0 | 0.6990438437957872 | 0.699043843796 |
| 1 | 0.38753580939387533 | 0.387535809394 |
| 2 | -0.6465040300987617 | -0.646504030099 |
| 3 | -0.39721354789070035 | -0.397213547891 |
| 4 | -0.0562969811584088 | -0.0562969811584 |
| 5 | 0.009316251038287279 | 0.00931625103829 |
| 6 | 0.0037753858196282524 | 0.00377538581964 |
| 7 | 0.000368653487362814 | 0.000368653487357 |
| 8 | -1.764768765977293e-5 | -1.76476876689e-5 |

- **Max error (script vs independent 500-point grid vs 200001-point grid):** S_0 0.69904/0.699044/0.699044; S_1 1.08658/1.08658/1.08658; S_2 0.440076 for all three; S_3 0.0622176; S_4 0.0134349; S_5 0.00411865; S_6 0.000379706; S_7 2.53844e-5; S_8 7.7367e-6 (script 7.736699e-6). Every maximum is attained at x = ±1, which are grid points, so the grid maximum equals the true supremum.
- **Reference:** f is evaluated analytically, so nothing needs verifying.
- **Picture:** f is drawn solid blue and S_n dashed red, with titles carrying the right index and error. S_2(-1) = -0.335 and S_1(1) = 1.087 both lie inside ylims (-1.3, 1.3), so nothing is clipped. The legend at bottom right does not cover the curves. In frames 5-9 the curves are visually indistinguishable, which is consistent with errors of 1e-2 or less.

