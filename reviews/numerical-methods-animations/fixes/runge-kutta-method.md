# Fix record: runge-kutta-method

Scratch evidence folder (re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/runge-kutta-method/fix/` (below: `$FIX`). Python checks are run as `cd $FIX/py && /usr/bin/python3 -I <script>.py`; each script's output is saved beside it as `<script>.out`.

- `py/reference.py`: high-precision reference (mpmath `odefun` at 30 digits; scipy Radau, DOP853 and LSODA at rtol 1e-13 compared against it).
- `py/ref_dps.py`: y(5) at mpmath 30 and 45 digits.
- `py/analysis.py`: independent RK4, stability limit, ∂f/∂y along the solution, instability onset by step size, error and stage tables for n = 12…640, order ratios, and the n = 80 values at the frame times.
- `py/misc.py`: sympy ∂f/∂y and the nullcline, distance to the nullcline, and the RK4 n = 80 peak.
- `py/peak.py`: peak of the exact solution.
- `py/limits.py`: real-axis stability limits for Euler, Heun, Taylor 3 and RK4, and the minimum n.
- `rk4_instrumented.jl`: the fixed script's own computation, with the plotting removed and stage and label printing added.

## Findings

### F1 — Error — fixed
- **Reproduced:** `py/analysis.py` (independent RK4) at n = 20 gives y(5) = 0.2891074072, against the exact y(5) = 0.00811992046486796 (mpmath, 30 and 45 digits agree to 25 digits). The error is 0.281. The n = 20 trace has its minimum at t = 3.25 (0.0500) and then rises: 3.5: 0.0975, 4.25: 0.1567, 4.5: 0.2457, 4.75: 0.1603, 5: 0.2891. The lowest stage value is −0.5497. The RK4 real-axis stability limit is z* = −2.785293563 (`mp.findroot(R(z)-1)`), and |R| < 1 on (z*, 0). Along the exact solution J = ∂f/∂y = −t/(3y^{2/3}) reaches −41.2554 at t = 5, and |J| increases over the whole of [0, 5]. With h = 0.25, h·J crosses z* at t = 3.342. The committed GIF's last frame reads "t=5.0 y≈0.2891" (`$FIX/orig_gif/frame_021.png`). The finding holds. The independent check's correction does not change it.
- **Change:** `rungekuttaaa.jl`:
  - `n = 20` → `n = 80` (h = 0.0625), with a comment giving the reason.
  - New `stride = 4`. The animation loop `1:n+1` → `1:stride:n+1`, so each frame adds 4 steps (0.25 in t). The frame count stays at 21 and fps at 3. The line is still drawn through every computed point (`ts[1:frame]`).
  - Title `"RK4: y' = 1 - t·y^{1/3},  y(0) = 1"` → `"RK4, h = 0.0625: y' = 1 - t·y^(1/3),  y(0) = 1"`. GR printed the braces `{1/3}` literally, so they are replaced with `^(1/3)`.
  - GIF regenerated.
- **Check:**
  - `julia rk4_instrumented.jl`: n = 80, lowest stage value +8.0948e-3 (no stage goes negative); 21 frames; values fall strictly after the peak at t = 0.875; y(5) = 0.0081267.
  - `py/analysis.py` gives the same numbers independently. Error at t = 5 is 6.805e-6, and the largest error over the 81 step points is 1.289e-5 (near t = 3.25).
  - h·J(5) = −2.578, so R = 0.730 and the step is stable up to t = 5.
  - Frames viewed: see "Scripts and GIFs".

### F2 — Error — fixed (with the checker's correction)
- **Reproduced:** `py/analysis.py` step-halving at t = 5 gives 0.2891074 (n=20), 0.0698482 (n=40), 0.0081267 (n=80) and 0.0081201 (n=160). The error ratios are 0.281/0.0617 = 4.55, then 9070, so the error is not fourth order with h = 0.25 over [0,5]. The sentence "tracks this with fourth-order accuracy even with … h=0.25" is false. The checker's correction applies: "fixed curve" is a wording problem. `py/misc.py` (sympy) gives f(t, 1/t³) = 0, while d/dt(1/t³) = −3/t⁴, so y = 1/t³ is the nullcline and not a solution. The solution is drawn toward it: y − 1/t³ = 5.28e-2, 6.11e-4 and 1.20e-4 at t = 3, 4 and 5.
- **Change:** `index.qmd`:
  - Behavior paragraph: "fixed curve where $y=1/t^3$" → "nullcline $y=1/t^3$ (where $y'=0$)". The h = 0.25 sentence is replaced by an accuracy sentence for h = 0.0625 and the D2 sentence on coarser steps.
  - Heading `$n=20$ steps` → `$n=80$ steps ($h=0.0625$)`.
  - Intro: "Each frame adds one new solution point; the connecting curve reveals the numerical trajectory." → "Each frame adds four RK4 steps (0.25 in $t$); the connecting curve passes through every computed point."
  - Alt text rewritten.
  - Every number is checked in the ledger.
- **Check:** the ledger below. The new text matches the regenerated frames (21 frames; the last label is "t=5.0 y≈0.0081").

### F3 — Minor — fixed
- **Reproduced:**
  - `py/analysis.py` one-step (local) error from the exact y, halving h from 0.2 down to 0.0125. At t0 = 1 the ratios are 32.52, 32.45, 32.29 and 33.43; at t0 = 2.5 they are 45.99, 37.88, 34.72 and 33.30. Both approach 2⁵ = 32, so the local error is O(h⁵).
  - Global error at t = 5, stable regime, n = 80→160→320→640→1280: ratios 52.41, 21.74, 18.64 and 17.31. The largest error on the grid gives 19.42, 17.65, 16.81 and 16.40. Both approach 2⁴ = 16, so the global error is O(h⁴).
  - "O(h⁴) local accuracy" names the wrong kind of error. The finding holds.
- **Change:** `index.qmd` intro: "— giving $O(h^4)$ local accuracy." → "— for smooth $f$ this gives $O(h^5)$ local truncation error and $O(h^4)$ global error." The statement is general and labelled as such. It also holds here: f is smooth for y > 0, and the RK4 n = 80 values stay ≥ 0.0081.
- **Check:** the ratios above. Mathews' module page states the same thing (local truncation error of order h⁵, global error of order h⁴; the formulas are images, and the theorem text is in `RungeKuttaMod.html`).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd intro | "Each frame adds four RK4 steps (0.25 in $t$)" | script: `stride = 4`, h = 5/80 = 0.0625, 4·0.0625 = 0.25; `rk4_instrumented.jl` prints frame t = 0, 0.25, …, 5.0 (21 frames) | yes |
| index.qmd intro | "the connecting curve passes through every computed point" | script draws `plot!(ts[1:frame], ys[1:frame])` with `frame` a step index, so the intermediate steps are included | yes |
| index.qmd intro | "for smooth $f$ … $O(h^5)$ local truncation error and $O(h^4)$ global error" | `py/analysis.py`: local ratios → 32 (33.43, 33.30 at h = 0.0125); global ratios → 16 (17.31 at t=5, 16.40 max-error) | yes |
| index.qmd heading | "$n=80$ steps ($h=0.0625$)" | script `n = 80`, `h = (5-0)/80 = 0.0625`; instrumented prints `n=80 h=0.0625` | yes |
| index.qmd Behavior | "nullcline $y=1/t^3$ (where $y'=0$)" | `py/misc.py`: sympy f(t,1/t³) = 0 | yes |
| index.qmd Behavior | "pulls $y$ toward the nullcline" (kept verb) | `py/misc.py`: y − 1/t³ = 5.28e-2, 6.11e-4, 1.20e-4 at t = 3, 4, 5 | yes |
| index.qmd Behavior | "within $1.3\times10^{-5}$ of the exact solution" | `py/analysis.py`: n=80 maxerr over 81 points = 1.289e-5 | yes |
| index.qmd Behavior | "$y(5)\approx0.0081267$" | `py/analysis.py` 0.0081267250; `rk4_instrumented.jl` raw 0.0081267 | yes |
| index.qmd Behavior | "the exact $0.0081199$" | `py/ref_dps.py`: 0.008119920464867961003 (dps 30 = dps 45); Radau/DOP853/LSODA agree within 5e-17 | yes |
| index.qmd Behavior | "Steps longer than about $h=0.0675$ become unstable once the solution flattens toward the nullcline" (round 2 wording) | h_max = 2.7852936/41.2554 = 0.067513 (`py/analysis.py` "h must be below 0.06751"; `py/limits.py`); \|J\| is increasing, so for h > h_max the bound h\|J\| < 2.785 fails before t = 5 and for h ≤ h_max it never fails (n = 74 onset t = 4.999; n = 75, h = 0.0667: no onset).  `py/analysis.py`: y′ = −0.90 at t=2 vs −0.057 at t=3.34 (onset for h=0.25), −0.005 at t=5; onset t for n = 12/20/40/60/70 = 3.10/3.34/4.09/4.67/4.91, all after the solution has flattened; n=20…52 traces are not monotone after the peak and have negative stage values; n ≥ 60 traces are monotone | yes |
| index.qmd Behavior | "$\partial f/\partial y=-t/(3y^{2/3})$" | `py/misc.py` sympy: diff equals −t/(3y^{2/3}) → True | yes |
| index.qmd Behavior | "grows to $-41.3$ at $t=5$" | `py/analysis.py`: J(5) = −41.2554; \|J\| increasing on all of [0,5] | yes |
| index.qmd Behavior | "RK4 is stable only while $h\,\|\partial f/\partial y\|<2.785$" | `py/analysis.py`: R(z)=1 at z* = −2.785293563, \|R\|<1 on (z*,0) (max 0.999999999). This is linear stability with J frozen at the current point; n=74 (h·J(5) = −2.788, R = 1.0034) passes it only in the last step and shows no visible growth (max error 1.8e-5) | yes |
| index.qmd Behavior | "with $h=0.25$ ($n=20$) the computed values turn upward after $t=3.25$" | `py/analysis.py` n=20: 3.00: 0.0914, 3.25: 0.0500, 3.50: 0.0975, 3.75: 0.1221 | yes |
| index.qmd Behavior | "end at $y(5)\approx0.289$" | `py/analysis.py` n=20: 0.2891074072 (Mathews' GIF also shows 0.2891074 for m = 20) | yes |
| index.qmd alt text | "step h = 0.0625" | as heading | yes |
| index.qmd alt text | "four RK4 steps per frame" | as intro | yes |
| index.qmd alt text | "rising to about 1.45 near t = 0.9" | `py/misc.py`: RK4 n=80 max 1.449725 at t = 0.875; `py/peak.py`: exact peak 1.449767 at t = 0.8836 | yes |
| index.qmd alt text | "then falling smoothly toward y ≈ 0.0081 at t = 5" | `py/misc.py`: RK4 values strictly decreasing after peak; y(5) = 0.0081267; frame_021 viewed | yes |
| rungekuttaaa.jl comment | "h = 0.0625 keeps h*\|df/dy\| below RK4's limit 2.785 up to t = 5" | 0.0625·41.2554 = 2.578 < 2.785 (`py/misc.py`) | yes |
| rungekuttaaa.jl comment | "each frame adds `stride` RK4 steps (0.25 in t)" | 4·0.0625 = 0.25 | yes |
| GIF title | "RK4, h = 0.0625: y' = 1 - t·y^(1/3),  y(0) = 1" | frames 1, 8, 14, 17, 21 viewed: title fits within the 640 px frame, no literal braces | yes |
| GIF label (unchanged code, new values) | "t=5.0  y≈0.0081" etc. | `rk4_instrumented.jl` prints all 21 labels; each equals the RK4 value rounded to 4 decimals (e.g. 0.0384728 → 0.0385, 0.0199687 → 0.02) | yes |

## Scripts and GIFs
- Script changed: `rungekuttaaa.jl`. GIF regenerated: `rungekuttaaa.gif` (21 frames, as before).
- Frames extracted to `$FIX/new_gif/` and viewed at full size:
  - Frame 1 is the start point (0, 1) with the label "t=0.0 y≈1.0".
  - Frame 8 is at t = 1.75, label y≈1.0728.
  - Frame 14 is at t = 3.25, label y≈0.0385.
  - Frame 17 is at t = 4.0, label y≈0.0162.
  - Frame 21 is at t = 5.0, label y≈0.0081.
  - The contact sheet (`sheet.png`) shows a smooth rise to about 1.45 and then a monotone fall that flattens near zero after t ≈ 3.2. There is no upturn or zig-zag. Every label matches `rk4_instrumented.out`. The title fits and is legible. The red marker sits on the trace's end point.
- The old GIF's frames are in `$FIX/orig_gif/` (frame 21: zig-zag, "t=5.0 y≈0.2891").
- `git status --short -- pages/numerical-methods/runge-kutta-method` after regeneration:
  ```
   M pages/numerical-methods/runge-kutta-method/index.qmd
   M pages/numerical-methods/runge-kutta-method/rungekuttaaa.gif
   M pages/numerical-methods/runge-kutta-method/rungekuttaaa.jl
  ```
  These are exactly the expected files. The page has only one script and one GIF.

## Legacy archive
Consulted: `n2003/RungeKuttaMod.html` and Links `_lnk_11.html` and `_lnk_12.html` (Example 11 is this IVP, and its Animation 1 links to the portal). I also consulted the animation `a2001/Animations/OrdinaryDE/RungeKutta1/RungeKuttaaa.gif`, frames extracted to `$FIX/mathews_gif/` (`sheet.png` and `labels.png`).

- **Mathews' animation is a step-count sweep, not a single run.** Each frame shows the whole RK4 solution of y′ = 1 − t·∛y, y(0) = 1 on [0,5] for one number of subintervals m. The frames step m upward: 12, 14, 16, 18, 20, 24, 28, …, 48 (most held for two frames), then 52, 56, 60, 70, 80, 90, 100, 120, 150. Each frame prints "y(5) = …".
- **His coarse-m frames show the same tail instability.** The curves turn up and zig-zag after t ≈ 3 for m ≤ 52 and settle for m ≥ 60.
- **His printed y(5) values match an independent RK4 to all 7 printed digits** (`py/analysis.py`): m=12 0.5883471, 20 0.2891074, 40 0.0698482, 56 0.0098571, 60 0.008463, 80 0.0081267, 100 0.0081213 and 150 0.0081201.
- **The page's old n = 20 was simply Mathews' m = 20 frame.** That frame is unstable. The archive does not mention stability; its point is that the values change as m grows.
- **This fix follows D2's default:** one stable run with h = 0.0625 (m = 80, which appears in Mathews' sweep with y(5) = 0.0081267, the same as the new final value). The page says in one sentence that the coarse step goes unstable.
- The archive's step-count sweep would be a good animation for the D2 alternative, but this fix does not reproduce it.
- **The module page's error theorem** (local truncation error of order h⁵, global error of order h⁴) agrees with the F3 fix.

## Notes

- **Reference curve.** The round-1 review suggested also drawing the reference solution. I did not add it. With n = 80 the largest error is 1.3e-5, so on a 0–1.8 axis at 480 px a reference curve would sit under the trace (less than 0.01 px apart). It would only show at the coarse steps. This is the smallest change consistent with D2.
- **Value labels.** The labels keep the original `round(y; digits=4)`. Tail values therefore show 2 to 3 significant figures (e.g. "y≈0.02" for 0.0199687 and "y≈0.0081"). These are correctly rounded, not false. Switching to significant-figure formatting would be cosmetic, so I left it.
- **Title braces.** The GIF title's literal `{1/3}` was a pre-existing cosmetic defect that round 1 did not list. I fixed it while editing the title, since it was cheap and safe.
- **Other pages.** Other pages in the working tree (bisection, fixed-point, Newton, trapezoidal, the section index) were already modified by other fixers. I did not touch them.

### D2 pattern for other pages

**(a) Verifying the stability limit and choosing h.**
- **Reference y(5).** `py/reference.py` and `py/ref_dps.py` use `mp.odefun(lambda t,y: 1 - t*mp.cbrt(y), 0, mp.mpf(1))`, mpmath's Taylor-series integrator, at `mp.dps = 30` and again at 45. Both give **y(5) = 0.008119920464867961003**, agreeing to 25 digits. scipy `solve_ivp` with Radau, DOP853 and LSODA at rtol 1e-13 / atol 1e-16 agree with it to within 5e-17 at t = 5 (and within 1e-12 over the t = 0.25k grid). Other reference values: y(3) = 0.0898316681, y(4) = 0.0162357438, y(4.5) = 0.0112304066.
- **Jacobian along the solution.** J = ∂f/∂y = −t/(3y^{2/3}) (sympy-checked), evaluated on the Radau dense output at 50001 points. |J| increases monotonically on [0,5], so the worst case is J(5) = **−41.2554**.
- **Stability limit.** Find the real-axis limit z* of the method's stability function: the most negative z < 0 with |R(z)| = 1, found with `mp.findroot`. `py/limits.py` gives:
  - Euler and Heun: z* = −2, h < 0.048479, n ≥ 104.
  - Taylor 3 / RK3: z* = −2.5127453, h < 0.060907, n ≥ 83.
  - RK4 / Taylor 4: z* = −2.7852936, h < 0.067513, n ≥ 75.
  - In each case h_max = −z*/41.2554 and n_min = ⌈5/h_max⌉.
  - ABM4 PECE was not computed here. It is not a polynomial R, so that page needs its own root-locus check.
- **Onset of instability.** For a given h, solve h·J(t) = z* with brentq along the exact solution (`py/analysis.py`, function `onset`). For RK4: n = 12 → t = 3.103, n = 20 → 3.342, 40 → 4.090, 60 → 4.666, 70 → 4.908, 74 → 4.999; n ≥ 75 has no onset.
- **Choosing h.** Take the next round n above n_min that leaves margin. Then confirm with an independent implementation of the page's method (`py/analysis.py`, function `rk4`) that:
  - every stage value stays positive (cbrt of a negative stage is where the nonsense starts);
  - the trace is monotone after the peak;
  - the largest grid error is small.

  I chose RK4 n = 80, h = 0.0625 (h·J(5) = −2.578, R = 0.730). Lowest stage value +8.09e-3, max error 1.289e-5, y(5) = 0.0081267 (error 6.8e-6). Note that n just below n_min (70, 74) still looks fine, because the instability only acts during the last one or two steps. So "stable to t = 5" is the criterion, not "visibly unstable".

**(b) Frame count.** RK4 is computed at all n = 80 steps. Every 4th step is animated (`stride = 4`, `for frame in 1:stride:n+1`, so n must be a multiple of the stride), and the line is drawn through all computed points `ts[1:frame]`. That keeps the original 21 frames (t = 0, 0.25, …, 5) and fps = 3. For Euler/Heun (n ≥ 104) a natural choice is n = 120 with stride 6, or n = 200 with stride 10. For Taylor 3 (n ≥ 83), n = 100 with stride 5. Each of these keeps 21 frames at t = 0.25k. These suggestions were not run; verify them on the page.

**(c) Sentence used** (adapt the method's limit, the old h, and the computed numbers):

> Steps longer than about $h=0.0675$ become unstable once the solution flattens toward the nullcline, because $\partial f/\partial y=-t/(3y^{2/3})$ grows to $-41.3$ at $t=5$ and RK4 is stable only while $h\,|\partial f/\partial y|<2.785$: with $h=0.25$ ($n=20$) the computed values turn upward after $t=3.25$ and end at $y(5)\approx0.289$.

For another method, replace the threshold h (−z*/41.2554, from `py/limits.py`: Euler/Heun 0.0485, Taylor 3 0.0609), "RK4" and "2.785" (Euler/Heun: 2; Taylor 3: 2.513), the old h and n, the t after which the old trace turns, and the old final value. Compute all of these on that page; they differ by method.

**(d) What Mathews' archive used.**
- **This page.** Mathews' RK4 animation (`a2001/Animations/OrdinaryDE/RungeKutta1/RungeKuttaaa.gif`) does not use one step. It sweeps m = 12 … 150 subintervals on [0,5], showing the whole solution and the printed y(5) for each m. m = 20 (h = 0.25), the old page's choice, is one of the unstable frames. Its printed y(5) values reproduce exactly with plain RK4 (see Legacy archive). The other pages should check their own topic's archive GIF the same way (extract frames, read the m and y(5) labels, reproduce them).

## Round 2 after check

The independent resolution check confirmed that F1, F2 and F3 are resolved. It raised two new Minor items and one note.

1. **The wording overstated the claim.** "Coarser steps become unstable…" was not exactly true: n = 75–79 (h up to 0.0667) are coarser than 0.0625 and still pass the stability criterion.
   - **Change:** index.qmd Behavior: "Coarser steps become unstable once…" → "Steps longer than about $h=0.0675$ become unstable once…". The rest of the sentence is unchanged.
   - **Check:** h_max = −z*/|J(5)| = 2.7852936/41.2554 = 0.067513, which rounds to 0.0675 (`py/analysis.py`, `py/limits.py`).
     - |J| increases monotonically on [0,5] (`py/analysis.py`). So for any h > h_max, h|J| passes 2.785 before t = 5: the onset for n = 74 is t = 4.999. For h ≤ h_max it never passes: n = 75 has no onset.
     - The claim is linear stability with J frozen at each point. For h just above h_max the growth acts only in the last step or two and is not visible (n = 74: max error 1.8e-5). The sentence says "become unstable", which is true in that sense, and does not claim visible divergence.
   - Sentence (c) in "D2 pattern for other pages" was updated to the same wording, with the per-method thresholds.
2. **End marker hidden.** The final marker at (5, 0.0081) was half-clipped by the right border and sat on the y = 0 frame line.
   - **Change:** `rungekuttaaa.jl`: `xlims = (0.0, 5.0)` → `(-0.1, 5.1)` and `ylims = (0.0, 1.8)` → `(-0.05, 1.8)`, with a comment. The GIF was regenerated.
   - **Check:** frames extracted to `$FIX/new_gif2/` (21 frames).
     - Frame 1: the start marker at (0, 1) is fully visible, clear of the left border.
     - Frame 17: the marker at t = 4.0 (y≈0.0162) is visible.
     - Frame 21: the end marker at (5, 0.0081) is fully visible, inside the frame and above the bottom border. The y tick 0.0 now sits slightly above the frame line.
     - The axis ticks are still 0–5 and 0.0–1.5. The title and labels are unchanged.
   - `git status --short -- pages/numerical-methods/runge-kutta-method` shows `M index.qmd`, `M rungekuttaaa.gif` and `M rungekuttaaa.jl`, which is the expected set.
3. **No "## Description" section.** The checker noted that the page has no "## Description" section. This was already the case before this fix and is not a finding, so, as instructed, I did not add one (out of scope).

## Resolution check (independent checker, not shown this record)

Work: `check/chk.py` (independent RK4 in Python plus a DOP853 reference at rtol 1e-13 and a Radau reference at rtol 1e-12, which agree to <1e-12; stage-sign tracking; step halving), the polynomial check of RK4's stability limit, a scratch run of `rungekuttaaa.jl`, and frames from `giftools.jl` in `check/frames/`.

### Original findings

### F1 — resolved
- The script now uses `n = 80`, so h = 0.0625. My independent RK4 with n = 80 has a maximum grid error of 1.289e-5 and gives y(5) = 0.00812673, against the reference 0.00811992. No stage value goes negative for n ≥ 60. Along the true solution, h·∂f/∂y peaks at −2.578 at t = 5, which is inside RK4's real-axis limit of −2.78529 (root of |R(z)| = 1, recomputed).
- The animation shows every 4th point (`1:stride:n+1` gives 1, 5, …, 81, which is 21 frames and includes the endpoint). The line is drawn through all `ts[1:frame]`, so every computed point is on the curve.
- The frame labels match my RK4 values at t = 0, 0.25, …, 5 (for example t=2.5 gives 0.4045, t=3.0 gives 0.0898, t=3.5 gives 0.0254 and t=5.0 gives 0.0081). They also match the exact solution to the 4 digits shown (exact: 0.089832, 0.025358, 0.0081199).
- In the last frame the curve decreases monotonically toward 0 after the peak. The zig-zag and the rise to 0.2891 are gone.
- The optional reference curve was not added. With error ≤1.3e-5 it would sit on top of the trace, so leaving it out does not hurt correctness.

### F2 — resolved
- The false sentence "tracks this with fourth-order accuracy even with … h=0.25" is gone.
- The replacement names h = 0.0625, gives the error bound 1.3e-5 (true: 1.289e-5) and gives y(5) ≈ 0.0081267 against the exact 0.0081199 (true: 0.00812673 and 0.00811992).
- "Fixed curve" became "nullcline $y=1/t^3$ (where $y'=0$)", which is correct.
- The new instability explanation is also correct. At t = 5, ∂f/∂y = −41.255, which rounds to −41.3. The limit is 2.785. With h = 0.25 the values are 0.0500 at t = 3.25 and 0.0975 at t = 3.5, and the final value is 0.28911.
- One wording nit is listed under New problems.

### F3 — resolved
- "$O(h^4)$ local accuracy" became "for smooth $f$ … $O(h^5)$ local truncation error and $O(h^4)$ global error".
- I checked the global order by step halving at t = 5 on this IVP. The error ratios for n = 160→320→640→1280→2560 are 21.7, 18.6, 17.3 and 16.7, approaching 16 (p → 4). A global order of 4 means a local order of 5.
- The qualifier "for smooth $f$" is appropriate, because f is smooth for y > 0, and y stays positive here.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:12 | "Each frame adds four RK4 steps (0.25 in $t$)" | stride = 4, h = 0.0625 → 0.25; frames at t = 0, 0.25, …, 5 | true |
| index.qmd:12 | "the connecting curve passes through every computed point" | `plot!(ts[1:frame], ys[1:frame])` includes the intermediate steps | true |
| index.qmd:12 | "$O(h^5)$ local truncation error and $O(h^4)$ global error" | halving ratios → 16 | true |
| index.qmd:16 heading | "$n=80$ steps ($h=0.0625$)" | 5/80 = 0.0625, matches script | true |
| index.qmd:18 | "nullcline $y=1/t^3$ (where $y'=0$)" | 1 − t·(t⁻³)^{1/3} = 0 | true |
| index.qmd:18 | "stay within $1.3\times10^{-5}$" | max error 1.289e-5 | true |
| index.qmd:18 | "$y(5)\approx0.0081267$ … exact $0.0081199$" | 0.00812673 / 0.00811992 | true |
| index.qmd:18 | "$\partial f/\partial y=-t/(3y^{2/3})$" | derivative of −t·y^{1/3} | true |
| index.qmd:18 | "grows to $-41.3$ at $t=5$" | −41.255 | true |
| index.qmd:18 | "stable only while $h\,\|\partial f/\partial y\|<2.785$" | real root of \|1+z+z²/2+z³/6+z⁴/24\|=1 at −2.78529 | true (linearised criterion) |
| index.qmd:18 | "Coarser steps become unstable" | n = 75–79 (h ≤ 0.0667) keep h·\|λ\|max ≤ 2.75 < 2.785 | slightly overgeneral (see New problems) |
| index.qmd:18 | "with $h=0.25$ … turn upward after $t=3.25$ and end at $y(5)\approx0.289$" | 0.0500 at 3.25, 0.0975 at 3.5, 0.28911 at 5 | true |
| index.qmd:22 alt | "step h = 0.0625 … four RK4 steps per frame" | script | true |
| index.qmd:22 alt | "rising to about 1.45 near t = 0.9" | true max 1.44977 at t = 0.8836; RK4 grid max 1.44973 at 0.875 | true |
| index.qmd:22 alt | "falling smoothly toward y ≈ 0.0081 at t = 5" | 0.0081267; monotone after peak (frames) | true |
| rungekuttaaa.jl:12 comment | "h = 0.0625 keeps h*\|df/dy\| below RK4's limit 2.785 up to t = 5" | max 2.578 | true |
| rungekuttaaa.jl:14 | stride = 4, "0.25 in t" | 4 × 0.0625 | true |
| rungekuttaaa.jl:19 title | "RK4, h = 0.0625: y' = 1 - t·y^(1/3),  y(0) = 1" | matches f, h and the initial condition; legible in the frames | true |
| rungekuttaaa.jl:36 | `for frame in 1:stride:n+1` | 1…81, 21 frames, endpoint included | correct |

### New problems
1. **Minor** — index.qmd:18, "Coarser steps become unstable once the solution flattens toward the nullcline". Read literally, this means any h > 0.0625, but that is not quite right. By the page's own criterion the threshold is h ≈ 2.785/41.26 ≈ 0.0675. With n = 75 (h = 0.0667) I get h·|λ|max = 2.75, a stable run and a maximum error of 1.7e-5. With n = 60 (h = 0.0833) the end of the run is beyond the limit (3.44), yet the maximum error is only 3.4e-4. A more precise wording would be "Steps much coarser than about $h\approx0.067$ become unstable…". This is wording only and does not affect correctness.
2. **Minor (cosmetic)** — rungekuttaaa.gif, last frames. The current-point marker at (5, 0.0081) sits in the bottom-right corner of the axes, half clipped by the right border and lying on the y = 0 axis line, so the final point is hard to see. The original also clipped the marker at t = 5, but it sat at y = 0.29 and was easier to see. ylims = (0, 1.8) leaves the tail for t > 3.3 visually on the axis. This is acceptable as is, and could be improved with a slightly larger xlim or a negative lower ylim.

Pre-existing, not introduced by the fix: the page has no `## Description` section before `## Animations`, which `.github/agents/animation-page.agent.md` requires (lines 12 and 205). HEAD lacks it too, and the Phase 1 inventory did not flag it.

### Reproducibility and conventions
- Reproducibility: the scratch copy of `rungekuttaaa.jl` regenerated a GIF that is byte-identical (`cmp`) to the committed `rungekuttaaa.gif`. It has 21 frames. I viewed frames 1, 11 and 21 at full size and the contact sheet. The title, the annotation and the axes are legible and correct.
- Conventions: there is a source link and a GIF embed for the case, the alt text is descriptive and up to date, and there are no code blocks. The Description section is missing, as noted above (pre-existing).
- Scope: `fix.diff` touches only `pages/numerical-methods/runge-kutta-method/` (index.qmd, rungekuttaaa.jl, rungekuttaaa.gif). The working tree has other modified files outside this folder: the bisection, fixed-point and newton pages and `pages/numerical-methods/index.qmd`. `pages/numerical-methods/index.qmd` was already modified in the session-start snapshot. Its diff concerns only the Milne/Predictor/Shooting links and is not part of this page's fix. The other files belong to other pages' fixes.

### Re-check

I re-checked against the updated diff. Two things changed since the first check: one sentence in index.qmd:18, and the axis limits in rungekuttaaa.jl (`xlims = (-0.1, 5.1)`, `ylims = (-0.05, 1.8)`). The GIF was regenerated. Everything else is unchanged: the ODE, n = 80, h, stride, the RK4 loop and the alt text.

### Original findings
- **F1: still resolved.** The computation is unchanged. With n = 80 the maximum error is 1.289e-5 and y(5) = 0.00812673. The new GIF's labels match my RK4 values: t=2.5 gives 0.4045 and t=5.0 gives 0.0081. The trace is monotone after the peak.
- **F2: still resolved.** The 1.3e-5, 0.0081267/0.0081199, −41.3, 2.785, 3.25 and 0.289 statements are unchanged and were verified above.
- **F3: still resolved.** The text is unchanged.

### Earlier new problems
- **NP1 (wording): resolved.** The text now reads "Steps longer than about $h=0.0675$ become unstable once the solution flattens…". The page's criterion gives the threshold 2.785/41.2554 = 0.06751, so "about 0.0675" is correct. For h a little above it (n = 72, h = 0.0694), the linearised amplification exceeds 1 only over the last few steps, so the growth is mild: max error 2.1e-5 at n = 72. For coarser h it is large: 3.4e-4 at n = 60, 6.2e-2 at n = 40 and 0.28 at n = 20. "About" and "once the solution flattens" cover this adequately.
- **NP2 (clipped end marker): resolved.** The new axis limits leave visible margins. In the full-size frame 21, the red marker at (5, 0.0081) is fully visible inside the box and clearly above the bottom border. The initial marker at (0, 1) in frame 1 is no longer half-clipped on the left border either. The ticks still read 0–5 and 0.0–1.5. The title and annotation are legible. I checked the full-size frames 1, 11 and 21.

### Reproducibility, conventions, new problems
- The scratch copy `check/run2/rungekuttaaa.jl` regenerates a GIF byte-identical (`cmp`) to the committed one, with 21 frames.
- The diff still touches only the page folder. The source link, the embed and the alt text are present. There are no code blocks.
- The missing `## Description` section is still pre-existing and was not introduced by the fix.
- New problems: none. The axis change only adds margins and the plotted data are unchanged. The new sentence's number is verified above.

**Final status:** committed
