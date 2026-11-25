# Numerical methods: plan for the pages without animations

Written 2026-11-24, after the nine review rounds of the 53 animation pages were merged into `main`.

## Where things stand

- **58 topic pages** in `pages/numerical-methods/` are still flat `.qmd` files with no animations.
  - **18 have written text**, mostly linear algebra from the `content-page` skill.
  - **40 are skeletons:** a title, a short intro, and "(Planned)" sections for Derivation Notes, Worked Example and Implementation Notes.
- **The Mathews archive** (`/home/jason/Desktop/math-fullerton/baseline/mathews/`) has a module page for 56 of the 58. Logistic Curve has no module page (only its bibliography and proof pages), and Power Series has no module at all.
- **Few legacy animations survive for these pages:**
  - **Survive:** Fibonacci Search and Milne-Simpson have their animated GIFs. Fourier Series has 4 of its 9.
  - **Lost:** Golden Ratio, Quadratic/Cubic, Steepest Descent, Nelder-Mead and Powell link to animation pages, but only the HTML survives, so these must be rebuilt from the worked examples.
  - **Everything else** never had an animation in the archive. Monte Carlo Integration's module links the Midpoint-rule animation by mistake.

## Recommendation

- **41 pages get animations, in 9 batches** of 3–7 pages, grouped so that each batch shares a kind of picture.
  - Batch 1 comes first because it has surviving legacy GIFs to match, which is the case the `animation-page` skill handles best.
  - Batches 2–3 rebuild lost animations from the worked examples.
  - Batches 4–9 are new animations with no legacy original. Each must say so on the page, as Laurent does.
- **17 pages stay text-only**, marked "—" in the table (now "10 (text)" to "13 (text)"; see Follow-on plan). These are direct linear-algebra algorithms (elimination, factorizations, Horner, Householder and similar), where an animation would only redraw a matrix. Three of them are still skeletons and need the `content-page` skill.
- **For a skeleton page, run `content-page` first**, so that the text and worked example exist, and then `animation-page`. Of the 41 animation pages, 37 are skeletons and 4 already have text.

## Before the first batch (done 2026-11-24)

1. **The `animation-page` skill carries the review lessons.** Its Accuracy standard lists the mistakes the nine review rounds found, and requires a build ledger: a recorded computation for every number and behaviour sentence on a page.
   - The old advice to clamp diverging iterates and the `round(x; digits=4)` label template were removed. Both caused findings.
2. **New batches are reviewed with the `review-animations` skill.** It was restored from history and adapted:
   - It takes `batch=<N>`.
   - It writes to a per-batch folder such as `reviews/batch-1`.
   - It forbids MATLAB.

   Fixes go back through `animation-page`, followed by a re-review into `reviews/batch-<N>-r2`, until a round has no Error or Misleading findings. The old `fix-animations` command was tied to the first 53 pages' fix plan, so it was not restored. It is in history at `37a1c08^` if needed.

## Running a batch

Start a fresh session on an up-to-date `main` and run `/run-animation-batch <N>` (or ask to "run batch N"). The `run-animation-batch` skill directs content-page, animation-page and review-animations for the batch on a `batch-<N>` branch, and stops short of merging.

## Status

