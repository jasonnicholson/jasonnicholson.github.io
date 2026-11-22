# Newton-Raphson Method — animation review (round 5)

Page: `pages/numerical-methods/newton-raphson-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, in the script headers and in the frames agrees with an independent computation. Details follow in the ledger and the implementation checks.

Observed but not reported as findings (cosmetic, not misleading):
- `newtoncc.gif` legends for frames 6 to 8 read `x₆ = 0.0`, `x₇ = -0.0`, `x₈ = 0.0` (true values 2.86e-6, -1.56e-17, 0.0) because labels round to 5 decimals. The `-0.0` is a little odd but correct to the stated precision.
- The legend subscripts use `₍n₎` (e.g. `x₍₃₎`), which reads fine in the frames.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonaa.jl` | 0 | 6.8 | newtonaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonbb.jl` | 0 | 6.9 | newtonbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncc.jl` | 0 | 6.7 | newtoncc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtondd.jl` | 0 | 6.5 | newtondd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonee.jl` | 0 | 6.6 | newtonee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonff.jl` | 0 | 7.1 | newtonff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtonaa.gif` | 6 | byte-identical | newtonaa |
| `newtonbb.gif` | 13 | byte-identical | newtonbb |
| `newtoncc.gif` | 9 | byte-identical | newtoncc |
| `newtondd.gif` | 11 | byte-identical | newtondd |
| `newtonee.gif` | 7 | byte-identical | newtonee |
| `newtonff.gif` | 7 | byte-identical | newtonff |

### Page references

