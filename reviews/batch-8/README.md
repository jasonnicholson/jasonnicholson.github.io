# Batch 8 review, round 1

**Pages reviewed: 6 of 6** (Power method, Jacobi and Gauss-Seidel Iteration, Successive Over Relaxation - SOR, Eigenvalues and Eigenvectors, QR method, Jacobi method). None skipped.

**Findings: 0 Error, 0 Misleading, 13 Minor (unverified).** With no Error or Misleading finding, there was nothing for independent checking. No implementation or drawing error on any page: every script runs the method its page names, every value checked matches an independent computation (exact rationals, 50–300-digit arithmetic), and every committed GIF is byte-identical to what its script produces.

Because the page text was written in this batch, each reviewer's claim ledger covered the whole page. The legacy Mathews archive was consulted by every reviewer.

**How this batch was reviewed.** Batches 6–9 were reviewed from the working tree before their pages were committed, so that batches 5–9 could be reviewed in parallel; the reviewed state of each page folder was saved and is exactly what the "Add … animations (batch 8)" commits contain. Section-index links are changed in those commits, so reviewer findings about the section index were withdrawn.

**Director's reclassification.** The Eigenvalues reviewer rated the Example 11 entry 2.9 × 10⁻⁸ (true 2.849 × 10⁻⁸) an Error "with small effect". It is a last-digit rounding slip (2.849 rounded twice), which the review standard does not count as wrong beyond the last digit, so it is recorded as Minor, as batch 4 recorded 0.972 for 0.971.

## Calibration

Power method was the calibration page. Its reviewer worked on a scratch copy with two planted errors in Case 2 (3.576e-6 changed to 3.756e-6, and "the bars settle onto the black marks" changed to "move away from") and reported both as Errors from its own computations, without comparing the copy with the repository. The planted findings are not in this report; the real page's versions were confirmed by the same reviewer, and that review stands as the Power method review.

(This calibration ran on the brief as it stood before batch 5's calibration exposed a weakness; it was judged on independence and passed. The other five pages were reviewed with the corrected brief.)

## The findings

- **Power method F1:** the introduction says every log panel has grey dashed predicted slopes; Case 2's has none.
- **Jacobi and Gauss-Seidel F1:** Case 3 states the Jacobi ratio range 4.437–6.012 as if it held after 10 sweeps; both ends come from sweeps 1–2.
- **SOR F1:** "each legend gives ρ" is false for Case 2 (ρ is in the panel titles).
- **Eigenvalues F1:** Example 11 table 2.9 × 10⁻⁸ → 2.8 × 10⁻⁸.
- **Eigenvalues F2:** Case 3's "within 6 % / 10 %" bounds are measured the wrong way round (6.07 %, 10.98 %).
- **Eigenvalues F3:** "vertical line up … tangent down" is wrong for run (b)'s first step.
- **Eigenvalues F4:** "the table above" is below.
- **Eigenvalues F5 (fidelity):** two of Mathews' Example 8 eigenvectors are the negatives of the page's.
- **QR F1:** the Case 1 alt text says one diagonal entry overshoots; two do (d₂ and d₄).
- **QR F2:** not every Case 3 frame is a step or a deflation (opening and closing frames).
- **Jacobi method F1:** "brings the surface down to 0" — two zeroed entries are negative.
- **Jacobi method F2:** not all five diagonal dots are visibly off their ticks.
- **Jacobi method F3:** the cyclic run passes Mathews' relative stopping test, not the absolute tolerance 10⁻¹¹.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [power-method](power-method.md) | 4 | 4 | 0 | 0 | 1 | reviewed (calibration pilot) |
| [jacobi-and-gauss-seidel-iteration](jacobi-and-gauss-seidel-iteration.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [successive-over-relaxation-sor](successive-over-relaxation-sor.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [eigenvalues-and-eigenvectors](eigenvalues-and-eigenvectors.md) | 4 | 4 | 0 | 0 | 5 | reviewed |
| [qr-method](qr-method.md) | 3 | 3 | 0 | 0 | 2 | reviewed |
| [jacobi-method](jacobi-method.md) | 4 | 4 | 0 | 0 | 3 | reviewed |

## Fidelity findings (for Jason to decide as a group)

- Eigenvalues F5: Example 8's "agree with Mathews' Eigensystem output" omits that two of his eigenvectors have the opposite sign.

## Patterns

- **Statements about every panel, frame or case** that hold for most but not all (Power F1, SOR F1, QR F2).
- **Direction words checked against one run but not another** (Eigenvalues F3, Jacobi method F1, QR F1).
- **Ranges and bounds whose reference point is implicit** (Jacobi-GS F1, Eigenvalues F2, Jacobi method F3).

## Phase 1 inventory

All 21 scripts ran from scratch copies against the global Julia environment (Plots 1.41.2) and reproduced all 21 committed GIFs byte for byte. Every page reference resolves.
