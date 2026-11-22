# Chebyshev Approximation Polynomial — animation review (round 2)

Page: `pages/numerical-methods/chebyshev-approximation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 3 Minor**.

## Findings

### F1 — Implementation (picture), Minor: the top-left legend hides nodes and the curve peak in cases 13, 16, 27, 28 and 29

- **Location:** `chebyshev_animations_all.jl` line 226, `legend=:topleft`, which applies to every case.
- **What is there now:** the opaque legend box covers data in five cases. Across those cases, 34 node markers sit under it. In the first frame of case 13 (`n = 2 nodes`) and of case 16 (`n = 2 nodes`), only **one** red node is visible, though the title says two. The hidden nodes are cos at (-6.664, 0.928) and cos(x)e^(-x) at (-1.121, 1.333). In cases 27–29 the legend covers the first maximum of Y0 (x ≈ 2.2, y ≈ 0.52), plus one or two nodes on it, in most frames. In case 29 that maximum lies in the middle of the approximation interval [0.5, 6].
- **What is true instead:** every node should be visible, because the page and the titles say the frame shows n nodes.
- **How I know:** `review/nodevis.py` maps every node of every frame (2424 nodes in 299 frames) to pixel coordinates using the detected plot box and the script's own xlims/ylims. It then checks for red marker pixels within ±3 px. The 34 misses are all in cases 13 (n=2,6,10,14,16), 16 (n=2,5,6,8,10,12,14,16), 27 (n=8,12,14,16), 28 (n=2,5,6,8,10,12,14,16) and 29 (n=4,6,8,10,12,14,16), and all of them fall inside the legend box. Visual confirmation is in `review/zoom_legend.png`: crops of `cheby29/frame_010`, `cheby16/frame_001` and `cheby13/frame_001`.
- **Suggested correction:** move the legend out of the data, either with `legend=:outerright` or with `legend=:outerbottom, legend_columns=3`. Alternatively, add a per-case legend position to `ChebyCase`, but note that `:bottomright` would hide the node at (9.42, −1) in case 13, so check each choice. Then re-run `nodevis.py` (or look at the frames) to confirm that no node is hidden.

- **Independent check:** not run (Minor finding, unverified)

### F2 — Fidelity, Minor: node intervals of cases 04 and 29 differ from Mathews' examples, with no reason given

- **Location:** script line 27 `with_span("04", …, (0.0, 4.0))` and line 52 `with_span("29", …, (0.5, 6.0))`. Page lines 40 and 140: "Case 04 caption: f(x)=sqrt(x), interval [0, 4]" and "Case 29 caption: f(x)=bessely(0,x), interval [0.5, 6]".
- **What is there now:** case 04 interpolates √x on [0, 4] and case 29 interpolates Y0 on [0.5, 6]. The page, the script and the GIF titles agree with each other.
- **What the archive has:** `Chebyshev.html` says "ununequally spaced nodes in [0, 2]" for case 4 and "unequally spaced nodes in [0.5, 4]" for case 29. The legacy GIFs agree. `Chebyshev04/Chebyshevdd.gif` has its green interval bounds at x = 0 and x = 2, with nodes up to √2 ≈ 1.41 (`review/legacy/sheet04.png`). `Chebyshev29/Chebyshevccc.gif` has its bounds at x = 0.5 and x = 4 (`review/legacy/sheet29.png`). Mathews' sequences are 04/05/06 = [0,2], [0,8], [0,10] and 27/28/29 = [0.5,20], [0.5,10], [0.5,4]. The page changes the first of one sequence and the last of the other.
- **Impact:** small. Both versions still show the same behaviour: good inside the interval and blow-up outside. But a reader comparing with Mathews will find different examples.
- **Suggested correction:** set case 04 to `(0.0, 2.0)` and case 29 to `(0.5, 4.0)`, regenerate, and update the two captions. If the change was deliberate, add one sentence saying why.

- **Independent check:** not run (Minor finding, unverified)

### F3 — Fidelity, Minor: cases 02 and 03 use wider node intervals than Mathews; the pole-side windows of 01/02/03/07 are cut off

- **Location:** script lines 24–26 and 30. The `xlims` and `span` of cases 01, 02, 03 and 07 are both set to [-1.6, 0.9] or [-0.9, 1.6]. Page captions at lines 28, 32, 36 and 52.
- **What is there now:** case 02 uses [-0.9, 1.6] and case 03 uses [-1.6, 0.9]. In cases 01, 02, 03 and 07 the plot window stops exactly at the node interval.
- **What the archive has:** the windows are −1.6 ≤ x ≤ 1.5 for cases 1, 3 and 7 and −1.5 ≤ x ≤ 1.6 for case 2 (formula images, `review/legacy_formulas.png`). These windows show f on both sides of the pole and the interpolant extrapolating. I measured the node interval from the green bounds in the legacy GIFs. Case 02 is [-0.9, 1.5]: at 202 px per unit, the right bound is at px 619, which is x = 1.50 (`review/legacy/f02_025.png`). Case 03 is [-1.5, 0.8]: the right bound at px 487 is x = 0.81 (`review/legacy/f03_025.png`). The legacy GIFs for cases 01 and 07 are missing, so I could not determine their node intervals.
- **Impact:** for case 03, moving the right end from 0.8 to 0.9 raises f(b) from 25 to 100. The y-axis then runs to 105, which flattens the curve over most of the interval. The n = 16 error rises from 0.0251 to 1.43 (`review/runge.py`). The case-02 shift (1.5 → 1.6) is immaterial.
- **Suggested correction:** use Mathews' node intervals, [-0.9, 1.5] for 02 and [-1.5, 0.8] for 03. If the extrapolation region is wanted, restore his wider windows. Otherwise, state in a sentence that the window is restricted to the interval.

No Error or Misleading findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `chebyshev_animations_all.jl` | 0 | 30.6 | 29 GIFs (cheby01.gif … cheby29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `cheby01.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby02.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby03.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby04.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby05.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby06.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby07.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby08.gif` | 14 | byte-identical | chebyshev_animations_all |
| `cheby09.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby10.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby11.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby12.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby13.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby14.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby15.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby16.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby17.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby18.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby19.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby20.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby21.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby22.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby23.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby24.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby25.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby26.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby27.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby28.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby29.gif` | 10 | byte-identical | chebyshev_animations_all |

### Page references

- Scripts linked: `chebyshev_animations_all.jl`
- GIFs embedded: 29
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Chebyshev-node interpolation uses clustered nodes near interval endpoints to reduce oscillation compared with equally spaced interpolation at the same degree." | Runge-type f = 1/(1+10x²) on [-1,1] (`runge.py`). Max error with equispaced vs Chebyshev nodes: n=8: 0.135 vs 0.165; n=16: 0.485 vs 0.0138; n=24: 2.46 vs 0.00114; n=32: 14.0 vs 9.47e-5. The node positions cluster as cos((2k−1)π/2n). | Confirmed. Note that at n = 8 the equispaced max error is slightly smaller; the claim is about oscillation and growth, which holds from n = 16 on. |
| D2 | "This is why Chebyshev-based polynomial approximation is a standard remedy for Runge-type endpoint blow-up." | Same numbers: equispaced error grows to 14, Chebyshev error falls to 1e-4. | Confirmed |
| D3 | Node formula x_k = (a+b)/2 + (b−a)/2 cos((2k−1)π/(2n)), k = 1..n, "mapped roots" | Script line 93 implements exactly this. The independent nodes (Mathews' form t_k = cos((2k+1)π/(2N+2)), k = 0..N, mapped) differ from the script's by at most 1.8e-15. cos((2k−1)π/2n) are the roots of T_n. | Confirmed |
| A1 | "Each animation steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes" | `node_count_sequence(15)` = [2,3,4,5,6,8,10,12,14,16] for the 28 non-08 cases (instr.out). GIFs have 10 frames, and the titles read n = 2 … 16. | Confirmed |
| A2 | "(case 08 continues to 20, 24, 28 and 32)" | `node_count_sequence(31)` = [..,16,20,24,28,32]. The GIF has 14 frames and its last title is n = 32. | Confirmed |
| A3 | "for a fixed function and approximation interval" | The trim loop in `chebyshev_nodes` never fired: attempt 0 for all 299 (case, n) pairs. The span is constant within each case. | Confirmed |
| A4 | "With n nodes the interpolant has degree at most n−1" | n interpolation conditions give a unique polynomial of degree ≤ n−1. Independent Chebyshev coefficients c_0..c_{n−1} reproduce the script's curve to 1e-15. | Confirmed |
| A5 | "for an even function on a symmetric interval and even n it is at most n−2" | Even cases 08, 13, 17, 20, 22, all even n: max |c_{n−1}| = 1.95e-14 (case 17, f up to 27). Odd n gives c_{n−1} of order 0.1–10. | Confirmed |
| A6 | Source link "Julia source for all cases" → `chebyshev_animations_all.jl` | The file exists and produces all 29 GIFs, byte-identical to the committed ones (manifest). | Confirmed |
| C01 | Case 01: f(x)=1/(1-x), interval [-1.6, 0.9] | Script line 24. GIF title "f(x) = 1/(1-x) / interval [-1.6, 0.9]". | Confirmed (fidelity note F3: archive window differs; archive node interval not determinable) |
| C02 | Case 02: f(x)=1/(1+x), interval [-0.9, 1.6] | Script line 25; GIF title matches | Confirmed (archive [-0.9, 1.5], F3) |
| C03 | Case 03: f(x)=1/(1-x)^2, interval [-1.6, 0.9] | Script line 26; GIF title matches | Confirmed (archive [-1.5, 0.8], F3) |
| C04 | Case 04: f(x)=sqrt(x), interval [0, 4] | Script line 27; GIF title "[0, 4]" | Confirmed vs script and GIF; departs from archive [0, 2] (F2) |
| C05 | Case 05: sqrt(x), [0, 8] | Script line 28; GIF title matches; archive "[0, 8]" | Confirmed |
| C06 | Case 06: sqrt(x), [0, 10] | Script line 29; GIF title; archive "[0, 10]", and legacy GIF bounds at 0 and 10 | Confirmed |
| C07 | Case 07: 1/sqrt(1-x), [-1.6, 0.9] | Script line 30; GIF title | Confirmed (archive node interval not determinable) |
| C08 | Case 08: 1/(1+10x^2), [-1, 1], up to 32 nodes | Script line 31 (max_order 31 → 32 nodes); GIF title at n = 32; archive "[-1, 1]", window ±1.5 | Confirmed |
| C09 | Case 09: log(x), [0.02, 2] | Script line 32; GIF title; archive "[0.02, 2]" | Confirmed |
| C10 | Case 10: log(x), [0.02, 4] | Script line 33; GIF title; archive and legacy GIF bounds 0.02, 4 | Confirmed |
| C11 | Case 11: log(1+x), [-0.98, 1] | Script line 34; GIF title; archive "[-0.98, 1]" | Confirmed |
| C12 | Case 12: sin(x), [-3pi, 3pi] | Auto span = (−9.42478, 9.42478) = ±3π exactly; the GIF title shows "[-9.425, 9.425]" (same value); legacy GIF bounds ±3π | Confirmed |
| C13 | Case 13: cos(x), [-3pi, 3pi] | As C12 | Confirmed (display: F1) |
| C14 | Case 14: tan(x), approximation interval [-1.45, 1.45] "inside singularities" | Script line 37; GIF title; ±1.45 < π/2 = 1.5708; f finite at all nodes | Confirmed |
| C15 | Case 15: exp(x), [-2, 3] | Auto span = xlims = (−2, 3); GIF title; legacy GIF bounds −2, 3 | Confirmed |
| C16 | Case 16: cos(x)*exp(-x), [-2, 4] | Auto span (−2, 4); GIF title; archive window | Confirmed (display: F1) |
| C17 | Case 17: cosh(x), [-4, 4] | Auto span; GIF title | Confirmed |
| C18 | Case 18: atan(x), [-2.2, 2.2] | Auto span; GIF title | Confirmed |
| C19 | Case 19: asin(x), [-1, 1] | Script line 42; GIF title; f is NaN-masked outside [-1, 1] | Confirmed |
| C20 | Case 20: besselj(0,x), [-10.2, 10.2] | Auto span; GIF title; values match scipy j0 at the nodes | Confirmed |
| C21 | Case 21: besselj(1,x), [-10.2, 10.2] | Same check against scipy j1 | Confirmed |
| C22 | Case 22: normal_pdf(x), [-3, 3] | exp(−x²/2)/√(2π); auto span (−3, 3); matches the archive's 1/√(2π) e^(−x²/2) | Confirmed |
| C23 | Case 23: normal_cdf(x), [-3, 3] | ½ + ½ erf(x/√2) equals the archive formula; agrees with scipy ndtr | Confirmed |
| C24 | Case 24: gamma(x), [0.05, 2] | Script line 47; GIF title; archive "[0.05, 2]"; legacy GIF bounds | Confirmed |
| C25 | Case 25: gamma(x), [0.05, 4] | Script line 48; GIF title; archive "[0.05, 4]" | Confirmed |
| C26 | Case 26: gamma(x), [0.5, 5] | Script line 49; GIF title. The archive index says "[0.5, 5]", but the legacy GIF `Chebyshevzz.gif` places its first node near x ≈ 0.05 (Γ ≈ 18), so the archive contradicts itself. The page follows the index text. | Confirmed (no finding) |
| C27 | Case 27: bessely(0,x), [0.5, 20] | Script line 50; GIF title; archive and legacy GIF bounds 0.5, 20 | Confirmed (display: F1) |
| C28 | Case 28: bessely(0,x), [0.5, 10] | Script line 51; GIF title; archive and legacy GIF bounds 0.5, 10 | Confirmed (display: F1) |
| C29 | Case 29: bessely(0,x), [0.5, 6] | Script line 52; GIF title "[0.5, 6]" | Confirmed vs script and GIF; departs from archive [0.5, 4] (F2); display F1 |
| W1 | Wiring: heading "Case NN" embeds `chebyNN.gif` for NN = 01…29 | index.qmd lines 26–140. The first-frame and last-frame title of every GIF reads "Chebyshev Case NN" with the matching NN (`review/first_a.png`, `first_b.png`, `last_a/b/c.png`). | Confirmed |
| P1 | Picture: legend "f(x)" magenta, "interpolant" blue, "nodes" red | Script lines 229–231 match the legend; the red markers sit at (x_k, f(x_k)), with interpolation residual 0 at every node | Confirmed |
| P2 | Picture: title "n = N nodes, degree ≤ N−1" | Each title matches the n in its frame; degree bound as A4 | Confirmed |

Not in the ledger (excluded by the standard): "Source inspiration: [@mathewsSite]" (attribution).

---

### 3. Implementation checks — `chebyshev_animations_all.jl`

**It is the method it claims to be.** The script interpolates f at the n roots of T_n mapped to [a, b] (Chebyshev points of the first kind). It evaluates the interpolant with the barycentric formula, using weights computed from the product 1/∏(x_j − x_k). This is the Lagrange interpolant at Chebyshev nodes, which is what the page Description calls "Chebyshev-node interpolation". Mathews' "Chebyshev approximation polynomial" (n2003 module) builds the same polynomial in Chebyshev-series form, with discrete coefficients c_j = (2/(N+1)) Σ f(x_k) T_j(t_k). The two forms are the same polynomial: a legitimate variant in a different representation. The Description describes the nodal form that the code runs, so there is no mismatch.

**The numbers are right.** I instrumented a scratch copy (`review/instr.jl`, which is the script minus the render loop plus a dump). It printed, for every case and n, the span, the trim attempt, the node-reproduction residual, the max error on the span, and whether the nodes lie inside the y-window (`review/instr.out`). It also dumped the nodes and the interpolant on a 401-point grid over the span (`review/dump.tsv`). Independently, `review/indep.py` used numpy/scipy (scipy j0/j1/y0/gamma/ndtr) to compute Mathews' series coefficients from his own node formula and to evaluate Σ c_j T_j.

| Check | Script | Independent | Result |
|---|---|---|---|
| Nodes, all 299 (case, n) | `chebyshev_nodes` | Mathews t_k mapped | max |Δx| = 1.8e-15 |
| Interpolant on 401-point grid, all 299 (case, n) | barycentric | Chebyshev series, Mathews coefficients | max relative difference 7.0e-15 (case 25) |
| Interpolant reproduces data at the nodes | `barycentric_eval` at the nodes | — | residual 0.0 for all 299 |
| Even f, even n ⇒ c_{n−1} = 0 | — | coefficient | max 1.95e-14 |
| Convergence sanity, max error at n = 16 | e.g. exp: 7.1e-12, cosh: 8.1e-9, sin on ±3π: 8.1e-4, √x on [0,4]: 0.063 (slow, since √x is not smooth at 0), 1/(1−x)² on [-1.6,0.9]: 1.43 | — | Consistent with the analyticity of each f: fast for entire f, slow near singularities |

The per-case function lambdas agree with the scipy reference implementations at every node; otherwise the interpolants could not agree to 1e-15. The fallback that trims the interval in `chebyshev_nodes` never ran (attempt 0 everywhere), so no title shows an interval different from the one used.

**Its reference values are right.** The "true" curve is f itself, evaluated with Julia Base and SpecialFunctions. normal_pdf and normal_cdf are written out as exp(−x²/2)/√(2π) and ½+½erf(x/√2); both are correct and match scipy. There is no other reference value.

**The picture shows what was computed.**
- I viewed the first frame and the last frame of all 29 GIFs at full title resolution (`review/first_a.png`, `first_b.png`, `last_a.png`, `last_b.png`, `last_c.png`), and the full contact sheets of 01, 08 and 29 for the middle frames. Titles, function labels, intervals, n and degree bounds are correct in every case. The red nodes lie on f, and the blue curve passes through them.
- The y-window is the 3–97% quantile of f on the plotting grid, widened to contain f over the whole node interval. `nodes_in_ylims` is true for all 299 frames, so no node is clipped by the axis.
- Off-window clamping: the interpolant and f are clamped to a band one window-height beyond the axes, so curves leave the frame and do not ride along its edge. Extrapolation blow-up (for example √x beyond 4, Y0 beyond 6) is drawn as running off the frame. It is never labelled with a clamped value. This is acceptable.
- Masking: f outside its domain (log at x ≤ 0, asin at |x| > 1, Y0 at 0) returns NaN and is not drawn. Correct.
- Case 14 (tan): because of the clamping band, the magenta f(x) curve shows a vertical segment at x = ±π/2, the usual asymptote artifact. It lies outside the approximation interval and changes no conclusion. Not a finding.
- The legend occludes data in cases 13, 16, 27, 28 and 29: Finding F1.
- Frame counts are 10 per GIF and 14 for case 08, at 2 fps. Committed GIFs are byte-identical to scratch regenerations (manifest).

**Commands run** (all from the scratch folder):
- `julia instr.jl > instr.out`
- `/usr/bin/python3 indep.py > indep.out`
- `/usr/bin/python3 runge.py`
- `/usr/bin/python3 nodevis.py`
- ImageMagick `convert`/`montage` for the legacy frames and zoom crops.

