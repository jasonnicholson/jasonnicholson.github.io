# Gauss-Legendre Quadrature — animation review (round 3)

Page: `pages/numerical-methods/gauss-legendre-quadrature/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my own computation and with the frames. Every number the script computes matches an independent high-precision computation to at least 12 digits.

Observations that I judged not to be findings:
- The top-left annotation `Y = exp(-x) sin(8*x^(2/3)) + 1` (script line 109, x=0.24) begins under the y-tick label "2.0", so its first letter collides with the tick ("2.0Y = ..."). It is cosmetic and still readable.
- Script comment line 14 calls `n_seq` a "Legacy-like progression". Mathews' GIF uses n = 2, 4, ..., 40 and this script uses 2, 3, 4, 5, 6, 8, ..., 64. The page itself states the script's actual sequence correctly, so no reader is misled.
- The smooth-integrand contrast value "4×10⁻¹⁷ at n=16" is the true (exact-arithmetic) quadrature error, 4.17e-17. Evaluated in double precision, the same sum gives about -7.3e-16 because of roundoff. The page's claim is about the rule's error, so it is correct.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `gausslegendreaa.jl` | 0 | 8.9 | gausslegendreaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.12-13 | approximates ∫_a^b f by evaluating f at optimally chosen interior nodes and weighting | The script evaluates f at the n Gauss nodes, all inside (0,2) | confirmed |
| 2 | l.16-18 | On [-1,1], ∑ w_i g(t_i) with t_i the roots of P_n and w_i the associated weights | The script's Golub-Welsch nodes match mpmath Newton roots of P_n to ≤2.0e-15 and weights 2/((1-t²)P_n'(t)²) to ≤2.2e-15 for n=2,3,5,16,64 | confirmed |
| 3 | l.20-23 | x=(a+b)/2+(b-a)/2·t; ∫≈(b-a)/2 ∑ w_i f(...) | Script lines 38-39 apply exactly this map and scaling | confirmed |
| 4 | l.24 | exact for polynomials up to degree 2n-1 | Script's rule on [0,2]: relative error for x^(2n-1) ≤5e-15 (n=2,3,5,8,16); for x^(2n) it is -2.8e-2, -2.5e-3, -1.6e-5, -6.0e-9 for n=2,3,5,8 (n=16: the 2n-degree error, 2.8e-18 relative, is below double precision) | confirmed |
| 5 | l.29 | f(x)=1+e^{-x} sin(8x^{2/3}) on [0,2] | Script line 11-12; frame annotation "Y = exp(-x) sin(8*x^(2/3)) + 1" | confirmed |
| 6 | l.29 | opens with three frames of the integrand alone, the second also showing the reference value | Frames 1-3 show only the curve. Frames 1 and 3 have identical hashes. Frame 2 adds "True / Numerical Quadrature / I = 2.016280" | confirmed |
| 7 | l.29 | reference value I≈2.016280 | mpmath (substitution x=u³, and a direct split quad agree): I = 2.0162797196170963 → 2.016280. Script's trapezoid reference is 2.016279706128 (error -1.35e-8) | confirmed |
| 8 | l.29 | n = 2,3,4,5,6,8,10,…,20,24,28,…,48,56,64 | Script `n_seq` is exactly this. 3 intro + 21 = 24 frames, which matches the GIF frame count | confirmed |
| 9 | l.29 | recomputes nodes and weights across the full interval | Each frame calls `gauss_legendre_sum(n)` on all of [0,2], not a composite rule | confirmed |
| 10 | Case heading l.33 | Increasing-order Gauss-Legendre rule, f, [0,2] | as rows 5, 8 | confirmed |
| 11 | l.35 | each shaded bar has width w_i and height f(x_i), marked by a red dot at the node x_i, so its area is w_i f(x_i) | Script lines 43-49, 84-86, 105. Frames 4, 5, 8, 24: bar tops pass through the red dots at (x_i, f(x_i)). n=3 bar edges at 5/9 and 14/9 (≈0.556, 1.444) as drawn | confirmed |
| 12 | l.35 | bars laid end to end across [0,2] | Cumulative scaled weights end at 2.000000000000000 (±1e-15) for every n | confirmed |
| 13 | l.35 | each node lies inside its own bar | Instrumented check `bounds[i] < x[i] < bounds[i+1]` is true for all 21 n | confirmed |
| 14 | l.35 | as n grows the nodes become denser and the estimate settles toward I≈2.016280 | Errors fall from 3.2e-3 (n=6) to 1.86e-6 (n=64) | confirmed |
| 15 | l.35 | from n=6 on it decreases in every frame | I_n: n=5 2.014623 → n=6 2.019465 (increase), then strictly decreasing through n=64 (both script and mpmath) | confirmed |
| 16 | l.35 | last frame (n=64) gives 2.016282 | script 2.016281583861, mpmath 2.01628158386076; frame 24 shows "Approximation = 2.016282" | confirmed |
| 17 | l.35 | still about 1.9×10⁻⁶ high | vs true I: +1.864e-6; vs the script's reference: +1.878e-6 | confirmed |
| 18 | l.35 | x^{2/3} makes f' unbounded at 0, f'(x)≈(16/3)x^{-1/3} near 0 | mpmath: f'(1e-9)·x^{1/3} = 5.3333333 | confirmed |
| 19 | l.35 | textbook error order assumes smooth f, so it does not hold here | The standard error term needs f^{(2n)}. This f is not even C¹ on [0,2]. The observed error is algebraic, not geometric | confirmed |
| 20 | l.35 | error shrinks like O(n^{-10/3}) | Observed log₂ ratios: 3.30 (32→64), 3.32 (128→256), approaching 10/3. Matches theory for an x^α endpoint singularity, error ~ n^{-2α-2} with α=2/3 | confirmed |
| 21 | l.35 | doubling n divides it by about 9.8 (32 to 64), tending to 2^{10/3}≈10.08 | 32→64: 9.84 (true I), 9.78 (script reference). 64→128: 9.95. 128→256: 10.02. 2^{10/3}=10.079 | confirmed |
| 22 | l.35 | smooth 1+e^{-x} sin 8x on [0,2] has error 4×10⁻¹⁷ at n=16 | mpmath exact-arithmetic error at n=16: 4.166e-17 (double-precision evaluation is roundoff-limited, -7.3e-16) | confirmed |
| 23 | l.37 | `[Julia source](gausslegendreaa.jl)` | The file exists and is the script that produces this GIF | confirmed |
| 24 | l.39 | embed `gausslegendreaa.gif` | Committed GIF, byte-identical to the rerun | confirmed |
| 25 | l.39 alt | bars of width w_i, height f(x_i), red dot at each node; nodes increase from 2 to 64; estimate settles toward 2.016280, reaching 2.016282 at 64 nodes | as rows 7, 8, 11, 16 | confirmed |
| 26 | l.41-42 | compares I_n=∑ w_i f(x_i) against a high-resolution numerical reference | Here w_i are the scaled weights; on [0,2] (b-a)/2=1, so they equal the [-1,1] weights and the notation agrees with l.16. The reference is a 120001-point trapezoid, error 1.35e-8, which is enough for the 6-decimal comparison | confirmed |
| 27 | Frames, all | Title/annotations: "Sample Points = n", "Approximation = …" | Contact sheet values 2.332149, 2.014623, 2.017912, 2.016729, 2.016457, 2.016365, 2.016308, 2.016292, 2.016286, 2.016283 match the mpmath I_n for n=3,5,8,12,16,20,28,36,44,56 | confirmed |

### 3. Implementation checks — `gausslegendreaa.jl`

**Is the method it claims to be.** Yes. It runs the Golub-Welsch algorithm: eigenvalues of the symmetric tridiagonal Jacobi matrix with off-diagonals k/√(4k²-1) give the nodes, and w_i = 2·v_{1i}² gives the weights. This is a standard, legitimate way to compute the n-point Gauss-Legendre rule, and the single (non-composite) rule is mapped affinely to [0,2]. That matches the page's Description.

**The numbers are right.** I compared the script's nodes and weights (dumped to `review/nodes.txt`) against Legendre roots polished by `mp.findroot` on `mp.legendre(n,x)` and weights from 2/((1-t²)P_n'(t)²) at 30 digits. For n=2,3,5,16,64, the largest node difference was 2.0e-15 and the largest weight difference 2.2e-15. I_n from the instrumented script against an independent mpmath Gauss sum (40 digits, Newton on P_n):

| n | script I_n | mpmath I_n | error vs true I |
|---|---|---|---|
| 2 | 1.154627908484 | 1.15462790848444 | -8.617e-1 |
| 3 | 2.332149179135 | 2.33214917913519 | +3.159e-1 |
| 5 | 2.014622535920 | 2.01462253591991 | -1.657e-3 |
| 6 | 2.019465088565 | 2.01946508856529 | +3.185e-3 |
| 16 | 2.016456684783 | 2.01645668478277 | +1.770e-4 |
| 32 | 2.016298066545 | 2.01629806654537 | +1.835e-5 |
| 64 | 2.016281583861 | 2.01628158386076 | +1.864e-6 |

The script and mpmath agree to all 12 printed digits for all 21 n. Exactness holds to degree 2n-1 and fails at degree 2n (ledger row 4).

**The reference values are right.** `true_int` is a 120000-interval trapezoid sum, 2.016279706128. The true value is 2.0162797196170963, agreed by two independent mpmath quadratures (the substitution x=u³ removes the singularity). The reference error is -1.35e-8, which does not affect the 6-decimal "I = 2.016280" shown in frame 2 or any comparison on the page.

**The picture shows what was computed.** I viewed frames 2, 4 (n=2), 5 (n=3), 8 (n=6), 24 (n=64) and the contact sheet. Bars have left/right edges at a + cumulative weights and heights f(x_i). Red dots sit at (x_i, f(x_i)) on the bar tops, and a thin red vertical marks each node. The n=2 bars are [0,1] and [1,2], with nodes at 0.423 and 1.577. The n=3 edges are at 0.556 and 1.444. The curve drawn is the function in the code. The axes [0,2]×[0,2.1] contain the whole curve (max ≈1.92, min ≈0.36), so nothing is clamped or masked. The frame count is 24 (3 intro + 21). Annotated n and approximations match the computed values (ledger row 27).

**Fidelity to the legacy archive.** Mathews' module has one animation, Example 6, linked from lnk_8 to `a2001/.../GaussLegendreaa.gif`. It uses the same function y = e^{-x} sin(8x^{2/3}) + 1 on [0,2] and the same bar construction (bar widths equal to the weights, laid end to end, with the node dot on the bar top). Its n runs 2, 4, ..., 40, and its legacy approximations (n=2 1.154628, n=6 2.019465, n=10 2.017086, n=14 2.016553, n=18 2.016400, n=40 2.016288) match this script's values. The page extends the n range and adds a reference-value frame. These changes do not alter the example, and no archive case is dropped. No fidelity finding.

