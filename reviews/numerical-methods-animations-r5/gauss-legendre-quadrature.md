# Gauss-Legendre Quadrature — animation review (round 5)

Page: `pages/numerical-methods/gauss-legendre-quadrature/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with values I computed independently, and the frames show what the script computes.

These observations were checked and are deliberately **not** findings. They are cosmetic and do not change what a viewer would conclude:
- In every frame, the formula label `Y = exp(-x) sin(8*x^(2/3)) + 1` (script line 109, at x=0.24, y=2.02) touches the "2.0" y-tick label, so it reads "2.0Y = …". It is still legible.
- In frame 2, the magenta curve passes just over the left end of the line "I = 2.016280" (y=1.32). It is still legible.
- Frame 2 labels the reference "True". The value is actually a 120001-point trapezoid estimate, 2.016279706, but it agrees with the true integral, 2.0162797196, to all six decimals shown.
- The page's n sequence (2–6, 8–20 by 2, 24–48 by 4, 56, 64) differs from the legacy GIF's sequence (2, 4, …, 40). It is a superset that still includes Mathews' n = 2…5 from Example 6. This is not a fidelity problem.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `gausslegendreaa.jl` | 0 | 9.7 | gausslegendreaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

The independent reference is $I = 2.016279719617096327887274$. I computed it with mpmath at 40 digits in two ways that agree to every digit: the substitution $x=u^3$, which removes the singularity, and tanh-sinh quadrature.

| # | Claim (page's words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| D1 | "$t_i$ are roots of the Legendre polynomial $P_n(t)$ and $w_i$ are associated weights" | Description | The script gets its nodes from Golub–Welsch (eigenvalues of the Jacobi matrix with $\beta_k=k/\sqrt{4k^2-1}$), an equivalent formulation. Using the three-term recurrence, $\max_i\lvert P_n(t_i)\rvert$ = 3.0e-15 (n=3), 2.1e-14 (n=8) and 4.6e-13 (n=64). The rule sums agree with `numpy.polynomial.legendre.leggauss` to all 10 printed digits for every n. | confirmed |
| D2 | $[a,b]$ map $x=\frac{a+b}2+\frac{b-a}2t$ and the sum with the factor $\frac{b-a}{2}$ | Description | Script lines 38–40 do exactly this. | confirmed |
| D3 | "exact for polynomials up to degree $2n-1$" | Description | With script nodes and weights: $\int t^{2n-2}$ and $\int t^{2n-1}$ have error ≤ 2.3e-15; $\int t^{2n}$ has error −0.178 (n=2), −0.0457 (n=3), −2.9e-3 (n=5), −4.7e-5 (n=8). With the asymmetric $(1+t)^k$ (numpy nodes), n=5: k=9 gives 2.8e-14 and k=10 gives −2.9e-3; n=8: k=15 gives 9e-12 (round-off on a value of about 4e3) and k=16 gives −4.7e-5. | confirmed |
| A1 | Integrand $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | intro, heading, last paragraph | Script lines 11–12; frame label "Y = exp(-x) sin(8*x^(2/3)) + 1". | confirmed |
| A2 | "opens with three frames of the integrand alone, the second also showing the reference value $I\approx2.016280$" | intro | Frames 1 and 3 have identical hashes and show the curve only. Frame 2 adds "True / Numerical Quadrature / I = 2.016280". | confirmed |
| A3 | $I\approx2.016280$ | intro, Behavior, alt | True value 2.01627972, which rounds to 2.016280. The script's trapezoid reference is 2.016279706128 (error −1.35e-8). | confirmed |
| A4 | "$n=2,3,4,5,6,8,10,\dots,20,24,28,\dots,48,56,64$" | intro | `n_seq` (lines 15–16) is identical. 3 intro frames + 21 = 24 frames, which matches the GIF frame count. | confirmed |
| A5 | "recomputes nodes and weights across the full interval" (no composite rule) | intro | `gauss_legendre_sum(n)` is called fresh for each frame on the whole of $[0,2]$. | confirmed |
| A6 | "Julia source scripts … are linked under each case" | intro | `[Julia source](gausslegendreaa.jl)` exists. The embed is `gausslegendreaa.gif`, produced by that script (byte-identical regeneration). | confirmed |
| B1 | "Each shaded bar has width $w_i$ and height $f(x_i)$ … its area is the term $w_i f(x_i)$ of the sum" | Behavior | Lines 43–49 and 80–87: widths are the scaled weights, heights are $f(x_i)$. Since $(b-a)/2=1$, the scaled weights equal the $[-1,1]$ weights, so "$w_i$" is consistent with the Description. | confirmed |
| B2 | "marked by a red dot at the node $x_i$" | Behavior, alt | Line 105 puts a scatter at $(x_i,f(x_i))$. Frames 4 and 24 show it on the top edge of each bar. | confirmed |
| B3 | "bars are laid end to end across $[0,2]$, and each node lies inside its own bar" | Behavior | Instrumented run: the bounds are cumulative sums ending at 2.000000000000000 (±1e-15) for every n, and `bounds[i] < x_i < bounds[i+1]` holds for every n in `n_seq`. The minimum margin ranges from 0.42 (n=2) to 6.95e-4 (n=64). | confirmed |
| B4 | "As $n$ grows, the nodes become denser and the estimate settles toward $I$" | Behavior | Errors fall from +3.2e-3 (n=6) to +1.86e-6 (n=64); see the table in section 3. | confirmed |
| B5 | "from $n=6$ on it decreases in every frame" | Behavior | Q goes 2.0194651 (n=6), then 2.0179118, 2.0170862, …, 2.0162816, strictly decreasing over all 16 steps. From n=5 to n=6 it increases (2.0146225 → 2.0194651), so the "from n=6" qualifier is accurate. | confirmed |
| B6 | "the last frame ($n=64$) gives 2.016282, still about $1.9\times10^{-6}$ high" | Behavior, alt | Q64 = 2.0162815839, error +1.864e-6 against the true I (+1.878e-6 against the script's reference). Frame 24 shows "Approximation = 2.016282". | confirmed |
| B7 | "$f'$ unbounded at $x=0$ ($f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0)" | Behavior | mpmath $f'(x)/(\frac{16}{3}x^{-1/3})$ = 0.99960 (x=1e-4), 0.999997 (1e-6) and 0.99999997 (1e-8). | confirmed |
| B8 | "textbook error order, which assumes smooth $f$, does not hold" | Behavior | The textbook bound needs $f^{(2n)}$, and $f$ is not even $C^1$ on $[0,2]$. The observed algebraic rate (B9) is far slower than the geometric rate seen for the smooth comparison (B11). | confirmed |
| B9 | "error shrinks only algebraically, like $O(n^{-10/3})$" | Behavior | Log-log slopes: −3.270 (16→32), −3.299 (32→64), −3.307 (56→64). The theoretical rate for an endpoint singularity $x^{\alpha}$ with α=2/3 is $n^{-2-2\alpha}=n^{-10/3}$. | confirmed |
| B10 | "doubling $n$ divides it by about 9.8 (from 32 to 64 nodes), tending to $2^{10/3}\approx10.08$" | Behavior | Error ratios: 9.22 (8/16), 9.65 (16/32), **9.84 (32/64)**, then 9.95, 10.02, 10.05, 10.06 (64/128 … 512/1024). $2^{10/3}=10.0794$. Against the script's own reference, the 32/64 ratio is 9.78. | confirmed |
| B11 | "smooth integrand $1+e^{-x}\sin 8x$ … error about $1.8\times10^{-13}$ at $n=14$ and reaches … $10^{-15}$ or less by $n=16$" | Behavior | numpy leggauss against an mpmath reference: n=14 gives 1.843e-13, n=15 gives −4.0e-15, n=16 gives −4.4e-16. | confirmed |
| L1 | Alt text: "bars of width w_i and height f(x_i), with a red dot at each node, are recomputed as the number of nodes increases from 2 to 64, and the integral estimate settles toward 2.016280, reaching 2.016282 at 64 nodes" | alt | As B1–B6, A4. | confirmed |
| L2 | "follows the archived module equation" | last paragraph | Archive Example 6 (`gr_276`/`gr_277`/`gr_278`) is $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$. The archive's Q2 = 1.1546279…, matching the script's 1.1546279085, and Q5 = 2.01462, matching 2.0146225. | confirmed |
| L3 | "compares $I_n=\sum w_i f(x_i)$ against a high-resolution numerical reference" | last paragraph | The reference is a 120001-point trapezoid estimate with error −1.35e-8. That is about 0.7% of the smallest displayed error (1.86e-6) and invisible at the 6 decimals shown. $I_n$ without a $(b-a)/2$ factor is correct because that factor is 1 here. | confirmed |
| F1 | Displayed approximations in every frame | GIF | Frame values read off the contact sheet (n=3: 2.332149, 5: 2.014623, 8: 2.017912, 12: 2.016729, 16: 2.016457, 20: 2.016365, 28: 2.016308, 36: 2.016292, 44: 2.016286, 56: 2.016283, 64: 2.016282, and frame 4, n=2: 1.154628) all equal the independent numpy values rounded to 6 decimals. | confirmed |

### 3. Implementation checks: `gausslegendreaa.jl`

**It is the method it claims to be.** It runs the n-point Gauss–Legendre rule applied once over the whole of $[0,2]$ (not composite), with nodes and weights from Golub–Welsch: the eigenvalues of the symmetric tridiagonal Jacobi matrix with off-diagonal $k/\sqrt{4k^2-1}$, and weights $2v_{1,i}^2$. That is a standard and exact formulation of the same rule the Description gives. The nodes come back sorted ascending (`issorted` is true for all n), which the end-to-end bar layout relies on.

**The numbers are right.**
- The rule sums from the instrumented script equal numpy `leggauss` sums to all 10 printed digits for every n in `n_seq`. Selected values (script = independent):
  - n=2: 1.1546279085
  - n=3: 2.3321491791
  - n=5: 2.0146225359
  - n=6: 2.0194650886
  - n=16: 2.0164566848
  - n=32: 2.0162980665
  - n=64: 2.0162815839
- Property checks: the nodes are roots of $P_n$ (residual ≤ 4.6e-13 at n=64), the weights sum to 2, and the rule is exact through degree $2n-1$ and fails at $2n$ (D3).
- Running the same rule on the smooth comparison integrand reproduces the geometric convergence the page quotes (B11).

**Its reference values are right.** `true_int` = 2.016279706128 (composite trapezoid, 120001 points). The independent value is 2.0162797196171 (mpmath, two methods agreeing to 25 digits), so the script's reference is off by −1.35e-8. It is used only for display in frame 2, where it rounds to the correct 2.016280. Using it instead of the true value changes the page's derived numbers only in the third significant figure of the 32/64 ratio (9.78 against 9.84; both read "about 9.8").

**The picture shows what was computed.**
- Frames 1 and 3 are identical (the curve alone). Frame 2 adds the reference. Frames 4–24 show n = 2…64 in `n_seq` order, one per frame.
- In each data frame:
  - Bar i spans the cumulative-weight cell $[a+\sum_{j<i}w_j,\ a+\sum_{j\le i}w_j]$ with height $f(x_i)$.
  - A thin red vertical line runs from 0 to $f(x_i)$ at the node.
  - The red dot sits at $(x_i,f(x_i))$ on the curve and on the bar's top edge.
  - Verified visually at n=2 (cells [0,1] and [1,2], nodes 0.423 and 1.577, heights 0.359 and 0.796), at n=3 (cells of width 5/9, 8/9, 5/9, with the node at 1.0 in the middle cell) and at n=64.
- The axis limits (0, 2.1) contain the whole curve ($\min f$=0.357, $\max f$=1.920 on a 200001-point grid), so nothing is clamped.
- The "Sample Points = n" and "Approximation = …" annotations use the same `n` and `approx` the frame draws.
- The formula label matches `f` in the code.

**Legacy fidelity.** The archive's only animation for this topic (`GaussLegendreaa.gif`, Example 6) uses the same integrand, interval, bar construction and text layout. It ran n = 2, 4, …, 40 with no reference-value frame. The page keeps the example and the construction, extends the range of n and adds a correct reference frame. No archive case is dropped (the module has one animation), and no departure misleads a reader.

