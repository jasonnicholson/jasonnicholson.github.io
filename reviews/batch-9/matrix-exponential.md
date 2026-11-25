# Review: Matrix Exponential (batch 9, round 1)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).**

Legacy archive consulted: `MatrixExponentialMod.html`, Links lnk_1–lnk_10, images gr_131, 133, 184–186new, 191, 202–206, 211, 222–226, 231, 234–235, 240–242, 246, 254, 257–258, 266; the animation archive has no folder for this module. Independent computations: sympy closed forms for all six examples (ODE, initial values, PDP⁻¹), 60- and 200-digit mpmath partial sums with grid checks, SciPy `expm`, RK45 trajectories.

## Findings

### F1 — Page match — Minor (unverified): the norm bound fails for the n = 0 term

- **Location:** `index.qmd` line 225: "in any matrix norm, the $n$-th term is at most $(\lVert\mathbf{A}\rVert\,|t|)^n/n!$".
- **True instead:** the bound needs a submultiplicative norm and, for n = 0, ‖I‖ ≤ 1; for the (submultiplicative) Frobenius norm ‖I₂‖_F = √2 > 1. The convergence conclusion is unaffected.
- **Fix:** "in any submultiplicative matrix norm, the $n$-th term ($n \ge 1$) is at most …", or name an operator norm.

### F2 — Page match — Minor (unverified): "Every term has positive entries" — the n = 0 term is I

- **Location:** Case 1 Behavior (line 36): "Every term has positive entries, so for $t > 0$ each partial sum lies below the exact entry"; the same claim in Example 1 (line 326): "Every term of the series has positive entries here".
- **True instead:** I has zero off-diagonal entries; the terms are nonnegative, and positive for n ≥ 1 (Aⁿ = ½[3ⁿ+1, 3ⁿ−1; …]). The conclusions hold: at 200 digits on a 1/400 grid of (0, 2] for N = 1…20 every error is positive, the diagonal error is at least the off-diagonal one, and each error rises with t (`ex1b.py`, no violations).
- **Fix:** "every term after the first has positive entries", or "nonnegative entries".

No Fidelity findings (Example 6 follows the matrix of Mathews' worked solution and says so; Example 2's lost graphs and Example 1's absent graph are stated).

## Inventory (Phase 1)

4 scripts, 4 GIFs (23, 79, 89, 109 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 116 entries; reviewer's verdicts)

- **Description and Animations introduction (1–12):** confirmed (series and diagonalization forms; Φ(t)Φ(0)⁻¹; Mathews' starting points, windows, colours and view point gr_184, 204, 224; lost Example 2 graphs).
- **Case 1 (13–28):** confirmed except 17 (F2): partial sums below the exact entry for t > 0; each term lowers the error; errors rise with t; 10.40 → 8.350e−10 at t = 1 through 1.860, 0.01107, 6.733e−6; 1.045e−3 at t = 2; e^{3t} sets the pace.
- **Case 2 (29–39):** confirmed: e^{At} = e^{−t}R(2t); radius 2 → 0.06039; counterclockwise; 7 rad ≈ 1.114 turns.
- **Case 3 (40–51):** confirmed: view point (2, −4, 1) angles; distance from x = y falls from 1.414 to 0.02590; corners in the plane; ellipse of period π; 2e^{−2t} = 0.0006709 at t = 4.
- **Case 4 (52–60):** confirmed: slowest eigenvector (2, −2, −3); no corner with x₀ − y₀ + z₀ = 0; angle 81.95° → 0.6895°, rising twice before t = 0.75; distance 12.25 → 0.1898, decreasing every frame.
- **Body text and Examples 1–6 (61–116):** confirmed except 68 (F1): A², A³ entries; S₁₀ coefficients vs gr_131/133; e^{A}; both tables; Examples 2–5 closed forms agree with Mathews; extents; Example 6's statement matrix is defective and his solution uses another; y₁…y₄ and their turning points. Library- and solver-dependent verification residuals CND (own values consistent).

## Implementation checks

- **matexpaa.jl:** truncated Taylor series with exact BigInt powers, summed in 512-bit; titles match 60/200-digit values; panels contain every value; frames 1, 5, 20 checked.
- **matexpbb.jl:** closed form asserted against `exp(A t)` to 1e−14; frames 1, 21, 71 checked; left panel reproduces gr_185.
- **matexpcc.jl:** closed form asserted to 1e−14; camera matches Mathews' view point; frames 1, 21, 81 checked.
- **matexpdd.jl:** closed form asserted to 1e−13 and matched to 40-digit mpmath; angle and distance values match; frames 1, 21, 101 checked.
