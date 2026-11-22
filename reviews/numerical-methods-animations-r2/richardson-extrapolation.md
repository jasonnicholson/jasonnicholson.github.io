# Richardson Extrapolation — animation review (round 2)

Page: `pages/numerical-methods/richardson-extrapolation/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1: Fidelity, Minor. The legacy module's animated scenarios (Examples 8 to 10) are not represented, and the page does not say so
- **Location:** `index.qmd` lines 28–46 (the whole Animations section). Its introduction says "Each animation below compares the base central difference with Richardson extrapolation for the legacy test function and interval."
- **What is there now:** two cases. The first is a profile of D3 and D5 against f′ on [0, π] (this corresponds to legacy Examples 2(b) and 3). The second is a log-log error plot at x0 = 1 (this corresponds to legacy Example 4, which studies O(h^n) behaviour).
- **What the archive has:** the module's section "Various Scenarios and Animations for Richardson's Extrapolation and higher derivatives" contains Examples 8, 9 and 10. Each is a frame sequence for f(x) = e^{−x} sin x at X = 1.0 with H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}. Each frame shows the five stencil points X ± H and X ± 2H and the local polynomial built from the five-point estimate:
  - Example 8: tangent line with slope d1 = five-point f′ (gr_174 code, gr_175 to gr_190 frames).
  - Example 9: osculating parabola from the five-point f″ (gr_195 code, gr_196 to gr_211).
  - Example 10: cubic from the five-point f‴ (gr_216 code, gr_217 to gr_233).
  
  These are the only animations in the legacy module. The page's Case 2 reuses X = 1 and a similar list of h values, but as an error plot. The stencil-and-tangent geometry is absent, and so are the f″ and f‴ scenarios. Nothing on the page says they were left out.
- **How I know:** `sed 's/<[^>]*>//g' RichardsonExtrapMod.html` gives the section heading and Examples 8 to 10. `grep 'HEIGHT='` on `RichardsonExtrapMod_lnk_9/10/11.html` lists 6 graph frames each. I viewed gr_174, gr_181, gr_195, gr_196 and gr_216.
- **Severity reasoning:** this is Minor. What the page shows is mathematically correct and on-topic, and the two cases do match legacy Examples 2 to 4. The departure is an omission rather than a contradiction. Examples 9 and 10 are about higher derivatives and are only loosely about Richardson extrapolation.
- **Suggested correction:** choose one of these:
  - (a) Add a case reproducing Example 8: at x0 = 1, with h over the legacy H list, plot f, the five stencil points and the tangent line of slope D5. Optionally add the f″ and f‴ analogues.
  - (b) Add one sentence to the Animations introduction saying that the legacy higher-derivative stencil scenarios (Examples 8 to 10) are not reproduced.

No other findings. Every numerical claim, every behaviour claim, every formula and the wiring checked out (see the ledger and the implementation checks).

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Count: Error 0, Misleading 0, Minor 1.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `richexaa.jl` | 0 | 8.4 | richexaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `richexab.jl` | 0 | 6.4 | richexab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `richexaa.gif` | 9 | byte-identical | richexaa |
| `richexab.gif` | 12 | byte-identical | richexab |

### Page references

- Scripts linked: `richexaa.jl`, `richexab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Richardson extrapolation combines two finite-difference estimates with different step sizes so that the leading truncation term cancels." | Both scripts' `d5` combine D3 at h and at h/2 (lines 13 and 12). The h² cancellation was verified numerically (see I-2). | confirmed |
| D2 | "In the legacy module, this is presented as a refinement of the central three-point derivative for f(x)=e^{-x}\sin(x) over [0,\pi]" | Legacy gr_34 and gr_153: `f[x_] = e^-x Sin[x]`. gr_60: `[0, π]`. gr_148: D_five built from D_three. | confirmed |
| D3 | D_3(x,h)=(f(x+h)-f(x-h))/(2h) | Matches `d3` in both scripts. | confirmed |
| D4 | D_5(x,h)=(4D_3(x,h/2)-D_3(x,h))/3 | Matches `d5` in both scripts. I also verified that it equals the five-point central formula with step h/2 to about 1e-15 (`inst_a.jl`; for example x=1, h=0.02 gives diff −9.2e-16). Note: the legacy convention is D_five(x,h) = (4D3(x,h) − D3(x,2h))/3 (gr_148), so the page's D_5(x,h) is the legacy D_five(x,h/2). Both are valid Richardson formulations, and the page states its own formula explicitly, so this is not a finding. A reader comparing numbers with Mathews' tables at the same h would see D5 errors about 16× smaller. | confirmed (valid variant) |
| D5 | "upgrades the local truncation behavior from O(h^2) to O(h^4) for smooth functions" | Exact-arithmetic local slopes at x=1: p3 = 2.007 → 2.000, p5 = 3.905 → 4.000 (`indep.py`). | confirmed |
| D6 | Derivation Notes: if D_3 = f' + C_2h^2 + C_4h^4 + ⋯ then (4D_3(h/2)−D_3(h))/3 = f' + O(h^4), "because the C_2 h^2 contribution cancels exactly" | Algebra: 4·C2h²/4 − C2h² = 0, leaving −C4h⁴/4. With C4 = f⁽⁵⁾/120 this gives D5 error −f⁽⁵⁾h⁴/480. Numerically, err5 / (\|f⁽⁵⁾(1)\|h⁴/480) → 1.0000 and err3 / (\|f‴(1)\|h²/6) → 1.0000 as h → 0 (`indep.py`). | confirmed |
| A1 | "Each animation below compares the base central difference with Richardson extrapolation for the legacy test function and interval." | Both scripts use f = e^{−x} sin x. Case 1 uses [0, π]. Case 2 uses x0 = 1 ∈ [0, π], the same X as legacy Examples 8 to 10. | confirmed |
| C1-h | Heading: "Case 1 - profile comparison, D_3(x,h) vs. D_5(x,h)" | `richexaa.jl` plots f′ on [0,π] and D3 and D5 on [h, π−h] for 9 values of h. Frames 1–9 have titles h = 0.5 … 0.01. | confirmed |
| C1-b1 | "Both approximations converge as h shrinks" | Max errors from script and independent computation agree (table in I-1). They decrease monotonically: D3 6.81e-2 → 3.33e-5, D5 1.32e-4 → 8.17e-11. | confirmed |
| C1-b2 | "the Richardson curve tracks f'(x) much more closely" | Ratio max3/max5 grows from 515 (h=0.5) to 4.1e5 (h=0.01). In frames 1–3 the dashed D3 visibly separates from f′ while D5 overlays it. | confirmed |
| C1-b3 | "because the dominant h^2 error term is canceled" | See D6. | confirmed |
| C1-link | [Julia source](richexaa.jl) and embed richexaa.gif | The script writes richexaa.gif, and that GIF is the profile animation. | confirmed |
| C1-alt | "Animation comparing D3 and Richardson D5 derivative curves against the true derivative over 0 to pi for decreasing h." | Frames show f′ (black) on [0, π], with D3 (dashed) and D5 (orange) for h decreasing from 0.5 to 0.01. | confirmed |
| C1-frame | Frame annotations "max\|error D3\| ≈ … max\|error D5\| ≈ …" | All 9 frames match the independent values to 3 significant figures (I-1). The max is attained at x = h, the left end of the plotted range. | confirmed |
| C2-h | Heading: "Case 2 - pointwise convergence at x_0=1 on log-log axes" | `richexab.jl`: `x0 = 1.0`, `xaxis=:log, yaxis=:log`. | confirmed |
| C2-b1 | "The error slope for the three-point formula follows approximately O(h^2)" | Double-precision script values give local slopes of 2.00 throughout. The data sit within 0.5% of the O(h²) guide (err3/guide2 = 0.995–1.000). | confirmed |
| C2-b2 | "while Richardson extrapolation follows approximately O(h^4) before roundoff effects appear" | Slopes are 3.9–4.0 down to h = 0.006. With the script's double-precision values, the last two intervals give slopes 4.82 and 1.72, and err5(0.0015) = 1.29e-14 against exact truncation 4.67e-15. The final frame visibly leaves the O(h⁴) guide at the last two points. The stated qualifier is accurate. | confirmed |
| C2-link | [Julia source](richexab.jl) and embed richexab.gif | The script writes richexab.gif, and that GIF is the log-log convergence plot. | confirmed |
| C2-alt | "log-log error curves versus h at x0 equals 1 showing second-order and fourth-order convergence trends" | Frames 1–12 add one h per frame. Blue circles show D3, orange diamonds show D5, and dashed and dotted guides show O(h²) and O(h⁴). | confirmed |
| C2-legend | Legend "\|D3(1,h)-f'(1)\|", "\|D5(1,h)-f'(1)\|", "O(h^2) guide", "O(h^4) guide" | The legend matches the plotted series in code lines 34–55. The guides are anchored at the h = 0.5 point (c2 = 0.17031, c4 = 8.6015e-4). | confirmed |
| W1 | Section index links the page | `pages/numerical-methods/index.qmd:92` contains `[Richardson Extrapolation](richardson-extrapolation/)`. | confirmed |

