# Fix plan — numerical-methods animations

This is the plan for correcting everything the round-1 review found ([round-1 report](../README.md)). It covers 61 Error, 37 Misleading and 76 Minor findings across 51 pages, plus 3 inventory items. The [worklist](worklist.md) lists every finding with its status. The fixes are carried out by the director prompt `.claude/commands/fix-animations.md`, run as `/fix-animations`. When the fixes are in, independent re-review rounds use `/review-animations` with a new output folder.

**Before running anything, read the Decisions section.** Each decision has a default the director will use. Edit a decision here if you want it done differently; the director reads this file at the start of every run.

## Goal and finish line

A page is finished when all of these hold:

1. Every finding in its round-1 report has been fixed, or recorded as not reproduced with evidence.
   - Minor findings were never independently checked, so they must be reproduced before anything is changed.
2. An independent checker, shown the original findings and the diff but not the fixer's reasoning, agrees that each one is resolved. It also checks every sentence or number the fix added or changed.
3. Every script on the page runs, and every committed GIF is exactly what its script produces now.
4. The page renders with Quarto without errors.
5. The page's fix record is written and the page is committed on the fix branch.

The whole effort is finished after a full independent re-review (`/review-animations all out=reviews/numerical-methods-animations-r2`) finds no Error or Misleading findings. Any it does find go through another fix pass and another re-review round (`-r3`, …).

## Principles for every fix

- **Mathematics is the ground truth, here as in the review.** A round-1 finding is a claim too, even a verified one. The fixer confirms it before acting, and every number or behaviour sentence it writes is computed, not recalled. Most round-1 errors were plausible sentences nobody had computed; a fix that writes new uncomputed sentences repeats the original mistake.
- **Fix the right thing.**
  - If the animation is correct and the text is wrong, fix the text.
  - If the animation is wrong (wrong method, wrong numbers, numerical artifact, clamped value shown as real, clipped label), fix the script, regenerate its GIFs, and then make the text match the new animation.
- **Keep the page conventions from `.github/agents/animation-page.agent.md`:** Description before Animations, a source link and GIF embed per case, alt text that describes the animation, and no code blocks on the page.
  - Do not restructure pages or add teaching content beyond what a fix needs.
  - Leave the "(Planned)" and legacy-inventory stubs alone.
- **Shared code moves together.** The two copies of `lagnewt_animations_all.jl` must stay byte-identical. The three series scripts (Maclaurin, Padé, Laurent) should use one vetted exact-coefficient routine.
- **Keep changes to the page.** A fix touches only its own page folder, apart from the section index and orphan files named in the decisions. The global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2) is not changed.
- **The legacy Mathews archive is a reference, not the ground truth.** The fix and re-review runs happen on a machine that has the archive the pages were built from; the round-1 review did not.
  - Fixers use it to learn what each example was meant to be: the function, parameters, step size and behaviour Mathews showed.
  - Anything taken from it is computed before it goes on a page.
  - Where the archive and the mathematics disagree, the page follows the mathematics and says so where it matters.
  - From round 2 on, re-reviews also report departures from the archive that matter to a reader, as findings of kind Fidelity.
- **Regenerating GIFs is now intended.** Run each fixed script from its own folder, so that `@__DIR__` overwrites the committed GIF. Afterwards, check with `git status` that only the expected GIFs changed.

## Decisions (defaults the director will use)

**D1 — Quadrature integrand.** Eleven integration pages use f(x) = 1 + e^{−x} sin(8x^{2/3}) on [0,2], which is not smooth at x = 0. Every rule therefore converges at order 5/3, and the textbook rates do not apply.
- **Default:** keep the integrand. It is the shared Mathews example and the pages compare against each other.
  - Correct each page's Behavior and alt text to describe what the animation shows, using a measured order.
  - Add one sentence explaining the cause: the x^{2/3} term makes f′ unbounded at 0.
  - Keep the textbook order in the Description, explicitly labelled as holding for smooth f.
- **Alternative:** switch every quadrature page to a smooth integrand and regenerate all of them. This is consistent across pages but loses the Mathews example.

