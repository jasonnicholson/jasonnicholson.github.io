# Least Squares Polynomials — animation review (round 3)

Page: `pages/numerical-methods/least-squares-polynomials/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1: Fidelity, Minor. The page does not mention Mathews' Example 8
- **Location:** `index.qmd` lines 40–41: "The four cases animate Examples 2–5 … The module's Example 1, …, the graph in Example 6, …, and Example 7, … are not animated here."
- **What is there now:** The sentence lists the archive examples the page leaves out (1, 6, 7). Because it is written as a full list, a reader will take it to cover everything the page leaves out.
- **What is true:** The legacy module has an Example 8: "Use the linear least squares method to find the polynomial curve fit of degree = 3 for the points …" (`LeastSqPolyMod_lnk_9.html`, which builds the matrix F and solves FᵀF C = Fᵀ Y). The page leaves it out and does not say so.
- **How I know:** `sed 's/<[^>]*>//g' n2003/LeastSqPolyMod.html | sed '/^[[:space:]]*$/d'` lists Examples 1–8. `grep -o 'LeastSqPolyMod_lnk_[0-9]*\.html'` shows links lnk_1 to lnk_9, and lnk_9 holds Example 8. I could not read Example 8's data points because its data image (gr_121) is missing from the archive.
- **Suggested correction:** Add a clause to line 41, for example: "… and Example 8, which repeats the cubic fit using the general linear-least-squares matrix formulation, are not animated here." If the dataset is ever recovered, also say whether it is the same six points.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `leastsqpolyaa.jl` | 0 | 8.1 | leastsqpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyab.jl` | 0 | 8.3 | leastsqpolyab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyac.jl` | 0 | 8.2 | leastsqpolyac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyad.jl` | 0 | 8.5 | leastsqpolyad.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `leastsqpolyaa.gif` | 3 | byte-identical | leastsqpolyaa |
| `leastsqpolyab.gif` | 4 | byte-identical | leastsqpolyab |
| `leastsqpolyac.gif` | 5 | byte-identical | leastsqpolyac |
| `leastsqpolyad.gif` | 6 | byte-identical | leastsqpolyad |

### Page references

