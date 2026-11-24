# Gauss-Legendre Quadrature — animation review (round 9)

Page: `pages/numerical-methods/gauss-legendre-quadrature/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and every number in the frames agreed with independent computation at the precision stated. Details are in the ledger and checks below.

Observations that are deliberately *not* findings:
- The script comment on line 14 calls `n_seq` a "Legacy-like progression". The legacy GIF uses n = 2, 2, 4, 6, ..., 40 (n=2 shown twice, step 2, max 40); the script uses 2,3,4,5,6,8,...,20,24,...,48,56,64. The page itself makes no claim that the sequence matches the archive, and the extension to 64 nodes is what supports the page's convergence-rate discussion, so this is not a reader-relevant departure.
- Intro frame 2 labels the trapezoid-rule reference "True ... I = 2.016280". The reference is a 120000-interval trapezoid sum with error -1.35e-8, so the 6-decimal value shown is the true value; the label is accurate at the displayed precision.
- Cosmetic: the formula label at the upper left touches the "2.0" y tick label, and in frame 2 the line "I = 2.016280" crosses the magenta curve. Both remain readable.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `gausslegendreaa.jl` | 0 | 15.0 | gausslegendreaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `gausslegendreaa.gif` | 24 | byte-identical | gausslegendreaa |

### Page references

- Scripts linked: `gausslegendreaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description l.12-13 | approximates the integral by evaluating f at interior nodes and weighting | script `gauss_legendre_sum`: x = (a+b)/2 + (b-a)/2 t, sum of wt.*f(x); all nodes strictly inside (0,2) | confirmed |
| D2 | l.15-18 | n-point rule on [-1,1] is sum w_i g(t_i), t_i roots of P_n | script nodes vs numpy `leggauss`: max abs diff 1.6e-15 (n=6), 1.4e-15 (n=20), 1.3e-15 (n=64); max abs P_n(t_i) 4.7e-13 at n=64 | confirmed |
| D3 | l.20-23 | affine map and (b-a)/2 factor for [a,b] | lines 38-39 implement exactly this map and factor | confirmed |
| D4 | l.24 | exact for polynomials up to degree 2n-1 | script rule on [-1,1], monomials t^k: errors <= 2.9e-15 for k <= 2n-1, and at k = 2n: 1.8e-1 (n=2), 4.6e-2 (n=3), 2.9e-3 (n=5), 4.7e-5 (n=8) | confirmed |
| A1 | l.28-29 | f(x) = 1+e^{-x} sin(8x^{2/3}) on [0,2] | script line 11-12; frame label "Y = exp(-x) sin(8*x^(2/3)) + 1" | confirmed |
| A2 | l.29 | opens with three frames of the integrand alone | frames 1-3: curve only, no bars | confirmed |
| A3 | l.29 | the second also shows the reference value I ≈ 2.016280 | frame 2 shows "True / Numerical Quadrature / I = 2.016280"; frames 1 and 3 do not | confirmed |
| A4 | l.29 | I ≈ 2.016280 | mpmath (dps 40, substitution x=u^3): I = 2.0162797196170963; script reference 2.016279706128 (err -1.35e-8) | confirmed |
| A5 | l.29 | n = 2,3,4,5,6,8,10,...,20,24,28,...,48,56,64 | `n_seq` line 15-16 matches exactly; frames 4-24 captions Sample Points 2 ... 64 | confirmed |
| A6 | l.29 | recomputes nodes and weights across the full interval for each frame | `gauss_legendre_sum(n)` called fresh per frame on [0,2] | confirmed |
| A7 | l.33 heading | Increasing-order Gauss-Legendre rule, same f, [0,2] | as A1, A5 | confirmed |
| B1 | l.35 | each shaded bar has width w_i and height f(x_i) | `weighted_rectangles`: widths = wt = (b-a)/2·w_i = w_i since (b-a)/2 = 1; heights = f.(x_nodes) | confirmed |
| B2 | l.35 | red dot at the node x_i | scatter at (x_i, f(x_i)), top edge of bar i (frames 4, 5, 24 inspected) | confirmed |
| B3 | l.35 | area of bar is the term w_i f(x_i) | follows from B1 | confirmed |
| B4 | l.35 | bars laid end to end across [0,2] | bounds = a + cumsum(wt); last bound 2.000000000000000 ± 1e-15 for every n | confirmed |
| B5 | l.35 | each node lies inside its own bar | instrumented check bounds[i] < x_i < bounds[i+1] true for all 21 n | confirmed |
| B6 | l.35 | estimate settles toward I ≈ 2.016280 | errors shrink from 3.2e-3 (n=6) to 1.86e-6 (n=64) | confirmed |
| B7 | l.35 | from n=6 on it decreases in every frame | I_n for n = 6,8,...,64: 2.019465, 2.017912, 2.017086, 2.016729, 2.016553, 2.016457, 2.016400, 2.016365, 2.016327, 2.016308, 2.016298, 2.016292, 2.016289, 2.016286, 2.016285, 2.016283, 2.016282 — strictly decreasing (and 5→6 increases, so "from 6 on" is the right start) | confirmed |
| B8 | l.35 | last frame (n=64) gives 2.016282 | script 2.016281583861 → "%.6f" 2.016282; frame 24 shows "Approximation = 2.016282" | confirmed |
| B9 | l.35 | still about 1.9e-6 high | 2.016281583861 − 2.016279719617 = +1.864e-6 | confirmed |
| B10 | l.35 | f'(x) ≈ (16/3) x^{-1/3} near 0, unbounded | mpmath f'(1e-9) = 5333.33332, (16/3)(1e-9)^{-1/3} = 5333.33333 | confirmed |
| B11 | l.35 | textbook error order assumes smooth f, does not hold here | follows from B10 and B12 | confirmed |
| B12 | l.35 | error shrinks like O(n^{-10/3}) | local exponents log2(e_n/e_2n): 3.270 (16→32), 3.281 (20→40), 3.289 (24→48), 3.294 (28→56), increasing toward 10/3 = 3.333; consistent with the endpoint-singularity rate n^{-(2+2α)}, α = 2/3 | confirmed |
| B13 | l.35 | doubling n divides it by about 9.8 (32 to 64) | e_32/e_64 = 1.8347e-5 / 1.8642e-6 = 9.84 | confirmed |
| B14 | l.35 | tending to 2^{10/3} ≈ 10.08 | 2^{10/3} = 10.0794; ratios rise 9.65, 9.72, 9.77, 9.81, 9.84 | confirmed |
| B15 | l.35 | smooth 1+e^{-x} sin 8x on [0,2]: error about 1.8e-13 at n=14 | numpy leggauss vs mpmath: +1.84e-13 | confirmed |
| B16 | l.35 | reaches round-off level (about 1e-15 or less) by n=16 | n=15: -3.8e-15; n=16: -2.9e-16; n=17,18,20: ≤ 7.3e-16 | confirmed |
| W1 | l.37 | [Julia source](gausslegendreaa.jl) | file exists, is the script that writes `gausslegendreaa.gif` | confirmed |
| W2 | l.39 | embed gausslegendreaa.gif | file exists; regenerated byte-identical | confirmed |
| W3 | l.39 alt | bars of width w_i, height f(x_i), red dot at each node, nodes 2 to 64, settles toward 2.016280, 2.016282 at 64 | as B1, B2, A5, A4, B8 | confirmed |
| W4 | l.41-42 | compares I_n against a high-resolution numerical reference | 120001-point trapezoid, error 1.35e-8 — adequate for 6-decimal display and for the 1.9e-6 error claim (0.7 % relative effect on B9) | confirmed |
| C1 | count | 24 frames (3 intro + 21 n values) | manifest 24 frames; 3 + length(n_seq)=21 | confirmed |

