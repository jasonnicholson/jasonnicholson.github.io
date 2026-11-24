# Riemann Sums — animation review (round 8)

Page: `pages/numerical-methods/riemann-sums/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** 0 Error, 0 Misleading, 0 Minor.

Observations that I judged not to be findings:
- `riemannaa.jl` and `riemannbb.jl` lines 41 use `round(approx; digits=6)`, which drops trailing zeros. As a result, frames show "Approximation = 2.0" (L, n=1), "1.8522" (L, n=6), "2.03585" (R, n=1) and "2.01341" (R, n=72), while the Lower and Upper scripts print `%.6f`. Every shown value is correct to the digits displayed (for example, L_1 = 2·f(0) = 2 exactly), so the display is inconsistent but not misleading. A cosmetic fix would be `@sprintf("%.6f", approx)`.
- In the legacy archive, the Left and Right animations mark the sample points with red dots and use a different n sequence (it includes 50, 70 and 100). The page has no dots and uses n = …, 48, 56, 64, 72, 88, 104, 120. Neither change alters what a reader learns.
- The legacy Midpoint animation is not on this page. It is covered by the site's separate `midpoint-rule` page, which uses the same function, so nothing was dropped.
- At n = 32 and n = 70, the legacy lower-sum frames show 1.872235 and 1.954392. The true lower sums are 1.870891 and 1.951344 (mpmath). The legacy values are wrong, but the page does not use them.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `riemannaa.jl` | 0 | 7.7 | riemannaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemannbb.jl` | 0 | 12.8 | riemannbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanncc.jl` | 0 | 8.8 | riemanncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanndd.jl` | 0 | 8.2 | riemanndd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | Partition into n subintervals, Δx=(b−a)/n, approximation converges to the true integral as n increases | f is continuous on [0,2] (f(0)=1), so it is Riemann integrable. All four sequences approach I=2.0162797 (table below) | confirmed |
| 2 | Description | x_i=a+iΔx; L_n=Σ_{i=0}^{n-1} f(x_i)Δx; R_n=Σ_{i=1}^{n} f(x_i)Δx | Matches `left_sum` (aa l.18) and `right_sum` (bb l.18) exactly | confirmed |
| 3 | Description | Lower and upper sums are "bounds from interval minima/maxima" | cc and dd take the exact min/max over endpoints and interior critical points. Every lower sum is ≤ I and every upper sum is ≥ I (indep.py, all 24 n) | confirmed |
| 4 | Description | Legacy Mathews animations increase sampling density over the entire interval between frames | Legacy Left/Lower frames show n = 1, 4, 8, 12, 16, 24, 32, 50, 70, 100, …, each covering all of [0,2] | confirmed |
| 5 | Intro | Each animation is over [0,2] for y=e^{-x}sin(8x^{2/3})+1 | All scripts: `f(x) = exp(-x)*sin(8*x^(2/3))+1`, `a,b=0,2`, `xlims=(0,2)` | confirmed |
| 6 | Intro | Between frames n increases across the full interval (density, not a left-to-right sweep) | `n_seq` is strictly increasing (1…120) after a blank frame 1. Every frame draws all n bars (frames inspected) | confirmed |
| 7 | Intro | Julia sources are linked under each case | 4 links, one per case, all present | confirmed |
| 8 | Case 1 heading/link/embed | Left Riemann sum, `riemannaa.jl`, `riemannaa.gif` | aa computes heights at `f(xl)`. The GIF title is "Left Riemann Sum" | confirmed |
| 9 | Case 1 | Rectangle height taken at the left endpoint | aa l.33 `h = f(xl)`. In the frames each bar's top-left corner lies on the curve (n=3, 6, 10, 16) | confirmed |
| 10 | Case 1 | As density increases the approximation settles toward the true integral | L: 2.000000, 2.363965, 1.893096, 1.797590, then increases monotonically to 2.014795 at n=120 (error 0.0015) | confirmed |
| 11 | Case 1 alt | Each frame increases partition density and updates the left-endpoint estimate | Frames 2–25 match this. Frame 1 is the bare curve | confirmed |
| 12 | Case 2 heading/link/embed | Right Riemann sum, `riemannbb.jl`, `riemannbb.gif` | bb uses `f(xr)`. The GIF title is "Right Riemann Sum" | confirmed |
| 13 | Case 2 | Rectangle height taken at the right endpoint | bb l.33 `h = f(xr)`. Frame 2 (n=1) bar height is f(2)=1.01792 | confirmed |
| 14 | Case 2 | Endpoint choice shifts the approximation at finite n | R_n−L_n = Δx(f(2)−f(0)) = 0.035850/n: 0.0358 at n=1, 0.0003 at n=120. Small but nonzero, and the bars visibly differ at small n | confirmed |
| 15 | Case 2 alt | Each frame increases density and updates the right-endpoint estimate | As for #11 | confirmed |
| 16 | Case 3 heading/link/embed | Lower sum, `riemanncc.jl`, `riemanncc.gif` | cc uses `fmin`. The GIF title is "Lower Riemann Sum" | confirmed |
| 17 | Case 3 | Each rectangle uses the minimum of f on its subinterval | `fmin` takes the minimum over the endpoints and the interior critical points of f. The critical points 0.0803835, 0.4319820, 0.9392052, 1.5644755 agree with mpmath to 10 digits. Six-decimal sums agree with an independent dense-sampling minimisation | confirmed |
| 18 | Case 3 | Every frame's sum is a lower bound for I | Every one of the 24 sums is ≤ I | confirmed |
| 19 | Case 3 | I ≈ 2.016280 | mpmath: 2.016279719617096 (also by the substitution x=t³) | confirmed |
| 20 | Case 3 | Sums approach I as n grows, but not monotonically | Lower sum: 0.714 → … → 1.978951 at n=120. The only decrease is from n=3 to n=4 | confirmed |
| 21 | Case 3 | Lower sum falls from 1.374576 (n=3) to 1.192004 (n=4) | Script 1.374576 / 1.192004. mpmath 1.374576208 / 1.192004154. Frames show the same values | confirmed |
| 22 | Case 3 | This happens because the n=4 partition is not a refinement of n=3 | Correct reasoning: lower sums are monotone under refinement, and {0,1/2,1,3/2,2} does not contain 2/3 or 4/3 | confirmed |
| 23 | Case 3 alt | Each frame increases n and uses min of f on each subinterval | Frames match | confirmed |
| 24 | Case 4 heading/link/embed | Upper sum, `riemanndd.jl`, `riemanndd.gif` | dd uses `fmax`. The GIF title is "Upper Riemann Sum" | confirmed |
| 25 | Case 4 | Each rectangle uses the maximum of f on its subinterval | `fmax` follows the same construction as #17, and the values match the independent computation. In frame 2 (n=1) the bar is at max f = 1.919756 | confirmed |
| 26 | Case 4 | Every frame's sum is an upper bound | All 24 upper sums are ≥ I | confirmed |
| 27 | Case 4 | Lower and upper sums squeeze I as n→∞ | The gap shrinks from 3.125 at n=1 to 0.072 at n=120 | confirmed |
| 28 | Case 4 | At n=120, 1.978951 ≤ I ≤ 2.050951 | mpmath 1.978951024 and 2.050951046 | confirmed |
| 29 | Case 4 | The upper sum is not monotone: it rises from 2.418035 (n=7) to 2.427098 (n=8) | Script 2.418035 / 2.427098. mpmath 2.418034832 / 2.427098012 | confirmed |
| 30 | Case 4 alt | Each frame increases n and uses max of f on each subinterval | Frames match | confirmed |

