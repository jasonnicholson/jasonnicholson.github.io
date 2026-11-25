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

---

# Batch 8: closing summary (2026-11-25)

## Pages built

| Page | Text (Phase 1) | Animations (Phase 2) |
|---|---|---|
| [Power method](../../pages/numerical-methods/power-method/) | written from `PowerMethodMod`, all examples; tables in exact rationals | 4 new: Examples 1 and 2, the shifted-inverse method against the power method, the Markov chains of Examples 4 and 5 |
| [Jacobi and Gauss-Seidel Iteration](../../pages/numerical-methods/jacobi-and-gauss-seidel-iteration/) | already written; the builder corrected four errors in the old text (a broken `\tag`, the spectral-radius statement, a residual attribution) | 3 new: the two methods in the plane, Mathews' Example 6, Examples 2 and 4 in another equation order |
| [Successive Over Relaxation - SOR](../../pages/numerical-methods/successive-over-relaxation-sor/) | already written; the builder corrected a mix of ω = 1.25 and 1.5 and a broken `\tag` | 3 new: Jacobi, Gauss-Seidel and SOR on Example 1, the ω sweep with ω_opt = 1.528, Laplace's equation on a 5 × 5 grid |
| [Eigenvalues and Eigenvectors](../../pages/numerical-methods/eigenvalues-and-eigenvectors/) | written from `EigenvaluesMod`; adds a section on the powers AʲX₀ for the animation | 4 new: invariant directions, scaled powers, Newton–Raphson on the characteristic polynomial, rounded polynomial roots against an eigenvalue routine |
| [QR method](../../pages/numerical-methods/qr-method/) | written from `QRMethodMod`, all examples | 3 new: unshifted QR on Example 3, Householder reduction then QR on Example 4, shifts and deflation on Example 5 |
| [Jacobi method](../../pages/numerical-methods/jacobi-method/) | written from `JacobiMethodMod`, all examples | 4: classical and cyclic Jacobi on Example 1, a rebuild of Mathews' "eigenvalue movie" (Example 6, which survives as still frames in the module), and the same matrix to ε = 10⁻¹¹ |

Every GIF regenerates byte for byte from its committed script (checked by each builder, by the director, and in the review's Phase 1). Power method was the Phase 2 pilot and passed unchanged.

## Findings by round and severity

| Round | Folder | Error | Misleading | Minor | Calibration pilot (planted errors caught) |
|---|---|---|---|---|---|
| 1 | `reviews/batch-8` | 0 | 0 | 13 | Power method (2 of 2) |

With no Error or Misleading finding in round 1, no second round was required.

## What was fixed

All 13 Minor findings were reproduced, fixed and judged by a different checker who saw only the findings and the diff. Power method: Case 2's log panel described without the predicted slopes (the fixer reworded rather than adding slopes to the GIF). Jacobi and Gauss-Seidel: the 4.437–6.012 range attributed to sweeps 1–2. SOR: where Case 2 gives ρ (reworded). Eigenvalues: Example 11's 2.8 × 10⁻⁸; Case 3's bounds 7 % and 11 %; run (b)'s first step; "the table below"; two of Mathews' Example 8 eigenvectors are the negatives of the page's (the same eigenvectors). QR: d₂ and d₄ both overshoot (alt text and Behavior paragraph); the opening and closing frames of Case 3. Jacobi method: the zeroed entries include negative ones; which diagonal dots are visibly off their ticks (measured in pixels); the cyclic run passes Mathews' relative stopping test. No GIF changed.

## Open

Nothing.

## Decisions taken for Jason to revisit

1. **Eigenvalues F1 reclassified** from Error to Minor (2.9 × 10⁻⁸ for 2.849 × 10⁻⁸ is a last-digit rounding slip), as batch 4 did for 0.972.
2. **Plan corrections:** Jacobi method's legacy animation is not "none": Mathews' eigenvalue movie survives as still frames in the module and is rebuilt as Case 3 (recorded in the plan).
3. **`\tag` corruption:** the old Jacobi-Gauss-Seidel and SOR pages had a `\tag` broken into a tab character plus "ag{"; both were fixed here. The same corruption is still present in `cholesky-doolittle-and-crout-factorizations.qmd`, which is in no batch.

## Process notes

- Reviewers returned reports as text; the director wrote them. MATLAB was not run; quarto only by the director.
- As in batches 6 and 7, the page states were committed from saved copies after the review loop finished; the final state was rendered with `quarto render pages/numerical-methods/`, which completed without errors (warnings only for section-index links to batch 9 pages, which are moved in the working tree and linked in batch 9's commits).

## Commits on `batch-8`

```
1b75775 Record batch 8 archive paths in the plan
723ea8d Write Power method page text (batch 8)
d37e96f Write Jacobi method page text (batch 8)
ba89645 Write QR method page text (batch 8)
f837912 Write Eigenvalues and Eigenvectors page text (batch 8)
d828128 Add Power method animations (batch 8)
de1ff9c Add Jacobi and Gauss-Seidel Iteration animations (batch 8)
741b9b6 Add Jacobi method animations (batch 8)
cb4b90a Add QR method animations (batch 8)
a52062d Add Eigenvalues and Eigenvectors animations (batch 8)
8f4e418 Add Successive Over Relaxation - SOR animations (batch 8)
5d6d12f Add batch 8 review
693e615 Fix Power method (batch 8 review)
ea5224c Fix Jacobi and Gauss-Seidel Iteration (batch 8 review)
ace0b0b Fix Successive Over Relaxation - SOR (batch 8 review)
eda0a19 Fix Eigenvalues and Eigenvectors (batch 8 review)
8dfd1bf Fix QR method (batch 8 review)
45fd23a Fix Jacobi method (batch 8 review)
```
