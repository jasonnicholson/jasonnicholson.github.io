# Catenary — animation review (round 8)

Page: `pages/numerical-methods/catenary/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None. Every checkable claim on the page and every element of the GIF agreed with independent computation; the archive cross-check found no unexplained departure.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `catenaryaa.jl` | 0 | 7.4 | catenaryaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `catenaryaa.gif` | 25 | byte-identical | catenaryaa |

### Page references

- Scripts linked: `catenaryaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| 1 | catenary $y = c\cosh(x/c) - c$, "Mathews' form with its lowest point at the origin" | intro l.12 | Script l.13 `c .* cosh.(x ./ c) .- c`; Mathews gr_2: `y = f(x) = c cosh(x/c) - c where c > 0`; min y_cat over grid ~1e-5 at x≈0 (grid does not contain 0 exactly), f(0)=0 analytically | confirmed |
| 2 | parabolic approximation $y = x^2/(2c)$ | l.12 | Script l.14; sympy series of c cosh(x/c)-c = x²/(2c)+x⁴/(24c³)+x⁶/(720c⁵)+x⁸/(40320c⁷)+… | confirmed |
| 3 | c increases from 0.5 to 4 | l.12, alt text | `range(0.5, 4.0, length=25)`; frame titles c=0.5 … c=4.0 (frames 1 and 25 viewed) | confirmed |
| 4 | c is ratio of horizontal tension to weight per unit length; larger c = tauter, flatter cable | l.12 | Standard catenary statics (a = T₀/w); for a fixed span, sag decreases as c grows | confirmed |
| 5 | catenary is the curve of a flexible cable hanging under gravity | l.12 | standard; matches Mathews Background | confirmed |
| 6 | parabola is the first nonzero term of the Maclaurin series | l.12 | sympy series (claim 2); Mathews gr_28 general term x^{2n}/((2n)! c^{2n-1}) | confirmed |
| 7 | Case 1 follows Exploration 2 ("Approximated by a parabola"), which finds the Maclaurin series | l.16 | Archive lnk_3: heading "Approximated by a parabola", "Exploration 2. Find the Maclaurin series…" | confirmed |
| 8 | Exploration 1: catenaries with different c are scaled copies of one shape | l.17 | Archive lnk_2: "the curve is merely magnified by the scale factor…"; gr_3/gr_13 plot F[x,d/2], F[x,d], F[x,2d], F[x,3d] | confirmed |
| 9 | arc-length Exploration 3 | l.17 | Archive lnk_4 "Arc Length … Exploration 3." | confirmed |
| 10 | catenary-fit section (unnumbered) | l.17 | Archive CatenaryMod.html "Catenary Fit" section | confirmed |
| 11 | Examples 1–2 solve for c of catenary through origin and two points at equal height either side of y-axis, compute arc length with Simpson's rule, compare with parabola through same three points | l.17 | Archive lnk_5 (gr_91: pts {(-a,b),(0,0),(a,b)}, a=10, b=6; "length … approximated numerically by using Simpson's rule"); lnk_6 (parabola through origin and the point, compared) | confirmed |
| 12 | these are not animated here | l.17 | only one script/GIF exists | confirmed |
| 13 | large c: two curves nearly indistinguishable near x=0 | Behavior l.21 | c=4: gap 6.5e-4 at x=1, 0.0105 at x=2, 0.172 at x=4; frame 25 shows overlap except slight separation at edges | confirmed |
| 14 | small c: catenary climbs more steeply than parabola; the two separate well inside window | l.21 | d/dx: sinh(x/c) > x/c for x>0; frame 1 shows separation well inside [-4,4] | confirmed |
| 15 | at c=0.5 the gap passes 0.1 at \|x\|≈0.73 | l.21 | mpmath findroot: 0.727123 | confirmed |
| 16 | catenary leaves top of plot at \|x\|≈1.94 | l.21 | 0.5cosh(2x)-0.5=11.5 → x=acosh(24)/2=1.935383; ylim top 11.5 (script l.18); instrumented grid exit 1.948 (grid step 0.016) | confirmed |
| 17 | parabola leaves top at \|x\|≈3.39 | l.21 | x=√11.5=3.391165; grid exit 3.407 | confirmed |
| 18 | catenary never below parabola; difference $x^4/(24c^3)+x^6/(720c^5)+\cdots$ positive for x≠0 | l.21 | series (claim 2), all terms even-power positive; instrumented min(cat−par) ≥ 2.7e-12 > 0 for all 25 frames | confirmed |
| 19 | lowest point always at (0,0) | l.21 | f(0)=0, f even and convex; black diamond at (0,0) in every frame (script l.28) | confirmed |
| 20 | curves for c are the c=1 curves cosh x − 1 and x²/2 scaled by c about the origin | l.21 | c·f₁(x/c): c(cosh(x/c)−1) and c·(x/c)²/2 = x²/(2c); numeric allclose check in chk.py | confirmed |
| 21 | flattening as c grows comes from viewing ever larger copies through a fixed window | l.21 | follows from claim 20; xlims/ylims fixed (script l.18) | confirmed |
| 22 | Source link `catenaryaa.jl` | l.23 | file exists; it is the only script and produces catenaryaa.gif | confirmed |
| 23 | Embed `catenaryaa.gif` | l.25 | committed GIF byte-identical to scratch regeneration (manifest; md5 rechecked) | confirmed |
| 24 | Alt text: c sweeps 0.5→4; curves nearly coincide near apex for large c | l.25 | claims 3, 13 | confirmed |
| 25 | GIF title "Catenary y = c·cosh(x/c) - c, c = …" | frames | matches code; rounded c values on contact sheet (0.5, 0.94, 1.38, 1.81, 2.25, 2.69, 3.12, 3.56, 4.0) equal round(c_k,2) of linspace values (3.125→3.12 by round-half-even) | confirmed |
| 26 | Legend entries (catenary, parabola, lowest point (0,0)) | frames | match plotted series; legend box does not cover either curve in frame 1 (catenary at y≈10.5 is at x≈1.91, outside legend's x≈±1.5) | confirmed |

The page has no Description section stating formulas/algorithm beyond the intro; nothing further to ledger there.

### 3. Implementation checks — `catenaryaa.jl`

- **Is the method it claims.** It is not an iterative method; it plots the closed-form catenary c·cosh(x/c)−c and its leading Maclaurin term x²/(2c) for 25 values of c. Both formulas are exactly what the page names (script l.13–14 vs page l.12).
- **Numbers right.** Instrumented copy (`review/inst.jl`) reproduces the arrays: e.g. y_cat(4) at c=0.5 = 744.7396 (Python 744.7396), at c=4 = 2.172323 (Python 2.172323); parabola at x=4, c=4: 2.0 (16/8). Positivity of cat−par in every frame. Grid exits from the top of the window match analytic exits to within one grid step (0.016).
- **Reference values.** The "reference" is the Maclaurin leading term; verified symbolically with sympy (`x**2/(2*c) + x**4/(24*c**3) + x**6/(720*c**5) + …`) and against Mathews gr_28.
- **Picture shows what was computed.** Frames 1, 25 and the contact sheet (frames 1,4,…,25) viewed. Fixed window x∈[−4,4], y∈[−0.5,11.5]; curves above 11.5 are simply clipped at the frame edge (no clamping/labelling of off-plot values). For c ≥ 1.375 both curves stay inside the window at x=±4 (y_cat(4)=11.27 at c=1.375). Title c matches the frame's c. Committed GIF is byte-identical to a scratch regeneration (25 frames).

### Archive fidelity

Mathews' module has one form of the catenary (matches), Exploration 1 (scaling, matches page description), Exploration 2 (Maclaurin series; the animation's catenary-vs-parabola comparison illustrates it), Exploration 3 (arc length), a Catenary Fit section, and Examples 1–2 (a=10, b=6). The page states explicitly which of these are not animated, so nothing is silently dropped. Mathews does not animate a c sweep; the page's choice of c∈[0.5,4] is its own and is mathematically sound. No fidelity finding.

