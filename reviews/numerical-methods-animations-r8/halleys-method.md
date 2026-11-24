# Halley's Method — animation review (round 8)

Page: `pages/numerical-methods/halleys-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Zero Error, zero Misleading, zero Minor.

Things looked at and judged not to be findings:
- `halleysba.jl:65` clamps the tangent to the y-limits, which draws short flat dotted stubs along the top and bottom plot borders (e.g. frame 1, bottom-left, x in [-3, -2.45]). They sit on the frame edge, carry no label or value, and do not change what a viewer concludes.
- Final frames in which nothing visible changes (1a frames 5-7, 1b frames 4-5, Case 2 frames 4-6). The legend and annotation still report the correct values, and the page makes no claim that these frames add anything.
- Legend labels use a generic "xₙ₊₁" rather than the frame's index. The annotation in the same frame gives the current index, so this is not ambiguous.
- Mathews' Example 2(a) (Newton on the Case 2 function) is not animated. The page states this explicitly (line 49), so it is not a silent drop.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `halleysaa.jl` | 0 | 5.9 | halleysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysab.jl` | 0 | 7.1 | halleysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysba.jl` | 0 | 7.1 | halleysba.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | l.12 | Halley = x-intercept of osculating hyperbola (a+b(x-xn))/(1+c(x-xn)) matching f, f', f'' at xn | sym.py: H-f, H'-f', H''-f'' at xn all 0 for both functions; root of H minus Halley step = 0 | confirmed |
| D2 | l.12 | Root of Taylor parabola gives a different iteration (Halley's irrational method) | standard naming; parabola root involves sqrt, differs from rational step | confirmed |
| D3 | l.12 | cubic convergence at simple roots | sym.py: g'(x*)=g''(x*)=0, g'''≠0 for both cases; e_{n+1}/e_n^3 → 0.123, 0.125 (case 1b), 0.332, 0.333 (case 2) | confirmed |
| D4 | l.18 | x_{n+1}=x_n-2ff'/(2f'^2-ff'') | identical to the code (ab l.32, ba l.33) | confirmed |
| D5 | l.22 | Newton-correction form | algebraically equal to D4 | confirmed |
| D6 | l.24 | correction factor →1 near a simple root | f→0, f'≠0 | confirmed |
| D7 | l.34 | C = abs(f'''/(6f') - f''^2/(4f'^2)) | formula gives 1/8 (x²-2) and 1/3 (cubic at -2); sym.py g'''(x*)/6 = 1/8 and 1/3 | confirmed |
| D8 | l.36 | multiple root → linear | sym.py: Halley g'(1) = 1/3 at the double root of (x-1)^2(x+2) (= (m-1)/(m+1)) | confirmed |
| D9 | l.40 | f, f', f'' = three evals vs two; log2/log3≈0.63; 3^(1/3)≈1.442; 2^(1/2)≈1.414 | arithmetic: 0.6309, 1.4422, 1.4142 | confirmed |
| D10 | l.40 | √2 from x0=2 to 20,000 digits: Halley 10 iterations vs Newton 15 | timing.jl (BigFloat, 66,503 bits): newton iters=15, halley1 iters=10, halley2 iters=10 | confirmed |
| D11 | l.40 | first form about as long or slightly longer than Newton; second form about twice Newton | timing.jl warm runs: Newton 6.0-6.7 ms, form 1 5.6-6.3 ms, form 2 13.2-15.7 ms | confirmed (it depends on the implementation; it holds in Julia BigFloat) |
| A1 | l.44 | Case 1a: tangent drawn blue dashed | aa l.52 steelblue :dash; frames | confirmed |
| A2 | l.44 | Cases 1b/2: x_n marked on curve, tangent blue dotted, hyperbola orange dashed crossing axis at Halley iterate | ab l.59-74, ba l.60-75; frames; sym.py root check | confirmed |
| A3 | l.48 | Cases follow Mathews Examples 1(a), 1(b), 2(b) | archive: Ex1 f=x²-2, p0=2 (Newton/Halley); Ex2 f=x³-3x+2, p0=-2.2 | confirmed |
| A4 | l.49 | Ex 2(a) is Newton on the Case 2 function from the same start; not animated; the blue diamond is only the Newton step from the current Halley iterate | archive lnk_4 p[0]=N[-11/5]; ba l.79 computes x_cur - fv/fpv | confirmed |
| 1a-1 | heading | f=x²-2, x0=2, Newton | aa l.10-13, 28 | confirmed |
| 1a-2 | l.53 | converges quadratically to √2≈1.41421 | digits 1.07, 2.61, 5.67, 11.8, 24.0 | confirmed |
| 1a-3 | l.53 | x1=1.5, x2≈1.4167, x3≈1.4142 | script: 1.5, 1.41666667, 1.41421569 | confirmed |
| 1a-4 | link/embed/alt | halleysaa.jl / halleysaa.gif, one tangent step per frame | manifest byte-identical regen; 7 frames, one per iterate | confirmed |
| 1b-1 | heading | Halley, f=x²-2, x0=2 | ab l.10-14, 32 | confirmed |
| 1b-2 | l.61 | orange diamond = Halley iterate, blue diamond = Newton | ab l.82-87; frame 1 | confirmed |
| 1b-3 | l.61 | x1≈1.42857 vs Newton x1=1.5 | 1.4285714286 / 1.5 (script and mpmath) | confirmed |
| 1b-4 | l.61 | about 1.8, 6.4, 20 accurate digits after steps 1-3 (extended precision) | mpmath: 1.843, 6.438, 20.22 | confirmed |
| 1b-5 | l.61 | g'''/3! governs the error rather than g''/2! | g''(√2)=0, g'''/6=1/8 | confirmed |
| 1b-6 | link/embed/alt | halleysab.jl / .gif; hyperbola + tangent, both next iterates on the axis | code and frames | confirmed |
| 2-1 | heading | Halley, f=x³-3x+2, x0=-2.2 | ba l.11-15 | confirmed |
| 2-2 | l.69 | =(x+2)(x-1)^2, simple root -2, double root 1 | expansion: x³-3x+2 | confirmed |
| 2-3 | l.69 | Halley x1≈-2.002, Newton x1≈-2.022 | -2.0020618557 / -2.0222222222 | confirmed |
| 2-4 | l.69 | Newton errors 2.2e-2, 3.2e-4, 6.9e-8, 3.2e-15 | mpmath 2.2222e-2, 3.2206e-4, 6.9127e-8, 3.1857e-15 | confirmed |
| 2-5 | l.69 | Halley errors 2.1e-3, 2.9e-9, 8.2e-27 | mpmath 2.0619e-3, 2.9138e-9, 8.2463e-27 | confirmed |
| 2-6 | l.69 | in double precision Newton first reaches -2 exactly at x5, Halley at x3 | float64: Newton x4=-2.000000000000003, x5=-2.0; Halley x2=-2.0000000029138016, x3=-2.0; Julia instrumented run identical | confirmed |
| 2-7 | l.69 | neither first step overshoots; both are left of the root; Halley's is within 0.0021 | -2.0222 and -2.00206 are both < -2; 0.00206 < 0.0021 | confirmed |
| 2-8 | l.69 | first-step markers about 0.02 apart, overlap; the legend gives the values | 0.0202 apart (~2 px at 5.5 units / ~630 px); in frame 1 the blue diamond is hidden under the orange one; the legend shows -2.02222 and -2.002062 | confirmed |
| 2-9 | link/embed/alt | halleysba.jl / .gif, converging to the simple root -2 | code, frames | confirmed |

### 3. Implementation checks

### halleysaa.jl (Newton baseline)
- *Method:* plain Newton x - f/f' (l.28). It is labelled Newton-Raphson, as the page says.
- *Numbers:* instrumented copy `inst_halleysaa.jl` prints [2.0, 1.5, 1.4166666666666667, 1.4142156862745099, 1.4142135623746899, 1.4142135623730951, 1.414213562373095]. Independent float64 run (`indep.py`) gives the same values bit for bit. mpmath errors are 8.58e-2, 2.45e-3, 2.12e-6, 1.59e-12, 8.99e-25.
- *Reference:* √2 is drawn as the root of f. No separate reference value.
- *Picture:* the tangent at x_frame has slope 2x and its zero is the legend's x_{n+1}. The red dot is at (x_n, f(x_n)). Labels and indices match (frame k shows "tangent at x_k" and "x_{k+1} ≈ ..."). The regenerated GIF is byte-identical to the committed one.

### halleysab.jl (Halley, x²-2)
- *Method:* the rational Halley step (l.32), not the irrational (parabola) variant. The page names the same variant.
- *Numbers:* script [2.0, 1.4285714285714286, 1.4142139267767408, 1.414213562373095, 1.4142135623730951], identical to the independent float64 run. The Newton comparison points 1.5, 1.4142857, ... are the Newton steps from each Halley iterate (instrumented output).
- *Hyperbola:* b1 = -f''/(2f'), a1 = f' + f·b1. sym.py shows it osculates f to second order and its zero is exactly the Halley step. The pole sits at 3x_n > 2.6, which is off-screen, so the NaN mask removes nothing that is visible.
- *Picture:* frames 1-5 checked. The orange diamond sits at the hyperbola's x-intercept and the blue diamond at the tangent's. Legend values are correct to the digits shown. The regenerated GIF is byte-identical.

### halleysba.jl (Halley, x³-3x+2)
- *Method:* the rational Halley step (l.33).
- *Numbers:* script [-2.2, -2.002061855670103, -2.0000000029138016, -2.0, -2.0, -2.0], identical to the independent float64 run. Error ratios e_{n+1}/e_n^3 = 0.332 and 0.333, which match C = 1/3 from the page formula and from g'''/6.
- *Reference:* the root -2 is exact (f(-2)=0, f'(-2)=9≠0).
- *Picture:* frames 1-6 checked. In frame 1 the pole of the hyperbola is at -3.945, off-screen. The hyperbola passes through (x0, f(x0)) and crosses the axis at -2.002. Tangent clamping only adds stubs along the border (see section 1). The annotation uses %.10f and the values are correct. The regenerated GIF is byte-identical.

### Legacy archive
Example 1: f(x)=x²-2, root √2, p0=2, (a) Newton and (b) Halley. Example 2: f(x)=x³-3x+2, root -2, p0=-2.2 (N[-11/5,100]), (a) Newton and (b) Halley. The page's cases 1a, 1b and 2 reproduce 1(a), 1(b) and 2(b). The dropping of 2(a) is disclosed. No fidelity findings.

