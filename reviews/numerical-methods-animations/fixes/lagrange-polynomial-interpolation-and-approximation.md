# Fix record: lagrange-polynomial-interpolation-and-approximation

Work package WP-B. This fixer also owns the Newton Interpolation page, which shares the script `lagnewt_animations_all.jl` (see `fixes/newton-interpolation-polynomial.md`). The two copies of the script are byte-identical (`cmp` gives no output).

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/lagrange-polynomial-interpolation-and-approximation/fix/`

- `orig/`, `new/`: the script before and after the fix. `origfirst/` is the old script with only the evaluator changed to the first barycentric form. `newsecond/` is the new script with the old second-form evaluator put back. Each folder has a `defs.jl` (the script without its render loop) and a `dump.txt`.
- `dump.jl`: re-runs every frame computation (nodes, y-limits, plotted values) for a version. Run `julia dump.jl <orig|new|origfirst|newsecond>`.
- `indep.py`: an independent check of every frame. It uses its own mpmath definitions of all 29 functions, rebuilds the nodes as a + k(b−a)/(n−1), builds the interpolant by 60-digit Newton divided differences, clamps it to the frame's y-limits, and compares it with the script's plotted values at all 1000 points of all 290 frames. Run `/usr/bin/python3 -I indep.py <version>`. Output is in `indep_out.txt` and `indep_origfirst.txt`.
- `rawrel.py`: the relative error of the script's unclamped values against the same 60-digit interpolant, and the count of wrong-sign points. Output is in `rawrel_out.txt` and `rawrel_newsecond.txt`.
- `err.py`: the maximum of |P − f| over the node hull on a 4001-point grid, for every case and degree. Output is in `err_out.txt`.
- `ledger_checks.py`: a symbolic check of the first barycentric form, the normal pdf/cdf definitions, f at both ends of every listed span, and the tan node spacing. Output is in `ledger_checks_out.txt`. `tan_span.py` holds the node-span search for Case 14.
- `gen_cases.py`: generates the 29 case headings and alt texts and asserts that every interval matches the script's own `xlims` and node span (from `new/dump.txt`).
- `committed/`: copies of the GIFs before the fix, with frames of 04, 08, 14 and 29. `run/` is a scratch run of the new script. `new_frames/` holds the frames of all 29 regenerated GIFs, with `last_all.png` as a montage of every last frame. `archive/` holds the legacy frames and the formula montage.

## Findings

### F1 — Error — fixed
- Reproduced: the script has `n_nodes_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]`. `dump.jl` emits frames n = 2, 3, 4, 5, 6, 8, 10, 12, 14, 16 for every case. Every regenerated GIF has 10 frames (29 × "10" from the frame count). Titles in the sheets for 03, 19 and 24 read degree 1, 2, 3, 4, 5, 7, 9, 11, 13, 15.
- Change: index.qmd:25 "Each animation increases polynomial degree one step at a time for a fixed function and interval." → "Each animation raises the polynomial degree through 1, 2, 3, 4, 5, 7, 9, 11, 13 and 15 (2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 nodes) for a fixed function and node interval. Where a curve leaves the plot window, it is drawn along the window's top or bottom edge." The animation was not changed (D7).
- Check: as above. The second sentence describes `clamp.(yinterp, ylims...)` and `ytrue_clip` in the script, and can be seen in the new frames: lagnewt04 frame 10 and lagnewt29 frames 9 and 10 have the interpolant running along the top edge.

### F2 — Error — fixed
- Reproduced: `indep.py orig` reports "frames with any point off by >1e-6 of y-range: [('04', 16, 450, 1.0), ('29', 14, 44, 1.0), ('29', 16, 488, 1.0)]". That is exactly 3 of 290 frames, with the same point counts as the review. `rawrel.py orig` gives max relative errors of 4.54e+03 (04, degree 15), 129 (29, degree 13) and 40.6 (29, degree 15). Every bad point has the wrong sign (450, 44, 488).
- Change: `lagnewt_animations_all.jl` `barycentric_eval` now uses the first barycentric form `l(x) * sum_j w_j y_j/(x - x_j)` with `l(x) = prod_j (x - x_j)`, plus a comment explaining why. index.qmd:12 now says the animations use this form, that it is the same interpolant, and that it stays accurate far outside the nodes, where the second form gives wrong-sign values in Cases 04 and 29. All GIFs were regenerated in both folders.
- Check:
  - With the evaluator change alone, on the old nodes, `indep.py origfirst` gives a max clamped difference of 7.85e-10 of the y-range and no bad frames.
  - With the final script, `indep.py new` gives a max clamped difference of 2.15e-09 of the y-range over all 290 frames and 1000 points, and no bad frames. `rawrel.py new` gives a largest relative error of 1.69e-07 (29, degree 15) and no wrong-sign points.
  - On the new nodes the second form would still fail. `rawrel.py newsecond` finds wrong-sign points in ('29', 16, 151), ('04', 14, 4), ('29', 14, 2) and ('04', 16, 1), and in no other case. That supports the page's "in Cases 04 and 29".
  - Frames viewed at full size: new lagnewt04 frame 10 and lagnewt29 frames 9 and 10. There are no vertical bars, and the interpolant rises off the top once and stays on the top edge.

### F3 — Misleading — fixed
- Reproduced: the old index.qmd has bare "### Case NN" headings, and all 29 alt texts end with "from the legacy function-and-interval list". No function or interval appears anywhere on the page.
- Change: each heading is now "### Case NN: $f(x)=…$, nodes on $[a, b]$". Each alt text names the function, the node interval, "degree rising from 1 to 15" and the plot window ("the same interval" when the two coincide). index.qmd:21 → "The 29 animations below follow the legacy Mathews case ordering. Each case heading gives the function and the node interval $[a, b]$; the nodes are equally spaced from $a$ to $b$, endpoints included. Where the plot window is wider than $[a, b]$ (Cases 04–06, 08–11, 14, 19 and 24–29), the curve beyond the nodes is extrapolation."
- Check:
  - `gen_cases.py` asserts every interval against `new/dump.txt`. It prints "all intervals match script: True | window wider than node interval in cases: ['04', '05', '06', '08', '09', '10', '11', '14', '19', '24', '25', '26', '27', '28', '29']".
  - The function in each heading was checked against the script label printed by the same run. `indep.py` confirms that the script's node values equal mpmath's f for those functions (max relative difference 6.6e-15).
  - `ledger_checks.py` confirms the normal pdf/cdf formulas: npdf − e^{−x²/2}/√(2π) ≤ 2e-18 and ncdf − ½(1+erf(x/√2)) ≤ 3e-32 at 30 digits.

### F4 — Misleading — fixed (script; checker's correction applied)
- Reproduced: `dump.jl orig` shows an inset of exactly 3% of the span width at both ends in all 290 frames (for example (0.06, 0.06) for case 04 and (0.0594, 0.0594) for case 09). `err.py` gives these degree-15 maxima of |P − f| over the node hull:

  | Case | Old nodes (3% inset) | New nodes (full interval) |
  |---|---|---|
  | 04 | [0.06, 1.94]: 0.000631 | [0, 2]: 0.0485 (77 times larger) |
  | 08 | [−0.94, 0.94]: 0.368 | [−1, 1]: 0.485 |

- Change (the finding says the inset hides the feature the case shows, so the animation was changed, not just the text):
  - `equal_nodes`: the first attempt uses trim 0, so nodes are equally spaced from a to b, endpoints included. The inset retry (0.03, 0.04, … of the width) now runs only if f is non-finite at some node.
  - `resolved_span`: a listed span is used as given.
  - Case 14 (tan): given an explicit node span [−3, 3], because 5 nodes on [−π, π] are −π, −π/2, 0, π/2, π and would sit on the poles (`ledger_checks.py` prints those nodes).
  - Case 19 (asin): given the span [−1, 1]. The old automatic span was the finite part of a 2200-point grid, [−0.99932, 0.99932].
  - The text change is in F3.
- Check:
  - `dump.jl new` shows inset (0.0, 0.0) in all 290 frames, so the retry never fired.
  - `ledger_checks.py` shows f finite at both ends of every listed span (for example f(0) = 0 for √x, f(±1) = ±1.5708 for asin, f(0.05) = 19.4701 for Γ, and Y₀(0.5) = −0.444519).
  - `indep.py new` confirms the nodes equal a + k(b−a)/(n−1) to 1.4e-15.
  - In the sheet of lagnewt08 (frame 10 viewed), the Runge end oscillations reach about 0.58 near x = ±0.96. The sheets for 03, 19 and 24 show the nodes at both ends.

### F5 — Minor — fixed
- Reproduced: in `dump.jl orig`, case 14 with n = 14 has "nodes_outside_ylims 2", at x = ±1.5901 with y = ±51.72. The y-window is (−17.22, 16.86). The committed lagnewt14 frame 9 shows 12 red nodes. The review gave x as ±1.5903; the script's value is ±1.5901.
- Change: render_case now builds the y-limits from the node values of every frame (`ys_all`), not just the 2- and 16-node sets. With the node span [−3, 3] (see F4), the largest |tan| at any node of any frame is 22.41 (`tan_span.py` and `ledger_checks.py`), against 51.72 on the old span. The y-window becomes (−27.79, 27.79).
- Check: `dump.jl new` gives nodes_outside_ylims 0 in all 290 frames. New lagnewt14 frame 9 (full size) shows 14 nodes, including (∓1.6154, ±22.41). No case text was added for tan. The finding's optional "what the reader should see" was not done, because it would be new content.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:12 | "evaluate it in the first barycentric form, $P_n(x)=\ell(x)\sum w_i y_i/(x-x_i)$, $\ell=\prod(x-x_j)$, $w_i=1/\prod_{j\ne i}(x_i-x_j)$" | script `barycentric_weights` and `barycentric_eval` (new) compute exactly these | yes |
| index.qmd:12 | "This is the same interpolant" | ledger_checks.py → "first form - Lagrange form simplifies to: 0" (symbolic, 4 nodes) | yes |
| index.qmd:12 | "stays accurate far outside the nodes" | rawrel.py new → max relative error 1.69e-07 over all 290 frames × 1000 points, including x up to 22 with nodes in [0.5, 4]. No wrong-sign points | yes |
| index.qmd:12 | "second barycentric form … gives values of the wrong sign in Cases 04 and 29" | rawrel.py newsecond → wrong-sign points only in 29 (n=16: 151, n=14: 2) and 04 (n=14: 4, n=16: 1) | yes |
| index.qmd:21 | "nodes are equally spaced from $a$ to $b$, endpoints included" | dump.jl new → inset (0.0, 0.0) in all 290 frames. indep.py new → nodes = a+k(b−a)/(n−1) to 1.4e-15 | yes |
| index.qmd:21 | "Cases 04–06, 08–11, 14, 19 and 24–29" have a window wider than [a, b] | gen_cases.py → wider list ['04','05','06','08','09','10','11','14','19','24','25','26','27','28','29'] | yes |
| index.qmd:21 | "the curve beyond the nodes is extrapolation" | definition: those x lie outside [x₀, xₙ] = [a, b] | yes |
| index.qmd:25 | degrees "1, 2, 3, 4, 5, 7, 9, 11, 13 and 15", nodes "2, 3, 4, 5, 6, 8, 10, 12, 14 and 16" | script `n_nodes_seq`. Title "degree $(n_nodes - 1)". 10 frames in each of the 29 GIFs | yes |
| index.qmd:25 | "for a fixed function and node interval" | one `case.f` and one `resolved_span` per GIF (dump.jl: one span per case) | yes |
| index.qmd:25 | "Where a curve leaves the plot window, it is drawn along the window's top or bottom edge" | script: `clamp.(yinterp, ylims…)` and `ytrue_clip = clamp(…)`. Frames lagnewt04/010 and lagnewt29/009 and 010 show the edge runs | yes |
| headings 01–29 | function and "nodes on [a, b]" for each case (01 [−1.6, 0.9]; 02 [−0.9, 1.6]; 03 [−1.6, 0.9]; 04 [0, 2]; 05 [0, 8]; 06 [0, 10]; 07 [−1.6, 0.9]; 08 [−1, 1]; 09 [0.02, 2]; 10 [0.02, 4]; 11 [−0.98, 1]; 12, 13 [−3π, 3π]; 14 [−3, 3]; 15 [−2, 3]; 16 [−2, 4]; 17 [−4, 4]; 18 [−2.2, 2.2]; 19 [−1, 1]; 20, 21 [−10.2, 10.2]; 22, 23 [−3, 3]; 24 [0.05, 2]; 25 [0.05, 4]; 26 [0.5, 5]; 27 [0.5, 20]; 28 [0.5, 10]; 29 [0.5, 4]) | gen_cases.py → "all intervals match script: True" (tolerance 1e-12 against the dumped spans) | yes |
| headings 01–29 | function formulas ($1/(1-x)$, …, $\ln x$, $e^{-x}\cos x$, $J_0$, $J_1$, $e^{-x^2/2}/\sqrt{2\pi}$, $\tfrac12(1+\operatorname{erf}(x/\sqrt2))$, $\Gamma$, $Y_0$) | script labels printed by gen_cases.py match one for one. indep.py: script node values = mpmath f to 6.6e-15. ledger_checks.py: npdf and ncdf identities | yes |
| alt texts 01–29 | "… through equally spaced nodes on [a, b], degree rising from 1 to 15, drawn with f on [window]" or "on the same interval" | gen_cases.py (window = script `xlims`, checked to 1e-12). Degree sequence as in index.qmd:25 | yes |
| lagnewt_animations_all.jl, case 14 comment | "5 equally spaced nodes on [-pi, pi] would land on the poles at +-pi/2" | ledger_checks.py → nodes [−3.14159265, −1.57079633, 0, 1.57079633, 3.14159265] | yes |
| lagnewt_animations_all.jl, resolved_span comment | "a listed node span is used as given (f is finite at both of its ends)" | ledger_checks.py → f finite at both ends of all 19 listed spans | yes |
| lagnewt_animations_all.jl, equal_nodes comment | "endpoints included. Only if f is not finite at some node are the nodes moved inside" | code. dump.jl new → inset 0 everywhere | yes |
| lagnewt_animations_all.jl, eval comment | "second form (num/den) loses all accuracy far outside the nodes, where its denominator cancels" | rawrel.py orig → relative error 4.54e3, 129, 40.6 with wrong signs. newsecond → wrong signs in 04 and 29 | yes |
| lagnewt_animations_all.jl, ylims comment | "Include the node values of every frame so that every node is drawn" | dump.jl new → nodes_outside_ylims 0 in all 290 frames | yes |

## Scripts and GIFs
- Script changed: `lagnewt_animations_all.jl`, with an identical copy in the Newton folder (`cmp` silent). The changes:
  - first-form evaluator (F2);
  - no node inset, and listed spans used as given (F4);
  - Case 14 span [−3, 3] and Case 19 span [−1, 1] (F4/F5);
  - y-limits from the nodes of every frame (F5).
- GIFs regenerated with `julia lagnewt_animations_all.jl` in both page folders. All 29 change, which is expected, because every case's nodes moved (the 3% inset is gone). The repo GIFs in both folders are byte-identical to a scratch run of the same script (29 of 29 checked with `cmp`).
- Frames viewed at full size:
  - 04/010: no bars, nodes from 0 to 2;
  - 29/009 and 29/010: no bars;
  - 14/009: 14 nodes, all inside the window;
  - 08/010: Runge end oscillations;
  - 01/001: nodes at −1.6 and 0.9.
- Sheets viewed for 03, 19 and 24, plus the last-frame montage of all 29 (`new_frames/last_all.png`). In every frame the titles read "Interpolation Case NN: f(x) = <label>, degree d", the red nodes lie on f, and the blue curve passes through them.
- Cosmetic: where a node interval equals the plot window (01–03, 07, 12, 13, 15–18, 20–23), the end nodes sit on the frame border and are drawn as half markers. They are still visible, so this was left as it is. (Superseded: fixed in Round 2 below with a 2% x-margin.)
- `git status --short` for the two page folders after regeneration: ` M` on both `index.qmd` files, on both `lagnewt_animations_all.jl` files, and on `lagnewt01.gif` … `lagnewt29.gif` in each folder (58 GIFs). Nothing else changed.

## Legacy archive
Consulted:
- `n2003/LagrangePolyMod.html`, whose Animations link points to `/a2001/Animations/Interpolation/Lagrange/Lagrange.html`.
- That page itself, which lists the 29 "Lagrange & Newton Polynomial" cases.
- Its formula images, viewed as the montage `archive/formulas.png`.
- The animations that are present: `Lagrange01/Lagrangeaa.gif` (34 frames) and `Lagrange04/Lagrangedd.gif` (29 frames). `Lagrange09/Lagrangeii.gif` (34831 bytes) could not be decoded by ffmpeg. The other case folders hold only HTML.

What it showed:
- **Functions and windows.** The 29 functions and their order match the script. The windows match too, except Cases 01, 03 and 07 (archive −1.6 ≤ x ≤ 1.5; script −1.6 to 0.9) and Case 02 (archive −1.5 ≤ x ≤ 1.6; script −0.9 to 1.6). Those windows were not changed, because no finding concerns them.
- **Node intervals.** The archive's "equally spaced nodes in [a, b]" notes (04 [0, 2], 05 [0, 8], 06 [0, 10], 08 [−1, 1], 09 [0.02, 2], 10 [0.02, 4], 11 [−0.98, 1], 24 [0.05, 2], 25 [0.05, 4], 26 [0.5, 5], 27 [0.5, 20], 28 [0.5, 10], 29 [0.5, 4]) match the script's spans.
- **Endpoints.** In Mathews' own animations the end nodes sit on the endpoints: Lagrangedd (√x) has nodes at x = 0 and x = 2, and Lagrangeaa has its last node at x = 0.9. This agrees with the F4 fix (no inset).
- **Degrees.** His frames are labelled S₂ … S₂₀ and S₂ … S₂₅, and also add a "Tolerance ±0.05" convergence-region bar, which the site's animations do not have.
- **Cases 14 and 19.** Mathews gives no node interval for Case 14 (tan) or Case 19 (asin). The spans [−3, 3] and [−1, 1] are this fix's choice. For tan, [−π, π] would put nodes on the poles.

## Notes
- **Orphan files (D3).** `lagrangeaa.jl` was not touched; the director handles it.
- **Choice of evaluator.** The first barycentric form was chosen over Newton divided differences. It is the smallest change, it keeps the Lagrange page's description true, and both round-1 reviews accept it. The Newton page text was adjusted to say so (Newton F3).
- **Leftover code.** `render_case` still computes the unused `w_lo`, `y_lo`, `w_hi` and `y_hi`. This was pre-existing dead code and was left alone.
- **Convention gaps.** The case headings use the form "Case NN: f, nodes on [a, b]" without a behaviour label or a **Behavior:** paragraph. Adding behaviour text for 29 cases would be new content, so it was left out.

## Round 2 after check

The independent resolution check found Lagrange F1–F5 resolved. It raised two new Minor items, both caused by the endpoint-inclusive nodes. Round-2 evidence is in `round2/` of the scratch folder: `degenerate.py`, `sincos.py` with `sincos_out.txt`, `frames/` with the montage `last_all.png`, and `script/`.

### R2-1 — Minor — fixed (text): Cases 12 and 13 show constant interpolants in early frames
- Reproduced: `sincos.py` gives the following.
  - Case 12 (sin): with 2, 3 and 4 nodes, x/π = [−3, 3], [−3, 0, 3] and [−3, −1, 1, 3], all multiples of π. The plotted interpolant differs from 0 by at most 3.67e-16 in those frames. With 5 and 6 nodes the nodes are not multiples of π (x/π = −1.5, −1.8, …), and the curve departs from 0 by 1.03 and 1.61.
  - Case 13 (cos): with 2 and 4 nodes every node is an odd multiple of π. The plotted interpolant differs from −1 by at most 2.22e-16 and 5.55e-16. With 3 nodes (−3π, 0, 3π) it does not, because cos 0 = 1 and the curve is a parabola (max deviation from −1 is 2).
  - Within the frame sequence, all nodes are multiples of π only for n = 2, 3, 4, since x/π = −3 + 6k/(n−1) is an integer for all k only when (n−1) divides 6, and 7 is not in `n_nodes_seq`.
  - Sheet `round2/frames/lagnewt12/sheet.png` (frames 1–3 show the flat line) and lagnewt13 frame 4 were viewed.
- Choice: text, not a new node interval. Mathews lists both cases on −3π ≤ x ≤ 3π with no separate node interval, and endpoint-inclusive nodes there are what the case is. The flat frames are correct mathematics: aliasing of a periodic function sampled at its zeros or extrema. A sentence explaining them is the smallest correct change. Moving the interval would need a new, unfaithful interval.
- Change in index.qmd:
  - Case 12: added "With 2, 3 and 4 nodes every node is a multiple of $\pi$, where $\sin x = 0$, so the frames titled degree 1, 2 and 3 all show the line $y = 0$." The alt text gains "; at degrees 1, 2 and 3 every node is a multiple of π, so the interpolant is the line y = 0".
  - Case 13: added "With 2 and 4 nodes every node is an odd multiple of $\pi$, where $\cos x = -1$, so the frames titled degree 1 and 3 show the line $y = -1$." The alt text gains "; at degrees 1 and 3 every node is an odd multiple of π, so the interpolant is the line y = −1".
- Other cases: `degenerate.py new` also lists frames whose true degree is below the nominal one, for example even functions on symmetric nodes (08, 13, 17, 20, 22) and odd functions with 3 nodes. Running it on the old script (`degenerate.py orig`) lists the same kinds of frames, so they are not caused by this fix. They were not raised and are left unchanged.

### R2-2 — Minor (cosmetic) — fixed: half-markers at the window edge
- Reproduced: in the round-1 regenerated frames, the end nodes of cases whose node interval equals the plot window were cut by the frame border. Seen in lagnewt01 frame 1 and in the last-frame montage.
- Change: in `lagnewt_animations_all.jl` render_case, `xpad = 0.02 * (case.xlims[2] - case.xlims[1])`, and the axis uses `xlims=xaxis = (xlims[1] - xpad, xlims[2] + xpad)`. A one-line comment was added. f and the interpolant are still evaluated only on `case.xlims` (`xplot` is unchanged). A 2% margin is roughly 13 px at this frame width (plot area about 680 px wide), more than the marker radius (ms = 4.5). The frames confirm that the markers are now whole.
- Text consequence: the axis is now always 2% wider than the interval on which f is drawn. index.qmd:21 "Where the plot window is wider than $[a, b]$" → "Where $f$ is drawn on a wider interval than $[a, b]$". The case list is unchanged, and the alt texts' "drawn with f on [window]" stays true because f is drawn on `case.xlims`.
- Check:
  - `julia dump.jl new` after the change produces a `dump.txt` byte-identical to the one before (`cmp` silent). Nodes, y-limits and plotted values are therefore unchanged, and all round-1 numeric checks (indep.py, rawrel.py, err.py) still apply.
  - Montage `round2/frames/last_all.png`: every end node is now a full marker, for example 01 at x = −1.6 and 0.9, 12 and 13 at ±3π, and 17 at ±4.
  - lagnewt13 frame 4 at full size: whole end markers, with f drawn to ±3π only.

### Round-2 ledger

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:21 | "Where $f$ is drawn on a wider interval than $[a, b]$ (Cases 04–06, 08–11, 14, 19 and 24–29)" | f is drawn on `xplot = range(case.xlims…)`. gen_cases.py → windows wider than node span exactly in that list | yes |
| index.qmd:75 | "With 2, 3 and 4 nodes every node is a multiple of $\pi$, where $\sin x = 0$" | sincos_out.txt → x/π = [−3,3], [−3,0,3], [−3,−1,1,3], all multiples of π = True | yes |
| index.qmd:75 | "the frames titled degree 1, 2 and 3 all show the line $y = 0$" | sincos_out.txt → max\|plotted − 0\| = 3.67e-16 for n = 2, 3, 4. Sheet frames 1–3 viewed | yes |
| index.qmd:77 alt | "at degrees 1, 2 and 3 every node is a multiple of π, so the interpolant is the line y = 0" | as above | yes |
| index.qmd:81 | "With 2 and 4 nodes every node is an odd multiple of $\pi$, where $\cos x = -1$" | sincos_out.txt → n = 2: [−3, 3], n = 4: [−3, −1, 1, 3], all odd = True | yes |
| index.qmd:81 | "the frames titled degree 1 and 3 show the line $y = -1$" | sincos_out.txt → max\|plotted + 1\| = 2.22e-16 (n = 2), 5.55e-16 (n = 4). n = 3 is not flat (deviation 2) | yes |
| index.qmd:83 alt | "at degrees 1 and 3 every node is an odd multiple of π, so the interpolant is the line y = −1" | as above | yes |
| lagnewt_animations_all.jl comment | "Small x-margin so that nodes at the ends of the window are drawn whole" | montage last_all.png. lagnewt13 frame 4 | yes |

### Round-2 scripts, GIFs and status
- The script was edited in the Lagrange folder and copied to the Newton folder (`cmp` silent). Both folders were regenerated with `julia lagnewt_animations_all.jl`. All 29 GIFs are byte-identical across the two folders, and every GIF has 10 frames.
- `git status --short` for the two page folders: ` M` on both `index.qmd` files, on both `lagnewt_animations_all.jl` files, and on 58 `lagnewt*.gif`. Nothing else changed. `lagrangeaa.jl`, `newtpolyaa.*` and `newtpolybb.*` are untouched.

## Resolution check (independent checker, not shown this record)

Scratch work: `check/run/` (regenerated GIFs), `check/instr.jl` + `check/instr_out.txt` (290-frame audit against a 512-bit Newton divided-difference reference on the same Float64 data), `check/sign2.jl` (second-form sign check on the new nodes), `check/frames/lagnewtNN/` (all 29 current GIFs, every frame + sheet), `check/old/` (pre-fix 04, 08, 14, 19, 29 from the local LFS object store).

### Original findings

### Lagrange F1: resolved
- Old line 25 is gone. The new sentence says the degree goes 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 on 2, 3, 4, 5, 6, 8, 10, 12, 14, 16 nodes. That matches `n_nodes_seq` (script line 158). All 29 GIFs have 10 frames, and the frame titles read degree 1…5, 7, 9, 11, 13, 15 (sheets for 01, 04, 09, 12, 13, 14, 19, 24, 27, 29).

### Lagrange F2: resolved
- `barycentric_eval` now uses the first form `l(x)·Σ w_j y_j/(x−x_j)` (lines 120–129).
- Audit of all 290 (case, degree) frames against a 512-bit divided-difference reference, both clamped to the frame's ylims: the worst difference is 8.7e-10 of the y-range (case 29, n=16), there are 0 points off by more than 1e-6, and the worst unclamped relative error is 6.6e-8. The first form gives 0 wrong-sign points in 04 (n=14, 16) and in 29 (n=14, 16).
- Frames: in lagnewt04 frame 10 and lagnewt29 frame 10 the interpolant rises once and runs along the top edge, with no vertical bars. Pre-fix lagnewt04 frame 10 had bars at x≈5.7 and 9.6–10.4.
- The old line 12 claim ("numerically stable") is replaced. See the ledger for the new claim about the second form.

### Lagrange F3: resolved
- Each heading now gives the function and the node interval, and each alt text names the function, the interval, the degree range and the plot window. Every interval and window matches the script table and `resolved_span` (printed spans in `instr_out.txt`). Line 21 now states the node placement.

### Lagrange F4: resolved
- `equal_nodes` now uses trim = 0 on the first attempt, so nodes run from a to b with both endpoints included. The retry never fires: in all 290 frames `xs[1]==a` and `xs[end]==b`, with second differences ≤ 4.4e-16.
- √x now has a node at x = 0 (frame 10 of case 04: the red node sits at (0, 0)).
- Case 08 nodes are on [−1, 1]. Frame 10 shows Runge spikes to ≈0.58 near x = ±0.97, where f ≈ 0.096, an error of ≈0.485, as expected.
- `resolved_span` now uses the listed span as given.

### Lagrange F5: resolved
- ynode now gathers node values from every frame (line 172).
- Case 14 moved to nodes on [−3, 3]. ylims are (−27.79, 27.79). The largest node value is ±22.41 (n=14). nodesOut = 0 in all 290 frames.
- lagnewt14 frame 9 (degree 13) shows all 14 nodes, including (−1.615, 22.4) and (1.615, −22.4). Pre-fix frame 9 showed 12.
- The optional suggestion (say on the page what tan is meant to show) was not done. That is acceptable for a Minor finding.

### Newton F1: resolved
- The fix is the same as Lagrange F2 (byte-identical script and GIFs), with the same evidence. The bars are gone in lagnewt04 frame 10 and lagnewt29 frames 9 and 10.

### Newton F2: resolved
- New line 24: "2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 equally spaced nodes (degree 1 to 5, then 7, 9, 11, 13 and 15) … with nodes at both ends of the interval". This is true. All 290 frames have both endpoints as nodes.

### Newton F3: resolved
- New line 26 says the shared script evaluates the same polynomial in the first barycentric (Lagrange) form, not by divided differences. That is true of the script. "Same polynomial" is verified: it agrees with the divided-difference reference to ≤8.7e-10 of the y-range. "A divided-difference example is to be added" is a promise, not a claim.

### Newton F4: not resolved (out of scope: D3)
- The diff does not touch `newtpolybb.jl` or `newtpolybb.gif`, and both are still on disk.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| L index:12 | first form P_n = ℓ(x)Σ w_i y_i/(x−x_i), ℓ = Π(x−x_j), w_i = 1/Π_{j≠i}(x_i−x_j) | Matches the script lines 101–129 and the standard identity. Agrees with the 512-bit reference in all frames. | true |
| L index:12 | "stays accurate far outside the nodes" | Worst relative error 6.6e-8 over all frames, including case 29 out to x = 22 | true |
| L index:12 | second form "gives values of the wrong sign in Cases 04 and 29" | With the current nodes, the second form gives the wrong sign at 4 and 1 points (case 04, n=14 and 16, x ≈ 9.5–10.4) and at 2 and 151 points (case 29, n=14 and 16, x ≈ 11.7–20). No other case fails (`instr_out.txt`, `sign2.jl`). | true |
| L index:21 | nodes equally spaced from a to b, endpoints included | All 290 frames | true |
| L index:21 | window wider than [a,b] in Cases 04–06, 08–11, 14, 19, 24–29 | Compared xlims with span for all 29. The list is exact; the other cases have the window equal to the span. | true |
| L index:25 | degrees 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 / nodes 2 … 16 | Script line 158 and frame titles | true |
| L index:25 | off-window curve drawn along the top or bottom edge | `clamp` on both curves (lines 182, 189). Seen in 04, 24 and 29 frames. | true |
| L headings 01–29 | function and interval, e.g. 01 1/(1−x) [−1.6,0.9]; 04 √x [0,2]; 05 [0,8]; 06 [0,10]; 08 [−1,1]; 09 ln x [0.02,2]; 10 [0.02,4]; 11 ln(1+x) [−0.98,1]; 12/13 [−3π,3π]; 14 tan [−3,3]; 15 eˣ [−2,3]; 16 e⁻ˣcos x [−2,4]; 17 cosh [−4,4]; 18 arctan [−2.2,2.2]; 19 arcsin [−1,1]; 20/21 J₀/J₁ [−10.2,10.2]; 22 normal pdf [−3,3]; 23 ½(1+erf(x/√2)) [−3,3]; 24–26 Γ [0.05,2], [0.05,4], [0.5,5]; 27–29 Y₀ [0.5,20], [0.5,10], [0.5,4] | Each compared with the script lambdas and with `resolved_span` as printed by the audit | all true |
| L alt texts 01–29 | "degree rising from 1 to 15", window "[0,10.5]", "[−1.5,1.5]", "[−0.5,4.1]", "[−π,π]", "[−0.2,5.2]", "[0,22]", "the same interval" | Compared with xlims for every case. f is drawn where finite (log, asin and Γ are not drawn outside their domains). | true |
| N index:20 | Lagrange page gives each case's function and node interval; link `../lagrange-…/index.qmd` | It does. The link style matches another page (`../nonlinear-systems/index.qmd`). | true |
| N index:24 | node counts, degrees, nodes at both ends | As above | true |
| N index:26 | first barycentric (Lagrange) form, not divided differences | Script lines 120–129 | true |
| script:36–38 | 5 equally spaced nodes on [−π,π] land on ±π/2 | −π + kπ/2, k = 0…4, includes ±π/2 | true |
| script:76–79, 86–88 | span used as given; trim only if f is non-finite at a node | The code does this; the retry never fires | true |

### New problems

1. **Minor.** Cases 12 and 13 now open with degenerate frames that the page does not explain.
   - Location: lagnewt12.gif frames 1–3 and lagnewt13.gif frames 1 and 3.
   - Cause: with endpoints included, the 2-, 3- and 4-node sets on [−3π, 3π] fall on multiples of π.
     - sin is 0 at every one of those nodes, so the "degree 1, 2, 3" frames of case 12 all show the same flat line y = 0.
     - cos is −1 at the 2- and 4-node sets, so the "degree 1" and "degree 3" frames of case 13 show y = −1.
   - The mathematics is correct (the page says "degree at most n"). But the first three frames of case 12 are identical and labelled degree 1/2/3. The pre-fix inset nodes avoided this.
   - A sentence in the case text, or a different span, would fix it.
2. **Minor (cosmetic).** In the cases where the node interval equals the plot window (01–03, 07, 12, 13, 15–18, 20–23), the two end nodes now sit on the plot frame and are drawn as half-markers. Example: lagnewt01 node at (0.9, 10). They are still visible.

Pre-existing and not introduced by this fix: the Newton page's 29 alt texts still read "Newton interpolation animation for case NN from the legacy function-and-interval list". These are not descriptive by the convention at animation-page.agent.md:203. Line 20 now points to the Lagrange page for the list, which softens this. The orphan files `lagrangeaa.jl`, `newtpolyaa.*` and `newtpolybb.*` remain from the inventory.

Nothing else found. This rests on:
- the 290-frame clamped comparison against the high-precision reference;
- the endpoint and node-visibility audit;
- full-size views of frames 9 and 10 of 04, 08, 14, 19 and 29, and the pre-fix 04 and 14;
- contact sheets of 01, 04, 09, 12, 13, 14, 19, 24, 27 and 29.

### Reproducibility and conventions

- Both script copies are byte-identical (`cmp`).
- A scratch run (22 s) reproduces all 29 GIFs byte for byte against both the Lagrange folder (29/29) and the Newton folder (29/29). The two folders' GIFs are also identical to each other.
- Both pages keep the conventions: Description, then Animations, then Derivation Notes; one source link; 29 embeds of 29 distinct GIFs; no code fences. The Lagrange alt texts are now descriptive.
- Files outside the two page folders: the working tree has modifications in other pages (pade, romberg, monte-carlo-pi and others), but none of them appears in this fix's diff. They belong to other pages' fixes. The diff itself touches only the two folders.

### Re-check

This re-check covers the fixer's second pass: Case 12/13 sentences and alt text, a 2% x-margin, and one reworded intro line. Scratch work for it is in `check/run2/`, `check/frames2/`, `check/flat.jl` and `check/instr_out2.txt`.

### New problem 1 (flat low-degree frames in Cases 12/13): resolved
- **Case 12 sentence and alt text: true.** I computed the nodes myself (`flat.jl`):
  - the 2-, 3- and 4-node sets are {±3π}, {−3π, 0, 3π} and {±3π, ±π};
  - all of these are multiples of π;
  - the interpolant satisfies max|P| = 3.7e-16 over the window in each of those frames, so it is the line y = 0 to rounding;
  - with 5 nodes (±1.5π added), max|P| = 1.03, so the flat frames stop exactly at degree 3.
- **Case 13 sentence and alt text: true.**
  - With 2 and 4 nodes, every node is an odd multiple of π and cos = −1 there; max|P+1| is 2.2e-16 and 5.6e-16.
  - The 3-node set includes 0, where cos = 1, so the degree-2 frame is a parabola. That matches the sentence, which does not claim degree 2.
- **Frames.** Viewed at full size: lagnewt12 frames 1 and 3, a flat blue line at y = 0 through 2 and 4 red nodes. Contact sheet of lagnewt13: frames 1 and 3 are flat at −1, frame 2 is a parabola through (0, 1).
- **Node interval.** Kept at [−3π, 3π]. The heading still matches `resolved_span`.

### New problem 2 (half-drawn end markers): resolved
- **What changed.** The script now sets `xlims = case.xlims ± 0.02·width` (lines 183–185, 195). Only the axis changed: xplot, the nodes, ylims and every plotted value are unchanged.
  - The 290-frame audit gives output identical to the first check, apart from the secondForm column, which I did not compare: all nodes at both endpoints, nodesOut = 0, and the worst clamped difference from the 512-bit reference is 8.7e-10 of the y-range.
- **Frames.** Viewed at full size: lagnewt01 frame 10 (end nodes at x = −1.6 and 0.9), lagnewt20 frame 5 (±10.2), lagnewt12 frames 1 and 3 (±3π) and lagnewt04 frame 10 (node at x = 0). All end markers are drawn whole.
- **Side effect.** The curves stop at the case window and leave a thin blank strip at each side. In 04 and 29 the clamped top-edge segment stops at x = 10.5 and x = 22. Harmless.

### Reworded intro line: true
- New wording (L index:21): "Where $f$ is drawn on a wider interval than $[a, b]$ (Cases 04–06, 08–11, 14, 19 and 24–29)".
- f is drawn on xplot = case.xlims. For exactly these cases, xlims strictly contains the span, as in the earlier ledger check. The wording is now independent of the padded axis, so it stays accurate.

### Previous verdicts still hold
- Lagrange F1–F5 resolved; Newton F1–F3 resolved; Newton F4 not resolved (out of scope: D3).
- I checked again:
  - lagnewt04 frame 10 and lagnewt29 frame 10: no bars, the curve runs along the top edge;
  - lagnewt14 frame 9: all 14 nodes visible;
  - headings, ledger rows and the Newton text: unchanged apart from the items above.

### Reproducibility and conventions
- Both script copies are byte-identical.
- A scratch run of the current script reproduces 29/29 GIFs byte for byte in the Lagrange folder and 29/29 in the Newton folder.
- Both pages: Description, then Animations; one source link; 29 embeds; no code fences.
- The new case sentences are prose between the heading and the embed, which is fine.
- The diff touches only the two page folders.

### New problems
- None.
- What this rests on:
  - the node and interpolant computation for 12/13;
  - the unchanged 290-frame audit;
  - full-size views of 01, 04, 12 (frames 1 and 3), 14, 20 and 29;
  - the 13 contact sheet.
- Still pre-existing and outside this fix: the Newton page's alt texts read "…from the legacy function-and-interval list", including Cases 12 and 13, which carry no note there. The Newton page points readers to the Lagrange page for the case details.

**Final status:** committed
