# Taylor Series Method for ODE's — animation review (round 6)

Page: `pages/numerical-methods/taylor-series-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I checked every checkable claim in the Animations section, the alt texts and the wiring against values I computed myself. All of them hold at the precision they are stated to. Both implementations are correct Taylor methods of the stated order, and their reference values are accurate to about 1e-17. The frames show what was computed.

The archive gives no Fidelity departure either. The page uses Mathews' ODE, interval, initial value, orders (n=3 and n=4) and his exact sequence of 21 values of m. Where its coarse-m values differ from his, it says so openly.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `taylorderivativeaa.jl` | 0 | 12.1 | taylorderivativeaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `taylorderivativebb.jl` | 0 | 9.1 | taylorderivativebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `taylorderivativeaa.gif` | 21 | byte-identical | taylorderivativeaa |
| `taylorderivativebb.gif` | 21 | byte-identical | taylorderivativebb |

### Page references

- Scripts linked: `taylorderivativeaa.jl`, `taylorderivativebb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Abbreviations: "ours" means my independent Python and mpmath computation. "script" means the instrumented copy of the script.

### Introduction

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| I1 | IVP $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | Script lines 19, 26-27 (aa) and 12, 35-36 (bb). Legacy frames are titled "y' = 1 - t∛y", have t-axis 0..5 and a red dot at (0,1). | confirmed |
| I2 | "repeats Mathews' step-refinement sweep" with "the 21 values of Mathews' animations, m = 12, 14, …, 150" | Script `ms` lists the same 21 values. The legacy GIFs have 21 distinct labelled frames with exactly these m. | confirmed |
| I3 | Each frame is a complete run with $h=5/m$ | `taylor3(m)`/`taylor4(m)` use `h=(T-t0)/m` and run all m steps. The frame titles show "h = 5/m". | confirmed |
| I4 | "drawn over a fine-step reference solution" | The reference is the same method with 50,000 steps. Its y(5)=0.008119920464867961 equals mpmath's 0.0081199204648679610 to every digit. | confirmed |
| I5 | "labelled with the computed y(5) and its error" | Annotations at lines 95-96 appear in every frame. | confirmed |
| I6 | Points below y=-0.3 are marked by triangles on the bottom edge, and the true minimum is printed | Lines 74, 87-89 and 99-102. Frames aa 1-2 and bb 1-7 show the triangles and print "min y = …". The values match the script output (for example -8.597 at 4.58, and -7751 at 4.06). | confirmed |
| I7 | $\sqrt[3]{y}$ is the real cube root | `cbrt` is used everywhere. | confirmed |
| I8 | Truncated Taylor series $y_{n+1}=y_n+hy'_n+\frac{h^2}{2}y''_n+\cdots$, local accuracy $O(h^{p+1})$ | Step functions at lines 22 (aa) and 31 (bb). The global errors confirm the order (see section 3). | confirmed |
| I9 | Julia sources are linked under each case | Each case links its script. | confirmed |

