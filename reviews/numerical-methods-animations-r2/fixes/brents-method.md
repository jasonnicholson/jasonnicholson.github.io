# Fix record: brents-method

Scratch folder (evidence scripts and outputs): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/brents-method/fix/`

## Findings

### F1 — Minor — fixed
- Reproduced:
  - `julia trace_aa.jl` (copy of `brentsaa.jl` lines 1–106 printing a, b, c after each step) shows that step 3 (IQI) is computed from (a, b, c) = (0.8, 0.4, 0.0) and produces c = 0.22760580197149965.
  - `/usr/bin/python3 -I checks.py`:
    - the line-32 formula at those points gives `IQI s = 0.2276058019714996`;
    - fitting x = P(y) with `np.polyfit([ya,yb,yc],[a,b,c],2)` and evaluating at y = 0 gives `0.22760580197149918` (the same point);
    - fitting the forward parabola y = q(x) gives roots `[1.0696992 0.33387223]`.
  - The old sentence ("fits a quadratic through the three points … uses the x-intercept") therefore describes a different step (0.33387) from the one the formula and the script take (0.2276).
- Change: `index.qmd` line 16. Before: "fits a quadratic through the three points $(a, f(a))$, $(b, f(b))$, $(c, f(c))$ and uses the $x$-intercept of that quadratic." After: "fits $x$ as a quadratic function of $y$ through the three points $(a, f(a))$, $(b, f(b))$, $(c, f(c))$ (a sideways parabola) and evaluates it at $y = 0$."
- Check: `/usr/bin/python3 -I lagr.py` (sympy). The quadratic x = P(y) interpolating (y_a, a), (y_b, b), (y_c, c) satisfies P(0) − (line-32 formula) = `0` symbolically, and P reproduces all three points (`[0, 0, 0]`). The new sentence therefore describes exactly the formula on line 32 and the code.

### F2 — Minor — fixed
- Reproduced:
  - Frame 1 of the committed `brentsaa.gif` (`giftools.jl` → `frames_aa/frame_001.png`, viewed at full size) shows the x-window from −0.15 to 3.1, with the curve crossing zero near 0.33, 1.26 and 2.41. Only the crossing in [0, 1] is discussed on the page.
  - The archive's Example 4 (`BrentMethodMod_lnk_6.html`) is "Use Brent's Method to find the three roots of the cubic polynomial". Its Root (ii) and Root (iii) outputs (gr_242, gr_253) start from [1., 2.] and [2., 3.] and give b = 1.26465829006442 and 2.406803251324166, for f[x] = −4 + 17x − 16x² + 4x³.
- Change: `index.qmd` Case 1 Behavior. One sentence was appended after "… regula falsi 24.": "The window also shows the cubic's other two roots, $x \approx 1.2647$ in $[1, 2]$ and $x \approx 2.4068$ in $[2, 3]$; Mathews' example also finds these with Brent's method, but only the run on $[0, 1]$ is animated here."
  - I chose the sentence over narrowing `xlims`. Mathews' own graph (gr_224, `Plot[f[x], {x, 0, 3}]` in gr_223) shows all three roots, so the wide window is faithful. Adding the sentence needs no regeneration.
- Check: `/usr/bin/python3 -I checks.py`:
  - `sympy.real_roots` gives 0.32853845861141489597, 1.2646582900644196963 and 2.4068032513241654077, which round to 1.2647 and 2.4068.
  - The signs are f(1) = 1, f(2) = −2 and f(3) = 11, so [1, 2] and [2, 3] each bracket one root.
  - `mpmath.findroot` on each bracket returns the same roots.
  - The archive's computed b values (above) agree with these roots to their printed digits.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.16 | "fits $x$ as a quadratic function of $y$ through the three points … (a sideways parabola) and evaluates it at $y = 0$" | `python3 -I lagr.py` → P(0) − formula = 0, P interpolates the 3 points; `checks.py` → P(0) = 0.22760580197149918 = script's 0.22760580197149965 to 15 digits | yes |
| index.qmd Case 1 Behavior | "The window also shows the cubic's other two roots" | Frame 1 of `brentsaa.gif` viewed: xlims (−0.15, 3.1); zero crossings near 1.26 and 2.41 visible; ylims (−4.5, 8.5) contain the curve around both crossings | yes |
| same | $x \approx 1.2647$ in $[1, 2]$ | sympy root 1.2646582900644197; f(1) = 1, f(2) = −2 | yes |
| same | $x \approx 2.4068$ in $[2, 3]$ | sympy root 2.4068032513241654; f(2) = −2, f(3) = 11 | yes |
| same | "Mathews' example also finds these with Brent's method" | Archive lnk_6 Example 4 text "Use Brent's Method to find the three roots"; gr_242 / gr_253 outputs from [1.,2.] and [2.,3.] | yes |
| same | "only the run on $[0, 1]$ is animated here" | Page has two cases: brentsaa.jl (a0 = 0.0, b0 = 1.0) and brentsbb.jl (tan x − 2x on [0.5, 1.5]) | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. Both findings are text-only.
- I viewed frame 1 of the committed `brentsaa.gif` (9 frames) to confirm the picture claim in F2.
- `git status --short -- pages/numerical-methods/brents-method` → ` M pages/numerical-methods/brents-method/index.qmd` (only).

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/brentmethod/`. This snapshot has no `BrentMethodMod.html`, only `BrentMethodMod/Links/*_lnk_1..7.html` and Images. What the archive has:
- Examples 1–3 apply the secant and inverse-quadratic methods alone to a cubic.
- Example 4 runs Brent's method on f(x) = 4x³ − 16x² + 17x − 4 for all three roots, on [0, 1], [1, 2] and [2, 3]. Its plot is over [0, 3].
- Example 5 is tan x = 2x on [0.5, 1.5].
- Case 1 is Example 4 root (i), and Case 2 is Example 5.
- The fixed page now says that roots (ii) and (iii) are not animated.

