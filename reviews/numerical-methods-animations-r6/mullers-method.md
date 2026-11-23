# Muller's Method — animation review (round 6)

Page: `pages/numerical-methods/mullers-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match / implementation (picture). **Minor.** In Case 3 the last frames show no visible iteration

- **Location:** `mullerscc.jl` lines 16–17 (`xlims = (0.9, 2.1)`, `ylims = (-0.5, 1.5)`, which are fixed for all frames). The page text affected is the intro in `index.qmd` line 12: "the next iterate is found where the parabola crosses the x-axis … the oldest point is dropped, and the new root estimate becomes $p_2$ (red dot). The gray dots are $p_0$ and $p_1$."
- **What is there now:** The window is fixed at 1.2 units wide (about 560 px). From frame 7 on, the three points span 1.07e-3, 2.8e-4 and 5.5e-5 in x (computed: frame 7 points 1.72005, 1.72750, 1.73063; frame 9 points 1.73063, 1.73170, 1.73199). That is under 0.5 px, so the gray dots sit hidden under the red dot. The step to the parabola's axis crossing (1.07e-3, 2.8e-4, 5.5e-5) is also under one pixel. The crossing itself is never marked in this case. I compared frames pixel by pixel (PIL difference, threshold 30, legend excluded). Frames 7→8 and 8→9 differ only in the bounding box x 356–549, y 130–353. That is the parabola's dashed arms, whose drawn extent (`min−0.2 … max+0.2`) shifts slightly. Nothing changes at the root. Frames 7, 8 and 9 look identical except for the legend value of p₂ (`committed/mullerscc/frame_007.png` … `frame_009.png`).
- **What is true instead:** The method keeps making real progress in these frames: the error falls 1.4e-3 → 3.5e-4 → 6.3e-5 → 7.8e-6. Cases 1 and 2 zoom each frame and add an inset for exactly this reason. Case 3 does not, so a third of its animation does not show the dropped point, the gray dots or the axis crossing that the intro tells the reader to look for.
- **Correction:** Zoom each frame to the current triple and the next iterate, as `mullersbb.jl` lines 68–73 do, or add an inset around the step from p₂ to the axis crossing. Mark the crossing with the open red circle used in Cases 1 and 2. If the fixed window is kept, the Case 3 text should say that the last frames are converged at this scale.

No other findings. Every numerical claim, behaviour claim, count and wiring entry on the page checked out against my independent computation (ledger below).

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Total: 0 Error, 0 Misleading, 1 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `mullersaa.jl` | 0 | 10.9 | mullersaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullersbb.jl` | 0 | 10.7 | mullersbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullerscc.jl` | 0 | 6.7 | mullerscc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `mullersaa.gif` | 8 | byte-identical | mullersaa |
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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | Parabola through three successive approximations; "parabola (dashed blue) passes through the current triple $(p_0,p_1,p_2)$" | All three scripts draw `lagrange_parabola` through `(q0,q1,q2)` in steelblue `ls=:dash`. Frames show the dashed curve through all three dots. | confirmed |
| 2 | Intro | "next iterate is found where the parabola crosses the x-axis (in Case 1 the parabola never reaches the axis; see that case)" | Cases 2 and 3: `muller_step` returns the real root nearest p2. indep.py gives the same next iterates (rows 21, 29). Case 1: discriminant < 0 in all 8 frames. | confirmed (in Case 3 the crossing is not visible in late frames; see F1) |
| 3 | Intro | "Each frame advances one iteration: the oldest point is dropped, and the new root estimate becomes $p_2$ (red dot). The gray dots are $p_0$ and $p_1$." | `history[i+1] = (q1, q2, q3)` in all scripts. The red scatter is q2 and the gray are q0 and q1. Frames confirm this, e.g. Case 2 frame 2 has red at 1.25432 and gray at 0.9 and 1.0. | confirmed (in Case 3 frames 7–9 the gray dots are hidden; see F1) |
| 4 | Intro | Julia source linked under each case | `[Julia source](mullersaa.jl)`, `(mullersbb.jl)`, `(mullerscc.jl)`, one under each case | confirmed |
| 5 | Case 1 heading | "Convergent, $f(x)=x^3-3x+2$, double root at $p=1$" | Script line 21 has the same f. sympy: f=(x−1)²(x+2), f(1)=f′(1)=0, f″(1)=6. Iterates converge to 1 (row 11). | confirmed |
| 6 | Case 1 | "$f(x)=(x-1)^2(x+2)$, starting from $p_2=2.0$" | sympy factor. `p_init = [2.2, 2.1, 2.0]`. | confirmed |
| 7 | Case 1 | "None of the parabolas reaches the x-axis: at every step its roots are complex" | Discriminant per frame: −20.16, −3.909, −0.5667, −3.021e-2, −1.007e-3, −1.097e-5, −2.157e-8, −6.52e-12 (script). indep.py gives the same signs at 60 digits. | confirmed |
| 8 | Case 1 | "the first would be $p_3 \approx 1.2873+0.3563i$" | indep.py complex Muller gives 1.287301587 + 0.3563447873i. With the script's tie-break `abs(b+D) >= abs(b-D)`, b+D is chosen and Im > 0. | confirmed |
| 9 | Case 1 | Real part of that complex root "is the parabola's vertex (open red circle)" | Algebra: Re(p2 − 2f2/(b+i s)) = p2 − 2f2·b/(b²+s²) = p2 − b/(2d). Numerically, \|vertex_x − Re(root)\| = 1.6e-61 over all 8 frames (indep.py). Frames show an open red circle at the vertex, labelled "vertex = next p₂". | confirmed |
| 10 | Case 1 | "Each frame is zoomed to the current points, and the inset magnifies the vertex" | Script lines 78–82 and 108–119. Visible on the contact sheet. | confirmed |
| 11 | Case 1 | Vertex height "falls from 0.80 to $5.4\times10^{-13}$ over the eight frames" | Script: 7.9998e-01 … 5.4319e-13. indep.py (60 digits): 0.79998 … 5.4343e-13. The GIF inset titles read "8.00e-01" … "5.43e-13". 8 frames. | confirmed |
| 12 | Case 1 | Iterates "$1.2873, 1.1581, 1.0552, 1.0100, 1.0017, \ldots$" | Script/indep: 1.2873015873, 1.1580878020, 1.0552041928, 1.0099991954, 1.0016845915 | confirmed |
| 13 | Case 1 | "decrease to $p=1$" | All of the first 15 iterates are above 1 and decreasing (order.py sign string `+++++++++++++++`) | confirmed |
| 14 | Case 1 | "superlinearly (order $\approx 1.32$ asymptotically for this real-part variant)" | order.py at 3000 digits: log-ratio order estimates 1.3244–1.3249, which is the plastic number 1.3247 | confirmed |
| 15 | Case 1 | "faster than Newton's method, which converges only linearly at a double root" | Mathews' archive Newton from 2.0: error 5.09e-3 after 8 steps. The real-part Muller variant has error 3.1e-8 after 8 steps. Newton is linear at a double root (standard; f′(1)=0). | confirmed |
| 16 | Case 1 | Mathews' program "drops the square root, so the step is $p_3=p_2-2f(p_2)/b$, where $b$ is the parabola's slope at $p_2$" | Archive `gr_5.gif`: `If[b b > 4 a c, disc = Sqrt[...], disc = 0]; Z = -2c/(b+disc)`. Its b is the coefficient of h in a h²+b h+c about p2, which is the slope at p2. (Mathews' program also re-orders the retained points, which the page does not mention. That does not affect any number the page quotes; see row 17.) | confirmed |
| 17 | Case 1 | Mathews' iterates "$1.1091, 1.4944, 1.0558, 0.9965, \ldots$ rise to 1.4944, drop below 1, and then approach 1 from both sides" | Archive output (`ex1b.png`): 1.1091314, 1.4944130, 1.0557604, 0.9964676, 0.9981213, 1.0000166, 0.9999988, 1.0000000056. My re-implementation `mathews.py` reproduces them all. | confirmed |
| 18 | Case 1 alt text | "parabolas never reach the x-axis, so each new iterate is the parabola's vertex (the real part of the complex root), and the iterates converge to the double root at p = 1; each frame is zoomed…, and an inset magnifies the vertex just above the x-axis" | Rows 7, 9, 10, 11 and 13. The inset shows the open circle above the axis line in every frame. | confirmed |
| 19 | Case 1 wiring | Link `mullersaa.jl`, embed `mullersaa.gif` | That script has the Case 1 f and p_init, and the GIF title is "f(x) = x³ - 3x + 2" | confirmed |
| 20 | Case 2 heading | "Convergent, $f(x)=\sin(x^2-2)(x^2-2)$, double root at $p=\sqrt2$" | Script line 16 has the same f. sympy: f(√2)=f′(√2)=0, f″(√2)=16. | confirmed |
| 21 | Case 2 | "converges to the double root $p=\sqrt2\approx1.4142$ starting from $p_2=1.0$" | `p_init=[0.8,0.9,1.0]`. Iterates 1.25432, 1.32230, 1.36890, 1.39706, 1.40841, 1.41270, 1.41392, 1.41417, 1.4142102 (script = indep.py to about 1e-16). At 3000 digits the sequence converges to √2 (error 5e-1637). √2 = 1.41421356. | confirmed |
| 22 | Case 2 | "double root where $x^2-2=0$ since both factors vanish simultaneously" | sin(u)·u ≈ u² with u=x²−2, which has a simple zero (u′=2√2≠0). See row 20. | confirmed |
| 23 | Case 2 | "Muller's method locates it efficiently despite the flat tangent at the root" | Discriminant > 0 in all 9 frames (14.39 … 3.13e-9). Asymptotic order 1.2338 (order.py), which is superlinear. | confirmed (qualitative) |
| 24 | Case 2 | "Each frame is zoomed to the current points, and the inset magnifies the step from $p_2$ to the parabola's axis crossing (open red circle), which is the next iterate" | Script lines 68–73 and 99–112. Frames show an open red circle on the axis, labelled "axis crossing = next p₂". | confirmed |
| 25 | Case 2 | "the step shrinks from 0.25 to $3.6\times10^{-5}$ over the nine frames" | Steps 2.5432e-01 … 3.5799e-05 (script and indep). Inset titles read "2.54e-01" … "3.58e-05". 9 frames. | confirmed |
| 26 | Case 2 alt text | "converging to the double root at p = sqrt(2) starting from p₂ = 1.0; each frame is zoomed…, inset magnifies the step…" | Rows 21 and 24 | confirmed |
| 27 | Case 2 wiring | `mullersbb.jl` / `mullersbb.gif` | Matching f and title | confirmed |
| 28 | Case 3 heading | "Convergent, $f(x)=x^6-7x^4+15x^2-9$, double root at $p=\sqrt3$" | Script line 12 has the same f. sympy: f(√3)=f′(√3)=0, f″(√3)=48. | confirmed |
| 29 | Case 3 | "factors as $(x^2-1)(x^2-3)^2$, giving a double root at $p=\sqrt3\approx1.7321$" | sympy: (x−1)(x+1)(x²−3)². √3 = 1.7320508. | confirmed |
| 30 | Case 3 | "Starting from $p_2=1.5$, Muller's method converges to the double root" | `p_init=[1.3,1.4,1.5]`. Iterates 1.62765, 1.67427, 1.70349, 1.72005, 1.72750, 1.73063, 1.73170, 1.73199, 1.7320430 (script = indep). Error after frame 9's step is 7.8e-6. At 3000 digits the sequence converges (36 iterates, error 3.4e-1381, discriminant ≥ 0 throughout). | confirmed |
| 31 | Case 3 | "Newton's method would converge linearly here" | Double root (row 28). Standard result. | confirmed |
| 32 | Case 3 | "Muller's method converges superlinearly, with order $\approx1.23$ at this double root" | case3b.py at 3000 digits: estimates settle at 1.2338 | confirmed |
| 33 | Case 3 | "(below the $\approx1.84$ it achieves at a simple root)" | Standard result: the root of p³=p²+p+1 is 1.8393 | confirmed |
| 34 | Case 3 alt text | "converging to the double root at p = sqrt(3) starting from p₂ = 1.5" | Row 30 | confirmed |
| 35 | Case 3 wiring | `mullerscc.jl` / `mullerscc.gif` | Matching f and title | confirmed |
| 36 | Counts | Three cases; Case 1 has "eight frames" and Case 2 "nine frames" | GIFs have 8, 9 and 9 frames (manifest and frame folders) | confirmed |
| 37 | Fidelity | Cases correspond to Mathews' Examples 1–3 | Ex 1: same f and start (2.2, 2.1, 2.0). Ex 2: same f and start (0.8, 0.9, 1.0); Mathews' output p3…p10 matches the script's iterates digit for digit. Ex 3: same f; Mathews' Newton start is 1.5, but his Muller start could not be determined (archive images missing). No archive example was dropped. Case 1's departure from Mathews (real part instead of a dropped square root) is disclosed on the page with Mathews' own numbers. | confirmed / Ex 3 start: could not determine |

The page has no separate Description section with method formulas. The only formula it states is Mathews' step (row 16).

---

### 3. Implementation checks

All three scripts use the same `muller_step`. It builds the divided differences δ0, δ1 and d (second divided difference) and b = δ1 + h1·d, the slope at p2. It then sets disc = b² − 4 f2 d and returns p2 − 2f2/E, with E = b ± √disc chosen for the larger magnitude. This is the standard real-arithmetic Muller step: the stable form of the quadratic formula, with the oldest point replaced each iteration.

### `mullersaa.jl` (Case 1)
- **Method:** A Muller variant. When disc < 0, which happens in every frame, it returns p2 − b/(2d). That is the real part of the complex Muller iterate, i.e. the vertex. This is a disclosed variant, not standard Muller. It is named as such in the script comments and on the page.
- **Numbers:** script (float64) beside indep.py (60-digit Vandermonde + polyroots, real part):

  | frame | p2 | next (script) | next (indep) | vertex h (script) | vertex h (indep) |
  |---|---|---|---|---|---|
  | 1 | 2.0 | 1.2873015873016 | 1.2873015873016 | 7.9998e-01 | 7.9998e-01 |
  | 2 | 1.28730 | 1.158087802003537 | 1.158087802003536 | 1.8139e-01 | 1.8139e-01 |
  | 3 | 1.15809 | 1.05520419279069 | 1.05520419279069 | 3.1872e-02 | 3.1872e-02 |
  | 4 | 1.05520 | 1.00999919535373 | 1.00999919535373 | 2.1573e-03 | 2.1573e-03 |
  | 5 | 1.01000 | 1.00168459149086 | 1.00168459149086 | 7.8117e-05 | 7.8117e-05 |
  | 6 | 1.00168 | 1.00010790067738 | 1.00010790067738 | 8.9418e-07 | 8.9418e-07 |
  | 7 | 1.00011 | 1.0000030057271563 | 1.0000030057271222 | 1.7903e-09 | 1.7903e-09 |
  | 8 | 1.000003 | 1.0000000311735213 | 1.0000000311740599 | 5.4319e-13 | 5.4343e-13 |

  The two agree to within float64 rounding near a double root, and the displayed "5.43e-13" holds under both. Order at 3000 digits: 1.3247. The script's comment that a 9th frame would have a height of about 1e-17 is confirmed: indep gives 1.01e-17.
- **Reference values:** The root p = 1 is exact (sympy factorization).
- **Picture:** Main panel shows f, the parabola through (q0,q1,q2), an open circle at (q3, P(q3)) = the vertex, gray q0/q1 and red q2, with the legend label `p₂ = %.10g`. The inset is centred on the vertex with y range (−0.8h, 3h), and its title gives the height h. I checked frames 1–8 on the sheet: the vertex circle sits above the axis line in every inset, titles match the computed h, and the legend p₂ values match the iterates. No clamping.

### `mullersbb.jl` (Case 2)
- **Method:** Standard real Muller. It errors on disc < 0, and that never fires: disc ranges from 14.39 down to 3.13e-9, all positive.
- **Numbers:** script beside indep:

  | frame | next (script) | next (indep) | step |
  |---|---|---|---|
  | 1 | 1.2543159902744359 | 1.2543159902744359 | 2.5432e-01 |
  | 2 | 1.3222993665586782 | 1.3222993665586782 | 6.7983e-02 |
  | 3 | 1.3688966241528713 | 1.3688966241528712 | 4.6597e-02 |
  | 4 | 1.3970591565574766 | 1.3970591565574768 | 2.8163e-02 |
  | 5 | 1.4084129639769241 | 1.408412963976924 | 1.1354e-02 |
  | 6 | 1.4126956654374672 | 1.4126956654374674 | 4.2827e-03 |
  | 7 | 1.4139236819552305 | 1.4139236819552306 | 1.2280e-03 |
  | 8 | 1.4141744432077474 | 1.4141744432077472 | 2.5076e-04 |
  | 9 | 1.4142102425258867 | 1.4142102425258867 | 3.5799e-05 |

  Mathews' archive output (Example 2, p3–p10) matches these to 16 digits. Order at 3000 digits: 1.2338.
- **Reference values:** √2 checked with sympy.
- **Picture:** The window is zoomed per frame and the open circle is at (q3, 0). The inset spans q2 − 0.15s … q3 + 0.8s, and its title is the step q3 − q2. Frames match: titles run 2.54e-01 … 3.58e-05, and the red dot carries the 5-digit p₂ label. Script comments hold: points are within 0.1 of √2 from frame 5 on (frame 5 p0 = 1.3223 is 0.092 away), and the inset step is under 7% of panel width from frame 7 on (frame 7 is 6.3%, frame 6 is 8.4%).

### `mullerscc.jl` (Case 3)
- **Method:** Standard real Muller, the same as `mullersbb.jl`. disc > 0 in all 9 frames (45.12 … 1.65e-7). For context only: continued past the animation in float64, disc turns negative at step 12, when the error is about 2.7e-8 ≈ √eps, the attainable-accuracy floor at a double root. At 60 digits the same happens at step 18, at error about 1e-31. At 3000 digits it stays positive through convergence. So this is a rounding artifact outside the animated range, not a finding.
- **Numbers:** script beside indep:

  | frame | next (script) | next (indep) | step |
  |---|---|---|---|
  | 1 | 1.627646913608958 | 1.6276469136089565 | 1.2765e-01 |
  | 2 | 1.6742682889831824 | 1.6742682889831808 | 4.6621e-02 |
  | 3 | 1.7034875047036455 | 1.7034875047036412 | 2.9219e-02 |
  | 4 | 1.7200472229337476 | 1.7200472229337408 | 1.6560e-02 |
  | 5 | 1.72750110119843 | 1.7275011011984546 | 7.4539e-03 |
  | 6 | 1.7306305638858632 | 1.7306305638856946 | 3.1295e-03 |
  | 7 | 1.7317042934610234 | 1.7317042934613555 | 1.0737e-03 |
  | 8 | 1.7319877986383865 | 1.7319877986375479 | 2.8351e-04 |
  | 9 | 1.732043002751156 | 1.7320430027295643 | 5.5204e-05 |

  The differences (up to 2e-11) are float64 cancellation in f near a double root and are invisible in the 5-digit legend. Order at 3000 digits: 1.2338. All iterates stay below √3.
- **Reference values:** √3 checked with sympy factorization.
- **Picture:** The window is fixed. The parabola is drawn over [min − 0.2, max + 0.2] and clipped at the axes, with gray q0/q1, red q2 and the legend p₂ to 5 digits. Frames 1–5 show the parabola and its crossing clearly, and the legend values match the iterates. Frames 7–9 do not resolve the iteration (F1). Clipping of f and of the parabola at y = 1.5 hides nothing the page discusses.

