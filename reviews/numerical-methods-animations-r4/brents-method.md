# Brent's Method — animation review (round 4)

Page: `pages/numerical-methods/brents-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Page match, Minor: "The non-trivial root of tan(x) = 2x" implies there is only one

- **Location:** `index.qmd` line 74: "The non-trivial root of $\tan(x) = 2x$ lies at $x^* \approx 1.1656$." The same wording is in `brentsbb.jl` line 3: "Non-trivial root ≈ 1.1656."
- **What is there now:** the sentence reads as though tan x = 2x has only the trivial root 0 and the root 1.1656.
- **What is true:** tan x = 2x has infinitely many non-trivial roots: one in each branch of tan, symmetric about 0. Examples are −1.165561185, 4.604216777 and 7.789883751 (mpmath `findroot` from 50-digit starts −1.16, 4.6 and 7.79). 1.1655611852 is the smallest positive root and the only root in [0.5, 1.5].
- **How I know:** `/usr/bin/python3 -I -c "import mpmath as mp; f=lambda x: mp.tan(x)-2*x; print([mp.nstr(mp.findroot(f,x0),10) for x0 in (-1.16,4.6,7.79)])"` printed `['-1.165561185', '4.604216777', '7.789883751']`.
- **Correction:** "The root of $\tan(x) = 2x$ in $[0.5, 1.5]$ (its smallest positive root) lies at $x^* \approx 1.1656$." Make the same change in the `brentsbb.jl` header comment.

- **Independent check:** not run (Minor finding, unverified)

### F2. Implementation (picture), Minor: the last steps of each animation cannot be told apart, so the fast convergence the page describes does not show

- **Location:** `brentsaa.jl` lines 17–18 and 142–143, and `brentsbb.jl` lines 17–18 and 146–147: fixed whole-function windows, and a legend label `b = $(round(b_best; digits=6))`. The frames affected are `brentsaa.gif` frames 6–9 (steps 5–8) and `brentsbb.gif` frames 9–11 (steps 8–10).
- **What is there now:** the window is 3.25 units wide in Case 1 and 1.35 units wide in Case 2, on a plot area about 640 px across. From Case 1 step 6 (bracket width 3.3e-4, about 0.07 px) and Case 2 step 8 (width 6.8e-5, about 0.03 px), the shaded bracket is one dashed line and the red dot does not move. The only label that changes is the 6-decimal `b = …` legend, and it stops changing too: Case 1 frames 8 and 9 both read `b = 0.328538`, and Case 2 frames 9, 10 and 11 all read `b = 1.165561`. So Case 2 steps 8 (IQI), 9 (Secant) and 10 (Min step) differ only in the step label, and so do Case 1 steps 7 (Secant) and 8 (IQI). The page's Behavior text sets out exactly this stretch: errors of 3.2e-4, 5.5e-6, 2.7e-9 and 4.0e-19 at steps 5–8, and the final minimum step. The animation gives the viewer no sign of any of it.
- **How I know:** the per-frame widths and b values come from `review/instr.out` (Case 1 widths 1.0, 0.8, 0.4, 0.172, 0.112, 0.0111, 3.29e-4, 3.24e-4, 3.24e-4; Case 2 widths 1.0, 0.961, 0.480, 0.240, 0.142, 0.0584, 0.0129, 0.0112, 6.8e-5, 1.98e-8, 5.0e-11). I also looked at the contact sheets `committed/brentsaa/sheet.png` and `committed/brentsbb/sheet.png`, and at `committed/brentsbb/frame_011.png` at full size.
- **Correction (any one of these):** print more digits of b, or |c − b|, or f(b) in the legend or annotation (for example `b = 1.1655611852, |c−b| = 5.0e-11`). Or add a zoomed inset, or a second panel showing log10|c − b| against the step number, so that the superlinear collapse can be seen.

No Error or Misleading findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


Error: 0. Misleading: 0. Minor: 2.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `brentsaa.jl` | 0 | 7.6 | brentsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `brentsbb.jl` | 0 | 7.6 | brentsbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page text (location) | Evidence | Verdict |
|---|---|---|---|
| D1 | "requires only that f be continuous on [a,b] with f(a) and f(b) of opposite sign — no derivatives are needed" (l.12) | the code uses only f values | confirmed |
| D2 | IQI "fits x as a quadratic function of y through (a,f(a)), (b,f(b)), (c,f(c)) … evaluates it at y=0" (l.16) | the page's Lagrange formula applied to the script's (a,b,c) reproduces the script's IQI points to the last bit (see I-2) | confirmed |
| D3 | Secant "(regula falsi) — uses the chord through (a,f(a)) and (b,f(b)) … when … a = c" (l.17) | code l.62–66 runs the secant when a == c. In that case a = c and b bracket the root, so the step is a false-position chord. The values are checked in I-2 | confirmed |
| D4 | Bisection "used as a safeguard … guarantees the bracket shrinks by at least half" (l.18) | a bisection sets b ← b + (c−b)/2, which halves [b, c] exactly | confirmed |
| D5 | State: f(b)·f(c) ≤ 0, \|f(b)\| ≤ \|f(c)\|; a is the previous b or coincides with c (l.24–26) | code l.42–50 enforces both conditions before every step; a ← b at l.94, and the swap at l.48 sets c = a | confirmed |
| D6 | IQI formula s = … (l.32) | evaluated independently in `indep.py` on the script's iterates: Case 1 step 3 gives 0.2276058019714996, step 5 gives 0.3282147397456249, step 8 gives 0.3285384586114149; Case 2 step 5 gives 1.1766603295259697, step 8 gives 1.1655612050524227. All equal the script's points | confirmed |
| D7 | IQI "accepted only if s falls inside the current bracket and … adequate progress" (l.34) | the acceptance test (l.81) needs p/q < ¾(c−b) − ½tol1, which implies the point is inside the bracket, and needs \|p/q\| < \|e\|/2. The sentence is a necessary condition stated loosely; D9 states it precisely | confirmed |
| D8 | Secant formula s = b − f(b)(b−a)/(f(b)−f(a)) (l.40) | the algebra of code l.64–65 with the sign adjustment gives d = −f_b(b−a)/(f_b−f_a). Numerically equal to the script's secant points (I-2) | confirmed |
| D9 | Safeguards: bisect if the interpolated step would not stay within about ¾ of the way from b to c, or is not smaller than half the step before last (l.44) | l.81: `2p < 3*xm*q - |tol1*q|` (xm = (c−b)/2, so the limit is ¾(c−b)) and `p < |e*q/2|`, where e holds the step before last (e ← d before d ← p/q) | confirmed |
| D10 | x^9 on [−1,2]: Brent needs 96 function evaluations to shrink the bracket below 1e-10; bisection needs 37 (l.44) | `x9.jl`: 96 evaluations, final width 5.0e-11 (it stops the first time the width is ≤ 1e-10). `scipy.brentq(xtol=1e-10, rtol=4eps)`: 96 calls. Bisection: 3/2^35 = 8.7e-11 < 1e-10 and 3/2^34 = 1.7e-10, so 35 midpoints + 2 endpoints = 37 | confirmed |
| D11 | IQI order ≈ 1.839, the positive real root of t³ = t² + t + 1 (l.45, table) | `np.roots([1,-1,-1,-1])` gives 1.83928676 | confirmed |
| D12 | Robustness: cannot fail to converge given a valid bracket and continuous f (l.46) | standard property of zeroin; the bracket is kept at every step (D5) | confirmed |
| D13 | Table: bisection order 1; regula falsi linear; secant ≈1.618; IQI ≈1.839; Brent up to ≈1.839; no derivatives (l.50–56) | standard values. The golden ratio is 1.618 | confirmed |
| A1 | "The shaded region marks the current bracket between b and c" (l.60) | the code shades [min(b,c), max(b,c)] (l.118, 134–136). Frames agree | confirmed |
| A2 | "The red dot tracks b, the best current approximation (the endpoint with the smallest \|f\| value)" (l.60) | the dot is at `st.b`, recorded after the swap at l.47–50 | confirmed |
| A3 | "The step annotation indicates which sub-method — Bisection, Secant, or IQI — was selected at that iteration" (l.60) | the annotation is `st.method`, set at l.59/84/99 for the step that produced the new point. Frames show "Step k: …" | confirmed |
| A4 | "Min step" marks a step shorter than the tolerance (≈5e-11), replaced by a step of that length (l.60) | l.95–99, with tol1 = 2·eps·\|b\| + 5e-11 ≈ 5.00000052e-11 | confirmed |
| A5 | Julia sources linked under each case (l.62) | l.68 and l.76 link the files | confirmed |
| C1-1 | Heading: f(x) = 4x³ − 16x² + 17x − 4, [a0,b0] = [0,1] (l.64) | `brentsaa.jl` l.10, 12–13; GIF title matches | confirmed |
| C1-2 | f(0) = −4 < 0, f(1) = 1 > 0 | direct evaluation | confirmed |
| C1-3 | True root x* ≈ 0.3285 | mpmath: 0.328538458611415 | confirmed |
| C1-4 | 8 steps: secant, bisection, IQI, secant, IQI, secant, secant, IQI | `instr.out`: Secant, Bisection, IQI, Secant, IQI, Secant, Secant, IQI; 9 frames (steps 0–8); stops because f(b) == 0 | confirmed |
| C1-5 | At step 3 the IQI point 0.2276 has the larger \|f\|, becomes the other end, b stays at 0.4 | IQI point 0.22760580197; f = −0.9124 against f(0.4) = 0.496; frame 4 shows c = 0.2276 and b = 0.4 | confirmed |
| C1-6 | After the bisection at step 2 every step is an interpolation step | steps 3–8 are IQI or Secant | confirmed |
| C1-7 | Errors at steps 5–8: 3.2e-4, 5.5e-6, 2.7e-9, 4.0e-19 | mpmath \|b − r\|: 3.237e-4, 5.461e-6, 2.738e-9, 3.983e-19 | confirmed |
| C1-8 | At step 8 b is the double nearest the root, and f(b) evaluates to exactly 0 | the neighbouring doubles have errors 5.51e-17 and 5.59e-17, against 3.98e-19 for b; f(b8) = 0.0 in Float64 (Julia and Python) | confirmed |
| C1-9 | To get within 1e-10 on [0,1], bisection needs 32 iterations and regula falsi 24 | `indep2.py`: the first midpoint within 1e-10 is the 32nd; the first regula falsi iterate within 1e-10 is the 24th | confirmed |
| C1-10 | Other roots x ≈ 1.2647 in [1,2] and x ≈ 2.4068 in [2,3], shown in the window | mpmath: 1.26465829006, 2.40680325132; both crossings are visible in the frames (x window −0.15 to 3.1) | confirmed |
| C1-11 | Mathews' example also finds these with Brent's method; only [0,1] is animated | archive lnk_6 Root (ii) on [1,2] and Root (iii) on [2,3] (gr_242, gr_253) | confirmed |
| C1-12 | Alt text: bracket narrows from [0,1] to the root at x ≈ 0.3285 in 8 steps, labels show bisection, secant and IQI | frames | confirmed |
| C2-1 | Heading: f(x) = tan(x) − 2x, [a0,b0] = [0.5,1.5] (l.72) | `brentsbb.jl` l.10, 12–13; GIF title matches | confirmed |
| C2-2 | "The non-trivial root of tan(x) = 2x lies at x* ≈ 1.1656" | the value is right (1.1655611852072113); "the" non-trivial root is wrong, since there are infinitely many (F1) | wrong (Minor, F1) |
| C2-3 | f(0.5) = tan(0.5) − 1 ≈ −0.454; f(1.5) = tan(1.5) − 3 ≈ 11.1 | −0.45369751, 11.10141995 | confirmed |
| C2-4 | 10 steps: secant, two bisections, then secant, IQI, secant, secant, IQI, secant, final minimum step | `instr.out`: Secant, Bisection, Bisection, Secant, IQI, Secant, Secant, IQI, Secant, Min step; 11 frames | confirmed |
| C2-5 | Leaves the root inside a bracket of width 5e-11, with b ≈ 1.1655611852 at one end | final b = 1.1655611852026313 and c = 1.1655611852526317; width 5.00004e-11; root − b = 4.58e-12, so the root is inside | confirmed |
| C2-6 | The bisection at step 3 moves the right end off x = 1.5 to 1.2598 | step 3 gives c = 1.2598159432786313 (previously 1.5) | confirmed |
| C2-7 | Regula falsi needs 165 iterations to get within 1e-10 on [0.5,1.5] | `indep2.py`: 165 | confirmed |
| C2-8 | f is convex here, so every chord lands left of the root and the right endpoint stays at 1.5 | f″ = 2sec²x·tan x > 0 on (0, π/2); the regula falsi run ends with bracket (1.16556118511, 1.5), so the right end never moved | confirmed |
| C2-9 | The error eventually shrinks by a factor of about 0.87 per iteration | the last ratios are 0.86642; theory 1 − f′(r)(1.5 − r)/f(1.5) = 0.86642 | confirmed |
| C2-10 | Alt text: narrows from [0.5,1.5] to the root at x ≈ 1.1656, converging in 10 steps despite the function blowing up near the π/2 asymptote | 10 steps; the asymptote is drawn dotted at π/2 and f is masked within 0.04 of it | confirmed |
| W1 | Case 1 link and embed are `brentsaa.jl` / `brentsaa.gif`; Case 2 link and embed are `brentsbb.jl` / `brentsbb.gif` | each script writes its own GIF; the scratch regeneration is byte-identical | confirmed |
| V1 | Animation shows the bracket narrowing (intro and alt texts) | it does for the early steps; the last 3–4 steps cannot be told apart (F2) | confirmed, with a Minor readability issue (F2) |

---

### 3. Implementation checks

Both scripts share an identical `run_brents` (lines 27–104 in `brentsaa.jl`, the same lines in `brentsbb.jl`).

### I-1. Is it the method it claims to be?
Yes. It is Brent's ZEROIN as published (Brent 1973; netlib `zeroin.f`), transcribed line for line:
- The start sets c = a, d = e = b − a.
- The bracket test `fb*(fc/|fc|) > 0` resets c = a and d = e = b − a.
- The swap makes |f(b)| ≤ |f(c)|.
- The tolerance is tol1 = 2·eps·|b| + tol/2, with xm = (c − b)/2.
- The loop stops when |xm| ≤ tol1 or fb == 0.
- It bisects when |e| < tol1 or |fa| ≤ |fb|.
- It takes the linear step when a == c and inverse quadratic interpolation otherwise, using Brent's p/q form.
- Sign adjustment and acceptance: 2p < 3·xm·q − |tol1·q| and p < |e·q/2|.
- The minimum step is sign(xm)·tol1.

The extra `it == n_iters` break is a frame cap, and it is never reached: the two runs stop after 8 and 10 steps, against caps of 14 and 16. The Description (ZEROIN with the a/b/c roles, IQI, a secant step when a = c, the ¾ and half-step-before-last tests) describes this same variant.

Independent cross-check: SciPy's `brentq` is a separate C implementation of Brent's algorithm. Run with xtol = 1e-10 and rtol = 4·eps, which makes its δ equal to the script's tol1, its function-evaluation sequence is identical to the script's in both cases, to every bit:
- Case 1: 0, 1, 0.8, 0.4, 0.22760580197149965, 0.339287812174893, 0.3282147397456249, 0.3285439194491427, 0.3285384613493639, 0.3285384586114149 (10 calls).
- Case 2: 0.5, 1.5, 0.5392637731145249, 1.0196318865572624, 1.2598159432786313, 1.1182930272785787, 1.1766603295259697, 1.1637285834543314, 1.1654929603348207, 1.1655612050524227, 1.1655611852026313, 1.1655611852526317 (12 calls).

The legacy Mathews worked solutions agree as well:
- Example 4 (gr_229): p0..p8 = 1, 0.8, 0.4, 0.4, 0.3392878121748930, 0.3282147397456249, 0.3285439194491427, 0.3285384613493639, 0.3285384586114148. These are the script's b values, frames 0–8.
- Example 5 (gr_276): p0..p9 = 0.5, 0.53926377311452, 1.01963188655726, 1.01963188655726, 1.11829302727858, 1.17666032952597, 1.16372858345433, 1.16549296033482, 1.16556120505242, 1.16556118520263. These are the script's b values, frames 0–9. Mathews used a tighter tolerance and so took one more step to 1.165561185207211, where the script makes its min step instead.

### I-2. Are the numbers right?
Script values (from `instr.out`) against independent values (from `indep.py` / `indep2.py`):

| Case/step | Script point | Independent (page formula applied to the script's a, b, c) |
|---|---|---|
| 1 / 1 Secant (a=c=0, b=1) | 0.8 | 0.8 |
| 1 / 2 IQI attempt (a=1, b=0.8, c=0) | rejected, so bisection to 0.4 | IQI gives 1.3105, outside [0, 0.8], so rejection is correct; the midpoint is 0.4 |
| 1 / 3 IQI | 0.22760580197149965 | 0.2276058019714996 |
| 1 / 4 Secant | 0.339287812174893 | 0.339287812174893 |
| 1 / 5 IQI | 0.3282147397456249 | 0.3282147397456249 |
| 1 / 6 Secant | 0.3285439194491427 | 0.3285439194491427 |
| 1 / 7 Secant | 0.3285384613493639 | 0.3285384613493639 |
| 1 / 8 IQI | 0.3285384586114149 | 0.3285384586114149 |
| 2 / 1 Secant | 0.5392637731145249 | 0.5392637731145249 |
| 2 / 4 Secant | 1.1182930272785787 | 1.1182930272785787 |
| 2 / 5 IQI | 1.1766603295259697 | 1.1766603295259697 |
| 2 / 6 Secant | 1.1637285834543314 | 1.1637285834543314 |
| 2 / 7 Secant | 1.1654929603348207 | 1.1654929603348207 |
| 2 / 8 IQI | 1.1655612050524227 | 1.1655612050524227 |
| 2 / 9 Secant | 1.1655611852026313 | 1.1655611852026313 |
| 2 / 10 Min step | 1.1655611852526317 = b + 5.00004e-11 | tol1 = 5e-11 + 2·eps·1.1656 = 5.0000005e-11; sign(xm) > 0 |

Bisection steps: Case 2 step 2 gives 1.0196318865572624 = (0.5392637731145249 + 1.5)/2, and step 3 gives 1.2598159432786313 = (1.0196318865572624 + 1.5)/2. Both are midpoints.

Convergence near the root (Case 1): |b − r| = 3.24e-4, 5.46e-6, 2.74e-9, 3.98e-19 at steps 5–8. This is the superlinear collapse expected near a simple root.

### I-3. Are the reference values right?
The scripts draw no reference curve. The only reference values are in the comments (brentsaa "Root ≈ 0.3285"; brentsbb "Non-trivial root ≈ 1.1656") and in the page text. Checked with mpmath at 50 digits:
- cubic roots: 0.328538458611415, 1.26465829006442, 2.40680325132417 (agree with `numpy.roots`)
- tan x = 2x: 1.1655611852072113068

All of the quoted figures are right. The wording "non-trivial root" is F1.

### I-4. Does the picture show what was computed?
I looked at all frames on both contact sheets, and at `brentsaa` frame 4 and `brentsbb` frame 11 at full size.
- **Curve:** magenta f(x) is computed from the same `f`. The clamping (to ylims ± 1, and ± 0.5 in Case 2) only cuts off parts of the curve outside the window. Case 2 masks the curve within 0.04 of π/2 and draws a dotted vertical line at π/2. Neither device affects the region near the root.
- **Shaded bracket and dashed lines:** they sit at min/max(b, c) for each recorded step, which agrees with `instr.out`. Examples: Case 1 frame 4 spans [0.2276, 0.4]; Case 2 frame 4 spans [1.0196, 1.2598].
- **Red dot:** it is at (b, f(b)). The clamps (`clamp(b_best, xlims…)` in aa and `clamp(f(b), ylims…)` in bb) never take effect: every b lies inside the x-window, and every f(b) lies in [−0.48, 1.41], inside the y-window.
- **Legend:** `b = round(b, 6)` matches the b values.
- **Step label:** "Step k: method" agrees with the computed sequence. Frame 1 reads "Start".
- **Titles:** they name the same functions as the code, and the Case 2 title also gives the interval.
- **Frame counts:** 9 and 11, which are steps 0–8 and 0–10, as the page says.
- **Readability:** the only issue is the one in F2. The final steps cannot be told apart at the full-function scale, and the 6-decimal legend stops changing.

### Archive fidelity
- Mathews' Brent examples are Example 4 (the cubic 4x³ − 16x² + 17x − 4, roots on [0,1], [1,2] and [2,3]) and Example 5 (tan x − 2x on [0.5,1.5]). The page animates Example 4 root (i) and Example 5 with the same functions and intervals.
- The script's iterates reproduce Mathews' tables exactly up to the script's coarser stopping tolerance.
- The page says openly that Example 4's roots (ii) and (iii) are not animated.
- Examples 1–3 (secant alone, IQI alone, and a double-root comparison) are examples of the constituent methods, not of Brent's method, so I do not treat their absence as a fidelity finding.
- Mathews quotes regula falsi and bisection iteration counts (36/50 for Example 4, 243/50 for Example 5) at his own, tighter accuracy. The page restates the comparison at 1e-10 and its counts are right at that tolerance (C1-9, C2-7). This is a valid recomputation, not a departure.
- No fidelity findings.

### Could not determine
Nothing material. The ¾ and half-step tests are quoted from the code, not from Brent's paper. The SciPy and Mathews sequences agree with the code bit for bit, so these tests are the standard ones.

