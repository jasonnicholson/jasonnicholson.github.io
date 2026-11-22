# Fix record: secant-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/secant-method/fix/`
- `inst.jl`: an instrumented copy of the iteration and legend-label logic of `secantmethodbb/cc/ff.jl`. It prints every iterate in double precision and the old and new label for every frame. Output is in `inst.out`.
- `indep.py`: an independent run of the same secant iteration in 100-digit mpmath from the same starting values. It prints exact iterates, errors, sign patterns and the label each exact value would get. Output is in `indep.out`.
- `bbox.jl`: the bounding box of pixel differences between the committed and the regenerated frames. Output is in `bbox.out`.
- `old/`, `new/`, `legacy/`: frames extracted with `giftools.jl` from the committed GIFs, the regenerated GIFs and Mathews' a2001 GIFs.

## Findings

### F1 — Minor — fixed
- **Reproduced:** `julia inst.jl` gives the ff iterates p2 = −1.842461960133637, p3 = −0.09748338647473931, p4 = 0.07619322951467797, p5 = −5.236815030411346e−05, p6 = 1.011134093196055e−07 and p7 = −9.225344201478945e−17. `indep.py` (mpmath) agrees: −1.84246196013363, −0.0974833864747366, 0.0761932295146752, −5.2368150304106e−5, 1.01113409319577e−7, −9.22534493586275e−17.
  - The sign pattern for p1…p7 is `+--+-+-` (`indep.out`). The iterates overshoot to the far side at p2 and stay on that side at p3. From p3 on they alternate sides, and |p| decreases strictly (0.0975, 0.0762, 5.2e−5, 1.0e−7, 9.2e−17). So "converges directly" is false.
  - The finding said the iterates alternate "exactly as in Case 3". That is not quite true: p2 and p3 are both negative. Case 3 alternates from p1 on (`+-+-+-+-`). The comment was worded to match the computed signs.
- **Change:** `secantmethodff.jl` line 4.
  - Before: `# Root at x=0; method converges directly`
  - After: `# Root at x=0; overshoots to p2 ≈ -1.842, then from p3 on the iterates alternate sides of the root while converging`
- **Check:** see the ledger rows L1–L3. No page change was needed. Case 6's Behavior text ("Despite a larger first overshoot, subsequent steps quickly close in on the root") is still true and makes no claim about direction.

### F2 — Minor — fixed
- **Reproduced:**
  - `julia inst.jl` prints the old label `round(pc; digits=5)` for every frame. In bb, frames 25–28 print `p26 = 0.2`, `p27 = 0.2`, `p28 = 0.2` and `p29 = 0.2`, although the true values are p26 = 0.2000037425 … p29 = 0.2000008835. In cc, frames 4–7 print `p5 = 0.0`, `p6 = -0.0`, `p7 = 0.0` and `p8 = 0.0`. In ff, frames 4–6 print `p5 = -5.0e-5`, `p6 = 0.0` and `p7 = -0.0`.
  - The old committed frames show the same labels (`old/bb/frame_028.png` etc.).
  - The finding is confirmed, and also covers `-5.0e-5` for p5 = −5.2368e−5 in ff (one significant figure, wrong in its second digit).
- **Change:**
  - `secantmethodbb.jl`: added `using Printf`. The label changed from `"p$(frame+1) = $(round(pc; digits=5))"` to `@sprintf("p%d = %.8f", frame+1, pc)`. With 8 decimals the residual error is visible down to p29 (err 8.8e−7).
  - `secantmethodcc.jl` and `secantmethodff.jl`: added `using Printf` and a helper, `fmt_p(x) = x == 0 ? "0" : abs(x) >= 1e-3 ? @sprintf("%.5f", x) : @sprintf("%.2e", x)`, with the label `"p$(frame+1) = $(fmt_p(pc))"`. Values with |x| ≥ 1e−3 keep the old 5-decimal text: −1.22138, 0.01804, −0.00672, −1.84246, −0.09748, 0.07619. Smaller values are shown in scientific notation with 3 significant figures.
  - Why 3 significant figures: cc's p7 is 4.798293787661118e−25 in double but 4.80018331316741e−25 in exact arithmetic, because cancellation in double corrupts the third digit. A `%.6g` label (Mathews' own style) would print `4.79829e-25`, a false number. `%.2e` prints `4.80e-25`, which equals the exact value rounded.
- **Check:** every new label (ledger L4–L6) equals the exact mpmath iterate rounded to the label's precision. The labels in the regenerated frames were read at full size: bb frames 1, 14 and 28; cc frame 5 and the contact sheet; ff frame 6 and the contact sheet.

