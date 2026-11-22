# Broyden's Method — animation review (round 4)

Page: `pages/numerical-methods/broydens-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding. Every checkable claim on the page, in the script headers and in the frames agrees with the computed values at the precision it is stated to.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `broydenaa.jl` | 0 | 10.2 | broydenaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `broydenbb.jl` | 0 | 11.1 | broydenbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `broydenaa.gif` | 7 | byte-identical | broydenaa |
| `broydenbb.gif` | 8 | byte-identical | broydenbb |

### Page references

- Scripts linked: `broydenaa.jl`, `broydenbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words / location) | Evidence | Verdict |
|---|---|---|---|
| D1 | Newton step: $J\Delta X=-F$, $X^{(k+1)}=X^{(k)}+\Delta X$ (l.18) | Standard. Matches Mathews' theorem | confirmed |
| D2 | Newton needs $n^2$ partial-derivative evaluations per step (l.12, l.20) | $n\times n$ Jacobian. Matches Mathews | confirmed |
| D3 | Central-difference Jacobian $M_{ij}=(F_i(X+he_j)-F_i(X-he_j))/2h$ uses $2n^2$ extra function evaluations (l.26–28) | Formula matches Mathews `gr_72.gif` and the count matches `gr_73.gif` ("2 n²"). In scalar component evaluations it is $2n\cdot n$ | confirmed |
| D4 | Secant condition $B_{k+1}s_k=y_k$ with $s_k$, $y_k$ as defined (l.34–36) | `checks.py`: $\lVert B_{k+1}s-y\rVert_\infty \le 3\times10^{-17}$ at every update in both runs | confirmed |
| D5 | Rank-1 update $B_{k+1}=B_k+(y-B_ks)s^T/(s^Ts)$ is the least change in the Frobenius norm (l.38–40) | Same as Mathews `gr_207.gif`. `checks.py`: adding any other admissible correction ($u w^T$ with $w\perp s$) increased $\lVert B-B_{old}\rVert_F$ in every trial | confirmed |
| D6 | The update costs $O(n^2)$ and needs no function evaluations beyond $F(X^{(k+1)})$ (l.42) | An outer product. The script calls `F` once per iteration | confirmed |
| D7 | Algorithm: Step 0 uses the exact Jacobian and one Newton step. Then evaluate F, update B, solve $B_k\Delta X=-F$, step (l.46–56) | Script lines 43–64 do exactly this, in this order | confirmed |
| D8 | Superlinear convergence near a simple root (l.60) | Ratios $e_{k+1}/e_k$ (`checks.py`): A gives 0.023, 0.030, 0.025, 0.039, 7.7e-4, 9.8e-6. B gives 0.10, 0.089, 0.027, 0.095, 0.018, 8.3e-4, 2.2e-4. Both tend to 0 | confirmed |
| A1 | System $f_1=1-4x+2x^2-2y^3$, $f_2=-4+x^4+4y+4y^4$ (l.66) | Script l.16–17 and the contour arrays l.78–79. Same as Mathews `gr_213`/`gr_660` | confirmed |
| A2 | Blue curve is $f_1=0$, red curve is $f_2=0$ (l.68) | Script l.92–93: Z1 is blue, Z2 is red. Frames: the open S-shaped cubic-in-y curve is blue and the closed quartic loop is red | confirmed |
| A3 | Exactly two real solutions, near (0.062, 0.724) and (1.556, −0.576) (l.68) | Resultant in y has degree 12 with exactly 2 real roots that solve both equations: (0.0617701263386074, 0.724490515347217) and (1.55609748432205, −0.575650769618843) | confirmed |
| A4 | Both lie inside the plotted window (l.68) | Window x∈[−1.75, 2.25], y∈[−1.5, 1.25]. Both intersections are visible in every frame | confirmed |
| A5 | Each frame adds the next iterate, joined to the earlier ones by a line (l.68) | Script l.84–98. Frames confirm | confirmed |
| A6 | After the first (Newton) step the iterates are too close to the root to separate at this scale (l.68) | Step 2 length is 1.09e-3 for A and 1.07e-2 for B. The panel is about 100 px per unit, so about 1 px. Frames show overlapping markers | confirmed |
| A7 | Right panel plots $\lVert F(X^{(k)})\rVert$ on a log scale (l.68) | Script l.70 and l.102 (`yscale=:log10`). Frames confirm | confirmed |
| A8 | Example 5 poses this system. Its archived copy lacks the starting-point, result and graph images (l.72) | `lnk_7.html` shows Example 5 with system `gr_213` (present). Images `gr_214`–`gr_241` are all missing on disk | confirmed |
| A9 | Starting points are those of the standard Broyden runs in Example 8, and the animations reproduce its printed iterates (l.72) | `gr_676` (standard Broyden, from (0.1, 0.7)) and `gr_682` (from (1.5, −0.5)). Every printed $P_k$ matches the script's iterates to all 15–16 digits shown, e.g. A $P_6$=(0.0617701263386075, 0.7244905153472168) and B $P_7$=(1.556097484322055, −0.5756507696188374) | confirmed |
| A10 | Examples 1 and 3 are Newton and pseudo-Newton. Example 8 is the improved, Sherman–Morrison Broyden. The 3-D and 4-D exercises are not animated (l.73) | Module text: Ex 1 is Newton, Ex 3 is Pseudo-Newton, Ex 8 is "improved Broyden" after the Sherman–Morrison theorem. Ex 2, 4, 6 and 9 are 3-D and Ex 7 and 10 are 4-D | confirmed |
| CA1 | Case A heading: $X^{(0)}=(0.1, 0.7)$, root ≈ (0.062, 0.724), convergent | Script l.26. Converges to (0.061770, 0.724491) | confirmed |
| CA2 | The first Newton step moves the iterate by about 0.05 | 0.04643 | confirmed |
| CA3 | ‖F‖ falls from 2.5e-1 to 7.8e-3 on that step | 2.4843e-1 → 7.7616e-3 | confirmed |
| CA4 | ‖F‖ reaches 1.4e-15 at $X^{(6)}$ | 1.3552e-15 at k=6. Script and Python agree | confirmed |
| CA5 | From $X^{(0)}$ to $X^{(4)}$, ‖F‖ shrinks by between 24 and 43 times per step | Ratios 32.0, 24.5, 42.3, 25.7 | confirmed |
| CA6 | Over each of the last two steps it shrinks by more than 1000 times | 1.30e3 and 1.65e5 | confirmed |
| CA7 | Link `broydenaa.jl` and embed `broydenaa.gif` are Case A | The script has x0 = (0.1, 0.7). The GIF titles say "solution near (0.062, 0.724)" and X_0 = (0.1000, 0.7000) | confirmed |
| CA8 | Alt text: only the first step is large enough to see. ‖F‖ falls from 2.5e-1 to 1.4e-15 in six steps | Frames 1–7, 6 steps. Final title is "‖F(X_6)‖ = 1.36e-15" | confirmed |
| CB1 | Case B heading: $X^{(0)}=(1.5, −0.5)$, root ≈ (1.556, −0.576), convergent | Script l.26. Converges to (1.556097, −0.575651) | confirmed |
| CB2 | Converges to the lower-right solution | Yes, the final iterate equals that root to 1e-14 | confirmed |
| CB3 | ‖F‖ falls at every step, from 7.3e-1 at $X^{(0)}$ to 3.0e-14 at $X^{(7)}$ | 7.3154e-1 → … → 2.9557e-14. Every ratio exceeds 1 | confirmed |
| CB4 | Only about a factor of 5 from $X^{(3)}$ to $X^{(4)}$ | 5.2312e-5 / 1.0562e-5 = 4.95 | confirmed |
| CB5 | More than 1000 times in each of the last two steps | 1.20e3 and 5.42e3 | confirmed |
| CB6 | Starting-point dependent: a different initial guess finds a different root | A reaches the upper root and B the lower-right root | confirmed |
| CB7 | Link `broydenbb.jl` and embed `broydenbb.gif` are Case B | The script has x0 = (1.5, −0.5). The GIF titles match | confirmed |
| CB8 | Alt text: ‖F‖ falls at every step from 7.3e-1 to 3.0e-14 in seven steps | 8 frames, 7 steps. Final title is "‖F(X_7)‖ = 2.96e-14" | confirmed |
| W1 | The page is linked from the section index | `pages/numerical-methods/index.qmd:27` | confirmed |
| W2 | The cross-link `../nonlinear-systems/index.qmd` exists | The file exists | confirmed |

