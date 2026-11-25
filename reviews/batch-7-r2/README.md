# Batch 7 review, round 2

**Pages reviewed: 2 of 2** (the pages changed in the round-1 fixes: Finite Difference Method, Elliptic PDE's; Crank-Nicolson had no round-1 findings and was not changed). None skipped.

**Findings: 0 Error, 1 Misleading (independently confirmed), 2 Minor.** The Misleading finding means a third round is required for the pages changed by this round's fixes.

This was a fresh, independent review: reviewers did not read round 1's reports or the fix records, and did not compare a page with any other copy of it. Each reviewer's claim ledger covered the whole page, and every reviewer consulted the legacy archive. The pages were reviewed from the working tree in their round-1-fixed state (saved and committed as the "Fix … (batch 7 review)" commits).

## Calibration

Elliptic PDE's was the calibration page this round. Its reviewer worked on a scratch copy with two planted errors in Case 1 (the error after ten sweeps 1.080 changed to 1.060, and "decrease at every sweep" changed to "rise at least once before they fall") and reported both as Errors from its own computations. It also found one real finding (below), which an independent checker confirmed; that review, with the planted findings removed, stands as Elliptic's round-2 review.

## The findings

- **Elliptic PDE's F1 (Misleading, confirmed):** the insulated-edge values do not simply "bend up toward" the exact values: a hump up to about 16 (Mathews' run) and 18 (ω = 1.5325) above them travels left along the edge before the values settle from above.
- **Finite Difference F1:** it is the grid diagonals, not the grid lines, that lie on the characteristics when r = 1.
- **Finite Difference F2 (fidelity):** two sentences call n = 11, m = 21 Mathews' grid for all three examples; Example 3's grid is the page's reconstruction.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [elliptic-pdes](elliptic-pdes.md) | 4 | 4 | 0 | 1 | 0 | reviewed (calibration pilot) |
| [finite-difference-method](finite-difference-method.md) | 3 | 3 | 0 | 0 | 2 | reviewed |

## Comparison with round 1

None of round 1's findings came back; each reviewer confirmed the round-1 corrections now on the page (the d'Alembert boundary condition, the proof's F/G labels, the implicit-method wording and the |c₉| alt text; "SOR's E rises only once" and "largest at the centre from sweep 109 on"). Elliptic F1 concerns a sentence round 1 confirmed; this round's direction-word ledger found the overshoot in the frames and the computed edge values.
