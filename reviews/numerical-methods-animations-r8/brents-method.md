# Brent's Method — animation review (round 8)

Page: `pages/numerical-methods/brents-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim in the Description and Animations sections was confirmed against an instrumented run of the scripts and an independent Python computation (below). No implementation, page-match or fidelity defect found.

Considered and not reported:
- Description item 2 heads the a = c linear step "Secant method (regula falsi)" while the comparison table lists Secant and Regula Falsi separately. In ZEROIN the linear step is taken only when a = c, i.e. through the two bracketing points b and c, so it is literally a false-position step; Mathews also calls it regula falsi. Not misleading.
- Line 34 "accepted only if s falls inside the current bracket and ... adequate progress" is a necessary condition (the real test is the 3/4 rule), and line 44 gives the exact tests. Not a finding.
- Archive uses tolerance 1e-15 (Mathews' Example 4 ends at 0.3285384586114148, Example 5 at 1.16556118520721); the scripts use 1e-10. Iterates p1-p7 (Ex. 4) and p1-p9 (Ex. 5) in Mathews' tables are identical to the script's b sequence to all 16 printed digits; only the tolerance-dependent tail differs, and the page does not claim to reproduce Mathews' tolerance. Example 4's other two roots are explicitly mentioned on the page as not animated. Not a fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `brentsaa.jl` | 0 | 8.6 | brentsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `brentsbb.jl` | 0 | 8.8 | brentsbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `brentsaa.gif` | 9 | byte-identical | brentsaa |
| `brentsbb.gif` | 11 | byte-identical | brentsbb |

### Page references

- Scripts linked: `brentsaa.jl`, `brentsbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | Requires only continuity and f(a), f(b) of opposite sign; no derivatives | confirmed | script uses only f |
| D2 | IQI fits x as quadratic in y through (a,fa),(b,fb),(c,fc), evaluated at y=0; superlinear near simple root | confirmed | page formula (line 32) evaluated in Python reproduces script IQI iterates exactly: C1 step 3 0.2276058019714996, step 5 0.3282147397456249; C2 step 5 1.1766603295259697, step 8 1.1655612050524227 |
| D3 | Secant used when only two distinct points (a = c) | confirmed | script line 63 |
| D4 | Secant formula s = b − f(b)(b−a)/(f(b)−f(a)) | confirmed | reproduces C1 step 1 0.8, step 4 0.339287812174893; C2 step 1 0.5392637731145249 |
| D5 | Bisection as safeguard; halves the bracket | confirmed | d = xm; C1 step 2 0.8→0.4, C2 step 2/3 widths 0.9607→0.4804→0.2402 |
| D6 | State: f(b)f(c) ≤ 0, \|f(b)\| ≤ \|f(c)\|; a = previous b or a = c | confirmed | script lines 43-51, 95; every recorded step satisfies both (instrumented output) |
| D7 | Interpolation accepted only if within ~3/4 of the way from b to c and smaller than half the step before last | confirmed | script line 82: 2p < 3·xm·q − \|tol1·q\| and p < \|e·q/2\| (Brent 1973 ZEROIN) |
| D8 | x^9 on [−1,2]: Brent needs 96 evaluations to get bracket below 1e-10; bisection 37 | confirmed | indep.py: ZEROIN tol 1e-10 → 96 evals, final width 5.0e-11 (first width <1e-10 also at 96); bisection 35 halvings of width 3 + 2 endpoint evals = 37 |
| D9 | Order ≈1.839, positive real root of t³ = t² + t + 1 | confirmed | tribonacci constant 1.8393 |
| D10 | Never fails to converge with valid bracket and continuous f | confirmed (standard result) | |
| D11 | Table orders: bisection 1, RF 1, secant ≈1.618, IQI ≈1.839 | confirmed | standard |
| A1 | Shaded region = bracket between b and c | confirmed | script lines 119, 135-138; frames |
| A2 | Red dot = b, endpoint with smaller \|f\| | confirmed | script line 141-143; \|f(b)\| ≤ \|f(c)\| at all steps |
| A3 | Step annotation = sub-method chosen; "Min step" = step shorter than tol ≈5e-11 replaced by that length | confirmed | tol1 = 2eps\|b\| + 5e-11 ≈ 5.00000005e-11; script lines 96-100 |
| A4 | Legend gives b to 10 decimals and \|c−b\| | confirmed | `%.10f`, `%.1e`; frames |
| A5 | Bracket narrower than one pixel from step 6 (C1) and step 8 (C2) | confirmed | measured scale ≈191 px/unit (C1), ≈475 px/unit (C2); C1 step5 0.011→2.1 px, step6 3.3e-4→0.06 px; C2 step7 0.0112→5.3 px, step8 6.8e-5→0.03 px |
| A6 | Julia scripts linked under each case | confirmed | |
| C1-1 | Case 1 f = 4x³−16x²+17x−4, [0,1] | confirmed | script lines 11-14; title |
| C1-2 | f(0) = −4, f(1) = 1 | confirmed | |
| C1-3 | Root ≈ 0.3285 | confirmed | mpmath 0.328538458611414896 |
| C1-4 | 8 steps: secant, bisection, IQI, secant, IQI, secant, secant, IQI | confirmed | instrumented and independent runs agree; 9 frames |
| C1-5 | Step 3 IQI point 0.2276 has larger \|f\|, becomes other end; b stays 0.4 | confirmed | c = 0.22760580, f(c) = −0.912 vs f(0.4) = 0.496 |
| C1-6 | After step 2 every step is interpolation | confirmed | |
| C1-7 | Errors at steps 5-8: 3.2e-4, 5.5e-6, 2.7e-9, 4.0e-19 | confirmed | 3.237e-4, 5.461e-6, 2.738e-9, 3.983e-19 |
| C1-8 | Step-8 b is the nearest double to the root; f(b) = 0 exactly | confirmed | err 3.98e-19; neighbours' errors +5.59e-17, −5.51e-17; f(b) = 0.0 |
| C1-9 | Stops because f(b) = 0, bracket 3.2e-4 wide | confirmed | \|c−b\| = 3.237e-4 |
| C1-10 | Bisection 32 iterations, regula falsi 24 to get within 1e-10 | confirmed | indep.py: 32, 24 (actual-error criterion) |
| C1-11 | Other roots ≈1.2647 in [1,2], ≈2.4068 in [2,3], visible in window | confirmed | 1.26465829, 2.40680325; xlims (−0.15, 3.1) |
| C1-12 | Mathews' example also finds the other roots with Brent | confirmed | archive lnk_6 Roots (ii), (iii) |
| C1-13 | Alt text: b converges to ≈0.3285 in 8 steps; bracket [0,1] → width 3.2e-4; labels bisection/secant/IQI | confirmed | |
| C2-1 | Case 2 f = tan x − 2x, [0.5, 1.5] | confirmed | script; title |
| C2-2 | Smallest positive root ≈1.1656 | confirmed | 1.16556118520721; f < 0 on (0, x*) |
| C2-3 | f(0.5) ≈ −0.454, f(1.5) ≈ 11.1 | confirmed | −0.45370, 11.1014 |
| C2-4 | 10 steps: secant, 2 bisections, secant, IQI, secant, secant, IQI, secant, min step | confirmed | 11 frames |
| C2-5 | Final bracket width 5e-11, b ≈ 1.1655611852 at one end, root inside | confirmed | b = 1.1655611852026, c = 1.1655611852526, root between (err of b 4.6e-12) |
| C2-6 | Step-3 bisection moves right end from 1.5 to 1.2598 | confirmed | c = 1.2598159433 |
| C2-7 | Regula falsi needs 165 iterations to within 1e-10; f convex, chords left of root, right end stays 1.5, error ratio ≈0.87 | confirmed | indep.py: 165; final right endpoint 1.5; observed ratio 0.8664; asymptotic 1 − f'(x*)(1.5−x*)/f(1.5) = 0.86642; f'' = 2sec²x tan x > 0 |
| C2-8 | Alt text: converges in 10 steps; function blows up near π/2 | confirmed | dotted line at π/2 in frames |
| W1 | Case 1 link/embed → brentsaa.jl/.gif; Case 2 → brentsbb.jl/.gif | confirmed | parameters in headings match scripts |

