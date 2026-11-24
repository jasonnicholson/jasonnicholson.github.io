# Simpson's 3/8 Rule for Numerical Integration — animation review (round 9)

Page: `pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None. Every checkable claim on the page is confirmed by computation or by the frames, and the implementation passes all four checks (section 3).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson38aa.jl` | 0 | 9.5 | simpson38aa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpson38aa.gif` | 24 | byte-identical | simpson38aa |

### Page references

- Scripts linked: `simpson38aa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (own words) | Check | Verdict |
|---|---|---|---|
| D1 | "Composite Simpson's 3/8 rule applies cubic interpolation on blocks of three subintervals." | Script fits a cubic through 4 nodes on each block [x_{3k}, x_{3k+3}] (lines 40-55). The exact integral of that cubic equals the rule: n=3 cubic integral 1.884214099418847, rule 1.884214099418847 (`legacycheck.py`). | confirmed |
| D2 | "With h=(b-a)/n and n divisible by 3", S = 3h/8 [f0 + fn + 3 Σ_{i≢0 mod 3} f_i + 2 Σ_{i≡0 mod 3, 0<i<n} f_i] | Matches `simpson38_sum` (lines 25-30). Independent per-panel sum 3h/8(f0+3f1+3f2+f3) agrees with the script at every n to ≤1e-9 (table below). | confirmed |
| D3 | For f in C^4, global error is O(h^4) | Degree of precision: rule exact for x^0..x^3 (error 0), not x^4 (error 0.1185) or x^5 (0.5926) on a single panel [0,2]; this gives the h^4 composite error for smooth f. | confirmed |
| D4 | "higher-order refinement of trapezoidal geometry using piecewise cubic panels" | Descriptive, nothing to compute beyond D1. | confirmed (qualitative) |
| A1 | Intro: "Simpson's 3/8 rule diagram over [0,2] for y = e^{-x} sin(8x^{2/3}) + 1" | Script line 8-9: `f(x) = exp(-x)*sin(8*x^(2/3)) + 1`, `a,b = 0,2`. | confirmed |
| A2 | "Each frame recomputes the approximation across the full interval with a denser partition where n remains a multiple of 3." | n_seq = 3,6,...,36,42,...,72,81,...,108,120: all multiples of 3, strictly increasing; each frame is a fresh full-interval computation. Frame 1 is f alone (the alt text says so). | confirmed |
| A3 | "Red dots mark the sample points x_i" | Line 72-73 scatter all n+1 nodes; frames 2, 24 show red dots at every node (4 and 121 dots). | confirmed |
| A4 | "vertical red lines mark the panel boundaries x_{3k}" | Lines 58-61 draw lines at i = 0:3:n, from 0 to f(x_{3k}); frame 24 shows 41 lines (n/3+1 = 41). | confirmed |
| A5 | "Julia source scripts ... are linked under each case." | One case; link `simpson38aa.jl` present. | confirmed |
| C1 | Heading: "Composite Simpson's 3/8 Rule, f(x)=e^{-x}sin(8x^{2/3})+1 on [0,2]" | As A1; method is the composite 3/8 rule (D2). | confirmed |
| C2 | "Piecewise cubic panels over triplets of subintervals are rebuilt at increasing density." | As A2, D1. Drawn cubics reproduce their nodes to ≤1.3e-14 (`instr.jl`, maxres). | confirmed |
| C3 | "Every approximation shown lies below the true integral" | All 23 errors S_n − I negative (table). | confirmed |
| C4 | "∫_0^2 f dx ≈ 2.016280" | I = 2.0162797196170963 (mpmath quad, two independent formulations: direct with breakpoints, and substitution x=t^3 removing the singularity; agree to 20 digits). Rounds to 2.016280. | confirmed |
| C5 | "The error grows from 4 to 7 sample points, then shrinks at every later frame" | |e|: 0.132066 (4 pts) → 0.225809 (7 pts), then strictly decreasing through all 21 later frames to 0.000469309. | confirmed |
| C6 | "the last frame (121 sample points) gives 2.01581, about 0.00047 low" | n=120: script 2.015810410863725, independent 2.015810411; error −0.000469309. Frame 24 shows "Sample Points = 121", "Approximation = 2.01581". | confirmed |
| C7 | "f' unbounded at x=0 (f'(x) ≈ (16/3) x^{-1/3} near 0)" | mpmath: f'(1e-9)·(1e-9)^{1/3} = 5.33333332 vs 16/3 = 5.33333333. | confirmed |
| C8 | "the textbook error order, which assumes smooth f, does not hold for this integrand" | Ratios below are ≈3.17, not 16. | confirmed |
| C9 | "The measured error shrinks like O(h^{5/3}) rather than O(h^4)" | Halving ratios 4.317 (15→30), 3.396, 3.224, 3.189, 3.180, 3.177, 3.1759, 3.1754, 3.17507 (3840→7680); log2(3.17507) = 1.667. | confirmed |
| C10 | "halving h divides it by about 3.22 (from 60 to 120 subintervals)" | (S60−I)/(S120−I) = 3.22384. Both n=60 and n=120 are frames of the animation. | confirmed |
| C11 | "tending to 2^{5/3} ≈ 3.17, instead of 16" | 2^{5/3} = 3.1748; ratios approach it (C9). | confirmed |
| W1 | `[Julia source](simpson38aa.jl)` | File exists; it is the script that produces the embedded GIF. | confirmed |
| W2 | `![...](simpson38aa.gif)` | Committed GIF is byte-identical to the scratch rerun of `simpson38aa.jl` (manifest). | confirmed |
| W3 | Alt text: "after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise cubic panels and the global approximation" | Frame 1: f only. Frames 2-24: dots, boundary lines, pink-filled cubic panels, "Approximation = ..." annotation. | confirmed |
| L1 | "reconstructs Mathews' archived animation Simpsonaa.gif" | `a2001/Animations/Quadrature/Simpson38/Simpson.html` lists one animation, `Simpsonaa.html` → `Simpsonaa.gif`; the 2003 module links only that page. | confirmed |
| L2 | "uses the same integrand and interval" | Legacy frames are labelled y = e^{-x} sin(8x^{2/3}) + 1 with x-axis 0 to 2. | confirmed |
| L3 | "ends at the same 121-point approximation, 2.015810" | Legacy frame 24: "Sample Points = 121 ... Approximation = 2.015810"; independent value 2.015810411. | confirmed |
| L4 | "steps through a different sequence of intermediate n" | Legacy shows 4, 10, 16, 25, 37, 49, 61, 73, 85, 106, ... points (sheet); page shows 4, 7, 10, 13, 16, ... Legacy values agree with independent computation (n=9 1.927234, n=84 2.0154247 vs 2.015425, n=105 2.0156925 vs 2.015692). | confirmed |

