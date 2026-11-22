# Least Squares Lines — animation review (round 2)

Page: `pages/numerical-methods/least-squares-lines/`. Reported findings: **0 Error, 1 Misleading, 1 Minor**.

## Findings

### F1. Page match / Misleading: the "vertical residuals" the page points readers to are mostly hidden under the data markers (Case 3 almost completely)

**Location.**
- `index.qmd` line 22: "Cases 1, 3 and 4 print the fitted coefficients and the residual sum of squares in each frame, and Cases 1 and 3 also draw the vertical residuals, so you can see what the least-squares criterion is doing geometrically."
- `index.qmd` line 30 (Case 1 alt text): "...with residual segments drawn vertically to the line."
- `index.qmd` line 46 (Case 3 alt text): "...with residuals updating as points are added."
- Drawing code: `lslineaa.jl` lines 49-52 and `lslineac.jl` lines 35-38 (steelblue, `lw=1.2`), drawn under red markers of `ms=6` (`lslineaa.jl` line 42, `lslineac.jl` line 31).

**What is there now.** The segments are drawn, but the residuals are small compared with the markers. The red markers are about 12 px across, which is about ±0.25 data units at these axis scales (13 to 13.5 y-units over roughly 330 px). The 1-px-wide segments start at the marker centre, so any residual under about 0.25 is entirely covered and larger ones show only as a short stub.

Exact residuals (`indep.py` and a numpy one-liner):
- Case 1, k = 8: −0.25, 0.357, −0.036, −0.429, 0.179, **0.786**, **−0.607**, 0. Frames k = 2..5 have no residual above 0.4 in magnitude.
- Case 3, k = 8: 0.461, −0.078, 0.382, −0.157, 0.304, −0.235, 0.225, −0.314. No residual in any Case 3 frame exceeds 0.461.

Pixel count of steelblue pixels in each committed frame (RGB within ±30 of (70,130,180)), with the length per segment column:
- `lslineaa` (Case 1): frames 1-7 have 0, 2, 7, 18, 29, 53, 53 px. The longest stubs are 15 to 20 px, only at x = 4 and x = 5 in the last frames.
- `lslineac` (Case 3): frames 1-8 have 0, 1, 3, 17, 21, 33, 32, 31 px. No single stub is longer than 10 px.

You can see this at native size in `committed/lslineac/frame_008.png`, where the residuals are not discernible, and in the 3x crop `review/zoom_c3.png`, where they show as stubs a few pixels long. In Case 1 (`review/zoom_c1.png`), only the x = 4 and x = 5 residuals are readable, in frames 5-7.

**What is true instead.** In Case 3 a viewer at normal size sees essentially no residuals. In Case 1 they see two or three short ticks in the last frames only. The sentence "so you can see what the least-squares criterion is doing geometrically" is not borne out by the animation, and neither alt text describes what a viewer actually sees.

**Suggested correction.** Either make the residuals visible or stop promising them. To make them visible, draw the segments after the markers or use smaller markers (`ms=4`), and use a thicker, contrasting stroke (`lw=2`, a darker colour). Optionally also tighten the y-range or enlarge the figure. Otherwise, reword line 22 and the two alt texts so they do not present the residuals as a visible feature.

- **Independent check:** confirmed with correction: the visible effect is as alleged (residuals are mostly not discernible; in Case 3 almost entirely invisible, in Case 1 only a few stubs late on), but the mechanism differs: the residual segments are drawn on top of the red markers (plot! after scatter!), and only the part beyond the ~6.5 px (~0.25 unit) marker radius is visible. Case 1 scope: x=2 and x=4 stubs in frame 5; x=4 and x=5 (and a faint x=2) in frames 6–7.

### F2. Page match / Minor: Case 3 "settles near" is not supported by the computed sequence

**Location.** `index.qmd` line 42: "The coefficient settles near $a \approx 1.5392$ for the legacy dataset."

**What is there now / what is true.** The value 1.5392 is correct: the exact value is 157/102 = 1.539216, and the legacy archive gives 1.53922. But the sequence of fits over the eight frames does not settle. Both `indep.py` and the instrumented `inst/lslineac.jl` give:

| k | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|
| a | 2 | 1.6 | 1.64286 | 1.56667 | 1.58182 | 1.54945 | 1.55714 | 1.53922 |
| change | | −0.400 | +0.043 | −0.076 | +0.015 | −0.032 | +0.008 | −0.018 |

