# Fix record: booles-rule

Scratch folder (all evidence, re-runnable): `$F = /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/booles-rule/fix/`

## Findings

### F1 — Minor (fidelity) — fixed

- **Reproduced.**
  - Code: `boolesaa.jl` (before) has no `scatter!` call and no divider segments. Each block is only `plot!(xp, yp; fillrange=0, fillcolor=:lightpink, linecolor=:red, lw=0.8)`.
  - Frames: `julia giftools.jl boolesaa.gif $F/before`. Frame 24 (n=120) viewed at full size shows a uniform pink fill under the magenta curve, with no visible nodes or block boundaries. Pure-red pixel count (R>200, G<60, B<60) inside the plot box: frame 5 → 52, frame 24 → 0 (`$F`, inline python). After the fix: 391 and 4096.
  - Legacy: `julia giftools.jl .../a2001/Animations/Quadrature/Boole/Booleaa.gif $F/legacy`. Mathews' frames draw a red dot at every sample point and a red vertical line at every block boundary x_{4k}, including both endpoints. `$F/legacy_cols.py` samples row y=400:
    - frame 5 (5 points, n=4): red columns 25 and 625, which are x=0 and x=2;
    - frame 6 (9 points, n=8): red columns 25, 325 and 625, which are x=0, 1 and 2;
    - colour (255,0,0), fill (255,189,206).
- **Change.** `boolesaa.jl` uses the Simpson R2-A picture pattern with stride 4:
  - `xlims` (0.0, 2.0) → (-0.03, 2.03), so the end dots are not clipped;
  - after the block fills: dividers `for i in 0:4:n; xk = a + i*dx; plot!([xk,xk],[0.0,f(xk)]; color=:red, lw=0.8)`;
  - after the magenta curve: `scatter!` at `xnodes = [a + i*dx for i in 0:n]`, `color=:red, markersize=3, markerstrokewidth=0`.
  - z-order: fills → dividers → curve → dots.
  - The reviewer suggested dividers at k = 1..n/4−1 only. I used k = 0..n/4, which includes both endpoints, as the legacy GIF and the Simpson pattern do.
  - `index.qmd`: the Animations intro and the alt text now name the opening f-only frame, the red dots and the red boundary lines, worded as on the Simpson page.
