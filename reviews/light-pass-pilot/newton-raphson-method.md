# Review: Newton-Raphson Method (overview page, light-pass pilot)

**Mode:** overview (action *write*). The diff against `main` adds `## Description` and the heading ids `{#case-1}` … `{#case-6}`; it changes no script or GIF, so the animations were not re-reviewed.

**Result: 0 Error, 0 Misleading, 0 Minor.**

## Findings

None.

## Calibration note

This page was the run's calibration page. The reviewer was given a scratch copy whose Description had two planted errors:

- the asymptotic constant f″(x\*)/(2f′(x\*)) changed from 0.7933 to 0.7963, in the prose and in the table's last row;
- the Case 2 sentence rewritten to say the convergence "speeds up to quadratic" after early halving.

The reviewer reported both as Errors with the correct values (C = 0.7933267586; e_{n+1} = e_n/2 exactly at every step, since x_{n+1} = (x_n + 0.2)/2). The copy was otherwise identical to the committed page, so the rest of the review stands for the real page. Those same computations confirm the real text at the two planted places ("≈ 0.7933", and "reduces to x_{n+1} − 0.2 = ½(x_n − 0.2), exactly the ratio (m−1)/m = 1/2"). The planted findings are not findings on the page.

## Inventory (Phase 1)

- Diff touches only `index.qmd` (50 insertions, 6 heading lines changed).
- GIFs (frames extracted from the committed files): newtonaa 6, newtonbb 13, newtoncc 9, newtondd 11, newtonee 7, newtonff 7 frames. Regeneration skipped (no script changed).
- Mechanical checks: no control characters, no "(Planned)" / "Animation Focus" / "Legacy Animation Inventory" section, no `localhost` link, no code block; every link resolves (six case anchors exist as explicit heading ids; the seven sibling folders exist).
- Description prose: 386 words (each inline `$…$` counted as one word; 480 if inline math is split on spaces). Within 150–400 on the first count.
- Archive: found; the reviewer read `n2003/Newton'sMethodMod.html` and its equation images gr_1–13 and gr_108–116.

## Claim ledger (reviewer's, real-page verdicts)

| # | Claim (Description) | Verdict | Evidence |
|---|---|---|---|
| 1 | Solves a single equation f(x) = 0 | confirmed | definitional; Mathews' algorithm statement |
| 2 | Each step replaces f by its tangent / linear Taylor part | confirmed | matches Animations intro and all six scripts' update line |
| 3 | x_{n+1} = x_n − f(x_n)/f′(x_n) | confirmed | same notation as intro and GIF legends |
| 4 | Needs f′; f′(x_n) ≠ 0 or the step is undefined | confirmed | |
| 5 | Theorem: f ∈ C²[a,b], f(x\*) = 0, f′(x\*) ≠ 0 ⇒ ∃δ > 0, convergence for x₀ ∈ [x\*−δ, x\*+δ] | confirmed | Mathews gr_7–gr_13 |
| 6 | Theorem gives no size for δ | confirmed | |
| 7 | Simple root, f ∈ C² near it: at least quadratic, \|e_{n+1}\| ≈ \|f″\|/(2\|f′\|)\|e_n\|² | confirmed (general) | Mathews gr_110 |
| 8 | Correct digits roughly double | confirmed | |
| 9 | Multiplicity m ≥ 2: linear, ratio (m−1)/m | confirmed (general) | Mathews gr_111 |
| 10 | Case 1 shows the quadratic rate | confirmed | ratios settle at 0.793 |
| 11 | Case 2: f = (1−5x)², double root 0.2 | confirmed | newtonbb.jl line 11 |
| 12 | Case 2 iteration reduces to x_{n+1} − 0.2 = ½(x_n − 0.2), exactly (m−1)/m | confirmed | e_{n+1}/e_n = 0.5 to machine precision, 12 steps (checked on the calibration copy's planted variant; the computation confirms the real sentence) |
| 13 | Case 1: f = 3eˣ − 4cos x, x₀ = 1 | confirmed | newtonaa.jl lines 10, 14 |
| 14 | x\* = 0.254850059029 | confirmed | 0.2548500590288503… (mpmath, 50 digits) |
| 15 | Error exponents −2, −4, −7, −13 from n = 2 | confirmed | 3.09e-2, 7.27e-4, 4.19e-7, 1.39e-13 |
| 16 | e_n/e_{n−1}² settles at f″/(2f′) ≈ 0.7933 | confirmed | C = 0.7933267586 |
| 17 | Table x_n, rows 0–5 | confirmed | to 12 decimals, mp and double |
| 18 | Table e_n | confirmed | 0.745150, 0.224902, 0.0308883, 7.26841e-4, 4.18705e-7, 1.39081e-13 |
| 19 | Table ratios 0.4050, 0.6107, 0.7618, 0.7926, 0.7933 | confirmed | 0.405047, 0.610671, 0.761819, 0.792555, 0.793326 |
| 20 | Convergence only local | confirmed | |
| 21 | Case 4: attracting 4-cycle from x₀ = 0, never near the real root | confirmed | cycle {3.000498, 1.961897, 1.147502, 0.007446}, multiplier 0.2325; root −1.6716998817; matches frame legends |
| 22 | Case 5: x_n → +∞ while f(x_n) → 0 | confirmed | 2, 4, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188; f falls to 4.46e-4 |
| 23 | Stopping test on \|f(x_n)\| alone would accept a far point | confirmed | |
| 24 | Case 3: x₀ = 1.35 converges | confirmed | …, 0.2916, −0.01625, 2.86e-6, −1.6e-17, 0; frame 9 |
| 25 | Case 6: x₀ = 1.4 past x_c ≈ 1.3917 diverges in growing oscillations | confirmed | 1.4, −1.4136, 1.4501, −1.5506, 1.8471, −2.8936, 8.7103; x_c = 1.39174520 |
| 26 | Secant replaces f′ by the slope through the last two iterates | confirmed | consistent with secant page |
| 27 | Bisection / False Position keep a bracket, slower, cannot lose it | confirmed (general) | |
| 28 | Fixed Point Iteration with g(x) = x − f(x)/f′(x) | confirmed | Mathews gr_13 |
| 29 | Accelerated and Modified N-R restore quadratic convergence at multiple roots | confirmed | that page, line 12 |
| 30 | Halley's uses f″, cubic at simple roots | confirmed | Halley page, line 12 |
| 31 | Nonlinear Systems extends Newton to several equations | confirmed | that page, lines 40–46 |
| 32 | Seven sibling links and six case anchors resolve | confirmed | |

## Standard and implementation checks

- Six points present, in order: problem (line 12), formula (15–17), assumptions (19–21), accuracy (23–35 plus table), failure modes with case links (47–50), where it fits (52).
- Table: 6 rows, the page's own Case 1, adds the digits the GIF does not show. No proofs, no callout boxes.
- Outside the Description: only the six heading ids (allowed cross-reference anchors).
- Scripts not under review; for every case the text cites, the reviewer reproduced the script's iteration from its parameters in Python and compared with the frames (newtonaa f6, newtonbb f13, newtoncc f9, newtonee f7, contact sheets of newtondd and newtonff).
- Fidelity: both theorems stated with Mathews' hypotheses. No Fidelity finding.
