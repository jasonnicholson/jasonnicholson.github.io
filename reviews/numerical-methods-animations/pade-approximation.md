# Padé Approximation — animation review

Page: [`pages/numerical-methods/pade-approximation/index.qmd`](../../pages/numerical-methods/pade-approximation/index.qmd) · Scripts: `pade_animations_all.jl` · GIFs: 27

**Result:** 1 error, 0 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — Γ and Y0 cases (22–27) are built from least-squares-fitted Taylor coefficients that are wrong by up to 13%, so many of their frames are not the Padé approximants of Γ or Y0

- **Location:** `pade_animations_all.jl:176` (`return series_coeffs_fit(case.f, c, n, case.xlims)`) and `:179–229` (`series_coeffs_fit`). The cases are in table rows `:45–50`, and the page shows them in Cases 22–27 (index.qmd lines 216–250).
- **Now:** `series_coeffs_analytic` has no branch for `gamma(x)` or `bessely(0,x)`. These six cases therefore fall through to `series_coeffs_fit`, which fits a degree-8 polynomial by least squares to 29 equally spaced samples x0 + h·t, t = −14…14. The step h is 0.01, 0.02, 0.03, 0.1, 0.05 and 0.02 for cases 22–27. The fitted coefficients are taken as the Taylor coefficients, and the [L/M] systems are solved from them.
- **True:** fitting a degree-8 polynomial over a window of ±14h aliases the x⁹, x¹⁰, … terms onto the fitted coefficients. The fitted coefficients do not equal f⁽ᵏ⁾(x0)/k!. Relative errors in powers 5–8, script against exact:

  | case | a5 | a6 | a7 | a8 |
  |---|---|---|---|---|
  | 22 Γ, x0=1 | 0.07% | 0.08% | **4.5%** (−1.0405 vs −0.99600) | **5.0%** (1.0477 vs 0.99811) |
  | 23 Γ, x0=2 | **3.5%** (−2.575e−4 vs −2.670e−4) | 0.06% | **5.8%** (−3.017e−3 vs −2.853e−3) | **4.6%** |
  | 24 Γ, x0=3 | 0.02% | 0.02% | 1.9% | 2.0% |
  | 25 Y0, x0=10 | 0.2% | 0.4% | **5.5%** (4.319e−5 vs 4.570e−5) | **6.9%** (−7.258e−7 vs −7.796e−7) |
  | 26 Y0, x0=5 | 0.02% | 0.01% | **12.6%** (6.658e−7 vs 5.910e−7) | 1.1% |
  | 27 Y0, x0=2 | 0.05% | 0.04% | 3.4% | 4.1% |

  The error is truncation (aliasing), not rounding. I reran the same fit on samples exact to 50 digits and got the identical errors (`fit_source.py`). The script's use of BigFloat in the solve does not help.

  As a result, the plotted R does not match f through order L+M. The Baker residual of the script's (p, q) against the exact series is up to 5.6e−2 (case 22), 2.4e−4 (case 23), 5.3e−5 (case 24), 3.6e−6 (case 25), 1.1e−7 (case 26) and 2.4e−5 (case 27). The analytic cases have residuals of 1e−16.

  Visible consequences: a frame counts as visibly different here when the script's curve, as drawn, differs from the true Padé curve by more than 2% of the y-range at 5 or more of the 900 plotted points. That holds for 22, 14, 12, 7, 2 and 8 of the 45 frames in cases 22–27, so 65 of 270 frames. Clear examples:
  - Case 22 [6/2] (frame 43): an isolated spike at x ≈ 1.87, from a spurious pole–zero pair at 1.867. The true [6/2] has no such feature, and its only real pole in the window is at 0.002. At x = 5.2 the frame shows 17.8; the true value is 14.9.
  - Case 22 [4/4] (frame 41): R(5.2) is 8.05; the true value is 6.09.
  - Case 24 [3/5] (frame 40): the curve turns over at x ≈ 4.8 and falls to −13.3 at x = 5.2, with a numerator root at 5.08. The true [3/5] keeps following Γ, at 29.2 against Γ(5.2) = 32.6. A viewer would conclude [3/5] fails near x = 5, which is false.
  - Case 23 [2/5] (frame 31): the right-hand pole is at 4.82; the true pole is at 4.69.
  - Case 23 [0/8] (frame 37): the right-hand pole is at 4.10; the true pole is at 4.20.
  - Case 27 [4/4] (frame 41): the pole is at x = 9.06; the true pole is at 9.90.
  - Case 27 [6/2] (frame 43): the pole is at 10.96; the true pole is at 10.14.
  - Case 27 [6/1] (frame 35): the bump near x ≈ 7.5 has the wrong height. The script reaches about +0.33; the true curve turns down at about 0.

  Frames with L+M ≤ 4 are indistinguishable from the true ones in all six cases.
