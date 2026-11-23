# Newton Interpolation Polynomial — animation review (round 6)

Page: `pages/numerical-methods/newton-interpolation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no error, nothing misleading, and no minor issue that meets the review standard.

To support that clean result, every claim in the ledger (Part 2) was checked against values I computed independently or read from the frames, and all four implementation points were checked for both scripts (Part 3). I also looked at the following and decided they are not findings:

- **Clamped interpolants run along the window edge.** `lagnewt_animations_all.jl:211` (`clamp.(yinterp, ylims...)`) draws any off-scale part of the interpolant exactly on the top or bottom frame line. Two examples: Case 24, degree 7, from x≈2.3 to 5.2, and Case 09, degree ≥5, for x<0. This shows up only as a faint blue tint on the black frame border (full-size check: `committed/lagnewt24/frame_006.png`). It does not suggest a false value or an extra curve, so it is not a finding.
- **Vertical line at x≈18.2 in Case 28, degree 9 (`lagnewt28` frame 7).** This could look like a drawing artifact, but it is real. The degree-9 interpolant of Y₀ on 10 nodes in [0.5, 10] really crosses the window there. Independent check (mpmath, 40 digits, Lagrange form): P(15) = −20.94, P(18) = −17.00, P(18.18) = +0.390, P(20) = 681.8, root at x = 18.17646. The script's values jump from −0.905 to +1.522 between grid points 18.168 and 18.190, which agrees.
- **Pole of Γ at x = 0 inside the Case 24–26 window (no `poles=` entry).** The plot grid `range(-0.2, 5.2, length=1000)` contains x = 0.0 exactly (index 38). There `gamma(0.0)` is `Inf`, so `safe_eval` returns NaN and the curve breaks. No connecting segment is drawn across the pole (checked: indices 37/38/39 give −185.6 / Inf / 184.4, and the frames show the break).
- **Fidelity: degree sequence and "convergence regions".** The legacy animation (`Lagrangeaa.gif`, 36 frames) titles itself "Lagrange Newton Polynomial — Convergence Regions". It shows S₂, S₃, S₅, S₆, S₈, S₁₀, S₁₃, … up to about S₂₅, with a yellow band marking where |P − f| < 0.05. The page uses degrees 1–5, 7, 9, 11, 13, 15 and has no tolerance band. The page claims neither feature: it says only that it matches the legacy *case ordering*, which is true. I treat this as content the page does not have, not as a departure that misleads.
- **Fidelity: Newton module Examples 5–17.** These static examples use some intervals that differ from the animation set, for example sin on [−10, 10] and eˣ on [−5, 5]. The page follows the animation index (`Lagrange.html`), which is the animation set the Newton module links to. Its 29 functions, plot windows and stated node intervals all match that index (see the ledger). Examples 2–4 (error analysis, number theory) are not animations and are out of scope.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 34.0 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtpolyaa.jl` | 0 | 8.1 | newtpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | $P_n(x)=a_0+a_1(x-x_0)+\dots+a_n\prod_{j=0}^{n-1}(x-x_j)$, with $a_k=f[x_0,\dots,x_k]$ | Standard Newton form. `newtpolyaa.jl` builds exactly this with `divided_diff` and nested (Horner) evaluation. Its coefficients match my divided differences from the recursive definition (P3). | confirmed |
| D2 | "For the same nodes and data, Newton and Lagrange forms produce the same polynomial" | Uniqueness of the interpolant. Numerically, the script's barycentric values match my 50-digit Newton-form values to ≤ 2.9e-9 absolute over all 290 frames (P3). | confirmed |
| D3 | "Cases 01–29 … reuse the same interpolation cases as the Lagrange page" | The shared script is byte-identical to the Lagrange page's copy. | confirmed |
| D4 | "… matching the legacy Mathews case ordering" | Case n's function and window equal `Lagrange.html` item n for all 29 cases (formula image montage `review/legacy_formulas_1.png`, `_2.png`). | confirmed |
| D5 | "each case heading gives the function and the node interval [a, b]" | All 29 headings give a function and an interval. Each interval equals the span the script uses (`check_cases.out`: 29/29 `match=True`). | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Each case shows 2, 3, 4, 5, 6, 8, 10, 12, 14, 16 equally spaced nodes (degree 1–5, 7, 9, 11, 13, 15) | `n_nodes_seq` at line 167. Each GIF has 10 frames (manifest) with titles reading degree 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 (all 29 contact sheets read). | confirmed |
| A2 | "for a fixed function and node interval, with nodes at both ends of the interval" | The `equal_nodes` trimming branch never fires. Script nodes equal my exact a + k(b−a)/(n−1) to ≤ 8.9e-16 in all 290 node sets, endpoints included. | confirmed |
| A3 | "The shared script … evaluates it in the first barycentric (Lagrange) form, not by divided differences" | Lines 129–138: `l(x) * Σ w_j y_j/(x−x_j)`, which is the first form. No divided differences appear in the shared script. | confirmed |
| A4 | "The last case … has its own script, which builds the Newton form from divided differences" | `newtpolyaa.jl` lines 13–34. | confirmed |
| A5 | Source link `lagnewt_animations_all.jl`; embeds `lagnewtNN.gif` under "Case NN" | Link target exists. Heading-to-embed wiring was checked programmatically: 29/29 match. Every GIF title reads "Interpolation Case NN" with the matching NN. | confirmed |
| A6 | Link to the Lagrange page | `../lagrange-polynomial-interpolation-and-approximation/index.qmd` exists. | confirmed |

