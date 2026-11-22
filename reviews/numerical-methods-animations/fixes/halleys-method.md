# Fix record: halleys-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/halleys-method/fix/` (below: `$S`).

Evidence scripts:
- `$S/checks/indep.py`: independent check in mpmath (50 digits) and sympy. Run with `/usr/bin/python3 -I $S/checks/indep.py`. Output is in `$S/checks/indep.out`.
- `$S/instr/halleysab_instr.jl`, `$S/instr/halleysba_instr.jl`: the committed scripts' own parameter and iteration blocks, printing per frame the Newton step, Halley step, Taylor-parabola roots, osculating-hyperbola zero and pole (Float64, the scripts' arithmetic). Output is in `$S/instr/*_instr.out`.
- `$S/checks/markers.py`: pixel scale of the plot box and the Newton/Halley marker separation in frame 1; zoomed crops `$S/checks/ba_f1_zoom.png`, `$S/checks/ab_f1_zoom.png`. Output in `$S/checks/markers_*.out`.
- `$S/committed/<gif>/`, `$S/new/<gif>/`: extracted frames of the committed and regenerated GIFs.
- `$S/archive/`: legacy formula images converted to PNG.

## Findings

### F1 — Error — fixed
- **Reproduced.** `indep.py`, Case 1b (x² − 2, x₀ = 2): Halley step 1.42857142857143; Taylor-parabola roots ±1.41421356237 (the parabola of a quadratic is f itself). Case 2 (x³ − 3x + 2, x₀ = −2.2): Halley step −2.0020618556701; Taylor-parabola roots −1.99909849506 (nearest) and −0.655446959488. So the Taylor-parabola root is not the Halley iterate. sympy, for general F = f(xₙ), F1 = f′(xₙ), F2 = f″(xₙ), with b₁ = −F2/(2F1), a₁ = F1 + F·b₁ and H(t) = (F + a₁t)/(1 + b₁t): `H(0)=F: True  H'(0)=F1: True  H''(0)=F2: True`, and the zero of H is `2*F*F1/(F*F2 - 2*F1**2)`, which `equals Halley step -2FF1/(2F1^2-FF2)? [True]`.
- **Change.** index.qmd:12 "fits an osculating (second-order Taylor) parabola and finds the root of that parabola nearest to the current point." → "fits an osculating hyperbola, a rational function $y = \dfrac{a + b(x - x_n)}{1 + c(x - x_n)}$ that matches $f$, $f'$ and $f''$ at $x_n$, and takes its $x$-intercept as $x_{n+1}$. (Taking the root of the second-order Taylor parabola instead gives a different iteration, Halley's irrational method.)"
- **Check.** sympy output above (osculation of all three quantities; zero = Halley step). "Different iteration": `indep.py` Case 2 first step, parabola root −1.99909849506 vs Halley −2.0020618556701. The irrational-method iteration (root of the Taylor parabola nearest xₙ) was run in `indep.py`; its errors on Case 2 are 0.2, 0.000901505, 8.1407e-11, 5.99437e-32, a different sequence from Halley's (0.2, 0.00206186, 2.9138e-9, 8.24629e-27). The name "Halley's irrational method" is terminology (Halley gave both a rational and an irrational formula), not a computed claim.

