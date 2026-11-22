# Legendre Polynomials — animation review (round 5)

Page: `pages/numerical-methods/legendre-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page matched my own computation and the frames, and both scripts implement what they say they implement.

Observations that I judged not to be findings, so the owner can overrule me:

- **Case 1 legend placement (cosmetic).** In frames 5–6 of `legendrepolyaa.gif` the `:topright` legend covers roughly x ∈ [0.62, 0.98], y ∈ [0.67, 1.12], which is where P_1…P_5 converge on (1, 1). The curves still come out to (1, 1) at the right edge, so the page's claim $P_n(1)=1$ can still be seen. I did not count it as misleading.
- **No `## Description` section.** The page has no Description section, although `.github/agents/animation-page.agent.md` asks for one. The review standard treats missing content as not a finding. As a result the page has no Description formulas to check. The method formulas it does give, in the Case 1 and Case 2 paragraphs, are checked below.
- **Archive coverage.** Mathews' Examples 1–5, 7 and 9 (discrete vs continuous least squares, inner products, Gram–Schmidt, shifted Legendre) are not animated. Example 8 compares the Legendre series with the *discrete interpolation polynomial*, and the page shows only the series. The page says only that "This $f$ is the function of Mathews' Example 8(b)", and that is accurate. It does not claim to reproduce the comparison, so I did not raise a Fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `legendrepolyaa.jl` | 0 | 6.2 | legendrepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | "illustrates Legendre polynomials $P_n(x)$ on $[-1,1]$" | Both scripts use `x = range(-1,1)` and `xlims=(-1,1)`. Frames confirm. | confirmed |
| 2 | Intro | "The first animation reveals $P_0$ through $P_5$ one per frame" | `n_max = 5`, `@animate for n in 0:n_max` draws k = 0..n. GIF has 6 frames, and frame k+1 adds P_k (contact sheet). | confirmed |
| 3 | Intro | "the second shows the Legendre series partial sums converging to $f(x)=e^{x}\cos(\pi x/2)$" | `f(x) = exp(x)*cos(π*x/2)`. Max error falls to 7.74e-6 (row 15). | confirmed |
| 4 | Intro | "Julia source scripts ... are linked under each case" | Case 1 links `legendrepolyaa.jl`, Case 2 links `legendrepolybb.jl`. | confirmed |
| 5 | Case 1 heading | "Successive polynomials $P_0, P_1, \ldots, P_5$" | Frame titles go from "P₀ … P_0" to "P₀ … P_5". The legend lists P_0(x)..P_5(x). | confirmed |
| 6 | Case 1 | "Each $P_n$ is orthogonal to all lower-degree Legendre polynomials on $[-1,1]$" | Gram matrix of P_0..P_5 by 10-pt Gauss (exact to degree 19): off-diagonal entries 0 to 1e-14, diagonal 2/(2n+1). | confirmed |
| 7 | Case 1 | "$P_n(1)=1$, $P_n(-1)=(-1)^n$" | Script `legendre(n,[-1,…,1])`: P_n(-1) = 1, -1, 1, -1, 1, -1 and P_n(1) = 1 for n = 0..5. Matches `scipy.special.eval_legendre`. | confirmed |
| 8 | Case 1 | "$P_n$ has exactly $n$ zeros in $(-1,1)$" | `legroots`: P_1 {0}, P_2 ±0.57735, P_3 {0, ±0.774597}, P_4 ±0.339981, ±0.861136, P_5 {0, ±0.538469, ±0.906180}. Script curve on the 500-pt grid has 0,1,2,3,4,5 sign changes. | confirmed |
| 9 | Case 1 | "computed by the recurrence $(n+1)P_{n+1} = (2n+1)xP_n - nP_{n-1}$" | Script line 20: `P = ((2k-1)*x*P_{k-1} - (k-1)*P_{k-2})/k`, which is the same recurrence with n = k-1. sympy confirms the recurrence identity for n = 1..4. The script's values at 8 test points equal scipy's to 12 decimals. | confirmed |
| 10 | Case 1 alt text | "P_0 through P_5 added one per frame on the interval [-1, 1], showing their oscillatory character" | Frames 1–6 | confirmed |
| 11 | Case 1 wiring | Link and embed show Case 1 | `legendrepolyaa.jl` → `legendrepolyaa.gif`. The committed GIF is byte-identical to a fresh scratch run (manifest). | confirmed |
| 12 | Case 2 heading | "Legendre series for $f(x) = e^{x}\cos(\pi x/2)$" | Script line 44. The frame title and legend name the same f. | confirmed |
| 13 | Case 2 | "$S_N(x) = \sum_{n=0}^{N} c_n P_n(x)$ with $c_n = \tfrac{2n+1}{2}\int_{-1}^{1} f P_n\,dx$" | Script lines 37–41 and 53–57. The integral is done by 20-pt Gauss–Legendre. Script coefficients agree with mpmath (30 digits) to ≥9 significant digits (table in §3). | confirmed |
| 14 | Case 2 | "converges to $f$ as $N\to\infty$" | L² error² falls monotonically: 0.313, 0.213, 0.0458, 7.22e-4, 1.80e-5, 2.21e-6, 1.82e-8, 4.21e-11, 5.45e-12. f is entire, so the Legendre series converges uniformly. | confirmed |
| 15 | Case 2 | "This $f$ is the function of Mathews' Example 8(b)" | Archive `gr_325.gif` reads `f[x] = e^x Cos[π/2 x]`, and `gr_323.gif` gives the interval `[-1, 1]`. | confirmed |
| 16 | Case 2 | "it is neither even nor odd" | c_1 = 0.3875 ≠ 0 rules out even. c_0 = 0.6990 ≠ 0 rules out odd. | confirmed |
| 17 | Case 2 | "every coefficient $c_0,\ldots,c_8$ is nonzero" | mpmath: 0.699044, 0.387536, -0.646504, -0.397214, -0.0562970, 0.00931625, 0.00377539, 3.68653e-4, -1.76477e-5. The smallest magnitude is c_8 = 1.76e-5, well above quadrature error (~1e-12). | confirmed |
| 18 | Case 2 | "so each frame adds a new term" | 9 frames S_0..S_8. Each adds one nonzero term. | confirmed |
| 19 | Case 2 | "Because $S_N$ minimises the integrated squared error rather than the maximum error, the max error need not fall at every step" | Residual of S_3 is orthogonal to P_0..P_3 (inner products ~1e-32), so S_N is the L² projection. L² error falls monotonically (row 14) while max error rises from S_0 to S_1 (row 20). | confirmed |
| 20 | Case 2 | "it rises from 0.699 for $S_0$ to 1.09 for $S_1$" | Independent: 0.6990 (at x = -1) and 1.0866 (at x = 1). Script prints 0.69904 and 1.08658. Same on a 200 001-pt grid. | confirmed |
| 21 | Case 2 | "then falls with each added term to $7.74\times10^{-6}$ for $S_8$" | Independent max errors S_1..S_8: 1.087, 0.4401, 0.06222, 0.01343, 0.004119, 3.797e-4, 2.538e-5, 7.737e-6. These decrease strictly, and the last is 7.74e-6. The dense grid gives the same 4 significant figures. | confirmed |
| 22 | Case 2 alt text | "partial sums S_0 through S_8 ... one per frame; every coefficient is nonzero, and the max error rises from 0.699 for S_0 to 1.09 for S_1, then falls with each added term to 7.74e-6 for S_8" | Same as rows 17, 18, 20 and 21. Frame titles show 0.699, 1.09, 0.44, 0.0622, 0.0134, 0.00412, 0.00038, 2.54e-5, 7.74e-6. | confirmed |
| 23 | Case 2 wiring | Link and embed show Case 2 | `legendrepolybb.jl` → `legendrepolybb.gif`. Committed GIF is byte-identical to the regenerated one. | confirmed |
| 24 | Frames vs page | Title, legend and final result agree with the page | Frame 9 title reads "S_8(x) (max err = 7.74e-6)". The legend shows f in blue and S_n dashed red. Nothing contradicts the page. | confirmed |