### Per-case headings and alt texts

For every case, the "function" and "node interval" columns were checked three ways: against the script row, against the GIF title (read on every contact sheet), and against `Lagrange.html`. "Window" was checked against `xlims` in the script and against the legacy window image.

| Case | Heading f / nodes | Script f / span | GIF title f | Legacy f / window / nodes | Alt-text window / extra claims | Verdict |
|---|---|---|---|---|---|---|
| 01 | 1/(1−x), [−1.5, 0.9] | same | 1/(1-x) | same / [−1.6,1.5] / nodes [−1.5,0.9] seen in legacy GIF frames | window [−1.6,1.5] ✓. Pole at 1 ✓. "beyond the pole f ≤ −2, below the window": f ≤ −2 on (1,1.5], window ylims lower = −1.646 ✓ | confirmed |
| 02 | 1/(1+x), [−0.9, 1.5] | same | 1/(1+x) | same / [−1.5,1.6] / not stated (mirror of 01) | window ✓. Pole at −1 ✓. f ≤ −2 on [−1.5,−1), ylims lower −1.646 ✓ | confirmed (legacy node span: could not determine, no legacy GIF) |
| 03 | 1/(1−x)², [−1.5, 0.9] | same | 1/(1-x)^2 | same / [−1.6,1.5] / not stated | window ✓, pole ✓ | confirmed (legacy node span: could not determine) |
| 04 | √x, [0, 2] | same | sqrt(x) | same / [0,10.5] / [0,2] | f on [0,10.5] ✓ | confirmed |
| 05 | √x, [0, 8] | same | sqrt(x) | [0,8] | ✓ | confirmed |
| 06 | √x, [0, 10] | same | sqrt(x) | [0,10] | ✓ | confirmed |
| 07 | 1/√(1−x), [−1.5, 0.95] | same | 1/sqrt(1-x) | same / [−1.6,1.5] / Newton Ex 6 uses [−1.5,0.95] | window ✓. "f drawn for x<1": `sqrt` of a negative throws, giving NaN ✓ | confirmed |
| 08 | 1/(1+10x²), [−1, 1] | same | 1/(1+10x^2) | same / [−1.5,1.5] / [−1,1] | f on [−1.5,1.5] ✓ | confirmed |
| 09 | ln x, [0.02, 2] | same | log(x) | same / [−0.5,4.1] / [0.02,2] | window ✓. f for x>0 ✓ | confirmed |
| 10 | ln x, [0.02, 4] | same | log(x) | [0.02,4] | ✓ | confirmed |
| 11 | ln(1+x), [−0.98, 1] | same | log(1+x) | same / [−1.5,1.5] / [−0.98,1] | window ✓. f for x>−1 ✓ | confirmed |
| 12 | sin x, [−3π, 3π] | span = window = ±9.42477796 | sin(x) | same / [−3π,3π] | see C12 below | confirmed |
| 13 | cos x, [−3π, 3π] | same | cos(x) | same | see C13 | confirmed |
| 14 | tan x, [−1.45, 1.45] | same, poles ±π/2 | tan(x) | same / [−π,π] / Newton Ex 11 [−1.45,1.45] | nodes lie between the poles (1.45 < 1.5708) ✓. f on [−π,π] broken at the poles (NaN inserted) ✓, visible in frames. See C-odd | confirmed |
| 15 | eˣ, [−2, 3] | same | exp(x) | same / [−2,3] | ✓ | confirmed |
| 16 | e⁻ˣ cos x, [−2, 4] | same | cos(x)*exp(-x) | same / [−2,4] | ✓ | confirmed |
| 17 | cosh x, [−4, 4] | same | cosh(x) | same / [−4,4] | ✓ | confirmed |
| 18 | arctan x, [−2.2, 2.2] | same | atan(x) | same / [−2.2,2.2] | ✓, C-odd | confirmed |
| 19 | arcsin x, [−1, 1] | same | asin(x) | same / [−1.5,1.5] (Newton Ex 14 [−1,1]) | window ✓. "f drawn on [−1,1] (its whole domain)": `asin` throws for \|x\|>1 ✓. C-odd | confirmed |
| 20 | J₀, [−10.2, 10.2] | same | besselj(0,x) | same / [−10.2,10.2] | ✓ | confirmed |
| 21 | J₁, [−10.2, 10.2] | same | besselj(1,x) | same | ✓, C-odd | confirmed |
| 22 | e^{−x²/2}/√(2π), [−3, 3] | same | normal_pdf(x) (label, consistent with code) | same / [−3,3] | ✓ | confirmed |
| 23 | ½(1+erf(x/√2)), [−3, 3] | same | normal_cdf(x) | same / [−3,3] | ✓, C-odd | confirmed |
| 24 | Γ, [0.05, 2] | same | gamma(x) | same / [−0.2,5.2] / [0.05,2] | f on [−0.2,5.2] ✓ (break at the pole, see Part 1) | confirmed |
| 25 | Γ, [0.05, 4] | same | gamma(x) | [0.05,4] | ✓ | confirmed |
| 26 | Γ, [0.5, 5] | same | gamma(x) | [0.5,5] | ✓ | confirmed |
| 27 | Y₀, [0.5, 20] | same | bessely(0,x) | same / [0,22] / [0.5,20] | f on [0,22] ✓ | confirmed |
| 28 | Y₀, [0.5, 10] | same | bessely(0,x) | [0.5,10] | ✓ | confirmed |
| 29 | Y₀, [0.5, 4] | same | bessely(0,x) | [0.5,4] | ✓ | confirmed |

