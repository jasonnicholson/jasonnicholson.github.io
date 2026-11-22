# Laurent Series — animation review (round 2)

Page: `pages/numerical-methods/laurent-series/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Implementation (display): Taylor polynomials are clamped onto the plot border and drawn along the frame edge. Minor

- **Location:** `laurent_animations_all.jl` line 346
  `ylaur = [isfinite(y) ? clamp(y, case.ylims[1], case.ylims[2]) : NaN for y in ylaur]`
  (and line 330, the same treatment for `f`).
- **What is there now:** wherever the degree-N polynomial leaves the y-window, its value is replaced by `ylims[1]` or `ylims[2]`. The blue curve then runs horizontally along the top or bottom edge of the axes box. Examples: in `laurent08.gif` frame 1, the line y = x appears to level off at ±1.5. In `laurent01.gif`, every even-N frame shows a blue line lying on y = 0 from x ≈ 3 to 10.5. Also visible in `laurent12` (bottom-left at y = −10), `laurent21` (top-right at y = 1.1) and `laurent27` (bottom at y = −2).
- **How much of the picture is affected:** `clampfrac.py` computes the share of the 900-point x-grid where the polynomial lies outside ylims (and is therefore drawn on the edge), for N = 1…max:
  - 01: 43–74 %
  - 08: 84→43 %
  - 09: up to 76 %
  - 18: up to 69 %
  - 19: 71→41 %
  - 25–27: up to 77 %
  - 05, 10, 11, 12, 16, 20, 21 and 22: 20–66 % in many frames
  - 03, 13 and 15: 0 %
- **What is true instead:** off-window the polynomial is unbounded. In cases 08–11 and 18–21 it grows like |x−x0|^N; it does not sit at the axis limit. A viewer could read the edge segment as the approximant saturating or equalling 0, which matters most in case 01, where y = 0 is a meaningful value. The page itself never quotes an off-window value, which is why this is Minor and not Misleading.
- **Suggested correction:** do not clamp `ylaur` (or `ytrue`). Plots.jl clips at `ylims` by itself, so the curve simply leaves the window. Alternatively, map out-of-range values to `NaN` instead of to the limit. If you keep clamping for `f` so that the poles of tan and Γ draw as vertical lines, apply it to `ytrue` only.

- **Independent check:** not run (Minor finding, unverified)

### F2. Page match (Description): "analytic at x0 ⇒ principal part is zero" is stated without the annulus qualifier, and the page contradicts it later. Minor

- **Location:** `index.qmd` line 18:
  "When $f$ is analytic at $x_0$, as it is in every case below, the principal part is zero and, on the largest disc about $x_0$ where $f$ is analytic, the Laurent series is the ordinary Taylor series."
  The same idea appears on line 24: "All 27 functions are analytic at $x_0$, so $a_k=0$ for every $k<0$". Line 12 gives the formula as "The Laurent series of a function around a center $x_0$", as if it were unique.
- **What is there now:** the zero principal part is derived from analyticity at x0 alone. The disc qualifier grammatically attaches only to the second clause.
- **What is true instead:** a Laurent expansion about x0 is determined by an annulus as well as the centre. Analyticity at x0 makes the principal part vanish only for the expansion on the disc |x−x0| < R. The page's own line 30 says correctly that for tan (case 12) and Γ (cases 22–24), which are analytic at x0, "a different Laurent series about $x_0$, with nonzero negative powers, holds in the annulus". For example, about x0 = 1, Γ has the 1/z pole at distance 1, so its expansion on 1 < |z−1| < 2 contains Σ(−1)^k (z−1)^{−k−1}. Lines 18 and 24 are therefore false as literally stated, and they conflict with line 30.
- **How I know:** standard Laurent theory (uniqueness per annulus), together with the page's own line 30. No computation is needed.
- **Suggested correction:** line 18 could read "When $f$ is analytic on the disc $|x-x_0|<R$ (R = distance to the nearest singularity), its Laurent series on that disc has zero principal part and is the Taylor series." Line 24 could read "…so on the disc about $x_0$ out to the nearest singularity $a_k=0$ for every $k<0$…". On line 12, add "valid in an annulus $r<|x-x_0|<R$".

No Fidelity findings (see Archive).

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `laurent_animations_all.jl` | 0 | 25.5 | 27 GIFs (laurent01.gif … laurent27.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `laurent01.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent02.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent03.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent04.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent05.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent06.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent07.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent08.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent09.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent10.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent11.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent12.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent13.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent14.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent15.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent16.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent17.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent18.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent19.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent20.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent21.gif` | 10 | byte-identical | laurent_animations_all |
| `laurent22.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent23.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent24.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent25.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent26.gif` | 8 | byte-identical | laurent_animations_all |
| `laurent27.gif` | 8 | byte-identical | laurent_animations_all |

### Page references

- Scripts linked: `laurent_animations_all.jl`
- GIFs embedded: 27
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (location) | Check | Verdict |
|---|---|---|---|
| 1 | Laurent series $f(x)=\sum_{k=-\infty}^{\infty} a_k (x-x_0)^k$ (l.14–16) | Standard form, but no annulus is stated | Confirmed (imprecision noted in F2) |
| 2 | "extends Taylor series by allowing negative powers. Those negative-power terms form the principal part" (l.18) | Definition | Confirmed |
| 3 | "When $f$ is analytic at $x_0$ … the principal part is zero" (l.18) | True only for the disc expansion; contradicted by l.30 | Wrong as stated (F2, Minor) |
| 4 | "on the largest disc about $x_0$ where $f$ is analytic, the Laurent series is the ordinary Taylor series" (l.18) | Laurent uniqueness | Confirmed |
| 5 | "f is analytic at $x_0$, as it is in every case below" (l.18) / "All 27 functions are analytic at $x_0$" (l.24) | Checked every case: √x at 1, 4, 5; 1/√(1−x) at 0; log x at 1, 2; log(1+x) at 0; tan at 0; atan and asin at 0; Γ at 1, 2, 3; Y0 at 10, 5, 2; the rest are entire | Confirmed |
| 6 | "reuses the same 27 function/interval/center cases used on the Padé page" (l.22) | Compared case table with `pade-approximation/pade_animations_all.jl` l.24–50: every function, c, xlims, ylims and max order is identical | Confirmed |
| 7 | "draws truncated series about $x_0$ instead of rational Padé forms" (l.22) | Script l.336–344 draws polynomials only | Confirmed |
| 8 | "so $a_k=0$ for every $k<0$" (l.24) | True for the disc expansion only | Wrong as stated, as part of F2 |
| 9 | two-sided truncation $\sum_{-N}^{N}$ equals $\sum_{0}^{N}$, "the degree-$N$ Taylor polynomial. That is what each frame draws" (l.26–30) | Script l.344 uses `coeffs[1:n+1]`, degree n. Coefficients verified (section 3) | Confirmed |
| 10 | "with $N$ increasing frame by frame" (l.30) | Loop `for n in 1:case.max_order`; legend shows N = 1…10 (or …8); all frames distinct (decoded-frame md5: 10/10 or 8/8 unique in every GIF) | Confirmed |
| 11 | "no frame contains a negative power" (l.30) | Only nonnegative powers in `poly_eval_asc` | Confirmed |
| 12 | Entire cases are "08–11, 13–15 and 18–21" (l.30) | sin, cos, eˣ, e^{−x}cos x, cosh, J0, J1, Gaussian and erf are entire. All the others have a finite singularity | Confirmed |
| 13 | Non-entire cases: series "converges only within the distance from $x_0$ to the nearest singularity … and diverges beyond it" (l.30) | Cauchy–Hadamard. Radii: 01 R=1; 02 R=4; 03 R=5; 04 R=1; 05 R=1; 06 R=2; 07 R=1; 12 R=π/2; 16 R=1 (±i); 17 R=1; 22 R=1; 23 R=2; 24 R=3; 25 R=10; 26 R=5; 27 R=2 | Confirmed |
| 14 | "every such plotted interval reaches past that distance" (l.30) | max\|x−x0\| over the interval: 01 9.5; 02 6.5; 03 5.5; 04 1.5; 05 3.1; 06 2.5; 07 1.5; 12 π; 16 2; 17 1.5; 22 4.2; 23 3.2; 24 3.2; 25 12; 26 17; 27 20. Every value is > R | Confirmed |
| 15 | Nearest singularity is a pole for tan (12) and Γ (22–24) (l.30) | tan has poles at ±π/2. Γ has its pole at 0 (distance 1, 2, 3). The other non-entire cases have branch points (√, log, atan at ±i, asin at ±1, Y0 at 0) | Confirmed |
| 16 | "a different Laurent series about $x_0$, with nonzero negative powers, holds in the annulus between that pole and the next singularity; the animations do not draw it" (l.30) | Annuli: π/2<\|z\|<3π/2 for tan; 1<\|z−1\|<2, 2<\|z−2\|<3 and 3<\|z−3\|<4 for Γ. The enclosed poles give a nonzero principal part. Not drawn: confirmed in the script | Confirmed |
| 17 | "same case ordering as the Padé suite (Case 01 through Case 27)" (l.32) | Ids 01–27 are in the same order in both tables | Confirmed |
| 18 | Link "[Julia source for all cases](laurent_animations_all.jl)" (l.34) | The file exists and produces all 27 GIFs (manifest: byte-identical regen) | Confirmed |
| 19–45 | Case headings 01–27 (l.36–140): function, $x_0$ and interval for each | Each row of the script's `cases` table (l.21–47) matches its heading exactly. Notably case 10 has c = π/4 and xlims (−7π/4, 9π/4); case 11 has π/3 and (−5π/3, 7π/3); case 20 uses exp(−x²/2)/√(2π); case 21 uses 0.5+0.5·erf(x/√2). GIF titles, read at full size from the last frame of every GIF (montages `last_0/1/2.png`), show the matching formula label and x0 (0.7854 = π/4, 1.0472 = π/3). All 27 checked | Confirmed (27 of 27) |
| 46–72 | Embeds and alt text "Laurent-series truncation animation for case NN." → `laurentNN.gif` (l.38–142) | Each embed NN points to the GIF that script case NN writes (`out_name = "laurent$(case.id).gif"`), and its title says Case NN | Confirmed (27 of 27) |

Not on the page, so not checked as claims: frame counts, colours and the meaning of the marker and the dashed line. For the record: magenta is f, steelblue is T_N, the dashed grey vertical line is at x0 and the red dot is (x0, f(x0)). All are consistent with the code.

---

### 3. Implementation checks: `laurent_animations_all.jl`

**Method.** This is the method the page names, in the variant the page describes. For functions analytic at x0, the Laurent series on the disc of convergence is the Taylor series, and the page says it draws exactly that, the degree-N Taylor polynomial. No negative-power terms are ever computed. This is not a hidden simplification: page l.24–30 and the legend "Laurent = Taylor, N = n" both say so.

**Numbers.**
- I instrumented a scratch copy (`review/instr.jl`, script lines 1–325 plus a dump) to write each case's coefficient vector to `coeffs.tsv`. It also writes T_N at 7 points for every N to `evals.tsv`.
- I computed the reference coefficients independently with `mpmath.taylor` at 60 digits (`indep.py`), about the exact Float64 centre, from the function definitions only. Command: `/usr/bin/python3 -I indep.py coeffs.tsv`.
- Maximum relative error per case, script against reference:
  - 01: 0
  - 02: 0
  - 03: 8.3e-17
  - 04: 0
  - 05: 5.6e-17
  - 06: 5.6e-17
  - 07: 5.6e-17
  - 08: 6.7e-17
  - 09: 8.6e-17
  - 10: 1.4e-15
  - 11: 3.0e-15
  - 12: 5.6e-17
  - 13: 8.6e-17
  - 14: 6.7e-17
  - 15: 8.6e-17
  - 16: 5.6e-17
  - 17: 5.6e-17
  - 18: 5.6e-17
  - 19: 5.6e-17
  - 20: 1.3e-16
  - 21: 1.3e-16
  - 22: 5.2e-17
  - 23: 6.4e-17
  - 24: 9.3e-17
  - 25: 9.8e-17
  - 26: 9.2e-17
  - 27: 5.8e-17
  - Worst: 2.98e-15 (case 11, from `cos(c + kπ/2)` with a rounded π, which is harmless).
- Sample top coefficients, script against reference:
  - case 22, a8 = 0.9981056938 against 0.998105693783
  - case 24, a8 = 0.00135522086 against 0.00135522086024
  - case 27, a8 = −0.0002913447428 against −0.000291344742798
  - case 12: tan coefficients 1, 1/3, 2/15, 17/315 (the term 62/2835 is unused because N ≤ 8)
  - case 08, a10 = 1.7e-22 against an exact 0 (rounding of sin(5π), invisible)
- The derivative-matching property holds by construction: a_k = f^(k)(x0)/k! to the stated order N, verified above for every k ≤ N and every case.
- Polynomial evaluation: Horner (`poly_eval_asc`) on `coeffs[1:n+1]` in z = x − x0. Against an mpmath evaluation of the same coefficients at 7 × N points per case (`evalchk.py`), the worst scaled error is 5.7e-15.
- The special-purpose routines also check out:
  - The Γ path (log-Γ series with digamma and Hurwitz ζ by Euler–Maclaurin) matches the reference to < 1e-16 at c = 1, 2, 3. The comment's tail bound also holds for the orders used: s ≤ 8, A ≥ 116 gives (128/(2π·116))² ≈ 0.031 < 0.04.
  - The Y0 path (derivative identity via MPFR `yn`) matches to < 1e-16 at c = 10, 5, 2.

**Reference values.** The "true" curve is `case.f` evaluated in Float64 (Base, SpecialFunctions). Every function matches its heading, as checked in the ledger. Its value at x0 (the red dot) equals a0 in each case; this is visible in all last frames and agrees with `coeffs.tsv` (a0 = 1, 2, √5, 1, 0, log 2, 0, 0, 1, sin π/4, cos π/3, 0, 1, 1, 1, 0, 0, 1, 0, 1/√(2π), 0.5, Γ(1), Γ(2), Γ(3), Y0(10), Y0(5), Y0(2)). Values outside the domain (log of x ≤ 0, √(1−x) with x > 1, asin with |x| > 1, Y0(0)) raise exceptions or are non-finite and become `NaN`, so they are not drawn. That is correct.

**Picture.**
- I viewed the contact sheets for 01, 12 and 22, full-size frames 08/1 and 27/2, and the final frame of all 27 GIFs (`review/last_*.png`).
- The blue curve passes through the red dot at x0 in every frame and hugs f near x0, and the hugging interval widens with N. For the non-entire cases it peels away at about the radius in table entry 13. Examples: case 01 departs near x ≈ 2, which is |x−1| ≈ 1; case 05 near x ≈ 2; case 22 near x ≈ 2.
- The legend's N equals the polynomial degree. Titles match the page (ledger 19–45).
- The vertical magenta strokes at the poles of tan (±π/2) and Γ (x = 0) come from clamping adjacent samples of opposite sign and joining them. They read as asymptotes and do not mislead.
- The one display problem is the polynomial clamped onto the frame edge (F1).
- Regeneration: the manifest reports all 27 GIFs byte-identical to the committed ones, so the frames reviewed are this script's output.

---

### Archive

- The brief's pointer, n2003, has no Laurent module; `TaylorPolyMod.html` covers Taylor polynomials only.
- `grep -il laurent` across n2003 and the a2001 Animations HTML found only `FrobeniusSeriesMod.html` and `FrobeniusSeriesProof.html` ("generalized Laurent series", unrelated).
- A complex-variables module `c2003/LaurentSeriesMod.html` exists, but it is textbook theory with Mathematica examples and no animations or numerical cases.
- The a2001 animation set has Padé (`Interpolation/Pade`) and Maclaurin/Taylor (`Interpolation/series`) animations but none for Laurent.
- The page is therefore a site-original construction on the Padé case set, and it says so. There is no archive example it departs from or drops, so there are no Fidelity findings.