One claim could not be determined. It is not a finding: I could not establish which starting points Mathews' Example 5 itself used, because those images (`gr_219`, `gr_220`) are missing from the archive. The page discloses this.

### 3. Implementation checks

The two scripts are identical except for the header comments, the starting point, the title string and the output file name (checked with `diff`). The manifest reports that a scratch copy of each regenerates its committed GIF byte for byte.

### `broydenaa.jl` (X0 = (0.1, 0.7))

- **It is the method it claims to be.** It is Broyden's "good" method (Broyden's first method). It applies an explicit rank-1 update to B, not to its inverse, takes the exact Jacobian at step 0 and solves a linear system each step. This is the standard Broyden variant described on the page and in Mathews' Example 5 and Theorem. It is not the Sherman–Morrison "improved" variant, and the page says so. The Jacobian (l.20–23) agrees with sympy (`[[4x−4, −6y²],[4x³, 16y³+4]]`) and with a central finite difference to 3.9e-10. Stopping rule: the loop breaks when ‖F‖ < 1e-12 or when sᵀs < 1e-20.
- **The numbers are right.** Script output against independent numpy (both shown to 15 decimals):

  | k | script X_k | independent X_k | ‖F‖ script / indep. |
  |---|---|---|---|
  | 0 | (0.100000000000000, 0.700000000000000) | same | 2.4843e-1 / 2.4843e-1 |
  | 1 | (0.061038616443267, 0.725258837008245) | same | 7.7616e-3 / 7.7616e-3 |
  | 2 | (0.061779159834426, 0.724459783671636) | same | 3.1620e-4 / 3.1620e-4 |
  | 3 | (0.061770589062488, 0.724491157041490) | same | 7.4833e-6 / 7.4833e-6 |
  | 4 | (0.061770109194288, 0.724490490187661) | same | 2.9154e-7 / 2.9154e-7 |
  | 5 | (0.061770126325456, 0.724490515327927) | same | 2.2354e-10 / 2.2354e-10 |
  | 6 | (0.061770126338607, 0.724490515347217) | same | 1.3552e-15 / 1.3552e-15 |

  These also match Mathews' printed standard-Broyden iterates (`gr_676`) to every digit shown. Property checks: the secant condition holds to ≤3e-17 at every update, each update is the Frobenius least change, the final residual is 1.4e-15, and the error ratios tend to 0 (superlinear).
