# Newton Interpolation Polynomial — animation review (round 5)

Page: `pages/numerical-methods/newton-interpolation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.


#### Could not determine / observations (not findings)

- **Node intervals for Cases 02, 03, 12, 13, 15–23 in the legacy animations.** The legacy animation index (`a2001/.../Lagrange/Lagrange.html`) gives the function and the plot window for all 29 cases. It gives the node interval only for 04–06, 08–11 and 24–29, and all of those match the script. The legacy animated GIF survives only for Case 01 (`Lagrange01/Lagrangeaa.gif`). Its frames show nodes from −1.5 to 0.9, which matches the script. For the other cases the GIFs are missing, so the legacy node interval cannot be recovered. The script uses the whole window as the node interval, which is a reasonable choice. The Newton module's static Examples 9, 10, 12, 13 and 15 use different intervals: sin and cos on [−10, 10], eˣ on [−5, 5], arctan on [−2, 2] and J₀ on [−10, 10]. For eˣ, nodes on [−5, 5] would fall far outside the animation window [−2, 3], so those static examples are evidently not the animation setups. The page claims only to follow the animation list's ordering (line 20), and it makes no claim about the static examples.
- **Legacy presentation not carried over.** The surviving legacy animation (Case 01) runs to about degree 30 over 34 frames and draws a yellow "Convergence Regions, Tolerance ±0.05" band. The page stops at degree 15 and has no tolerance band. This is content the page does not have, not something false, so it is not a finding.
- **Clamping display device (shared script).** The interpolant is clamped to the y-limits, so where it leaves the window it runs along the frame edge. Examples are Cases 05, 09–11, 24 and 25. It reads as "off scale" and changes no conclusion the page draws. In Case 28, degree 9, a near-vertical blue line at x ≈ 18.2 looks like an artifact but is real. My mpmath Newton form gives P₉(15) = −20.9, P₉(18) = −17.0, P₉(18.2) = +2.63 and a sign change at x = 18.18, so the polynomial genuinely sweeps from below the window to above it there.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 35.4 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtpolyaa.jl` | 0 | 6.9 | newtpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: C = confirmed, W = wrong, ? = could not determine.

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | P_n(x)=a₀+a₁(x−x₀)+…+a_n∏_{j<n}(x−x_j), a_k=f[x₀,…,x_k] | `newtpolyaa.jl` `divided_diff`/`newton_eval` implement exactly this. Its coefficients match my recursive dd(i,j) definition to all printed digits (Section 3). | C |
| D2 | "For the same nodes and data, Newton and Lagrange forms produce the same polynomial" | Uniqueness of the interpolant. Numerically, the shared script's barycentric values match my mpmath Newton form (max scaled diff ≤ 5.4e-9 over all 29 cases × 10 degrees). | C |
| D3 | "Cases 01–29 … reuse the same interpolation cases as the Lagrange page … matching the legacy Mathews case ordering" | Case headings are identical to the Lagrange page (`diff` of `### Case` lines is empty), and that page embeds the same 29 GIFs. The order and functions match the legacy index montage (`review/legacy_formulas.png`). | C |
| D4 | "each case heading gives the function and the node interval [a, b]" | Each heading's interval equals the script's `resolved_span` (instrumented dump `review/lag_dump.txt`). | C |

### Animations intro

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | 2, 3, 4, 5, 6, 8, 10, 12, 14, 16 equally spaced nodes (degree 1–5, 7, 9, 11, 13, 15) | `n_nodes_seq` in the script, and the frame titles on all 29 contact sheets | C |
| A2 | 29 cases; one GIF per case, 10 frames each | 29 GIFs × 10 frames (manifest and contact sheets) | C |
| A3 | "with nodes at both ends of the interval" | The instrumented copy logged `trimmed false` for every case and node count: `equal_nodes` never moved a node inward. | C |
| A4 | "The shared script … evaluates it in the first barycentric (Lagrange) form, not by divided differences" | `barycentric_eval` computes l(x)·Σ w_j y_j/(x−x_j) with w_j = 1/∏(x_j−x_k). That is the first (modified Lagrange) form. | C |
| A5 | "The last case … has its own script, which builds the Newton form from divided differences" | `newtpolyaa.jl` | C |
| A6 | Source link `lagnewt_animations_all.jl`, `newtpolyaa.jl` | Files exist beside the page and produced the committed GIFs (byte-identical regeneration) | C |

