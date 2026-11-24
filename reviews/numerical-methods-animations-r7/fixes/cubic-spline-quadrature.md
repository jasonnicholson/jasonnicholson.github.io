# Fix record: cubic-spline-quadrature

Scratch folder: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/cubic-spline-quadrature/fix/`

## Findings

### F1 — Minor — fixed
- Reproduced:
  - `julia .../r7fix/tools/giftools.jl splinequadaa.gif .../fix/frames` → `21 frames`. All 21 frames are distinct (framemd5: 21 different hashes).
  - `julia -e 'm=collect(3:2:41); println(length(m)," ",first(m)," ",last(m)," total frames ",length(vcat(0,m)))'` → `20 3 41 total frames 21`.
  - Viewed `frames/frame_001.png` at full size: only the magenta $f$ curve, with no spline, nodes, fill or labels. `frame_002.png` shows "Sample Points = 3, Approximation = 2.461678". `frame_021.png` shows "Sample Points = 41, Approximation = 2.012209". The contact sheet shows the counts 5, 9, …, 41 rising on frames 3, 5, …, 21.
  - Script: `for m in vcat(0, m_seq)` (line 69), and spline drawn only `if m > 0` (line 75).
  - So the sentences "Each frame recomputes…" (index.qmd line 25) and the alt text "each frame increases sample points…" (line 36) are false for frame 1.
- Change: `index.qmd` only (R7-D/D7: correct the text and leave the animation alone).
  - Line 25: "Each frame recomputes the spline…" → "After an opening frame showing $f$ alone, each frame recomputes the spline…"
  - Line 36 alt text: "…density refinement: each frame increases sample points…" → "…density refinement: after an opening frame of the curve alone, each frame increases sample points…"
- Check: `git diff` shows only these two lines changed. The new wording matches frame 1 (curve only) and frames 2–21 (m = 3, 5, …, 41, one spline rebuild per frame), as computed and viewed above.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.25 | "After an opening frame showing $f$ alone" | frame_001.png viewed: magenta $f$ only; script line 69 `vcat(0, m_seq)`, line 75 `if m > 0` | yes |
| index.qmd l.25 (unchanged numbers) | "each frame … $m=3$ to $m=41$" now covers frames 2–21 | `collect(3:2:41)` → 20 values, 3…41; giftools → 21 frames; frame_002 "Sample Points = 3", frame_021 "Sample Points = 41" | yes |
| index.qmd l.36 alt | "after an opening frame of the curve alone, each frame increases sample points, rebuilds the spline, and updates the integral estimate" | same as above; the contact sheet shows the counts rising and the approximation label changing on every frame from 2 on | yes |

## Scripts and GIFs
- No script changed and no GIF regenerated.
- Frames of the committed `splinequadaa.gif` were extracted to `fix/frames/`. Frames 1, 2 and 21 were viewed at full size, and the rest on `sheet.png`.
- `git status --short -- pages/numerical-methods/cubic-spline-quadrature` → ` M pages/numerical-methods/cubic-spline-quadrature/index.qmd` (nothing else).

## Legacy archive
- Consulted. The legacy animation is `a2001/Animations/Quadrature/Spline/Splineaa.gif`, extracted with giftools to `fix/legacy/` (24 frames). Its `frame_001.png` also shows $y=e^{-x}\sin(8x^{2/3})+1$ alone under the title "Natural Cubic Spline For Numerical Quadrature". So the page's opening frame follows Mathews, and only the wording needed correcting.
- The round-7 review records that the source is Mathews Example 6 (`n2003/SplineQuadMod`), with m = 3, 5, …, 41. This fix changes no number, so I did not recheck the review's table comparison.

## Notes
- No ambiguity in the decisions: R7-A (fix all) and R7-D/D7 (correct the text, keep the animation).
- The Animations intro says "Each animation below", although the page has only one animation. This was not a finding, so I left it unchanged.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the diff changes only `index.qmd` lines 25 and 36. Line 25 now reads "After an opening frame showing $f$ alone, each frame recomputes the spline over the full interval using a denser odd sample count from $m=3$ to $m=41$ points." The alt text (line 36) now reads "after an opening frame of the curve alone, each frame increases sample points, rebuilds the spline, and updates the integral estimate".
- I extracted the committed GIF with giftools.jl and got 21 frames. Frame 1 at full size shows only the magenta $f$ curve and the title: no spline, nodes, fill or annotations. Frame 2 shows "Sample Points = 3", frame 11 shows "Sample Points = 21" and frame 21 shows "Sample Points = 41". That fits frame k showing $m=2k-1$, which gives the 20 odd values 3..41 from `collect(3:2:41)` after the `m == 0` opening frame (`vcat(0, m_seq)`, `if m > 0`). Both new statements are true.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd L25 | "After an opening frame showing $f$ alone" | frame_001.png shows the curve only; script `m=0` branch skips the spline | True |
| index.qmd L25 | "each frame recomputes ... odd sample count from $m=3$ to $m=41$" (unchanged numbers) | frames 2/11/21 read m=3/21/41; `3:2:41` gives 20 odd values | True |
| index.qmd L36 alt | "after an opening frame of the curve alone, each frame increases sample points, rebuilds the spline, and updates the integral estimate" | the same frame evidence; the Approximation label changes per frame (2.461678 at m=3, 2.000544 at m=21, 2.012209 at m=41) | True |

### New problems
None. This rests on the following: the diff has only the two text edits above, both checked against the frames and the script. No script or GIF changed, and the rest of the page is untouched.

### Reproducibility and conventions
- Ran a scratch copy of `splinequadaa.jl`. The GIF it wrote is byte-identical to the committed `splinequadaa.gif` (cmp). The GIF itself is unchanged by this fix.
- `git status --porcelain` and `git diff --stat HEAD` on the page folder show only `index.qmd` modified (2 insertions, 2 deletions). The fix diff lists no other file.
- Conventions kept: Description comes before Animations, there is one case with a `[Julia source](splinequadaa.jl)` link and a GIF embed, the alt text is descriptive, and there are no code blocks.

**Final status:** committed
