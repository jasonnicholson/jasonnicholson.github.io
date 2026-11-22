# Riemann Sums — animation review (round 3)

Page: `pages/numerical-methods/riemann-sums/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found nothing false, miscomputed or misleading on this page.

Every number the page and the four GIFs state agrees with an independent computation to all six decimals shown. Every behaviour claim holds for the computed sequences. Every rectangle checked in the frames is built from the right quantity, and the wiring is correct.

Observations that I did not count as findings, recorded so the owner can see they were considered:

- *Display precision in Cases 1–2.* `riemannaa.jl:41` and `riemannbb.jl:41` format with `round(approx; digits=6)`, so trailing zeros are dropped. The frames read `Approximation = 2.0` (left, n=1), `1.8522` (left, n=6), `1.79759`, `1.95574`, `2.03585` (right, n=1) and `2.01341` (right, n=72). Cases 3–4 use `%.6f`. Each displayed value is the correct value rounded to 6 dp (for example L_6 = 1.852200), so nothing is misrepresented. The difference is only cosmetic. If consistency is wanted, use `@sprintf("%.6f", approx)` as cc/dd do.
- *Case 2 "endpoint choice shifts the approximation".* This is true, but the shift is small for this function. The sum telescopes: R_n − L_n = Δx·(f(2) − f(0)) = 0.035850/n, because f(2) = 1.017925 ≈ f(0) = 1. For example, at n=3 the values are L = 1.893096 and R = 1.905046. The claim does not say the shift is large, so I left it as confirmed.
- *Legacy n2003 formula image.* The n2003 module page's Examples 10–13 header images (`gr_176/201/227/254`) show `f[x] = 1 + e^{-x} Sin[9/2 x]`. However, the solution code these examples link to (`lnk_15`, image `gr_178`) defines `f[x_] = 1 + e^{-x} Sin[8 x^{2/3}]` on [0,2], and the a2001 animations are titled `y = e^{-x} sin(8x^{2/3}) + 1`. The page uses sin(8x^{2/3}), the function that was actually animated, so this is not a fidelity departure. Mathews' a2001 index also has a Midpoint Rule animation; that topic has its own page (`pages/numerical-methods/midpoint-rule/`), so leaving it off this page is not a drop.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `riemannaa.jl` | 0 | 7.5 | riemannaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemannbb.jl` | 0 | 7.8 | riemannbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanncc.jl` | 0 | 8.0 | riemanncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanndd.jl` | 0 | 10.3 | riemanndd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Evidence key: **[I]** = independent Python/mpmath (`review/indep.out`), **[S]** = instrumented script copies (`review/inst_all.out`), **[F]** = committed frames, **[C]** = code reading.

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.12 | "partitioning [a,b] into n subintervals … Δx = (b−a)/n" | [C] all four scripts use `dx = (b-a)/n` with n equal subintervals | confirmed |
| 2 | Description l.12 | "As n increases … the approximation converges to the true integral" | f is continuous on [0,2], so it is Riemann integrable. [I] all four sequences tend to I = 2.016280 (n=120: L 2.014795, R 2.015094, lower 1.978951, upper 2.050951) | confirmed |
| 3 | Description l.14 | nodes x_i = a + iΔx | [C] `a + i*(b-a)/n` (aa, bb); `a+(i-1)*dx`, `a+i*dx` (cc, dd) | confirmed |
| 4 | Description l.15 | L_n = Σ_{i=0}^{n-1} f(x_i)Δx | [C] `riemannaa.jl:18`; [S] = [I] for all 24 n | confirmed |
| 5 | Description l.15 | R_n = Σ_{i=1}^{n} f(x_i)Δx | [C] `riemannbb.jl:18`; [S] = [I] for all 24 n | confirmed |
| 6 | Description l.15 | lower/upper sums are "bounds from interval minima/maxima" | [C] `riemanncc.jl:41`, `riemanndd.jl:41` take the exact min/max over endpoints and interior critical points; [I] lower ≤ I ≤ upper for every n | confirmed |
| 7 | Description l.17 | "The legacy Mathews animations increase sampling density over the entire interval between frames. The animations below follow that same pattern." | Legacy frames (`review/legacy/*/sheet.png`) show whole-interval refinement through m = 1, 4, 6, 8, 12, 16, 24, 32, 50, 70, 100; [C] n_seq refines over the whole interval | confirmed |
| 8 | Animations intro l.21–22 | interval [0, 2] | [C] `a, b = 0.0, 2.0`, xlims (0,2); [F] x-axis 0–2 | confirmed |
| 9 | Animations intro l.22 | function y = e^{-x} sin(8x^{2/3}) + 1 | [C] `f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1` in all four scripts | confirmed |
| 10 | Animations intro l.22 | "number of subintervals n increases across the full interval … refines by density, not by sweeping left-to-right" | [C] frames are n = 0 (curve only), then 1, 2, 3, 4, 5, 6, 7, 8, 10, …, 104, 120 (strictly increasing); [F] each frame tiles all of [0,2] | confirmed |
| 11 | l.24 | Julia source scripts linked under each case | [C] four links present; the manifest confirms each script regenerates its GIF byte-identically | confirmed |
| 12 | Case 1 heading | Left Riemann Sum, same f | [C] aa: title "Left Riemann Sum", same f | confirmed |
| 13 | Case 1 Behavior | "rectangle height … taken at the left endpoint" | [C] `h = f(xl)`; [F] n=2: heights f(0)=1, f(1)=1.366 (frame_003); n=3: 1, 0.911, 0.93 | confirmed |
| 14 | Case 1 Behavior | "As sample-point density increases, the approximation settles toward the true integral" | [I] L_n: 2.000000, 2.363965, 1.893096, 1.797590, 1.818308, … then increasing monotonically from n=4 to 2.014795 at n=120 (I = 2.016280) | confirmed |
| 15 | Case 1 link/embed | `riemannaa.jl` / `riemannaa.gif` are the Left case | [C], [F] title "Left Riemann Sum" | confirmed |
| 16 | Case 1 alt text | "each frame increases partition density and updates the left-endpoint area estimate" | [F] the annotation updates every frame; frame 1 is the curve only | confirmed |
| 17 | Case 2 heading | Right Riemann Sum, same f | [C] bb | confirmed |
| 18 | Case 2 Behavior | "rectangle height is taken at the right endpoint" | [C] `h = f(xr)`; [F] n=3 heights 0.911, 0.93, 1.018 | confirmed |
| 19 | Case 2 Behavior | "Comparing with Case 1 shows how endpoint choice shifts the approximation at finite n" | [I] R_n − L_n = 0.035850/n, nonzero at every n and shrinking (0.0358 at n=1, 0.0003 at n=120). True; the shift is small (see Observations) | confirmed |
| 20 | Case 2 link/embed/alt | `riemannbb.*` is the Right case | [C], [F] | confirmed |
| 21 | Case 3 heading | Lower Riemann Sum, same f | [C] cc | confirmed |
| 22 | Case 3 Behavior | "Each rectangle uses the minimum of f on its subinterval" | [C] `fmin` over endpoints and interior critical points; critical points 0.0803835, 0.4319820, 0.9392052, 1.5644755 match an independent root-find to 1e-16; [F] n=3 heights 0.3572 (interior min at 0.432), 0.911, 0.7956 (interior min at 1.564) | confirmed |
| 23 | Case 3 Behavior | "every frame's sum is a lower bound for the integral" | [I] lower_n ≤ I for all 24 n (the n=0 frame has no sum) | confirmed |
| 24 | Case 3 Behavior | "I ≈ 2.016280" | [I] mpmath quad, direct and with substitution x = t³: 2.0162797196170963 → 2.016280 | confirmed |
| 25 | Case 3 Behavior | "The sums approach I as n grows" | [I] lower_120 = 1.978951, increasing from n=4 onward | confirmed |
| 26 | Case 3 Behavior | "falls from 1.374576 at n=3 to 1.192004 at n=4" | [I] 1.374576, 1.192004; [S] the same; [F] frames 004/005 show these values | confirmed |
| 27 | Case 3 Behavior | "the n=4 partition is not a refinement of the n=3 one" | nodes {0, 2/3, 4/3, 2} ⊄ {0, 0.5, 1, 1.5, 2} | confirmed |
| 28 | Case 3 link/embed/alt | `riemanncc.*` is the Lower case; "uses the minimum of f on each subinterval" | [C], [F] | confirmed |
| 29 | Case 4 heading | Upper Riemann Sum, same f | [C] dd | confirmed |
| 30 | Case 4 Behavior | "Each rectangle uses the maximum of f on its subinterval" | [C] `fmax`; [F] n=1 height 1.91976 = f(0.0803835), so the interior peak is captured | confirmed |
| 31 | Case 4 Behavior | "every frame's sum is an upper bound for the integral" | [I] upper_n ≥ I for all 24 n | confirmed |
| 32 | Case 4 Behavior | "Lower and upper sums squeeze the exact value as n → ∞" | f is continuous; [I] the gap shrinks from 3.125 (n=1) to 0.0720 (n=120) | confirmed |
| 33 | Case 4 Behavior | "at n=120, 1.978951 ≤ I ≤ 2.050951" | [I] lower 1.978951, upper 2.050951, I = 2.016280; [F] last frames | confirmed |
| 34 | Case 4 Behavior | "upper sum rises from 2.418035 at n=7 to 2.427098 at n=8" | [I] 2.418035, 2.427098; [S] the same; [F] dd frame_008/009 | confirmed |
| 35 | Case 4 Behavior | "not monotonically along this sequence of n" | [I] the upper sequence decreases except at 7→8 | confirmed |
| 36 | Case 4 link/embed/alt | `riemanndd.*` is the Upper case | [C], [F] | confirmed |

