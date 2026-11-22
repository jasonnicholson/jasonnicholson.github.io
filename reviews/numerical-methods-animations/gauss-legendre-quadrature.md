# Gauss-Legendre Quadrature — animation review

Page: [`pages/numerical-methods/gauss-legendre-quadrature/index.qmd`](../../pages/numerical-methods/gauss-legendre-quadrature/index.qmd) · Scripts: `gausslegendreaa.jl` · GIFs: 1

**Result:** 0 error, 1 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — "stabilizes rapidly" hides the slow algebraic convergence caused by the x^(2/3) term

- **Location:** index.qmd:35, "As $n$ grows, the node distribution becomes denser and the weighted estimate stabilizes rapidly."
- **Now:** The page says the estimate stabilizes rapidly. A reader of a Gauss-Legendre page will take that as the method's usual very fast (geometric) convergence.
- **True:** $f(x)=1+e^{-x}\sin(8x^{2/3})$ has an $x^{2/3}$ term at the endpoint $x=0$, where $f'$ is unbounded. Because of that, Gauss-Legendre converges only algebraically here, with error about $C\,n^{-10/3}$. With 64 nodes, the last frame, the error is still $1.86\times10^{-6}$. The final displayed value is 2.016282, but the true integral is 2.016280 (2.0162797196…). For comparison, the smooth integrand $1+e^{-x}\sin 8x$ on the same interval reaches machine precision by $n=16$. The estimate does settle steadily and monotonically from $n=6$ onward. Calling that settling "rapid" is the misleading part. This integrand is a textbook case of Gauss-Legendre losing its usual advantage.
- **Evidence:** `python3 reviewer/rate.py` gives these errors against the mpmath reference 2.0162797196170963279. n=8: 1.63e-3. n=16: 1.77e-4. n=20: 8.56e-5. n=32: 1.83e-5. n=64: 1.86e-6. n=128: 1.87e-7. The observed order is 3.21, 3.26, 3.28, 3.30, 3.32, approaching 10/3. For the smooth comparison integrand the error is -4.4e-16 at n=16.
- **Suggested fix:** Replace the sentence with: "As $n$ grows the nodes become denser and the estimate settles toward $I\approx2.016280$. Convergence is only algebraic (error roughly $\propto n^{-10/3}$; still about $2\times10^{-6}$ at $n=64$) because the $x^{2/3}$ term makes $f'$ unbounded at $x=0$. A smooth integrand would converge to machine precision with far fewer nodes."

- **Independent check:** confirmed. Checker: confirmed; the n=64 frame value differs from the true integral in the 7th significant digit (2.016282 vs 2.016280), not the 6th.

### F2 — Minor — Page match — "Each frame increases the quadrature order" does not hold for the first three frames

