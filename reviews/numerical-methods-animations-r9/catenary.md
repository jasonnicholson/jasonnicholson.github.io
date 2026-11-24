# Catenary — animation review (round 9)

Page: `pages/numerical-methods/catenary/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Counts: Error 0, Misleading 0, Minor 0.

Every checkable claim on the page agrees with an independent computation and with the frames; the script implements
exactly the curves it names; the committed GIF is byte-identical to a fresh scratch regeneration (manifest).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `catenaryaa.jl` | 0 | 13.0 | catenaryaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | "the catenary $y = c\cosh(x/c) - c$" | script l.13 `c .* cosh.(x ./ c) .- c` | confirmed |
| 2 | "Mathews' form with its lowest point at the origin" | archive gr_2: `y = f(x) = c cosh(x/c) - c where c > 0`; gr_1: lowest point `(0, 0)` | confirmed |
| 3 | parabolic approximation $y = x^2/(2c)$ | script l.14 `x .^ 2 ./ (2c)` | confirmed |
| 4 | "$c$ increases from 0.5 to 4" | `range(0.5, 4.0, length=25)`; frame 1 title c = 0.5, frame 25 title c = 4.0 | confirmed |
| 5 | $c$ = "ratio of horizontal tension to weight per unit length; larger $c$ means a tauter, flatter cable" | standard statics: $c = T_0/w$; curvature at apex $1/c$ | confirmed |
| 6 | "the parabola is the first nonzero term of its Maclaurin series" | sympy: series = x²/(2c) + x⁴/(24c³) + x⁶/(720c⁵) + x⁸/(40320c⁷) + …; archive gr_26 `x²/(2c)`, gr_28 | confirmed |
| 7 | "Case 1 follows Exploration 2 ("Approximated by a parabola") ... which finds the Maclaurin series" | archive lnk_3 (the "Approximated by a parabola" section) is headed "Exploration 2. Find the Maclaurin series for …". (On the module page the "Exploration N." link sits at the end of the section it belongs to, so the main page's text order is misleading; the link pages settle it.) | confirmed |
| 8 | "Exploration 1 (catenaries with different $c$ are scaled copies of one shape)" | lnk_2: "the 'shape' of the curve is preserved … merely magnified by the scale factor" | confirmed |
| 9 | "its arc-length Exploration 3, its catenary-fit section" | lnk_4 "Arc Length … Exploration 3"; module page "Catenary Fit" section | confirmed |
| 10 | Examples 1–2 solve for $c$ through origin and two symmetric points, arc length by Simpson's rule, compare with the parabola through the same points | lnk_5 (a = 10, b = 6; "approximated numerically by using Simpson's rule"); lnk_6 (parabola through origin and the point; compare) | confirmed |
| 11 | "For large $c$ ... the two curves are nearly indistinguishable near $x=0$" | c = 4: gap at x = 4 is 0.1723 (cat 2.1723, par 2.0000); gap < 0.1 for |x| < 3.50 | confirmed |
| 12 | "For small $c$ ... the catenary climbs more steeply than the parabola and the two separate well inside the window" | c = 0.5: y_cat(4) = 744.7 vs y_par(4) = 16 | confirmed |
| 13 | "at $c=0.5$ the gap passes 0.1 at $|x|\approx0.73$" | mpmath root of cat−par−0.1: 0.727123…; script grid: first sample 0.7295 | confirmed |
| 14 | "the catenary leaves the top of the plot at $|x|\approx1.94$" | top = 11.5 (script ylims); root of cat = 11.5: 1.935383…; grid 1.948; frame 1 shows exit near ±1.9 | confirmed |
| 15 | "the parabola at $|x|\approx3.39$" | √(2·0.5·11.5) = 3.391165; frame 1 shows exit near ±3.4 | confirmed |
| 16 | "The catenary never lies below the parabola ... difference $x^4/(24c^3)+x^6/(720c^5)+\cdots$ is positive for every $x\neq0$" | series coefficients all positive (sympy, archive gr_28); script min(d) > 0 in every frame (≥ 2.7e-12, grid excludes x=0) | confirmed |
| 17 | "The lowest point is always at $(0, 0)$" | f(0)=0, f even and convex; black diamond at (0,0) in all frames | confirmed |
| 18 | "the curves for parameter $c$ are the $c=1$ curves $y=\cosh x-1$ and $y=x^2/2$ scaled by the factor $c$ about the origin" | c·g(x/c) with g(u)=cosh u−1 gives c cosh(x/c)−c; c·(x/c)²/2 = x²/(2c) | confirmed |
| 19 | "the flattening as $c$ grows comes from viewing ever larger copies through a fixed window" | fixed xlims (−4,4), ylims (−0.5,11.5) in every frame (script l.18) | confirmed |
| 20 | Alt text: "as c sweeps from 0.5 to 4; the two curves nearly coincide near the apex for large c" | as 4, 11 | confirmed |
| 21 | Wiring: "[Julia source](catenaryaa.jl)", embed `catenaryaa.gif` | the only script / GIF; script writes catenaryaa.gif; regen byte-identical | confirmed |
| 22 | "Julia source scripts ... are linked under each case" | link present under Case 1 | confirmed |
| 23 | Frame elements: title "Catenary y = c·cosh(x/c) - c, c = …", legend (blue solid catenary, red dashed parabola, black diamond lowest point) | frames 1, 4, 13, 25 and contact sheet; title c = round(c,2) of the plotted c | confirmed |

### 3. Implementation checks — `catenaryaa.jl`

- **Method it claims to be:** not a numerical method; it plots the closed-form catenary and the first Maclaurin term.
  Formulas in code (l.13–14) are exactly those in the title, legend, page and Mathews' module.
- **Numbers right:** instrumented copy (`review/instr.jl`) reproduces the script's arrays. Side by side with the
  independent mpmath computation (`review/chk.py`), y_cat(4) per frame agrees to ~1e-14 (e.g. c=0.5: 744.739580626089
  both; c=4: 2.1723225392609753 vs 2.172322539260975). 25 frames, Δc = 0.1458333.
  Grid-based crossings (0.7295, 1.948, 3.407) bracket the exact values (0.72712, 1.93538, 3.39117) within one grid step (0.016).
- **Reference values:** none beyond the closed forms; series verified with sympy.
- **Picture shows what was computed:** frames 1, 4, 13 (contact sheet), 25 inspected. Curves exit the top where
  computed; clipping at y = 11.5 is only a window, the page itself states the exit points; legend does not cover
  any curve (at c = 0.5 it sits between the catenary branches, which leave the window at |x| ≈ 1.94). Titles carry
  the correct c.

### Archive (fidelity)

Consulted. Mathews' form, apex location, parabola term and exploration numbering all match the page. Mathews has no
animation or c-sweep for Exploration 2 (its images gr_30–46 are absent from the archive); the 0.5–4 sweep is the
page's own choice and is stated as such. Omitted archive items are listed explicitly on the page. No fidelity finding.

