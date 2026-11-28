# 2D Trapezoidal and Simpson Rules — batch 21 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Review of `pages/numerical-methods/2d-trapezoidal-and-simpson-rules/index.qmd`, light-pass batch 21, overview page (action: extend). The diff changes only `index.qmd`: the Description (lines 12–58) and two heading ids (lines 74, 86). No script or GIF changed, so the animations were not re-reviewed. I used the committed frames only to check claims the new text makes about them.

I consulted the Mathews archive: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/simpsonsrule2dmod.html`. I read its text and rendered the images for the error terms, the example integrals and Example 7 (gr_17, 18, 37, 38, 43, 108, 153, 189, 190, 193) to `EV/reviewer/mathews_err.png`.

Scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-21/2d-trapezoidal-and-simpson-rules/reviewer/`:
- `comp.py`: independent mpmath computation at 30 digits.
- `c2.py`: asymptotic Simpson ratios.
- `wc.py`: word count.
- `mathews_err.png`: the rendered Mathews images.

## 1. Findings

None.

One note that is not a finding: the table's n=16 trapezoidal entry reads `−0.004482`. The true error is −0.00448254, which rounds to −0.004483 at 4 significant figures. The page truncated instead of rounding. That is within the last-digit rounding tolerance of the standard, and it matches the leading digits of the GIF title ("|error| = 0.004482543"). Changing it to −0.004483 is optional.

## 2. Claim ledger (new and changed text)

Reference value: I = 5.04756680716753966… This is my own mpmath double quadrature. The archived benchmark 5.04756680717 differs from it by 2.5e-12.

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| L1 | The two rules approximate ∫_a^b∫_c^d f dy dx over a rectangle from values of f on a grid | confirmed | Matches the module's theorems and both scripts |
| L2 | Examples 1–6 of the module, and both animations, use I = ∫₀¹∫₀¹ 8e^{−x²−y⁴} dy dx | confirmed | Module gr_43, gr_108 and gr_153 show this integral (Examples 1, 4, 6; Examples 3 and 5 refer back to 1 and 4). Both scripts use `f(x,y)=8*exp(-(x^2)-(y^4))` on [0,1]² |
| L3 | This is the volume under z=8e^{−x²−y⁴} over R=[0,1]² | confirmed | The module's Remark under Examples 1 and 4 says the same; the integrand is positive |
| L4 | Panels h=(b−a)/m and k=(d−c)/n; nodes x_i=a+ih, y_j=c+jk | confirmed | Moved and lightly reworded from the old text; matches the module and the scripts (`hx`, `hy`, `range`) |
| L5 | Each rule applies the 1D rule along y at every x_i and then along x, so a node's weight is the product of the 1D weights | confirmed | Tensor-product structure; scripts use `wx[i]*wy[j]` and `ax[i]*ay[j]` |
| L6 | I_T formula with weights 1/2, 1, …, 1, 1/2 | confirmed | Pre-existing formula, unchanged; matches `trapezoid2d`; my independent I_T agrees with the GIF titles to 9 digits (for example n=2: 4.74908773601 against 4.749087736) |
| L7 | I_S = hk/9 ΣΣ a_i a_j f with weights 1, 4, 2, …, 4, 1 | confirmed | Matches `simpson2d`; my I_S agrees with the GIF titles (for example n=2: 5.10626262445 against 5.106262624) |
| L8 | w_j and a_j are defined the same way with n in place of m | confirmed | Scripts and module |
| L9 | For Simpson, m and n must be even | confirmed | Standard requirement; `n_seq` is all even |
| L10 | Mathews states the errors as I = I_T + O(h²) + O(k²) = I_S + O(h⁴) + O(k⁴) | confirmed | Module images gr_18 and gr_38 give these exact forms |
| L11 | These hold when f_xx and f_yy (for I_T), or f_xxxx and f_yyyy (for I_S), are continuous on R | confirmed as a sufficient hypothesis | Split the error as (∫_x − T_x)∫_y f + T_x(∫_y − T_y)f. The first term needs d²/dx²∫f dy = ∫f_xx dy to be continuous; the second needs f_yy(x_i,·) to be continuous. The same argument with fourth derivatives covers Simpson. Mathews states no hypothesis, so this is an addition, not a departure. The example f is C^∞ |
| L12 | Halving h and k typically divides the error by about 4 for I_T and 16 for I_S | confirmed (the "typically" qualifier is accurate) | Asymptotic Simpson ratios: 16.15 (n=20→40), 16.04 (40→80), 16.009 (80→160). Trapezoidal ratio is 4.005 at 8→16 |
| L13 | The animations use square meshes, m=n, h=k=1/n | confirmed | Both scripts use the same n in x and y on [0,1] |
| L14 | The table rows are frames that double n | confirmed | n=2, 4, 8 and 16 are all in `n_seq = [2,4,6,8,10,12,16,20]` |
| L15 | Row n=2: I_T−I = −0.2985; I_S−I = 0.05870 | confirmed | −0.298479; 0.0586958 |
| L16 | Row n=4: −0.07222, ratio 4.13; 0.004245, ratio 13.8 | confirmed | −0.0722221, 4.1328; 0.00424482, 13.828 |
| L17 | Row n=8: −0.01795, ratio 4.02; 1.960e−4, ratio 21.7 | confirmed | −0.0179536, 4.0227; 1.9597e−4, 21.661 |
| L18 | Row n=16: −0.004482, ratio 4.01; 1.150e−5, ratio 17.0 | confirmed (I_T is truncated in the last digit, see the note in section 1) | −0.00448254, 4.0052; 1.14964e−5, 17.046 |
| L19 | Signs: trapezoidal underestimates, Simpson overestimates | confirmed | The computed signs match the table |
| L20 | The Case 1 trapezoidal ratios are close to 4 from the start | confirmed | 4.13, 4.02, 4.01 |
| L21 | The Case 2 Simpson ratios swing between 13.8 and 21.7 on coarse meshes and settle near 16 only on fine ones (16.6 from n=10 to n=20) | confirmed | 13.83, 21.66, 17.05; 10→20 gives 16.634 |
| L22 | On the 2×2 Simpson frame, the quadratic along x=0 peaks at about 8.30, above max f = 8 | confirmed | Quadratic through f(0,0), f(0,0.5), f(0,1) peaks at y=0.1907 with value 8.2973. max f = f(0,0) = 8. Frame 1 of simpson2daa shows the curve rising above the surface at x=0 |
| L23 | Simpson 6×6 has 49 nodes and error 6.7e−4; trapezoidal 20×20 has 441 nodes and error 0.0029; the first is smaller | confirmed | 7²=49, 21²=441; S(6)−I = 6.6797e−4; T(20)−I = −2.8684e−3 (the page quotes the magnitude) |
| L24 | Both rules need a rectangle; for inner limits depending on x (Example 7), Simpson is applied in y at each x and then in x | confirmed | The module's "More Background" applies Simpson on [c(x),d(x)] to get F(x), then Simpson on [a,b]. Example 7 is ∫₀²∫_{x²}^{√(8x)} e^{−x√y} dy dx. Consistent with the Animations note that Example 7 is not animated |
| L25 | These are tensor-product forms of the 1D Trapezoidal and Simpson rules; Gauss-Legendre chooses nodes and weights; Monte Carlo avoids the grid, which needs (m+1)^d nodes | confirmed | Standard facts; (m+1)^d is the node count of a tensor grid with m panels per axis |
| L26 | Links `../trapezoidal-rule-for-numerical-integration/`, `../simpsons-rule-for-numerical-integration/`, `../gauss-legendre-quadrature/`, `../monte-carlo-integration/` | confirmed | Each directory exists and contains `index.qmd` |
| L27 | Links `[Case 1](#case-1)` and `[Case 2](#case-2)` | confirmed | The diff adds `{#case-1}` (line 74) and `{#case-2}` (line 86), using the same syntax as other approved pages such as accelerated-and-modified-newton-raphson |