The fit still zig-zags downward at the last frame, and the final step (−0.018) is more than twice the size of the step before it. The page presents 1.5392 as a limit the animation converges to, but it is simply the eight-point value. The drift is expected: the data lie near a line with a positive intercept, so the through-origin slope keeps falling as larger x values are added.

**Suggested correction.** Replace "settles near" with a plain statement: "With all eight points the fit is $a = 157/102 \approx 1.5392$; as points are added the coefficient zig-zags downward from 2."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lslineaa.jl` | 0 | 5.5 | lslineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineab.jl` | 0 | 5.8 | lslineab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineac.jl` | 0 | 6.1 | lslineac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslinead.jl` | 0 | 5.7 | lslinead.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Abbreviations: "indep" = `review/indep.py` (exact rationals plus lstsq); "inst" = instrumented script output; "frames" = committed frames.

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Least squares chooses parameters that "minimize the sum of squared residuals" | All four scripts solve the normal equations. For every k, indep shows the residual is exactly orthogonal to each basis function (Σr = 0 and Σr·x = 0 for Cases 1/2; Σr·x = 0 for Case 3; Σr·r^{3/2} ≈ 1e-10 relative for Case 4) | confirmed |
| D2 | "standard linear model is $y = b + a x$, where residuals are vertical distances" | `lslineaa.jl` fits `a*x + b` and draws residuals from (x_i, y_i) to (x_i, a x_i + b) | confirmed |
| D3 | "Regressing x on y instead of y on x produces a different line after rearrangement, even for the same data" | Case 2: slopes differ for every k ≥ 3 (a·c = 27/28, 289/295, 64/65, 2028/2065, 675/688, 2025/2051, all ≠ 1). They coincide only when the data are exactly collinear (k = 2), which the page itself notes in Case 2 | confirmed |
| D4 | "$y = a x$ and $y = a x^{3/2}$ remain linear in the unknown coefficient a, so least squares still applies directly" | `lslineac.jl` uses a = Σxy/Σx², `lslinead.jl` uses a = Σx^{1.5}y/Σx³. These are the one-parameter normal equations (also the archive's PowerCurve formula a = Σx^m y / Σx^{2m}) | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | "Each animation below shows how the fitted model changes as data points are added" | Loops over k = 2..8, 2..8, 1..8, 1..4; frames show points added one at a time | confirmed |
| I2 | "Cases 1, 3 and 4 print the fitted coefficients and the residual sum of squares in each frame" | frames: Case 1 "a=…, b=…, RSS=…", Case 3 "a=…, RSS=…", Case 4 "a=…, RSS=…" in every frame; Case 2 prints the intersection instead | confirmed |
| I3 | "Cases 1 and 3 also draw the vertical residuals" | Code draws them (aa 49-52, ac 35-38); Case 4 draws none | confirmed (literally) |
| I4 | "…so you can see what the least-squares criterion is doing geometrically" | Residuals are mostly hidden under markers, Case 3 almost entirely (F1) | **wrong** (F1) |

### Case 1

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading: Standard least-squares line, $y = b + a x$ | `fit_unconstrained` is the standard closed form; matches lstsq at every k | confirmed |
| C1.2 | "The unconstrained fit minimizes vertical residuals to a straight line" | Normal equations in y; residual ⟂ {1, x} exactly | confirmed |
| C1.3 | "$a = -45/28 \approx -1.6071$" | indep −45/28 = −1.607143; inst −1.6071428571428572; archive −45/28 | confirmed |
| C1.4 | "$b = 121/14 \approx 8.6429$" | indep 121/14 = 8.642857; inst 8.642857142857142; archive 121/14 | confirmed |
| C1.5 | "The eighth point (6, −1) lies exactly on the seven-point line" | indep: seven-point line at x = 6 gives −45/28·6 + 121/14 = −1 exactly | confirmed |
| C1.6 | "…so the last two frames show the same fit" | inst k=7 and k=8 identical a, b, RSS (1.3929 = 39/28, archive 39/28); frames 6 and 7 show the same line and annotation | confirmed |
| C1.7 | Alt: "standard least-squares line updating as points are added" | frames 1-7 | confirmed |
| C1.8 | Alt: "with residual segments drawn vertically to the line" | Drawn, but mostly hidden (F1) | wrong as a description of what is visible (F1) |
| C1.9 | Wiring: link `lslineaa.jl`, embed `lslineaa.gif` | Script header says "standard unconstrained…y = b + a*x"; GIF byte-identical to its output | confirmed |

### Case 2

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | "With only the first two points, fitting y on x and x on y give the same line, through both points" | indep k=2: a = −1, c = −1, a·c = 1; both lines are y = 9 − x through (−1,10),(0,9). Frame 1 annotation "k=2: both lines coincide" | confirmed |
| C2.2 | "From three points on they give two distinct lines" | a·c < 1 for every k = 3..8 (values in D3) | confirmed |
| C2.3 | "their intersection coincides with the centroid of the points used" | indep exact: k=3 (0, 26/3), k=4 (1/2, 31/4), k=5 (1, 7), k=6 (3/2, 19/3), k=7 (2, 38/7), k=8 (5/2, 37/8). Intersection equals centroid exactly in each. inst agrees to ~1e-13. Archive Example 3 gives (5/2, 37/8) for both | confirmed |
| C2.4 | "for all eight points is $(\bar x, \bar y) = (2.5, 4.625)$" | 5/2, 37/8 | confirmed |
| C2.5 | "These data are strongly correlated, so the two lines nearly overlap" | r² = a·c = 2025/2051 = 0.98732, r = −0.9936; frames show lines nearly overlapping | confirmed |
| C2.6 | "with all eight points their slopes are −1.6071 and −1.6278" | y on x −45/28 = −1.607143; x on y rearranged 1/c = −293/180 = −1.627778 (archive: y = 313/36 − 293x/180 = 8.69444 − 1.62778x); inst alpha = −1.6277777777777778 | confirmed |
| C2.7 | Alt: "intersection (black diamond) drawn on the centroid of the points used (orange star)" | Code: star ms=11 then diamond ms=4 at (xi, yi). Frames 2-7 show the diamond centred on the star; frame 1 shows only the star (correctly, no intersection) | confirmed |
| C2.8 | Frame annotations "(xi, yi)" | Frames: (0.0, 8.667), (0.5, 7.75), (1.0, 7.0), (1.5, 6.333), (2.0, 5.429), (2.5, 4.625), each equal to the exact centroid rounded to 3 decimals | confirmed |
| C2.9 | Wiring: `lslineab.jl` / `lslineab.gif` | Script header "compare y-on-x and x-on-y regressions plus intersection"; GIF byte-identical | confirmed |

### Case 3

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C3.1 | Heading: constrained fit through the origin, $y = a x$ | `fit_through_origin` = Σxy/Σx²; residual ⟂ x exactly (indep orth = 0 for every k) | confirmed |
| C3.2 | "produces a single-parameter fit" | One coefficient | confirmed |
| C3.3 | "$a \approx 1.5392$ for the legacy dataset" | indep 157/102 = 1.539216; inst 1.5392156862745099; archive 157/102 = 1.53922; data match archive (1,2),(2,3),(3,5),(4,6),(5,8),(6,9),(7,11),(8,12) | confirmed |
| C3.4 | "The coefficient settles near…" | Sequence 2, 1.6, 1.643, 1.567, 1.582, 1.549, 1.557, 1.539, still moving by −0.018 at the last frame | **wrong** (F2) |
| C3.5 | Alt: "constrained least-squares fit through the origin… with residuals updating as points are added" | Fit line through the origin: confirmed in frames. Residuals: practically invisible (F1) | partly wrong (F1) |
| C3.6 | Frame annotations a, RSS | Frames: 2.0/0.0, 1.6/0.2, 1.64286/0.2143, 1.56667/0.3667, 1.58182/0.3818, 1.54945/0.5275, 1.55714/0.5429, 1.53922/0.6863. All match indep exact values (RSS = 0, 1/5, 3/14, 11/30, …) | confirmed |
| C3.7 | Wiring: `lslineac.jl` / `lslineac.gif` | header "constrained fit through origin y = a*x"; GIF byte-identical | confirmed |

### Case 4

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C4.1 | Heading: $T = a r^{3/2}$ | `lslinead.jl` fits a·x^1.5; plot title "Power Fit: T = a*r^(3/2)" | confirmed |
| C4.2 | "With exponent fixed at 3/2, the power law is linear in a after choosing basis function $r^{3/2}$" | Formula a = Σφ T / Σφ², φ = r^{1.5}; equals lstsq with the single column φ | confirmed |
| C4.3 | "Using Mercury, Venus, Earth, and Mars data" | x = 57.59, 108.11, 149.57, 227.84; y = 87.99, 224.70, 365.26, 686.98, identical to archive image `gr_145` | confirmed |
| C4.4 | "$a \approx 0.19977$" | lstsq 0.19976930016; inst 0.1997693001603878; archive 0.199769 | confirmed |
| C4.5 | "These are the legacy module's data" | archive images `gr_145`/`gr_147` | confirmed |
| C4.6 | "Mercury distance of 57.59 million km is about 0.55% below its modern semi-major axis of about 57.91 million km" | Modern a(Mercury) = 0.387098 AU × 149.598 = 57.909 million km (standard value; not re-derived from a primary source here). (57.909 − 57.59)/57.909 = 0.551% | confirmed |
| C4.7 | "Mercury's ratio $T/r^{3/2} \approx 0.2013$" | 87.99/57.59^1.5 = 0.201332 | confirmed |
| C4.8 | "…the other three planets' 0.1997 to 0.1999" | Venus 0.199896, Earth 0.199680, Mars 0.199756, which round to 0.1999, 0.1997 and 0.1998 | confirmed |
| C4.9 | "…which is why Mercury's ratio stands apart" | With r = 57.909 the ratio is 87.99/57.909^1.5 = 0.199671, inside the other planets' band, so the distance discrepancy accounts for it | confirmed |
| C4.10 | Alt: "power-law least-squares fit T equals a times r to the three-halves for planetary distance and orbital period data" | frames 1-4 | confirmed |
| C4.11 | Frame annotations | a = 0.201332, 0.200085, 0.199803, 0.199769; RSS = 0.0, 0.3421, 0.5078, 0.5154. Match lstsq (0.2013319, 0.2000846, 0.1998029, 0.1997693; RSS 0, 0.3421, 0.5078, 0.5154) | confirmed |
| C4.12 | Wiring: `lslinead.jl` / `lslinead.gif` | header "Kepler-style constrained power law"; GIF byte-identical | confirmed |

---

### 3. Implementation checks

### `lslineaa.jl`: standard least-squares line

- **Method.** The closed-form solution of the 2x2 normal equations, a = (nΣxy − ΣxΣy)/(nΣx² − (Σx)²) and b = (Σy − aΣx)/n. This is ordinary least squares for y = b + ax, the same formula as the archive theorem (`gr_4`/`gr_5`, written with the opposite sign convention).
- **Numbers.**

  | k | script a | indep a | script b | indep b | script RSS | indep RSS |
  |---|---|---|---|---|---|---|
  | 2 | −1.0 | −1 | 9.0 | 9 | 0.0 | 0 |
  | 3 | −1.5 | −3/2 | 8.666667 | 26/3 | 0.166667 | 1/6 |
  | 4 | −1.7 | −17/10 | 8.6 | 43/5 | 0.3 | 3/10 |
  | 5 | −1.6 | −8/5 | 8.6 | 43/5 | 0.4 | 2/5 |
  | 6 | −1.485714 | −52/35 | 8.561905 | 899/105 | 0.704762 | 74/105 |
  | 7 | −1.607143 | −45/28 | 8.642857 | 121/14 | 1.392857 | 39/28 |
  | 8 | −1.607143 | −45/28 | 8.642857 | 121/14 | 1.392857 | 39/28 |

  The residual is exactly orthogonal to {1, x} for every k, and numpy lstsq agrees.
- **Reference values.** None are drawn. The archive's 8-point values (−45/28, 121/14, RSS 39/28) match.
- **Picture.** The green line is a·x + b over [−2, 7]. Red markers are the first k points and grey markers are all the data. The legend "fit with first k points" carries the right k (2..8 across frames 1..7). Residual segments run from (x_i, y_i) to (x_i, a x_i + b), which is geometrically correct but mostly hidden (F1). The annotation numbers match the table. The fitted line passes through the left end of the annotation text and overprints the minus sign of "a = −…" in frames 2-7 (`review/zoom_annot.png`). The sign is still legible and the slope's sign is obvious from the line, so I did not count this as a finding.

### `lslineab.jl`: y-on-x vs x-on-y regressions

- **Method.** `fit_y_on_x` is the same OLS as above. `fit_x_on_y` is OLS with the roles swapped (x = c y + d), and it is drawn as y = x/c − d/c. The intersection formula is derived from y = a x + b and x = c y + d: y(1 − ac) = ad + b. This is correct. Coincidence is detected by |1 − ac| ≤ 1e-8, which fires only at k = 2 (ac = 1.0 exactly in floating point there; the smallest other value of 1 − ac is 0.0127).
- **Numbers.**

  | k | script c | indep c | script 1/c | indep 1/c | script (xi, yi) | indep intersection = centroid |
  |---|---|---|---|---|---|---|
  | 2 | −1.0 | −1 | −1.0 | −1 | coincide | lines identical |
  | 3 | −0.642857 | −9/14 | −1.555556 | −14/9 | (8.9e-16, 8.666667) | (0, 26/3) |
  | 4 | −0.576271 | −34/59 | −1.735294 | −59/34 | (0.5, 7.75) | (1/2, 31/4) |
  | 5 | −0.615385 | −8/13 | −1.625 | −13/8 | (1.0, 7.0) | (1, 7) |
  | 6 | −0.661017 | −39/59 | −1.512821 | −59/39 | (1.5, 6.333333) | (3/2, 19/3) |
  | 7 | −0.610465 | −105/172 | −1.638095 | −172/105 | (2.0, 5.428571) | (2, 38/7) |
  | 8 | −0.614334 | −180/293 | −1.627778 | −293/180 | (2.5, 4.625) | (5/2, 37/8) |

  At k = 8 the archive's x = 1565/293 − 180y/293 gives c = −180/293 and d = 1565/293 = 5.341297. inst gives d = 5.341296928327646.
- **Reference values.** The centroid is a plain mean, and it agrees with the exact values.
- **Picture.** The green solid line is y on x and the blue dashed line is x on y rearranged. The orange star at the centroid is drawn first and the black diamond at the computed intersection on top. In frames 2-7 the diamond sits on the star. Frame 1 has no diamond and its annotation says "both lines coincide", which is correct. The rounded annotation values match the table. The k = 3 value xi = 8.9e-16 rounds to "0.0" (not "-0.0").

### `lslineac.jl`: fit through the origin

- **Method.** a = Σxy/Σx², the one-parameter normal equation for y = a x. This is the archive's PowerCurve with m = 1.
- **Numbers.** Script vs indep: k=1 2.0 / 2; k=2 1.6 / 8/5; k=3 1.642857 / 23/14; k=4 1.566667 / 47/30; k=5 1.581818 / 87/55; k=6 1.549451 / 141/91; k=7 1.557143 / 109/70; k=8 1.539216 / 157/102. RSS script vs indep: 0, 0.2, 0.214286, 0.366667, 0.381818, 0.527473, 0.542857, 0.686275. The two sets are identical. Residual ⟂ x exactly at every k.
- **Reference values.** None are drawn. The archive's 157/102 matches.
- **Picture.** The magenta line a·x passes through the origin. The red and grey markers and the annotation are correct. Residual segments are geometrically correct but practically invisible (F1).

### `lslinead.jl`: Kepler power fit T = a r^{3/2}

- **Method.** a = Σ r^{1.5} T / Σ r³, the one-parameter least squares with basis r^{3/2}. It minimises the RSS in T, the same criterion as the archive's PowerCurve with m = 3/2.
- **Numbers.** Script vs numpy lstsq (single column r^{1.5}): k=1 0.201331949995885 / 0.20133194999588502; k=2 0.20008462562538754 / 0.2000846256253875; k=3 0.19980285815564366 / 0.1998028581556437; k=4 0.1997693001603878 / 0.19976930016038782. RSS script 0, 0.342087, 0.507771, 0.515371 vs lstsq 0, 0.3421, 0.5078, 0.5154. Residual ⟂ r^{1.5} to about 1e-10 (relative to Σ r³ ≈ 1.6e7).
- **Reference values.** None are drawn. The page's planetary claims are checked in C4.6-C4.9.
- **Picture.** The green curve a·r^{1.5} is drawn over [40, 240], which covers all four planets (57.6 to 227.8). The y-range [0, 750] contains every point and the Mars label (y ≈ 702). Planet names are drawn only for the points used. The annotation values match.

### Fidelity to the legacy archive

The archive module has five examples:
1. Standard line for (−1,10)…(6,−1).
2. The x-on-y line for the same data.
3. The intersection of the two lines, compared with the centroid.
4. y = a x for (1,2)…(8,12).
5. The Kepler fit T = a r^{3/2} for the four planets.

The page covers all five. Examples 2 and 3 are combined in Case 2. The data, functions and results are identical to the archive's (−45/28, 121/14, RSS 39/28; −293/180, i.e. 313/36 − 293x/180; intersection (5/2, 37/8) = centroid; 157/102; 0.199769). No fidelity findings.

### Could not determine

Nothing material. The modern Mercury semi-major axis (57.909 million km) comes from the standard value 0.387098 AU, which I did not re-derive from a primary source. The page's 0.55% and "about 57.91" are consistent with it.