**D2 — ODE step size.** The Euler, Runge-Kutta, Adams-Bashforth-Moulton and Taylor-method pages solve y′ = 1 − t·y^{1/3}, y(0) = 1 on [0,5]. Here ∂f/∂y reaches −41.3 at t = 5 (true y(5) = 0.0081199205). At the current steps every method goes unstable in the tail.
- **Default:** keep the problem and interval, and use a step that is stable to t = 5 for that page's method. Animate a subset of the steps if the frame count gets large.
- Approximate minimum step counts on [0,5], from the stability limit at J = −41.3. The fixer verifies them before use.

  | Method | Stability limit | h must be below | Minimum n |
  |---|---|---|---|
  | Euler and Heun | 2 | 0.0485 | 104 |
  | RK4 | 2.785 | 0.0675 | 75 |
  | Taylor order 3 | 2.51 | 0.061 | 83 |
  | ABM4 PECE | 1.285 | 0.031 | 161 |

  Taylor order 4 has about the same limit as RK4.
- Add one sentence saying exactly what is computed: for steps longer than about h*, h·|∂f/∂y| exceeds the method's stability limit before t = 5, so from then on errors are amplified instead of damped. Just above h* this affects only the last steps. At the old step it starts at a computed time t. (The earlier wording here, "coarser steps become unstable once the solution flattens", is false and must not be used: for large h the onset comes before the solution flattens.)
- Check Mathews' own example in the legacy archive for the step size he used. If he used a coarse step, the default still applies. Say on the page, in a sentence, that the coarser step goes unstable.
- **Alternative:** keep the coarse steps and make the instability the point of each animation, rewriting the text accordingly.
- **Superseded for round 2 by R2-B below.**

**D3 — Orphan files.**
- **Default:**
  - Delete `lagrangeaa.jl` from the Lagrange page; it duplicates Case 01 and its GIF was never committed.
  - On the Newton Interpolation page, add `newtpolyaa.jl`/`.gif` as a linked case after verifying it. It is the only code there that builds the divided-difference table the Description explains.
  - Delete `newtpolybb.jl`/`.gif`. Its "Runge Phenomenon" title is wrong for all but the last frame, and Lagrange Case 08 already covers Runge.
- **Alternative:** leave all orphans in place and untouched.

**D4 — Broken section-index links.** `pages/numerical-methods/index.qmd` links `milne-simpsons-method/`, `predictor-corrector-methods/` and `shooting-methods-for-odes/`, but those pages are still flat `.qmd` files.
- **Default:** change the three links to point at the `.qmd` files.

**D5 — Minor findings.**
- **Default:** fix every Minor finding the fixer can reproduce.
- A purely cosmetic one, such as a legend overlapping a point, may be fixed only if it is cheap and safe. Otherwise record it as `deferred` with a reason.

**D6 — Laurent page content.** None of the 27 Laurent cases has a principal part, so every frame is a Taylor polynomial.
- **Default:** reword the page and the GIF legends to say so honestly (finding F1).
- Adding real Laurent cases with poles is new content and is out of scope. It is listed here for Jason to decide later.

**D7 — Text against animation when both are defensible.** An example is "degree one step at a time" when the script skips degrees.
- **Default:** change the text to describe the animation, not the animation to fit the text, unless the round-1 finding says the animation itself misleads.

**D8 — Git.**
- Work on the branch `fix/numerical-methods-animations`.
- Make one commit per page, and one per shared work package where shared code changes.
- The director commits. Subagents never do.
- Nothing is pushed.
- Any uncommitted change already in the working tree when a run starts is not part of this work and is never staged.

## Round 2 decisions (Jason, 2026-11-22)

These apply when fixing from `reviews/numerical-methods-animations-r2`. Where they conflict with D1–D8, they take precedence.

**R2-A — Fidelity findings (departures from the Mathews archive).** Jason left this to the director. The rule:
- **Follow Mathews** when the departure is a parameter of an existing case or an element missing from the picture. Parameters include the interval, starting point, centre, function and step. Picture elements include sample-point markers, panel dividers and legacy-style bars. Examples:
  - Chebyshev case 03 interval;
  - Fixed-Point cases 4–6 starting points;
  - Maclaurin T08–T12 centres and functions, and M10;
  - Bisection intervals;
  - panel markers on Simpson, Simpson 3/8, Newton-Cotes and Boole;
  - Gauss-Legendre bars.

  If following Mathews would make the page mathematically wrong, or would contradict a fix that round 1 confirmed, keep the page. Say why in one sentence on the page, and record it.
