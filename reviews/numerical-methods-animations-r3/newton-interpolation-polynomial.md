# Newton Interpolation Polynomial — animation review (round 3)

Page: `pages/numerical-methods/newton-interpolation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: Cases 12 and 13 show constant lines in frames titled degree 1–3, and this page never says so

- **Location:** `index.qmd` line 24 ("Cases 01–29 each show the interpolant on 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 equally spaced nodes (degree 1 to 5, then 7, 9, 11, 13 and 15)…"), and the bare headings `### Case 12` (line 74) and `### Case 13` (line 78). The GIF titles in `lagnewt12.gif` and `lagnewt13.gif` read "degree 1", "degree 2" and "degree 3".
- **What is there now:** The page says each frame shows the interpolant of degree 1, 2, 3, …. Case 12 and Case 13 have no text of their own.
- **What is true:** In Case 12 ($\sin x$, nodes on $[-3\pi,3\pi]$) every node is a multiple of π for 2, 3 and 4 nodes. All node values are 0, so the "degree 1", "degree 2" and "degree 3" frames all show the same line $y=0$. In Case 13 ($\cos x$) the 2- and 4-node sets are odd multiples of π, so the "degree 1" and "degree 3" frames show $y=-1$. A reader who sees three identical flat frames labelled with rising degrees gets no explanation from this page. The Lagrange page, which embeds the byte-identical GIFs, has a sentence under each of these two cases explaining this. The Newton page left it out. In Newton-form terms the cause is that the divided differences $a_1, a_2, a_3$ are all zero. (There is a milder general version of the same thing: for an even $f$ with an even number of symmetric nodes, the interpolant has degree at most $n-2$. So the "degree 1" frames of Cases 08, 13, 17, 20 and 22 are horizontal lines. Read as "degree at most", the titles are conventional and correct.)
- **How I know:** I ran an instrumented copy (`review/lagnewt_instr2.jl`, then a Python reader over `nodes_dump.tsv`):
  - `12 n=2,3,4: node y = [0,0], [0,0,0], [0,0,0,0]; interpolant range on samples ±3.7e-16`
  - `13 n=2: node y [-1,-1], interpolant ≡ -1; n=4: node y [-1,-1,-1,-1], interpolant ≡ -1; n=3: [-1,1,-1], range [-1, 0.997]`

  The frames (`committed/lagnewt12/frame_001–003.png`, `lagnewt13/frame_001,003.png`, seen in `review/sheets_1.png`) show these flat lines.
- **Suggested correction:** Under `### Case 12` add: "With 2, 3 and 4 nodes every node is a multiple of $\pi$, where $\sin x=0$, so the frames titled degree 1, 2 and 3 all show the line $y=0$ (every divided difference after $a_0$ is zero)." Under `### Case 13` add the matching sentence for $y=-1$ at degree 1 and 3. Optionally, change "degree 1 to 5" on line 24 to "degree at most 1 to 5".

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Observations considered and not raised as findings

