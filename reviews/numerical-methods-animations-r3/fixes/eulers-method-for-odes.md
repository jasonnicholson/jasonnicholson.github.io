# Fix record: eulers-method-for-odes

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/eulers-method-for-odes/fix/` (`$FIX` below). Scripts: `indep.py` (independent Python Euler and midpoint against DOP853 dense output, rtol 1e-13), `f2.py` (midpoint tails), `sign.py` (sign and place of the largest error, refinement ratios), `damp.py` (error at t = 3, 4, 5), `instr_aa.jl` / `instr_bb.jl` (the edited scripts with the plotting replaced by printing the label values). Saved outputs: `*.out`.

## Findings

### F1 — Misleading — fixed
- Reproduced: `/usr/bin/python3 -I $FIX/indep.py` gives, at every node t_i = 5i/m, the error y_i − y(t_i) against DOP853:
  - Euler: e(5) = −4.223e-06 / −2.137e-06 / −1.715e-06 at m = 60 / 120 / 150, while max|e| = 5.698e-02 / 2.816e-02 / 2.247e-02, at t = 1.667 each. The ratio max|e| / |e(5)| is 3.26e3 at m = 50 and 1.31e4–1.48e4 for every m from 55 to 150.
  - Midpoint: max|e| = |e(5)| for m = 16 to 70. For m = 80, 90, 100, 120, 150 the ratio is 2.49, 8.91, 20.6, 49.8, 87.4, and the maximum lies at t = 3.188–3.222 (6.275e-04 at m = 80, 1.589e-04 at m = 150). For m = 12 and 14 the maximum is at t = 4.58 and 4.64 (ratio 7.5 and 6.6).
  - At m = 150 the Euler and midpoint e(5) are −1.7152e-06 and +1.8185e-06, while the max errors are 2.247e-02 and 1.589e-04 (ratio 141.4, `sign.py`).
  - This matches the review and the checker's correction.
- Change:
  - Both scripts: added `refnodes(m)`, the reference at the run's own nodes (RK4 with k = cld(50000, m) substeps per node). Per frame, `err = ys .- refnodes(m)`. Labels: `error = %+.1e` → `error at t = 5: %+.1e`, plus a new line `max |error| = %.1e at t = %.2f`. The text block moved up (y = 0.73, 0.61, 0.49, 0.38, 0.27) to fit the extra line.
  - `index.qmd` intro: "labelled with the computed y(5) and its error" → "…y(5), its error at t=5 and the largest error at any grid point of the run".
  - Case 1 Behavior: the y(5)-error sentence is replaced. It now says the error at t = 5 is small (−4.2e-6 at m = 60, −1.7e-6 at m = 150) but does not measure accuracy: it is damped by the strongly negative ∂f/∂y and is more than 10⁴ times smaller than the largest error from m = 55 on. The largest error (t = 1.64–1.73 for m = 45–150, run above the reference) falls at every refinement and about halves when m doubles: 5.7e-2, 2.8e-2, 2.2e-2 at m = 60, 120, 150.
  - Case 2 Behavior: added that for m = 16–70 the error at t = 5 is the largest error, but from m = 80 it is 2.5–87 times smaller than the largest error at t = 3.19–3.22 (6.3e-4 at m = 80, 1.6e-4 at m = 150). From m = 80 to 150 the largest error falls by 3.9, close to (150/80)² ≈ 3.5, while Euler's falls by 1.9 ≈ 150/80. At m = 150 it is about 140 times smaller than Euler's 2.2e-2, although the errors at t = 5 are about the same size. "error in y(5)" → "error at t=5".
  - Both alt texts: one sentence added giving the two m = 150 label values.
- Check:
  - `julia $FIX/instr_aa.jl` and `julia $FIX/instr_bb.jl` print the label values for all 41 frames. Each agrees with `indep.py` to all 4 printed significant figures and in location, for example Euler m = 150: e5 −1.7152e-06, max 2.2473e-02 at t = 1.67; midpoint m = 150: +1.8185e-06, max 1.5891e-04 at t = 3.20. `|refnodes(m)[end] − yex5|` ≤ 1.4e-17.
  - New frames viewed (see below).

### F2 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I $FIX/f2.py`.
  - m = 24: last six values 0.0858, 0.1241, 0.1300, 0.1992, 0.1237, 0.6127; last steps +0.0692, −0.0755, +0.4889; the only negative step after the minimum is at t = 4.583, so after the minimum just the last three steps alternate.
  - m = 28: last steps +0.0276, −0.0075, +0.2587; the one negative step after the minimum is at t = 4.643 (the second-to-last step). Rise from minimum 0.3501, y(5) = 0.3841123.
  - m = 32 to 70: no negative step after the minimum (one sign change after the peak).
  - Legacy MEuleraa frame for m = 24 (`$FIX/legacy_mb/frame_014.png`) shows the same final zig-zag.
