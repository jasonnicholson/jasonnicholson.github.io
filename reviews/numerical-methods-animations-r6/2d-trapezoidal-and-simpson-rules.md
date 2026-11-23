# 2D Trapezoidal and Simpson Rules — animation review (round 6)

Page: `pages/numerical-methods/2d-trapezoidal-and-simpson-rules/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No errors, nothing misleading, and nothing minor that met the bar. Every checkable claim on the page and in the frames agreed with an independent computation (ledger below).

Not findings, recorded for the owner's information:

- **Simpson panel-count convention differs from Mathews'.** Mathews' `Simpson2D[a,b,c,d,m,n]` uses `h=(b-a)/(2m)`, so his "m = 5 by n = 5" result (5.04764458608) is the 10x10-panel rule, and his "m = 10 by n = 10" (5.04757148312) is 20x20 panels. The page defines m and n as panel counts, which must be even, and labels the GIF frames by panel count ("mesh = 10x10" gives 5.047644586). That is a valid convention and the page is consistent with itself. It only matters to a reader cross-checking against the archive, who would see "10x10" where Mathews says "m = 5".
- **Archive Example 7 is dropped, but the page says so.** The non-rectangular integral is $\int_0^2\int_{x^2}^{\sqrt{8x}} e^{-x\sqrt y}\,dy\,dx$ (module image `gr_193`). The page says it is not animated, so it is not a silent drop.
- **The archive has internal errors that the page does not repeat.** Example 1's statement says "Simpson's rule" but its solution runs `Trapezoidal2D`. Example 5's table (`gr_133–152`) is labelled Simpson but shows the trapezoidal values (5.0360837636, 5.04469842165). The page's numbers are correct.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson2daa.jl` | 0 | 9.8 | simpson2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `trapezoidal2daa.jl` | 0 | 8.6 | trapezoidal2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words / frame text) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Examples 1–6 of the archived module use $I=\int_0^1\int_0^1 8e^{-x^2-y^4}\,dy\,dx$" | Archive statement images gr_43 (Ex1), gr_67 (Ex2), gr_87 (Ex3), gr_108/113–131 (Ex4/5), gr_132 (Ex6) all show this integral | confirmed |
| D2 | "surface $z=8e^{-x^2-y^4}$ over $R=[0,1]^2$" | Script line 9, xlims/ylims | confirmed |
| D3 | 2D Trapezoidal: $hk\sum\sum w_iw_jf$, with $w_0=w_m=1/2$ and interior $w=1$ | Standard product rule. Matches Mathews `Trapezoidal2D` (gr_41new: hk/4 with weights 1,2,4) and script lines 25–39 | confirmed |
| D4 | 2D Simpson: $\frac{hk}{9}\sum\sum a_ia_jf$, with $a_0=a_m=1$, $a=4$ for odd $i$ and $a=2$ for even interior $i$ | Script lines 25–40. The exactness tests below show degree-3 exactness per variable | confirmed |
| D5 | $h=(b-a)/m$, $k=(d-c)/n$, $x_i=a+ih$, $y_j=c+jk$; "For Simpson's rule m and n must be even" | Script uses `range(...,length=n+1)` with panel width 1/n and even n_seq | confirmed. This is a valid variant of Mathews' 2m convention; see note above |
| A1 | "full-domain mesh refinement on $[0,1]\times[0,1]$ for $f=8e^{-x^2-y^4}$" | Scripts; frames show the whole square re-gridded each frame | confirmed |
| A2 | "archived benchmark $I\approx 5.04756680717$" | mpmath (30 digits): I = 5.047566807167539662… (also 8·(√π/2)erf(1)·∫e^{-y⁴}). Archive gr_88 shows 5.04756680717 | confirmed (error 2.5e-12, below the last digit) |
| A3 | "The archived snapshot is incomplete for some intermediate image IDs" | Images gr_46–66 (Ex1 solution), gr_68–86 (Ex2) and gr_154–187 (Ex7) are referenced but absent | confirmed |
| A4 | "reconstructed from the available formula and checkpoint assets" | Checkpoints survive in gr_88–107 (Trap 10x10 = 5.0360837636, 20x20 = 5.04469842165) and gr_113–131 (Simpson 5.04764458608, 5.04757148312) | confirmed |
| A5 | "Example 7 … double integral whose inner limits of integration are functions of x (a non-rectangular region), is not animated" | Module text plus gr_193 ($\int_0^2\int_{x^2}^{\sqrt{8x}}$) | confirmed |
| A6 | "Julia source scripts … linked under each case" | Case 1 links `trapezoidal2daa.jl`, Case 2 links `simpson2daa.jl`; both exist | confirmed |
| C1-1 | Heading: 2D Trapezoidal Rule, $f=8e^{-x^2-y^4}$ | trapezoidal2daa.jl line 9; frame titles | confirmed |
| C1-2 | "coarse-to-fine tensor grid updates over the whole square each frame" | n_seq = [2,4,6,8,10,12,16,20]; 8 distinct frames (frames.md5) | confirmed |
| C1-3 | "converges toward the archived reference value" | I_T = 4.749087736, 4.975344691, 5.015604706, 5.029613219, 5.036083764, 5.039595175, 5.043084264, 5.044698422. Increases monotonically toward 5.0475668 | confirmed |
| C1-4 | "visible second-order error decay under refinement" | Error ratio for n→2n: 4.0033 (10→20), 4.0008 (20→40). Error 0.29848 (n=2) to 0.0028684 (n=20) is about n⁻² | confirmed |
| C1-5 | "black lines join the sample nodes with straight segments: grid lines of the piecewise-bilinear interpolant, whose integral is $I_T$" | `gridlines` draws f at the nodes joined by straight path3d segments. A bilinear interpolant restricted to x=x_i or y=y_j is linear, and the product trapezoid rule is exactly the integral of the bilinear interpolant (also confirmed: rule exact for xy, not for x²) | confirmed |
| C1-6 | Alt text: "full-grid refinement from 2x2 to 20x20, and convergence to the archived benchmark" | Frame 1 "mesh = 2x2", frame 8 "mesh = 20x20, I_T = 5.044698422, \|error\| = 0.002868386" | confirmed |
| C1-7 | Script comment: "Include archived checkpoints at 10x10 and 20x20" | Script 5.036083764 / 5.044698422 vs archive 5.0360837636 / 5.04469842165 | confirmed |
| C1-8 | Wiring: Case 1 embeds `trapezoidal2daa.gif` | GIF titles read "2D Trapezoidal Rule" | confirmed |
| C2-1 | Heading: 2D Simpson Rule, $f=8e^{-x^2-y^4}$ | simpson2daa.jl line 9; frame titles | confirmed |
| C2-2 | "Simpson tensor-product weights are recomputed on each refined mesh" | `simpson2d(n)` rebuilds ax/ay each frame | confirmed |
| C2-3 | "reaches high accuracy with fewer refinements" than trapezoidal | Simpson error at n=6 is 6.68e-4, already below trapezoidal at n=20 (2.87e-3). At n=20 Simpson is 4.68e-6. Ratio 16.6 (10→20), 16.15 (20→40) | confirmed |
| C2-4 | "black curves are the quadratics through the sample nodes over each pair of panels along every grid line" | `quadpieces` builds the Lagrange quadratic on [t_k, t_{k+2}]. It reproduces node data (test: 1.0, 2.0, 0.5 returned exactly) and reproduces a quadratic exactly (max err 0.0) | confirmed |
| C2-5 | "grid lines of the piecewise-biquadratic interpolant (one patch per 2x2 block of panels), whose integral is $I_S$" | A biquadratic Lagrange interpolant restricted to a nodal line is the 1D quadratic through that line's nodes, and the product Simpson rule integrates the biquadratic interpolant exactly. Rule exact for x², x²y², x³y³, x³y²; not exact for x⁴ (err 8.33e-3 at n=2) | confirmed |
| C2-6 | "On the 2x2 mesh they differ from the trapezoidal straight lines by up to 0.51 in z" | Continuous max over all 6 grid lines, numpy at 200001 pts: 0.51095 (Julia on sampled pts: 0.51095) | confirmed |
| C2-7 | Script comment: zlims 8.4 because "the n=2 quadratic along x=0 peaks at about 8.30" | Peak 8.2973 at y=0.191 on x=0. No curve leaves [0, 8.4] (min 1.0827) | confirmed. No clipping |
| C2-8 | Alt text: "refinement from 2x2 to 20x20, and convergence toward the archived benchmark integral" | Frame 1 "mesh = 2x2, I_S = 5.106262624, \|error\| = 0.058695817"; frame 8 "mesh = 20x20, I_S = 5.047571483, \|error\| = 4.676e-6" | confirmed |
| C2-9 | Script comment: "Even panel counts … including legacy checkpoints" | Script n=10: 5.047644586, n=20: 5.047571483. Archive (Mathews m=5, m=10, i.e. 10 and 20 panels): 5.04764458608, 5.04757148312 | confirmed |
| C2-10 | Wiring: Case 2 embeds `simpson2daa.gif` | GIF titles read "2D Simpson Rule" | confirmed |
| F1 | Frame titles report I and \|error\| for the right mesh | Values per frame match the instrumented script and the independent mpmath products (table in §3) to all 9 printed decimals | confirmed |
| F2 | Frame count: 8 per GIF, 2x2 → 20x20 | frames.md5: 8 distinct hashes each | confirmed |

