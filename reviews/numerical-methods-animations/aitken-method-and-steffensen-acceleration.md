# Aitken's Method & Steffensen's Acceleration — animation review

Page: [`pages/numerical-methods/aitken-method-and-steffensen-acceleration/index.qmd`](../../pages/numerical-methods/aitken-method-and-steffensen-acceleration/index.qmd) · Scripts: `aitkenab.jl`, `aitkencd.jl`, `aitkenef.jl` · GIFs: 3

**Result:** 1 error, 1 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Case 1: Steffensen does not reach machine precision; it stalls at 6.6e-9

- **Location:** index.qmd:64, "Steffensen's $\Delta^2$ acceleration restores superlinear convergence, reaching machine precision in a handful of steps."
- **Now:** The page says Steffensen reaches machine precision. In the GIF (aitkenab, frames 4–23) the red curve drops to log₁₀|x−1| = −8.18 at step 3 and then stays flat for steps 4–7.
- **True:** The script's Steffensen iterates are S₃ = S₄ = … = S₇ = 0.99999999344396751, so the error is 6.556e-9 at every one of those steps. The cause is rounding in the expanded polynomial. At x = 1 − 6.6e-9, `x^3 - 3x + 2` evaluates to exactly 0.0 (the true value is 1.29e-16). That makes q1 = q2 = x and the Aitken denominator 0, so the guard at aitkenab.jl:39–40 copies S₃ into every remaining step. Steps 4–7 are therefore never computed. They are still drawn as four diamonds, and the legend counts them as "Steffensen (7 steps)". In exact arithmetic the method keeps converging: S₄ error = 3.58e-18 and S₅ error = 1.07e-36. The best accuracy a double-root solve can reach with this expanded f in double precision is about √eps ≈ 1e-8. Newton itself bottoms out at 1.5e-9 (k = 28).
- **Evidence:** `julia aitkenab_print.jl` gives S errors 1.0, 5.747e-2, 2.805e-4, 6.556e-9, 6.556e-9, 6.556e-9, 6.556e-9, 6.556e-9 (plotted log₁₀ −8.1834 for n = 3..7). `python3 independent.py` gives exact errors 6.557e-9 → 3.58e-18 → 1.07e-36, and its own double-precision loop reports "denom=0.0 at step 4, f(a)=0.0", the same stall. `julia factored_check.jl` shows that with f = (x−1)²(x+2) and f′ = 3(x−1)(x+1) the Float64 errors are 1, 5.75e-2, 2.80e-4, 6.56e-9, 0, 0, 0, 0. `julia newton_long.jl` gives "case1: smallest Newton error … 1.52e-09".
- **Suggested fix:** Pick one of two:
  - Fix the text: "...restores superlinear convergence: about 8 correct digits after 3 steps (error 6.6e-9). Beyond that, f(x) = x³−3x+2 can no longer be evaluated accurately near the double root in double precision, so the iteration stalls at about 10⁻⁸."
  - Fix the script: evaluate f and f′ in factored form, `f(x) = (x-1)^2*(x+2)`, `df(x) = 3(x-1)*(x+1)`. Then also add the `df == 0` / `f == 0` guard that aitkencd/aitkenef have, because x lands exactly on 1.0 and the Newton steps would otherwise give 0/0 = NaN. In either case, stop drawing guard-filled repeats as Steffensen steps, or say that they are repeats.

- **Independent check:** confirmed.

### F2 — Misleading — Page match — Case 3: Steffensen stalls near 1e-8 and its error goes back up; the page says it "converges in only a few steps"

