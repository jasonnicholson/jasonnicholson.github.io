# Runge-Kutta Method — animation review (round 6)

Page: `pages/numerical-methods/runge-kutta-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I checked every claim in the Animations section, including the alt text and the script header and comments, against values I computed independently. All of them agree at the precision stated.

Two observations that are not findings:

- **The carried-versus-own split depends on how local error is defined.** The Behavior paragraph splits the error after the first upward step into "own truncation error" (m = 12–18) and "error carried from earlier steps, which that step multiplies by 2.9 to 18.6" (m = 20–56). Every number reproduces exactly when the local truncation error is defined the textbook way: the RK4 step taken from the reference value y(t_i), minus y(t_{i+1}). The carried part is then Φ(y_i) − Φ(Y_i). The other common split measures the step's one-step error from the run's own y_i against the exact flow. Under that split about 99% of the error is the step's own for every m from 12 to 56, and the exact flow damps the carried error by a factor of 0.02–0.13. Both splits are valid. The page's split is the standard one, and its numbers under it are right, so this is not a finding. The owner may still want to state the definition in one clause.
- The page has no `## Description` section, although the authoring conventions ask for one. That is missing content, so it is out of scope here. It also means there were no Description formulas to check.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttaaa.jl` | 0 | 12.3 | rungekuttaaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Values marked "computed" come from `indep.py` (Python, independent of the script) unless they say otherwise. Values marked "script" come from `rk_instr.jl`.

