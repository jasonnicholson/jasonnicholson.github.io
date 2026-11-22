# Padé Approximation — animation review (round 5)

Page: `pages/numerical-methods/pade-approximation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Implementation (display): some real poles inside the plot window appear as short finite spikes, not as poles. **Minor**

- **Location:** `pade_animations_all.jl` lines 452 and 465–475. The approximant is sampled on a fixed 900-point grid (`xplot = range(..., length=900)`), is set to NaN only when `abs(den) < 1e-8`, and is then clamped to `ylims`. The code does nothing to place a sample at, or mark, a real zero of `q` inside the window.
- **What is there now:** when a pole falls between grid points and has a small residue, the drawn curve jumps between two moderate values and never reaches the axis limit. The pole then looks like a glitch or a small kink. Examples:
  - Case 25, frame 2, `Padé [0/1]` for Y0 about 10. The real pole is at x = 9.7764 with residue 1.24e-2. The drawn spike runs only from −1.02 to +1.02, while the ylims are ±2 (see `committed/pade25/frame_002.png`).
  - Case 25 `[2/1]`. The pole is at x = 9.6302 with residue −7.8e-4. The drawn values stay between 0.08 and 0.22, so it shows as a small kink near x0.
  - Case 25 `[0/3]`, `[0/5]`, `[0/7]`, `[2/3]`, `[2/5]`. The poles are at 9.33–9.78 with residues 4e-4 to 6e-3. The spikes reach at most |y| ≈ 0.66.
  - Case 26 `[3/3]` (frame 25). The pole is at x = 3.714 with residue −3.1e-3. It is drawn as a blip between −0.45 and 0.29. `[3/1]` and `[3/5]` behave the same way.
  - Case 22 `[5/2]` (pole at x = 2.300) and `[3/5]` (pole at x = 2.603). The spikes stop well short of the y-limits of 35 and −10.
- **What is true instead:** each of these approximants has a genuine real pole in the window, so |R| → ∞ there. In total, 30 frames have a real pole of `q` inside the window whose drawn spike does not reach the axis limit. About 13 of them have residue ≥ 1e-4 (all in the Gamma and Y0 cases 22–27), and those are the ones a viewer can see as a misdrawn blip. The rest are near-cancelling pole-zero pairs (Froissart-type doublets, residue 1e-15 to 1e-5). Those are invisible at any reasonable resolution and are not a concern.
- **How I know:** `review/poles.py` reads the script's own p, q for every frame (`review/script_dump.txt`, produced by `review/dump.jl` running an unmodified copy of the script's functions). For each frame it finds the real roots of q in the window, computes the residue p/q′ at each, and takes the sampled min and max of the plotted curve within ±2.5 grid steps of the root. It printed 30 such frames, for example `('25', (0, 1), '', 9.7764, 'res=1.24e-02', 'sampled y in [-1.02,1.02] vs ylims (-2,2)')`. As an independent check for Case 25 [0/1]: Y0(10) = 0.05567 and Y0′(10) = −Y1(10) = −0.24902. That puts the pole at x0 + a0/a1 = 10 − 0.2236 = 9.7764, with residue magnitude a0²/|a1| = 0.0124. This matches.
- **Suggested correction:** in `render_case`, compute the real roots of `q` inside `xlims`. Then either:
  - insert NaN at each root and add grid points on either side, so the curve runs to the clamp on both sides, or
  - draw a thin dashed vertical line at each real pole.

  Either way the pole reads as a pole. To avoid drawing doublets, you can skip roots where `p` has a root within about 1e-6.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Notes (not findings)

- **Fidelity.** All 27 rows of the case table agree with Mathews' 27-case animation index (function, x0 and interval). Mathews' animations show a sequence of diagonal-type approximants S_{n,n} with a "Tolerance ±0.01" convergence-interval bar. This page instead shows every [m/n] with m+n ≤ N and has no tolerance bar. That is a different presentation, not a dropped case, so I do not count it as a finding.
- Plots.jl draws the target curve straight across the poles of tan and Gamma, so the magenta vertical line at x = ±π/2 (and at x = 0 for Gamma) is just the connecting segment. This is acceptable as an asymptote marker.
- `tan_coeff` contains a k = 9 entry that is never used, because Case 12 has max_total = 8. This is harmless.

---

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

### Description

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "R_{m,n}(x)=P_m(x)/Q_n(x), Q_n(x_0)=1" | Script: `q = [1.0; qtail]`, and polynomials are in z = x − x0 (lines 361, 466). | confirmed |
| D2 | Coefficients are chosen so the Taylor expansion of R about x0 matches f "through order m+n", i.e. f^(k)(x0)=R^(k)(x0) for k=0..m+n | The linear system enforces q f − p = O(z^{m+n+1}) with q0 = 1, which is equivalent. My exact computation, built from the Baker definition, reproduces the script's R on every regular frame (see §3). | confirmed |
| D3 | "When Taylor coefficients vanish, as for even or odd functions or when f(x0)=0, some entries [m/n] have no such R_{m,n}" | Exact check: 176 entries have no R with Q(x0)=1 that matches through m+n. They occur only in even or odd cases (08, 09, 12, 15–20), in f(x0)=0 cases (05, 07) and in cases with vanishing coefficients (14: Re((−1+i)^k)=0 at k=2,6; 21: odd tail). | confirmed |
| D4 | "Those frames show the lower-order entry that takes their place in the Padé table, which matches f only to a lower order, and the legend says so" | For all 176 entries, the legend label "= [l/μ] (degenerate)" equals the degrees of the reduced rational function, which I computed exactly by cancelling the gcd of the Baker solution. The displayed curve equals that function, and its contact order is < m+n+1. There were 0 label mismatches across all 1614 frames. | confirmed |
| D5 | Legend example "Padé [2/1] = [1/0] (degenerate)" | Appears exactly so in Case 08, frame 9 (`committed/pade08/frame_009.png`), and in Cases 12 and 17. | confirmed |
| D6 | "for √x about x0=5, the [4/6] system has condition number about 1.5×10^11" | My calculation: mpmath 50-digit coefficients give a 2-norm cond of 1.51092e11. numpy gives 1.5109e11. The script's own B has 1.5109180e11. | confirmed |
| D7 | "that system is singular for some entries [m/n], the degenerate entries described above" | Across the whole table, every degenerate entry has cond(B) ≥ 4.73e16 (Inf in Float64), and every regular one has ≤ 1.51e11. No entry is singular but consistent. | confirmed |
| D8 | "Rational functions can have singularities/vertical-asymptotes and horizontal asymptotes. Polynomials do not have asymptotes or singularities." | Standard. True for non-constant polynomials, and frames show approximants with poles. | confirmed |
| D9 | "Often, Padé approximant's can converge when Taylor Series does not" / "often stay accurate on larger intervals" | General statement. The frames illustrate it: in Case 16 atan, [5/5] tracks f on [−2,2] while the Taylor [9/0] leaves the window for |x| > 1.2. In Case 04, [n/n] tracks to x ≈ 1 while [9/0] fails for x < −1. | confirmed (as a general statement) |
| D10 | "with the 20-digit vpa setting of the video script" | `pade_animation_code.m` line 178: `digits(20);`, line 179: `vpa(...)`. | confirmed |
| D11 | [1/15], [1/16], [1/17] for e^x about 0 "took about 7, 31 and 134 seconds in MATLAB R2026a"; "MATLAB's symbolic pade can be very slow for some entries below total order 20"; "padeapprox from chebfun also struggles" | I am not allowed to run MATLAB, and Chebfun is not available. | could not determine |

### Animations section

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A0 | "Each animation shows one Padé order per frame for a fixed center x0, overlaid on the target function." | Each frame shows one [m/n] (from `order_pairs`), the magenta f, and a red dot at (x0, f(x0)). The frame counts are 66 (N=10) and 45 (N=8), which match the manifest. | confirmed |
| A0b | "[Julia source for all cases](pade_animations_all.jl)" and 27 per-case "Julia source" links | All of them point to `pade_animations_all.jl`, which is the single script that produces every GIF. | confirmed |
| C01 | √x, x0=1, [0,10.5]; alt text same; embeds pade01.gif | Row "01": `sqrt`, 1.0, (0,10.5). GIF title "Case 01: f(x) = sqrt(x), x0 = 1.0". Matches the archive row 1. | confirmed |
| C02 | √x, x0=4, [0,10.5] | Row 02, title and archive agree | confirmed |
| C03 | √x, x0=5, [0,10.5] | Row 03, title and archive agree | confirmed |
| C04 | 1/√(1−x), x0=0, [−1.5,1.5] | Row 04, title and archive agree | confirmed |
| C05 | log x, x0=1, [−0.5,4.1] | Row 05, title and archive agree | confirmed |
| C06 | log x, x0=2, [−0.5,4.1] | Row 06, title and archive agree | confirmed |
| C07 | log(1+x), x0=0, [−1.5,1.5] | Row 07, title and archive agree | confirmed |
| C08 | sin x, x0=0, [−3π,3π] | Row 08, title and archive agree | confirmed |
| C09 | cos x, x0=0, [−3π,3π] | Row 09, title and archive agree | confirmed |
| C10 | sin x, x0=π/4, [−7π/4,9π/4] | Row 10 (`pi/4`). Title shows "x0 = 0.7854" (π/4 = 0.78540). Archive agrees. | confirmed |
| C11 | cos x, x0=π/3, [−5π/3,7π/3] | Row 11. Title shows "x0 = 1.0472" (π/3 = 1.04720). Archive agrees. | confirmed |
| C12 | tan x, x0=0, [−π,π] | Row 12, title and archive agree | confirmed |
| C13 | e^x, x0=0, [−2,3] | Row 13, title and archive agree | confirmed |
| C14 | e^{−x}cos x, x0=0, [−2,4] | Row 14, title and archive agree | confirmed |
| C15 | cosh x, x0=0, [−4,4] | Row 15, title and archive agree | confirmed |
| C16 | arctan x, x0=0, [−2,2] | Row 16, title and archive agree | confirmed |
| C17 | arcsin x, x0=0, [−1.5,1.5] | Row 17, title and archive agree | confirmed |
| C18 | J0, x0=0, [−10.2,10.2] | Row 18, title and archive agree | confirmed |
| C19 | J1, x0=0, [−10.2,10.2] | Row 19, title and archive agree | confirmed |
| C20 | (1/√(2π))e^{−x²/2}, x0=0, [−3,3] | Row 20, title ("normal_pdf") and archive agree | confirmed |
| C21 | ½+½erf(x/√2), x0=0, [−3,3] | Row 21, title ("normal_cdf") and archive agree | confirmed |
| C22 | Γ(x), x0=1, [−0.2,5.2] | Row 22, title and archive agree | confirmed |
| C23 | Γ(x), x0=2, [−0.2,5.2] | Row 23, title and archive agree | confirmed |
| C24 | Γ(x), x0=3, [−0.2,5.2] | Row 24, title and archive agree | confirmed |
| C25 | Y0, x0=10, [0,22] | Row 25, title and archive agree | confirmed |
| C26 | Y0, x0=5, [0,22] | Row 26, title and archive agree | confirmed |
| C27 | Y0, x0=2, [0,22] | Row 27, title and archive agree | confirmed |
| Alt | Each alt text names the same function, center and interval as its heading | Read all 27. They are consistent with the headings and the table. | confirmed |
| Wiring | Case NN embeds `padeNN.gif`, whose title reads "Padé Case NN" | Checked the title strip of every GIF's first frame (`review/titles.png`). | confirmed |

---

### 3. Implementation checks: `pade_animations_all.jl`

**Method.** The script computes the linearised Padé approximant: q0 = 1, a Toeplitz system for q1..qn, then p = (q·a) truncated to degree m. This is the standard construction. When the system is singular (cond > 1e14), it falls back to the reduced (Frobenius/Baker) form, which is the top-left entry of the Padé-table block, and labels the frame as degenerate. That is a legitimate and correctly described variant (D3, D4). The branch for a singular but consistent system (line 434–435) is never taken on this table. My dump shows 0 such entries.

**Instrumentation.** `review/pade_lib.jl` is lines 1–498 of the script, with the render loop removed. `review/dump.jl` calls the script's own `series_coeffs_analytic`, `pade_linear`, `pade_from_series` and `cond` for every case and every (m,n), and writes `review/script_dump.txt` (1614 entries).

**Independent computation.**
- `review/indep.py` covers cases 01–05, 07–20 and 22–27. `review/fast0621.py` covers 06 and 21.
- **Taylor coefficients:**
  - sympy exact series of each target function about the stated x0, for cases 01–21;
  - `mpmath.taylor` at 60 digits for Γ (22–24) and Y0 (25–27);
  - for 06 and 21, closed forms of the rational parts with the transcendental constant (log 2, or 1/√(2π)) handled exactly.

  This does not reuse any of the script's formulas.
- **Padé approximant:** built from the Baker definition without assuming Q(0) = 1. I took the nullspace of the (L+M+1)×(L+M+2) system "q f − p = O(z^{L+M+1})" (exact sympy, or 60-digit SVD for 22–27), cancelled the gcd, and normalised Q*(0) = 1.
  - An entry "exists" when the reduced form still has contact order ≥ L+M+1.
  - The expected label is "" when it exists, otherwise " = [deg P*/deg Q*] (degenerate)".
- **Comparison:** the script's p/q against the exact R* at 9 random points in each plot window, giving the relative error with a floor of 1, plus the label for every frame. For 06 and 21, the degeneracy structure was computed with the constant replaced by a generic rational, and the values were computed with the true constant at 60 digits.

| Case | max rel. error of script Taylor coeffs | max error of script R vs exact R* (all frames) | degenerate frames (exact) | label mismatches |
|---|---|---|---|---|
| 01 √x @1 | 0 | 7.8e-14 | 0 | 0 |
| 02 √x @4 | 0 | 1.6e-14 | 0 | 0 |
| 03 √x @5 | 8.3e-17 | 2.3e-14 | 0 | 0 |
| 04 1/√(1−x) | 0 | 4.5e-10 (at [5/5], sample near its pole) | 0 | 0 |
| 05 log x @1 | 5.6e-17 | 8.8e-12 | 10 | 0 |
| 06 log x @2 | 5.6e-17 | 2.0e-11 | 0 | 0 |
| 07 log(1+x) | 5.6e-17 | 6.1e-10 | 10 | 0 |
| 08 sin @0 | 6.7e-17 | 1.5e-15 | 20 | 0 |
| 09 cos @0 | 8.6e-17 | 4.6e-15 | 15 | 0 |
| 10 sin @π/4 | 1.5e-15 | 2.6e-14 | 0 | 0 |
| 11 cos @π/3 | 3.2e-15 | 1.2e-13 | 0 | 0 |
| 12 tan | 5.6e-17 | 1.6e-14 | 14 | 0 |
| 13 e^x | 8.6e-17 | 5.5e-14 | 0 | 0 |
| 14 e^{−x}cos x | 6.7e-17 | 3.5e-15 | 2 | 0 |
| 15 cosh | 8.6e-17 | 3.4e-15 | 15 | 0 |
| 16 atan | 5.6e-17 | 6.4e-16 | 20 | 0 |
| 17 asin | 5.6e-17 | 7.0e-15 | 14 | 0 |
| 18 J0 | 5.6e-17 | 1.9e-15 | 15 | 0 |
| 19 J1 | 5.6e-17 | 8.0e-16 | 20 | 0 |
| 20 normal pdf | 1.3e-16 | 2.3e-16 | 15 | 0 |
| 21 normal cdf | 1.3e-16 | 8.6e-15 | 6 | 0 |
| 22 Γ @1 | 5.2e-17 | 4.6e-12 | 0 | 0 |
| 23 Γ @2 | 6.4e-17 | 3.9e-14 | 0 | 0 |
| 24 Γ @3 | 9.3e-17 | 1.4e-13 | 0 | 0 |
| 25 Y0 @10 | 9.8e-17 | 4.8e-15 | 0 | 0 |
| 26 Y0 @5 | 9.2e-17 | 2.1e-15 | 0 | 0 |
| 27 Y0 @2 | 5.8e-17 | 7.4e-15 | 0 | 0 |

The exact computation finds 176 degenerate frames in total, which equals the script's 176. The largest errors (6e-10, 4.5e-10) are at samples very close to a pole of the approximant, and they are invisible at plot resolution.

**Numbers are right:** yes, for all 1614 frames (table above).

**Reference values:** the "true" curve is plotted directly from Julia's `sqrt`, `log`, `sin`, `cos`, `tan`, `exp`, `cosh`, `atan`, `asin`, `besselj`, `bessely`, `erf` and `gamma`, with NaN outside the domain through `safe_eval`. The red marker is at (x0, f(x0)). The Float64 Taylor coefficients agree with the exact ones to ≤ 3.2e-15 relative, so the reference values are right.

**Picture matches computation:**
- I viewed the contact sheets of all 27 GIFs and full-size frames of Cases 08 (frame 9) and 25 (frame 2).
- The blue curve is p/q evaluated at x − x0, and the legend shows the right [m/n] and the right degenerate label.
- Titles name the function, case number and x0 correctly for all 27 (`review/titles.png`).
- Clamping to `ylims` draws vertical connecting segments at poles that the grid samples near enough, which reads correctly as an asymptote. Off-scale parts run along the frame edge.
- The one display shortcoming is F1: small-residue poles between grid samples are drawn as short blips.
- The x-limits and y-limits keep x0 and the region of agreement visible in every case.

**Checks I did not run:** the MATLAB timing claims (D11), as noted above. The YouTube video section is outside the Animations section, and I checked only the "20-digit vpa" detail of its script, because the Description cites it.

