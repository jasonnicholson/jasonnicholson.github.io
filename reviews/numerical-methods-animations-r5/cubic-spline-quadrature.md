# Cubic Spline Quadrature — animation review (round 5)

Page: `pages/numerical-methods/cubic-spline-quadrature/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my own computation at the precision it is stated to. The implementation is a correct natural cubic spline quadrature, and the GIF shows what the script computes.

Observations that are not findings:
- Frame 1 of the GIF shows only the curve `f` and no spline. This is an intro frame (m = 0 in `vcat(0, m_seq)`, line 69). The introduction says "Each frame recomputes the spline … from m=3 to m=41". Read literally, that does not cover frame 1, but no reader would be misled. The legacy GIF has two such intro frames.
- The page never quotes the true integral (2.016280). The animation therefore cannot show how far the m = 41 estimate (2.012209, error -0.0041) still is from it. This is content the page does not have, so it is not an error.
- Two values in the legacy GIF disagree with the exact spline integral in the 6th decimal: Mathews m = 33 gives 2.010075 against an exact 2.010073, and m = 35 gives 2.010748 against an exact 2.010751. The page's script gives the exact values, so this does not count against the page.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `splinequadaa.jl` | 0 | 7.4 | splinequadaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `splinequadaa.gif` | 21 | byte-identical | splinequadaa |

### Page references

- Scripts linked: `splinequadaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "building a natural cubic spline interpolant through sampled nodes, then integrating that spline exactly over each panel" | The script interpolates exactly (max node residual 0.0 for every m). Its panel formula `h(y_i+y_{i+1})/2 - h^3(M_i+M_{i+1})/24` matches scipy's exact `CubicSpline.integrate` to about 1e-12 for all 20 m. | confirmed |
| D2 | "each panel uses a cubic polynomial with continuity of function value, first derivative, and second derivative across knots" | Largest jump at interior knots: S' ≤ 3.6e-15, S'' = 0.0 (`instr2.jl`). | confirmed |
| D3 | "natural spline interpolant (S''(x_0)=S''(x_n)=0)" | S'' at both ends is (0.0, 0.0) for every m. Line 42 returns `vcat(0.0, M_inner, 0.0)`. | confirmed |
| D4 | Formula: the integral of S equals the sum of panel integrals of S_i | Matches `spline_integral` (lines 60-67) and scipy. | confirmed |
| D5 | "As sample density increases … spline interpolation error decreases and the integral estimate converges." | The absolute error in the integral falls at every step: 0.4454, 0.2831, 0.1864, … 0.00407 (true value 2.0162797196 from mpmath). The L1 interpolation error falls at every step. The max error falls from m = 5 on. | confirmed |
| A1 | Function $f(x)=1+e^{-x}\sin(8x^{2/3})$ (intro and Case 1 heading) | Script line 8: `exp(-x) * sin(8 * x^(2/3)) + 1`. Same function as the legacy GIF. | confirmed |
| A2 | Interval $[0,2]$ | Line 9: `a, b = 0.0, 2.0`. Axis 0 to 2 in the frames. | confirmed |
| A3 | "denser odd sample count from m=3 to m=41 points" | Line 11: `m_seq = collect(3:2:41)`. Frame labels run 3, 5, …, 41. | confirmed |
| A4 | "Each frame recomputes the spline over the full interval" | Line 76: `xs = range(a, b, length=m)` on each frame. Frame 1 is a curve-only intro frame (see note). | confirmed (with note) |
| A5 | "natural cubic spline quadrature diagram" / heading "Natural Cubic Spline Quadrature" | GIF title, and the method checked in D1-D3. | confirmed |
| B1 | "The spline interpolant and integral estimate are rebuilt globally at each density level." | Lines 76-87 run inside the loop. | confirmed |
| B2 | "the area between spline and curve shrinks at every step, from 0.71 at m=3 to 0.0061 at m=41" | `indep.py` gives L1 = 0.70999 (m = 3) and 0.00614 (m = 41), decreasing at all 19 steps. | confirmed |
| B3 | "The largest pointwise gap … sits under the narrow peak near x≈0.08" (m = 3, 5, 7) | Max-gap locations: x = 0.0768, 0.0965, 0.0945. The f peak is at x = 0.0804. The spline is below f at each. | confirmed |
| B4 | "undershoots by more at m=5 (1.11) and m=7 (1.09) than at m=3 (0.88)" | 1.1108, 1.0899, 0.8773. | confirmed |
| B5 | "From m=5 on it falls at every step, to 0.16 at m=41" | Decreases at every step from m = 5 to m = 41. m = 41 gives 0.1569. | confirmed |
| B6 | "moves left onto the steep rise next to x=0 … to x≈0.06 at m=11, 0.03 at m=21 and 0.013 at m=41" | 0.0616, 0.0284, 0.0129. | confirmed |
| B7 | "the x^{2/3} term gives f an infinite slope" at x = 0 | f'(x) contains e^{-x}cos(8x^{2/3})(16/3)x^{-1/3}, which tends to +infinity as x → 0+. | confirmed |
| B8 | "At m=41 the spline's overshoot of the peak value is only 0.03" | max S − max f = 1.94638 − 1.91976 = 0.0267, which rounds to 0.03. | confirmed |
| B9 | "The filled spline area tracks the curve more tightly as m increases" | Same evidence as B2. The frames show this. | confirmed |
| W1 | Link `[Julia source](splinequadaa.jl)` | The file exists and is the only script. It writes `splinequadaa.gif`. | confirmed |
| W2 | Embed `splinequadaa.gif` | Byte-identical to the scratch regeneration (manifest). | confirmed |
| W3 | Alt text: "each frame increases sample points, rebuilds the spline, and updates the integral estimate" | Frames 2-21 show m and "Approximation = round(Q, 6)", and the values match the instrumented output. | confirmed |

