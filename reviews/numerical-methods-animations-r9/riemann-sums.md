# Riemann Sums — animation review (round 9)

Page: `pages/numerical-methods/riemann-sums/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0.

Every number on the page agrees with an independent computation to the precision stated, and every frame I inspected draws the quantities the code computes. The observations below were checked and judged not to be findings:

- Left/Right GIFs format the estimate with `round(approx; digits=6)`, so trailing zeros drop ("Approximation = 2.0", "1.8522", "1.79759", "2.01341"). Lower/Upper use `%.6f`. All the displayed values are correct (n=1 left sum is exactly 2.0, because f(0)=1 and Δx=2). This is cosmetic and does not mislead.
- Left/Right frames say "Sample Points = n" and Lower/Upper frames say "Subintervals = n". Both are accurate: one sample per subinterval.
- The n sequence (1…120) differs from the legacy one (which ends at 100), and the legacy lower and upper values differ from the page's in the 4th to 6th decimal. Example: legacy lower n=32 gives 1.872235, true value 1.870891; legacy upper n=8 gives 2.427094, true value 2.427098. The legacy values come from sampled extrema: its lower sums run too high and its upper sums too low. The page's values are the exact extrema. A departure that makes the page correct is not a finding.
- The legacy Quadrature/RiemannSum index also lists a Midpoint Rule animation. It is not dropped: it has its own page, `pages/numerical-methods/midpoint-rule/` (`midpointaa.jl`, `midpointaa.gif`).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `riemannaa.jl` | 0 | 8.2 | riemannaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemannbb.jl` | 0 | 9.6 | riemannbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanncc.jl` | 0 | 9.1 | riemanncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `riemanndd.jl` | 0 | 11.8 | riemanndd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description ¶1 | Partition into n subintervals, Δx=(b−a)/n, converges to the true integral as n grows | f is continuous on [0,2], so it is Riemann integrable. All four sequences approach I (table below) | confirmed |
| D2 | Description ¶2 | $x_i=a+i\Delta x$; $L_n=\sum_{i=0}^{n-1}f(x_i)\Delta x$, $R_n=\sum_{i=1}^{n}f(x_i)\Delta x$ | aa.jl:18 sums i in 0:n-1; bb.jl:18 sums i in 1:n | confirmed |
| D3 | Description ¶2 | lower/upper sums are "bounds from interval minima/maxima" | cc/dd.jl:41 take the min/max over the endpoints and interior critical points; checked against brute-force sampling | confirmed |
| D4 | Description ¶3 | Legacy animations increase density over the whole interval; these follow the same pattern | Legacy frames: n = 1,4,8,12,16,24,32,50,70,100… over [0,2]. Page: n over the full [0,2] | confirmed |
| A1 | Animations intro | Riemann sum diagram over [0,2] for $y=e^{-x}\sin(8x^{2/3})+1$ | All scripts lines 8–9 (cc/dd 9–10): `f(x)=exp(-x)*sin(8*x^(2/3))+1`, a=0, b=2; frames' x axis runs 0–2. Matches the legacy title formula | confirmed |
| A2 | Animations intro | n increases between frames across the full interval, not by sweeping left to right | n_seq = 1…120, each frame redraws all n rectangles (frames checked) | confirmed |
| A3 | Animations intro | Julia sources are linked under each case | 4 links resolve to the 4 scripts | confirmed |
| C1a | Case 1 heading | Left Riemann Sum, same f | aa.jl title "Left Riemann Sum", same f | confirmed |
| C1b | Case 1 Behavior | height taken at the left endpoint | aa.jl:31–33 `h=f(xl)`; frames show rectangle top-left corners on the curve | confirmed |
| C1c | Case 1 Behavior | approximation settles toward the true integral | L_n: 2.0, 2.364, 1.893, … 2.014795 at n=120, against I=2.016280 | confirmed |
| C1d | Case 1 link/embed/alt | riemannaa.jl / riemannaa.gif; "increases partition density and updates the left-endpoint area estimate" | GIF title "Left Riemann Sum"; estimate updates each frame | confirmed |
| C2a | Case 2 heading/Behavior | Right sum, height at the right endpoint | bb.jl:31–33 `h=f(xr)`; frames show top-right corners on the curve | confirmed |
| C2b | Case 2 Behavior | endpoint choice shifts the approximation at finite n | R_n−L_n=(f(2)−f(0))·2/n=0.03585/n, e.g. n=1: 2.035850 vs 2.0 | confirmed |
| C2c | Case 2 link/embed/alt | riemannbb.jl / riemannbb.gif, right-endpoint estimate | GIF title "Right Riemann Sum" | confirmed |
| C3a | Case 3 Behavior | each rectangle uses the minimum of f on its subinterval | cc.jl:41,61; brute force (200001 samples per subinterval) matches | confirmed |
| C3b | Case 3 Behavior | every frame's sum is a lower bound for I | lower ≤ I for all 24 n (indep.py, column `True`) | confirmed |
| C3c | Case 3 Behavior | $I \approx 2.016280$ | mpmath, t³ substitution: 2.016279719617; 50-panel quad: same | confirmed |
| C3d | Case 3 Behavior | lower sum falls from 1.374576 at n=3 to 1.192004 at n=4 | indep: 1.374576208 → 1.192004154; script prints the same | confirmed |
| C3e | Case 3 Behavior | approaches I but not monotonically; n=4 is not a refinement of n=3 | 3∤4; this is the only drop in the sequence | confirmed |
| C3f | Case 3 link/embed/alt | riemanncc.jl / riemanncc.gif; increases subintervals, uses min of f | GIF title "Lower Riemann Sum", "Subintervals = n" | confirmed |
| C4a | Case 4 Behavior | each rectangle uses the maximum of f on its subinterval | dd.jl:41,61; brute force matches | confirmed |
| C4b | Case 4 Behavior | every frame's sum is an upper bound | upper ≥ I for all 24 n | confirmed |
| C4c | Case 4 Behavior | at n=120, $1.978951 \le I \le 2.050951$ | indep: 1.978951024, 2.050951046; the last frames of cc/dd show the same | confirmed |
| C4d | Case 4 Behavior | upper sum rises from 2.418035 at n=7 to 2.427098 at n=8 | indep: 2.418034832 → 2.427098012 (the only rise) | confirmed |
| C4e | Case 4 Behavior | lower and upper sums squeeze I as n→∞ | gap: 3.125 at n=1, 0.0720 at n=120, shrinking along the sequence | confirmed |
| C4f | Case 4 link/embed/alt | riemanndd.jl / riemanndd.gif; uses max of f | GIF title "Upper Riemann Sum" | confirmed |
| F1 | Fidelity | Same four legacy cases (Left, Right, Lower, Upper), same f, same interval | legacy frames show `y = e^{-x} sin(8 x^{2/3}) + 1` on [0,2], 4 animations | confirmed |

### 3. Implementation checks

Regeneration: the manifest reports all four committed GIFs byte-identical to scratch reruns. Each has 25 frames: frame 1 is the bare curve (n=0), then frames 2–25 are n = 1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,72,88,104,120.

Commands (in `review/`):
- `julia inst_{aa,bb,cc,dd}.jl` runs a copy of each script truncated before the animation, which prints the script's own sums and critical points.
- `/usr/bin/python3 -I indep.py` computes, with mpmath at 30 digits, the exact integral (substitution x=t³), the critical points (root scan in u=x^{1/3}, 200001 points, bisection refinement), and L, R, lower and upper for every n.
- `/usr/bin/python3 -I brute.py` computes the lower and upper sums by brute force (numpy, 200001 samples per subinterval), with no use of critical points.

**Reference integral.** I = 2.016279719617096 by two independent mpmath quadratures. The page's 2.016280 is correct.

**Critical points.** The script gives 0.08038354937224365, 0.43198195723294985, 0.9392052471495191 and 1.5644755011307958. The independent scan gives 0.0803835493722, 0.431981957233, 0.93920524715 and 1.56447550113. They match, and no critical point is missed. The script's grid starts at 1e-4; there is no root near 0, since f' → +∞ there.

**Values (script, rounded as displayed | independent):**

| n | Left (aa) | indep L | Right (bb) | indep R | Lower (cc) | indep/brute | Upper (dd) | indep/brute |
|---|---|---|---|---|---|---|---|---|
| 1 | 2.0 | 2.000000 | 2.03585 | 2.035850 | 0.714407 | 0.714407 | 3.839512 | 3.839512 |
| 3 | 1.893096 | 1.893096 | 1.905046 | 1.905046 | 1.374576 | 1.374576 | 2.881460 | 2.881460 |
| 4 | 1.79759 | 1.797590 | 1.806553 | 1.806553 | 1.192004 | 1.192004 | 2.843078 | 2.843078 |
| 7 | 1.881422 | 1.881422 | 1.886543 | 1.886543 | 1.541768 | 1.541768 | 2.418035 | 2.418035 |
| 8 | 1.904354 | 1.904354 | 1.908836 | 1.908836 | 1.601561 | 1.601561 | 2.427098 | 2.427098 |
| 32 | 2.003771 | 2.003771 | 2.004891 | 2.004891 | 1.870891 | 1.870891 | 2.139327 | 2.139327 |
| 120 | 2.014795 | 2.014795 | 2.015094 | 2.015094 | 1.978951 | 1.978951 | 2.050951 | 2.050951 |

All 24 n values agree for all four scripts. The full lists are in the command output, and lower ≤ I ≤ upper holds at every n.

**Per script:**
- *riemannaa.jl (left).* The method is right: the height is f at the left endpoint, i in 0:n-1. The numbers match. Its reference is not applicable, since the script draws no reference value. The picture is right: rectangles sit on [xl, xl+dx] with height f(xl), and the frames show each left corner on the curve; the annotation reports `left_sum(n)` for the drawn n. The y-limits (0, 2.1) contain max f ≈ 1.917 and min f ≈ 0.36, so nothing is clamped.
- *riemannbb.jl (right).* The same holds with height f(xr), i in 1:n. The frames show the right corners on the curve.
- *riemanncc.jl (lower).* This is a true lower (Darboux) sum. The minimum is taken exactly over the endpoints and interior critical points, which is valid because f is C¹ on (0,2] and continuous at 0. The numbers match both the independent critical-point method and brute-force sampling. The picture draws heights fmin(xl,xr), and the frames show rectangle tops touching the curve's minimum on each subinterval.
- *riemanndd.jl (upper).* The same holds with the maximum. The n=1 frame has its rectangle at max f = 1.917 (at x = 0.0804), inside the 2.1 limit. The annotation sits on the pink fill but stays readable.

