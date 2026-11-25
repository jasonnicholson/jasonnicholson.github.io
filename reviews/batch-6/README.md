# Batch 6 review, round 1

**Pages reviewed: 5 of 5** (Harvesting Model, Projectile Motion, Compartment Model, Logistic Curve, Earthquake Model). None skipped.

**Findings: 1 Error, 1 Misleading, 5 Minor.** Both the Error and the Misleading finding were confirmed by an independent checker who was given only the allegation. No implementation or drawing error on any page: every script runs the method its page names, every value checked matches an independent computation, and every committed GIF is byte-identical to what its script produces.

Because the page text was written in this batch, each reviewer's claim ledger covered the whole page. The legacy Mathews archive at `/home/jason/Desktop/math-fullerton/baseline/mathews/` was consulted by every reviewer.

**How this batch was reviewed.** To run batches 5–9 in parallel, batches 6–9 were reviewed from the working tree before their pages were committed; the reviewed state of each page folder was saved and is exactly what the "Add … animations (batch 6)" commits contain. Section-index links are changed in those commits, so reviewer findings about the section index linking a deleted flat file, and about links to later-batch pages, were withdrawn (they are noted in the page reports).

## Calibration

Harvesting Model was the calibration page. Its reviewer worked on a scratch copy with two planted errors (Case 3's t₀ = 0.4031 for x₀ = 1 changed to 0.4301, and Case 2's "the five that start between 1 and 3 rise toward it" changed to "fall away from it") and reported both as Errors from its own computations, without comparing the copy with the repository. The planted findings are not in this report; the real page's versions were confirmed by the same reviewer, and that review stands as the Harvesting review.

(This calibration ran on the reviewer brief as it stood before batch 5's calibration exposed a weakness; the director judged it on independence, and it passed. The later brief adds explicit ledger checks of direction and comparison words and forbids comparing the page with any other copy.)

## The findings

- **Projectile Motion F1 (Error, confirmed):** Millikan's oil drops are put in the quadratic-drag regime; they are the classic case of linear (Stokes) drag (Re ≈ 1e-5). The page repeats Mathews' own error.
- **Projectile Motion F2:** Example 7's RK4 runs end at the data point to four decimals only with the root finder's full-precision b and V, not the printed b.
- **Logistic Curve F1 (Misleading, confirmed):** the near-L-axis Hessian eigenvector does not mean "E changes little when L changes"; L and c move together along it, while L alone raises E steeply (ΔL = 10 gives 165.9).
- **Logistic Curve F2:** the correlation coefficient is negative (−0.988, ≤ −0.9978); the page quotes it as positive.
- **Earthquake Model F1:** the row-residual bound 8 × 10⁻⁶ should be 9 × 10⁻⁶ (8.95e-6).
- **Earthquake Model F2:** "every floor moves against the ground" at ω = 6 is true only relative to the ground; in Case 1's fixed-coordinate sense floors 2, 4, 6 move with it.
- **Earthquake Model F3:** a script comment describes the bisection brackets wrongly.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [harvesting-model](harvesting-model.md) | 4 | 4 | 0 | 0 | 0 | reviewed (calibration pilot) |
| [projectile-motion](projectile-motion.md) | 3 | 3 | 1 | 0 | 1 | reviewed |
| [compartment-model](compartment-model.md) | 3 | 3 | 0 | 0 | 0 | reviewed |
| [logistic-curve](logistic-curve.md) | 3 | 3 | 0 | 1 | 1 | reviewed |
| [earthquake-model](earthquake-model.md) | 4 | 4 | 0 | 0 | 3 | reviewed |

## Fidelity findings (for Jason to decide as a group)

None. (Projectile F1 is a physics error that the page inherits from Mathews' text; it is reported as a page-match Error.)

## Patterns

- **Reasoning drawn from correct numbers** (Logistic F1): every number in the sentence is right; the inference is not.
- **Physics stated from the source without checking** (Projectile F1).
- **Sign and sense of words** (Logistic F2's correlation sign, Earthquake F2's "against the ground" used in two senses).

## Phase 1 inventory

All 17 scripts ran from scratch copies against the global Julia environment (Plots 1.41.2) and reproduced all 17 committed GIFs byte for byte. Every page reference resolves.
