# Fix record: accelerated-and-modified-newton-raphson

Scratch folder (all evidence scripts and frame extractions):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/accelerated-and-modified-newton-raphson/fix/` (below: `$S`).
Python is `/usr/bin/python3 -I`; frame tool is `r2fix/tools/giftools.jl`.

## Findings

### F1 — Minor — fixed (text)
- Reproduced: extracted the committed `accnewtonaa.gif` (`giftools.jl … $S/committed/accnewtonaa`, 13 frames). Measured plot box: left edge x = 67 px, bottom y = 545 px; frame-1 marker centre at 322 px for x = 1.2 and frame-13 centre at 220 px for x = 1.000052 gives 510 px per x-unit (561 px / 1.1). `python3 -I $S/check_case1.py $S/committed/accnewtonaa` (mpmath, 40 digits) printed err_px = 102.00, 52.55, 26.70, 13.46, 6.76, 3.39, 1.70, 0.85, 0.42, 0.21, 0.11, 0.05, 0.03 and f_px = 61.9, 15.9, 4.05, 1.02, 0.26, … for k = 0…12. Its pixel differences between successive frames (outside the legend band) are ≤ 104 px from x₅→x₆ on, all inside a 15 × 13 px box at the root, down to 1 px for x₁₁→x₁₂. `python3 -I $S/marker_cover.py $S/committed/accnewtonaa` showed that the red marker covers the root pixel (220.0, 520.8) in every frame from x₅ to x₁₂ (covers=True), but not for x₀–x₄ (distance 6.8 px at x₄). The finding holds.
- Change: text only, following D7 and the "smallest change" lesson. The finding names a text sentence as an acceptable correction ("At the least…"). A log-error inset or a per-frame zoom would add a panel or new drawing logic, which the brief tells fixers to avoid for Minor picture findings.
  - `index.qmd` Case 1 Behavior: added the sentence "At the scale of the plot only the first few steps can be told apart: from $x_5$ on, the iterate is less than 0.007 from the root and its marker covers the root, so the remaining halvings show only in the legend value."
  - Case 1 alt text: appended "; from x₅ on the marker covers the root and the progress shows only in the legend value".
- Check: e₅ = 0.00664342 < 0.007, and the errors decrease monotonically after that (ratios 0.501098 … 0.500009, all < 1, all positive). The marker covers the root for x₅…x₁₂ (pixel test above). GIF unchanged, so the measured frames are the published ones.

### F2 — Minor — fixed (script style + text)
- Reproduced: `python3 -I $S/check_case3.py` (sympy + mpmath) gave h = (x − 1)(x + 2)/(3(x + 1)), h′(1) = 1/2, and Method B − Newton(h) simplifies to 0. The iterates are x₁ = 0.994152046784, x₂ = 0.999994277965 and x₃ = 1 − 5.46e−12. The drawn slope is 0.4710743802 = h′(1.2). The maximum |tangent − h| on [x₁, x₀] is 0.002927, which is 1.49 px at 508 px per y-unit and 3.0 % of h(x₀) = 0.0969697. The overshoot x₁ − 1 = −0.00585 is 2.19 px, the second segment is 2.64 px long and the third 0.0026 px. In the committed frame_002.png the tangent shows only as a faint tint on the green curve. The finding holds.
- Change:
  - `accnewtoncc.jl` line 64 (tangent segment): `color=:steelblue, lw=1.5` → `color=:black, lw=1.5, ls=:dash`, with the comment updated. This is a line-style change, not a new plot element. The vertical drops are unchanged.
  - `index.qmd` Case 3 Behavior: "and shows the tangent lines converging to $x = 1$: $x_1 = 0.994152$, …" → "with the tangent lines dashed. $h$ is nearly straight between the root and $x_0$, so the first tangent lies almost on the curve and takes the iterate in one step to $x_1 = 0.994152$, just left of the root. At this scale that overshoot and the later steps are too small to see, and the iterates are read from the legend: $x_2 = 0.999994$, and, as in Case 2, $x_3$ equals 1 to six decimals."
  - Case 3 alt text: rewritten to name the dashed tangent lying almost on the curve, the step to x₁ = 0.994152 just left of x = 1, and x₃ = 1 to six decimals.
- Check: regenerated in place (`julia accnewtoncc.jl`). Frames were extracted to `$S/new/accnewtoncc` and compared pixel by pixel with `$S/committed/accnewtoncc`.
  - Frame 1 differs in only 6 pixels, max Δ 56 (GIF palette requantisation; no tangent is drawn yet).
  - Frames 2–5 differ only inside the box x 248–335, y 289–347 px, which is where the tangent lies.
  - Viewed frames 001, 002 and 005 at full size. The black dashes are clearly visible along the curve from (1.2, 0.097) to the root. The legend reads x₍1₎ = 0.994152 in frame 2 and x₍4₎ = 1.0 in frame 5, and the title is unchanged.

### F3 — Minor — fixed (one sentence, R2-A)
- Reproduced: read `n2003/NewtonAccelerateMod.html` and solution links `lnk_2,3,5,7,8,9,10` as text, and viewed the upscaled statement and solution-code images (`$S/archive/stack.png`, `stack_sol.png`, `stack6b.png`, `stack_24.png`, `gr_160.png`, `gr_334.png`). The examples are:
  - Ex 1: f = x³ − 3x + 2. (a) simple root p = −2, p₀ = −2.4. (b) double root p = 1, p₀ = 1.2.
  - Ex 2: accelerated, p = 1, p₀ = 1.2.
  - Ex 3: accelerated at the double root p = 1 and the triple root p = 2 of x⁵ − 8x⁴ + 25x³ − 38x² + 28x − 8. The statement says "cubic" but both the statement image gr_160 and the solution code gr_161 show the quintic.
  - Ex 4: modified, p = 1, p₀ = 1.2.
  - Ex 5: modified, same quintic and roots as Ex 3.
  - Ex 6: f = −x⁷ + … + 2 = (x − 1)⁶(2 − x) (gr_386–388). (a) Newton, (b) accelerated with m = 6 (gr_391), (c) modified, all at p = 1. The 6(b)/(c) text says "double root", which is an archive slip.

  The page's three cases are Ex 1(b), 2 and 4, and nothing on the page mentions the others. The finding holds.
- Change: following R2-A ("Add one sentence … Do not add the example") and the Monte Carlo π pattern (placed after the last embed; the page has no legacy note), added two source lines at the end of `index.qmd`:
  > The three cases reproduce Examples 1(b), 2 and 4 of Mathews' Accelerated and Modified Newton Methods module, all at the double root of the same cubic.
  > The module's Examples 1(a), 3, 5 and 6, which apply standard Newton-Raphson at the simple root of that cubic (Example 1(a)), the accelerated method (Example 3) and the modified method (Example 5) at a double and a triple root of a fifth-degree polynomial, and the standard, accelerated and modified methods at a root of higher multiplicity (Example 6), are not animated here.
  The Animations intro was not changed, because the pattern puts this note at the end.
- Check: `python3 -I $S/check_f3.py` printed:
  - Ex 1 cubic = (x − 1)²(x + 2): multiplicity at −2 = 1 (simple), at 1 = 2.
  - Ex 3/5 polynomial: degree 5, (x − 2)³(x − 1)², multiplicity 2 at 1 and 3 at 2.
  - Ex 6 polynomial: degree 7, −(x − 2)(x − 1)⁶, multiplicity 6 at 1 (> 2, so "higher multiplicity"); expand((x − 1)⁶(2 − x)) equals the statement polynomial.

  Which method each example uses was read from the statement text and confirmed in the solution pages (lnk_5: "accelerated … double root … Now investigate the other root … triple root"; lnk_7: "modified … double root … triple root"; lnk_8/9/10: Newton / accelerated / modified). The page has 3 cases (`grep -c '^### Case'` → 3) and 3 scripts/GIFs. The module's title is "Accelerated and Modified Newton Methods" (HTML title text).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 1 Behavior | "only the first few steps can be told apart" | `marker_cover.py`: marker distance to root 119, 55, 27, 13.5, 6.8 px for x₀–x₄ (separate), covers root from x₅ | yes |
| Case 1 Behavior | "from $x_5$ on, the iterate is less than 0.007 from the root" | `check_case1.py`: e₅ = 0.00664342, later e_k smaller (ratios < 1, e_k > 0) | yes |
| Case 1 Behavior | "its marker covers the root" | `marker_cover.py`: covers=True for x₅…x₁₂ | yes |
| Case 1 Behavior | "remaining halvings show only in the legend value" | ratios 0.501098…0.500009 (halving); successive-frame changes outside legend ≤ 104 px, within a 15 × 13 px box at the root; legend shows x₍k₎ to 6 decimals | yes |
| Case 1 alt | "from x₅ on the marker covers the root and the progress shows only in the legend value" | same as above | yes |
| Case 3 Behavior | "with the tangent lines dashed" | `accnewtoncc.jl` l.64 `ls=:dash`; frames 002–005 viewed | yes |
| Case 3 Behavior | "$h$ is nearly straight between the root and $x_0$" | `check_case3.py`: max deviation of chord/tangent from h on [x₁, x₀] = 0.002927 (3.0 % of h(x₀)) | yes |
| Case 3 Behavior | "first tangent lies almost on the curve" | same: ≤ 1.49 px from h over its whole length | yes |
| Case 3 Behavior | "$x_1 = 0.994152$, just left of the root" | mpmath x₁ = 0.994152046784 < 1 | yes |
| Case 3 Behavior | "overshoot and later steps too small to see" | overshoot 2.19 px; segment 2 = 2.64 px, segment 3 = 0.0026 px | yes |
| Case 3 Behavior | "$x_2 = 0.999994$", "$x_3$ equals 1 to six decimals" (kept) | mpmath x₂ = 0.999994277965, x₃ = 1 − 5.46e−12 | yes |
| Case 3 alt | "dashed tangent from x₀=1.2 lies almost on the nearly straight curve … x₁=0.994152, just left of x=1 … x₃ equal to 1 to six decimals" | same checks | yes |
| End note | "reproduce Examples 1(b), 2 and 4 … all at the double root of the same cubic" | archive images gr_31, 34, 35, 118–120, 233–235: f = x³ − 3x + 2, p = 1, p₀ = 1.2; scripts use the same f, x₀ | yes |
| End note | "Example 1(a) … simple root of that cubic" | gr_32/33: p = −2, p₀ = −2.4; sympy multiplicity 1 | yes |
| End note | "accelerated method (Example 3) and modified method (Example 5) at a double and a triple root of a fifth-degree polynomial" | gr_160/161, 277; lnk_5/lnk_7 text; sympy degree 5, multiplicities 2 and 3 | yes |
| End note | "standard, accelerated and modified methods at a root of higher multiplicity (Example 6)" | lnk_8/9/10 text; gr_386–391 (m = 6); sympy multiplicity 6 at x = 1 | yes |
| `accnewtoncc.jl` comment | "dashed black so it stands out where it lies almost on the nearly straight curve h" | as above | yes |

## Scripts and GIFs
- Script changed: `accnewtoncc.jl` (tangent line style only; the computation is unchanged). Regenerated `accnewtoncc.gif` in place; it is byte-identical to the trial run in `$S/try_cc/`.
- `accnewtonaa.jl` and `accnewtonbb.jl` are unchanged and were not regenerated.
- Frames viewed: new `accnewtoncc` frames 001, 002 and 005 at full size, plus the pixel diff against the committed frames for all 5. Committed `accnewtonaa` frame 007 and `accnewtoncc` frame 002 were viewed to reproduce the findings.
- `git status --short -- pages/numerical-methods/accelerated-and-modified-newton-raphson` after regeneration:
  ```
   M .../accnewtoncc.gif
   M .../accnewtoncc.jl
   M .../index.qmd
  ```

## Legacy archive
- Consulted: `n2003/NewtonAccelerateMod.html` and `n2003/newtonaccelerate/NewtonAccelerateMod/{Links,Images}`. There is no topic-specific animated GIF. The module's "Animations" link points to the Newton's Method animations (`a2001/Animations/RootFinding/NewtonMethod/`), which are not this topic.
- The three cases match Ex 1(b), 2 and 4 in function, p₀ and root, and Mathews' iterates agree (the review's table and my mpmath runs: 1.00606…, 0.994152…).
- Archive slips noted and not copied: Ex 3/5 call the quintic a "cubic polynomial", and Ex 6(b)/(c) call the order-6 root a "double root" (the code uses m = 6). The page sentence names the polynomial by degree and the Ex 6 root as "higher multiplicity", both computed.

## Notes
- F1 is fixed by text rather than a log-error inset or a per-frame zoom (D7; the brief's "smallest change" lesson). If Jason wants the linear rate visible in the picture itself, a |x_n − 1| log-scale inset would be the next step.
- The page's Description/Animations structure and Case 2 were left as they were. Case 2's later steps are also small on screen, but no finding names it and its text makes no picture claim beyond the legend values, so I did not change it.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fix is text only. `accnewtonaa.jl` and `accnewtonaa.gif` are unchanged (`git diff --quiet HEAD` on both). The fixer chose the finding's minimum option: a sentence saying the later steps cannot be seen and show only in the legend.
- Iterates at 40 digits (mpmath), x0 = 1.2: errors are 0.2, 0.10303, 0.052356, 0.026401, 0.013258, **0.0066434** (x5), 0.0033254, …, 5.2016e-5 (x12). So "from x5 on, the iterate is less than 0.007 from the root" is true, and x4 (0.0133) is not under 0.007, so x5 is the right place to start.
- Marker cover, measured on the committed frames (red-pixel extent, rows > 100): the red disc spans 8 px. Its centre is at 233, 227, 223, 222 and 220 px in frames x3, x4, x5, x6 and x12. The x = 1 axis position is about 220 px (the x12 centre, 5e-5 from the root).
  - At x4 the root is about 7 px from the centre, just outside the disc.
  - From x5 on the root is about 3 px from the centre, inside the disc.
- Full-size frame 006 (x5) shows the dot sitting on the root. "Its marker covers the root" from x5 is therefore true.
- The new alt-text clause says the same thing and is true.
- The picture limitation itself remains, as accepted by the finding's "at the least" option.

### F2 — resolved
- The script change is the tangent segment only: steelblue solid becomes black, `ls=:dash`, lw 1.5. The construction is unchanged.
  - The segment (x_n, h(x_n)) → (x_{n+1}, 0) is the Newton tangent of h. Newton on h from 1.2, using mpmath `diff`, gives 0.99415204678…, which equals the script's Method B x1.
- The zoomed frame 002 (new vs old, crop 230–350 × 270–360, 4×) shows visible black dashes along the green curve between x ≈ 1 and 1.2. Before the fix, the steelblue-on-green segment could not be made out.
  - Pixel diff from old to new: about 200 px change by more than 30 in frames 2–5, all inside the tangent's bounding box (x 248–330, y 292–347).
  - Frame 1 differs only by palette quantisation (max channel-sum diff 56).
- The text now says the tangent nearly coincides with the nearly straight h. It also says that the overshoot to x1 = 0.994152 and the later steps are too small to see, and are read from the legend. Both statements are true.
  - h' runs from 0.5 at x = 1 to 0.4711 at 1.2, and h'' is about −0.13 to −0.17.
  - The largest gap between the tangent and h on [x1, x0] is 0.00293, about 1.5 px.
  - The overshoot is 0.00585 in x, about 2.2 px, inside the marker. In frame 002 the dot sits on the root.
- The legends in frames 1–5 read 1.2, 0.994152, 0.999994, 1.0, 1.0, which matches the text.
- The overshoot itself is still not visible in the picture. The finding accepted "stands out + text" as one option, and the fixer chose it.

### F3 — resolved
- A two-sentence paragraph was added at the end of the Animations section. This follows R2-A: say what was left out, do not add the example. I checked each claim against the archive (`NewtonAccelerateMod.html` text plus formula images gr_31–35, 158–160, 274–276, 334–335):
  - The module title "Accelerated and Modified Newton Methods" matches.
  - Cases 1–3 reproduce Examples 1(b), 2 and 4, all at the double root p = 1 of x³−3x+2 from p0 = 1.2. True.
  - Example 1(a) is standard Newton at the simple root p = −2 of the same cubic (p0 = −2.4). True.
  - Example 3 is the accelerated method and Example 5 the modified method, each at the double root p = 1 and the triple root p = 2 of x⁵−8x⁴+25x³−38x²+28x−8. sympy gives `(x - 2)**3*(x - 1)**2`. The archive itself calls this a "cubic", so the page's "fifth-degree" is the correct wording.
  - Example 6(a–c) applies the standard, accelerated and modified methods at p = 1 of −x⁷+8x⁶−27x⁵+50x⁴−55x³+36x²−13x+2. sympy gives `-(x - 2)*(x - 1)**6`, so the root has order 6 and "a root of higher multiplicity" is true.
- The page no longer presents the m = 2 cases without saying what was left out.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Case 1 Behavior, new sentence | "only the first few steps can be told apart" | Marker-centre offset from the root: about 13, 7, 3, 2 px for x3–x6, against an 8 px disc. Frames x6–x12 move by ≤ 2 px. | True |
| Case 1 | "from $x_5$ on … less than 0.007 from the root" | e5 = 0.0066434 < 0.007; e4 = 0.013258 | True |
| Case 1 | "its marker covers the root" (from x5) | Root about 3 px from the disc centre (disc radius about 4 px) from frame x5 on, about 7 px at x4 | True |
| Case 1 | "remaining halvings show only in the legend value" | Error ratios 0.515 … 0.50001; the legend has 6 decimals | True |
| Case 1 alt | "from x₅ on the marker covers the root and the progress shows only in the legend value" | As above | True |
| Case 3 Behavior | "plots h(x) = (x−1)(x+2)/(3(x+1)) with the tangent lines dashed" | sympy: f/f' = (x−1)(x+2)/(3(x+1)). Script draws the tangent with `ls=:dash`, black, as seen in the frames. The drops are solid steelblue and are not called tangents. | True |
| Case 3 | "h is nearly straight between the root and x0" | h' from 0.500 to 0.471, h'' about −0.13 to −0.17 on [1, 1.2] | True |
| Case 3 | "first tangent lies almost on the curve" | Largest gap 0.00293, about 1.5 px | True |
| Case 3 | "takes the iterate in one step to x1 = 0.994152, just left of the root" | x1 = 0.994152046784, so e1 = −0.00585 | True |
| Case 3 | "that overshoot and the later steps are too small to see" | Overshoot about 2.2 px, inside the marker. x1→x2 is about 2.2 px and x2→x3 about 0.002 px. | True |
| Case 3 | "$x_2 = 0.999994$" | 0.999994277965 | True |
| Case 3 | "$x_3$ equals 1 to six decimals" | 0.999999999995 (e3 = −5.46e-12); legend shows 1.0 | True |
| Case 3 | quadratic convergence (alt and heading) | e_{n+1}/e_n²: 0.146, 0.167, 0.1667, which tends to h''/(2h') = −1/6 in magnitude | True |
| Case 3 alt | "dashed tangent from x₀=1.2 lies almost on the nearly straight curve … to x₁=0.994152, just left of x=1 (double root of f) … x₃ equal to 1 to six decimals, without knowing the multiplicity" | As above | True |
| New paragraph, sentence 1 | "reproduce Examples 1(b), 2 and 4 of Mathews' Accelerated and Modified Newton Methods module, all at the double root of the same cubic" | Archive text and images gr_31–35, 118–120, 233–235 | True |
| New paragraph, sentence 2 | Examples 1(a), 3, 5, 6 as described (simple root of that cubic; accelerated and modified methods at a double and a triple root of a fifth-degree polynomial; all three methods at a root of higher multiplicity) | Archive text and images. sympy factorisations (x−2)³(x−1)² and −(x−2)(x−1)⁶ | True |
| accnewtoncc.jl comment | "dashed black so it stands out where it lies almost on the nearly straight curve h" | Matches the code and the frames | True |

### New problems
None. This rests on:
- every changed sentence, number and alt-text clause checked above by independent mpmath and sympy computation and by pixel measurement on the committed frames;
- the old/new frame diff being confined to the tangent's bounding box, so nothing else in the Case 3 picture changed;
- the Case 1 and Case 2 scripts and GIFs being unchanged.

Not a defect: the dashed tangent has no legend entry. The text names it, and the legend was not touched.

### Reproducibility and conventions
- `accnewtoncc.jl`, run from a scratch copy, gives a GIF byte-identical to the committed one (sha256 76825b2e…52e1, matching the LFS pointer in the diff). Its decoded framemd5 also matches.
- `accnewtonaa.*` and `accnewtonbb.*` are unchanged from HEAD.
- Conventions hold:
  - Description (line 10) comes before Animations (line 24).
  - Each case has a `[Julia source]` link and a GIF embed with descriptive alt text.
  - There are no code blocks (0 triple backticks).
- The fix diff touches only the page folder: `accnewtoncc.gif`, `accnewtoncc.jl` and `index.qmd`. The other modified paths in the working tree belong to other pages' fixes and are not part of this diff.

**Final status:** committed
