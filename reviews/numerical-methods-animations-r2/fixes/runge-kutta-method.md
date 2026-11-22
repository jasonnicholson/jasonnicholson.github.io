# Fix record: runge-kutta-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/runge-kutta-method/fix/` (below: `$FIX`).

- `$FIX/check.py`: independent Python RK4 sweep, DOP853 reference (rtol 1e-13), RK4 stability limit, onset times, comparison with every legacy value.
- `$FIX/check2.py`: error at the last node before onset against the error at t = 5, for each m.
- `$FIX/check3.py`: first upturn after the peak for each m.
- `$FIX/check4.py`: the reference decays after its peak, and RK4 with 50 000 steps agrees with DOP853.
- `$FIX/check5.py`: the size of the upturn (post-peak minimum to y(5)) for m = 44–56, after the coordinator's check flagged m = 56 as not visibly turning upward.
- `$FIX/instr.jl`: the new script's compute block, with plotting removed, printing what each frame shows.
- `$FIX/labels.jl`, `$FIX/gifdelays.py`: tools to read the legacy GIF (label strips and frame delays).
- `$FIX/legacy/`: legacy GIF frames. `$FIX/new/`: frames of the new GIF. `$FIX/orig/`: the pre-fix script and GIF.

## Findings

### F1 — Minor (Fidelity) — fixed

- **Reproduced:**
  - `julia $S/tools/giftools.jl .../a2001/Animations/OrdinaryDE/RungeKutta1/RungeKuttaaa.gif $FIX/legacy` gave 36 frames.
  - Every legacy frame is a complete RK4 run on [0, 5] for some m, labelled with m and y(5).
  - The committed page instead traced a single n = 80 run, four steps per frame, so it showed no step-size dependence. The finding holds.
  - Correction to the finding: the reviewer read m only from the contact sheet, which samples every third frame, and listed 12 values. Reading all the distinct frames gives **21** values of m (see Notes, "R2-B pattern").
  - `python3 $FIX/check.py` reproduces all 21 printed legacy y(5) values to all of their printed digits.
- **Change (decision R2-B):** `rungekuttaaa.jl` was rewritten as Mathews' step-refinement sweep. Each frame is a full RK4 run with m subintervals, m = 12…150 (21 frames), drawn over a fine-step reference solution. Each frame carries m, h = 5/m, y(5), the error and the reference y(5). A shaded span marks where h·|∂f/∂y| > 2.785. The `index.qmd` changes:
  - the intro's first two sentences;
  - the Case 1 heading ("n=80 steps (h=0.0625)" → "RK4 step-refinement sweep … m = 12 to 150 subintervals");
  - the Behavior paragraph, rewritten from the new runs, with the corrected D2 stability sentence;
  - the alt text.
  - follow-up after the independent check: the upturn range was changed from "12 through 56" to "visibly … 12 through 52", with m = 56's last-step rise of 8.1×10⁻⁴ (≈ 0.17 px) stated separately, in both the Behavior paragraph and the alt text.
- **Check:**
  - The instrumented copy (`julia $FIX/instr.jl`) prints y(5), error and onset for each m. They agree with the independent Python (`check.py`) to every printed digit. For example, m = 12 gives 0.5883470625 and onset 3.1033 (Julia, 1e-4 grid) against 3.1032 (Python brentq). m = 150 gives 0.0081200962.
  - Frames 1, 5, 14, 16 and 21 were viewed at full size, and the contact sheet was checked (details under Scripts and GIFs).

## Ledger of changed text