### Per-case headings, alt text and GIF titles (Cases 01–29)

For every case I checked four things. (a) The heading function and node interval match the script row and the instrumented span. (b) The GIF title in all 10 frames reads "Interpolation Case NN: f(x) = …" with the same function. (c) The window the alt text states equals the script's `xlims`. (d) The embed `lagnewtNN.gif` is the case-NN GIF (the title in the frames says Case NN). All of these hold for all 29 cases.

| Case | Heading f, nodes | Script row (f, xlims, span) | Alt-text window/extra claims | Verdict |
|---|---|---|---|---|
| 01 | 1/(1−x), [−1.5, 0.9] | same, (−1.6,1.5), (−1.5,0.9) | window [−1.6,1.5] includes pole at 1: C. "beyond the pole f ≤ −2, below the window": f on (1,1.5] ≤ −2, and the y-lower limit is −1.646, so C | C |
| 02 | 1/(1+x), [−0.9, 1.5] | same, (−1.5,1.6), (−0.9,1.5) | pole at −1. Beyond it f ≤ −2, and y-lower is −1.646: C | C |
| 03 | 1/(1−x)², [−1.5, 0.9] | same, (−1.6,1.5), (−1.5,0.9) | window includes pole; both branches visible | C |
| 04 | √x, [0, 2] | same, (0,10.5), (0,2) | f on [0,10.5] | C |
| 05 | √x, [0, 8] | (0,10.5), (0,8) | f on [0,10.5] | C |
| 06 | √x, [0, 10] | (0,10.5), (0,10) | f on [0,10.5] | C |
| 07 | 1/√(1−x), [−1.5, 0.95] | (−1.6,1.5), (−1.5,0.95) | f drawn for x < 1 (NaN for x ≥ 1 via `safe_eval`) | C |
| 08 | 1/(1+10x²), [−1, 1] | (−1.5,1.5), (−1,1) | f on [−1.5,1.5] | C |
| 09 | ln x, [0.02, 2] | (−0.5,4.1), (0.02,2) | f drawn for x > 0 | C |
| 10 | ln x, [0.02, 4] | (−0.5,4.1), (0.02,4) | same | C |
| 11 | ln(1+x), [−0.98, 1] | (−1.5,1.5), (−0.98,1) | f drawn for x > −1 | C |
| 12 | sin x, [−3π, 3π] | auto span = window (−3π,3π) | f on same interval | C |
| 13 | cos x, [−3π, 3π] | auto span (−3π,3π) | same | C |
| 14 | tan x, [−1.45, 1.45] | (−π,π), (−1.45,1.45), poles ±π/2 | nodes between poles (1.45 < π/2), f on [−π,π] broken at poles (visible gaps) | C |
| 15 | eˣ, [−2, 3] | auto (−2,3) | same interval | C |
| 16 | e⁻ˣcos x, [−2, 4] | auto (−2,4); title "cos(x)*exp(-x)" | same | C |
| 17 | cosh x, [−4, 4] | auto (−4,4) | same | C |
| 18 | arctan x, [−2.2, 2.2] | auto (−2.2,2.2) | same | C |
| 19 | arcsin x, [−1, 1] | (−1.5,1.5), (−1,1) | window [−1.5,1.5], f on [−1,1] | C |
| 20 | J₀, [−10.2, 10.2] | auto (−10.2,10.2) | same | C |
| 21 | J₁, [−10.2, 10.2] | auto | same | C |
| 22 | e^{−x²/2}/√(2π), [−3, 3] | auto; title "normal_pdf(x)" | same | C |
| 23 | ½(1+erf(x/√2)), [−3, 3] | auto; title "normal_cdf(x)" | same | C |
| 24 | Γ, [0.05, 2] | (−0.2,5.2), (0.05,2) | f on [−0.2,5.2]; no spurious connector across the pole at 0 (frame 5 viewed full-size) | C |
| 25 | Γ, [0.05, 4] | (−0.2,5.2), (0.05,4) | same | C |
| 26 | Γ, [0.5, 5] | (−0.2,5.2), (0.5,5) | same | C |
| 27 | Y₀, [0.5, 20] | (0,22), (0.5,20) | f on [0,22] | C |
| 28 | Y₀, [0.5, 10] | (0,22), (0.5,10) | same | C |
| 29 | Y₀, [0.5, 4] | (0,22), (0.5,4) | same | C |