### 3. Implementation checks — `gausslegendreaa.jl`

**It is the method it claims to be.** Nodes and weights come from the Golub-Welsch eigenvalue method on the Legendre Jacobi matrix (off-diagonal k/sqrt(4k²−1), weights 2·v₁²). That is standard n-point Gauss-Legendre, not a neighbouring rule. Independent checks: nodes and weights match numpy `leggauss` to within 2.5e-15 for n = 2, 6, 20, 64. P_n(t_i) ≈ 0 to 4.7e-13. Degree of precision is exactly 2n−1: monomials of degree ≤ 2n−1 are exact to 3e-15, and degree 2n fails for n = 2, 3, 5, 8.

**The numbers are right.** Script I_n (instrumented `instr.jl`) vs independent numpy `leggauss` sum (`indep.py`) agree to all 12 printed digits for every n in `n_seq`. Examples:

| n | script I_n | independent I_n | error vs mpmath I |
|---|---|---|---|
| 2 | 1.154627908484 | 1.154627908484 | −8.62e-1 |
| 6 | 2.019465088565 | 2.019465088565 | +3.19e-3 |
| 20 | 2.016365279015 | 2.016365279015 | +8.56e-5 |
| 32 | 2.016298066545 | 2.016298066545 | +1.83e-5 |
| 64 | 2.016281583861 | 2.016281583861 | +1.86e-6 |

These also agree with the captions in Mathews' original GIF wherever the n values coincide (2: 1.154628, 4: 2.106664, 6: 2.019465, 8: 2.017912, 10: 2.017086, ..., 40: 2.016288), which is a third independent source.

**Its reference values are right.** The reference is a composite trapezoid sum with 120000 intervals: 2.016279706128173. mpmath quad after the substitution x = u³ (which removes the singularity) gives 2.0162797196170963. A second mpmath quad with breakpoints gives the same value to 20 digits. The reference error is −1.35e-8, which is far below the 6-decimal display and does not affect the page's 1.9e-6 or 9.8 claims.

**The picture shows what was computed.** I inspected frames 1-5, 24 and the contact sheet (frames at n = 3, 5, 8, 12, 16, 20, 28, 36, 44, 56).
- Bars run from cumulative-weight bounds, with height f(x_i). The red dots sit at (x_i, f(x_i)) on each bar's top edge.
- At n=2 the bars are [0,1] and [1,2] (weights 1, 1), and the dots are at x = 1 ∓ 0.57735, which matches the computation.
- Captions show "Sample Points = n" and "Approximation = I_n" with the right n and value.
- The axis window [0,2]×[0,2.1] contains the whole curve (range about 0.36 to 1.92), so nothing is clipped or clamped.
- The frame count is 24.

### Legacy fidelity

- The function, interval, bar construction (width = weight, laid end to end, height at node) and caption layout all match Mathews' GIF.
- Mathews' n sequence is 2, 2, 4, ..., 40. The page uses a different, longer sequence up to 64 and adds odd 3 and 5. The page does not claim the legacy sequence, and no example is dropped.
- Mathews' intro frames show no reference value. The page's added "True I" frame is correct.

No fidelity findings.