### 3. Implementation checks

### `legendrepolyaa.jl`

- **Method.** It evaluates P_n with the three-term (Bonnet) recurrence from P_0 = 1 and P_1 = x, the same recurrence the page states. The script uses no Rodrigues or explicit formulas.
- **Numbers.** `review/aa_inst.jl` runs the script's own `legendre` function. At x = [-1, -0.7, -0.3, 0, 0.2, 0.55, 0.9, 1] it gives, for example, P_4 = [1, -0.4120625, 0.0729375, 0.375, 0.232, -0.35903515625, 0.2079375, 1] and P_5 = [-1, 0.36519875, -0.34538625, 0, 0.30752, -0.028194804688, -0.04114125, 1]. `review/indep.py` gives the same values to 12 decimals with `scipy.special.eval_legendre`. Over the 500-pt grid the minima are P_2 -0.49999 and P_4 -0.42857; the true minima are -0.5 and -3/7 = -0.428571.
- **Reference values.** None are used.
- **Picture.** Each frame draws `legendre(k, x)` for k = 0..n with labels `P_k(x)`, and the frame-n title is "P₀ … P_n". In frame 6 all curves pass through (1, 1) and alternate between ±1 at x = -1, with 1..5 zero crossings. ylims ±1.3 contain every curve, and nothing is clamped. The only display issue is the legend overlap noted above.