### Case 1 (order 3)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Heading: order 3, same IVP, m = 12 to 150 | Script and frame titles agree. | confirmed |
| A2 | Three derivative terms are used per step | The step uses y', y'' and y'''. | confirmed |
| A3 | Local error $O(h^4)$, global error $O(h^3)$, same order as RK3 | Max node error at m=100/200/400 is 1.327e-5, 1.579e-6 and 1.916e-7. The ratios are 8.4 and 8.2, close to 2^3. | confirmed |
| A4 | Reference rises to about 1.4498 near t=0.88 | The mpmath peak is y=1.4497667 at t=0.883556, where t·y^{1/3}=1. | confirmed |
| A5 | Reference y(5)=0.0081199 | mpmath gives 0.00811992046. | confirmed |
| A6 | m=12..36 visibly leave the reference in the tail | Max node errors are 8.6, 109, 0.58, 0.13, 1.2, 0.048, 0.15, 0.15 and 0.029 (m=36 has a bump of 0.03 at t=4.86, visible in frame 9). | confirmed |
| A7 | y(5)≈-4.47 for m=12 and -109 for m=14 | Ours: -4.4676549 and -109.0749263. The script prints the same. | confirmed |
| A8 | m=20 jumps from 0.0068 at t=4 to 1.22 at t=4.25, ends at 0.0895 | Ours: 0.006795 → 1.21616, end 0.0895215. | confirmed |
| A9 | From m=40 on each run decreases steadily after its peak and stays within 3e-4 of the reference at every node | No increase after the peak for any m≥40. Max node error at m=40 is 2.504e-4, and smaller for larger m. | confirmed |
| A10 | m=100: largest node error 1.3e-5, error in y(5) -1.2e-9 | Ours: 1.327e-5 and -1.186e-9. | confirmed |
| A11 | ∂f/∂y reaches -41.3 at t=5 | -41.2554. Its magnitude is increasing on [0.9,5], so t=5 is the extreme. | confirmed |
| A12 | Threshold h≈0.0609 (m≤82; here m=12..80), stability limit 2.513 | Order-3 R(z) crosses \|R\|=1 at z=-2.5127453. h*=2.5127/41.2554=0.060907, m*=82.09. Onset occurs for m≤80 and not for m≥90. | confirmed |
| A13 | Beyond the limit, $y'=\lambda y$ amplifies errors | \|R(z)\|>1 for z<-2.5127 on the real axis. | confirmed |
| A14 | For m=12..48 the error at t=5 exceeds the error at the last node before the shaded region | Holds for every m in 12..48 (for example m=48: 4.66e-7 against 9.2e-8). It fails for 52..80, which the page does not claim. | confirmed |
| A15 | m=80 shading starts at t≈4.96, m=12 at t≈3.07 | Onset along the exact solution: 4.9577 and 3.0663. The script shows 4.96 and 3.07. | confirmed |
| A16 | For m=52..80 the error in y(5) is below 3.1e-9 | 1.06e-9, -3.091e-9, -2.93e-9, -2.40e-9, -1.92e-9. | confirmed |
| A17 | m=90..150 stay below 2.513 up to t=5 | h·41.255 at m=90 is 2.292. Frames 18-21 say "< 2.513 up to t = 5" and have no shading. | confirmed |
| A18 | Mathews' y(5) is reproduced to every printed digit for 19 of 21 m, the exceptions being m=12 and 14, which go negative before t=5 | Legacy labels compared with ours for m=16..150 all match (for example 0.1563161, 0.0895215, -0.0401212, 0.0251901, 0.00816 and 0.0081204). m=12 (0.1766603 against -4.4677) and m=14 (-3.4636068 against -109.07) differ. Both of those go negative first at t=4.17 and t=4.64. m=24 and 28 first go negative only at t=5, so they are not "before t=5". | confirmed |
| A19 | Mathews shows y(5)=0.1766603 at m=12 | Legacy frame 4. | confirmed |
| A20 | Alt text: reference peaks near 1.45 at t≈0.88 and decays to 0.0081 | See A4 and A5. | confirmed |
| A21 | Alt text: drops off the bottom for m=12 and 14, spikes to 1.22 at m=20 | Low-node counts are 2 and 1 for those m and 0 for all others. Spike: 1.216. | confirmed |
| A22 | Alt text: shading for m=12..80, on the reference from m=40, y(5)=0.0081199 at m=150 | See A12 and A9. m=150 gives 0.008119920093. | confirmed |
| A23 | Wiring: link `taylorderivativeaa.jl`, embed `taylorderivativeaa.gif` (order 3) | The script writes that GIF, and the frames are titled "Taylor order 3". | confirmed |

