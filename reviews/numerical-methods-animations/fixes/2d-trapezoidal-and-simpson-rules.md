# Fix record: 2d-trapezoidal-and-simpson-rules

Scratch folder (all evidence, re-runnable): `$FIX` = `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/2d-trapezoidal-and-simpson-rules/fix/`. Scripts are in `$FIX/scripts/`, the old frames in `$FIX/committed/`, and the new frames in `$FIX/new/`.

Decision D1 does not apply: this page's integrand $8e^{-x^2-y^4}$ is smooth on $[0,1]^2$. The round-1 review measured trapezoid error ratios of about 4 and Simpson ratios of 13.8 to 21.7 when $h$ is halved. That text was not changed.

## Findings

### F1 — Minor — fixed
- **Reproduced:** I ran `julia occlusion.jl` (a round-1 script, copied into `$FIX/scripts`), then `python3 -I countcolor.py occl_*.png`. Coloured pixels:
  - surface only: 38577
  - surface plus n=2 wireframe: 2932
  - surface plus n=20 wireframe: 0

  In the committed GIFs, frame 1 has 2146 coloured pixels (trapezoid) and 2183 (Simpson). Frame 8 has 0 in both. At full size, committed Simpson frame 8 shows a black mesh on white. The GR `:wireframe` series is filled opaque and hides the coloured surface.
- **Change:** In both scripts, `surface!(plt, xg, yg, Zg; st=:wireframe, ..., fillalpha=0.0)` became a single `plot!(plt, X, Y, Z; seriestype=:path3d, ...)`. It draws lines only, one polyline per grid line, with the polylines separated by NaN.
  - `trapezoidal2daa.jl`: a new `gridlines(xg, yg)` draws straight segments between nodes.
  - `simpson2daa.jl`: see F2.
  - The now unused `Zg` was removed.
- **Check:**
  - The regenerated GIFs have coloured pixels in every frame:
    - trapezoid frames 1 to 8: 29300 down to 22575;
    - Simpson frames 1 to 8: 29801 down to 23015.

    Command: `countcolor.py $FIX/new/*/frame_*.png`.
  - Frames 1 and 8 of both GIFs and trapezoid frame 5 were viewed at full size. The coloured surface is visible under the black grid in each.
  - The drawn coordinates were dumped by the instrumented copies `instr_trapezoidal2daa.jl` and `instr_simpson2daa.jl`. `check_curves.py` compares them with an independent `scipy` `RegularGridInterpolator(method='linear')`. The largest difference from the bilinear interpolant is 1.3e-15 or less, for every n in the sequence.
  - Side effect, accepted: the GR line series is drawn on top with no hidden-line removal. A few segments behind the ridge crest now show through near the ridge. `hidden.py` compares dark line pixels in the old (depth-sorted) and new trapezoid frames. Pixels that are dark only in the new frames, beyond a 2-pixel tolerance, number 26 to 134 per frame, against 1819 to 7989 line pixels per frame. All of them lie along the ridge (`extra_f3.png`). Removing them would need my own hidden-line code or a different camera, so they were left as they are. See Notes.

### F2 — Minor — fixed
- **Reproduced:**
  - `python3 -I framediff.py $FIX` on the committed frames, below the title band, gives a largest per-pixel |dRGB| of 100 in frame 1 (5 pixels above 60) and 12 in frame 8 (0 pixels above 60). The plot bodies are identical apart from dither.
  - `check_curves.py` confirms that the drawn bilinear mesh integrates to the trapezoid value: at n=2, ∫(bilinear interpolant) = 4.749087736005 = I_T, while the Simpson title shows I_S = 5.106262624.
- **Change:** `simpson2daa.jl` now draws the grid lines of the piecewise-biquadratic interpolant:
  - `quadpieces(t, v)` gives the quadratic through the 3 nodes of each pair of panels;
  - `gridcurves(xg, yg)` applies it along every x = x_i and y = y_j.

  On a node line, the tensor biquadratic interpolant reduces to the 1-D piecewise quadratic through the nodes on that line. The zlims changed from (0, 8.2) to (0, 8.4), because the n=2 quadratic along x=0 peaks at 8.2973, which the old limit clipped. I saw the clipping in the first regenerated frame 1.
