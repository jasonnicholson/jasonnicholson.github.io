# Riemann Sums — animation review (round 6)

Page: `pages/numerical-methods/riemann-sums/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every numerical claim, behaviour claim, wiring link and formula on the page matches my independent computation and the frames.

Observations that are not findings (cosmetic, nothing misleading):
- `riemannaa.jl:41` and `riemannbb.jl:41` format the on-frame value with `round(approx; digits=6)`. This drops trailing zeros: the left sum at n=6 shows "1.8522" (true value 1.852200399), and the right sum at n=72 shows "2.01341" (true value 2.013409706). Each value is still correct to 6 decimals. The lower and upper scripts use `%.6f`. If the owner wants a consistent look, `@sprintf("%.6f", approx)` would fix it.
- The left and right frames label n as "Sample Points" (the legacy wording), while the lower and upper frames say "Subintervals". Both are accurate.
- The page differs from the legacy archive in a way that is more correct, so it is not a Fidelity finding. The legacy Lower and Upper GIFs appear to use sampled minima and maxima. For example:
  - At n=32, the legacy lower sum is 1.872235; the exact infimum sum is 1.870891.
  - At n=32, the legacy upper sum is 2.137833; the exact value is 2.139327.
  - At n=4, the legacy upper sum is 2.843070; the exact value is 2.843078.

  The page's scripts compute the exact minima and maxima (endpoints plus interior critical points). Where the legacy sums are deterministic, they agree with the page to 6 digits: left sums at n=4, 8 and 32 are 1.797590, 1.904354 and 2.003771; lower sums at n=12, 16 and 24 are 1.660983, 1.726233 and 1.817359.
- Legacy `Quadrature/RiemannSum/RiemannSum.html` also links a Midpoint Rule animation. The site has a separate `midpoint-rule` page, and the legacy `Animations/Riemann/Riemann.html` lists exactly the four cases this page has. I don't count this as a dropped case.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `riemannaa.jl` | 0 | 8.3 | riemannaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemannbb.jl` | 0 | 7.6 | riemannbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanncc.jl` | 0 | 9.0 | riemanncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanndd.jl` | 0 | 9.7 | riemanndd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "partitioning $[a,b]$ into $n$ subintervals … $\Delta x=(b-a)/n$" | All scripts use `dx=(b-a)/n` | confirmed |
| D2 | "As $n$ increases … the approximation converges to the true integral" | All four sequences reach within 0.035 of I=2.016280 at n=120 and are trending in; f is continuous, so it is Riemann-integrable | confirmed |
| D3 | "nodes $x_i=a+i\Delta x$", "$L_n=\sum_{i=0}^{n-1}f(x_i)\Delta x$" | `riemannaa.jl:18` sums `i in 0:n-1`; independent sums match to 5e-11 | confirmed |
| D4 | "$R_n=\sum_{i=1}^{n}f(x_i)\Delta x$" | `riemannbb.jl:18` sums `i in 1:n`; matches the independent computation | confirmed |
| D5 | "lower, and upper sums … bounds from interval minima/maxima" | `fmin`/`fmax` use exact extrema (see section 3) | confirmed |
| D6 | "legacy Mathews animations increase sampling density over the entire interval between frames. The animations below follow that same pattern." | Legacy frames go n=1,4,(6),8,12,16,24,32,50,70,100, always across the full [0,2]; the page goes n=1…120 across the full interval | confirmed |
| A1 | "Riemann sum diagram over $[0,2]$" | `a, b = 0.0, 2.0` in all four scripts; frame x-axes run 0–2 | confirmed |
| A2 | "$y=e^{-x}\sin(8x^{2/3})+1$" (intro and all four headings) | `f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1` in all four; the same function is in the legacy GIF titles | confirmed |
| A3 | "Between frames, the number of subintervals $n$ increases across the full interval … not by sweeping left-to-right" | `n_seq` is strictly increasing; every frame redraws all n rectangles across [0,2] (frames checked: 1, 4, 7, 10, 13, 16, 19, 22, 25 of each GIF) | confirmed |
| A4 | "Julia source scripts … are linked under each case" | Four links, one per case | confirmed |
| C1a | Case 1 heading "Left Riemann Sum" | `riemannaa.jl` uses height `f(xl)`; frame title is "Left Riemann Sum" | confirmed |
| C1b | "rectangle height on each subinterval is taken at the **left endpoint**" | `riemannaa.jl:33` sets `h = f(xl)`; the n=3 frame shows heights 1.000, 0.91, 0.93 = f(0), f(2/3), f(4/3) | confirmed |
| C1c | "As sample-point density increases, the approximation settles toward the true integral" | L_n = 2.000, 2.364, 1.893, 1.798, then increases monotonically to 2.014795 at n=120 (I=2.016280). There are early oscillations (n=1→2→3→4), then it settles | confirmed |
| C1d | Alt text: "each frame increases partition density and updates the left-endpoint area estimate" | Frames show n increasing and the annotation updating with values that match L_n | confirmed |
| C1e | Wiring: `riemannaa.jl` / `riemannaa.gif` | The script writes `riemannaa.gif`; the GIF title is "Left Riemann Sum"; the GIF is byte-identical to a regenerated copy | confirmed |
| C2a | Case 2 heading "Right Riemann Sum" | `riemannbb.jl:33` sets `h = f(xr)`; frame title is "Right Riemann Sum" | confirmed |
| C2b | "rectangle height is taken at the **right endpoint**" | The n=3 frame shows heights 0.91, 0.93, 1.018 = f(2/3), f(4/3), f(2) | confirmed |
| C2c | "Comparing with Case 1 shows how endpoint choice shifts the approximation at finite $n$" | R_n − L_n = Δx(f(2)−f(0)), which is 0.03585, 0.017925, 0.003585 and 0.000299 at n=1, 2, 10 and 120 (identical to 2/n·0.0179248). There is a shift; it is small because f(2)≈f(0). The statement is true | confirmed |
| C2d | Alt text for the right-endpoint case | As C1d | confirmed |
| C2e | Wiring: `riemannbb.jl` / `riemannbb.gif` | Correct; the GIF is byte-identical to a regenerated copy | confirmed |
| C3a | Case 3 heading "Lower Riemann Sum" | `riemanncc.jl` uses `fmin` = exact minimum on each subinterval | confirmed |
| C3b | "Each rectangle uses the **minimum of $f$ on its subinterval**" | Script values match my independent bounded-minimizer computation to 5e-11 (table below); the n=4 frame shows heights 0.357 (the interior minimum at 0.432), 0.43, 0.80, 0.80 | confirmed |
| C3c | "every frame's sum is a lower bound for the integral" | All 24 lower sums are below I (max 1.978951) | confirmed |
| C3d | "$I\approx 2.016280$" | mpmath quad gives 2.0162797196171 by two independent routes (direct, and the substitution x=t³) | confirmed |
| C3e | "The sums approach $I$ as $n$ grows" | Rises to 1.978951 at n=120; gap 0.037, shrinking | confirmed |
| C3f | "the lower sum falls from 1.374576 at $n=3$ to 1.192004 at $n=4$" | Script: 1.3745762078 and 1.1920041540. Independent: same. This is the only decrease in the sequence | confirmed |
| C3g | "can happen because the $n=4$ partition is not a refinement of the $n=3$ one" | {0,0.5,1,1.5,2} does not contain 2/3 or 4/3, so it is not a refinement; only refinements guarantee monotone lower sums | confirmed |
| C3h | Alt text: "increases the number of subintervals and uses the minimum of f on each subinterval" | Frames match | confirmed |
| C3i | Wiring: `riemanncc.jl` / `riemanncc.gif` | Correct; the GIF is byte-identical to a regenerated copy | confirmed |
| C4a | Case 4 heading "Upper Riemann Sum" | `riemanndd.jl` uses `fmax` | confirmed |
| C4b | "Each rectangle uses the **maximum of $f$ on its subinterval**" | Matches the independent maximizer to 5e-11; the n=1 frame's height is 1.91976 = global max at x=0.0804 (2·1.91976=3.839512, matching the annotation) | confirmed |
| C4c | "every frame's sum is an upper bound for the integral" | All 24 upper sums exceed I (min 2.050951) | confirmed |
| C4d | "Lower and upper sums squeeze the exact value as $n\to\infty$" | Gap Up−Lo = 3.125 at n=1 and 0.0720 at n=120, decreasing; standard Darboux result for continuous f | confirmed |
| C4e | "at $n=120$, $1.978951 \le I \le 2.050951$" | Script: 1.9789510237 and 2.0509510464; independent: same; I=2.016280 lies between them | confirmed |
| C4f | "not monotonically … the upper sum rises from 2.418035 at $n=7$ to 2.427098 at $n=8$" | Script: 2.4180348322 and 2.4270980115; independent: same. This is the only increase in the sequence | confirmed |
| C4g | Alt text for the upper case | Frames match | confirmed |
| C4h | Wiring: `riemanndd.jl` / `riemanndd.gif` | Correct; the GIF is byte-identical to a regenerated copy | confirmed |
| F1 | Frame annotations: values shown in each GIF (checked n=3, 6, 10, 16, 28, 48, 72, 120 in all four, plus lower n=4 and upper n=1) | All agree with the independent values to 6 dp (left/right show trailing zeros dropped, see observations) | confirmed |

