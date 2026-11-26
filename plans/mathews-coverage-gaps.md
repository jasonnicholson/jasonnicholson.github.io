# Mathews archive: coverage gaps

Written 2026-11-25, after batches 1–14 of `numerical-methods-animation-plan.md` were merged. This file reports what the archive has that the site does not. No page has been written or changed.

## Summary

- **Topics.** Mathews' module index (`n2003/NumericalUndergradMod.html`) has 114 entries. The site covers all of them except Lin-Bairstow and the five entries of the "Calculus and Fundamentals" section. Three topics with real content have no page: **Lin-Bairstow Method**, **Heun's Method** and **Big "O" Truncation Error**. A fourth, **Calculus Review**, is a placeholder in the index, but its content survives as two Web modules.
- **Legacy animations.** Every surviving animation in `a2001/Animations` has been rebuilt except five: **Heun's method** (no page to put it on) and **four of the six numerical-differentiation animations** (forward and backward differences).
- **Depth.** This is the largest gap. The **53 pages built before batch 1** are animation-first: 250–2,100 words, with a Description and Animations but almost none of the module's theorems or worked examples. The 41 pages built in batches 1–9 run to 4,000–9,000 words and work every example. Simpson's rule, for example, has 283 words on the site, and Mathews' module has 11 examples.
- **Other subjects.** `c2003` is a whole complex-analysis course (92 modules in 12 chapters). `calculus` and `complex` hold nothing new. None of this is in scope until Jason decides.

## How this was checked

- **Index.** Mathews' module index (`n2003/NumericalUndergradMod.html`) has the same sections and order as the site's index (`pages/numerical-methods/index.qmd`). The two lists were compared entry by entry.
- **Modules not in the index.** Every top-level `n2003/*Mod.html` was compared with the index. So were the 126 topic folders and the 139 `*Bib.html` pages. Placeholders were found by their size (about 2 KB) and their template text ("Research Experience for Undergraduates").
- **Animations.** Every animation portal in `a2001/Animations/Animations*.html` was listed. Its GIFs were matched to site pages by file name, and where pages do not name the legacy file, by topic and GIF count. They were not compared frame by frame.
- **Depth.** For each page: its prose word count (code blocks left out), its GIF count, and the number of distinct "Example N" references. These were set against the number of examples in the module's text.

## 1. Topics with no page

