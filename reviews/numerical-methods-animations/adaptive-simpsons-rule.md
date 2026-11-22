# Adaptive Simpson's Rule — animation review

Page: [`pages/numerical-methods/adaptive-simpsons-rule/index.qmd`](../../pages/numerical-methods/adaptive-simpsons-rule/index.qmd) · Scripts: `adaptivesimpsonsaa.jl` · GIFs: 1

**Result:** 0 error, 2 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — The page's 15ε criterion does not produce the refinement shown; the animation follows a factor-1 test that keeps the coarse S(a,b)

- **Location:** index.qmd lines 18–22: "A common acceptance criterion is $\left|S(a,m)+S(m,b)-S(a,b)\right| < 15\,\varepsilon$, so refinement concentrates …". Read together with line 27, "with tolerance $10^{-3}$", and line 31, "$\varepsilon=10^{-3}$". Also adaptivesimpsonsaa.jl lines 11–34 (hard-coded `node_sets`) and lines 47–57 (`simpson_nonuniform`).
- **Now:** The Description gives the 15ε test as the acceptance criterion. It then says the animation shows the adaptive refinement for ε = 10^-3. The reader concludes that the 41-point final partition and the value 2.016252 come from that test at ε = 10^-3.
- **True:** The script runs no adaptive test (see F3), so I tested the hard-coded progression against candidate rules.
  - **The rule that matches.** Exactly one rule reproduces the script's final partition: split [a,b] unless |S(a,m)+S(m,b)−S(a,b)| < 1·ε·(b−a)/(B−A), with ε = 10^-3. The tolerance is split between halves by halving it at each level. The accepted panel then contributes its coarse S(a,b), not S(a,m)+S(m,b), and there is no Richardson correction.
  - **Every split and keep agrees with it.** Across all 41 panels ever drawn, d/(b−a) is at most 4.53e-4 for every kept panel and at least 5.30e-4 for every split panel. So the drawn progression implies a test factor between 0.906 and 1.06, not 15 or 10.
  - **What the page's own test gives.** With the 15ε test, tolerance halved per level, and S(a,m)+S(m,b) returned (the textbook scheme), the run stops much earlier. It accepts 9 intervals: 18 Simpson panels, 37 points. Its value is 2.0160635 (error −2.16e-4), or 2.0162036 with the Richardson correction. Near x = 0 its finest interval is [0, 1/32], not [0, 2^-11].
  - **Nothing else matches.** No 10ε or 15ε variant, with or without tolerance halving or Richardson, reproduces the drawn partition.
- **Evidence:** `python3 hypothesis.py`:
  ```
  fac= 1 drawn panels=coarse S(a,b): panels=20 nodes=41 value=2.0162517612 matches script partition: True
  fac=10 drawn panels=halves     : panels=20 nodes=41 value=2.0161354773 matches script partition: False
  fac=15 drawn panels=halves     : panels=18 nodes=37 value=2.0160634881 matches script partition: False
  fac=15 drawn panels=coarse S(a,b): panels= 9 nodes=19 value=2.0139618530 matches script partition: False
  ```
  `python3 panels.py`: "width-scaled d/(b-a): max kept = 4.5296e-4, min split = 5.2996e-4". `python3 indep.py` lists the accepted intervals for all 8 standard variants. None equals the script's partition.
- **Suggested fix:** Either:
  - **Change the page.** State the rule the animation actually follows: "accept [a,b] when |S(a,m)+S(m,b)−S(a,b)| < ε·(b−a)/(B−A) and use S(a,b) on it". Keep the 15ε test as a remark about the usual criterion, adding that it would stop at 37 points for this example.
  - **Change the script.** Compute the node sets with the 15ε rule at ε = 10^-3, using S(a,m)+S(m,b) on accepted intervals, and redraw.

- **Independent check:** confirmed. Checker: with ε=10⁻³ the page's 15ε test gives 19 nodes (S=2.016063) with tolerance halving, 11 without; the animation's 41-node set arises only from the 15× stricter |S₂−S|<ε with halving. Arguably an Error.

### F2 — Misleading — Page match — The animation never shows where the nodes are, so the claimed nonuniform concentration cannot be seen

