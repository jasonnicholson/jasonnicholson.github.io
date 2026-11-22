# Simpson's Rule for Numerical Integration — animation review (round 5)

Page: `pages/numerical-methods/simpsons-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed by independent computation and by the frames; the implementation is composite Simpson's rule, its numbers agree with a 40-digit mpmath computation to all printed digits, and the picture draws what is computed.

Observation, not a finding (cosmetic, does not mislead): the on-frame label uses `round(approx; digits=6)` and Julia's default printing drops trailing zeros, so four frames show fewer than six decimals: n=6 "1.84056", n=24 "2.01037", n=40 "2.01389", n=72 "2.0154" (true values 1.840560, 2.010370, 2.013890, 2.015400). Every value is still correct. If the owner wants uniform digits, `@sprintf("%.6f", approx)` (Printf) would fix it (`simpsonsaa.jl` line 65).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpsonsaa.jl` | 0 | 10.6 | simpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpsonsaa.gif` | 24 | byte-identical | simpsonsaa |

### Page references

- Scripts linked: `simpsonsaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | Composite Simpson's rule "fitting a quadratic interpolant across each pair of subintervals" | Script fits a quadratic through 3 nodes per panel (lines 41–54); panel areas sum to `simpson_sum(n)` within 4e-15 for all 23 n | confirmed |
| 2 | Description | $h=(b-a)/n$, even $n$, $S_n=\frac h3[f(x_0)+f(x_n)+4\sum_{k=1}^{n/2}f(x_{2k-1})+2\sum_{k=1}^{n/2-1}f(x_{2k})]$ | Matches script lines 26–31 (odd i in 1:2:n-1, even i in 2:2:n-2) and my mpmath implementation; values identical | confirmed |
| 3 | Description | "the method integrates cubics exactly" | Script routine on $x^k$ over [0,2]: error 0.0 for k=0..3 at n=2,4,8; k=4 error 0.2667, 0.01667, 0.00104 (ratio 16) | confirmed |
| 4 | Description | composite error for $C^4$ $f$ is $O(h^4)$ | Script routine on $e^x$ on [0,2]: halving ratios 15.65, 15.91, 15.98, 15.99 | confirmed |
| 5 | Animations intro | diagram over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | Script lines 8–9 | confirmed |
| 6 | Animations intro | "After an opening frame showing only $f$" | frame_001: only the magenta curve and title | confirmed |
| 7 | Animations intro | "each frame redraws the entire interval using a denser even partition" | `n_seq` = 2,4,…,20,24,…,48,56,64,72,84,96,108, strictly increasing and even; each frame rebuilds all panels from a to b | confirmed |
| 8 | Animations intro | "Red dots mark the sample points $x_i$" | lines 72–73, $x_i=a+i\,dx$, i=0..n; frames 2, 6, 24 show n+1 dots | confirmed |
| 9 | Animations intro | "vertical red lines mark the panel boundaries $x_{2k}$" | lines 58–61, i in 0:2:n; frame_006 (n=10) has lines at 0, 0.4, 0.8, 1.2, 1.6, 2.0 only | confirmed |
| 10 | Case heading | "Composite Simpson's Rule, $f(x)=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$" | Script lines 8–9, 26–31 | confirmed |
| 11 | Behavior | approximation "converges toward the true integral" | S_n: 2.491261 (n=2), 1.611786 (n=4), then increasing every frame to 2.015834 (n=108); error 0.475 → 0.000446 | confirmed |
| 12 | Behavior | $\int_0^2 f\,dx \approx 2.016280$ | mpmath, substitution $x=t^3$ and tanh-sinh, both 2.016279719617096327887 | confirmed |
| 13 | Behavior | last frame has 109 sample points | n=108 → 109; frame_024 label "Sample Points = 109" | confirmed |
| 14 | Behavior | last frame gives 2.015834 | script 2.015834215997174; mpmath 2.015834216; frame_024 label 2.015834 | confirmed |
| 15 | Behavior | "about 0.00045 low" | I − S_108 = 0.000445504 | confirmed |
| 16 | Behavior | $f'$ unbounded at 0, $f'(x)\approx\frac{16}{3}x^{-1/3}$ | sympy: $\lim_{x\to0^+}x^{1/3}f'(x)=16/3$ | confirmed |
| 17 | Behavior | textbook error order does not hold; error is $O(h^{5/3})$ not $O(h^4)$ | doubling ratios 3.38 (24→48), 3.22 (48→96), 3.189, 3.180, 3.177, 3.1759, 3.1754, 3.1751, 3.1749 (6144→12288) → $2^{5/3}$ | confirmed |
| 18 | Behavior | "halving $h$ divides it by about 3.38 (from 24 to 48 subintervals)" | E_24/E_48 = 0.00591009/0.00174838 = 3.38032 | confirmed |
| 19 | Behavior | "tending to $2^{5/3}\approx3.17$, instead of 16" | $2^{5/3}=3.1748$; ratios above approach it from above | confirmed |
| 20 | Source link | `[Julia source](simpsonsaa.jl)` is this case | only script; it is this case | confirmed |
| 21 | Embed | `simpsonsaa.gif` is this case | committed GIF is byte-identical to regeneration of `simpsonsaa.jl` (manifest) | confirmed |
| 22 | Alt text | opening frame shows only f; then sample points as red dots, panel boundaries as vertical red lines, piecewise quadratic panels, and "the global approximation" | frames 1, 2, 6, 24; approximation printed in every non-opening frame | confirmed |
| 23 | Intro | "Each animation below…"/"linked under each case" (plural, one case) | one case present, wording generic | confirmed (no substantive claim) |

