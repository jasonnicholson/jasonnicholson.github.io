# Least Squares Polynomials — animation review (round 7)

Page: `pages/numerical-methods/least-squares-polynomials/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: the printed quintic does not interpolate at its printed precision

- **Location:** `index.qmd:77`, `p_5(x)=4.63232 + 0.50885x - 0.06063x^2 - 0.00074x^3 - 0.00065x^4 + 0.00012x^5,\qquad \mathrm{RMS}=0\ \text{(exact interpolation)}`.
- **What is there now:** Each coefficient is correctly rounded to five decimals, but that leaves $a_5$ with one significant figure ($0.00012$ for $0.00011667$) and $a_3$, $a_4$ with two. The formula is set directly beside "RMS = 0 (exact interpolation)".
- **What is true:** The polynomial as printed misses the data. Its values at the six nodes are $0.6942, 2.2990, 3.8000, 5.0000, 5.5003, 5.6038$ against $0.7, 2.3, 3.8, 5.0, 5.5, 5.6$. Its RMS is $0.00286$, about 39% of the quartic's $0.00734$. A reader who substitutes $x=-4.5$ to check the "exact interpolation" claim gets a miss of $0.0058$. The true quintic has exactly zero residual.
- **How I know:** `/usr/bin/python3 review/indep2.py`, section "printed-coefficient check": `5 round-correct True RMS of printed polynomial 0.002858 true 0.000000`, residuals `[-5.80e-03 -1.03e-03 -2.00e-05 -1.00e-05 2.70e-04 3.77e-03]`. The exact rational residuals of the true quintic are `[0, 0, 0, 0, 0, 0]`.
- **Same effect, smaller, on $p_4$ (line 67):** the printed quartic has RMS $0.007353$, which rounds to $0.00735$ rather than the stated $0.00734$. The stated value is right for the true fit.
- **Suggested correction:** Print the higher coefficients to six significant figures, as Mathews does (archive image 70):
  $p_5(x)=4.63232 + 0.508854x - 0.0606259x^2 - 0.000737810x^3 - 0.000650515x^4 + 0.000116670x^5$.
  This form has RMS $3.8\times10^{-6}$ and a largest residual of $5.3\times10^{-6}$. For $p_4$ use $4.62863 + 0.496687x - 0.0582343x^2 + 0.00201395x^3 - 0.000801378x^4$ (RMS $0.00734$). Alternatively, keep the current digits and write $\approx$ with a note that the coefficients are rounded.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `leastsqpolyaa.jl` | 0 | 7.9 | leastsqpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyab.jl` | 0 | 8.0 | leastsqpolyab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyac.jl` | 0 | 8.6 | leastsqpolyac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyad.jl` | 0 | 7.8 | leastsqpolyad.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Evidence labels: **E** = exact rational computation (`indep.py`, `indep2.py`); **S** = instrumented script output; **F** = frames; **A** = legacy archive.

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | $p_m(x)=a_0+a_1x+\cdots+a_mx^m$ | Confirmed | `poly_eval` in all four scripts; column $j$ of `V` is $x^{j}$ for $j=0..m$ |
| 2 | Chosen to minimize $E=\sum(p_m(x_i)-y_i)^2$ | Confirmed | E: $V^TV$ positive definite for $m=2..5$, and $V^Tr=0$ exactly, so the solution is the unique minimizer |
| 3 | Setting partials of $E$ to zero gives $(V^TV)\mathbf a=V^T\mathbf y$ | Confirmed | E: symbolic identity $\nabla E=2(V^TV\mathbf a-V^T\mathbf y)$ true for $m=2..5$ |
| 4 | $V$ is the Vandermonde-style design matrix | Confirmed | Line 18 of each script |
| 5 | RMS $=\sqrt{\frac1n\sum(p_m(x_i)-y_i)^2}$ | Confirmed | Script formula; matches the archive's `RMS` routine (image 7) |
| 6 | Six data points as listed | Confirmed | Scripts line 16 and 17; archive images 38, 52, 60, 68 |
| 7 | "As the degree increases from 2 to 5, RMS decreases" | Confirmed | E: 0.052451, 0.027673, 0.007340, 0 |
| 8 | "does not always mean better behavior outside the data interval"; high-degree fits can show wiggle and poor extrapolation | Confirmed | E, at $x=10$: $p_2..p_5 = 2.40, 4.82, -2.23, 8.08$; at $x=-10$: $-8.18, -10.33, -16.19, -23.95$. A: image 85. Example 7 points: quartic fit falls to $-17.9$ on $[0.25,5]$ |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 9 | Each animation draws the degree-$m$ fit one partial sum at a time, same dataset | Confirmed | Scripts; F (titles, frame counts) |
| 10 | Blue points are the data | Confirmed | F, legend; `scatter!(x_data, y_data; color=:royalblue)` |
| 11 | Gray dashed curve is the fitted $p_m$ | Confirmed | F, legend; `y_full` from `poly_eval` |
| 12 | Solid colored curve is the partial sum, $k$ increasing frame by frame | Confirmed | F; `pix.py`: all 18 frames within 1.9 px (0.033 data units) of the independent partial sum |
| 13 | Only the last frame ($k=m$) is a least-squares fit | Confirmed | E: every $k<m$ has RMS above the degree-$k$ optimum |
| 14 | Earlier partial sums are not the degree-$k$ fits; lowering the degree changes every coefficient | Confirmed | E: coefficients for $m=0..5$ all differ at each power |
| 15 | Degree-0 fit is the mean $3.8167$ | Confirmed | E: 3.81666667 |
| 16 | $a_0$ ranges from $4.629$ to $4.674$ across the four cases | Confirmed | E: 4.67425, 4.66863, 4.62863, 4.63232 |
| 17 | Each earlier partial sum has larger RMS than the degree-$k$ fit | Confirmed | E: true in all 14 $(m,k)$ pairs with $k<m$ |
| 18 | Case 4 partial-sum RMS rises from $0.17774$ at $k=2$ to $0.20267$ at $k=3$ | Confirmed | E: 0.177735, 0.202675; S; F frames 3 and 4 of `leastsqpolyad` |
| 19 | Scripts compute the coefficients from the normal equations | Confirmed | `coeffs = (V' * V) \ (V' * y_data)` |
| 20 | Scripts generated these animations | Confirmed | Manifest: all four regenerated GIFs byte-identical to committed |
| 21 | Cases animate Examples 2 to 5, fitting quadratic, cubic, quartic, quintic to the six points | Confirmed | A: module text and images 38, 52, 60, 68 |
| 22 | Example 1 fits a least-squares parabola to a different set of points | Confirmed | A: image 10, $(-1,10),(0,9),(1,7),\ldots$ |
| 23 | Example 6's graph plots quadratic to quintic together on an interval wide enough to show them separating | Confirmed | A: images 84 (PlotRange $[-10,10]$) and 85. Example 6 also has a data-interval graph (image 83) |
| 24 | Example 7 fits the same degrees to points from a non-polynomial function to show wiggle | Confirmed | A: `lnk_8` text and image 86. The source function's image is missing, but the claim does not name it |
| 25 | Example 8 recomputes the cubic fit to the same six points from the general linear least-squares theorem | Confirmed for the setup | A: module text, image 120. The solution images are missing, so its printed result could not be read |

