# Least Squares Lines — animation review

Page: [`pages/numerical-methods/least-squares-lines/index.qmd`](../../pages/numerical-methods/least-squares-lines/index.qmd) · Scripts: `lslineaa.jl`, `lslineab.jl`, `lslineac.jl`, `lslinead.jl` · GIFs: 4

**Result:** 0 error, 0 misleading, 5 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Minor — Page match — Case 1 "stabilize" is not what the slope sequence does

- **Location:** index.qmd:26, "As points are added, the slope and intercept stabilize near $a \approx -1.6071$ and $b \approx 8.6429$."
- **Now:** The page presents −1.6071 / 8.6429 as values that the fit settles toward as points are added.
- **True:** The two numbers are correct for the full 8-point fit: a = −45/28 = −1.607142857 and b = 121/14 = 8.642857143. But the slope does not settle. For k = 2…8 it runs −1.0, −1.5, −1.7, −1.6, −1.4857, −1.6071, −1.6071. The jump from k=6 to k=7 (+0.12) is larger than the k=4→5 change. The last two frames are identical only because point 8, (6, −1), lies exactly on the 7-point line: its residual is exactly 0 in rational arithmetic. So the apparent "stabilization" is a coincidence of this dataset, not convergence.
- **Evidence:** `julia reviewer/lslineaa_print.jl` printed the per-frame a and b above. `python3 -I reviewer/indep.py` gave: "exact 7-pt: -45/28 121/14 residual of point 8 on 7-pt line: 0".
- **Suggested fix:** Rephrase as "With all eight points the fit is $a = -45/28 \approx -1.6071$, $b = 121/14 \approx 8.6429$". Optionally add that the eighth point lies exactly on the seven-point line, which is why the last two frames agree.

- **Independent check:** not run (minor finding, unverified).

### F2 — Minor — Page match — Intro says every animation shows residuals and fitted parameters

- **Location:** index.qmd:22, "Each animation below shows how the fitted model changes as data points are added. Residuals and fitted parameters update frame-by-frame…"
- **Now:** The claim is made for all four animations.
- **True:**
  - Cases 1 and 3 draw vertical residual segments and print the parameters.
  - Case 2 (lslineab) draws no residuals and prints no fitted parameters. Its only annotation is the intersection point (lslineab.jl:79-82).
  - Case 4 (lslinead) prints a and RSS but draws no residual segments (lslinead.jl has no residual plot).
- **Evidence:** Code reading of lslineab.jl:58-82 and lslinead.jl:25-43, plus frames lslineab/frame_007.png and lslinead/frame_004.png.
- **Suggested fix:** Change the sentence to "…the fitted parameters (and, in Cases 1 and 3, the vertical residuals) update frame-by-frame." Alternatively, add residual segments to lslinead.jl and a, b, c, d to the lslineab annotation.

- **Independent check:** not run (minor finding, unverified).

### F3 — Minor — Implementation (picture) — Case 2: intersection marker never visible; k=2 label is inaccurate

- **Location:** lslineab.jl:72-77 (diamond drawn at ms=6, then the centroid star drawn on top at ms=9) and lslineab.jl:51, 79-81 (the k=2 label).
- **Now:**
  - The legend lists a black-diamond "line intersection" in frames 2–7, but the diamond is always completely covered by the orange centroid star. The intersection and the centroid coincide exactly, and the star is drawn afterwards and larger.
  - Frame 1 (k=2) reads "intersection ill-conditioned".
  - From k=5 on, the two lines are within 2–4 px of each other across the whole window.
- **True:**
  - With two points both regressions pass through both points, so the lines are identical (a·c = 1.0 exactly). The intersection is undefined, not ill-conditioned.
  - The page alt text (line 38) promises "their moving intersection and the data centroid". A viewer cannot see the intersection marker or tell it apart from the centroid, so the page's main point (line 34, intersection = centroid) is shown only by the text annotation and a legend entry with no visible mark.
  - The near-overlap of the lines comes from the data (r² = 0.987). It is not an error, but it makes "two distinct lines" hard to see after frame 3.
- **Evidence:** In `julia reviewer/lslineab_print.jl`, k=2 printed `ac=1.0 has=false`, and k=3…8 printed xi, yi equal to xbar, ybar to about 1e-13. `python3 -I reviewer/gap.py` gave a maximum gap of 0.389 / 0.229 / 0.150 / 0.149 / 0.155 / 0.093 y-units for k=3…8, which is about 9.8 / 5.8 / 3.8 / 3.8 / 3.9 / 2.3 px. Frames 002 and 007 viewed.
- **Suggested fix:**
  - Draw the intersection marker after the centroid, or as an open or larger marker, so both are visible.
  - Change the k=2 label to "k=2: both lines coincide (through both points)".
  - Optionally mention in the page that the lines nearly coincide for these strongly correlated data, with slopes −1.6071 vs −1.6278.

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Implementation (picture) — Parameter annotation overprints the legend in Cases 3 and 4

