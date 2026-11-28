# Numerical methods: the light pass

Written 2026-11-25. It follows the coverage review in `mathews-coverage-gaps.md` and Jason's decisions on it.

## Goal

The site's purpose is what is instructive and insightful. That means the animations, plus a short overview of each method. Proofs and the full set of worked examples belong to the course and the book, not to this site. Two kinds of work follow from that:

- **Three new topics.** Heun's Method, the Lin-Bairstow Method and Big "O" Truncation Error get pages. Big "O" opens a new **Fundamentals** section at the top of the index. Numerical Differentiation gets the four forward and backward difference animations that survive in the archive.
- **The 53 pages built before batch 1 get a proper overview.** Each page gets a `## Description` that meets the overview standard below. Nothing else on these pages is rewritten.
  - The animations on these pages have been through nine review rounds, and they stay as they are.
  - The 41 pages of batches 1–9 are left alone, even though they go further than this standard.

## The overview standard

A page's `## Description` comes first, before `## Animations`. It has 150–400 words of prose, plus display math. In the count, each inline math expression is one word, and display math and table rows are not counted. It contains these six things, in this order unless the page reads better otherwise:

1. **The problem.** What the method solves, in one or two sentences.
2. **The core formula.** The method's formula or formulas, as display math, in the same notation as the page's animations.
3. **What it assumes.** The method's hypotheses: for example, a sign change, a smooth enough f, f′ ≠ 0 at the root, or an even number of subintervals.
4. **How accurate it is.** The convergence order or the error term, stated as a general result, with the conditions under which it holds ("for a simple root", "if f ∈ C⁴[a, b]"). Where an animation on the page shows this, point to the case.
5. **When it fails or misleads.** One or two concrete failure modes. Prefer the ones the page's animations show, and link to the case.
6. **Where it fits.** One sentence linking related pages on the site, for example Secant → Newton-Raphson and False Position.

**Optional: one short worked example.** It is a table of at most about six rows, or at most five steps. Include it only when it adds something the animations do not show, such as the iterates' digits. Use the page's own animated problem, so the numbers agree with the GIFs.

**Left out:** proofs, derivations beyond a one-line intuition, definition and theorem callout boxes, the module's full set of examples, and Mathematica or MATLAB procedures. One `callout-important` box for the key formula is allowed.

**Accuracy.** The Accuracy standard and the claim ledger of `content-page` apply to every new sentence. Every number is computed. Every general result is labelled as general and is not attached to an example unless it has been checked for that example. A general convergence result is the easiest place to make a plausible but false claim, so it gets the same check as a number.

**Edits outside the Description:**
- Overview sentences that now sit in the `## Animations` introduction may be moved into the Description, without changing what they say. The ledger records each move.
- The only change allowed inside the Animations sections is a link or a cross-reference. To link to a case, add an explicit id to its heading (`### Case 2 — … {#case-2}`) and link `[Case 2](#case-2)`, as the pilot pages do.
- Other sections (Derivation Notes, Worked Example, Outside Links, References) stay as they are, unless they contradict the new Description. A contradiction is reported to the director, not fixed silently.

## Step 1: adapt the skills (own branch, `light-pass-skills`)

1. **`content-page`:** add an "Overview standard" section, copied from above. It applies when the brief says "overview". In that mode the writer edits only the Description (and makes the moves allowed above), keeps the page's folder and animations, and keeps a ledger of every new sentence.
2. **`run-animation-batch`:**
   - It reads the batch from this plan when the batch number is 15 or more, and from `numerical-methods-animation-plan.md` otherwise.
   - It gains an "overview" page kind. For these pages, Phase 1 runs `content-page` in overview mode on an existing page, not only on skeletons. Phase 2 runs only for pages marked "new animations" in the batch table.
   - A page is done when its Description meets the standard and its last review round found no Error or Misleading findings.