### 3. Implementation checks

### `trapezoidal2daa.jl`

- **It is the method it claims to be.** It is the composite product trapezoid rule on an n×n uniform grid, with weights ½ at the ends and 1 inside in each direction, scaled by hx·hy (lines 19–40). The same rule as Mathews' `Trapezoidal2D` (gr_41new).
- **The numbers are right.** I ran an instrumented copy (`review/trapezoidal2daa_inst.jl`) against an independent mpmath computation (`review/indep.py`). The integrand is separable, so the 2D rule equals 8·T_n[e^{-x²}]·T_n[e^{-y⁴}].

  | n | script I_T | independent I_T | \|error\| (indep) |
  |---|---|---|---|
  | 2 | 4.749087736 | 4.74908773600508 | 0.298479 |
  | 4 | 4.975344691 | 4.97534469137861 | 0.0722221 |
  | 6 | 5.015604706 | 5.01560470555394 | 0.0319621 |
  | 8 | 5.029613219 | 5.02961321903879 | 0.0179536 |
  | 10 | 5.036083764 | 5.03608376360298 | 0.011483 |
  | 12 | 5.039595175 | 5.03959517544381 | 0.00797163 |
  | 16 | 5.043084264 | 5.04308426449502 | 0.00448254 |
  | 20 | 5.044698422 | 5.04469842164674 | 0.00286839 |

  Property checks (`review/ex_trapezoidal2daa.jl`, f replaced): exact for xy (err 0). Error for x² is 0.04167 at n=2 and 0.01042 at n=4, so not exact, with a ratio of 4. Error ratio on the real integrand under halving: 4.0033, 4.0008, 4.0002, so order 2.
