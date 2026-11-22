# Least Squares Lines — animation review (round 4)

Page: `pages/numerical-methods/least-squares-lines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

The cosmetic items I noticed are not findings because none of them misleads a reader:
- In Case 1 the coefficient annotation slightly overlaps the green line near the top-left, but the text stays legible.
- In Case 4 the residuals are too small to see at the plot's scale. The page does not claim that Case 4 draws them.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lslineaa.jl` | 0 | 6.4 | lslineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineab.jl` | 0 | 7.2 | lslineab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineac.jl` | 0 | 6.6 | lslineac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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
| D1 | Description | "The standard linear model is $y = b + a x$, where residuals are vertical distances" | `lslineaa.jl` L19-20 solves the normal equations for `y = a*x + b`. The residual is `yv - (a*xv+b)` (L54), which is vertical. | confirmed |
| D2 | Description | "Regressing $x$ on $y$ instead of $y$ on $x$ produces a different line after rearrangement, even for the same data." | All 8 points: y-on-x slope -1.607143. x-on-y rearranged slope 1/c = -1.627778. The lines differ for every k ≥ 3. They coincide only for exactly collinear data (k=2), and the page says so in Case 2. | confirmed |
| D3 | Description | "$y = a x$ and $y = a x^{3/2}$ remain linear in the unknown coefficient $a$, so least squares still applies directly." | `lslineac.jl` L12 uses a = Σxy/Σx². `lslinead.jl` L13 uses a = Σr^{1.5}T/Σr³. Both are the one-parameter normal equations. The residuals are orthogonal to the basis (exact 0 for Case 3; ≤1.5e-10 for Case 4). | confirmed |
| A1 | Animations intro | "Each animation below shows how the fitted model changes as data points are added." | Case 1 runs k=2..8, Case 2 runs k=2..8, Case 3 runs k=1..8 and Case 4 runs k=1..4, with each frame refitting on `x[1:k]`. The frames show this. | confirmed |
| A2 | Animations intro | "Cases 1, 3 and 4 print the fitted coefficients and the residual sum of squares in each frame" | Seen in the frames: Case 1 shows "a=…, b=…, RSS=…", Case 3 shows "a=…, RSS=…" and Case 4 shows "a=…, RSS=…". Case 2 prints the intersection instead. | confirmed |
| A3 | Animations intro | "Cases 1 and 3 also draw each vertical residual as a dark blue segment from the point to the line" | `lslineaa.jl` L49-52 and `lslineac.jl` L35-38 draw `[xv[i],xv[i]]`×`[yv[i],yh]` in `:navy`. The segments are visible in the frames. | confirmed |
| A4 | Animations intro | "the largest residual in any frame is about 0.79 in Case 1 and 0.46 in Case 3" | Exact max \|residual\| over all frames is 0.785714 (11/14) for Case 1 at k=7,8 and 0.460784 for Case 3 at k=8. | confirmed |
| C1a | Case 1 heading | "Standard Least-Squares Line, $y = b + a x$" | Script, GIF title and wiring all match. | confirmed |
| C1b | Case 1 | "With all eight points the fit is $a = -45/28 \approx -1.6071$ and $b = 121/14 \approx 8.6429$." | Exact: a=-45/28=-1.607143, b=121/14=8.642857. The script gives -1.6071428571428572 and 8.642857142857142, and the frame shows "a = -1.6071, b = 8.6429". The legacy image gr_18/gr_46 gives the same values. | confirmed |
| C1c | Case 1 | "The eighth point $(6, -1)$ lies exactly on the seven-point line, so the last two frames show the same fit." | -45/28·6+121/14 = -1 exactly (residual 0.0). Fits at k=7 and k=8 are identical (a, b and RSS=1.392857 equal). Frames 6 and 7 show the same line. | confirmed |
| C1d | Case 1 alt text | "standard least-squares line updating as points are added, with each vertical residual drawn as a short dark blue segment" | Frames 1-7. | confirmed |
| C1e | Case 1 wiring | Link `lslineaa.jl`, embed `lslineaa.gif` | The script is the y=b+ax case, and its output is MD5-identical to the committed GIF. | confirmed |
| C2a | Case 2 | "With only the first two points, fitting $y$ as a function of $x$ and fitting $x$ as a function of $y$ give the same line, through both points." | k=2: a=-1, b=9; c=-1, d=9 → rearranged y = -x + 9; a·c = 1. Frame 1 is labelled "k=2: both lines coincide". | confirmed |
| C2b | Case 2 | "From three points on they give two distinct lines" | a·c = 0.9643, 0.9797, 0.9846, 0.9821, 0.9811 and 0.9873 for k=3..8, all ≠ 1. The slopes differ at every k ≥ 3, for example -1.5 vs -1.5556 at k=3. | confirmed |
| C2c | Case 2 | "their intersection coincides with the centroid of the points used" | Exact intersection equals the exact centroid for every k=3..8: (0, 26/3), (0.5, 7.75), (1, 7), (1.5, 19/3), (2, 38/7) and (2.5, 37/8). The script's floating values agree to within 1e-13. The frames show the diamond on the star. | confirmed |
| C2d | Case 2 | "which for all eight points is $(\bar{x}, \bar{y}) = (2.5, 4.625)$" | Centroid is (5/2, 37/8). The frame shows "(2.5, 4.625)". Legacy gr_103 and gr_107 give the same. | confirmed |
| C2e | Case 2 | "with all eight points their slopes are $-1.6071$ and $-1.6278$" | -45/28 = -1.607143. 1/c = -293/180 = -1.627778. Legacy gr_89 gives y = 313/36 - 293x/180. | confirmed |
| C2f | Case 2 | "These data are strongly correlated, so the two lines nearly overlap" | r² = a·c = 0.9873 for all 8 points. Frame 7 shows the lines visually overlapping. | confirmed |
| C2g | Case 2 alt text | "intersection (black diamond) drawn on the centroid of the points used (orange star)" | `lslineab.jl` L73-77 uses an orange `:star5` and a black `:diamond`. Frames 2-7 match. | confirmed |
| C2h | Case 2 wiring | `lslineab.jl` / `lslineab.gif` | Output is MD5-identical to the committed GIF. | confirmed |
| C3a | Case 3 heading | "Constrained Fit Through the Origin, $y = a x$" | `lslineac.jl` L12 and L32 fit and plot a·x. | confirmed |
| C3b | Case 3 | "With all eight points of the legacy dataset the fit is $a = 157/102 \approx 1.5392$" | Exact 157/102 = 1.539216. The script gives 1.5392156862745099. The data (1,2)…(8,12) match legacy gr_117, and legacy gr_132 gives 157/102. | confirmed |
| C3c | Case 3 | "as points are added the coefficient zig-zags downward from 2" | a_k = 2, 1.6, 1.642857, 1.566667, 1.581818, 1.549451, 1.557143 and 1.539216. The sequence alternates direction after k=2 and trends down from 2. | confirmed |
| C3d | Case 3 alt text | "constrained least-squares fit through the origin … with each vertical residual drawn as a short dark blue segment" | Frames 1-8. | confirmed |
| C3e | Case 3 wiring | `lslineac.jl` / `lslineac.gif` | Output is MD5-identical to the committed GIF. | confirmed |
| C4a | Case 4 heading | "Kepler-Style Power Fit, $T = a r^{3/2}$" | `lslinead.jl` L13 and L34. The GIF title reads "T = a*r^(3/2)". | confirmed |
| C4b | Case 4 | "Using Mercury, Venus, Earth, and Mars data gives $a \approx 0.19977$." | numpy lstsq gives a = 0.19976930. The script gives 0.1997693001603878. Legacy gr_151 gives 0.199769. | confirmed |
| C4c | Case 4 | "These are the legacy module's data" | The script data match legacy gr_147 exactly. | confirmed |
| C4d | Case 4 | "its Mercury distance of 57.59 million km is about 0.55% below its modern semi-major axis of about 57.91 million km" | 0.387098 AU × 149.5979 = 57.909 Mkm. 57.59/57.909 − 1 = −0.551%. | confirmed |
| C4e | Case 4 | "Mercury's ratio $T/r^{3/2} \approx 0.2013$ stands apart from the other three planets' $0.1997$ to $0.1999$" | Ratios are 0.201332, 0.199896, 0.199680 and 0.199756, so the other three span 0.1997-0.1999. With the modern distance, Mercury's ratio would be 0.19967, which supports "which is why". | confirmed |
| C4f | Case 4 alt text | "power-law least-squares fit T equals a times r to the three-halves for planetary distance and orbital period data" | Frames 1-4. | confirmed |
| C4g | Case 4 wiring | `lslinead.jl` / `lslinead.gif` | Output is MD5-identical to the committed GIF. | confirmed |
| N1 | Counts | (implicit) frame counts | Case 1 has 7 frames, Case 2 has 7, Case 3 has 8 and Case 4 has 4, matching the loop ranges. The page states no counts beyond "last two frames" (C1c). | confirmed |