- **Location:** lslineac.jl:41-42 (`annotate!(p, 1.0, 12.2, …)` with `legend=:topleft`) and lslinead.jl:42-43 (`annotate!(p, 95.0, 720.0, …)` with `legend=:topleft`).
- **Now:**
  - In every lslineac frame, the "a = …, RSS = …" text is centred at x=1.0. It runs left past the axis over the "12" tick label and through the legend's "all data" entry and marker, so parts of the RSS digits and the legend label are obscured. Frames 001, 004 and 008 viewed.
  - In lslinead, the text sits on top of the legend's "all planets" line. It is readable, but cluttered.
- **True:** The printed values are correct (see Implementation checks), but in Case 3 the fitted coefficient, which is the number the page quotes, is partly overprinted.
- **Evidence:** committed/lslineac/frame_001.png, frame_004.png, frame_008.png and committed/lslinead/frame_004.png.
- **Suggested fix:** Use `legend=:bottomright` in lslineac.jl and lslinead.jl, or move the annotation (for example `annotate!(p, 4.5, 12.4, …)` in lslineac and `(160, 60)` in lslinead).

- **Independent check:** not run (minor finding, unverified).

### F5 — Minor — Implementation — Mercury's distance in the Kepler data is about 0.55% low

- **Location:** lslinead.jl:9, `x = [57.59, 108.11, 149.57, 227.84]`
- **Now:** Mercury is given r = 57.59 million km.
- **True:** Mercury's semi-major axis is about 57.91 million km. The other three distances are within 0.1% of modern values, and all four periods are within 0.03%. Because of this one value, Mercury is the outlier in T/r^{3/2}: 0.20133 for Mercury against 0.19968–0.19990 for the others. Its single-point fit (frame 1, a = 0.201332) is the frame furthest from the physical constant. With modern data the fit gives a = 0.199609. From GM_sun, the physical constant is 2π·(10⁹ m)^{1.5}/√GM/86400 s = 0.199623. The page's a ≈ 0.19977 is correct for the dataset used. This may be the textbook's own table; that could not be checked because the archive is unavailable.
- **Evidence:** `python3 -I reviewer/indep.py` printed "per-planet T/r^1.5: [0.20133195 0.19989608 0.19968037 0.19975568]", "r rel diff vs modern: [-0.0055 -0.0009 -0.0002 -0.0005]", "a with modern data: 0.19961" and "Kepler constant from GM_sun: 0.199623".
- **Suggested fix:** Either use 57.91 for Mercury (and update the page value to a ≈ 0.19963 after re-running), or keep the textbook table and add a note that it is the textbook's data.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `lslineaa.jl` | yes | 3.0 | lslineaa.gif |
| `lslineab.jl` | yes | 3.0 | lslineab.gif |
| `lslineac.jl` | yes | 3.1 | lslineac.gif |
| `lslinead.jl` | yes | 2.9 | lslinead.gif |

