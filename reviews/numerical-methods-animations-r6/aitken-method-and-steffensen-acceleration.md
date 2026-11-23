# Aitken's Method & Steffensen's Acceleration — animation review (round 6)

Page: `pages/numerical-methods/aitken-method-and-steffensen-acceleration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**No findings.** I checked every numerical, behavioural, wiring and method-description claim on the page against my own computations and the frames. All of them hold at the precision they are stated to. Observations that I considered and decided are not findings are listed at the end of section 3.

Counts: Error 0, Misleading 0, Minor 0.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `aitkenab.jl` | 0 | 14.4 | aitkenab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkencd.jl` | 0 | 9.4 | aitkencd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkenef.jl` | 0 | 10.3 | aitkenef.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | At a multiple root of order m, Newton error ratio → (m−1)/m | mpmath Newton ratios at k=5,10,20: Case 1 0.5033, 0.50011, 0.5000; Case 2 0.49887, 0.49997, 0.5000; Case 3 0.49829, 0.49995, 0.5000 (m=2 → 1/2) | confirmed |
| D2 | Double root: ratio 1/2, "about 50 iterations" to go from O(1) to 1e-16; 2^-53 ≈ 1.1e-16 | 2^-53 = 1.11e-16 → 53 halvings | confirmed |
| D3 | "for the expanded polynomials of Cases 1 and 3 below, f evaluates to exactly 0 after 28 and 25 Newton steps, at errors of 1.5e-9 and 2.6e-10" | `fzero.jl`: Case 1 f(x_28)==0, err 1.5211e-9 (f'=9.1e-9, nonzero); Case 3 f(x_25)==0, err 2.5538e-10 | confirmed |
| D4 | Δ and Δ² definitions; x̂_k = x_k − (Δx_k)²/Δ²x_k | Standard; the same algebra is in the scripts (line 48/60: `xS[i] - (q1 - xS[i])^2 / denom`, denom = q2 − 2q1 + x) | confirmed |
| D5 | Theorem: x_k → p, x_k ≠ p, lim (x_{k+1}−p)/(x_k−p) = A, abs(A) < 1 ⇒ (x̂_k−p)/(x_k−p) → 0 | Standard theorem; matches Mathews' statement in the module (converges linearly, p_n ≠ p, abs(A) < 1). Limit of 1 − (r−1)²/(r²−2r+1) = 0 for any r ≠ 1 | confirmed |
| D6 | Steffensen = Aitken on two Newton steps: q1, q2 Newton steps from p0, p1 = p0 − (q1−p0)²/(q2−2q1+p0), repeat | This is exactly the loop in all three scripts, and it matches Mathews' wording ("two steps of Newton's method ... then Aitken's process ... set p0 = p1 and repeat") | confirmed |
| D7 | "superlinear convergence even at double roots"; "restores roughly quadratic convergence" | mpmath e_{k+1}/e_k² for Steffensen: Case 1 0.058, 0.085, 0.083; Case 2 0.22, 0.21, 0.18; Case 3 0.36, 0.58, 0.58. These ratios are bounded and settle, so the order is 2 | confirmed |
| D8 | "Each outer iteration consumes two Newton steps" | Scripts compute q1 and q2 per outer step | confirmed |
| D9 | Table: Newton simple → quadratic; Newton double → linear (1/2); Steffensen double → superlinear (≈2), "Two Newton evals per step" | D1, D7, D8 | confirmed |

### Animations: introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Two synchronized panels per function | Every frame: top curve panel, bottom log-error panel | confirmed |
| A2 | Top panel draws Newton tangent-line steps, one per frame | Script lines 52–57 / 82–86: frame k draws the path through x_0..x_k; each segment runs vertically from (x_i,0) to (x_i,f(x_i)) and then to (x_{i+1},0), which is the tangent at x_i (x_{i+1} is its zero). The frames show 0..22 steps over 23 frames | confirmed |
| A3 | Current iterate x_k printed in legend | Legend "Newton x_k = …" with 10 decimals. Frame 23 of Case 1 reads x_22 = 1.0000003115, and the computed value is 1.000000311483668 | confirmed |
| A4 | Steffensen iterates marked on the x-axis | Red diamonds at (S_j, 0), j ≤ min(frame, n_done) | confirmed |
| A5 | Bottom panel plots log10 abs(x_k − p) vs. iteration for both methods | Lines 111–114; points match computed errors (e.g. Case 1 Steffensen at −8.18 = log10 6.556e-9) | confirmed |
| A6 | "Newton's tangent steps become shorter than one pixel of the frame after its first 8, 5 and 4 steps in Cases 1, 2 and 3" | Plot box measured from frames (`px.py`): columns 69–668 (Case 1, 3), 72–668 (Case 2). Pixels per unit: 206.6, 212.9, 299.5. Step lengths: Case 1 step 8 = 5.08e-3 (1.05 px), step 9 = 2.55e-3 (0.53 px); Case 2 step 5 = 6.28e-3 (1.34 px), step 6 = 3.12e-3 (0.66 px); Case 3 step 4 = 6.12e-3 (1.83 px), step 5 = 2.99e-3 (0.90 px) | confirmed |
| A7 | Julia sources linked under each case | Links `aitkenab.jl`, `aitkencd.jl`, `aitkenef.jl` exist | confirmed |
| A8 | Cases 1–3 use the functions of Mathews Examples 2, 4, 6, with Mathews' starting values for Cases 2 and 3 | Formula images: Ex 2 f = x³−3x+2, p=1, p0=1; Ex 4 f = sin(x²−2)(x²−2), p=√2, p0=1; Ex 6 f = x⁶−7x⁴+15x²−9, p0=1.5. Scripts use x0 = 2.0, 1.0, 1.5 | confirmed |
| A9 | Example 2's p0 = 1 is the root itself and f'(1) = 0 | Image gr_60: p0 = 1; f'(1) = 3−3 = 0 | confirmed |
| A10 | Examples 1, 3, 5 apply Δ² to the Newton sequence for the same three functions, not animated | Images gr_32–37, 112–117, 192–197: {p_n}, Δ², {q_n} with the same three f and p | confirmed |

### Case 1: aitkenab

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C1.1 | f(x) = x³−3x+2, double root p = 1, x0 = 2.0 | Script lines 13–17; sympy factor (x−1)²(x+2) | confirmed |
| C1.2 | Newton converges linearly, ratio 1/2 | D1 | confirmed |
| C1.3 | Steffensen errors 1, 5.7e-2, 2.8e-4, 6.6e-9 in 3 steps | Script: 1, 5.7471e-2, 2.8049e-4, 6.5560e-9. Python float replica: identical. mpmath: 1, 0.0575, 2.80e-4, 6.56e-9 | confirmed |
| C1.4 | Plain Newton at 3.1e-7 after 22 steps | Script 3.1148e-7; mpmath 3.11e-7 | confirmed |
| C1.5 | At S_3, f evaluates to exactly 0, so the Δ² denominator is 0 and the sequence stops | Script: f(S_3) = 0.0, n_done = 3, stop_reason "Δ² denominator = 0" | confirmed |
| C1.6 | Alt text: Newton slow and linear; Steffensen stops after 3 steps at 6.6e-9; x0 = 2 | Frames 5 and 23: legend "Steffensen (3 steps; stopped: Δ² denominator = 0)", annotation S_3 = 0.9999999934 | confirmed |
| C1.7 | Wiring: Case 1 → aitkenab.jl / aitkenab.gif | GIF title "f(x) = x³−3x+2 (p = 1)" | confirmed |

### Case 2: aitkencd

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C2.1 | f = (x²−2)sin(x²−2), double root √2, x0 = 1.0 | Script lines 13–17. The sympy derivative equals the script's df (2x(sin u + u cos u), u = x²−2) | confirmed |
| C2.2 | Steffensen error 6.7e-16 after 4 steps (8 Newton steps) | Script S_4 err 6.6613e-16; Python float replica 6.661e-16 | confirmed |
| C2.3 | "three units in the last place" | ulp(1.4142135623730945) = 2.22e-16, and 6.66e-16 = 3 ulp | confirmed |
| C2.4 | Plain Newton 4.7e-8 after 22 | Script 4.7272e-8; mpmath 4.73e-8 | confirmed |
| C2.5 | Errors measured from double-precision √2; from exact √2 the final error is 5.7e-16 | mpmath: S_4 − exact √2 = −5.695e-16; S_4 − Float64(√2) = −6.661e-16 | confirmed |
| C2.6 | Stops at S_4 because abs(f'(S_4)) < 1e-14 | Script f'(S_4) = −8.79e-15, stop_reason "abs(f'(S_4)) < 1e-14"; frame 23 legend shows it | confirmed |
| C2.7 | Alt text: 6.7e-16 from double √2 (5.7e-16 exact) after 4 steps | as above | confirmed |
| C2.8 | Wiring | GIF title "(x²−2)sin(x²−2) (p = √2)" | confirmed |

### Case 3: aitkenef

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| C3.1 | f = x⁶−7x⁴+15x²−9 = (x²−1)(x²−3)², double root √3 ≈ 1.732, x0 = 1.5 | sympy factor (x−1)(x+1)(x²−3)²; script lines 14–18 | confirmed |
| C3.2 | Tangent steps shorter than a pixel after the first four | A6 | confirmed |
| C3.3 | Steffensen reaches 2.8e-8 in 3 steps | Script 2.7592e-8; float replica 2.760e-8; mpmath 2.76e-8 | confirmed |
| C3.4 | Values near the root of order 1e-14, comparable to the rounding error of the expanded polynomial | Script f(S_3..S_5) = 2.1e-14, 7.8e-14, 7.1e-15. The largest term 15x² ≈ 45 gives eps·45 ≈ 1e-14. True f(S_3) ≈ 24e² ≈ 1.8e-14 | confirmed |
| C3.5 | Steps 4–6 errors 5.4e-8, 2.1e-8, 1.5e-8 | Script 5.4422e-8, 2.1477e-8, 1.4585e-8 | confirmed (for the script). They are rounding noise: my Python replica, which evaluates powers in a different order, gives 5.27e-8, 3.5e-9, 2.24e-8. The page attributes these steps to rounding, so this is consistent |
| C3.6 | Plain Newton 2.4e-8 after 22 | Script 2.4023e-8 (mpmath 2.24e-8; the page quotes the double-precision run, consistent with its framing) | confirmed |
| C3.7 | "In exact arithmetic step 4 would reach 4.4e-16" | mpmath S_4 error 4.4e-16 | confirmed |
| C3.8 | Alt text: levels off at a few times 1e-8 after 3 steps | Frame 23 bottom panel: −7.56, −7.26, −7.67, −7.84 | confirmed |
| C3.9 | Wiring | GIF title "x⁶−7x⁴+15x²−9 (p = √3)" | confirmed |

---

### 3. Implementation checks

All three scripts share one structure: Newton iterates for 22 steps, Steffensen iterates (Aitken applied to two Newton steps, restarted from the accelerated value) with guards, and two panels per frame.

### aitkenab.jl
- **Method:** Steffensen in Mathews' form (Aitken's Δ² on the Newton map, restarted each outer step), and plain Newton. Matches page D6.
- **Numbers:** all 23 Newton iterates agree with mpmath to the printed precision (e.g. x_22 error 3.1148e-7 vs 3.11e-7). Steffensen errors: script 1, 5.7471e-2, 2.8049e-4, 6.5560e-9; Python float replica identical; mpmath 1, 5.75e-2, 2.80e-4, 6.56e-9 (and 3.58e-18 at step 4, which double precision cannot reach). Quadratic constant ≈ 0.083.
- **Reference:** p = 1 is exact; sympy gives (x−1)²(x+2), and the derivative 3x²−3 matches.
- **Picture:** tangent path built from (x_i,0)→(x_i,f(x_i))→(x_{i+1},0); Steffensen diamonds at S_j; legend index equals the frame number; the stop reason is shown from frame 4 on. Clamp at 1e-16 is never active (smallest error 6.6e-9). Axis window (−0.3, 2.6) × (−0.8, 5.5) contains x0 and the root.

### aitkencd.jl
- **Method:** as above, plus guards abs(f') < 1e-14 at S and q1 and abs(denominator) < 1e-15. The Newton guard is never triggered in 22 steps (all iterates distinct, smallest f' ≈ 7.6e-7).
- **Numbers:** Newton x_22 error 4.7272e-8 vs mpmath 4.73e-8. Steffensen script 0.41421, 3.8023e-2, 3.0775e-4, 1.6772e-8, 6.6613e-16; float replica identical; mpmath 0.414, 0.0380, 3.08e-4, 1.68e-8, 4.97e-17.
- **Reference:** `sqrt(2.0)`; the page states that errors are measured from it and gives the exact-√2 figure correctly (5.695e-16).
- **Picture:** the title function matches the code; S_4 annotation 1.4142135624; stop reason in the legend. Clamp inactive (min error 6.66e-16 > 1e-16).

### aitkenef.jl
- **Method:** as aitkencd. No guard fires in 6 steps (comment line 39–40 is correct).
- **Numbers:** Newton x_22 error 2.4023e-8 (mpmath 2.24e-8; the difference is rounding in the expanded polynomial). Steffensen script 0.23205, 1.9424e-2, 2.1863e-4, 2.7592e-8, then 5.44e-8, 2.15e-8, 1.46e-8; mpmath 0.232, 1.94e-2, 2.19e-4, 2.76e-8, 4.4e-16. Steps 1–3 agree, and steps 4–6 are rounding-dominated, as the page states.
- **Reference:** `sqrt(3.0)`; sympy factor confirms √3 is a double root. Derivative 6x⁵−28x³+30x matches sympy.
- **Picture:** contact sheet and frame 23 show the Steffensen error curve levelling off at about 1e-8 after step 3, as described. Window (0.6, 2.6) × (−2.5, 4.5) contains x0 = 1.5, the root and the simple root at 1.

### Considered and not reported
- The bottom panel puts Newton steps and Steffensen outer steps on the same "Iteration k" axis, although one Steffensen step costs two Newton steps. The page says this in the Description ("Each outer iteration consumes two Newton steps") and in Case 2 ("4 steps (8 Newton steps)"), and it follows Mathews' "compare the number of iterations". The plot is not false. Labelling the axis with the cost would be a teaching improvement, not a correction.
- Mathews' Example 6 says "multiple root near x = 2". The page correctly uses √3 ≈ 1.732, which is the actual double root of that polynomial (factor (x²−1)(x²−3)²).
- Case 1 starts at x0 = 2 rather than Mathews' p0 = 1, and the page gives the reason. That reason is correct (f'(1) = 0).
- In Case 3, the S_k annotation overlaps the Newton marker region near the root. This is cosmetic and the text stays legible.

