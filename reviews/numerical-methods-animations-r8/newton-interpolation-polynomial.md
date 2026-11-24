# Newton Interpolation Polynomial — animation review (round 8)

Page: `pages/numerical-methods/newton-interpolation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: the animations stop at degree 15 and leave out Mathews' "convergence region" band

- **Location:** `lagnewt_animations_all.jl` line 169, `n_nodes_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]`, and the page introduction (index.qmd line 24): "Cases 01–29 each show the interpolant on 2, 3, … 16 equally spaced nodes (degree 1 to 5, then 7, 9, 11, 13 and 15)".
- **What is there now:** each case runs from degree 1 to degree 15 in 10 frames. Nothing marks where the interpolant is within a tolerance of f.
- **Legacy:** the two surviving legacy animations are titled "Lagrange Newton Polynomial / Convergence Regions". Case 01 (`Lagrangeaa.gif`, 34 frames) runs up to S₂₅ and case 04 (`Lagrangedd.gif`, 29 frames) up to S₂₀. Each frame draws a yellow bar marking the x-range where |S_n − f| < 0.05 ("Tolerance ±0.05"), with green verticals at the ends of the node interval. I extracted the frames with `giftools.jl` into `review/legacy_Lagrangeaa/` and `review/legacy_Lagrangedd/`; `review/legacy_last_frames.png` shows the last frame of each.
- **Why it matters (a little):** in Mathews the high-degree frames and the tolerance band show which part of the interval converges, for example on √x over [0, 2] (Case 04) and 1/(1−x) (Case 01). The page's frames show the same curves only up to degree 15, with no band. The page itself is accurate about what it shows: it states its own degree sequence correctly, and it never claims to match Mathews' degree range. So this is a silent departure, not a false statement.
- **Suggested correction:** either extend `n_nodes_seq` toward Mathews' range (for example up to 21 or 26 nodes; the first barycentric form stays accurate, see §3) and optionally shade the region where |P − f| < 0.05, or add one sentence to the introduction saying that the legacy animations went to degree 20–25 and marked a ±0.05 convergence region, and that these frames stop at degree 15.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 36.8 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtpolyaa.jl` | 0 | 7.5 | newtpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| `newtpolyaa.gif` | 5 | byte-identical | newtpolyaa |

### Page references

- Scripts linked: `lagnewt_animations_all.jl`, `newtpolyaa.jl`
- GIFs embedded: 30
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **C** = confirmed, **W** = wrong, **?** = could not determine.

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | $P_n(x)=a_0+a_1(x-x_0)+\dots+a_n\prod_{j<n}(x-x_j)$ with $a_k=f[x_0,\ldots,x_k]$ | This is the standard Newton form. `newtpolyaa.jl` implements it (divided-difference table plus nested evaluation), and my independent recursive `dd(i,j)` gives the same coefficients (§3) | C |
| D2 | "Newton and Lagrange forms produce the same polynomial" | Uniqueness of the interpolant. Numerically, my mpmath Newton-form evaluation matches the script's barycentric evaluation to ≤ 5.6e-9 of the y-span in all 290 frames | C |
| D3 | Cases 01–29 "reuse the same interpolation cases as the Lagrange page" | Shared script is byte-identical, and the `### Case` headings are identical | C |
| D4 | "matching the legacy Mathews case ordering" | The legacy index formula images (montage in `review/legacy_formulas.png`) list the same 29 functions and plot windows in the same order | C |
| D5 | "each case heading gives the function and the node interval [a, b]" | Every heading's interval equals the script's resolved node span (table in §3) | C |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | 2, 3, 4, 5, 6, 8, 10, 12, 14, 16 nodes, degree 1–5, 7, 9, 11, 13, 15 | `n_nodes_seq` at line 169. Each GIF has 10 frames (manifest), and frame titles read degree 1…15 (contact sheets) | C |
| A2 | "equally spaced nodes … with nodes at both ends of the interval" | Dumped nodes equal `linspace(a, b, n)` from the heading to ≤ 8.9e-16 for all 29×10 node sets, so the trimming fallback in `equal_nodes` never fired | C |
| A3 | "The degree in each title is the number of nodes minus one … its actual degree can be lower" | Title string `degree $(n_nodes - 1)` | C |
| A4 | Even $f$ with symmetric nodes gives only even powers; odd $f$ gives only odd powers | Vandermonde solve in 50 digits (`indep_symm.py`): the odd-power coefficients are ~1e-47 or smaller for 08/13/17/20/22, and the even-power ones are ~1e-48 or smaller for 12/14/18/19/21 | C |
| A5 | Even cases are exactly 08, 13, 17, 20, 22 | The other symmetric-node cases are odd (12, 14, 18, 19, 21) or odd about ½ (23). The rest have asymmetric spans | C |
| A6 | In the even cases the degree-1 frame is a horizontal line | Degree-1 slope is 0 (exact or ≤ 3e-57) in all five. Frame 1 of 08/13/20/22 is visibly horizontal on the sheets | C |
| A7 | In the even cases the frame titled degree 15 has degree 14 | x¹⁵ coefficient ≈ 0. x¹⁴ coefficient is nonzero: −371 (08), −3.65e-12 (13), 1.4e-11 (17), −7.2e-13 (20), −1.27e-7 (22) | C |
| A8 | The shared script uses the first barycentric form, not divided differences | Lines 124–141 | C |
| A9 | "The last case on this page has its own script, which builds the Newton form from divided differences" | `newtpolyaa.jl` lines 13–34 | C |
| A10 | Source link `lagnewt_animations_all.jl` | File exists in the page folder and produces all 29 GIFs byte-identically (manifest) | C |

