# Brent's Method — animation review (round 5)

Page: `pages/numerical-methods/brents-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** There are 0 Error, 0 Misleading and 0 Minor findings.

I checked every claim in the ledger below against computed evidence and all of them hold. The implementation is a faithful transcription of Brent's ZEROIN. Its iterates match an independent implementation, scipy's brentq, bit for bit, and they match Mathews' own printed Brent tables for both examples through every step that both runs share.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `brentsaa.jl` | 0 | 7.8 | brentsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `brentsbb.jl` | 0 | 7.8 | brentsbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "requires only that f be continuous on [a, b] with f(a) and f(b) of opposite sign — no derivatives are needed" | The code uses only values of f. It stops with a valid bracket. | confirmed |
| D2 | IQI "fits x as a quadratic function of y through the three points (a,f(a)), (b,f(b)), (c,f(c)) … evaluates it at y = 0" | The code's p/q formula (lines 70–73) gave the same values as the page's Lagrange formula (line 32): Case 1 step 3 is 0.2276058019714996 from the formula and 0.22760580197149965 from the script; Case 1 step 5 is 0.3282147397456249 and 0.32821473974562487; Case 2 step 5 is 1.1766603295259697 from both. | confirmed |
| D3 | Secant "uses the chord through (a,f(a)) and (b,f(b)) … when … a = c" | Code lines 63–67 take this branch only when `a == c`. The formula on line 40 reproduces the script's step 1 in both cases: 0.8, and 0.5392637731145248. | confirmed |
| D4 | Bisection "guarantees the bracket shrinks by at least half" | d = xm = (c−b)/2, so a bisection step halves \|c−b\| exactly. | confirmed |
| D5 | State: f(b)·f(c) ≤ 0, \|f(b)\| ≤ \|f(c)\|; a is the previous b or coincides with c | Lines 43–51 enforce both inequalities. Line 95 sets a = b before the update. | confirmed |
| D6 | IQI formula (line 32) | This is the standard Lagrange form of inverse interpolation at y = 0. It agrees numerically with the code (see D2). | confirmed |
| D7 | Secant formula s = b − f(b)(b−a)/(f(b)−f(a)) | ZEROIN's p = 2·xm·s, q = 1−s, followed by its sign normalisation, gives d = (a−b)f(b)/(f(b)−f(a)), which is the same step. It also agrees numerically (D3). | confirmed |
| D8 | IQI "accepted only if s falls inside the current bracket and the method is making adequate progress; otherwise a bisection" | Line 82 applies the 3/4 test and the half-step-before-last test. Example: at Case 1 step 2 the IQI candidate is 1.3105, outside [0, 0.8], and the step taken is a bisection. | confirmed |
| D9 | Safeguards: bisect if the interpolation does not stay "within about three quarters of the way from b to c" or "is not smaller than half the step before last" | Line 82: `2p < 3·xm·q − |tol1·q|` means p/q < ¾(c−b) less a small margin, and `p < |e·q/2|` with e the step before last. | confirmed |
| D10 | x⁹ on [−1, 2]: Brent "needs 96 function evaluations to shrink the bracket below 10⁻¹⁰, where bisection needs 37" | `x9.jl`: the script's routine first reaches a width below 1e-10 at step 94, which is 96 evaluations; the final width is 5.0e-11. scipy brentq also reports 96 function calls. Bisection: `python3` loop gives 37 evaluations (35 halvings plus 2 endpoints), with final width 8.7e-11. | confirmed |
| D11 | Fast case order ≈ 1.839, the positive root of t³ = t² + t + 1 | The tribonacci constant is 1.83929. | confirmed |
| D12 | Robustness: cannot fail to converge for a valid bracket and continuous f | This is standard for ZEROIN, and both runs and the x⁹ run terminate with a valid bracket. | confirmed |
| D13 | Comparison table: orders 1, 1, ≈1.618, ≈1.839, up to ≈1.839; which methods are guaranteed and which need derivatives | These are standard values and consistent with the above. | confirmed |

### Animations: introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | "shaded region marks the current bracket between b and c" | Code lines 119, 135–138 shade [min(b,c), max(b,c)]. The frames show it. | confirmed |
| A2 | "red dot tracks b … the endpoint with the smallest \|f\|" | Line 141 uses `st.b`, and the swap on line 48 makes \|f(b)\| ≤ \|f(c)\|. | confirmed |
| A3 | Step annotation shows Bisection, Secant or IQI; "Min step" marks a step shorter than the tolerance (≈5×10⁻¹¹) that is replaced by a step of that length | Lines 96–100 handle this. tol1 = 2·eps·\|b\| + 5e-11 ≈ 5.00005e-11. The Case 2 final frame reads "Step 10: Min step" and \|c−b\| = 5.0e-11. | confirmed |
| A4 | The legend gives b to 10 decimals and \|c−b\| | `@sprintf("b = %.10f, |c−b| = %.1e")`. The frames show it. | confirmed |
| A5 | The bracket is narrower than one pixel from step 6 in Case 1 and step 8 in Case 2 | The plot area is about 640 px wide. Case 1 spans 3.25 units, about 5.1e-3 per px: step 5 width 1.1e-2 is about 2 px, step 6 width 3.3e-4 is under 1 px. Case 2 spans 1.35 units, about 2.1e-3 per px: step 7 width 1.1e-2 is about 5 px, step 8 width 6.8e-5 is under 1 px. | confirmed |
| A6 | Each case's source script is linked under it | Lines 68 and 76 link these. | confirmed |

### Case 1: f(x) = 4x³ − 16x² + 17x − 4, [0, 1]

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Function and interval in the heading | Script line 11 and lines 13–14. The frame title shows the same function. | confirmed |
| C1.2 | f(0) = −4, f(1) = 1 | python: −4 and 1. | confirmed |
| C1.3 | True root x* ≈ 0.3285 | sympy real_roots gives 0.32853845861141489597. | confirmed |
| C1.4 | 8 steps: secant, bisection, IQI, secant, IQI, secant, secant, IQI | `inst_aa.jl` printed this sequence, and the GIF has 9 frames (steps 0–8) with these labels. | confirmed |
| C1.5 | At step 3 the IQI point 0.2276 has the larger \|f\|, so it becomes the other end of the bracket and b stays at 0.4 | Step 3: b = 0.4, c = 0.22760580197. \|f(0.2276)\| = 0.912 and \|f(0.4)\| = 0.496. | confirmed |
| C1.6 | After the step 2 bisection, every step is an interpolation step | Steps 3–8 are all IQI or Secant. | confirmed |
| C1.7 | Errors in b at steps 5–8: 3.2e-4, 5.5e-6, 2.7e-9, 4.0e-19 | mpmath gives 3.2372e-4, 5.4608e-6, 2.7379e-9 and 3.9835e-19. | confirmed |
| C1.8 | At step 8, b is the double nearest the root, and f(b) evaluates to exactly 0 | float(root) = 0.3285384586114149, the same as the script's b. Both neighbours are about 5.5e-17 away. f(b) = 0.0 in the script and in python. | confirmed |
| C1.9 | Bisection needs 32 iterations and regula falsi 24 to get within 10⁻¹⁰ of the root on [0, 1] | `indep.py` gives 32 for bisection (midpoint error) and 24 for regula falsi. | confirmed |
| C1.10 | The other roots are ≈ 1.2647 in [1, 2] and ≈ 2.4068 in [2, 3], and they are visible in the window | sympy gives 1.26465829006 and 2.40680325132. xlims = (−0.15, 3.1), and frame 9 shows both crossings. | confirmed |
| C1.11 | "Mathews' example also finds these with Brent's method, but only the run on [0, 1] is animated" | The archive's `gr_241` and `gr_252` read `BrentMethod[1.0, 2.0, 10^-15]` and `BrentMethod[2.0, 3.0, 10^-15]`. | confirmed |
| C1.12 | Alt text: "narrows from [0,1] to the root at x≈0.3285 in 8 steps, with step labels showing bisection, secant, and IQI" | As C1.3 and C1.4. | confirmed |

### Case 2: f(x) = tan(x) − 2x, [0.5, 1.5]

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Function and interval in the heading | Script line 11 and lines 13–14. The frame title shows "tan(x) − 2x, [0.5, 1.5]". | confirmed |
| C2.2 | The root in [0.5, 1.5] is the smallest positive root, x* ≈ 1.1656 | mpmath findroot gives 1.1655611852072113. tan x − 2x < 0 on (0, 1.1656), because f(0) = 0, f′(0) = −1 and f is convex on (0, π/2). | confirmed |
| C2.3 | f(0.5) ≈ −0.454, f(1.5) ≈ 11.1 | python gives −0.45370 and 11.1014. | confirmed |
| C2.4 | 10 steps: secant, two bisections, secant, IQI, secant, secant, IQI, secant, min step | `inst_bb.jl` printed this sequence, and the GIF has 11 frames with these labels. | confirmed |
| C2.5 | The final bracket has width 5×10⁻¹¹ with b ≈ 1.1655611852 at one end, and it contains the root | The bracket is b = 1.1655611852026313 and c = 1.1655611852526317, width 5.0e-11. The root minus b is +4.6e-12 and c minus the root is +4.5e-11, so the root is inside. | confirmed |
| C2.6 | The step 3 bisection moves the right end off 1.5, to 1.2598 | Step 3 gives c = 1.2598159432786313. | confirmed |
| C2.7 | Regula falsi needs 165 iterations to get within 10⁻¹⁰ | `indep.py` gives 165. | confirmed |
| C2.8 | f is convex here, every chord lands left of the root, and the right endpoint stays at 1.5 | f″ = 2sec²x·tan x > 0 on (0, π/2). In `indep.py` all regula falsi errors are negative and the final bracket is (1.16556118511, 1.5). | confirmed |
| C2.9 | The error eventually shrinks by a factor of about 0.87 per iteration | The final ratios are 0.86642. The theoretical value is 1 − f′(x*)(1.5−x*)/f(1.5) = 0.866418, which rounds to 0.87. | confirmed |
| C2.10 | Alt text: "converging in 10 steps despite the function blowing up near the π/2 asymptote" | 10 steps. The dotted asymptote at π/2 is visible, and the curve is masked within 0.04 of it. | confirmed |

### Wiring

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| W1 | Case 1 links `brentsaa.jl` and embeds `brentsaa.gif`, the [0,1] cubic run | The script parameters match the heading, and the GIF is byte-identical to the regenerated one (manifest). | confirmed |
| W2 | Case 2 links `brentsbb.jl` and embeds `brentsbb.gif`, the tan run | Same evidence as W1. | confirmed |

---

### 3. Implementation checks

### `brentsaa.jl` and `brentsbb.jl`

The two scripts share an identical `run_brents`. They differ only in f, the interval, n_iters, the axis limits, the title, and the masking of the tan asymptote.

**It is the method it claims to be.** `run_brents` (lines 34–105) is a line-by-line transcription of Brent's ZEROIN (Brent 1973, Netlib `zeroin.f`), in the following parts:
- the re-bracket step `c = a; d = e = b − a` when f(b) and f(c) have the same sign;
- the swap that makes b the endpoint with the smaller |f|;
- tol1 = 2·eps·|b| + tol/2 and xm = (c − b)/2;
- the stopping test `|xm| ≤ tol1 or fb == 0`;
- the interpolation branch only when |e| ≥ tol1 and |fa| > |fb|;
- the secant step when a == c, and IQI otherwise, in Brent's p/q form;
- the sign normalisation;
- the acceptance test `2p < 3·xm·q − |tol1·q|` and `p < |e·q/2|`;
- the minimum step `b += sign(xm)·tol1`.

The variant is the original ZEROIN. It is not Dekker's method, the Wikipedia "Brent's method" pseudocode (which uses a different mflag test), or Numerical Recipes' `zbrent` (the same logic but with different tolerance handling). The Description describes this same algorithm (D5, D8, D9).

The `n_iters` cap (14 or 16) is never reached: the runs end at steps 8 and 10 through `fb == 0` and `|xm| ≤ tol1` respectively.

**The numbers are right.** I compared against `scipy.optimize.brentq`, which is a separate C reformulation of Brent's method, with xtol=1e-10 and rtol=4·eps (so its δ equals ZEROIN's tol1). I logged every evaluation point.

| | Script b/c sequence (new evaluation points) | brentq evaluation points | Evaluations |
|---|---|---|---|
| Case 1 | 0.8, 0.4, 0.22760580197149965, 0.33928781217489301, 0.32821473974562487, 0.32854391944914269, 0.32853846134936388, 0.3285384586114149 | identical, bit for bit | 10 / 10 |
| Case 2 | 0.53926377311452489, 1.0196318865572624, 1.2598159432786313, 1.1182930272785787, 1.1766603295259697, 1.1637285834543314, 1.1654929603348207, 1.1655612050524227, 1.1655611852026313, 1.1655611852526317 | identical, bit for bit | 12 / 12 |

I verified the step labels by recomputing the steps: the IQI steps with the page's Lagrange formula (D2), the secant steps with the chord formula (D3), and the step 2 bisection in Case 1 because its IQI candidate 1.3105 lies outside the bracket.

Mathews' printed Brent tables agree with the script value for value: `gr_229` for Case 1 (p₀…p₈) and `gr_276` for Case 2 (p₀…p₉). Mathews ran to tol 1e-15, so his Case 2 continues to p₁₀ = p₁₁ = 1.16556118520721. With the page's tol 1e-10 the script instead stops after the minimum step, and the page describes that correctly.

The x⁹ claim was checked with the script's own routine: 96 evaluations. brentq also gives 96.

**Its reference values are right.** The page quotes these reference values: x* ≈ 0.3285 and the other two cubic roots, which I checked with sympy `real_roots` at 20 digits; x* ≈ 1.1656 for tan, checked with mpmath `findroot` at 50 digits and a residual check through brentq; and the bisection and regula falsi counts, each recomputed from scratch in `indep.py` (32, 24 and 165). Neither script draws an "exact" reference.

**The picture shows what was computed.** I viewed the contact sheets of both GIFs and the final frames, `brentsaa/frame_009.png` and `brentsbb/frame_011.png`:
- In every frame the shaded band and the dashed lines lie at the recorded b and c.
- The red dot is at (b, f(b)).
- The step label and its colour match `st.method`.
- The legend values match the printed b to 10 decimals and the printed |c−b|. For example, Case 2 frame 11 reads 1.1655611852 and 5.0e-11, and Case 1 frame 9 reads 0.3285384586 and 3.2e-04.

The display devices are harmless:
- In Case 1, b is clamped to xlims, but b always lies in [0, 1], so the clamp never acts.
- In Case 2, f(b) is clamped to ylims, but every f(b) lies in [−0.48, 0.06], so the clamp never acts.
- In Case 2 the backdrop is clamped and masked within 0.04 of π/2, and a dotted asymptote line is drawn there. Only the backdrop is affected, and the step 0–2 bracket edge at 1.5 is still drawn.

The Case 1 final frame shows |c−b| = 3.2e-04 while b is already exact. This is ZEROIN terminating on f(b) = 0. The page explicitly says that f(b) = 0 and that the error is 4.0e-19, so the frame does not mislead.

### Fidelity to the legacy archive

Mathews' Example 4 is Brent on 4x³ − 16x² + 17x − 4 for the three roots on [0,1], [1,2] and [2,3]. His Example 5 is tan(x) = 2x on [0.5, 1.5]. The page uses both examples with the same functions and intervals. It animates only the [0, 1] root of Example 4 and says so explicitly (C1.11), so nothing is dropped silently.

Mathews' tolerance is 1e-15 and the page's is 1e-10. This changes only the final steps of Case 2, and the page describes its own run correctly.

Mathews' comparison counts differ from the page's: about 36 and 50 iterations for Example 4, and about 50 and 243 for Example 5. Those counts are at his 1e-15 accuracy. The page states its own counts at 1e-10, and I verified them (C1.9, C2.7), so this is not a fidelity issue.

There is no fidelity finding.

