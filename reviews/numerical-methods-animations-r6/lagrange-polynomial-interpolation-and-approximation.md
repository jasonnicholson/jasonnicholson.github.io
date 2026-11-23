# Lagrange Polynomial Interpolation and Approximation — animation review (round 6)

Page: `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

I checked every row of the case table, every claim on the page, and the frames of all 29 GIFs (all 10 frames of each, using the contact sheets). Section 2 gives the evidence for each claim and Section 3 gives the implementation checks.

Observations that are not findings. They are recorded so the owner can see that I considered them.

- **Legacy features the page does not have.** Mathews' animations, as seen in `Lagrangeaa.gif` and `Lagrangedd.gif`, are titled "Convergence Regions". They draw a yellow band where |P−f| < 0.05 and go to higher degree: up to 25 nodes in case 1 and 19 nodes in case 4. The page stops at 16 nodes and has no tolerance band. This is content the page lacks rather than an error, so it is not a finding.
- **Even functions.** In Cases 08, 17, 20 and 22, f is even and the nodes are symmetric. As a result, the frame titled "degree 1" shows a horizontal line, and the frame titled "degree 3" shows a polynomial whose true degree is 2. The page explains the analogous degeneracy for odd functions (Cases 14, 18, 19, 21 and 23) and for Cases 12 and 13, but not this one. Nothing false is said, since the Description says "degree at most n", so this is not a finding.
- **The Γ pole at x = 0 (Cases 24–26).** The pole lies inside the window but is not listed in `poles`. The f curve still breaks there, only because the 1000-point grid happens to land on x = 0.0 exactly, where `gamma(0.0) = Inf` is converted to NaN. This works for the committed GIFs. It is fragile, because a different grid length would draw a vertical connector across the pole. Not a finding.
- **Case 28, degree 9.** The near-vertical blue line at x ≈ 18.18 is genuine. It is a real root of the degree-9 interpolant, which mpmath `findroot` places at 18.176461, and P goes from −0.905 at x = 18.168 to +1.522 at x = 18.190. It is not a drawing artifact.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 32.9 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

The independent evidence comes from three scripts. `dump.jl` is an instrumented copy of the script's own functions, and it dumps the nodes, the node values and the unclamped interpolant at all 1000 plot points for every case and degree. `check.py` evaluates the Lagrange basis form in 60-digit mpmath and also rebuilds the nodes from the **page headings**. `second.py` runs a float64 second barycentric form. `lines.py` checks the degenerate frames, and `ftrue.py` compares f with mpmath.

### Description and introduction

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | "builds a unique polynomial of degree at most $n$ through $n+1$ data points" | confirmed | Standard result. The script's interpolant reproduces the node values exactly: `barycentric_eval` returns `ys[j]` at nodes, and the mpmath evaluation agrees there. |
| D2 | "evaluate it in the first barycentric form, $P_n(x)=\ell(x)\sum w_i y_i/(x-x_i)$, $\ell=\prod(x-x_j)$, $w_i=1/\prod_{j\ne i}(x_i-x_j)$" | confirmed | Script lines 110–139 implement exactly this. `w[j] /= (xs[j]-xs[k])` gives $w_j=1/\prod_{k\ne j}(x_j-x_k)$, and lines 132–138 compute `l*s`. |
| D3 | "This is the same interpolant, and it stays accurate far outside the nodes" | confirmed | I compared against the mpmath Lagrange-basis value at every 3rd plot point, for all 10 degrees in all 29 cases. The worst relative error is 4.4e-9 (Case 29, degree 15, x = 6.937, where P = 8763.53). Every other case is ≤ 1.6e-10. |
| D4 | "the second barycentric form … gives values of the wrong sign in Cases 04 and 29" | confirmed | `second.py` uses the same weights in float64 and finds wrong-sign values only in Case 04 (degree 13: 211 plot points; degree 15: 93 points; e.g. x = 8.219, true 9.35e10, second form −8.58e12) and Case 29 (degree 13: 56 points; degree 15: 374 points; e.g. x = 10.989, true 1.64e8, second form −1.44e9). All of these points would appear visibly different after clamping. No other case has any. |
| D5 | Lagrange form $P_n=\sum y_iL_i$, $L_i=\prod_{j\ne i}(x-x_j)/(x_i-x_j)$ | confirmed | `check.py` uses exactly this form as the reference, and it agrees with the script (D3). |
| D6 | "The 29 animations below follow the legacy Mathews case ordering." | confirmed | All 29 rows of `Lagrange.html`, with function and window read from `Lagrange_gr_1…58.gif` (montage `review/legacy_formulas.png`), match the script's functions and windows in the same order. |
| D7 | "Each case heading gives the function and the node interval $[a,b]$; the nodes are equally spaced from $a$ to $b$, endpoints included." | confirmed | Nodes were rebuilt independently from each heading's [a,b] for n = 2…16. The maximum deviation from the script's nodes and node values is ≤ 1.4e-15 in every case. The trimming fallback in `equal_nodes` never fires. |
| D8 | "Where the plot window is wider than $[a,b]$ (Cases 01–11, 14, 19 and 24–29), the interpolant beyond the nodes is extrapolation." | confirmed | Windows and spans from the dump: the window is wider exactly in 01–11, 14, 19 and 24–29, and equals [a,b] in 12, 13, 15–18 and 20–23. |
| D9 | "In Case 19, $\arcsin x$ is undefined outside $[-1,1]$, so there only the interpolant is drawn." | confirmed | `asin` throws outside [−1,1], which gives NaN (`ftrue.py`: 0 NaN mismatches against mpmath). In the frames, the magenta curve is confined to [−1,1]. |
| D10 | "raises the polynomial degree through 1, 2, 3, 4, 5, 7, 9, 11, 13 and 15 (2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 nodes)" | confirmed | `n_nodes_seq = [2,3,4,5,6,8,10,12,14,16]` (line 167). Every GIF has 10 frames (manifest), and the titles read degree 1 … 15 in that order. |
| D11 | "for a fixed function and node interval" | confirmed | `span` is fixed per case (line 166), and the frames show the same endpoint nodes throughout. |
| D12 | "Where a curve leaves the plot window, it is drawn along the window's top or bottom edge, except $f$ in Cases 01–03 and 14, which runs off the window and is broken at each of its poles." | confirmed | The interpolant is always clamped (line 211). f is clamped (line 194) unless `poles` is non-empty, and `poles` is set only for 01, 02, 03 and 14. In those cases f is unclamped with a NaN inserted at each pole (lines 196–201). The frames agree. |
| D13 | "[Julia source for all cases](lagnewt_animations_all.jl)" | confirmed | The file exists, generates all 29 GIFs, and the regenerated GIFs are byte-identical to the committed ones (manifest). |

### Per-case claims

For every case I checked three things. (a) The heading's function and [a,b] equal the script row: confirmed by `check.py`, with node deviation ≤ 1.4e-15. (b) The GIF title shows the same function with case number NN in `lagnewtNN.gif`: confirmed on every contact sheet. (c) The window and other wording in the alt text agree with `xlims`, the ylims from the dump, and the frames. All three are confirmed for every case unless a row says otherwise.

| Case | Heading / alt claims | Verdict | Evidence |
|---|---|---|---|
| 01 | 1/(1−x), nodes [−1.5, 0.9], window [−1.6, 1.5], pole at x = 1, "beyond the pole f ≤ −2, below the window" | confirmed | On (1, 1.5], 1/(1−x) ≤ −2. The y-limits are (−1.646, 11.25), so that branch is below the window. The legacy `Lagrangeaa.gif` also has nodes from −1.5 to 0.9. |
| 02 | 1/(1+x), nodes [−0.9, 1.5], window [−1.5, 1.6], pole at x = −1, f ≤ −2 below the window | confirmed | On [−1.5, −1), f ≤ −2, and the y-limits are (−1.646, 11.25). |
| 03 | 1/(1−x)², nodes [−1.5, 0.9], window [−1.6, 1.5], includes the pole | confirmed | The frames show f broken at x = 1, with its right branch (f ≥ 4) visible. |
| 04 | √x, nodes [0, 2], f on [0, 10.5] | confirmed | Window (0, 10.5). The legacy index says "equally spaced nodes in [0, 2]", and `Lagrangedd.gif` agrees. |
| 05 | √x, nodes [0, 8], f on [0, 10.5] | confirmed | |
| 06 | √x, nodes [0, 10], f on [0, 10.5] | confirmed | |
| 07 | 1/√(1−x), nodes [−1.5, 0.95], window [−1.6, 1.5], f drawn for x < 1 | confirmed | f is NaN for x ≥ 1. The node interval matches legacy Example 6, [−1.5, 0.95]. |
| 08 | 1/(1+10x²), nodes [−1, 1], f on [−1.5, 1.5] | confirmed | Matches the legacy index and Example 7. |
| 09 | ln x, nodes [0.02, 2], window [−0.5, 4.1], f drawn for x > 0 | confirmed | Matches the legacy index. |
| 10 | ln x, nodes [0.02, 4], same window | confirmed | Matches the legacy index. |
| 11 | ln(1+x), nodes [−0.98, 1], window [−1.5, 1.5], f drawn for x > −1 | confirmed | Matches the legacy index. |
| 12 | sin x, nodes [−3π, 3π], "With 2, 3 and 4 nodes every node is a multiple of π … frames titled degree 1, 2 and 3 all show the line y = 0" | confirmed | Nodes/π are [−3, 3], [−3, 0, 3] and [−3, −1, 1, 3]. The maximum of \|P\| in those frames is 3.7e-16. With 5 nodes (nodes/π = −3, −1.5, 0, 1.5, 3) the maximum of \|P\| is 1.03, which is not 0. |
| 13 | cos x, nodes [−3π, 3π], "With 2 and 4 nodes every node is an odd multiple of π … degree 1 and 3 show the line y = −1" | confirmed | The maximum of \|P+1\| is 2.2e-16 (2 nodes) and 5.6e-16 (4 nodes). With 3 nodes it is 2.0, since the middle node 0 is an even multiple of π. |
| 14 | tan x, nodes [−1.45, 1.45] between poles ±π/2, f on [−π, π] broken at poles; middle node (0, 0) on the line through the end nodes, so degrees 1 and 2 are the same line | confirmed | The middle node is exactly (0.0, 0.0). The maximum of \|P₂−P₁\| is 7.1e-15 against a window height of 20.4. 1.45 < π/2 = 1.5708. The node interval matches legacy Example 11. |
| 15 | eˣ, nodes [−2, 3] | confirmed | |
| 16 | e⁻ˣ cos x, nodes [−2, 4] | confirmed | The title reads `cos(x)*exp(-x)`, which is the same function. |
| 17 | cosh x, nodes [−4, 4] | confirmed | |
| 18 | arctan x, nodes [−2.2, 2.2]; degrees 1 and 2 the same line | confirmed | The maximum of \|P₂−P₁\| is 4.4e-16. |
| 19 | arcsin x, nodes [−1, 1], window [−1.5, 1.5], f on [−1, 1]; degrees 1 and 2 the same line | confirmed | The maximum of \|P₂−P₁\| is 8.9e-16. The node interval matches legacy Example 14. |
| 20 | J₀, nodes [−10.2, 10.2] | confirmed | f agrees with mpmath `besselj(0, x)` to 8.9e-16. |
| 21 | J₁, nodes [−10.2, 10.2]; degrees 1 and 2 the same line | confirmed | The maximum of \|P₂−P₁\| is 2.6e-18. |
| 22 | e^(−x²/2)/√(2π), nodes [−3, 3] | confirmed | |
| 23 | ½(1+erf(x/√2)), nodes [−3, 3]; middle node (0, ½) on the line, so degrees 1 and 2 are the same line | confirmed | The middle node is (0.0, 0.5). The maximum of \|P₂−P₁\| is 3.3e-16. |
| 24 | Γ, nodes [0.05, 2], f on [−0.2, 5.2] | confirmed | Matches the legacy index. |
| 25 | Γ, nodes [0.05, 4] | confirmed | Matches the legacy index. |
| 26 | Γ, nodes [0.5, 5] | confirmed | Matches the legacy index. |
| 27 | Y₀, nodes [0.5, 20], f on [0, 22] | confirmed | Y₀(0) = −Inf is drawn as NaN. Matches the legacy index. |
| 28 | Y₀, nodes [0.5, 10] | confirmed | Matches the legacy index. |
| 29 | Y₀, nodes [0.5, 4] | confirmed | Matches the legacy index. |
| W | Wiring: each `### Case NN` embeds `lagnewtNN.gif` | confirmed | The title "Interpolation Case NN: f(x) = …" in every frame of every GIF matches its heading. |

