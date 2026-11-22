# Laurent Series — animation review

Page: [`pages/numerical-methods/laurent-series/index.qmd`](../../pages/numerical-methods/laurent-series/index.qmd) · Scripts: `laurent_animations_all.jl` · GIFs: 27

**Result:** 0 error, 1 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — The "two-sided" Laurent truncation is just the degree-N Taylor polynomial in every case; negative-power terms are never computed and no case has a principal part

- **Location:**
  - index.qmd line 24–30: "Each frame uses a two-sided truncation with both negative and positive powers at the same time, $\sum_{k=-N}^{N} a_k (x-x_0)^k$, with $N$ increasing frame by frame."
  - index.qmd line 22: "draws Laurent-series truncations instead of rational Padé forms".
  - index.qmd line 18: "In many smooth cases centered away from singularities, the principal part is zero…".
  - laurent_animations_all.jl lines 243–250 and 262–263: the curve is `poly_eval_asc(coeffs[1:(n+1)], z)`, labelled `"Laurent orders $(first(exps))..$(last(exps))"` with `exps = -n:n`.
- **Now:**
  - The page and every frame's legend ("Laurent orders -1..1" … "-10..10") present each frame as a sum over negative and positive powers.
  - The code never computes a negative-index coefficient. `series_coeffs` returns a_0…a_n only. The comment at lines 248–249 states that the negative terms are zero, and each frame draws the ordinary Taylor polynomial of degree N.
- **True:**
  - All 27 functions are analytic at their x₀. The Laurent series about x₀ on the disc around x₀ is therefore the Taylor series, a_k = 0 for every k < 0, and the sum over k = −N…N equals the degree-N Taylor polynomial. The drawn curves are correct for that region, so the page's formula is not false.
  - However, no frame of any case shows a negative power doing anything. The page reads as if the negative powers contribute, and line 18's "in many smooth cases" implies that some of the 27 cases have a nonzero principal part. None does.
  - For the pole cases, the plotted interval also reaches past the nearest pole, into an annulus where the real Laurent series about x₀ does have negative powers. The drawn disc series diverges exactly there. Examples:
    - Case 22 (Γ, x₀ = 1): in 1 < |x−1| < 2, which on the real axis includes x ∈ (2, 3), the coefficients are a₋₁ = 1, a₋₂ = −1, a₋₃ = 1, a₋₄ = −1.
    - Case 12 (tan, x₀ = 0): in π/2 < |x| < 3π/2, the coefficients are a₋₁ = −2 and a₋₃ = −π²/2 = −4.9348.

    A reader of a Laurent-series page that promises "two-sided" truncations would reasonably expect those terms to appear.
- **Evidence:**
  - `python3 -I reviewer/indep_coeffs.py reviewer/script_coeffs.txt`: for every case 01–27, max |a₋₁|, |a₋₂|, |a₋₃| ≤ 1.2e-40 (contour integral at 40 digits). This confirms a zero principal part in the disc for all 27.
  - `python3 -I reviewer/outer_annulus.py` gives the outer-annulus values quoted above. Case 23 (Γ, x₀ = 2, annulus 2 < |z−2| < 3): a₋₁ = 1, a₋₂ = −2, a₋₃ = 4, a₋₄ = −8.
  - Frames: in `committed/laurent22/sheet.png` and `committed/laurent12/sheet.png`, the legends read "Laurent orders -N..N" while the curve is visibly the Taylor polynomial, diverging past the pole.
- **Suggested fix:** Reword lines 24–30, for example: "All 27 functions are analytic at $x_0$, so the principal part vanishes ($a_k=0$ for $k<0$). The two-sided truncation $\sum_{k=-N}^{N}a_k(x-x_0)^k$ therefore reduces to the degree-$N$ Taylor polynomial, which is what each frame draws, with $N$ increasing frame by frame. Beyond the nearest singularity the drawn series diverges; there a different Laurent expansion, with nonzero negative powers, would apply." On line 18, change "In many smooth cases" to "When $f$ is analytic at $x_0$ (true of every case below)". In the script, change the legend to something like `"Taylor/Laurent N = $n (a_k = 0 for k < 0)"`.

- **Independent check:** confirmed. Checker: confirmed via 30-digit contour integrals (all principal-part coefficients ≤ 9e-32 in all 27 cases); notes the two-sided formula at line 24 is arguably closer to an Error.