- **Add one sentence** when a whole Mathews example or topic is left out, saying what was left out. Do not add the example. This is the case for, among others, B-Splines (Mathews' subject is B-spline interpolation), Monte Carlo π, Rational, Catenary, Hermite and Tangent Parabola.
- **Correct every stale "legacy GIF missing" note.** These appear on Euler, Midpoint, Simpson 3/8 and Newton-Cotes, and the GIFs are in `a2001/Animations/`.

**R2-B — ODE animations: do what Mathews did.** On Euler (both cases), Runge-Kutta, Taylor (both orders) and Adams-Bashforth-Moulton:
- Replace the single fixed-step trajectory with Mathews' **step-refinement sweep**. Each frame is a full run over [0, 5] with m subintervals, labelled with m and the computed y(5).
- Take the m sequence from the page's own legacy GIF in `a2001/Animations/OrdinaryDE/` (for example Euler m = 10…130, Modified Euler 12…120, RK4 12…150). Reproduce Mathews' printed y(5) values as the check.
- Coarse m goes unstable and fine m converges. The text describes exactly that, with computed numbers and the corrected D2 stability sentence.
- Keep the exact-solution reference curve.

**R2-C — Madsen-Reid: follow Jason's reference implementation.** The page's method is Vestermark's `newton_real` (Future Team ApS, 2002), downloadable at <https://www.hvks.com/Numerical/Downloads/Newton_Real.cpp>. That file, not the 1975 Madsen–Reid report, is the reference for the scripts and the page. Fixers read it from the URL; it carries a restrictive licence, so do not copy it into the repository. Port its iteration faithfully:
- the stage test `stage1 = f2/u > u/f/4 || f != ff`, with Stage 2 as plain Newton under Adams' rounding-error bound;
- the Stage-1 search: halve while |f| > |f0|; after two helpful halvings, take the rotated half step `alterdirection(dz, 0.5)`; otherwise keep stepping along dz, up to n times, while |f| falls;
- `alterdirection` = multiply by 0.6 + 0.8i (53.13°) times m;
- the r0 cap with rotation, and r0 = 5·(pre-cap length);
- the saddle-point and rounding-domain branches.

The page cites this implementation as "Madsen's method as implemented by Vestermark", not as the 1975 report's equations. Under this decision, r2 finding F3 (the r0 update uses the pre-cap length) matches the reference and is `not a defect`. F1 and F2 are fixed against the reference.

**R2-D — Euler "Modified Euler": switch to the midpoint method.** This follows Mathews. The update is y_{k+1} = y_k + h·f(t_k + h/2, y_k + (h/2)·f(t_k, y_k)). Retitle the case and the GIF "Modified Euler (midpoint)", and fix the Description and numbers. Mathews' printed Example 12 values are the check.

## Work packages and order

The worklist groups the findings into seven packages. The order matters where pages share code or where one page sets the pattern for others.

| WP | Pages | Shape of the work | Pattern-setter (run first) |
|---|---|---|---|
| A — series coefficients | Maclaurin & Taylor, Padé, Laurent | Replace least-squares-fitted Taylor coefficients with exact ones for the 13 Taylor cases (Maclaurin) and the Γ/Y₀ cases 22–27 (Padé, Laurent). Regenerate the affected GIFs, then fix the text findings. | Padé (largest visible damage); its vetted coefficient routine is then reused by the other two |
| B — shared interpolation script | Lagrange, Newton Interpolation | One fixer owns `lagnewt_animations_all.jl`: stable evaluation far from the nodes (the 3 bad frames), node-interval and degree-sequence wording. Copies kept identical, GIFs regenerated in both folders. D3 orphans. | Single fixer for both pages |
| C — quadrature | Trapezoidal, Simpson, Simpson 3/8, Boole, Midpoint, Romberg, Gauss-Legendre, Newton-Cotes, Adaptive Simpson, Riemann Sums, 2D rules, Monte Carlo π (Cubic Spline Quadrature has no findings) | Mostly D1 text corrections. Riemann Sums needs real lower/upper sums (inf/sup). Adaptive Simpson needs its test reconciled with the page. Several label/rounding fixes. | Trapezoidal (sets the D1 wording) |
| D — ODE stability | Euler, Runge-Kutta, ABM, Taylor method, RKF45 | D2 step sizes, regenerate, rewrite Behavior text from the new runs. RKF45 has its own findings (step-size text, hidden curve, y-limits). | Runge-Kutta (sets the D2 pattern) |
| E — root finding | Bisection, Regula Falsi, Newton-Raphson, Secant, Brent, Muller, Halley, Madsen-Reid, Aitken-Steffensen, Accelerated/Modified Newton, Improved Newton, Fixed-Point, Graeffe, Broyden, Nonlinear Systems | Wrong roots and behaviour text, plus real implementation fixes: Muller (complex iterates), Halley (draw the osculating hyperbola), Madsen-Reid (implement the acceleration or rename the page's claims), Fixed-Point (no clamp-and-continue), Graeffe (overflow), Improved Newton and Aitken-Steffensen (factored f near multiple roots), Brent (variant/labels). | Bisection and Newton-Raphson (text-only patterns); Fixed-Point (script pattern) |
| F — interpolation and approximation | Chebyshev, Hermite, Cubic Splines, B-Splines, Bézier, Aitken/Neville, Legendre, Rational, Catenary, Least-Squares Lines and Polynomials (Tangent Parabola has no findings) | Mixed: Chebyshev titles and case 19 interval; Legendre coefficients; Bézier curve/point sync; Rational "minimax" claim and axis; text fixes elsewhere. | none needed |
| G — differentiation | Numerical Differentiation, Derive Formulae, Richardson | Clipped titles and rounding to significant figures; secant-line construction; Case 3 heading. | none needed |

The run order:
1. Pilot: Bisection, Newton-Raphson, Fixed-Point, Trapezoidal, Runge-Kutta and Padé. These cover text-only fixes, script fixes, and the D1, D2 and WP-A patterns.
2. The director reads the pilot results critically before going on.
3. Everything else, in parallel, with the pattern-setters' wording and code handed to the rest of their package.
4. Section-index links (D4).
5. Full-section render.

## Running on another machine

These prompts were written on one machine and will be run on another: the one with the legacy archive. The director checks each of these in its Phase 0 and stops if one fails.

1. **Branch.** Fetch and check out `fix/numerical-methods-animations` from `origin`. It carries the round-1 report, this plan and both commands (`.claude/commands/fix-animations.md`, `.claude/commands/review-animations.md`).
2. **Git LFS.** The GIFs are LFS-tracked. Run `git lfs pull` if the checkout has pointer files instead of GIFs; `file <gif>` should report GIF image data.
3. **Julia.** The global environment must load Plots and SpecialFunctions. The committed GIFs were made with Plots 1.41.2 and SpecialFunctions 2.9.2.
   - The director regenerates a few unchanged scripts in scratch and compares decoded frames with the committed GIFs.
   - Identical frames with different bytes are fine.
   - If the frames differ, it stops and asks before regenerating anything, since every touched GIF would change for reasons unrelated to the fix.
4. **Python for independent checks.** A Python with numpy, scipy, sympy and mpmath is needed. The director finds one, or makes a throwaway virtual environment in scratch.
5. **Quarto** to render the pages. It was 1.8.26 here.
6. **The legacy archive.** It was at `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/` per `.github/agents/animation-page.agent.md`. If it is elsewhere, tell the director the path.

The evidence scripts under `reviews/numerical-methods-animations/evidence/` were run from a scratch folder on the first machine. Their paths need adjusting before they can be re-run.

## Records

Each page gets a fix record at `reviews/numerical-methods-animations/fixes/<slug>.md`. It holds:

- per finding: the outcome (fixed, not reproduced, deferred), what changed, where, and the evidence (command and numbers);
- a ledger of every sentence or number added or changed on the page, with the computation that checks it;
- the scripts changed and the GIFs regenerated, with frames viewed;
- the independent resolution check result.

`fixes/README.md` summarises the run. [worklist.md](worklist.md) has its Status column updated as pages are committed. The round-1 page reports are left unchanged as the baseline.

## Re-review rounds

After the fix run:

1. Run `/review-animations all out=reviews/numerical-methods-animations-r2`.
   - The reviewers are fresh and are not shown round-1 or the fix records, so their read is not anchored on either.
   - With the bisection known errors fixed, the review director calibrates its pilot with a planted error in a scratch copy instead.
2. Feed any confirmed findings back into `/fix-animations` with that round's folder as input.
3. Repeat with `-r3` and later folders until a round has no Error or Misleading findings.
4. Running a second independent review round in parallel with different reviewers is a cheap way to catch what one round misses.