3. **`review-animations`:** add an overview mode for those pages.
   - The reviewer's claim ledger covers the text the batch added or changed (the page's `git diff` against `main`), and checks that text against the page's animations and remaining text.
   - It also checks the Description against the six points of the standard. A missing point is a Minor finding.
   - The calibration error is planted in the new text.
   - Animations are not re-reviewed unless the batch changed them. New pages and new animations get the full review.
4. Update the `deferred-cleanup` memory note: the skill no longer reads only the old plan by name.

## Step 2: pilot two pages, then Jason checks the format

On branch `light-pass-pilot`, write overviews for two pages with the skills from Step 1, review them, and fix what the review finds:

- **Newton-Raphson Method**, which has no Description now;
- **Simpson's Rule**, which has a 60-word one.

Jason reads the two pages and either approves the format or adjusts the standard. Only then are batches 15–22 run. The two pilot pages count as done in batches 16 and 20.

## Batches

Batch numbers continue from the first plan, so branch names (`batch-15`, …) do not clash with history. Run them with `/run-animation-batch <N>`.

- Batch 15 changes the index, so run it on its own.
- Batches 16–22 touch disjoint pages and do not change the index, so they can be stacked, as batches 3–13 were.

Each page is marked with one of four actions:
- **write:** the page has no Description, so one is written to the standard.
- **extend:** the Description is short, so it is brought up to the standard.
- **check:** the Description is already substantial, so it is checked against the six points and only what is missing is added. A page that already meets the standard is left alone, and the review confirms that.
- **new:** a new page or new animations.

| Batch | Theme | Pages |
|---|---|---|
| 15 | New topics and index | Heun's Method (new), Lin-Bairstow Method (new), Big "O" Truncation Error (new), Numerical Differentiation (extend, plus 4 new animations) |
| 16 | Root finding I | Bisection (write), False Position (write), Fixed Point Iteration (write), Newton-Raphson (write; pilot), Secant (write), Muller's (write), Aitken and Steffensen (check), Accelerated and Modified Newton (extend) |
| 17 | Root finding II | Improved Newton (extend), Halley's (check), Brent's (check), Graeffe's (check), Nonlinear Systems (check), Broyden's (check), Madsen-Reid (check) |
| 18 | Series and interpolation I | Maclaurin and Taylor (check), Padé (check), Laurent (extend), Lagrange (extend), Newton Interpolation (extend), Hermite (extend), Aitken's and Neville's (extend), The Tangent Parabola (write) |
| 19 | Interpolation II and curve fitting | Cubic Splines (extend), B-Splines (extend), Bézier (extend), Chebyshev (extend), Rational Approximation (extend), Legendre (write), Catenary (write), Least Squares Lines (extend), Least Squares Polynomials (extend) |
| 20 | Differentiation and integration I | Richardson (extend), Derive Differentiation Formulae (extend), Riemann Sums (extend), Midpoint (extend), Trapezoidal (extend), Simpson's (extend; pilot), Simpson's 3/8 (extend), Boole's (extend) |
| 21 | Integration II | Newton-Cotes (extend), Romberg (extend), Adaptive Simpson's (extend), Gauss-Legendre (extend), Cubic Spline Quadrature (extend), Monte Carlo Pi (extend), 2D Trapezoidal and Simpson (extend) |
| 22 | ODEs | Euler's (extend), Taylor Series for ODEs (write), Runge-Kutta (write), Runge-Kutta-Fehlberg (extend), Adams-Bashforth-Moulton (extend) |

This covers 53 existing pages (11 write, 33 extend, 9 check) and 3 new pages.

### Batch 15 in detail

The director makes the index changes. Page work goes through the skills.

- **Index:**
  - Add a `## Fundamentals` section above "The Solution of Nonlinear Equations", with Big "O" as its only entry.
  - Add Lin-Bairstow after Horner's Method.
  - Add Heun's Method after Euler's Method.
