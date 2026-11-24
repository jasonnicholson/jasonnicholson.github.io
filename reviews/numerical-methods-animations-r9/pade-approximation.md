# Padé Approximation — animation review (round 9)

Page: `pages/numerical-methods/pade-approximation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0, Fidelity: 0.

I checked every frame of every case: 1614 Padé entries, 27 cases × 45 or 66 entries. Each one agrees with an independent exact or high-precision Padé computation, in both the rational function and the "(degenerate)" legend label. Every checkable claim on the page was confirmed. The MATLAB timing sentence and the remark about chebfun could not be checked under the rules of this review (see the ledger).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `pade_animations_all.jl` | 0 | 114.5 | 27 GIFs (pade01.gif … pade27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | $R_{m,n}=P_m/Q_n$, $Q_n(x_0)=1$ | Confirmed | `pade_linear` sets q0 = 1. Polynomials are in z = x − x0 (`render_case` L466). p has m+1 coefficients, so m is the numerator degree, matching the legend `[m/n]`. |
| D2 | "chooses coefficients so the Taylor expansion of $R_{m,n}$ about $x_0$ matches the target function through order $m+n$" / equivalently derivatives match for k=0..m+n | Confirmed | Toeplitz rows k=m+1..m+n (L347-354), then p from the convolution q*a (L363-370). Independent sympy/mpmath Padé built from the same definition agrees on all 1614 entries. The empirical order check (`order.py`) for diagonal and next-to-diagonal entries gives observed orders ≈ m+n+1 wherever the error is above Float64 noise (176 entries tested, 80 below noise and skipped). The three pre-asymptotic exceptions at h=0.2 reach the expected order at h=0.02. |
| D3 | "When Taylor coefficients vanish, as for even or odd functions or when $f(x_0)=0$, some entries $[m/n]$ have no such $R_{m,n}$" | Confirmed | Exact sympy `linsolve` is inconsistent for exactly the entries the script labels degenerate. Degenerate counts per case: 05:10, 07:10, 08:20, 09:15, 12:14, 14:2, 15:15, 16:20, 17:14, 18:15, 19:20, 20:15, 21:6. Cases 01-04, 06, 10, 11, 13 and 22-27 have none. |
| D4 | "Those frames show the lower-order entry that takes their place in the Padé table … and the legend says so, for example 'Padé [2/1] = [1/0] (degenerate)'" | Confirmed | The independent Frobenius (null-vector, reduced) form gives the same `[l/μ]` label in every degenerate frame. The exact string "[2/1] = [1/0] (degenerate)" occurs in cases 08, 12, 14, 16, 17, 19 and 21, and is visible in the pade12 contact sheet. |
| D5 | "for $\sqrt{x}$ about $x_0=5$, the $[4/6]$ system has condition number about $1.5\times10^{11}$" | Confirmed | Script's Float64 `cond(B)` = 1.5109e11. Independent 50-digit SVD of the exact matrix gives 1.51092e11. It is also the largest regular-system condition number in the table. |
| D6 | "that system is singular for some entries $[m/n]$, the degenerate entries described above" | Confirmed (for this table) | Every B with cond > 1e14 (min 4.73e16, case 20 [1/5]) is degenerate, and every degenerate entry has a singular B. No singular-but-consistent entry occurs (the branch at L434-435 is never taken). |
| D7 | MATLAB `pade` timings: [1/15], [1/16], [1/17] for e^x about 0 took about 7, 31 and 134 s in R2026a with 20-digit `vpa` | Could not determine | MATLAB is excluded from this review. Only the "20-digit vpa setting of the video script" part was checked: `pade_animation_code.m` L178-179 has `digits(20); vpa(...)`. |
| D8 | "`padeapprox` from chebfun also struggles" | Could not determine | Chebfun was not run. |
| D9 | General statements (Padé often converges where Taylor does not; rational functions have poles and asymptotes; Padé often stays accurate on larger intervals) | Confirmed qualitatively | Visible in the frames, e.g. pade12 (tan) diagonal entries reproduce both poles, and pade01/pade05 diagonal entries track √x and log on the whole window where the Taylor rows [k/0] diverge. |

### Animations section

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "Each animation shows one Padé order per frame for a fixed center $x_0$, overlaid on the target function" | Confirmed | `render_case`: one frame per (m,n), magenta f, blue Padé curve, red dot at (x0, f(x0)). |
| A2 | "step through every entry $[m/n]$ with $m+n\le 10$ ($m+n\le 8$ in Cases 12, 17 and 22–27)" | Confirmed | `max_total` is 8 for rows 12, 17 and 22-27, and 10 elsewhere. The committed GIFs have 66 frames (=11·12/2) and 45 frames (=9·10/2) respectively, per the manifest. |
| A3 | Mathews' animations "stepped along the diagonal (or next-to-diagonal) entries … up to total order 18, and marked a tolerance interval" | Confirmed (history; spot-checked) | Archive Padeaa.gif last frame is S₉,₉ (total 18) with "Tolerance ±0.001" bar. Padell.gif steps S₁,₁…S₅,₅ with a tolerance bar. |
| A4 | "[Julia source for all cases](pade_animations_all.jl)" plus the 27 per-case links | Confirmed | Every link points to the one script that writes `pade$(id).gif`. Committed GIFs are byte-identical to the regenerated ones (manifest). |
| C01-C27 | Heading function, x0 and interval for each case | Confirmed, all 27 | Checked row by row against `cases` (L24-50) and the GIF title text in every contact sheet. 01-03: √x at 1, 4, 5 on [0,10.5]. 04: 1/√(1−x) at 0 on [−1.5,1.5]. 05-06: log at 1, 2 on [−0.5,4.1]. 07: log(1+x) at 0 on [−1.5,1.5]. 08-09: sin, cos at 0 on [−3π,3π]. 10: sin at π/4 on [−7π/4,9π/4], title shows x0 = 0.7854. 11: cos at π/3 on [−5π/3,7π/3], title shows 1.0472. 12: tan at 0 on [−π,π]. 13: e^x at 0 on [−2,3]. 14: e^{−x}cos x at 0 on [−2,4]. 15: cosh at 0 on [−4,4]. 16: atan at 0 on [−2,2]. 17: asin at 0 on [−1.5,1.5]. 18-19: J0, J1 at 0 on [−10.2,10.2]. 20: normal pdf at 0 on [−3,3]. 21: ½+½erf(x/√2) at 0 on [−3,3]. 22-24: Γ at 1, 2, 3 on [−0.2,5.2]. 25-27: Y0 at 10, 5, 2 on [0,22]. |
| Alt-text ×27 | Function, centre and interval in each alt text | Confirmed | Each alt text matches its heading and its GIF. |
| Embeds ×27 | `pade01.gif` … `pade27.gif` in case order | Confirmed | Each GIF title shows its own case number. |
| Videos section | YouTube videos and their headings | Could not determine (out of scope) | The videos are MATLAB-generated and external. They are not GIF animations from these scripts. |

### Fidelity to the legacy archive

The archive is at `a2001/Animations/Interpolation/Pade/Pade.html`. I rendered its 27 formula/centre/interval image triples into `review/m1.png` and `review/m2.png`. All 27 rows match the page and the script exactly: the same functions, centres and intervals in the same order. The page states its departures from the archive explicitly: every entry up to total 10 or 8 rather than the diagonal up to 18, and no tolerance bar. These are not findings.

### 3. Implementation checks: `pade_animations_all.jl`

**Method.** This is the classical linearised Padé construction: q0 = 1, an n×n Toeplitz system for q1..qn, then p from the convolution of q and a. Where the system is singular and inconsistent (the [m/n] approximant does not exist), the script searches entries in increasing order for the reduced, Frobenius-form rational p/q whose block contains [m/n]. It shows that rational and labels it `[deg p/deg q] (degenerate)`. This is the standard Padé-table convention (Baker). The page describes the same thing.

**Numbers.**
- Taylor coefficients: I compared the script's `series_coeffs_analytic` with sympy exact series (cases 01-21) and with `mpmath.taylor` at 60 digits (Γ and Y0, cases 22-27). The maximum relative error per case is ≤ 2.1e-16, except cases 10 and 11 (1.5e-15 and 3.2e-15, from Float64 `sin(c+kπ/2)`), which is harmless. The zero pattern matches exactly in every case. The script's exact sin/cos at 0 give true zeros.
- Padé entries: `review/dump.jl` (an instrumented copy of the library part of the script) writes p, q, cond(B) and the label for all 1614 entries. `review/indep.py` and `review/indep2.py` compute each entry independently: exact sympy `linsolve` with a Frobenius null-vector fallback for cases 01-21, and 60-digit mpmath with an SVD singularity test for 22-27. `review/compare.py` cross-multiplies (P_script·Q_indep − P_indep·Q_script) and compares labels. Result: **flagged 0 of 1614**. Every label is identical, and every rational function agrees to a relative tolerance of 1e-10 or better (nothing above 1e-10 was printed).
- Order of contact: `review/order.py` gives an observed error order ≈ m+n+1 for diagonal and next-to-diagonal entries above Float64 noise (see D2).

**Reference values.** The "true" curve is the library function itself (`sqrt`, `log`, `besselj`, `gamma`, `bessely`, and so on), wrapped in `safe_eval`, which returns NaN outside the domain. The red dot is at f(x0). The magenta curve was checked visually against known shapes in the sheets: tan poles at ±π/2, Γ pole at 0, Y0 → −∞ at 0, asin undefined for |x|>1. All are correct.

**Picture.**
- Titles and legends show the case's function label, x0 rounded to 4 digits, and `Padé [m/n]` with the degenerate suffix where it applies. All were checked on the contact sheets of cases 01, 05, 08, 10, 12, 21, 22 and 27, and the titles of all 27.
- Display devices:
  - Padé values are clamped to one y-span beyond the axes (L477-478), so curves leave the frame instead of running along its edge.
  - Points with |Q| < 1e-8 are masked. Only 7 points in the whole table are masked (cases 05, 06, 07, 13, 14).
  - Poles appear as near-vertical connecting segments, which read as the asymptote.
  - `review/vis.jl` confirms that in every one of the 1614 frames at least 10% of the Padé curve lies inside the axes, so no frame hides its approximant. No display device changes what a viewer would conclude.
- The script's comment claim (L375-376), "regular cond ≤ 1.6e11, singular ≥ 4.7e16", is confirmed: 1.511e11 and 4.73e16.

