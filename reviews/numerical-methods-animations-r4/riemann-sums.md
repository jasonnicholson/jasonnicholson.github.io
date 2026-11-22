# Riemann Sums — animation review (round 4)

Page: `pages/numerical-methods/riemann-sums/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Zero Error, zero Misleading, zero Minor.

Things I looked at and deliberately did not raise (below the review standard's threshold):

- Cases 1-2 format the annotation with `round(approx; digits=6)`, which drops trailing zeros: frame n=6 of `riemannaa.gif` shows `Approximation = 1.8522` (true 1.852200399) and frame n=72 of `riemannbb.gif` shows `2.01341` (true 2.013409706). Both are correct to six decimals. Cases 3-4 use `@sprintf("%.6f")`. This is a cosmetic inconsistency, not an error.
- Cases 1-2 label the count "Sample Points = n" (the legacy label) and Cases 3-4 label it "Subintervals = n". For left/right sums the two are equal, so both labels are correct.
- Mathews' n2003 Examples 10-13 show the formula image `f[x] = 1 + e^-x Sin[9/2 x]` (`RiemannSumMod_gr_176/201/227/254.gif`), but his own solution code (`gr_178`, `gr_229`), graph (`gr_200`) and a2001 animations all use `1 + e^-x Sin[8 x^(2/3)]` on [0, 2]. The page uses the function from the solutions and animations, so this is an inconsistency inside the legacy archive, not a fidelity departure.
- The legacy animation set also has a Midpoint Rule animation. It is not dropped: it lives on the separate `pages/numerical-methods/midpoint-rule/` page.
- The page's `n` sequence (1..8, 10, 12, ..., 120) differs from Mathews' (1, 2, 4, 6, 8, ..., 100, 120). The page doesn't claim his sequence, and the endpoint n=120 is the same.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `riemannaa.jl` | 0 | 7.1 | riemannaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemannbb.jl` | 0 | 7.7 | riemannbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanncc.jl` | 0 | 9.2 | riemanncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanndd.jl` | 0 | 9.2 | riemanndd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `riemannaa.gif` | 25 | byte-identical | riemannaa |
| `riemannbb.gif` | 25 | byte-identical | riemannbb |
| `riemanncc.gif` | 25 | byte-identical | riemanncc |
| `riemanndd.gif` | 25 | byte-identical | riemanndd |

### Page references

