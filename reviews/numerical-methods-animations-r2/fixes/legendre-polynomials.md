# Fix record: legendre-polynomials

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/legendre-polynomials/fix/`
(`indep.py` = independent mpmath/scipy check; `bb_instr.jl` = instrumented copy of the fixed script; `legacy/` = rendered archive images; `frames_bb/`, `frames_bb_final/` = extracted frames of the new GIF.)

## Findings

### F1 — Minor (Fidelity) — fixed

- **Reproduced:** `legendrepolybb.jl` line 43 was `f(x) = cos(π * x / 2)`. The archive's Example 8 (the module's only Legendre-series example on [-1, 1]) uses 8(a) `f[x] = e^x` (`LegendrePolyMod_gr_324.gif`) and 8(b) `f[x] = e^x Cos[pi/2 x]` (`gr_325.gif`). I rendered both statement images at 4x (`legacy/gr_324.png`, `legacy/gr_325.png`) and read them. cos(pi x/2) is even, so its odd coefficients are zero; the old page said so correctly but did not say why it departed from Mathews.
- **Decision:** R2-A says to follow Mathews when the departure is a parameter of an existing case, and the function is listed as one. Switching to Mathews' function does not make the page wrong and does not undo a round-1 fix. I chose 8(b) e^x cos(pi x/2) over 8(a) e^x for three reasons: the review suggested it first; it keeps the cos(pi x/2) factor of the existing case; and it fits the existing ylims (-1.3, 1.3), whereas e^x reaches 2.718 and would need new limits.
- **Change:**
  - `legendrepolybb.jl`:
    - header comment lines 2–4 rewritten;
    - line 44 `f(x) = cos(π * x / 2)` → `f(x) = exp(x) * cos(π * x / 2)`;
    - title text `cos(πx/2)` → `exp(x)cos(πx/2)`, plus `titlefontsize=12`, because at the default size the longer title clipped its closing parenthesis (seen in the first regeneration, frame 1);
    - `legend=:topright` → `legend=:bottomright`, because the top-right legend covered the peak of the new f (about 1.21 at x ≈ 0.36);
    - legend label `f(x) = cos(πx/2)` → `f(x) = exp(x)cos(πx/2)`.
  - `index.qmd`: the intro sentence (line 12), the Case 2 heading (line 24), the Case 2 Behavior paragraph (line 26) and the Case 2 alt text (line 30) are updated to the new function and its computed numbers.
- **Check:**
  - The script's coefficients (`julia bb_instr.jl`) agree with mpmath 30-digit quadrature (`/usr/bin/python3 -I indep.py`) to about 1e-14 for every c_n, n = 0…8 (table below).
  - The max errors agree on the script's 500-point grid and on an independent 200001-point grid; the maximum is always at x = ±1, which is on the script's grid.
  - The new GIF has 9 frames. The title values match the computed errors at 3 s.f. (see Scripts and GIFs).

| n | script c_n | mpmath c_n |
|---|---|---|
| 0 | 0.6990438437957872 | 0.699043843795788 |
| 1 | 0.38753580939387533 | 0.387535809393875 |
| 2 | -0.6465040300987617 | -0.646504030098766 |
| 3 | -0.39721354789070035 | -0.397213547890703 |
| 4 | -0.0562969811584088 | -0.0562969811584083 |
| 5 | 0.009316251038287279 | 0.00931625103829338 |
| 6 | 0.0037753858196282524 | 0.0037753858196378 |
| 7 | 0.000368653487362814 | 0.000368653487357218 |
| 8 | -1.764768765977293e-5 | -1.76476876689254e-5 |

| N | max err script (500 pts) | max err independent (200001 pts), location | L2 error (mpmath) |
|---|---|---|---|
| 0 | 0.6990438437957872 | 6.990438e-01 at x=-1 | 0.559564 |
| 1 | 1.0865796531896623 | 1.086580e+00 at x=+1 | 0.461507 |
| 2 | 0.4400756230909007 | 4.400756e-01 at x=+1 | 0.214014 |
| 3 | 0.062217552193850535 | 6.221755e-02 at x=-1 | 0.0268755 |
| 4 | 0.013434905958208447 | 1.343491e-02 at x=+1 | 0.00424164 |
| 5 | 0.004118654919921168 | 4.118655e-03 at x=+1 | 0.00148695 |
| 6 | 0.0003797058167827041 | 3.797058e-04 at x=-1 | 0.000134769 |
| 7 | 2.5384387069898397e-5 | 2.538439e-05 at x=+1 | 6.48757e-6 |
| 8 | 7.736699410125464e-6 | 7.736699e-06 at x=+1 | 2.3342e-6 |

The max error is not monotone: it rises from N=0 to N=1, then falls strictly for N = 1…8. The L2 error falls at every step, as an orthogonal projection must.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.12 | "converging to $f(x) = e^{x}\cos(\pi x/2)$" | script line 44 `f(x) = exp(x) * cos(π * x / 2)`; frames show S_N approaching f; max err → 7.74e-6 at N=8 (`bb_instr.jl`) | yes |
| index.qmd l.24 heading | "Legendre series for $f(x) = e^{x}\cos(\pi x/2)$" | same as above; GIF title/legend show exp(x)cos(πx/2) (frames 1–9 viewed) | yes |
| index.qmd l.26 | "This $f$ is the function of Mathews' Example 8(b)" | archive `LegendrePolyMod.html` l.397 / `_lnk_17.html` "8 (b). Use the function" + `gr_325.gif` rendered → "f[x] = e^x Cos[π/2 x]" | yes |
| index.qmd l.26 | "it is neither even nor odd" | `indep.py`: f(0.5)=1.165822, f(-0.5)=0.42888194; neither equal nor negatives | yes |
| index.qmd l.26 | "every coefficient $c_0, \ldots, c_8$ is nonzero, so each frame adds a new term" | c_n table above: smallest magnitude is c_8 = -1.76e-5 ≠ 0 (script and mpmath agree); the script adds one term per frame, `for n in 0:n_max` with n_max = 8 | yes |
| index.qmd l.26 | "Because $S_N$ minimises the integrated squared error rather than the maximum error, the max error need not fall at every step" | S_N is the L2 orthogonal projection (c_n formula, ‖P_n‖² = 2/(2n+1)); computed L2 error falls at every N (0.5596 → 0.4615 → … → 2.33e-6), while the max error rises at N=1 (table) | yes |
| index.qmd l.26 | "it rises from 0.699 for $S_0$ to 1.09 for $S_1$" | script 0.6990438…, 1.0865796…; independent 0.6990438, 1.086580 → 0.699, 1.09 | yes |
| index.qmd l.26 | "then falls with each added term to $7.74\times 10^{-6}$ for $S_8$" | N=1…8 errors 1.087, 0.440, 0.0622, 0.0134, 0.00412, 3.80e-4, 2.54e-5, 7.74e-6, strictly decreasing (script and independent); 7.736699e-6 → 7.74e-6 | yes |
| index.qmd l.30 alt text | "S_0 through S_8 for e^x cos(pi x/2), one per frame; every coefficient is nonzero, and the max error rises from 0.699 for S_0 to 1.09 for S_1, then falls with each added term to 7.74e-6 for S_8" | 9 frames, titles S_0…S_8; the numbers and monotonicity are as in the rows above | yes |
| legendrepolybb.jl header l.2–4 | "exp(x)cos(πx/2) (the function of Mathews' Example 8(b)) … f is neither even nor odd, and every coefficient c_0 ... c_8 is nonzero" | as in the rows above | yes |
| GIF title (per frame) | "Legendre Series for exp(x)cos(πx/2) — S_n(x)  (max err = …)": 0.699, 1.09, 0.44, 0.0622, 0.0134, 0.00412, 0.00038, 2.54e-5, 7.74e-6 | `bb_instr.jl` `round(e, sigdigits=3)`: identical list. 0.44 and 0.00038 are the 3-s.f. values 0.440 and 0.000380 with the trailing zero dropped by `round`, so they are not false | yes |
| GIF legend | "f(x) = exp(x)cos(πx/2)", "S_n(x)" | frames viewed | yes |

## Scripts and GIFs

- Script changed: `legendrepolybb.jl` (function, title, title font size, legend position and label, header comment). `legendrepolyaa.jl` and `legendrepolyaa.gif` are untouched.
- Regenerated: `legendrepolybb.gif` (9 frames). The last run was after a comment-only edit, and its decoded frames (framemd5) are identical to the previous run's (`diff frames_bb/frames.md5 frames_bb_final/frames.md5` → identical).
- Frames viewed:
  - Frames 1 and 2 at full size in the first regeneration: the title was clipped and the legend covered the peak of f, which led to the font-size and legend fixes.
  - After the fix, frames 2 and 9 at full size and the contact sheet of all 9 frames.
  - In every frame the title fits and the S_n index in the title matches the legend.
  - The max error values are as listed. The bottom-right legend overlaps no curve: the minimum of every S_N is ≥ -0.335, reached at x=-1, and f ≥ 0.
  - S_0 is flat at 0.699. S_1 is the line ending at 1.09 at x=1. S_2 dips to -0.335 at x=-1. From S_4 on, S_N and f coincide visually.
- `git status --short -- pages/numerical-methods/legendre-polynomials` after regeneration: `M index.qmd`, `M legendrepolybb.gif`, `M legendrepolybb.jl`.

## Legacy archive

- **Consulted:** `n2003/LegendrePolyMod.html`, `Links/LegendrePolyMod_lnk_16.html` (8a) and `_lnk_17.html` (8b), read as text. I rendered these images: `gr_323` (interval), `gr_324` and `gr_325` (functions), `gr_326` (8(a) Mathematica code), and `gr_330` and `gr_333` (8(a) coefficients and terms).
- **What it showed:**
  - Example 8 compares the discrete interpolation polynomial with the Legendre series on [-1, 1], for 8(a) e^x and 8(b) e^x cos(pi x/2).
  - The 8(a) code uses order n = 4. Its printed coefficients, c_0 = 1.1752, c_1 = 1.10364, c_2 = 0.357814, c_3 = 0.0704556 and c_4 = 0.00996513, agree with my mpmath values (1.1752012, 1.1036383, 0.3578144, 0.0704556, 0.0099651).
  - The 8(b) solution images (`gr_336`–`gr_345`) are **missing** from the archive. So the order Mathews used for 8(b), and his plot of it, could not be checked; only the 8(b) function statement is available.
  - There is no legacy animated GIF for this topic in `a2001/Animations/`. The only "Legendre" item there is Quadrature/GaussLegendre, a different page.
- **Differences from the fixed page:**
  - The page animates the 8(b) function with partial sums S_0…S_8. Mathews' Example 8 compares a single order (n = 4 in 8(a)) against the interpolation polynomial.
  - The page shows the Legendre-series sequence only, not the interpolation comparison. That is the structure of the existing case, which I kept.

## Notes

- R2-A "add one sentence when a whole example is left out": the module's other examples (discrete versus continuous least squares, inner products, Gram–Schmidt, the shifted Legendre series, and the interpolation-polynomial comparison of Example 8) are not animated on this page. The finding does not name this, so I added no left-out sentence. The director may want one under R2-A.
- The page has no `## Description` section (a pre-existing convention gap that no finding names), so I did not add one.
- I did not touch the reviewer's non-findings: the Case 1 legend over the (1,1) region, and the mixed "P₀ … P_5" subscript style in the `legendrepolyaa.gif` title.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence (archive): `LegendrePolyMod.html` Example 8: "Compare the discrete interpolation polynomial and Legendre series approximation on the interval [-1, 1]", 8(b) "Use the function" `LegendrePolyMod_gr_325.gif`. I rendered gr_323 and gr_325 at 4x (`check/a323.png`, `check/a325.png`): they read "[-1, 1]" and "f[x] = e^x Cos[pi/2 x]". `Links/LegendrePolyMod_lnk_17.html` is "Solution 8 (b)" for that function. So the new f(x) = e^x cos(pi x/2) on [-1,1] is Mathews' Example 8(b). This follows R2-A ("follow Mathews" for a function parameter).
- Evidence (script): `legendrepolybb.jl` line 44 is now `f(x) = exp(x) * cos(π * x / 2)`. Nothing else in the computation changed (recurrence, 20-point Golub-Welsch Gauss-Legendre, c_n = (2n+1)/2 ∫ f P_n, S_N = Σ c_k P_k, max error on a 500-point grid). The plot title, curve label and legend position changed, and so did `titlefontsize=12`.
- Evidence (GIF): the committed GIF is byte-identical to my scratch rerun (sha256 ab4bfecc…). The per-frame max errors in the titles are 0.699, 1.09, 0.44, 0.0622, 0.0134, 0.00412, 0.00038, 2.54e-5 and 7.74e-6. They match my independent mpmath values (below) to 3 s.f. in every frame. The curves are visibly e^x cos(pi x/2), with f(±1)=0 and a peak of about 1.21 near x≈0.36.
- The old even-function effect (repeated frames) no longer exists, and the page no longer claims it. Every frame now adds a visible term.

