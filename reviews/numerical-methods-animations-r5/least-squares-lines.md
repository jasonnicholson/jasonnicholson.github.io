# Least Squares Lines — animation review (round 5)

Page: `pages/numerical-methods/least-squares-lines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with the independent computation and with the frames, every script implements the method it names with correct numbers, and the four cases cover all five of Mathews' examples with his data.

Observations that are not findings (cosmetic, do not mislead):
- Case 1 frames 2-7: the green fit line passes through the top-left annotation text (e.g. between "a" and "=" in frame 7). The text remains readable.
- Case 4 frames: planet name labels touch the red markers (e.g. "Earth"). Readable.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lslineaa.jl` | 0 | 6.4 | lslineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineab.jl` | 0 | 6.9 | lslineab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineac.jl` | 0 | 7.1 | lslineac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslinead.jl` | 0 | 6.9 | lslinead.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `lslineaa.gif` | 7 | byte-identical | lslineaa |
| `lslineab.gif` | 7 | byte-identical | lslineab |
| `lslineac.gif` | 8 | byte-identical | lslineac |
| `lslinead.gif` | 4 | byte-identical | lslinead |

### Page references

- Scripts linked: `lslineaa.jl`, `lslineab.jl`, `lslineac.jl`, `lslinead.jl`
- GIFs embedded: 4
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | standard model $y = b + a x$, residuals are vertical distances | `fit_unconstrained` minimises vertical residuals (residual orthogonal to [1, x], see section 3); Mathews uses y = ax + b (gr_7) | confirmed |
| D2 | Description | Regressing x on y produces a different line after rearrangement, even for the same data | k=8: y-on-x slope -1.607143, x-on-y rearranged slope -1.627778 | confirmed |
| D3 | Description | $y=ax$ and $y=ax^{3/2}$ remain linear in $a$, so least squares applies directly | scripts use the one-parameter normal equation; residual orthogonal to basis (section 3) | confirmed |
| A1 | Animations intro | Each animation shows how the fitted model changes as data points are added | loops `k in 2:8`, `2:8`, `1:8`, `1:4`; frames 7, 7, 8, 4 | confirmed |
| A2 | intro | Cases 1, 3 and 4 print the fitted coefficients and the RSS in each frame | Case 1 annotation "a, b, RSS"; Case 3 "a, RSS"; Case 4 "a, RSS" (code lines 55-56, 41-42, 42-43; frames) | confirmed |
| A3 | intro | Cases 1 and 3 draw each vertical residual as a dark blue segment from the point to the line | `color=:navy` segments `[xv[i],xv[i]]`, `[yv[i], yhat]` in both scripts; visible in frames | confirmed |
| A4 | intro | largest residual in any frame about 0.79 in Case 1 | max over frames = 0.785714 (k=7,8), script and Python agree | confirmed |
| A5 | intro | largest residual about 0.46 in Case 3 | max over frames = 0.460784 (k=8) | confirmed |
| C1a | Case 1 heading | standard least-squares line $y=b+ax$ | `lslineaa.jl` closed-form normal equations; title "Least Squares Line: y = b + a*x" | confirmed |
| C1b | Case 1 | With all eight points $a=-45/28\approx-1.6071$, $b=121/14\approx8.6429$ | exact Fraction: (-45/28, 121/14); script -1.6071428571, 8.6428571429; Mathews gr_51: 121/14 - 45x/28 | confirmed |
| C1c | Case 1 | eighth point (6, -1) lies exactly on the seven-point line, so last two frames show the same fit | 121/14 - 6*45/28 = -1 exactly; k=7 and k=8 give identical a, b, RSS 1.392857 (= 39/28, Mathews gr_58) | confirmed |
| C1d | Case 1 alt | standard line updating as points added, residual segments dark blue | frames 1-7 | confirmed |
| C1e | Case 1 wiring | link `lslineaa.jl`, embed `lslineaa.gif` | script writes `lslineaa.gif`; content is Case 1 | confirmed |
| C2a | Case 2 | With only the first two points both fits give the same line through both points | k=2: a=-1, b=9; c=-1, d=9 so alpha=-1, beta=9; frame 1 annotation "both lines coincide" | confirmed |
| C2b | Case 2 | From three points on they give two distinct lines | k=3: slopes -1.5 vs -1.5556; distinct at every k=3..8 | confirmed |
| C2c | Case 2 | intersection coincides with the centroid of the points used | k=3..8 intersection equals centroid to 1e-13 (script) / exactly (Python solve); Mathews gr_103-107 | confirmed |
| C2d | Case 2 | for all eight points $(\bar x,\bar y)=(2.5, 4.625)$ | mean of data = (2.5, 4.625); script xi=2.5000000000001, yi=4.6249999999999; Mathews {5/2, 37/8} | confirmed |
| C2e | Case 2 | lines nearly overlap: with all eight points slopes $-1.6071$ and $-1.6278$ | a=-1.6071428571, 1/c=-1.6277777778 | confirmed |
| C2f | Case 2 alt | intersection (black diamond) drawn on centroid (orange star) | code lines 73-77; frames 2-7 show the diamond inside the star; no diamond at k=2 (correct, lines coincide) | confirmed |
| C2g | Case 2 wiring | `lslineab.jl` / `lslineab.gif` | confirmed |
| C3a | Case 3 heading | constrained fit through the origin $y=ax$ | `fit_through_origin` = sum(xy)/sum(x^2) | confirmed |
| C3b | Case 3 | all eight points of the legacy dataset give $a=157/102\approx1.5392$ | Fraction 157/102 = 1.539216; script 1.5392156863; Mathews gr_132/138 157x/102; data (1,2)...(8,12) matches gr_117 | confirmed |
| C3c | Case 3 | as points are added the coefficient zig-zags downward from 2 | a(k) = 2, 1.6, 1.642857, 1.566667, 1.581818, 1.549451, 1.557143, 1.539216: overall decrease, alternating from k=2 on | confirmed |
| C3d | Case 3 alt | fit through origin, residual segments dark blue | frames 1-8 | confirmed |
| C3e | Case 3 wiring | `lslineac.jl` / `lslineac.gif` | confirmed |
| C4a | Case 4 heading | $T=ar^{3/2}$ | `fit_kepler_a` = sum(r^1.5 T)/sum(r^3); plotted curve `a .* xplot.^1.5` | confirmed |
| C4b | Case 4 | exponent fixed at 3/2, linear in $a$ with basis $r^{3/2}$ | as above; residual orthogonal to r^1.5 (rel. 1e-10 of sums ~1e7) | confirmed |
| C4c | Case 4 | Mercury, Venus, Earth, Mars data give $a\approx0.19977$ | numpy lstsq 0.1997693; script 0.1997693002; Mathews gr_151/156 0.199769 | confirmed |
| C4d | Case 4 | these are the legacy module's data | script data equal Mathews gr_145/147 (57.59, 87.99), (108.11, 224.70), (149.57, 365.26), (227.84, 686.98) | confirmed |
| C4e | Case 4 | legacy Mercury distance 57.59 is about 0.55% below modern semi-major axis about 57.91 million km | (57.909-57.59)/57.909 = 0.551% | confirmed |
| C4f | Case 4 | which is why Mercury's ratio $T/r^{3/2}\approx0.2013$ stands apart | legacy ratio 0.201332; with r=57.909 the ratio becomes 0.199671, in line with the others and with 2*pi/sqrt(GM_sun) = 0.199623 day/(Mkm)^1.5 | confirmed |
| C4g | Case 4 | other three planets' ratios $0.1997$ to $0.1999$ | Venus 0.199896, Earth 0.199680, Mars 0.199756: range 0.1997-0.1999 at 4 d.p. | confirmed |
| C4h | Case 4 alt | power-law fit for planetary distance and period data | frames 1-4 | confirmed |
| C4i | Case 4 wiring | `lslinead.jl` / `lslinead.gif` | confirmed |
| F1 | Fidelity | page covers the archive's examples | Ex 1 -> Case 1; Ex 2 (x = cy + d) and Ex 3 (intersection) -> Case 2; Ex 4 (y = ax, data gr_117) -> Case 3; Ex 5 (T = C x^{3/2}, data gr_147) -> Case 4. All data identical to the archive. | confirmed |

### 3. Implementation checks

Independent values from `review/indep.py` (`/usr/bin/python3`); script values from `review/inst/*.jl` run with `julia`.

### `lslineaa.jl` (Case 1, y = b + a x)
- Method: closed-form normal equations for the unconstrained line, a = (n Sxy - Sx Sy)/(n Sxx - Sx^2), b = (Sy - a Sx)/n. This is ordinary least squares on basis [1, x].
- Numbers (script / independent):

| k | a | b | RSS | max abs residual |
|---|---|---|---|---|
| 2 | -1.0 / -1 | 9.0 / 9 | 0 / 0 | 0 / 0 |
| 3 | -1.5 / -3/2 | 8.666667 / 26/3 | 0.166667 / 0.166667 | 0.3333 / 0.3333 |
| 4 | -1.7 / -17/10 | 8.6 / 43/5 | 0.3 / 0.3 | 0.4 / 0.4 |
| 5 | -1.6 / -8/5 | 8.6 / 43/5 | 0.4 / 0.4 | 0.4 / 0.4 |
| 6 | -1.485714 / -52/35 | 8.561905 / 899/105 | 0.704762 / 0.704762 | 0.5905 / 0.5905 |
| 7 | -1.607143 / -45/28 | 8.642857 / 121/14 | 1.392857 / 1.392857 | 0.7857 / 0.7857 |
| 8 | -1.607143 / -45/28 | 8.642857 / 121/14 | 1.392857 / 1.392857 | 0.7857 / 0.7857 |

  Residual orthogonal to [1, x] at every k (A^T r of order 1e-14). Mathews' result 121/14 - 45x/28, RSS 39/28 = 1.39286 agrees.
- Reference values: none beyond the fit itself.
- Picture: line drawn from the fitted a, b over the full x range; residual segments from (x_i, y_i) to (x_i, a x_i + b); legend count "first k points" matches k; annotation values match the table at 4 d.p. Frames 1, 4, 7 inspected plus the contact sheet. Axis window (-2..7, -2.2..11.3) contains all data.

### `lslineab.jl` (Case 2, y-on-x and x-on-y)
- Method: y-on-x as above; x-on-y with roles of x and y swapped (x = c y + d), rearranged to y = x/c - d/c. Intersection solves y = a x + b, x = c y + d: y = (a d + b)/(1 - a c). Algebra checked.
- Numbers (script / independent): c, d and intersection at k = 3..8: c = -0.642857 / -0.642857, -0.576271 / -0.576271, -0.615385 / -0.615385, -0.661017 / -0.661017, -0.610465 / -0.610465, -0.614334 / -0.614334; intersections (0, 8.6667), (0.5, 7.75), (1, 7), (1.5, 6.3333), (2, 5.4286), (2.5, 4.625) in both, equal to the centroid each time. k = 2: a c = 1, script flags "both lines coincide" and draws no diamond, correct. Mathews' intersection {5/2, 37/8} agrees.
- Reference values: centroid computed as plain mean, correct.
- Picture: green solid y-on-x, blue dashed x-on-y rearranged, star at centroid, diamond at computed intersection; annotation (xi, yi) rounded to 3 d.p. matches. Frames 1, 2, 7 inspected plus the contact sheet.

### `lslineac.jl` (Case 3, y = a x)
- Method: one-parameter least squares through the origin, a = Sxy/Sxx (Mathews' power-fit formula with m = 1).
- Numbers (script / independent exact): k=1..8: 2 / 2, 1.6 / 8/5, 1.642857 / 23/14, 1.566667 / 47/30, 1.581818 / 87/55, 1.549451 / 141/91, 1.557143 / 109/70, 1.539216 / 157/102. RSS and max residual agree (final RSS 0.686275, max residual 0.460784). Residual orthogonal to x (1e-14). Mathews 157x/102 = 1.53922x agrees.
- Picture: magenta line a x from origin; navy residual segments to a x_i; annotation a to 5 d.p. and RSS match. Contact sheet of all 8 frames inspected.

### `lslinead.jl` (Case 4, T = a r^{3/2})
- Method: one-parameter least squares on basis r^{3/2}: a = sum(r^1.5 T)/sum(r^3).
- Numbers (script / independent lstsq): k=1 0.20133195 / 0.2013319; k=2 0.20008463 / 0.2000846; k=3 0.19980286 / 0.1998029; k=4 0.19976930 / 0.1997693. RSS 0, 0.3421, 0.5078, 0.5154 in both. Residual orthogonal to r^{3/2}. Mathews 0.199769 agrees.
- Reference values: the page's physical comparison checked against GM_sun = 1.32712440018e20 m^3/s^2: Kepler constant 2 pi / sqrt(GM) = 0.199623 day/(Mkm)^1.5; Mercury with modern r = 57.909 gives 0.199671 (legacy 0.201332), supporting the page's explanation.
- Picture: green curve a r^1.5 over r in 40..240; planet labels attached to points used; annotation a to 6 d.p. and RSS match. All 4 frames inspected (contact sheet, frame 4 full size).