S = scratch folder above. "py" = `/usr/bin/python3 $FIX/check*.py`; "jl" = `julia $FIX/instr.jl`.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Intro | "repeats Mathews' step-refinement sweep" | Legacy GIF frames: each is a complete RK4 run for one m (`$FIX/legacy/frame_004.png`, `labels_a.png`, `labels_b.png`); py reproduces all 21 legacy y(5) (match7 True for all) | yes |
| Intro | "complete RK4 run with m subintervals (h = 5/m)" | script `rk4(m)`: h = (T−t0)/m, T−t0 = 5; classical RK4, weights (1,2,2,1)/6 | yes |
| Intro | "the 21 values of Mathews' animation, m = 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150" | Legacy frame md5s: 22 distinct frames (1 blank + 21); label strips of frames 4,6,…,26,28–36 read these m in this order; `ms` in script has 21 entries | yes |
| Intro | "drawn over a fine-step reference solution" | Reference = RK4 with 50 000 steps; py check4: max diff vs DOP853 9.47e-13 | yes |
| Intro | "labelled with the computed y(5) and its error" | frames viewed: labels "y(5) = …", "error = …" in every frame | yes |
| Heading | "RK4 step-refinement sweep, y' = 1 − t∛y, y(0)=1, m = 12 to 150 subintervals" | script `f`, `y0`, `ms[1]=12`, `ms[end]=150` | yes |
| Behavior | "rises from y(0)=1 to about 1.4498 near t=0.88" | py: exact max 1.449767 at t = 0.88356; jl ref range max 1.4497667 | yes |
| Behavior | "then decays toward the nullcline y = 1/t³ (where y'=0)" | 1 − t·y^{1/3} = 0 ⇔ y = t⁻³; py check4: y' < 0 on [0.884, 5] → True; round-2 review claim 8 (attraction) | yes |
| Behavior | "reaches y(5) = 0.0081199" | py DOP853 0.008119920465; jl reference 0.008119920464867961 | yes |
| Behavior | "For m = 12 through 52 the computed curve visibly turns upward before t = 5 instead of following the decay" | py check3: m = 12…56 each have an increase after the peak (first at t = 2.9167 for m = 12 … 4.9107→5 for m = 56); m = 60…150: none (monotone decreasing after peak). Visibility: py check5 rise from post-peak minimum to y(5): m=44 4.89e-2, m=48 4.33e-2, m=52 2.80e-2, m=56 8.05e-4; plot box in frame_021.png spans rows 42–432 = 390 px for 1.85 y-units → 211 px/unit, so m=52 rises ≈ 5.9 px (visible in frames/sheet), m=56 ≈ 0.17 px (invisible, frame 14 viewed) | yes |
| Behavior | "y(5) ≈ 0.588 for m=12, 0.289 for m=20 and 0.0377 for m=52" | jl/py: 0.5883470625, 0.2891074072, 0.0376958174 | yes |
| Behavior | "at m = 56 it still turns upward on the last step, but only by 8.1×10⁻⁴, too little to see, and ends at y(5) ≈ 0.0099" | py check3: only increase is t = 4.9107→5.0000 (last step); check5: min 0.009052 → y(5) 0.0098571, rise 8.05e-4 ≈ 0.17 px | yes |
| Behavior | "The error in y(5) falls at every refinement in the sweep" | py: \|err\| strictly decreasing across the 21 m → True | yes |
| Behavior | "3.4×10⁻⁴ at m=60, 2.8×10⁻⁵ at m=70, 6.8×10⁻⁶ at m=80, 1.8×10⁻⁷ at m=150" | jl/py: +3.431e-04, +2.765e-05, +6.805e-06, +1.757e-07 | yes |
| Behavior | "where y(5) ≈ 0.0081201" (m = 150) | jl/py 0.0081200962 | yes |
| Behavior | "∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5" | d/dy(1 − t y^{1/3}); py J(5) = −41.2554; \|J\| monotone increasing on (0,5] → True | yes |
| Behavior | "steps longer than about h = 0.0675 (m ≤ 74; here m = 12 to 70)" | py: h* = 2.785294/41.2554 = 0.067513, 5/h* = 74.06; m = 74 onset 4.9987 < 5; m = 75 stable to 5; sweep members with h > h*: 12…70 (jl onset ≠ none exactly for m ≤ 70) | yes |
| Behavior | "RK4's stability limit 2.785" | py brentq \|R(z)\| = 1 on [−3,−2]: z = −2.7852936; jl bisection zlim = 2.785293563405282 | yes |
| Behavior | "from then on errors are amplified instead of damped" | py check2: for every sweep m from 12 to 70 and for m = 74, \|e(5)\| > \|e\| at the last node before onset (ratios 1.3 … 976), and \|e\| is nondecreasing after onset for m = 12 and for 32–74; for m = 75, 80, 100 and 150, \|e(5)\| < max\|e\| (damped). R(−2.7853) = 1.00001, so \|R(hJ)\| > 1 past the limit | yes |
| Behavior | "(the shaded region in those frames)" | script vspan from onset to T only when onset ≠ nothing; frames 1, 5, 14, 16 shaded, 21 not | yes |
| Behavior | "Just above h = 0.0675 this affects only the last steps (m = 70: from t ≈ 4.91)" | jl onset 4.9083, py 4.9082; m = 70 h = 0.0714 → last ≈ 1.3 steps; \|e(5)\| 2.8e-5 | yes |
| Behavior | "at m = 12 it starts at t ≈ 3.10" | py 3.1032, jl 3.1033 | yes |
| Behavior | "For m = 80 to 150, h·\|∂f/∂y\| stays below 2.785 up to t = 5" | py h\|J(5)\|: m=80 2.578, 90 2.292, 100 2.063, 120 1.719, 150 1.375, and \|J\| increasing in t | yes |
| Alt text | "each frame is a complete RK4 run with m subintervals, m = 12 to 150" | as intro | yes |
| Alt text | "gray reference curve that peaks near 1.45 at t ≈ 0.88 and decays to 0.0081 at t = 5" | 1.449767 at 0.88356; y(5) 0.0081199 | yes |
| Alt text | "For m = 12 to 52 the run visibly turns upward in the tail, ending at y(5) = 0.588 for m = 12 (at m = 56 the upturn is too small to see)" | check3, check5 (pixel sizes as above); 0.5883471 | yes |
| Alt text | "for m = 12 to 70 a shaded region marks where h·\|∂f/∂y\| exceeds 2.785" | jl onset ≠ none exactly for m ≤ 70 | yes |
| Alt text | "settle onto the reference as m grows, with y(5) = 0.0081201 at m = 150" | error decreasing across sweep; 0.0081200962 | yes |
| GIF title | "RK4 for y' = 1 - t·y^(1/3), y(0) = 1 / m = <m> subintervals, h = 5/<m>" | `f`, `y0`, h = 5/m exactly | yes |
| GIF labels | "y(5) = %.7f", "error = %+.1e" (y(5) − reference y(5)), "reference y(5) = 0.0081199" | jl instr values; %.7f of the smallest value (0.0081201) still shows 5 significant figures, so nothing rounds to a false number | yes |
| GIF labels | "h·\|∂f/∂y\| > 2.785 from t ≈ <onset %.2f>" / "h·\|∂f/∂y\| < 2.785 up to t = 5" | onsets jl = py to 1e-4 (table in check.py output); stable case only when no onset on [0,5] | yes |
| GIF legend | "h·\|∂f/∂y\| > 2.785", "reference solution", "RK4, m = <m>" | as above | yes |
| Unchanged, still true | "RK4 computes four slope estimates … O(h⁵) local / O(h⁴) global for smooth f" | not changed; round-2 claim ledger rows 4–5 | yes (unchanged) |

