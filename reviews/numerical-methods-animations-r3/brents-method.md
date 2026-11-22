# Brent's Method — animation review (round 3)

Page: `pages/numerical-methods/brents-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Implementation (script header comment), Minor
- **Location:** `brentsbb.jl` line 3: `# Non-trivial root ≈ 1.1656. Illustrates fast convergence vs slow Regula Falsi.`
- **Now:** The header says the animation illustrates the comparison with Regula Falsi.
- **True instead:** The GIF draws only the Brent run: no regula falsi iterates and no comparison. The comparison (165 regula falsi iterations) exists only in the page text. The comparison numbers in the page are themselves correct (see ledger C2-9).
- **How I know:** I read the plotting code in lines 108–152. Its only data source is `steps = run_brents(...)`, and nothing computes regula falsi. I also checked all 11 frames in `committed/brentsbb/` (sheet and frame_011): there is no regula falsi element.
- **Correction:** `# Non-trivial root ≈ 1.1656. Shows bracket narrowing with method annotation (the page compares with Regula Falsi).` or simply drop "vs slow Regula Falsi".

No other discrepancies were found. Everything else below was checked and confirmed.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Error: 0. Misleading: 0. Minor: 1.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `brentsaa.jl` | 0 | 6.8 | brentsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

Verdict key: **confirmed** / **wrong** / **could not determine**. Evidence references point to section 3.

### Description (method formulas and algorithm)

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | Requires only f continuous on [a,b], f(a), f(b) of opposite sign; no derivatives | confirmed | Code uses only f values; both cases start with a sign change (C1-1, C2-2) |
| D2 | Maintains a bracket that always contains a root | confirmed | Every recorded step in both runs has f(b)·f(c) ≤ 0 (signs printed in instrumented run); reference roots lie in every printed [b,c] |
| D3 | IQI fits x as a quadratic in y through (a,fa),(b,fb),(c,fc), evaluated at y=0; the Lagrange formula for s shown | confirmed | My implementation uses exactly the page's Lagrange formula and reproduces the script's IQI iterates to all printed digits (case 1 steps 3, 5, 8; case 2 steps 5, 8) |
| D4 | Secant step used when only two distinct points (a = c); s = b − f(b)(b−a)/(f(b)−f(a)) | confirmed | My implementation uses this formula exactly when a == c and reproduces all script Secant steps (case 1 steps 1, 4, 6, 7; case 2 steps 1, 4, 6, 7, 9). Script's p/q form: raw p/q = (a−b)fb/(fa−fb); the sign normalisation makes d = −raw p/q, giving the page's formula |
| D5 | Bisection is the safeguard; guarantees the bracket shrinks by at least half | confirmed | A bisection step sets the new point at the midpoint of [b,c]; case 2 steps 2 and 3 halve the width exactly: 0.9607→0.4804→0.2402 |
| D6 | State: f(b)·f(c) ≤ 0, \|f(b)\| ≤ \|f(c)\|; b best approximation; a = previous b or coincides with c | confirmed | Script lines 41–50 enforce this; matches Brent (1973) ZEROIN and Mathews' own statement |
| D7 | IQI accepted only if s is inside the bracket and progress is adequate, else bisection | confirmed | Script line 81: 2p < 3·xm·q − \|tol1·q\| (s within ~3/4 of the way from b to c, so inside the bracket) and p < \|e·q/2\| |
| D8 | Safeguards: bisect when the interpolated step would not stay within about 3/4 of the way from b to c, or is not smaller than half the step before last | confirmed | Same line 81; `e` holds the previous `d` (lines 82–83), i.e. the step before last |
| D9 | x^9 on [−1, 2]: Brent needs 96 function evaluations to shrink the bracket below 1e−10; bisection needs 37 | confirmed | Script's own routine (`x9.jl`): 94 steps, 96 evaluations, width first < 1e−10 at step 94 (final 5.0e−11). My independent implementation: 96. Bisection: width 3/2^n < 1e−10 first at n = 35 iterations, + 2 endpoint evaluations = 37 |
| D10 | IQI order ≈ 1.839, the positive real root of t^3 = t^2 + t + 1 | confirmed | numpy roots of t^3−t^2−t−1: 1.83928676; standard IQI order |
| D11 | Brent cannot fail to converge for a valid bracket and continuous f | confirmed | Standard result (bisection fallback and the \|e\|/2 test bound the work); consistent with all runs |
| D12 | Table: bisection order 1; regula falsi linear, guaranteed; secant ≈1.618 not guaranteed; IQI ≈1.839; Brent up to ≈1.839, guaranteed, no derivatives | confirmed | Standard values; the case 2 regula falsi run shows linear contraction (0.866) |

