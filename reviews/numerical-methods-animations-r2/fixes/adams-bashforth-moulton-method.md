# Fix record: adams-bashforth-moulton-method

Scratch folder (all evidence, re-runnable): `$FIX = /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/adams-bashforth-moulton-method/fix`

Scripts there: `check.py` (independent ABM4 vs Mathews' printed y(5)), `stab.py` (PECE stability boundary), `sweep.py` (onset and error before/after onset per m), `facts.py` / `facts2.py` (visibility, signs, negatives, reference accuracy, n = 50 run, stability interval scan), `mono.py` (reference monotone after peak), `instr.jl` (the new script's own numbers), `labels.jl` / `gifdelays.py` (legacy GIF reading).

## Findings

### F1 — Misleading — fixed
- Reproduced: `python3 -I $FIX/stab.py` → boundary z = −1.284816263; `sweep.py` → f_y(5) = −41.2554, h* = 0.031143, 5/h* = 160.55. `check.py` / `sweep.py` reproduce the reviewer's table: m = 150 error at t = 5 −1.36e-10, max 1.20e-6; m = 100 −4.49e-9, max 8.53e-6; m = 80 −1.09e-5, max 2.64e-5; m = 70 +2.08e-3. For m = 100, 120, 150 the error at t = 5 is smaller than at the last node before onset (8.25e-9 → 4.49e-9; 1.12e-9 → 5.66e-10; 1.66e-10 → 1.36e-10). So the page's framing of 0.0311 as the point past which results degrade was misleading; with the checker's correction, visible/practical degradation begins between m = 60 and 80 (m = 70: 26% relative error at t = 5 but 2.1e-3 absolute, invisible in the frame).
- Change: `index.qmd` intro no longer says n = 200 was needed; the stability paragraph now calls 1.285 / h = 0.0311 a frozen-coefficient linear bound "not an accuracy threshold", says it is crossed in every frame (m ≤ 160), and gives the computed contrast (m = 12–60 errors grow from 5.6e-5…2.2e-3 to 0.096…0.74; m = 100–150 errors below 1e-8 and smaller still at t = 5). It names all three of the module's Example 11 runs (n = 50, 100, 150). Script comment "h = 0.025 keeps ... below ABM4 PECE's limit" removed with the n = 200 run; the new comment says `zlim` is "a linear bound, not an accuracy threshold".
- Check: every number in the ledger below; frames m = 80, 100, 150 (shaded tail, run on reference, error labels −1.1e-05, −4.5e-09, −1.4e-10) viewed.

### F2 — Minor — fixed (per R2-B)
- Reproduced: legacy `a2001/Animations/OrdinaryDE/Adams1/Adamsaa.gif` (39 frames, all 100 cs) extracted to `$FIX/legacy`; distinct frames 4, 6, …, 32 (held 2) and 34–39 (one each) = 21 runs, labels stacked in `$FIX/lab1.png`, `$FIX/lab2.png`. Sequence m = 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150 (same as RK4), with printed y(5) = 0.0214088, 0.031208, 0.632147, 0.5320078, −0.3628404, −0.1443545, 0.0788702, 0.2516957, −0.1185897, 0.1822742, 0.0734851, 0.0481297, 0.0621776, 0.016797, 0.1036708, 0.0102009, 0.008109, 0.0081196, 0.0081199, 0.0081199, 0.0081199. The page's animation was a single n = 200 trajectory: finding holds.
- Change: `adamsbashforthmoultonaa.jl` rewritten to the R2-B sweep (one complete ABM4 run per m, 21 frames, fps 1), following the RK pattern (title, shaded onset span, gray reference lw 4, magenta polyline with nodes, red end dot, four-line text block). `abm4` and `rk4_reference` kept unchanged. ylims changed to (−0.5, 1.8) so every value of every run (min −0.4530 at m = 14, max 1.44975) is inside: no clamping or border markers needed. Stability limit computed in-script from the PECE characteristic polynomial (companion matrix, `LinearAlgebra` stdlib). `index.qmd` intro, case heading, Behavior, stability paragraph and alt text rewritten for the sweep.
- Check: `python3 -I $FIX/check.py` → all 21 round(y(5), 7) equal Mathews' printed values (trailing zeros dropped in his labels for m = 14, 16, 56, 80); `julia $FIX/instr.jl` gives the same 21 values to 10 digits.

