# Least Squares Lines — animation review (round 6)

Page: `pages/numerical-methods/least-squares-lines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agreed with my own computation, and every frame I inspected showed what the script computes. I found no implementation error, no mismatch between the page and the GIFs, and no fidelity departure that matters.

Observations that I judged **not** to be findings, with the reason:
- In `lslineaa.gif` (Case 1) the green fit line passes through the start of the coefficient annotation (`annotate!` at (0.35, 10.6), `lslineaa.jl` line 55). It crosses the minus sign of "a = -1.6071" in frames 2 to 7. The text stays legible (see `review/zoom_annot.png`), and the negative slope is plain from the plot. Cosmetic only.
- The Description says "Regressing x on y ... produces a different line after rearrangement, even for the same data." This is not true for exactly collinear data. Case 2 states that exception itself (the k = 2 frame), so a reader is not misled.
- In Case 4 the fitted curve barely moves between frames, because a changes by less than 1%. The page does not claim a visible change, and the annotation shows the change in a.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lslineaa.jl` | 0 | 7.2 | lslineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineab.jl` | 0 | 7.5 | lslineab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineac.jl` | 0 | 6.5 | lslineac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslinead.jl` | 0 | 7.0 | lslinead.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description | "The standard linear model is y = b + a x, where residuals are vertical distances" | aa.jl L44/L49-52 fits and draws y = a x + b with vertical segments; normal equations L19-20 | confirmed |
| D2 | Description | "Regressing x on y instead of y on x produces a different line after rearrangement" | k = 8: y-on-x slope −1.6071, x-on-y rearranged slope −1.6278 (indep.py) | confirmed (exception for collinear data is shown in Case 2) |
| D3 | Description | "y = a x and y = a x^{3/2} remain linear in the unknown coefficient a, so least squares still applies directly" | ac.jl L12 and ad.jl L13 are the one-parameter normal equations Σφy/Σφ² | confirmed |
| I1 | Animations intro | "Each animation below shows how the fitted model changes as data points are added" | aa/ab: k = 2..8; ac: k = 1..8; ad: k = 1..4; coefficients change per frame (instrumented output) | confirmed |
| I2 | intro | "Cases 1, 3 and 4 print the fitted coefficients and the residual sum of squares in each frame" | frames: aa "a=…, b=…, RSS=…"; ac "a=…, RSS=…"; ad "a=…, RSS=…" in every frame (contact sheets) | confirmed |
| I3 | intro | "Cases 1 and 3 also draw each vertical residual as a dark blue segment from the point to the line" | aa.jl L49-52 and ac.jl L35-38 draw `color=:navy` segments from (xᵢ, yᵢ) to (xᵢ, ŷᵢ); visible in frames | confirmed |
| I4 | intro | "the largest residual in any frame is about 0.79 in Case 1" | max \|r\| over all frames = 55/70 = 0.7857 (k = 7, 8) | confirmed |
| I5 | intro | "... and 0.46 in Case 3" | max \|r\| over all frames = 0.4608 (k = 8) | confirmed |
| I6 | intro | "the segments are short and some are barely visible" | frames show segments of 0 to ~0.79 units on an axis about 13 units tall | confirmed |
| C1a | Case 1 heading | "Standard Least-Squares Line, y = b + a x" | aa.jl title "Least Squares Line: y = b + a*x"; unconstrained 2-parameter fit | confirmed |
| C1b | Case 1 | "With all eight points the fit is a = −45/28 ≈ −1.6071 and b = 121/14 ≈ 8.6429" | exact Fraction: a = −45/28, b = 121/14; script a = −1.6071428571428572, b = 8.642857142857142; frame 7 annotation "a = -1.6071, b = 8.6429" | confirmed |
| C1c | Case 1 | "The eighth point (6, −1) lies exactly on the seven-point line" | 121/14 − 6·45/28 = −1 exactly; residual 0 | confirmed |
| C1d | Case 1 | "so the last two frames show the same fit" | k = 7 and k = 8 give the same a, b and RSS (1.3929); frames 6 and 7 show the same line (only the legend's point count and the colour of (6,−1) change) | confirmed |
| C1e | Case 1 alt | "standard least-squares line updating as points are added, with each vertical residual drawn as a short dark blue segment" | frames 1 to 7 | confirmed |
| C1f | Case 1 link/embed | `lslineaa.jl` / `lslineaa.gif` | the script is the standard-line case; the GIF is byte-identical to its regeneration (manifest) | confirmed |
| C2a | Case 2 heading | "Two Regression Lines and Their Intersection" | ab.jl fits y on x and x on y and marks the intersection | confirmed |
| C2b | Case 2 | "With only the first two points, fitting y as a function of x and fitting x as a function of y give the same line, through both points" | k = 2: a = −1, b = 9; c = −1, d = 9, so x = −y + 9 is the same as y = −x + 9; both pass through (−1,10) and (0,9); frame 1 reads "k=2: both lines coincide" | confirmed |
| C2c | Case 2 | "From three points on they give two distinct lines" | k = 3..8 slopes (y-on-x vs rearranged x-on-y): −1.5/−1.5556, −1.7/−1.7353, −1.6/−1.625, −1.4857/−1.5128, −1.6071/−1.6381, −1.6071/−1.6278 | confirmed |
| C2d | Case 2 | "their intersection coincides with the centroid of the points used" | intersection from script equals the centroid to ≤1e-13 for every k = 3..8 (e.g. k = 4: (0.5, 7.75); k = 6: (1.5, 6.3333)); exact formulas agree | confirmed |
| C2e | Case 2 | "which for all eight points is (x̄, ȳ) = (2.5, 4.625)" | exact centroid (5/2, 37/8); frame 7 "(xi, yi)=(2.5, 4.625)"; legacy answer image gives (5/2, 37/8) | confirmed |
| C2f | Case 2 | "These data are strongly correlated, so the two lines nearly overlap" | r = −√(a·c) = −√(1.6071·0.6143) = −0.9936; frames show the lines nearly overlapping | confirmed |
| C2g | Case 2 | "with all eight points their slopes are −1.6071 and −1.6278" | −45/28 = −1.60714; 1/c = −1.62778 | confirmed |
| C2h | Case 2 alt | "intersection (black diamond) drawn on the centroid of the points used (orange star)" | ab.jl L73-77; frames 2 to 7 show the diamond on the star; frame 1 shows no diamond (lines coincide) | confirmed |
| C2i | Case 2 link/embed | `lslineab.jl` / `lslineab.gif` | match; byte-identical regeneration | confirmed |
| C3a | Case 3 heading | "Constrained Fit Through the Origin, y = a x" | ac.jl L12 a = Σxy/Σx²; line through origin | confirmed |
| C3b | Case 3 | "With all eight points of the legacy dataset the fit is a = 157/102 ≈ 1.5392" | exact 157/102 = 1.539216; script 1.5392156862745099; legacy data (1,2)…(8,12) and legacy answer 157/102 = 1.53922 | confirmed |
| C3c | Case 3 | "as points are added the coefficient zig-zags downward from 2" | a_k = 2, 1.6, 1.6429, 1.5667, 1.5818, 1.5495, 1.5571, 1.5392: alternates up and down from k = 2 with a falling trend | confirmed |
| C3d | Case 3 alt | "constrained least-squares fit through the origin ... each vertical residual drawn as a short dark blue segment" | frames 1 to 8 | confirmed |
| C3e | Case 3 link/embed | `lslineac.jl` / `lslineac.gif` | match; byte-identical regeneration | confirmed |
| C4a | Case 4 heading | "Kepler-Style Power Fit, T = a r^{3/2}" | ad.jl L13 a = Σr^{3/2}T / Σr³; title "Power Fit: T = a*r^(3/2)" | confirmed |
| C4b | Case 4 | "the power law is linear in a after choosing basis function r^{3/2}" | as above | confirmed |
| C4c | Case 4 | "Using Mercury, Venus, Earth, and Mars data gives a ≈ 0.19977" | numpy lstsq 0.19976930016; script 0.1997693001603878; frame 4 "a = 0.199769"; legacy answer 0.199769 | confirmed |
| C4d | Case 4 | "Mercury distance of 57.59 million km is about 0.55% below its modern semi-major axis of about 57.91 million km" | 0.387098 AU × 149.5979 = 57.909 Mkm; (57.909−57.59)/57.909 = 0.551% | confirmed |
| C4e | Case 4 | "Mercury's ratio T/r^{3/2} ≈ 0.2013" | 87.99/57.59^1.5 = 0.201332 | confirmed |
| C4f | Case 4 | "the other three planets' 0.1997 to 0.1999" | Venus 0.199896, Earth 0.199680, Mars 0.199756, which round to 0.1997 to 0.1999 | confirmed |
| C4g | Case 4 | "which is why Mercury's ratio ... stands apart" (the cause is the distance) | with the modern r = 57.909 and the modern T = 87.969, Mercury's ratio is 0.199623, the same as the other planets with modern elements (0.19962). With the legacy r and the modern T it is still 0.20128. So the distance accounts for the gap, not the period. | confirmed |
| C4h | Case 4 alt | "power-law least-squares fit T equals a times r to the three-halves for planetary distance and orbital period data" | frames 1 to 4 | confirmed |
| C4i | Case 4 link/embed | `lslinead.jl` / `lslinead.gif` | match; byte-identical regeneration | confirmed |

### 3. Implementation checks

Method used for the independent computation (`review/indep.py`, run with `/usr/bin/python3 -I indep.py`):
- exact rational normal equations with `fractions.Fraction`;
- `numpy.linalg.lstsq` on the design matrix as a second check that does not depend on the closed form;
- residual orthogonality to every basis function, checked exactly.

The script values come from instrumented scratch copies (`julia aa.jl` and so on in the review folder).

### `lslineaa.jl`: standard line y = b + a x
- **Method:** closed-form normal equations for a 2-parameter linear least-squares fit (L13-22). This is the stated method.
- **Numbers:**

| k | script a | script b | script RSS | exact a | exact b | exact RSS |
|---|---|---|---|---|---|---|
| 2 | −1.0 | 9.0 | 0.0 | −1 | 9 | 0 |
| 3 | −1.5 | 8.666667 | 0.166667 | −3/2 | 26/3 | 1/6 |
| 4 | −1.7 | 8.6 | 0.3 | −17/10 | 43/5 | 0.3 |
| 5 | −1.6 | 8.6 | 0.4 | −8/5 | 43/5 | 0.4 |
| 6 | −1.485714 | 8.561905 | 0.704762 | −52/35 | 899/105 | 0.704762 |
| 7 | −1.607143 | 8.642857 | 1.392857 | −45/28 | 121/14 | 1.392857 |
| 8 | −1.607143 | 8.642857 | 1.392857 | −45/28 | 121/14 | 1.392857 |

  The exact residuals satisfy Σr = 0 and Σx·r = 0 for every k (orthogonality holds). The numpy lstsq results agree to 1e-15.
- **Reference values:** none drawn. The data match legacy Example 1, `(-1,10),(0,9),(1,7),(2,5),(3,4),(4,3),(5,0),(6,-1)` (legacy image gr_8).
- **Picture:** the line is drawn from the same a and b. The residual segments run from (xᵢ, yᵢ) to (xᵢ, a xᵢ + b) for the points in use only. The legend count is "first k points". The annotation values match the table above to 4 dp in frames 1, 4 and 7, which I inspected. The axes (−2..7, −2.2..11.3) contain all the data and the line. The only issue is the cosmetic overlap of the line with the annotation noted in §1.

### `lslineab.jl`: y-on-x and x-on-y regressions and their intersection
- **Method:** two separate 2-parameter fits: y = a x + b, and x = c y + d with the roles swapped (L23-32). It then rearranges to y = x/c − d/c and intersects the lines with y = (a d + b)/(1 − a c), x = c y + d. I derived that formula by substitution and it is correct. The guard |1 − ac| > 1e-8 correctly detects coincident lines at k = 2.
- **Numbers:** c and d agree with numpy lstsq on [1, y] → x for every k, for example k = 8: c = −0.6143344709897611 against −0.6143344709897611, d = 5.341296928327646 against 5.341296928327646. The intersection equals the centroid for k = 3..8 to ≤ 1.2e-13. The k = 3 intersection x prints as 8.9e-16 and displays as "0.0".
- **Reference values:** the centroid is computed directly as the mean. It matches the legacy answer (5/2, 37/8).
- **Picture:** green is y on x and blue dashed is the rearranged x on y. The orange star is the centroid of the points in use, and the black diamond is drawn on top of it for k ≥ 3. At k = 2 the frame shows no diamond and the caption "both lines coincide". The caption values match the table to 3 dp. All markers and lines fall inside the axes.

### `lslineac.jl`: y = a x through the origin
- **Method:** a = Σxy/Σx², the one-parameter normal equation. This is the stated method.
- **Numbers:** script a for k = 1..8 is 2.0, 1.6, 1.642857, 1.566667, 1.581818, 1.549451, 1.557143, 1.539216. The exact values are 2, 8/5, 23/14, 47/30, 87/55, 141/91, 109/70 and 157/102, an identical match. The RSS values match: 0, 0.2, 0.214286, 0.366667, 0.381818, 0.527473, 0.542857, 0.686275. Σx·r = 0 exactly for every k.
- **Reference values:** none drawn. The data match legacy Example 4 (image gr_117), and the result matches the legacy 157/102 = 1.53922.
- **Picture:** the magenta line runs through the origin with slope a. The navy segments go to (xᵢ, a xᵢ). The annotation shows a to 5 dp and RSS to 4 dp, matching the values above. The final line reaches 12.31 at x = 8, inside ylim 13.

### `lslinead.jl`: T = a r^{3/2}
- **Method:** a = Σ r^{3/2} T / Σ r³, the one-parameter normal equation with basis r^{3/2}. This is the stated method.
- **Numbers:**

| k | script a | numpy lstsq a | script RSS | numpy RSS |
|---|---|---|---|---|
| 1 | 0.201331949995885 | 0.201331949995885 | 0 | 2e-28 |
| 2 | 0.20008462562538754 | 0.2000846256253875 | 0.342087 | 0.342087 |
| 3 | 0.19980285815564366 | 0.1998028581556437 | 0.507771 | 0.507771 |
| 4 | 0.1997693001603878 | 0.19976930016038782 | 0.515371 | 0.515371 |

  The residual is orthogonal to r^{3/2} (|Σφr| ≤ 2e-10, relative to Σφ² ≈ 2e7).
- **Reference values:** the data match the legacy planet table (images gr_145 and gr_147). The modern Mercury semi-major axis (57.909 Mkm) and the cause of the outlying ratio were checked in C4d and C4g.
- **Picture:** the green curve is a·r^{1.5} with the current a. The planet names are labelled next to the points in use. The annotation matches the table: frame 4 reads "a = 0.199769, RSS = 0.5154". The axes (40..240, 0..750) contain all the data.

### Legacy fidelity
The legacy module has 5 examples:
1. the standard line;
2. the x-on-y line;
3. the intersection of the two lines, compared with the mean point;
4. the "modified least squares line" y = a x;
5. Kepler's T = C x^{3/2}.

The page covers all five: Examples 2 and 3 are merged into Case 2. It uses the same data sets and reproduces the legacy answers: (5/2, 37/8), 157/102 = 1.53922 and 0.199769. Adding the points one at a time is an animation device that the legacy module does not have, and it is consistent with the legacy fits. I found no dropped case and no changed function or data.

