# Least Squares Polynomials — animation review (round 6)

Page: `pages/numerical-methods/least-squares-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my independent computation and with the frames. The four scripts run the stated method and compute correct values.

Observations below the finding threshold. They are recorded here so the clean result can be audited, and are not proposed as corrections.
- In frame k=1 of every GIF the partial-sum line leaves the top of the window. The window is `ylims = (0.0, 6.2)` and the line peaks between 6.86 and 7.05 at x=4.5. The orange residual segment at x=4.1, whose fitted end lies between 6.68 and 6.84, is cut off at the top edge. The RMS annotation is computed from the unclipped values and is correct, and a viewer can see that the line runs off the plot. Nothing the page says depends on the clipped part.
- The final p4 and p5 dip just below y=0 near x=-5 (minima -0.063 and -0.107) and are clipped there. This is outside the data range and immaterial.
- The orange vertical residual segments are not mentioned in the page's description of the diagram. This is an omission, not a false statement.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `leastsqpolyaa.jl` | 0 | 7.9 | leastsqpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyab.jl` | 0 | 7.7 | leastsqpolyab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyac.jl` | 0 | 9.1 | leastsqpolyac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyad.jl` | 0 | 8.7 | leastsqpolyad.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Data used throughout: x = (-4.5, -3.2, -1.4, 0.8, 2.5, 4.1), y = (0.7, 2.3, 3.8, 5.0, 5.5, 5.6), identical in the page, the scripts (line 16–17) and Mathews (image gr_38).

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | LS polynomial $p_m(x)=a_0+\dots+a_mx^m$ minimizes $E=\sum (p_m(x_i)-y_i)^2$ | Standard. The script solves exactly this problem; see I-checks. | confirmed |
| D2 | Setting the partials to zero gives the normal equations $(V^TV)\mathbf a=V^T\mathbf y$, with $V$ the Vandermonde-style design matrix | Script line 18 builds `V = [x^j for x, j in 0:m]` and line 19 solves `(V'V)\(V'y)`. The residual is orthogonal to the columns of V, exactly in rational arithmetic and to about 1e-12 in the script (`V'r`). | confirmed |
| D3 | RMS $=\sqrt{\frac1n\sum(p_m(x_i)-y_i)^2}$ | Script line 30 uses the same formula with n=6. | confirmed |
| D4 | The six data points listed | They match script lines 16–17 and Mathews gr_38. | confirmed |
| D5 | "As the degree increases from 2 to 5, RMS decreases" | Exact RMS values are 0.0524514, 0.0276732, 0.00733997 and 0. | confirmed |
| D6 | High-degree fits can wiggle and extrapolate poorly | This is a general caution, hedged with "can". Mathews' Example 6 graph (gr_85, on [-10,10]) shows the fits separating outside the data. | confirmed (general statement) |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Each animation draws the degree-m LS polynomial one partial sum at a time, for the same dataset | `@animate for k in 0:m` with `partial_eval(x, coeffs, k)`. The titles in the frames read "partial sum through x^k". | confirmed |
| A2 | Blue points = data; gray dashed = fitted $p_m$; solid coloured = partial sum $a_0+\dots+a_kx^k$ | Script lines 43–45, and the frames (royalblue markers, gray45 dashed curve, solid curve coloured per case). | confirmed |
| A3 | k increases frame by frame; only the last frame (k=m) is an LS fit | There are k=0..m frames. The partial sums for k<m are not LS fits: for example, at k=0 the partial sum is a0 ≈ 4.63–4.67, while the LS constant is 3.81667. | confirmed |
| A4 | Lowering the degree changes every coefficient | The exact coefficient vectors for m=2..5 (see I-checks) differ in every position. | confirmed |
| A5 | "the degree-0 fit is the mean 3.8167" | Exact value 3.816666… (mean of y). | confirmed |
| A6 | "$a_0$ ranges from 4.629 to 4.674 across the four cases" | a0 = 4.674251, 4.668626, 4.628628, 4.632324, so the minimum is 4.62863 (rounds to 4.629) and the maximum is 4.67425 (rounds to 4.674). | confirmed |
| A7 | Each earlier partial sum has a larger RMS than the degree-k LS fit | The LS RMS by degree is k=0: 1.79946, k=1: 0.54048, k=2: 0.05245, k=3: 0.02767, k=4: 0.00734. Partial-sum RMS: m=2 gives 1.99337, 0.89688. m=3 gives 1.99095, 0.92296, 0.13392. m=4 gives 1.97417, 0.88548, 0.22093, 0.16715. m=5 gives 1.97569, 0.87789, 0.17774, 0.20267, 0.10511. All 14 pairs are larger. | confirmed |
| A8 | The partial-sum RMS need not fall as terms are added; in Case 4 it rises from 0.17774 at k=2 to 0.20267 at k=3 | Script values are 0.1777354095 and 0.2026746762. The exact values are 0.177735 and 0.202675. The frames show "RMS(partial) = 0.17774" and "0.20267". | confirmed |
| A9 | The Julia scripts compute the coefficients from the normal equations | Script line 19. | confirmed |
| A10 | The four cases animate Mathews' Examples 2–5 (LS quadratic, cubic, quartic, quintic for the six points) | Archive lnk_3..lnk_6: Examples 2–5 are degree 2, 3, 4, 5 for the points in gr_38 (the same six). | confirmed |
| A11 | Example 1 fits an LS parabola to a different set of points | Archive gr_10 gives the points (-1,10),(0,9),(1,7),(2,5),(3,4),(4,3),(5,0),(6,-1), with the "least squares parabola". | confirmed |
| A12 | The graph in Example 6 plots quadratic to quintic together on a wide interval showing separation outside the data | Archive lnk_7: Example 6 asks "Why is the RMS error for [p5] essentially zero?". Its second graph (gr_85) plots the fits on [-10,10], and they separate outside the data. The page describes only the graph, and the question itself is answered by Case 4's Behavior. | confirmed |
| A13 | Example 7 fits the same degrees to points sampled from a non-polynomial function | Archive lnk_8 fits degrees 2–5 to the points in gr_86, which "were obtained from [f] which is not polynomial". | confirmed |
| A14 | Example 8 recomputes the cubic for the same six points by the general linear LS theorem | Archive lnk_9: degree 3, "linear least squares method", with points gr_120 identical to gr_38. | confirmed |
| A15 | Examples 1, 6, 7, 8 are not animated | Only 4 scripts and 4 GIFs exist, for m=2..5. | confirmed |