- **Check:** `check_curves.py`, for every n in {2,4,6,8,10,12,16,20}:
  - **Drawn curves.** The dumped Simpson curve points match an independently coded tensor-product quadratic-Lagrange interpolant, evaluated in 2-D, to within 3.6e-15.
  - **Integrals.** Each interpolant was integrated with 4×4 Gauss–Legendre per panel, which is exact for these polynomials. The bilinear interpolant gives I_T and the biquadratic interpolant gives I_S, both equal to the script values to 12 decimals. For example, at n=20, I_S = 5.047571483116.
  - **Pixel difference.** `framediff_new.py` now gives large plot-body differences between the Simpson and trapezoid frames: 10684 pixels above 60 in frame 1.
  - **Frames viewed.** Simpson frames 1, 2 and 8 were viewed at full size:
    - frame 1 shows parabolic grid curves, with the x=0 curve no longer clipped;
    - frame 2 (4x4) shows curved patches;
    - the titles are unchanged.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 1 Behavior | "The black lines join the sample nodes with straight segments" | `gridlines` in trapezoidal2daa.jl. Dumped points vs scipy linear interpolant: max deviation ≤1.3e-15 (`check_curves.py`) | yes |
| index.qmd Case 1 Behavior | "grid lines of the piecewise-bilinear interpolant, whose integral is the trapezoidal value $I_T$" | `check_curves.py`: ∫bilinear (Gauss 4×4/panel) = I_T sum = script I_T for all 8 n, e.g. n=2 4.749087736005, n=20 5.044698421647 | yes |
| index.qmd Case 1 alt | "coloured surface of f ... with straight black grid lines through the sample nodes (the bilinear interpolant)" | coloured px 29300 to 22575 in frames 1 to 8 (`countcolor.py`); frames viewed | yes |
| index.qmd Case 1 alt | "from 2x2 to 20x20" | `n_seq = [2, 4, 6, 8, 10, 12, 16, 20]`; frame 1 title "mesh = 2x2", frame 8 title "mesh = 20x20" (viewed) | yes |
| index.qmd Case 2 Behavior | "quadratics through the sample nodes over each pair of panels along every grid line" | `quadpieces`/`gridcurves` in simpson2daa.jl; dumped points vs independent 2-D biquadratic Lagrange: ≤3.6e-15 for all n (`check_curves.py`) | yes |
| index.qmd Case 2 Behavior | "piecewise-biquadratic interpolant (one patch per 2x2 block of panels), whose integral is the Simpson value $I_S$" | `check_curves.py`: ∫biquad (blocks [2b h,(2b+2)h]², Gauss 4×4/panel) = I_S sum = script I_S for all 8 n, e.g. n=2 5.106262624448 | yes |
| index.qmd Case 2 Behavior | "On the 2x2 mesh they differ from the trapezoidal straight lines by up to 0.51 in $z$" | `gap_n2.py` (sympy, exact): max over the 6 grid lines = 0.510946684 on x=0 (others 0.398, 0.190, 0.188, 0.178, 0.070) | yes |
| index.qmd Case 2 alt | "coloured surface of f ... black piecewise-quadratic grid curves through the sample nodes (the biquadratic interpolant)", "from 2x2 to 20x20" | coloured px 29801 to 23015 in frames 1 to 8; `check_curves.py` as above; n_seq and the titles in the viewed frames | yes |
| simpson2daa.jl comment | "the n=2 quadratic along x=0 peaks at about 8.30" | `gap_n2.py`: `maximum` = 8.29733600022; dump max z over all n = 8.2973 (n=2, at x=0, y=0.1875 sample) | yes |
| both scripts' comments | "a :wireframe series is filled opaque by GR and hides the surface" | F1 reproduction: 2932 and 0 coloured px with the wireframe, against 38577 without it | yes |
| GIF titles | unchanged (computation unchanged) | Titles in the new frames 1 and 8 match the round-1 table (e.g. I_S = 5.047571483, \|error\| = 4.676e-6) | yes |

## Scripts and GIFs
- **Scripts changed:** `trapezoidal2daa.jl` (overlay drawing only) and `simpson2daa.jl` (overlay drawing and zlims). The quadrature functions, `n_seq`, `true_val` and the titles are untouched.
- **GIFs regenerated:** `trapezoidal2daa.gif` (md5 719958eb…) and `simpson2daa.gif` (md5 e489fdd8…), 8 frames each, extracted with giftools.jl to `$FIX/new/`.
- **Frames viewed at full size:**
  - trapezoid frames 1, 5 and 8;
  - Simpson frames 1, 2 and 8.
