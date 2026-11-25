# Review: Elliptic PDE's (batch 7, round 1)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

Legacy archive consulted: `EllipticPDEMod.html`, Links lnk_1–lnk_7, the readable images (program gr_17, gr_53; Example 1 gr_18–30; Example 3 gr_55–65; Example 4 gr_70–75; Example 5 gr_85–88; Example 6 gr_93–96), `EllipticPDEProof.pdf` (textbook section 10.3); the animation archive has no PDE folder. Independent computations: an own SOR solver with different storage and loop order, SciPy sparse direct solves, iteration-matrix eigenvalues in Mathews' sweep order, Fourier-series references cross-checked with mpmath, order-of-accuracy studies.

## Findings

### F1 — Page match — Minor (unverified): "Its E rises only once" reads as Gauss-Seidel

- **Location:** `index.qmd` line 52 (Case 3 Behavior): "...at the same sweep Gauss-Seidel is still $5.309$ from it, with errors of both signs. Its E rises only once, at sweep $39$, at the grid point $(0.05, 0.95)$..."
- **True instead:** "Its" follows a sentence about Gauss-Seidel, but it is SOR's E that rises once (sweep 39, 0.127639 → 0.138959); Gauss-Seidel's E never rises in its 227 sweeps (and two sentences later the page says so).
- **Evidence:** `ex2.py`: "E rises at [39]" for SOR; "GS E monotone True"; script log "GS E rises at sweeps Int64[]".
- **Fix:** "SOR's $E$ rises only once, at sweep $39$, ...".

Observation, not a finding: the same paragraph says Gauss-Seidel's error is "positive at every interior point from sweep 81 on and largest at the centre". Positivity from 81 is correct; the largest error is at the centre from sweep 109 on and at the stop. The fixer may tighten this to "…and, by the stop, largest at the centre".

No Fidelity findings: Examples 1, 3, 4 and 5 reproduce Mathews' printouts value for value; Examples 2 and 6 use set-ups the page chose because his images are missing, and it says so.

## Inventory (Phase 1)

4 scripts, 4 GIFs (27, 38, 84, 78 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 126 entries; reviewer's verdicts)

- **Description (1–5):** confirmed (five-point equation, SOR update, stopping test, 20 sweeps for the 9×9 problem).
- **Animations introduction (6–14):** confirmed (Mathews' starts, order and stopping test; h cancels; u* by direct solve; no archive animation; case-to-example mapping; missing set-up images).
- **Case 1 (15–23):** confirmed: ω = 1.446463; 1.080 after ten sweeps; E and max|u − u*| decrease at every sweep, 66.0101 → 0.000605833 and 75.41 → 0.000672; centre 70.0003 (exactly 70 for the difference equations).
- **Case 2 (24–35):** confirmed: insulated-edge values bend up toward 75.98 … 16.15; within 1 by sweep 11; right-angle contours; monotone in both runs; ω = 1.446463 stops at 30 with 0.000998 and error 0.00273 (> tolerance); ω = 1.5325 (optimum 1.532494) stops at 23 within 0.000392.
- **Case 3 (36–50):** confirmed except the pronoun in 40 (F1): start 96.13; SOR stops at 47 with 0.000753, within 0.00234; GS 5.309 away at 47 with both signs; rise at (0.05, 0.95); GS monotone, below 0.001 at 227, still 0.0394 away (39×); positive from 81; ratio 0.970–0.976 per sweep.
- **Case 4 (51–60):** confirmed: E 1.40154 → 0.000865966 at 40, one rise at 39; 0.000324 < disc error 0.000476 by partial cancellation; max|u − u*| falls to 7.69e-7, max|u − u_exact| rises after sweep 40 to 0.000475; peak at (0.5, 0.25).
- **Theory (61–90):** confirmed (O(h²); a = (n − 1)h vs Mathews' "a = nh"; 5×5 system and exact P; symmetry argument for 70; Neumann stencils; (11) and the spectral radii 0.446463, 0.729454 vs GS 0.853553, 0.975528; algorithm with at most 71 sweeps; (13), (14); nine-point ratios 64 (O(h⁶)) for harmonic functions, 4 for e^x sin 2y).
- **Examples 1–6 (91–126):** confirmed (all E sequences against Mathews' printouts digit for digit; result tables; Table 10.6's 124.821 slip; Example 2 Fourier comparison, factor 1.4–6.4; Example 3 raises every value above Example 1; Example 5's 19 sweeps; Example 6 series and order table with ratios 3.84–3.99).

## Implementation checks

- **ellipticaa.jl:** faithful transcription of Mathews' Dirichlet program (gr_17); E and error sequences identical to the independent solver and to gr_20/gr_28; orientation correct; 27 frames.
- **ellipticbb.jl:** Mathews' Neumann program (gr_53) with the bottom-edge update; direct solver has the right edge weights; all 30 E values match gr_57; ω = 1.5325 optimum from own eigenvalues.
- **ellipticcc.jl:** same program on 21×21, GS with the cap raised to 1000; SOR and GS sequences match; heatmaps symmetric and rescaled per frame.
- **ellipticdd.jl:** Example 5 storage; series reference overflow-safe and sufficient (own series to k = 2001 agrees); frames 44 and 78 checked.
