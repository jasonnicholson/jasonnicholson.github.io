# Batch 5 review, round 1

**Pages reviewed: 5 of 5** (Lotka-Volterra Model, Lorenz Attractor, van der Pol System, Pendulum, Spring-Mass Systems). None skipped.

**Findings: 2 Error, 0 Misleading, 11 Minor.** Both Errors were confirmed by an independent checker who was given only the allegation. No implementation or drawing error on any page: every script runs the method its page names, every value checked matches an independent computation, and every committed GIF is byte-identical to what its script produces.

Because the page text was written in this batch, each reviewer's claim ledger covered the whole page. The legacy Mathews archive at `/home/jason/Desktop/math-fullerton/baseline/mathews/` was consulted by every reviewer. Batch 5 was reviewed from its commits on `batch-5`.

## Calibration

Lotka-Volterra Model was the calibration page, and it took two runs.

- **First run (brief fixed).** The reviewer worked on a scratch copy with two planted errors in Case 3 and Case 2 (the fox-peak lag 0.8938 changed to 0.8398, and "the smaller the orbit, the shorter its period" changed to "longer"). It reported the number from its own computation, but it found the behaviour plant only by comparing the scratch copy with the repository. The brief was changed: every comparative or direction word on the page now gets its own ledger entry checked against the reviewer's own computed values, and comparing the page with any other copy of it is forbidden. All later briefs (batches 5–9) use the corrected brief.
- **Second run (passed).** A fresh reviewer, on a fresh scratch copy with two new planted errors in Case 3 (the rabbit minimum 1190.2 changed to 1109.2, and "both populations grow at first" changed to "fall at first"), reported both as Errors from its own computations, without comparing copies. The planted findings are not in this report; the real page's versions were confirmed by the same reviewer, and that review stands as the Lotka-Volterra review.

## The findings

