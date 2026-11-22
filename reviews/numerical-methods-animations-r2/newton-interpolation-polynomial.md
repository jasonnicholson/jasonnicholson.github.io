# Newton Interpolation Polynomial — animation review (round 2)

Page: `pages/numerical-methods/newton-interpolation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Fidelity, Minor: node interval for Case 01 (and likely 02, 03, 07) differs from Mathews'

- **Location:** `lagnewt_animations_all.jl` lines 23–25 and 29 (shared case table; same file on the Lagrange page), e.g.
  `with_span("01", "1/(1-x)", x -> 1 / (1 - x), (-1.6, 0.9), (-1.6, 0.9))`.
  This page sends readers to the Lagrange page for the intervals, which states "Case 01: $f(x)=1/(1-x)$, nodes on $[-1.6, 0.9]$".
- **Now:** for Case 01 the nodes are equally spaced on [−1.6, 0.9] and the plot window is [−1.6, 0.9].
- **In the archive:** Mathews' Case 01 plots on −1.6 ≤ x ≤ 1.5 (formula image `Lagrange_gr_2.gif`). His animation `Lagrangeaa.gif` has green node-interval markers at x = −1.5 and x = 0.9. Its 4-node frame (frame 6, "S 3") has nodes at −1.5, −0.7, 0.1 and 0.9, which is a spacing of 0.8 = 2.4/3. So his nodes lie on **[−1.5, 0.9]**. His window also runs past the pole to 1.5, so the extrapolation between 0.9 and the pole can be seen. The script's window stops at the last node. For the same function family the static Newton module, Example 6 (`NewtonPolyMod_gr_435/436`), uses 1/√(1−x) on **[−1.5, 0.95]**.
- **How I know:** I extracted the legacy GIF frames with `julia giftools.jl Lagrangeaa.gif review/legacy_aa/frames`. Then I cropped frame 6 (`review/legacy_aa_f6_bottom.png`) and read the node and marker positions from the axis ticks.
- **Could not determine:** the exact legacy node intervals for Cases 02, 03 and 07. Their legacy GIFs are not in the archive, and the index gives only the plot windows: 02 −1.5..1.6, 03 −1.6..1.5, 07 −1.6..1.5. The script uses [−0.9, 1.6], [−1.6, 0.9] and [−1.6, 0.9]. The legacy Case 01 pattern points to [−0.9, 1.5] for 02 and [−1.5, 0.9] for 03. Example 6 points to [−1.5, 0.95] for 07.
- **Consequence:** small. The function, the case order and the qualitative picture are unchanged, and the page and the GIFs agree with each other. The numbers differ from Mathews' with no reason given.
- **Suggested correction:** use node span (−1.5, 0.9) for Cases 01 and 03, and (−0.9, 1.5) for Case 02. For Case 07 decide between (−1.5, 0.9) and Example 6's (−1.5, 0.95). Optionally widen `xlims` so a little extrapolation toward the pole shows, as in the legacy plot. Then update the Lagrange page's headings and captions to match. Or keep the current values and add one sentence giving the reason.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Observations that are not findings (for the owner's information)

- **Legacy degree range and "Convergence Regions" band.** The legacy animations go to higher degree: S2, S3, S5, S6, S8, S10, S13, S16, S19, S22, S25 in Case 01, and up to S19 in Case 04. They also shade a yellow band where |P − f| < 0.05 (titled "Convergence Regions, Tolerance ±0.05"). The new GIFs stop at degree 15 and have no band. The page makes no claim about either, so under the review standard this is a teaching choice and not a finding.
- **`newtpolyaa` is not Mathews' Example 1.** Example 1 interpolates cos x on [0, 1] with nodes k/5, k = 0..5 (`NewtonPolyMod_gr_109–111`). The page's single-script case uses cos x on [0, 2π] with nodes kπ/3. The page does not present it as Mathews' example, and on [0, 1] the error would be too small to see, so I do not count this as a departure that matters.
- **Clamping.** In 04, 09, 24, 28 and 29 more than half of the interpolant's plotted points lie outside the window, and they are clamped to it (instrumented counts below). The clamped stretches lie on the axis frame and read as "the curve leaves the window". Unlike the Lagrange page, this page does not say so, but I judged it not to change what a viewer would conclude.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 29.9 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtpolyaa.jl` | 0 | 6.5 | newtpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page text (quoted or paraphrased closely) | Kind | Evidence | Verdict |
|---|---|---|---|---|
| 1 | "$P_n(x)=a_0 + a_1(x-x_0)+\dots+a_n\prod_{j=0}^{n-1}(x-x_j)$ where $a_k=f[x_0,\ldots,x_k]$" | Method | Standard Newton form. `newtpolyaa.jl` `divided_diff` and `newton_eval` implement exactly this, checked against a sympy exact table (§3B) | confirmed |
| 2 | "For the same nodes and data, Newton and Lagrange forms produce the same polynomial" | Method | Script's barycentric values match mpmath Newton divided differences on all 290 node sets to ≤ 4.4e-9 relative (§3A) | confirmed |
| 3 | "Cases 01–29 below intentionally reuse the same interpolation cases as the Lagrange page" | Wiring | The two `lagnewt_animations_all.jl` copies have the same md5 (5f743370…). All 29 GIFs are byte-identical (`cmp`, 29/29) | confirmed |
| 4 | "matching the legacy Mathews case ordering" | Wiring / fidelity | Function order 01–29 matches the legacy index formula images exactly (`review/legacy_formulas.png`) | confirmed |
| 5 | "the Lagrange page gives each case's function and node interval" | Wiring | The Lagrange page's 29 headings list a function and an interval. Each agrees with the script row's `f` and `node_span` (or with xlims for the auto-span rows, whose resolved span equals xlims; instrumented). Link target `../lagrange-polynomial-interpolation-and-approximation/index.qmd` exists | confirmed (but see F1 on fidelity of 01–03, 07) |
| 6 | "Cases 01–29 each show the interpolant on 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 equally spaced nodes" | Counts / parameters | `n_nodes_seq` in the script. Manifest: every GIF has 10 frames. Contact sheet 01 titles read degree 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 | confirmed |
| 7 | "(degree 1 to 5, then 7, 9, 11, 13 and 15)" | Counts | Same as 6. All 29 final frames are titled "degree 15" (montages `review/last_*.png`) | confirmed |
| 8 | "for a fixed function and node interval" | Parameters | Each case renders from one row. The title function in all 29 GIFs matches the row's `formula_label` and `f` (montages) | confirmed |
| 9 | "with nodes at both ends of the interval" | Parameters | Instrumented `equal_nodes` for all 29 cases × 10 node counts: `trimmed=false` in every one of 290 sets. First and last node equal the span ends (`review/instr.out`) | confirmed |
| 10 | "The shared script draws this same polynomial but evaluates it in the first barycentric (Lagrange) form, not by divided differences" | Method | `barycentric_eval`, lines 113–130: $\ell(x)\sum w_j y_j/(x-x_j)$ with $w_j=1/\prod_{k\ne j}(x_j-x_k)$. No divided differences anywhere in the file | confirmed |
| 11 | "The last case on this page has its own script, which builds the Newton form from divided differences" | Method / wiring | `newtpolyaa.jl` `divided_diff` and Horner-type `newton_eval`. Link `[Julia source](newtpolyaa.jl)` and embed `newtpolyaa.gif` sit under that heading | confirmed |
| 12 | `[Julia source for Cases 01–29](lagnewt_animations_all.jl)` | Wiring | File exists and is the script that produces lagnewt01–29 (regenerated byte-identical per the manifest) | confirmed |
| 13 | Case NN headings and embeds `lagnewtNN.gif`, NN = 01..29 | Wiring | index.qmd lines 30–144: each heading embeds the GIF with the same number, and the GIF title reads "Interpolation Case NN" | confirmed |
| 14 | Alt text ×29: "Newton interpolation animation for case NN from the legacy function-and-interval list." | Wiring | The GIF numbering matches the legacy list order (row 4). The GIF evaluates barycentrically, which the page discloses (row 10) | confirmed |
| 15 | Heading: "$f(x)=\cos x$, nodes $x_k = k\pi/3$ on $[0, 2\pi]$" | Parameters | `all_xs = range(0, 2π, length=7)` gives kπ/3, k = 0..6. f = cos | confirmed |
| 16 | "Each frame adds the next node and one more Newton term $a_n\prod_{j<n}(x-x_j)$" | Behaviour | Frames n = 0..6 use `all_xs[1:n+1]`. The instrumented coefficient list grows by one entry per frame | confirmed |
| 17 | "the coefficients already found do not change" | Behaviour | The instrumented script prints identical prefixes at every n. sympy check: coefficients from the first m nodes equal the first m full coefficients for m = 1..7 | confirmed |
| 18 | "$a_0,\ldots,a_6 = 1, -\tfrac{3}{2\pi}, -\tfrac{9}{4\pi^2}, \tfrac{9}{2\pi^3}, -\tfrac{27}{16\pi^4}, -\tfrac{81}{80\pi^5}, \tfrac{81}{80\pi^6}$" | Numerical | The sympy exact divided-difference table gives exactly these 7 values (all `True`). Floats agree with the script: 1, −0.477464829, −0.227972663, 0.145131905, −0.017323845, −0.003308611, 0.001053163 | confirmed |
| 19 | "For degrees 1 to 4 the polynomial leaves the plot to the right of the newest node" | Behaviour | With ylims ±1.6 on a 200 001-point grid, the first x where \|P\|>1.6 is: deg 1, 5.445 (newest node 1.047); deg 2, 2.894 (2.094); deg 3, 4.779 (3.142); deg 4, 5.559 (4.189). Each exit lasts to 2π. Degrees 0, 5 and 6 never leave. Frames agree | confirmed |
| 20 | "with all seven nodes (degree 6) the largest error on $[0, 2\pi]$ is 0.0071" | Numerical | Refined maximum \|P₆ − cos\| = 0.0071163 at x = 0.3130 (mpmath findroot on the derivative). The script's 600-point grid gives 0.0071162 | confirmed |
| 21 | Alt: "adding one node x_k = kπ/3 per frame from degree 0 (1 node) to degree 6 (7 nodes)" | Counts | The GIF has 7 frames (manifest) titled "degree 0 (1 node)" … "degree 6 (7 nodes)" (contact sheet) | confirmed |
| 22 | Alt: "the dashed polynomial passes through every node" | What the diagram shows | Node residual ≤ 4.2e-15 in every frame. P is drawn red dashed and the nodes as black markers on the curve (frames) | confirmed |
| 23 | Alt: "matches cos x within 0.0071 at degree 6" | Numerical | Same as 20 | confirmed |
| 24 | Script header claims (`newtpolyaa.jl` lines 1–4: "cos(x) on [0, 2π]", "adds one equally-spaced node per frame", "Produces: newtpolyaa.gif") | Parameters | Code matches. Manifest says the regenerated GIF is byte-identical | confirmed |
| 25 | Shared script comment, lines 36–37: "5 equally spaced nodes on [-pi, pi] would land on the poles at +-pi/2" | Parameters | The nodes are −π, −π/2, 0, π/2, π, so exactly the poles. The reason for the [−3, 3] span is valid | confirmed |

