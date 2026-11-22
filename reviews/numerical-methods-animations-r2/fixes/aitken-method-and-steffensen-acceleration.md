# Fix record: aitken-method-and-steffensen-acceleration

Scratch folder (all evidence scripts and outputs): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/aitken-method-and-steffensen-acceleration/fix/` (below: `$S`).

## Findings

### F1 — Minor — fixed
- Reproduced: `$S/f1_theorem.py` (mpmath, 60 digits). A sequence with |e_{k+1}/e_k| = 0.5 exactly and signs `+,+,-` repeating (so it converges linearly with rate 1/2) gives signed ratios cycling −0.5, 0.5, −0.5 and Aitken ratios ê_k/e_k for k = 50..55 of `-0.28571, 2.0, 0.0, -0.28571, 2.0, 0.0`. The ratio does not tend to 0, so "converges linearly" alone does not give the theorem's conclusion. (The cycle starts at a different phase than the reviewer's listing, which depends only on how the sign pattern is aligned with k; the values are the same three.)
- Change: `index.qmd` line 24, "Given *any* linearly convergent sequence … (not just Newton iterates)" → "Given a sequence $\{x_k\}$ converging to a limit $p$ (not just Newton iterates) whose signed error ratios $(x_{k+1}-p)/(x_k-p)$ approach a constant $A$ with $|A|<1$, as in the theorem below, …". Theorem (line 30): "If $\{x_k\}\to p$ linearly with $x_k\neq p$ for all $k$" → "If $\{x_k\}\to p$ with $x_k\neq p$ for all $k$, and there is a real number $A$ with $|A|<1$ such that $\lim_{k\to\infty}(x_{k+1}-p)/(x_k-p)=A$, then …". This is the hypothesis in Mathews' statement (archive images `gr_15`–`gr_19`: $p_n\neq p$ for $n\ge0$, $|A|<1$, $\lim (p-p_{n+1})/(p-p_n)=A$).
- Check: `$S/f1_proof_check.py` (sympy). With ρ_k = e_{k+1}/e_k, ê_k/e_k = ρ_k(ρ_{k+1}−ρ_k)/(ρ_kρ_{k+1}−2ρ_k+1), which is 0 at ρ_k = ρ_{k+1} = A; the denominator tends to (1−A)² ≠ 0 for |A|<1, so the limit is 0. Numerically, e_k = A^k(1+1/(k+1)) gives ê_k/e_k at k = 77 of 4.4e-7 (A = −0.5), 4.0e-6 (A = 0.5) and 3.2e-4 (A = 0.9). The page's three Newton sequences satisfy the new hypothesis: signed ratios → 0.5 (k = 39: 0.5, 0.5, 0.5), all errors of one sign, and Aitken ratios at k = 37 of −7.9e-13, 2.6e-13, 3.9e-13 (`$S/f1_theorem.out`).

### F2 — Minor — fixed
- Reproduced: committed frames extracted to `$S/committed/`. `committed/aitkenab/frame_023.png` legend reads "Newton x_22 = 1.0" (computed x_22 = 1.0000003115) and no blue marker is visible; `committed/aitkenef/frame_006.png` shows no Newton marker at x_5 = 1.729099 (hidden under the diamonds). Pixel diff of the top plot area with the legend masked (`$S/pixdiff.py`) falls to tens of pixels per frame after the first few frames in all three GIFs, i.e. the top panel barely changes. Instrumented copies (`$S/instr/<script>_num.jl`, `.out`) give Newton step lengths in pixels at the frame's scale (plot box measured from the new frames: 599 px for 2.9 units, 596 px for 2.8, 599 px for 2.0, i.e. 206.6, 212.9, 299.5 px per unit): the last step of at least one pixel is step 8 (x_7→x_8, 1.049 px; next 0.526 px) in Case 1, step 5 (x_4→x_5, 1.337 px; next 0.664) in Case 2 and step 4 (x_3→x_4, 1.832 px; next 0.896) in Case 3, and every later step is shorter.
- Change (scripts, all three): Newton marker is drawn a second time, unlabeled, after the Steffensen diamonds so it is on top (legend order unchanged); Newton legend label `round(x_cur; digits=6)` → `@sprintf("%.10f", x_cur)`; Steffensen annotation `round(xs_cur; digits=5)` → `@sprintf("%.10f", xs_cur)` (same cause: "S_3=1.0" in Case 1 for 0.9999999934); `using Plots` → `using Plots, Printf`. In `aitkencd.jl` the annotation moved from y = 0.08 to y = −0.15 (below the axis), because the longer label sat on the curve and tangent line. Text (`index.qmd`): animation intro rewritten to say what the top panel shows and that Newton's tangent steps become shorter than one pixel after its first 8, 5 and 4 steps in Cases 1, 2 and 3, so the linear tail is seen in the bottom panel; Case 3 Behavior "visible in both the tangent-line panel and the gently sloping error curve" → "shows in the gently sloping error curve (in the top panel its tangent steps are shorter than a pixel after the first four)".
- Check: new frames `$S/new1/<gif>/`. Frame 23 of ab: "Newton x_22 = 1.0000003115", blue circle visible on top at x ≈ 1; ef frame 6: "Newton x_5 = 1.7290989886", circle visible next to the diamonds; cd frame 23: "Newton x_22 = 1.4142135151", "S_4=1.4142135624" below the axis and clear of the curve. All labels match `$S/instr/*_num.out`.

### F3 — Minor — fixed
- Reproduced: `committed/aitkencd/frame_023.png` title ends "(p =", `committed/aitkenef/frame_006.png` title ends "(p = (", and the bottom-panel y-label of ab ("log₁₀ |xₖ − 1|") is cut at the left edge.
- Change: top-panel titles in all three scripts drop the prefix "Newton (blue) vs Steffensen (red): " (the legend and the bottom title already name both methods), e.g. `title="f(x) = (x²−2)sin(x²−2)  (p = √2)"`; final `plot(...)` gets `left_margin=3Plots.mm`. ab's title was not clipped but was shortened too so the three GIFs match.
- Check: new frames 1 and 23 of each GIF: titles "f(x) = x³−3x+2  (p = 1)", "f(x) = (x²−2)sin(x²−2)  (p = √2)", "f(x) = x⁶−7x⁴+15x²−9  (p = √3)" are complete and centred; the bottom y-labels "log₁₀ |xₖ − 1|", "… − √2|", "… − √3|" are fully inside the frame.

### F4 — Minor — fixed (R2-A: one sentence, example not added)
- Reproduced: archive `AitkenSteffensenMod.html` lists Examples 1–6; their statement images give the functions Ex 1/2 `gr_34`/`gr_59` = x³−3x+2, Ex 3/4 `gr_114`/`gr_139` = Sin[x²−2](x²−2), Ex 5/6 `gr_194`/`gr_218` = x⁶−7x⁴+15x²−9. The solution pages `lnk_2`, `lnk_4`, `lnk_6` (Examples 1, 3, 5) say "Let us apply Aitken's acceleration process to a sequence {p_n} of iterations generated by Newton's method", and Example 3's surviving code image `gr_130` applies the q_n formula to the Newton list P (`gr_124`: NestList of the Newton map from 1.0, m = 15). The page animates only Newton vs Steffensen (scripts aitkenab/cd/ef, three cases); no Aitken-on-Newton series is drawn. Script headers claimed "Examples 1 & 2 merged" etc.
- Decision: R2-A says to add one sentence when a whole Mathews example is left out and not to add the example; Examples 1, 3, 5 are whole examples, so the reviewer's alternative fix (headers + page sentence) was taken.
- Change: script headers → "Aitken/Steffensen animation: Mathews Example 2 (Newton vs Steffensen); Example 1 (Aitken Δ² applied to the Newton sequence) is not animated" (likewise 4/3 and 6/5). `index.qmd`, after the last embed (the page has no legacy note), two source lines: the first names what the page reproduces and the Case 1 starting-value departure; the second is the R2-A sentence: "The module's Examples 1, 3 and 5, which apply Aitken's $\Delta^2$ process to the already-computed Newton sequence for the same three functions, are not animated here."
- Check: ledger rows L7–L8.

## Ledger of changed text
| # | Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|---|
| L1 | index.qmd l.24 | sequence whose signed error ratios $(x_{k+1}-p)/(x_k-p)$ approach $A$, $\lvert A\rvert<1$, "as in the theorem below" | same hypothesis as L2; `f1_theorem.py` shows linear convergence alone is not enough | yes |
| L2 | index.qmd l.30–36 | Theorem hypothesis: $x_k\to p$, $x_k\ne p$, $\lim (x_{k+1}-p)/(x_k-p)=A$, $\lvert A\rvert<1$ ⇒ $(\hat x_k-p)/(x_k-p)\to0$ | `f1_proof_check.py`: ê/e = ρ_k(ρ_{k+1}−ρ_k)/(ρ_kρ_{k+1}−2ρ_k+1) → 0/(1−A)² = 0; numeric A = −0.5, 0.5, 0.9 → 4.4e-7, 4.0e-6, 3.2e-4 at k = 77; matches archive `gr_15`–`gr_23` | yes |
| L3 | index.qmd Animations intro | top panel draws Newton tangent steps, one per frame, current iterate $x_k$ printed in legend, Steffensen iterates marked on the x-axis | scripts: `scatter!` label "Newton x_$(frame) = …", diamonds at `(xS, 0)`; frames 1, 3, 10, 23 of each GIF | yes |
| L4 | index.qmd Animations intro | "shorter than one pixel of the frame after its first 8, 5 and 4 steps in Cases 1, 2 and 3" | `$S/instr/*_num.out` step_to_next_px: Case 1 step 8 = 1.049, step 9 = 0.526; Case 2 step 5 = 1.337, step 6 = 0.664; Case 3 step 4 = 1.832, step 5 = 0.896; later steps all smaller (monotone in the tables); px/unit from plot-box columns 69–668 / 72–668 / 69–668 in `new1/*/frame_001.png` | yes |
| L5 | index.qmd Animations intro | "its long linear tail is seen in the bottom panel" | bottom panel plots all 23 Newton errors; signed ratio → 0.5 (`f1_theorem.out`); frame 23 of each GIF shows a straight Newton line to k = 22 | yes |
| L6 | index.qmd Case 3 Behavior | "(in the top panel its tangent steps are shorter than a pixel after the first four)" | as L4, Case 3: step 4 = 1.832 px, step 5 = 0.896 px, decreasing after | yes |
| L7 | index.qmd end, line 1 | Cases 1–3 use functions and Newton-vs-Steffensen comparisons of Examples 2, 4, 6; Mathews' starting values for Cases 2 and 3; Case 1 starts at $x_0=2$ because Example 2's stated $p_0=1$ is the root, $f'(1)=0$, Newton step undefined | archive: `gr_59` x³−3x+2, `gr_60` p₀ = 1; `gr_139` Sin[x²−2](x²−2), `gr_140` p₀ = 1 (= Case 2 x0 = 1.0); `gr_218` x⁶−7x⁴+15x²−9, `gr_219` p₀ = 1.5 (= Case 3 x0 = 1.5); example text "Use Newton's method and Steffensen's acceleration method … Compare the number of iterations". `f1_proof_check.py`: f(1) = 0, f'(1) = 0; Julia `1.0 - f(1.0)/df(1.0)` → NaN | yes |
| L8 | index.qmd end, line 2 | Examples 1, 3 and 5 apply Aitken's Δ² to the already-computed Newton sequence for the same three functions; not animated here | archive `gr_34`, `gr_114`, `gr_194` = the three functions; `lnk_2/4/6` text quoted under F4; `gr_124`/`gr_130` (Ex 3) code; page has three cases, scripts ab/cd/ef, none draws q_n | yes |
| L9 | aitkenab/cd/ef.jl header l.2–3 | "Mathews Example 2/4/6 (Newton vs Steffensen); Example 1/3/5 (Aitken Δ² applied to the Newton sequence) is not animated" | as L7, L8 | yes |
| L10 | GIF titles | "f(x) = x³−3x+2  (p = 1)", "f(x) = (x²−2)sin(x²−2)  (p = √2)", "f(x) = x⁶−7x⁴+15x²−9  (p = √3)" | functions match script `f`; roots 1, √2, √3 confirmed double by the r2 review (f'' = 6, 16, 48) and by signed Newton ratio → 0.5 (`f1_theorem.out`); titles fully visible in new frames | yes |
| L11 | GIF Newton labels | e.g. "Newton x_22 = 1.0000003115", "1.4142135151", "1.7320507835"; "x_5 = 1.7290989886" | `$S/instr/*_num.out` label column; frames ab 023, cd 023, ef 006, ef 023 | yes |
| L12 | GIF Steffensen labels | "S_3=0.9999999934", "S_2=0.9997195119" (ab); "S_2=1.4139058150", "S_4=1.4142135624" (cd); "S_2=1.7318321772", "S_5=1.7320508290", "S_6=1.7320508222" (ef) | `$S/instr/*_num.out` S lines; frames ab 003/023, cd 003/023, ef 003/006/023 | yes |

Numbers in the page that were not changed (Case 1–3 error values, stop reasons, 28/25 Newton steps) are unaffected: the iteration code is unchanged and `$S/instr/*_num.out` reproduces the r2 review's values (e.g. S errors 1, 5.7471e-2, 2.8049e-4, 6.5560e-9; Case 2 S_4 error 6.6613e-16 and stop "|f'(S_4)| < 1e-14"; Case 3 S errors 2.7592e-8, 5.4422e-8, 2.1477e-8, 1.4585e-8; Newton e22 = 3.1148e-7, 4.7272e-8, 2.4023e-8).

## Scripts and GIFs
- Scripts changed: `aitkenab.jl`, `aitkencd.jl`, `aitkenef.jl` (display only: header, `Printf`, title, label formatting, Newton marker redrawn on top, `left_margin=3Plots.mm`; cd also annotation y 0.08 → −0.15). Iteration code untouched.
- GIFs regenerated in place with `julia <script>.jl`: `aitkenab.gif` (md5 f8d76824…), `aitkencd.gif` (81e5b103…), `aitkenef.gif` (8c7d5b1c…); each 23 frames, 680×880.
- Frames viewed at full size: ab 001, 003, 010, 023; cd 003, 006 (before annotation move), 023, contact sheet; ef 003, 006, 023. Checked: titles complete, y-labels inside the frame, Newton circle drawn over the diamonds, legend and annotation values equal the instrumented iterates, bottom panel unchanged in content.
- `git status --short -- pages/numerical-methods/aitken-method-and-steffensen-acceleration` after regeneration: `M` aitkenab.gif, aitkenab.jl, aitkencd.gif, aitkencd.jl, aitkenef.gif, aitkenef.jl, index.qmd. No other files touched.

## Legacy archive
Consulted: `n2003/AitkenSteffensenMod.html`, `aitkensteffensen/AitkenSteffensenMod/Links/*_lnk_2..7.html`, and the surviving images (theorem `gr_1`–`gr_29`, statement images, Example 3 solution `gr_118`–`gr_137`). Most solution images for Examples 1, 2, 4, 5, 6 are missing. No Aitken/Steffensen animation exists under `a2001/Animations/` (only Bisection, Fixed Point, Newton, Regula Falsi, Secant under RootFinding), so there is no legacy animation to match.
- Theorem: Mathews includes the |A| < 1 signed-ratio hypothesis; the page now does too (F1).
- Examples: three pairs on the same three functions; odd = Aitken on Newton's sequence, even = Steffensen. The page animates the even ones (F4 sentence).
- Starting values: Example 4 p₀ = 1 and Example 6 p₀ = 1.5 match Cases 2 and 3. Example 2's stated p₀ = 1 is the double root, where the Newton step is 0/0, so the page keeps x₀ = 2 and says why in one sentence (R2-A: following Mathews would make the page wrong). Example 3's solution uses p₀ = 1.0 and 15 Newton steps; its printed p_n − √2 values (e.g. −0.10972403776, −0.051688844017, −0.02526335241) agree with the script's Newton errors 1.0972e-1, 5.1689e-2, 2.5263e-2.
- Example 6's text says "the multiple root near x = 2"; the root is √3 ≈ 1.732 (factored form (x²−1)(x²−3)²), as Example 5's `gr_193` gives. The page uses √3; nothing quoted from the "near 2" wording.

## Notes
- F2: the smaller of the reviewer's two options was taken (text softened, plus the cheap label and draw-order fixes). No zoom inset or moving x-window was added.
- The three titles were shortened rather than given a smaller font, so all three GIFs use the same style; ab was not clipped but was changed for consistency, since its GIF was regenerated anyway for F2.
- Placement of the F4 sentences follows the Monte Carlo π pattern ("Where a page has no legacy note, the same place is right after the last embed").
- Not touched: the page lacks a separate legacy-source paragraph and has no "(Planned)" stubs; no other convention gaps were acted on.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the theorem (index.qmd lines 30–40) now reads "If {x_k} → p with x_k ≠ p for all k, and there is a real number A with |A| < 1 such that lim (x_{k+1}−p)/(x_k−p) = A, then lim (x̂_k−p)/(x_k−p) = 0". This is Mathews' hypothesis. Checked against the archive's `AitkenSteffensenMod.html`, which says "If there exists a real number A with |A|<1 such that …". It is the standard (Henrici) form of the theorem and is true for any A with |A|<1, including A ≤ 0.
- My own check in 60-digit mpmath (`check/theorem.py`): sequences with e_k = A^k(1+1/(k+1)).
  - For A = 0.5, −0.6 and 0.9, the ratio x̂_k/e_k at k = 20, 40, 70 is 1.7e-4 → 5.2e-6, 2.5e-5 → 7.4e-7, and 1.4e-2 → 4.2e-4. All go to 0.
  - The reviewer's counterexample (signs +,+,−, |ratio| = 1/2) has signed ratios −0.5, 0.5, −0.5 with no limit, so the new hypothesis excludes it. Its Aitken ratio cycles through −0.2857, 2.0, 0.0, as the finding said.
- Line 24 was rewritten to the same hypothesis ("whose signed error ratios … approach a constant A with |A| < 1"). It is consistent with the theorem.
- The page's own Newton sequences satisfy the hypothesis: the signed ratio at k = 22 is 0.5 in all three cases (mpmath).

### F2 — resolved
- Evidence: the fix takes both routes the finding offered.
  - **Softened text.** The Animations intro (line 64) now says the top panel shows only the start of Newton's run and that the long linear tail is seen in the bottom panel. Case 3 (line 86) now attributes the crawl to the error curve, "in the top panel its tangent steps are shorter than a pixel after the first four".
  - **Script.** The Newton marker is redrawn after the Steffensen diamonds. The legend label uses `%.10f`.
- **The "8, 5 and 4 steps" numbers.** I measured the top-panel plot box in the new frames: x pixels 69–668 (Cases 1 and 3) and 72–668 (Case 2). That gives 206.6, 212.9 and 299.5 px per x-unit. The horizontal length in pixels of each Newton step |x_{k+1}−x_k| is (`check/steps.py`):
  - Case 1: 91.8, 53.2, 29.4, 15.7, 8.1, 4.1, 2.1, 1.05 | 0.53, … → 8 steps of at least 1 px.
  - Case 2: 64.8, 12.4, 5.6, 2.7, 1.34 | 0.66, … → 5 steps.
  - Case 3: 53.5, 8.6, 3.8, 1.83 | 0.90, … → 4 steps.
  - The vertical segments are smaller still from those steps on. The text matches.
- **Frames viewed.**
  - aitkenef frame_006: the blue Newton circle is visible on top of the diamonds, and the legend reads "Newton x_5 = 1.7290989886". Before the fix the circle was hidden.
  - aitkenab frame_023: the legend reads "Newton x_22 = 1.0000003115", where it used to read "1.0". The circle is visible on top of S_2 and S_3.
- The top panel is still static in its geometry after the first few frames, but the page now says exactly that, so no false claim remains.

### F3 — resolved
- Evidence: the titles are now shortened to "f(x) = x³−3x+2  (p = 1)", "f(x) = (x²−2)sin(x²−2)  (p = √2)" and "f(x) = x⁶−7x⁴+15x²−9  (p = √3)". In the new frames (frame_001, frame_023 of each GIF) all three are fully visible and centred, and p is readable.
- `left_margin=3Plots.mm` was added. The bottom-panel y-labels "log₁₀ |xₖ − 1|", "log₁₀ |xₖ − √2|" and "log₁₀ |xₖ − √3|" are now fully inside the frame.
- Colour identification moved to the legend, which already names Newton and Steffensen, so the title no longer needs it.

### F4 — resolved (via the finding's alternative fix)
- Evidence: the script headers now say "Mathews Example 2/4/6 (Newton vs Steffensen); Example 1/3/5 (Aitken Δ² applied to the Newton sequence) is not animated". The page gained a two-sentence closing paragraph (lines 92–93) that says the same. This is the alternative the finding offered, and it is also what owner decision R2-A asks for ("Add one sentence when a whole Mathews example … is left out").
- Archive check:
  - Examples 1/2, 3/4 and 5/6 use f = x³−3x+2, (x²−2)sin(x²−2) and x⁶−7x⁴+15x²−9 respectively (images gr_34/59, gr_114/139, gr_194/218).
  - Examples 1, 3 and 5 apply Aitken to the Newton sequence (lnk_2, lnk_4 and lnk_6 text).
  - Example 2's stated start is p₀ = 1 (gr_60), and f'(1) = 3−3 = 0. Example 4's is p₀ = 1 (gr_140), the same as Case 2's x₀ = 1.0. Example 6's is p₀ = 1.5 (gr_219), the same as Case 3's x₀ = 1.5.
  - So every claim in the new paragraph is accurate.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.24 | "sequence … whose signed error ratios (x_{k+1}−p)/(x_k−p) approach a constant A with \|A\|<1 … converges faster" | Matches the theorem's hypothesis. mpmath check for A = 0.5, −0.6, 0.9 | correct |
| index.qmd l.30–34 | Theorem hypothesis: x_k ≠ p, lim signed ratio = A, \|A\|<1 | Archive wording; Henrici theorem; mpmath check above; counterexample now excluded | correct |
| index.qmd l.64 | "top panel draws … tangent-line steps (one step per frame, with the current iterate x_k printed in the legend) and marks the Steffensen iterates on the x-axis" | Seen in frames 001, 003, 006, 012 and 023 of all three GIFs | correct |
| index.qmd l.64 | "shorter than one pixel … after its first 8, 5 and 4 steps in Cases 1, 2 and 3" | Pixel step lengths above: 8, 5 and 4 steps of at least 1 px | correct |
| index.qmd l.64 | "its long linear tail is seen in the bottom panel" | The bottom panel shows Newton's straight-line log-error to k = 22 | correct |
| index.qmd l.86 | "Newton's linear crawl shows in the gently sloping error curve (in the top panel its tangent steps are shorter than a pixel after the first four)" | Case 3 steps in px: 53.5, 8.6, 3.8, 1.83, then 0.90 | correct |
| index.qmd l.92 | Cases 1–3 = Examples 2, 4, 6. Starting values for Cases 2 and 3 are Mathews'. Ex. 2's p₀ = 1 is the root and f'(1) = 0 | Archive gr_60/140/219; f'(1) = 0 | correct |
| index.qmd l.93 | Examples 1, 3 and 5 apply Aitken Δ² to the Newton sequence for the same three functions and are not animated | Archive lnk_2/4/6 text and gr_34/114/194 | correct |
| aitken{ab,cd,ef}.jl l.2–3 | Header: Example 2/4/6 animated, Example 1/3/5 not | Same archive check | correct |
| aitkenab.jl title | "f(x) = x³−3x+2  (p = 1)" | Expanding (x−1)²(x+2) gives x³−3x+2 | correct |
| aitkencd.jl title | "f(x) = (x²−2)sin(x²−2)  (p = √2)" | f(√2) = 0 and f'(√2) = 0 | correct |
| aitkenef.jl title | "f(x) = x⁶−7x⁴+15x²−9  (p = √3)" | Expanding (x²−1)(x²−3)² gives the polynomial | correct |
| Legend "Newton x_22" | 1.0000003115 / 1.4142135151 / 1.7320507835 | mpmath exact Newton gives 1.0000003115 / 1.4142135151 / 1.7320507852. Case 3 differs in the last two digits because of Float64 rounding near the double root (see note in New problems). Errors 3.1e-7, 4.7e-8 and 2.4e-8 match the unchanged page text | correct (Float64 values) |
| Annotation S_k | S_3 = 0.9999999934 (Case 1), S_4 = 1.4142135624 (Case 2), S_6 = 1.7320508222 (Case 3) | Errors 6.6e-9, under 1e-10 and 1.46e-8 match the page's 6.6e-9, 6.7e-16 and 1.5e-8. Exact-arithmetic Steffensen errors in Case 1 are 1, 0.057, 2.8e-4, 6.6e-9 | correct |
| aitkencd.jl annotate y | Moved from 0.08 to −0.15 (below the axis) | Frames 003, 012, 023: the label is legible and overlaps neither the curve nor the markers | fine |
| all scripts | `left_margin=3Plots.mm` | The y-labels are no longer clipped | fine |

### New problems
None.

Observation, not a defect: the Case 3 Newton legend now prints 10 decimals. The last two (x_22 = 1.7320507835 against 1.7320507852 in exact arithmetic) reflect Float64 rounding when evaluating the expanded polynomial near the double root. The label is the iterate the script actually computes and plots. The page already says (line 20) that rounding limits Newton on Cases 1 and 3, and the page's error 2.4×10⁻⁸ is this Float64 value. So the label is consistent with the page.

This rests on the following:
- I viewed frames 001, 003, 006, 012 and 023 of the new GIFs at full size.
- The bottom panels are unchanged apart from the margin.
- The Newton marker now sits on top at frame 0 (x₀ = S₀), where it covers the S₀ diamond. Both mark the same point and the legend lists both, so this is harmless.

### Reproducibility and conventions
- I ran each of the three changed scripts from a scratch copy (`check/run/`). Each output GIF is byte-identical (`cmp`) to the committed GIF: aitkenab, aitkencd and aitkenef.
- The pre-fix GIFs were obtained via `git show HEAD:… | git lfs smudge` for comparison.
- Conventions still hold:
  - Description comes before Animations.
  - Each case has a `[Julia source](…)` link and a GIF embed.
  - The alt text is descriptive and unchanged, and still accurate.
  - There are no code blocks.
- The fix diff touches only the page folder: 3 .jl files, 3 GIFs and index.qmd.
- Other modified pages and the untracked `reviews/numerical-methods-animations-r2/fixes/*.md` records on the branch belong to other pages' fixes or to fix records, not to this page's diff.

**Final status:** committed
