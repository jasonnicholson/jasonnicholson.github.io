# Batch 7 review, round 3

**Pages reviewed: 2 of 2** (the pages changed in the round-2 fixes: Finite Difference Method for the wave equation, Elliptic PDE's). None skipped.

**Findings: 0 Error, 0 Misleading, 3 Minor (unverified).** With no Error or Misleading finding, there was nothing for independent checking, and no further round is required. No implementation or drawing error on either page; every GIF is byte-identical to what its script produces.

This was a fresh, independent review: reviewers did not read earlier rounds' reports or the fix records, and did not compare a page with any other copy of it. Each reviewer's claim ledger covered the whole page, and both reviewers consulted the legacy archive. The pages were reviewed from the working tree in their round-2-fixed state (saved, and committed as the "Fix … (batch 7 review, round 2)" commits).

## Calibration

Finite Difference Method was the calibration page this round. Its reviewer worked on a scratch copy with two planted errors in Case 1 (the second-row error 0.2212 changed to 0.2122, and "at t = 0.5 and t = 1 it falls back to rounding level" changed to "it reaches its largest values") and reported both as Errors from its own computations. Its one real finding stands as that page's round-3 review.

## The findings

- **Finite Difference Method F1:** the two corners do not "move apart one grid step per time step"; each moves one step, in opposite directions (and the gap closes after the reflections).
- **Elliptic PDE's F1:** the Case 4 alt text says the error "rises to" the discretisation error 0.0004755; it reaches 0.0004750.
- **Elliptic PDE's F2:** the Case 2 alt text says both runs settle "from above"; the ω = 1.5325 run dips 0.59 below at sweep 8 (the Behavior paragraph says so).

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [finite-difference-method](finite-difference-method.md) | 3 | 3 | 0 | 0 | 1 | reviewed (calibration pilot) |
| [elliptic-pdes](elliptic-pdes.md) | 4 | 4 | 0 | 0 | 2 | reviewed |

## Comparison with earlier rounds

Elliptic F2 is a remnant of round 2's Misleading F1 (the insulated-edge overshoot): the Behavior paragraph was corrected in full, including the dip, but the alt text kept an unqualified "from above". No other earlier finding came back. Both reviewers independently confirmed the earlier corrections now on the pages: the d'Alembert extension G(z) = −F(−z), the diagonal alignment at r = 1 and the proof's labels (Finite Difference); SOR's single rise at sweep 39, the Gauss-Seidel error largest at the centre from sweep 109, and the hump and dip of Case 2 (Elliptic).
