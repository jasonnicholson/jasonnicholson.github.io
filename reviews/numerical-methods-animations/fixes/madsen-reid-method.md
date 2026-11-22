# Fix record: madsen-reid-method

Scratch evidence folder (re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/madsen-reid-method/fix/`
- `repro/instr.jl`, `repro/indep.py`: round-1 evidence scripts, re-run unchanged against the original scripts.
- `new/trace_new.jl`: instrumented Julia trace of the fixed algorithm (all three cases, with trial values, clip flag, |f|²).
- `instr/madsreidaa_instr.jl`, `instr/madsreidab_instr.jl`: the fixed repo scripts with the animation part cut off, printing iterates, labels and Newton points (so the shipped code itself is traced).
- `new/indep_new.py`: independent mpmath (40 digits) replay of the fixed algorithm written from the page's wording, plus sympy theory checks.
- `new/general_m.py`: check of the general multi-step claim for m = 2 and m = 3.
- `frames/madsreidaa/`, `frames/madsreidab/`: extracted frames of the regenerated GIFs.

**Choice for F1.** The fix plan allows either implementing the acceleration or removing the claims. The Fix standard says the animation is wrong when "it runs a different method from the one named", and the page is titled and cited as the Madsen-Reid method, whose defining multi-step mechanism the scripts lacked. So the scripts were fixed (multi-step search added) and the text rewritten from the new runs. The r0 cap was kept as is and is now described correctly.

## Findings

### F1 — Error — fixed
- Reproduced: `julia repro/instr.jl` on the original scripts: every step of aa (6), ab (14), ac (7) prints `clip=false`; r0 in ab goes 10, 6, 3.789, 2.308, 1.343, 0.745, …, 0.003352 (reset to 5·|Newton step| each iteration, shrinking). ab iterates equal plain Newton: `python3 -I repro/indep.py` → mpmath plain Newton x14 = 1.000335413657244 vs script 1.000335413657196; error ratios 0.6, 0.57895, …, 0.50006. No code tries z − kΔz for k ≥ 2.
- Change: `madsreidaa.jl`, `madsreidab.jl`, `madsreidac.jl` — after a full Newton step that reduces |f|², try z − pΔz for p = 2..n (n = degree: 3, 3, 2) while |f|² keeps decreasing and keep the last improving point; such steps are labelled `:multi` and drawn in seagreen (aa/ab: tangent to the Newton point, then a thick segment along the axis to x − kΔx), with a legend entry "Stage 1 – multi-step kΔx" (aa/ab). r0 comment "acceleration: allow 5× next time" → "cap for next step: 5× this Newton step". `index.qmd` §1: "the step-size limit r0 is *increased* fivefold after each accepted step … recovering quadratic-like convergence in practice" → description of the multi-step search, the k = m result near a root of multiplicity m ≤ n, and r0 as a cap reset to 5|Δz| that shortens no step in the animations. §2 Stage list now has Stage 2 (Newton), Stage 1 (Multi-step), Stage 1 (Damped). §3 "the same cost as plain Newton" → "the same derivatives as plain Newton, plus a few extra evaluations of f at the trial points" (the trial points are extra f evaluations). Note: "acceleration by relaxing the step-size limit" → "acceleration by repeated steps in the same direction".
- Check: `julia new/trace_new.jl` and `julia instr/madsreidab_instr.jl`: ab labels `multi` ×4 with k = 3, 2, 2, 2; clip=false in every step of all three cases; independent `python3 -I new/indep_new.py` reproduces every iterate of all three cases (e.g. ab x4 = 1.0000002296437116 vs Julia 1.0000002296437034). sympy: (x − 2P/P′) − 1 = (x − 1)²/(3(x + 1)) → quadratic with constant 1/6; Julia e4/e3² = 0.1666. `new/general_m.py`: (x−1)³(x+2) with n = 4 picks k = 3 every step, e/e² → 0.1111; (x−1)²(x+2)(x−3) picks k = 2, e/e² → −0.0833.

### F2 — Error — fixed
- Reproduced: original ab: 14 × `:newton`, 0 halvings, no clip, error ratio → 0.5001, stops at the iteration cap with x14 = 1.000335413657196 (`repro/instr.jl`). Round-1 frames were all blue.
- Change: script fixed under F1 and `madsreidab.gif` regenerated; legend label now `round(x; sigdigits=9)` instead of `digits=5` so x4 = 1.0000002296… shows as "1.00000023" rather than "1.0". Case 2 Behavior paragraph rewritten from the new run (plain Newton comparison, 3Δx then 2Δx ×3, errors, x4, |P(x4)|, no damping); the deflation sentence about x = −2 removed (no deflation in the script, −2 never approached). Alt text rewritten.
- Check: `julia instr/madsreidab_instr.jl` → x1 = 0.4000000000000004, x2 = 1.0857142857142854, x3 = 1.0011741682974562, x4 = 1.0000002296437034, all `multi`; |P(x4)| = 1.581e-13 (mpmath 1.582e-13); legend9sig [4.0, 0.4, 1.08571429, 1.00117417, 1.00000023]. Frames 2, 3, 5 viewed (see below).

### F3 — Error — fixed
- Reproduced: sympy `limit((P/P')/(x-1), x, 1)` = 1/2 for P = (x−1)²(x+2) (`new/indep_new.py`); original-run Newton step/error 0.40 → 0.4999 (round-1 `verify/trace.jl`), error ratio → 0.5001 (`repro/instr.jl`). The step is half the remaining distance, i.e. too short, not inflated.
- Change: index.qmd §1 "because f′(x*) = 0, which inflates each step" → "because f′(x*) = 0: near the root f/f′ ≈ (x−x*)/m, so each Newton step covers only 1/m of the remaining distance and the error shrinks by the factor (m−1)/m per step".
- Check: as above (1/2 = 1/m, ratio 0.5 = (m−1)/m for m = 2).

### F4 — Minor — fixed
- Reproduced: `grep -n "scatter!" madsreidaa.jl madsreidab.jl` (original) shows only the current-point marker; only madsreidac.jl draws `shape=:star5` at ±2i.
- Change: index.qmd Animations intro "The star markers show the exact root(s)." → "In Case 3, star markers show the exact roots." (text-only, the smallest change; no drawing added).
- Check: madsreidac.jl line `scatter!([0.0, 0.0], [2.0, -2.0]; … shape=:star5, label="roots ±2i")`; madsreidac.gif is unchanged and its round-1 frames show the stars.

### F5 — Minor — fixed
- Reproduced: original aa: 6 × `:newton`, `halvings=0` on every step (`repro/instr.jl`); no damping anywhere.
- Change: Case 1 Behavior rewritten from the new run (the first step is now a 2Δx multi-step, then full Newton steps; "no damping occurs"); alt text rewritten.
- Check: `julia instr/madsreidaa_instr.jl` → labels multi, newton ×5; no `damped`. Errors from `new/indep_new.py`.

### F6 — Minor — fixed
- Reproduced: `repro/instr.jl` (ac): step 1 `halv=1 alt=false`, step 2 `halv=4 alt=true`, step 3 `halv=1 alt=false`, steps 4–7 `newton`; `repro/indep.py` reproduces z1 = −0.25, z2 = 0.0546875 + 0.40625i, z3, and the full-Newton |f|² = 480.42 at step 3. Path is drawn with straight `plot!` segments between iterates.
- Change: Case 3 Behavior: added z1 and the failed halvings, z2 exact, "Orange segments are Stage 1 steps: the first and third are halved Newton steps, and the second is the alterdirection rotation. The last four segments are full Newton steps (blue), and no multi-step move occurs. The path is a polyline converging to z* = +2i."
- Check: `julia new/trace_new.jl` (fixed algorithm): ac identical to original; multi-step trials at steps 4–7 all fail (|f|² at 2Δz: 3.845 vs 0.2027, 0.1703 vs 1.348e-4, 1.3456e-4 vs 7.09e-11, 7.08554e-11 vs 1.96e-23). Halvings at z1: |f|² 4358.06, 343.55, 51.45, 21.03, 16.536 all > 16.504 (`repro/indep.py`). madsreidac.gif byte-identical after regeneration.

### F7 — Minor — fixed
- Reproduced: original aa/ab `alterdirection(dz) = dz·m·(−0.6)` (reversal); `repro/indep.py`: applying it to x² + 4 at x = −0.25 gives |f|² 16.504 → 18.556. In ac the alterdirection point is accepted with no |f|² test. Page said the structure "guarantees" monotone |f|².
- Change: aa/ab: the reversal is replaced by `error("alterdirection needs a complex step; not representable on the real axis")` (the branch is never reached; it can no longer silently show a fake). ac: comment "accepted without a descent test" on that branch (behaviour unchanged). index.qmd: "rotates the step by approximately 53° and scales it" → "rotates the step by 53.13° (multiplication by 0.6 + 0.8i; this makes the step complex, so it can only be shown in Case 3)"; the "guarantees … Lyapunov function … global convergence character" sentence → "designed to make |f(z)|² decrease at every step … It is not a guarantee: an alterdirection step is accepted without checking |f|². In all three animations below |f|² does decrease at every step."
- Check: aa and ab regenerate without error (branch not reached). Angle: `mp.degrees(mp.atan2(0.8,0.6))` = 53.1301°, |0.6 + 0.8i| = 1. |f|² sequences (Julia traces): aa 289, 3.17079, 0.636858, 0.00238373, 5.24706e-8, 2.62807e-17, 0; ab 2916, 0.746496, 5.13954e-4, 1.712e-11, 2.49943e-26; ac 25, 16.5039, 14.7318, 13.4917, 0.202661, 1.348e-4, 7.08551e-11, 1.9611e-23 — strictly decreasing in all three.

### Round 2 after check

**N1 — Minor — fixed.** The independent check found that "The limit can only shorten a step" is not exactly true of madsreidac.jl. There, `if r > r0; dz = alterdirection(dz, r0/r)` also rotates the step, since alterdirection multiplies by (0.6 + 0.8i)·r0/r, which has modulus r0/r and angle 53.13°.
- Change: index.qmd §1 now reads "A Newton step longer than r0 is cut to length r0; in the real-axis scripts (Cases 1 and 2) it keeps its direction, and in the complex script (Case 3) it is also rotated by 53.13° by `alterdirection` (below). No Newton step in the three animations is longer than r0, so the limit never acts."
- Check:
  - In aa and ab the code is `dz*(r0/r)`, which has length r0 and the same sign.
  - In ac the code is `alterdirection(dz, r0/r)`: atan2(0.8, 0.6) = 53.1301° and |0.6 + 0.8i| = 1, so the length is r0.
  - `new/trace_new.jl` shows clip=false on all 17 steps.
  - No script changed for N1.

**N2 — Minor — fixed.** In Case 2, steps 2–4 have |P| ≤ 0.0227 on a y-axis 64 units tall, so they were sub-pixel in frames 3–5.
- Change (madsreidab.jl): frames 0–1 keep the full window. From frame 2 on, the limits are set from the latest step's start, Newton point and end:
  - xlims are those three points ± 0.15 × the step width.
  - ylims are −0.1·ytop to ytop, with ytop = 1.25·max|P| at the step's ends.
  - The curve is resampled on the new window.
  - The legend moves to the side away from the step's start.
  - This adds about 12 lines of limit code and no new plot elements.
- Change (index.qmd):
  - Case 2 Behavior gains "From x₂ on, the window zooms in on each new step, because the steps shrink from 0.69 to 0.0012 in x; each zoomed frame shows the tangent reaching the axis halfway along the step, then the second Δx along the axis."
  - The alt text gains "the view zooming in on each step from x₂ on".
- Check: `julia new/zoom_windows.jl` gives the step widths 0.6857, 0.08454 and 0.001174. Its windows are:

  | Frame | xlims | ylims |
  |---|---|---|
  | 2 | (0.297, 1.189) | (−0.108, 1.08) |
  | 3 | (0.9885, 1.0984) | (−0.00283, 0.0283) |
  | 4 | (0.99982, 1.00135) | (−5.2e-7, 5.2e-6) |

  In every zoomed step the Newton point sits at fraction 0.5000 of the step (k = 2).
- Frames: the GIF was regenerated and frames 2–5 viewed at full size (`frames/madsreidab_r2/`).
  - Frame 3 (x2 = 1.08571429): tangent from (0.4, 0.864) to 0.743, then axis to 1.0857.
  - Frame 4 (x3 = 1.00117417): tangent from (1.0857, 0.0227) to 1.0434, then axis to 1.0012.
  - Frame 5 (x4 = 1.00000023): tangent from (1.00117, 4.1e-6) to 1.00059, then axis to 1.0000002, with y tick labels ×10⁻⁶.
  - Each step is clearly visible and the legend covers no step.
  - Frame 2 is visually unchanged. Its decoded md5 differs from the first fixed version, and so does frame 1's. The cause is the GIF palette, which is shared across all frames and changed when the zoomed frames were added; the content is the same.
- git status of the page folder is unchanged in kind: index.qmd, aa.jl/gif, ab.jl/gif and ac.jl are modified, and madsreidac.gif is still unmodified.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| §1 | near the root f/f′ ≈ (x−x*)/m; step covers 1/m; error factor (m−1)/m | sympy limit (P/P′)/(x−1) → 1/2 (m = 2); `repro/instr.jl` ratio → 0.5001 | yes |
| §1 | multi-step: tries z − 2Δz, z − 3Δz, … up to z − nΔz, keeps last point where \|f\|² still decreasing | code in all three scripts (`for p in 2:n_deg … ft_sq < fn_sq \|\| break`) | yes |
| §1 | near a root of multiplicity m ≤ n that point is z − mΔz, which converges quadratically (Case 2) | ab k = 2 at steps 2–4; `general_m.py`: m = 3, n = 4 → k = 3, e/e² → 0.1111; m = 2, n = 4 → k = 2, e/e² → −0.0833; sympy x − 2P/P′ error (x−1)²/(3(x+1)) | yes (general statement, asymptotic) |
| §1 | r0 limits the Newton step to length r0, reset each iteration to 5× the latest Newton step length | code `if r > r0 … ; r0 = r*5.0`, r = \|unclipped Newton step\|; ac cap uses alterdirection(dz, r0/r), length r0 | yes |
| §1 (round 2) | a Newton step longer than r0 is cut to length r0; same direction in Cases 1–2; also rotated by 53.13° in Case 3; no Newton step is longer than r0 in the animations, so the limit never acts | aa/ab `dz*(r0/r)`; ac `alterdirection(dz, r0/r)`, angle 53.1301°, \|0.6+0.8i\| = 1; `new/trace_new.jl`: clip=false on all 6 + 4 + 7 steps | yes |
| Case 2 (round 2) | the window zooms from x2 on; steps shrink from 0.69 to 0.0012 in x; tangent reaches the axis halfway along the step, then a second Δx | `new/zoom_windows.jl`: widths 0.6857, 0.08454, 0.001174; Newton point fraction 0.5000; frames 3–5 viewed | yes |
| Case 2 alt (round 2) | "the view zooming in on each step from x₂ on" | as above | yes |
| §2 | "chooses each step by comparing \|f\|² at trial points along the Newton direction" | code structure | yes |
| §2 Stage 2 | full step reduces \|f\|² and z − 2Δz does not reduce it further → accepted; quadratic phase near a simple root | code; aa steps 2–6 and ac steps 4–7 are Stage 2 and quadratic (aa e/e² → 0.7422 = f″/(2f′) = 0.74223) | yes |
| §2 Stage 1 (Multi-step) | if z − 2Δz reduces further, chooses z − kΔz, k ≥ 2 | code | yes |
| §2 Stage 1 (Damped) | 53.13°, multiplication by 0.6 + 0.8i; complex, shown only in Case 3 | atan2(0.8, 0.6) = 53.1301°, \|0.6+0.8i\| = 1; ac alterdirection formula = dz·(0.6+0.8i)·m; aa/ab now error out on that branch | yes |
| §2 | designed to decrease \|f\|²; not a guarantee: alterdirection accepted unchecked; decreases at every step in all three animations | code (no test after alterdirection); \|f\|² sequences listed under F7 | yes |
| §3 | same derivatives as plain Newton, plus extra f evaluations at trial points | code evaluates only f, fp; trial points call f | yes |
| Note | acceleration by repeated steps in the same direction | code | yes |
| Animations intro | blue = full Newton (Stage 2); green = z − kΔz, k ≥ 2, drawn as tangent to Newton point then along axis; orange = damped/direction-altered (Stage 1) | color/drawing code in aa/ab/ac; frames aa 002, ab 002 | yes |
| Animations intro | "In Case 3, star markers show the exact roots." | ac `scatter!(… shape=:star5)` at ±2i; mpmath polyroots ±2i | yes |
| Case 1 | doubled step reduces \|P\|² more than the Newton step | trace step 1: full 17.3075, p=2 3.17079, p=3 8.73249 | yes |
| Case 1 | x1 = x0 − 2Δx ≈ 1.5833, passes the root | x1 = 1.5833333333333333 < x* = 1.879385 < x0 = 3 | yes |
| Case 1 | every later step full Newton, no damping | labels newton ×5 after multi | yes |
| Case 1 | quadratic; root x* ≈ 1.8794 | mpmath root 1.87938524157; e/e² 1.116, 0.6684, 0.7369, 0.7422 → f″/(2f′) = 0.74223 | yes |
| Case 1 | errors 9.8e-2, 6.4e-3, 3.0e-5, 6.7e-10 over steps 2 to 5 | indep_new.py: x2..x5 errors 0.09783, 0.006397, 3.015e-5, 6.749e-10 | yes |
| Case 1 | x6 equals x* to double precision | float(x6) = 1.8793852415718169 = float(2cos(π/9)) | yes |
| Case 1 alt | doubled first step x0 = 3.0 → x1 ≈ 1.5833, then full Newton steps converging quadratically to x ≈ 1.8794 | as above | yes |
| Case 2 | plain Newton: error roughly halves each step, still 3.4e-4 after 14 steps | repro/indep.py ratios 0.6 … 0.50006; x14 = 1.000335414 | yes |
| Case 2 | every step multi-step (all green): 3Δx to x1 = 0.4, then 2Δx three times | trace k = 3, 2, 2, 2; x1 = 0.4 (mpmath exact 0.4) | yes |
| Case 2 | 2Δx is the multiplicity-corrected step for m = 2 | sympy (x − 2P/P′ quadratic) | yes |
| Case 2 | errors 8.6e-2, 1.2e-3, 2.3e-7 fall quadratically | 0.08571, 0.001174, 2.296e-7; e/e² 0.2381, 0.1598, 0.1666 → 1/6 | yes |
| Case 2 | stops after 4 steps at x4 ≈ 1.00000023, \|P(x4)\| ≈ 1.6e-13 | Julia x4 = 1.0000002296437034, \|P\| = 1.581e-13 (< 1e-10 tolerance) | yes |
| Case 2 | no step is damped | no `damped` label | yes |
| Case 2 alt | four multi-step moves (3Δx, then 2Δx three times) converging quadratically from x0 = 4.0 to x = 1 | as above | yes |
| Case 2 GIF legend | "x4 = 1.00000023" etc. (sigdigits = 9) | legend9sig list; frame_005 viewed | yes |
| Case 3 | halved Newton step reaches z1 = −0.25 | step 1 halv=1 | yes |
| Case 3 | at z1 neither the real Newton step nor any of its 4 halvings reduces \|P\|² | 4358.06, 343.55, 51.45, 21.03, 16.536 vs 16.504 | yes |
| Case 3 | rotation to z2 = 0.0546875 + 0.40625i | trace and mpmath replay | yes |
| Case 3 | first and third orange segments are halved Newton steps, second is alterdirection | halv=1 / halv=4 alt=true / halv=1 | yes |
| Case 3 | last four segments full Newton (blue), no multi-step move | steps 4–7 `newton`, p = 2 trials all worse (see F6) | yes |
| Case 3 | polyline converging to +2i | straight `plot!` segments; \|z7 − 2i\| = 1.1e-12 | yes |
| aa/ab legend | "Stage 1 – multi-step kΔx" | frames viewed | yes |

Unchanged text that stays: title "Damped Newton with Acceleration (Madsen-Reid Method)" (now accurate: damping and the multi-step acceleration are both implemented); Case 3 alt text (confirmed in round 1, GIF unchanged).

## Scripts and GIFs
- Scripts changed: `madsreidaa.jl`, `madsreidab.jl`, `madsreidac.jl`.
- GIFs regenerated: `madsreidaa.gif` (changed), `madsreidab.gif` (changed), `madsreidac.gif` (regenerated; byte-identical to the committed file — sha256 a61ba646…9c35 matches the LFS object id — as expected, since the multi-step search never fires in Case 3 and the drawing/legend code of ac is unchanged).
- Frames viewed at full size: aa frame_002 (x1 = 1.58333, green tangent to 2.2917 then axis segment to 1.5833, vertical to P(x1) = −1.78) and frame_007 (x6 = 1.87939, green first step plus blue Newton steps); ab frame_002 (x1 = 0.4, green tangent from (4, 54) to 2.8, axis segment to 0.4), frame_003 (x2 = 1.08571429) and frame_005 (x4 = 1.00000023). Legends show the right index and value; titles fit; all iterates are inside the windows (aa ylims −5..22, P(3) = 17; ab ylims −4..60, P(4) = 54). The later Case 2 steps are small at this scale; the legend values carry them.
- `git status --short -- pages/numerical-methods/madsen-reid-method` after regeneration:
  ```
   M pages/numerical-methods/madsen-reid-method/index.qmd
   M pages/numerical-methods/madsen-reid-method/madsreidaa.gif
   M pages/numerical-methods/madsen-reid-method/madsreidaa.jl
   M pages/numerical-methods/madsen-reid-method/madsreidab.gif
   M pages/numerical-methods/madsen-reid-method/madsreidab.jl
   M pages/numerical-methods/madsen-reid-method/madsreidac.jl
  ```

## Legacy archive
Consulted: `grep -rIl -i madsen` and `reid` over `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/` find only bibliography entries for unrelated Madsen papers (Hald & Madsen 1985, l1 optimization, in the Newton-search bibliography). There is no Madsen-Reid module or example in the archive, so nothing was compared.

## Notes
- The Madsen-Reid 1975 report (AERE-R.7986) was not available. The multi-step search implemented here (try z − pΔz, p = 2..n, while |f|² decreases) follows the page's own wording ("multiple steps in the same direction") and the round-1 reviewer's description of Madsen's algorithm; it is not checked against the original Fortran. The real algorithm also has a stage-switch test and deflation that these one-root animations do not implement; the page's Stage 1/Stage 2 labels describe what the scripts do. Jason may want to check the implementation against the report.
- With the acceleration implemented, Case 1 changed too: its first step is now a 2Δx multi-step (x1 = 1.5833) instead of a Newton step (old x1 = 2.2917). The page text and alt text describe the new run.
- Not changed (no finding names them, general description): "robust, globally convergent" in the intro, the deflation paragraph, and the generalization note apart from the "relaxing the step-size limit" phrase.
- Quarto render of the page was not run by me (it would write outside the page folder).

## Resolution check (independent checker, not shown this record)

Work: `check/indep.py` is an independent Python replay of the algorithm as the page now describes it, plus an mpmath reference root and a plain-Newton baseline. `check/run/` holds scratch copies of the three scripts, run with the global Julia environment. `check/frames_{aa,ab,ac}/` hold the extracted frames and contact sheets.

### Original findings

### F1 — resolved
- The acceleration is now implemented in all three scripts. After a step that reduces |f|², the script tries x − pΔx for p = 2..n_deg and keeps the last point where |f|² still decreases (aa/ab n_deg = 3, ac n_deg = 2). The diff shows no other change to the iteration.
- My replay, written from the page text, reproduces every iterate. Case 2 now gives errors −0.6, 8.57e-2, 1.17e-3, 2.30e-7. Those fall quadratically: e_{k+1}/e_k² ≈ 0.16 and 0.167. Under plain Newton the error ratio was → 0.5.
- The r0 text now matches the code. r0 is described as a cap that is reset to 5× the latest Newton step and only limits steps. My replay finds that the cap clips no step in any of the three runs.
- The title "Damped Newton with Acceleration" is now accurate.

### F2 — resolved
- The Case 2 paragraph and alt text were rewritten from the new run. Every claim checks against the replay: 4 steps, all multi-step (k = 3, 2, 2, 2); x1 = 0.4; no damping; x4 = 1.0000002296; |P(x4)| = 1.58e-13 (mpmath 1.582e-13); errors as stated; the run stops on tolerance.
- The plain-Newton comparison is also correct: x14 − 1 = 3.354e-4.
- In the GIF, every segment is green and the legend reads x0…x4 = 4.0, 0.4, 1.08571429, 1.00117417, 1.00000023.

### F3 — resolved
- Line 14 now says that each step covers 1/m of the remaining distance and that the error shrinks by (m−1)/m per step. Both are correct.
- They are consistent with plain Newton on Case 2: error ratio → 0.5 and step/error → 0.5.

### F4 — resolved
- Line 42 now reads "In Case 3, star markers show the exact roots."
- Only madsreidac draws stars, at ±2i (frame_008 viewed). The aa and ab frames have no stars.

### F5 — resolved
- Case 1 text is rewritten. Step 1 is a doubled step to x1 = 1.58333: |P|² is 17.31 at k=1, 3.17 at k=2 and 8.73 at k=3. Steps 2–6 are full Newton steps, with no damping.
- The errors 9.78e-2, 6.40e-3, 3.02e-5 and 6.75e-10 for x2..x5 match the text. x6 = 1.8793852415718169 equals the double-rounded mpmath root exactly.
- The GIF shows the first move in green (tangent to 2.2917, then along the axis to 1.5833) and later moves in blue.

### F6 — resolved
- The replay gives z1 = −0.25 (1 halving), then z2 = 0.0546875 + 0.40625i (4 failed halvings, then alterdirection), then z3 (1 halving), then 4 full Newton steps.
- At z1 the last halving gives |P|² = 16.536, against 16.504 at z1. The "polyline" wording is correct.
- With n_deg = 2, no multi-step is ever taken (the 2Δz trial is always worse), as the page says. The GIF is byte-identical to the previous one, which is right because the iterates did not change.

### F7 — resolved
- The fake real-axis "reversal" is gone. aa and ab now `error()` if alterdirection is ever reached, and my replay confirms it never is.
- The page describes the rotation as multiplication by 0.6 + 0.8i, which matches the ac code (atan(0.8/0.6) = 53.13°). It says the rotation can only be shown in Case 3.
- "Guarantees" is softened. The page now states that an alterdirection step is accepted without a descent check. |f|² decreases at every step in all three runs: Case 1 289 → … → 7.9e-31; Case 2 2916 → … → 2.5e-26; Case 3 25, 16.50, 14.73, 13.49, 0.203, …
- The fixer did not add a descent check to the ac code. It disclosed the missing check instead, which the finding allowed.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| qmd:14 | f/f' ≈ (x−x*)/m, step covers 1/m, error factor (m−1)/m | Taylor expansion; Case 2 plain-Newton ratio → 0.5 | true |
| qmd:14 | tries z−2Δz … z−nΔz, keeps last decreasing point | matches code loop (break on first non-decrease) | true |
| qmd:14 | near multiplicity-m root that point is z−mΔz; converges quadratically | e(1−k/m)^m is minimised at k = m; Case 2 picks k = 2 at steps 2–4; quadratic errors | true (asymptotic) |
| qmd:16-18 | r0 reset each iteration to 5× latest Newton step length | code `r0 = r*5`, where r is the unclipped length | true |
| qmd:20 | limit can only shorten a step; shortens none in the animations | clip=False in all 17 steps; but see new problem N1 for ac | true for aa/ab; see N1 |
| qmd:24-28 | Stage 2 / multi-step / damped definitions; 4 halvings; 53.13°, 0.6+0.8i; "only shown in Case 3" | code reading; atan2(0.8,0.6) = 53.130° | true |
| qmd:30 | not a guarantee; alterdirection unchecked; |f|² decreases every step in all three | replay |f|² sequences | true |
| qmd:34 | same derivatives plus extra f evaluations at trial points | code | true |
| qmd:38 | "acceleration by repeated steps in the same direction" | code | true |
| qmd:42 | blue/green/orange meaning; green drawn as tangent then along the axis; stars only in Case 3 | aa/ab plotting code; frames | true |
| qmd:48 | x1 = x0 − 2Δx ≈ 1.5833, passes root | 3 − 2·(17/24) = 1.58333 < 1.87939 | true |
| qmd:48 | errors 9.8e-2, 6.4e-3, 3.0e-5, 6.7e-10 (x2..x5); x6 = x* to double precision | replay plus mpmath | true |
| qmd:52 alt | doubled first step to 1.5833, then quadratic Newton | as above | true |
| qmd:56 | Newton error halves, 3.4e-4 after 14 steps | 3.354e-4 | true |
| qmd:56 | 3Δx to x1 = 0.4 past root; then 2Δx three times; errors 8.6e-2, 1.2e-3, 2.3e-7; stops after 4 steps; x4 ≈ 1.00000023; |P(x4)| ≈ 1.6e-13; no damping | replay; mpmath |P(x4)| = 1.582e-13 | true |
| qmd:60 alt | four multi-steps (3Δx, then 2Δx ×3) | replay | true |
| qmd:64 | z1 = −0.25 by a halved step; Newton and 4 halvings fail at z1; z2 = 0.0546875+0.40625i; orange 1 and 3 halved, orange 2 rotation; last 4 blue; no multi-step; polyline to +2i | replay | true |
| aa/ab.jl legend | "Stage 1 – multi-step kΔx"; ab label sigdigits = 9 | frames | correct and legible |

### New problems

**N1 — Minor — qmd:16-20 vs madsreidac.jl:43-45.**
- The page says the r0 limit "can only shorten a step". In the complex script, a step longer than r0 is passed through `alterdirection(dz, r0/r)`, which also rotates it by 53.13°.
- No step is clipped in any animation, so nothing shown is wrong. The general statement does not match the Case 3 code, though.
- Fix: either say "shortens (and, in the complex version, rotates)" or change the ac clip to `dz*(r0/r)`.

**N2 — Minor (legibility, pre-existing scale) — madsreidab.gif frames 3–5.**
- Steps 2–4 of Case 2 cover |P| ≤ 0.023 on a y-axis that spans 64 units, so the "2Δx three times" moves are sub-pixel.
- The reader can only see them through the legend values. The page claims are still true. Fix: an inset or zoom would help (optional).

**Note (not counted).** The page's rule for Stage 2 ("the doubled step does not reduce |f|² further") is a simplification. Madsen's original enters Stage 2 through a convergence test. I could not check this against the 1975 report, so I do not flag it.

### Reproducibility and conventions
- All three changed or affected scripts ran from scratch copies with exit code 0.
- madsreidaa.gif and madsreidab.gif are byte-identical to the working-tree GIFs (sha256 4022a057… and b36a6d17…).
- madsreidac.jl changed but its GIF did not. The regenerated madsreidac.gif is byte-identical to the committed one (sha256 a61ba646…, the same as the HEAD LFS oid), as it should be.
- Frames viewed:
  - aa frame_002 and frame_007
  - ab frame_002 and frame_005, plus the contact sheet
  - ac frame_008
- Conventions are kept:
  - Description comes before Animations.
  - Each of the 3 cases has a source link and an embed.
  - The alt text is descriptive.
  - There are no code blocks.
- Only files in the page folder were modified for this page. The untracked `reviews/numerical-methods-animations/fixes/madsen-reid-method.md` is the fixer's report and is outside the published page.

### Re-check

This round touched three files. madsreidaa.jl/.gif and madsreidac.jl/.gif are byte-identical to the copies I checked in round 1. In madsreidab.jl only plotting code changed: the window now zooms from frame 2 on, the legend position moves, and the curve is resampled. `mr_iterates` is unchanged, so the iterates, labels and every number in the Case 2 text stay the same as in my replay. In index.qmd, line 20 was rewritten and a zoom sentence was added to the Case 2 Behavior paragraph and alt text.

### N1 — resolved
- The new text says a step longer than r0 is cut to length r0. Cases 1 and 2 keep its direction, Case 3 also rotates it 53.13°, and the limit never acts in these runs.
- The code agrees. aa/ab use `dz*(r0/r)`, so |dz| = r0 and the direction is kept. ac uses `alterdirection(dz, r0/r)`, which is dz·(0.6+0.8i)·r0/r, so |dz| = r0 and the step is rotated by atan2(0.8, 0.6) = 53.13°.
- "Never acts" holds: clip = False in all 17 steps of my replay.

### N2 — resolved
I viewed all 5 frames of the regenerated madsreidab.gif at full size. Frames 0–1 use the full window as before. Frames 2–4 zoom to the latest step, and each is built from the right quantities:

| Frame | Tangent | Axis segment | Check |
|---|---|---|---|
| 2 (legend x2 = 1.08571429) | from (0.4, 0.864) to 0.743 | 0.743 → 1.0857 | 0.4 + 0.343 = 0.743; P(0.4) = 0.864 |
| 3 (legend x3 = 1.00117417) | from (1.0857, 0.0227) to 1.0434 | 1.0434 → 1.00117 | P(x2) = 0.02267 |
| 4 (legend x4 = 1.00000023) | from (1.001174, 4.14e-6) to 1.000587 | 1.000587 → 1.0000002 | P(x3) = 4.138e-6 |

- The tick labels are legible, and the legend does not cover the step.
- New text, "steps shrink from 0.69 to 0.0012 in x": the steps are |x2 − x1| = 0.6857 and |x4 − x3| = 0.001174. True.
- New text, "tangent reaching the axis halfway along the step": for k = 2 the Newton point x − Δx lies exactly halfway to x − 2Δx. True by construction, and it can be seen in the frames.
- The alt-text addition about the zoom is true.

### F1–F7 — still resolved
No algorithm code changed in any script, and the iterates are identical to my replay. The page text for F1–F7 is unchanged apart from the N1 sentence, which replaced the round-1 wording and is correct.

### Reproducibility and conventions
- I ran all three scripts again from fresh scratch copies (`check/run2/`). Each exits 0 and produces a GIF byte-identical to the working tree.
- No file outside the page folder changed for this page.
- Conventions are still kept.

### New problems
None. This rests on: the code diff (plotting only); the full-size view of all 5 ab frames; hand checks of each plotted coordinate; and the byte-identical reruns.

**Final status:** committed