### F2 — Error — fixed (as corrected by the independent check)
- **Reproduced.** Committed `halleysab` frame 1 (`$S/committed/halleysab/frame_001.png`): the orange dashed "osculatory parabola" lies on the magenta f; the orange Halley diamond sits a few pixels right of where they cross. `halleysab_instr.jl` frame 1: `parabola_roots=[1.4142135623730951, …]`, `halley=1.4285714285714286`. `halleysba_instr.jl` frame 1: `parabola_roots=[-1.999098495057019, …]`, `halley=-2.002061855670103`. Visible gap only in Case 1b frame 1 (0.0143579 in x, ≈ 5.7 px at 395.6 px/unit); Case 2 sub-pixel (0.00296 × 115.1 px/unit ≈ 0.34 px), as the checker said. The construction drawn is the wrong one in both.
- **Change.**
  - halleysab.jl:3 header comment "osculating parabola construction" → "osculating hyperbola construction".
  - halleysab.jl:53–56 and halleysba.jl:53–56: Taylor parabola replaced by the osculating hyperbola `b1 = -fppv/(2*fpv); a1 = fpv + fv*b1; hyperbola(x) = (d = 1 + b1*(x - x_cur); d > 0 ? (fv + a1*(x - x_cur)) / d : NaN)`, drawn in the same style (darkorange, dashed), label "osculatory parabola" → "osculating hyperbola (Halley)". The far branch beyond the pole is NaN-masked; no clamping.
  - halleysab.jl:81 comment "Mark Halley x-intercept (lower root of parabola, nearer to actual root)" → "Mark Halley iterate (x-intercept of the osculating hyperbola)".
  - index.qmd:44 intro, :62 and :70 alt texts now name the osculating hyperbola (see F4 and ledger).
- **Check.**
  - `*_instr.jl` (same formula as the new script code, Float64): `hz-halley=0.0` in every frame of both cases, i.e. the hyperbola zero equals `xs[frame+2]` exactly.
  - Pole xₙ − 1/b₁: Case 1b 6.0, 4.2857, 4.2426, 4.2426 (window 1.0–2.6); Case 2 −3.9455, −3.5046, −3.5000, −3.5, −3.5 (window −3.0–2.5). All outside the window, and on the side the mask removes (Case 1b b₁ < 0, so d > 0 ⇔ x < pole; Case 2 b₁ > 0, so d > 0 ⇔ x > pole), so the mask hides nothing inside the window.
  - New frames viewed at full size: `$S/new/halleysab/frame_001.png` (dashed hyperbola separates from f and crosses the axis at the orange diamond, 1.428571; Newton diamond at 1.5 visible 28 px away), `frame_002.png`, `frame_005.png`; `$S/new/halleysba/frame_001.png` (hyperbola crosses at the orange diamond −2.002062), `frame_003.png`, `frame_006.png`. Legends read "osculating hyperbola (Halley)" and the Newton/Halley values match `*_instr.out`.

### F3 — Error — fixed
- **Reproduced.** `halleysba_instr.jl` frame 1: `newton=-2.022222222222222`, `halley=-2.002061855670103`; both < −2, i.e. on the same side as x₀ = −2.2, so Newton falls short and does not overshoot. `markers.py` on the new frame 1: 115.1 px per x-unit, Newton marker column 167.5, Halley 169.9, separation 2.32 px; in a 50×60 crop around the Halley marker the only steelblue pixels (7) are the dotted tangent line (`$S/checks/ba_f1_zoom.png`): the blue Newton diamond is hidden. Same in the committed frame.
- **Change.** index.qmd:66 "The orange dashed parabola visibly corrects the Newton overshoot." → "Neither first step overshoots: both stay to the left of the root, on the same side as $x_0$, and Halley's lands within 0.0021 of it. The two first-step markers are only about 0.02 apart, so they overlap at this scale; the legend gives their values."
- **Check.** Ledger rows below. No change to the picture: making both markers visible would need a zoom/inset (D5, smallest change), so the text says they overlap.

### F4 — Minor — fixed
- **Reproduced.** halleysaa.jl:52 tangent `ls=:dash`, no parabola/hyperbola drawn; committed `halleysaa/frame_002.png` shows a dashed blue tangent and only f, tangent and markers. halleysab.jl:60 and halleysba.jl:61 tangent `ls=:dot`.
- **Change.** index.qmd:44 rewritten: "Case 1a shows the Newton-Raphson **tangent-line construction** alone (tangent blue dashed) as a baseline. Cases 1b and 2 show the **osculating-hyperbola construction** of Halley's method: at each step the current iterate $x_n$ is marked on the curve, the tangent line (blue dotted) shows where Newton's method would jump next, and the osculating hyperbola (orange dashed) crosses the $x$-axis at the Halley iterate $x_{n+1}$ — yielding **cubic** rather than quadratic convergence at simple roots."
- **Check.** Line styles from the script source (above) and frames: `$S/committed/halleysaa/frame_002.png` (dashed), `$S/new/halleysab/frame_001.png`, `$S/new/halleysba/frame_001.png` (dotted tangent, dashed orange hyperbola crossing at the Halley diamond). Closing clause ("cubic rather than quadratic at simple roots") is the original general statement, kept.

