# Taylor Series Method for ODE's — animation review (round 2)

Page: `pages/numerical-methods/taylor-series-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: the legacy animations varied the number of subintervals, but the new ones show a single, well-resolved run

- **Location:** both cases. `taylorderivativeaa.jl` lines 28 and 47–60 and `taylorderivativebb.jl` lines 34 and 53–66 (fixed `n = 100`, revealed 5 steps per frame). Page lines 16–30.
- **What the legacy has:** Both Mathews animations have the same ODE, $y'=1-t\sqrt[3]{y}$, $y(0)=1$ on $[0,5]$, with order n=3 (`Tayloraa.gif`) and n=4 (`Taylorbb.gif`). Each frame is a full solution for a different number of subintervals: m = 12, 14, 18, 20, 28, 32, 40, 52, 70, 100 for order 3 and m = 12, 14, 18, 20, 28, 32, 44, 56, 80, 120 for order 4. Each frame is labelled "Using m = … subintervals" with its "y(5) = …". The subject of the animation is the spurious spikes and negative values that appear at coarse steps, and how they disappear as m grows (y(5) settles at 0.0081199). For example, the order-3 frame for m = 20 shows y(5) = 0.0895215 and the spike near t = 4.25.
- **What the page has:** Each GIF animates one run with h = 0.05 (m = 100), revealed left to right. That run is well inside the stability region, so the two GIFs look the same (contact sheets `committed/taylorderivativeaa/sheet.png` and `committed/taylorderivativebb/sheet.png` agree in every frame annotation to 4 decimals). The coarse-step instability that the legacy animations were about appears only in the Behavior text (h = 0.25). The page gives no reason for the change.
- **Why only Minor:** Nothing the page states is false. The text describes the coarse-step phenomenon correctly, and its h = 0.25 order-3 numbers match Mathews' m = 20 frame exactly (see the ledger). But a reader gets two animations that look identical and never sees the behaviour the archive animated.
- **Evidence:** legacy frames as listed above. Script values: `review/ys_aa.txt` and `review/ys_bb.txt`, where the frame-annotation values for the two orders are identical to 4 decimals at t = 0, 0.5, …, 5.
- **Suggested correction:** Either (a) restructure each script to animate over m (for example m = 12, 14, 18, 20, 28, 32, 40, 52, 70, 100 for order 3), labelling m and y(5) in each frame, or (b) keep the current animations and add a sentence saying they show only the stable h = 0.05 run, with the coarse-step behaviour described in the text. With option (a), note that the order-4 frames for y < 0 will not match Mathews (see the note under ledger entry L22).

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `taylorderivativeaa.jl` | 0 | 6.1 | taylorderivativeaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `taylorderivativebb.jl` | 0 | 6.1 | taylorderivativebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

The reference solution ("ref") is mpmath `odefun` (30 digits, tol 1e-25) on the 101-point grid. It agrees with scipy DOP853 (rtol 1e-13) to 3.6e-13 on the grid.

| # | Page claim (own words) | Evidence | Verdict |
|---|---|---|---|
| L1 | Intro: IVP $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | Both scripts: `t0,y0=0,1`, `T=5`, f = `1 - t*y^(1/3)` / `1 - t*cbrt(y)` | confirmed |
| L2 | "Each frame adds five Taylor steps (0.25 in t)" | `stride=5`, `h=0.05`; `for frame in 1:5:101` gives 21 frames; frame annotations go t = 0, 0.25, …, 5 | confirmed |
| L3 | "the connecting curve passes through every computed point" | `plot!(ts[1:frame], ys[1:frame])` is a polyline through all computed nodes | confirmed |
| L4 | Taylor update $y_{n+1}=y_n+hy'_n+\frac{h^2}{2}y''_n+\cdots$, derivatives computed analytically from the ODE | aa line 23, bb line 29: `y + h d1 + h²/2 d2 + h³/6 d3 (+ h⁴/24 d4)`. The derivatives match sympy total derivatives exactly (L8) | confirmed |
| L5 | Local accuracy $O(h^{p+1})$ for order p | Global ratios ≈ 2^p (L9), which implies local order p+1 | confirmed |
| L6 | Julia source linked under each case | `[Julia source](taylorderivativeaa.jl)` under Case 1, `bb` under Case 2. Manifest: committed GIFs are byte-identical to regenerated ones | confirmed |
| L7 | Case 1 heading: order 3, n=100, h=0.05 | aa: `taylor3_step`, `n=100`, `h=(5-0)/100`. GIF title "Taylor order 3, h = 0.05" | confirmed |
| L8 | Case 1: "three derivative terms are used per step" | y', y'', y''' are used. sympy: script yd2 and yd3 minus the true total derivatives simplify to 0 | confirmed |
| L9 | Case 1: LTE $O(h^4)$, global $O(h^3)$ | Max error over t = k·0.05 for n = 100→200→400→800: ratios 8.49, 8.21, 8.11 (→ 8 = 2³) | confirmed |
| L10 | "Taylor method requires explicit symbolic derivatives" | Correct description of the method and the script | confirmed |
| L11 | Case 1: largest error at the 101 step points is $1.3\times10^{-5}$ | Independent Taylor-3 vs ref: 1.327e-5 at t = 3.15. Script values = independent values to 8.9e-16 | confirmed |
| L12 | Case 1: error at t=5 is $1.2\times10^{-9}$ | 1.186e-9 (script y(5) = 0.0081199192789; ref 0.00811992046487) | confirmed |
| L13 | exact $y(5)=0.0081199$ | ref y(5) = 0.00811992046486796 (mpmath and scipy agree). There is no closed form, but the reference is accurate far beyond the stated digits. The exact solution stays positive: y' = 1 > 0 at y = 0 | confirmed |
| L14 | Order-3 stability limit 2.513 | Root of \|1+z+z²/2+z³/6\| = 1 on the negative real axis: z = −2.5127 | confirmed |
| L15 | $\partial f/\partial y=-t/(3y^{2/3})$ reaches −41.3 at t=5 | Analytic derivative is correct. Along ref: J(5) = −41.255. J is monotone decreasing for t > 1, so the minimum on [0,5] is at t = 5 | confirmed |
| L16 | Order 3: threshold h ≈ 0.0609 | 2.5127/41.255 = 0.06091 | confirmed |
| L17 | "Just above h=0.0609 this affects only the last few steps" | m = 82 (h = 0.0610): err(5) = 1.8e-9, max error 2.5e-5 at t = 3.11, so nothing visible. Consistent | confirmed |
| L18 | Order 3, h=0.25: instability starts at t≈3.3 | 0.25·\|J\| crosses 2.5127 along ref at t = 3.279. At computed step points it is 2.26 at t = 3.25 and above 3 at t = 3.5 | confirmed |
| L19 | Order 3, h=0.25: jumps from 0.0068 at t=4 to 1.22 at t=4.25 | Script copy with n = 20: 0.0067951 → 1.2161637. Independent Python: same. Mathews' m = 20 frame shows the same spike, and y(5) = 0.0895215 matches ours (0.0895215) | confirmed |
| L20 | Case 1 alt text: builds left to right, five steps per frame, rises to about 1.45 near t=0.9, falls smoothly to y≈0.0081 at t=5 | Frames 1–21: peak of computed solution ≈ 1.4498 (ref peak 1.44977 at t = 0.884). Last frame annotation "t=5.0 y≈0.0081" | confirmed |
| L21 | Case 2 heading: order 4, n=100, h=0.05 | bb: `taylor4_step`, `n=100`. GIF title "Taylor order 4, h = 0.05" | confirmed |
| L22 | Case 2: "four derivative terms … all computed analytically" | d1…d4. sympy: script yd4 (rational in c = ∛y) minus the true 4th total derivative is exactly 0, and yd2 and yd3 likewise | confirmed |
| L23 | Case 2: LTE $O(h^5)$, global $O(h^4)$ | Ratios 17.99, 16.74, 16.38 (→ 16) | confirmed |
| L24 | Case 2: largest error at 101 points is $8.0\times10^{-7}$ | 8.021e-7 at t = 3.30. Script = independent to 6.7e-16 | confirmed |
| L25 | "more than 16 times smaller than the 1.3e-5 of order 3" | 1.327e-5 / 8.021e-7 = 16.5 | confirmed |
| L26 | Order-4 stability limit 2.785 | Root of \|Σ_{k≤4} z^k/k!\| = 1: z = −2.7853 | confirmed |
| L27 | Order 4: threshold h ≈ 0.0675 | 2.7853/41.255 = 0.06751 | confirmed |
| L28 | "Just above h=0.0675 this affects only the last few steps" | m = 74 (h = 0.0676): err(5) = 3.8e-10, max error 2.9e-6 | confirmed |
| L29 | Order 4, h=0.25: starts at t≈3.3 | Crossing along ref at t = 3.342 | confirmed |
| L30 | Order 4, h=0.25: values turn negative at t=4.25 and reach about −10 at t=4.5; exact stays positive | Script copy with n = 20: y(4) = 0.01419, y(4.25) = −0.04653, y(4.5) = −10.434. Independent Python with the real cube root gives the same. The exact solution is > 0 (L13). *Note:* Mathews' order-4 m = 20 frame differs after y goes negative (spike up to ≈ 0.65, y(5) = 0.0711898). The Mathematica code evidently treats the cube root of a negative number differently. With the real-cube-root convention the script uses (Julia `cbrt`), −10.4 is the correct order-4 Taylor iterate. Where y > 0 throughout, the order-4 legacy y(5) values match ours exactly (m = 32: −0.080651; m = 44: 0.0081717; m = 56: 0.00812) | confirmed |
| L31 | Case 2 alt text: same description as Case 1 | Frames of `taylorderivativebb.gif` match (peak ≈ 1.45 near t ≈ 0.9; final "t=5.0 y≈0.0081") | confirmed |
| L32 | Embeds: Case 1 → `taylorderivativeaa.gif`, Case 2 → `taylorderivativebb.gif` | Page lines 22 and 30. GIF titles say order 3 and order 4 respectively | confirmed |

Not checked, as excluded by the review standard: "Source inspiration", the Planned sections, and the Legacy Animation Inventory stub.

---

### 3. Implementation checks

Commands (all from the review folder):
- `julia inst_aa.jl`, `julia inst_bb.jl`: scratch copies with the animation removed, printing every (i, t_i, y_i) → `ys_aa.txt`, `ys_bb.txt`
- `julia inst20_aa.jl`, `julia inst20_bb.jl`: the same with `n = 20` → `ys20_*.txt`
- `/usr/bin/python3 -I indep.py <review>`: sympy derivatives, independent Taylor stepping, mpmath and scipy reference, convergence ratios
- `/usr/bin/python3 -I stab.py`: stability limits, J(5), thresholds, crossing times
- `/usr/bin/python3 -I h025.py`: independent h = 0.25 runs under three cube-root conventions, and comparison with legacy m values
- `/usr/bin/python3 -I thresh.py <review>`: error just above and below the thresholds

### `taylorderivativeaa.jl` (order 3)
- **Method:** This is the true order-3 Taylor series method. Each step uses y + h f + h²/2 y'' + h³/6 y''', with y'' and y''' the total derivatives along f. sympy confirms that the script's `yd2` and `yd3` minus the true total derivatives simplify to 0. The derivation in the comment (line 14) is also correct.
- **Numbers:** The script's iterates agree with an independent Python Taylor-3 (sympy-generated derivatives) to within 8.9e-16 at all 101 nodes. Order check: max-error ratios under halving are 8.49, 8.21, 8.11, so order 3.
- **Reference values:** The script draws no reference curve. The page's y(5) = 0.0081199 matches the mpmath reference 0.00811992046.
- **Picture:** The polyline runs through ts[1:frame], ys[1:frame], with a red marker at the current node. The annotation shows t and y at that node, rounded, and matches the computed values at every 0.5 checked (1.0, 1.3648, 1.4422, 1.2499, 0.8596, 0.4045, 0.0898, 0.0254, 0.0162, 0.0112, 0.0081). The title states the right order, h and ODE. The axes (−0.1..5.1, −0.05..1.8) contain the whole solution, nothing is clamped, and the end point is visible in frame 21.
- Robustness note (not a finding): `y^(1/3)` would throw a DomainError for y < 0. This never happens at h = 0.05, or at the page's h = 0.25 example for order 3 (min y = 0.0068).

### `taylorderivativebb.jl` (order 4)
- **Method:** This is the true order-4 Taylor method. `yd4_f` is the closed-form 4th total derivative in c = ∛y, and sympy confirms it equals the true derivative exactly (difference 0). `yd2_f` and `yd3_f` are also exact. The update includes h⁴/24·y''''.
- **Numbers:** The script's iterates equal an independent Taylor-4 to within 6.7e-16. Ratios 17.99, 16.74, 16.38, so order 4. y(5) = 0.0081199205, error 3.85e-11, and the reference is accurate to about 1e-13, which is enough for this comparison.
- **Reference values:** none drawn. The page's figures are confirmed in the ledger.
- **Picture:** same construction as the order-3 script. The annotations match the computed values. The title is correct and the whole solution is visible.

### Committed vs regenerated GIFs
Byte-identical for both (manifest), so the frames I checked are those of the current code.