- Scripts linked: `riemannaa.jl`, `riemannbb.jl`, `riemanncc.jl`, `riemanndd.jl`
- GIFs embedded: 4
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description l.12 | partition width $\Delta x=(b-a)/n$; approximation converges to the true integral as $n$ grows | `f` is continuous on [0, 2], so it is Riemann integrable. Computed L/R/lower/upper at n=120 are all within 0.035 of I | confirmed |
| D2 | l.14-15 | nodes $x_i=a+i\Delta x$; $L_n=\sum_{i=0}^{n-1} f(x_i)\Delta x$, $R_n=\sum_{i=1}^{n} f(x_i)\Delta x$ | `left_sum` (aa l.18) uses i in 0:n-1, `right_sum` (bb l.18) uses i in 1:n, both with `a + i*(b-a)/n` | confirmed |
| D3 | l.15 | lower/upper sums are "bounds from interval minima/maxima" | cc l.41 `fmin` and dd l.41 `fmax` take the min/max over the endpoints and the interior critical points, which is the exact extremum of a differentiable f on a closed interval | confirmed |
| D4 | l.17 | legacy Mathews animations increase sampling density over the entire interval between frames | a2001 `LeftRiemannaa.gif` and `LowerRiemannaa.gif` frames: n = 1, 4, 8, 12, 16, 24, 32, 50, 70, 100, 120, with full-interval partitions | confirmed |
| A1 | l.21-22 | every animation is over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | all four scripts: `f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1`, `a, b = 0.0, 2.0`, `xlims=(0,2)` | confirmed |
| A2 | l.22 | between frames, n increases across the full interval, refining by density rather than sweeping left to right | `n_seq` is strictly increasing. Each frame redraws all n rectangles over [0, 2] (frames 1, 3, 5, 9, 25 viewed for each GIF) | confirmed |
| A3 | l.24 | Julia sources are linked under each case | 4 links present. Manifest: all scripts are linked | confirmed |
| C1a | Case 1 heading | Left Riemann Sum of the stated f | aa: heights `f(xl)` at the left endpoint (l.33). Title "Left Riemann Sum". Frame n=2 shows heights f(0)=1 and f(1)=1.3640 | confirmed |
| C1b | Case 1 Behavior | height on each subinterval is taken at the left endpoint | aa l.31-33 | confirmed |
| C1c | Case 1 Behavior | as density increases, the approximation settles toward the true integral | L_n: 2.000, 2.364, 1.893, 1.798, ..., 2.009796 (n=48), 2.014795 (n=120). I = 2.016280. It settles, though not monotonically at small n, and the page does not claim it is monotone | confirmed |
| C1d | Case 1 alt text | each frame increases partition density and updates the left-endpoint area estimate | frames 2-25: n = 1..120, annotation equals `left_sum(n)` | confirmed (frame 1 is the bare curve, n=0) |
| C1e | Case 1 wiring | link `riemannaa.jl`, embed `riemannaa.gif` | the script writes `riemannaa.gif`, and the GIF's title reads "Left Riemann Sum" | confirmed |
| C2a | Case 2 heading / Behavior | Right Riemann Sum; height at the right endpoint | bb l.31-33 `h = f(xr)`. Title "Right Riemann Sum" | confirmed |
| C2b | Case 2 Behavior | comparing with Case 1 shows how endpoint choice shifts the approximation at finite n | R_n − L_n = (f(2) − f(0))Δx = 0.03585/n: 0.0358 at n=1, 0.0003 at n=120, so R_n > L_n throughout. The shift is real but small | confirmed |
| C2c | Case 2 alt text / wiring | right-endpoint estimate; `riemannbb.jl` / `riemannbb.gif` | as for C1d and C1e | confirmed |
| C3a | Case 3 heading / Behavior | each rectangle uses the minimum of f on its subinterval | cc `fmin`. Rectangle heights in frame n=4 are 0.3572 (interior min at x=0.43198), f(0.5), f(1.5) and 0.7956 (interior min at x=1.56448) | confirmed |
| C3b | Case 3 Behavior | every frame's sum is a lower bound for I | all 24 lower sums are ≤ I (indep.py `lo<=I True` for every n) | confirmed |
| C3c | Case 3 Behavior | $I \approx 2.016280$ | mpmath: I = 2.0162797196171 (adaptive quad on 40 panels, and again after the substitution x = t³; the two agree to 15 digits) | confirmed |
| C3d | Case 3 Behavior | sums approach I as n grows, but not monotonically | lower sums are increasing except at 3→4 and reach 1.978951 at n=120 | confirmed |
| C3e | Case 3 Behavior | lower sum falls from 1.374576 at n=3 to 1.192004 at n=4 | script: 1.3745762078, 1.1920041540. indep: 1.374576208, 1.192004154. Frames n=3 and n=4 show the same values | confirmed |
| C3f | Case 3 Behavior | the drop happens because the n=4 partition is not a refinement of the n=3 one | {0, 1/2, 1, 3/2, 2} ⊉ {0, 2/3, 4/3, 2}. Lower sums are monotone only under refinement | confirmed |
| C3g | Case 3 alt text / wiring | uses the minimum on each subinterval; `riemanncc.jl` / `riemanncc.gif` | as above. Title "Lower Riemann Sum" | confirmed |
| C4a | Case 4 heading / Behavior | each rectangle uses the maximum of f on its subinterval | dd `fmax`. Frame n=1 height is 1.919756 = f(0.0803835), the global max. Frame n=8 first rectangle has the same height | confirmed |
| C4b | Case 4 Behavior | every frame's sum is an upper bound | all 24 upper sums are ≥ I | confirmed |
| C4c | Case 4 Behavior | at n=120, $1.978951 \le I \le 2.050951$ | script: 1.9789510237, 2.0509510464. indep: 1.978951024, 2.050951046. Last frames of cc and dd show the same | confirmed |
| C4d | Case 4 Behavior | the sums squeeze I as n→∞, but not monotonically along this sequence | upper sums decrease except at 7→8. The gap shrinks from 3.125 (n=1) to 0.0720 (n=120) | confirmed |
| C4e | Case 4 Behavior | upper sum rises from 2.418035 at n=7 to 2.427098 at n=8 | script: 2.4180348322, 2.4270980115. indep: 2.418034832, 2.427098012. Frame n=8 shows 2.427098 | confirmed |
| C4f | Case 4 alt text / wiring | uses the maximum on each subinterval; `riemanndd.jl` / `riemanndd.gif` | as above. Title "Upper Riemann Sum" | confirmed |
| F1 | Fidelity | function, interval and the four cases (left, right, lower, upper) match the legacy | a2001 animation frames are titled `y = e^{-x} sin(8x^{2/3}) + 1` on [0, 2]. n2003 solution code uses the same f, a, b. Legacy values match the script (left n=4: legacy 1.797590 vs 1.7975903; lower n=4: legacy 1.192005 vs 1.1920042, the legacy minimises on a 1200-point grid; lower n=16: 1.726233 vs 1.7262325) | confirmed |

