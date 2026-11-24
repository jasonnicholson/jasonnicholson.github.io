# Nonlinear Systems — animation review (round 9)

Page: `pages/numerical-methods/nonlinear-systems/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, in the scripts' headers and in the frames agrees with my independent computation at the precision stated. Nothing in the frames contradicts the page.

Observations that are below the threshold for a finding (cosmetic, and they do not change what a viewer concludes):
- In frame 0 of each GIF the green start diamond is hidden under the red current-iterate marker, because both sit at the same point. The legend still lists both.
- The current-iterate marker is the same red as the f₂ = 0 curve. This is a colour choice, and the legend tells them apart.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonsysaa.jl` | 0 | 8.4 | newtonsysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonsysab.jl` | 0 | 7.5 | newtonsysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtonsysaa.gif` | 9 | byte-identical | newtonsysaa |
| `newtonsysab.gif` | 9 | byte-identical | newtonsysab |

### Page references

- Scripts linked: `newtonsysaa.jl`, `newtonsysab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (abridged) | Verdict | Evidence |
|---|---|---|---|
| D1 | Jacobian J = [[f_x, f_y],[g_x, g_y]], J_ij = ∂F_i/∂x_j | confirmed | Standard definition. The script's Jacobian equals the sympy Jacobian `[[4x-4, -6y^2],[4x^3, 16y^3+4]]`. |
| D2 | Fixed-point iteration X⁽ᵏ⁺¹⁾ = G(X⁽ᵏ⁾) | confirmed | Standard. Matches Mathews' Example 1 form (gr_75). |
| D3 | Row-sum condition at X*, with the start close enough, guarantees convergence | confirmed | ‖J_G(X*)‖_∞ < 1 makes G a local contraction. Matches Mathews' theorem, case (i). |
| D4 | Row-sum is sufficient but not necessary; converges locally when ρ(J_G(X*)) < 1 | confirmed | Ostrowski's theorem. |
| D5 | Newton linearization and update J ΔX = −F, X⁽ᵏ⁺¹⁾ = X⁽ᵏ⁾ + ΔX | confirmed | The scripts run `pts[k] - Jv \ F(pts[k])`, which is equivalent. |
| D6 | Four steps of one Newton iteration | confirmed | Matches the code and Mathews' four steps. |
| D7 | Quadratic near a nonsingular solution; digits roughly double | confirmed | Measured e_{k+1}/e_k² ≈ 0.53 (case 1) and ≈ 0.96 (case 2) in the asymptotic regime. |
| D8 | Singular Jacobian at the solution means the quadratic rate is lost | confirmed | Standard result, in the generic case. |
| D9 | Same algorithm in any dimension | confirmed | Standard. |
| D10 | Table: fixed-point linear with factor ≈ ρ when 0<ρ<1; superlinear when ρ=0 (Newton as a fixed-point iteration) | confirmed | Standard asymptotics. G(X) = X − J⁻¹F has J_G(X*) = 0 when J(X*) is nonsingular. |
| D11 | Table: cost per iteration (low vs Jacobian + solve) | confirmed | True of the algorithms. |
| D12 | Table: starting-point sensitivity "High" vs "Moderate" | could not determine | A qualitative judgement that no computation settles. |
| A1 | System f₁ = 1 − 4x + 2x² − 2y³, f₂ = −4 + x⁴ + 4y + 4y⁴ | confirmed | Same as lines 12–13 of both scripts and the same as Mathews gr_221. |
| A2 | Blue curve is f₁ = 0, red curve is f₂ = 0 | confirmed | Code `lc=:blue` on Z1 and `:red` on Z2. Frames checked: blue reaches y = −0.794 at x = 1 (true cbrt(−1/2) = −0.794); red crosses x = 0 at y = 0.7245 and −1.2207. |
| A3 | "Their two intersections are the solutions" | confirmed | The resultant in y has degree 12 with exactly 2 real roots (sympy `real_roots`): y = −0.57565, 0.72449. |
| A4 | Each frame adds one Newton step (J evaluated, linear solve, update) | confirmed | Frame k shows pts[1..k+1]. There are 9 frames: the start plus 8 steps. |
| A5 | 301×301 grid over each window: >90% within 1e-10 of a solution in ≤10 iterations | confirmed | 91.32% (window 1) and 93.21% (window 2). The NumPy and Julia runs agree exactly. |
| A6 | Starts near det J = 0 can be thrown far outside the window and need dozens of iterations | confirmed | 1813 and 1362 starts need ≥24 iterations. Their median distance to the det J = 0 curve is 0.037 and 0.040, against 0.55 and 0.72 for all starts. The slowest orbit reaches \|coord\| ≈ 1.9e29 and 9.1e23. |
| A7 | Over 200 iterations for the slowest start in each window | confirmed | Window 1: 246 iterations from (−0.1083, −0.6908). Window 2: 203 iterations from (−0.2, −0.675). Both implementations give these values, and no start fails to converge within 2000 iterations. |
| A8 | Julia scripts linked under each case | confirmed | Links at lines 86 and 94. |
| A9 | Non-animated Mathews items: Example 1 (fixed point), Example 3 (equivalence), Example 4 (Newton as fixed point), Exercise 5 (3×3) | confirmed | Matches the NewtonSystemMod.html example list. The Example 1 G (gr_75) is algebraically equivalent to the system (Example 3). |
| C1-1 | Heading: Solution 1, start (0.5, 0.8) | confirmed | `p0 = [0.5, 0.8]`, title "Starting at (0.5, 0.8)". |
| C1-2 | Start just above the red curve and well above the blue curve at x = 0.5 | confirmed | At x = 0.5 the red upper branch is at y = 0.7182 and the blue curve at y = −0.6300. |
| C1-3 | Converges rapidly to (0.0618, 0.7245) | confirmed | mpmath gives 0.0617701263386, 0.7244905153472. The script prints 0.06177013, 0.72449052. |
| C1-4 | "upper-left portion of the plot" | confirmed | Window x ∈ [−0.25, 2.25], y ∈ [−1.25, 1.5]. |
| C1-5 | Distances 0.44 → 0.24 → 0.024 → 3e-4 → 5e-8 → 1e-15 | confirmed | 0.4447, 0.2367, 0.02374, 2.923e-4, 4.569e-8, 1.116e-15 (mpmath), and 1.110e-15 for the float64 script iterates. |
| C1-6 | Each error roughly the square of the previous | confirmed | Ratios e_{k+1}/e_k²: 1.20, 0.42, 0.52, 0.53, 0.53. |
| C1-7 | Alt text: converges to ≈ (0.062, 0.724) | confirmed | As C1-3. |
| C2-1 | Heading: Solution 2, start (2, −1) | confirmed | `p0 = [2.0, -1.0]`, title "Starting at (2, -1)". |
| C2-2 | Start in the lower-right region near Solution 2 | confirmed | Window x ∈ [−0.25, 2.75], y ∈ [−1.5, 1.25]. Initial distance 0.614. |
| C2-3 | Converges to (1.5561, −0.5757) | confirmed | mpmath gives 1.556097484322, −0.575650769619. Mathews lnk_2 gives {1.5560974843220556, −0.5756507696188449}. The script header and printout agree. |
| C2-4 | Blue crosses red near its rightmost point (1.5579, −0.6300) | confirmed | The rightmost point of f₂ = 0 has ∂f₂/∂y = 0, so y = −(1/4)^{1/3} = −0.629961 and x = 1.557854. |
| C2-5 | Distances 0.61 → 0.21 → 0.034 → 1.1e-3 → 1.1e-6 → 1.1e-12 | confirmed | 0.6141, 0.2142, 0.03367, 1.051e-3, 1.058e-6, 1.076e-12 (float64: 1.079e-12). |
| C2-6 | Quadratic, each error roughly the square of the previous | confirmed | Ratios: 0.57, 0.73, 0.93, 0.96, 0.96. |
| C2-7 | Alt text ≈ (1.556, −0.576), lower-right intersection | confirmed | As C2-3. |
| W1 | Case 1 links and embeds newtonsysaa.jl/.gif; Case 2 links and embeds newtonsysab.jl/.gif | confirmed | The parameters in each script match its heading. |

### 3. Implementation checks

### newtonsysaa.jl
- **Method:** plain (undamped) Newton for a 2×2 system. It solves J Δ = F with backslash (LU) and subtracts. This is the method named on the page.
- **Numbers:** float64 iterates from `iter64.jl`, set beside mpmath (50 digits, `indep.py`):

| k | script (x, y) | mpmath (x, y) |
|---|---|---|
| 1 | −0.173128205128, 0.753712606838 | −0.1731282051, 0.7537126068 |
| 2 | 0.038071590057, 0.725858577763 | 0.03807159006, 0.7258585778 |
| 3 | 0.061477808008, 0.724493571739 | 0.06147780801, 0.7244935717 |
| 4 | 0.061770080651, 0.724490515556 | 0.06177008065, 0.7244905156 |
| 5+ | 0.061770126339, 0.724490515347 | 0.06177012634, 0.7244905153 |

  The script's analytic Jacobian matches the symbolic Jacobian from sympy.
- **Reference values:** the script takes pts[end] after 8 steps as the solution. It is within 7e-17 of the true root, and the residual is at machine precision.
- **Picture:** the path is built from pts[1..frame+1], and the current marker sits at pts[frame+1]. The legend labels x⁽ᵏ⁾ show the right index and values rounded to 4 decimals: (−0.1731, 0.7537), (0.0381, 0.7259), (0.0615, 0.7245), then (0.0618, 0.7245). All match `iter64.jl`. All iterates lie inside the window (min x = −0.173 > −0.25), so nothing is clamped. Zero contours come from a 400×400 grid, and the curves agree with spot values (A2, C1-2).

### newtonsysab.jl
- **Method:** the same Newton implementation.
- **Numbers:**

| k | script (x, y) | mpmath (x, y) |
|---|---|---|
| 1 | 1.75, −0.666666666667 | 1.75, −0.6666666667 |
| 2 | 1.589691077157, −0.577916982642 | 1.589691077, −0.5779169826 |
| 3 | 1.557144460948, −0.575553596832 | 1.557144461, −0.5755535968 |
| 4 | 1.556098540666, −0.575650704608 | 1.556098541, −0.5756507046 |
| 5+ | 1.556097484322, −0.575650769619 | 1.556097484, −0.5756507696 |

- **Reference values:** pts[end] equals the root to machine precision, and it agrees with Mathews' quoted root.
- **Picture:** the legend values (1.75, −0.6667), (1.5897, −0.5779), (1.5571, −0.5756), then (1.5561, −0.5757) all match. The path and markers are correct, and all iterates lie inside the window. The intersection sits just left of the red curve's rightmost point, as the page says.

### Grid study (page line 76)
I ran the basin study twice, independently: vectorized NumPy with the 2×2 solve by Cramer's rule (`grid.py`), and Julia with the scripts' own `Jac \ F` (`grid.jl`). Settings: 301×301 `linspace` over each script's plot window, Euclidean distance below 1e-10 to either root, at most 2000 iterations. Both give identical results:
- Window 1: 91.32% of starts converge in ≤10 iterations; the slowest start takes 246 iterations; none fail to converge.
- Window 2: 93.21% converge in ≤10 iterations; the slowest start takes 203 iterations; none fail to converge.

### Fidelity
The page's system is Mathews' (gr_221), and so is its fixed-point form (gr_75), which is cited as Example 1. The page explicitly lists the examples it does not animate. Mathews' Example 2 starting points could not be checked because the solution images are missing from the archive. His quoted Solution 2 matches the page. I found no fidelity departure.

