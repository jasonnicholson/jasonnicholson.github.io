# Euler's Method for ODE's — animation review

Page: [`pages/numerical-methods/eulers-method-for-odes/index.qmd`](../../pages/numerical-methods/eulers-method-for-odes/index.qmd) · Scripts: `eulersmethodaa.jl`, `eulersmethodbb.jl` · GIFs: 2

**Result:** 1 error, 1 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Heun does not end closer to the reference at t = 5; it ends about 9.5× farther away than Euler

- **Location:** index.qmd lines 48–49: "The predictor-corrector slope average reduces drift and stays closer to the dashed RK4 reference trajectory at the right endpoint."
- **Now:** The page says Modified Euler ends closer to the reference than forward Euler at t = 5.
- **True:** At t = 5:
  - Heun: y_40 = 0.250635 against the true y(5) = 0.008120, an error of +0.2425.
  - Forward Euler: y_40 = −0.017441, an error of −0.0256.

  Heun is about 9.5 times farther off. The final frame of `eulersmethodbb.gif` shows this plainly: the magenta curve climbs to about 0.25 while the dashed reference stays near 0.

  Heun tracks the reference closely up to t = 3.875, where its maximum |error| is 0.0071 against 0.0863 for Euler. So "reduces drift" holds on that range. After that Heun's error grows: 0.0106 at t = 4, 0.127 at t = 4.25, 0.175 at t = 4.375, and 0.2425 at t = 5. The cause is the step size. Along the true solution, h·∂f/∂y = −0.125·t/(3 y^{2/3}) falls below −2 at t ≈ 3.68 and reaches −5.16 at t = 5. Heun's real-axis stability interval is [−2, 0], so the method is unstable there.
- **Evidence:**
  - `reviewer/indep.py` (python3) is an independent Euler/Heun implementation with a Radau reference (rtol 1e-12) and an mpmath `odefun` reference. Its table gives Heun errors of 0.00619 (t = 3.875), 0.01064 (4.0), 0.12703 (4.25) and 0.24252 (5.0). Euler's error at 5.0 is −0.02556, and the h·df/dy column is −2.123 at t = 3.75.
  - `reviewer/extra.py`: "h*df/dy = -2 first at t = 3.6805".
  - The script's own printout agrees: "Final y(5) = 0.2506349857845535", "Reference y(5) = 0.008119920464867961".
- **Suggested fix:** Replace the paragraph with something like: "Averaging the two endpoint slopes keeps Heun on the reference curve over the hump (maximum error ≈ 0.007, against ≈ 0.086 for Euler). Once the solution flattens near y ≈ 0, however, ∂f/∂y = −t/(3y^{2/3}) becomes large and h·∂f/∂y < −2 for t > 3.7. With h = 0.125, Heun is then outside its stability region, its iterates break away from the reference, and it ends at y_40 ≈ 0.251 against the true y(5) ≈ 0.00812."

  Alternatively, use a smaller step. Comparing endpoint values is a poor test in either case. Euler's error at t = 5 is the smaller of the two even at h = 1/16 (−3.2e-6 against 6.9e-4) and at h = 1/32 (−1.6e-6 against 2.9e-6). If the page wants to show that Heun is more accurate, it should compare the maximum error over [0, 5] (h = 1/16: Euler 0.042, Heun 0.0013) rather than the value at the endpoint.

- **Independent check:** confirmed. Checker: Heun ends at 0.2506 vs true 0.00812 (Euler error −0.0256); both methods go unstable past t≈3.7 (h·J < −2). Nuance: Heun does track the reference much better than Euler on [0, ~4] — only the endpoint claim is false. The RK4 reference matches a 30-digit mpmath solution (y(5)=0.0081199204648680).

### F2 — Misleading — Page match — Euler does not "drift low near t=5"; it runs high over the hump and then goes unstable, ending in a spike and a negative value