- **Batch 1 done 2026-11-24** on branch `batch-1`: all four pages have written text and animations. Two independent review rounds (`reviews/batch-1`, `reviews/batch-1-r2`) found no Error or Misleading findings; all Minor findings were fixed and independently checked. See `reviews/batch-1/README.md`.
- **Batch 2 done 2026-11-24** on branch `batch-2`: all three pages have written text and animations. Three independent review rounds (`reviews/batch-2`, `-r2`, `-r3`); round 2 found one Error (a false case (ii) statement carried over from Mathews on the Quadratic search page), round 3 found no Error or Misleading findings, and every finding of every round was fixed and independently checked. See `reviews/batch-2/README.md`.
- **Batch 3 done 2026-11-25** on branch `batch-3`: all three pages have written text and animations. Two independent review rounds (`reviews/batch-3`, `-r2`); round 1 found one Error (iteration counts on the Steepest Descent page that depended on arithmetic precision), round 2 found no Error or Misleading findings, and every finding of both rounds was fixed and independently checked. The three "lost" Mathews animations of this batch turned out to be "Under Construction" pages, so they were probably never made. See `reviews/batch-3/README.md`.
- **Batch 4 done 2026-11-25** on branch `batch-4`: all five pages have written text and animations. One independent review round (`reviews/batch-4`) found no Error or Misleading findings; all nine Minor findings were fixed and independently checked. See `reviews/batch-4/README.md`.
- **Batch 5 done 2026-11-25** on branch `batch-5`: all five pages have written text and animations. Two independent review rounds (`reviews/batch-5`, `-r2`); round 1 found two Errors (Mathews' Example 5 pictures misdescribed on the Spring-Mass page; a misquoted Rössler range on the Lorenz page), round 2 found no Error or Misleading findings, and every finding of both rounds was fixed and independently checked. See `reviews/batch-5/README.md`.
- **Batch 6 done 2026-11-25** on branch `batch-6` (stacked on `batch-5`): all five pages have written text and animations. Two independent review rounds (`reviews/batch-6`, `-r2`); round 1 found one Error (Millikan's drops put in the quadratic-drag regime, as Mathews has it) and one Misleading finding (a Hessian eigenvector on the Logistic page), round 2 found no Error or Misleading findings, and every finding of both rounds was fixed and independently checked. See `reviews/batch-6/README.md`.
- **Batch 7 done 2026-11-25** on branch `batch-7` (stacked on `batch-6`): all three pages have written text and animations. Three independent review rounds (`reviews/batch-7`, `-r2`, `-r3`); round 1 found one Error (a false d'Alembert proviso shared with Mathews' proof), round 2 one Misleading finding (the insulated-edge overshoot on the Elliptic page), round 3 none, and every finding of every round was fixed and independently checked. See `reviews/batch-7/README.md`.
- **Batch 8 done 2026-11-25** on branch `batch-8` (stacked on `batch-7`): all six pages have written text and animations. One independent review round (`reviews/batch-8`) found no Error or Misleading findings; all 13 Minor findings were fixed and independently checked. See `reviews/batch-8/README.md`.
- **Batch 9 done 2026-11-25** on branch `batch-9` (stacked on `batch-8`): all seven pages have written text and animations. Two independent review rounds (`reviews/batch-9`, `-r2`); round 1 found one Error (a step quoted between the wrong frames on the Power Series page) and two Misleading findings (Circle of Curvature, Nonlinear Curve Fitting), round 2 found no Error or Misleading findings, and every finding of both rounds was fixed or shown not reproducible and independently checked. See `reviews/batch-9/README.md`.
- **Batch 10 done 2026-11-25** on branch `batch-10`: the three eigenvalue-support skeletons (Householder Transformations, Hessenberg Factorization, Faddeev-Leverrier Method) are written as flat text-only pages. Three independent review rounds (`reviews/batch-10`, `-r2`, `-r3`); round 1 found one Error (a Corollary hypothesis left to a nearby caution) and five Minor findings, no worked-example number was wrong, round 2 one Misleading finding (an unsupported attribution in the Faddeev-Leverrier floating-point discussion), round 3 none; every finding was fixed and independently checked. See `reviews/batch-10/README.md`.
- **Batch 11 done 2026-11-25** on branch `batch-11` (stacked on `batch-10`): the five elimination and factorization pages reviewed in text-only mode and fixed. Two independent review rounds (`reviews/batch-11`, `-r2`); round 1 found 6 Errors (one the nine lost `\t`s on the Cholesky page) and 5 Misleading findings, round 2 none, and every finding of both rounds was fixed and independently checked. See `reviews/batch-11/README.md`.

The `reviews/` folders were removed after merging. They are still in history: batch 1 at `4bc9c3f^`, batch 2 at `d3cdb0a^`, and batches 3–9 at `c8eefc8^`.

## Follow-on plan (written 2026-11-25)

### What is left (checked against the repository on 2026-11-25)

- **All 41 animation pages are done.** Each one is a folder with an `## Animations` section and 2–8 GIFs, and none has a "(Planned)" section left.
- **The 17 text-only pages are still flat `.qmd` files:**
  - **3 were never written:** Householder Transformations, Hessenberg Factorization and Faddeev-Leverrier Method. Each still has "Animation Focus" and three "(Planned)" sections. All three have Mathews modules (`n2003/HouseholderMod.html`, `HessenbergMod.html`, `FaddeevLeverrierMod.html`).
  - **14 were written on 2026-04-26,** before the Accuracy standard and the claim ledger existed. None of them has been reviewed. Two pages written alongside them (Jacobi and Gauss-Seidel, SOR) needed four errors corrected and a broken `\tag` fixed when batch 8 rewrote them.
  - **Cholesky, Doolittle and Crout Factorizations has broken markup.** `\t` was read as a tab, which turned `\tag{…}` into a tab plus "ag{…}" on lines 42, 47 and 52, and `\tfrac` into a tab plus "frac" on lines 160, 162 and 163. No other page has control characters.
- **One skeleton is outside the original plan, and it is not needed:** `fft-and-trigonometric-polynomials/`. It has "(Planned)" sections and a legacy stub whose `localhost:8000` links are dead on the published site. Its only module is `FourierSeriesMod.html`, titled "The Fast Fourier Transform (FFT)", and the Fourier series page already covers that module in full: all five of Mathews' examples (FFT included), the discrete series, and every animation that can be rebuilt. `TrigPolyMod.html` is an empty placeholder, so there is nothing else to write from. Nothing links to the folder except the section index (line 86 of `pages/numerical-methods/index.qmd`, under Curve Fitting). Batch 14 retires it.

### Decisions (Jason accepted A–E on 2026-11-25)

- **A. Retire the FFT page.** Delete the folder. Point its Curve Fitting index entry at the discrete-series section of `fourier-series/` so that the topic can still be found there. Add a Quarto `aliases` entry to the Fourier series page so that the old published URL redirects. No page in the site uses `aliases` yet, so check that the redirect page renders.
- **B. Review the 14 written text-only pages** and fix what the reviews find (batches 11–13). Cholesky's broken markup is fixed in batch 11.
- **C. Adapt the two skills for text-only pages before batch 10,** on their own branch, as was done before batch 1:
  - `review-animations` accepts flat pages in a batch. For a flat page, the reviewer keeps a claim ledger for the whole page and reports Page-text and Fidelity findings only, and the calibration error is planted in the text.
  - `run-animation-batch` skips Phase 2 for these pages and leaves them flat (so no index changes are needed). It runs Phase 1 only for skeletons. Fixes follow `content-page`'s Accuracy standard instead of `animation-page` step 15. A page counts as done when it has no "(Planned)" section and its last review round found no Error or Misleading findings.
- **D. Add Powell (1964) and Lambert (1991) to `references.bib`** and cite them with keys on Powell's Method and Predictor-Corrector Methods (batch 14). Batch 4 attributed Lambert's order theorem from memory, so check the theorem against the book, or reword it as a standard result, before citing it.
- **E. Rebuild the two lost discrete-series animations** on the Fourier series page (batch 14). These are Mathews' FFT1 and FFT2, for |x−π| and x−π at n = 36, built the same way as Cases 6–8.

Decisions already taken on Jason's behalf, recorded in the batch notes and stated on the pages. Revisit any of these if wanted:

- **Places where the pages follow the mathematics, not Mathews:**
  - Newton search keeps 3 saddle steps instead of Mathews' 5.
  - Nelder-Mead follows exact arithmetic past the step-6 tie.
  - Steepest Descent omits Mathews' unused h < δ exit.
  - Galerkin Example 2 follows the equation in Mathews' notebook rather than the one in his module.
  - Projectile Motion says that Mathews has the Millikan regimes backwards.
  - The d'Alembert proviso is corrected.
  - Matrix Exponential Example 6 follows Mathews' worked solution where it differs from his statement.
- **Set-ups chosen where Mathews' are lost:** Lorenz, van der Pol Examples 2–6, Pendulum Examples 4–6, Finite Difference Example 3, Elliptic Examples 2 and 6, Projectile Example 7's launch speeds, Nelder-Mead's Rosenbrock triangle, and the Example 2 data of Nonlinear Curve Fitting.
- **Small choices:**
  - Monte Carlo Example 14 keeps its figures from the continued random stream.
  - Fibonacci Case 3 explains the overlapping points in a note rather than being re-zoomed.
  - Newton Case 1 titles use `%.4g`.
  - Two GIFs are over the 3 MB target: `gradientcc.gif` (3.2 MB) and `nelderbb.gif` (3.1 MB).
- **Housekeeping:** the section index status note (line 11, "60–80% done") is out of date.

### Remaining batches

Batches 10–13 are text-only (no animations). Each of their pages is handled by `content-page`, either to write it or to fix review findings, and reviewed with `review-animations` as adapted under C. Batch 14 uses the existing skills, so it can run before C is done.

| Batch | Pages | Skill and first step |
|---|---|---|
| 10 | Householder Transformations, Hessenberg Factorization, Faddeev-Leverrier Method (eigenvalue support; link to the QR method page's Householder-then-QR animation rather than repeat it) | `content-page` writes each page (Phase 1), then review |
| 11 | Triangular Systems and Back Substitution, Gauss-Jordan Elimination and Pivoting, LU Factorization, Cholesky Doolittle and Crout Factorizations, Pivoting Methods (elimination and factorization) | review first; fix with `content-page` |
| 12 | Inverse Matrix, Tri-Diagonal Matrices, Row Reduced Echelon Form, Homogeneous Linear Systems, Iterative Refinement (structure of linear systems) | review first; fix with `content-page` |
| 13 | Kirchoff's Law, Leontief Model, Horner's Method, Conic Fit (applications and polynomials) | review first; fix with `content-page` |
| 14 | Fourier series and loose ends: retire FFT and Trigonometric Polynomials (A); Fourier series gets the FFT1 and FFT2 rebuilds (E); Powell's Method and Predictor-Corrector Methods get the bibliography keys (D) | `animation-page` for the two Fourier cases and their page text; the director makes the index, alias and folder changes; `review-animations` reviews Fourier series in full; the two citation edits get an independent check (Phase 4 style) instead of a full re-review |

### How to run them

1. Make the two skill changes (C) on their own branch and merge them.
2. For each batch, start a fresh session on an up-to-date `main` and run `/run-animation-batch <N>`. Name batch 14 by number, because `next` treats Fourier series as done already. Each run works on a `batch-<N>` branch, reviews into `reviews/batch-<N>`, `-r2` and so on until a round has no Error or Misleading findings, and stops before merging. Batches 10–13 touch disjoint files and do not change the index, so they can be stacked, as batches 3–9 were. Batch 14 changes the index and the Fourier series page, so run it on its own.
3. After the last batch, render the whole section (`quarto render pages/numerical-methods/`), mark the pages done here, and update the index status note.

## Batches

| Batch | Theme |
|---|---|
| 1 | Surviving legacy animations, plus Monte Carlo Integration (random points, like Monte Carlo Pi) |
| 2 | One-dimensional searches: bracket or iterate shrinking toward the minimum |
| 3 | Multi-dimensional searches: path of iterates or simplex on a contour plot |
| 4 | ODE solution methods: successive approximations, shooting trajectories, grid refinement |
| 5 | Dynamical-systems models: trajectories and phase portraits |
| 6 | Applied ODE models: solution curves as a parameter or time advances |
| 7 | PDEs: time stepping and iteration toward the steady state |
| 8 | Eigenvalue and iterative linear-system methods: vectors or residuals converging |
| 9 | Series solutions and the remaining geometric or optimization pages |
| 10 | Text-only: write the three eigenvalue-support skeletons (see Follow-on plan) |
| 11 | Text-only: review elimination and factorization pages |
| 12 | Text-only: review structure-of-linear-systems pages |
| 13 | Text-only: review applications and polynomial pages |
| 14 | Fourier series and loose ends: retire the FFT page, rebuild FFT1 and FFT2, add the bibliography keys |

## Every page

"Archive examples" counts the module's worked-example links, and "Archive graphs" counts the graph-sized images in those examples (height ≥ 100 px). Both measure how much there is to rebuild from. Legacy GIF paths are relative to `a2001/Animations/`.

| Batch | Page | Page text | Legacy animation | Archive examples | Archive graphs |
|---|---|---|---|---|---|
| 1 | [Fibonacci Search](../pages/numerical-methods/fibonacci-search/) | written; **done (batch 1):** 3 animations (rebuild of Mathews' n = 32 animation, his Example 2 tolerance, new Example 1) | survives: `Optimization/Fibonacci1/Fibonacciaa.gif` (39 frames) | 4 | 17 |
| 1 | [Milne-Simpson's Method](../pages/numerical-methods/milne-simpsons-method/) | written; **done (batch 1):** 2 animations (rebuild of Mathews' m-sweep for y' = 1 − t∛y, new weak-stability error plot) | survives: `OrdinaryDE/Milne1/Milneaa.gif` (38 frames) | 12 | 40 |
| 1 | [Fourier series](../pages/numerical-methods/fourier-series/) | written; **done (batch 1):** 8 animations (rebuilds of all 5 Fourier-series cases and the 3 surviving discrete ones; the module links 10 animations, not 9; the 2 lost discrete ones are not rebuilt; **batch 14** rebuilds them) | 4 of 9 survive: `FourierFFT{cc,dd,ee}.gif`, `FourierSeriesee.gif` | 6 | 30 |
| 1 | [Monte Carlo Integration](../pages/numerical-methods/monte-carlo-integration/) | written; **done (batch 1):** 2 new animations (Example 3 running estimate, Example 14 Monte Carlo vs midpoint rule in 5-D) | none (module links the Midpoint animation by mistake) | 15 | 111 |
| 2 | [Golden Ratio Search](../pages/numerical-methods/golden-ratio-search/) | written; **done (batch 2):** 3 animations (rebuild of Mathews' lost Example 6 animation from his plotting program, new Example 1, new non-unimodal run of Example 2's function on [−1, 1]) | lost (portal HTML only: `Optimization/GoldenRatio1/GoldenRatioaa.html`; module `n2003/GoldenRatioSearchMod.html`) | 7 | 38 |
| 2 | [Quadratic Interpolative Search](../pages/numerical-methods/quadratic-interpolative-search/) | written (quadratic and cubic search, as the module); **done (batch 2):** 2 animations (rebuilds of Mathews' lost Quadratic (Example 3) and Cubic (Example 4) animations) | lost (Quadratic and Cubic portals, HTML only: `Optimization/Quadratic1/Quadraticaa.html`, `Optimization/Cubic1/Cubicaa.html`; module `n2003/QuadraticSearchMod.html`) | 5 | 44 |
| 2 | [Newton's Search Method](../pages/numerical-methods/newtons-search-method/) | written (the module is two-variable Newton search); **done (batch 2):** 3 new animations on contour maps (Example 5 minima and saddles, Example 6 convergence vs divergence, Example 4 Rosenbrock) | none (module `n2003/NewtonSearchMod.html`) | 7 | 55 |
| 3 | [Steepest Descent - Gradient Search](../pages/numerical-methods/steepest-descent-gradient-search/) | written; **done (batch 3):** 4 new animations (Examples 1–4 with Mathews' own line search, three panels: path, zoom, φ_k with the parabola fit) | probably never made: `Optimization/Gradient1/Gradientaa.html` shows only the archive's "Under Construction" banner and no GIF; module `n2003/GradientSearchMod.html` | 7 | 61 |
| 3 | [Nelder Mead Method](../pages/numerical-methods/nelder-mead-method/) | written; **done (batch 3):** 3 animations (Mathews' 16 static Example 4 pictures animated on the exact-arithmetic path, new Rosenbrock run, new Exercise 3 runs) | probably never made: `Optimization/Nelder1/Nelderaa.html` shows only the "Under Construction" banner and no GIF; module `n2003/NelderMeadMod.html` | 5 | 33 |
| 3 | [Powell's Method](../pages/numerical-methods/powells-method/) | written; **done (batch 3):** 3 animations (rebuilds of Animations 1 and 2 from Mathews' surviving Example 7 and 8 plotting programs, new Rosenbrock run) | probably never made: `Optimization/Powell1/Powellaa.html` and `Powellbb.html` show only the "Under Construction" banner and no GIF; module `n2003/PowellMethodMod.html` | 9 | 62 |
| 4 | [Predictor-Corrector Methods](../pages/numerical-methods/predictor-corrector-methods/) | written (from standard sources; the module was never written); **done (batch 4):** 3 new animations (PECE steps, corrector iterates, error vs number of corrections, all for y' = 1 + y² with AB2 + trapezoid) | none (module `n2003/PredictCorrectMod.html` is an "under construction" placeholder; only `PredictCorrectBib.html` exists) | 1 | 0 |
| 4 | [Picard Iteration](../pages/numerical-methods/picard-iteration/) | written (12 examples); **done (batch 4):** 4 new animations (Examples 3, 4, 7, 11 in Mathews' windows, with a log error panel) | none (module `n2003/PicardIterationMod.html`, 12 examples; notebook `picarditeration/PicardIterationMod.nb`) | 15 | 116 |
| 4 | [Shooting Methods for ODE's](../pages/numerical-methods/shooting-methods-for-odes/) | written (6 examples); **done (batch 4):** 3 new animations (the shots and the landing line, m-refinement, failure as b → 1 + π) | none (module `n2003/ShootingMod.html`) | 7 | 14 |
| 4 | [Finite Difference Method for ODE's](../pages/numerical-methods/finite-difference-method-for-odes/) | written (6 examples); **done (batch 4):** 3 new animations (grid refinement, Richardson extrapolation, orders of convergence) | none (module `n2003/FiniteDifferenceMod.html`) | 7 | 11 |
| 4 | [Galerkin's Method](../pages/numerical-methods/galerkins-method/) | written (all examples); **done (batch 4):** 3 new animations (Example 2 as n grows with the condition number, Example 3(b)'s two bases, Example 4(b)'s sine coefficients) | none (module `n2003/GalerkinMod.html`) | 9 | 121 |
| 5 | [Lorenz Attractor](../pages/numerical-methods/lorenz-attractor/) | written (all examples, with the Rössler attractors); **done (batch 5):** 3 new animations (RK4 against an order-30 Taylor reference, two true solutions 10⁻¹⁰ apart, the two Rössler attractors) | none (module `n2003/LorenzAttractorMod.html`) | 7 | 74 |
| 5 | [Lotka-Volterra Model](../pages/numerical-methods/lotka-volterra-model/) | written (all 7 examples); **done (batch 5):** 3 new animations (Example 2 forward and backward, five orbits with their phase lag, Example 6 foxes and rabbits) | none (module `n2003/Lotka-VolterraMod.html`) | 7 | 32 |
| 5 | [van der Pol System](../pages/numerical-methods/van-der-pol-system/) | written (all 6 examples); **done (batch 5):** 3 new animations (μ = 0 against the exact circle, μ = 1/16 to 1 from outside and inside, the μ = 4 relaxation oscillation) | none (module `n2003/VanDerPolMod.html`) | 7 | 30 |
| 5 | [Pendulum](../pages/numerical-methods/pendulum/) | written (all 8 examples); **done (batch 5):** 3 new animations (linear against nonlinear pendulum, Example 6 loops and rotations, Example 7's fourteen damped curves) | none (module `n2003/PendulumMod.html`) | 8 | 86 |
| 5 | [Spring-Mass Systems](../pages/numerical-methods/spring-mass-systems/) | written (all 10 examples; corrects Mathews' Example 5 first frequency); **done (batch 5):** 2 new animations (Example 6 two walls, Example 5 one wall, with their normal modes) | none (module `n2003/SpringMassMod.html`) | 11 | 225 |
| 6 | [Projectile Motion](../pages/numerical-methods/projectile-motion/) | written (all examples; Example 7 launch speeds reconstructed); **done (batch 6):** 3 new animations (the four drag laws, Example 3's one-formula solution, five baseballs aimed at 506.5 ft) | none (module `n2003/ProjectileMotionMod.html`) | 9 | 71 |
| 6 | [Compartment Model](../pages/numerical-methods/compartment-model/) | written (all examples, exact solutions); **done (batch 6):** 3 new animations (Mathews' Examples 1–3) | none (module `n2003/CompartmentModelMod.html`) | 4 | 48 |
| 6 | [Harvesting Model](../pages/numerical-methods/harvesting-model/) | written (all 20 examples); **done (batch 6):** 4 animations (Mathews' three cases, Examples 8, 15, 19, and a new harvest-rate sweep) | none (module `n2003/HarvestingModelMod.html`) | 20 | 77 |
| 6 | [Logistic Curve](../pages/numerical-methods/logistic-curve/) | written (from the Web module; Example 5 true least squares new); **done (batch 6):** 3 new animations (linearization as L varies, Gauss–Newton, solutions of the fitted equation) | none (module `n2003/Web/LogisticEquationMod/LogisticEquationMod.html`, "Module for Logistic Curve Fitting", 4 examples; the top level has only the Bib and Proof pages) | 0 | 0 |
| 6 | [Earthquake Model](../pages/numerical-methods/earthquake-model/) | written (all examples); **done (batch 6):** 4 new animations (swaying at ω = 2.1, frequency sweep, amplitude against period, the six modes) | none (module `n2003/EarthquakeModelMod.html`) | 4 | 9 |
| 7 | [Crank-Nicolson Method](../pages/numerical-methods/crank-nicolson-method/) | written (all examples); **done (batch 7):** 4 new animations (forward differences at r = 0.5 and 0.875, Crank-Nicolson at r = 1 and 2, a sawtooth at r = 2) | none (module `n2003/CrankNicolsonMod.html`) | 5 | 17 |
| 7 | [Finite Difference Method](../pages/numerical-methods/finite-difference-method/) | written (the wave equation; corrects the d'Alembert proviso); **done (batch 7):** 3 new animations (Example 1's second row, the plucked string against d'Alembert, the growing sawtooth at r = 1.02) | none (module `n2003/FiniteDifferencePDEMod.html`) | 4 | 15 |
| 7 | [Elliptic PDE's](../pages/numerical-methods/elliptic-pdes/) | written (all 6 examples); **done (batch 7):** 4 new animations (SOR on 9 × 9, the insulated edge, SOR against Gauss-Seidel on 21 × 21, the error against Laplace's equation) | none (module `n2003/EllipticPDEMod.html`) | 7 | 25 |
| 8 | [Power method](../pages/numerical-methods/power-method/) | written (all examples); **done (batch 8):** 4 new animations (Examples 1 and 2, shifted-inverse against power, the Markov chains) | none (module `n2003/PowerMethodMod.html`) | 6 | 23 |
| 8 | [Jacobi method](../pages/numerical-methods/jacobi-method/) | written (all examples); **done (batch 8):** 4 animations (classical and cyclic Jacobi, a rebuild of Mathews' eigenvalue movie, the movie's matrix to 10⁻¹¹) | none as a GIF, but the module shows Mathews' "eigenvalue movie" as still frames (module `n2003/JacobiMethodMod.html`) | 7 | 30 |
| 8 | [QR method](../pages/numerical-methods/qr-method/) | written (all examples); **done (batch 8):** 3 new animations (unshifted QR, Householder then QR, shifts and deflation) | none (module `n2003/QRMethodMod.html`) | 9 | 36 |
| 8 | [Eigenvalues and Eigenvectors](../pages/numerical-methods/eigenvalues-and-eigenvectors/) | written (all examples, plus a section on the powers AʲX₀); **done (batch 8):** 4 new animations (invariant directions, scaled powers, Newton on p(λ), rounded polynomial roots) | none (module `n2003/EigenvaluesMod.html`) | 13 | 173 |
| 8 | [Jacobi and Gauss-Seidel Iteration](../pages/numerical-methods/jacobi-and-gauss-seidel-iteration/) | written (four errors in the old text corrected); **done (batch 8):** 3 new animations (the two methods in the plane, Example 6, Examples 2 and 4 reordered) | none (module `n2003/GaussSeidelMod.html`) | 8 | 6 |
| 8 | [Successive Over Relaxation - SOR](../pages/numerical-methods/successive-over-relaxation-sor/) | written (old ω mix and broken \tag corrected); **done (batch 8):** 3 new animations (three methods on Example 1, the ω sweep, Laplace's equation on 5 × 5) | none (module `n2003/SORmethodMod.html`) | 4 | 41 |
| 9 | [Frobenius Series Solution](../pages/numerical-methods/frobenius-series-solution/) | written (10 examples); **done (batch 9):** 3 new animations (both Frobenius solutions, the rim condition J₀(λ) = 0, the drum's normal modes) | none (module `n2003/FrobeniusSeriesMod.html`) | 12 | 175 |
| 9 | [Power Series](../pages/numerical-methods/power-series/) | written (from standard sources; no module); **done (batch 9):** 3 new animations (Airy, Legendre with p = 1, a series about 0 and about 1) | none; no archive module | 0 | 0 |
| 9 | [Circle of Curvature](../pages/numerical-methods/circle-of-curvature/) | written (broken \tag fixed); **done (batch 9):** 3 animations (a rebuild of Mathews' collocation circles, the osculating circle on y = x² and on the cardioid) | none as a GIF, but the module shows Mathews' collocation-circle animation as 19 still frames (module `n2003/CurvatureMod.html`) | 13 | 104 |
| 9 | [Linear Programming-Simplex Method](../pages/numerical-methods/linear-programming-simplex-method/) | written; **done (batch 9):** 4 new animations (the level line, the simplex path, two objectives, Example 5 in three variables) | none (module `n2003/LinearProgrammingMod.html`) | 11 | 167 |
| 9 | [Nonlinear Curve Fitting](../pages/numerical-methods/nonlinear-curve-fitting/) | written (from the Web module; Example 2 data reconstructed); **done (batch 9):** 3 new animations (exponential and power linearization, Gauss–Newton) | none (module `n2003/Web/NonLinearCurveFitMod/NonLinearCurveFitMod.html`, 3 examples; the top-level `NonLinearCurveMod.html` is a placeholder) | 1 | 0 |
| 9 | [Matrix Exponential](../pages/numerical-methods/matrix-exponential/) | written (all examples); **done (batch 9):** 4 new animations (partial sums, Mathews' solution families of Examples 3–5) | none (module `n2003/MatrixExponentialMod.html`) | 11 | 85 |
| 9 | [Painleve Property](../pages/numerical-methods/painleve-property/) | written (all examples); **done (batch 9):** 3 new animations (a pole on a grid point, two poles of y' = 1 + y², a Riccati equation) | none (module `n2003/PainlevePropertyMod.html`) | 14 | 76 |
| 11 (text) | [Triangular Systems and Back Substitution](../pages/numerical-methods/triangular-systems-and-back-substitution.qmd) | written; **done (batch 11):** reviewed and fixed, two review rounds | none (`backsubstitutionmod.html`) | 0 | 0 |
| 11 (text) | [Gauss-Jordan Elimination and Pivoting](../pages/numerical-methods/gauss-jordan-elimination-and-pivoting.qmd) | written; **done (batch 11):** reviewed and fixed, two review rounds | none | 7 | 15 |
| 11 (text) | [LU Factorization](../pages/numerical-methods/lu-factorization.qmd) | written; **done (batch 11):** reviewed and fixed, two review rounds | none | 9 | 22 |
| 11 (text) | [Cholesky, Doolittle and Crout Factorizations](../pages/numerical-methods/cholesky-doolittle-and-crout-factorizations.qmd) | written; **done (batch 11):** reviewed and fixed, two review rounds | none | 9 | 65 |
| 12 (text) | [Inverse Matrix](../pages/numerical-methods/inverse-matrix.qmd) | written | none | 7 | 36 |
| 12 (text) | [Tri-Diagonal Matrices](../pages/numerical-methods/tri-diagonal-matrices.qmd) | written | none | 9 | 21 |
| 11 (text) | [Pivoting Methods](../pages/numerical-methods/pivoting-methods.qmd) | written; **done (batch 11):** reviewed and fixed, two review rounds | none | 10 | 110 |
| 12 (text) | [Row Reduced Echelon Form](../pages/numerical-methods/row-reduced-echelon-form.qmd) | written | none | 6 | 32 |
| 12 (text) | [Homogeneous Linear Systems](../pages/numerical-methods/homogeneous-linear-systems.qmd) | written | none | 6 | 33 |
| 13 (text) | [Kirchoff's Law](../pages/numerical-methods/kirchoffs-law.qmd) | written | none | 7 | 24 |
| 13 (text) | [Leontief Model](../pages/numerical-methods/leontief-model.qmd) | written | none | 5 | 44 |
| 12 (text) | [Iterative Refinement](../pages/numerical-methods/iterative-refinement.qmd) | written | none | 11 | 141 |
| 13 (text) | [Horner's Method](../pages/numerical-methods/horners-method.qmd) | written | none | 10 | 46 |
| 13 (text) | [Conic Fit](../pages/numerical-methods/conic-fit.qmd) | written | none | 13 | 30 |
| 10 (text) | [Householder Transformations](../pages/numerical-methods/householder-transformations.qmd) | written (all 5 of Mathews' cases; links the QR page's Householder-then-QR animation); **done (batch 10):** text-only, three review rounds | none | 6 | 64 |
| 10 (text) | [Hessenberg Factorization](../pages/numerical-methods/hessenberg-factorization.qmd) | written (all 9 examples, exact similarity checks); **done (batch 10):** text-only, three review rounds | none | 10 | 50 |
| 10 (text) | [Faddeev-Leverrier Method](../pages/numerical-methods/faddeev-leverrier-method.qmd) | written (all 3 examples exact, floating-point experiment); **done (batch 10):** text-only, three review rounds | none | 4 | 20 |
| 14 | [FFT and Trigonometric Polynomials](../pages/numerical-methods/fft-and-trigonometric-polynomials/) | skeleton, outside the original plan; **to be retired (batch 14)**: the Fourier series page covers its module | none of its own; same module as Fourier series (`n2003/FourierSeriesMod.html`) | (Fourier series) | (Fourier series) |
