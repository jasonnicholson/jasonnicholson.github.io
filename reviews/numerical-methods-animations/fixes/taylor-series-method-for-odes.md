# Fix record: taylor-series-method-for-odes

Scratch evidence folder (re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/taylor-series-method-for-odes/fix/` (below: `$FIX`). Python checks run as `cd $FIX/py && /usr/bin/python3 -I <script>.py`. Each script's output is saved beside it as `<script>.out`.

- `py/derivs.py`: sympy total derivatives y″, y‴ and y⁗ of y′ = 1 − t·y^{1/3}. It checks the scripts' y″ and y‴, the review's y⁗ formula and the new Julia `yd4_f` expression, and finds ∂f/∂y.
- `py/reference.py`: reference solution from mpmath `odefun` (30 and 45 digits), saved at t = 0.05k (`ref_grid.json`). It is cross-checked against scipy Radau, LSODA and DOP853 (rtol 1e-13).
- `py/analysis.py`: independent Taylor order 3 and order 4 with analytic derivatives. Also stability limits, ∂f/∂y along the solution, instability onset by step size, the n = 20 tables, the candidate n (80, 83, 100, 120), the n = 100 frame values and order checks (local and global).
- `py/misc.py`: R₃ and R₄ beyond z*, positivity of the exact solution, the error ratio and h_max arithmetic.
- `py/flat.py`: the onset time and exact slope y′ at onset, for h from 0.0625 to 2.
- `py/mathews.py`, `py/mathews_abs.py`, `py/mathews_ex11.py`, `py/mathews_neg.py`: reproduce the values printed in the legacy archive, and find which of his runs go negative before t = 5.
- `instrumented.jl`: runs a page script's own computation without plotting and prints n, h, stride, the title, limits and every frame label.
- `scripterr.jl`: the fixed scripts' own values compared with the mpmath reference.
- `d4check.jl`: the HEAD finite-difference y⁗ compared with the new analytic `yd4_f`.
- Frames: `orig_aa/`, `orig_bb/` (committed GIFs), `new_aa/`, `new_bb/` (regenerated) and `mathews_aa/`, `mathews_bb/` (archive GIFs, with `labels.png` crops).

## Findings

### F1 — Error — fixed
- **Reproduced:**
  - `py/analysis.py` (independent order 3 and order 4 at n = 20, h = 0.25):
    - Order 3: 4.00: 0.006795, 4.25: 1.216164, 4.50: 0.452905, 5.00: 0.089522.
    - Order 4 (analytic y⁗): 4.25: −0.046527, 4.50: −10.434138, 5.00: −5.253501. The old script's finite-difference y⁗ gives −0.046492, −10.451291 and −5.267457 (`d4check.jl`), the same as the review's table.
    - Reference (`py/reference.py`): y(4.25) = 0.0134162, y(4.5) = 0.0112304, y(5) = 0.008119920464867961003 (dps 30 = dps 45; Radau within 2e-14).
  - Stability limits (`py/analysis.py`, `mp.findroot`):
    - Order 3: R₃(z*) = −1 at z* = −2.512745327.
    - Order 4: R₄(z*) = +1 at z* = −2.785293563.
    - Both have |R| < 1 on (z*, 0), and `py/misc.py` shows R₃ ≤ −1 and R₄ ≥ 1 for all z ≤ z*.
  - J = ∂f/∂y = −t/(3y^{2/3}) (sympy). Along the solution |J| increases monotonically on [0,5] to J(5) = −41.2554. With h = 0.25 the onset is at t = 3.279 (order 3) and t = 3.342 (order 4).
  - The committed frames show the same: `orig_aa/frame_018.png` has the spike to "y≈1.2162" at t = 4.25, and `orig_bb/frame_021.png` has the trace leaving the bottom of the plot with the label "y≈-5.2675".
  - The finding holds.
- **Change:**
  - Both scripts: `n = 20` → `n = 100` (h = 0.05), with a comment giving the reason. A new `stride = 5` changes the loop `1:n+1` to `1:stride:n+1`, so each frame adds 5 steps (0.25 in t). The frame count stays 21 and fps stays 3, and the line still passes through all computed points.
  - Limits: `xlims (0,5)` → `(-0.1,5.1)` and `ylims (0,1.8)` → `(-0.05,1.8)`, so the end marker is not clipped.
  - Titles: `"Taylor Method (n=3): y' = 1 - t·y^{1/3},  y(0) = 1"` → `"Taylor order 3, h = 0.05: y' = 1 - t·y^(1/3),  y(0) = 1"`, and likewise for order 4. GR printed the braces literally, and "n=3" could be read as a step count.
  - The same h is used for both cases, so Case 2's same-step comparison (F2) stays meaningful. Order 4 alone would only need n ≥ 75.
  - index.qmd:
    - Headings gain "$n=100$ steps ($h=0.05$)".
    - The intro's frame sentence is updated.
    - Each Behavior paragraph gets an accuracy sentence and the D2 stability sentence.
    - Both alt texts are rewritten.
- **Check:**
  - h·J(5) = 0.05 × (−41.2554) = −2.063. That is inside both limits: R₃ = −0.398 and R₄ = 0.356 (`py/analysis.py`).
  - `instrumented.jl`:
    - Order 3 lowest value 0.0081199, and the values strictly decrease after the peak 1.449609 at t = 0.90. y(5) = 0.0081199193.
    - Order 4 lowest value 0.0081199, and the values strictly decrease after the peak 1.449614 at t = 0.90. y(5) = 0.0081199205.
  - `scripterr.jl` (the scripts' own values against mpmath at all 101 nodes):
    - Order 3: max error 1.3272e-5 (at t = 3.15), error at t = 5 1.186e-9.
    - Order 4: max error 8.0209e-7 (at t = 3.30), error at t = 5 3.846e-11.
  - `py/analysis.py` independently gives the same values, agreeing with every frame value to the 7 printed digits.
  - Frames: see "Scripts and GIFs".

### F2 — Error — fixed
- **Reproduced:** `py/analysis.py` n = 20:
  - err3/err4 at t = 0.25…2.75 is 11.0, 13.5, 16.3, 19.8, 24.7, 32.7, 48.7, 96.9, 579.0, 195.9 and 8.8. So the error ratio is not "slightly" better.
  - From t = 4.5 the order-4 error is 10.4 against 0.44 for order 3, so order 4 is far worse there.
  - The checker's figures (10–600×) agree. The finding holds.
- **Change:** index.qmd Case 2: "giving slightly better accuracy than order 3 with the same step size $h=0.25$" → "With the same step $h=0.05$ the largest error at the 101 step points is $8.0\times10^{-7}$, more than 16 times smaller than the $1.3\times10^{-5}$ of order 3." The D2 sentence for order 4 describes what h = 0.25 did.
- **Check:**
  - `scripterr.jl` gives 1.3272e-5 and 8.0209e-7, and `py/misc.py` gives the ratio 16.54.
  - This compares the largest errors. Node by node the ratio is not uniform: it ranges from 0.5 (t = 2.85, where the order-3 error changes sign) to 16320 (`py/analysis.py`). So the text compares only the maximum errors.

### F3 — Error — fixed (with the checker's correction)
- **Reproduced:** `py/analysis.py`:
  - Order 3 global error at T = 2, halving h from 0.25: 9.345e-4, 1.140e-4, 1.408e-5, 1.750e-6, 2.181e-7. The ratios are 8.20, 8.10, 8.05 and 8.02, so the global error is O(h³).
  - Max-grid error on [0,5] for n = 100…800: ratios 8.41, 8.24 and 8.12.
  - The local one-step error ratios are 16.03, 16.01, 16.01 and 16.00 at t₀ = 1, so the local error is O(h⁴). As the checker said, the "local truncation error O(h⁴)" clause is correct. Only "matching RK4 in order" is false.
- **Change:**
  - index.qmd Case 1: "The local truncation error is $O(h^4)$, matching RK4 in order." → "The local truncation error is $O(h^4)$ and the global error is $O(h^3)$, the same order as a third-order Runge–Kutta method."
  - Case 2 (the RK4 comparison moves here, as the finding suggested): "The local truncation error is $O(h^5)$ and the global error is $O(h^4)$, the same order as RK4."
- **Check:**
  - Order 4 local ratios are 33.11 (t₀ = 1) and 32.59 (t₀ = 2.5), tending to 32. Global ratios are 24.49, 21.34, 19.08 and 17.67 at T = 2, and the max-grid ratios 17.50, 16.91 and 16.44 tend to 16.
  - Mathews' module page states the same theorem: local error O(h^{n+1}) and global error O(h^n) (text of `TaylorDEMod.html`).

### F4 — Misleading — fixed
- **Reproduced:** `d4check.jl` compares HEAD `taylorderivativebb.jl` with the new `yd4_f`. The finite difference against the exact y⁗ is 1.66666315 vs 1.66666667 at (0,1), and −18.37611306 vs −18.37598174 at (3, 0.09). The relative differences are 1.3e-7 to 2.1e-5. Over the n = 20 trajectory up to t = 4 the largest difference is 6.30e-7. The checker's correction holds: only index.qmd:12 ("compute higher derivatives analytically") is contradicted.
- **Change:** `taylorderivativebb.jl`:
  - The finite difference (`eps_h …; d4 = (yd3_f(...) - d3)/eps_h`) is replaced by `d4 = yd4_f(t, y)`.
  - New function `yd4_f(t, y) = (27c^7 + 18c^5 t^2 − 39c^4 t + 3c^3 t^4 + 18c^3 − 15c^2 t^3 + 22c t^2 − 10t)/(27c^8)` with `c = cbrt(y)`, plus a comment.
  - Header comment: "one more derivative term" → "one more derivative term (y'''' also analytic)".
  - Case 2 text adds "all computed analytically".
- **Check:**
  - `py/derivs.py`: sympy's y⁗ minus the c-form expression simplifies to 0, and the review's formula also matches (difference 0).
  - `d4check.jl`: with the new code at n = 100 the trajectory differs from the finite-difference version by at most 3.8e-11, so there is no visible change.
  - The Julia n = 20 analytic values (−0.0465273, −10.4341377) match `py/analysis.py`.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd intro | "Each frame adds five Taylor steps (0.25 in $t$)" | `stride = 5`, h = 0.05, so 5·0.05 = 0.25. `instrumented.jl` prints 21 frames at t = 0, 0.25, …, 5.0 for both scripts | yes |
| index.qmd intro | "the connecting curve passes through every computed point" | the scripts draw `plot!(ts[1:frame], ys[1:frame])` where `frame` is a step index | yes |
| Case 1 heading | "$n=100$ steps ($h=0.05$)" | `instrumented.jl`: `n=100 h=0.05` | yes |
| Case 1 | "local truncation error is $O(h^4)$" (kept) | `py/analysis.py` local ratios 16.03/16.01/16.01/16.00 (t₀ = 1) and 12.16→15.72 (t₀ = 2.5) | yes |
| Case 1 | "global error is $O(h^3)$" | `py/analysis.py` ratios at T = 2: 8.20, 8.10, 8.05, 8.02; max-grid n = 100…800: 8.41, 8.24, 8.12 | yes |
| Case 1 | "the same order as a third-order Runge–Kutta method" | an RK3 method has global error O(h³) by definition; measured order here is 3 (above) | yes |
| Case 1 | "largest error at the 101 step points is $1.3\times10^{-5}$" | `scripterr.jl` 1.3272e-05 (t = 3.15); `py/analysis.py` 1.327e-05 | yes |
| Case 1 | "error at $t=5$ is $1.2\times10^{-9}$" | `scripterr.jl` 1.186e-09; `py/analysis.py` 1.19e-09 | yes |
| Case 1 | "exact $y(5)=0.0081199$" | `py/reference.py` 0.008119920464867961 (dps 30 = 45) | yes |
| Case 1 (round 2) | "For steps longer than about $h=0.0609$, $h\,\|\partial f/\partial y\|$ exceeds order-3 Taylor's stability limit $2.513$ before $t=5$" | h_max = 2.512745327/41.2554 = 0.060907 (`py/misc.py`, `py/analysis.py`). \|J\| is monotone increasing, so for h > h_max, h\|J\| passes 2.513 at some t < 5 (n = 82: onset t = 4.998), and for h ≤ h_max it never does (n = 83: no onset) | yes |
| Case 1 | "$\partial f/\partial y=-t/(3y^{2/3})$" | `py/derivs.py` → True | yes |
| Case 1 | "grows to $-41.3$ at $t=5$" | `py/analysis.py` J(5) = −41.2554, \|J\| monotone on [0,5] | yes |
| Case 1 (round 2) | "errors are amplified instead of damped" (limit $2.513$) | z* = −2.512745327; \|R₃\| < 1 on (z*,0) (max 0.999999999); R₃ ≤ −1 for z ≤ z* (`py/misc.py`). This is linear stability with J frozen | yes |
| Case 1 (round 2) | "Just above $h=0.0609$ this affects only the last few steps" | `py/round2.py`: n = 82/80/76/70 (h = 0.0610–0.0714) give onsets t = 4.998/4.958/4.875/4.745, with 0/0/1/3 steps starting after the onset. Max errors are 2.5e-5 to 4.2e-5, and min y = 0.00812, so nothing is visible | yes |
| Case 1 (round 2) | "with $h=0.25$ ($n=20$) it starts at $t\approx3.3$" | `py/round2.py`, `py/analysis.py`: onset t = 3.279 | yes |
| Case 1 | "jumps from $0.0068$ at $t=4$ to $1.22$ at $t=4.25$" | `py/analysis.py` n = 20 order 3: 0.006795, 1.216164 (equals the HEAD script's values in the review) | yes |
| Case 1 alt | "step h = 0.05", "five Taylor steps per frame" | as heading and intro | yes |
| Case 1 alt | "rising to about 1.45 near t = 0.9" | `instrumented.jl`: peak 1.449609 at t = 0.90 | yes |
| Case 1 alt | "then falling smoothly toward y ≈ 0.0081 at t = 5" | `instrumented.jl`: strictly decreasing after peak → true, y(5) = 0.0081199193; frames viewed | yes |
| Case 2 heading | "$n=100$ steps ($h=0.05$)" | `instrumented.jl`: `n=100 h=0.05` | yes |
| Case 2 | "four derivative terms are used per step, all computed analytically" | script `taylor4_step` uses `yd1_f`…`yd4_f`, all closed form; `py/derivs.py` checks them against sympy (difference 0) | yes |
| Case 2 | "local truncation error is $O(h^5)$" (kept) | `py/analysis.py` local ratios 39.03→33.11 (t₀ = 1), 37.43→32.59 (t₀ = 2.5) | yes |
| Case 2 | "global error is $O(h^4)$, the same order as RK4" | ratios 24.49, 21.34, 19.08, 17.67 (T = 2); max-grid 17.50, 16.91, 16.44; RK4 is globally fourth order (measured 16.40 on the RK page) | yes |
| Case 2 | "largest error at the 101 step points is $8.0\times10^{-7}$" | `scripterr.jl` 8.0209e-07 (t = 3.30); `py/analysis.py` 8.021e-07 | yes |
| Case 2 | "more than 16 times smaller than the $1.3\times10^{-5}$ of order 3" | 1.3272e-5/8.0209e-7 = 16.54 (`py/misc.py`) | yes |
| Case 2 (round 2) | "For steps longer than about $h=0.0675$, $h\,\|\partial f/\partial y\|$ exceeds order-4 Taylor's stability limit $2.785$ before $t=5$"; "Just above … only the last few steps"; "with $h=0.25$ … it starts at $t\approx3.3$" | h_max = 2.785293563/41.2554 = 0.067513; n = 74 onset t = 4.999, n = 75 no onset (`py/analysis.py`). `py/round2.py`: n = 74/72/70 give onsets 4.999/4.954/4.908 with 0/0/1 steps after the onset, max errors 2.9e-6 to 3.8e-6. Onset for h = 0.25 is t = 3.342 | yes |
| Case 2 (round 2) | "errors are amplified instead of damped" (limit $2.785$) | z* = −2.785293563; \|R₄\| < 1 on (z*,0); R₄ ≥ 1 for z ≤ z* (`py/misc.py`) | yes |
| Case 2 | "with $h=0.25$ ($n=20$) the computed values turn negative at $t=4.25$" | `py/analysis.py` n = 20 order 4: t = 4.00: 0.014188 (> 0), t = 4.25: −0.046527; all earlier nodes positive | yes |
| Case 2 | "reach about $-10$ at $t=4.5$" | −10.434 (analytic y⁗, `py/analysis.py` and `d4check.jl`); −10.451 with the old finite difference | yes |
| Case 2 | "although the exact solution stays positive" | `py/misc.py`: exact min on [0,5] is 0.0081199 at t = 5. Also y′ = 1 > 0 wherever y = 0 | yes |
| Case 2 alt | "rising to about 1.45 near t = 0.9 … toward y ≈ 0.0081 at t = 5", "five Taylor steps per frame", "h = 0.05" | `instrumented.jl`: peak 1.449614 at t = 0.90, strictly decreasing after it, y(5) = 0.0081199205 | yes |
| both .jl `n` comment | "h = 0.05 keeps h*\|df/dy\| below order-3 (order-4) Taylor's limit 2.513 (2.785) up to t = 5" | 0.05·41.2554 = 2.063 (`py/misc.py`) | yes |
| both .jl `stride` comment | "each frame adds `stride` Taylor steps (0.25 in t)" | 5·0.05 = 0.25 | yes |
| both .jl limits comment | "small margins so the end point (5, 0.0081) is not clipped" | `new_aa/frame_021.png`, `new_bb/frame_021.png`: marker fully inside the frame | yes |
| bb.jl comment | "(y'''' also analytic)", "y'''' = total derivative of y''' along y' = f, simplified with c = y^(1/3)" | `py/derivs.py`: candidate − sympy d4 → 0 | yes |
| GIF titles | "Taylor order 3, h = 0.05: y' = 1 - t·y^(1/3),  y(0) = 1" (and order 4) | frames 1, 10, 18, 21 viewed: the title fits in 640 px with no literal braces | yes |
| GIF labels (code unchanged, new values) | e.g. "t=2.25  y≈0.629", "t=5.0  y≈0.0081" | `instrumented.jl` prints all 21 labels per script; each is the value rounded to 4 decimals (0.6289506 → 0.629, 0.0199657 → 0.02) | yes |

## Scripts and GIFs
- Scripts changed: `taylorderivativeaa.jl` and `taylorderivativebb.jl`. Both GIFs were regenerated with `julia <script>.jl` from the page folder. Each still has 21 frames.
- Frames extracted to `$FIX/new_aa/` and `$FIX/new_bb/`. Viewed at full size:
  - aa frames 1, 18 and 21: start marker at (0,1) clear of the border; t = 4.25 label "y≈0.0134"; end marker at (5, 0.0081) fully visible above the frame line.
  - bb frames 10 and 21.
  - Contact sheets for both. They show a smooth rise to about 1.45 and a monotone fall that flattens after t ≈ 3.2, with no spike and nothing leaving the plot.
  - Every label matches `inst_aa.out` and `inst_bb.out`. The title is legible and fits.
- `git status --short -- pages/numerical-methods/taylor-series-method-for-odes` after regeneration:
  ```
   M pages/numerical-methods/taylor-series-method-for-odes/index.qmd
   M pages/numerical-methods/taylor-series-method-for-odes/taylorderivativeaa.gif
   M pages/numerical-methods/taylor-series-method-for-odes/taylorderivativeaa.jl
   M pages/numerical-methods/taylor-series-method-for-odes/taylorderivativebb.gif
   M pages/numerical-methods/taylor-series-method-for-odes/taylorderivativebb.jl
  ```
  This is the expected set. Both GIFs were meant to change, and there are no other GIFs in the folder.

## Legacy archive
Consulted:
- `n2003/TaylorDEMod.html` and Links `_lnk_12.html` (Example 11, order 3) and `_lnk_13.html` (Example 12, order 4).
- Images `TaylorDEMod_gr_215` (IVP), `_228` (his Mathematica code), `_233`, `_236`, `_240`, `_243`, `_247` and `_250`.
- The animations `a2001/Animations/OrdinaryDE/Taylor1/Tayloraa.gif` (33 frames) and `Taylor2/Taylorbb.gif` (32 frames), extracted to `$FIX/mathews_aa/` and `$FIX/mathews_bb/`. `labels.png` holds the m and y(5) crops.

What it showed:
- **The IVP is the page's:** y′ = 1 − t∛y, y(0) = 1, 0 ≤ t ≤ 5 (gr_215). Examples 11 and 12 compute order-3 and order-4 Taylor solutions.
- **Example 11 (order 3) uses m = 25 (h = 0.2).** Its printed list (gr_236) and graph (gr_233) go unstable, which the text does not mention: y(4.2) = 0.0328265, y(4.6) = −0.00995901, then a spike to 0.352 at t = 4.8. `py/mathews_ex11.py` reproduces every printed value through t = 4.6 exactly.
- **He then uses m = 50 and m = 150.** He prints y(5) = 0.00811996 and 0.00811992, and both reproduce.
  - At m = 50 (h = 0.1) the order-3 method is past its linear-stability limit from t = 4.252 on, but only for the last 7 steps. The printed y(5) is still accurate.
  - This is why the page uses "become unstable" in the linear-stability sense and the stricter "stable to t = 5" criterion.
- **The animations are step-count sweeps, not single runs.** Each frame shows the whole solution for one m and prints y(5).
  - Both sweeps use m = 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120 and 150.
  - m = 20 (h = 0.25, the old page's step) is an unstable frame in both. Order 3 shows the same spike at t = 4.25 as the old page.
  - The printed y(5) values reproduce exactly (`py/mathews.py`, all 7 printed digits) for order 3 with m ≥ 16 and order 4 with m ≥ 32. These are exactly the runs with no negative value before t = 5 (`py/mathews_neg.py`). Examples: order 3 m = 20: 0.0895215; order 4 m = 32: −0.080651; order 4 m = 40: 0.0094813.
  - The runs that do go negative before t = 5 (order 3 m = 12 and 14; order 4 m = 12–28) do not reproduce with a real cube root, the principal complex root or |y|^{1/3}. His code (gr_228) replaces y^{k/3} with Sign[y]·|y|^{k/3} after expanding, so even powers get a sign. In any case those runs are already in the unstable regime.
  - His order-4 m = 20 frame (y(5) = 0.0711898) therefore differs from the old script's −5.27 only after y < 0.
- **The module theorem** (local error O(h^{n+1}), global O(h^n)) agrees with the F3 fix.
- **The fix follows D2's default:** one stable run, h = 0.05 (m = 100, which appears in both of Mathews' sweeps with y(5) = 0.0081199, the same as the new final values to 7 digits). Each case says in a sentence that h = 0.25 goes unstable. The page does not copy Mathews' m = 25 worked example, which is unstable.

## Notes
- **Same step for both cases.** Order 4 alone would only need n ≥ 75, so n = 80 would do. I used n = 100 for both, so that Case 2's comparison "with the same step" is a like-for-like comparison and the two animations have the same frame times. This is the smallest change that keeps the old page's same-step framing.
- **Reference curve.** It was not added. The largest errors are 1.3e-5 and 8.0e-7, which are invisible at this scale (same reasoning as the Runge–Kutta record).
- **Order-3 script cube root.** `taylorderivativeaa.jl` uses `y^(1/3)`, which throws a DomainError for y < 0. That cannot happen at h = 0.05, since the lowest value is 0.0081, so I left it unchanged.
- **Pre-existing convention gap, not touched.** The page has no `## Description` section before `## Animations`. No finding names it.
- **Outside this page: the Runge–Kutta page's sentence overstates slightly.** It reads "Steps longer than about $h=0.0675$ become unstable once the solution flattens toward the nullcline". RK4 has the same real-axis limit as order-4 Taylor, and `py/flat.py` shows that for large steps the onset is not in the flat part. At h = 0.5 it is at t = 3.04 (y′ = −0.30), and at h = 1 it is at t = 2.79 (y′ = −0.61), while the steepest descent slope is about −0.9 to −1. The "once the solution flattens" clause is true for h = 0.25 (onset t = 3.34, y′ = −0.057) but not for every longer step. In round 1 I attached "after the solution has flattened out" to h = 0.25 only. Round 2 dropped the clause (see below). I did not edit the RK page; the director may want the same change there and on the other D2 pages.

## Round 2 (director)

The director's shared correction (`patterns/d2wording.md`) applies to both cases. "Steps longer than about h* become unstable before t = 5" reads as a visible blow-up, but just above h* the limit is crossed only in the last step or so and nothing visible happens.

- **Change (index.qmd, both Behavior paragraphs).** The sentences now say what was computed:
  - Case 1: "For steps longer than about $h=0.0609$, $h\,|\partial f/\partial y|$ exceeds order-3 Taylor's stability limit $2.513$ before $t=5$ (because $\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$), and from then on errors are amplified instead of damped. Just above $h=0.0609$ this affects only the last few steps, but with $h=0.25$ ($n=20$) it starts at $t\approx3.3$ and the computed value jumps from $0.0068$ at $t=4$ to $1.22$ at $t=4.25$."
  - Case 2: the same form with $h=0.0675$ and limit $2.785$, ending in the unchanged h = 0.25 facts (negative at t = 4.25, about −10 at t = 4.5).
  - The clause "after the solution has flattened out" was dropped.
- **Check.** `py/round2.py` (output `round2.out`):
  - Order 3, n = 82, 80, 76, 70 (h = 0.0610–0.0714): onset t = 4.998, 4.958, 4.875, 4.745, with 0, 0, 1 and 3 steps starting after the onset. The max error is 2.5e-5 to 4.2e-5 and y stays ≥ 0.00812.
  - Order 4, n = 74, 72, 70: onset t = 4.999, 4.954, 4.908, with 0, 0 and 1 steps after the onset. The max error is 2.9e-6 to 3.8e-6.
  - Onset at h = 0.25: t = 3.279 (order 3) and 3.342 (order 4), both "≈3.3".
  - The ledger rows marked "(round 2)" replace the round-1 rows for these sentences. Every other number is unchanged from round 1.
- No script or GIF changed in round 2. `git status` of the page folder still shows the same five modified files.

## Resolution check (independent checker, not shown this record)

All numbers below come from `check/indep.py` (sympy total derivatives; mpmath `odefun` reference at 30 digits, which agrees with scipy Radau rtol=1e-13 to 1.9e-14 on the grid), from running scratch copies of the scripts (`check/run/`), from `check/h25bb.jl` (the fixed order-4 script with n=20), and from the frames in `check/fa/` and `check/fb/`.

### Original findings

### F1 — resolved
- Both scripts now use n=100, h=0.05. The largest h·|∂f/∂y| along the solution is 0.05·41.255 = 2.06, which is below both stability limits: 2.5127 for order 3 and 2.7853 for order 4. These are the real roots of |R(z)|=1 for the Taylor polynomials, which I computed myself.
- Nodal errors against the high-precision reference: order 3 has a maximum of 1.327e-5 (at t=3.15) and 1.19e-9 at t=5. Order 4 has a maximum of 8.02e-7 (at t=3.30) and 3.8e-11 at t=5. Both end at y(5)=0.0081199, and the exact value is 0.00811992. Neither run produces a spike or a negative value.
- Frames: in both GIFs (21 frames each), frames 1, 11 and 21 at full size and the contact sheet show a smooth rise to about 1.45 near t≈0.9, then a decay. The red marker stays on screen through t=5. The annotations agree with the reference: 0.4045 at t=2.5, 0.0898 at 3, 0.0254 at 3.5, 0.0162 at 4, 0.0112 at 4.5 and 0.0081 at 5.
- The page now explains the h=0.25 instability in the text, and the numbers it gives are correct (see the ledger).

### F2 — resolved
- The sentence "slightly better accuracy than order 3 with h=0.25" is gone. In its place the page says that at h=0.05 the maximum error is 8.0e-7 for order 4 against 1.3e-5 for order 3, "more than 16 times smaller". I measured 1.327e-5 / 8.021e-7 = 16.5, so the claim is true.

### F3 — resolved
- "matching RK4 in order" is gone. The page now says local O(h^4), global O(h^3), "the same order as a third-order Runge–Kutta method". Under step halving the global error ratio at T=2 is 8.04, 8.02, 8.01, 8.00, and the ratio of maximum nodal errors on [0,5] is 8.49, 8.21, 8.11.
- The RK4 comparison now sits in Case 2. For order 4 at T=2 the ratios are 18.6, 17.4, 16.7, 16.3, tending to 16, and the max-error ratios are 18.0, 16.7, 16.4. Global O(h^4) is confirmed.

### F4 — resolved
- The finite difference has been replaced by `yd4_f`. sympy shows that `simplify(D(D(D(f))) - yd4_script) = 0`, where D is the total derivative along f. The script comment now says "(y'''' also analytic)", and the page says "all computed analytically". Both are true.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:12 | "Each frame adds five Taylor steps (0.25 in t)" | Loop is `1:5:101` with h=0.05, giving 21 frames; the t annotations step by 0.25 | true |
| index.qmd:12 | "connecting curve passes through every computed point" | `plot!(ts[1:frame], ys[1:frame])` draws all nodes | true |
| index.qmd:16,24 | headers "n=100 steps (h=0.05)" | Scripts: n=100, T=5 | true |
| index.qmd:18 | local O(h^4), global O(h^3), like RK3 | Step-halving ratios of about 8 | true |
| index.qmd:18 | max error at 101 points 1.3e-5 | 1.327e-5 | true |
| index.qmd:18 | error at t=5 1.2e-9 | 1.186e-9 | true |
| index.qmd:18 | exact y(5)=0.0081199 | 0.0081199205 (mpmath and Radau) | true |
| index.qmd:18 | threshold h≈0.0609 | 2.51275/41.2554 = 0.06091; \|∂f/∂y\| is monotone on [0,5] | true |
| index.qmd:18 | order-3 limit 2.513 | Real root of 1+z+z²/2+z³/6 = -1: -2.51275 | true |
| index.qmd:18 | ∂f/∂y = -t/(3y^{2/3}), -41.3 at t=5 | sympy; -41.255 | true |
| index.qmd:18 | errors amplified past the limit, "only the last few steps" just above 0.0609 | Frozen-coefficient argument with monotone \|J\|; a fair heuristic statement | true |
| index.qmd:18 | h=0.25: starts at t≈3.3 | Crossing of 0.25\|J\| = 2.513 at t=3.279 | true |
| index.qmd:18 | 0.0068 at t=4, 1.22 at t=4.25 | Order-3 Taylor with n=20: 0.0068, 1.2162 | true |
| index.qmd:26 | "all computed analytically" | yd4_f matches sympy exactly | true |
| index.qmd:26 | local O(h^5), global O(h^4), same as RK4 | Ratios approach 16 | true |
| index.qmd:26 | max error 8.0e-7, "more than 16 times smaller" than 1.3e-5 | 8.021e-7; ratio 16.5 | true |
| index.qmd:26 | threshold h≈0.0675, limit 2.785 | Root -2.78529; 2.78529/41.2554 = 0.06751 | true |
| index.qmd:26 | h=0.25: starts t≈3.3, negative at 4.25, about -10 at 4.5, exact stays positive | Crossing t=3.342; fixed script with n=20 gives -0.0465 at 4.25 and -10.434 at 4.5; exact y>0 because y'=1 at y=0 | true |
| index.qmd:22,30 alt | h=0.05, five steps per frame, peak about 1.45 near t=0.9, down to 0.0081 at t=5 | Numerical peak 1.4496 at node t=0.90 (true peak 1.4498 at t=0.884); final value 0.0081 | true |
| aa.jl:28 / bb.jl:34 comments | h=0.05 keeps h\|df/dy\| below 2.513 / 2.785 | Maximum is 2.063 | true |
| aa.jl:32-33 / bb.jl:38-39 | xlims (-0.1,5.1), ylims (-0.05,1.8) | Endpoint (5, 0.0081) is visible in frame 21 | true |
| aa.jl:35 / bb.jl:41 | titles "Taylor order 3/4, h = 0.05: …" | Fully legible at 640×480 | true |
| bb.jl:18-22 | yd4_f closed form | sympy difference 0 | true |

### New problems
None introduced by the fix. This rests on the full ledger above, on reading frames 1, 11 and 21 of both GIFs at full size plus the contact sheet, and on the step-halving order checks.

Pre-existing gap, not introduced by the fix: the page has no `## Description` section before `## Animations`, which `.github/agents/animation-page.agent.md` lines 12 and 205 require. HEAD had no such section either, and the original review did not raise it. (Minor, convention.)

### Reproducibility and conventions
- Scratch copies of both changed scripts were rerun. `cmp` shows that both committed GIFs are byte-identical to the output: taylorderivativeaa.gif and taylorderivativebb.gif, 21 frames each.
- One source link and one embed per case, descriptive alt text, no code blocks: all kept. The Description section was already missing before the fix (see above).
- Within this page's diff only files in the page folder changed. Elsewhere in the working tree, files under `reviews/numerical-methods-animations/fixes/` are modified or untracked, but they belong to other pages' fix records and not to this page.

**Final status:** committed
