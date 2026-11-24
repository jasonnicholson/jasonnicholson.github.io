# Numerical Differentiation — animation review (round 8)

Page: `pages/numerical-methods/numerical-differentiation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Counts: Error 0, Misleading 0, Minor 0.

Considered and not reported (below threshold):
- Case 1 frames 4–12 (h ≤ 0.1) show the two curves visually indistinguishable; the convergence is carried by the title's max-error number. This is a teaching-presentation choice, and the title numbers are correct, so it does not mislead.
- Case 1 y-limits (-1, 1.1) leave the lower half of the plot empty (the curve minimum is about -0.21). Cosmetic only; nothing is clipped (D3(0, 0.5) = 1.0812 < 1.1).
- Case 2 plots on [0, π] where Mathews' Example 14 used [0, 2.1], and uses h = 0.6 ... 0.001 where Example 14 used 0.5 ... 0.01 (the legacy animation used 1.0 ... 0.001). The page does not claim the same step list, and the difference does not matter to a reader.
- `numdiffab.jl` line 26–28 has a `continue` inside `@animate` that would silently drop frames. It never fires (min x0 - h = 0.4 ≥ 0, max x0 + h = 1.6 ≤ π; verified `skip=false` for all 12 h), so all 12 frames are drawn.
- Calling (f(x+h) - f(x-h))/(2h) a "three-point" formula follows Mathews' own naming ("Three point rule for f'"), even though the centre weight is zero. This is a valid convention.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `numdiffaa.jl` | 0 | 7.5 | numdiffaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `numdiffab.jl` | 0 | 7.8 | numdiffab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `numdiffaa.gif` | 12 | byte-identical | numdiffaa |
| `numdiffab.gif` | 12 | byte-identical | numdiffab |

### Page references

- Scripts linked: `numdiffaa.jl`, `numdiffab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.12 | test function is f(x)=e^{-x} sin(x) | archive gr_27, gr_220...; both scripts line 9 | confirmed |
| 2 | Description l.12 | on [0, π] | archive gr_49/51; aa `xlims=(0,pi)` | confirmed |
| 3 | Description l.12 | representative steps h=0.1, 0.01, 0.001 | archive gr_45/47 (Examples 2(a),(b)) | confirmed |
| 4 | Description l.16–18 | D3(x,h) = (f(x+h) - f(x-h))/(2h) | `central3` aa l.12; ab l.34; archive gr_4 | confirmed |
| 5 | Description l.20 | truncation error O(h^2) for smooth f | sympy series: D3 - f' = sqrt2 h^2 e^-x (10 sin(x+π/4) - h^2 cos(x+π/4))/30, i.e. (h^2/6) f'''(x) + O(h^4) | confirmed |
| 6 | Description l.20 | as h decreases truncation error improves, but eventually roundoff and cancellation limit accuracy | double precision at x=1: err 1.69e-3 (h=1e-1) ... 1.67e-11 (1e-5), then grows to 5.2e-10 (1e-8), 4.9e-5 (1e-13) | confirmed |
| 7 | Animations l.24 | each animation shows finite-difference derivative behaviour for f=e^{-x} sin x | both scripts | confirmed |
| 8 | Animations l.24 | "on legacy interval settings from the source module" | Case 1 [0, π] = Ex 2(c). Case 2 is a point derivative at x0=1 (Ex 11/14); its plot window [0, π] differs from Ex 14's [0, 2.1], which is immaterial | confirmed (loosely for Case 2) |
| 9 | l.26 | Case 1 extends Example 2(c), plot of D3(x,h) vs f'(x) on [0, π], from single h=0.01 to a sequence | archive lnk_5: Plot D1[x,0.01] and f'[x] on {x,0,π}; aa hs includes 0.01 | confirmed |
| 10 | l.26 | Case 2 follows Examples 11 and 14, central difference at x0=1 | archive gr_262/263, gr_325/326: f'[1.0]; legacy animations (chord; parabola + parallel line) | confirmed |
| 11 | l.26 | Example 1 = graph of f''' used to bound the error | module text | confirmed |
| 12 | l.26 | Examples 2(a), 2(b) = tables of approximations | module text: compute f'(0), f'(0..3) for h list | confirmed |
| 13 | l.26 | Example 3 = plot of absolute error against the error bound | module text + gr_91–98 | confirmed |
| 14 | l.26 | Example 4 = how the bound shrinks with h | module text + gr_118–121 (1/2 -> 1/4, O(h^2)) | confirmed |
| 15 | l.26 | Examples 9, 10, 12, 13 = forward/backward formulas for f' | module text | confirmed |
| 16 | l.26 | second-derivative formulas = Project II, Examples 5–8, and Examples 15–17 | module text | confirmed |
| 17 | l.26 | no other archive examples dropped silently | all of Ex 1–17 accounted for (2(c), 11, 14 animated; rest listed) | confirmed |
| 18 | Case 1 heading l.28 | central derivative profile D3(x,h) on [0, π] | aa l.16, l.25 | confirmed |
| 19 | Case 1 Behavior l.30 | numerical derivative curve approaches f'(x) as h shrinks | max error decreases monotonically over all 12 frames: 8.13e-2 ... 3.33e-7 | confirmed |
| 20 | Case 1 Behavior l.30 | consistent with second-order truncation error | max err h=0.1: 3.330e-3; 0.01: 3.333e-5; 0.001: 3.333e-7 (factor 100 per factor-10 step); matches h^2/3 = (M3/6)h^2 with f'''(0)=2 | confirmed |
| 21 | Case 1 link l.32 | Julia source = numdiffaa.jl | file exists, is Case 1 | confirmed |
| 22 | Case 1 embed/alt l.34 | 3-point central approx vs true derivative over 0 to π as h decreases | frames 1–12: h 0.5 -> 0.001, black f', blue D3 | confirmed |
| 23 | Case 2 heading l.36 | secant to tangent at x0=1, h -> 0 | ab l.12 x0=1.0; hs 0.6 -> 0.001 | confirmed |
| 24 | Case 2 Behavior l.38 | slope of the symmetric secant (f(x0+h)-f(x0-h))/(2h) converges to f'(x0) | mpmath D3(1,h) - f'(1): 6.14e-2 (h=0.6) ... 1.69e-7 (h=0.001), monotone; f'(1) = -0.110793765 | confirmed |
| 25 | Case 2 Behavior l.38 | as in Example 14, each frame draws the parabola through the three stencil points | ab l.41–42; instrumented: P(x0±h) - f(x0±h) ≤ 6e-17 for all h; green curve in all 12 frames; matches Mathews' q (gr_327) | confirmed |
| 26 | Case 2 Behavior l.38 | and the line through (x0,f(x0)) with the secant slope | ab l.43, purple dotted, all frames; matches Mathews' g | confirmed |
| 27 | Case 2 Behavior l.38 | that slope is the parabola's derivative at x0 | P(x) = y0 + msec(x-x0) + c2(x-x0)^2 => P'(x0) = msec algebraically | confirmed |
| 28 | Case 2 Behavior l.38 | so the line touches the parabola there and runs parallel to the chord | same slope msec; chord S(x0+h) - f(x0+h) = 0 (instrumented); visible in frame 1 | confirmed |
| 29 | Case 2 link l.40 | Julia source = numdiffab.jl | file exists, is Case 2 | confirmed |
| 30 | Case 2 alt l.42 | central secant lines through x0±h, parallel lines through x0, collapsing to the tangent at x0=1, parabola in each frame | frames 1–12 | confirmed |
| 31 | Derivation l.48–50 | f(x±h) = f ± h f' + h^2/2 f'' ± h^3/6 f'''(ξ±) | Taylor with Lagrange remainder | confirmed |
| 32 | Derivation l.52 | leads to central rule with error proportional to h^2 | subtracting: f' - D3 = -(h^2/12)(f'''(ξ+)+f'''(ξ-)) = -(h^2/6) f'''(ξ) | confirmed |
| 33 | Counts (implicit) | 2 cases, 2 scripts, 2 GIFs | manifest; 12 frames each | confirmed |