Per-case behaviour paragraphs:

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| B12 | Case 12: with 2, 3, 4 nodes every node is a multiple of π, so every divided difference is zero and degrees 1, 2, 3 show y = 0 | Nodes/π = [−3,3], [−3,0,3], [−3,−1,1,3]. The coefficients in floating point are ≤ 3.7e-16, so mathematically 0. Frames 1–3 show a flat line at 0. | C |
| B13 | Case 13: with 2 and 4 nodes every node is an odd multiple of π, a₀ = −1, the later dd are 0, and degrees 1 and 3 show y = −1 | Coefficients [−1, 0] and [−1, 0, 0, 0] (exactly 0 in floating point). Frames 1 and 3 show y = −1. With 3 nodes (0 included) the line is not flat, which is consistent with the claim. | C |
| B14 | Case 14: tan is odd, the middle node (0,0) lies on the chord, f[x₀,x₁,x₂] = 0, and degrees 1 and 2 show the same line | f[x₀,x₁,x₂] = 0 (computed); frames 1 and 2 show an identical line | C |
| B18 | Case 18 arctan: same claim | f[x₀,x₁,x₂] = 0; frames agree | C |
| B19 | Case 19 arcsin: same claim | f[x₀,x₁,x₂] = 0; frames agree | C |
| B21 | Case 21 J₁: same claim | f[x₀,x₁,x₂] = 0; frames agree | C |
| B23 | Case 23: f − ½ is odd, the middle node is (0, ½), f[x₀,x₁,x₂] = 0 | f[x₀,x₁,x₂] = 0; frames agree | C |

