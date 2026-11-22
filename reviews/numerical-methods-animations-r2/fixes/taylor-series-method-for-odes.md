# Fix record: taylor-series-method-for-odes

Scratch folder (all evidence, re-runnable): `$FIX = /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/taylor-series-method-for-odes/fix/`

| Script | What it does |
|---|---|
| `check.py` | sympy total derivatives of f = 1 − t·y^(1/3) in c = ∛y; independent Taylor-3/4 sweep under three cube-root conventions (real, principal complex, \|y\|^(1/3)); compares with Mathews' printed y(5) |
| `conv.py` | a fourth convention (complex, real part per step); none of these reproduces the negative-going legacy frames |
| `mathews_conv.py` | Mathews' own printed derivative formulas (archive image `TaylorDEMod_gr_276.gif`) and the real-cube-root formulas; compares both with all 42 legacy y(5) values |
| `traj.py` | tail nodes, max and min of every run (both orders) |
| `check2.py` | DOP853 reference (rtol 1e-13); per m: y(5), error, max node error, onset t_on (brentq on h·\|J(t)\| = limit), monotone-after-peak test, negative nodes, amplification test \|e(5)\| vs \|e\| at the last node before t_on |
| `check3.py` | extra numbers: max node error over m ≥ 40 / m ≥ 36, m = 100 errors, \|e(5)\| sequences, order-4 late rises for m = 36, 40 |
| `gain.py` | step-map gain ∂Φ/∂y along each run (used only to decide the wording, see Notes) |
| `instr_aa.jl`, `instr_bb.jl` | the new scripts with the animation removed, printing limit, J(5), h*, and per-m y(5), error, onset |
| `labels.jl`, `stack.jl`, `gifdelays.py` | legacy label strips, archive code-image stack, GIF frame delays |

## Findings

### F1 — Minor (Fidelity) — fixed

- **Reproduced:** yes. The committed scripts ran one fixed run (n = 100, h = 0.05) revealed 5 steps per frame; the legacy `Tayloraa.gif` and `Taylorbb.gif` are step-refinement sweeps.
  - `julia $S/tools/giftools.jl .../OrdinaryDE/Taylor1/Tayloraa.gif $FIX/legacy/Tayloraa` (and `Taylor2/Taylorbb.gif`): 33 and 32 frames, every frame 100 cs (`gifdelays.py`). Distinct frames from `frames.md5` (`uniq -f1 -c`): order 3 has 3 blank frames, frames 4, 6, …, 20 held 2 frames each, then 22–33 single; order 4 has 3 blank frames, 4, 6, …, 18 held 2, then 20–32 single. That is 21 distinct runs in each GIF.
  - Label strips (`labels.jl`, `aa1.png aa2.png bb1.png bb2.png`) give the **same** m sequence for both orders: m = 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150. The reviewer's 10-value lists (and the different order-4 list) came from the contact sheet, which samples every 3rd frame.
  - Legacy y(5), order 3: 0.1766603, −3.4636068, 0.1563161, 0.1341734, 0.0895215, −0.0401212, −0.0212395, 0.0127828, 0.0251901, 0.0083511, 0.00816, 0.0081204, then 0.0081199 for m = 52 … 150.
  - Legacy y(5), order 4: 0.4929678, 0.2026955, −554.44545, 0.0666066, 0.0711898, −39.08622, −21.680298, −0.080651, 0.0081972, 0.0094813, 0.0081717, 0.0081225, 0.0081201, 0.00812, then 0.0081199 for m = 60 … 150.
- **Change (R2-B):**
  - `taylorderivativeaa.jl`, `taylorderivativebb.jl` rewritten on the Runge-Kutta pattern: one frame per m (21 frames, fps 1), full run over [0, 5]; two-line title `Taylor order p for y' = 1 - t·y^(1/3), y(0) = 1\nm = $m subintervals, h = 5/$m`; shaded `vspan` [t_on, 5] labelled `h·|∂f/∂y| > <limit>`; gray reference curve (own method, 50 000 steps); run polyline with node markers; red dot at (5, y_m) when in the window; text block `y(5) = %.7f`, `error = %+.1e`, `reference y(5) = %.7f`, stability line.
  - Differences from the RK pattern, all because these runs leave the window: fixed window ylims (−0.3, 1.8) for all frames; nodes below −0.3 drawn as `:dtriangle` markers on the bottom border (legend "node below -0.3 (off scale)"); an extra text line `min y = %.4g at t ≈ %.2f (off scale)` with the true minimum; legend moved to `:bottomleft` and the text block raised to y = 1.72 … 1.30, because order-3 m = 20 spikes to 1.216 at t = 4.25, which would cross the RK text position (y 0.87–1.22). The y values in the text are always the true computed values.
  - `taylorderivativeaa.jl` now uses `cbrt(y)` (real cube root) in the derivatives instead of `y^(1/3)`, which throws a DomainError for y < 0; order-3 m = 12 and 14 go negative mid-run. The formulas are unchanged otherwise (written in c = cbrt(y): c^(-2), c^(-5)).
  - `index.qmd`: Animations intro, both case headings, both Behavior paragraphs and both alt texts rewritten (see Ledger).