### F5 — Minor — fixed
- **Reproduced.** `grep -n "g(" index.qmd` before the fix: g appears only on line 58. `indep.py`: Halley map for x² − 2 is `x*(x**2 + 6)/(3*x**2 + 2)`, g′(√2) = 0, g″(√2)/2 = 0, g‴(√2)/6 = 1/8; Newton map `x/2 + 1/x`, g′(√2) = 0, g″(√2)/2 = √2/4. The page's C formula (line 34) gives 1/8 for x² − 2, matching g‴/6. So the statement is correct once g is defined as the iteration map.
- **Change.** index.qmd:58 adds ", where $g$ is the iteration map, $x_{n+1} = g(x_n)$" (and removes a stray space in `3! $`). While editing this sentence, "tripling accurate digits each iteration" was made exact: "; from there the number of accurate digits roughly triples each iteration (about 1.8, 6.4 and 20 after steps 1, 2 and 3, in extended precision)". The first step goes from 0.23 to 1.84 digits (×7.9), so "tripling each iteration" from x₀ was not exactly true.
- **Check.** `indep.py`: "Case 1b Halley correct-digit counts -log10|e_k|: ['0.2323', '1.843', '6.438', '20.22', …]"; ratios 6.438/1.843 = 3.49, 20.22/6.438 = 3.14.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:12 | Halley fits an osculating hyperbola y = (a + b(x−xₙ))/(1 + c(x−xₙ)) | `indep.py` sympy: rational form H(t) = (F + a₁t)/(1 + b₁t), i.e. a = F, b = a₁, c = b₁ | yes |
| index.qmd:12 | "that matches f, f′ and f″ at xₙ" | `indep.py` → `H(0)=F: True  H'(0)=F1: True  H''(0)=F2: True` | yes |
| index.qmd:12 | "takes its x-intercept as xₙ₊₁" | `indep.py` → zero of H equals Halley step `[True]`; `*_instr.out` → `hz-halley=0.0` every frame | yes |
| index.qmd:12 | Taylor-parabola root gives a different iteration (Halley's irrational method) | `indep.py` Case 2 step 1: parabola root −1.99909849506 vs Halley −2.0020618556701; irrational-method error sequence 0.2, 0.000901505, 8.14e-11 vs Halley 0.2, 0.00206186, 2.91e-9. Name: terminology | yes (name not computed) |
| index.qmd:44 | Case 1a: tangent construction alone, tangent blue dashed | halleysaa.jl:52 `color=:steelblue … ls=:dash`; no other curve; `committed/halleysaa/frame_002.png` | yes |
| index.qmd:44 | Cases 1b, 2: tangent blue dotted; hyperbola orange dashed | halleysab.jl:60, halleysba.jl:61 `ls=:dot`; new hyperbola `color=:darkorange … ls=:dash`; new frames 1 | yes |
| index.qmd:44 | hyperbola crosses the x-axis at the Halley iterate xₙ₊₁ | `*_instr.out` `hz-halley=0.0`; new frame 1 of both GIFs: orange dashed curve passes through the orange diamond | yes |
| index.qmd:44 | "cubic rather than quadratic convergence at simple roots" | unchanged general statement (original text); consistent with C = 1/8 and g‴/6 = 1/8 for Case 1b | yes (general) |
| index.qmd:58 | "from there the number of accurate digits roughly triples each iteration" | `indep.py` digits 1.843 → 6.438 → 20.22 (×3.49, ×3.14) | yes |
| index.qmd:58 | "about 1.8, 6.4 and 20 after steps 1, 2 and 3, in extended precision" | `indep.py` (mpmath 50 dps) → 1.843, 6.438, 20.22 | yes |
| index.qmd:58 | "where g is the iteration map, x_{n+1} = g(x_n)" | `indep.py` → Halley g‴(√2)/6 = 1/8, g′ = g″ = 0; Newton g″(√2)/2 = √2/4 | yes |
| index.qmd:62 alt | osculating hyperbola, whose x-intercept is the Halley iterate, alongside the Newton tangent | as row "takes its x-intercept"; `new/halleysab/frame_001.png` | yes |
| index.qmd:66 | "Neither first step overshoots: both stay to the left of the root, on the same side as x₀" | `halleysba_instr.out` frame 1: newton −2.022222222222222 < −2, halley −2.002061855670103 < −2, x₀ = −2.2 < −2 | yes |
| index.qmd:66 | "Halley's lands within 0.0021 of it" | `indep.py` k=1 err = −0.00206186 → |e₁| = 0.00206 < 0.0021 | yes |
| index.qmd:66 | "markers only about 0.02 apart" | −2.002061855670103 − (−2.022222222222222) = 0.0201604 | yes |
| index.qmd:66 | "they overlap at this scale; the legend gives their values" | `markers.py` → separation 2.32 px; no steelblue marker pixels visible (`checks/ba_f1_zoom.png`); legend shows −2.02222 and −2.002062 | yes |
| index.qmd:70 alt | osculating hyperbola, whose x-intercept is the Halley iterate, and the tangent line; iterates "marked on the x-axis" | `*_instr.out` `hz-halley=0.0`; `new/halleysba/frame_001.png` | yes |
| halleysab.jl / halleysba.jl legend | "osculating hyperbola (Halley)" | curve drawn is H with b₁, a₁ as verified above | yes |
| halleysab.jl / halleysba.jl comments | "x-intercept is exactly the Halley iterate (the Taylor parabola's root is not)"; pole at xₙ − 1/b₁ | `indep.py` zero/pole: pole t = 2F1/F2 = −1/b₁; parabola roots differ (F1 numbers) | yes |

## Scripts and GIFs
- **Scripts changed:** `halleysab.jl`, `halleysba.jl` (hyperbola replaces parabola; legend; comments). `halleysaa.jl` unchanged.
- **GIFs regenerated:** `cd pages/numerical-methods/halleys-method && julia halleysab.jl && julia halleysba.jl`. halleysaa.gif was not regenerated and is unchanged.
- **Frames viewed (full size):** halleysab frames 1, 2, 5 (of 5); halleysba frames 1, 3, 6 (of 6). Checked: the dashed orange hyperbola passes through the orange Halley diamond; no pole or vertical artifact inside the window; legend values match `*_instr.out` (1b: 1.5 / 1.428571, 1.41429 / 1.414214; 2: −2.02222 / −2.002062); title and annotation unchanged and legible.
- **git status of the page folder after regeneration:**
  ```
   M pages/numerical-methods/halleys-method/halleysab.gif
   M pages/numerical-methods/halleys-method/halleysab.jl
   M pages/numerical-methods/halleys-method/halleysba.gif
   M pages/numerical-methods/halleys-method/halleysba.jl
   M pages/numerical-methods/halleys-method/index.qmd
  ```

## Legacy archive
Consulted: `n2003/Halley'sMethodMod.html` and `halleysmethod/Halley'sMethodMod/Links/*_lnk_2..5.html` (read as text), with the formula images for the examples converted to PNG (`$S/archive/`). It shows Example 1: f(x) = x² − 2, p₀ = 2, (a) Newton, (b) Halley; Example 2: f(x) = x³ − 3x + 2, root x = −2, p₀ = −2.2, (a) Newton, (b) Halley. These match the page's Cases 1a, 1b and 2. The archive has no graph-sized images for this topic (largest image HEIGHT = 36), so Mathews showed tables of iterates and errors in 100-digit arithmetic, not an animation; it gives no geometric construction for Halley's method, so nothing there conflicts with the hyperbola fix. (The archive solves Example 2 by Newton as well; the page has no Newton-only Case 2 animation, which is a pre-existing omission, not a finding.)

## Notes
- halleysba.jl still clamps the tangent line to `ylims` (line 61), which draws the clamped part as a dotted line along the top and bottom edges of the plot box. Pre-existing, cosmetic, not a finding; left unchanged. The new hyperbola is not clamped (GR clips it at the window).
- In Case 2 frames 2–3 the legends read "≈ -2.0" for both steps (true values −2.0000028283 and −2.0000000029 in frame 2): rounding with "≈", not false; pre-existing, unchanged.
- index.qmd was not rendered with Quarto; `\dfrac` is standard amsmath, supported by MathJax.

## Resolution check (independent checker, not shown this record)

Scratch evidence: `check/indep.py` (independent osculating-rational fit by series matching, 80-digit mpmath iterates), `check/run/` (regenerated GIFs), `check/frames_halleysab/`, `check/frames_halleysba/` (new frames), `check/frames_old_ab/`, `check/frames_old_ba/` (pre-fix frames from the LFS object store), `check/ba1_top.png`, `check/ba1_root.png` (4x zooms).

### Original findings

### F1 — resolved
- The parabola sentence is gone. index.qmd:12 now says Halley fits an osculating hyperbola $y=(a+b(x-x_n))/(1+c(x-x_n))$ that matches f, f', f'' at $x_n$, takes its x-intercept as $x_{n+1}$, and notes that the Taylor-parabola root is a different iteration (Halley's irrational method).
- Independent check (`indep.py`): I solved for a, b, c by matching the series of $(a+bt)/(1+ct)$ to $f+f't+\tfrac12f''t^2$, without using the Halley formula. Its zero $-a/b$ equals the rational Halley iterate to 15 digits at every iterate of both cases: 1.42857142857143 and 1.41421392677674 for $x^2-2$; −2.00206185567010 and −2.00000000291380 for the cubic. For $x^2-2$ at $x_0=2$, the Taylor parabola is f itself and its root is √2, not 1.428571, so the "different iteration" remark is true.

