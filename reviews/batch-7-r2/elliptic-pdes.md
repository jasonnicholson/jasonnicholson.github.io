# Review: Elliptic PDE's (batch 7, round 2)

**Findings: 0 Error, 1 Misleading (independently confirmed), 0 Minor.** Calibration page for this round: the reviewer worked on a scratch copy with two planted errors in the Case 1 Behavior paragraph (the error after ten sweeps 1.080 changed to 1.060, and "both E and max|u − u*| decrease at every sweep" changed to "rise at least once before they fall") and reported both as Errors from its own computations (1.08026; both sequences strictly decreasing, confirmed in frame 27 and against Mathews' printout gr_20). The planted findings are removed; the reviewer's one real finding stands below.

This was a fresh, independent review: the reviewer read no earlier review or fix record. Legacy archive consulted: the module HTML, all Links pages, program, set-up, printout and plot images, `EllipticPDEProof.pdf` (textbook §10.3). Independent computations: an own Python SOR/Gauss-Seidel in Mathews' order and in coordinate order, sparse direct solves, iteration-matrix spectral radii, four-edge Fourier series, a 60-digit nine-point study. The checker wrote a separate implementation of Mathews' Neumann sweep.

## Findings

### F1 — Page match (direction word) — Misleading (confirmed by an independent checker): the insulated-edge values overshoot the exact values before settling

- **Location:** `index.qmd` line 44 (Case 2 Behavior): the insulated-edge values "start on the straight line from $80$ to $0$, bend up toward the exact values $75.98, 71.06, \ldots, 16.15$ of the difference equations, and are within $1$ of them by sweep $11$ in both runs"; the alt text at line 48 ("bending from a straight line to the exact values") says the same.
- **True instead:** in both runs a hump well above the exact values travels left along the edge in the first sweeps, then the whole edge settles onto the exact values from above. Bottom edge minus exact: with ω = 1.446463 the largest excess is +16.21 at x = 0.75 in sweep 1 (47.5 against 31.30), +15.44 in sweep 2, +12.39, +9.26, +6.33, +4.08, then +2.87, +1.90, +1.41, +1.05, +0.76 by sweep 11, and from sweep 3 on every edge value is above the exact one; with ω = 1.5325 it is +18.00 in sweep 1 and +18.44 in sweep 2, then values above from sweep 4 on (apart from two dips of about 0.5–0.6). "Within 1 by sweep 11 in both runs" holds (sweep 11 and sweep 8).
- **Evidence:** reviewer `ex3b.py`; checker `check/bb.py` (exact edge 75.9762 … 16.1495; stops at 30 and 23 sweeps as on the page); committed frames 3, 4, 6, 8 of `ellipticbb.gif` (sweep 1: both curves hump to about 47–49 at x = 0.75 against about 31; sweep 2: about 60 and 63 against 45 at x = 0.625; sweeps 4 and 6: both curves above the black curve along nearly the whole edge).
- **Fix:** "They start on the straight line from $80$ to $0$. In the first sweeps a hump well above the exact values $75.98, 71.06, \ldots, 16.15$ of the difference equations moves to the left along the edge, up to $16$ above them in Mathews' run and $18$ with $\omega = 1.5325$; the values then settle onto the exact values from above and are within $1$ of them by sweep $11$ in Mathews' run and by sweep $8$ with $\omega = 1.5325$." Reword the alt text (line 48) to match.

No Fidelity findings. (Note from the reviewer, not a finding: the section index does not yet link this page; it is linked in the page's "Add animations" commit.)

## Inventory (Phase 1)

4 scripts, 4 GIFs (27, 38, 84, 78 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D5), Animations introduction (A1–A9):** confirmed.
- **Case 1 (C1.1–C1.9):** confirmed apart from the two planted sentences.
- **Case 2 (C2.1–C2.11):** confirmed except C2.3 (F1).
- **Case 3 (C3.1–C3.15):** confirmed, including the round-1 wording now in place: SOR's E rises only once, at sweep 39; the Gauss-Seidel error is largest at the centre from sweep 109 on.
- **Case 4 (C4.1–C4.11):** confirmed.
- **Theory (T1–T28):** confirmed (5×5 system and exact P; symmetry argument; (11) as the Young optimum; spectral radii; nine-point ratios 64 and 4).
- **Examples 1–6 (E1.1–E6.13):** confirmed (every E sequence against Mathews' printouts; tables; Textbook Table 10.6's 124.821 slip; Example 2 comparison; Example 3 raises every value; Example 5's 19 sweeps; Example 6 series and refinement ratios).

## Implementation checks

- **ellipticaa.jl:** Mathews' Dirichlet SOR line for line; every E and error identical to the independent run; frames 12 and 27 checked.
- **ellipticbb.jl:** Mathews' Neumann program; both runs identical to the independent implementation; the edge-value axis (0–90) contains the overshoot, which the frames draw clearly — F1 concerns the text only.
- **ellipticcc.jl:** SOR and Gauss-Seidel; 47 and 227 sweeps; frames 43, 51, 84 checked.
- **ellipticdd.jl:** Example 5 storage, start 0, 60 sweeps; series reference agrees with an independent series to 7 digits; frames checked.