- **Heun's Method (`heuns-method/`, animated):**
  - `content-page` writes the Description from standard sources. The module (`n2003/Heun'sMethodMod.html`) lost every equation image, so its text can only confirm the structure: the theorem, the precision theorem and the examples.
  - `animation-page` rebuilds `a2001/Animations/OrdinaryDE/Heun1/Heunaa.gif`: 36 frames, y′ = 1 − t∛y, y(0) = 1 on [0, 5], with an m-sweep ending at m = 150, where the GIF prints y(5) = 0.0081236. Read the m values from the frames, and use the same reference curve and labels as the Euler page's cases.
  - One new case is allowed: the error at t = 5 against h on log-log axes for Euler, modified Euler and Heun, showing orders 1, 2 and 2.
  - Link to the new page from the Euler and Predictor-Corrector pages where they mention Heun's method. Those are one-line edits by the same subagent.
- **Lin-Bairstow Method (`lin-bairstow-method/`, animated):**
  - The Description follows the module (`n2003/BairstowMethodMod.html`, folder `bairstowmethod/`, with 5 example pages and images intact): quadratic synthetic division, then Newton's method on the remainder coefficients (r, s).
  - The animations are new; Mathews made none, and the page must say so. Two cases:
    - the (r, s) iterates converging, beside the quadratic factor's two roots moving in the complex plane;
    - deflation finding every root of the module's example polynomial.
  - Check every example polynomial and starting value against the module's images.
- **Big "O" Truncation Error (`big-o-truncation-error/`, animated):**
  - It is a concept page, not a method, so the standard is adapted. The page covers:
    - the problem: describing how fast an error goes to zero;
    - the definitions for functions and for sequences, as display math;
    - the rules for combining O(hᵖ) terms;
    - a pointer to where the site uses it (Taylor, quadrature, ODE pages).
  - It takes 2–3 short examples from the module (`n2003/BigOMod.html`, folder `bigoh/`, with 9 example pages and images intact).
  - One new animation: the errors of approximations of different orders against h on log-log axes, with the ratio |E(h)|/hᵖ staying bounded.
  - If the writer finds no animation that teaches more than a table, the page stays flat and text-only. That is a decision to record for Jason.
- **Numerical Differentiation (extend):**
  - The Description adds the forward and backward difference formulas of orders O(h) and O(h²), and the three-point second-derivative formula, each with its order.
  - Four new cases rebuild `a2001/Animations/Derivative/`:
    - `ForwardD1f/ForwardDfaa.gif` (38 frames): forward difference, O(h);
    - `ForwardD2f/ForwardD1faa.gif` (28 frames): forward difference, O(h²), with the parabola;
    - `BackwardD1f/BackwardDfaa.gif` (38 frames): backward difference, O(h);
    - `BackwardD2f/BackwardD1faa.gif` (28 frames): backward difference, O(h²), with the parabola.
  - All four use f(x) = e⁻ˣ sin x at x = 1. The frames show h falling from 0.6, and the h values must be read from them.
  - The Animations introduction's "not animated" list is updated to match.

## Finish

After batch 22:

1. Render the whole section (`quarto render pages/numerical-methods/`).
2. Update the index status note.
3. Mark this plan finished, as the first plan was.

## Status

- Step 1 (skills): done 2026-11-25 on branch `light-pass-skills` (commit 965fc1b), merged into `main` with the pilot; skill-text fix 88a48a6.
- Step 2 (pilot): run 2026-11-25 on branch `light-pass-pilot` (branched from `light-pass-skills`), review in `reviews/light-pass-pilot`, merged into `main`. **Format approved by Jason 2026-11-25**, as built: 150–400 words with inline math counted as one word, the optional short table, and explicit `{#case-N}` heading ids for case links (all now written into the standard).
  - Newton-Raphson Method (write): Description written (386 words, six points, 6-row table of Case 1's iterates, case anchors `{#case-1}`…`{#case-6}`); review round 1 clean (0 Error, 0 Misleading, 0 Minor). Done (counts as done in batch 16).
  - Simpson's Rule (extend): Description extended (334 words, 5-row table of Case 1's errors, anchor `{#case-1}`); review round 1 clean (0/0/0). Done (counts as done in batch 20).