### F2 — resolved
- Both scripts (halleysab.jl:53–60, halleysba.jl:53–60) now draw $H(x)=(f+a_1(x-x_n))/(1+b_1(x-x_n))$ with $b_1=-f''/(2f')$ and $a_1=f'+fb_1$. These coefficients match the solved b/a and c (pole $x_n-1/b_1$ = 6.000, 4.286 and 4.243 for Case 1b; −3.945, −3.505 and −3.500 for Case 2). Every pole is outside the plotted windows (1.0–2.6 and −3 to 2.5). A d>0 mask keeps only the branch through $x_n$. The legend reads "osculating hyperbola (Halley)". The comment at halleysab.jl:85 is corrected. index.qmd:44 and the alt texts at :62 and :70 name the hyperbola.
- Frames: in halleysab frame 1 the orange dashed curve is now distinct from magenta (it lies below it left of $x_0$) and crosses the axis exactly at the orange diamond (1.428571), left of the Newton diamond (1.5). In frames 3 and 5 it hugs f near √2 and bends above it to the right. In halleysba frame 1 the hyperbola rises from $x_0$ through the orange diamond at −2.002 and leaves through the top edge. It no longer dives through x≈−0.65 as the old parabola did.

### F3 — resolved
- The "visibly corrects the Newton overshoot" sentence is gone. It is replaced by: neither first step overshoots, both stay to the left of the root, Halley lands within 0.0021, and the markers are about 0.02 apart and overlap, with the legend giving their values.
- Checks: Newton −2.0222222 and Halley −2.0020619 are both < −2 (left, same side as −2.2). |−2.0020619+2| = 0.0020619 < 0.0021. The gap is 0.0201597 ≈ 0.02. Zoom `ba1_root.png`: the orange diamond covers the blue Newton diamond, so "overlap" is accurate. The legend shows −2.02222 and −2.002062.

### F4 — resolved
- index.qmd:44 now says Case 1a shows the tangent construction alone (blue dashed) and that Cases 1b and 2 use a blue dotted tangent with the orange dashed hyperbola. Confirmed against the code: halleysaa.jl:52 uses `ls=:dash` and draws no curvature curve; halleysab.jl:64 and halleysba.jl:65 use `ls=:dot`. halleysaa.gif is unchanged (its sha256 equals the HEAD LFS oid).

### F5 — resolved
- index.qmd:58 now adds "where g is the iteration map, $x_{n+1}=g(x_n)$". Sympy: Halley's $g=x(x^2+6)/(3x^2+2)$ has $g'(\sqrt2)=g''(\sqrt2)=0$ and $g'''/6=1/8$, which equals C from line 34. Newton has $g'=0$ and $g''/2=\sqrt2/4$. The statement is correct.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:12 | osculating hyperbola $(a+b(x-x_n))/(1+c(x-x_n))$ matching f, f', f'' | series-matching solve in indep.py | correct |
| index.qmd:12 | takes its x-intercept as $x_{n+1}$ | zero = Halley iterate, all iterates, both cases | correct |
| index.qmd:12 | Taylor-parabola root gives a different iteration, Halley's irrational method | $x^2-2$: parabola root √2 ≠ 1.428571; standard name | correct |
| index.qmd:44 | Case 1a tangent blue dashed, no hyperbola | halleysaa.jl:52, frames | correct |
| index.qmd:44 | Cases 1b/2: $x_n$ marked on curve, tangent blue dotted, hyperbola orange dashed crosses axis at $x_{n+1}$ | scripts and frames (red dot on curve, ls=:dot, crossing at orange diamond) | correct |
| index.qmd:58 | $x_1\approx1.42857$ vs Newton 1.5 | indep.py | correct (unchanged numbers) |
| index.qmd:58 | about 1.8, 6.4 and 20 accurate digits after steps 1, 2, 3 (extended precision) | 80-digit: −log10 of the error = 1.843, 6.438, 20.22 | correct |
| index.qmd:58 | digits roughly triple; g''' vs g'' governs; g = iteration map | ratios 3.5 and 3.1; sympy g-derivatives | correct |
| index.qmd:66 | neither first step overshoots; both left of root | −2.02222 and −2.00206 < −2 | correct |
| index.qmd:66 | Halley within 0.0021 | 0.0020619 | correct |
| index.qmd:66 | markers about 0.02 apart, overlap at this scale; legend gives values | 0.02016; zoom shows overlap; legend −2.02222 and −2.002062 | correct |
| index.qmd:62 alt | osculating hyperbola whose x-intercept is the Halley iterate, Newton tangent, both iterates marked | frames 1–5 | correct |
| index.qmd:70 alt | same for the cubic, convergence to x = −2 | frames 1–6 | correct |
| halleysab.jl:3 | header "osculating hyperbola construction" | code | correct |
| halleysa{b,ba}.jl:53–58 | comments: H matches f, f', f''; intercept = Halley iterate; parabola root is not; NaN beyond pole at $x_n-1/b_1$ | algebra plus indep.py | correct |
| both scripts | legend "osculating hyperbola (Halley)" | frames, legible | correct |
| halleysab.jl:85 | comment "x-intercept of the osculating hyperbola" | as above | correct |

### New problems
None. This rests on:
- independent rational-fit verification of every drawn iterate;
- full-size inspection of frames 1, 3 and 5 (ab) and 1, 3 and 6 (ba), plus zooms;
- comparison with the pre-fix frames.

The differing pixels between old and new frames come only from the orange curve and its anti-aliasing and from the legend label. Title, axes, f, tangent, markers and annotations are unchanged.

The flat dotted line along the top edge of halleysba (x ≳ −1.35) is the clamped blue tangent. It was present before the fix and is not the hyperbola (`ba1_top.png` shows the orange dashes leaving through the top edge). It is a cosmetic pre-existing artefact, outside the scope of the findings.

### Reproducibility and conventions
- I copied halleysab.jl and halleysba.jl to `check/run/` and ran them. Both GIFs are byte-identical (cmp) to the working-tree GIFs, which are 5 and 6 frames.
- The page keeps its conventions: Description before Animations, a `[Julia source]` link and a GIF embed for each of the 3 cases, descriptive alt text, and no code fences (grep found none).
- The diff touches only files in pages/numerical-methods/halleys-method/. One untracked file outside the page folder exists, reviews/numerical-methods-animations/fixes/halleys-method.md. It is not part of the site page and appears to be a fix-workflow record.

**Final status:** committed
