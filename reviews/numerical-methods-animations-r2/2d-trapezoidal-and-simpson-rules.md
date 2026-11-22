# 2D Trapezoidal and Simpson Rules — animation review (round 2)

Page: `pages/numerical-methods/2d-trapezoidal-and-simpson-rules/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Page match (Description), Minor: the Simpson formula leaves out its evenness condition, and h, k, m, n are never defined

- **Location:** `index.qmd` lines 21–36, the formulas
  `I_T ≈ hk Σ_{i=0}^{m} Σ_{j=0}^{n} w_i w_j f(x_i,y_j), w_0=w_m=1/2, w_i=1 (1≤i≤m−1)` and
  `I_S ≈ (hk/9) Σ Σ a_i a_j f(x_i,y_j), a_0=a_m=1, a_i=4 (odd i), a_i=2 (even i)`.
- **What is there now:** The page never defines `h`, `k`, `m` or `n`, nor `x_i` and `y_j`. The weights `w_j` and `a_j` are used with `j` running to `n`, but they are defined only in terms of `i` and `m`. Most importantly, the Simpson formula does not say that `m` and `n` must be even.
- **What is true instead:** The weight pattern `1,4,2,…,4,1` and the factor `hk/9` give the composite Simpson rule only when `m` and `n` are even. With an odd `m`, the stated formula is not Simpson's rule and it fails even for `f = 1`.
- **Evidence:** The page's Simpson formula applied to `f ≡ 1` on [0,1]² with m = n:
  m=3 → weights [1,4,2,1], result **0.7901** (exact 1);
  m=5 → **0.8711**;
  m=4 → 1.0000.
  The scripts are not affected: `n_seq = [2,4,…,20]` contains only even counts, and `simpson2daa.jl` line 16 notes the requirement in a comment.
- **Suggested correction:** After the formulas, add "where h = (b−a)/m and k = (d−c)/n are the panel widths, x_i = a + ih and y_j = c + jk, and w_j and a_j are defined in the same way with n in place of m. For Simpson's rule m and n must be even." Also write "a_i = 2 (even i, 0<i<m)".

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: "The archived module examples use …" overstates the archive, and Example 7 is dropped without comment

- **Location:** `index.qmd` lines 12–19: "The archived module examples use $I = \int_0^1\int_0^1 8e^{-x^2-y^4}\,dy\,dx$".
- **What is there now:** The sentence says, in effect, that all the archive's examples use this integral, and nothing on the page mentions any other archive example.
- **What is true instead:** Examples 1–6 of the archive module do use 8e^{−x²−y⁴} on [0,1]², which I confirmed from images gr_43, gr_108 and gr_67. Example 7 (`SimpsonsRule2DMod_lnk_8.html`, images gr_193 and gr_197) is different. It applies composite Simpson to ∫₀² ∫_{x²}^{√(8x)} e^{−x√y} dy dx over a non-rectangular region with variable inner limits, using n = 20 and m = 5, and the archive gives the value ≈ 1.01516369587. The page leaves this case out without saying so.
- **Why only Minor:** The page states its scope as "a rectangular double integral", and leaving out the variable-limits case is a defensible choice. Only the wording that implies the archive has no other examples is inaccurate.
- **Suggested correction:** Write "Examples 1–6 of the archived module use …", and add one sentence saying that the archive's Example 7 (Simpson's rule with variable inner limits) is not animated here.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson2daa.jl` | 0 | 6.8 | simpson2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `trapezoidal2daa.jl` | 0 | 7.1 | trapezoidal2daa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Description l.13 | composite 2D Trapezoidal and 2D Simpson rules on a rectangular double integral | Both scripts use product composite weights on a uniform tensor grid over [0,1]² | confirmed |
| 2 | l.16, l.19 | I = ∫₀¹∫₀¹ 8e^{−x²−y⁴} dy dx, surface z = 8e^{−x²−y⁴} over R = [0,1]² | `f(x,y) = 8*exp(-(x^2)-(y^4))` in both scripts (line 9); `xlims = ylims = (0,1)` | confirmed |
| 3 | l.13 | "The archived module examples use" this integral | Examples 1–6 yes; Example 7 uses e^{−x√y} on a curved region | wrong in its generality (F2) |
| 4 | l.21–28 | 2D Trapezoidal = hk ΣΣ w_i w_j f, with endpoint weight ½ and interior weight 1 | `trapezoid2d` lines 25–39 are exactly this; it is exact for 1, x, xy and not for x² (err 1.04e-2 at n=4) | confirmed (undefined symbols: F1) |
| 5 | l.30–36 | 2D Simpson = (hk/9) ΣΣ a_i a_j f, with weights 1,4,2,…,4,1 | `simpson2d` lines 25–40 are exactly this; exact for x³y³, not for x⁴ (err 5.21e-4 at n=4). Formula as written fails for odd m (F1) | confirmed for even m; evenness condition missing (F1) |
| 6 | l.38–39 | archived snapshot is incomplete for some intermediate image IDs | gr_46–66 and gr_154–187 are absent (legacy-inventory statement, noted only) | confirmed (not scored) |
| 7 | l.43 | Each animation shows full-domain mesh refinement on [0,1]×[0,1] | Frames: grid lines cover the whole square in all 8 frames of both GIFs | confirmed |
| 8 | l.45 | archived benchmark I ≈ 5.04756680717 | mpmath: 5.04756680716753966 (both as 8·∫e^{−x²}·∫e^{−y⁴} and as a 2D quad); archive gr_88 shows "5.04756680717" | confirmed (correct to all 12 digits) |
| 9 | l.47 | Julia source linked under each case | links present: `trapezoidal2daa.jl` under Case 1, `simpson2daa.jl` under Case 2 | confirmed |
| 10 | Case 1 heading | 2D Trapezoidal Rule, f = 8e^{−x²−y⁴} | `trapezoidal2daa.jl` uses this rule and this f | confirmed |
| 11 | Case 1 | tensor grid updates over the whole square each frame, coarse to fine | n_seq = [2,4,6,8,10,12,16,20]; frames show n×n grids in that order | confirmed |
| 12 | Case 1 | approximation converges toward the archived reference value | errors 0.2985, 0.0722, 0.0320, 0.0180, 0.0115, 0.00797, 0.00448, 0.00287, decreasing monotonically | confirmed |
| 13 | Case 1 | visible second-order error decay under refinement | error ratios on halving: 2→4: 4.13, 4→8: 4.02, 8→16: 4.005, 10→20: 4.003 | confirmed |
| 14 | Case 1 | black lines join the sample nodes with straight segments, the grid lines of the piecewise-bilinear interpolant | `gridlines` draws polylines through (x_i, y, f(x_i, y)) at the nodes only; frame 1 shows straight chords | confirmed |
| 15 | Case 1 | integral of the bilinear interpolant is I_T | per cell, ∫ bilinear = hk/4 × (sum of 4 corners), which summed gives the product trapezoid weights; I checked this numerically by exactness for xy | confirmed |
| 16 | Case 1 alt | coloured surface with straight black grid lines; refinement 2x2 to 20x20; convergence to benchmark | frames 1 and 8; titles mesh = 2x2 … 20x20 | confirmed |
| 17 | Case 1 link/embed | `trapezoidal2daa.jl` / `trapezoidal2daa.gif` are this case | the script writes that GIF; the manifest shows the committed GIF is byte-identical to the regenerated one | confirmed |
| 18 | Case 2 heading | 2D Simpson Rule, same f | `simpson2daa.jl` uses this rule and this f | confirmed |
| 19 | Case 2 | Simpson tensor-product weights are recomputed on each refined mesh | `simpson2d(n)` is called per frame | confirmed |
| 20 | Case 2 | Simpson reaches high accuracy with fewer refinements than trapezoidal | Simpson at 6×6 has error 6.68e-4, below trapezoidal at 20×20 (2.87e-3); at 20×20 Simpson's error is 4.68e-6 | confirmed |
| 21 | Case 2 | black curves are the quadratics through the nodes over each pair of panels along every grid line | `quadpieces` builds the Lagrange quadratic on [t_k, t_{k+2}], k = 1, 3, …, and is applied along every x_i and y_j | confirmed |
| 22 | Case 2 | these are the grid lines of the piecewise-biquadratic interpolant, one patch per 2x2 block, whose integral is I_S | the biquadratic tensor interpolant restricted to a grid line is the 1D quadratic interpolant there; its integral gives the weights (h/3)(1,4,1)⊗(k/3)(1,4,1), which is the product Simpson rule (exact through x³y³ as checked) | confirmed |
| 23 | Case 2 | on the 2x2 mesh they differ from the trapezoidal straight lines by up to 0.51 in z | `curves.py`: max abs(quadratic − linear) over all 6 grid lines at n=2 is 0.51095, at x=0, y=0.25 | confirmed |
| 24 | Case 2 alt | coloured surface with black piecewise-quadratic curves; refinement 2x2 to 20x20; convergence toward benchmark | frames 1 and 8; errors fall from 5.87e-2 to 4.68e-6 | confirmed |
| 25 | Case 2 link/embed | `simpson2daa.jl` / `simpson2daa.gif` are this case | the script writes that GIF; committed and regenerated GIFs are byte-identical | confirmed |
| 26 | script comment `simpson2daa.jl` l.14 | n=2 quadratic along x=0 peaks at about 8.30 | `curves.py`: peak 8.2973 at x=0, y=0.191 (inside zlims 8.4, so nothing is clipped) | confirmed |
| 27 | script comment `trapezoidal2daa.jl` l.16 | includes archived checkpoints at 10x10 and 20x20 | archive Ex 3: Trapezoidal at m=n=10 gives 5.0360837636 and at 20 gives 5.04469842165; the script gives 5.036083763603 and 5.044698421647. Archive Ex 4 Simpson (m=5, i.e. 10 panels) gives 5.04764 and at 20 panels 5.04757148312; the script gives 5.047644586 and 5.047571483116 | confirmed |
| 28 | counts | 2 cases, 8 frames each | manifest and frames: 8 frames per GIF | confirmed (the page states no count) |