- Change:
  - `index.qmd` Case 2: "For m=12 to 20 the tail zig-zags. For m=24 to 60 … by 0.57 at m=24 … ending at y(5)≈0.613, 0.0761 … and 0.0259" → "For m=12 to 24 the tail zig-zags; at m=24 only the last three steps alternate (+0.069, −0.076, +0.489), ending at y(5)≈0.613. For m=28 to 60 the curve turns upward … (at m=28 with one small dip of 0.0075 in the second-to-last step), rising from its minimum by 0.35 at m=28, 0.057 at m=40 and 0.015 at m=60 … ending at y(5)≈0.384, 0.0761 … and 0.0259".
  - Alt text: "m = 12 to 24 … zig-zags (at m = 24 only in the last three steps), and for m = 28 to 60 it turns upward".
- Check: the numbers are from `f2.out`. The new frame 7 (m = 28) shows the small kink near t = 4.8 and then the jump, so the text says "small dip" and makes no claim about whether it can be seen.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Intro | labels: y(5), error at t=5, largest error at any grid point | scripts' annotate lines 94–96 (aa) / 97–99 (bb); frames show the three lines | yes |
| Case 1 | error at t=5 −4.2e-6 (m=60), −1.7e-6 (m=150), y(5)≈0.0081182 | indep.out: −4.223e-06, −1.715e-06, 0.0081182 | yes |
| Case 1 | ∂f/∂y strongly negative late in the run | damp.out: f_y along reference −8.54 (t=3.2), −20.79 (t=4), −41.26 (t=5); errors at t=3,4,5 for m=150: 1.64e-3, 1.27e-5, 1.72e-6 | yes (mechanism is the standard linearised one, also the checker's) |
| Case 1 | from m=55, error at t=5 more than 10⁴ times smaller than max | indep.out ratio: 1.48e4 (55) … 1.31e4 (150); 3.26e3 at m=50 | yes |
| Case 1 | max error for m=45–150 between t=1.64 and 1.73, run above reference | sign.out: t = 1.643–1.727, e_max > 0 for all 13 m | yes |
| Case 1 | falls at every refinement in the sweep | indep.out: "falls" for all 19 refinements m=10→150 | yes |
| Case 1 | about halves when m doubles | 60→120: 5.698/2.816 = 2.02; 50→100: 2.03; 70→140: 2.02 | yes |
| Case 1 | 5.7e-2 (60), 2.8e-2 (120), 2.2e-2 (150) | indep.out 5.698e-02, 2.816e-02, 2.247e-02; instr.out identical | yes |
| Case 2 | m=12–24 zig-zag; m=24 last three steps +0.069, −0.076, +0.489; y(5)≈0.613 | f2.out: steps 0.0692, −0.0755, 0.4889; y5 0.6126681 | yes |
| Case 2 | m=28–60 turn upward; m=28 dip 0.0075 in second-to-last step | f2.out: m=28 negative step −0.0075 at t=4.643 = 5−2h; no negative step after minimum for m=32–60 | yes |
| Case 2 | rise 0.35 (m=28), 0.057 (40), 0.015 (60); y(5)≈0.384, 0.0761, 0.0259 | f2.out: 0.3501, 0.0572, 0.0150; indep.out 0.3841123, 0.0761463, 0.0259429 | yes |
| Case 2 | error at t=5 falls at every refinement from m=16 (unchanged claim, wording "at t=5") | indep.out abs e5: 14→16 rises, then falls for all later refinements | yes |
| Case 2 | m=16–70 error at t=5 is the largest error | indep.out ratio = 1 for all 16–70 | yes |
| Case 2 | from m=80, 2.5 to 87 times smaller; max at t=3.19–3.22 | indep.out ratios 2.49, 8.91, 20.6, 49.8, 87.4; t 3.188–3.222 | yes |
| Case 2 | 6.3e-4 (m=80), 1.6e-4 (m=150) | indep.out 6.275e-04, 1.589e-04 | yes |
| Case 2 | factor 3.9 vs (150/80)²≈3.5; Euler 1.9 vs 150/80≈1.9 | sign.out: Mid 80/150 3.949, Euler 1.890, 1.875, 3.5156 | yes |
| Case 2 | at m=150 about 140 times smaller than Euler's 2.2e-2; errors at t=5 about the same size | sign.out 141.4; e5 −1.715e-06 vs +1.818e-06 | yes |
| Alt 1 | m=150: −1.7e-06 and 2.2e-02, largest near t = 1.67 | instr.out m=150 | yes |
| Alt 2 | m=12–24 zig-zag (m=24 last three steps), m=28–60 upward | f2.out | yes |
| Alt 2 | m=150: +1.8e-06 and 1.6e-04, largest near t = 3.20 | instr.out m=150 | yes |
| Frame labels | `error at t = 5: %+.1e`, `max |error| = %.1e at t = %.2f` | instr.out all 41 frames = indep.out | yes |

## Scripts and GIFs
- Scripts changed: `eulersmethodaa.jl`, `eulersmethodbb.jl`. The changes are `refnodes`, the per-frame `err` and `imax`, and the label block. Methods, m sequences, window, shading and reference are unchanged.
- GIFs regenerated in place: `eulersmethodaa.gif` (20 frames), `eulersmethodbb.gif` (21 frames). Every frame changes because the label block changed, which is intended.
- Frames viewed at full size:
  - aa frames 1 (m=10) and 20 (m=150);
  - bb frames 7 (m=28) and 21 (m=150);
  - both contact sheets (every second frame).
- Checked in the frames:
  - The five label lines are legible and do not touch the curves or the legend. The longest line ends near t ≈ 2.35, where the curves are above it.
  - The label values agree with `instr.out`: aa m=10 shows max 1.8e+00 at t = 5.00, aa m=40 shows 2.2e-01 at t = 4.88, bb m=80 shows 6.3e-04 at t = 3.19.
  - Titles, shading and the end dot are unchanged.
- `git status --short -- pages/numerical-methods/eulers-method-for-odes`: M eulersmethodaa.gif, M eulersmethodaa.jl, M eulersmethodbb.gif, M eulersmethodbb.jl, M index.qmd.

## Legacy archive
- Consulted: `a2001/Animations/OrdinaryDE/MEuler1/MEuleraa.gif`. The frames were extracted, and the m = 24 frame (frame 14) shows the same last-step zig-zag as our run and prints y(5) = 0.6126681.
- Mathews' frames print only m and y(5), with no error label. The added "error at t = 5" and "max |error|" lines go beyond the archive, as F1 requires. The m sequences, methods and y(5) values are unchanged and still match the archive (round-3 ledger I7/I8).

## Notes
- Case 1 still has the round-2 sentence "From then on each step multiplies the error it inherits by 1+h∂f/∂y<−1, amplifying it with alternating sign instead of damping it". This resembles the wording D2 forbids. It is not a round-3 finding: the reviewer confirmed it as ledger A18 as a statement about the linear error recurrence, and the page then gives the computed consequence per m range. I left it unchanged; Jason may want it reworded.
- The new text attributes the small error at t = 5 to damping from the strongly negative ∂f/∂y. This is the linearised error-recurrence argument. |e| is not monotone after its maximum (`damp.out`), so the page does not claim a monotone decay.
- The page was not rendered with Quarto.

## Resolution check (independent checker, not shown this record)

Independent reference: `check/indep.py`. It uses scipy DOP853 dense output (rtol 1e-13, atol 1e-16) and its own Euler and midpoint loops, then compares every grid node. Reference y(5) = 0.0081199205; the peak is 1.449767 at t = 0.8836. Script values: `check/instr/{aa,bb}.jl` are scratch copies of the scripts with one added printf line. All values agree with indep.py to the printed precision.

### Original findings
### F1 — resolved
- Evidence: each frame now prints "error at t = 5" and "max |error| = … at t = …". The max is taken over all nodes against RK4 reference values at the nodes, with m·cld(50000,m) steps. Every printed value in both sweeps matches DOP853 to 4 significant figures and 2 decimals in t. Examples: Euler m=150 gives 2.247e-2 at 1.667 (script and indep); midpoint m=150 gives 1.589e-4 at 3.200; midpoint m=80 gives 6.275e-4 at 3.188.
- The page text now says that the t=5 error does not measure the run's accuracy. It explains why with the strong negative ∂f/∂y. I checked the damping: ∫ ∂f/∂y dt from 1.667 to 5 along the reference is −45.6. The text quotes the maximum errors. It shows the convergence orders with measured ratios: Euler 80→150 gives 1.89 and 60→120 gives 2.02; midpoint 80→150 gives 3.95. Midpoint is about 141 times better than Euler at m=150. The O(h²) Description claim is now visible in the numbers.
- In the frames, Euler m=150 (frame 20) shows "error at t = 5: -1.7e-06" and "max |error| = 2.2e-02 at t = 1.67". The visible gap near the peak is now explained.
### F2 — resolved
- Evidence: the m=24 midpoint steps before the end are …, +0.0329, +0.0383, +0.0059, +0.0692, −0.0755, +0.4889. The only sign alternation is in the last three steps, as the page says ("+0.069, −0.076, +0.489"). m=28 ends +0.0276, −0.0075, +0.2587. The page now puts m=28 with the upturn runs and names "one small dip of 0.0075 in the second-to-last step". That matches the reviewer's suggestion and is accurate.
- From m=32 to 60 the steps after the peak change sign exactly once, so they rise smoothly. m=28's rise from its minimum is 0.3501, quoted as 0.35. y(5) at m=28 is 0.3841123, quoted as 0.384. The alt text was updated to "m = 12 to 24 … (at m = 24 only in the last three steps)" and "m = 28 to 60". Frame 6 (m=24) shows the dip and the final jump.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Animations intro l.32–33 | labelled with y(5), its error at t=5 and the largest error at any grid point | matches the script's annotate lines and the frames | OK |
| Case 1 l.52 | error at t=5 small: −4.2e-6 at m=60 | −4.223e-6 | OK |
| Case 1 l.53 | −1.7e-6 at m=150, y(5)≈0.0081182 | −1.715e-6; 0.0081182 | OK |
| Case 1 l.54–55 | ∂f/∂y strongly negative late, damps earlier error | ∫∂f/∂y from 1.667 to 5 is −45.6 | OK |
| Case 1 l.55–56 | from m=55 on, t=5 error >10⁴ times smaller than max | ratios 1.48e4 (55), 1.35e4 (60) … 1.31e4 (150); m=50 is 3.26e3, so "from 55" is right | OK |
| Case 1 l.57 | m=45–150: max lies between t=1.64 and 1.73 | t of max: 1.667, 1.700, 1.727, 1.667, 1.643, 1.688, … 1.667; range 1.643–1.727 | OK |
| Case 1 l.57–58 | after the peak, where the run is above the reference | peak at 0.88; sign of error at the max is + for all m ≥ 45 | OK |
| Case 1 l.58 | falls at every refinement in the sweep | the max is strictly decreasing over m = 10…150 | OK |
| Case 1 l.58–59 | about halves when m doubles | 60→120 ratio 2.02 | OK |
| Case 1 l.59–60 | 5.7e-2 (60), 2.8e-2 (120), 2.2e-2 (150) | 5.698e-2, 2.816e-2, 2.247e-2 | OK |
| Case 1 alt | at m=150: −1.7e-06 and 2.2e-02, largest near t=1.67 | −1.715e-6, 2.247e-2, t=1.667 | OK |
| Case 2 l.80 | m=12 to 24 tail zig-zags | sign changes after the peak: 4, 4, 3, 5, 5, 3 for m=12…24 | OK |
| Case 2 l.80–81 | m=24 only last three steps alternate: +0.069, −0.076, +0.489 | +0.0692, −0.0755, +0.4889; earlier steps all + | OK |
| Case 2 l.81 | ends at y(5)≈0.613 (m=24) | 0.6126681 | OK |
| Case 2 l.81–83 | m=28 to 60 turn upward; m=28 one small dip 0.0075 in 2nd-to-last step | m=28 d[-2]=−0.00754; m=32–60 have one sign change after the peak | OK |
| Case 2 l.83–84 | rise from min 0.35 (28), 0.057 (40), 0.015 (60) | 0.3501, 0.05716, 0.01500 | OK |
| Case 2 l.85 | y(5)≈0.384, 0.0761, 0.0259 | 0.3841123, 0.0761463, 0.0259429 | OK |
| Case 2 l.87 | from m=16 the error at t=5 falls at every refinement | 1.110, 0.945, 0.807, 0.605, … 1.82e-6, strictly decreasing | OK |
| Case 2 l.88 | 2.5e-4 (80), 1.8e-6 (150), y(5)≈0.0081217 | 2.520e-4, 1.818e-6, 0.0081217 | OK |
| Case 2 l.89 | m=16 to 70: t=5 error is the largest error of the run | argmax is at t=5 for m=16…70; for m=12 and 14 it is not (t=4.58, 4.64), consistent with "from 16" | OK |
| Case 2 l.90 | from m=80, 2.5 to 87 times smaller | ratios 2.49, 8.91, 20.6, 49.8, 87.4 | OK |
| Case 2 l.91 | max lies between t=3.19 and 3.22 | 3.188, 3.222, 3.200, 3.208, 3.200 | OK |
| Case 2 l.91–92 | 6.3e-4 (80), 1.6e-4 (150) | 6.275e-4, 1.589e-4 | OK |
| Case 2 l.92–93 | falls by 3.9, close to (150/80)²≈3.5 | 3.949; 3.516 (fitted order 2.19) | OK |
| Case 2 l.93–94 | Euler's falls by 1.9, close to 150/80≈1.9 | 4.248e-2/2.247e-2 = 1.89; 1.875 | OK |
| Case 2 l.94–95 | at m=150 about 140 times smaller than Euler's 2.2e-2; t=5 errors about the same size | 2.247e-2/1.589e-4 = 141; −1.7e-6 vs +1.8e-6 | OK |
| Case 2 alt | m=12 to 24 zig-zag (m=24 only last three steps); m=28 to 60 upturn | as above | OK |
| Case 2 alt | at m=150: +1.8e-06 and 1.6e-04, largest near t=3.20 | +1.818e-6, 1.589e-4, 3.200 | OK |
| Frames (both) | "error at t = 5: %+.1e", "max \|error\| = %.1e at t = %.2f" | all 41 frames' values reproduced by indep.py (see instr output) | OK |
| Scripts | refnodes(m): RK4 with m·cld(50000,m) steps, sampled every k | node alignment correct (yr[1:k:end] has m+1 entries at t_i); values match DOP853 | OK |

### New problems
None. This rests on:
- the full ledger above, every number independently recomputed;
- the full-size frames I viewed: aa 1 (m=10), 10 (m=55) and 20 (m=150); bb 1 (m=12), 6 (m=24), 17 (m=80) and 21 (m=150). In each, the three black label lines are legible, do not overlap the curves and match the computed values. The curves, shading and legend are unchanged; only the annotations moved and one was added.

One small point that is not a defect: the intro calls the reference "fixed-step RK4 with 50 000 steps". The grid-node errors are taken against RK4 with between 50 000 and 50 100 steps. The difference is far below the printed precision.

### Reproducibility and conventions
- Reproducibility: I ran scratch copies of eulersmethodaa.jl and eulersmethodbb.jl (`check/run/`). Their output GIFs are byte-identical to the working-tree GIFs: sha256 62a76368… and 3625a1aa…, the same as the LFS oids in the diff. Frame counts are 20 and 21.
- Conventions: Description comes before Animations. Each case has a "[Julia source]" link and a GIF embed with descriptive alt text. There are no code blocks (0 ```).
- Files outside the folder: this fix's diff touches only the five files in the page folder. The working tree also has changes in other numerical-methods page folders, which belong to other pages' parallel fixes. Nothing outside `pages/numerical-methods/eulers-method-for-odes/` is attributable to this fix.

**Final status:** committed