- Scripts linked: `leastsqpolyaa.jl`, `leastsqpolyab.jl`, `leastsqpolyac.jl`, `leastsqpolyad.jl`
- GIFs embedded: 4
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | $p_m$ minimizes $E=\sum (p_m(x_i)-y_i)^2$ | The script solves the normal equations of exactly this E. Residual orthogonality holds: max\|Vᵀr\| = 0 exactly (sympy), ≤1.2e-12 in the script. | confirmed |
| D2 | Description | Normal equations $(V^TV)\mathbf a=V^T\mathbf y$, $V$ Vandermonde-style | Script line 18–19: `V=[x^j for x, j in 0:m]`, `coeffs=(V'*V)\(V'*y_data)` | confirmed |
| D3 | Description | RMS $=\sqrt{\frac1n\sum(p_m(x_i)-y_i)^2}$ | Script line 30 uses the same formula, divided by n=6. It reproduces Mathews' printed RMS for Ex 2 (0.0524514) and Ex 4 (0.00733997). | confirmed |
| D4 | Description | Six data points (−4.5,0.7)…(4.1,5.6) | Script line 16–17 is identical. Mathews gr_39/gr_41 show the same `XY` list. | confirmed |
| D5 | Description | "As the degree increases from 2 to 5, RMS decreases" | Exact RMS: 0.0524514, 0.0276732, 0.0073400, 0 | confirmed |
| D6 | Description | High-degree fits can wiggle / extrapolate poorly | General statement. Mathews' Example 6 graph (gr_85, x∈[−10,10]) shows the four fits separating outside the data. | confirmed (general) |
| A1 | Intro | Each animation draws the degree-m fit "one partial sum at a time, for the same dataset" | `@animate for k in 0:m`, `partial_eval(x,c,k)`. All four scripts use the same data. | confirmed |
| A2 | Intro | Blue points = data; gray dashed = fitted $p_m$; solid coloured = partial sum $a_0+\dots+a_kx^k$; k increases frame by frame | Script lines 43–45. Frames show royalblue dots, gray45 dashed line, solid coloured curve. Titles read "partial sum through x^0 … x^m". | confirmed |
| A3 | Intro | "Only the last frame (k=m) is a least-squares fit" | For every k<m, the partial-sum RMS is strictly larger than the degree-k LS RMS (table in §3), so no earlier frame is an LS fit. | confirmed |
| A4 | Intro | "the degree-0 fit is the mean 3.8167" | mean(y) = 3.816667 | confirmed |
| A5 | Intro | "$a_0$ ranges from 4.629 to 4.674 across the four cases" | Exact a₀: 4.674251, 4.668626, 4.628628, 4.632324. min 4.6286→4.629, max 4.6743→4.674 | confirmed |
| A6 | Intro | Each earlier partial sum has a larger RMS than the degree-k LS fit | All 10 cases (k<m, m=2..5) checked. See the table in §3. | confirmed |
| A7 | Intro | "in Case 4 it rises from 0.17774 at k=2 to 0.20267 at k=3" | Exact: 0.17774, 0.20267. Script frame annotations give the same. | confirmed |
| A8 | Intro | Scripts compute coefficients from the normal equations | Script line 19 | confirmed |
| A9 | Intro | Cases animate Mathews' Examples 2–5 (quadratic, cubic, quartic, quintic, six points above) | lnk_3..lnk_6: Examples 2–5, degrees 2–5, same XY. Coefficients match Mathews' gr_50 (p2), gr_66 (p4) and gr_74 (p5) to every digit shown. | confirmed |
| A10 | Intro | Example 1 fits a parabola to a different set of points | gr_11: XY={{-1,10},{0,6},{1,2},{2,1},{3,0},{4,2},{5,4},{6,7}} | confirmed |
| A11 | Intro | Example 6's graph plots quadratic–quintic together on a wide interval showing separation outside the data | lnk_7 has gr_83 (data window) and gr_85 (x∈[−10,10], curves separate past x≈−5 and x≈7) | confirmed |
| A12 | Intro | Example 7 fits the same degrees to points sampled from a non-polynomial function (polynomial wiggle) | lnk_8 text: "fits of degree n = 2, 3, 4, 5 … The points were obtained from … which is not polynomial". Module text: "polynomial wiggle … next example illustrates". | confirmed |
| A13 | Intro (implicit) | The list of non-animated examples (1, 6, 7) is complete | Example 8 (lnk_9) exists and is not mentioned | **wrong** (F1) |
| C1a | Case 1 heading | Quadratic, m=2 → `leastsqpolyaa.jl` / `.gif` | Script `m = 2`. The GIF title reads "Degree-2". 3 frames. | confirmed |
| C1b | Case 1 Behavior | Concave-down trend | a₂ = −0.0756 < 0 | confirmed |
| C1c | Case 1 Behavior | "all residuals below 0.1 in size" | Residuals p−y: +0.06391, −0.09180, −0.01405, +0.04873, +0.02306, −0.02986. max = 0.0918 | confirmed |
| C1d | Case 1 Behavior | "two largest are at the two leftmost points (x=−4.5 and x=−3.2)" | \|−0.0918\| at −3.2 and \|0.0639\| at −4.5 are the two largest. Next is 0.0487. | confirmed |
| C1e | Case 1 formula | $p_2=4.67425+0.52861x-0.07563x^2$, RMS ≈ 0.05245 | Exact: 4.674251, 0.528610, −0.0756344. RMS 0.0524514 | confirmed |
| C1f | Case 1 alt | Partial sums through x^0, x^1, x^2, ending with smooth concave-down fit | Frames 1–3 titles "through x^0/x^1/x^2". The last frame is the concave fit. | confirmed |
| C2a | Case 2 heading | Cubic, m=3 → `leastsqpolyab` | `m = 3`, title "Degree-3", 4 frames | confirmed |
| C2b | Case 2 Behavior | Adding the cubic term lowers RMS | 0.05245 → 0.02767 | confirmed |
| C2c | Case 2 Behavior | "tracks the left and right tails a bit more closely" | \|res\| at x=−4.5: 0.0639→0.0191. x=−3.2: 0.0918→0.0453. x=4.1: 0.0299→0.0117 | confirmed |
| C2d | Case 2 Behavior | "remaining stable across the plotted interval" | p₃ on [−5,4.5] ranges 0.031..5.613, monotone-ish, with no oscillation (frame 4) | confirmed |
| C2e | Case 2 formula | $4.66863+0.48939x-0.07424x^2+0.00268x^3$, RMS ≈ 0.02767 | Exact: 4.668626, 0.489392, −0.0742387, 0.0026766. RMS 0.0276732 | confirmed |
| C2f | Case 2 alt | x^0..x^3, final RMS lower than the quadratic's | 4 frames, titles x^0..x^3. 0.02767 < 0.05245 | confirmed |
| C3a | Case 3 heading | Quartic, m=4 → `leastsqpolyac` | `m = 4`, title "Degree-4", 5 frames | confirmed |
| C3b | Case 3 Behavior | "noticeably reduces residuals" | Every residual shrinks. Cubic \|r\| = .0191,.0453,.0306,.0140,.0301,.0117. Quartic \|r\| = .0022,.0071,.0105,.0106,.0066,.0015 | confirmed |
| C3c | Case 3 Behavior | follows curvature between middle and right-side points | Residuals at x=0.8, 2.5, 4.1 drop from .0140, .0301, .0117 to .0106, .0066, .0015 (qualitative claim) | confirmed |
| C3d | Case 3 Behavior | "RMS drops by about a factor of four compared with the cubic" | 0.0276732 / 0.0073400 = 3.77 | confirmed |
| C3e | Case 3 formula | $4.62863+0.49669x-0.05823x^2+0.00201x^3-0.00080x^4$, RMS ≈ 0.00734 | Exact: 4.628628, 0.496687, −0.0582343, 0.0020139, −0.00080138. RMS 0.0073400. Agrees with Mathews gr_66/gr_67. | confirmed |
| C3f | Case 3 alt | x^0..x^4, ending with close fit to all six points | 5 frames. max\|res\| = 0.0106 | confirmed |
| C4a | Case 4 heading | Quintic, m=5 → `leastsqpolyad` | `m = 5`, title "Degree-5", 6 frames | confirmed |
| C4b | Case 4 Behavior | Degree 5 on six distinct x interpolates; RMS exactly 0 | Exact rational solve: all residuals 0, RMS 0 | confirmed |
| C4c | Case 4 Behavior | "floating-point solve shows roundoff of about 8×10⁻¹⁵" | Script final_rms = 7.859e-15. The frame annotation reads "RMS(final) = 7.86e-15". | confirmed |
| C4d | Case 4 formula | $4.63232+0.50885x-0.06063x^2-0.00074x^3-0.00065x^4+0.00012x^5$ | Exact: 4.632324, 0.508854, −0.0606259, −0.00073781, −0.00065051, 0.00011667. Agrees with Mathews gr_74. | confirmed |
| C4e | Case 4 alt | x^0..x^5, ending with polynomial through all six points | 6 frames. The last frame's yhat is [0.7, 2.3, 3.8, 5.0, 5.5, 5.6]. | confirmed |
| W1 | Wiring | Each `[Julia source]` link and `![](…gif)` embed matches its case | aa/ab/ac/ad ↔ m=2/3/4/5 in both link and embed. The manifest reports all four committed GIFs byte-identical to fresh regenerations. | confirmed |