| Topic | Archive | Legacy animation | Notes |
|---|---|---|---|
| **Lin-Bairstow Method** | `BairstowMethodMod.html` (36 KB, in the index under Nonlinear Equations, after Horner's Method); folder `bairstowmethod/` with 5 example pages and 165 images | none | Quadratic synthetic division, then Newton's method on the remainder coefficients (r, s) to find quadratic factors. Complete text and images. It fits as a text-only page next to Horner's Method, or as an animation of the quadratic factor's roots converging. |
| **Heun's Method** | `Heun'sMethodMod.html` (18 KB, **not** in the index); folder `heunsmethod/` with 12 example pages, a proof PDF and **no images** | **survives:** `OrdinaryDE/Heun1/Heunaa.gif`, 36 frames, the same m-sweep for y′ = 1 − t∛y as Euler and modified Euler, ending at m = 150, y(5) = 0.0081236 | Every equation in the module was an image, and none survived, so the text has gaps ("global precision of order ."). The page must be written from standard sources and checked against the GIF. The site mentions Heun only as the starting step on Predictor-Corrector Methods. |
| **Big "O" Truncation Error** | `BigOMod.html` (32 KB, index section "Calculus and Fundamentals"); folder `bigoh/` with 9 example pages, 176 images and a proof PDF | none | Big-O for functions and sequences, order of approximation, how errors combine. The site has no "Calculus and Fundamentals" section. |
| **Calculus Review** (optional) | Index entry `CalculusMod.html` is a placeholder, but `n2003/Web/Calculus1Mod/` (51 KB) and `Calculus2Mod/` (63 KB) hold "Calculus Fundamentals I and II": limits, continuity, the intermediate and mean value theorems, Riemann sums and Taylor's theorem | none of its own (it links the Riemann-sum animations) | Background rather than a numerical method, but it is in Mathews' index. |

## 2. Placeholders and bibliography-only topics (nothing to write from)

- **Empty module placeholders:**
  - `TrigPolyMod.html`, decided already.
  - `PredictCorrectMod.html`, already written from standard sources.
  - `NonLinearCurveMod.html`, which the Web module replaced.
  - `CalculusMod.html`; see Calculus Review above.
- **`MatlabUsingMod.html`** is only a page of links to MATLAB programs. The site uses Julia, so it does not apply.
- **`ComplexNumberMenu.html` and `ComplexFunMenu.html`** are linked from the index but are not in the archive. Their subject is in `c2003`.
- **36 topics have only a bibliography page and no module.** They show what Mathews planned. Any of them would have to be written from standard sources:
  - Root finding and polynomials: Jenkins-Traub, Laguerre's method, Quartic equation.
  - Linear algebra and eigenvalues: Wielandt deflation, Hilbert matrix, Ill-conditioning, Jordan form, Principal axis, Eigenfaces.
  - Quadrature: Gauss-Kronrod, Gauss-Laguerre, Chebyshev quadrature, Orthogonal polynomials, Pi computation.
  - Differentiation: Automatic differentiation.
  - ODE topics: Stiff DEs, Separable DEs, Exact equations, Variation of parameters, Autonomous systems, Difference equations, Cobweb diagrams, Laplace transform.
  - Models: Duffing, Belousov-Zhabotinskii, Hodgkin-Huxley, Michaelis-Menten.
  - Special functions: Airy, Bessel.
  - PDE and boundary problems: Dirichlet problem, Vibrating string, Vibrating drum, Harmonic functions.
  - Fundamentals: Mean value theorem.
  - (Logistic equation and nonlinear curve fit are already covered.)

## 3. Covered on another page, or duplicates

- `FixPointNewtonMod.html` is the same module as `NewtonSystemMod.html` (Nonlinear Systems).
- `RiemannSumMod.html` ("Riemann Sums, Midpoint Rule and Trapezoidal") is covered by those three pages.
- `FourierSeriesMod.html` ("The Fast Fourier Transform") is covered by the Fourier series page (batch 14).
- These lower-case files duplicate their mixed-case modules: `linearprogrammingmod.html`, `newtonsearchmod.html` and `picarditerationmod.html`.
- `DEUndergradMod.html` is a 24-entry subset of the main index.
- The 39 modules in `n2003/Web/NumericalModules.html` are earlier versions of indexed modules. The only exceptions are the two Calculus modules, listed above.
- `calculus/maclaurin` and `calculus/taylor` hold 32 older worked-example pages for Maclaurin and Taylor polynomials. Their topic is the Maclaurin and Taylor Series page.
- `a2001` `Quadrature/Simpson41/Simpsonaa.gif` is the same file as `Quadrature/Simpson/Simpsonaa.gif` (both 212,115 bytes). `Riemann/*` repeats `Quadrature/*Riemann`.

## 4. Surviving legacy animations not yet used

| GIF (under `a2001/Animations/`) | Frames | Shows | Where it belongs |
|---|---|---|---|
| `OrdinaryDE/Heun1/Heunaa.gif` | 36 | Heun's method m-sweep for y′ = 1 − t∛y | a Heun's Method page (§1), or a third case on Euler's Method |
| `Derivative/ForwardD1f/ForwardDfaa.gif` | 38 | forward difference, O(h), f(x) = e⁻ˣ sin x at x = 1, h shrinking from 0.6 | Numerical Differentiation |
| `Derivative/ForwardD2f/ForwardD1faa.gif` | 28 | forward difference, O(h²), with the interpolating parabola | Numerical Differentiation |
| `Derivative/BackwardD1f/BackwardDfaa.gif` | 38 | backward difference, O(h) | Numerical Differentiation |
| `Derivative/BackwardD2f/BackwardD1faa.gif` | 28 | backward difference, O(h²), with the parabola | Numerical Differentiation |

The other two derivative animations (central O(h²), with the line and with the parabola) are covered by Case 2 of Numerical Differentiation. The page says that it leaves out the forward and backward formulas (module Examples 9, 10, 12 and 13) and the second-derivative formulas (Project II, Examples 5–8 and 15–17).

Every other portal's GIFs have a rebuild on the matching page: root finding, series, interpolation, quadrature, optimization and the other ODE methods.

## 5. Depth: the 53 pages built before batch 1

These pages were built in April 2026 and reviewed in the nine animation review rounds, which focused on the animations. The pages have a Description and Animations, and sometimes Derivation Notes. Many have no Description at all. Almost none has the module's definitions, theorems or worked examples. Many pages list the module's examples as "not animated", and those examples do not appear anywhere else on the page.

"Module examples" counts the distinct example numbers in the module's text. "Cited" counts the distinct "Example N" references on the page, which are often only in that "not animated" list.

| Page | Words | GIFs | Cited | Module examples |
|---|---|---|---|---|
| The Tangent Parabola | 255 | 1 | 1 | 5 |
| Legendre Polynomials | 268 | 2 | 1 | 9 |
| Simpson's Rule | 283 | 1 | 0 | 11 |
| Monte Carlo Pi | 314 | 1 | 3 | 7 |
| Boole's Rule | 322 | 1 | 0 | 11 |
| Trapezoidal Rule | 323 | 1 | 0 | 11 |
| Rational Approximation | 339 | 1 | 2 | 4 |
| Cubic Spline Quadrature | 340 | 1 | 0 | 6 |
| Simpson's 3/8 Rule | 342 | 1 | 0 | 11 |
| Catenary | 365 | 1 | 0 | 2 |
| Romberg Integration | 375 | 1 | 0 | 6 |
| Gauss-Legendre Quadrature | 379 | 1 | 0 | 6 |
| Midpoint Rule | 379 | 1 | 0 | 11 |
| Adaptive Simpson's Rule | 381 | 1 | 0 | 7 |
| False Position | 394 | 2 | 0 | 3 |
| Cubic Splines | 402 | 1 | 1 | 3 |
| Bisection Method | 420 | 2 | 0 | 4 |
| Richardson Extrapolation | 432 | 2 | 4 | 10 |
| Numerical Differentiation | 447 | 2 | 5 | 17 |
| Riemann Sums | 463 | 4 | 0 | 15 |
| Bézier Curves | 478 | 2 | 5 | 9 |
| Chebyshev Approximation | 478 | 29 | 0 | 18 |
| 2D Trapezoidal and Simpson | 479 | 2 | 1 | 7 |
| B-Splines | 479 | 2 | 2 | 2 |
| Derive Numerical Differentiation Formulae | 484 | 3 | 0 | 3 (example pages) |
| Hermite Interpolation | 510 | 2 | 1 | 3 |
| Least Squares Lines | 629 | 4 | 0 | 5 |
| Newton-Raphson Method | 631 | 6 | 0 | 8 |
| Fixed Point Iteration | 683 | 6 | 0 | 9 |
| Newton-Cotes Integration | 694 | 4 | 0 | 7 |
| Adams-Bashforth-Moulton | 696 | 1 | 1 | 11 |
| Least Squares Polynomials | 716 | 4 | 4 | 8 |
| Muller's Method | 720 | 3 | 0 | 3 |
| Aitken's and Neville's Interpolation | 750 | 2 | 2 | 7 |
| Runge-Kutta Method | 793 | 1 | 0 | 11 |
| Secant Method | 793 | 6 | 0 | 8 |
| Runge-Kutta-Fehlberg | 834 | 2 | 4 | 8 |
| Graeffe's Method | 895 | 2 | 0 | 9 |
| Accelerated and Modified Newton | 905 | 3 | 4 | 6 |
| Halley's Method | 1,010 | 3 | 1 | 2 |
| Improved Newton Method | 1,027 | 5 | 3 | 3 |
| Nonlinear Systems | 1,102 | 2 | 3 | 4 |
| Broyden's Method | 1,105 | 2 | 2 | 4 |
| Padé Approximation | 1,148 | 27 | 0 | 14 |
| Brent's Method | 1,149 | 2 | 0 | 5 |
| Taylor Series Method for ODEs | 1,187 | 2 | 0 | 12 |
| Aitken and Steffensen | 1,208 | 3 | 1 | 6 |
| Maclaurin and Taylor Series | 1,246 | 31 | 0 | 19 |
| Euler's Method for ODEs | 1,438 | 2 | 2 | 12 |
| Laurent Series | 1,486 | 8 | 0 | (no Mathews numerical module) |
| Lagrange Interpolation | 1,864 | 29 | 0 | 17 |
| Madsen-Reid Method | 1,883 | 3 | 0 | (no Mathews module) |
| Newton Interpolation Polynomial | 2,105 | 30 | 1 | 17 |

For comparison, the batch 1–9 pages run from 3,515 words (Linear Programming) to 8,967 words (Nelder-Mead).

## Recommendation

1. **Add the three missing topics.**
   - **Heun's Method:** its own page after Euler's Method, with a rebuild of `Heunaa.gif` plus the standard theory. Mathews gave it a module and an animation of its own.
   - **Lin-Bairstow:** a text-only page after Horner's Method, or with an animation of the quadratic factor converging.
   - **Big "O" Truncation Error:** a text-only page in a new "Fundamentals" section at the top of the index.
   - This is one small batch, run with `run-animation-batch`, after content-page has written each page.
2. **Rebuild the four forward and backward difference animations** on Numerical Differentiation, and write the module's forward, backward and second-derivative material that the page now leaves out. This fits in the same batch.
3. **Deepen the 53 pre-batch-1 pages** with `content-page`: add each module's definitions, theorems and worked examples, keep the existing animations, and review them in text-only mode. This is the bulk of the remaining work, about the size of batches 1–9 again. Grouped by chapter, it would make 8–10 batches. Start with the thinnest pages whose modules have the most examples: the quadrature rules (Simpson, Trapezoidal, Midpoint, Boole, 3/8, Romberg, Riemann Sums), then Runge-Kutta, Adams-Bashforth-Moulton, Taylor Series for ODEs, Numerical Differentiation and Chebyshev.
4. **Leave out** the bibliography-only topics and Calculus Review unless Jason wants new material from standard sources.

## Decisions (2026-11-25)

- **Yes** to pages for Heun's Method, Lin-Bairstow and Big "O". Big "O" starts a new "Fundamentals" section.
- **`c2003`: not now.**
- **Depth: a light pass, not a rewrite.** Jason's view is that the site is for what is instructive and insightful: the animations and a short description, without proofs or every worked example. Readers who want the full detail can turn to the course or the book. The 53 earlier pages therefore get an overview to a fixed standard, and the batch 1–9 pages are left alone. See `numerical-methods-light-pass-plan.md`.

## Questions for Jason

- Should the three missing topics get pages, and should Big "O" start a "Fundamentals" section?
- Is deepening the 53 earlier pages wanted? If so, should they match the batch 1–9 standard (every module example worked), or have a shorter set of key theorems and one or two examples each?
- Should `c2003` be looked at? It is the complex-analysis course (92 modules: complex numbers, analytic functions, contour integrals, residues, conformal mapping, z-transforms, Fourier and Laplace transforms). It is a second subject, not numerical methods. Laurent Series is the only page on the site that overlaps with it.
