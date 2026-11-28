# B-Splines — batch 19 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/b-splines/index.qmd` (light-pass batch 19, overview, action *extend*). Evidence: `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-19/b-splines/`. My scratch scripts are in its `reviewer/` folder (`check.py`, `y.py`, `more.py`, `wc.py`). I did not run MATLAB or quarto and did not modify the repository. I consulted the Mathews archive (`n2003/B-SplinesMod.html`, read as text).

## 1. Findings

**F1 — Page text, Minor. The partition of unity and the curve domain are stated on a closed interval, but the page's own definition makes both fail at the right end.**
- **Where:** line 16, `C(t)=\sum_{i=1}^{n} P_i\,N_{i,k}(t), \qquad t_k\le t\le t_{n+1}`; line 31, "the basis functions sum to 1 on $[t_k,t_{n+1}]$"; line 42, "In code, the half-open spans of $N_{i,1}$ make every basis function zero at $t=4$ …".
- **What is there now:** the page defines $N_{i,1}$ on line 22 with the half-open span $t_i\le t<t_{i+1}$. Under that definition every $N_{i,1}(t_{n+1})$ is 0, with no extra convention. So it is the page's own definition, not just the code, that gives $\sum N_{i,4}(4)=0$ and $C(4)=(0,0)$. Lines 16 and 31 therefore contradict line 22 at the single point $t=t_{n+1}$. Line 42 does describe the symptom, but it calls it an implementation matter ("In code"), when it follows directly from the displayed formula.
- **How I know:** I implemented the page's recursion exactly as written (`check.py`). It gives sum = 0.0 and C(4) = [0, 0] at t = 4, and C(4 − 1e-9) = (6.0, 4.5e-9). SciPy's `BSpline`, which closes the last span, gives C(4) = (6, 0).
- **Suggested fix:** add the standard convention after line 27 ("the last non-empty span is taken closed, so $N_{n,1}(t_{n+1})=1$"). Alternatively, write $[t_k,t_{n+1})$ on lines 16 and 31. In either case, reword line 42 to say that the literal half-open definition, as code usually implements it, gives $C(4)=(0,0)$.

No other findings.

## 2. Claim ledger (the + lines of the diff; no sentences were moved)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | "A B-spline curve is a smooth parametric curve $C(t)$ shaped by control points $P_1,\ldots,P_n$ … need not pass through them" | confirmed | Case 1 curve misses every interior control point (row 21) |
| 2 | order $k$ means degree $k-1$; nondecreasing knot vector $t_1\le\cdots\le t_{n+k}$ | confirmed | standard; matches the script (`k = 4  # order = degree + 1`) |
| 3 | $C(t)=\sum_{i=1}^n P_iN_{i,k}(t)$, $t_k\le t\le t_{n+1}$ | confirmed for the formula; right endpoint: see F1 | script `bspline_curve_point` |
| 4 | $N_{i,1}$ is the indicator of $t_i\le t<t_{i+1}$ | confirmed | script line `(lo <= x < hi) ? 1.0 : 0.0` |
| 5 | Cox-de Boor recursion with denominators $t_{i+k-1}-t_i$ and $t_{i+k}-t_{i+1}$ | confirmed | identical to `bspline_basis` in both scripts; my implementation agrees with SciPy `BSpline` to 1.8e-15 on [0, 3.999] |
| 6 | a term with a zero denominator is taken as zero | confirmed | script `denom > 0 ? … : 0.0` |
| 7 | both animations use $k=4$, $n=7$, knots $(0,0,0,0,1,2,3,4,4,4,4)$, $t\in[0,4]$ | confirmed | both scripts: `vcat(zeros(4), range(1,3,length=3), fill(4.0,4))`, `t_min = t_knots[4] = 0`, `t_max = t_knots[8] = 4` |
| 8 | the construction needs $n\ge k$ control points and $n+k$ knots | confirmed | standard; script comment says "need n+k = 11 knots" |
| 9 | each $N_{i,k}\ge0$ and is zero outside $[t_i,t_{i+k}]$ | confirmed | general result; minimum basis value on the grid = 0.0; support spans 1,2,3,4,3,2,1 as Case 2 states |
| 10 | the basis functions sum to 1 on $[t_k,t_{n+1}]$ (Case 2) | confirmed on $[0,4)$ (max error 4.4e-16); false at $t=4$ under the page's definition (F1) | `check.py`; last frame of bsplinebb shows the dashed sum at 1 |
| 11 | on each knot span the curve lies in the convex hull of the $k$ active control points | confirmed | general result: on $[t_j,t_{j+1})$ the non-zero basis functions are $N_{j-3..j,4}$, which are non-negative and sum to 1 |
| 12 | moving one control point changes the curve only where its basis function is non-zero (local support) | confirmed | follows from the linear form of $C$ |
| 13 | at an interior knot of multiplicity $m\le k-1$ the curve is at least $C^{k-1-m}$; a cubic with simple knots, as here, is $C^2$ | confirmed | standard (the hypothesis $m\le k-1$ is present); jumps in C'' at t = 1, 2, 3 are about 1e-8 (finite-difference noise), so C'' is continuous |
| 14 | clamped means the first and last knots are repeated $k$ times; the curve starts at $P_1$, ends at $P_n$, tangent to the control polygon | confirmed | C(0) = (0,0) = P1, C(4) = (6,0) = P7 (SciPy); C′(0) = (3,6) = 3(P2−P1), C′(4) = (3,−4.5) = 3(P7−P6) |
| 15 | "A B-spline curve has no convergence order, since it follows its control polygon rather than interpolating data" | confirmed (defensible framing for a design curve) | none needed |
| 16 | used to interpolate equally spaced data, as in Mathews' module, B-splines give a cubic spline with error $O(h^4)$ for $f\in C^4[a,b]$ with clamped end conditions | confirmed | Mathews' module: equally spaced nodes, end conditions "crafted to form either a natural cubic spline or a clamped cubic spline". Clamped interpolant of eˣ on [0,1]: error ratios 15.60, 15.82, 15.91, 15.96 as h halves (O(h⁴)). The natural spline gives ratio about 4, so the clamped hypothesis is the necessary one and it is stated. |
| 17 | "The control points are not points on the curve" | confirmed | row 21 |
| 18 | $P_3=(2,-1)$, $P_5=(4,-0.5)$ | confirmed | script `ctrl_pts` |
| 19 | these lie below the $x$-axis, yet the curve has $y>0$ for all $0<t<4$ | confirmed | `y.py`: interior local minima of y are 0.2100 at t ≈ 1.111 and 0.4108 at t ≈ 2.952; near the ends y ≈ 6e-5 and 4.5e-5 and stays positive; the final frame of bsplineaa agrees |
| 20 | (Case 1 link) | confirmed | anchor `{#case-1}` added on line 52 |
| 21 | the curve misses each interior control point by 0.68 to 1.21 | confirmed | minimum Euclidean distance from each control point to the curve: P2 0.9758, P3 1.2109, P4 0.9118, P5 0.9110, P6 0.6802 |
| 22 | $N_{4,4}$ is non-zero on all of $(0,4)$, so moving $P_4$ moves every point except the ends | confirmed | support is [t4, t8] = [0, 4] with simple interior knots; samples are positive across (0,4) and about 1.7e-19 at 1e-6 from each end; N4,4(0) = N4,4(4) = 0 |
| 23 | the half-open spans make every basis function zero at $t=4$; direct evaluation gives $C(4)=(0,0)$ instead of $P_7=(6,0)$ | confirmed numerically; "In code" framing: see F1 | `check.py` |
| 24 | the page's scripts stop at $t=4-10^{-9}$ | confirmed | both scripts use `range(t_min + 1e-9, t_max - 1e-9, …)` |
| 25 | with four control points and knots $(0,0,0,0,1,1,1,1)$, a cubic B-spline is exactly the cubic Bézier curve | confirmed | B-spline basis vs Bernstein $\binom{3}{i}t^i(1-t)^{3-i}$ agree to 1.1e-16 (`more.py`); consistent with the Bézier page's $B(t)$ on $[0,1]$ |
| 26 | Mathews' B-spline construction is another route to the interpolating Cubic Splines | confirmed | Mathews' module builds the natural or clamped cubic spline; the cubic-splines page is about interpolating cubic splines |
| 27 | links `../bezier-curves/` and `../cubic-splines/` | confirmed | both directories exist with `index.qmd`; the `../slug/` form matches other pages |
| 28 | anchors `{#case-1}` and `{#case-2}` on the case headings | confirmed | lines 52 and 60; the Description links `#case-1` and `#case-2` match |

