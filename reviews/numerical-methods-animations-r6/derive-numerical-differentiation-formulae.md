# Derive Numerical Differentiation Formulae — animation review (round 6)

Page: `pages/numerical-methods/derive-numerical-differentiation-formulae/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with values I computed independently, at the precision the page states them. Every number shown in the frames matches the script's computation and the exact-arithmetic reference. Section 3 records the non-findings I considered and why I left them out.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `diffformaa.jl` | 0 | 7.6 | diffformaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformab.jl` | 0 | 8.6 | diffformab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `diffformac.jl` | 0 | 8.2 | diffformac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `diffformaa.gif` | 12 | byte-identical | diffformaa |
| `diffformab.gif` | 11 | byte-identical | diffformab |
| `diffformac.gif` | 11 | byte-identical | diffformac |

### Page references

- Scripts linked: `diffformaa.jl`, `diffformab.jl`, `diffformac.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description ¶1 | Central finite-difference formulas are "derived from Taylor expansions and solved in parallel as small linear systems" | Matches the archive (Mathematica `Solve` on Taylor equations, gr_35 / gr_128). Re-derived with sympy Vandermonde systems (`indep.out`). | confirmed |
| 2 | Description ¶1 | The legacy module derives the first- and second-derivative formulas together | Archive text: "parallel development of the formulas" for f' and f'' | confirmed |
| 3 | Description ¶2 | For symmetric stencils the odd and even Taylor terms cancel, giving clear error orders; wider stencils improve accuracy for smooth f | Sympy: all central-stencil leading error terms are in even powers of h; the 5-point f', f'' errors are O(h^4) against O(h^2) for 3-point | confirmed |
| 4 | Animations intro | Test function $f(x)=e^{-x}\sin x$ | All three scripts, line 8/9: `f(x) = exp(-x) * sin(x)` | confirmed |
| 5 | Animations intro | Case 1 = 3-point f'; Cases 2 and 3 compare 3-point and 5-point stencils for f' and f'' | `diffformab.jl` plots d1_3 and d1_5; `diffformac.jl` plots d2_3 and d2_5 | confirmed |
| 6 | Animations intro | "The legacy module derives the formulas symbolically and has no numerical example" | Archive read: no numerical example, no plot | confirmed |
| 7 | Case 1 heading | $f'(x_0)\approx\frac{f(x_0+h)-f(x_0-h)}{2h}$ | `diffformaa.jl:11` matches; Vandermonde weights [-1/2, 0, 1/2] | confirmed |
| 8 | Case 1 Behavior | The 3-point slope converges to the tangent slope as h decreases | err goes from 6.14e-2 (h=0.6) to 1.69e-7 (h=0.001), monotone (`instr.out`) | confirmed |
| 9 | Case 1 Behavior | "reflecting second-order accuracy" | err/h² = 0.1707, 0.1700, …, 0.169442, which tends to f'''(1)/6 = 0.169442 (`indep.out`) | confirmed |
| 10 | Case 1 alt | Stencil points and slope line converging to the tangent at x0 = 1 | `x0 = 1.0` (line 13); frames 1 → 12 show the dashed line merging into the red tangent; orange points at x0∓h, x0 | confirmed |
| 11 | Case 1 frames | Annotations "approx = …, exact = -0.110794" | Exact f'(1) = -0.110793765306699 (mpmath); every displayed approx matches the mpmath stencil value to 6 dp (e.g. h=0.6: -0.049354 against -0.04935374) | confirmed |
| 12 | Case 1 wiring | Link `diffformaa.jl`, embed `diffformaa.gif` | Files exist; the GIF regenerates byte-identically from this script | confirmed |
| 13 | Case 2 heading | $f'(x_0)\approx\frac{f(x_0-2h)-8f(x_0-h)+8f(x_0+h)-f(x_0+2h)}{12h}$ | `diffformab.jl:13` matches; Vandermonde weights [1/12, -2/3, 0, 2/3, -1/12] = (1, -8, 0, 8, -1)/12 | confirmed |
| 14 | Case 2 Behavior | The 5-point error "drops faster than the three-point estimate for the same h" | Smaller at every h (e.g. 1.92e-4 against 2.08e-2 at h=0.35) and falls faster: err5/h⁴ → -0.014772 = -f⁽⁵⁾(1)/30, against O(h²) for err3 | confirmed |
| 15 | Case 2 Behavior | The green 5-point line "already lies on the red true tangent at h=0.35" | Frame 1: the green line is visibly on the red tangent; the dashed blue line is visibly off it | confirmed |
| 16 | Case 2 Behavior | "the two lines differ by about 0.1 pixel at their ends" | Slope gap 1.919e-4 × half-length 0.9 = 1.727e-4 in y. The plot box spans rows 26–417 (391 px) for y ∈ [-0.1, 0.55], so 1.662e-3 per px and the gap is 0.104 px (`px2.py`) | confirmed |
| 17 | Case 2 Behavior | The 5-point error is read from the $|\text{err5}|$ value printed in each frame | Every frame shows "h=…, \|err3\|≈…, \|err5\|≈…" | confirmed |
| 18 | Case 2 frames | Printed \|err3\|, \|err5\| values (2.08e-02/1.92e-04 … 6.78e-07/2.16e-13) | Match `instr.out`; agree with the mpmath exact-arithmetic values to 3 s.f. down to h=0.005. At h=0.002 the float64 \|err5\| = 2.16e-13 against 2.36e-13 in exact arithmetic, the difference being rounding. The frame prints the actual float64 error, which is correct. | confirmed |
| 19 | Case 2 alt | Dashed 3-point line approaches the tangent; the 5-point line lies on the tangent in every frame; both errors printed | Contact sheet frames 1–11 | confirmed |
| 20 | Case 2 wiring | `diffformab.jl` / `diffformab.gif` | Byte-identical regeneration | confirmed |
| 21 | Case 3 heading | Second-derivative formulas on $[2h,\pi-2h]$ | `diffformac.jl:23` `xinner = range(2h, pi-2h, …)`; frame titles say the same | confirmed |
| 22 | Case 3 Behavior | Compares f''(x) with the 3-point and 5-point f'' stencils | `diffformac.jl:10,12,13`. Sympy: f'' = -2e^{-x}cos x (difference 0). Weights [1,-2,1]/h² and [-1,16,-30,16,-1]/(12h²) agree with Vandermonde | confirmed |
| 23 | Case 3 Behavior | "both stencils use only points in [0,π]" on that window | The 5-point stencil reaches x±2h, which is exactly 0 and π at the window ends | confirmed |
| 24 | Case 3 Behavior | "the maximum errors in each frame are taken over this window" | `diffformac.jl:29-30`: max over the 700 sample points of `xinner`. A sampled max, but it agrees with the exact-arithmetic max on the same grid, and the 5-point max sits at the endpoint x=2h, which is sampled | confirmed |
| 25 | Case 3 Behavior | "From h=0.35 to h=0.005 both maximum errors shrink" | err3: 1.31e-2 → 2.69e-6; err5: 5.16e-4 → 5.52e-11, strictly decreasing (`instr.out`) | confirmed |
| 26 | Case 3 Behavior | "the five-point stencil stays closer in every frame" | max err5 < max err3 in all 11 frames; also pointwise: at 0 of the 700 points in any frame is err5 ≥ err3 (`pw.py`) | confirmed |
| 27 | Case 3 Behavior | "At h=0.002 the five-point maximum error rises slightly, from 5.5×10⁻¹¹ to 5.9×10⁻¹¹" | Float64: 5.516e-11 (h=0.005) → 5.892e-11 (h=0.002) | confirmed |
| 28 | Case 3 Behavior | "because floating-point rounding now outweighs its truncation error" | Exact-arithmetic truncation max: 5.500e-11 at h=0.005 (≈ the float64 value, so truncation dominates) and 1.417e-12 at h=0.002 (40× below the float64 5.89e-11, so rounding dominates) | confirmed |
| 29 | Case 3 alt | Exact curve on 0 to π; stencil curves on 2h to π−2h; h decreasing | `xtrue` = [0, π]; frame 1 shows the stencil curves starting at x=0.7 | confirmed |
| 30 | Case 3 frames | Printed max errors (1.31e-02/5.16e-04 … 4.30e-07/5.89e-11) | Match `instr.out` and the independent numpy/mpmath values (`indep.out`) | confirmed |
| 31 | Case 3 wiring | `diffformac.jl` / `diffformac.gif` | Byte-identical regeneration | confirmed |
| 32 | Derivation Notes | $f(x\pm h)=f\pm hf'+\frac{h^2}{2}f''\pm\frac{h^3}{6}f'''+\cdots$ | Taylor series | confirmed |
| 33 | Derivation Notes | 3-point f' and f'' formulas with $O(h^2)$ | Sympy leading terms: (1/6)h²f''' and (1/12)h²f⁽⁴⁾ | confirmed |
| 34 | Derivation Notes | 5-point f' and f'' are $O(h^4)$; 5-point f''' and f⁽⁴⁾ only $O(h^2)$ | Sympy: -(1/30)h⁴f⁽⁵⁾, -(1/90)h⁴f⁽⁶⁾, (1/4)h²f⁽⁵⁾, (1/6)h²f⁽⁶⁾. The archive's gr_128 agrees | confirmed |

---

### 3. Implementation checks

### `diffformaa.jl` (Case 1)
- **Right method.** `d1_3(x,h) = (f(x+h)-f(x-h))/(2h)` is the central 3-point first-derivative formula. Vandermonde moment solve on offsets {-1,0,1}: weights [-1/2, 0, 1/2].
- **Numbers right.** Script against mpmath, approx at x0=1: h=0.6 gives -0.049353742675 against -0.04935374268; h=0.1 gives -0.109098976848 against -0.1090989768; h=0.001 gives -0.110793595865 against -0.1107935959. err/h² tends to 0.169442 = f'''(1)/6, which confirms second order.
- **Reference right.** `fp(x) = e^{-x}(cos x − sin x)`; sympy difference from d/dx f is 0. f'(1) = -0.110793765306699 in both.
- **Picture.** Black f on [0, π]. Orange points at (x0∓h, f(x0∓h)) and (x0, f(x0)). The dashed "formula slope" line passes through (x0, f(x0)) with slope `approx`, so it is parallel to the secant through the outer points rather than being that secant. The legend calls it "formula slope", which is accurate. The red tangent uses the exact slope. The title's h matches the loop value. The y-limits [-0.1, 0.55] contain everything drawn. Not a finding.

### `diffformab.jl` (Case 2)
- **Right method.** `d1_5` = (f(x−2h) − 8f(x−h) + 8f(x+h) − f(x+2h))/(12h). This is the standard 5-point central f' formula; the Vandermonde weights on {-2..2} are [1/12, -2/3, 0, 2/3, -1/12].
- **Numbers right.** Every printed |err3|, |err5| matches the instrumented run and the mpmath values (table rows 14 and 18). err5/h⁴ goes from -0.01279 (h=0.35) to -0.0147724, tending to -f⁽⁵⁾(1)/30 = -0.0147725, so fourth order is confirmed.
- **Reference right.** Same `fp` as Case 1, verified.
- **Picture.** The five orange points are at x0+{-2,-1,0,1,2}h. The tangent, the 3-point line and the 5-point line all pass through (x0, f(x0)) with their own slopes. The tangent is drawn wider (lw=5) underneath so that the green line stays visible on top of it; the page says this. Line 56's comment ("differ by at most |err5| = 1.92e-4") is correct, because 1.92e-4 is the largest err5 in the run. The 0.1-pixel claim was measured (row 16).

### `diffformac.jl` (Case 3)
- **Right method.** `d2_3` = (f(x+h) − 2f(x) + f(x−h))/h² and `d2_5` = (−f(x+2h) + 16f(x+h) − 30f(x) + 16f(x−h) − f(x−2h))/(12h²). Both match the Vandermonde weights ([1,-2,1] and [-1/12, 4/3, -5/2, 4/3, -1/12]).
- **Numbers right.** Float64 max errors from numpy (`indep.out`) agree with the script at every h, for example h=0.35: 1.3057e-2 / 5.1583e-4, and h=0.002: 4.2989e-07 / 5.8920e-11. The exact-arithmetic truncation maxima on the same grid agree down to h=0.01. They part at h=0.005 (5.500e-11 against 5.516e-11, a small rounding share) and at h=0.002 (1.42e-12 against 5.89e-11, rounding dominant), as the page says.
- **Reference right.** `fpp(x) = -2e^{-x}cos x`; sympy difference from f'' is 0.
- **Picture.** The black curve is the exact f'' on [0, π]. The stencil curves are on [2h, π−2h] and start visibly at x=0.7 in frame 1. f'' spans [-2.0000, 0.1340] on [0, π], inside ylims [-2.1, 0.2]. The legend box covers a short stretch of all three curves near x ≈ 2.4–2.95, y ≈ 0.1. The curves there coincide and the page makes no claim about that region, so this is cosmetic and not a finding. Beyond frame 2 the three curves cannot be told apart at plot resolution, and the page relies on the printed max errors for the comparison, which is appropriate.

### Non-findings considered
- **Case 1's "formula slope" line** goes through (x0, f(x0)) rather than through the two outer stencil points. Its legend and the page describe it as a slope, so the picture is not misleading.
- **The "three-point" name** is used although f(x0) has weight 0 in the f' formula. This is standard nomenclature, used by the archive too.
- **The archive's forward and backward difference subroutines** are not shown on the page. The archive has no numerical example of them, so the page drops no example. This counts as content the page does not yet have, which the brief excludes.

