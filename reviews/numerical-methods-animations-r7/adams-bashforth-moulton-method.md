# Adams-Bashforth-Moulton Method — animation review (round 7)

Page: `pages/numerical-methods/adams-bashforth-moulton-method/`. Reported findings: **0 Error, 1 Misleading, 0 Minor**.

## Findings

### F1. Page match, Misleading: "a close end value" at m = 12 is 2.6 times the exact value

- **Location:** `index.qmd` lines 40-41: "and a close end value can hide a bad run: at $m=12$, $y(5)=0.0214$, although the run is off by $0.74$ at $t\approx4.17$."
- **What is there now:** $y(5)=0.0214$ is presented as *close* to the true value.
- **What is true:** the exact value is $0.0081199$, so the m = 12 end value is **2.64 times** the exact value (relative error 164%). It is close only in absolute terms and at the plot's scale (error $+0.0133$, about 2 pixels). The numbers quoted in the sentence are themselves right ($0.0214088$; maximum node error $0.7364$ at $t=4.1667$).
- **Why it matters:** the same paragraphs judge this quantity relatively. They call the m = 70 error of $2.1\times10^{-3}$ "26% of $y(5)$" and the n = 50 end value "about 17 times the exact value". By that standard m = 70, with a 26% error, is far closer than m = 12, with a 164% error, yet m = 12 is the one called close.
- **How I know:** `review/script_runs.csv` (from `instr.jl`), reference from mpmath `odefun` at 30 digits, $y(5)=0.00811992046486796$:

  | m | y(5) | y(5)/exact | abs. error |
  |---|---|---|---|
  | 12 | 0.0214088 | 2.637 | 0.0133 |
  | 56 | 0.0167970 | 2.069 | 0.0087 |
  | 70 | 0.0102009 | 1.256 | 0.0021 |

- **Suggested correction:** "and a small absolute end error can hide a much worse run: at $m=12$, $y(5)=0.0214$ is off by only $0.013$ (though that is still 2.6 times the exact value), while the run is off by $0.74$ at $t\approx4.17$."

---

- **Independent check:** confirmed.


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adamsbashforthmoultonaa.jl` | 0 | 13.4 | adamsbashforthmoultonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `adamsbashforthmoultonaa.gif` | 21 | byte-identical | adamsbashforthmoultonaa |

### Page references

- Scripts linked: `adamsbashforthmoultonaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts: **C** confirmed, **W** wrong or misleading, **ND** could not determine. There are no ND entries.

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | ABM is a predictor-corrector multistep scheme for $y'=f(t,y)$ | C | Code lines 51-61 |
| 2 | "4-step form": explicit AB predictor from recent history | C | Coefficients 55, -59, 37, -9 over 24 match my derivation by integrating the Lagrange interpolant |
| 3 | Implicit AM corrector "immediately refines it" | C | Coefficients 9, 19, -5, 1 over 24, derived the same way; one correction per step (PECE). The corrector uses three back values, order 4, as in Mathews `gr_18` |
| 4 | Not self-starting; initial points from a one-step method such as RK4 | C | Code lines 41-49; Mathews `gr_38` does the same |
| 5 | Each new value uses prior function evaluations, high accuracy, low per-step cost | C | Maximum node error ratio on halving h tends to 16 (15.24, 15.63 on [0,1]); two new f evaluations per step in the method as defined |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 6 | Repeats the sweep of Mathews' animation for legacy Example 11 | C | `lnk_12` (Example 11) links to `Adams1/Adamsaa.html`; legacy frames show the same sweep |
| 7 | $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $0\le t\le5$ | C | Code lines 12, 66-68; `gr_165` |
| 8 | Each frame is a complete ABM4 run with m subintervals | C | Code lines 109-110 |
| 9 | $h=5/m$ | C | Code lines 35, 111; frame titles |
| 10 | First three steps by RK4 | C | Code line 41 |
| 11 | The 21 values of m listed are those of Mathews' animation | C | Read all 39 legacy frames: 3 blank, m = 12 to 60 shown twice each, then 70, 80, 90, 100, 120, 150. The 21 distinct values are the listed ones |
| 12 | Frames labelled with computed y(5) and its error | C | All 21 labels read and compared with the computed table; all 21 y(5) also equal Mathews' legacy labels |
| 13 | Thick gray curve is a reference from fixed-step RK4 at $h=10^{-4}$ | C | Code lines 70-72, 123 (lw 4, gray70); 50000 steps |
| 14 | No closed-form exact solution is used | C | None in the script |

