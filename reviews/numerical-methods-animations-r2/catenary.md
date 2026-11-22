# Catenary — animation review (round 2)

Page: `pages/numerical-methods/catenary/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Page match, Minor: c is called the "sag parameter"
- **Location:** `index.qmd` line 12: "... alongside its parabolic approximation $y = x^2/(2c) + c$ as the sag parameter $c$ increases from 0.5 to 4."
- **What is there now:** c is named the "sag parameter".
- **What is true instead:** in $y=c\cosh(x/c)$, c is the catenary parameter, $c = H/w$ (horizontal tension over weight per unit length). Sag goes the opposite way: as c increases the curve gets flatter and the sag gets smaller. On a fixed half-span $a=4$ the sag is $c\cosh(4/c)-c$: 744.7 at c=0.5 and 2.17 at c=4 (from `inst.jl`, y_cat(4) minus c). So the sweep "sag parameter increases" actually shows the sag *decreasing*. The Behavior paragraph itself says large c is a "nearly taut cable" and small c a "slack cable", which is right and partly fixes the problem. A reader skimming the intro would still take the wrong meaning from the name.
- **How I know:** the definition, plus the per-frame values from `julia review/inst.jl` (the `ycat(4)` column falls from 745.24 at c=0.5 to 6.17 at c=4).
- **Suggested correction:** replace "the sag parameter $c$" with "the catenary parameter $c$ (the ratio of horizontal tension to weight per unit length; larger $c$ means a tauter, flatter cable)".

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: the archive's worked examples are dropped without a note
- **Location:** the whole `index.qmd`. It has one case (the parabola comparison), and line 8 says only "Source inspiration: [@mathewsSite]."
- **What is there now:** the page animates only archive Exploration 1 ("Approximated by a parabola").
- **What the archive has:** the numerical part of Mathews' module is its two worked examples:
  - Example 1 (`CatenaryMod_lnk_5.html`, graph `gr_92.gif` showing the points (−10,6), (0,0), (10,6)) finds the catenary $y=c\cosh(x/c)-c$ through the origin and $(\pm10, 6)$. This needs a numerical solve for c ("we must resort to using a numerical approximation for c"). It then computes the arc length with Simpson's rule.
  - Example 2 (`CatenaryMod_lnk_6.html`) fits the parabola through the same points, compares lengths and finds the maximum height difference ("1.7 inches off in 6 feet").

  The page drops both examples and says nothing about it.
- **How I know:** I read the archive as text and viewed `gr_91.gif` (the Mathematica input `a = 10; b = 6`) and `gr_92.gif`. My own computation of the archive's numbers, with `/usr/bin/python3` and mpmath `findroot`: c = 9.18894140222, arc length on [0,10] = $c\sinh(10/c)$ = 12.0941, maximum |catenary − parabola $0.06x^2$| on [0,10] = 1.709 in. (with feet as the unit). That last value matches the archive's "1.7 inches", so I have the archive's setup right.
- **Severity reasoning:** Minor, not Misleading. The page does not claim to cover these examples, and nothing on it is false. A reader of "Source inspiration" would still not learn that the source's numerical content (root-finding for c, Simpson's-rule arc length) is missing.
- **Suggested correction:** either add a second case (say `catenarybb.jl`) that animates the root-finding for c with a=10, b=6, converging to c ≈ 9.18894, with the parabola $y=0.06x^2$ overlaid. Or add one sentence saying the page covers only the parabola comparison, not Mathews' catenary-fit and arc-length examples.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Not findings (noted for completeness)
- The page has no `## Description` section, although the authoring conventions in `.github/agents/animation-page.agent.md` require one. That is content the page does not yet have, so it is out of scope. As a result there are no Description formula claims to check.
- The legend at `:top` sits over the catenary's steep branches near y≈10–11 in the c=0.5 frame. It hides nothing the page talks about.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `catenaryaa.jl` | 0 | 6.0 | catenaryaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | "the catenary $y = c\cosh(x/c)$" | l.12 | script l.13 `y_cat = c .* cosh.(x ./ c)`; frame title shows the same | confirmed |
| 2 | "its parabolic approximation $y = x^2/(2c) + c$" | l.12 | script l.14 `x .^ 2 ./ (2c) .+ c` | confirmed |
| 3 | "$c$ increases from 0.5 to 4" | l.12 | script l.9 `range(0.5, 4.0, length=25)`; frame 1 title c = 0.5, frame 25 title c = 4.0 | confirmed |
| 4 | "the sag parameter $c$" | l.12 | c is the catenary parameter H/w; sag falls as c rises | wrong in name (F1) |
| 5 | "The catenary is the curve formed by a flexible cable hanging under gravity" | l.12 | standard (uniform cable under its own weight); same as the archive's Background | confirmed |
| 6 | "the parabola is the first two terms of its Maclaurin series" | l.12 | sympy: $c\cosh(x/c)=c+x^2/(2c)+x^4/(24c^3)+x^6/(720c^5)+O(x^8)$; first two non-zero terms = $c + x^2/(2c)$ | confirmed |
| 7 | "Julia source scripts ... are linked under each case" | l.14 | one case, linked at l.20 | confirmed |
| 8 | Heading: "Catenary vs parabola approximation as $c$ varies" | l.16 | the script does exactly this | confirmed |
| 9 | "For large $c$ (nearly taut cable), the two curves are nearly indistinguishable near $x=0$" | l.18 | at c=4: gap at x=1 is 6.5e-4; the gap passes 0.1 only at \|x\|≈3.50, and is 0.172 at the window edge x=4; frame 25 shows the two curves overlapping across the middle | confirmed |
| 10 | "nearly taut" for large c / "slack" for small c | l.18 | larger c = more tension relative to weight = flatter | confirmed |
| 11 | "For small $c$ ..., the catenary climbs more steeply than the parabola" | l.18 | slopes: $\sinh(x/c)$ vs $x/c$; $\sinh u > u$ for u>0. Frame 1 shows it | confirmed |
| 12 | "the two separate well inside the window" | l.18 | at c=0.5 the gap is 0.38 at x=1 and the catenary leaves the plot at 1.94, inside ±4 | confirmed |
| 13 | "at $c=0.5$ the gap passes 0.1 at $\|x\|\approx0.73$" | l.18 | mpmath root of $0.5\cosh(2x)-(x^2+0.5)=0.1$: **0.727123**; the script grid gives first exceedance at \|x\|=0.729 | confirmed |
| 14 | "the catenary leaves the top of the plot at $\|x\|\approx1.94$" | l.18 | $0.5\,\mathrm{acosh}(24)$ = **1.935383**; ylims top = 12 (script l.18); frame 1 matches | confirmed |
| 15 | "the parabola [leaves the top] at $\|x\|\approx3.39$" | l.18 | $\sqrt{11.5}$ = **3.391165**; frame 1 matches | confirmed |
| 16 | "The catenary never lies below the parabola" | l.18 | difference = $c(\cosh u - 1 - u^2/2)$ with u=x/c, which is >0 for u≠0. Numerically: min over u∈[−10,10], u≠0, is 4.2e-10 > 0; every frame's grid min difference is >0 (`inst.jl`) | confirmed |
| 17 | "their difference $x^4/(24c^3)+x^6/(720c^5)+\cdots$ is positive for every $x\neq0$" | l.18 | sympy series of the difference: $x^4/(24c^3)+x^6/(720c^5)+x^8/(40320c^7)+\dots$; all terms are even powers with positive coefficients | confirmed |
| 18 | "The lowest point is always at $(0, c)$" | l.18 | $c\cosh(0)=c$ and cosh is minimised at 0; script l.28 places the diamond at (0,c); in frames 1 and 25 the diamond is at y=0.5 and y=4 | confirmed |
| 19 | Source link `[Julia source](catenaryaa.jl)` | l.20 | the file exists; it is the only script | confirmed |
| 20 | Embed `catenaryaa.gif` | l.22 | the file exists; `cmp` against my scratch regeneration: byte-identical | confirmed |
| 21 | Alt text: "Catenary y=c cosh(x/c) compared with its parabolic approximation y=x^2/(2c)+c as c sweeps from 0.5 to 4" | l.22 | as in 1–3 | confirmed |
| 22 | Alt text: "the two curves nearly coincide near the apex for large c" | l.22 | as in 9; frame 25 | confirmed |
| 23 | Implicit count: one case | l.16 | 1 script, 1 GIF, 25 frames | confirmed |

