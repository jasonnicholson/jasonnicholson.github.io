# Padé Approximation — animation review (round 2)

Page: `pages/numerical-methods/pade-approximation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. The Description gives the wrong reason why high-order Padé approximants are hard to compute (page match, Minor)

- **Location.** `index.qmd` line 24: "High-order Padé Approximants can be hard to compute because of how fast the coefficients grow."
- **What is there now.** The difficulty is attributed to *growth* of the Taylor coefficients.
- **What is true instead.** The difficulty comes from the conditioning of the linear (Toeplitz) system for the denominator. In practice, that conditioning tracks how widely the coefficient magnitudes spread, which usually means how fast they *decay*. It also comes from degenerate, singular blocks of the Padé table.

  The page's own cases show this. The worst-conditioned systems on the page belong to functions whose coefficients shrink. The best-conditioned belong to a function whose coefficients stay near 1 in size.

| Case | Size of the Taylor coefficients a_k | Largest cond(B) the script meets |
|---|---|---|
| 03, √x about x0=5 | a_0 = 2.24, a_10 = −2.1e−9 (shrinking) | 1.51e11, at [4/6] |
| 13, eˣ about 0 | a_k = 1/k!, a_10 = 2.8e−7 (shrinking) | 6.36e7, at [4/6] |
| 22, Γ(x) about 1 | a_8 = 0.998 (stays near 1) | 8.2e3 |

- **How I know.** I ran `julia review/dump.jl`, which instruments a copy of the script to print cond(B) and the coefficients for each frame, then `awk` over `script_dump.txt`, giving the numbers above.
- **Suggested correction.** "High-order Padé approximants can be hard to compute because the linear system for the denominator coefficients becomes ill-conditioned, especially when the Taylor coefficients span many orders of magnitude, and because some entries are degenerate (the system is singular)."

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Count: Error 0, Misleading 0, Minor 1.**


#### Not counted as findings (recorded so a clean result can be trusted)

- **Clamping to the axis limits.** Line 475 runs `ypad = clamp.(ypad, case.ylims...)`. In 558 of 1641 frames this draws an off-scale stretch of the approximant as a flat line on the top or bottom frame border; I counted every frame with a run of at least 45 of the 900 grid points (5% of the width).

  Examples:
  - Case 22 [8/0] runs along y = 35 for x > 2.6.
  - Case 01 [0/3] is negative after its pole at x = 2.526 (−8.3 at x = 2.6, −0.067 at x = 5), and is drawn along y = 0, which is also the frame line.

  Looking at full-size frames (pade22 frame 45, pade01 frame 7), these segments read as "the curve left the window": they sit on the frame border. The page makes no claim that depends on them, so I judged this acceptable. If the owner prefers, replacing the clamp with NaN for off-window values would remove them.
- **Pole lines.** Poles are drawn as vertical connecting lines. That is a standard convention, and the target function is drawn the same way at its own poles.
- **Fidelity: different frame sequence.** The legacy animations step only along the diagonal, S₁,₁ … S₈,₈ (tan stops at S₅,₅), and add a green "Convergence Intervals" bar at a stated tolerance. The new GIFs step through every [m/n] with m+n ≤ 10, or m+n ≤ 8 for cases 12, 17 and 22–27, with no convergence bar. The furthest diagonal entry shown is therefore [5/5], or [4/4] for those seven cases, against the legacy [8/8].

  All 27 legacy functions, centres and intervals are kept exactly. I count this as a design change (content the page does not have) rather than a fidelity error, but it is listed here so the owner can decide.
- **Spelling and grammar in the Description.** For example "rationale function", "approximant's", "for give m and n", and "fail … fails" on line 24. These are cosmetic and not counted.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `pade_animations_all.jl` | 0 | 101.8 | 27 GIFs (pade01.gif … pade27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description (formulas, algorithm and method claims)

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "a rationale function approximation expanded from a function value and the derivative function values similar to Taylor Series" | The script builds p and q from the Taylor coefficients a_k = f^(k)(x0)/k! only (`series_coeffs_analytic` → `pade_from_series`) | confirmed |
| D2 | "Padé approximant's can converge when Taylor Series does not even though both use the same information at a point" | `interval.py`, region with abs error ≤ 1e−3 around x0. Case 04 (Taylor radius 1): [10/0] gives [−0.656, 0.582], [5/5] gives [−1.5, 0.862]. Case 07: [10/0] gives [−0.615, 0.694], [5/5] gives [−0.859, 1.5]. Case 16: ±0.684 against ±1.256. The Padé approximant stays accurate beyond the Taylor radius of convergence. | confirmed (as illustrated by finite orders) |
| D3 | "Rationale functions can have singularities/vertical-asymptotes and horizontal asymptotes. Polynomials do not…" | General mathematics; poles are visible in the frames (e.g. case 01 [0/3], pole at 2.526) | confirmed |
| D4 | R_{m,n} = P_m/Q_n, Q_n(x0) = 1 | Lines 340–372: q = [1; qtail], p has m+1 coefficients and q has n+1. The legend is [m/n] with m the numerator degree (e.g. [0/3] shows 1/cubic with a pole, [9/0] is a polynomial). In degenerate frames the reduced q also has q0 = 1. | confirmed |
| D5 | "chooses coefficients so the Taylor expansion of R_{m,n} about x0 matches the target function through order m+n" | Rows k = m+1..m+n force (q·a)_k = 0, and p_i = (q·a)_i for i ≤ m, so q f − p = O(z^{m+n+1}). An independent nullspace solve reproduces every non-degenerate frame (section 3). | confirmed |
| D6 | "derivatives match for give m and n" | Same as D5: derivatives 0..m+n match | confirmed |
| D7 | "When Taylor coefficients vanish, as for even or odd functions or when f(x0)=0, some entries [m/n] have no such R_{m,n}" | My independent count of frames where no [m/n] with Q(x0) ≠ 0 exists: 176 frames, all in the 13 cases with vanishing coefficients. Per case: 05 (10), 07 (10), 08 (20), 09 (15), 12 (14), 14 (2), 15 (15), 16 (20), 17 (14), 18 (15), 19 (20), 20 (15), 21 (6). The 14 cases with no zero coefficients have none. | confirmed |
| D8 | "Those frames show the lower-order entry that takes their place in the Padé table" | Legend [l/μ] equals the independently computed reduced (Frobenius) degrees in 176/176 frames, and the plotted curve equals the independent rational function | confirmed |
| D9 | "…which matches f only to a lower order" | In each such frame no approximant with Q(x0) ≠ 0 reaches order m+n, so the reduced form, which has Q(x0) = 1, matches to a lower order | confirmed |
| D10 | "the legend says so, for example 'Padé [2/1] = [1/0] (degenerate)'" | That exact note appears in cases 08, 12, 14, 16, 17, 19 and 21; seen in pade12 frame 6 | confirmed |
| D11 | "Compared with a Taylor polynomial of the same total order, Padé approximants can represent poles and often stay accurate on larger intervals, especially for functions with nearby singularities or branch-point behavior" | `interval.py`, [N/0] against [N/2 / N/2]. Padé is wider for the branch-point and pole cases 01–07, 12, 16, 17 and 20–24. It is narrower for entire functions: 09 cos, 15 cosh, 18 J0. "Often … especially" is accurate. | confirmed |
| D12 | "hard to compute because of how fast the coefficients grow" | See F1 | **wrong** (F1) |
| D13 | "Total orders … of less than 20 fail at times for MATLAB's symbolic `pade` … `padeapprox` from chebfun also struggles" | No MATLAB or Chebfun available | could not determine |
| D14 | "see the resources section below" | The section exists below but is titled "Outside Links" | confirmed (name differs; cosmetic) |

### Video Animations section

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| V1 | "The videos are generated by a MATLAB script: pade_animation_code.m" | The file exists beside the page | confirmed |
| V2 | Headings: exp about 0 and 1; tanh about 0 and 0.5; arctan about 0 and 0.5; 1/x about 0.5; 1/(x−1) about 0.75; sin about 0 and 0.5; x/(x²+0.01²)^{1/4} about 0.5; Runge about 0 and 0.5 | Each matches a `titleName` / `func` / `expansionPoint` block in the .m file (lines 3–100) | confirmed |
| V3 | The YouTube videos show those cases | Not viewable from here | could not determine |

### Animations section

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A0 | "Each animation shows one Padé order per frame for a fixed center x0, overlaid on the target function." | One [m/n] entry per frame, in increasing total m+n; 66 frames (m+n ≤ 10) or 45 frames (m+n ≤ 8, cases 12, 17, 22–27), matching the manifest frame counts. x0 is fixed per GIF; the magenta curve is f. | confirmed |
| A1 | "[Julia source for all cases](pade_animations_all.jl)" | File exists | confirmed |

For every case below I checked:
- the heading's function, x0 and interval against the script table (lines 24–50), the GIF title (`titles.png`) and the legacy case list (`legacy_cases.png`);
- the alt text against the same;
- that the source link is `pade_animations_all.jl`, which exists;
- that the embed `padeNN.gif` is the GIF the script writes for id NN, whose title reads "Padé Case NN".

| Case | Heading | Script row | GIF title | Legacy | Alt text | Link / embed | Verdict |
|---|---|---|---|---|---|---|---|
| 01 | √x, x0=1, [0,10.5] | same | sqrt(x), x0 = 1.0 | same | matches | pade01.gif | confirmed |
| 02 | √x, x0=4, [0,10.5] | same | x0 = 4.0 | same | matches | pade02.gif | confirmed |
| 03 | √x, x0=5, [0,10.5] | same | x0 = 5.0 | same | matches | pade03.gif | confirmed |
| 04 | 1/√(1−x), 0, [−1.5,1.5] | same | 1/sqrt(1-x), 0.0 | same | matches | pade04.gif | confirmed |
| 05 | log x, 1, [−0.5,4.1] | same | log(x), 1.0 | same | matches | pade05.gif | confirmed |
| 06 | log x, 2, [−0.5,4.1] | same | log(x), 2.0 | same | matches | pade06.gif | confirmed |
| 07 | log(1+x), 0, [−1.5,1.5] | same | log(1+x), 0.0 | same | matches | pade07.gif | confirmed |
| 08 | sin, 0, [−3π,3π] | same | sin(x), 0.0 | same | matches | pade08.gif | confirmed |
| 09 | cos, 0, [−3π,3π] | same | cos(x), 0.0 | same | matches | pade09.gif | confirmed |
| 10 | sin, π/4, [−7π/4,9π/4] | same | x0 = 0.7854 | same | matches | pade10.gif | confirmed |
| 11 | cos, π/3, [−5π/3,7π/3] | same | x0 = 1.0472 | same | matches | pade11.gif | confirmed |
| 12 | tan, 0, [−π,π] | same | tan(x), 0.0 | same | matches | pade12.gif | confirmed |
| 13 | eˣ, 0, [−2,3] | same | exp(x), 0.0 | same | matches | pade13.gif | confirmed |
| 14 | e^{−x}cos x, 0, [−2,4] | same | exp(-x)*cos(x) | same | matches | pade14.gif | confirmed |
| 15 | cosh, 0, [−4,4] | same | cosh(x) | same | matches | pade15.gif | confirmed |
| 16 | arctan, 0, [−2,2] | same | atan(x) | same | matches | pade16.gif | confirmed |
| 17 | arcsin, 0, [−1.5,1.5] | same | asin(x) | same | matches | pade17.gif | confirmed |
| 18 | J0, 0, [−10.2,10.2] | same | besselj(0,x) | same | matches | pade18.gif | confirmed |
| 19 | J1, 0, [−10.2,10.2] | same | besselj(1,x) | same | matches | pade19.gif | confirmed |
| 20 | normal pdf, 0, [−3,3] | same | normal_pdf(x) | same | matches | pade20.gif | confirmed |
| 21 | ½+½erf(x/√2), 0, [−3,3] | same | normal_cdf(x) | same | matches | pade21.gif | confirmed |
| 22 | Γ, 1, [−0.2,5.2] | same | gamma(x), 1.0 | same | matches | pade22.gif | confirmed |
| 23 | Γ, 2, [−0.2,5.2] | same | gamma(x), 2.0 | same | matches | pade23.gif | confirmed |
| 24 | Γ, 3, [−0.2,5.2] | same | gamma(x), 3.0 | same | matches | pade24.gif | confirmed |
| 25 | Y0, 10, [0,22] | same | bessely(0,x), 10.0 | same | matches | pade25.gif | confirmed |
| 26 | Y0, 5, [0,22] | same | bessely(0,x), 5.0 | same | matches | pade26.gif | confirmed |
| 27 | Y0, 2, [0,22] | same | bessely(0,x), 2.0 | same | matches | pade27.gif | confirmed |

The page makes no behaviour or numerical-result claims per case, so there were no "Behavior" paragraphs to check.

---

### 3. Implementation checks: `pade_animations_all.jl`

### It is the method it claims to be

The script runs the standard linearised Padé construction:
- q0 = 1;
- solve the n×n Toeplitz system B q_{1..n} = −a_{m+1..m+n}, with B[r,j] = a_{m+r−j};
- form p_i = Σ_j q_j a_{i−j} for i ≤ m.

When B is singular (cond > 1e14), the script looks for the reduced, Frobenius form of the block containing [m/n], the "top-left" entry. It uses that form only when the [m/n] approximant with Q(x0) = 1 does not exist; otherwise it keeps [m/n]. This variant is named in the code comments (lines 408–438) and in the page Description (D7–D10).

Comment claim at line 375: on this table, regular systems have cond ≤ 1.6e11 and singular ones have cond ≥ 4.7e16. This is **confirmed**: the largest cond below 1e14 is 1.5109e11 (case 03 [4/6]) and the smallest above is 4.7327e16. `toep.py` also computes the exact rational determinant of B (sympy) for every frame of the 13 cases with rational coefficients, and finds no misclassification.

### The numbers are right

**Taylor coefficients.** These are computed independently in `indep.py`:
- sympy exact series for every elementary function, about π/4 and π/3 symbolically;
- `mpmath.taylor` at 120 digits for J0, J1, Γ and Y0.

The largest relative difference from the script's coefficients per case is:
- 0 for 01–09, 12–19, 22–27, including the Γ and Y0 coefficients, which the script computes by its Hurwitz-zeta and Bessel-recurrence routine;
- 1.5e−15 for 10 and 3.3e−15 for 11 (Float64 `sin(c + kπ/2)`);
- 2.1e−16 for 20 and 21.

Structural zeros: the script has exact zeros exactly where sympy does, in every case.

**Padé approximants.** I computed these independently without the q0 = 1 assumption. For each of the 1641 frames, `indep.py` solves the homogeneous system q f − p = O(z^{m+n+1}) for (p, q) jointly, using a 60-digit Gauss–Jordan nullspace. Every nonzero solution gives the same rational function, by Frobenius' theorem. From that solution:
- **Existence of the [m/n] approximant with Q(x0) = 1:** some nullspace vector has q0 ≠ 0.
- **Reduced degrees:** the smallest l, and the smallest μ, for which p/q can be written with deg P ≤ l (or deg Q ≤ μ), tested by a second linear system.

**Comparison with the script** (`compare.py`, `dense.py`):

- **Legend notes:** 1641/1641 identical. That is 176 degenerate notes with the same [l/μ], and no note in the other 1465 frames.
- **Values at 9 points per frame:** the largest relative difference per case is at most 1e−13 for most cases. The largest is 1.96e−10 (case 04 [4/6]), then 3.4e−12 (case 22 [0/8]) and 3.1e−11 (cases 05/07 [5/5]). All of these are ill-conditioned Float64 solves and invisible on screen.
- **Plotted (clamped) values on the full 900-point grid,** excluding the 4 grid points around each sign change of q: the largest difference as a fraction of the y-range is 1.6e−10 (case 04). It is at most 2.5e−11 everywhere else, and no frame differs by more than 1e−3 anywhere.

Selected side-by-side values (script / independent):

| Case, frame, x | Script | Independent |
|---|---|---|
| 01 [8/2], 9-pt sample | 0.6850954307123077 | 0.6850954307123587 |
| 05 [5/5] | 0.29999999996868165 | 0.3 |
| 12 [3/4] | −2293.326093880596 | −2293.3260938801154 |
| 22 [0/8] | 5.109066143954713 | 5.109066143937113 |
| 27 [4/4] | −31.813303304235244 | −31.813303304235816 |

Hand checks:
- tan [2/1] → x = [1/0], correct, because a_2 = 0 makes the [2/1] Toeplitz row inconsistent.
- sin [2/2] = x/(1+x²/6), exists, so it carries no note; its peak is 6√6/12 ≈ 1.22, as in pade08.
- log(1+x) [0/n] = 0 = [0/0], because a_0 = 0.

### Its reference values are right

The reference curve is the target function itself, evaluated by `safe_eval` with Julia's `sqrt`, `log`, `gamma`, `besselj`, `bessely` and `erf`. Each table row's lambda matches its label and its heading. Points outside the real domain become NaN: √x and log x for x < 0, 1/√(1−x) and arcsin for x > 1, and Y0 at 0. The red marker is (x0, f(x0)), and in frames such as pade01 frame 7 it sits on both curves.

### The picture shows what was computed

- **Titles and legends.** Titles read "Padé Case NN: f(x) = <label>, x0 = <c to 4 d.p.>" and match the heading for all 27 (`titles.png`). The legend "Padé [m/n]<note>" uses the same m, n and note that produced the plotted p, q (same code path as my dump; the regenerated GIFs are byte-identical).
- **Frames viewed.** I viewed the contact sheets of cases 01, 04, 05, 08, 12, 22 and 25, and full-size pade01 frame 7 and pade22 frame 45. The curves have the shapes the computed rational functions require: pole at 2.526 for case 01 [0/3]; [0/n] ≡ 0 for log; sin [2/5] = [1/4]; Y0 [0/7] tiny near-pole spike close to x0.
- **NaN masking.** NaN masking for |den| < 1e−8 triggers in only 7 frames. Each is an endpoint pole, e.g. log(1+x) [2/1], with q = 1 + 2z/3, has a pole at z = −1.5, the left end of the window. It does not hide anything.
- **Clamping and pole lines.** See "Not counted as findings" above. My judgment is that they do not change what a viewer concludes.
- **Axis windows.** These match the legacy windows where a legacy GIF exists: sqrt 0–3.5, tan ±10, arcsin about ±2. In every case they include x0 and the region where the approximants are accurate.

