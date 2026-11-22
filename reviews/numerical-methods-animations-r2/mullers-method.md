# Muller's Method — animation review (round 2)

Page: `pages/numerical-methods/mullers-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1: Case 2's first frame does not draw the parabola as far as the axis crossing that gives the next iterate
- **Kind:** Implementation (drawing) / page match. **Severity:** Minor.
- **Location:** `mullersbb.jl` line 77: `xpara = range(min(q0, q1, q2) - 0.2, max(q0, q1, q2) + 0.2, length=200)`. The page introduction says: "the next iterate is found where the parabola crosses the x-axis".
- **What is there now:** In frame 1 (triple 0.8, 0.9, 1.0) the dashed parabola is drawn only on [0.6, 1.2]. It ends at about y = 0.2, still above the axis. The crossing that gives Muller's next iterate, p3 = 1.254316, is at x = 1.2543, outside the drawn range. A viewer of the first frame cannot see where the next iterate comes from. In frames 2–9 of Case 2, and in every frame of Case 3, the crossing does fall inside the drawn range.
- **How I know:** I ran `python3 -I geom.py`. Case `bb` frame 1 gave `q3=1.254316 drawn=[0.6000,1.2000] q3_in=False`, and every other frame gave `q3_in=True`. I confirmed it visually in `committed/mullersbb/frame_001.png`, where the dashed curve stops near (1.2, 0.2).
- **Suggested correction:** Extend the drawn range to include the next iterate, as `mullersaa.jl` already does (lines 83–84). Compute `q3 = muller_step(q0, q1, q2, f)` in the frame loop and use `range(min(q0,q1,q2,q3) - 0.2, max(q0,q1,q2,q3) + 0.2, ...)`. Make the same change in `mullerscc.jl` line 78 for consistency. Nothing is currently wrong there.

- **Independent check:** not run (Minor finding, unverified)

### F2: Case 3's vertical scale makes the parabola and its crossing nearly unreadable
- **Kind:** Implementation (display). **Severity:** Minor.
- **Location:** `mullerscc.jl` line 17: `ylims = (-12.0, 20.0)`.
- **What is there now:** The three starting points have f = 1.236, 1.081 and 0.703 (`f(1.3)`, `f(1.4)`, `f(1.5)`). Every later iterate has |f| < 0.21. Against a 32-unit-tall axis, the parabola is a short dashed stub a few pixels tall, and its crossing of the axis, which is the step the page tells the reader to watch, is barely distinguishable. From frame 4 on, all three points merge into one dot. The upper limit of 20 also clamps `f` at both ends (`clamp.` on line 75), which shows up as flat magenta segments along the top border near x = ±2.3. I have counted the clamping as part of the readability problem, not as a separate finding.
- **How I know:** I viewed `committed/mullerscc/frame_002.png` and `frame_005.png`. In frame 2 the parabola spans roughly 1.2 to 1.83 in x and about 1.5 to −0.3 in y, which is about 15 px tall in a 500 px plot.
- **Suggested correction:** Narrow the window around the root, for example `xlims = (0.9, 2.1)` and `ylims = (-0.5, 1.5)`. Alternatively, add a zoomed inset or second panel around x ∈ [1.25, 1.95]. If the whole curve stays in view, drop the `clamp.` on `f` and let the axis clip it.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Totals:** 0 Error, 0 Misleading, 2 Minor.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `mullersaa.jl` | 0 | 5.7 | mullersaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullersbb.jl` | 0 | 5.8 | mullersbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullerscc.jl` | 0 | 6.0 | mullerscc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `mullersaa.gif` | 9 | byte-identical | mullersaa |
| `mullersbb.gif` | 9 | byte-identical | mullersbb |
| `mullerscc.gif` | 9 | byte-identical | mullerscc |

### Page references

- Scripts linked: `mullersaa.jl`, `mullersbb.jl`, `mullerscc.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (location) | Check | Verdict |
|---|---|---|---|
| 1 | Intro: Muller's method fits "a parabola through three successive approximations of a root" | All three scripts build the Lagrange parabola through (q0, q1, q2) and take its root nearest p2 (or, in Case 1, its vertex) | confirmed |
| 2 | Intro: "The parabola (dashed blue) passes through the current triple (p0,p1,p2)" | Code: `ls=:dash`, `color=:steelblue`, Lagrange interpolant of the three points. Frames show the dashed curve through the three dots | confirmed |
| 3 | Intro: "the next iterate is found where the parabola crosses the x-axis (in Case 1 the parabola never reaches the axis…)" | True of the computation in Cases 2 and 3. In Case 2 frame 1 the crossing is not drawn (F1) | confirmed (computation); drawing issue in F1 |
| 4 | Intro: "Each frame advances one iteration: the oldest point is dropped" | `history[i+1] = (q1, q2, q3)` in all scripts | confirmed |
| 5 | Intro: "the new root estimate becomes p2 (red dot). The gray dots are p0 and p1." | Code lines 97–99 (aa), 83–85 (bb, cc); frames | confirmed |
| 6 | Case 1 heading: f(x) = x³ − 3x + 2, double root at p = 1, "Convergent" | sympy `factor` gives `(x - 1)**2*(x + 2)`. Iterates → 1.0000000312 at frame 9 | confirmed |
| 7 | Case 1: "f(x) = (x−1)²(x+2)" | sympy factor | confirmed |
| 8 | Case 1: "starting from p2 = 2.0" | `p_init = [2.2, 2.1, 2.0]` | confirmed |
| 9 | Case 1: "None of the parabolas reaches the x-axis: at every step its roots are complex" | Discriminants of all 9 drawn parabolas, from the script (float64) and from mpmath: −20.16, −3.909, −0.5667, −0.03021, −1.007e−3, −1.097e−5, −2.157e−8, −6.52e−12, −1.2e−16 (float64 −2.5e−15). All negative | confirmed |
| 10 | Case 1: "the first would be p3 ≈ 1.2873 + 0.3563i" | mpmath complex Muller root: 1.287301587 + 0.3563447873i (and its conjugate) | confirmed |
| 11 | Case 1: "takes the real part of that complex root instead, which is the parabola's vertex" | Algebra: Re[p2 − 2C/(B ± i√−Δ)] = p2 − 2CB/(B² − Δ) = p2 − 2CB/(4AC) = p2 − B/(2A), the vertex. Numerically, the vertex x and Re(complex root) agree to all printed digits at every step | confirmed |
| 12 | Case 1: "(open red circle)" marks the vertex | Code lines 91–93: white fill, red stroke, at (q3, P(q3)). Frame 1 shows it at (1.287, 0.800), and the computed vertex y is 0.8000 | confirmed |
| 13 | Case 1: "The iterates 1.2873, 1.1581, 1.0552, 1.0100, 1.0017, …" | Script: 1.2873015873, 1.1580878020, 1.0552041928, 1.0099991954, 1.0016845915. mpmath: same to ≥12 digits | confirmed |
| 14 | Case 1: iterates "decrease to p = 1" | Script sequence is strictly decreasing through frame 9 (1.0000000312) | confirmed |
| 15 | Case 1: "superlinearly (order ≈ 1.32 asymptotically for this real-part variant)" | mpmath at 6000 digits, 32 iterates: successive order estimates settle at 1.325. 10-step geometric mean 1.32469, which is the plastic number, the root of r³ = r + 1 | confirmed |
| 16 | Case 1: "faster than Newton's method, which converges only linearly at a double root" | Newton from 2.0: errors 0.556, 0.298, 0.155, 0.0796, 0.0403, 0.0203, 0.0102, 0.00509 (ratio → 1/2). This matches Mathews' archived 1 − p8 = −0.00509474. Muller (real-part variant) error after 8 iterates: 3.1e−8 | confirmed |
| 17 | Case 1 alt text: parabolas never reach the axis, each new iterate is the vertex (real part of complex root), converge to the double root at p = 1, start p2 = 2.0 | Rows 8–14 | confirmed |
| 18 | Case 1 link `mullersaa.jl` and embed `mullersaa.gif` | Script has f = x³ − 3x + 2 and writes `mullersaa.gif`. Title in frames reads "f(x) = x³ - 3x + 2" | confirmed |
| 19 | Case 2 heading: f(x) = sin(x² − 2)(x² − 2), double root at √2, "Convergent" | f ≈ (x² − 2)² near x² = 2, so the root is double. Iterates → 1.4141744 at frame 9 (error 3.9e−5) | confirmed |
| 20 | Case 2: "p = √2 ≈ 1.4142" | √2 = 1.41421356 | confirmed |
| 21 | Case 2: "starting from p2 = 1.0" | `p_init = [0.8, 0.9, 1.0]` | confirmed |
| 22 | Case 2: "double root where x² − 2 = 0 since both factors vanish simultaneously" | sin(0)·0. Each factor has a simple zero, so the product has a double zero | confirmed |
| 23 | Case 2: "Muller's method locates it efficiently despite the flat tangent at the root" | Muller error after 8 new iterates: 3.9e−5. Newton from 1.0 after 8 (Mathews' table): 7.7e−4. Monotone convergence, all discriminants > 0 | confirmed (qualitative) |
| 24 | Case 2 alt text | f, root, start match | confirmed |
| 25 | Case 2 link/embed `mullersbb.jl`/`mullersbb.gif` | Script f and output name match. Frame title "f(x) = sin(x²-2)·(x²-2)" | confirmed |
| 26 | Case 3 heading: f = x⁶ − 7x⁴ + 15x² − 9, double root at √3, "Convergent" | sympy: `(x - 1)*(x + 1)*(x**2 - 3)**2`. Iterates → 1.7319878 at frame 9 | confirmed |
| 27 | Case 3: "factors as (x²−1)(x²−3)²" | sympy factor; mpmath identity check, max difference 5e−399 | confirmed |
| 28 | Case 3: "p = √3 ≈ 1.7321" | √3 = 1.7320508 | confirmed |
| 29 | Case 3: "Starting from p2 = 1.5" | `p_init = [1.3, 1.4, 1.5]` | confirmed |
| 30 | Case 3: "Newton's method would converge linearly here" | Standard result for a double root (error ratio → 1/2). Same mechanism verified numerically for Case 1 (row 16) | confirmed |
| 31 | Case 3: "Muller's method converges superlinearly, with order ≈ 1.23 at this double root" | mpmath, 28 iterates: order estimates 1.2337–1.2338, which matches the root of 2r³ − r² − r − 1 = 0, 1.2337519. Case 2 gives the same 1.2338 | confirmed |
| 32 | Case 3: "(below the ≈ 1.84 it achieves at a simple root)" | Root of r³ = r² + r + 1 is 1.839287. Numerical check on eˣ − 2 from 0.4, 0.5, 0.6: estimates 1.78, 1.85, 1.844 | confirmed |
| 33 | Case 3 alt text | f, root, start match | confirmed |
| 34 | Case 3 link/embed `mullerscc.jl`/`mullerscc.gif` | Script f and output name match. Frame title matches | confirmed |
| 35 | "Julia source scripts … are linked under each case" | Three `[Julia source]` links present | confirmed |

The page has no Description section with formulas, so there was no method description to check against the code.

---

### 3. Implementation checks

All three scripts share the same `muller_step`. It computes h0 = p1 − p0, h1 = p2 − p1, δ0 and δ1, d = (δ1 − δ0)/(h1 + h0), b = δ1 + h1·d, and the step p3 = p2 − 2f2/(b ± √(b² − 4f2·d)), with the sign chosen to maximise |denominator|. This is standard Muller in the root-nearest-p2 form, which drops the oldest point. My independent code builds the same parabola from divided differences expanded about p2, and reproduces every iterate.

### `mullersaa.jl` (Case 1)
- **Method:** Muller's method with a disclosed variant. When the discriminant is negative, the step returns the real part of the complex Muller root, p2 − b/(2d), which is the parabola's vertex (algebra in ledger row 11). The page and the script header both name this variant. Mathews' archived program handles a negative discriminant differently, by setting disc := 0, so p3 = p2 − 2c/b. That gives p3 = 1.1091314, p4 = 1.4944130, p5 = 1.0557604, p6 = 0.9964676. My mpmath implementation in the `mathews` mode reproduces those four values exactly. The page's variant is valid and disclosed. Its iterates differ from Mathews' table, but the page does not quote Mathews' numbers, so I did not count this as a finding.
- **Numbers:**

  | k | script p_k | mpmath p_k | disc (script) |
  |---|---|---|---|
  | 3 | 1.2873015873016 | 1.2873015873015873 | −20.1596 |
  | 4 | 1.158087802003537 | 1.1580878020035357 | −3.90889 |
  | 5 | 1.0552041927906899 | 1.055204192790688 | −0.566726 |
  | 6 | 1.0099991953537275 | 1.0099991953537275 | −0.0302075 |
  | 7 | 1.0016845914908628 | 1.0016845914908629 | −1.00717e−3 |
  | 8 | 1.000107900677376 | 1.00010790067738 | −1.09694e−5 |
  | 9 | 1.0000030057271563 | 1.0000030057271222 | −2.15684e−8 |
  | 10 | 1.0000000311735213 | 1.0000000311740599 | −6.52e−12 |

  Differences of about 1e−14 to 1e−13 in the last rows are float64 cancellation at a double root. They are invisible at the 5 digits shown in the legend.
- **Reference values:** The true root 1 is exact (sympy factorisation). Header line 20, "f(2.2) = 6.048", is correct.
- **Picture:** In frames 1, 3 and 9, the dashed parabola passes through the gray and red dots. The open red circle sits at the vertex (frame 1: (1.287, 0.800), computed vertex y = 0.8000). The legend "p₂ = …" matches the iterate at 5 digits in every frame I checked (2.0, 1.15809, 1.0). The "parabola (no real root)" label is correct in all 9 frames, because the discriminant is negative in all 9. The drawn range includes the vertex in every frame. The parabola is clamped at y = 7 for 30 points in frame 1 and 16 in frame 2, along the top border. That is harmless.

### `mullersbb.jl` (Case 2)
- **Method:** Standard real Muller. The script raises an error on a negative discriminant, and none occurs: the discriminants are 14.39, 6.729, 1.459, 0.1582, 0.01574, 9.07e−4, 2.86e−5 and 4.69e−7, all positive.
- **Numbers:** Script p3..p10: 1.2543159902744359, 1.3222993665586782, 1.3688966241528713, 1.3970591565574766, 1.408412963976924, 1.4126956654374672, 1.4139236819552305, 1.4141744432077474. mpmath gives the same values to all 16–17 digits. Mathews' archived table (`gr_103`–`gr_119`) gives the same values to all 16 printed digits, from the same starting values 0.8, 0.9, 1.0.
- **Reference:** The root √2 is exact. The asymptotic order is 1.2338, as expected for a double root.
- **Picture:** Frames 1, 2, 5 and 9 show the parabola through the three points, the red dot at p2 and the legend matching the iterate. In frame 1 the parabola is not drawn as far as its crossing at 1.2543 (F1). In frame 2 the parabola is clamped at y = −0.2 for 15 points along the bottom border, which is not visible as a separate feature.

### `mullerscc.jl` (Case 3)
- **Method:** Standard real Muller, the same as `bb`. The discriminants are all positive: 45.12, 19.97, 4.894, 0.7533, 0.09670, 8.03e−3, 4.09e−4, 1.19e−5.
- **Numbers:** Script p3..p10: 1.627646913608958, 1.6742682889831824, 1.7034875047036455, 1.7200472229337476, 1.72750110119843, 1.7306305638858632, 1.7317042934610234, 1.7319877986383865. mpmath gives 1.6276469136089565, 1.6742682889831808, 1.7034875047036412, 1.7200472229337408, 1.7275011011984546, 1.7306305638856946, 1.7317042934613555, 1.7319877986375479. They agree to 12 or more digits, and the residual difference is float64 cancellation at the double root.
- **Reference:** The root √3 is exact (sympy). The script header correctly notes that Mathews' "near x = 2" refers to the root at √3.
- **Picture:** Frames 1, 2, 5 and 9: the geometry is correct, the legend values match and the crossing lies within the drawn range in all frames. The scale makes the construction nearly unreadable (F2).
- **Fidelity:** Mathews' Example 3 gives the Newton start p0 = 1.5 (`gr_144`), and the page's p2 = 1.5 is consistent with it. Mathews' Muller starting triple for Example 3 could not be determined, because the archive's images after `gr_144` are missing. The page's 1.3, 1.4, 1.5 follows the pattern of Examples 1 and 2.

### Fidelity summary
Examples 1, 2 and 3 of Mathews map to Cases 1, 2 and 3, with the same functions, roots and starting values where the archive shows them. Case 2 reproduces Mathews' Muller table digit for digit. Case 1 uses a different complex-discriminant fallback from Mathews' program, as described above. It is disclosed and valid, so I did not count it as a finding. No archive case is dropped.