### Divided-differences case (`newtpolyaa`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| N1 | Heading: f = cos x, nodes x_k = k/5 on [0, 1] | `all_xs = [k/5 for k in 0:5]`, `f(x)=cos(x)` | C |
| N2 | "This is Mathews' Example 1" | Legacy `NewtonPolyMod.html` Example 1: cos x, nodes {(k/5, cos(k/5))}, k = 0..5, degrees 1..5 on [x₀, x_n] (formula images 109–111) | C |
| N3 | Each frame adds node x_n = n/5 and one more term a_n∏(x−x_j); earlier coefficients unchanged | Instrumented run: each frame's coefficient vector is the previous one plus one entry | C |
| N4 | a₀..a₅ = 1, −0.0996671, −0.488402, 0.0490076, 0.0381225, −0.00396205 | Script: 1.0, −0.09966711079, −0.48840202099, 0.04900763385, 0.03812245731, −0.00396204671. Mine (mpmath recursive dd, 40 digits): 1.0, −0.0996671, −0.488402, 0.0490076, 0.0381225, −0.00396205 | C |
| N5 | Max error on the shaded [x₀,x_n]: 4.97e-3 (deg 1), 1.16e-4 (deg 2), 1.35e-6 (deg 5) | Script: 4.9709e-3, 1.1647e-4, 1.3500e-6. scipy barycentric on a 400 001-point grid: 4.9709e-3, 1.1647e-4, 6.4249e-5, 4.2306e-6, 1.3500e-6 | C |
| N6 | "so there the curves coincide in the frames" | The largest gap, 5e-3, is about 1 px on a 1.7-unit, ~400 px axis. In frames 1–5 the curves overlap inside the shading. | C |
| N7 | Drawn on [−0.5, 2.1], "as in Mathews' graphs" | Script `xlims=(-0.5,2.1)`. Mathews' Solution 1(e) code (gr_206) has `PlotRange → {{-0.5, 2.1}, {-0.5, 1.05}}`. The script's y-limits are (−0.6, 1.1); the page claims only the x-range. | C |
| N8 | Error at x = 2.1 falls 1.30 → 0.65 → 0.32 → 0.067 → 0.015 | Mine: 1.2955, 0.6532, 0.3208, 0.0671, 0.0147. Script P(2.1) values agree with mine to 1e-12. | C |
| N9 | Degree-2 and degree-3 polynomials leave the bottom of the plot near x = 1.81 and 1.95 | Bottom = −0.6. Roots of P_n(x) + 0.6: 1.8079 (n=2) and 1.9488 (n=3). P₁, P₄ and P₅ stay inside (min on window 0.791, −0.438, −0.490; max ≤ 1.050 < 1.1). | C |
| N10 | Alt: one node per frame, degree 1 (2 nodes) to 5 (6 nodes); [x₀,x_n] shaded; dashed polynomial passes through every node | 5 frames. `vspan!` over [x₀,x_n]. Node residual of P_n is 0 (mpmath). The dashed red line hits every black node in the frames. | C |
| N11 | Alt: max error on the shaded interval "falls from 4.97e-3 to 1.35e-6" | Monotone sequence 4.97e-3, 1.16e-4, 6.42e-5, 4.23e-6, 1.35e-6 | C |
| N12 | Alt: gap at x = 2.1 shrinks from 1.30 to 0.015 | See N8 (monotone) | C |
| N13 | GIF titles: "new coefficient a_n = …; max \|P_n − cos\| on [0, n/5] = …" | Frame titles match N4/N5 values for every frame, including a₃ = 0.0490076 / 6.42e-05 and a₄ = 0.0381225 / 4.23e-06 | C |

---

### 3. Implementation checks

### `lagnewt_animations_all.jl` (shared, Cases 01–29)

**It is the method it claims to be.** It is polynomial interpolation at equally spaced nodes including both endpoints, evaluated in the first barycentric form. The page says plainly that this is not the divided-difference route (A4), and because the interpolant is unique the polynomial drawn is the Newton polynomial. The weights w_j = 1/∏_{k≠j}(x_j−x_k) are correct. `barycentric_eval` returns y_j exactly within 1e-12 of a node, so the interpolant reproduces its data.

**The numbers are right.** I instrumented a copy (`review/lag_instr.jl`) to dump, for every case and node count, the resolved span, whether nodes were trimmed, the y-limits, and the interpolant at every 37th of the 1000 plot points (28 points per frame, 290 frames). Then I evaluated, independently, the Newton divided-difference form in mpmath at 50 digits, with nodes built from the page headings' intervals and windows (`review/indep_cases.py`). Max |script − mine| / max(1, |mine|) per case:

| Case | diff | Case | diff | Case | diff |
|---|---|---|---|---|---|
| 01 | 1.0e-12 | 11 | 7.0e-12 | 21 | 2.3e-14 |
| 02 | 1.1e-12 | 12 | 1.5e-14 | 22 | 8.0e-15 |
| 03 | 1.1e-13 | 13 | 2.6e-14 | 23 | 1.6e-14 |
| 04 | 6.1e-11 | 14 | 1.9e-13 | 24 | 3.7e-13 |
| 05 | 4.5e-11 | 15 | 4.4e-14 | 25 | 3.6e-13 |
| 06 | 1.1e-12 | 16 | 1.9e-14 | 26 | 1.4e-11 |
| 07 | 5.0e-13 | 17 | 2.3e-15 | 27 | 7.1e-14 |
| 08 | 7.4e-14 | 18 | 2.5e-14 | 28 | 1.7e-10 |
| 09 | 1.2e-12 | 19 | 9.5e-13 | 29 | 5.4e-9 |
| 10 | 1.5e-13 | 20 | 2.5e-14 | | |

