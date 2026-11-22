# Lagrange Polynomial Interpolation and Approximation — animation review (round 5)

Page: `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found nothing false, wrongly computed or misleading on the page, in the script or in the GIFs. Everything I checked is listed in the claim ledger and the implementation checks below, together with the evidence.

A few observations did not reach the level of a finding. I record them so that the clean result can be audited:

- **Case 28, degree 9 (frame 7)** shows a vertical blue line at x ≈ 18.2. This is not an artefact. The degree-9 interpolant has a real root at x = 18.17646 (mpmath `findroot`), with P(18.1) = −7.93 and P(18.2) = +2.63. Far from the nodes it is steep enough to cross the whole window within one grid step. On either side the curve runs along the bottom and top edges, which the page discloses.
- **Cases 24–26 (Γ)**: the window [−0.2, 5.2] contains Γ's pole at 0, and the page does not mention it, unlike Cases 01–03. The drawing is still right. f is clamped like every non-pole case, and it breaks at x = 0 because the plot grid hits exactly 0.0, where `gamma(0.0)` returns non-finite, so `safe_eval` gives NaN. The intro sentence, "drawn along the window's top or bottom edge, except f in Cases 01–03 and 14", therefore holds. If the grid changed, a vertical clamped segment could appear at x = 0. That would be a robustness note, not a current error.
- **Fidelity, degree range**: Mathews' animations run to higher degrees than the page. Animation 01 goes to about S₃₀₊ over 34 frames and Animation 04 to S₁₉, and both overlay a ±0.05 "convergence region" band. The page caps the degree at 15 and has no band. The page claims only to follow Mathews' *case ordering*, which is true, so I treat this as content the page does not have, not a fidelity finding.
- **Fidelity, node intervals not recoverable from the archive**: the archive gives the node interval for Cases 01 (from the animation frames), 04–06, 08–11 and 24–29 (from the index), and for 07 and 14 (from the static Examples 6 and 11). The page matches every one of them. For Cases 02, 03, 12, 13, 15–23 the archive has no animation GIF and the index gives no node interval, so I **could not determine** Mathews' nodes. The page's choices (02 mirrors 01, 03 as 01, the rest spanning the window, 19 on [−1, 1], the domain of arcsin, which is also static Example 14's interval) are mathematically sound. Some static examples use other intervals (sin and cos on [−10, 10], eˣ on [−5, 5], arctan on [−2, 2], J₀ on [−10, 10]). The first three cannot be animation node intervals, because they extend past the animation windows.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 34.1 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `lagnewt01.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt02.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt03.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt04.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt05.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt06.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt07.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt08.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt09.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt10.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt11.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt12.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt13.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt14.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt15.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt16.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt17.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt18.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt19.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt20.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt21.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt22.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt23.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt24.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt25.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt26.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt27.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt28.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt29.gif` | 10 | byte-identical | lagnewt_animations_all |

### Page references

- Scripts linked: `lagnewt_animations_all.jl`
- GIFs embedded: 29
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | "builds a unique polynomial of degree at most $n$ through $n+1$ data points" | confirmed | Standard; script uses n nodes for degree n−1 (titles show `n_nodes - 1`). |
| D2 | "The animations evaluate it in the first barycentric form, $P_n(x)=\ell(x)\sum w_i y_i/(x-x_i)$, $\ell=\prod(x-x_j)$, $w_i=1/\prod_{j\ne i}(x_i-x_j)$" | confirmed | `barycentric_weights` (l.110–120) computes exactly $w_i$; `barycentric_eval` (l.132–138) returns `l * s` with `l=∏(x-x_j)`, `s=Σ w_j y_j/(x-x_j)`; node hit returns `ys[j]`. |
| D3 | "This is the same interpolant, and it stays accurate far outside the nodes" | confirmed | Script value vs mpmath Lagrange form on all 290×1000 grid points: max relative error 4.4e-9 (Case 29, n=16); max error as fraction of window height 8.7e-10. |
| D4 | "…where the second barycentric form (a ratio of two such sums) gives values of the wrong sign in Cases 04 and 29" | confirmed | Float64 second form, float weights computed in the script's loop order, compared with the script's (verified) values: wrong sign at grid points in Case 04 (n=14: 5 pts, n=16: 1) and Case 29 (n=14: 2, n=16: 110) and in no other case. With exactly rounded weights, the same two cases only (04: 39/150 pts; 29: 174/295 pts). |
| D5 | Lagrange formula $P_n=\sum y_i L_i$, $L_i=\prod_{j\ne i}(x-x_j)/(x_i-x_j)$ | confirmed | Standard; this is the formula my mpmath reference evaluates, and the script agrees with it (D3). |
| D6 | "The 29 animations below follow the legacy Mathews case ordering." | confirmed | Mathews `Lagrange.html` function sequence 1/(1−x), 1/(1+x), 1/(1−x)², √x ×3, 1/√(1−x), 1/(1+10x²), Log x ×2, Log(1+x), Sin, Cos, Tan, eˣ, Cos·e⁻ˣ, Cosh, ArcTan, ArcSin, J₀, J₁, normal pdf, normal cdf, Γ ×3, Y₀ ×3 = script rows 01–29. Windows also match Mathews' images row for row (`review/mathews_formulas.png`). |
| D7 | "Each case heading gives the function and the node interval [a, b]; the nodes are equally spaced from a to b, endpoints included." | confirmed | All 290 node sets differ from ideal equispaced nodes on the heading interval by ≤ 2.7e-15 (no trimming in `equal_nodes` ever fired). |
| D8 | "Where the plot window is wider than [a, b] (Cases 01–11, 14, 19 and 24–29), the interpolant beyond the nodes is extrapolation." | confirmed | `dump/summary.tsv`: span ≠ xlims exactly for 01–11, 14, 19, 24–29; for 12, 13, 15–18, 20–23 span == xlims (auto span = full finite window). |
| D9 | "In Case 19, arcsin x is undefined outside [−1, 1], so there only the interpolant is drawn." | confirmed | `asin` throws DomainError for \|x\|>1 → `safe_eval` NaN; frames show no magenta outside [−1, 1]. |

### Animations: intro and wiring

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "raises the polynomial degree through 1, 2, 3, 4, 5, 7, 9, 11, 13 and 15 (2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 nodes)" | confirmed | `n_nodes_seq = [2,3,4,5,6,8,10,12,14,16]` (l.167); every GIF has 10 frames (manifest); titles on all 29 contact sheets read degree 1,2,3,4,5,7,9,11,13,15. |
| A2 | "for a fixed function and node interval" | confirmed | One case row per GIF; nodes recomputed per n on the same span. |
| A3 | "Where a curve leaves the plot window, it is drawn along the window's top or bottom edge" | confirmed | Interpolant `clamp.(yinterp, ylims…)` (l.211); f `ytrue_clip` (l.194); axis ylims are exactly those limits. Seen e.g. Case 28 frame 7, Case 24 frames 5–15, Case 09 left edge. |
| A4 | "…except f in Cases 01–03 and 14, which runs off the window and is broken at each of its poles" | confirmed | `poles=[1.0]`, `[-1.0]`, `[1.0]`, `[-π/2, π/2]` only for those rows; f unclamped with NaN inserted at the poles (l.196–201); sheets 01–03, 14 show f leaving the window and broken at the poles. |
| A5 | Single source link `lagnewt_animations_all.jl` | confirmed | File exists beside the page; it produces all 29 GIFs; regenerated GIFs are byte-identical to the committed ones (manifest). |
| A6 | Wiring: Case NN heading embeds `lagnewtNN.gif` | confirmed | index.qmd lines 31–157: each heading NN embeds `lagnewtNN.gif`; the GIF title reads "Interpolation Case NN: f(x) = …" with the heading's function on all 29 sheets. |
| A7 | Count: 29 cases | confirmed | 29 rows, 29 headings, 29 GIFs. |

### Per-case headings, captions and alt text

For every row I checked the heading function and node interval against the script row (`dump/summary.tsv`), the alt-text window against `xlims`, and the GIF title against the frames. f at the nodes matches mpmath to ≤ 2.7e-16 relative in every case.

| Case | Heading / alt claims | Script row (f, xlims, span) | GIF title | Verdict |
|---|---|---|---|---|
| 01 | 1/(1−x), nodes [−1.5, 0.9]; window [−1.6, 1.5] includes pole x=1; "beyond the pole f ≤ −2, below the window" | 1/(1−x), (−1.6,1.5), (−1.5,0.9), pole 1 | "1/(1-x)" | confirmed. For x∈(1,1.5], f ≤ −2 (f(1.5) = −2); window bottom is −1.646, so f lies below it. Frames show no magenta past x=1. |
| 02 | 1/(1+x), nodes [−0.9, 1.5]; window [−1.5, 1.6]; pole −1; f ≤ −2 beyond pole, below window | matches; ylims bottom −1.646 | "1/(1+x)" | confirmed |
| 03 | 1/(1−x)², nodes [−1.5, 0.9]; window [−1.6, 1.5] includes pole | matches | "1/(1-x)^2" | confirmed |
| 04 | √x, nodes [0, 2], f on [0, 10.5] | matches | "sqrt(x)" | confirmed |
| 05 | √x, nodes [0, 8] | matches | "sqrt(x)" | confirmed |
| 06 | √x, nodes [0, 10] | matches | "sqrt(x)" | confirmed |
| 07 | 1/√(1−x), nodes [−1.5, 0.95]; window [−1.6, 1.5]; f drawn for x<1 | matches; sqrt of a negative throws → NaN | "1/sqrt(1-x)" | confirmed |
| 08 | 1/(1+10x²), nodes [−1, 1], f on [−1.5, 1.5] | matches | "1/(1+10x^2)" | confirmed |
| 09 | ln x, nodes [0.02, 2]; window [−0.5, 4.1]; f for x>0 | matches; log of a negative throws → NaN | "log(x)" | confirmed |
| 10 | ln x, nodes [0.02, 4] | matches | "log(x)" | confirmed |
| 11 | ln(1+x), nodes [−0.98, 1]; window [−1.5, 1.5]; f for x>−1 | matches | "log(1+x)" | confirmed |
| 12 | sin x on [−3π, 3π]; "With 2, 3 and 4 nodes every node is a multiple of π … degree 1, 2 and 3 all show the line y = 0" | auto span = (−3π, 3π) | "sin(x)" | confirmed. Nodes/π = {±3}, {−3,0,3}, {±3,±1}; \|P\| ≤ 3.7e-16 on the grid for n = 2, 3, 4; n=5 nodes include ±1.5π, so P is non-zero. |
| 13 | cos x on [−3π, 3π]; "With 2 and 4 nodes every node is an odd multiple of π … degree 1 and 3 show the line y = −1" | auto span | "cos(x)" | confirmed. n=2: ±3π; n=4: ±3π, ±π; P ∈ [−1−4e-16, −1+6e-16]. |
| 14 | tan x, nodes [−1.45, 1.45] between poles ±π/2; f on [−π, π] broken at poles; degree 1 and 2 same line | matches, poles ±π/2 | "tan(x)" | confirmed. 3 nodes (−1.45, 0, 1.45), y = (−8.238, 0, 8.238); mid − mean(ends) = 0; max\|P₂−P₁\| = 7e-15. |
| 15 | eˣ, nodes [−2, 3], f on the same interval | auto span (−2, 3) | "exp(x)" | confirmed |
| 16 | e⁻ˣ cos x, nodes [−2, 4] | auto span | "cos(x)*exp(-x)" | confirmed (same function) |
| 17 | cosh x, nodes [−4, 4] | auto span | "cosh(x)" | confirmed |
| 18 | arctan x, nodes [−2.2, 2.2]; degree 1 = degree 2 | auto span | "atan(x)" | confirmed; max\|P₂−P₁\| = 4e-16 |
| 19 | arcsin x, nodes [−1, 1]; window [−1.5, 1.5]; f on [−1, 1]; degree 1 = degree 2 | matches | "asin(x)" | confirmed; max\|P₂−P₁\| = 9e-16 |
| 20 | J₀, nodes [−10.2, 10.2] | auto span | "besselj(0,x)" | confirmed |
| 21 | J₁, nodes [−10.2, 10.2]; degree 1 = degree 2 | auto span | "besselj(1,x)" | confirmed; end values ±0.0066157 (J₁ is odd); max\|P₂−P₁\| = 2.6e-18 |
| 22 | e^{−x²/2}/√(2π), nodes [−3, 3] | auto span | "normal_pdf(x)" | confirmed (label names the same function) |
| 23 | ½(1+erf(x/√2)), nodes [−3, 3]; middle node (0, ½) on the chord; degree 1 = degree 2 | auto span | "normal_cdf(x)" | confirmed; nodes y = (0.0013499, 0.5, 0.9986501); mid − mean(ends) = 0 |
| 24 | Γ, nodes [0.05, 2], f on [−0.2, 5.2] | matches | "gamma(x)" | confirmed (see note on the pole at 0 in §1) |
| 25 | Γ, nodes [0.05, 4] | matches | "gamma(x)" | confirmed |
| 26 | Γ, nodes [0.5, 5] | matches | "gamma(x)" | confirmed |
| 27 | Y₀, nodes [0.5, 20], f on [0, 22] | matches | "bessely(0,x)" | confirmed (Y₀(0) = −∞ → NaN, so f is drawn on (0, 22]; trivial) |
| 28 | Y₀, nodes [0.5, 10] | matches | "bessely(0,x)" | confirmed |
| 29 | Y₀, nodes [0.5, 4] | matches | "bessely(0,x)" | confirmed |

"degree rising from 1 to 15" appears in every alt text; it is confirmed by A1.

### Fidelity to the archive

| # | Item | Verdict | Evidence |
|---|---|---|---|
| F1 | Function and plot window for all 29 cases | confirmed | `review/mathews_formulas.png` vs script `xlims`: all 29 equal. |
| F2 | Node intervals 04–06, 08–11, 24–29 | confirmed | Mathews index text "equally spaced nodes in [0,2]", "[0,8]", "[0,10]", "[-1,1]", "[0.02,2]", "[0.02,4]", "[-0.98,1]", "[0.05,2]", "[0.05,4]", "[0.5,5]", "[0.5,20]", "[0.5,10]", "[0.5,4]". |
| F3 | Case 01 nodes [−1.5, 0.9] | confirmed | Mathews `Lagrangeaa.gif` frames: the first node is at −1.5 and the last at 0.9. |
| F4 | Case 07 nodes [−1.5, 0.95], Case 14 nodes [−1.45, 1.45] | confirmed | Static Examples 6 and 11 (`review/ex6_11.png`), which link to Animations 7 and 14. |
| F5 | Node intervals for 02, 03, 12, 13, 15–23 | could not determine | No Mathews GIF in the archive for these, and the index gives no node interval. See §1. |

---

### 3. Implementation checks: `lagnewt_animations_all.jl`

**Is it the method it claims to be?** Yes. It builds the polynomial interpolant through equispaced nodes and evaluates it in the first barycentric form (the "modified Lagrange formula"), which is algebraically identical to the Lagrange form in the Description. The weights are $w_j = 1/\prod_{k\ne j}(x_j-x_k)$ (l.110–120). Evaluation is $\ell(x)\sum_j w_j y_j/(x-x_j)$, with an exact return at a node (l.122–139). No neighbouring method or simplification is involved.

**Are the numbers right?** Yes, checked independently and exhaustively:
- Node placement: all 290 node sets equal $a + (b-a)k/(n-1)$ to ≤ 2.7e-15, so the fallback that trims the interval never triggered (`check.out`, `nodeshift`).
- f at the nodes, compared with mpmath at 60 digits: ≤ 2.7e-16 relative in every case, including SpecialFunctions' `besselj`, `bessely`, `gamma` and `erf` (`fnode_relerr`).
- The interpolant on the whole plot grid, compared with mpmath's Lagrange-form evaluation of the same node data at 60 digits: max relative error 4.4e-9 (Case 29, degree 15, far extrapolation), and typically about 1e-15. Converted to screen terms, the largest discrepancy is 8.7e-10 of the window height, so nothing is visible (`interp_maxrel`, `visible_frac`).
- Interpolation property: the code returns `ys[j]` at nodes, and the drawn nodes are the `(xs, ys)` used to build the polynomial.
- Special structure checks, which do not depend on remembering a formula. In the odd-symmetric cases (14, 18, 19, 21, 23) the middle node lies exactly on the chord, and P₂ ≡ P₁ to ≤ 7e-15. In Case 12 the nodes for n ≤ 4 are multiples of π and \|P\| ≤ 3.7e-16. In Case 13 the nodes for n = 2, 4 are odd multiples of π and P ≡ −1 to 6e-16.
- The page's comparison with the second barycentric form was reproduced in float64: wrong signs occur only in Cases 04 and 29 (D4).

**Are its reference values right?** The only reference is the magenta f curve, which is drawn from the same `case.f`. f was verified against mpmath at all node points (above). The labels `normal_pdf` and `normal_cdf` match the coded functions, e^{−x²/2}/√(2π) and ½+½erf(x/√2). The domain handling is correct: asin, log, sqrt of a negative and bessely of a negative throw and become NaN, and non-finite values (1/0, Y₀(0), Γ(0)) also become NaN.

**Does the picture show what was computed?** Yes. I viewed all 29 contact sheets (all 10 frames each) and these full-size frames: Case 24 frame 1, Case 28 frame 7.
- Titles show the right case id, the coded formula and degree = nodes − 1.
- The legend is f(x) in magenta, the interpolant in blue and the nodes as red dots, and it matches the plotted series.
- Nodes sit on f and on the interpolant.
- y-limits come from robust 3–97% quantiles of f (on the node interval when the case has poles), widened to include every node of every frame, so every node is in view.
- Clamping of the interpolant and of non-pole f is disclosed on the page. It never hides a feature the page talks about: the extrapolation blow-up is shown leaving the window, and the Runge oscillation in Case 08 is visible.
- In the pole cases f is unclamped with NaN breaks at the poles, so there is no false vertical segment.
- The one vertical blue segment (Case 28, degree 9, x ≈ 18.18) is the interpolant's true zero crossing (§1), not an artefact.
- Committed GIFs are byte-identical to a fresh regeneration (manifest), so the frames reviewed are what this script produces.

