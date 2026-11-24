# Lagrange Polynomial Interpolation and Approximation — animation review (round 9)

Page: `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Implementation, Minor. Γ's pole at x = 0 is not listed for Cases 24–26; f breaks there only because a grid point lands exactly on 0.0

- **Location:** `lagnewt_animations_all.jl` lines 17 and 59–61. The field comment reads `poles::Vector{Float64}  # poles of f inside the window (empty if none)`. The case rows are `with_span("24", "gamma(x)", …, (-0.2, 5.2), (0.05, 2.0))` and the same for 25 and 26, none with `poles=`.
- **What is there now:** Each of these windows, [−0.2, 5.2], contains the pole of Γ at x = 0, but `poles` is empty. So the script treats the case as pole-free:
  - It draws f from the clamped values `ytrue_clip` without inserting a NaN at the pole.
  - It takes the y-limits from the whole window rather than from the node interval.
- **What is true:** Γ has a simple pole at x = 0, inside every one of these windows. The page sentence "f is broken at each of its poles (Cases 01–03, 14 and 24–26)" holds for the committed GIFs only by coincidence: `range(-0.2, 5.2, length=1000)[38] == 0.0` exactly, `gamma(0.0) == Inf`, and `safe_eval` turns that into NaN.
- **Evidence:**
  - `julia -e 'using SpecialFunctions; x=collect(range(-0.2,5.2,length=1000)); println(x[38]); println(gamma(x[38]))'` prints `0.0` and then `Inf`.
  - In the dump, the grid values next to 0 are Γ(−0.0054) = −185.6 and Γ(0.0054) = 184.4, with NaN at x = 0.
  - The frames of lagnewt24/25/26 show f broken at 0, with no connecting segment.
  - With any other grid length or window, the clamped values ylims[1] − yspan and ylims[2] + yspan would be joined by a vertical magenta line at x ≈ 0.
- **Suggested correction:** Add `poles=[0.0]` to rows 24–26. This would also take the y-limits from f on the node interval, as for the other pole cases, so check that the window still looks right. Alternatively, correct the comment so it no longer claims to list every pole in the window.