- **Its reference values are right.** The script draws no separate reference root. The title "solution near (0.062, 0.724)" agrees with the mpmath root (0.0617701263386074, 0.724490515347217). The contour arrays Z1 and Z2 are the same f1 and f2 as `F`.
- **The picture shows what was computed.** Frames 1, 2, 4 and 7 were viewed, and the contact sheet showed all frames. The left title "X_k = (x, y)" uses the correct index and the 4-decimal value of the current iterate. The right title "‖F(X_k)‖" matches `residuals[k+1]` (instrumented output). The log-plot points match the table. ylims (1e-16, 1e1) contain every residual (minimum 1.36e-15). There are 7 frames, k = 0..6. No clamping or masking. Both roots are in the window.

### `broydenbb.jl` (X0 = (1.5, −0.5))

- **It is the method it claims to be.** The code is the same as above.
- **The numbers are right.**

  | k | script X_k | independent X_k | ‖F‖ script / indep. |
  |---|---|---|---|
  | 0 | (1.500000000000000, −0.500000000000000) | same | 7.3154e-1 |
  | 1 | (1.563144329896907, −0.582474226804124) | same | 1.0507e-1 |
  | 2 | (1.555352036863449, −0.575188105942452) | same | 1.1090e-2 |
  | 3 | (1.556095422856546, −0.575627127115621) | same | 5.2312e-5 |
  | 4 | (1.556096954909285, −0.575652970586295) | same | 1.0562e-5 |
  | 5 | (1.556097494140761, −0.575650731326978) | same | 1.9212e-7 |
  | 6 | (1.556097484313824, −0.575650769650469) | same | 1.6032e-10 |
  | 7 | (1.556097484322055, −0.575650769618837) | same | 2.9557e-14 |

  These match Mathews `gr_682` to every digit shown. Mathews' F(P) = (−8.49e-15, 2.83e-14) has norm 2.96e-14, which also matches. The secant condition holds to ≤2e-18 and the error ratios tend to 0 (2.2e-4 at the last step).
- **Its reference values are right.** The title "solution near (1.556, −0.576)" agrees with the mpmath root (1.55609748432205, −0.575650769618843).
- **The picture shows what was computed.** The contact sheet and frame 8 were viewed. The titles and log-plot points match the instrumented output. The minimum residual of 2.96e-14 is inside the ylims. There are 8 frames, k = 0..7. The first step (length 0.104, about 10 px) is visible and later steps are not, as the page says.

### Notes that are not findings

- The current-iterate marker is red, the same colour as the $f_2$ curve, and earlier iterates are steelblue, close to the $f_1$ blue. The page does not describe the marker colours, and the frames remain readable.
- Mathews draws $f_1$ in red and $f_2$ in blue. The page swaps the colours but says which is which. Colour choice is excluded.