The history and attribution sentence ("Source inspiration") and the "Derivation Notes (Planned)" placeholder were excluded, as the brief directs.

---

### 3. Implementation checks

### A. `lagnewt_animations_all.jl` (shared with the Lagrange page)

**Drift between the two copies:** none. Both files have md5 `5f743370d143be8fabc20401ba9a5127` (`diff` is empty), and all 29 GIFs on the two pages are byte-identical (`cmp`, 29/29).

**It is the method it claims to be.** The script runs polynomial interpolation on equally spaced nodes and evaluates it in the first barycentric form: weights $w_j=1/\prod_{k\ne j}(x_j-x_k)$ (lines 101–111), then $P(x)=\ell(x)\sum_j w_jy_j/(x-x_j)$ (lines 113–130), returning the data value when |x − x_j| ≤ 1e-12. This is the unique interpolating polynomial in Lagrange/barycentric form, not Newton divided differences. The page says so explicitly (ledger row 10), so it is not mislabelled.

**The numbers are right.**
- Instrumented copy: `review/lagnewt_instr.jl` (lines 1–151 of the original plus a dump loop). Run with `cd review && julia lagnewt_instr.jl > instr.out`. It wrote each case's nodes, data and unclamped interpolant on the 1000-point plot grid to `review/dump/caseNN.txt`.
- Independent check, `review/indep_check.py` (run with `/usr/bin/python3 -I indep_check.py dump`):
  - It regenerates the nodes as a + (b−a)k/(n−1) and the data with mpmath at 60 digits. Script nodes and data agree with these to ≤ 8.9e-16 in every case.
  - Taking the script's own float nodes and data, it builds the Newton divided-difference table in mpmath and evaluates by nested multiplication at all 1000 plot x.
  - Maximum relative difference |P_script − P_ref| / max(1, |P_ref|) per case:

