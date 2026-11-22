# Fix record: catenary

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/catenary/fix/`
- `check.py`: sympy series of catenary − parabola and of sinh(u) − u, per-frame c values, the 0.05 gap point and window exit points for frames 1-3, the c thresholds for leaving the window before x = ±4, the minimum gap on the script grid, and the c = 4 gaps
- `check2.py`: the |x| where the c = 0.5 gap reaches 0.05 and 0.1, plus a numerical monotonicity check of the gap
- `frames_committed/`: the frames of the committed catenaryaa.gif (unchanged by this fix) and a contact sheet

Run with `/usr/bin/python3 -I check.py` and `/usr/bin/python3 -I check2.py`.

## Findings

### F1 — Misleading — fixed
- Reproduced: `check.py` → catenary − parabola = x⁴/(24c³) + x⁶/(720c⁵) + x⁸/(40320c⁷) + O(x¹⁰). Every term is positive for x ≠ 0, and the minimum on the script's 500-point grid over all 25 frames is 2.69e-12 (rounding at x ≈ 0). So the catenary is never below the parabola. At c = 0.5 (frame 1): the gap reaches 0.05 at |x| = 0.6145, the catenary leaves y = 12 at |x| = 1.9354 and the parabola at |x| = 3.3912, and at x = 4 the values are cat = 745.2396 and par = 16.5. Thresholds: the parabola leaves the window before x = ±4 only for c < 0.7085 (frames 1-2), and the catenary only for c < 1.4146 (frames 1-7), which matches the checker's correction. Committed frame_001.png: the solid blue catenary is the narrow inner U, the dashed parabola the wide outer U, and they visibly split at about |x| ≈ 0.7. The old sentence ("the catenary hangs deeper and the parabola diverges noticeably at the endpoints") is wrong in the plot's coordinates on both counts.
- Change: index.qmd line 18, Case 1 Behavior. Before: "For small $c$ (slack cable), the catenary hangs deeper and the parabola diverges noticeably at the endpoints." After: "For small $c$ (slack cable), the catenary climbs more steeply than the parabola and the two separate well inside the window: at $c=0.5$ the gap passes 0.1 at $|x|\approx0.73$, and the catenary leaves the top of the plot at $|x|\approx1.94$, the parabola at $|x|\approx3.39$. The catenary never lies below the parabola, since their difference $x^4/(24c^3)+x^6/(720c^5)+\cdots$ is positive for every $x\neq0$." This is a text-only fix (D7), because the animation is correct. Script and GIF are unchanged.
- Check: every number is in the ledger below. The new text claims exit points only for c = 0.5, so it does not imply that both curves leave the window for all small c (checker's correction). Frame 1 viewed: the split at about 0.7 and the exits at about ±1.9 and ±3.4 match.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:18 | "the catenary climbs more steeply than the parabola" | slopes are sinh(x/c) and x/c, with \|sinh u\| > \|u\| for u ≠ 0. `check.py`: sinh(x) − x = x³/6 + x⁵/120 + … (all terms positive). `check2.py` also confirms with mpmath that sinh(t/0.5) − t/0.5 > 0 on 2001 points in (0, 4]. Holds for every c | yes |
| index.qmd:18 | "the two separate well inside the window" | `check2.py` → at c = 0.5 the gap is 0.05 at \|x\| = 0.6145 and 0.1 at \|x\| = 0.7271, against the window half-width 4. Frame 1 shows a visible split at about 0.7 | yes |
| index.qmd:18 | "at $c=0.5$ the gap passes 0.1 at $\|x\|\approx0.73$" | `check2.py` → 0.727123365… The gap increases in \|x\| because its derivative sinh(x/c) − x/c > 0 for x > 0, so "passes" means "exceeds from there on". c = 0.5 is frame 1 (`check.py` c list) | yes |
| index.qmd:18 | "catenary leaves the top of the plot at $\|x\|\approx1.94$" | `check.py` → c·acosh(12/c) = 1.9354 at c = 0.5. Script ylims = (0, 12) | yes |
| index.qmd:18 | "the parabola at $\|x\|\approx3.39$" | `check.py` → sqrt(2c(12 − c)) = 3.3912 at c = 0.5 | yes |
| index.qmd:18 | "The catenary never lies below the parabola" | series is a sum of positive terms (all terms c·(x/c)^{2k}/(2k)! for k ≥ 2). `check.py` → min(cat − par) over the grid and all 25 frames = 2.69e-12 ≥ 0 | yes |
| index.qmd:18 | "$x^4/(24c^3)+x^6/(720c^5)+\cdots$" | `check.py` sympy → x**8/(40320*c**7) + x**6/(720*c**5) + x**4/(24*c**3) + O(x**10) | yes |
| index.qmd:18 | "positive for every $x\neq0$" | same series, every term > 0 for x ≠ 0, c > 0 | yes |

Unchanged text that was re-checked: "For large $c$ … nearly indistinguishable near $x=0$". `check.py` at c = 4 gives a gap of 0.00065 at |x| = 1, 0.0105 at |x| = 2 and 0.172 at |x| = 4. "The lowest point is always at $(0, c)$": both curves have y'(0) = 0, y(0) = c and y'' > 0. The alt text ("the two curves nearly coincide near the apex for large c") is consistent with the new Behavior text.

## Scripts and GIFs
- No script changed. No GIF regenerated. catenaryaa.gif is the committed file. The round-1 inventory found it byte-identical to its regenerated output.
- Frames viewed with giftools.jl (`frames_committed/`): frame_001 (c = 0.5) and frame_025 (c = 4.0) at full size. In frame 1 the catenary is inside and above the parabola, they split at about |x| 0.7, and they leave the top at about ±1.9 and ±3.4. In frame 25 the curves coincide except near x = ±4, where the catenary is slightly above.
- `git status --short -- pages/numerical-methods/catenary` after the fix: ` M pages/numerical-methods/catenary/index.qmd` (only).

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/CatenaryMod.html` and `catenary/CatenaryMod/Links/CatenaryMod_lnk_1..6.html`. The module covers the Maclaurin series of the catenary ("approximated by a parabola", where the first terms of the series give the parabola), arc length, and fitting a catenary through the origin and a point (Example 1: a = 10, b = 6; Example 2: the matching parabola and a comparison of lengths). The only graph-sized image, CatenaryMod_gr_88.gif, is a single catenary through the origin and two marked endpoints. The archive has no animation that sweeps c and no statement about small-c behaviour, so it does not bear on F1. The site's animation (c sweep with the vertex fixed at (0, c)) is the site's own construction. Nothing on the page was changed to match the archive.

