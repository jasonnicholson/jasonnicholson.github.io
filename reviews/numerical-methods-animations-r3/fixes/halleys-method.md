# Fix record: halleys-method

Scratch folder: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/halleys-method/fix/` (scripts `f1_check.py`, `f1_repeat.py`, `topng.jl`; archive images `arch_gr_*.png`).

## Findings

### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I f1_check.py` (mpmath, generic f, f′, f″ formulas for f = x² − 2, x₀ = 2, fixed working precision dps = digits + 20, stop when |x − √2| < 10⁻ᵈ):
  - 2^(1/2) = 1.41421, 3^(1/3) = 1.44225 (ratio − 1 = 0.0198, a 2% gain); log 2 / log 3 = 0.63093.
  - 500 digits: Newton 10 it 0.0003 s, Halley 6 it 0.0003 s.
  - 20,000 digits: Newton 15 it 0.064 s, Halley 10 it 0.069 s.
  - 200,000 digits: Newton 18 it 2.67 s, Halley 12 it 2.75 s.
  - `f1_repeat.py`, 5 repeats at 20,000 digits: Halley/Newton time 1.18, 1.10, 1.15, 0.96, 1.51; always 10 vs 15 iterations.
  The page's claim "significantly faster overall" for √2 in high precision is not supported. The finding holds.
- Change: `index.qmd` Trade-offs paragraph (line 40). The sentence "Whether the extra evaluation is worthwhile … Halley's cubic rate makes it significantly faster overall." was replaced by two sentences. They give the iteration ratio log 2/log 3 ≈ 0.63 and the efficiency indices 1.442 vs 1.414, and say the time saving depends on the cost of f″ and the extra arithmetic. They also give the √2 example: to 20,000 digits at fixed working precision, Halley needs 10 iterations against Newton's 15 but takes about as long or slightly longer. The first sentence (three evaluations vs two) is unchanged.
- Check: see ledger. The iteration counts are deterministic. "About as long or slightly longer" covers the measured time ratios 0.96–1.18 (one outlier at 1.51), and the reviewer's 0.054/0.047 = 1.15. Timings are machine-dependent, so the page gives no seconds.

### R3-D — "not animated here" sentence moved — fixed
- The two closing lines ("Cases 1a, 1b and 2 follow Examples 1(a), 1(b) and 2(b) … Example 2(a) … is not animated here; Case 2's blue diamond shows only the Newton step from the current Halley iterate.") moved from after the Case 2 embed to the Animations introduction. They now sit after "Julia source scripts that generated these animations are linked under each case." and before the Case 1a heading. The wording is unchanged: it names cases explicitly ("Case 2's blue diamond", "the Case 2 function") and does not depend on its old position.
- Content check against the whole archive module (`n2003/Halley'sMethodMod.html`). `grep -n -E 'Example|Exploration'` finds only Example 1 (line 210) and Example 2 (line 231), with no Explorations. The solution links map to lnk_2 = 1(a) Newton, lnk_3 = 1(b) Halley, lnk_4 = 2(a) Newton and lnk_5 = 2(b) Halley (lnk_1 is the notebook header). The statement images read as follows: gr_61 f(x) = x² − 2, gr_63 p₀ = 2 (1(a)), gr_175 f(x) = x³ − 3x + 2, gr_177 and gr_178 p₀ = −2.2 (2(a) and 2(b)). The only other content sections are background (definitions, theorems) and "Square Roots" formulas (3)/(4), which are the x² − A case already covered by Cases 1a/1b, not an example. The page animates 1(a) (Case 1a, Newton), 1(b) (Case 1b) and 2(b) (Case 2), and omits only 2(a). That is a complete list.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Trade-offs | "Because its digits triple rather than double" | Restates the page's own Description claim (asymptotic). Reviewer's digits for Case 1b: 1.84 → 6.44 → 20.2 → 61.6 (ratios ≈ 3.5, 3.1, 3.05); Newton 1.07 → 2.61 → 5.67 → 11.8 → 24.1 (≈ 2). Used only for the high-precision count | yes |
| Trade-offs | "about log 2/log 3 ≈ 0.63 times as many iterations for a high-precision result" | `f1_check.py` → log2/log3 = 0.63093; observed counts 6/10 = 0.60, 10/15 = 0.667, 12/18 = 0.667 | yes |
| Trade-offs | "efficiency index 3^{1/3} ≈ 1.442 … Newton's 2^{1/2} ≈ 1.414" | `f1_check.py` → 1.4422495…, 1.4142135… (evaluations per step 3 and 2, as the preceding sentence states) | yes |
| Trade-offs | "barely above" | 1.4422/1.4142 − 1 = 0.0198 (2%) | yes |
| Trade-offs | "whether it saves time depends on how costly f″ and the extra arithmetic are" | Qualitative and follows from the efficiency-index comparison. For f = x² − 2 (f″ = 2, trivially cheap) the timing still shows no saving | yes |
| Trade-offs | "√2 from x₀ = 2 to 20,000 digits at fixed working precision with the formulas above … Halley needs 10 iterations against Newton's 15" | `f1_check.py` / `f1_repeat.py` → Newton 15, Halley 10 (all 6 runs). Formulas are the page's Newton and Halley iteration formulas with f = x² − 2 | yes |
| Trade-offs | "takes about as long or slightly longer" | `f1_repeat.py` → H/N time 1.18, 1.10, 1.15, 0.96, 1.51; `f1_check.py` 0.069/0.064 = 1.08; reviewer 1.15 | yes |
| Animations intro | Moved sentence (text unchanged): Cases 1a/1b/2 = Examples 1(a)/1(b)/2(b); 2(a) Newton on Case 2 function from same start not animated; Case 2 blue diamond = Newton step from current Halley iterate | Archive grep and statement images (above). `halleysba.jl` l.78 `x_newton = x_cur - fv/fpv` (reviewer W3) | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated, because F1 and R3-D are text-only.
- `git status --short -- pages/numerical-methods/halleys-method` shows `M pages/numerical-methods/halleys-method/index.qmd` only.

