# Numerical-methods animation review — round 4

Run of 2026-11-22 on branch `fix/numerical-methods-animations`, after the round-3 fix run. This is a fresh, independent review. The reviewers did not read earlier rounds or fix records; the comparison with earlier rounds below was written after this round's findings were final.

## Headline

- **All 53 animation pages were reviewed.** None was left out.
- **Findings:** 0 Error, 1 Misleading and 22 Minor. Seven of the Minor findings are Fidelity findings (departures from the Mathews archive).
  - The Misleading finding was confirmed by an independent checker who saw only the allegation.
  - Minor findings were not independently checked and are labelled unverified.
- **34 pages have no findings.** Each clean report has a full claim ledger. Each claim was checked against the reviewer's own computation, usually with mpmath, sympy or scipy at high precision.
- **Mechanical checks:** there are no inventory findings. All 113 scripts ran from scratch copies, and all 279 committed GIFs reproduce byte for byte. Every page is linked from the section index and embeds every GIF on disk.
- **Calibration passed.** A scratch copy of the Bisection page had two planted errors: a root wrong in the third significant digit, and a false behaviour sentence. The reviewer caught both. The real page was then reviewed separately and is clean.
- **The legacy Mathews archive was found and used** (`/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/` and `a2001/Animations/`). Every reviewer consulted it.
- **Environment:** Plots 1.41.2 and SpecialFunctions 2.7.2 in the global Julia environment, unchanged. Python: `/usr/bin/python3`.

## Read first

1. **[Runge-Kutta](runge-kutta-method.md) F1 (Misleading, confirmed with a correction).** The page explains the upturn at the end of the coarse runs by linear stability and by truncation error. The actual mechanism is different:
   - In every run that visibly turns upward (m = 12–52), an RK4 stage value goes below y = 0, where f contains ∛y, which is not smooth.
   - The size of the upturn depends on how ∛y is extended to negative y. With ∛max(y, 0), y(5) at m = 20 is 0.0054 instead of 0.289.
   - The page's "for smooth f" also needs a qualifier.
   - **Checker's correction:** m = 56 turns up with no negative stage. For m = 28, 32, 40, 44, 48 and 52, the first upward step has all stages positive, so the negative stages come after the upturn begins.
   - The round-3 rewrite of this paragraph is correct in every number it states; it misses this mechanism.
2. **[Taylor method](taylor-series-method-for-odes.md) F1.** The page says Mathews' different y(5) values come from his formulas using sign(y)|y|^{k/3}. The reviewer could not reproduce his values that way. Round 2's own fix record agrees: it read the rule from Mathews' code image, but its reproduction attempts did not match the negative-going runs either. The mechanism has never been computed; the verifiable part is that his values differ only for runs that go negative before t = 5.
3. **[Padé](pade-approximation.md) F1.** In Case 01, values off the bottom of the plot are clamped onto y = 0, which is also the x-axis. In nine frames a diverging approximant is drawn as if it were 0; for example, Taylor [4/0] is −270 at x = 10.5.
4. **"Not animated here" lists are still incomplete on three pages:**
   - [Aitken/Neville](aitkens-and-nevilles-interpolation.md): Examples 3–5 also plot Neville interpolants, not only tableaux.
   - [Numerical Differentiation](numerical-differentiation.md): the Project I examples are not listed.
   - [Richardson](richardson-extrapolation.md): the error-bound graphs of Examples 1, 3 and 4 are not listed.

