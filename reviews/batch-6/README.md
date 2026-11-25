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

---

# Batch 6: closing summary (2026-11-25)

## Pages built

| Page | Text (Phase 1) | Animations (Phase 2) |
|---|---|---|
| [Harvesting Model](../../pages/numerical-methods/harvesting-model/) | written from `HarvestingModelMod`, all 20 examples; corrects a sign in Mathews' formula for the time t₁ in case (iii) | 4: Mathews' three cases (Examples 8, 15, 19) and a new sweep of the harvest rate |
| [Projectile Motion](../../pages/numerical-methods/projectile-motion/) | written from `ProjectileMotionMod`; Example 7's launch speeds reconstructed (Mathews' are lost); corrects Mathews on Millikan's drops | 3 new: the four drag laws together, Example 3's one-formula solution, five baseballs aimed at Stargell's 506.5 ft |
| [Compartment Model](../../pages/numerical-methods/compartment-model/) | written from `CompartmentModelMod`, all examples with exact solutions | 3 new: Mathews' Examples 1–3 (open chain, closed loop, five-tank chain) |
| [Logistic Curve](../../pages/numerical-methods/logistic-curve/) | written from Mathews' logistic curve-fitting module (`Web/LogisticEquationMod`, which the plan had missed), US census data; Example 5 (true least squares) is new | 3 new: data linearization as the guessed limit varies, Gauss–Newton from the L = 800 fit, solutions of the fitted logistic equation |
| [Earthquake Model](../../pages/numerical-methods/earthquake-model/) | written from `EarthquakeModelMod`; corrects the sign of Mathews' ω²I + A | 4 new: the building swaying at ω = 2.1, the frequency sweep, amplitude against period, the six natural modes |

Every GIF regenerates byte for byte from its committed script (checked by each builder, by the director, and in each review's Phase 1). Harvesting Model was the Phase 2 pilot and passed unchanged.

## Findings by round and severity

| Round | Folder | Error | Misleading | Minor | Calibration pilot (planted errors caught) |
|---|---|---|---|---|---|
| 1 | `reviews/batch-6` | 1 | 1 | 5 | Harvesting Model (2 of 2) |
| 2 | `reviews/batch-6-r2` | 0 | 0 | 2 | Earthquake Model (2 of 2) |

Round 2 found no Error or Misleading findings, so the loop ended there.

## What was fixed

Every finding of both rounds was reproduced, fixed and judged by a different checker who saw only the findings and the diff.

- **Round 1.** Projectile: Millikan's drops are now the classic case of linear drag, with a sentence saying Mathews has it backwards (Error); Example 7's end points are stated for the root finder's full-precision b and V. Logistic: the Hessian eigenvector moves L and c together (Misleading); the correlation coefficient is negative. Earthquake: residual bound 9 × 10⁻⁶; at ω = 6 the floors move against the ground only relative to it (the page now gives the computed range 0.4998e to 0.0078e); the bisection comment in `earthquakecc.jl` (its GIF regenerates byte for byte).
- **Round 2.** Projectile: Mathews has two comparison plots (Examples 3 and 4), neither with all four drag laws. Logistic: the Case 3 alt text no longer calls the solutions from 400 and 600 S-shaped.

## Open

Nothing.

## Decisions taken for Jason to revisit

1. **Projectile Example 7's launch speeds** are reconstructed by root finding (Mathews' values are lost); the page says so.
2. **Projectile F1:** rather than silently correcting Mathews' Millikan remark, the page says that his module has the regimes backwards.
3. **Plan correction:** Logistic Curve does have a Mathews module, `n2003/Web/LogisticEquationMod/LogisticEquationMod.html` (4 examples), recorded in the plan; its "Archive examples" and "Archive graphs" counts (0, 0) were left as the plan had them.
4. **Stacked branches and parallel review** (decisions for batches 5–9): `batch-6` starts from the tip of `batch-5`; batches 6–9 were built and reviewed from the working tree in parallel with batch 5, with each page's reviewed and fixed states saved and committed afterwards in order, so the history shows the same sequence as a batch run alone.

## Process notes

- Reviewers returned reports as text; the director wrote them. MATLAB was not run; quarto only by the director.
- Each page's text, reviewed state and fixed states were committed from saved copies after the review loop finished, so the page-text and animation commits were not rendered one by one. The final state was rendered with `quarto render pages/numerical-methods/`, which completed without errors (warnings only for section-index links to batch 7–9 pages, which are moved in the working tree and linked in their own batches' commits).
- Compartment Model links `../matrix-exponential.qmd`, which is right on this branch; the link changes to `../matrix-exponential/` in batch 9's Matrix Exponential commit.

## Commits on `batch-6`

```
cfdcfac Record batch 6 archive paths in the plan
113c310 Write Projectile Motion page text (batch 6)
3ae08f9 Write Compartment Model page text (batch 6)
1015310 Write Harvesting Model page text (batch 6)
a4428e2 Write Logistic Curve page text (batch 6)
17477ee Write Earthquake Model page text (batch 6)
43f8326 Add Harvesting Model animations (batch 6)
a4a6497 Add Projectile Motion animations (batch 6)
a6187c5 Add Compartment Model animations (batch 6)
f28238f Add Logistic Curve animations (batch 6)
312d235 Add Earthquake Model animations (batch 6)
c2211ee Add batch 6 review
185743e Fix Projectile Motion (batch 6 review)
f9dd0fa Fix Logistic Curve (batch 6 review)
02fe419 Fix Earthquake Model (batch 6 review)
42e6d31 Add batch 6 review, round 2
ac69064 Fix Projectile Motion (batch 6 review, round 2)
134b898 Fix Logistic Curve (batch 6 review, round 2)
```
