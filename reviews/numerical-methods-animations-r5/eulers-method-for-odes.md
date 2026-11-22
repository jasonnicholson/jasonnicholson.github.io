# Euler's Method for ODE's — animation review (round 5)

Page: `pages/numerical-methods/eulers-method-for-odes/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

Every numerical, behavioural, count, wiring and method claim on the page matched my independent computation at the precision it is stated to. The frames show what the scripts compute. The page is faithful to the legacy module, and both legacy sweeps are reproduced exactly.

Points I looked at and judged **not** to be findings:
- The red band uses ∂f/∂y evaluated along the *reference* solution, not along the computed run. The page does not say which. This is the natural reading of a stability limit, and it does not change any conclusion. Along the reference, h|∂f/∂y| increases strictly after the peak (checked), so the band [onset, 5] is exactly the set where the condition holds.
- The Case 1 mechanism text says late negative ∂f/∂y "damps the error made earlier", yet for m = 50 to 100 the final stretch is past the onset. These are consistent: the damping happens between the max-error point (t ≈ 1.7) and the onset. For m = 60, |e| goes from 5.7e-2 (max) to 4.6e-3 at t = 3 to 2.1e-5 just before the onset. The "amplified part stays too small" caveat is borne out by the numbers.
- At m = 24 (Case 2) the run also rises gently from its minimum at t = 3.54 before the last three alternating steps. The page groups m = 24 with the zig-zag runs and says that only the last three steps alternate. That is accurate.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `eulersmethodaa.jl` | 0 | 14.5 | eulersmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `eulersmethodbb.jl` | 0 | 13.1 | eulersmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

The evidence keys are listed after the table: J = instrumented Julia dump; P = independent Python (`indep.out`); T = `tails.py`; L = legacy archive; F = committed frames; S = sympy (`cmp.py`); O = order check.

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Euler: $y_{n+1}=y_n+h f(t_n,y_n)$, $t_{n+1}=t_n+h$ | `eulersmethodaa.jl` l.28; P matches J y(5) to 6e-15 | confirmed |
| D2 | Euler local truncation error O(h²), global O(h); accuracy improves linearly | O: max-error ratio on halving h = 2.004, 2.002, 2.001, 2.000 (m = 400→6400) | confirmed |
| D3 | Mathews' modified Euler is the explicit midpoint method, $y_{n+1}=y_n+h f(t_n+h/2, y_n+\tfrac h2 f(t_n,y_n))$ | L: gr_40 shows this formula; the gr_42 `MEuler` subroutine is the same; `eulersmethodbb.jl` l.30 is identical | confirmed |
| D4 | Midpoint improves global accuracy to O(h²) | O: ratios 4.093, 4.046, 4.023, 4.011 | confirmed |
| A1 | IVP $y'=1-t\sqrt[3]{y}$, $y(0)=1$, $0\le t\le5$ | Both scripts l.12–17; L gr_228 / gr_229 (Mathews uses Sign[y]Abs[y]^(1/3), and the scripts use `cbrt`) | confirmed |
| A2 | Each frame is a complete run with m subintervals, h = 5/m, for the m values of Mathews' animation | Scripts; L: the legacy frame labels list exactly the same m sequences | confirmed |
| A3 | Gray reference = fixed-step RK4 with 50 000 steps | Scripts l.34–49. Reference y(5) = 0.008119920464867961; DOP853 0.00811992046486798; mpmath 0.00811992046486796 | confirmed |
| A4 | Frames labelled with computed y(5), error at t = 5, and largest error at any grid point | F; scripts l.94–96 | confirmed |
| A5 | Light red band marks where h\|∂f/∂y\| exceeds the stability limit | Scripts l.62–68, 85–87; F. The limit is 2 for both methods (S) | confirmed (evaluated along the reference; see the notes under Findings) |
| A6 | Legacy `Euleraa.gif` / `MEuleraa.gif` sweep m the same way | L: the frame labels are m = 10,15,…,60,70,…,150 and 12,14,16,18,20,24,…,60,70,80,90,100,120,150 | confirmed |
| A7 | Every y(5) printed in the legacy animations agrees with the runs here to 7 decimals | P vs L: all 41 match when rounded to 7 d.p. (e.g. m = 35 Euler −0.002736979 vs printed −0.002737; midpoint m = 80 0.008371955 vs 0.008372) | confirmed |
| A8 | Examples 11 and 12 print runs with m = 40, 100, 150, and their final values agree | L gr_233/240/247: −0.0174406, 0.00811736, 0.00811821. P: −0.017440619, 0.008117365, 0.008118205. L gr_255/262/269: 0.0761463, 0.00813852, 0.00812174. P: 0.076146277, 0.008138516, 0.008121739 | confirmed |
| C1-h | Case 1 heading: forward Euler, same IVP, m = 10 to 150 | `eulersmethodaa.jl` l.16, 28 | confirmed |
| C1-1 | 20 values m = 10,15,20,25,30,35,40,45,50,55,60,70,80,90,100,110,120,130,140,150 | Script l.16; GIF has 20 frames | confirmed |
| C1-2 | Reference rises to about 1.4498 near t = 0.88 | P: peak 1.449767 at t = 0.8836 | confirmed |
| C1-3 | Then decays toward nullcline y = 1/t³ (where y' = 0) | y' = 0 ⇔ y = t⁻³. P: y_ref(4) = 0.01624 vs 0.01563, y_ref(5) = 0.00812 vs 0.008, and strictly decreasing after the peak | confirmed |
| C1-4 | Reaches y(5) = 0.0081199 | 0.00811992 | confirmed |
| C1-5 | m = 10 to 40 zig-zag in tail and dip below zero; exact solution stays positive | T: alternating tail increments for every m in 10–40; min y = −0.4624, −0.1702, −0.1315, −0.1163, −0.0322, −0.0452, −0.0174. The exact solution stays positive (y' = 1 at y = 0; reference min > 0) | confirmed |
| C1-6 | End at y(5) ≈ 1.777 (m = 10), 0.391 (m = 30), −0.0174 (m = 40) | 1.7774834, 0.3907263, −0.0174406 | confirmed |
| C1-7 | m = 40 is the first of the Example 11 runs (40, 100, 150) | L lnk_12 | confirmed |
| C1-8 | At m = 45 the last steps still alternate, by less than 0.009, too little to see | T: last increments +0.0002, −0.0033, +0.0085. F frame 8 shows no visible wiggle | confirmed |
| C1-9 | From m = 50 on, runs decrease steadily after their peak | T/P: strictly decreasing after the peak for every m ≥ 50 | confirmed |
| C1-10 | Error at t = 5: −4.2e-6 (m = 60), −1.7e-6 (m = 150); y(5) ≈ 0.0081182 at m = 150 | −4.22e-6, −1.72e-6; 0.008118205 | confirmed |
| C1-11 | From m = 55 on, the error at t = 5 is more than 10⁴ times smaller than the largest error | Ratios: m = 50 3.26e3 (excluded), 55 1.48e4, 60 1.35e4, … 150 1.31e4 (all ≥ 1.31e4) | confirmed |
| C1-12 | For m = 45 to 150 the largest error lies between t = 1.64 and 1.73, after the peak, run above reference | t_max ∈ {1.667, 1.700, 1.727, 1.667, 1.643, 1.688, 1.667, 1.650, 1.682, 1.667, 1.654, 1.679, 1.667}; the error sign is + for all | confirmed |
| C1-13 | Largest error falls at every refinement; about halves when m doubles | Strictly decreasing over all 20 m; 60→120 ratio 2.024 | confirmed |
| C1-14 | 5.7e-2 (m = 60), 2.8e-2 (m = 120), 2.2e-2 (m = 150) | 0.05698, 0.02816, 0.02247 | confirmed |
| C1-15 | ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5 | Formula correct; −41.2554 | confirmed |
| C1-16 | h > about 0.0485 (m ≤ 103; here 10–100): h\|∂f/∂y\| exceeds Euler's limit 2 before t = 5 | h* = 2/41.2554 = 0.04848, m* = 103.14; onset exists for m ≤ 100 in the sweep, none for 110–150 | confirmed |
| C1-17 | After onset each step multiplies the inherited error by 1 + h∂f/∂y < −1 | S: \|1+z\| ≤ 1 ⇔ −2 ≤ z ≤ 0, so z < −2 gives factor < −1 | confirmed |
| C1-18 | Onset at m = 10 at t ≈ 2.92 | 2.923 (P by bisection on the reference); the J frame shows 2.92 | confirmed |
| C1-19 | For m = 10 to 45 the error at t = 5 is larger than just before the onset | \|e(5)\| > \|e(last node before onset)\| for all 8 values (e.g. m = 45: 7.1e-3 vs 8.1e-5) | confirmed |
| C1-20 | m = 50 to 100: onset from t ≈ 3.95 (m = 50) to ≈ 4.95 (m = 100) | 3.950, 4.949 | confirmed |
| C1-21 | m = 50 to 100: runs decrease steadily, and the error at t = 5 is smaller than just before the onset | Monotone; \|e(5)\| < \|e_before\| for all 7 (e.g. m = 50: 2.1e-5 vs 4.7e-5) | confirmed |
| C1-22 | m = 110 to 150: stays below 2 up to t = 5 | No onset (J and P) | confirmed |
| C1-alt | Alt text: reference peaks near 1.45 at t ≈ 0.88, decays to 0.0081; m = 10–40 zig-zags and dips below zero; y(5) = 1.777 at m = 10; shaded m = 10–100; steady from m = 50; y(5) = 0.0081182 at m = 150; −1.7e-06 and 2.2e-02, largest near t = 1.67 | As above; F frame 20 shows exactly these labels | confirmed |
| C1-link | [Julia source](eulersmethodaa.jl) and embed eulersmethodaa.gif are the Euler sweep | Files; manifest byte-identical regeneration; F titles "Euler's method …" | confirmed |
| C2-h | Case 2 heading: midpoint, same IVP, m = 12 to 150 | `eulersmethodbb.jl` l.18, 30 | confirmed |
| C2-1 | 21 values m = 12,14,16,18,20,24,28,…,60,70,80,90,100,120,150; same reference | Script l.18, l.36–51; GIF has 21 frames | confirmed |
| C2-2 | m = 12 to 24: tail zig-zags | T: alternating tail increments at each of 12, 14, 16, 18, 20, 24 | confirmed |
| C2-3 | m = 24: only the last three steps alternate (+0.069, −0.076, +0.489), y(5) ≈ 0.613 | T: …, +0.0059, +0.0692, −0.0755, +0.4889; 0.6126681 | confirmed |
| C2-4 | m = 28 to 60 turn upward before t = 5 instead of following the decay | T/P: a single minimum followed by a rise for 32–60; m = 28 the same except one dip | confirmed |
| C2-5 | m = 28: one small dip of 0.0075 in the second-to-last step | T: step 4.643→4.821 is −0.0075 | confirmed |
| C2-6 | Rise from minimum 0.35 (m = 28), 0.057 (m = 40), 0.015 (m = 60, barely visible) | 0.3501, 0.05716, 0.0150; F m = 60 shows a slight upturn | confirmed |
| C2-7 | End at y(5) ≈ 0.384, 0.0761, 0.0259 | 0.3841123, 0.0761463, 0.0259429 | confirmed |
| C2-8 | m = 40 is the first of the Example 12 runs | L lnk_13 | confirmed |
| C2-9 | m = 70 upturn only 0.0008, too small to see | 0.00076 | confirmed |
| C2-10 | From m = 80 on, runs decrease steadily after their peak | Monotone for 80, 90, 100, 120, 150 | confirmed |
| C2-11 | From m = 16 the error at t = 5 falls at every refinement, to 2.5e-4 (m = 80) and 1.8e-6 (m = 150) | 1.11, 0.945, 0.806, 0.605, 0.376, 0.127, 0.089, 0.068, 0.0548, 0.0439, 0.035, 0.0285, 0.0178, 2.02e-3, 2.52e-4, 5.4e-5, 1.86e-5, 5.14e-6, 1.82e-6 (strictly decreasing; 14→16 rises, hence "from m = 16") | confirmed |
| C2-12 | y(5) ≈ 0.0081217 at m = 150 | 0.008121739 | confirmed |
| C2-13 | m = 16 to 70: the error at t = 5 is also the largest error of the run | argmax at t = 5 for all 16–70 (not for 12, 14: t = 4.58, 4.64) | confirmed |
| C2-14 | From m = 80 on, 2.5 to 87 times smaller than the largest error | 2.49, 8.91, 20.6, 49.8, 87.4 | confirmed |
| C2-15 | Largest error lies between t = 3.19 and 3.22: 6.3e-4 (m = 80), 1.6e-4 (m = 150) | t = 3.188, 3.222, 3.200, 3.208, 3.200; 6.27e-4, 1.59e-4 | confirmed |
| C2-16 | m = 80→150: midpoint max error falls ×3.9 (vs (150/80)² ≈ 3.5); Euler's falls ×1.9 (vs 150/80 ≈ 1.9) | 3.949; 3.516; 1.890; 1.875 | confirmed |
| C2-17 | At m = 150 about 140 times smaller than Euler's 2.2e-2; errors at t = 5 about the same size | 141.4; −1.72e-6 vs +1.82e-6 | confirmed |
| C2-18 | Amplification factor 1 + z + z²/2, \|R\| ≤ 1 on the negative real axis exactly for −2 ≤ z ≤ 0; limit 2 | S: the midpoint step on y' = λy gives 1 + hλ + h²λ²/2; the solution set is [−2, 0]; min R = 1/2 | confirmed |
| C2-19 | m ≤ 103 (here 12–100) exceed 2 before t = 5, from t ≈ 2.99 (m = 12) to 4.95 (m = 100) | 2.987, 4.949 | confirmed |
| C2-20 | For each of these m the error at t = 5 is larger than just before the onset | True for all 19 values 12–100 (e.g. m = 100: 1.86e-5 vs 1.39e-5) | confirmed |
| C2-21 | m = 120 and 150 stay below 2 | No onset | confirmed |
| C2-alt | Alt text: m = 12–24 zig-zag (m = 24 last three steps); 28–60 turn upward; y(5) = 0.0761 at m = 40; shaded 12–100; steady from m = 80; y(5) = 0.0081217 at m = 150; +1.8e-06 and 1.6e-04, largest near t = 3.20 | As above; F frames 6 and 21 | confirmed |
| C2-link | [Julia source](eulersmethodbb.jl) and embed eulersmethodbb.gif are the midpoint sweep | Files; manifest byte-identical; F titles "Modified Euler (midpoint) …" | confirmed |
| Fid | Archive cases covered | Legacy module has exactly two animations (Euler, MEuler), both reproduced with the same IVP and m sequence; Examples 1–10 are static examples, not animations. Heun's method is a separate module (`Heun'sMethodMod.html`, its own Heun1 animation), so naming MEuler as the midpoint method is faithful | confirmed |

