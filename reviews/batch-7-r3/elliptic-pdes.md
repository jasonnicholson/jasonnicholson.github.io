# Review: Elliptic PDE's (batch 7, round 3)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).**

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: the module HTML, the seven Links pages, every surviving image (programs, set-ups, printouts and plots of Examples 1, 3, 4, 5 and the statement of Example 6), `EllipticPDEProof.pdf` (textbook §10.3, so every textbook claim was checked). Independent computations: own SOR and Gauss-Seidel sweeps on a differently laid-out plate array, sparse direct solves, iteration-matrix spectral radii, 50-digit five- and nine-point error ratios, Example 6 series coefficients by 30-digit quadrature with k ≤ 800.

## Findings

### F1 — Page match (alt text) — Minor (unverified): the Case 4 error does not quite "rise to" the discretisation error

- **Location:** `index.qmd` line 64, alt text of `ellipticdd.gif`: "…while the error against Laplace's equation rises to the discretisation error 0.0004755".
- **True instead:** the discretisation error max|u* − u_exact| is 0.000475516; at sweep 60, the last frame, max|u − u_exact| is 0.000475037 (0.0004750 to the four figures the alt text uses). It approaches 0.0004755 without reaching it. The Behavior paragraph (line 60) is right ("to 0.000475").
- **Evidence:** `ex6.py`: `sweep60 … |u-uex| 0.000475037`, `disc 0.000475516`; the script log agrees.
- **Fix:** "…rises to 0.000475, almost exactly the discretisation error 0.0004755" (or "rises towards the discretisation error 0.0004755").

### F2 — Page match (alt text, direction word) — Minor (unverified): "settle onto the exact values from above" omits the ω = 1.5325 dip

- **Location:** line 48, alt text of `ellipticbb.gif`: "…the values on the insulated edge in that run and in a run with omega = 1.5325, which … then settle onto the exact values from above".
- **True instead:** true of the ω = 1.446463 run (every bottom-edge value at or above the exact value from sweep 3 on); in the ω = 1.5325 run the value at x = 0.125 is 0.588 below the exact value at sweep 8. The Behavior paragraph (line 44) states this exception.
- **Evidence:** `ex3.py`, ω = 1.5325: `k= 8 maxdev +0.671 at x=0.500 mindev -0.588 at x=0.125`.
- **Fix:** "settle onto the exact values, mostly from above", or add "(apart from a small dip in the ω = 1.5325 run at sweep 8)".

No Fidelity findings. Noted by the reviewer, not findings: Gauss-Seidel's "10 sweeps per frame" in Case 3 has a first step of 3 and a last of 7; a long Case 1 surface-panel title touches the contour panel's title (both readable); colour-bar ticks 0, 25, … instead of the requested 0:30:180 (cosmetic).

## Inventory (Phase 1)

4 scripts, 4 GIFs; all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 156 entries; reviewer's verdicts)

- **Description (1–6), Animations introduction (7–15):** confirmed (SOR update and stopping test as Mathews' programs; 20 sweeps; Example 4 = Example 1 relabelled; Example 5 stops after 19 sweeps).
- **Case 1 (16–25):** confirmed: 1.080 after ten sweeps; both sequences decrease at every sweep; 66.0101 → 0.000605833; 75.41 → 0.000672; centre 70.0003.
- **Case 2 (26–42):** confirmed except the alt-text clause in 41 (F2), including the round-2 wording now in place: the hump moves left, about 16 and 18 above; settles from above; the dip of 0.59 at x = 0.125 in sweep 8; within 1 by sweeps 11 and 8; stops at 30 and 23.
- **Case 3 (43–58):** confirmed: 47 sweeps, E 0.000753, 0.00234; GS 5.309 away with both signs; SOR's E rises only at sweep 39, at (0.05, 0.95); GS positive from sweep 81, largest at the centre from sweep 109; factor 0.970–0.976; 227 sweeps, 0.0394.
- **Case 4 (59–68):** confirmed except the alt-text clause in 67 (F1): 1.40154 → 0.000865966; 0.000324 less than 0.000476; partial cancellation; the error against Laplace's equation rises at every sweep after the 40th.
- **Theory (69–94):** confirmed (5×5 system and exact P by sympy; symmetry; (11) and spectral radii; nine-point ratios 4.0 and 64.0).
- **Examples 1–6 (95–156):** confirmed (every E sequence against Mathews' printouts; Table 10.6's 124.821 slip; Example 2's 27-entry comparison; Example 3's 56 entries against Table 10.7; Example 5's 19 sweeps; Example 6's series, table and order table). No CND entries.

## Implementation checks

- **ellipticaa.jl:** Mathews' Dirichlet SOR (gr_17) line for line; all 20 E and error values identical to the independent run; frames 1, 4, 27 checked.
- **ellipticbb.jl:** Mathews' Neumann program (gr_53); the 56-unknown direct solve correct; both runs identical to the independent run; frames 4, 10, 38 checked.
- **ellipticcc.jl:** SOR and Gauss-Seidel; 47 and 227 sweeps; frames 43, 84 checked.
- **ellipticdd.jl:** Example 5 storage, start 0, 60 sweeps; series reference gives the same discretisation error as an independent k ≤ 800 series; frames 1, 44, 78 checked.
