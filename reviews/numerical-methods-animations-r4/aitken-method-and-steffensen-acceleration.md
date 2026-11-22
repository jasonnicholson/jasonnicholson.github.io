# Aitken's Method & Steffensen's Acceleration — animation review (round 4)

Page: `pages/numerical-methods/aitken-method-and-steffensen-acceleration/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Page match, Minor: Case 2's final Steffensen error is given as "about 6 × 10⁻¹⁶", but it is 6.7 × 10⁻¹⁶

- **Location:** `index.qmd` line 81, "its error reaches about $6 \times 10^{-16}$ after 4 steps (8 Newton steps)". The same number is in the Case 2 alt text on line 85, "reaches error about 6×10⁻¹⁶ (double-precision rounding level) after 4 steps".
- **What is there now:** 6 × 10⁻¹⁶.
- **What is true:** the script computes S₄ = 1.41421356237309448 and |S₄ − √2| = 6.661 × 10⁻¹⁶. That is exactly 3 units in the last place (3 · 2⁻⁵² = 6.66 × 10⁻¹⁶), and to one significant figure it rounds to 7 × 10⁻¹⁶, not 6. "About" softens the claim and the order of magnitude is right, so this is Minor. The rest of the page rounds to two significant figures (6.6 × 10⁻⁹, 4.7 × 10⁻⁸ and so on), and this value does not follow that convention. In exact arithmetic S₄ would have error 5.0 × 10⁻¹⁷ (mpmath), so the 6.7 × 10⁻¹⁶ comes from rounding, as the page says.
- **How I know:** `julia instr_cd.jl` prints `S  4  1.41421356237309448 err=6.661e-16`. `python3 -I indep.py` prints `S4 1.414213562373095 err=4.973e-17` for exact arithmetic.
- **Correction:** write "$6.7 \times 10^{-16}$ (three units in the last place)" on line 81 and "6.7×10⁻¹⁶" in the alt text on line 85.

No other finding. Every other numerical, behavioural and wiring claim on the page agrees with my own computation. The ledger below lists each one.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Count: 0 Error, 0 Misleading, 1 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `aitkenab.jl` | 0 | 14.1 | aitkenab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkencd.jl` | 0 | 10.7 | aitkencd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkenef.jl` | 0 | 9.7 | aitkenef.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `aitkenab.gif` | 23 | byte-identical | aitkenab |
| `aitkencd.gif` | 23 | byte-identical | aitkencd |
| `aitkenef.gif` | 23 | byte-identical | aitkenef |

### Page references

- Scripts linked: `aitkenab.jl`, `aitkencd.jl`, `aitkenef.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Newton converges quadratically at simple roots; at a root of multiplicity m, \|x_{k+1}−p\|/\|x_k−p\| → (m−1)/m | Standard result. For all three double roots the mpmath Newton ratios (x_k−p)/(x_{k−1}−p) at k = 21, 22 are 0.500000 | confirmed |
| D2 | For m = 2 the ratio is ½; about 50 iterations take an O(1) error to 10⁻¹⁶ (2⁻⁵³ ≈ 1.1 × 10⁻¹⁶) | 2⁻⁵³ = 1.11e-16, which is 53 halvings, "about 50" | confirmed |
| D3 | "for the expanded polynomials of Cases 1 and 3 below, f evaluates to exactly 0 after 28 and 25 Newton steps, at errors of 1.5 × 10⁻⁹ and 2.6 × 10⁻¹⁰" | Extended Float64 Newton in the instrumented copies: Case 1 `f==0 at k=28 err=1.521e-09`; Case 3 `f==0 at k=25 err=2.554e-10` | confirmed |
| D4 | Aitken formula x̂_k = x_k − (Δx_k)²/Δ²x_k with Δ²x_k = x_{k+2} − 2x_{k+1} + x_k | Correct definition. Matches the code's `xS[i] - (q1 - xS[i])^2 / denom` with `denom = q2 - 2*q1 + xS[i]` | confirmed |
| D5 | Theorem: x_k → p, x_k ≠ p, (x_{k+1}−p)/(x_k−p) → A with \|A\| < 1 ⇒ (x̂_k−p)/(x_k−p) → 0 | Writing e_{k+1} = (A+δ_k)e_k gives (x̂_k−p)/e_k = (A+δ_k)(δ_{k+1}−δ_k)/[(A+δ_k)(A+δ_{k+1}) − 2(A+δ_k) + 1], which tends to 0/(A−1)² = 0. Matches Mathews' statement | confirmed |
| D6 | Steffensen as written: q₁, q₂ are two Newton steps from p₀, then p₁ = p₀ − (q₁−p₀)²/(q₂−2q₁+p₀), repeat | This is exactly the loop in all three scripts. It is Mathews' definition (Aitken applied to the Newton fixed-point map) | confirmed |
| D7 | Steffensen gives superlinear, roughly quadratic convergence at double roots | The Newton map g has g′(p) = ½ ≠ 1, so Aitken/Steffensen on g is quadratic. mpmath Case 1 errors 5.7e-2, 2.8e-4, 6.6e-9, 3.6e-18 give e_{k+1}/e_k² ≈ 0.085, 0.083, 0.083. Cases 2 and 3 behave the same way (1.7e-8 → 5.0e-17; 2.8e-8 → 4.4e-16) | confirmed |
| D8 | Each outer step uses two Newton steps (table: "Two Newton evals per step") | Code computes q1 and q2, each with one f and one f′ evaluation | confirmed |
| D9 | Summary table rows (Newton simple: quadratic; Newton double: linear ½; Steffensen double: ≈2) | Consistent with D1 and D7 | confirmed |