The largest values come from far extrapolation, where |P| is huge (Case 29 evaluates up to x = 22 from nodes on [0.5, 4]). Those values are clamped off-screen in any case. No node was ever trimmed (`trimmed false` in every row).

**Reference values.** The reference curve f is the library function: `SpecialFunctions` besselj/bessely/gamma/erf and Base sin/cos/tan/log/sqrt/exp. Node values match mpmath to the diffs above. Singularities are NaN-masked (`safe_eval`), and for Cases 01–03 and 14 a NaN is inserted at each listed pole. For Γ (24–26) the pole at 0 is not listed, but frame 5 of Case 24 at full size shows no connector across it.

**The picture shows what was computed.** I viewed the contact sheets of all 29 GIFs, plus full-size frames for Case 24 (frame 5) and Case 28 (frame 7). In each, the red nodes lie on f, the blue interpolant passes through every node, and the title's function and degree match the script and the page. The y-limits come from f, robustly trimmed and widened to include every node of every frame. All nodes are visible in every frame I viewed. The clamping of the interpolant to the window edges and the Case 28 sweep are discussed above; neither misleads.

**Drift.** Byte-identical to the Lagrange page's copy.

### `newtpolyaa.jl` (Mathews' Example 1)

**It is the method it claims to be.** It builds a Newton divided-difference table in place and evaluates P_n by nested (Horner-type) multiplication. The in-place update `d[i] = (d[i]-d[i-1])/(xs[i]-xs[i-j+1])` uses the correct denominator x_i − x_{i−(j−1)} for order j−1, and `coeffs` collects the top of each column.

**The numbers are right.** In the instrumented copy (`review/newtpolyaa_instr.jl`), coefficients, max error and P(2.1) were set beside my independent mpmath computation and a scipy BarycentricInterpolator check:

| n | a_n script | a_n mine | max err script | max err mine (400k grid) | P(2.1) script | P(2.1) mine |
|---|---|---|---|---|---|---|
| 1 | −0.0996671108 | −0.0996671 | 4.97089e-3 | 4.9709e-3 | 0.790699 | 0.7907 |
| 2 | −0.488402021 | −0.488402 | 1.16469e-4 | 1.1647e-4 | −1.158025 | −1.1580 |
| 3 | 0.0490076338 | 0.0490076 | 6.42495e-5 | 6.4249e-5 | −0.825606 | −0.8256 |
| 4 | 0.0381224573 | 0.0381225 | 4.23055e-6 | 4.2306e-6 | −0.437729 | −0.4377 |
| 5 | −0.0039620467 | −0.00396205 | 1.34999e-6 | 1.3500e-6 | −0.490135 | −0.4901 |

P_n reproduces every node exactly (residual 0 in mpmath).

**Reference values.** cos x is exact (Base `cos`).

**The picture shows what was computed.** I viewed all 5 frames on the contact sheet and frame 2 at full size. The shading spans [0, n/5]. The red dashed P_n passes through the black nodes. Degrees 2 and 3 leave the bottom near x = 1.81 and 1.95, and degrees 4 and 5 stay inside. The two-line title reports a_n and the max error with the correct index and interval.

### Fidelity summary

Example 1 matches Mathews (function, nodes, degrees 1–5, x-window). The functions and windows of Cases 01–29 match the legacy animation index in all 29 rows. Node intervals match wherever the archive states one: 04–06, 08–11 and 24–29 in the index; 01 in the surviving animation; 07 = static Example 6 [−1.5, 0.95]; 14 = static Example 11 [−1.45, 1.45]. For the other cases the archive does not determine the node interval (see "Could not determine").

