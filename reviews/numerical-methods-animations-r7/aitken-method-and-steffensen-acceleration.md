# Aitken's Method & Steffensen's Acceleration — animation review (round 7)

Page: `pages/numerical-methods/aitken-method-and-steffensen-acceleration/`. Reported findings: **0 Error, 1 Misleading, 2 Minor**.

## Findings

### F1. Page match, **Misleading**: Case 1 presents 6.6e-9 as a double-precision limit

- **Location:** `index.qmd` line 73: "It cannot go further in double precision: at $S_3$ the expanded polynomial $x^3 - 3x + 2$ evaluates to exactly 0, so the $\Delta^2$ denominator is 0 and the animation stops the Steffensen sequence there."
- **What is there:** The mechanism is correct. `f(S_3)` is exactly 0 in Float64, so `q1 = q2 = S_3` and the denominator is 0.
- **What is true instead:** The stop belongs to this iteration on this expanded form, and 6.6e-9 is not a floor of double precision for this root. Two runs in the same Float64 arithmetic go further:
  - Steffensen on the **factored** form `(x-1)^2 (x+2)` has errors `1, 5.75e-2, 2.80e-4, 6.56e-9, 0`. It takes a fourth step and lands on the root exactly.
  - Plain **Newton on the same expanded polynomial** reaches 1.52e-9 at step 28, which is 4.3 times closer than Steffensen's stopping point. The page's own line 20 quotes this value.
- **How I know:** `julia $R/inst/checks.jl` (control block) and `julia $R/inst/aitkenab.inst.jl` (`NewtonExt: stop at k=28 ... err=1.521e-09`; `S 3 ... err 6.556e-09, f = 0`).
- **Suggested correction:** "The sequence cannot continue from $S_3$: there the expanded polynomial $x^3 - 3x + 2$ rounds to exactly 0, so the $\Delta^2$ denominator is 0 and the animation stops. This is a limit of evaluating the expanded form, not of double precision: the factored form $(x-1)^2(x+2)$ takes a fourth step to the root."

- **Independent check:** confirmed.

### F2. Page match, **Minor**: the "Convergence order" column gives a rate as if it were an order

- **Location:** `index.qmd` lines 56 to 60, row "Newton–Raphson | Double ($m=2$) | Linear ($\tfrac{1}{2}$)".
- **What is there:** The parenthesis holds the order in the other two rows (`Quadratic (≈2)`, `Superlinear (≈2)`), so the parallel form reads as order 1/2.
- **What is true instead:** Newton at a double root has order **1** with asymptotic error **ratio** 1/2.
- **How I know:** `julia $R/inst/tails.jl` gives `e[end]/e[end-1] = 0.500000` for m = 2. `$R/inst/aitkenab.inst.jl` shows a constant ratio of 0.5000 in Case 1, which is order 1.
- **Suggested correction:** `Linear (order 1, ratio $\tfrac{1}{2}$)`. Steffensen's entry could also read `Quadratic (2)`: `$R/exact.py` gives $e_{k+1}/e_k^2 \to 0.08333,\ 0.17678,\ 0.57735$, so the order is exactly 2 in all three cases.

- **Independent check:** not run (Minor finding, unverified)

### F3. Page match, **Minor**: "far more accurate than either step alone" is stated for every outer iteration

- **Location:** `index.qmd` line 52: "Each outer iteration consumes **two Newton steps** but produces a correction that is far more accurate than either step alone."
- **What is true instead:** This holds near the root in exact arithmetic but fails on the page's own cases. The factor below is (better Newton-substep error) / (Steffensen error), so a value under 1 means Steffensen is worse:

| Outer step | Case 1 | Case 2 | Case 3 |
|---|---|---|---|
| 1 | 5.18 | **1.36** | **1.28** |
| 2 | 50.5 | 30.2 | 21.5 |
| 3 | 10695 | 4586 | 1980 |
| 4 | | 7.4e6 | **0.21** |
| 5 | | | **0.30** |
| 6 | | | **1.00** (`S_6 = q_1`, because `f(q_1) = 0`) |

