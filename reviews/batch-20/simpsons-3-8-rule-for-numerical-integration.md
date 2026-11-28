# Simpson's 3/8 Rule for Numerical Integration — batch 20 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/index.qmd` (light-pass batch 20, overview page, action *extend*). Evidence folder: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-20/simpsons-3-8-rule-for-numerical-integration. My scratch files are in its `reviewer/` subfolder: chk.py, rate.py, wc.py, mathews.png and sel.png.

The diff changes no script and no GIF, so the animations were not re-reviewed. Mathews archive consulted: yes, `n2003/Simpson38RuleMod.html`. I read its formula images gr_26–28 and gr_39–49 (composite rule, remainder term, the (1/2)^4 = 0.0625 remark). MATLAB and quarto were not run, and nothing in the repository was modified. The working-tree diff `git diff 147040f -- <page dir>` is byte-identical to EV/diff.patch.

## 1. Findings

None.

Observations that are not findings:
- **"never rises above 1.37"**: the n=6 first cubic peaks at 1.3640, at its right endpoint x=1. The statement is true but loose; "1.36" would be tighter.
- **The 2.25 factor and the Newton-Cotes page**: the Newton-Cotes page's Case 3 says that on this non-smooth integrand the 3/8 error is about 1.25 times Simpson's. This page's "about 2.25 times larger" is explicitly scoped to "smooth f", so the two do not contradict.
- **Removed sentence**: the diff drops the old line "higher-order refinement of trapezoidal geometry". It is not carried into the new text, and removing it is fine.

## 2. Claim ledger (the + lines of the diff)

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | Approximates ∫_a^b f dx from values at equally spaced points | Definition; the script samples f at a+i·dx | confirmed |
| 2 | h=(b−a)/n, x_i=a+ih, i=0..n; on each block [x_{3k−3},x_{3k}] f is replaced by the cubic through the four nodes | Script lines 37–48 (poly_coeffs through 4 nodes per triplet); Mathews gr_23 | confirmed |
| 3 | Block-sum formula (3h/8)Σ_{k=1}^{n/3}[f_{3k−3}+3f_{3k−2}+3f_{3k−1}+f_{3k}] | Identical to Mathews gr_26. My block-sum implementation equals the collected-weights form to 1e−40 at all 23 n of the GIF | confirmed |
| 4 | Collected form: weights 1 at the ends, 3 for i≢0 mod 3, 2 for 0<i<n with i≡0 mod 3 | Matches the script's simpson38_sum exactly (sum_3 over i%3≠0, sum_2 over 3:3:n−3) | confirmed |
| 5 | n must be a multiple of 3 | Structural; the script's n_seq is all multiples of 3 | confirmed |
| 6 | Sums converge for any continuous f | Positive weights summing to b−a give a Riemann-type sum | confirmed |
| 7 | The error formula needs f∈C⁴[a,b] | Mathews gr_40 | confirmed |
| 8 | Exact for every cubic | Errors on [0,1] with n=6: x⁰..x³ give 0 (≤6e−42), x⁴ gives 2.3e−4, x⁵ gives 5.8e−4 | confirmed |
| 9 | ∫−S = −(b−a)f⁽⁴⁾(c)h⁴/80, a<c<b, "as Mathews states it" | Matches Mathews gr_39–44. Sign check with exp on [0,1], n=12: I−S = −1.0341e−6, inside [−h⁴e/80, −h⁴/80] = [−1.639e−6, −6.03e−7] | confirmed |
| 10 | O(h⁴), and halving h divides the error by about 16 | exp: 15.98; cos: 16.02 (n 12→24); Mathews gr_49 = 0.0625 | confirmed |
| 11 | 1/80 is 9/4 of Simpson's 1/180; at the same h the error is about 2.25 times larger for smooth f | 180/80 = 2.25. Measured error ratios of 3/8 to Simpson: exp 2.248/2.2495/2.2499, cos 2.252/2.2505/2.2501 (n=12, 24, 48). Simpson page line 21 uses 1/180 | confirmed |
| 12 | The animation does not show h⁴ because the integrand is not in C⁴[0,2] | f′ ~ (16/3)x^{−1/3} at 0; measured ratios are about 3.2, not 16 | confirmed |
| 13 | Case 1 integrand f=e^{−x}sin(8x^{2/3})+1, with f′ unbounded at 0 | Script line 7; derivative computed by hand | confirmed |
| 14 | Error shrinks like h^{5/3}: ratios 4.32, 3.40, 3.22, approaching 2^{5/3}≈3.17 | Mine: 4.31738, 3.39635, 3.22384. Continuing the sequence: 120→240 gives 3.189, then 3.1801, 3.1771, 3.1759 (up to 1920). 2^{5/3}=3.17480 | confirmed |
| 15 | At n=6 the first cubic on [0,1] never rises above 1.37 | Cubic through (0,1), (1/3,0.535988), (2/3,0.909072), (1,1.36396) has max 1.36396 at x=1. Frame_003 matches | confirmed |
| 16 | f peaks at about 1.92 near x=0.080 | findroot of f′ gives x=0.0803835, f=1.919756. The next local max is about 1.38 near x≈0.93, so this is the global peak | confirmed |
| 17 | Error grows from −0.132 at n=3 to −0.226 | −0.132066 and −0.225809. Frame_002 shows 1.884214 and frame_003 shows 1.79047 | confirmed |
| 18 | Table n=15: S=1.994094, err −0.02219 | 1.994094425, −0.0221853; frame_006 shows 1.994094 | confirmed |
| 19 | Table n=30: S=2.011141, err −0.005139, ratio 4.32 | 2.011141122, −0.0051386, 4.317; frame_011 shows 2.011141 | confirmed |
| 20 | Table n=60: S=2.014767, err −0.001513, ratio 3.40 | 2.014766742, −0.00151298, 3.396; frame_017 shows 2.014767 | confirmed |
| 21 | Table n=120: S=2.015810, err −0.0004693, ratio 3.22 | 2.015810411, −0.000469309, 3.224; frame_024 shows 2.01581 | confirmed |
| 22 | The rows are Case 1 frames, each halving h | 15, 30, 60, 120 are all in the script's n_seq, and each step halves h | confirmed |
| 23 | I ≈ 2.016280 | mpmath quad with the substitution x=t³ and a 40-panel direct quad agree: 2.0162797196… | confirmed |
| 24 | Ratio definition: previous error divided by this error | Consistent with rows 19–21 | confirmed |
| 25 | Degree-3 member of Newton-Cotes, between Simpson's and Boole's | Closed NC with interpolant degrees 2, 3, 4. Consistent with newton-cotes-integration/index.qmd line 13 and booles-rule/index.qmd line 46 | confirmed |
| 26 | For odd n≥5, one 3/8 block plus Simpson on the remaining even number covers [a,b] | n−3 is even and ≥2 | confirmed |
| 27 | Heading id `{#case-1}` added; link `[Case 1](#case-1)` | The explicit id matches the link | confirmed |
| 28 | Links ../newton-cotes-integration/, ../simpsons-rule-for-numerical-integration/, ../booles-rule/ | All three index.qmd files exist | confirmed |