### Animations section: introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | Two synchronized panels. Top: Newton tangent steps, one per frame, with x_k in the legend, and Steffensen iterates on the x-axis. Bottom: log₁₀\|x_k − p\| against iteration for both methods | Code (`frame in 0:n_total`, `n_pts = 1 + 2*frame`, legend `Newton x_$(frame)`, red diamonds at y = 0, bottom `plot!` of log errors) and frames: 23 frames, x_0…x_22 in the legends, one Steffensen step added per frame until the sequence stops | confirmed |
| I2 | "Newton's tangent steps become shorter than one pixel of the frame after its first 8, 5 and 4 steps in Cases 1, 2 and 3" | `seg.py`, pixel length of step k. Case 1: step 8 = 1.05 px, step 9 = 0.52 px. Case 2: step 5 = 1.35 px, step 6 = 0.67 px. Case 3: step 4 = 1.83 px, step 5 = 0.89 px | confirmed |
| I3 | Cases 1–3 use the functions of Mathews' Examples 2, 4 and 6, with his starting values for Cases 2 and 3 (p₀ = 1 and 1.5) | Archive formula GIFs: Ex 2 f = x³−3x+2, p = 1, p₀ = 1; Ex 4 f = sin(x²−2)(x²−2), p = √2, p₀ = 1; Ex 6 f = x⁶−7x⁴+15x²−9, p₀ = 1.5 | confirmed |
| I4 | Example 2's p₀ = 1 is the root itself, where f′(1) = 0 and the Newton step is undefined, so Case 1 starts at 2 | f′(1) = 3 − 3 = 0 (sympy) | confirmed. Mathews' solution images are missing, so I could not see which start his worked solution actually used |
| I5 | Examples 1, 3 and 5 (Aitken on the Newton sequence) are not animated | Archive Examples 1, 3 and 5 are those; the page and the script headers say they are not animated | confirmed (disclosed, so not a fidelity finding) |

