# Padé Approximation — animation review (round 3)

Page: `pages/numerical-methods/pade-approximation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: garbled wording in the Description
- **Location:** `index.qmd` lines 12, 20 and 24.
  - Line 12: "a rationale function approximation", "Padé approximant is a rationale function", "Rationale functions can have…"
  - Line 20: "This really means derivatives match for give $m$ and $n$."
  - Line 24: "Total orders (denominator plus numerator order) of less than 20 fail at times for MATLAB's symbolic `pade` function fails."
- **What is there now:** "rationale" appears three times where the mathematical term is "rational". "for give" should read "for given". The MATLAB sentence has two verbs ("fail … fails") and cannot be parsed as a definite claim.
- **What is true instead:** the term is "rational function". The derivative statement is correct once the typo is fixed: f and R share derivatives of orders 0 … m+n at x0, which I confirmed for every non-degenerate frame (see §3).
- **How I know:** reading the text. I could not determine whether the MATLAB claim itself is true, because MATLAB was not run.
- **Suggested correction:**
  - Replace "rationale" with "rational" (3×).
  - Change "for give $m$ and $n$" to "for the given $m$ and $n$", or more precisely "$f^{(k)}(x_0)=R_{m,n}^{(k)}(x_0)$ for $k=0,\dots,m+n$".
  - Rewrite line 24's second sentence as a single claim, e.g. "MATLAB's symbolic `pade` sometimes fails even for total orders below 20."

No mathematical, numerical, wiring or fidelity errors were found. Everything else below was checked and passed.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Counts: Error 0, Misleading 0, Minor 1.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `pade_animations_all.jl` | 0 | 108.1 | 27 GIFs (pade01.gif … pade27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `pade01.gif` | 66 | byte-identical | pade_animations_all |
| `pade02.gif` | 66 | byte-identical | pade_animations_all |
| `pade03.gif` | 66 | byte-identical | pade_animations_all |
| `pade04.gif` | 66 | byte-identical | pade_animations_all |
| `pade05.gif` | 66 | byte-identical | pade_animations_all |
| `pade06.gif` | 66 | byte-identical | pade_animations_all |
| `pade07.gif` | 66 | byte-identical | pade_animations_all |
| `pade08.gif` | 66 | byte-identical | pade_animations_all |
| `pade09.gif` | 66 | byte-identical | pade_animations_all |
| `pade10.gif` | 66 | byte-identical | pade_animations_all |
| `pade11.gif` | 66 | byte-identical | pade_animations_all |
| `pade12.gif` | 45 | byte-identical | pade_animations_all |
| `pade13.gif` | 66 | byte-identical | pade_animations_all |
| `pade14.gif` | 66 | byte-identical | pade_animations_all |
| `pade15.gif` | 66 | byte-identical | pade_animations_all |
| `pade16.gif` | 66 | byte-identical | pade_animations_all |
| `pade17.gif` | 45 | byte-identical | pade_animations_all |
| `pade18.gif` | 66 | byte-identical | pade_animations_all |
| `pade19.gif` | 66 | byte-identical | pade_animations_all |
| `pade20.gif` | 66 | byte-identical | pade_animations_all |
| `pade21.gif` | 66 | byte-identical | pade_animations_all |
| `pade22.gif` | 45 | byte-identical | pade_animations_all |
| `pade23.gif` | 45 | byte-identical | pade_animations_all |
| `pade24.gif` | 45 | byte-identical | pade_animations_all |
| `pade25.gif` | 45 | byte-identical | pade_animations_all |
| `pade26.gif` | 45 | byte-identical | pade_animations_all |
| `pade27.gif` | 45 | byte-identical | pade_animations_all |

### Page references

- Scripts linked: `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`, `pade_animations_all.jl`
- GIFs embedded: 27
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description (method claims)
| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | "a rationale function approximation expanded from a function value and the derivative function values similar to Taylor Series" | confirmed (apart from the spelling, F1) | The script builds every frame only from the Taylor coefficients a_k = f^(k)(x0)/k! (`series_coeffs_analytic` → `pade_linear`). |
| D2 | "Padé approximant's can converge when Taylor Series does not even though both use the same information" | confirmed | Same coefficient vector for [N/0] and [N/2 / N/2]. Interval on which the error is < 1e-3 (`interval.py`): case 01 Taylor [10/0] [0.25, 1.87] vs Padé [5/5] [0.084, 7.23]; case 04 [−0.65, 0.58] vs [−1.5, 0.86]; case 16 [−0.68, 0.68] vs [−1.26, 1.26]; case 12 [8/0] [−0.69, 0.69] vs [4/4] [−1.28, 1.28]. |
| D3 | "Rationale functions can have singularities/vertical-asymptotes and horizontal asymptotes. Polynomials do not" | confirmed | General fact. The frames show the poles of R (e.g. pade01 [0/3] pole at x ≈ 2.5; pade12 [4/4] poles near ±π/2). |
| D4 | $R_{m,n}=P_m/Q_n$, $Q_n(x_0)=1$ | confirmed | `pade_linear` sets q = [1; qtail] in z = x − x0, so Q(x0) = 1. |
| D5 | "chooses coefficients so the Taylor expansion of $R_{m,n}$ about $x_0$ matches the target function through order $m+n$" | confirmed | The script solves the linearised condition Qf − P = O(z^{m+n+1}) with Q(0)=1, which is equivalent because Q is invertible near 0. For all 1,465 non-degenerate frames the independent 100-digit Baker approximant agrees with the plotted p/q to ≤ 6.7e-9 relative (worst: case 04 [4/5]). |
| D6 | "derivatives match for give m and n" | confirmed (wording F1) | Equivalent to D5. |
| D7 | "When Taylor coefficients vanish, as for even or odd functions or when f(x0)=0, some entries [m/n] have no such R" | confirmed | The independent rank test finds 176 entries with rank B < rank [B \| rhs]. They occur in cases 05 (10), 07 (10), 08 (20), 09 (15), 12 (14), 14 (2), 15 (15), 16 (20), 17 (14), 18 (15), 19 (20), 20 (15) and 21 (6). Every one of these cases has vanishing Taylor coefficients: f(x0)=0 for 05 and 07; even or odd for 08, 09, 12, 15–20; a2 = a6 = a10 = 0 for 14; odd part plus constant for 21. The cases with no vanishing coefficients (01–04, 06, 10, 11, 13, 22–27) have no degenerate entries. |
| D8 | "Those frames show the lower-order entry that takes their place in the Padé table, which matches f only to a lower order" | confirmed | For all 176 entries the script's reduced [l/μ] equals the degrees of the exactly cancelled Frobenius form (sympy). In every case l ≤ m and μ ≤ n, and the first non-zero power of Q̂f − P̂ is ≤ m+n, so contact is lower than m+n. The plotted curves match the exact reduced form to ≤ 1e-9. |
| D9 | "the legend says so, for example 'Padé [2/1] = [1/0] (degenerate)'" | confirmed | All 176 legend suffixes equal the independently computed " = [l/μ] (degenerate)". The exact example string appears for cases 08, 12, 14, 16, 17, 19 and 21 (e.g. the pade12 contact sheet). No non-degenerate frame carries a note. |
| D10 | "Padé approximants can represent poles and often stay accurate on larger intervals, especially for functions with nearby singularities or branch-point behavior" | confirmed | `interval.py`: diagonal Padé wins clearly in the branch-point and singular cases (01–07, 12, 16, 21, 22–24, 27). Taylor wins for the entire functions cos, cosh and J0, and for Y0 about 10. "Often/especially" is therefore accurate. |
| D11 | "for √x about x0=5, the [4/6] system has condition number about 1.5×10¹¹" | confirmed | Float64 `cond(B)` from the script = 1.5109e11, and the independent 100-digit 2-norm condition number = 1.5109e11. It is also the largest condition number of any regular system in the table. |
| D12 | "that system is singular for some entries [m/n], the degenerate entries described above" | confirmed | Every exactly singular B in the table is inconsistent, i.e. degenerate. There are no singular-but-consistent entries (`compare.py`: list empty). |
| D13 | MATLAB `pade` fails at times below total order 20; chebfun `padeapprox` "also struggles" | could not determine | External software, not run. The sentence is also garbled (F1). |
| V1 | Video headings (exp about 0 and 1, tanh about 0 and 0.5, arctan about 0 and 0.5, 1/x about 0.5, 1/(x−1) about 0.75, sin about 0 and 0.5, x/(x²+0.01²)^{1/4} about 0.5, Runge about 0 and 0.5) | confirmed against `pade_animation_code.m` (func / expansionPoint pairs, lines 5–101); video content could not determine | YouTube videos are external and were not viewed. |

### Animations section
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "Each animation shows one Padé order per frame for a fixed center x0, overlaid on the target function." | confirmed | `order_pairs` gives one [m/n] per frame over all m+n ≤ max_total, ordered by total and then by m: 66 frames for max_total 10 and 45 for max_total 8, matching the manifest frame counts exactly. There is one fixed `case.c` per GIF and the magenta f is drawn in every frame. |
| A2 | "[Julia source for all cases](pade_animations_all.jl)" | confirmed | The file exists, and a scratch run reproduces all 27 GIFs byte-identically (manifest). |
| C01 | √x, x0=1, [0,10.5] | confirmed | Row 24: `sqrt`, 1.0, (0,10.5). GIF title "f(x) = sqrt(x), x0 = 1.0"; x-axis 0–10.5. Legacy row 1 is identical. |
| C02 | √x, x0=4, [0,10.5] | confirmed | Row 25. Title x0 = 4.0. Legacy row 2. |
| C03 | √x, x0=5, [0,10.5] | confirmed | Row 26. Title x0 = 5.0. Legacy row 3. |
| C04 | 1/√(1−x), x0=0, [−1.5,1.5] | confirmed | Row 27. Title "1/sqrt(1-x), x0 = 0.0". Legacy row 4. |
| C05 | log x, x0=1, [−0.5,4.1] | confirmed | Row 28. Title. Legacy row 5. |
| C06 | log x, x0=2, [−0.5,4.1] | confirmed | Row 29. Title. Legacy row 6. |
| C07 | log(1+x), x0=0, [−1.5,1.5] | confirmed | Row 30. Title. Legacy row 7. |
| C08 | sin x, x0=0, [−3π,3π] | confirmed | Row 31. Title; axis ±9.42. Legacy row 8. |
| C09 | cos x, x0=0, [−3π,3π] | confirmed | Row 32. Title. Legacy row 9. |
| C10 | sin x, x0=π/4, [−7π/4,9π/4] | confirmed | Row 33. Title "x0 = 0.7854" (= π/4 to 4 dp). Legacy row 10. |
| C11 | cos x, x0=π/3, [−5π/3,7π/3] | confirmed | Row 34. Title "x0 = 1.0472" (= π/3). Legacy row 11. |
| C12 | tan x, x0=0, [−π,π] | confirmed | Row 35 (max_total 8, 45 frames). Title; axis ±3.14. Legacy row 12. |
| C13 | eˣ, x0=0, [−2,3] | confirmed | Row 36. Title "exp(x)". Legacy row 13. |
| C14 | e^{−x}cos x, x0=0, [−2,4] | confirmed | Row 37. Title "exp(-x)*cos(x)". Legacy row 14. |
| C15 | cosh x, x0=0, [−4,4] | confirmed | Row 38. Title. Legacy row 15. |
| C16 | arctan x, x0=0, [−2,2] | confirmed | Row 39. Title "atan(x)". Legacy row 16. |
| C17 | arcsin x, x0=0, [−1.5,1.5] | confirmed | Row 40 (max_total 8). Title "asin(x)". Legacy row 17. |
| C18 | J0, x0=0, [−10.2,10.2] | confirmed | Row 41. Title "besselj(0,x)". Legacy row 18. |
| C19 | J1, x0=0, [−10.2,10.2] | confirmed | Row 42. Title "besselj(1,x)". Legacy row 19. |
| C20 | (2π)^{−1/2}e^{−x²/2}, x0=0, [−3,3] | confirmed | Row 43. Title "normal_pdf(x)", whose definition in the code is exp(−x²/2)/√(2π). Legacy row 20. |
| C21 | ½+½ erf(x/√2), x0=0, [−3,3] | confirmed | Row 44. Title "normal_cdf(x)", code 0.5+0.5·erf(x/√2). Legacy row 21. |
| C22 | Γ, x0=1, [−0.2,5.2] | confirmed | Row 45 (max_total 8). Title "gamma(x), x0 = 1.0". Legacy row 22. |
| C23 | Γ, x0=2, [−0.2,5.2] | confirmed | Row 46. Legacy row 23. |
| C24 | Γ, x0=3, [−0.2,5.2] | confirmed | Row 47. Legacy row 24. |
| C25 | Y0, x0=10, [0,22] | confirmed | Row 48. Title "bessely(0,x), x0 = 10.0". Legacy row 25. |
| C26 | Y0, x0=5, [0,22] | confirmed | Row 49. Legacy row 26. |
| C27 | Y0, x0=2, [0,22] | confirmed | Row 50. Legacy row 27. |
| ALT | 27 image alt texts (function, centre and, where given, interval) | confirmed | Each alt text matches its heading and row, e.g. pade04 "one over square root of one minus x centered at zero" and pade10 "sin(x) centered at pi over 4". |
| LNK | 27 per-case "[Julia source](pade_animations_all.jl)" links | confirmed | The single script produces every case. |
| EMB | Embed `padeNN.gif` under "Case NN" for NN = 01…27 | confirmed | The output name is `"pade$(case.id).gif"` and the ids run "01"…"27" in heading order. The titles in `review/titles.png` (frame 2 of every GIF) read "Padé Case NN" with the matching function and x0. |

### Fidelity to the legacy archive
- All 27 legacy animation rows (function, centre, interval: `review/legacy_table.png`) match the page headings and the script rows exactly, and no legacy case is dropped.
- The one difference is in presentation, not a finding. Legacy `Padeaa.gif` steps only through the diagonal entries S_{1,1} … S_{8,8} and draws a "Convergence Intervals, tolerance ±0.001" bar. The new GIFs step through the whole Padé table up to total order 10 (or 8) and have no tolerance bar. This is a valid alternative presentation, and the page does not claim to show convergence intervals.

### 3. Implementation checks (`pade_animations_all.jl`)

**Method is what it claims.** The script builds the Baker Padé approximant [m/n] with Q(x0)=1:
- It solves the n×n Toeplitz system for q1…qn, rows k = m+1…m+n with B[r,j] = a_{m+r−j} and rhs = −a_{m+r}.
- It then forms p_i = Σ q_j a_{i−j}.

When B is singular (cond > 1e14), it replaces the entry with the top-left entry of its Padé-table block (the reduced Frobenius form) and labels it. This is the standard formulation and agrees with the Description.

One latent path is never exercised. If B were singular but the system consistent, `pade_from_series` returns the `B \ rhs` / `pinv` solution rather than the reduced form. On this table no entry is singular-and-consistent, so this does not affect any frame.

**Numbers are right.**
- **Taylor coefficients:** the script's Float64 a_k agree with the independent exact/100-digit values to a maximum relative error of 3.2e-15 (cases 10 and 11, which use sin(c+kπ/2) in Float64) and ≤ 1.3e-16 for every other case. Exact zeros are exact zeros in every case (for 08 and 09 because `taylor_coeffs_exact` is used).
- **Singular/regular classification:** the largest Float64 cond among exactly regular systems is 1.511e11 (case 03 [4/6]); the smallest among exactly singular ones is 4.73e16 (case 20 [1/5]). The 1e14 threshold sits in a gap of five orders of magnitude, so the classification is right for all 1,641 frames. This also confirms the code comment at lines 375–376.
- **Degenerate labels:** 176/176 match the independent exact computation (0 mismatches).
- **Curves:** over all 1,641 frames, the maximum of |R_indep − p/q_script| / (1+|R_indep|) on 201 points per frame, excluding points with |R| > 1e3 next to poles, is 6.7e-9 (case 04 [4/5]). No other frame exceeds 4.2e-10.

**Reference values are right.** The magenta curves use Julia `sqrt`, `log`, `sin`, `tan`, `exp`, `cosh`, `atan`, `asin`, `besselj`, `bessely`, `erf` and `gamma`. Against mpmath at 40 digits on 129 sampled grid points per case, the maximum relative error is 1.9e-16 in every case. The NaN pattern also matches: NaN exactly where f is undefined or non-real (log at x ≤ 0, 1/√(1−x) at x ≥ 1, asin at |x| > 1, Y0 at 0).

**Picture shows what was computed.**
- The blue curve is p(x−x0)/q(x−x0) of the computed or reduced entry. The red dot is at (x0, f(x0)). The legend shows [m/n] plus the degeneracy note, and the title shows the row's function label and x0.
- I checked contact sheets for 01, 05, 08, 12, 22 and 25 and the frame-2 crops of all 27.
- **Display devices:**
  - The blue curve is clamped to ylims. Where an approximant leaves the window it runs along the border, and across a pole it draws a vertical line.
  - In the most visible instance (pade01 [0/3]) the curve lies on y = 0 for x > 2.5. The true values there are −1.0, −0.067, −0.014 and −0.005 at x = 3, 5, 7.5 and 10, so the drawn line misrepresents nothing material.
  - Elsewhere the line on the border reads as "off scale".
  - NaN masking only at |q| < 1e-8 is harmless.
  - I found no frame where clamping changes what a viewer would conclude.
- **Small spikes:** the blips in pade25 [0/7] and [2/1] near x ≈ 9.6–9.9 are genuine poles of R. They appear because Y0(10) ≈ 0.056 is close to the zero of Y0 at 10.22, and they agree with the independent curve.
- **Frame counts:** 66 frames for every max_total = 10 case and 45 for every max_total = 8 case (12, 17, 22–27), matching the manifest.

