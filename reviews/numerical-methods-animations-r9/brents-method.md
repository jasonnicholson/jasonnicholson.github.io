# Brent's Method — animation review (round 9)

Page: `pages/numerical-methods/brents-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I checked every claim in the ledger below against my own computations and found none that is false or misleading.

Observations that are not findings:

- **Variant note (implementation, no action needed).** The script's comment says "Brent's ZEROIN, 1973". The sign test at line 43, `fb * (fc / abs(fc)) > 0`, is the Forsythe-Malcolm-Moler / Netlib `zeroin.f` form. In Brent's ALGOL original the test is `(fb > 0) = (fc > 0)`. The two forms give different results only when `f(b) == 0` exactly, and that happens at step 8 of Case 1. With the original test, `c` would be reset to the previous `b`, and the final bracket would be 2.7e-9 wide (my `indep.py` gives c = 0.3285384613493639). With the script's test, `c` stays at 0.32821473974562487, giving a width of 3.2e-4. The page's sentence "with the bracket still 3.2×10⁻⁴ wide" is therefore correct for the code that runs. Either way, `b` is the exact (nearest-double) root at that point, so both brackets are valid. This is a legitimate variant, not an error. If the owner wants the comment to be exact, it could say "ZEROIN (Forsythe-Malcolm-Moler form of Brent 1973)".
- `method_labels` (brentsaa.jl line 114, brentsbb.jl line 115) is unused. That is style only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `brentsaa.jl` | 0 | 15.3 | brentsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `brentsbb.jl` | 0 | 17.0 | brentsbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Requires only f continuous on [a,b], f(a), f(b) opposite sign, no derivatives | Algorithm uses only f values | confirmed |
| D2 | IQI fits x as quadratic in y through (a,fa),(b,fb),(c,fc), evaluated at y=0 | Script lines 70-73; `iqi.py` Lagrange formula equals script's IQI iterates (c1 s3: 0.2276058019714996 vs 0.22760580197149965; c1 s5: 0.3282147397456249 vs 0.32821473974562487; c1 s8: 0.3285384586114149 vs 0.3285384586114149) | confirmed |
| D3 | IQI formula (Lagrange form, line 32) | Same as D2; it is the Lagrange interpolant of x(y) at y=0 | confirmed |
| D4 | Secant / regula-falsi step through (a,f(a)),(b,f(b)) when a=c; formula s = b − f(b)(b−a)/(f(b)−f(a)) | Script p=2·xm·s, q=1−s with a=c reduces algebraically to that formula; c1 step 1 gives 0.8 both ways | confirmed |
| D5 | Bisection as safeguard; bracket shrinks by at least half | d = xm = (c−b)/2 | confirmed |
| D6 | State: f(b)f(c) ≤ 0, abs(f(b)) ≤ abs(f(c)); a = previous b or coincides with c | Lines 43-51, 95 | confirmed |
| D7 | IQI accepted only if inside the bracket and making adequate progress, else bisection | Line 82 acceptance test | confirmed |
| D8 | Safeguard: bisect if the interpolation step doesn't stay within ≈3/4 of the way from b to c, or isn't smaller than half the step before last | `2p < 3·xm·q − abs(tol1·q)` ⇔ abs(d) < (3/4)abs(c−b) − tol1/2; `p < abs(e·q/2)` with e = the step before last (e is updated only after the test, so the test sees the old e) | confirmed |
| D9 | x^9 on [−1,2]: Brent needs 96 function evaluations to shrink the bracket below 1e-10; bisection 37 | `counts.py`: with the page's tolerance (t = 5e-11, as in the scripts) the first bracket below 1e-10 comes at 96 evaluations (2 initial + 94). Bisection: 3/2^35 < 1e-10 is 35 iterations + 2 = 37. (With t=0 it would be 103; the page's convention is the scripts' tolerance.) | confirmed |
| D10 | Order ≈1.839 = positive root of t³=t²+t+1 | 1.8393³ = 6.222 ≈ 1.8393²+1.8393+1 | confirmed |
| D11 | Table rows (bisection 1, RF linear, secant ≈1.618, IQI ≈1.839, Brent up to ≈1.839) | Standard results | confirmed |
| A1 | Shaded region = bracket between b and c | Lines 119, 135-138; frames | confirmed |
| A2 | Red dot = b, the endpoint with smaller abs(f) | Lines 47-51, 141-143; frames | confirmed |
| A3 | Step annotation shows Bisection/Secant/IQI; "Min step" = a step shorter than tol (≈5e-11) replaced by a step of that length | Lines 96-101; tol1 = 2·eps·abs(b) + 5e-11 ≈ 5.0e-11; frame labels read Start/Secant/Bisection/IQI/Min step | confirmed |
| A4 | Legend gives b to 10 decimals and abs(c−b) | `%.10f`, `%.1e` at line 144; frames | confirmed |
| A5 | Bracket narrower than one pixel from step 6 (Case 1) and step 8 (Case 2) | Frames are 700 px wide; Case 1 x-span 3.25 (≈0.005/px): step 5 width 1.1e-2 (≈2 px), step 6 3.3e-4. Case 2 x-span 1.35 (≈0.0022/px): step 7 1.1e-2 (≈5 px), step 8 6.8e-5. Frames show two lines through step 5 / step 7 and a single line from step 6 / step 8 on | confirmed |
| A6 | Julia source linked under each case | `[Julia source](brentsaa.jl)`, `(brentsbb.jl)` | confirmed |
| C1-1 | Heading: f = 4x³−16x²+17x−4, [0,1] | Script lines 11, 13-14; frame title | confirmed |
| C1-2 | f(0) = −4, f(1) = 1 | Direct | confirmed |
| C1-3 | Root x* ≈ 0.3285 | mpmath 0.328538458611414896 | confirmed |
| C1-4 | 8 steps: secant, bisection, IQI, secant, IQI, secant, secant, IQI | Instrumented run and `indep.py` agree exactly; 9 frames (steps 0-8) | confirmed |
| C1-5 | Step 3 IQI point 0.2276 has larger abs(f), becomes the other end; b stays 0.4 | f(0.22760580197) = −0.912, abs > abs(f(0.4)) = 0.496; state 3 has b=0.4, c=0.2276 | confirmed |
| C1-6 | After step 2 every step is interpolation | Steps 3-8: IQI, Sec, IQI, Sec, Sec, IQI | confirmed |
| C1-7 | Errors in b at steps 5-8: 3.2e-4, 5.5e-6, 2.7e-9, 4.0e-19 | `indep.py` vs mpmath root: 3.24e-4, 5.46e-6, 2.74e-9, 3.98e-19 | confirmed |
| C1-8 | At step 8, b is the double nearest the root and f(b) is exactly 0 | float(mp root) = 0.3285384586114149 = b; Julia and Python f(b) = 0.0 | confirmed |
| C1-9 | Stops because f(b) = 0, bracket still 3.2e-4 wide | Script: fb == 0 break; c = 0.32821473974562487, width 3.237e-4 (see variant note in section 1) | confirmed (for the implemented FMM variant) |
| C1-10 | Bisection needs 32 iterations, regula falsi 24 to get within 1e-10 on [0,1] | `counts.py`: bisection midpoint error first < 1e-10 at n = 32 (and stays below); RF iterate first < 1e-10 at n = 24 | confirmed |
| C1-11 | Other roots ≈1.2647 in [1,2], ≈2.4068 in [2,3], visible in window | mpmath polyroots 1.26465829, 2.40680325; xlims (−0.15, 3.1); frames show all three crossings | confirmed |
| C1-12 | Mathews' example also finds these with Brent's method | Legacy lnk_6 roots (ii), (iii) on [1,2], [2,3] (gr_242, gr_253) | confirmed |
| C1-alt | b converges to 0.3285 in 8 steps; bracket narrows from [0,1] to width 3.2e-4; labels show bisection, secant, IQI | As above | confirmed |
| C2-1 | Heading: f = tan x − 2x, [0.5,1.5] | Script lines 11, 13-14; frame title | confirmed |
| C2-2 | Root ≈1.1656, the smallest positive root of tan x = 2x | mpmath 1.16556118520721; tan x < 2x on (0, x*) since tan x ≈ x near 0 and only one crossing on (0, π/2) | confirmed |
| C2-3 | f(0.5) ≈ −0.454, f(1.5) ≈ 11.1 | −0.4537, 11.1014 | confirmed |
| C2-4 | 10 steps: secant, 2 bisections, secant, IQI, secant, secant, IQI, secant, min step | Instrumented run and `indep.py` agree exactly; 11 frames | confirmed |
| C2-5 | Final bracket width 5e-11 with b ≈ 1.1655611852 at one end, root inside | b = 1.1655611852026313, c = 1.1655611852526317, width 5.000e-11; root − b = 4.58e-12 ∈ (0, 5e-11) | confirmed |
| C2-6 | Bisection at step 3 moves the right end off 1.5 to 1.2598 | State 3 c = 1.2598159432786313 | confirmed |
| C2-7 | Regula falsi needs 165 iterations to within 1e-10 | `counts.py`: first at n = 165 | confirmed |
| C2-8 | f convex, every chord lands left, right endpoint stays 1.5 | f'' = 2 sec²x tan x > 0 on (0, π/2); all 165 RF iterates < root; right endpoint set = {1.5} | confirmed |
| C2-9 | Error eventually shrinks by ≈0.87 per iteration | Ratios 0.8664 near n = 165 | confirmed |
| C2-alt | Bracket narrows from [0.5,1.5] to the root ≈1.1656 in 10 steps; function blows up near the π/2 asymptote | As above; dotted asymptote at π/2 visible in frames | confirmed |

### 3. Implementation checks

### brentsaa.jl (Case 1)
- **Method.** Brent's ZEROIN: IQI when a ≠ c, secant/false-position when a = c, Brent's two-part acceptance test, minimum step tol1, bisection fallback. Line by line it matches the published algorithm, apart from the FMM sign-test form noted in section 1.
- **Numbers.** Script states (Julia) and my independent transliteration (Python) agree to the last digit at every step 0-7, and at step 8 for b:

  | step | method | script b | indep b | script c | indep c |
  |---|---|---|---|---|---|
  | 0 | init | 1 | 1.0 | 0 | 0.0 |
  | 1 | Secant | 0.80000000000000004 | 0.8 | 0 | 0.0 |
  | 2 | Bisection | 0.40000000000000002 | 0.4 | 0 | 0.0 |
  | 3 | IQI | 0.4 | 0.4 | 0.22760580197149965 | same |
  | 4 | Secant | 0.33928781217489301 | 0.339287812174893 | 0.22760580197149965 | same |
  | 5 | IQI | 0.32821473974562487 | 0.3282147397456249 | 0.33928781217489301 | same |
  | 6 | Secant | 0.32854391944914269 | 0.3285439194491427 | 0.32821473974562487 | same |
  | 7 | Secant | 0.32853846134936388 | 0.3285384613493639 | 0.32821473974562487 | same |
  | 8 | IQI | 0.3285384586114149 | 0.3285384586114149 | 0.32821473974562487 | 0.3285384613493639 (sign-test variant, see section 1) |

  Mathews' own Brent output (legacy gr_229) lists the same b sequence p0-p7: 1, 0.8, 0.4, 0.4, 0.3392878121748930, 0.3282147397456249, 0.3285439194491427, 0.3285384613493639. That is a third independent agreement.
- **Reference values.** The page's root 0.3285 is checked against mpmath (50 digits). The script draws no separate "true" root.
- **Picture.** All 9 frames viewed (contact sheet). The bracket is drawn from min/max(b, c), the red dot sits at (b, f(b)), and the legend values and step labels match the printed states. The curve is clamped to ±1 beyond the y-limits, so the clamped parts are off-screen and nothing visible is altered. The x-clamp of b never triggers.

### brentsbb.jl (Case 2)
- **Method.** It is the same routine as Case 1 (the diff shows only parameters and plotting changes).
- **Numbers.** Script and independent run agree at all 11 states. For example: step 4 b = 1.1182930272785787; step 5 1.1766603295259697; step 8 1.1655612050524227; step 9 1.1655611852026313; step 10 c = 1.1655611852526317. Mathews' gr_276 lists the same b sequence p0-p9, then continues further at its tighter tolerance.
- **Reference values.** The root is 1.16556118520721 by mpmath. f is continuous on [0.5, 1.5] because π/2 > 1.5.
- **Picture.** All 11 frames viewed. The curve is NaN-masked within 0.04 of π/2 and clamped just beyond the y-limits, so only off-screen parts are affected. The dot's y-value is clamped, but every b has f(b) in [−0.49, 0.06], so the clamp never triggers. f(1.5) = 11.1 lies above the window, so the right bracket end's function value is off-screen in frames 0-2. This does not affect what the frames claim. The labels and legend match the states.

### Legacy fidelity
Case 1 is Mathews Example 4 root (i), and the page discloses that roots (ii) and (iii) are not animated. Case 2 is Mathews Example 5. Mathews' Examples 1-3 are plain secant and IQI demonstrations, not Brent runs. Mathews' iteration counts (RF ≈36 and 243, bisection ≈50) use his tighter accuracy. The page computes its own counts at 1e-10, and those check out (C1-10, C2-7). I found no fidelity departure.