- **Spring-Mass Systems F1 (Error, fidelity, confirmed):** the page says every surviving Mathews picture shows the first mode with the masses moving in opposite directions; his Example 5 pictures, which plot his incorrect first mode (ratio +1.396), show them moving in the same direction.
- **Spring-Mass Systems F2:** Mathews' printed eigenfrequencies are correct; only the ω₁ he assigns is wrong.
- **Lorenz Attractor F1 (Error, confirmed):** the Rössler after-spike minimum distance from the z-axis is 1.8–5.0, not 2.5–5.6.
- **Lorenz Attractor F2:** Example 6's tallest spikes are quoted from the 0.01 grid (51.77, 65.95; true 51.80, 65.98).
- **Lorenz Attractor F3:** two first-crossing times in Example 1's m-table use the 0.02 grid without saying so (7.23 and 18.80 at every step).
- **Lorenz Attractor F4 (low confidence):** the Rössler Lyapunov estimates 0.0649/0.0671 look low (independent estimates 0.069–0.076).
- **Lotka-Volterra F1:** "more than 10⁴ times smaller" is not true of run (c)'s error.
- **Lotka-Volterra F2:** the distance from the exact orbit is called the run's error; it is only the part across the orbit.
- **van der Pol F1:** two ratios in the verification table are slightly off (16.10, 15.98).
- **Pendulum F1:** the widest loop's closure error is quoted as within 1.8e-5 and within 1.7e-5 (true 1.745e-5).
- **Pendulum F2:** the 2π-shift agreement "within 4e-15" is not reproducible (rounding noise, up to about 1e-14).
- **Pendulum F3:** "Mathews' own step counts" for Examples 5 and 6, whose inputs are lost.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [lotka-volterra-model](lotka-volterra-model.md) | 3 | 3 | 0 | 0 | 2 | reviewed (calibration pilot, second run) |
| [lorenz-attractor](lorenz-attractor.md) | 3 | 3 | 1 | 0 | 3 | reviewed |
| [van-der-pol-system](van-der-pol-system.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [pendulum](pendulum.md) | 3 | 3 | 0 | 0 | 3 | reviewed |
| [spring-mass-systems](spring-mass-systems.md) | 2 | 2 | 1 | 0 | 1 | reviewed |

## Fidelity findings (for Jason to decide as a group)

- Spring-Mass Systems F1 (Error) and F2: how the page describes Mathews' Example 5 pictures and printout.
- Pendulum F3: the page credits Mathews with step counts that are lost for Examples 5 and 6.

## Patterns

- **Values read off a sampling grid instead of located** (Lorenz F2, F3): the same lesson as batch 5's Phase 1 van der Pol crossing.
- **Reference accuracy near the error being measured** (van der Pol F1: a reference only about 120 times more accurate than the n = 12000 error).
- **Statements about Mathews' pictures** need the same check as numbers (Spring-Mass F1).

## Phase 1 inventory

All 14 scripts ran from scratch copies against the global Julia environment (Plots 1.41.2) and reproduced all 14 committed GIFs byte for byte. Every page reference resolves, no file on disk is unreferenced, and the section index links all five pages.

---

# Batch 5: closing summary (2026-11-25)

## Pages built

| Page | Text (Phase 1) | Animations (Phase 2) |
|---|---|---|
| [Lotka-Volterra Model](../../pages/numerical-methods/lotka-volterra-model/) | written from `Lotka-VolterraMod`, all 7 examples; period 6.6084826712 and the Example 6 fox-rabbit period computed | 3 new: Example 2's forward and backward runs, five orbits of the aside with their phase lag, Example 6's foxes and rabbits |
| [Lorenz Attractor](../../pages/numerical-methods/lorenz-attractor/) | written from `LorenzAttractorMod` with the Rössler examples; nearly all of Mathews' set-up (intervals, starts) is lost and was chosen by the page | 3 new: RK4 against an order-30 Taylor reference, two true solutions 10⁻¹⁰ apart, the two Rössler attractors |
| [van der Pol System](../../pages/numerical-methods/van-der-pol-system/) | written from `VanDerPolMod`, all 6 examples; Example 1 matches Mathews' end point, Examples 2–6 use a chosen start and interval (his are lost) | 3 new: μ = 0 against the exact circle, μ = 1/16 to 1 from outside and inside, the μ = 4 relaxation oscillation |
| [Pendulum](../../pages/numerical-methods/pendulum/) | written from `PendulumMod`, all 8 examples; Examples 5 and 6 inputs lost, so the page uses its own curves; Example 4's interval [0, 20] assumed | 3 new: linear against nonlinear pendulum, Example 6's loops and rotations, Example 7's fourteen damped curves |
| [Spring-Mass Systems](../../pages/numerical-methods/spring-mass-systems/) | written from `SpringMassMod`, all 10 examples; corrects Mathews' Example 5 first frequency (2√(1+√2), not √(1+√2)) | 2 new: Example 6 (two walls) and Example 5 (one wall), each with its normal modes |

Every GIF regenerates byte for byte from its committed script (checked by each builder, by the director before commit, and in each review's Phase 1). Lotka-Volterra was the Phase 2 pilot and passed unchanged.

## Findings by round and severity

| Round | Folder | Error | Misleading | Minor | Calibration pilot (planted errors caught) |
|---|---|---|---|---|---|
| 1 | `reviews/batch-5` | 2 | 0 | 11 | Lotka-Volterra (first run 1 of 2 independently; brief fixed; second run 2 of 2) |
| 2 | `reviews/batch-5-r2` | 0 | 0 | 6 | Pendulum (2 of 2) |

Round 2 found no Error or Misleading findings, so the loop ended there.

## What was fixed

Every finding of both rounds was reproduced, fixed and judged by a different checker who saw only the findings and the diff.

- **Round 1.** Spring-Mass: Mathews' Example 5 pictures show his incorrect first mode with the masses moving the same way (Error); only his ω₁ is wrong. Lorenz: the Rössler after-spike range is 1.8–5.0 (Error); Example 6's tallest spikes 51.80–65.98; the m-table column now says it was checked on the 0.02 grid; the Rössler Lyapunov exponent "about 0.07". Lotka-Volterra: run (c)'s error claim; the distance from the exact orbit is the part of the error across it. van der Pol: the ratios 16.00/15.98/15.96 against a 256-bit RK4 + Richardson reference. Pendulum: closure within 1.8 × 10⁻⁵; the 2π shift "to rounding error (about 10⁻¹⁴)"; Mathews' step count claimed only where it survives.
- **Round 2.** Lotka-Volterra: end-point errors are Euclidean distances (run (a) 2.1 × 10⁻⁷); at t = 3.3 the outer point still leads round the loop, the inner points lead from t ≈ 4.1 (Behavior paragraph and alt text). Lorenz: the fourth ratio 16.5. van der Pol: Example 4's tenth gap 5.6 × 10⁻¹⁴, still on the geometric sequence; the μ = 4 cycle's halves are related by a half turn, not a mirror. Spring-Mass: Mathews' `Solve` output is right, his summary line of the roots drops the factor 2.

No GIF changed in either round.

## Open

Nothing.

## Decisions taken for Jason to revisit

1. **Set-ups chosen where Mathews' are lost:** Lorenz (intervals and starts of nearly every example), van der Pol Examples 2–6 (start (0, 3), [0, 60], n = 6000), Pendulum Examples 5 and 6 (own curves) and Example 4 (interval [0, 20]). Each page says which values are Mathews' and which are its own.
2. **van der Pol Example 4's tenth-maximum gap** (round 2 F1) was kept Minor although its two digits were wrong: it was offered as a rounding-level value and the decay by ρ it illustrates was right.
3. **Calibration brief change:** round 1's first calibration found the behaviour plant only by comparing the copy with the repository; the brief now requires a ledger entry for every direction or comparison word and forbids comparing copies. All later reviews (batches 5–9) used the corrected brief.

## Process notes

- Reviewers returned reports as text; the director wrote them. MATLAB was not run; quarto only by the director. `quarto render pages/numerical-methods/` completed without errors after the last fix (warnings only for section-index links to batch 6–9 pages, which are moved in the working tree and linked in their own batches' commits).
- Batch 5 was reviewed from its commits on `batch-5`; batches 6–9 ran in parallel from the working tree (see their READMEs).

## Commits on `batch-5`

```
25e3974 Record batch 5 archive paths in the plan
7f42836 Write Lorenz Attractor page text (batch 5)
84f9462 Write Lotka-Volterra Model page text (batch 5)
a8e9567 Write van der Pol System page text (batch 5)
4e9d0b0 Write Pendulum page text (batch 5)
adc87cd Write Spring-Mass Systems page text (batch 5)
2147e34 Add Lotka-Volterra Model animations (batch 5)
295d457 Add Lorenz Attractor animations (batch 5)
80bcd3c Add van der Pol System animations (batch 5)
f40cbe8 Add Pendulum animations (batch 5)
3b3b456 Add Spring-Mass Systems animations (batch 5)
b2a2626 Add batch 5 review
fd89faa Fix Lotka-Volterra Model (batch 5 review)
4219f7f Fix Pendulum (batch 5 review)
e82d1fa Fix Spring-Mass Systems (batch 5 review)
8e2b40e Fix van der Pol System (batch 5 review)
d0597d5 Fix Lorenz Attractor (batch 5 review)
d42c695 Add batch 5 review, round 2
2638449 Fix Lorenz Attractor (batch 5 review, round 2)
3c2f1b0 Fix Spring-Mass Systems (batch 5 review, round 2)
d782737 Fix Lotka-Volterra Model (batch 5 review, round 2)
8356178 Fix van der Pol System (batch 5 review, round 2)
```
