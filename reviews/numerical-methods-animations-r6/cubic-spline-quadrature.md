# Cubic Spline Quadrature — animation review (round 6)

Page: `pages/numerical-methods/cubic-spline-quadrature/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor issues.

The page's claims all agree with my independent computation at the precision stated. That includes every number in the Behavior paragraph. Notes that are not findings appear in the ledger.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `splinequadaa.jl` | 0 | 8.0 | splinequadaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| D1 | "approximates ∫_a^b f by building a natural cubic spline interpolant through sampled nodes, then integrating that spline exactly over each panel" | Description l.12-13 | Script integral = Σ h(y_i+y_{i+1})/2 − h³(M_i+M_{i+1})/24, which is the exact integral of the cubic piece in second-derivative (M) form. It agrees with scipy `CubicSpline.integrate` to 1e-10 for every m. It also agrees with a 2,000,000-panel trapezoid of the script's own `spline_eval` to about 1e-12 (m=3: 2.461677504688585 vs 2.461677504688496; m=41: 2.0122088912288487 vs 2.0122088912271714). | confirmed |
| D2 | "each panel uses a cubic polynomial with continuity of function value, first derivative, and second derivative across knots" | l.14 | The script's tridiagonal system is the standard C² condition. Node residual is 0.0 for m=3,5,11,41. One-sided difference-quotient jumps at the knots are O(step·M), at most 4.6e-4 with step 1e-6, i.e. consistent with no derivative jump. The spline matches scipy's C² natural spline. | confirmed |
| D3 | natural: "S''(x_0)=S''(x_n)=0" | l.16 | `return vcat(0.0, M_inner, 0.0)` (l.42). For linear data, interior M is about 1e-14 and the integral is exactly 8.0. | confirmed |
| D4 | quadrature formula ∫S = Σ∫S_i | l.17-19 | same as D1 | confirmed |
| D5 | "As sample density increases ... spline interpolation error decreases and the integral estimate converges" | l.20 | The \|error\| of the integral decreases at every m: 0.4454 (m=3), 0.2831 (5), 0.1864 (7) … 0.004071 (41), against true I = 2.016279719617. The L1 interpolation error decreases at every m. The sup error rises from m=3 to m=5/7 before it decreases, and the Behavior paragraph states this itself. As a general asymptotic statement, the claim is correct. | confirmed |
| A1 | f(x)=1+e^{-x}sin(8x^{2/3}) on [0,2] | l.25, l.30 | script l.8-9: `exp(-x)*sin(8*x^(2/3))+1`, `a,b=0,2` | confirmed |
| A2 | "Each frame recomputes the spline over the full interval using a denser odd sample count from m=3 to m=41" | l.25-26 | `m_seq = 3:2:41` gives 20 values, each with `range(a,b,length=m)` over the full interval. The frame annotations read 3, 5, …, 41. Frame 1 (m=0) is a title frame that shows only f and no spline, which is the same as the legacy GIF. Not a finding. | confirmed |
| A3 | "Julia source scripts ... linked under each case" | l.28 | One case, linked to `splinequadaa.jl` | confirmed |
| C1 | Case heading: natural cubic spline quadrature, f, [0,2] | l.30 | script and frames | confirmed |
| B1 | "The spline interpolant and integral estimate are rebuilt globally at each density level" | l.32 | The script rebuilds xs, ys, M and the integral inside the loop for each m. | confirmed |
| B2 | "the area between spline and curve shrinks at every step" | l.32 | The L1 values for m=3..41 are 0.70999, 0.37670, 0.29221, 0.18353, 0.11430, 0.07600, 0.05383, 0.04004, 0.03098, 0.02472, 0.02022, 0.01688, 0.01433, 0.01234, 0.01075, 0.00946, 0.00840, 0.00752, 0.00678, 0.00614. They are strictly decreasing. | confirmed |
| B3 | "from 0.71 at m=3 to 0.0061 at m=41" | l.32 | 0.70999 and 0.00614 | confirmed |
| B4 | largest gap "sits under the narrow peak near x≈0.08" (early m) | l.32 | The peak of f is at x=0.080384, where f=1.919756. The largest gap is at x=0.0768 for m=3, 0.0965 for m=5, 0.0945 for m=7 and 0.0765 for m=9, with S<f in every case. | confirmed |
| B5 | "the spline undershoots by more at m=5 (1.11) and m=7 (1.09) than at m=3 (0.88)" | l.32 | The largest gaps are 1.1108, 1.0899 and 0.8773, all with S<f. The script's own 800-point grid gives 1.1108, 1.0899 and 0.8773. | confirmed |
| B6 | "From m=5 on it falls at every step, to 0.16 at m=41" | l.32 | The gap is 1.1108, 1.0899, 0.8605, 0.6736, 0.5441, 0.4541, 0.3896, 0.3416, 0.3048, 0.2758, 0.2524, 0.2331, 0.2170, 0.2032, 0.1914, 0.1811, 0.1721, 0.1640, 0.1569. It is strictly decreasing, and 0.1569 rounds to 0.16. | confirmed |
| B7 | moves left "onto the steep rise next to x=0, where the x^{2/3} term gives f an infinite slope" | l.32 | f'(x) contains (16/3)x^{-1/3}e^{-x}cos(8x^{2/3}), which → ∞ as x→0⁺. The location of the largest gap moves monotonically left from m=9 on. | confirmed |
| B8 | "to x≈0.06 at m=11, 0.03 at m=21 and 0.013 at m=41" | l.32 | The graded grid gives 0.0616, 0.0284 and 0.0129. The script's grid gives 0.0626, 0.0275 and 0.0125. | confirmed |
| B9 | "At m=41 the spline's overshoot of the peak value is only 0.03" | l.32 | max S = 1.94642 at x=0.0757, and max f = 1.91976, so the overshoot is 0.0267 ≈ 0.03. Frame 21 shows the red spline just above the magenta curve at the peak. | confirmed |
| B10 | "The filled spline area tracks the curve more tightly as m increases" | l.32 | B2, and frames 2, 3, 11 and 21 | confirmed |
| W1 | `[Julia source](splinequadaa.jl)` | l.34 | The file exists and is the only script. | confirmed |
| W2 | `![...](splinequadaa.gif)` | l.36 | The file exists, and the regeneration from the linked script is byte-identical. | confirmed |
| W3 | alt: "full-interval density refinement: each frame increases sample points, rebuilds the spline, and updates the integral estimate" | l.36 | Frames 2-21 show m=3..41 with "Approximation =" values equal to `round(Q,6)`. All 11 frames on the contact sheet were read: 2.461678, 1.733199, 1.907477, 1.970143, 1.991279, 2.000544, 2.00539, 2.008244, 2.010073, 2.011319, 2.012209. Each matches scipy's value rounded to 6 digits. Frame 1 is the title frame (see A2). | confirmed |

### 3. Implementation checks: `splinequadaa.jl`

**It is the method it claims to be.** The script runs a natural cubic spline in second-derivative (moment) form. `natural_spline_M` solves the (n−2)×(n−2) tridiagonal system h_{i}M_{i}+2(h_i+h_{i+1})M_{i+1}+h_{i+1}M_{i+2} = 6(Δ_{i+1}−Δ_i) by the Thomas algorithm, with M_0=M_n=0. `spline_eval` is the standard moment-form evaluation. `spline_integral` integrates each cubic piece exactly. This is natural cubic spline quadrature, the method in the title and in Mathews' module, and it is not a neighbouring method.

**The numbers are right.**
- Script against independent scipy `CubicSpline(bc_type='natural').integrate(0,2)`. Every m agrees to all 10 printed digits:

  | m | script | scipy |
  |---|---|---|
  | 3 | 2.461677504688585 | 2.4616775047 |
  | 5 | 1.7331993537961796 | 1.7331993538 |
  | 11 | 1.9480699762179035 | 1.9480699762 |
  | 21 | 2.0005440202177294 | 2.0005440202 |
  | 41 | 2.0122088912288487 | 2.0122088912 |

  The intermediate m values agree too; see `instr.out` and `indep.out`.
- Property check on the script's own routines with sin x on [0,π]. There g''=0 at both ends, so the natural condition is consistent and O(h⁴) convergence is expected. When h is halved, the error ratios are 18.7, 16.67, 16.17, 16.04, 16.01. That is fourth order, as expected, and the m=129 error is 1.0e-9.
- Linear data are reproduced exactly: M_inner ≈ 1e-14, and the integral is 8.0 against an exact 8.0.
- Interpolation residual at the nodes is 0.0 for m=3,5,11,41. The integral formula agrees with a fine trapezoid of `spline_eval` to about 1e-12.

**Its reference values are right.** The script draws f itself as the reference curve and does not quote an "exact" integral. The page does not quote one either. For context, the true integral is 2.016279719617096. I computed it with mpmath quad after substituting x=t³, which removes the x^{2/3} singularity in the derivative. A direct split quad cross-checks it with identical digits. The estimates approach it monotonically from m=5 on, with a final error of 0.00407.

**The picture shows what was computed.**
- The spline (red, filled pink down to 0) is evaluated with `spline_eval` at 800 points on the current node set.
- The nodes are scattered at (xs, f(xs)), and frames 2, 3, 11 and 21 show them on the curve.
- f is drawn in magenta from the same `f` used for the nodes.
- The axis limits [0,2]×[0,2.1] contain everything: the spline minimum is ≥0.319 and its maximum is ≤1.957 for every m (`prop.out`, `indep.out`), so neither the fill nor the curve is clipped.
- The annotations show the right m and `round(Q,6)`. Frame 13 (m=25) shows "2.00539" because `round` drops a trailing zero (2.005390). That is correct to 6 digits.
- 21 frames = 1 title frame + 20 m-values.

### Legacy archive (fidelity)

Mathews' animation `Splineaa.gif` has the same function (its label reads "y = e^{-x} sin(8x^{2/3}) + 1"), the same interval [0,2], the same odd m sequence 3..41 and the same layout, with blank lead frames. His m=3, 7, 11, 23, 27, 31, 39 and 41 values (2.461678, 1.829912, 1.948070, 2.003313, 2.006987, 2.009252, 2.011799, 2.012209) agree with the script and with scipy.

A few legacy values differ in the last digits:

| m | legacy | correct value (scipy and script) |
|---|---|---|
| 15 | 1.983111 | 1.983110 |
| 19 | 1.996731 | 1.996732 |
| 35 | 2.010748 | 2.010751 |

Where the page differs from the archive it is correct. The page does not reproduce the legacy numbers, so this is not a finding. The module's Examples 1-2 use integrands whose formulas are images and are not animation cases. The page does not claim to cover them, so they fall under content the page does not yet have. There is no fidelity finding.