- **Location:** index.qmd:80, "Steffensen converges in only a few Aitken-accelerated steps."
- **Now:** The page implies that Steffensen converges to the root within a few steps.
- **True:** The script's Steffensen errors are 2.32e-1, 1.94e-2, 2.19e-4, 2.76e-8, 5.44e-8, 2.15e-8, 1.46e-8. Progress stops after step 3, and the error rises at step 4. The GIF shows this as a wobble at log₁₀ ≈ −7.3 to −7.8 (frames 5–23). After 6 Steffensen steps, which cost 12 Newton steps, the error of 1.46e-8 is about the same as plain Newton's at k = 21 (4.4e-8) and k = 22 (2.4e-8). Exact arithmetic gives 2.76e-8 → 4.40e-16 → 1.12e-31, so the stall is a rounding floor of the expanded polynomial x⁶−7x⁴+15x²−9 near its double root, not a property of the method. A reader would take the plateau to be how Steffensen behaves.
- **Evidence:** `julia aitkenef_print.jl` (S lines). `python3 independent.py` gives exact Steffensen errors of 2.760e-8, 4.398e-16, 1.116e-31, 7.2e-63. The independent double loop gives 2.760e-8, 5.268e-8, 3.499e-9, 2.243e-8, which is noisy and differs from the script beyond step 3, as rounding noise would. `julia factored_check.jl` with f = (x²−1)(x²−3)² and f′ = 2x(x²−3)(3x²−5) gives Float64 errors 2.32e-1, 1.94e-2, 2.19e-4, 2.76e-8, 2.22e-16, 0, 0.
- **Suggested fix:** Either reword it as "Steffensen gains about 8 digits in 3 steps and then stalls near 10⁻⁸, the attainable accuracy for this double root when f is evaluated in expanded form in double precision", or evaluate f and f′ in factored form in aitkenef.jl (lines 13–14) so that the plot shows the quadratic convergence the page describes.

- **Independent check:** confirmed.

### F3 — Minor — Page match — Newton at a double root does not need "hundreds" of iterations and cannot reach machine precision in double precision

- **Location:** index.qmd:20, "each Newton step only halves the error — hundreds of iterations may be needed to reach machine precision."
- **Now:** "hundreds of iterations".
- **True:** Halving the error from O(1) down to 1e-16 takes log(1e-16)/log(0.5) ≈ 53 steps, so the number is about 50, not hundreds. Also, with the expanded polynomials of Cases 1 and 3, Newton never reaches machine precision. Its best errors are 1.5e-9 (k = 28) and 2.6e-10 (k = 25). Only Case 2 gets there, at 2.2e-16 by k = 50.
- **Evidence:** `julia newton_long.jl`: "case1: smallest … 1.52e-09 at k=28", "case2: … 2.22e-16 at k=50", "case3: … 2.55e-10 at k=25", "halvings from 1 to 1e-16: 53.2".
- **Suggested fix:** "...each Newton step only halves the error, so about 50 iterations would be needed to go from an O(1) error to 10⁻¹⁶. In practice, rounding in f near a double root usually stops progress at around 10⁻⁸."

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Page match — Case 2 wording suggests Δ² is applied to the plotted Newton iterates

- **Location:** index.qmd:72, "Steffensen's acceleration applied to the Newton iterates recovers rapid convergence".
- **Now:** The wording reads as though the red sequence is Aitken Δ² applied to the blue Newton sequence.
- **True:** All three scripts run Steffensen. Each outer step takes two Newton steps from the current accelerated value, applies Aitken's formula, and restarts there (aitkencd.jl:39–49). This is not Δ² applied to the sequence {x_k} in the plot. The difference matters here. Plain Δ² applied to this case's Newton sequence gives errors 3.8e-2, 3.2e-3, 6.0e-4, 1.3e-4, 3.0e-5, 7.1e-6, which is still linear with ratio ≈ 0.23. Steffensen gives 3.8e-2, 3.1e-4, 1.7e-8, 6.7e-16. The restart is what produces the rapid convergence.
- **Evidence:** `python3 independent.py`, "Aitken D2 of Newton sequence (exact)" line for aitkencd versus the "Steffensen exact" lines.
- **Suggested fix:** "Steffensen's method (Aitken's formula applied to two Newton steps, restarted from each accelerated value) recovers rapid convergence...".

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `aitkenab.jl` | yes | 4.8 | aitkenab.gif |
| `aitkencd.jl` | yes | 4.7 | aitkencd.gif |
| `aitkenef.jl` | yes | 4.7 | aitkenef.gif |