### 3. Implementation checks

### `riemannaa.jl` (Left Riemann sum)
- **Method:** `left_sum(n) = Δx Σ_{i=0}^{n-1} f(a+iΔx)`. This is the standard left sum, the same as Description l.15.
- **Numbers:** All 24 values from the instrumented copy match my independent mpmath sum to 6 dp. Selected values (script / independent):
  - n=1: 2.000000 / 2.000000
  - n=3: 1.893096 / 1.893096
  - n=16: 1.977936 / 1.977936
  - n=120: 2.014795 / 2.014795
- **Closed-form check:** I ran the script's `left_sum` with f = x² on [0,2]. It equals 8/n³·Σi² exactly (n=4: 1.75; n=120: 2.633425926).
- **Convergence property:** The error from n=64 to n=120 falls by a factor of 2.74 (0.004073 → 0.001485). This is consistent with an h^{5/3} term from the x^{2/3} cusp at 0, which dominates the h·(f(b) − f(a))/2 term because f(b) ≈ f(a).
- **Reference:** No reference value is drawn.
- **Picture:** Rectangles are `[xl, xr] × [0, f(xl)]`; the frames match. Frame 1 is the curve only, and frames 2–25 are n = 1 … 120. The annotation "Sample Points = n" is correct: a left sum has n sample points. The y-limit of 2.1 exceeds max f = 1.91976, so nothing is clipped.

