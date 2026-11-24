# Least Squares Polynomials — animation review (round 9)

Page: `pages/numerical-methods/least-squares-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found nothing in the implementation, page text, frames or legacy fidelity that is false, misleading, or a real minor defect.

Two observations below are recorded only so the clean result can be audited. Neither is a finding.
- Every frame also draws orange vertical residual stems from each data point to the current partial sum. The page's legend description (blue points, gray dashed $p_m$, solid coloured partial sum) does not mention them. That is an omission in the description, not a false statement, and the stems explain themselves.
- In the k=1 frames the partial-sum line runs above the window top (y=6.2; its maximum over the plot is 6.86 to 7.05 across the cases) and is clipped. The full quartic and quintic dip slightly below y=0 at x=-5 (minimum -0.063 for the quartic and -0.107 for the quintic) and are clipped by `ylims=(0,6.2)`. Both happen outside the data interval and change nothing a viewer would conclude.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `leastsqpolyaa.jl` | 0 | 8.2 | leastsqpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyab.jl` | 0 | 8.6 | leastsqpolyab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyac.jl` | 0 | 8.1 | leastsqpolyac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyad.jl` | 0 | 8.3 | leastsqpolyad.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | LS polynomial $p_m(x)=a_0+\dots+a_mx^m$ minimises $E=\sum(p_m(x_i)-y_i)^2$ | Standard. The script minimises exactly this through the normal equations. | confirmed |
| D2 | Normal equations $(V^TV)\mathbf a=V^T\mathbf y$, with V the Vandermonde-style design matrix | Script line 18 `V=[x^j for x in x_data, j in 0:m]`, line 19 `(V'*V)\(V'*y_data)` | confirmed |
| D3 | $\mathrm{RMS}=\sqrt{\frac1n\sum(p_m(x_i)-y_i)^2}$ | Script line 30 divides by `length(x_data)`=6. It matches Mathews' RMS values (0.0524514, 0.0276732, 0.00733997). | confirmed |
| D4 | Six data points (-4.5,0.7), (-3.2,2.3), (-1.4,3.8), (0.8,5.0), (2.5,5.5), (4.1,5.6) | Script lines 16 and 17. Legacy gr_38, gr_39 and gr_120 give the same points. | confirmed |
| D5 | "As the degree increases from 2 to 5, RMS decreases" | Exact RMS: 0.0524514, 0.0276732, 0.00733997, 0 | confirmed |
| D6 | Higher degree does not always mean better behaviour outside the data, because of wiggle and extrapolation | General caveat. Legacy Example 6 graph (gr_85, [-10,10]) shows the four fits diverging outside the data. | confirmed (general statement) |
| A1 | Each animation draws the degree-m LS polynomial one partial sum at a time, for the same dataset | `@animate for k in 0:m`, `partial_eval(x,coeffs,k)` with fixed coeffs. All four scripts use the same data. | confirmed |
| A2 | Blue points are the data, the gray dashed curve is $p_m$, the solid coloured curve is the partial sum, and k increases frame by frame | Script lines 43 to 45. Frames: royalblue scatter, gray45 dashed, coloured solid line. Titles read "through x^0" up to "x^m". | confirmed |
| A3 | Only the last frame (k=m) is a least-squares fit | The k=m partial sum equals the full fit (RMS(partial)=RMS(final) in the last frame). No earlier partial sum equals a degree-k LS fit, because a_0 differs from the mean (A4) and its RMS exceeds the degree-k LS RMS (A5). | confirmed |
| A4 | The degree-0 fit is the mean 3.8167, and a_0 ranges from 4.629 to 4.674 across the four cases | Mean = 3.816667. a_0 = 4.674251, 4.668626, 4.628628, 4.632324, so the range is 4.6286 to 4.6743. | confirmed |
| A5 | Each earlier partial sum has a larger RMS than the degree-k LS fit | All 14 (m,k<m) pairs checked: partial RMS > LS RMS in every case (for example m=5,k=4: 0.10511 > 0.00734) | confirmed |
| A6 | Partial-sum RMS need not fall: in Case 4 it rises from 0.17774 at k=2 to 0.20267 at k=3 | Exact: 0.1777354, 0.2026747. Frames 3 and 4 of `leastsqpolyad.gif` show the same values. | confirmed |
| A7 | Scripts compute coefficients from the normal equations | Line 19 | confirmed |
| A8 | Cases animate Mathews Examples 2 to 5 (quadratic, cubic, quartic, quintic, same six points) | Legacy lnk_3 to lnk_6: degrees 2, 3, 4, 5 for these points. gr_40 gives $p_2 = 4.67425+0.52861x-0.0756344x^2$. | confirmed |
| A9 | Example 1 fits an LS parabola to a different set of points | Legacy gr_10 and gr_12 give (-1,10),(0,9)/(0,6),... so the points are different | confirmed |
| A10 | The Example 6 graph plots the quadratic-to-quintic fits together on a wide interval, showing them separating outside the data | Legacy gr_84 and gr_85: `Show[graph2..graph5, PlotRange->{{-10,10},{-20,9}}]`, with the curves separating outside [-4.5,4.1]. (Example 6's text asks why the quintic RMS is about 0. Case 4 covers that.) | confirmed |
| A11 | Example 7 fits the same degrees to points sampled from a non-polynomial function, to show wiggle | Legacy lnk_8: degrees 2 to 5, with the remark "The points were obtained from [f] which is not polynomial". Data gr_86 differ. | confirmed |
| A12 | Example 8 recomputes the cubic fit to the same six points by the general linear LS theorem | Legacy lnk_9: degree 3, data gr_120 = the same six points | confirmed |
| C1-h | Case 1 heading: quadratic, m=2, linked to `leastsqpolyaa.jl` / `.gif` | Script `m = 2`. The GIF title reads "Degree-2". The GIF is byte-identical to the regenerated one. | confirmed |
| C1-a | "all residuals below 0.1 in size; the two largest are at x=-4.5 and x=-3.2" | Residuals: +0.0639, -0.0918, -0.0140, +0.0487, +0.0231, -0.0299. Max 0.0918 at -3.2, next 0.0639 at -4.5. | confirmed |
| C1-b | Concave-down main trend | a_2 = -0.0756 < 0 | confirmed |
| C1-c | $p_2=4.67425+0.52861x-0.07563x^2$, RMS ≈ 0.05245 | Exact: 4.674251, 0.528610, -0.0756344, RMS 0.0524514. Script gives the same. | confirmed |
| C1-alt | Partial sums through x^0, x^1, x^2, ending with a smooth concave-down curve | 3 frames, as described | confirmed |
| C2-h | Case 2 heading: cubic, m=3, linked to `leastsqpolyab` | `m = 3`, title "Degree-3" | confirmed |
| C2-a | The cubic term lowers RMS | 0.05245 to 0.02767 | confirmed |
| C2-b | Tracks the left and right tails a bit more closely | Endpoint residuals at x=-4.5: 0.0639 to 0.0191. At x=4.1: 0.0299 to 0.0117. At x=-3.2: 0.0918 to 0.0453. | confirmed |
| C2-c | Stable across the plotted interval | Frame 4: smooth curve, extrema 0.031 to 5.613 on [-5,4.5] | confirmed |
| C2-d | $p_3=4.66863+0.48939x-0.07424x^2+0.00268x^3$, RMS ≈ 0.02767 | Exact: 4.668626, 0.489392, -0.0742387, 0.00267659, RMS 0.0276732 | confirmed |
| C2-alt | Ends with the fitted cubic, whose RMS is lower than the quadratic's | 4 frames. 0.02767 < 0.05245. | confirmed |
| C3-h | Case 3 heading: quartic, m=4, linked to `leastsqpolyac` | `m = 4`, title "Degree-4" | confirmed |
| C3-a | Noticeably reduces residuals and follows the curvature between the middle and right-side points | Max abs residual 0.0453 to 0.0106. On the middle and right points (0.8, 2.5, 4.1) the maximum falls from 0.0301 to 0.0106. | confirmed (qualitative) |
| C3-b | RMS drops by about a factor of four compared with the cubic | 0.0276732 / 0.00733997 = 3.77 | confirmed |
| C3-c | $p_4 = 4.62863+0.496687x-0.0582343x^2+0.00201395x^3-0.000801378x^4$, RMS ≈ 0.00734 | Exact: 4.628628, 0.4966872, -0.0582343, 0.00201395, -0.000801378, RMS 0.00733997 | confirmed |
| C3-alt | Ends with a close fit to all six points | 5 frames. Last frame residual stems are invisible (max 0.0106). | confirmed |
| C4-h | Case 4 heading: quintic, m=5, linked to `leastsqpolyad` | `m = 5`, title "Degree-5" | confirmed |
| C4-a | Six distinct x and degree 5, so the LS polynomial interpolates and RMS is exactly 0 | Exact rational residuals all 0 | confirmed |
| C4-b | The floating-point solve shows roundoff of about 8e-15 | Script final_rms = 7.859e-15. The GIF annotation reads "RMS(final) = 7.86e-15". | confirmed |
| C4-c | $p_5$ coefficients 4.63232, 0.508854, -0.0606259, -0.000737810, -0.000650515, 0.000116670 (6 s.f.) | Exact: 4.6323237, 0.50885354, -0.060625943, -0.00073780967, -0.00065051461, 0.00011666988 | confirmed |
| C4-d | A degree n-1 polynomial matches n distinct points but may be fragile for extrapolation | Hedged. Consistent with the legacy Example 6 graph. | confirmed |
| C4-alt | Partial sums through x^0 to x^5, ending with a polynomial through all six points | 6 frames. Last frame passes through every point. | confirmed |
| W | 4 scripts linked, 4 GIFs embedded, each pairing correct | Manifest: GIFs byte-identical to scratch regenerations. Script names and `m` values match the headings. | confirmed |

### 3. Implementation checks

The four scripts are identical apart from `m`, the partial-sum colour and the output filename (checked with `diff`).

**Method.** Least-squares polynomial fit of degree m by forming and solving the normal equations $(V^TV)a=V^Ty$ with Julia's `\` (LU on a square matrix). This is the method the page and Mathews' theorem describe. Forming the normal equations squares the condition number. cond(V^TV) is 3.8e2, 6.6e3, 2.3e5 and 4.7e6 for m=2..5, so at least about 9 significant digits survive, far more than the 6 that are displayed.

**Numbers.** I compared the instrumented scripts (`julia inst_a?.jl`) with the exact rational solution (`python3 indep.py`):

| m | Script coeffs (Float64) | Exact (sympy, 9 s.f.) | Script RMS | Exact RMS |
|---|---|---|---|---|
| 2 | 4.67425136543867, 0.5286095149615617, -0.07563440814242862 | 4.67425137, 0.528609515, -0.0756344081 | 5.245143e-2 | 5.245143451e-2 |
| 3 | 4.668626410745655, 0.4893924944444207, -0.07423866638351526, 0.0026765941096235962 | 4.66862641, 0.489392494, -0.0742386664, 0.00267659411 | 2.767321e-2 | 2.767320994e-2 |
| 4 | 4.628628162388204, 0.4966872292746732, -0.05823430106748539, 0.0020139492184828756, -0.0008013781534538062 | 4.62862816, 0.496687229, -0.0582343011, 0.00201394922, -0.000801378153 | 7.339968e-3 | 7.339968010e-3 |
| 5 | 4.632323749813362, 0.508853540448049, -0.06062594253910825, -0.0007378096658431165, -0.0006505146090198225, 0.00011666987908697646 | 4.63232375, 0.508853540, -0.0606259425, -0.000737809666, -0.000650514609, 0.000116669879 | 7.859354e-15 | 0 |

Property checks:
- Exact residuals are orthogonal to the basis: V^T r = 0 exactly for every m in rational arithmetic.
- In the script's floating-point computation, max|V^T r| is 3.2e-14, 1.0e-13, 2.6e-13 and 1.2e-12 for m=2..5. These are negligible against V^T y entries of order 10 to 10^4.
- The m=5 fit interpolates. Its exact residuals are 0, and in floating point the RMS is 7.9e-15.

Partial-sum RMS:

| m | Script, k=0..m | Exact, k=0..m |
|---|---|---|
| 2 | 1.99337, 0.89688, 0.05245 | 1.99337, 0.896885, 0.0524514 |
| 3 | 1.99095, 0.92296, 0.13392, 0.02767 | 1.99095, 0.922957, 0.133923, 0.0276732 |
| 4 | 1.97417, 0.88548, 0.22093, 0.16715, 0.00734 | 1.97417, 0.885479, 0.220934, 0.167153, 0.00733997 |
| 5 | 1.97569, 0.87789, 0.17774, 0.20267, 0.10511, 7.86e-15 | 1.97569, 0.877895, 0.177735, 0.202675, 0.105105, 0 |

**Reference values.** The final $p_m$ is the only reference curve, and it is the computed fit itself, verified above. Mathews' own RMS values (legacy gr_78 to gr_81: 0.0524514, 0.0276732, 0.00733997, and 4.27e-14 ≈ 0) and his $p_2$ (gr_40, gr_44) agree with these to every digit shown.

**Picture.** I inspected the contact sheets for all four committed GIFs (3, 4, 5 and 6 frames, every frame visible). In each frame:
- The title "Degree-m LS fit: partial sum through x^k" has the right m and k.
- The legend names "final pm(x)" with the right m.
- The constant (k=0) frame is a horizontal line at a_0 of about 4.63 to 4.67.
- The k=1 frame is a line of slope a_1.
- The last frame's partial sum lies on top of the dashed final curve and passes through or near the points as the residuals predict.
- The RMS(partial) and RMS(final) annotations match the printed values above exactly.
- The residual stems run from y_i to the partial sum at x_i (lines 47 to 50), which is the right quantity.

Display devices: clipping at ylims=(0,6.2) affects only the k=1 line beyond x≈2.9 and the quartic and quintic tails at x<-4.9. Neither is a finding (see the observations in section 1). The regenerated GIFs are byte-identical to the committed ones (manifest).