## 3. Checks

**Six points of the standard.**
1. Problem: line 12. Present.
2. Core formula: lines 15–21, display math, in the script's notation (n, h, x_i, the 3/2/3 weights). Present.
3. Assumptions: n a multiple of 3; f∈C⁴ for the error formula (lines 23–24). Present.
4. Accuracy: Mathews' error term with its hypothesis, O(h⁴), the factor 16, and the 9/4 comparison. It states correctly that the animation does not show h⁴ (lines 26–33). Present.
5. Failure modes: the non-smooth integrand, with the h^{5/3} rate and a link to Case 1, and the coarse wide panels missing the peak at n=6 (lines 35–37). Present.
6. Where it fits: line 48. Present.

The optional worked example has 4 rows (the limit is about 6). It uses the page's own problem and adds digits the GIF does not show. There are no proofs and no callout boxes.

**Word count.** I recounted 342 with my own script (inline math counted as one word; display math, table rows and link targets excluded), which matches the manifest. This is within 150–400.

**Consistency with the rest of the page.** The Case 1 Behavior paragraph (line 59) states the same I≈2.016280, all approximations low, error growing from 4 to 7 points, 2.01581 at 121 points about 0.00047 low, and ratio 3.22 tending to 3.17. All of this agrees with the new text and with my numbers. Six frames viewed (002, 003, 006, 011, 017, 024) show the values the text cites. There are no contradictions with the Newton-Cotes, Simpson's or Boole's pages (see the observation above on the 1.25 factor).

**Scope of the diff.** Outside the Description, the only change is the `{#case-1}` id on the Case 1 heading, which the standard allows. No script or GIF changed.

**Markup.** Judged from source, KaTeX constructs used (`\not\equiv`, `\mathrm{mod}`, `\ `, `\dots`) are all supported. No `|` appears inside the table's math cells, and the display math blocks are balanced.

**Fidelity.** The block formula and the remainder term (including its sign and the factor 1/80) match Mathews' composite theorem and corollary. The halving remark matches Mathews' 0.0625. There is no fidelity departure.
