# Batch 4 review, round 1

**Pages reviewed: 5 of 5** (Picard Iteration, Predictor-Corrector Methods, Shooting Methods for ODE's, Finite Difference Method for ODE's, Galerkin's Method). None skipped.

**Findings: 0 Error, 0 Misleading, 9 Minor (unverified).** With no Error or Misleading finding, Phase 3 (independent checking) had nothing to check. No implementation or drawing error on any page: every script runs the method its page names, every iterate, table cell and reference value matches an independent implementation, and every committed GIF is byte-identical to what its script produces.

Because the page text was written in this batch, each reviewer's claim ledger covered the whole page (worked examples, tables, theorems, implementation notes), not only the Animations section and Description. The legacy Mathews archive was found at `/home/jason/Desktop/math-fullerton/baseline/mathews/` and every reviewer consulted it.

## Calibration

Picard Iteration was the calibration page. Its reviewer worked on a scratch copy with two planted errors (Case 1's final largest error 1.107 changed to 1.170, and Case 4's tolerance interval "widens" changed to "narrows") and reported both as Errors with its own computations. The brief was not changed. The planted findings are not in this report; the real page's versions of those sentences were confirmed by the same reviewer, and that review stands as the Picard review.

## The findings

- **Picard F1:** the Description cites Theorem 2 for a local-convergence statement that is in the unnumbered error-bound theorem.
- **Predictor-Corrector F1:** a table cell 0.972 should be 0.971 (0.9714729).
- **Predictor-Corrector F2:** the corrector-convergence theorem's "exactly one solution, from any starting value" needs a global Lipschitz condition; for y' = 1 + y² it holds only inside the strip used (the corrector equation has two roots), which the page does not say.
- **Shooting F1:** Case 3's left panel draws the exact u, v and fan (and the exact v(b), C in its title); only the magenta curve and right panel use Runge2D, which the page does not say.
- **Finite Difference for ODE's F1 (fidelity):** Mathews' magenta curve is his finite-difference solution, not the exact solution as the page says.
- **Finite Difference for ODE's F2:** "the error curve dips there" is not true of n = 5.
- **Finite Difference for ODE's F3:** Mathews' c₁ differs from the page's in the last two digits.
- **Finite Difference for ODE's F4:** the j = 24 verification row's last digit does not follow from the printed factors.
- **Galerkin F1:** "within 2% … for k ≥ 10" fails at k = 10 (2.04%).

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [picard-iteration](picard-iteration.md) | 4 | 4 | 0 | 0 | 1 | reviewed (calibration pilot) |
| [predictor-corrector-methods](predictor-corrector-methods.md) | 3 | 3 | 0 | 0 | 2 | reviewed |
| [shooting-methods-for-odes](shooting-methods-for-odes.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [finite-difference-method-for-odes](finite-difference-method-for-odes.md) | 3 | 3 | 0 | 0 | 4 | reviewed |
| [galerkins-method](galerkins-method.md) | 3 | 3 | 0 | 0 | 1 | reviewed |

## Fidelity findings (for Jason to decide as a group)

- Finite Difference for ODE's F1: the page says the exact solution is "in magenta as in his graphs"; in Mathews' graphs magenta is the finite-difference solution.

## Patterns

- **Statements about what a panel or graph shows** (Shooting F1, Finite Difference F1): which curve is exact and which is computed, in the animation and in Mathews' graphs, needs the same check as a number.
- **Quantifiers and bounds just past their range** (Galerkin F1 at k = 10, Finite Difference F2 at n = 5, Predictor-Corrector F2's global "exactly one solution").
- **Last-digit rounding** (Predictor-Corrector F1, Finite Difference F3/F4): double rounding, and checks shown with fewer digits than were used.

## Phase 1 inventory

All 16 scripts ran from scratch copies against the global Julia environment (Plots 1.41.2) and reproduced all 16 committed GIFs byte for byte. Every page reference resolves, no file on disk is unreferenced, and the section index links all five pages. Pre-existing uncommitted changes when the run started: the Phase 2 work of later batches (5–9), which the batch director keeps out of batch 4's commits; none touch batch 4's pages.