Committed GIFs byte-identical to their regenerated output: **3 of 3**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 14 | Newton "converges *quadratically* at simple roots" | theory_check.py: Newton-map ratio → 0 for m=1 (standard quadratic result) | confirmed |
| 2 | 14–17 | at a multiple root of order m, error ratio → (m−1)/m | theory_check.py: limits 1/2, 2/3, 3/4 for m=2,3,4 | confirmed |
| 3 | 20 | double root: ratio ½, "each Newton step only halves the error" | script ratios → 0.500000 in all three cases | confirmed |
| 4 | 20 | "hundreds of iterations may be needed to reach machine precision" | ≈53 halvings; Cases 1, 3 floor at ~1e-9 | wrong (→ F3) |
| 5 | 24–28 | Δ² definition and formula x̂_k = x_k − (Δx_k)²/Δ²x_k | standard; same formula as script line 42 / 48 | confirmed |
| 6 | 30–36 | Aitken theorem: (x̂_k−p)/(x_k−p) → 0 for linearly convergent sequence | standard theorem (with linear convergence meaning a limiting ratio \|A\|<1); independent.py: Δ² errors fall ~4× per step vs Newton's 2×, ratio → 0 | confirmed |
| 7 | 40 | Steffensen = Aitken Δ² applied to the Newton iteration, superlinear at double roots | scripts implement exactly this (variant: Steffensen acceleration of fixed-point map g(x)=x−f/f′, not the derivative-free Steffensen root finder); exact errors quadratic (e.g. 2.76e-8→4.40e-16→1.12e-31) | confirmed |
| 8 | 42–44 | steps q₁, q₂ Newton; p₁ = p₀ − (q₁−p₀)²/(q₂−2q₁+p₀); restart | aitkenab.jl:36–42, aitkencd.jl:42–48, aitkenef.jl:43–49 match | confirmed |
| 9 | 46 | two Newton steps per outer iteration; "restores roughly quadratic convergence" | code; exact e_{n+1}/e_n² ≈ 0.58 constant (Case 3) | confirmed (exact arithmetic; the GIFs show it only for 3 steps in Cases 1 and 3, see F1/F2) |
| 10 | 50–54 | table: Newton simple quadratic; Newton double linear ½; Steffensen double ≈2, two Newton evals/step | as above | confirmed |
| 11 | 58 | two synchronized panels; top = Newton tangent geometry one step per frame | frames; path built (x_i,0)→(x_i,f(x_i))→(x_{i+1},0), slope = f′(x_i); legend x_k matches frame k | confirmed |
| 12 | 58 | bottom = log₁₀\|x_k−p\| vs iteration for Newton and Steffensen | code lines 98–101 etc.; values match printed errors | confirmed |
| 13 | 58 | both panels share the same frame clock | nS = min(frame, n_steff), Newton index = frame | confirmed |
| 14 | 60 | Julia sources linked under each case | lines 66, 74, 82 | confirmed |
| 15 | 62 | Case 1: f = x³−3x+2, double root p=1, x₀=2.0 | aitkenab.jl:12,15,16; sympy factor (x−1)²(x+2), f″(1)=6≠0 | confirmed |
| 16 | 64 | Newton converges linearly (slowly) to p=1 of f=(x−1)²(x+2) | ratios 0.556→0.500; err 3.1e-7 at k=22 | confirmed |
| 17 | 64 | asymptotic error ratio ½ | 0.500012 at k=22 | confirmed |
| 18 | 64 | Steffensen restores superlinear convergence | errors 1, 5.7e-2, 2.8e-4, 6.6e-9 | confirmed (for steps 0–3) |
| 19 | 64 | "reaching machine precision in a handful of steps" | stalls at 6.556e-9 for steps 3–7 | wrong (→ F1) |
| 20 | 66, 68 | link aitkenab.jl / embed aitkenab.gif are Case 1 | manifest: aitkenab.gif produced by aitkenab.jl, byte-identical; title/params match | confirmed |
| 21 | 68 | alt text: Newton tangent steps from x₀=2 to p=1; Newton slow linear vs Steffensen fast | frames 1, 3, 5, 23 | confirmed |
| 22 | 70 | Case 2: f=(x²−2)sin(x²−2), double root p=√2, x₀=1.0 | aitkencd.jl:12,15,16; f(√2)=f′(√2)=0, f″(√2)=16 | confirmed |
| 23 | 72 | double root causes Newton to converge linearly | ratios → 0.500000; err 4.73e-8 at k=22 | confirmed |
| 24 | 72 | "Steffensen's acceleration applied to the Newton iterates" | the script restarts (Steffensen); it does not apply Δ² to the plotted sequence | wrong wording (→ F4) |
| 25 | 72 | "dropping to machine precision far sooner" | S₄ err 6.66e-16 (3 ulp; exact S₄ err 4.97e-17) at step 4 vs Newton 4.7e-8 at k=22 | confirmed |
| 26 | 74, 76 | link/embed aitkencd are Case 2 | manifest; title/params | confirmed |
| 27 | 76 | alt text Case 2 | frames 1, 6, 23 | confirmed |
| 28 | 78 | Case 3: f=x⁶−7x⁴+15x²−9, double root p=√3, x₀=1.5 | aitkenef.jl:13,16,17 | confirmed |
| 29 | 80 | f=(x²−1)(x²−3)², double root at √3≈1.732 | sympy factor (x−1)(x+1)(x²−3)²; f″(√3)=48 | confirmed |
| 30 | 80 | Newton's linear crawl visible in tangent panel and gently sloping error curve | ratios → 0.5; blue curve slope ≈ −0.3 decades/step in frames | confirmed |
| 31 | 80 | "Steffensen converges in only a few Aitken-accelerated steps" | errors 2.8e-8, 5.4e-8, 2.1e-8, 1.5e-8 after step 3 (no further convergence, non-monotone) | wrong / misleading (→ F2) |
| 32 | 82, 84 | link/embed aitkenef are Case 3 | manifest; title/params | confirmed |
| 33 | 84 | alt text Case 3 | frames 1, 5, 23 | confirmed |

