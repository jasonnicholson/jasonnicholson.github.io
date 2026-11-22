# Fix record: fixed-point-iteration

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/fixed-point-iteration/fix/`
(called `$FIX` below).

- `$FIX/repro/print_iterates.jl` with the HEAD versions of `fixpointdd/ee/ff.jl`: instrumented run of the original scripts (round-1 tool, page-script list cut to dd/ee/ff).
- `$FIX/repro/check.py`: independent sympy (exact) + mpmath (50 digits) check, run with `/usr/bin/python3 -I`.
- `$FIX/repro/archive_check.py`: recomputes the values the legacy animations display.
- `$FIX/postfix/print_iterates.jl` with the fixed scripts: instrumented run after the fix.
- `$FIX/new/{ee,ff}/`: frames of the regenerated GIFs. `$FIX/committed/{ee,ff}/`: frames of the HEAD GIFs. `$FIX/archive/{dd,ee,ff}/`: frames of Mathews' GIFs.
- `$FIX/patterntest/`: a scratch-only variant of `fixpointff.jl` with the old (0,4) window, used to exercise the lower-edge off-scale branch.

## Script pattern for clamped / diverging iterates (pilot)

Used in `fixpointdd.jl`, `fixpointee.jl` and `fixpointff.jl`:

- `xs` holds the true iterates (`xs[i+1] = g(xs[i])`). No clamp in the computation. Every cobweb vertex and every label is built from `xs`.
- Path segments that leave the window are clipped by the axes. Nothing is moved to the edge.
- Only the red marker of an off-scale iterate is drawn clamped. It sits just inside the window edge (inset 3% of the range, on y = x since xlims == ylims) and is drawn differently: a hollow red triangle pointing towards the true value (up or down), plus a red "off-scale ↑/↓" annotation. Its legend label keeps the true value and adds "(off-scale, marker at edge)".
- In-window markers and labels are unchanged (`round(x; digits=4)`), so `fixpointdd.gif`, which never leaves the window, regenerates byte-identical.
- The lower-edge branch was exercised in `$FIX/patterntest/ff_narrow.jl` (Case 6 with the old (0,4) window, 6 steps). Its last frame shows a hollow down-triangle at the lower-left with "off-scale ↓" and the label `x_6 = -2.5234 (off-scale, marker at edge)`. The vertical segment at x = 3.39 is clipped at the bottom edge. Nothing is clamped in the computation.

## Findings

### F1 — Error — fixed
- **Reproduced:** `cd $FIX/repro && julia print_iterates.jl` with the HEAD `fixpointff.jl` gives `xs = 1.5, 2.6875, 0.8506, 3.3938, 0.0, 4.0, 0.0, 4.0, 0.0, 4.0, 0.0`. Segments 4, 6, 8 and 10 are reported `onCurve=false` (g(xv) = −0.57644 and −2.0 where the drawn y is 0). `python3 -I check.py` gives the true orbit x₄…x₁₀ = −0.576442, 4.20515, −2.5234, 3.66982, −1.2018, 4.23982, −2.61393, and the roots of g(g(x)) = x as {−8, −2, 2, 4}, so {0, 4} is not a 2-cycle. Committed `frame_011.png` shows `x_10 = 0.0` with the marker at (0,0).
- **Change:** `fixpointff.jl`
  - Clamp removed. The pattern above is applied.
  - `n_iters` 10 → 16. `xlims = ylims` (0,4) → (−4.5, 4.5).
  - `legend` `:topleft` → `:bottomright`, so the legend does not cover the cobweb: at top-left it covered the y ≈ 4.24 horizontals and the curve's peak.
  - Header comments rewritten.
- **Check:** `cd $FIX/postfix && julia print_iterates.jl`
  - xs = 1.5, 2.6875, 0.8506, 3.3938, −0.5764, 4.2051, −2.5234, 3.6698, −1.2018, 4.2398, −2.6139, 3.5988, −1.0373, 4.2497, −2.6397, 3.5778, −0.9891. These agree with mpmath to all printed digits.
  - All 16 segments are `onCurve=true` with horizontals ending on the diagonal.
  - The whole orbit lies in [−2.6405, 4.2500], inside the window, so the off-scale branch never fires here.
  - Frames 1, 3, 5, 7, 9, 11, 13, 15 and 17 viewed (sheet plus full-size frame_017). Labels match xs. The last frame shows `x_16 = -0.9891`, with the path wound onto the outer 4-cycle box. The legend covers nothing.

### F2 — Error — fixed
- **Reproduced:** the HEAD `fixpointee.jl` gives `xs = 2.5, 2.8125, 3.3838, 4.0 ×6`. Segments 3–8 are `onCurve=false` (g(xv) = 4.5544 and 6.0 where the drawn y is 4.0). `check.py` gives the true values x₃…x₈ = 4.5544, 7.46284, 17.6549, 86.7516, 1924.84, 927212.0, strictly increasing. The first index above 4 is 3. g(4) = 6, so the old run fed a false value back in.
- **Change:** `fixpointee.jl`
  - Clamp removed. The pattern above is applied.
  - `n_iters` 8 → 4. The animation ends two iterates after leaving the window, so there are no long runs of parked frames.
  - Comments updated. Title and window unchanged.
- **Check:** postfix xs = 2.5, 2.8125, 3.3838, 4.5544, 7.4628, and all 4 segments are on the curve. All 5 frames viewed:
  - The vertical segment at x = 3.3838 runs to the top edge and is clipped there.
  - frame_004 shows the hollow up-triangle near (3.88, 3.88), "off-scale ↑", and the legend `x_3 = 4.5544 (off-scale, marker at edge)`.
  - frame_005 shows `x_4 = 7.4628 (off-scale, marker at edge)`.
  - Cosmetic: the "off-scale ↑" text crosses the clipped vertical line at x = 3.38 but stays legible.

### F3 — Error — fixed
- **Reproduced:** `check.py` gives g(2) = 2, g'(2) = 3/2 ≠ 1, and g(x) − x = x(x−2)/4. Its sign is −1 at x = 1 and +1 at x = 3, so the curve crosses y = x at 2 and does not touch it.
- **Change:** `index.qmd` Case 4 Behavior: "is tangent to $y = x$ at $x^* = 2$ from below." → "crosses $y = x$ at $x^* = 2$ (and again at $x = 0$); it lies below the diagonal for $0 < x < 2$."
- **Check:** in the ledger. The committed dd frames (unchanged GIF) show the magenta curve crossing the green line at (2,2) and below it on (0,2).

### F4 — Error — fixed
- **Reproduced:** `check.py` gives fixed points {0, 2} with g'(0) = 1/2 and g'(2) = 3/2. From 1.5 the orbit is strictly decreasing and positive for n ≤ 40, with x₈ = 0.0683681, x₄₀ = 1.706e−11 and x₄₀/x₃₉ = 0.5. HEAD `fixpointdd.jl` never clamps: all 8 segments are on the curve, so the comment "diverges quickly off-scale" is false.
- **Change:**
  - `index.qmd` Case 4 heading: "Divergent" → "Repelled from $x^* = 2$, converges to $x = 0$".
  - Behavior sentence 2 now says the staircase walks away from x* = 2 and converges monotonically to x = 0, where g'(0) = ½.
  - Alt text rewritten to match.
  - `fixpointdd.jl`: header and `n_iters` comments corrected. The never-firing clamp was replaced with the pattern (latent defect of the F1/F2 kind).
- **Check:** postfix xs are identical to HEAD (1.5 … 0.06836812960908217). `fixpointdd.gif` regenerated byte-identical: sha256 d0c3784c… matches the HEAD LFS object.

### F5 — Misleading — fixed (corrected version)
- **Reproduced:** `check.py`
  - |xₙ − 2| for n = 0..10 is 0.5, 0.688, 1.15, 1.39, 2.58, 2.21, 4.52, 1.67, 3.2, 2.24, 4.61. The early outward motion is real but not monotone.
  - Sides of 2 alternate for every n ≤ 400 (`True`).
  - min and max over 0..400 are −2.6405476 and 4.2499705.
  - The 4-cycle refined with findroot is {4.24996169, −2.640524438, 3.577169892, −0.9876210557} and closes to 1e−51. Its multiplier ∏g' = −0.030499976, so it is attracting.
- **Change:**
  - `index.qmd` Case 6 heading: "Oscillating divergent" → "Oscillating, does not converge".
  - Behavior: "iteration diverges while oscillating — the staircase spirals outward from the fixed point." → "the iteration does not converge to $x^*$: the staircase moves away from $x^* = 2$, alternating sides at every step, and settles onto a stable 4-cycle (≈ 4.25, −2.64, 3.58, −0.99)."
  - Alt text rewritten. Script comments match.
  - "Spirals outward" was replaced by "moves away" because |xₙ − 2| is not monotone.
- **Check:** the new GIF (F1) shows the path moving away from (2,2) and then winding onto the outer 4-cycle box. Distance of x₁₃…x₁₆ to the nearest cycle point is 3.1e−4, 8.1e−4, 6.7e−4 and 1.5e−3.

## Ledger of changed text

All Python commands are `/usr/bin/python3 -I $FIX/repro/check.py` unless stated. All Julia commands are `cd $FIX/postfix && julia print_iterates.jl`.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 4 heading | "Repelled from x* = 2, converges to x = 0" | check.py → g'(2) = 3/2; orbit from 1.5 strictly decreasing, positive (n ≤ 40), x₄₀ = 1.706e−11 | yes |
| index.qmd Case 4 Behavior | "crosses y = x at x* = 2 (and again at x = 0)" | check.py → fixed points [0, 2]; g'(2) = 3/2 ≠ 1 (crossing, not tangent); g−x = x(x−2)/4 changes sign at 0 and 2 | yes |
| same | "lies below the diagonal for 0 < x < 2" | g(x) − x = x(x−2)/4 < 0 on (0,2); sign at x = 1 → −1 | yes |
| same | "walks away from x* = 2 toward the left and converges monotonically to … x = 0, where g'(0) = ½" | check.py → strictly decreasing & positive n ≤ 40 True; x₄₀/x₃₉ = 0.5; g'(0) = 1/2 | yes |
| index.qmd Case 4 alt | "starting at x₀ = 1.5 below the repelling fixed point x* = 2; walks left and converges to x = 0" | as above; GIF frames end at x_8 = 0.0684 | yes |
| index.qmd Case 5 Behavior | "x₃ ≈ 4.554 already leaves the window" | check.py → x₃ = 4.5544, first index > 4 is 3; window (0,4) | yes |
| same | "x₄ ≈ 7.463" | check.py → 7.46284; postfix xs → 7.46284438 | yes |
| same | "marked off-scale at the window edge with their true values" | new frames 004/005: hollow ▲ near (3.88, 3.88), "off-scale ↑", legend `x_3 = 4.5544 …`, `x_4 = 7.4628 …` | yes |
| same | "keeps growing (x₈ ≈ 9.27 × 10⁵)" | check.py → x₈ = 927212.0, strictly increasing; g(x) − x = x(x−2)/4 increasing for x > 1, so increments grow and xₙ → ∞ | yes |
| index.qmd Case 5 alt | "from x₃ on the iterates leave the window and are marked off-scale at its edge" | as above | yes |
| index.qmd Case 6 heading | "Oscillating, does not converge" | check.py → sides alternate all n ≤ 400; limit is a 4-cycle, not a point | yes |
| index.qmd Case 6 Behavior | "does not converge to x*: moves away from x* = 2" | g'(2) = −3/2; \|xₙ − 2\| rises 0.5 → 4.61 by n = 10 (not monotone, hence "moves away", not "spirals outward") | yes |
| same | "alternating sides at every step" | check.py → `(x_i−2)(x_{i+1}−2) < 0` for all i < 400: True | yes |
| same | "settles onto a stable 4-cycle (≈ 4.25, −2.64, 3.58, −0.99)" | findroot 4-cycle {4.24996169, −2.640524438, 3.577169892, −0.9876210557}; multiplier −0.0305 (\|·\| < 1); \|x₄₀₀ − x₃₉₆\| = 0 | yes |
| index.qmd Case 6 alt | "moves away from x* = 2, alternating sides, and settles onto a 4-cycle" | as above; new frame_017 | yes |
| fixpointdd.jl comment | "repelling x* = 2 (g'(2) = 3/2 > 1) … converges monotonically to … x = 0 (g'(0) = 1/2)" | as Case 4 | yes |
| fixpointdd.jl comment | "iterates decrease from 1.5 to x_8 = 0.0684, all inside the window" | postfix xs → x₈ = 0.06836812960908217; all in (0, 1.5] | yes |
| fixpointee.jl comment | "x_3 = 4.5544 already leaves the window, so x_3 and x_4 are shown off-scale"; "x_3 = 4.5544 and x_4 = 7.4628 are off-scale" | postfix xs → 4.554401636, 7.462844384 | yes |
| fixpointee.gif labels | `x_3 = 4.5544 (off-scale, marker at edge)`, `x_4 = 7.4628 (off-scale, marker at edge)` | frames 004/005 at full size | yes |
| fixpointff.jl comment | "x* = 2 repels … alternating sides; stays bounded and settles onto an attracting 4-cycle ~ {4.25, −2.64, 3.58, −0.99}" | as Case 6 | yes |
| fixpointff.jl comment | "orbit stays in [−2.641, 4.250]" | check.py → min −2.6405476, max 4.2499705 (n ≤ 400) | yes |
| fixpointff.jl comment (Round 2 wording) | "Nothing is drawn where x > −3.3125 and y < −3.3125: the min of g on the window is g(4.5) = −3.3125, y = x is below −3.3125 only for x < −3.3125, and the orbit's min is −2.641" | sympy: g(−4.5) = 19/16, g(4.5) = −53/16 = −3.3125, and the vertex x = −1 is a maximum, so the minimum of g on [−4.5, 4.5] is −3.3125. Whether the curve dips below −3.3125 inside the window: it reaches −3.3125 only at x = 4.5, the window edge. y = x is below −3.3125 only for x < −3.3125. The orbit min over 400 steps is −2.6405476. | yes |
| fixpointff.gif labels | x_0 … x_16 | postfix xs vs frames: x_4 −0.5764, x_6 −2.5234, x_8 −1.2018, x_10 −2.6139, x_12 −1.0373, x_14 −2.6397, x_16 −0.9891 (sheet + frame_017) | yes |

Window-end values for the last fixpointff.jl row: `python3 -I -c` with sympy → g(−4.5) = 19/16 = 1.1875, g(4.5) = −53/16 = −3.3125, vertex at x = −1. So the minimum of g on [−4.5, 4.5] is −3.3125.

## Scripts and GIFs
- **Scripts changed:** `fixpointdd.jl` (comments and the pattern; same output), `fixpointee.jl`, `fixpointff.jl`. `fixpointaa/bb/cc.jl` are untouched.
- **GIFs regenerated:** `fixpointee.gif` (5 frames, was 9) and `fixpointff.gif` (17 frames, was 11). `fixpointdd.gif` was regenerated and is byte-identical to HEAD (sha256 d0c3784c1a41…). A second run of ee and ff reproduced the same sha256 (de18ad03…, f558877d…), so the output is deterministic.
- **Frames viewed:**
  - ee: all 5 at sheet size, plus frame_004 and frame_005 at full size.
  - ff: sheet (frames 1, 3, …, 17) and frame_017 at full size.
  - Checked: every vertex is built from true xs (postfix geometry: 28/28 segments on the curve, 0 off), the labels carry the right index and value, the off-scale marker and note are visible, and the 4-cycle settling is visible.
  - The ff title "… x₀ = 1.5" sits flush with the right edge. It was the same in the committed GIF and is not clipped.
- **git status of the page folder after regeneration:**
  ```
   M pages/numerical-methods/fixed-point-iteration/fixpointdd.jl
   M pages/numerical-methods/fixed-point-iteration/fixpointee.gif
   M pages/numerical-methods/fixed-point-iteration/fixpointee.jl
   M pages/numerical-methods/fixed-point-iteration/fixpointff.gif
   M pages/numerical-methods/fixed-point-iteration/fixpointff.jl
   M pages/numerical-methods/fixed-point-iteration/index.qmd
  ```

## Legacy archive
- **Consulted:**
  - `n2003/FixedPointMod.html` and `n2003/fixedpoint/FixedPointMod/Links/FixedPointMod_lnk_{4..10}.html`.
  - The code images `FixedPointMod_gr_355/391/454.gif`.
  - The original animations `a2001/Animations/RootFinding/FixedPoint/Fixpointaa…ff.gif` (frames of dd, ee, ff extracted).
  - `cobweb/` holds only `CobwebBib` and has no examples.
- **What it showed:** the site's dd/ee/ff cases use Mathews' functions but different starting values and windows.
  - **Mathews Ex. 7 "Divergence: Monotone Increasing":** g = x²/4 + x/2, p0 = 2.03. The animation stops at p8 = 3.00169 inside the [0,4] window.
  - **Mathews Ex. 8:** same g, p0 = 1.95. It is titled **"Convergence: Monotone Decreasing"** and says the iteration converges to the attractive fixed point (0) and is repelled from 2. The animation ends at p15 = 0.03794. This supports the F4 fix: Mathews himself presents the below-2 start of this g as convergence to 0, not divergence.
  - **Mathews Ex. 9 "Divergence: Spiral":** g = −x²/4 − x/2 + 4, p0 = 1.97, window [0, 4.05]. The animation ends at p10 = 0.17357, still inside the window.
- **Values checked:** `python3 -I $FIX/repro/archive_check.py` → p8 = 3.00169, p15 = 0.0379444, p9/p10 = 3.03803/0.173572. All three match the archive.
- **Differences from the fixed page:**
  - Mathews avoided clamping by stopping each animation while the iterates were still in the window. The site's Case 6 starts farther out (x₀ = 1.5), so it would leave [0,4] at x₄. The fix widens the window to show the true orbit instead.
  - Mathews' Ex. 9 label "Divergence" means only local divergence from x* (his theorem (ii) says "will not converge to P … local divergence"). For x₀ = 1.5 the computed orbit is bounded and settles on a 4-cycle, so the page says "does not converge" and states the 4-cycle rather than "diverges".

## Round 2 after check
- The checker found a Minor problem: the `fixpointff.jl` comment claimed nothing is drawn in x > −3.3, y < −3.3. That was false, because g < −3.3 for x in (4.49545, 4.5]. sympy gives the roots of g = −3.3 as 4.49545 and −6.49545.
- The comment now states the computed bound: nothing is drawn where x > −3.3125 and y < −3.3125 (min of g on the window = g(4.5) = −53/16; y = x is below that only for x < −3.3125; the orbit min is −2.641).
- Only the comment changed. `julia fixpointff.jl` regenerated a GIF that `cmp` confirms is byte-identical to the previous one (sha256 f558877d…). `git status` of the page folder lists the same six files as before.

## Notes
- **Cosmetic, not a finding:** in `fixpointee.gif` frames 4–5 the red "off-scale ↑" note overlaps the clipped blue vertical at x = 3.38 but stays legible. Left as is.
- **Not changed:** in-window labels still use `round(x; digits=4)`, which would print tiny values as 0.0. No value on this page is small enough for this to matter (the smallest label is 0.0684), so I left it to keep `fixpointdd.gif` byte-identical. Other pages that reuse the pattern for near-zero values should use significant-figure formatting.
- **Kept on purpose:** Case 6 still says "steeply decreasing at x* = 2" (g'(2) = −3/2, verified). It was not in the findings, so it stays.
- **Outside this page:** `git diff --stat` shows uncommitted changes in other pages (bisection-method, runge-kutta-method, the numerical-methods index). They belong to other fixers. I did not touch them.

## Resolution check (independent checker, not shown this record)

All computations: `check/indep.py` (sympy + mpmath at 40 digits, run with `/usr/bin/python3 -I`). Frames: `check/frames_{dd,ee,ff}/` (committed GIFs), `check/frames_{dd,ff}_old/` (HEAD GIFs via `git show | git lfs smudge`). Scripts re-run from `check/run/`.

### Original findings

### F1 — resolved
- Evidence: the clamp is gone from `fixpointff.jl` (`xs[i+1] = g(xs[i])`), and the window is now (−4.5, 4.5)². My unclamped orbit is 1.5, 2.6875, 0.8506, 3.3938, −0.5764, 4.2051, −2.5234, 3.6698, −1.2018, 4.2398, −2.6139, 3.5988, −1.0373, 4.2497, −2.6397, 3.5778, −0.9891. Its range is [−2.64055, 4.24997], so every iterate lies inside the window and the off-scale branch never runs. The committed GIF has 17 frames. Frame 9's legend reads `x_8 = -1.2018` and frame 17's reads `x_16 = -0.9891`, both matching my values. Every cobweb corner sits on the magenta curve or on the diagonal, and the drawn path reaches the edges only at the true values (≈ 4.25 and ≈ −2.64). There are no corner jumps at (0,0) or (4,4) and no fake 0↔4 bounce. The last frame shows the rectangles settling onto the 4-cycle.

### F2 — resolved
- Evidence: the clamp is gone, and `n_iters` is now 4. My values are x₃ = 4.5544016 and x₄ = 7.4628444, both above the 4.0 window top. The committed GIF has 5 frames. In frame 4 the vertical at x = 3.3838 runs up to the top edge, where the axes clip it; it no longer stops at a fabricated y = 4.0 vertex. The marker is a hollow up-triangle at the edge, with the note "off-scale ↑". The legend reads `x_3 = 4.5544 (off-scale, marker at edge)`, and frame 5 reads `x_4 = 7.4628 (off-scale, marker at edge)`. No clamped value is labelled as real, and nothing suggests the iteration stalled. Frames 4 and 5 differ only in the label, because the x₄ segments lie entirely outside the window. The page text explains this, so it is not misleading.

### F3 — resolved
- Evidence: "tangent … from below" is gone. g(x) − x factors as x(x − 2)/4, so the fixed points are 0 and 2. The curve crosses the diagonal at both, and g − x < 0 on (0, 2), which makes "lies below the diagonal for 0 < x < 2" true. Since g'(2) = 3/2 ≠ 1, the curve crosses at 2 rather than touching it. Frame 9 of `fixpointdd.gif` shows the crossing at (2, 2) and the start at the origin.

### F4 — resolved
- Evidence: the heading now reads "Repelled from x* = 2, converges to x = 0". The behavior text gives the convergence to x = 0 with g'(0) = 1/2. I verified this: sympy gives g' = {1/2, 3/2} at {0, 2}. The sequence decreases monotonically for 40 steps, with x₈ = 0.068368, x₄₀ = 1.7058e−11 and x₄₀/x₃₉ = 0.5000000000. The comments in `fixpointdd.jl` are corrected, and the "diverges quickly off-scale" comment is gone. The GIF is byte-identical to HEAD and its frame hashes match HEAD. This is correct, because no iterate ever left the window, so dropping the clamp changes nothing. Frame 9 ends at `x_8 = 0.0684` near the origin, which matches the new alt text.

### F5 — resolved
- Evidence: the text now reads "does not converge to x*: … moves away from x* = 2, alternating sides at every step, and settles onto a stable 4-cycle (≈ 4.25, −2.64, 3.58, −0.99)". I checked each part:
  - (xₙ − 2)(xₙ₊₁ − 2) < 0 for all 400 steps, so the orbit alternates sides every step.
  - The last four values of 400 steps are 4.2499617, −2.6405244, 3.5771699, −0.98762106, listed in orbit order. |x₄₀₀ − x₃₉₆| = 0.
  - The multiplier ∏g'(cᵢ) = −0.0305 has magnitude below 1, so the cycle is attracting ("stable" is correct).

  No wording implies unbounded growth any more. The heading, alt text and script comments were changed to match.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 4 heading | "Repelled from x* = 2, converges to x = 0" | g'(2) = 3/2 > 1; xₙ → 0 monotonically, ratio 0.5 | correct |
| index.qmd Case 4 behavior | "crosses y = x at x* = 2 (and again at x = 0); lies below the diagonal for 0 < x < 2" | g − x = x(x−2)/4: zeros at 0 and 2, negative on (0, 2) | correct |
| index.qmd Case 4 behavior | "g'(2) = 3/2 > 1 … walks away … toward the left and converges monotonically to … x = 0, where g'(0) = 1/2" | sympy derivative; 40 strictly decreasing iterates | correct |
| index.qmd Case 4 alt text | "starting at x₀ = 1.5 below the repelling fixed point x* = 2; walks left and converges to x = 0" | frame 9 | correct |
| index.qmd Case 5 added sentence | x₃ ≈ 4.554, x₄ ≈ 7.463, x₈ ≈ 9.27 × 10⁵ | 4.5544016, 7.4628444, 927212.28 | correct |
| index.qmd Case 5 added sentence | "x₃ and x₄ are marked off-scale at the window edge with their true values" | frames 4 and 5 | correct |
| index.qmd Case 5 alt text | "from x₃ on the iterates leave the window and are marked off-scale at its edge" | frames 4 and 5 | correct |
| index.qmd Case 6 heading | "Oscillating, does not converge" | alternates sides; tends to a 4-cycle, not to 2 | correct |
| index.qmd Case 6 behavior | g'(2) = −3/2; alternating sides; stable 4-cycle ≈ (4.25, −2.64, 3.58, −0.99) | sympy; 400-step orbit; multiplier −0.0305 | correct |
| index.qmd Case 6 alt text | "moves away from x* = 2, alternating sides, and settles onto a 4-cycle" | frame 17 | correct |
| fixpointdd.jl header | g'(2) = 3/2 > 1, converges monotonically to 0, g'(0) = 1/2 | as above | correct |
| fixpointdd.jl n_iters comment | "decrease from 1.5 to x_8 = 0.0684, all inside the window" | x₈ = 0.068368; min > 0 | correct |
| fixpoint{dd,ee,ff}.jl comment block | true iterates, axis clipping, marker drawn clamped only when off-scale, label keeps the true value | code read plus frames | correct |
| fixpoint{dd,ee,ff}.jl off-scale branch | marker inset at 3% of the window width, on the diagonal (xlims == ylims) | ee frames 4 and 5: triangle at (3.88, 3.88) | correct |
| fixpointee.jl header | "x_3 = 4.5544 already leaves the window, so x_3 and x_4 are shown off-scale" | 4.5544 > 4 | correct |
| fixpointee.jl n_iters | 4; "x_3 = 4.5544 and x_4 = 7.4628 are off-scale" | values | correct |
| fixpointff.jl header | x* = 2 repels, alternating, bounded, attracting 4-cycle ≈ {4.25, −2.64, 3.58, −0.99} | as above | correct |
| fixpointff.jl n_iters | 16 → x₁₆ = −0.9891 | Python −0.98911…; frame 17 label | correct |
| fixpointff.jl window comment | "orbit stays in [−2.641, 4.250]" | [−2.64055, 4.24997] | correct |
| fixpointff.jl window comment | "nothing is drawn in the region x > −3.3, y < −3.3 (min of g … = g(4.5) = −3.3125)" | g(4.5) = −3.3125 is correct. g = −3.3 at x = 4.4955, so the magenta curve does enter y < −3.3 for x ∈ [4.4955, 4.5]. | slightly imprecise (see new problem 1) |
| fixpointff.jl xlims/ylims, legend | (−4.5, 4.5)², `:bottomright` | frames: the legend covers no cobweb or marker; the curve's endpoint (4.5, −3.31) just touches the legend's top edge | acceptable |

### New problems
1. **Minor** (code comment only): `fixpointff.jl`, the comment above `xlims`. It says nothing is drawn in x > −3.3, y < −3.3, but the same comment gives g(4.5) = −3.3125. The magenta curve therefore enters that region for x ∈ [4.4955, 4.5]. In the frames the curve's endpoint sits right at the legend's top edge and nothing meaningful is hidden. The rendered page is not affected.

Nothing else. This rests on four things: I recomputed every number in the diff; I viewed frames 1, 9 and 17 of ff, frames 1, 3, 4 and 5 of ee, and frame 9 of dd at full size; the dd GIF is unchanged and its frame hashes match HEAD; and the unchanged cases 1–3 and their scripts are untouched. One cosmetic note, not a problem: the ff title now reaches pixel column 598 of 600 (it was 593), because the minus signs widen the y tick labels. It is still fully legible.

### Reproducibility and conventions
- Ran `fixpointdd.jl`, `fixpointee.jl` and `fixpointff.jl` from scratch copies in `check/run/`. All three outputs are byte-identical (`cmp`) to the GIFs in the page folder. `fixpointdd.gif` is also byte-identical to HEAD.
- Each case still has a `[Julia source]` link and a GIF embed. The alt texts are descriptive, and there are no code blocks.
- Pre-existing gap, not introduced by this fix: the page has no `## Description` section before `## Animations`, which the conventions file requires (line 12). HEAD has the same layout.
- Within this page's folder, only the six listed files changed. Other changed files in the working tree belong to other pages' fixes and have nothing to do with fixed-point iteration: bisection-method, runge-kutta-method, pade-approximation, and a link edit in `pages/numerical-methods/index.qmd` (Milne-Simpson, Predictor-Corrector, Shooting).

### Re-check (director)
The fixer's round-2 change was a comment only, in fixpointff.jl ("x > -3.3125 and y < -3.3125: the min of g on the window is g(4.5) = -3.3125"). I checked it directly: the min of g over 900001 points on [-4.5, 4.5] is -3.3125 = g(4.5), so the comment is now true. repro.sh: all 6 committed GIFs are byte-identical to their scripts' output. The earlier new problem is resolved; there are no others.

**Final status:** committed