### `riemannbb.jl` (Right Riemann sum)
- **Method:** `right_sum(n) = Δx Σ_{i=1}^{n} f(a+iΔx)`, the standard right sum.
- **Numbers:** All 24 match independent values to 6 dp. Selected values (script / independent):
  - n=1: 2.035850 / 2.035850
  - n=3: 1.905046 / 1.905046
  - n=72: 2.013410 / 2.013410
  - n=120: 2.015094 / 2.015094
- **Closed-form check:** with f = x², `right_sum` equals 8/n³·Σ_{1}^{n} i² (n=4: 3.75).
- **Reference:** none drawn.
- **Picture:** heights are f(xr). This is correct in the frames, for example n=3 gives 0.911, 0.93, 1.018.

### `riemanncc.jl` (Lower sum)
- **Method:** The exact Darboux lower sum. On each cell the script takes the minimum of f over the endpoints plus the interior critical points.
  - Critical points come from sign changes of the analytic f′ on a 20000-point grid starting at x = 1e-4, refined by 60 bisections.
  - f′ is correct: d/dx[e^{-x} sin(8x^{2/3})] = e^{-x}[(16/3)x^{-1/3} cos(8x^{2/3}) − sin(8x^{2/3})].
  - Near 0⁺, f′ → +∞, so no critical point is missed in (0, 1e-4). My independent grid from 1e-9 with 400001 points finds the same four critical points.
- **Variant note:** Mathews' `LowerRiemann` (image `gr_226`) takes the minimum over a finite sample grid `Xvals`, which is an approximation; the legacy GIF gives 0.714411 at n=1. The script computes the true infimum (0.714407). That is a legitimate and more accurate version, and the page describes it correctly ("minimum of f on its subinterval").
- **Numbers:** independent check = dense 2001-point sampling per cell plus bounded `scipy.optimize.minimize_scalar` refinement plus endpoints. All 24 match the script to 6 dp. Selected values (script / independent):
  - n=1: 0.714407 / 0.714407
  - n=3: 1.374576 / 1.374576
  - n=4: 1.192004 / 1.192004
  - n=72: 1.953170 / 1.953170
  - n=120: 1.978951 / 1.978951
- **Closed-form check:** with f = x², which is increasing with no critical points, `lower_sum` equals the left sum exactly (n=4: 1.75; n=120: 2.633425926).
- **Reference:** I = 2.016280, which appears in the page text only. Verified with mpmath to 30 digits, by two methods that agree: 2.01627971961709633.
- **Picture:** Rectangle heights are `fmin(xl, xr)`. Checked in the n=3 and n=4 frames, where the interior minimum at 0.432 is used correctly and each top touches the curve at its minimum. The annotation reads "Subintervals = n".

### `riemanndd.jl` (Upper sum)
- **Method:** the exact Darboux upper sum, with the same critical-point machinery as cc.
- **Numbers:** All 24 match independent dense-sampling plus refinement to 6 dp. Selected values (script / independent):
  - n=1: 3.839512 / 3.839512 (= 2 × 1.9197559)
  - n=7: 2.418035 / 2.418035
  - n=8: 2.427098 / 2.427098
  - n=120: 2.050951 / 2.050951
- **Closed-form check:** with f = x², `upper_sum` equals the right sum exactly.
- **Reference:** none drawn.
- **Picture:** Heights are `fmax`. At n=1 the rectangle top is at 1.92, the interior peak, inside the y-limit of 2.1. The annotation sits inside the rectangle in the n=1 frame but stays readable (frame_002). At n=7 and n=8 the frames show the stated values.

### Regeneration and frame counts
The manifest reports that all four scratch runs exit 0 and reproduce the committed GIFs byte-identically. Each GIF has 25 frames: n = 0 (curve only) followed by the 24 values in `n_seq`. The page states no frame count.