- **Location:** index.qmd lines 39–40: "Forward Euler accumulates first-order global error and drifts low near $t=5$ relative to the dashed RK4 reference trajectory."
- **Now:** The page describes a gradual accumulated drift below the reference toward t = 5.
- **True:** Forward Euler behaves as follows:
  - **0 < t ≤ 2.875:** Euler is above the reference throughout. Its error reaches +0.0863 at t = 1.75, and its peak is 1.508 against the true 1.450.
  - **t = 3 to 3.375:** Euler is below the reference by at most 0.012.
  - **t = 3.375 to 4.5:** Euler stays within 0.0025 of the reference.
  - **t > 4.5:** Euler oscillates unstably (h·∂f/∂y < −2 for t > 3.68). The values are y_38 = −0.0071, y_39 = +0.2320 (the true value is 0.00878, so this is 26 times too large) and y_40 = −0.0174.

  The true solution stays positive on [0, 5], with minimum 0.00812 at t = 5. Being "low at t = 5" is only the last tooth of a sawtooth. The prominent feature in frames 40–41, a spike to 0.23 at t = 4.875, contradicts "drifts low".

  The t = 5 discrepancy is also not first-order accumulated error. Halving the step does not halve it. The error at t = 5 is +0.714, −0.0256 and −3.2e-6 for h = 0.25, 0.125 and 0.0625. First-order behaviour does hold where the solution is smooth and the method is stable: the error at t = 2 is 0.1708, 0.0812, 0.0395, 0.0195 and 0.0097 as h halves from 0.25 to 0.015625.
- **Evidence:**
  - `reviewer/indep.py`: the per-step table (Eerr column) and the convergence table.
  - `reviewer/inst_aa.jl` (an instrumented copy of the script) prints the script's own iterates. They match the independent iterates to 1.1e-14 (`reviewer/cmp.py`).
  - Frames `committed/eulersmethodaa/frame_040.png` (y_39 at about 0.23) and `frame_041.png` (y_40 just below 0) show the same behaviour.
- **Suggested fix:** Replace with something like: "Forward Euler overshoots the hump, with a maximum error of about 0.086 near t ≈ 1.75. This is the first-order global error, which halves when h is halved. Near y ≈ 0 the step h = 0.125 makes h·∂f/∂y < −2 for t > 3.7, so Euler becomes unstable. Its iterates oscillate, jumping to y_39 ≈ 0.23 and then to y_40 ≈ −0.017, although the true solution stays positive (y(5) ≈ 0.00812)."