### Case 1, m=2 (`leastsqpolyaa.jl`, `leastsqpolyaa.gif`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading m=2 | Script `m = 2`. The frame titles read "Degree-2 LS fit". | confirmed |
| C1.2 | Concave-down trend | a2 = -0.0756344 < 0. | confirmed |
| C1.3 | All residuals below 0.1 in size | The residuals p−y are +0.063912, −0.091795, −0.014045, +0.048733, +0.023060 and −0.029864, so the largest is 0.0918. | confirmed |
| C1.4 | The two largest residuals are at x=-4.5 and x=-3.2 | They are 0.0918 at x=-3.2 and 0.0639 at x=-4.5, and the next largest is 0.0487. | confirmed |
| C1.5 | $p_2=4.67425+0.52861x-0.07563x^2$ | Exact coefficients are 4.6742514, 0.5286095, −0.0756344. The script and Mathews (gr_49–51: 4.67425 + 0.52861x − 0.0756344x²) agree. | confirmed |
| C1.6 | RMS ≈ 0.05245 | Exact 0.0524514. The script and the frame show 0.05245, and Mathews gives 0.0524514. | confirmed |
| C1.7 | Link and embed point to `leastsqpolyaa.jl` and `leastsqpolyaa.gif` | Both files are this case, and the GIF reproduces byte-identically (manifest). | confirmed |
| C1.8 | Alt text: partial sums through x^0, x^1, x^2, ending with the smooth concave-down fit | The GIF has 3 frames whose titles are x^0, x^1, x^2. The last frame matches the final curve. | confirmed |

### Case 2, m=3 (`leastsqpolyab`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading m=3 | Script `m = 3`. The frame titles read "Degree-3". | confirmed |
| C2.2 | Adding the cubic term lowers RMS | RMS falls from 0.0524514 to 0.0276732. | confirmed |
| C2.3 | Tracks left and right tails a bit more closely | Residuals at x=-4.5 go from 0.0639 to 0.0191, at x=-3.2 from 0.0918 to 0.0453, and at x=4.1 from 0.0299 to 0.0117. At x=2.5 the residual grows from 0.0231 to 0.0301, but the two end points and both left points improve. | confirmed (soft wording, holds at the tails) |
| C2.4 | Remains stable across the plotted interval | On [-5, 4.5] p3 ranges from 0.031 to 5.613 and is smooth, with no oscillation (frame 4). | confirmed |
| C2.5 | $p_3=4.66863+0.48939x-0.07424x^2+0.00268x^3$ | Exact coefficients are 4.6686264, 0.4893925, −0.0742387, 0.0026766. Mathews' Example 3 result images (gr_57–59) are absent from the archive, so the comparison is with my computation only. | confirmed |
| C2.6 | RMS ≈ 0.02767 | Exact 0.0276732, and the frame shows 0.02767. | confirmed |
| C2.7 | Wiring | `leastsqpolyab.jl` and `.gif` are this case. | confirmed |
| C2.8 | Alt text: x^0 to x^3, RMS lower than the quadratic's | 4 frames. 0.02767 < 0.05245. | confirmed |

