# Legendre Polynomials — animation review

Page: [`pages/numerical-methods/legendre-polynomials/index.qmd`](../../pages/numerical-methods/legendre-polynomials/index.qmd) · Scripts: `legendrepolyaa.jl`, `legendrepolybb.jl` · GIFs: 2

**Result:** 1 error, 1 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Implementation — Series coefficients from a coarse trapezoid rule; c_8 is wrong by a factor of 2 and the "max err" in the last two titles is wrong

- **Location:** `legendrepolybb.jl:27-36` (`legendre_coeff`, 1000-point trapezoid rule; the comment on line 27 says "Gauss-Legendre quadrature with many points"), and the frame title from line 58, shown in GIF frames 7–9.
- **Now:** The script computes c_n = (2n+1)/2 ∫ f P_n with a composite trapezoid rule, h = 2/999. That rule's O(h²) endpoint error is about (2n+1)/2 · (h²/12) · π ≈ 1.05e-6 · (2n+1)/2, and it grows with n while the true coefficients shrink quickly. Script values: c_6 = −1.337277e-3, c_8 = 8.214296e-6. The frame titles show max err 3.17e-5 for S_6 and S_7 (frames 7–8) and 2.35e-5 for S_8 (frame 9). So the computed series almost stops improving at N = 8.
- **True:** c_6 = −1.330456e-3 and c_8 = 1.713218e-5 (more than twice the script's value). With the true coefficients, the max error on the script's 500-point grid is 1.70e-5 for S_6 and S_7 and 1.32e-7 for S_8. The S_6 title is about 1.9× too large, and the S_8 title is about 180× too large. Titles for S_0 to S_5 (0.637, 0.0505, 0.00131) round correctly at 3 significant figures.
- **Evidence:**
  - `reviewer/bb_instr.jl` (instrumented copy) prints the script's coefficients and per-frame errors listed above.
  - `reviewer/indep.py` (mpmath `quad` with `mp.legendre`, 30 digits) gives c_0..c_10 = 0.636619772367581, 0, −0.687085270146032, 0, 0.0517789536762638, 0, −0.00133045638584257, 0, 1.71321795415561e-5, 0, −1.32370651434613e-7. It also gives the true S_N max errors on the script grid: 0.63662, 0.63662, 0.0504655, 0.0504655, 0.00131346, 0.00131346, 1.70005e-5, 1.70005e-5, 1.31692e-7. The residual f − S_8 is orthogonal to P_0..P_8 to below 1e-31.
  - `reviewer/closedform.py` confirms the coefficients against the closed form c_n = (2n+1)(−1)^{n/2} j_n(π/2) for even n, agreeing to 15 digits. The script's error c_trap − c_true for n = 0, 2, 4, 6, 8 is −5.2e-7, −2.6e-6, −4.7e-6, −6.8e-6, −8.9e-6. These match the predicted endpoint-correction magnitude (2n+1)/2 · h²π/12 exactly.
  - `reviewer/fixcheck.jl` runs the script's own `legendre_coeff` with npts = 1000, 10000 and 100000, giving c_8 = 8.21e-6, 1.704e-5 and 1.7131e-5. It also shows that exact coefficients give per-frame errors of 0.637, 0.637, 0.0505, 0.0505, 0.00131, 0.00131, 1.7e-05, 1.7e-05, 1.32e-07.
- **Suggested fix:** Replace the trapezoid rule with an accurate quadrature, or use the closed form. With SpecialFunctions (already in the environment): `coeffs = [isodd(n) ? 0.0 : (2n+1)*(-1)^(n÷2)*sphericalbesselj(n, π/2) for n in 0:n_max]`. Otherwise use Gauss–Legendre nodes or ≥ 1e5 trapezoid points. Fix the line-27 comment so it names the rule actually used. Frame titles will then read 1.7e-5 for frames 7–8 and 1.32e-7 for frame 9.

- **Independent check:** confirmed.

### F2 — Misleading — Page match — "Each added term refines the fit", but half the frames add a zero term and do not change

- **Location:** index.qmd:26, "Only even-$n$ terms contribute (since $f$ is even). Each added term refines the fit." Also the frame titles from `legendrepolybb.jl:58` ("2 terms", "4 terms", …).
- **Now:** The animation adds n = 0..8 one per frame. The odd terms are zero (script values ~1e-17), so frames 2, 4, 6 and 8 (S_1, S_3, S_5, S_7) are identical to the frames before them, with the same max err (0.637, 0.0505, 0.00131, 3.17e-5). Their titles still announce one more term ("2 terms", "4 terms", "6 terms", "8 terms").
- **True:** Only the even-n additions change the fit. The page contradicts itself: it says only even terms contribute, then says each added term refines the fit.
- **Evidence:** `reviewer/bb_instr.jl` output. Frame n=1 err 0.636619 equals n=0. n=3 equals n=2 (0.0504686), n=5 equals n=4 (0.00130559), and n=7 equals n=6 (3.16903e-5). The contact sheet `committed/legendrepolybb/sheet.png` shows identical pairs of panels.
- **Suggested fix:** Change the sentence to "Each added even-order term refines the fit; the odd-order terms are zero, so every second frame is unchanged." Alternatively, animate over even N only (0, 2, 4, 6, 8, 10) and count only the nonzero terms in the title.

- **Independent check:** confirmed with correction. Checker: frames 2, 4, 6 and 8 have the same curve and the same max err as the previous frame (they differ only in title and legend pixels). Misleading but minor in impact, since line 26 does say only even-n terms contribute.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `legendrepolyaa.jl` | yes | 2.8 | legendrepolyaa.gif |
| `legendrepolybb.jl` | yes | 3.1 | legendrepolybb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "illustrates Legendre polynomials $P_n(x)$ on $[-1,1]$" | Both scripts use x ∈ [−1,1], xlims (−1,1) | confirmed |
| 2 | 12 | "The first animation reveals $P_0$ through $P_5$ one per frame" | aa: `for n in 0:5`, 6 frames, each adds one curve (sheet.png) | confirmed |
| 3 | 12 | "the second shows the Legendre series partial sums converging to $f(x)=\cos(\pi x/2)$" | Curves visually converge. The computed max err stalls at 2.35e-5 (true 1.32e-7) because of the coefficient error | confirmed for the picture; the numbers behind it are wrong (→ F1) |
| 4 | 16 | Heading "Successive polynomials $P_0, P_1, \ldots, P_5$" | aa n_max = 5 | confirmed |
| 5 | 18 | "Each $P_n$ is orthogonal to all lower-degree Legendre polynomials on $[-1,1]$" | indep.py Gram matrix for n ≤ 5 is diagonal, diag 2/(2n+1) | confirmed |
| 6 | 18 | "$P_n(1)=1$, $P_n(-1)=(-1)^n$" | sympy n = 0..6, and script values at ±1 (aa_instr.jl) | confirmed |
| 7 | 18 | "$P_n$ has exactly $n$ zeros in $(-1,1)$" | sympy nroots n = 1..5: all real and inside (−1,1), e.g. P_5: 0, ±0.538469, ±0.906180 | confirmed |
| 8 | 18 | "computed by the recurrence $(n+1)P_{n+1} = (2n+1)xP_n - nP_{n-1}$" | Recurrence verified symbolically n = 1..5. Script line 20 is the same recurrence with k = n+1. Script output matches the explicit polynomials to 2e-15 (fixcheck.jl) | confirmed |
| 9 | 20, 22 | Case 1 link `legendrepolyaa.jl`, embed `legendrepolyaa.gif` | manifest: the GIF is produced by that script, byte-identical | confirmed |
| 10 | 22 | Alt: "P_0 through P_5 added one per frame on the interval [-1, 1], showing their oscillatory character" | Frames 1–6 | confirmed |
| 11 | 24 | Heading "Legendre series for $f(x)=\cos(\pi x/2)$" | bb line 38 `f(x) = cos(π * x / 2)` | confirmed |
| 12 | 26 | "$S_N(x)=\sum_{n=0}^N c_n P_n(x)$ with $c_n=\tfrac{2n+1}{2}\int_{-1}^1 f P_n\,dx$" | Formula is correct and is what bb lines 35 and 48–51 intend. The integral is evaluated too inaccurately for n ≥ 6 | formula confirmed; implementation wrong (→ F1) |
| 13 | 26 | "converges to $f$ as $N\to\infty$" | True for the exact series (c_10 ≈ −1.3e-7, errors fall rapidly; indep.py) | confirmed |
| 14 | 26 | "Only even-$n$ terms contribute (since $f$ is even)" | mpmath c_odd = 0 exactly; script c_odd ~1e-17 | confirmed |
| 15 | 26 | "Each added term refines the fit" | Odd terms are zero; frames 2, 4, 6, 8 are unchanged | wrong (→ F2) |
| 16 | 28, 30 | Case 2 link `legendrepolybb.jl`, embed `legendrepolybb.gif` | manifest: produced by that script, byte-identical | confirmed |
| 17 | 30 | Alt: "partial sums for cos(pi x/2) building up frame by frame, showing convergence to the true function" | Frames 1–9 | confirmed (half the frames are unchanged, see F2) |

## Implementation checks

### legendrepolyaa.jl
- **Method:** It evaluates P_n by the standard three-term recurrence P_k = ((2k−1)xP_{k−1} − (k−1)P_{k−2})/k, starting from P_0 = 1 and P_1 = x. This is the recurrence the page states.
- **Numbers:** Script values at x = −1, −2/3, −1/3, 0, 1/3, 2/3, 1 (`reviewer/aa_instr.jl`) match the sympy exact values (`reviewer/indep.py`):
  - P_3: 0.259259 / 7/27 and 0.407407 / 11/27
  - P_4: −0.427469 / −277/648 and 0.375 / 3/8
  - P_5: 0.305556 / 11/36
  - P_6: −0.017233 / −67/3888 and 0.193416 / 47/243

  Across 2001 points on [−1,1], the maximum difference from the explicit polynomials is ≤ 2.3e-15 for n = 0..5 (`reviewer/fixcheck.jl`). Orthogonality and the norms 2/(2n+1) were confirmed exactly with sympy.
- **Reference values:** None drawn. The zero line y = 0 is correct.
- **Picture:** I looked at frames 1–6 on the contact sheet and frame 6 at full size. Each frame adds the correct curve with a matching legend entry and title "P₀ … P_n". The visible extrema agree with the sympy extrema: P_2 min −0.5 at 0, P_3 ±0.447 at ∓0.447, P_4 −0.4286 at ±0.655 and 0.375 at 0, P_5 ±0.4197 at ∓0.765 and ±0.3466 at ±0.285. All curves end at 1 when x = 1 and at (−1)^n when x = −1. The legend box covers the convergence point near (1, 1); this is cosmetic and not misleading. ylims ±1.3 contain all curves.

### legendrepolybb.jl
- **Method:** Partial sums of the Legendre (orthogonal-projection / least-squares) series of cos(πx/2), N = 0..8, one term per frame. P_n uses the same correct recurrence. The coefficients come from a 1000-point composite trapezoid rule, not the Gauss–Legendre rule the comment on line 27 claims (→ F1).
- **Numbers:** Script coefficient beside true value (mpmath and closed form). c_odd is ~1e-17 in the script and 0 exactly.

  | n | script c_n | true c_n |
  |---|---|---|
  | 0 | 0.6366192477 | 0.6366197724 |
  | 2 | −0.6870878934 | −0.6870852701 |
  | 4 | 0.0517742319 | 0.0517789537 |
  | 6 | −1.337277e-3 | −1.330456e-3 |
  | 8 | 8.214296e-6 | 1.713218e-5 |

  The errors match the trapezoid endpoint-correction magnitude (2n+1)/2 · h²π/12 to the digits shown. Increasing npts to 1e5 reproduces the true c_8 (1.71313e-5).

  Per-frame max err, script beside true:

  | N | script max err | true max err |
  |---|---|---|
  | 0, 1 | 0.636619 | 0.636620 |
  | 2, 3 | 0.0504686 | 0.0504655 |
  | 4, 5 | 0.00130559 | 0.00131346 |
  | 6, 7 | 3.169e-5 | 1.700e-5 |
  | 8 | 2.348e-5 | 1.317e-7 |
- **Reference values:** The "true" curve f(x) = cos(πx/2) is evaluated directly and is correct. As an independent least-squares check, the residual of the true S_8 is orthogonal to P_0..P_8 (|⟨f − S_8, P_k⟩| < 1e-31).
- **Picture:** I looked at all 9 frames on the contact sheet and frame 9 at full size. The red dashed S_N and blue f are drawn on the same grid, and the legend shows S_N with the correct index. The visible fit is correct: the coefficient errors are about 1e-5 and invisible at this scale. The numeric title is wrong for frames 7–9 (F1), and frames 2, 4, 6 and 8 repeat the previous frame while the title still counts an extra "term" (F2). The title's "N+1 terms" counts the zero odd terms. ylims ±1.3 are fine.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/legendre-polynomials/`](evidence/legendre-polynomials/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
