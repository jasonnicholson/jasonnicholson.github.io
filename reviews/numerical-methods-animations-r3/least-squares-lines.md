# Least Squares Lines — animation review (round 3)

Page: `pages/numerical-methods/least-squares-lines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**No findings.**

I found no Error, Misleading, Minor or Fidelity finding. Every numerical, behavioural, diagram, count and wiring claim on the page agrees with my own independent computation and with the frames (see the ledger). Every script runs the method it names and computes correct values.

I looked at one possible issue and decided it does not meet the bar:

- **Cases 1 and 2, annotation placement.** The status text is centred at (0.35, 10.6). From k = 3 onward the fitted line crosses its left end, near "a = -1.6…", and so does the short residual at (-1, 10). Zoomed crops (`review/aa3crop.png`, `review/aa7crop.png`) show that the minus sign and the digits stay legible. This is cosmetic only, so it is not reported.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lslineaa.jl` | 0 | 7.2 | lslineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineab.jl` | 0 | 7.2 | lslineab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineac.jl` | 0 | 7.1 | lslineac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslinead.jl` | 0 | 6.8 | lslinead.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Each claim is quoted in the page's own words where possible.

### Description

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| D1 | "Least squares line fitting chooses parameters that minimize the sum of squared residuals" | This is the definition. All four scripts implement the normal-equation solution of that minimisation, and residuals are orthogonal to the basis (D2, I-checks). | confirmed |
| D2 | "The standard linear model is $y = b + a x$, where residuals are vertical distances from points to the fitted line." | `lslineaa.jl:19-20` gives the closed-form normal equations for y on x. `lslineaa.jl:49-52` draws the residuals as vertical segments (x fixed). | confirmed |
| D3 | "Regressing $x$ on $y$ instead of $y$ on $x$ produces a different line after rearrangement, even for the same data." | The two slopes are equal only when \|r\| = 1. For k ≥ 3 the slopes differ (k = 8: -1.607143 vs -1.627778). The k = 2 exception is stated explicitly in Case 2. | confirmed |
| D4 | "Constrained models such as $y = a x$ and $y = a x^{3/2}$ remain linear in the unknown coefficient $a$, so least squares still applies directly." | The models are linear in a. `lslineac.jl:12` and `lslinead.jl:13` use the one-parameter normal equation a = Σφy/Σφ². | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | "Each animation below shows how the fitted model changes as data points are added." | All four loops run over `k` and fit `x[1:k]`: Case 1 and Case 2 for k = 2..8, Case 3 for k = 1..8, Case 4 for k = 1..4. | confirmed |
| I2 | "Cases 1, 3 and 4 print the fitted coefficients and the residual sum of squares in each frame" | Annotations: `lslineaa.jl:55-56` (a, b, RSS), `lslineac.jl:41-42` (a, RSS), `lslinead.jl:42-43` (a, RSS). The values in every frame match `indep.py` (see I-checks). Case 2 prints the intersection instead, and the page does not claim otherwise. | confirmed |
| I3 | "Cases 1 and 3 also draw each vertical residual as a dark blue segment from the point to the line" | `lslineaa.jl:49-52` and `lslineac.jl:35-38` draw `color=:navy` segments from (x_i, y_i) to (x_i, ŷ_i). The segments are visible in the frames. Cases 2 and 4 draw none. | confirmed |
| I4 | "the largest residual in any frame is about 0.79 in Case 1 and 0.46 in Case 3" | Max \|residual\| over all frames: Case 1 = 0.785714 (= 11/14, at k = 7 and k = 8). Case 3 = 0.460784 (at k = 8). The script and `indep.py` agree. | confirmed |
| I5 | "the segments are short and some are barely visible" | The frames show this. For example, the residuals at (1, 7) and (3, 4) in Case 1 k = 8 are about 0.04 and 0.18. | confirmed |

### Case 1: Standard Least-Squares Line, $y = b + a x$

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading model $y = b + a x$ | `lslineaa.jl` title "Least Squares Line: y = b + a*x". The fit is unconstrained in a and b. | confirmed |
| C1.2 | "The unconstrained fit minimizes vertical residuals to a straight line." | D2 | confirmed |
| C1.3 | "With all eight points the fit is $a = -45/28 \approx -1.6071$ and $b = 121/14 \approx 8.6429$." | Exact rational computation gives a = -45/28 = -1.607143 and b = 121/14 = 8.642857. Script: a = -1.6071428571428572, b = 8.642857142857142. Legacy result image: y = 121/14 - 45x/28. | confirmed |
| C1.4 | "The eighth point $(6, -1)$ lies exactly on the seven-point line" | The k = 7 fit is also -45/28, 121/14, and 121/14 - 6·45/28 = 242/28 - 270/28 = -1 exactly. | confirmed |
| C1.5 | "so the last two frames show the same fit" | k = 7 and k = 8 give identical a, b and RSS (39/28 = 1.392857). Frames 6 and 7 show the same line and the same annotation "a = -1.6071, b = 8.6429, RSS = 1.3929". Only the colour of (6, -1) changes. | confirmed |
| C1.6 | Alt text: "standard least-squares line updating as points are added, with each vertical residual drawn as a short dark blue segment" | Frames 1-7 | confirmed |
| C1.7 | Wiring: `[Julia source](lslineaa.jl)` and `lslineaa.gif` | The script is the y = b + ax case and writes `lslineaa.gif`. The manifest reports the committed GIF is byte-identical to a fresh run. | confirmed |

### Case 2: Two Regression Lines and Their Intersection

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | "With only the first two points, fitting $y$ as a function of $x$ and fitting $x$ as a function of $y$ give the same line, through both points." | k = 2: a = -1, b = 9, c = -1, d = 9, so α = 1/c = -1 and β = 9. Both lines are y = 9 - x through (-1, 10) and (0, 9). Frame 1 is annotated "k=2: both lines coincide". | confirmed |
| C2.2 | "From three points on they give two distinct lines in the $x$-$y$ plane" | Slopes y-on-x vs rearranged x-on-y, for k = 3..8: -1.5/-1.5556, -1.7/-1.7353, -1.6/-1.625, -1.4857/-1.5128, -1.6071/-1.6381, -1.6071/-1.6278. They differ in every frame. | confirmed |
| C2.3 | "their intersection coincides with the centroid of the points used" | Exact rational computation for k = 3..8 gives intersections (0, 26/3), (1/2, 31/4), (1, 7), (3/2, 19/3), (2, 38/7) and (5/2, 37/8). Each equals the exact centroid. The script's float intersections agree to about 1e-13. | confirmed |
| C2.4 | "which for all eight points is $(\bar{x}, \bar{y}) = (2.5, 4.625)$" | 37/8 = 4.625. Legacy Example 3 gives {5/2, 37/8}. | confirmed |
| C2.5 | "These data are strongly correlated, so the two lines nearly overlap" | r² = a·c = 0.987323 at k = 8 (r ≈ -0.9937). The frames show the lines almost on top of each other. | confirmed |
| C2.6 | "with all eight points their slopes are $-1.6071$ and $-1.6278$" | -45/28 = -1.607143. 1/c = -293/180 = -1.627778. Legacy: y = 313/36 - 293x/180 = 8.69444 - 1.62778x. | confirmed |
| C2.7 | Alt text: "intersection (black diamond) drawn on the centroid of the points used (orange star)" | `lslineab.jl:73-78` draws an orange `:star5` at the centroid and then a black `:diamond` at (xi, yi). The zoom `review/ab7star.png` shows the diamond centred inside the star. At k = 2 there is no diamond, which is correct because there is no intersection. | confirmed |
| C2.8 | Heading "Two Regression Lines and Their Intersection" and wiring to `lslineab.jl` / `lslineab.gif` | The script fits y on x and x on y, rearranges x = cy + d to y = x/c - d/c, and computes the intersection by solving y = a(cy + d) + b. The derivation is correct. The GIF is byte-identical to a fresh run. | confirmed |

### Case 3: Constrained Fit Through the Origin, $y = a x$

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C3.1 | Heading model $y = a x$ | `lslineac.jl:12` gives a = Σxy/Σx². The title is "y = a*x" and the line passes through the origin in every frame. | confirmed |
| C3.2 | "produces a single-parameter fit" | There is one coefficient. | confirmed |
| C3.3 | "With all eight points of the legacy dataset the fit is $a = 157/102 \approx 1.5392$" | Exact: Σxy = 471 and Σx² = 204, giving 471/204 = 157/102 = 1.539216. Script: 1.5392156862745099. Legacy: 157/102 = 1.53922. The data match legacy `gr_117`. | confirmed |
| C3.4 | "as points are added the coefficient zig-zags downward from 2" | For k = 1..8, a = 2, 8/5, 23/14, 47/30, 87/55, 141/91, 109/70, 157/102 = 2, 1.6, 1.642857, 1.566667, 1.581818, 1.549451, 1.557143, 1.539216. It alternates down, up, down, up, down, up, down, with a downward trend. | confirmed |
| C3.5 | Alt text: residuals drawn as short dark blue segments | Frames 1-8 | confirmed |
| C3.6 | Wiring: `lslineac.jl` / `lslineac.gif` | Confirmed, and byte-identical to a fresh run. | confirmed |

### Case 4: Kepler-Style Power Fit, $T = a r^{3/2}$

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C4.1 | Heading model $T = a r^{3/2}$ | `lslinead.jl:13` gives a = Σ r^{3/2} T / Σ r³. The title is "T = a*r^(3/2)". | confirmed |
| C4.2 | "With exponent fixed at $3/2$, the power law is linear in $a$ after choosing basis function $r^{3/2}$." | D4 | confirmed |
| C4.3 | "Using Mercury, Venus, Earth, and Mars data gives $a \approx 0.19977$." | `lstsq` gives 0.1997693. The script gives 0.1997693001603878. Legacy gives 0.199769. | confirmed |
| C4.4 | "These are the legacy module's data" | Script data (57.59, 87.99), (108.11, 224.70), (149.57, 365.26), (227.84, 686.98) match legacy images `gr_145` and `gr_147` exactly. | confirmed |
| C4.5 | "its Mercury distance of 57.59 million km is about 0.55% below its modern semi-major axis of about 57.91 million km" | 0.387098 AU × 149.5978707 = 57.909 million km, and 1 - 57.59/57.909 = 0.551%. | confirmed |
| C4.6 | "Mercury's ratio $T/r^{3/2} \approx 0.2013$" | 87.99/57.59^1.5 = 0.201332 | confirmed |
| C4.7 | "the other three planets' $0.1997$ to $0.1999$" | Venus 0.199896, Earth 0.199680, Mars 0.199756. These round to 0.1999, 0.1997 and 0.1998. | confirmed |
| C4.8 | "which is why Mercury's ratio ... stands apart" (causal) | With the modern distance 57.909, the ratio becomes 87.99/57.909^1.5 = 0.199671, in line with the other planets. The distance error alone accounts for the 0.78% excess. | confirmed |
| C4.9 | Alt text: "power-law least-squares fit T equals a times r to the three-halves for planetary distance and orbital period data" | Frames 1-4. The curve is a·r^1.5 with the frame's a, and the planets are labelled as they are added. | confirmed |
| C4.10 | Wiring: `lslinead.jl` / `lslinead.gif` | Confirmed, and byte-identical to a fresh run. | confirmed |

### Counts and structure

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| N1 | Four cases, each with one script and one GIF | There are 4 scripts and 4 GIFs, all linked and embedded (manifest) | confirmed |
| N2 | Implied frame counts (Case 1 "last two frames") | Frames: Case 1 = 7 (k = 2..8), Case 2 = 7, Case 3 = 8 (k = 1..8), Case 4 = 4. These agree with the loops and with the committed GIFs. | confirmed |

### Fidelity to the legacy archive

| # | Legacy item | Page | Verdict |
|---|---|---|---|
| L1 | Ex. 1: y = ax + b, data (-1,10)…(6,-1), result 121/14 - 45x/28, RSS 39/28 | Case 1 has the same data and result. RSS 1.3929 is shown in the final frame. | confirmed |
| L2 | Ex. 2: x = cy + d, result 1565/293 - 180y/293, rearranged to 313/36 - 293x/180 | Case 2: c = -0.614334 = -180/293 and d = 5.341297 = 1565/293. The rearranged slope is -1.6278. | confirmed |
| L3 | Ex. 3: intersection = centroid (5/2, 37/8) | Case 2 | confirmed |
| L4 | Ex. 4: y = ax, data (1,2)…(8,12), a = 157/102 | Case 3 | confirmed |
| L5 | Ex. 5: Kepler T = C x^{3/2}, four planets, a = 0.199769 | Case 4 | confirmed |

No legacy example is dropped. Examples 2 and 3 are merged into Case 2, which shows both the x-on-y line and its intersection. Every function and dataset matches the archive.

---

### 3. Implementation checks

All instrumented runs used scratch copies (`review/inst/*.jl`, each with one added `println`). Nothing was run in the page folder.

### `lslineaa.jl`: standard least-squares line

- **Method.** The closed-form normal equations for y = b + ax are a = (nΣxy - ΣxΣy)/(nΣx² - (Σx)²) and b = (Σy - aΣx)/n. This is ordinary least squares, the method named on the page.
- **Numbers.** Script vs independent exact rational computation:

| k | script a | exact a | script b | exact b | script RSS | exact RSS |
|---|---|---|---|---|---|---|
| 2 | -1.0 | -1 | 9.0 | 9 | 0.0 | 0 |
| 3 | -1.5 | -3/2 | 8.666667 | 26/3 | 0.166667 | 1/6 |
| 4 | -1.7 | -17/10 | 8.6 | 43/5 | 0.3 | 3/10 |
| 5 | -1.6 | -8/5 | 8.6 | 43/5 | 0.4 | 2/5 |
| 6 | -1.485714 | -52/35 | 8.561905 | 899/105 | 0.704762 | 74/105 |
| 7 | -1.607143 | -45/28 | 8.642857 | 121/14 | 1.392857 | 39/28 |
| 8 | -1.607143 | -45/28 | 8.642857 | 121/14 | 1.392857 | 39/28 |

  The residuals are orthogonal to {1, x} in every frame: Σr and Σrx are both below 6e-14, from `numpy.lstsq` residuals. On exact data y = 3x + 2, the script's routine returns (3.0000000000000018, 1.9999999999999942).
- **Reference values.** None are drawn.
- **Picture.** Each frame draws the line a·x + b with that frame's a and b. Residual segments run from (x_i, y_i) to (x_i, a x_i + b) for the points used only. The legend reads "fit with first k points" with the correct k. The annotation values in all 7 frames match the table (contact sheet). The axis limits x ∈ [-2, 7] and y ∈ [-2.2, 11.3] contain all the data. Nothing is clamped or masked.

### `lslineab.jl`: y-on-x and x-on-y regressions

- **Method.** y on x is OLS as above. x on y is OLS with the roles swapped: c = (nΣxy - ΣyΣx)/(nΣy² - (Σy)²) and d = (Σx - cΣy)/n. It is rearranged to y = x/c - d/c. The intersection is solved exactly from y = a(cy + d) + b, which gives y = (ad + b)/(1 - ac) and x = cy + d. Coincident lines are detected by \|1 - ac\| < 1e-8, which is true only at k = 2, where ac = 1.
- **Numbers.** Script vs exact computation and `numpy.lstsq` (x on y):

| k | c script | c exact | d script | d exact | 1/c | intersection (script) | centroid (exact) |
|---|---|---|---|---|---|---|---|
| 2 | -1.0 | -1 | 9.0 | 9 | -1.0 | none (coincide) | (-1/2, 19/2) |
| 3 | -0.642857 | -0.642857 | 5.571429 | 5.571429 | -1.555556 | (8.9e-16, 8.666667) | (0, 26/3) |
| 4 | -0.576271 | -0.576271 | 4.966102 | 4.966102 | -1.735294 | (0.5, 7.75) | (1/2, 31/4) |
| 5 | -0.615385 | -0.615385 | 5.307692 | 5.307692 | -1.625 | (1.0, 7.0) | (1, 7) |
| 6 | -0.661017 | -0.661017 | 5.686441 | 5.686441 | -1.512821 | (1.5, 6.333333) | (3/2, 19/3) |
| 7 | -0.610465 | -0.610465 | 5.313953 | 5.313953 | -1.638095 | (2.0, 5.428571) | (2, 38/7) |
| 8 | -0.614334 | -180/293 | 5.341297 | 1565/293 | -1.627778 | (2.5, 4.625) | (5/2, 37/8) |

  On exact data x = 3y + 2 (y given), `fit_x_on_y` returns (3.0000000000000018, 1.9999999999999942).
- **Reference values.** The centroid is computed directly as the means. It matches the exact centroid.
- **Picture.** The green solid line is y on x and the blue dashed line is the rearranged x on y. The orange star is at the centroid. The black diamond is at the computed intersection and sits visibly inside the star (`review/ab7star.png`). The annotation reports the intersection, rounded to 3 places, matching the table in every frame. At k = 3 it shows "(0.0, 8.667)", which is the rounded 8.9e-16. Frame 1 says "both lines coincide" and shows no diamond. The limits contain all data and all centroids.

### `lslineac.jl`: fit through the origin, y = ax

- **Method.** One-parameter least squares, a = Σxy/Σx². This is the exact minimiser of Σ(y - ax)².
- **Numbers.**

| k | script a | exact a | script RSS | exact RSS | max \|r\| |
|---|---|---|---|---|---|
| 1 | 2.0 | 2 | 0.0 | 0 | 0 |
| 2 | 1.6 | 8/5 | 0.2 | 0.2 | 0.4 |
| 3 | 1.642857 | 23/14 | 0.214286 | 0.214286 | 0.357 |
| 4 | 1.566667 | 47/30 | 0.366667 | 0.366667 | 0.433 |
| 5 | 1.581818 | 87/55 | 0.381818 | 0.381818 | 0.418 |
| 6 | 1.549451 | 141/91 | 0.527473 | 0.527473 | 0.451 |
| 7 | 1.557143 | 109/70 | 0.542857 | 0.542857 | 0.443 |
| 8 | 1.539216 | 157/102 | 0.686275 | 0.686275 | 0.461 |

  The residual is orthogonal to x: Σrx is below 3e-14. On exact data y = 2.5x, the routine returns 2.5000000000000004.
- **Reference values.** None are drawn.
- **Picture.** The line a·x starts at the origin in every frame. Residual segments are drawn from the points to the line. The annotation is a to 5 digits and RSS to 4, and it matches the table in every frame. The limits [0, 9] × [0, 13] contain all data.

### `lslinead.jl`: Kepler power fit, T = a r^{3/2}

- **Method.** One-parameter least squares on the basis function φ = r^{3/2}, a = Σφ T / Σφ². This is the exact minimiser of Σ(T - aφ)², the same as Mathews' PowerCurve with m = 3/2.
- **Numbers.**

| k | script a | `numpy.lstsq` a | script RSS | lstsq RSS |
|---|---|---|---|---|
| 1 | 0.20133195 | 0.2013319 | 0.0 | 0.0000 |
| 2 | 0.20008463 | 0.2000846 | 0.342087 | 0.3421 |
| 3 | 0.19980286 | 0.1998029 | 0.507771 | 0.5078 |
| 4 | 0.19976930 | 0.1997693 | 0.515371 | 0.5154 |

  The residual is orthogonal to φ: \|Σrφ\| is below 2e-10, against Σφ² of about 2.5e7. On exact data T = 0.2 r^1.5, the routine returns 0.20000000000000004.
- **Reference values.** The modern Mercury semi-major axis of 57.909 million km (0.387098 AU) supports the page's 0.55% statement. It is not drawn.
- **Picture.** The curve a·r^1.5 uses the frame's a. The planets used are red and labelled. The annotation a to 6 digits matches the table. The limits [40, 240] × [0, 750] contain all data. There are 4 frames, one per planet.

---

### Summary

- Findings: 0 Error, 0 Misleading, 0 Minor (including Fidelity: none).
- Claim ledger: 47 entries, all confirmed, none wrong, none undetermined.
- I consulted the legacy archive. Every example function and dataset matches it, and no example is dropped.

