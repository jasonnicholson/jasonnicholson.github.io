# Newton Interpolation Polynomial — animation review (round 4)

Page: `pages/numerical-methods/newton-interpolation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1 — Page match, Minor: Cases 01–29 on this page do not say which function or interval they show

- **Location:** `index.qmd`, headings `### Case 01` … `### Case 29` and every alt text `"Newton interpolation animation for case NN from the legacy function-and-interval list."`
- **What is there now:** a bare case number and an alt text that names no function, interval or degree range. The intro sends the reader to the Lagrange page for the function and node interval.
- **What is true:** each case has a definite function, window and node interval (verified below; they match the Lagrange page headings row for row). Nothing on the page is false. But a reader of this page, or a screen-reader user, cannot tell what Case 14 is without opening another page, and the alt text tells them nothing. The only on-page identification is the title burned into the GIF (`Interpolation Case NN: f(x) = …`).
- **How I know:** read `index.qmd`. Compared it with the case table, lines 32–62 of `lagnewt_animations_all.jl`, and with the Lagrange page headings.
- **Suggested correction:** give each heading the same function and node interval that the Lagrange page uses (for example `### Case 14: $f(x)=\tan x$, nodes on $[-3, 3]$`) and write alt text that names the function, node interval and degree range (1 to 15). Alternatively, reuse the Lagrange page's alt text with "Lagrange" changed to "Newton (same polynomial)".

- **Independent check:** not run (Minor finding, unverified)

### F2 — Fidelity, Minor: the divided-differences case uses a different interval and nodes from Mathews' Newton example, and the page gives no reason

