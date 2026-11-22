# Chebyshev Approximation Polynomial — animation review

Page: [`pages/numerical-methods/chebyshev-approximation-polynomial/index.qmd`](../../pages/numerical-methods/chebyshev-approximation-polynomial/index.qmd) · Scripts: `chebyshev_animations_all.jl` · GIFs: 29

**Result:** 3 error, 0 misleading, 3 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — The intro says the degree goes up one step at a time, but it skips degrees

- **Location:** index.qmd:22, "Each animation increases polynomial degree one step at a time for a fixed function and approximation interval."; the cause is `node_count_sequence`, chebyshev_animations_all.jl:158-179.
- **Now:** The page says the degree goes up by one in each frame.
- **True:** The node counts are `[2,3,4,5,6,8,10,12,14,16]`, so the degrees are 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 (10 frames). Case 08 (`max_order=31`) has node counts `[2,…,16,20,24,28,32]`, so its degrees are 1, 2, 3, 4, 5, 7, 9, 11, 13, 15, 19, 23, 27, 31 (14 frames). After degree 5 the step is 2 (and 4 in case 08). Degrees 6, 8, 10, 12, 14 never appear.
- **Evidence:** `julia dump_cases.jl` prints `seq=[2, 3, 4, 5, 6, 8, 10, 12, 14, 16]` for 28 cases and `seq=[2, 3, 4, 5, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32]` for case 08. The committed GIFs have 10 frames each (14 for cheby08), per `committed/*/nframes`. The frame titles read "degree 1, 2, 3, 5, 7, 9, 11, 13, 15" (the cheby12 contact sheet shows 1, 2, 3, 4, 5, 7, 9, 11, 13, 15).
- **Suggested fix:** Replace the sentence with: "Each animation raises the polynomial degree through 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 (case 08 continues to 19, 23, 27, 31) for a fixed function and approximation interval." Alternatively, change `node_count_sequence` to `2:max_order+1` if one step per frame is what was intended.

- **Independent check:** confirmed. Checker: node counts 2,3,4,5,6,8,10,12,14,16 (and 20,24,28,32 in case 08); false for all 29 cases.

### F2 — Error — Page match — Case 19 interpolates on [-0.999, 0.999], not on the [-1.5, 1.5] the alt text states

- **Location:** index.qmd:100, "Case 19 caption: f(x)=asin(x), interval [-1.5, 1.5]."; the cause is `auto_span("19", "asin(x)", x -> asin(x), (-1.5, 1.5))`, chebyshev_animations_all.jl:42, together with `finite_support`/`resolved_span` (lines 64-84).
- **Now:** The alt text gives the interval as [-1.5, 1.5]. That is only the x-range of the plot.
- **True:** `asin` throws for |x|>1. `finite_support` therefore keeps the first and last of 2200 plot-grid points where `asin` is defined, and the Chebyshev nodes are placed on [-0.99931787, 0.99931787]. The GIF's own title says "interval [-0.999, 0.999]". The interval comes from the sampling grid, not from a mathematical choice: asin is finite at ±1, so [-1, 1] is the natural interval.
- **Evidence:** `dump_cases.jl` gives `CASE 19 … span=(-0.9993178717598908, 0.9993178717598908) … title_interval=[-0.999, 0.999]`. The full-size `committed/cheby19/frame_010.png` reads "interval [-0.999, 0.999]". `verify.py` confirms that the case 19 nodes are the first-kind Chebyshev nodes of that span (deviation 1.6e-16 of the width).
- **Suggested fix:** Use `with_span("19", "asin(x)", x -> asin(x), (-1.5, 1.5), (-1.0, 1.0))` and keep the alt text's interval as [-1, 1] (the title will then read [-1, 1]). Alternatively, change the alt text to "interval [-0.999, 0.999]".

- **Independent check:** confirmed. Checker: [-1.5,1.5] is only the plot's x-range; the nodes and every frame title use [-0.999,0.999].