- **Fidelity, divided-difference example.** Mathews' only worked divided-difference example (NewtonPolyMod Example 1, `NewtonPolyMod_gr_109–111.gif`) is $f(x)=\cos x$ on $[0,1]$ with nodes $x_k=k/5$, degrees 1–5. The page's own example (`newtpolyaa`) uses $\cos x$ on $[0,2\pi]$ with nodes $k\pi/3$, degrees 0–6. The page does not claim this is Mathews' example, and there is no legacy Newton-specific animation, so there is no archive animation it departs from. The heading states the parameters exactly. On $[0,1]$ the degree-1 to degree-5 curves would be visually indistinguishable from cos, so the change is defensible. I do not count it as a finding. The owner may still want to know that it is not Mathews' example.
- **Fidelity, shared cases.** The legacy animation (case 01 GIF, the only one of the 29 available beside 04 and 09) runs to about 34 nodes and draws a yellow ±0.05 "convergence region" band. The new GIFs stop at 16 nodes and have no band. All 29 functions, plot windows and stated node intervals match the legacy list (see the ledger), and no case is dropped. The difference is a display device, so it is not a finding here. It is shared with the Lagrange page, whose reviewer owns it.
- **Clamping.** The interpolant, and $f$ in non-pole cases, is clamped to the y-limits, so off-window portions run along the frame border. On this page that runs to as much as 79% of the samples (Case 29 degree 15, Case 04 degree 15: 782/1000). The clamped segments coincide with the frame line and read as "leaves the window", which is true. The Lagrange page discloses this and this page does not. I judged that it does not change what a viewer concludes. In Case 14, $\tan x$ is drawn as a near-vertical magenta segment at ±π/2 (clamped, connected across the pole). It reads as an asymptote, which is the conventional reading.
- **Alt text for Cases 01–29** is generic ("Newton interpolation animation for case NN from the legacy function-and-interval list") and names no function. It makes no false claim. It is a conventions and teaching issue, not a correctness one.
- **newtpolyaa display:** the nodes at $x=0$ and $x=2\pi$ are half clipped by `xlims=(0, 2π)`. This is cosmetic.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 35.4 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtpolyaa.jl` | 0 | 6.6 | newtpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page text (quoted / located) | Check | Verdict |
|---|---|---|---|
| D1 | L12–16: $P_n(x)=a_0+a_1(x-x_0)+\dots+a_n\prod_{j=0}^{n-1}(x-x_j)$ | Matches `newton_eval` (nested/Horner form of the same expression) in `newtpolyaa.jl` L24–31 | confirmed |
| D2 | L18: "$a_k=f[x_0,\ldots,x_k]$ are divided differences" | `divided_diff` L10–21 produces the top diagonal of the table; equals exact sympy divided differences (see I-2) | confirmed |
| D3 | L18: "For the same nodes and data, Newton and Lagrange forms produce the same polynomial" | Standard uniqueness. Numerically, the barycentric output equals the 60-digit Newton form to ≤3.9e-9 relative across all 290 frames | confirmed |
| D4 | L20: "Cases 01–29 below intentionally reuse the same interpolation cases as the Lagrange page" | Script files identical (`diff` empty); all 29 GIFs md5-identical to the Lagrange page's copies | confirmed |
| D5 | L20: "matching the legacy Mathews case ordering" | Legacy `Lagrange.html` formula images 1–58 (`review/legacy_formulas.png`): functions and windows 01–29 equal script rows 01–29 in order | confirmed |
| D6 | L20: "the Lagrange page gives each case's function and node interval" | Lagrange page headings checked row by row against the script table and the computed first/last nodes: all 29 agree | confirmed |
| A1 | L24: "2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 equally spaced nodes" | `n_nodes_seq` L167; 10 frames per GIF (manifest; frame dirs) | confirmed |
| A2 | L24: "(degree 1 to 5, then 7, 9, 11, 13 and 15)" | Titles (`titles_1_10.png`) say degree 1…15. In Cases 12/13 some frames are constant (see F1) | confirmed as nominal degree; see F1 |
| A3 | L24: "for a fixed function and node interval" | The span is fixed per case (`resolved_span`) | confirmed |
| A4 | L24: "with nodes at both ends of the interval" | Instrumented: `trimmed=false` for all 29 cases × 10 node counts; first/last node equal the span ends | confirmed |
| A5 | L26: "The shared script draws this same polynomial but evaluates it in the first barycentric (Lagrange) form, not by divided differences" | `barycentric_eval` L122–139 computes $\ell(x)\sum w_jy_j/(x-x_j)$ | confirmed |
| A6 | L26: "The last case on this page has its own script, which builds the Newton form from divided differences" | `newtpolyaa.jl` uses `divided_diff` + `newton_eval` | confirmed |
| W1 | L28: link `lagnewt_animations_all.jl` | File exists; it produces all 29 GIFs (byte-identical regen) | confirmed |
| W2 | L30–144: `### Case NN` → `lagnewtNN.gif`, NN = 01…29 | Each GIF title reads "Interpolation Case NN" with the same NN (all 29, `titles_1_10.png`) | confirmed (29/29) |
| W3 | L32–144 alt text "Newton interpolation animation for case NN from the legacy function-and-interval list" | No specific claim; the case number matches | confirmed (generic) |
| N1 | L146 heading: "$f(x)=\cos x$, nodes $x_k=k\pi/3$ on $[0,2\pi]$" | `f(x)=cos(x)`, `range(0, 2π, length=7)` → step π/3 | confirmed |
| N2 | L148: "Each frame adds the next node and one more Newton term" | `xs_n = all_xs[1:n+1]`, n = 0…6; 7 frames | confirmed |
| N3 | L148: "the coefficients already found do not change" | Instrumented coefficient lists are prefixes of each other (I-2) | confirmed |
| N4 | L148: $a_0..a_6 = 1, -3/(2\pi), -9/(4\pi^2), 9/(2\pi^3), -27/(16\pi^4), -81/(80\pi^5), 81/(80\pi^6)$ | Exact sympy divided differences equal all seven (symbolic difference 0) | confirmed (7/7) |
| N5 | L148: "For degrees 1 to 4 the polynomial leaves the plot to the right of the newest node" | Exits of [-1.6,1.6] at x = 5.445, 2.894, 4.779, 5.559; newest nodes 1.047, 2.094, 3.142, 4.189. Degrees 0, 5 and 6 stay inside (deg 5 max 1.004) | confirmed |
| N6 | L148: "with all seven nodes (degree 6) the largest error on $[0,2\pi]$ is 0.0071" | Independent: 0.0071163 at x = 0.3130 and 5.9702; script grid: 0.007116 | confirmed |
| N7 | L150: link `newtpolyaa.jl` | Exists; produces `newtpolyaa.gif` byte-identically | confirmed |
| N8 | L152 alt: "adding one node $x_k = k\pi/3$ per frame from degree 0 (1 node) to degree 6 (7 nodes)" | Frame titles "degree 0 (1 node)" … "degree 6 (7 nodes)"; 7 frames | confirmed |
| N9 | L152 alt: "the dashed polynomial passes through every node" | Node residual ≤ 4.2e-15 (instrumented); dashed red line in frames | confirmed |
| N10 | L152 alt: "matches cos x within 0.0071 at degree 6" | As N6 | confirmed |
| C1 | Counts: 29 shared cases + 1 own case, 30 GIFs | Manifest: 30 GIFs, all embedded | confirmed |

