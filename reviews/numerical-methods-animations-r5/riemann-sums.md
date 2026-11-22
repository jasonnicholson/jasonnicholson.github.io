# Riemann Sums — animation review (round 5)

Page: `pages/numerical-methods/riemann-sums/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Errors: 0. Misleading: 0. Minor: 0.

Every numerical claim on the page agrees with an independent computation to all stated digits. The four scripts implement the methods their titles name, and every frame I inspected draws the quantities the code computes. The observations below were checked and judged **not** to be findings. They are recorded so the clean result can be audited.

- **Number formatting in Left/Right frames.** `riemannaa.jl:41` and `riemannbb.jl:41` use `round(approx; digits=6)`, so trailing zeros are dropped: "Approximation = 2.0" (n=1), "1.79759" (n=4), "1.8522" (n=6), "2.01341" (Right, n=72). Lower/Upper use `%.6f`. Every displayed value is correct, and Mathews' own table prints the same way ("2.", "1.79759"). This is cosmetic.
- **Upper n=1 frame.** The rectangle top at y=1.9198 runs just above the "Subintervals = 1" text at y=1.88. The text is still readable.
- **Case 2 "shifts the approximation".** The shift is exactly R_n − L_n = (f(2) − f(0))·Δx = 0.035850/n, which is small because f(0)=1 and f(2)=1.017925. The sentence is true. Saying that the shift is small would be a teaching improvement, not a correction.
- **Fidelity.** Mathews' Example 10–13 header formula reads `f[x] = 1 + e^{-x} Sin[9/2 x]` (images `RiemannSumMod_gr_176.gif`, `gr_227.gif`). But his code (`gr_178.gif`, `gr_229.gif`) defines `f[x_] = 1 + E^-x Sin[8 x^(2/3)]` over [0, 2], and his graph (`gr_200.gif`) is that function. The page uses the code/graph function, so it is faithful. Mathews' n-sequence is {1,2,4,6,8,10,12,14,16,20,24,28,32,40,50,60,70,80,100,120}, and the page uses a different increasing sequence ending at 120. A reader would not be affected by this. Mathews' Lower/Upper table values differ from the page's in the 6th digit (e.g. Lower n=4: 1.192005 vs 1.192004; Upper n=1: 3.83949 vs 3.839512) because he took extrema on a 1201-point grid. The page's values are the exact ones (see §3), so this departure is a correct one. His Left/Right tables match the page exactly at every shared n (e.g. Left n=120 2.014795; Right n=120 2.015094; Lower n=120 1.978951; Upper n=120 2.050951). The Mathews animation index also has a Midpoint Rule animation that this page omits. It lives on the site's own `midpoint-rule` page with the same f and interval, so nothing is dropped.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `riemannaa.jl` | 0 | 7.9 | riemannaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemannbb.jl` | 0 | 8.0 | riemannbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanncc.jl` | 0 | 8.1 | riemanncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanndd.jl` | 0 | 11.2 | riemanndd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description ¶1 | Partition $[a,b]$ into $n$ subintervals; $\Delta x=(b-a)/n$; as $n$ increases the approximation converges to the true integral | All scripts use `dx=(b-a)/n`. f is continuous on [0,2], so all four sums converge. Computed sums at n=120 are within 0.038 of I and decreasing (table §3) | confirmed |
| D2 | Description ¶2 | $x_i=a+i\Delta x$; $L_n=\sum_{i=0}^{n-1} f(x_i)\Delta x$ | `riemannaa.jl:18` `left_sum` = exactly this | confirmed |
| D3 | Description ¶2 | $R_n=\sum_{i=1}^{n} f(x_i)\Delta x$ | `riemannbb.jl:18` = exactly this | confirmed |
| D4 | Description ¶2 | lower and upper sums are "bounds from interval minima/maxima" | `riemanncc.jl:41,45` uses the true min on each subinterval and `riemanndd.jl:41,45` the true max (endpoints + interior critical points) | confirmed |
| D5 | Description ¶3 | Legacy Mathews animations increase sampling density over the entire interval; the animations below follow that pattern | Mathews' tables use increasing m over [0,2] for Ex. 10–13. The scripts' `n_seq` is strictly increasing and rectangles span all of [0,2] in every frame | confirmed |
| A1 | Animations intro | Each animation is over $[0,2]$ | `a, b = 0.0, 2.0`, `xlims=(0,2)` in all four | confirmed |
| A2 | Animations intro | Function $y=e^{-x}\sin(8x^{2/3})+1$ | `f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1` in all four. The frame curve matches (peak 1.9198 at x=0.0804, min 0.3572 at x=0.4320) | confirmed |
| A3 | Animations intro | Between frames, $n$ increases across the full interval, refining by density, not by sweeping left-to-right | Frame 1 is the curve only (n=0). Frames 2–25 have n=1,2,…,8,10,…,120 with full-width tilings (frames inspected: 2,4,7,10,13,16,19,22,25 of each GIF) | confirmed |
| A4 | Animations intro | Julia sources linked under each case | Each case links its own script (aa/bb/cc/dd) | confirmed |
| C1a | Case 1 heading | Left Riemann Sum, same f | `riemannaa.jl`, title "Left Riemann Sum", same f | confirmed |
| C1b | Case 1 Behavior | Height taken at the **left endpoint** | `riemannaa.jl:33` `h = f(xl)`. Frame n=3 heights 1.000, 0.909, 0.931 = f(0), f(2/3), f(4/3) | confirmed |
| C1c | Case 1 Behavior | As density increases, the approximation settles toward the true integral | L_n: 2.0, 2.364, 1.893, 1.798, then monotonically increasing 1.818 → 2.014795 (n=120). I = 2.016280, final error 1.48e-3 | confirmed |
| C1d | Case 1 alt text | Each frame increases partition density and updates the left-endpoint area estimate | Frames 2–25 do this. Frame 1 is the bare curve | confirmed |
| C1e | Case 1 wiring | `[Julia source](riemannaa.jl)`, `![…](riemannaa.gif)` | Committed GIF is byte-identical to a scratch regen of `riemannaa.jl` (manifest) | confirmed |
| C2a | Case 2 heading | Right Riemann Sum, same f | `riemannbb.jl`, title "Right Riemann Sum" | confirmed |
| C2b | Case 2 Behavior | Height taken at the **right endpoint** | `riemannbb.jl:33` `h = f(xr)`. Frame n=3 heights 0.909, 0.931, 1.018 = f(2/3), f(4/3), f(2) | confirmed |
| C2c | Case 2 Behavior | Comparing with Case 1 shows how endpoint choice shifts the approximation at finite $n$ | R_n − L_n = 0.035850/n > 0 at every n (0.03585 at n=1, 0.00030 at n=120) | confirmed (the shift is real but small) |
| C2d | Case 2 alt text / wiring | Right-endpoint estimate; riemannbb.jl / .gif | As C1d/C1e. GIF byte-identical to regen | confirmed |
| C3a | Case 3 heading | Lower Riemann Sum, same f | `riemanncc.jl`, title "Lower Riemann Sum" | confirmed |
| C3b | Case 3 Behavior | Each rectangle uses the minimum of $f$ on its subinterval | `fmin` = min over endpoints and interior critical points. The critical points match an independent root-find (§3). Frame n=3 heights 0.357, 0.909, 0.796 = true minima | confirmed |
| C3c | Case 3 Behavior | Every frame's sum is a lower bound for $I$ | All 24 lower sums < I. The largest is 1.978951 at n=120 | confirmed |
| C3d | Case 3 Behavior | $I \approx 2.016280$ | mpmath quad = 2.016279719617096 (two independent quadratures agree) | confirmed |
| C3e | Case 3 Behavior | Sums approach $I$ as $n$ grows, but not monotonically | Increasing except n=3→4. Reaches 1.978951 at n=120 | confirmed |
| C3f | Case 3 Behavior | Lower sum 1.374576 at $n=3$ | independent 1.3745762078 | confirmed |
| C3g | Case 3 Behavior | Lower sum 1.192004 at $n=4$ | independent 1.1920041540 | confirmed |
| C3h | Case 3 Behavior | The $n=4$ partition is not a refinement of the $n=3$ one | 4 is not a multiple of 3 (e.g. node 2/3 is not a node of the n=4 partition) | confirmed |
| C3i | Case 3 alt text / wiring | Minimum of f on each subinterval; riemanncc.jl / .gif | As above. GIF byte-identical to regen | confirmed |
| C4a | Case 4 heading | Upper Riemann Sum, same f | `riemanndd.jl`, title "Upper Riemann Sum" | confirmed |
| C4b | Case 4 Behavior | Each rectangle uses the maximum of $f$ on its subinterval | `fmax` analogous to `fmin`. Frame n=3 heights 1.920, 1.385, 1.018 = true maxima | confirmed |
| C4c | Case 4 Behavior | Every frame's sum is an upper bound | All 24 upper sums > I. The smallest is 2.050951 at n=120 | confirmed |
| C4d | Case 4 Behavior | Lower and upper sums squeeze the exact value as $n\to\infty$ | U_n − L_n falls from 3.125 (n=1) to 0.0720 (n=120) and f is continuous | confirmed |
| C4e | Case 4 Behavior | At $n=120$, $1.978951 \le I \le 2.050951$ | independent: 1.9789510237 ≤ 2.0162797 ≤ 2.0509510464 | confirmed |
| C4f | Case 4 Behavior | Not monotone: upper sum rises from 2.418035 at $n=7$ to 2.427098 at $n=8$ | independent: 2.4180348322 → 2.4270980115. This is the only rise in the sequence | confirmed |
| C4g | Case 4 alt text / wiring | Maximum of f on each subinterval; riemanndd.jl / .gif | As above. GIF byte-identical to regen | confirmed |
| F1 | Frames (all) | Annotation "Sample Points / Subintervals = n" and "Approximation = …" | Spot-checked n=1,3,6,10,16,28,48,72,120 in each GIF against the independent table. All agree to the displayed digits | confirmed |