No other errors or misleading statements were found. Everything checked is listed in the ledger below.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Count: 0 Error, 0 Misleading, 1 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 36.0 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | "builds a unique polynomial of degree at most n through n+1 data points" | Confirmed | Standard result. The interpolant reproduces every node: dynodes ≤ 3e-16, and `barycentric_eval` returns `ys[j]` at nodes. |
| D2 | "The animations evaluate it in the first barycentric form, P_n(x)=ℓ(x)Σ w_i y_i/(x−x_i), ℓ=∏(x−x_j), w_i=1/∏_{j≠i}(x_i−x_j)" | Confirmed | Code lines 112–141 implement exactly this. |
| D3 | "This is the same interpolant" | Confirmed | The script's values agree with an independent 60-digit classical Lagrange evaluation on the same data. The maximum error over all 29 cases × 10 frames, where the exact value is within one y-span of the window, is 3.0e-9 of the y-span; it is ≤ 1e-12 in most frames. |
| D4 | "it stays accurate far outside the nodes" | Confirmed | Same check as D3, including the extrapolated parts of the windows. The first-form result had the wrong sign at only one to three points per frame, in four frames (Cases 01 and 02, degrees 11–15), all next to a true zero crossing, where the error is ~1e-13 of the y-span. |
| D5 | "the second barycentric form … gives values of the wrong sign in Cases 04 and 29" | Confirmed | With `second_form` added to the instrumented copy and compared with exact values (only where \|exact\| > 1e-6), the second form gives wrong signs at 4 and 1 grid points in Case 04 (n = 14, 16) and at 2 and 151 points in Case 29 (n = 14, 16). There are none in any other case. |
| D6 | Lagrange-basis formula for P_n and L_i | Confirmed | Standard; equivalent to D2. |
| D7 | "The 29 animations below follow the legacy Mathews case ordering" | Confirmed | Functions 1–29 match `Lagrange.html` row for row (see the archive montages). |
| D8 | "nodes are equally spaced from a to b, endpoints included" | Confirmed | Every frame: max \|x_k − (a + (b−a)k/(n−1))\| ≤ 2.7e-15, and the trimming fallback in `equal_nodes` never fires. |
| D9 | "Where the plot window is wider than [a, b] (Cases 01–11, 14, 18–20 and 24–29)…" | Confirmed | From the dumped spans and xlims: exactly these cases have span ≠ window. Cases 12, 13, 15–17 and 21–23 have span = window. |
| D10 | "In Case 19, arcsin x is undefined outside [−1, 1], so there only the interpolant is drawn" | Confirmed | `asin` throws → NaN for \|x\| > 1; frames show only the blue curve there. |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Degrees 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 (2, 3, 4, 5, 6, 8, 10, 12, 14, 16 nodes) | Confirmed | `n_nodes_seq` on line 169. Each GIF has 10 frames, and the titles read degree 1…15 in that order (all 29 contact sheets). |
| A2 | "The degree in each title is the number of nodes minus one" | Confirmed | Title uses `n_nodes - 1`. |
| A3 | Even cases (08, 13, 17, 20, 22): the frame titled degree 1 is a horizontal line | Confirmed | `deg.py`: x¹ coefficient is exactly 0 for n = 2 in all five cases. The frames show horizontal lines. No other case has an even f with symmetric nodes. |
| A4 | Even cases: the frame titled degree 15 has degree 14 | Confirmed | `deg.py`: x¹⁵ coefficient is exactly 0 for n = 16 in 08, 13, 17, 20 and 22. The nodes are exactly symmetric in Float64 (deviation 0). |
| A5 | "A curve that goes off-scale leaves the plot window" | Confirmed | `offscale` clamps one y-span beyond the axes, and the frames show curves exiting the window. |
| A6 | "f is broken at each of its poles (Cases 01–03, 14 and 24–26)" | Confirmed as rendered; fragile for 24–26 (see F1) | 01–03 and 14 have explicit NaN pole points. 24–26 break only because a grid point is exactly 0.0. |
| A7 | Mathews' animations survive only for Cases 01 and 04 | Confirmed | Only `Lagrangeaa.gif` and `Lagrangedd.gif` are GIFs. `Lagrangeii.gif` is HTML (`file` output). |
| A8 | Mathews' animations went to degree 25 (Case 01) and degree 20 (Case 04) | Confirmed | Last frames are labelled S₂₅ and S₂₀ (`mathews01/frame_034.png`, `mathews04/frame_029.png`). |
| A9 | Mathews drew a yellow bar labelled "Tolerance ±0.05" over the interval where the interpolant is within 0.05 of f; these frames stop at degree 15 and have no bar | Confirmed | Mathews' frames show the bar and label. The page's frames have no bar and stop at degree 15. |
| A10 | Source link `lagnewt_animations_all.jl` | Confirmed | The file exists and produces all 29 GIFs. |

### Per-case headings, captions and alt text

The common parts of every alt text ("degree rising from 1 to 15") are confirmed by A1. For every case, the frame titles read "Interpolation Case NN: f(x) = <label>" with the correct NN and a label naming the heading's function: `log(x)` for ln x, `cos(x)*exp(-x)`, `normal_pdf(x)`, `normal_cdf(x)`, `besselj(0,x)`, `bessely(0,x)`, `gamma(x)`, and so on. Embeds `lagnewtNN.gif` match headings 01–29 one to one.

