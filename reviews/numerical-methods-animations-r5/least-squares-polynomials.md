# Least Squares Polynomials — animation review (round 5)

Page: `pages/numerical-methods/least-squares-polynomials/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every numerical claim on the page matches the exact rational least-squares solution to the stated precision. Every behaviour claim matches the computed residuals and RMS values. Every case is wired to the correct script and GIF. The frames show what the scripts compute. The archive agrees with the page on the data, the coefficients and the RMS values. The page discloses the archive examples it does not animate, and it describes each of them correctly.

Observations I looked at and did not count as findings:
- `ylims = (0, 6.2)` clips the k=1 partial-sum lines at the right edge (about 15% of the x-window, where the line exceeds 6.2) and the final quartic and quintic for x < about -4.95 (minimums -0.063 and -0.107 at x=-5). This does not touch any data point or change any conclusion.
- The x-window [-5, 4.5] barely extends beyond the data [-4.5, 4.1], so the Case 4 remark "may still be fragile for extrapolation" cannot be seen in the animation. The remark is hedged ("may"), the computed values support it (p5(-10) = -23.95 against p2(-10) = -8.18; p5(10) = 8.08 against p4(10) = -2.23), and the page says that Mathews' wide-interval graph (Example 6) is not animated.
- The design of animating partial sums of the monomial expansion is not how Mathews presents the examples. The page states plainly that only the last frame is a least-squares fit and that the earlier frames are not degree-k fits, so this is a teaching choice, not a mismatch.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `leastsqpolyaa.jl` | 0 | 8.8 | leastsqpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyab.jl` | 0 | 7.6 | leastsqpolyab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyac.jl` | 0 | 8.8 | leastsqpolyac.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `leastsqpolyad.jl` | 0 | 8.1 | leastsqpolyad.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Evidence key: **J** = instrumented copy of the script's own computation (`julia instr.jl`). **X** = independent exact computation with sympy rationals plus `numpy.polynomial.polyfit` (`/usr/bin/python3 indep.py`). **F** = committed frames. **A** = Mathews archive.

### Description
| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | LS polynomial $p_m=a_0+\dots+a_mx^m$ minimises $E=\sum(p_m(x_i)-y_i)^2$ | confirmed | standard; script minimises the same quantity via normal equations; X shows $V^Tr=0$ exactly for m=0..5 |
| D2 | Normal equations $(V^TV)\mathbf a=V^T\mathbf y$, V Vandermonde-style | confirmed | script lines 18-19 build `V=[x^j]` and solve `(V'V)\(V'y)`, which is the same system as the archive's normal-equation matrix (A, ex1.png) |
| D3 | RMS $=\sqrt{\frac1n\sum(p_m(x_i)-y_i)^2}$ | confirmed | script line 30 uses the same formula; archive `RMS` routine is identical |
| D4 | Data: (-4.5,0.7),(-3.2,2.3),(-1.4,3.8),(0.8,5.0),(2.5,5.5),(4.1,5.6) | confirmed | script lines 16-17; A Examples 2-5 and 8 use the same points |
| D5 | As degree increases from 2 to 5, RMS decreases | confirmed | X: 0.052451, 0.027673, 0.0073400, 0 |
| D6 | High-degree fits can wiggle and extrapolate poorly | confirmed (general) | X extrapolation: p(-10) = -8.18, -10.33, -16.19, -23.95 for m=2..5 |

### Animations introduction
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| I1 | Each animation draws the degree-m LS polynomial one partial sum at a time, same dataset | confirmed | script loop `for k in 0:m`, `partial_eval`; F titles "partial sum through x^k" |
| I2 | Blue points = data; gray dashed = fitted $p_m$; solid coloured = partial sum, k increasing frame by frame | confirmed | script lines 43-45 (royalblue scatter, gray45 dash, coloured solid); F all four GIFs |
| I3 | Only the last frame (k=m) is a LS fit | confirmed | X: partial-sum coefficients for k<m differ from the degree-k LS coefficients (e.g. a0 = 4.674 vs mean 3.817) |
| I4 | Degree-0 fit is the mean 3.8167 | confirmed | X: 22.9/6 = 3.816667 |
| I5 | $a_0$ ranges from 4.629 to 4.674 across the four cases | confirmed | X: a0 = 4.674251, 4.668626, 4.628628, 4.632324 |
| I6 | Each earlier partial sum has a larger RMS than the degree-k LS fit | confirmed | X: all 14 (m,k<m) pairs are True; e.g. m=5,k=3: 0.202675 > 0.027673 |
| I7 | Partial-sum RMS need not fall as terms are added; in Case 4 it rises from 0.17774 at k=2 to 0.20267 at k=3 | confirmed | J and X: 0.177735 then 0.202675; F leastsqpolyad frames 3-4 show 0.17774 and 0.20267 |
| I8 | Scripts compute coefficients from the normal equations | confirmed | script line 19 |
| I9 | The four cases animate Mathews' Examples 2-5 (quadratic, cubic, quartic, quintic, same six points) | confirmed | A lnk_3..lnk_6 |
| I10 | Example 1 fits a LS parabola to a different set of points | confirmed | A ex1.png: points (-1,10),(0,9),... |
| I11 | Example 6's graph plots the quadratic to quintic fits together on a wide interval, showing them separating outside the data | confirmed | A ex6.png: `PlotRange -> {{-10,10},{-20,9}}`, curves diverge outside [-4.5,4.1] |
| I12 | Example 7 fits the same degrees to points from a non-polynomial function (wiggle) | confirmed | A lnk_8 text "obtained from ... which is not polynomial"; degrees 2,3,4,5 |
| I13 | Example 8 recomputes the cubic fit to the same six points via the linear LS theorem | confirmed | A lnk_9 text "degree = 3"; ex8.png shows the same six points |

### Case 1 (aa, m=2)
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1.1 | Heading m=2; link `leastsqpolyaa.jl`; embed `leastsqpolyaa.gif` | confirmed | script `m = 2`; GIF title "Degree-2"; regen byte-identical to committed |
| C1.2 | Concave-down; all residuals below 0.1 in size | confirmed | a2 = -0.0756 < 0; X residuals 0.0639, -0.0918, -0.0140, 0.0487, 0.0231, -0.0299 (max 0.0918) |
| C1.3 | Two largest residuals at the two leftmost points (x=-4.5, -3.2) | confirmed | \|r\| = 0.0918 at -3.2 and 0.0639 at -4.5; next is 0.0487 |
| C1.4 | $p_2=4.67425+0.52861x-0.07563x^2$ | confirmed | X: 4.6742513654, 0.5286095150, -0.0756344081; A: 4.67425 + 0.52861x - 0.0756344x^2 |
| C1.5 | RMS ≈ 0.05245 | confirmed | X 0.05245143; A 0.0524514; F "RMS(final) = 0.05245" |
| C1.6 | Alt: partial sums through x^0, x^1, x^2, ending with smooth concave-down fit | confirmed | F: 3 frames, titles x^0, x^1, x^2 |

### Case 2 (ab, m=3)
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2.1 | Heading m=3; wiring | confirmed | script `m = 3`; GIF title "Degree-3"; byte-identical regen |
| C2.2 | Lowers RMS (vs quadratic) | confirmed | 0.027673 < 0.052451 |
| C2.3 | Tracks left and right tails more closely | confirmed | \|r\| at x=-4.5: 0.0191 vs 0.0639; x=-3.2: 0.0453 vs 0.0918; x=4.1: 0.0117 vs 0.0299 |
| C2.4 | Remains stable across the plotted interval | confirmed | X: p3 on [-5,4.5] is smooth, range 0.031 to 5.613, no oscillation; F frame 4 |
| C2.5 | $p_3=4.66863+0.48939x-0.07424x^2+0.00268x^3$ | confirmed | X: 4.6686264, 0.4893925, -0.0742387, 0.0026766 |
| C2.6 | RMS ≈ 0.02767 | confirmed | X 0.02767321; A Ex 6 lists 0.0276732; F 0.02767 |
| C2.7 | Alt: partial sums x^0..x^3, final RMS lower than quadratic's | confirmed | F 4 frames; 0.02767 < 0.05245 |

### Case 3 (ac, m=4)
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C3.1 | Heading m=4; wiring | confirmed | script `m = 4`; GIF title "Degree-4"; byte-identical regen |
| C3.2 | Noticeably reduces residuals; follows curvature between middle and right points | confirmed | X residuals at x=-1.4, 0.8, 2.5: cubic 0.0306, 0.0140, -0.0301 vs quartic 0.0105, -0.0106, 0.0065; max \|r\| 0.0453 to 0.0106 |
| C3.3 | RMS drops by about a factor of four vs the cubic | confirmed | X ratio 3.770 |
| C3.4 | $p_4=4.62863+0.49669x-0.05823x^2+0.00201x^3-0.00080x^4$ | confirmed | X: 4.6286282, 0.4966872, -0.0582343, 0.0020139, -0.0008014; A identical to 6 s.f. |
| C3.5 | RMS ≈ 0.00734 | confirmed | X 0.007339968; A 0.00733997; F 0.00734 |
| C3.6 | Alt: partial sums x^0..x^4, close fit to all six points | confirmed | F 5 frames; max residual 0.0106 |

### Case 4 (ad, m=5)
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C4.1 | Heading m=5; wiring | confirmed | script `m = 5`; GIF title "Degree-5"; byte-identical regen |
| C4.2 | Six distinct x, degree 5: LS polynomial interpolates, RMS exactly 0 | confirmed | X exact rational residuals all 0 |
| C4.3 | Animation's floating-point solve shows roundoff about 8e-15 | confirmed | J 7.859e-15; F "RMS(final) = 7.86e-15" |
| C4.4 | Degree n-1 can match n distinct points; may be fragile for extrapolation | confirmed | X; p5(-10) = -23.95, the most extreme of the four fits |
| C4.5 | $p_5=4.63232+0.50885x-0.06063x^2-0.00074x^3-0.00065x^4+0.00012x^5$ | confirmed | X: 4.6323237, 0.5088535, -0.0606259, -0.0007378, -0.0006505, 0.0001167; A identical |
| C4.6 | Alt: partial sums x^0..x^5, ending with the polynomial through all six points | confirmed | F 6 frames; final curve passes through every point |

### Counts
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| N1 | Four cases, k from 0 to m (m+1 frames each) | confirmed | GIF frame counts 3, 4, 5, 6 (manifest and F) |

### 3. Implementation checks

All four scripts share the same code path, so each check below covers all four.

**It is the method it claims to be.** The scripts build the monomial design matrix `V[i,j] = x_i^j` (j = 0..m) and solve the normal equations `(V'V) a = V'y` with a dense solve. That is polynomial least squares by normal equations, as the page and the archive theorem describe. There is no substitute method behind the name.

**The numbers are right.** Script coefficients (J) and the exact rational LS solution (X, sympy `LUsolve` on rational data) agree to all 10 printed decimals for every m. They also agree with numpy's `polyfit`, which uses an SVD-based solve rather than the normal equations:

| m | script (J) | exact (X) |
|---|---|---|
| 2 | 4.6742513654, 0.5286095150, -0.0756344081 | same |
| 3 | 4.6686264107, 0.4893924944, -0.0742386664, 0.0026765941 | same |
| 4 | 4.6286281624, 0.4966872293, -0.0582343011, 0.0020139492, -0.0008013782 | same |
| 5 | 4.6323237498, 0.5088535404, -0.0606259425, -0.0007378097, -0.0006505146, 0.0001166699 | same |

Property checks: the exact residual is orthogonal to every basis column ($V^Tr = 0$ exactly, m = 0..5), and the quintic residuals are exactly 0 (interpolation). The largest condition number of $V^TV$ is 4.7e6 (m=5), so the normal-equation solve loses at most about 7 digits. That is consistent with the 10-digit agreement.

RMS per frame, script (J) against independent (X):
- m=2: k=0..2: 1.993366, 0.896885, 0.052451 (X identical)
- m=3: 1.990952, 0.922957, 0.133923, 0.027673 (X identical)
- m=4: 1.974167, 0.885479, 0.220934, 0.167153, 0.007340 (X identical)
- m=5: 1.975690, 0.877895, 0.177735, 0.202675, 0.105105, 7.86e-15 (X: same, final exactly 0)

**Its reference values are right.** There is no separate "exact" reference. The gray dashed curve is the script's own degree-m fit, and its coefficients are verified above. The archive's Mathematica `Fit` output agrees for m = 2, 4 and 5 to the 6 significant figures shown, and Mathews' RMS values agree for m = 2, 3, 4 (0.0524514, 0.0276732, 0.00733997). Mathews' p5 RMS is 4.27e-14, which is a different roundoff level from a different solver; the true value is 0.

**The picture shows what was computed.** I viewed all frames on the contact sheets of the four committed GIFs (3 + 4 + 5 + 6 frames). Each title reads "Degree-m LS fit: partial sum through x^k" with the right m and k. The gray dashed curve is `poly_eval(x, coeffs)`; the coloured curve is `partial_eval(..., k)`. The orange stems join each data point to the partial sum's value at that x (`yhat_data`), and their lengths are visibly consistent with the residuals (long at k=0, invisible at k=m). The RMS(partial) and RMS(final) annotations match J and X to 5 decimals in every frame. The legend labels "final pm(x)" and "partial sum through x^k" are correct. Display devices: x-window [-5, 4.5] covers all data; y-window [0, 6.2] clips only the k=1 line at the upper right and the m = 4 and 5 final curves for x < about -4.95 (values to -0.107). Neither hides a data point or a feature the page discusses. The manifest reports, and I re-checked with `cmp`, that every scratch regeneration is byte-identical to the committed GIF, so the frames are the output of the scripts as committed.