### 3. Implementation checks

Both scripts share an identical `run_brents` (diff shows only parameters, window, title, and backdrop masking).

**Method.** `run_brents` is Brent's ZEROIN (1973) faithfully: sign-reset of c with d = e = b − a, swap so \|f(b)\| ≤ \|f(c)\|, tol1 = 2·eps·\|b\| + tol/2, xm = (c−b)/2, termination on \|xm\| ≤ tol1 or fb = 0, interpolation only if \|e\| ≥ tol1 and \|fa\| > \|fb\|, linear step if a = c else IQI in Brent's p/q form, acceptance 2p < 3xm·q − \|tol1·q\| and p < \|e·q/2\|, minimum step copysign(tol1, xm). Checked line by line against the ZEROIN flow; the p/q sign handling yields d = −(p/q) as required (verified on a hand example a=0, b=1, fa=−1, fb=1 → 0.5).

**Numbers.** Instrumented copies (`review/brentsaa_instr.jl`, `brentsbb_instr.jl`) print every (method, b, c). An independently written Python ZEROIN (`review/indep.py`) produces the identical sequence to 17 significant digits for both cases (table above). Independently of any ZEROIN transcription, the page's own Lagrange IQI and secant formulas applied to the script's (a,b,c) reproduce each interpolation iterate exactly, and the archive's Mathematica output (Mathews' own Brent routine) lists the same iterates p1-p7 (Ex. 4) and p1-p9 (Ex. 5). Every recorded bracket contains the mpmath root.