### Case 1: f(x) = x³ − 3x + 2, p = 1, x₀ = 2.0

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | Heading parameters f, p = 1, x₀ = 2.0 | `aitkenab.jl` lines 13, 16, 17; frame title "f(x) = x³−3x+2 (p = 1)" | confirmed |
| C1.2 | f = (x−1)²(x+2), double root at 1 | sympy factor `(x - 1)**2*(x + 2)`, f′(1) = 0, f″(1) = 6 | confirmed |
| C1.3 | Newton converges linearly with ratio ½ | mpmath ratios 0.5008 (k = 8) → 0.5 (k = 22) | confirmed |
| C1.4 | Steffensen errors 1, 5.7 × 10⁻², 2.8 × 10⁻⁴, 6.6 × 10⁻⁹ in 3 steps | Script: 1.000, 5.747e-2, 2.805e-4, 6.556e-9. mpmath: 1, 5.747e-2, 2.805e-4, 6.557e-9 | confirmed |
| C1.5 | Plain Newton is at 3.1 × 10⁻⁷ after 22 steps | Script 3.115e-7; mpmath 3.115e-7 | confirmed |
| C1.6 | At S₃ the expanded polynomial evaluates to exactly 0, so the Δ² denominator is 0 and the sequence stops | Script `f(S3)=0.000e+00`, `n_done=3`, `stop_reason=Δ² denominator = 0`. f(S₃) = 0 gives q₁ = q₂ = S₃, so the denominator is exactly 0. The true f(S₃) ≈ 3e² ≈ 1.3e-16 is below the rounding error of evaluating the expanded form | confirmed |
| C1.7 | Link and embed point to `aitkenab.jl` and `aitkenab.gif` | index.qmd lines 75, 77 | confirmed |
| C1.8 | Alt text: Newton slow and linear; Steffensen fast, stopping after 3 steps at error 6.6×10⁻⁹ | Last frame: red curve ends at k = 3 at log ≈ −8.18; legend "Steffensen (3 steps; stopped: Δ² denominator = 0)" | confirmed |

### Case 2: f(x) = (x² − 2) sin(x² − 2), p = √2, x₀ = 1.0

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | Heading parameters | `aitkencd.jl` lines 13, 16, 17; frame title matches | confirmed |
| C2.2 | √2 is a double root; Newton is linear | sympy f′(√2) = 0, f″(√2) = 16; Newton ratio → 0.5 | confirmed |
| C2.3 | Error "about 6 × 10⁻¹⁶ after 4 steps (8 Newton steps)" | Script 6.661e-16 | **wrong at the stated precision: should be 6.7e-16 (F1, Minor)** |
| C2.4 | "a few units in the last place of double precision" | 6.661e-16 = 3 · 2⁻⁵² | confirmed |
| C2.5 | Steffensen S₁…S₃ (not given on the page, but drawn) | Script 1.37619087589826683, 1.41390581499436019, 1.41421354560081047. mpmath 1.3761908758982667, 1.4139058149943604, 1.4142135456008103 | confirmed |
| C2.6 | Plain Newton is at 4.7 × 10⁻⁸ after 22 steps | Script 4.727e-8; mpmath 4.727e-8 | confirmed |
| C2.7 | Sequence stops at S₄ because \|f′(S₄)\| < 10⁻¹⁴ | Script `df(S4) = -8.793e-15`, `stop_reason=\|f'(S_4)\| < 1e-14`, `n_done=4` | confirmed |
| C2.8 | Link and embed point to `aitkencd.jl` and `aitkencd.gif` | lines 83, 85 | confirmed |
| C2.9 | Alt text: Steffensen reaches about 6×10⁻¹⁶ after 4 steps | as C2.3 | wrong at the stated precision (F1) |

