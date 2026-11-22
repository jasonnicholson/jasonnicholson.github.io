# Fix record: eulers-method-for-odes

The scratch evidence folder is `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/eulers-method-for-odes/fix/` (written `$FIX` below) and can be re-run. To run the Python checks, use `cd $FIX/py && /usr/bin/python3 -I <script>.py`. Each script's output is saved beside it as `<script>.out`.

- `py/reference.py`: computes y(t) with mpmath `odefun` at 30 digits on t = 0.125k and compares scipy Radau, DOP853 and LSODA (rtol 1e-13, atol 1e-16) against it.
- `py/analysis.py`: independent Euler, Heun and explicit-midpoint solvers, plus:
  - sympy ∂f/∂y and J along the solution;
  - stability limits;
  - instability onset for each step size;
  - a sweep over n (y(5), largest error, lowest stage value, monotonicity after the peak);
  - Mathews' archive y(5) values reproduced;
  - the full per-step table on the old grid (n = 40).
- `py/analysis_lib.py`: the function part of `analysis.py`, so the other scripts can import it.
- `py/chosen.py`: on the new grid (n = 200), the sign runs of the error, the largest errors on sub-ranges and the frame values. On the old grid (n = 40), the facts behind the phrases quoted on the page.
- `py/cmp.py`: compares the fixed scripts' own iterates and RK4 reference with the independent results, checks that the exact solution stays positive, and computes the order ratios.
- `inst_aa.jl` and `inst_bb.jl`: the fixed scripts with the plotting removed. They print the frame times and labels and dump the iterates and the reference curve on the grid.
- `labels.jl`: crops the m and y(5) labels from Mathews' animation frames.

## Findings

### F1 — Error — fixed
- **Reproduced.** I ran `py/analysis.py`, which has an independent Heun solver, on the old grid (n = 40, h = 0.125).
  - Heun ends at y₄₀ = 0.2506350 against the exact y(5) = 0.00811992046486796, an error of +0.2425.
  - Euler ends at −0.0174406, an error of −0.0256.
  - Heun's error is about 9.5 times Euler's, so the page's claim that Heun "stays closer … at the right endpoint" is false.
  - Up to t = 3.875 Heun's largest |error| is 7.08e-3 (at t = 3.25), against 0.0863 for Euler. After its minimum at t = 3.875 Heun's values rise: errors 0.0106 (t = 4), 0.127 (4.25) and 0.2425 (5).
  - Stability: Heun's stability function is R(z) = 1 + z + z²/2. Its minimum on the real line is 0.5, and `mp.findroot` gives R = 1 at z* = −2, so |R| < 1 exactly on (−2, 0). J = ∂f/∂y = −t/(3y^{2/3}) (checked with sympy) reaches −41.2554 at t = 5, and |J| increases over all of [0, 5]. With h = 0.125, h·J crosses −2 at t = 3.6805.
  - The finding holds. The checker's nuance (Heun tracks much better before t ≈ 4) is confirmed and reflected in the new text.
- **Change.** Decision D2 (default): both scripts now use n = 200 steps (h = 0.025), so both methods are stable up to t = 5. The Case 2 Behavior paragraph is replaced. It now:
  - gives Heun's accuracy at h = 0.025 against Euler's on the same grid;
  - gives Heun's final value;
  - states the stability bound;
  - describes what h = 0.125 does (close tracking to t = 3.875, then the values turn upward to 0.251).

  The Case 2 alt text is rewritten. The GIF title is now "Modified Euler, h = 0.025: …".
- **Check.** `py/cmp.py`:
  - The fixed script's Heun iterates match the independent ones to 2.2e-16.
  - With n = 200 Heun's largest error is 1.784e-4 (t = 3.075), y(5) = 0.0081212783, and the lowest stage value is 8.12e-3 (all stages positive). The values fall strictly after the peak.
  - h·J(5) = −1.031, so R = 0.50 and the step is stable.
  - Frames viewed: see "Scripts and GIFs".

### F2 — Misleading — fixed (with the checker's correction)
- **Reproduced.** I ran `py/analysis.py` on the old grid (n = 40).
  - Euler is above the reference for 0 < t ≤ 2.875. The largest error is +0.0863 at t = 1.75 (peak 1.5083 against 1.4497).
  - Euler is below the reference from t = 3.0 to 3.25, by at most 0.0122 (t = 3.125).
  - After that the error alternates in sign from t ≈ 3.875. The values fall strictly until t = 4.25, then zig-zag: y₃₈ = −0.00710 at t = 4.75, y₃₉ = 0.231996 at t = 4.875 and y₄₀ = −0.0174406 at t = 5.
  - The checker's correction holds: Euler is already negative at t = 4.75 as well as at t = 5 (`py/chosen.py`: negative values at t = [4.75, 5.0]).
  - "Drifts low near t = 5" is therefore misleading.
  - Error at t = 5 for n = 20, 40 and 80: +0.714, −0.0256 and −3.2e-6. It does not halve when h is halved.