### 3. Implementation checks

### I-1 `richexaa.jl` (Case 1: profile of D3 and D5 against f′ on [0, π])

- **It is the method it claims to be.** `d3` is the central three-point difference. `d5 = (4 d3(x,h/2) − d3(x,h))/3` is one Richardson step eliminating h². It equals the five-point central formula (f(x−2k) − 8f(x−k) + 8f(x+k) − f(x+2k))/(12k) with k = h/2, which I verified to ≤ 1e-15 at x ∈ {0.3, 1, 2.5} and h ∈ {0.2, 0.02} (`review/inst_a.jl`). This is the standard "h and h/2" variant (Mathews uses "h and 2h").
- **The numbers are right.** I recomputed the per-frame maxima over the script's own grid `xint = range(h, π−h, 700)` in 50-digit mpmath (`review/indep.py`) and compared them with the instrumented script (`review/inst_a.jl`):

| h | script max3 | independent max3 | script max5 | independent max5 | GIF annotation |
|---|---|---|---|---|---|
| 0.5 | 6.81e-02 | 6.807e-02 | 1.32e-04 | 1.321e-04 | 6.81e-02 / 1.32e-04 |
| 0.32 | 3.12e-02 | 3.116e-02 | 4.08e-05 | 4.076e-05 | 3.12e-02 / 4.08e-05 |
| 0.2 | 1.28e-02 | 1.283e-02 | 8.56e-06 | 8.561e-06 | 1.28e-02 / 8.56e-06 |
| 0.12 | 4.73e-03 | 4.731e-03 | 1.34e-06 | 1.340e-06 | 4.73e-03 / 1.34e-06 |
| 0.08 | 2.12e-03 | 2.119e-03 | 2.89e-07 | 2.890e-07 | 2.12e-03 / 2.89e-07 |
| 0.05 | 8.31e-04 | 8.311e-04 | 4.70e-08 | 4.701e-08 | 8.31e-04 / 4.70e-08 |
| 0.03 | 3.00e-04 | 2.997e-04 | 6.35e-09 | 6.351e-09 | 3.00e-04 / 6.35e-09 |
| 0.02 | 1.33e-04 | 1.333e-04 | 1.28e-09 | 1.281e-09 | 1.33e-04 / 1.28e-09 |
| 0.01 | 3.33e-05 | 3.333e-05 | 8.17e-11 | 8.168e-11 | 3.33e-05 / 8.17e-11 |