---

### 3. Implementation checks

### `trapezoidal2daa.jl`

- **It is the method it claims to be:** It applies the composite product trapezoidal rule on a uniform (n+1)×(n+1) grid with weights ½ at the ends and 1 in the interior on each axis, scaled by h_x·h_y (lines 19–40). This is the standard tensor-product composite rule and it matches the page's formula.
- **The numbers are right:** I loaded the script's own `trapezoid2d` (lines 1–41 included into a module in `instr.jl`) and compared it with an independent numpy implementation (`indep.py`):

| n | script I_T | independent I_T | abs(I_T − I) |
|---|---|---|---|
| 2 | 4.749087736005 | 4.749087736005 | 2.985e-1 |
| 4 | 4.975344691379 | 4.975344691379 | 7.222e-2 |
| 6 | 5.015604705554 | 5.015604705554 | 3.196e-2 |
| 8 | 5.029613219039 | 5.029613219039 | 1.795e-2 |
| 10 | 5.036083763603 | 5.036083763603 | 1.148e-2 |
| 12 | 5.039595175444 | 5.039595175444 | 7.972e-3 |
| 16 | 5.043084264495 | 5.043084264495 | 4.483e-3 |
| 20 | 5.044698421647 | 5.044698421647 | 2.868e-3 |

  Property checks with the script's routine at n=4 and f replaced by monomials: errors are exactly 0 for 1, x and xy, and 1.04e-2 for x², 7.05e-3 for x²y² and 1.56e-2 for x³. This is the degree of precision of the trapezoid rule. Error ratios on halving the step approach 4 (4.13, 4.02, 4.005, 4.0008 for 20→40), which is order 2. Values for n=10 and n=20 match Mathews' archive (Example 3) to every digit it shows.
