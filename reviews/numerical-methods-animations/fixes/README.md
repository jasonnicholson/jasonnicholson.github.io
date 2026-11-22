# Fix run — numerical-methods animations (round 1)

Run of 2026-11-21 on branch `fix/numerical-methods-animations`, scope `all`, from `reviews/numerical-methods-animations` (round 1). Nothing was pushed.

## Headline

- **All 51 pages with findings are fixed, checked and committed.** No page is left with an open finding, and no finding failed its check twice.
  - 174 of 174 round-1 findings are now `fixed`: 61 Error, 37 Misleading and 76 Minor. That count includes Newton Interpolation F4, which was resolved by the D3 file deletion.
  - No finding was recorded as `not reproduced` or left `deferred`. Every fixer reproduced its findings before changing anything, including the Minor ones that round 1 never checked.
  - The 3 inventory items are fixed: D3 (orphan files) and D4 (section-index links).
  - Cubic Spline Quadrature and The Tangent Parabola had no findings and were not touched.
- **Every page went through an independent resolution check.** A fresh checker, shown the original findings and the diff but not the fixer's reasoning, recomputed every changed sentence and number. It also looked at the regenerated frames and reproduced every changed GIF byte for byte from a scratch copy.
  - In 15 cases the checker found a new problem in the fix. The page went back to the same fixer and was checked again. These were mostly Minor problems, such as a clipped label, a wrong number in new text, or a claim that was too broad.
  - No page needed more than two rounds.
- **The whole section renders.** `quarto render pages/numerical-methods/` completes without errors.
- **The legacy Mathews archive was found and used** (`/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/`, plus `a2001/` for some animated GIFs). Each fix record has a "Legacy archive" section. No archive topic exists for Madsen-Reid or Laurent.

## Decisions: where a default settled something you may want to revisit

- **D1 (non-smooth quadrature integrand): default applied on all 11 pages.**
  - The integrand is kept. Each page now gives its own measured rate: O(h^5/3) for the composite rules, and O(n^-10/3) for Gauss-Legendre, whose endpoint singularity behaves differently.
  - Each page also has the shared cause sentence, and the textbook order is labelled "for smooth f (C^k)".
  - The wording came from the Trapezoidal pilot.
- **D2 (ODE step size): default applied on Euler/Heun, RK4, Taylor, ABM and RKF45.** New steps: RK4 h = 0.0625; Euler and Heun h = 0.025; Taylor h = 0.05; ABM4 h = 0.025.
  - The ABM4 PECE stability limit was computed (z* = −1.2848, h* = 0.0311), as were all the other limits.
  - **The D2 text in the plan is not quite right.** It says "coarser steps become unstable once the solution flattens", and two independent checks showed this is false in both halves:
    - For large h the onset comes before the flat part. With RK4 at h = 1 it is at t ≈ 2.79, where y′ ≈ −0.61.
    - Just above the threshold nothing visible happens.
  - The pages now say exactly what is computed: for h above h*, h·|∂f/∂y| passes the method's limit before t = 5, and the pages give the onset time for the old step.
  - **You may want to update D2's wording in `fix-plan/README.md`** so later rounds don't reintroduce it.
- **D3 (orphans): applied.** `lagrangeaa.jl` and `newtpolybb.jl`/`.gif` are deleted.
  - `newtpolyaa` (divided differences of cos on kπ/3 nodes) is verified and linked as the last case on the Newton page.
  - The Newton page's counts are now scoped to "Cases 01–29".
- **D4 (index links): applied.** The three links now point at the flat `.qmd` pages.
- **D6 (Laurent): default applied.**
  - The page and all 27 legends now say honestly that no case has a principal part, so each frame is a Taylor polynomial ("Laurent = Taylor, N = n").
  - The pole cases are noted, and no new cases were added.
  - Real Laurent examples with poles are still yours to decide.
- **D7 (text vs animation): text changed** on Lagrange/Newton (degree sequence), Chebyshev (node counts), Riemann F3, Legendre F2, Aitken/Neville F2, Regula Falsi F5 and B-Splines F2.

Fix choices where another valid fix existed:

- **Muller Case 1** keeps the real-part (vertex) iteration, made explicit in the script, legend and text. Mathews' own example used the same real-arithmetic fallback. The alternative would have been true complex Muller.
- **Brent** scripts now run Brent's ZEROIN; their evaluation points match scipy `brentq` and Mathews' printouts. The modified Wikipedia variant is gone.
- **Madsen-Reid** now implements the multi-step acceleration, rather than renaming the page's claims.
- **Lagrange/Newton** nodes now include the endpoints (no 3% inset), as in Mathews. To keep the cases well-posed:
  - Case 14 moved to nodes on [−3, 3], because 5 nodes on [−π, π] land on the poles.
  - Case 19 uses [−1, 1].
  - Chebyshev case 19 also interpolates on [−1, 1] instead of the alt text's [−1.5, 1.5].
- **Riemann** Lower/Upper sums now use the true inf/sup on each subinterval, as Mathews' archive did.
- **Adaptive Simpson** now runs a real adaptive routine using Mathews' factor-1 test with the tolerance halved per split. The page states that test and contrasts it with the 15ε variant.
- **Improved Newton F5:** a short `## Description` defining Methods A, B and C was added, because the finding itself named it.

## Things found but not changed (for you or for round 2)

- **A new false sentence on Nonlinear Systems.** index.qmd:76 says Newton converges "within a handful of iterations from anywhere in the basin". On a grid of starting points, some need up to 38 iterations (Solution 1) and up to 178 (Solution 2). The evidence is in that fix record's Notes. It was not a round-1 finding, so it was left alone.
- **Pages with no `## Description` section** (pre-existing, not findings): Newton-Raphson, Runge-Kutta, Regula Falsi, Secant, Muller, Taylor method, Legendre, Catenary. Improved Newton now has one, because its finding named it.
- **Archive differences:**
  - Euler: Mathews' "Modified Euler" is the explicit midpoint method, not Heun; the page uses Heun and names it.
  - Euler and Simpson 3/8: legacy notes say archive GIFs are missing, but they are present now. Other pages may have the same stale note.
  - Chebyshev: Mathews' intervals for cases 04 and 29 were [0, 2] and [0.5, 4]; the pages use wider ones.
- **Cosmetic leftovers:**
  - Cubic Splines: the last frame's title is clipped by one character.
  - Aitken/Neville: the frame-5 title says "degree 4", although the text explains that the interpolant is the same cubic.
  - Muller: in `mullersaa.gif` frames 5–9 the vertex circle is hidden under other markers.
  - Newton Interpolation: alt texts still say "legacy function-and-interval list", and Cases 12 and 13 lack the flat-frame note that the Lagrange page now has.
- **Environment:** this machine has SpecialFunctions 2.7.2, not the 2.9.2 the round-1 GIFs were made with.
  - Before any change, unchanged scripts were rerun, including the Padé script that evaluates Γ and Y₀. All 58 GIFs were byte-identical, so regenerating was safe.
  - Quarto is 1.10.18, not 1.8.26.

## Method notes

- **Pilot.** The pilot was Bisection, Newton-Raphson, Fixed-Point, Trapezoidal, Runge-Kutta and Padé. Its fix records showed reproduction first, a computed ledger for every changed sentence, and checkers that recomputed independently.
- **Briefs.** Three lessons were added to the remaining briefs:
  - do not fix pre-existing convention gaps that no finding names;
  - make the smallest change that fixes a Minor picture finding;
  - quantifiers must be exactly true.
- **Patterns handed on:**
  - D1 wording from Trapezoidal;
  - the D2 approach from Runge-Kutta, with the wording correction above;
  - the exact Taylor-coefficient routine from Padé (validated against mpmath to 1.1e-16 relative), reused by Maclaurin and Laurent;
  - the off-scale-marker pattern from Fixed-Point, reused by Secant.
- **Records.** Each page's fix record (`<slug>.md` here) ends with the independent checker's result and a final status line. Re-checks are summarised in "Round 2" / "Re-check" sections. Scratch evidence was kept outside the repository and is not part of the record.

## Commits (55, oldest first)

One commit per page (WP-B as one commit for both interpolation pages), plus three director follow-ups: the Runge-Kutta stability wording (`7eb8f60`), D3 (`5cd7ea4`) and the Padé comment (`e4e8aae`). D4 is `188e4bd`. `git log --oneline 735d365..HEAD` lists them all; this README and the final worklist update are in the last commit.

## Next

Run the independent re-review: `/review-animations all out=reviews/numerical-methods-animations-r2`.
