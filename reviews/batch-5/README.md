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
