# 2D Trapezoidal and Simpson Rules — animation review (round 3)

Page: `pages/numerical-methods/2d-trapezoidal-and-simpson-rules/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no error, no misleading statement and no minor issue that meets the standard. Every checkable claim on the page and every number in the frames agrees with an independent computation (details below).

Observations that I considered and decided are not findings:
- The archive's Simpson2D takes `m`, `n` as the number of *pairs* of panels (`h = (b-a)/(2m)`, image `gr_42new.gif`), whereas the page and script use `m`, `n` = number of panels (even). This is a valid, equivalent formulation; the archive's Example 4 checkpoints (`m = 5`, `m = 10`) correspond to the script's 10x10 and 20x20 panel meshes, and those values agree (see ledger L21).
- The archive's own Example 1 text says "Simpson's rule" but its solution runs `Trapezoidal2D`, and its Example 5 output images (`gr_137/139/141`) repeat the trapezoidal numbers under the label `SR`. These are archive defects; the page correctly treats Example 1 as trapezoidal and does not reproduce the mislabelled numbers.
- The two GIFs use different z-limits (8.2 vs 8.4). This is deliberate (script comment, `simpson2daa.jl:14`) so the n=2 Simpson curve (peak 8.297) is not clipped; nothing is clipped in either GIF.
- Archive Example 7 (non-rectangular region) is not animated, but the page says so explicitly (Description, lines 45-47), so it is not a silent drop.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson2daa.jl` | 0 | 6.9 | simpson2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `trapezoidal2daa.jl` | 0 | 8.9 | trapezoidal2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| L1 | Description l.12-13 | composite 2D Trapezoidal and 2D Simpson rules on a rectangular double integral | both scripts implement tensor-product composite rules on [0,1]^2 | confirmed |
| L2 | l.13-17 | "Examples 1-6 of the archived module use I = ∫0^1∫0^1 8e^{-x^2-y^4} dy dx" | archive integrand images gr_43, gr_67, gr_87, gr_108, gr_132, gr_153 all show this integral; Example 7 (gr_188) is ∫_a^b∫_{c(x)}^{d(x)} | confirmed |
| L3 | l.19 | surface z = 8e^{-x^2-y^4} over R = [0,1]x[0,1] | both scripts `f(x,y)=8*exp(-(x^2)-(y^4))`, limits (0,1) | confirmed |
| L4 | l.24-28 | I_T ≈ hk ΣΣ w_i w_j f, w_0=w_m=1/2, interior 1 | `trapezoidal2daa.jl:25-39`; script routine exact on 1, x, y, xy (error 0.0) and not on x^2 (error 0.04167 at n=2) - degree 1 per variable, as the rule should be | confirmed |
| L5 | l.32-36 | I_S ≈ (hk/9) ΣΣ a_i a_j f, a_0=a_m=1, odd 4, even interior 2 | `simpson2daa.jl:25-40`; script routine exact on x^3y^3 (0.0) and x^2 (0.0), not on x^4 (0.008333 at n=2 = 1/120, the known Simpson error for x^4 with h=1/2) | confirmed |
| L6 | l.38-41 | h=(b-a)/m, k=(d-c)/n, x_i=a+ih, y_j=c+jk; Simpson needs m,n even | scripts use m=n, `range(...,length=n+1)`, all n in n_seq even | confirmed |
| L7 | l.43-44 | archived snapshot incomplete for some intermediate image IDs | Example 1 images gr_46...64 and Example 2 gr_82, Example 6 gr_154...183 are missing on disk | confirmed |
| L8 | l.45-47 | Example 7 applies composite Simpson to a double integral with inner limits functions of x; not animated | archive lnk_8 text and gr_188; no Example 7 case on page | confirmed |
| L9 | l.51-53 | each animation shows full-domain mesh refinement on [0,1]x[0,1] for f = 8e^{-x^2-y^4} | n_seq = [2,4,6,8,10,12,16,20], whole square each frame (sheets) | confirmed |
| L10 | l.53 | archived benchmark I ≈ 5.04756680717 | mpmath: 8·∫e^{-x^2}·∫e^{-y^4} = 5.047566807167540 (also 2D quad identical) → 5.04756680717 to 11 decimals; archive gr_90 shows 5.04756680717 | confirmed |
| L11 | l.55, 65, 79 | Julia source linked under each case | `[Julia source](trapezoidal2daa.jl)` under Case 1, `simpson2daa.jl` under Case 2 | confirmed |
| L12 | Case 1 heading | 2D Trapezoidal Rule, f = 8e^{-x^2-y^4} | script f and method match | confirmed |
| L13 | Case 1 behaviour | coarse-to-fine tensor grid updates over the whole square each frame | 8 frames, grid lines span full square each frame (sheet) | confirmed |
| L14 | Case 1 behaviour | converges toward the archived reference value | errors 0.2985, 0.0722, 0.0320, 0.0180, 0.01148, 0.00797, 0.00448, 0.00287 (monotone decreasing) | confirmed |
| L15 | Case 1 behaviour | visible second-order error decay under refinement | halving ratios of error (independent numpy): n=2→4: 4.13, 4→8: 4.02, 8→16: 4.005, 16→32: 4.001; in-GIF 10→20: 0.011483/0.002868 = 4.00 | confirmed |
| L16 | Case 1 behaviour | black lines join sample nodes with straight segments; grid lines of the piecewise-bilinear interpolant, whose integral is I_T | `gridlines` (`trapezoidal2daa.jl:44-53`) emits only node values f(x_i,y_j) along each x=x_i and y=y_j, joined by straight path3d segments; the bilinear interpolant restricted to a grid line is exactly that linear interpolation, and its integral equals the product trapezoid sum | confirmed |
| L17 | Case 1 alt text | coloured surface of f, straight black grid lines through sample nodes, refinement 2x2 to 20x20, convergence to the archived benchmark | frames 1 and 8; titles "mesh = 2x2" ... "mesh = 20x20" | confirmed |
| L18 | Case 1 embed | `trapezoidal2daa.gif` is the trapezoidal case | GIF titles "2D Trapezoidal Rule"; byte-identical to scratch regeneration of `trapezoidal2daa.jl` (md5 719958eb...) | confirmed |
| L19 | Case 2 heading | 2D Simpson Rule, f = 8e^{-x^2-y^4} | script f and method match | confirmed |
| L20 | Case 2 behaviour | Simpson tensor-product weights recomputed on each refined mesh | `simpson2d(n)` rebuilds `ax`, `ay` per n | confirmed |
| L21 | Case 2 behaviour | Simpson reaches high accuracy with fewer refinements than trapezoidal | Simpson errors 5.87e-2, 4.24e-3, 6.68e-4, 1.96e-4, 7.78e-5, 3.69e-5, 1.15e-5, 4.68e-6; Simpson 6x6 (6.7e-4) already beats trapezoidal 20x20 (2.87e-3). Halving ratios 13.8, 21.7, 17.0, 16.2, 16.06 (→16, fourth order). Archive: Simpson m=5 (10 panels) 5.04764 (gr_120), m=10 (20 panels) 5.04757 (gr_127); script 5.047644586, 5.047571483 | confirmed |
| L22 | Case 2 behaviour | black curves are quadratics through sample nodes over each pair of panels along every grid line; grid lines of the piecewise-biquadratic interpolant (one patch per 2x2 block), whose integral is I_S | `quadpieces` (`simpson2daa.jl:45-57`) is the Lagrange quadratic on [t_k, t_{k+2}], k = 1,3,5,... (reproduces node values by construction, samples include the nodes); used along every x=x_i and y=y_j. Biquadratic tensor interpolant restricted to a grid line is this 1D quadratic, and its integral equals the product Simpson sum | confirmed |
| L23 | Case 2 behaviour | "On the 2x2 mesh they differ from the trapezoidal straight lines by up to 0.51 in z" | independent `diff.py`: max over the six grid lines = 0.5109 (on x=0; others 0.398, 0.190, 0.189, 0.178, 0.070); instrumented script curves: 0.51095 at x=0 | confirmed |
| L24 | Case 2 alt text | black piecewise-quadratic grid curves, refinement 2x2 to 20x20, convergence toward the benchmark | frames 1 and 8; titles 2x2 ... 20x20 | confirmed |
| L25 | Case 2 embed | `simpson2daa.gif` is the Simpson case | GIF titles "2D Simpson Rule"; byte-identical to scratch regeneration (md5 e489fdd8...) | confirmed |
| L26 | GIF titles (both) | I_T / I_S and |error| per frame | every frame title equals the instrumented-script value and the independent numpy value to the printed 9 decimals (table in section 3) | confirmed |
| L27 | script comment `simpson2daa.jl:14` | the n=2 quadratic along x=0 peaks at about 8.30 | instrumented: 8.29734; independent: 8.2973; zlims 8.4 contains it | confirmed |
| L28 | script comment `trapezoidal2daa.jl:16` / `simpson2daa.jl:16` | n_seq includes archived checkpoints at 10x10 and 20x20 | archive TR[10,10] = 5.0360837636 (gr_92) and the finer grid 5.04469842165 (gr_94) equal the script's n=10 (5.036083763603) and n=20 (5.044698421647); Simpson m=5,10 → 10, 20 panels (L21) | confirmed |