### Per case (heading, alt text, GIF title). The function and interval in each heading were checked against the script row, the GIF title (contact sheets), my independent nodes, and the legacy index.

| Case | Heading f, nodes | Script row | GIF title | Alt-text window / display claims | Verdict |
|---|---|---|---|---|---|
| 01 | 1/(1−x), [−1.5, 0.9] | match | `1/(1-x)` | window [−1.6, 1.5] ✓. Pole at 1 ✓. "beyond the pole f ≤ −2, below the window": f(1.5) = −2 and f ≤ −2 on (1, 1.5]; y-min is −1.646 ✓ | C |
| 02 | 1/(1+x), [−0.9, 1.5] | match | `1/(1+x)` | [−1.5, 1.6] ✓. Pole −1 ✓. f ≤ −2 below y-min −1.646 ✓ | C |
| 03 | 1/(1−x)², [−1.5, 0.9] | match | `1/(1-x)^2` | [−1.6, 1.5] ✓. Pole ✓ (right branch visible, no contrary claim) | C |
| 04 | √x, [0, 2] | match | `sqrt(x)` | f on [0, 10.5] ✓ | C |
| 05 | √x, [0, 8] | match | ✓ | ✓ | C |
| 06 | √x, [0, 10] | match | ✓ | ✓ | C |
| 07 | 1/√(1−x), [−1.5, 0.95] | match | ✓ | [−1.6, 1.5]. f drawn only for x < 1 (DomainError → NaN) ✓ | C |
| 08 | 1/(1+10x²), [−1, 1] | match | ✓ | f on [−1.5, 1.5] ✓ | C |
| 09 | ln x, [0.02, 2] | match | `log(x)` | [−0.5, 4.1]. f for x > 0 ✓ | C |
| 10 | ln x, [0.02, 4] | match | ✓ | ✓ | C |
| 11 | ln(1+x), [−0.98, 1] | match | ✓ | [−1.5, 1.5]. f for x > −1 ✓ | C |
| 12 | sin x, [−3π, 3π] | auto span = window ends ±9.42477796 | ✓ | Degrees 1, 2, 3: nodes {±3π}, {±3π, 0}, {±3π, ±π}, all multiples of π. Node values ≤ 8e-51 in 50-digit arithmetic, and frames 1–3 show y = 0 | C |
| 13 | cos x, [−3π, 3π] | auto span ✓ | ✓ | Degrees 1 and 3: node values all −1 (computed), frames show y = −1. Degree 2 includes x = 0, where cos 0 = 1 (so not claimed) ✓ | C |
| 14 | tan x, [−1.45, 1.45] | match, poles ±π/2 | ✓ | f[x₀,x₁,x₂] = 0 (x² coeff 0). Degree 1 and 2 frames show the same line. f on [−π, π] is broken at the poles ✓ | C |
| 15 | eˣ, [−2, 3] | auto span ✓ | ✓ | ✓ | C |
| 16 | e⁻ˣcos x, [−2, 4] | auto span ✓ | `cos(x)*exp(-x)` | ✓ | C |
| 17 | cosh x, [−4, 4] | auto span ✓ | ✓ | ✓ | C |
| 18 | arctan x, [−2, 2] | match | ✓ | f on [−2.2, 2.2]. Degree 1 = degree 2 ✓ | C |
| 19 | arcsin x, [−1, 1] | match | ✓ | window [−1.5, 1.5]. f drawn on [−1, 1]. Degree 1 = degree 2 ✓ (sheet) | C |
| 20 | J₀, [−10, 10] | match | `besselj(0,x)` | f on [−10.2, 10.2] ✓ | C |
| 21 | J₁, [−10.2, 10.2] | auto span ±10.2 ✓ | ✓ | Degree 1 = degree 2 (x² coeff 0, slope −6.5e-4) ✓ | C |
| 22 | e^{−x²/2}/√(2π), [−3, 3] | auto ✓ | `normal_pdf(x)` | ✓ | C |
| 23 | ½(1+erf(x/√2)), [−3, 3] | auto ✓ | `normal_cdf(x)` | Middle node (0, ½). Degree 1 = degree 2 ✓ (sheet) | C |
| 24 | Γ, [0.05, 2] | match | `gamma(x)` | f on [−0.2, 5.2] ✓. The pole at 0 is not in `poles`, but xplot hits x = 0 exactly, where `gamma(0.0)` is not finite, so the NaN breaks the curve (dump: index 37, x = 0.0, NaN). No spurious connector (sheet) | C |
| 25 | Γ, [0.05, 4] | match | ✓ | ✓ | C |
| 26 | Γ, [0.5, 5] | match | ✓ | ✓ | C |
| 27 | Y₀, [0.5, 20] | match | `bessely(0,x)` | f on [0, 22] ✓ | C |
| 28 | Y₀, [0.5, 10] | match | ✓ | ✓ | C |
| 29 | Y₀, [0.5, 4] | match | ✓ | ✓ | C |