### Case 2 (order 4)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| B1 | Heading: order 4, same IVP, m = 12 to 150 | Script and frame titles agree. | confirmed |
| B2 | Four derivative terms, all computed analytically | The closed form of y'''' equals the sympy total derivative exactly (difference 0). | confirmed |
| B3 | Local error $O(h^5)$, global error $O(h^4)$, same order as RK4 | Max node error at m=100/200/400 is 8.02e-7, 4.58e-8 and 2.71e-9. The ratios are 17.5 and 16.9. | confirmed |
| B4 | m=12..32 leave the reference in the tail and go negative, though the exact solution stays positive | Minima: -3.12, -0.74, -7751, -19.9, -10.4, -1505, -951, -0.081. The exact solution decreases to 0.00812 and is never negative. | confirmed |
| B5 | y(5)≈-7666 for m=16 | -7665.8734 | confirmed |
| B6 | m=20 turns negative at t=4.25, reaches about -10.4 at t=4.5 and ends at about -5.25 | First negative node at t=4.25, min -10.434 at 4.5, y(5)=-5.2535. | confirmed |
| B7 | y(5)≈-0.081 for m=32 | -0.080651 | confirmed |
| B8 | From m=36 on, within 2.7e-3 of the reference at every node | Max node errors are 2.651e-3 (m=36), 1.361e-3 (m=40), then smaller. | confirmed |
| B9 | m=36 and 40 turn up once near the end, by about 0.0015 and 0.0005, too little to see | Single increases: 0.0015 at t=4.861 and 0.00055 at t=5. Frames 9 and 10 show no visible separation. | confirmed |
| B10 | From m=40 on, the error in y(5) falls at every refinement, to 4.8e-12 at m=150 | 1.36e-3, 5.18e-5, 2.55e-6, 2.29e-7, 3.56e-8, 8.24e-9, 7.16e-10, 1.81e-10, 7.45e-11, 3.85e-11, 1.42e-11, 4.76e-12: strictly decreasing. | confirmed |
| B11 | m=100: largest node error 8.0e-7, more than 16 times smaller than order 3's 1.3e-5 | 8.021e-7. Ratio 1.327e-5/8.021e-7 = 16.5. | confirmed |
| B12 | Threshold h≈0.0675 (m≤74; here m=12..70), stability limit 2.785 | Order-4 R(z)=1 at z=-2.7852936. h*=0.067513, m*=74.06. Onset occurs for m≤70 and not for m≥80. | confirmed |
| B13 | For all of these m, the error at t=5 exceeds the error at the last node before the shaded region | True for every m in 12..70 (for example m=70: 7.16e-10 against 5.50e-10). | confirmed |
| B14 | m=70 shading from t≈4.91, m=12 from t≈3.10 | 4.9082 and 3.1032. | confirmed |
| B15 | m=80..150 stay below 2.785 up to t=5 | h·41.255 at m=80 is 2.578. | confirmed |
| B16 | Mathews reproduced for m=32..150, and m=12..28 go negative before t=5 | All 13 legacy labels for m=32..150 match (for example -0.080651, 0.0081972, 0.0094813, 0.0081717, 0.0081225, 0.0081201 and 0.00812). m=12..28 differ, and their first negative times are 4.17, 3.93, 3.75, 4.44, 4.25, 4.58 and 4.82, all before 5. | confirmed |
| B17 | Mathews shows y(5)=0.0711898 at m=20 | Legacy bb frame for m=20. | confirmed |
| B18 | Alt text: drops off the bottom for m=12..28, as low as -7751 at m=16 | Low counts are 3,1,4,2,3,2,1 for m=12..28 and 0 for m=32 (min -0.081). The overall minimum is -7750.7 at m=16. | confirmed |
| B19 | Alt text: shading for m=12..70, on the reference from m=36, y(5)=0.0081199 at m=150 | See B12 and B8. m=150 gives 0.00811992047. | confirmed |
| B20 | Wiring: link `taylorderivativebb.jl`, embed `taylorderivativebb.gif` (order 4) | The script writes that GIF, and the frames are titled "Taylor order 4". | confirmed |

### Counts and frames

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1 | 21 frames per animation, one per m | 21 frames in each committed GIF. Each title shows the right m. | confirmed |

### 3. Implementation checks

### `taylorderivativeaa.jl` (order 3)

- **Method.** This is the Taylor series method of order 3. y', y'' and y''' are exact total derivatives along y'=f, written in c=∛y. `derivs.py` derived them independently: with y=c³ and dc/dt=f/(3c²), the difference between the script's expressions and sympy's is identically 0. The derivation holds for negative c as well, because the real cube root is differentiable away from y=0. The update is y+h y'+h²/2 y''+h³/6 y'''. It is not a neighbouring method.
- **Numbers.** The script's y(5) agrees with my independent Python run for every m to all printed digits:

  | m | script | ours |
  |---|---|---|
  | 12 | -4.4676549 | -4.4676549 |
  | 14 | -109.0749263 | -109.0749263 |
  | 20 | 0.0895215 | 0.08952150734 |
  | 36 | 0.0251901 | 0.02519007421 |
  | 100 | 0.0081199 (err -1.2e-9) | err -1.186e-9 |
  | 150 | err -3.7e-10 | err -3.714e-10 |

  Onset times and off-scale minima also agree (script 3.07/4.96 against ours 3.0663/4.9577; min -8.597 at t=4.58). The order property holds: halving h cuts the max node error by 8.4 and then 8.2.
- **Reference.** The script's 50,000-step order-3 reference gives y(5)=0.008119920464867961. mpmath `odefun` at 30 digits gives 0.0081199204648679610. The peak is at 1.44977 at t=0.8836, matching the exact 1.4497667 at 0.8835558. The reference error is at round-off. The stability limit from the bisection, 2.5127453266, equals the independent value -2.512745327 where R=-1.
- **Picture.** I viewed frames 1, 2, 5, 9 and the contact sheet (m=12..150). Orange lines and nodes are the run and the gray line is the reference. The shading spans [onset, 5] with the stated label. Triangles sit at the bottom edge for nodes below -0.3, and the lines are drawn to their true values and clipped by the axes. The red end marker is omitted when it is off scale. The annotations equal the computed values. The m=20 spike to 1.216 and the m=36 bump near t=4.86 are visible. The title function matches the code. The clamping and fixed limits do not mislead, because the true minimum and y(5) are printed.

### `taylorderivativebb.jl` (order 4)

- **Method.** This is the Taylor series method of order 4. y'''' is a simplified closed form equal to sympy's total derivative of y''' (difference identically 0). The update adds h⁴/24 y''''.
- **Numbers.** The script and my Python run agree for every m:

  | m | script | ours |
  |---|---|---|
  | 12 | -0.5365789 | -0.5365789188 |
  | 16 | -7665.8734003 | -7665.8734 |
  | 20 | -5.2535013 | -5.253501334 |
  | 24 | -1492.8343029 | -1492.834303 |
  | 32 | -0.0806510 | -0.08065097 |
  | 40 | 0.0094813 | 0.009481330864 |
  | 150 | err +4.8e-12 | err +4.762e-12 |

  The order property holds: halving h cuts the max node error by 17.5 and then 16.9.
- **Reference.** The order-4 reference with 50,000 steps gives the same y(5) as mpmath to all 16 digits. The stability limit is 2.7852935634, equal to the independent R=+1 crossing at -2.785293563.
- **Picture.** I viewed frames 2 (m=14) and 10 (m=40) and the contact sheet. The purple run, the shading, the triangles (counts match the script's `low`, for example 4 at m=16) and the "min y" annotations (-7751 at 4.06, -10.43 at 4.50) all match the computed values. At m=40 the run is indistinguishable from the reference, as the page says.

### Note (not a finding)

I tried four ways Mathews might have handled the cube root of a negative y:
- the principal complex root, keeping complex values;
- the principal complex root, taking the real part each step;
- |y|^(1/3);
- the real cube root.

None of them reproduces his coarse-m values (0.1766603, -3.4636068, 0.4929678, -554.44545, 0.0711898). That is consistent with the page's statement that this "has not been reproduced". The page's real-cube-root choice is a valid real extension of the ODE, and the page discloses it.

