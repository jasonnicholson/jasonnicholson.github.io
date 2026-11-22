# Fix record: simpsons-rule-for-numerical-integration

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/simpsons-rule-for-numerical-integration/fix/` (below: `$F`).

## Findings

### F1 — Minor — fixed (text)
- Reproduced: frames of the committed GIF extracted to `$F/committed/` with `giftools.jl`. `frame_001.png` viewed: magenta curve and title only. Pixel count (`/usr/bin/python3`, PIL): frame 1 has 1 pink pixel and 0 red pixels. Frames 2, 12 and 24 have 134033, 108392 and 108692 pink pixels. All 24 frame hashes are distinct (`frames.md5`). The cause is `vcat(0, n_seq)` with the `if n > 0` guard in `simpsonsaa.jl`.
- Change: kept the opening frame, because Mathews' GIF also opens with frames that show only f (legacy frames 1–3 are identical title frames; see Legacy archive). Under D7 the text now describes the animation. `index.qmd` line 23: "Each frame redraws …" → "After an opening frame showing only $f$, each frame redraws …". The alt text on line 33 now starts "after an opening frame showing only f, each frame shows …".
- Check: regenerated `frame_001.png` viewed (curve only). The pixel count gives 0 pink and 0 red pixels in frame 1. Frames 2–24 all carry the partition, markers and annotation (`$F/pixelcheck_final.txt`, 23 × OK).

### F2 — Minor — fixed (script + regenerated GIF + text)
- Reproduced: committed `frame_024.png` viewed. It shows a uniform pink fill under the curve, with no dots and no dividers. The pixel count gives **0** pure-red pixels in frame 24, so even the 0.8-pt red panel edges are hidden under the 2-pt magenta curve. Script lines 41–55 draw only fills plus edges. Legacy `Simpsonaa.gif` frames 6 and 24 viewed: there is a red dot at every sample point and a red vertical line at every $x_{2k}$ (see Legacy archive).
- Change (`simpsonsaa.jl`), following R2-A (missing picture elements follow Mathews):
  - added panel dividers: one red line, `lw=0.8`, from $y=0$ to $f(x_{2k})$ at each $x_{2k}=a+2k\,dx$, $k=0..n/2$ (endpoints included, as in the legacy GIF);
  - added sample-point markers: `scatter!` at $x_i=a+i\,dx$, $i=0..n$, in red, `markersize=3`, `markerstrokewidth=0`, drawn after the magenta curve so they sit on top;
  - `xlims` `(0.0, 2.0)` → `(-0.03, 2.03)`. Without the margin, the box clipped the dots at $x=0$ and $x=2$ to half dots (seen in `$F/new1/crop02_left.png`).
  - `index.qmd` line 23 gains "Red dots mark the sample points $x_i$, and vertical red lines mark the panel boundaries $x_{2k}$." The alt text names the dots and lines.
- Check:
  - Instrumented copy `$F/simpsonsaa_instr.jl` (`julia simpsonsaa_instr.jl`) inspects each frame's series list. For every n in the sequence, the scatter series has exactly n+1 points with x bit-identical to `a + i*dx` (the nodes `simpson_sum` uses) and y = f(x). There are exactly n/2+1 divider segments, at `a + i*dx` for i = 0:2:n, each from 0 to f(x_{2k}). Series order per frame is fills → dividers → curve → scatter. For n = 0 there is no scatter and no divider. Output: 24 lines, all `okpts=true okdv=true`, `order=PDCS` (n = 0: `order=C`).
  - Independent pixel check `$F/pixelcheck.py` (`/usr/bin/python3 -I pixelcheck.py $F/final`) calibrates the plot box from the frame (L=39, R=617.5, T=50, B=449 px) and, for each frame 2–24, predicts the pixel of every $(x_i,f(x_i))$ and of every divider at 20/50/80 % of its height. It finds red at all of them (e.g. frame 24: dots 109/109, dividers 55/55). It finds **no** red at mid-height above the odd nodes $x_{2k+1}$, which have no divider. Result `ALL OK`.
  - Frames viewed: 1, 2, 3, 12 and 24 full size, plus the contact sheet and zooms of the end dots (`$F/final/crop02_left.png`, `crop24_right.png`: full round dots inside the box).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.23 | "After an opening frame showing only $f$" | Regenerated `frame_001.png` viewed: curve only. `pixelcheck`-style count: frame 1 has 0 pink and 0 red pixels. Script: n = 0 skips the fills, dividers, annotation and scatter (instr. `n=0 pts=0 dividers=0 order=C`) | yes |
| index.qmd l.23 | "each frame redraws the entire interval using a denser even partition" (unchanged words, now scoped to frames after the first) | `$F/indep.py` → `even: True strictly increasing: True frames incl. opening: 24`. Dividers at x=0 and x=2 are present in every frame 2–24 (pixel check: dividers n/2+1 of n/2+1, which includes both ends) | yes |
| index.qmd l.23 | "Red dots mark the sample points $x_i$" | instr.: scatter x == `a+i*dx`, i = 0..n, y == f(x), for all 23 n. Pixel check: 3/3 … 109/109 dots found. The marker colour is `:red` in the script | yes |
| index.qmd l.23 | "vertical red lines mark the panel boundaries $x_{2k}$" | instr.: divider x == `a+i*dx`, i = 0:2:n (n/2+1 lines). Panels span $[x_{2k},x_{2k+2}]$ (script loop `for i in 0:2:n-2`, review ledger #1). Pixel check: 2/2 … 55/55 found, 0 red at odd nodes | yes |
| index.qmd l.33 alt | "after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise quadratic panels and the global approximation" | Same checks as the three rows above. The panels and approximation are unchanged from the committed script (`simpson_sum` untouched). Approximations on viewed frames: frame 2 "2.491261", frame 3 "1.611786", frame 12 "2.01037", frame 24 "2.015834", against `$F/indep.py` (mpmath) values 2.49126101725, 1.61178632865, 2.01036962937, 2.015834216 | yes |
| index.qmd l.29 (unchanged) | 109 sample points, 2.015834, about 0.00045 low, $I\approx2.016280$ | `$F/indep.py` → `108 109 pts 2.015834216`, `I 2.0162797196171 I-S108 0.000445504`. No number on the page changed | yes |
| simpsonsaa.jl comments | "Panel dividers at every panel boundary x_{2k}, k = 0..n/2"; "Sample points x_i = a + i*dx, i = 0..n" | instr. output above | yes |

## Scripts and GIFs
- Script changed: `simpsonsaa.jl` (dividers, scatter, x margin). The computation (`simpson_sum`, panel fits, `n_seq`, annotations) is untouched.
- GIF regenerated in place (`cd pages/numerical-methods/simpsons-rule-for-numerical-integration && julia simpsonsaa.jl`): `simpsonsaa.gif`, 24 frames, 24 distinct, 500 ms each (unchanged pacing), md5 `4a1d9d52a66558b5f85f524be207401a`. It is byte-identical to the scratch run `$F/try/simpsonsaa.gif` (`cmp`).
- Frames viewed (`$F/final/`): 1 (curve only), 2 (n=2: 3 dots, dividers at 0 and 2 only, no interior divider), 3 (n=4: 5 dots, dividers at 0, 1, 2), 12 (n=24: 25 dots, 13 dividers, "2.01037"), 24 (n=108: 109 dots, 55 dividers, "2.015834"), and `sheet.png`. Titles and annotations are legible. Everything lies inside the window: y from 0 to max f ≈ 1.92 < 2.1, and the end dots are no longer clipped.
- `git status --short -- pages/numerical-methods/simpsons-rule-for-numerical-integration`:
  ```
   M .../index.qmd
   M .../simpsonsaa.gif
   M .../simpsonsaa.jl
  ```

## Legacy archive
Consulted.
- `n2003/simpsonsrulemod.html` (text): the composite Simpson theorem; no animation parameters.
- `a2001/Animations/Quadrature/Simpson/Simpsonaa.gif`: 630×480, 24 frames, 1000 ms each.
  - Frames 1–3 are identical title frames ("Simpson's Rule For Numerical Quadrature") showing only the magenta curve.
  - Frames 4–5 show 3 points; then 5, 7, …, 41 points (n = 2, 4, …, 40).
  - The last frame shows "Sample Points = 41, Approximation = 2.013890".
  - Each data frame draws a pink fill, a red parabola edge, a red dot at every sample point, and a 1-px pure-red (255,0,0) vertical line from the baseline to $f(x_{2k})$ at every $x_{2k}$, including x=0 and x=2. Pixel columns 25 and 625 of frame 6 are red over 189 and 193 rows.
  - The formula $y=e^{-x}\sin(8x^{2/3})+1$ is printed top-left.
- The page now matches the legacy picture elements (dots, dividers) and, like the legacy, opens with a curve-only frame. The legacy values the review cross-checked (2.491261, 1.840560, 1.976389, 1.998814, 2.006018, 2.013890) equal the script's. No conflict with the mathematics.

## Notes
- Not changed, recorded for Jason:
  - (a) The legacy prints the formula in the frame; the Julia GIF does not. The finding's fix did not ask for it, and the formula is in the page heading and Animations text.
  - (b) The legacy sweeps n = 2…40 (41 points). The Julia script goes to n = 108 with a non-uniform sequence. This was not a finding, and the page's numbers are tied to the 109-point frame.
  - (c) The legacy holds the title for 3 s at 1 s/frame. The Julia GIF shows one 0.5 s opening frame at 2 fps.
- The margin `xlims = (-0.03, 2.03)` is a small departure from a frame that hugs [0,2]. Without it the end dots are half-clipped by GR's plot-area clipping. The integration interval, the fills and the text "over $[0,2]$" are unaffected.

### R2-A picture pattern for other quadrature pages
For Simpson 3/8, Newton-Cotes and Boole (same Mathews family, `a2001/Animations/Quadrature/<topic>/`).

**What Mathews' GIF draws** (`/home/jason/Desktop/math-fullerton/baseline/mathews/a2001/Animations/Quadrature/Simpson/Simpsonaa.gif`; frames 1, 3, 6, 24 viewed full size, plus the contact sheet):
- a pink fill under each interpolating polynomial panel, with a red polynomial edge;
- a **red dot at every sample point** $(x_i,f(x_i))$, $i=0..n$, drawn on top of the curve;
- a **1-px red vertical divider at every panel boundary** (for Simpson $x_{2k}$, $k=0..n/2$, *including both endpoints*), from the baseline $y=0$ up to $f$ at that node, with no lines at interior nodes of a panel;
- the magenta curve;
- the formula label.
- Colours sampled from the frames: dots and dividers (255,0,0); fill (255,189,198/206).

**What was added to `simpsonsaa.jl`** (inside the frame loop):
```julia
xlims = (-0.03, 2.03)   # small margin so the end sample points are not clipped
...
    if n > 0
        dx = (b - a) / n
        # ... existing panel fills (fillcolor=:lightpink, linecolor=:red, lw=0.8) ...

        # Panel dividers at every panel boundary x_{2k}, k = 0..n/2 (as in the legacy GIF)
        for i in 0:2:n
            xk = a + i * dx
            plot!([xk, xk], [0.0, f(xk)]; color=:red, lw=0.8)
        end
        # ... existing annotations ...
    end

    plot!(xplot, f.(xplot); color=:magenta, lw=2)

    if n > 0
        # Sample points x_i = a + i*dx, i = 0..n, drawn on top (as in the legacy GIF)
        xnodes = [a + i * dx for i in 0:n]
        scatter!(xnodes, f.(xnodes); color=:red, markersize=3, markerstrokewidth=0)
    end