## Ledger of changed text

Exact reference: DOP853 rtol 1e-13 → y(5) = 0.008119920464867977 (`check.py`). "visible" = |error| > 0.02 (≈ 3.5 px: plot area ≈ 395 px for 2.3 units of y); 0.006 (≈ 1 px) also reported.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Intro | "repeats the step-refinement sweep of Mathews' animation for legacy Example 11" | legacy frames `$FIX/lab1.png`, `lab2.png`; Example 11 ODE/IC/interval from archive gr_165 ("y' = 1 − t∛y with y(0) = 1 over 0 ≤ t ≤ 5") | yes |
| Intro | complete ABM4 run, m subintervals, h = 5/m, first three steps by RK4 | script `abm4` (RK4 for i = 1:3, h = (tf − t0)/n_steps) | yes |
| Intro | 21 values m = 12 … 150 (list) | legacy label strips; script `ms` | yes |
| Intro | labelled with computed y(5) and its error | script annotate lines; frames viewed | yes |
| Intro | "thick gray curve … RK4 at h = 10^-4" | script lw = 4, gray70, h_ref = 1e-4; `facts.py` → max diff vs DOP853 at 50 001 points 9.5e-13 | yes |
| Heading | "ABM4 predictor-corrector step-refinement sweep … m = 12 to 150" | `ms` | yes |
| Behavior | reference peak 1.4498 near t = 0.88, then decays to 0.0081199 | `facts.py` → max 1.449767 at t = 0.88356; `mono.py` → y' > 0 before, < 0 after peak; y(5) = 0.0081199205 | yes |
| Behavior | m = 12–52 visibly break away, from t ≈ 3.2 to 4.7 depending on m | `facts2.py` threshold 0.02 → first t 3.333, 3.214, 3.438, 3.333, 3.5, 3.958, 3.75, 3.75, 4.167, 4.375, 4.205, 4.688, 4.615 (range 3.21–4.69); max err ≥ 0.114 for all | yes |
| Behavior | each of m = 12–52 goes below zero; m = 48 only to −0.0049 | `facts.py` negative nodes listed for each m = 12…52; m = 48 min −0.0049; m = 56 min +0.0126 | yes |
| Behavior | "real cube root" | Julia `cbrt` and numpy `np.cbrt` both real for negative input; values match Mathews' | yes |
| Behavior | m = 56, 60 stay on reference until about t = 4.8, 4.9, then rise above by up to 0.11, 0.096 | `facts2.py` thr 0.02 → first 4.821, 4.917, all visible errors positive; `facts.py` max err 0.1080 at t = 4.911, 0.09555 at t = 5 | yes |
| Behavior | across m = 12–60 y(5) between −0.363 (m = 20) and 0.632 (m = 16) | `check.py` → min −0.3628404 (m = 20), max 0.6321470 (m = 16) | yes |
| Behavior | m = 12: y(5) = 0.0214, run off by 0.74 at t ≈ 4.17 | `check.py` 0.0214088; `facts.py` max err 0.7364 at t = 4.167 | yes |
| Behavior | from m = 60 on, error in y(5) falls at every refinement; 9.6e-2, 2.1e-3, 1.1e-5, 4.5e-9, 1.4e-10 at m = 60, 70, 80, 100, 150 | `check.py` err5: 9.56e-2, 2.08e-3, −1.09e-5, −2.94e-7, −4.49e-9, −5.66e-10, −1.36e-10 (m = 60…150, |·| strictly decreasing) | yes |
| Behavior | m = 70: 26% of y(5), too small to see | `facts.py` relerr5 25.6%; max err 2.08e-3 ≈ 0.36 px | yes |
| Stability | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | `sweep.py` fy(5) = 41.2554 | yes |
| Stability | stable on y' = λy, real λ < 0, only while h|λ| ≤ 1.285 | `stab.py` bisection on PECE char. poly → 1.284816263; `facts2.py` → ρ ≤ 1 on [−1.28481, 0), ρ > 1 on [−100, −1.28482] (and for |z| > 100 one root grows like (495/576)z²); `sweep.py` direct recurrence z = −1.28 decays, −1.29 grows to 1.9e4; script `zlim` = 1.284816263106912 | yes |
| Stability | every m ≤ 160 (h > 0.0311), every frame | `sweep.py` m = 160 onset 4.9944, m = 161 none; 5/h* = 160.55 | yes |
| Stability | shaded region from t ≈ 2.83 (m = 12) to 4.89 (m = 150) | `instr.jl` onsets 2.8260 … 4.8896; frame labels "2.83", "4.89" | yes |
| Stability | m = 12–60: error before onset 5.6e-5 to 2.2e-3, after reaches 0.096 to 0.74 | `sweep.py` before: min 5.64e-5 (m = 60), max 2.17e-3 (m = 20); after max: 9.56e-2 (m = 60) … 7.36e-1 (m = 12) | yes |
| Stability | m = 100, 120, 150: below 1e-8 before onset, error at t = 5 smaller still | `sweep.py` 8.25e-9 → 4.49e-9; 1.12e-9 → 5.66e-10; 1.66e-10 → 1.36e-10 | yes |
| Stability | "h = 0.0311 is a linear stability bound, not an accuracy threshold" | follows from rows above (m = 80–150 all exceed the bound, max err ≤ 2.6e-5) | yes |
| Stability | module's worked solution uses n = 50, 100, 150 | archive gr_168/175/182 "Using n = 51 / 101 / 151 points" (n + 1 points) | yes |
| Stability | n = 100, 150 end at 0.0081199 | archive gr_177, gr_184 last entry 0.00811992; `check.py` 0.0081199160, 0.0081199203 | yes |
| Stability | n = 50: y48 ≈ −0.0018 at t = 4.8, y(5) ≈ 0.138, about 17× exact | archive gr_170 {4.8, −0.0018309}, {5., 0.13809}; `facts.py` y48 −0.0018309, y50 0.1380900, ratio 17.006 | yes |
| Alt text | peaks near 1.45 at t ≈ 0.88, 0.0081 at t = 5 | as Behavior | yes |
| Alt text | m = 12–60 visibly break away, y(5) between −0.363 and 0.632 | as Behavior (m = 56, 60 max err 0.108, 0.096 visible) | yes |
| Alt text | shaded where h·|∂f/∂y| > 1.285, every frame | `instr.jl` onset exists for all 21 | yes |
| Alt text | from m = 70 on lies on the reference at this scale; y(5) = 0.0081199 at m = 100, 150 | `check.py` max err 2.08e-3, 2.64e-5, 1.50e-5, 8.53e-6, 3.49e-6, 1.20e-6 for m = 70…150 (≤ 0.36 px) | yes |
| GIF title | "ABM4 for y' = 1 - t·y^(1/3), y(0) = 1 / m = $m subintervals, h = 5/$m" | script; frames | yes |
| GIF labels | y(5) %.7f, error %+.1e, reference 0.0081199, onset %.2f | `instr.jl` values; frames 1, 2, 5, 14, 15, 16, 17, 19, 21 viewed | yes |
| Script comments | ylims "min −0.453 at m = 14, max 1.4498"; zlim "1.2848: a linear bound, not an accuracy threshold" | `instr.jl` global min −0.4530 (m = 14), max 1.44975 | yes |