### Animations introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Shaded region = current bracket between b and c | confirmed | Plot code lines 118, 133–137 shade [min(b,c), max(b,c)] from the recorded state |
| A2 | Red dot = b, the endpoint with the smaller \|f\| | confirmed | Line 140 uses `st.b`; lines 47–50 make b the smaller-\|f\| end; the dot is drawn at (b, f(b)); no clamping takes effect (case 1 b ∈ [0,1] ⊂ xlims; case 2 \|f(b)\| ≤ 0.48 ⊂ ylims) |
| A3 | Step annotation shows Bisection, Secant or IQI selected at that iteration | confirmed | `method` is set to the accepted candidate or "Bisection" (lines 59, 84); annotation reads `Step $(i-1): $meth`; frames show these labels |
| A4 | "Min step" marks a step shorter than the tolerance (≈5e−11), replaced by a step of that length | confirmed | Lines 95–99; tol1 = 2·eps·1.1656 + 5e−11 = 5.00005e−11; case 2 step 10 moves b by exactly this (final width 5.000e−11) |
| A5 | Sources linked under each case | confirmed | `[Julia source](brentsaa.jl)` and `(brentsbb.jl)` exist; manifest: regenerated GIFs byte-identical to committed |

### Case 1 — f(x) = 4x³ − 16x² + 17x − 4, [0, 1]

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1-0 | Heading: function and [a0,b0] = [0,1] | confirmed | Script lines 10, 12–13; GIF title shows the same function |
| C1-1 | f(0) = −4 < 0, f(1) = 1 > 0 | confirmed | Direct evaluation |
| C1-2 | True root x* ≈ 0.3285 | confirmed | mpmath: 0.3285384586114148959725705 |
| C1-3 | 8 steps: secant, bisection, IQI, secant, IQI, secant, secant, IQI | confirmed | Script and independent run both: Secant, Bisection, IQI, Secant, IQI, Secant, Secant, IQI; scipy brentq evaluates the same points (0.8, 0.4, 0.2276…, 0.3393…, 0.32821…, 0.328544…, 0.3285385…, 0.32853846) |
| C1-4 | Step 3: IQI point 0.2276 has the larger \|f\|, becomes the other end; b stays at 0.4 | confirmed | IQI point 0.22760580197149965, f = −0.9124; f(0.4) = 0.496; recorded step 3: b = 0.4, c = 0.2276058 |
| C1-5 | After the step-2 bisection every step is interpolation | confirmed | Steps 3–8 are IQI/Secant |
| C1-6 | Errors in b at steps 5–8: 3.2e−4, 5.5e−6, 2.7e−9, 4.0e−19 | confirmed | Independent: 3.237e−4, 5.461e−6, 2.738e−9, 3.983e−19 |
| C1-7 | At step 8 b is the double nearest the root and f(b) is exactly 0 | confirmed | b = 0.3285384586114149 = float(mpmath root); error 4.0e−19 < half-ulp (2.8e−17); f(b) evaluates to 0.0 in both Julia and Python |
| C1-8 | To get within 1e−10 of the root, bisection needs 32 iterations, regula falsi 24 | confirmed | `counts.py`: bisection midpoint first within 1e−10 at iteration 32; regula falsi iterate within 1e−10 at iteration 24 |
| C1-9 | Other roots x ≈ 1.2647 in [1,2] and x ≈ 2.4068 in [2,3]; visible in the window | confirmed | mpmath polyroots: 1.26465829, 2.406803251; xlims (−0.15, 3.1); both crossings visible in every frame |
| C1-10 | Mathews' example also finds these with Brent's method; only [0,1] is animated | confirmed | Archive lnk_6 Root (ii) on [1,2] → 1.26465829006442 (gr_242), Root (iii) on [2,3] → 2.406803251324166 (gr_253) |
| C1-11 | Alt text: bracket narrows from [0,1] to the root at x≈0.3285 in 8 steps, labels show bisection, secant, IQI | confirmed | 9 frames (Step 0–8); final bracket [0.328215, 0.328538] contains the root with b at the root |