### 3. Implementation checks

### `eulersmethodaa.jl` (forward Euler)

1. **Method.** Line 28 is `ys[i+1] = ys[i] + h*f(ts[i], ys[i])`: forward Euler on a uniform grid with h = 5/m. `f` uses the real cube root, which matches Mathews' `Sign[y] Abs[y]^(1/3)` (L gr_229). The order check with the script's own `euler` routine gives max-error ratios 2.004, 2.002, 2.001, 2.000 under halving of h, which is first order (`order_aa.jl`).
2. **Numbers.** The independent Python Euler run with a DOP853 reference agrees with the script on every frame: max |Δy(5)| = 6.4e-15, max |Δ err(5)| = 6.4e-15, max relative Δ in max-error = 7.7e-12, identical argmax nodes, and onset times within 1e-4. That last difference comes from the reference-grid scan against my bisection, and every displayed value is 2 decimals. All 20 y(5) values equal the legacy-printed values at 7 d.p.

   | m | script y(5) | Python y(5) | legacy | err(5) | max \|err\| @ t | onset |
   |---|---|---|---|---|---|---|
   | 10 | 1.7774834 | 1.777483366 | 1.7774834 | +1.8e0 | 1.8e0 @ 5.00 | 2.92 |
   | 40 | −0.0174406 | −0.017440619 | −0.0174406 | −2.6e-2 | 2.2e-1 @ 4.88 | 3.68 |
   | 45 | 0.0152568 | 0.015256814 | 0.0152568 | +7.1e-3 | 7.7e-2 @ 1.67 | 3.82 |
   | 60 | 0.0081157 | 0.008115697 | 0.0081157 | −4.2e-6 | 5.7e-2 @ 1.67 | 4.19 |
   | 100 | 0.0081174 | 0.008117365 | 0.0081174 | −2.6e-6 | 3.4e-2 @ 1.65 | 4.95 |
   | 150 | 0.0081182 | 0.008118205 | 0.0081182 | −1.7e-6 | 2.2e-2 @ 1.67 | none |

   The full table is in `indep.out` and `julia_aa.tsv`.