| # | Page claim (own words) | Evidence | Verdict |
|---|---|---|---|
| 1 | IVP $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | script l.11, 13–14; frame titles | confirmed |
| 2 | "Each frame is a complete RK4 run with $m$ subintervals ($h=5/m$)" | script l.21–35, 62–63; frame titles "h = 5/m" | confirmed |
| 3 | "the 21 values of Mathews' animation, m = 12, 14, …, 120, 150" | script `ms`; GIF has 21 frames; legacy frames read: 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150 | confirmed |
| 4 | "drawn over a fine-step reference solution" | RK4 with 50 000 steps: y(5) = 0.00811992046486796. mpmath odefun gives 0.00811992046486796 and DOP853 gives 0.00811992046487 | confirmed |
| 5 | "labelled with the computed y(5) and its error" | annotations l.83–84; frames show y(5) and a signed error | confirmed |
| 6 | RK4 uses four slope estimates and a weighted average; $O(h^5)$ local, $O(h^4)$ global for smooth f | script l.28–32. Smooth test $y'=-2ty$: error ratio on halving h = 15.85, 16.00, 16.02, 16.01. On this ODE at fine m the script's `rk4` gives ratios 22.3, 18.8, 17.4, 16.7 (m=150→2400), which tend to 16 | confirmed |
| 7 | f not smooth at y=0; $\partial f/\partial y = -t/(3y^{2/3})$ unbounded | differentiate $1 - t y^{1/3}$ | confirmed |
| 8 | "the coarser runs below evaluate it at negative y" | negative stages in m = 12–52 (see #31) | confirmed |
| 9 | Reference rises from 1 to about 1.4498 near t = 0.88 | computed peak t = 0.883556, y = 1.449767 | confirmed |
| 10 | then decays toward the nullcline $y = 1/t^3$ (where y' = 0) | y' = 0 ⇔ $t y^{1/3}=1$ ⇔ $y=1/t^3$. On (t_peak, 5] y is decreasing and stays above $1/t^3$ (checked on 2000 points); y(5) − 1/125 = 1.2e-4 | confirmed |
| 11 | reference y(5) = 0.0081199 | 0.0081199205 | confirmed |
| 12 | For m = 12 through 52 the curve visibly turns upward before t = 5 | Upward steps after the peak exist for every m from 12 to 56 and none from 60 up. Summed rise is 0.46 (m=12) down to 0.028 (m=52), about 6 px or more in a 1.85-unit, ~400 px axis. Frames for m = 12–52 show the upturn | confirmed |
| 13 | y(5) ≈ 0.588 (m=12), 0.289 (m=20), 0.0377 (m=52) | computed 0.5883471, 0.2891074, 0.0376958 | confirmed |
| 14 | m = 56 turns upward on the last step by 8.1e-4, too little to see, ending at ≈ 0.0099 | last-step rise 8.0526e-4 (the only upward step); y(5) = 0.0098571; 8e-4 ≈ 0.2 px; frame 14 shows no visible rise | confirmed |
| 15 | Error in y(5) falls at every refinement in the sweep | \|err\| strictly decreasing over all 21 m (0.580, 0.460, 0.380, 0.324, 0.281, 0.219, 0.103, 0.100, 0.0754, 0.0617, 0.0524, 0.0457, 0.0296, 1.74e-3, 3.43e-4, 2.77e-5, 6.81e-6, 2.77e-6, 1.42e-6, 5.25e-7, 1.76e-7) | confirmed |
| 16 | 3.4e-4 at m=60, 2.8e-5 at m=70, 6.8e-6 at m=80, 1.8e-7 at m=150 | 3.431e-4, 2.765e-5, 6.805e-6, 1.757e-7 | confirmed |
| 17 | y(5) ≈ 0.0081201 at m = 150 | 0.0081201 | confirmed |
| 18 | $\partial f/\partial y$ along the reference reaches −41.3 at t = 5 | −41.2554. \|f_y\| is monotone increasing on (t_peak, 5], so the maximum is at t = 5 | confirmed |
| 19 | RK4 linear stability limit 2.785 | root of \|R(z)\|=1 on the negative axis: 2.785294 | confirmed |
| 20 | Steps longer than about h = 0.0675 (m ≤ 74; here m = 12 to 70) exceed the limit before t = 5 | h_crit = 2.785294/41.2554 = 0.067513, so 5/h_crit = 74.06. An onset exists for every m from 12 to 70 and for none from 80 up | confirmed |
| 21 | the shaded region in those frames | script l.73–75 vspan [onset, 5]. Shading present in frames for m = 12–70 (e.g. frames 1, 14, 16) and absent from m = 80 up (frame 21) | confirmed |
| 22 | m = 70 onset t ≈ 4.91; m = 12 onset t ≈ 3.10 | computed 4.908 and 3.103; script 4.9083 and 3.1033; frame labels "4.91" and "3.10" | confirmed |
| 23 | For m = 80 to 150, h\|f_y\| along the reference stays below 2.785 up to t = 5 | m = 80: 0.0625 × 41.2554 = 2.578; no onset | confirmed |
| 24 | For m = 12 to 24 the run's own h\|f_y\| at its grid values stays below 2.42 | max over grid: 1.589, 1.316, 1.932, 1.570, 1.996, 2.418 | confirmed |
| 25 | For m = 12 to 18 the upturn begins with one long step that starts before the shaded region (t ≈ 2.92 to 3.33 for m = 12) | first upward step / onset: m=12 [2.917, 3.333] / 3.103; m=14 2.857 / 3.162; m=16 3.125 / 3.219; m=18 3.056 / 3.278 | confirmed |
| 26 | 94 to 100% of the error just after it (0.168 for m = 12) is that step's own truncation error | e_{i+1}(m=12) = 0.16815. Own-LTE share (textbook split, `decomp2.py`): 99.6, 99.9, 93.7, 98.0 % for m = 12, 14, 16, 18 (exact-flow split: 99.4–99.8 %) | confirmed |
| 27 | For m = 20 to 56 the error after the first upward step is mostly carried error, which that step multiplies by 2.9 to 18.6 | Textbook split: carried share 80.0, 98.5, 96.6, 98.4, 99.7, 97.0, 98.3, 98.8, 99.0, 99.0 %; factor [Φ(y_i) − Φ(Y_i)]/e_i = 5.01, 6.93, 2.91, 5.66, 18.57, 3.57, 4.06, 4.24, 4.06, 3.65, so range 2.91–18.57. The opposite split gives a different attribution (see §1 note) | confirmed (under the textbook LTE definition) |
| 28 | For m = 60 and 70 the bound is crossed but the run does not turn upward | onsets 4.666 and 4.908; no upward step after the peak in either | confirmed |
| 29 | Size of upturns depends on how cbrt is taken for y < 0 | see #33 | confirmed |
| 30 | In every run from m = 12 to 52, and in no other, some RK4 stage value falls below 0 (as low as −1.15) | negative stages in m = 12–52 only; minimum −1.1542 (m=12). m = 56 minimum stage +0.0048 | confirmed |
| 31 | first always $y_i+k_3$ (where $k_4$ is evaluated): in the first upward step for m = 12–24 and 36, in the step after it for m = 28, 32, 40–52 | first negative stage is index 3 (y+k3) for all 13 runs. Step of first negative stage vs first upward step: equal for 12,14,16,18,20,24,36; one later for 28,32,40,44,48,52 | confirmed |
| 32 | script takes the real cube root, as Mathews' printed y(5) values show he did; then f = 1 + t\|y\|^{1/3} > 1 | Julia `cbrt` is the real cube root. All 21 of Mathews' printed y(5) values (0.5883471 … 0.0081201, read from legacy frames) equal the script's to all 7 printed digits. With max(y,0) instead, m=12 would print −0.239. For y < 0, cbrt(y) = −\|y\|^{1/3}, so f = 1 + t\|y\|^{1/3} | confirmed |
| 33 | With cbrt(max(y,0)) the summed upward steps after the peak shrink in each of these runs (0.46 → 0 for m = 12, 0.028 → 0.012 for m = 52) | real vs max-variant sum of rises, m = 12…52: .460→0, .365→0, .415→.0013, .350→.042, .325→.013, .243→.023, .127→.023, .091→.019, .069→.022, .057→.020, .049→.013, .043→.012, .02795→.01153. Shrinks in every run | confirmed |
| 34 | y(5) becomes −0.239 (m=12), 0.0054 (m=20), 0.021 (m=52) | −0.23919, 0.00543, 0.02128 | confirmed |
| 35 | The m = 56 run has no negative stage, so its last-step rise is the same either way | min stage +0.0048; rise 8.0526e-4 in both variants | confirmed |
| 36 | Source link `rungekuttaaa.jl`; embed `rungekuttaaa.gif` | both files exist; the GIF is the output of that script (byte-identical regeneration) | confirmed |
| 37 | Alt: gray reference curve peaks near 1.45 at t ≈ 0.88, decays to 0.0081 at t = 5 | #9, #11; reference drawn `:gray70` | confirmed |
| 38 | Alt: m = 12 to 52 visibly turn upward, y(5) = 0.588 for m = 12; at m = 56 too small to see | #12–14 | confirmed |
| 39 | Alt: for m = 12 to 70 a shaded region marks where h·\|∂f/∂y\| on the reference exceeds 2.785 | #21 | confirmed |
| 40 | Alt: runs settle onto the reference as m grows, y(5) = 0.0081201 at m = 150 | #15, #17; frame 21 | confirmed |
| 41 | Script header and comments: "min 0.0081, max 1.4498" for grid values; "stage values reach −1.15"; "reference error far below plotting resolution"; "2.7853" | script: grid min 0.008120, max 1.449751; stage min −1.1542; reference agrees with mpmath to about 1e-17; zlim 2.7852936 | confirmed |
| 42 | Frame annotations: "reference y(5) = 0.0081199"; per-frame y(5), error and onset text | all match the computed values (frames 1, 14, 16 and 21 inspected individually; contact sheet for the rest) | confirmed |

**Fidelity to the legacy archive.** The archive animation is an RK4 run of $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ on $[0,5]$ for the same 21 values of m. Its printed y(5) values all equal the page's, and the page's curves match it frame for frame. The page adds the reference curve, the error and the stability shading. It drops nothing from Mathews' animation, apart from his blank opening frame that shows only the initial point, which does not matter to a reader. There is no fidelity finding.

### 3. Implementation checks: `rungekuttaaa.jl`

1. **It is the method it claims to be.** Lines 26–33 are the classical 4-stage RK4: increments k1…k4 at (t, y), (t+h/2, y+k1/2), (t+h/2, y+k2/2), (t+h, y+k3), with weights 1, 2, 2, 1 over 6. I checked this through behaviour rather than by recalling the tableau. The same stage structure on $y'=-2ty$ shrinks the error by a factor of 16.0 per halving of h (order 4). The script's own `rk4` on this ODE gives ratios that tend to 16 (22.3 → 18.8 → 17.4 → 16.7 for m = 150 → 2400).
2. **The numbers are right.** My independent Python RK4 (`indep.py`) and the instrumented Julia copy agree on all 21 values of y(5) to 7 printed digits: 0.5883471, 0.4685529, 0.3876236, 0.3316264, 0.2891074, 0.2274383, 0.1108585, 0.1082442, 0.0834665, 0.0698482, 0.0604713, 0.0538504, 0.0376958, 0.0098571, 0.0084630, 0.0081476, 0.0081267, 0.0081227, 0.0081213, 0.0081204, 0.0081201. Mathews' printed values are identical, which is an outside confirmation. The stability limit, solved by brentq on \|R(z)\| = 1, is 2.785294; the script gives 2.7852936. The onsets from my 200 001-point reference grid agree with the script's to 3 decimals.
3. **Its reference values are right.** The script's reference is RK4 with 50 000 steps, giving y(5) = 0.00811992046486796. mpmath `odefun` (Taylor series, 30 digits) gives 0.00811992046486796 and SciPy DOP853 gives 0.00811992046487. The exact solution stays positive (y' = 1 > 0 at y = 0), so the reference never meets the cbrt branch issue. The peak is 1.449767 at t = 0.8836 by both the script and DOP853.
4. **The picture shows what was computed.** I inspected frames 1 (m=12), 14 (m=56), 16 (m=70) and 21 (m=150) individually and the rest on the contact sheet. The magenta polyline with markers is the grid (ts, ys) of that run, and the red dot is (5, y_m). The gray band is the 50 000-step reference. The shaded span runs from the computed onset to 5 and appears only when an onset exists. Titles carry m and h = 5/m, and the function in the title is the function in the code. Annotations show y(5), the signed error, the reference y(5) and the onset time, all matching computed values. The y-limits (−0.05, 1.8) contain every grid value of every run (min 0.00812, max 1.44975). Stage values (down to −1.15) are not drawn and the page does not claim they are. No clamping or NaN masking is used. There are 21 frames at 1 fps.