- Scripts linked: `newtonaa.jl`, `newtonbb.jl`, `newtoncc.jl`, `newtondd.jl`, `newtonee.jl`, `newtonff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Independent values are from `indep.py` unless noted.

### Introduction
| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| I1 | "At each iterate $x_n$, a tangent line to $f(x)$ is drawn; its x-intercept gives $x_{n+1} = x_n - f(x_n)/f'(x_n)$" | All six scripts update `xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])`; each drawn segment runs from $(x_n, f(x_n))$ to $(x_{n+1}, 0)$, both points lying on the tangent line | confirmed |
| I2 | "Julia source scripts ... are linked under each case" | six links, one per case | confirmed |

### Case 1: $f(x)=3e^x-4\cos x$, $x_0=1.0$
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 1a | Heading parameters $f$, $x_0=1.0$ | `newtonaa.jl` l.10, l.14 | confirmed |
| 1b | "single positive root, $x^*\approx 0.2549$" | root 0.25485005902885; f(0)=-1 and f'(x)=3e^x+4sin x>0 for x>0 (3e^x>4 once x>ln(4/3)), so the positive root is unique | confirmed |
| 1c | "infinitely many negative roots, outside the plotted window" | roots near -1.38121, -4.71908, -7.85369, ... (f≈-4cos x as x→-∞); window x∈[0,1.5] | confirmed |
| 1d | "$x_0=1.0$ on the convex side ... each tangent line lands between the root and the previous iterate ... decrease monotonically" | f''=3e^x+4cos x >0 on [0,1.5] (7.0 to 13.7); f(x0)=5.99>0; iterates 1 > 0.47975 > 0.28574 > 0.25558 > 0.2548504777 > 0.2548500590 all above root | confirmed |
| 1e | iterates "(1, 0.4798, 0.2857, 0.2556, 0.254850, …)" | script: 1.0, 0.479752016, 0.285738359, 0.255576900, 0.254850478; independent identical to 10 digits | confirmed |
| 1f | "number of correct digits roughly doubles each step ... quadratic" | errors 0.745, 0.225, 3.09e-2, 7.27e-4, 4.19e-7, 1.39e-13; e₅/e₄² = 0.79 vs f''(r)/(2f'(r)) = 7.742/9.760 = 0.793 | confirmed |
| 1g | Alt text: "rapid, monotone convergence from x₀=1.0 down to the root at x≈0.2549" | as 1d to 1f; frames 1 to 6 show the dot moving left along the curve to the crossing | confirmed |
| 1h | Link/embed `newtonaa.jl` / `newtonaa.gif` is this case | script parameters and GIF title `f(x) = 3eˣ − 4cos(x)` | confirmed |

### Case 2: $f(x)=(1-5x)^2$, $x_0=1.0$
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 2a | Heading parameters | `newtonbb.jl` l.11, l.15 | confirmed |
| 2b | "double root at $x^*=0.2$" | f=(1-5x)², f(0.2)=f'(0.2)=0, f''=50 | confirmed |
| 2c | "$f'(x^*)=0$ ... degrades to linear convergence" | iterates 1, 0.6, 0.4, 0.3, 0.25, 0.225, ..., 0.2001953125 | confirmed |
| 2d | "each step roughly halves the error" | ratio (x_{n+1}-0.2)/(x_n-0.2) = 0.5 exactly for all 12 steps (analytically x_{n+1}-0.2 = (x_n-0.2)/2) | confirmed |
| 2e | Alt text "slow linear convergence to the double root at x=0.2" | frame 13 legend `x₁₂ = 0.2002`, dot at 0.2 | confirmed |
| 2f | Script header "rate 1/2 per step" | as 2d | confirmed |
| 2g | Wiring | `newtonbb.*`, GIF title `f(x) = (1 − 5x)²` | confirmed |

### Case 3: $f(x)=\arctan x$, $x_0=1.35$
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 3a | Heading parameters | `newtoncc.jl` l.11, l.15 | confirmed |
| 3b | "Convergent near inflection point" | root x*=0 is arctan's inflection point (f''(0)=0); run converges | confirmed |
| 3c | "only root is $x^*=0$" | arctan strictly increasing | confirmed |
| 3d | "converges only when $\lvert x_0\rvert < x_c \approx 1.3917$" | x_c solves (1+x²)arctan x = 2x: 1.3917452003; |x0|>x_c gives growing |x_n| (case 6), |x0|=x_c a 2-cycle | confirmed |
| 3e | "$x_0=1.35$ (just inside the convergence radius), the method converges" | iterates 1.35, -1.28409, 1.12412, -0.78587, 0.29155, -0.016251, 2.86e-6, -1.56e-17, 0 (script = independent to all printed digits) | confirmed |
| 3f | "requires several oscillating steps before settling in" | signs alternate every step; |x_n| shrinks slowly for 4 steps then very fast | confirmed |
| 3g | Alt text "convergent case starting just inside the critical radius at x₀=1.35" | as above | confirmed |
| 3h | Wiring | `newtoncc.*`; all iterates inside window [-3, 2.5], frames show the zig-zag closing on 0 | confirmed |

### Case 4: $f(x)=x^3-x+3$, $x_0=0$
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 4a | Heading parameters | `newtondd.jl` l.12, l.16 | confirmed |
| 4b | "one real root, $x^*\approx -1.6717$" | root -1.6716998817; discriminant of x³-x+3 is -4(-1)³-27·9 = -239 < 0, so one real root | confirmed |
| 4c | "curve crosses the axis at the left of the window" | xlims (-2, 3.5); frames show crossing near -1.67 | confirmed |
| 4d | "attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475" | exact 4-cycle (fixed point of N⁴ found with findroot): 0.0074460774, 3.0004983, 1.9618967, 1.1475016; multiplier Π N'(c_i) = 0.2325 < 1, so attracting | confirmed |
| 4e | "iterates are drawn into ... never approach the root" | iterates 0, 3, 1.96154, 1.14718, 0.00658, 3.00039, 1.96182, 1.14743, 0.00726, 3.00047, 1.96188 (script = independent); x₄, x₈ approach 0.00745 | confirmed |
| 4f | Alt text "settle into a 4-cycle near 0.0074, 3.0005, 1.9619 and 1.1475 and never reach the real root at x≈−1.6717" | as 4d, 4e | confirmed |
| 4g | Script header l.4-5 (same values, "window widened to show it") | as above | confirmed |
| 4h | Display clamping (`clamp` to ylims) | max f(x_n) = 27.012 < 30; clamping never changes any drawn value | confirmed (no effect) |
| 4i | Wiring | `newtondd.*`; GIF has 11 frames x₀..x₁₀ | confirmed |

### Case 5: $f(x)=xe^{-x}$, $x_0=2$
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 5a | Heading parameters | `newtonee.jl` l.11, l.15 | confirmed |
| 5b | "only root is $x^*=0$" | x e^{-x}=0 iff x=0 | confirmed |
| 5c | "maximum of $f$ at $x=1$"; "there $f>0$ and $f'(x)=(1-x)e^{-x}<0$" (for x>1) | f'=(1-x)e^{-x}; zero at 1, negative for x>1 | confirmed |
| 5d | "$x_{n+1}=x_n^2/(x_n-1) > x_n$" | x - xe^{-x}/((1-x)e^{-x}) = x - x/(1-x) = x²/(x-1); x²/(x-1) - x = x/(x-1) > 0 for x>1 | confirmed |
| 5e | "(2, 4, 5.33, 6.56, …, 10.02 after six steps)" | 2, 4, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188 (script = independent) | confirmed |
| 5f | "$f(x_n)\to 0$" | f(x_n): 0.271, 0.0733, 0.0257, 0.00926, 0.00336, 0.00122, 0.000446 | confirmed |
| 5g | Alt text "each tangent line meets the axis further right ... toward +∞" | frames 1 to 7; all iterates inside window [0, 11], so the "→ ∞" legend branch is never used | confirmed |
| 5h | Wiring | `newtonee.*` | confirmed |

### Case 6: $f(x)=\arctan x$, $x_0=1.4$
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 6a | Heading parameters | `newtonff.jl` l.11, l.15 | confirmed |
| 6b | "just outside the critical convergence radius $x_c\approx1.3917$" | 1.4 > 1.39175 | confirmed |
| 6c | "do not converge ... escape toward larger $\lvert x\rvert$" | 1.4, -1.41362, 1.45013, -1.55063, 1.84705, -2.89356, 8.71033 (script = independent); |x_n| strictly increasing | confirmed |
| 6d | Script header "oscillates with growing amplitude" | sign alternates, |x_n| grows | confirmed |
| 6e | Alt text "divergent case starting just outside the critical radius at x₀=1.4" | as above | confirmed |
| 6f | Display: x₆=8.71 is outside window [-4,5] | last frame legend reads `x₆ = 8.71 (out of range)`, tangent from x₅ drawn and clipped at right edge; the true value is reported | confirmed (honest) |
| 6g | Wiring | `newtonff.*` | confirmed |

### Counts
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1 | Six cases, six scripts, six GIFs | page, folder, manifest | confirmed |
| C2 | Case 5 "after six steps" ↔ 7 frames | `n_iters = 6`, 7 frames | confirmed |

### 3. Implementation checks

All six scripts use the same loop `xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])` with a hand-coded derivative: plain Newton-Raphson, no damping or safeguards. The method is what the page names.

| Script | Derivative check | Script iterates (instrumented) | Independent (mpmath, numeric derivative) | Reference values | Picture |
|---|---|---|---|---|---|
| `newtonaa.jl` | fp = 3eˣ+4 sin x ✓ | 1, 0.47975201560572, 0.28573835913113, 0.25557690047166, 0.25485047773433, 0.25485005902899 | 1, 0.4797520156, 0.2857383591, 0.2555769005, 0.2548504777, 0.254850059 | root 0.2548500590289 | frames 1 to 6: tangent segments from (x_n, f(x_n)) to (x_{n+1}, 0), vertical drops, red dot on curve; legend values = round(x_n, 5) |
| `newtonbb.jl` | fp = -10(1-5x) ✓ | 1, 0.6, 0.4, 0.3, 0.25, ..., 0.2001953125 | identical | double root 0.2 | frame 13 shows staircase into 0.2; legend `0.2002` |
| `newtoncc.jl` | fp = 1/(1+x²) ✓ | 1.35, -1.28409115, 1.12412311, -0.78587188, 0.29155398, -0.01625100, 2.861e-6, -1.561e-17, 0.0 | identical to printed digits | root 0; x_c = 1.39174520 | all iterates in window, so the "both endpoints visible" filter never hides a step; zig-zag visible in frames 2 to 9 |
| `newtondd.jl` | fp = 3x²-1 ✓ | 0, 3, 1.96153846, 1.14717596, 0.00657937, 3.00038907, 1.96181818, 1.14743023, 0.00725625, 3.00047319, 1.96187865 | identical | root -1.67169988; 4-cycle 0.0074461, 3.0004983, 1.9618967, 1.1475016, multiplier 0.233 | clamping inactive (max f 27.01 < 30); cycle visible in frames 5 to 11 |
| `newtonee.jl` | fp = (1-x)e^{-x} ✓ | 2, 4, 5.33333, 6.56410, 7.74383, 8.89211, 10.01882 | identical | root 0; closed form x_{n+1}=x_n²/(x_n-1) | all iterates within [0,11]; frames show steps marching right |
| `newtonff.jl` | fp = 1/(1+x²) ✓ | 1.4, -1.41361865, 1.45012931, -1.55062598, 1.84705408, -2.89356239, 8.71032585 | identical | root 0; x_c as above | last step leaves the window and is labelled with its true value and "(out of range)" |

Point by point, for every script:
- **Method**: plain Newton-Raphson as named. Confirmed by reading the update line and by agreement with an independent Newton run that uses a numerically differentiated derivative, which also independently checks each hand-written `fp`.
- **Numbers**: script iterates agree with the independent 40-digit computation to every printed digit (table above). Rates were checked as properties: quadratic in case 1 (asymptotic constant 0.79 vs theoretical 0.793), error ratio exactly 0.5 for the double root in case 2, alternating and shrinking or growing |x_n| either side of x_c for the arctan pair, 4-cycle multiplier < 1 in case 4, x_{n+1}=x_n²/(x_n-1) in case 5.
- **Reference values**: the page's roots (0.2549, 0.2, 0, -1.6717, 0, 0), x_c ≈ 1.3917 and the cycle values were all recomputed independently and agree at the stated precision.
- **Picture**: I viewed contact sheets for all six GIFs and full frames for the last frames of cases 2 and 3. Titles name the function in the code, legend indices match frame numbers (frame k shows x_k), dots sit on the curve at x_k, and tangent segments connect (x_k, f(x_k)) to (x_{k+1}, 0). The window-visibility filters in cc, dd and ee never trigger, because every iterate is inside the window. The clamp in dd never changes a value. In ff the off-window final iterate is reported with its true value.

### Fidelity to the legacy archive
`Newton'sMethodMod.html` Examples 3 to 8 ("Various Scenarios and Animations") are, from their formula images (`Newton'sMethodMod_gr_374/375, 394/395, 433/434, 454/455, 484/485, 514/515`, montage in `review/mathews_cases.png`):
- Ex 3 Fast Convergence: 3eˣ−4cos x = 0, p₀ = 1.0 → Case 1 ✓
- Ex 4 Slow Convergence: 1−10x+25x² = 0, p₀ = 1.0 → Case 2 ✓ (same polynomial as (1−5x)²)
- Ex 5 Convergence, Oscillation: arctan x = 0, p₀ = 1.35 → Case 3 ✓
- Ex 6 NON Convergence, Cycling: x³−x+3 = 0, p₀ = 0.0 → Case 4 ✓
- Ex 7 NON Convergence, Diverging to Infinity: x e^{-x} = 0, p₀ = 2.0 → Case 5 ✓
- Ex 8 NON Convergence, Divergent Oscillation: arctan x = 0, p₀ = 1.4 → Case 6 ✓

The archive's links go to `a2001/Animations/RootFinding/NewtonMethod/Newtonaa..ff.html`, matching the script names one to one. Examples 1 and 2 are worked computations with no animation, so the page does not drop an animated case. No fidelity departures.