Every alt text also says "degree rising from 1 to 15", which is confirmed (A1).

For the cases whose nodes span the whole window (12, 13, 15–18, 20–23), `Lagrange.html` gives only "over the interval [window]" with no separate node interval. Using the whole window as the node interval agrees with that, but there is no legacy GIF for these cases to confirm it. Fidelity of their node spans: could not determine beyond that.

### Case-specific behaviour paragraphs

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C12 | "With 2, 3 and 4 nodes every node is a multiple of π … every divided difference is zero and the frames titled degree 1, 2 and 3 all show the line y = 0" (also in the alt text) | Nodes: {±3π}, {−3π,0,3π}, {±3π,±π}. 50-digit divided differences are all ≤ 1e-50. With 5 nodes the nodes include ±1.5π, so the claim correctly stops at 4. The frames show y = 0 at degrees 1–3. | confirmed |
| C13 | "With 2 and 4 nodes every node is an odd multiple of π … a₀ = −1, every later divided difference is zero, … degree 1 and 3 show the line y = −1" (also in the alt text) | n=2: a = [−1, 0]. n=4: a = [−1, 0, 0, 0]. n=3 includes x=0 (cos = 1), so degree 2 correctly excluded. Frames confirm. | confirmed |
| C-odd (14, 18, 19, 21, 23) | "f (or f − ½) is odd and the nodes are symmetric … middle node (0,0) [(0,½) for 23] lies on the line … f[x₀,x₁,x₂] = 0, and the frames titled degree 1 and 2 show the same line" | 50-digit a₂ = 0 exactly for all five. The script's degree-1 and degree-2 interpolants agree with mine to ≤ 1.1e-15. The contact sheets show identical lines in frames 1 and 2. Middle node is exactly 0 in the script (node_dx = 0). | confirmed (×5) |

### Divided-differences case (`newtpolyaa`)

