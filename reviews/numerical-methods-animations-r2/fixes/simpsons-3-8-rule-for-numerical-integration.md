# Fix record: simpsons-3-8-rule-for-numerical-integration

Scratch folder (`$F`): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/simpsons-3-8-rule-for-numerical-integration/fix/`
Legacy path (`$L`): `/home/jason/Desktop/math-fullerton/baseline/mathews/`

## Findings

### F1 — Minor (Fidelity) — fixed
- Reproduced: `ls -la $L/a2001/Animations/Quadrature/Simpson38/` lists `Simpsonaa.gif` (228,701 bytes), `Simpsonaa.html` and `Simpson.html`. `Simpsonaa.html` has `SRC="Simpsonaa.gif"`. The module page `$L/n2003/simpson38rule/Simpson38RuleMod/Links/Simpson38RuleMod_lnk_12.html` (Example 11 solution) links "Animation 1" to `/a2001/Animations/Quadrature/Simpson38/Simpsonaa.html`. `giftools.jl Simpsonaa.gif $F/legacy` gives "24 frames". The page's sentence "`Simpsonaa.gif` is missing in the snapshot" is false.
- Legacy frame labels, read from the crop sheet `$F/legacy/labels.png` (crop 360×110 at (265,30) of every frame, tiled 3×8): 3 title frames, then Sample Points = 4, 4, 7, 10, 13, 16, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 79, 85, 91, 106, 121. The approximations are 1.884214, 1.884214, 1.790470, 1.927234, 1.976629, 1.994094, 2.001834, 2.008397, 2.011141, 2.012595, 2.013477, 2.014059, 2.014468, 2.014767, 2.014994, 2.015170, 2.015311, 2.015425, 2.015519, 2.015692, 2.015810. The finding's list leaves out the repeated 4-point frame. Its count of three title frames plus 21 labelled frames = 24 is right.
- Independent check: `/usr/bin/python3 -I $F/indep.py` computes the composite 3/8 rule in mpmath at 30 digits with its own weight loop. Every one of the 21 legacy labels matches its value rounded to 6 decimals ("OK" on every row). n=120 gives 2.01581041086, with error −0.000469309 against I = 2.0162797196171. Page n not in the legacy sequence: [21, 27, 33, 81, 99, 108]. Legacy n not on the page: [78, 84, 105].
- Change: `index.qmd`, legacy note (line 34). Before: "the archived animation HTML exists, but the referenced `Simpsonaa.gif` is missing in the snapshot; this reconstruction follows the module formulas and visual conventions." After: "this animation reconstructs Mathews' archived animation `Simpsonaa.gif`. It uses the same integrand and interval and ends at the same 121-point approximation, 2.015810, but steps through a different sequence of intermediate $n$."
- Check: every number and claim is in the ledger below.

### F2 — Minor (Fidelity / page match) — fixed (R2-A: follow Mathews on picture elements)
- Reproduced: the committed `simpson38aa.jl` has no `scatter!` and no divider segments. Committed frames extracted to `$F/committed/` show no dots and no dividers. The magenta curve at lw=2 covers the red cubic edges from about n=15 onward.
- Legacy: `$F/legacy/frame_006.png` (n=6) and `frame_024.png` (n=120) were viewed full size, along with the contact sheet. Every data frame has a red dot at each sample point and a red vertical line from the baseline up to f at every third node, the panel boundary. In frame 6 there is one interior line, at x=1.
- Change: `simpson38aa.jl` follows the Simpson-page pattern with the divider stride changed to 3. (1) `xlims = (0.0, 2.0)` becomes `(-0.03, 2.03)`, so the end dots are not clipped. (2) After the panel fills, red dividers `plot!([xk,xk],[0,f(xk)]; color=:red, lw=0.8)` are drawn for `i in 0:3:n`, with `xk = a + i*dx`. (3) After the magenta curve, `scatter!` draws the nodes `a + i*dx`, `i in 0:n`, with `color=:red, markersize=3, markerstrokewidth=0`. `n_seq`, the quadrature and the labels are unchanged. `index.qmd`: one sentence added to the Animations intro, and the alt text updated to describe the new elements (ledger).
- Check:
  - Instrumented copy `$F/simpson38aa_instr.jl`: `@animate` is replaced by a plain loop that reads `Plots.current().series_list` for each frame. For all 23 data frames the result is `okS=true okD=true okOrder=true`, and the run ends with "ALL OK = true".
    - okS: one scatter of n+1 points, x bit-equal (`===`) to `a+i*dx`, y == f(x).
    - okD: n/3+1 two-point dividers at `a+3k*dx` with y = [0, f].
    - okOrder: series order is panels → dividers → curve → scatter (`PDCS`).
    - Frame n=0 holds only the curve (`C`).
    - `simpson38_sum(n)` is unchanged; for example n=120 gives 2.015810410863725, the same as the round-2 review table.
  - Independent pixel check `/usr/bin/python3 -I $F/pixelcheck.py $F/new`:
    - The plot box is found from the dark frame lines (L=39, R=618, T=50, B=449).
    - For every frame it requires a red pixel (R>200, G<170, B<170) within ±1 px of each predicted dot, and at 20/50/80 % of each divider's height.
    - As a control, it requires no red pixel at 50 % height above any node with i mod 3 ≠ 0.
    - Result: all dots and divider samples are found in every frame (for example n=120: dots 121/121, divider samples 123/123, control 0). Frame 1 has 0 red pixels in the box. "ALL OK = True".

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Animations intro | "Red dots mark the sample points $x_i$" | `simpson38aa_instr.jl`: scatter x === a+i·dx for i=0..n, y == f, in all 23 data frames; pixel check finds red at each dot | yes |
| index.qmd Animations intro | "vertical red lines mark the panel boundaries $x_{3k}$" | instr: n/3+1 segments at a+3k·dx (k=0..n/3, endpoints included), y=[0,f]; pixel check finds red at 20/50/80 % of each and none above non-boundary nodes | yes |
| index.qmd alt text | "after an opening frame showing only f" | instr: frame n=0 series = `C` (curve only); pixel check: 0 red pixels in box in frame 1; `frame_001.png` viewed | yes |
| index.qmd alt text | "each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise cubic panels and the global approximation" | instr order `PDCS` in all 23 data frames (P = cubic panel fills); "Approximation = …" label present (frames 2, 3, 10, 16, 24 viewed) | yes |
| index.qmd legacy note | "reconstructs Mathews' archived animation `Simpsonaa.gif`" | the archive file exists (ls, 228,701 bytes, 24 frames); module Example 11 "Animation 1" links to Simpsonaa.html, which embeds Simpsonaa.gif | yes |
| index.qmd legacy note | "same integrand and interval" | legacy frame shows "y = e^{-x} sin(8x^{2/3}) + 1" with x axis 0 to 2 (`legacy/frame_024.png`); all 21 legacy labels equal mpmath S³ᐟ⁸ₙ of that f on [0,2] to 6 dp (`indep.py`, every row OK); the script has the same f, a=0, b=2 | yes |
| index.qmd legacy note | "ends at the same 121-point approximation, 2.015810" | legacy last frame "Sample Points = 121 / Approximation = 2.015810"; page last n = 120 → 121 points, script 2.015810410863725, mpmath 2.01581041086 → 2.015810 | yes |
| index.qmd legacy note | "steps through a different sequence of intermediate $n$" | `indep.py`: page-only n [21, 27, 33, 81, 99, 108]; legacy-only n [78, 84, 105]; both start at n=3 and end at n=120 | yes |
| simpson38aa.jl comments | "Panel dividers at every panel boundary x_{3k}, k = 0..n/3"; "Sample points x_i = a + i*dx, i = 0..n" | same instr checks as above | yes |

The text left unchanged was rechecked against the new GIF. The Behavior paragraph says "the last frame (121 sample points) gives 2.01581", and frame 24 reads "Sample Points = 121 / Approximation = 2.01581". The approximations are unchanged because `simpson38_sum` is unchanged.

## Scripts and GIFs
- Script changed: `simpson38aa.jl`. GIF regenerated: `simpson38aa.gif` (24 frames, 328,009 bytes), by `cd pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration && julia simpson38aa.jl`.
- Frames viewed full size: 1 (n=0, curve only), 2 (n=3), 3 (n=6), 10 (n=27), 16 (n=54) and 24 (n=120), plus the contact sheet. Two 3× zooms of frame 24 were also viewed: the steep left peak, and the right end, where the end dot is not clipped.
  - At 121 points the node spacing is about 4.7 px and the dots are about 6 px wide. The dots touch on the flat right part but each one is still distinguishable. The legacy GIF at the same density looks the same.
  - The labels do not overlap any dots. The panel kinks are visible for n ≤ 12.
- `git status --short -- pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration` after regeneration: `M index.qmd`, `M simpson38aa.gif`, `M simpson38aa.jl`.

## Legacy archive
Consulted.
- `a2001/Animations/Quadrature/Simpson38/Simpsonaa.gif` is present, with 24 frames. It is Mathews' "Animation 1", linked from the Example 11 solution of the module (`n2003/simpson38rule/Simpson38RuleMod/Links/..._lnk_12.html`). That solution's table lists the same sample-point sequence the GIF shows.
- The GIF draws the same integrand on [0,2], in this order:
  - a pink fill under the cubic panels with a red edge;
  - red dots at the sample points;
  - red dividers at every third node;
  - the magenta curve.
- Its labels match mpmath values (`indep.py`).
- Differences that remain on the page, which no finding asked to change:
  - The page uses a different intermediate n sequence (Simpson-page precedent: its n sequence was kept). The legacy note now states this difference.
  - The page has one title frame against Mathews' three, plus his repeated 4-point frame.
  - The text label layout differs.

## Notes
- R2-A "left out" sentence: not added. Mathews has one animation for this topic, and the page reproduces it. The Simpson pattern-setter page added no such sentence either.
- Not a finding, not changed: the intro sentence "Each frame recomputes the approximation…" is not literally true of the opening curve-only frame. The round-2 reviewer judged this trivial (claim #7). The new alt text names the opening frame, as the Simpson page does.
- Marker size was kept at 3 for consistency with the Simpson page. The page is denser here (121 points against 109). The reviewer suggested 2.5, which would still touch at 4.7 px spacing.

### Director note

Checker's note (pre-existing, not counted): frame labels drop trailing zeros (e.g. 2.01581 where Mathews prints 2.015810).

## Resolution check (independent checker, not shown this record)

Scratch: `.../r2fix/simpsons-3-8-rule-for-numerical-integration/check/` (committed/, regen/, old/, legacy/ frame folders; num.py; run/).

### Original findings

### F1 — resolved
- Evidence: the false sentence ("`Simpsonaa.gif` is missing in the snapshot") is gone (index.qmd line 34). The replacement says the animation reconstructs Mathews' `Simpsonaa.gif`, with the same integrand and interval, ending at the same 121-point approximation 2.015810, through a different sequence of intermediate n. Each claim checked:
  - `ls a2001/Animations/Quadrature/Simpson38/` lists `Simpsonaa.gif`. The 24 frames were extracted with giftools.
  - Legacy frame 24 (full size) shows the label `y = e^{-x} sin(8 x^{2/3}) + 1` on [0,2], "Sample Points = 121", "Approximation = 2.015810".
  - mpmath (30 digits): S_120 = 2.015810411, which agrees.
  - The legacy sheet shows Sample Points 4, 10, 16, 25, 37, 49, 61, 73, 85, 106, … The page's sequence is n+1 = 4, 7, …, 37, 43, …, 73, 82, 91, 100, 109, 121. It includes 22, 28, 34, 82, 100 and 109, which the legacy sequence lacks, and lacks 85 and 106. "Different sequence of intermediate n" is therefore true.
  - The case follows R2-A, third bullet (correct stale "legacy GIF missing" notes).

### F2 — resolved
- Evidence: the script now draws red panel dividers `plot!([xk,xk],[0,f(xk)])` for i in 0:3:n. These are the panel boundaries x_{3k}, k = 0..n/3, including both ends. It also draws red sample-point dots `scatter!` at x_i = a + i·dx, i = 0..n. The dots are drawn after the magenta curve, so they stay on top.
- Full-size frames checked:
  - frame 2 (n=3): 4 dots, with dividers only at 0 and 2.
  - frame 3 (n=6): 7 dots, with a divider at x=1.
  - frame 12 (n=33): 34 dots, with dividers at 0.18, 0.36, 0.55, … = 2·3k/33.
  - frame 24 (n=120): 121 dots and 41 dividers, spaced 0.05 apart.
- In every data frame, the triplet structure and the sample points are visible, including the late frames where the cubic is hidden under f. This matches legacy frame 24 (dots plus a vertical line every third node), as R2-A requires ("panel markers on … Simpson 3/8").
- `xlims` was widened to (-0.03, 2.03), so the end dots are not clipped (visible at x=0 and x=2 in every frame).
- The fill, cubic pieces, labels and approximation values are unchanged from the pre-fix GIF.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.22 | "Red dots mark the sample points $x_i$" | script l.118–121; frames 2, 3, 12, 24 show n+1 dots on f at a+i·dx | correct |
| index.qmd l.22 | "vertical red lines mark the panel boundaries $x_{3k}$" | script loop `0:3:n`; frame 12 divider positions 2·3k/33; frame 24 has 41 lines | correct |
| index.qmd l.32 alt | "after an opening frame showing only f" | frame 1 shows only the magenta f, with no fill, dots or labels | correct |
| index.qmd l.32 alt | "sample points as red dots, panel boundaries as vertical red lines, piecewise cubic panels and the global approximation" | frames 2–24 | correct |
| index.qmd l.34 | "reconstructs Mathews' archived animation `Simpsonaa.gif`" | file exists in a2001/Animations/Quadrature/Simpson38/ | correct |
| index.qmd l.34 | "same integrand and interval" | legacy label y=e^{-x}sin(8x^{2/3})+1; x axis 0..2 | correct |
| index.qmd l.34 | "121-point approximation, 2.015810" | legacy frame 24 label 2.015810; mpmath S_120 = 2.015810411; page GIF last frame 2.01581 | correct |
| index.qmd l.34 | "different sequence of intermediate $n$" | legacy 79, 85, 106 vs page 82, 100, 109 (and 22, 28, 34) | correct |
| simpson38aa.jl l.14 comment | "small margin so the end sample points are not clipped" | end dots fully visible in frames | correct |
| simpson38aa.jl comments l.57, l.71 | "Panel dividers at every panel boundary x_{3k}, k = 0..n/3"; "Sample points x_i = a + i*dx, i = 0..n" | match code | correct |

The unchanged Behavior text was re-checked against the regenerated values, since the frames' numbers are unchanged:
- all values are below I = 2.016279720;
- the error is 0.13207 at 4 points and 0.22581 at 7, then decreases monotonically;
- at 121 points the value is 2.015810 and the error is 0.000469;
- the error ratio from 60 to 120 subintervals is 3.2238, against 2^{5/3} = 3.1748.

All of it still holds.

### New problems
None. This rests on:
- the full-size views of frames 1, 2, 3, 12 and 24, and the 12-frame contact sheet;
- the mpmath recomputation of all 23 approximations and the integral;
- a comparison with the legacy frames;
- the fact that the diff touches only three files in the page folder.

Pre-existing observation, not introduced by this fix and not counted: the frame label uses `round(approx; digits=6)`, which drops trailing zeros ("1.79047", "2.01517", "2.01581"). Mathews prints 1.790470 and 2.015810.

### Reproducibility and conventions
- Ran a scratch copy of `simpson38aa.jl` (`julia simpson38aa.jl`). Its output GIF is byte-identical to the committed `simpson38aa.gif`: both have sha256 39119c3d…cdda and 328009 bytes, and `cmp` passes. The decoded frame md5s are also identical (24 frames).
- Conventions:
  - Description (l.10) comes before Animations (l.19).
  - Case 1 has a `[Julia source](simpson38aa.jl)` link and an embed.
  - The alt text is descriptive.
  - There are no code blocks (0 occurrences of ```).
- `fix.diff`/`git diff HEAD --stat` for this page shows only index.qmd, simpson38aa.gif and simpson38aa.jl. The other modified files in the working tree belong to other pages' parallel fixes; the untracked `reviews/numerical-methods-animations-r2/fixes/simpsons-3-8-rule-for-numerical-integration.md` is the expected fix record. No other change attributable to this fix was found outside the page folder.

**Final status:** committed
