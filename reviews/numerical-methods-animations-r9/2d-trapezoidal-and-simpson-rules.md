# 2D Trapezoidal and Simpson Rules — animation review (round 9)

Page: `pages/numerical-methods/2d-trapezoidal-and-simpson-rules/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and every number in the frames agrees with independent computation. Details below.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson2daa.jl` | 0 | 18.4 | simpson2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `trapezoidal2daa.jl` | 0 | 13.0 | trapezoidal2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpson2daa.gif` | 8 | byte-identical | simpson2daa |
| `trapezoidal2daa.gif` | 8 | byte-identical | trapezoidal2daa |

### Page references

- Scripts linked: `trapezoidal2daa.jl`, `simpson2daa.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.13–16 | "Examples 1–6 of the archived module use I = ∫0^1∫0^1 8e^{-x²-y⁴} dy dx" | Archive integrand image gr_43 is byte-identical (md5 273bf7ac…) to gr_67, gr_87, gr_108, gr_132, gr_153 used by Examples 2–6; code image gr_111 `f[x_,y_]=8 e^{-x^2-y^4}` | confirmed |
| 2 | l.19 | surface z = 8e^{-x²-y⁴} over R=[0,1]² | archive gr_111/gr_114 (region 0≤x≤1, 0≤y≤1) | confirmed |
| 3 | l.24–28 | I_T = hk ΣΣ w_i w_j f(x_i,y_j), w_0=w_m=1/2, else 1 | Equivalent to Mathews T2D (gr_16: hk/4 with 1/2/4 pattern). Script l.25–39 implements exactly this. Degree-of-precision check with script routine (dop.jl): exact for 1, xy; error 0.041667 for x² at n=2 (=1D trapezoid error for x², h=1/2) | confirmed |
| 4 | l.32–36 | I_S = hk/9 ΣΣ a_i a_j f, a=1,4,2,…,4,1 | Equivalent to Mathews S2D (gr_36, gr_42new) with h=(b-a)/(2m) in his notation. Script l.25–40 implements exactly this. dop.jl: exact (error 0.0) for 1, xy, x², y², x³y³; nonzero for x⁴ (0.008333 at n=2, ratio 16 to n=4: 0.000521) | confirmed |
| 5 | l.38–41 | m panels of width h=(b-a)/m, nodes x_i=a+ih; Simpson needs m,n even | Script uses n panels, `range(..., length=n+1)`, n_seq all even | confirmed |
| 6 | l.45–47 | full-domain mesh refinement on [0,1]² for f, benchmark I≈5.04756680717 | mpmath 30-digit: I = 5.04756680716753966…, and separable product 8·∫e^{-x²}·∫e^{-y⁴} gives the same; rounds to 5.04756680717. (Archive images for Example 2's value, gr_68–86, are missing, so the "archived" provenance itself could not be seen; the value is correct.) | confirmed (value); provenance could not be determined |
| 7 | l.49 | Julia scripts linked under each case | l.65, l.79 | confirmed |
| 8 | l.51–52 | archived snapshot incomplete for some intermediate image IDs | gr_46–66 and gr_68–86 absent from Images/ although referenced by lnk_2/lnk_3 | confirmed |
| 9 | l.53–55 | Example 7: composite Simpson on double integral with inner limits functions of x; not animated | lnk_8 + "More Background" text | confirmed |
| 10 | Case 1 heading | 2D Trapezoidal Rule, f=8e^{-x²-y⁴} | script l.9, title of every frame | confirmed |
| 11 | Case 1 Behavior | coarse-to-fine tensor grid updates over the whole square each frame | frames 1–8: 2,4,6,8,10,12,16,20 panels, grid covers whole square | confirmed |
| 12 | Case 1 | converges toward the archived reference | errors 0.2985, 0.0722, 0.0320, 0.0180, 0.0115, 0.0080, 0.0045, 0.0029 (monotone decrease) | confirmed |
| 13 | Case 1 | visible second-order error decay | observed order log2(e(n)/e(2n)): 2.047 (2→4), 2.008 (4→8), 2.003 (6→12), 2.002 (8→16), 2.001 (10→20) | confirmed |
| 14 | Case 1 | black lines join nodes with straight segments: grid lines of piecewise-bilinear interpolant, whose integral is I_T | script `gridlines` uses only node values (node error 0.0, 2(n+1)² points); interp.py: exact integral of piecewise-bilinear interpolant = 4.749087736005079 (n=2), 4.975344691378608 (n=4), 5.044698421646745 (n=20), equal to I_T | confirmed |
| 15 | Case 1 alt text | coloured surface, straight black lines through nodes, 2x2 to 20x20, convergence to benchmark | frames 1 and 8, sheet | confirmed |
| 16 | Case 1 wiring | link trapezoidal2daa.jl, embed trapezoidal2daa.gif | manifest: GIF produced by that script, byte-identical | confirmed |
| 17 | Case 2 heading | 2D Simpson Rule, same f | script l.9, frame titles | confirmed |
| 18 | Case 2 Behavior | Simpson tensor weights recomputed on each refined mesh | `simpson2d(n)` called per frame | confirmed |
| 19 | Case 2 | Simpson reaches high accuracy with fewer refinements than trapezoidal | Simpson 6x6 error 6.68e-4 already below trapezoid 20x20 error 2.87e-3; observed Simpson order 3.79, 4.44, 4.18, 4.09, 4.06 | confirmed |
| 20 | Case 2 | black curves are quadratics through nodes over each pair of panels along every grid line | `quadpieces` is the Lagrange quadratic on [t_k, t_{k+2}], k odd; reproduces node values (max error 1.8e-15 at n=20) | confirmed |
| 21 | Case 2 | piecewise-biquadratic interpolant, one patch per 2x2 block, integral is I_S | interp.py: integral of biquadratic interpolant = 5.106262624447544 (n=2), 5.051811626509001 (n=4), 5.047571483116476 (n=20), equal to I_S | confirmed |
| 22 | Case 2 | on 2x2 mesh curves differ from trapezoid straight lines by up to 0.51 in z | curves.py: max |quad−lin| = 0.51095 on line x=0 at y=0.75 | confirmed |
| 23 | Case 2 alt text | coloured surface, black piecewise-quadratic curves, 2x2 to 20x20, convergence toward benchmark | frames 1 and 8, sheet | confirmed |
| 24 | Case 2 wiring | link simpson2daa.jl, embed simpson2daa.gif | manifest | confirmed |
| 25 | simpson2daa.jl l.14 comment | n=2 quadratic along x=0 peaks at about 8.30 | curves.py: 8.2973 at y≈0.191; Julia sampled curve max 8.2973; zlims 8.4 so nothing is clipped | confirmed |
| 26 | trapezoidal2daa.jl l.16 / simpson2daa.jl l.16 comments | archived checkpoints 10x10 and 20x20 | Archive: Trapezoidal2D at m=n=10 then finer grid (gr_99: steps 1/10 and 1/20); Simpson2D at m=n=5 and 10 with h=(b-a)/(2m) (gr_42new) = 10 and 20 panels. Both in n_seq | confirmed |
| 27 | Frame titles | I_T, I_S, |error| per frame | Julia values (instr.jl) equal independent scipy values to all printed digits (table below) | confirmed |

### 3. Implementation checks

### trapezoidal2daa.jl
- **Method:** composite product trapezoidal rule, weights 1/2 at ends, 1 inside, scaled by hx·hy. Same n in x and y. Matches page formula and Mathews T2D.
- **Numbers:** script vs independent (scipy `trapezoid` applied along each axis, `indep.py`):

| n | script I_T | independent I_T | script |error| | true |error| |
|---|---|---|---|---|
| 2 | 4.749087736 | 4.749087736005 | 0.298479071 | 2.985e-1 |
| 4 | 4.975344691 | 4.975344691379 | 0.072222116 | 7.222e-2 |
| 6 | 5.015604706 | 5.015604705554 | 0.031962102 | 3.196e-2 |
| 8 | 5.029613219 | 5.029613219039 | 0.017953588 | 1.795e-2 |
| 10 | 5.036083764 | 5.036083763603 | 0.011483044 | 1.148e-2 |
| 12 | 5.039595175 | 5.039595175444 | 0.007971632 | 7.972e-3 |
| 16 | 5.043084264 | 5.043084264495 | 0.004482543 | 4.483e-3 |
| 20 | 5.044698422 | 5.044698421647 | 0.002868386 | 2.868e-3 |

  Property checks: degree of precision 1 per variable (exact on xy, not on x²); observed order 2.00.
- **Reference:** 5.04756680717 vs mpmath 5.0475668071675…; difference 3e-12, invisible at the 9 printed digits.
- **Picture:** frames 1, 4, 8 inspected and contact sheet; title n, I_T and error match the table; lines are straight segments through the (n+1)² nodes; f ≤ 8 < zlim 8.2, so no clipping.

### simpson2daa.jl
- **Method:** composite product Simpson rule, weights 1,4,2,…,4,1 per axis, scaled by hx·hy/9, n even. Matches page formula and Mathews S2D (his m = n/2).
- **Numbers:** script vs independent (scipy `simpson` along each axis):

| n | script I_S | independent I_S | script |error| | true |error| |
|---|---|---|---|---|
| 2 | 5.106262624 | 5.106262624448 | 0.058695817 | 5.870e-2 |
| 4 | 5.051811627 | 5.051811626509 | 0.004244819 | 4.245e-3 |
| 6 | 5.048234773 | 5.048234772908 | 0.000667966 | 6.680e-4 |
| 8 | 5.047762777 | 5.047762777353 | 0.00019597 | 1.960e-4 |
| 10 | 5.047644586 | 5.047644586076 | 7.7779e-5 | 7.778e-5 |
| 12 | 5.047603712 | 5.047603712117 | 3.6905e-5 | 3.690e-5 |
| 16 | 5.047578304 | 5.047578303611 | 1.1496e-5 | 1.150e-5 |
| 20 | 5.047571483 | 5.047571483116 | 4.676e-6 | 4.676e-6 |

  Property checks: exact through x³y³, not x⁴ (error ratio 16 from n=2 to 4); observed order 4.06–4.44.
- **Reference:** as above.
- **Picture:** frames 1, 4, 8 and sheet inspected; title values match; curves are piecewise quadratics through the nodes on panel pairs, as the page says; peak 8.297 lies inside zlim 8.4, so no clipping.

### Archive fidelity
Same integrand, same domain, archive checkpoints (10x10, 20x20 panels for both rules) are in the frame sequence; Example 7 omission is disclosed on the page. Archive Examples 3/5 report error ratios ≈1/4 and ≈1/16 for halving h; the scripts give 0.2498 (trapezoid 10→20) and 0.0601 (Simpson 10→20). No fidelity departure found.