- **Its reference values are right.** `fp(x) = e^{−x}(cos x − sin x)`. sympy's `diff(exp(-x)*sin(x), x)` minus this expression simplifies to 0. The legacy Example 2(b) graph (gr_93) has the same shape as the black f′ curve: 1 at x = 0, a minimum of about −0.2 near x ≈ 1.6, and about −0.04 at π.
- **The picture shows what was computed.**
  - I viewed the contact sheet and frames 1 to 9.
  - The black f′ is drawn on [0, π]. D3 (blue dashed) and D5 (orange) are drawn on [h, π−h]. That restriction keeps the stencil inside [0, π]; it is a display choice and harmless.
  - Titles show the correct h, and the legend formula matches the code.
  - With ylims (−1, 1.1), all curves stay inside the window (range about −0.21 to 1).
  - From h = 0.12 on, D3 is visually indistinguishable from f′. The on-frame max-error annotation carries the comparison from there, which is honest.
  - Each frame's maximum is taken over a slightly different interval [h, π−h] and is attained at x = h. This does not change any conclusion.

### I-2 `richexab.jl` (Case 2: pointwise error at x0 = 1 on log-log axes)

- **It is the method it claims to be.** It uses the same `d3` and `d5` as Case 1. Errors are `abs(d(x0,h) − fp(x0))` for 12 values of h.
- **The numbers are right.** Instrumented script (`review/inst_b.jl`) beside the independent values (`review/indep.py`, 50-digit exact arithmetic):