- **Independent check:** confirmed with correction. Checker: Euler runs high over 0<t≤2.875 (57% of the interval), and also goes negative already at t=4.75 (−0.007), not only at the endpoint.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `eulersmethodaa.jl` | yes | 4.3 | eulersmethodaa.gif |
| `eulersmethodbb.jl` | yes | 4.4 | eulersmethodbb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12–14 | Euler "advances the solution by following the local tangent at each grid point" | Each drawn segment's slope minus f(t_k, y_k) is at most 8.9e-16 (`reviewer/inst_aa.jl`) | confirmed |
| 2 | 17 | $y_{n+1} = y_n + h f(t_n,y_n)$, $t_{n+1}=t_n+h$ | `eulersmethodaa.jl:42`; grid `range(0,5,length=41)` | confirmed |
| 3 | 20 | "local truncation error $O(h^2)$" | One step from (0,1) against mpmath: error ratios 4.07, 4.04, 4.02, 4.01 as h halves (`reviewer/extra.py`) | confirmed |
| 4 | 20–21 | "global error $O(h)$, so reducing the step size improves accuracy linearly" | Error at t = 2: 0.1708, 0.0812, 0.0395, 0.0195, 0.0097, … (ratios about 2.05) (`reviewer/indep.py`) | confirmed (smooth, stable region) |
| 5 | 21–22 | "modified Euler (Heun) predictor-corrector method averages endpoint slopes" | `eulersmethodbb.jl:42–45`: Euler predictor, then average of f at (t_k, y_k) and (t_{k+1}, y_pred). Segment slope minus (k1+k2)/2 is at most 6.9e-15 | confirmed |
| 6 | 22–23 | Heun "improves global accuracy to $O(h^2)$" | Error at t = 2: 3.29e-3, 6.65e-4, 1.48e-4, 3.48e-5, 8.43e-6, … (ratios 4.9, 4.5, 4.25, 4.13, 4.06, 4.03). One-step error ratio about 8 | confirmed |
| 7 | 28 | IVP $y' = 1 - t\sqrt[3]{y}$, $y(0)=1$ on $0 \le t \le 5$ | Both scripts: line 8 `f`, lines 29–30, line 38 | confirmed |
| 8 | 28–29 | "$n=41$ point setup ($h=0.125$)" | `n_pts = 41`, h = 5/40 = 0.125 (script prints h=0.125) | confirmed |
| 9 | 29 | "Each frame adds one new computed point and segment" | 41 frames. Frame 1 shows y_0 only; frame k adds the segment to y_{k−1} and moves the marker | confirmed |
| 10 | 30–31 | "dashed black curve is a … reference trajectory computed with fixed-step RK4 at $h=10^{-4}$" | Scripts lines 10–27, 34 and 63/66. Black dashed curve with legend "Reference (RK4 h=1e-4)" in frames | confirmed |
| 11 | 30 | Reference is "high-accuracy" | Script RK4 against Radau: max difference 1.6e-13 (`reviewer/refdump.jl`, `reviewer/refcmp.py`). y(5) is 0.008119920464867961 against mpmath 0.00811992046486796 | confirmed |
| 12 | 37 | Case 1 heading: Forward Euler, same IVP, n=41 | `eulersmethodaa.jl`; frame title "Euler Method: y' = 1 - t*cbrt(y), y(0)=1, n=41" | confirmed |
| 13 | 39 | "Forward Euler accumulates first-order global error" | True over the hump (#4). The visible t ≥ 4.5 error is an instability that does not scale with h | misleading (→ F2) |
| 14 | 39–40 | "drifts low near $t=5$ relative to the dashed RK4 reference" | Euler is high by up to 0.086 on the hump, then oscillates: y_39 = 0.232, y_40 = −0.0174 | wrong as a description (→ F2) |
| 15 | 42 | Case 1 link `eulersmethodaa.jl` | The file is forward Euler with the heading's parameters | confirmed |
| 16 | 44 | Embed `eulersmethodaa.gif`; alt text "Forward Euler … y(0)=1 over 0 <= t <= 5 using 41 points" | Manifest: produced by aa.jl, byte-identical, 41 frames; parameters match | confirmed |
| 17 | 46 | Case 2 heading: "Modified Euler (Heun), same IVP and grid" | `eulersmethodbb.jl`: same f, interval, y0 and n_pts = 41 | confirmed |
| 18 | 48 | "The predictor-corrector slope average reduces drift" | Over 0 ≤ t ≤ 3.875: Heun max \|err\| 0.0071 against Euler 0.0863. Over t ≥ 4.25 Heun's error (0.13–0.24) far exceeds Euler's on most steps | confirmed only for t ≲ 4 (→ F1) |
| 19 | 48–49 | "stays closer to the dashed RK4 reference trajectory at the right endpoint" | At t = 5: Heun err +0.2425, Euler err −0.0256 | wrong (→ F1) |
| 20 | 51 | Case 2 link `eulersmethodbb.jl` | The file is Heun with the heading's parameters | confirmed |
| 21 | 53 | Embed `eulersmethodbb.gif`; alt text "Modified Euler … using 41 points" | Manifest: produced by bb.jl, byte-identical, 41 frames | confirmed |

The legacy archive note (lines 33–35) is out of scope (history and attribution). The Planned sections and the Legacy Inventory section are also out of scope.

## Implementation checks

### eulersmethodaa.jl
- **Method:** Forward (explicit) Euler, `ys[i+1] = ys[i] + h*f(ts[i], ys[i])` (line 42), on a uniform 41-point grid with h = 0.125. This is the method the page names.
- **Numbers:** I instrumented a copy (`reviewer/inst_aa.jl`) to dump all 41 iterates and compared them with the independent numpy implementation in `reviewer/indep.py` (`reviewer/cmp.py`). The maximum difference is 1.06e-14. Selected values, script against independent against true solution:

  | Point | Script | Independent | True |
  |---|---|---|---|
  | y_8 (t = 1) | 1.507825 | 1.507825 | 1.442168 |
  | y_16 (t = 2) | 0.940769 | 0.940769 | 0.859589 |
  | y_24 (t = 3) | 0.082145 | 0.082145 | 0.089832 |
  | y_32 (t = 4) | 0.016041 | 0.016041 | 0.016236 |
  | y_38 | −0.007095 | −0.007095 | — |
  | y_39 | 0.231996 | 0.231996 | — |
  | y_40 (t = 5) | −0.0174406 | −0.017441 | 0.0081199 |

  First-order convergence holds where the solution is smooth (claim ledger #4).
- **Reference values:** The RK4 routine (lines 10–27) has the classical coefficients. Its output on the h = 1e-4 grid matches scipy Radau (rtol 1e-12, atol 1e-14) to 1.6e-13. Radau agrees with DOP853 to 2.9e-13, and both agree with mpmath `odefun` (30 digits) at t = 1, …, 5: for example y(5) = 0.00811992046486796. sympy substitution does not apply because the page claims no closed-form solution and none is plotted. The reference is accurate far beyond what the plot needs. The true solution stays positive, since y' = 1 > 0 at y = 0, so `cbrt` never sees a negative argument on the reference. Euler's negative iterates use the real cube root (Julia `cbrt`), consistent with numpy.
- **Picture:** I looked at the contact sheet (frames 1, 5, 9, …, 41) and the full-size frames 40 and 41.
  - Each segment from (t_k, y_k) to (t_{k+1}, y_{k+1}) has slope f(t_k, y_k) to 8.9e-16, so the polyline is the tangent-following path the Description claims.
  - The red marker sits at the newest point, and its legend label `y_$(frame-1)` has the correct index (frame 41 shows y_40).
  - The title matches the code's f, y0 and n.
  - The y-limits (−0.1, 1.55) contain every iterate (range −0.01744 to 1.50826) and the whole reference (0.00812 to 1.44977). There is no clamping or masking.
  - The spike at t = 4.875 and the negative last value are faithfully drawn. They are what the page text misdescribes (F2).

### eulersmethodbb.jl
- **Method:** Heun's method, which Mathews calls "modified Euler". It is an explicit Euler predictor `y_pred = y_k + h k1`, then `k2 = f(t_{k+1}, y_pred)`, then `y_{k+1} = y_k + (h/2)(k1 + k2)` (lines 42–45). This is the trapezoidal-corrector variant that the page describes ("averages endpoint slopes"), not the midpoint method that some texts call modified Euler.
- **Numbers:** I instrumented a copy (`reviewer/inst_bb.jl`). Its iterates match the independent Heun in `reviewer/indep.py` to 8.9e-16. Selected values, script against independent against true solution:

  | Point | Script | Independent | True |
  |---|---|---|---|
  | y_8 | 1.441436 | 1.441436 | 1.442168 |
  | y_16 | 0.858924 | 0.858924 | 0.859589 |
  | y_24 | 0.095464 | 0.095464 | 0.089832 |
  | y_32 | 0.026876 | 0.026876 | 0.016236 |
  | y_34 | 0.140444 | 0.140444 | 0.013416 |
  | y_40 | 0.2506350 | 0.250635 | 0.0081199 |

  Second-order convergence holds at t = 2, with error ratios tending to 4 (claim ledger #6). Departure from the reference begins near t ≈ 4, consistent with h·∂f/∂y < −2 for t > 3.68 (`reviewer/extra.py`).
- **Reference values:** The reference is the same RK4 routine and grid as in aa.jl, so the same verification applies (accurate to about 1e-13).
- **Picture:** I looked at the contact sheet (frames 1, 5, …, 41) and the full-size frame 41.
  - Each segment's slope equals (k1 + k2)/2 to 6.9e-15.
  - The marker and its label index are correct, and the title matches the code.
  - All iterates (0.0242 to 1.4491) are inside the y-limits, with no clamping.
  - The final frame clearly shows Heun leaving the reference after t ≈ 4 and ending at about 0.25. That is the opposite of the page's claim (F1).

Re-run: from `$WORK/eulers-method-for-odes/reviewer/`, run `julia inst_aa.jl; julia inst_bb.jl; julia refdump.jl; /usr/bin/python3 indep.py; /usr/bin/python3 extra.py; /usr/bin/python3 cmp.py; /usr/bin/python3 refcmp.py`.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/eulers-method-for-odes/`](evidence/eulers-method-for-odes/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
