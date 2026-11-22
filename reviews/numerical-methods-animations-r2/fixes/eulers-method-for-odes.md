# Fix record: eulers-method-for-odes

Scratch folder (all evidence scripts re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/eulers-method-for-odes/fix/` (`$FIX` below).

- `check.py`: independent Python Euler and midpoint; compares round(y(5), 7) with each of Mathews' 41 printed values; reproduces the Example 12 table.
- `analyze.py`, `verify.py`, `tails.py`: per-m statistics behind every behaviour sentence.
- `instr.jl`: runs the page scripts' own computations (everything before the animation block) and prints the per-m values.
- `labels.jl`, `gifdelays.py`: legacy label strips and frame delays (copied from the RK fixer).

## Findings

### F1 — Misleading — fixed
- **Reproduced.**
  - Archive `Euler'sMethodMod_gr_42.gif` (viewed): the `MEuler` subroutine is `Y[[j+1]] = Y[[j]] + h f[T[[j]] + h/2, Y[[j]] + h/2 f[T[[j]], Y[[j]]]]`, which is the explicit midpoint method.
  - Example 12 table `gr_255.gif` (viewed), with h = 0.125 and 41 points, ends at 0.0761463. `check.py` midpoint n = 40 gives 1.4419349, 0.8584792, 0.0913999, 0.0189838 and 0.0761463 at t = 1…5, matching the table's 1.44193, 0.858479, 0.0913999, 0.0189838 and 0.0761463.
  - All 21 `MEuleraa.gif` labels match the midpoint method (see F2). The old script was Heun, the trapezoidal predictor-corrector: its lines 115–118 averaged k1 at t_i and k2 at t_{i+1}.
- **Change (R2-D).**
  - `eulersmethodbb.jl` now runs `ys[i+1] = ys[i] + h*f(ts[i] + h/2, ys[i] + (h/2)*f(ts[i], ys[i]))`. The GIF title is "Modified Euler (midpoint) for y' = 1 - t·y^(1/3), y(0) = 1" and the legend label is "modified Euler, m = $m".
  - `index.qmd` Description: the "modified Euler (Heun) … averages endpoint slopes" sentence is replaced by the midpoint formula, with "takes a half Euler step to the middle of the step and uses the slope there … global accuracy O(h²)".
  - Case 2 heading: now "Modified Euler (midpoint) step-refinement sweep, same IVP, m = 12 to 150 subintervals".
  - The Case 2 Behavior paragraph and alt text are rewritten from the new runs.
  - The "Examples 11-12 reconstruction" claim is gone. The new legacy note says the m = 40 frames are the runs of Examples 11 and 12, which is checked.
- **Check.**
  - `instr.jl` on the page script reproduces all 21 Mathews values; its y(5) for m = 40 is 0.0761462774.
  - The script and the independent Python agree to 10 digits for every m. Compare `instr.jl` output with `check.py` and `analyze.py`.
  - Order: the midpoint method's max error at n = 200/400/800/1600 is 8.662e-5, 2.068e-5, 5.052e-6 and 1.249e-6, with ratios 4.189, 4.093 and 4.046, so it is O(h²) (`verify.py`).

### F2 — Misleading — fixed
- **Reproduced.**
  - `ls` shows `a2001/Animations/OrdinaryDE/Euler1/Euleraa.gif` (137738 B) and `MEuler1/MEuleraa.gif` (148614 B).
  - `giftools.jl` extracts 30 and 32 frames. Every frame has a 100 cs delay (`gifdelays.py`).
  - Distinct frames, from `frames.md5`:
    - Euler: 1–3 blank, 4–16 even-numbered frames held for 2 frames each, then 18–30 one frame each, giving 20 values of m.
    - MEuler: 1–3 blank, 4–18 even-numbered frames held for 2 frames each, then 20–32, giving 21 values of m.
  - The label strips (crop y 335–445, `eul_a/b.png` and `me_a/b.png`) were read at full size:
    - Euler: m = 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150. The review's list of 9 came from the contact sheet only.
    - MEuler: m = 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150.
  - `check.py` matches all 41 printed y(5) values at 7 decimals. Euler: 1.7774834, 1.0252058, 0.7223784, 0.5522923, 0.3907263, −0.002737, −0.0174406, 0.0152568, 0.0080988, 0.0081157, 0.0081157, 0.0081163, 0.0081167, 0.0081171, 0.0081174, 0.0081176, 0.0081178, 0.0081179, 0.0081181, 0.0081182.
  - Mathews' Euler m = 55 and m = 60 both print 0.0081157. That is correct, not a typo: the runs give 0.0081157259 and 0.0081156970.
- **Change (R2-A, R2-B).**
  - Both scripts are rewritten as RK-pattern step-refinement sweeps: one complete run per frame, Mathews' m list, the gray RK4 reference with 50 000 steps, magenta run with node markers, a red dot at (5, y_m), and a light-red `vspan` from the onset to T where h·|∂f/∂y| > 2. The text block shows y(5) to 7 decimals, the error (%+.1e), the reference y(5), and the onset or "< 2 up to t = 5". fps = 1.
  - Departures from the RK layout, because coarse Euler runs leave RK's window:
    - ylims are (−0.55, 1.9), the same for both cases. Every value of every run is inside: Euler min −0.46237 and max 1.77748 at m = 10; midpoint max 1.44972. The scripts `error()` if a run ever leaves the window, so nothing is clamped.
    - The legend is at bottom-left and the text block at x = 0.05, y = 0.62/0.50/0.38/0.27, the region empty for every run. At top-right the legend would have hidden Euler m = 10's y(5) = 1.777, and the RK text position is crossed by coarse runs.
  - The stale "missing" note is replaced. The Animations intro is rewritten to describe the sweep, and both Case headings, Behavior paragraphs and alt texts are rewritten.
- **Check.** Frames viewed at full size, with the following checks.
  - aa: frames 1 (m = 10), 6 (m = 35), 7 (m = 40), 8 (m = 45) and 20 (m = 150).
  - bb: frames 1 (m = 12), 3 (m = 16), 7 (m = 28), 15 (m = 60), 16 (m = 70) and 21 (m = 150).
  - bb tail crops: m = 32, 40, 48 and 56 (`mid_tails.png`).
  - The titles show the correct m and h = 5/m. Labels match `instr.jl` (m = 35: "y(5) = -0.0027370, error = -1.1e-02, … from t ≈ 3.54"). The text never overlaps a run and nothing is clipped.
  - The visibility statements match what the frames show: m = 45 shows no oscillation; midpoint m = 60 shows a barely visible tick; m = 70 shows none.

## Ledger of changed text

Reference values used throughout: DOP853 (rtol 1e-13) gives y(5) = 0.008119920464867971, and the script reference (RK4 with 50 000 steps) gives 0.008119920465.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Description | Mathews' modified Euler = explicit midpoint method, formula $y_{n+1}=y_n+hf(t_n+h/2, y_n+\frac h2 f(t_n,y_n))$ | archive gr_42 (viewed); `check.py` reproduces 21/21 MEuler labels + Example 12 table | yes |
| Description | "half Euler step to the middle of the step and uses the slope there" | is the formula | yes |
| Description | global accuracy O(h²) | `verify.py`: midpoint max err ratios 4.189/4.093/4.046 under halving | yes |
| Intro | each frame a complete run with m subintervals, h = 5/m, Mathews' m values | scripts' `ms` = legacy label strips | yes |
| Intro | gray reference = fixed-step RK4 with 50 000 steps | script `rk4(50_000)`; yex5 0.008119920465 vs DOP853 0.0081199204649 | yes |
| Intro | labelled with y(5) and its error; light red band where h·\|∂f/∂y\| exceeds the stability limit | script annotate!/vspan!; frames viewed | yes |
| Legacy note | both GIFs are in the archive, sweep m the same way | `ls`, `giftools.jl`, label strips | yes |
| Legacy note | every printed y(5) agrees with the runs when rounded to 7 decimals | `check.py`: 41/41 MATCH (−0.002737 and 0.008372 printed without trailing 0) | yes |
| Legacy note | m = 40 frames are the runs of Examples 11 and 12 | gr_229 (viewed): Example 11 `n = 40`, Euler on [0, 5]; gr_255 table h = 0.125 ends 0.0761463 = midpoint m = 40 | superseded (see Round 2 after check) |
| Case 1 heading | Forward Euler step-refinement sweep, m = 10 to 150 | `ms` | yes |
| Case 1 | 20 values m = 10, 15, …, 150 (listed) | `ms` (20 entries) | yes |
| Case 1 | reference peak about 1.4498 near t = 0.88 | `verify.py`: 1.44977 at t = 0.8836 | yes |
| Case 1 | decays toward nullcline y = 1/t³ (y' = 0) | 1 − t·y^{1/3} = 0 ⇔ y = t⁻³; y·t³ = 6.88, 2.43, 1.04, 1.015 at t = 2, 3, 4, 5; exact decreasing after peak: True | yes |
| Case 1 | exact y(5) = 0.0081199 | DOP853 0.0081199205 | yes |
| Case 1 | m = 10 to 40 zig-zag in the tail and dip below zero | `verify.py` ymin: −0.462, −0.170, −0.132, −0.116, −0.032, −0.045, −0.017 (m = 45: +0.00674); direction changes after peak 5, 7, 9, 11, 6, 6 for m = 15–40; m = 10 tail from t = 2: 1.235, 0.662, 0.073, −0.053, 1.106, −0.462, 1.777 (3 changes); frames 1, 6, 7 viewed | yes |
| Case 1 | exact solution stays positive | exact min on [0, 5] = 0.0081199 at t = 5 | yes |
| Case 1 | y(5) ≈ 1.777 (m = 10), 0.391 (m = 30), −0.0174 (m = 40) | 1.7774834, 0.3907263, −0.0174406 | yes |
| Case 1 | m = 40 is Example 11 | gr_229 `n = 40` | superseded (see Round 2 after check) |
| Case 1 | m = 45: last steps still alternate, by less than 0.009, too little to see | tail …0.00978, 0.01000, 0.00674, 0.01526 (3 changes, largest move 0.0085); frame 8 viewed: no visible oscillation | yes |
| Case 1 | from m = 50 on runs decrease steadily after their peak | direction changes after peak = 0 for m = 50…150 | yes |
| Case 1 | from m = 60 the error in y(5) falls at every refinement | \|e5\| 4.223e-6, 3.621e-6, 3.179e-6, 2.834e-6, 2.556e-6, 2.328e-6, 2.137e-6, 1.975e-6, 1.836e-6, 1.715e-6 (m = 55 → 60 rises 4.195e-6 → 4.223e-6, hence "from m = 60") | yes |
| Case 1 | roughly halving when m doubles, first order | 60 → 120: 4.223/2.137 = 1.976; 70 → 140: 3.621/1.836 = 1.972 | yes |
| Case 1 | −4.2e-6 (m = 60), −2.1e-6 (m = 120), −1.7e-6 (m = 150), y(5) ≈ 0.0081182 | −4.223e-6, −2.137e-6, −1.715e-6; 0.0081182053 | yes |
| Case 1 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | fy(5) = −41.2554; \|fy\| increasing on [1, 5]: True, max at t = 5 | yes |
| Case 1 | steps longer than about h = 0.0485 (m ≤ 103; here m = 10 to 100) exceed limit 2 before t = 5 | h* = 2/41.2554 = 0.04848; 5/103 = 0.04854 > h*, 5/104 = 0.04808 < h*; `instr.jl` onset exists for m ≤ 100 in sweep, none for m ≥ 110 | yes |
| Case 1 | Euler stability limit 2 | \|1+z\| ≤ 1 ⇔ −2 ≤ z ≤ 0 for real z | yes |
| Case 1 | each step multiplies inherited error by 1 + h ∂f/∂y < −1 (amplifying, alternating sign) | e_{k+1} = (1 + hJ)e_k + local error; h\|J\| > 2 with J < 0 ⇔ 1 + hJ < −1 | yes |
| Case 1 | m = 10: onset t ≈ 2.92 | `instr.jl` 2.9228; Python 2.923 | yes |
| Case 1 | m = 10 to 45: error at t = 5 larger than just before onset | ratios 6.86, 41.7, 38.1, 24.5, 1310, 20.9, 395, 88.5 | yes |
| Case 1 | m = 50 to 100: onset from t ≈ 3.95 (m = 50) to t ≈ 4.95 (m = 100), increasing | 3.9503, 4.0732, 4.1893, 4.4043, 4.6004, 4.7813, 4.9495 | yes |
| Case 1 | m = 50–100: runs decrease steadily, error at t = 5 smaller than just before onset | direction changes 0; ratios 0.452, 0.126, 0.203, 0.303, 0.454, 0.678, 0.842 | yes |
| Case 1 | m = 110 to 150: below 2 up to t = 5 | onset none; 5/110·41.2554 = 1.875 < 2 | yes |
| Case 1 alt | peaks near 1.45 at t ≈ 0.88; decays to 0.0081 | 1.44977 at 0.8836; 0.0081199 | yes |
| Case 1 alt | m = 10–40 zig-zag, below zero; y(5) = 1.777 for m = 10; shaded for m = 10–100; m ≥ 50 decreases steadily after peak; y(5) = 0.0081182 at m = 150 | as above | yes |
| GIF aa title | "Euler's method for y' = 1 - t·y^(1/3), y(0) = 1 / m = $m subintervals, h = 5/$m" | script f and loop variable; frames viewed | yes |
| GIF aa labels | y(5) %.7f, error %+.1e, reference y(5), onset %.2f / "< 2 up to t = 5"; legend "h·\|∂f/∂y\| > 2" | values = `instr.jl`; zlim = 2 | yes |
| Case 2 heading | Modified Euler (midpoint) step-refinement sweep, m = 12 to 150 | `ms` | yes |
| Case 2 | 21 values listed; same reference as Case 1 | `ms` (21 entries); identical `rk4(50_000)` code | yes |
| Case 2 | m = 12 to 20: tail zig-zags | direction changes after peak 4, 4, 3, 5, 5; m = 12 tail from t = 2.5: 0.389, 0.128, 0.140, 0.897, 0.149, 1.420, 0.196; frames 1, 3 viewed | yes |
| Case 2 | m = 24 to 60 turn upward before t = 5 | minimum before t = 5 (t_min 3.54…4.67) with positive rise after it, for every m in 24–60 | yes |
| Case 2 | rise from minimum 0.57 (m = 24), 0.057 (m = 40), 0.015 (m = 60), "barely visible" | 0.5693, 0.0572, 0.0150; frame 15 viewed (tick of about 2–3 px) | yes |
| Case 2 | ending at y(5) ≈ 0.613, 0.0761, 0.0259 (Example 12 aside: see Round 2 after check) | 0.6126681, 0.0761463, 0.0259429 | yes |
| Case 2 | m = 70 upturn only 0.0008, too small to see | 0.000756; frame 16 viewed | yes |
| Case 2 | from m = 80 runs decrease steadily after peak | direction changes 0 for m = 80, 90, 100, 120, 150 | yes |
| Case 2 | from m = 16 error in y(5) falls at every refinement | \|e5\| 1.110, 0.945, 0.807, 0.605, 0.376, 0.127, 0.0890, 0.0680, 0.0548, 0.0439, 0.0350, 0.0285, 0.0178, 2.02e-3, 2.52e-4, 5.40e-5, 1.86e-5, 5.14e-6, 1.82e-6 (14 → 16 rises) | yes |
| Case 2 | 2.5e-4 at m = 80; 1.8e-6 at m = 150, y(5) ≈ 0.0081217 | 2.520e-4; 1.818e-6; 0.0081217390 | yes |
| Case 2 | amplification factor 1 + z + z²/2 has \|·\| ≤ 1 on the negative real axis exactly for −2 ≤ z ≤ 0; limit 2 = Euler's | R ≥ 1/2 for all real z (min at z = −1), R(0) = R(−2) = 1, R < 1 between, > 1 outside; numeric min 0.5 | yes |
| Case 2 | m ≤ 103 (here 12 to 100) exceed 2 before t = 5 | same h* = 0.04848; onset for m = 101, 102, 103 at 4.966, 4.982, 4.998; none at 104 | yes |
| Case 2 | onset t ≈ 2.99 (m = 12) to t ≈ 4.95 (m = 100) | 2.9869, 4.9495 | yes |
| Case 2 | for each of these m error at t = 5 larger than just before onset | ratios m = 12…100: 40.5, 428, 1050, 79.2, 122, 67.1, 46.4, 21.4, 23.9, 35.7, 57.4, 90.3, 136, 193, 179, 42.6, 8.4, 2.45, 1.34 | yes |
| Case 2 | m = 120, 150 below 2 up to t = 5 | onset none | yes |
| Case 2 alt | m = 12–20 zig-zag; 24–60 upward; y(5) = 0.0761 at m = 40; shaded m = 12–100; m ≥ 80 decreasing; y(5) = 0.0081217 at m = 150 | as above | yes |
| GIF bb title/labels | "Modified Euler (midpoint) for y' = …", same labels | script; frames viewed | yes |
| Script comments | ylims comments (Euler min −0.4624, max 1.7775; midpoint min 0.0081, max 1.4497) | `instr.jl` ymin/ymax | yes |

## Scripts and GIFs
- Scripts changed: `eulersmethodaa.jl` and `eulersmethodbb.jl`, both rewritten as m-sweeps. Package use is still Plots only, plus Printf from the standard library, and the `@__DIR__` output paths are kept.
- GIFs regenerated in place with `julia eulersmethodaa.jl` and `julia eulersmethodbb.jl` (about 13 s each). They have 20 and 21 frames respectively, all distinct by framemd5, each lasting 100 cs.
- Frames viewed at full size: aa 1, 6, 7, 8, 20; bb 1, 3, 7, 15, 16, 21, plus tail crops of bb 8, 10, 12, 14. Checks are listed under F2.
- `git status --short -- pages/numerical-methods/eulers-method-for-odes` shows `M` on `eulersmethodaa.gif`, `eulersmethodaa.jl`, `eulersmethodbb.gif`, `eulersmethodbb.jl` and `index.qmd`, and nothing else.

## Legacy archive
- Consulted.
  - `n2003/Euler'sMethodMod.html`, stripped to text. Examples 11 and 12 are "Various Scenarios and Animations": Euler and Modified Euler for the same IVP.
  - Images viewed: `gr_42`, the MEuler subroutine (midpoint); `gr_229`, the Example 11 code (`f = 1 - t Sign[y] Abs[y]^(1/3)`, `n = 40`); `gr_255`, the Example 12 n = 40 table.
  - `a2001/Animations/OrdinaryDE/Euler1/Euleraa.gif` and `MEuler1/MEuleraa.gif`, all frames.
- **What it showed.** Mathews' Modified Euler is the midpoint method. Both legacy animations are step-refinement sweeps over m, with y(5) printed to 7 decimals. All 41 printed values are correct.
- **Differences, and why the page follows the mathematics.**
  - The legacy frames rescale or clip the y-axis: the coarse runs leave the frame at the top. The page keeps one fixed window in which every value is visible.
  - The page drops Mathews' 3-frame blank lead-in and his 2-frame holds, which matches the RK pattern.
  - The page adds the reference curve, the error label and the stability band (R2-B).
- I did not open `n2003/Heun'sMethodMod.html`. Heun is no longer on this page.

## Notes
- The R2-B pattern was followed, with page-specific choices: the window is (−0.55, 1.9) and the legend and text are at bottom-left, as explained under F2.
- **Director's note on visibility.** Each range is stated as what is visible, with the computed sizes of the tiny cases:
  - Euler m = 45: alternation below 0.009, invisible;
  - midpoint m = 60: upturn 0.015, barely visible;
  - midpoint m = 70: upturn 0.0008, invisible.
- **Euler m = 50–100.** These runs exceed the stability limit, but their error at t = 5 is smaller than just before the onset, so the D2 wording "errors are amplified instead of damped" would not be literally true of the total error. The page states the mechanism precisely (the inherited error is multiplied by 1 + h·∂f/∂y < −1) and says plainly that for m = 50–100 the effect stays too small to see. RK did not have this case.
- **Error sequences are not monotone over the whole sweep.** Euler |e(5)| rises from m = 35 to 40 and very slightly from m = 55 to 60. Midpoint rises from m = 14 to 16. The page claims monotone decrease only from m = 60 (Euler) and m = 16 (midpoint).
- **R2-A "left out" note, for the director to decide.** The module's Examples 1–10 are worked examples that are not animated. No finding names them and the page's animation subject (Mathews' two animations) is now fully reproduced, so I did not add a "left out" sentence. Adding one needs the examples identified from their statement images.
- The page was not rendered with Quarto. The director renders the full section later.
- Out of scope: the intro still has no sentence on Heun's method under its own name. Mathews covers it in a separate module.

## Round 2 after check

### New Minor (from the independent check): Examples 11 and 12 are not single m = 40 runs. Outcome: fixed
- **Reproduced.** I viewed the solution images and stacked them into `$FIX/ex11_runs.png` and `$FIX/ex12_runs.png`.
  - Example 11 (`Links/..._lnk_12.html`): code blocks gr_229, gr_236 and gr_243 run `Euler[0.0, 5.0, 1.0, n]` with n = 40, 100 and 150. The final-value lines are gr_235: −0.0174406, gr_242: 0.00811736 and gr_249: 0.00811821.
  - Example 12 (`lnk_13`): code blocks gr_251, gr_258 and gr_265 run `MEuler` with n = 40, 100 and 150. The final values are gr_257: 0.0761463, gr_264: 0.00813852 and gr_271: 0.00812174.
  - So the earlier wording, "Their m = 40 frames are the runs of Examples 11 and 12" and "(the module's Example 11/12)", implied a single run per example. That is not exactly true.
- **Change, in `index.qmd`.**
  - Legacy note: "Their $m=40$ frames are the runs of the module's Examples 11 and 12." becomes "The module's Examples 11 (Euler) and 12 (modified Euler) each print runs with $m=40$, $100$ and $150$; their final values agree with this page's frames for those $m$."
  - Case 1: "(the module's Example 11)" becomes "(the first of the module's Example 11 runs, $m=40$, $100$ and $150$)".
  - Case 2: "(the module's Example 12)" becomes "(the first of the module's Example 12 runs, $m=40$, $100$ and $150$)".
- **Check.** An inline Python check runs Euler and the midpoint method at m = 40, 100 and 150 and rounds each result to the printed number of decimals. All 6 match. The Euler runs give −0.0174406187, 0.0081173646 and 0.0081182053; the midpoint runs give 0.0761462774, 0.0081385159 and 0.0081217390. Mathews' n is the number of subintervals: the printed values are y₄₁, y₁₀₁ and y₁₅₁. m = 40, 100 and 150 are all in both sweeps' `ms`, so the page has a frame for each.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Legacy note | Examples 11 (Euler) and 12 (modified Euler) each print runs with m = 40, 100, 150 | gr_229/236/243 (`Euler`, n = 40/100/150), gr_251/258/265 (`MEuler`, n = 40/100/150), viewed | yes |
| Legacy note | their final values agree with this page's frames for those m | 6/6 match after rounding: printed −0.0174406, 0.00811736, 0.00811821, 0.0761463, 0.00813852, 0.00812174 | yes |
| Case 1 | −0.0174 for m = 40 is the first of Example 11's runs (m = 40, 100, 150) | as above | yes |
| Case 2 | 0.0761 for m = 40 is the first of Example 12's runs (m = 40, 100, 150) | as above | yes |

No scripts or GIFs changed in this round. The page folder status is unchanged: `M` on the two `.jl` files, the two `.gif` files and `index.qmd`.

## Resolution check (independent checker, not shown this record)

Tools and outputs for this check are in this folder:
- `verify.py`: my own Euler, midpoint and Heun implementations, with a DOP853 reference (rtol 1e-13). The reference gives y(5) = 0.0081199205 and a peak of 1.449767 at t = 0.88356.
- `crops.py`, `legE.png`, `legM.png`: crops of the y(5) and m labels from the legacy frames.
- `ex11.png`, `ex12.png`: the module's Example 11 and 12 result images.
- `legacy_*/`, `new_*/`: extracted frames.
- `run/`: the regenerated GIFs.

### Original findings

### F1 — resolved
- Evidence: `eulersmethodbb.jl` now implements `ys[i+1] = ys[i] + h*f(ts[i]+h/2, ys[i]+(h/2)*f(ts[i],ys[i]))`, which is Mathews' MEuler (explicit midpoint). The case heading, GIF title, legend and alt text now say "Modified Euler (midpoint)". The Description now gives the midpoint formula and a correct verbal description ("half Euler step to the middle … uses the slope there"). No "Heun" remains on the page (grep).
- My midpoint implementation reproduces Example 12's printed n = 40 values:
  - y(5) = 0.07614628 (printed 0.0761463);
  - t = 1, 2, 3, 4 give 1.441935, 0.858479, 0.0913999, 0.0189838.
- The module's other two Example 12 runs also match: m = 100 gives 0.0081385 (printed 0.00813852) and m = 150 gives 0.0081217 (printed 0.00812174).
- Heun at n = 40 would give 0.2506, so the page now uses the module's method, not Heun.
- All 21 y(5) annotations of the legacy MEuleraa.gif are reproduced to 7 decimals (table below), and the regenerated GIF prints the same values.

### F2 — resolved
- Evidence: the "missing" note is gone. In its place the page says the legacy GIFs are in the archive and sweep m in the same way, and that every printed y(5) agrees with the page's runs to seven decimals. That is true: I read all 20 distinct Euler frames and all 21 distinct MEuler frames of the legacy GIFs (the first frame of each is a blank axes frame), and all 41 values match my implementations when rounded to 7 decimals.
- The legacy m sequences are:
  - Euler: 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150 (20 values);
  - MEuler: 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150 (21 values).

  Both scripts use exactly these sequences. The original finding listed only a subset of the m values; the fixer used the full sequence, which is correct.
- Both animations are now refinement sweeps: one complete run per frame, labelled with m, h, the computed y(5), its error, and the reference y(5), over a gray reference curve. Per R2-B, the reference curve is kept.
- The coarse-grid zig-zag or upturn is now visible in the frames, for Euler m = 10–40 and for midpoint m = 12–60.

Legacy values versus my runs (all match to 7 decimals):

| Euler m | legacy y(5) | mine | | MEuler m | legacy y(5) | mine |
|---|---|---|---|---|---|---|
| 10 | 1.7774834 | 1.7774834 | | 12 | 0.1958729 | 0.1958729 |
| 15 | 1.0252058 | 1.0252058 | | 14 | 0.1846256 | 0.1846256 |
| 20 | 0.7223784 | 0.7223784 | | 16 | 1.1185921 | 1.1185921 |
| 25 | 0.5522923 | 0.5522923 | | 18 | 0.9529541 | 0.9529541 |
| 30 | 0.3907263 | 0.3907263 | | 20 | 0.8146072 | 0.8146072 |
| 35 | -0.002737 | -0.0027370 | | 24 | 0.6126681 | 0.6126681 |
| 40 | -0.0174406 | -0.0174406 | | 28 | 0.3841123 | 0.3841123 |
| 45 | 0.0152568 | 0.0152568 | | 32 | 0.1347559 | 0.1347559 |
| 50 | 0.0080988 | 0.0080988 | | 36 | 0.0971247 | 0.0971247 |
| 55 | 0.0081157 | 0.0081157 | | 40 | 0.0761463 | 0.0761463 |
| 60 | 0.0081157 | 0.0081157 | | 44 | 0.0628993 | 0.0628993 |
| 70 | 0.0081163 | 0.0081163 | | 48 | 0.0519899 | 0.0519899 |
| 80 | 0.0081167 | 0.0081167 | | 52 | 0.0431155 | 0.0431155 |
| 90 | 0.0081171 | 0.0081171 | | 56 | 0.0365908 | 0.0365908 |
| 100 | 0.0081174 | 0.0081174 | | 60 | 0.0259429 | 0.0259429 |
| 110 | 0.0081176 | 0.0081176 | | 70 | 0.0101439 | 0.0101439 |
| 120 | 0.0081178 | 0.0081178 | | 80 | 0.008372 | 0.0083720 |
| 130 | 0.0081179 | 0.0081179 | | 90 | 0.0081739 | 0.0081739 |
| 140 | 0.0081181 | 0.0081181 | | 100 | 0.0081385 | 0.0081385 |
| 150 | 0.0081182 | 0.0081182 | | 120 | 0.0081251 | 0.0081251 |
| | | | | 150 | 0.0081217 | 0.0081217 |

### Changed-text ledger

Notation in this table:
- "onset" is the first t on a fine reference grid where h·|f_y| > 2.
- "err before onset" is |y_j − y(t_j)| at the last grid point before the onset.
- "Visible" means seen in the full-size frames; "numeric" means true only in the numbers.

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Description | modified Euler = explicit midpoint, formula y_{n+1}=y_n+h f(t_n+h/2, y_n+(h/2)f(t_n,y_n)) | Matches MEuler and the script; reproduces Example 12 and the legacy GIF | True |
| Description | "half Euler step to the middle … uses the slope there … global accuracy O(h²)" | Correct description of the midpoint method; second order. Error at m = 60→120 falls 1.78e-2→5.1e-6, which is not in the asymptotic range here, but O(h²) is the textbook order for smooth f, and y stays ≥ 0.008 > 0, so f is smooth along the solution | True |
| Animations intro | each frame a complete run with m subintervals, h = 5/m, gray reference = fixed-step RK4 with 50 000 steps, labelled with y(5) and error, red band where h·\|f_y\| > limit | Script code matches. The script's reference y(5) of 0.0081199 equals DOP853 0.0081199205 | True |
| Legacy note | GIFs are in the archive and sweep m the same way; every printed y(5) agrees to 7 decimals | All 41 values match (table above) | True |
| Legacy note / Case texts | "Their m=40 frames are the runs of the module's Examples 11 and 12"; "−0.0174 for m=40 (the module's Example 11)"; "0.0761 (the module's Example 12)" | Example 11 prints n = 41 points: −0.0174406. Example 12 prints n = 41 points: 0.0761463. Both Examples also print runs at m = 100 and 150. True, but incomplete (see New problems, Minor) | True (incomplete) |
| Case 1 heading | Forward Euler step-refinement sweep, m = 10 to 150 | Script ms | True |
| Case 1 | 20 values m = 10, 15, …, 150 of Mathews' animation | Legacy frames read | True |
| Case 1 | reference rises to about 1.4498 near t = 0.88 | 1.449767 at t = 0.8836 | True |
| Case 1 | decays toward nullcline y = 1/t³ (where y′ = 0) | 1 − t y^{1/3} = 0 ⇔ y = t⁻³; at t = 5 that is 0.008, and the reference is 0.00812 | True |
| Case 1 | reference y(5) = 0.0081199 | 0.0081199205 | True |
| Case 1 | m = 10 to 40: zig-zag in the tail and dip below zero | min y: −0.462, −0.170, −0.132, −0.116, −0.032, −0.045, −0.0174 for m = 10…40. Visible in the frames, though for m = 40 the dip is only the last point (−0.0174, a few pixels) | True |
| Case 1 | y(5) ≈ 1.777 (m=10), 0.391 (m=30), −0.0174 (m=40) | 1.7774834, 0.3907263, −0.0174406 | True |
| Case 1 | m = 45: the last steps still alternate, by less than 0.009, too little to see | Last diffs …, +0.00022, −0.00327, +0.00852; max swing 0.0085. Invisible in the frame | True |
| Case 1 | from m = 50 the runs decrease steadily after their peak | Monotone decreasing after the argmax for every m = 50…150 | True |
| Case 1 | from m = 60 the error in y(5) falls at every refinement | \|err\|: 55: 4.19e-6, 60: 4.22e-6 (a rise, so "from 60" is the right start); then 60→150 strictly decreasing | True |
| Case 1 | roughly halving when m doubles: −4.2e-6 (60), −2.1e-6 (120), −1.7e-6 (150) | −4.22e-6, −2.14e-6, −1.72e-6; also 70→140: 3.62e-6→1.84e-6 | True |
| Case 1 | y(5) ≈ 0.0081182 at m = 150 | 0.0081182 | True |
| Case 1 | f_y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | −41.255. \|f_y\| is monotone increasing along the reference for t > 0 | True |
| Case 1 | steps longer than about h = 0.0485 (m ≤ 103; here m = 10 to 100) exceed the limit 2 before t = 5 | h_crit = 2/41.255 = 0.04848, i.e. m < 103.14 | True |
| Case 1 | each step multiplies the inherited error by 1 + h f_y < −1 | Linearized error recursion for Euler, where h\|f_y\| > 2 | True |
| Case 1 | m = 10 onset t ≈ 2.92 | 2.923 (GIF shows 2.92) | True |
| Case 1 | m = 10 to 45: error at t = 5 larger than just before the onset | Before → end: 0.258→1.77, 0.024→1.02, 0.019→0.71, 0.022→0.54, 2.9e-4→0.38, 5.2e-4→0.011, 6.5e-5→0.026, 8.1e-5→0.0071 | True (numeric) |
| Case 1 | m = 50 to 100: onset t ≈ 3.95 to 4.95; amplified part too small to see; runs decrease steadily; error at t = 5 smaller than before the onset | Onset 3.950, 4.073, 4.189, 4.404, 4.600, 4.781, 4.949. Before→end, e.g. m = 50: 4.7e-5→2.1e-5; m = 100: 3.0e-6→2.6e-6. All smaller | True |
| Case 1 | m = 110 to 150 stay below 2 up to t = 5 | 5/110·41.26 = 1.875 | True |
| Case 1 alt | reference peaks near 1.45 at t ≈ 0.88, decays to 0.0081; m = 10–40 zig-zag and dip below zero; 1.777 at m = 10; shading for m = 10–100; from m = 50 steady decrease; 0.0081182 at m = 150 | As above. Shading checked in frames: present for m = 10–100, absent for m = 110–150 | True |
| Case 2 heading | Modified Euler (midpoint) step-refinement sweep, m = 12 to 150 | Script ms | True |
| Case 2 | 21 values m = 12 … 150 of Mathews' animation | Legacy frames read | True |
| Case 2 | m = 12 to 20: the tail zig-zags | 3–5 sign changes of Δy in the tail. Visible | True |
| Case 2 | m = 24 to 60: turns upward before t = 5; rises from its minimum by 0.57 (24), 0.057 (40), 0.015 (60), the last barely visible | 0.5693, 0.0572, 0.0150. In the frames the upturn is visible at 24 and 40 and faint at 60 | True |
| Case 2 | ending at y(5) ≈ 0.613, 0.0761, 0.0259 | 0.6126681, 0.0761463, 0.0259429 | True |
| Case 2 | m = 70: upturn only 0.0008, too small to see | 0.00078 | True |
| Case 2 | from m = 80 the runs decrease steadily after their peak | Monotone for 80, 90, 100, 120, 150 | True |
| Case 2 | from m = 16 the error in y(5) falls at every refinement in the sweep | \|err\| 14: 0.177 → 16: 1.11 (a rise); from 16 to 150 strictly decreasing | True |
| Case 2 | 2.5e-4 at m = 80; 1.8e-6 at m = 150; y(5) ≈ 0.0081217 | 2.52e-4, 1.82e-6, 0.0081217 | True |
| Case 2 | amplification factor 1 + z + z²/2; \|R\| ≤ 1 on the negative real axis exactly for −2 ≤ z ≤ 0; limit 2, same as Euler | R(z) = 1 + z + z²/2 for the midpoint method on y′ = λy. R has its minimum 1/2 at z = −1, R(0) = R(−2) = 1, and R > 1 outside [−2, 0] | True |
| Case 2 | m ≤ 103 (here 12–100) exceed 2 before t = 5; onset t ≈ 2.99 (m=12) to 4.95 (m=100) | 2.987, 4.949 | True |
| Case 2 | for each of these m the error at t = 5 is larger than just before the onset | Holds for all 16 values m = 12…100, e.g. m = 12: 4.6e-3→0.188; m = 80: 3.0e-5→2.5e-4; m = 100: 1.39e-5→1.86e-5 | True (numeric) |
| Case 2 | m = 120, 150 stay below 2 | 5/120·41.26 = 1.72 | True |
| Case 2 alt | m = 12–20 zig-zag; m = 24–60 upturn; 0.0761 at m = 40; shading for 12–100; from m = 80 steady decrease; 0.0081217 at m = 150 | As above; shading checked in frames | True |
| GIF titles / labels | "Euler's method for y' = 1 - t·y^(1/3) …, m = …, h = 5/m"; "Modified Euler (midpoint) …"; y(5), error, reference y(5), stability text | Every frame's y(5) equals my value. The stability text matches my onsets (m = 30 shows 3.40; mine is 3.395) | True |
| Script comments | ylims comments: Euler min −0.4624 / max 1.7775 at m = 10; midpoint max 1.4497 | −0.4624, 1.7775; midpoint max over all m = 1.4497 | True |

### New problems

- **Minor** (Legacy note in `index.qmd`, "Their $m=40$ frames are the runs of the module's Examples 11 and 12", and the "(the module's Example 11/12)" parentheticals in Case 1 and Case 2). Each of Examples 11 and 12 actually prints three runs: n = 41, 101 and 151 points, i.e. m = 40, 100 and 150.
  - Example 11 prints −0.0174406, 0.00811736 and 0.00811821 (`Euler'sMethodMod_gr_232/239/246.gif`).
  - Example 12 prints 0.0761463, 0.00813852 and 0.00812174 (`gr_254/261/268.gif`).

  The statement is true but implies each Example is a single m = 40 run. The m = 100 and m = 150 frames are also Example runs, and they match the page. Suggested wording: "Their m = 40, 100 and 150 frames are the runs of the module's Examples 11 and 12."

Non-defect observation: the midpoint frames for m = 24 and 28 show a small visible zig-zag at the end, on top of the upturn. The text groups them under "turns upward", which is true; it does not claim the absence of zig-zag.

Apart from the Minor item above, I found nothing new. This rests on:
- independent reproduction of every number on the page (`verify.py`);
- all 41 legacy annotations reproduced;
- full-size frames viewed: Euler m = 10, 40, 45, 150 and midpoint m = 12, 24, 40, 150, plus the contact sheets of both GIFs;
- a grep for leftover "Heun", "missing", "0.025" and "n = 200" text (none found).

### Reproducibility and conventions

- Both scripts were run from scratch copies (`check/run/`). The regenerated GIFs are byte-identical to the committed ones:
  - `eulersmethodaa.gif`: sha256 2f3e6c01…2564, 20 frames;
  - `eulersmethodbb.gif`: sha256 c4c02f33…372a, 21 frames.
- Both committed files are real GIFs (640×480), not LFS pointers.
- Conventions hold:
  - Description comes before Animations.
  - Each case has a `[Julia source]` link and a GIF embed.
  - The alt texts are descriptive and accurate.
  - There are no code blocks in `index.qmd`.
- The fix diff touches only the five files in the page folder: 2 .jl, 2 .gif and index.qmd. The working tree has other modified pages and untracked `reviews/numerical-methods-animations-r2/fixes/*.md`. These belong to the other pages' fixes in this run, and nothing outside this page folder is part of this page's diff.

### Re-check

This re-check covers the fixer's response to the Minor item: the Examples 11 and 12 wording.

**What changed.** Only `index.qmd` changed:
- the legacy note (lines 36–39);
- the Case 1 aside (line 50);
- the Case 2 aside (line 78).

The scripts and GIFs are unchanged. Their sha256 hashes still equal my scratch copies and the byte-identical regenerated GIFs (2f3e6c01…, c4c02f33…).

**New wording checked against the archive.** I re-read the archive images `Euler'sMethodMod_gr_232/239/246.gif` and `gr_254/261/268.gif`.

- Legacy note: "The module's Examples 11 (Euler) and 12 (modified Euler) each print runs with m = 40, 100 and 150; their final values agree with this page's frames for those m." **True.**
  - Example 11 prints n = 41, 101, 151 points, which is m = 40, 100, 150. Its values are −0.0174406, 0.00811736 and 0.00811821. The page frames show −0.0174406, 0.0081174 and 0.0081182, so they agree at the frames' 7 decimals.
  - Example 12 prints the same three runs. Its values are 0.0761463, 0.00813852 and 0.00812174. The page frames show 0.0761463, 0.0081385 and 0.0081217, which also agree.
- Case 1: "−0.0174 for m = 40 (the first of the module's Example 11 runs, m = 40, 100 and 150)". **True.** The archive prints the n = 41 run first.
- Case 2: "0.0761 (the first of the module's Example 12 runs, m = 40, 100 and 150)". **True.**

**Minor item: resolved.**

**F1 and F2 still hold.**
- There is no Heun or "missing" text left (grep).
- The midpoint method, the m sweeps, every other sentence and number, and the GIFs are all unchanged from the state I checked above.

**New problems: none.**

**Final status:** committed
