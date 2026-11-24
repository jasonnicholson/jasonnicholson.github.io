# Least Squares Lines — animation review (round 7)

Page: `pages/numerical-methods/least-squares-lines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error 0, Misleading 0, Minor 0.

Every checkable claim on the page was confirmed (Part 2), and all four scripts compute and draw what they claim (Part 3).


#### Examined and deliberately not reported

These do not meet the standard for a finding. They are listed so the owner can see they were looked at.

- **Case 1 readout crossed by the fit line.** `lslineaa.jl:55` places the coefficient text where the green line passes through it in frames k = 3 to 8. The text is drawn on top, and at 8x zoom every glyph, including the minus sign, is legible (`review/zoom_c1.png`). Cosmetic, not unreadable.
- **Case 4 window starts at r = 40.** Mathews plots from r = 0 (`LeastSqLineMod_gr_152`, `_153`). All four planets and the whole fitted curve over the data range are visible, and the page makes no claim about the origin.
- **Case 3 window** is [0, 9] x [0, 13] against Mathews' [-1, 9] x [-2.2, 13.3]. The origin the line is constrained through is visible at the corner.
- **Mathews' RSS comparison** in Example 2 (0.532423 against 1.39286) is not on the page. This is absent content, not a dropped case: the example itself is covered by Case 2.

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lslineaa.jl` | 0 | 7.4 | lslineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineab.jl` | 0 | 7.4 | lslineab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslineac.jl` | 0 | 7.0 | lslineac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `lslinead.jl` | 0 | 6.7 | lslinead.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "chooses parameters that minimize the sum of squared residuals" | Residual exactly orthogonal to each basis function in rational arithmetic (Cases 1 to 3), at most 6.1e-11 (Case 4); Cases 1 and 4 also agree with `numpy.linalg.lstsq` | confirmed |
| D2 | "$y = b + a x$, where residuals are vertical distances" | Scripts compute `y - (a x + b)`; plotted segments are vertical | confirmed |
| D3 | "Regressing $x$ on $y$ ... produces a different line after rearrangement" | y on x: y = 8.64286 - 1.60714x. x on y rearranged: y = 8.69444 - 1.62778x | confirmed |
| D4 | "$y = a x$ and $y = a x^{3/2}$ remain linear in the unknown coefficient $a$" | Closed form a = sum(phi y) / sum(phi^2); Case 3 checked by exact orthogonality, Case 4 also against `lstsq` on the single basis column | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | "Each animation below shows how the fitted model changes as data points are added" | Frames use k = 2..8, 2..8, 1..8, 1..4 points; series dump shows the "points used" grow by one each frame | confirmed |
| I2 | "Cases 1, 3 and 4 print the fitted coefficients and the residual sum of squares in each frame" | Annotation text of all 7 + 8 + 4 frames parsed and compared with exact values, within display rounding | confirmed |
| I3 | "Cases 1 and 3 also draw each vertical residual as a dark blue segment from the point to the line" | `:navy`; dump shows exactly k segments per frame, each from (x_i, y_i) to (x_i, fit(x_i)) | confirmed |
| I4 | "the largest residual in any frame is about 0.79 in Case 1" | 0.785714 (= 11/14), at x = 4, k = 7 and 8 | confirmed |
| I5 | "and 0.46 in Case 3" | 0.460784, at x = 1, k = 8 | confirmed |
| I6 | "the segments are short and some are barely visible" | For example the residual at x = 1 in Case 1, k = 8 is -1/28 = -0.036; frames agree | confirmed |

### Case 1

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading: standard line $y = b + a x$ | `fit_unconstrained` is the normal-equation solution; frame title matches | confirmed |
| C1.2 | "minimizes vertical residuals to a straight line" | Sum r = 0 and sum r x = 0 exactly at every k | confirmed |
| C1.3 | "$a = -45/28 \approx -1.6071$" | Exact -45/28; Mathews `gr_18`, `gr_47` | confirmed |
| C1.4 | "$b = 121/14 \approx 8.6429$" | Exact 121/14; Mathews `gr_18`, `gr_48` | confirmed |
| C1.5 | "(6, -1) lies exactly on the seven-point line" | Seven-point line at x = 6 equals -1 exactly | confirmed |
| C1.6 | "the last two frames show the same fit" | k = 7 and k = 8 give identical a, b, RSS (1.392857 = 39/28) | confirmed |
| C1.7 | Link `lslineaa.jl`, embed `lslineaa.gif` | Byte-identical GIF from a scratch copy; it is this case | confirmed |
| C1.8 | Alt text: line updating, residuals as short dark blue segments | Frames and series dump | confirmed |

