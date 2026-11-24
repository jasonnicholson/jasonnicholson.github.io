# Aitken's Method & Steffensen's Acceleration — animation review (round 8)

Page: `pages/numerical-methods/aitken-method-and-steffensen-acceleration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Counts: Error 0, Misleading 0, Minor 0.

Every numerical claim on the page reproduced from the scripts and, where meaningful, from an independent high-precision computation; the pictures draw what is computed; the wiring is correct; the departures from Mathews (Case 1 start value, Examples 1/3/5 not animated) are disclosed on the page with a correct reason.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `aitkenab.jl` | 0 | 9.3 | aitkenab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkencd.jl` | 0 | 10.3 | aitkencd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `aitkenef.jl` | 0 | 11.3 | aitkenef.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | l.14–18 | At a root of multiplicity m, Newton is linear with ratio (m−1)/m | Standard; computed Newton ratio e22/e21 = 0.500 in all three cases (mpmath) | confirmed |
| 2 | l.20 | For m=2 ratio ½; about 50 iterations from O(1) to 1e-16; 2^-53 ≈ 1.1e-16 | arithmetic | confirmed |
| 3 | l.20 | Expanded polynomials of Cases 1 and 3: f evaluates to exactly 0 after 28 and 25 Newton steps, errors 1.5e-9 and 2.6e-10 | instrumented Julia: "f==0 at k=28 err=1.521e-9", "k=25 err=2.554e-10" | confirmed |
| 4 | l.24–28 | Aitken formula x̂_k = x_k − (Δx_k)²/Δ²x_k with Δ² = x_{k+2}−2x_{k+1}+x_k | standard | confirmed |
| 5 | l.30–42 | Aitken theorem (|A|<1, x_k≠p ⇒ error ratio → 0) | standard; matches archive statement | confirmed |
| 6 | l.46–50 | Steffensen = two Newton steps q1,q2 from p0, then p1 = p0 − (q1−p0)²/(q2−2q1+p0), repeat | scripts l.42–48 implement exactly this; matches archive's description | confirmed |
| 7 | l.46, 52, table | Superlinear / roughly quadratic convergence at double roots | mpmath exact-arithmetic Steffensen errors: C1 5.7e-2, 2.8e-4, 6.6e-9, 3.6e-18, 1.1e-36; order estimates 2.86, 2.30, 2.13 (C1), 2.47, 2.21, 2.10 (C2), 2.14, 2.07, 2.03 (C3) | confirmed |
| 8 | table | Two Newton evaluations per Steffensen step | code | confirmed |
| 9 | l.64 | Two panels: top Newton tangent steps one per frame with x_k in legend; Steffensen iterates on x-axis; bottom log10|x_k−p| vs iteration for both | frames 1, 3, 5…23 of all three GIFs; plotting code | confirmed |
| 10 | l.64 | Newton tangent steps shorter than one pixel after first 8, 5, 4 steps (Cases 1, 2, 3) | Plot box measured from frame_023: 206.6, 212.9, 299.5 px/unit. Step lengths in px: C1 step 8 = 1.05, step 9 = 0.53; C2 step 5 = 1.34, step 6 = 0.66; C3 step 4 = 1.83, step 5 = 0.90 | confirmed |
| 11 | l.68 | Cases 1–3 use functions and Newton-vs-Steffensen comparisons of Examples 2, 4, 6; start values for Cases 2, 3 from Mathews | archive gr_59/60 (x³−3x+2, p0=1), gr_139/140 (sin(x²−2)(x²−2), p0=1), gr_218/219 (x⁶−7x⁴+15x²−9, p0=1.5) | confirmed |
| 12 | l.68 | Example 2's p0=1 is the root itself, f'(1)=0, so Case 1 uses x0=2 | f'(1)=3−3=0; archive gr_60 "p0 = 1" | confirmed |
| 13 | l.69 | Examples 1, 3, 5 apply Aitken to the Newton sequence and are not animated | archive text of lnk_2/4/6 | confirmed |
| 14 | l.71 | Case 1: f=x³−3x+2, double root p=1, x0=2.0 | aitkenab.jl l.13–17; sympy factor (x−1)²(x+2) | confirmed |
| 15 | l.73 | f = (x−1)²(x+2) | sympy | confirmed |
| 16 | l.73 | Steffensen errors 1, 5.7e-2, 2.8e-4, 6.6e-9 in 3 steps | Julia: 1.000, 5.747e-2, 2.805e-4, 6.556e-9; mpmath exact: 1, 0.0575, 2.80e-4, 6.56e-9 | confirmed |
| 17 | l.73 | Newton at 3.1e-7 after 22 steps | Julia 3.115e-7; mpmath 3.11e-7 | confirmed |
| 18 | l.73 | At S3 expanded polynomial rounds to exactly 0, Δ² denominator 0, animation (sequence) stops | Julia f(S3)=0.000e+00, n_done=3, stop "Δ² denominator = 0"; legend in frames 4–23 shows "3 steps; stopped: Δ² denominator = 0" | confirmed |
| 19 | l.73 | Factored form (x−1)²(x+2) takes a fourth step to the root | Python float64 factored form: S4 = 0.9999999999999997, error 3.3e-16 | confirmed |
| 20 | l.75, 77 | Link aitkenab.jl and GIF aitkenab.gif; alt text: x³−3x+2, root 1 from x0=2, Steffensen stops after 3 steps at 6.6e-9 | file/title/frame_023 | confirmed |
| 21 | l.79 | Case 2: f=(x²−2)sin(x²−2), double root √2, x0=1.0 | aitkencd.jl l.13–17; (x²−2)sin(x²−2) ~ (x²−2)² near √2 | confirmed |
| 22 | l.81 | Steffensen error 6.7e-16 after 4 steps (8 Newton steps), three ulps | Julia 6.661e-16; ulp(√2)=2.22e-16, ratio 3.0 | confirmed |
| 23 | l.81 | Newton still at 4.7e-8 after 22 | Julia 4.727e-8; mpmath 4.73e-8 | confirmed |
| 24 | l.81 | Errors measured from double-precision √2; from exact √2 final error 5.7e-16 | script `root = sqrt(2.0)`; mpmath |S4−√2| = 5.69e-16 | confirmed |
| 25 | l.81 | Stops at S4 because |f'(S4)| < 1e-14 | Julia df(S4) = −8.79e-15, stop "|f'(S_4)| < 1e-14", n_done=4; legend frames 5–23 | confirmed |
| 26 | l.83, 85 | Link aitkencd.jl / GIF aitkencd.gif; alt text 6.7e-16 (5.7e-16 exact) after 4 steps | file/title/frames | confirmed |
| 27 | l.87 | Case 3: f=x⁶−7x⁴+15x²−9, double root √3, x0=1.5 | aitkenef.jl l.14–18 | confirmed |
| 28 | l.89 | f=(x²−1)(x²−3)², √3 ≈ 1.732 | sympy factor (x−1)(x+1)(x²−3)² | confirmed |
| 29 | l.89 | Tangent steps shorter than a pixel after first four | see #10 (step 5 = 0.90 px) | confirmed |
| 30 | l.89 | Steffensen error 2.8e-8 in 3 steps | Julia 2.759e-8; mpmath exact 2.76e-8 | confirmed |
| 31 | l.89 | Near the root f values ~1e-14, comparable to rounding error of evaluating the expanded polynomial | f(S3)=2.13e-14; max |float−exact| of f over ±5e-8 around √3 = 1.3e-14 | confirmed |
| 32 | l.89 | Steps 4–6 errors 5.4e-8, 2.1e-8, 1.5e-8 | Julia 5.442e-8, 2.148e-8, 1.458e-8. (A Python float64 run using `**` gives different noise values 5.3e-8, 3.5e-9, 2.2e-8, confirming these are rounding-determined, as the page says.) | confirmed |
| 33 | l.89 | Plain Newton after 22 steps 2.4e-8 | Julia 2.402e-8 (mpmath exact 2.24e-8; page quotes the script's float run, which is what the panel shows) | confirmed |
| 34 | l.89 | In exact arithmetic step 4 would reach 4.4e-16 | mpmath: 4.4e-16 both from exact S3 and from the float S3 | confirmed |
| 35 | l.91, 93 | Link aitkenef.jl / GIF aitkenef.gif; alt text levels off at a few ×1e-8 after 3 steps | frame_023 bottom panel | confirmed |
| 36 | manifest | 3 scripts, 3 GIFs, 23 frames each (frames 0..22) | manifest; `@animate for frame in 0:n_total`, n_total=22 | confirmed |

### 3. Implementation checks

Common structure (all three scripts): Newton iterates xN (22 steps), Steffensen iterates xS with guards (|f'|<1e-14, |Δ²|<1e-15) that truncate the sequence rather than pad it; frame k draws k Newton tangent steps and min(k, n_done) Steffensen iterates; bottom panel plots log10 of errors clamped at 1e-16 (clamp never active: smallest error is 6.66e-16).

### aitkenab.jl
- **Method:** Steffensen in Mathews' form (Aitken Δ² applied to the Newton map, restarted from each accelerated value). Matches the page's Description and the archive.
- **Numbers:** derivative 3x²−3 correct (sympy). Steffensen errors script / mpmath: 5.747e-2 / 5.75e-2, 2.805e-4 / 2.80e-4, 6.556e-9 / 6.56e-9; script stops at step 4 because f(S3) = 0 exactly in Float64 (mpmath would continue to 3.6e-18). Newton e22 3.115e-7 / 3.11e-7; ratio → 0.500.
- **Reference:** root = 1.0, exact.
- **Picture:** tangent path built from (x_i,0)→(x_i,f(x_i))→(x_{i+1},0), which is the tangent line by construction; title matches f; legend index = frame = Newton step; annotation S_3=0.9999999934 matches S3 = 0.99999999344; regenerated GIF byte-identical to committed.

### aitkencd.jl
- **Method:** same as above.
- **Numbers:** derivative 2x(sin u + u cos u), u=x²−2, correct (sympy). Steffensen script / mpmath: 3.802e-2 / 3.80e-2, 3.077e-4 / 3.08e-4, 1.677e-8 / 1.68e-8, 6.661e-16 (from fl(√2)) / exact arithmetic 5.0e-17; the float64 value is at the rounding floor (5.69e-16 from exact √2). Independent Python float64 run reproduces the same four errors and the same f'-guard stop. Newton e22 4.727e-8 / 4.73e-8.
- **Reference:** root = sqrt(2.0), correctly rounded; page discloses this.
- **Picture:** curve shape checked (f(0)=2 sin 2 ≈ 1.82, zero at x=√(2+π)≈2.27 visible); stop label matches computed guard; annotation S_4=1.4142135624 correct.

### aitkenef.jl
- **Method:** same as above.
- **Numbers:** derivative 6x⁵−28x³+30x correct (sympy). Steffensen script / mpmath: 1.942e-2 / 1.94e-2, 2.186e-4 / 2.19e-4, 2.759e-8 / 2.76e-8; steps 4–6 (5.44e-8, 2.15e-8, 1.46e-8) are rounding-dominated (exact would be 4.4e-16, 1.1e-31), as the page states. No guard fires (n_done = 6 = n_steff). Newton e22 2.402e-8 (exact 2.24e-8; the difference is float rounding in f near the double root).
- **Reference:** root = sqrt(3.0), correctly rounded.
- **Picture:** legend "Steffensen (6 steps)" with no stop reason, consistent with computation; bottom panel shows the plateau at ~1e-8 the page describes; annotation S_6=1.7320508222 matches 1.73205082215.

### Legacy fidelity
Functions and starting values for Examples 2, 4, 6 match the archive (gr_59/60, gr_139/140, gr_218/219), except Case 1's x0 = 2 instead of p0 = 1, which the page explains correctly (p0 = 1 is the root, f'(1) = 0). Examples 1/3/5 (Aitken on the Newton sequence) are omitted and the page says so. Example 6's archive text says "the multiple root near x = 2" while its own formula image gr_193 gives p = √3; the page's √3 is mathematically correct. No fidelity findings.