Fidelity (legacy archive):
- Legacy animation `Simpsonaa.gif` uses the same integrand $y=e^{-x}\sin(8x^{2/3})+1$ on [0,2], the same diagram (red dots, red panel lines, pink parabolic panels, magenta f), 630×480. Legacy runs 3 title frames then n=2,4,…,40 (sample points 3…41); its labels match my values (n=2 2.491261, n=6 1.840560, n=10 1.976389, n=14 1.998814, n=18 2.006018, n=22 2.009329, n=26 2.011175, n=30 2.012331, n=34 2.013112, n=38 2.013669, n=40 2.013890). The page's sequence goes further (to n=108) with the same idea; no case dropped (the archive has one Simpson animation). No fidelity finding. The module's worked Examples 1–6 belong to the page's "Worked Example (Planned)" placeholder and are out of scope.

### 3. Implementation checks — `simpsonsaa.jl`

**Is the method it claims.** `simpson_sum` (lines 26–31) is the standard composite Simpson 1/3 rule with weights 1,4,2,…,2,4,1 times h/3, n even. The drawn panels (lines 41–55) are the quadratic interpolants on $[x_{2k},x_{2k+2}]$, filled from 0. Instrumented check (`simpsonsaa_instr.jl`): for every n in the frame sequence the exact integral of the drawn quadratics minus `simpson_sum(n)` is ≤ 4e-15 in magnitude, and each fitted quadratic reproduces its three nodes to ≤ 2.6e-15. So the shaded area is exactly the reported approximation.

**Numbers right.** Script (instrumented) vs independent mpmath (40 digits), all 23 frames:

| n | script | mpmath | n | script | mpmath |
|---|---|---|---|---|---|
| 2 | 2.4912610172534464 | 2.491261017 | 36 | 2.0134120330938727 | 2.013412033 |
| 4 | 1.611786328647445 | 1.611786329 | 40 | 2.0138900411352303 | 2.013890041 |
| 6 | 1.8405602095615228 | 1.84056021 | 44 | 2.014251008823117 | 2.014251009 |
| 8 | 1.9414360776747084 | 1.941436078 | 48 | 2.0145313361281936 | 2.014531336 |
| 10 | 1.9763885057788257 | 1.976388506 | 56 | 2.0149343497581955 | 2.01493435 |
| 12 | 1.991249237540609 | 1.991249238 | 64 | 2.0152063434566827 | 2.015206343 |
| 14 | 1.9988141398228967 | 1.99881414 | 72 | 2.0153996741989433 | 2.015399674 |
| 16 | 2.0032094989460294 | 2.003209499 | 84 | 2.0156006459086404 | 2.015600646 |
| 18 | 2.006018174734146 | 2.006018175 | 96 | 2.0157369856104674 | 2.015736986 |
| 20 | 2.0079417386648446 | 2.007941739 | 108 | 2.015834215997174 | 2.015834216 |
| 24 | 2.010369629370005 | 2.010369629 | | | |
| 28 | 2.011813592933058 | 2.011813593 | | | |
| 32 | 2.012756197183165 | 2.012756197 | | | |

Property checks on the script's own routine (`dop.jl`): exact for $x^0..x^3$, not for $x^4$ (degree of precision 3); error ratio ≈16 on halving for smooth $e^x$; ratio → $2^{5/3}$ for this integrand, consistent with the $x^{2/3}$ endpoint singularity.

**Reference values.** The script draws no reference value; the page's "true" integral 2.016280 was verified two independent ways (singularity-removing substitution $x=t^3$, and tanh-sinh on the original), both 2.0162797196170963.

**Picture shows what was computed.** Frames 1, 2, 6, 24 and the contact sheet (every other frame) viewed. Frame 1: f only. Frame 2 (n=2): one parabola through (0,1), (1,1.364), (2,1.025), boundary lines at 0 and 2 only, label 3 points / 2.491261. Frame 6 (n=10): five parabolas, lines at even nodes only, 11 dots, 1.976389. Frame 24 (n=108): 109 dots, 55 lines, 2.015834. Every label equals the script's computed value rounded to 6 decimals. Axis limits: y in [0,2.1] contains f (max 1.9198) and every drawn quadratic (max 1.9760, min 0.3489); x margin keeps endpoint dots visible; no clamping or masking. Labels at (1.15, 1.88/1.74) never overlap drawn content (curve ≤ 1.39 there). 24 frames = 1 opening + 23 partitions.