- **What was checked in them:**
  - the surface is visible;
  - the trapezoid lines are straight and the Simpson curves are quadratic;
  - nothing is clipped;
  - the titles are unchanged and legible.
- **git status of the page folder** (`git status --short -- pages/numerical-methods/2d-trapezoidal-and-simpson-rules`): `M index.qmd`, `M simpson2daa.gif`, `M simpson2daa.jl`, `M trapezoidal2daa.gif`, `M trapezoidal2daa.jl`. These are the expected files only.

## Legacy archive
I consulted `n2003/simpsonsrule2dmod.html` and `simpsons2Drule/SimpsonsRule2DMod/Links/*_lnk_1..8.html`.
- **What the archive is.** It has no animations, only static Mathematica output.
- **Examples 1 and 4.** They use the same integrand, the iterated integral of $8e^{-x^2-y^4}$ over the unit square (image gr_133 shows the formula). The grids are m=n=10 for Trapezoid, and m=n=5 then m=n=10 for Simpson.
  - Mathews' Simpson values are 5.04764458608 at m=5 (gr_124) and 5.04757148312 at m=10 (gr_131).
  - These equal the script's I_S at n=10 (5.0476445860761) and at n=20 (5.0475714831165). Mathews' m counts pairs of panels, so his checkpoints are this page's 10x10 and 20x20 frames.
- **Graphics.** Image gr_112 is a coloured surface of f with its plot-mesh lines. Image gr_115 is the region plot.
- **What matches the page.** The page's integrand, domain and mesh checkpoints (10x10, and 20x20 as the finer grid) agree with the archive. The fixed animations now show the coloured surface with a grid, as Mathews' surface plot does.
- **What differs.** Nothing in the archive conflicts with the fix.

## Notes
- **Residual cosmetic artifact.** The GR line overlay has no hidden-line removal. A few back-slope grid segments show through just behind the ridge crest: 26 to 134 extra dark pixels per trapezoid frame, see `hidden.py` and `extra_f3.png`. The old opaque wireframe removed them, but it hid the surface. Removing them would need hidden-line code of my own or a steeper camera. I left them under D5.
- The Simpson GIF's z axis now runs to 8.4, and the trapezoid GIF's still runs to 8.2. The tick labels (0 to 8) are the same in both.
- **Description text not touched.** The Description says "The archived snapshot is incomplete for some intermediate image IDs, so these animations are reconstructed...". No finding names it, so it was not changed. With the archive now available it may be worth re-wording, but that is Jason's call.

## Resolution check (independent checker, not shown this record)

Work files: `check/verify.py` (numbers), `check/pix.py` (pixel counts), `check/run/` (regenerated GIFs), `check/{old,new}_{trapezoidal,simpson}2daa/` (frames). The pre-fix GIFs were taken from `.git/lfs/objects` by their HEAD oids, because `git show` returns only the LFS pointer.

### Original findings

### F1: resolved
- Evidence: both scripts now draw the grid as a `seriestype=:path3d` line series with NaN breaks instead of `st=:wireframe`. In the full-size frames 1, 4 and 8 of both new GIFs, the coloured `:matter` surface is visible under the black lines.
- Saturated-pixel counts (max−min channel > 60):

  | GIF, frame | Old | New |
  |---|---|---|
  | Trapezoidal, frame 1 | 1550 | 23827 |
  | Trapezoidal, frame 4 | 2 | 21302 |
  | Trapezoidal, frame 8 | 0 | 17278 |
  | Simpson, frame 1 | 1734 | 24055 |
  | Simpson, frame 4 | 2 | 21529 |
  | Simpson, frame 8 | 0 | 17492 |

- The alt text now says "coloured surface of f …". That is now true.

### F2: resolved
- Evidence: the Simpson script now draws, along every grid line x = x_i and y = y_j, the piecewise quadratic through the nodes on each pair of panels. The `quadpieces` Lagrange formula is correct, and these curves are exactly the restriction of the piecewise-biquadratic tensor interpolant to the grid lines.
- I integrated that interpolant independently:

  | Mesh | Integral of the interpolant | Rule value |
  |---|---|---|
  | n=2, biquadratic | 5.1062626244475 | I_S = 5.106262624447543 |
  | n=4, sum over the four 2×2 blocks | 5.051811626509 | I_S = 5.051811626509 |
  | n=2, bilinear | 4.749087736005 | I_T = 4.749087736005 |

  So the Simpson picture now shows the object whose integral is I_S, and the Trapezoidal picture shows the object whose integral is I_T.
