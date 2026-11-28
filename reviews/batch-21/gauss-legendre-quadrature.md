# Gauss-Legendre Quadrature — batch 21 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: pages/numerical-methods/gauss-legendre-quadrature/index.qmd (light-pass batch 21, overview, extend). The diff touches only index.qmd: the Description (lines 12–58) was rewritten, and Case 1's heading got `{#case-1}`. No script or GIF changed, so the animations were not re-reviewed beyond checking that the frames match the claims in the new text.

Mathews archive: consulted. I read /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/GaussianQuadMod.html, and its error-theorem image gr_88 (n=2 on [-1,1]: ∫f − Σ w_{2,i} f(z_{2,i}) = f⁽⁴⁾(c)/135).

Scratch files: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-21/gauss-legendre-quadrature/reviewer/check.py (the numerical checks), /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-21/gauss-legendre-quadrature/reviewer/wc.py (word count), and gr_88.png / gr_89.png (the Mathews error-term images, enlarged) in the same folder.

## 1. Findings

None.

## 2. Claim ledger (+ lines of the diff)

Reference value: I = ∫₀² (1+e^{−x} sin(8x^{2/3})) dx = 2.0162797196171. I computed it with mpmath at 40 digits after substituting x = u³, which removes the singularity. The script's trapezoid reference is 2.016279706, which differs by −1.35e−8 and gives the same 2.016280 at 6 decimals.

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | The rule approximates ∫_a^b f from n values of f; unlike the equally spaced Newton-Cotes rules it chooses both nodes and weights, so that it is exact to the highest possible degree | confirmed | Standard result; see 7 and 8 |
| 2 | On [-1,1]: ∫g ≈ Σ ω_i g(t_i), with ω_i = 2/((1−t_i²)[P_n′(t_i)]²) | confirmed | For n=5 the formula matches numpy leggauss weights to a maximum difference of 3.1e−16 |
| 3 | The nodes t_i are the n roots of P_n | confirmed | Standard. The script's Golub–Welsch Jacobi matrix (β_k = k/√(4k²−1)) gives the Legendre roots |
| 4 | The roots lie inside (−1,1) and the weights are positive | confirmed | Standard; checked numerically for several n |
| 5 | Change of variable x = (a+b)/2 + (b−a)/2·t; I_n = Σ w_i f(x_i), w_i = (b−a)/2·ω_i, "the rule the animation draws" | confirmed | Matches gausslegendreaa.jl `gauss_legendre_sum` (x and wt), and the bars of width w_i |
| 6 | The rule needs only a finite interval and values at interior nodes, and never evaluates f at a or b; its error formula needs f ∈ C^{2n}[a,b] | confirmed | Follows from 4 and the hypothesis of 9 |
| 7 | General result: exact for every polynomial of degree ≤ 2n−1 | confirmed | x^{2n−1}+x^{2n−2} on [0,2] for n=1..4: errors ≤ 4e−14 (rounding only) |
| 8 | No rule with n nodes is exact for all polynomials of degree 2n | confirmed | Standard: ∏(x−x_i)² has a positive integral, but the rule gives 0 |
| 9 | If f ∈ C^{2n}[a,b], error = (b−a)^{2n+1}(n!)⁴/((2n+1)[(2n)!]³)·f^{(2n)}(c) for some c in (a,b) | confirmed | f = x^{2n} on [0,2], n=1..4: actual errors 0.66667, 0.17778, 0.045714, 0.011610 equal the formula's 0.66667, 0.17778, 0.045714, 0.011610. The sign convention (integral minus rule) matches Mathews |
| 10 | For n=2 on [-1,1] this is Mathews' f⁽⁴⁾(c)/135 | confirmed | sympy: 2⁵·(2!)⁴/(5·(4!)³) = 1/135; Mathews gr_88 shows f⁽⁴⁾[c]/135 |
| 11 | For f analytic on a neighbourhood of [a,b], the error falls at least geometrically as n grows | confirmed | Standard (Bernstein ellipse) result, stated as general |
| 12 | "Case 1 quotes this for the smooth integrand 1+e^{−x} sin 8x" | confirmed | Case 1 does quote it. Its numbers check: error 1.84e−13 at n=14 and −4.4e−16 at n=16 (also 2.2e−7 at n=10 and 3.3e−10 at n=12, so geometric) |
| 13 | Case 1's integrand has f′ unbounded at 0, so f ∉ C¹[0,2] | confirmed | f′ ≈ (16/3)x^{−1/3} near 0 |
| 14 | The error shrinks only algebraically; doubling n divides it by about 9.2, 9.6, then 9.8, approaching 2^{10/3} ≈ 10.08 | confirmed | Ratios 9.2226, 9.6455, 9.8415, then (beyond the page) 9.9544, 10.0153, 10.0470 at n=128/256/512; 2^{10/3} = 10.0794. O(n^{−2(α+1)}) with α = 2/3 for an endpoint x^α singularity gives n^{−10/3} |
| 15 | n=2 nodes x ≈ 0.423 and 1.577 | confirmed | 1 ∓ 1/√3 = 0.42265, 1.57735 |
| 16 | These nodes sit near the two troughs of f | confirmed | f's local minima are at x = 0.43198 (f = 0.3572) and x = 1.56448 (f = 0.7956). f at the nodes is 0.3587 and 0.7960. Frame 4 shows both dots at the troughs |
| 17 | I_2 = 1.154628, about 43% low | confirmed | I_2 = 1.154628 (also frame 4); (I−I_2)/I = 0.4273 |
| 18 | \|I_5−I\| ≈ 1.7e−3 but \|I_6−I\| ≈ 3.2e−3 | confirmed | −1.6572e−3 and +3.1854e−3 |
| 19 | Table row n=4: 2.106664, 9.04e−2 | confirmed | 2.106664, 9.0384e−2; frame 6 shows 2.106664 |
| 20 | Row n=8: 2.017912, 1.63e−3, ratio 55.4 | confirmed | 2.017912, 1.6321e−3, 55.380 |
| 21 | Row n=16: 2.016457, 1.77e−4, ratio 9.22 | confirmed | 2.016457, 1.7697e−4, 9.2226; frame 13 shows 2.016457 |
| 22 | Row n=32: 2.016298, 1.83e−5, ratio 9.65 | confirmed | 2.016298, 1.8347e−5, 9.6455; frame 18 shows 2.016298 |
| 23 | Row n=64: 2.016282, 1.86e−6, ratio 9.84 | confirmed | 2.016282, 1.8642e−6, 9.8415; frame 24 shows 2.016282 |
| 24 | The rows are frames of Case 1, each doubling n, against I ≈ 2.016280; ratio = previous row's error / this row's | confirmed | n = 4, 8, 16, 32, 64 are all in the script's n_seq, at frames 6, 9, 13, 18 and 24. All errors are positive (I_n > I) |
| 25 | Where it fits: Gauss-Legendre raises n on the whole interval; Trapezoidal and Simpson's shrink h; Romberg speeds this up by extrapolation; Adaptive Simpson concentrates effort where f needs it | confirmed | Accurate characterisations; all linked pages exist |
| 26 | Heading id `{#case-1}` on Case 1 (the only change outside the Description) | confirmed | This is an allowed cross-reference edit; heading text is unchanged |