## Legacy archive
Consulted: `n2003/Halley'sMethodMod.html` (text stripped), its solution links lnk_1–5, and its statement images gr_61, gr_63, gr_175, gr_177 and gr_178, converted to PNG and viewed. The module has Examples 1(a)/(b) (f = x² − 2, p₀ = 2; Newton, then Halley) and 2(a)/(b) (f = x³ − 3x + 2, p₀ = −2.2; Newton, then Halley), and no Explorations. These match the page's cases, with 2(a) not animated and disclosed. On speed, Mathews says Halley can "speed up convergence significantly" and that the solutions show digits doubling for Newton and tripling for Halley. That is a claim about iteration count, not wall time, and the corrected page keeps that distinction.

## Notes
- The reviewer's Case 1b alt-text remark ("both next iterates marked", none on the last frame by design) was "not a finding" and was left alone.
- The timing sentence uses fixed working precision. A precision-doubling or specialised √ implementation would change the cost model, and the page's "depends on" clause covers that.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the flat claim "Halley's cubic rate makes it significantly faster overall" (old line 40) is gone. The replacement (new line 40) gives the iteration ratio log 2/log 3, the efficiency indices 3^(1/3) and 2^(1/2), says that the saving depends on the cost of f'' and the extra arithmetic, and gives a √2 example: 10 Halley against 15 Newton iterations to 20,000 digits, "about as long or slightly longer". I re-measured this independently in two arithmetic libraries, using the generic formulas (Newton x − f/f'; Halley x − 2ff'/(2f'^2 − ff'')) with f = x^2 − 2, x0 = 2, fixed working precision of 20,020 digits, stopping at |x − √2| < 10^−20000:
  - Iteration counts: Newton 15 and Halley 10 in both libraries. In Julia BigFloat the per-step log10 errors are, for Newton, −1.07, −2.61, −5.67, −11.8, … , −12542 (step 14), −20020 (step 15); for Halley, −1.84, −6.44, −20.2, −61.6, −186, −558, −1674, −5022, −15068 (step 9), −20020 (step 10).
  - mpmath 1.2.1 (pure-Python backend), `check/timing.py 20000`, three separate runs of 5–6 interleaved repetitions each. Newton took 0.059–0.085 s and Halley 0.067–0.116 s. Halley was slower in every one of the 16 paired repetitions, by roughly 5–40% under a loaded machine, with a typical ratio of about 1.1–1.15.
  - Julia BigFloat (MPFR), `check/timing.jl`, two separate runs, each of 5 repetitions taking the minimum of 20 timings. Newton took 4.46–4.78 ms and Halley 4.83–5.25 ms, a Halley/Newton ratio of 1.05–1.11 in all 10 repetitions.
  - So Halley takes fewer iterations but slightly longer wall time, which matches "about as long or slightly longer". At 500 digits (mpmath) the counts are 10 and 6 and the times are equal (0.0002 s), so the general sentence is not contradicted there either.
