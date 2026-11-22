# Fix record: pade-approximation

Scratch folder with every script and output named below:
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/pade-approximation/fix/` (written `fix/` below).
Independent reference throughout: Taylor coefficients from sympy (`fix/exact_coeffs.py`, the round-1 reviewer's script, 40 digits) and a 60-digit mpmath Padé (Frobenius null-vector form where the Toeplitz block is singular) in `fix/compare_new.py`.
Old frames: `fix/old/dump_pade.jl` (reviewer's dump of the HEAD script) → `fix/old/script_values.txt`. New frames: `fix/dump_new.jl` (loads the fixed repo script without rendering) → `fix/script_values_new.txt`.

## Findings

### F1 — Error — fixed
- Reproduced: `python3 -I compare_new.py old/script_values_conv.txt` (`fix/compare_old.out`). Max relative coefficient error of the old fit, cases 22–27: 5.0e-2, 5.8e-2, 2.0e-2, 6.9e-2, 1.3e-1, 4.1e-2 (matches the finding's table maxima 5.0%, 5.8%, 2.0%, 6.9%, 12.6%, 4.1%). Frames differing from the true Padé by >2% of the y-range at ≥5 of 900 points: 21, 14, 10, 6, 1, 7 (59 of 270; reviewer 65, checker 70 — same picture, slightly different counting). Spot values (`python3 -I spot_values.py`): case 22 [6/2] old R(5.2) = 17.84 with pole 1.870 / zero 1.867; [4/4] old R(5.2) = 8.05; case 24 [3/5] old R(5.2) = −13.32 with zero 5.08; case 23 [2/5] pole 4.822, [0/8] pole 4.100; case 27 [4/4] pole 9.059, [6/2] pole 10.957, [6/1] R(7.5) = 0.337.
- Change: `pade_animations_all.jl` — added the exact coefficient routine `taylor_coeffs_exact` (lines 71–211, with `_bernoulli_numbers`, `_hurwitz_zeta`, `_bessel_big`); `series_coeffs_analytic` now returns `taylor_coeffs_exact(:gamma, c, n)` and `taylor_coeffs_exact(:bessely, c, n; nu=0)` for Γ and Y0 (lines 321–324); `series_coeffs_fit` (old lines 179–229) deleted; the fallback is now `error("no Taylor coefficients for …")` (line 327) so no case can silently fall back to a fit. No package added (SpecialFunctions, LinearAlgebra already loaded).
- Check: `julia dump_new.jl && python3 -I compare_new.py` (`fix/compare_new.out`): cases 22–27 coefficient max relative error 5.2e-17, 6.3e-17, 9.3e-17, 9.8e-17, 9.2e-17, 5.8e-17; visibly different frames 0 in every case (0 of 1614 overall); worst max|R−Rref|/y-range 3.3e-11 (case 22 [3/5]); Baker residual of the nonsingular frames ≤ 4.7e-16. New spot values: case 22 [6/2] R(5.2) = 14.86, only real pole in window 0.002, no pole–zero pair at 1.87; [4/4] R(5.2) = 6.09; case 24 [3/5] R(5.2) = 29.22, no numerator root in window; case 23 [2/5] pole 4.689, [0/8] pole 4.204; case 27 [4/4] pole 9.896, [6/2] pole 10.138, [6/1] R(7.5) = −0.073. All match the finding's "true" values (14.9, 6.09, 29.2, 4.69, 4.20, 9.90, 10.14, "turns down at about 0"). Frames viewed: pade22 frame 43, pade24 frame 40, pade27 contact sheet ([4/4] pole at ≈9.9).

### F2 — Minor — fixed
- Reproduced: `LIST=1 ONLY="12 15 16 17 20" python3 -I compare_new.py old/script_values_conv.txt` (`fix/compare_old_F2list.out`): old singular-system frames off by >2% of the y-range at ≥5 points: case 12 [2/3] (frame 18), case 15 [1/3] (12) and [1/7] (38), case 16 [2/5] (31, max 6.6%), case 17 [4/3] (33), case 20 [1/3] (12, max 2.1%) — the frames named in F2; case 15 [3/3] and the others are shifted by less. Spot values: case 15 [1/3] old poles ±1.5492 (Q = 1 − 0.41667x²); [3/3] ±3.4713; [1/7] ±1.5595; case 12 [2/3] old poles ±1.7150. The 60-digit reference finds exactly 176 frames with a singular Toeplitz matrix (the same frames the fixed script flags), and `label_check2.py` (sympy, exact arithmetic) finds every one of them inconsistent: no [m/n] with Q(x0) = 1 exists there.
- Change: `pade_animations_all.jl` lines 338–438 (`pade_linear` … `pade_from_series`). The old solve is kept as `pade_linear` (unchanged arithmetic, so every regular frame is computed exactly as before). New `is_singular` (cond(B) > 1e14), `poly_degree`, `contact_ok` (does q·f − p vanish through order K) and `reduced_pade` (search over lower-order regular entries for the unique reduced Frobenius form; it is the top-left entry of the Padé-table block). `pade_from_series` returns `(p, q, note)`: for a singular, inconsistent system it returns the reduced form and the note `" = [l/mu] (degenerate)"`, which `render_case` appends to the legend (line 485). For sin and cos about c = 0 (cases 08, 09) the coefficients now come from `taylor_coeffs_exact` (lines 241–245), which gives exact zeros; the old `sin(k·π/2)` left 6e-17 noise that hid the singular blocks from the test (LU solved on the noise). Cases 10 and 11 (c ≠ 0) keep their old formula so their GIFs stay byte-identical.
- Check: `compare_new.out`: worst max|R−Rref|/y-range over cases 01–21 is 1.6e-10 (case 04, which has no singular frames) and ≤ 8.1e-12 in every case with degenerate frames; 0 visibly different frames. Script singular flags agree with the 60-digit reference in all 27 cases. New spot values: case 15 [1/3] poles ±1.4142 = ±√2, label "[1/3] = [0/2] (degenerate)"; [3/3] ±3.4641 (= [2/2]); [1/7] ±1.4858 (= [0/6]); case 12 [2/3] poles ±1.7321 = ±√3, label "= [1/2]". Separation of the singular test: regular systems have cond(B) ≤ 1.51e11 (case 03 [4/6]), singular ones ≥ 4.73e16 (case 20 [1/5]); raising the threshold from 1e12 to 1e14 left the dump and all GIFs byte-identical. Exact label check: `python3 -I label_check2.py` (`fix/label_check2.out`; it replaces a slower first version that was stopped; sympy DomainMatrix over ℚ, or ℚ(s) with s = 1/√(2π) symbolic for cases 20–21) → 816 frames in the 13 cases, 176 degenerate labels, 0 mismatches in singular status or in the printed [l/mu]; a mutation test (two labels altered in a copy, `fix/mut/`) is caught as 2 mismatches.

### F3 — Minor — fixed
- Reproduced: `julia contact_orders.jl`: 176 degenerate frames (66 [0/n] frames with f(x0) = 0 in cases 05, 07, 08, 12, 16, 17, 19; 85 frames with m ≥ 1 in cases 12, 14–21; 25 in cases 08–09), matching F3's counts. In every one, the curve shown matches f through order at most m+n−1 (max over frames of match order − (m+n) = −1). Examples: tan [2/1] shows R = x; cosh [1/1] shows R = 1.
- Change: index.qmd line 20, one sentence added after "…for give $m$ and $n$.": "When Taylor coefficients vanish, as for even or odd functions or when $f(x_0)=0$, some entries $[m/n]$ have no such $R_{m,n}$. Those frames show the lower-order entry that takes their place in the Padé table, which matches $f$ only to a lower order, and the legend says so, for example "Padé [2/1] = [1/0] (degenerate)"." Together with the F2 legend note, every such frame is now labelled.
- Check: see ledger; frames pade12 frame 9 (legend "Padé [2/1] = [1/0] (degenerate)", R = x) and pade05 frame 56 ("Padé [0/10] = [0/0] (degenerate)", R ≡ 0) viewed at full size.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.20 | "When Taylor coefficients vanish, as for even or odd functions or when $f(x_0)=0$, …" | Zero coefficients per case from `script_values_new.txt` A lines: degenerate frames occur only in cases with vanishing coefficients — 05, 07 (a0 = 0, f(x0) = 0); 08, 12, 16, 17, 19 (odd); 09, 15, 18, 20 (even); 14 (a2, a6, a10 = 0); 21 (a2, a4, … = 0); cases with no zero coefficient have 0 degenerate frames. | yes |
| index.qmd l.20 | "some entries $[m/n]$ have no such $R_{m,n}$" | `label_check2.py` (exact sympy): in all 176 singular frames the [m/n] system with q0 = 1 has no solution; 60-digit `compare_new.py` agrees on which frames are singular. | yes |
| index.qmd l.20 | "Those frames show the lower-order entry that takes their place in the Padé table" | `label_check2.py`: for every degenerate frame the shown [l/mu] equals the exact reduced Frobenius form (deg numerator / deg denominator after cancelling); l ≤ m, mu ≤ n, l+mu < m+n. `label_check2.py` → 176 labels, 0 mismatches. | yes |
| index.qmd l.20 | "which matches $f$ only to a lower order" | `julia contact_orders.jl` → 176 frames, max(match order − (m+n)) = −1 | yes |
| index.qmd l.20 | "the legend says so, for example "Padé [2/1] = [1/0] (degenerate)"" | pade12 frame 9 viewed at full size: legend reads exactly this; R = x (`spot_values.py`: case 12 [2/1] note ' = [1/0] (degenerate)') | yes |
| GIF legends (176 frames, cases 05, 07–09, 12, 14–21) | "Padé [m/n] = [l/mu] (degenerate)" | `label_check2.py` (exact) → 0 mismatches in 176 labels; frames viewed: pade15 f12 "[1/3] = [0/2] (degenerate)", pade12 f9, pade05 f56 | yes |
| GIF curves, cases 22–27 (all 270 frames) | exact [m/n] Padé of Γ and Y0 | `compare_new.py` → 0 visibly different frames, worst 3.3e-11 of y-range | yes |
| Script comment l.375–376 | "regular systems have cond(B) <= 1.6e11 … singular ones … >= 4.7e16" | dump: max cond regular 1.511e11 (03 [4/6]), min cond singular 4.733e16 (20 [1/5]) | yes |

## Scripts and GIFs
- Script changed: `pade_animations_all.jl` only. Run: `cd pages/numerical-methods/pade-approximation && julia pade_animations_all.jl` → "Generated 27 GIFs." (run twice; the second run, after the threshold edit, produced byte-identical GIFs: sha1 compare in `fix/gifs_before_rerun.sha1`).
- `git status -- pages/numerical-methods/pade-approximation`: modified `index.qmd`, `pade_animations_all.jl`, and `pade05, 07, 08, 09, 12, 14–27.gif` (19 GIFs). Unchanged and byte-identical: `pade01–04, 06, 10, 11, 13.gif` (no degenerate frames, coefficients untouched) — as expected.
- Frame-level check (`julia framediff.jl`, `julia psnr.jl`, outputs `fix/framediff.out`, `fix/psnr.out`): every frame's decoded md5 changes because the GIF palette is shared across frames, but in cases 05–21 the frames below 40 dB PSNR against HEAD are exactly the degenerate frames (all 13 cases: True); every other frame there is ≥ 40 dB (palette-only). In cases 22–27 the frames below 40 dB are the higher-order ones (case 22: 25 frames from frame 16 on; case 26: frames 43 and 45 only); the low-order frames are palette-only changes.
- Frames viewed at full size: pade15 frame 12 ([1/3] = [0/2], poles at ±1.41), pade22 frame 43 ([6/2], no spike near 1.87, ends near 14.9), pade24 frame 40 ([3/5] follows Γ to ≈29 at 5.2), pade12 frame 9, pade05 frame 56, pade08 frame 66 ([10/0], last frame), pade27 contact sheet. Titles unchanged; legends legible, no overlap with curves of note.

## Legacy archive
Consulted. `n2003/PadeApproximationMod.html` has 14 worked examples (formulas are images); its "Animations" link goes to `a2001/Animations/Interpolation/Pade/Pade.html`, which lists 27 animations. The formula images for entries 22–27 (Pade_gr_64–81, viewed) read: Gamma[x], x0 = 1, 2, 3 on −0.2 ≤ x ≤ 5.2; BesselY[0,x], x0 = 10, 5, 2 on 0 ≤ x ≤ 22 — the page's cases 22–27 match. The animated GIFs for 22–27 are not in the archive (Pade23/26/27 folders hold only the HTML). The archived tan animation (Pade12/Padell.gif, 12 frames, viewed) steps only through diagonal approximants S1,1 … S5,5 with a ±0.01 tolerance band; the site's animation steps through every [m/n] with m+n ≤ 8. That is a design difference, not addressed by any finding, so left as is. Nothing in the archive bears on the fit (F1) or on degenerate entries (F2, F3).

## Notes
- The page line "This really means derivatives match for give $m$ and $n$." has a typo ("give"); not in any finding, left unchanged. "see the resources section below" refers to the section titled "Outside Links" (claim 7 in round 1); left unchanged.
- `laurent-series/laurent_animations_all.jl` contains the same `series_coeffs_fit` (Float64) and needs the same fix (WP-A); not touched.
- Ambiguity: F2 offered two fixes (Frobenius solution, or the block's top-left with a legend note). Both give the same rational function; I compute the reduced Frobenius form and label it with its block entry, so the curve and the legend are both right.

### WP-A coefficient routine
Standalone copy: `fix/coeff_routine.jl` (identical to lines 71–211 of `pade_animations_all.jl` apart from its own `using SpecialFunctions`; checked with `diff`). Usage: `include("coeff_routine.jl"); a = taylor_coeffs_exact(family, c, n; nu=0, alpha=0.5, prec=256)` returns `a[k+1] = f^(k)(c)/k!`, k = 0…n, as `Vector{Float64}`.

What it computes: everything is done in `prec`-bit BigFloat (default 256) about the Float64 point `c` taken exactly (`BigFloat(c)`), then each coefficient is rounded once to Float64 (round-to-nearest). So `c = pi/4` means the Float64 nearest π/4, consistent with plotting in z = x − c.

| family | f | formula | domain |
|---|---|---|---|
| `:sqrt`, `:power` | x^α (α = 1/2 for `:sqrt`; `alpha` is a Float64 taken exactly) | binom(α,k)·c^(α−k) | c > 0 |
| `:log` | log x | log c; (−1)^(k−1)/(k c^k) | c > 0 |
| `:exp` | eˣ | e^c/k! | any c |
| `:sin`, `:cos` | sin x, cos x | derivative cycle (sin c, cos c, −sin c, −cos c)/k!; exact zeros at c = 0 | any c |
| `:gamma` | Γ(x) | Γ(c+z) = Γ(c)·exp(Σ l_m z^m), l_1 = ψ(c), l_m = (−1)^m ζ(m,c)/m; exponential expanded by k g_k = Σ_j j l_j g_{k−j}. Γ(c), ψ(c) from MPFR via SpecialFunctions; Hurwitz ζ by Euler–Maclaurin (shift to c+N ≥ 100+2m, 60 Bernoulli terms, Bernoulli numbers as exact rationals) | c > 0 |
| `:besselj` | J_ν(x), integer ν | J_ν^(k)(c) = 2^−k Σ_j (−1)^j C(k,j) J_{ν−k+2j}(c), J_{−m} = (−1)^m J_m; J_m(c) from MPFR (jn); c < 0 via J_m(−x) = (−1)^m J_m(x) | any c |
| `:bessely` | Y_ν(x), integer ν | same identity with Y_m from MPFR (yn), Y_{−m} = (−1)^m Y_m | c > 0 |

Families not covered raise an error (no silent fallback). Not covered: 1/(1−x), 1/(1+x), 1/(1−x)², 1/√(1−x), 1/(1+x²), log(1+x), tan, atan, asin, cosh, e^(−x²/2), e^(−x)cos x and the normal pdf/cdf — the Maclaurin cases (c = 0) on the WP-A pages keep their existing closed forms, which round-1 found exact to ≤ 3.3e-15 relative (here: `compare_new.out`, cases 04, 07, 12–21 ≤ 1.3e-16). exp, sin, cos, J0 and J1 at c = 0 are covered (validated below).

Validation (WP-A expansion points included: √x at 1, 4, 5; log at 1, 2; sin at π/4; cos at π/3; Γ at 1, 2, 3, 4; J0 at 10; J1 at 5; Y0 at 2, 5, 10), orders 0–20:
- `julia dump_coeffs.jl` → `coeffs_julia.txt` (51 function/point rows: sqrt at 1, 4, 5, 0.3, 2.5; x^−0.5 at 1, 0.25, 3; x^2.5 at 1, 0.7; log at 1, 2, 0.5, 3.7; exp at 0, 1, −2.5; sin and cos at 0, π/4, π/3, 1, −2; Γ at 1, 2, 3, 4, 0.5, 2.7, 10; J0 at 0, 10, 5, 2, −3; J1 at 0, 5, 10, 2, −3; J2 at 1.5; Y0 at 2, 5, 10, 0.7; Y1 at 2, 5).
- `python3 -I validate_coeffs.py` → `validate_coeffs.out`: reference `mpmath.taylor` (mpmath 1.2, high-precision numerical differentiation) at dps 70, cross-checked at dps 50. Result: all 1071 coefficients (51 rows × orders 0–20) are exactly equal to the mpmath value rounded to the nearest Float64; max relative error 1.08e-16 (per family: sqrt 8.3e-17, x^−0.5 8.9e-17, x^2.5 9.6e-17, log 1.02e-16, exp 9.9e-17, sin 9.5e-17, cos 9.3e-17, Γ 1.02e-16, J0 1.08e-16, J1 1.01e-16, J2 7.9e-17, Y0 1.00e-16, Y1 1.01e-16); exact zeros (sin, cos, J1 at 0, …) come out as 0. The dps-50 and dps-70 references agree to 5.0e-51, so the reference itself is not the limit.
- Second, independent reference for orders ≤ 8 at the 27 Padé-page cases: sympy symbolic derivatives (`exact_coeffs.py`): cases 22–27 max relative error 5.2e-17 … 9.8e-17 (`compare_new.out`).
- Limits: validated against mpmath to order 20 at the points listed. The identities hold for any order; what can limit accuracy is cancellation in the Bessel sum and in the Γ exponential recurrence. Measured (`julia cancellation.jl` → `cancellation.out`, max over k of log2(Σ|terms|/|result|)) at all validated Bessel and Γ points: at most 7.5 bits lost up to order 20 and at most 13.0 bits up to order 40 (Γ at c = 4), against 256 working bits, so orders well beyond 20 are safe at these points; for other points or much higher orders rerun `cancellation.jl` and raise `prec` if needed. The Hurwitz-ζ Euler–Maclaurin tail ratio ((m+120)/(2π(100+2m)))² is below 0.04 for every m ≥ 2, so ζ sets no order limit. Domain limits: Γ only for c > 0 (Γ(x+1) = xΓ(x) can shift a point); log, x^α, Y_ν need c > 0; ν must be an integer.

## Resolution check (independent checker, not shown this record)

All work is in `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/pade-approximation/check/`:
- `run/`: scratch copy of the script and its regenerated GIFs.
- `dump/`: `script_pq.txt` (the script's coefficients and P, Q, legend suffix for all 1,614 frames) and `cond.txt`.
- `py/`:
  - `exact.py` writes `coeffs.json`, 110-digit Taylor coefficients.
  - `xcheck.py` cross-checks them.
  - `pade.py` writes `pade_out.txt`, an independent Frobenius Padé for every frame.
  - `examples.py` evaluates the F1 examples.
  - `exsing.py` checks singularity.
- `frames/`: extracted frames.

Method (independent of the script's algorithms):
- **Coefficients.** The elementary cases use sympy series about the exact center, evaluated to 110 digits, so exact zeros stay exact. J0 and J1 use the power series. Γ uses `mpmath.taylor` at 110 digits, cross-checked against the ψ-recursion Γ⁽ᵏ⁺¹⁾ = Σ C(k,j) Γ⁽ʲ⁾ ψ⁽ᵏ⁻ʲ⁾ to agree to 3e−100. Y0 uses `mp.bessely(0,c,derivative=k)/k!`, cross-checked against `mpmath.taylor` to agree to 2e−100.
- **Padé.** For each [L/M], I take the null vector of the M×(M+1) Padé system by full SVD at 110 digits, form p = trunc(q·f), and cancel common roots found by `polyroots`. That gives the reduced R = P/Q with exact degrees (λ, μ), which is the top-left of the block. The contact order of Q·f − P decides whether a true [L/M] exists: the order must be at least L+M+1. The expected legend is "" when a true [L/M] exists and " = [λ/μ] (degenerate)" otherwise.
- **Comparison.** I compared the expected legend with the script's legend. I also compared the true R with the script's P/Q on the script's 900 plot points, with the same clamping, as a fraction of the y-range.

### Original findings

### F1 — resolved
- Evidence: `series_coeffs_fit` is deleted. Γ and Y0 now go through `taylor_coeffs_exact` (BigFloat 256-bit). The script's Float64 coefficients for cases 22–27 agree with my 110-digit coefficients to at most 9.3e−17 relative, against up to 12.6% before.
- In all 270 frames of cases 22–27, the script's curve agrees with the true Padé curve to at most 3.3e−11 of the y-range. Zero frames reach the 2% threshold, against 65–70 before.
- The F1 examples now show the true values:
  - Case 22 [6/2]: no spike at 1.87, R(1.87) = 0.952. The real poles are at 0.002 and −10.03. R(5.2) = 14.86 (true 14.9).
  - Case 22 [4/4]: R(5.2) = 6.09.
  - Case 24 [3/5]: R(5.2) = 29.22, with no real numerator root in the window (zeros 1.12±3.07i and 9.22).
  - Case 23 [2/5]: the right pole is at 4.689.
  - Case 23 [0/8]: the right pole is at 4.204.
  - Case 27 [4/4]: the pole is at 9.896.
  - Case 27 [6/2]: the pole is at 10.138.
  - Case 27 [6/1]: R(7.5) = −0.073, so the curve turns down near 0.
- I looked at the full-size frames pade22/043, pade24/040, pade27/041 and pade23/045 (the last frame). The spike is gone. [3/5] follows Γ to 29 at x = 5.2. The [4/4] pole in case 27 is drawn at x ≈ 9.9.
- The function `error("no Taylor coefficients ...")` now replaces the silent fit fallback. Every case hits an analytic branch, since the script runs to completion.

### F2 — resolved
- Evidence: when B is singular, `pade_from_series` now returns the reduced block approximant if the [m/n] system is inconsistent, and labels it. My exact computation agrees in every frame:
  - All 1,614 legends match the independent expectation, with 0 mismatches. The 176 "(degenerate)" frames carry exactly the block top-left I computed.
  - All 1,614 curves match the true (Frobenius) Padé to at most 1.6e−10 of the y-range. A few frames have one plot point next to a pole where the script's |den| < 1e−8 cutoff blanks a point I evaluate. That is not visible.
- The frames F2 named are now correct:
  - Case 15 [1/3] (frame 12) shows "Padé [1/3] = [0/2] (degenerate)" with poles at ±1.414, as I saw in the frame.
  - Case 12 [2/3] has poles at ±√3.
  - Cases 16, 17 and 20 differ from truth by less than 1e−14.
- The singularity test `cond(B) > 1e14` agrees with exact singularity for every system in the table. The largest regular cond is 1.51e11 and the smallest singular cond is 4.73e16, as the script comment states. Every consistent-singular frame (pinv path, no label) is a genuine [m/n] and matches truth to below 1e−14.

### F3 — resolved
- Evidence: index.qmd line 20 now adds that, when Taylor coefficients vanish (even or odd f, or f(x0) = 0), some [m/n] do not exist. It adds that those frames show the lower-order block entry, which matches f only to lower order, and that the legend says so.
- My computation confirms each part. Every labelled frame has contact order below m+n+1 and shows its block's top-left entry. The quoted example "[2/1] = [1/0] (degenerate)" appears in cases 12, 14 and 21; I saw it in the case 12 frame 9.
- The F3 examples are now labelled. Every [0/n] frame for sin and for log at 1 shows "= [0/0] (degenerate)", for example pade05/002. Case 15 [1/1] is labelled degenerate. Case 12 [1/1] = x is a genuine [1/1], since tan − x = O(x³), so it has no label, correctly.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:20 | "When Taylor coefficients vanish, as for even or odd functions or when $f(x_0)=0$, some entries $[m/n]$ have no such $R_{m,n}$." | The exact contact-order test finds non-existent entries in cases 05, 07–09, 12, 14–21 (176 frames). All have vanishing coefficients: odd or even, f(x0) = 0, or a2 = a6 = 0 in case 14. | True |
| index.qmd:20 | "Those frames show the lower-order entry that takes their place in the Padé table" | The shown curve equals the reduced Frobenius R (to 1e−14), and its label is the block top-left (λ, μ) with λ+μ < m+n in all 176 frames. | True |
| index.qmd:20 | "which matches $f$ only to a lower order" | The contact order is below m+n+1 in all 176 labelled frames. | True |
| index.qmd:20 | "the legend says so, for example "Padé [2/1] = [1/0] (degenerate)"" | The label exists in cases 12, 14 and 21; it is legible in pade12/frame_009. | True |
| GIF legends (176 frames) | "Padé [m/n] = [λ/μ] (degenerate)" | Independent block computation: 176 of 176 match, and no labels are missing or extra. | True |
| GIF legends (all other frames) | "Padé [m/n]" | A true [m/n] exists (contact ≥ m+n+1), and the curve matches truth to 1.6e−10 of the y-range. | True |
| script comment | regular cond(B) ≤ 1.6e11, singular ≥ 4.7e16 | Measured 1.51e11 and 4.73e16, with 0 misclassifications against exact singularity. | True |
| script comment | Γ: log-Γ series with l1 = ψ(c), lm = (−1)^m ζ(m,c)/m; Y0 derivative formula | The output coefficients agree with mpmath (two routes) to ≤ 9.3e−17 relative. | True |
| script comment | Hurwitz zeta tail factor < 0.04 | (128/(2π·116))² = 0.031 for s ≤ 8. | True |

### New problems
None. This rests on:
- the independent comparison of every frame's legend and curve (1,614 of 1,614) against exact Frobenius Padé approximants;
- full-size inspection of pade05/002, pade08/057, pade12/009, pade15/012, pade21/033, pade22/043, pade23/045, pade24/040 and pade27/041. The labels are legible and the legend box fits even the longest labels, such as "Padé [4/3] = [3/2] (degenerate)" beside "normal_cdf(x)";
- the unchanged GIFs (01–04, 06, 10, 11, 13) still matching truth to at most 1.6e−10 of the y-range.

Not new, and left as it was: clamping to ylims draws flat segments at the plot border next to poles (for example pade27/041 between x ≈ 7.3 and 9.9). Also, the pre-existing typo "for give $m$ and $n$" on line 20 is unchanged. Neither is in scope.

### Reproducibility and conventions
- Reproducibility: a scratch copy of `pade_animations_all.jl` ran in 90 s and produced 27 GIFs, all byte-identical to the committed files (27 of 27).
- Conventions:
  - Description comes before Animations.
  - Each of the 27 cases has a "[Julia source]" link and a GIF embed with descriptive alt text.
  - There are no code blocks in index.qmd.
- Scope: the fix diff touches only the page folder (index.qmd, the script, and pade05, 07–09, 12, 14–27.gif). The working tree has other modified pages, including laurent-series, which belong to other page fixes on this branch. There is also an untracked `reviews/numerical-methods-animations/fixes/pade-approximation.md`, which I did not read, since it is the fixer's notes.
- The F1 note about the same fit in `laurent-series` is outside this page. That page has its own pending changes in the working tree, and I did not check them.

**Final status:** committed

## Follow-up after commit (director)

The script comment "(WP-A shared routine)" used an internal label; it now reads "(the same routine is used on the Maclaurin and Laurent pages)". Comment only. A scratch rerun reproduces all 27 GIFs byte-identical.
