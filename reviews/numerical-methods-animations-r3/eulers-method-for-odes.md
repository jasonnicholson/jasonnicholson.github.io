# Euler's Method for ODE's — animation review (round 3)

Page: `pages/numerical-methods/eulers-method-for-odes/`. Reported findings: **0 Error, 1 Misleading, 1 Minor**.

## Findings

### F1: Page match, **Misleading**: the error in y(5) is presented as the accuracy measure, but here it is roughly 10⁴ times smaller than the global error and hides the difference between the two methods

**Location**
- `index.qmd` lines 51–55 (Case 1): "from $m=60$ the error in $y(5)$ falls at every refinement, roughly halving when $m$ doubles, as expected of a first-order method: $-4.2\times10^{-6}$ at $m=60$, $-2.1\times10^{-6}$ at $m=120$ and $-1.7\times10^{-6}$ at $m=150$".
- Lines 80–82 (Case 2): "to $2.5\times10^{-4}$ at $m=80$ and $1.8\times10^{-6}$ at $m=150$".
- Lines 20–25 (Description): modified Euler "improves the global accuracy to $O(h^2)$".
- Frame annotation `error = %+.1e` (`eulersmethodaa.jl` line 86, `eulersmethodbb.jl` line 89).

**What is there now.** Every quoted number is correct. The page and the frames, however, report only the error at t = 5, as if it measured how accurate each run is. At m = 150 the reader sees Euler's error as −1.7e-06 and modified Euler's as +1.8e-06. The two are effectively equal, right after the Description has said the midpoint method is second order and Euler first order. The last Euler frame (frame 20, m = 150) prints "error = -1.7e-06", yet in the same frame the magenta curve sits visibly above the gray reference near the peak.

**What is true instead.** Near t = 5 the problem is strongly contracting (∂f/∂y ≈ −41.3), and the solution is pulled onto the nullcline y ≈ 1/t³. That contraction wipes out the error accumulated earlier, so the error at t = 5 is not representative of the run. The global errors differ by more than two orders of magnitude.

| run | error at t=5 | max \|error\| over grid (where) | error at t=1 |
|---|---|---|---|
| Euler m=60 | −4.22e-06 | 5.70e-02 (t=1.667) | +4.36e-02 |
| Euler m=120 | −2.14e-06 | 2.82e-02 (t=1.667) | +2.17e-02 |
| Euler m=150 | −1.72e-06 | 2.25e-02 (t=1.667) | +1.73e-02 |
| Midpoint m=120 | +5.14e-06 | 2.56e-04 (t=3.208) | −2.57e-05 |
| Midpoint m=150 | +1.82e-06 | 1.59e-04 (t=3.200) | −1.64e-05 |

The instrumented scripts give the same maximum grid errors: `emax` = 2.250e-02 for Euler m=150 and 1.635e-04 for midpoint m=150. The script's version differs slightly because it matches against the nearest RK4 grid node.

**How I know.**
- `/usr/bin/python3` with `indep.py` plus the max-error snippet, which compares against DOP853 dense output with rtol 1e-13.
- `julia eulersmethodaa_instr.jl` and `julia eulersmethodbb_instr.jl` (column `emax`).
- At the peak, the Euler m=150 maximum is 1.46549 against the reference 1.449767 (instrumented output).

**Suggested correction.**
- In each Behavior paragraph, add a sentence saying that the strong decay near t = 5 shrinks the final-time error far below the error elsewhere in the run. Quote the maximum error as well, for example "the largest error along the run is about 2.2×10⁻² for Euler at m = 150 against 1.6×10⁻⁴ for modified Euler".
- Optionally change the frame label to "error at t=5" and add a "max error" line computed against the reference.

- **Independent check:** confirmed with correction: the core claim holds. The roughly 10^4 ratio applies to Case 1 (Euler, m >= 55; 3.3e3 at m = 50). In Case 2 (midpoint) the end-point error equals the global error for m <= 70 and understates it 2.5 to 87 times for m = 80-150. At m = 150 the global errors are 2.25e-2 (Euler) and 1.6e-4 (midpoint), about 140 times apart, while the printed errors are -1.7e-6 and +1.8e-6. The Description O(h^2) statement is correct but nothing on the page shows it. Details: checker verify.md (global-error table).

### F2: Page match, **Minor**: Case 2 says only m = 12–20 zig-zag, but m = 24 (and slightly m = 28) also zig-zag in the last steps