### 3. Implementation checks

### `trapezoidal2daa.jl`

*Method.* Composite product trapezoidal rule on an n x n mesh: weights 1/2 at the ends and 1 inside along each axis, sum multiplied by hx·hy (lines 19-40). This is the tensor-product trapezoidal rule named in the title and in the page formula, with m = n.

*Numbers.* Instrumented copy vs independent numpy implementation vs archive:

| n | script I_T | independent I_T | script |err| | independent |err| | archive |
|---|---|---|---|---|---|
| 2 | 4.749087736 | 4.749087736005 | 0.298479071 | 2.985e-01 | |
| 4 | 4.975344691 | 4.975344691379 | 0.072222116 | 7.222e-02 | |
| 6 | 5.015604706 | 5.015604705554 | 0.031962102 | 3.196e-02 | |
| 8 | 5.029613219 | 5.029613219039 | 0.017953588 | 1.795e-02 | |
| 10 | 5.036083764 | 5.036083763603 | 0.011483044 | 1.148e-02 | 5.0360837636 (err 0.0114830435646) |
| 12 | 5.039595175 | 5.039595175444 | 0.007971632 | 7.972e-03 | |
| 16 | 5.043084264 | 5.043084264495 | 0.004482543 | 4.483e-03 | |
| 20 | 5.044698422 | 5.044698421647 | 0.002868386 | 2.868e-03 | 5.04469842165 |