- **How I know:** `julia $R/inst/outer.jl`.
- **Suggested correction:** "...but, once the iterates are near the root and rounding is not dominant, produces a correction far more accurate than either step alone."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `aitkenab.jl` | 0 | 14.3 | aitkenab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkencd.jl` | 0 | 10.9 | aitkencd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkenef.jl` | 0 | 9.4 | aitkenef.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: **confirmed**, **wrong**, **could not determine**. F-numbers mark entries that carry a finding.

### Description

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 1 | 14 | Newton is quadratic at simple roots | confirmed | m=1: log-error ratio 2.003, 2.006 |
| 2 | 14-18 | At a root of order m, error ratio tends to (m-1)/m | confirmed | m=2,3,4: 0.500000, 0.666667, 0.750000 (3000-bit) |
| 3 | 20 | Double root: ratio 1/2 | confirmed | 0.5000 in all three cases |
| 4 | 20 | About 50 iterations from order 1 to 1e-16; 2^-53 ≈ 1.1e-16 | confirmed | log2(1e16) = 53.15; 2^-53 = 1.110e-16 |
| 5 | 20 | Case 1: f is exactly 0 after 28 Newton steps, error 1.5e-9 | confirmed | k=28, 1.521e-9 |
| 6 | 20 | Case 3: f is exactly 0 after 25 Newton steps, error 2.6e-10 | confirmed | k=25, 2.554e-10 |
| 7 | 24-28 | Definitions of Δ, Δ² and the Aitken formula | confirmed | Matches code; a geometric sequence gives the limit to 2.6e-77 |
| 8 | 30-40 | Aitken theorem: hat-error / error tends to 0 | confirmed | On all three Newton sequences, ratio falls to about 1e-12 at k=35; the algebra also holds for any \|A\| < 1 |
| 9 | 46 | Steffensen applies Δ² to the Newton iteration | confirmed | Scripts and Mathews both use this variant |
| 10 | 46 | Superlinear at double roots | confirmed | Order → 2 (400-digit run) |
| 11 | 48-50 | Algorithm steps 1 to 3 | confirmed | Script lines 42 to 48 match exactly |
| 12 | 52 | Each outer iteration uses two Newton steps | confirmed | Two f and two f' evaluations per step |
| 13 | 52 | Each outer iteration is far more accurate than either step | **wrong as a universal (F3)** | Table in F3 |
| 14 | 52 | Restores roughly quadratic convergence | confirmed | e_{k+1}/e_k² converges |
| 15 | 58 | Table: Newton, simple root, quadratic | confirmed | As 1 |
| 16 | 59 | Table: Newton, double root, "Linear (1/2)" as an order | **misleading form (F2)** | Order 1, ratio 1/2 |
| 17 | 60 | Table: Steffensen, double root, about 2; two Newton evals | confirmed | As 10 and 12 |

### Animations introduction

| # | Line | Claim | Verdict | Evidence |
|---|---|---|---|---|
| 18 | 64 | Two synchronized panels | confirmed | Frames; `layout=(2,1)` |
| 19 | 64 | Top: Newton tangent steps, one per frame | confirmed | `n_pts = 1 + 2*frame`; frames 0 to 22 |
| 20 | 64 | Current iterate x_k printed in legend | confirmed | e.g. `x_22 = 1.0000003115`, matches script |
| 21 | 64 | Steffensen iterates marked on the x-axis | confirmed | Red diamonds at y = 0 |
| 22 | 64 | Bottom: log10\|x_k - p\| vs iteration for both | confirmed | Plot code and frames; the 1e-16 clamp never activates (smallest error 6.7e-16) |
| 23 | 64 | Steps are under one pixel after the first 8, 5, 4 | confirmed | Horizontal px: Case 1 step 8 = 1.05, step 9 = 0.53; Case 2 step 5 = 1.34, step 6 = 0.66; Case 3 step 4 = 1.83, step 5 = 0.90. Box width 599, 596, 599 px |
| 24 | 66 | Source scripts are linked under each case | confirmed | Lines 75, 83, 91 |
| 25 | 68 | Cases use the functions of Mathews Examples 2, 4, 6 | confirmed | `gr_59`, `gr_139`, `gr_218` |
| 26 | 68 | Mathews' starting values for Cases 2 and 3 | confirmed | `gr_140` p0 = 1; `gr_219` p0 = 1.5 |
| 27 | 68 | Example 2's stated p0 = 1 is the root, where f'(1) = 0 | confirmed | `gr_60` p0 = 1; f(1) = f'(1) = 0 |
| 28 | 69 | Examples 1, 3, 5 apply Δ² to Newton for the same functions and are not animated | confirmed | `gr_34`, `gr_114`, `gr_194`; statement text; no such case on the page |