**Location**
- `index.qmd` lines 75–76: "For $m=12$ to $20$ the tail zig-zags. For $m=24$ to $60$ the curve turns upward before $t=5$ instead of following the decay, rising from its minimum by $0.57$ at $m=24$ …".
- Alt text on line 92: "For m = 12 to 20 the run zig-zags in the tail, and for m = 24 to 60 it turns upward".

**What is there now.** m = 24 is grouped with the smooth-upturn runs.

**What is true instead.** The last six values of the m = 24 midpoint run are 0.0858, 0.1241, 0.1300, 0.1992, 0.1237, 0.6127, so the last steps are +0.069, −0.076, +0.489. That is a clear alternation, visible in committed frame `eulersmethodbb/frame_006.png` as a dip followed by a large jump to the red end point. Most of the 0.57 "rise from its minimum" is that one final jump.
- m = 28 ends with steps +0.028, −0.0075, +0.259: a small dip and then a jump.
- From m = 32 on, the post-minimum sequence rises without a dip. In my check, the step-sign changes after the peak number 1 for every m from 32 to 60.

**How I know.** `indep.py` and the inline snippet printing `mid(m)` tails for m = 24, 28, 32. The legacy MEuleraa frame for m = 24 shows the same final zig-zag.

**Suggested correction.** "For $m=12$ to $24$ the tail zig-zags (at $m=24$ only in the last few steps). For $m=28$ to $60$ the curve turns upward…". Move the "0.57 at m=24" figure into the zig-zag sentence, or replace it with m = 32's rise of 0.108. Update the alt text to match.

No other findings. Every numerical claim on the page (more than 50) agreed with my independent computation at the stated precision. See the ledger.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `eulersmethodaa.jl` | 0 | 11.8 | eulersmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `eulersmethodbb.jl` | 0 | 13.8 | eulersmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `eulersmethodaa.gif` | 20 | byte-identical | eulersmethodaa |
| `eulersmethodbb.gif` | 21 | byte-identical | eulersmethodbb |

### Page references

