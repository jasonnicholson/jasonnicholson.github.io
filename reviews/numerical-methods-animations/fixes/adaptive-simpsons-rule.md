# Fix record: adaptive-simpsons-rule

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/adaptive-simpsons-rule/fix/` (below: `$S`).

Evidence scripts (in `$S/scripts/`, each with its output saved as `<name>.out`):
- `nodesets.py`: parses the committed `node_sets` literal from `git show HEAD:…/adaptivesimpsonsaa.jl`.
- `analysis.py`: runs Mathews' `Adapt` routine (archive `AdaptiveQuadMod_gr_2.gif`), plus the 10ε and 15ε variants, and compares them with the committed node sets.
- `order.py`: tests whether any simple global rule reproduces the committed split order.
- `check_new.py`: independent level-order refinement, with per-set composite Simpson in mpmath at 40 digits, the reference integral, and a comparison with the committed node sets.
- `nearzero.py`: the test quantity on [0,h] against its tolerance, and the sympy series of f′ at 0.
- `instr.jl`: the fixed script's own refinement code (copied up to the animation loop), printing every node set, split and label.
- `pixels.py`: the pixel scale of the regenerated frame.
- `$S/frames_old/`, `$S/frames_new/`: frames of the committed and regenerated GIF. `$S/archive/frames/`: frames of Mathews' animation `a2001/Animations/Quadrature/AdaptQuad/AdaptQuadaa.gif`.

Run the Python scripts with `/usr/bin/python3 -I <script>` and the Julia one with `julia instr.jl`, from `$S/scripts/`.

## Findings

### F1 — Misleading — fixed
- **Reproduced.** `analysis.py` runs Mathews' routine exactly as in the archive (accept when |S(a,b)−S(a,c)−S(c,b)| < tol, otherwise recurse with tol/2 on each half). It returns: `accepted intervals 20`, `accepted intervals == script final panels: True`, `split intervals (calls not accepted) == script split set: True 19`. So the drawn partition is the factor-1 test with the tolerance halved per split. The factor range that reproduces it is `0.906 .. 1.059`, which matches the review. The page's 15ε test gives `fac=15: accepted intervals 9 … finest = (0.0, 0.03125)` and a returned sum of 2.0160634881. The finding holds.
  - **One refinement of the review's wording.** "Keeps the coarse S(a,b)" is true of the displayed "Approximation", which is the composite Simpson sum of S(a,b) over the drawn panels (2.0162517612). Mathews' routine itself returns Σ[S(a,m)+S(m,b)] over the same 20 intervals, which is `2.0162726040`. The acceptance test is the same in both cases; only the reported sum differs. Mathews' own table (archive image `gr_204.gif`) shows 2.016252, the coarse sum, like the animation.
- **Change.** index.qmd Description: the paragraph "A common acceptance criterion is … < 15ε, so refinement concentrates …" becomes a statement of the test the animation uses. The display reads |S(a,m)+S(m,b)−S(a,b)| < ε_[a,b], with ε on the whole interval and half the tolerance for each half of a split interval. The paragraph keeps "so refinement concentrates where curvature or oscillation is strongest". It adds one sentence on the 15ε variant: for this example it accepts 9 subintervals, finest [0,1/32], against 20, finest [0,1/2048]. The Animations paragraph now says the tolerance is ε = 10⁻³. It also states the split order and that "Approximation" is the composite Simpson sum of S(a,b) over the panels drawn. The Behavior paragraph gives the final error and the value the recursive routine itself returns, 2.016273.
- **Check.** Every number is in the ledger below. The script now runs this test (F3), so `instr.jl` and `check_new.py` reproduce the frames from the stated rule.

### F2 — Misleading — fixed
- **Reproduced.** The committed frames were extracted to `$S/frames_old` and the contact sheet and frame 21 viewed at full size. No nodes or panel boundaries can be seen; in frames 15–21 only the label text changes. The review's pixel scale is also confirmed: `pixels.py` gives a plot-box scale of 289.5 px per unit (box columns 39–618), so [0,1/32] is 9.05 px wide, [0,1/1024] is 0.28 px and [0,1/2048] is 0.14 px. The checker's correction is also correct: in the early committed frames the kinks between parabolas, for example at 0.5 and 1.0, do show the panels.
- **Change (script).** In `adaptivesimpsonsaa.jl`:
  - Each panel boundary gets a red vertical line from 0 to f(x).
  - Every sample point gets a red marker, drawn over the curve.
  - The two new sample points of each frame are drawn in blue, with a blue label "Split [p, q]". Its endpoints are printed as exact fractions (`Rational`), so the label is exact even when the panel is under 1 px wide.
  - The text lines moved up (y = 1.97, 1.84, 1.71, 1.58) to make room for the fourth line.
  - "Approximation" is printed with `@sprintf("%.6f")`. The old `round(…; digits=6)` printed 2.01592, dropping the trailing zero.

  Mathews' own animation in the archive draws the same red node markers and boundary lines (see Legacy archive).
- **Change (page).** The Animations paragraph says what is marked. The Behavior paragraph says the following, all computed:
  - the last seven frames split [0,1/16], …, [0,1/1024], because f′ is unbounded at 0;
  - the panels split in the last five frames are at most 1/64 wide (under 5 pixels), so the blue label names each split;
  - [1.5,2] is never split;
  - 19 of the 41 points lie in [0,1/8].

  The alt text is rewritten to match.
- **Check.** I viewed the new contact sheet (`$S/frames_new/sheet.png`) and frames 2, 6, 16 and 21 at full size.
  - Frame 2 shows the single panel [0,2] with red points at 0, 1 and 2 and no split label.
  - Frame 6 shows "Split [0, 1/2]", with blue points at 1/8 and 3/8 on f.
  - Frame 16 shows "Split [0, 1/32]", with blue points at 1/128 and 3/128 near the y-axis.
  - Frame 21 shows 41 red points, densely packed near x = 0 and sparse on [1.5,2], with boundary lines at 1.5 and 2 and a red point (no line) at the midpoint 1.75. Its labels read "Sample Points = 41", "Approximation = 2.016252", "tol = 0.001" and "Split [0, 1/1024]".
  - The text clears the curve, whose local maximum on [0.5,1.5] is 1.3845 at x = 0.939 (numpy grid of 100001 points).
  - `frames.md5` has no duplicate frames, so every one of the 21 frames is distinct.

### F3 — Minor — fixed
- **Reproduced.** In the committed script, `tol` appears only in the label (line 86) and `node_sets` is a literal (lines 13–34). `analysis.py` snaps the literals to the dyadic grid; the rounded literals in sets 16–20 (for example `0.0117188`) differ from it by up to 5e-8. The review's per-set values for sets 16–20 (2.0162192591 and so on, from the rounded literals) differ from the exact-dyadic values (2.0162192537) by about 5e-9, as the review said. The finding holds.
  - **Split order.** The literal is Mathews' own trace from Example 7 (archive `AdaptiveQuadMod_lnk_8.html`), but its split order is not the recursive (depth-first) order. `order.py` shows that no simple rule reproduces it: largest |d|, largest |d|/tol, widest-then-leftmost and leftmost all give the same set of 19 splits but a different order.
- **Change.** `adaptivesimpsonsaa.jl` now computes the node sets with `adaptive_node_sets(a, b, tol)`. It starts from the panel [a,b] with tolerance `tol`. At each step it splits the widest panel that fails `accepted(p,q,t)`, leftmost first, giving each half t/2. It stops when every panel passes. The test is Mathews' |S(p,m)+S(m,q)−S(p,q)| < t. Splitting widest-first visits the panels level by level; since the test is local, the final partition is the one the recursive routine accepts. Header comment unchanged.
- **Check.**
  - **Julia.** `instr.jl` (the fixed script's own code) prints 20 node sets with 3, 5, …, 41 points and midpoint deviation 0 for every set. Its final nodes are exact dyadics, identical to Mathews' accepted partition.
  - **Independent check.** `check_new.py` builds the node sets by its own level-order loop. It matches every set, split and value to 10 digits: for example set 5 is 2.0080514303 and set 20 is 2.0162517612.
  - **Comparison with the committed sets.** Against the committed `node_sets`, sets 1–4 and 6–20 have the same nodes; only set 5 (frame 6) differs. The committed set split [1/2,1] first (11 points, 1.935128); level order splits [0,1/2] first (2.008051).
  - **Changing `tol` now changes the frames.**

## Ledger of changed text

Reference integral I = 2.016279719617096327887274421915103056596, from the brief's command: `/usr/bin/python3 -I -c "import mpmath as mp; mp.mp.dps=40; …"`. Both quadratures printed the same 40 digits.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Description | "The animation uses the acceptance test of Mathews' routine: [a,b] is accepted when \|S(a,m)+S(m,b)−S(a,b)\| < ε_[a,b]" | Archive `AdaptiveQuadMod_gr_2.gif`: `If[Abs[Sab - Sac - Scb] < tol, …, Return[Adapt[a,c,tol/2] + Adapt[c,b,tol/2]]]`; `analysis.py` → `accepted intervals == script final panels: True`; script `accepted(p,q,t)` is this test | yes |
| index.qmd Description | "the whole interval starts with ε and each half of a split interval gets half its tolerance" | gr_2.gif (tol/2 in both recursive calls); script pushes `(p,m,t/2),(m,q,t/2)` | yes |
| index.qmd Description | "so refinement concentrates where curvature or oscillation is strongest" (kept from the original) | Review claim ledger #5 confirmed; `analysis.py`: finest accepted [0,2^-11] at x=0, [1.5,2] accepted unsplit | yes |
| index.qmd Description | 15ε variant "accepts 9 subintervals (the finest is [0,1/32])" | `analysis.py` → `fac=15: accepted intervals 9 … finest = (0.0, 0.03125)` | yes |
| index.qmd Description | "instead of 20 (the finest is [0,1/2048])" | `analysis.py` → `accepted intervals 20`, `finest accepted interval: (0.0, 0.00048828125) width 2^-11`; 2^-11 = 1/2048 | yes |
| index.qmd Animations | "with tolerance ε=10⁻³" | script `tol = 1e-3`; frame label "tol = 0.001" | yes |
| index.qmd Animations | "Starting from the single panel [0,2], each frame splits the widest panel that fails the test (leftmost first)" | script `adaptive_node_sets` (sort key `(-(q-p), p)` over failing panels); `instr.out` frame 2 split "-", frames 3–21 one split each | yes |
| index.qmd Animations | "marks the two new sample points in blue" | script: blue `scatter!` at (3p+q)/4, (p+3q)/4; frame 6 shows blue points at 1/8 and 3/8 after "Split [0, 1/2]" | yes |
| index.qmd Animations | "'Approximation' is the composite Simpson sum of S(a,b) over the panels drawn" | script `simpson_nonuniform(xs)` sums (h/3)(f(x0)+4f(x1)+f(x2)) over consecutive triples of the drawn node set | yes |
| index.qmd Behavior | "Refinement stops when all 20 panels (41 points) pass the test" | `instr.out` last set: `pts 41`; loop ends when `failing` is empty; `check_new.out` set 20 `pts 41` | yes |
| index.qmd Behavior | "[1.5,2] is never split" | `analysis.py` → `[1.5,2] accepted unsplit: True`; `instr.out` split list contains no [3/2,2] | yes |
| index.qmd Behavior | "19 of the 41 points lie in [0,1/8]" | `julia -e '… count(<=(0.125), xs)'` on the final node set → `nodes in [0,1/8]: 19 of 41` | yes |
| index.qmd Behavior | "The last seven frames split [0,1/16], [0,1/32], …, [0,1/1024] in turn" | `instr.out` frames 15–21: splits [0, 1/16], [0, 1/32], [0, 1/64], [0, 1/128], [0, 1/256], [0, 1/512], [0, 1/1024] | yes |
| index.qmd Behavior | "because f′ is unbounded at x=0 (f′(x)≈(16/3)x^{-1/3} near 0)" | `nearzero.py`: sympy series `16/(3*x**(1/3)) + O(1)`. On [0,h] the test quantity shrinks by 3.175 per halving (→ 2^{5/3}=3.1748, i.e. like h^{5/3}) while the tolerance halves, so [0,h] fails for h = 1/8 … 1/1024; the neighbour [h,2h] passes from h=1/16 on (e.g. h=2^-5: d=1.61e-6 < tol 1.56e-5) | yes |
| index.qmd Behavior | "the panels split in the last five frames are at most 1/64 wide (under 5 pixels at this scale)" | `instr.out` frames 17–21 split [0,1/64] … [0,1/1024]; `pixels.py` → 289.5 px/unit, width 0.015625 → 4.52 px | yes |
| index.qmd Behavior | "so the blue label names each one" | frames 16 and 21 viewed: "Split [0, 1/32]", "Split [0, 1/1024]" in blue | yes |
| index.qmd Behavior | "final estimate 2.016252" | `instr.out` frame 21 `approx 2.0162517612 label 2.016252`; `check_new.out` set 20 `2.01625176116` | yes |
| index.qmd Behavior | "integral 2.016280" | I = 2.0162797196… → 2.016280 (6 dp) | yes |
| index.qmd Behavior | "by −2.8×10⁻⁵" | `check_new.out` set 20 `err -2.796e-5` | yes |
| index.qmd Behavior | "summing S(a,m)+S(m,b) over the same panels, as the recursive routine returns, gives 2.016273" | `analysis.py` → `returned value 2.0162726040`; `check_new.out` → `Adapt return (fine sum) = 2.01627260396` | yes |
| index.qmd alt text | "one failing panel is split per frame, with sample points and panel boundaries drawn and the new points in blue" | script drawing code; frames 6, 16, 21 viewed | yes |
| index.qmd alt text | "the refinement ends with 41 points, 19 of them in [0, 1/8]" | as above (41 points; 19 of 41) | yes |
| index.qmd alt text | "the piecewise quadratic approximation and integral estimate update each frame" (kept) | `frames.md5`: 21 distinct frames; `instr.out`: 20 different approximations | yes |
| GIF label | "Sample Points = n", n = 3, 5, …, 41 | `instr.out` pts column | yes |
| GIF label | "Approximation = %.6f" per frame | `instr.out` label column. E.g. frame 6 is 2.008051, frame 15 is 2.015920 and frame 21 is 2.016252. Each matches `check_new.out` (mpmath at exact nodes) to 10 digits. | yes |
| GIF label | "Split [p, q]" exact fractions | `Rational(x)` of dyadic Float64 is exact; `instr.out` split column | yes |

## Scripts and GIFs
- **Script changed.** `adaptivesimpsonsaa.jl`. The node sets are now computed (F3), and nodes, boundaries, the new points and the split label are drawn (F2). The changes add only `using Printf` (standard library); no other dependency.
- **GIF regenerated.** `adaptivesimpsonsaa.gif`, by `cd pages/numerical-methods/adaptive-simpsons-rule && julia adaptivesimpsonsaa.jl`. It has 21 frames at fps 2: one blank start frame showing f, then 20 node sets.
- **Frames viewed.** I viewed the contact sheet and frames 2, 6, 16 and 21 at full size. I checked:
  - the parabolas pass through f at the red points;
  - the boundary lines sit at the panel ends;
  - the blue points are the midpoints of the two new halves;
  - the labels match `instr.out`;
  - the text does not overlap the curve;
  - late splits near x = 0 are named by the label.
- **`git status --short -- pages/numerical-methods/adaptive-simpsons-rule` after regeneration:**
  ```
   M pages/numerical-methods/adaptive-simpsons-rule/adaptivesimpsonsaa.gif
   M pages/numerical-methods/adaptive-simpsons-rule/adaptivesimpsonsaa.jl
   M pages/numerical-methods/adaptive-simpsons-rule/index.qmd
  ```

## Legacy archive
Consulted: `n2003/AdaptiveQuadMod.html`, `n2003/adaptivequad/AdaptiveQuadMod/Links/AdaptiveQuadMod_lnk_8.html` (Example 7), the images `gr_2.gif` (Adapt subroutine), `gr_90.gif` (the long version), `gr_184.gif` (f), `gr_185.gif`, `gr_204.gif` and `gr_206.gif`, and the animation `a2001/Animations/Quadrature/AdaptQuad/AdaptQuadaa.gif` (24 frames).
- **What the example is.** Example 7 is f(x) = 1 + e^{−x} sin(8x^{2/3}) on [0,2], computed with `Adapt[0,2,0.001]`. The 20 node sets printed there are exactly the committed `node_sets` literal, including the 6-digit rounded values. Mathews' table gives 2.491261 for 3 points and 2.016252 for 41 points: the coarse composite sum, as on our frames.
- **Acceptance test.** Mathews' `Adapt` (gr_2.gif) uses `Abs[Sab - Sac - Scb] < tol` with tol/2 per half, and returns `Sac + Scb`. This is the factor-1 test the review inferred. It is now stated on the page. The page also notes that the routine's own return value is 2.016273, not the 2.016252 shown in both Mathews' table and our frames (computed: `analysis.py`).
- **Animation.** Mathews' animation draws red sample points and red vertical panel boundaries on a pink fill, with "Sample Points" and "Approximation" text. The F2 fix restores those markers.
- **Difference from the archive.** Mathews' split order is not the depth-first order of his recursive routine. `order.py` found no simple rule that reproduces it. The fixed script computes the sets in level order instead. This differs from Mathews in one frame: frame 6, the 11-point set, shows 2.008051 where Mathews' table and the old GIF show 1.935128. The final partition and value are the same. The page no longer claims that the frames follow the recorded progression.

## Notes
- **D1.** D1 asks for a measured order in place of a textbook order. This page states no convergence order, and an adaptive run has no single h, so no order was measured or added. The D1 cause (f′ unbounded at 0, sympy series `16/(3*x**(1/3)) + O(1)`) is used in the Behavior paragraph to explain where the refinement goes, which is what this animation shows.
- **D7.** The text was changed to describe the animation (F1). The script was also changed, because F2 (an invisible feature) and F3 (no algorithm) are about the animation itself.
- **Wording kept.** "A common variant uses 15ε" keeps the page's original general remark that 15ε is a common criterion. It is not specific to this example; the numbers attached to it for this example were computed.
- The "(Planned)" stubs were not touched.
- Nothing outside the page folder was touched.

## Resolution check (independent checker, not shown this record)

Scratch work: `check/indep.py` (independent Python recursion, greedy order, values), `check/instr.jl` (the committed script's own node sets and labels, plus a tol sweep), `check/run/` (scratch rerun), `check/frames/` (decoded frames, sheet, md5s).

### Original findings

### F1 — resolved
- The 15ε sentence is gone. The page now states the test the animation uses: accept [a,b] when |S(a,m)+S(m,b)−S(a,b)| < ε_[a,b], starting from ε and halving it for each half of a split.
- The test is attributed to Mathews' routine. That is correct: legacy `adaptivequad/AdaptiveQuadMod/Images/AdaptiveQuadMod_gr_2.gif` shows `Adapt[a,b,tol]`, which tests `Abs[Sab-Sac-Scb] < tol`, otherwise calls `Adapt[a,c,tol/2] + Adapt[c,b,tol/2]`.
- The script now computes the partition with that test (line 20, `accepted`), with tolerance halving per split. I checked it against my own recursive implementation (`indep.py`).
  - **Factor 1:** 20 accepted panels, 41 nodes, finest panel [0, 1/2048]. This is the same set as the script's final partition (`True`).
  - **Factor 15:** 9 accepted panels, finest [0, 1/32]. This matches the page's remark about the variant.
- The page also says what "Approximation" sums: S(a,b) over the panels drawn. That is what `simpson_nonuniform` computes. It separately gives the S(a,m)+S(m,b) value the recursive routine returns (2.016273, which I confirmed).
- So the reader is no longer told one test while the animation shows another.

### F2 — resolved
- **Frames.** Every frame now draws:
  - red node markers;
  - red panel-boundary lines at the odd-indexed nodes;
  - the two new midpoints of the split panel, in blue;
  - a blue "Split [p, q]" label with exact dyadic fractions.

  I checked frames 2, 11 and 21 at full size, plus the contact sheet. The kinks and boundaries are clearly visible down to about 1/16.
- **The late splits.** These happen in panels too small to see, as the original finding said. The page now says so explicitly: the last five panels split are at most 1/64 wide, which is under 5 px. That claim holds: the plot spans 40 to 618 px for 2 units, so 1/64 ≈ 4.5 px. The page also says the label names each panel. The labels read Split [0, 1/64] … [0, 1/1024] in frames 17–21.
- The original finding's suggested fix allowed softening the text. The fixer did that and added the labels, so this is fully adequate.
- The overstated claim "nonuniform node refinement concentrates on difficult regions" was replaced by verifiable counts. I confirmed them: 41 points, 19 of them in the closed interval [0, 1/8] (18 strictly below 1/8), and [1.5, 2] is never split.

### F3 — resolved
- The `node_sets` literal is gone. The node sets come from `adaptive_node_sets(a, b, tol)`, so `tol` now drives the result. Changing it gives 21 final nodes at tol 1e-2 and 71 at tol 1e-4.
- Nodes are exact binary midpoints, so the six-digit rounded literals are gone. The final value is now 2.016252 from exact dyadic nodes (2.0162517612).
- The split order is now a defined rule: widest failing panel first, leftmost on ties. The page states this rule. I reproduced the full 19-split order independently in Python and it matches the script's `splits`.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| qmd l.18 | "acceptance test of Mathews' routine" | Legacy `Adapt` image gr_2: `Abs[Sab-Sac-Scb] < tol`, halves tol on recursion | correct |
| qmd l.20 | \|S(a,m)+S(m,b)−S(a,b)\| < ε_[a,b] | Same as script line 20 and the legacy routine | correct |
| qmd l.22 | "whole interval starts with ε and each half … gets half its tolerance" | Script line 37 `t/2`; legacy `tol/2` | correct |
| qmd l.22 | 15ε variant: "9 subintervals (finest [0,1/32])" | indep.py fac=15: 9 accepted, finest 1/32, first panel (0, 0.03125) | correct |
| qmd l.22 | "instead of 20 (finest [0,1/2048])" | indep.py fac=1: 20, finest 1/2048 | correct |
| qmd l.27 | ε = 10^-3 | Script `tol = 1e-3`, label "tol = 0.001" | correct |
| qmd l.27 | "each frame splits the widest panel that fails the test (leftmost first)" | Script line 34; order reproduced independently in Python. GIF frame 1 is the bare curve and frame 2 is the unsplit [0,2], so "each frame" means each frame after the start, which the sentence's "Starting from the single panel" covers | correct |
| qmd l.27 | "marks the two new sample points in blue" | Frames: blue markers at (3p+q)/4 and (p+3q)/4, e.g. 0.5625 and 0.6875 for Split [1/2,3/4] (frame 11) | correct |
| qmd l.27 | "Approximation" = composite sum of S(a,b) over the panels drawn | `simpson_nonuniform` is h/3(f0+4f1+f2) per panel = S(a,b). Frame values match indep (2.491261, 1.611786, …) | correct |
| qmd l.33 | "all 20 panels (41 points) pass the test" | indep.py and instr.jl | correct |
| qmd l.33 | "[1.5,2] is never split" | Accepted panel (1.5, 2.0); no split of it in the order | correct |
| qmd l.33 | "19 of the 41 points lie in [0,1/8]" | Count ≤ 1/8 is 19 (closed interval) | correct |
| qmd l.33 | "last seven frames split [0,1/16] … [0,1/1024]" | Node sets 14–20 = GIF frames 15–21; splits (0,1/16) … (0,1/1024), 7 values | correct |
| qmd l.33 | f′ unbounded at 0, f′(x) ≈ (16/3)x^(−1/3) | Analytic: cos(8x^(2/3))·(16/3)x^(−1/3)·e^(−x) + …. Numeric ratio of f′ to (16/3)x^(−1/3): 0.9996 at 1e-4, 0.999997 at 1e-6 | correct |
| qmd l.33 | "last five frames are at most 1/64 wide (under 5 pixels)" | Splits 1/64 … 1/1024; axis about 289 px/unit, so 1/64 ≈ 4.5 px | correct |
| qmd l.33 | final estimate 2.016252 | indep S1 = 2.0162518; frame 21 label 2.016252 | correct |
| qmd l.33 | integral 2.016280 | mpmath quad at 30 digits, split at 0, 1/1024, 1/8, 1, 2: 2.01627971961709… | correct |
| qmd l.33 | difference −2.8×10^-5 | −2.7958e-5 | correct |
| qmd l.33 | S(a,m)+S(m,b) sum = 2.016273 | indep S2 = 2.0162726 | correct |
| qmd l.37 alt | one failing panel per frame; points, boundaries, blue new points; 41 points, 19 in [0,1/8] | Frames and counts above | correct |
| jl l.17–19 comment | "Mathews' Adapt[a, b, tol] … each half gets tolerance t/2" | Legacy routine | correct |
| jl l.24–26 comment | "final partition is the one the recursive routine accepts" | Greedy final set == recursive accepted set (indep.py `True`). Expected, since each panel's tolerance depends only on its depth | correct |
| GIF labels | Sample Points 3, 5, …, 41; Approximation values; "Split [p, q]" fractions | instr.jl table matches frames on the sheet and at full size (frames 2, 11, 21) | correct |

### New problems

None. This rests on the following:
- every number and sentence in the diff was recomputed independently (ledger above);
- the split order and final partition were reproduced by a separate Python implementation;
- the legacy `Adapt` routine was checked for the attribution;
- frames 1, 2, 11 and 21 and the contact sheet were inspected. Labels are legible, parabolas and fills are still built from each panel's three nodes, and nothing that was correct before is broken.

One cosmetic observation, not a problem: in frames 17–21 the blue markers sit on the left axis edge and cannot be told apart. The page text and the blue label already say this.

### Reproducibility and conventions

- **Reproducibility.** I ran a scratch copy of `adaptivesimpsonsaa.jl` with `julia run/adaptivesimpsonsaa.jl`. The output is byte-identical (`cmp`) to the committed `adaptivesimpsonsaa.gif`: 21 frames, sha256 per the LFS pointer 2b2a0444….
- **Conventions.**
  - Description comes before Animations.
  - There is one case, with a `[Julia source](adaptivesimpsonsaa.jl)` link and a GIF embed.
  - The alt text is descriptive and accurate.
  - There are no code blocks.
  - The bibliography and back link are unchanged.
- **Scope of changes.** The diff touches only the three files in the page folder.
  - Other modified files in the working tree belong to other pages' fixes on this branch.
  - There is an untracked `reviews/numerical-methods-animations/fixes/adaptive-simpsons-rule.md`. It is a process report outside the site pages, and I did not read it, per the brief.

**Final status:** committed
