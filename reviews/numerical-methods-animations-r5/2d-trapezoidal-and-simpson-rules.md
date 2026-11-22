# 2D Trapezoidal and Simpson Rules — animation review (round 5)

Page: `pages/numerical-methods/2d-trapezoidal-and-simpson-rules/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor issue. The evidence behind this clean result is in sections 2 and 3.

(Out of scope, for information only: the archive's Example 5 solution page (images 140–152) has a copy-paste error of its own. It labels the trapezoidal values 5.0360837636 and 5.04469842165 as "Simpson's rule approximation" and gives the ratio 0.249793 while claiming it should be about 0.0625. The page does not reproduce this.)

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson2daa.jl` | 0 | 7.2 | simpson2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description l.12–13 | Composite 2D Trapezoidal and 2D Simpson rules on a rectangular double integral | Both scripts implement tensor-product composite rules on [0,1]² (see §3) | confirmed |
| D2 | l.13–17 | "Examples 1–6 of the archived module use I = ∫₀¹∫₀¹ 8e^{-x²-y⁴} dy dx" | Archive integral images 43, 67, 87, 108, 132, 153 (Examples 1–6) all show this integral (`arch/intro.png`) | confirmed |
| D3 | l.19 | surface z=8e^{-x²-y⁴} over R=[0,1]×[0,1] | Archive images 44, 45, 109, 110; script `f` and limits | confirmed |
| D4 | l.24–28 | I_T ≈ hk ΣΣ w_i w_j f, w_0=w_m=½, w_i=1 | Script lines 25–39 implement exactly this; exact for 1, x, y, xy and not for x², y² (errors 4.167e-2 at n=2) | confirmed |
| D5 | l.32–36 | I_S ≈ (hk/9) ΣΣ a_i a_j f, a_0=a_m=1, 4 odd, 2 even interior | Script lines 25–40 implement exactly this; exact for x^p y^q with p,q ≤ 3, error 8.333e-3 for x⁴ at n=2 | confirmed |
| D6 | l.38–41 | h=(b−a)/m, k=(d−c)/n, x_i=a+ih, y_j=c+jk; Simpson needs m, n even | Script uses m=n with n ∈ {2,4,…,20}, all even | confirmed |
| A1 | l.45–47 | Full-domain mesh refinement on [0,1]² for f=8e^{-x²-y⁴} | Frames: the grid spans the whole square in every frame; `f` matches | confirmed |
| A2 | l.47 | Archived benchmark I ≈ 5.04756680717 | Exact I = 8·(√π/2)erf(1)·∫₀¹e^{-y⁴}dy = 5.04756680716754 (mpmath, 30 digits); archive image (Example 3) shows 5.04756680717 | confirmed |
| A3 | l.49 | Julia scripts linked under each case | l.65 → trapezoidal2daa.jl, l.79 → simpson2daa.jl | confirmed |
| A4 | l.51–52 | Archive snapshot incomplete for some image IDs | Images 46–66, 68–86 absent from `Images/` (159 of ~233 present) | confirmed |
| A5 | l.53–55 | Example 7 applies composite Simpson to a double integral with inner limits functions of x (non-rectangular), not animated | Archive "More Background" and lnk_8 text: inner limits c[x], d[x], n=20, m=5; no script on page | confirmed |
| C1-1 | Case 1 heading | 2D Trapezoidal Rule, f=8e^{-x²-y⁴} | Script `trapezoid2d`, `f` line 9; GIF title "2D Trapezoidal Rule on [0,1] x [0,1]" | confirmed |
| C1-2 | l.59 | Grid updates over the whole square each frame | 8 frames, meshes 2,4,6,8,10,12,16,20, each a full grid (frames 1, 2, sheet) | confirmed |
| C1-3 | l.60 | Converges toward the archived reference value | I_T: 4.749087736 → 5.044698422; error 0.29848 → 0.0028684, strictly decreasing | confirmed |
| C1-4 | l.60–61 | Visible second-order error decay | error·n² = 1.194, 1.156, 1.151, 1.149, 1.148, 1.148, 1.1475, 1.1474 (≈ constant); E(20)/E(10) = 0.249793 (matches archive Example 3 value 0.249793) | confirmed |
| C1-5 | l.61–63 | Black lines are straight segments joining nodes, i.e. grid lines of the piecewise-bilinear interpolant whose integral is I_T | `gridlines` joins f at nodes with straight segments; Gauss-integrating the bilinear interpolant gives 4.749087736005, 4.975344691379, 5.015604705554 for n=2,4,6, equal to I_T | confirmed |
| C1-6 | alt text l.67 | coloured surface of f, straight black grid lines through nodes, refinement 2x2 to 20x20, convergence to benchmark | Frames 1–8; surface is f on 90×90 (orientation Z[j,i]=f(x_i,y_j) correct; (0,0) corner at z=8) | confirmed |
| C2-1 | Case 2 heading | 2D Simpson Rule, f=8e^{-x²-y⁴} | Script `simpson2d`, `f` line 9; GIF title "2D Simpson Rule on [0,1] x [0,1]" | confirmed |
| C2-2 | l.71 | Simpson tensor-product weights recomputed on each refined mesh | `simpson2d(n)` builds weights per n | confirmed |
| C2-3 | l.72–73 | Simpson reaches high accuracy with fewer refinements than trapezoidal | Simpson 6x6 error 6.68e-4 already beats trapezoid 20x20 error 2.87e-3; Simpson 20x20 error 4.68e-6; error·n⁴ ≈ 0.75–1.09 (fourth order) | confirmed |
| C2-4 | l.73–76 | Black curves are quadratics through nodes over each pair of panels along every grid line, i.e. grid lines of the piecewise-biquadratic interpolant (one patch per 2x2 block), whose integral is I_S | `quadpieces` builds Lagrange quadratics on [t_k, t_{k+2}], k odd; restriction of tensor biquadratic to x=x_i is exactly that. Gauss integral of the biquadratic interpolant = 5.106262624448, 5.051811626509, 5.048234772908 for n=2,4,6, equal to I_S | confirmed |
| C2-5 | l.76–77 | On the 2x2 mesh they differ from the trapezoidal straight lines by up to 0.51 in z | max over the 6 grid lines of |quadratic − linear| = 0.5109 (on line x=0); others 0.398, 0.188, 0.190, 0.178, 0.070 | confirmed |
| C2-6 | alt text l.81 | piecewise-quadratic grid curves, refinement 2x2 to 20x20, convergence toward benchmark | Frames 1, 2 and sheet; titles mesh 2x2 … 20x20 | confirmed |
| W1 | l.65/67 | Case 1 link and embed | trapezoidal2daa.jl produces trapezoidal2daa.gif (byte-identical regen) | confirmed |
| W2 | l.79/81 | Case 2 link and embed | simpson2daa.jl produces simpson2daa.gif (byte-identical regen) | confirmed |
| N1 | Counts | Two cases, 8 frames each | n_seq has 8 entries; 8 frames each GIF | confirmed |
| S1 | trapezoidal2daa.jl l.16 | Includes archived checkpoints at 10x10 and 20x20 | Archive Ex. 1/3: TR 10x10 = 5.0360837636, 20x20 = 5.04469842165; script 5.036083763603, 5.044698421647 | confirmed |
| S2 | simpson2daa.jl l.16 | Even panel counts including legacy checkpoints | Archive Ex. 4: Simpson "m=5 by n=5" = 5.04764458608 and "m=10 by n=10" = 5.04757148312 (Mathews' m counts panel pairs); script S(10) = 5.047644586076, S(20) = 5.047571483116 | confirmed |
| S3 | simpson2daa.jl l.14 | n=2 quadratic along x=0 peaks at about 8.30; zlims 8.4 | Peak 8.2973; no curve clipped (trapezoid lines max 8.0 < 8.2) | confirmed |

---

### 3. Implementation checks

### `trapezoidal2daa.jl`

- **Method.** Composite tensor-product trapezoidal rule: weights ½ at both ends and 1 in the interior on each axis, sum times h·k (lines 19–40). It is the method the page names and is the same formula as the Description. Degree of precision, using the script's own routine at n=2 with `f` swapped for monomials: errors 0 for 1, x, y, xy; 4.167e-2 for x² and y² (exact 1/12·½ = 0.041667). That is exactly bilinear exactness and no more.
- **Numbers.** Script routine against an independent numpy implementation (`indep.py`), agreeing to every printed digit:

| n | script I_T | independent I_T | |I_T − I| |
|---|---|---|---|
| 2 | 4.749087736005 | 4.749087736005 | 0.298479071 |
| 4 | 4.975344691379 | 4.975344691379 | 0.072222116 |
| 6 | 5.015604705554 | 5.015604705554 | 0.031962102 |
| 8 | 5.029613219039 | 5.029613219039 | 0.017953588 |
| 10 | 5.036083763603 | 5.036083763603 | 0.011483044 |
| 12 | 5.039595175444 | 5.039595175444 | 0.007971632 |
| 16 | 5.043084264495 | 5.043084264495 | 0.004482543 |
| 20 | 5.044698421647 | 5.044698421647 | 0.002868386 |

  Order check: error·n² converges to 1.147 (second order); E(20)/E(10) = 0.249793.
- **Reference value.** `true_val = 5.04756680717`. The integral is separable: 8·∫₀¹e^{-x²}dx·∫₀¹e^{-y⁴}dy = 5.04756680716754 (mpmath, 30 digits), so the benchmark is correctly rounded to 11 decimals. Its offset of 2.5e-12 is far below the smallest error displayed.
- **Picture.** Every frame title (`I_T`, `|error|`, mesh) matches the table above after rounding to 9 digits (checked against the printed `round(...; digits=9)` strings and the frames). The surface is f itself on a 90×90 grid in the correct Z[j,i] orientation: the (x,y)=(0,0) corner is at z=8, f falls slowly along the x=0 edge and faster along y=0. The black grid has n+1 lines per direction (3 at 2x2, 5 at 4x4 counted in frames 1–2), and its segments meet the surface at the nodes and lie as chords below the concave surface. zlims (0, 8.2) clip nothing.

### `simpson2daa.jl`

- **Method.** Composite tensor-product Simpson 1/3 rule: weights 1, 4, 2, …, 4, 1 on each axis, sum times h·k/9 (lines 19–41). The array-index-to-node mapping is correct: index i corresponds to node i−1, and odd nodes get weight 4. Degree of precision using the script's routine at n=2: errors 0 for x^p y^q with p,q ≤ 3 (tested 1, xy, x²y², x³y³, x³, y³, x³y); 8.333e-3 for x⁴ and y⁴ (exact 1/120 = 0.008333 for one 1D Simpson panel pair on [0,1]). That is the expected bicubic exactness.
- **Numbers.**

| n | script I_S | independent I_S | |I_S − I| |
|---|---|---|---|
| 2 | 5.106262624448 | 5.106262624448 | 0.058695817 |
| 4 | 5.051811626509 | 5.051811626509 | 0.004244819 |
| 6 | 5.048234772908 | 5.048234772908 | 0.000667966 |
| 8 | 5.047762777353 | 5.047762777353 | 0.000195970 |
| 10 | 5.047644586076 | 5.047644586076 | 7.7779e-5 |
| 12 | 5.047603712117 | 5.047603712117 | 3.6905e-5 |
| 16 | 5.047578303611 | 5.047578303611 | 1.1496e-5 |
| 20 | 5.047571483116 | 5.047571483116 | 4.676e-6 |

  Order check: error·n⁴ = 0.94, 1.09, 0.87, 0.80, 0.78, 0.77, 0.753, 0.748, settling toward a constant (fourth order). Archive checkpoints reproduced: 5.04764458608 (10x10) and 5.04757148312 (20x20).
- **Reference value.** The same reference as above, confirmed.
- **Picture.** Titles match the table, rounded to 9 digits; errors below 1e-4 print in Julia's e-notation, which is readable. The grid curves are piecewise Lagrange quadratics over panel pairs along every grid line. These are exactly the grid lines of the biquadratic interpolant, whose exact integral equals I_S for n=2, 4, 6 (`interp.py`). In frame 1 the x=0 curve visibly rises above the surface to about 8.30 (computed 8.2973) at the back-left, consistent with the zlims comment. zlims (0, 8.4) clip nothing. Frame 2 (4x4) shows 5 curves per direction.

### Fidelity to the archive
The archive's Examples 1–6 all use this integrand on the unit square. Ex. 1/3 use the trapezoidal rule at 10x10 and 20x20, and Ex. 4/5 use Simpson at Mathews' "m=5" and "m=10", which is 10 and 20 panels. Ex. 2 gives the analytic value 5.04756680717. The animations' mesh sequences contain all four checkpoints and reproduce the archive values to every digit shown. Example 7 (non-rectangular region) is omitted, and the page says so explicitly (l.53–55). There is no fidelity finding.