### Case 1 (`aitkenab`)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 29 | f = x³-3x+2 = (x-1)²(x+2), double root 1, x0 = 2 | confirmed | Expansion; f(1) = f'(1) = 0, f''(1) = 6; script lines 13 to 17 |
| 30 | Newton is linear, ratio 1/2 | confirmed | 0.5000 from k = 13 |
| 31 | Steffensen errors 1, 5.7e-2, 2.8e-4, 6.6e-9 | confirmed | 1, 5.747e-2, 2.805e-4, 6.556e-9 (script); 400-digit 5.747e-2, 2.805e-4, 6.557e-9 |
| 32 | Newton 3.1e-7 after 22 steps | confirmed | 3.115e-7 in both |
| 33 | f(S_3) is exactly 0, denominator is 0, sequence stops | confirmed | `f = 0, denom = 0` |
| 34 | "It cannot go further in double precision" | **misleading (F1)** | Factored form reaches 0; Newton reaches 1.5e-9 |
| 35 | Alt text: from x0 = 2; slow Newton; Steffensen stops after 3 steps at 6.6e-9 | confirmed | Frames |
| 36 | Wiring: `aitkenab.jl`, `aitkenab.gif` | confirmed | Lines 75, 77; GIF byte-identical to regenerated output |

### Case 2 (`aitkencd`)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 37 | f = (x²-2)sin(x²-2), double root √2, x0 = 1 | confirmed | f''(√2) = 16; script lines 13 to 17 |
| 38 | Newton is linear | confirmed | 0.5000 from k = 11 |
| 39 | Steffensen is Aitken on two Newton steps, restarted | confirmed | `aitkencd.jl` lines 45 to 60 |
| 40 | Error 6.7e-16 after 4 steps (8 Newton steps) | confirmed | 6.661e-16 at S_4 |
| 41 | Three units in the last place | confirmed | 6.661e-16 / 2.220e-16 = 3.00 |
| 42 | Newton 4.7e-8 after 22 | confirmed | 4.727e-8 in both |
| 43 | Errors are measured from the double-precision √2 | confirmed | `root = sqrt(2.0)` |
| 44 | From the exact √2 the final error is 5.7e-16 | confirmed | 5.695e-16 |
| 45 | Stops at S_4 because \|f'(S_4)\| < 1e-14 | confirmed | \|f'(S_4)\| = 8.793e-15; legend states it |
| 46 | Alt text numbers | confirmed | As 40 and 44 |
| 47 | Wiring: `aitkencd.jl`, `aitkencd.gif` | confirmed | Lines 83, 85; byte-identical |

### Case 3 (`aitkenef`)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 48 | f = x⁶-7x⁴+15x²-9 = (x²-1)(x²-3)², double root √3 ≈ 1.732, x0 = 1.5 | confirmed | Expansion; f''(√3) = 48 |
| 49 | Tangent steps under a pixel after the first four | confirmed | As 23 |
| 50 | Steffensen error 2.8e-8 in 3 steps | confirmed | 2.759e-8 (script); 2.76e-8 (400-digit) |
| 51 | Values of order 1e-14, comparable to rounding error | confirmed | Exact f at S_3..S_6: 1.83e-14, 7.11e-14, 1.11e-14, 5.11e-15; rounding error 3.0e-15 to 7.1e-15 |
| 52 | Steps 4 to 6: 5.4e-8, 2.1e-8, 1.5e-8 | confirmed | 5.442e-8, 2.148e-8, 1.458e-8 |
| 53 | About where Newton is after 22 steps (2.4e-8) | confirmed | 2.402e-8 in Float64 (exact-arithmetic Newton 2.237e-8) |
| 54 | Exact-arithmetic step 4 reaches 4.4e-16 | confirmed | 4.398e-16 |
| 55 | Alt text: levels off at a few times 1e-8 after 3 steps | confirmed | Range 1.5e-8 to 5.4e-8 |
| 56 | Wiring: `aitkenef.jl`, `aitkenef.gif` | confirmed | Lines 91, 93; byte-identical |