- **Check:**
  - Script values = independent Python values. Order 3, `instr_aa.jl` against `check2.py`: the y(5) values agree in every printed digit, e.g. m = 14: −109.0749263341 / −109.0749263, m = 44: 0.0081600353 / 0.0081600. Order 4, `instr_bb.jl` against `check2.py`: also every printed digit, e.g. m = 16: −7665.8734003132 / −7665.8734003.
  - Reference: script `yex5` = 0.008119920464867961 (both orders); DOP853 0.008119920465; round-2 reviewer's mpmath 0.00811992046486796.
  - Legacy reproduction (`mathews_conv.py`, `check.py`): with the real cube root, all printed values are reproduced for order 3 except m = 12, 14 (19 of 21), and for order 4 for m = 32 … 150 (14 of 21). The exceptions are exactly the runs with a negative node before t = 5 (`check2.py` `neg_at`). With Mathews' own printed derivative formulas, **all 42** printed values are reproduced, and so is the n = 25 order-4 y(5) = −89.8028 printed in the module (`−89.80280802`). So the differences come from the y < 0 convention and nothing else; see Legacy archive.
  - Frames viewed; see Scripts and GIFs.

## Ledger of changed text

Numbers from `check2.py` / `check3.py` (Python, DOP853 reference) unless stated; the Julia instrumented runs agree in every printed digit.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Intro | "repeats Mathews' step-refinement sweep … complete Taylor-method run with m subintervals (h = 5/m)" | scripts: `for m in ms`, `h = (T - t0)/m`; legacy frames each a full run | yes |
| Intro | "21 values of Mathews' animations, m = 12, 14, …, 150" | label strips aa1/aa2/bb1/bb2 → same 21 values in both GIFs; `ms` in both scripts | yes |
| Intro | "fine-step reference solution", "labelled with the computed y(5) and its error" | `taylorp(50_000)`; annotate lines; ref vs DOP853 agree (0.008119920464867961 vs 0.008119920465) | yes |
| Intro | "Computed points below y = −0.3 are marked by triangles on the bottom edge, and the run's true minimum is printed" | `low = findall(<(ylims[1]), ys)`, dtriangle at ylims[1]; `min y` line uses `ys[argmin(ys)]`; frames aa 1, bb 2, bb 3 | yes |
| Intro | "∛y is the real cube root, so runs that go negative stay real" | both scripts use `cbrt`; order-3 m = 12 min −8.597 gives real values | yes |
| Intro | Taylor update sentence, O(h^{p+1}) | unchanged text (round-2 ledger L4, L5) | unchanged |
| Case 1 heading | "Taylor order 3 step-refinement sweep, …, m = 12 to 150 subintervals" | `ms`; GIF title "Taylor order 3 … m = $m subintervals" | yes |
| Case 1 | first three sentences (p = 3, O(h⁴)/O(h³), symbolic derivatives) | unchanged (L8–L10) | unchanged |
| Case 1 | reference rises to about 1.4498 near t = 0.88, decays to y(5) = 0.0081199 | DOP853 peak 1.44977 at t = 0.8836; Julia ref peak 1.4497667 at t = 0.8836; y(5) 0.0081199205 | yes |
| Case 1 | "For m = 12 through 36 the computed curve visibly leaves the reference in the tail" | max node error m = 12…36: 8.61, 109, 0.582, 0.126, 1.20, 0.0482, 0.151, 0.152, 0.0293; m = 40: 2.50e-4. Scale ≈ 185 px per unit (y = 1.5 at px 98, y = 0 at px 376), so 0.029 ≈ 5 px (seen in frame aa 9), 2.5e-4 ≈ 0.05 px | yes |
| Case 1 | y(5) ≈ −4.47 (m = 12), −109 (m = 14) | −4.4676549, −109.0749263 | yes |
| Case 1 | m = 20 jumps from 0.0068 at t = 4 to 1.22 at t = 4.25, ends at 0.0895 | `traj.py`: (4.0, 0.006795), (4.25, 1.216), y(5) 0.0895215 | yes |
| Case 1 | "From m = 40 on, each run decreases steadily after its peak" | `check2.py`: "monotone-after-peak" for every m ≥ 40; m = 36 has a rise of 0.0301 | yes |
| Case 1 | "stays within 3×10⁻⁴ of the reference at every node" (m ≥ 40) | `check3.py`: max node error over m ≥ 40 = 2.5042e-4 | yes |
| Case 1 | m = 100 (h = 0.05): largest node error 1.3×10⁻⁵, error in y(5) −1.2×10⁻⁹ | 1.3272e-5; −1.1859e-9 (frame label "−1.2e-09") | yes |
| Case 1 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | J(5) = −41.2554 (Python and Julia); J decreasing on [1, 5], min on [0, 5] at t = 5 | yes |
| Case 1 | h ≈ 0.0609 (m ≤ 82; here m = 12 to 80) | limit 2.5127453 / 41.255409 = 0.060907, m* = 82.09; sweep: t_on exists for m = 12…80, none for 90…150 | yes |
| Case 1 | stability limit 2.513 | bisection on \|1+z+z²/2+z³/6\| = 1 → 2.5127453 (Julia), brentq 2.51275 (Python) | yes |
| Case 1 | "on y′ = λy with real λ < 0 the method amplifies errors once h\|λ\| exceeds this limit" | R(z) = 1+z+z²/2+z³/6 has R′ = 1+z+z²/2 > 0 (discriminant < 0), so R is increasing, R(−2.5127) = −1, and \|R\| > 1 for z < −2.5127, \|R\| ≤ 1 on [−2.5127, 0] | yes |
| Case 1 | "For m = 12 to 48 the error at t = 5 is larger than at the last node before the shaded region" | `check2.py` AMPLIFIED for m = 12…48; "not" for 52…80 | yes |
| Case 1 | m = 80 shading from t ≈ 4.96 | t_on = 4.958 (Python), 4.9578 (Julia); frame label "4.96" | yes |
| Case 1 | for m = 52 to 80 the error in y(5) stays below 3.1×10⁻⁹ | \|e(5)\| = 1.06e-9, 3.09e-9, 2.93e-9, 2.40e-9, 1.92e-9; max 3.091e-9 | yes |
| Case 1 | at m = 12 the shading starts at t ≈ 3.07 | 3.066 (Python), 3.0664 (Julia) | yes |
| Case 1 | m = 90 to 150 stay below 2.513 up to t = 5 | t_on none for 90, 100, 120, 150 (5/90 = 0.0556 < 0.0609) | yes |
| Case 1 | Mathews' y(5) reproduced to every printed digit for 19 of 21 m; exceptions m = 12 and 14, which go negative before t = 5 | `check.py` / `mathews_conv.py` realcbrt column: MATCH for 16…150; m = 12: −4.4677 vs 0.1766603, m = 14: −109.07 vs −3.4636068. `neg_at`: m = 12 [4.167, 4.583, 5], m = 14 [4.643, 5]; m = 24 and 28 negative only at t = 5 (and they match) | yes |
| Case 1 | Mathews' formulas replace each y^{k/3} by sign(y)\|y\|^{k/3}; for even k and y < 0 the sign is opposite to (∛y)^k | archive `TaylorDEMod_gr_267.gif` (code: rules for k = 1, 2, 4, 5, 8) and `gr_276.gif` (printed d₁…d₄, every fractional power written `Abs[y]^{k/3} Sign[y]`). With c = sign(y)\|y\|^{1/3}, c^k = sign(y)^k\|y\|^{k/3}, which is +\|y\|^{k/3} for even k, while sign(y)\|y\|^{k/3} = −\|y\|^{k/3} for y < 0. Those formulas reproduce all 42 legacy values (`mathews_conv.py`) | yes |
| Case 1 | example y(5) = 0.1766603 at m = 12 | legacy strip aa1; Mathews-formula recomputation 0.1766602634 | yes |
| Case 1 alt | gray reference peaks near 1.45 at t ≈ 0.88, decays to 0.0081 at t = 5 | as above | yes |
| Case 1 alt | m = 12 to 36 leave the reference; drop off the bottom for m = 12 and 14; spike to 1.22 at m = 20 | min y: m = 12 −8.597, m = 14 −109.07, all other order-3 minima ≥ −0.0402 (> −0.3); m = 20 max tail 1.216; frames aa 1, 5 | yes |
| Case 1 alt | shading for m = 12 to 80 exceeding 2.513; from m = 40 the run lies on the reference; y(5) = 0.0081199 at m = 150 | t_on list; max node error ≤ 2.5e-4 for m ≥ 40; m = 150 label "y(5) = 0.0081199" (frame aa 21) | yes |
| Case 2 heading | "Taylor order 4 step-refinement sweep, …, m = 12 to 150 subintervals" | `ms`; GIF title | yes |
| Case 2 | first two sentences (p = 4, O(h⁵)/O(h⁴)) | unchanged (L22, L23) | unchanged |
| Case 2 | m = 12 through 32 visibly leave the reference in the tail and go negative; exact solution stays positive | `neg_at` non-empty for m = 12…32, empty for 36+; max node errors 3.13, 0.755, 7751, 19.9, 10.4, 1505, 951, 0.0888; m = 36: 2.65e-3 (≈0.5 px). Exact solution positive: y′ = 1 > 0 wherever y = 0 (round-2 ledger L13) | yes |
| Case 2 | y(5) ≈ −7666 (m = 16) | −7665.8734003 | yes |
| Case 2 | m = 20: negative at t = 4.25, about −10.4 at t = 4.5, ends at y(5) ≈ −5.25 | (4.0, 0.01419), (4.25, −0.04653), (4.5, −10.43); y(5) −5.2535013 | yes |
| Case 2 | y(5) ≈ −0.081 for m = 32 | −0.0806510 | yes |
| Case 2 | from m = 36 on, within 2.7×10⁻³ of the reference at every node | max node error over m ≥ 36 = 2.6515e-3 | yes |
| Case 2 | at m = 36 and 40 it still turns up once near the end, by about 0.0015 and 0.0005, too little to see | `check3.py`: m = 36 single rise 1.477e-3 on the step ending at t = 4.861; m = 40 single rise 5.467e-4 on the last step. At ≈ 185 px per unit these are 0.27 and 0.10 px | yes |
| Case 2 | from m = 40 on the error in y(5) falls at every refinement, to 4.8×10⁻¹² at m = 150 | \|e(5)\|: 1.36e-3, 5.18e-5, 2.55e-6, 2.29e-7, 3.56e-8, 8.23e-9, 7.16e-10, 1.81e-10, 7.45e-11, 3.85e-11, 1.42e-11, 4.76e-12 (strictly decreasing); m = 36 is 7.73e-5 < m = 40, hence "from m = 40" | yes |
| Case 2 | m = 100: largest node error 8.0×10⁻⁷, more than 16 times smaller than 1.3×10⁻⁵ | 8.0209e-7; 1.3272e-5 / 8.0209e-7 = 16.55 | yes |
| Case 2 | h ≈ 0.0675 (m ≤ 74; here m = 12 to 70), limit 2.785 | 2.7852936 / 41.255409 = 0.067513, m* = 74.06; t_on exists for 12…70, none for 80…150. \|R\| > 1 for z < −2.7853, where R = 1 at the boundary and R → +∞ | yes |
| Case 2 | for all of these m the error at t = 5 is larger than at the last node before the shaded region | `check2.py` AMPLIFIED for every m = 12…70 | yes |
| Case 2 | m = 70 from t ≈ 4.91; m = 12 from t ≈ 3.10 | 4.908 / 4.9083; 3.103 / 3.1033 | yes |
| Case 2 | m = 80 to 150 below 2.785 up to t = 5 | t_on none | yes |
| Case 2 | Mathews' y(5) reproduced to every printed digit for m = 32 to 150; m = 12 to 28 go negative before t = 5 and differ | realcbrt MATCH for 32…150, differ for 12…28; `neg_at` for 12…28 includes nodes before t = 5; m = 32 negative only at t = 5 | yes |
| Case 2 | example y(5) = 0.0711898 at m = 20 | legacy strip bb1; Mathews-formula recomputation 0.07118978141 | yes |
| Case 2 alt | m = 12 to 32 go negative; drop off the bottom for m = 12 to 28 (as low as −7751 at m = 16) | minima: −3.115, −0.7376, −7750.7, −19.88, −10.43, −1504.7, −951.45 (all < −0.3), m = 32 −0.0807 (in window); frames bb 2, 3, 8 | yes |
| Case 2 alt | shading for m = 12 to 70 exceeding 2.785; from m = 36 on the run lies on the reference; y(5) = 0.0081199 at m = 150 | t_on list; max node error ≤ 2.65e-3 for m ≥ 36; m = 150 label | yes |
| GIF titles / labels | "Taylor order 3/4 for y' = 1 - t·y^(1/3), y(0) = 1", "m = $m subintervals, h = 5/$m", "Taylor 3/4, m = $m", "h·\|∂f/∂y\| > 2.513 / 2.785", "node below -0.3 (off scale)", "min y = … (off scale)" | built from the computed quantities in the scripts; frames checked below | yes |