### Case heading and first Behavior paragraph

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 15 | Heading: ABM4 sweep, this ODE, m = 12 to 150 | C | Code line 69 |
| 16 | Reference rises to about 1.4498 near t = 0.88 | C | Peak 1.449767 at t = 0.883556 (mpmath root of y' = 0) |
| 17 | Decays to $y(5)=0.0081199$ | C | 0.00811992046 (mpmath); script 0.00811992046 |
| 18 | m = 12 to 52 visibly break away in the tail, from t ≈ 3.2 to 4.7 by m | C | First node with error above 0.02 (about 3 px): earliest 3.214 (m = 14), latest 4.688 (m = 48) |
| 19 | Each of these runs goes below zero somewhere | C | Minimum negative for all 13 runs |
| 20 | At m = 48 only to -0.0049, too little to see | C | Minimum -0.004882 at t = 4.896, under 1 px; frame 012 |
| 21 | Below zero, $\sqrt[3]{y}$ is the real cube root | C | Julia `cbrt`; equals Mathews' `Sign[y] Abs[y]^(1/3)` |
| 22 | m = 56, 60 stay on the reference until about t = 4.8, 4.9 | C | Same 0.02 threshold: 4.821, 4.917 |
| 23 | Then rise above it by up to 0.11 and 0.096 | C | +0.10798 at t = 4.911; +0.09555 at t = 5 |
| 24 | Across m = 12 to 60, y(5) ranges from -0.363 (m = 20) to 0.632 (m = 16) | C | -0.3628404 and 0.6321470 are the extremes of the 15 runs |
| 25 | "a close end value can hide a bad run" at m = 12 | **W** | **F1**: 2.64 times exact |
| 26 | m = 12: y(5) = 0.0214 | C | 0.0214088 |
| 27 | m = 12: off by 0.74 at t ≈ 4.17 | C | 0.7364 at t = 4.1667 |
| 28 | From m = 60 on, error in y(5) falls at every refinement | C | 9.56e-2, 2.08e-3, 1.09e-5, 2.94e-7, 4.49e-9, 5.66e-10, 1.36e-10 |
| 29 | Quoted errors at m = 60, 70, 80, 100, 150 | C | 9.6e-2, 2.1e-3, 1.1e-5, 4.5e-9, 1.4e-10 as above |
| 30 | m = 70 error is 26% of y(5) | C | 2.081e-3 / 8.120e-3 = 25.6% |
| 31 | m = 70 error too small to see | C | About 0.35 px; frame 016 |

### Stability paragraph

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 32 | $\partial f/\partial y=-t/(3y^{2/3})$ | C | Differentiation; code line 13 |
| 33 | Reaches -41.3 at t = 5 | C | -41.2554; \|f_y\| is monotone on [0,5] with its maximum at t = 5 |
| 34 | Stable on real λ < 0 only while h\|λ\| ≤ 1.285 | C | Own characteristic polynomial, bisected: 1.28481626 (script 1.28481626). ρ ≤ 1 throughout (0, limit); ρ > 1 for every sampled \|z\| in [1.2849, 500]. Direct recurrence decays at z = -1.284 and grows at z = -1.286 |
| 35 | Every m ≤ 160 (h > 0.0311) exceeds the limit before t = 5 | C | Critical h = 0.031143, critical m = 160.55; h\|f_y(5)\| = 1.2892 at m = 160, 1.2812 at m = 161 |
| 36 | Includes every frame here | C | Largest m is 150 |
| 37 | Shaded region from t ≈ 2.83 (m = 12) to t ≈ 4.89 (m = 150) | C | 2.826 and 4.8896; all 21 frame labels agree with the computed onsets |
| 38 | The analysis "shows where this can start" | C | In all 15 runs of m = 12 to 60 the first node with error above 0.01 lies after the onset |
| 39 | m = 12 to 60: error at last step before the shaded region is 5.6e-5 to 2.2e-3 | C | Minimum 5.64e-5 (m = 60), maximum 2.17e-3 (m = 20) |
| 40 | After it the error reaches 0.096 to 0.74 | C | Smallest maximum 0.0956 (m = 60), largest 0.7364 (m = 12) |
| 41 | m = 100, 120, 150: below 1e-8 there | C | 8.25e-9, 1.12e-9, 1.66e-10 |
| 42 | Error at t = 5 is smaller still | C | 4.49e-9, 5.66e-10, 1.36e-10, each below the value in #41 |
| 43 | h = 0.0311 is a stability bound, not an accuracy threshold | C | m = 100 to 150 are past the bound in the tail with errors below 1e-8 there |
| 44 | Module's Example 11 uses n = 50, 100, 150 | C | `gr_166`, `gr_173`, `gr_180` |
| 45 | n = 100 and 150 end at 0.0081199 | C | 0.00811991598, 0.00811992033; legacy 0.00811992 |
| 46 | n = 50: $y_{48}\approx-0.0018$ at t = 4.8 | C | -0.00183090; legacy `gr_170` -0.0018309 |
| 47 | n = 50 ends at about 0.138 | C | 0.1380900; legacy 0.13809 |
| 48 | About 17 times the exact value | C | 17.006 |

### Wiring and alt text

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 49 | Source link points at this case's script | C | `adamsbashforthmoultonaa.jl` exists and is the only script |
| 50 | Embed points at this case's GIF | C | Byte-identical regeneration per manifest |
| 51 | Alt: each frame a complete run, m = 12 to 150 | C | As #8, #15 |
| 52 | Alt: gray curve peaks near 1.45 at t ≈ 0.88, decays to 0.0081 | C | As #16, #17 |
| 53 | Alt: m = 12 to 60 break away, ending between -0.363 and 0.632 | C | As #18, #22, #24 |
| 54 | Alt: shaded region marks h\|f_y\| > 1.285, in every frame | C | Onset exists for all 21 m |
| 55 | Alt: from m = 70 on the run lies on the reference at this scale | C | Largest node error for m ≥ 70 is 2.08e-3, about 0.35 px |
| 56 | Alt: y(5) = 0.0081199 at m = 100, 150 | C | As #45 |

---

### 3. Implementation checks: `adamsbashforthmoultonaa.jl`

### It is the method it claims to be: confirmed

Classical fourth-order ABM in PECE mode with RK4 starting values and no local-extrapolation modifier. This is the same variant as Mathews' `ABM` subroutine (`gr_38`), and the page describes it correctly. Coefficients were derived independently with sympy by integrating Lagrange interpolants: AB `[55, -59, 37, -9]/24`, AM `[9, 19, -5, 1]/24`.

### The numbers are right: confirmed

- An independent Python implementation agrees with the script's values at every node of all 21 runs plus n = 50. The largest difference in any run is 1.2e-13.
- Convergence: maximum node error on [0, 1] for m = 20 to 320 is 8.77e-8, 6.58e-9, 4.53e-10, 2.97e-11, 1.90e-12, with ratios 13.32, 14.54, 15.24, 15.63, approaching $2^4$. On [0, 2.5] the ratios are 15.33, 12.79, 14.21, 15.06. On $y'=y$ they are 11.81, 13.95, 14.98. The error at a single endpoint is not a usable order measure here: at t = 2 it passes through a sign change and gave ratios from 1.03 to 374, so I used the maximum norm.
- Mathews' printed tables match to their printed digits, for example:

  | Run | Node | Script | Mathews |
  |---|---|---|---|
  | n = 50 | y₃₀ | 0.0897596 | 0.0897596 |
  | n = 50 | y₄₈ | -0.0018309 | -0.0018309 |
  | n = 50 | y₅₀ | 0.13809 | 0.13809 |
  | n = 100 | y₆₀ | 0.0898282 | 0.0898282 |
  | n = 100 | y₉₉ | 0.00837376 | 0.00837376 |
  | n = 150 | y₉₀ | 0.0898311 | 0.0898311 |
  | n = 150 | y₁₄₉ | 0.00828797 | 0.00828797 |

- Stability limit: script 1.284816263106912, independent 1.2848162631069109.

### Its reference values are right: confirmed

- Script RK4 y(5) = 0.008119920464867961; mpmath Taylor (`odefun`, 30 digits) 0.0081199204648679610; DOP853 (rtol 1e-13) 0.008119920464867971.
- The script's reference differs from DOP853 by at most 3.7e-13 over sampled nodes. That is about 370 times smaller than the smallest error the page quotes (1.4e-10), so it supports every comparison.
- The mpmath solution satisfies the ODE: residuals 1.6e-10 at t = 2 and -3.6e-12 at t = 4 under numerical differentiation.

### The picture shows what was computed: confirmed

- All 21 frames: title, m, h, y(5), signed error, reference y(5) and onset time read and matched to the computed table.
- Pixel check (`final.py`): axes calibrated from the frame box, and every computed node of every run lies on drawn magenta or the red end marker (13/13 up to 151/151).
- The line extremes in the pixels agree with the computed extremes, within line width. Where the extreme is the last node (m = 16, 18, 20, 24, 32, 36, 40, 60) the red end marker covers it, as drawn at the right value.
- No clamping or NaN masking. Axis limits (-0.5, 1.8) contain every value: minimum -0.4530 at m = 14, maximum 1.44975 at m = 90, as the comment on line 106 states.
- The shaded band is computed along the reference solution, the frozen-coefficient reading the page gives. The value -41.3 is likewise the reference value.
- Annotations and legend do not cover the data in any frame.

### Fidelity to the legacy archive: no finding

Same ODE, interval, initial value, method variant, starting procedure, and the same 21 values of m, with all 21 y(5) labels equal to Mathews'. The module has one animation item and the page reproduces it. The reference curve, shading and error labels are additions. The legacy GIF's repeated frames and blank lead-in are pacing only.