### F3 — Error — Implementation (picture) — The titles run off the right edge, so cases 19 and 20 show the wrong degree and case 21 shows none

- **Location:** chebyshev_animations_all.jl:212-215 (`size=(760, 520)` and the one-line `title=…degree $(n_nodes - 1)`).
- **Now:** The title is wider than the plot. In cheby19, frames 8-10 (degrees 11, 13, 15) read "degree 1". In cheby20, frames 1-7 end at "degree" with no number, and frames 8-10 show only a cut-off "1". In cheby21, no frame shows a degree number. In cheby07, 12, 13, 23, 27, 28 and 29 the last digit of "15" is partly clipped but still legible.
- **True:** Those frames are degree 11, 13 and 15 (19 and 20) and degrees 1 to 15 (21). For cases 19 and 20, a reader sees "degree 1" on the final, nearly exact interpolant.
- **Evidence:** `python3 titles.py last 1 15`, `python3 titles.py last 16 29`, `python3 titles_case.py 19 20 21` and `python3 rightcrops.py` build title strips from the committed frames: `titles_frames_19_20_21.png`, `right_top.png` and `right_bot.png`. I read them, together with the full-size `committed/cheby19/frame_010.png`, which reads "…interval [-0.999, 0.999], degree 1". No title is clipped on the left (`clipcheck.py`: the leftmost dark pixel is at x ≥ 33 in every frame).
- **Suggested fix:** Shorten the title or wrap it onto two lines, for example `title="Case $(case.id): f(x) = $(case.formula_label)\ninterval [...], degree $(n_nodes - 1)"`. Alternatively, set `titlefontsize=11` or widen the figure (`size=(900, 520)`).

- **Independent check:** confirmed with correction. Checker: case 19 frames 8–10 show 'degree 1' (true 11, 13, 15); case 21 shows no degree digit in any frame. Correction: case 20 never shows a wrong degree — none of its frames has a readable degree at all.

### F4 — Minor — Implementation (picture) — For symmetric problems, "degree n−1" in the title overstates the interpolant's real degree

- **Location:** chebyshev_animations_all.jl:215 (`degree $(n_nodes - 1)`).
- **Now:** Every frame is labelled degree n−1. In cases 08, 13, 17, 20 and 22 (even function on a symmetric interval), the first frame says "degree 1" but shows a horizontal line.
- **True:** Interpolation at n nodes gives a polynomial of degree **at most** n−1. If f is even on a symmetric interval, the interpolant is even, so its real degree is n−2 whenever n is even. That covers every frame of cases 08, 13, 17, 20 and 22. If f is odd (or odd plus a constant), the frames labelled degree 2 and 4 are really degree 1 and 3. That covers cases 12, 14, 18, 19, 21 and 23.
- **Evidence:** `python3 actual_degree.py` solves for the Chebyshev coefficients of each interpolant from the script's node values. For case 08 it gives "title 1 → actual 0; title 3 → actual 2; … title 31 → actual 30". The same pattern appears for 13, 17, 20 and 22, and "title 2 → 1; title 4 → 3" for 12, 14, 18, 19, 21 and 23. (Case 15 at degree 15 is reported only because its leading coefficient is about 1e-11; that is a tolerance effect, not a real drop.) In `committed/cheby08/sheet.png`, frame 1 shows a flat line titled "degree 1".
- **Suggested fix:** Label the frames "n = $(n_nodes) nodes (degree ≤ $(n_nodes-1))". Alternatively, add one sentence to the page saying that symmetric functions lose the top odd or even term.

- **Independent check:** not run (minor finding, unverified).

### F5 — Minor — Implementation (picture) — The y-window cuts off the steep end of f, the outermost nodes and the largest error in several cases