- **Check.**
  - Instrumented copy `$F/boolesaa_instr.jl` (plain loop, reads `Plots.current().series_list`). For all 23 values of n:
    - scatter count = n+1, with x bit-equal to `a+i*dx` and y == f;
    - divider count = n/4+1, at x = a+4k·dx with y = [0, f];
    - series order matches `^P+D+CS$`;
    - n=0 has no scatter and no dividers;
    - `boole_sum` values are unchanged (n=4 → 1.5531546827, n=8 → 1.9634127276, n=64 → 2.0153696865, n=120 → 2.0159611789; these equal the reviewer's table).
  - Independent pixel check `/usr/bin/python3 -I $F/pixelcheck.py $F/after`. Box 39–617.5 × 50–449, mapped with the new xlims.
    - Frame 1: 0 red pixels.
    - Frames 2–24: dots n+1/n+1 found, and dividers n/4+1/n/4+1 found at 20/50/80 % height.
    - Control: 0 red pixels at non-boundary nodes (i mod 4 ≠ 0).
    - Result: `ALL OK`.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Animations intro | "After an opening frame showing only $f$," | `boolesaa_instr.jl` n=0 → scatter=0, dividers=0, no annotation branch (`if n > 0`); `pixelcheck.py` frame 1 → 0 red pixels in box; frame 1 viewed in `$F/after/sheet.png` shows only the magenta curve | yes |
| index.qmd Animations intro | "each frame recomputes … multiple of 4" (unchanged wording, now after the clause) | n_seq all multiples of 4; instr prints full-interval `boole_sum(n)` per frame | yes |
| index.qmd Animations intro | "Red dots mark the sample points $x_i$" | instr: scatter n+1 points at `a+i*dx`, i=0..n, y=f, every frame; pixelcheck: dots n+1/n+1 in frames 2–24 | yes |
| index.qmd Animations intro | "vertical red lines mark the panel boundaries $x_{4k}$" | instr: n/4+1 segments at x=a+4k·dx, k=0..n/4, y=[0,f]; pixelcheck: dividers n/4+1/n/4+1 and 0 red pixels at non-boundary nodes | yes |
| index.qmd alt text | "after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise quartic panels and the global approximation" | same checks as above; the quartic fills are still drawn (P series first in each frame); "Approximation = …" annotation present in frames 2–24 (sheet + frames 2, 24 viewed) | yes |
| boolesaa.jl comments | "Panel dividers at every block boundary x_{4k}, k = 0..n/4"; "Sample points x_i = a + i*dx, i = 0..n" | same as instr checks | yes |
| GIF title / annotations | unchanged ("Boole's Rule / Numerical Quadrature", "Sample Points = n+1", "Approximation = …") | values identical to before (instr list above) | yes |

The Behavior paragraph is unchanged. Its claim "Piecewise quartic panels are rebuilt at increasing density" now refers to visible panels, because the boundaries are drawn in every frame. None of its numbers depend on the drawing.

## Scripts and GIFs

- Script changed: `pages/numerical-methods/booles-rule/boolesaa.jl`. It was regenerated in place with `julia boolesaa.jl`, which printed "Saved: boolesaa.gif".
- GIF regenerated: `boolesaa.gif` (24 frames).
- Frames viewed at full size:
  - frame 2 (n=4): one quartic panel, 5 dots, dividers at x=0 and x=2;
  - frame 24 (n=120): 121 dots and 31 dividers; the annotation text does not overlap any dot;
  - zoom `$F/zoom24.png`: the end dots at x=0 and x=2 are whole (not clipped), and adjacent dots near the peak touch but stay distinguishable.
- Contact sheet `$F/after/sheet.png` (frames 1, 3, 5, …, 23) viewed: panel structure visible throughout.
- `git status --short -- pages/numerical-methods/booles-rule` → ` M boolesaa.gif`, ` M boolesaa.jl`, ` M index.qmd` (expected).

## Legacy archive

Consulted.
- `a2001/Animations/Quadrature/Boole/Booleaa.gif`: same f, the same interval [0,2] and the same approximations (5 → 1.553155, 13 → 2.001295, 121 → 2.015961). It draws a red dot at every sample point and red block-boundary lines from 0 to f, including both endpoints. The fixed animation now matches these elements.
- Remaining differences, which are cosmetic and left alone:
  - Mathews prints the formula of f and the title in the plot. This page keeps its own title and states f in the text.
  - The legacy GIF opens with two f-only frames. This one opens with one f-only frame and shows 23 values of n.
- `n2003/BooleRuleMod.html` holds the module's theory, Examples 1–10 on other integrals (true value, error, step-halving) and Example 11, the animated example.

## Notes

- **R2-A "left out" sentence: not added.** The module's Examples 1–10 are not animated on this page. R2-A's "add one sentence when a whole Mathews example or topic is left out" could apply, but no finding names it. Under the lessons rule (pre-existing gaps that no finding names go to Notes), I did not add it. Director's call.
- **Frame n=64 label.** It reads "Approximation = 2.01537", because `round` drops the trailing zero of 2.015370. The value is not false and this is not a finding, so I left it. Reviewer ledger G1 calls it cosmetic.
- **Divider range.** The reviewer's suggestion drew interior dividers only (k = 1..n/4−1). I followed the legacy GIF and the Simpson pattern, which include both endpoints.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence (script): `boolesaa.jl` now draws a vertical red line from 0 to f(x_{4k}) at every block boundary (`for i in 0:4:n`, x = a + i*dx; this includes both ends of [0,2]). It also scatters all n+1 nodes x_i = a + i*dx, i = 0..n, at f(x_i), after the magenta curve so they sit on top. x-limits are widened to (-0.03, 2.03) so the end dots are not clipped. Nothing that computes the approximation changed.
- Evidence (frames): I extracted all 24 frames of the committed GIF (`check/new/`) and viewed frames 1, 2, 12 and 24 at full size, plus the contact sheet.
  - Frame 1 (n = 0) shows f only.
  - Frame 2 (n = 4) has 5 dots and dividers at x = 0 and 2. The single quartic visibly passes through the 5 dots.
  - Frame 12 (n = 44) has 45 dots and 12 dividers at multiples of 2/11 (0.18, 0.36, …, 2.0), which is 11 blocks.
  - Frame 24 (n = 120) has 121 dots and 31 dividers at multiples of 1/15.
  - The late frames now show the 5-node block structure, as the legacy `Booleaa.gif` frame 24 does (legacy draws dark dividers and red dots; same layout).
- The Behavior sentence "Piecewise quartic panels are rebuilt at increasing density" and the alt text now describe what is visible.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Animations intro | "After an opening frame showing only $f$, each frame recomputes … $n$ remains a multiple of 4" | Script loops over `vcat(0, n_seq)`; the n = 0 branch draws only f. Frame 1 viewed: curve only, no annotations. All n in n_seq are multiples of 4. | correct |
| Animations intro | "Red dots mark the sample points $x_i$" | `scatter!` of x_i = i·h, i = 0..n, color red, at f(x_i). Dot counts in frames 2/12/24 = 5/45/121. | correct |
| Animations intro | "vertical red lines mark the panel boundaries $x_{4k}$" | Lines at i = 0,4,…,n from 0 to f(x_i), red. Frame 12 has 12 lines for 11 blocks; frame 24 has 31 for 30. | correct |
| Alt text | "after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise quartic panels and the global approximation" | Same checks as above. The pink-filled quartics (red outline) and the "Approximation =" label are present in every frame from 2 on. | correct |
| Frame labels (unchanged code, regenerated) | Sample Points / Approximation for all 23 n | Independent mpmath (30 digits) composite Boole sums: 5→1.553155, 9→1.963413, 17→2.007328, 25→2.011644, 33→2.013393, 41→2.014287, 45→2.014579, 49→2.014809, 57→2.015142, 65→2.01537, 81→2.015653, 97→2.015817, 113→2.015922, 121→2.015961. All match the frames shown. | correct |
| Behavior (unchanged, re-checked) | ∫ ≈ 2.016280; 121 → 2.015961, 3.2e-4 low; ratio 3.18 (60→120) | mpmath quad: 2.01627972. Error at n = 120 is 3.19e-4. Error ratio between n = 60 and n = 120 is 3.182. The sequence increases monotonically and stays below the integral. | correct |

### New problems
None. This rests on:
- the full-size frames 1, 2, 12 and 24 and the contact sheet (no clipping, labels legible, dividers and dots at the right abscissae and ordinates);
- independent recomputation of every frame label;
- the script diff, which touches only drawing.

Cosmetic note, not a defect: dividers are drawn at the interval ends x_0 and x_n as well as the interior boundaries. That is consistent with "panel boundaries $x_{4k}$".

### Reproducibility and conventions
- I ran a scratch copy of `boolesaa.jl` (`check/run/`). Its output is byte-identical to the committed GIF (sha256 17e9dc75…55f3).
- Page structure is intact:
  - Description comes before Animations.
  - There is one case, with a `[Julia source](boolesaa.jl)` link and a GIF embed.
  - The alt text is descriptive.
  - There are no code blocks.
- Outside `pages/numerical-methods/booles-rule/`, the only files touching Boole are the workflow's own fix record (`reviews/numerical-methods-animations-r2/fixes/booles-rule.md`) and the shared worklist. I did not read either, as instructed. Nothing else outside the page folder is attributable to this fix.

**Final status:** committed