### 3. Implementation checks

### `numdiffaa.jl` (Case 1)
- **Method:** the standard central difference (f(x+h) - f(x-h))/(2h), l.12, which is Mathews' D1 / the page's D3. Not a neighbouring method.
- **Numbers:** the instrumented copy prints the title's max error (700-point grid). The independent mpmath computation of the true sup over [0, π] (dense scan + bounded optimisation) gives:

| h | script grid max | true sup (mpmath) | h^2/3 |
|---|---|---|---|
| 0.5 | 8.127671e-2 | 8.127702e-2 | 8.333e-2 |
| 0.3 | 2.973127e-2 | 2.973127e-2 | 3.000e-2 |
| 0.2 | 1.328011e-2 | 1.328011e-2 | 1.333e-2 |
| 0.1 | 3.329998e-3 | 3.330002e-3 | 3.333e-3 |
| 0.07 | 1.632533e-3 | 1.632533e-3 | 1.633e-3 |
| 0.05 | 8.331250e-4 | 8.331250e-4 | 8.333e-4 |
| 0.03 | 2.999730e-4 | 2.999730e-4 | 3.000e-4 |
| 0.02 | 1.333280e-4 | 1.333280e-4 | 1.333e-4 |
| 0.01 | 3.333300e-5 | 3.333300e-5 | 3.333e-5 |
| 0.005 | 8.333313e-6 | 8.333312e-6 | 8.333e-6 |
| 0.002 | 1.333333e-6 | 1.333333e-6 | 1.333e-6 |
| 0.001 | 3.333333e-7 | 3.333333e-7 | 3.333e-7 |

  All agree at the title's 3 significant figures. The order-2 property holds (×100 per ÷10 in h).