- In Simpson frame 1, the lines are visibly curved (along x=0 they overshoot to about 8.3). In Trapezoidal frame 1 they are straight.
- Pixels with difference > 60 between the Trapezoidal and Simpson plot bodies (below the title):

  | Frame | Old | New |
  |---|---|---|
  | 1 | 0 | 4131 |
  | 4 | 0 | 9397 |
  | 8 | 0 | 16393 |

  Part of the frame-8 difference comes from the change in zlims (see the note under New problems).

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 1 Behavior | "black lines join the sample nodes with straight segments … grid lines of the piecewise-bilinear interpolant, whose integral is I_T" | The script joins f(x_i,y_j) linearly. The bilinear interpolant restricted to a grid line is linear. Its integral at n=2 equals I_T to 1e-15 (dblquad). | True |
| index.qmd Case 1 alt | "coloured surface of f … straight black grid lines through the sample nodes (the bilinear interpolant), full-grid refinement from 2x2 to 20x20 …" | Frames 1 and 8 match: the surface is visible, the lines are straight, and n_seq = 2…20. | True |
| index.qmd Case 2 Behavior | "quadratics through the sample nodes over each pair of panels along every grid line … piecewise-biquadratic interpolant (one patch per 2x2 block of panels), whose integral is I_S" | The integral of the piecewise-biquadratic interpolant equals I_S at n=2 and n=4 (machine precision). The curves are its grid-line restrictions. | True |
| index.qmd Case 2 Behavior | "differ from the trapezoidal straight lines by up to 0.51 in z" (2x2 mesh) | Maximum \|quadratic − linear\| over the 6 grid lines at n=2 is 0.51095, on x=0. The next largest is 0.398, on x=0.5. | True |
| index.qmd Case 2 alt | "coloured surface of f … black piecewise-quadratic grid curves … (the biquadratic interpolant) … from 2x2 to 20x20" | Matches frames 1, 4 and 8. | True |
| simpson2daa.jl | `zlims = (0.0, 8.4)  # the n=2 quadratic along x=0 peaks at about 8.30` | Peak is 8.29734 at y≈0.1907. The maximum over all curves at all n is 8.2973, which is < 8.4, and the minimum is 1.083, which is > 0. Nothing is clipped. | True |
| both .jl | comment "a :wireframe series is filled opaque by GR and hides the surface" | Consistent with the old frames, where frame 8 has 0 saturated pixels. | True |
| both .jl | `gridlines` / `gridcurves` / `quadpieces` code | Read line by line. NaN separators are correct. The first node of each later pair is skipped to avoid a duplicate. The Lagrange basis is correct. | Correct |
| GIF titles (unchanged code, new frames) | I_T and I_S for n=2…20 | Recomputed independently in numpy for every n. All 9 shown digits match. The reference 5.04756680717 agrees with mpmath, which gives 5.0475668071675. Measured orders by halving: Trapezoidal 2.00, Simpson 4.0. | True |

### New problems
None.

This rests on the following:
- the ledger above;
- full-size inspection of frames 1, 4 and 8 of both GIFs, where titles and axes are legible and the values are correct;
- the regenerated GIFs being byte-identical to the committed ones.

Observation, not a problem: the Simpson GIF now uses zlims (0, 8.4) and the Trapezoidal GIF keeps (0, 8.2), so the two cases are drawn at slightly different vertical scales. This is cosmetic. The axes are labelled and the change is needed to avoid clipping the n=2 overshoot.

The path3d lines are drawn over the semi-transparent surface without depth occlusion, for example the n=2 bilinear segments that lie below f. This is normal for GR and not misleading.

### Reproducibility and conventions
- `simpson2daa.jl` and `trapezoidal2daa.jl` were run from scratch copies. Both outputs are byte-identical (`cmp`) to the committed GIFs:
  - sha256 db5d3f84… (Simpson)
  - sha256 13a13046… (Trapezoidal)
- Each GIF has 8 frames.
- index.qmd conventions:
  - `## Description` comes before `## Animations`.
  - Each case has a `[Julia source]` link and a GIF embed.
  - The alt text is descriptive.
  - There are no code fences.
- The fix diff touches only the page folder. Other modified files in the working tree, such as the numerical-methods index (its Milne-Simpson link), Newton, Pade, Lagrange and Taylor, belong to other pages' fixes and do not involve this page. The section index still links `2d-trapezoidal-and-simpson-rules/`.

**Final status:** committed
