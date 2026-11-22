# Fix record: fixed-point-iteration

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/fixed-point-iteration/fix/`
(`indep.py`, `indep2.py` = independent Python/mpmath/sympy checks; `inst/{dd,ee,ff}.jl` = instrumented copies of the fixed scripts that print every iterate and its legend label; `legacy/` = Mathews formula images and legacy GIF frames; `new/{dd,ee,ff}/` = frames of the regenerated GIFs.)

## Findings

### F1 — Minor (Fidelity) — fixed
- Reproduced: the archive formula images `FixedPointMod_gr_354/390/453.gif` (stacked to `legacy/f7.png`) read p₀ = 2.03 (Example 7), 1.95 (Example 8), 1.97 (Example 9) for g = x²/4 + x/2, x²/4 + x/2 and −x²/4 − x/2 + 4. The legacy last frames (`a2001/Animations/RootFinding/FixedPoint/Fixpointdd.gif` frame 33, `Fixpointee.gif` frame 54, `Fixpointff.gif` frame 36) show p₉ = 3.75337, p₁₆ = 0.01933, p₁₀ = 0.17357. `python3 indep.py` (mpmath, 40 digits) gives x₉ = 3.753370983 from 2.03, x₁₆ = 0.01933215993 from 1.95 and x₁₀ = 0.1735717694 from 1.97, matching. The page started Cases 4–6 at 1.5, 2.5, 1.5, and Case 5 left the [0,4] window at x₃ = 4.5544 (old script), as the finding says.
- Change (R2-A: follow Mathews' starting points):
  - `fixpointdd.jl`: x0 1.5 → 1.95, n_iters 8 → 16 (Mathews' 16), title and comments.
  - `fixpointee.jl`: x0 2.5 → 2.03, n_iters 4 → 9 (Mathews' 9; x₉ is the last iterate inside the window), title and header comments.
  - `fixpointff.jl`: x0 1.5 → 1.97, n_iters 16 → 32 (enough to reach the 4-cycle the page describes), title, window comment; `titlefontsize = 13` because the longer title "x₀ = 1.97" was clipped at the right edge at the default size (seen in the first regenerated frame 33).
  - `index.qmd`: Case 4/5/6 headings x₀; Case 4/5/6 alt text; Case 5 off-scale sentence replaced by "The animation stops at x₉ ≈ 3.753, the last iterate inside the window; the sequence keeps growing (x₁₂ ≈ 29.92, x₁₄ ≈ 1.437 × 10⁴)."
  - All other Case 4–6 Behavior wording was re-checked against the new orbits and still holds (ledger).
- Check: instrumented runs (`julia inst/dd.jl`, `inst/ee.jl`, `inst/ff.jl`) agree with `indep.py` to all 10 printed decimals. All three orbits stay inside their windows (`all in window=true`). The new frames match (see Scripts and GIFs).

### F2 — Minor (Page match) — fixed
- Reproduced: `index.qmd:39` said "strictly decreasing, so g'(2) = −½". sympy (`indep2.py`) gives g'(x) = −8/(x+2)², so g'(2) = −1/2. Monotonicity gives only the sign, so the "so" is a non sequitur.
- Change: `index.qmd` Case 3 Behavior → "The curve g(x) = 8/(x+2) is strictly decreasing, with g'(x) = −8/(x+2)², so g'(2) = −½."
- Check: `indep2.py` → `Case3 g'(x) = -8/(x + 2)**2  g'(2) = -1/2`.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 3 Behavior | g'(x) = −8/(x+2)², g'(2) = −½ | `indep2.py` → `-8/(x + 2)**2`, `g'(2) = -1/2` | yes |
| Case 4 heading | x₀ = 1.95 | archive gr_390 "p₀ = 1.95"; script `x0 = 1.95` | yes |
| Case 4 Behavior (unchanged text, re-checked for the new start) | walks away from x* = 2 to the left, converges monotonically to 0, g'(2) = 3/2, g'(0) = ½, g below diagonal on (0,2) | `indep.py`: x₀…x₁₆ strictly decreasing (True), 1.95 → 0.01933; ratio x₁₆/x₁₅ = 0.5095. `indep2.py`: g' = x/2 + 1/2 → 3/2, 1/2; g − x = x(x−2)/4 | yes |
| Case 4 alt | "starting at x₀ = 1.95 just below the repelling fixed point x* = 2; … walks left and converges to the fixed point x = 0" | as above; 2 − 1.95 = 0.05 | yes |
| Case 5 heading | x₀ = 2.03 | archive gr_354 "p₀ = 2.03"; script `x0 = 2.03` | yes |
| Case 5 Behavior (kept) | moves monotonically rightward and diverges | `indep.py`: x₀…x₁₄ strictly increasing (True), x₁₄ = 14373.03. For x > 2, g(x) − x = x(x−2)/4 > 0 and increasing, so the steps grow and the sequence is unbounded | yes |
| Case 5 Behavior (new) | stops at x₉ ≈ 3.753, the last iterate inside the window | `inst/ee.jl`: x_9 = 3.7533709825; `indep.py` x₁₀ = 5.398633924 > 4 | yes |
| Case 5 Behavior (new) | x₁₂ ≈ 29.92, x₁₄ ≈ 1.437 × 10⁴ | `indep.py`: x₁₂ = 29.92101127, x₁₄ = 14373.03054 | yes |
| Case 5 alt | "starting just above the fixed point at x₀ = 2.03; the staircase climbs away from x* = 2 and reaches x₉ ≈ 3.753 at the right of the window" | as above; last frame `new/ee/frame_010.png` marker at (3.753, 3.753), legend "x_9 = 3.7534" | yes |
| Case 6 heading | x₀ = 1.97 | archive gr_453 "p₀ = 1.97"; script `x0 = 1.97` | yes |
| Case 6 Behavior (unchanged text, re-checked) | moves away from x* = 2, alternates sides at every step, settles onto a stable 4-cycle (≈ 4.25, −2.64, 3.58, −0.99) | `indep.py`: alternates for all 0..60 (True); \|xₙ − 2\| grows 0.03 → 1.906 over x₀…x₁₁ and stays ≥ 1.57 from x₁₁ on. 4-cycle from the real roots of g⁴(x) = x: {−2.6405244, −0.98762106, 3.5771699, 4.2499617}, multiplier −0.0305 (`indep2.py`), so it is stable. The last shown iterates x₂₉…x₃₂ = 4.2493, −2.6388, 3.5786, −0.9909 are within 0.0034 of the cycle and round to 4.25, −2.64, 3.58, −0.99 | yes |
| Case 6 alt | "starting at x₀ = 1.97 just below x* = 2; … alternating sides, and settles onto a 4-cycle" | as above | yes |
| fixpointdd.jl comment | "x_16 = 0.0193" | `inst/dd.jl` x_16 = 0.0193321599 | yes |
| fixpointee.jl comments | "x_9 = 3.7534", "x_10 = 5.3986" | `inst/ee.jl` x_9 = 3.7533709825; `indep.py` x₁₀ = 5.398633924 | yes |
| fixpointff.jl comments | "within 0.004 of the 4-cycle" for x_29…x_32; orbit in [−2.639, 4.250]; min −2.639 | `inst/ff.jl` min = −2.63878712, max = 4.24929981; distances to cycle points 0.00066, 0.0017, 0.0014, 0.0033 | yes |
| fixpointff.jl legend comment (unchanged logic) | nothing drawn at x > −3.3125, y < −3.3125 | orbit min −2.6388 > −3.3125; last frame shows the legend covers nothing | yes |
| GIF titles | "x₀ = 1.95", "x₀ = 2.03", "x₀ = 1.97" | full frames viewed: all fit in the frame | yes |