Committed GIFs byte-identical to their regenerated output: **4 of 4**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Least squares line fitting chooses parameters that minimize the sum of squared residuals between measured data and a model." | All four scripts solve the normal equations of the sum of squared residuals. Residual is orthogonal to the basis (indep.py, A^T r ≈ 1e-14) | confirmed |
| 2 | 13 | "The standard linear model is $y = b + a x$, where residuals are vertical distances" | lslineaa.jl:13-21 fits y on x. Vertical segments at lslineaa.jl:49-52 | confirmed |
| 3 | 17 | "Regressing $x$ on $y$ instead of $y$ on $x$ produces a different line after rearrangement, even for the same data." | Full data: y-on-x slope −1.607143, rearranged x-on-y slope −1.627778. They differ whenever r² < 1 (here r² = 0.98732) | confirmed |
| 4 | 18 | "$y = a x$ and $y = a x^{3/2}$ remain linear in the unknown coefficient $a$, so least squares still applies directly." | lslineac/lslinead use a = Σφy/Σφ² with φ = x or x^{1.5}. This matches lstsq, and the residual is orthogonal to φ | confirmed |
| 5 | 22 | "Each animation below shows how the fitted model changes as data points are added." | All four loop over prefixes x[1:k] (k from 2 or 1 to n) | confirmed |
| 6 | 22 | "Residuals and fitted parameters update frame-by-frame" | Case 2 shows neither. Case 4 has no residual segments | wrong (→ F2) |
| 7 | 24 | Case 1 model "$y = b + a x$" | lslineaa.jl title and code | confirmed |
| 8 | 26 | "The unconstrained fit minimizes vertical residuals to a straight line." | Normal equations for y on x. polyfit agrees to 1e-10 for every k | confirmed |
| 9 | 26 | "As points are added, the slope and intercept stabilize near…" | Slope sequence −1, −1.5, −1.7, −1.6, −1.486, −1.607, −1.607. The last two are equal only because point 8 lies on the 7-point line | wrong (→ F1) |
| 10 | 26 | "$a \approx -1.6071$" | −45/28 = −1.6071429 (script, numpy, exact) | confirmed |
| 11 | 26 | "$b \approx 8.6429$" | 121/14 = 8.6428571 | confirmed |
| 12 | 28, 30 | Case 1 link/embed → lslineaa.jl / lslineaa.gif | manifest: lslineaa.gif produced by lslineaa.jl, byte-identical | confirmed |
| 13 | 30 (alt) | "standard least-squares line updating as points are added, with residual segments drawn vertically to the line" | lslineaa.jl:49-52. Segments visible at x=4, 5 in frame 007; the others are shorter than the marker radius | confirmed |
| 14 | 34 | "Fitting $y$ as a function of $x$ and fitting $x$ as a function of $y$ produce two distinct lines in the $x$-$y$ plane." | Distinct for k ≥ 3 (identical at k=2). For k ≥ 5 they are only 2–4 px apart in the GIF | confirmed (picture weakness → F3) |
| 15 | 34 | "Their intersection coincides with the centroid of the data" | Script and independent solve: intersection = centroid for every k = 3…8, to about 1e-13 | confirmed |
| 16 | 34 | "$(\bar{x}, \bar{y}) = (2.5, 4.625)$" | 20/8 = 2.5, 37/8 = 4.625 | confirmed |
| 17 | 36, 38 | Case 2 link/embed → lslineab.jl / lslineab.gif | manifest | confirmed |
| 18 | 38 (alt) | "comparing y-on-x and x-on-y regression lines, showing their moving intersection and the data centroid" | The lines and centroid are shown. The intersection marker is always hidden under the star; its location is given only in the text annotation | confirmed with caveat (→ F3) |
| 19 | 40 | Case 3 model "$y = a x$" (constrained through origin) | lslineac.jl:12, a = Σxy/Σx². Matches lstsq with the single column x | confirmed |
| 20 | 42 | "produces a single-parameter fit" | One coefficient | confirmed |
| 21 | 42 | "The coefficient settles near $a \approx 1.5392$" | Sequence 2.0, 1.6, 1.6429, 1.5667, 1.5818, 1.5495, 1.5571, 1.5392 (damped oscillation). Final value = 157/102 = 1.539216 | confirmed |
| 22 | 44, 46 | Case 3 link/embed → lslineac.jl / lslineac.gif | manifest | confirmed |
| 23 | 46 (alt) | "constrained least-squares fit through the origin for y equals a times x, with residuals updating as points are added" | lslineac.jl:32-38 draws the line through the origin and vertical residual segments | confirmed |
| 24 | 48 | Case 4 model "$T = a r^{3/2}$" | lslinead.jl:13, basis r^{1.5}. Fit is in T (vertical) | confirmed |
| 25 | 50 | "With exponent fixed at $3/2$, the power law is linear in $a$ after choosing basis function $r^{3/2}$." | Same as #4 | confirmed |
| 26 | 50 | "Using Mercury, Venus, Earth, and Mars data" | lslinead.jl:9-11 has these four planets. Mercury's r is 0.55% low | confirmed (data caveat → F5) |
| 27 | 50 | "$a \approx 0.19977$" | Script 0.1997693002. numpy lstsq 0.1997693002 | confirmed |
| 28 | 52, 54 | Case 4 link/embed → lslinead.jl / lslinead.gif | manifest | confirmed |
| 29 | 54 (alt) | "power-law least-squares fit T equals a times r to the three-halves for planetary distance and orbital period data" | Frames 001–004 show the curve and the planets; axis labels give units | confirmed |

## Implementation checks

### lslineaa.jl
- **Method:** Ordinary least squares for y = b + a x, using the closed-form normal equations (lslineaa.jl:13-21). The residuals are vertical. RSS is computed on the points used.
- **Numbers (script vs independent numpy lstsq/polyfit):**

  | k | a | b | RSS | match |
  |---|---|---|---|---|
  | 2 | −1.0 | 9.0 | 0.0 | identical |
  | 3 | −1.5 | 8.666667 | 0.166667 | identical |
  | 4 | −1.7 | 8.6 | 0.3 | identical |
  | 5 | −1.6 | 8.6 | 0.4 | identical |
  | 6 | −1.485714 | 8.561905 | 0.704762 | identical |
  | 7 | −1.607143 | 8.642857 | 1.392857 | identical |
  | 8 | −1.607143 | 8.642857 | 1.392857 | identical |

  The residual is orthogonal to [1, x] for every k (|Aᵀr| ≤ 4e-14). The exact rationals for the 8-point fit are a = −45/28 and b = 121/14.