### Case 3, m=4 (`leastsqpolyac`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C3.1 | Heading m=4 | Script `m = 4`. The frame titles read "Degree-4". | confirmed |
| C3.2 | Noticeably reduces residuals | The residuals are 0.00216, 0.00711, 0.01052, 0.01059, 0.00655 and 0.00152, each smaller than the cubic's 0.0191, 0.0453, 0.0306, 0.0140, 0.0301 and 0.0117. | confirmed |
| C3.3 | Follows the subtle curvature changes between middle and right-side points | This is qualitative. The quartic's curvature p4'' is -0.366 at x=-4.5, -0.116 at x=0 and -0.229 at x=4.1, so it is non-monotone, while the cubic's curvature is monotone. The residuals at x=0.8, 2.5 and 4.1 all fall. The claim is consistent with this, though it is too loose to test precisely. | confirmed (qualitative) |
| C3.4 | RMS drops by about a factor of four vs the cubic | 0.0276732 / 0.00733997 = 3.77. | confirmed |
| C3.5 | $p_4=4.62863+0.49669x-0.05823x^2+0.00201x^3-0.00080x^4$ | Exact coefficients are 4.6286282, 0.4966872, −0.0582343, 0.0020139, −0.0008014. Mathews' gr_65 gives the same values. | confirmed |
| C3.6 | RMS ≈ 0.00734 | Exact 0.00733997, and the frame shows 0.00734. Mathews gives 0.00733997. | confirmed |
| C3.7 | Wiring | `leastsqpolyac.jl` and `.gif` are this case. | confirmed |
| C3.8 | Alt text: x^0 to x^4, close fit to all six points | 5 frames, and the largest residual in the last frame is 0.0106. | confirmed |

### Case 4, m=5 (`leastsqpolyad`)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C4.1 | Heading m=5 | Script `m = 5`. The frame titles read "Degree-5". | confirmed |
| C4.2 | With 6 distinct x and degree 5 the LS polynomial interpolates, so RMS is exactly 0 | In exact rational arithmetic all six residuals are exactly 0. | confirmed |
| C4.3 | The floating-point solve shows roundoff of about 8e-15 | The script's `final_rms` is 7.859e-15, and the frames show "RMS(final) = 7.86e-15". | confirmed |
| C4.4 | A degree n−1 polynomial can match n distinct points, but may be fragile for extrapolation | A standard fact. Mathews' gr_85 shows the quintic diverging from the others outside the data. | confirmed |
| C4.5 | $p_5=4.63232+0.50885x-0.06063x^2-0.00074x^3-0.00065x^4+0.00012x^5$ | Exact coefficients are 4.6323237, 0.5088535, −0.0606259, −0.0007378, −0.0006505, 0.0001167. Mathews' gr_73 gives the same values. | confirmed |
| C4.6 | RMS = 0 (exact interpolation) | See C4.2. | confirmed |
| C4.7 | Wiring | `leastsqpolyad.jl` and `.gif` are this case. | confirmed |
| C4.8 | Alt text: x^0 to x^5, ending with the polynomial through all six points | 6 frames. In the last frame the curve passes through every marker, with yhat matching y to 1e-14. | confirmed |

### Counts

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| N1 | Four cases, degrees 2–5 | 4 scripts and 4 embeds. | confirmed |
| N2 | Frames: partial sums through x^0..x^m | The GIFs have 3, 4, 5 and 6 frames (manifest and frame folders). | confirmed |

### 3. Implementation checks

The four scripts are identical apart from `m`, the colour of the partial-sum curve, and the file name (checked with `diff`). The checks therefore apply to each script, and the numbers are given per m.

