# Least Squares Polynomials — animation review (round 4)

Page: `pages/numerical-methods/least-squares-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor issue.

Observations that do not rise to findings:
- The frames draw thin orange vertical residual segments from each data point to the partial sum. The page's description of the diagram ("blue points … gray dashed … solid colored curve") does not mention them. This is an omission rather than a false statement. The segments are self-explanatory alongside the RMS(partial) annotation.
- The y-window `(0, 6.2)` clips the k = 1 lines at the right, and the clipped residual segment at x = 4.1 has a true end at 6.84 or so. It also clips the final quartic and quintic for x < about −4.9, where p4(−5) = −0.063 and p5(−5) = −0.107. Neither clip affects anything the page says.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `leastsqpolyaa.jl` | 0 | 8.1 | leastsqpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyab.jl` | 0 | 8.6 | leastsqpolyab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyac.jl` | 0 | 8.7 | leastsqpolyac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyad.jl` | 0 | 7.9 | leastsqpolyad.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description | $p_m$ minimizes $E=\sum(p_m(x_i)-y_i)^2$; the normal equations $(V^TV)\mathbf a=V^T\mathbf y$, with V the Vandermonde-style design matrix | Script lines 18–19: `V = [x^j for x, j in 0:m]`, `coeffs = (V'V)\(V'y)` | confirmed |
| D2 | Description | The RMS formula $\sqrt{\frac1n\sum(\cdot)^2}$ | Script line 30 uses the same formula | confirmed |
| D3 | Description | Six data points (−4.5,0.7), (−3.2,2.3), (−1.4,3.8), (0.8,5.0), (2.5,5.5), (4.1,5.6) | Script lines 16–17; archive gr_38 and gr_120 | confirmed |
| D4 | Description | "As the degree increases from 2 to 5, RMS decreases" | Exact RMS values 0.0524514, 0.0276732, 0.00733997, 0 | confirmed |
| D5 | Description | High-degree fits can wiggle and extrapolate poorly | A general statement. The archive's Example 6 graph on [−10,10] shows the fits separating. The animations do not claim to show this | confirmed (general) |
| A1 | Intro | Each animation draws the degree-m LS polynomial one partial sum at a time, for the same dataset | `@animate for k in 0:m`, `partial_eval` sums the first k+1 coefficients; same data in all four scripts (the only diffs are m, colour and filename) | confirmed |
| A2 | Intro | Blue points = data; gray dashed = fitted $p_m$; solid coloured = partial sum, with k increasing frame by frame | Script lines 43–45; frames | confirmed |
| A3 | Intro | Only the last frame (k=m) is a least-squares fit | Partial-sum RMS exceeds the degree-k LS RMS at every k<m (see A6) | confirmed |
| A4 | Intro | The degree-0 fit is the mean 3.8167 | mean(y) = 3.816667 | confirmed |
| A5 | Intro | $a_0$ ranges from 4.629 to 4.674 across the four cases | a0 = 4.674251, 4.668626, 4.628628, 4.632324 | confirmed |
| A6 | Intro | Every earlier partial sum has a larger RMS than the degree-k LS fit | LS RMS at k=0,1,2,3,4: 1.79946, 0.54048, 0.05245, 0.02767, 0.00734. Partial sums: k=0 1.9934/1.9910/1.9742/1.9757; k=1 0.8969/0.9230/0.8855/0.8779; k=2 0.1339/0.2209/0.1777; k=3 0.1672/0.2027; k=4 0.1051. All are larger | confirmed |
| A7 | Intro | Partial-sum RMS need not fall: in Case 4 it rises from 0.17774 at k=2 to 0.20267 at k=3 | Julia 0.17773541 and 0.20267468; sympy 0.177735 and 0.202675. Frames show 0.17774 and 0.20267 | confirmed |
| A8 | Intro | The scripts compute the coefficients from the normal equations | Line 19 | confirmed |
| A9 | Intro | The four cases are Mathews Examples 2–5 (quadratic, cubic, quartic, quintic, same six points) | Archive lnk_3..lnk_6; gr_38 data; gr_49–51, 65–67, 73–75 coefficients and RMS match | confirmed |
| A10 | Intro | Example 1 fits an LS parabola to a different set of points | Archive gr_10: (−1,10), (0,9), …, (6,−1) and XY {(−1,10),(0,6),…} | confirmed |
| A11 | Intro | Example 6's graph plots the quadratic-to-quintic fits together on a wide interval, showing them separate outside the data | Archive lnk_7, gr_84 `PlotRange {{-10,10},{-20,9}}`, graph gr_85 | confirmed |
| A12 | Intro | Example 7 fits the same degrees to points sampled from a non-polynomial function (wiggle) | Archive lnk_8 text ("points were obtained from … which is not polynomial"); data gr_86 (0.25,23.1),… | confirmed |
| A13 | Intro | Example 8 recomputes the cubic for the same six points via the general linear LS theorem | Archive lnk_9 text plus gr_120 (same six points) | confirmed |
| C1-h | Case 1 heading | Quadratic, m=2 → `leastsqpolyaa.jl` / `.gif` | Script m=2; 3 frames; titles "Degree-2" | confirmed |
| C1-a | Case 1 Behavior | All residuals below 0.1 in size; the two largest at x=−4.5 and x=−3.2 | Residuals +0.06391, −0.09180, −0.01405, +0.04873, +0.02306, −0.02986 | confirmed |
| C1-b | Case 1 Behavior | Captures the concave-down trend | a2 = −0.0756 < 0 | confirmed |
| C1-c | Case 1 Behavior | "the baseline smooth fit used in the module" | Example 2 is the first of the module's degree sequence | confirmed (loose wording) |
| C1-d | Case 1 formula | $p_2=4.67425+0.52861x-0.07563x^2$, RMS≈0.05245 | Exact 4.674251, 0.528610, −0.075634; RMS 0.0524514. Julia identical; archive 4.67425+0.52861x−0.0756344x², 0.0524514 | confirmed |
| C1-alt | Case 1 alt | Partial sums through x^0, x^1, x^2, ending with the smooth concave-down fit | Frames 1–3 | confirmed |
| C2-h | Case 2 heading | Cubic, m=3 → `leastsqpolyab` | m=3; 4 frames | confirmed |
| C2-a | Case 2 Behavior | Lowers RMS | 0.05245 → 0.02767 | confirmed |
| C2-b | Case 2 Behavior | Tracks the left and right tails a bit more closely | Residual at x=−4.5: 0.0639→0.0191; at x=4.1: −0.0299→0.0117 | confirmed |
| C2-c | Case 2 Behavior | Stable across the plotted interval | p3 on [−5,4.5] is smooth and monotone near the edges, ranging from 0.031 to 5.613; last frame | confirmed |
| C2-d | Case 2 formula | $4.66863+0.48939x-0.07424x^2+0.00268x^3$, RMS≈0.02767 | Exact 4.668626, 0.489392, −0.074239, 0.0026766; RMS 0.0276732 (archive 0.0276732) | confirmed |
| C2-alt | Case 2 alt | Ends with a cubic whose RMS is lower than the quadratic's | 0.02767 < 0.05245 | confirmed |
| C3-h | Case 3 heading | Quartic, m=4 → `leastsqpolyac` | m=4; 5 frames | confirmed |
| C3-a | Case 3 Behavior | Noticeably reduces residuals | max\|r\| 0.0453 → 0.0106 | confirmed |
| C3-b | Case 3 Behavior | Follows the subtle curvature changes between middle and right-side points | Residuals at x=0.8, 2.5, 4.1 go from (0.0140, −0.0301, 0.0117) to (−0.0106, 0.0065, −0.0015). The wording is qualitative; the numbers are consistent with it | confirmed (qualitative) |
| C3-c | Case 3 Behavior | RMS drops by about a factor of four versus the cubic | 0.0276732 / 0.00733997 = 3.77 | confirmed |
| C3-d | Case 3 formula | $4.62863+0.49669x-0.05823x^2+0.00201x^3-0.00080x^4$, RMS≈0.00734 | Exact 4.628628, 0.496687, −0.058234, 0.0020139, −0.00080138; RMS 0.00733997 (archive matches) | confirmed |
| C3-alt | Case 3 alt | Ends with a close fit to all six points | Last frame; max\|r\| 0.0106 | confirmed |
| C4-h | Case 4 heading | Quintic, m=5 → `leastsqpolyad` | m=5; 6 frames | confirmed |
| C4-a | Case 4 Behavior | Six distinct x and degree 5, so the fit interpolates and RMS is exactly 0 | The exact rational solve gives residuals that are identically 0 | confirmed |
| C4-b | Case 4 Behavior | The animation's floating-point solve shows roundoff of about 8e−15 | Julia final_rms = 7.859e−15; frame shows "7.86e-15" | confirmed |
| C4-c | Case 4 formula | $4.63232+0.50885x-0.06063x^2-0.00074x^3-0.00065x^4+0.00012x^5$, RMS=0 | Exact 4.632324, 0.508854, −0.060626, −0.00073781, −0.00065051, 0.00011667 (archive identical) | confirmed |
| C4-alt | Case 4 alt | Ends with the polynomial through all six data points | Frame 6 | confirmed |
| W1 | Wiring | Links and embeds aa/ab/ac/ad match Cases 1–4 | Page markdown; each script's m; the manifest's byte-identical regeneration | confirmed |
| W2 | Counts | Implied frame count m+1 per case (k = 0..m) | 3, 4, 5 and 6 frames (manifest and contact sheets) | confirmed |

