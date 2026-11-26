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
