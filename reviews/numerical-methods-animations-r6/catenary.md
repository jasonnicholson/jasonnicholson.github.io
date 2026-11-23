# Catenary — animation review (round 6)

Page: `pages/numerical-methods/catenary/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed by independent computation, by the instrumented script, or by the frames (ledger below). No implementation error, page mismatch or fidelity departure that matters to a reader was found.

Observations deliberately not raised as findings:
- The archive uses the shifted form y = c cosh(x/c) − c (lowest point at the origin) with approximating parabola y = x²/(2c) (archive gr_2, gr_25–29). The page uses y = c cosh(x/c) with y = x²/(2c) + c. This is a vertical shift by c of the same pair of curves, and the page's own statements are correct for its form; per the review standard this is a valid formulation differing from the textbook, not a finding.
- The archive's "Approximated by a parabola" exploration shows a static series computation; it does not sweep c. The c-sweep is the page's own device, and the page does not claim Mathews swept c.
- The frame title rounds c to two decimals with ties-to-even (0.9375 → "0.94", 3.125 → "3.12"). The page quotes no per-frame c values; harmless.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `catenaryaa.jl` | 0 | 7.0 | catenaryaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | "the catenary $y = c\cosh(x/c)$" | l.12 | script l.13 `y_cat = c .* cosh.(x ./ c)` | confirmed |
| 2 | "its parabolic approximation $y = x^2/(2c) + c$" | l.12 | script l.14 `y_par = x .^ 2 ./ (2c) .+ c` | confirmed |
| 3 | "c increases from 0.5 to 4" | l.12 | script l.9 `range(0.5, 4.0, length=25)`; frame 1 title c = 0.5, frame 25 title c = 4.0; values monotone increasing (instrumented run) | confirmed |
| 4 | c is "the ratio of horizontal tension to weight per unit length" | l.12 | standard statics: c = T₀/w for y = c cosh(x/c) | confirmed |
| 5 | "larger c means a tauter, flatter cable" | l.12 | curvature at apex = 1/c, decreasing in c; frames flatten as c grows | confirmed |
| 6 | "The catenary is the curve formed by a flexible cable hanging under gravity" | l.12 | standard definition; archive Background says the same | confirmed |
| 7 | "the parabola is the first two terms of its Maclaurin series" | l.12 | sympy: c cosh(x/c) = c + x²/(2c) + x⁴/(24c³) + x⁶/(720c⁵) + O(x⁸); first two terms = c + x²/(2c) | confirmed |
| 8 | "Julia source scripts ... are linked under each case" | l.14 | one case, `[Julia source](catenaryaa.jl)` at l.23 | confirmed |
| 9 | Case 1 follows Exploration 2 ("Approximated by a parabola"), which finds the Maclaurin series | l.16 | archive lnk_3: heading "Approximated by a parabola", "Exploration 2. Find the Maclaurin series for …" | confirmed |
| 10 | Exploration 1: catenaries with different c are scaled copies of one shape | l.17 | archive lnk_2: "the 'shape' of the curve is preserved … merely magnified by the scale factor" | confirmed |
| 11 | arc-length Exploration 3 | l.17 | archive lnk_4: heading "Arc Length", "Exploration 3." | confirmed |
| 12 | a catenary-fit section | l.17 | archive CatenaryMod.html l.73 "Catenary Fit" | confirmed |
| 13 | Examples 1–2 solve numerically for c of the catenary through the origin and two points at equal height on either side of the y-axis, compute arc length with Simpson's rule, compare with the parabola through the same three points | l.17 | archive lnk_5 / gr_91–95: pts {(−a,b),(0,0),(a,b)}, a=10, b=6, c by Newton/FindRoot, "length … approximated numerically by using Simpson's rule"; lnk_6 / gr_129–130: parabola p = d x² through (a,b), compared with catenary | confirmed |
| 14 | Those explorations/examples "are not animated here" | l.17 | only one script/GIF on the page | confirmed |
| 15 | Heading: "Catenary vs parabola approximation as c varies" | l.19 | script draws both curves per c value | confirmed |
| 16 | "For large c (nearly taut cable), the two curves are nearly indistinguishable near x=0" | l.21 | gap at c=4: 6.5e-4 at x=1, 0.172 at x=4 (check.py); frame 25 shows the curves overlapping except a slight split at the window edges | confirmed |
| 17 | "For small c (slack cable), the catenary climbs more steeply than the parabola and the two separate well inside the window" | l.21 | c=0.5: gap 0.381 at x=1, 728.7 at x=4; frame 1 shows separation from |x|≈0.7 | confirmed |
| 18 | "at c=0.5 the gap passes 0.1 at \|x\|≈0.73" | l.21 | mpmath root of cat−par−0.1: x = 0.727123 | confirmed |
| 19 | "the catenary leaves the top of the plot at \|x\|≈1.94" | l.21 | ylims (0,12) (script l.18); root of 0.5 cosh(2x) = 12: x = 1.935383 → 1.94; instrumented grid first exceeds 12 at x = 1.948; frame 1 shows the exit just inside ±2 | confirmed |
| 20 | "the parabola at \|x\|≈3.39" | l.21 | √(2·0.5·(12−0.5)) = 3.391165; grid first exceeds at 3.407; frame 1 | confirmed |
| 21 | "The catenary never lies below the parabola, since their difference x⁴/(24c³)+x⁶/(720c⁵)+⋯ is positive for every x≠0" | l.21 | sympy series coefficients 1/(24c³), 1/(720c⁵), general 1/((2n)! c^{2n−1}) all positive; instrumented min(y_cat−y_par) over the grid is positive in all 25 frames (1.4e-9 … 2.7e-12; the grid omits x=0) | confirmed |
| 22 | "The lowest point is always at (0, c)" | l.21 | y_cat(0)=c, cosh minimum at 0; marker `scatter!([0.0],[c])` l.28; frames 1 and 25 show the diamond at y=0.5 and y=4 | confirmed |
| 23 | "curves for parameter c are the c=1 curves y=cosh x and y=x²/2+1 scaled by the factor c about the origin" | l.21 | c·cosh(X/c) at X=c·u equals c·cosh u; c(u²/2+1) = X²/(2c)+c at X=c·u; scale.py residuals 0.0 for c=0.5,1.7,4 | confirmed |
| 24 | "the flattening as c grows comes from viewing ever larger copies through a fixed window" | l.21 | fixed xlims (−4,4), ylims (0,12) in every frame (script l.18) + #23 | confirmed |
| 25 | Link `catenaryaa.jl` is the script for this case | l.23 | file exists; it produces catenaryaa.gif | confirmed |
| 26 | Embed `catenaryaa.gif` is this case's animation | l.25 | committed GIF byte-identical (`cmp`) to the scratch regeneration of `catenaryaa.jl` | confirmed |
| 27 | Alt text: "Catenary y=c cosh(x/c) compared with its parabolic approximation y=x^2/(2c)+c as c sweeps from 0.5 to 4; the two curves nearly coincide near the apex for large c" | l.25 | #1–3, #16; frames | confirmed |
| 28 | Frame title / legend: "Catenary y = c·cosh(x/c), c = …", legend "y = c·cosh(x/c) (catenary)", "y = x²/(2c) + c (parabola)", "lowest point (0, c)" | GIF | match the plotted expressions at script l.13–14, l.20, l.25, l.27, l.29 | confirmed |

The page has no Description section stating formulas; the only method statements are in the Animations section and are in the ledger above.

### 3. Implementation checks — `catenaryaa.jl`

**It is the method it claims to be.** The page is a function-visualisation, not an iterative method. The script evaluates the exact catenary c cosh(x/c) and the two-term Maclaurin polynomial c + x²/(2c) on 500 points of [−4, 4] for 25 equally spaced c in [0.5, 4]. That is what the page and title say.

**The numbers are right.** Instrumented copy `review/inst.jl` (plotting commented out, prints per frame). Results set beside independent values (mpmath/sympy, `review/check.py`):

| Quantity | Script (grid) | Independent |
|---|---|---|
| c values | 0.5, 0.6458, …, 3.8542, 4.0 (25) | 0.5 + 3.5k/24, k=0..24 — identical |
| min y_cat (c=0.5) | 0.500064 at x=−0.008 | 0.5 at x=0 (grid has no x=0) |
| catenary exceeds 12, c=0.5 | first grid x = 1.948 | 1.935383 |
| parabola exceeds 12, c=0.5 | first grid x = 3.407 | 3.391165 |
| gap at x=4, c=0.5 | 728.73958 | 728.73958 |
| gap at x=4, c=4 | 0.172323 | 0.172323 |
| min(y_cat − y_par) | > 0 in every frame | difference series has all-positive coefficients |
| Maclaurin series | — | c + x²/(2c) + x⁴/(24c³) + x⁶/(720c⁵) + … |

**Reference values.** None beyond the exact catenary itself, which is evaluated in closed form.

**The picture shows what was computed.** Viewed frames 1 (c=0.5), 25 (c=4.0) and the contact sheet (c = 0.5, 0.94, 1.38, 1.81, 2.25, 2.69, 3.12, 3.56, 4.0). Each frame: solid blue catenary, dashed red parabola, black diamond at (0, c); titles carry the right c; legend text matches the expressions. ylims (0,12) clip both curves at small c (per the instrumented run, the catenary is clipped in frames up to c = 1.375 and the parabola in frames up to c = 0.6458); the clipped parts simply leave the top of the window, which the page describes explicitly, so the clamp does not mislead. The legend box sits at top centre and does not cover the curves' visible portions. Committed GIF is byte-identical to the scratch regeneration (manifest and `cmp`).