- **Change.** The same D2 step change as F1 (n = 200, h = 0.025).
  - Case 1 Behavior paragraph replaced. It now:
    - describes the new trace (above the reference until t = 2.9 by at most 0.017, then just below by less than 0.002);
    - gives the final value;
    - adds the D2 sentence: steps longer than about h = 0.0485 become unstable, and h = 0.125 zig-zags after t = 4.25, jumps to 0.232 and ends at −0.0174.
  - Case 1 heading `$n=41$` → `$n=200$ steps ($h=0.025$)`.
  - Intro: "using the legacy module's $n=41$ point setup ($h=0.125$). Each frame adds one new computed point and segment." → "computed with $n=200$ steps ($h=0.025$). Each frame adds five steps (0.125 in $t$); the connecting curve passes through every computed point."
  - Alt text rewritten.
  - GIF title is now "Euler Method, h = 0.025: …".
- **Check.** `py/cmp.py`:
  - The fixed script's Euler iterates match the independent ones to 5.6e-17.
  - `py/chosen.py`, Euler with n = 200: error positive on t = 0.025 … 2.9, negative on 2.925 … 5.0 (two sign runs only). Largest error 0.016814 at t = 1.675. Largest |error| for t ≥ 2.875 is 1.872e-3. y(5) = 0.0081186298. The values fall strictly after the peak (1.461508 at t = 0.9). The lowest value is 8.1186e-3 > 0.
  - h·J(5) = −1.031, so Euler's factor 1 + hJ = −0.031 and |R| < 1 up to t = 5.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd intro | "computed with $n=200$ steps ($h=0.025$)" | script `n_steps = 200`, `h = 5/200`; `inst_aa.out` and `inst_bb.out`: `n_steps=200 h=0.025` | yes |
