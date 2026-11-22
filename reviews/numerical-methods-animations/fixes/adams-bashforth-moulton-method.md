# Fix record: adams-bashforth-moulton-method

Scratch evidence folder (re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/adams-bashforth-moulton-method/fix/` (below: `$FIX`). Python checks are run as `cd $FIX/py && /usr/bin/python3 -I <script>.py`; each script's output is saved beside it as `<script>.out`.

- `py/stability.py`: ABM4 PECE characteristic polynomial (sympy), root-locus sampling and a direct scan of max|root| on z ∈ [−3, 0).
- `py/zstar.py`: refines the real-axis stability limit z* with `mp.findroot` (30 digits).
- `py/analysis.py`: reference solution (mpmath `odefun` at 30 digits, scipy Radau and DOP853 at rtol 1e-13), J = ∂f/∂y along it, h_max and n_min, instability onset by n, an independent ABM4-PECE (RK4 starter) for n = 50…200, the n = 50 table and the n = 200 values at frame times.
- `py/textchecks.py`: sympy ∂f/∂y, exact peak, rounding of the quoted numbers.
- `py/archive_repro.py`: reproduces the y(5) labels of Mathews' `Adamsaa.gif` and the Example 11 runs.
- `abm_instrumented.jl`: the fixed script's own computation (lines 8-69 copied verbatim), plotting removed, printing added.
- `labels.jl`: crops and tiles the label strip of the archive GIF's distinct frames.
- `archive_gif/`, `new_gif/`: extracted frames (giftools.jl).

## Findings

### F1 — Error — fixed
- **Reproduced:**
  - `py/analysis.py` (independent ABM4-PECE, RK4 starter) at n = 50 (h = 0.1): y_48 = −0.0018309 at t = 4.8 (exact +0.0092030), y_49 = 0.0308130 (exact 0.0086385), y_50 = 0.1380900 against the exact y(5) = 0.008119920464867961 (mpmath odefun, dps 30; Radau 0.008119920464867916, DOP853 0.008119920464867977). Ratio 17.01 (`py/textchecks.py`). The trace decreases strictly from its peak until t = 4.8 and then rises (first increases on [4.8, 4.9] and [4.9, 5.0]). Error signs at t = 3.0, 3.1, …, 5.0: `---+++---++--------++`. Max error on t ≤ 3.3 is 1.4e-4.
  - The script's own routine gives the same y_48, y_49, y_50 (`julia abm_instrumented.jl`: −0.0018309, 0.0308130, 0.1380900).
  - Stability limit (not computed by the pattern-setter): `py/stability.py` derives the PECE characteristic polynomial ζ⁴ − (1 + 7z/6 + 55z²/64)ζ³ + (5z/24 + 59z²/64)ζ² − (z/24 + 37z²/64)ζ + 9z²/64 (roots 1, 0, 0, 0 at z = 0). Scan of max|root| on [−3, 0): the largest unstable z is −1.28482; max|root| < 1 on the whole of (z*, 0) (max 0.999999 at z = −1e-6, where the principal root → 1). No root crosses at ζ = −1 (the ζ = −1 equation 5z²/2 + 17z/12 + 2 = 0 has only complex roots); the crossing is a complex pair at θ = 1.5585. `py/zstar.py` refines it: **z* = −1.284816263** (max|root| = 1 + 6.2e-9 at z* − 1e-8 and 1 − 6.2e-9 at z* + 1e-8).
  - J = ∂f/∂y = −t/(3y^{2/3}) (sympy, `py/textchecks.py`); along the DOP853 solution at 50001 points J decreases monotonically, J(5) = −41.2554. h_max = z*/J(5) = 0.031143, n_min = 161 (n = 160: onset t = 4.9944; n = 161: none). For h = 0.1 the onset (h|J(t)| = 1.2848) is t = 3.4526.
  - The finding holds. The independent-check note (limit ≈ −1.285, h·∂f/∂y reaching −4.1) agrees: h·J(5) = −4.1255 at h = 0.1.
- **Change (decision D2 default):**
  - `adamsbashforthmoultonaa.jl`: `n_steps = 50` → `n_steps = 200` with a comment; new `stride = 4`; loop `1:length(ts)` → `1:stride:length(ts)` (51 frames at t = 0.1k, as before; fps 2 unchanged; the line is drawn through all computed points `ts[1:frame]`); title `"ABM4: y' = 1 - t*cbrt(y), y(0)=1"` → `"ABM4, h = 0.025: y' = 1 - t*cbrt(y), y(0)=1"`; `xlims (0, 5)` → `(-0.1, 5.1)`, `ylims (0, 1.55)` → `(-0.05, 1.55)` with a comment (see Notes). GIF regenerated.
  - `index.qmd`: intro "with the historical $n=50$-step setup (51 mesh points)" → "computed with $n=200$ steps ($h=0.025$) instead of the $n=50$ steps ($h=0.1$) of the module's first run (see Behavior). Each frame adds four steps (0.1 in $t$); the connecting curve passes through every computed point."; heading gets ", $n=200$ steps ($h=0.025$)"; Behavior paragraph replaced by an accuracy sentence for h = 0.025 and the D2 stability sentence in the director's corrected wording; alt text rewritten.
  - Description "giving high accuracy with low per-step cost" left unchanged: it is a general statement and now sits beside a run whose error is at most 3.1e-7.
- **Check:**
  - n = 200: h·J(5) = −1.0314, inside (z*, 0); no onset on [0, 5]. `py/analysis.py`: min y = min predictor = 8.1199e-3 (all positive), min RK4 starter stage 1.0123, strictly decreasing after the peak (1.449725 at t = 0.875), max |error| over 201 step points 3.087e-7 at t = 3.300, error at t = 5 −2.579e-11.
  - `julia abm_instrumented.jl` (the fixed script's code): identical figures (y(5) = 0.0081199204, err −2.579e-11, max |ABM − RK4 ref| 3.087e-7 at t = 3.300, peak 1.449725 at 0.875, strictly decreasing after peak: true, 51 frames, last frame index 201 at t = 5.00, labels y_0, y_4, …, y_196, y_200). The script itself prints Final y(5) = 0.008119920439074675.
  - Frames viewed: see "Scripts and GIFs".

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd intro | "$n=200$ steps ($h=0.025$)" | script `n_steps = 200`, tf−t0 = 5 → h = 0.025 (`abm_instrumented.jl` → "n=200 h=0.0250") | yes |
| index.qmd intro | "the $n=50$ steps ($h=0.1$) of the module's first run" | archive Example 11 (`AdamsBashforthMod_lnk_12.html`, images gr_166/173/180): runs n = 50, then 100, then 150; gr_170 value table has step 0.1 | yes |
| index.qmd intro | "Each frame adds four steps (0.1 in $t$); the connecting curve passes through every computed point" | `stride = 4`, `frame in 1:stride:length(ts)`, `plot!(ts[1:frame], ys[1:frame])`; 4 × 0.025 = 0.1; `giftools` → 51 frames; labels y_0, y_4, …, y_200 | yes |
| index.qmd heading | ", $n=200$ steps ($h=0.025$)" | as above | yes |
| Behavior | "within $3.1\times10^{-7}$ of the exact solution at all 201 step points (the largest error is near $t=3.3$)" | `py/analysis.py` n=200 → max\|err\| = 3.087e-7 at t = 3.300 (vs DOP853); `abm_instrumented.jl` vs RK4 h=1e-4 ref → 3.087e-7 at t = 3.300 | yes |
| Behavior | "the error at $t=5$ is $2.6\times10^{-11}$" | `py/analysis.py` → err(5) = −2.579e-11; Julia → −2.579e-11 | yes |
| Behavior | "exact $y(5)=0.0081199$" | mpmath odefun dps 30 → 0.008119920464867961 | yes |
| Behavior | "steps longer than about $h=0.0311$" | `py/textchecks.py` → h* = 1.284816/41.2554 = 0.031143 → 0.0311 | yes |
| Behavior | "stability limit $1.285$" (ABM4 predictor-corrector, i.e. PECE as scripted) | `py/zstar.py` → z* = −1.284816263; `py/stability.py` scan → stable on all of (z*, 0) | yes |
| Behavior | "$\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$" | sympy → −t/(3y^{2/3}); `py/analysis.py` → J(5) = −41.2554, J monotone on [0,5] | yes |
| Behavior | "exceeds … before $t=5$" for every h > h* | J monotone ⇒ h\|J(t)\| crosses 1.2848 before t = 5 iff h > h*; n = 160 onset 4.9944, n = 161 none | yes |
| Behavior | "just above $h=0.0311$ this affects only the last steps" | n = 160 (h = 0.03125) onset 4.9944 (last step); n = 150 onset 4.8896 (last 4 steps) | yes |
| Behavior | "at the module's $h=0.1$ ($n=50$) it starts at $t\approx3.45$" | `py/analysis.py` → onset 3.4526 | yes |
| Behavior | "the computed values fall to $y_{48}\approx-0.0018$ at $t=4.8$ (below zero), then turn upward" | n=50: strictly decreasing from peak to t = 4.8 (first increases after t = 4.8 and 4.9), y_48 = −0.0018309 | yes |
| Behavior | "end at $y(5)\approx0.138$, about 17 times the exact value" | y_50 = 0.1380900; ratio 17.01 (`py/textchecks.py`) | yes |
| Alt text | "step h = 0.025 (n = 200)", "builds four steps per frame" | as intro | yes |
| Alt text | "lies on the dashed RK4 reference throughout" | max deviation 3.1e-7 (≪ one pixel); frames 001-051 viewed: magenta covers the dashed curve | yes |
| Alt text | "rising to about 1.45 near t = 0.9" | `py/textchecks.py` exact peak t = 0.8836, y = 1.449767; computed peak 1.449725 at t = 0.875 | yes |
| Alt text | "falling to y ≈ 0.0081 at t = 5" | y_200 = 0.0081199204; strictly decreasing after peak | yes |
| GIF title | "ABM4, h = 0.025: y' = 1 - t*cbrt(y), y(0)=1" | h = 0.025; frame_051 shows the title in full | yes |
| Script comment | "h = 0.025 keeps h*\|df/dy\| below ABM4 PECE's limit 1.285 up to t = 5" | 0.025 × 41.2554 = 1.0314 < 1.2848 (`py/textchecks.py` → True) | yes |
| Script comment | "each frame adds `stride` ABM4 steps (0.1 in t)" | 4 × 0.025 = 0.1 | yes |
| Script comment | "end point (5, 0.0081)" | y_200 = 0.0081199 | yes |

## Scripts and GIFs
- Script changed: `adamsbashforthmoultonaa.jl` (n_steps, stride, frame loop, title, limits). GIF regenerated: `adamsbashforthmoultonaa.gif` (51 frames, fps 2).
- Frames extracted to `$FIX/new_gif/` (51 frames) and viewed at full size: frame 001 (start marker at (0, 1) fully visible, legend y_0, no magenta yet), frame 036 (t = 3.5, marker y_140 on the reference), frame 051 (marker y_200 at (5, 0.0081) fully inside the frame and above the bottom border; title fits; legend "Reference (RK4 h=1e-4)", "ABM4", "y_200"); contact sheet for frames 1, 6, 11, …, 51 shows the trace building at t = 0.5 steps and staying on the dashed reference throughout. The legend (top right) does not cover the curve.
- `git status --short -- pages/numerical-methods/adams-bashforth-moulton-method` → `M adamsbashforthmoultonaa.gif`, `M adamsbashforthmoultonaa.jl`, `M index.qmd` (expected set).

## Legacy archive
Consulted.
- `n2003/AdamsBashforthMod.html`, Example 11 (`abmmethod/AdamsBashforthMod/Links/AdamsBashforthMod_lnk_12.html`): Mathews solves y' = 1 − t·y^{1/3}, y(0) = 1 on [0, 5] (with `Sign[y] Abs[y]^(1/3)`, the real cube root, as Julia's `cbrt`) three times: n = 50, 100, 150. His n = 50 table (gr_170) lists y(4.8) = −0.0018309, y(4.9) = 0.030813, y(5) = 0.13809, and his n = 50 graph (gr_167) shows the upward hook at t = 5; the n = 100 and n = 150 runs end at 0.00811992. These reproduce with plain ABM4-PECE (`py/archive_repro.py`). The module text does not comment on the n = 50 hook.
- Animation `a2001/Animations/OrdinaryDE/Adams1/Adamsaa.gif` (39 frames, 22 distinct): sweeps m = 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150 subintervals, printing y(5). All 21 printed y(5) values reproduce to the printed digits with ABM4-PECE + RK4 starter (`py/archive_repro.py`; e.g. m = 20 → −0.3628404, m = 60 → 0.1036708, m = 80 → 0.008109, m = 100 → 0.0081199). Frames up to m = 60 show a visible excursion in the tail (zig-zags for small m, a final upward hook at m = 60); m ≥ 70 look smooth at that scale.
- Difference from the fixed page: the page's old setting copied Mathews' first run (n = 50), which is unstable after t ≈ 3.45. The page follows the mathematics (D2 default): n = 200 is stable to t = 5 by the linear criterion, whereas Mathews' n = 100 and n = 150 (both visually fine, errors 4.5e-9 and 1.4e-10 at t = 5) are above h* = 0.0311 (onsets t = 4.283 and 4.890), so they were not chosen. The page states in one sentence what happens at h = 0.1.

## Notes
- The axis-limit change (xlims/ylims margins) is not from a finding on this page. Without it the new end point (5, 0.0081) would sit on the bottom frame line and against the right border; the same issue was raised as a Minor item on the Runge-Kutta page in round 2, and the same small change is used here.
- "Stable to t = 5" is the linear-stability criterion with J frozen along the exact solution, as in the pattern; n = 100 and 150 (above h*) still look fine because the amplification acts only over the last steps.
- Pre-existing convention gaps: none noted beyond the "(Planned)" stubs, which were not touched.
- Nothing outside this page folder was touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fixer took option (b), changing `n_steps` from 50 to 200 (h = 0.025) and drawing 4 steps per frame, and added an accurate explanation of what happens at the module's h = 0.1. The false sentence ("tracks the reference closely over the full interval ... stable descent") is gone.
- Independent ABM4 (Python, same AB4 predictor / AM4 corrector in PECE mode, RK4 start) checked against an mpmath `odefun` Taylor reference (tol 1e-25, y(5) = 0.0081199204648679610) and DOP853 (rtol 1e-13):
  - n = 200: max |error| = 3.087e-7 at t = 3.300, error at t = 5 is −2.58e-11, min y = 0.00812 > 0. The Julia script prints `Final y(5) = 0.008119920439074675`, which differs from the exact value by −2.58e-11, the same number.
  - n = 400: max error 1.34e-8, a ratio of 23 from n = 200 (n = 100 → 200 gives 27.6). It converges and stays positive, so h = 0.025 is inside the stable, convergent regime.
  - n = 50: y_48 = −0.0018309 at t = 4.8, y_50 = 0.13808998 (the module's own printout, AdamsBashforthMod_gr_172.gif, gives 0.13809). That is 17.0 times the exact value.
- Stability: I computed the PECE ABM4 characteristic polynomial myself. Its real stability interval ends at z ≈ −1.2848. Along the exact solution, ∂f/∂y = −t/(3y^{2/3}) decreases monotonically after t = 1 and reaches −41.255 at t = 5, its minimum on [0, 5]. So h·|J| at t = 5 is 1.031 for h = 0.025 (inside the interval), and the critical h is 1.285/41.255 = 0.031147. At h = 0.1 the crossing is at t = 3.4528.
- The GIF matches. All 51 frames lie on the dashed reference, and the last frame ends at about 0.008 with no upturn (frames 001, 026 and 051 checked at full size, plus the contact sheet).
- The Description's "giving high accuracy" now sits next to a run with a maximum error of 3.1e-7, so it no longer needs a comment.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Animations para | "computed with n=200 steps (h=0.025)" | script `n_steps = 200`, tf−t0 = 5, so h = 0.025 | true |
| index.qmd Animations para | "instead of the n=50 steps (h=0.1) of the module's first run" | legacy lnk_12: runs with n = 50, 100, 150 ("Using n = 51/101/151 points"); the first is n = 50 | true |
| index.qmd Animations para | "Each frame adds four steps (0.1 in t)" | `1:stride:length(ts)` with stride 4, 4·0.025 = 0.1; indices 1, 5, …, 201 give 51 frames and end exactly at y_200 | true |
| index.qmd Animations para | "the connecting curve passes through every computed point" | `plot!(ts[1:frame], ys[1:frame])` uses every point | true |
| index.qmd Case 1 heading | "n=200 steps (h=0.025)" | as above | true |
| Behavior | "within 3.1×10⁻⁷ of the exact solution at all 201 step points" | max error 3.0867e-7 | true |
| Behavior | "largest error is near t=3.3" | argmax at t = 3.300 | true |
| Behavior | "error at t=5 is 2.6×10⁻¹¹" | −2.58e-11 (Python and Julia agree) | true (magnitude) |
| Behavior | "exact y(5)=0.0081199" | 0.00811992046487 | true |
| Behavior | "steps longer than about h=0.0311 ... exceeds ... before t=5" | h_crit = 1.285/41.255 = 0.031147; h = 0.032 crosses at t = 4.956, h = 0.035 at t = 4.812 | true |
| Behavior | "stability limit 1.285" | PECE ABM4 real interval [−1.2848, 0] | true |
| Behavior | "∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t=5" | derivative of 1 − t·y^{1/3} is correct; value −41.255 | true |
| Behavior | "errors are amplified instead of damped" | spectral radius > 1 outside the interval | true |
| Behavior | "just above h=0.0311 this affects only the last steps" | crossing at t ≈ 4.96 for h = 0.032 | true |
| Behavior | "at h=0.1 (n=50) it starts at t≈3.45" | crossing at t = 3.4528 | true |
| Behavior | "y_48 ≈ −0.0018 at t=4.8 (below zero)" | −0.0018309 | true |
| Behavior | "then turn upward and end at y(5) ≈ 0.138, about 17 times the exact value" | y_49 = 0.0308, y_50 = 0.13809; 0.13809/0.0081199 = 17.0 | true |
| Alt text | "h = 0.025 (n = 200)", "builds four steps per frame", "lies on the dashed RK4 reference throughout" | script and frames | true |
| Alt text | "rising to about 1.45 near t = 0.9" | max y = 1.44977 at t = 0.8836 | true |
| Alt text | "falling to y ≈ 0.0081 at t = 5" | 0.0081199 | true |
| .jl comment | "h = 0.025 keeps h*\|df/dy\| below ABM4 PECE's limit 1.285 up to t = 5" | 0.025·41.255 = 1.031 < 1.285 | true |
| .jl comment | "each frame adds `stride` ABM4 steps (0.1 in t)" | as above | true |
| .jl | xlims (−0.1, 5.1), ylims (−0.05, 1.55); comment about the end point not being clipped | the end marker at (5, 0.0081) is fully visible in frame 051 | true |
| .jl title | "ABM4, h = 0.025: y' = 1 - t*cbrt(y), y(0)=1" | matches the run; readable at full size | true |
| .jl legend | "y_$(frame - 1)" | gives y_0 … y_200, which matches the step index | true |

### New problems
None. This rests on:
- every number in the ledger reproduced independently (mpmath and DOP853 references, my own ABM4, my own stability polynomial);
- the full-size frames 001, 026 and 051 and the contact sheet: the title, legend and labels are legible and correct, and the marker index matches the plotted point;
- the ABM routine itself is unchanged.

One small wording point, not a problem: the Behavior paragraph says "exact solution" while the page says no closed-form solution is used. The values are those of the true solution, computed to high precision, so the statement holds.

### Reproducibility and conventions
- I ran a scratch copy of `adamsbashforthmoultonaa.jl` with the global Julia environment. The output GIF is byte-identical to the committed `adamsbashforthmoultonaa.gif` (cmp), which has 51 frames.
- The page order is still Description, then Animations. The page keeps a "[Julia source]" link and one embed for its single case, with descriptive alt text, and has no code blocks.
- The diff touches only the 3 files in the page folder. Other pages on the branch show working-tree modifications from other fixes; none of them is part of this page's diff.

**Final status:** committed