Not a finding, noted for completeness: the in-frame annotation uses `round(approx; digits=6)`, so values with a trailing zero print with five decimals (n=72 "2.01517", n=120 "2.01581"). The values are correct and the page quotes "2.01581" consistently with the frame.

### Script vs independent values

| n | points | script `simpson38_sum` | independent (mpmath) | error S−I |
|---|---|---|---|---|
| 3 | 4 | 1.8842140994188474 | 1.884214099 | −0.132066 |
| 6 | 7 | 1.790470481304736 | 1.790470481 | −0.225809 |
| 9 | 10 | 1.9272339711446245 | 1.927233971 | −0.0890457 |
| 12 | 13 | 1.976629196190375 | 1.976629196 | −0.0396505 |
| 15 | 16 | 1.9940944247919974 | 1.994094425 | −0.0221853 |
| 18 | 19 | 2.001833808071699 | 2.001833808 | −0.0144459 |
| 21 | 22 | 2.005934192958429 | 2.005934193 | −0.0103455 |
| 24 | 25 | 2.008397041546531 | 2.008397042 | −0.00788268 |
| 27 | 28 | 2.0100124027891093 | 2.010012403 | −0.00626732 |
| 30 | 31 | 2.0111411216067023 | 2.011141122 | −0.0051386 |
| 33 | 34 | 2.0119677265662554 | 2.011967727 | −0.00431199 |
| 36 | 37 | 2.0125952389214476 | 2.012595239 | −0.00368448 |
| 42 | 43 | 2.0134768107053778 | 2.013476811 | −0.00280291 |
| 48 | 49 | 2.014059184718606 | 2.014059185 | −0.00222053 |
| 54 | 55 | 2.0144675377251207 | 2.014467538 | −0.00181218 |
| 60 | 61 | 2.0147667415686947 | 2.014766742 | −0.00151298 |
| 66 | 67 | 2.0149935291633914 | 2.014993529 | −0.00128619 |
| 72 | 73 | 2.015170132082283 | 2.015170132 | −0.00110959 |
| 81 | 82 | 2.0153705880411943 | 2.015370588 | −0.000909132 |
| 90 | 91 | 2.015518613868462 | 2.015518614 | −0.000761106 |
| 99 | 100 | 2.0156314275265914 | 2.015631428 | −0.000648292 |
| 108 | 109 | 2.0157196260763444 | 2.015719626 | −0.000560094 |
| 120 | 121 | 2.015810410863725 | 2.015810411 | −0.000469309 |

### 3. Implementation checks — `simpson38aa.jl`

**Method.** Composite Simpson's 3/8 rule, the standard closed Newton-Cotes 4-point rule applied on consecutive blocks of three subintervals. `simpson38_sum` (lines 25-30) uses weight 3 for i not divisible by 3, weight 2 for interior multiples of 3, weight 1 at the ends, times 3h/8 — the composite form. For n=3 the `sum_2` branch is correctly 0. The drawn panels (lines 40-55) are the interpolating cubics through (x_{3k..3k+3}, f), i.e. the curves whose areas the rule computes. No neighbouring method or simplification.

**Numbers.** Instrumented copy (`instr.jl`) vs independent per-panel mpmath sum agree at all 23 n to the 9-10 digits printed (table). Property checks: rule exact for degree ≤3, fails at degree 4 (D3); each drawn cubic reproduces its 4 nodes to ≤1.3e-14; exact integral of the n=3 cubic equals the rule to all printed digits.

**Reference value.** The script draws no exact curve or reference integral; the page's reference 2.016280 was verified by two independent mpmath quadratures agreeing to 20 digits (C4).

**Picture.** Frames 1, 2, 3, 4, 8, 12, 16, 20, 24 (sheet) inspected. Frame 1 shows f alone; later frames show pink-filled cubic panels from y=0, red boundary lines at x_{3k} up to f(x_{3k}), red dots at all n+1 nodes drawn on top, and the annotation "Sample Points = n+1" and "Approximation = S_n" with values matching the table. f ranges over [0.3572, 1.9198] on [0,2], inside ylims (0, 2.1), so nothing is clipped; xlims have a small margin so endpoint dots are visible. The annotation (x≈0.8-1.5, y 1.74-1.88) sits above the curve there (max f ≈ 1.38 on that x range), so it hides nothing. 24 frames = 1 opening + 23 n values; regenerated GIF byte-identical to the committed one. No clamping, masking or window issues.