## Notes
- **F2 placement.** I put the F2 sentence in the Case 1 Behavior, as the finding suggested, rather than in the R2-A "left out" source-note position after the last embed. This is part of one example rather than a whole example, and the sentence explains what is visible in that case's GIF.
- **Examples 1–3 are not mentioned.** Examples 1–3 (secant alone, IQI alone, and their comparison at simple and double roots) are not animated, and the page does not mention them. No finding names this, so I added nothing; it is left to the director under R2-A.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `index.qmd` line 16 now reads "fits $x$ as a quadratic function of $y$ through the three points ... (a sideways parabola) and evaluates it at $y = 0$." That is inverse quadratic interpolation. It agrees with the line-32 formula and the scripts' IQI branch.
- Check (`check/chk.py`): at $(a,b,c) = (0.8, 0.4, 0)$ the line-32 formula gives 0.2276058019714996. `np.polyfit` of $x$ on $y$ (degree 2), evaluated at $y=0$, gives 0.22760580197149918, so the new wording and the formula give the same point. The forward parabola $y=q(x)$ has roots [1.0697, 0.33387], which is a different point, so the old reading really was wrong. $|f(0.2276)| = 0.912 > |f(0.4)| = 0.496$, which is consistent with the unchanged step-3 narrative.
- The scripts and GIFs did not need to change for this finding, and they did not.

### F2 — resolved
- Evidence: one sentence was added to the end of the Case 1 Behavior paragraph. It names the other two roots, $x \approx 1.2647$ in $[1,2]$ and $x \approx 2.4068$ in $[2,3]$, says Mathews' example also finds them with Brent's method, and says only the $[0,1]$ run is animated. This is the "add one sentence" route that the finding allows and that R2-A sets for an omitted part of an example.
- The numbers: the mpmath roots are 1.264658290064420 and 2.406803251324165, so both round correctly. There is a sign change on each interval: $f(1)=1$, $f(2)=-2$, $f(2)=-2$, $f(3)=11$.
- The archive claim: `BrentMethodMod_lnk_6.html` (Solution 4) runs "Root (i)", "Root (ii)", ... with "Use Brent's Method to find the root that lies in the interval ...". So the sentence is accurate.
- The window claim: `brentsaa.gif` frame 1, viewed at full size, shows the curve crossing zero near 1.26 and 2.41 inside `xlims = (-0.15, 3.1)`.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.16 | "fits $x$ as a quadratic function of $y$ ... evaluates it at $y=0$" | polyfit $x(y)$ at $y=0$ equals the line-32 formula (0.227605801971499) | correct |
| index.qmd l.16 | "(a sideways parabola)" | a quadratic in $y$ is a parabola with a horizontal axis | correct |
| index.qmd l.66 | "The window also shows the cubic's other two roots" | GIF frame 1 viewed; both crossings are inside the plotted window | correct |
| index.qmd l.66 | $x \approx 1.2647$ in $[1,2]$ | mpmath 1.26465829006442; $f(1)=1$, $f(2)=-2$ | correct |
| index.qmd l.66 | $x \approx 2.4068$ in $[2,3]$ | mpmath 2.40680325132417; $f(2)=-2$, $f(3)=11$ | correct |
| index.qmd l.66 | "Mathews' example also finds these with Brent's method" | archive Solution 4 (lnk_6) applies Brent's method to roots (i), (ii), ... of the cubic | correct |
| index.qmd l.66 | "only the run on $[0,1]$ is animated here" | brentsaa.jl uses a0=0, b0=1, and there is no other cubic case | correct |

### New problems
None. This rests on the following:
- The diff touches only two lines of `index.qmd`, and each added claim was checked independently above.
- No script or GIF in the page folder changed (`git diff --quiet HEAD` on all four files).
- The unchanged text that depends on the IQI interpretation (the step-3 narrative) is consistent with the new wording.

### Reproducibility and conventions
- Reproducibility: no script or GIF changed, so there was nothing to regenerate. The committed `brentsaa.gif` decodes to 9 frames.
- Conventions:
  - Description still comes before Animations.
  - Each case has a `[Julia source]` link and a GIF embed with descriptive alt text.
  - There are no code blocks.
- Scope:
  - Within this page folder, only `index.qmd` is modified.
  - Other modified files in the working tree belong to other pages' parallel fixes, plus the untracked `reviews/numerical-methods-animations-r2/fixes/brents-method.md` record. None of them is part of this page's diff.

**Final status:** committed