## Notes
- The page has no `## Description` section; its description sits as an intro paragraph under `## Animations`. This is a pre-existing convention gap that no finding names, so it was left as is.
- "Slack cable" for small c is kept from the original. It is correct physically (for a fixed span, smaller c means more sag: c(cosh(4/c) − 1) = 744.74 at c = 0.5 against 2.17 at c = 4, per the round-1 review's table), but the fixed-vertex plot does not show sag over a span.
- Nothing outside the page folder was touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The false sentence ("the catenary hangs deeper and the parabola diverges noticeably at the endpoints") is gone from index.qmd:18. The replacement says the catenary climbs more steeply than the parabola, the curves separate well inside the window, and the catenary never lies below the parabola. All of this is true (see ledger).
- sympy series of c·cosh(x/c) − (c + x²/(2c)) gives x⁴/(24c³) + x⁶/(720c⁵) + x⁸/(40320c⁷) + …. Every term is c·u^{2k}/(2k)! with u = x/c and k ≥ 2, so the difference is > 0 for every x ≠ 0. The page states this correctly.
- At c = 0.5 (mpmath, 40 digits): the gap reaches 0.1 at |x| = 0.72712, the catenary meets y = 12 at |x| = 1.93538, and the parabola meets y = 12 at |x| = 3.39116. These match the page's ≈0.73, ≈1.94 and ≈3.39.
- The script and GIF did not change, and they did not need to; the finding was only about the text. The full-size frame 1 (c = 0.5) shows the solid catenary as the narrow inner curve that leaves the top of the window near x = ±1.9. The dashed parabola leaves near x = ±3.4, and the curves visibly separate from about |x| ≈ 0.7. This matches the new text.
- The reviewer's correction (both curves leave the window only for c < 0.71) is respected: the new text quotes exit points only for c = 0.5. Independently, the catenary exits before x = 4 for frames 1–7 (c ≤ 1.375, exit at 3.93) and the parabola only for frames 1–2 (c = 0.646, exit at 3.83).

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:18 | "catenary climbs more steeply than the parabola" (small c) | The difference is ≥ 0 and grows like x⁴/(24c³); frame 1 shows the catenary as the inner, steeper curve | True |
| index.qmd:18 | "the two separate well inside the window" | At c = 0.5 the gap is 0.05 at 0.61 and 0.1 at 0.73, against a half-width of 4 | True |
| index.qmd:18 | gap passes 0.1 at \|x\| ≈ 0.73 (c = 0.5) | mpmath root 0.727123 | True |
| index.qmd:18 | catenary leaves the top at \|x\| ≈ 1.94 | 0.5·acosh(24) = 1.935383; ylims = (0, 12) in the script | True |
| index.qmd:18 | parabola leaves the top at \|x\| ≈ 3.39 | √(2·0.5·11.5) = 3.391165 | True |
| index.qmd:18 | "never lies below the parabola" | The series has only non-negative terms | True |
| index.qmd:18 | difference x⁴/(24c³) + x⁶/(720c⁵) + ⋯ | sympy series matches | True |
| index.qmd:18 | "positive for every x ≠ 0" | Each term is > 0 for x ≠ 0 | True |
| index.qmd:18 (unchanged) | large c: nearly indistinguishable near x = 0; lowest point (0, c) | Frame 25 (c = 4): the curves coincide near the apex and differ by about 0.17 at x = ±4; the black diamond is at (0, c) | True |

### New problems
None. This rests on three checks: every number and claim in the only changed line was recomputed independently; the GIF and script are unchanged; and frames 1, 13 and 25 were viewed at full size and agree with the text.

### Reproducibility and conventions
- The fix changes only `index.qmd`. catenaryaa.jl and catenaryaa.gif are unchanged: the working-tree GIF's sha256 1264fc57… equals the HEAD LFS pointer oid.
- A scratch copy of catenaryaa.jl regenerates catenaryaa.gif byte-identical to the committed file (cmp). It has 25 frames.
- No file outside the page folder is touched by this page's fix. git status of the folder shows only index.qmd. Repo-wide, no modified paths fall outside pages/numerical-methods; the other modifications there belong to other pages.
- Conventions: the page has a source link and an embed for its single case, descriptive alt text and no code blocks. One issue predates the fix and was not introduced by it: the page has no `## Description` section before `## Animations`, which the conventions file requires. The intro paragraph sits under `## Animations` instead. The fix did not cause this and it was not among the findings; it is noted here for completeness.

**Final status:** committed