- Scripts linked: `eulersmethodaa.jl`, `eulersmethodbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

**Description**

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | Euler: $y_{n+1}=y_n+h f(t_n,y_n)$, $t_{n+1}=t_n+h$ | confirmed | `eulersmethodaa.jl` l.28 implements exactly this |
| D2 | Euler local truncation error $O(h^2)$, global $O(h)$ | confirmed | max grid error ratios when m doubles from 200 to 3200: 2.007, 2.004, 2.002, 2.001 |
| D3 | Mathews' modified Euler is the explicit midpoint method $y_{n+1}=y_n+hf(t_n+h/2, y_n+\tfrac h2 f(t_n,y_n))$ | confirmed | archive gr_40 (formula) and gr_42 (`MEuler` subroutine) are exactly this; `eulersmethodbb.jl` l.30 implements it |
| D4 | Midpoint improves global accuracy to $O(h^2)$ | confirmed | max grid error ratios: 4.19, 4.09, 4.05, 4.02 |

**Animations introduction**

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| I1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $0\le t\le5$ | confirmed | scripts l.12/14, 14/16; archive gr_228 shows the same IVP |
| I2 | Each frame is a complete run with m subintervals, h = 5/m | confirmed | loop over `ms`, one run per frame; titles show "h = 5/m" |
| I3 | m values are those of Mathews' animation | confirmed | legacy Euleraa has 20 distinct run frames: m = 10, 15, …, 150, identical to `ms`. MEuleraa has 21: m = 12, …, 150, identical |
| I4 | Gray reference is fixed-step RK4 with 50 000 steps | confirmed | `rk4(50_000)`; y(5) = 0.008119920464868, equal to RK4 at 25 000 steps and to mpmath (0.00811992046486796) |
| I5 | Frames labelled with computed y(5) and its error | confirmed | annotate lines; all frames checked on the contact sheets |
| I6 | Light red band marks where $h\lvert\partial f/\partial y\rvert$ exceeds the stability limit | confirmed | `vspan!` from the onset, which is evaluated along the reference solution (that choice is not stated, but it is reasonable) |
| I7 | Legacy Euleraa/MEuleraa y(5) values agree with the runs here to seven decimals | confirmed | all 41 legacy labels read; each equals my value rounded to 7 dp (for example −0.002737 ↔ −0.0027370, 0.008372 ↔ 0.0083720) |
| I8 | Examples 11/12 print runs at m = 40, 100, 150 and agree | confirmed | archive gr_235/242/249: −0.0174406, 0.00811736, 0.00811821. Mine: −0.0174406187, 0.0081173646, 0.0081182053. gr_257/264/271: 0.0761463, 0.00813852, 0.00812174. Mine: 0.0761462774, 0.0081385159, 0.0081217390 |

**Case 1 (Forward Euler)**

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Heading: Forward Euler sweep, m = 10 to 150 | confirmed | script `ms` |
| A2 | 20 values: 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150 | confirmed | `ms` l.16; the GIF has 20 frames (manifest) |
| A3 | Reference rises to about 1.4498 near t = 0.88 | confirmed | peak y = 1.449767 at t = 0.88356 |
| A4 | Then decays toward the nullcline $y=1/t^3$ (where y' = 0) | confirmed | $1-t y^{1/3}=0 \iff y=t^{-3}$. At t = 5, y = 0.00812 against 1/125 = 0.008 |
| A5 | Reference y(5) = 0.0081199 | confirmed | 0.0081199205 |
| A6 | m = 10–40 zig-zag in the tail and dip below zero | confirmed | minima −0.462, −0.170, −0.132, −0.116, −0.032, −0.045, −0.0174. Alternating tails, e.g. m=10: 0.07, −0.05, 1.11, −0.46, 1.78 |
| A7 | Exact solution stays positive | confirmed | reference min > 0; y' = 1 > 0 at y = 0 |
| A8 | y(5) ≈ 1.777 (m=10), 0.391 (m=30), −0.0174 (m=40) | confirmed | 1.7774834, 0.3907263, −0.0174406 |
| A9 | m = 40 is the first of Example 11's runs | confirmed | archive gr_229 (n = 40) and gr_235 |
| A10 | At m = 45 the last steps alternate by less than 0.009, too little to see | confirmed | last steps +0.0002, −0.0033, +0.0086; frame_008 looks smooth at this scale |
| A11 | From m = 50 on, runs decrease steadily after their peak | confirmed | strictly decreasing after argmax for every m ≥ 50 |
| A12 | From m = 60 the error in y(5) falls at every refinement | confirmed | \|e\|: 4.22, 3.62, 3.18, 2.83, 2.56, 2.33, 2.14, 1.98, 1.84, 1.72 (e-6). m = 55 → 60 rises slightly (4.19 → 4.22), so "from 60" is the right start |
| A13 | Roughly halving when m doubles | confirmed | 60 → 120: ratio 1.98 |
| A14 | −4.2e-6 (m=60), −2.1e-6 (m=120), −1.7e-6 (m=150), y(5) ≈ 0.0081182 | confirmed (but see F1) | −4.2235e-6, −2.1369e-6, −1.7152e-6, 0.0081182053 |
| A15 | $\partial f/\partial y=-t/(3y^{2/3})$ reaches −41.3 at t = 5 | confirmed | −41.2554 |
| A16 | Critical h ≈ 0.0485 (m ≤ 103; here m = 10 to 100) | confirmed | h* = 2/41.2554 = 0.048478, m* = 103.14. \|f_y\| is monotone along the reference, so the maximum is at t = 5 |
| A17 | Euler stability limit 2 | confirmed | \|1+z\| ≤ 1 ⇔ −2 ≤ z ≤ 0 |
| A18 | Beyond the onset each step multiplies the inherited error by 1 + h f_y < −1, with alternating sign | confirmed | linear error recurrence e_{n+1} = (1+hf_y)e_n + τ_n. Measured product of \|1+hf_y\| beyond the onset is 1.1e3 for m=45 and 441 for m=50 |
| A19 | At m = 10 the onset is at t ≈ 2.92 | confirmed | 2.9228 |
| A20 | For m = 10–45, error at t=5 is larger than just before the onset | confirmed | e.g. m=10: 0.258 → 1.77; m=45: 8.0e-5 → 7.1e-3. All eight hold |
| A21 | For m = 50–100 the onset runs from t ≈ 3.95 to t ≈ 4.95 | confirmed | 3.9503 and 4.9495 |
| A22 | For m = 50–100 the amplified part is too small to see; runs decrease steadily; error at t=5 is smaller than before the onset | confirmed | e.g. m=50: 4.66e-5 → 2.11e-5; m=100: 3.04e-6 → 2.56e-6. The oscillatory error component at m=50 is at most 1.5e-5 |
| A23 | For m = 110–150, h\|f_y\| < 2 up to t = 5 | confirmed | h ≤ 0.04545 < 0.04848; no onset |
| A24 | Link `eulersmethodaa.jl`, embed `eulersmethodaa.gif` is this case | confirmed | regenerated GIF is byte-identical (manifest); frame titles read "Euler's method" |
| A25 | Alt text: peak near 1.45 at t ≈ 0.88; 0.0081 at t = 5; m = 10–40 zig-zag below zero; 1.777 at m = 10; shading for m = 10–100; steady from m = 50; 0.0081182 at m = 150 | confirmed | as above; contact sheet shows shading through m = 100 (thin strip) and none at m = 120, 140 |

**Case 2 (Modified Euler / midpoint)**

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| B1 | Heading: midpoint sweep, m = 12 to 150 | confirmed | `ms` |
| B2 | 21 values: 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150 | confirmed | `ms` l.18; the GIF has 21 frames; matches legacy |
| B3 | Same reference as Case 1 | confirmed | identical code; y(5) identical |
| B4 | For m = 12 to 20 the tail zig-zags | confirmed | alternating tails (e.g. m=12: 0.14, 0.90, 0.15, 1.42, 0.20) |
| B5 | For m = 24 to 60 the curve turns upward instead of zig-zagging (implied by the contrast with B4) | **wrong in part (F2)** | m = 24 alternates +0.069, −0.076, +0.489 in its last steps; m = 28 has a small dip. Smooth upturn only from m = 32 |
| B6 | Rise from minimum: 0.57 (m=24), 0.057 (m=40), 0.015 (m=60) | confirmed | 0.5693, 0.05716, 0.01500 |
| B7 | y(5) ≈ 0.613, 0.0761, 0.0259 | confirmed | 0.6126681, 0.0761463, 0.0259429 |
| B8 | m = 40 is the first of Example 12's runs | confirmed | archive gr_257 |
| B9 | At m = 70 the upturn is only 0.0008 | confirmed | 0.000756 |
| B10 | From m = 80 on, runs decrease steadily after their peak | confirmed | monotone after the peak for m = 80, 90, 100, 120, 150; m = 70 is not |
| B11 | From m = 16 the error in y(5) falls at every refinement | confirmed | 1.11, 0.945, 0.806, 0.605, 0.376, 0.127, 0.089, 0.068, 0.055, 0.044, 0.035, 0.028, 0.0178, 2.0e-3, 2.5e-4, 5.4e-5, 1.86e-5, 5.1e-6, 1.8e-6 (14 → 16 rises, so "from 16" is right) |
| B12 | 2.5e-4 at m = 80, 1.8e-6 at m = 150, y(5) ≈ 0.0081217 | confirmed (but see F1) | 2.5203e-4, 1.8185e-6, 0.0081217390 |
| B13 | Amplification factor $1+z+z^2/2$; \|R\| ≤ 1 on the negative real axis exactly for −2 ≤ z ≤ 0; limit 2, same as Euler | confirmed | R − 1 = z(1 + z/2) ≤ 0 ⇔ −2 ≤ z ≤ 0, and R ≥ 1/2 > −1 for all real z |
| B14 | m ≤ 103 (here 12–100) exceed 2 before t = 5 | confirmed | same h* as A16 |
| B15 | Onset from t ≈ 2.99 (m=12) to t ≈ 4.95 (m=100) | confirmed | 2.9869 and 4.9495 |
| B16 | For each m = 12–100 the error at t=5 is larger than just before the onset | confirmed | all 19 hold, e.g. m=100: 1.385e-5 → 1.86e-5; m=12: 4.6e-3 → 0.188 |
| B17 | m = 120, 150 stay below 2 | confirmed | no onset |
| B18 | Link `eulersmethodbb.jl`, embed `eulersmethodbb.gif` is this case | confirmed | byte-identical regeneration; frame titles read "Modified Euler (midpoint)" |
| B19 | Alt text: m = 12–20 zig-zag, m = 24–60 turn upward; 0.0761 at m = 40; shading m = 12–100; steady from m = 80; 0.0081217 at m = 150 | wrong in part (F2), rest confirmed | as above |

**Fidelity**

| # | Item | Verdict | Evidence |
|---|---|---|---|
| L1 | Same IVP, same f (real cube root, Mathews `Sign[y] Abs[y]^(1/3)`), same methods, same m sequences as the archive animations | confirmed | gr_229, gr_42, legacy frame labels |
| L2 | Both archive animation portals (Euler, Modified Euler) are represented | confirmed | Mod page lists exactly two portals; the page has two cases |

---

### 3. Implementation checks

### `eulersmethodaa.jl` (forward Euler sweep)

- **The method it claims to be.** Line 28, `ys[i+1] = ys[i] + h*f(ts[i], ys[i])`, is forward Euler, not a variant. `f` uses `cbrt`, the real cube root, which equals Mathews' `Sign[y] Abs[y]^(1/3)`. That matters because the coarse runs go negative. `fy = -t/(3 cbrt(y)^2)` is the correct derivative of $1 - t\,\mathrm{sgn}(y)\lvert y\rvert^{1/3}$.
- **The numbers are right.** Instrumented copy against independent Python, y(5):
  - m=10: 1.7774833658 (script) / 1.7774834 (Python) / 1.7774834 (legacy frame)
  - m=35: −0.0027369792 / −0.0027370 / −0.002737
  - m=40: −0.0174406187 / −0.0174406 / −0.0174406
  - m=45: 0.0152568141 / 0.0152568 / 0.0152568
  - m=50: 0.0080988327 / 0.0080988 / 0.0080988
  - m=100: 0.0081173646 / 0.0081174 / 0.00811736 (Example 11)
  - m=150: 0.0081182053 / 0.0081182 / 0.0081182 (and 0.00811821)

  All 20 runs agree to every printed digit, and all 20 legacy labels match. Order check: error ratios of 2.00 when m doubles, which is first order.
- **Its reference values are right.** RK4 with 50 000 steps gives y(5) = 0.008119920464868. That is identical to 15 digits with RK4 at 25 000 steps, and it matches mpmath's Taylor ODE solver at 30 digits (0.008119920464867961) and DOP853 at rtol 1e-13. Peak (0.88356, 1.449767) agrees with Python's (0.8835558, 1.4497667). The reference is far more accurate than the 1e-6 error labels require.
- **The picture shows what was computed.**
  - First frame (m=10), frame 8 (m=45), the contact sheet frames, and the last frame (m=150) all checked.
  - Title m and h match the frame.
  - The red dot sits at (5, y_m).
  - The shaded band starts at the printed onset and is absent for m ≥ 110.
  - The y window (−0.55, 1.9) contains every value (global min −0.46237 at m=10, max 1.77748 at m=10), which the script also asserts. Nothing is clamped.
  - The only interpretive problem is F1: the "error" label is the error at t=5 only.

### `eulersmethodbb.jl` (modified Euler = explicit midpoint sweep)

- **The method it claims to be.** Line 30, `ys[i] + h*f(ts[i]+h/2, ys[i]+(h/2)*f(ts[i],ys[i]))`, is the explicit midpoint method. That is exactly Mathews' `MEuler` subroutine (archive gr_42) and the page's formula. It is not Heun's method. Same f and f_y as above.
- **The numbers are right.** y(5), script / Python / legacy:
  - m=12: 0.1958729272 / 0.1958729 / 0.1958729
  - m=16: 1.1185921236 / 1.1185921 / 1.1185921
  - m=40: 0.0761462774 / 0.0761463 / 0.0761463 (Example 12)
  - m=80: 0.0083719546 / 0.0083720 / 0.008372
  - m=100: 0.0081385159 / 0.0081385 / 0.00813852
  - m=150: 0.0081217390 / 0.0081217 / 0.00812174

  All 21 runs agree and all 21 legacy labels match. Order check: max-error ratios 4.19 → 4.02 when m doubles, which is second order.
- **Its reference values are right.** Same reference as aa; verified above.
- **The picture shows what was computed.**
  - First frame (m=12), frame 6 (m=24), the contact sheet frames, and the last frame (m=150) all checked.
  - Titles, legend, red end dot, shading onset and its absence for m ≥ 120 are all correct.
  - Window contains all values (min 0.00812 at m=150, max 1.44974), as the script's comment and assertion say.
  - The stability band uses limit 2, which is correct for $R(z)=1+z+z^2/2$ on the negative real axis.
  - Issues: F1 (the error label is the error at t=5 only) and F2 (the m=24 frame visibly zig-zags, contrary to the page's grouping).

