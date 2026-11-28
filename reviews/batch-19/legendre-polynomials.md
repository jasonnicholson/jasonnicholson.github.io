# Legendre Polynomials — batch 19 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Review of `pages/numerical-methods/legendre-polynomials/index.qmd`, light-pass batch 19, overview mode. The diff changes only `index.qmd`. It adds `## Description` (lines 10–49) and adds `{#case-1}` and `{#case-2}` to the two case headings. No script or GIF changed, so the animations are not under review. I consulted the Mathews archive (`n2003/LegendrePolyMod.html`, read as text, plus its equation images gr_201, gr_270, gr_305, gr_346 and gr_368). I did not run MATLAB or quarto, and I modified nothing in the repository. My scratch files are in `EV/reviewer/`: `check.py`, `gibbs.py`, `wc.py` and `mathews_eqs.png`.

## 1. Findings

**F1 — Page text, Minor.**
- **Location:** `index.qmd` line 12: "The Legendre polynomials $P_n(x)$ are the orthogonal polynomials of the interval $[-1,1]$."
- **What is wrong:** "the orthogonal polynomials of $[-1,1]$" suggests there is only one such family. Orthogonality depends on the weight. Line 48 of the same Description says the Chebyshev polynomials are also "orthogonal on $[-1,1]$ with weight $1/\sqrt{1-x^2}$".
- **Why it is only Minor:** the display at line 23 makes the unweighted inner product clear straight away, so a reader is unlikely to be misled.
- **Suggested fix:** "...are the polynomials orthogonal on $[-1,1]$ with weight 1 (the plain integral $\int_{-1}^1 P_mP_n\,dx$)", or simply "...are orthogonal on $[-1,1]$ with weight 1."

## 2. Claim ledger (the text this batch added; no sentences were moved)

**Lines 12–14: problem and construction**
- **L1.** Legendre polynomials are orthogonal on $[-1,1]$: confirmed, with weight 1 (see F1).
- **L2.** Their main use is continuous least squares: find $S_N$ of degree ≤ N minimizing $\int_{-1}^1 (f-S_N)^2\,dx$. Confirmed; this is Mathews' "Continuous Least Squares Approximation" definition.
- **L3.** Mathews builds them by Gram-Schmidt on $1, x, x^2, \ldots$, normalized so that $P_n(1)=1$. Confirmed: Mathews has the Gram-Schmidt theorem, and the remark that follows it normalizes with $P_k(1)=1$ (gr_270).
- **L4.** The animations compute them by the equivalent three-term recurrence $P_0=1$, $P_1=x$, $(n+1)P_{n+1}=(2n+1)xP_n-nP_{n-1}$. Confirmed:
  - `legendrepolyaa.jl` and `legendrepolybb.jl` both use `P = ((2k-1)*x*P_{k-1} - (k-1)*P_{k-2})/k`, which is the same recurrence shifted by one index.
  - Mathews gr_305 gives the identical formula.

**Lines 20–30: core formulas**
- **L5.** Orthogonality: $\int P_mP_n = 0$ for $m \ne n$ and $2/(2n+1)$ for $m = n$. Confirmed: standard result, and consistent with my mpmath computations.
- **L6.** No normal equations are needed, and $c_n=\frac{2n+1}{2}\int_{-1}^1 fP_n\,dx$. Confirmed:
  - This is the formula `legendre_coeff` in `legendrepolybb.jl` implements.
  - It matches Case 2's Behavior paragraph (line 66).

**Line 32: what the cases show**
- **L7.** Case 1 draws $P_0$ to $P_5$. Confirmed: the frames of `legendrepolyaa` show 6 frames, titled P₀…P_0 through P₀…P_5, one curve added per frame.
- **L8.** Case 2 adds the terms of this series one per frame. Confirmed: the frames of `legendrepolybb` show 9 frames, $S_0$ through $S_8$.

**Lines 34–36: assumptions and practice**
- **L9.** The coefficients need only $f$ square-integrable on $[-1,1]$, as Mathews assumes. Confirmed:
  - Mathews: "All the functions we use are assumed to be square-integrable" (gr_201).
  - Square integrability is sufficient, since $f \in L^2 \subset L^1$ and $|P_n| \le 1$.
