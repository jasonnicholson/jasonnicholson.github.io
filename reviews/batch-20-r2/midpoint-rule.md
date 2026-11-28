# Midpoint Rule — batch 20 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Review of `pages/numerical-methods/midpoint-rule/index.qmd`, light-pass batch 20 overview page (action: extend). I read the manifest, diff.patch, the full page, `midpointaa.jl` (read only, not run, since the diff changes no script or GIF) and frames 003–004 of `midpointaa.gif`. I did not read anything under `reviews/`, did not run MATLAB or quarto, and modified nothing in the repository. My scratch script is `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-20r2/midpoint-rule/reviewer/chk.py` (mpmath, 30 digits).

I consulted the Mathews archive: `n2003/MidpointRuleMod.html`, including the corollary images `MidpointRuleMod_gr_28/29/31.gif`.

## 1. Findings

None.

One borderline point, not counted as a finding. Line 32 reads "Under the same hypothesis the Trapezoidal Rule's error is −(b−a)f''(c)Δx²/12, with its own c, **so** when f'(a)≠f'(b) the midpoint error is … about half the trapezoidal error, of opposite sign." Strictly, two mean-value formulas with different c's do not imply the ratio. The claim itself is true for f∈C²[a,b], though. Summing the per-panel errors h³f''(ξᵢ)/24 gives a Riemann sum of f'', so I−M_n ≈ Δx²(f'(b)−f'(a))/24 and I−T_n ≈ −Δx²(f'(b)−f'(a))/12. A reader is not misled.

## 2. Claim ledger (+ lines of the diff)

