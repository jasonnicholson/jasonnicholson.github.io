# Least Squares Polynomials — animation review (round 8)

Page: `pages/numerical-methods/least-squares-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** 0 Error, 0 Misleading, 0 Minor.

Observations I checked and judged not to be findings:
- In each k=1 frame the partial-sum line leaves the top of the window (its value at x=4.5 is 6.86 to 7.05, against ylims 0 to 6.2). The final fits dip slightly below y=0 at x=-5 (as low as -0.107 for the quintic). This clipping is cosmetic. The k=1 RMS annotation is still correct and nothing the page says depends on the clipped part.
- The orange residual segments are not described in the page text or the legend. That is content the page does not have, not a false claim.
- The page leaves out archive Examples 1, 6 (graph), 7 and 8, but it lists each one and says it is not animated. I checked each of those descriptions against the archive (see the ledger), so these are not silent drops.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `leastsqpolyaa.jl` | 0 | 8.3 | leastsqpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyab.jl` | 0 | 8.8 | leastsqpolyab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyac.jl` | 0 | 8.4 | leastsqpolyac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | p_m(x)=a0+...+am x^m minimizes E=Σ(p_m(x_i)-y_i)^2 | standard definition. The scripts minimize this E | confirmed |
| D2 | Normal equations (V^T V)a = V^T y, V Vandermonde-style | script lines 18-19: `V=[x^j ...]`, `coeffs=(V'*V)\(V'*y_data)` | confirmed |
| D3 | RMS = sqrt((1/n)Σ(p_m(x_i)-y_i)^2) | script line 30 uses exactly this. Mathews's E_2 for the quadratic is 0.0524514, which equals my 0.0524514345 with 1/n | confirmed |
| D4 | Six data points (-4.5,0.7),(-3.2,2.3),(-1.4,3.8),(0.8,5.0),(2.5,5.5),(4.1,5.6) | script lines 16-17. Archive gr_38 and gr_41 | confirmed |
| D5 | "As the degree increases from 2 to 5, RMS decreases" | exact RMS 0.0524514, 0.0276732, 0.0073400, 0 | confirmed |
| D6 | High-degree fits can wiggle and extrapolate poorly | general statement. Archive gr_85 shows the fits separating outside [-4.5,4.1] | confirmed (general) |
| A1 | Each animation draws the degree-m LS polynomial one partial sum at a time, same dataset | script loop `for k in 0:m`, `partial_eval` sums c[1..k+1]. Same x_data and y_data in all four scripts (diff shows only m, colour and filenames differ) | confirmed |
| A2 | Blue points = data. Gray dashed = fitted p_m. Solid coloured = partial sum a0+...+ak x^k, k increasing per frame | script lines 43-45. Frames of all four GIFs | confirmed |
| A3 | Only the last frame (k=m) is a LS fit. Earlier partial sums are not degree-k LS fits | the partial-sum RMS is strictly larger than the degree-k LS RMS for every k<m (see A6) | confirmed |
| A4 | The degree-0 fit is the mean 3.8167 | mean = 3.816667 | confirmed |
| A5 | a0 ranges from 4.629 to 4.674 across the four cases | a0 = 4.674251, 4.668626, 4.628628, 4.632324. Min 4.6286 and max 4.6743 | confirmed |
| A6 | Each earlier partial sum has a larger RMS than the degree-k LS fit | degree-k LS RMS for k=0..4 is 1.79946, 0.54048, 0.05245, 0.02767, 0.00734. Partial-sum RMS: k=0 1.97417 to 1.99337. k=1 0.87789 to 0.92296. k=2 0.13392, 0.22093, 0.17774. k=3 0.16715, 0.20267. k=4 0.10511. All are larger | confirmed |
| A7 | Case 4 partial RMS rises from 0.17774 (k=2) to 0.20267 (k=3) | exact 0.1777354, 0.2026747. Script 0.17774, 0.20267 | confirmed |
| A8 | Scripts compute the coefficients from the normal equations | lines 18-19 | confirmed |
| A9 | Cases animate Mathews Examples 2-5 (quadratic to quintic on these six points) | archive lnk_3..lnk_6: degrees 2,3,4,5 on the same points | confirmed |
| A10 | Ex. 1 fits a LS parabola to a different set of points | archive gr_10: (-1,10),(0,9),...,(6,-1) | confirmed |
| A11 | Ex. 6 graph plots the quadratic to quintic fits together on an interval wide enough to show them separating | archive lnk_7, gr_85 (x from -10 to 10, curves diverge outside the data) | confirmed |
| A12 | Ex. 7 fits the same degrees to points from a non-polynomial function (wiggle) | archive lnk_8 text: "points were obtained from ... which is not polynomial" | confirmed |
| A13 | Ex. 8 recomputes the cubic for the same six points by the linear least-squares theorem | archive lnk_9 text and gr_120 (same six points, degree 3) | confirmed |
| C1a | Case 1 heading m=2. The link and embed are leastsqpolyaa | the script has m=2. The GIF title says "Degree-2" | confirmed |
| C1b | Quadratic is concave-down | a2 = -0.0756 < 0 | confirmed |
| C1c | All residuals below 0.1 in size | residuals 0.06391, -0.09180, -0.01405, 0.04873, 0.02306, -0.02986. Max 0.0918 | confirmed |
| C1d | The two largest residuals are at x=-4.5 and x=-3.2 | sizes 0.0918 (x=-3.2) and 0.0639 (x=-4.5). The next largest is 0.0487 | confirmed |
| C1e | p2 = 4.67425 + 0.52861x - 0.07563x^2 | exact 4.6742514, 0.5286095, -0.0756344. Archive gr_50 has the same | confirmed |
| C1f | RMS ≈ 0.05245 | 0.0524514 | confirmed |
| C1g | Alt text: partial sums through x^0, x^1, x^2, ending with a smooth concave-down curve | 3 frames, titles "through x^0..x^2" | confirmed |
| C2a | Case 2 m=3. Link and embed are leastsqpolyab | script m=3. GIF title "Degree-3" | confirmed |
| C2b | Cubic lowers RMS | 0.02767 < 0.05245 | confirmed |
| C2c | Tracks the left and right tails a bit more closely | residuals at x=-4.5: 0.064 to 0.019. At x=-3.2: -0.092 to -0.045. At x=4.1: -0.030 to 0.012 | confirmed |
| C2d | Stays stable across the plotted interval | final frame: smooth, monotone rise to a flat top, no wiggle in [-5,4.5] | confirmed |
| C2e | p3 = 4.66863 + 0.48939x - 0.07424x^2 + 0.00268x^3 | exact 4.6686264, 0.4893925, -0.0742387, 0.0026766 | confirmed |
| C2f | RMS ≈ 0.02767 | 0.0276732 | confirmed |
| C2g | Alt text: partial sums through x^0..x^3, final RMS lower than the quadratic's | 4 frames. 0.02767 < 0.05245 | confirmed |
| C3a | Case 3 m=4. Link and embed are leastsqpolyac | script m=4. GIF title "Degree-4" | confirmed |
| C3b | Noticeably reduces residuals | max size 0.0453 (cubic) to 0.0106 (quartic). Every residual is smaller | confirmed |
| C3c | Follows the subtle curvature between the middle and right-side points | residuals at x=0.8, 2.5, 4.1 go from 0.0140, -0.0301, 0.0117 to -0.0106, 0.0065, -0.0015. Qualitative, but consistent with the numbers | confirmed (qualitative) |
| C3d | RMS drops by about a factor of four from the cubic | 0.0276732/0.0073400 = 3.77 | confirmed |
| C3e | p4 = 4.62863 + 0.496687x - 0.0582343x^2 + 0.00201395x^3 - 0.000801378x^4 | exact 4.6286282, 0.49668723, -0.058234301, 0.0020139492, -0.00080137815 | confirmed |
| C3f | RMS ≈ 0.00734 | 0.00733997 | confirmed |
| C3g | Alt text: partial sums x^0..x^4, close fit to all six points | 5 frames. Max residual 0.0106 | confirmed |
| C4a | Case 4 m=5. Link and embed are leastsqpolyad | script m=5. GIF title "Degree-5" | confirmed |
| C4b | Six distinct x and degree 5, so it interpolates and RMS is exactly 0 | exact rational solve gives residuals and RMS of exactly 0 | confirmed |
| C4c | The floating-point solve shows roundoff of about 8e-15 | script final_rms = 7.859e-15, frame annotation "7.86e-15" | confirmed |
| C4d | p5 coefficients 4.63232, 0.508854, -0.0606259, -0.000737810, -0.000650515, 0.000116670 (6 s.f.) | exact 4.6323237, 0.50885354, -0.060625943, -0.00073780967, -0.00065051461, 0.00011666988. All correctly rounded to 6 s.f. Archive gr_74 has the same | confirmed |
| C4e | A degree n-1 polynomial can match n distinct points. Fragile for extrapolation | general statement (archive lnk_7 warning, gr_85) | confirmed (general) |
| C4f | Alt text: partial sums x^0..x^5, ending through all six points | 6 frames. Last frame passes through every point | confirmed |

### 3. Implementation checks

The four scripts are identical except for `m`, the line colour and the filenames (diff run against leastsqpolyaa.jl). The manifest reports that a scratch run of each script reproduces its committed GIF byte for byte, so the committed GIFs are this code's output.

**Method.** Each script builds the polynomial design matrix V (n×(m+1), entries x_i^j) and solves the normal equations (V'V)a = V'y with `\`. This is least-squares polynomial fitting by the normal equations, as the page and the archive describe. Frame k draws the partial sum of the degree-m coefficients, and both the page and the script header say plainly that these partial sums are not degree-k fits.

**Numbers.** Script output (instrumented copy) next to the exact rational solve:

| m | script coeffs | exact coeffs | script RMS | exact RMS |
|---|---|---|---|---|
| 2 | 4.67425136543867, 0.5286095149615617, -0.07563440814242862 | 4.674251365438670, 0.528609514961562, -0.075634408142429 | 0.05245143450917267 | 0.052451434509173 |
| 3 | 4.668626410745655, 0.4893924944444207, -0.07423866638351526, 0.0026765941096236 | 4.668626410745656, 0.489392494444422, -0.074238666383515, 0.002676594109624 | 0.027673209944852 | 0.027673209944852 |
| 4 | 4.628628162388204, 0.4966872292746732, -0.0582343010674854, 0.0020139492184829, -0.0008013781534538 | 4.628628162388194, 0.496687229274676, -0.058234301067481, 0.002013949218483, -0.000801378153454 | 0.007339968009931 | 0.007339968009931 |
| 5 | 4.632323749813362, 0.508853540448049, -0.06062594253910825, -0.0007378096658431, -0.0006505146090198, 0.00011666987908698 | 4.632323749813375, 0.508853540448057, -0.060625942539114, -0.000737809665845, -0.000650514609020, 0.000116669879087 | 7.86e-15 | 0 |

Partial-sum RMS per frame (script compared with exact): agreement to at least 12 digits in every frame. For example, m=5: 1.975690267436404 / 1.9756902674364096, 0.8778947251114891 / 0.8778947251114921, 0.17773540952732633 / 0.17773540952726585, 0.2026746761661765 / 0.20267467616618282, 0.10510530104223006 / 0.1051053010423025.

Property checks:
- The residual is orthogonal to the basis. Exact V^T r = 0 for every m. In floating point, script V'r has sizes from 4e-16 up to 1.2e-12 (the largest is the x^5 column for m=5), which is consistent with cond(V'V) = 382, 6.6e3, 2.3e5 and 4.7e6 for m=2..5.
- The quintic interpolates the data. Exact residuals are 0, and the floating-point residuals are at most 1.4e-14.
- The archive's Mathematica coefficients (gr_50 for m=2, gr_74 for m=5) and its E_2 = 0.0524514 agree with these.
- The conditioning of the normal equations at m=5 (4.7e6) costs at most about 6 of 16 digits. The coefficients agree with the exact values to about 13 significant digits, which is far more than any value the page quotes needs.

**Reference values.** These scripts plot no separate "exact" curve. The gray dashed "final p_m" is the computed fit itself, and it is correct as shown above.

**Picture.** I checked the contact sheets of all four committed GIFs (3, 4, 5 and 6 frames, which is m+1 each). In every frame:
- the title gives the right degree and k;
- the legend reads "final p_m(x)" for the right m;
- the solid curve is the k-th partial sum: a horizontal line at a0 for k=0, a straight line for k=1, and so on;
- the dashed gray curve is the full fit;
- the orange segments join each data point to the partial sum at that x;
- the RMS(partial) and RMS(final) annotations equal the computed values to the digits shown.

In the last frame of each GIF the solid curve covers the dashed one and passes through or near every point. The display limits clip the k=1 line at the top and the final curves just below y=0 near x=-5. This does not hide anything the page discusses.

