# Review: Powell's Method (batch 3, round 2)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).**

Legacy archive consulted: the module HTML, solution pages lnk_2–9 with their output images, subroutine images gr_15, gr_74, gr_216, gr_242, plotting programs gr_227 and gr_263, archived frames gr_228–240 and gr_264–276, `PowellMethodProof.pdf`, and `a2001/Animations/Optimization/Powell1/`. Independent computations: exact fractions for Examples 1–3; 80-digit mpmath for Examples 4–5 with every line search as the root of φ′ nearest 0 in the descent direction (polynomial root-finding, independent of the script's march and golden-section search); comparisons with Mathews' printed values.

## Findings

### F1 — Page match / fidelity — Minor (unverified): not every one of Mathews' line searches starts at γ = 0

- **Location:** Description, `index.qmd` line 24: "Mathews does every line search with Mathematica's `FindMinimum`, started at $\gamma = 0$."
- **True instead:** true of his `TaxiCab` and `Powell` subroutines (gr_15, gr_74, gr_216, gr_242 all use `FindMinimum[…, {γ, 0.0}]`), but the step-by-step part of Example 6 (gr_150 in lnk_7) uses `FindMinimum[f[P0 + γ u1], {γ, 0.5}]`. No number is affected: from 0.5 the search still reaches π − 5.5, since φ′(0.5) = −sin 6 > 0.
- **Fix:** "Mathews' programs do every line search with `FindMinimum` started at $\gamma = 0$ (his hand-worked Example 6 starts it at $\gamma = 0.5$, with the same results)."

### F2 — Page match / fidelity — Minor (unverified): "the same … colours … One thing is drawn differently" undercounts the differences

- **Location:** Animations introduction, line 30: "the same function, starting point, window …, cyan contour levels, colours and seven points. One thing is drawn differently."
- **True instead:** the dog-leg searches are drawn orange (`seg_color`, `powellbb.jl` line 137); Mathews draws every segment magenta (gr_263: `{Magenta, Thickness[0.004], Line[Take[V, i]]}`). Line 28 of the same section says the dog-leg is orange, so the picture itself is not misdescribed.
- **Fix:** "…cyan contour levels and seven points. Two things are drawn differently: the dog-leg searches are orange rather than magenta, and each search is drawn from where it starts…"

## Inventory (Phase 1)

3 scripts, 3 GIFs; all run; `powellaa.gif` (10 frames), `powellbb.gif` (10), `powellcc.gif` (16) byte-identical to what their scripts produce; every reference resolves; no unreferenced file; the section index links the page.

## Claim ledger (whole page; 92 entries; reviewer's verdicts)

- **Description (1–6):** confirmed except 6 (F1); 60-digit process could not be determined but every tabulated value agrees with the 80-digit roots; Mathews' maximum differences 3.32e-8, 4.6e-9, 5.69e-8, 3.61e-9, 2.40e-8, 4.5e-9.
- **Animations (7–42):** confirmed except 16 (F2): panel elements, zoom scaling, tangency (aa 3, bb 6, cc 3 and 6), no contour at (3, 2) (bb 7), the Case 3 sentence on where the contour disappears (cc 7: zoom only; cc 8–9: zoom; cc 10–13: none), exact rational vertices and the 256-bit golden search, "Under Construction" pages, window and levels (gr_227/263 contval2 equal the script's list), the polygon remark (gr_264–276); Case 1 steps 13/40 … 3/256, distances 0.13975, 0.034939, 0.0087346 (ratio exactly 4), zoom half-widths; Case 2 706/511, 0.0091039 vs 0.069877, 0.001094 and 7.126e-5, exact conjugacy, 511/507 onto (3, 2); Case 3 0.014975, 2.4753e-5, ≤ 5.51e-5, 0.0947°, 1.2265e-5, γ 0.999181, |U₂| 2.7521e-5, slope 2.0149, γ 402.7456, 0.011084, 3.467e-9, 2.607e-24; wiring.
- **Line searches, taxi-cab, Example 1 (43–54):** all confirmed (sympy for the parabolas, exact closed forms for k = 1…10, Mathews within 3.317e-8, gr_27).
- **Example 2 (55–62):** all confirmed (exact fractions; 0.48876953125 printed …313, acceptable; ratios 0.476, 0.298, 0.367, 0.427, 0.404; Mathews within 4.6e-9).
- **Powell's method, theorem, Example 3 (63–70):** all confirmed, including the proof's algebra and every fraction.
- **Example 4 (71–75):** all confirmed to all printed digits; Mathews within 1.217e-12 then 3.609e-9; last f ≈ 1.27e-25; Hessian ratio 2508.
- **Example 5 (76–81):** all confirmed (three tables, 8.8e-17, 1.43e-9, 3.81e-9, Mathews within 2.40e-8, five stationary points from the degree-9 resultant).
- **Example 6 (82–86):** all confirmed, including the textbook values (PowellMethodProof.pdf) and the true line minimum γ = 1.00000240 against the textbook's f = −1.9978294.
- **Enhanced method, graphical runs, notes (87–92):** all confirmed (gr_192–209, 10.67° in Example 4, gr_240 and gr_272 as frames).

## Implementation checks

- **powellaa.jl / powellbb.jl:** taxi-cab (gr_15) and basic Powell (gr_74), exact parabola vertex in `Rational{BigInt}`; γ values and points identical to the independent exact run (taxi-cab ends at (2.9921875, 1.99609375), f + 7 = 4.578e-5; Powell ends exactly at (3, 2)); the identity f(3 + u, 2 + v) + 7 = u² + v² − uv verified symbolically; frames 1, 3, 4, 6, 7 checked in full (e.g. bb frame 6 start (−9.785, −4.892)×10⁻⁴ plotted at (−9.8, −4.9) on ×10⁴ axes); 10 frames each.
- **powellcc.jl:** basic Powell; a legitimate first-local-minimum-downhill search (10⁻⁴⁰ probe, 10⁻³ first step quartered until downhill, doubling, 300 golden-section steps at 256 bits); all 12 searches agree to every printed digit with the 80-digit polynomial-root searches (e.g. γ 0.01497524692, −2.47530819e−5, 402.7455889, 1.000000478; f(X₄) 1.154e-46 vs 1.153876e-46; 2.607e-24); f_rel identity verified; frames 2–4, 6–13 checked (valley slope measured 2.02 in frame 12; segment slope 1.32 vs U₂ slope 1.324); no clamping that changes a conclusion.