- **Evidence:** `julia dump_pade.jl` produced `script_values.txt`. Then `python3 -I exact_coeffs.py`, `compare_pade.py` (output in `compare_out.txt`; see the lines for cases 22–27) and `crosscheck.py`. The exact coefficients were cross-checked against `mpmath.taylor` at 50 digits and agree to 1e−40. The plotted f itself is correct: SpecialFunctions `gamma` and `bessely` agree with mpmath to 1e−16 (`fvals.jl`). The overlays are `ov_case22.png` through `ov_case27.png`, and committed frames `pade22/frame_043.png` and `pade24/frame_040.png` show the spike and the downturn.
- **Suggested fix:** compute these coefficients analytically and drop the fit.
  - Γ: use Γ⁽ᵏ⁺¹⁾ = Σⱼ C(k,j) Γ⁽ʲ⁾ ψ⁽ᵏ⁻ʲ⁾, with ψ⁽ⁱ⁾ = `polygamma(i, c)` from SpecialFunctions, then divide by k!.
  - Y0: use Y0⁽ᵏ⁾(c) = 2⁻ᵏ Σⱼ (−1)ʲ C(k,j) Y_{k−2j}(c), with Y₋ₙ = (−1)ⁿYₙ.

  Then a[k+1] = f⁽ᵏ⁾(c)/k!. Alternatively, generate the coefficients once with mpmath or TaylorSeries.jl and hard-code them. The same fit, in Float64, exists in `laurent-series/laurent_animations_all.jl`. Its error is the same truncation error, so it needs the same fix.

- **Independent check:** confirmed with correction. Checker: coefficients off by 1.9–12.6% (worst case 26, a7); re-running the fit in high precision gives the same errors (fit-method error, not rounding). Count differs slightly: the checker found 70 of 270 frames visibly wrong (reviewer: 65), almost all with m+n ≥ 5; case 26 is only mildly affected (2 frames).

### F2 — Minor — Implementation — When the Padé system is singular and inconsistent, `pinv` returns a least-squares denominator, so a few frames show a curve that is not a Padé approximant of any kind

- **Location:** `pade_animations_all.jl:255–259` (`qtail = try B \ rhs catch pinv(B) * rhs end`).
- **Now:** for even or odd functions, and when f(x0) = 0, many entries of the Padé table lie in degenerate blocks. In those entries the Toeplitz matrix B is exactly singular. This affects 176 of the 1,614 frames, in cases 05, 07–09, 12 and 14–21.
  - Where B·q = rhs is consistent, the `pinv` solution gives the same rational function as the reduced (Frobenius) Padé form. Cases 08 and 09 reach that form through LU on the 1e−17 noise in `sin(k·π/2)`, `cos(k·π/2)`. Both routes are fine, and the difference is below 1e−14.
  - Where the system is inconsistent, `pinv` returns the minimum-norm least-squares q. The resulting P/Q matches neither the [L/M] order conditions (no such approximant exists) nor the reduced block approximant.