## Scripts and GIFs

- Scripts changed: `taylorderivativeaa.jl`, `taylorderivativebb.jl` (sweep rewrite; aa switched to `cbrt`). Both use Plots and Printf only (Printf is standard library).
- Regenerated in place: `julia taylorderivativeaa.jl`, `julia taylorderivativebb.jl` → 21 frames each, every frame 100 cs (`gifdelays.py`).
- `git status --short -- pages/numerical-methods/taylor-series-method-for-odes` after regeneration: `M index.qmd`, `M taylorderivativeaa.gif`, `M taylorderivativeaa.jl`, `M taylorderivativebb.gif`, `M taylorderivativebb.jl`. These are the expected files only.
- Frames viewed (full size): aa 1 (m = 12: off-scale triangles at t = 4.58 and 5, clipped line, min label −8.597 at t ≈ 4.58, no red dot since y(5) is off scale), aa 5 (m = 20: spike to 1.22 at t = 4.25 clear of the text block, y(5) = 0.0895215), aa 9 (m = 36: small visible bump near t = 4.86), aa 21 (m = 150: no shading, "< 2.513 up to t = 5", y(5) = 0.0081199). bb 2 (m = 14: one triangle at t ≈ 3.93, min −0.7376), bb 3 (m = 16: y(5) = −7665.8734003, min −7751 at t ≈ 4.06), bb 8 (m = 32: last node −0.081 visible in the window). Contact sheets for both GIFs: shading spans and onset labels match t_on, the last shaded frame is m = 80 (order 3) and m = 70 (order 4), labels are legible, and the legend at bottom-left does not cover any run.

