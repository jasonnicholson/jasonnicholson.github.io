# Fix record: newton-raphson-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/newton-raphson-method/fix/`

- `indep.py`: independent mpmath/sympy computation (30 digits) for cases 1, 4, 5. Run `/usr/bin/python3 -I indep.py`.
- `ledger_checks.py`: extra checks for the new sentences. Run `/usr/bin/python3 -I ledger_checks.py`.
- `instr.jl`: instrumented copy of the iterate loops of `newtonaa.jl`, `newtondd.jl` and `newtonee.jl` (same f, f', x0, n_iters), printing the iterates and their legend roundings. Run `julia instr.jl`.
- `committed/`: copies of the GIFs before the fix, with frames extracted. `new/newtondd/`: frames of the regenerated GIF.

## Findings

### F1 — Error — fixed
- Reproduced: `indep.py` gives `aa root: 0.25485005902885` and `aa f(0.2910): 0.181464`. `instr.jl` gives a script x5 of `0.25485005902898933`, with legend `0.25485`. The page's 0.2910 is wrong.
- Change: index.qmd:20 "near $x^* \approx 0.2910$" → "$x^* \approx 0.2549$". index.qmd:25 alt "x≈0.291" → "x≈0.2549".
- Check: root 0.254850059… rounds to 0.2549. `f(0.2549) = 0.000243682` (indep.py), the residual you would expect from a 4-decimal rounding.

### F2 — Error — fixed
- Reproduced: `indep.py` finds the sign-change roots on [−20, 3]: −17.2787596, −14.1371664, −10.9955869, −7.8536904, −4.71908156, −1.3812061 and 0.254850059. Only 0.254850059 lies in [0, 1.5]. `ledger_checks.py` gives f(−(2k+1)π) ≈ +4.13, +4.00, … and f(−2kπ) ≈ −3.99, −4.0, …, so f changes sign in every interval of length π going left. That means infinitely many negative roots. Also f(0) = −1 and min f′ on [0, 1.5] = 3.0 > 0, so there is exactly one positive root.
- Change: index.qmd:20 "A single real root exists near …" → "The function has a single positive root, $x^* \approx 0.2549$ (it also has infinitely many negative roots, outside the plotted window)."
- Check: as above. The window is xlims = (0.0, 1.5) in newtonaa.jl, so no negative root is in it.

### F3 — Error — fixed
- Reproduced: `indep.py` iterates 1.0, 0.4797520156, 0.2857383591, 0.2555769005, 0.2548504777, 0.254850059. Errors 0.74515, 0.2249, 0.030888, 0.00072684, 4.1871e-7, 1.3908e-13, all positive. `ledger_checks.py`: "x*<x_{n+1}<x_n for all n: True". f″ = 3eˣ + 4cos x has a minimum of 7.74161 on [x*, 1], and f(1) = 5.99364 > 0. The iterates never overshoot.
- Change: index.qmd:21 "each tangent line rapidly overshoots then undershoots before converging — illustrating …" → "on the convex side of the root, each tangent line lands between the root and the previous iterate, so the iterates decrease monotonically to $x^*$ (1, 0.4798, 0.2857, 0.2556, 0.254850, …); the number of correct digits roughly doubles each step — the quadratic convergence …". Alt text: "rapid convergence" → "rapid, monotone convergence … down to".
- Check: correct digits −log10|e| = 0.128, 0.648, 1.51, 3.14, 6.38, 12.9 (indep.py). Successive ratios 2.33, 2.08, 2.03, 2.02 (ledger_checks.py).

### F4 — Error — fixed (text, and the plot window widened)
- Reproduced: `ledger_checks.py` gives real roots [−1.6716999]. `indep.py` gives the complex pair 0.83584994 ± 1.04686932i, f(−2) = −3 and f(0) = 3, local min f(1/√3) = 2.615099821 and local max f(−1/√3) = 3.384900179. The old window xlims (−0.5, 3.5) cut off the crossing (committed frame_011 viewed: no crossing visible).
- Change: index.qmd:44 heading → "Cycling (non-convergence)". index.qmd:46–47 → "$f$ has one real root, $x^* \approx -1.6717$, where the curve crosses the axis at the left of the window. Starting at $x_0 = 0$, the iterates are drawn into an attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475 → … and never approach the root — Newton-Raphson can fail even when a root exists." Alt text rewritten to match. newtondd.jl: xlims (−0.5, 3.5) → (−2.0, 3.5) and ylims (−3.0, 30.0) → (−4.0, 30.0), so the crossing and the curve's left end (f(−2) = −3) are inside the frame. The GIF was regenerated.
- Why the window changed: the finding says the cropped window made the frames appear to support the false "no root" claim. Widening the window is a two-number change and leaves the iterates unchanged. Text alone ("the root is outside the window") would also have been correct. Widening was chosen so that the picture shows the point the case is making.
- Check: new frames 001, 005 and 011 were viewed at full size. The curve crosses y = 0 between −2 and −1.5, near −1.67, in every frame, and both local extrema are visible. Iterates and legends are unchanged (x₍4₎ = 0.0066, x₍10₎ = 1.9619). The review's suggested wording "trapped to the right of the local extrema" was **not** used, because it is false: x0 = 0 and the cycle point 0.0074 lie between the extrema ±0.57735.

### F6 — Misleading — fixed (covered by the F4 rewrite)
- Reproduced: `indep.py` gives x0..x10 = 0.0, 3.0, 1.96154, 1.14718, 0.00657937, 3.00039, 1.96182, 1.14743, 0.00725625, 3.00047, 1.96188. x196..x200 = 0.0074460774, 3.0004983, 1.9618967, 1.1475016, 0.0074460774. Over 200 iterates the min is 0.0 and the max is 3.0005, so the sequence is bounded. Solving N⁴(x) = x gives the 4-cycle [0.0074460774, 3.0004983, 1.9618967, 1.1475016]. N²(c) − c = 1.95445, so it is not a 2-cycle. The cycle multiplier ∏ N′ = ∏ f f″/f′² = 0.232505 < 1, so the cycle is attracting.
- Change: "cycle or diverge", "divergence" and "divergent" were removed from the heading, the Behavior text and the alt text (see F4).
- Check: as above. The script iterates (instr.jl) match to every printed digit.

### F5 — Error — fixed
- Reproduced: `indep.py` gives x0..x6 = 2.0, 4.0, 5.33333, 6.5641, 7.74383, 8.89211, 10.0188, steps all positive (2.0, 1.33333, 1.23077, 1.17972, 1.14828, 1.12671), and slopes f′(x_n) = −0.1353, −0.05495, −0.02092, … (shallow, not steep). f(x_n) = 0.2707 … 0.0004464, and x1000 = 1008.68. `ledger_checks.py`: N(x) simplifies to x²/(x−1), and N(x) − x = x/(x−1) > 0 for x > 1. f′(1) = 0 and f″(1) = −e⁻¹, so x = 1 is the maximum. The only zero of f is x = 0. Script values (instr.jl): 2.0, 4.0, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188. The committed GIF (sheet viewed) shows the red point moving right every frame, and all 7 iterates are inside xlims (0, 11).
- Change: index.qmd:53 heading → "Divergence to infinity". index.qmd:55–56 → "The only root is $x^* = 0$, but $x_0 = 2$ lies beyond the maximum of $f$ at $x = 1$. There $f > 0$ and $f'(x) = (1-x)e^{-x} < 0$, so each tangent line meets the axis to the right: $x_{n+1} = x_n^2/(x_n - 1) > x_n$. The iterates run off toward $+\infty$ (2, 4, 5.33, 6.56, …, 10.02 after six steps) while $f(x_n) \to 0$ — a small residual does not mean a root is near." Alt text rewritten to match. The animation was already right and was not changed (D7).
- Check: as above.

### F7 — Minor — fixed
- Reproduced: the iterates (instr.jl and indep.py, see F6) form a 4-cycle, not a cycle "between ~0 and ~3". The comment at newtondd.jl:4 was wrong.
- Change: newtondd.jl:4 "# Newton iterates cycle between ~0 and ~3 indefinitely" → "# Newton iterates are attracted to a 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475". A comment line was added: "# The only real root, x* ≈ -1.6717, is never approached (window widened to show it)".
- Check: cycle values and multiplier as in F6. Root as in F4.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:20 | "single positive root, $x^* \approx 0.2549$" | indep.py → `aa root: 0.25485005902885`. ledger_checks.py → f(0) = −1, min f′ on [0,1.5] = 3.0 | yes |
| index.qmd:20 | "infinitely many negative roots, outside the plotted window" | ledger_checks.py → f(−(2k+1)π) ≈ +4, f(−2kπ) ≈ −4 (k ≥ 1). indep.py → negative roots −1.3812061 … −17.2787596. xlims (0, 1.5) | yes |
| index.qmd:21 | "on the convex side of the root" | indep.py → min f″ on [x*,1] = 7.74161, f(1) = 5.99364 > 0 | yes |
| index.qmd:21 | "each tangent line lands between the root and the previous iterate … decrease monotonically" | ledger_checks.py → `x*<x_{n+1}<x_n for all n: True` | yes |
| index.qmd:21 | "1, 0.4798, 0.2857, 0.2556, 0.254850" | ledger_checks.py → [1.0, 0.4798, 0.2857, 0.2556, …] and x4 6dp = 0.25485(0). indep.py → x4 = 0.2548504777 | yes |
| index.qmd:21 | "correct digits roughly doubles each step" | indep.py → digits 0.648, 1.51, 3.14, 6.38, 12.9. ratios 2.33, 2.08, 2.03, 2.02 | yes |
| index.qmd:25 alt | "rapid, monotone convergence from x₀=1.0 down to the root at x≈0.2549" | as rows above | yes |
| index.qmd:44 | heading "Cycling (non-convergence)" | indep.py → bounded 4-cycle, no convergence over 200 iterates | yes |
| index.qmd:46 | "one real root, $x^* \approx -1.6717$" | ledger_checks.py → real_roots [−1.6716999]. sympy nroots → −1.67169988165716 | yes |
| index.qmd:46 | "the curve crosses the axis at the left of the window" | newtondd.jl xlims (−2.0, 3.5). new frames 001/005/011 viewed: crossing near −1.67 is visible | yes |
| index.qmd:47 | "attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475" | indep.py → cycle [0.0074460774, 3.0004983, 1.9618967, 1.1475016], multiplier 0.232505, N²(c)−c = 1.95445 | yes |
| index.qmd:47 | "never approach the root" | indep.py → min over 200 iterates = 0.0, so the distance to −1.6717 is always ≥ 1.67 | yes |
| index.qmd:51 alt | "settle into a 4-cycle near 0.0074, 3.0005, 1.9619 and 1.1475 and never reach the real root at x≈−1.6717" | as rows above. script legends x8..x10 = 0.0073, 3.0005, 1.9619 (instr.jl) | yes |
| index.qmd:53 | heading "Divergence to infinity" | indep.py → x1000 = 1008.68. ledger_checks.py → N(x) − x = x/(x−1) > 0 | yes |
| index.qmd:55 | "only root is $x^*=0$" | ledger_checks.py → solve(x e⁻ˣ) = [0] | yes |
| index.qmd:55 | "maximum of $f$ at $x = 1$" | ledger_checks.py → f′(1) = 0, f″(1) = −e⁻¹ | yes |
| index.qmd:55 | "There $f>0$ and $f'(x) = (1-x)e^{-x} < 0$" | x > 1: x e⁻ˣ > 0 and (1−x) < 0. sympy diff gives f′ = (1−x)e⁻ˣ (ledger_checks.py uses sp.diff) | yes |
| index.qmd:55 | "$x_{n+1} = x_n^2/(x_n-1) > x_n$" | ledger_checks.py → N simplified = x²/(x−1). N − x = x/(x−1) > 0 for x > 1 | yes |
| index.qmd:56 | "2, 4, 5.33, 6.56, …, 10.02 after six steps" | indep.py → 2.0, 4.0, 5.33333, 6.5641, …, 10.0188 (x6). instr.jl → 10.018818672756456 | yes |
| index.qmd:56 | "$f(x_n) \to 0$" | indep.py → f(x_n) 0.2707 → 0.0004464. x_n → ∞ (x1000 = 1008.68) and x e⁻ˣ → 0 | yes |
| index.qmd:60 alt | "each tangent line meets the axis further right, and the iterates move away from the root at x=0 toward +∞" | indep.py → steps all positive (2.0 … 1.12671) | yes |
| newtondd.jl:4 | "4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475" | as index.qmd:47 | yes |
| newtondd.jl:5 | "only real root, x* ≈ -1.6717, is never approached" | as index.qmd:46–47 | yes |
| newtondd.jl:19–20 | xlims (−2.0, 3.5), ylims (−4.0, 30.0) | instr.jl → f(−2.0) = −3.0 > −4. all f(x_n) in [2.99, 27.02], so the clamp in the script stays a no-op | yes |

## Scripts and GIFs
- Scripts changed: `newtondd.jl` (header comment, xlims and ylims). No other script was changed.
- GIFs regenerated: `newtondd.gif` (`julia newtondd.jl` from the page folder). The GIFs for unchanged scripts were not regenerated and are untouched.
- Frames viewed (`new/newtondd/`): frame_001 (x₍0₎ = 0.0, the whole curve, root crossing near −1.67, both extrema), frame_005 (x₍4₎ = 0.0066, the first lap of the cycle drawn) and frame_011 (x₍10₎ = 1.9619, the last frame). Tangent segments run from (x_n, f(x_n)) to (x_{n+1}, 0), and vertical drops go to f(x_{n+1}). The title is unclipped and the legend is legible. All iterate y-values (≤ 27.02) are inside ylims, so nothing is clamped. Committed `newtonee` sheet and `newtondd` frame_011 were also viewed before the change.
- `git status --short -- pages/numerical-methods/newton-raphson-method` after regeneration: ` M index.qmd`, ` M newtondd.gif`, ` M newtondd.jl`.

## Legacy archive
Consulted: `n2003/Newton'sMethodMod.html` and `newtonsmethod/Newton'sMethodMod/Links/*_lnk_4..8.html`. The formula images gr_374/375, 454/455, 484/485 and the graph gr_393 were viewed. The animated examples in the archive are:
- Example 3, "Fast Convergence": 3 Exp[x] − 4 Cos[x] = 0, p0 = 1.0. This is Animation 1 (Newtonaa). The archive graph gr_393 (on [0, 1]) shows the curve crossing the axis near 0.25, consistent with x* = 0.2549.
- Example 4, "Slow Convergence" (Newtonbb).
- Example 5, "Convergence, Oscillation" (Newtoncc).
- Example 6, "NON Convergence, Cycling": x³ − x + 3 = 0, p0 = 0.0. This is Animation 4 (Newtondd).
- Example 7, "NON Convergence, Diverging to Infinity": x e⁻ˣ = 0, p0 = 2.0. This is Animation 5 (Newtonee).

Mathews' own labels for cases 4 and 5 ("Cycling" and "Diverging to Infinity") agree with the computed behaviour and with the corrected headings. The page's old claims ("no real root", "convergence") were not from the archive. The archive's graphs and iteration images for examples 6 and 7 (gr_456, gr_483, gr_486, gr_513) are not in the archive copy, so his window for case 4 could not be compared. Newtonff (Case 6) has no matching example in this module's list.

## Notes
- The round-1 suggested text for F4 said the iterates are "trapped to the right of the local extrema". That is false: x0 = 0 and the cycle point 0.0074 lie between the extrema at ±0.57735. The text was not used.
- D7: the Case 1 and Case 5 animations were right, so only their text changed. For Case 4 the finding said the cropped window made the frames appear to support the false claim. The window was widened, the smallest change that makes the picture honest, and the iterates are unchanged.
- Not touched: index.qmd:14 says "traces the convergence (or divergence) toward a root". "Divergence toward a root" is awkward wording, but it was not a finding. Cases 2, 3 and 6 were not part of this brief and were left unchanged.

### Director note

The resolution checker observed that this page has no `## Description` section before `## Animations`, which the page conventions require. That was already so at the start of the run and was not a round-1 finding. Adding a Description is new content, so it was left for Jason to decide (or for the round-2 review to raise).

## Resolution check (independent checker, not shown this record)

Work files: `check/nums.py`, `check/nums2.py` (mpmath at 40 digits), `check/run/` (scratch reruns), `check/new_dd/`, `check/old_dd/`, `check/ee/`, `check/aa/` (extracted frames).

### Original findings

### F1 — resolved
- Evidence: index.qmd:20 now says $x^* \approx 0.2549$; alt text says x≈0.2549. mpmath findroot gives 0.25485005902885025…, which rounds to 0.2549. The GIF's last frame reads "x₍5₎ = 0.25485", which matches. The value 0.2910 no longer appears on the page.

### F2 — resolved
- Evidence: the page now says "a single positive root … (it also has infinitely many negative roots, outside the plotted window)". Positive root is unique: for x > ln(4/3) ≈ 0.288, 3eˣ > 4 ≥ 4cos x, so f > 0. On (0, 0.288), f' = 3eˣ + 4 sin x > 0. A sign-change scan of [−40, 0] finds 13 negative roots (…, −7.85369, −4.71908, −1.38121), one near each zero of cos x, since 3eˣ → 0. That makes infinitely many. The window is xlims = (0, 1.5) in newtonaa.jl, so all of them lie outside it.

### F3 — resolved
- Evidence: the "overshoots then undershoots" wording is gone. My iterates are 1, 0.4797520, 0.2857384, 0.2555769, 0.2548504777, 0.254850059. The errors are all positive and decreasing (0.745, 0.225, 0.0309, 7.27e-4, 4.19e-7, 1.39e-13). Correct digits run 0.65, 1.51, 3.14, 6.38, 12.86, so they roughly double each step. On [x*, 1], f'' = 3eˣ + 4cos x ≥ 7.74 > 0, and f(1) > 0, so "convex side" is correct. Every quoted iterate rounds correctly. In the contact sheet (aa/sheet.png), every tangent foot is to the right of the root.

### F4 — resolved
- Evidence: the heading is now "Cycling (non-convergence)". The text says there is one real root, x* ≈ −1.6717. mpmath polyroots gives −1.67169988, plus 0.83585 ± 1.04687i, so this is correct. The false "no real roots / minimum above zero / intercept that does not exist" wording is gone. The alt text was rewritten. The script window was widened to xlims (−2, 3.5) and ylims (−4, 30). In the full-size frames (new_dd/frame_001, _006, _011), the curve crosses the axis near x ≈ −1.67, and f(−2) = −3 is inside ylims. This matches "the curve crosses the axis at the left of the window".

### F5 — resolved
- Evidence: the heading is now "Divergence to infinity". I checked each claim:
  - The maximum of x e^{-x} is at x = 1 (f' = 0 there).
  - For x > 1, f > 0 and f' < 0.
  - x²/(x−1) reproduces each iterate.
  - The iterates are 2, 4, 5.33333, 6.5641, 7.74383, 8.89211, 10.0188, so "10.02 after six steps" holds.
  - f(x_n) runs 0.271 → 4.46e-4, so it tends to 0.

  The alt text now says the iterates move right toward +∞. The unchanged GIF (ee/sheet.png) shows every tangent meeting the axis to the right of the previous point, and the final label reads x₍6₎ = 10.0188. The page now agrees with the animation and with the script header.

### F6 — resolved
- Evidence: "divergence" and "diverge" are gone from Case 4. Over 400 iterations from x0 = 0, the iterates stay in [0, 3.0005]. They converge to the 4-cycle 0.0074460774 → 3.0004983 → 1.9618967 → 1.1475016. Solving N⁴(x) = x gives the same values. The cycle multiplier ∏ f f''/f'² = 0.2325, which is below 1, so the cycle is attracting, as the text says.

### F7 — resolved
- Evidence: newtondd.jl:4 now reads "Newton iterates are attracted to a 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475", which is correct (see F6). The new line 5 is also correct: "The only real root, x* ≈ -1.6717, is never approached (window widened to show it)".

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:20 | "single positive root, x* ≈ 0.2549" | findroot 0.254850059…; uniqueness argument above | correct |
| index.qmd:20 | "infinitely many negative roots, outside the plotted window" | 13 sign changes on [−40,0], one per zero of cos; window (0,1.5) | correct |
| index.qmd:21 | "convex side of the root" | f'' ≥ 7.74 on [x*,1], f(x0)=6.06>0 | correct |
| index.qmd:21 | "lands between the root and the previous iterate … decrease monotonically" | errors all positive and decreasing | correct |
| index.qmd:21 | 1, 0.4798, 0.2857, 0.2556, 0.254850 | 1, 0.47975, 0.28574, 0.25558, 0.2548504777 | correct |
| index.qmd:21 | "correct digits roughly double each step" | 0.65→1.51→3.14→6.38→12.86 | correct |
| index.qmd:25 alt | "rapid, monotone convergence from x₀=1.0 down to the root at x≈0.2549" | as above; frames agree | correct |
| index.qmd:44 heading | "Cycling (non-convergence)" | attracting 4-cycle, no convergence | correct |
| index.qmd:46 | "one real root, x* ≈ −1.6717" | polyroots −1.671699881…; other two complex | correct |
| index.qmd:46 | "crosses the axis at the left of the window" | xlims (−2,3.5); crossing visible in frames | correct |
| index.qmd:47 | "attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475" | N⁴ fixed point 0.0074461, 3.0004983, 1.9618967, 1.1475016; multiplier 0.2325 | correct |
| index.qmd:47 | "never approach the root" | iterates confined to [0, 3.0005] | correct |
| index.qmd:51 alt | 4-cycle values; "never reach the real root at x≈−1.6717" | as above | correct |
| index.qmd:53 heading | "Divergence to infinity" | x_{n+1} > x_n for x_n > 1, step → 1 | correct |
| index.qmd:55 | "x0 = 2 beyond the maximum of f at x = 1" | f'(1)=0, f'' (1) < 0 | correct |
| index.qmd:55 | "f > 0 and f' = (1−x)e^{-x} < 0" there | sign check for x > 1 | correct |
| index.qmd:55 | "x_{n+1} = x_n²/(x_n − 1) > x_n" | x − x/(1−x) = x²/(x−1); numerically reproduces iterates | correct |
| index.qmd:56 | "2, 4, 5.33, 6.56, …, 10.02 after six steps" | 2, 4, 5.33333, 6.5641, …, x6 = 10.0188 | correct |
| index.qmd:56 | "f(x_n) → 0" | 0.271, 0.0733, …, 4.46e-4 | correct |
| index.qmd:60 alt | "each tangent line meets the axis further right … toward +∞" | frames ee/ | correct |
| newtondd.jl:4 | 4-cycle values | as above | correct |
| newtondd.jl:5 | "x* ≈ -1.6717 never approached (window widened to show it)" | as above; frames | correct |
| newtondd.jl:19–20 | xlims (−2.0, 3.5), ylims (−4.0, 30.0) | root −1.67 and f(−2) = −3 both inside | correct |

### New problems

None introduced by the fix. This rests on three checks:
- Every changed sentence, number and alt text was checked independently (ledger above).
- The new newtondd.gif was inspected at full size. I looked at frames 1, 6 and 11, and compared frame 11 against the pre-fix GIF. The tangent segments go from (x_n, f(x_n)) to (x_{n+1}, 0). The legend labels (x₍5₎ = 3.0004, x₍10₎ = 1.9619) match the computed iterates and are legible. The only visual change is the wider window, and nothing that was right before is broken.
- Case 1 and Case 5 text now agree with their unchanged GIFs.

Pre-existing, not caused by the fix and not among the findings: the page has no `## Description` section before `## Animations`. The HEAD version lacks it too. animation-page.agent.md:12/205 requires it (Minor, convention).

### Reproducibility and conventions

- newtondd.jl (the only changed script) was run from a scratch copy, and its output is byte-identical to the committed newtondd.gif (sha256 ce56544a…). newtonaa.jl and newtonee.jl, whose page text changed, were also rerun; both outputs are byte-identical to the committed GIFs.
- Every case still has a `[Julia source]` link and a GIF embed with descriptive alt text. There are no code blocks. The Description-section gap is pre-existing, as noted above.
- The diff for this page touches only files in pages/numerical-methods/newton-raphson-method/. The working tree also has changes in other page folders (bisection, fixed-point, runge-kutta, trapezoidal) and in pages/numerical-methods/index.qmd, where three links were changed from folder/ to .qmd. Those belong to other pages' work and are not part of this page's diff. Nothing in them references the Newton-Raphson page.

**Final status:** committed