- **Its reference values are right:** `true_val = 5.04756680717`. Two independent mpmath evaluations give I = 5.047566807167539662…, so the reference differs from the true value by 2.5e-12, about 1e-7 of the smallest error displayed (2.87e-3).
- **The picture shows what was computed:**
  - Titles: I viewed frames 1 and 8 and the 8-frame contact sheet. Each title's "I_T" and "|error|" equals the script's value rounded to 9 digits (frame 1: 4.749087736 / 0.298479071; frame 8: 5.044698422 / 0.002868386; all intermediate frames match the table).
  - Black grid lines: they are polylines through the exact nodal values, so they are the edges of the bilinear interpolant. In frame 1 the straight chords visibly cut below the curved surface, as expected.
  - Surface orientation: `Zf` is indexed [y, x], which is the GR surface convention. The black lines use explicit (x, y, f(x,y)) triples and lie on the surface at every node in all frames. Because f is not symmetric in x and y, this rules out a transposed surface.
  - Axis limits: zlims (0, 8.2) contain max f = 8 and clip nothing. No NaN masking is used beyond the polyline separators.

### `simpson2daa.jl`

- **It is the method it claims to be:** It applies the composite product Simpson rule with weights 1,4,2,…,4,1 on each axis (array index i maps to node i−1, so odd nodes get weight 4 and even interior nodes get 2), scaled by h_x·h_y/9 (lines 19–41). It is used only with even n, which is correct.
- **The numbers are right:**