## Ledger of changed text

| # | Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|---|
| L1 | `secantmethodff.jl` l.4 | "overshoots to p2 ≈ -1.842" | `julia inst.jl` → p2 = −1.842461960133637; `python3 -I indep.py` → −1.84246196013363 | yes |
| L2 | `secantmethodff.jl` l.4 | "then from p3 on the iterates alternate sides of the root" | `indep.py` sign string for p1..p7 is `+--+-+-`, so p3−, p4+, p5−, p6+, p7− alternate. The double-precision `inst.out` gives the same signs. | yes |
| L3 | `secantmethodff.jl` l.4 | "while converging" (root x = 0) | \|p3..p7\| = 0.0975, 0.0762, 5.24e−5, 1.01e−7, 9.23e−17 is strictly decreasing toward 0 (`indep.out`) | yes |
| L4 | `secantmethodbb.jl` legend, frames 1–28 | `p2 = 0.57333333` … `p29 = 0.20000088`, with %.8f for every iterate p2…p29 | `inst.out` NEW column vs `indep.out` label column: all 28 labels are identical, e.g. p26 0.20000374, p27 0.20000231, p28 0.20000143, p29 0.20000088. Exact p29 = 0.20000088348853, so err = 8.83489e−7 | yes |
| L5 | `secantmethodcc.jl` legend, frames 1–7 | `p2 = -1.22138`, `p3 = 0.01804`, `p4 = -0.00672`, `p5 = 4.57e-07`, `p6 = -6.89e-12`, `p7 = 4.80e-25`, `p8 = 0` | p2–p7 match the `indep.out` labels exactly. p8: double gives exactly 0 (`inst.out`); exact arithmetic gives −7.59e−48 (see Notes) | p2–p7 yes; p8 is the double-precision value (Notes) |
| L6 | `secantmethodff.jl` legend, frames 1–6 | `p2 = -1.84246`, `p3 = -0.09748`, `p4 = 0.07619`, `p5 = -5.24e-05`, `p6 = 1.01e-07`, `p7 = -9.23e-17` | They match the `indep.out` labels exactly (exact p5 = −5.2368150e−5, p6 = 1.0111341e−7, p7 = −9.2253449e−17) | yes |
| L7 | `secantmethodcc.jl`, `secantmethodff.jl` comment | "Legend value: 5 decimals, or scientific notation once \|x\| < 1e-3 so small iterates do not print as 0.0." | Describes `fmt_p` as written; `inst.out` frame 4 of cc shows OLD `0.0` → NEW `4.57e-07` | yes |

`index.qmd` was not changed. The page cites no legend value from the bb, cc or ff GIFs. Case 5's quoted `p10 ≈ 10.57` comes from `secantmethodee.gif`, which is unchanged.

## Scripts and GIFs
- **Scripts changed:** `secantmethodbb.jl`, `secantmethodcc.jl` and `secantmethodff.jl`. The changes are the label format and `using Printf`, plus the header comment in ff. The iteration and plotting geometry are untouched.
- **GIFs regenerated:** each was rebuilt in place with `julia secantmethod{bb,cc,ff}.jl` from the page folder. `secantmethodaa`, `dd` and `ee` were not run and are unchanged.
- **Frame comparison:** `bbox.jl` compared the committed frames with the new frames (`bbox.out`).
  - The frame counts are unchanged: 28, 10 and 6.
  - cc frames 2, 3 and 8–10 and ff frames 1–3 have no difference above threshold. Their labels are unchanged by design.
  - In the other frames, the differences sit in the legend box (rows 54–133).
  - bb frames 1–7 and cc frame 1 also show low-amplitude single-pixel changes along the magenta curve. An 8× amplified difference image (`diff_bb1.png`) shows these are GIF palette quantization, not geometry.
- **Frames viewed at full size:**
  - bb frame 1: the secant passes through p0 and p1 and meets y = 0 at the diamond. The label `p2 = 0.57333333` is legible.
  - bb frame 14: `p15 = 0.20074478`.
  - bb frame 28: `p29 = 0.20000088`. The legend fits inside the top-left box and does not overlap the curve.
  - cc frame 5: `p6 = -6.89e-12`.
  - ff frame 6: `p7 = -9.23e-17`.
  - The contact sheets for cc (all 10 frames) and ff (all 6 frames) were also checked. Every label is legible and has the right index.