Consistency with the rest of the page:
- Case 1's "visible second-order error decay" agrees with L20.
- Case 2's "high accuracy with fewer refinements" agrees with L23.
- Case 2's "differ … by up to 0.51 in z" on the 2×2 mesh is consistent: I computed a maximum quadratic-versus-linear difference of 0.5109 along the n=2 grid lines.
- The `zlims` comment in simpson2daa.jl ("peaks at about 8.30") agrees with L22.
- I found no contradictions.

## 3. Checks

**Six points of the overview standard:**
1. Problem: line 12.
2. Core formula: the I_T and I_S display math, in the scripts' notation.
3. Assumptions: rectangle, m and n even, derivative continuity.
4. Accuracy: Mathews' O-terms with hypotheses, the asymptotic 4 and 16 ratios, and the table pointing to Case 1 and Case 2.
5. Failure or misleading behaviour: the coarse Simpson ratios cannot show the rate; the 2×2 quadratic overshoots above max f; non-rectangular regions. Each failure that an animation shows links to its case.
6. Where it fits: line 58.

All six are present. The optional worked example is a 4-row table on the page's own animated problem, and it adds the error ratios, which the GIFs do not show. There are no proofs, no theorem boxes and no MATLAB or Mathematica.

**Word count:**
- The manifest reports 385.
- My rough recount gives 402. It counts inline math as one word, skips display math and table rows, and counts link text. The difference is tokenization: link text, "1–6" and similar.
- Either count is at or near the 400-word limit. I did not raise a finding because the manifest's defined method gives 385. If the owner wants margin, the last sentence's Monte Carlo clause is the easiest to shorten.

**Diff scope:**
- Outside the Description, the diff only adds `{#case-1}` and `{#case-2}` to the two case headings. That is allowed.
- The old "Here the rectangle…" sentence moved within the Description and was lightly reworded with its meaning unchanged; I checked it as new text (L4, L8, L9).
- The Animations introduction and the Behavior paragraphs are untouched.

**Links and anchors:** all resolve (L26, L27). The manifest's mechanical checks reported nothing.

**Scripts:** unchanged by the diff, so I did not re-review them. As supporting evidence, my independent I_T and I_S for every n in `n_seq` match the GIF titles to the digits shown.

**Restrictions:** I did not run MATLAB, quarto or any page script, and I modified nothing in the repository.
