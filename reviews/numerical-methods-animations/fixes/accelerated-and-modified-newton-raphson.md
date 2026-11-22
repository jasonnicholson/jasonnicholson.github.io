# Fix record: accelerated-and-modified-newton-raphson

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/accelerated-and-modified-newton-raphson/fix/`

- `iter_aa.jl`, `iter_bb.jl`, `iter_cc.jl`: round-1 instrumented copies of the three iterate loops (Float64, same operations as the scripts). They print each iterate, its error and its 6-digit legend label. Run `julia iter_<c>.jl`; the output is saved in `iter_<c>.out`.
- `indep.py`: round-1 sympy/mpmath check (factorisation, h = f/f′, Method B = Newton on h, error series, 60-digit iterates). Run `/usr/bin/python3 -I indep.py` (output in `indep.out`).
- `slopes.py`: round-1 drawn-segment slope against tangent slope (output in `slopes.out`).
- `check_fix.py`: new, written for this fix. It uses mpmath at 50 digits plus a Float64 replica. It checks the drawn-line slope against the tangent slope at every step of all three cases, the side and fraction of distance covered by each Case 1 step, and the Case 2/3 iterates and e_{n+1}/e_n² ratios. Run `/usr/bin/python3 -I check_fix.py` (output in `check_fix.out`).
- `committed/{aa,bb,cc}/`: frames and contact sheets of the committed GIFs. `committed_md5.txt` holds the md5 sums of the committed GIFs.

## Findings

### F1 — Misleading — fixed
- Reproduced: `check_fix.py` computes the slope of the drawn Case 2 segment, f(xₙ)/(xₙ − xₙ₊₁), against f′(xₙ) at all four nonzero steps: 0.66 vs 1.32, 0.018236915 vs 0.036473829, 1.8310044e-5 vs 3.6620088e-5, and 1.8625258e-11 vs 3.7250516e-11. The ratio is 0.5 every time, and step/Newton step = 2.0 every time. The Float64 replica also gives a ratio of 0.5 at its 3 nonzero steps. In Case 1 (all 12 steps, Float64 ratio 1.0 to 1e-11) and Case 3 (ratio to h′(xₙ) = 1.0 at all 4 steps) the drawn line is the tangent. Committed `committed/bb/frame_002.png` was viewed: the orange segment from (1.2, 0.128) to (1.006, 0) is a chord that lies above the curve, not a tangent.
- Change: index.qmd. In the Animations intro (line 26), "shows the **Newton tangent-line diagram** … the line from $(x_n,\, f(x_n))$ to the x-axis intercept" → "shows a Newton-style line diagram … the line from the plotted curve at $x_n$ to the x-axis intercept … In Cases 1 and 3 that line is the tangent to the plotted curve; in Case 2 it has half the tangent slope (see Case 2)." The old "(x_n, f(x_n))" was also inexact for Case 3, which plots h. In the Case 2 Behavior (line 40), one sentence was added: "The orange line from $(x_n,\, f(x_n))$ is therefore not the tangent: its slope is $f'(x_n)/2$, half the tangent slope, so it meets the axis twice as far from $x_n$ as the Newton tangent would." The Case 2 alt text (line 44), "tangent-line animation … in a few steps", → "animation …: orange lines with half the tangent slope give steps twice the Newton step; … with x₃ equal to 1 to six decimals". The script and GIF are unchanged (decision D7; the GIF title never says "tangent"). The optional lighter true-tangent overlay was not added, because it would be new drawing code.
- Check: the slope numbers are above. Algebraically, the segment slope is f/(2f/f′) = f′/2 for every n.

### F2 — Misleading — fixed
- Reproduced: `check_fix.py` (mpmath, Case 1) shows that every xₙ₊₁ lies strictly between 1 and xₙ (`between(1,x_n)=True` for n = 0…11). The ratios e_{n+1}/e_n are 0.5151515, 0.5081652, 0.5042517, … and 0.5000087, all greater than 1/2. So each step covers 0.4848485 … 0.4999913 of the remaining distance, and nothing lands "far from x*". `indep.py` gives the error map e_{n+1} = e/2 + e²/12 + …. The committed contact sheet `committed/aa/sheet.png` was viewed: the blue tangents form a staircase that approaches 1 from the right.
- Change: index.qmd:32. "The tangent line at $x_n$ is nearly horizontal near the root, so it crosses zero far from $x^*$ — forcing many iterations to creep toward $x = 1$." → "Near the root $f(x) \approx 3(x-1)^2$, so the tangent at $x_n$ meets the axis between $x_n$ and $x^*$, only about halfway there ($x_{n+1} - 1 \approx (x_n - 1)/2$). Each step covers just under half the remaining distance (1.2, 1.10303, 1.052356, 1.026401, …), so after 12 steps $x_{12} = 1.000052$ is still about $5.2 \times 10^{-5}$ from the root."
- Check: see the ledger.

### F3 — Minor — fixed
- Reproduced: `julia iter_cc.jl` gives x₁ = 0.99415204678362468 (label 0.994152), x₂ = 0.99999427796503726 (label 0.999994) and x₃ = 1.0000000000083733 (label 1.0). `julia iter_bb.jl` gives x₁ = 1.0060606060606054 (1.006061), x₂ = 1.0000061033293672 (1.000006) and x₃ = 1.0000000000036071 (1.0). For both, the legend first reads 1.0 at x₃, and both have |e_{n+1}/e_n²| → 1/6 (`check_fix.py`: bb 0.151515, 0.166163, 0.166666, 0.166667; cc −0.146199, −0.167318, −0.166667, −0.166667). So "in just 2 steps" for Case 3 against "a few steps" for Case 2 wrongly suggests that B is faster. Committed `committed/cc/frame_003.png` was viewed: the legend reads "x₍2₎ = 0.999994".
- Change: index.qmd. Case 2 (line 40), "The same function and starting point as Case 1 now converges in just a few steps." → "From the same starting point as Case 1, $x_1 = 1.006061$, $x_2 = 1.000006$, and $x_3$ equals 1 to six decimals." Case 3 (line 50), "converging to $x = 1$ in just 2 steps" → "converging to $x = 1$: $x_1 = 0.994152$, $x_2 = 0.999994$, and, as in Case 2, $x_3$ equals 1 to six decimals." Case 3 alt text (line 54), "in 2 steps without knowing the multiplicity" → ", with x₃ equal to 1 to six decimals, without knowing the multiplicity". accnewtoncc.jl:7 header comment, "converging in ~2 steps" → "x2 = 0.999994 and x3 equals 1 to six decimals" (comment only).
- Check: see the ledger. The finding's optional note that "Method B approaches from below" was not added. In exact arithmetic x₁, x₂ and x₃ are all below 1 (mpmath e₃ = −5.457e-12), but in the script's Float64 run x₃ = 1.0000000000083733 is above 1 (round-off floor), so the statement would not hold for the animation as drawn.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:26 | "In Cases 1 and 3 that line is the tangent to the plotted curve" | `check_fix.py` → Case 1 Float64 drawn/f′ ratio 1.0 at all 12 steps (≥0.999999999998); Case 3 drawn/h′ ratio 1.0 at n = 0…3; `slopes.py` → aa and cc ratio 1.000000 | yes |
| index.qmd:26 | "in Case 2 it has half the tangent slope" | `check_fix.py` → ratio 0.5 at n = 0…3 (mpmath) and at the 3 nonzero Float64 steps | yes |
| index.qmd:26 | "the line from the plotted curve at $x_n$ to the x-axis intercept traces … $x_{n+1}$" | scripts: aa/bb `plot!([xn, xn1], [fn, 0.0])` with fn = f(xn); cc `[hn, 0.0]` with hn = h_plot(xn) | yes |
| index.qmd:32 | "$f(x) \approx 3(x-1)^2$" near the root | `indep.py` → factor (x−1)²(x+2), so x+2 = 3 at x = 1; `check_fix.py` → f(1+e)/(3e²) = 1.06667 (e = 0.2) and 1.00333 (e = 0.01) | yes |
| index.qmd:32 | "the tangent at $x_n$ meets the axis between $x_n$ and $x^*$" | `check_fix.py` → `between(1,x_n)=True` for n = 0…11 | yes |
| index.qmd:32 | "$x_{n+1} - 1 \approx (x_n - 1)/2$" | `indep.py` → e_{n+1} = e/2 + e²/12; ratios 0.515152 … 0.500009 | yes |
| index.qmd:32 | "Each step covers just under half the remaining distance" | `check_fix.py` → fraction covered 0.4848485 … 0.4999913, all < 0.5 (ratio > 1/2 True for all 12) | yes |
| index.qmd:32 | "1.2, 1.10303, 1.052356, 1.026401" | `julia iter_aa.jl` → labels 1.2, 1.10303, 1.052356, 1.026401 (mpmath 1.1030303, 1.0523564, 1.0264008) | yes |
| index.qmd:32 | "$x_{12} = 1.000052$", "about $5.2 \times 10^{-5}$ from the root" | `iter_aa.jl` → x₁₂ = 1.0000520156500807, label 1.000052; mpmath e₁₂ = 5.20156e-5 | yes |
| index.qmd:40 | "its slope is $f'(x_n)/2$, half the tangent slope" | `check_fix.py` → 0.66/1.32, 0.018236915/0.036473829, … ratio 0.5 | yes |
| index.qmd:40 | "it meets the axis twice as far from $x_n$ as the Newton tangent would" | `check_fix.py` → step/NewtonStep = 2.0 at n = 0…3; algebraic: 2f/f′ vs f/f′ | yes |
| index.qmd:40 | "$x_1 = 1.006061$, $x_2 = 1.000006$" | `iter_bb.jl` → 1.0060606060606054 (label 1.006061), 1.0000061033293672 (1.000006) | yes |
| index.qmd:40 | "$x_3$ equals 1 to six decimals" | `iter_bb.jl` → x₃ = 1.0000000000036071, label 1.0; mpmath e₃ = 6.208e-12 | yes |
| index.qmd:44 alt | "orange lines with half the tangent slope give steps twice the Newton step" | as the two rows above | yes |
| index.qmd:44 alt | "quadratic convergence … with x₃ equal to 1 to six decimals" | `check_fix.py` → e_{n+1}/e_n² = 0.151515, 0.166163, 0.166666 → 1/6; x₃ as above | yes |
| index.qmd:50 | "$x_1 = 0.994152$, $x_2 = 0.999994$" | `iter_cc.jl` → 0.99415204678362468 (label 0.994152), 0.99999427796503726 (0.999994) | yes |
| index.qmd:50 | "as in Case 2, $x_3$ equals 1 to six decimals" | `iter_cc.jl` → x₃ = 1.0000000000083733, label 1.0; mpmath e₃ = −5.457e-12; Case 2 as above | yes |
| index.qmd:54 alt | "with x₃ equal to 1 to six decimals" | as above | yes |
| accnewtoncc.jl:7 comment | "x2 = 0.999994 and x3 equals 1 to six decimals" | as above | yes |

## Scripts and GIFs
- Scripts changed: accnewtoncc.jl, header comment line 7 only. No code changed.
- GIFs regenerated: `julia accnewtoncc.jl` → md5 d5f634f28ea2c4f7b380d2c9d55910ad, identical to the committed file (`committed_md5.txt`), as expected for a comment-only change. accnewtonaa.jl and accnewtonbb.jl are untouched and were not regenerated.
- Frames viewed (committed = current GIFs): `committed/bb/frame_002.png` (orange chord with half the tangent slope; legend x₍1₎ = 1.006061), `committed/cc/frame_003.png` (legend x₍2₎ = 0.999994) and `committed/aa/sheet.png` (staircase from the right; legends 1.2, 1.052356, …, x₍12₎ = 1.000052). These match the values quoted in the new text.
- `git status --short -- pages/numerical-methods/accelerated-and-modified-newton-raphson` after regeneration shows only ` M accnewtoncc.jl` and ` M index.qmd`.

## Legacy archive
Consulted: `NewtonAccelerateMod.html` and `newtonaccelerate/NewtonAccelerateMod/Links/*_lnk_{3,4,6}.html`, with formula images gr_35, gr_119, gr_120, gr_131, gr_144 and gr_235 and graph gr_124. Mathews' Example 1(b) (plain Newton, slow convergence), Example 2 (accelerated Newton, `NewtonRaphsonAccelerate[1.2, 2, 5]`) and Example 4 (modified Newton) all use f(x) = x³ − 3x + 2 with p₀ = 1.2. This is the same function, start and m as the page's three cases. The archive module has no animations of its own; it has a static plot of f on [−3, 3] and Mathematica iteration tables. Nothing in the archive conflicts with the fixed page.

## Notes
- Float64 round-off near the double root: the scripts' x₃ for Cases 2 and 3 (errors 3.6e-12 and +8.4e-12) differ from the exact iterates (6.2e-12 and −5.5e-12) because f is evaluated in expanded form near a double root. The legend labels (1.0) are unaffected, so this was not acted on, and the page text quotes no values below 1e-6 for Cases 2 and 3. The bb frames for x₄ and x₅ and the cc frame for x₄ repeat x₃ (`iter_bb.out` and `iter_cc.out` show identical values), because the Float64 step becomes zero there. This is visible only as an unchanged legend and was not raised in round 1.
- The existing Case 1 sentence "the asymptotic error constant is (m−1)/m = 1/2, meaning each step only halves the error" was kept. The computed ratio → 0.500009 at n = 12.

## Resolution check (independent checker, not shown this record)

Evidence scripts and outputs: `check/verify.py` (mpmath, 40 digits), `check/run/` (scratch regeneration), `check/frames_{aa,bb,cc}/` (decoded frames).

### Original findings

### F1 — resolved
- The intro no longer calls all three diagrams "Newton tangent-line" diagrams. It now says: "In Cases 1 and 3 that line is the tangent to the plotted curve; in Case 2 it has half the tangent slope". The Case 2 Behavior paragraph now says the orange line "is therefore not the tangent: its slope is f'(x_n)/2 ... meets the axis twice as far from x_n as the Newton tangent would". The Case 2 alt text no longer says "tangent-line animation".
- I computed this independently along the Method A iterates (k = 0, 1, 2). The drawn slope divided by f'(x_n) is exactly 0.5. The distance from x_n to the drawn intercept divided by the Newton step is exactly 2.0. For Cases 1 and 3, the drawn slope divided by the true derivative is 1.0: for Case 3 this is h'(x_n), computed by numerical differentiation of f/f'. Case 3's step is algebraically Newton on h, since h/h' = f f'/(f'^2 − f f''), and the simplified h_plot matches f/f' to 1e-41.
- The script and GIF did not change (bb GIF is unchanged against HEAD). This is acceptable because the fix took the "change the wording" route. The picture (frame_002: a chord above the curve) now agrees with the text.

### F2 — resolved
- I confirmed that the false "crosses zero far from x*" sentence is gone. Here is what replaced it, checked claim by claim:
  - "f(x) ≈ 3(x−1)^2" near the root: true. f/(3e²) = 1.0333 at x = 1.1 and 1.00333 at 1.01, because f = (x−1)²(x+2).
  - "meets the axis between x_n and x*": true. Every iterate stays above 1 and decreases monotonically.
  - "x_{n+1} − 1 ≈ (x_n − 1)/2": true. The ratios are 0.515, 0.508, 0.504, … , 0.500009.
  - "just under half the remaining distance": true. The fraction of the remaining distance covered per step is 0.4848, 0.4918, 0.4957, … , 0.49999, always < 0.5.
  - Iterates 1.2, 1.10303, 1.052356, 1.026401: these match to 6 decimals.
  - "x_12 = 1.000052 ... about 5.2e-5 from the root": true. x12 = 1.00005201565, and the last frame (frame_013) legend reads "x₍12₎ = 1.000052".
- The sentence no longer contradicts "each step only halves the error".

### F3 — resolved
- "in just 2 steps" is removed from both the Case 3 text and its alt text. Both cases now get the same wording: "x_3 equals 1 to six decimals", and Case 3 says "as in Case 2". Case 2's vague "in just a few steps" is replaced by explicit iterates. The page no longer implies that Method B is faster than Method A.
- High-precision iterates:
  - Method A: x1 = 1.0060606, x2 = 1.0000061 (e = 6.1e-6), x3 = 1 + 6.2e-12.
  - Method B: x1 = 0.9941520, x2 = 0.9999943 (e = −5.7e-6), x3 = 1 − 5.5e-12.
- The frames agree with these iterates. bb frame_002/003/004 legends show x₍1₎ = 1.006061, x₍2₎ = 1.000006, x₍3₎ = 1.0. cc frame_002/003/004 legends show x₍1₎ = 0.994152, x₍2₎ = 0.999994, x₍3₎ = 1.0.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:26 | "Newton-style line diagram" | Matches what is drawn (lines from the curve to the axis intercept) | OK |
| index.qmd:26 | "line from the plotted curve at x_n to the x-axis intercept traces x_{n+1}" | Scripts draw from (x_n, f or h(x_n)) to (x_{n+1}, 0) | OK |
| index.qmd:26 | "In Cases 1 and 3 that line is the tangent...; in Case 2 it has half the tangent slope" | Slope ratios 1.0 / 1.0 / 0.5 at k = 0..2 | OK |
| index.qmd:32 | f(x) ≈ 3(x−1)² | f = (x−1)²(x+2); ratio → 1 | OK |
| index.qmd:32 | meets the axis between x_n and x*, about halfway; x_{n+1}−1 ≈ (x_n−1)/2 | Monotone from above; ratios 0.515 → 0.500009 | OK |
| index.qmd:32 | "just under half the remaining distance" | Fractions 0.485 … 0.49999 (< 0.5) | OK |
| index.qmd:32 | 1.2, 1.10303, 1.052356, 1.026401 | mpmath: 1.10303030, 1.05235642, 1.02640081 | OK |
| index.qmd:32 | x_12 = 1.000052, ≈ 5.2×10⁻⁵ from root | 1.00005201565; e = 5.202e-5; frame_013 legend | OK |
| index.qmd:40 | orange line not the tangent; slope f'(x_n)/2 | Drawn slope / f' = 0.5 exactly | OK |
| index.qmd:40 | meets the axis twice as far from x_n as the Newton tangent | Step ratio 2.0 exactly | OK |
| index.qmd:40 | x_1 = 1.006061, x_2 = 1.000006, x_3 equals 1 to six decimals | 1.00606061, 1.00000610, 1+6.2e-12; legends match | OK |
| index.qmd:44 alt | "orange lines with half the tangent slope give steps twice the Newton step" | As above | OK |
| index.qmd:44 alt | "x₃ equal to 1 to six decimals" | As above; frame_004 legend "1.0" | OK |
| index.qmd:50 | "shows the tangent lines" (Case 3) | Lines are tangent to h (slope / h' = 1.0) | OK |
| index.qmd:50 | x_1 = 0.994152, x_2 = 0.999994, x_3 = 1 to six decimals, "as in Case 2" | 0.99415205, 0.99999428, 1−5.5e-12; legends match | OK |
| index.qmd:54 alt | "tangent-line animation on h(x)"; "x₃ equal to 1 to six decimals" | As above | OK |
| accnewtoncc.jl:7 (comment only) | "x2 = 0.999994 and x3 equals 1 to six decimals" | As above; it changes no computation | OK |

### New problems
None.
- This rests on three checks:
  - Every changed sentence and number in the ledger was checked against a 40-digit recomputation.
  - The frames were inspected at full size (aa frame 13; bb frames 2–4; cc frames 2–4).
  - All three GIFs are unchanged and reproduce byte for byte.
- Pre-existing observation, not caused by the fix and not a finding: in Case 3, the steelblue tangent segment almost coincides with the green h curve, so it is hard to see. This is inherent to h being nearly linear near x = 1.

### Reproducibility and conventions
- Changed files in the page folder are index.qmd and accnewtoncc.jl (one comment line). No GIF changed: `git diff --quiet HEAD` holds for all three GIFs.
- I ran all three scripts from scratch copies (`check/run/`). Each output is byte-identical (`cmp`) to the committed GIF: aa 13 frames, bb 6, cc 5.
- Conventions are kept:
  - Description comes before Animations.
  - Each case has a "[Julia source]" link and a GIF embed.
  - The alt text is descriptive.
  - There are no code blocks.
- Outside the page folder, the only thing attributable to this page is an untracked fixer note at `reviews/numerical-methods-animations/fixes/accelerated-and-modified-newton-raphson.md`, which is not site content. The other modified paths under pages/numerical-methods belong to other pages' fixes. No site file outside this page folder was changed for this page.

**Final status:** committed