- **Reference:** `fp(x) = exp(-x)(cos x - sin x)` was verified symbolically to equal d/dx[e^{-x} sin x] (sympy, difference simplifies to 0); it also matches Mathews gr_90.
- **Picture:** the black curve is f', the blue is D3 at the same 700 x points. The title h and max error match the computed values above. No clamping or NaN masking. The y range (-1, 1.1) contains all curves (max D3 = 1.0812 at x=0, h=0.5, visible in frame 1). 12 frames, h decreasing. Legend labels are correct.

### `numdiffab.jl` (Case 2)
- **Method:** symmetric secant slope msec = (f(x0+h) - f(x0-h))/(2h) at x0=1 (l.34), plus Mathews' Example 14 construction: the quadratic through the 3 stencil points (written in Newton/Taylor form about x0, c2 = second difference/(2h^2)), and the line through (x0, f(x0)) with slope msec.
- **Numbers:** script vs mpmath D3(1,h): -0.049354 / -0.04935374; -0.083592 / -0.08359181; -0.100189 / -0.10018941; -0.106979 / -0.10697946; -0.109099 / -0.10909898; -0.109963 / -0.10996341; -0.110370 / -0.11037014; -0.110641 / -0.11064126; -0.110726 / -0.11072599; -0.110777 / -0.11077682; -0.110790 / -0.11078953; -0.110794 / -0.11079360. All match to the 6 decimals shown. They also match the legacy values (-0.049354, -0.083592 in the a2001 animation; -0.109099, -0.110726, -0.110777 in Solution 14). The error shrinks by about 4 per halving (0.1 -> 0.05: 1.695e-3 / 4.236e-4 = 4.00).
- **Reference:** f'(1) = -0.110793765 (mpmath), and the title's "true = -0.110794" is correct. It matches Mathews' printed f'[1.] = -0.110794.
- **Picture:** the instrumented check shows the parabola passes through all 3 stencil points (residual ≤ 6e-17) and the dashed chord passes through both outer points (residual ≤ 3e-17). The purple line has slope msec through (x0, f(x0)), and the red line has slope f'(1) through (x0, f(x0)). The orange markers are at (x0-h, x0, x0+h). Frame 1 (h=0.6) shows the chord through (0.4, 0.261) and (1.6, 0.202) and the parallel purple line touching the parabola at x0. By about h=0.05 everything collapses onto the tangent. The title h and slopes agree with the values above. The y range (-0.1, 0.55) contains every drawn element. 12 frames; the `continue` guard never triggers.