## Per-page results

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [2d-trapezoidal-and-simpson-rules](2d-trapezoidal-and-simpson-rules.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [accelerated-and-modified-newton-raphson](accelerated-and-modified-newton-raphson.md) | 3 | 3 | 0 | 0 | 0 | clean |
| [adams-bashforth-moulton-method](adams-bashforth-moulton-method.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [adaptive-simpsons-rule](adaptive-simpsons-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [aitken-method-and-steffensen-acceleration](aitken-method-and-steffensen-acceleration.md) | 3 | 3 | 0 | 0 | 1 | findings |
| [aitkens-and-nevilles-interpolation](aitkens-and-nevilles-interpolation.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [bezier-curves](bezier-curves.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [bisection-method](bisection-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [booles-rule](booles-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [brents-method](brents-method.md) | 2 | 2 | 0 | 0 | 2 | findings |
| [broydens-method](broydens-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [b-splines](b-splines.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [catenary](catenary.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [chebyshev-approximation-polynomial](chebyshev-approximation-polynomial.md) | 1 | 29 | 0 | 0 | 0 | clean |
| [cubic-spline-quadrature](cubic-spline-quadrature.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [cubic-splines](cubic-splines.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [derive-numerical-differentiation-formulae](derive-numerical-differentiation-formulae.md) | 3 | 3 | 0 | 0 | 1 | findings |
| [eulers-method-for-odes](eulers-method-for-odes.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [false-position-or-regula-falsi-method](false-position-or-regula-falsi-method.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [fixed-point-iteration](fixed-point-iteration.md) | 6 | 6 | 0 | 0 | 0 | clean |
| [gauss-legendre-quadrature](gauss-legendre-quadrature.md) | 1 | 1 | 0 | 0 | 1 | findings |
| [graeffes-method](graeffes-method.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [halleys-method](halleys-method.md) | 3 | 3 | 0 | 0 | 1 | findings |
| [hermite-polynomial-interpolation](hermite-polynomial-interpolation.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [improved-newton-method](improved-newton-method.md) | 5 | 5 | 0 | 0 | 1 | findings |
| [lagrange-polynomial-interpolation-and-approximation](lagrange-polynomial-interpolation-and-approximation.md) | 1 | 29 | 0 | 0 | 2 | findings |
| [laurent-series](laurent-series.md) | 1 | 27 | 0 | 0 | 0 | clean |
| [least-squares-lines](least-squares-lines.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [least-squares-polynomials](least-squares-polynomials.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [legendre-polynomials](legendre-polynomials.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [maclaurin-and-taylor-series](maclaurin-and-taylor-series.md) | 1 | 31 | 0 | 0 | 0 | clean (1 out of scope) |
| [madsen-reid-method](madsen-reid-method.md) | 3 | 3 | 0 | 0 | 1 | findings |
| [midpoint-rule](midpoint-rule.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [monte-carlo-pi](monte-carlo-pi.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [mullers-method](mullers-method.md) | 3 | 3 | 0 | 0 | 2 | findings |
| [newton-cotes-integration](newton-cotes-integration.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [newton-interpolation-polynomial](newton-interpolation-polynomial.md) | 2 | 30 | 0 | 0 | 2 | findings |
| [newton-raphson-method](newton-raphson-method.md) | 6 | 6 | 0 | 0 | 0 | clean |
| [nonlinear-systems](nonlinear-systems.md) | 2 | 2 | 0 | 0 | 0 | clean |
| [numerical-differentiation](numerical-differentiation.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [pade-approximation](pade-approximation.md) | 1 | 27 | 0 | 0 | 1 | findings |
| [rational-approximation](rational-approximation.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [richardson-extrapolation](richardson-extrapolation.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [riemann-sums](riemann-sums.md) | 4 | 4 | 0 | 0 | 0 | clean |
| [romberg-integration](romberg-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [runge-kutta-fehlberg-method](runge-kutta-fehlberg-method.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [runge-kutta-method](runge-kutta-method.md) | 1 | 1 | 0 | 1 | 0 | findings |
| [secant-method](secant-method.md) | 6 | 6 | 0 | 0 | 0 | clean |
| [simpsons-3-8-rule-for-numerical-integration](simpsons-3-8-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [simpsons-rule-for-numerical-integration](simpsons-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [taylor-series-method-for-odes](taylor-series-method-for-odes.md) | 2 | 2 | 0 | 0 | 1 | findings |
| [the-tangent-parabola](the-tangent-parabola.md) | 1 | 1 | 0 | 0 | 0 | clean |
| [trapezoidal-rule-for-numerical-integration](trapezoidal-rule-for-numerical-integration.md) | 1 | 1 | 0 | 0 | 0 | clean |

## Fidelity findings (7, all Minor): for you to decide as a group

- **Lists of what is not animated:**
  - [Aitken/Neville](aitkens-and-nevilles-interpolation.md) F1;
  - [Numerical Differentiation](numerical-differentiation.md) F1;
  - [Richardson](richardson-extrapolation.md) F1.
- **A case's parameters differ from Mathews' with no reason given:**
  - [Lagrange](lagrange-polynomial-interpolation-and-approximation.md) F2: Case 14 (tan x) puts its nodes on [−3, 3], across both poles. Mathews' static example uses [−1.45, 1.45]; his animation for this case is not in the archive.
  - [Newton Interpolation](newton-interpolation-polynomial.md) F2: the divided-differences case uses cos x on [0, 2π] with nodes kπ/3. Mathews' Example 1 uses [0, 1] with nodes k/5. The reviewer calls the change defensible, since it makes each added term visible.
- **A method rule differs from Mathews' with no mention:**
  - [Runge-Kutta-Fehlberg](runge-kutta-fehlberg-method.md) F1: Case 1 "reconstructs" Example 1 with a different step-acceptance rule (error per unit step, not per step). At the same tolerance the page gets 259 points where Mathews gets 120, and final errors that differ by a factor of 15–20.
  - [Muller](mullers-method.md) F2: Case 1 handles the complex case differently from Mathews. This is the item you parked in round 3; the page is unchanged.

## Other Minor findings

- **[Muller](mullers-method.md) F1:** the Case 1 window is too coarse from frame 3 on to show that no parabola reaches the x-axis (parked with F2).
- **Numbers stated too precisely or not at all:**
  - [Aitken-Steffensen](aitken-method-and-steffensen-acceleration.md): see "Compared with earlier rounds".
  - [Gauss-Legendre](gauss-legendre-quadrature.md): the smooth-contrast error of 4×10⁻¹⁷ at n = 16 cannot occur in double precision; the error is round-off of about 1e-15.
  - [Halley](halleys-method.md): the Case 2 frame label shows "x₂ = -2.0" for −2.0000000029, which contradicts the page's statement that −2 is first reached at x₃.
- **Statements broader than what holds:**
  - [Brent](brents-method.md) F1: "the non-trivial root" of tan x = 2x, which has infinitely many.
  - [Graeffe](graeffes-method.md): linear convergence as "the diagnostic signature" of equal-magnitude roots; it does not apply to a complex-conjugate pair.
  - [Derive](derive-numerical-differentiation-formulae.md): five-point formulas as O(h⁴); this holds only for f′ and f″.
  - [Madsen-Reid](madsen-reid-method.md): the "Note on generalization" says the 53.13° rotation and the whole structure "translate directly" to real equations and systems, and calls the method an alternative to trust-region methods.
  - [Cubic Spline Quadrature](cubic-spline-quadrature.md): the text implies the largest gap stays at the peak; from m ≈ 11 on it is at the steep rise near x = 0.
- **Pictures or text that leave something out:**
  - [Brent](brents-method.md) F2: the last steps of both animations cannot be told apart.
  - [Improved Newton](improved-newton-method.md): "each drawn line is the tangent", but the vertical segments are not described.
  - [Lagrange](lagrange-polynomial-interpolation-and-approximation.md) F1: Cases 14, 18, 19, 21 and 23 show the same line at degrees 1 and 2 with no note. The page explains the same effect for Cases 12 and 13.
  - [Newton Interpolation](newton-interpolation-polynomial.md) F1: the Case 01–29 headings and alt text name no function or interval.

## Patterns

- **Text added by the fix rounds still produces most findings, but far fewer than before:**
  - **Runge-Kutta:** the round-3 rewrite got every number right but explains a mechanism that is not the cause.
  - **Taylor:** a mechanism added in round 2 was asserted, never reproduced.
  - **Aitken/Neville:** a "not animated" list extended in round 3 is still incomplete.
- **"Not animated here" lists remain the most common Fidelity problem.** Lists that were moved but not re-audited in round 3 (Numerical Differentiation, Richardson) have gaps, as does one that was audited (Aitken/Neville). Each list needs every example, exploration and project in the module checked against the page.
- **Display devices:** Padé's clamping to the x-axis and Brent's indistinguishable final frames are the only picture problems left in the section.
- **Same issue, different calls:** the [Laurent](laurent-series.md) reviewer saw vertical lines drawn across the poles in Cases 12 and 22–24 but did not count them. Round 3 counted the same thing on Lagrange Case 14. Decide whether you want these fixed everywhere.

## Outside the review scope (not counted)

- [Maclaurin and Taylor Series](maclaurin-and-taylor-series.md): the "Video Animations" text calls `abs` discontinuous. This is the same item as in round 3. It is out of scope, so it is recorded in the page file but not counted.
- **Noted by reviewers as cosmetic, not counted:**
  - Monte Carlo π says "Each animation below" for a single animation.
  - Romberg and Simpson 3/8 say "each frame" although frame 1 shows only f.
  - Several frame labels drop trailing zeros.
  - Pages still without a `## Description` section, among them Bisection, Newton-Raphson, Secant and Runge-Kutta.

## Compared with earlier rounds

- **Totals:**

  | Round | Error | Misleading | Minor | Archive used |
  |---|---|---|---|---|
  | 1 | 61 | 37 | 76 | no |
  | 2 | 2 | 8 | 79 | yes |
  | 3 | 0 | 3 | 28 | yes |
  | 4 | 0 | 1 | 22 | yes |

- **Recurring:** Muller F1 and F2 are the round-3 findings, unchanged because you parked the page.
- **Same sentence, different reading:** [Aitken-Steffensen](aitken-method-and-steffensen-acceleration.md).
  - Round 3 changed "6.66e-16" to "about 6×10⁻¹⁶", because the true error |S₄ − √2| is 5.7e-16.
  - This round's reviewer measured what the script computes, 6.7e-16 against the rounded fl(√2), and wants "6.7×10⁻¹⁶".
  - Both numbers are right for their reference. The fix is to say which one the page means.
- **Round-3 fixes:** none came back as a finding. Several pages had a new, smaller problem found in text that round 3 rewrote or left beside a fix: Runge-Kutta, Cubic Spline Quadrature, Graeffe, Halley and Lagrange.
- **Madsen-Reid:** the reviewer confirmed the R3-A version. The `fz0 = fz1` change is disclosed, and it alters no decision or iterate in the three animations. The corrected x₀ = −0.7 example checks out.

## How this round was run

- **Phase 1, done once by the director:**
  - inventory;
  - isolated scratch runs of all 113 scripts, eight pages at a time;
  - frames, contact sheets and frame hashes of every committed GIF;
  - one manifest per page.
- **Phase 2:** one reviewer per page, with the full Review standard, the page's manifest and its archive location.
  - The pilot was Bisection (on a calibration copy with planted errors), Simpson, Euler and Lagrange. Both planted errors were caught, and the clean Simpson report was spot-checked by recomputing its integral, final value and refinement ratio.
  - The two-line clean reports (Boole's, Least-Squares Polynomials, Monte Carlo π) were checked for ledger depth: 51, 51 and 33 ledger rows.
- **Phase 3:** the one Misleading finding went to a fresh checker who saw only the allegation.
- **Page files:** each page file has the findings, any check verdict, the Phase 1 inventory, and the reviewer's full claim ledger and implementation checks.