| Case | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| max rel | 3.7e-14 | 2.9e-14 | 3.7e-14 | 6.2e-11 | 4.2e-11 | 1.1e-12 | 3.7e-14 | 7.5e-14 | 2.0e-12 | 3.9e-13 |

| Case | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
|---|---|---|---|---|---|---|---|---|---|---|
| max rel | 2.8e-12 | 1.8e-14 | 4.4e-14 | 4.7e-14 | 8.4e-14 | 2.9e-14 | 4.1e-15 | 5.4e-14 | 1.3e-12 | 5.2e-14 |

| Case | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 |
|---|---|---|---|---|---|---|---|---|---|
| max rel | 2.9e-14 | 1.5e-14 | 3.9e-14 | 9.6e-13 | 2.7e-12 | 1.4e-11 | 3.2e-13 | 1.9e-10 | 4.4e-9 |

  The largest discrepancy, 4.4e-9 in Case 29, occurs far outside the nodes, where |P| is huge and clamped anyway. It is invisible.
- Interpolation property: node residual is 0.0 in all 290 node sets (instrumented).

**Reference values.** The "true" curve is f evaluated directly. Julia's `besselj`, `bessely`, `gamma`, `erf` and `log` agree with mpmath at the nodes to ≤ 8.9e-16 relative (same script). The auto-span cases (12, 13, 15–18, 20–23) resolve to the full plot window, because f is finite across each window. Every listed span is used as given, and no node set was trimmed.

