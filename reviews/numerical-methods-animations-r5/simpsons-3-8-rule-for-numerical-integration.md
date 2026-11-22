# Simpson's 3/8 Rule for Numerical Integration — animation review (round 5)

Page: `pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, and every number the script computes and displays, agreed with my independent computation to the precision stated. Details are in the ledger and the implementation checks below.

One observation that I am not counting as a finding, because it misleads no one: the in-frame label uses `round(approx; digits=6)`, so values whose sixth decimal is 0 are shown with five decimals (frames n=6 "1.79047", n=72 "2.01517", n=108 "2.01572", n=120 "2.01581"). The values are correct.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson38aa.jl` | 0 | 9.0 | simpson38aa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | Composite 3/8 rule "applies cubic interpolation on blocks of three subintervals", h=(b-a)/n, n divisible by 3 | Script fits a cubic through 4 nodes of each 3-subinterval block (`poly_coeffs`, l.18-21, 40-55); every n in `n_seq` is a multiple of 3 | confirmed |
| 2 | Description | $S_n=\frac{3h}{8}[f_0+f_n+3\sum_{i\not\equiv0}f_i+2\sum_{i\equiv0,0<i<n}f_i]$ | Formula reproduces the textbook rule; my mpmath implementation of exactly this formula (indep.py) matches the script's `simpson38_sum` to all printed digits for all 23 n; it is also the exact integral of the drawn panel cubics (instr.jl: `cubicint` agrees with `simpson38_sum` to ~1e-15 for all n) | confirmed |
| 3 | Description | For $f\in C^4$, global error is fourth order, $S-I=O(h^4)$ | Script's own routine on $e^x$ over [0,2] (props.jl): error ratios on halving h = 14.85, 15.69, 15.92, 15.98, 16.00 (n=3..96); errors match $(b-a)h^4 f^{(4)}/80$ magnitude (e.g. n=48: 2.406e-7 vs 2.407e-7) | confirmed |
| 4 | Description | "higher-order refinement of trapezoidal geometry using piecewise cubic panels" | Qualitative; O(h^4) vs trapezoid O(h^2), cubic panels confirmed | confirmed (qualitative) |
| 5 | Intro | Diagram over [0,2] for $y=e^{-x}\sin(8x^{2/3})+1$ | Script l.8-9: `f(x) = exp(-x)*sin(8*x^(2/3))+1`, `a,b=0.0,2.0` | confirmed |
| 6 | Intro | "Each frame recomputes the approximation across the full interval with a denser partition where n remains a multiple of 3" | `n_seq` = 3,6,...,36,42,...,72,81,...,108,120, strictly increasing, all multiples of 3; each frame calls `simpson38_sum(n)` on [a,b]. Frame 1 (n=0) shows only f, as the alt text says | confirmed |
| 7 | Intro | "Red dots mark the sample points $x_i$" | Script l.72-73 scatters $x_i=a+i\,dx$, i=0..n, in red; frames 2, 24 show n+1 red dots | confirmed |
| 8 | Intro | "vertical red lines mark the panel boundaries $x_{3k}$" | Script l.58-61, i in 0:3:n; frame 3 (n=6) has lines at 0, 1, 2; frame 2 (n=3) only at 0 and 2 | confirmed |
| 9 | Case heading | Composite Simpson's 3/8, $f=e^{-x}\sin(8x^{2/3})+1$ on [0,2] | as #5 | confirmed |
| 10 | Behavior | "Piecewise cubic panels over triplets of subintervals are rebuilt at increasing density" | Cubics interpolate their 4 nodes (max node residual 1.3e-14 over all n, instr.jl); frames show re-drawing per n | confirmed |
| 11 | Behavior | True integral $\int_0^2 f\,dx\approx 2.016280$ | mpmath, 40 digits, two independent ways (interval splitting near 0; substitution $x=t^3$ removing the singularity): 2.0162797196170963... both | confirmed |
| 12 | Behavior | "Every approximation shown lies below the true integral" | All 23 errors S-I negative (indep.py): from -0.132066 (n=3) to -0.000469309 (n=120) | confirmed |
| 13 | Behavior | "The error grows from 4 to 7 sample points, then shrinks at every later frame" | abs error: n=3 0.132066, n=6 0.225809 (grows), then 0.0890457, 0.0396505, ..., 0.000560094, 0.000469309, strictly decreasing over all 21 later frames | confirmed |
| 14 | Behavior | "the last frame (121 sample points) gives 2.01581, about 0.00047 low" | n=120: script 2.015810410863725, mine 2.015810411; error -0.000469309; frame 24 shows "Sample Points = 121", "Approximation = 2.01581" | confirmed |
| 15 | Behavior | $f'$ unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0 | sympy: $\lim_{x\to0^+} f'(x)/(\tfrac{16}{3}x^{-1/3}) = 1$ | confirmed |
| 16 | Behavior | Measured error shrinks like $O(h^{5/3})$, not $O(h^4)$ | Ratios $E_n/E_{2n}$ (indep.py): n=60 3.22384, 120 3.18902, 240 3.18013, 480 3.17715, 960 3.17592, 1920 3.17535, 3840 3.17507, 7680 3.17494 | confirmed |
| 17 | Behavior | "halving h divides it by about 3.22 (from 60 to 120 subintervals), tending to $2^{5/3}\approx3.17$, instead of 16" | 3.22384 at n=60→120; $2^{5/3}=3.174802$; sequence above converges to it | confirmed |
| 18 | Link | `[Julia source](simpson38aa.jl)` is this case | File exists; it is the only script and produces `simpson38aa.gif` | confirmed |
| 19 | Embed | `simpson38aa.gif` is this case | Committed GIF byte-identical to scratch regeneration (manifest); frames match script parameters | confirmed |
| 20 | Alt text | "after an opening frame showing only f, each frame shows the sample points as red dots, the panel boundaries as vertical red lines, the piecewise cubic panels and the global approximation" | Frame 1 shows only the magenta f; frames 2-24 show dots, boundary lines, shaded cubic panels, and the "Approximation =" label | confirmed |
| 21 | Legacy note | Reconstructs Mathews' `Simpsonaa.gif`, same integrand and interval | Archive `a2001/Animations/Quadrature/Simpson38/Simpsonaa.gif` frames are labelled $y=e^{-x}\sin(8x^{2/3})+1$ on [0,2] | confirmed |
| 22 | Legacy note | Ends at the same 121-point approximation 2.015810 | Archive last frame: "Sample Points = 121", "Approximation = 2.015810"; true S_120 = 2.0158104 | confirmed |
| 23 | Legacy note | "steps through a different sequence of intermediate n" | Archive sample-point counts include 10, 16, 25, 37, 49, 61, 73, 85, 106, 121 (e.g. n=84, 105 are not in `n_seq`; n=6 is not in the archive) | confirmed |

