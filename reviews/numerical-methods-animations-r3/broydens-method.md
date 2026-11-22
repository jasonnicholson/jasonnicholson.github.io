# Broyden's Method — animation review (round 3)

Page: `pages/numerical-methods/broydens-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**No findings.**

I checked every claim in the ledger below against evidence I produced, and none is wrong, misleading or materially imprecise.

One observation that is not a finding: the current iterate is drawn as a red marker. That is the same colour as the $f_2 = 0$ curve, and the page does not mention the marker. At the root the marker sits on the red curve, but it is much larger than the line, and no page claim depends on telling the two apart. This is cosmetic only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `broydenaa.jl` | 0 | 10.9 | broydenaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `broydenbb.jl` | 0 | 11.0 | broydenbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description, Newton | $J\Delta X = -F$, $X^{(k+1)} = X^{(k)} + \Delta X$; quadratic near a simple root | Standard | confirmed |
| D2 | Description, FD | Central-difference $M_{ij}$ formula; "$2n^2$ additional function evaluations per iteration" | Equals Mathews `gr_72`/`gr_73` ("2 n²"), counting scalar component evaluations: 2n vector evaluations × n components | confirmed |
| D3 | Description | Secant condition $B_{k+1}s_k = y_k$ with $s_k$, $y_k$ as defined | Script line 59: `B + (y - B s) s'/(s's)`; check $B_{k+1}s = B s + (y - B s) = y$ | confirmed |
| D4 | Description | Rank-1 update formula; it is the Frobenius-closest matrix satisfying the secant condition | Standard ("good" Broyden); the script implements exactly this formula | confirmed |
| D5 | Description | $O(n^2)$ to update; no new function evaluations beyond $F(X^{(k+1)})$ | Script evaluates F once per iterate and never re-evaluates the Jacobian | confirmed |
| D6 | Algorithm Step 0 | $B_0 = J(X^{(0)})$ exact; one Newton step gives $X^{(1)}$ | Script lines 43–44; Jacobian entries verified by hand: $\partial f_1 = (-4+4x, -6y^2)$, $\partial f_2 = (4x^3, 4+16y^3)$; matches Mathews `gr_664` | confirmed |
| D7 | Algorithm k ≥ 1 | Steps 1–4, with $s_{k-1} = X^{(k)} - X^{(k-1)}$ and the update using $F(X^{(k)}) - F(X^{(k-1)})$ | Script lines 48–64 (`s = X_curr - X_prev`, `y = F_curr - F_prev`, solve, step) | confirmed |
| D8 | Convergence | Superlinear near a simple root | Error ratios $e_{k+1}/e_k$: A 0.023, 0.030, 0.025, 0.039, 7.7e-4, 5.9e-6; B 0.104, 0.089, 0.027, 0.095, 0.018, 8.3e-4, 1.9e-4. Both trend to 0 | confirmed |
| I1 | Animations intro | System $f_1 = 1 - 4x + 2x^2 - 2y^3$, $f_2 = -4 + x^4 + 4y + 4y^4$ | Script lines 16–17 and 78–79; Mathews `gr_660`/`gr_664` | confirmed |
| I2 | Intro | Blue curve is $f_1 = 0$, red curve is $f_2 = 0$ | Script lines 92–93 (Z1 blue, Z2 red); frames: blue is the unbounded graph $y = \sqrt[3]{(1-4x+2x^2)/2}$, red is the closed quartic loop | confirmed |
| I3 | Intro | "exactly two real solutions" | Resultant in $x$ (degree 12 in $y$, square-free) has exactly 2 real roots, $y = -0.5756508$ and $y = 0.7244905$. Each gives one common $x$: (0.0617701263, 0.7244905153) and (1.5560974843, −0.5756507696) | confirmed |
| I4 | Intro | Solutions near (0.062, 0.724) and (1.556, −0.576) | Rounded values of I3 | confirmed |
| I5 | Intro | Both lie inside the plotted window | Window x ∈ [−1.75, 2.25], y ∈ [−1.5, 1.25] (script lines 29–30) | confirmed |
| I6 | Intro | Each frame adds the next iterate, joined to the earlier ones by a line | Script lines 84–98; frames show $X_0$ only in frame 1 and then grow | confirmed |
| I7 | Intro | After the first (Newton) step the iterates are too close to the root to separate | Steps after the first: A ≤ 1.1e-3; B: 1.07e-2, then ≤ 8.6e-4. About 0.01 units per pixel (4 units over ~420 px), so ≤ ~1 px; frames confirm | confirmed |
| I8 | Intro | Right panel shows $\lVert F(X^{(k)})\rVert$ on a log scale | Script lines 102–108, `yscale=:log10`; the ylims [1e-16, 1e1] contain every value (min 1.36e-15) | confirmed |
| A1 | Case A heading | $X^{(0)} = (0.1, 0.7)$, root ≈ (0.062, 0.724) | Script line 26; computed root (0.0617701, 0.7244905) | confirmed |
| A2 | Case A | Newton step moves the iterate "by about 0.05" | Step norm 0.04643 | confirmed |
| A3 | Case A | $\lVert F\rVert$ from 2.5e-1 to 7.8e-3 | 2.4843e-1 → 7.7616e-3 | confirmed |
| A4 | Case A | Down to 1.4e-15 at $X^{(6)}$ | 1.3552e-15 at k = 6; the run stops there (6 steps, 7 frames) | confirmed |
| A5 | Case A | From $X^{(0)}$ to $X^{(4)}$, shrinks by "between 24 and 43 times per step" | Ratios 32.0, 24.5, 42.3, 25.7 | confirmed |
| A6 | Case A | Last two steps each more than 1000× | 1.30e3, 1.65e5 | confirmed |
| A7 | Case A | Rank-1 updates, no new derivative evaluations | Script | confirmed |
| A8 | Case A alt | ‖F‖ falls from 2.5e-1 to 1.4e-15 in six steps; only the first step is visible | As A3/A4 and I7; frames 1–7 | confirmed |
| A9 | Case A wiring | Link `broydenaa.jl`, embed `broydenaa.gif` | Script has x0 = (0.1, 0.7); regenerated GIF is byte-identical to the committed one (manifest) | confirmed |
| B1 | Case B heading | $X^{(0)} = (1.5, -0.5)$, root ≈ (1.556, −0.576) | Script (diff vs aa); computed root (1.5560975, −0.5756508) | confirmed |
| B2 | Case B | Converges to the lower-right solution | Final iterate (1.556097484322, −0.575650769619) | confirmed |
| B3 | Case B | ‖F‖ falls at every step | 7.315e-1, 1.051e-1, 1.109e-2, 5.231e-5, 1.056e-5, 1.921e-7, 1.603e-10, 2.956e-14: monotone | confirmed |
| B4 | Case B | From 7.3e-1 at $X^{(0)}$ to 3.0e-14 at $X^{(7)}$ | 7.3154e-1; 2.9557e-14 at k = 7 | confirmed |
| B5 | Case B | Only about 5× from $X^{(3)}$ to $X^{(4)}$ | 4.95 | confirmed |
| B6 | Case B | More than 1000× in each of the last two steps | 1.20e3, 5.42e3 | confirmed |
| B7 | Case B | A different initial guess finds a different root | A → upper root, B → lower-right root | confirmed |
| B8 | Case B alt | Falls at every step from 7.3e-1 to 3.0e-14 in seven steps | B3/B4; 8 frames = 7 steps | confirmed |
| B9 | Case B wiring | Link `broydenbb.jl`, embed `broydenbb.gif` | Script has x0 = (1.5, −0.5); byte-identical regeneration | confirmed |
| F1 | Closing note | System and starting points follow Mathews' module. Example 5 poses the system, but its archived copy lacks the starting-point, result and graph images | `_lnk_7` references `gr_213`–`gr_241`; only `gr_213` (the system) exists on disk | confirmed |
| F2 | Closing note | Starting points are those of the standard Broyden runs in Example 8, whose printed iterates these animations reproduce | `gr_666`/`gr_671`/`gr_674`/`gr_677` give (0.1, 0.7) and (1.5, −0.5). `gr_673`/`gr_676`/`gr_679`/`gr_682` print P0..P6 and P0..P7, and they agree with the script's iterates in all 12 printed decimals (e.g. P4 for B: 1.556096954909285, −0.5756529705862952 vs 1.556096954909, −0.575652970586). Iteration counts match (6 and 7) | confirmed |
| F3 | Closing note | Examples 1 and 3 (Newton, pseudo-Newton), Example 8's improved (Sherman–Morrison) method and the 3-D/4-D exercises are not animated | Matches the module's contents; the omission is disclosed | confirmed |
| T1 | Frame titles | Suptitles "solution near (0.062, 0.724)" / "(1.556, −0.576)"; panel titles $X_k$ and ‖F(X_k)‖ with the correct index | Instrumented title strings, e.g. `X_6 = (0.0618, 0.7245)`, `||F(X_6)|| = 1.36e-15`; `X_7 = (1.5561, -0.5757)`, `||F(X_7)|| = 2.96e-14`; they match the frames | confirmed |

### 3. Implementation checks

### `broydenaa.jl`

- **Method:** the "good" Broyden method (Broyden 1965), with an exact Jacobian for $B_0$ and a first Newton step. It is the same as Mathews' standard `Broyden` routine and the page's Algorithm. There are no safeguards, damping or line search. It stops when ‖F‖ < 1e-12, or after 10 updates.
- **Numbers:** the instrumented script copy and my independent numpy implementation agree in all 12 printed decimals at every k:

| k | script X | independent X | script ‖F‖ | independent ‖F‖ |
|---|---|---|---|---|
| 0 | (0.100000000000, 0.700000000000) | same | 2.4843e-01 | 2.4843e-01 |
| 1 | (0.061038616443, 0.725258837008) | same | 7.7616e-03 | 7.7616e-03 |
| 2 | (0.061779159834, 0.724459783672) | same | 3.1620e-04 | 3.1620e-04 |
| 3 | (0.061770589062, 0.724491157041) | same | 7.4833e-06 | 7.4833e-06 |
| 4 | (0.061770109194, 0.724490490188) | same | 2.9154e-07 | 2.9154e-07 |
| 5 | (0.061770126325, 0.724490515328) | same | 2.2354e-10 | 2.2354e-10 |
| 6 | (0.061770126339, 0.724490515347) | same | 1.3552e-15 | 1.3552e-15 |

  Both also match Mathews' printed P0..P6 (`gr_673`, `gr_676`).
- **Reference values:** the title root (0.062, 0.724) is checked against a 40-digit mpmath `findroot` value, (0.06177012633860…, 0.72449051534721…), and against the sympy resultant root. The final iterate's error is 1.4e-16.
- **Picture:** the zero contours use `Z[yi, xi]`, laid out the right way for `contour(xg, yg, Z)`, and the intersections fall at the computed roots. Each frame plots iterates 0..k, with the current one in red. The residual panel plots `residuals[1:k+1]` against 0..k, and every value lies inside the y-limits. There is no clamping or masking. 7 frames = $X_0..X_6$.

### `broydenbb.jl`

Identical to aa except for the header comments, the start point (1.5, −0.5), the suptitle and the output name (checked with `diff`).

- **Numbers:** script and independent implementation agree in all 12 printed decimals:

| k | X (script = independent) | ‖F‖ |
|---|---|---|
| 0 | (1.500000000000, −0.500000000000) | 7.3154e-01 |
| 1 | (1.563144329897, −0.582474226804) | 1.0507e-01 |
| 2 | (1.555352036863, −0.575188105942) | 1.1090e-02 |
| 3 | (1.556095422857, −0.575627127116) | 5.2312e-05 |
| 4 | (1.556096954909, −0.575652970586) | 1.0562e-05 |
| 5 | (1.556097494141, −0.575650731327) | 1.9212e-07 |
| 6 | (1.556097484314, −0.575650769650) | 1.6032e-10 |
| 7 | (1.556097484322, −0.575650769619) | 2.9557e-14 |

  This matches Mathews' printed P0..P7 (`gr_679`, `gr_682`).
- **Reference values:** root (1.556097484322055, −0.575650769618843), from both the resultant and mpmath. The final error is 6.3e-15.
- **Picture:** same as aa. 8 frames = $X_0..X_7$. Frames 2–8 show $X_1$ and later iterates overlapping, as the page says.

### Fidelity

The system, starting points and iterates reproduce Mathews' Example 8 standard-Broyden runs exactly. Mathews draws $x \in [-2, 2]$, $y \in [-2, 1]$ with the colours swapped. The page states its own colour convention correctly, so this does not matter to a reader. The only difference from Example 5 is the starting points, which the archive cannot supply, and the page discloses this. No archive case for this system is silently dropped.

