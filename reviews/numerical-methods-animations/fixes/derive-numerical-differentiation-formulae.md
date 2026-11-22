# Fix record: derive-numerical-differentiation-formulae

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/derive-numerical-differentiation-formulae/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.out`, frames in `$FIX/orig_frames/` (committed GIFs) and `$FIX/new_frames/` (regenerated GIFs).

- `inst.jl` (`julia inst.jl` → `inst.out`): instrumented copy of the numerics of `diffformab.jl` and `diffformac.jl`, no plotting. It prints the raw errors, the old annotation strings (`round(...; digits=6/8)`) and the new ones (`@sprintf("%.2e", ...)`).
- `indep.py` (`/usr/bin/python3 -I indep.py` → `indep.out`): independent check. sympy confirms the scripts' `fp` and `fpp`. Each formula is evaluated in IEEE double (numpy) and compared with the mpmath (40-digit) exact derivative; this is what a label should show. It is also evaluated in mpmath, which gives the truncation error alone.
- `bigcheck.jl` (`julia bigcheck.jl` → `bigcheck.out`): Julia double estimate against a 200-bit BigFloat exact $f'(1)$, for the two smallest $h$ of Case 2.
- `textcheck.py` (`/usr/bin/python3 -I textcheck.py` → `textcheck.out`): checks the Behavior claims against the values in `inst.out`.

## Findings

### F1 — Error — fixed

- **Reproduced:** `diffformac.jl` has no `x0`. The only spatial variables are `xtrue = range(0, pi, 900)` and `xinner = range(2h, pi-2h, 700)`. The frame title reads "Second-derivative formulas on [0, pi] | h = …". Committed frames `$FIX/orig_frames/diffformac/frame_001.png` and `frame_011.png` have no marker or annotation at x = 1. The heading "at $x_0=1$" does not describe the animation.
- **Change:** `index.qmd:36`: `### Case 3 - second derivative formulas at $x_0=1$` → `### Case 3 - second-derivative formulas on $[0,\pi]$`. This is text only (D7), since the animation is right.
- **Check:** the heading now matches the GIF title ("on [0, pi]"), the Behavior paragraph ("over $[0,\pi]$") and the alt text ("over 0 to pi"). The formulas were not added to the heading; that was optional in the finding, and the smallest change was taken.

### F2 — Minor — fixed

- **Reproduced:** `julia inst.jl` prints the old annotation strings.
  - Case 2 (diffformab): h=0.08 → `|err5|≈1.0e-6` (raw 6.008507e-07); h=0.005 → `|err3|≈4.0e-6` (raw 4.236052e-06); h=0.002 → `|err3|≈1.0e-6` (raw 6.777681e-07). `|err5|≈0.0` appears for h = 0.05, 0.03, 0.02, 0.01, 0.005 and 0.002 (6 of 11 frames).
  - Case 3 (diffformac): h=0.02 → `max|error 5-point| ≈ 1.0e-8` (raw 1.365368e-08). `≈ 0.0` appears for h = 0.01, 0.005 and 0.002 (3 of 11 frames). Also h=0.03 → `7.0e-8` (raw 6.768570e-08).
  - Read in the committed frames: `orig_frames/diffformab/frame_011.png` ("|err3|≈1.0e-6, |err5|≈0.0") and `orig_frames/diffformac/frame_011.png` ("max|error 5-point| ≈ 0.0").
  - Independent: `indep.py` gives the same errors to 3 significant figures in every frame, with one exception. Case 2 at h=0.002 gives |err5| = 2.14e-13 there against Julia's 2.16e-13. That error is set by rounding (truncation alone: 2.36e-13), so it depends on the last bits of the libm `exp`/`sin`. `bigcheck.jl` shows that Julia's own estimate is 2.1604e-13 away from the exact $f'(1)$ (BigFloat), so the Julia label is the true error of the plotted estimate.
- **Change:** `diffformab.jl`: added `using Printf`. Line 63 now reads `round(abs(approx3 - exact); digits=6)` → `@sprintf("%.2e", abs(approx3 - exact))`, and likewise for `approx5`. `diffformac.jl`: added `using Printf`. Line 56 now reads `round(err3; digits=8)` → `@sprintf("%.2e", err3)`, and likewise for `err5`. Both GIFs were regenerated.
- **Check:** the new frames match the NEW strings in `inst.out` and the `label:` values in `indep.out`.
  - Case 2: frame_001 (h=0.35) reads 2.08e-02 / 1.92e-04; frame_005 (h=0.08) reads 1.08e-03 / 6.01e-07; frame_011 (h=0.002) reads 6.78e-07 / 2.16e-13.
  - Case 3: frame_001 (h=0.35) reads 1.31e-02 / 5.16e-04; frame_008 (h=0.02) reads 4.30e-05 / 1.37e-08; frame_010 (h=0.005) reads 2.69e-06 / 5.52e-11; frame_011 (h=0.002) reads 4.30e-07 / 5.89e-11.
  - No label reads 0.0 any more.
  - Consequence for the text: the five-point maximum error in Case 3 is now legible, and it rises from 5.52e-11 (h=0.005) to 5.89e-11 (h=0.002). That made the old "As $h$ decreases, both improve" false for the last frame, so the Behavior sentence at index.qmd:38 was corrected (see ledger). Truncation alone at h=0.002 is 1.42e-12 (`indep.py`), so at least 5.75e-11 of the 5.89e-11 is rounding.

