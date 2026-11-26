# Light-pass pilot review (Step 2 of `plans/numerical-methods-light-pass-plan.md`)

**2 pages reviewed in overview mode, 0 not reviewed. Findings: 0 Error, 0 Misleading, 0 Minor.**

Both new Descriptions check out claim by claim against independent computation (mpmath/sympy), the committed GIF frames and Mathews' module. The calibration page's reviewer caught both planted errors. No finding needed an independent check (Phase 3 had nothing to do), and there was nothing to fix.

| Page | Action | Scripts / GIFs changed | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [newton-raphson-method](newton-raphson-method.md) | write | 0 / 0 | 0 | 0 | 0 | clean (overview mode; calibration page) |
| [simpsons-rule-for-numerical-integration](simpsons-rule-for-numerical-integration.md) | extend | 0 / 0 | 0 | 0 | 0 | clean (overview mode) |

## How the review ran

- **Evidence (director):** each page's diff against the branch point with `main` (`a01b5c5`); frames and contact sheets from every committed GIF (`giftools.jl`); the text-only mechanical checks (control characters, leftover sections, `localhost`, code blocks, links and anchors); a prose word count of the Description; and a copy of the overview standard. Regeneration was skipped because neither diff touches a script. The committed GIFs are real image data, not LFS pointers. The archive was found at `/home/jason/Desktop/math-fullerton/baseline/mathews/`, and both reviewers consulted it.
- **Calibration:** the Newton-Raphson reviewer got a scratch copy with two planted errors in the new Description. One was a number wrong in the third significant digit (the asymptotic constant 0.7933 → 0.7963). The other was a general result attached to a case that contradicts it (Case 2 "speeds up to quadratic"). It reported both as Errors with the right values, so its brief was kept for Simpson's Rule. The copy differed from the page only at the two plants, so the calibration report is the page's review. Its computations also confirm the real text at the planted places.
- **Reviewers** read the review standard from `review-animations` in full, ran no MATLAB and no quarto, and changed nothing in the repository. Each returned its full report as text; the director wrote the files here.

## Patterns and notes

- No recurring mistake: both writers ledgered every number, and both stated the general results (quadratic convergence at a simple root; O(h⁴) under C⁴) with their hypotheses. They checked those results on the page's own case before pointing to it.
- The Simpson's writer removed one claim from the old Description, "typically much smaller than trapezoidal error at the same spacing". On this page's integrand it is false for n ≤ 6, and only a constant factor of about 3.5 elsewhere.
- **Word-count convention.** Newton-Raphson's Description is 386 words if each inline `$…$` counts as one word, and 480 if inline math is split on spaces. The standard does not say which. Both reviewers used the first.

## Pilot close-out (run-animation-batch, Phase 5)

**Pages:** Newton-Raphson Method (*write*) and Simpson's Rule (*extend*), overview mode only. Their animations are unchanged, and no page moved or was added. The index is unchanged.

**Findings by round:** round 1 (this folder): 0 Error, 0 Misleading, 0 Minor on both pages. No fixes, and no further rounds. Nothing is open.

**Checks the director made:**
- Recomputed with mpmath:
  - Newton: Case 1's root, iterates and error ratios (including the rounding of 0.79255 → 0.7926), and Case 6's growing oscillation.
  - Simpson: the integral, every table row, the 3.5× trapezoidal ratio and the n ≤ 6 reversal.
- Confirmed that each diff touches only the Description and heading ids.
- Counted the Description words.
- Checked that every link and anchor resolves in the rendered HTML.
- Rendered the whole section (`quarto render pages/numerical-methods/`), with no errors or warnings.

**Decisions taken for Jason to revisit:**
1. **Branch base.** `light-pass-pilot` was branched from `light-pass-skills`, not `main`, because the pilot needs the Step 1 skills and they are not merged yet. Merging this branch also brings in the two `light-pass-skills` commits (965fc1b, d88f5c9). The page diffs against `main` are unaffected, because `light-pass-skills` changes no page.
2. **Case anchors.** To link the Description to cases, the writers added explicit ids (`{#case-1}` …) to the case headings. This is the "cross-reference" edit the standard allows. It avoids Quarto's long auto-generated anchors for headings with math. If approved, batches 16–22 should do the same.
3. **Optional tables.** Both pages use the optional worked example: Newton's 6-row table of Case 1's iterates and error ratios, and Simpson's 5-row table of errors and halving ratios. Each adds digits the GIF does not show. Whether every page should have one, or only some, is part of the format check.

**Questions for the format check:**
- **Length.** Newton-Raphson is near the ceiling, at 386 words (480 if inline math is split on spaces), and its "Where it fits" is one long sentence with seven links. Is that the intended density, or should the standard aim lower (for example 250–300) and allow two sentences for "Where it fits"?
- **Word counting.** Should inline math count as one word? The standard does not say.

**Skill bug found (not fixed; outside the pilot's scope):** when `review-animations` is invoked with arguments, the skill loader substitutes positional parameters into its text. The line "shrinks its error by about `$2^p$`" became "by about out=reviews/light-pass-pilot^p$". The reviewers' copy of the Review standard was taken straight from the SKILL.md file, so it was intact. A fix is to write it as "about 2ᵖ" or as "a factor of 2 to the power p" in that skill. It is the only `$<digit>` in the skills (line 153 of both copies, `.github/skills/` and `.claude/skills/`).

**Commits on `light-pass-pilot`:**
- edb7b11 Write Newton-Raphson Method overview (light-pass pilot)
- 050b82c Write Simpson's Rule overview (light-pass pilot)
- 6b5e750 Add light-pass pilot review
- the commit that adds this close-out and the plan's Status note