- **Reference values:** None drawn.
- **Picture:** Viewed the contact sheet, frame_001 and frame_007.
  - Annotations ("a = -1.0, b = 9.0, RSS = 0.0" through "a = -1.6071, b = 8.6429, RSS = 1.3929") match the printed values.
  - The green line passes through the plotted points as the fit dictates.
  - The legend reads "fit with first k points", with the correct k.
  - Data points match the code.
  - Residual segments are vertical, from (xᵢ, yᵢ) to (xᵢ, a xᵢ + b). They are visible only where |residual| exceeds the marker radius.
  - No clamping; all data lie inside the limits.

### lslineab.jl
- **Method:** y-on-x OLS (a, b) and x-on-y OLS (x = c y + d), rearranged to y = x/c − d/c. The intersection is solved from y(1 − ac) = ad + b, which is algebraically correct.
- **Numbers (script vs independent):**

  | k | c | d | 1/c | −d/c | intersection | centroid |
  |---|---|---|---|---|---|---|
  | 3 | −0.642857 | 5.571429 | −1.555556 | 8.666667 | (0, 8.666667) | (0, 8.666667) |
  | 8 | −0.614334 | 5.341297 | −1.627778 | 8.694444 | (2.5, 4.625) | (2.5, 4.625) |

  All k = 3…8 agree with numpy to printed precision. Residual x − (d + c y) is orthogonal to [1, y] (≤ 1.4e-13). At k=2, a·c = 1.0 exactly, so the script skips the intersection.
- **Reference values:** The centroid is the plain mean of the points used. It is correct.
- **Picture:** Viewed the contact sheet, frame_001 (k=2), frame_002 (k=3) and frame_007 (k=8).
  - Status text values match the computed values.
  - The dashed blue line is the rearranged x-on-y line.
  - The diamond is hidden by the star in every frame, and the k=2 label says "ill-conditioned" for identical lines (F3).

### lslineac.jl
- **Method:** One-parameter least squares through the origin, a = Σxy/Σx², with vertical residuals.
- **Numbers (script vs independent numpy lstsq with the single column x):**

  | k | a | RSS |
  |---|---|---|
  | 1 | 2.0 | 0 |
  | 2 | 1.6 | 0.2 |
  | 3 | 1.642857 | 0.214286 |
  | 4 | 1.566667 | 0.366667 |
  | 5 | 1.581818 | 0.381818 |
  | 6 | 1.549451 | 0.527473 |
  | 7 | 1.557143 | 0.542857 |
  | 8 | 1.539216 | 0.686275 |

  All are identical between the script and numpy. The exact final value is a = 157/102. x·r ≈ 1e-14 for every k.
- **Reference values:** None drawn.
- **Picture:** Viewed the contact sheet and frames 001, 004 and 008.
  - The line passes through the origin with the printed slope.
  - Residual segments are vertical.
  - The annotation values ("a = 2.0, RSS = 0.0" … "a = 1.53922, RSS = 0.6863") match, but they overprint the legend and the y tick label (F4).

### lslinead.jl
- **Method:** One-parameter least squares on the basis r^{3/2}, a = Σ r^{1.5} T / Σ r³. Residuals are in T (vertical); the exponent is not fitted.
- **Numbers (script vs independent numpy lstsq):**

  | k | a | RSS |
  |---|---|---|
  | 1 | 0.20133195 | 0 |
  | 2 | 0.20008463 | 0.342087 |
  | 3 | 0.19980286 | 0.507771 |
  | 4 | 0.19976930 | 0.515371 |

  All are identical. The basis is orthogonal to the residual to about 1e-10, relative to Σr³ of about 2e7.
- **Reference values:** No exact curve is drawn. Physical cross-check: the Kepler constant in these units from GM_sun is 0.199623, and a fit to modern planetary data gives 0.199609. The dataset's 0.199769 is close; most of the difference comes from Mercury's r = 57.59 (F5).
- **Picture:** Viewed the contact sheet and frame_004.
  - The curve passes near all four planets, and the labels sit next to the correct points.
  - Axes are labelled with units (million km, days).
  - The annotation matches the computed a and RSS but overlaps the legend (F4).
  - All data lie inside the limits; no clamping.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/least-squares-lines/`](evidence/least-squares-lines/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