### 3. Implementation checks

Commands used:
- `julia review/inst_riemann{aa,bb,cc,dd}.jl > review/inst_out.txt` runs the script copies with the animation removed and print loops added.
- `/usr/bin/python3 -I review/indep.py`, which computes:
  - left and right sums directly with numpy, using `cbrt(x)**2` for x^{2/3};
  - lower and upper sums as the min/max over 4001 samples per subinterval, polished with `scipy.optimize.minimize_scalar` (bounded, xatol 1e-13). This uses no derivative and no critical-point list;
  - I with `mpmath.quad` at 30 digits, both directly and after substituting x=t³.
- The comparison script reports max |script − independent| = 5.0e-11 across all 96 values. That is the print-precision limit of the independent output.

### Values side by side (script = independent to the shown digits)

| n | Left | Right | Lower | Upper |
|---|---|---|---|---|
| 1 | 2.0000000000 | 2.0358496324 | 0.7144073719 | 3.8395118984 |
| 2 | 2.3639645589 | 2.3818893751 | 1.1527922985 | 3.2837205081 |
| 3 | 1.8930959070 | 1.9050457845 | 1.3745762078 | 2.8814604949 |
| 4 | 1.7975902842 | 1.8065526923 | 1.1920041540 | 2.8430776506 |
| 7 | 1.8814216812 | 1.8865430572 | 1.5417683885 | 2.4180348322 |
| 8 | 1.9043543283 | 1.9088355323 | 1.6015612632 | 2.4270980115 |
| 16 | 1.9779355558 | 1.9801761578 | 1.7262325029 | 2.2409175443 |
| 32 | 2.0037709616 | 2.0048912626 | 1.8708907285 | 2.1393265300 |
| 72 | 2.0129117945 | 2.0134097061 | 1.9531704595 | 2.0730976085 |
| 120 | 2.0147950912 | 2.0150938381 | 1.9789510237 | 2.0509510464 |

