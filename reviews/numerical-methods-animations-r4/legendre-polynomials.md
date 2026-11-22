# Legendre Polynomials — animation review (round 4)

Page: `pages/numerical-methods/legendre-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my independent computation and with the frames. Both scripts implement what they claim, and their numbers match exact symbolic values to about 1e-14.

These items were considered and deliberately not raised:
- In frame 1 of `legendrepolyaa.gif`, the title reads "Legendre Polynomials P₀ … P_0", and later frames mix a Unicode subscript with `_n`. This is cosmetic and nothing is misleading.
- In `legendrepolyaa.gif` the legend (`:topright`) covers part of the region near x ∈ [0.63, 0.98], y ∈ [0.67, 1.17], where the curves rise towards (1, 1). The common point (1, 1) is still visible at the right edge in every frame, so the property P_n(1) = 1 can still be read. This is cosmetic.
- Archive Example 8 compares the "discrete interpolation polynomial" with the "Legendre series approximation". The page shows only the Legendre series. It does not claim to reproduce the comparison; it says only that f "is the function of Mathews' Example 8(b)", which is correct (see below). Archive Examples 1–5, 7 and 9 (discrete or continuous least squares, inner products, Gram–Schmidt, shifted Legendre) are not animated. This is an animation page with two cases and claims no completeness, so I did not treat these as silently dropped cases.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `legendrepolyaa.jl` | 0 | 7.1 | legendrepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `legendrepolybb.jl` | 0 | 7.2 | legendrepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro l.12 | "illustrates Legendre polynomials $P_n(x)$ on $[-1,1]$" | both scripts: `x = range(-1,1,…)`, xlims (-1,1) | confirmed |
| 2 | Intro l.12 | "The first animation reveals $P_0$ through $P_5$ one per frame" | aa: `n_max = 5`, loop `0:n_max`, 6 frames; frame k plots P_0..P_{k-1} (contact sheet) | confirmed |
| 3 | Intro l.12 | "the second shows the Legendre series partial sums converging to $f(x)=e^{x}\cos(\pi x/2)$" | bb l.44 `f(x) = exp(x)*cos(π*x/2)`; sup error falls to 7.74e-6 | confirmed |
| 4 | Intro l.14 | Julia sources are linked under each case | l.20 → legendrepolyaa.jl, l.28 → legendrepolybb.jl | confirmed |
| 5 | Case 1 heading | "Successive polynomials $P_0, P_1, \ldots, P_5$" | aa n_max = 5; final frame shows 6 curves labelled P_0..P_5 | confirmed |
| 6 | Case 1 l.18 | "Each $P_n$ is orthogonal to all lower-degree Legendre polynomials on $[-1,1]$" | sympy: ∫P_mP_n = 0 exactly for all 0 ≤ n < m ≤ 5 | confirmed |
| 7 | Case 1 l.18 | "$P_n(1)=1$, $P_n(-1)=(-1)^n$" | sympy Rodrigues, n = 0..5; script's `legendre(n,[±1])` prints the same; frames show the curves meeting at (1,1) and alternating at x = -1 | confirmed |
| 8 | Case 1 l.18 | "$P_n$ has exactly $n$ zeros in $(-1,1)$" | sympy nroots: 0, 1, 2, 3, 4, 5 real roots in (-1,1), e.g. P_2 at ±0.57735, P_5 at 0, ±0.53847, ±0.90618; frames show the same counts of crossings | confirmed |
| 9 | Case 1 l.18 | "computed by the recurrence $(n+1)P_{n+1}=(2n+1)xP_n-nP_{n-1}$" | aa l.20 uses the same recurrence with index k = n+1; sympy verifies the identity for n = 1..4; script output vs closed form max diff 2.1e-15 | confirmed |
| 10 | Case 1 alt text | "P_0 through P_5 added one per frame on the interval [-1, 1], showing their oscillatory character" | frames | confirmed |
| 11 | Case 1 wiring | link legendrepolyaa.jl and embed legendrepolyaa.gif are Case 1 | script writes legendrepolyaa.gif; regeneration byte-identical | confirmed |
| 12 | Case 2 heading | "Legendre series for $f(x)=e^{x}\cos(\pi x/2)$" | bb l.44; frame titles "exp(x)cos(πx/2)" | confirmed |
| 13 | Case 2 l.26 | $S_N=\sum_{n=0}^N c_nP_n$, $c_n=\frac{2n+1}{2}\int_{-1}^1 fP_n\,dx$ | bb l.38–42 and l.55–57 implement exactly this | confirmed |
| 14 | Case 2 l.26 | "converges to $f$ as $N\to\infty$" | f is entire, so the Legendre series converges uniformly on [-1,1]; computed sup errors decrease to 7.7e-6 | confirmed |
| 15 | Case 2 l.26 | "This $f$ is the function of Mathews' Example 8(b)" | archive lnk_17: "8 (b). Use the function" plus image gr_325 = `f[x] = e^x Cos[π/2 x]`, interval image gr_323 = [-1, 1] | confirmed |
| 16 | Case 2 l.26 | "it is neither even nor odd" | f(-x) = e^{-x}cos(πx/2), which is neither f(x) nor -f(x) | confirmed |
| 17 | Case 2 l.26 | "every coefficient $c_0,\ldots,c_8$ is nonzero, so each frame adds a new term" | exact c_n (sympy, 20 digits): 0.69904, 0.38754, -0.64650, -0.39721, -0.056297, 0.0093163, 0.0037754, 0.00036865, -1.7648e-5; all nonzero. 9 frames for n = 0..8 | confirmed |
| 18 | Case 2 l.26 | "Because $S_N$ minimises the integrated squared error rather than the maximum error, the max error need not fall at every step" | residual is orthogonal to P_0..P_N to 2.5e-15 (L2 projection). L2 error decreases monotonically (0.5596, 0.4615, 0.2140, 0.02688, 0.004242, 0.001487, 1.348e-4, 6.488e-6, 2.334e-6) while the sup error rises at N = 1 | confirmed |
| 19 | Case 2 l.26 | max error "rises from 0.699 for $S_0$ to 1.09 for $S_1$" | sup error on a 2,000,001-point grid: 0.699044 (x = -1), 1.08658 (x = 1) | confirmed |
| 20 | Case 2 l.26 | "then falls with each added term to $7.74\times10^{-6}$ for $S_8$" | 1.08658 > 0.440076 > 0.0622176 > 0.0134349 > 0.00411865 > 0.000379706 > 2.53844e-5 > 7.7367e-6, strictly decreasing from N = 1 | confirmed |
| 21 | Case 2 alt text | "partial sums S_0 through S_8 … one per frame; every coefficient is nonzero, and the max error rises from 0.699 for S_0 to 1.09 for S_1, then falls with each added term to 7.74e-6 for S_8" | as in rows 17, 19 and 20; 9 frames | confirmed |
| 22 | Case 2 frames | titles show "max err = 0.699, 1.09, 0.44, 0.0622, 0.0134, 0.00412, 0.00038, 2.54e-5, 7.74e-6" | each agrees with the independent sup error to 3 significant figures (0.44008 → "0.44" and 3.797e-4 → "0.00038" are 3-s.f. rounding with trailing zeros dropped) | confirmed |
| 23 | Case 2 wiring | link legendrepolybb.jl and embed legendrepolybb.gif are Case 2 | script writes legendrepolybb.gif; regeneration byte-identical | confirmed |
| 24 | Case 2 frames | blue solid line = f, red dashed line = S_n (legend) | bb l.68–70; frames | confirmed |

The page has no separate Description section. The method statements it does make (recurrence, coefficient formula) are rows 9 and 13.

### 3. Implementation checks

### `legendrepolyaa.jl`
- **Method:** standard three-term Bonnet recurrence. Line 20, `P_k = ((2k-1)xP_{k-1} - (k-1)P_{k-2})/k`, is the page's recurrence with n = k-1.
- **Numbers:** `aa_check.jl` loads the script's `legendre` and prints values at 11 points and at ±1. For example P_4(0) = 0.375 and P_5(-0.8) = 0.39952, which agree with the closed forms (35x⁴-30x²+3)/8 and (63x⁵-70x³+15x)/8. In `check2.jl`, the maximum difference from the closed forms over the 500-point plotting grid is ≤ 2.1e-15 for n = 0..5. P_n(±1) = (±1)^n holds exactly.
- **Reference values:** none drawn. The closed forms were checked against Rodrigues' formula in sympy (`indep.py`).
- **Picture:** 6 frames, and frame k shows P_0..P_{k-1} with matching legend entries and title index. The y-limits ±1.3 contain every curve, since |P_n| ≤ 1. The zero crossings visible in the frames match the sympy roots. The legend overlaps the upper-right corner; see the non-findings above.

### `legendrepolybb.jl`
- **Method:** Legendre series (continuous L2 projection) truncated at N = 0..8, with coefficients from Gauss–Legendre quadrature. The nodes and weights come from Golub–Welsch: off-diagonal k/√(4k²-1), weights 2·v₁². This is the correct Jacobi matrix for Legendre.
- **Quadrature check (`check2.jl`):** the 20-point rule gives Σw = 2 - 2e-16 and integrates x^k exactly for k ≤ 39 (error ≤ 8e-16). The error first appears at k = 40 (2.8e-12), which is the expected degree of precision 2·20-1 = 39.
- **Numbers:** script coefficients (instrumented `bb_instr.jl`) beside exact symbolic coefficients (`indep.py`, sympy integrate):

| n | script c_n | exact c_n |
|---|---|---|
| 0 | 0.6990438437957872 | 0.69904384379578838941 |
| 1 | 0.38753580939387533 | 0.38753580939387494158 |
| 2 | -0.6465040300987617 | -0.64650403009876636233 |
| 3 | -0.39721354789070035 | -0.39721354789070262905 |
| 4 | -0.0562969811584088 | -0.056296981158408290970 |
| 5 | 0.009316251038287279 | 0.0093162510382933775503 |
| 6 | 0.0037753858196282524 | 0.0037753858196377980065 |
| 7 | 0.000368653487362814 | 0.00036865348735721847366 |
| 8 | -1.764768765977293e-5 | -0.000017647687668925382332 |

  These agree to about 1e-14 absolute. The residual f - S_N is orthogonal to P_0..P_N to 2.5e-15 (60-point GL), so S_N is the least-squares projection.
- **Max errors:** the script computes them on the 500-point grid, which includes x = ±1. The independent sup errors on a 2,000,001-point grid are in rows 19–22 of the ledger and agree to every printed digit. The maximiser is at an endpoint for every N, so the 500-point grid does not under-report.
- **Reference values:** f is evaluated directly from its formula. There is no numerical reference curve.
- **Picture:** 9 frames, titled S_0..S_8 with the max error. The red dashed S_n is drawn from the same `coeffs` and `legendre` as the error. The y-limits ±1.3 contain everything: S ranges over [-0.335, 1.2102] across all N, and max f = 1.2102. The visible gap between the curves shrinks as the title errors say: it is clear in frames 1–4 and indistinguishable from frame 5 on (error 0.0134 and below).