## Scripts and GIFs
- Script changed: `adamsbashforthmoultonaa.jl` (sweep; adds `using Printf`, `using LinearAlgebra`, both stdlib).
- GIF regenerated: `adamsbashforthmoultonaa.gif`, 21 frames at 1 s. A second run in `$FIX/rerun` is byte-identical.
- Frames viewed (`$FIX/new`): 1 (m = 12), 2 (14), 5 (20), 14 (56), 15 (60), 16 (70), 17 (80), 19 (100), 21 (150) at full size, and the contact sheet. Checked: title m and h = 5/m; red dot at (5, y_m); text block legible and clear of every curve (highest tail node 0.751 at m = 12, text from y ≈ 0.83); legend clear of the text; shading starts at the labelled onset; m ≤ 60 departures visible, m ≥ 70 on the reference; nothing leaves the window.
- `git status -- pages/numerical-methods/adams-bashforth-moulton-method`: `M adamsbashforthmoultonaa.gif`, `M adamsbashforthmoultonaa.jl`, `M index.qmd`.

## Legacy archive
Consulted. `n2003/abmmethod/AdamsBashforthMod/Links/AdamsBashforthMod_lnk_12.html` (Example 11): runs with n = 50, 100, 150 (gr_168/175/182), tables gr_170 (n = 50: y48 = −0.0018309, y50 = 0.13809), gr_177 and gr_184 (y(5) = 0.00811992). `a2001/Animations/OrdinaryDE/Adams1/Adamsaa.gif`: 39 frames at 100 cs, 3 blank lead-in frames, m = 12…52 held 2 frames, 21 runs with the m and y(5) values listed under F2; Mathews' window clips the coarse runs (e.g. m = 12 below y ≈ −0.2). All 21 printed values and the three worked-solution runs are reproduced by an independent ABM4 (PECE, RK4 start). Differences from Mathews: lead-in and holds dropped (one frame per m, as in the RK pattern); our window shows every computed value instead of clipping; the page adds the reference curve, error label and the linear-bound shading.

