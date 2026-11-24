# Laurent Series — animation review (round 9)

Page: `pages/numerical-methods/laurent-series/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim in the Animations section and the Description agrees with my independent computation at the precision stated, and every frame, title and legend agrees with the code and the page.

Count: Error 0, Misleading 0, Minor 0.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `laurent_animations_all.jl` | 0 | 20.7 | 8 GIFs (laurent01.gif … laurent08.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `laurent01.gif` | 14 | byte-identical | laurent_animations_all |
| `laurent02.gif` | 12 | byte-identical | laurent_animations_all |
| `laurent03.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent04.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent05.gif` | 14 | byte-identical | laurent_animations_all |
| `laurent06.gif` | 12 | byte-identical | laurent_animations_all |
| `laurent07.gif` | 12 | byte-identical | laurent_animations_all |
| `laurent08.gif` | 12 | byte-identical | laurent_animations_all |

### Page references

- Scripts linked: `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`, `laurent_animations_all.jl`
- GIFs embedded: 8
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description
| # | Claim (page wording, abbreviated) | Verdict | Evidence |
|---|---|---|---|
| D1 | $a_k=\frac1{2\pi i}\oint_C f(z)(z-x_0)^{-k-1}dz$, $C$ a positively oriented circle in the annulus | confirmed | Standard Laurent formula. I used it numerically (contour on $|z|=2,5,1$), and it reproduced the script's coefficients for Cases 03, 06, 07, 08 (below) |
| D2 | Terms with $k<0$ form the principal part, and the coefficients are unique for a given annulus. A function with several singularities has a different series in each annulus | confirmed | Standard. Illustrated by Cases 05–07, whose three coefficient sets differ |
| D3 | Analytic on the whole disk ⇒ all negative coefficients zero, and the Laurent series is the Taylor series | confirmed | Cauchy–Goursat. Cases 01, 02, 05 have zero negative coefficients (sympy) |
| D4 | Analytic on a connected region containing the annulus with a non-removable singularity on or inside the inner circle ⇒ some negative power has a nonzero coefficient | confirmed | If all $a_{k<0}=0$, the series is analytic on the full disk and equals $f$ on the annulus. Any path from inside the inner circle to outside passes through the annulus, so the identity theorem extends the equality to the singularity, which makes it removable. Contradiction |
| D5 | $(x-x_0)^{-k}$ is infinite at $x_0$ and →0 as $|x|\to\infty$. A polynomial has no vertical asymptote and, if nonconstant, no horizontal asymptote | confirmed | Elementary |

### Animations introduction
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| I1 | Blue = partial sum, magenta = $f$ | confirmed | `render_case`: `:steelblue` sum, `:magenta` f, and the legends in every GIF |
| I2 | Dashed black lines are the asymptotes of $f$ | confirmed | `vasym`/`hasym` for each case: 01 y=0; 02 y=0; 03 x=0, y=0; 04 x=±1, y=1; 05–07 x=−3, x=1, y=0; 08 x=0, y=1. Each is a true asymptote ($e^{1/x}$ at x=0 is one-sided, from the right) |
| I3 | Green shading = where the series converges on the real line | confirmed | `regions`: 01 all; 02 (−1,1); 03 x≠0; 04 \|x\|>1; 05 (−1,1); 06 (−3,−1)∪(1,3); 07 \|x\|>3; 08 x≠0. Each matches the region set by the nearest singularities |
| I4 | In cases with negative powers, orange = Taylor polynomial about a regular point inside the shaded region, with the same number of terms | confirmed | `ref` is set exactly for 03, 04, 06, 07, 08, at 1, 3, 2, 5, 1, each inside its shaded region. The degree is `nterms-1`, and the legends read "(N terms)" identically for blue and orange in every frame I checked |
| I5 | Legend lists the powers included | confirmed | `powers_label`. Frames checked: 01 f14, 03 f10, 04 f10, 05 f14, 06 f12, 07 f12, 08 f12 |
| I6 | Mathews' module has no animations, and its examples are not attributed to him | not evaluated | History/attribution (excluded by the brief). The archive text shows only static plots, which is consistent |

### Case 01: $\sin x/x$ about 0, all $x$
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1a | Series $1-x^2/6+x^4/120-\cdots$, no negative power; the singularity is removable; Laurent = Taylor | confirmed | sympy coefficients [1,0,−1/6,0,1/120,0,−1/5040] = script `(-1)^(k/2)/(k+1)!` |
| 1b | Converges for every $x$ | confirmed | Entire function |
| 1c | The ≤0.01 interval widens every frame, from about $\|x\|\le0.25$ to about $\|x\|\le10.9$ | confirmed | Script: 0.2453, 1.054, 1.939, …, 10.079, 10.856 (strictly increasing over all 14 frames). mpmath independent: 0.2453 and 10.8562 |
| 1d | Alt: interval −14 to 14, no negative power, wider match each frame | confirmed | xlims (−14,14). Frames 1–14 viewed on the contact sheet and frame 14 at full size |

### Case 02: $1/(1+x^2)$ about 0, $\|x\|<1$
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 2a | Series $1-x^2+x^4-\cdots$, no negative powers | confirmed | Geometric series. Script coefficient `(-1)^(k/2)` for even k |
| 2b | Radius 1, set by the poles at ±i | confirmed | |
| 2c | Error at 0.9 falls every frame, 0.448 → 0.044 | confirmed | Script: 0.44751 … 0.04407, monotone over 12 frames. Closed form $0.9^{2m+2}/1.81$ gives the same values |
| 2d | Error at 1.2 grows every frame, 0.590 → 32.6 | confirmed | Script: 0.59016 … 32.58068, monotone |
| 2e | Alt: even-power sums, [−1,1] shaded, settle inside and swing away outside | confirmed | Contact sheet, all 12 frames |

### Case 03: $\sin x/x^3$ about 0, $0<\|x\|<\infty$
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 3a | $f=x^{-2}-\frac16+\frac{x^2}{120}-\cdots$ | confirmed | sympy series. Contour integral at $\rho=1$ gives $a_{-2}=1$, $a_0=-0.1666666667$, $a_2=0.008333333$, and zero for odd k. Script `(-1)^((k+2)/2)/(k+3)!` matches |
| 3b | $f-x^{-2}\to-1/6$ | confirmed | |
| 3c | At x=0.05, f=399.83, and the last sum (powers −2..16) = 399.83 | confirmed | f=399.833354, sum=399.833354 (script and mpmath) |
| 3d | Degree-9 Taylor about 1 (10 terms) gives 40.6 there | confirmed | Script 40.59119. sympy 40.59119062 |
| 3e | Taylor about 1 converges only on 0<x<2 | confirmed | Radius = distance to the pole at 0 = 1 |
| 3f | Frame 1 sum $x^{-2}$→0, frame 2 → −1/6, frame 3 on contains a positive power | confirmed | Frames are −2; −2..0; −2..2; …; −2..16 (10 frames) |
| 3g | Alt: orange about 1 stays finite at 0, and in the last frame it is on the curve near 1 and leaves before 2 | confirmed | Taylor error: −8e−4 at 1.4, −0.040 at 1.6, −0.63 at 1.8, −5.25 at 2.0. Frame 10 shows it leaving at about 1.6 |

### Case 04: $(x^2+1)/(x^2-1)$ in powers of $1/x$, $\|x\|>1$
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 4a | $f=1+2x^{-2}+2x^{-4}+\cdots$ | confirmed | sympy in $w=1/x$: [1,0,2,0,2,0,2,0] |
| 4b | Every partial sum →1, the horizontal asymptote | confirmed | Every frame includes power 0. The frames are −2m..0 for m=0..9 |
| 4c | Last frame (−18..0) within 0.0011 on $1.5\le\|x\|\le10$ | confirmed | Max error 0.0010826 (script) |
| 4d | Degree-9 Taylor about 3 leaves the window near x=5.69 | confirmed | It crosses y=−3 at x=5.6855 |
| 4e | It equals $-3.06\times10^4$ at x=10, where f=1.0202 | confirmed | −30625.0 (script and sympy). f=1.020202 |
| 4f | The Taylor series about 3 converges only on 1<x<5 | confirmed | Nearest pole at 1, radius 2 |
| 4g | At x=0.5 the last sum is $6.99\times10^5$, while f=−1.67 | confirmed | 699049 and −1.66667 |
| 4h | Alt: levels off at y=1 outside x=±1, and orange leaves the curve before x=5 in the last frame | confirmed | Taylor error −0.016 at 4.5, −0.092 at 4.8, −0.25 at 5.0. Frame 10 viewed |

### Case 05: $4/((x-1)(x+3))$, $\|x\|<1$
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 5a | $f=\frac1{x-1}-\frac1{x+3}$, with poles at 1 and −3 | confirmed | Algebra |
| 5b | $a_k=-1-(-1)^k/3^{k+1}$ | confirmed | sympy Maclaurin [−4/3, −8/9, −28/27, −80/81, −244/243] equals the formula |
| 5c | At 0.5 the last frame gives −2.28559 vs f=−2.28571 | confirmed | −2.285592 and −2.285714 (powers 0..13) |
| 5d | At 1.5 it gives −582 vs f=1.78 | confirmed | −582.081 and 1.7778 |
| 5e | Alt: settles inside, leaves outside, asymptotes at −3, 1 and y=0 | confirmed | Contact sheet and frame 14 |

### Case 06: same $f$, $1<\|x\|<3$
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 6a | $a_k=-(-1)^k/3^{k+1}$ (k≥0), $a_k=1$ (k<0) | confirmed | Contour at $\rho=2$: a_{−3..3} = 1, 1, 1, −0.33333, 0.11111, −0.037037, 0.012346 |
| 6b | One series covers both (−3,−1) and (1,3) | confirmed | |
| 6c | Last frame (−12..12): error <0.19 on [−2.5,−1.5] and <0.02 on [1.5,2.5] | confirmed | Maximum errors are 0.18693 and 0.017005 (script and mpmath) |
| 6d | Degree-24 Taylor about 2 (25 terms) has error <1e−7 on [1.5,2.5] | confirmed | Max 5.96e−8 (script and sympy) |
| 6e | The Taylor series about 2 converges only on 1<x<3 | confirmed | Radius 1 |
| 6f | At x=−2 the polynomial is $3.8\times10^{14}$, where f=−1.33 | confirmed | 3.753e14 and −1.3333 |
| 6g | Alt: blue follows both shaded intervals, orange only the right one | confirmed | Frame 12 viewed |

### Case 07: same $f$, $\|x\|>3$
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 7a | $a_{-k}=1-(-3)^{k-1}$, with $a_{-1}=0$, so the series is $4x^{-2}-8x^{-3}+28x^{-4}-\cdots$ | confirmed | Contour at $\rho=5$: a_{−5..0} = −80, 28, −8, 4, 0, 0. sympy in 1/x: [0,0,4,−8,28,−80] |
| 7b | No constant or positive power, so every sum →0 | confirmed | Frames −n..−2 |
| 7c | Last frame (−13..−2) error <7e−4 on $5\le\|x\|\le12$ | confirmed | Max 6.530e−4 |
| 7d | Degree-11 Taylor about 5 equals −75.0 at 12, where f=0.0242 | confirmed | −74.963 and 0.024242 |
| 7e | The Taylor series about 5 converges only on 1<x<9 | confirmed | Radius 4 (pole at 1) |
| 7f | Alt: follows the curve toward 0 on both sides, and orange leaves before x=9 in the last frame | confirmed | Taylor error −0.027 at 8.5, −0.069 at 8.8, −0.125 at 9. Frame 12 viewed |

### Case 08: $e^{1/x}$ about 0, $0<\|x\|<\infty$
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 8a | $e^{1/x}=1+x^{-1}+x^{-2}/2!+\cdots$ | confirmed | Contour at $\rho=1$: a_{−4..1} = 1/24, 1/6, 1/2, 1, 1, 0 |
| 8b | Essential singularity, $f\to+\infty$ (0⁺), $f\to0$ (0⁻), $f\to1$ (\|x\|→∞) | confirmed | |
| 8c | Every partial sum →1 and lies below f for x>0 | confirmed | All terms are positive for x>0, so each partial sum is strictly below f. The script's floating-point check reports equality to rounding (difference 0.0) at x≈5.4–6 in late frames, and no sum exceeds f |
| 8d | At 0.2 the last sum (−11..0) = 147.6 vs f=148.4 | confirmed | 147.6038 and 148.4132 |
| 8e | Degree-11 Taylor about 1 gives 44.5 there | confirmed | Script 44.53235. sympy 44.53235 |
| 8f | The Taylor series about 1 converges only on 0<x<2 | confirmed | Radius 1 |
| 8g | At −0.1 the last sum ≈ −1163, while f≈4.5e−5 | confirmed | −1162.62 and 4.540e−5 |
| 8h | Alt: rises along x=0 from the right, levels toward y=1, and orange leaves before 2 | confirmed | Taylor error −0.088 at 1.6, −0.52 at 1.7, −2.4 at 1.8. Frame 12 viewed |

### Wiring and headings (all 8 cases)
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| W1 | Case N links `laurent_animations_all.jl` and embeds `laurentNN.gif` | confirmed | index.qmd lines 32–90. The GIF name is built from `case.id` |
| W2 | Each heading's function and region equal the case-table row and the GIF title | confirmed | All 8 titles read at full size or on the contact sheets. Rows 01–08 match their headings (function, centre, region) |

---

### 3. Implementation checks: `laurent_animations_all.jl`

**Method.** Each frame plots a finite partial sum $\sum_{k\in P} a_k x^k$ with closed-form Laurent coefficients for the stated region. There is no hidden variant. The comparison curve is a genuine Taylor polynomial about `ref`, built from Taylor-arithmetic helpers:
- `taylor_sin(c,n)` uses $\sin^{(k)}(c)=\sin(c+k\pi/2)$.
- `taylor_inv_pow(c,p,n)` uses $(c+t)^{-p}=\sum(-1)^k\binom{p+k-1}{k}c^{-p-k}t^k$.
- `series_mul` is the truncated Cauchy product.
- `taylor_exp_of` uses the recurrence $k g_k=\sum j h_j g_{k-j}$ for $e^{h}$.
- Case 04 is decomposed as $1+\frac1{x-1}-\frac1{x+1}$, correctly, since $\frac1{x-1}-\frac1{x+1}=\frac2{x^2-1}$.

**Numbers.** The script's Laurent coefficients equal the sympy series and the contour-integral values for every case (tables above). The script's Taylor coefficients about `ref` (first six shown) equal sympy's to every printed digit:
- 03: 0.841471, −1.984111, 3.007183, −4.000740, 4.999841, −5.999985
- 04: 1.25, −0.1875, 0.109375, −0.05859375, 0.0302734, −0.0153809
- 06: 0.8, −0.96, 0.992, −0.9984, 0.99968, −0.999936
- 07: 0.125, −0.046875, 0.013672, −0.003662, 0.000946, −0.000240
- 08: 2.718282, −2.718282, 4.077423, −5.889611, 8.268107, −11.348827

All evaluated quantities quoted on the page agree between the script's routines and the independent mpmath/sympy computation (ledger).

**Reference values.** The "exact" curve is $f$ itself in closed form. The masking is correct: `sinc_f(0)=1` (removable), and NaN at the true poles (03, 04, 05–07, 08 at their singular points), with the pole abscissae inserted into the grid so no line bridges a pole.

**Picture.** I viewed every contact sheet and the last frame at full size for Cases 01, 03, 04, 05, 06, 07, 08.
- Frame counts: 14/12/10/10/14/12/12/12, matching `frames`.
- Each legend's powers and term counts match `frames` and `nterms`.
- Orange degree = blue term count − 1.
- Shading, asymptotes and titles match the case rows.
- The y-limits clip large values (for example, the Case 04 sum inside \|x\|<1 and the Case 06 Taylor polynomial at x=−2). This clipping does not change what a reader would conclude, and the page gives those off-window values numerically.

Could not determine: nothing material. Mathews' exact example functions could not be read (missing formula images), but the page makes no claim to reproduce them.