- **Location:** `index.qmd`, heading `### Divided differences: $f(x)=\cos x$, nodes $x_k = k\pi/3$ on $[0, 2\pi]$`; `newtpolyaa.jl` lines 33–36.
- **What is there now:** $\cos x$ on $[0,2\pi]$, nodes $k\pi/3$ for $k=0,\dots,6$, degrees 0 to 6.
- **Legacy:** Mathews' Newton module, Example 1 (`NewtonPolyMod.html`, images `NewtonPolyMod_gr_109/110/111.gif`), forms the Newton polynomials of degree 1 to 5 for $f(x)=\cos x$ on $[x_0,x_5]=[0,1]$ with nodes $\{(k/5,\cos(k/5))\}_{k=0}^{5}$. The archive has no separate Newton animation. The module's "Animations" link goes to the shared Lagrange/Newton animation index, which Cases 01–29 reproduce.
- **Assessment:** the function is the same, but the interval, node set and degree range differ, and the page does not say so. The change is defensible: on $[0,1]$, every interpolant of degree 2 or higher would be visually indistinguishable from $\cos x$. Recorded only so that the owner knows about the departure.
- **Suggested correction:** optionally, add one clause such as "Mathews' Example 1 uses $\cos x$ on $[0,1]$ with nodes $k/5$; the wider interval here makes each added term visible."

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 34.0 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtpolyaa.jl` | 0 | 5.5 | newtpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| `newtpolyaa.gif` | 7 | byte-identical | newtpolyaa |

### Page references

- Scripts linked: `lagnewt_animations_all.jl`, `newtpolyaa.jl`
- GIFs embedded: 30
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | $P_n(x)=a_0+a_1(x-x_0)+\dots+a_n\prod_{j=0}^{n-1}(x-x_j)$, with $a_k=f[x_0,\ldots,x_k]$ | This is the standard Newton form. `newtpolyaa.jl` `divided_diff` returns the top diagonal $f[x_0..x_k]$ (its recursion `d[i]=(d[i]-d[i-1])/(xs[i]-xs[i-j+1])` is the standard in-place table). `newton_eval` is the nested form of the same expression. Its coefficients match the exact sympy divided differences (see I2). | confirmed |
| D2 | "Newton and Lagrange forms produce the same polynomial" | Mathematical fact (uniqueness). Also numerically: the shared script's barycentric values match a high-precision Newton divided-difference evaluation to a relative error of ≤ 4.9e-9 in every case and frame (I1) | confirmed |
| D3 | "Cases 01–29 … reuse the same interpolation cases as the Lagrange page" | Script byte-identical on both pages, and all 29 GIFs byte-identical | confirmed |
| D4 | "… matching the legacy Mathews case ordering" | Legacy `Lagrange.html` formula images 1–58: every case's function and window matches table rows 01–29 in order. Where the legacy page states node intervals (Cases 4, 5, 6, 8, 9, 10, 11, 24–29), they match the script's spans exactly | confirmed |
| D5 | "the Lagrange page gives each case's function and node interval" | Lagrange page headings checked against the table, all 29 rows: functions and node intervals agree (e.g. 14: tan, [-3,3]; 24: Γ, [0.05,2]; 27: Y₀, [0.5,20]) | confirmed |
| A1 | Each case shows "2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 equally spaced nodes (degree 1 to 5, then 7, 9, 11, 13 and 15)" | `n_nodes_seq` line 167. All 29 GIFs have 10 frames (manifest). Contact sheets: titles read degree 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 | confirmed |
| A2 | "for a fixed function and node interval" | `resolved_span` is fixed for each case. Spans printed by the instrumented copy | confirmed |
| A3 | "with nodes at both ends of the interval" | Instrumented `equal_nodes` for all 29 cases × 10 node counts: in no instance were the nodes trimmed inward (`xs[1]==a && xs[end]==b` every time). The auto-span cases (12, 13, 15–18, 20–23) resolve to exactly the window endpoints. Nodes differ from exact $a+k(b-a)/(n-1)$ by ≤ 1.4e-15 | confirmed |
| A4 | "The shared script draws this same polynomial but evaluates it in the first barycentric (Lagrange) form, not by divided differences" | Lines 122–139: $P=\ell(x)\sum w_j y_j/(x-x_j)$ with $w_j=1/\prod_{k\ne j}(x_j-x_k)$ (lines 110–120). No divided differences in the script | confirmed |
| A5 | "The last case on this page has its own script, which builds the Newton form from divided differences" | `newtpolyaa.jl` lines 9–31, 44–45 | confirmed |
| W1 | `[Julia source for Cases 01–29](lagnewt_animations_all.jl)` | The file exists beside the page and produces lagnewt01–29 (byte-identical regeneration, per the manifest) | confirmed |
| W2 | Case NN embeds `lagnewtNN.gif`, NN = 01…29 | Read in `index.qmd`: sequential and correct. Each GIF's title shows the matching case number | confirmed |
| W3 | Alt texts 01–29 "Newton interpolation animation for case NN from the legacy function-and-interval list" | Correct case number. Gives no content (F1) | confirmed (uninformative, see F1) |
| C12 | "With 2, 3 and 4 nodes every node is a multiple of π, where sin x = 0, so every divided difference is zero and the frames titled degree 1, 2 and 3 all show the line y = 0" | Nodes/π = [-3,3], [-3,0,3], [-3,-1,1,3]. Script max\|P\| over the window = 3.7e-16 for each. Frames 1–3 of `lagnewt12` show y=0. With 5 nodes (±1.5π) this is no longer the case | confirmed |
| C13 | "With 2 and 4 nodes every node is an odd multiple of π, where cos x = −1, so a₀ = −1, every later divided difference is zero, and the frames titled degree 1 and 3 show the line y = −1" | Nodes/π = [-3,3] and [-3,-1,1,3]. max\|P+1\| = 2.2e-16 and 3.3e-16. Frames 1 and 3 of `lagnewt13` show y = −1. a₀ = f(x₀) = cos(−3π) = −1 | confirmed |
| N1 | Heading: f(x)=cos x, nodes x_k = kπ/3 on [0, 2π] | `newtpolyaa.jl` lines 33–36: `range(0, 2π, length=7)` | confirmed |
| N2 | "Each frame adds the next node and one more Newton term a_n∏_{j<n}(x−x_j)" | Frame n uses `all_xs[1:n+1]`. 7 frames, degree 0…6 | confirmed |
| N3 | "the coefficients already found do not change" | The script recomputes the table each frame. The printed coefficient vectors for n=0…6 are prefix-identical (I2). Also a property of the Newton form | confirmed |
| N4 | a₀…a₆ = 1, −3/(2π), −9/(4π²), 9/(2π³), −27/(16π⁴), −81/(80π⁵), 81/(80π⁶) | Exact sympy divided differences equal these. The differences simplify to 0 for all seven | confirmed |
| N5 | "For degrees 1 to 4 the polynomial leaves the plot to the right of the newest node" | Plot y-limits ±1.6. First x with \|P\|>1.6: deg 1: 5.446 (newest node 1.047); deg 2: 2.894 (2.094); deg 3: 4.779 (3.142); deg 4: 5.559 (4.189); deg 5: never (max\|P₅\| = 1.0039); deg 0: never. The script's grid gives the same values (5.455, 2.895, 4.783, 5.559) | confirmed |
| N6 | "with all seven nodes (degree 6) the largest error on [0, 2π] is 0.0071" | Independent exact P₆, 20001-point scan in mpmath: max\|P₆−cos\| = 0.0071163 at x ≈ 0.3129 (and its mirror point). Script grid: 0.0071162 | confirmed |
| N7 | `[Julia source](newtpolyaa.jl)` and embed `newtpolyaa.gif` | The file exists and regenerates byte-identically (manifest) | confirmed |
| N8 | Alt: "adding one node x_k = kπ/3 per frame from degree 0 (1 node) to degree 6 (7 nodes); the dashed polynomial passes through every node and matches cos x within 0.0071 at degree 6" | 7 frames, titles "degree 0 (1 node)" … "degree 6 (7 nodes)". Dashed red P_n through black nodes in every frame. Error as in N6 | confirmed |

---

### 3. Implementation checks

### I1. `lagnewt_animations_all.jl` (shared, Cases 01–29)

*Method.* It evaluates the unique interpolating polynomial through equally spaced nodes in the first barycentric form. The page says exactly this (A4). The weights are $w_j=1/\prod_{k\ne j}(x_j-x_k)$ (lines 110–120), and the evaluation returns $\ell(x)\sum_j w_j y_j/(x-x_j)$, with an exact node hit returning $y_j$ (lines 122–139). This is a legitimate representation of the Lagrange/Newton interpolant. It is not divided differences, and the page discloses that.

*Numbers.* I instrumented a scratch copy (`review/inst_lagnewt.jl`, including the script without its render loop) to dump, for every case and every node count, the nodes, the node values and the interpolant at 41 points across the full plot window (`review/lagnewt_dump.txt`). Independent check: `review/indep_lagnewt.py` (mpmath, 60 digits) builds the nodes from the Lagrange page's stated intervals, evaluates f exactly, forms Newton divided differences and evaluates by nested multiplication. Results (worst over the 10 frames of each case):

| Case | max\|node − exact\| | max rel err f(node) | max rel err P vs HP Newton (same data) | max rel err P vs HP Newton (exact data) |
|---|---|---|---|---|
| 01 | 1.1e-16 | 1.1e-16 | 1.1e-12 | 1.0e-12 |
| 02 | 1.1e-16 | 1.1e-16 | 1.1e-12 | 1.1e-12 |
| 03 | 1.1e-16 | 2.7e-16 | 8.9e-14 | 1.1e-13 |
| 04 | 1.0e-16 | 1.0e-16 | 6.0e-11 | 6.6e-11 |
| 05 | 4.1e-16 | 1.0e-16 | 3.7e-11 | 4.5e-11 |
| 06 | 8.2e-16 | 8.9e-17 | 1.1e-12 | 1.1e-12 |
| 07 | 9.3e-17 | 1.4e-16 | 6.1e-13 | 4.0e-13 |
| 08 | 5.2e-17 | 9.9e-17 | 7.5e-14 | 7.4e-14 |
| 09 | 1.1e-16 | 7.6e-17 | 1.8e-12 | 1.4e-12 |
| 10 | 2.1e-16 | 8.9e-17 | 2.1e-13 | 1.7e-13 |
| 11 | 5.3e-17 | 1.5e-16 | 1.9e-12 | 7.0e-12 |
| 12 | 5.8e-16 | 5.2e-17 | 1.3e-14 | 1.2e-14 |
| 13 | 5.8e-16 | 5.2e-17 | 4.5e-14 | 4.5e-14 |
| 14 | 1.8e-16 | 1.1e-16 | 1.8e-15 | 1.5e-14 |
| 15 | 2.0e-16 | 7.2e-17 | 5.0e-14 | 5.3e-14 |
| 16 | 1.8e-16 | 1.3e-16 | 2.6e-14 | 2.2e-14 |
| 17 | 2.1e-16 | 1.3e-16 | 2.9e-15 | 3.3e-15 |
| 18 | 1.8e-16 | 1.1e-16 | 4.6e-14 | 4.4e-14 |
| 19 | 5.2e-17 | 1.2e-16 | 9.6e-13 | 1.2e-12 |
| 20 | 7.1e-16 | 7.5e-17 | 4.0e-14 | 3.8e-14 |
| 21 | 7.1e-16 | 9.5e-17 | 1.3e-14 | 2.4e-14 |
| 22 | 1.8e-16 | 5.6e-17 | 4.4e-15 | 3.9e-15 |
| 23 | 1.8e-16 | 7.9e-17 | 2.4e-14 | 1.7e-14 |
| 24 | 1.1e-16 | 9.6e-17 | 9.2e-13 | 6.5e-13 |
| 25 | 2.2e-16 | 9.0e-17 | 3.3e-12 | 3.3e-12 |
| 26 | 3.8e-16 | 1.0e-16 | 1.0e-11 | 1.4e-11 |
| 27 | 1.4e-15 | 7.7e-17 | 2.6e-13 | 7.1e-14 |
| 28 | 8.3e-16 | 1.3e-16 | 1.5e-10 | 1.9e-10 |
| 29 | 2.1e-16 | 1.6e-16 | 3.5e-9 | 4.9e-9 |

The interpolant the script plots equals the true Newton interpolant to plotting accuracy everywhere in every window, including the far-extrapolation regions (relative error ≤ 5e-9, worst in Case 29, degree 15, extrapolated to x = 22). Nodes are never trimmed (A3). The barycentric routine returns y_j at the nodes, so the interpolant reproduces its data by construction, and the frames show it passing through every red node.

*Reference values.* The function evaluations (`f` in the table: sqrt, log, tan, SpecialFunctions `besselj`, `bessely`, `gamma`, `erf`) agree with mpmath at the nodes to ≤ 2.7e-16 relative. The table functions match the GIF titles, the Lagrange page headings and the legacy formula images row by row.

*Picture.* I viewed the contact sheets of all 29 GIFs (Cases 01, 12, 13, 14 and 29 at full sheet size, the rest in 2×2 montages under `review/mont_*.png`). Titles carry the right case number, function label and degree. Magenta is f, blue the interpolant, red the nodes. Every node is visible. Where the interpolant leaves the window it is clamped onto the frame edge (line 211), which reads as leaving the plot rather than as a false plateau. f is broken at the poles in Cases 01–03 and 14. The Newton page makes no claim about clamping. Case 12 frames 1–3 and Case 13 frames 1 and 3 show the flat lines the page describes.

*Drift.* This copy is byte-identical to the one on the Lagrange page.

### I2. `newtpolyaa.jl` (divided differences, cos x on [0, 2π])

*Method.* This is genuine Newton interpolation: a divided-difference table computed in place (lines 10–21), whose top diagonal gives $a_k=f[x_0..x_k]$, evaluated by nested (Horner-type) multiplication in the Newton basis (lines 24–31). Nodes are taken in increasing order, as in the page's formula.

*Numbers.* Instrumented copy `review/inst_newt.jl` (the script's own functions). Independent: sympy exact divided differences on nodes kπ/3.

| k | script a_k | exact a_k | exact closed form |
|---|---|---|---|
| 0 | 1.0 | 1 | 1 |
| 1 | −0.47746482927568595 | −0.477464829275686 | −3/(2π) |
| 2 | −0.22797266319526005 | −0.22797266319526 | −9/(4π²) |
| 3 | 0.1451319049493977 | 0.1451319049493977 | 9/(2π³) |
| 4 | −0.017323845054779807 | −0.017323845054779817 | −27/(16π⁴) |
| 5 | −0.0033086106885915536 | −0.0033086106885915527 | −81/(80π⁵) |
| 6 | 0.0010531634917120504 | 0.0010531634917120504 | 81/(80π⁶) |

The coefficient vectors for n = 0…6 are prefixes of one another. Max error on [0,2π] (exact P_n, 20001-point mpmath scan, vs the script's 600-point grid): deg 0: 2.0 / 2.0; deg 1: 3.0 / 3.0; deg 2: 10.5 / 10.5; deg 3: 9.5 / 9.5; deg 4: 2.0 / 2.0; deg 5: 1.0 / 1.0; deg 6: 0.0071163 / 0.0071162. P₆(2π) = 1 and P₅(2π) ≈ 0, as expected at a node and off one, respectively.

*Reference values.* The reference curve is Base `cos`. Nothing else is used as a reference.

*Picture.* I read all 7 frames on the contact sheet and frame 4 at full size. Titles read "Newton Polynomial for cos(x) — degree n (n+1 nodes)" for n = 0…6. The blue line is cos x, the red dashed line is P_n, and the black dots are the nodes. The axis is fixed at y ∈ [−1.6, 1.6], x ∈ [0, 2π]. Degrees 1–4 leave the window to the right of the newest node, as stated. The legend writes "P_3(x)" literally rather than as a subscript, and the end nodes at x = 0 and 2π are half-clipped by the axis box. Both are cosmetic and do not mislead.

### Legacy archive notes
- Cases 01–29: function and plot window agree with Mathews' Lagrange & Newton animation index for all 29 rows. The stated node intervals agree for the 13 cases where the index states one. I did not check node intervals for Cases 01–03, 07, 14 and 19 against Mathews' animation frames. Those spans come from the script comments, and they are the Lagrange reviewer's to verify. The legacy GIF for Case 14 (`Lagrange14/Lagrangenn.gif`) is missing from the archive, so I could not check it here.
- Mathews' Newton module Examples 5–17 use some different intervals from the animation index (e.g. sin and cos on [−10,10], tan on [−1.45,1.45], eˣ on [−5,5]). The page follows the animation index, which is the set of animations that Mathews' Newton module links to. Not a finding.