```
- Style: dividers `:red`, `lw=0.8`, from 0 to `f(x)`; markers `:red`, `markersize=3`, `markerstrokewidth=0`.
- z-order: fills → dividers → magenta curve → markers.
- For the other rules, change the divider stride to the panel width: `0:3:n` for 3/8, `0:4:n` for Boole, and `0:m:n` for an m-point Newton-Cotes panel.
- Build the nodes with the **same expression the quadrature sum uses** (`a + i*dx`). `a + i*(b-a)/n` rounds differently, and the exact-equality check then fails.
- `dx` from the first `if n > 0` block is visible in the second block (Julia `if` does not open a scope).
- Add the small x-margin, or the dots at $a$ and $b$ are clipped to half dots by the box.
- At `markersize=3` the dots are about 6 px across. At 109 points (≈5.4 px spacing) adjacent dots touch near the steep peak but stay distinguishable. Re-check this if a page goes denser.

**How it was checked in the frames:**
1. An instrumented copy (`$F/simpsonsaa_instr.jl`) replaces `@animate` with a plain loop and, per frame, reads `Plots.current().series_list`:
   - the scatter count is n+1, with x bit-equal to `a+i*dx` and y == f;
   - there are n/2+1 two-point vertical segments at `a+i*dx`, `i in 0:2:n`, with y = [0, f];
   - the series order is fills → dividers → curve → scatter (`PDCS`).
2. An independent pixel check (`$F/pixelcheck.py`):
   - it finds the plot box from the dark frame columns and rows of frame 1, and maps data to pixels with the xlims/ylims;
   - it requires a red pixel (R>200, G<170, B<170) within ±1 px of every predicted dot and at 20/50/80 % of every divider's height;
   - it requires *no* red at odd nodes (a control against false positives);
   - G<170 is needed because a 0.8-pt line that lands between pixel columns renders as two pale pixels ≈(255,120–129,123–133); the fill is (255,207,214).
3. Frames viewed: first, n=2, n=4, a middle frame and the last, plus zooms of the end dots.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The fixer kept the opening frame and changed the text instead of the script, as F1's first option allowed. Line 23 now reads "After an opening frame showing only $f$, each frame redraws the entire interval using a denser even partition." The alt text (line 33) now reads "after an opening frame showing only f, each frame shows ...".
- In the committed GIF (`check/new/frame_001.png`), frame 1 shows only the magenta curve and the title: no fill, no dots, no dividers and no annotation. In the script, `vcat(0, n_seq)` together with both `if n > 0` guards (lines 39 and 70) keeps the sample-point scatter out of frame 1.
- Frames 2 to 24 each show a partition with n = 2, 4, ..., 108. The contact sheet `check/new/sheet.png` confirms that n grows monotonically.

### F2 — resolved
- Evidence: Script lines 57-61 now draw a vertical red line from 0 to f(x_{2k}) at each x_{2k}, for i in 0:2:n. Lines 70-74 draw `scatter!` red dots at (x_i, f(x_i)) for i = 0..n, on top of the curve.
- Pixel scan of a row near y = 0.05 (`check/px.py`). Expected count is n/2+1:

  | Frame | n | Red vertical runs found | Expected |
  |---|---|---|---|
  | 2 | 2 | 2 | 2 |
  | 3 | 4 | 3 | 3 |
  | 12 | 24 | 13 | 13 |
  | 24 | 108 | 55 | 55 |

  The pre-fix GIF, scanned the same way, has 0 runs in every one of these frames.
- Full-size frames 2, 12 and 24 show one dot per sample point (3, 25 and 109). The dots sit on the magenta curve. The dividers run up to the curve at every second node.
- This now matches the legacy `a2001/Animations/Quadrature/Simpson/Simpsonaa.gif` (frame 24, 41 points): red dots at every node and a divider at each panel boundary.
- The fix follows R2-A ("panel markers on Simpson").
- Residual, not required by F2's Fix line: the legacy frame also prints the formula y = e^{-x} sin(8x^{2/3}) + 1 in the plot. The Julia frames still do not. The page text names the function directly above the GIF, so I do not count this as a defect.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.23 | "After an opening frame showing only $f$" | frame_001.png shows only f and the title | true |
| index.qmd l.23 | "each frame redraws the entire interval using a denser even partition" | Frames 2-24 use n = 2..108, all even and strictly increasing, each spanning [0,2] | true |
| index.qmd l.23 | "Red dots mark the sample points $x_i$" | scatter at a+i·dx, i=0..n. Dots counted visually in frames 2 and 12: 3 and 25 | true |
| index.qmd l.23 | "vertical red lines mark the panel boundaries $x_{2k}$" | Pixel scan gives n/2+1 lines in frames 2, 3, 12 and 24 | true |
| index.qmd l.33 alt | "after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise quadratic panels and the global approximation" | Same frame evidence. Each of frames 2-24 has fill, dots, dividers and an "Approximation =" label | true |
| simpsonsaa.jl l.15 | xlims = (-0.03, 2.03) | Frames 2 and 24: the end dots at x=0 and x=2 are fully visible and the ticks are unchanged | fine |
| GIF labels (not changed, re-verified) | 2.491261 (n=2), 2.003209 (n=16), 2.01037 (n=24), 2.015834 (n=108) | Composite Simpson computed in mpmath at 30 digits: 2.491261017, 2.003209499, 2.010369629, 2.015834216 | match |
| index.qmd l.29 (not changed) | I ≈ 2.016280; 2.015834 about 0.00045 low; ratio 3.38 (24→48); 2^{5/3} ≈ 3.17 | mpmath gives I = 2.0162797196, S_108 − I = −0.0004455, (S_24−I)/(S_48−I) = 3.3803, and 2^{5/3} = 3.1748 | true |

### New problems
None introduced by the fix. This rests on the following:
- Full-size frames 1, 2, 12 and 24 and the contact sheet were all inspected. The new elements do not hide any label.
- The annotation values are unchanged and correct.
- The curve, fill and title are as before. The only other change is the x-axis margin of 0.03, which is harmless.

Pre-existing observation, unchanged by this fix: `round(approx; digits=6)` drops trailing zeros. The n=24 frame shows "2.01037" and the n=72 frame shows "2.0154", where 2.010370 and 2.015400 would be expected. This is cosmetic only, and the round-2 findings did not raise it.

### Reproducibility and conventions
- **Reproducibility.** I ran a scratch copy of `simpsonsaa.jl`. Its output is byte-identical to the committed `simpsonsaa.gif` (`cmp` returns equal), and the decoded frame md5s are identical. I also regenerated the pre-fix script from HEAD. Its output's sha256 (9c639d24...) equals the HEAD LFS oid, so the environment reproduces the committed baseline.
- **Conventions.**
  - Description comes before Animations.
  - The single case has a "[Julia source](simpsonsaa.jl)" link and a GIF embed with descriptive alt text.
  - There are no code blocks.
- **Scope.** This page's diff touches only `index.qmd`, `simpsonsaa.jl` and `simpsonsaa.gif` inside the page folder. Other modified paths in the working tree belong to other pages (bisection-method, monte-carlo-pi, runge-kutta-method) and to the round-2 fix records, not to this page's fix.

**Final status:** committed