- **L10.** On $[a,b]$ Mathews uses $P_n\bigl((2x-a-b)/(b-a)\bigr)$. Confirmed: Mathews gr_346 gives $q_k(x)=p_k\bigl((2x-a-b)/(b-a)\bigr)$.
- **L11.** Case 2 uses 20-point Gauss-Legendre quadrature. Confirmed:
  - The script calls `legendre_coeff(...; npts=20)`, using Golub-Welsch nodes and weights.
  - My numpy `leggauss(20)` coefficients differ from the mpmath adaptive-quadrature values by at most 6.6e-16 for $n = 0, \ldots, 8$.

**Lines 38–41: accuracy**
- **L12.** In general, $S_N$ is the best degree-≤N approximation in integrated squared error, adding a term never increases that error, and for every $L^2$ function $f$ the error tends to 0. Confirmed: a general result, using orthogonal projection and the density of polynomials in $L^2[-1,1]$.
- **L13.** For continuous $f$, $|f-S_N|\le\sum_{n>N}|c_n|$ whenever that sum converges. Confirmed:
  - If $\sum|c_n|<\infty$, the series converges uniformly to a continuous $g$.
  - It also converges in $L^2$ to $f$, so $g=f$ everywhere.
  - Since $|P_n|\le1$, the bound follows.
  - The hypotheses as stated are sufficient.