## Implementation checks

### aitkenab.jl
- **Method:** Newton for 22 iterations (lines 25–29). "Steffensen" for 7 outer steps (lines 32–43): two Newton steps from xS[i], then Aitken's formula, then a restart at the accelerated value. This is Steffensen acceleration of the Newton fixed-point map g(x) = x − f/f′, and it is exactly the algorithm in the page's Description (lines 42–44). It is not plain Aitken Δ² of the Newton sequence, and it is not the derivative-free Steffensen root finder x − f²/(f(x+f)−f). The page describes the same variant it runs, so there is no mismatch at the level of the Description. The variant is the legitimate one found in textbooks (Steffensen applied to a fixed-point iteration). There is no df == 0 guard, which does not matter with the current f, but see the F1 fix. The denominator guard fills the remaining steps with copies (lines 39–40), and those copies are drawn as steps (F1).
- **Numbers (script | independent exact, 120 digits):**
  - Newton x₁ 1.5555555555555556 | 1.5555555555555556; x₄ 1.0795622104143607 | 1.0795622104143609; x₁₀ err 1.275305e-3 | 1.275305e-3; x₂₂ err 3.114837e-7 | 3.114861e-7 (rounding drift only); ratio at k=22 0.500012 | 0.500000.
  - Steffensen S₁ 0.94252873563218365 | 0.94252873563218391; S₂ 0.99971951186750685 | …876; S₃ err 6.556032e-9 | 6.556746e-9; S₄ err 6.556032e-9 (frozen) | 3.58e-18; S₅ 6.556e-9 | 1.07e-36.
  - f′ = 3x²−3 agrees with sympy.