| index.qmd intro | "Each frame adds five steps (0.125 in $t$)" | script `stride = 5`; `inst_*.out` `frame_t=0.0,0.125,…,5.0`, 41 frames | yes |
| index.qmd intro | "the connecting curve passes through every computed point" | script draws `plot!(ts[1:frame], ys[1:frame])`, where `frame` is a step index (1, 6, 11, …), so the intermediate steps are included | yes |
| index.qmd intro (unchanged, re-checked) | RK4 reference at $h=10^{-4}$ is "high-accuracy" | `py/cmp.py`: script's RK4 reference vs Radau on t = 0.025k, max diff 2.73e-14; at t = 5 it gives 0.008119920464867961, which equals the mpmath 30-digit value 0.0081199204648679610 | yes |
| Case 1 heading | "$n=200$ steps ($h=0.025$)" | as intro | yes |
| Case 1 Behavior | "runs above the dashed RK4 reference until $t=2.9$" | `py/chosen.py`: error sign runs (+1, 0.025, 2.9), (−1, 2.925, 5.0) | yes |
| Case 1 Behavior | "by at most $0.017$ near $t=1.7$" | `py/chosen.py`: max \|err\| 1.6814e-02 at t = 1.675 | yes |
| Case 1 Behavior | "after that it lies just below, by less than $0.002$" | `py/chosen.py`: negative run from 2.925 to 5.0; max \|err\| for t ≥ 2.875 = 1.872e-03 | yes |
| Case 1 Behavior | "$y(5)\approx0.0081186$" | `py/chosen.py` 0.0081186298; the script prints `Final y(5) = 0.008118629840021034` | yes |
| Case 1 Behavior | "the exact $0.0081199$" | `py/reference.py`: mpmath (30 digits) 0.0081199204648679610; Radau, DOP853 and LSODA agree to within 9e-13 on t = 0.125k | yes |
| (superseded in round 2) Case 1 Behavior | "Steps longer than about $h=0.0485$ become unstable before $t=5$" | `py/analysis.py`: h_max = 2/\|J(5)\| = 0.048478 (n_min = 104). \|J\| increases on (0, 5], so h·\|J\| passes 2 before t = 5 exactly when h > h_max: n = 103 (h = 0.04854) has onset t = 4.998, and n = 104 has none. This is linear stability with J frozen at each point. | yes |
| Case 1 Behavior | "$\partial f/\partial y=-t/(3y^{2/3})$" | `py/analysis.py`: sympy diff equals −t/(3y^(2/3)) → True | yes |
| (superseded in round 2) Case 1 Behavior | "grows in magnitude along the solution to $-41.3$ at $t=5$" | `py/analysis.py`: J(5) = −41.2554; \|J\| strictly increasing on 50001 points of [0,5] → True | yes |
| (superseded in round 2) Case 1 Behavior | "Euler is stable only while $h\,\|\partial f/\partial y\|<2$" | R(z) = 1 + z; \|R\| < 1 ⇔ −2 < z < 0 | yes |
| Case 1 Behavior | "the legacy module's $h=0.125$ ($n=40$)" | archive Example 11 code (`Euler'sMethodMod_gr_229.gif`) sets `n = 40` on [0, 5.0]; its table (`gr_233.gif`) has t-steps of 0.125 | yes |
| Case 1 Behavior | "the computed values zig-zag after $t=4.25$" | `py/chosen.py`: n = 40 strictly decreasing from the peak up to t = 4.25, first rise at t = 4.375; `py/analysis.py` table: 4.25→4.375 up, →4.5 down, →4.625 up, →4.75 down, →4.875 up, →5 down | yes |
| Case 1 Behavior | "jump to $0.232$ at $t=4.875$" | `py/analysis.py`: k = 39, t = 4.875, y = 0.231996 | yes |
| Case 1 Behavior | "end at $y(5)\approx-0.0174$" | `py/analysis.py`: −0.0174406; archive GIF frame for m = 40 also prints −0.0174406 | yes |
| Case 1 Behavior | "although the exact solution stays positive" | `py/cmp.py`: min of exact solution over [0,5] = 0.0081199 > 0 | yes |
| Case 1 alt text | "step h = 0.025 (n = 200)", "five steps per frame" | as intro | yes |
| Case 1 alt text | "runs slightly above the dashed RK4 reference over the hump" | error > 0 on (0, 2.9], max 0.0168 (`py/chosen.py`); this is visible in frames 15 and 41 as a magenta curve just above the dashes near the peak | yes |
| Case 1 alt text | "peak about 1.46 near t = 0.9" | `py/chosen.py`: Euler n = 200 peak 1.461508 at t = 0.900 | yes |
| Case 1 alt text | "follows it down to y ≈ 0.0081 at t = 5" | y(5) = 0.0081186; strictly decreasing after the peak → True | yes |
| Case 2 Behavior | "keeps Heun within $1.8\times10^{-4}$ of the dashed RK4 reference" | `py/chosen.py`: Heun n = 200 max \|err\| 1.7838e-04 (t = 3.075) | yes |
| Case 2 Behavior | "against $0.017$ for forward Euler on the same grid" | Euler n = 200 max \|err\| 1.6814e-02 | yes |
| Case 2 Behavior | "it ends at $y(5)\approx0.0081213$" | `py/chosen.py` 0.0081212783; the script prints `Final y(5) = 0.00812127828435098` | yes |
| Case 2 Behavior | "Averaging the slopes at both ends of each step" | script: `k1 = f(ts[i], ys[i])`, `k2 = f(ts[i+1], y_pred)`, `ys[i+1] = ys[i] + 0.5h(k1+k2)` | yes |
| (superseded in round 2) Case 2 Behavior | "Heun has the same stability bound as Euler here, $h\,\|\partial f/\partial y\|<2$" | `py/analysis.py`: R(z) = 1 + z + z²/2, min on the real line 0.5, R = 1 at z* = −2.0 (`mp.findroot`), so \|R\| < 1 ⇔ −2 < z < 0 | yes |
| Case 2 Behavior | "with $h=0.125$ ($n=40$) it stays within $0.0071$ of the reference up to $t=3.875$" | `py/chosen.py`: max \|err\| for t ≤ 3.875 = 7.0800e-03 (t = 3.25) | yes |
| Case 2 Behavior | "then its values turn upward" | `py/chosen.py`: Heun n = 40 strictly decreasing from the peak up to t = 3.875, first rise at t = 4.0 | yes |
| Case 2 Behavior | "end at $y(5)\approx0.251$, about 31 times the exact value" | `py/analysis.py` 0.2506350; `py/chosen.py` y(5)/y_exact(5) = 30.87 | yes |
| Case 2 alt text | "step h = 0.025 (n = 200)", "five steps per frame" | as intro | yes |
| Case 2 alt text | "lies on the dashed RK4 reference throughout" | max \|err\| 1.78e-4. In the 640×480 frame y = 0 is at about pixel row 408 and y = 1.5 at about 45 (read from frame_041), so the scale is about 242 px per unit and the error is about 0.04 px. In frames 25 and 41 the dashes are fully covered by the magenta trace. | yes |
| Case 2 alt text | "rising to about 1.45 near t = 0.9" | `py/chosen.py`: Heun peak 1.449701 at t = 0.875 | yes |
| Case 2 alt text | "falling to y ≈ 0.0081 at t = 5" | y(5) = 0.0081213; strictly decreasing after the peak → True | yes |
| eulersmethodaa.jl and eulersmethodbb.jl comment | "h = 0.025 keeps h*\|df/dy\| below the stability limit 2 up to t = 5 (\|df/dy\| reaches 41.3)" | 0.025 · 41.2554 = 1.031 < 2 | yes |
| both scripts' comment | "each frame adds `stride` steps (0.125 in t)" | 5 · 0.025 = 0.125 | yes |
| both scripts' comment | "small margins so the end point at t = 5 is not clipped" | frame_041 of both GIFs: the marker at (5, 0.0081) is fully inside the frame | yes |
| GIF titles | "Euler Method, h = 0.025: y' = 1 - t*cbrt(y), y(0)=1" and "Modified Euler, h = 0.025: y' = 1 - t*cbrt(y), y(0)=1" | frames 1, 15, 25 and 41 viewed: titles fit inside 640 px and are legible | yes |
| GIF legend label (code unchanged, new values) | "y_0", "y_5", …, "y_200" | `inst_*.out` labels list; frame 15 shows "y_70" at t = 1.75 = 70·0.025 | yes |
| Description (unchanged, re-checked) | "for smooth problems … global error O(h) … Heun … O(h²)" | `py/cmp.py`: largest-error ratios as h halves (n = 100→800) are Euler 2.01, 2.01, 2.00 and Heun 4.41, 4.18, 4.09 | yes |

