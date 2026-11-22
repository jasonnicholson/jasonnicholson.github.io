# Fix record: halleys-method

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/halleys-method/fix/`
- `indep.py` / `indep.out`: mpmath (120 digits) Newton and Halley sequences for both examples, plus the correction factor along the Halley iterates.
- `float64_seq.jl` / `float64_seq.out`: Float64 Newton and Halley sequences for Example 2, using the same expressions as `halleysba.jl`.
- `archive/`: upscaled archive formula images (gr_58, gr_61–64, gr_175–178) and the stacked Example 2(a) error table (gr_201–207).
- `frames_ba/`: frames of the (unchanged) `halleysba.gif`.

## Findings

### F1 — Minor — fixed
- Reproduced: `python3 -I indep.py`. The displayed equivalent form (line 22) has no bracketed factor; the correction is the second fraction. The page's condition "$f''$ small relative to $f'$" is not what makes the factor close to 1. The ratio $r = f f''/(2f'^2)$ along the Halley iterates:
  - Case 2: $f''/f'$ = −1.14583, −1.33105, −1.33333 (not small, and growing in size), while r = 0.101852, 1.37033e-3, 1.94253e-9 and the factor $1/(1-r)$ = 1.113402, 1.001372, 1.000000002.
  - Case 1: $f''/f'$ = 0.5, 0.7, 0.707107 (growing), while r = 0.125, 0.005, 1.28836e-7 and the factor = 1.142857, 1.005025, 1.000000129.
  - From $x_1$ of Case 2: Newton −2.00000282833, Halley −2.00000000291. From $x_1$ of Case 1: Newton 1.41428571429, Halley 1.41421392678. Both match the review's evidence.
- Change: `index.qmd` line 24. Before: "The bracketed factor is a multiplicative correction to the Newton step. When $f''$ is small relative to $f'$, the denominator is close to 1 and Halley reduces to Newton-Raphson." After: "The second factor, $1\big/\bigl(1 - f(x_n)\, f''(x_n)/(2[f'(x_n)]^2)\bigr)$, is a multiplicative correction to the Newton step. When $|f(x_n)\, f''(x_n)|$ is small compared with $2[f'(x_n)]^2$, which always happens close to a simple root, this factor is close to 1 and the Halley step nearly coincides with the Newton step."
- Check: the factor is the second fraction of the line-22 formula (read). Halley step = Newton step × factor, so the relative difference between the steps is factor − 1 = r/(1 − r). Close to a simple root of a smooth f, $f(x_n)\to0$, $f'(x_n)\to f'(x^*)\ne0$ and $f''$ stays bounded, so r → 0. The numbers above show r → 0 in both cases even though $|f''/f'|$ grows.

### F2 — Minor — fixed (text; no new case, per R2-A)
- Reproduced:
  - Archive: `Halley'sMethodMod_lnk_4.html` is "Solution 2 (a)", Newton-Raphson on $f(x)=x^3-3x+2$ (gr_175) with $p_0=-2.2$ (gr_177). The page has no case for it. It has Case 1a (Ex 1(a)), Case 1b (Ex 1(b)) and Case 2 (Ex 2(b)).
  - Script: `halleysba.jl` l.78–81 draws the blue diamond at `x_cur - fv/fpv`, where `x_cur` is the current Halley iterate. It is therefore a one-step comparison, not Newton's sequence. Frame 2 of `halleysba.gif`, viewed at full size, shows the blue diamond at Newton-from-$x_1$ (legend "−2.0").
  - The sentence "demonstrating that Halley requires fewer iterations…" rested on a sequence the page does not show.
  - mpmath (`indep.out`) errors:
    - Newton from −2.2: 0.2, 2.22222e-2, 3.22061e-4, 6.91267e-8, 3.18566e-15, 6.76564e-30, 3.05159e-59.
    - Halley from −2.2: 0.2, 2.06186e-3, 2.9138e-9, 8.24629e-27.
  - The Newton errors match Mathews' printed 2(a) table (gr_201–207: 2.0e-1, 2.2222e-2, 3.2206119e-4, 6.9126677e-8, 3.18566483e-15, 6.76564028e-30, 3.05159256e-59) to all digits shown.