## Scripts and GIFs

- **Script changed:** `pages/numerical-methods/runge-kutta-method/rungekuttaaa.jl`, rewritten as the sweep. Same file name, same `@__DIR__` output, same 640×480 GR style. It adds `using Printf` (standard library) and no packages.
- **GIF regenerated:** `rungekuttaaa.gif`, 21 frames at fps = 1 (100 cs each; read from the GIF's graphic-control blocks with `$FIX/gifdelays.py`).
- **Frames viewed** (`julia $S/tools/giftools.jl rungekuttaaa.gif $FIX/new`):
  - Frame 1 (m = 12): the polyline goes through the 13 nodes. It leaves the gray reference after t ≈ 2.9 and climbs to the red end point at y = 0.588. The shading starts at t ≈ 3.10 and ends at t = 5. The labels read 0.5883471, +5.8e-01, 0.0081199, and "from t ≈ 3.10".
  - Frame 5 (m = 20): the run zigzags up in the tail to 0.2891074. The shading starts at 3.34.
  - Frame 14 (m = 56): the curve lies on the reference and the error is invisible at this scale. The label gives +1.7e-03, and the shading starts at 4.56.
  - Frame 16 (m = 70): a thin shaded strip from 4.91, error +2.8e-05.
  - Frame 21 (m = 150): no shading, "< 2.785 up to t = 5", y(5) = 0.0081201, error +1.8e-07.
  - The contact sheet shows the progression from m = 12 to 150.
  - Titles, legend and labels are legible and unclipped, and the legend does not cover the curve.
- **Axis limits:** xlims (−0.1, 5.1), ylims (−0.05, 1.8), kept from the old script. Every computed value of every run lies inside: jl gives a run minimum of 0.0081 and a maximum of 1.44975. Nothing is clamped or masked.
- **git status** after regeneration (`git status --short -- pages/numerical-methods/runge-kutta-method`): `M index.qmd`, `M rungekuttaaa.gif`, `M rungekuttaaa.jl`. Nothing else changed.

## Legacy archive

- **Consulted:**
  - `n2003/RungeKuttaMod.html`, read as text: the theorem, the algorithm, Examples 1–2, and the animation link. The equations are images, so the text gives no parameters.
  - `a2001/Animations/OrdinaryDE/RungeKutta1/RungeKutta.html` and `RungeKuttaaa.html`, which say "36 frames".
  - `RungeKuttaaa.gif` (640×480, 36 frames, 1 s each).
- **What the legacy animation shows:**
  - The title is "Runge-Kutta Method, RK4 / Numerically Approximate the solution to the D.E. y' = 1 − t∛y".
  - Each frame is a full RK4 run on [0, 5] with "Using m = … subintervals" and "y(5) = …" printed on it.
  - There is no reference curve, and a red dot marks (0, 1).
  - The coarse runs turn upward in the tail.
- **Differences from Mathews, and why:**
  - The new GIF adds the reference curve (R2-B: keep the reference), the error label, and the stability shading, which illustrates the stability sentence on the page.
  - It drops Mathews' blank lead-in and his frame holds, so each m gets 1 s. It keeps his ODE, interval, initial value and full m sequence.
  - All 21 of Mathews' printed y(5) values are correct (reproduced), so nothing on the page departs from his numbers.

## Notes

### R2-B pattern for other pages (Euler, Taylor, ABM)

**1. Reading Mathews' m sequence and y(5) values from the legacy GIF.**
- Extract the frames: `julia $S/tools/giftools.jl /home/jason/Desktop/math-fullerton/baseline/mathews/a2001/Animations/OrdinaryDE/RungeKutta1/RungeKuttaaa.gif $FIX/legacy`.
- **Do not read m from `sheet.png`.** It samples every k-th frame (k = 3 here), and that is why the round-2 reviewer saw only 12 of the 21 values.
- Find the distinct frames from `frames.md5`: `awk -F, '!/^#/{print $NF}' frames.md5 | nl | awk '{print $1,$2}' | uniq -f1 -c`. Here that gives frames 1–3 blank, then frames 4, 6, …, 26 (each held 2 frames), then 28–36 (one frame each).
- Crop the label band (y 335–445 of 640×480) from each distinct frame and stack the strips into one image with ffmpeg `vstack` (script `$FIX/labels.jl`: `julia labels.jl <framedir> 4,6,...,24 out.png`). Two images of about 11 strips each are legible at full size.
- Delays come from the GIF's graphic-control extensions (`$FIX/gifdelays.py`); here every frame lasts 100 cs.
- Values read for RK4 (y' = 1 − t∛y, y(0) = 1, [0, 5]):

  | m | 12 | 14 | 16 | 18 | 20 | 24 | 28 | 32 | 36 | 40 | 44 |
  |---|---|---|---|---|---|---|---|---|---|---|---|
  | y(5) | 0.5883471 | 0.4685529 | 0.3876236 | 0.3316264 | 0.2891074 | 0.2274383 | 0.1108585 | 0.1082442 | 0.0834665 | 0.0698482 | 0.0604713 |

  | m | 48 | 52 | 56 | 60 | 70 | 80 | 90 | 100 | 120 | 150 |
  |---|---|---|---|---|---|---|---|---|---|---|
  | y(5) | 0.0538504 | 0.0376958 | 0.0098571 | 0.008463 (printed without its trailing 0) | 0.0081476 | 0.0081267 | 0.0081227 | 0.0081213 | 0.0081204 | 0.0081201 |

**2. Reproducing the values.**
- `$FIX/check.py` is an independent Python RK4 with m equal steps of h = 5/m, using `np.cbrt`. It compares round(y(5), 7) with each printed value, and all 21 match.
- The Julia script gives the same values to 10 digits (`$FIX/instr.jl`).
- The exact y(5) = 0.0081199205 comes from DOP853 (rtol 1e-13). The script's reference, RK4 with 50 000 steps, agrees to 9.5e-13.
- The per-m stability onset t_on solves h·|J(t)| = 2.7852936 along the reference, with J = ∂f/∂y = −t/(3y^{2/3}).
- Other pages use their own method's real-axis limit: |R(z)| = 1 for that method's stability polynomial, or the PECE root locus for ABM. Compute it; do not copy the D2 table.

**3. How each frame is drawn** (`rungekuttaaa.jl`):
- **One frame per m**, a complete run.
- **Title:** two lines, `"RK4 for y' = 1 - t·y^(1/3), y(0) = 1\nm = $m subintervals, h = 5/$m"` (titlefontsize 11). Writing h = 5/m keeps it exact, with no rounding.
- **Plotted, in order:**
  - when an onset exists, `vspan!([ton, T])` in light red (alpha 0.10), labelled "h·|∂f/∂y| > 2.785", ending at T rather than at the x-limit;
  - the reference curve in gray70, lw 4, labelled "reference solution";
  - the run as a magenta polyline with small node markers (ms 2.5), labelled "RK4, m = $m";
  - a red dot at (5, y_m).
- **Text block** at x = 2.35, left-aligned, y = 1.22 / 1.10 / 0.98 / 0.87:
  - `y(5) = %.7f` (Mathews' 7 decimals);
  - `error = %+.1e`, which is y(5) − reference y(5);
  - `reference y(5) = %.7f`, in gray;
  - either `h·|∂f/∂y| > 2.785 from t ≈ %.2f` or `h·|∂f/∂y| < 2.785 up to t = 5`.
- **Axes:** xlims (−0.1, 5.1), ylims (−0.05, 1.8), legend at :topright, framestyle :box, 640×480.
- **Blow-up values outside the window.**
  - None occur for RK4: every value of every run lies in [0.0081, 1.4498], which is inside the window.
  - Pages whose coarse runs leave the window (likely Euler and ABM; check yours):
    - keep the window fixed for all frames so the frames can be compared;
    - let Plots clip the polyline at the frame edge;
    - mark each node outside the window with a marker on the border (for example a `:utriangle` at ylims[2]);
    - put the **true** y(5), and the true max/min if needed, in the text labels.
  - Never draw a clamped value as a node, and never label a clamped value.
  - If y goes negative, `cbrt` stays real in both Julia and numpy, but say so if it happens. It does not happen for RK4: the run minimum is 0.0081.

**4. Behavior paragraph wording used** (exact):
> The reference solution rises from $y(0)=1$ to about $1.4498$ near $t=0.88$, then decays toward the nullcline $y=1/t^3$ (where $y'=0$) and reaches $y(5)=0.0081199$. For $m=12$ through $52$ the computed curve visibly turns upward before $t=5$ instead of following the decay, ending at $y(5)\approx0.588$ for $m=12$, $0.289$ for $m=20$ and $0.0377$ for $m=52$; at $m=56$ it still turns upward on the last step, but only by $8.1\times10^{-4}$, too little to see, and ends at $y(5)\approx0.0099$. The error in $y(5)$ falls at every refinement in the sweep: $3.4\times10^{-4}$ at $m=60$, $2.8\times10^{-5}$ at $m=70$, $6.8\times10^{-6}$ at $m=80$ and $1.8\times10^{-7}$ at $m=150$, where $y(5)\approx0.0081201$.

**Stability sentence** (exact; the corrected D2 form):
> The cause is stability: $\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$, so for steps longer than about $h=0.0675$ ($m\le74$; here $m=12$ to $70$), $h\,|\partial f/\partial y|$ exceeds RK4's stability limit $2.785$ before $t=5$, and from then on errors are amplified instead of damped (the shaded region in those frames). Just above $h=0.0675$ this affects only the last steps ($m=70$: from $t\approx4.91$), but at $m=12$ it starts at $t\approx3.10$. For $m=80$ to $150$, $h\,|\partial f/\partial y|$ stays below $2.785$ up to $t=5$.

**Quantifier traps checked on RK4:**
- "Unstable" (h > h*) is not the same set as "visibly turns upward". m = 60 and 70 have h > h* but are monotone after the peak, so the text names the two ranges separately: 12–52 visibly turn upward, and 12–70 exceed the limit. A computed upturn is not necessarily a visible one. m = 56 turns upward by only 8.05e-4, about 0.17 px at this window's 211 px per y-unit, so the text says "visibly" for 12–52 and gives m = 56's tiny upturn with its size. On your page, convert each rise to pixels (plot-box rows ÷ y-range) before calling it visible.
- "Falls at every refinement" was checked over all 21 m. Check it on your page, because Euler or ABM error sequences may not be monotone.
- "Amplified instead of damped" was checked per m: |e(5)| is greater than |e| at the last node before onset for every sweep m from 12 to 70 and for m = 74, and |e(5)| < max|e| for m = 75, 80, 100 and 150.

**5. Frames and pacing:** 21 frames, one per m, at fps = 1 (1 s per frame). Mathews used 1 s per GIF frame with a 3 s blank lead-in and 2 s holds on m = 12…52. The lead-in and holds were dropped for simplicity. The intro sentence of the page states how the frames are built (the full m list, reference curve, y(5) and error labels).

### Other notes
- The page still has no `## Description` section, which the conventions require. No finding names it, so it is not added here (out of scope).
- The intro's plural sentence "Julia source scripts that generated these animations are linked under each case" was left unchanged; it is wording only and not a finding.
- The page was not rendered with Quarto. Rendering writes outside the page folder, and the director renders the full section later.

### Director note

The checker noted (pre-existing, not a finding) that the page has no `## Description` section; left for Jason.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved

- Evidence, legacy sweep. I extracted the legacy `a2001/Animations/OrdinaryDE/RungeKutta1/RungeKuttaaa.gif` with giftools: 36 frames, 22 distinct by decoded-frame md5. The first is a blank title frame and the other 21 are m frames, each held two frames for m ≤ 24 and one after that. I read every label strip at full resolution (`check/legacy_labels.png`). Mathews' sequence is m = 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150. That is 21 values, and it is exactly the script's `ms` and the page's list. The round-2 finding saw only 12 of them on the contact sheet.
- Evidence, my own RK4. I wrote an independent RK4 in Python (`check/rk.py`) with the same ODE, h = 5/m and the same 21 m. Rounded to 7 decimals it reproduces all 21 printed legacy y(5) values exactly:
  - 0.5883471, 0.4685529, 0.3876236, 0.3316264, 0.2891074, 0.2274383, 0.1108585;
  - 0.1082442, 0.0834665, 0.0698482, 0.0604713, 0.0538504, 0.0376958, 0.0098571;
  - 0.008463, 0.0081476, 0.0081267, 0.0081227, 0.0081213, 0.0081204, 0.0081201.

  The new GIF prints the same y(5) on each frame. I checked the frames for m = 12, 44, 56, 70 and 150 at full size.
- Evidence, the fix itself. Each frame of the new GIF is now a complete RK4 run with the coarse-m runs climbing in the tail, as R2-B requires. Each frame is labelled with m and y(5), and the reference curve is kept as a gray backdrop. The page text describes the sweep.

### Changed-text ledger

High-precision reference: mpmath `odefun` (30 digits) gives y(5) = 0.00811992046486796, and DOP853 at rtol 1e-13 agrees to 1e-17.

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Intro | "repeats Mathews' step-refinement sweep … each frame a complete RK4 run with m subintervals (h=5/m)" | Matches the script (`rk4(m)` per frame) and the legacy GIF | OK |
| Intro | "the 21 values of Mathews' animation, m = 12 … 150" | All 21 legacy label strips read; the list is identical | OK |
| Intro | "drawn over a fine-step reference solution and labelled with the computed y(5) and its error" | Reference is RK4 with 50 000 steps; its y(5) matches mpmath to display precision. The frames show y(5), error and reference y(5) | OK |
| Intro (unchanged sentence) | O(h^5) local, O(h^4) global error | Step halving from m = 80 to 640: errors 6.8e-6, 1.30e-7, 5.97e-9, 3.20e-10. The ratios 52 → 22 → 18.6 approach 16 | OK |
| Case heading | "RK4 step-refinement sweep … m = 12 to 150 subintervals" | Matches `ms` | OK |
| Behavior | peak "about 1.4498 near t = 0.88" | Root of y' = 0 on the reference: t = 0.88356, y = 1.449767 | OK |
| Behavior | "decays toward the nullcline y = 1/t^3" and "reaches y(5) = 0.0081199" | 0.00811992 | OK |
| Behavior | "For m = 12 through 56 the computed curve turns upward before t = 5" | Each run of m = 12 to 56 has an increasing step for t > 2. The first increase is at t = 3.33 (m = 12) and at the last step t = 5.0 (m = 56). m = 60 and above have no tail increase | OK (see new problem 1 on visibility) |
| Behavior | y(5) ≈ 0.588 (m = 12), 0.289 (m = 20), 0.0099 (m = 56) | 0.5883471, 0.2891074, 0.0098571 | OK |
| Behavior | "error in y(5) falls at every refinement in the sweep" | \|error\| decreases strictly across all 21 m (e.g. m = 28 → 32: 0.1026 → 0.1000) | OK |
| Behavior | 3.4e-4 (m = 60), 2.8e-5 (m = 70), 6.8e-6 (m = 80), 1.8e-7 (m = 150) | 3.43e-4, 2.76e-5, 6.80e-6, 1.76e-7 | OK |
| Behavior | y(5) ≈ 0.0081201 at m = 150 | 0.0081201 | OK |
| Behavior | ∂f/∂y = −t/(3y^{2/3}) "reaches −41.3 at t = 5" | −41.2554 on the exact y(5). The formula is the correct derivative of 1 − t·y^{1/3} | OK |
| Behavior | RK4 stability limit 2.785 | Root of \|R(z)\| = 1 on (−3, −2): z = −2.785294 | OK |
| Behavior | threshold "about h = 0.0675 (m ≤ 74; here m = 12 to 70)" | h* = 2.785294/41.2554 = 0.067513, so m* = 74.06. m = 74 is above the threshold and m = 75 below it. In the sweep m ≤ 70 cross and m ≥ 80 do not | OK |
| Behavior | "exceeds … before t = 5" | \|∂f/∂y\| along the solution is strictly increasing for t > 1, so the crossing is a single onset time ≤ 5 | OK |
| Behavior | "errors are amplified instead of damped (the shaded region in those frames)" | \|R(h·∂f/∂y)\| > 1 past the onset (the linearised argument, per the D2 wording). The shading appears in frames m = 12 to 70 only | OK |
| Behavior | onset at m = 70 "from t ≈ 4.91"; at m = 12 "t ≈ 3.10" | 4.9082 and 3.1032 | OK |
| Behavior | "For m = 80 to 150 … stays below 2.785 up to t = 5" | No onset for m ≥ 80 | OK |
| Alt text | gray reference "peaks near 1.45 at t ≈ 0.88 and decays to 0.0081" | As above | OK |
| Alt text | "For m = 12 to 56 the run turns upward in the tail, ending at y(5) = 0.588 for m = 12" | Numerically true; the turn is not visible at m = 56 (new problem 1) | Minor |
| Alt text | shaded region for m = 12 to 70 where h·\|∂f/∂y\| exceeds 2.785 | Seen in the frames for m = 12, 44, 56 and 70; no shading at m = 150 | OK |
| Alt text | "settle onto the reference … y(5) = 0.0081201 at m = 150" | Confirmed in frame 21 | OK |
| GIF title | "RK4 for y' = 1 - t·y^(1/3), y(0) = 1 / m = … subintervals, h = 5/…" | Legible in all frames viewed | OK |
| GIF labels | y(5) to 7 decimals, error as %+.1e, reference y(5) = 0.0081199, onset text | For example m = 44: 0.0604713, +5.2e-02, onset 4.22 (mine: 4.2179). m = 56: +1.7e-03 (mine: 1.74e-3) | OK |
| Script comment | "every computed value of every run lies inside (min 0.0081, max 1.4498)" | Over all runs, max y = 1.4498 (m = 90) and min y = 0.00812. Both are inside ylims (−0.05, 1.8) | OK |
| Script comment | `zlim` "2.7853" | 2.785294 | OK |

### New problems

1. **Minor**, at `index.qmd` Behavior and the alt text ("m = 12 through 56 … turns upward", "For m = 12 to 56 the run turns upward in the tail").
   - At m = 56 the upturn is one final step from 0.00905 to 0.00986. That rise of about 0.0008 is well under a pixel at the GIF's y-scale (−0.05 to 1.8 over about 390 px), and frame 14 shows the curve lying on the reference with no visible rise.
   - The statement is numerically true, but the alt text presents it as something the picture shows. Visibly, the upturn runs from m = 12 to m = 52: at m = 52 the last step rises about 0.028, roughly 6 px.
   - A fix would say "visibly through m = 52", or note that the m = 56 rise is only about 0.0008.

No other new problems. This rests on three things: the full ledger above, the five full-size frames viewed (m = 12, 44, 56, 70, 150), and the legacy match for all 21 m.

### Reproducibility and conventions

- **Reproducibility.** I ran a scratch copy of `rungekuttaaa.jl` (`check/run/`). The output GIF is byte-identical (`cmp`) to the committed `rungekuttaaa.gif`: 21 frames, 640×480, fps 1.
- **Conventions.**
  - There is one source link and one GIF embed for the single case.
  - The alt text is descriptive.
  - There are no code blocks (0 code fences).
  - The page has no `## Description` section before `## Animations`, which the conventions require. This gap is pre-existing: HEAD has the same structure, the diff does not touch those lines, and the bisection page has the same gap. It is not a regression from this fix.
- **Files outside the page folder.** The page diff touches only `pages/numerical-methods/runge-kutta-method/` (index.qmd, rungekuttaaa.jl, rungekuttaaa.gif). The other modified files in the working tree are the bisection, monte-carlo-pi and simpsons pages and the untracked `reviews/numerical-methods-animations-r2/fixes/*.md`. They belong to other pages' fixes or records, not to this one.

### Re-check

The fixer changed only `index.qmd`, in the Behavior paragraph and the alt text. `rungekuttaaa.jl` and `rungekuttaaa.gif` are identical to the versions I checked above (`diff` and `cmp` against my scratch run), so F1 still holds: **resolved**.

I computed the new numbers with `check/rise.py`, which uses my own RK4.

- **"For m = 12 through 52 the computed curve visibly turns upward".** For every m from 12 to 52, the rise from the tail minimum (t > 2) to y(5) is at least 2.795e-2:
  - m = 12: 4.60e-1;
  - m = 44: 4.89e-2;
  - m = 48: 4.33e-2;
  - m = 52: 2.795e-2. This is the minimum at t = 4.808 up to y(5), and most of it is the last step, 2.67e-2.

  OK.
- **"0.0377 for m = 52".** I get 0.0376958. OK.
- **"at m = 56 it still turns upward on the last step, but only by 8.1e-4".** My last step goes from 0.0090518 to 0.0098571, a rise of 8.053e-4. It is the only rise in the tail (tail minimum at t = 4.911). OK.
- **"ends at y(5) ≈ 0.0099".** I get 0.0098571. OK.
- **Pixel scale, which the fixer used to justify the wording.**
  - In frame 21, the plot box runs from pixel row 42 to row 432, i.e. 390 px for the ylims (−0.05, 1.8). That is 210.8 px per unit, and it puts y = 0 at row 421.5, consistent with the tick.
  - m = 52: 2.795e-2 is 5.9 px, which is visible (confirmed in my earlier frame view).
  - m = 56: 8.05e-4 is 0.17 px, which is not visible.

  OK.
- **Alt text** ("m = 12 to 52 the run visibly turns upward … at m = 56 the upturn is too small to see"): consistent with the numbers above. OK.

New problem 1 is **resolved**. The rest of the diff (intro, heading and the other Behavior sentences) is unchanged from the ledger above, and I found no new problems.

**Final status:** committed