All 24 n values appear in `inst_out.txt` and `indep_out.txt`, and all agree. Reference value: I = 2.0162797196171.

### `riemannaa.jl` (Left)
- **Method:** the left-endpoint Riemann sum, `Δx·Σ_{i=0}^{n-1} f(a+iΔx)`. The drawing uses the same `f(xl)` heights.
- **Numbers:** match the independent values (table).
- **Reference values:** the script draws no reference value.
- **Picture:** rectangles span `[xl, xl+dx]` with height `f(xl)`; the curve is f on 800 points. ylims (0, 2.1) contain f's range [0.3572, 1.9198] (dense-grid check), so nothing is clipped. There are 25 frames: n=0 (curve only) followed by the 24 n values. The annotation values match.

### `riemannbb.jl` (Right)
- **Method:** the right-endpoint sum, `Σ_{i=1}^{n}`, with height `f(xr)`.
- **Numbers:** match the independent values. As a structural check, R_n − L_n = Δx(f(2)−f(0)) holds exactly at n=1, 2, 10 and 120.
- **Picture:** correct geometry and annotations. No clipping.

### `riemanncc.jl` (Lower) and `riemanndd.jl` (Upper)
- **Method:** lower and upper (Darboux) sums. Each subinterval's extremum is taken over the endpoints plus the interior critical points.
- **Derivative:** `fp` (line 20) = e^{-x}((16/3)x^{-1/3}cos(8x^{2/3}) − sin(8x^{2/3})). This is the correct derivative of f.
- **Critical points:** the script finds them by sign changes on a 20000-point grid starting at x=1e-4, then bisects. That gives 0.080384, 0.431982, 0.939205 and 1.564476.
  - These agree with the independent dense-grid argmax (0.080384) and argmin (0.431982).
  - The count of four is complete. f'=0 means tan u = (16/3)x^{-1/3} with u = 8x^{2/3} ∈ (0, 12.70]. The right-hand side is large and positive, so the roots lie just below u = π/2, 3π/2, 5π/2 and 7π/2 (π/2 ≈ 1.57, 3π/2 ≈ 4.71, 5π/2 ≈ 7.85, 7π/2 ≈ 11.0). The next candidate, near 9π/2 ≈ 14.1, lies outside the range of u. Each of these four roots matches one point the script found.
  - No critical point lies in (0, 1e-4), because f' → +∞ there.
- **Numbers:** match the independent derivative-free min/max sums to 5e-11. So the exact-extremum logic is right for every subinterval of every n.
- **Reference values:** I is not drawn. The page's I≈2.016280 is confirmed by the mpmath computation above.
- **Picture:** heights are drawn from the same `fmin`/`fmax` used in the sum.
  - Lower n=4 frame: the first rectangle's height is 0.357 = f(0.432), the interior minimum. Correct.
  - Upper n=1 frame: the height is 1.9198 = the global max. Correct.
  - In the upper n=1 and n=2 frames the annotation text sits over the shaded rectangle, but it stays legible.
  - 25 frames. Annotations match.

