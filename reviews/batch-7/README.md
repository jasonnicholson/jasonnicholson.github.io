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

---

# Batch 7: closing summary (2026-11-25)

## Pages built

| Page | Text (Phase 1) | Animations (Phase 2) |
|---|---|---|
| [Crank-Nicolson Method](../../pages/numerical-methods/crank-nicolson-method/) | written from `CrankNicolsonMod`, all examples; Example 4 follows Mathews' program (b = 0.2, r = 2) | 4 new: forward differences at r = 0.5 and r = 0.875, Crank-Nicolson at r = 1 and 2, a sawtooth of size 0.001 at r = 2 |
| [Finite Difference Method](../../pages/numerical-methods/finite-difference-method/) | written from `FiniteDifferencePDEMod` (the wave equation); Example 3's grid reconstructed (Mathews' is lost); corrects the d'Alembert proviso that Mathews' proof shares | 3 new: Example 1's second row by (8) and (7), the plucked string against d'Alembert, the growing sawtooth at r = 1.02 |
| [Elliptic PDE's](../../pages/numerical-methods/elliptic-pdes/) | written from `EllipticPDEMod`, all 6 examples; Examples 2 and 6 set-ups chosen (Mathews' are lost); notes the textbook's Table 10.6 slip | 4 new: SOR on the 9 × 9 grid, the insulated edge at two ω, SOR against Gauss-Seidel on 21 × 21, the error against Laplace's equation |

Every GIF regenerates byte for byte from its committed script (checked by each builder, by the director, and in each review's Phase 1). Crank-Nicolson was the Phase 2 pilot and passed unchanged.

## Findings by round and severity

| Round | Folder | Error | Misleading | Minor | Calibration pilot (planted errors caught) |
|---|---|---|---|---|---|
| 1 | `reviews/batch-7` | 1 | 0 | 4 | Crank-Nicolson (2 of 2) |
| 2 | `reviews/batch-7-r2` | 0 | 1 | 2 | Elliptic PDE's (2 of 2) |
| 3 | `reviews/batch-7-r3` | 0 | 0 | 3 | Finite Difference Method (2 of 2) |

Round 3 found no Error or Misleading findings, so the loop ended there.

## What was fixed

Every finding of every round was reproduced, fixed and judged by a different checker who saw only the findings and the diff.

- **Round 1.** Finite Difference: the d'Alembert condition is G(z) = −F(−z) with F of period 2a (Error; Mathews' proof has the same proviso, and the page now says so); the proof's F and G labels; "suitable" implicit methods have no stability restriction (not every implicit method); the Case 3 alt text on |c₉| (with a "since then" clause added by the fixer). Elliptic: "its E rises only once" is SOR's, and the Gauss-Seidel error is largest at the centre "from sweep 109 on".
- **Round 2.** Elliptic: the insulated-edge hump (up to 16 and 18 above the exact values) that travels left before the values settle from above, with the ω = 1.5325 run's dip of 0.59 (Misleading). Finite Difference: the grid diagonals lie on the characteristics when r = 1; Mathews' grid is claimed only for Examples 1 and 2.
- **Round 3.** Finite Difference: the two corners move in opposite directions, each one grid step per time step. Elliptic: two alt texts (the error rises to 0.0004750, close to the discretisation error 0.0004755; the dip in the ω = 1.5325 run).

No GIF changed in any round.

## Open

Nothing.

## Decisions taken for Jason to revisit

1. **Set-ups chosen where Mathews' are lost:** Finite Difference Example 3's grid (b = 1.02, k = 0.051, r = 1.02), Elliptic Examples 2 and 6 (n = 21; Example 6 starts at 0, consistent with the size the module gives for Mathews' lost 40-line printout). The pages say which values are his.
2. **The d'Alembert proviso:** the page states the correct condition and says Mathews' proof has the narrower one.

## Process notes

- Reviewers returned reports as text; the director wrote them. MATLAB was not run; quarto only by the director.
- As in batch 6, the page states were committed from saved copies after the review loop finished; the final state was rendered with `quarto render pages/numerical-methods/`, which completed without errors (warnings only for section-index links to batch 8–9 pages, which are moved in the working tree and linked in their own batches' commits).

## Commits on `batch-7`

```
aa154ba Record batch 7 archive paths in the plan
02445bc Write Crank-Nicolson Method page text (batch 7)
132abc8 Write Finite Difference Method page text (batch 7)
99ff20e Write Elliptic PDE's page text (batch 7)
d1fe1fb Add Crank-Nicolson Method animations (batch 7)
208e2d4 Add Finite Difference Method animations (batch 7)
a222d50 Add Elliptic PDE's animations (batch 7)
ae65356 Add batch 7 review
f4cd9f5 Fix Finite Difference Method (batch 7 review)
27604c6 Fix Elliptic PDE's (batch 7 review)
7e982f7 Add batch 7 review, round 2
f6c63a1 Fix Finite Difference Method (batch 7 review, round 2)
df0675f Fix Elliptic PDE's (batch 7 review, round 2)
bd3e116 Add batch 7 review, round 3
25a2d0f Fix Finite Difference Method (batch 7 review, round 3)
cda35fc Fix Elliptic PDE's (batch 7 review, round 3)
```
