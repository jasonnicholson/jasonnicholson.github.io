# Least Squares Polynomials — batch 19 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/least-squares-polynomials/index.qmd`, light-pass batch 19, overview page (extend). Reviewer scratch: `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-19/least-squares-polynomials/reviewer/` (check.py, crops of the archive's normal-equation image and of the GIF RMS labels). I did not run MATLAB, quarto, any page script or any state-changing git command. I consulted the Mathews archive: `n2003/LeastSqPolyMod.html` as text, plus its normal-equations image `LeastSqPolyMod_gr_4.gif`.

## 1. Findings

None.

Observations that are not findings:
- The Where-it-fits sentence (line 52) joins four independent clauses with commas. It is accurate but reads as a run-on. This is style only.
- The link text says "Least Squares Line" but the target page's title is "Least Squares Lines". The link resolves, so this is cosmetic.
- The statement that QR "solves the same problem without squaring it" holds in the usual small-residual sense. QR's sensitivity still contains a cond(V)²·‖r‖ term, but for an overview this is standard and not misleading.
- Out of the diff's scope, noted for the director only: the unchanged Animations introduction (line 61) describes Mathews' Example 6 as "the graph … which plots the quadratic to quintic fits together". The module's text gives Example 6 as "Why is the RMS error for [p5] essentially zero?" I did not open the solution's graph, so I could not determine whether that description is wrong. The new text does not depend on it.

## 2. Claim ledger (the + lines of the diff)