## Legacy archive

Consulted.
- `a2001/Animations/OrdinaryDE/Taylor1/Tayloraa.gif` (order 3) and `Taylor2/Taylorbb.gif` (order 4): the same ODE, interval and y(0) as the page. Each is a sweep over the same 21 values of m, with labels "Using m = … subintervals" and "y(5) = …", 1 s per frame, a 3-frame blank lead-in and 2-frame holds on the first 9 (order 3) or 8 (order 4) values. Lead-in and holds were dropped, as on the RK page; the intro states the frame construction.
- `n2003/TaylorDEMod.html`: Examples 11 and 12 are the order-3 and order-4 animations. Solution code images `TaylorDEMod_gr_214` (order-3 subroutine), `gr_228` and `gr_267` (derivative definitions), `gr_276` (printed formulas and an m = 25 order-4 run).
- **Difference, and why the page follows the mathematics:** Mathews replaces every y^{k/3} in his derivative formulas by Sign[y]·Abs[y]^{k/3} (k = 1, 2, 4, 5, 8). For odd k this is the real cube root to the k-th power. For even k and y < 0 it has the wrong sign. So once a run goes negative, his y″, y‴ and y⁗ are not the derivatives of y′ = 1 − t·∛y with the real cube root that his own y′ uses. The page uses the real cube root consistently. Recomputing his formulas reproduces all 42 printed y(5) values (and his n = 25 value −89.8028), which confirms that this convention is the whole cause. The frames that differ are order 3 m = 12, 14 and order 4 m = 12–28. Each Behavior paragraph says this in one sentence, per R2-A.

