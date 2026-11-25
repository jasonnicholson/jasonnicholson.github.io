# Review: Lotka-Volterra Model (batch 5, round 2)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).**

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: the module HTML, solution pages lnk_2–lnk_7, the program and output images of Examples 2, 4, 5, 6, and the `a2001/Animations` tree. Independent computations: own RK4, SciPy DOP853 (rtol 2.3e−14), mpmath `odefun` at 30 digits, scipy `lambertw`, angle measurements of the current points.

## Findings

### F1 — Page match — Minor (unverified): the "end-point error" column uses the largest-component error without saying so

- **Location:** `index.qmd` lines 296–300 (Example 2 Results table), column "end-point error": 1.8 × 10⁻⁷, 1.6 × 10⁻⁷, 7.6 × 10⁻⁷.
- **True instead:** the values are max-component (∞-norm) errors; elsewhere the page measures distances between points as Euclidean ("0.0036 apart", the aside's "distance from start"). For run (a) the component differences are (−1.03e−7, +1.83e−7): Euclidean 2.10e−7, max-component 1.83e−7; runs (b) and (c) agree in both norms to the digits shown. The "about 2 × 10⁴ times smaller" claim holds either way (1.7e4 Euclidean for (a)).
- **Evidence:** `ex2b.py` (DOP853 reference (0.4386438744, 0.7315450359)).
- **Fix:** label the column "largest component error" (or give (a) as 2.1 × 10⁻⁷).

### F2 — Page match (direction word) — Minor (unverified): at t = 3.3 the outer point, not the inner, is further round

- **Location:** line 46 (Case 2 Behavior): "so the inner points pull ahead and the dotted line joining the five points bends: at $t = 3.3$ the run from $x_0 = 1.2$ has gone $0.524$ of its period and the run from $x_0 = 2$ only $0.499$."
- **True instead:** the phase fractions are correct (0.5237, 0.4994), but in the frame at t = 3.3 (frame 26) the outer point is about 10° further round (polar angle about (1, 1): 205.6° for x₀ = 2 against 195.3° for x₀ = 1.2), because the large orbit moves fast across its top. The inner points are visibly ahead only after about t ≈ 4.5 (at t = 6.6: 359.5° against 17.7°).
- **Fix:** "…so the inner runs complete a larger fraction of their periods (at $t = 3.3$, $0.524$ for $x_0 = 1.2$ against $0.499$ for $x_0 = 2$), and by $t = 6.6$ the inner points are visibly ahead round the loop and the dotted line joining the five points bends."

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (74, 68, 130 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 161 entries; reviewer's verdicts)

- **Description (1–9), Animations introduction (10–20):** confirmed, including the round-1 wording now in place: the distance from the exact orbit shows the part of the error across it.
- **Case 1 (21–34):** confirmed.
- **Case 2 (35–45):** confirmed, with 38 subject to F2.
- **Case 3 (46–59):** confirmed (both populations grow at first; rabbit low 1190.2 at 3.249; lag 0.8938; T = 5.267).
- **Equilibria, Jacobian, theorems, model (60–75):** confirmed.
- **RK and Example 1 (76–89):** confirmed (77, Mathews' slope names, not checked).
- **Example 2 (90–121):** confirmed, including the round-1 wording now in place ("end-point errors of runs (a) and (b) are about 2 × 10⁴ times smaller"); 98 as a max-norm column (F1).
- **Examples 3–5 (122–137), Example 6 (138–157):** confirmed (155, the author's reference drift 2.2e−12, CND; own reference within 8.4e−13).
- **Numerical notes (158–161):** confirmed, including the round-1 wording "detects drift off the orbit, not timing error".

## Implementation checks

- **lotkaaa.jl:** classical RK4 (order confirmed: ratios 17.3, 16.7, 16.5); ends, gap, ΔV identical; T and the half-way point match mpmath; frames 1, 25, 51, 74 checked.
- **lotkabb.jl:** five runs identical; periods match DOP853; frames 1, 26, 68 checked.
- **lotkacc.jl:** end point and ΔV identical; events and period match DOP853/mpmath; frames 20, 40, 130 checked.