### 3. Implementation checks

### `lslineaa.jl` (standard line)
- **Method:** It solves the 2×2 normal equations in closed form: a = (nΣxy − ΣxΣy)/(nΣx² − (Σx)²), b = (Σy − aΣx)/n. This is the standard least-squares line.
- **Numbers:** The script's values and exact rationals agree for every frame:

| k | script a | script b | script RSS | exact a | exact b | exact RSS |
|---|---|---|---|---|---|---|
| 2 | -1.0 | 9.0 | 0.0 | -1 | 9 | 0 |
| 3 | -1.5 | 8.666667 | 0.166667 | -3/2 | 26/3 | 1/6 |
| 4 | -1.7 | 8.6 | 0.3 | -17/10 | 43/5 | 0.3 |
| 5 | -1.6 | 8.6 | 0.4 | -8/5 | 43/5 | 0.4 |
| 6 | -1.485714 | 8.561905 | 0.704762 | -52/35 | 899/105 | 0.704762 |
| 7 | -1.607143 | 8.642857 | 1.392857 | -45/28 | 121/14 | 1.392857 |
| 8 | -1.607143 | 8.642857 | 1.392857 | -45/28 | 121/14 | 1.392857 |

  At every k, Σr = 0 and Σr·x = 0 exactly, which is residual orthogonality. numpy lstsq agrees to 6 decimals.