- **Location:** chebyshev_animations_all.jl:202-203 (`robust_ylims` takes the 3%–97% quantiles of f over the plot range, and f itself is clamped) and line 221 (the nodes are not clamped, so nodes outside the window simply disappear).
- **Now:** In cases 01, 02, 03, 07, 09, 10, 11 and 16 (and marginally 04-06), the part of f nearest a singularity is drawn as a flat line along the frame edge, and the endpoint node falls outside the window. For example, in case 03 (f = 1/(1−x)², f(0.9)=100) the window stops at y = 37.5. The final-frame nodes at x=0.846 (f=42.3) and x=0.894 (f=89.0) are not visible.
- **True:** Both the clustering of nodes at the endpoint (the feature the Description highlights) and the largest error sit in the hidden part. For case 03 at degree 15, the maximum error is 1.434 at x = 0.900, while the largest error inside the visible window is 0.658.
- **Evidence:** `python3 offchart.py` lists every off-window node per frame, e.g. "03 … n=16:[(0.846, 42.26), (0.894, 88.97)]" and "01 … n=16:[(0.894, 9.43)]". `python3 hidden_err.py` prints "max err 1.434 at x=0.9000, f there=100.0; ylims top 37.5 reached at x=0.8367; max err within visible part: 0.658". The full-size `committed/cheby01/frame_010.png` and `cheby03/frame_010.png` show f and the interpolant running flat along the top edge.
- **Suggested fix:** For the `with_span` cases, compute the ylims from f over the approximation interval (the span) rather than from quantiles over the whole plot range. Alternatively, keep the quantile limits and state on the page that the steep end is cropped.

- **Independent check:** not run (minor finding, unverified).

### F6 — Minor — Page match — "(expanded)" in the alt text for cases 04 and 29 matches nothing in the GIFs

- **Location:** index.qmd:40 "f(x)=sqrt(x), interval [0, 4] (expanded)."; index.qmd:140 "f(x)=bessely(0,x), interval [0.5, 6] (expanded)."
- **Now:** The alt text marks these two cases as "expanded".
- **True:** Case 04 uses the same plot window (x in [0, 10.5]) and settings as cases 05 and 06. Case 29 uses the same window (x in [0, 22]) as cases 27 and 28. Their intervals are the shortest in each group, not expanded ones, and there is no zoom and no other difference in the script.
- **Evidence:** chebyshev_animations_all.jl:27-29 and 50-52. `dump_cases.jl` shows identical `xlims` and `ylims` within each group.
- **Suggested fix:** Delete "(expanded)" from both alt texts, or say what it means.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `chebyshev_animations_all.jl` | yes | 18.5 | 29 GIFs |