### 3. Implementation checks

All four scripts are identical except for `m`, the curve colour and the output filename (checked with `diff`). So the checks below apply to each script, and the per-case numbers are in the ledger.

**Is it the method claimed?** Yes. It is the least-squares polynomial in the monomial basis, found by solving the normal equations `(V'V) a = V'y` with Julia's `\` (LU on the square Gram matrix). This is the formulation in the page's Description and in Mathews' theorem. The partial-sum animation device is labelled clearly in the frame titles, the legend and the page intro.

**Are the numbers right?** Yes. Independent exact rational solves (`review/indep.py`, sympy `(V^TV).solve(V^Ty)`) and numpy `polynomial.polyfit` (QR-based least squares) agree with the instrumented Julia output to every printed digit.

| m | Julia coefficients (instrumented) | Exact (sympy) | Julia RMS | Exact RMS |
|---|---|---|---|---|
| 2 | 4.67425137, 0.52860951, −0.07563441 | 4.67425137, 0.52860951, −0.07563441 | 0.0524514345 | 0.052451435 |
| 3 | 4.66862641, 0.48939249, −0.07423867, 0.00267659 | identical to 8 d.p. | 0.0276732099 | 0.02767321 |
| 4 | 4.62862816, 0.49668723, −0.05823430, 0.00201395, −0.00080138 | identical | 0.0073399680 | 0.007339968 |
| 5 | 4.63232375, 0.50885354, −0.06062594, −0.00073781, −0.00065051, 0.00011667 | identical | 7.86e−15 | 0 |