| # | Claim | Evidence (mine vs script) | Verdict |
|---|---|---|---|
| N1 | Heading: f = cos x, nodes x_k = k/5 on [0, 1] | Script lines 36–39. Legacy Example 1 image: `f[x] = Cos[x]`, nodes {0, 1/5, …, 4/5, 1} | confirmed |
| N2 | "This is Mathews' Example 1" | `NewtonPolyMod_lnk_2..4`: Example 1, degrees n = 1…5 on [x₀, xₙ] | confirmed |
| N3 | "Each frame adds the next node x_n = n/5 and one more Newton term … the coefficients already found do not change" | Instrumented run: each frame's coefficient vector extends the previous one unchanged | confirmed |
| N4 | a₀…a₅ = 1, −0.0996671, −0.488402, 0.0490076, 0.0381225, −0.00396205 | Mine (recursive definition, 40 digits): 1.0, −0.0996671, −0.488402, 0.0490076, 0.0381225, −0.00396205. Script: −0.09966711079, −0.48840202099, 0.04900763385, 0.03812245731, −0.00396204671 | confirmed |
| N5 | Largest error on [x₀, xₙ]: 4.97e-3 (deg 1), 1.16e-4 (deg 2), 1.35e-6 (deg 5) | Mine (refined maxima): 4.9709e-3, 1.16469e-4, 1.349995e-6. Script: 4.97089e-3, 1.164690e-4, 1.349993e-6. GIF titles also show deg 3: 6.42e-05 (mine 6.42495e-5) and deg 4: 4.23e-06 (mine 4.23056e-6) | confirmed |
| N6 | "so there the curves coincide in the frames" | 5e-3 at most on a 1.7-unit y-range in about 430 px is about 1 px. Frames show overlap. | confirmed |
| N7 | Frames drawn on [−0.5, 2.1], "as in Mathews' graphs" | Script `xlims=(-0.5, 2.1)`. Legacy graphs span −0.5…2.1 | confirmed |
| N8 | Error at x = 2.1: 1.30, 0.65, 0.32, 0.067, 0.015 | Mine: 1.296, 0.6532, 0.3208, 0.06712, 0.01471 | confirmed |
| N9 | Degree-2 and degree-3 polynomials leave the bottom of the plot near x = 1.81 and 1.95 | Bottom ylim −0.6. Mine: P₂ = −0.6 at x = 1.8079, P₃ at 1.9488. Degrees 1, 4, 5 stay inside [−0.6, 1.1] (ranges [0.79, 1.05], [−0.438, 1.0], [−0.490, 1.0]), so only 2 and 3 leave | confirmed |
| N10 | Alt: one node per frame, degree 1 (2 nodes) to 5 (6 nodes) | 5 frames (manifest), titles "degree n (n+1 nodes)" | confirmed |
| N11 | Alt: [x₀, xₙ] shaded; dashed polynomial passes through every node | `vspan!` over [x₀, xₙ]; P drawn red dashed; nodes on the curve in all frames | confirmed |
| N12 | Alt: largest error on the shaded interval "falls from 4.97e-3 to 1.35e-6"; gap at x = 2.1 "shrinks from 1.30 to 0.015" | Both sequences are monotone decreasing (N5, N8) | confirmed |
| N13 | Source link `newtpolyaa.jl`, embed `newtpolyaa.gif` | Both exist; GIF is byte-identical to a fresh run (manifest) | confirmed |

---

### 3. Implementation checks

### `lagnewt_animations_all.jl` (shared with the Lagrange page, byte-identical)

**Method.** The script computes the polynomial interpolant on equally spaced nodes and evaluates it with the first barycentric form `l(x)·Σ w_j y_j/(x−x_j)`, with weights `w_j = 1/∏_{k≠j}(x_j−x_k)`. That is a valid evaluation of the unique interpolant, and the page says plainly that it is not the divided-difference form (A3). At |x − x_j| ≤ 1e-12 it returns y_j exactly. Node construction is `range(a, b, length=n)`. The trimming fallback in `equal_nodes` (attempt > 0) never triggers for any of the 290 node sets.

**Numbers.** Instrumented copy `review/lagnewt_instr.jl` dumped, for all 29 cases × 10 node counts: the span, ylims, nodes, node values, and the unclamped interpolant on the 1000-point plot grid (`review/dump.txt`). Independent check `review/check_cases.py` (system Python, mpmath at 50 digits) does the following:
- builds nodes from the *page's* stated intervals;
- evaluates f with mpmath's own sqrt, log, tan, asin, Bessel J/Y, erf and gamma;
- forms the Newton divided-difference table;
- evaluates the Newton form at each plot point.