---

### 3. Implementation checks

All four scripts are the same code except for `m`, the curve colour and the output name (checked with `diff`). The checks below therefore apply to all four. Numbers are listed per script.

### (a) It is the method it claims to be
The scripts compute ordinary polynomial least squares in the monomial basis by forming and solving the normal equations (`(V'*V) \ (V'*y_data)`). This is exactly what the page's Description and Mathews' theorem describe. It is not QR or a pseudo-inverse. That is fine here, because the conditioning is mild: cond(VᵀV) = 3.8e2, 6.6e3, 2.3e5, 4.7e6 for m = 2..5, which costs at most about 7 digits and leaves more than 9 correct. The animation device (frame k = partial sum of the degree-m coefficients) is stated plainly on the page and in the script headers.

### (b) The numbers are right
I compared the script output (instrumented copies) with the independent exact rational computation (`indep.py`, sympy `LUsolve` on rational data).

| m | script coeffs | exact coeffs | script RMS | exact RMS | script max\|Vᵀr\| |
|---|---|---|---|---|---|
| 2 | 4.67425136543867, 0.5286095149615617, −0.07563440814242862 | 4.67425137, 0.52860951, −0.07563441 | 0.05245143450917267 | 0.05245143 | 3.2e-14 |
| 3 | 4.668626410745655, 0.4893924944444207, −0.07423866638351526, 0.0026765941096235962 | 4.66862641, 0.48939249, −0.07423867, 0.00267659 | 0.027673209944852083 | 0.02767321 | 1.0e-13 |
| 4 | 4.628628162388204, 0.4966872292746732, −0.05823430106748539, 0.0020139492184828756, −0.0008013781534538062 | 4.62862816, 0.49668723, −0.05823430, 0.00201395, −0.00080138 | 0.007339968009930619 | 0.00733997 | 2.6e-13 |
| 5 | 4.632323749813362, 0.508853540448049, −0.06062594253910825, −0.0007378096658431165, −0.0006505146090198225, 0.00011666987908697646 | 4.63232375, 0.50885354, −0.06062594, −0.00073781, −0.00065051, 0.00011667 | 7.86e-15 | 0 (exact) | 1.2e-12 |