- **Location:** index.qmd:28-29, "Each animation below shows … Each frame increases the quadrature order $n$ and recomputes nodes and weights across the full interval."
- **Now:** The text says every frame increases $n$, and it speaks of several animations ("Each animation below").
- **True:** The page has one animation. Its first 3 of 24 frames are intro frames with no rule drawn. Frames 1 and 3 show only the curve. Frame 2 shows "True / Numerical Quadrature / I = 2.01628". Frames 4-24 then show $n$ = 2, 3, 4, 5, 6, 8, 10, …, 48, 56, 64 (21 orders, uneven steps). The true value appears only in frame 2 and never next to an approximation.
- **Evidence:** script lines 13-14 and 60-61 (`frame_states = [:intro1, :intro2, :intro3] ∪ n_seq`). `committed/gausslegendreaa/nframes` = 24. I viewed frames 1-4 and 24.
- **Suggested fix:** Change the text to: "The animation opens with the integrand and the reference value $I\approx2.016280$, then shows the rule for $n=2,3,4,5,6,8,\dots,56,64$, recomputing nodes and weights each frame."

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `gausslegendreaa.jl` | yes | 4.3 | gausslegendreaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 13 | "evaluating $f$ at optimally chosen interior nodes and weighting those values" | All nodes strictly inside (-1,1) for every n (max abs(t) < 1). Script forms Σ wt_i f(x_i) (line 38). | confirmed |
| 2 | 16 | $n$-point rule $\int_{-1}^1 g \approx \sum w_i g(t_i)$ | script lines 20-38 | confirmed |
| 3 | 18 | "$t_i$ are roots of the Legendre polynomial $P_n(t)$ and $w_i$ are associated weights" | indep.py: max abs(P_n(t_i)) ≤ 4.7e-13 for n=2…64. Nodes match mpmath roots to ≤2.3e-15. Weights match $2/((1-t^2)P_n'(t)^2)$ to ≤2.2e-15. | confirmed |
| 4 | 20-23 | Map $x=\frac{a+b}{2}+\frac{b-a}{2}t$ with factor $\frac{b-a}{2}$ | script lines 36-37 apply exactly this | confirmed |
| 5 | 24 | "exact for polynomials up to degree $2n-1$" | indep.py on the script's weights: max error over degrees 0…2n−1 is ≤2.3e-15 for n = 2, 3, 4, 5, 8, 16, 32, 64. Degree 2n fails: 0.178 (n=2), 0.0457 (3), 0.0116 (4), 2.9e-3 (5), 4.7e-5 (8), 7.2e-10 (16). At n=32 and 64 the degree-2n error is below roundoff. | confirmed |
| 6 | 29, 33, 42 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ | script lines 9-10. On-plot label "Y = exp(-x) sin(8*x^(2/3)) + 1" matches. | confirmed |
| 7 | 28 | "Each animation below" (plural) | there is one animation | wrong (→ F2), trivial |
| 8 | 29 | "Each frame increases the quadrature order $n$" | frames 1-3 are intro frames, n starts at frame 4 | wrong (→ F2) |
| 9 | 29 | "recomputes nodes and weights across the full interval" | `gauss_legendre_sum(n)` is called per frame on [a,b]=[0,2], with no subintervals | confirmed |
| 10 | 33 | Heading "Increasing-Order Gauss-Legendre Rule" | n_seq strictly increasing from 2 to 64 | confirmed |
| 11 | 35 | "shaded bars visualize weighted sample contributions built from Gauss-Legendre nodes" | bar area = height·width equals wt_i f(x_i) to ≤1.1e-16 (instr.jl `maxareaerr`). Bar edges are midpoints between nodes. | confirmed |
| 12 | 35 | "As $n$ grows, the node distribution becomes denser" | the minimum bar width falls from 1.0 (n=2) to 2.18e-3 (n=64) | confirmed |
| 13 | 35 | "the weighted estimate stabilizes rapidly" | algebraic error ~n^(-10/3). Error is 1.86e-6 at n=64. | wrong (→ F1) |
| 14 | 37, 39 | Link `gausslegendreaa.jl` and embed `gausslegendreaa.gif` | manifest: the script alone produces this GIF, byte-identical to the committed one | confirmed |
| 15 | 39 | alt: "weighted sample bars and nodes are recomputed as order increases" | frames 4-24 | confirmed |
| 16 | 39 | alt: "the integral estimate converges" | I_n decreases monotonically from n=6 (2.019465) to n=64 (2.016282) toward 2.0162797 | confirmed |
| 17 | 41 | "compares $I_n=\sum w_i f(x_i)$ …" (formula) | Strictly, with the [-1,1] weights of line 16 a factor $(b-a)/2$ is needed, but here $(b-a)/2=1$. The script includes the factor (line 37). | confirmed (numerically identical for [0,2]) |
| 18 | 41 | "against a high-resolution numerical reference" | Trapezoid on 120001 points gives 2.016279706128. The mpmath value is 2.0162797196171, so the error is 1.35e-8. Frame 2 shows "I = 2.01628" (=2.016280), correct to the digits shown. The reference appears only in frame 2 (see F2). | confirmed |
| 19 | 41 | "This page follows the archived module equation" | legacy archive not available, and out of scope | could not determine (archive not available) |

## Implementation checks

### gausslegendreaa.jl
- **Method:** True Gauss-Legendre. Nodes and weights come from the Golub-Welsch eigenproblem on the symmetric tridiagonal Jacobi matrix with off-diagonal $k/\sqrt{4k^2-1}$ and weights $2v_{1i}^2$ (lines 20-32). The rule is applied once on the whole of [0,2] with the affine map (lines 34-39), not as a composite variant. I verified it by property rather than from a remembered table (claim ledger rows 3 and 5). The nodes are roots of $P_n$, the weights match the closed form $2/((1-t^2)P_n'^2)$, every rule is exact through degree 2n−1, and the rules fail at degree 2n wherever that failure is above roundoff (n ≤ 16). Σw = 2 to ≤1e-15 for all 21 orders.
- **Numbers:** The script's I_n (instr.jl), my numpy-`leggauss` I_n (indep.py), and the error against the mpmath reference:

  | n | script I_n | independent I_n | error |
  |---|---|---|---|
  | 2 | 1.154627908484 | 1.154627908484 | −0.862 |
  | 3 | 2.332149179135 | 2.332149179135 | +0.316 |
  | 5 | 2.014622535920 | 2.01462253592 | −1.66e-3 |
  | 8 | 2.017911793793 | 2.017911793793 | +1.63e-3 |
  | 12 | 2.016728860798 | 2.016728860798 | +4.49e-4 |
  | 16 | 2.016456684783 | 2.016456684783 | +1.77e-4 |
  | 20 | 2.016365279015 | 2.016365279015 | +8.56e-5 |
  | 28 | 2.016308165173 | 2.016308165173 | +2.85e-5 |
  | 36 | 2.016292173603 | 2.016292173603 | +1.25e-5 |
  | 44 | 2.016286148530 | 2.01628614853 | +6.43e-6 |
  | 56 | 2.016282618898 | 2.016282618898 | +2.90e-6 |
  | 64 | 2.016281583861 | 2.016281583861 | +1.86e-6 |

  The script and the independent values agree to all printed digits. The frame text values ("Approximation = …", rounded to 6 digits) match. One display detail: n=18 shows "2.0164" because `round` drops the trailing zero of 2.016400. This is harmless.
- **Reference values:** `true_int` is a 120001-point trapezoid rule = 2.016279706128. The independent value is 2.0162797196170963279, from mpmath tanh-sinh on [0,2] split at 0.25, 0.5, 1, 1.5, and it agrees with Gauss-Legendre after the substitution x=u³ to 20 digits. The reference error of 1.35e-8 is far below the 6 decimals displayed, so "I = 2.01628" is correct.
- **Picture:** I viewed the contact sheet and full-size frames 2, 4 and 24. The bars run between midpoints of adjacent nodes, with ends at a and b. Each bar's height is wt_i f(x_i)/width, so its area is the node's contribution, checked to 1e-16. The red verticals run from 0 to f(x_i) at each node. The magenta curve is f on 800 points, and the label matches the coded f. The frame text matches the computed n and I_n. There is no clamping or masking. The axis window [0,2]×[0,2.1] contains the whole curve, whose maximum is about 1.92. Cosmetic issues that are not findings: the function label at (0.24, 2.02) touches the "2.0" y-tick label, and on low-n frames the text sits over semi-transparent bars, but both remain readable.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/gauss-legendre-quadrature/`](evidence/gauss-legendre-quadrature/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