### 3. Implementation checks

All four scripts share f(x)=e^{-x}sin(8x^{2/3})+1 on [0,2] and n_seq = 1–8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 48, 56, 64, 72, 88, 104, 120, with a blank frame first (25 frames, which matches the committed GIFs).

**Method identity.** aa is the left-endpoint sum and bb the right-endpoint sum. cc and dd are the true Darboux lower and upper sums: the exact infimum and supremum on each subinterval, found from the endpoints and the interior critical points. They are not sampled approximations. The `fp` formula is the correct derivative: d/dx sin(8x^{2/3}) = (16/3)x^{-1/3}cos(8x^{2/3}). The critical-point scan starts at x=1e-4, and nothing is lost by that, because f'>0 on (0, 0.0804). The scan spacing of 1e-4 is about 0.01 rad of phase near x=1e-4, so no pair of sign changes can be missed. Exactly 4 critical points exist in (0,2], and mpmath finds the same 4.

**Numbers.** Script output (instrumented copies) beside the independent computation (indep.py):

| n | L script / indep | R script / indep | Lower script / indep | Upper script / indep |
|---|---|---|---|---|
| 1 | 2.0 / 2.000000 | 2.03585 / 2.035850 | 0.714407 / 0.714407 | 3.839512 / 3.839512 |
| 3 | 1.893096 / 1.893096 | 1.905046 / 1.905046 | 1.374576 / 1.374576 | 2.881460 / 2.881460 |
| 4 | 1.79759 / 1.797590 | 1.806553 / 1.806553 | 1.192004 / 1.192004 | 2.843078 / 2.843078 |
| 7 | 1.881422 / 1.881422 | 1.886543 / 1.886543 | 1.541768 / 1.541768 | 2.418035 / 2.418035 |
| 8 | 1.904354 / 1.904354 | 1.908836 / 1.908836 | 1.601561 / 1.601561 | 2.427098 / 2.427098 |
| 32 | 2.003771 / 2.003771 | 2.004891 / 2.004891 | 1.870891 / 1.870891 | 2.139327 / 2.139327 |
| 64 | 2.012207 / 2.012207 | 2.012768 / 2.012768 | 1.945355 / 1.945355 | 2.079985 / 2.079985 |
| 120 | 2.014795 / 2.014795 | 2.015094 / 2.015094 | 1.978951 / 1.978951 | 2.050951 / 2.050951 |

All 24 n agree to 6 decimals in all four columns (full lists are in the command outputs). Property checks: R_n − L_n = Δx(f(2)−f(0)) holds, and Lower ≤ L, R ≤ Upper with Lower ≤ I ≤ Upper for every n.

**Reference values.** I = 2.01627971961710 by adaptive mpmath quadrature split near the x^{2/3} cusp. The substitution x=t³, which makes the integrand smooth, gives the same value. The page's 2.016280 is correct.

**Picture.** I checked the first frame, frames for n = 1, 2, 3, 6, 10, 16, 28, 48 and 72, and the last frame (n=120) of all four GIFs against the code. In aa, bar tops meet the curve at their left corners. In bb (n=1) the bar height is f(2)≈1.018. In cc each bar touches the curve from below at its subinterval minimum, and in dd each bar touches the curve from above at its maximum (n=1 bar at 1.9198). Annotations report the n and the value the script computed for that frame. The y-limit of 2.1 exceeds max f = 1.9198, so nothing is clipped. At n=1 in dd the annotation text sits inside the bar but remains legible.