---

### 3. Implementation checks: `catenaryaa.jl`

There is no iterative numerical method here. The script evaluates two closed-form curves over a parameter sweep, so the four checks reduce to the following.

**Method it claims to be.** It claims to plot the catenary $c\cosh(x/c)$ and its two-term Maclaurin parabola. Lines 13–14 compute exactly these. sympy confirms that the parabola is the truncation of the series through $O(x^2)$.

**Numbers are right.** I wrote an instrumented copy (`review/inst.jl`) that runs the same `c_values`/`x` grids and prints per-frame quantities. I set these beside an independent mpmath computation (`review/check.py`):

| Quantity | Script grid (inst.jl) | Independent (mpmath) |
|---|---|---|
| c=0.5: gap first > 0.1 | \|x\| = 0.729 (grid point) | 0.727123 |
| c=0.5: catenary > 12 | \|x\| = 1.948 (grid point) | 1.935383 |
| c=0.5: parabola > 12 | \|x\| = 3.407 (grid point) | 3.391165 |
| c=4: y_cat(4) | 6.1723 | 6.172323 |
| c=4: gap at x=4 | 6.1723 − 6.0 | 0.172323 |
| c=4: gap first > 0.1 | \|x\| = 3.503 | 3.498062 |
| min(cat − par) over grid, any frame | > 0 (2.7e-12 … 1.4e-9) | analytically > 0 for x≠0 |

The grid values differ from the exact ones only by the grid spacing (8/499 ≈ 0.016). The c values are the 25 points of `linspace(0.5, 4, 25)` (0.5, 0.6458, …, 4.0). The titles round them to 2 digits (0.5, 0.65, 0.79, …, 3.12, …, 4.0). Python and Julia give the same rounding, including 3.125 → 3.12.

**Reference values are right.** There is no separate reference. The "exact" curve is the catenary itself, evaluated directly with `cosh`. The labelled lowest point (0, c) is exact.

**Picture shows what was computed.** I viewed frames 1 and 25 and the contact sheet (frames 1, 4, 7, …, 25).
- Frame 1 (c=0.5): the catenary leaves the top at x≈±1.94 and the parabola at ±3.39, matching the numbers above. The diamond is at (0, 0.5).
- Frame 25 (c=4.0): both curves rise from 4 to about 6.0–6.17 at x=±4, with a small visible gap at the edges, which matches the 0.17 gap.
- Titles show the right c for each frame, the legend entries match the plotted formulas, and the colours are consistent (blue solid for the catenary, red dashed for the parabola, black diamond for the lowest point).
- Display devices: the fixed ylims (0, 12) clip the steep catenary at small c. The page states this explicitly ("leaves the top of the plot"), so it is not misleading. There are no NaN masks or clamping.
- Regeneration: the committed GIF is byte-identical to a scratch regeneration (manifest, and my `cmp`).