### F2 — Minor — Implementation — Fitted coefficients for the Γ and Y₀ cases (22–27) are inaccurate at high order, so the last frames are not quite the stated truncation

- **Location:** laurent_animations_all.jl lines 68–117 (`series_coeffs_fit`), reached from line 222 for cases 22–27.
- **Now:**
  - a₀…a_n come from a least-squares fit of a degree-n polynomial to 29 equally spaced samples, at spacing h = 0.01, 0.02, 0.03, 0.1, 0.05, 0.02 for cases 22–27.
  - a₀–a₄ are good to about 1e-6 or better. a₅–a₈ carry relative errors of 1e-4 to 1.3e-1, from round-off amplified by 1/h^k and from aliasing of higher-order terms.
- **True** (script value vs. exact Taylor coefficient):

  | Case | k | Script | True | Rel. err |
  |---|---|---|---|---|
  | 22 | 7 | −1.0405 | −0.99600 | 4.5% |
  | 22 | 8 | 1.0477 | 0.99811 | 5.0% |
  | 23 | 5 | −2.575e-4 | −2.670e-4 | 3.5% |
  | 23 | 7 | −3.017e-3 | −2.853e-3 | 5.8% |
  | 25 | 7 | 4.319e-5 | 4.570e-5 | 5.5% |
  | 25 | 8 | −7.258e-7 | −7.796e-7 | 6.9% |
  | 26 | 7 | 6.658e-7 | 5.910e-7 | 12.6% |
  | 27 | 8 | −3.033e-4 | −2.913e-4 | 4.1% |

  The drawn N = 7 and N = 8 curves differ from the true truncations by up to 9.3% of the y-axis span. In case 25, N = 7, at x = 5 the curve is drawn at −0.860 where the true Taylor polynomial is −1.044; at x = 15 it is 1.18 vs 1.37. Frames N ≤ 6 differ by < 0.3% of the span.
- **Evidence:** `julia reviewer/coeffs_dump.jl`; `python3 -I reviewer/indep_coeffs.py reviewer/script_coeffs.txt` (full table in `indep_coeffs.out`); `python3 -I reviewer/fit_visual_impact.py reviewer/script_coeffs.txt` (per-frame max difference: case 25 N=7 9.32%, N=8 7.82%; case 27 N=7 3.34%; case 22 N=8 2.52%; others < 2.1%); `python3 -I reviewer/fit_where25.py reviewer/script_coeffs.txt`. The deviations lie only in the tails, where both curves have already left f(x), so the qualitative picture (divergence away from x₀) is unchanged. Hence Minor.
- **Suggested fix:** Compute these coefficients exactly instead of fitting. For example, use the Cauchy integral a_k = (1/M)Σ_j f(x₀ + r e^{iθ_j}) e^{−ikθ_j} / r^k, with M = 64 and r about half the distance to the nearest singularity: r = 0.5 for Γ at 1, 1 for Γ at 2, 1.5 for Γ at 3, and 0.5·x₀ for Y₀. SpecialFunctions' `gamma` and `bessely` accept complex arguments. For Y₀, the derivative recurrence Y₀′ = −Y₁, Y_n′ = (Y_{n−1} − Y_{n+1})/2 also works.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `laurent_animations_all.jl` | yes | 17.4 | 27 GIFs |

