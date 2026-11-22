# Aitken's Method & Steffensen's Acceleration — animation review (round 3)

Page: `pages/numerical-methods/aitken-method-and-steffensen-acceleration/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, **Minor**: Case 2's final Steffensen error is measured against the rounded root, not √2

- **Location:** `index.qmd` line 78, "its error reaches $6.7 \times 10^{-16}$ after 4 steps". The same figure is in the Case 2 alt text on line 82: "which reaches error 6.7×10⁻¹⁶ after 4 steps". The script `aitkencd.jl` line 16 sets `root = sqrt(2.0)`, and that value is used for `errS` and in the bottom-panel plot.
- **What is there now:** the page states 6.7×10⁻¹⁶. This is |S₄ − fl(√2)|, where fl(√2) = 1.4142135623730951 is the double-precision rounding of √2. That rounded value is itself 9.7×10⁻¹⁷ away from the true √2.
- **What is true:** S₄ = 1.414213562373094479… (exact value of the double). Its distance from the true √2 is **5.7×10⁻¹⁶**, so at the two significant figures quoted, "6.7" is wrong in its first digit. Both numbers sit at the double-precision floor (about 2.6 ulp). In exact arithmetic, step 4 would reach 5.0×10⁻¹⁷.
- **How I know:** `indep.py` printed `case2 S4 exact double 1.414213562373094479340807  |S4-sqrt2_true|= 5.695e-16  |S4-fl(sqrt2)|= 6.661e-16`. The exact-arithmetic Steffensen errors were `0.414 0.038 0.000308 1.68e-8 4.97e-17 ...`.
- **Suggested correction:** the simplest fix is the wording. In line 78 and the alt text on line 82, say the error reaches the double-precision rounding level, "about $6 \times 10^{-16}$ (a few units in the last place)". An alternative is to state 5.7×10⁻¹⁶, but then the script's error should also be computed in extended precision, as `abs(big(x) - sqrt(big(2)))`. Rounding `sqrt(big(2))` back to Float64 just gives `sqrt(2.0)` again, so it does not help. Consequence: negligible. The plotted point moves from −15.18 to −15.24.

No other findings. Every other checkable claim was confirmed; see the ledger below.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `aitkenab.jl` | 0 | 9.1 | aitkenab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkencd.jl` | 0 | 10.2 | aitkencd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkenef.jl` | 0 | 10.7 | aitkenef.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words, abridged) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | l.14–18 | At a root of multiplicity m, the Newton error ratio tends to (m−1)/m | Standard result. Exact-arithmetic e₂₂/e₂₁ = 0.5000 in all three double-root cases (`indep.py`) | confirmed |
| D2 | l.20 | For m=2 the ratio is 1/2; about 50 iterations take an O(1) error to 1e−16; 2⁻⁵³ ≈ 1.1e−16 | 2⁻⁵³ = 1.11e−16, so 53 halvings | confirmed |
| D3 | l.20 | For the expanded polynomials of Cases 1 and 3, f evaluates to exactly 0 after 28 and 25 Newton steps, at errors 1.5e−9 and 2.6e−10 | `newton_tail.jl` (the scripts' own f, Julia Float64) printed `case1 FIRST f==0 at step 28, err=1.521e-09` and `case3 FIRST f==0 at step 25, err=2.554e-10`. (Plain Python with a different evaluation order gives 27 and 26, so this depends on the arithmetic. It is correct for the scripts' Julia arithmetic.) | confirmed |
| D4 | l.24–28 | Aitken: x̂ₖ = xₖ − (Δxₖ)²/Δ²xₖ, with Δ²xₖ = xₖ₊₂ − 2xₖ₊₁ + xₖ | Standard formula. Algebra checked | confirmed |
| D5 | l.30–42 | Theorem: if xₖ → p, xₖ ≠ p, and (xₖ₊₁−p)/(xₖ−p) → A with \|A\|<1, then (x̂ₖ−p)/(xₖ−p) → 0 | Standard statement. Matches Mathews' theorem text | confirmed |
| D6 | l.46–50 | Steffensen: two Newton steps q₁, q₂ from p₀, then p₁ = p₀ − (q₁−p₀)²/(q₂−2q₁+p₀); repeat | Exactly the script loop (`aitkenab.jl` l.41–49 and the guarded equivalents in cd/ef). Matches Mathews' Steffensen paragraph | confirmed |
| D7 | l.46, 52, 60 | Superlinear, roughly quadratic convergence even at double roots | Exact arithmetic e_{k+1}/e_k² ≈ 0.08–0.6, bounded: Case 1 6.56e−9 → 3.58e−18; Case 2 1.68e−8 → 4.97e−17; Case 3 2.76e−8 → 4.4e−16 | confirmed |
| D8 | l.52, 60 | Each outer iteration consumes two Newton steps | Code computes q₁ and q₂ by two Newton steps per outer step | confirmed |
| D9 | l.58–59 | Table: Newton quadratic at simple roots, linear (1/2) at double roots | Standard; D1 | confirmed |
| A1 | l.64 | Two synchronized panels per animation: top has Newton tangent steps, one per frame, x_k in the legend, and Steffensen iterates on the x-axis; bottom has log₁₀\|x_k−p\| vs iteration for both | Frames 1, 3, 5…23 of all three GIFs. Frame k shows k tangent steps and legend `Newton x_k = …`. Red diamonds S₀…S_nS on y=0. Bottom panel has both curves | confirmed |
| A2 | l.64 | Newton tangent steps become shorter than one pixel after the first 8, 5 and 4 steps in Cases 1, 2 and 3 | Measured plot box 598 px wide. Step lengths: Case 1 s8 = 1.05 px, s9 = 0.52 px; Case 2 s5 = 1.34 px, s6 = 0.67 px; Case 3 s4 = 1.83 px, s5 = 0.89 px. Vertical legs at those steps are < 0.05 px | confirmed |
| A3 | l.64 | Newton's long linear tail is visible in the bottom panel | Bottom panels at frame 23 show a straight line to k=22 | confirmed |
| A4 | l.66, 72, 80, 88 | Julia source linked under each case | Links are `aitkenab.jl`, `aitkencd.jl`, `aitkenef.jl`; files exist | confirmed |
| C1-1 | l.68 | Case 1: f = x³−3x+2, double root p=1, x₀=2.0 | Script l.13–17. sympy factor gives (x−1)²(x+2); f(1)=f'(1)=0, f''(1)=6 | confirmed |
| C1-2 | l.70 | Newton converges linearly to the double root; asymptotic ratio 1/2, each step halves the error | Instrumented errors 1, .556, .298, …, 6.23e−7, 3.11e−7; ratio → 0.500 | confirmed |
| C1-3 | l.70 | Steffensen errors 1, 5.7e−2, 2.8e−4, 6.6e−9 in 3 steps | Script: 1.000, 5.747e−2, 2.805e−4, 6.556e−9. Exact arithmetic gives the same to 3 s.f. | confirmed |
| C1-4 | l.70 | Plain Newton is still at 3.1e−7 after 22 steps | Script N22 err 3.115e−7 | confirmed |
| C1-5 | l.70 | At S₃ the expanded polynomial evaluates to exactly 0, so the Δ² denominator is 0 and the sequence stops there | Probe: f(S₃)=0.000e+00, q₁=q₂=S₃, denom=0.000e+00. `n_done=3`, stop reason "Δ² denominator = 0" | confirmed |
| C1-6 | l.74 alt | Steffensen fast, stopping after 3 steps at error 6.6×10⁻⁹; Newton slow and linear | As C1-3/C1-5. Frame 23 shows the red curve ending at k=3, about −8.2 | confirmed |
| C2-1 | l.76 | Case 2: f = (x²−2)sin(x²−2), double root √2, x₀=1.0 | Script l.13–17. sympy: derivative correct, f(√2)=f'(√2)=0, f''(√2)=16 | confirmed |
| C2-2 | l.78 | Newton converges linearly | Errors halve: ratio 0.500 | confirmed |
| C2-3 | l.78 | Steffensen = Aitken applied to two Newton steps, restarted from each accelerated value | Code | confirmed |
| C2-4 | l.78 | Error reaches 6.7e−16 after 4 steps (8 Newton steps) | Script error vs fl(√2) is 6.661e−16. True error vs √2 is 5.695e−16 | **wrong at stated precision** (F1, Minor) |
| C2-5 | l.78 | Plain Newton is still at 4.7e−8 after 22 | Script 4.727e−8; exact arithmetic 4.73e−8 | confirmed |
| C2-6 | l.78 | Stops at S₄ because \|f'(S₄)\| is below the 1e−14 cutoff | f'(S₄) = −8.793e−15. Stop reason "\|f'(S_4)\| < 1e-14"; n_done=4 | confirmed |
| C2-7 | l.82 alt | Steffensen reaches error 6.7×10⁻¹⁶ after 4 steps | as C2-4 | wrong at stated precision (F1) |
| C3-1 | l.84 | Case 3: f = x⁶−7x⁴+15x²−9, double root √3, x₀=1.5 | Script l.14–18. sympy factor gives (x−1)(x+1)(x²−3)², f''(√3)=48 | confirmed |
| C3-2 | l.86 | f = (x²−1)(x²−3)², √3 ≈ 1.732 | sympy factor | confirmed |
| C3-3 | l.86 | Newton's linear crawl; tangent steps sub-pixel after the first four | Errors halve; A2 | confirmed |
| C3-4 | l.86 | Steffensen reaches 2.8e−8 in 3 steps, then stalls | Script S₃ err 2.759e−8 (exact arithmetic 2.76e−8) | confirmed |
| C3-5 | l.86 | Near the root, f values (order 1e−14) are comparable to the rounding error of evaluating the expanded polynomial | f(S₃..S₆) = 2.1e−14, 7.8e−14, 7.1e−15, 0. The rounding bound is ≈ eps·(27+63+45+9) ≈ 3e−14. A float64 Python replication with different evaluation order gives different steps 5–6 (3.5e−9, 2.2e−8), which shows these steps are rounding-dominated | confirmed |
| C3-6 | l.86 | Steps 4–6 give errors 5.4e−8, 2.1e−8, 1.5e−8 | Script: 5.442e−8, 2.148e−8, 1.458e−8 (Julia Float64) | confirmed |
| C3-7 | l.86 | About where plain Newton is after 22 steps (2.4e−8) | Script N22 err 2.402e−8 | confirmed |
| C3-8 | l.86 | In exact arithmetic step 4 would reach 4.4e−16 | mpmath: 4.40e−16 from the exact S₃, and 4.396e−16 from the Float64 S₃ | confirmed |
| C3-9 | l.90 alt | Steffensen levels off at a few times 10⁻⁸ after 3 steps | as C3-4/C3-6. Frame 23 shows the red curve flat at about −7.3 to −7.8 | confirmed |
| W1 | l.72–90 | Each case's link and embed point at the right script and GIF | ab = Case 1 function and x₀; cd = Case 2; ef = Case 3. Titles in the GIFs match the headings | confirmed |
| F-1 | l.92 | Cases use the functions of Mathews Examples 2, 4 and 6, with Mathews' starting values for Cases 2 and 3 | Archive images: Ex 2 f=x³−3x+2, p=1, p₀=1; Ex 4 f=sin(x²−2)(x²−2), p=√2, p₀=1; Ex 6 f=x⁶−7x⁴+15x²−9, p₀=1.5 | confirmed |
| F-2 | l.92 | Example 2's stated p₀=1 is the root itself, where f'(1)=0, so Case 1 starts at 2 | gr_60 shows "p₀ = 1"; f'(1)=0 | confirmed (departure is justified and disclosed) |
| F-3 | l.93 | Examples 1, 3 and 5 (Aitken Δ² on the Newton sequence) are not animated | Module text confirms that these examples are what it says; the page discloses the omission | confirmed (not silent, so not a fidelity finding) |

---

### 3. Implementation checks

All three scripts share one structure. They run 22 plain Newton steps and up to `n_steff` Steffensen steps (Aitken applied to two Newton steps, restarting from the accelerated value). The guards keep only the steps actually computed. The top panel draws the tangent path: a vertical leg from (xᵢ,0) to (xᵢ,f(xᵢ)), then a segment to (xᵢ₊₁,0). The bottom panel plots log₁₀ error, clamped at 1e−16.

### `aitkenab.jl` (Case 1)
- **Method:** Newton–Raphson, and Mathews' "Steffensen acceleration": Aitken's Δ² applied to the Newton map, two Newton steps per outer step. This is the variant the page describes. It is not the derivative-free f(x+f(x)) Steffensen method, and the page does not claim it is. Correct.
- **Numbers (script vs independent mpmath):** Newton errors k=0..22 are 1, .5556, .2979, …, 6.230e−7, 3.115e−7, against exact 1, .556, .298, …, 6.23e−7, 3.11e−7. Steffensen errors are 1, 5.747e−2, 2.805e−4, 6.556e−9, against exact 1, 0.0575, 0.00028, 6.56e−9 (exact continues 3.58e−18). The derivative `3x^2-3` was checked with sympy. The stop at S₃ happens because f(S₃) is exactly 0, so the denominator is 0; the probe confirms it.
- **Reference:** root = 1.0 is exact, since (x−1)²(x+2) factors that way.
- **Picture:** the tangent from (2,4) lands at 1.5556, which equals 2 − 4/9, and each segment joins (xᵢ,f(xᵢ)) to (xᵢ₊₁,0), so the slope is f'(xᵢ) by construction. The legend x_22 = 1.0000003115 matches. The annotation S_3 = 0.9999999934 matches 0.99999999344. Labels "Steffensen (2 steps)" (frame 3) and "3 steps; stopped: Δ² denominator = 0" (frames 5+) are correct. The bottom-panel red curve ends at k=3, about −8.18 = log₁₀(6.56e−9). No point falls below the 1e−16 clamp, and ylims (−17, 1) contain every value. Title and ylabel are correct.

### `aitkencd.jl` (Case 2)
- **Method:** the same method, with \|f'\| < 1e−14 guards on Newton and Steffensen and a \|denominator\| < 1e−15 guard. Correct.
- **Numbers:** Newton errors .4142, .1097, .05169, …, 4.727e−8, against exact .414, .11, .0517, …, 4.73e−8. Steffensen errors are .4142, 3.802e−2, 3.077e−4, 1.677e−8, 6.661e−16, against exact .414, .038, .000308, 1.68e−8, 4.97e−17. The fourth differs only because of the double-precision floor. The derivative `2x(sin(x²−2)+(x²−2)cos(x²−2))` was checked with sympy. The stop is reached because f'(S₄) = −8.79e−15 < 1e−14. The Newton guard never fires in 22 steps (f'(x₂₂) = −7.6e−7).
- **Reference:** `sqrt(2.0)` is accurate to 9.7e−17. That is sufficient for every comparison except the last-digit statement of S₄'s error (F1).
- **Picture:** the vertical leg at x=1 has height 0.84 = f(1) = (−1)·sin(−1), and the tangent lands at 1.3045, as computed. The Steffensen diamonds sit at 1, 1.376, 1.4139 and 1.41421. Annotation `S_4=1.4142135624`. Legend "4 steps; stopped: \|f'(S_4)\| < 1e-14" (frames 6+). The red curve ends at −15.18, inside the ylims, and the clamp is not reached.

### `aitkenef.jl` (Case 3)
- **Method:** the same as Case 2. No guard fires within `n_steff = 6`. The comment "no guard fires in Float64" is true. A 7th step would hit denominator 0, because f(S₆) = 0 exactly; it is not attempted.
- **Numbers:** Newton errors .2321, .05348, …, 4.414e−8, 2.402e−8, against exact .232, .0535, …, 4.47e−8, 2.24e−8. Steps 21–22 depart from exact by 1–7% because of rounding in f near the double root; the page does not quote them as exact. Steffensen errors are .2321, 1.942e−2, 2.186e−4, 2.759e−8, then 5.442e−8, 2.148e−8, 1.458e−8 (a rounding-dominated stall). Exact arithmetic gives .232, .0194, .000219, 2.76e−8, 4.4e−16, …. The derivative `6x⁵−28x³+30x` was checked with sympy.
- **Reference:** `sqrt(3.0)` is accurate to ~1e−16, which is ample for errors around 1e−8.
- **Picture:** the vertical leg at x=1.5 has height 0.703 = f(1.5), and the tangent lands at 1.6786. The diamonds sit at 1.5, 1.7126, 1.7318 and ~1.73205. Annotation `S_6=1.7320508222` matches 1.73205082215; the label slightly overlaps the curve but stays legible. The bottom-panel red curve bottoms at about −7.56 and is flat from k=3 to k=6, matching the computed stall.

### Cross-checks common to all three
- There are 23 frames (k = 0…22), and one Newton step is added per frame.
- The committed GIFs are byte-identical to regenerated ones (manifest), so the frames reflect the current scripts.
- The y-limits of the top panel put every Newton and Steffensen iterate inside the window (x ∈ [0.94, 2] for Case 1, [1, 1.42] for Case 2, [1.5, 1.74] for Case 3). No clamping or masking changes what a viewer sees.

