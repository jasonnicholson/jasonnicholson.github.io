# Review: Power method (batch 8, round 1)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).** Calibration page: the reviewer worked on a scratch copy with two planted errors in the Case 2 Behavior paragraph (a number with transposed digits and "move away from" for "settle onto") and reported both as Errors from its own computations (see the README). The planted findings are not reported; the committed page's versions were confirmed by the same reviewer (x₂, x₅ of X₄₀ = 3.575674e−6 and 3.575675e−6, both 3.576e−6; the 2-norm error falls at every step, largest ratio 0.924 at k = 4).

Legacy archive consulted: `PowerMethodMod.html`, Links 2–6, the PowerMeth and InvPowerMeth listings, call arguments, every printout and the Markov outputs; `a2001/Animations` has no eigenvalue animation. Independent computations: every example in exact Python `Fraction` arithmetic, 60-digit mpmath norms, sympy eigensystems, and a parser checking every table entry on the page at its stated precision.

## Findings

### F1 — Page match — Minor (unverified): the Animations introduction says every log panel has grey dashed predicted slopes; Case 2's has none

- **Location:** `index.qmd` line 22: "A panel with a logarithmic axis shows how fast the errors shrink … and grey dashed lines show the slopes that the eigenvalue ratios predict."
- **True instead:** `poweraa.jl`, `powercc.jl` and `powerdd.jl` draw grey dashed reference slopes; `powerbb.jl` (lines 101–131) draws none, and the Case 2 frames confirm there is no dashed slope line.
- **Fix:** add (3/4)^k and (1/4)^{k/2} reference lines to `powerbb.jl`, or reword to "in Cases 1, 3 and 4, grey dashed lines show…".

No Fidelity findings: every archive example (1–5) is reproduced with Mathews' matrices, starting vectors, tolerances and iteration counts (22, 40, 10; Markov terms match his printouts); the one departure (Example 4 extended to month 12) is stated.

## Inventory (Phase 1)

4 scripts, 4 GIFs (26, 44, 29, 16 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description, theory, algorithm (D1–D11):** confirmed (maxsize rule against Mathews' listing gr_69; c₀ = 0; ties to the positive coordinate; test (4); r/(1 − r) error factor).
- **Example 1 (E1.1–E1.12):** confirmed, including the exact steps, all 110 table entries, 22 printout lines (gr_74–95), eigenvalues 4, 2, 1 and the decomposition of X₀, c_k − 4 = 16/(5·2ᵏ − 8) for k = 1…22, error ratios rising to 0.49999981, the Aitken table, unit vector (0.324443, 0.486664, 0.811107).
- **Example 2 (E2.1–E2.12):** confirmed, including c₂ = 4 exactly, the 40-row table, Mathews' printout (he prints 3.575670), eigenvalues 4, 3, 2, 1, −1, −2 and coefficients, e_k/e_{k−1} = 0.7500 from k = 20, the closed form of the 4th coordinate, sign alternation, ratios → −7/22 and −11/14, step 1.954e−6 vs error 5.862e−6.
- **Shifted inverse and Example 3 (S1–S3, E3.1–E3.9):** confirmed (InvPowerMeth gr_215; μ values; exact steps; 10-row table; ratio → 1/11; plain method 36 iterations to 6.2e−11, 25 at ε = 1e−7 with 9.5e−8).
- **Markov chains (M1, E4.1–E5.4):** confirmed, including all table rows, eigenvectors, exact P_k formulas, deviations and ratios (0.3013 at k = 11; z_k − 3600 = 1400(0.4)^k).
- **Animations (A1–A3, C1.1–C4.8):** confirmed except A1 for Case 2 (F1); Case 1 closed form X_k − V₁ = (3, 2, 0)/(5(5·2^k − 4)); Case 2 vector-error ratio 0.7500 from k = 23 (2-norm); Case 3 stops (k = 10: 6.169e−11, 5.560e−12; k = 25: 9.537e−8, 4.298e−9); Case 4 month-6 deviations 1.362 and 5.734, 0.001057 and 0.02349 at k = 12.

## Implementation checks

- **poweraa.jl:** Mathews' PowerMeth exactly; c₂₂ − 4 = 7.629397e−7, ‖X₂₂ − V₁‖ = 3.438522e−8, step 7.629403e−7 identical to the exact run; V₁ and W₂ true eigenvectors; labels match the exact offsets.
- **powerbb.jl:** same algorithm; c₄₀ − 4 = −1.6977e−12, verr 5.8618e−6, step 1.95394e−6; AV₁ = 4V₁; markers follow the sign; the k = 2 zero masked and annotated; no reference slope (F1).
- **powercc.jl:** InvPowerMeth with one exact LU, each solve verified, "≤ ε", estimate α + 1/c; plain run with "<" at 1e−7; values identical to the independent run.
- **powerdd.jl:** exact Markov iteration; deviation sequences identical; slopes 0.3ᵏ and 0.4ᵏ anchored at month 12.
