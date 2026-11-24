# Runge-Kutta Method — animation review (round 9)

Page: `pages/numerical-methods/runge-kutta-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim in the Animations section, the alt text, the wiring, and the script's own comments agrees with independent computation at the precision stated. No fidelity departures: the IVP, interval, the 21 values of m and all 21 printed y(5) values match Mathews' animation exactly.

(Not a finding, noted for completeness: the Behavior paragraph is far longer than the conventions file's "1–2 sentences" guideline; this is style, not correctness.)



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttaaa.jl` | 0 | 14.2 | rungekuttaaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `rungekuttaaa.gif` | 21 | byte-identical | rungekuttaaa |

### Page references

- Scripts linked: `rungekuttaaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Sources of evidence: P = `indep.py`/`decomp.py`/`extra.py` (Python, independent); J = `instr.jl` (script's own routine); F = committed frames; M = Mathews archive.

### Introduction / method description (line 12)

| # | Claim (page words) | Evidence | Verdict |
|---|---|---|---|
| 1 | IVP $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | script l.11–14; F titles; M frame titles | confirmed |
| 2 | "Each frame is a complete RK4 run with $m$ subintervals ($h=5/m$)" | script l.21–35, 62–63; F titles "h = 5/m" | confirmed |
| 3 | "the 21 values of Mathews' animation, m = 12, 14, …, 150" | script l.15 (21 values); M frame labels: 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150 | confirmed |
| 4 | "drawn over a fine-step reference solution and labelled with the computed y(5) and its error" | script l.38, 76, 83–84; F | confirmed |
| 5 | RK4 computes $k_j=h f(\cdot)$, adds $(k_1+2k_2+2k_3+k_4)/6$ to $y_i$ | script l.28–32 (classical RK4, nodes 0, h/2, h/2, h) | confirmed |
| 6 | smooth f: $O(h^5)$ local, $O(h^4)$ global | J: errors at m=150/300/600/1200: 1.757e-7, 7.888e-9, 4.191e-10, 2.409e-11; ratios 22.3, 18.8, 17.4 → 16 | confirmed |
| 7 | f not smooth at y=0; $\partial f/\partial y=-t/(3y^{2/3})$ unbounded | analytic (t>0) | confirmed |
| 8 | "the coarser runs below evaluate it at negative y" | P: negative stage values in m=12..52 | confirmed |

### Case 1 heading and Behavior (lines 16, 18)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 9 | Heading: RK4 sweep, same IVP, m = 12 to 150 | script | confirmed |
| 10 | Reference rises to "about 1.4498 near t=0.88" | P (DOP853): max 1.449767 at t=0.88356; J: 1.449767 at 0.8836 | confirmed |
| 11 | decays toward nullcline $y=1/t^3$ (where y'=0) | y'=0 ⇔ y=t⁻³; P: y(4)=0.016236 vs 0.015625, y(5)=0.008120 vs 0.008 | confirmed |
| 12 | reference y(5)=0.0081199 | mpmath 0.00811992046486796; J yex5 0.008119920464868 | confirmed |
| 13 | m=12 through 52 visibly turn upward before t=5 | P: first post-peak upward step exists for all m=12..52, summed rises 0.46…0.028; F frames 1–13 show it (m=52 small but visible) | confirmed |
| 14 | y(5) ≈ 0.588 (m=12), 0.289 (m=20), 0.0377 (m=52) | P/J: 0.5883471, 0.2891074, 0.0376958 | confirmed |
| 15 | m=56 turns upward on last step only, by 8.1e-4, too small to see; y(5)≈0.0099 | P: only upward step i=55 (t 4.911→5), Δy=8.05e-4; y(5)=0.0098571; F frame 14 no visible rise | confirmed |
| 16 | error in y(5) falls at every refinement | P: |err| strictly decreasing over all 21 m | confirmed |
| 17 | errors 3.4e-4 (m=60), 2.8e-5 (70), 6.8e-6 (80), 1.8e-7 (150); y(5)≈0.0081201 at m=150 | P/J: 3.43e-4, 2.76e-5, 6.80e-6, 1.76e-7; 0.0081201 | confirmed |
| 18 | $\partial f/\partial y$ along reference reaches −41.3 at t=5 | P: −41.255 (max |·| on [0,5] is at t=5) | confirmed |
| 19 | stability bound h≈0.0675, m≤74; here m=12 to 70 | P: zlim/41.255 = 0.067513; 5/h* = 74.06 | confirmed |
| 20 | RK4 linear stability limit 2.785 | P: root of R(z)=1 on (−3,−2): 2.785294; J zlim 2.785294 | confirmed |
| 21 | shaded region in those frames (m=12..70) | F: frames 1–16 shaded, 17–21 not | confirmed |
| 22 | m=70 onset t≈4.91; m=12 onset t≈3.10 | P: 4.908, 3.103; J same | confirmed |
| 23 | m=80..150 stay below 2.785 to t=5 | P/J: no onset | confirmed |
| 24 | m=12..24 run's own h|∂f/∂y| at grid values < 2.42 | P: max 1.589, 1.316, 1.932, 1.570, 1.996, 2.418 | confirmed |
| 25 | m=12..18 upturn begins with one step starting before shaded region (m=12: t≈2.92→3.33) | P: first up steps start 2.917, 2.857, 3.125, 3.056 vs onsets 3.103, 3.162, 3.219, 3.278; m=12 step 2.917→3.333 | confirmed |
| 26 | 94–100% of the error after that step is the step's own local error from exact y(t_i); m=12 error 0.168 | decomp.py: 99.63%, 99.91%, 93.71%, 97.99%; e_{i+1}(m=12)=0.16815 | confirmed |
| 27 | m=20..56: local part 0.3–20% | decomp.py: 19.98, 1.51, 3.36, 1.56, 0.32, 3.02, 1.73, 1.17, 0.99, 1.02 % | confirmed |
| 28 | RK4 step map multiplies the existing error by 2.9–18.6 | decomp.py secant ratios: 5.01, 6.93, 2.91, 5.66, 18.57, 3.57, 4.06, 4.24, 4.06, 3.65 | confirmed |
| 29 | exact flow over that step would shrink it to 2–6% | decomp.py: 6.09, 4.40, 3.98, 2.79, 2.32, 2.82, 2.67, 2.65, 2.71, 2.82 % | confirmed |
| 30 | m=60 and 70: bound crossed but no upward turn | P: no post-peak upward step | confirmed |
| 31 | negative stage in every run m=12..52 and no other; as low as −1.15 | P: counts 8,9,8,9,9,9,7,5,5,4,3,2,1 for m=12..52, 0 for m≥56; min −1.15419 (m=12) | confirmed |
| 32 | first negative stage always $y_i+k_3$; in the first upward step for m=12–24 and 36, the step after for 28, 32, 40–52 | P: first-negative index = first-up index for 12,14,16,18,20,24,36; = first-up+1 for 28,32,40,44,48,52; stage always y+k3 | confirmed |
| 33 | script uses real cube root, "as Mathews' printed y(5) values show he did" | all 21 Mathews y(5) (M crops) equal P real-cbrt values to 7 digits; clipped variant gives e.g. −0.239 at m=12 | confirmed |
| 34 | for y<0, $f=1+t|y|^{1/3}>1$ | analytic | confirmed |
| 35 | with cbrt(max(y,0)) the summed post-peak rises shrink in each run (0.46→0 for m=12; 0.028→0.012 for m=52) | P: all 13 runs shrink; m=12 0.459657→0; m=52 0.027950→0.011533 | confirmed |
| 36 | clipped y(5): −0.239 (m=12), 0.0054 (m=20), 0.021 (m=52) | P: −0.239189, 0.00543, 0.021278 | confirmed |
| 37 | m=56 has no negative stage, so its last-step rise is the same either way | P: 0 negative stages; clipped rise 0.0008 = unclipped | confirmed |

### Wiring and alt text (lines 20, 22)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 38 | "[Julia source](rungekuttaaa.jl)" is this case's script | file exists, produces `rungekuttaaa.gif` | confirmed |
| 39 | embed `rungekuttaaa.gif` is this case | manifest: byte-identical to regen | confirmed |
| 40 | alt: gray reference peaks near 1.45 at t≈0.88, decays to 0.0081 | P, F | confirmed |
| 41 | alt: m=12..52 visibly turns upward; y(5)=0.588 at m=12; m=56 too small to see | P, F | confirmed |
| 42 | alt: m=12..70 shaded region where h|∂f/∂y| on reference > 2.785 | F, P | confirmed |
| 43 | alt: y(5)=0.0081201 at m=150 | P/J, F frame 21 | confirmed |
| 44 | Page linked from section index | `pages/numerical-methods/index.qmd` l.116 | confirmed |

### Script comments

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 45 | l.18 every grid value of every run in (min 0.0081, max 1.4498); stages reach −1.15 | P: global grid min 0.0081201, max 1.449751; stage min −1.1542 | confirmed |
| 46 | l.37 reference error far below plotting resolution | J yex5 vs mpmath differ ~1e-17 | confirmed |
| 47 | l.51 zlim 2.7853 | P 2.785294 | confirmed |

### 3. Implementation checks — `rungekuttaaa.jl`

**Is the method it claims.** Classical four-stage RK4 (l.28–32): k1 at (t,y), k2 and k3 at (t+h/2, y+k1/2 / y+k2/2), k4 at (t+h, y+k3), weights 1,2,2,1 /6. Not a variant. f uses Julia `cbrt` (real cube root), which matches Mathews' outputs.

**Numbers right.** Script's y(5) for all 21 m (J) equal the independent Python RK4 (P) to every printed digit and equal Mathews' printed values to 7 decimals: e.g. m=12 0.5883471 / 0.5883471 / 0.5883471; m=48 0.0538504 ×3; m=150 0.0081201 ×3. Order check with the script's routine: error ratios under doubling 22.3, 18.8, 17.4 approaching 16 (order 4). `stab_limit` bisection gives 2.785294, matching an independent Brent root of R(z)=1 (2.785293563). Onset times (J) match P to 3 decimals for all 16 shaded runs.

**Reference right.** RK4 with 50 000 steps: y(5)=0.008119920464868 vs mpmath 30-digit 0.00811992046486796 and DOP853 0.0081199205; peak 1.449767 at t≈0.8836 in both. Error far below any displayed digit (error labels go down to 1.8e-7).

**Picture shows what was computed.** Inspected frames 1 (m=12), 13 (m=52), 14 (m=56), 16 (m=70) and the contact sheet (m=12…150). Magenta polyline through the grid values, red dot at (5, y_m), gray reference; shaded span [onset, 5] only for m≤70; annotations show y(5), signed error, reference y(5) and the onset text with values matching J. Title function matches code. ylims (−0.05, 1.8) contain every grid value of every run (stages are not drawn), so nothing is clamped. 21 frames, one per m, in the stated order.