### F3 — Minor — fixed

- **Reproduced:** in `orig_frames/diffformab/frame_011.png` (and every frame) the title ends at "…-f(x0+2h)]/(12", the "F" touches the left edge, and the closing "h)" is cut off.
- **Change:** `diffformab.jl:50`: added `titlefontsize=11` to the `plot(...)` call. The title text and frame size are unchanged.
- **Check:** in `new_frames/diffformab/frame_001.png`, `frame_005.png` and `frame_011.png` the full title "Five-point formula: f'(x0) ≈ [f(x0-2h)-8f(x0-h)+8f(x0+h)-f(x0+2h)]/(12h)" is visible, with a margin on both sides. The title formula matches the page heading at index.qmd:28.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:36 | "### Case 3 - second-derivative formulas on $[0,\pi]$" | diffformac.jl: `xlims = (0.0, pi)`, `xtrue = range(0, pi, 900)`, no `x0`. GIF title "Second-derivative formulas on [0, pi]" (`new_frames/diffformac/frame_001.png`) | yes |
| index.qmd:38 | "From $h=0.35$ to $h=0.005$" | diffformac.jl `hs = [0.35, …, 0.005, 0.002]`: 0.35 is frame 1 and 0.005 is frame 10 | yes |
| index.qmd:38 | "both maximum errors shrink" (over that range) | `textcheck.py`: err3 and err5 both fall at every step from 0.35 to 0.005 (9 steps, all `True`) | yes |
| index.qmd:38 | "the five-point stencil stays closer in every frame" | `textcheck.py`: "Case3 err5<err3 all: True", min ratio err3/err5 = 25.3 (h=0.35) | yes |
| index.qmd:38 | "because it cancels lower-order truncation terms" | Unchanged reason from the old text. Truncation-only maxima (`indep.py`): 3-point ∝ h² (1.31e-02 → 4.30e-07), 5-point ∝ h⁴ (5.16e-04 → 1.42e-12). Archive image `NumericalDiffFormulaeMod_gr_128.gif` shows the five-point f'' remainder with an $h^6 f^{(6)}$ numerator over $180h^2$ | yes |
| index.qmd:38 | "At $h=0.002$ the five-point maximum error rises slightly" | `textcheck.py`: "Case3 h 0.005->0.002: … err5 falls False". `inst.out`: 5.516299e-11 → 5.891976e-11 | yes |
| index.qmd:38 | "from $5.5\times10^{-11}$ to $5.9\times10^{-11}$" | `inst.out` 5.516299e-11, 5.891976e-11. `indep.py` label values 5.52e-11, 5.89e-11. Frames 010 and 011 read 5.52e-11 and 5.89e-11 | yes |
| index.qmd:38 | "because floating-point rounding now outweighs its truncation error" | `indep.py` at h=0.002: truncation-only max5 = 1.42e-12 against double-precision max5 = 5.89e-11, so rounding is at least 5.75e-11, about 40× the truncation. At h=0.005 truncation is 5.50e-11 against 5.52e-11 (truncation still dominates) | yes |
| diffformab.jl:63 (GIF label) | `|err3|≈%.2e`, `|err5|≈%.2e` (values per frame) | `inst.out` NEW strings agree with `indep.py` to 3 significant figures in every frame. The one rounding-level case (err5 at h=0.002, 2.16e-13 against numpy's 2.14e-13) is confirmed for Julia's own estimate by `bigcheck.jl`: 2.1604e-13 against the BigFloat exact value | yes |
| diffformac.jl:56 (GIF label) | `max|error 3-point| ≈ %.2e`, `max|error 5-point| ≈ %.2e` | `inst.out` NEW strings agree with `indep.py` label values in all 11 frames | yes |
| diffformab.jl:50 | `titlefontsize=11` (no text change) | Frames 001/005/011 show the whole title | yes |

The unchanged Case 2 Behavior sentence (index.qmd:30, "its error drops faster than the three-point estimate for the same $h$") was rechecked against the now-legible labels. `textcheck.py` gives err5 < err3 in every frame; both errors decrease at every step; and err5's step ratio is smaller than err3's at every step. It still holds. The alt texts make no rate or monotonicity claim and were left unchanged.

## Scripts and GIFs

- Scripts changed: `diffformab.jl` (Printf, `%.2e` labels, `titlefontsize=11`) and `diffformac.jl` (Printf, `%.2e` labels). `diffformaa.jl` is unchanged and was not rerun; its GIF md5 is still `ad0cee62d627bc51690a57a280dbba5c`.
- GIFs regenerated: `diffformab.gif` (md5 7199e7d9… → 5a1b9fa5…) and `diffformac.gif` (272a643b… → 03ab9531…). Each has 11 frames, the same as before.
- Frames viewed at full size:
  - diffformab: 001, 005, 011.
  - diffformac: 001, 008, 010, 011.
  - Checked in them:
    - the stencil points, estimate lines and tangent are unchanged;
    - the labels show the computed errors with the right h;
    - the Case 2 title is complete;
    - the Case 3 stencil curves start at x = 2h = 0.7 in the h=0.35 frame.
- `git status --short -- pages/numerical-methods/derive-numerical-differentiation-formulae` after regeneration:
  ```
   M .../diffformab.gif
   M .../diffformab.jl
   M .../diffformac.gif
   M .../diffformac.jl
   M .../index.qmd
  ```
  Only the expected files changed.

## Legacy archive

Consulted: `n2003/NumericalDiffFormulaeMod.html` and its three `Links/*_lnk_N.html` pages.

- The module is a Mathematica derivation (Mathews, IJMEST 2003) of central, forward and backward difference formulas by solving the Taylor "equations" as a linear system. It has **no animations** and no numerical test function. In particular, $f(x)=e^{-x}\sin x$, $x_0=1$ and the step sizes are the site's own choices, not Mathews'.
- The graph-sized images (HEIGHT ≥ 100) are Mathematica output cells. `NumericalDiffFormulaeMod_gr_128.gif` shows the five-point solution: $f'[x_0] = -(-5f[-2h+x_0]+40f[-h+x_0]-40f[h+x_0]+5f[2h+x_0]-2h^5f^{(5)})/(60h)$ and $f''[x_0] = -(450f[x_0]+15f[-2h+x_0]-240f[-h+x_0]-240f[h+x_0]+15f[2h+x_0]-2h^6f^{(6)})/(180h^2)$. Divided by 5 and by 15 respectively, these are exactly the scripts' `d1_5` and `d2_5` (plus remainder). So the formulas on the page and in the scripts agree with the archive.
- No difference between the archive and the fixed page needed resolving.

## Notes

- **Behavior paragraph of Case 3:** F2's fix made a false quantifier in the existing text visible ("As $h$ decreases, both improve"; the five-point maximum error rises in the last frame). The sentence was corrected rather than the step list changed, per D7: the animation is right, because the rounding error it shows is real. "noticeably" was dropped, because at small h the curves are visually indistinguishable and the difference shows only in the labels.
- **Case 2 at h=0.002:** |err5| = 2.16e-13 is likewise rounding-influenced (truncation alone 2.36e-13), but it still falls from the previous frame, so no text needed changing.
- **`diffformaa.jl`:** this script also uses `round(...; digits=6)`, for the approximation and exact values. Those are O(0.1) numbers, so 6 decimals gives 5 or more significant figures, and no finding names it. It was left unchanged.
- **Optional parts not done:** adding the second-derivative formulas to the Case 3 heading and adding "h = …" to the Case 2 title. The first is new content; the second is not needed, because h is already in the Case 2 annotation.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: index.qmd:36 now reads `### Case 3 - second-derivative formulas on $[0,\pi]$`. diffformac.jl has no `x0`. It plots `xtrue` over [0, π] and the stencil curves over `xinner = range(2h, pi-2h)`, and the frame title is "Second-derivative formulas on [0, pi] | h = …". The new heading is true and matches the frame title, the Behavior paragraph and the alt text. The optional extras (formulas in the heading, the [2h, π−2h] note) were not added. They were suggestions only, and the page is correct without them.

### F2 — resolved
- Evidence: both scripts now format the errors with `@sprintf("%.2e", …)`. I read the annotation strings in all 22 frames on the contact sheet and in full-size frames 1, 6, 10 and 11. They match the strings I printed from a separate Julia script and match an independent numpy float64 computation to 3 significant figures.
  - Case 2 |err5|: 1.92e-04, 5.38e-05, 1.50e-05, 3.02e-06, 6.01e-07, 9.21e-08, 1.20e-08, 2.36e-09, 1.48e-10, 9.24e-12, 2.16e-13.
  - Case 3 max|err5|: 5.16e-04 … 1.37e-08 (h = 0.02), 8.71e-10, 5.52e-11, 5.89e-11.
- The wrong values the finding listed are gone. h = 0.08 now shows 6.01e-07 (true 6.009e-7). Case 2 at h = 0.005 and h = 0.002 shows err3 4.24e-06 and 6.78e-07. Case 3 at h = 0.02 shows 1.37e-08 (true 1.365e-8). No frame shows "0.0".
- In Case 2 at h = 0.002, |err5| reads 2.16e-13, while the exact-arithmetic truncation error (mpmath, 50 digits) is 2.364e-13. The difference is float64 rounding. The annotation reports the error the script actually computed, so it is not wrong, and the h⁴ trend is still visible (9.24e-12 → 2.16e-13).

### F3 — resolved
- Evidence: diffformab.jl adds `titlefontsize=11`. In full-size new frames 1, 6 and 11, the whole title "Five-point formula: f'(x0) ≈ [f(x0-2h)-8f(x0-h)+8f(x0+h)-f(x0+2h)]/(12h)" is visible, ending in "(12h)", with clear margins on both sides. Old frame 1 (pre-fix GIF from `git lfs smudge`) is cut off at "/(12". All 11 frames on the contact sheet show the full title. The optional "h = …" in the title was not added, but h is in the annotation.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:36 | "second-derivative formulas on $[0,\pi]$" | Script xlims (0, π). Curves span [0, π] (f'') and [2h, π−2h] (stencils). Frame title matches. | True |
| index.qmd:38 | "From h=0.35 to h=0.005 both maximum errors shrink" | Independent float64 maxima. err3: 1.31e-2, 6.69e-3, 3.47e-3, 1.55e-3, 6.87e-4, 2.69e-4, 9.67e-5, 4.30e-5, 1.07e-5, 2.69e-6. err5: 5.16e-4, 1.86e-4, 6.11e-5, 1.41e-5, 3.06e-6, 5.00e-7, 6.77e-8, 1.37e-8, 8.71e-10, 5.52e-11. Both decrease at every step. | True |
| index.qmd:38 | "the five-point stencil stays closer in every frame" | err5 < err3 in all 11 frames, including h = 0.002 (5.89e-11 vs 4.30e-7). | True |
| index.qmd:38 | "At h=0.002 the five-point maximum error rises slightly, from 5.5e-11 to 5.9e-11" | float64: 5.516e-11 (h = 0.005) → 5.892e-11 (h = 0.002). Julia prints 5.52e-11 → 5.89e-11, the same as frames 10 and 11. | True |
| index.qmd:38 | "because floating-point rounding now outweighs its truncation error" | mpmath exact-arithmetic max|err5| (41 points on [2h, π−2h]): 5.500e-11 at h = 0.005 (≈ float, so truncation dominates), 1.417e-12 at h = 0.002 (float 5.89e-11, about 40× larger, so rounding dominates). At h = 0.002 the float argmax is x ≈ 0.78, not the left edge where truncation peaks, which is consistent with rounding noise. | True |
| diffformab.jl:50 | `titlefontsize=11` | Title fits in all frames | OK |
| diffformab.jl:63 | `@sprintf("%.2e", …)` err3/err5 | Matches independent values (above) | OK |
| diffformac.jl:56 | `@sprintf("%.2e", …)` err3/err5 | Matches independent values (above) | OK |
| both .jl | `using Printf` | Required for @sprintf; scripts run | OK |

### New problems
None. This rests on the following:
- I computed every new number and claim in the text independently (numpy float64 and mpmath, 50 digits).
- I looked at full-size first, middle and last frames of both changed GIFs and at both contact sheets. The plot content is unchanged apart from the title size (Case 2) and the annotation format (both cases). Annotations stay inside the axes and do not overlap the curves or the legend.
- Case 3 text is still correct for h = 0.002, where err3 keeps shrinking (4.30e-7) and only err5 rises, as stated.

### Reproducibility and conventions
- I ran diffformab.jl and diffformac.jl from scratch copies in `check/run/`. Both GIFs are byte-identical (`cmp`) to the committed working-tree GIFs. diffformaa.jl/gif are unchanged by the fix.
- Conventions: Description comes before Animations, each of the 3 cases has a `[Julia source]` link and a GIF embed, the alt text is descriptive (Case 3 alt says "over 0 to pi", which is consistent), and there are no code blocks.
- The diff for this page touches only files inside the page folder. The working tree has other modified pages and untracked `reviews/…/fixes/*.md` files. Those belong to other pages' fixes and the review workflow, not to this page's diff.

**Final status:** committed
