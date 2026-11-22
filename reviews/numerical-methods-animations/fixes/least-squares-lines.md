# Fix record: least-squares-lines

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/least-squares-lines/fix/`
- `indep.py`: exact rational fits for Cases 1 and 2 (per-k a, b, c, d, intersection, centroid, line gap)
- `indep2.py`: Case 3 per-k a and RSS, Case 4 per-k a, T/r^1.5 ratios, Mercury check
- `committed/<gif>/`, `new/<gif>/`: extracted frames and contact sheets before and after
- `archive/`: enlarged legacy data and result images

## Findings

### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I indep.py` (exact `Fraction` arithmetic). y-on-x slope for k=2..8: -1, -3/2, -17/10, -8/5, -52/35 (-1.485714), -45/28, -45/28. Changes: -0.5, -0.2, +0.1, +0.114286, -0.121429, 0. b at k=8 = 121/14. "residual pt8 on 7pt line: 0". The slope does not settle; the last two frames agree only because point 8 lies exactly on the 7-point line.
- Change: index.qmd Case 1 Behavior: "As points are added, the slope and intercept stabilize near a ≈ -1.6071 and b ≈ 8.6429." → "With all eight points the fit is a = -45/28 ≈ -1.6071 and b = 121/14 ≈ 8.6429. The eighth point (6, -1) lies exactly on the seven-point line, so the last two frames show the same fit." No script change (lslineaa.gif unchanged; `git hash-object` = HEAD blob af729f69).
- Check: values above; committed lslineaa frames 6 and 7 print a = -1.6071, b = 8.6429 (Julia `round(digits=4)` of -1.607142857, 8.642857143).

### F2 — Minor — fixed
- Reproduced: code reading. lslineaa.jl:54-56 prints a, b, RSS and draws residuals (49-52); lslineab.jl prints only the intersection status (79-82), no residuals; lslineac.jl prints a, RSS (40-42) and draws residuals (35-38); lslinead.jl prints a, RSS (41-43), no residual segments. Committed frames lslineab/frame_002 and lslinead/frame_004 viewed: confirmed.
- Change: index.qmd Animations intro: "Residuals and fitted parameters update frame-by-frame so you can see …" → "Cases 1, 3 and 4 print the fitted coefficients and the residual sum of squares in each frame, and Cases 1 and 3 also draw the vertical residuals, so you can see …" (text fix per D7; no drawing added).
- Check: same code lines; new frames of lslineac and lslinead viewed show "a = …, RSS = …".

### F3 — Minor — fixed
- Reproduced: `indep.py`: k=2 a·c = 1 exactly (a = -1, c = -1), max gap between the lines 0.0, so the lines coincide and there is no intersection. k=3..8 intersection equals centroid exactly in rationals: (0, 26/3), (1/2, 31/4), (1, 7), (3/2, 19/3), (2, 38/7), (5/2, 37/8). Max gap in window: 0.389, 0.229, 0.150, 0.149, 0.155, 0.093. Committed frame_002 viewed: only the orange star visible, diamond completely hidden.
- Change (lslineab.jl): centroid star drawn first (ms 9 → 11), intersection diamond drawn after it (ms 6 → 4), so the diamond sits visibly inside the star; k=2 label "intersection ill-conditioned" → "both lines coincide" (the suggested "(through both points)" was dropped because the longer centred label ran into the left frame edge in a trial render; the page text says "through both points"); comment line 50 updated. index.qmd Case 2 Behavior rewritten to cover k=2 (same line), k≥3 (distinct lines, intersection = centroid of points used), and the near-overlap with full-data slopes -1.6071 and -1.6278; alt text updated to name the diamond and star.
- Check: regenerated lslineab.gif; `new/lslineab/frame_001.png` shows "k=2: both lines coincide" and only the centroid star; frames 2-7 show the black diamond inside the star (zoom `new/ab4_zoom.png`), labels (0.0, 8.667), (0.5, 7.75), (1.0, 7.0), (1.5, 6.333), (2.0, 5.429), (2.5, 4.625) match `indep.py`.