**The picture shows what was computed.**
- I read the full contact sheet for Case 01 and the last frame of all 29 cases at readable size (`review/last_01.png`, `last_10.png`, `last_19.png`, `last_28.png`). I also read frame 2 of 29, 24 and 09 and frame 4 of 28, 04 and 14 (`review/edge_examples.png`, `edge2.png`).
- Each title shows the correct function label and degree n_nodes − 1. Nodes (red) lie on f (magenta). The interpolant (blue) passes through them. Node spans seen in the frames match the table: 04 to 2, 05 to 8, 06 to 10, 27 to 20, 28 to 10, 29 to 4, 08 and 19 on [−1, 1].
- Display devices:
  - y-limits come from the 3–97% quantiles of f plus every node value, so every node is drawn.
  - The interpolant is clamped to the y-limits. The share of each frame's 1000 plotted interpolant points that are clamped peaks at: 04 78%, 09 53%, 24 60%, 28 54%, 29 80%. For f the clamped count is ≤ 22/1000 per case.
  - Clamped stretches lie on the axis frame. In Case 14, f's clamped pole shows as a vertical line at ±π/2, which is the usual asymptote look.
  - None of this changes what a viewer would conclude.
- Plot windows end at the last node for 01–03 and 07 (see F1).

**Case table vs headings vs GIF titles:** checked all 29 rows. The function labels in the titles match the code `f`. The intervals match the Lagrange page headings that this page points to. The function order matches the legacy order. The one archive discrepancy is F1.

### B. `newtpolyaa.jl`

**It is the method it claims to be.**
- `divided_diff` builds the Newton divided-difference table in place: at stage j, d[i] ← (d[i] − d[i−1])/(x_i − x_{i−j+1}), and the top entry of each column becomes the coefficient.
- `newton_eval` evaluates the Newton form by nested multiplication, val ← val·(x − x_i) + a_i. This is exactly the Description's formula.

**The numbers are right.** The instrumented copy, `review/newtpolyaa_instr.jl` (original lines 1–39 plus print loop, run with `julia newtpolyaa_instr.jl`), prints the coefficients for each n. The independent sympy exact computation is `review/newtpoly_check.py`.

| k | script a_k | exact | exact (float) |
|---|---|---|---|
| 0 | 1.0 | 1 | 1.0 |
| 1 | −0.47746482927568595 | −3/(2π) | −0.477464829275686 |
| 2 | −0.22797266319526005 | −9/(4π²) | −0.22797266319526 |
| 3 | 0.1451319049493977 | 9/(2π³) | 0.1451319049493977 |
| 4 | −0.017323845054779807 | −27/(16π⁴) | −0.017323845054779817 |
| 5 | −0.0033086106885915536 | −81/(80π⁵) | −0.0033086106885915527 |
| 6 | 0.0010531634917120504 | 81/(80π⁶) | 0.0010531634917120504 |

- Interpolation property: node residual ≤ 4.2e-15 in every frame.
- Nesting property: the coefficients for m nodes equal the first m coefficients for all 7 nodes, for every m. Checked exactly in sympy and in the instrumented output.
- Maximum error at degree 6: script grid 0.0071162, refined 0.0071163 at x = 0.3130.

**Reference values.** The true curve is `cos`, evaluated directly. Nothing else serves as a reference.

**The picture shows what was computed.**
- Contact sheet, all 7 frames. Titles read "degree n (n+1 nodes)" for n = 0..6. The black node markers sit on the blue cos x curve, and the red dashed P_n passes through all of them.
- For degrees 1–4 the dashed curve leaves the ±1.6 window to the right of the newest node, at the x values computed above. Degree 5 dips to 0 at 2π, and degree 6 lies on cos x.
- ylims (−1.6, 1.6) are fixed and nothing is clamped, so Plots simply cuts the curve at the window.
- Cosmetic only: with xlims exactly [0, 2π], the end nodes are half-drawn at the frame edge.
- Regenerated output is byte-identical to the committed GIF (manifest).