| # | Claim (page's words, line) | Verdict | Evidence |
|---|---|---|---|
| L1 | "Given $n$ data points" (12), with E summed i=1..n | confirmed | This is consistent with E and RMS (lines 18 and 31) and with Mathews' "n data points". |
| L2 | The normal equations are "$m+1$ linear equations that Mathews writes with sums of powers of the data", Σ_j (Σ_i x_i^{j+k}) a_j = Σ_i x_i^k y_i, k=0..m (20–22) | confirmed | sympy, exact rationals: for every m=0..5 the sums-of-powers matrix and right side are exactly VᵀV and Vᵀy. The archive image gr_4 shows the same matrix (n, Σx_i, …, Σx_i^{2m}). |
| L3 | V is n×(m+1) with V_ij = x_i^j, j=0..m (28) | confirmed | The scripts build `V = [x^j for x in x_data, j in 0:m]`. |
| L4 | "unique when at least $m+1$ of the $x_i$ are distinct: then the columns of V are independent, VᵀV is SPD, and the normal equations have exactly one solution" (33) | confirmed | General result: a Vandermonde submatrix on m+1 distinct nodes is nonsingular, so V has full column rank and VᵀV is SPD. The condition is also necessary. |
| L5 | "The error E is measured only vertically, at the data points." (34) | confirmed | This follows from the definition of E. |
| L6 | "There is no convergence order; accuracy is the size of the residuals" (36) | confirmed | This is a correct characterization. |
| L7 | "Raising the degree never increases the minimum of E, because every polynomial of degree m−1 is also one of degree m" (37) | confirmed | General result (nested spaces). Exact E on the page's data for m=0..5: 19.428, 1.7527, 0.016507, 0.0045948, 0.00032325, 0. |
| L8 | "If m=n−1 and the x_i are distinct, the fit interpolates the data and E=0" (38) | confirmed | General result. Exact E=0 for m=5 on the six points. |
| L9 | Six data points (41), unchanged except for the trailing punctuation | confirmed | They match x_data and y_data in all four scripts. |
| L10 | RMS 0.05245 (m=2), 0.02767 (m=3), 0.00734 (m=4), 0 (m=5) (43) | confirmed | Exact computation: 0.0524514, 0.0276732, 0.00733997, 0. The GIF last frames show 0.05245, 0.02767 and 0.00734. The Case 4 GIF shows 7.86e-15, which is the roundoff that Case 4's Behavior already explains. |
| L11 | Links Case 1–4 point to the quadratic, cubic, quartic and quintic (43) | confirmed | The anchors {#case-1}…{#case-4} are on headings with m=2,3,4,5, wired to aa/ab/ac/ad (.jl and .gif). |
| L12 | The quintic "passes through all six points" (43) | confirmed | Exact residuals are 0. Frame 6 of leastsqpolyad shows the curve through all six points. |
| L13 | "Forming VᵀV squares the 2-norm condition number of V" (44) | confirmed | General identity. numpy: cond₂(VᵀV) = cond₂(V)² for every m (381.8 = 381.8, etc.). |
| L14 | "so in floating point the normal equations lose accuracy as the degree grows" (44) | confirmed | General statement. cond grows monotonically with m on these data (L15). |
| L15 | cond(VᵀV) ≈ 382, 6.6×10³, 2.3×10⁵, 4.7×10⁶ for m=2..5 (45) | confirmed | numpy: 381.8, 6576, 2.295e5, 4.688e6. |
| L16 | "a QR factorization of V solves the same problem without squaring it" (45) | confirmed | Standard result (see the observation above). |
| L17 | "A smaller RMS does not mean a better model." (47) | confirmed | Supported by L19. |
| L18 | The animations plot only [−5,4.5], "where the four fits differ by at most 0.25" (48) | confirmed | All four scripts set `xlims = (-5.0, 4.5)`, and the frames show this window. The largest pairwise difference on a 200001-point grid is 0.2469 (quadratic vs quintic, at x=−5). On the data hull [−4.5,4.1] it is 0.092. |
| L19 | At x=10 the fits give 2.40, 4.82, −2.23, 8.08 (49) | confirmed | Exact coefficients give 2.39691, 4.81528, −2.22776, 8.08230. |
| L20 | High-degree fits to non-polynomial data can oscillate ("polynomial wiggle"), "as Mathews' Example 7 shows" (50) | confirmed (text) | The module text says that when the data are "NOT polynomial" this is "polynomial wiggle", and that Example 7 illustrates it. I did not inspect the Example 7 graph itself. |
| L21 | Degree-1 case is the Least Squares Line (52) | confirmed | `least-squares-lines/index.qmd` fits y = b + ax by least squares. |
| L22 | Nonlinear Curve Fitting "fits exponential and power models by linearizing the data" (52) | confirmed | That page's Description covers y = ce^{ax} and y = cx^a by data linearization. |
| L23 | "with m=n−1 the fit becomes the interpolating polynomial of Lagrange Polynomial Interpolation" (52) | confirmed | Follows from L8 (distinct x_i, stated just before). |
| L24 | Chebyshev page "shows how well-placed nodes reduce the oscillation of high-degree polynomials" (52) | confirmed | Lines 13–14 and 41 of the Chebyshev page say this: 16 Chebyshev nodes give error 1.4e-2 against 0.48 for equally spaced nodes. |
| L25 | Heading ids {#case-1}…{#case-4} (63, 73, 83, 93) | confirmed | These are the only edits outside the Description, and the standard allows them. |
| L26 | Removed sentence ("As the degree increases from 2 to 5, RMS decreases … wiggle … poor extrapolation") | confirmed | It sat in the Description, not the Animations, and its content now appears expanded in L10, L17–L20. |

## 3. Checks

**Six points of the standard:**
1. Problem: present (lines 12–18).
2. Core formula: present as display math (14, 18, 22, 26, 31), in the scripts' notation (V, normal equations, RMS as in `final_rms`).
3. Assumptions: present (33–34: m+1 distinct x_i; vertical error).
4. Accuracy: present, stated as general results (36–38), tied to the cases with RMS values that were checked (43), plus conditioning (44–45).
5. Failure modes: present (47–50: extrapolation, wiggle, plus the normal-equations conditioning). They say honestly that the animations' window does not show the separation.
6. Where it fits: present (52), and all four links resolve.

No proofs or theorem boxes.

**Word count:** I recounted independently at 398 (inline math counted as one word, display math excluded, punctuation-only tokens dropped). This is within 150–400, at the limit.

**Links and anchors:** #case-1…#case-4 match the explicit ids on the four case headings. `../least-squares-lines/`, `../nonlinear-curve-fitting/`, `../lagrange-polynomial-interpolation-and-approximation/` and `../chebyshev-approximation-polynomial/` all exist with an index.qmd.

**Scope of diff:** `git diff 147040f` on the page folder is identical to EV/diff.patch. Only index.qmd changed (29+/9−); no script or GIF changed, so the animations are not under review. Outside the Description, the only changes are the four heading ids.

**Consistency with the rest of the page:** no contradiction found. The new RMS values match the Case 1–4 displays, the GIF labels and Case 3's "about a factor of four" (3.77). The Case 4 RMS of 0 matches Case 4's Behavior (exact 0, roundoff about 8e-15 in the GIF). The Animations introduction's mean of 3.8167 is confirmed (degree-0 fit = 3.816667).

**Fidelity:** the normal equations are in Mathews' sums-of-powers form with his n and m. The wiggle attribution to Example 7 matches the module text. No Fidelity departures.