### Case 1 (`leastsqpolyaa`)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 26 | Heading $m=2$ | Confirmed | `m = 2` |
| 27 | Captures the concave-down trend | Confirmed | $a_2=-0.0756<0$ |
| 28 | All residuals below $0.1$ in size | Confirmed | E: largest $0.09180$ |
| 29 | Two largest at the two leftmost points | Confirmed | E: $|r|=0.06391, 0.09180$ at $-4.5,-3.2$; next is $0.04873$ |
| 30 | Baseline smooth fit used in the module | Confirmed | A: Example 2 is the module's first fit to these points |
| 31 | $p_2$ coefficients | Confirmed | E: 4.67425137, 0.52860951, -0.07563441; A: image 40 |
| 32 | RMS $\approx 0.05245$ | Confirmed | E: 0.05245143; A: 0.0524514; F |
| 33 | Link, embed and alt text (partial sums $x^0$ to $x^2$, smooth, concave-down) | Confirmed | 3 frames; F |

### Case 2 (`leastsqpolyab`)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 34 | Heading $m=3$ | Confirmed | `m = 3` |
| 35 | Adding the cubic term lowers RMS | Confirmed | E: 0.05245 to 0.02767 |
| 36 | Tracks the left and right tails a bit more closely | Confirmed, with a nuance | E: both end residuals shrink ($0.0639\to0.0191$, $0.0299\to0.0117$), and the squared error falls on both end pairs (left $0.01251\to0.00242$, right $0.00142\to0.00104$). The individual residual at $x=2.5$ grows ($0.0231\to0.0301$). Not a finding, since the claim holds for the tails |
| 37 | Remains stable across the plotted interval | Confirmed | E: one turning point in $[-5,4.5]$ (at $4.293$), no inflection |
| 38 | $p_3$ coefficients | Confirmed | E: 4.66862641, 0.48939249, -0.07423867, 0.00267659. Archive coefficient images are missing |
| 39 | RMS $\approx 0.02767$ | Confirmed | E: 0.02767321; A: image 79, 0.0276732; F |
| 40 | Link, embed and alt text (ends with cubic, RMS below quadratic's) | Confirmed | 4 frames; F |

### Case 3 (`leastsqpolyac`)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 41 | Heading $m=4$ | Confirmed | `m = 4` |
| 42 | Noticeably reduces residuals | Confirmed | E: all six $|r|$ fall; largest $0.04534\to0.01059$ |
| 43 | Follows subtle curvature changes between middle and right-side points | Confirmed | E: second divided differences of the data on the last three triples are $-0.0720,-0.0645,-0.0702$, a reversal. The cubic's are monotone ($-0.0844,-0.0692,-0.0544$) and cannot reverse. The quartic's reverse ($-0.0768,-0.0594,-0.0748$) |
| 44 | RMS drops by about a factor of four vs the cubic | Confirmed | E: ratio 3.770 |
| 45 | $p_4$ coefficients | Confirmed as rounded | E: 4.62862816, 0.49668723, -0.05823430, 0.00201395, -0.00080138; A: image 62. See F1 for the effect of the rounding |
| 46 | RMS $\approx 0.00734$ | Confirmed | E: 0.00733997; A: 0.00733997; F |
| 47 | Link, embed and alt text (close fit to all six points) | Confirmed | 5 frames; largest residual $0.0106$ |

### Case 4 (`leastsqpolyad`)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 48 | Heading $m=5$ | Confirmed | `m = 5` |
| 49 | Six distinct $x$ and degree 5, so the fit interpolates, RMS exactly 0 | Confirmed | E: exact residuals all 0 |
| 50 | Floating-point solve shows roundoff of about $8\times10^{-15}$ | Confirmed | S: 7.859e-15; F: "7.86e-15" |
| 51 | A degree $n-1$ polynomial can match $n$ distinct points | Confirmed | Square Vandermonde, nonsingular |
| 52 | May still be fragile for extrapolation | Confirmed | E: at $x=10$, $p_5=8.08$ and $p_4=-2.23$. The plotted window $[-5,4.5]$ does not show this, but the page does not say it does, and line 41 states the wide-interval graph is not animated |
| 53 | $p_5$ coefficients | Confirmed as rounded; **see F1** | E: 4.63232375, 0.50885354, -0.06062594, -0.00073781, -0.00065051, 0.00011667; A: image 70 |
| 54 | RMS $=0$ (exact interpolation) beside the printed formula | True of $p_5$, **not of the formula as printed: F1** | E: printed form has RMS 0.002858 |
| 55 | Link, embed and alt text (passes through all six points) | Confirmed | 6 frames; F |

---

### 3. Implementation checks

The four scripts are identical apart from `m`, the curve colour, and the file names (`diff` of `aa` against each of the others).

**It is the method it claims to be.** Each script forms the Vandermonde matrix and solves the normal equations directly with `(V'V) \ (V'y)`, which is what the page says. Conditioning is no obstacle at this size: cond$(V^TV)$ is $3.8\times10^2$, $6.6\times10^3$, $2.3\times10^5$, $4.7\times10^6$ for $m=2..5$.

**The numbers are right.** Script output against the exact rational solution:

| $m$ | Script coefficients | Exact (8 d.p.) | Script RMS | Exact RMS | Archive RMS | Largest $\lvert V^Tr\rvert$ in script |
|---|---|---|---|---|---|---|
| 2 | 4.674251365, 0.528609515, -0.075634408 | 4.67425137, 0.52860951, -0.07563441 | 0.052451435 | 0.05245143 | 0.0524514 | 3.2e-14 |
| 3 | 4.668626411, 0.489392494, -0.074238666, 0.002676594 | 4.66862641, 0.48939249, -0.07423867, 0.00267659 | 0.027673210 | 0.02767321 | 0.0276732 | 1.0e-13 |
| 4 | 4.628628162, 0.496687229, -0.058234301, 0.002013949, -0.000801378 | 4.62862816, 0.49668723, -0.05823430, 0.00201395, -0.00080138 | 0.007339968 | 0.00733997 | 0.00733997 | 2.6e-13 |
| 5 | 4.632323750, 0.508853540, -0.060625943, -0.000737810, -0.000650515, 0.000116670 | 4.63232375, 0.50885354, -0.06062594, -0.00073781, -0.00065051, 0.00011667 | 7.86e-15 | 0 | 4.27e-14 (≈ 0) | 1.2e-12 |

NumPy `polynomial.polyfit` (a least-squares solve that does not form $V^TV$) gives the same coefficients. The exact residual is orthogonal to the basis ($V^Tr=0$ in rational arithmetic) for every degree.

Partial-sum RMS, script label against exact:

| $m$ | $k=0$ | $k=1$ | $k=2$ | $k=3$ | $k=4$ | $k=5$ |
|---|---|---|---|---|---|---|
| 2 | 1.99337 / 1.993366 | 0.89688 / 0.896885 | 0.05245 / 0.052451 | | | |
| 3 | 1.99095 / 1.990952 | 0.92296 / 0.922957 | 0.13392 / 0.133923 | 0.02767 / 0.027673 | | |
| 4 | 1.97417 / 1.974167 | 0.88548 / 0.885479 | 0.22093 / 0.220934 | 0.16715 / 0.167153 | 0.00734 / 0.007340 | |
| 5 | 1.97569 / 1.975690 | 0.87789 / 0.877895 | 0.17774 / 0.177735 | 0.20267 / 0.202675 | 0.10511 / 0.105105 | 7.86e-15 / 0 |

**Its reference values are right.** The only reference curve is the "final" $p_m$, and "RMS(final)" is its RMS. Both are verified above. The data match the archive.

**The picture shows what was computed.**

- `pix.py` located the drawn partial-sum curve in up to 47 pixel columns of each of the 18 frames and compared it with the independent partial sum. The worst deviation over all frames is 0.033 data units (1.9 px), which is the line width.
- All 18 frames were read for title, legend and RMS labels, and each agrees with the tables above. Orange residual stems run from each data point to the partial sum at that $x$ (code, confirmed visually). The page does not mention them, but they are drawn correctly.
- Clipping: in every $k=1$ frame the line leaves the top of the window near $x\approx3$ and its value at $x=4.1$ ($6.67$ to $6.84$ across the four cases) is above `ylims`. The line is visibly cut by the frame and the RMS label is computed from the true values, so this misleads no one. The $p_4$ and $p_5$ curves reach $-0.063$ and $-0.107$ at $x=-5$, just under the axis floor, which is immaterial.
- Frame counts are 3, 4, 5, 6 ($m+1$). Committed GIFs are byte-identical to fresh runs (manifest).

**Could not determine:**

- Mathews' printed Example 3 coefficients, and the printed results of Examples 7 and 8: those archive images are missing. The cubic itself is verified by exact computation and by the surviving RMS.
- The source function of Example 7, for the same reason. The page does not name it.

The repository was not modified. `git status --short` is empty.

