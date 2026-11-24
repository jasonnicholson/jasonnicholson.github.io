# Laurent Series — animation review (round 8)

Page: `pages/numerical-methods/laurent-series/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** 0 Error, 0 Misleading, 0 Minor.

Every coefficient table, every reference Taylor polynomial and every number quoted on the page was reproduced independently; every heading agrees with its case-table row and GIF title; every alt-text statement agrees with the frames and the computed departure points. Details below.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `laurent_animations_all.jl` | 0 | 20.5 | 8 GIFs (laurent01.gif … laurent08.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | $f=\sum a_k(x-x_0)^k$, $a_k=\frac1{2\pi i}\oint_C f(z)(z-x_0)^{-(k+1)}dz$, $C$ any positive circle in the annulus | confirmed | Standard Laurent theorem; the same formula, evaluated numerically on a circle, reproduces every case's coefficients (see §3) |
| D2 | Terms with $k<0$ form the principal part; coefficients unique per annulus; different annuli give different series | confirmed | Standard; Cases 05–07 exhibit three distinct series of one function |
| D3 | Analytic on whole disk ⇒ all negative coefficients zero, series = Taylor | confirmed | Cauchy–Goursat; Cases 01, 02, 05 contour coefficients for $k<0$ are 0 to 1e-17 |
| D4 | Analytic on a connected region containing the annulus + non-removable singularity on/inside inner circle ⇒ some negative coefficient nonzero | confirmed | If all $a_{k<0}=0$, the series defines $g$ analytic on $|x-x_0|<R$; any path in the region from the annulus to a point inside the inner circle ends with a segment inside the outer circle, so region∩disk is connected and $f=g$ there by the identity theorem, making the singularity removable |
| D5 | $(x-x_0)^{-k}$ infinite at $x_0$, →0 at ∞; a polynomial has no vertical asymptote and, unless constant, no horizontal one | confirmed | Elementary |

### Animations introduction
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| I1 | Blue = partial sum, magenta = f | confirmed | script lines 169, 174; all frames |
| I2 | Dashed black lines are the asymptotes of f | confirmed | `vasym`/`hasym` per row: 01 y=0; 02 y=0; 03 x=0,y=0; 04 x=±1,y=1; 05–07 x=-3,x=1,y=0; 08 x=0 (one-sided), y=1 — all true asymptotes |
| I3 | Green shading = convergence region on the real line | confirmed | `regions`: 01 whole window; 02 (-1,1); 03 (-6,0)∪(0,6); 04 \|x\|>1; 05 (-1,1); 06 (-3,-1)∪(1,3); 07 \|x\|>3; 08 x≠0 |
| I4 | In negative-power cases, orange = Taylor polynomial about a regular point inside the shaded region, same number of terms | confirmed | refs 1,3,2,5,1 for cases 03,04,06,07,08, each inside its shading; degree = nterms−1 (line 178); none drawn in 01, 02, 05 |
| I5 | Legend lists the powers included | confirmed | every contact sheet |
| I6 | Mathews' module (Complex Analysis §7.3) has no animations; it works a disk/annulus/exterior example like Cases 05–07 | confirmed | archive header "7.3 Laurent Series Representations"; Example 7.7 "three different Laurent series … in the disk, the annulus, and the region"; no animated GIFs referenced |

### Case 01 — sin x / x
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 01a | Heading: about 0, all x | confirmed | row 01; title "sin(x)/x about 0: every negative power vanishes"; shading = full window |
| 01b | Series $1-x^2/6+x^4/120-\cdots$, no negative power, removable singularity, equals Taylor series, converges for all x | confirmed | contour coefficients vs script: max rel diff 9e-18 for k=-3…26 |
| 01c | 0.01-interval widens every frame, ≈0.25 → ≈10.9 | confirmed | probe.jl: 0.2450, 1.0535, …, 10.0790, 10.8560 (strictly increasing, 14 frames) |
| 01d | Alt: sums on [-14,14], no negative power, match on wider interval each frame | confirmed | xlims (-14,14); sheet |

### Case 02 — 1/(1+x²)
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 02a | Heading: about 0, \|x\|<1 | confirmed | row 02; GIF title |
| 02b | Series $1-x^2+x^4-\cdots$, radius 1 from poles ±i | confirmed | contour coefficients match (1.8e-25) |
| 02c | Error at 0.9 falls every frame, 0.448 → 0.044 | confirmed | 0.44751 … 0.04407, monotone |
| 02d | Error at 1.2 grows every frame, 0.590 → 32.6 | confirmed | 0.59016 … 32.58068, monotone |
| 02e | Alt: settle inside (-1,1), swing away outside | confirmed | sheet |

### Case 03 — sin x / x³
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 03a | Heading: about 0, 0<\|x\|<∞ | confirmed | row 03; title "region 0 < \|x\|" |
| 03b | $f=x^{-2}-1/6+x^2/120-\cdots$; $f-x^{-2}\to-1/6$ | confirmed | contour coefficients match (9e-18) |
| 03c | At 0.05: f=399.83, last sum (powers −2..16) 399.83 | confirmed | 399.8334 / 399.8334 (script and Python) |
| 03d | Degree-9 Taylor about 1, same 10 terms, gives 40.6 | confirmed | script 40.5912; mpmath 40.59119 |
| 03e | Taylor series about 1 converges only on 0<x<2 | confirmed | nearest singularity 0, distance 1 |
| 03f | Frame 1 sum → 0, frame 2 → −1/6, frames ≥3 contain a positive power, unbounded | confirmed | probe: at x=1e3, 1e-6, −0.1667, 8.3e3; frame 3 powers −2..2 |
| 03g | Alt: orange about 1 finite at 0; last frame on curve near 1, leaves before 2 | confirmed | Taylor(0)=54.8 (finite); within 0.05 of f on [0.465, 1.614] |

### Case 04 — (x²+1)/(x²−1)
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 04a | Heading: powers of 1/x, \|x\|>1 | confirmed | row 04; title |
| 04b | $f=1+2x^{-2}+2x^{-4}+\cdots$, every sum → 1 | confirmed | contour coefficients (ρ=2) match to 1e-26 |
| 04c | Last frame powers −18..0; within 0.0011 on 1.5≤\|x\|≤10 | confirmed | max error 0.001083 |
| 04d | Degree-9 Taylor about 3 leaves window near 5.69; equals −3.06e4 at 10 where f=1.0202 | confirmed | leaves ylims at 5.686; −3.063e4 (mpmath −30625.0); f(10)=1.02020 |
| 04e | Taylor about 3 converges only on 1<x<5 | confirmed | nearest singularity 1, distance 2 |
| 04f | At 0.5 last sum 6.99e5, f=−1.67 | confirmed | 6.99e5 (=699049), −1.6667 |
| 04g | Alt: level off at y=1 outside x=±1; orange matches near 3, leaves before 5 | confirmed | within 0.05 of f on [1.593, 4.690] |

### Case 05 — 4/((x−1)(x+3)), disk
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 05a | Heading: \|x\|<1 | confirmed | row 05; title |
| 05b | $f=\frac1{x-1}-\frac1{x+3}$, poles 1 and −3 | confirmed | algebra |
| 05c | $a_k=-1-(-1)^k/3^{k+1}$ | confirmed | contour coefficients (ρ=0.5) match to 1e-16 |
| 05d | At 0.5: −2.28559 vs −2.28571 | confirmed | −2.285592 / −2.285714 |
| 05e | At 1.5: −582 vs 1.78 | confirmed | −582.08 / 1.7778 |
| 05f | Alt: settle inside (-1,1), leave outside; dashed x=−3, x=1, y=0 | confirmed | frame 14; error <0.025 for x≥−0.8, 0.5 at the boundary −1 |

### Case 06 — annulus
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 06a | Heading: 1<\|x\|<3 | confirmed | row 06; title |
| 06b | $a_k=-(-1)^k/3^{k+1}$ (k≥0), $a_k=1$ (k<0) | confirmed | contour coefficients (ρ=2) match to 2e-17 |
| 06c | Last frame powers −12..12; error <0.19 on [−2.5,−1.5], <0.02 on [1.5,2.5] | confirmed | 0.18693, 0.01700 |
| 06d | Degree-24 Taylor about 2, 25 terms, error <1e-7 on [1.5,2.5] | confirmed | 5.96e-8 |
| 06e | Taylor about 2 converges only on 1<x<3; at −2 it is 3.8e14, f=−1.33 | confirmed | 3.753e14 (mpmath 3.7530e14); −1.3333 |
| 06f | Alt: blue follows both shaded intervals; orange only the right | confirmed | sheet; orange within 0.05 on [1.173, 2.911] only |

### Case 07 — exterior
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 07a | Heading: \|x\|>3 | confirmed | row 07; title |
| 07b | $a_{-k}=1-(-3)^{k-1}$, $a_{-1}=0$, $4x^{-2}-8x^{-3}+28x^{-4}$ | confirmed | contour coefficients (ρ=5) match to 2e-29 |
| 07c | Every sum → 0 | confirmed | only negative powers |
| 07d | Last frame powers −13..−2; error <7e-4 on 5≤\|x\|≤12 | confirmed | 6.53e-4 |
| 07e | Degree-11 Taylor about 5 = −75.0 at 12, f=0.0242; converges 1<x<9 | confirmed | −74.963; 0.02424; nearest singularity 1 at distance 4 |
| 07f | Alt: follow toward y=0 both sides; orange leaves before 9 | confirmed | within 0.02 on [2.09, 8.41] |

### Case 08 — e^{1/x}
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 08a | Heading: about 0, 0<\|x\|<∞ | confirmed | row 08; title |
| 08b | $e^{1/x}=1+x^{-1}+x^{-2}/2!+\cdots$; essential singularity; limits +∞, 0, 1 | confirmed | contour coefficients match to 9e-18 |
| 08c | Every sum → 1, lies below f for x>0 | confirmed | all coefficients positive, truncation drops positive terms |
| 08d | At 0.2: last sum 147.6 vs 148.4; degree-11 Taylor about 1 gives 44.5 | confirmed | 147.6038 / 148.4132 / 44.5324 (mpmath 44.53235) |
| 08e | Taylor about 1 converges only on 0<x<2 | confirmed | singularity at 0, distance 1 |
| 08f | At −0.1 last sum ≈ −1163, f≈4.5e-5 | confirmed | −1162.62; 4.54e-5 |
| 08g | Alt: rise along x=0 from right, level toward y=1; orange leaves before 2 | confirmed | within 0.05 on [0.496, 1.572] |

### Wiring
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| W1 | Each case links `laurent_animations_all.jl` and embeds `laurentNN.gif` of its own number | confirmed | index.qmd lines 32–90; `out_name = "laurent$(case.id).gif"`; GIF titles carry the matching case number |

### 3. Implementation checks — `laurent_animations_all.jl`

**Method.** Partial sums $\sum_{k\in P} a_k x^k$ over a closed-form coefficient function per case; the Taylor comparison uses truncated power-series arithmetic (`series_mul`, `taylor_sin`, `taylor_inv_pow`, `taylor_exp_of` via $k g_k=\sum j h_j g_{k-j}$). This is the Laurent series as described.

**Numbers (coefficients).** Independent check not relying on any remembered formula: Laurent coefficients computed by the page's own contour integral $\frac1{2\pi}\int_0^{2\pi} f(\rho e^{it})(\rho e^{it})^{-k}dt$ with mpmath at a radius inside each case's annulus (ρ = 1, 0.5, 1, 2, 0.5, 2, 5, 1), over the full index range of each case's frames plus margin. Max relative difference from the script's `coef`: 01 9e-18, 02 2e-25, 03 9e-18, 04 1e-26, 05 1e-16, 06 2e-17, 07 2e-29, 08 9e-18.

**Reference values (Taylor polynomials).** Script `ref_coefs(d)` vs `mpmath.taylor(f, ref, d)`: max relative coefficient difference 03 3.9e-16, 04 0, 06 0, 07 0, 08 1.6e-16. Spot evaluations (script / Python): 03 at 0.05 40.5912/40.5912; 04 at 10 −3.063e4/−30625.0; 06 at −2 3.753e14/3.7530e14; 07 at 12 −74.9628/−74.9628; 08 at 0.2 44.5324/44.5324. f itself is the closed form in each row and matches each heading.

**Picture.** Frames read for every case (contact sheets; full-size last frames of 03 and 05). Frame counts 14, 12, 10, 10, 14, 12, 12, 12; powers per frame and term counts in the legends equal the case table (probe.jl prints them). Blue is the partial sum, orange the Taylor polynomial of degree nterms−1 at the stated ref, drawn in x−ref. Poles and 0 are inserted into the grid and set to NaN so no curve is joined across a pole. y-limits clip the curves near poles, which is the normal display and does not hide any feature the page discusses (the one quoted value off-screen, Case 03's Taylor value at 0.05, is stated in the text, not claimed to be visible). Titles name the function and region of each row. In Case 08 frame 1 and Case 07 frame 1 the dashed horizontal asymptote coincides with the blue constant/near-zero curve; harmless.

**Regeneration.** Manifest: all 8 GIFs byte-identical to a scratch run, exit 0.

### Legacy archive
Mathews §7.3 Examples: Extra Example 1 and 7.8 (series obtained by dividing a Maclaurin series by a power of z), 7.7 (one rational function in disk, annulus and exterior), 7.9 (exp series with a substituted argument, valid in a punctured plane). Exact functions cannot be read because the formula images are missing locally. The page states its examples are its own and not Mathews', and covers the same four kinds (Cases 01/03, 05–07, 08). No fidelity finding.