| h | script err3 | exact err3 | script err5 | exact err5 (truncation only) | exact err5 / (\|f⁽⁵⁾(1)\|h⁴/480) |
|---|---|---|---|---|---|
| 0.5 | 4.257869e-02 | 4.257869e-02 | 5.375918e-05 | 5.375918e-05 | 0.9316 |
| 0.32 | 1.738872e-02 | 1.738872e-02 | 9.410393e-06 | 9.410393e-06 | 0.9720 |
| 0.2 | 6.783537e-03 | 6.783537e-03 | 1.461109e-06 | 1.461109e-06 | 0.9891 |
| 0.12 | 2.440728e-03 | 2.440728e-03 | 1.906987e-07 | 1.906987e-07 | 0.9961 |
| 0.08 | 1.084580e-03 | 1.084580e-03 | 3.775150e-08 | 3.775150e-08 | 0.9983 |
| 0.05 | 4.236281e-04 | 4.236281e-04 | 5.766570e-09 | 5.766569e-09 | 0.9993 |
| 0.03 | 1.525008e-04 | 1.525008e-04 | 7.476736e-10 | 7.476741e-10 | 0.9998 |
| 0.02 | 6.777739e-05 | 6.777739e-05 | 1.477083e-10 | 1.477089e-10 | 0.9999 |
| 0.01 | 1.694424e-05 | 1.694424e-05 | 9.238929e-12 | 9.232562e-12 | 1.0000 |
| 0.006 | 6.099917e-06 | 6.099917e-06 | 1.205230e-12 | 1.196561e-12 | 1.0000 |
| 0.003 | 1.524978e-06 | 1.524978e-06 | 4.259093e-14 | 7.478561e-14 | 1.0000 |
| 0.0015 | 3.812445e-07 | 3.812445e-07 | 1.292022e-14 | 4.674109e-15 | 1.0000 |

  - Exact-arithmetic local slopes: p3 = 2.007, 2.003, 2.001, then 2.000 for the rest. p5 = 3.905, 3.963, 3.986, 3.995, 3.998, 3.999, then 4.000. Both match the method's order, and the error constants match the leading terms f‴h²/6 and f⁽⁵⁾h⁴/480 (the 480 confirms the h/2 variant).
  - Script err3 agrees with the exact value to all printed digits.
  - Script err5 agrees down to h = 0.006, within 0.7%. At h = 0.003 and 0.0015 it departs (ratios 0.57 and 2.76). That is double-precision roundoff, which the page's "before roundoff effects appear" correctly anticipates.
- **Its reference values are right.** The reference is f′(1) = e^{−1}(cos 1 − sin 1) = −0.110793765…, from the verified closed-form `fp` (see I-1).
- **The picture shows what was computed.**
  - I viewed the contact sheet and frames 1 and 12 at full size.
  - Each frame k shows the first k values of h. Axes are log-log, and h decreases to the left.
  - The guides span [min h, max h] of the visible points and are anchored at h = 0.5. Data and guide agree within 0.5% for D3 and 7% for D5 (the O(h⁴) guide is anchored before the asymptotic regime). The O(h²) guide therefore lies almost on top of the blue data line. It is still faintly visible, and the overlap is the intended message.
  - Frame 1 has a single point per series with fractional-exponent tick labels (10^−0.2, 10^0.0). This is cosmetic and not misleading.
  - In frame 12 the last two orange points leave the dotted guide, which agrees with the roundoff values above.
  - The title "Pointwise Richardson Convergence at x0 = 1" and the legend entries are correct.