### Case 2

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading: two regression lines and their intersection | `fit_y_on_x`, `fit_x_on_y`, and the intersection solved from both | confirmed |
| C2.2 | "With only the first two points ... the same line, through both points" | k = 2: a = c = -1, b = d = 9, a c = 1; frame says "both lines coincide" | confirmed |
| C2.3 | "From three points on they give two distinct lines" | a c = 0.9643, 0.9797, 0.9846, 0.9821, 0.9811, 0.9873 for k = 3..8, none equal to 1 | confirmed |
| C2.4 | "their intersection coincides with the centroid of the points used" | Exact equality in rationals at every k = 3..8 | confirmed |
| C2.5 | "for all eight points is $(\bar{x}, \bar{y}) = (2.5, 4.625)$" | 20/8, 37/8; Mathews `gr_103`, `gr_107` | confirmed |
| C2.6 | "strongly correlated, so the two lines nearly overlap" | r = -0.993641, r^2 = 0.987323 | confirmed |
| C2.7 | "their slopes are $-1.6071$ and $-1.6278$" | -45/28 and -293/180 = -1.627778; Mathews `gr_91` | confirmed |
| C2.8 | Link `lslineab.jl`, embed `lslineab.gif` | Byte-identical GIF from a scratch copy | confirmed |
| C2.9 | Alt text: intersection (black diamond) on the centroid (orange star) | Marker series at the same coordinates for k = 3..8; no diamond at k = 2, where no unique intersection exists | confirmed |

### Case 3

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C3.1 | Heading: fit through origin, $y = a x$ | `fit_through_origin` = sum(xy) / sum(x^2); line passes through (0, 0) | confirmed |
| C3.2 | "Constraining the intercept to zero ... single-parameter fit" | One coefficient; residual orthogonal to x exactly at every k | confirmed |
| C3.3 | "all eight points of the legacy dataset" | Data match Mathews `gr_117` | confirmed |
| C3.4 | "$a = 157/102 \approx 1.5392$" | Exact 157/102 = 1.539216; Mathews `gr_128`, `gr_133` | confirmed |
| C3.5 | "the coefficient zig-zags downward from 2" | 2, 1.6, 1.642857, 1.566667, 1.581818, 1.549451, 1.557143, 1.539216: the change alternates in sign and each low is lower than the last | confirmed |
| C3.6 | Link `lslineac.jl`, embed `lslineac.gif` | Byte-identical GIF from a scratch copy | confirmed |
| C3.7 | Alt text: fit through origin, residual segments | Frames and series dump | confirmed |

### Case 4

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C4.1 | Heading: $T = a r^{3/2}$ | `fit_kepler_a` = sum(r^1.5 T) / sum(r^3); Mathews' PowerCurve formula (`gr_114`) with m = 3/2 | confirmed |
| C4.2 | "linear in $a$ after choosing basis function $r^{3/2}$" | Residual orthogonal to r^1.5 to about 6e-11 | confirmed |
| C4.3 | "Using Mercury, Venus, Earth, and Mars data gives $a \approx 0.19977$" | 0.1997693002 (40-digit mpmath); Mathews `gr_151` gives 0.199769 | confirmed |
| C4.4 | "These are the legacy module's data" | All eight numbers match Mathews `gr_145`, `gr_147` | confirmed |
| C4.5 | "57.59 million km is about 0.55% below its modern semi-major axis of about 57.91" | (57.59 - 57.91) / 57.91 = -0.5526%. Kepler's law with GM_sun = 1.32712440018e20 and T = 87.9691 d gives 57.9091 million km (constants from memory, see below) | confirmed |
| C4.6 | "Mercury's ratio $T/r^{3/2} \approx 0.2013$" | 0.201332 | confirmed |
| C4.7 | "the other three planets' $0.1997$ to $0.1999$" | Venus 0.199896, Earth 0.199680, Mars 0.199756 | confirmed |
| C4.8 | The distance offset "is why" Mercury's ratio stands apart | The offset alone raises the ratio by 0.835%; Mercury is 0.778% above the mean of the other three; with r = 57.91 the ratio is 0.199665, level with the others | confirmed |
| C4.9 | Link `lslinead.jl`, embed `lslinead.gif`, alt text | Byte-identical GIF from a scratch copy; frames show the power curve and planet data | confirmed |

**Could not determine:** nothing on the page. One limit on C4.5: GM_sun and Mercury's period came from memory and were not looked up. They are used only as a cross-check on the 57.91 figure.

### 3. Implementation checks

### Method used for all four scripts

1. **Instrumented copies** (`review/inst/`) printed every computed value. Each still produced a GIF byte-identical to the committed one.
2. **Series dump copies** (`review/dump/`) wrote the actual data of every plotted series and annotation in every frame to TSV. These too produced byte-identical GIFs, so the dumped data is what the committed GIFs show.
3. **Independent computation** (`review/indep.py`, `review/dump/check.py`) used exact rationals for Cases 1 to 3 and 40-digit mpmath for Case 4, without calling the scripts' routines. It made **13,589 comparisons** with no failures: data points, every sample of every fitted curve, every residual segment endpoint, centroid and intersection markers, and all annotation values within their display rounding.
4. **Frames** viewed: the contact sheets, which contain every frame of all four GIFs (7, 7, 8, 4), plus one full-size late frame of each.

Reproduce with:

```
cd /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7/least-squares-lines/review/dump && /usr/bin/python3 check.py
/usr/bin/python3 /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7/least-squares-lines/review/indep.py
```

### `lslineaa.jl` (Case 1)