## Notes

- **Wording of the stability sentence.** The D2/RK form "from then on errors are amplified instead of damped" was not used as a blanket statement. For order 3, m = 52–80 have an onset (h > h*), but |e(5)| is *smaller* than |e| at the last node before the onset (`check2.py`: e.g. m = 52, 1.06e-9 vs 6.04e-8). The actual step-map gain ∂Φ/∂y along the runs (`gain.py`) also differs from R(h·∂f/∂y): for order-3 m = 12–70 its first |G| > 1 (t > 1) comes later than t_on (m = 80 has no step that starts after t_on), and for order-3 m = 12–44 and 52 it is not > 1 at every step after t_on. So the page states the limit as the linear test-equation fact. It then reports the observed amplification per range: order 3 for m = 12–48, order 4 for m = 12–70, and order 3 for m = 52–80 with |e(5)| < 3.1e-9.
- **Order-3 error in y(5) is not monotone in m** (m = 52: 1.06e-9; m = 56: 3.09e-9). The page makes no "falls at every refinement" claim for order 3. For order 4 the claim is made only from m = 40, where it holds.
- **Director's note on visible vs numerical upturns:** order 3 has no tiny-only upturns (every m ≥ 40 is monotone after the peak). For order 4 the tiny ones (m = 36, 40) are stated with their sizes and "too little to see".
- The window (−0.3, 1.8) and the off-scale triangles are new elements, beyond the RK pattern. They are needed because coarse runs reach −7751. Clamped values are never drawn as nodes or labelled; the text shows the true y(5) and the true minimum.
- The reference curve is each script's own method with 50 000 steps (the RK pattern used RK4). Both give y(5) = 0.008119920464867961, which agrees with DOP853 and mpmath.
- The page still has no `## Description` section (convention gap, no finding). Not added. The page was not rendered with Quarto (the director renders the section).
- The old Behavior's h = 0.25 (n = 20) examples are kept in substance as the m = 20 frame descriptions (order 3: 0.0068 → 1.22; order 4: −0.0465 at 4.25, −10.4 at 4.5). The old "starts at t ≈ 3.3" is replaced by per-frame onset labels (m = 20: 3.28 for order 3, 3.34 for order 4), which are not quoted on the page.

