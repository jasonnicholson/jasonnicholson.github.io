# Padé Approximation — animation review (round 6)

Page: `pages/numerical-methods/pade-approximation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Implementation (display): off-scale parts of the approximant are drawn along the plot border, so they look like a curve that levels off at the axis limit (Minor)

- **Where:** `pade_animations_all.jl` line 475, `ypad = clamp.(ypad, case.ylims[1], case.ylims[2])`.
- **What is there now:** every value of the approximant above or below the y-limits is replaced by the limit itself. Plots then draws those points as a steel-blue line lying on the top or bottom edge of the frame.
  - `pade08.gif` frame 55 is sin(x), Padé [9/0], a Taylor polynomial. The blue curve runs flat along y = 1.5 from x ≈ 5.5 to 3π and along y = −1.5 from −3π to x ≈ −5.2. A degree-9 polynomial actually reaches |y| ≈ 10² there.
  - Other examples: `pade01.gif` [9/0] runs along the top from x ≈ 2.9 to 10.5. `pade22.gif` [5/0] runs along the bottom from x ≈ 2.8 to 5.2, and [8/0] along the top.
- **What is true instead:** the approximant leaves the plotting window. It does not level off at the axis limit.
- **How I know:** I counted the frames in `julia_grid.txt` (the unclamped curves) in which more than 10 % of the x-range lies outside the y-limits. The count is 524 of 1614 frames, spread over 26 of the 27 cases; case 24 is the only one without such a frame. The per-case counts are in the session commands. Each one is a frame where a long stretch of curve lies on the frame edge. A viewer can read this as the approximant saturating, although most readers will guess that it has gone off-scale. Nothing on the page relies on the behaviour off-scale, so the impact is small.
- **Suggested correction:** do not clamp to the axis limits themselves. One option is to set values outside a margin to NaN, for example `ypad[(ypad .< lo - 2span) .| (ypad .> hi + 2span)] .= NaN`, and let Plots clip the rest at the axes. The other is to clamp to a widened band such as `[lo - span, hi + span]`, so the line visibly leaves the frame. A related point, not a separate finding: the target curve `ytrue` is not masked at the true poles of tan(x) (±π/2, case 12) and Γ(x) (x = 0, cases 22–24). Plots joins the samples on either side, so a magenta vertical line is drawn across the plot at each pole. This reads as an asymptote marker and is conventional, but the same NaN mask would remove it if wanted.

No other findings. Every computed number, every legend label (including all 176 "(degenerate)" labels), every title, and every heading, caption and wiring entry checked out. See below.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


Count: Error 0, Misleading 0, Minor 1.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `pade_animations_all.jl` | 0 | 108.6 | 27 GIFs (pade01.gif … pade27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description (method statements)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | "$R_{m,n}=P_m/Q_n$, $Q_n(x_0)=1$ … Taylor expansion of $R_{m,n}$ about $x_0$ matches the target function through order $m+n$" | confirmed | The script imposes q0 = 1 and solves the Toeplitz equations for orders m+1…m+n (`pade_linear`, l.340–373). For every non-degenerate entry in all 27 cases, the residual of q·f − p at orders 0…m+n, taken against my independent coefficients, is ≤ 1.6e-15 relative (`compare_out.txt`, last column). |
| D2 | "Equivalently, $f^{(k)}(x_0)=R^{(k)}_{m,n}(x_0)$ for $k=0,\dots,m+n$" | confirmed | Mathematically equivalent to D1, since Q(x0) ≠ 0. |
| D3 | "When Taylor coefficients vanish, as for even or odd functions or when $f(x_0)=0$, some entries $[m/n]$ have no such $R_{m,n}$" | confirmed | My exact sympy Padé table finds 176 non-existent entries, all in cases with vanishing coefficients: 05 and 07 (f(x0) = 0); 08, 09, 12 and 15–20 (odd or even); 14 (a2 = a6 = 0); 21 (even coefficients from k = 2 vanish). The cases without vanishing coefficients (01–04, 06, 10, 11, 13, 22–27) have none. The mpmath determinants for 06, 11 and 22–27 are ≥ 3e-13 relative, far from zero. |
| D4 | "Those frames show the lower-order entry that takes their place in the Padé table, which matches $f$ only to a lower order, and the legend says so" | confirmed | For all 176 entries the script's legend note equals `" = [dp/dq] (degenerate)"`, where (dp, dq) are the degrees of the exactly reduced Frobenius solution (sympy `gcd` of the null-space p and q). There are 0 mismatches. The plotted curve equals the exact reduced approximant to ≤ 1.1e-13 of the y-span. |
| D5 | Example label "Padé [2/1] = [1/0] (degenerate)" | confirmed | Present for sin (08), tan (12), atan (16), asin (17), J1 (19) and the normal CDF (21). For sin, the exact [2/1] reduces to x = [1/0]. |
| D6 | "Padé approximants can represent poles and often stay accurate on larger intervals" than a Taylor polynomial of the same total order | confirmed (qualitative) | Frames show it. In `pade12` the [4/4] places poles at ±π/2 and tracks tan on [−π, π], while [8/0] departs at \|x\| ≳ 1.2. In `pade01`, [5/5] tracks √x to 10.5 while [9/0] leaves at x ≈ 2.5. |
| D7 | "for $\sqrt{x}$ about $x_0=5$, the $[4/6]$ system has condition number about $1.5\times10^{11}$" | confirmed | The script gives cond(B) = 1.5109e11. My 50-digit SVD of the same 6×6 Toeplitz matrix built from exact coefficients gives 1.51092e11. |
| D8 | The system "is singular for some entries [m/n], the degenerate entries described above" | confirmed | On all 1614 entries, exact singularity (sympy det = 0) coincides with non-existence. There is no singular-but-consistent entry: the script's "singular-consistent" branch is never taken. |
| D9 | MATLAB `pade` timings: [1/15], [1/16], [1/17] for e^x about 0 "about 7, 31 and 134 seconds in MATLAB R2026a"; "`padeapprox` from chebfun also struggles" | could not determine | MATLAB may not be run. The supporting detail checks out: `pade_animation_code.m` uses `digits(20)` (the "20-digit vpa setting"), and the e^x videos use maxOrder 20, so these entries are within range. |
| D10 | Rational functions can have poles and horizontal asymptotes; polynomials do not | confirmed (general fact) | No check needed. |

### Video section

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| V1 | "The videos are generated by a MATLAB script: pade_animation_code.m" | confirmed (file exists, cases match) / could not determine (that each YouTube video is this script's output) | Each heading matches a block in the m-file: exp about 0 and 1; tanh about 0 and 0.5; arctan about 0 and 0.5; 1/x about 0.5; 1/(x−1) about 0.75; sin about 0 and 0.5; x/(x²+0.01²)^{1/4} about 0.5; Runge about 0 and 0.5. The YouTube videos were not viewed. |
| V2 | Video count per heading (2, 2, 2, 1, 1, 2, 1, 2) | confirmed | This matches the number of m-file blocks per function. |

### Animations section

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A0 | "Each animation shows one Padé order per frame for a fixed center $x_0$, overlaid on the target function" | confirmed | One [m/n] per frame, all m+n ≤ max_total, ordered by total order: 66 frames when max_total = 10 and 45 when it is 8. The manifest frame counts match exactly. Magenta is f, steel blue is the approximant, and a red dot marks (x0, f(x0)). |
| A1 | Link "Julia source for all cases" → `pade_animations_all.jl` | confirmed | The file exists and generates all 27 GIFs. The manifest shows them byte-identical to the regenerated output. |

For each case row below, I checked four things: the heading's function, x0 and interval against the case-table line in the script; the title in frame 1 (read at full size, tiles in `review/titles_0.png` and `titles_1.png`); the alt text; and the source link and embed. All are **confirmed** unless noted. "Numbers" is the largest difference between the script's plotted approximant and my independent approximant, over all frames of that case. It is measured as a fraction of the y-span, at grid points within one span of the window and away from poles.

| Case | Heading (f, x0, interval) | Script line | GIF title | Alt text | Link / embed | Numbers (max diff / span) | Degenerate labels (script = exact) |
|---|---|---|---|---|---|---|---|
| 01 | √x, 1, [0, 10.5] | l.24 ✓ | "sqrt(x), x0 = 1.0" ✓ | ✓ | .jl / pade01.gif ✓ | 4.3e-14 | 0 = 0 |
| 02 | √x, 4, [0, 10.5] | l.25 ✓ | ✓ | ✓ | ✓ | 1.7e-14 | 0 = 0 |
| 03 | √x, 5, [0, 10.5] | l.26 ✓ | ✓ | ✓ | ✓ | 4.3e-14 | 0 = 0 |
| 04 | 1/√(1−x), 0, [−1.5, 1.5] | l.27 ✓ | ✓ | ✓ | ✓ | 6.7e-10 | 0 = 0 |
| 05 | log x, 1, [−0.5, 4.1] | l.28 ✓ | ✓ | ✓ | ✓ | 4.9e-11 | 10 = 10 |
| 06 | log x, 2, [−0.5, 4.1] | l.29 ✓ | ✓ | ✓ | ✓ | 2.9e-11 | 0 = 0 |
| 07 | log(1+x), 0, [−1.5, 1.5] | l.30 ✓ | ✓ | ✓ | ✓ | 3.7e-11 | 10 = 10 |
| 08 | sin x, 0, [−3π, 3π] | l.31 ✓ | ✓ | ✓ | ✓ | 8.9e-15 | 20 = 20 |
| 09 | cos x, 0, [−3π, 3π] | l.32 ✓ | ✓ | ✓ | ✓ | 8.4e-15 | 15 = 15 |
| 10 | sin x, π/4, [−7π/4, 9π/4] | l.33 ✓ | "x0 = 0.7854" ✓ | ✓ | ✓ | 3.9e-14 | 0 = 0 |
| 11 | cos x, π/3, [−5π/3, 7π/3] | l.34 ✓ | "x0 = 1.0472" ✓ | ✓ | ✓ | 7.3e-14 | 0 = 0 |
| 12 | tan x, 0, [−π, π] | l.35 ✓ | ✓ | ✓ | ✓ | 3.0e-14 | 14 = 14 |
| 13 | eˣ, 0, [−2, 3] | l.36 ✓ | ✓ | ✓ | ✓ | 1.8e-13 | 0 = 0 |
| 14 | e^{−x} cos x, 0, [−2, 4] | l.37 ✓ | "exp(-x)*cos(x)" ✓ | ✓ | ✓ | 5.6e-13 | 2 = 2 |
| 15 | cosh x, 0, [−4, 4] | l.38 ✓ | ✓ | ✓ | ✓ | 3.7e-14 | 15 = 15 |
| 16 | arctan x, 0, [−2, 2] | l.39 ✓ | "atan(x)" ✓ | ✓ | ✓ | 7.8e-15 | 20 = 20 |
| 17 | arcsin x, 0, [−1.5, 1.5] | l.40 ✓ | "asin(x)" ✓ | ✓ | ✓ | 2.0e-14 | 14 = 14 |
| 18 | J0, 0, [−10.2, 10.2] | l.41 ✓ | "besselj(0,x)" ✓ | ✓ | ✓ | 6.8e-15 | 15 = 15 |
| 19 | J1, 0, [−10.2, 10.2] | l.42 ✓ | ✓ | ✓ | ✓ | 5.2e-15 | 20 = 20 |
| 20 | (2π)^{−1/2} e^{−x²/2}, 0, [−3, 3] | l.43 ✓ | "normal_pdf(x)" ✓ | ✓ | ✓ | 4.9e-15 | 15 = 15 |
| 21 | ½ + ½ erf(x/√2), 0, [−3, 3] | l.44 ✓ | "normal_cdf(x)" ✓ | ✓ | ✓ | 1.1e-13 | 6 = 6 ([2/1]=[1/0], [4/1]=[3/0], [4/3]=[3/2], [6/1]=[5/0], [6/3]=[5/2], [8/1]=[7/0]) |
| 22 | Γ, 1, [−0.2, 5.2] | l.45 ✓ | ✓ | ✓ | ✓ | 1.0e-10 | 0 = 0 |
| 23 | Γ, 2, [−0.2, 5.2] | l.46 ✓ | ✓ | ✓ | ✓ | 3.9e-13 | 0 = 0 |
| 24 | Γ, 3, [−0.2, 5.2] | l.47 ✓ | ✓ | ✓ | ✓ | 4.7e-12 | 0 = 0 |
| 25 | Y0, 10, [0, 22] | l.48 ✓ | ✓ | ✓ | ✓ | 1.7e-13 | 0 = 0 |
| 26 | Y0, 5, [0, 22] | l.49 ✓ | ✓ | ✓ | ✓ | 5.3e-14 | 0 = 0 |
| 27 | Y0, 2, [0, 22] | l.50 ✓ | ✓ | ✓ | ✓ | 2.2e-14 | 0 = 0 |

- **Counts:** 27 cases, 27 headings, 27 embeds, and 28 source links (27 plus the "all cases" link). All confirmed.
- **NaN masking:** the script's `abs(den) < 1e-8` NaN mask never blanks a grid point where the exact approximant is finite and in view. The count of such points is 0 in every case.

### Legacy fidelity

All 27 rows (function, x0, interval) agree exactly with the formula images of Mathews' `Pade.html` cases 1–27 (`review/legacy/legacy_0.png` and `legacy_1.png`).

Mathews' animations show diagonal [n/n] approximants with a "convergence interval" bar at a tolerance of ±0.001 or ±0.01. The page instead shows every [m/n] with m+n ≤ 10 (or ≤ 8) and has no tolerance bar. The page does not claim to reproduce that feature, and it is content the page does not have, so it is not reported as a fidelity finding.

As a cross-check, Mathews' tan [2/2] frame shows poles at about ±1.73, which agrees with the script's [2/2] = x/(1 − x²/3) (poles at ±√3).

### 3. Implementation checks (`pade_animations_all.jl`)

### It is the method it claims to be

It is the classical linearised Padé construction in the monomial basis about x0:
- q0 = 1.
- The n×n Toeplitz system B q_tail = −a_{m+1..m+n}, with B[r, j] = a_{m+r−j} (l.345–354).
- p_i = Σ_{j ≤ min(i, n)} q_j a_{i−j} (l.363–370).

When B is singular (cond > 1e14), the script looks for the reduced Frobenius ("Baker") form of the [m/n] entry, the top-left entry of its block, and labels the frame "(degenerate)" if that form does not match f through order m+n (l.411–438). This is the standard definition of the Padé table with blocks.

The branch at l.434–435, which returns the possibly ill-solved p and q when a singular system is consistent, is never reached for these 27 cases: 0 of 1614 entries. Its potential weakness therefore has no effect.

### The numbers are right

**Taylor coefficients.** The script's coefficient vectors were compared with independent ones:
- sympy `series` of the closed-form f about x0, for cases 01–05, 07–10 and 12–21;
- `mpmath.taylor` at 60 digits, self-checked against 90 digits with agreement ≤ 1.3e-61, for 06, 11 and 22–27.

The largest relative error is 3.3e-15 (case 11, from Float64 π/3) and is 0 in 23 cases. Exact zeros are exactly zero in every case, which matters for detecting degeneracy. Agreement to 0.0 for Γ and Y0 confirms the "correctly rounded" claim in the comment block at l.71–92.

**Approximants: comparison with an independent table.**
- For the exact cases I computed the exact Frobenius null vector, reduced p/q with a polynomial gcd, and tested contact through m+n exactly.
- For case 21, the structure comes from exact arithmetic at two generic rational values of t = 1/√(2π), which agree. The values come from mpmath at the true t.
- For 06, 11 and 22–27, I solved the system in 60-digit mpmath and confirmed it is non-singular (Hadamard-normalised |det| ≥ 3e-13).

| Check | Result |
|---|---|
| Plotted approximant vs mine, worst over all 27 cases | 6.7e-10 of the y-span (case 04, [4/6]) |
| Plotted approximant vs mine, 21 of 27 cases | below 1e-12 |
| Contact property for every non-degenerate entry: \|Σ q_j a_{k−j} − p_k\| / Σ\|terms\| for k ≤ m+n, using my coefficients and the script's p and q | ≤ 1.6e-15 |
| Legend note | identical to my expected label for all 1614 entries |
| Singular flag | identical to exact singularity for all 1614 entries |

**Singularity threshold.** The comment "regular systems have cond(B) ≤ 1.6e11 and exactly singular ones ≥ 4.7e16" (l.375–376) is confirmed. The largest regular value is 1.511e11 (case 03 [4/6]); the smallest singular value is 4.73e16 (case 20 [1/5]). The 1e14 threshold separates them with a factor of about 600 on each side.

**Not an error: tiny features near x0 in case 25.** The [2/1] and [0/7] frames show small spikes near x ≈ 9.6–9.8. These are genuine poles of the exact approximants:
- [2/1] has a pole at x = 9.6302 with a numerator zero at 9.6353 (a near pole-zero doublet; residue −7.8e-4);
- [0/7] has a pole at x = 9.7773 (residue 3.1e-3).

The grid misses them closely, so they show as short ticks. They are not artifacts of the computation.

### Its reference values are right

The reference curve is the closed-form f, evaluated with `safe_eval` (Base `sqrt`, `log`, `tan`, `asin`, `exp`, `cosh`, `atan`, and SpecialFunctions `besselj`, `bessely`, `gamma`, `erf`). The formulas on l.24–50 are the stated functions. Domain errors (log x for x ≤ 0, √x for x < 0, asin for |x| > 1, Y0(0)) become NaN, which is correct.

### The picture shows what was computed

Frames checked:
- contact sheets of pade01, 05, 08, 12, 22 and 25;
- pade08 frame 55 at full size;
- the frame-1 titles of all 27 GIFs at full size.

The steel-blue curve in each frame is the [m/n] named in the legend: the frame order follows `order_pairs`, and pade08 frame 55 = [9/0], as expected from index T(T+1)/2 + m + 1. The curve matches the computed values. The red dot is (x0, f(x0)). Titles show the right function and x0, with x0 rounded to 4 digits (0.7854, 1.0472).

The display issues are the clamping described in F1 and, at the true poles of tan and Γ, an unmasked magenta vertical line, which is conventional and not reported separately.