| # | Claim (page wording, line) | Verdict | Evidence |
|---|---|---|---|
| L1 | The rule approximates ∫ₐᵇf by rectangles like a Riemann sum, with height at the midpoint (l.12) | confirmed | Definition; the script's `midpoint_sum` matches |
| L2 | M_n = Δx Σ_{i=0}^{n−1} f(a+(i+½)Δx), Δx=(b−a)/n (l.13–17, unchanged formula) | confirmed | Same as `midpoint_sum` in midpointaa.jl |
| L3 | Each rectangle is centered at its midpoint sample, "the red dots in the animation" (l.19) | confirmed | `scatter!` with markercolor=:red at xs; frames 003/004 show red dots at 0.5, 1.5 and at 0.25…1.75 |
| L4 | As Riemann sums, M_n converge for every Riemann-integrable f (l.21) | confirmed | Standard: the midpoint is a valid tag point |
| L5 | The error formula needs f∈C²[a,b] (l.22) | confirmed | Matches the Mathews corollary (gr_29: f∈C²[a,b]) |
| L6 | Each rectangle's area equals the area under the tangent line at the midpoint, so the rule is exact for linear f, and the first missed term involves f'' (l.24) | confirmed | ∫_{m−h/2}^{m+h/2}[f(m)+f'(m)(x−m)]dx = h f(m) |
| L7 | "As Mathews states it": ∫ₐᵇf − M_n = (b−a)f''(c)Δx²/24, a<c<b (l.25–29) | confirmed | Mathews gr_28: ∫ = M(f,h)+E_M(f,h); gr_31: E_M = (b−a)f''(c)h²/24. Sign checked: convex f gives M < I |
| L8 | Error O(Δx²); halving Δx typically divides it by about 4 (l.31) | confirmed | Follows from L7; matches the Mathews remark |
| L9 | Trapezoidal error is −(b−a)f''(c)Δx²/12 with its own c (l.32) | confirmed | Standard; identical to the trapezoidal page, l.24 |
| L10 | When f'(a)≠f'(b), the midpoint error is about half the trapezoidal error and of opposite sign, for small Δx (l.32) | confirmed | Asymptotic expansion as above (see note in Findings) |
| L11 | Left and right sums are in general only first order (l.33) | confirmed | Standard; consistent with the riemann-sums page, l.28 |
| L12 | [Case 1](#case-1) shows what happens when the hypothesis fails (l.35) | confirmed | Anchor `{#case-1}` added at l.60 |
| L13 | Case 1 integrand f=e^{−x}sin(8x^{2/3})+1; f' unbounded at 0, so f∉C²[0,2] (l.36) | confirmed | Same f as the script; f'≈(16/3)x^{−1/3} near 0 |
| L14 | Error shrinks like Δx^{5/3}; ratios 2.86, 3.09, 3.14 approach 2^{5/3}≈3.17, not 4 (l.36) | confirmed | Computed ratios: 20: 2.859, 40: 3.0923, 80: 3.1419, 160: 3.157, 320: 3.1635, 640: 3.167, 1280: 3.1691. 2^{5/3}=3.1748 |
| L15 | For n from 40 to 120, midpoint error ≈ −0.37 × trapezoidal error, not −1/2 (l.37) | confirmed | (M−I)/(T−I): n=40 −0.36619, 50 −0.36686, 60 −0.36728, 70 −0.36757, 80 −0.36778, 100 −0.36807, 120 −0.36827. Independent theory check: the x^{2/3} endpoint term gives the ratio ζ(−α,½)/ζ(−α) = 2^{−α}−1 = −0.370 for α=2/3 |
| L16 | Table row n=10, Δx=1/5: M=2.043030, M−I=0.02675 (l.41) | confirmed | 2.043030305, 0.0267506 |
| L17 | n=20, Δx=1/10: 2.025636, 0.009357, ratio 2.86 (l.42) | confirmed | 2.025636334, 0.00935661, 2.859 |
| L18 | n=40, Δx=1/20: 2.019305, 0.003026, ratio 3.09 (l.43) | confirmed | 2.019305493, 0.00302577, 3.0923 |
| L19 | n=80, Δx=1/40: 2.017243, 0.0009630, ratio 3.14 (l.44) | confirmed | 2.017242755, 0.000963035, 3.1419 |
| L20 | The rows are frames of Case 1, each halving Δx; I≈2.016280; ratio is previous error / this error (l.46) | confirmed | 10, 20, 40, 80 are all in n_seq. I = 2.0162797196 (by the substitution x=t³ and by direct subdivided quadrature; both agree) |
| L21 | A coarse partition can miss f's shape; a single estimate says nothing about its own error (l.48) | confirmed | Illustrated by L22–L23 |
| L22 | n=2: samples at x=0.5 and 1.5 fall near the two dips of f; M_2≈1.231, 0.79 below I (l.49) | confirmed | Local minima at x=0.4320 (f=0.357) and 1.5645 (f=0.796), the only two in [0,2]. f(0.5)=0.426, f(1.5)=0.806. M_2=1.231216, I−M_2=0.78506. Frame 003 shows this |
| L23 | M_4≈2.0111 is closer to I than every frame from 6 to 28 sample points (l.49) | confirmed | \|M_4−I\|=0.005161. Frames 6–28 have errors 0.0430, 0.0352, 0.0268, 0.0207, 0.0164, 0.0133, 0.00936, 0.00697, 0.00543, all larger; the frame at 32 (0.00436) is closer, so the bound 28 is exact. Frame 004 shows 2.011118 |
| L24 | The midpoint rule is the one-point Gauss–Legendre rule on each subinterval and the simplest open Newton–Cotes formula (l.51) | confirmed | The 1-point GL node is 0 with weight 2; the open N-C formula with n=0 is the midpoint rule |
| L25 | S_{2n}=(2M_n+T_n)/3 is Simpson on 2n subintervals; the leading errors cancel for smooth f (l.51) | confirmed | T_{2n}=(T_n+M_n)/2, and (4T_{2n}−T_n)/3=(T_n+2M_n)/3. Error terms +h²/24 and −h²/12 cancel with weights 2:1 |
| L26 | Heading id `{#case-1}` added to the Case 1 heading (l.60, outside the Description) | confirmed | An allowed cross-reference edit; it matches the link at l.35 |

Consistency with the rest of the page: the unchanged Behavior paragraph says ratio ≈3.11 from 24 to 48, tending to 3.17. I computed 3.1125, consistent with the table. Its values 2.016280, 2.016771 and ~0.00049 at n=120 agree with my M_120=2.016771455 and error 0.000492. Its "closer than left/right from 4 sample points on" also checks: true for every frame from n=4, false for n=1 and 2. Derivation Notes (O(Δx²) for C² f) agrees with the Description. There are no contradictions. The figures shared with the trapezoidal page are also consistent: my T(24)−I ≈ −0.0192 matches its table entry −0.01919.

## 3. Checks (overview mode)

- **Six points.** (1) Problem: l.12. (2) Core formula as display math in the page's Δx/n notation: l.15–17, plus the error formula at l.27–29. (3) Assumptions: Riemann-integrable for convergence and C² for the error term, l.21–22. (4) Accuracy as a general result with its hypothesis, O(Δx²), compared with trapezoidal and endpoint sums: l.25–33. (5) Failure modes linked to Case 1 (non-C² integrand at rate 5/3; coarse-partition luck and misleading estimates): l.35–49. (6) Where it fits (Gauss–Legendre, Newton–Cotes, Simpson, Trapezoidal, Riemann): l.12, l.32, l.51. All present. There are no proofs, theorem boxes or Mathematica/MATLAB code. The worked example table has 4 rows, uses the page's own animated problem, and adds digits the GIF does not show (errors and ratios).
- **Word count.** I counted 399 independently with the manifest's rules (inline math = 1 word, display math, table rows and headings excluded), matching the manifest. It is within 150–400, though at the upper edge.
- **Links and anchors.** `../riemann-sums/`, `../trapezoidal-rule-for-numerical-integration/`, `../gauss-legendre-quadrature/`, `../newton-cotes-integration/` and `../simpsons-rule-for-numerical-integration/` each exist as a folder with `index.qmd`. `#case-1` matches the explicit id `{#case-1}` on the Case 1 heading.
- **Diff scope.** Only `index.qmd` changed. The only change outside the Description is the `{#case-1}` heading id, which is allowed. The Animations intro, Behavior paragraph, alt text and other sections are unchanged. No script or GIF changed, so the animations are not under review.
- **Fidelity.** The error formula and its C² hypothesis match the Mathews corollary exactly (Mathews uses h and m; the page uses Δx and n, consistent with its own animation notation). The Case 1 function and interval are the Mathews animation's.