### Case 2 — f(x) = tan(x) − 2x, [0.5, 1.5]

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2-0 | Heading: function and [a0,b0] = [0.5,1.5] | confirmed | Script lines 10, 12–13; GIF title |
| C2-1 | Non-trivial root x* ≈ 1.1656 | confirmed | mpmath: 1.165561185207211306833918 |
| C2-2 | f(0.5) ≈ −0.454, f(1.5) ≈ 11.1 | confirmed | −0.45370, 11.10142 |
| C2-3 | 10 steps: secant, two bisections, secant, IQI, secant, secant, IQI, secant, final minimum step | confirmed | Script and independent run identical; scipy evaluates the same 10 points |
| C2-4 | Final bracket width 5e−11 with b ≈ 1.1655611852 at one end; root inside | confirmed | b = 1.1655611852026313, c = 1.1655611852526317, width 5.000e−11; root 1.16556118520721 lies between them |
| C2-5 | Step-3 bisection moves the right end off 1.5 to 1.2598 | confirmed | Step 3: c = 1.2598159432786313 (steps 0–2 have c = 1.5) |
| C2-6 | Regula falsi needs 165 iterations to get within 1e−10 | confirmed | `counts.py`: 165 |
| C2-7 | f convex here, every chord lands left of the root, right endpoint stays at 1.5 | confirmed | f'' = 2 sec²x tan x > 0 on (0, π/2); all 165 regula falsi iterates < root; set of right endpoints = {1.5} |
| C2-8 | Error eventually shrinks by a factor ≈ 0.87 per iteration | confirmed | Observed ratio 0.86642; theory 1 − f'(r)(1.5−r)/f(1.5) = 1 − 4.434·0.3344/11.10 = 0.866 |
| C2-9 | Alt text: bracket narrows from [0.5,1.5] to root ≈1.1656 in 10 steps despite blow-up near the π/2 asymptote | confirmed | 11 frames (Step 0–10); asymptote drawn as a dotted line at π/2, curve masked within 0.04 of it, no artefacts in the frames |

### Fidelity to the legacy archive

| # | Item | Verdict | Evidence |
|---|---|---|---|
| L1 | Case 1 = Mathews Example 4 (same cubic, [0,1]) | confirmed | gr_219 `f[x] = 4x^3 − 16x^2 + 17x − 4`; Mathews' iterates p1–p8 (gr_229) equal the script's step 1–8 b values (0.8, 0.4, 0.4, 0.339287812…, 0.328214739…, 0.328543919…, 0.328538461…, 0.328538458611…) |
| L2 | Case 2 = Mathews Example 5 (tan x = 2x on [0.5, 1.5]) | confirmed | gr_264/265/267; Mathews' p1–p9 (gr_276) equal the script's b values for steps 1–9. Mathews used a tighter tolerance and continues one more step to 1.165561185207211; the page uses tol = 1e−10 and ends with a min step. This is a disclosed parameter choice that the page's own numbers describe correctly, so it is not a finding |
| L3 | Example 4 roots (ii), (iii) not animated | confirmed, disclosed | The page says so explicitly and gives the roots; not silent |
| L4 | Archive Examples 1–3 (secant method alone, IQI alone) not on the page | not a finding | They illustrate the constituent methods, not Brent's method; the page's Animations are the two Brent examples |

### 3. Implementation checks

Both scripts share the same `run_brents` routine (diff shows only parameters, plot limits, title, and tan-asymptote masking differ).

### `brentsaa.jl`

1. **It is the method claimed.** `run_brents` is Brent's ZEROIN (Brent 1973; Forsythe–Malcolm–Moler `zeroin`), restructured into a loop: sign-reset of c (`c=a, d=e=b−a`), swap so \|f(b)\| ≤ \|f(c)\|, `tol1 = 2·eps·|b| + tol/2`, `xm = (c−b)/2`, bisection unless \|e\| ≥ tol1 and \|fa\| > \|fb\|, secant if a == c else IQI in Brent's p/q form, sign normalisation, acceptance test `2p < 3·xm·q − |tol1·q|` and `p < |e·q/2|`, minimum step `copysign(tol1, xm)`. The variant is the standard ZEROIN, which the page describes.
2. **The numbers are right.** Script vs independent (explicit Lagrange IQI, explicit secant formula, geometric acceptance test) vs scipy brentq evaluation points:

| step | method | script b | independent b | scipy evaluation |
|---|---|---|---|---|
| 0 | init | 1 | 1 | 0, 1 |
| 1 | Secant | 0.80000000000000004 | 0.80000000000000004 | 0.8 |
| 2 | Bisection | 0.40000000000000002 | 0.40000000000000002 | 0.4 |
| 3 | IQI (→c) | 0.4 (c = 0.22760580197149965) | 0.4 (c = 0.2276058019714996) | 0.227605801971 |
| 4 | Secant | 0.33928781217489301 | same | 0.339287812175 |
| 5 | IQI | 0.32821473974562487 | same | 0.328214739746 |
| 6 | Secant | 0.32854391944914269 | same | 0.328543919449 |
| 7 | Secant | 0.32853846134936388 | same | 0.328538461349 |
| 8 | IQI | 0.3285384586114149 (f = 0) | same | 0.328538458611 |

   Total 10 function evaluations in all three. Stop reason: f(b) == 0 at step 8.
3. **Reference values.** The page's x* ≈ 0.3285 and the other roots 1.2647, 2.4068 agree with mpmath to the digits stated. The script has no separate reference curve; the backdrop is f itself.
4. **The picture shows what was computed.** All 9 committed frames checked (contact sheet; frames 1, 4, 6, 9 at full size). The bracket shading and dashed lines are at [min(b,c), max(b,c)] of each recorded state. The red dot is at (b, f(b)). The legend shows `b = round(b, 6)`, matching the printed values (1.0, 0.8, 0.4, 0.4, 0.339288, 0.328215, 0.328544, 0.328538, 0.328538). The step labels match the computed methods. The title function matches line 10. The backdrop clamp (ylims ±1) only affects the off-screen parts of the cubic. The b clamp to xlims never triggers. Committed and regenerated GIFs are byte-identical (manifest).

### `brentsbb.jl`

1. **Method:** identical routine to `brentsaa.jl` (standard ZEROIN).
2. **Numbers:** script vs independent (identical to all 17 digits) vs scipy:

| step | method | b | c | scipy evaluation |
|---|---|---|---|---|
| 0 | init | 0.5 | 1.5 | 0.5, 1.5 |
| 1 | Secant | 0.53926377311452489 | 1.5 | 0.539263773115 |
| 2 | Bisection | 1.0196318865572624 | 1.5 | 1.01963188656 |
| 3 | Bisection | 1.0196318865572624 | 1.2598159432786313 | 1.25981594328 |
| 4 | Secant | 1.1182930272785787 | 1.2598159432786313 | 1.11829302728 |
| 5 | IQI | 1.1766603295259697 | 1.1182930272785787 | 1.17666032953 |
| 6 | Secant | 1.1637285834543314 | 1.1766603295259697 | 1.16372858345 |
| 7 | Secant | 1.1654929603348207 | 1.1766603295259697 | 1.16549296033 |
| 8 | IQI | 1.1655612050524227 | 1.1654929603348207 | 1.16556120505 |
| 9 | Secant | 1.1655611852026313 | 1.1655612050524227 | 1.1655611852 |
| 10 | Min step | 1.1655611852026313 | 1.1655611852526317 | 1.16556118525 |

   Total 12 function evaluations in all three. The error in b at the end is 4.58e−12. Stop reason: \|xm\| ≤ tol1.
3. **Reference values:** root 1.1656 agrees with mpmath (1.16556118520721…).
4. **Picture:** all 11 frames checked (contact sheet; frame 11 at full size). The bracket, dot, legend values (0.5, 0.539264, 1.019632, 1.019632, 1.118293, 1.17666, 1.163729, 1.165493, 1.165561 ×3) and labels match the computed run. The f(b) clamp to ylims never triggers (\|f(b)\| ≤ 0.48). The curve is masked within 0.04 of π/2 and clamped to ylims ±0.5. Beyond π/2+0.04 the clamped values (≈ −2.3) lie below the window, so nothing misleading is drawn. A dotted line marks the asymptote at π/2. The root and the whole iteration lie well inside the window. Committed and regenerated GIFs are byte-identical.
5. Header comment line 3: see F1.

### Not findings (noted for completeness)
- `method_labels` in `brentsaa.jl` line 113 is unused (code style).
- When a step is shorter than tol1, the "Min step" label replaces the sub-method that was selected. The page's introduction explains the label, so this is not misleading.

