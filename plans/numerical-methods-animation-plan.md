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
- **17 pages stay text-only**, marked "—" in the table. These are direct linear-algebra algorithms (elimination, factorizations, Horner, Householder and similar), where an animation would only redraw a matrix. Three of them are still skeletons and need the `content-page` skill.
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

## Every page

"Archive examples" counts the module's worked-example links, and "Archive graphs" counts the graph-sized images in those examples (height ≥ 100 px). Both measure how much there is to rebuild from. Legacy GIF paths are relative to `a2001/Animations/`.

| Batch | Page | Page text | Legacy animation | Archive examples | Archive graphs |
|---|---|---|---|---|---|
| 1 | [Fibonacci Search](../pages/numerical-methods/fibonacci-search/) | written; **done (batch 1):** 3 animations (rebuild of Mathews' n = 32 animation, his Example 2 tolerance, new Example 1) | survives: `Optimization/Fibonacci1/Fibonacciaa.gif` (39 frames) | 4 | 17 |
| 1 | [Milne-Simpson's Method](../pages/numerical-methods/milne-simpsons-method/) | written; **done (batch 1):** 2 animations (rebuild of Mathews' m-sweep for y' = 1 − t∛y, new weak-stability error plot) | survives: `OrdinaryDE/Milne1/Milneaa.gif` (38 frames) | 12 | 40 |
| 1 | [Fourier series](../pages/numerical-methods/fourier-series/) | written; **done (batch 1):** 8 animations (rebuilds of all 5 Fourier-series cases and the 3 surviving discrete ones; the module links 10 animations, not 9; the 2 lost discrete ones are not rebuilt) | 4 of 9 survive: `FourierFFT{cc,dd,ee}.gif`, `FourierSeriesee.gif` | 6 | 30 |
| 1 | [Monte Carlo Integration](../pages/numerical-methods/monte-carlo-integration/) | written; **done (batch 1):** 2 new animations (Example 3 running estimate, Example 14 Monte Carlo vs midpoint rule in 5-D) | none (module links the Midpoint animation by mistake) | 15 | 111 |
| 2 | [Golden Ratio Search](../pages/numerical-methods/golden-ratio-search/) | written; **done (batch 2):** 3 animations (rebuild of Mathews' lost Example 6 animation from his plotting program, new Example 1, new non-unimodal run of Example 2's function on [−1, 1]) | lost (portal HTML only: `Optimization/GoldenRatio1/GoldenRatioaa.html`; module `n2003/GoldenRatioSearchMod.html`) | 7 | 38 |
| 2 | [Quadratic Interpolative Search](../pages/numerical-methods/quadratic-interpolative-search/) | written (quadratic and cubic search, as the module); **done (batch 2):** 2 animations (rebuilds of Mathews' lost Quadratic (Example 3) and Cubic (Example 4) animations) | lost (Quadratic and Cubic portals, HTML only: `Optimization/Quadratic1/Quadraticaa.html`, `Optimization/Cubic1/Cubicaa.html`; module `n2003/QuadraticSearchMod.html`) | 5 | 44 |
| 2 | [Newton's Search Method](../pages/numerical-methods/newtons-search-method/) | written (the module is two-variable Newton search); **done (batch 2):** 3 new animations on contour maps (Example 5 minima and saddles, Example 6 convergence vs divergence, Example 4 Rosenbrock) | none (module `n2003/NewtonSearchMod.html`) | 7 | 55 |
| 3 | [Steepest Descent - Gradient Search](../pages/numerical-methods/steepest-descent-gradient-search.qmd) | skeleton | lost (portal HTML only) | 7 | 61 |
| 3 | [Nelder Mead Method](../pages/numerical-methods/nelder-mead-method.qmd) | skeleton | lost (portal HTML only) | 5 | 33 |
| 3 | [Powell's Method](../pages/numerical-methods/powells-method.qmd) | skeleton | lost (two items, HTML only) | 9 | 62 |
| 4 | [Predictor-Corrector Methods](../pages/numerical-methods/predictor-corrector-methods.qmd) | skeleton | none | 1 | 0 |
| 4 | [Picard Iteration](../pages/numerical-methods/picard-iteration.qmd) | skeleton | none | 15 | 116 |
| 4 | [Shooting Methods for ODE's](../pages/numerical-methods/shooting-methods-for-odes.qmd) | skeleton | none | 7 | 14 |
| 4 | [Finite Difference Method for ODE's](../pages/numerical-methods/finite-difference-method-for-odes.qmd) | skeleton | none | 7 | 11 |
| 4 | [Galerkin's Method](../pages/numerical-methods/galerkins-method.qmd) | skeleton | none | 9 | 121 |
| 5 | [Lorenz Attractor](../pages/numerical-methods/lorenz-attractor.qmd) | skeleton | none | 7 | 74 |
| 5 | [Lotka-Volterra Model](../pages/numerical-methods/lotka-volterra-model.qmd) | skeleton | none | 7 | 32 |
| 5 | [van der Pol System](../pages/numerical-methods/van-der-pol-system.qmd) | skeleton | none | 7 | 30 |
| 5 | [Pendulum](../pages/numerical-methods/pendulum.qmd) | skeleton | none | 8 | 86 |
| 5 | [Spring-Mass Systems](../pages/numerical-methods/spring-mass-systems.qmd) | skeleton | none | 11 | 225 |
| 6 | [Projectile Motion](../pages/numerical-methods/projectile-motion.qmd) | skeleton | none | 9 | 71 |
| 6 | [Compartment Model](../pages/numerical-methods/compartment-model.qmd) | skeleton | none | 4 | 48 |
| 6 | [Harvesting Model](../pages/numerical-methods/harvesting-model.qmd) | skeleton | none | 20 | 77 |
| 6 | [Logistic Curve](../pages/numerical-methods/logistic-curve.qmd) | skeleton | none; archive has no module page (Bib and Proof only) | 0 | 0 |
| 6 | [Earthquake Model](../pages/numerical-methods/earthquake-model.qmd) | skeleton | none | 4 | 9 |
| 7 | [Crank-Nicolson Method](../pages/numerical-methods/crank-nicolson-method.qmd) | skeleton | none | 5 | 17 |
| 7 | [Finite Difference Method](../pages/numerical-methods/finite-difference-method.qmd) | skeleton | none | 4 | 15 |
| 7 | [Elliptic PDE's](../pages/numerical-methods/elliptic-pdes.qmd) | skeleton | none | 7 | 25 |
| 8 | [Power method](../pages/numerical-methods/power-method.qmd) | skeleton | none | 6 | 23 |
| 8 | [Jacobi method](../pages/numerical-methods/jacobi-method.qmd) | skeleton | none | 7 | 30 |
| 8 | [QR method](../pages/numerical-methods/qr-method.qmd) | skeleton | none | 9 | 36 |
| 8 | [Eigenvalues and Eigenvectors](../pages/numerical-methods/eigenvalues-and-eigenvectors.qmd) | skeleton | none | 13 | 173 |
| 8 | [Jacobi and Gauss-Seidel Iteration](../pages/numerical-methods/jacobi-and-gauss-seidel-iteration.qmd) | written | none | 8 | 6 |
| 8 | [Successive Over Relaxation - SOR](../pages/numerical-methods/successive-over-relaxation-sor.qmd) | written | none | 4 | 41 |
| 9 | [Frobenius Series Solution](../pages/numerical-methods/frobenius-series-solution.qmd) | skeleton | none | 12 | 175 |
| 9 | [Power Series](../pages/numerical-methods/power-series.qmd) | skeleton | none; no archive module | 0 | 0 |
| 9 | [Circle of Curvature](../pages/numerical-methods/circle-of-curvature.qmd) | written | none | 13 | 104 |
| 9 | [Linear Programming-Simplex Method](../pages/numerical-methods/linear-programming-simplex-method.qmd) | written | none | 11 | 167 |
| 9 | [Nonlinear Curve Fitting](../pages/numerical-methods/nonlinear-curve-fitting.qmd) | skeleton | none | 1 | 0 |
| 9 | [Matrix Exponential](../pages/numerical-methods/matrix-exponential.qmd) | skeleton | none | 11 | 85 |
| 9 | [Painleve Property](../pages/numerical-methods/painleve-property.qmd) | skeleton | none | 14 | 76 |
| — | [Triangular Systems and Back Substitution](../pages/numerical-methods/triangular-systems-and-back-substitution.qmd) | written | none (`backsubstitutionmod.html`) | 0 | 0 |
| — | [Gauss-Jordan Elimination and Pivoting](../pages/numerical-methods/gauss-jordan-elimination-and-pivoting.qmd) | written | none | 7 | 15 |
| — | [LU Factorization](../pages/numerical-methods/lu-factorization.qmd) | written | none | 9 | 22 |
| — | [Cholesky, Doolittle and Crout Factorizations](../pages/numerical-methods/cholesky-doolittle-and-crout-factorizations.qmd) | written | none | 9 | 65 |
| — | [Inverse Matrix](../pages/numerical-methods/inverse-matrix.qmd) | written | none | 7 | 36 |
| — | [Tri-Diagonal Matrices](../pages/numerical-methods/tri-diagonal-matrices.qmd) | written | none | 9 | 21 |
| — | [Pivoting Methods](../pages/numerical-methods/pivoting-methods.qmd) | written | none | 10 | 110 |
| — | [Row Reduced Echelon Form](../pages/numerical-methods/row-reduced-echelon-form.qmd) | written | none | 6 | 32 |
| — | [Homogeneous Linear Systems](../pages/numerical-methods/homogeneous-linear-systems.qmd) | written | none | 6 | 33 |
| — | [Kirchoff's Law](../pages/numerical-methods/kirchoffs-law.qmd) | written | none | 7 | 24 |
| — | [Leontief Model](../pages/numerical-methods/leontief-model.qmd) | written | none | 5 | 44 |
| — | [Iterative Refinement](../pages/numerical-methods/iterative-refinement.qmd) | written | none | 11 | 141 |
| — | [Horner's Method](../pages/numerical-methods/horners-method.qmd) | written | none | 10 | 46 |
| — | [Conic Fit](../pages/numerical-methods/conic-fit.qmd) | written | none | 13 | 30 |
| — | [Householder Transformations](../pages/numerical-methods/householder-transformations.qmd) | skeleton | none | 6 | 64 |
| — | [Hessenberg Factorization](../pages/numerical-methods/hessenberg-factorization.qmd) | skeleton | none | 10 | 50 |
| — | [Faddeev-Leverrier Method](../pages/numerical-methods/faddeev-leverrier-method.qmd) | skeleton | none | 4 | 20 |