## Resolution check (independent checker, not shown this record)

Scratch work: `check/py/` (sweep.py, ledger.py, form.py, back*.py), `check/frames/` (legacy and new frames, contact sheets), `check/aa_labels.png` and `check/bb_labels.png` (the m and y(5) labels of every distinct legacy frame), `check/repro/` (regenerated GIFs).

### Original findings

### F1 — resolved
- Both scripts now animate Mathews' step-refinement sweep (decision R2-B). Each frame is a complete run with m subintervals, over [0, 5], labelled with m, h = 5/m, y(5), its error, the reference y(5), and the stability onset. The m sequence is 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150. I read it from every distinct frame of the legacy `Taylor1/Tayloraa.gif` and `Taylor2/Taylorbb.gif`: 21 values in each, identical in both. (The finding's list of 10 values was a subsample of these.)
- Legacy printed y(5) values, read from the frames:
  - order 3: 0.1766603, -3.4636068, 0.1563161, 0.1341734, 0.0895215, -0.0401212, -0.0212395, 0.0127828, 0.0251901, 0.0083511, 0.00816, 0.0081204, then 0.0081199 for m = 52 to 150.
  - order 4: 0.4929678, 0.2026955, -554.44545, 0.0666066, 0.0711898, -39.08622, -21.680298, -0.080651, 0.0081972, 0.0094813, 0.0081717, 0.0081225, 0.0081201, 0.00812, then 0.0081199 for m = 60 to 150.
- My own Python Taylor-3 and Taylor-4 code uses sympy total derivatives and the real cube root. It reproduces Mathews to every printed digit for order 3 at all m except 12 and 14 (19 of 21), and for order 4 at m = 32 to 150. These are exactly the cases the page claims. The runs that differ are those where y goes negative at an interior node (first negative node: order 3 at t = 4.167 and 4.643; order 4 between t = 3.75 and 4.82). For order-3 m = 24 and 28, y(5) is negative but only the final node is negative, so no derivative is ever evaluated at negative y and they match.
- I checked the page's explanation of Mathews' divergent values. Writing each derivative as a polynomial in y^(1/3) divided by y^(k-1), then replacing each fractional power y^(j/3) by sign(y)|y|^(j/3), reproduces all 9 divergent legacy values to every printed digit:
  - order 3, m = 12, 14: 0.1766603 and -3.4636068;
  - order 4, m = 12, 14, 16, 18, 20, 24, 28: 0.4929678, 0.2026955, -554.44545, 0.0666066, 0.0711898, -39.08622, -21.680298.
  - The same model reproduces the legacy m = 12 spike to y(4.583) = 1.5758.
  - So the page's mechanism is confirmed, and the two examples it quotes (0.1766603 at order-3 m = 12, 0.0711898 at order-4 m = 20) are right.
  - The mechanism depends on the algebraic form: with the fully expanded negative-power form, the same substitution does not reproduce Mathews. The page doesn't say which form, but its statement is true of a natural form.