---

### 3. Implementation checks

Independent values come from `/usr/bin/python3 indep.py` (mpmath, 30 digits). Script values come from `julia inst_*.jl`.

### Shared: function, reference integral, critical points
- f matches the page and the legacy archive in every script.
- Reference integral (only quoted on the page, never drawn): I = 2.0162797196171, from two independent quadratures that agree to 15 digits. The page's "≈ 2.016280" is correct.
- Critical points (cc/dd, found from a hand-written f′ with grid sign changes and bisection): 0.08038354937224365, 0.43198195723294985, 0.9392052471495191, 1.5644755011307958. Independent (`mp.findroot` on `mp.diff(f)`): 0.0803835493722437, 0.43198195723295, 0.939205247149519, 1.5644755011308. They agree to all printed digits. The hand-written f′ (cc/dd l.20) is the correct derivative. Its comment that f′ → +∞ as x → 0+ is also correct. The grid starts at x = 1e-4, but f′ > 0 on (0, 1e-4) (the x^{-1/3} cos term is > 21·(16/3)), so no critical point is missed there. The independent grid starting at 1e-6 also finds exactly four.

### `riemannaa.jl` — Left Riemann sum
- Method: L_n = Δx Σ_{i=0}^{n-1} f(a + iΔx). This is the left-endpoint rule, as named.
- Numbers: all 24 values agree with the independent L_n to ≥ 9 digits. For example, n = 1, 4, 16, 120: script 2.0, 1.7975902842, 1.9779355558, 2.0147950912; indep 2.000000000, 1.797590284, 1.977935556, 2.014795091.
- Reference: none drawn.
- Picture: each rectangle is [xl, xl + dx] × [0, f(xl)], matching the sum. The annotation shows `left_sum(n)`. Viewed frames 1, 3 (n=2: heights 1 and 1.3640, value 2.363965) and the sheet through n=120 (2.014795). The y-limit of 2.1 exceeds max f = 1.9198, so nothing is clipped.

### `riemannbb.jl` — Right Riemann sum
- Method: R_n = Δx Σ_{i=1}^{n} f(a + iΔx). This is the right-endpoint rule.
- Numbers: all 24 agree. For example, n = 1, 4, 16, 120: script 2.0358496324, 1.8065526923, 1.9801761578, 2.0150938381; indep 2.035849632, 1.806552692, 1.980176158, 2.015093838. The property check R_n − L_n = (f(2) − f(0))·2/n holds: 0.035849632 at n=1.
- Picture: rectangle heights are `f(xr)`. The values in the frames match.

### `riemanncc.jl` — Lower sum
- Method: the true lower Darboux sum. The min on each closed subinterval is taken over the endpoints and the interior critical points, which is exact for differentiable f. It is not a sampled approximation.
- Numbers: all 24 agree with both independent versions (exact candidates, and dense sampling, which is always ≥ the exact min). For example, n = 1, 3, 4, 120: script 0.7144073719, 1.3745762078, 1.1920041540, 1.9789510237; indep 0.714407372, 1.374576208, 1.192004154, 1.978951024.
- Property: every value is ≤ I.
- Picture: heights are `fmin(xl, xr)`. Frame n=4 checked rectangle by rectangle. The annotation matches.

### `riemanndd.jl` — Upper sum
- Method: the true upper Darboux sum, by the same exact candidate set as cc.
- Numbers: all 24 agree. For example, n = 1, 7, 8, 120: script 3.8395118984, 2.4180348322, 2.4270980115, 2.0509510464; indep 3.839511898, 2.418034832, 2.427098012, 2.050951046. Dense sampling gives values just below these (3.839509931 at n=1), as expected.
- Property: every value is ≥ I.
- Picture: heights are `fmax(xl, xr)`. In frame n=1 the single rectangle has height 1.9198 (< ylim 2.1, so it is not clipped). The annotation sits inside the rectangle but stays readable. Frame n=8 shows 2.427098.

### GIF provenance
- The manifest reports every committed GIF byte-identical to a fresh scratch regeneration, with 25 frames each (n=0 bare curve, then the 24 values in `n_seq`).

