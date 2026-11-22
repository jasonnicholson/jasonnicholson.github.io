# Legendre Polynomials — animation review (round 3)

Page: `pages/numerical-methods/legendre-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, no Misleading and no Minor finding.

Observations below the threshold for a finding:
- In `legendrepolyaa.gif` frames 5 and 6, the `:topright` legend covers roughly x in [0.63, 0.99] and y in [0.66, 1.2]. This hides part of the approach of P1, P2, P3 and P5 to (1, 1). The point x = 1 itself is still visible at the right border, where every curve visibly ends at 1 and P1, P3 and P5 start at -1 on the left. The property P_n(1) = 1 can still be read, so this is cosmetic.
- Fidelity, judged not a finding. Mathews' Example 8 compares the Legendre series with the discrete interpolation polynomial. Example 8(a) uses n = 4 (`gr_326.gif`). The graphs and code for 8(b) (`gr_336` to `gr_345`) are missing from the archive, so its degree cannot be read. The page's Case 2 claims only that f is the function of Example 8(b), and that is true (`gr_325.gif`: `f[x] = e^x Cos[π/2 x]` on `[-1, 1]`, from `gr_323.gif`). The page shows partial sums up to N = 8 and no interpolation comparison. That is a different presentation, not a contradiction. Example 8(a) (f = e^x) has no animation. I count that as content the page does not have, not a silent change to a case it presents.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `legendrepolyaa.jl` | 0 | 5.8 | legendrepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `legendrepolybb.jl` | 0 | 7.6 | legendrepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|---|
| 1 | Intro | "illustrates Legendre polynomials $P_n(x)$ on $[-1,1]$" | confirmed | Both scripts use `x = range(-1, 1, length=500)` and `xlims=(-1, 1)` |
| 2 | Intro | "The first animation reveals $P_0$ through $P_5$ one per frame" | confirmed | `for n in 0:5` gives 6 frames. Committed GIF has 6 frames; titles run "P₀ … P_0" to "P₀ … P_5"; the legend gains one entry per frame |
| 3 | Intro | "the second shows the Legendre series partial sums converging to $f(x)=e^x\cos(\pi x/2)$" | confirmed | `f(x) = exp(x)*cos(π*x/2)`. Max error falls to 7.74e-6 (row 15) |
| 4 | Intro | "Julia source scripts ... are linked under each case" | confirmed | Each case has a `[Julia source]` link |
| 5 | Case 1 heading | "Successive polynomials $P_0,\ldots,P_5$" | confirmed | `n_max = 5` |
| 6 | Case 1 | "Each $P_n$ is orthogonal to all lower-degree Legendre polynomials on $[-1,1]$" | confirmed | Gram matrix of the script's `legendre` with 10-point Gauss-Legendre: off-diagonal entries 0 to 1e-12, diagonal [2, 0.6667, 0.4, 0.2857, 0.2222, 0.1818] = 2/(2n+1) |
| 7 | Case 1 | "$P_n(1)=1$, $P_n(-1)=(-1)^n$" | confirmed | Script values: P(1) = 1.0 for n = 0..5; P(-1) = 1, -1, 1, -1, 1, -1 |
| 8 | Case 1 | "$P_n$ has exactly $n$ zeros in $(-1,1)$" | confirmed | numpy `legroots`: 0, 1, 2, 3, 4, 5 roots, all in (-1, 1) (for example P5: ±0.9062, ±0.5385, 0) |
| 9 | Case 1 | "computed by the recurrence $(n+1)P_{n+1}=(2n+1)xP_n-nP_{n-1}$" | confirmed | Code line 20: `P = ((2k-1)*x*P_{k-1} - (k-1)*P_{k-2})/k`, which is the same recurrence with k = n+1. Its output matches the closed forms of P0 to P5 to 2.3e-15 at 2001 points |
| 10 | Case 1 alt text | "P_0 through P_5 added one per frame on the interval [-1, 1], showing their oscillatory character" | confirmed | Frames 1 to 6 (contact sheet). The number of oscillations grows with n |
| 11 | Case 1 wiring | link `legendrepolyaa.jl`, embed `legendrepolyaa.gif` | confirmed | The script writes `legendrepolyaa.gif` and the regenerated GIF is byte-identical |
| 12 | Case 2 heading | "Legendre series for $f(x)=e^{x}\cos(\pi x/2)$" | confirmed | Code line 44. The frame titles say the same |
| 13 | Case 2 | "$S_N=\sum_{n=0}^N c_nP_n$, $c_n=\tfrac{2n+1}{2}\int_{-1}^1 fP_n\,dx$" | confirmed | Code lines 37 to 41 and 53 to 57 implement exactly this. Coefficients agree with mpmath to ≤ 1e-14 (table in section 3) |
| 14 | Case 2 | "converges to $f$ as $N\to\infty$" | confirmed | f is entire, so the Legendre series converges uniformly. The computed max errors fall to 7.74e-6 at N = 8 |
| 15 | Case 2 | "This $f$ is the function of Mathews' Example 8(b)" | confirmed | Archive `LegendrePolyMod_gr_325.gif`: `f[x] = e^x Cos[π/2 x]`, interval `[-1, 1]` (`gr_323.gif`) |
| 16 | Case 2 | "it is neither even nor odd" | confirmed | f(-x) = e^{-x}cos(πx/2), which is neither f(x) nor -f(x). The odd and even coefficients are both nonzero |
| 17 | Case 2 | "every coefficient $c_0,\ldots,c_8$ is nonzero, so each frame adds a new term" | confirmed | The smallest is \|c8\| = 1.765e-5; all nine are nonzero (section 3) |
| 18 | Case 2 | "$S_N$ minimises the integrated squared error rather than the maximum error" | confirmed | The residual f - S_N is orthogonal to P0..PN: inner products ≤ 2.5e-15 for N = 1, 4, 8 (80-point Gauss-Legendre) |
| 19 | Case 2 | "max error ... rises from 0.699 for $S_0$ to 1.09 for $S_1$" | confirmed | Script: 0.69904, 1.08658. Independent, on a 200001-point grid: 0.699044, 1.08658 |
| 20 | Case 2 | "then falls with each added term to $7.74\times10^{-6}$ for $S_8$" | confirmed | The sequence for N = 1..8 is 1.087, 0.440, 0.0622, 0.0134, 0.00412, 3.80e-4, 2.54e-5, 7.74e-6, strictly decreasing. The 500-point grid and the 200001-point grid agree because the maximum is at x = ±1, which is on the grid |
| 21 | Case 2 alt text | "partial sums S_0 through S_8 ... one per frame; every coefficient is nonzero, and the max error rises from 0.699 ... to 1.09 ..., then falls ... to 7.74e-6" | confirmed | 9 frames; titles read S_0 to S_8 with max err 0.699, 1.09, 0.44, 0.0622, 0.0134, 0.00412, 0.00038, 2.54e-5, 7.74e-6 |
| 22 | Case 2 wiring | link `legendrepolybb.jl`, embed `legendrepolybb.gif` | confirmed | The script writes `legendrepolybb.gif` and the regenerated GIF is byte-identical |

The page has no Description section, so there are no method claims outside the Animations section. I did not report the missing section, because the standard excludes content the page does not yet have.

---

### 3. Implementation checks

### `legendrepolyaa.jl`

- **Method:** the three-term Bonnet recurrence for Legendre polynomials, as claimed. It is the same form as the archive's recurrence (`gr_305.gif`: p_k = (1/k)((2k-1)x p_{k-1} - (k-1)p_{k-2})).
- **Numbers:** P0 to P5 from the script differ from the closed forms (1, x, (3x²-1)/2, (5x³-3x)/2, (35x⁴-30x²+3)/8, (63x⁵-70x³+15x)/8) by at most 2.3e-15 over 2001 points. The orthogonality and norms are correct (ledger rows 6 to 8).
- **Reference values:** none are used.
- **Picture:** frame k shows P0..P_{k-1}, with matching legend entries and the title "P₀ … P_{k-1}". The ylims (-1.3, 1.3) contain the full range [-1, 1]. Interior extrema visible in frame 6 are P2 min -0.5 at 0 and P4 min -0.4286, consistent with the computed minima. The curves agree with the archive's static plot `gr_311.gif` (P0 to P5 on [-1, 1]). Legend overlap is noted in section 1 as cosmetic.

### `legendrepolybb.jl`

- **Method:** truncated Legendre series (continuous least-squares projection), as claimed. The coefficients come from 20-point Gauss-Legendre quadrature built by Golub-Welsch. The Jacobi off-diagonal is k/√(4k²-1) and the weights are 2·v₁², which is correct for μ₀ = 2. Nodes and weights match numpy `leggauss(20)` to 1.4e-15 and 2.3e-15. The degree-of-precision check gives exact results for x^38 and x^39 (errors 5e-16 and 8e-16) and an error of 2.8e-12 for x^40, consistent with degree 2m-1 = 39.
- **Numbers:** script coefficients against independent values (mpmath quad, 30 digits):

| n | script c_n | independent c_n |
|---|---|---|
| 0 | 0.6990438437957872 | 0.699043843795788 (= 2π cosh 1/(4+π²)) |
| 1 | 0.38753580939387533 | 0.387535809393875 |
| 2 | -0.6465040300987617 | -0.646504030098766 |
| 3 | -0.39721354789070035 | -0.397213547890703 |
| 4 | -0.0562969811584088 | -0.0562969811584083 |
| 5 | 0.009316251038287279 | 0.00931625103829338 |
| 6 | 0.0037753858196282524 | 0.0037753858196378 |
| 7 | 0.000368653487362814 | 0.000368653487357218 |
| 8 | -1.764768765977293e-5 | -1.76476876689254e-5 |

  Max errors, script (500-point grid) against independent (500-point and 200001-point grids):

| N | script | independent (500) | independent (200001) | location |
|---|---|---|---|---|
| 0 | 0.6990438 | 0.699044 | 0.699044 | x = ±1 |
| 1 | 1.0865797 | 1.08658 | 1.08658 | x = 1 |
| 2 | 0.4400756 | 0.440076 | 0.440076 | x = 1 |
| 3 | 0.0622176 | 0.0622176 | 0.0622176 | x = -1 |
| 4 | 0.0134349 | 0.0134349 | 0.0134349 | x = 1 |
| 5 | 0.00411865 | 0.00411865 | 0.00411865 | x = 1 |
| 6 | 3.79706e-4 | 3.79706e-4 | 3.79706e-4 | x = -1 |
| 7 | 2.53844e-5 | 2.53844e-5 | 2.53844e-5 | x = 1 |
| 8 | 7.73670e-6 | 7.7367e-6 | 7.7367e-6 | x = 1 |

- **Reference values:** f is evaluated directly. The "max err" is measured on the plotting grid, which contains the endpoints where every maximum lies, so the grid value equals the true supremum to the digits shown.
- **Picture:** each frame plots f (blue) and S_n (red dashed), with the title S_n and the rounded max err for the same n. The ylims (-1.3, 1.3) contain every curve: f ranges over [0, 1.2102] (max at x = 0.3609); the S_N extremes are -0.335 (S_2 at -1) and 1.2102. Nothing is clamped. Frames 1 to 3 show visible gaps: S_0 is a constant at 0.699 and S_1 a line from 0.31 to 1.09, both consistent with the coefficients. From S_4 on the curves overlap at plot resolution, which is consistent with errors ≤ 0.013.