Committed GIFs byte-identical to their regenerated output: **29 of 29**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Chebyshev-node interpolation uses clustered nodes near interval endpoints" | Script line 97 gives cos-spaced nodes, densest at the ends (dump.txt node lists). | confirmed |
| 2 | 12 | "…to reduce oscillation compared with equally spaced interpolation at the same degree" | `runge_compare.py`, f=1/(1+10x²) on [-1,1], max error Chebyshev vs equispaced: deg 11 4.8e-2 vs 2.4e-1; deg 15 1.4e-2 vs 4.8e-1; deg 31 9.5e-5 vs 1.4e1. At deg 7 the two are comparable (0.165 vs 0.135). | confirmed |
| 3 | 12 | "Chebyshev-based polynomial approximation is a standard remedy for Runge-type endpoint blow-up" | Same computation; the cheby08 frames converge (script max error 9.46e-5 at deg 31). | confirmed |
| 4 | 14-18 | "$n$ Chebyshev nodes are the mapped roots $x_k = \frac{a+b}{2} + \frac{b-a}{2}\cos(\frac{(2k-1)\pi}{2n})$, k=1..n" | Script line 97 is the same formula. `verify.py`: the script's nodes match this formula to 1.8e-16 of the width, and max\|T_n(mapped node)\| ≤ 5e-14 (first-kind roots), for all 29 cases and every frame. | confirmed |
| 5 | 12 (implicit), title | The method is Chebyshev-node interpolation (an approximation polynomial) | The code does barycentric Lagrange interpolation at first-kind nodes. It computes no series or projection coefficients. `verify.py` matches a 50-digit Lagrange interpolant to ≤ 3.1e-15 relative. | confirmed |
| 6 | 22 | "increases polynomial degree one step at a time" | The degrees are 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 (case 08 also 19, 23, 27, 31). | wrong (→ F1) |
| 7 | 22 | "for a fixed function and approximation interval" | Each case's span is fixed. The fallback that trims the interval (lines 89-104) never runs (`trimmed=false` in every frame of dump.txt). | confirmed |
| 8 | 24 | Link "Julia source for all cases" → chebyshev_animations_all.jl | The file exists and produces all 29 GIFs (manifest). | confirmed |
| 9 | 28 | Case 01: f(x)=1/(1-x), interval [-1.6, 0.9] | Script line 24; span (-1.6, 0.9); title "1/(1-x), interval [-1.6, 0.9]"; embed cheby01.gif | confirmed |
| 10 | 32 | Case 02: f(x)=1/(1+x), interval [-0.9, 1.6] | Line 25; span (-0.9, 1.6); title matches; cheby02.gif | confirmed |
| 11 | 36 | Case 03: f(x)=1/(1-x)^2, interval [-1.6, 0.9] | Line 26; span (-1.6, 0.9); title matches; cheby03.gif | confirmed |
| 12 | 40 | Case 04: f(x)=sqrt(x), interval [0, 4] | Line 27; span (0, 4); title "interval [0, 4]"; cheby04.gif | confirmed |
| 13 | 40 | Case 04: "(expanded)" | Nothing in the script or the frames corresponds. | wrong (→ F6) |
| 14 | 44 | Case 05: f(x)=sqrt(x), interval [0, 8] | Line 28; span (0, 8); title matches; cheby05.gif | confirmed |
| 15 | 48 | Case 06: f(x)=sqrt(x), interval [0, 10] | Line 29; span (0, 10); title matches; cheby06.gif | confirmed |
| 16 | 52 | Case 07: f(x)=1/sqrt(1-x), interval [-1.6, 0.9] | Line 30; span (-1.6, 0.9); title matches (last digit of "15" grazes the edge but is legible); cheby07.gif | confirmed |
| 17 | 56 | Case 08: f(x)=1/(1+10x^2), interval [-1, 1] | Line 31; span (-1, 1); title matches; cheby08.gif | confirmed |
| 18 | 56 | Case 08: "up to order 31" | `max_order=31`; the last frame is titled "degree 31" (its real degree is 30, see F4). | confirmed |
| 19 | 60 | Case 09: f(x)=log(x), interval [0.02, 2] | Line 32; span (0.02, 2.0); title matches; cheby09.gif | confirmed |
| 20 | 64 | Case 10: f(x)=log(x), interval [0.02, 4] | Line 33; span (0.02, 4.0); title matches; cheby10.gif | confirmed |
| 21 | 68 | Case 11: f(x)=log(1+x), interval [-0.98, 1] | Line 34; span (-0.98, 1.0); title matches; cheby11.gif | confirmed |
| 22 | 72 | Case 12: f(x)=sin(x), interval [-3pi, 3pi] | Line 35; span ±9.42478 = ±3π; title "[-9.425, 9.425]" (same interval); cheby12.gif | confirmed |
| 23 | 76 | Case 13: f(x)=cos(x), interval [-3pi, 3pi] | Line 36; span ±3π; title "[-9.425, 9.425]"; cheby13.gif | confirmed |
| 24 | 80 | Case 14: f(x)=tan(x), approximation interval [-1.45, 1.45] | Line 37; span (-1.45, 1.45); title matches; cheby14.gif | confirmed |
| 25 | 80 | Case 14: "inside singularities" | The poles are at ±π/2 = ±1.5708, outside [-1.45, 1.45]; all nodes are finite and visible (offchart.py). | confirmed |
| 26 | 84 | Case 15: f(x)=exp(x), interval [-2, 3] | Line 38; span = xlims (-2, 3); title matches; cheby15.gif | confirmed |
| 27 | 88 | Case 16: f(x)=cos(x)*exp(-x), interval [-2, 4] | Line 39; span (-2, 4); title matches; cheby16.gif | confirmed |
| 28 | 92 | Case 17: f(x)=cosh(x), interval [-4, 4] | Line 40; span (-4, 4); title matches; cheby17.gif | confirmed |
| 29 | 96 | Case 18: f(x)=atan(x), interval [-2.2, 2.2] | Line 41; span (-2.2, 2.2); title matches; cheby18.gif | confirmed |
| 30 | 100 | Case 19: f(x)=asin(x) | Line 42; title "asin(x)"; cheby19.gif | confirmed |
| 31 | 100 | Case 19: interval [-1.5, 1.5] | The span is [-0.99932, 0.99932]; the title says "[-0.999, 0.999]". | wrong (→ F2) |
| 32 | 104 | Case 20: f(x)=besselj(0,x), interval [-10.2, 10.2] | Line 43; span (-10.2, 10.2); title matches; cheby20.gif (the degree is clipped from the title, F3) | confirmed |
| 33 | 108 | Case 21: f(x)=besselj(1,x), interval [-10.2, 10.2] | Line 44; span (-10.2, 10.2); title matches; cheby21.gif (the degree is clipped from the title, F3) | confirmed |
| 34 | 112 | Case 22: f(x)=normal_pdf(x), interval [-3, 3] | Line 45 uses exp(-x²/2)/√(2π), matching mpmath `npdf` to 6.8e-17; span (-3, 3); title matches; cheby22.gif | confirmed |
| 35 | 116 | Case 23: f(x)=normal_cdf(x), interval [-3, 3] | Line 46 uses 0.5+0.5·erf(x/√2), matching mpmath `ncdf` to 9e-17; span (-3, 3); title matches; cheby23.gif | confirmed |
| 36 | 120 | Case 24: f(x)=gamma(x), interval [0.05, 2] | Line 47; span (0.05, 2.0); title matches; cheby24.gif | confirmed |
| 37 | 124 | Case 25: f(x)=gamma(x), interval [0.05, 4] | Line 48; span (0.05, 4.0); title matches; cheby25.gif | confirmed |
| 38 | 128 | Case 26: f(x)=gamma(x), interval [0.5, 5] | Line 49; span (0.5, 5.0); title matches; cheby26.gif | confirmed |
| 39 | 132 | Case 27: f(x)=bessely(0,x), interval [0.5, 20] | Line 50; span (0.5, 20.0); title matches; cheby27.gif | confirmed |
| 40 | 136 | Case 28: f(x)=bessely(0,x), interval [0.5, 10] | Line 51; span (0.5, 10.0); title matches; cheby28.gif | confirmed |
| 41 | 140 | Case 29: f(x)=bessely(0,x), interval [0.5, 6] | Line 52; span (0.5, 6.0); title matches; cheby29.gif | confirmed |
| 42 | 140 | Case 29: "(expanded)" | Nothing in the script or the frames corresponds. | wrong (→ F6) |
| 43 | 26-140 | Wiring: each "Case NN" heading embeds chebyNN.gif, which is case NN | The manifest references (lines 28…140) match the script's ids and the frame titles "Chebyshev Case NN". | confirmed |