## 3. Checks

**Scope of the diff:** one file changed, `index.qmd` (29 insertions, 7 deletions). No script or GIF changed, so the animations are not under review. Outside the Description, the only changes are the two heading ids `{#case-1}` and `{#case-2}`, which are allowed. The Animations introduction and the Behavior paragraphs are unchanged, and no sentence was moved. The old Description sentences that were removed (convex hull, local support, smoothness) were replaced by restatements that agree with them.

**The six points of the standard:**
1. The problem: present (line 12).
2. The core formula: present as display math in the scripts' notation ($N_{i,k}$, $t_i$, $P_i$, order $k$), and it is exactly what `bspline_basis` implements.
3. What it assumes: present (nondecreasing knots, $n\ge k$, $n+k$ knots, multiplicity $\le k-1$, clamped vector).
4. How accurate it is: present (no convergence order for a design curve; $O(h^4)$ with the correct hypotheses when used for interpolation).
5. When it fails or misleads: present, three concrete modes tied to Case 1 and the scripts (control points off the curve, weak local support, the endpoint evaluation trap).
6. Where it fits: present (Bézier and Cubic Splines).

Nothing the standard leaves out was added (no proofs, theorem boxes or code procedures).

**Word count:** 397 by the manifest and 396 by my own count (`wc.py`). Both are within 150–400.

**Consistency with the rest of the page:** no contradiction with the Case 1 or Case 2 Behavior paragraphs, the alt texts, or the closing Mathews note on line 68. The one internal tension is between the page's own lines 16/31 and 22 (F1).

**Frames:** final frame of bsplineaa: the curve stays above y = 0 between the ends, ends at the red marker on (6,0), and misses the interior control points. Final frame of bsplinebb: seven basis functions, with the dashed sum at 1.0 across [0,4]. Both agree with the new text.

**Mechanical checks:** the manifest reports none found, and I found no broken markup in the new LaTeX (the cases environment, `\text{}` and `\qquad` are all inside `$$`).

**Fidelity:** Mathews' module uses uniform translated cubic B-splines for interpolation, while this page uses parametric Cox-de Boor curves. That difference is already disclosed on line 68 and in the new line 37, so there is no Fidelity finding.