- **True:** comparing against the reduced Padé from exact coefficients, the differences are visible only in these frames:
  - Case 15 cosh [1/3] (frame 12): the frame shows 1/(1 − 0.41667x²), with poles at ±1.549. The reduced approximant is [0/2] = 1/(1 − x²/2), with poles at ±√2 = ±1.414.
  - Case 15 [3/3] (frame 25) and [1/7] (frame 38): poles shifted slightly.
  - Case 12 tan [2/3] (frame 18): poles at ±1.715; the reduced form has them at ±√3 = ±1.732.
  - Case 16 [2/5] (frame 31) and [2/7] (frame 48), case 17 [4/3] (frame 33), and case 20 [1/3] (frame 12) and [5/3] (frame 42): differences of 1–7% of the y-range.

  These are small, and some frame has to stand in for an [L/M] that does not exist. But in these frames the legend labels as "Padé [L/M]" a curve that is neither the [L/M] approximant nor the one it degenerates to.
- **Evidence:** in `compare_out.txt`, the lines flagged `solve=PINV exact_nonsing=False … <-- differs`. Overlays are in `ov_case12.png`, `ov_case15.png`, `ov_case16.png`, `ov_case17.png` and `ov_case20.png`. The script's case 15 [1/3] values are P = [1, 0] and Q = [1, 0, −0.41667, 0] (`script_values.txt`). The committed frame `pade15/frame_012.png` shows the poles at about ±1.55.
- **Suggested fix:** when B is singular, compute the Frobenius solution: take a null vector of the M×(M+1) system, form P = trunc(Q·f), and cancel common factors. Simpler: when the system is inconsistent, plot the block's top-left approximant and say so in the legend, e.g. "[1/3] = [0/2] (degenerate)".

- **Independent check:** not run (minor finding, unverified).

### F3 — Minor — Page match — The Description says R always matches f through order m+n, but about 170 frames show degenerate table entries that cannot

- **Location:** index.qmd line 20: "chooses coefficients so the Taylor expansion of $R_{m,n}$ about $x_0$ matches the target function through order $m+n$."
- **Now:** the sentence is stated for every R, and the animations step through every [m/n] with m+n ≤ 10 (or ≤ 8). For odd or even functions, and when f(x0) = 0, many frames show a reduced approximant that matches to a lower order and repeats the previous frame. Examples:
  - Every [0/n] frame in cases 05, 07, 08, 12, 16, 17 and 19 shows R ≡ 0.
  - Case 12 tan [1/1] and [2/1] both show R = x, which matches tan only through order 2.
  - Case 15 cosh [1/1] and [0/0] both show R = 1.
- **True:** in these blocks no [m/n] with Q(x0) = 1 attains order m+n. By my count, 85 frames with m ≥ 1 in cases 12 and 14–21 have a Baker residual of order 1e−3 or larger, against 1e−16 for nondegenerate frames. In addition there are the 66 [0/n] frames for functions with f(x0) = 0, and the degenerate sin and cos frames of cases 08 and 09.
- **Evidence:** `compare_out.txt` (`exact_nonsing=False` lines, `BakerRes`) and the contact sheet `committed/pade12/sheet.png`, where [1/1] and [2/1] are identical lines.
- **Suggested fix:** add one sentence after line 20, for example: "For even or odd functions (and when f(x0)=0) the Padé table has repeated blocks: some [m/n] coincide with a lower-order neighbour and match only to a lower order, so consecutive frames can look identical."

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `pade_animations_all.jl` | yes | 76.9 | 27 GIFs |