## Scripts and GIFs
- **Scripts changed:** `eulersmethodaa.jl` and `eulersmethodbb.jl`, with identical edits:
  - `n_pts = 41` → `n_steps = 200`, `n_pts = n_steps + 1`, and a new `stride = 5`;
  - the loop `1:n_pts` → `1:stride:n_pts`;
  - `xlims` → `(t0 - 0.1, tf + 0.1)`;
  - new titles.

  The solver code, the reference, the colours, fps = 2 and the `@__DIR__` output paths are unchanged.
- **GIFs regenerated:** `eulersmethodaa.gif` and `eulersmethodbb.gif`. Each still has 41 frames at t = 0.125k, the same frame count and duration as before.
- **Frames.** They were extracted to `$FIX/new_aa/` and `$FIX/new_bb/`. The old frames are in `$FIX/orig_aa/` and `$FIX/orig_bb/`.
  - Euler, `new_aa`:
    - The contact sheet shows a smooth build-up from (0, 1). The magenta trace sits visibly just above the dashed reference over the hump, then lies on it down to t = 5. There is no zig-zag and no negative value.
    - Frame 15 (label y_70, t = 1.75): the gap above the reference is visible.
    - Frame 41 (label y_200): the end marker at (5, 0.0081) is fully visible.
  - Heun, `new_bb`:
    - Frame 1 shows the start marker y_0 at (0, 1).
    - Frame 25 shows y_120 at t = 3.0.
    - In frame 41 (y_200) the magenta trace hides the dashed reference over the whole range, and the end marker is inside the frame.
  - In both GIFs the title and legend are legible and the legend does not cover the trace.
- **git status after regeneration** (`git status --short -- pages/numerical-methods/eulers-method-for-odes`):
  ```
   M pages/numerical-methods/eulers-method-for-odes/eulersmethodaa.gif
   M pages/numerical-methods/eulers-method-for-odes/eulersmethodaa.jl
   M pages/numerical-methods/eulers-method-for-odes/eulersmethodbb.gif
   M pages/numerical-methods/eulers-method-for-odes/eulersmethodbb.jl
   M pages/numerical-methods/eulers-method-for-odes/index.qmd
  ```
  This is the expected set. Both scripts were changed, so both GIFs were expected to change.

## Legacy archive
**Consulted.** I read `n2003/Euler'sMethodMod.html` and Links `_lnk_12.html` (Example 11, Euler) and `_lnk_13.html` (Example 12, Modified Euler). I viewed their code and table images: `gr_40`, `gr_42`, `gr_229`, `gr_233`, `gr_255` and `gr_269`. I also extracted the frames of the animations `a2001/Animations/OrdinaryDE/Euler1/Euleraa.gif` (30 frames) and `MEuler1/MEuleraa.gif` (32 frames) to `$FIX/mathews_euler/` and `$FIX/mathews_meuler/`; the label strips are `labels.png` in each.

- **Examples 11 and 12** solve this IVP with n = 40 (h = 0.125) on [0, 5]. They use `f = 1 - t Sign[y] Abs[y]^(1/3)`, which is the real cube root like Julia's `cbrt`. Example 11's Euler table (gr_233) matches the script's old iterates: for example y(4.875) = 0.231996 and y(5) = −0.0174406. So the old page's h = 0.125 was the module's choice, and it is unstable for this problem. The module does not mention stability.
- **The animations are step-count sweeps, not single runs**, like the RK4 one. Each frame shows the whole solution for m subintervals and prints y(5).
  - Euler sweeps m = 10, 15, …, 50, 55, 60, 70, …, 150.
  - Modified Euler sweeps m = 12, 14, …, 60, 70, 80, 90, 100, 120, 150.
  - The coarse-m frames zig-zag or turn up in the tail.
  - Every printed y(5) reproduces exactly (to 7 digits) with an independent solver (`py/analysis.py`, "Mathews' archive values reproduced"): 20 Euler values (for example m = 40 −0.0174406, m = 50 0.0080988, m = 150 0.0081182) and 21 Modified Euler values.
- **Mathews' "Modified Euler" is the explicit midpoint method, not Heun.** The algorithm image gr_40 is y_{k+1} = y_k + h f(t_k + h/2, y_k + (h/2) f(t_k, y_k)), and so is the subroutine gr_42. His animation values match the midpoint method (m = 40: 0.0761463) and not Heun (m = 40: 0.2506350).
  - The site's Case 2 implements Heun and calls it "Modified Euler (Heun)". Several textbooks use that name for Heun's method, the page describes Heun's slope average correctly, and no finding names this. So I left the method as it is.
  - Both are two-stage second-order Runge-Kutta methods with the same R(z) = 1 + z + z²/2. The stability statements on the page therefore hold for either.
  - Jason may want to decide whether Case 2 should follow Mathews' midpoint method instead (see Notes).
