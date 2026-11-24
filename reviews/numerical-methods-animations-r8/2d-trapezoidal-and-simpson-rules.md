# 2D Trapezoidal and Simpson Rules — animation review (round 8)

Page: `pages/numerical-methods/2d-trapezoidal-and-simpson-rules/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every claim in the ledger below was confirmed against my own computation, the frames, or the archive. Counts: Error 0, Misleading 0, Minor 0.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson2daa.jl` | 0 | 7.5 | simpson2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `trapezoidal2daa.jl` | 0 | 8.2 | trapezoidal2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Description l.13-16 | "Examples 1-6 of the archived module use I = int_0^1 int_0^1 8e^{-x^2-y^4} dy dx" | Integrand images gr_43 (Ex1), gr_67 (Ex2), gr_87 (Ex3), gr_108 (Ex4), gr_132 (Ex5), gr_153 (Ex6) all md5 `273bf7ac...`; gr_43 reads `int_0^1 int_0^1 8 e^{-x^2-y^4} dy dx` | confirmed |
| 2 | l.19 | surface z=8e^{-x^2-y^4} over R=[0,1]x[0,1] | legacy gr_44, gr_45; both scripts `f(x,y)=8*exp(-(x^2)-(y^4))`, limits (0,1) | confirmed |
| 3 | l.24-28 | I_T = hk sum sum w_i w_j f, w_0=w_m=1/2, interior 1 | script `trapezoid2d` uses exactly these weights; exact for 1, x, xy (err 0), not x^2 (err 0.0417 at n=2) | confirmed |
| 4 | l.32-36 | I_S = hk/9 sum sum a_i a_j f, a=1,4,2,...,4,1 | script `simpson2d` l.25-40; exact for x^p y^q, p,q<=3 (err 0), not x^4 (err 0.00833 at n=2) | confirmed |
| 5 | l.38-41 | h=(b-a)/m, k=(d-c)/n, x_i=a+ih, y_j=c+jk; Simpson needs m,n even | scripts use `range(...,length=n+1)`, n_seq all even | confirmed |
| 6 | Animations l.45-47 | full-domain refinement on [0,1]^2 for f, benchmark I ~ 5.04756680717 | exact I = 8*int e^{-x^2}*int e^{-y^4} = 5.0475668071675397 (mpmath 30 digits; also 2D quad); benchmark differs by 2.5e-12, correct to its 11 decimals; legacy ex3.png prints 5.04756680717 | confirmed |
| 7 | l.49 | Julia scripts linked under each case | links `trapezoidal2daa.jl` (Case 1), `simpson2daa.jl` (Case 2), files exist | confirmed |
| 8 | l.51-52 | archived snapshot incomplete for some image IDs | e.g. gr_46-66 (Ex1 results, plots) absent from `Images/` (159 files) | confirmed |
| 9 | l.53-55 | Example 7 is Simpson's rule with inner limits functions of x; not animated | module text "More Background ... limits of integration on the inside integral are functions of x ... Example 7"; no Ex7 script | confirmed |
| 10 | Case 1 heading | 2D Trapezoidal, f=8e^{-x^2-y^4} | script l.9, title "2D Trapezoidal Rule" | confirmed |
| 11 | Case 1 Behavior | coarse-to-fine tensor grid over the whole square each frame | n_seq = 2,4,6,8,10,12,16,20, full grid every frame (frames 1-8) | confirmed |
| 12 | Case 1 Behavior | converges toward reference value | errors 0.2985, 0.0722, 0.0320, 0.0180, 0.0115, 0.00797, 0.00448, 0.00287 (monotone decreasing) | confirmed |
| 13 | Case 1 Behavior | visible second-order error decay | err(n)/err(2n) = 4.023 (4), 4.005 (8), 4.001 (16); in frames 0.072222/0.017954=4.02, 0.011483/0.002868=4.00 | confirmed |
| 14 | Case 1 Behavior | black lines join nodes with straight segments = grid lines of piecewise-bilinear interpolant whose integral is I_T | `gridlines` joins f(x_i,y_j) along each grid line; restriction of tensor bilinear interpolant to x=x_i is the linear interpolant in y; integral of bilinear interpolant = product trapezoid (exactness on bilinears, item 3); frame 1 shows straight polyline segments | confirmed |
| 15 | Case 1 alt text | coloured surface, straight black grid lines, 2x2 to 20x20, convergence to benchmark | frames 1 and 8 titles "mesh = 2x2" / "mesh = 20x20"; surface + black lines visible | confirmed |
| 16 | Case 2 heading | 2D Simpson, same f | script l.9, title "2D Simpson Rule" | confirmed |
| 17 | Case 2 Behavior | Simpson weights recomputed on each refined mesh | `simpson2d(n)` called per frame | confirmed |
| 18 | Case 2 Behavior | Simpson reaches high accuracy with fewer refinements than trapezoidal | Simpson err at n=6 is 6.68e-4, already below trapezoid at n=20 (2.87e-3); order ratio 16.06 at n=32 (4th order) | confirmed |
| 19 | Case 2 Behavior | black curves are quadratics through nodes over each pair of panels = grid lines of piecewise-biquadratic interpolant, one patch per 2x2 block, integral = I_S | `quadpieces` builds Lagrange quadratic on [t_k, t_{k+2}], k odd; restriction of tensor biquadratic to a node line is that quadratic; product Simpson is exact on biquadratics (item 4) | confirmed |
| 20 | Case 2 Behavior | on 2x2 mesh they differ from trapezoidal straight lines by up to 0.51 in z | max over all six grid lines of |quadratic - linear| = 0.51095 (along x=0) | confirmed |
| 21 | Case 2 alt text | biquadratic curves, 2x2 to 20x20, convergence toward benchmark | frames 1/8 titles; Simpson errors 0.0587 -> 4.68e-6 monotone | confirmed |
| 22 | Wiring | each case's link and embed are the right script/GIF | Case 1 -> trapezoidal2daa.{jl,gif}, Case 2 -> simpson2daa.{jl,gif}; GIFs regenerate byte-identically from the linked scripts | confirmed |
| 23 | simpson2daa.jl l.14 comment | n=2 quadratic along x=0 peaks at about 8.30 | independent 8.29734; plotted sample max 8.29725; inside zlims 8.4 | confirmed |
| 24 | trapezoidal2daa.jl l.16 / simpson l.16 | n_seq includes archived 10x10 and 20x20 checkpoints | legacy trapezoid 10x10 = 5.0360837636, 20x20 = 5.04469842165; legacy Simpson m=5 (10 panels) = 5.04764458608, m=10 (20 panels) = 5.04757148312; scripts give 5.036083763603, 5.044698421647, 5.047644586076, 5.047571483116 | confirmed |