Committed GIFs byte-identical to their regenerated output: **27 of 27**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Often, Padé approximant's can converge when Taylor Series does not" | Case 01 (√x about 1): at x = 10.5, the error of [10/0] is 4.9e7 and the error of [5/5] is 5.8e−3. Case 07: at x = 1.5, [10/0] error 3.3 and [5/5] error 4.5e−7 (`taylor_vs_pade.py`). | confirmed |
| 2 | 12 | "Rationale functions can have singularities/vertical-asymptotes and horizontal asymptotes. Polynomials do not…" | Standard (non-constant polynomials). The frames show Padé poles, e.g. case 12. | confirmed |
| 3 | 17 | $R_{m,n}=P_m/Q_n$, $Q_n(x_0)=1$ | Script: `q = [1.0; qtail]` in z = x−x0, so Q(x0) = 1. Numerator degree m and denominator degree n, as in legend "[m/n]". | confirmed |
| 4 | 20 | "matches the target function through order $m+n$" | Every nondegenerate pair in the 21 analytic cases has a Baker residual ≤ 3e−16, and 1,420 pairs agree with `mpmath.pade`. Fails for the degenerate entries and for cases 22–27. | wrong in part (→ F3, F1) |
| 5 | 22 | Padé "can represent poles and often stay accurate on larger intervals" than Taylor of the same total order | Line-1 numbers; also atan at x = 2: [10/0] error 43, [5/5] error 0.016. | confirmed |
| 6 | 24 | Total orders < 20 "fail at times for MATLAB's symbolic `pade`"; chebfun `padeapprox` "also struggles" | Claim about external tools; no MATLAB or chebfun here. | could not determine (no MATLAB/chebfun) |
| 7 | 26 | "see the resources section below" | No section named "resources"; the "Outside Links" section (line 28) is below. | confirmed in substance (section is named differently) |
| 8 | 86 | "Each animation shows one Padé order per frame for a fixed center $x_0$, overlaid on the target function." | `render_case`: one (m, n) per frame, every m+n ≤ max_total, ordered by total and then m, giving 66 frames (max_total 10) or 45 (max_total 8). Matches `nframes`. Magenta f with a red dot at (x0, f(x0)). | confirmed |
| 9 | 88 | "[Julia source for all cases](pade_animations_all.jl)" | The file exists and produces all 27 GIFs byte-identically (manifest). | confirmed |
| 10 | 90–94 | Case 01: √x, x0 = 1, x∈[0,10.5]; alt text same; pade01.gif | Script row :24 `(sqrt, 1.0, (0,10.5))`. GIF title "Padé Case 01: f(x) = sqrt(x), x0 = 1.0". Coefficients exact; Padé matches the reference to 4e−14 of the y-range. | confirmed |
| 11 | 96–100 | Case 02: √x, x0 = 4, [0,10.5] | Row :25; title "…sqrt(x), x0 = 4.0"; difference from reference 2e−14. | confirmed |
| 12 | 102–106 | Case 03: √x, x0 = 5, [0,10.5] | Row :26; title "x0 = 5.0"; difference 4e−14. | confirmed |
| 13 | 108–112 | Case 04: 1/√(1−x), x0 = 0, [−1.5,1.5]; alt "one over square root of one minus x centered at zero" | Row :27; title "1/sqrt(1-x), x0 = 0.0"; coefficients C(2k,k)/4ᵏ exact; difference 2e−10. | confirmed |
| 14 | 114–118 | Case 05: log x, x0 = 1, [−0.5,4.1] | Row :28; title "log(x), x0 = 1.0"; exact; [0/n] frames show 0 (degenerate, see F3). | confirmed |
| 15 | 120–124 | Case 06: log x, x0 = 2, [−0.5,4.1] | Row :29; title "x0 = 2.0"; difference 1e−11. | confirmed |
| 16 | 126–130 | Case 07: log(1+x), x0 = 0, [−1.5,1.5]; alt "centered at zero" | Row :30; title "log(1+x), x0 = 0.0"; exact. | confirmed |
| 17 | 132–136 | Case 08: sin x, x0 = 0, [−3π,3π] | Row :31 `(-3pi,3pi)`; title "sin(x), x0 = 0.0"; equals reduced Padé to 3e−15. | confirmed |
| 18 | 138–142 | Case 09: cos x, x0 = 0, [−3π,3π] | Row :32; title "cos(x), x0 = 0.0"; difference 5e−15. | confirmed |
| 19 | 144–148 | Case 10: sin x, x0 = π/4, [−7π/4,9π/4]; alt "centered at pi over 4" | Row :33; title "x0 = 0.7854"; difference 3e−14. | confirmed |
| 20 | 150–154 | Case 11: cos x, x0 = π/3, [−5π/3,7π/3]; alt "pi over 3" | Row :34; title "x0 = 1.0472"; difference 2e−14. | confirmed |
| 21 | 156–160 | Case 12: tan x, x0 = 0, [−π,π] | Row :35 (max total 8); title "tan(x), x0 = 0.0"; coefficients 1, 1/3, 2/15, 17/315 exact; frame 18 [2/3] off slightly (F2). | confirmed (F2 minor) |
| 22 | 162–166 | Case 13: eˣ, x0 = 0, [−2,3] | Row :36; title "exp(x), x0 = 0.0"; difference 7e−14. | confirmed |
| 23 | 168–172 | Case 14: e⁻ˣcos x, x0 = 0, [−2,4] | Row :37; title "exp(-x)*cos(x), x0 = 0.0"; Re((−1+i)ᵏ)/k! exact; difference 2e−14. | confirmed |
| 24 | 174–178 | Case 15: cosh x, x0 = 0, [−4,4] | Row :38; title "cosh(x), x0 = 0.0"; frames 12, 25 and 38 are not Padé approximants (F2). | confirmed (F2) |
| 25 | 180–184 | Case 16: arctan x, x0 = 0, [−2,2] | Row :39; title "atan(x), x0 = 0.0"; frames 31 and 48 off by up to 7% of the y-range (F2). | confirmed (F2 minor) |
| 26 | 186–190 | Case 17: arcsin x, x0 = 0, [−1.5,1.5] | Row :40 (max total 8); title "asin(x), x0 = 0.0"; frame 33 pole shift near the edge (F2). | confirmed (F2 minor) |
| 27 | 192–196 | Case 18: J0, x0 = 0, [−10.2,10.2] | Row :41; title "besselj(0,x), x0 = 0.0"; exact series; difference ≤ 4e−3 of the y-range. | confirmed |
| 28 | 198–202 | Case 19: J1, x0 = 0, [−10.2,10.2] | Row :42; title "besselj(1,x)"; difference ≤ 2e−3. | confirmed |
| 29 | 204–208 | Case 20: (1/√(2π))e^{−x²/2}, x0 = 0, [−3,3]; alt "normal density" | Row :43; title "normal_pdf(x), x0 = 0.0"; exact; frames 12 and 42 slightly off (F2). | confirmed (F2 minor) |
| 30 | 210–214 | Case 21: ½+½erf(x/√2), x0 = 0, [−3,3]; alt "normal CDF" | Row :44; title "normal_cdf(x), x0 = 0.0"; exact; difference ≤ 2e−3. | confirmed |
| 31 | 216–220 | Case 22: Γ(x), x0 = 1, [−0.2,5.2]; alt "Gamma(x) centered at one" | Row :45 (max total 8); title "gamma(x), x0 = 1.0". Parameters agree, but 22 of 45 frames are not the Padé approximants of Γ. | parameters confirmed; content wrong (→ F1) |
| 32 | 222–226 | Case 23: Γ(x), x0 = 2, [−0.2,5.2] | Row :46; title "x0 = 2.0"; 14 of 45 frames visibly off. | parameters confirmed; content wrong (→ F1) |
| 33 | 228–232 | Case 24: Γ(x), x0 = 3, [−0.2,5.2] | Row :47 (y-limits up to 45); title "x0 = 3.0"; 12 of 45 frames off, e.g. [3/5]. | parameters confirmed; content wrong (→ F1) |
| 34 | 234–238 | Case 25: Y0, x0 = 10, [0,22] | Row :48; title "bessely(0,x), x0 = 10.0"; 7 of 45 frames off. | parameters confirmed; content wrong (→ F1) |
| 35 | 240–244 | Case 26: Y0, x0 = 5, [0,22] | Row :49; title "x0 = 5.0"; 2 of 45 frames off ([6/2], [8/0]), only slightly. | parameters confirmed; content slightly wrong (→ F1) |
| 36 | 246–250 | Case 27: Y0, x0 = 2, [0,22] | Row :50; title "x0 = 2.0"; 8 of 45 frames off ([4/4] pole at 9.06 vs 9.90). | parameters confirmed; content wrong (→ F1) |
| 37 | 92–248 | Each case's "[Julia source]" link → pade_animations_all.jl, and the embed pade NN.gif sits under Case NN | The manifest maps each pade NN.gif to this script. The case number in each GIF title equals its heading number (titles_1–3.png). | confirmed |

