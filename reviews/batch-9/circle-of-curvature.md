# Review: Circle of Curvature (batch 9, round 1)

**Findings: 0 Error, 1 Misleading (independently confirmed), 1 Minor (unverified).**

Legacy archive consulted: `CurvatureMod.html`, solution links 2, 4, 5, 6, 8, 12, 13, images gr_13–15, 29–32, 35–38, 188–194, 212, 241, 253, 255, 257, 259, 264, 268; `a2001/Animations` has no curvature folder. Independent computations: sympy circumcircle solves and osculation checks (f, f′, f″ matched), mpmath three-point circles at t ± 1e−8 for the parametric formulas, direction and window checks over every frame.

## Findings

### F1 — Page match — Misleading (confirmed by an independent checker): the center is not "always above the parabola"

- **Location:** `index.qmd` line 42 (Case 2 Behavior): "The center $(-4x^3,\ \tfrac12 + 3x^2)$ is always above the parabola, on the side toward which it bends, …"
- **True instead:** the center is always above the tangent point and on the concave side, along the upward normal ($b - f(x) = 2x^2 + \tfrac12 > 0$). But it lies inside (above) the parabola $Y = X^2$ only when $b > a^2$, i.e. $\tfrac12 + 3x^2 > 16x^6$; with $u = x^2$, $16u^3 - 3u - \tfrac12 = (u - \tfrac12)(4u + 1)^2$, so only for $|x| < 1/\sqrt2$. The evolute crosses the parabola at $(\mp\sqrt2, 2)$; for $1/\sqrt2 < |x| \le 1$ (12 of the 41 animated points, including the paused frame at x = 1) the center is outside. At x = ±1 the center is (∓4, 3.5) where the parabola's height is 16.
- **Evidence:** reviewer `check2.py` (b > a² False for |x| ≥ 0.75, True for |x| ≤ 0.70; root 0.70710678, center (−1.41421, 2.00000)); checker's sympy factorization and grid count; frames `curvaturebb/frame_001.png` (center (4, 3.5) outside the right arm), `frame_053.png` (center (−4, 3.5) outside the left arm; the evolute visibly crosses the parabola near (±1.41, 2)).
- **Fix:** "The center $(-4x^3,\ \tfrac12+3x^2)$ lies on the upward normal, above the point itself, on the side toward which the parabola bends. It lies inside the parabola only for $|x| < 1/\sqrt2$: the evolute crosses the parabola at $(\mp\sqrt2,\,2)$, and for $|x| > 1/\sqrt2$, as at $x = 1$, the center is outside it."

### F2 — Implementation (script comment) — Minor (unverified): ties are not rounded "consistently"

- **Location:** `curvaturebb.jl` lines 38–39 (comment on `curv`): "the center (a, b) is computed exactly and rounded once (labels then round exact ties such as b(0.95) = 3.2075 consistently)".
- **True instead:** the exact rationals are converted to Float64 and printed with `%#.4g`, so the direction at an exact decimal tie depends on the Float64 value: b(±0.95) = 3.2075 → 3.208 (up), b(±0.55) = 1.4075 → 1.407 (down), a(∓0.85) = ±2.4565 → ±2.457 (up). Every label is a correct last-digit rounding; only the comment is wrong.
- **Evidence:** Python `Decimal(1.4075)`, `Decimal(3.2075)`; `regen/curvaturebb.jl.log`.
- **Fix:** drop "consistently", or round half-up from the exact rational before printing.

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (22, 53, 67 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D9):** confirmed (osculation; signed ρ and concave side; collocation limit; formulas (1)–(4), (6), (7) by sympy and three-point circles; evolute).
- **Animations introduction (A1–A15):** confirmed (Mathews' two collocation animations, 19 surviving stills gr_194–212; his h list, window and colours (gr_189, gr_193); Examples 2–3 computed at (½, ¼); Ex 6 values of t); A9 (Case 1 rebuilds his lost Ex 4 animation with the same h and window) CND, presented as a reconstruction.
- **Case 1 (C1.1–C1.19):** confirmed: center $(x(h^2-4x^2), \tfrac12(1+6x^2+h^2))$ moving in a straight line, distance $h^2\sqrt{x^2+\tfrac14}$; x = 0 radius 1, 0.505, 0.50005; x = ½ radius $\sqrt{2+h^4/2}$, faster (1.8e−5 above √2 at h = 0.1); radius decreases with h and stays above its limit; off-window notes exactly as stated.
- **Case 2 (C2.1–C2.18):** confirmed except C2.6 (F1): ρ = ½(1+4x²)^{3/2} from ½ to 5.590; circles leave the window for |x| ≥ 0.8; center moves opposite to the point horizontally; semicubical evolute with cusp (0, ½); radius tangent to the evolute; pauses and values at x = 0, ½, 1.
- **Case 3 (C3.1–C3.19):** confirmed: D = 12(1 − cos t) > 0; r = (8/3)|sin(t/2)| from 0.1744 to 8/3 and back; cusp frame omitted; evolute −p(t + π)/3; Ex 5 reversed parameterization (signed −4/3, same circle); Mathews' window widened so every circle fits.
- **Reference sections (R1–R15):** confirmed (Examples 1–5 values and verifications).

## Implementation checks

- **curvatureaa.jl:** circumcircle in 256-bit; closed forms identical to the independent sympy solve; all 38 title triples match to 6 s.f.; limit circles asserted; frames 1, 4, 5, 9, 22 checked.
- **curvaturebb.jl:** exact centers; all 41 titles match to 4 s.f. (three exact ties per F2); evolute closed form tied to computed centers by assert; frames 1, 21, 35, 53 checked.
- **curvaturecc.jl:** parametric formulas with correct derivatives; all 47 titles match; every circle inside the window; frames 1, 36, 56, 67 checked.