- Batch 15 (new topics and index): run 2026-11-25 on branch `batch-15`, review in `reviews/batch-15`. Index: Fundamentals section with Big "O", Lin-Bairstow after Horner's Method, Heun's Method after Euler's Method. Review round 1: 0 Error, 0 Misleading, 5 Minor; all five fixed and independently checked.
  - Heun's Method (new): Description (379 words); Case 1 rebuilds `Heunaa.gif` (21 runs, every printed y(5) reproduced), Case 2 new (log-log errors of Euler, midpoint and Heun). One-line links from the Euler and Predictor-Corrector pages. Done.
  - Lin-Bairstow Method (new): Description (374 words, Example 4 table); two new cases (Example 4 convergence, quintic deflation), no Mathews original. Done.
  - Big "O" Truncation Error (new): Description (390 words, adapted standard); one new case (Taylor polynomials of e^h, |E|/hᵖ bounded); the page is animated, not flat. Done.
  - Numerical Differentiation (extend, plus 4 new animations): Description extended (392 words); Cases 3–6 rebuild the four forward/backward legacy GIFs. Their h starts at 1 (O(h)) and 0.5 (O(h²)), not 0.6 as this plan said, and Mathews' last frame is h = 0.0005. Done.
- Batch 16 (root finding I): run 2026-11-28 on branch `batch-16` (stacked under `batch-17` … `batch-22`), review in `reviews/batch-16` and `reviews/batch-16-r2`. Round 1: 2 Error, 0 Misleading, 7 Minor; round 2 (the five changed pages): 0 Error, 0 Misleading, 7 Minor. All fixed and independently checked, except the Aitken–Steffensen word count (decision for Jason). Newton-Raphson was done in the pilot.
  - Bisection Method (write): Description 398 words; Case 1 error bound and non-monotone error, Case 2 broken hypotheses, exact-hit caveat. Done.
  - False Position (write): 398 words; linear rate with constant C checked on both cases, fixed endpoint, x¹⁰ − 1 example. Done.
  - Fixed Point Iteration (write): 396 words; 6-row table of Cases 2–3, repelling fixed points in Cases 4–6. Done.
  - Secant Method (write): 398 words; 6-row table of Case 1 (extended precision), f″ = 0 and double-root rates. Done.
  - Muller's Method (write): 397 words; order 1.84 when f‴(p) ≠ 0, 1.23 at the double roots, complex step in Case 1. Done.
  - Aitken's Method and Steffensen's Acceleration (check): missing points added; 464 words, over 400 (not trimmed: reviewed text). Done.
  - Accelerated and Modified Newton-Raphson (extend): 399 words; 4-row error table, wrong-multiplier range 0 < μ < 2m. Done.
- Batch 17 (root finding II): run 2026-11-28 on branch `batch-17`, review in `reviews/batch-17`. Round 1: 0 Error, 0 Misleading, 10 Minor; five fixed and independently checked, five are word counts of *check* pages (not trimmed, for Jason). No round 2 needed.
  - Improved Newton Method (extend): 389 words; linear (m−1)/m and Method A's limit h′/(mh) checked on Cases 1–4, wrong-multiplicity and Case 5 failures. Done.
  - Halley's Method (check): hypotheses, case pointers (C = 1/8, 1/3) and links added; 400 words. Done.
  - Brent's Method (check): case pointers and links added; 500 words (over 400). Done.
  - Graeffe's Method (check): case pointers, double-root rate and links added; 417 words (over 400). Done.
  - Nonlinear Systems (check): rate pointers, smoothness hypothesis and links added; 441 words (over 400). Done.
  - Broyden's Method (check): hypotheses and Case A ratios added; 539 words (over 400). Done.
  - Damped Newton with Acceleration (Madsen-Reid) (check): core-formula display, simple-root rate and links added; 1167 words (over 400). Done.