## Implementation checks

### pade_animations_all.jl
- **Method:** this is the standard linearised Padé construction. In z = x − x0, with q0 = 1, it solves the M×M Toeplitz system Σⱼ qⱼ a_{k−j} = 0 for k = L+1…L+M (lines 244–259), then sets pₖ = Σ_{j≤min(k,M)} qⱼ a_{k−j} for k ≤ L (lines 262–269). This is the Padé approximant that the Description's formula defines. The frames show every [m/n] with m+n ≤ max_total, ordered by total order and then by increasing numerator degree (`order_pairs`, lines 274–283). That gives 66 frames for max_total 10 (19 cases) and 45 for max_total 8 (cases 12, 17 and 22–27), matching the extracted `nframes`. The last frame is always the Taylor polynomial [N/0]. Singular systems fall back to `pinv`; see F2.
- **Numbers:**
  - *Taylor coefficients:* for the 21 analytic cases, the script's coefficients agree with the exact ones (sympy) to ≤ 3.3e−15 relative error. The worst is case 11, a10, from π/3 rounding. Cases 08 and 09 carry ≤ 6e−17 of noise where the exact coefficient is 0. For cases 22–27 the coefficients come from the fit and are off by up to 12.6%; see the F1 table. For example, the case 22 a0..a8 are 1.0000000000048, −0.57721566024, 0.98905598, −0.90748244, 0.98173373, −0.98135403, 0.99231513, −1.04050332, 1.04765056. The exact values are 1, −0.5772156649, 0.9890559953, −0.9074790761, 0.9817280868, −0.9819950689, 0.9931491146, −0.9960017604, 0.9981056938.
  - *Padé:* my own 60-digit solve agrees with `mpmath.pade` on all 1,420 nonsingular pairs, excluding mpmath's own [0/0] quirk. For all nonsingular pairs in the 21 analytic cases, the script's curve matches the reference to ≤ 2e−10 of the y-range, and its Baker residual is ≤ 3e−16.
  - *Singular pairs:* 176 frames. They agree with the reduced (Frobenius) form except for the 9 frames in F2.
