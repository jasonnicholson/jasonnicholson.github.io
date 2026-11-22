# Gauss-Legendre Quadrature — animation review (round 2)

Page: `pages/numerical-methods/gauss-legendre-quadrature/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Bars are not the legacy weight-by-sample bars; end bars sit about 18% below the curve in every frame
- **Kind:** Fidelity (it also affects what the picture shows). **Severity:** Minor.
- **Location:** `gausslegendreaa.jl` lines 41–53 (`weighted_rectangles`), and the header comment on line 2, "legacy-style bar visualization".
- **What is there now:** Each bar spans the cell between midpoints of neighbouring nodes, with `a` and `b` as the outer ends. Its height is `w_i f(x_i) / width_i`. The bar *area* equals the weighted contribution $w_i f(x_i)$, which I checked: the sum of areas minus the approximation is ≤ 4e-16 for every n. But the bar *height* is not the sample value $f(x_i)$, and the bar *width* is not the weight $w_i$. Instrumented ratios height/f(x_i) (`julia ratio.jl`):
  - n=3: interior 1.148, end bars 0.907.
  - n=6: 0.843 to 1.040.
  - n=18: end bars 0.822.
  - n=64: end bars 0.819.

  The two end bars therefore sit about 18% below the curve in *every* frame, however large n gets. This is visible: in frame 14 (n=18) the last bar tops out at about 0.84, while the curve at x≈2 is about 1.0. In frame 8 (n=6) the first bar is at 1.61 while the node line rises to f(0.0675)=1.91. A viewer reading the bars like a Riemann sum would conclude the rule under-samples near the endpoints, which is not what is happening.
- **What the legacy does instead:** In Mathews' animation (legacy frame 7, n=6), the bar edges are at pixel x ≈ 77, 185, 325, 466 and 574, with 300 px per unit starting at 25. That puts them at x ≈ 0.173, 0.533, 1.000, 1.47 and 1.83, which are the cumulative weights 0.171, 0.532, 1.000, 1.468 and 1.829. So the legacy bar has width $w_i$ and height $f(x_i)$, with a red dot at $(x_i,f(x_i))$ on its top edge. The picture shows both the weight and the sample, and the script's comment "legacy-style" is not accurate.
- **Suggested correction:** Use `bounds = a .+ [0; cumsum(wt)]` and `heights = f.(x_nodes)`, and optionally add a dot at each $(x_i, f(x_i))$. I checked that this is well-formed. With cumulative-weight cells, every node lies strictly inside its own cell for every n in `n_seq` (`julia sep.jl` → `true`, the Chebyshev–Markov–Stieltjes separation property), and the bar area is unchanged. Alternatively, keep the current construction but fix the header comment and add a sentence to the page saying that bar *area*, not height, is $w_i f(x_i)$.

- **Independent check:** not run (Minor finding, unverified)

### F2. Two on-frame numbers lose their trailing zeros, so they show fewer digits than the others
- **Kind:** Implementation (display). **Severity:** Minor.
- **Location:** `gausslegendreaa.jl` line 96 `"Approximation = $(round(approx; digits=6))"` and line 100 `"I = $(round(true_int; digits=6))"`.
- **What is there now:** Frame 14 (n=18) reads "Approximation = 2.0164", while every other frame shows 6 decimals. The computed value is 2.016400352, so the correct 6-decimal display is 2.016400. Frame 2 reads "I = 2.01628", while the page text says 2.016280. Neither number is wrong, but the n=18 frame looks as if it has jumped to a less precise value.
- **How I know:** `julia inst.jl` printed `n= 18 approx=2.016400352437904 disp=2.0164` and `true_int … round6=2.01628`. I viewed `committed/gausslegendreaa/frame_014.png` and `frame_002.png`.
- **Suggested correction:** Format with a fixed number of decimals, for example `using Printf; @sprintf("Approximation = %.6f", approx)` and `@sprintf("I = %.6f", true_int)`.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `gausslegendreaa.jl` | 0 | 8.1 | gausslegendreaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description | GL evaluates $f$ "at optimally chosen interior nodes and weighting those values" | Nodes are roots of $P_n$, all in (−1,1); the rule has the maximal degree of precision 2n−1 | confirmed |
| D2 | Description | $\int_{-1}^1 g \approx \sum w_i g(t_i)$, $t_i$ roots of $P_n$, $w_i$ associated weights | Script (Golub–Welsch, $\beta_k=k/\sqrt{4k^2-1}$, $w=2v_1^2$) gives n=5 nodes ±0.9061798459, ±0.5384693101, 0 and weights 0.2369268851, 0.4786286705, 0.5688888889. These equal `numpy.polynomial.legendre.leggauss(5)`. Nodes for n=2, 3, 64 also agree. | confirmed |
| D3 | Description | Map $x=\frac{a+b}2+\frac{b-a}2 t$ and $\int_a^b f\approx\frac{b-a}2\sum w_i f(\cdot)$ | Matches the script's lines 36–37. A high-precision mpmath GL built from my own Newton-on-$P_n$ nodes with this formula reproduces the script's values (see §3). | confirmed |
| D4 | Description | "exact for polynomials up to degree $2n-1$" | `julia dop.jl` with the script's own nodes and weights. Monomial error at degree 2n−1 and 2n−2 is ≤ 2.3e-15 for n=2, 3, 5, 8, 16. At degree 2n the error is −0.178, −0.0457, −2.9e-3, −4.7e-5 and −7.2e-10, so the rule is not exact beyond 2n−1. | confirmed |
| A1 | Intro | Function $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | Script line 9 and `a, b = 0.0, 2.0`. On-frame label "Y = exp(-x) sin(8*x^(2/3)) + 1". Same as the legacy GIF. | confirmed |
| A2 | Intro | "opens with three frames of the integrand alone" | Frames 1–3 show the curve only, with no bars (frame hashes: 1 and 3 identical, 2 differs only in text) | confirmed |
| A3 | Intro | "the second also showing the reference value $I\approx2.01628$" | Frame 2 text reads "True / Numerical Quadrature / I = 2.01628". The independent value is I = 2.0162797196170963 (mpmath, after substituting x=u³). | confirmed |
| A4 | Intro | "Each later frame uses more nodes, $n=2,3,4,5,6,8,10,\dots,20,24,28,\dots,48,56,64$" | `n_seq` = [2,3,4,5,6,8,10,12,14,16,18,20,24,28,32,36,40,44,48,56,64], which gives 21 frames, 24 in total. The frames' "Sample Points" labels match. | confirmed |
| A5 | Intro | "recomputes nodes and weights across the full interval" | `gauss_legendre_sum(n)` calls the eigen-solver fresh for each n over all of [a,b], with no subdivision | confirmed |
| A6 | Case heading | "Increasing-Order Gauss-Legendre Rule, $f$… on $[0,2]$" | As A1 and A4 | confirmed |
| B1 | Behavior | "shaded bars visualize weighted sample contributions built from Gauss-Legendre nodes" | Bar area equals $w_i f(x_i)$ exactly (sum of areas = approximation to ≤ 4e-16). Heights are not $f(x_i)$; see F1. | confirmed (narrowly; see F1) |
| B2 | Behavior | "As $n$ grows, the nodes become denser" | Frames show more and narrower cells as n grows; the maximum cell width falls | confirmed |
| B3 | Behavior | "settles toward $I\approx2.016280$" | Independent I = 2.01627972, which rounds to 2.016280. The script's trapezoid reference is 2.0162797061, 1.35e-8 from the true value. | confirmed |
| B4 | Behavior | "from $n=6$ on it decreases in every frame" | Independent GL values: n=5 2.0146225, n=6 2.0194651 (an increase), then strictly decreasing at every step from 6 → 8 to 56 → 64 (`indep.py`, all "dec") | confirmed |
| B5 | Behavior | "the last frame ($n=64$) gives 2.016282" | Script 2.016281583860760; numpy 2.016281583861; frame 24 reads "Approximation = 2.016282" | confirmed |
| B6 | Behavior | "still about $1.9\times10^{-6}$ high" | High-precision GL error at n=64: +1.8642437e-6 | confirmed |
| B7 | Behavior | "$f'$ unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0)" | mpmath ratio $f'(x)/(\tfrac{16}{3}x^{-1/3})$ is 0.9943 at 1e-3, 0.999997 at 1e-6 and 0.9999999975 at 1e-9 | confirmed |
| B8 | Behavior | "textbook error order, which assumes smooth $f$, does not hold" | The textbook error term involves $f^{(2n)}$, which is unbounded at 0 here. The measured error is algebraic, not geometric (B9). | confirmed |
| B9 | Behavior | "error shrinks only algebraically, like $O(n^{-10/3})$" | Error ratios on doubling n: E16/E32 = 9.65, E28/E56 = 9.81, E32/E64 = 9.84, E64/E128 = 9.95, E128/E256 = 10.02, E256/E512 = 10.05, E512/E1024 = 10.06, rising toward $2^{10/3}$ = 10.079 (`rate.py`, `indep.py`). This also fits the known $n^{-2-2\alpha}$ rate for an endpoint singularity $x^{\alpha}$ with α=2/3. | confirmed |
| B10 | Behavior | "doubling $n$ divides it by about 9.8 (from 32 to 64 nodes), tending to $2^{10/3}\approx10.08$" | E32/E64 = 9.841; $2^{10/3}$ = 10.0794; the ratios increase monotonically toward it (B9) | confirmed |
| B11 | Behavior | "smooth integrand $1+e^{-x}\sin 8x$ on $[0,2]$ already has error $4\times10^{-17}$ at $n=16$" | Exact I = 2.1396277602002456530 (closed form = mpmath quad). The 16-point GL error in 40-digit arithmetic is 4.166e-17; n=14 gives 1.8e-13 and n=18 gives 2.5e-21. The error is below double-precision roundoff, so in float64 one sees about 4e-16, but the claim concerns the rule's error and is right. | confirmed |
| W1 | Link | "[Julia source](gausslegendreaa.jl)" | The file exists and is the script that produces the GIF (byte-identical regeneration) | confirmed |
| W2 | Embed | `gausslegendreaa.gif` | Exists, 24 frames, byte-identical to the scratch regeneration | confirmed |
| W3 | Alt text | "weighted sample bars and nodes are recomputed as the number of nodes increases from 2 to 64" | n runs from 2 to 64 (A4, A5) | confirmed |
| W4 | Alt text | "integral estimate settles toward 2.016280, reaching 2.016282 at 64 nodes" | B3, B5 | confirmed |
| P1 | Closing para | "follows the archived module equation" | Legacy GIF title "y = e^{-x} sin(8x^{2/3}) + 1" on the 0..2 axis (Mathews Example 6 / Animation 1). Legacy approximations agree with the script's: n=2 1.154628, n=6 2.019465, n=10 2.017086, n=14 2.016553, n=18 2.016400. | confirmed |
| P2 | Closing para | "compares $I_n=\sum w_i f(x_i)$ against a high-resolution numerical reference" | On [0,2], (b−a)/2 = 1, so the unscaled weights with $x_i=1+t_i$ give exactly $I_n$, consistent with D3. The reference is a trapezoid rule with 120 000 intervals and an error of 1.35e-8, ample for 6 decimals. | confirmed |

---

### 3. Implementation checks: `gausslegendreaa.jl`

**It is the method it claims to be.** Plain (non-composite) n-point Gauss–Legendre on [0,2]. Nodes and weights come from the Golub–Welsch eigenproblem of the Legendre Jacobi matrix: off-diagonal $k/\sqrt{4k^2-1}$, weights $2v_{1,i}^2$. This is the standard construction, not a neighbouring method, and the rule is recomputed for each n.

**The numbers are right.** I checked three independent routes against the instrumented script output (`inst.jl`):
- numpy `leggauss`, and scipy `roots_legendre` for large n;
- my own mpmath GL at 40 digits, with nodes from Newton iteration on $P_n$ and weights $2/((1-x^2)P_n'(x)^2)$;
- the degree-of-precision property (D4).

| n | script | numpy leggauss | error vs I (mpmath) |
|---|---|---|---|
| 2 | 1.154627908484442 | 1.154627908484 | −8.6165e-01 |
| 3 | 2.332149179135188 | 2.332149179135 | +3.1587e-01 |
| 5 | 2.014622535919906 | 2.014622535920 | −1.6572e-03 |
| 6 | 2.019465088565291 | 2.019465088565 | +3.1854e-03 |
| 16 | 2.016456684782773 | 2.016456684783 | +1.7697e-04 |
| 32 | 2.016298066545368 | 2.016298066545 | +1.8347e-05 (mpmath GL: 1.8346928e-5) |
| 64 | 2.016281583860760 | 2.016281583861 | +1.8642e-06 (mpmath GL: 1.8642437e-6) |

All 21 values agree to at least 12 digits. The script's n=64 rule integrates monomials to about 1e-15.

**Its reference values are right.** `true_int` is a 120 001-point trapezoid rule, 2.016279706128. The independent reference is 2.0162797196170963279, computed by substituting x=u³ to remove the $x^{2/3}$ singularity, and it agrees with direct mpmath quadrature with breakpoints to 20 digits. The difference of 1.35e-8 is well below the 6 decimals displayed and stated.

**The picture shows what was computed.**
- I viewed frames 2, 4 (n=2), 8 (n=6), 14 (n=18) and 24 (n=64), plus the contact sheet.
- The curve is the coded $f$, and the label text matches the function.
- The "Sample Points" and "Approximation" labels match the instrumented n and values. The only display slip is that trailing zeros are dropped (F2).
- The node lines are drawn at $x_i$ up to $f(x_i)$.
- Bar areas equal $w_i f(x_i)$, but bar heights depart from $f(x_i)$, by about 18% at the end bars in every frame (F1).
- No clamping occurs: the maximum bar height is 1.929 and the maximum of $f$ is about 1.92, both below ylim 2.1. Nothing the page discusses falls outside the window.
- The frame count is 24, as described.

**Legacy comparison.**
- The legacy animation uses the same function and interval, 3 intro frames, and n = 2, 4, …, 40 (frames 4–24, with n=2 shown twice).
- The port's n sequence differs (2 to 64), and it adds a reference-value text on intro frame 2. Neither is a problem.
- The legacy static examples 1–5 (n=2..5 rules on other integrals) were never animations, so the page does not drop an animated case.
- The bar construction differs as described in F1.

