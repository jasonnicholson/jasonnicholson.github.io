# Least Squares Lines — animation review (round 8)

Page: `pages/numerical-methods/least-squares-lines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every numerical claim, behaviour claim, diagram claim and wiring claim on the page agrees with my own computation and with the frames. All four scripts implement the methods they name and produce correct values.

Observations I checked and decided are not findings:
- The Description says "Regressing $x$ on $y$ … produces a different line after rearrangement, even for the same data". Strictly, this fails for exactly collinear data, which includes the two-point frame. The Case 2 text says this explicitly ("With only the first two points … give the same line"), so a reader is not misled.
- Case 1, later frames: the green line crosses the top-left annotation text. The text stays legible.
- Case 2: the black intersection diamond (ms=4) is drawn on top of the orange centroid star (ms=11). It is small but visible in frames 2 to 7, and the alt text describes this layering accurately.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lslineaa.jl` | 0 | 7.4 | lslineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineab.jl` | 0 | 7.4 | lslineab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineac.jl` | 0 | 7.3 | lslineac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslinead.jl` | 0 | 6.3 | lslinead.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | standard model $y=b+ax$, residuals are vertical distances | lslineaa.jl L13-21 normal equations; residual orthogonal to [1,x] (max 5e-14) | confirmed |
| D2 | Description | x-on-y regression gives a different line after rearrangement | slopes differ for k ≥ 3 (k=8: -1.607143 vs -1.627778); coincide only for collinear data (k=2), which Case 2 states | confirmed |
| D3 | Description | $y=ax$ and $y=ax^{3/2}$ are linear in $a$, so least squares applies directly | lslineac/ad use a = Σφy/Σφ²; residual orthogonal to φ (≤1.5e-10 relative to large sums) | confirmed |
| I1 | Intro | each animation shows the fit changing as points are added | k=2..8 (Case 1, 2), 1..8 (Case 3), 1..4 (Case 4) | confirmed |
| I2 | Intro | Cases 1, 3, 4 print coefficients and RSS in every frame | code L55/L41/L42; frames show "a=…, b=…, RSS=…", "a=…, RSS=…" | confirmed |
| I3 | Intro | Cases 1 and 3 draw vertical residuals as dark blue segments from point to line | `color=:navy` segments `[x_i,x_i]`, `[y_i, ŷ_i]`; visible in frames | confirmed |
| I4 | Intro | largest residual in any frame about 0.79 (Case 1) | max \|r\| = 0.7857 (k=7, 8, point (4,3)) | confirmed |
| I5 | Intro | largest residual in any frame about 0.46 (Case 3) | max \|r\| = 0.4608 (k=8) | confirmed |
| C1a | Case 1 heading | $y=b+ax$ | script title and fit | confirmed |
| C1b | Case 1 | all eight points: $a=-45/28\approx-1.6071$, $b=121/14\approx8.6429$ | exact Fraction: -45/28, 121/14; Julia -1.6071428…, 8.6428571…; frame 7 text matches | confirmed |
| C1c | Case 1 | $(6,-1)$ lies exactly on the seven-point line; last two frames show the same fit | -45/28·6+121/14 = -1 exactly; k=7 and k=8 coefficients identical | confirmed |
| C1d | Case 1 | data are the legacy data | gr_8: (-1,10),(0,9),(1,7),(2,5),(3,4),(4,3),(5,0),(6,-1) = script L10-11 | confirmed |
| C1e | Case 1 | RSS with all points (frame) 1.3929 | 39/28 = 1.392857, which matches archive gr_58 | confirmed |
| C2a | Case 2 | with two points both regressions give the same line through both points | a=c=-1, a·c=1; frame 1 says "both lines coincide" | confirmed |
| C2b | Case 2 | from three points on, two distinct lines | slopes (y-on-x, x-on-y): k=3 -1.5/-1.5556, k=4 -1.7/-1.7353, …; all differ | confirmed |
| C2c | Case 2 | intersection coincides with centroid of points used | exact: k=3 (0,26/3), k=4 (1/2,31/4), …, k=8 (5/2,37/8) = centroids | confirmed |
| C2d | Case 2 | all eight points centroid $(2.5, 4.625)$ | 20/8, 37/8 | confirmed |
| C2e | Case 2 | slopes $-1.6071$ and $-1.6278$ with all eight | -1.607143, 1/c = -1.627778 | confirmed |
| C2f | Case 2 alt | intersection is a black diamond drawn on the centroid, which is an orange star | code L73-77; frames | confirmed |
| C3a | Case 3 heading | $y=ax$, through the origin | lslineac.jl L12 a=Σxy/Σx², line `a .* xplot` | confirmed |
| C3b | Case 3 | legacy dataset, all eight: $a=157/102\approx1.5392$ | Fraction 157/102 = 1.539216; archive gr_117 data, gr_140 "157x/102 = 1.53922x" | confirmed |
| C3c | Case 3 | coefficient zig-zags downward from 2 | 2, 1.6, 1.6429, 1.5667, 1.5818, 1.5495, 1.5571, 1.5392 (alternating down/up, net down) | confirmed |
| C3d | Case 3 alt | residual segments drawn | frames | confirmed |
| C4a | Case 4 heading | $T=ar^{3/2}$ | lslinead.jl L13 a = Σ r^{1.5}T / Σ r³ | confirmed |
| C4b | Case 4 | Mercury, Venus, Earth, Mars data, which are the legacy module's | gr_145 matches script L9-10 | confirmed |
| C4c | Case 4 | $a\approx0.19977$ | lstsq 0.19976930; archive gr_156 0.199769 | confirmed |
| C4d | Case 4 | Mercury distance 57.59 is about 0.55% below modern ≈57.91 | (57.59-57.909)/57.909 = -0.551% | confirmed |
| C4e | Case 4 | Mercury $T/r^{3/2}\approx0.2013$; others 0.1997 to 0.1999 | 0.201332; 0.199896, 0.199680, 0.199756 | confirmed |
| C4f | Case 4 | Mercury stands apart *because of* the distance | with modern r, Mercury ratio = 87.99/57.909^1.5 = 0.19967, in line with the others (modern r and T all give 0.19962) | confirmed |
| W1 | Wiring | Case 1 → lslineaa.jl / .gif; Case 2 → lslineab; Case 3 → lslineac; Case 4 → lslinead | index.qmd L28-54; each script's content matches its heading; committed GIFs byte-identical to regen (manifest) | confirmed |
| F1 | Fidelity | archive examples covered | Ex1→Case 1, Ex2 + Ex3 (x-on-y line, intersection = mean point)→Case 2, Ex4→Case 3, Ex5→Case 4; same data in each | confirmed (no fidelity issue) |

### 3. Implementation checks

### lslineaa.jl (Case 1, standard line)
- **Method:** closed-form normal equations for $y=b+ax$. Correct.
- **Numbers:** the instrumented copy printed k=2..8: a = -1, -1.5, -1.7, -1.6, -1.485714, -1.607143, -1.607143 and b = 9, 8.666667, 8.6, 8.6, 8.561905, 8.642857, 8.642857. These are identical to numpy lstsq and to the exact fractions (-3/2, 26/3; -17/10, 43/5; -8/5, 43/5; -52/35, 899/105; -45/28, 121/14). Residual orthogonality to [1, x] holds to 5e-14. RSS values 0, 0.1667, 0.3, 0.4, 0.7048, 1.3929, 1.3929 match the frames.
- **Reference values:** none drawn apart from the data. The data match archive gr_8.
- **Picture:** the line uses the computed a and b, and the residual segments run from (x_i, y_i) to (x_i, a x_i + b). I checked the sheet and frame 7. The annotation shows the correct values and the legend shows the correct k.

### lslineab.jl (Case 2, two regressions)
- **Method:** y-on-x line (as above) and x-on-y line x = c y + d from the normal equations with the roles swapped, rearranged to y = (1/c)x - d/c. The intersection is solved from y = a(cy+d)+b. Correct.
- **Numbers:** the instrumented copy's c and slope 1/c match my exact computation for every k. The intersection equals the centroid to within 1e-13 (for example k=8: (2.500000000000066, 4.624999999999893) against (2.5, 4.625)). k=2 is caught by |1-ac|>1e-8 (ac = 1 exactly).
- **Picture:** green solid y-on-x line, blue dashed x-on-y line, orange star at the centroid, black diamond at the intersection. In frames 1 to 7 the labels "k=…: (xi, yi)=…" match the computed values (k=3 shows 0.0, which is xi = 8.9e-16 rounded).

### lslineac.jl (Case 3, through the origin)
- **Method:** a = Σxy/Σx², the one-parameter least-squares fit of y = ax. Correct.
- **Numbers:** a for k=1..8 equals 2, 8/5, 23/14, 47/30, 87/55, 141/91, 109/70, 157/102 (exact). The Julia output is identical. RSS 0, 0.2, 0.2143, 0.3667, 0.3818, 0.5275, 0.5429, 0.6863 matches the frames. The residual is orthogonal to x.
- **Reference:** the archive gives 157/102 = 1.53922 (gr_140), which matches.
- **Picture:** magenta line a·x through the origin and navy residual segments. Frame 8 text "a = 1.53922, RSS = 0.6863" is correct.

### lslinead.jl (Case 4, Kepler power fit)
- **Method:** a = Σ r^{3/2} T / Σ r³, least squares on the basis φ = r^{3/2}, with vertical residuals in T. Correct.
- **Numbers:** for k=1..4 the script gives a = 0.20133195, 0.20008463, 0.19980286, 0.19976930, and numpy lstsq gives the same to 8 digits. RSS 0, 0.3421, 0.5078, 0.5154 matches the frames.
- **Reference:** the archive gives 0.199769 (gr_156). I checked the page's explanation about Mercury's distance against modern orbital elements (C4d to C4f).
- **Picture:** the curve uses the computed a, and the planet labels sit beside the right points. The window 40 ≤ r ≤ 240, 0 ≤ T ≤ 750 contains all the data. The legacy plot (gr_153) starts at r = 0, but the cropped window hides nothing the page discusses.

### Regeneration
The manifest reports that all four committed GIFs are byte-identical to scratch regenerations, so the frames reviewed are the output of the current scripts.