- Batch 18 (series and interpolation I): run 2026-11-28 on branch `batch-18`, review in `reviews/batch-18`. Round 1: 0 Error, 0 Misleading, 4 Minor; all fixed and independently checked. No round 2 needed.
  - Maclaurin and Taylor Series (check): remainder, hypothesis, case links added; 400 words. Done.
  - Padé Approximation (check): hypothesis, Case 16 contrast, links added; 399 words. Done.
  - Laurent series (extend): 400 words; geometric rate (Case 02), divergence and slow convergence near the circles. Done.
  - Lagrange Polynomial Interpolation (extend): 394 words; error theorem, Runge (Case 08), extrapolation (Case 04). Done.
  - Newton Interpolation Polynomial (extend): 388 words; divided differences, Mathews' equal-spacing bounds checked on the dd case. Done.
  - Hermite Polynomial Interpolation (extend): 396 words; h⁴/384 bound, pre-asymptotic ratios, overshoot. Done.
  - Aitken's and Neville's Interpolation (extend): 399 words; Aitken's recursion, remainder bounds on Case 2, convergence-test trap in Case 1. Done.
  - The Tangent Parabola (write): 376 words; 4-row coefficient table (Mathews' Table 1), O(h²) rate, |x| and round-off failures. Done.
- Batch 19 (interpolation II and curve fitting): run 2026-11-28 on branch `batch-19`, review in `reviews/batch-19`. Round 1: 0 Error, 0 Misleading, 3 Minor; all fixed and independently checked. No round 2 needed.
  - Cubic Splines (extend): 393 words; 5-row natural-spline error table (sin O(h⁴), cos O(h²)). Done.
  - B-Splines (extend): 397 words; Cox-de Boor, local support, closed last span. Done.
  - Bézier Curves (extend): 398 words; Bernstein, power and de Casteljau forms, t = 1/2 levels. Done.
  - Chebyshev Approximation Polynomial (extend): 386 words; Lagrange–Chebyshev bound, Case 08 geometric rate, endpoint singularities. Done.
  - Rational Approximation (extend): 383 words; interpolation system, alternation theorem, Padé comparison. Done.
  - Legendre Polynomials (write): 395 words; recurrence, orthogonality, L² optimality, Gibbs overshoot. Done.
  - Catenary (write): 392 words; Taylor gap bound checked on Case 1, slack-cable failure, fit equation. Done.
  - Least Squares Lines (extend): 395 words; normal equations, power fit, x-on-y and constraint pitfalls. Done.
  - Least Squares Polynomials (extend): 398 words; normal equations, conditioning, extrapolation. Done.
- Batch 20 (differentiation and integration I): run 2026-11-28 on branch `batch-20`, review in `reviews/batch-20` and `reviews/batch-20-r2`. Round 1: 0 Error, 1 Misleading, 4 Minor; round 2 (four changed pages): 0 Error, 0 Misleading, 1 Minor. All fixed and independently checked. Simpson's Rule was done in the pilot.
  - Richardson Extrapolation (extend): 367 words; D₅ remainder h⁴/480, Case 2 slopes, rounding. Done.
  - Derive Numerical Differentiation Formulae (extend): 400 words; derivation recipe now expands to degree n+2 as Mathews does; four formulas with remainders. Done.
  - Riemann Sums (extend): 380 words; first-order results, bracket width ≤ VΔx, L/R not bounds. Done.
  - Midpoint Rule (extend): 399 words; error term, ½-of-trapezoidal relation (when f′(a) ≠ f′(b)), h^{5/3} on Case 1. Done.
  - Trapezoidal Rule (extend): 295 words; error term and sign rule, 5-row table, h^{5/3} on Case 1. Done.
  - Simpson's 3/8 Rule (extend): 342 words; error term, 9/4 of Simpson's constant, 4-row table. Done.
  - Boole's Rule (extend): 390 words; error term, O(h⁶), 5-row table, Romberg's third column. Done.
- Batches 21–22: in progress on stacked branches (see their entries).