- **git status of the page folder after regeneration:** `M` on `secantmethodbb.gif`, `secantmethodbb.jl`, `secantmethodcc.gif`, `secantmethodcc.jl`, `secantmethodff.gif` and `secantmethodff.jl`. Nothing else changed.

## Legacy archive
Consulted.
- **n2003 module (`secantmethod/SecantMethodMod/Links/*_lnk_*.html`; the top-level `SecantMethodMod.html` is not in the archive):**
  - Example 1 uses the secant method on a cubic.
  - Example 2's statement says Newton's method.
  - Examples 3–8 are the six animated cases. Their titles are: Fast Convergence; Slow Convergence; Convergence, Oscillation; Convergence; NON Convergence, Diverging to Infinity; Convergence.
  - Example 8 (this page's Case 6) is titled just "Convergence". It makes no "directly" claim.
- **a2001 GIFs (`a2001/Animations/RootFinding/SecantMethod/Secant{aa..ff}.gif`):**
  - `Secantff.gif` shows p2 = −1.84246, p3 = −0.09748, p4 = 0.07619, p5 = −0.00005 and p6 = 1.01113×10⁻⁷. That agrees with the computed sequence and with the side alternation from p3 on.
  - `Secantbb.gif`'s last frame labels `p28 = 0.200001`, so Mathews' own label already distinguished the iterate from 0.2.
  - Mathews' labels use 6 significant figures (`0.200001`, `-1.84246`) or 5 decimals (`-0.00005`), and switch to scientific notation for very small values (`1.01113×10⁻⁷`). The fixed labels follow the same idea. They use 3 significant figures for small values because the double-precision cc p7 is not accurate to 6 (see F2).
  - These files exist in a2001. The round-2 review's note that the Example 5 images are missing refers to the n2003 module images only. This was not investigated further, because it is not a finding.

## Notes
- **cc `p8 = 0` (frame 7):** in double precision p8 is exactly 0, because atan(p7) == p7 and the secant ratio rounds to 1. In exact arithmetic p8 = −7.59e−48. The rounding error of that step in double is about eps·|p7| ≈ 1e−40, far larger than 7.6e−48, so 0 is the correct double-precision result and is within the computation's accuracy. It was left as is. The old label also showed `0.0` there. If Jason prefers, the label could read `p8 ≈ 0`.
- **Pre-existing items not covered by any finding, left untouched:**
  - The page has no `## Description` section.
  - cc frames 8–10 only repeat the converged point (noted by the reviewer as harmless padding).
  - Plain `round(...; digits=5)` and `digits=4` labels remain in `secantmethodaa.jl` and `secantmethoddd.jl`, where no value rounds to a false number. The reviewer confirmed those labels.

### Director note

Checker's pre-existing notes (not counted): the page has no `## Description` section; in the cc GIF frames 8–10 show no secant line because the iteration stops once p8 = 0.0 in Float64.

## Resolution check (independent checker, not shown this record)

Scratch evidence: `check/indep.py` (independent float64 + 200-digit mpmath secant iterations), `check/run/` (scratch runs of the three changed scripts), `check/frames_{bb,cc,ff}/` and `check/oldframes_{bb,cc,ff}/` (decoded frames of new and pre-fix GIFs; pre-fix GIFs taken from the local LFS object store by the HEAD pointer oids), `check/{bb,cc,ff}_legends.png` (legend crops of every relevant frame).

### Original findings

### F1 — resolved
- The false comment `# Root at x=0; method converges directly` in `secantmethodff.jl` line 4 is gone. It now reads `# Root at x=0; overshoots to p2 ≈ -1.842, then from p3 on the iterates alternate sides of the root while converging`.
- Independent check (`indep.py`, float64 and 200-digit mpmath agree): p2 = -1.8424620 (≈ -1.842 ✓), p3 = -0.0974834, p4 = +0.0761932, p5 = -5.2368e-5, p6 = +1.0111e-7, p7 = -9.2253e-17. p2 and p3 are both negative, and from p3 on the signs go − + − + −, so "from p3 on the iterates alternate sides" is exactly right. |p3| > |p4| > |p5| > ..., so "while converging" is also right.
- The page text for Case 6 (unchanged) does not repeat the "directly" claim, so no page change was needed. The GIF is consistent: the frame legends show p3 = -0.09748, p4 = 0.07619, p5 = -5.24e-05, p6 = 1.01e-07, p7 = -9.23e-17.

### F2 — resolved
- `secantmethodbb.jl`: the label is now `@sprintf("p%d = %.8f", frame+1, pc)`, with `using Printf` added. Frames 24–28 of the new GIF read p25 = 0.20000606, p26 = 0.20000374, p27 = 0.20000231, p28 = 0.20000143, p29 = 0.20000088 (verified in `bb_legends.png`). Independent values: 0.2000060555, 0.2000037425, 0.2000023130, 0.2000014295, 0.2000008835 (mpmath on 25(x−0.2)² agrees). All are correctly rounded to 8 decimals. The residual error (8.8e-7 at p29) is now visible, so the final frame no longer reads as exact convergence. Frame 1 (p2 = 0.57333333) and frame 14 (p15 = 0.20074478) also match.
- `secantmethodcc.jl` and `secantmethodff.jl`: the new `fmt_p` prints 5 decimals for |x| ≥ 1e-3 and `%.2e` below that.
  - cc legends: p2 = -1.22138, p3 = 0.01804, p4 = -0.00672, p5 = 4.57e-07, p6 = -6.89e-12, p7 = 4.80e-25, p8 = 0. All match the independent float64 run.
  - ff legends: as listed under F1, all match.
  - The old `0.0`/`-0.0` labels for nonzero iterates are gone. The only remaining "0" is cc p8, which is exactly 0.0 in Float64 (exact arithmetic gives −7.6e−48: the secant ratio (p7−p6)/(p7−atan(p6)) rounds to 1). So that label is the true computed value, not a rounding artefact of the display.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| ff.jl l.4 | "overshoots to p2 ≈ -1.842" | p2 = -1.84246196 (float64 and mpmath) | correct |
| ff.jl l.4 | "from p3 on the iterates alternate sides of the root while converging" | signs p2..p7: − − + − + −; magnitudes decrease monotonically from p3 | correct |
| cc.jl, ff.jl new comment | "5 decimals, or scientific notation once \|x\| < 1e-3 so small iterates do not print as 0.0" | matches `fmt_p` code; output observed in frames | correct |
| cc.jl, ff.jl `fmt_p` | `x == 0 ? "0" : abs(x) >= 1e-3 ? %.5f : %.2e` | each legend value compared with an independent run (above) | correct |
| bb.jl label | `p%d = %.8f` | p2, p15, p25–p29 compared with independent values | correct |
| bb GIF legends | p25..p29 = 0.20000606 / 0.20000374 / 0.20000231 / 0.20000143 / 0.20000088 | independent values rounded to 8 decimals | correct |
| cc GIF legends | p2..p8 = -1.22138 / 0.01804 / -0.00672 / 4.57e-07 / -6.89e-12 / 4.80e-25 / 0 | independent float64 run (mpmath agrees to shown digits for p2–p7) | correct |
| ff GIF legends | p2..p7 = -1.84246 / -0.09748 / 0.07619 / -5.24e-05 / 1.01e-07 / -9.23e-17 | independent float64 and mpmath | correct |

`index.qmd` is unchanged (`git diff --quiet HEAD` on it). No page text, headings or alt text were changed.

### New problems
None. This rests on the following:
- Every legend value in all frames of the three regenerated GIFs was checked against an independent computation.
- First, middle and last frames of each GIF were viewed at full size (bb 1/14/28, cc 1/5/10, ff 1/6). The secant lines, x-intercept diamonds, dashed drop lines and history points are built from the right iterates and are unchanged in construction.
- A pixel diff against the pre-fix frames shows changes larger than palette noise only inside the legend box. Elsewhere there are at most a few isolated pixels, and frames with unchanged legends (e.g. cc 9) differ by at most 32 levels, which is GIF palette quantisation.
- The longer labels fit inside the legend box and do not cover any plotted element.

Two pre-existing observations, neither introduced by this fix:
1. cc frames 8–10 draw no secant: the 1e-14 denominator guard stops the iteration once p8 = 0.0.
2. The page has no `## Description` section; the intro paragraph sits under `## Animations`. This is the same at HEAD.

### Reproducibility and conventions
- **Reproducibility:** scratch copies of `secantmethodbb.jl`, `secantmethodcc.jl` and `secantmethodff.jl` produced GIFs byte-identical (`cmp`) to the working-tree GIFs, which are 28, 10 and 6 frames.
- **Conventions:** `index.qmd` is untouched. It still has a source link and an embed per case, descriptive alt text, and no code blocks. It lacks a `## Description` section before `## Animations`; this gap predates the fix.
- **Files changed:** only the six files in the page folder changed (3 .jl, 3 .gif). Other modified paths in the working tree belong to other pages and fix records being worked in parallel, and are not part of this page's diff.

**Final status:** committed
