# Batch 5 review, round 2

**Pages reviewed: 5 of 5** (all pages changed in the round-1 fixes: Lotka-Volterra Model, Lorenz Attractor, van der Pol System, Pendulum, Spring-Mass Systems). None skipped.

**Findings: 0 Error, 0 Misleading, 6 Minor (unverified).** With no Error or Misleading finding, there was nothing for independent checking, and no further round is required. No implementation or drawing error on any page; every GIF is byte-identical to what its script produces.

This was a fresh, independent review: reviewers did not read round 1's reports or the fix records, and did not compare a page with any other copy of it. Each reviewer's claim ledger covered the whole page, and every reviewer consulted the legacy archive. The pages were reviewed from their round-1 fix commits on `batch-5`.

## Calibration

Pendulum was the calibration page this round. Its reviewer worked on a scratch copy with two planted errors in Case 1 (the first swing 1.9766 changed to 1.9466, and "half-swings that shorten from 2.681 to 2.305" changed to "lengthen from 2.305 to 2.681") and reported both as Errors from its own computations. It found nothing else, so that review stands as Pendulum's round-2 review.

## The findings

- **Lotka-Volterra F1:** the Example 2 "end-point error" column is the largest-component error (run (a): 1.8e−7 against Euclidean 2.1e−7), not labelled as such.
- **Lotka-Volterra F2 (direction word):** at t = 3.3 the outer point, not the inner, is further round the loop; the inner points are visibly ahead only after about t = 4.5.
- **Lorenz Attractor F1:** the fourth RK4 error ratio is 16.5 (16.548), not 16.6.
- **van der Pol F1:** Example 4's tenth-maximum gap is 5.6e−14, still on the geometric sequence, not "rounding level 3.8e−14". The number is wrong at both digits; kept Minor because it is offered as rounding-level and the sentence's teaching (decay by ρ) is right.
- **van der Pol F2:** "mirror image" for the cycle's point symmetry through the origin.
- **Spring-Mass F1 (fidelity):** Mathews' `Solve` output is right, but his own summary line of the roots (gr_165) drops the factor 2, which is where his wrong ω₁ comes from; the page says his roots are correct.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [pendulum](pendulum.md) | 3 | 3 | 0 | 0 | 0 | reviewed (calibration pilot) |
| [lotka-volterra-model](lotka-volterra-model.md) | 3 | 3 | 0 | 0 | 2 | reviewed |
| [lorenz-attractor](lorenz-attractor.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [van-der-pol-system](van-der-pol-system.md) | 3 | 3 | 0 | 0 | 2 | reviewed |
| [spring-mass-systems](spring-mass-systems.md) | 2 | 2 | 0 | 0 | 1 | reviewed |

## Fidelity findings (for Jason to decide as a group)

- Spring-Mass Systems F1: how the page describes Mathews' Example 5 roots.

## Comparison with round 1

None of round 1's findings came back as findings, with one near-relative: round 1's Lorenz reviewer noted "16.6" (2-norm 16.548) as a rounding near-miss without filing it; this round files it as Minor. Spring-Mass F1 refines round 1's F2 (Mathews' printed eigenfrequencies correct, only ω₁ wrong) by locating where the slip enters. Each reviewer independently confirmed the round-1 corrections now on the page: the Rössler after-spike range 1.8–5.0 and the Lyapunov "about 0.07" (Lorenz); the error ratios 16.00/15.98/15.96 (van der Pol); the closure bound 1.8e−5 (Pendulum); the Example 5 pictures' same-direction first mode (Spring-Mass); the "end-point error" column and the across-orbit error wording (Lotka-Volterra).