| Step | C1 script b | C1 err (indep) | C2 script b | C2 err (indep) |
|---|---|---|---|---|
| 0 | 1 | 6.7e-1 | 0.5 | 6.7e-1 |
| 1 | 0.80000000000000004 | 4.7e-1 | 0.53926377311452489 | 6.3e-1 |
| 2 | 0.40000000000000002 | 7.1e-2 | 1.0196318865572624 | 1.5e-1 |
| 3 | 0.40000000000000002 | 7.1e-2 | 1.0196318865572624 | 1.5e-1 |
| 4 | 0.33928781217489301 | 1.1e-2 | 1.1182930272785787 | 4.7e-2 |
| 5 | 0.32821473974562487 | 3.2e-4 | 1.1766603295259697 | 1.1e-2 |
| 6 | 0.32854391944914269 | 5.5e-6 | 1.1637285834543314 | 1.8e-3 |
| 7 | 0.32853846134936388 | 2.7e-9 | 1.1654929603348207 | 6.8e-5 |
| 8 | 0.3285384586114149 | 4.0e-19 | 1.1655612050524227 | 2.0e-8 |
| 9 | — | — | 1.1655611852026313 | 4.6e-12 |
| 10 | — | — | 1.1655611852026313 (min step, c moves) | 4.6e-12 |

**Reference values.** No reference curve is drawn; the roots quoted in comments/page (0.3285, 1.2647, 2.4068, 1.1656) agree with mpmath polyroots/findroot at 50 digits.

**Picture.** Committed GIFs are byte-identical to fresh scratch runs (manifest). Viewed contact sheets of both GIFs and full frames brentsaa 4 and brentsbb 11: bracket shading spans min/max(b,c); red dot is at (b, f(b)); legend values match the printed values; step labels and colours match the computed method; frame counts 9 and 11 = 8 and 10 steps + start. Clamping: C1 x-clamp of b and C2 y-clamp of f(b) never activate (b ∈ [0.33,1], \|f(b)\| < 0.5). C2 backdrop masked within 0.04 of π/2 and clamped just beyond ylims — only affects parts of the curve already off-screen (f(1.5) = 11.1 > 8). Nothing visible contradicts the page.