Consistency with the rest of the page: the Description's n=64 error of 1.86e−6 matches Case 1's "about 1.9×10⁻⁶ high". Its 9.8 ratio and 10.08 limit match Case 1's "9.8 (from 32 to 64 nodes), tending to 2^{10/3}≈10.08". I_6 > I with I_8 < I_6 matches "from n=6 on it decreases in every frame". The Description now uses ω_i for the [-1,1] weights and w_i for the mapped weights, which matches the w_i bar widths in Case 1 and the alt text. No contradictions found.

## 3. Checks

- **The six points.** (1) Problem: line 12. (2) Core formula: the display math on lines 15–29, in the animation's notation (x_i, w_i, I_n), plus the [-1,1] form with ω_i. (3) What it assumes: lines 31–32. (4) How accurate it is: lines 34–40, a general result with the C^{2n} hypothesis, plus the analytic-f geometric rate. (5) When it fails or misleads: lines 42–46, with the Case 1 singularity, the n=2 trough miss, and the non-monotone error from n=5 to n=6, all computed. (6) Where it fits: line 58. All present and in order. The optional worked example is a 5-row table on the page's own problem, within the limit. There are no proofs or theorem boxes.
- **Word count.** 352 by my count (manifest: 354; the difference is how links are counted). Within 150–400.
- **Links and anchors.** ../newton-cotes-integration/, ../legendre-polynomials/, ../trapezoidal-rule-for-numerical-integration/, ../simpsons-rule-for-numerical-integration/, ../romberg-integration/ and ../adaptive-simpsons-rule/ each have an index.qmd. Both `[Case 1](#case-1)` links match the explicit id `{#case-1}` added to the Case 1 heading.
- **Scope of the diff.** Only index.qmd changed. The edits outside the Description are just the heading id. The Animations introduction (lines 62–65), the Behavior paragraph, the source link, the alt text and the closing paragraph are unchanged, and no sentences were moved.
- **Script/GIF.** Not changed by the diff. I read gausslegendreaa.jl only to confirm that the Description's formulas are the ones it implements: mapping, scaled weights, sum, and bars of width w_i. I checked frames 4, 6, 13, 18 and 24 against my computed I_n, and all match to 6 decimals.
- I did not run MATLAB, quarto or the page's script, and I modified nothing in the repository.
