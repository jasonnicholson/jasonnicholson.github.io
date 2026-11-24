# Legendre Polynomials — animation review (round 8)

Page: `pages/numerical-methods/legendre-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0.

Things examined and judged not to be findings:
- Case 1 legend (top right) covers part of the region where all curves approach $(1,1)$. A zoomed crop of the last frame (`review/aa_f6_corner.png`) shows all six curves still visibly meet at $(1,1)$ right of the legend box, so the claim $P_n(1)=1$ stays readable.
- Plot titles and labels render `P_5`, `S_1` etc. with a literal underscore (mixed with a Unicode `P₀`). Cosmetic only; the index shown is correct.
- The page has no `## Description` section, which the authoring conventions require. That is missing content, not a false claim, so it is out of scope under the review standard.
- Fidelity: Mathews' Example 8 compares the Legendre series with the discrete interpolation polynomial and uses degree n = 4 (seen in gr_326 for 8(a)). The page's Case 2 uses Mathews' 8(b) function $e^x\cos(\pi x/2)$ on $[-1,1]$ (confirmed from gr_325 and gr_323), extends the series to degree 8, and leaves out the interpolation-polynomial comparison and 8(a) ($f=e^x$). The page makes no claim to reproduce Mathews' degree or comparison, it names the function's source correctly, and the archive has no legacy animation for this topic (nothing under `a2001/Animations/` matches "legend"). I did not count this as a reader-relevant departure. The 8(b) result graphs (gr_336–gr_345) are missing from the archive, so I could not see Mathews' 8(b) figures.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `legendrepolyaa.jl` | 0 | 6.0 | legendrepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `legendrepolybb.jl` | 0 | 7.8 | legendrepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| 1 | "illustrates Legendre polynomials $P_n(x)$ on $[-1,1]$" | Both scripts use `x = range(-1,1,500)` and `xlims=(-1,1)`; frames confirm | confirmed |
| 2 | "The first animation reveals $P_0$ through $P_5$ one per frame" | `n_max=5`, loop `0:n_max`; 6 committed frames, frame k shows P_0..P_{k-1} (contact sheet) | confirmed |
| 3 | "the second shows the Legendre series partial sums converging to $f(x)=e^{x}\cos(\pi x/2)$" | `f(x)=exp(x)*cos(π*x/2)`; max error falls to 7.74e-6 by S_8 | confirmed |
| 4 | Case 1 heading "Successive polynomials $P_0,\ldots,P_5$" | as #2 | confirmed |
| 5 | "Each $P_n$ is orthogonal to all lower-degree Legendre polynomials on $[-1,1]$" | mpmath: max \|∫P_nP_m\| over m<n, n≤5 = 2e-34 | confirmed |
| 6 | "$P_n(1)=1$, $P_n(-1)=(-1)^n$" | script values at ±1 for n=0..5: (1,1),(−1,1),(1,1),(−1,1),(1,1),(−1,1); mpmath agrees; visible in frame 6 | confirmed |
| 7 | "$P_n$ has exactly $n$ zeros in $(-1,1)$" | numpy roots: P1 {0}; P2 ±0.5774; P3 0, ±0.7746; P4 ±0.3400, ±0.8611; P5 0, ±0.5385, ±0.9062; frame 6 crossings match | confirmed |
| 8 | "computed by the recurrence $(n+1)P_{n+1}=(2n+1)xP_n-nP_{n-1}$" | script line 20: `P = ((2k-1)*x*P_{k-1} - (k-1)*P_{k-2})/k`, the same recurrence with k=n+1; values checked against closed forms (e.g. P_4(0.3)=0.0729375, P_5(−0.5)=−0.08984375) | confirmed |
| 9 | Case 1 link `legendrepolyaa.jl` and embed `legendrepolyaa.gif` | file exists, is the P_0..P_5 script; committed GIF byte-identical to regen (md5 efe6f7c3…) | confirmed |
| 10 | Case 1 alt: "P_0 through P_5 added one per frame on the interval [-1, 1], showing their oscillatory character" | frames | confirmed |
| 11 | Case 2 heading: Legendre series for $e^x\cos(\pi x/2)$ | script line 44 | confirmed |
| 12 | "$S_N(x)=\sum_{n=0}^N c_nP_n(x)$ with $c_n=\tfrac{2n+1}{2}\int_{-1}^1 fP_n\,dx$" | script lines 37–41 and 53–57 implement exactly this (20-point Gauss–Legendre for the integral) | confirmed |
| 13 | "converges to $f$ as $N\to\infty$" | f is entire; L2 and sup errors decrease to ~1e-6 by N=8 | confirmed |
| 14 | "This $f$ is the function of Mathews' Example 8(b)" | archive gr_325: `f[x] = e^x Cos[π/2 x]`, interval [-1,1] (gr_323) | confirmed |
| 15 | "it is neither even nor odd" | f(0.5)=1.1658, f(−0.5)=0.4289, both nonzero and unequal in magnitude | confirmed |
| 16 | "every coefficient $c_0,\ldots,c_8$ is nonzero, so each frame adds a new term" | coefficients (below), smallest \|c_8\|=1.76e-5; 9 frames S_0..S_8 | confirmed |
| 17 | "$S_N$ minimises the integrated squared error rather than the maximum error" | standard property; L2 error decreases monotonically 0.560, 0.462, 0.214, 0.0269, 0.00424, 0.00149, 1.35e-4, 6.49e-6, 2.33e-6 | confirmed |
| 18 | "max error ... rises from 0.699 for $S_0$ to 1.09 for $S_1$" | independent sup on 200001 points: 0.699044 (at x=−1), 1.08658 (at x=1) | confirmed |
| 19 | "then falls with each added term to $7.74\times10^{-6}$ for $S_8$" | sup errors S_2..S_8: 0.440076, 0.0622176, 0.0134349, 0.00411865, 3.79706e-4, 2.53844e-5, 7.7367e-6, strictly decreasing | confirmed |
| 20 | Case 2 link `legendrepolybb.jl` and embed `legendrepolybb.gif` | correct files; committed GIF byte-identical to regen (md5 18e3c6df…) | confirmed |
| 21 | Case 2 alt text (S_0..S_8 one per frame, nonzero coefficients, 0.699 → 1.09 → 7.74e-6) | as #16, #18, #19; frame titles show 0.699, 1.09, 0.44, 0.0622, 0.0134, 0.00412, 0.00038, 2.54e-5, 7.74e-6 | confirmed |
| 22 | Frame titles (Case 2) report "max err" for S_n | the 500-point grid max equals the true sup to 6 significant digits, since the sup is at an endpoint and the grid includes both endpoints | confirmed |