- The coarse-step behaviour is now visible in the frames:
  - order 3: the m = 12 and 14 runs drop off the bottom, m = 16 and 20 spike, m = 28 and 32 have bumps, and m = 36 has a small visible bump near t = 4.7;
  - order 4: m = 12 to 28 drop off the bottom, and m = 32 ends at -0.081;
  - fine m lie on the reference.
- The two GIFs now differ visibly, as they should.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Animations intro | sweep of m = 12…150 (21 values) "of Mathews' animations" | read from all distinct legacy frames, both orders | correct |
| Intro | h = 5/m; fine-step reference; labelled y(5) and error | script (reference = same-order Taylor, 50 000 steps); frames show y(5), error, reference y(5) | correct |
| Intro | points below y = -0.3 marked by triangles on bottom edge; true minimum printed | frames 1–2 (order 3), 1–7 (order 4): triangles at bottom border, "min y = … (off scale)" printed | correct |
| Intro | real cube root, negative runs stay real | `cbrt` in both scripts | correct |
| Intro | local error O(h^{p+1}) | step halving: y(5) error ratios 9.6, 9.0 (p = 3) and 20.4, 18.1 (p = 4) at m = 200/400/800 → global O(h^p) | correct |
| Case 1 heading | order 3 sweep, m = 12 to 150 | script | correct |
| Case 1 | reference peak about 1.4498 near t = 0.88 | DOP853 rtol 1e-13: max 1.449767 at t = 0.8836 | correct |
| Case 1 | y(5) = 0.0081199 | mpmath odefun (30 digits) 0.00811992046486796 | correct |
| Case 1 | m = 12–36 visibly leave the reference in the tail | max node errors 8.6, 109, 0.58, 0.13, 1.2, 0.048, 0.15, 0.15, 0.029 (m = 36: bump of 0.03, visible in frame 9); m = 40: 2.5e-4 (invisible) | correct |
| Case 1 | y(5) ≈ -4.47 (m = 12), -109 (m = 14) | -4.4676549, -109.0749 | correct |
| Case 1 | m = 20: 0.0068 at t = 4, 1.22 at t = 4.25, ends 0.0895 | 0.006795, 1.2162, 0.0895215 | correct |
| Case 1 | from m = 40: decreases steadily after peak, within 3e-4 at every node | no increasing step after the peak for m ≥ 40; max node error 2.50e-4 (m = 40), decreasing after | correct |
| Case 1 | m = 100: largest node error 1.3e-5, error in y(5) -1.2e-9 | 1.33e-5, -1.19e-9 | correct |
| Case 1 | ∂f/∂y = -t/(3y^{2/3}) reaches -41.3 at t = 5 | 41.2554; |∂f/∂y| is monotone increasing on [0, 5] along the solution | correct |
| Case 1 | threshold h ≈ 0.0609, m ≤ 82; here m = 12–80 | 2.51275/41.2554 = 0.06091, 5/h = 82.09 | correct |
| Case 1 | order-3 limit 2.513; amplification on y' = λy beyond it | root of \|1+z+z²/2+z³/6\| = 1 at z = -2.51275 | correct |
| Case 1 | m = 12–48: error at t = 5 larger than at last node before shading | true for m = 12–48, false for m = 52–80 | correct |
| Case 1 | m = 80 shading from t ≈ 4.96; m = 12 from t ≈ 3.07 | onset 4.958 and 3.066 | correct |
| Case 1 | m = 52–80: \|error in y(5)\| < 3.1e-9 | 1.06e-9, 3.09e-9, 2.93e-9, 2.40e-9, 1.92e-9 | correct |
| Case 1 | m = 90–150: below 2.513 up to t = 5 | 41.255·5/90 = 2.29 < 2.513 | correct |
| Case 1 | Mathews reproduced for 19 of 21; exceptions m = 12, 14 go negative before t = 5 | see F1 | correct |
| Case 1 | sign(y)\|y\|^{k/3} mechanism; opposite sign to (∛y)^k for even k, y < 0; Mathews 0.1766603 at m = 12 | algebra; my model reproduces all divergent values (see F1) | correct (form-dependent, see F1) |
| Case 1 alt | reference peaks near 1.45 at t ≈ 0.88, decays to 0.0081 | as above | correct |
| Case 1 alt | m = 12–36 leave reference; off the bottom for m = 12 and 14; spike to 1.22 at m = 20; shading m = 12–80; on the reference from m = 40; y(5) = 0.0081199 at m = 150 | minima: m = 12: -8.6, m = 14: -109; all others ≥ -0.041 > -0.3; no run exceeds 1.8 (top of plot); frames agree | correct |
| Case 2 heading | order 4 sweep, m = 12 to 150 | script | correct |
| Case 2 | m = 12–32 visibly leave and go negative | min y < 0 for every m in 12–32; m = 32 ends at -0.0807 (visible in frame 8) | correct |
| Case 2 | y(5) ≈ -7666 (m = 16); m = 20 negative at t = 4.25, ≈ -10.4 at t = 4.5, y(5) ≈ -5.25; y(5) ≈ -0.081 (m = 32) | -7665.873; first negative t = 4.25, -10.434 at 4.5, -5.2535; -0.0806510 | correct |
| Case 2 | from m = 36: within 2.7e-3 at every node | 2.65e-3 (m = 36), 1.36e-3 (m = 40), then smaller | correct |
| Case 2 | m = 36 and 40 turn up once near the end by ≈ 0.0015 and 0.0005, too little to see | one rise after the peak in each: 1.48e-3 at t = 4.72, 5.47e-4 at t = 4.875 (under 1 px) | correct |
| Case 2 | from m = 40 the error in y(5) falls at every refinement, to 4.8e-12 at m = 150 | 1.36e-3, 5.2e-5, 2.6e-6, 2.3e-7, 3.6e-8, 8.2e-9, 7.2e-10, 1.8e-10, 7.5e-11, 3.9e-11, 1.4e-11, 4.76e-12 (against the mpmath reference) | correct |
| Case 2 | m = 100: largest node error 8.0e-7, more than 16× smaller than 1.3e-5 | 8.02e-7; ratio 16.6 | correct |
| Case 2 | threshold h ≈ 0.0675, m ≤ 74; here m = 12–70; limit 2.785 | 2.78529/41.2554 = 0.06751, 5/h = 74.06 | correct |
| Case 2 | for all m = 12–70, error at t = 5 is larger than at the last node before shading | true for every one | correct |
| Case 2 | m = 70 shading from t ≈ 4.91; m = 12 from t ≈ 3.10 | 4.908, 3.103 | correct |
| Case 2 | m = 80–150 below 2.785 up to t = 5 | 41.255/16 = 2.58 < 2.785 | correct |
| Case 2 | Mathews reproduced for m = 32–150; m = 12–28 go negative before t = 5; 0.0711898 at m = 20 | see F1 | correct |
| Case 2 alt | m = 12–32 go negative; off the bottom for m = 12–28; as low as -7751 at m = 16; shading m = 12–70; on the reference from m = 36 | minima -3.12, -0.74, -7750.7, -19.9, -10.4, -1504.7, -951.4 (all < -0.3); m = 32: -0.081 (> -0.3); max over all runs 1.449 | correct |
| Script titles and labels | "Taylor order p for y' = 1 - t·y^(1/3), y(0) = 1 / m = …, h = 5/m"; legend; annotations | full-size frames 1, 2, 11, 21 (order 3) and 1, 3, 8, 11, 21 (order 4): legible, values match my computation | correct |