- **This fix follows D2's default**: one stable run per method at h = 0.025 (m = 200). That is finer than any frame in Mathews' sweeps, because the stability limit needs m ≥ 104. The page says in one sentence per case what the module's h = 0.125 does.

## Notes
- **Choice of n.** I chose n = 200 over the brief's other suggestion, n = 120.
  - n = 120 is stable too: h·J(5) = −1.719, Euler largest error 0.028, values monotone after the peak.
  - n = 200 leaves more margin: h·J(5) = −1.031. Euler's error factor 1 + hJ stays close to 0 rather than near −0.72. It also gives a round h = 0.025 and keeps the original 41 frames with stride 5.
  - Euler's first-order error is still visible at this step (about 4 px near the peak). Heun's is not (about 0.04 px). That visual contrast matches the text.
- **Legacy archive note on the page (not changed).** The paragraph says `Euleraa.gif` and `MEuleraa.gif` "were missing from the recovered animation folders". In the archive on this machine both files exist; their mtimes are 4 days later than the surrounding HTML, so they may have been recovered after the page was written. The note also says the cases are reconstructed from "Examples 11-12", but Example 12 is the midpoint method and Case 2 is Heun. No finding names this paragraph and the brief leaves the archive notes out of scope, so I did not touch it. Jason may want to update it, and to decide whether Case 2 should use the midpoint method to match Mathews.
- **Convention gaps.** None noticed beyond the pre-existing stubs, which were left untouched.
- **xlims margin.** The end marker at t = 5 used to be half-clipped by the right border. No finding named it. I widened `xlims` by 0.1 on each side, the same small change the Runge-Kutta round 2 made; it is cheap and safe (D5).
- **Outside my page.** I touched nothing outside the page folder and this record.

## Round 2 after check

The independent resolution check confirmed that F1 and F2 are resolved. It raised one new Minor item.

**The D2 sentence read as a sharper threshold than a reader will see.** "Steps longer than about $h=0.0485$ become unstable before $t=5$" is right as a linear-stability threshold. But Euler shows no visible instability until h ≈ 0.1: its error at t = 5 is −2.6e-6 at h = 0.05 and −2.1e-5 at h = 0.1. I followed the director's shared wording (`patterns/d2wording.md`).

- **Change, Case 1 Behavior.** "Steps longer than about $h=0.0485$ become unstable before $t=5$, because … grows in magnitude along the solution to $-41.3$ at $t=5$ and Euler is stable only while $h\,|\partial f/\partial y|<2$: with the legacy module's $h=0.125$ ($n=40$) the computed values …" → "For steps longer than about $h=0.0485$, $h\,|\partial f/\partial y|$ exceeds Euler's stability limit 2 before $t=5$ (because $\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$), and from then on errors are amplified instead of damped; just above $h=0.0485$ this affects only the last steps, but at the legacy module's $h=0.125$ ($n=40$) it starts at $t\approx3.68$ and the computed values …". The rest of the sentence is unchanged.
- **Change, Case 2 Behavior.** The Heun sentence has a similar form, so I changed it the same way. "Heun has the same stability bound as Euler here, $h\,|\partial f/\partial y|<2$: with $h=0.125$ ($n=40$) it stays within …" → "Heun has the same stability limit as Euler, $h\,|\partial f/\partial y|<2$, so at $h=0.125$ ($n=40$) errors are amplified instead of damped from $t\approx3.68$: it stays within …". The rest is unchanged.
- **Scripts and GIFs.** No script or GIF changed in round 2. `git status --short -- pages/numerical-methods/eulers-method-for-odes` shows the same five files as before.

### Round 2 ledger