- **Reference values:** root = 1.0 is exact, since sympy factors f as (x−1)²(x+2).
- **Picture:** I looked at the contact sheet and at full-size frame 23, and checked the tangent path construction, the legend "Newton x_k" (x_2 = 1.297907 and x_4 = 1.079562 match the printed values), the S_n annotation, and the bottom-panel values against the printed log errors (−1.2405, −3.5521, −8.1834). The 1e-16 clamp is never reached. "Newton x_22 = 1.0" is correct rounding of 1.0000003 to 6 digits. The plateau at −8.18 is the problem described in F1.

### aitkencd.jl
- **Method:** The same Newton and Steffensen structure (lines 25–49), with derivative guards. f′ = 2x(sin u + u cos u) with u = x²−2 agrees with the sympy derivative.
- **Numbers (script | independent exact):**
  - Newton x₁ 1.3044895246152155 | same; x₄ 1.4017074304239319 | same; x₂₂ err 4.727216e-8 | 4.727216e-8; ratio 0.500000 | 0.500000.
  - Steffensen errors 4.142e-1, 3.802e-2, 3.077e-4, 1.677e-8, 6.66e-16, 6.66e-16 | 4.142e-1, 3.802e-2, 3.077e-4, 1.677e-8, 4.97e-17, 4.4e-34.
  - The script's S₄ = 1.4142135623730945 is 3 ulp from Float64 √2, which is effectively machine precision. This case reaches it because f = u·sin u and f′ share the computed u, so f/f′ stays accurate.
- **Reference values:** root = √2. sympy gives f(√2) = f′(√2) = 0 and f″(√2) = 16, so it is a double root. f also has a simple root at √(2+π) ≈ 2.2675 inside the plot window, which Newton never approaches. That is harmless.
- **Picture:** I looked at the contact sheet and frames 1 and 23 and checked the legend values (x_2 = 1.362525, x_4 = 1.401707) and the S_n labels (1.41421). The title is cropped at the right edge ("(p = √2)" is cut off). This is cosmetic, since p also appears in the y-axis label, so I did not record it as a finding.

### aitkenef.jl
- **Method:** The same structure as aitkencd. f′ = 6x⁵−28x³+30x agrees with sympy. Expanding (x²−1)(x²−3)² by hand and with sympy confirms the polynomial.
- **Numbers (script | independent exact):**
  - Newton x₁ 1.6785714285714286 | same; x₄ 1.7261058449618949 | 1.7261058449618952; x₂₂ err 2.402e-8 | 2.237e-8, where rounding noise has set in and the step ratio becomes 0.544.
  - Steffensen errors 2.321e-1, 1.942e-2, 2.186e-4, 2.759e-8, 5.442e-8, 2.148e-8, 1.458e-8 | 2.321e-1, 1.942e-2, 2.186e-4, 2.760e-8, 4.40e-16, 1.12e-31, 7.2e-63. An independent double loop also stalls, with noisy values (5.27e-8, 3.50e-9, 2.24e-8). Steps 0–3 agree; after that both are rounding noise (F2).
- **Reference values:** root = √3. sympy gives f(√3) = f′(√3) = 0 and f″(√3) = 48. x₀ = 1.5 lies between the local maximum at √(5/3) ≈ 1.291 and √3, so Newton approaches from the left, monotonically, as drawn.
- **Picture:** I looked at the contact sheet and full-size frame 5 (it shows the error rising at step 4), checked the legend x_2 = 1.707172 and x_4 = 1.726106 against the printed values, and checked the S_n label 1.73205. The title is cropped at the right edge, which is cosmetic.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/aitken-method-and-steffensen-acceleration/`](evidence/aitken-method-and-steffensen-acceleration/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