---

### 3. Implementation checks

### `lagnewt_animations_all.jl` (shared with the Lagrange page)

**Drift:** `diff` of this file against `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/lagnewt_animations_all.jl` is empty. The copies have **not drifted**. All 29 `lagnewtNN.gif` on the two pages are md5-identical, and every committed GIF is byte-identical to a fresh scratch regeneration (manifest).

**Method:** This is polynomial interpolation through equally spaced nodes with both endpoints included. The interpolant is evaluated in the first barycentric form, $\ell(x)\sum_j w_jy_j/(x-x_j)$ with $w_j=1/\prod_{k\ne j}(x_j-x_k)$ (L110–139), and the exact-node shortcut returns $y_j$. That is the unique interpolating polynomial, the same one the Newton form gives, and the page says so explicitly (L26).

**Numbers (independent):** `check_interp.py` rebuilt each of the 290 interpolants (29 cases × 10 node counts) in mpmath at 60 digits. It used Newton divided differences on the script's own Float64 nodes and data and evaluated at 28 sampled plot abscissae per frame, including far extrapolation.
- Script vs Newton form, max relative error (relative to max(1,|P|)): worst **3.9e-9** (Case 29, 16 nodes, |P| up to 4.2e13). Next worst: 5.0e-10, 1.3e-10, 5.4e-11 (Case 04, |P| up to 4.9e14). Most are ~1e-15. At plotting resolution these are exact.
- Node data vs an independent mpmath evaluation of each $f$ (including $J_0$, $J_1$, $Y_0$, Γ, erf): max relative error 2.6e-16.
- My Newton construction reproduces the data at the nodes (residual ~1e-55 to 1e-60). That is the interpolation-property check.
- Nodes: no trimming ever happens (`trimmed=false` for all 290). First and last nodes equal the span ends listed in the table.

**Reference values:** $f$ is drawn from the library functions. The node values are verified above. The pole handling for 01–03 (NaN inserted at the pole) works: the frames show a break at x = 1 (x = −1 in Case 02). $f$ is NaN outside its domain for 07, 09–11 and 19.

**Picture:** I read all 29 titles at full size for frames 1 and 10 (`titles_1_10.png`): "Interpolation Case NN: f(x) = <label>, degree d". Each label matches the case's lambda, and the degrees run 1…15. I viewed the contact sheets of all 29 (`committed/lagnewt01/sheet.png`, `lagnewt04/sheet.png`, `review/sheets_0..4.png`) and `lagnewt24/frame_005.png` at full size. In every frame the interpolant passes through the red nodes, and the magenta $f$ and blue interpolant are the right curves. Clamping to the y-limits is discussed under Observations. Per-frame counts of clamped samples are in `review/instr_out.txt`.

**Case table vs legacy (every row):** script `f` / window vs Mathews formula images (`legacy_formulas.png`) / legacy node interval text:

| Case | f | window | node span (script) | Mathews span | match |
|---|---|---|---|---|---|
| 01 | 1/(1−x) | [−1.6,1.5] | [−1.5,0.9] | not stated; legacy GIF shows nodes from −1.5 to 0.9 | yes |
| 02 | 1/(1+x) | [−1.5,1.6] | [−0.9,1.5] | not stated (mirror of 01) | yes, by mirroring |
| 03 | 1/(1−x)² | [−1.6,1.5] | [−1.5,0.9] | not stated | yes, as 01 (no legacy GIF) |
| 04 | √x | [0,10.5] | [0,2] | [0,2] | yes |
| 05 | √x | [0,10.5] | [0,8] | [0,8] | yes |
| 06 | √x | [0,10.5] | [0,10] | [0,10] | yes |
| 07 | 1/√(1−x) | [−1.6,1.5] | [−1.5,0.95] | not stated | could not determine (no legacy GIF; comment cites a static example I did not trace) |
| 08 | 1/(1+10x²) | [−1.5,1.5] | [−1,1] | [−1,1] | yes |
| 09 | ln x | [−0.5,4.1] | [0.02,2] | [0.02,2] | yes |
| 10 | ln x | [−0.5,4.1] | [0.02,4] | [0.02,4] | yes |
| 11 | ln(1+x) | [−1.5,1.5] | [−0.98,1] | [−0.98,1] | yes |
| 12 | sin x | [−3π,3π] | [−3π,3π] | not stated (window) | yes |
| 13 | cos x | [−3π,3π] | [−3π,3π] | not stated | yes |
| 14 | tan x | [−π,π] | [−3,3] | not stated | departure explained in a script comment (5 nodes on [−π,π] hit ±π/2: confirmed) |
| 15 | eˣ | [−2,3] | same | not stated | yes |
| 16 | cos x·e⁻ˣ | [−2,4] | same | not stated | yes |
| 17 | cosh x | [−4,4] | same | not stated | yes |
| 18 | arctan x | [−2.2,2.2] | same | not stated | yes |
| 19 | arcsin x | [−1.5,1.5] | [−1,1] | not stated (domain) | yes |
| 20 | J₀ | [−10.2,10.2] | same | not stated | yes |
| 21 | J₁ | [−10.2,10.2] | same | not stated | yes |
| 22 | e^(−x²/2)/√(2π) | [−3,3] | same | not stated | yes |
| 23 | ½+½erf(x/√2) | [−3,3] | same | not stated | yes |
| 24 | Γ | [−0.2,5.2] | [0.05,2] | [0.05,2] | yes |
| 25 | Γ | [−0.2,5.2] | [0.05,4] | [0.05,4] | yes |
| 26 | Γ | [−0.2,5.2] | [0.5,5] | [0.5,5] | yes |
| 27 | Y₀ | [0,22] | [0.5,20] | [0.5,20] | yes |
| 28 | Y₀ | [0,22] | [0.5,10] | [0.5,10] | yes |
| 29 | Y₀ | [0,22] | [0.5,4] | [0.5,4] | yes |

### `newtpolyaa.jl`

**Method:** This is Newton's divided-difference interpolation. `divided_diff` (L10–21) updates the table column by column in place: `d[i] = (d[i]-d[i-1])/(xs[i]-xs[i-j+1])` for column j. That is the standard recurrence, and the coefficients are the top diagonal. `newton_eval` (L24–31) is nested (Horner) evaluation of the Newton form. This is the method the page names.

**Numbers:** the scratch copy `newtpolyaa_instr.jl` printed the coefficients and errors. Beside them, the exact values from `check_newt.py` (sympy):

| k | script $a_k$ | exact | page |
|---|---|---|---|
| 0 | 1.0 | 1 | 1 |
| 1 | −0.4774648293 | −3/(2π) = −0.477464829276 | −3/(2π) |
| 2 | −0.2279726632 | −9/(4π²) = −0.227972663195 | −9/(4π²) |
| 3 | 0.1451319049 | 9/(2π³) = 0.145131904949 | 9/(2π³) |
| 4 | −0.01732384505 | −27/(16π⁴) = −0.017323845055 | −27/(16π⁴) |
| 5 | −0.003308610689 | −81/(80π⁵) = −0.003308610689 | −81/(80π⁵) |
| 6 | 0.001053163492 | 81/(80π⁶) = 0.001053163492 | 81/(80π⁶) |

The node residual is ≤ 4.2e-15 for every degree. Coefficient lists for successive n are prefixes of one another. The max |P₆ − cos| on [0,2π] is 0.007116 on the script's 600-point grid and 0.0071163 (refined, at x = 0.3130 and 5.9702) independently.

**Reference values:** The reference is `cos` itself. Nothing to verify beyond that.

**Picture:** `committed/newtpolyaa/sheet.png` shows 7 frames, titled "degree n (n+1 nodes)" for n = 0…6. The blue line is cos, the dashed red line is P_n, and the black nodes lie on both curves. For n = 1–4 the dashed curve leaves the window right of the newest node, as computed (N5). The y-limits [−1.6,1.6] are fixed, and lines leaving the window are clipped by GR, not clamped. The endpoint nodes are half clipped by the x-limits (cosmetic).

