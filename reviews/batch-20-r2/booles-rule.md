# Boole's Rule — batch 20 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `/home/jason/Desktop/jasonhnicholson.com/pages/numerical-methods/booles-rule/index.qmd` (light-pass batch 20, overview, action *extend*). I did not read `reviews/`, did not run MATLAB or quarto, and modified nothing in the repository. My scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-20r2/booles-rule/reviewer/` (`chk.py`, `chk2.py`, `wc.py`, `mathews.png`).

I consulted the Mathews archive: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/BooleRuleMod.html`, including its formula images gr_1–12 and gr_33–50, which I rendered into `mathews.png`.

## 1. Findings

None.

## 2. Claim ledger (the `+` lines of the diff; no sentences were moved)

Evidence used below:
- **chk.py:** mpmath at 30 digits. The true integral I comes from the substitution x = t³ followed by `mp.quad`, cross-checked by splitting [0,2] into 40 pieces. Both give I = 2.0162797196.
- **chk2.py:** sympy exact arithmetic.
- **Frames:** `frame_002.png` and `sheet.png`.

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| L1 | Boole's rule approximates ∫ₐᵇ f dx from values at equally spaced points | confirmed | Definition; matches Mathews. |
| L2 | h=(b−a)/n, x_i=a+ih, f_i=f(x_i), i=0..n; on each [x_{4k},x_{4k+4}] f is replaced by the quartic through 5 nodes | confirmed | Same as the script's `boole_sum` and `poly_coeffs` loops (i in 0:4:n−4). |
| L3 | Display formula B_n=(2h/45)Σ(7,32,12,32,7) | confirmed | Matches Mathews gr_37 with n=4m and the script line `total += (2*dx/45)*(7f(x0)+32f(x1)+12f(x2)+32f(x3)+7f(x4))`. Exactness for degrees 0–5 (chk2) pins down the 5 weights uniquely, so they are the integrals of the quartic interpolant. |
| L4 | n must be a multiple of 4 | confirmed | Follows from the panel structure. |
| L5 | B_n converges to the integral for any continuous f | confirmed | All weights are positive, and B_n is a convex combination (weights 14/90, 64/90, 24/90 …) of Riemann sums with spacing 4h. |
| L6 | The error formula needs f ∈ C⁶[a,b] | confirmed | Mathews gr_41. |
| L7 | Exact for every polynomial of degree 5 | confirmed | chk2: ∫₀¹xᵈ − B_n = 0 for d=0..5 at n=4 and n=8. For d=6 it is −1/2688 and −1/172032 (nonzero). |
| L8 | The fifth-degree term cancels by symmetry about the panel midpoint | confirmed | (x−m)⁵ is odd about the midpoint m and the weights are symmetric, so both the integral and B vanish. This is a one-line intuition, which the standard allows. |
| L9 | ∫f − B_n = −2(b−a)f⁽⁶⁾(c)h⁶/945, a<c<b, "as Mathews states it" | confirmed | Matches Mathews gr_45 exactly, sign included (Mathews defines ∫ = B + E_B in gr_40). chk2 with x⁶ on [0,1]: −1/2688, −1/172032 and −1/1959552 at n=4, 8, 12, each equal to −(2/945)·720·h⁶. |
| L10 | O(h⁶), the highest order of the four closed Newton-Cotes rules on this site; halving h typically divides the error by about 64 | confirmed | Agrees with the Newton-Cotes page (lines 28 and 81: degrees 1, 3, 3, 5 and orders h², h⁴, h⁴, h⁶). Mathews' remark gives (1/2)⁶=0.015625. |
| L11 | Closed rules with ≥7 nodes per panel are exact to higher degree (the seven-node rule to degree 7) | confirmed | chk2 degree of precision: 5-node 5, 6-node 5, 7-node 7, 8-node 7. |
| L12 | The animation does not show O(h⁶) because the integrand is not in C⁶[0,2] | confirmed | f′ ≈ (16/3)x^{−1/3} near 0, so f is not even C¹. |
| L13 | Case 1 integrand f=1+e^{−x}sin(8x^{2/3}), f′ unbounded at 0 | confirmed | Same function as the script `f(x)` and the Case 1 heading. |
| L14 | The error shrinks like h^{5/3}; halving divides it by 3.10 then 3.17 (last two table rows), close to 2^{5/3}≈3.17, not 64 | confirmed | chk ratios: 32/16 3.1007, 64/32 3.1725, 128/64 3.1819, 256/128 3.1794, 512/256 3.1772, tending to 2^{5/3}=3.1748. |
| L15 | For n from 48 to 120, Boole's error is about 0.85 times Simpson's at the same n | confirmed | chk (B_n−I)/(S_n−I) over the frame n values 48…120: 0.8413, 0.8436, …, 0.8530. |
| L16 | First quadrature frame (n=4): the quartic misses the peak f≈1.92 near x≈0.08 | confirmed | Peak from findroot on f′: x=0.08038, f=1.91976. `frame_002.png` shows the single pink quartic dipping to about 0.12 near x≈0.28 while the magenta f peaks at about 1.92 near 0.08. |
| L17 | n=4 error −0.463, more than twice the Trapezoidal Rule's −0.214 on the same five points | confirmed | B₄−I = −0.463125; T₄−I = −0.214208 (ratio 2.16). |
| L18 | Table row n=4: h=1/2, B=1.553155, err −0.4631 | confirmed | 1.5531547, −0.463125. Frame 2 shows 1.553155. |
| L19 | Row n=8: 1/4, 1.963413, −0.05287, ratio 8.76 | confirmed | 1.9634127, −0.052867, 8.7602. Frame 3 shows 1.963413. |
| L20 | Row n=16: 1/8, 2.007328, −0.008952, 5.91 | confirmed | 2.0073277, −0.00895199, 5.9056. Frame 5 shows 2.007328. |
| L21 | Row n=32: 1/16, 2.013393, −0.002887, 3.10 | confirmed | 2.0133926, −0.00288708, 3.1007. Frame 9 shows 2.013393. |
| L22 | Row n=64: 1/32, 2.015370, −0.0009100, 3.17 | confirmed | 2.0153697, −0.000910033, 3.1725. Frame 17 shows 2.01537 (Julia drops the trailing zero). |
| L23 | The rows are frames of Case 1, each halving h; I≈2.016280; ratio = previous error / this error | confirmed | n=4, 8, 16, 32, 64 are all in the script's `n_seq`. I = 2.0162797. The ratio definition matches the computed column. |
| L24 | Boole is the degree-4 Newton-Cotes member after trapezoidal, Simpson and Simpson 3/8 | confirmed | Interpolant degrees 1, 2, 3, 4. |
| L25 | B_{2n} = (16S_{2n} − S_n)/15 is one Richardson step | confirmed | chk: the difference is below 6e−31 for n=4, 8, 16 on the page's integrand. Notation agrees with the Simpson page (S_n has n subintervals; its line 37 uses S_{2n}=(4T_{2n}−T_n)/3 in parallel). |
| L26 | This forms the third column of Romberg Integration | confirmed | The Romberg page, line 26: "the third is Boole's rule". |
| L27 | Heading id `{#case-1}` added | confirmed | The only change outside the Description. The link `[Case 1](#case-1)` resolves to it. |

Consistency with the rest of the page:
- The unchanged Behavior paragraph says the error ratio is "about 3.18 (from 60 to 120)". chk gives 3.18196, which agrees with L14.
- Behavior says the approximation rises monotonically and stays below I, ending at 2.015961, about 3.2e−4 low. chk: B_n increases strictly over every n in n_seq, all values are below I, and B₁₂₀ = 2.015961 with error −3.185e−4.
- The Animations intro and alt text do not contradict anything.

## 3. Checks

**Six points of the overview standard:**
1. **Problem:** line 12.
2. **Core formula:** display math at lines 15–17, in the page and script notation (n, h, f_i, B_n).
3. **Assumptions:** lines 19–20 (n a multiple of 4; continuity for convergence; C⁶ for the error formula).
4. **Accuracy:** lines 22–29. A general result with its hypothesis, plus a correct statement that the animation does not show it.
5. **Failure or misleading cases:** lines 31–34. The non-smooth integrand linked to Case 1, and the coarse n=4 panel. Both were computed and seen in the frames.
6. **Where it fits:** line 46.

The optional worked example is a 5-row table on the page's own animated problem, and every value matches the GIF. There are no proofs and no callout or theorem boxes.

**Word count:** 390 by my independent count (inline math counted as 1, display math, table rows and pure-punctuation tokens excluded), the same as the manifest. That is within 150–400, near the top.

**Links and anchors:** all six relative page links resolve to an existing `index.qmd`: simpsons-rule-for-numerical-integration, trapezoidal-rule-for-numerical-integration, newton-cotes-integration, simpsons-3-8-rule-for-numerical-integration, richardson-extrapolation and romberg-integration. `#case-1` matches the explicit heading id.

**Scope of the diff:** only `index.qmd` changed; no script or GIF. Outside the Description the only change is the `{#case-1}` id on the Case 1 heading, which is allowed. No sentences were moved out of the Animations intro, and that intro is unchanged.

**Fidelity to Mathews:** no departures.
- Mathews writes the composite rule with m panels and h=(b−a)/(4m); the page uses n=4m, which is equivalent.
- The remainder formula (gr_45), the C⁶ hypothesis (gr_41) and the factor of 64 when h is halved (gr_50) are reproduced faithfully.
- The single-panel term −8h⁷f⁽⁶⁾/945 (gr_12) is consistent with the composite term.

**Script (unchanged, not under full review):** I checked only that `boolesaa.jl`'s `boole_sum` implements exactly the Description's displayed formula and that its `f` is the page's f. Both hold.