Property checks:
- Residual orthogonality: Vᵀr = 0 exactly in rational arithmetic, and below 1.2e-12 in the scripts.
- Interpolation at m=5: all six fitted values equal the data.
- RMS decreases monotonically with m.

Partial-sum RMS per frame (the script annotation matches my exact value in every case). The degree-k LS RMS is in brackets.

| m | k=0 | k=1 | k=2 | k=3 | k=4 | k=5 |
|---|---|---|---|---|---|---|
| 2 | 1.99337 [1.79946] | 0.89688 [0.54048] | 0.05245 | | | |
| 3 | 1.99095 [1.79946] | 0.92296 [0.54048] | 0.13392 [0.05245] | 0.02767 | | |
| 4 | 1.97417 [1.79946] | 0.88548 [0.54048] | 0.22093 [0.05245] | 0.16715 [0.02767] | 0.00734 | |
| 5 | 1.97569 [1.79946] | 0.87789 [0.54048] | 0.17774 [0.05245] | 0.20267 [0.02767] | 0.10511 [0.00734] | 7.86e-15 |

### (c) Reference values
The page has no separate "exact" reference curve. The gray dashed curve is the script's own final fit, which (b) verifies. The RMS(final) annotation is the script's computed RMS, also verified in (b). For m=5 it shows 7.86e-15 where the exact value is 0, and the page explains this roundoff correctly. Mathews' own results agree where the archive images survive:
- Ex 2: p₂ = 4.67425 + 0.52861x − 0.0756344x², E₂ = 0.0524514
- Ex 4: p₄ coefficients as in gr_66, E = 0.00733997
- Ex 5: p₅ coefficients as in gr_74, E = 4.27e-14 ≈ 0 (Mathematica roundoff)

Example 3's images are missing from the archive, so I could not cross-check it, but the exact computation covers it.

### (d) The picture shows what was computed
I viewed the contact sheets of all four committed GIFs (3, 4, 5 and 6 frames = m+1). In each frame:
- The title "Degree-m LS fit: partial sum through x^k" matches k.
- The legend labels "final pm(x)" and "partial sum through x^k" match the plotted series.
- The orange stems run from each data point to the partial sum at that x (`yhat_data`), which is the right quantity.
- The RMS(partial) and RMS(final) annotations equal the values in (b).
- The last frame's solid curve coincides with the dashed curve.

Display devices:
- ylims = (0, 6.2) clips the k=1 partial line, which reaches 6.87–7.05 at x=4.5, and the stem at x=4.1, whose top is at yhat 6.67–6.84. The stem visibly runs off the top edge. The RMS shown is the true one, so this does not mislead.
- The final quartic and quintic dip slightly below 0 at the left edge (min −0.063 and −0.107 at x=−5, outside the data range [−4.5, 4.1]) and are clipped there. The page makes no claim about this region, and the clipped part is barely visible, so it is not a finding.
- xlims (−5, 4.5) contains all data.

The manifest reports that a fresh run of each unchanged script reproduces the committed GIF byte for byte.

**Verdict for all four scripts:** the method is correct, the numbers are correct, the reference values are correct, and the picture is faithful.