- **Method:** ordinary least squares by the normal equations, the formula in Mathews' theorem (`gr_4`, `gr_5`) rearranged.
- **Reference values:** none drawn. Exact fractions agree with Mathews.
- **Picture:** line, points, and k residual segments per frame match the computed values. Limits [-2, 7] x [-2.2, 11.3] are Mathews' and contain all data.

| k | script a | exact a | script b | exact b | script RSS | exact RSS |
|---|---|---|---|---|---|---|
| 2 | -1.0 | -1 | 9.0 | 9 | 0.0 | 0 |
| 3 | -1.5 | -3/2 | 8.666667 | 26/3 | 0.166667 | 1/6 |
| 4 | -1.7 | -17/10 | 8.6 | 43/5 | 0.3 | 3/10 |
| 5 | -1.6 | -8/5 | 8.6 | 43/5 | 0.4 | 2/5 |
| 6 | -1.485714 | -52/35 | 8.561905 | 899/105 | 0.704762 | 0.704762 |
| 7 | -1.607143 | -45/28 | 8.642857 | 121/14 | 1.392857 | 39/28 |
| 8 | -1.607143 | -45/28 | 8.642857 | 121/14 | 1.392857 | 39/28 |

### `lslineab.jl` (Case 2)

- **Method:** two OLS fits, y on x and x on y. The second is correctly rearranged to y = x/c - d/c. Intersection from y(1 - ac) = ad + b.
- **Reference values:** the centroid, computed from the data. Final fits match Mathews: c = -180/293, d = 1565/293, rearranged y = 313/36 - (293/180)x.
- **Picture:** both lines, centroid star and intersection diamond match at every k. The `abs(1 - a*c) > 1e-8` guard is correct here: it is 0 at k = 2 and at least 0.012 for k >= 3.

| k | a | rearranged slope 1/c | script (xi, yi) | exact centroid |
|---|---|---|---|---|
| 2 | -1 | -1 | none (coincide) | (-0.5, 9.5), drawn |
| 3 | -1.5 | -1.555556 | (0.0, 8.666667) | (0, 26/3) |
| 4 | -1.7 | -1.735294 | (0.5, 7.75) | (1/2, 31/4) |
| 5 | -1.6 | -1.625 | (1.0, 7.0) | (1, 7) |
| 6 | -1.485714 | -1.512821 | (1.5, 6.333333) | (3/2, 19/3) |
| 7 | -1.607143 | -1.638095 | (2.0, 5.428571) | (2, 38/7) |
| 8 | -1.607143 | -1.627778 | (2.5, 4.625) | (5/2, 37/8) |

### `lslineac.jl` (Case 3)

- **Method:** least squares for y = ax, a = sum(xy) / sum(x^2), Mathews' power fit with m = 1.
- **Reference values:** none drawn. Exact 157/102 agrees with Mathews.
- **Picture:** line through the origin and k residual segments per frame match the computed values.

| k | script a | exact a | script RSS | exact RSS |
|---|---|---|---|---|
| 1 | 2.0 | 2 | 0.0 | 0 |
| 2 | 1.6 | 8/5 | 0.2 | 0.2 |
| 3 | 1.642857 | 23/14 | 0.214286 | 0.214286 |
| 4 | 1.566667 | 47/30 | 0.366667 | 0.366667 |
| 5 | 1.581818 | 87/55 | 0.381818 | 0.381818 |
| 6 | 1.549451 | 141/91 | 0.527473 | 0.527473 |
| 7 | 1.557143 | 109/70 | 0.542857 | 0.542857 |
| 8 | 1.539216 | 157/102 | 0.686275 | 0.686275 |

### `lslinead.jl` (Case 4)

- **Method:** Mathews' power fit with m = 3/2, a = sum(r^1.5 T) / sum(r^3). It is a direct least-squares fit in T, not a log-log fit.
- **Reference values:** none drawn. The final a agrees with Mathews' 0.199769.
- **Picture:** curve and points match, planet labels are on the right points, and the curve stays inside the y limit at the plotted right edge in every frame.

| k | script a | 40-digit a | script RSS | independent RSS |
|---|---|---|---|---|
| 1 | 0.201331950 | 0.20133195 | 0.0 | 0 |
| 2 | 0.200084626 | 0.2000846256 | 0.342087 | 0.34208705 |
| 3 | 0.199802858 | 0.1998028582 | 0.507771 | 0.50777095 |
| 4 | 0.199769300 | 0.1997693002 | 0.515371 | 0.51537144 |

### Fidelity to the legacy archive

All five Mathews examples are present with his data:

| Mathews | Page |
|---|---|
| Example 1, y = ax + b | Case 1 |
| Example 2, x = cy + d | Case 2 |
| Example 3, intersection and centroid | Case 2 |
| Example 4, y = ax | Case 3 |
| Example 5, y = ax^(3/2), Kepler | Case 4 |

A filename search of `a2001/Animations` (least, lsq, lsline, regress) found no animated legacy GIF for this topic. The add-one-point-per-frame device is the page's own and misrepresents nothing in the archive.