- **Reference values:** the "true" curve is drawn from SpecialFunctions or Base functions. Spot values agree with mpmath to about 1e−16: Y0(10) = 0.0556711672835994, Y0(0.3) = −0.80727357780452, Γ(4.5) = 11.6317283965674, Γ(−0.1) = −10.6862870211932, J1(7.3), J0(9.1), Φ(1.2) = 0.88493032977829 (`fvals.jl`). Domain errors (log or √ of negatives, 1/√(1−x) for x > 1) are caught and become NaN, so nothing false is drawn.
- **Picture:**
  - I looked at the contact sheets for pade01 and pade12. I read the title and legend strips of the last frame of all 27 GIFs (`titles_1–3.png`): every title shows the right function label and x0 (π/4 → 0.7854, π/3 → 1.0472), and every legend shows "[N/0]" with N = max_total.
  - Full frames checked: pade15 frame 12, pade22 frame 43 and pade24 frame 40.
  - The script's R is drawn in z = x − x0 with the right center, and the red dot sits at (x0, f(x0)). Values are clamped to the y-limits and set to NaN when |Q| < 1e−8. Clamping draws out-of-range parts along the frame edge, and poles appear as near-vertical jumps between the two edges. That is consistent with the authoring brief and reads as "off-scale". For example, √x [0/3] is negative beyond its pole at x ≈ 2.5 (−1 at x = 3, about −0.004 at x = 10.5) and is drawn along the bottom edge at y = 0. No case's conclusion depends on a clamped value.
  - With the exceptions in F1 and F2, the plotted approximants match my independent reference on the script's 900-point grid.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/pade-approximation/`](evidence/pade-approximation/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