### F4 — Minor — fixed
- Reproduced: committed lslineac/frame_004 shows "a = 1.56667, RSS = 0.3667" centred at x=1 running left over the "12" tick label and through the legend's "all data" entry; committed lslinead/frame_004 shows the annotation on top of the legend's "all planets" line.
- Change: lslineac.jl `legend=:topleft` → `:bottomright`, annotation `(1.0, 12.2)` centred → `(0.3, 12.2)` left-aligned. lslinead.jl `legend=:topleft` → `:bottomright` (annotation unchanged).
- Check: new lslineac frames 1-8 (sheet + frames 1, 8 full size): annotation fully inside the axes, nothing overlaps it, legend in empty lower-right corner; printed a values 2.0, 1.6, 1.64286, 1.56667, 1.58182, 1.54945, 1.55714, 1.53922 match `indep2.py`. New lslinead frames 1 and 4: annotation clear, legend in empty lower-right; a = 0.201332 and 0.199769 match `indep2.py`.

### F5 — Minor — fixed (text note; data kept)
- Reproduced: `indep2.py`: T/r^1.5 = [0.20133195, 0.19989608, 0.19968037, 0.19975568]; Mercury 57.909176 million km from 0.38709893 AU × 149.5978707 million km/AU, so 57.59 is -0.551% low; with Mercury = 57.91 its ratio becomes 0.199665 (in line with the others) and the 4-point a becomes 0.199750.
- Change: kept the data (the archive shows it is Mathews' own table and his result a = 0.199769). Added to index.qmd Case 4 Behavior: "These are the legacy module's data; its Mercury distance of 57.59 million km is about 0.55% below its modern semi-major axis of about 57.91 million km, which is why Mercury's ratio T/r^{3/2} ≈ 0.2013 stands apart from the other three planets' 0.1997 to 0.1999."
- Check: numbers above. The legend move in F4 regenerated lslinead.gif; the data and printed values are unchanged.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd intro | "Cases 1, 3 and 4 print the fitted coefficients and the residual sum of squares in each frame" | code: lslineaa.jl:54-56 (a, b, RSS), lslineac.jl:40-42 (a, RSS), lslinead.jl:41-43 (a, RSS); lslineab prints only intersection; new frames viewed | yes |
| index.qmd intro | "Cases 1 and 3 also draw the vertical residuals" | lslineaa.jl:49-52, lslineac.jl:35-38 draw segments; lslineab/lslinead have none | yes |
| Case 1 | a = -45/28 ≈ -1.6071, b = 121/14 ≈ 8.6429 | `python3 -I indep.py` → k=8: -45/28 -1.607142857, 121/14 8.642857143 | yes |
| Case 1 | "(6, -1) lies exactly on the seven-point line, so the last two frames show the same fit" | `indep.py` → "residual pt8 on 7pt line: 0"; k=7 and k=8 a, b identical | yes |
| Case 2 | "With only the first two points … give the same line, through both points" | `indep.py` k=2: a = -1, c = -1, a·c = 1, max gap 0.0; RSS(k=2) = 0 | yes |
| Case 2 | "From three points on they give two distinct lines" | `indep.py` k=3..8: a·c = 27/28, 289/295, 64/65, 2028/2065, 675/688, 2025/2051 (all ≠ 1), slopes a ≠ 1/c at each k | yes |
| Case 2 | "intersection coincides with the centroid of the points used" | `indep.py` k=3..8 xi, yi equal x̄, ȳ exactly (rationals listed in F3) | yes |
| Case 2 | (x̄, ȳ) = (2.5, 4.625) for all eight points | `indep.py` k=8 centroid 5/2, 37/8 | yes |
| Case 2 | "nearly overlap", slopes -1.6071 and -1.6278 | `indep.py` k=8: a = -1.6071428, 1/c = -1.6277778; max gap 0.093 y-units (window 13.5) | yes |
| Case 2 alt | "intersection (black diamond) drawn on the centroid of the points used (orange star)" | lslineab.jl marker/colour; new frames 2-7 and zoom viewed | yes |
| lslineab.jl label | "k=2: both lines coincide" | a·c = 1 at k=2 (`indep.py`); frame_001 viewed | yes |
| lslineab.jl comment | "With two points … a*c = 1 and the lines coincide" | same | yes |
| Case 4 | Mercury 57.59 "about 0.55% below" "about 57.91 million km" | `indep2.py` → 57.909176, rel diff -0.005512. Modern value from the J2000 mean element a = 0.38709893 AU (literature constant, not computed here) × IAU AU 149.5978707 million km | yes (input constant from literature) |
| Case 4 | Mercury T/r^{3/2} ≈ 0.2013; others 0.1997 to 0.1999 | `indep2.py` → 0.20133195; 0.19989608, 0.19968037, 0.19975568 | yes |
| Case 4 | "which is why … stands apart" | `indep2.py` → with 57.91, Mercury ratio 0.199665, within 0.00002 of Earth's 0.19968 | yes |
| Case 4 | a ≈ 0.19977 (unchanged) | `indep2.py` k=4 → 0.1997693; archive gr_151 → 0.199769 | yes |

## Scripts and GIFs
- Scripts changed: lslineab.jl, lslineac.jl, lslinead.jl. lslineaa.jl unchanged.
- GIFs regenerated: lslineab.gif, lslineac.gif, lslinead.gif (each by running its own script from the page folder). lslineaa.gif not regenerated; its `git hash-object` matches the HEAD blob (af729f69). Note: the GIFs are Git LFS files, so `git show HEAD:<gif> | md5sum` gives the pointer's hash, not the image's.
- Frames viewed: lslineab frames 1, 4, 7 full size plus sheet and zoom (label, markers, both lines); lslineac frames 1, 8 full size plus sheet of all 8 (annotation position and values, legend placement); lslinead frames 1 and 4 full size (annotation, legend, planet labels).
- `git status --short -- pages/numerical-methods/least-squares-lines` after regeneration:
  ```
   M index.qmd
   M lslineab.gif
   M lslineab.jl
   M lslineac.gif
   M lslineac.jl
   M lslinead.gif
   M lslinead.jl
  ```

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/LeastSqLineMod.html` (it sits at the n2003 root, not under `leastsquaresline/`) and `leastsquaresline/LeastSqLineMod/Links/LeastSqLineMod_lnk_2..6.html`. Data images enlarged (`archive/gr_*.png`):
- Example 1/2/3 data (gr_8): (-1,10), (0,9), (1,7), (2,5), (3,4), (4,3), (5,0), (6,-1): same as Cases 1 and 2. Example 3 asks for the intersection of the two lines and compares it with the coordinate averages, matching Case 2's point.
- Example 4 data (gr_117): (1,2), (2,3), (3,5), (4,6), (5,8), (6,9), (7,11), (8,12): same as Case 3.
- Kepler data (gr_145/147): (57.59, 87.99), (108.11, 224.70), (149.57, 365.26), (227.84, 686.98), and Mathews' result (gr_151/156) y = 0.199769 x^{3/2}, matching the script. So the low Mercury distance is in the textbook table itself; the page keeps the table, as the archive does, and now says that Mercury's distance is about 0.55% below its modern value.
- Mathews' examples are static (data and final fits); no incremental-point animation to compare against.

## Notes
- Not a listed finding, left unchanged: Case 3 Behavior says "The coefficient settles near a ≈ 1.5392". `indep2.py` gives a for k=1..8 as 2, 1.6, 1.642857, 1.566667, 1.581818, 1.549451, 1.557143, 1.539216. This sequence goes up and down and does not settle; it is the same kind of wording as F1. The final value 1.5392 (= 157/102) is correct. Jason may want "With all eight points the coefficient is a = 157/102 ≈ 1.5392."
- Not a listed finding, left unchanged: in lslineaa frames 5-7 (committed sheet), the centred "a = …, b = …, RSS = …" annotation starts at the left frame edge and touches the 10.0 tick label. It is still readable. Moving it to a left-aligned position like the lslineac fix would solve it.
- lslineab: from k=5 on, the two lines are still within a few pixels of each other. I did not change the plot for this; the page text now says the lines nearly overlap and gives their slopes.

## Resolution check (independent checker, not shown this record)

Work files: `check/verify.py` (exact rational arithmetic in `fractions` plus numpy), `check/run/` (scratch copies of the scripts and regenerated GIFs), `check/frames_{new,old}_*` (decoded frames; old GIFs from `git show HEAD:… | git lfs smudge`), `check/zoom_ab*.png` (8x crops around the centroid), `check/legacy_145.png` (legacy Kepler data image).

### Original findings

### F1 — resolved
- Evidence: The "stabilize near" sentence is gone (index.qmd:26). It now reads: "With all eight points the fit is a = −45/28 ≈ −1.6071 and b = 121/14 ≈ 8.6429. The eighth point (6, −1) lies exactly on the seven-point line, so the last two frames show the same fit."
- Exact arithmetic (verify.py): k=8 gives a = −45/28 and b = 121/14. The k=7 fit is also −45/28 and 121/14. The residual of (6, −1) on the 7-point line is exactly 0. Every part of the new sentence is true.
- lslineaa.jl and its GIF are unchanged, as expected, since this was a text-only finding.

### F2 — resolved
- Evidence: The intro (index.qmd:22) now says: "Cases 1, 3 and 4 print the fitted coefficients and the residual sum of squares in each frame, and Cases 1 and 3 also draw the vertical residuals". I checked this against the code and the frames:
  - lslineaa.jl:55-56 prints a, b and RSS, and :49-52 draws residuals.
  - lslineac.jl:41-42 prints a and RSS, and :35-38 draws residuals.
  - lslinead.jl:42-43 prints a and RSS and draws no residuals.
  - lslineab.jl prints only the intersection, and the page no longer claims anything else for it.
- Frames viewed: lslineac 001/004/008 and lslinead 001/004.

### F3 — resolved
- Evidence:
  - lslineab.jl:72-78 now draws the centroid star first (ms=11) and the diamond (ms=4) on top of it.
  - In 8x zooms of new frames 004 and 007, a black diamond is clearly visible inside the orange star. In the old frame 007 there is only the star.
  - A pixel count of near-black pixels in an 11x11 box at the star centre gives 30–42 for new frames 2–7 and 5 for frame 1, where no diamond is drawn. So the diamond shows in every frame k=3…8.
  - The k=2 label is now "k=2: both lines coincide" (frame 001 viewed). Exact arithmetic confirms a·c = 1 at k=2: a = −1, c = −1.
  - For k=3…8 the exact intersection equals the exact centroid of the points used. The status label in frame 007 shows (2.5, 4.625).
  - The page adds the near-overlap note with slopes −1.6071 and −1.6278. Exact values: a = −45/28 = −1.607142…, and 1/c = −293/180 = −1.627777…, which rounds to −1.6278.
  - The lines still nearly overlap. That comes from the data and is now explained in the text.

### F4 — resolved
- Evidence:
  - lslineac uses legend=:bottomright, with a left-aligned annotation at (0.3, 12.2). In frames 001, 004 and 008 the text sits inside the axes, clear of the "12" tick and the legend, and is fully readable ("a = 1.53922, RSS = 0.6863" in frame 008).
  - lslinead uses legend=:bottomright. In frames 001 and 004 the annotation stands alone at the top and the legend in the lower right overlaps no data, curve or planet labels.
  - The magenta and green curves never enter the bottom-right legend box. In Case 3, y = a·x is at least 10.7 for x ≥ 7. In Case 4, T is at least 500 for r ≥ 185.

### F5 — resolved
- Evidence: The fixer kept the data and added a provenance note. This is the second option the finding offered.
  - The legacy archive image LeastSqLineMod_gr_145.gif (rendered at 3x) reads "(57.59, 87.99), (108.11, 224.70), (149.57, 365.26), (227.84, 686.98)", which matches lslinead.jl:9-10 exactly. So "These are the legacy module's data" is true.
  - 57.59/57.91 − 1 = −0.553%, which matches "about 0.55% below". Mercury's semi-major axis is 0.387098 AU × 149.598 = 57.909 million km.
  - The ratios T/r^{3/2} are 0.20133, 0.19990, 0.19968 and 0.19976. The page says "≈ 0.2013" for Mercury and "0.1997 to 0.1999" for the others; both are correct.
  - "Which is why" also holds: at r = 57.91, Mercury's ratio is 0.20133·(57.59/57.91)^{1.5} ≈ 0.19967, in line with the other planets.
  - a ≈ 0.19977 is unchanged and correct: 0.199769 at k=4.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:22 | Cases 1, 3, 4 print coefficients and RSS; Cases 1 and 3 draw vertical residuals | Code lines cited under F2; frames viewed | true |
| index.qmd:26 | a = −45/28 ≈ −1.6071 | Exact normal equations, k=8 | true |
| index.qmd:26 | b = 121/14 ≈ 8.6429 | Exact normal equations, k=8 | true |
| index.qmd:26 | (6, −1) lies exactly on the seven-point line; last two frames the same | Residual = 0 exactly; k=7 fit equals k=8 fit | true |
| index.qmd:34 | With the first two points both regressions give the same line, through both points | k=2: a = −1, b = 9, c = −1, a·c = 1; the line through (−1, 10) and (0, 9) | true |
| index.qmd:34 | From three points on, two distinct lines | a·c = 27/28, 289/295, 64/65, 2028/2065, 675/688, 2025/2051 (all ≠ 1) | true |
| index.qmd:34 | Intersection coincides with the centroid of the points used | Exact equality for k=3…8 | true |
| index.qmd:34 | For all eight points (x̄, ȳ) = (2.5, 4.625) | 5/2, 37/8 | true |
| index.qmd:34 | Slopes −1.6071 and −1.6278 | −45/28; 1/c = −293/180 = −1.62778 | true |
| index.qmd:34 | "strongly correlated … nearly overlap" | r² = a·c = 2025/2051 = 0.987; frames 004 and 007 show near-overlap | true |
| index.qmd:38 (alt) | Intersection (black diamond) drawn on the centroid of the points used (orange star) | Colours and markers match lslineab.jl:73-77 and the frames. The diamond is absent in frame 1 (k=2), which matches the text's "from three points on" | true (see note in New problems) |
| index.qmd:50 | a ≈ 0.19977 (unchanged) | 0.199769 | true |
| index.qmd:50 | Legacy module's data | Legacy image gr_145 matches the script data | true |
| index.qmd:50 | 57.59 is about 0.55% below about 57.91 | −0.553% | true |
| index.qmd:50 | Mercury T/r^{3/2} ≈ 0.2013; others 0.1997 to 0.1999 | 0.20133; 0.19968–0.19990 | true |
| lslineab.jl:50 | Comment: with two points a·c = 1 and the lines coincide | Exact | true |
| lslineab.jl:72 | Comment: centroid first, then the smaller intersection marker on top | Matches the code order and the frames | true |
| lslineab.jl:82 | Label "k=$(k): both lines coincide" | Shown only at k=2 (a·c = 1, so the 1e-8 test fails); correct | true |
| lslineac.jl / lslinead.jl | Legend position and annotation placement | Frames viewed; per-frame a and RSS recomputed: Case 3 k=1…8 match 2.0/0.0 … 1.53922/0.6863, Case 4 0.201332/0 … 0.199769/0.5154 | true |

### New problems

None found that needs a fix. This rests on the exact recomputation of every changed number, the full-size first, middle and last frames of all three regenerated GIFs, the zoomed marker crops, and the per-frame pixel check.

Observation only, not a problem: the Case 2 alt text describes the diamond drawn on the star. That is true for 6 of the 7 frames. Frame 1 (k=2) has no diamond, consistent with the prose ("from three points on").

### Reproducibility and conventions

- I ran lslineab.jl, lslineac.jl and lslinead.jl from scratch copies in `check/run/`. Each output GIF is byte-identical to the working-tree GIF (`cmp`), with 7, 8 and 4 frames.
- lslineaa.jl and lslineaa.gif are unchanged.
- index.qmd still has Description before Animations, one source link and one embed per case (4 of 4), descriptive alt text and no code blocks (0 fences).
- The section index still links the page (pages/numerical-methods/index.qmd:80).
- No tracked file outside `pages/numerical-methods/` is modified. The only page-related file outside the page folder is the untracked fixer note `reviews/numerical-methods-animations/fixes/least-squares-lines.md`, which is a workflow record and not site content. The other modified files under `pages/numerical-methods/` belong to other pages' fixes on this branch and are not part of this page's diff.

**Final status:** committed