Results (`review/check_cases.out`):
- span equals the page heading interval: 29/29;
- max node-position difference: 8.9e-16;
- max node-value difference: 1.4e-14;
- max |P_script − P_mine| where the curve is visible: 2.9e-9. The worst case is a degree-15 interpolant with large extrapolated values; the max relative difference over the whole grid is 5.9e-9.

So the plotted interpolants are the correct polynomials to plotting accuracy everywhere.

**Reference values.** The "f(x)" curve is the library function itself (Base, SpecialFunctions 2.7.2). Node values agree with mpmath to ≤ 1.4e-14, which covers Γ, J₀, J₁, Y₀ and erf.

**Picture.**
- Read on all 29 contact sheets: titles (case id, function label, degree) and legends (f(x) magenta, interpolant steel-blue, nodes red) are correct. Every interpolant passes through its red nodes.
- Y-limits: for 01–03 and 14, from f on the node interval, widened to include every node value. For the others, from the 3%–97% range of f on the window, also widened to include the nodes. All nodes are visible in every frame.
- Pole handling: f is broken with NaN at the listed poles (01–03, 14). At Γ's pole x = 0 (cases 24–26) the grid hits 0.0 exactly, giving `Inf`, then NaN. Y₀(0) = −Inf gives NaN. Outside its domain f throws and gives NaN (07, 09–11, 19).
- Clamping: interpolants are clamped to the frame edge (discussed in Part 1, not misleading). The one feature that looks like an artifact, the vertical line in Case 28 at degree 9, is a genuine crossing of the window at x = 18.176.

### `newtpolyaa.jl`

**Method.** It is the Newton divided-difference method as the page describes it. `divided_diff` updates the table in place (`d[i] = (d[i]−d[i−1])/(x_i − x_{i−j+1})`) and takes the top entry of each column as a_k. `newton_eval` is nested (Horner) evaluation of the Newton form. Each frame recomputes the table for nodes 0..n. The leading coefficients are unchanged between frames, as claimed (N3).

**Numbers.** Instrumented copy `review/newtpolyaa_instr.jl` printed the coefficients and errors per frame. My independent computation (mpmath, 40 digits) does not use the script's table. It uses:
- the recursive divided-difference definition, for the coefficients;
- the Lagrange form, for the polynomial values;
- `findroot` on the derivative, for the error maxima.

Every value agrees to the digits shown (N4, N5, N8, N9). The script's maximum error over 4001 grid points matches the true maximum to 5 or more significant figures.

**Reference values.** cos x from Base. There are no other reference values.

**Picture.** The title shows the new coefficient a_n and the max error with the right index and the right interval [0, n/5] (`%.1f` of xs_n[end]). The shaded span is [x₀, xₙ]. P is red dashed and cos is blue. Full-size check of frame 3 (`committed/newtpolyaa/frame_003.png`): the title reads a_3 = 0.0490076 and max error 6.42e-05 on [0, 0.6], and P₃ leaves the bottom near x ≈ 1.95. The window [−0.5, 2.1] × [−0.6, 1.1] clips only P₂ and P₃, exactly as the page states.

### Commands run (key ones)

- `diff …/newton-interpolation-polynomial/lagnewt_animations_all.jl …/lagrange-polynomial-interpolation-and-approximation/lagnewt_animations_all.jl` gives no output (identical).
- `julia review/lagnewt_instr.jl` then `/usr/bin/python3 review/check_cases.py review/dump.txt`: summary 290 node sets, max node dx 8.9e-16, max dy 1.4e-14, max visible |ΔP| 2.9e-9, max rel 5.9e-9; 29/29 spans match the page.
- `julia review/newtpolyaa_instr.jl`: per-frame coefficients and errors as quoted in N4/N5.
- mpmath scripts (inline) for: Example 1 coefficients, error maxima, error at 2.1 and exit points; the Case 28 degree-9 root at 18.17646; gamma on the plot grid near 0.
- `giftools.jl` on the legacy `Lagrange01/Lagrangeaa.gif` (36 frames; nodes span −1.5…0.9). On `Lagrange09/Lagrangeii.gif` it produced no frames. That did not matter because Case 09's node interval is stated in the text of `Lagrange.html`.