`py/round2.py` and `round2.out` are new.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 1 | "For steps longer than about $h=0.0485$, $h\,\|\partial f/\partial y\|$ exceeds Euler's stability limit 2 before $t=5$" | `py/round2.py`: h_max = 2/\|J(5)\| = 0.0484785. \|J\| is strictly increasing on [0,5] (`py/analysis.py`), so h\|J(t)\| > 2 for some t < 5 exactly when h > h_max: n = 103 has onset 4.9978, and n = 104 has none | yes |
| Case 1 | "Euler's stability limit 2" | R(z) = 1 + z; \|R\| < 1 ⇔ −2 < z < 0 | yes |
| Case 1 | "$\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$" | `py/analysis.py`: sympy check → True; J(5) = −41.2554 | yes |
| Case 1 | "from then on errors are amplified instead of damped" | \|J\| is increasing, so once h\|J\| > 2 it stays above 2 to t = 5. `py/round2.py` for h = 0.125 on [onset, 5]: min \|1+z\| = 1.0000 (equal to 1 only at the onset), so the Euler factor has \|R\| ≥ 1 throughout. This is linear stability with J frozen at each point. | yes |
| Case 1 | "just above $h=0.0485$ this affects only the last steps" | `py/round2.py`: n = 100 (h = 0.05) onset 4.9495, 1 step from a grid point past the onset; n = 103 onset 4.9978, crossing only inside the last step. Euler error at t = 5: −2.56e-6 (n = 100), −2.48e-6 (n = 103), −2.11e-5 (n = 50); the stable n = 104 gives −2.46e-6 | yes |
| Case 1 | "at the legacy module's $h=0.125$ ($n=40$) it starts at $t\approx3.68$" | `py/round2.py`: onset(0.125) = 3.6805 (brentq on h·J(t) = −2 along the exact solution) | yes |
| Case 1 (unchanged rest) | "zig-zag after $t=4.25$, jump to $0.232$ at $t=4.875$ … $-0.0174$ … exact solution stays positive" | main ledger rows (unchanged) | yes |
| Case 2 | "Heun has the same stability limit as Euler, $h\,\|\partial f/\partial y\|<2$" | `py/analysis.py`: R(z) = 1 + z + z²/2, min on the real line 0.5, R = 1 at z* = −2.0, so \|R\| < 1 ⇔ −2 < z < 0 | yes |
| Case 2 | "at $h=0.125$ ($n=40$) errors are amplified instead of damped from $t\approx3.68$" | `py/round2.py`: onset 3.6805; min \|1+z+z²/2\| on [onset, 5] = 1.0000 (equal to 1 only at the onset) | yes |
| Case 2 (unchanged rest) | "stays within $0.0071$ … up to $t=3.875$ … turn upward … $0.251$ … 31 times" | main ledger rows (unchanged). This is consistent with the amplification starting at 3.68: the error grows from 4.40e-3 (t = 3.625) to 4.68e-3 (3.75), 6.19e-3 (3.875) and 1.06e-2 (4.0) (`py/analysis.py` table) | yes |

### Director note

Archive items from the fixer for Jason (not changed): Mathews' 'Modified Euler' is the explicit midpoint method (his printed y(5) values reproduce with midpoint, not Heun); the page uses Heun and names it as such, with the same stability limit. The page's archive note says Euleraa.gif / MEuleraa.gif were missing, but both are present in the archive now.

## Resolution check (independent checker, not shown this record)

Work files: `check/indep.py` (independent Euler/Heun, Radau rtol 1e-12 and mpmath `odefun` references), `check/scan.py` (step-size scan), `check/run/` (scratch runs of both scripts), `check/fr_aa/`, `check/fr_bb/` (decoded frames).

Exact y(5) = 0.00811992046486796 (mpmath, 30 digits); Radau gives the same to 1e-16, and so does the script's RK4 reference (0.008119920464867961).

### Original findings

### F1 — resolved
- The false sentence ("stays closer to the dashed RK4 reference at the right endpoint") is gone.
- Both scripts now use h = 0.025 (n = 200 steps), and the new Case 2 text describes that run. My independent Heun at h = 0.025 has max |error| 1.784e-4 (at t = 3.075) and ends at 0.00812128. On the same grid, Euler's max |error| is 1.681e-2. So "within 1.8e-4 … against 0.017 for forward Euler … ends at 0.0081213" is correct. Along the numerical solution, max h|df/dy| = 1.03 < 2, so this run is stable.
- The legacy h = 0.125 behaviour is now described correctly:
  - max |error| up to t = 3.875 is 0.00708 ("within 0.0071").
  - y turns upward at t = 4.0 (0.02415 → 0.02688).
  - y_40 = 0.250635, which is 30.87 times the exact value ("about 31 times").
- "Same stability bound as Euler, h|df/dy| < 2" is correct. On the negative real axis, Heun's R(z) = 1 + z + z²/2 satisfies |R| ≤ 1 exactly for z in [−2, 0].
- GIF: the final frame of `eulersmethodbb.gif` shows the magenta trace covering the dashed reference over [0, 5]. It ends at y_200 ≈ 0.008, with no upturn.

### F2 — resolved
- "Drifts low near t = 5" and "accumulates first-order global error" are gone.
- Euler at h = 0.025, from my own computation:
  - The error is positive through t = 2.9 and negative at every grid point from t = 2.925 to t = 5, as the page says ("above until t = 2.9").
  - The largest error is +0.01681 at t = 1.675 ("at most 0.017 near t = 1.7").
  - On (2.9, 5] the error lies in [−0.00187, −1.3e-6] ("just below, by less than 0.002").
  - y_200 = 0.00811863 ("≈ 0.0081186").
- The legacy h = 0.125 description is also correct:
  - From t = 4.25 the y values alternate direction: 0.01294, 0.01321, 0.00893, 0.01723, −0.00709 ("zig-zag after t = 4.25").
  - y_39 = 0.23200 at t = 4.875, and y_40 = −0.017441.
  - The exact solution stays positive, since y' = 1 > 0 whenever y = 0.