## Implementation checks

### chebyshev_animations_all.jl
- **Method:** The script interpolates at Chebyshev nodes of the **first kind**, the roots of T_n mapped affinely from [-1,1] to [a,b] (line 97). It is not a truncated Chebyshev series or projection, and it never computes Chebyshev coefficients. The interpolant is evaluated with the second ("true") barycentric formula (lines 120-135), and the weights come from the product formula w_j = 1/∏(x_j−x_k) (lines 108-118). This is the correct barycentric interpolant for any node set. For **every** case, the data are exact samples f(x_k) of the case's function at the nodes; nothing is fitted or sampled from a plot. Each case's interval is `node_span` intersected with the finite part of the plot range (`resolved_span`). For the `auto_span` cases it is the finite part of the plot range. That equals the plot range for every case except 19 (see F2). The fallback that trims the interval for non-finite values never runs in any frame.
- **Numbers:** `julia dump_cases.jl` dumps, for all 29 cases and every frame, the span, the nodes, f at the nodes, and the interpolant at 7 probe points per frame. `verify.py` is independent of the script's code. It rebuilds the nodes from the first-kind formula, evaluates f with mpmath at 50 digits (including `besselj`, `bessely`, `gamma`, `npdf`, `ncdf`, `asin`, `atan`, `tan`, `log`), and evaluates a 50-digit product-form Lagrange interpolant. Worst disagreement over all frames, script vs independent:
  - Nodes: ≤ 1.8e-16 relative to the interval width, in all cases.
  - First-kind check: max\|T_n(t_k)\| ≤ 5.1e-14 over all cases (worst is case 28).
  - f at the nodes: ≤ 2.6e-16 relative. Special-function cases: 20 J0 9.1e-17, 21 J1 1.2e-16, 22 normal_pdf 6.8e-17, 23 normal_cdf 8.5e-17, 24-26 Γ ≤ 1.1e-16, 27-29 Y0 ≤ 1.5e-16, 19 asin 1.2e-16.
  - Interpolant at the probes: ≤ 3.1e-15 relative (case 03). Special-function cases are ≤ 2.3e-15 (case 25).
  - Case 08 max error on [-1,1]: the script gives 0.165 (deg 7), 0.0138 (deg 15) and 9.46e-5 (deg 31). `runge_compare.py` (mpmath) gives 0.1648, 0.01376 and 9.471e-5.
  - Errors in the final frame fall steadily in every case (dump.txt), e.g. exp 7.1e-12, J0 1.05e-3, Y0 on [0.5, 6] 1.7e-5. The slow cases are those with an endpoint singularity: sqrt about 0.06-0.1, log on [0.02, 4] 0.13, Γ on [0.05, 4] 0.65.
  - The interpolant's real degree is lower than the title's for symmetric problems (F4, `actual_degree.py`).