| Case | Heading f, nodes | Script row | Other claims | Verdict |
|---|---|---|---|---|
| 01 | 1/(1−x), [−1.5, 0.9] | same; window (−1.6, 1.5); pole 1 | window includes the pole; "beyond the pole f ≤ −2, below the window" (y-axis bottom = −1.646 > −2; f(1.5) = −2) | Confirmed |
| 02 | 1/(1+x), [−0.9, 1.5] | same; window (−1.5, 1.6); pole −1 | same as 01, mirrored; y-axis bottom −1.646 | Confirmed |
| 03 | 1/(1−x)², [−1.5, 0.9] | same; pole 1 | window [−1.6, 1.5] includes the pole | Confirmed |
| 04 | √x, [0, 2] | same; window (0, 10.5) | "f on [0, 10.5]" | Confirmed |
| 05 | √x, [0, 8] | same | as 04 | Confirmed |
| 06 | √x, [0, 10] | same | as 04 | Confirmed |
| 07 | 1/√(1−x), [−1.5, 0.95] | same; window (−1.6, 1.5) | f drawn for x < 1 | Confirmed |
| 08 | 1/(1+10x²), [−1, 1] | same; window (−1.5, 1.5) | f on [−1.5, 1.5] | Confirmed |
| 09 | ln x, [0.02, 2] | same; window (−0.5, 4.1) | f drawn for x > 0 | Confirmed |
| 10 | ln x, [0.02, 4] | same | as 09 | Confirmed |
| 11 | ln(1+x), [−0.98, 1] | same; window (−1.5, 1.5) | f drawn for x > −1 | Confirmed |
| 12 | sin x, [−3π, 3π] | auto span = window = ±9.42478 | 2, 3 and 4 nodes are at multiples of π, so frames titled degrees 1–3 show y = 0 (node values ≤ 3.7e-16; frames show y = 0) | Confirmed |
| 13 | cos x, [−3π, 3π] | auto span = ±3π | 2 and 4 nodes are at odd multiples of π, cos = −1 exactly, so frames titled degrees 1 and 3 show y = −1 | Confirmed |
| 14 | tan x, [−1.45, 1.45] | same; window (−π, π); poles ±π/2 | (0, 0) on the chord, so the degree-1 and degree-2 frames show the same line (x² coefficient exactly 0); broken at poles | Confirmed |
| 15 | eˣ, [−2, 3] | auto span = window | f on the same interval | Confirmed |
| 16 | e⁻ˣ cos x, [−2, 4] | auto span = window | same interval | Confirmed |
| 17 | cosh x, [−4, 4] | auto span = window | same interval | Confirmed |
| 18 | arctan x, [−2, 2] | same; window (−2.2, 2.2) | the degree-1 and degree-2 frames show the same line (x² coefficient 0) | Confirmed |
| 19 | arcsin x, [−1, 1] | same; window (−1.5, 1.5) | same line (x² coefficient 0); f on [−1, 1] | Confirmed |
| 20 | J₀(x), [−10, 10] | same; window (−10.2, 10.2) | f on [−10.2, 10.2] | Confirmed |
| 21 | J₁(x), [−10.2, 10.2] | auto span = window | same line (x² coefficient 0) | Confirmed |
| 22 | e^{−x²/2}/√(2π), [−3, 3] | auto span = window | same interval | Confirmed |
| 23 | ½(1+erf(x/√2)), [−3, 3] | auto span = window | (0, ½) on the chord, so the degree-1 and degree-2 frames show the same line (x² coefficient 3.9e-19 relative, from rounding) | Confirmed |
| 24 | Γ(x), [0.05, 2] | same; window (−0.2, 5.2) | f on [−0.2, 5.2] | Confirmed (see F1 on the pole) |
| 25 | Γ(x), [0.05, 4] | same | same | Confirmed (F1) |
| 26 | Γ(x), [0.5, 5] | same | same | Confirmed (F1) |
| 27 | Y₀(x), [0.5, 20] | same; window (0, 22) | f on [0, 22] | Confirmed |
| 28 | Y₀(x), [0.5, 10] | same | same | Confirmed |
| 29 | Y₀(x), [0.5, 4] | same | same | Confirmed |

