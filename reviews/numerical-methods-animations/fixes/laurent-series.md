# Fix record: laurent-series

Scratch folder with every script and output named below:
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/laurent-series/fix/` (written `fix/` below).
The round-1 evidence scripts were copied to `fix/reviewer/` and `fix/verify/` and re-run from `fix/`.
Coefficient dumps: `fix/dump.jl <script> <out>` loads a script's definitions without its render loop and writes `series_coeffs(case)` for all 27 cases at 17 digits. `old/script_coeffs.txt` comes from the HEAD script (`old/laurent_HEAD.jl`, from `git show HEAD:`). `step1/script_coeffs.txt` comes from the coefficient fix alone. `final_coeffs.txt` comes from the repo script as left.

## Findings

### F1 — Misleading — fixed
- **Reproduced:**
  - `python3 -I reviewer/indep_coeffs.py old/script_coeffs.txt` (`old/indep_coeffs.out`) uses mpmath contour integrals at 40 digits with radius 0.5R. For every case 01–27, max|a₋₁..a₋₃| ≤ 1.2e-40, so no case has a principal part.
  - My own check, `python3 -I f1_radius.py` (`f1_radius.out`), uses a different radius (0.9R) and a₋₁..a₋₅. Every case gives ≤ 4.9e-10, which is quadrature error: it grows as r approaches R and stays at ≤ 1.2e-40 at r = 0.5R.
  - The HEAD script draws `poly_eval_asc(coeffs[1:(n+1)], z)` (degree-n polynomial, old line 250) under the legend "Laurent orders -n..n". Negative-index coefficients are never computed.
  - Outer-annulus coefficients (`reviewer/outer_annulus.py` → `old/outer_annulus.out`, and `f1_radius.py`) match the finding:
    - case 12, π/2<|z|<3π/2: a₋₁ = −2, a₋₃ = −4.9348022;
    - case 22, 1<|z−1|<2: a₋₁..a₋₄ = 1, −1, 1, −1;
    - case 23, 2<|z−2|<3: a₋₁..a₋₄ = 1, −2, 4, −8;
    - case 24, 3<|z−3|<4: a₋₁..a₋₄ = 1, −3, 9, −27.
- **Change (D6: reword honestly, no new pole cases):**
  - index.qmd line 18: "In many smooth cases centered away from singularities, …" → "When $f$ is analytic at $x_0$, as it is in every case below, the principal part is zero and, on the largest disc about $x_0$ where $f$ is analytic, the Laurent series is the ordinary Taylor series."
  - Line 22: "draws Laurent-series truncations" → "draws truncated series about $x_0$".
  - Lines 24–30: "Each frame uses a two-sided truncation with both negative and positive powers at the same time …" is replaced by the statement that $a_k=0$ for $k<0$. The display now reads $\sum_{-N}^{N}=\sum_{0}^{N}$, followed by "is the degree-$N$ Taylor polynomial … no frame contains a negative power". Two sentences follow: one on convergence radius and divergence (entire cases named), and one saying that for the pole cases (12, 22–24) a different annulus Laurent series with negative powers exists but is not drawn.
  - Script `laurent_animations_all.jl`: legend "Laurent orders $(first(exps))..$(last(exps))" → "Laurent = Taylor, N = $(n)" (line 357). The unused `exps = -n:n` was removed. The comment at lines 341–343 was reworded.
- **Check:**
  - Ledger below.
  - Frames viewed at full size: laurent01 f1 ("Laurent = Taylor, N = 1"), laurent25 f7, laurent20 f10. Contact sheets of laurent12 and laurent22 were viewed, plus a strip of the top 230 px of every case's last frame (`tops/tops.png`). Every legend reads "Laurent = Taylor, N = <max_order>" and is legible.
  - A first legend wording, "Taylor/Laurent N = n (a_k = 0 for k < 0)", was rejected after viewing. In case 20 it covered the red (x₀, f(x₀)) marker at the pdf peak (`pngcmp` render of laurent20 frame 10). The shorter label leaves the marker visible: laurent20 f10 in the tops strip and the full frame.

### F2 — Minor — fixed
- **Reproduced:** `python3 -I reviewer/indep_coeffs.py old/script_coeffs.txt` gives these max relative coefficient errors for the old least-squares fit:

  | Case | 22 | 23 | 24 | 25 | 26 | 27 |
  |---|---|---|---|---|---|---|
  | Max rel. error | 4.96e-2 | 5.75e-2 | 1.97e-2 | 6.89e-2 | 1.26e-1 | 4.10e-2 |

  - All table entries in F2 reproduce, e.g. case 22 k=8: −1.0477 script vs 0.99811 true; case 26 k=7: 12.6%.
  - `reviewer/fit_visual_impact.py` (`old/fit_visual_impact.out`): the worst frame differs by 9.32% of the y-span (case 25 N=7).
  - `python3 -I spot25.py` (`spot25.out`), case 25 N=7: at x=5 old −0.8603 vs true −1.0443; at x=15 old 1.1815 vs true 1.3683.
- **Change:** `laurent_animations_all.jl`:
  - Added the WP-A routine `taylor_coeffs_exact` with `_bernoulli_numbers`, `_hurwitz_zeta` and `_bessel_big` (lines 68–207). Its code is identical to Padé lines 71–211, checked with `diff`. Two lines differ, neither of them code:
    - one blank line;
    - the header comment (line 68), which now reads "(same routine as the Padé page)" instead of the internal label "(WP-A shared routine)", at the coordinator's request.
  - After that comment edit the script was re-run, and all 27 GIFs came out byte-identical to the previous run (`cmp` against `fix/prerun/`).
  - `series_coeffs` now returns `taylor_coeffs_exact(:gamma, c, n)` and `taylor_coeffs_exact(:bessely, c, n; nu=0)` (lines 310–313).
  - `series_coeffs_fit` was deleted. The fallback is now `error("no Taylor coefficients …")` (line 316).
  - No package was added, and the closed forms for cases 01–21 are untouched.
- **Check:**
  - `python3 -I reviewer/indep_coeffs.py step1/script_coeffs.txt` (`step1/indep_coeffs.out`) gives these max relative errors:

    | Case | 22 | 23 | 24 | 25 | 26 | 27 |
    |---|---|---|---|---|---|---|
    | Max rel. error | 5.24e-17 | 6.35e-17 | 9.26e-17 | 9.83e-17 | 9.23e-17 | 5.77e-17 |

  - `fit_visual_impact.py` (`step1/fit_visual_impact.out`): 0.00% of the y-span in every frame of cases 22–27.
  - `spot25.out`: the new values are −1.0443 and 1.3683, equal to mpmath.taylor.
  - `cmp final_coeffs.txt step1/script_coeffs.txt`: identical, so the legend edit did not touch the coefficients.
  - `diff` of lines 1–21 of `old/` vs `step1/script_coeffs.txt`: identical (cases 01–21 unchanged).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.18 | "When $f$ is analytic at $x_0$, as it is in every case below, the principal part is zero" | `indep_coeffs.out`: max\|a₋₁..a₋₃\| ≤ 1.2e-40 for all 27 cases (r = 0.5R). `f1_radius.out`: a₋₁..a₋₅ at r = 0.9R ≤ 4.9e-10 (quadrature error). The singularities listed in `f1_radius.py` (branch points 0, ±1, −1, ±i; poles ±π/2 and 0) do not include any x₀. | yes |
| index.qmd l.18 | "on the largest disc about $x_0$ where $f$ is analytic, the Laurent series is the ordinary Taylor series" | Standard (Laurent expansion on a disc has a₋ₖ = 0). `indep_coeffs.out`: contour a₀..a_n equal mpmath.taylor to ≤ 2.2e-39 in all cases | yes |
| index.qmd l.22 | "draws truncated series about $x_0$ instead of rational Padé forms" | Script line 344: `poly_eval_asc(coeffs[1:(n+1)], z)` with z = x − x₀ | yes |
| index.qmd l.24–28 | "All 27 functions are analytic at $x_0$, so $a_k=0$ for every $k<0$"; display $\sum_{-N}^{N}=\sum_{0}^{N}$ | Same as row 1 | yes |
| index.qmd l.30 | "is the degree-$N$ Taylor polynomial. That is what each frame draws, with $N$ increasing frame by frame" | Script: `for n in 1:case.max_order`, curve = Σ_{k=0}^{n} a_k z^k with a_k = Taylor coefficients (`indep_coeffs.out` for 01–21, `step1/indep_coeffs.out` for 22–27, ≤ 1.5e-15 rel. at worst, case 11). Legend counts N = 1…max_order (frames viewed: laurent01 f1 N=1, laurent25 f7 N=7, laurent22 sheet N=1…8) | yes |
| index.qmd l.30 | "no frame contains a negative power" | Script never computes a negative-index term (only `coeffs[1:(n+1)]`, k ≥ 0) | yes |
| index.qmd l.30 | "Unless $f$ is entire (cases 08–11, 13–15 and 18–21)" | `f1_radius.out`: entire = 08, 09, 10, 11, 13, 14, 15, 18, 19, 20, 21 (sin, cos, exp, e^{−x}cos x, cosh, J₀, J₁, normal pdf, ½+½erf). Root-test estimates from a₃₀..a₄₀ are 3.7–16.6 and growing. Every other case has a finite R. | yes |
| index.qmd l.30 | "the series converges only within the distance from $x_0$ to the nearest singularity … and diverges beyond it" | Cauchy–Hadamard with R = distance to nearest singularity (f analytic on that disc, singular on its boundary). Numerically, `f1_radius.out` root-test |a_k|^{−1/k} for k = 30..40 vs R: 01 1.19–1.24 vs 1; 02 4.66–4.83 vs 4; 03 5.81–6.02 vs 5; 04 1.06–1.08 vs 1; 05 1.10–1.12 vs 1; 06 2.19–2.24 vs 2; 07 1.10–1.12 vs 1; 12 1.559–1.561 vs π/2; 16 1.10–1.12 vs 1; 17 1.16–1.19 vs 1; 22 1.00 vs 1; 23 2.04–2.05 vs 2; 24 3.08–3.11 vs 3; 25 11.1–11.4 vs 10; 26 5.55–5.69 vs 5; 27 2.22–2.27 vs 2 (k^{1/k}-type factors bias these slightly high) | yes |
| index.qmd l.30 | "every such plotted interval reaches past that distance" | `f1_radius.out` "window beyond R: True" for all 16 non-entire cases. The smallest margin is case 06 (max\|x−x₀\| = 2.5 vs R = 2) and cases 03/24 (5.5 vs 5, 3.2 vs 3). | yes |
| index.qmd l.30 | "Where the nearest singularity is a pole ($\tan x$ in case 12, $\Gamma(x)$ in cases 22–24)" | Nearest singularities: tan poles ±π/2. Γ pole at 0 (distance 1, 2, 3). All other non-entire cases have a branch point nearest (√, log, (1−x)^{−1/2}, log(1+x): real branch points; atan: ±i; asin: ±1; Y₀: logarithmic at 0), as listed in `f1_radius.py`. | yes |
| index.qmd l.30 | "a different Laurent series about $x_0$, with nonzero negative powers, holds in the annulus between that pole and the next singularity; the animations do not draw it" | `f1_radius.out` / `old/outer_annulus.out`: case 12 (π/2<\|z\|<3π/2) a₋₁ = −2, a₋₃ = −4.9348022; case 22 a₋₁..a₋₄ = 1, −1, 1, −1; case 23: 1, −2, 4, −8; case 24: 1, −3, 9, −27 (all imaginary parts < 1e-25). The script draws only the disc series. | yes |
| GIF legends (all 27 GIFs, 254 frames) | "Laurent = Taylor, N = n" | Frames viewed (see F1 Check). `pngbox_step1_vs_new.out`: the legend edit changes only pixels inside the legend label box (x 180–295, y 47–87) in every case. | yes |
| Script comment l.341–343 | "Every case's f is analytic at x0, so the principal part vanishes (a_k = 0 for k < 0) and the truncation sum_{k=-n}^{n} is the degree-n Taylor polynomial." | Same as rows 1 and 5 | yes |
| GIF curves, cases 22–27 (48 frames) | exact Taylor polynomials of Γ and Y₀ | `step1/fit_visual_impact.out`: 0.00% of the y-span in every frame. `spot25.out` matches mpmath. | yes |

## Scripts and GIFs
- **Script changed:** `laurent_animations_all.jl`. Run with `cd pages/numerical-methods/laurent-series && julia laurent_animations_all.jl` → "Generated 27 GIFs."
- **Byte-identity, done in two stages in scratch:**
  - The HEAD script run in `fix/headrun/` reproduces all 27 committed GIFs byte for byte (`cmp` against copies in `fix/orig/`).
  - The coefficient fix alone (`fix/step1/`, old legend) leaves `laurent01–21.gif` byte-identical and changes only `laurent22–27.gif` (`step1/gif_compare.out`).
  - The legend change then necessarily alters all 27 GIFs (D6 asks for honest legends in every GIF).
  - Note: `git show HEAD:<gif>` returns an LFS pointer, so the comparisons use the worktree copies taken before regeneration.
- **Frame-level check, on unquantized PNG renders of each frame from the old, step1 and new scripts (`fix/pngcmp/`, `fix/pngbox.jl`):**
  - old vs step1: cases 01–21 have 0 differing pixels in every frame (`pngbox_old_vs_step1.out`).
  - step1 vs new: every case differs only within the legend label box, x 180–295, y 47–87 (`pngbox_step1_vs_new.out`).
  - old vs new for 01–21: same, legend box only (`pngbox_old_vs_new.out`).
  - Note: a decoded-GIF comparison (`diffbox.jl`) shows scattered differences across the whole frame. These are palette/dither changes, because the GIF palette is shared across frames and the legend text changed it.
- **Frames viewed:**
  - Full size: laurent01 f1, laurent25 f7 (new vs old: the left branch reaches −2 at x ≈ 4.5 instead of ≈ 4.3, consistent with the spot values), laurent22 f8, laurent20 f10, laurent16 f10, laurent27 f8, laurent08 f10.
  - Contact sheets: laurent12, laurent22.
  - The top-strip tile of all 27 last frames.
  - Titles are unchanged. Legends show the correct N and are legible. The x₀ marker is visible in every case where it lies in the window.
- **`git status -- pages/numerical-methods/laurent-series`:** modified `index.qmd`, `laurent_animations_all.jl`, `laurent01.gif` … `laurent27.gif` (all 27, as expected). Nothing else in the folder.

## Legacy archive
- **Consulted.**
  - `n2003/` has no Laurent module; `TaylorPolyMod.html` covers Taylor/Maclaurin polynomials only.
  - `grep -ril laurent` found `n2003/FrobeniusSeriesMod.html`, which mentions Frobenius series as "generalized Laurent series", and a complex-analysis module, `c2003/LaurentSeriesMod.html` (§7.3 Laurent Series Representations). That module defines the Laurent series on an annulus and motivates it with a function that has no Maclaurin series because of a singularity at 0. It contains no animations.
- **Nothing in the archive corresponds to this page's 27-case animation set,** which is reused from the Padé page. So there is no fidelity question.
- **Mathews' Laurent material is about functions with a singularity at the center or annulus expansions.** That supports the reworded page: what the animations show is the zero-principal-part special case. Adding such cases is the D6 item left for Jason.

## Notes
- **D6 scope:** real Laurent cases with poles (e.g. Γ about x₀ = 0 or a −1, or the annulus series for cases 12 and 22–24 computed above) are not added. That decision is for Jason.
- **Alt text and titles:** the alt text "Laurent-series truncation animation for case NN." and the GIF titles "Laurent Case NN" are left unchanged. With the reworded page text they are accurate: the Laurent truncation is the Taylor polynomial.
- **Even and odd functions:** consecutive frames are identical, because every other coefficient is zero. "N increasing frame by frame" remains literally true. This is not in any finding, so it is left as is.
- **Outside this page, not touched:** `maclaurin-and-taylor-series/index.qmd` line 25 says Laurent series "may be discussed on other Numerical Methods pages". That is fine.

## Resolution check (independent checker, not shown this record)

All of the work below is in `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/laurent-series/check/`. That includes the scratch run in `run/`, the coefficient dump in `script_coeffs.txt`, the independent checks `indep.py`/`indep.out`, `cr.py` and `annulus.py`, the pre-fix GIFs in `old/` (taken with `git show HEAD:… | git lfs smudge`), the frames in `frames/old*` and `frames/new*`, and the pixel diffs in `pixdiff.py` and `pixdiff2.py`.

### Original findings

### F1 — resolved
- **Evidence (text):**
  - The false or misleading sentences are gone. The old "Each frame uses a two-sided truncation with both negative and positive powers at the same time" is replaced by "All 27 functions are analytic at $x_0$, so $a_k=0$ for every $k<0$, and the two-sided truncation … $=\sum_{k=0}^{N}$ … is the degree-$N$ Taylor polynomial … no frame contains a negative power."
  - The old "In many smooth cases" is replaced by "When $f$ is analytic at $x_0$, as it is in every case below".
  - The old "draws Laurent-series truncations" now reads "draws truncated series about $x_0$".
  - Each replacement sentence is verified true below, in the ledger.
  - The page now also states that a different Laurent series, with nonzero negative powers, holds in the annulus past the nearest pole for cases 12 and 22–24, and that the animations do not draw it. I confirmed this by contour integrals:
    - case 12: a₋₁ = −2, a₋₃ = −4.9348 (= −π²/2), and a₋₂ = a₋₄ = 0 to 1e-30;
    - case 22: a₋₁..a₋₄ = 1, −1, 1, −1;
    - case 23: 1, −2, 4, −8;
    - case 24: 1, −3, 9, −27.
- **Evidence (script/GIF):**
  - The legend changed from "Laurent orders -n..n" to "Laurent = Taylor, N = n". I read it at full size in case 01 frame 1, case 12 frame 8, case 22 frame 8, case 25 frame 7 and case 26 frame 4, and in the contact sheets of 22, 23 and 27. It is legible and correct.
  - The script comment now matches what the code does.
  - Old-vs-new pixel diffs for cases 01–21 lie only inside the legend box (x 50–330, y 30–110). There are 0 changed pixels outside it in every frame, so nothing else in those 21 GIFs changed.

### F2 — resolved
- **Evidence:**
  - The least-squares fit (`series_coeffs_fit`) is removed. Cases 22–24 now use `taylor_coeffs_exact(:gamma, …)` and cases 25–27 use `taylor_coeffs_exact(:bessely, …; nu=0)`. These are 256-bit BigFloat formulas: the log-Gamma/Hurwitz-zeta expansion, and the Bessel derivative identity. The routine is byte-identical to the one in `pade_animations_all.jl`, as the new comment says.
  - I dumped the script's coefficients and compared them with two independent references: mpmath `taylor` at 60 digits, and a 128-point Cauchy integral (the two references agree to ≤ 1e-39).
    - The maximum relative error over all a₀..a₈ of cases 22–27 is 1.5e-16.
    - Every one of these coefficients equals the correctly rounded Float64 of the true value (0 mismatches; `cr.py`).
  - The entries in the original table are all now exact. For example:
    - case 22: a₇ = −0.99600176044243153, a₈ = 0.99810569378312892;
    - case 23: a₅ = −2.6698206874501e-4;
    - case 25: a₇ = 4.5699891363312e-5;
    - case 26: a₇ = 5.9100533379062e-7;
    - case 27: a₈ = −2.9134474279806e-4.
  - **Picture:** in case 25, frame N = 7, the blue curve read off the pixels matches the true degree-7 Taylor polynomial at the points the finding cited, to within pixel resolution:

    | x | Drawn | True polynomial | Old drawn value |
    |---|---|---|---|
    | 5 | −1.02 | −1.044 | −0.860 |
    | 15 | 1.42 | 1.368 | 1.18 |
    | 6 | −0.373 | −0.384 | |
    | 14 | 0.318 | 0.305 | |

  - Old-vs-new curve-pixel changes in cases 22–27 appear only in the frames the finding predicted: N = 7–8 in cases 22, 23, 24 and 25, N = 8 in case 26, and N = 7 in case 27. Frames N ≤ 6 change only in the legend.
  - The coefficients of cases 01–21 come from unchanged closed-form code. They agree with mpmath to rounding, except for zero-valued even/odd entries, which are exact zeros or ±1e-17 round-off in the sin/cos phase formula (not a change by the fixer).

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Description | "When $f$ is analytic at $x_0$, as it is in every case below, the principal part is zero" | Contour integrals of a₋₁..a₋₃ on a small circle are ≤ 1e-30 for all 27 cases (original evidence, re-confirmed for 22–27 by the Taylor/Cauchy agreement). Every x₀ is a regular point: sqrt/log centers > 0, Γ at 1, 2, 3, Y₀ at 10, 5, 2, the others at 0 or π/4, π/3 away from singularities. | true |
| index.qmd Description | "on the largest disc about $x_0$ where $f$ is analytic, the Laurent series is the ordinary Taylor series" | Uniqueness of the Laurent expansion on an annulus; for 0 < \|z\| < R the Taylor series is that expansion. | true |
| index.qmd Animations ¶1 | "draws truncated series about $x_0$ instead of rational Padé forms" | Matches the code (`poly_eval_asc` of a₀..a_N). | true |
| index.qmd Animations | "All 27 functions are analytic at $x_0$, so $a_k=0$ for every $k<0$" | As above. | true |
| index.qmd display eq. | $\sum_{k=-N}^{N}a_k(x-x_0)^k=\sum_{k=0}^{N}a_k(x-x_0)^k$ | Follows from a_k = 0 for k < 0. | true |
| index.qmd | "is the degree-$N$ Taylor polynomial. That is what each frame draws, with $N$ increasing frame by frame; no frame contains a negative power" | The code loops n = 1..max_order and draws the degree-n polynomial. The frames show N = 1..10 (or 1..8) in the legend. | true |
| index.qmd | "Unless $f$ is entire (cases 08–11, 13–15 and 18–21)" | 08–11 are sin/cos, 13 is exp, 14 is e^{−x}cos x, 15 is cosh, 18 and 19 are J₀ and J₁, 20 is a Gaussian and 21 is the erf CDF: all entire. The rest have singularities: sqrt/log branch points (01–03, 05–07), the branch point at 1 (04), poles at ±π/2 (12), branch points at ±i (16) and ±1 (17), Γ poles at 0, −1, … (22–24), and the Y₀ log branch point at 0 (25–27). The list is exact. | true |
| index.qmd | "the series converges only within the distance from $x_0$ to the nearest singularity … and diverges beyond it" | Cauchy–Hadamard: R = distance to the nearest singularity. | true |
| index.qmd | "every such plotted interval reaches past that distance" | max \|x−x₀\| vs R for all 16 non-entire cases (`annulus.py`): 9.5/1, 6.5/4, 5.5/5, 1.5/1, 3.1/1, 2.5/2, 1.5/1, π/(π/2), 2/1, 1.5/1, 4.2/1, 3.2/2, 3.2/3, 12/10, 17/5, 20/2. All exceed R. | true |
| index.qmd | "Where the nearest singularity is a pole ($\tan x$ in case 12, $\Gamma(x)$ in cases 22–24)" | No other case has a pole as its nearest singularity: 04 is a branch point, 16/17 are branch points and 25–27 have a log branch point. | true |
| index.qmd | "a different Laurent series about $x_0$, with nonzero negative powers, holds in the annulus between that pole and the next singularity; the animations do not draw it" | The annuli are π/2 < \|z\| < 3π/2 (next poles ±3π/2), 1 < \|z−1\| < 2, 2 < \|z−2\| < 3 and 3 < \|z−3\| < 4 (next pole −1). Computed negative coefficients are listed under F1; all are nonzero. Not drawn: true. | true |
| script legend | "Laurent = Taylor, N = $(n)" | Correct (with the page's caveat that the identity holds on the disc). | true |
| script comment (render loop) | "Every case's f is analytic at x0, so the principal part vanishes … degree-n Taylor polynomial" | As above. | true |
| script comment (header of the new routine) | "Exact Taylor coefficients, correctly rounded to Float64 (same routine as the Padé page)" | Function bodies are byte-identical to `pade_animations_all.jl`. Correct rounding was verified for cases 22–27 (0 of 54 mismatches). | true |
| script comment | Hurwitz-zeta and Bessel-derivative formulas | Correct identities. The output matches the independent references to ≤ 1.5e-16. | true |
| script | `error("no Taylor coefficients …")` fallback | Unreachable for the 27 cases; the script runs to completion. | fine |

### New problems

None. This rests on four checks:
- every changed sentence and number in the ledger was checked independently (contour integrals, mpmath at 60 digits, and singularity distances);
- the coefficients of cases 22–27 are correctly rounded;
- the drawn curves were checked against true Taylor values by pixel read-off;
- old-vs-new pixel diffs show the GIFs of cases 01–21 changed only in the legend, and those of cases 22–27 changed only in the legend and in the predicted high-N frames.

A pre-existing observation, not introduced by this fix: the alt text is generic ("Laurent-series truncation animation for case NN.") and was not touched.

### Reproducibility and conventions

- I copied `laurent_animations_all.jl` to scratch and ran it with `julia`; it produced 27 GIFs.
- All 27 committed GIFs are byte-identical to that output (`cmp`).
- Conventions:
  - Description comes before Animations.
  - There is one source link, covering all cases, and one embed per case (27 embeds, all present).
  - There are no code blocks (0 code fences).
- No file outside the page folder was changed by this fix. The working tree also contains modifications under `pages/numerical-methods/maclaurin-and-taylor-series/`, which belong to a different page's fix. `pages/numerical-methods/index.qmd` is already committed in HEAD (188e4bd).

**Final status:** committed
