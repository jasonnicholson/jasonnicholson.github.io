# Adaptive Simpson's Rule — animation review (round 2)

Page: `pages/numerical-methods/adaptive-simpsons-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0.

Every checkable claim on the page was confirmed against an independent computation, an instrumented copy of the script, and the extracted frames (ledger below). Observations I considered and set aside as not findings:

- *Split order versus Mathews (not a finding).* Mathews' Example 7 table and legacy animation split $[1/2,1]$ before $[0,1/2]$, so his 11-point value is 1.935128; the page's script splits leftmost first, so its 11-point frame shows 2.008051. All other 19 per-frame values agree with Mathews' table to six decimals, and the final partition is identical. The page states its own ordering rule ("the widest panel that fails the test (leftmost first)") and the GIF follows it; the page makes no claim to reproduce Mathews' intermediate sequence. No reader-relevant departure.
- *"Approximation" is the composite $\sum S(a,b)$, not what the recursive routine returns (not a finding).* The page says so explicitly in the Animations intro and gives the recursive value (2.016273) in the Behavior paragraph; Mathews' own table shows the same composite values.
- *GIF frame 1 shows only the curve and frame 2 the unsplit panel, so "each frame splits" is loose for the first two frames.* Too slight to matter; the intro says "Starting from the single panel $[0,2]$".



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adaptivesimpsonsaa.jl` | 0 | 7.0 | adaptivesimpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `adaptivesimpsonsaa.gif` | 21 | byte-identical | adaptivesimpsonsaa |

### Page references