### Fidelity to the archive

- **Functions and plot windows:** All 29 match the `Lagrange.html` formula images exactly, for example −1.6 ≤ x ≤ 1.5 for Case 1, −3π ≤ x ≤ 3π for Cases 12–13, 0 ≤ x ≤ 22 for Cases 27–29.
- **Node intervals:**
  - Those printed in `Lagrange.html` (Cases 04–06, 08–11 and 24–29) match.
  - Case 01's nodes match Mathews' surviving animation, [−1.5, 0.9]; Case 04's match [0, 2].
  - Cases 07, 14, 18, 19 and 20 use the intervals of Examples 6, 11, 13, 14 and 15 in `LagrangePolyMod.html`.
  - Cases 12, 13 and 15 use the animation windows rather than the static Examples 9, 10 and 12 (which use [−10, 10], [−10, 10] and [−5, 5]). This is consistent with the animation index, which is the relevant source.
  - Mathews' own node intervals for Cases 02, 03, 12, 13, 15–17 and 21–23 cannot be determined: the animations are lost and the index gives only the plot window. Choosing the window, or 02 as the mirror of 01, is a reasonable reading and is not flagged.
- **Degree range:** The page stops at degree 15 where Mathews went to 20 or 25, and drops the tolerance bar. It says so explicitly, so this is not a finding.

---

### 3. Implementation checks (`lagnewt_animations_all.jl`)

**It is the method it claims to be.**
- The script runs polynomial interpolation through equally spaced nodes, evaluated by the first (modified) barycentric formula with weights w_j = 1/∏(x_j − x_k).
- A node hit within 1e-12 returns the data value.
- This is the Lagrange interpolant, and the variant (first form) is the one the Description names.

**The numbers are right.**
- *Nodes:* for all 290 frames, the max deviation from a + (b−a)k/(n−1) is ≤ 2.7e-15, and the trim fallback never fires.
- *Node values* agree with mpmath f to ≤ 3e-16 relative. This includes SpecialFunctions' `gamma`, `besselj`, `bessely` and `erf` against mpmath.
- *f on the plot grid:* max relative difference ≤ 4.1e-16. There are no grid points where the script returns NaN but f is finite and moderate.
- *Interpolant:* compared with a 60-digit classical Lagrange evaluation of the same data, the max error is 3.0e-9 × y-span over all frames. Typical values are 1e-16 to 1e-12; the largest is Case 29, n = 16, far outside the nodes.
- *Reproduction at nodes:* holds by construction and is visible in every frame.
- *Parity and degree properties:* hold exactly (A3, A4, odd-case x² coefficients).

**Its reference values are right.** The "true" curve is f itself, from Base and SpecialFunctions. It was checked against mpmath as above.

**The picture shows what was computed.**
- *Frames inspected:* all 29 contact sheets (10 of 10 frames each), titles read in the sheets.
- *Elements:* magenta f, blue interpolant and red nodes match the legend. The nodes lie on f, and the interpolant passes through them.
- *Display devices:*
  - Clamping to one y-span outside the axes only makes curves leave the window.
  - Pole breaks are correct for 01–03 and 14, and for 24–26 by grid coincidence (F1).
  - The y-limits include every node of every frame.
- *Case 28, degree-9 frame:* an isolated near-vertical blue line appears at x ≈ 18.18. I checked that it is genuine. The exact degree-9 interpolant falls to −51.6 at x ≈ 16.98, then rises through zero at x = 18.1765 with slope ≈ 110, so it crosses the 1.34-unit-high window in about 0.012 in x. The script's values there match the exact ones (e.g. −0.904759 at 18.1682 and 1.52232 at 18.1902). This is not a finding.
- *Unused code:* `y_lo`, `y_hi`, `w_lo` and `w_hi` (lines 173–179) are computed but never used. This is a style matter, not a finding.