- **Reference values:** The "true" curve is f itself, evaluated by Julia Base and SpecialFunctions 2.9.2. It agrees with mpmath at the nodes to ≤ 2.6e-16 relative, as above. normal_pdf and normal_cdf are written correctly (exp(-x²/2)/√(2π) and ½(1+erf(x/√2))).
- **Picture:**
  - Contact sheets: cheby08, 12 and 27. Full-size final frames: cheby01, 03, 04, 14, 19 and 24. Title strips: the final frame of all 29 cases, frame 1 vs the final frame of all 29 (`right_top.png`, `right_bot.png`), and every frame of 19, 20 and 21.
  - The function, interval and degree in each title come from the same `case` and `span` used for the computation. The red nodes are plotted at (x_k, f(x_k)). The interpolant passes through them (nodes reproduced: `barycentric_eval` returns y_j when x is at a node). The blue curve is the interpolant over the whole plot range, including extrapolation beyond the interval (e.g. cheby04 for x>4, cheby24 for x>2), clamped to the window.
  - Clamping the interpolant to the window reads as "off-scale" and does not mislead, except that the window is set from f's quantiles, which hides the steep end (F5). In cheby14, f clamped across the poles of tan draws vertical lines at x = ±π/2. That is an ordinary asymptote artifact.
  - The title overflows the frame in cases 19, 20 and 21 (F3).
  - Frame counts are 10 per GIF and 14 for cheby08, matching the node-count sequence (F1). GIFs play at fps=2.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/chebyshev-approximation-polynomial/`](evidence/chebyshev-approximation-polynomial/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