- df/dy = −t/(3y^{2/3}) at the exact y(5) is −41.255 ("−41.3"), and 2/41.255 = 0.04848 ("about h = 0.0485").
- GIF: in `eulersmethodaa.gif` the magenta trace runs visibly a little above the reference over the hump (peak 1.4615 at t = 0.9, against the true 1.4498 at t = 0.884), then follows it down to about 0.008 at t = 5. It has no spike and no negative values, which matches the new text and alt text.
- The fixer took the brief's "use a smaller step" alternative. The page states the change (n = 200, h = 0.025) in the intro, in both headings and in both titles, and describes the legacy h = 0.125 failure in prose.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd 28–29 | n = 200 steps, h = 0.025 | script: n_steps = 200, h = 5/200 | correct |
| index.qmd 29–30 | five steps per frame (0.125 in t); curve passes through every computed point | script: `1:stride:n_pts` with stride 5 gives 41 frames, last index 201; it plots `ts[1:frame]` | correct |
| index.qmd 38 | Case 1 heading: n = 200 steps (h = 0.025) | script | correct |
| index.qmd 40 | above the reference until t = 2.9 | last positive error at t = 2.9, first negative at 2.925 | correct |
| index.qmd 41 | at most 0.017 near t = 1.7 | 0.016814 at t = 1.675 | correct |
| index.qmd 41 | after that below by less than 0.002 | error on (2.9, 5] is in [−0.001872, −1.3e-6] | correct |
| index.qmd 42 | y(5) ≈ 0.0081186 against exact 0.0081199 | 0.00811863 (Python and Julia); exact 0.00811992 (mpmath) | correct |
| index.qmd 42–43 | steps longer than about h = 0.0485 become unstable before t = 5 | 2/41.255 = 0.04848: correct as the linear absolute-stability threshold. In practice Euler shows no visible instability until h ≈ 0.104; see N1 | correct but over-sharp (N1) |
| index.qmd 43–44 | df/dy = −t/(3y^{2/3}), reaching −41.3 at t = 5 | derivative of 1 − t·y^{1/3}; value −41.255 | correct |
| index.qmd 44–45 | Euler stable only while h\|df/dy\| < 2 | \|1 + z\| ≤ 1 on the real axis ⇔ z in [−2, 0] | correct |
| index.qmd 45 | legacy module's h = 0.125 (n = 40) | inherited from the old text ("n = 41 points, h = 0.125"); the legacy example parameters are formula images, not re-verified | unchanged in substance |
| index.qmd 46 | zig-zag after t = 4.25 | y: 0.01294 (4.25), 0.01321, 0.00893, 0.01723, −0.00709 | correct |
| index.qmd 46 | jump to 0.232 at t = 4.875 | y_39 = 0.23200 | correct |
| index.qmd 47 | ends at y(5) ≈ −0.0174; exact stays positive | y_40 = −0.017441; y' = 1 at y = 0 | correct |
| index.qmd 51 alt | h = 0.025 (n = 200); five steps per frame; slightly above over the hump; peak about 1.46 near t = 0.9; ends ≈ 0.0081 | Euler peak 1.4615 at t = 0.900; end 0.008119; frames 21 and 41 | correct |
| index.qmd 55–56 | Heun within 1.8e-4 of the reference | 1.784e-4 | correct |
| index.qmd 56 | against 0.017 for Euler on the same grid | 0.01681 | correct |
| index.qmd 57 | Heun y(5) ≈ 0.0081213 | 0.00812128 | correct |
| index.qmd 57–58 | Heun has the same stability bound h\|df/dy\| < 2 | R(z) = 1 + z + z²/2 is stable on the real axis for [−2, 0] | correct |
| index.qmd 58–59 | h = 0.125: within 0.0071 up to t = 3.875 | 0.007080 | correct |
| index.qmd 59 | then turns upward | 0.02415 (3.875) → 0.02688 (4.0) → 0.04395 → 0.1404 … | correct |
| index.qmd 60 | ends ≈ 0.251, about 31 times exact | 0.250635 / 0.0081199 = 30.87 | correct |
| index.qmd 64 alt | lies on the reference throughout; peak about 1.45 near t = 0.9; ends ≈ 0.0081 | Heun peak 1.4497 at t = 0.875; max error 1.8e-4 (under 0.1 px); frame 41 | correct |
| both .jl line 31 comment | h = 0.025 keeps h\|df/dy\| below 2 up to t = 5; \|df/dy\| reaches 41.3 | max h\|J\| along the numerical solution is 1.031 | correct |
| both .jl line 46 | xlims margin of 0.1 so the end point is not clipped | frame 41: the y_200 marker is fully visible at t = 5 | correct |
| aa.jl title | "Euler Method, h = 0.025: …" | legible in frames 1, 21, 41 | correct |
| bb.jl title | "Modified Euler, h = 0.025: …" | legible in frame 41 | correct |

### New problems