### 3. Implementation checks

### `legendrepolyaa.jl`
- **Method:** the three-term Bonnet recurrence for Legendre polynomials, as the page states.
- **Numbers:** instrumented copy printed P_n at x = −1, −0.5, 0.3, 1 for n = 0..5. All match closed forms, e.g. P_2(0.3) = −0.365, P_3(−0.5) = 0.4375, P_4(0.3) = 0.0729375, P_5(0.3) = 0.34538625. Properties checked independently (mpmath): orthogonality to 2e-34, endpoint values, zero counts and locations.
- **Reference values:** none drawn.
- **Picture:** 6 frames, frame k adds P_{k-1} in a distinct colour with a matching legend entry. ylims ±1.3 contain every curve (|P_n| ≤ 1). Extrema visible in frame 6 match computation (P_2 min −0.5 at 0; P_3 local extrema ±0.447; P_4 min −0.4286; P_5 interior extrema ±0.4197). The committed GIF is byte-identical to the regenerated one.

### `legendrepolybb.jl`
- **Method:** a truncated Legendre (continuous least-squares) series, with coefficients by 20-point Gauss–Legendre via Golub–Welsch. The Jacobi matrix off-diagonal k/√(4k²−1) and weights 2·v₁² are correct for the Legendre weight.
- **Numbers:** script coefficients against independent mpmath adaptive quadrature (30 digits):

| n | script c_n | mpmath c_n |
|---|---|---|
| 0 | 0.6990438437957872 | 0.699043843795788 |
| 1 | 0.38753580939387533 | 0.387535809393875 |
| 2 | −0.6465040300987617 | −0.646504030098766 |
| 3 | −0.39721354789070035 | −0.397213547890703 |
| 4 | −0.0562969811584088 | −0.0562969811584083 |
| 5 | 0.009316251038287279 | 0.00931625103829338 |
| 6 | 0.0037753858196282524 | 0.0037753858196378 |
| 7 | 0.000368653487362814 | 0.000368653487357218 |
| 8 | −1.764768765977293e-5 | −1.76476876689254e-5 |

  They agree to about 1e-14, far below anything plotted or quoted. Max errors, script (500-point grid) against independent (200001-point grid): 0.699044/0.699044, 1.08658/1.08658, 0.440076/0.440076, 0.0622176/0.0622176, 0.0134349/0.0134349, 0.00411865/0.00411865, 3.79706e-4/3.79706e-4, 2.53844e-5/2.53844e-5, 7.7367e-6/7.7367e-6.
- **Reference values:** the "exact" curve is f evaluated directly, which is correct.
- **Picture:** 9 frames S_0..S_8. The red dashed S_n and blue f are drawn from the computed arrays, and the title index and max-err match the printed values. The partial sums span [−0.335, 1.087] and f spans [0, 1.2102], all inside ylims ±1.3, so nothing is clipped. The bottom-right legend sits below y = 0 and covers no curve. The committed GIF is byte-identical to the regenerated one.

Repository not modified (`git status --porcelain` on the page folder is empty; instrumented copies had the `gif(...)` line removed).