No entry is "could not determine". The one comparison that could not be made is against Mathews' worked iterates, whose images are absent. The page makes no claim about them.

---

### 3. Implementation checks

### Method (all scripts)
Each script runs Newton, and **Steffensen's acceleration of the Newton fixed-point map** $g(x) = x - f/f'$: two g-steps, then Aitken, restarted from the result. This is the variant the page describes and the one in Mathews' module. It is not the derivative-free iteration $x - f^2/(f(x+f)-f)$, and the page does not claim it is. The f' in each script agrees with a BigFloat centred difference (residuals 3.6e-47, 1.6e-48, 1.4e-46).

### Numbers: script against independent 400-digit computation

| Quantity | Case 1 script / exact | Case 2 script / exact | Case 3 script / exact |
|---|---|---|---|
| Newton error, k = 22 | 3.115e-7 / 3.115e-7 | 4.727e-8 / 4.727e-8 | 2.402e-8 / 2.237e-8 (rounding, see below) |
| S_1 error | 5.747e-2 / 5.747e-2 | 3.802e-2 / 3.802e-2 | 1.942e-2 / 1.942e-2 |
| S_2 error | 2.805e-4 / 2.805e-4 | 3.077e-4 / 3.077e-4 | 2.186e-4 / 2.186e-4 |
| S_3 error | 6.556e-9 / 6.557e-9 | 1.677e-8 / 1.677e-8 | 2.759e-8 / 2.760e-8 |
| S_4 error | stopped / 3.583e-18 | 6.661e-16 / 4.973e-17 | 5.442e-8 / 4.398e-16 |
| Asymptotic e_{k+1}/e_k² | 0.08333 | 0.17678 | 0.57735 |

A separately written Float64 Steffensen (`checks.jl`) reproduces the script's iterates for Cases 1 and 3. Departures from the exact sequence at S_4 are rounding effects, and the page describes them as such. In Case 3 the Newton tail is also rounding-driven from about k = 18 (errors at k = 22 to 25: 2.40e-8, 5.54e-9, 2.12e-8, 2.55e-10).

### Reference values
p = 1, √2, √3 satisfy f(p) = f'(p) = 0 with f''(p) = 6, 16, 48, all nonzero, so each is a double root (400-digit evaluation). The scripts' `sqrt(2.0)` differs from the exact √2 by 9.667e-17, and the page discloses this. For √3, the same kind of offset is far below every plotted Case 3 error.

### The picture
- Committed GIFs are byte-identical to fresh scratch regenerations (manifest; md5 re-checked), and each has 23 frames, so the values drawn are the values the scripts compute.
- Contact sheets of all three GIFs and full frames (`aitkenab` 23, `aitkencd` 6, `aitkenef` 5) were inspected.
- Tangent geometry is right: the path runs (x_k, 0) to (x_k, f(x_k)) to (x_{k+1}, 0).
- Titles, axis labels, legends and stop reasons match the code and computed values.
- No iterate falls outside the plot window. The error clamp at 1e-16 never activates.
- In Case 3 no guard fires in the six steps taken, as the script comment says. `f(S_6)` is exactly 0, so a seventh step would hit the denominator guard. The page makes no claim about a seventh step, so this is not a finding.

### Considered and not reported
- The bottom panel counts one Steffensen step as one iteration although it costs two Newton steps. The page states this cost (lines 52, 60, 81), and Mathews' examples compare iteration counts too.
- Example 6 says the root is "near x = 2". The page's √3 is the correct double root (Example 5 gives p = √3).
- Case 1's departure from Mathews' p0 = 1 is explained on the page and is necessary.

The repository was not modified (`git status --short` is empty).