### 3. Implementation checks

**Method.** I instrumented scratch copies (`review/inst_{aa,bb,cc,dd}.jl`) with the animation block disabled, so they print each sum at every n. I wrote an independent Python implementation (`review/indep.py`) that does the following:

- It computes I with `mpmath.quad`, both directly (split at the extrema) and after the substitution x=t³, which removes the x^{-1/3} derivative singularity. The two values agree to 30 digits: **I = 2.016279719617096**.
- It finds critical points as roots of g(u) = (16/3)cos(8u²) − u·sin(8u²), with u = x^{1/3}, on a 200 001-point grid starting at u=1e-9 and refined with findroot. This form of f′ has no singularity and is independent of the script's grid.
- It computes the subinterval min/max by a 2001-point scan followed by bounded Brent minimisation. This uses no critical-point list.

Critical points:

- Script: 0.08038354937224365, 0.43198195723294985, 0.9392052471495191, 1.5644755011307958
- Independent: 0.08038354937224367, 0.43198195723294996, 0.9392052471495191, 1.5644755011307958

Both find 4 points, the same 4. None was missed near x=0, where f′ → +∞ (the script's grid starts at x=1e-4, and f is increasing on (0, 0.0804)). f at these points: 1.919756, 0.357204, 1.384510, 0.795589.

Sums (script value = independent value to all 10 printed digits in every row; abbreviated here):

| n | Left (script / indep) | Right | Lower | Upper |
|---|---|---|---|---|
| 1 | 2.0000000000 / 2.0000000000 | 2.0358496324 / same | 0.7144073719 / same | 3.8395118984 / same |
| 2 | 2.3639645589 / same | 2.3818893751 / same | 1.1527922985 / same | 3.2837205081 / same |
| 3 | 1.8930959070 / same | 1.9050457845 / same | 1.3745762078 / same | 2.8814604949 / same |
| 4 | 1.7975902842 / same | 1.8065526923 / same | 1.1920041540 / same | 2.8430776506 / same |
| 7 | 1.8814216812 / same | 1.8865430572 / same | 1.5417683885 / same | 2.4180348322 / same |
| 8 | 1.9043543283 / same | 1.9088355323 / same | 1.6015612632 / same | 2.4270980115 / same |
| 16 | 1.9779355558 / same | 1.9801761578 / same | 1.7262325029 / same | 2.2409175443 / same |
| 48 | 2.0097964924 / same | 2.0105433597 / same | 1.9202667838 / same | 2.0999894970 / same |
| 120 | 2.0147950912 / same | 2.0150938381 / same | 1.9789510237 / same | 2.0509510464 / same |

All 24 n values were compared, and all agree. The full output is in the command logs of `inst_*.jl` and `indep.py`.

### `riemannaa.jl` — Left Riemann Sum
- *Method:* the left-endpoint rule, `f(a+iΔx)` for i=0..n−1, which is exactly D2.
- *Numbers:* match the independent computation at all 24 n. They also match Mathews' Left table at every shared n.
- *Reference values:* the script draws no reference integral.
- *Picture:* rectangles span [x_i, x_{i+1}] with height f(x_i), and the n=3 heights equal f(0), f(2/3), f(4/3) = 1.000, 0.909, 0.931. The title, labels and values agree with the code. ylims (0, 2.1) contain max f = 1.9198, so nothing is clamped. There are 25 frames (blank + 24) with no duplicate frames (frames.md5).

### `riemannbb.jl` — Right Riemann Sum
- *Method:* the right-endpoint rule, i=1..n, which is exactly D3.
- *Numbers:* match at all n. The identity R_n − L_n = (f(2) − f(0))·(2/n) = 0.017925·2/n = 0.035850/n holds: e.g. n=1 0.0358496, n=120 0.0002987.
- *Reference values:* none drawn.
- *Picture:* height f(x_{i+1}). The n=3 heights 0.909, 0.931, 1.018 are correct. No clamping, 25 frames.

### `riemanncc.jl` — Lower Riemann Sum
- *Method:* a true lower Darboux sum (infimum on each subinterval). f is continuous, so the min is attained at an endpoint or at an interior critical point. The script gets the critical points by sign changes of an analytic f′ on a 20 000-point grid followed by 60 bisections. The f′ formula agrees with sympy's derivative.
- *Numbers:* match the independent scan+Brent computation (which does not use critical points) at all n to 10 digits.
- *Reference values:* the page's I ≈ 2.016280 is correct (2.0162797196).
- *Picture:* the n=1 height is 0.3572, the global min. The n=3 heights 0.357, 0.909, 0.796 are correct. Every rectangle lies under the curve in the inspected frames. 25 frames, no clamping.

### `riemanndd.jl` — Upper Riemann Sum
- *Method:* a true upper Darboux sum, using the same machinery with `maximum`.
- *Numbers:* match at all n.
- *Reference values:* the n=120 bracket and the n=7→8 rise are both confirmed.
- *Picture:* the n=1 height is 1.9198, the global max. The n=3 heights 1.920, 1.385, 1.018 are correct. Every rectangle covers the curve. The top edge at n=1 sits just above the annotation, which stays readable. 25 frames.

Nothing in this review was left undetermined.