### New problems

None. This rests on four things:
- I recomputed both sweeps independently (sympy derivatives, Python), against a 30-digit mpmath reference.
- Every number in the changed text matched.
- The legacy values matched, including a model of Mathews' negative-y arithmetic that reproduces all 9 divergent legacy values.
- I viewed the first, middle, last and key frames at full size.

Observation, not a defect: the reference curve is a 50 000-step same-order Taylor run, not a closed-form solution. R2-B asks to keep the exact-solution reference curve, but this ODE has none in closed form, and this reference agrees with the mpmath value of y(5) to about 1e-14.

### Reproducibility and conventions

- **Reproducibility.** I ran both changed scripts from scratch copies. Their output is byte-identical to the committed GIFs (sha256 f08d83b0… for aa, 3a067f10… for bb), and the decoded frame md5s are also identical. Each GIF has 21 frames at 1 fps.
- **Conventions:**
  - each case has a source link and a GIF embed;
  - the alt text is descriptive;
  - there are no code blocks.
- **Pre-existing, not introduced by this fix:** the page has no `## Description` section before `## Animations`. HEAD lacks it too, and the diff does not touch it.
- **Scope.** `git status` on the page folder shows only the 5 page files. Other pages are modified in the working tree, but they belong to other fixes, and fix.diff covers only this folder.

**Final status:** committed