Property checks with the script's own routine (`poly_t.jl`): exact (0.0) for 1, x, y, xy; error 0.041667 for x^2 at n=2 and 0.010417 at n=4 (ratio 4); x^3y^3 error 0.035156 → 0.008057. Degree of precision 1 per variable and order 2, as expected. Error halving ratio on the benchmark → 4.00.

*Reference value.* `true_val = 5.04756680717`; mpmath separable product 8·∫0^1 e^{-x^2}dx·∫0^1 e^{-y^4}dy = 5.04756680716753966..., identical to a direct 2D mpmath quadrature. Correct to all 12 stated significant figures; error of the constant (3.2e-12) is far below the smallest error displayed (2.9e-3).

*Picture.* Surface is f itself on a 90x90 grid with `Zf[y,x]` layout (Plots' convention); the high flat edge is x=0 (z=8 → 2.94 along y as e^{-y^4}) and the surface falls off in x, consistent with f. Grid lines are path3d polylines through the node values only (straight between nodes). Frame titles match the table above to every printed digit. zlims (0, 8.2) contains max f = 8; no clamping or masking; 8 frames = 8 entries of n_seq. Frames 1, 4, 5, 8 and the contact sheet inspected.

### `simpson2daa.jl`

*Method.* Composite product Simpson rule, weights 1,4,2,...,4,1 along each axis (array index i ↔ node i-1, so `isodd(i-1)` → 4; lines 25-31), sum times hx·hy/9 (line 40). Matches the page formula with m = n even. Equivalent to Mathews' `Simpson2D` with its m = n/2 (pairs of panels).

*Numbers.*

| n | script I_S | independent I_S | script |err| | independent |err| | archive |
|---|---|---|---|---|---|
| 2 | 5.106262624 | 5.106262624448 | 0.058695817 | 5.870e-02 | |
| 4 | 5.051811627 | 5.051811626509 | 0.004244819 | 4.245e-03 | |
| 6 | 5.048234773 | 5.048234772908 | 0.000667966 | 6.680e-04 | |
| 8 | 5.047762777 | 5.047762777353 | 0.00019597 | 1.960e-04 | |
| 10 | 5.047644586 | 5.047644586076 | 7.7779e-5 | 7.778e-05 | 5.04764 (m=5) |
| 12 | 5.047603712 | 5.047603712117 | 3.6905e-5 | 3.690e-05 | |
| 16 | 5.047578304 | 5.047578303611 | 1.1496e-5 | 1.150e-05 | |
| 20 | 5.047571483 | 5.047571483116 | 4.676e-6 | 4.676e-06 | 5.04757 (m=10) |

Property checks with the script's own routine (`poly_s.jl`): exact (0.0) for xy, x^2, x^3y^3 at n=2 and n=4; x^4 error 0.0083333 at n=2 and 0.00052083 at n=4 (ratio 16). Degree of precision 3 per variable and order 4, as expected. Benchmark halving ratios approach 16 (16.23 at 16→32, 16.06 at 32→64).

*Reference value.* Same constant and verification as above.

*Picture.* Same surface as the trapezoidal script. Grid curves are Lagrange quadratics on each pair of panels along every grid line, sampled at 2·8+1 points per pair (nodes included). On the 2x2 mesh the curve along x=0 peaks at 8.2973 above the surface (visible in frame 1, contained by zlims 8.4); max deviation from the straight trapezoid lines 0.5109, matching the page's "up to 0.51". Frame titles match the table above to every printed digit (Julia's `round` drops a trailing zero, e.g. 0.00019597, and switches to e-notation for small errors; values still correct). 8 frames = 8 n values. Frames 1 and 8 and the contact sheet inspected.

### Reproducibility

Both scratch regenerations (manifest) are byte-identical to the committed GIFs; I confirmed with md5 (`simpson2daa.gif` e489fdd8c2249ed0d283ca3fe940e57e, `trapezoidal2daa.gif` 719958eb0ff455280e7f57635838cabd) and confirmed the scratch script copies are identical to the repository scripts. Nothing in the repository was modified.