- **Its reference value is right.** The script uses true_val = 5.04756680717 and mpmath gives 5.0475668071675397. They differ by 2.5e-12, which has no effect on any printed digit.
- **The picture shows what was computed.** The surface matrix is `Zf[y,x]`, which is the orientation Plots expects. The black path3d segments pass through f(x_i, y_j) at every node and are straight between nodes. Frame 1 shows the x=0 edge staying high to y=0.5 and then dropping, as e^{-y⁴} does. Titles match the computed values. zlims (0, 8.2) covers max f = 8, so nothing is clipped. I viewed frames 1 and 8 and the contact sheet.

### `simpson2daa.jl`

- **It is the method it claims to be.** It is the composite product Simpson 1/3 rule on an n×n grid with n even. Weights are 1,4,2,…,4,1 in each direction, scaled by hx·hy/9 (lines 19–41). This is Mathews' `Simpson2D` (gr_42new) written with n = number of panels instead of Mathews' n = number of panel pairs.
- **The numbers are right.** Same method of checking as above, with 8·S_n[e^{-x²}]·S_n[e^{-y⁴}].

  | n | script I_S | independent I_S | \|error\| (indep) |
  |---|---|---|---|
  | 2 | 5.106262624 | 5.10626262444754 | 0.0586958 |
  | 4 | 5.051811627 | 5.051811626509 | 0.00424482 |
  | 6 | 5.048234773 | 5.04823477290786 | 0.000667966 |
  | 8 | 5.047762777 | 5.04776277735272 | 0.00019597 |
  | 10 | 5.047644586 | 5.04764458607609 | 7.77789e-5 |
  | 12 | 5.047603712 | 5.04760371211713 | 3.69049e-5 |
  | 16 | 5.047578304 | 5.04757830361121 | 1.14964e-5 |
  | 20 | 5.047571483 | 5.04757148311647 | 4.67595e-6 |

  Property checks: exact (err 0.0 at n=2 and n=4) for xy, x²y, x², x²y², x³y², x³y³. Not exact for x⁴ (err 8.33e-3 at n=2, 5.21e-4 at n=4, ratio 16). Error ratio on the real integrand under halving: 16.63, 16.15, 16.04, so order 4. The archive's Simpson values at 10 and 20 panels (5.04764458608, 5.04757148312) agree with the script.
- **Its reference value is right.** Same value and same check as for the trapezoidal script.
- **The picture shows what was computed.** `quadpieces` reproduces its node data exactly and a test quadratic exactly. Each curve spans [t_k, t_{k+2}] for odd k, which is one Simpson panel pair, so with even n every grid line is fully covered. Across the six n=2 grid lines, the curves run from 1.0827 to 8.2973 (peak on x=0 at y≈0.191), inside zlims (0, 8.4), so nothing is clipped. In frame 1 the curves visibly overshoot the surface along x=0, as expected for the interpolant. Frame titles match the computed values. I viewed frames 1 and 8 and the contact sheet.

