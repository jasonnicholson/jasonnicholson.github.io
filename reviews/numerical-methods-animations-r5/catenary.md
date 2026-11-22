# Catenary — animation review (round 5)

Page: `pages/numerical-methods/catenary/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no error, misleading statement or fidelity departure that matters to a reader. Every numerical claim on the page agrees with an independent computation to the precision stated. Every behaviour claim agrees with the computed curves and the frames. The case wiring is correct.

Notes that are not findings:
- Mathews writes the catenary as $y=c\cosh(x/c)-c$, with its lowest point at the origin, and the parabola as $x^2/(2c)$ (archive gr_2, gr_26, gr_29). The page and script use the vertically shifted form $y=c\cosh(x/c)$ with apex $(0,c)$ and parabola $x^2/(2c)+c$. The difference between the two curves is the same in both forms, and the page states its own form consistently, so this is a valid alternative formulation, not a fidelity finding.
- Mathews' main module page puts the link "Exploration 1." directly above the heading "Approximated by a parabola", which could suggest that this is Exploration 1. The linked solution pages settle it: lnk_2 holds "Exploration 1" (the scaled copies), lnk_3, titled "Approximated by a parabola", holds "Exploration 2. Find the Maclaurin series", and lnk_4 (Arc Length) holds "Exploration 3". The page's numbering is therefore correct.
- The archive has no animation of $c$ sweeping. The GIF is a new construction that illustrates Exploration 2, as the page says.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `catenaryaa.jl` | 0 | 6.9 | catenaryaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | "the catenary $y = c\cosh(x/c)$" | Script line 13 `c .* cosh.(x ./ c)`; frame titles "Catenary y = c·cosh(x/c)" | confirmed |
| 2 | "its parabolic approximation $y = x^2/(2c) + c$" | Script line 14; legend in frames | confirmed |
| 3 | "$c$ ... increases from 0.5 to 4" | `range(0.5, 4.0, length=25)`; frame 1 title c = 0.5, frame 25 title c = 4.0 | confirmed |
| 4 | "$c$ (the ratio of horizontal tension to weight per unit length)" | A cable with horizontal tension $T_0$ and weight $w$ per unit length satisfies $y''=(w/T_0)\sqrt{1+y'^2}$. The sympy residual of $y''-(1/c)\sqrt{1+y'^2}$ for $y=c\cosh(x/c)$ is 0, so $c=T_0/w$ (`ode.py`) | confirmed |
| 5 | "larger $c$ means a tauter, flatter cable" | Follows from 4 (more tension per unit weight). Frames flatten as $c$ grows | confirmed |
| 6 | "The catenary is the curve formed by a flexible cable hanging under gravity" | Standard. Satisfies the ODE in 4 | confirmed |
| 7 | "the parabola is the first two terms of its Maclaurin series" | sympy: $c\cosh(x/c)=c+x^2/(2c)+x^4/(24c^3)+x^6/(720c^5)+O(x^8)$ (`check.py`) | confirmed |
| 8 | "Case 1 follows Exploration 2 ('Approximated by a parabola') of Mathews' Catenary module, which finds the Maclaurin series" | Archive lnk_3: title "Approximated by a parabola", "Exploration 2. Find the Maclaurin series" | confirmed |
| 9 | "Exploration 1 (catenaries with different $c$ are scaled copies of one shape)" | Archive lnk_2: "the curve is merely magnified by the scale factor" | confirmed |
| 10 | "its arc-length Exploration 3, its catenary-fit section" | Archive lnk_4 "Arc Length ... Exploration 3". "Catenary Fit" is a section of the main page | confirmed |
| 11 | "Examples 1–2 (... $c$ of the catenary through the origin and two points at equal height on either side of the $y$-axis, ... arc length with Simpson's rule, ... parabola through the same three points)" | Archive lnk_5: a=10, b=6, plot gr_92 shows points (±10, 6) and the origin, length by Simpson's rule. lnk_6: parabola through the origin and the point, compared | confirmed |
| 12 | "... are not animated here" | The page has one script and one GIF, the c-sweep | confirmed |
| 13 | Heading: "Catenary vs parabola approximation as $c$ varies" | Script and frames | confirmed |
| 14 | "For large $c$ ... the two curves are nearly indistinguishable near $x=0$" | c = 4: gap at \|x\| = 1 is 6.5e-4, largest gap in window 0.172 (at \|x\| = 4). Frame 25 shows the curves overlapping except a slight split at the edges | confirmed |
| 15 | "For small $c$ ... the catenary climbs more steeply than the parabola" | Slopes are $\sinh(x/c)$ and $x/c$, and $\sinh u>u$ for $u>0$. Frame 1 | confirmed |
| 16 | "the two separate well inside the window" (small $c$) | c = 0.5: the gap reaches 7.75 at the point where the catenary leaves the window (\|x\| = 1.935) | confirmed |
| 17 | "at $c=0.5$ the gap passes 0.1 at $\|x\|\approx0.73$" | findroot gives 0.727123 | confirmed |
| 18 | "the catenary leaves the top of the plot at $\|x\|\approx1.94$" | $0.5\,\mathrm{acosh}(24)=1.935383$; ylims = (0, 12) in script; frame 1 | confirmed |
| 19 | "the parabola at $\|x\|\approx3.39$" | $\sqrt{11.5}=3.391165$; frame 1 | confirmed |
| 20 | "The catenary never lies below the parabola, since their difference $x^4/(24c^3)+x^6/(720c^5)+\cdots$ is positive for every $x\neq0$" | Series in 7. All remaining terms are even powers with positive coefficients. Instrumented script: min(y_cat − y_par) ≥ 0 in every frame (≈1e-9 to 1e-12 at the grid point nearest 0) | confirmed |
| 21 | "The lowest point is always at $(0, c)$" | $\cosh$ has its minimum at 0. The diamond is drawn at `[0.0],[c]`. Instrumented min of y_cat = c + O(1e-5) at the grid point x = −0.008 | confirmed |
| 22 | "Every frame shows the same pair of shapes: the curves for parameter $c$ are the $c=1$ curves $y=\cosh x$ and $y=x^2/2+1$ scaled by the factor $c$ about the origin" | $(x,y)\mapsto(cx,cy)$ sends $y=\cosh x$ to $y=c\cosh(x/c)$. sympy: $c((x/c)^2/2+1)-(x^2/(2c)+c)=0$ (`ode.py`) | confirmed |
| 23 | "the flattening as $c$ grows comes from viewing ever larger copies through a fixed window" | Fixed xlims (−4, 4) and ylims (0, 12) in the script, follows from 22 | confirmed |
| 24 | "[Julia source](catenaryaa.jl)" | The file exists and is the script that produces catenaryaa.gif | confirmed |
| 25 | Embed `catenaryaa.gif` | Byte-identical to a fresh regeneration of catenaryaa.jl (manifest) | confirmed |
| 26 | Alt text: "... as c sweeps from 0.5 to 4; the two curves nearly coincide near the apex for large c" | Same as 3 and 14 | confirmed |
| 27 | Legend and title in frames: "y = c·cosh(x/c) (catenary)", "y = x²/(2c) + c (parabola)", "lowest point (0, c)", "c = <value>" | Match code lines 20, 25, 27, 29. The title value is `round(c, 2)` of the actual c (for example 2.104 is shown as 2.1, and 3.854 as 3.85) | confirmed |

### 3. Implementation checks: `catenaryaa.jl`

**It is the method it claims to be.** The script plots the claimed objects: the catenary $c\cosh(x/c)$ and its two-term Maclaurin truncation $c+x^2/(2c)$. There is no numerical algorithm beyond evaluating these on a 500-point grid over [−4, 4] for 25 values of $c$ evenly spaced from 0.5 to 4.

**The numbers are right.** The instrumented copy printed these values, set beside the independent Python values:

| c | script y_cat(±4) | script y_par(±4) | script gap | Python gap at \|x\| = 4 |
|---|---|---|---|---|
| 0.5 | 745.2396 | 16.5 | 728.7 | (off-window, y > 12) |
| 2.1042 | 7.198289 | 5.906147 | 1.292142 | 1.292142 |
| 3.8542 | 6.122972 | 5.929842 | 0.193130 | 0.193130 |
| 4.0 | 6.172323 | 6.0 | 0.172323 | 0.172323 |

The page's three quoted numbers (0.73, 1.94, 3.39) agree with mpmath values of 0.727123, 1.935383 and 3.391165.

**Its reference values are right.** There is no separate reference: the catenary is the exact function. sympy confirms that it satisfies the catenary ODE and that the parabola is its Maclaurin series through $x^2$.

**The picture shows what was computed.** I viewed the contact sheet and frames 1 and 25.
- Frame 1 (c = 0.5): the catenary leaves y = 12 at about x = ±1.94, the dashed parabola at about ±3.39, and the diamond is at (0, 0.5).
- Frame 25 (c = 4.0): the curves overlap except at the window edges (6.17 vs 6.0), and the diamond is at (0, 4).
- Middle frames: the apex rises with $c$ and the gap shrinks monotonically. The maximum in-window gap goes 7.75 → 0.17 across the 25 frames (`check.py`).

Clipping at y = 12 for small $c$ only hides parts of the curves above the window, and the page describes exactly that ("leaves the top of the plot"). It is not misleading. The legend at `:top` does not cover the apex or the curves near the region the page discusses.