3. **Reference.** The fixed-step RK4 with 50 000 steps gives y(5) = 0.008119920464867961. DOP853 (rtol 1e-13) gives 0.00811992046486798, mpmath `odefun` at 30 digits gives 0.00811992046486796, and Radau gives 0.008119920464867885. At the run nodes, the script's `refnodes` and DOP853 agree well enough that the error columns match to 6e-15 absolute. `fy` = −t/(3 cbrt(y)²) is the correct ∂f/∂y.
4. **Picture.** In frames 1–8 and 20 and the contact sheet, the magenta polyline passes through the computed nodes, and the red dot sits at (5, y_m). The annotation values equal the dump. The band starts at the dumped onset and spans [onset, 5]. The title function matches the code. The y-window (−0.55, 1.9) contains every computed value; the script asserts this, and the min −0.4624 and max 1.7775 are confirmed. No clamping or masking is used.

### `eulersmethodbb.jl` (modified Euler = explicit midpoint)

1. **Method.** Line 30 is `ys[i] + h*f(ts[i]+h/2, ys[i] + (h/2)*f(ts[i], ys[i]))`. This is the explicit midpoint method and is identical to Mathews' `MEuler` subroutine (L gr_42). It is not Heun's method; Heun has its own module in the archive. The order check with the script's `meuler` gives ratios 4.093, 4.046, 4.023, 4.011, which is second order. sympy confirms that the step factor on y' = λy is 1 + hλ + (hλ)²/2.
2. **Numbers.** Python vs script: max |Δy(5)| = 1.1e-15, max |Δ err(5)| = 1.1e-15, relative Δ max-error ≤ 1.3e-11, argmax nodes identical. All 21 y(5) values match the legacy `MEuleraa.gif` labels at 7 d.p., and m = 40, 100, 150 match Example 12's printed values.

   | m | script y(5) | Python y(5) | legacy | err(5) | max \|err\| @ t | onset |
   |---|---|---|---|---|---|---|
   | 12 | 0.1958729 | 0.195872927 | 0.1958729 | +1.9e-1 | 1.4e0 @ 4.58 | 2.99 |
   | 24 | 0.6126681 | 0.612668062 | 0.6126681 | +6.0e-1 | 6.0e-1 @ 5.00 | 3.25 |
   | 40 | 0.0761463 | 0.076146277 | 0.0761463 | +6.8e-2 | 6.8e-2 @ 5.00 | 3.68 |
   | 80 | 0.0083720 | 0.008371955 | 0.008372 | +2.5e-4 | 6.3e-4 @ 3.19 | 4.60 |
   | 100 | 0.0081385 | 0.008138516 | 0.0081385 | +1.9e-5 | 3.8e-4 @ 3.20 | 4.95 |
   | 150 | 0.0081217 | 0.008121739 | 0.0081217 | +1.8e-6 | 1.6e-4 @ 3.20 | none |
3. **Reference.** The RK4 reference is the same as in Case 1 and is verified as above.
4. **Picture.** In frame 6 (m = 24), frame 21 (m = 150) and the contact sheet (12, 16, 20, 28, 36, 44, 52, 60, 80, 100, 150), the curve, red endpoint, labels and band all match the dump. The window contains all values: the comment's "min 0.0081 at m = 150, max 1.4497" is confirmed. The title function matches the code.

### Legacy archive
I consulted the archive. The IVP, the method definitions and both m sequences match it, and so does every printed y(5) value, 41 animation labels plus 6 example values. The page drops no archive animation case. I found no fidelity departures.

