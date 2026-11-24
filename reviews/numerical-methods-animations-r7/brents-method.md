# Brent's Method — animation review (round 7)

Page: `pages/numerical-methods/brents-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: Case 1 alt text says the bracket narrows to the root, but it stops 3.2e-4 wide

- **Location:** `index.qmd` line 70, alt text: "bracket narrows from [0,1] to the root at x≈0.3285 in 8 steps".
- **What is there now:** the wording says the bracket closes on the root.
- **What is true:** the Case 1 run ends with the bracket $[0.3282147397, 0.3285384586]$, width $3.237\times10^{-4}$. That is about $6.5\times10^{6}$ times the $5\times10^{-11}$ tolerance the page quotes. The bracket barely changes over steps 6-8 (3.29e-4, 3.24e-4, 3.24e-4). What converges is $b$, and the run stops because $f(b)$ evaluates to exactly 0, not because the bracket became small. The Behavior paragraph reports $f(b)=0$ but does not say that this ended the run, and the last frame's legend prints `|c−b| = 3.2e-04`.
- **How I know:** `julia inst.jl` prints, at step 8, `b=0.3285384586114149 c=0.32821473974562487 width=3.237189e-04 f(b)=0`. `julia reasons.jl` prints `stop after step 8: |xm|=1.619e-04 tol1=5.000e-11 fb=0.000e+00`, so the width test did not trigger the stop.
- **Suggested correction:** alt text: "Brent's Method on f(x)=4x³−16x²+17x−4: b converges to the root at x≈0.3285 in 8 steps while the bracket narrows from [0,1] to width 3.2×10⁻⁴, with step labels showing bisection, secant, and IQI selections". Optionally add to the Case 1 Behavior paragraph: "The run stops there because $f(b)=0$, with the bracket still $3.2\times10^{-4}$ wide."

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `brentsaa.jl` | 0 | 7.9 | brentsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `brentsbb.jl` | 0 | 7.7 | brentsbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: **C** confirmed, **W** wrong, **?** could not determine. History and attribution claims are excluded as the brief directs.

### Description

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 1 | 12 | Needs only continuous $f$ with opposite-sign endpoints; no derivatives | C | Code uses only $f$ values and a sign-change invariant |
| 2 | 14 | Maintains a bracket that always contains a root | C | `@assert fb*fc <= 0` held at every step of both runs |
| 3 | 14 | Selects among three sub-methods | C | Code branches: IQI, secant, bisection (plus the minimum-step guard) |
| 4 | 16 | IQI fits $x$ as a quadratic in $y$ through $a,b,c$, evaluated at $y=0$ | C | Page's Lagrange formula equals the code's $p/q$ step at every accepted IQI step (diff at most 5.6e-17) |
| 5 | 16 | IQI converges superlinearly near a simple root | C | Pure IQI at 2000 digits: empirical order 1.83917 |
| 6 | 17 | Secant/regula falsi chord through $a$, $b$ is used when $a=c$ | C | Code branch `a == c`. Because $b,c$ bracket the root, this chord is literally a false-position step, so the parenthetical is accurate |
| 7 | 18 | Bisection is the safeguard and shrinks the bracket by at least half | C | Bisection steps halve it: Case 2 widths 0.9607 to 0.4804 to 0.2402 |
| 8 | 24 | $f(b)f(c)\le 0$, $\lvert f(b)\rvert\le\lvert f(c)\rvert$ | C | Asserted at every step in `reasons.jl`; no failure |
| 9 | 26 | $b$ is best; root lies between $b$ and $c$; $a$ is the previous $b$ or coincides with $c$ | C | Code lines 43-50 and 95 |
| 10 | 32 | IQI formula | C | See #4; also reproduces scipy's iterates |
| 11 | 34 | IQI accepted only if inside the bracket and making adequate progress, else bisection | C | Code lines 82-89. Case 2 step 3: candidate 3.829 rejected, bisection taken |
| 12 | 40 | Secant formula | C | Equals the code's step at every accepted secant step (diff 0) |
| 13 | 44 | Safeguards: within about 3/4 of the way from $b$ to $c$, and smaller than half the step before last | C | Code line 82. The code has a further trigger ($\lvert f(a)\rvert\le\lvert f(b)\rvert$), which the page does not list but does not exclude. It causes the first bisection in both cases; the two listed tests would have rejected those candidates anyway (`step2.py`: 1.3105 and -0.1452), so nothing shown contradicts the text |
| 14 | 44 | $x^9$ on $[-1,2]$: 96 evaluations to get the bracket below $10^{-10}$ | C | Script's routine 96; my implementation 96; scipy `brentq` 96. Width goes 2.0e-10 to 5.0e-11 at evaluation 96 |
| 15 | 44 | Bisection needs 37 for the same | C | 35 iterations + 2 endpoint evaluations = 37; width 8.7e-11 |
| 16 | 45 | IQI order about 1.839, root of $t^3=t^2+t+1$ | C | Root 1.839287; empirical 1.83917 |
| 17 | 46 | Cannot fail with a valid bracket and continuous $f$ | C | Follows from the invariant and the forced bisection; held on all test problems |
| 18 | 52-56 | Table: orders 1, 1, 1.618, 1.839, up to 1.839; guarantees; no derivatives | C | Secant empirical order 1.61803; IQI 1.83917; regula falsi linear (ratios 0.361 and 0.866 here) |

### Animations introduction

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 19 | 60 | Shaded region is the bracket between $b$ and $c$ | C | Drawn bracket lines are within 1 px of the computed $b,c$ in all 20 frames (`pix.py`) |
| 20 | 60 | Red dot is $b$, the endpoint with the smaller $\lvert f\rvert$ | C | Dot centres fit $(b, f(b))$ linearly: max residual 0.04 px (Case 1), 0.74 px (Case 2, where the legend clips the dot at steps 2-3) |
| 21 | 60 | Annotation names the sub-method | C | All 20 labels match the trace |
| 22 | 60 | "Min step" is a step below about $5\times10^{-11}$ replaced by that length | C | Case 2 step 10: $\lvert d\rvert$ = 4.58e-12, moved by tol1 = 5.000e-11 |
| 23 | 60 | Legend gives $b$ to 10 decimals and $\lvert c-b\rvert$ | C | Frames read against computed values |
| 24 | 60 | Bracket narrower than one pixel from step 6 (Case 1), step 8 (Case 2) | C | Case 1: step 5 = 2.11 px, step 6 = 0.063 px. Case 2: step 7 = 5.30 px, step 8 = 0.032 px |
| 25 | 62 | Source scripts linked under each case | C | Lines 68 and 76 |

### Case 1

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 26 | 64 | $f=4x^3-16x^2+17x-4$ on $[0,1]$ | C | Script lines 11-14; frame title; archive Example 4(i) |
| 27 | 66 | $f(0)=-4$, $f(1)=1$ | C | Computed |
| 28 | 66 | Root about 0.3285 | C | 0.32853845861141490 (60-digit mpmath) |
| 29 | 66 | 8 steps: secant, bisection, IQI, secant, IQI, secant, secant, IQI | C | Script, my implementation and scipy agree; 9 frames |
| 30 | 66 | Step 3: IQI point 0.2276 has larger $\lvert f\rvert$, becomes other end, $b$ stays 0.4 | C | $\lvert f(0.2276)\rvert$ = 0.9124 > $\lvert f(0.4)\rvert$ = 0.4960 |
| 31 | 66 | After step 2, every step is interpolation | C | Trace |
| 32 | 66 | Errors at steps 5-8: 3.2e-4, 5.5e-6, 2.7e-9, 4.0e-19 | C | 3.237e-4, 5.461e-6, 2.738e-9, 3.983e-19 |
| 33 | 66 | At step 8, $b$ is the nearest double to the root | C | $\lvert b-x^*\rvert$ = 3.98e-19 < ulp/2 = 2.8e-17 |
| 34 | 66 | $f(b)$ evaluates to exactly 0 | C | Julia gives 0.0 (exact value at $b$ is 3.1e-18) |
| 35 | 66 | Bisection needs 32 iterations for $10^{-10}$ | C | Error 2.83e-10 at n=31, 4.99e-11 at n=32, and within $10^{-10}$ at every later n checked |
| 36 | 66 | Regula falsi needs 24 | C | First within $10^{-10}$ at iteration 24 |
| 37 | 66 | Other roots 1.2647 in $[1,2]$, 2.4068 in $[2,3]$, visible in the window | C | 1.26465829006, 2.40680325132; window reaches 3.1 |
| 38 | 66 | Mathews' example also finds these with Brent's method | C | Archive `gr_241`/`gr_242`, `gr_252`/`gr_253` |
| 39 | 68 | Link is the Case 1 script | C | `brentsaa.jl` |
| 40 | 70 | Alt: embed is the Case 1 GIF; 8 steps; root about 0.3285; labels | C | `brentsaa.gif` |
| 41 | 70 | Alt: "bracket narrows from [0,1] to the root" | **W (Minor)** | Final width 3.2e-4; see F1 |

### Case 2

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 42 | 72 | $f=\tan x-2x$ on $[0.5,1.5]$ | C | Script lines 11-14; frame title; archive Example 5 |
| 43 | 74 | Root about 1.1656, the smallest positive root | C | 1.16556118520721. $f(0)=0$, $f$ is convex on $(0,\pi/2)$, so there is exactly one root there |
| 44 | 74 | $f(0.5)\approx-0.454$, $f(1.5)\approx11.1$ | C | -0.45370, 11.10142 |
| 45 | 74 | 10 steps: secant, 2 bisections, secant, IQI, secant, secant, IQI, secant, minimum step | C | Script, my implementation and scipy agree; 11 frames |
| 46 | 74 | Ends with bracket width $5\times10^{-11}$, $b\approx1.1655611852$ at one end, root inside | C | $b$=1.1655611852026, $c$=1.1655611852526, $x^*$=1.1655611852072 |
| 47 | 74 | Step 3 bisection moves right end from 1.5 to 1.2598 | C | $c$ = 1.25981594 |
| 48 | 74 | Regula falsi needs 165 iterations | C | First within $10^{-10}$ at iteration 165 |
| 49 | 74 | $f$ convex here | C | $f''=2\tan x\sec^2x>0$ on the interval |
| 50 | 74 | Every chord lands left of the root; right endpoint stays 1.5 | C | All 165 iterates below $x^*$; final bracket right end 1.5 |
| 51 | 74 | Error eventually shrinks by about 0.87 per iteration | C | Measured 0.86642; theory $1-f'(x^*)(1.5-x^*)/f(1.5)$ = 0.866418 |
| 52 | 76 | Link is the Case 2 script | C | `brentsbb.jl` |
| 53 | 78 | Alt: embed is Case 2 GIF; bracket narrows to root; 10 steps; $\pi/2$ asymptote | C | Final width 5.0e-11; dotted line at $\pi/2$ in every frame |

### Fidelity to the archive

- Both cases are Mathews' Brent examples with the same function and interval (Example 4 root (i), Example 5). The script's iterates match the archive's printed $p_k$ through step 8 (Case 1) and step 9 (Case 2), to about 15 significant digits (the last printed digit can differ, for example 0.3285384586114148 against 0.3285384586114149).
- **Tolerance differs, not a finding.** Mathews used $\pm10^{-15}$ and the scripts use $10^{-10}$. The page states its own tolerance and attributes none of its counts to Mathews (his 36, 50 and 243 are for the tighter tolerance). The iterates are the same until the tolerance matters.
- **Example 4 roots (ii) and (iii)** are not animated, and the page says so.
- **Examples 1-3** are secant and pure-IQI exercises (the same cubic, and $x^3-3x+2$), not runs of Brent's method. I do not count their absence as a silent drop.
- No legacy animated GIF for this topic was found under `a2001/Animations/`.

### 3. Implementation checks

The two scripts contain the same `run_brents`. Both produce GIFs byte-identical to the committed ones, per the manifest.

### `brentsaa.jl`

- **Is the method it claims:** yes. It is Brent's ZEROIN (1973) in the common Numerical Recipes arrangement, with tolerance $2\varepsilon\lvert b\rvert+\text{tol}/2$. Bracket normalisation, the IQI and secant $p/q$ forms, both acceptance tests, the bisection fallback and the minimum step are all present.
- **Numbers:** my independent Python implementation (step computed from the page's formulas) and scipy `brentq` visit the same points.

| Step | Method | Script $b$ | Independent $b$ | Error in $b$ |
|---|---|---|---|---|
| 0 | start | 1 | 1 | 6.715e-1 |
| 1 | Secant | 0.80000000000000004 | same | 4.715e-1 |
| 2 | Bisection | 0.40000000000000002 | same | 7.146e-2 |
| 3 | IQI | 0.40000000000000002 | same | 7.146e-2 |
| 4 | Secant | 0.33928781217489301 | same | 1.075e-2 |
| 5 | IQI | 0.32821473974562487 | same | 3.237e-4 |
| 6 | Secant | 0.32854391944914269 | same | 5.461e-6 |
| 7 | Secant | 0.32853846134936388 | same | 2.738e-9 |
| 8 | IQI | 0.3285384586114149 | same | 3.983e-19 |

- **Reference values:** root from 60-digit `mpmath.findroot`, residual 3e-61.
- **Picture:** curve, bracket, dot, labels and title checked against computed values across all 9 frames. The clamp on $f$ only affects values outside the window. See F1 for the one text issue.

### `brentsbb.jl`

- **Is the method it claims:** yes, the same routine.
- **Numbers:**

| Step | Method | Script $b$ | Independent $b$ | Error in $b$ |
|---|---|---|---|---|
| 0 | start | 0.5 | 0.5 | 6.656e-1 |
| 1 | Secant | 0.53926377311452489 | same | 6.263e-1 |
| 2 | Bisection | 1.0196318865572624 | same | 1.459e-1 |
| 3 | Bisection | 1.0196318865572624 | same | 1.459e-1 |
| 4 | Secant | 1.1182930272785787 | same | 4.727e-2 |
| 5 | IQI | 1.1766603295259697 | same | 1.110e-2 |
| 6 | Secant | 1.1637285834543314 | same | 1.833e-3 |
| 7 | Secant | 1.1654929603348207 | same | 6.822e-5 |
| 8 | IQI | 1.1655612050524227 | same | 1.985e-8 |
| 9 | Secant | 1.1655611852026313 | same | 4.58e-12 |
| 10 | Min step | 1.1655611852026313 | same | 4.58e-12 |

- **Reference values:** root from 60-digit `mpmath.findroot`, residual 0 at working precision; archive prints 1.165561185207211.
- **Picture:** all 11 frames checked. The NaN mask and clamp near $\pi/2$ do not change anything a viewer would conclude: the asymptote is marked and lies outside the bracket. At steps 2-3 the legend box clips a corner of the dot, which stays readable.

### Routine on closed-form problems (both scripts)

The script's own `run_brents` was run on seven problems and every evaluation point compared with scipy `brentq` (`julia routine.jl`, `python3 routine.py`).

| Problem | Evaluations (script / scipy) | Max point difference | Error against closed form |
|---|---|---|---|
| $x^2-2$ on $[0,2]$ | 9 / 9 | 2.2e-16 | 4.13e-14 |
| $x^3-2$ on $[0,3]$ | 11 / 11 | 2.2e-16 | 6.66e-16 |
| $e^x-2$ on $[0,1]$ | 8 / 8 | 0 | 0 |
| $\cos x$ on $[1,2]$ | 7 / 7 | 0 | 0 |
| $\ln x$ on $[0.5,3]$ | 9 / 9 | 2.2e-16 | 1.83e-13 |
| $(x-1)^3$ on $[0,3]$ | 106 / 106 | 2.2e-16 | 3.88e-12 |
| $x^3-3x+2$ on $[-3,0]$ | 11 / 11 | 0 | 2.83e-12 |

### Could not determine

Nothing on the page was left undetermined.