**Method.** Each script builds the design matrix `V[i,j] = x_i^j`, j = 0..m (line 18), and solves the normal equations `(V'V) a = V'y` (line 19). This is the polynomial least-squares method the page describes. Solving the normal equations directly, rather than by QR, is the page's stated formulation and is adequate here. The largest entry of `V'r` is 1.2e-12 for m=5 and 2.6e-13 for m=4, and the coefficients agree with the exact rational solution to about 1e-14 relative.

**Numbers.** I computed an independent exact rational solution with sympy and cross-checked it with numpy `polyfit`. Beside each is the instrumented script output.

| m | quantity | exact (sympy) | script (Julia) |
|---|---|---|---|
| 2 | a | 4.6742513654386695, 0.5286095149615619, −0.07563440814242851 | 4.67425136543867, 0.5286095149615617, −0.07563440814242862 |
| 2 | RMS | 0.05245143451 | 5.245143e-02 |
| 3 | a | 4.668626410745656, 0.48939249444442207, −0.07423866638351521, 0.002676594109623515 | 4.668626410745655, 0.4893924944444207, −0.07423866638351526, 0.0026765941096235962 |
| 3 | RMS | 0.02767320994 | 2.767321e-02 |
| 4 | a | 4.6286281623881935, 0.4966872292746763, −0.05823430106748139, 0.002013949218482641, −0.0008013781534539993 | 4.628628162388204, 0.4966872292746732, −0.05823430106748539, 0.0020139492184828756, −0.0008013781534538062 |
| 4 | RMS | 0.00733996801 | 7.339968e-03 |
| 5 | a | 4.6323237498133745, 0.5088535404480572, −0.060625942539113555, −0.0007378096658449499, −0.0006505146090195438, 0.00011666987908705642 | 4.632323749813362, 0.508853540448049, −0.06062594253910825, −0.0007378096658431165, −0.0006505146090198225, 0.00011666987908697646 |
| 5 | RMS | 0 (exact) | 7.859354e-15 |

The property checks hold. In exact arithmetic `V^T r = 0` for every m (`orth zero: True`). For m=5 every residual is zero, which is the interpolation property. The RMS decreases monotonically with m, as nested least-squares spaces require. The RMS of every partial sum is at least the degree-k least-squares RMS, which is a check of optimality.

Partial-sum RMS (script vs exact):
- m=2: 1.9933657645, 0.8968847479, 0.0524514345 (exact 1.993366, 0.896885, 0.052451)
- m=3: 1.9909522749, 0.9229565982, 0.1339229480, 0.0276732099 (exact 1.990952, 0.922957, 0.133923, 0.027673)
- m=4: 1.9741674261, 0.8854787854, 0.2209337917, 0.1671533994, 0.0073399680 (exact 1.974167, 0.885479, 0.220934, 0.167153, 0.007340)
- m=5: 1.9756902674, 0.8778947251, 0.1777354095, 0.2026746762, 0.1051053010, ~0 (exact 1.975690, 0.877895, 0.177735, 0.202675, 0.105105, 0)

**Reference values.** The only reference is the "final" fitted curve, which is the exact LS solution above. It also agrees with Mathews' printed Mathematica `Fit` output for m=2, 4 and 5. The m=3 result images are missing from the archive. Mathews' quintic RMS of 4.27e-14 is a different roundoff from the same exact value of 0.

**Picture.** I viewed the contact sheets of all four committed GIFs, which show every frame, since each GIF has at most 6.
- The gray dashed curve is `poly_eval(x, coeffs)`, the full fit.
- The solid curve is `partial_eval(x, coeffs, k)`. In frame k=0 it is a horizontal line at a0 (for example 4.674 for m=2), and in frame k=1 it is the line a0 + a1·x.
- The orange segments join (x_i, y_i) to (x_i, partial(x_i)).
- In the last frame the solid curve lies on top of the dashed curve.
- The titles "Degree-m LS fit: partial sum through x^k" and the legend labels use the right m and k.
- The "RMS(partial)" and "RMS(final)" annotations equal the values printed above, rounded to 5 decimals (or `%.2e` below 1e-4).

The axis window [-5, 4.5] × [0, 6.2] contains all the data. Clipping occurs only for the k=1 line's right end and the bottom-left tail of p4 and p5, as noted under Findings. Neither affects any claim. Each committed GIF is byte-identical to a fresh run (manifest), so the frames are the output of the reviewed code.

### Legacy archive (fidelity)

I consulted the archive. Examples 2–5 use the same six points and degrees as Cases 1–4. Where Mathews' result images exist (m=2, 4, 5), his coefficients and RMS match the page. The page names Examples 1, 6, 7 and 8 explicitly as not animated and describes them accurately. No fidelity findings.