## Scripts and GIFs
- Scripts changed: `fixpointdd.jl`, `fixpointee.jl`, `fixpointff.jl`. Regenerated in place: `fixpointdd.gif` (17 frames), `fixpointee.gif` (10), `fixpointff.gif` (33). `fixpointaa/bb/cc` are untouched, not regenerated and unchanged in git.
- Frames viewed:
  - dd: contact sheet (x_0, x_2, …, x_16) and full last frame. The staircase walks left from (1.95, 1.95) between the curve and the diagonal. The legend labels match `inst/dd.jl` (1.8898, 1.7632, 1.5174, 1.1122, 0.6199, 0.2442, 0.0732, 0.0193).
  - ee: full first and last frames. First is x_0 = 2.03 just right of the crossing. Last is x_9 = 3.7534, the staircase climbing between the curve and the diagonal, with no off-scale marker.
  - ff: contact sheet (x_0, x_3, …, x_30) and full last frame. Labels: 2.1004, 1.6519, 3.038, −1.7664, 3.8528, −2.3766, 4.1987, −1.2316, 3.6056, −2.6388, −0.9909, all matching `inst/ff.jl`. The small spiral around (2, 2) is visible in the early frames. The title fits after the font change, and the bottom-right legend covers nothing.
- `git status --short -- pages/numerical-methods/fixed-point-iteration` after regeneration: `M` on fixpointdd.gif/.jl, fixpointee.gif/.jl, fixpointff.gif/.jl and index.qmd. No other files changed.
- Independent resolution check: not run by me (left for the director's verifier).

## Legacy archive
Consulted.
- `n2003/FixedPointMod.html` with `Links/FixedPointMod_lnk_8/9/10.html` (Examples 7, 8, 9). Each example is framed by Theorem (ii): x* is "a repelling fixed point and the iteration exhibits local divergence". Example 8 also names the attractive fixed point.
- Formula images: g = x²/4 + x/2 with p₀ = 2.03 (Example 7) and p₀ = 1.95 (Example 8); g = −x²/4 − x/2 + 4 with p₀ = 1.97 (Example 9).
- Legacy animations `a2001/Animations/RootFinding/FixedPoint/Fixpointdd/ee/ff.gif`: Fixpointdd = Example 7 (9 steps, p₉ = 3.75337), Fixpointee = Example 8 (16 steps, p₁₆ = 0.01933), Fixpointff = Example 9 (10 steps, p₁₀ = 0.17357, in a [0,4] window). All recomputed and matched (see F1).
- Differences kept on purpose:
  - (a) Case 6 runs 32 steps in a [−4.5, 4.5] window to show the attracting 4-cycle the page describes. Mathews stops at p₁₀, before the orbit leaves [0,4]. The 4-cycle claim is computed true (multiplier −0.0305), so it is kept.
  - (b) The page's dd/ee file names are swapped relative to Mathews' Fixpointdd/ee (noted by the reviewer as not part of the finding). Not changed.
  - (c) Cases 2 and 3 start at 3.8 and 1.0, not Mathews' 4.0. The reviewer excluded these from F1 and they show the same behaviour, so they are not changed.

## Notes
- After this change the off-scale-marker branch in `fixpointee.jl` never runs, as in `fixpointdd.jl` and `fixpointff.jl`, where the reviewer already called it harmless dead code. It is kept so the three scripts stay uniform and honest if parameters change.
- The page still has no `## Description` section (pre-existing convention gap, not a finding; not added).
- Case 6 now has 33 frames at fps 2 (about 16.5 s), compared with 17 before.

### Director note

Checker's cosmetic note: the off-scale marker code from round 1 remains in the three scripts but never runs with the new starting points.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: Cases 4, 5 and 6 now start at Mathews' values 1.95, 2.03 and 1.97, in the scripts (`x0`), GIF titles, page headings and alt text. This follows owner decision R2-A ("Fixed-Point cases 4–6 starting points").
- I recomputed the orbits independently (mpmath, 40 digits; script `/usr/bin/python3` inline):
  - Case 4 (g = x²/4 + x/2, x₀ = 1.95): the orbit decreases strictly, 1.95, 1.925625, 1.88982, …, x₁₆ = 0.0193322. This matches Mathews' p₁₆ = 0.01933. All 17 points are inside [0,4], and the orbit converges to 0, where g'(0) = ½.
  - Case 5 (same g, x₀ = 2.03): the orbit increases strictly, and x₉ = 3.7533710 matches Mathews' p₉ = 3.75337. Next come x₁₀ = 5.39863 (outside the window), x₁₂ = 29.92101 and x₁₄ = 14373.03 (≈ 1.437 × 10⁴). With n_iters = 9, every plotted iterate is inside the window, so the old off-scale frames are gone.
  - Case 6 (g = −x²/4 − x/2 + 4, x₀ = 1.97): x₁₀ = 0.1735718 matches Mathews' p₁₀ = 0.17357. The orbit alternates sides of x* = 2 at all 32 steps (checked by sign of xₖ − 2). The limiting 4-cycle is {−0.987621, 4.249962, −2.640524, 3.577170}. Its multiplier ∏g'(cᵢ) = −0.0305, so it is attracting, and the page is right to call it stable. The 2-cycle {−2, 4} has multiplier −1.25 and repels.
  - Distances from x₂₉…x₃₂ to the cycle are 6.6e−4, 1.7e−3, 1.4e−3 and 3.3e−3, all under 0.004, as the script comment claims. Over x₀…x₃₂ the orbit stays in [−2.63879, 4.24930], inside the ±4.5 window, so no point is clamped.
- No value is clamped or mislabelled: the off-scale branch is never reached in any of the three scripts, and every legend label uses the true iterate.
- The legend labels I read on the frames are x_16 = 0.0193, x_9 = 3.7534, x_16 = −1.6373 and x_32 = −0.9909. All four match my computation.

### F2 — resolved
- Evidence: index.qmd Case 3 now reads "strictly decreasing, with g'(x) = −8/(x+2)², so g'(2) = −½". That derivative is correct: at x = 2 it gives −8/16 = −½, the value now follows from the derivative and not from monotonicity, and the wording matches the suggested correction.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 3 | g'(x) = −8/(x+2)², g'(2) = −½ | d/dx 8(x+2)⁻¹ = −8(x+2)⁻²; at 2 gives −½ | true |
| index.qmd Case 4 heading | x₀ = 1.95 | matches script and Mathews Ex. 8 | true |
| Case 4 alt text | "x₀ = 1.95 just below the repelling fixed point x* = 2; walks left and converges to x = 0" | orbit decreases strictly to 0.0193 at k=16 and goes on to 0; g'(2) = 3/2 | true |
| Case 4 Behavior (unchanged) | "converges monotonically to x = 0" | holds for the new start | true |
| index.qmd Case 5 heading | x₀ = 2.03 | matches script and Mathews Ex. 7 | true |
| Case 5 Behavior | "stops at x₉ ≈ 3.753, the last iterate inside the window" | x₉ = 3.75337 ≤ 4 and x₁₀ = 5.39863 > 4 | true |
| Case 5 Behavior | x₁₂ ≈ 29.92, x₁₄ ≈ 1.437 × 10⁴ | 29.92101 and 14373.03 | true |
| Case 5 Behavior (unchanged) | "moves monotonically rightward and diverges" | orbit increases strictly and goes to infinity (x₁₆ ≈ 6.67e14) | true |
| Case 5 alt text | "just above … x₀ = 2.03; climbs away from x* = 2 and reaches x₉ ≈ 3.753 at the right of the window" | as above; last frame shows the marker at (3.753, 3.753) | true |
| index.qmd Case 6 heading | x₀ = 1.97 | matches script and Mathews Ex. 9 | true |
| Case 6 Behavior (unchanged) | "alternating sides at every step, settles onto a stable 4-cycle (≈ 4.25, −2.64, 3.58, −0.99)" | alternation holds at all 32 steps; cycle is 4.24996, −2.64052, 3.57717, −0.98762; multiplier −0.0305 | true |
| Case 6 alt text | "x₀ = 1.97 just below x* = 2 … alternating sides … 4-cycle" | as above | true |
| fixpointdd.jl | x0 = 1.95, n_iters = 16, "x_16 = 0.0193, all inside the window" | 0.0193322; minimum 0.0193 > 0 and maximum 1.95 < 4 | true |
| fixpointee.jl | x0 = 2.03, n_iters = 9, "x_9 = 3.7534 … x_10 = 5.3986 would leave it" | 3.753371 and 5.398634 | true |
| fixpointff.jl | x0 = 1.97, n_iters = 32, "x_29 … x_32 within 0.004 of the 4-cycle" | largest distance 0.00326 | true |
| fixpointff.jl | "orbit stays in [−2.639, 4.250]" | actual range [−2.63879, 4.24930] lies inside it (4.250 is a loose upper bound) | true |
| fixpointff.jl | titlefontsize = 13 | full title visible in frames 1, 17, 33 | fine |
| GIF titles | "x₀ = 1.95", "x₀ = 2.03", "x₀ = 1.97" | read on frames | true |

### New problems
None. This rests on the following checks:
- I recomputed every iterate and claim above at 40 digits.
- I viewed the full-size first, middle and last frames of fixpointff and the last frames of fixpointdd and fixpointee, plus the contact sheets of dd and ee. Each cobweb is built from the true iterates, the labels are legible and correct, the titles are not clipped, and no off-scale marker appears.

One cosmetic note, not a defect: the off-scale marker branch and its header comment remain in all three scripts but never run with the new starts. It is harmless general-purpose code.

### Reproducibility and conventions
- I copied fixpointdd.jl, fixpointee.jl and fixpointff.jl to `check/run/` and ran them with plain `julia`. All three output GIFs are byte-identical (`cmp`) to the committed GIFs. The committed GIFs have 17, 10 and 33 frames.
- Conventions: the page is unchanged structurally. Each case has a source link and an embed with descriptive alt text, and there are no code blocks. The page has no "Description" heading; it has a single "Animations" section, and that is not changed by this diff.
- Outside the page folder, the only new file for this page is the untracked fix record `reviews/numerical-methods-animations-r2/fixes/fixed-point-iteration.md`, which the plan expects. The other modified and untracked files belong to other pages' fixes.

**Final status:** committed
