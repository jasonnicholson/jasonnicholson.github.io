# Fix record: laurent-series

Scratch evidence (re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r6fix/laurent-series/fix/` (`dump.jl`, `check.py`, `check3.py`, `claims.py`, `claims2.py`, frame folders `f01`–`f08`).

## Findings

### F1 — Owner decision R6-B — fixed
- Reproduced: the old script evaluated only `poly_eval_asc(coeffs[1:(n+1)], z)`, a Taylor polynomial, in all 27 cases, with the legend `Laurent = Taylor, N = n`. No frame held a negative power.
- Change: `index.qmd` rewritten from the Description down (front matter, back link and source line kept). `laurent_animations_all.jl` rewritten as an 8-case table. `laurent01–08.gif` regenerated; `laurent09–27.gif` deleted.
- Check: coefficients, regions, drawn sums and every page number were computed independently with mpmath (below). Frames were viewed.

## Cases, coefficient checks and region checks

Coefficient check: `check.py` compares each script coefficient with the contour integral (1/2πi)∮ f(z) z^(−k−1) dz on the stated circle (512 points, 40 digits). Comparison polynomials are checked the same way about their centre. `check3.py` recomputes the drawn sums and polynomials at 622 sample evaluations across all frames.

| Case | f, centre 0 | Region | a_k | Contour circle | Max rel. err. coef. / Taylor / drawn sum | Region check |
|---|---|---|---|---|---|---|
| 01 | sin x / x | all x (removable at 0) | (−1)^(k/2)/(k+1)!, even k≥0 | \|z\|=1 | 4.9e-15 / – / 2.5e-14 | entire after filling f(0)=1; excluded powers −14…14 below 6e-42 |
| 02 | 1/(1+x²) | \|x\|<1 | (−1)^(k/2), even k≥0 | 0.5 | 4.2e-36 / – / 1.0e-15 | poles ±i; term at k=400 is 0.018 at \|x\|=0.99, 53.5 at 1.01 |
| 03 | sin x / x³ | 0<\|x\|<∞ | (−1)^((k+2)/2)/(k+3)!, even k≥−2 | 1 | 1.0e-16 / 2.9e-16 / 4.0e-14 | only singularity is the pole at 0 |
| 04 | (x²+1)/(x²−1) | \|x\|>1 | a_0=1, a_k=2 for even k<0 | 2 | 2.6e-37 / 5.1e-17 / 2.9e-16 | term k=400: 0.037 at 1.01, 111 at 0.99 |
| 05 | 4/((x−1)(x+3)) | \|x\|<1 | −1−(−1)^k/3^(k+1), k≥0 | 0.5 | 1.4e-16 / – / 2.6e-16 | term k=400: 0.018 at 0.99, 53.5 at 1.01 |
| 06 | same | 1<\|x\|<3 | −(−1)^k/3^(k+1) for k≥0; 1 for k<0 | 2 | 1.0e-16 / 8.6e-17 / 5.2e-16 | + powers 0.088 at 2.99, 1.26 at 3.01; − powers 0.019 at 1.01, 55.7 at 0.99 |
| 07 | same | \|x\|>3 | a_(−k)=1−(−3)^(k−1), k≥1 (a_(−1)=0) | 5 | 7.8e-40 / 4.5e-17 / 3.1e-16 | term k=400: 0.088 at 3.01, 1.27 at 2.99 |
| 08 | e^(1/x) | 0<\|x\|<∞ | a_(−k)=1/k!, k≥0 | 1 | 8.5e-17 / 1.4e-16 / 1.4e-15 | only singularity is the essential one at 0 |

Comparison polynomials: Taylor about x=1 (case 03), 3 (04), 2 (06), 5 (07), 1 (08), each with the same number of terms as the Laurent sum. Every coefficient is nonzero (smallest magnitude 6e-8, `check.py`), so "same number of terms" holds. Radii: 1, 2, 1, 4, 1. At both ends of each interval the terms of the full Taylor series do not tend to 0 (`n_checks.py`, |a_k|·radius^k at k=60 and 120: case 03 61, 121; 04 0.5, 0.5; 06 1, 1; 07 0.25, 0.25; 08 1.1e5, 4.2e7), so "the full Taylor series converges only on" the open interval holds.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Description | Definition, a_k contour formula, principal part, uniqueness per annulus, Taylor reduction, polynomial has no vertical or horizontal asymptote | Standard theorems (Laurent; Mathews' Remark and Thm 7.9 in the module text) | yes |
| Description (N1) | f analytic on a connected region containing the annulus, with a non-removable singularity on or inside the inner circle (at the center when r=0), has a nonzero negative-power coefficient | Proof: if all a_k with k<0 vanish, the series is analytic on \|z\|<R and equals f on the annulus. Every point of the domain with \|z\|≤r joins the annulus by a path inside the disk, so the identity theorem gives f = series on the domain within the disk, and each such singularity is removable. `n_checks.py`: largest \|a_k\|, k=−1…−8: 1 (03), 2 (04), 1 (06), 2188 (07), 1 (08); control in the disk 6e-62 | yes |
| Animations intro | Mathews has no animations; examples chosen for this page; his module works a disk/annulus/exterior example | `grep -ci animat LaurentSeriesMod.html` → 0; no Laurent item under `a2001/Animations`; text of Example 7.7 names disk, annulus and region | yes |
| Case 01 | within 0.01 of f, widening every frame, about \|x\|≤0.25 to ≤10.9 | `claims.py`: half-widths 0.245 … 10.855, strictly increasing | yes |
| Case 02 | x=0.9 error 0.448→0.044 falling; x=1.2 error 0.590→32.6 growing | `claims.py`: 0.447514→0.0440699 (decreasing True); 0.590164→32.5807 (increasing True) | yes |
| Case 03 | f(0.05)=399.83, sum 399.83, polynomial 40.6; f−x⁻²→−1/6; full Taylor series about 1 converges only on 0<x<2 | `claims.py`: 399.833, 399.833, 40.5912; −0.166667 at x=1e-3; radius 1; end terms above | yes |
| Case 03 (N3) | frame 1 sum tends to y=0; frame 2 sum to −1/6; every sum from frame 3 on has a positive power and is unbounded | `n_checks.py` at x=1e6: 1.0e-12, −0.16666667, 8.33e9; frame table: frame 3 adds x²/120, later frames keep a nonzero top positive power | yes |
| Cases 04, 06, 07, 08 (N2) | "the full Taylor series about x=… converges only on" 1<x<5, 1<x<3, 1<x<9, 0<x<2; the fixed-degree polynomial values are unchanged | radii 2, 1, 4, 1; end terms above | yes |
| Case 04 | within 0.0011 on 1.5≤\|x\|≤10; leaves window near 5.69; −3.06e4 at x=10, f=1.0202; 6.99e5 at x=0.5, f=−1.67 | `claims.py`: 0.00108262; root 5.68553; −30625.016 (`claims2.py`); 1.0202; 699049; −1.66667 | yes |
| Case 05 | x=0.5: −2.28559 vs −2.28571; x=1.5: −582 vs 1.78 | `claims.py`: same values (−582.081, 1.77778) | yes |
| Case 06 | error <0.19 on [−2.5,−1.5], <0.02 on [1.5,2.5]; Taylor error <1e-7; 3.8e14 at x=−2, f=−1.33 | `claims.py`: 0.186933; 0.0170046; 5.96e-8; 3.753e14; −1.33333 | yes |
| Case 07 | series 4x⁻²−8x⁻³+28x⁻⁴; error <7e-4 on 5≤\|x\|≤12; −75.0 at x=12, f=0.0242 | `claims2.py` [0,4,−8,28]; `claims.py` 0.000653035; −74.9628; 0.0242424 | yes |
| Case 08 | every sum below f for x>0; x=0.2: 147.6, 148.4, 44.5; x=−0.1: −1163, 4.5e-5 | `claims2.py` True for all 12 frames on (0,6]; `claims.py` 147.604, 148.413, 44.5324, −1162.62, 4.53999e-5 | yes |
| Frame references | "frame 3" (case 03); last-frame powers and term counts in Behavior text | frame table in script; legends read in final frames | yes |
| Alt text and GIF titles (N2) | Cases 03, 04, 07, 08 now describe the last frame: the polynomial leaves the curve before x=2 (03), before x=5 (04), just past x=9 (07), before x=2 (08). Case 06 keeps "follows it only on the right-hand one" | `n_last.jl`, last frame, within 2% of window height: one run each, 0.44–1.67 (03), 1.47–4.91 (04), 1.24–2.95 (06), 1.68–9.08 (07), 0.48–1.64 (08). `n_frames.jl`: case 06 has no run outside (1,3) in any frame | yes |

## Scripts and GIFs
- Script: `laurent_animations_all.jl`, rewritten. Uses Plots and Printf only (SpecialFunctions dropped). `@__DIR__` output kept. Rendering runs only when the script is executed directly, so the checks can `include` it.
- GIFs: `laurent01–08.gif` regenerated (14, 12, 10, 10, 14, 12, 12, 12 frames); `laurent09–27.gif` deleted. A second run reproduced all 8 byte for byte (`md5sum -c` → 8 OK).
- Curves: f is broken at its poles and each sum at x=0 with NaN points. Nothing is clamped; only non-finite values become NaN, and curves leave the window.
- Frames viewed at full size: 01 f14, 02 f12, 03 f10, 04 f1, 05 f7, 07 f12. Contact sheets: 06, 08. Checked: legends fit, powers and degrees match the frame, shading, asymptotes, breaks at poles.
- `git status` of the page folder: `index.qmd`, the script and `laurent01–08.gif` modified; `laurent09–27.gif` deleted; no other file.

## Legacy archive
Consulted `c2003/LaurentSeriesMod.html` and its four solution pages. The text gives the definition, the annulus, Laurent's theorem, the reduction to Taylor, uniqueness, and Example 7.7 (three series in a disk, an annulus and an outer region). Its formula images are missing locally, so no function could be confirmed and none is attributed to him. The module has no animations. Cases 05–07 use a function chosen for this page, so that the page does not present a recalled formula as his.

## Follow-up from the independent checker

- **N1, confirmed and fixed.** "Inside the inner circle" missed Cases 03, 04, 06 and 08. The revised sentence also requires a connected region: without it the statement is false (f = 1 on \|z\|>1, f = 0 on \|z\|<1 has singular points on the circle and no negative powers for \|z\|>1).
- **N2, confirmed and fixed.** All five Behavior sentences now give the interval to the full Taylor series. The old alt text was not true of every frame: in case 07 the degree-0 and degree-1 polynomials stay within 2% of window height of f over runs of 6.76 and 1.41 outside (1,9), and cases 03 and 04 have short runs outside in frames 1–3. The alt text for 03, 04, 07 and 08 now describes the last frame.
- **N3, confirmed and fixed.** The sentence now states what frames 1, 2 and 3 onward each do.
- Text only: script and all 8 GIFs unchanged (`md5sum -c before_n.md5` → 9 OK). The script has no comment repeating this wording.

## Notes
- Every case has centre 0, the natural centre for these expansions.
- In case 06 the Taylor polynomial about x=2 is more accurate than the Laurent sum on the right-hand interval. The page says so; the Laurent advantage shown there is that one series covers both intervals.
- Modified Padé GIFs in the working tree are not from this fix.

### Director note

The checker's second pass resolved F1 and N1 to N3 and raised N4: the Case 07 alt text said the Taylor polynomial leaves the curve just past x = 9. It leaves before 9 (error 0.019 at x = 8.4; at x = 9, T11 = -0.0833 against f = 0.0417). To stay within the two-round limit, the director applied the checker's one-word correction ('before x equals 9') after recomputing those values with mpmath. That word was not put through a third independent check.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the page now has 8 cases. Cases 01, 02 and 05 reduce to Taylor (no negative power). Cases 03, 04, 06, 07 and 08 have negative powers. Vertical asymptotes are shown in 03, 04, 06, 07, 08 and horizontal asymptotes in 04, 07, 08 (the sums reach them) and in 03 (asymptote of f, followed by the first frame only). Each negative-power case has a same-term-count Taylor polynomial that fails outside its disk of convergence.
- Coefficients: contour integrals (mpmath, 30 digits) match the page formulas for all 8 cases, largest difference 4.1e-23; a second radius in 03, 04, 05, 06, 07, 08 agrees to 1.5e-21 or better. The script's coefficients and Taylor coefficients match exact values (relative error at most 2.9e-16).
- Regions: every Taylor comparison diverges at both endpoints of its stated interval (terms do not tend to 0).
- "Laurent = Taylor" now appears only on Cases 01, 02, 05, where it is true.
- The 19 deleted GIFs (laurent09-27): no reference remains in the page, the script or any other site file (reviews/ excluded).

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Description | Laurent formula, a_k contour integral | Contour integrals reproduce all coefficients | OK |
| Description | Analytic on disk gives no negative powers | Standard; Cases 01, 02, 05 by contour | OK |
| Description | "non-removable singularity inside the inner circle" | Hypothesis literally met only by Case 07 | Minor, see N1 |
| Description | Polynomial has no vertical or horizontal asymptote unless constant | Proof by inspection | OK |
| Animations intro | Colours, shading, same term count, legend | Script and all frames | OK |
| Animations intro | Mathews §7.3 has no animations; works disk, annulus, exterior example | No "animat" in module or its folder; Example 7.7 | OK |
| Case 01 | Series; within 0.01 from about 0.25 to about 10.9, widening every frame | 0.245 to 10.856, strictly increasing over 14 frames | OK |
| Case 02 | Error at 0.9: 0.448 to 0.044, falling | 0.4475 to 0.04407, monotone | OK |
| Case 02 | Error at 1.2: 0.590 to 32.6, growing | 0.5902 to 32.58, monotone | OK |
| Case 03 | Series; f - x^-2 to -1/6 | sympy | OK |
| Case 03 | x=0.05: f=399.83, sum 399.83, T9=40.6 | 399.8334, 399.8334, 40.5912 | OK |
| Case 03 | "converges only on 0<x<2" | Radius 1, endpoints diverge; wording | Minor, see N2 |
| Case 03 | "From frame 3 on ... does not follow y=0" | True, but frame 2 also fails (limit -1/6) | Minor, see N3 |
| Case 04 | Series; within 0.0011 on 1.5<=\|x\|<=10 | Sup error 0.0010826 | OK |
| Case 04 | T9 leaves window near 5.69; -3.06e4 at 10; f=1.0202 | 5.6856; -30625.0; 1.020202 | OK |
| Case 04 | x=0.5: 6.99e5, f=-1.67 | 699049; -1.66667 | OK |
| Case 05 | a_k formula | Contour | OK |
| Case 05 | x=0.5: -2.28559 vs -2.28571; x=1.5: -582 vs 1.78 | -2.285592, -2.285714; -582.08, 1.7778 | OK |
| Case 06 | a_k formula | Contour | OK |
| Case 06 | Errors below 0.19, 0.02; T24 below 1e-7 | 0.18693, 0.017005, 5.96e-8 | OK |
| Case 06 | x=-2: 3.8e14, f=-1.33 | 3.753e14, -1.3333 | OK |
| Case 07 | a_{-k}; series 4, -8, 28 | Contour, sympy | OK |
| Case 07 | Error below 7e-4 on 5<=\|x\|<=12 | 6.53e-4 | OK |
| Case 07 | T11=-75.0 at 12, f=0.0242 | -74.96, 0.024242 | OK |
| Case 08 | Series and limits | sympy | OK |
| Case 08 | Sums below f for x>0 | 80-digit check, 12 frames, x in (0,6]: no violation | OK |
| Case 08 | x=0.2: 147.6, 148.4, T11=44.5 | 147.604, 148.413, 44.532 | OK |
| Case 08 | x=-0.1: about -1163, f about 4.5e-5 | -1162.62, 4.54e-5 | OK |
| Cases 04, 06, 07, 08 | "polynomial ... converges only on" | Intervals right; wording | Minor, see N2 |
| Alt texts (8) | Each description | Compared with first, middle and last frames | OK |
| GIF titles and legends | Powers, term counts, degrees | Frame lists and nonzero counts checked against exact coefficients | OK |

### New problems

- **N1 (Minor), Description, paragraph 2:** "If f has a non-removable singularity inside the inner circle, some negative power has a nonzero coefficient." The statement is true but its hypothesis misses most of the page's own cases: the poles of Cases 04 and 06 lie on the inner circle |x|=1, and in Cases 03 and 08 the singularity is the centre, with inner radius 0. Only Case 07 has a singularity strictly inside. "On or inside the inner circle" is correct and covers them all.
- **N2 (Minor), Cases 03, 04, 06, 07, 08:** "polynomial ... converges only on" an interval. A fixed-degree polynomial does not converge; its Taylor series does. The intervals themselves are right.
- **N3 (Minor), Case 03:** "From frame 3 on, each Laurent sum ... does not follow the horizontal asymptote y=0" implies the earlier frames do. Frame 2 is x^-2 - 1/6, which tends to -1/6, so only frame 1 follows y=0.

### Re-check after the N1-N3 edits

Only `index.qmd` has a newer timestamp. The script is byte-identical to the copy used in the first check. `fix.diff` had been regenerated, so the earlier text was compared with the new text by reading, not by a mechanical diff.

### F1 — resolved (unchanged)

### N1 — resolved
- The revised statement is true. Let f be analytic on a connected open set W containing the annulus A, and suppose every negative coefficient is zero. The series then defines an analytic g on D = {|x-x0|<R} with g = f on A. Any path in W from A to a point on or inside the inner circle stays in D after its last exit from A, because reaching |x-x0|>=R would mean crossing A again. So W intersect D is connected, g = f on all of it by the identity theorem, and every singularity of f on or inside the inner circle is removable. The contrapositive is the page's sentence.
- The added condition is correct and needed. Counterexample without it: f = 1 on 1<|z|<2 and f = 1/z on 0<|z|<1. f is analytic on this disconnected set and has a pole at 0 inside the inner circle, yet its Laurent series on the annulus is the constant 1 (contour on |z|=1.5: all a_k for k=-3..2 within 2e-26 of 1 at k=0 and 0 otherwise).
- The hypothesis now covers Cases 03, 04, 06, 07 and 08, each with f analytic on the connected set C minus its singularities.

### N2 — resolved
- Cases 03, 04, 06, 07, 08 now attribute convergence to the full Taylor series. Intervals 0<x<2, 1<x<5, 1<x<3, 1<x<9, 0<x<2 are right, and the series diverges at both endpoints (terms do not tend to 0).
- Reworded alt text, last frame: Case 03 leaves the curve at about x=1.5-1.6 (T9(2)=-5.14, f(2)=0.114), so "before x equals 2" is right. Case 04 at about x=4.4-4.7 (error 0.25 at x=5), so "before x equals 5" is right. Case 08 at about x=1.5-1.6 (T11(2)=-29.7, f(2)=1.65), so "before x equals 2" is right. Case 07 is wrong, see N4.

### N3 — resolved
- Frame 1 is x^-2, limit 0. Frame 2 is x^-2 - 1/6, limit -1/6. Frames 3-10 have highest powers 2 to 16 with nonzero coefficients, so each is unbounded. y=0 is the horizontal asymptote of f. "In Case 04, every partial sum tends to the horizontal asymptote" is true (limit 1).

### New problem from this pass
- **N4 (Minor), Case 07 alt text:** "in the last frame an orange Taylor polynomial about x equals 5 leaves the curve just past x equals 9." It leaves before 9. T11 differs from f by 0.01 at x=8.21, by one pixel (0.019) at x=8.40 and by three pixels (0.057) at x=8.73. At x=9, T11=-0.0833 against f=0.0417, already on the other side of y=0. A zoomed crop of the last frame shows the same. Should read "before x equals 9".

### Reproducibility (this pass)
- A fresh scratch copy of the script regenerated all 8 GIFs, byte-identical to the page's GIFs. Conventions unchanged: 8 cases, 8 source links, 8 embeds, no code fences, Description before Animations, no reference to laurent09-27.

### Reproducibility and conventions

- Script run from a scratch copy: all 8 GIFs byte-identical to the working-tree GIFs.
- Description precedes Animations; 8 cases, 8 source links, 8 embeds, descriptive alt text, no code fences.
- The diff has 29 entries (index.qmd, the script, 8 changed and 19 deleted GIFs), all inside the page folder.
- Frames examined: first, middle and last of all 8 GIFs at full size, plus contact sheets. Pole breaks are clean: no connector line crosses any pole in f or in a sum.

**Final status:** committed