### Changed-text ledger

Independent reference: mpmath at 40 digits, c_n = (2n+1)/2 · quad(f·P_n, [-1,0,1]). Max error = sup over [-1,1], from a 4001-point grid refined with bounded scalar minimisation, cross-checked on the script's 500-point grid (the two agree; every maximum is at x = ±1). Script `check/coef.py`.

c_0..c_8 = 0.699044, 0.387536, −0.646504, −0.397214, −0.0562970, 0.00931625, 0.00377539, 0.000368653, −1.76477e-5. Sympy closed form c_0 = 2π cosh(1)/(4+π²) = 0.699044.

Max error of S_0..S_8 = 0.699044, 1.086580, 0.440076, 0.0622176, 0.0134349, 0.00411865, 0.000379706, 2.53844e-5, 7.73670e-6.

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd intro | "partial sums converging to f(x) = e^x cos(πx/2)" | Matches the script's f; convergence seen in the frames (error 7.7e-6 at S_8) | OK |
| index.qmd Case 2 heading | "Legendre series for f(x) = e^x cos(πx/2)" | Same as the script | OK |
| Behavior | "This f is the function of Mathews' Example 8(b)" | Archive gr_325 = e^x Cos[π/2 x], gr_323 = [-1,1] | OK |
| Behavior | "neither even nor odd" | f(.5)+f(−.5)=1.595≠0 and f(.5)−f(−.5)=0.737≠0 | OK |
| Behavior | "every coefficient c_0, …, c_8 is nonzero" | Smallest is \|c_8\| = 1.76e-5, far above round-off. Sympy closed forms for c_0, c_1, c_2 are nonzero. | OK |
| Behavior | "S_N minimises the integrated squared error rather than the maximum error, the max error need not fall at every step" | Standard L² best-approximation property, and true; the S_0→S_1 rise is a concrete instance | OK |
| Behavior / alt | "0.699 for S_0" | 0.699044 (= c_0, at x = ±1 where f = 0) | OK |
| Behavior / alt | "rises … to 1.09 for S_1" | 1.086580 at x = 1 → 1.09 | OK |
| Behavior / alt | "then falls with each added term" | 1.087 > 0.440 > 0.0622 > 0.0134 > 0.00412 > 0.000380 > 2.54e-5 > 7.74e-6: strictly decreasing from S_1 to S_8 | OK |
| Behavior / alt | "7.74×10⁻⁶ for S_8" | 7.73670e-6 → 7.74e-6 | OK |
| alt text | "partial sums S_0 through S_8 for e^x cos(pi x/2), one per frame; every coefficient is nonzero" | 9 frames, S_0..S_8 | OK |
| GIF title (each frame) | "Legendre Series for exp(x)cos(πx/2) — S_n(x) (max err = …)" | Values per frame as listed under F1; all match | OK |
| GIF legend | "f(x) = exp(x)cos(πx/2)", "S_n(x)" | Correct | OK |
| Script header comments | "Mathews' Example 8(b) … neither even nor odd, every coefficient c_0 … c_8 is nonzero" | As above | OK |

