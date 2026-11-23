# Gauss-Legendre Quadrature — animation review (round 6)

Page: `pages/numerical-methods/gauss-legendre-quadrature/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page passed against my independent computation and the frames. Neither the script nor the page has an error, a misleading statement, or a minor issue worth fixing.

These observations do not rise to findings:
- Script line 14 calls `n_seq` a "Legacy-like progression". The legacy GIF uses n = 2, 4, 6, …, 40 (legacy frames: n=2 → 1.154628, n=6 → 2.019465, n=10 → 2.017086, …, n=40 → 2.016288). The new GIF uses 2, 3, 4, 5, 6, 8, …, 64. The page states its own sequence correctly, the function and interval match the legacy example, and the values at shared n agree (n=2, 6, 10, 14, 18, 40 match to 6 decimals). A reader does not lose anything.
- Intro frame 2 prints "True / Numerical Quadrature / I = 2.016280" on three lines. The wording is clumsy, but the page explains that this is the reference value. The "Y = …" label slightly overlaps the "2.0" y-tick. Both are cosmetic and readable.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `gausslegendreaa.jl` | 0 | 12.4 | gausslegendreaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page claim (own words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| D1 | "$t_i$ are roots of the Legendre polynomial $P_n(t)$" | Description | `exact.jl`: the script's Golub–Welsch nodes give max \|P_n(t_i)\| = 1.4e-14 (n=5), 1.4e-13 (n=20), 4.6e-13 (n=64) | confirmed |
| D2 | $\int_{-1}^1 g \approx \sum w_i g(t_i)$ with associated weights | Description | Script weights 2·v₁ᵢ² (Golub–Welsch). They match numpy `leggauss`, because the sums agree to 12 digits for every n (see §3) | confirmed |
| D3 | Interval map $x=\frac{a+b}{2}+\frac{b-a}{2}t$, factor $\frac{b-a}{2}$ | Description | Script lines 38–39 implement exactly this | confirmed |
| D4 | "The rule is exact for polynomials up to degree $2n-1$" | Description | `exact.jl`: max monomial error for degree ≤ 2n−1 is ≤ 2.3e-15 for n=2,3,5,8,16,64. Degree 2n is not exact (error −0.178 at n=2, −2.9e-3 at n=5, −7.2e-10 at n=16) | confirmed |
| A1 | Function $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | intro, heading, line 41 | Script line 11–12; the frame label "Y = exp(-x) sin(8*x^(2/3)) + 1" | confirmed |
| A2 | "opens with three frames of the integrand alone, the second also showing the reference value $I\approx2.016280$" | intro | Frames 1 and 3 have the same hash (f6ca0e…) and show only the curve and title. Frame 2 shows "I = 2.016280" | confirmed |
| A3 | $I\approx2.016280$ | intro, Behavior, alt | mpmath (substitution x=u³, 40 digits): I = 2.0162797196170963. The script's trapezoid reference is 2.016279706128 (error 1.3e-8). Both round to 2.016280 | confirmed |
| A4 | n = 2,3,4,5,6,8,10,…,20,24,28,…,48,56,64 | intro | Script `n_seq` is the same. There are 21 frames after the intro, 24 frames in total | confirmed |
| A5 | "recomputes nodes and weights across the full interval" | intro | A single (non-composite) n-point rule is computed on [0,2] for each frame (`gauss_legendre_sum`) | confirmed |
| A6 | Case 1 heading: increasing-order Gauss-Legendre rule, f, [0,2] | heading | as A1, A4 | confirmed |
| B1 | "Each shaded bar has width $w_i$ and height $f(x_i)$ … area is the term $w_i f(x_i)$" | Behavior | Script lines 43–49, 84. On [0,2] the scale (b−a)/2 = 1, so the scaled weight equals $w_i$ | confirmed |
| B2 | "marked by a red dot at the node $x_i$" | Behavior | `scatter!` at (x_i, f(x_i)) is visible in frames 4–24 | confirmed |
| B3 | "bars are laid end to end across $[0,2]$" | Behavior | `inst.out`: the last bound is 2.000000000000000 (±1e-15) for every n | confirmed |
| B4 | "each node lies inside its own bar" | Behavior | `inst.out`: `inside=true` for all 21 n. The nodes are sorted (`sorted=true`). This is consistent with the Chebyshev–Markov–Stieltjes separation property | confirmed |
| B5 | "As $n$ grows … the estimate settles toward $I\approx2.016280$" | Behavior | errors: −0.862, 0.316, 0.090, −1.66e-3, 3.19e-3, 1.63e-3, … , 1.86e-6 | confirmed |
| B6 | "from $n=6$ on it decreases in every frame" | Behavior | `indep.py`: the value increases from n=5 to n=6, then decreases strictly over n = 8,…,64 | confirmed |
| B7 | "last frame ($n=64$) gives 2.016282" | Behavior, alt | script 2.016281583861 → 2.016282. Frame 24 shows "Approximation = 2.016282" | confirmed |
| B8 | "still about $1.9\times10^{-6}$ high" | Behavior | true error +1.864e-6 (against the script's own reference, +1.878e-6) | confirmed |
| B9 | "$x^{2/3}$ makes $f'$ unbounded at 0, $f'\approx\frac{16}{3}x^{-1/3}$" | Behavior | $f' = e^{-x}[\cos(8x^{2/3})\cdot\frac{16}{3}x^{-1/3} - \sin(8x^{2/3})]$, which tends to $\frac{16}{3}x^{-1/3}$ as x→0 | confirmed |
| B10 | the textbook error order does not hold | Behavior | the measured decay is algebraic, not spectral (B11) | confirmed |
| B11 | the error shrinks like $O(n^{-10/3})$ | Behavior | Fitted log-log slope over the last 8 frames is −3.297. Theory for an endpoint $x^{\alpha}$ term (α=2/3) gives $n^{-2-2\alpha}=n^{-10/3}$ | confirmed |
| B12 | "doubling $n$ divides it by about 9.8 (from 32 to 64 nodes)" | Behavior | true ratio 9.841 (against the script reference, 9.78) | confirmed |
| B13 | "tending to $2^{10/3}\approx10.08$" | Behavior | 2^(10/3)=10.079. Ratios per doubling: 64→128: 9.95, 128→256: 10.02, 256→512: 10.05, 512→1024: 10.06 | confirmed |
| B14 | smooth $1+e^{-x}\sin 8x$ on [0,2]: error about $1.8\times10^{-13}$ at n=14 | Behavior | `indep.py`: 1.843e-13 (I_smooth = 2.1396277602002457) | confirmed |
| B15 | the smooth integrand reaches round-off (about 1e-15 or less) by n=16 | Behavior | n=15: −4.0e-15, n=16: −4.4e-16, n=17: −8.9e-16, n=18: 0 | confirmed |
| W1 | Link `[Julia source](gausslegendreaa.jl)` | page | the file exists and is the only script. The manifest shows it regenerates a byte-identical GIF | confirmed |
| W2 | Embed `gausslegendreaa.gif` | page | it is the script's output, 24 frames | confirmed |
| W3 | Alt text: bars of width w_i and height f(x_i), red dot at each node, nodes 2 to 64, settles toward 2.016280, reaches 2.016282 at 64 | alt | as B1, B2, A4, A3, B7 | confirmed |
| W4 | "compares $I_n$ against a high-resolution numerical reference" | line 41 | Composite trapezoid with 120001 points. Its error of 1.3e-8 is below 0.7% of the smallest error shown (1.9e-6), so it is adequate for the 6-decimal display and for the 9.8 ratio | confirmed |

### 3. Implementation checks — `gausslegendreaa.jl`

**It is the method it claims to be.** Nodes and weights come from the Golub–Welsch eigen-decomposition of the Jacobi matrix for Legendre polynomials (off-diagonal k/√(4k²−1), weights 2·(first eigenvector component)²). This is a standard, legitimate way to construct the n-point Gauss–Legendre rule. For each n, the script applies one full-interval (non-composite) rule mapped affinely to [0,2], which is what the page describes. The degree-of-exactness check (D4) and the Legendre-root check (D1) confirm that the rule is Gauss–Legendre and not some other rule.

**The numbers are right.** Script values (`inst.out`) set beside the independent numpy `leggauss` sums (`indep.py`). Every value agrees to all 12 printed digits.

| n | script | independent | true error |
|---|---|---|---|
| 2 | 1.154627908484 | 1.154627908484 | −8.6165e-01 |
| 3 | 2.332149179135 | 2.332149179135 | 3.1587e-01 |
| 5 | 2.014622535920 | 2.014622535920 | −1.6572e-03 |
| 6 | 2.019465088565 | 2.019465088565 | 3.1854e-03 |
| 16 | 2.016456684783 | 2.016456684783 | 1.7697e-04 |
| 32 | 2.016298066545 | 2.016298066545 | 1.8347e-05 |
| 48 | 2.016284543986 | 2.016284543986 | 4.8244e-06 |
| 64 | 2.016281583861 | 2.016281583861 | 1.8642e-06 |

(All 21 values agree; see `inst.out` and the `indep.py` output.) The values the legacy GIF shows for n = 2, 6, 10, 14, 18, 40 match these as well.

**Its reference values are right.** I computed the true integral independently with mpmath at 40 digits after the substitution x=u³, which removes the endpoint singularity: I = 2.01627971961709633. Direct mpmath quadrature over subintervals agrees. The script's trapezoid reference is 2.016279706128, off by 1.35e-8. That is ample for the 6-decimal "I = 2.016280" and immaterial to the error claims (B8, B12).

**The picture shows what was computed.** I viewed frames 2, 4 (n=2), 5 (n=3) and 24 (n=64) individually, and the contact sheet covering frames 1, 3, 5, …, 23.
- Each bar spans [a+Σ_{j<i}w_j, a+Σ_{j≤i}w_j] with height f(x_i). The red dot and the red vertical line sit at x_i inside that bar. For example, n=2: nodes 0.4226 and 1.5774 lie in bars [0,1] and [1,2]. n=3: bars [0,0.556], [0.556,1.444], [1.444,2] contain nodes 0.2254, 1.0, 1.7746.
- The magenta curve is f.
- The on-frame "Sample Points = n" and "Approximation = …" values equal the computed values for that frame.
- Axis limits [0,2]×[0,2.1] contain the whole curve (max f ≈ 1.917 near x≈0.087, min f > 0). No clamping or masking is used.
- Frame order and count (3 intro + 21) match `frame_states`.

