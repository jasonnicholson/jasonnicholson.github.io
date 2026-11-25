# Review: Finite Difference Method for the wave equation (batch 7, round 3)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).** Calibration page for this round: the reviewer worked on a scratch copy with two planted errors in the Case 1 Behavior paragraph (the second-row error 0.2212 changed to 0.2122, and "it falls back to rounding level" at t = 0.5 and 1 changed to "it reaches its largest values") and reported both as Errors from its own computations (row errors 0.2212, 0.3692, 0.3976, … dropping to 8.88e−16 and 7.77e−16 at rows 11 and 21; frames 11 and 21). The planted findings are removed; the reviewer's one real finding stands below.

This was a fresh, independent review: the reviewer read no earlier review or fix record. Legacy archive consulted: the module HTML, solution pages lnk_2–lnk_4, notebook images gr_1–gr_81, `FiniteDifferencePDEProof.pdf`, `a2001/Animations`. Independent computations: numpy for Example 1 and the refinement study, exact rationals and sympy for Example 2, a 20000-term Fourier sine series for Example 3 (independent of the script's d'Alembert code).

## Findings

### F1 — Page match (wording) — Minor (unverified): the corners do not "move apart one grid step per time step"

- **Location:** `index.qmd` line 40 (Case 2 Behavior): "the two corners move apart one grid step $h = 0.1$ per time step $k = 0.05$, the wave speed $c = 2$."
- **True instead:** each corner moves one grid step per time step, in opposite directions, so their separation grows by 2h per step — and only until the first reflection at t = 0.2; from t = 0.2 to 0.3 the gap stays 0.8, then they approach. Read literally, the sentence gives a separation rate h/k = c instead of 2c.
- **Evidence:** corner positions in the `fdpdebb.jl` log (0.50/0.70; 0.20/1.00; 0.10/0.90; 0.00/0.80) and fold(0.6 ± 2t) by hand.
- **Fix:** "the two corners move in opposite directions, each one grid step $h = 0.1$ per time step $k = 0.05$, the wave speed $c = 2$" (the wording Example 2 uses at line 358).

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (26 frames each); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D7), Animations introduction (A1–A10):** confirmed, including the round-2 wording now in place ("Mathews' grid of Examples 1 and 2 … kept for Example 3, whose grid the archive has lost").
- **Case 1 (C1.1–C1.13):** confirmed apart from the two planted sentences.
- **Case 2 (C2.1–C2.12):** confirmed except the wording in C2.2 (F1).
- **Case 3 (C3.1–C3.19):** confirmed.
- **Wave equation, derivation, starting values (W1–W8), stability (S1–S11):** confirmed.
- **d'Alembert and the theorem (T1–T8):** confirmed, including the round-1 and round-2 corrections now in place (G(z) = −F(−z) with F of period 2a; the grid diagonals align with the characteristics when r = 1; the proof's labels self-consistent).
- **Algorithm (G1–G3), Examples 1–3 (E1.1–E3.14):** confirmed (every table entry; Mathews' slips; refinement ratios; Example 3 summary and last-row tables).

## Implementation checks

- **fdpdeaa.jl:** Mathews' explicit scheme; per-row errors identical to the independent run; reference verified by sympy; frames 4, 11, 21 checked.
- **fdpdebb.jl:** exact rational agreement with d'Alembert and the page table; corner lines correct; frames 6, 11 checked.
- **fdpdecc.jl:** every quantity matches the independent run; the d'Alembert reference matches an independent Fourier series; frames 2, 21 checked.