- An earlier Julia attempt showed Halley converging only linearly. This was my own bug: `2f1` is the Float32 literal 20.0, not 2·f1. I fixed it before taking the numbers above.

### R3-D move of the "not animated here" sentence — done correctly
- The two sentences ("Cases 1a, 1b and 2 follow Examples 1(a), 1(b) and 2(b)… Example 2(a)… is not animated here; Case 2's blue diamond shows only the Newton step from the current Halley iterate.") moved unchanged from after Case 2 to the Animations introduction (new lines 48–49). They now come after the "Julia source scripts" line and before Case 1a, and are worded as a statement about the source.
- R3-B: I checked the sentence against every example in `Halley'sMethodMod.html`. The module has exactly four parts: Ex 1 f = x^2 − 2, (a) Newton p0 = 2, (b) Halley p0 = 2; Ex 2 f = x^3 − 3x + 2, (a) Newton p0 = −2.2, (b) Halley p0 = −2.2 (images gr_61, gr_63, gr_175, gr_177, gr_178). The mapping 1a → 1(a), 1b → 1(b), 2 → 2(b) is correct. 2(a) is the only part left out, and it is Newton from the same starting value. `halleysba.jl` lines 78–81 confirm that the blue diamond is x_cur − f/f' from the current Halley iterate.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.40 | "digits triple rather than double" | Measured digit sequences above (Halley ×≈3, Newton ×≈2 per step) | correct |
| l.40 | log 2/log 3 ≈ 0.63 | 0.63093 (Python) | correct |
| l.40 | "about 0.63 times as many iterations for a high-precision result" | asymptotic ratio; the measured 10/15 = 0.67 at 20,000 digits | correct ("about", asymptotic) |
| l.40 | 3^(1/3) ≈ 1.442 | 1.44225 | correct |
| l.40 | 2^(1/2) ≈ 1.414 | 1.41421 | correct |
| l.40 | "per function evaluation… efficiency index", with 3 vs 2 evaluations per step | p^(1/d) with d = 3 and d = 2 | correct |
| l.40 | "barely above" | 1.442/1.414 = 1.020 | correct |
| l.40 | "depends on how costly f'' and the extra arithmetic are" | qualitative; consistent with the timings | correct |
| l.40 | √2 from x0 = 2, 20,000 digits, fixed precision, "formulas above" | the setup I re-ran | correct |
| l.40 | Halley 10 iterations, Newton 15 | measured 10 and 15 in both mpmath and MPFR | correct |
| l.40 | "takes about as long or slightly longer" | Halley/Newton time ratio 1.05–1.11 (MPFR) and about 1.1–1.15 (mpmath), repeated runs | correct |
| l.48 (moved) | Cases ↔ Examples 1(a), 1(b), 2(b) | Mathews module images | correct |
| l.49 (moved) | Example 2(a) = Newton on the Case 2 f, same x0, not animated; blue diamond = Newton step from current Halley iterate | module images gr_175, gr_177, gr_178; halleysba.jl l.78–81 | correct |

### New problems
None. This rests on: every number and sentence in the ledger recomputed above; the timing claim re-measured more than once in two independent arithmetic libraries; the moved text checked against every example in the Mathews module; and the diff touching only `index.qmd`, with no scripts or GIFs changed, so nothing in the pictures could have broken.

### Reproducibility and conventions
- No script or GIF changed (`git diff --stat HEAD -- pages/numerical-methods/halleys-method` lists only `index.qmd`, with 4 lines added and 5 removed), so there was nothing to regenerate.
- Conventions hold. Description (l.10) comes before Animations (l.42). Each case has a `[Julia source]` link and a GIF embed with descriptive alt text (l.55/57, 63/65, 71/73). There are no code blocks (0 occurrences of ```).
- This fix changed no file outside the page folder. The other modified files in the working tree belong to other pages' fixes.

**Final status:** committed
