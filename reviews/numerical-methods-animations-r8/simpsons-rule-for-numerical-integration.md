# Simpson's Rule for Numerical Integration — animation review (round 8)

Page: `pages/numerical-methods/simpsons-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None. Every checkable claim on the page was confirmed against independent computation and the frames (ledger below).

Observations deliberately not raised as findings (cosmetic, not misleading):
- Frame 20 (n = 72) prints `Approximation = 2.0154` rather than `2.015400`, because `round(approx; digits=6)` drops trailing zeros (true value 2.015399674). The value is correct to the digits shown.
- The frames do not print the integrand (the legacy GIF did); the page text states it.
- The script's sequence skips n = 22 and extends past the legacy's n = 40 up to n = 108; legacy frames for n = 2..40 that overlap agree with the script to 6 decimals (e.g. 2.491261, 1.840560, 1.976389, 1.998814, 2.006018, 2.013890). Same function, interval and drawing scheme as the legacy, so no fidelity issue.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpsonsaa.jl` | 0 | 8.8 | simpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (own words) | Evidence | Verdict |
|---|---|---|---|
| 1 | Description formula: `S_n = h/3[f(x0)+f(xn)+4 sum_{k=1}^{n/2} f(x_{2k-1}) + 2 sum_{k=1}^{n/2-1} f(x_{2k})]`, h=(b-a)/n, n even | Matches script `simpson_sum` (odd i 1:2:n-1 weight 4, even i 2:2:n-2 weight 2, endpoints 1, times dx/3); script values equal mpmath implementation of this formula to all printed digits | confirmed |
| 2 | "fitting a quadratic interpolant across each pair of subintervals" | `instr.jl`: exact integral of each plotted quadratic summed equals `simpson_sum(n)` within 3e-15 for all 23 n; interpolation residual at nodes <= 2.6e-15 | confirmed |
| 3 | "the method integrates cubics exactly" | `indep.py`: Simpson error on x^k over [0,1]: 0 for k=0..3, 1/120 for k=4 | confirmed |
| 4 | composite error O(h^4) for f in C^4 | standard; consistent with degree of precision 3 | confirmed |
| 5 | Interval [0,2], f = e^{-x} sin(8x^{2/3}) + 1 | script lines 8-9; legacy GIF title shows same function | confirmed |
| 6 | "After an opening frame showing only f" | frame_001 shows only the magenta curve; script loops `vcat(0, n_seq)` with n=0 drawing f only | confirmed |
| 7 | "each frame redraws the entire interval using a denser even partition" | n_seq = 2,4,...,20,24,...,48,56,64,72,84,96,108, all even, strictly increasing; frames show full [0,2] | confirmed |
| 8 | "Red dots mark the sample points x_i" | script lines 72-73 scatter a+i*dx, i=0..n, red; frames | confirmed |
| 9 | "vertical red lines mark the panel boundaries x_{2k}" | script lines 58-61, i=0:2:n; frames (e.g. frame_002 n=2: lines at 0 and 2 only; frame_003 n=4 at 0,1,2) | confirmed |
| 10 | Alt text: piecewise quadratic panels and the global approximation shown | pink filled quadratics + "Approximation = ..." annotation in frames 2-24 | confirmed |
| 11 | "approximation converges toward the true integral" | S_n: 2.491261, 1.611786, 1.840560, ... 2.015834; error -> 0 (from n=4 on, monotone from below) | confirmed |
| 12 | true integral ≈ 2.016280 | mpmath (substitution x=t^3, and split-interval quad, both 30 digits): 2.0162797196 | confirmed |
| 13 | last frame has 109 sample points | n=108 -> 109; frame_024 shows "Sample Points = 109" | confirmed |
| 14 | last frame gives 2.015834 | script 2.015834216; mpmath 2.015834216; frame_024 "2.015834" | confirmed |
| 15 | "about 0.00045 low" | error -0.000445504 | confirmed |
| 16 | f' unbounded at 0, f'(x) ≈ (16/3) x^{-1/3} near 0 | d/dx: e^{-x}cos(8x^{2/3})·(16/3)x^{-1/3} - e^{-x}sin(...) -> (16/3)x^{-1/3} | confirmed |
| 17 | measured error shrinks like O(h^{5/3}) rather than O(h^4) | ratios E(h)/E(h/2): 3.380 (24->48), 3.221, 3.189, 3.180, 3.177, 3.176, 3.1754, 3.1751 (3072->6144) -> 2^{5/3}=3.17480 | confirmed |
| 18 | "halving h divides it by about 3.38 (from 24 to 48 subintervals)" | E(24)/E(48) = 3.38032 | confirmed |
| 19 | "tending to 2^{5/3} ≈ 3.17, instead of 16" | 2^{5/3}=3.1748; ratios above | confirmed |
| 20 | Wiring: `[Julia source](simpsonsaa.jl)`, embed `simpsonsaa.gif` | both files exist; manifest: committed GIF byte-identical to regenerated output of this script | confirmed |
| 21 | "Each animation below..." (plural) / "linked under each case" | one case, one script, one GIF; wording generic but not false | confirmed |

### 3. Implementation checks — `simpsonsaa.jl`

- **Is the method claimed.** Composite Simpson 1/3 rule with n even subintervals (`simpson_sum`), panels drawn as the quadratic through (x_{2k}, x_{2k+1}, x_{2k+2}) via a Vandermonde solve. Not a neighbouring method. The drawn panels' exact integrals sum to the reported approximation (diff <= 2.7e-15 for every n), so picture and number agree.
- **Numbers right.** Script (instrumented copy `review/instr.jl`) vs independent mpmath (`review/indep.py`, 30 digits), selected n:
  - n=2: 2.491261017 / 2.491261017
  - n=4: 1.611786329 / 1.611786329
  - n=24: 2.010369629 / 2.010369629
  - n=48: 2.014531336 / 2.014531336
  - n=72: 2.015399674 / 2.015399674
  - n=108: 2.015834216 / 2.015834216
  All 23 agree to every printed digit. Legacy GIF values for overlapping n also agree (e.g. n=40: 2.013890).
- **Reference values.** The script draws no reference; the page's "true integral ≈ 2.016280" verified as 2.0162797196 by two independent mpmath quadratures (singularity-removing substitution x=t^3 and a 39-piece split), agreeing to 30 digits.
- **Picture shows what was computed.** Viewed contact sheet, frame_002 (n=2), frame_024 (n=108). Dots at x_i, lines at x_{2k} up to f(x_{2k}), quadratic fills to y=0, annotations show n+1 and S_n with the correct index. Axis limits: y in [0, 2.1] contains f (range 0.3572 to 1.9198) and all drawn quadratics (range 0.3490 to 1.9759); x in [-0.03, 2.03] contains [0,2]. No clamping or masking. 24 frames = 1 opening + 23 partitions.
- Regeneration: manifest reports a clean run reproducing the committed GIF byte-identically.