### Could not determine

For Cases 12, 13, 15, 18 and 20, the legacy index does not list a node interval, and the legacy animated GIFs for these cases are not in the archive. The module's static examples use different intervals for these functions:

- sin and cos: [−10, 10]
- eˣ: [−5, 5]
- arctan: [−2, 2]
- J₀: [−10, 10]

The page puts the nodes across the whole animation window instead. Rows 4–6, 8–11 and 24–29 of the index do list a node interval wherever it differs from the window, which suggests the nodes span the window in the unlisted rows. I could not confirm what Mathews' animations actually used.

`a2001/.../Lagrange09/Lagrangeii.gif` is an HTML file rather than a GIF, so it could not be viewed. Case 09's node interval is confirmed from the index text anyway.

### 3. Implementation checks (`lagnewt_animations_all.jl`)

**It is the method it claims to be.** The script builds the Lagrange interpolating polynomial through n equally spaced nodes on [a,b], endpoints included, and evaluates it with the first barycentric form. That is one valid evaluation of the Lagrange interpolant, and the page's Description names it explicitly (D2). There is no neighbouring method and no simplification. The weights are the standard barycentric weights (lines 110–120).

**The numbers are right.**

- *Nodes.* `check.py` rebuilds the nodes from the page heading intervals in mpmath. For every case and n, the maximum of \|x_k − x_k(script)\| and the relative node-value error are ≤ 1.4e-15.
- *Interpolant values.* For each of the 29 cases × 10 degrees × 334 plot points, I compared the script's unclamped `barycentric_eval` output (`review/dump.txt`) with a 60-digit mpmath evaluation of $\sum y_iL_i(x)$. The worst relative error, with the scale floored at 1, is:

  | Case | Worst relative error |
  |---|---|
  | 01 | 1.1e-12 |
  | 04 | 5.9e-11 (\|P\| up to 4.9e14) |
  | 09 | 1.9e-12 (\|P\| up to 8.9e7) |
  | 24 | 8.5e-13 (\|P\| up to 1.3e11) |
  | 28 | 1.6e-10 |
  | 29 | 4.4e-9 (\|P\| up to 4.2e13) |
  | all others | ≤ 1.3e-11 |

  Every one of these is far below one pixel.
