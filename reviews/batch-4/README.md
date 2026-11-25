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

---

# Batch 4: closing summary (2026-11-25)

## Pages built

| Page | Text (Phase 1) | Animations (Phase 2) |
|---|---|---|
| [Picard Iteration](../../pages/numerical-methods/picard-iteration/) | written from `PicardIterationMod`, all 12 examples, every iterate exact | 4 new: Examples 3, 4, 7, 11 in Mathews' windows with a log error panel and the 0.01 tolerance interval |
| [Predictor-Corrector Methods](../../pages/numerical-methods/predictor-corrector-methods/) | written from standard sources (Mathews' module is an "under construction" placeholder): PECE and P(EC)^mE, Milne's device, modifiers, stability, three worked examples on y' = 1 + y² | 3 new: PECE step by step, the corrector iterates, the error at t = 1 against the number of corrections |
| [Shooting Methods for ODE's](../../pages/numerical-methods/shooting-methods-for-odes/) | written from `ShootingMod`, all 6 examples; two of Mathews' theory statements corrected | 3 new: the shots with the landing line, m-refinement, linear shooting failing as b → 1 + π |
| [Finite Difference Method for ODE's](../../pages/numerical-methods/finite-difference-method-for-odes/) | written from `FiniteDifferenceMod`, all 6 examples; every Mathews printout matched | 3 new: grid refinement, Richardson extrapolation, orders of convergence |
| [Galerkin's Method](../../pages/numerical-methods/galerkins-method/) | written from `GalerkinMod`, all examples; Example 2 follows the equation Mathews' notebook solves | 3 new: Example 2 as n grows with cond(A), Example 3(b)'s two bases, Example 4(b)'s sine coefficients |

Every GIF regenerates byte for byte from its committed script (checked by each builder, by the director before commit, and in the review's Phase 1). Picard Iteration was the Phase 2 pilot and passed unchanged.

## Findings by round and severity

| Round | Folder | Error | Misleading | Minor | Calibration pilot (planted errors caught) |
|---|---|---|---|---|---|
| 1 | `reviews/batch-4` | 0 | 0 | 9 | Picard (2 of 2) |

With no Error or Misleading finding in round 1, no second round was required.

## What was fixed

All nine Minor findings were reproduced, fixed and judged by a different checker who saw only the findings and the diff. Picard: the error-bound theorem is now "Theorem 2′" and the Description and systems section cite it. Predictor-Corrector: 0.972 → 0.971; the corrector-convergence theorem now requires a global Lipschitz condition and adds a strip version for a closed interval mapped into itself, which Example 2(a) now uses (the checker's "closed interval" refinement went back to the same fixer). Shooting: the page says which Case 3 elements are exact and which are Runge2D. Finite Difference for ODE's: Mathews' magenta curve is his FD solution; the dip claim limited to n ≥ 10; "agree to 14 decimal places" for c₁; verification rows j = 1 and 24 and the Step 4 sum made consistent with their printed factors (the fixer found the two extra cases). Galerkin: "k ≥ 11" (the gap is exactly 2/(k² − 2)). No GIF changed; one script comment changed (`fdodeaa.jl`), and its GIF regenerates byte for byte.

## Open

Nothing.

## Decisions taken for Jason to revisit

1. **Predictor-Corrector has no Mathews original.** Its module is an "under construction" placeholder; the page is from standard sources, uses its own AB2 + trapezoid examples, and cites Lambert (1991) in plain text (no `references.bib` entry; the order theorem was attributed from memory).
2. **Galerkin Example 2 follows the equation Mathews' notebook solves** (y' + 5y − 1 − x + sin 2x = 0), not the one his module states (y' + 2y + 6 + 4x = 0); the page flags this and also solves the stated one on an assumed [0, 3].
3. **Picard's "Theorem 2′" label** is new; renumbering would have shifted Theorem 3.
4. **Plan corrections:** the plan listed 15 archive examples for Picard; the module has 12.

## Process notes

- Reviewers returned reports as text; the director wrote them. MATLAB was not run; quarto only by the director. `quarto render pages/numerical-methods/` completed without errors after the last fix (warnings only for section-index links to later-batch pages moved in the working tree and committed in their own batches).

## Commits on `batch-4`

```
de67f4a Record batch 4 archive paths in the plan
c397da7 Write Shooting Methods for ODE's page text (batch 4)
126cc93 Write Finite Difference Method for ODE's page text (batch 4)
7de2d05 Write Predictor-Corrector Methods page text (batch 4)
12d8fb8 Write Picard Iteration page text (batch 4)
149faa8 Write Galerkin's Method page text (batch 4)
6bb31d8 Add Picard Iteration animations (batch 4)
cfbef54 Add Predictor-Corrector Methods animations (batch 4)
707a282 Add Shooting Methods for ODE's animations (batch 4)
41f9ad3 Add Finite Difference Method for ODE's animations (batch 4)
d0d4d22 Add Galerkin's Method animations (batch 4)
da892de Add batch 4 review
d0871b3 Fix Picard Iteration (batch 4 review)
5b35666 Fix Galerkin's Method (batch 4 review)
78d495e Fix Shooting Methods for ODE's (batch 4 review)
48582e0 Fix Predictor-Corrector Methods (batch 4 review)
62f07d2 Fix Finite Difference Method for ODE's (batch 4 review)
```
plus this closing commit.