### N1 — Minor — index.qmd lines 42–43: "Steps longer than about h = 0.0485 become unstable before t = 5"
- This is true as the linear absolute-stability threshold: for any h > 0.0485, h|df/dy| > 2 on some final stretch of [0, 5].
- It reads as a sharp practical threshold, and for Euler it is not one. I scanned h = 5/n:

  | h | Error at t = 5 | Increments alternate after t = 3? |
  |---|---|---|
  | 0.05 | −2.6e-6 | no |
  | 0.0625 | −3.2e-6 | no |
  | 0.0833 | −4.2e-6 | no |
  | 0.1 | −2.1e-5 | no |
  | 0.104 | −8.7e-4 | no, but the error starts changing sign |
  | 0.114 | +0.026 | yes, visible zig-zag |

  The region where |1 + hJ| > 1 is too short for the growth to show at moderate h. A reader who tries h = 0.05 sees nothing unstable.
- Suggested wording: "steps longer than about 0.0485 leave Euler's stability interval before t = 5 (visible oscillation appears near h ≈ 0.1)". Heun degrades earlier: its error at t = 5 is 6.9e-4 at h = 0.0625 and 9.0e-3 at h = 0.0714.
- This does not affect the fix of F1 or F2.

No other new problems. This rests on: every changed sentence and number checked above by independent computation; frames 1, 21 and 41 of aa and frame 41 of bb viewed at full size (titles and legends legible, y_k labels correct, e.g. y_100 at t = 2.5, end marker not clipped); and both GIFs reproduced byte for byte.

### Reproducibility and conventions
- I ran both scripts from scratch copies (`check/run/`). `cmp` shows both outputs byte-identical to the committed `eulersmethodaa.gif` and `eulersmethodbb.gif`. Each GIF has 41 frames at 640×480. The script printouts give y(5) = 0.008118629840021034 (Euler) and 0.00812127828435098 (Heun); the reference is 0.008119920464867961.
- Conventions:
  - Description comes before Animations.
  - Each case has a `[Julia source]` link and a GIF embed.
  - The alt text is descriptive.
  - There are no code blocks.
- Files changed: `git diff HEAD` shows no tracked changes outside `pages/numerical-methods/`. Within this page, only the five page-folder files changed. The untracked `reviews/numerical-methods-animations/fixes/*.md` files are process notes, not site pages.
- Design note (not a problem): the animations no longer use the legacy step h = 0.125. The legacy behaviour is now described only in prose. This is the brief's offered alternative, and the page states it clearly.

### Re-check

This round changed only the wording of the two stability sentences in index.qmd (lines 42–48 and 57–61).
- md5 hashes of both `.jl` scripts and both GIFs match my earlier scratch runs, so the byte-identical reproduction still holds.
- The rest of the page is unchanged from the first check.
- The work is in `check/recheck.py`.

### N1 — resolved
The new wording drops the implied sharp practical threshold. It says that for h > about 0.0485, h|∂f/∂y| exceeds 2 before t = 5, and that just above 0.0485 this affects only the last steps. Both statements are true:
- Along the exact solution, |∂f/∂y| increases strictly on [0.9, 5].
- At h = 0.05, h|J| first reaches 2 at t = 4.9495, so only the last step is affected.
- At h = 0.0485 it first reaches 2 at t = 4.9993.

### New or changed numbers
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd 42–44 | for h longer than about 0.0485, h\|∂f/∂y\| exceeds 2 before t = 5; ∂f/∂y reaches −41.3 | 2/41.255 = 0.04848; \|J\| is monotone, so the crossing comes before t = 5 exactly when h > 0.04848 | correct |
| index.qmd 45 | "from then on errors are amplified instead of damped" | Euler: \|1+z\| > 1 for z < −2, and \|J\| keeps increasing after the crossing. The linearised statement is correct. | correct |
| index.qmd 45–46 | "just above h = 0.0485 this affects only the last steps" | the crossing is at t = 4.95 for h = 0.05 and at t = 4.60 for h = 0.0625 | correct |
| index.qmd 46–47 | at h = 0.125 it starts at t ≈ 3.68 | h\|J\| = 2 at t = 3.6805 along the exact solution. On the Euler iterates the first grid point with h\|J\| > 2 is t = 3.75. Error sign alternation is visible from t = 3.625. | correct |
| index.qmd 47–48 | zig-zag after 4.25, 0.232 at 4.875, end −0.0174 | unchanged; verified earlier | correct |
| index.qmd 57–59 | Heun has the same limit, h\|∂f/∂y\| < 2; at h = 0.125 errors are amplified from t ≈ 3.68 | \|1+z+z²/2\| > 1 for z < −2; 3.6805 along the exact solution. Heun's own iterates turn upward after t = 3.875, so h\|J\| evaluated on them stays below 2. The sentence holds for propagation of error about the exact solution, which is what it describes. | correct |
| index.qmd 59–61 | within 0.0071 to 3.875; ends at 0.251, about 31 times exact | unchanged; verified earlier (0.00708; 0.250635 is 30.87 times exact) | correct |

### Status
- **F1:** still resolved.
- **F2:** still resolved.
- **New problems:** none. This rests on checking every changed sentence and number above, and on the scripts and GIFs being unchanged.

**Final status:** committed