- **Location:** index.qmd line 27: "showing how new points are introduced nonuniformly". Line 33: "The partition evolves from coarse to fine by splitting only where needed". Line 37 alt text: "nonuniform node refinement concentrates on difficult regions". adaptivesimpsonsaa.jl lines 79–80: the only per-panel drawing is a filled parabola, with no node markers and no boundary lines.
- **Now:** Panel boundaries show up only as 1-pixel seams of RGB (255,215,221) against fill (255,207,214), which is about 3% contrast. A zoomed crop of frame 21 (`reviewer/frame_021_zoom.png`) shows them only faintly. No node markers are drawn.
  - **Early frames.** In frames 2–8 the refinement shows only indirectly, as the parabolas get closer to f.
  - **Last seven frames.** The splits in frames 15–21 (node sets 14–20) all happen inside [0, 1/32], about 9 pixels wide. The deepest panel is [0, 2^-11], 0.15 pixel wide. These frames look identical apart from the "Sample Points" and "Approximation" text.
- **True:** The computed partition really is strongly nonuniform. It is graded geometrically to width 2^-11 at x = 0, where f′ ~ (16/3)x^(−1/3) is unbounded, and [1.5, 2] is never split. But a viewer cannot see this, and cannot see which panel each frame splits.
- **Evidence:** `python3 panels.py` gives the split sequence: sets 13→20 each split only the panel [0, 2^-k]. `python3 pixscan.py` scans pixel row y = 430 in frames 14 and 21. The boundary seams sit at x-pixels 40, 48, 57, 75, 93, 111, 147, … and frame 21 adds only pixels 40–44 to frame 14's seams.
- **Suggested fix:** Draw the nodes, for example with `scatter!(xs, f.(xs))` and/or `vline!` at the panel ends, and mark or highlight the panel split in each frame. Add an inset or log-scaled x-axis near x = 0, or else soften the page text to say the late refinement happens in a region too small to see at this scale.

- **Independent check:** confirmed with correction. Checker: every refinement after about frame 14 lies within x<0.008 (<2.3 px). Correction: in early frames the kinks between parabolas (e.g. at 0.5 and 1.0) do show the uneven panels, so 'no visible indication' is slightly too strong.

### F3 — Minor — Implementation — The script runs no adaptive algorithm: `tol` is only a label and the node sets are hard-coded

