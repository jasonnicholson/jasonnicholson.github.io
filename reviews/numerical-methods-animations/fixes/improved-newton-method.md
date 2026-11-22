# Fix record: improved-newton-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/improved-newton-method/fix/`

- `instr.jl`: instrumented copies of the iterate loops of `newtonimpaa/bb/cc/dd.jl`. It runs the committed expanded-form f, f′ and the factored forms now in the scripts, against a 512-bit BigFloat reference. It prints iterates, legend roundings, Float64 f against exact f, and the slopes of the drawn segments. Run `julia instr.jl`.
- `indep.py`: independent mpmath (120 digits) and sympy computation. It covers Method A on both polynomials, and standard Newton, Method B and Method C (Mathews' linear-search rule) on arctan from 1.4. Run `/usr/bin/python3 -I indep.py`.
- `ledger_checks.py`: symbolic checks for the new sentences. Run `/usr/bin/python3 -I ledger_checks.py`.
- `titletest/`: title font-size trial renders. `committed/`: the GIFs and scripts before the fix, with frames extracted. `new/`: frames of the regenerated GIFs.

## Findings

### F1 — Error — fixed
- Reproduced: `instr.jl` (committed dd loop) gives x = 1.3, 1.0088235294117645, 1.0000086167285056, 1.000000641886474, 1.0007193769128275, 1.000000057738013. The labels are 1.000001 and 1.000719 for x₃ and x₄. The 512-bit reference errors are 8.82e-3, 8.62e-6, 8.25e-12, 7.56e-24 and 6.35e-48. At the script's x₃, the expanded f is −8.881784197001252e-16 while the exact f is 7.934069861507476e-19, so the sign is wrong. `indep.py` gives e/e² = 0.0980, 0.110677, 0.111111, 0.111111. Committed frame_005 was viewed: its legend reads "x₍4₎ = 1.000719" while the marker sits on x = 1. This agrees with the checker's correction that the jump appears only in the legend.
- Change (old line numbers): newtonimpdd.jl:12–13, `f(x) = x^4 - x^3 - 3x^2 + 5x - 2` and `fp(x) = 4x^3 - 3x^2 - 6x + 5` → `f(x) = (x - 1)^3 * (x + 2)` and `fp(x) = (x - 1)^2 * (4x + 5)`, with a two-line comment giving the reason. :17 `n_iters = 5` → `n_iters = 3`, with a comment. GIF regenerated. index.qmd Case 4 sentence "the iterate reaches $x \approx 1$ in just a couple of steps" → "the animated iterates are $1.3$, $1.008824$, $1.000009$ and then $x_3$, which is within $10^{-11}$ of the root (labelled 1.0)".
- Check: `instr.jl` gives factored x = 1.3, 1.0088235294117647, 1.0000086167279412, 1.0000000000082498, labels 1.3, 1.008824, 1.000009, 1.0. These differ from the reference error by at most 1e-16. Beyond n = 3 the factored loop gives 1.0 and then NaN, which is why it stops at 3. sympy confirms that the factored f′ equals the expanded f′ (`(x - 1)**2*(4*x + 5)`). New frames 001, 003 and 004 were viewed. The legends read x₍0₎ = 1.3, x₍2₎ = 1.000009 and x₍3₎ = 1.0, and the orange segment runs from (1.3, 0.0891) to the axis near 1.009.

### F2 — Error — fixed
- Reproduced: the archive (NewtonImprovedMod.html, formula (10), image gr_51) defines Method B as x − f f′/((f′)² − f f″), which is Newton applied to u = f/f′. `indep.py`: sympy confirms that B equals Newton on u (`True`), with u = (x²+1)·atan x, u′ = 2x·atan x + 1 and u″ = 2(x + (x²+1)atan x)/(x²+1). The B iterates from 1.4 are 0.631573, 0.171166, 0.00624689, 3.25005e-7, 4.57729e-20 and 1.27869e-58, strictly decreasing and positive (`True`). The claim "A, B and C do not fix this case" is false for B.
- Change: index.qmd Case 5 lines 64–66 replaced. A now gets its own sentence: with m = 1 it is standard Newton and does not fix the case. B is defined in one clause and stated to converge monotonically, with four iterates. C is described under F5. The closing sentence now names A and C only.
- Check: see the ledger rows for Case 5. Monotone convergence follows because u is increasing (u′ ≥ 1) and convex for x > 0, so each Newton tangent's zero lies in [0, xₙ). It was also confirmed numerically (`indep.py`).

### F3 — Minor — fixed
- Reproduced: `instr.jl` (committed bb loop) gives x₃ = 1.0000000001306446, with expanded f(x₃) = 2.220446049250313e-16 against an exact 5.12e-20. x₄ = 0.9999994335946778 (label 0.999999). The reference err(x₄) is 2.92e-21. Committed frame_005 was viewed and shows "x₍4₎ = 0.999999".
- Change (old line numbers): newtonimpbb.jl:12–13 → `f(x) = (x - 1)^2 * (x + 2)` and `fp(x) = 3 * (x - 1) * (x + 1)`, with a comment. :17 `n_iters = 5` → `3`, with a comment. GIF regenerated. No text change was needed, because the page text and alt text ("in just a few steps") already match three steps.
- Check: the factored loop gives 1.3, 1.0130434782608697, 1.0000281716593107, 1.000000000132272, labels 1.3, 1.013043, 1.000028, 1.0, within 1.5e-16 of the reference. The next steps would be 1.0 and then NaN. New frames 003 (x₍2₎ = 1.000028) and 004 (x₍3₎ = 1.0) were viewed. `indep.py` gives e/e² = 0.144928, 0.165587, 0.166664, so the convergence is quadratic.

### F4 — Minor — fixed
- Reproduced: `instr.jl` gives a dd segment slope of 0.306 = f′(1.3)/3 = 0.918/3, and a bb segment slope of 1.035 = f′(1.3)/2 = 2.07/2, so these segments are not tangents. `ledger_checks.py` gives atan′(0) = 1, so Case 5's root is simple. The intro sentence called all five a "tangent-line diagram … on functions with multiple roots".
- Change: index.qmd:12 replaced by two sentences: "Each animation below traces a Newton-type iteration: Cases 1–4 use functions with a multiple root at $x = 1$, and Case 5 uses $\arctan x$, which has a simple root at $x = 0$." and "For standard Newton (Cases 1, 3, 5) each drawn line is the tangent at $x_n$; for Method A (Cases 2, 4) it is the line of slope $f'(x_n)/m$."
- Check: `ledger_checks.py` gives roots {−2: 1, 1: 2} and {−2: 1, 1: 3}. Scripts aa, cc and ee draw (xₙ, f(xₙ)) → (xₙ − f/f′, 0), whose slope is f′(xₙ), the tangent. bb and dd draw (xₙ, f(xₙ)) → (xₙ − m f/f′, 0), whose slope is f′/m (numbers above).

### F5 — Minor — fixed
- Reproduced: B is cited only by name, and C's test is written as |x_{n,m} − p| < |x_{n,m−1} − p|, which uses the unknown root. The archive's own test is in f-values: formula (21), image gr_109, is |f(p₀)| > |f(p₁)| > … > |f(p_m)|. The algorithm box (gr_115) computes p₁ = p₀ − Δx and p₂ = p₀ − 2Δx and continues while |y₂| < |y₁|. So m = 1 is always taken, and m grows only while |f| keeps decreasing.
- Change: index.qmd Case 5. B is defined inline (see F2). C is defined inline: "Method C (adaptive Newton) computes $x_{n,m} = x_n - m\,f(x_n)/f'(x_n)$, starting from the Newton step $m = 1$ and increasing $m$ while $|f(x_{n,m+1})| < |f(x_{n,m})|$". The behaviour that follows was rewritten from computation: for arctan, C keeps m = 1 at every step and diverges exactly as standard Newton does. The old "the search never succeeds" was imprecise, because under the archive's rule the m = 1 step is always accepted. I defined the methods inline where they are cited, rather than adding a `## Description` section. That is the smallest change that makes the cited methods defined. See Notes.
- Check: `indep.py` gives step-1 candidates −1.41362 and −4.22724 with |f| = 0.955118 and 1.33851. C's chosen m for 6 steps is [1, 1, 1, 1, 1, 1], with iterates 1.4, −1.41362, 1.45013, −1.55063, 1.84705, −2.89356, 8.71033, identical to standard Newton. The general argument is in `ledger_checks.py`. d(x) = atan(x)(1+x²) satisfies d(0) = 0 and (d − x)′ = 2x·atan x > 0, so d > x for x > 0, and by odd symmetry for x < 0. Hence x − d lies on the other side of 0, and |x − 2d| > |x − d|. Because |atan| increases with |x|, |f(x_{n,2})| > |f(x_{n,1})| at every step.

### F6 — Minor — fixed
- Reproduced: committed frames `committed/newtonimpcc/frame_013.png` and `committed/newtonimpdd/frame_005.png` were viewed. Both titles end "(triple root at x=", cut off at the right edge. The aa, bb and ee titles fit (aa frame_011, bb frame_005 and ee frame_007 viewed).
- Change: added `titlefontsize=12` to the `plot(...)` call in newtonimpcc.jl:35 and newtonimpdd.jl:39. The title text is unchanged.
- Check: in `titletest/t12_cc.png` and `t12_dd.png` the full title fits with a margin. In the new frames `new/newtonimpcc/frame_013.png` and `new/newtonimpdd/frame_004.png` the full title, ending "(triple root at x=1)", is visible.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:12 | "Cases 1–4 use functions with a multiple root at $x = 1$" | ledger_checks.py → roots {−2: 1, 1: 2} and {−2: 1, 1: 3} | yes |
| index.qmd:12 | "Case 5 uses $\arctan x$, which has a simple root at $x = 0$" | ledger_checks.py → atan(0) = 0, atan′(0) = 1 | yes |
| index.qmd:13 | "For standard Newton (Cases 1, 3, 5) each drawn line is the tangent at $x_n$" | aa/cc/ee code draws (xₙ, f(xₙ)) → (xₙ − f/f′, 0), slope f′(xₙ) | yes |
| index.qmd:13 | "for Method A (Cases 2, 4) it is the line of slope $f'(x_n)/m$" | instr.jl → dd slope 0.306 = 0.918/3, bb slope 1.035 = 2.07/2 | yes |
| index.qmd:52 | "animated iterates are $1.3$, $1.008824$, $1.000009$" | instr.jl → factored labels 1.3, 1.008824, 1.000009. new dd frames 001/003 | yes |
| index.qmd:52 | "$x_3$, which is within $10^{-11}$ of the root (labelled 1.0)" | instr.jl → x₃ = 1.0000000000082498 (err 8.25e-12). indep.py → 8.24975e-12. new dd frame_004 legend "x₍3₎ = 1.0" | yes |
| index.qmd:65 | "Method A with the correct multiplicity ($m = 1$ for this simple root) is standard Newton … does not fix this case" | ledger_checks.py → A with m = 1 equals Newton (True). indep.py → Newton iterates 1.4, −1.41362, 1.45013, −1.55063, 1.84705, −2.89356, 8.71033 | yes |
| index.qmd:66 | "Newton's method applied to $u = f/f' = (1+x^2)\arctan x$" and "$x_{n+1} = x_n - \tfrac{f f'}{(f')^2 - f f''}$" | indep.py → u = (x²+1)atan(x). "Method B == Newton on u ? True". Archive formula (10), gr_51, is the same formula | yes |
| index.qmd:66 | "$u$ is increasing and convex for $x > 0$" | indep.py → u′ = 2x·atan x + 1, u″ = 2(x+(x²+1)atan x)/(x²+1). ledger_checks.py → both positive for x > 0 (True, True) | yes |
| index.qmd:66 | "from $x_0 = 1.4$ its iterates decrease monotonically to the root" | indep.py → "B strictly decreasing and positive: True", last iterate 1.27869e-58 | yes |
| index.qmd:66 | "$0.6316$, $0.1712$, $0.00625$, $3.25 \times 10^{-7}$" | indep.py → 0.631573, 0.171166, 0.00624689, 3.25005e-7. ledger_checks.py roundings → 0.6316, 0.1712, 0.00625, 3.25e-07 | yes |
| index.qmd:67 | C's definition: "$x_{n,m} = x_n - m\,f(x_n)/f'(x_n)$, starting from … $m = 1$ and increasing $m$ while $\lvert f(x_{n,m+1})\rvert < \lvert f(x_{n,m})\rvert$" | Archive formula (13) (gr_76), test (21) (gr_109), algorithm box (gr_115): p₁ = p₀ − Δx, then continue while \|y₂\| < \|y₁\| | yes |
| index.qmd:67 | "the $m = 1$ step always crosses to the other side of $0$" | ledger_checks.py → (d − x)′ = 2x·atan x > 0, d(0) = 0, so d > x for x > 0, and by odd symmetry for x < 0 | yes |
| index.qmd:67 | "$x_{1,1} \approx -1.41$", "$x_{1,2} \approx -4.23$, with larger $\lvert f\rvert$" | indep.py → −1.413619, −4.227237. \|f\| 0.955118 < 1.33851 | yes |
| index.qmd:67 | "C keeps $m = 1$ at every step and diverges exactly as standard Newton does" | indep.py → chosen m [1, 1, 1, 1, 1, 1], C iterates identical to the Newton iterates. General argument as above | yes |
| index.qmd:68 | "Methods A and C are designed for multiplicity and do not repair a global-convergence failure like this one" | A: archive "Method A … root of order m". C: archive "linear search … to determine m". Both diverge here (rows above) | yes |
| newtonimpbb.jl:12–13 comment | "Float64 gives f(1 + 1.3e-10) = 2.2e-16 instead of 5.1e-20" | instr.jl → committed x₃ = 1.0000000001306446, fexp = 2.220446049250313e-16, fexact = 5.1204039424450154e-20 | yes |
| newtonimpbb.jl:14–15 | `f(x) = (x - 1)^2 * (x + 2)`, `fp(x) = 3 * (x - 1) * (x + 1)` | indep.py → factor(F) = (x−1)²(x+2), factor(F′) = 3(x−1)(x+1) | yes |
| newtonimpbb.jl:19 comment | "x3 is within 1.4e-10 of the root; a 4th step would land on x = 1 exactly, then 0/0" | instr.jl → factored x₃ err 1.3227e-10, x₄ = 1.0, x₅ = NaN | yes |
| newtonimpdd.jl:12–13 comment | "Float64 gives f(1 + 6.4e-7) = -8.9e-16 instead of +7.9e-19" | instr.jl → committed x₃ = 1.000000641886474, fexp = −8.881784197001252e-16, fexact = 7.934069861507476e-19 | yes |
| newtonimpdd.jl:14–15 | `f(x) = (x - 1)^3 * (x + 2)`, `fp(x) = (x - 1)^2 * (4x + 5)` | indep.py → factor(F) = (x−1)³(x+2), factor(F′) = (x−1)²(4x+5) | yes |
| newtonimpdd.jl:19 comment | "x3 is within 1e-11 of the root; a 4th step would land on x = 1 exactly, then 0/0" | instr.jl → factored x₃ err 8.25e-12, x₄ = 1.0, x₅ = NaN | yes |
| newtonimpbb GIF legends | x₍0₎..x₍3₎ = 1.3, 1.013043, 1.000028, 1.0 | instr.jl factored labels. New frames 003 and 004 viewed | yes |
| newtonimpdd GIF legends | x₍0₎..x₍3₎ = 1.3, 1.008824, 1.000009, 1.0 | instr.jl factored labels. New frames 001, 003 and 004 viewed | yes |
| newtonimpcc/dd GIF titles | unchanged text, font size 12, unclipped | new cc frame_013 and dd frame_004 viewed | yes |

## Scripts and GIFs
- Scripts changed: `newtonimpbb.jl` (factored f, f′, n_iters 3), `newtonimpdd.jl` (factored f, f′, n_iters 3, titlefontsize 12) and `newtonimpcc.jl` (titlefontsize 12 only, so its iterates are unchanged). `newtonimpaa.jl` and `newtonimpee.jl` are untouched and were not regenerated.
- GIFs regenerated: `newtonimpbb.gif` (4 frames, was 6), `newtonimpcc.gif` (13 frames, every frame differs only by the title) and `newtonimpdd.gif` (4 frames, was 6). Each was run with `julia <script>.jl` from the page folder.
- Frames viewed at full size: bb 003 and 004; dd 001, 003 and 004; cc 013. I checked that each orange segment runs from (xₙ, f(xₙ)) to (xₙ₊₁, 0), that the legend values and indices match `instr.jl`, that the titles are complete, and that the root x = 1 is in the window.
- The aa and cc iterates were also checked for the same cancellation problem (`instr.jl`). They are not affected. Their expanded-form labels equal the factored and reference labels at every displayed step (aa x₁₀ = 1.000321, cc x₁₂ = 1.002423), because their errors stay ≥ 3e-4 and 2.4e-3.
- `git status --short -- pages/numerical-methods/improved-newton-method` after regeneration:
  ```
   M pages/numerical-methods/improved-newton-method/newtonimpbb.gif
   M pages/numerical-methods/improved-newton-method/newtonimpbb.jl
   M pages/numerical-methods/improved-newton-method/newtonimpcc.gif
   M pages/numerical-methods/improved-newton-method/newtonimpcc.jl
   M pages/numerical-methods/improved-newton-method/newtonimpdd.gif
   M pages/numerical-methods/improved-newton-method/newtonimpdd.jl
  ```
  plus `index.qmd` (text edits, made after this listing). These are the expected files only.

## Legacy archive
Consulted: `n2003/NewtonImprovedMod.html`, its Links (Examples 1–3) and the formula and table images.
- **Method definitions.** Method A is accelerated Newton x − m f/f′. Method B is modified Newton, the formula (10) used above, which is Newton on f/f′. Method C is adaptive Newton: it tries m = 1, 2, … while |f| decreases, by test (21) and the algorithm box gr_115. The page now uses these definitions.
- **Example 1** is x³ − 3x + 2 = 0 with p₀ = 1.3 (double root 1). **Example 2** is x⁴ − x³ − 3x² + 5x − 2 = 0 with p₀ = 1.3 (triple root 1). Both match the page's Cases 1–4.
- **Mathews ran Method A for exactly 3 iterations.** For Example 1 his table (gr_145) shows 1.01304347826087, 1.0000281716593167, 1.0000000001359235. For Example 2 (gr_174) it shows 1.008823529411764, 1.000008616730388, 1.000000641877757, with f[p₃] = −8.88e-16. This supports n_iters = 3. It also shows that Mathews' own machine-precision x₃ for Example 2 carries the same cancellation error as the old script (true x₃ = 1 + 8.25e-12). The fixed page follows the mathematics (factored evaluation), not the archive's printed x₃. The label precision (6 decimals) is the same either way.
- The archive has no arctan example on this module. Case 5 is not from this source module.

## Notes
- Round 1 defined B and C inline in Case 5 and did not add a `## Description` section. Round 2 added the section, because F5 names it explicitly (see below).
- The label format `round(x; digits=6)` was kept. x₃ is shown as "1.0", which is correct to 6 decimals. The Case 4 text now says x₃ is within 1e-11 of the root and is labelled 1.0, so the reader is not told it is exact.
- Case 5's ee animation and its other sentences (x_c ≈ 1.3917, escape to ±∞) were not part of any finding and were not changed. `indep.py` incidentally confirms x_c = 1.39174520027 and the Newton iterates up to 8.71033.
- Nothing outside the page folder was touched.

## Round 2 after check

The independent check found F1–F4 and F6 resolved, and F5 partly resolved: F5 explicitly asks for a short Description, so adding one is in scope.

- Change in index.qmd: a new `## Description` section (lines 10–19) before `## Animations`. It states the general Newton convergence rates, defines Methods A, B and C (C with the computable |f| test), and ends with one sentence on A and B and one on what the animations show. In Case 5 the definitions were moved to the Description instead of being repeated. The B sentence keeps only "Newton's method applied to $u = f/f' = (1+x^2)\arctan x$" (the explicit formula was removed). The C sentence now begins "Method C does not fix it:" (its definition was removed). No other text, script or GIF changed. No regeneration was needed.
- Evidence script: `round2_checks.py` in the scratch folder. Run `/usr/bin/python3 -I round2_checks.py`.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:12 | "For smooth $f$, when Newton-Raphson … converges to a root, it does so quadratically if the root is simple but only linearly if the root has multiplicity $m \ge 2$" | General statement (archive Theorem 1, (6)/(7)), labelled "for smooth f". On this page: round2_checks.py → Newton e_{n+1}/e_n at n = 29 is 0.5 (double) and 0.666667 (triple), so linear. Quadratic at a simple root is the standard theorem | yes |
| index.qmd:13 | "Mathews compares three improvements for multiple roots" | Archive Examples 1–3: "compare Methods A, B and C for finding the double/triple/quadruple root" | yes |
| index.qmd:15 | Method A: $x_{n+1} = x_n - m\,f(x_n)/f'(x_n)$ | Archive formula (8)/(9). Same formula as the scripts bb/dd line 31 (`xs[i] - m * f(xs[i]) / fp(xs[i])`) | yes |
| index.qmd:16 | Method B: Newton on $u = f/f'$, $x_{n+1} = x_n - \dfrac{f f'}{f'^2 - f f''}$ | round2_checks.py → "Newton on u == x - f f'/(f'^2 - f f''): True" for generic f. Archive formula (10) (gr_51) | yes |
| index.qmd:16 | "$u$ … has a simple root where $f$ has a multiple one" | round2_checks.py → for f = (x−1)^m g: u(1) = 0, u′(1) = 1/2, 1/3, 1/4 for m = 2, 3, 4 (in general u′(1) = g(1)/(m g(1)) = 1/m ≠ 0) | yes |
| index.qmd:17 | Method C: "starting from the Newton step $m = 1$, increases $m$ while $\lvert f(x_{n,m+1})\rvert < \lvert f(x_{n,m})\rvert$, and takes the last such point as $x_{n+1}$" | Archive algorithm box gr_115: p₁ = p₀ − Δx, p₂ = p₀ − 2Δx, while \|y₂\| < \|y₁\| set p₁ = p₂ and try the next j. On exit p₁ is the last point that decreased \|f\|, and it "should replace p₀". "Does not need m": the algorithm uses only f and f′ | yes |
| index.qmd:19 | "Started close enough to a multiple root, Methods A and B converge to it quadratically" | Archive (9) and (11): "Let the starting value be close to p … converges quadratically". On this page: indep.py → A e/e² → 0.166667 and 0.111111. round2_checks.py → B e/e² → −0.1667 and −0.1111 from x₀ = 1.3 (B iterate 1 − 0.01235 = 0.98765 matches the archive table's 0.9876543209876544) | yes |
| index.qmd:19 | "The animations show standard Newton and Method A; Case 5 also discusses Methods B and C" | Scripts aa, cc, ee use m = 1 (standard Newton). bb and dd use Method A. Case 5 text, lines 77–78 | yes |
| index.qmd:77 | "Method B (Newton's method applied to $u = f/f' = (1+x^2)\arctan x$) does:" | Unchanged content, shortened. Ledger rows for index.qmd:66 above (u formula, monotone iterates) | yes |
| index.qmd:78 | "Method C does not fix it:" | Ledger rows for index.qmd:67 above. C keeps m = 1 at every step and its iterates equal Newton's | yes |

F5 outcome after round 2: fixed. Methods A, B and C are defined in the Description, C's test uses computable quantities, and Case 5 refers to those definitions.

## Resolution check (independent checker, not shown this record)

Scratch work: `check/indep.py` (mpmath, 200 digits), `check/f64.jl` (Float64 replay of the new scripts), `check/run/` (scratch copies of the changed scripts, re-run), `check/frames_{bb,cc,dd}/` (new GIF frames), `check/oldframes_{bb,cc,dd}/` (pre-fix GIFs from HEAD via `git lfs smudge`, read-only).

### Original findings

### F1 — resolved
- newtonimpdd.jl now uses `f(x) = (x-1)^3*(x+2)`, `fp(x) = (x-1)^2*(4x+5)`. Expanding gives 4x³−3x²−6x+5, the same derivative as before. `n_iters = 3`.
- Float64 replay: 1.3, 1.0088235294117647, 1.0000086167279412, 1.0000000000082498. A 4th step gives exactly 1.0 and a 5th gives NaN, so stopping at 3 is necessary, and the script comment says so. mpmath reference: x−1 = 8.82353e-3, 8.61673e-6, 8.24975e-12. The Float64 values match to every printed digit.
- The new GIF has 4 frames. Their labels read x₍0₎=1.3, x₍1₎=1.008824, x₍2₎=1.000009 (frame 3 checked at full size) and x₍3₎=1.0 (frame 4 checked at full size). The jump to 1.000719 is gone.
- The Case 4 text and alt text ("quadratic convergence") now agree with the frames.
- The script comment says Float64 gives f(1+6.4e-7) = −8.9e-16 instead of +7.9e-19. I reproduced both values: −8.881784197001252e-16 and 7.934e-19.

### F2 — resolved
- The false sentence is gone. Line 65 says Method A with m = 1 is standard Newton and does not fix the case, which is true. Line 66 defines Method B as Newton on u = f/f′ = (1+x²)arctan x and says it converges.
- My check: in mpmath, B from 1.4 gives 0.631573, 0.171166, 0.00624689, 3.25005e-7, 4.58e-20, 1.28e-58. These are monotone and quadratic, and they match the page's 0.6316, 0.1712, 0.00625 and 3.25×10⁻⁷.
- The claim that u is increasing and convex for x > 0 holds: u′ = 1 + 2x·arctan x > 0 and u″ = 2·arctan x + 2x/(1+x²) > 0. I also checked both numerically on (0, 10]. Newton on an increasing convex function, started right of the root, decreases monotonically to it, so the argument is sound.
- Line 68 now limits the "do not repair" claim to A and C.

### F3 — resolved
- newtonimpbb.jl now uses `f(x) = (x-1)^2*(x+2)`, `fp(x) = 3(x-1)(x+1)` (equal to 3x²−3), and `n_iters = 3`.
- Float64 gives 1.3, 1.0130434782608697, 1.0000281716593107, 1.000000000132272. mpmath gives errors of 1.30435e-2, 2.81717e-5 and 1.32272e-10, which agree.
- The 4 new frames have labels 1.3, 1.013043, 1.000028 and 1.0 (frames 2 and 4 checked at full size). The 0.999999 artefact is gone.
- The comment says expanded Float64 gives f(1+1.3e-10) = 2.2e-16 instead of 5.1e-20. I reproduced 2.220446e-16 against an exact 5.12e-20.

### F4 — resolved
- Lines 12–13 now say: Cases 1–4 have a multiple root at x = 1, and Case 5 is arctan with a simple root at 0. The drawn line is the tangent for standard Newton (Cases 1, 3, 5) and has slope f′(xₙ)/m for Method A (Cases 2, 4).
- This matches the code. aa, cc and ee draw (xₙ,f(xₙ))→(xₙ − f/f′, 0), which is the tangent. bb and dd draw (xₙ,f(xₙ))→(xₙ − m·f/f′, 0), whose slope is f′/m.
- All the case functions check out: (x−1)²(x+2) and (x−1)³(x+2) have a multiple root at 1.

### F5 — partly resolved
- Fixed: Methods B and C are now defined (line 66, and line 67 for C). C's test is now in computable quantities: increase m while |f(x_{n,m+1})| < |f(x_{n,m})|. This matches the legacy Mathews algorithm I read in NewtonImprovedMod.html (gr_112: stop when |f(p_{m+1})| > |f(p_m)|; gr_115: `While |y2| < |y1|`). The numbers check out: x_{1,1} = −1.413619 and x_{1,2} = −4.227237, with |f| = 0.955 and 1.339.
- The claim that C keeps m = 1 at every step is true in general. For x > 0, (1+x²)arctan x > x, so the m = 1 step crosses 0. x_{n,2} lies farther out on the same side, so |arctan| is larger there. My mpmath run of C over 6 steps gives m = 1 every time and the same divergent iterates as Newton.
- Not fixed: the page still has no `## Description` section. The finding's suggested fix and the page conventions (animation-page.agent.md: "ALWAYS create a `## Description` section … before `## Animations`") both require one. The definitions were placed inline in Cases 2 and 5 instead. Method A is defined only in the intro and Case 2, and B and C only in Case 5.

### F6 — resolved
- cc and dd now use `titlefontsize=12`. Full-size frames (cc frames 1 and 13, dd frames 3 and 4) show the whole title, "… (triple root at x=1)", ending inside the 640 px canvas.
- The bb title and the unchanged aa and ee titles were not cut off before and still fit (bb frames 2 and 4 checked).

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:12 | Cases 1–4 have a multiple root at x = 1; Case 5 arctan has a simple root at 0 | factorisations; arctan′(0) = 1 ≠ 0 | correct |
| index.qmd:13 | tangent for Cases 1, 3, 5; slope f′(xₙ)/m for Cases 2, 4 | script geometry (endpoint xₙ − m f/f′) | correct |
| index.qmd:52 | iterates 1.3, 1.008824, 1.000009 | Float64 and mpmath | correct |
| index.qmd:52 | x₃ within 10⁻¹¹ of the root, labelled 1.0 | x₃−1 = 8.25e-12; frame 4 label "1.0" | correct |
| index.qmd:65 | Method A with m = 1 is standard Newton and does not fix the case | identity; Newton diverges from 1.4 (x_c ≈ 1.3917) | correct |
| index.qmd:66 | u = f/f′ = (1+x²)arctan x; B formula ff′/((f′)² − ff″) | algebra: u/u′ = ff′/(f′² − ff″) | correct |
| index.qmd:66 | u increasing and convex for x > 0; iterates decrease monotonically | u′, u″ > 0 analytically and numerically | correct |
| index.qmd:66 | 0.6316, 0.1712, 0.00625, 3.25×10⁻⁷ | mpmath: 0.631573, 0.171166, 0.00624689, 3.25005e-7 | correct |
| index.qmd:67 | C definition and stopping rule | legacy gr_112 and gr_115 | correct (matches source) |
| index.qmd:67 | m = 1 step always crosses 0; x_{1,1} ≈ −1.41, x_{1,2} ≈ −4.23 with larger \|f\| | proof above; −1.413619, −4.227237; \|f\| 0.955 < 1.339 | correct |
| index.qmd:67 | C keeps m = 1 at every step and diverges as Newton | mpmath C run, 6 steps | correct |
| index.qmd:68 | A and C do not repair this failure | follows from the above | correct |
| bb.jl:12–13 comment | f(1+1.3e-10): 2.2e-16 vs 5.1e-20 | Julia: 2.220446e-16 vs 5.1204e-20 | correct |
| bb.jl:14–15 | factored f, fp | expands to x³−3x+2 and 3x²−3 | correct |
| bb.jl:19 comment | x3 within 1.4e-10; 4th step lands on 1 exactly, then 0/0 | x3−1 = 1.32272e-10; replay gives 1.0, then NaN | correct |
| dd.jl:12–13 comment | f(1+6.4e-7): −8.9e-16 vs +7.9e-19 | −8.8818e-16 vs 7.934e-19 | correct |
| dd.jl:14–15 | factored f, fp | expand to the quartic and 4x³−3x²−6x+5 | correct |
| dd.jl:19 comment | x3 within 1e-11; 4th step gives exactly 1, then 0/0 | 8.25e-12; replay gives 1.0, then NaN | correct |
| cc.jl:35, dd.jl:39 | titlefontsize=12 | frames show the full title | correct |
| bb labels | 1.3, 1.013043, 1.000028, 1.0 | Float64 rounding to 6 digits | correct |
| dd labels | 1.3, 1.008824, 1.000009, 1.0 | same | correct |

### New problems

None. This rests on four things. Every changed sentence and number was checked independently (ledger above). The new bb and dd frames were viewed at full size (first, middle and last frames) and show correct iterates, segments ending at the next iterate and legible labels. cc's plot content is unchanged apart from the title font (frame 13 label x₍12₎ = 1.002423, which agrees with the linear 2/3 rate). The Case 2 and Case 4 alt texts ("quadratic convergence … in just a few steps") are now consistent with 3-step animations that reach 1.0.

The missing Description section is not new; it is recorded under F5.

### Reproducibility and conventions

- I ran scratch copies of newtonimpbb.jl, newtonimpcc.jl and newtonimpdd.jl. All 3 GIFs are byte-identical to the working-tree GIFs (`cmp`). Frame counts are bb 4 (was 6), cc 13 (unchanged; frame hashes differ because of the title font) and dd 4 (was 6).
- Every case still has a source link and a GIF embed. Alt text is descriptive, and there are no code blocks (no ``` in index.qmd). The section index (pages/numerical-methods/index.qmd:21) still links the page.
- Description before Animations: still absent; the page goes straight to `## Animations`. This was already the case before the fix and is tracked under F5.
- Files outside the page folder: this fix's diff touches only `pages/numerical-methods/improved-newton-method/`. The working tree has other modified files, such as pages/numerical-methods/index.qmd (link changes for milne-simpsons, predictor-corrector and shooting methods) and other page folders. Those belong to other pages' work and are unrelated to this page.

### Re-check

This round's fix adds a `## Description` (index.qmd:10–19) between the source line and `## Animations`, and moves the B and C definitions out of Case 5. Scripts and GIFs are unchanged from the first check: the three scratch-regenerated GIFs are still byte-identical to the working tree (`cmp`), and the three changed .jl files are identical to my scratch copies. Scratch work: `check/recheck.py` (mpmath, 100 digits).

### F1 — resolved (unchanged; Case 4 text and dd.jl/gif unchanged since the first check)
### F2 — resolved
- Line 76: A with m = 1 is standard Newton and does not fix the case.
- Line 77: B, Newton on u = (1+x²)arctan x, converges, with values 0.6316, 0.1712, 0.00625, 3.25e-7. The numbers, wording and proof are the same as checked in the first round; only the B formula moved to the Description.
### F3 — resolved (unchanged)
### F4 — resolved (unchanged, lines 23–24)
### F5 — resolved
- A `## Description` now sits before `## Animations` and defines Methods A, B and C. C's test uses only computable |f| values.

Each Description sentence was checked by independent computation:

| Location | Text | Check | Verdict |
|---|---|---|---|
| :12 | When Newton converges, it is quadratic at a simple root and linear at multiplicity m ≥ 2 | Mathews Theorem 1 (legacy page). The Case 1 and Case 3 iterates are linear with ratio (m−1)/m. Strictly the rate is "at least quadratic" when f″(p) = 0, a standard simplification | correct |
| :13 | "Mathews compares three improvements" | legacy NewtonImprovedMod.html: Methods A, B and C, compared in Examples 1–3 | correct |
| :15 | A: x_{n+1} = x_n − m f/f′, m known | legacy (8); scripts bb and dd use the same formula | correct |
| :16 | B: Newton on u = f/f′, which has a simple root where f has a multiple one; formula ff′/(f′² − ff″) | u/u′ = ff′/(f′² − ff″) algebraically. For (x−1)³(x+2), u′(1) = 0.333333 = 1/m ≠ 0, so the root of u is simple | correct |
| :17 | C: no m needed; x_{n,m} = x_n − m f/f′ from m = 1; increase m while \|f(x_{n,m+1})\| < \|f(x_{n,m})\|; take the last such point | Matches legacy gr_112 and gr_115 (`While \|y2\| < \|y1\|`, keep p1). My run of this rule picks m = 2 at the double root and m = 3 at the triple root from 1.3 at every step, with errors 1.3e-2, 2.8e-5, 1.3e-10, 2.9e-21 and 8.8e-3, 8.6e-6, 8.2e-12, 7.6e-24 | correct ("last such point" is slightly terse, but it reads correctly as the point where the loop stops) |
| :19 | Started close enough to a multiple root, A and B converge quadratically | A (correct m): e/e² → 1/6 for the double root and 1/9 for the triple. B from 1.3: e/e² → 0.1667 (double) and 0.1111 (triple), errors down to 6.6e-43 and 2.3e-48 | correct |
| :19 | The animations show standard Newton and Method A; Case 5 also discusses B and C | Cases 1, 3, 5 are standard Newton; Cases 2, 4 are A; Case 5 text covers B and C | correct |
| :77–78 (reworded) | B and C sentences without the inline formulas; numbers unchanged | Same numbers as the first-round ledger: 0.631573, 0.171166, 0.00624689, 3.25005e-7; x_{1,1} = −1.413619, x_{1,2} = −4.227237 | correct |

### F6 — resolved (unchanged)

### New problems
None. Every new sentence checks out (table above), the scripts and GIFs are unchanged and reproducible, and the B/C definitions in the Description agree with what Case 5 uses.

### Conventions
- The Description now comes before Animations, closing the gap the first check found.
- Every case has a source link and an embed, alt text is descriptive, and there are no code blocks.
- The fix touches only files in the page folder.

**Final status:** committed