- *Interpolation property.* At nodes the routine returns `ys[j]` exactly, and mpmath confirms the node values.

**Its reference values are right.** The "true" curve is f itself. `ftrue.py` compared the script's `safe_eval(f, x)` with mpmath at every 7th plot point in every case, about 143 points each. The worst relative error is 6.7e-14 (Case 03). Every NaN, meaning the parts of the window where f is not drawn, falls exactly where mpmath says f is undefined or infinite: asin outside [−1,1], log for x ≤ 0, √(1−x) for x ≥ 1, and Y₀(0). There are 0 mismatches in all 29 cases.

**The picture shows what was computed.**

I viewed all 10 frames of all 29 GIFs on the contact sheets in `committed/lagnewtNN/sheet.png`.

- **Plotted elements.** Magenta is f, blue is the interpolant and red dots are the nodes. The node count per frame is 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16, matching the title's degree + 1. In every frame the interpolant passes through every node.
- **Titles.** Each title has the right case number, function and degree.
- **y-limits.** They include every node value of every frame by construction (lines 184–193), and no node is clipped in any frame.
- **Clamping.** The interpolant's clamping to the window edge is disclosed in the page text (D12).
- **Pole breaks.** f is broken at the poles in 01–03 and 14. In 24–26 it breaks at Γ's pole because the grid hits x = 0 exactly (see the observations in Section 1).
- **Visible behaviour matches the computed values:**
  - The sign of the extrapolated tails, e.g. Case 04 going up at odd degree and down at degrees 2 and 4, matches the sign of the leading divided difference.
  - In Cases 12 and 13, the degenerate y = 0 and y = −1 frames show at the stated degrees.
  - The coincident degree-1 and degree-2 lines in 14, 18, 19, 21 and 23 are visible.
  - The Case 28 degree-9 crossing is a real root of P.
- **Committed GIFs.** They are byte-identical to the regenerated output, so the frames reflect the current script.

Commands, all run from the review folder with scratch copies:

- `julia dump.jl`, which uses `lib.jl` (the first 231 lines of the script, i.e. without the render loop) to write `dump.txt`.
- `python3 -I check.py dump.txt 3`
- `python3 -I second.py dump.txt`
- `python3 -I lines.py dump.txt`
- `python3 -I c28.py dump.txt`
- `julia ftrue.jl && python3 -I ftrue.py ftrue.txt`
- `montage.py` and `ex.py`, which build montages of the legacy formula images.