Wiring: the 30 `![](…)` embeds point at `lagnewt01.gif` … `lagnewt29.gif` and `newtpolyaa.gif`, in heading order. Each GIF's title carries its case id (sheets). **C**. The page is linked from the section index (`pages/numerical-methods/index.qmd` line 60). **C**.

### Divided-differences case (`newtpolyaa`)

| # | Claim | Independent value (`indep_aa.py`, mpmath 40 digits) | Verdict |
|---|---|---|---|
| N1 | f = cos x, nodes x_k = k/5 on [0, 1], "Mathews' Example 1" | Legacy formula images gr_109 `f[x] = Cos[x]`, gr_111 `{(x_k,y_k)} = {(0,1),(1/5,Cos[1/5]),…,(1,Cos[1])}`, gr_110 `[x_0, x_n]` | C |
| N2 | Each frame adds node x_n = n/5 and one Newton term; earlier coefficients unchanged | Script: `all_xs[1:n+1]`. In the coefficient table each a_k depends only on x_0..x_k | C |
| N3 | a₀…a₅ = 1, −0.0996671, −0.488402, 0.0490076, 0.0381225, −0.00396205 | 1, −0.099667111, −0.48840202, 0.049007634, 0.038122457, −0.0039620467 | C |
| N4 | Max error on [x₀, x_n]: 4.97e-3 (deg 1), 1.16e-4 (deg 2), 1.35e-6 (deg 5) | 4.971e-3, 1.165e-4, 1.350e-6 (also 6.425e-5 for deg 3 and 4.231e-6 for deg 4, matching the frame titles 6.42e-05 and 4.23e-06) | C |
| N5 | "there the curves coincide in the frames" | ≤ 5e-3 on a 1.7-unit y-range, about 1–2 px; the sheet shows overlap on the shaded interval | C |
| N6 | Drawn on [−0.5, 2.1] "as in Mathews' graphs" | Legacy gr_140: `PlotRange -> {{-0.5, 2.1}, {-0.5, 1.05}}`. Script uses xlims (−0.5, 2.1) | C |
| N7 | Error at x = 2.1: 1.30, 0.65, 0.32, 0.067, 0.015 | 1.296, 0.6532, 0.3208, 0.06712, 0.01471 | C |
| N8 | Degree-2 and degree-3 polynomials leave the bottom of the plot near x = 1.81 and 1.95 | P₂ = −0.6 at x = 1.8079 and P₃ = −0.6 at 1.9488 (y-min is −0.6). P₄ never reaches −0.6 and P₅ only at 2.2457, outside the window, so only degrees 2 and 3 leave | C |
| N9 | Alt: shaded [x₀, x_n], dashed polynomial through every node, error 4.97e-3 → 1.35e-6, gap 1.30 → 0.015 at 2.1 | Sheet shows the shaded `vspan`, the dashed P_n and black nodes. Node residual is 0 (mpmath) | C |
| N10 | Source link `newtpolyaa.jl` | Exists and regenerates the GIF byte-identically (manifest) | C |