- **L14.** For $f$ analytic on a region containing $[-1,1]$, the $c_n$ shrink geometrically, and so does the bound. Confirmed: a general result (Bernstein ellipse). It is not attached to a case, but for Case 2's entire $f$ the computed $|c_n|$ fall from 0.70 to 7e-9 by $n = 11$.
- **L15.** In Case 2 the $L^2$ error falls at every frame, from 0.560 for $S_0$ to 2.33e-6 for $S_8$. Confirmed. Computing $\sqrt{\int(f-S_N)^2}$ two ways (Parseval with mpmath coefficients, and direct quadrature with the script's GL20 coefficients) gives agreement to 6 digits:

| $S_N$ | $L^2$ error |
|---|---|
| $S_0$ | 0.559564 |
| $S_1$ | 0.461507 |
| $S_2$ | 0.214014 |
| $S_3$ | 0.0268755 |
| $S_4$ | 0.00424164 |
| $S_5$ | 0.00148695 |
| $S_6$ | 1.34769e-4 |
| $S_7$ | 6.48757e-6 |
| $S_8$ | 2.3342e-6 |

  The sequence is strictly decreasing.

**Lines 43–46: failure modes**
- **L16.** Least squares is not minimax, so the maximum error need not fall at every step. Confirmed: a general statement.
- **L17.** In Case 2 the maximum error rises from 0.699 for $S_0$ to 1.09 for $S_1$, while the $L^2$ error falls from 0.560 to 0.461. Confirmed:
  - Maximum error is 0.6990 on both the 500-point and 200001-point grids, then 1.087. This matches the frame titles "max err = 0.699" and "1.09".
  - $L^2$ error is 0.5596, then 0.4615.
- **L18.** In every frame of Case 2 the largest error is at an endpoint, $x = \pm 1$. Confirmed on both grids:
  - At $x=-1$: $N$ = 0, 3, 6.
  - At $x=+1$: $N$ = 1, 2, 4, 5, 7, 8.
  - "Where each $|P_n|$ reaches 1" is true, since $|P_n(\pm1)|=1$.
- **L19.** For sign(x) the partial sums converge in the mean but not uniformly. Confirmed (`gibbs.py`, with $c_n = P_{n-1}(0)-P_{n+1}(0)$ for odd $n$, checked against quadrature).
- **L20.** The overshoot is about 9% of the jump height, the same at N = 21, 41, 81 and 161. Confirmed. Measured as $(\max S_N - 1)/2$:

| N | Overshoot | Location |
|---|---|---|
| 21 | 9.03% | x = 0.139 |
| 41 | 8.97% | x = 0.074 |
| 81 | 8.96% | x = 0.038 |
| 161 | 8.95% | x = 0.019 |

  The limit equals the Fourier Gibbs constant, 8.949%.

**Line 48: related pages**
- **L21.** Gauss-Legendre Quadrature uses the zeros of $P_n$ as its nodes. Confirmed: that page's line 20 says "nodes $t_i$ are the $n$ roots of the Legendre polynomial $P_n(t)$".
- **L22.** Least Squares Polynomials is the discrete counterpart that fits data points. Confirmed: that page's line 12 says "Given $n$ data points...".
- **L23.** Chebyshev Approximation Polynomial interpolates at the zeros of the Chebyshev polynomials. Confirmed: that page's lines 12 and 16 describe interpolation at the roots of $T_n$.
- **L24.** Chebyshev polynomials are orthogonal on $[-1,1]$ with weight $1/\sqrt{1-x^2}$. Confirmed: standard result.
- **L25.** Fourier Series is the same kind of orthogonal expansion with sines and cosines. Confirmed: general statement, and the page exists.
- **L26.** Maclaurin and Taylor series are accurate near one point rather than across the interval. Confirmed: general statement, and the page exists.

**Heading ids**
- **L27.** `{#case-1}` is added to the Case 1 heading and `{#case-2}` to the Case 2 heading. Confirmed: the links `#case-1` and `#case-2` at lines 32 and 44 match them.

## 3. Checks

**The six points of the overview standard**
1. **Problem:** present (lines 12–13).
2. **Core formula:** present as display math in the scripts' notation (recurrence, orthogonality, series and $c_n$, lines 16–30).
3. **Assumptions:** present ($L^2$ $f$, the interval $[-1,1]$ and the shift to $[a,b]$, lines 34–35).
4. **Accuracy:** present ($L^2$ optimality and monotonicity, $L^2$ convergence, the uniform tail bound, geometric decay for analytic $f$). It points to Case 2 with verified numbers.
5. **Failure modes:** present (maximum error not monotone, linked to Case 2 and verified; Gibbs overshoot for sign(x), verified).
6. **Where it fits:** present (line 48; one long sentence).

There is no worked-example table, no callout or theorem boxes, and no proofs. Nothing the standard leaves out is included.

**Contradictions with the rest of the page:** none.
- Case 2's Behavior paragraph (line 66) gives the same 0.699 → 1.09 rise and the same $c_n$ formula.
- Case 1's Properties text gives the same recurrence.
- The Animations introduction is unchanged and consistent.
- The figures in the frames (max errors 0.699, 1.09, 0.44, 0.0622, 0.0134, 0.00412, 0.00038, 2.54e-5, 7.74e-6) match my recomputation: 0.6990, 1.087, 0.4401, 0.06222, 0.01343, 0.004119, 3.797e-4, 2.538e-5, 7.737e-6.

**Word count:** 394 words of prose, at or under the 400-word limit. My count with `wc.py` (inline math as 1 word, display math excluded, link URLs stripped, punctuation-only tokens dropped) gives 394, matching the manifest. Keeping the stand-alone "%" token raises it to about 413. This is borderline but within the limit as the standard counts.

**Links and anchors:** all resolve.
- `#case-1` and `#case-2` match the explicit heading ids.
- These pages all exist: `../gauss-legendre-quadrature/`, `../least-squares-polynomials/`, `../chebyshev-approximation-polynomial/`, `../fourier-series/` and `../maclaurin-and-taylor-series/` (each has an `index.qmd`).

**Markup:** `\begin{cases}...\\[2pt]...\end{cases}`, `\dfrac`, `\operatorname{sign}` and `\bigl`/`\bigr` are all valid KaTeX. I found no broken math. (Judged from the source; quarto was not run.)

**Scope of the diff:** 42 insertions and 2 deletions in `index.qmd` only. Outside the Description, the only changes are the two heading ids, which are allowed. No sentences were moved out of the Animations introduction. No script or GIF changed, so Questions 1 and 2 were not re-run on the animations. I looked at both contact sheets to confirm the case claims (L7, L8, L17).

**Fidelity:** the Description's construction (Gram-Schmidt with $P_n(1)=1$), recurrence, square-integrability assumption and shifted-interval mapping all agree with Mathews' module. Case 2's $f$ is presented as Mathews' Example 8(b); that text predates this batch and is not under review. No Fidelity findings.