## Notes
- The corrected D2 sentence ("from then on errors are amplified instead of damped") is not used as worded: F1 (confirmed) shows it is false in practice for m = 100–150 on this problem. The page instead says the linear analysis "no longer guarantees that errors are damped" and gives the computed error behaviour on both sides, which follows the mathematics over the template.
- The D2 table's ABM4 "minimum n 161" is confirmed (5/h* = 160.55), but no frame of Mathews' sweep reaches it; under R2-B the sweep is kept and every frame is shaded.
- Director's note on visibility applied: "visibly" claims use |error| > 0.02 (≈ 3.5 px); the sub-visible negative dip at m = 48 (−0.0049) and the invisible m = 70 error (2.1e-3, 26%) are stated with their sizes.
- The page was not rendered with Quarto (writes outside the page folder).
- The Description section is unchanged; the "(Planned)" and legacy-inventory stubs are untouched.

## Resolution check (independent checker, not shown this record)

Independent tools (all in `check/scripts/`): `sweep.py` (my own ABM4 PECE in Python/numpy with an RK4 start for y1..y3, compared against an mpmath `odefun` Taylor reference at 30 digits; real-axis stability limit from the roots of the PECE characteristic polynomial, found by brentq; onset times on a 1e-5 grid of a DOP853 solution at rtol 1e-13), `tail.py` (tail departure times and error histories), `crop.py` (label strip of the legacy GIF frames). Legacy GIF frames are in `check/legacy/`, new frames in `check/new/`, and the Example 11 solution images stacked in `check/legacy_ex11.png`.

Reference: y(5) = 0.00811992046486796. Peak 1.449766696 at t = 0.8835558 (root of 1 - t·y^(1/3) = 0).

### Original findings

### F1 — resolved
- The n = 200 trajectory and the sentence that framed h = 0.0311 as the point past which errors are amplified are gone. The page now says the frozen-coefficient analysis "shows where this can start, not how large it gets", that past onset the linear analysis "no longer guarantees that errors are damped", and that "h = 0.0311 is a linear stability bound, not an accuracy threshold". It backs this with numbers. All of them check:
  - m = 12–60: error at the last step before onset is 5.64e-5 to 2.17e-3, and the error after onset reaches 0.0956 to 0.736.
  - m = 100, 120 and 150: the error is 8.25e-9, 1.12e-9 and 1.66e-10 before onset, and 6.2e-9, 1.0e-9 and 1.6e-10 after it (below 1e-8 on either reading of "there"). At t = 5 it is 4.49e-9, 5.66e-10 and 1.36e-10, smaller still.
- The page now names all three of the module's runs. From Mathews' Example 11 printout (gr_166–gr_184): n = 50 gives y48 = −0.0018309 at t = 4.8 and y(5) = 0.13809. n = 100 and n = 150 both give 0.00811992. My ABM4 reproduces these (y48 = −0.0018309036, y50 = 0.1380900, ratio 17.006). The old script comment ("h = 0.025 keeps h*|df/dy| below ...") is gone. The new comment says `zlim # 1.2848: a linear bound, not an accuracy threshold`.
- The GIF now shows the point directly. Every frame is shaded past onset, yet frames m = 70 to 150 lie on the reference.