---

### 3. Implementation checks

### `lagnewt_animations_all.jl`

1. **It is the method it claims to be.** The page says, correctly, that this script evaluates the interpolant in the first barycentric form `l(x)·Σ w_j y_j/(x−x_j)`, with weights `w_j = 1/∏_{k≠j}(x_j−x_k)`, and not by divided differences. The polynomial is the unique interpolant, so it is the Newton polynomial drawn in another representation, and the page discloses this (A8).
2. **The numbers are right.** I instrumented a copy (`review/inst_all.jl`, which reuses the script's own functions) to dump, for every case and every node count, the nodes, node values, interpolant values on the 1000-point xplot, the resolved span and the y-limits (`review/dump_all.txt`). The independent check (`review/indep_all.py`) builds nodes from the page headings, evaluates f in mpmath (60 digits), builds the Newton form from an independent divided-difference table, and evaluates it at the same x. Results, maximum over all 10 frames of each case:
   - Node deviation from the heading's linspace is ≤ 8.9e-16 in all cases, so endpoints are always included and no trimming occurred.
   - The relative deviation of f at the nodes is ≤ 2.7e-16.
   - The deviation of the interpolant over the visible band (|y| within one y-span of the axes), divided by the y-span, is ≤ 6.2e-11 in all cases except 28 (2.9e-10) and 29 (5.6e-9), which come from extrapolation far beyond [0.5, 4]. None of this is visible.
   - Also checked: the interpolant reproduces the data at the nodes (the script returns y_j exactly when |x − x_j| ≤ 1e-12, and the mpmath form reproduces them identically). The parity properties hold (A4–A7).
3. **Its reference values are right.** The "reference" here is f itself, from Base/SpecialFunctions. The node values agree with mpmath to 1e-16 for all 22 distinct functions, including J₀, J₁, Y₀, Γ and erf.
4. **The picture shows what was computed.** I viewed contact sheets for cases 01, 02, 03, 04, 06, 07, 08, 09, 11, 12, 13, 14, 16, 19, 20, 22, 23, 24, 27 and 29. For the remaining cases (05, 10, 15, 17, 18, 21, 25, 26, 28) the title strings come from the same `formula_label` field (checked in code), and the data were checked numerically. On the sheets:
   - Titles carry the right case id, function and `n_nodes − 1`.
   - f is magenta, the interpolant blue and the nodes red, matching the legend.
   - Poles are broken (01, 02, 03, 14 via `poles`; 24–26 via the NaN at x = 0; 07, 09, 11, 19, 27–29 via domain NaN).
   - Off-scale values are clamped to one y-span beyond the axes, so curves leave the frame instead of running along its edge. That is acceptable display.
   - The y-limits include every node of every frame (Case 03 goes to 112.6 to show the node at f(0.9) = 100).
   - I found no element drawn from the wrong quantity.

### `newtpolyaa.jl`

1. **Method:** a genuine Newton divided-difference table (in place, column by column; `coeffs` takes the diagonal) with nested (Horner-type) evaluation `val = val·(x−x_i) + a_i`. This is the Newton form.
2. **Numbers:** coefficients and errors were checked against an independent recursive `dd(i,j)` in 40-digit mpmath (N3, N4, N7, N8). They agree to every printed digit.
3. **Reference:** `cos` is exact to machine precision. The script finds the maximum error with a 4001-point grid; my grid-plus-`findroot` refinement gives the same 3 significant figures.
4. **Picture:** the sheet shows 5 frames, degree 1–5. Each frame has the shaded [x₀, x_n], blue cos, dashed red P_n through all black nodes, and a title with the new coefficient a_n and the max error that match my values. The degree-2 and degree-3 curves exit the bottom near 1.81 and 1.95, as the page says.

### Reproduction

The manifest reports that every committed GIF is byte-identical to a fresh scratch run of its script. I did not re-render any GIFs; my runs were the instrumented dump only.