Committed GIFs byte-identical to their regenerated output: **27 of 27**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12–16 | "The Laurent series of a function around a center $x_0$ is $f(x)=\sum_{k=-\infty}^{\infty} a_k (x-x_0)^k$" | Standard definition (valid in an annulus about x₀) | confirmed |
| 2 | 18 | "extends Taylor series by allowing negative powers. Those negative-power terms form the principal part and capture pole-like behavior." | Standard; e.g. outer-annulus coefficients of Γ, tan (`outer_annulus.out`) | confirmed |
| 3 | 18 | "In many smooth cases centered away from singularities, the principal part is zero and the Laurent series reduces to an ordinary Taylor expansion." | True as stated, but it holds for all 27 cases (|a₋ₖ| ≤ 1.2e-40, `indep_coeffs.out`), not "many" | confirmed, misleading in context (→ F1) |
| 4 | 22 | "reuses the same 27 function/interval/center cases used on the Padé page" | `diff` of the `### Case` headings of pade-approximation/index.qmd and this page: identical; script table lines 21–47 match | confirmed |
| 5 | 22 | "draws Laurent-series truncations instead of rational Padé forms" | Draws polynomials (lines 243–250), which equal the disc Laurent truncations because a₋ₖ = 0 | confirmed in the narrow sense (→ F1) |
| 6 | 24–29 | "Each frame uses a two-sided truncation with both negative and positive powers at the same time, Σ_{k=-N}^{N} a_k (x-x_0)^k" | Code computes and draws only k = 0…N (line 250); negative terms are identically zero and never computed | wrong in substance / misleading (→ F1) |
| 7 | 30 | "with $N$ increasing frame by frame" | Loop `for n in 1:case.max_order` (line 242); nframes = 10 (cases 01–11, 13–16, 18–21) or 8 (12, 17, 22–27); legends read −1..1 → −10..10 / −8..8 (`titles_last.png`, sheets) | confirmed |
| 8 | 32 | "Each case below follows the same case ordering as the Padé suite (Case 01 through Case 27)." | Heading diff identical; ids 01–27 in order in script | confirmed |
| 9 | 34 | "[Julia source for all cases](laurent_animations_all.jl)" | File exists; manifest: it alone produces all 27 GIFs, byte-identical | confirmed |
| 10 | 36–38 | Case 01 — √x, x₀=1, x∈[0,10.5]; embed laurent01.gif, alt "…case 01." | Script line 21: sqrt, 1.0, (0,10.5); title "Laurent Case 01: f(x) = sqrt(x), x0 = 1.0"; axis 0–10.5 seen in frame_001 | confirmed |
| 11 | 40–42 | Case 02 — √x, x₀=4, [0,10.5]; laurent02.gif | Line 22: sqrt, 4.0, (0,10.5); title "…Case 02: f(x) = sqrt(x), x0 = 4.0" | confirmed |
| 12 | 44–46 | Case 03 — √x, x₀=5, [0,10.5]; laurent03.gif | Line 23: sqrt, 5.0, (0,10.5); title "…Case 03: … sqrt(x), x0 = 5.0" | confirmed |
| 13 | 48–50 | Case 04 — 1/√(1−x), x₀=0, [−1.5,1.5]; laurent04.gif | Line 24: 1/sqrt(1-x), 0.0, (−1.5,1.5); title "…Case 04: f(x) = 1/sqrt(1-x), x0 = 0.0" | confirmed |
| 14 | 52–54 | Case 05 — log x, x₀=1, [−0.5,4.1]; laurent05.gif | Line 25: log, 1.0, (−0.5,4.1); title "…Case 05: … log(x), x0 = 1.0"; axis −0.5–4.1 in sheet | confirmed |
| 15 | 56–58 | Case 06 — log x, x₀=2, [−0.5,4.1]; laurent06.gif | Line 26: log, 2.0, (−0.5,4.1); title "…Case 06: … log(x), x0 = 2.0" | confirmed |
| 16 | 60–62 | Case 07 — log(1+x), x₀=0, [−1.5,1.5]; laurent07.gif | Line 27: log(1+x), 0.0, (−1.5,1.5); title "…Case 07: … log(1+x), x0 = 0.0" | confirmed |
| 17 | 64–66 | Case 08 — sin x, x₀=0, [−3π,3π]; laurent08.gif | Line 28: sin, 0.0, (−3π,3π); title "…Case 08: … sin(x), x0 = 0.0" | confirmed |
| 18 | 68–70 | Case 09 — cos x, x₀=0, [−3π,3π]; laurent09.gif | Line 29: cos, 0.0, (−3π,3π); title "…Case 09: … cos(x), x0 = 0.0" | confirmed |
| 19 | 72–74 | Case 10 — sin x, x₀=π/4, [−7π/4,9π/4]; laurent10.gif | Line 30: sin, π/4, (−7π/4, 9π/4); title "…Case 10: … sin(x), x0 = 0.7854" (= π/4); axis −5.50…7.07 in frame_010 | confirmed |
| 20 | 76–78 | Case 11 — cos x, x₀=π/3, [−5π/3,7π/3]; laurent11.gif | Line 31: cos, π/3, (−5π/3, 7π/3); title "…Case 11: … cos(x), x0 = 1.0472" (= π/3) | confirmed |
| 21 | 80–82 | Case 12 — tan x, x₀=0, [−π,π]; laurent12.gif | Line 32: tan, 0.0, (−π,π); title "…Case 12: … tan(x), x0 = 0.0"; axis ±π in sheet | confirmed |
| 22 | 84–86 | Case 13 — eˣ, x₀=0, [−2,3]; laurent13.gif | Line 33: exp, 0.0, (−2,3); title "…Case 13: … exp(x), x0 = 0.0" | confirmed |
| 23 | 88–90 | Case 14 — e^{−x}cos x, x₀=0, [−2,4]; laurent14.gif | Line 34: exp(-x)*cos(x), 0.0, (−2,4); title "…Case 14: … exp(-x)*cos(x), x0 = 0.0" | confirmed |
| 24 | 92–94 | Case 15 — cosh x, x₀=0, [−4,4]; laurent15.gif | Line 35: cosh, 0.0, (−4,4); title "…Case 15: … cosh(x), x0 = 0.0" | confirmed |
| 25 | 96–98 | Case 16 — arctan x, x₀=0, [−2,2]; laurent16.gif | Line 36: atan, 0.0, (−2,2); title "…Case 16: … atan(x), x0 = 0.0" | confirmed |
| 26 | 100–102 | Case 17 — arcsin x, x₀=0, [−1.5,1.5]; laurent17.gif | Line 37: asin, 0.0, (−1.5,1.5); title "…Case 17: … asin(x), x0 = 0.0" | confirmed |
| 27 | 104–106 | Case 18 — J₀(x), x₀=0, [−10.2,10.2]; laurent18.gif | Line 38: besselj(0,x), 0.0, (−10.2,10.2); title "…Case 18: … besselj(0,x), x0 = 0.0" | confirmed |
| 28 | 108–110 | Case 19 — J₁(x), x₀=0, [−10.2,10.2]; laurent19.gif | Line 39: besselj(1,x), 0.0, (−10.2,10.2); title "…Case 19: … besselj(1,x), x0 = 0.0" | confirmed |
| 29 | 112–114 | Case 20 — (1/√(2π))e^{−x²/2}, x₀=0, [−3,3]; laurent20.gif | Line 40: exp(-x^2/2)/sqrt(2π), 0.0, (−3,3); title "…Case 20: … normal_pdf(x), x0 = 0.0" | confirmed |
| 30 | 116–118 | Case 21 — ½+½erf(x/√2), x₀=0, [−3,3]; laurent21.gif | Line 41: 0.5+0.5erf(x/√2), 0.0, (−3,3); title "…Case 21: … normal_cdf(x), x0 = 0.0" | confirmed |
| 31 | 120–122 | Case 22 — Γ(x), x₀=1, [−0.2,5.2]; laurent22.gif | Line 42: gamma, 1.0, (−0.2,5.2); title "…Case 22: … gamma(x), x0 = 1.0"; axis −0.2…5.2 in sheet | confirmed (coefficients inexact → F2) |
| 32 | 124–126 | Case 23 — Γ(x), x₀=2, [−0.2,5.2]; laurent23.gif | Line 43: gamma, 2.0, (−0.2,5.2); title "…Case 23: … gamma(x), x0 = 2.0" | confirmed (→ F2) |
| 33 | 128–130 | Case 24 — Γ(x), x₀=3, [−0.2,5.2]; laurent24.gif | Line 44: gamma, 3.0, (−0.2,5.2); title "…Case 24: … gamma(x), x0 = 3.0" | confirmed (→ F2) |
| 34 | 132–134 | Case 25 — Y₀(x), x₀=10, [0,22]; laurent25.gif | Line 45: bessely(0,x), 10.0, (0,22); title "…Case 25: … bessely(0,x), x0 = 10.0"; axis 0–22 in sheet | confirmed (→ F2) |
| 35 | 136–138 | Case 26 — Y₀(x), x₀=5, [0,22]; laurent26.gif | Line 46: bessely(0,x), 5.0, (0,22); title "…Case 26: … bessely(0,x), x0 = 5.0" | confirmed (→ F2) |
| 36 | 140–142 | Case 27 — Y₀(x), x₀=2, [0,22]; laurent27.gif | Line 47: bessely(0,x), 2.0, (0,22); title "…Case 27: … bessely(0,x), x0 = 2.0" | confirmed (→ F2) |
| 37 | 38–142 | Alt text "Laurent-series truncation animation for case NN." for each embed | Each alt's NN equals the heading's case number and the GIF's number (01…27); GIF titles carry the same id | confirmed |