- Scripts linked: `adaptivesimpsonsaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Evidence keys: **P** = independent Python (`indep.py`, `extra.py`, `range.py`, run with `/usr/bin/python3 -I`), **J** = instrumented copy of the script (`instr.jl`, `julia instr.jl`), **F** = extracted frames of the committed GIF, **A** = Mathews archive, **S** = script source line.

| # | Page text (quoted) | Verdict | Evidence |
|---|---|---|---|
| 1 | Description: $S(a,b)=\frac{b-a}{6}[f(a)+4f(m)+f(b)]$ | confirmed | S line 15 implements exactly this; J: `simpson` gives 4.0 for $\int_0^2 x^3$ (exact) and 6.6667 vs 6.4 for $x^4$ (degree of precision 3, as Simpson's rule should) |
| 2 | "refinement compares $S(a,b)$ against $S(a,m)+S(m,b)$" | confirmed | S line 20 |
| 3 | "the animation uses the acceptance test of Mathews' routine: accepted when $\lvert S(a,m)+S(m,b)-S(a,b)\rvert<\varepsilon_{[a,b]}$" | confirmed | S line 20; A gr_2 (Adapt subroutine): `If[Abs[Sab-Sac-Scb] < tol, Return[Sac+Scb], Return[Adapt[a,c,tol/2]+Adapt[c,b,tol/2]]]` |
| 4 | "the whole interval starts with $\varepsilon$ and each half of a split interval gets half its tolerance" | confirmed | S lines 28, 37; A gr_2 |
| 5 | "refinement concentrates where curvature or oscillation is strongest" | confirmed (general) | Refinement concentrates at $x=0$ where $f''\sim x^{-4/3}$ is unbounded (P/J final nodes: 19 of 41 in $[0,1/8]$) |
| 6 | "A common variant uses $15\,\varepsilon_{[a,b]}$ … accepts 9 subintervals (the finest is $[0,1/32]$)" | confirmed | P: factor 15 → panels=9, points=19, finest (0, 0.03125) = $[0,1/32]$ |
| 7 | "instead of 20 (the finest is $[0,1/2048]$)" | confirmed | P: factor 1 → panels=20, finest (0, 0.00048828125) = $[0,1/2048]$; J final nodes end at 1/4096, 1/2048 |
| 8 | Intro: $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$, $\varepsilon=10^{-3}$ | confirmed | S lines 9, 10, 12; A Example 7: same $f$, $[0,2]$, `Adapt[0,2,0.001]` |
| 9 | "Starting from the single panel $[0,2]$" | confirmed | F frame_002: 3 sample points, one parabola over $[0,2]$, Approximation = 2.491261 (P: 2.491261) |
| 10 | "each frame splits the widest panel that fails the test (leftmost first)" | confirmed | S line 34 sorts failing panels by (−width, left end); J split sequence: [0,2], [0,1], [1,2], [0,1/2], [1/2,1], [1,3/2], [0,1/4], [1/4,1/2], [1/2,3/4], [3/4,1], [0,1/8], [1/8,1/4], [0,1/16] … [0,1/1024], identical to P's independent widest-first loop |
| 11 | "marks the two new sample points in blue" | confirmed | S lines 119–120 plot $(3p+q)/4$, $(p+3q)/4$, the midpoints of the two halves = the only new nodes; F frames 3, 5, 7, 17, 21 show two blue points inside the split panel |
| 12 | "'Approximation' is the composite Simpson sum of $S(a,b)$ over the panels drawn" | confirmed | S `simpson_nonuniform` over triples (x0,x1,x2) with $h/3=(x_2-x_0)/6$; J per-frame values equal P's $\sum S(a,b)$ to all printed digits (table in §3) |
| 13 | Case heading: "Adaptive Refinement, $f(x)=1+e^{-x}\sin(8x^{2/3})$, $[0,2]$, $\varepsilon=10^{-3}$" | confirmed | S lines 9–12; F label "tol = 0.001" |
| 14 | "Refinement stops when all 20 panels (41 points) pass the test" | confirmed | J: 20 node sets, last has 41 points; P recursive routine: 20 accepted panels, 41 points; F frame_021 "Sample Points = 41" |
| 15 | "$[1.5,2]$ is never split" | confirmed | P final panel list contains (3/2, 2); J final nodes …, 3/2, 7/4, 2 |
| 16 | "19 of the 41 points lie in $[0,1/8]$" | confirmed | P and J: 19 |
| 17 | "The last seven frames split $[0,1/16],[0,1/32],\dots,[0,1/1024]$ in turn" | confirmed | J: GIF frames 15–21 split [0,1/16], [0,1/32], [0,1/64], [0,1/128], [0,1/256], [0,1/512], [0,1/1024]; F labels on frames 15, 17, 19, 21 read "Split [0, 1/16]", "[0, 1/64]", "[0, 1/256]", "[0, 1/1024]" |
| 18 | "because $f'$ is unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0)" | confirmed | P (sympy): $f'(x)=-e^{-x}\sin(8x^{2/3})+\frac{16e^{-x}\cos(8x^{2/3})}{3x^{1/3}}$, $\lim_{x\to0}x^{1/3}f'(x)=16/3$; at $x=10^{-6}$: 533.3318 vs 533.3333 |
| 19 | "the panels split in the last five frames are at most $1/64$ wide" | confirmed | J: last five splits are [0,1/64] … [0,1/1024] |
| 20 | "(under 5 pixels at this scale)" | confirmed | F frame_021 row 430: panel-boundary pixels at x=39 (0), 328 (1), 473 (1.5) → ≈289 px/unit; 1/64 → 4.5 px |
| 21 | "so the blue label names each one" | confirmed | S line 121; F frames 17, 19, 21 show the blue "Split [0, 1/…]" label |
| 22 | "The final estimate $2.016252$" | confirmed | J: 2.016251761; P: 2.016251761; F frame_021 "Approximation = 2.016252"; A Example 7 last table value 2.016252 |
| 23 | "differs from the integral $2.016280$" | confirmed | P mpmath, 30 digits, two independent ways (substitution $x=u^3$ removing the singularity; direct with breakpoints): 2.0162797196170963… |
| 24 | "by $-2.8\times10^{-5}$" | confirmed | P: composite − I = −2.7958e-05 |
| 25 | "summing $S(a,m)+S(m,b)$ over the same panels, as the recursive routine returns, gives $2.016273$" | confirmed | P recursive return: 2.016272604 |
| 26 | Source link `[Julia source](adaptivesimpsonsaa.jl)` | confirmed | file exists in page folder; it is the script that writes `adaptivesimpsonsaa.gif` (S line 126) |
| 27 | Embed `adaptivesimpsonsaa.gif` | confirmed | exists; manifest: byte-identical to scratch regeneration of this script |
| 28 | Alt: "one failing panel is split per frame, with sample points and panel boundaries drawn and the new points in blue" | confirmed | F frames 3–21; S lines 95–120 |
| 29 | Alt: "the refinement ends with 41 points, 19 of them in [0, 1/8]" | confirmed | as rows 14, 16 |
| 30 | Alt: "the piecewise quadratic approximation and integral estimate update each frame" | confirmed | F: parabolas and "Approximation" change on every frame from 2 to 21; J values all distinct |
| 31 | Counts: one case, one script, one GIF ("Each animation below…") | confirmed | page has one case; manifest: 1 script, 1 GIF (plural wording is harmless) |

### 3. Implementation checks — `adaptivesimpsonsaa.jl`

**It is the method it claims to be.** The script runs Mathews' adaptive Simpson acceptance test (absolute difference against the interval tolerance, no factor 15, tolerance halved on each split), matching the subroutine image in the archive (gr_2) and the page's Description. The recursion is replaced by an explicit "split the widest failing panel, leftmost first" loop for one split per frame. Because each panel's acceptance depends only on its own endpoints and its depth-determined tolerance, this ordering yields the same final partition as the recursion: confirmed by P, whose recursive implementation returns the identical 20 panels. Named variant: Mathews/Burden-style test with factor 1 (not the Lyness 15ε test), which the page states explicitly.

**The numbers are right.** Instrumented copy (`instr.jl`, plotting removed, printing every node set) vs independent Python (`indep.py`):

| GIF frame | pts | split | script (J) | independent (P) | Mathews table (A) |
|---|---|---|---|---|---|
| 2 | 3 | — | 2.491261017 | 2.491261 | 2.491261 |
| 3 | 5 | [0,2] | 1.611786329 | 1.611786 | 1.611786 |
| 4 | 7 | [0,1] | 1.909633195 | 1.909633 | 1.909633 |
| 5 | 9 | [1,2] | 1.941436078 | 1.941436 | 1.941436 |
| 6 | 11 | [0,1/2] | 2.008051430 | 2.008051 | 1.935128 (Mathews split [1/2,1] first; P reproduces 1.935128 for that order) |
| 7 | 13 | [1/2,1] | 2.001743629 | 2.001744 | 2.001744 |
| 8 | 15 | [1,3/2] | 2.003302106 | 2.003302 | 2.003302 |
| 9 | 17 | [0,1/4] | 2.012444628 | 2.012445 | 2.012445 |
| 10 | 19 | [1/4,1/2] | 2.013092144 | 2.013092 | 2.013092 |
| 11 | 21 | [1/2,3/4] | 2.012906183 | 2.012906 | 2.012906 |
| 12 | 23 | [3/4,1] | 2.012773693 | 2.012774 | 2.012774 |
| 13 | 25 | [0,1/8] | 2.015124346 | 2.015124 | 2.015124 |
| 14 | 27 | [1/8,1/4] | 2.015195262 | 2.015195 | 2.015195 |
| 15 | 29 | [0,1/16] | 2.015920311 | 2.015920 | 2.015920 |
| 16 | 31 | [0,1/32] | 2.016147759 | 2.016148 | 2.016148 |
| 17 | 33 | [0,1/64] | 2.016219254 | 2.016219 | 2.016219 |
| 18 | 35 | [0,1/128] | 2.016241748 | 2.016242 | 2.016242 |
| 19 | 37 | [0,1/256] | 2.016248829 | 2.016249 | 2.016249 |
| 20 | 39 | [0,1/512] | 2.016251059 | 2.016251 | 2.016251 |
| 21 | 41 | [0,1/1024] | 2.016251761 | 2.016252 | 2.016252 |

Property checks: the `simpson` formula integrates $x^3$ on $[0,2]$ exactly (4.0) and not $x^4$ (6.6667 vs 6.4), i.e. degree of precision 3. Each drawn panel parabola reproduces $f$ at its three nodes (max residual 1.0e-15) and its exact integral equals the panel's Simpson value (max difference 2.5e-16), so the pink area is exactly what "Approximation" sums. Alternate tests: factor 15 → 9 panels/19 points, finest $[0,1/32]$; factor 10 → 10 panels, finest $[0,1/64]$.

**Its reference values are right.** The script draws no reference value. The page's integral 2.016280 was checked with mpmath at 30 digits by two routes (cubic substitution making the integrand smooth, and direct quadrature with breakpoints), both 2.01627971961709632789.

**The picture shows what was computed.** Frames 1, 2, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21 viewed (contact sheet plus full-size frames 2, 17, 21). Frame 1: curve only. Frame 2: single parabola through (0,1), (1,f(1)), (2,f(2)), no split label. Later frames: red parabolas per panel through the panel's three nodes with pink fill down to 0 (S lines 83–97), red vertical lines at panel endpoints `xs[1:2:end]` (S line 100), red nodes, blue new nodes at the half-panel midpoints, labels "Sample Points", "Approximation", "tol = 0.001", "Split [p, q]" with exact dyadic fractions, all matching J. Axis limits $[0,2]\times[0,2.1]$ contain every plotted value: over all frames the parabolas range over [0.349, 1.976] and $f$ over [0.357, 1.920] (`range.py`), so nothing is clipped. No clamping or NaN masking. Frame count 21 = 1 curve-only frame + 20 node sets, matching 19 splits. The near-zero splits are only a few pixels wide, but the page says so and the blue label identifies each.

**Legacy fidelity.** The page reproduces Mathews' Example 7 / legacy animation 1 (same $f$, interval, tolerance, Adapt routine, 41 final points, final 2.016252, same pink-parabola presentation). Mathews' other examples (1–6) are tables of integrals at several tolerances with no animation in the archive; the page's single case matches the archive's single animation. The one departure, the order of two equal-width splits at the 11-point step, is described in §1 and is not a finding.