- Orthogonality property: the Julia `V'(Va−y)` is 1e−16 to 1e−12 in every case. That is roundoff relative to Gram entries up to about 3e6, so the residual is orthogonal to the basis. In the exact solve it is exactly 0.
- Interpolation property (m=5): the exact residuals are all 0. Julia's are ≤1.5e−14.
- Conditioning: cond(V'V) is 3.8e2, 6.6e3, 2.3e5 and 4.7e6 for m = 2 to 5 (`review/cond.txt`). Squaring the condition number through the normal equations costs at most about 7 digits at m=5, which is far below the 5 significant figures the page quotes. The match with the QR/exact results confirms this.

**Reference values.** There is no separate "exact" curve. The gray dashed "final p_m" is the same coefficient vector evaluated on a 500-point grid, so it is correct for the reasons above. The archive values (Mathematica `Fit`) agree with the script and the page.

**Does the picture show what was computed?** Yes. I viewed every frame of all four committed GIFs through the contact sheets. In each frame:
- the title index k matches the partial sum drawn, for example a k=0 horizontal line at a0 ≈ 4.67 / 4.67 / 4.63 / 4.63
- the k=1 line has slope a1 and its partial-sum RMS matches
- the RMS(partial) annotation equals the instrumented per-frame value: 1.99337, 0.89688, 0.05245 for aa; 1.99095, 0.92296, 0.13392, 0.02767 for ab; 1.97417, 0.88548, 0.22093, 0.16715, 0.00734 for ac; 1.97569, 0.87789, 0.17774, 0.20267, 0.10511, 7.86e−15 for ad
- RMS(final) is constant and correct
- the last frame's solid curve coincides with the dashed final curve.

The committed GIFs are byte-identical to fresh regenerations (manifest). The axis clipping noted under Findings is cosmetic and does not affect any conclusion.

**Legacy fidelity.** I consulted the archive. Examples 2–5 (the same six points, degrees 2–5, coefficients and RMS) are reproduced exactly. Examples 1, 6, 7 and 8 are not animated, and the page says so explicitly and describes them accurately (A10–A13). I found no silent departure.