### Case 3: f(x) = x⁶ − 7x⁴ + 15x² − 9, p = √3, x₀ = 1.5

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C3.1 | Heading parameters | `aitkenef.jl` lines 14, 17, 18; frame title matches | confirmed |
| C3.2 | f = (x²−1)(x²−3)², double root at √3 ≈ 1.732 | sympy factor `(x - 1)*(x + 1)*(x**2 - 3)**2`; f″(√3) = 48. Newton from 1.5 converges to √3 (not to the simple root 1) | confirmed |
| C3.3 | Top-panel tangent steps are shorter than a pixel after the first four | I2 | confirmed |
| C3.4 | Steffensen reaches 2.8 × 10⁻⁸ in 3 steps | Script 2.759e-8; mpmath 2.760e-8 | confirmed |
| C3.5 | Then stalls: near the root f is of order 10⁻¹⁴, comparable to the rounding error of evaluating the polynomial | Script f(S₃) = 2.13e-14, f(S₄) = 7.8e-14, f(S₅) = 7.1e-15. The largest term is 7x⁴ ≈ 63, so rounding error is about 63·eps ≈ 1.4e-14. True f(S₃) ≈ 24e² ≈ 1.8e-14 | confirmed |
| C3.6 | Steps 4–6 give errors 5.4 × 10⁻⁸, 2.1 × 10⁻⁸, 1.5 × 10⁻⁸ | Script 5.442e-8, 2.148e-8, 1.458e-8 | confirmed |
| C3.7 | Plain Newton after 22 steps is at 2.4 × 10⁻⁸ | Script (Float64) 2.402e-8. Exact arithmetic gives 2.237e-8; the Float64 value already contains rounding noise, and the page quotes the computed value | confirmed |
| C3.8 | In exact arithmetic step 4 would reach 4.4 × 10⁻¹⁶ | mpmath S₄ error 4.398e-16 | confirmed |
| C3.9 | Link and embed point to `aitkenef.jl` and `aitkenef.gif` | lines 91, 93 | confirmed |
| C3.10 | Alt text: Steffensen levels off at a few times 10⁻⁸ after 3 steps | Last frame: red curve at about −7.6, −7.3, −7.7, −7.8 for k = 3..6; legend "Steffensen (6 steps)" | confirmed |

### Counts and wiring

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| W1 | Three cases, three scripts, three GIFs, each linked and embedded under its case | Manifest plus the qmd | confirmed |
| W2 | Julia sources linked under each case | lines 75, 83, 91 | confirmed |

---

### 3. Implementation checks

### `aitkenab.jl` (Case 1)

- **Is it the method it claims to be.** Newton is `x - f/df`. Steffensen is two Newton steps followed by the Aitken Δ² update, restarted from the accelerated value. This is Mathews' "Steffensen's acceleration" (Aitken on the Newton map), the variant the Description gives. It is not the derivative-free Steffensen iteration x − f²/(f(x+f) − f), and the page does not claim that it is. f′ = 3x² − 3 is correct (sympy). The only guard is `abs(denom) < 1e-15`. It fires at i = 4 with the denominator exactly 0, and the page and legend report it correctly.
- **Are the numbers right.**

  | k | Steffensen, script (Float64) | Steffensen, mpmath | Newton x_k, script | Newton x_k, mpmath |
  |---|---|---|---|---|
  | 1 | 0.94252873563218365 | 0.94252873563218391 | 1.55555555555555558 | 1.5555555555555556 |
  | 2 | 0.99971951186750685 | 0.99971951186750876 | 1.29790660225442833 | 1.2979066022544283 |
  | 3 | 0.99999999344396751 | 0.99999999344325434 | — | — |
  | 22 | — | — | 1.00000031148366797 | 1.0000003114860721 |

  The scripts agree with mpmath to rounding level (the differences of 1e-12 to 1e-15 come from cancellation in f near the double root). The Steffensen errors shrink quadratically (constant ≈ 0.083).
- **Reference values.** `root = 1.0` is exact (sympy factor).
- **Does the picture show what was computed.** The tangent path is built from (x_k, 0) → (x_k, f(x_k)) → (x_{k+1}, 0), which is correct. The legend's `Newton x_$(frame) = xN[frame+1]` shows the right index; the last frame shows "x_22 = 1.0000003115", which matches. The Steffensen diamonds sit at S₀..S_nS. The annotation "S_3=0.9999999934" matches. The bottom panel limits (−17, 1) contain every point. The clamp at 1e-16 never applies (smallest error 6.6e-9). The top-panel window shows the start of the Newton run and every Steffensen iterate.

### `aitkencd.jl` (Case 2)