### F2 — resolved
- Following R2-B, the animation is now Mathews' step-refinement sweep. The legacy `a2001/Animations/OrdinaryDE/Adams1/Adamsaa.gif` has 39 frames: 3 title frames, then 21 distinct m frames (15 doubled, 6 single). I read every label: m = 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150. That is exactly the script's `ms`, and the page's list of "the 21 values".
- Mathews' printed y(5) against my ABM4, which matches the script output to every printed digit:

| m | Mathews | mine | m | Mathews | mine |
|---|---|---|---|---|---|
| 12 | 0.0214088 | 0.0214088 | 44 | 0.0734851 | 0.0734851 |
| 14 | 0.031208 | 0.0312080 | 48 | 0.0481297 | 0.0481297 |
| 16 | 0.632147 | 0.6321470 | 52 | 0.0621776 | 0.0621776 |
| 18 | 0.5320078 | 0.5320078 | 56 | 0.016797 | 0.0167970 |
| 20 | −0.3628404 | −0.3628404 | 60 | 0.1036708 | 0.1036708 |
| 24 | −0.1443545 | −0.1443545 | 70 | 0.0102009 | 0.0102009 |
| 28 | 0.0788702 | 0.0788702 | 80 | 0.008109 | 0.0081090 |
| 32 | 0.2516957 | 0.2516957 | 90 | 0.0081196 | 0.0081196 |
| 36 | −0.1185897 | −0.1185897 | 100 | 0.0081199 | 0.0081199 |
| 40 | 0.1822742 | 0.1822742 | 120 / 150 | 0.0081199 | 0.0081199 |

  (Mathematica drops trailing zeros, which explains m = 14, 56 and 80.) Mathews uses the real cube root (`Sign[y] Abs[y]^(1/3)`), and so does the script (`cbrt`).