### 3. Implementation checks — `simpson38aa.jl`

**It is the method it claims to be.** `simpson38_sum` (l.25-30) is the composite Simpson 3/8 rule: weights 3 at $i\not\equiv0\pmod3$, 2 at interior $i\equiv0$, 1 at the ends, factor $3h/8$. For n=3 the `sum_2` term is correctly 0. Degree-of-precision check using the script's own routine with f swapped (props.jl, [0,2]): errors for $x^0..x^3$ are 0 to 9e-16 at n=3 and n=9; for $x^4$ error 0.1185 (n=3) and $x^5$ 0.5926, i.e. exact through cubics and not beyond, as a 3/8 rule must be. On smooth $e^x$ the error ratio on halving h tends to 16 (14.85 → 16.00).

**The numbers are right.** Independent mpmath implementation (indep.py) vs the script's routine (instr.jl), selected n:

| n | script `simpson38_sum` | independent | S - I |
|---|---|---|---|
| 3 | 1.8842140994188474 | 1.884214099 | -0.132066 |
| 6 | 1.790470481304736 | 1.790470481 | -0.225809 |
| 9 | 1.9272339711446245 | 1.927233971 | -0.0890457 |
| 36 | 2.0125952389214476 | 2.012595239 | -0.00368448 |
| 60 | 2.0147667415686947 | 2.014766742 | -0.00151298 |
| 90 | 2.015518613868462 | 2.015518614 | -0.000761106 |
| 120 | 2.015810410863725 | 2.015810411 | -0.000469309 |

All 23 n agree. Displayed values in the archive GIF for overlapping n (1.884214, 1.927234, 1.994094, 2.008397, 2.012595, 2.014059, 2.014767, 2.015170, 2.015810) also agree.

**Reference values.** The script draws no exact reference; the page's reference integral 2.016280 is confirmed (claim 11).

**The picture shows what was computed.** Each shaded panel is the cubic through $(x_{3k+j}, f(x_{3k+j}))$, j=0..3 (node residual ≤ 1.3e-14), and the sum of the exact integrals of the drawn cubics equals the displayed approximation to ~1e-15 for every n, so the shaded area is the reported quantity. Fill is to y=0, which is the bottom of the axis; f has minimum 0.357 and the panel cubics have minimum 0.201 (n=12) and maximum 1.870 over all n, so nothing is clipped by ylims (0, 2.1). The xlims margin (-0.03, 2.03) keeps the end dots visible. Viewed frames 1, 2, contact sheet (12 evenly spaced frames) and 24: the "Sample Points" label is n+1 and the approximation label is `simpson38_sum(n)`, consistent with the computed values above. Frame count 24 = 1 opening frame + 23 values of `n_seq`; the page states no count.

**Fidelity to the archive.** Same integrand, interval, colours/layout idea and final 121-point value as Mathews' Simpson38 animation, which is the only animation the archive module links. Intermediate sequence differs, and the page says so. No archive case is dropped. No fidelity finding.