- **Reference values:** There is no separate reference curve. The data are the legacy Example 1 data (gr_8).
- **Picture:** The line is drawn from the fitted a and b. Residual segments run from (xᵢ, yᵢ) to (xᵢ, a·xᵢ+b). The annotation's rounded values match the table. The axis limits (-2..7, -2.2..11.3) contain all the data. I viewed the contact sheet and frame 7.

### `lslineab.jl` (y-on-x vs x-on-y)
- **Method:** It runs the y-on-x fit as above, plus the symmetric x-on-y fit x = c·y + d with c = (nΣxy − ΣxΣy)/(nΣy² − (Σy)²). It rearranges to y = x/c − d/c. The intersection is solved in closed form as yi = (a·d + b)/(1 − a·c) and xi = c·yi + d. I checked algebraically that substituting x = c·y + d into y = a·x + b gives this.
- **Numbers:** c at k=8 is -0.614334 and d is 5.341297, matching the exact -180/293 and 1565/293 (legacy gr_86). The intersection equals the centroid for every k (see C2c), with a floating error ≤ 1.2e-13. At k=2, a·c = 1.0 exactly in floating point, so the coincidence branch fires.
- **Reference values:** The centroid is computed directly as the mean of the points used.
- **Picture:** The green solid line is y-on-x and the blue dashed line is x-on-y rearranged. The star marks the centroid and the diamond the intersection. The intersection marker is omitted at k=2, which is correct. The annotation shows (xi, yi) rounded to 3 decimals, and at k=3 it shows xi = 8.9e-16 as "0.0". I viewed the contact sheet and frame 7.

### `lslineac.jl` (y = a x)
- **Method:** The one-parameter least-squares fit is a = Σxy/Σx². This is correct for the model y = a·x.
- **Numbers:** The script's a_k and the exact a_k agree for every k (see C3c). RSS for k=1..8 is 0, 0.2, 0.214286, 0.366667, 0.381818, 0.527473, 0.542857 and 0.686275 in both computations. The residual is orthogonal to x exactly (0) at every k.
- **Reference values:** None. The data are the legacy Example 4 data (gr_117/119).
- **Picture:** The line passes through the origin with slope a, and the residual segments are correct. The annotation matches. I viewed the contact sheet.

### `lslinead.jl` (T = a r^{3/2})
- **Method:** It fits the one-parameter basis φ = r^{1.5} with a = Σφ·T/Σφ². This is the least-squares fit for T = a·r^{3/2} and matches Mathews' PowerCurve with m = 3/2.
- **Numbers:**

| k | script a | numpy lstsq a | script RSS | numpy RSS |
|---|---|---|---|---|
| 1 | 0.201331950 | 0.20133195 | 0.0 | 0 |
| 2 | 0.200084626 | 0.20008463 | 0.342087 | 0.342087 |
| 3 | 0.199802858 | 0.19980286 | 0.507771 | 0.507771 |
| 4 | 0.199769300 | 0.19976930 | 0.515371 | 0.515371 |

  Residual·φ is ≤ 1.5e-10, which is zero relative to the scale of the data.
- **Reference values:** For the modern Mercury semi-major axis I used 0.387098 AU × 149.597871 Mkm/AU = 57.909 Mkm, which supports the page's 57.91 and 0.55%.
- **Picture:** The curve is a·r^{1.5} over r ∈ [40, 240], and every point lies inside the window. The planet labels are attached to the correct points. The annotation matches the table. I viewed the contact sheet and frame 4.

### Fidelity to the legacy archive
The legacy module has five examples, and the page covers all of them:
- Example 1 (standard line) is Case 1.
- Examples 2 and 3 (x-on-y line, then the intersection at the centroid) are combined in Case 2.
- Example 4 (y = a x) is Case 3.
- Example 5 (Kepler, y = a x^{3/2}) is Case 4.

The data and final results agree with the archive's formula images: gr_8, 18, 46, 81, 89, 103, 107, 117, 132, 147 and 151. Adding the points one at a time is the page's own device for animating the fits, and the page states it. No case is dropped and no example function was changed, so there is no Fidelity finding.

