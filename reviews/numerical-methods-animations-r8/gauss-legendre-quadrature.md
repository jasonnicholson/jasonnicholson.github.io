# Gauss-Legendre Quadrature — animation review (round 8)

Page: `pages/numerical-methods/gauss-legendre-quadrature/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and every value in the frames agrees with an independent computation (details below).

Not counted as findings (cosmetic, does not mislead): the small top-left label "Y = exp(-x) sin(8*x^(2/3)) + 1" touches the "2.0" y-tick; in frame 2 the text "I = 2.016280" slightly overlaps the curve near x = 1. The page's n-sequence (2,3,4,5,6,8,...,64) and the added "True I" intro frame differ from the legacy GIF (3 intro frames then n = 2,4,6,...,40); same function, interval and bar geometry, so this is not a fidelity issue a reader would notice.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `gausslegendreaa.jl` | 0 | 11.1 | gausslegendreaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "$t_i$ are roots of the Legendre polynomial $P_n(t)$ and $w_i$ are associated weights" | Script uses Golub–Welsch (Jacobi matrix, β_k = k/√(4k²−1), w = 2·v₁²). `nodes.jl`: max\|P_n(t_i)\| = 1.1e-16 (n=2), 3.0e-15 (n=3), 1.4e-14 (n=5), 4.6e-13 (n=64); n=2: t=±0.5773502692, w=1,1; n=3: t=0,±0.7745966692, w=0.8888888889, 0.5555555556 | confirmed |
| D2 | Change of variable $x=\frac{a+b}{2}+\frac{b-a}{2}t$ and the $\frac{b-a}{2}\sum w_i f(\cdot)$ formula | Script lines 38–40 implement exactly this | confirmed |
| D3 | "exact for polynomials up to degree $2n-1$" | `nodes.jl` on [-1,1]: error at degree 2n−2/2n−1 ~1e-16, at degree 2n 1.8e-1 (n=2), 4.6e-2 (n=3), 2.9e-3 (n=5); `indep.py` on [0,2]: degree 2n−1 rel. error ≤1e-15, degree 2n 2.8e-2, 2.5e-3, 2.0e-4… for n=2,3,4 | confirmed |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | Script line 11–12; frame label "Y = exp(-x) sin(8*x^(2/3)) + 1" | confirmed |
| A2 | "opens with three frames of the integrand alone, the second also showing the reference value $I\approx2.016280$" | Frames 1–3: curve only; frame 2 adds "True / Numerical Quadrature / I = 2.016280" | confirmed |
| A3 | Reference $I\approx2.016280$ | mpmath (substitution x=u³, 30 digits): I = 2.0162797196170963; script's trapezoid reference 2.016279706128 (error −1.35e-8). Both round to 2.016280 | confirmed |
| A4 | "$n=2,3,4,5,6,8,10,\dots,20,24,28,\dots,48,56,64$" | `n_seq` lines 15–16 identical; 3 + 21 = 24 frames = GIF frame count | confirmed |
| A5 | "recomputes nodes and weights across the full interval" | `gauss_legendre_sum(n)` called per frame on [a,b] (not composite) | confirmed |
| B1 | "Each shaded bar has width $w_i$ and height $f(x_i)$ … its area is the term $w_i f(x_i)$" | Bar width = scaled weight (b−a)/2·w_i = w_i since (b−a)/2 = 1; height f(x_i) (lines 43–49, 84) | confirmed |
| B2 | "marked by a red dot at the node $x_i$" | `scatter!(x_nodes, f.(x_nodes))`, visible in frames | confirmed |
| B3 | "bars are laid end to end across $[0,2]$" | bounds = a + cumsum(w); final bound = 2.000000000000000 (±1e-15) for every n (`instr.jl`) | confirmed |
| B4 | "each node lies inside its own bar" | `instr.jl`: bounds[i] < x_i < bounds[i+1] true for all 21 n (also the Chebyshev–Markov–Stieltjes separation property) | confirmed |
| B5 | "the estimate settles toward $I\approx2.016280$" | approximations converge to 2.0162797 (table below) | confirmed |
| B6 | "from $n=6$ on it decreases in every frame" | 2.019465 (6) > 2.017912 (8) > … > 2.016282 (64), strictly decreasing; n=5→6 increases, so "from 6 on" is the correct start | confirmed |
| B7 | "the last frame ($n=64$) gives 2.016282" | script 2.016281583861, numpy 2.016281583861; frame 24 reads "Approximation = 2.016282" | confirmed |
| B8 | "still about $1.9\times10^{-6}$ high" | error = +1.864e-6 vs mpmath I | confirmed |
| B9 | "$f'(x)\approx \frac{16}{3}x^{-1/3}$ near 0" | mpmath f'(1e-6) = 533.332; 16/3·(1e-6)^(-1/3) = 533.333 | confirmed |
| B10 | "error shrinks only algebraically, like $O(n^{-10/3})$" | endpoint behaviour f−1 ~ 8x^{2/3} gives Gauss–Legendre error ~ n^{−2α−2} = n^{−10/3}; measured ratios e(16)/e(32)=9.65, e(24)/e(48)=9.77, e(28)/e(56)=9.81, e(32)/e(64)=9.84 approaching 2^{10/3}=10.08 | confirmed |
| B11 | "doubling $n$ divides it by about 9.8 (from 32 to 64 nodes), tending to $2^{10/3}\approx 10.08$" | 9.84; 10.079 | confirmed |
| B12 | "smooth integrand $1+e^{-x}\sin 8x$ … error about $1.8\times10^{-13}$ at $n=14$" | numpy vs mpmath (I = 2.139627760200246): n=14 error 1.843e-13 | confirmed |
| B13 | "reaches … about $10^{-15}$ or less by $n=16$" | n=15 −4.0e-15, n=16 −4.4e-16, n=18,20 0 | confirmed |
| W1 | `[Julia source](gausslegendreaa.jl)` link | file exists, is the script that produces the GIF | confirmed |
| W2 | Embed `gausslegendreaa.gif` | exists; byte-identical to regeneration | confirmed |
| W3 | Alt text: "bars of width w_i and height f(x_i), with a red dot at each node, recomputed as the number of nodes increases from 2 to 64 … settles toward 2.016280, reaching 2.016282 at 64 nodes" | as B1, B2, A4, B5, B7 | confirmed |
| W4 | "compares $I_n$ … against a high-resolution numerical reference" | 120001-point trapezoid, error 1.35e-8, ample for the 6-decimal display | confirmed |
| L1 | Fidelity to legacy GIF | Legacy: same f, same [0,2], same weight-width bars with red node dots, n = 2 → 1.154628 (script: 1.154628), n=10 2.017086, n=14 2.016553, n=18 2.016400, all equal to the script's/numpy values; legacy final n=40 2.016288 (script n=40: 2.016288522). Page uses a different n-sequence extending to 64 | confirmed (no material departure) |

### 3. Implementation checks — `gausslegendreaa.jl`

**Is the method it claims.** Standard n-point Gauss–Legendre on [-1,1] via Golub–Welsch, mapped affinely to [0,2], single (non-composite) rule recomputed for each n. Nodes are roots of P_n (residual ≤4.6e-13 at n=64), weights reproduce the classical n=2,3 tables, and degree of precision is exactly 2n−1 (exact through 2n−1, fails at 2n).

**Numbers are right.** Script (`instr.jl`) vs independent numpy `leggauss` (`indep.py`), and error vs mpmath I = 2.01627971961709633:

| n | script | numpy | error |
|---|---|---|---|
| 2 | 1.154627908484 | 1.154627908484 | −8.62e-1 |
| 3 | 2.332149179135 | 2.332149179135 | 3.16e-1 |
| 4 | 2.106663539469 | 2.106663539469 | 9.04e-2 |
| 5 | 2.014622535920 | 2.014622535920 | −1.66e-3 |
| 6 | 2.019465088565 | 2.019465088565 | 3.19e-3 |
| 8 | 2.017911793793 | 2.017911793793 | 1.63e-3 |
| 10 | 2.017086196889 | 2.017086196889 | 8.07e-4 |
| 12 | 2.016728860798 | 2.016728860798 | 4.49e-4 |
| 14 | 2.016552638074 | 2.016552638074 | 2.73e-4 |
| 16 | 2.016456684783 | 2.016456684783 | 1.77e-4 |
| 20 | 2.016365279015 | 2.016365279015 | 8.56e-5 |
| 32 | 2.016298066545 | 2.016298066545 | 1.84e-5 |
| 48 | 2.016284543986 | 2.016284543986 | 4.82e-6 |
| 56 | 2.016282618898 | 2.016282618898 | 2.90e-6 |
| 64 | 2.016281583861 | 2.016281583861 | 1.86e-6 |

All 21 values agree to 12 decimals (intermediate n omitted here; all printed by both scripts).

**Reference value.** Trapezoid with 120001 points gives 2.016279706128; true 2.016279719617 (mpmath on the u³-substituted smooth integrand, cross-checked with a split-interval mpmath quad to 30 digits). Error 1.35e-8, invisible at the 6 decimals shown.

**Picture shows what was computed.** Frames 1–3 integrand only, frame 2 with "I = 2.016280". Frames 4–24 show n = 2…64 with "Sample Points = n" and "Approximation" text matching the table (checked frames 5 [n=3, 2.332149], sheet frames for n=5,8,12,16,20,28,36,44,56, and frame 24 [n=64, 2.016282]). Bars span [cumsum boundaries] with height f(x_i); red dots sit at (x_i, f(x_i)) on the top edge of each bar and inside it. Axis limits [0,2]×[0,2.1] contain the whole curve (max f ≈ 1.92) and all bars; no clamping or masking.

