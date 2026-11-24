# Halley's Method — animation review (round 9)

Page: `pages/numerical-methods/halleys-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Severity counts: Error 0, Misleading 0, Minor 0.

Observed but not raised as a finding (display device that does not change any conclusion):
- `halleysba.jl:65` clamps the tangent to `ylims`, so in frame 1 the steep tangent (slope 11.52) is drawn as short horizontal dotted pieces lying on the plot border (y = -5 for x in [-3, -2.45], y = 8 for x in [-1.33, 2.5]). They sit on the frame box, are barely visible, and no element the page discusses depends on them.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `halleysaa.jl` | 0 | 7.0 | halleysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysab.jl` | 0 | 7.9 | halleysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysba.jl` | 0 | 7.3 | halleysba.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `halleysaa.gif` | 7 | byte-identical | halleysaa |
| `halleysab.gif` | 5 | byte-identical | halleysab |
| `halleysba.gif` | 6 | byte-identical | halleysba |

### Page references

- Scripts linked: `halleysaa.jl`, `halleysab.jl`, `halleysba.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Osculating hyperbola y=(a+b(x-x_n))/(1+c(x-x_n)) matches f, f', f'' at x_n; its x-intercept is x_{n+1} | sympy (`hyp.py`): with b1=-f''/(2f'), a1=f'+f b1, H(0..2)=[f,f',f'']; root minus Halley step = 0 | confirmed |
| D2 | Root of Taylor parabola gives a different iteration (Halley's irrational method) | standard; not the script's method | confirmed |
| D3 | Cubic convergence at simple roots; digits roughly triple vs double for Newton | `indep.py` digits: Halley 1.84, 6.44, 20.2, 61.6; Newton 1.07, 2.61, 5.67, 11.8, 24.1 | confirmed |
| D4 | Formula x_{n+1}=x_n - 2ff'/(2f'^2 - ff'') | matches scripts line 32/33; sympy | confirmed |
| D5 | Second form (Newton step times 1/(1-ff''/(2f'^2))) equals first | sympy difference = 0 | confirmed |
| D6 | Factor near 1 near a simple root | f -> 0 while f' != 0 | confirmed |
| D7 | |e_{n+1}| ~ C|e_n|^3, C=|f'''/(6f') - f''^2/(4f'^2)| | formula gives 0.125 (x^2-2), 1/3 (cubic); measured e3/e2^3: 6.0486e-21/(3.644e-7)^3 = 0.125; 8.2463e-27/(2.9138e-9)^3 = 0.3333; also g'''(sqrt2)/6 = 1/8 (sympy) | confirmed |
| D8 | Multiple root: cubic rate lost, linear convergence | Halley on cubic near x=1 from 1.5: error ratios 0.340, 0.336, ... 0.33334 -> 1/3 = (m-1)/(m+1) | confirmed |
| D9 | Three evaluations per Halley step vs two for Newton | f, f', f'' vs f, f' | confirmed |
| D10 | log2/log3 ~ 0.63; 3^(1/3) ~ 1.442; 2^(1/2) ~ 1.414 | 0.6309, 1.4422, 1.4142 | confirmed |
| D11 | sqrt2 from x0=2 to 20,000 digits: Halley 10 iterations, Newton 15 | `digits20k.py` (mpmath 20100 dps, stop at error < 1e-20000): Newton 15, Halley 10 | confirmed |
| D12 | Halley (first form) takes about as long or slightly longer than Newton; second form about twice as long; second form does two more divisions | mpmath timings: Newton 0.048 s, form 1 0.061 s (1.27x), form 2 0.107 s (2.2x); division count 1 vs 3 | confirmed in mpmath; absolute timings are tool-dependent and the page names no tool, so the original measurement could not be reproduced as such |
| A1 | Case 1a: Newton tangent construction alone, tangent blue dashed | `halleysaa.jl:52` steelblue `:dash`; frames | confirmed |
| A2 | Cases 1b, 2: current iterate marked on curve, tangent blue dotted, hyperbola orange dashed crosses axis at Halley iterate | code lines 59-74 (ab), 60-75 (ba); frame 1 of each: orange diamond sits at hyperbola crossing (1.428571; -2.002062) | confirmed |
| A3 | Cases follow Mathews Examples 1(a), 1(b), 2(b); 2(a) (Newton for case 2 function) not animated; Case 2 blue diamond is only the Newton step from the current Halley iterate | archive: Ex 1 f=x^2-2, p0=2; Ex 2 f=x^3-3x+2, p0=-2.2, root -2; `halleysba.jl:79` x_newton from x_cur | confirmed |
| A4 | Case 1a heading f=x^2-2, x0=2 | `halleysaa.jl:10,13`; title | confirmed |
| A5 | Case 1a converges quadratically to sqrt2 ~ 1.41421; x1=1.5, x2~1.4167, x3~1.4142 | Float64: 1.5, 1.4166666666666667, 1.4142156862745099 | confirmed |
| A6 | Case 1a alt: each frame advances one tangent step | 7 frames, x0..x6, one tangent per frame | confirmed |
| A7 | Case 1b heading f=x^2-2, x0=2 | `halleysab.jl:10,14` | confirmed |
| A8 | Orange diamond = Halley iterate, blue diamond = Newton landing | code colours; frames | confirmed |
| A9 | Halley x1 ~ 1.42857 vs Newton x1 = 1.5 | 1.4285714285714286 (=10/7); 1.5 | confirmed |
| A10 | Digits about 1.8, 6.4, 20 after steps 1-3 (extended precision) | 1.843, 6.438, 20.22 | confirmed |
| A11 | |g'''(x*)|/3! governs rather than |g''(x*)|/2! | sympy: g'(sqrt2)=g''(sqrt2)=0, g'''/6=1/8 | confirmed |
| A12 | Case 1b alt: hyperbola's x-intercept is Halley iterate; both next iterates marked | frames 1-4 have both markers; final frame has none (no next step), acceptable | confirmed |
| A13 | Case 2 heading f=x^3-3x+2, x0=-2.2 | `halleysba.jl:11,15` | confirmed |
| A14 | f=(x+2)(x-1)^2; simple root -2, double root 1 | expand: x^3-3x+2 | confirmed |
| A15 | Halley x1 ~ -2.002; Newton x1 ~ -2.022 | -2.002061855670103; -2.022222222222222 | confirmed |
| A16 | Newton errors 2.2e-2, 3.2e-4, 6.9e-8, 3.2e-15 (steps 1-4) | 2.2222e-2, 3.2206e-4, 6.9127e-8, 3.1857e-15 | confirmed |
| A17 | Halley errors 2.1e-3, 2.9e-9, 8.2e-27 (steps 1-3) | 2.0619e-3, 2.9138e-9, 8.2463e-27 | confirmed |
| A18 | Double precision: Newton first reaches -2 exactly at x5, Halley at x3 | `fp64.jl`: Newton x4=-2.000000000000003, x5=-2.0; Halley x2=-2.0000000029138016, x3=-2.0 | confirmed |
| A19 | Neither first step overshoots; both left of root; Halley within 0.0021 | -2.0222, -2.0021 both < -2; |e1|=0.00206 | confirmed |
| A20 | First-step markers ~0.02 apart, overlap at this scale; legend gives values | separation 0.02016; frame 1: blue diamond hidden under orange, legend shows -2.02222 and -2.002062 | confirmed |
| A21 | Case 2 alt: converges to simple root -2 | frames 2-6 at -2 | confirmed |
| W1 | Links/embeds: halleysaa -> Case 1a, halleysab -> 1b, halleysba -> 2 | scripts' parameters and output names match headings | confirmed |

### 3. Implementation checks

### halleysaa.jl (Case 1a, Newton baseline)
- Method: plain Newton x - f/f' (line 28). The page presents it as the Newton baseline, consistent.
- Numbers: script Float64 iterates 2, 1.5, 1.4166666666666667, 1.4142156862745099, 1.4142135623746899, 1.4142135623730951, 1.414213562373095; mpmath (200 dps): 1.5, 1.41666666666666666667, 1.41421568627450980392, 1.41421356237468991063, sqrt2 to 1e-25. Agree to Float64.
- Reference: sqrt2 is exact root of x^2-2.
- Picture: tangent at x_n with slope 2x_n, x-intercept marker matches next iterate (frame 1: tangent crosses axis at 1.5, legend "x1 ~ 1.5"); annotations x_n match iterates at 8 decimals (e.g. x3 = 1.41421569). 7 frames = x0..x6.

### halleysab.jl (Case 1b, Halley on x^2-2)
- Method: Halley rational form (line 32), the page's first formula. Hyperbola coefficients (lines 55-56) verified symbolically to match f, f', f'' and to have the Halley iterate as root.
- Numbers: Float64 1.4285714285714286, 1.4142139267767408, 1.414213562373095, 1.4142135623730951; mpmath 1.42857142857142857143, 1.41421392677674084711, then sqrt2 to 6e-21. Agree.
- Reference: sqrt2.
- Picture: pole of the hyperbola at x_n - 1/b1 = 6.0 (frame 1), 4.29 (frame 2), outside the window, so the NaN mask removes nothing visible. Frame 1: orange diamond at 1.428571 where hyperbola crosses, blue at 1.5 where tangent crosses. Frame 2 legend Newton 1.41429 = (x1^2+2)/(2x1) correct. 5 frames.

### halleysba.jl (Case 2, Halley on x^3-3x+2)
- Method: same Halley formula (line 33); derivatives 3x^2-3, 6x correct.
- Numbers: Float64 -2.002061855670103, -2.0000000029138016, -2.0, -2.0, -2.0; mpmath -2.00206185567010309, -2.00000000291380177, error 8.2e-27. Agree. Annotation "%.10f" values (-2.0020618557, -2.0000000029) match. Result from double-rounded -2.2 identical to 20 digits with exact -11/5.
- Reference: -2 is an exact root ((x+2)(x-1)^2).
- Picture: hyperbola pole at -3.945 (frame 1) and -3.5 (later), left of xlims -3, so the drawn branch is the whole visible curve through x_n. Tangent is clamped to ylims (line 65); see note under Findings, judged not misleading. The page's statement that the two first-step markers overlap is accurate in frame 1.

### Legacy archive
Example 1: f = x^2 - 2, p0 = 2, root sqrt2 (1(a) Newton, 1(b) Halley). Example 2: f = x^3 - 3x + 2, p0 = -2.2, root -2 (2(a) Newton g(x)=2(1+x+x^2)/(3(1+x)), 2(b) Halley). Archive p3 for 2(a) = -2.00000006912667774767..., matching the page's 6.9e-8. The page reproduces 1(a), 1(b), 2(b) with Mathews' functions and starting values and states that 2(a) is not animated, so no fidelity departure.