- **Location:** adaptivesimpsonsaa.jl line 11 (`tol = 1e-3`, used only in the label at line 86), lines 13–34 (`node_sets` literal), and header line 2 ("Adaptive Simpson's Rule animation").
- **Now:** The script evaluates composite Simpson on 20 hard-coded partitions. No error estimate or acceptance test is computed, so changing `tol` changes only the "tol = 0.001" text in the frames. Node sets 16–20 also hold six-significant-digit decimal approximations of dyadic nodes, for example `0.0117188` for 0.01171875.
- **True:** The playback is consistent with a valid (factor-1) adaptive rule at ε = 10^-3 (see F1), so the values shown are not wrong. The rounded nodes move middle nodes off the midpoint by up to 5e-8 and change the final approximation by 5.6e-9 (2.0162517668 against 2.0162517612 exact-dyadic). That is invisible at the six decimals displayed. The order in which panels are split from frame to frame is roughly level by level, with [0.5,1] split before [0,0.5]. That is not the order a recursive implementation would visit them, but the page makes no claim about order.
- **Evidence:** `julia instr.jl`: maxmidpointdev = 5e-08 for sets 16–20, 0 otherwise. `python3 hypothesis.py` vs `julia instr.jl` for the final value.
- **Suggested fix:** Generate `node_sets` with an actual adaptive routine driven by `tol`, using the rule the page states (see F1). This also removes the rounded literals.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `adaptivesimpsonsaa.jl` | yes | 3.7 | adaptivesimpsonsaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "recursively subdivides intervals until a local error estimate is below a tolerance" | The drawn progression is recursive bisection. Every split panel fails and every kept panel passes \|S2−S\| < ε(b−a)/2 (`panels.py`). | confirmed |
| 2 | 13–15 | $S(a,b)=\frac{b-a}{6}[f(a)+4f(m)+f(b)]$ | Matches script line 54 (h/3 with h=(b−a)/2). Script routine exact on x^3 (err 0, 1e-13 on rounded set 20) and not on x^4 (err 0.2667 = 24/90 on set 1) (`degree.jl`). | confirmed |
| 3 | 16 | "refinement compares $S(a,b)$ against $S(a,m)+S(m,b)$" | This indicator separates kept from split panels exactly (`panels.py`). | confirmed |
| 4 | 18–21 | acceptance criterion "$\|S(a,m)+S(m,b)-S(a,b)\| < 15\,\varepsilon$" (for this page's ε = 10^-3) | The drawn partition needs factor ≈1 (0.906–1.06) and the coarse S(a,b). The 15ε test gives 37 points, value 2.016063 (`hypothesis.py`, `indep.py`). | wrong (→ F1) |
| 5 | 22 | "refinement concentrates where curvature or oscillation is strongest" | Deepest refinement is at x=0 (to 2^-11), where f′ and f″ are unbounded. Panels around the peak at 0.08 and the trough at 0.43 go to widths 1/16–1/8. [1.5,2], the flattest part, is never split (`panels.py`). | confirmed |
| 6 | 27 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | Script lines 8–9; magenta curve in frames 1, 2, 21 matches f (peak ≈1.92 near 0.08, min ≈0.36 near 0.43). | confirmed |
| 7 | 27 | "with tolerance $10^{-3}$" | `tol` is only a label (F3). The drawn progression is consistent with ε = 10^-3 only under a factor-1 test, not the 15ε test the page gives. | confirmed for the label; consistency with the stated criterion → F1 |
| 8 | 27 | "Frames follow the recorded node-set progression from the worked example" | The page's Worked Example is a "(Planned)" placeholder (lines 44–46) and the legacy source is unavailable, so there is nothing to compare against. | could not determine (no worked example exists to compare) |
| 9 | 27 | "showing how new points are introduced nonuniformly" | The computed node sets are nonuniform, but nodes and boundaries are not visibly drawn. | wrong (→ F2) |
| 10 | 31 | Heading: $f$, $[0,2]$, $\varepsilon=10^{-3}$ | As 6 and 7. | confirmed (ε caveat → F1) |
| 11 | 33 | "The partition evolves from coarse to fine by splitting only where needed" | Computation: each frame splits one panel that fails the (factor-1) test, and none that passes. Visibility: not shown (F2). | confirmed numerically; not visible (→ F2) |
| 12 | 33 | "each frame redraws the piecewise quadratic approximation over the current node set" | Script lines 67–81: interpolating parabola through (x0,x1,x2) on each panel. In frames 2, 3, 8, 21 the arcs pass through f at the panel ends and midpoints (e.g. frame 2 arc through (0,1), (1,1.36), (2,1.01)). | confirmed |
| 13 | 33 | "updates the running integral estimate" | Frame text "Approximation" in all 20 non-blank frames matches my independent per-set composite to 6 decimals (table below). | confirmed |
| 14 | 29, 35 | Julia source linked under the case: `adaptivesimpsonsaa.jl` | The link resolves to the only script, which produces the GIF (manifest). | confirmed |
| 15 | 37 | embed `adaptivesimpsonsaa.gif` | Byte-identical to the script's output (manifest). | confirmed |
| 16 | 37 | alt: "nonuniform node refinement concentrates on difficult regions" | True of the computed partition, not visible in the frames. | wrong (→ F2) |
| 17 | 37 | alt: "the piecewise quadratic approximation and integral estimate update each frame" | As 12 and 13. Frame 1 is a blank start frame showing only f, with no partition and no estimate. | confirmed |

## Implementation checks

### adaptivesimpsonsaa.jl
- **Method:** The script is a playback, not an implementation (F3). It draws composite Simpson with one interpolating parabola per panel on 20 hard-coded partitions, preceded by one blank frame (21 frames total, fps 2). Checked against every standard variant (`hypothesis.py`, `panels.py`, `indep.py`), the partitions are exactly those produced by one rule:
  - **Acceptance test:** |S(a,m)+S(m,b)−S(a,b)| < ε·(b−a)/2. That is factor 1, with the tolerance split in proportion to width (halved per level), at ε = 10^-3.
  - **Accepted value:** the coarse S(a,b), with no Richardson correction.

  The textbook 15ε and Burden–Faires/Mathews 10ε tests (with halving, returning S(a,m)+S(m,b)) give different partitions:

  | Variant | Accepted intervals | Simpson panels | Points | Value |
  |---|---|---|---|---|
  | 15ε, halving | 9 | 18 | 37 | 2.0160635 |
  | 10ε, halving | 10 | 20 | 41 | 2.0161355 |

  The 10ε run's 41 points are graded only to 1/128 near 0, and it splits [1.5,2]. Without tolerance halving, either test stops at 5 intervals, value 2.0130.
- **Numbers:** `simpson_nonuniform` on each set (script, from `instr.jl`) beside my independent mpmath composite on exact dyadic panels (`persets.py`):

  | set | points | script | independent |
  |---|---|---|---|
  | 1 | 3 | 2.4912610173 | 2.491261017 |
  | 2 | 5 | 1.6117863286 | 1.611786329 |
  | 3 | 7 | 1.9096331948 | 1.909633195 |
  | 4 | 9 | 1.9414360777 | 1.941436078 |
  | 5 | 11 | 1.9351282761 | 1.935128276 |
  | 6 | 13 | 2.0017436287 | 2.001743629 |
  | 7 | 15 | 2.0033021058 | 2.003302106 |
  | 8 | 17 | 2.0124446277 | 2.012444628 |
  | 9 | 19 | 2.0130921442 | 2.013092144 |
  | 10 | 21 | 2.0129061834 | 2.012906183 |
  | 11 | 23 | 2.0127736933 | 2.012773693 |
  | 12 | 25 | 2.0151243462 | 2.015124346 |
  | 13 | 27 | 2.0151952619 | 2.015195262 |
  | 14 | 29 | 2.0159203114 | 2.015920311 |
  | 15 | 31 | 2.0161477589 | 2.016147759 |
  | 16 | 33 | 2.0162192591 | 2.016219254 |
  | 17 | 35 | 2.0162417544 | 2.016241748 |
  | 18 | 37 | 2.0162488348 | 2.016248829 |
  | 19 | 39 | 2.0162510645 | 2.016251059 |
  | 20 | 41 | 2.0162517668 | 2.016251761 |

  Sets 16–20 differ by about 5e-9 because of the rounded node literals (F3). That is invisible at the 6 displayed decimals.
  - **Panel structure:** Every set has an odd point count, and every consecutive triple is a valid panel with its middle node at the midpoint: deviation 0 for sets 1–15, 5e-8 for sets 16–20.
  - **Degree of precision:** The script's routine is exact for x^3 and not for x^4, as it should be for Simpson.
- **Reference values:** The script has no "exact" integral. My reference is I = 2.0162797196170963279. mpmath tanh-sinh and Gauss–Legendre after the substitution x = t^3, which removes the x^(2/3) singularity, agree to 20 digits. Direct tanh-sinh on x agrees to 1e-11. The final displayed 2.016252 has error −2.80e-5, within tol = 10^-3. The sum of true per-panel errors over the final partition matches this (`panels.py`). The largest per-panel error is −9.3e-5, on [1.5,2].
- **Picture:** I looked at the contact sheet and at frames 1, 2, 8, 14 and 21 full size, plus a 3× zoom of frame 21 over [0,0.75] and a pixel-row scan of frames 14 and 21.
  - **Correct:** Parabolas are built from the right three nodes (`poly_coeffs` on (x0,x1,x2)) and pass through f at the nodes. The fill goes to 0. The magenta curve is f.
  - **Text:** "Sample Points" equals the length of the node set. "Approximation" equals `simpson_nonuniform` of the same set rounded to 6 digits, for example frame 2 shows 2.491261, frame 8 shows 2.003302 and frame 21 shows 2.016252, all matching the table.
  - **Axes:** ylims [0, 2.1] contain f (max ≈1.92, min ≈0.36). No clamping or masking is used.
  - **Defect:** Nodes and panel boundaries are effectively invisible, so the refinement in frames 15–21 (inside [0, 1/32]) cannot be seen (F2).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/adaptive-simpsons-rule/`](evidence/adaptive-simpsons-rule/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