- Change (`index.qmd`):
  - Case 2 Behavior: the sentence "demonstrating that Halley requires fewer iterations to attain high precision at simple roots" is replaced by Newton's own error sequence against Halley's, and by the double-precision step counts.
  - After the last embed, new source note (two lines, one paragraph): which Mathews examples the cases follow; Example 2(a) is not animated; what the blue diamond shows.
  - R2-A says not to add the example, so no Case 2a GIF was made.
- Check: numbers are in the ledger. Float64 (`julia float64_seq.jl`):
  - Newton x4 = −2.000000000000003 (≠ −2) and x5 = −2.0 exactly.
  - Halley x2 = −2.0000000029138016 (≠ −2) and x3 = −2.0 exactly.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Iteration Formula, l.24 | "The second factor, $1/(1 - f f''/(2[f']^2))$" | Second fraction of the l.22 display (read the file) | yes |
| l.24 | "is a multiplicative correction to the Newton step" | Halley step = (f/f')·factor (l.22 algebra; review D5 confirmed the equivalent form) | yes |
| l.24 | "When $\lvert f f''\rvert$ is small compared with $2[f']^2$ … this factor is close to 1" | factor = 1/(1−r) with r = ff''/(2f'^2); indep.out: r 0.1019→1.4e-3→1.9e-9 gives factor 1.113→1.0014→1.000000002 | yes |
| l.24 | "which always happens close to a simple root" | f→0, f'→f'(x*)≠0, f'' bounded for smooth f, so r→0; indep.out shows r→0 in both cases while \|f''/f'\| grows (0.5→0.707; 1.146→1.333) | yes |
| l.24 | "the Halley step nearly coincides with the Newton step" | relative difference = factor−1; from Case 2 x1: Newton −2.00000282833, Halley −2.00000000291 (both steps ≈ 0.00206 long, 0.14% apart) | yes |
| Case 2 Behavior | "In extended precision, Newton's own iterates from $x_0=-2.2$ have errors of about 2.2e-2, 3.2e-4, 6.9e-8 and 3.2e-15 after steps 1–4" | indep.py (mp.dps=120): 2.22222e-2, 3.22061e-4, 6.91267e-8, 3.18566e-15; matches Mathews gr_201–207 | yes |
| Case 2 Behavior | "against Halley's 2.1e-3, 2.9e-9 and 8.2e-27 after steps 1–3" | indep.py: 2.06186e-3, 2.9138e-9, 8.24629e-27 | yes |
| Case 2 Behavior | "in double precision Newton first reaches −2 exactly at $x_5$, Halley at $x_3$" | float64_seq.jl: Newton x4=−2.000000000000003, x5==−2.0 true; Halley x2=−2.0000000029138016, x3==−2.0 true (same update as halleysba.jl l.32) | yes |
| Source note after last embed | "Cases 1a, 1b and 2 follow Examples 1(a), 1(b) and 2(b) of Mathews' Halley's Method module." | Archive: lnk_2 "1 (a) Newton-Raphson", lnk_3 "1 (b) Halley", f = x²−2 (gr_61), p0 = 2 (gr_63, gr_64); lnk_5 "2 (b) Halley", f = x³−3x+2 (gr_175), p0 = −2.2 (gr_178). Scripts: halleysaa.jl l.10/13/28 (x²−2, 2.0, Newton), halleysab.jl l.10/14/32 (x²−2, 2.0, Halley), halleysba.jl l.10/14/32 (x³−3x+2, −2.2, Halley) | yes |
| Source note | "The module's Example 2(a), which applies Newton-Raphson iteration to the Case 2 function from the same starting value, is not animated here" | lnk_4 "Solution 2 (a)… Form the Newton-Raphson iteration function g(x)", gr_175 f, gr_177 p0 = −2.2. Its error table reproduces with Newton (above). Page has 3 cases / 3 GIFs, none of them Newton on x³−3x+2 | yes |
| Source note | "Case 2's blue diamond shows only the Newton step from the current Halley iterate" | halleysba.jl l.78–81: `x_newton = x_cur - fv / fpv`, with x_cur = xs[frame+1] (l.48, the Halley iterate). Frame 2 viewed: blue diamond at −2.0 (Newton from x1 = −2.00206) | yes |

Unchanged numbers in the edited paragraph were rechecked: Halley $x_1\approx-2.002$ (−2.0020619), Newton $x_1\approx-2.022$ (−2.0222222), "within 0.0021" (2.0619e-3).

## Scripts and GIFs
- No scripts changed and no GIFs regenerated (text-only fixes).
- Frames viewed: `halleysba.gif` frame 2, extracted with giftools into `frames_ba/`, to confirm what the blue diamond marks.
- `git status --short -- pages/numerical-methods/halleys-method` → ` M pages/numerical-methods/halleys-method/index.qmd` only.
- The page was not rendered with Quarto in this run. The new math is plain inline LaTeX (`\big/`, `\bigl`, `\times10^{-k}`).

## Legacy archive
- Consulted: `n2003/Halley'sMethodMod.html` and `halleysmethod/Halley'sMethodMod/Links/lnk_1–5`.
- Examples: two examples, each in parts (a) Newton and (b) Halley.
  - Ex 1: $x^2-2$, $p_0=2$.
  - Ex 2: $x^3-3x+2$, $p_0=-2.2$.
  - Mathews works at 100 digits: 7 Newton terms and 5 Halley terms.
- Formula text: the module says "The term in brackets shows where Newton-Raphson iteration function is changed". gr_58 (the square-root specialisation) writes the factor in parentheses with exponent −1. This is the source of the old "bracketed" wording, which no longer fits the page's restyled formula.
- Example 2(a): its error table (gr_201–207) was checked against an independent mpmath run and agrees.
- Legacy GIFs: no Halley animation GIF exists under `a2001/Animations/` (`ls -R … | grep -i hal` → nothing).
- Differences: the page now states that Example 2(a) is omitted, as R2-A requires. Otherwise the page's parameters match the archive.

## Notes
- F2 offered two options: add Case 2a, or text. R2-A ("add one sentence… do not add the example") and the D5 smallest-change rule point to text. Newton's sequence is given as numbers in the Behavior, and the omission is stated in a source note after the last embed, following the Monte Carlo π pattern. The page had no legacy note, so the note opens with one sentence naming what the page follows.
- The review's suggested phrase "folded into the blue comparison marker" was not used. The blue marker shows Newton from the current Halley iterate, and that equals Newton's own iterate only in frame 1.
- The cost claim D12 ("significantly faster overall" for high precision) was left untouched. It is not a finding, and the review recorded it as undetermined (no benchmark).

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: index.qmd line 24 no longer speaks of a "bracketed factor". It names the second factor explicitly as $1/(1 - f f''/(2f'^2))$, which matches the displayed formula on line 22 (algebra: $x - \frac{2ff'}{2f'^2 - ff''} = x - \frac{f}{f'}\cdot\frac{1}{1 - ff''/(2f'^2)}$). The condition is now "$|f f''|$ small compared with $2[f']^2$". That is exactly the condition for the factor to be close to 1. "which always happens close to a simple root" is true: $f \to 0$ while $f' \to f'(x^*) \ne 0$ and $f''$ stays bounded (smooth $f$), so the ratio goes to 0. Numerical check (mpmath, 120 digits): at Case 2's $x_0=-2.2$ the ratio is 0.10185 and the factor 1.11340. At Case 1's $x_0=2$ the ratio is 0.125. Both are consistent with "close to 1 near the root, not exactly 1 farther out".

### F2 — resolved
- Evidence: The fixer chose the finding's second option, which also matches owner decision R2-A ("add one sentence when a whole Mathews example is left out; do not add the example"):
  - Case 2's Behavior paragraph now gives Newton's own iterate sequence next to Halley's.
  - A new note after Case 2 says that Example 2(a) is not animated and what the blue diamond shows.
- The Mathews archive confirms the mapping. Halley'sMethodMod.html, Example 2 has 2(a) Newton-Raphson and 2(b) Halley on the same function; lnk_4 is Solution 2(a), Newton; lnk_5 is Solution 2(b), Halley.
- All numbers check independently (see the ledger). The claim "Halley requires fewer iterations" now has the comparison shown on the page: 3 steps against 5 in double precision.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.24 | "second factor, $1/(1 - f f''/(2[f']^2))$" | Matches line 22's second factor; algebraic identity with line 18 verified | OK |
| l.24 | "multiplicative correction to the Newton step" | Newton step $f/f'$ times factor | OK |
| l.24 | "When $\|f f''\|$ small compared with $2[f']^2$ … factor close to 1" | $1/(1-r)\to1$ as $r\to0$ | OK |
| l.24 | "which always happens close to a simple root" | $f\to0$, $f'\ne0$, $f''$ bounded, so $r\to0$; numerically $r$ = 0.102 at −2.2, 3.4e-4 at −2.00206 | OK |
| l.66 | Halley $x_1 \approx -2.002$; Newton $x_1\approx-2.022$ (unchanged) | −2.0020619, −2.0222222 | OK |
| l.66 | Newton errors after steps 1–4: 2.2e-2, 3.2e-4, 6.9e-8, 3.2e-15 | mpmath 120 dps: 0.02222, 3.221e-4, 6.913e-8, 3.186e-15 | OK |
| l.66 | Halley errors after steps 1–3: 2.1e-3, 2.9e-9, 8.2e-27 | 2.062e-3, 2.914e-9, 8.246e-27 | OK |
| l.66 | "in extended precision" | 120-digit run reproduces them; Mathews used 100 digits | OK |
| l.66 | "in double precision Newton first reaches −2 exactly at $x_5$, Halley at $x_3$" | Float64: Newton x4 = −2.000000000000003, x5 = −2.0; Halley x2 = −2.0000000029138016, x3 = −2.0. The script uses the same Halley formula | OK |
| l.72 | "Cases 1a, 1b and 2 follow Examples 1(a), 1(b) and 2(b)" | Archive: Ex1 x²−2, p0=2 (a Newton, b Halley); Ex2 (b) Halley. Matches case functions and starts | OK |
| l.73 | "Example 2(a) … applies Newton-Raphson iteration to the Case 2 function from the same starting value, is not animated here" | Archive lnk_4: Solution 2(a) is Newton-Raphson on Example 2's function; starting value −2.2 per the original finding (gr images). No Newton-only GIF exists for Case 2 | OK |
| l.73 | "Case 2's blue diamond shows only the Newton step from the current Halley iterate" | halleysba.jl: `x_newton = x_cur - fv/fpv` with `x_cur = xs[frame+1]` (Halley iterates), plotted as a steelblue diamond. In frame 2 the legend reads "Newton xₙ₊₁ ≈ -2.0" and the blue diamond sits under the orange one | OK |

### New problems
None. This rests on the following:
- Every added sentence and number was checked against my own 120-digit and Float64 runs, the script source and the Mathews archive.
- No script or GIF changed. The only change in the page folder is index.qmd: 5 insertions, 2 deletions.
- Style note, not a defect: the R2-A note is two sentences, not one. It is placed after the Case 2 embed, so it renders under the Case 2 heading. The text names all three cases, so it reads correctly there.

### Reproducibility and conventions
- Reproducibility: not applicable. No .jl or .gif in the page folder changed; `git diff --stat HEAD` lists only index.qmd. I extracted halleysba.gif (6 frames) only to confirm the blue-diamond claim.
- Conventions still hold:
  - the Description comes before the Animations;
  - each of the 3 cases has a source link and a GIF embed;
  - the alt text is descriptive and unchanged;
  - there are no code blocks.
- Outside the page folder: the working tree has many other modified pages and untracked review records. They come from other pages' parallel fixes. This page's diff touches nothing outside `pages/numerical-methods/halleys-method/`.

**Final status:** committed