The case intervals are not printed in the GIF titles. For rows 10–36 the interval was checked against the script's `xlims` (which sets the frame's x-axis exactly, and the GIFs are byte-identical to script output) and visually on frames of cases 01, 05, 10, 12, 22 and 25.

## Implementation checks

### laurent_animations_all.jl
- **Method:**
  - For every case the script draws the partial sums Σ_{k=0}^{N} a_k (x−x₀)^k for N = 1…max_order (10, or 8 for cases 12, 17, 22–27), evaluated by Horner's rule (`poly_eval_asc`, checked to be correct).
  - Negative-index coefficients are never computed. The comment at lines 248–249 asserts they vanish. I confirmed that for all 27 cases (each f is analytic at x₀, so its Laurent series on the disc around x₀ is the Taylor series). The drawn curves are therefore the true Laurent truncations for the disc |x−x₀| < R, where R is the distance to the nearest singularity. They are *not* the Laurent series valid in the outer annuli that the plotted interval also covers for cases with poles or branch points (see F1).
  - Coefficients come from closed forms for cases 01–21: sqrt binomial series, central binomials, log, sin/cos shift formula, tan Bernoulli values, exp, Re((−1+i)^k)/k!, cosh, atan, asin, J₀, J₁, normal pdf/cdf. For 22–27 (Γ, Y₀) they come from a least-squares polynomial fit to sampled values.
