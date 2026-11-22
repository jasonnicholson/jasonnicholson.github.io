# Runge-Kutta Method — animation review (round 3)

Page: `pages/numerical-methods/runge-kutta-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Page match / what the diagram shows — Minor
**Location:** `index.qmd`, Case 1 Behavior: "The cause is stability: $\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$, so for steps longer than about $h=0.0675$ ... $h\,|\partial f/\partial y|$ exceeds RK4's stability limit $2.785$ before $t=5$, and from then on errors are amplified instead of damped (the shaded region in those frames)." Also the frame legend `h·|∂f/∂y| > 2.785` and annotation `h·|∂f/∂y| > 2.785 from t ≈ 3.10` (`rungekuttaaa.jl` lines 53–59, 74, 80–81), and the alt text "a shaded region marks where h·|∂f/∂y| exceeds 2.785".

**What is there now:** The shaded region and its onset time are computed with $\partial f/\partial y$ evaluated **along the reference solution** (`onset(h)` loops over `tref, yref`). Neither the page nor the legend says so. Shaded next to the magenta RK4 run, a reader naturally reads the legend as a statement about the plotted run.

**What is true:** For the coarse runs the plotted run never enters the region it is shaded for. Evaluating $h|\partial f/\partial y|$ at the run's own nodes:

| m | max $h|f_y|$ along the plotted RK4 run | nodes > 2.785 |
|---|---|---|
| 12 | 1.589 | 0 |
| 14 | 1.316 | 0 |
| 16 | 1.932 | 0 |
| 18 | 1.570 | 0 |
| 20 | 1.996 | 0 |
| 24 | 2.418 | 0 |
| 28 | 2.786 | 1 |
| 52 | 3.377 | 5 |

(`/usr/bin/python3 review/zcomp.py`). Along the reference the onset for m=12 is t≈3.10 and $h|f_y|$ reaches 17.2 at t=5 (|R(z)|≈2900); along the run it stays ≤1.6, because the run has already jumped to y≈0.2–0.6 where $|f_y|$ is small. Correspondingly, the m=12 error does not grow by the linear factors |R|=9, 64, 271, 951, 2923 that "errors are amplified" in the shaded region would suggest; it goes 0.168 → 0.252 → 0.442 → 0.466 → 0.580 (`review/err.py`). The linearised explanation is the correct standard one (perturbations of the true solution are amplified once $h|f_y|$ along it exceeds 2.785, and that is what triggers the first excursion), so nothing is false; but the diagram doesn't say which curve the criterion is evaluated on, and for m=12–24 it is not true of the drawn curve.

**Correction:** Say "along the reference solution" in the page sentence ("... $h\,|\partial f/\partial y|$ evaluated along the reference solution exceeds ...") and in the legend label/annotation (e.g. `h·|∂f/∂y| > 2.785 on reference`). Optionally add that once the run has left the reference the linear picture no longer applies.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `rungekuttaaa.jl` | 0 | 12.5 | rungekuttaaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Evidence key: **S** = instrumented script copy `review/inst.jl` output; **I** = independent Python/mpmath (`review/indep.py`, `err.py`, `order.py`, `zcomp.py`); **F** = committed frames; **L** = legacy archive.

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | Repeats Mathews' step-refinement sweep for $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ over $[0,5]$ | Confirmed | Script line 11–14; L: legacy title "y' = 1 − t∛y", red dot at (0,1), axis 0–5 |
| 2 | Each frame is a complete RK4 run with $m$ subintervals ($h=5/m$) | Confirmed | Script `rk4(m)` per frame, `h=(T-t0)/m`; F titles "h = 5/m" |
| 3 | 21 values of Mathews' animation, $m = 12,14,16,18,20,24,28,32,36,40,44,48,52,56,60,70,80,90,100,120,150$ | Confirmed | Script line 15; F has 21 frames; L: 36 GIF frames = blank ×3, 12 runs ×2, 9 runs ×1 = 21 distinct runs, labels read from `legacy_labels.png` give exactly this list |
| 4 | Drawn over a fine-step reference solution | Confirmed | RK4 with 50 000 steps; its y(5)=0.008119920465 vs mpmath Taylor ODE solver 0.00811992046487 (agree to 1e-12) |
| 5 | Labelled with the computed $y(5)$ and its error | Confirmed | F annotations; values match S and I (below) |
| 6 | RK4 computes four slope estimates $k_1..k_4$ per step and takes a weighted average | Confirmed | Script lines 28–32 (weights 1,2,2,1 /6); identical to independent Butcher-tableau implementation to 10 digits |
| 7 | $O(h^5)$ local, $O(h^4)$ global truncation error for smooth $f$ | Confirmed | I (mpmath): global error ratios on halving m=100→1600: 30.3, 20.4, 18.1, 17.05 (→16); one-step error from exact y(1): 5.61e-9, 1.73e-10, 5.36e-12 for h=0.1, 0.05, 0.025 (ratio 32.4, 32.3 → 2^5). f is smooth along the trajectory since y ≥ 0.0081 > 0 |
| 8 | Heading: $m = 12$ to $150$ subintervals | Confirmed | Script line 15 |
| 9 | Reference rises from $y(0)=1$ to about $1.4498$ near $t=0.88$ | Confirmed | I: peak t=0.88356, y=1.449767; S: ref peak t=0.8836, y=1.449767 |
| 10 | then decays toward the nullcline $y=1/t^3$ (where $y'=0$) | Confirmed | $1-t y^{1/3}=0 \Leftrightarrow y=t^{-3}$; y(5)=0.00812 vs 1/125=0.008 |
| 11 | reaches $y(5)=0.0081199$ | Confirmed | I 0.00811992046; S yex5 0.008119920465 |
| 12 | For $m=12$ through $52$ the computed curve visibly turns upward before $t=5$ | Confirmed | I: every m in 12–52 has upward steps after t>1.5 (2 to 6 of them); smallest net rise m=52: 0.0097→0.0377 (≈6 px), visible in F frame 13; m=28 ends with a down-step but has rises from t=3.75 |
| 13 | ending at $y(5)\approx0.588$ for $m=12$ | Confirmed | 0.5883471 (S, I, L) |
| 14 | $0.289$ for $m=20$ | Confirmed | 0.2891074 |
| 15 | $0.0377$ for $m=52$ | Confirmed | 0.0376958 |
| 16 | at $m=56$ it still turns upward on the last step, but only by $8.1\times10^{-4}$, too little to see | Confirmed | Last step +8.0526e-4 (S, I); it is the only upward step after t>1.5; ≈0.2 px; F frame 14 shows no visible upturn |
| 17 | ends at $y(5)\approx0.0099$ ($m=56$) | Confirmed | 0.0098571 |
| 18 | The error in $y(5)$ falls at every refinement in the sweep | Confirmed | Errors (all positive): 5.80e-1, 4.60e-1, 3.80e-1, 3.24e-1, 2.81e-1, 2.19e-1, 1.03e-1, 1.00e-1, 7.53e-2, 6.17e-2, 5.24e-2, 4.57e-2, 2.96e-2, 1.74e-3, 3.43e-4, 2.76e-5, 6.80e-6, 2.77e-6, 1.42e-6, 5.25e-7, 1.76e-7 — strictly decreasing |
| 19 | $3.4\times10^{-4}$ at $m=60$ | Confirmed | 3.431e-4 |
| 20 | $2.8\times10^{-5}$ at $m=70$ | Confirmed | 2.765e-5 |
| 21 | $6.8\times10^{-6}$ at $m=80$ | Confirmed | 6.805e-6 |
| 22 | $1.8\times10^{-7}$ at $m=150$, where $y(5)\approx0.0081201$ | Confirmed | 1.757e-7; 0.0081200962 |
| 23 | $\partial f/\partial y=-t/(3y^{2/3})$ | Confirmed | Differentiate $1-t y^{1/3}$; script line 12 |
| 24 | reaches $-41.3$ at $t=5$ | Confirmed | −41.2554 (on the reference) |
| 25 | steps longer than about $h=0.0675$ ($m\le74$) | Confirmed | $h_{crit}=2.78529/41.2554=0.067513$, $m_{crit}=74.06$ |
| 26 | here $m=12$ to $70$ exceed the limit before $t=5$ | Confirmed | Onsets (I, S): 12→3.103 … 70→4.908; 80–150 never |
| 27 | RK4's stability limit $2.785$ | Confirmed | Root of $|1+z+z^2/2+z^3/6+z^4/24|=1$ on negative axis: −2.7852936 (brentq, I) = script 2.7852935634 |
| 28 | from then on errors are amplified instead of damped (the shaded region in those frames) | Confirmed with caveat → F1 | For the linearisation about the reference, |R(h f_y)|>1 throughout the shaded region (e.g. m=60: 1.001→2.52; m=52: 1.21→4.8) and errors there do grow (m=60: 2.8e-5→3.4e-4 over 4 steps). Criterion is evaluated on the reference, not the plotted run; see F1 |
| 29 | $m=70$: from $t\approx4.91$ | Confirmed | 4.9083 |
| 30 | at $m=12$ it starts at $t\approx3.10$ | Confirmed | 3.1033 |
| 31 | For $m=80$ to $150$, $h|\partial f/\partial y|$ stays below $2.785$ up to $t=5$ | Confirmed | m=80: $h|f_y(5)|=2.578$; larger m smaller |
| 32 | Source link `rungekuttaaa.jl`, embed `rungekuttaaa.gif` are this case | Confirmed | Script writes `rungekuttaaa.gif`; committed GIF byte-identical to regenerated; parameters match heading |
| 33 | Alt: gray reference curve peaks near 1.45 at $t\approx0.88$, decays to 0.0081 at $t=5$ | Confirmed | as #9, #11; F: gray `:gray70` line |
| 34 | Alt: for $m=12$ to $52$ the run visibly turns upward in the tail, ending at $y(5)=0.588$ for $m=12$ (at $m=56$ too small to see) | Confirmed | as #12, #13, #16 |
| 35 | Alt: for $m=12$ to $70$ a shaded region marks where $h|\partial f/\partial y|$ exceeds 2.785 | Confirmed (on the reference; see F1) | F: shading present in frames 1–16, absent 17–21 |
| 36 | Alt: runs settle onto the reference as $m$ grows, $y(5)=0.0081201$ at $m=150$ | Confirmed | #18, #22; F frame 21 |
| 37 | Frame title function "y' = 1 - t·y^(1/3), y(0) = 1" | Confirmed | Same as `f` in code |

Fidelity (legacy): The legacy GIF's 21 runs use exactly this m list and its printed y(5) values (0.5883471, 0.4685529, 0.3876236, 0.3316264, 0.2891074, 0.2274383, 0.1108585, 0.1082442, 0.0834665, 0.0698482, 0.0604713, 0.0538504, 0.0376958, 0.0098571, 0.008463, 0.0081476, 0.0081267, 0.0081227, 0.0081213, 0.0081204, 0.0081201) agree with the script's to all 7 printed decimals. Curve shapes (e.g. m=12 dipping to ≈0.13 at t≈2.9 then rising with a kink) match. The animation portal lists one animation; nothing is dropped. No fidelity findings.

---

### 3. Implementation checks — `rungekuttaaa.jl`

**Method is what it claims.** Classical 4-stage RK4 (c = 0, ½, ½, 1; a21=a32=½, a43=1; b = 1/6, 1/3, 1/3, 1/6), increments scaled by h (Mathews' form). Independent Python implementation from the Butcher tableau gives identical values (10 digits). Order verified empirically with mpmath (global ratio → 16, local ratio → 32), independent of remembering the coefficients.

**Numbers are right.** Script (instrumented) vs independent:

| m | script y(5) | independent y(5) | legacy y(5) |
|---|---|---|---|
| 12 | 0.5883470625 | 0.5883471 | 0.5883471 |
| 20 | 0.2891074072 | 0.2891074 | 0.2891074 |
| 52 | 0.0376958174 | 0.0376958 | 0.0376958 |
| 56 | 0.0098570759 | 0.0098571 | 0.0098571 |
| 60 | 0.0084629872 | 0.0084630 | 0.008463 |
| 70 | 0.0081475680 | 0.0081476 | 0.0081476 |
| 150 | 0.0081200962 | 0.0081201 | 0.0081201 |

(all 21 agree; full lists in `inst.jl` / `indep.py` output). `cbrt` never sees a negative argument (min over all runs 0.008120 > 0). Stability limit: script bisection 2.7852935634, independent brentq 2.7852935634.

**Reference values are right.** Reference = RK4 with 50 000 steps; y(5)=0.008119920465 vs mpmath `odefun` (Taylor, 30 digits) 0.00811992046487 — difference < 1e-12, far below the smallest error displayed (1.8e-7). Peak of reference 1.449767 at t=0.8836 confirmed (f≈0 there). Onset times computed on the reference at Δt=1e-4 agree with an independent dense-output DOP853 evaluation on a 1e-5 grid to 3 decimals (3.103, 3.162, …, 4.908).

**Picture shows what was computed.** Frames 1, 2–12 (contact sheet), 13 (m=52), 14 (m=56), 16 (m=70), 21 (m=150) inspected. Magenta polyline with node markers is the RK4 run; gray line is the reference; red dot at (5, y_m(5)); annotations show y(5), signed error, reference y(5) and onset text, all matching the computed values. Frame order follows the m list. Axis limits (−0.05, 1.8) contain every value of every run (max 1.44975, min 0.008120), so no clamping. Shading spans [onset, 5] and is present exactly for m ≤ 70. Only issue: the shading criterion is evaluated on the reference, which the legend does not say (F1). Note also that for m=12–20 the upturn's vertex node (e.g. t=2.917 for m=12) lies just left of the shaded onset (3.10) because the step that jumps straddles the onset; this is inherent to a pointwise criterion applied to a finite step and is not counted as a finding.