### 3. Implementation checks

### trapezoidal2daa.jl
- **Method:** composite product trapezoidal rule on an n x n grid, weights 1/2 at ends, 1 inside, times hx*hy. This is the 2D trapezoidal rule of the page and of Mathews' Theorem.
- **Numbers:** instrumented copy vs independent mpmath:

| n | script I_T | independent I_T | script |err| | independent |err| (vs benchmark) |
|---|---|---|---|---|
| 2 | 4.749087736005078 | 4.74908773600508 | 0.298479071 | 0.298479071 |
| 4 | 4.975344691378608 | 4.97534469137861 | 0.072222116 | 0.0722221158 |
| 6 | 5.0156047055539394 | 5.01560470555394 | 0.031962102 | 0.0319621016 |
| 8 | 5.02961321903879 | 5.02961321903879 | 0.017953588 | 0.0179535881 |
| 10 | 5.036083763602984 | 5.03608376360298 | 0.011483044 | 0.0114830436 |
| 12 | 5.039595175443809 | 5.03959517544381 | 0.007971632 | 0.00797163173 |
| 16 | 5.04308426449502 | 5.04308426449502 | 0.004482543 | 0.00448254267 |
| 20 | 5.044698421646742 | 5.04469842164674 | 0.002868386 | 0.00286838552 |

  Property checks: exact on 1, x, xy; error ratio on halving 4.02 -> 4.0003 (order 2). Legacy 10x10 and 20x20 values match to all printed digits.
- **Reference:** 5.04756680717 vs exact 5.04756680716754 (closed-form separable product, mpmath 30 digits). Error 2.5e-12, negligible against the smallest displayed error (2.9e-3).
- **Picture:** all 8 frame titles match the table above to the printed 9 decimals. Black polylines are f at the nodes joined by straight segments along x=x_i and y=y_j (frame 1 shows the 2x2 bilinear skeleton below the curved surface). zlims (0, 8.2) contain all values (max f = 8). No clamping or masking.

### simpson2daa.jl
- **Method:** composite product Simpson rule, weights 1,4,2,...,4,1 per axis (index shift handled at l.29: array index i -> node i-1), times hx*hy/9. n even throughout.
- **Numbers:**

| n | script I_S | independent I_S | script |err| | independent |err| |
|---|---|---|---|---|
| 2 | 5.106262624447544 | 5.10626262444754 | 0.058695817 | 0.0586958173 |
| 4 | 5.051811626509001 | 5.051811626509 | 0.004244819 | 0.00424481934 |
| 6 | 5.048234772907856 | 5.04823477290786 | 0.000667966 | 0.000667965738 |
| 8 | 5.047762777352722 | 5.04776277735272 | 0.00019597 | 0.000195970183 |
| 10 | 5.047644586076085 | 5.04764458607609 | 7.7779e-5 | 7.77789061e-5 |
| 12 | 5.047603712117132 | 5.04760371211713 | 3.6905e-5 | 3.69049471e-5 |
| 16 | 5.047578303611211 | 5.04757830361121 | 1.1496e-5 | 1.14964412e-5 |
| 20 | 5.047571483116476 | 5.04757148311647 | 4.676e-6 | 4.67594647e-6 |

  Property checks: exact on x^p y^q for p,q <= 3, fails on x^4 (degree of precision 3 per axis); error ratio on halving 21.7, 17.0, 16.2, 16.06 -> 16 (order 4). Legacy Mathews Simpson values (his m=5 and m=10, i.e. 10 and 20 panels) match n=10 and n=20 to all 12 printed digits.
- **Reference:** same as above.
- **Picture:** all 8 frame titles match the table. Curves are Lagrange quadratics through node triples on each panel pair along every grid line; in frame 1 the x=0 curve rises above the surface to ~8.30 (computed 8.297), inside zlims (0, 8.4). Plotted curve z-range per n: max 8.297 (n=2) falling to 8.00006 (n=20), min 1.0827 = f(1,1)... (f(1,1)=8e^{-2}=1.0827). No clamping or masking.

### Legacy fidelity
Function, domain, benchmark value and the 10x10/20x20 checkpoints all agree with the archive. Mathews' Simpson "m = 5 by n = 5" means 2m = 10 panels; the page counts panels directly (mesh = 10x10), which is a valid notational difference and the values coincide. Example 2 (analytic value) is represented by the benchmark; Examples 3, 5, 6 (error comparisons) are represented by the per-frame |error| and the order behaviour; Example 7 is explicitly disclosed as not animated. No undisclosed departure found. The archive's own surface plots (e.g. gr_47, gr_50) are missing from the snapshot, so a visual comparison with Mathews' figures could not be made.

