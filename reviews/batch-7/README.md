# Batch 7 review, round 1

**Pages reviewed: 3 of 3** (Crank-Nicolson Method, Finite Difference Method for the wave equation, Elliptic PDE's). None skipped.

**Findings: 1 Error, 0 Misleading, 4 Minor.** The Error was confirmed by an independent checker who was given only the allegation. No implementation or drawing error on any page: every script runs the method its page names, every value checked matches an independent computation, and every committed GIF is byte-identical to what its script produces.

Because the page text was written in this batch, each reviewer's claim ledger covered the whole page. The legacy Mathews archive was consulted by every reviewer.

**How this batch was reviewed.** Batches 6–9 were reviewed from the working tree before their pages were committed, so that batches 5–9 could be reviewed in parallel; the reviewed state of each page folder was saved and is exactly what the "Add … animations (batch 7)" commits contain. Section-index links are changed in those commits.

## Calibration

Crank-Nicolson Method was the calibration page. Its reviewer worked on a scratch copy with two planted errors (Case 2's G₁ = 0.665780 changed to 0.656780, and Case 1's computed rows "lie below the exact solution … the error panel stays negative" changed to "above … positive") and reported both as Errors from its own computations, without comparing the copy with the repository. The planted findings are not in this report; the real page's versions were confirmed by the same reviewer, and that review stands as the Crank-Nicolson review.

(This calibration ran on the brief as it stood before batch 5's calibration exposed a weakness; it was judged on independence and passed. Finite Difference and Elliptic PDE's were reviewed with the corrected brief.)

## The findings

- **Finite Difference F1 (Error, confirmed):** "the boundary conditions hold when F and G are odd and have period 2a" is false (F = sin(πz/a), G = 0 is a counterexample); the condition is G(z) = −F(−z) with F 2a-periodic, i.e. G = F for odd F. Mathews' proof has the same proviso.
- **Finite Difference F2:** F and G are swapped in the proof relative to (10) (the conclusion stands).
- **Finite Difference F3:** "implicit methods have no stability restriction" is too general (θ-scheme with θ < ¼).
- **Finite Difference F4:** the Case 3 alt text says |c₉| alternates in sign.
- **Elliptic PDE's F1:** "Its E rises only once" reads as Gauss-Seidel; it is SOR's E.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [crank-nicolson-method](crank-nicolson-method.md) | 4 | 4 | 0 | 0 | 0 | reviewed (calibration pilot) |
| [finite-difference-method](finite-difference-method.md) | 3 | 3 | 1 | 0 | 3 | reviewed |
| [elliptic-pdes](elliptic-pdes.md) | 4 | 4 | 0 | 0 | 1 | reviewed |

## Fidelity findings (for Jason to decide as a group)

None.

## Patterns

- **Theorem conditions copied from the source** (Finite Difference F1, F3): both statements are Mathews'; neither was checked against a counterexample.
- **Words of a sentence that refer to the wrong subject or quantity** (Elliptic F1's "Its", Finite Difference F4's |c₉|).

## Phase 1 inventory

All 11 scripts ran from scratch copies against the global Julia environment (Plots 1.41.2) and reproduced all 11 committed GIFs byte for byte. Every page reference resolves.
