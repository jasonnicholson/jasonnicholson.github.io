# Runge-Kutta Method — animation review (round 8)

Page: `pages/numerical-methods/runge-kutta-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, in the alt text, in the frames and in the script comments agreed with independent computation at the precision stated.

Non-finding observation (outside the review standard's scope, recorded only for the owner): the page has no `## Description` section, which `.github/agents/animation-page.agent.md` lines 12 and 205 require. The method formulas are instead stated in the Animations introduction, and those were checked below. This is missing content, not an error.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttaaa.jl` | 0 | 13.4 | rungekuttaaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Reference values: mpmath `odefun` (Taylor, 30 digits) gives y(5) = 0.00811992046487; scipy DOP853 (rtol 1e-13) gives 0.008119920465; the script's RK4-50000 reference gives `yex5 = 0.008119920465`.

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| 1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | script l.11-14 | confirmed |
| 2 | Each frame is a complete RK4 run with $m$ subintervals, $h=5/m$ | script l.21-35, 62-63 | confirmed |
| 3 | 21 values of Mathews' animation, m = 12,14,...,120,150 (list) | script l.15. The legacy GIF has 36 frames (blank first frame, then most values shown twice) with 21 distinct y(5) values. They match my RK4 runs for exactly this list, in order (0.5883471, 0.4685529, 0.3876236, 0.3316264, 0.2891074, 0.2274383, 0.1108585, 0.1082442, 0.0834665, 0.0698482, 0.0604713, 0.0538504, 0.0376958, 0.0098571, 0.008463, 0.0081476, 0.0081267, 0.0081227, 0.0081213, 0.0081204, 0.0081201) | confirmed |
| 4 | drawn over a fine-step reference solution | RK4 with 50000 steps, agrees with mpmath to 1e-14 | confirmed |
| 5 | labelled with the computed y(5) and its error | script l.83-84; frames | confirmed |
| 6 | four increments $k_j=h f(\cdot)$, weighted average $(k_1+2k_2+2k_3+k_4)/6$ | script l.28-32 (classical RK4) | confirmed |
| 7 | for smooth f: $O(h^5)$ local, $O(h^4)$ global | standard. Here observed order from m 150 to 300 is 4.48, from 100 to 200 is 4.92 (pre-asymptotic, f not smooth near y=0), which is consistent with the "for smooth f" qualifier | confirmed |
| 8 | $\partial f/\partial y=-t/(3y^{2/3})$, unbounded at y=0 | differentiation | confirmed |
| 9 | coarser runs evaluate f at negative y | negative stage values for m=12..52 (see 27) | confirmed |
| 10 | Case heading: m = 12 to 150 subintervals | script l.15 | confirmed |
| 11 | reference rises from 1 to about 1.4498 near t=0.88 | peak at t=0.883556 (where y'=0), y=1.4497667 | confirmed |
| 12 | then decays toward the nullcline $y=1/t^3$ (where $y'=0$) | y > 1/t^3 for every t after the peak (checked on 5000 points). y(5) - 1/125 = 1.2e-4 | confirmed |
| 13 | reaches y(5)=0.0081199 | 0.0081199205 | confirmed |
| 14 | m=12 through 52 visibly turn upward before t=5 | every run m=12..52 has upward steps after the peak (summed rise 0.46 for m=12 down to 0.028 for m=52, about 6 px at frame scale). The frames show it | confirmed |
| 15 | y(5) ≈ 0.588 (m=12), 0.289 (m=20), 0.0377 (m=52) | 0.5883471, 0.2891074, 0.0376958 | confirmed |
| 16 | m=56 turns upward on the last step only, by 8.1e-4, ends at y(5)≈0.0099 | the only upward step after the peak is step 55 (last), +8.0526e-4. y(5)=0.0098571 | confirmed |
| 17 | error in y(5) falls at every refinement | abs(error) strictly decreasing over all 21 runs, all errors positive | confirmed |
| 18 | errors 3.4e-4 (m=60), 2.8e-5 (70), 6.8e-6 (80), 1.8e-7 (150); y(5)≈0.0081201 at m=150 | 3.431e-4, 2.765e-5, 6.805e-6, 1.757e-7; 0.0081201 | confirmed |
| 19 | $\partial f/\partial y$ along the reference reaches -41.3 at t=5 | -41.2554. abs(fy) is increasing for t>1, so t=5 is the maximum | confirmed |
| 20 | RK4 linear stability limit 2.785 | real root of abs(R(z))=1: z=-2.785294 (script 2.78529356) | confirmed |
| 21 | threshold about h=0.0675 (m≤74; here m=12 to 70) | h_crit = 2.785294/41.2554 = 0.067513, i.e. m = 74.06. m=74 has onset at t=4.9987, m=75 has none | confirmed |
| 22 | shaded region in those frames (m=12..70) | frames m=12..70 shaded, m=80..150 not | confirmed |
| 23 | m=70: from t≈4.91; m=12: starts at t≈3.10 | onsets 4.9082 and 3.1032 | confirmed |
| 24 | m=80..150 stay below 2.785 along the reference | onset none | confirmed |
| 25 | for m=12..24 the run's own h·abs(fy) at grid values stays below 2.42 | maxima 1.589, 1.316, 1.932, 1.570, 1.996, 2.418 | confirmed |
| 26a | m=12..18: upturn begins with one long step that starts before the shaded region (t≈2.92 to 3.33 for m=12) | first upward steps start at t = 2.917, 2.857, 3.125 and 3.056, before onsets 3.103, 3.162, 3.219 and 3.278. For m=12 the step is [2.917, 3.333] | confirmed |
| 26b | 94 to 100% of the error just after it (0.168 for m=12) comes from that step started from the exact y(t_i) | 99.6, 99.9, 93.7, 98.0%; error after = 0.1681 | confirmed |
| 26c | m=20..56: the first upward step started from the exact y(t_i) gives 0.3 to 20% of the error after it | 20.0, 1.5, 3.4, 1.6, 0.3, 3.0, 1.7, 1.2, 1.0, 1.0% | confirmed |
| 26d | RK4's step map multiplies the existing error by 2.9 to 18.6 | 5.01, 6.93, 2.91, 5.66, 18.57, 3.57, 4.06, 4.24, 4.06, 3.65 | confirmed |
| 26e | exact flow shrinks it to 2 to 6% | 6.1, 4.4, 4.0, 2.8, 2.3, 2.8, 2.7, 2.7, 2.7, 2.8% | confirmed |
| 26f | m=60 and 70: bound crossed but no upturn | no upward step after the peak | confirmed |
| 27 | negative RK4 stage in every run m=12..52 and in no other, as low as -1.15, first always $y_i+k_3$ | minimum stages -1.154 (m=12) to -0.009 (m=52). m=56 minimum is +0.005. The first negative stage is always s3 | confirmed |
| 28 | the first negative stage is in the first upward step for m=12..24 and 36, and in the step after it for 28, 32 and 40..52 | (first-up, first-neg) step indices: 12 (7,7), 14 (8,8), 16 (10,10), 18 (11,11), 20 (13,13), 24 (17,17), 28 (21,22), 32 (26,27), 36 (31,31), 40 (35,36), 44 (40,41), 48 (45,46), 52 (50,51) | confirmed |
| 29 | script takes the real cube root, as Mathews' printed y(5) values show he did; then $f=1+t\lvert y\rvert^{1/3}>1$ | `cbrt` is the real cube root. The legacy values match the real-root runs to 7 digits, while the clipped variant gives a different value (for example -0.2392 at m=12) | confirmed |
| 30 | with $\sqrt[3]{\max(y,0)}$ the summed upward steps shrink in each run (0.46 to 0 for m=12, 0.028 to 0.012 for m=52) | they shrink in all 13 runs. m=12: 0.4597 to 0.0000. m=52: 0.02804 to 0.011533 | confirmed |
| 31 | clipped y(5): -0.239 (m=12), 0.0054 (m=20), 0.021 (m=52) | -0.2392, 0.0054, 0.0213 | confirmed |
| 32 | m=56 has no negative stage, so its last-step rise is the same either way | both variants give 0.0098571 and a rise of 0.0008 | confirmed |
| 33 | link `[Julia source](rungekuttaaa.jl)` and embed `rungekuttaaa.gif` | both files exist, and the GIF is this script's output (byte-identical) | confirmed |
| 34 | Alt text: gray reference peaks near 1.45 at t≈0.88, decays to 0.0081 at t=5; m=12..52 visibly turn upward; 0.588 at m=12; m=56 upturn too small to see; shading for m=12..70; 0.0081201 at m=150 | items 11-16, 18, 22. The m=56 frame shows no visible rise | confirmed |
| 35 | Script comment l.18: grid values in (0.0081, 1.4498), stages reach -1.15 | grid minimum 0.0081201, maximum 1.4498 (m=90), stage minimum -1.154. All drawn points are inside ylims (-0.05, 1.8) | confirmed |
| 36 | Frame title/legend/annotations | the title function matches `f`, the "h = 5/m" label is right, the legend text matches the plotted quantity, and the onset text in each frame matches the computed onset | confirmed |

### 3. Implementation checks — `rungekuttaaa.jl`

- **Method:** classical 4-stage RK4 (l.28-32), with stages at t, t+h/2, t+h/2 and t+h and weights 1,2,2,1 over 6. It is the method named on the page, with no variant.
- **Numbers:** the instrumented copy (`inst.jl`) and the independent Python RK4 (`indep.py`) agree to every printed digit for all 21 runs. For example, at m=12 the script gives 0.5883470624827951 and Python gives 0.5883471. At m=150 the script gives 0.00812009618961509 and Python gives 0.0081201. All 21 values also match Mathews' printed y(5) to 7 digits. The order check from m 150 to 300 gives a ratio of 22.3, so p is about 4.5 and approaching 4.
- **Reference values:** the script's `yex5` (0.008119920465) matches mpmath Taylor (0.00811992046487) and DOP853 to 12 digits, which is far more accurate than the smallest error shown (1.8e-7). The script's stability limit 2.78529356 matches my root of R(z)=1 (2.785294). Its onset times match my dense-reference onsets to 4 digits (e.g. 3.1033 vs 3.1032, 4.9083 vs 4.9082).
- **Picture:** frames 1, 14, 16, 17 and 21 were inspected, and the full contact sheet was viewed. The shaded span runs [onset, 5] and is present exactly for m≤70. The magenta curve is the run's grid values and the red dot is (5, y_m). The reference is the gray curve. Annotations show y(5), the signed error and the reference y(5), each formatted consistently with the computed values. No clamping or masking is used, and every grid value lies inside the axis limits.

