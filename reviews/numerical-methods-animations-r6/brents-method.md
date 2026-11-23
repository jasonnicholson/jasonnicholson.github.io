# Brent's Method — animation review (round 6)

Page: `pages/numerical-methods/brents-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no errors, nothing misleading and no minor issues. I checked every claim in the ledger below against my own computation, and each one agrees at the precision the page states.

Items I considered and decided were not findings:

- **Case 1 stops with the bracket still 3.2e-4 wide.** The final frame of Case 1 shows `|c−b| = 3.2e-04`. The run stops because f(b) == 0 exactly, not because the bracket fell below tolerance. The page says so explicitly ("f(b) evaluates to exactly 0"), so this does not mislead. The alt text says "bracket narrows … to the root", which is loose but true: b is the double nearest the root.
- **The "Step 3: IQI" label is crossed by the dashed bracket line** at x = 0.2276 in Case 1, frame 4. This is cosmetic and the label stays readable.
- **Case 2 stops at tol = 1e-10, where Mathews ran to about 1e-15.** Case 2 stops at step 10 (Min step) with b = 1.1655611852026313, error 4.6e-12. Mathews continues to p10 = p11 = 1.165561185207211. The page's numbers are stated for its own tolerance and are right for it. Mathews' regula falsi and bisection counts (36/50, 243/50) differ from the page's (24/32, 165) for the same reason: a different tolerance. The page does not attribute its counts to Mathews.
- **Mathews' Examples 1–3 are not animated.** These are the module's secant and IQI examples (lnk_2–lnk_5). They illustrate other methods, not Brent's, and the site has separate secant and regula falsi pages. Only Mathews' two Brent examples (4 and 5) are Brent cases. The page animates both and states that it drops roots (ii) and (iii) of Example 4.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `brentsaa.jl` | 0 | 7.7 | brentsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `brentsbb.jl` | 0 | 8.0 | brentsbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | IQI "fits x as a quadratic function of y through (a,f(a)),(b,f(b)),(c,f(c)) … evaluates it at y=0" | The script's p/q form gives the same iterates, to 17 digits, as my Lagrange-form IQI (indep.py) | confirmed |
| D2 | Secant used "when IQI cannot be used (only two distinct points, a = c)"; chord through (a,f(a)),(b,f(b)) | Code line 63 `if a == c` → Secant. With a = c the chord passes through the bracket ends, so "(regula falsi)" is apt | confirmed |
| D3 | Bisection "guarantees the bracket shrinks by at least half" | A bisection step sets b to the midpoint of [b,c], so the new bracket is exactly half | confirmed |
| D4 | State: f(b)·f(c) ≤ 0, \|f(b)\| ≤ \|f(c)\|; a = previous b or coincides with c | Code lines 43–51; every logged step satisfies both | confirmed |
| D5 | IQI Lagrange formula for s | Standard; equal to the script's step (see D1) | confirmed |
| D6 | Secant formula s = b − f(b)(b−a)/(f(b)−f(a)) | Derived from code: p = 2·xm·s, q = 1−s with a = c, then the sign flip, gives d = −fb(b−a)/(fb−fa). Independent implementation matches | confirmed |
| D7 | Interpolation rejected if it would not stay within about 3/4 of the way from b to c, or is not smaller than half the step before last | Code line 82: `2p < 3·xm·q − \|tol1·q\|` means \|d\| < ¾\|c−b\| (less a tol margin); `p < \|e·q/2\|` means \|d\| < \|e\|/2, where e is the step before last | confirmed |
| D8 | x^9 on [−1,2]: 96 function evaluations to shrink bracket below 1e-10; bisection 37 | Script's own routine with counter: 96 evals, 94 steps, final \|c−b\| = 5.0e-11. Independent: 96. Bisection: 35 midpoints + 2 endpoint evals = 37 (width 8.7e-11) | confirmed |
| D9 | Fast-case order ≈ 1.839, positive root of t³ = t² + t + 1 | numpy roots: 1.83928676 | confirmed |
| D10 | Comparison table (secant ≈ 1.618, IQI ≈ 1.839, Brent up to ≈ 1.839, guarantees) | Standard results | confirmed |
| A1 | Shaded region = bracket between b and c | Plot code lines 119, 135–138 use min/max(st.b, st.c) | confirmed |
| A2 | Red dot = b, the endpoint with smaller \|f\| | Code line 141 `st.b`, after the swap at lines 48–51 | confirmed |
| A3 | Step annotation shows Bisection / Secant / IQI | The frames' labels match the logged methods | confirmed |
| A4 | "Min step" = step shorter than tolerance (≈ 5×10⁻¹¹), replaced by a step of that length | Code lines 96–100. tol1 = 2·eps·\|b\| + 5e-11 ≈ 5.00005e-11 at b ≈ 1.17. Case 2 step 10 moves by 5.000e-11 | confirmed |
| A5 | Legend gives b to 10 decimals and \|c−b\| | `@sprintf("b = %.10f, \|c−b\| = %.1e")`; the frames show it | confirmed |
| A6 | Bracket narrower than one pixel from step 6 (Case 1) and step 8 (Case 2) | px.py: Case 1 has ≈ 191 px/unit. Step 5 is 2 px wide (cols 158, 160); step 6 is one column. Case 2 has ≈ 480 px/unit. Step 7 is 5 px wide (cols 458, 463); step 8 is one column | confirmed |
| A7 | Scripts linked under each case | brentsaa.jl / brentsbb.jl | confirmed |
| C1-1 | f(x) = 4x³−16x²+17x−4 on [0,1] | Script lines 11, 13–14; title matches | confirmed |
| C1-2 | f(0) = −4 < 0, f(1) = 1 > 0 | Direct | confirmed |
| C1-3 | Root x* ≈ 0.3285 | mpmath: 0.32853845861141489597 | confirmed |
| C1-4 | 8 steps: secant, bisection, IQI, secant, IQI, secant, secant, IQI | Script log and independent implementation are identical (steps 1–8) | confirmed |
| C1-5 | At step 3 the IQI point 0.2276 has larger \|f\|, becomes the other end; b stays at 0.4 | Step 3: c = 0.2276058, f(c) = −0.912; b = 0.4, f(b) = 0.496 | confirmed |
| C1-6 | After the bisection at step 2 every step is interpolation | Steps 3–8: IQI, Sec, IQI, Sec, Sec, IQI | confirmed |
| C1-7 | Errors in b at steps 5–8: 3.2e-4, 5.5e-6, 2.7e-9, 4.0e-19 | 3.24e-4, 5.46e-6, 2.74e-9, 3.98e-19 | confirmed |
| C1-8 | At step 8 b is the double nearest the root and f(b) evaluates to exactly 0 | b = 0.3285384586114149 = float(root) (neighbours are 5.5e-17 and 5.6e-17 away). f(b) = 0.0 in both Julia and Python | confirmed |
| C1-9 | To get within 1e-10: bisection 32 iterations, regula falsi 24 | First midpoint within 1e-10: iteration 32. Regula falsi: 24 (counting the first iterate whose actual error is < 1e-10) | confirmed |
| C1-10 | Other roots ≈ 1.2647 in [1,2] and ≈ 2.4068 in [2,3]; window shows them | np.roots: 1.26465829, 2.40680325. xlims (−0.15, 3.1) shows them | confirmed |
| C1-11 | Mathews' example also finds these with Brent's method | lnk_6: Roots (ii) and (iii) found with Brent | confirmed |
| C1-12 | Alt: "bracket narrows from [0,1] to the root at x≈0.3285 in 8 steps" | 9 frames, steps 0–8, final b = root | confirmed |
| C2-1 | f(x) = tan(x) − 2x on [0.5, 1.5] | Script; title matches | confirmed |
| C2-2 | Root ≈ 1.1656, the smallest positive root of tan x = 2x | mpmath: 1.16556118520721131. The next positive root lies beyond π | confirmed |
| C2-3 | f(0.5) ≈ −0.454, f(1.5) ≈ 11.1 | −0.45370, 11.1014 | confirmed |
| C2-4 | 10 steps: secant, 2 bisections, secant, IQI, secant, secant, IQI, secant, min step | Script log and independent implementation are identical | confirmed |
| C2-5 | Ends with bracket width 5×10⁻¹¹ and b ≈ 1.1655611852 at one end, root inside | b = 1.1655611852026313, c = 1.1655611852526317, width 5.000e-11. The root 1.16556118520721 lies between them | confirmed |
| C2-6 | The bisection at step 3 moves the right end off 1.5, to 1.2598 | Step 3: c = 1.2598159432786313 | confirmed |
| C2-7 | Regula falsi needs 165 iterations to get within 1e-10 | 165 | confirmed |
| C2-8 | f convex here, every chord lands left of root, right endpoint stays 1.5 | min f'' on [0.5,1.5] = 1.42 > 0. Regula falsi's right endpoint is still 1.5 at the end | confirmed |
| C2-9 | Error eventually shrinks by a factor ≈ 0.87 per iteration | Last ratios 0.8664. Theory: 1 − f'(r)(1.5−r)/f(1.5) = 0.8664 | confirmed |
| C2-10 | Alt: converges in 10 steps; function blows up near the π/2 asymptote | 11 frames (steps 0–10). Dotted line at π/2, curve masked within 0.04 | confirmed |

### 3. Implementation checks

### `brentsaa.jl` and `brentsbb.jl`

The two scripts share the same `run_brents` routine and differ only in their parameters and plot details.

**Is it the method it claims to be?** Yes. The routine is Brent's ZEROIN as in Brent (1973) and Forsythe–Malcolm–Moler, with no simplification. I compared it line by line:

- the c reset on a sign change, with d = e = b − a;
- the swap that makes \|f(b)\| ≤ \|f(c)\| (`a,b,c = b,c,b`, the same as FMM's a=b; b=c; c=a);
- tol1 = 2·eps·\|b\| + tol/2 and xm = (c−b)/2;
- termination on \|xm\| ≤ tol1 or fb = 0;
- the secant when a = c and IQI otherwise, in the p/q form;
- the two acceptance tests;
- the minimum step of size tol1.

The one addition is the "Min step" label, which is display only. The page describes the same variant: IQI with a secant fallback when a = c, bisection safeguards, and the ¾ and half-step-before-last tests.

**Are the numbers right?** Yes. My `indep.py` is a separate ZEROIN that computes each candidate from the Lagrange IQI formula and the plain secant formula, and applies the acceptance tests in geometric form. It reproduces every step of both scripts: the same b, c and method, with b and c equal to 17 significant digits.

| Step | Script b (Case 1) | Independent b | Method (both) |
|---|---|---|---|
| 0 | 1 | 1 | init |
| 1 | 0.80000000000000004 | 0.80000000000000004 | Secant |
| 2 | 0.40000000000000002 | same | Bisection |
| 3 | 0.40000000000000002 (c = 0.22760580197149965) | same | IQI |
| 4 | 0.33928781217489301 | same | Secant |
| 5 | 0.32821473974562487 | same | IQI |
| 6 | 0.32854391944914269 | same | Secant |
| 7 | 0.32853846134936388 | same | Secant |
| 8 | 0.3285384586114149 (f = 0) | same | IQI |

| Step | Script b (Case 2) | Independent b | Method (both) |
|---|---|---|---|
| 0 | 0.5 | 0.5 | init |
| 1 | 0.53926377311452489 | same | Secant |
| 2 | 1.0196318865572624 | same | Bisection |
| 3 | 1.0196318865572624 (c = 1.2598159432786313) | same | Bisection |
| 4 | 1.1182930272785787 | same | Secant |
| 5 | 1.1766603295259697 | same | IQI |
| 6 | 1.1637285834543314 | same | Secant |
| 7 | 1.1654929603348207 | same | Secant |
| 8 | 1.1655612050524227 | same | IQI |
| 9 | 1.1655611852026313 | same | Secant |
| 10 | 1.1655611852026313 (c = 1.1655611852526317) | same | Min step |

Mathews' own Mathematica tables (gr_229, gr_276) give the same p0–p8 for Case 1 and the same p0–p9 for Case 2, which is a third, independent confirmation. Every logged state satisfies f(b)·f(c) < 0. For a property check I ran the method on x^9, where the answer is known. It converges to b = −8.1e-12, and the bracket ends at 5e-11, inside [−1,2]. The iterates converge superlinearly near the end: the Case 1 errors 3.2e-4, 5.5e-6, 2.7e-9 and 4e-19 fit an order of about 1.8.

**Are the reference values right?** Neither script draws a "true" root. The roots in the header comments, ≈ 0.3285 and ≈ 1.1656, agree with mpmath (0.328538458611…, 1.165561185207…). The backdrop curves are the exact functions. Case 1 clamps them to ylims ± 1. Case 2 clamps them to ylims ± 0.5 and masks to NaN within 0.04 of π/2, which only hides the asymptote branch.

**Does the picture show what was computed?** Yes. I viewed both contact sheets plus Case 1 frame 4 and Case 2 frame 11 at full size:

- The shading and dashed lines are at min/max(b, c) of each logged state. The pixel columns I measured match the logged values: Case 1 step 3 has lines at 0.2276 and 0.4, and Case 2 step 5 has lines at 1.1183 and 1.1767.
- The red dot is at (b, f(b)). It is clamped only in x in Case 1 and only in y in Case 2, and neither clamp is ever active, because every b lies in the window and every \|f(b)\| ≤ 0.48.
- The step label is "Step i−1" with the method of the step that produced that b.
- The legend values equal the logged b and \|c−b\|.
- The titles match the code functions.
- Frame counts: 9 frames (steps 0–8) and 11 frames (steps 0–10).
- The view windows contain the whole initial bracket and, in Case 1, all three roots.