- Each new frame carries m, h = 5/m, y(5) to 7 decimals and the error, as R2-B requires. The reference curve is kept.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Animations intro | "repeats the step-refinement sweep of Mathews' animation for legacy Example 11" | Legacy GIF is a sweep over m; Example 11 page links Animation 1 = Adamsaa | ok |
| intro | "first three steps by RK4" | script `abm4` loop i in 1:3 RK4; my reproduction of legacy values with the same start | ok |
| intro | "21 values ... m = 12, 14, …, 150" | read from all legacy frames | ok |
| intro | "labelled with the computed y(5) and its error" | frames | ok |
| reference para | "thick gray curve", RK4 h = 1e-4 | script `gray70, lw=4`; RK4 y(5) printed 0.0081199 = mpmath | ok |
| Case heading | "m = 12 to 150 subintervals" | ms | ok |
| Behavior | peak "about 1.4498 near t = 0.88" | 1.4497667 at t = 0.88356 | ok |
| Behavior | y(5) = 0.0081199 | 0.00811992046 | ok |
| Behavior | m = 12–52 break away in the tail "from t ≈ 3.2 to 4.7, depending on m" | first step with \|e\| > 0.01: 3.13 (m = 16) … 4.62 (m = 52); with \|e\| > 0.02, 3.21 … 4.69 | ok (approximate) |
| Behavior | each m = 12–52 run goes below zero; m = 48 only to −0.0049 | min y: −0.419, −0.453, −0.275, −0.243, −0.363, −0.144, −0.176, −0.116, −0.119, −0.054, −0.065, −0.0049, −0.033; m = 56 and 60 stay positive | ok |
| Behavior | m = 56 and 60 stay on the reference until about t = 4.8 and 4.9, then rise above by up to 0.11 and 0.096 | m = 56: e = +0.0028 at 4.64, +0.013 at 4.73, +0.076 at 4.82, max +0.108 at 4.91; m = 60: \|e\| < 0.003 up to 4.83, then +0.051 at 4.92 and +0.0956 at 5 | ok |
| Behavior | end value between −0.363 (m = 20) and 0.632 (m = 16) over m = 12–60 | extremes of the y(5) column | ok |
| Behavior | m = 12: y(5) = 0.0214, off by 0.74 at t ≈ 4.17 | 0.0214088; max \|e\| 0.736 at t = 4.1667 | ok |
| Behavior | error in y(5) falls at every refinement from m = 60: 9.6e-2, 2.1e-3 (26%), 1.1e-5, 4.5e-9 (m = 100), 1.4e-10 (m = 150) | 9.56e-2, 2.08e-3 (25.6%), 1.09e-5, 2.94e-7 (90), 4.49e-9, 5.66e-10 (120), 1.36e-10, all decreasing | ok |
| Behavior | m = 70 error "too small to see in the frame" | 2.1e-3 at about 175 px per unit is about 0.4 px; frame_016 shows it on the reference | ok |
| Stability para | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | −41.2554 | ok |
| Stability para | stable on real λ < 0 only while h\|λ\| ≤ 1.285 | spectral radius < 1 on (−1.2848, 0); > 1 everywhere on [−200, −1.2849]; boundary −1.284816 | ok |
| Stability para | every m ≤ 160 (h > 0.0311) | h_crit = 0.0311430, so m < 160.55 | ok |
| Stability para | shaded onset from t ≈ 2.83 (m = 12) to t ≈ 4.89 (m = 150) | 2.826 and 4.890; the other frame labels (2.93, 3.01, 3.13, 3.24, 3.35, 3.49, 3.64, 3.82, 3.99, 4.28) match mine | ok |
| Stability para | errors before and after onset (m = 12–60; m = 100, 120, 150) | see F1 | ok |
| Stability para | "h = 0.0311 is a linear stability bound, not an accuracy threshold" | supported by the above | ok |
| Stability para | module runs n = 50, 100 and 150; y48 ≈ −0.0018 at t = 4.8; y(5) ≈ 0.138, about 17× exact; n = 100 and 150 give 0.0081199 | legacy gr_166–184 and my ABM4 | ok |
| Alt text | sweep, m = 12–150, gray reference peaking near 1.45 at t ≈ 0.88, 0.0081 at t = 5; m = 12–60 break away, ending between −0.363 and 0.632; shading in every frame; from m = 70 on the run lies on the reference; 0.0081199 at m = 100 and 150 | as above, and frames | ok |
| Script header and comments | step-refinement sweep, ms from Mathews | as above | ok |
| Script | `fy = -t/(3 cbrt(y)^2)` | equals −t/(3y^{2/3}) | ok |
| Script comment | characteristic polynomial ζ⁴ − ζ³ − (z/24)(9P + 19ζ³ − 5ζ² + ζ), P = ζ³ + (z/24)(55ζ³ − 59ζ² + 37ζ − 9); the companion coefficients in code | derived by hand from PECE with y_{n−3} = 1; the code's c vector matches; zlim agrees with mine to 1e-12 | ok |
| Script comment | ylims: min −0.453 at m = 14, max 1.4498 | −0.4530 (m = 14), 1.44975 | ok |
| Frame title | "ABM4 for y' = 1 - t·y^(1/3), y(0) = 1 / m = …, h = 5/m" | | ok |
| Frame labels | y(5), error, reference y(5) = 0.0081199, "h·\|∂f/∂y\| > 1.285 from t ≈ …" | all match my values | ok |

### New problems

None. This rests on four checks:
- every number in the changed text, script comments and frame labels was recomputed independently (ledger above);
- the 21-value m sequence and all 21 printed y(5) values were matched against the legacy GIF;
- the first, middle and last frames (m = 12, 44, 150), m = 70 and the contact sheet were viewed at full size. Labels are legible and the annotation block overlaps neither the curve nor the legend;
- the stability claim was checked over the whole negative real axis to −200.

One very small imprecision does not need a change. For m = 16 the deviation first passes 0.01 at t = 3.13, slightly before the page's "t ≈ 3.2". It becomes visible against the 4 px reference line only near 3.2–3.4, so "≈ 3.2" is fair.

### Reproducibility and conventions

- I ran a scratch copy of `adamsbashforthmoultonaa.jl` with `julia`. Its GIF is byte-identical (`cmp`) to the one in the working tree: 21 frames at fps 1.
- Conventions hold. The page has Description before Animations; a `[Julia source]` link and a GIF embed for the single case; descriptive alt text; and no code blocks.
- The fix diff for this page touches only the three files in the page folder: `index.qmd`, the `.jl` and the `.gif`. The working tree has other page folders modified as well. Those belong to other pages' fixes in this round and do not appear in this page's diff.

**Final status:** committed