- **Is it the method it claims to be.** Same structure as Case 1, with f′ guards. f′ = 2x(sin(x²−2) + (x²−2)cos(x²−2)) is correct; sympy differentiates f to the same expression. The Newton f′ guard never fires within 22 steps; in Float64 it would first fire at k = 49. The Steffensen guard fires at i = 5 because |f′(S₄)| = 8.79e-15 < 1e-14, which is the reason the legend and the page give.
- **Are the numbers right.**

  | k | Steffensen, script | Steffensen, mpmath | error, script | error, mpmath |
  |---|---|---|---|---|
  | 1 | 1.37619087589826683 | 1.3761908758982667 | 3.802e-2 | 3.802e-2 |
  | 2 | 1.41390581499436019 | 1.4139058149943604 | 3.077e-4 | 3.077e-4 |
  | 3 | 1.41421354560081047 | 1.4142135456008103 | 1.677e-8 | 1.677e-8 |
  | 4 | 1.41421356237309448 | 1.414213562373095… | 6.661e-16 | 4.973e-17 |

  Newton x₂₂: script 1.41421351510093896, mpmath 1.4142135151009391 (error 4.727e-8 in both).
- **Reference values.** `root = sqrt(2.0)` is the correctly rounded √2; f′(√2) = 0 and f″(√2) = 16 (sympy).
- **Does the picture show what was computed.** The geometry is correct, the legend shows "x_22 = 1.4142135151", and the annotation "S_4=1.4142135624" is correct. The final Steffensen point at log₁₀(6.66e-16) = −15.18 is inside the limits. The clamp never applies.

### `aitkenef.jl` (Case 3)

- **Is it the method it claims to be.** Same structure as Case 2. f′ = 6x⁵ − 28x³ + 30x is correct (sympy). No guard fires (`n_done=6`, `stop_reason` empty), which matches the script comment on line 39 and the legend "Steffensen (6 steps)".
- **Are the numbers right.**

  | k | Steffensen, script | Steffensen, mpmath | error, script | error, mpmath |
  |---|---|---|---|---|
  | 1 | 1.71262653575958024 | 1.7126265357595755 | 1.942e-2 | 1.942e-2 |
  | 2 | 1.73183217723267924 | 1.7318321772326914 | 2.186e-4 | 2.186e-4 |
  | 3 | 1.73205077997662271 | 1.7320507799704626 | 2.759e-8 | 2.760e-8 |
  | 4 | 1.73205075314728441 | 1.7320508075688769 | 5.442e-8 | 4.398e-16 |
  | 5 | 1.73205082904592045 | √3 (to 1e-31) | 2.148e-8 | 1.1e-31 |
  | 6 | 1.73205082215345740 | √3 | 1.458e-8 | 3.9e-50 |

  The scripts match exact arithmetic through step 3. From step 4 on, the Float64 sequence is dominated by rounding error in evaluating the expanded polynomial. That is a genuine Float64 effect, and the page describes it accurately and gives the exact-arithmetic value. Newton x₂₂: script 1.73205078354624931 (error 2.402e-8); mpmath 1.7320507852017416 (error 2.237e-8). The Float64 Newton has already drifted at the rounding level, and the page quotes the Float64 value it plots.
- **Reference values.** `root = sqrt(3.0)` is correct; f′(√3) = 0 and f″(√3) = 48.
- **Does the picture show what was computed.** The geometry is correct. The legend shows "x_22 = 1.7320507835" and the annotation shows "S_6=1.7320508222", both matching the script values. The plateau in the bottom panel matches C3.6. The clamp never applies. The top window [0.6, 2.6] × [−2.5, 4.5] includes x₀, the root and every Steffensen iterate.

### Not determined

- Which starting value Mathews' own Example 2 solution used, and his worked iterate tables for Examples 2, 4 and 6: the solution-page images (gr_61 onward) are not in the archive. The page explains its departure for Case 1 (p₀ = 1 is the root, so f′(p₀) = 0), and that reason is mathematically correct.

