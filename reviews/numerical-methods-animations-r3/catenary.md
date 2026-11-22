# Catenary — animation review (round 3)

Page: `pages/numerical-methods/catenary/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Fidelity, Minor: the exploration numbering quoted from Mathews is wrong
- **Location:** `index.qmd` line 24: "This animation is based on Exploration 1 ("Approximated by a parabola") of Mathews' Catenary module." Line 25: "The module's arc-length and catenary-fit explorations (Explorations 2–3) ...".
- **What is there now:** "Approximated by a parabola" is called Exploration 1. Arc length and catenary fit are called Explorations 2–3.
- **What is true instead:** On the main page, each "Exploration N." link comes *after* the section it belongs to. The linked pages settle it: `CatenaryMod_lnk_2.html` is headed "Background … Exploration 1." (four scaled catenaries, "Do the above four catenaries look similar? Are they the same?"). `CatenaryMod_lnk_3.html` is "Approximated by a parabola … Exploration 2. Find the Maclaurin series". `CatenaryMod_lnk_4.html` is "Arc Length … Exploration 3." The "Catenary Fit" section has no exploration link of its own. Its computation leads into Examples 1–2.
- **How I know:** `sed 's/<[^>]*>//g'` on `CatenaryMod.html` lines 20–140 and on each `Links/CatenaryMod_lnk_N.html` (the main-page anchors at lines 34/53/68 point to lnk_2/3/4 respectively).
- **Suggested correction:** "This animation is based on Exploration 2 ("Approximated by a parabola", the Maclaurin series of the catenary) of Mathews' Catenary module." Then: "The module's Exploration 1 (catenaries of different c are scaled copies of one shape), its arc-length Exploration 3, its catenary-fit section and its Examples 1–2 ... are not animated here."

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: Mathews' actual Exploration 1 (catenaries are similar curves) is silently dropped
- **Location:** `index.qmd` line 25, the list of what is "not animated here".
- **What is there now:** The list names arc length, catenary fit and Examples 1–2. It never mentions Mathews' first exploration.
- **What is true instead:** Mathews' Exploration 1 (`lnk_2`, image `gr_3`/`gr_13`) plots `F(x,c) = c cosh(x/c) − c` for d/2, d, 2d, 3d (d = 0.618759) on windows scaled by the same factor. It concludes that changing c only magnifies or shrinks one shape. That point bears on this animation: the sweep from c = 0.5 to 4 in a fixed window looks like the cable is changing shape, but each frame is a scaled copy of the same curve. The omission is not stated anywhere.
- **Suggested correction:** Add Exploration 1 to the not-animated list (see F1). Optionally add one sentence to the Behavior paragraph: every catenary is a scaled copy of `cosh`, so the apparent flattening comes from viewing them through a fixed window.

Not a finding: Mathews writes the catenary as `y = c cosh(x/c) − c` (lowest point at the origin; image `gr_2`) and the parabola as `x²/(2c)` (`gr_29`). The page shifts both up by c. That is an equivalent formulation and the difference of the two curves is unchanged.

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `catenaryaa.jl` | 0 | 7.6 | catenaryaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | "the catenary $y = c\cosh(x/c)$" | script line 13 `c .* cosh.(x ./ c)` | confirmed |
| 2 | "its parabolic approximation $y = x^2/(2c) + c$" | script line 14 | confirmed |
| 3 | "c ... increases from 0.5 to 4" | `range(0.5, 4.0, length=25)`. Frame 1 title c = 0.5, frame 25 title c = 4.0 | confirmed |
| 4 | "c (the ratio of horizontal tension to weight per unit length ...)" | standard statics, c = H/w | confirmed |
| 5 | "larger c means a tauter, flatter cable" | apex curvature 1/c decreases. Frames flatten from 1 to 25 | confirmed |
| 6 | "the curve formed by a flexible cable hanging under gravity" | definition | confirmed |
| 7 | "the parabola is the first two terms of its Maclaurin series" | sympy: c cosh(x/c) = c + x²/(2c) + x⁴/(24c³)+… | confirmed |
| 8 | "For large c ... the two curves are nearly indistinguishable near x=0" | gap at x=1 for c=4: 6.5e-4. Max gap over the whole window at c=4: 0.172 (at x=±4) | confirmed |
| 9 | "For small c ... the catenary climbs more steeply than the parabola and the two separate well inside the window" | c=0.5: gap at x=1 is 0.381. Max visible gap 7.69 | confirmed |
| 10 | "at c=0.5 the gap passes 0.1 at $\|x\|\approx0.73$" | mpmath root: 0.727123 | confirmed |
| 11 | "the catenary leaves the top of the plot at $\|x\|\approx1.94$" | acosh(24)/2 = 1.935383 (ylim 12). Script grid: last visible x = 1.932 | confirmed |
| 12 | "the parabola at $\|x\|\approx3.39$" | √11.5 = 3.391165. Script grid: 3.391 | confirmed |
| 13 | "The catenary never lies below the parabola" | min(y_cat − y_par) ≥ 0 in every frame (≥ 2.7e-12 on the grid) | confirmed |
| 14 | "their difference $x^4/(24c^3)+x^6/(720c^5)+\cdots$ is positive for every $x\neq0$" | sympy series: x⁴/(24c³) + x⁶/(720c⁵) + x⁸/(40320c⁷)+…. All terms are even powers with positive coefficients | confirmed |
| 15 | "The lowest point is always at (0, c)" | y = c cosh(0) = c. The black diamond is drawn at `[0.0],[c]`. Every frame shows it at the apex | confirmed |
| 16 | Case heading "Catenary vs parabola approximation as c varies" | the single script and GIF do exactly this | confirmed |
| 17 | Alt text: "...as c sweeps from 0.5 to 4; the two curves nearly coincide near the apex for large c" | frames 1, 25 and the contact sheet | confirmed |
| 18 | Wiring: `[Julia source](catenaryaa.jl)` and the embed `catenaryaa.gif` | the files exist. The script writes `catenaryaa.gif`. The GIF regenerates byte-identically (manifest) | confirmed |
| 19 | Diagram key: blue solid = catenary, red dashed = parabola, black diamond = lowest point (implicit in legend) | the legend in the frames matches the plot calls | confirmed |
| 20 | "based on Exploration 1 ("Approximated by a parabola")" | archive: that is Exploration 2 | wrong (F1) |
| 21 | "arc-length and catenary-fit explorations (Explorations 2–3)" | archive: arc length is Exploration 3. Catenary fit has no exploration number | wrong (F1) |
| 22 | Examples 1–2: "solve numerically for the c of the catenary through the origin and two points at equal height ..., compute its arc length with Simpson's rule, and compare ... with the parabola through the same three points" | `lnk_5`/`lnk_6` text: Example 1 is a catenary through the origin and two symmetric points with a=10, b=6, with Simpson's rule for length. Example 2 is the parabola through the same points, compared | confirmed (legacy inventory; checked against the text only) |

### 3. Implementation checks: `catenaryaa.jl`

- **It is the method it claims to be.** There is no numerical method here. The script evaluates the catenary and its two-term Maclaurin truncation directly. The formulas match the header comment and the page.
- **The numbers are right.** I instrumented a copy (`review/inst.jl`, run with the same `x` and `c` grids) and compared it against an independent mpmath/sympy computation (`review/check.py`):

  | Quantity | Script copy | Independent |
  |---|---|---|
  | c=0.5: catenary exits y=12 at | grid 1.9319 (last visible sample) | 1.935383 |
  | c=0.5: parabola exits y=12 at | grid 3.3908 | 3.391165 |
  | c=0.5: max visible gap | 7.6838 | 7.6865 (finer grid) |
  | c=4: max gap in window | 0.172323 | 0.172323 |
  | min(y_cat − y_par), frames 1/5/13/25 | 1.4e-9, 1.4e-10, 1.5e-11, 2.7e-12 | ≥ 0 analytically |
  | c titles, frames 1/5/13/25 | 0.5, 1.08, 2.25, 4.0 | linspace(0.5,4,25): 0.5, 1.0833, 2.25, 4.0 |

  Note: the 500-point x grid has no sample at x=0 (nearest is ±0.008), so the plotted minimum is c + 6e-5 at c=0.5. This cannot be seen and is harmless.
- **Reference values.** There is no separate "exact" curve. The catenary itself is the reference and is evaluated in closed form.
- **The picture shows what was computed.** I looked at frames 1 and 25 and the 9-frame contact sheet. The blue solid curve is c·cosh(x/c). The red dashed curve is the parabola. The diamond sits at (0, c) on both curves. The titles report the current c (rounded to 2 dp). The window x ∈ [−4,4], y ∈ [0,12] clips the small-c curves at the top, which the page states explicitly (exit points confirmed above). The clipping does not hide the feature being discussed. There are 25 frames at 5 fps, one per c value.

### Archive consulted
Yes: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/CatenaryMod.html` and `catenary/CatenaryMod/Links/*`. The graph images for the parabola exploration (`gr_31`, `gr_37`, `gr_41`) referenced by `lnk_3` are missing from the archive, so I could not compare Mathews' parabola plot visually. The formulas (`gr_27`–`gr_29`) were readable and agree with the page up to the vertical shift by c.