### New problems

None. This rests on the following checks:
- every number recomputed independently and matched;
- the archive function verified from the rendered images;
- full-size frames 1, 2, 3, 5, 6 and 9 viewed, plus the contact sheet of all 9. The title fits at fontsize 12 even in the longest frames ("max err = 0.00412" / "0.00038"), with nothing clipped. f peaks at ≈1.21, inside ylims ±1.3. S_2's dip to −0.335 at x = −1 is inside the limits. The bottom-right legend sits at y ≈ −1.0…−1.2, a region no curve enters in any frame, so it overlaps nothing.

Observations, not findings:
- Mathews' Example 8 compares the Legendre series with the discrete interpolation polynomial. The page shows only the series. The function parameter now follows Mathews, which is what R2-A asks for, and the original finding did not ask for the comparison.
- "minimises" uses British spelling. Cosmetic.
- Pre-existing, not introduced by this fix: the page has no `## Description` section before `## Animations`, which `animation-page.agent.md` requires (lines 12, 205). The HEAD version also lacks it, and neither the original review nor this fix touched it.

### Reproducibility and conventions

- I copied `legendrepolybb.jl` to `check/run/` and ran `julia run/legendrepolybb.jl`. The output GIF has sha256 ab4bfecc3c0864ed51483f9ec370d972ea43b1878758fffa2e165a34200d9308, byte-identical to the committed GIF (matching the LFS oid in the diff). The decoded frame md5s are identical as well (9 frames).
- Case 2 still has a source link and an embed, the alt text is descriptive, and there are no code blocks (0 fences). The Description section is missing (pre-existing; see above).
- `fix.diff` touches only `index.qmd`, `legendrepolybb.jl` and `legendrepolybb.gif` in the page folder; `legendrepolyaa.*` is unchanged. Other pages in the working tree show modifications from the parallel round-2 fixers. The fix record `reviews/numerical-methods-animations-r2/fixes/legendre-polynomials.md` is untracked, as the fix process expects; I did not read it.

**Final status:** committed