| n | script I_S | independent I_S | abs(I_S − I) |
|---|---|---|---|
| 2 | 5.106262624448 | 5.106262624448 | 5.870e-2 |
| 4 | 5.051811626509 | 5.051811626509 | 4.245e-3 |
| 6 | 5.048234772908 | 5.048234772908 | 6.680e-4 |
| 8 | 5.047762777353 | 5.047762777353 | 1.960e-4 |
| 10 | 5.047644586076 | 5.047644586076 | 7.778e-5 |
| 12 | 5.047603712117 | 5.047603712117 | 3.690e-5 |
| 16 | 5.047578303611 | 5.047578303611 | 1.150e-5 |
| 20 | 5.047571483116 | 5.047571483116 | 4.676e-6 |

  Property checks with the script's routine at n=4: errors are exactly 0 for 1, x, xy, x², x²y², x³ and x³y³, and 5.21e-4 for x⁴ and 1.30e-3 for x⁵. That is degree of precision 3 per axis, as Simpson's rule should have. Error ratios on halving the step approach 16 (10→20: 16.63, 20→40: 16.15, 40→80: 16.04), which is order 4. Values for 10 and 20 panels match archive Example 4 (5.04764 and 5.04757148312).
- **Its reference values are right:** It uses the same `true_val` as the trapezoidal script and is correct to 2.5e-12, far below the smallest displayed error (4.676e-6).
- **The picture shows what was computed:**
  - Titles: these match the table in every frame (frame 1: 5.106262624 / 0.058695817; frame 8: 5.047571483 / 4.676e-6). Small errors switch to Julia's e-notation (7.7779e-5 and below), which is cosmetic and not a finding.
  - Black curves: these are the piecewise Lagrange quadratics through each consecutive node triple, drawn along every grid line. Frame 1 shows three curved lines in each direction. The x=0 curve rises above the surface to 8.30, which is the overshoot of the quadratic interpolant, and it stays inside zlims (0, 8.4), so nothing is clipped.
  - Surface orientation: verified in the same way as for the trapezoidal script.

### Regeneration

According to the manifest, scratch copies of both scripts ran cleanly (exit 0, about 7 s each), and the GIFs they produced are byte-identical to the committed ones. The frames I reviewed are therefore the output of the code I checked.