### 3. Implementation checks: `splinequadaa.jl`

**Method.** The script runs a natural cubic spline in the second-derivative (M) form. Lines 23-34 set up the standard tridiagonal system `h_{i-1}M_{i-1} + 2(h_{i-1}+h_i)M_i + h_iM_{i+1} = 6(Δ_i − Δ_{i-1})`, which lines 30-40 solve with the Thomas algorithm, and the end conditions are M_0 = M_n = 0. Lines 45-58 evaluate the standard M-form cubic. The quadrature is the exact integral of each panel cubic. That is natural cubic spline quadrature as named. It is not a clamped or not-a-knot variant, and it is not some other rule under that name.

**Numbers.** The script's approximations (`instr.jl`) set beside scipy's natural spline integral (`indep.py`):

| m | script | scipy exact | true − estimate |
|---|---|---|---|
| 3 | 2.461677504688585 | 2.461677504689 | −0.445398 |
| 5 | 1.7331993537961796 | 1.733199353796 | +0.283080 |
| 7 | 1.8299124826871151 | 1.829912482687 | +0.186367 |
| 9 | 1.9074769312146973 | 1.907476931215 | +0.108803 |
| 11 | 1.9480699762179035 | 1.948069976218 | +0.068210 |
| 21 | 2.0005440202177294 | 2.000544020218 | +0.015736 |
| 31 | 2.009251688341952 | 2.009251688342 | +0.007028 |
| 41 | 2.0122088912288487 | 2.012208891229 | +0.004071 |

All 20 values agree to at least 12 digits (the full list is in the outputs of `instr.jl` and `indep.py`). Checks of the script's own routines that do not depend on remembering a formula:
- Node residual: 0.0 for every m.
- Knot jumps: S' ≤ 3.6e-15, S'' = 0.
- End values: S''(x_0) = S''(x_n) = 0.
- Exactness: integrates 3x − 1 on [0, 2] exactly (4.0 for m = 3, 5, 9).
- Convergence: for sin on [0, pi], where f'' = 0 at both ends so the natural end condition is consistent, the error ratios on halving h are 18.7, 16.7, 16.2, 16.0. That is O(h^4), as expected for spline quadrature.

**Reference values.** The script draws no "true" integral and no reference other than f itself, which is the f of the page. I computed the true integral independently as 2.01627971961709632788727442192 (mpmath, 30 digits) and used it only to confirm convergence.

**Picture.**
- The spline is drawn in red from `spline_eval` at 800 points, with the fill to y = 0. The spline stays inside [0.319, 1.957] for every m, so it is positive everywhere and the pink area equals the reported integral. It also stays inside ylims (0, 2.1), so nothing is clamped or cut off.
- The nodes are drawn as red markers at (x_i, f(x_i)), and f is drawn in magenta over everything.
- The annotations show m and the rounded approximation, and these match the instrumented values. I checked frames 2 (m = 3, 2.461678), 21 (m = 41, 2.012209) and the contact-sheet frames for m = 5, 9, …, 37 (all match).
- The m = 41 frame shows the small overshoot at the peak and the residual gap on the steep rise near x = 0, as the page describes.
- 21 frames at 2 fps: one intro frame followed by the 20 m values.

**Fidelity (legacy archive).** Mathews' animation (`Splineaa.gif`) uses the same function, the same interval, and the same odd sequence of sample points from 3 to 41 with a natural spline and the same annotations. Its m = 3 value is 2.461678 and its m = 41 value is 2.012209, the same as the page. The page's single case reproduces the archive's only animation, and no archive case is dropped. (The n2003 module's Examples 1-6 are Mathematica worked examples, not animations. The page lists Worked Example as planned, which is outside the scope of this review.)