### `legendrepolybb.jl`

- **Method.** It computes the truncated Legendre series (continuous least-squares / L² projection), with coefficients c_n = (2n+1)/2 ∫ f P_n by Gauss–Legendre quadrature. The nodes and weights come from Golub–Welsch: Jacobi matrix with off-diagonal k/√(4k²−1) and weights 2·v₁². Both are correct for Legendre with μ₀ = 2. Property check from the instrumented copy: the weights sum to 2.0, ∫x³⁸ gives 0.051282051282051 against exact 2/39, and ∫x⁴⁰ gives 0.048780487802 against exact 2/41, a 3e-12 miss. That is degree of precision exactly 39 = 2·20−1, as expected.
- **Numbers.** Script coefficients (`bb_inst.jl`) next to mpmath 30-digit quadrature (`indep.py`):

  | n | script c_n | independent c_n |
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

  Max error on the script's 500-pt grid, script versus independent (numpy `legval` with the mpmath coefficients, 500-pt and 200 001-pt grids):

  | N | script | independent (500) | independent (dense) |
  |---|---|---|---|
  | 0 | 0.6990438 | 0.699 | 0.699 |
  | 1 | 1.0865797 | 1.087 | 1.087 |
  | 2 | 0.4400756 | 0.4401 | 0.4401 |
  | 3 | 0.0622176 | 0.06222 | 0.06222 |
  | 4 | 0.0134349 | 0.01343 | 0.01343 |
  | 5 | 0.0041187 | 0.004119 | 0.004119 |
  | 6 | 3.79706e-4 | 3.797e-4 | 3.797e-4 |
  | 7 | 2.53844e-5 | 2.538e-5 | 2.538e-5 |
  | 8 | 7.73670e-6 | 7.737e-6 | 7.737e-6 |

  Least-squares property: the residual f − S_3 has inner products with P_0..P_3 of order 1e-32.
- **Reference values.** The reference curve is the closed-form f, evaluated directly. Its maximum is 1.2102 at x ≈ 0.361 and f(±1) = 0, inside ylims ±1.3.
- **Picture.** Frame n draws f (solid blue) and S_n (dashed red), with S_n summed from `coeffs[1:n+1]`. Each title shows S_n and its max error rounded to 3 significant figures. I checked the titles of all 9 frames against the script values above. The S_n range never leaves ±1.3: the lowest value is S_2(−1) = −0.335 and the highest S_n max is 1.2102. Nothing is clamped. Frame 2 at full resolution shows the S_1 line from 0.31 to 1.09, which matches c_0 ∓ c_1.

### Wiring / regeneration

The manifest shows both committed GIFs byte-identical to scratch reruns of the unchanged scripts. Frame counts are 6 and 9, which match the page.