- **Numbers** (script vs independent mpmath contour-integral coefficients, `indep_coeffs.out`):

  | Cases | k | Script | Independent | Max rel. err |
  |---|---|---|---|---|
  | 01–21 | 0…n | all | all | ≤ 4e-13 (limited by 12-digit printing). E.g. case 12: a₇ = 5.396825e-2 vs 17/315; case 17: a₇ = 4.464286e-2 vs 5/112; case 14: a₃ = 0.333333 |
  | 22 (Γ, x₀=1) | 1 | −0.5772156602 | −0.5772156649 (−γ) | |
  | 22 | 8 | 1.04765 | 0.99811 | 5.0% |
  | 23 (Γ, x₀=2) | 0…4 | | | ≤ 2.4e-6 |
  | 23 | 5…8 | | | up to 5.8% |
  | 24 (Γ, x₀=3) | 7, 8 | | | ≈ 2% |
  | 25 (Y₀, x₀=10) | 0 | 0.0556711678 | 0.0556711673 | |
  | 25 | 7 | | | 5.5% |
  | 25 | 8 | | | 6.9% |
  | 26 (Y₀, x₀=5) | 7 | | | 12.6% |
  | 27 (Y₀, x₀=2) | 7, 8 | | | ≈ 4% |

  The effect on the drawn curves is in F2. In all 27 cases the negative-index coefficients a₋₁, a₋₂, a₋₃ are below 1.2e-40, so omitting them is exact. The contour coefficients agree with `mpmath.taylor` to < 3e-39.
- **Reference values:**
  - The magenta "y = f(x)" curve is the function itself, evaluated with Base / SpecialFunctions. Each table entry's function was checked to be the heading's function (claim-ledger rows 10–36).
  - The red dot is (x₀, f(x₀)). The dashed line is at x₀.
- **Picture:**
  - Frames viewed:
    - all 27 last-frame titles and legends (`reviewer/titles_last.png`);
    - frame_001 of case 01 and frame_010 of case 10, full size;
    - contact sheets of cases 05, 12, 22 and 25.
  - Titles show the right function label, case id and x₀. Legends count N = 1…max_order in step with the frame index.
  - Clamping to `ylims` (lines 236 and 252) draws diverging partial sums as flat runs along the top or bottom axis. It also draws the true function's poles as vertical magenta segments: tan at ±π/2, Γ at 0. These are acceptable readability devices; nothing the page claims depends on them.
  - For even or odd functions, consecutive frames are identical (a_k = 0 for every other k). The page's "N increasing frame by frame" is still literally true.
  - Domain errors (√ and log of negatives, 1/√(1−x) for x > 1, Y₀ at 0) are masked to NaN, correctly leaving gaps.
  - The fallback branch of `series_coeffs_fit` (constant polynomial when samples are non-finite) is never reached: all six fitted cases have finite samples at their h.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/laurent-series/`](evidence/laurent-series/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
