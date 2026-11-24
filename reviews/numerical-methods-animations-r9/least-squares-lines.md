# Least Squares Lines — animation review (round 9)

Page: `pages/numerical-methods/least-squares-lines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Counts: Error 0, Misleading 0, Minor 0.

Every numerical claim on the page matches an independent exact computation at the precision it is stated to. Every behaviour claim matches the computed sequences. Each frame's annotations and geometry match what the script computes. All four legacy examples (five numbered examples, with Examples 2 and 3 combined into Case 2) are present and use Mathews' data.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lslineaa.jl` | 0 | 6.8 | lslineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineab.jl` | 0 | 7.8 | lslineab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineac.jl` | 0 | 7.4 | lslineac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslinead.jl` | 0 | 7.3 | lslinead.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description | Standard model $y = b + a x$, residuals are vertical distances | `lslineaa.jl` fits y = a x + b by the normal equations; residuals drawn as vertical segments `[xv[i],xv[i]]` | confirmed |
| D2 | Description | Regressing x on y gives a different line after rearrangement | k = 3..8 slopes differ (e.g. k = 8: -1.60714 vs -1.62778); they coincide only when \|r\| = 1, which the page itself notes for k = 2 | confirmed |
| D3 | Description | $y = a x$ and $y = a x^{3/2}$ are linear in $a$, so least squares applies directly | `lslineac.jl`/`lslinead.jl` use a = Σφy/Σφ² with φ = x or x^{1.5}; the residual is orthogonal to φ (exact 0 for Case 3; ~1e-10 relative for Case 4) | confirmed |
| I1 | Intro | Each animation shows the fitted model changing as points are added | Cases 1, 2: k = 2..8; Case 3: k = 1..8; Case 4: k = 1..4 | confirmed |
| I2 | Intro | Cases 1, 3, 4 print fitted coefficients and RSS in each frame | Annotations: Case 1 `a, b, RSS`; Case 3 `a, RSS`; Case 4 `a, RSS`; seen in all frames | confirmed |
| I3 | Intro | Cases 1 and 3 draw each vertical residual as a dark blue segment | `color=:navy` segments from (x_i, y_i) to (x_i, ŷ_i); visible in frames | confirmed |
| I4 | Intro | Largest residual in any frame about 0.79 (Case 1) and 0.46 (Case 3) | Case 1 max over frames = 11/14 = 0.785714 (k = 7, 8); Case 3 max = 47/102 = 0.460784 (k = 8) | confirmed |
| I5 | Intro | Segments are short and some barely visible | Frames: k = 3–5 segments ≤ 0.4 units on a 13.5-unit axis | confirmed |
| C1a | Case 1 heading | Standard least-squares line $y = b + a x$ | Script title "Least Squares Line: y = b + a*x"; method is ordinary least squares | confirmed |
| C1b | Case 1 | With all eight points $a = -45/28 \approx -1.6071$, $b = 121/14 \approx 8.6429$ | Exact: a = -45/28 = -1.607143, b = 121/14 = 8.642857; script prints -1.6071428571428572, 8.642857142857142; legacy Example 1 gives the same line | confirmed |
| C1c | Case 1 | $(6,-1)$ lies exactly on the seven-point line, so the last two frames show the same fit | Seven-point fit is also a = -45/28, b = 121/14; -45/28·6 + 121/14 = -1 exactly; RSS 39/28 = 1.392857 in both frames | confirmed |
| C1d | Case 1 alt | Line updates as points are added, residuals as short dark blue segments | Frames 1–7 | confirmed |
| C1e | Case 1 wiring | Link/embed `lslineaa.jl` / `lslineaa.gif` | Script is the y-on-x fit; GIF byte-identical to regenerated output | confirmed |
| C2a | Case 2 | With only the first two points both regressions give the same line through both points | k = 2: a = -1, c = -1, a·c = 1; frame 1 annotation "k=2: both lines coincide"; one line visible through (-1,10), (0,9) | confirmed |
| C2b | Case 2 | From three points on they give two distinct lines | k = 3..8: 1 - a·c ≠ 0 (r² ranges 0.964–0.987), distinct slopes | confirmed |
| C2c | Case 2 | The intersection coincides with the centroid of the points used | Exact intersection = centroid for every k = 3..8: (0, 26/3), (0.5, 7.75), (1, 7), (1.5, 19/3), (2, 38/7), (2.5, 4.625); script's xi, yi agree to ≤ 1.2e-13 | confirmed |
| C2d | Case 2 | For all eight points, $(\bar x,\bar y) = (2.5, 4.625)$ | Exact 5/2, 37/8; legacy Example 3 answer {5/2, 37/8} | confirmed |
| C2e | Case 2 | Strongly correlated; lines nearly overlap; slopes -1.6071 and -1.6278 | r = -0.99364; y-on-x slope -45/28 = -1.60714; x-on-y rearranged slope 1/c = -293/180 = -1.62778 | confirmed |
| C2f | Case 2 alt | Intersection (black diamond) drawn on the centroid (orange star) | Diamond ms = 4 drawn over star ms = 11; visible as a black dot in the star in frames 2–7 (full-size frame 7 checked); legend entries match | confirmed |
| C2g | Case 2 wiring | `lslineab.jl` / `lslineab.gif` | Script fits both regressions and plots the intersection; GIF byte-identical to regenerated | confirmed |
| C3a | Case 3 heading | Constrained fit through the origin $y = a x$ | a = Σxy/Σx², the correct one-parameter normal equation; line plotted as a·x | confirmed |
| C3b | Case 3 | All eight points of the legacy dataset give $a = 157/102 \approx 1.5392$ | Exact 157/102 = 1.539216; script 1.5392156862745099; data match legacy Example 4 data; legacy answer "157x/102 = 1.53922x" | confirmed |
| C3c | Case 3 | The coefficient zig-zags downward from 2 | Sequence 2, 1.6, 1.64286, 1.56667, 1.58182, 1.54945, 1.55714, 1.53922: overall downward, alternating after the first step | confirmed |
| C3d | Case 3 alt | Fit through origin with vertical residuals as dark blue segments | Frames 1–8 | confirmed |
| C3e | Case 3 wiring | `lslineac.jl` / `lslineac.gif` | Correct script; GIF byte-identical | confirmed |
| C4a | Case 4 heading | Kepler-style power fit $T = a r^{3/2}$ | a = Σ r^{1.5} T / Σ r³; title "Power Fit: T = a*r^(3/2)" | confirmed |
| C4b | Case 4 | Linear in $a$ after choosing basis $r^{3/2}$ | Residual orthogonal to r^{1.5} (6e-11 against Σ≈2.9e7) | confirmed |
| C4c | Case 4 | Mercury, Venus, Earth, Mars data give $a \approx 0.19977$ | lstsq: 0.19976930; script 0.1997693001603878; frame "0.199769"; legacy answer "y = 0.199769 x^{3/2}" | confirmed |
| C4d | Case 4 | These are the legacy module's data | Script data = legacy image gr_145: (57.59, 87.99), (108.11, 224.70), (149.57, 365.26), (227.84, 686.98) | confirmed |
| C4e | Case 4 | Mercury's 57.59 Mkm is about 0.55% below its modern semi-major axis of about 57.91 Mkm | 57.59/57.909 - 1 = -0.551% (modern a = 0.387098 AU = 57.909 Mkm) | confirmed |
| C4f | Case 4 | Mercury's ratio $T/r^{3/2} \approx 0.2013$ | 0.2013319 | confirmed |
| C4g | Case 4 | Other three planets' ratios 0.1997 to 0.1999 | Venus 0.199896, Earth 0.199680, Mars 0.199756 (round to 0.1999, 0.1997, 0.1998) | confirmed |
| C4h | Case 4 | The low Mercury distance is why its ratio stands apart | With the legacy T and modern r = 57.909, Mercury's ratio becomes 0.199671, in line with the others (all modern ratios ≈ 0.199622) | confirmed |
| C4i | Case 4 alt | Power-law fit for planetary distance/period data | Frames 1–4 | confirmed |
| C4j | Case 4 wiring | `lslinead.jl` / `lslinead.gif` | Correct script; GIF byte-identical | confirmed |
| W1 | Counts | Frames: Case 1 7, Case 2 7, Case 3 8, Case 4 4 (implied by the k ranges) | Frame extraction counts 7/7/8/4 | confirmed |

### 3. Implementation checks

### `lslineaa.jl` — standard least-squares line
- **Method:** ordinary least squares y = a x + b from the closed-form normal-equation solution a = (nΣxy − ΣxΣy)/(nΣx² − (Σx)²), b = (Σy − aΣx)/n. Correct method, standard form.
- **Numbers (script | independent exact):**

| k | a | b | RSS | max \|res\| |
|---|---|---|---|---|
| 2 | -1.0 \| -1 | 9.0 \| 9 | 0 \| 0 | 0 |
| 3 | -1.5 \| -3/2 | 8.666667 \| 26/3 | 0.166667 \| 1/6 | 0.3333 |
| 4 | -1.7 \| -17/10 | 8.6 \| 43/5 | 0.3 \| 3/10 | 0.4 |
| 5 | -1.6 \| -8/5 | 8.6 \| 43/5 | 0.4 \| 2/5 | 0.4 |
| 6 | -1.485714 \| -52/35 | 8.561905 \| 899/105 | 0.704762 | 0.5905 |
| 7 | -1.607143 \| -45/28 | 8.642857 \| 121/14 | 1.392857 \| 39/28 | 0.7857 |
| 8 | -1.607143 \| -45/28 | 8.642857 \| 121/14 | 1.392857 \| 39/28 | 0.7857 |

  Exact residuals satisfy Σr = 0 and Σr·x = 0 for every k (orthogonality to the basis {1, x}); `numpy.linalg.lstsq` agrees to machine precision.
- **Reference values:** none drawn.
- **Picture:** green line = a x + b over the full window; navy segments go from (x_i, y_i) to (x_i, a x_i + b) for the points used; the annotation reports a, b, RSS of the current k (4 d.p.); the legend says "fit with first k points" with the correct k. Axis window (-2, 7) × (-2.2, 11.3) matches Mathews' plot range and contains all data. No clamping or masking.

### `lslineab.jl` — y-on-x and x-on-y lines and their intersection
- **Method:** y-on-x as above; x-on-y fits x = c y + d with the same formula with the roles of x and y swapped, then draws y = x/c − d/c. Intersection solved from y = a(c y + d) + b ⇒ y = (a d + b)/(1 − a c), x = c y + d. Correct.
- **Numbers (script | exact):** c = -1, -9/14, -34/59, -8/13, -39/59, -105/172, -180/293 for k = 2..8 (script -1.0, -0.642857, -0.576271, -0.615385, -0.661017, -0.610465, -0.614334: matches). Rearranged slopes 1/c: -1, -1.55556, -1.73529, -1.625, -1.51282, -1.63810, -1.62778 (script identical). Intersection vs exact centroid agree for all k = 3..8 to ≤ 1.2e-13 (e.g. k = 8 script (2.500000000000066, 4.624999999999893) vs exact (5/2, 37/8)).
- **Reference values:** the centroid is computed directly as the mean of the points used; correct.
- **Picture:** green solid y-on-x and blue dashed x-on-y lines; orange star at the centroid, black diamond at the computed intersection, drawn only when 1 − a c ≠ 0 (k = 2 shows "both lines coincide"). The status text reports the intersection at 3 d.p. and the right k. The diamond sits inside the star in every frame with k ≥ 3, as the alt text says.

### `lslineac.jl` — fit through the origin y = a x
- **Method:** a = Σxy/Σx², the one-parameter least-squares solution. Correct.
- **Numbers (script | exact):** k = 1..8: 2.0 | 2; 1.6 | 8/5; 1.642857 | 23/14; 1.566667 | 47/30; 1.581818 | 87/55; 1.549451 | 141/91; 1.557143 | 109/70; 1.539216 | 157/102. RSS 0, 0.2, 0.214286, 0.366667, 0.381818, 0.527473, 0.542857, 0.686275 (identical). Exact Σ r·x = 0 for all k.
- **Reference values:** none.
- **Picture:** magenta line a·x through the origin; navy residual segments to a·x_i; annotation a (5 d.p.), RSS (4 d.p.) of the current k. The window (0, 9) × (0, 13) contains all data; the steep k = 1 line leaves through the top edge, which is fine. Data equal legacy Example 4.

### `lslinead.jl` — power fit T = a r^{3/2}
- **Method:** a = Σ r^{3/2} T / Σ r³, least squares with the single basis function r^{3/2}. Correct.
- **Numbers (script | independent lstsq):** k = 1: 0.201331950 | 0.20133195; k = 2: 0.200084626 | 0.20008463; k = 3: 0.199802858 | 0.19980286; k = 4: 0.199769300 | 0.19976930. RSS 0, 0.342087, 0.507771, 0.515371 (identical). Residual orthogonal to r^{1.5} to about 1e-10.
- **Reference values:** none drawn. The page's comparison to the modern Mercury semi-major axis was checked separately (C4e, C4h); I relied on remembered modern orbital elements (Mercury 0.387098 AU = 57.909 Mkm, T = 87.969 d, AU = 149.598 Mkm), not on a source fetched during this review.
- **Picture:** green curve a r^{1.5}; planet names on the points used; annotation a (6 d.p.) and RSS (4 d.p.) for the current k. The window (40, 240) × (0, 750) contains all four planets; the "Mars" label at the top right is not clipped (frame 4 checked).

### Legacy fidelity
Mathews' module has five examples: (1) y-on-x line for (-1,10), …, (6,-1); (2) the x-on-y line for the same data; (3) the intersection of the two lines, compared with the mean point, giving {5/2, 37/8}; (4) y = a x for (1,2), …, (8,12), giving 157/102 = 1.53922; (5) y = a x^{3/2} for the four planets, giving 0.199769. The page's Cases 1–4 use exactly these data. Case 2 combines Examples 2 and 3, and every result matches Mathews' answers. No example is dropped and no function is changed.

