# Least Squares Lines — batch 19 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/least-squares-lines/index.qmd` (light-pass batch 19, overview, action *extend*). Evidence: EV = /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-19/least-squares-lines. My scripts are in EV/reviewer/ (check.py, plus inline sympy checks). I did not run MATLAB or quarto, and I changed nothing in the repository.

I consulted the Mathews archive: `n2003/LeastSqLineMod.html`, and the formula images gr_3, gr_4, gr_5, gr_113 and gr_114 under `n2003/leastsquaresline/LeastSqLineMod/Images/`.

## 1. Findings

None.

One observation that is not a finding: line 46 cites "Case 3's free line $y \approx 0.3571 + 1.4762x$". That line is not drawn in the Case 3 GIF, which shows only the fit through the origin. The sentence is clear that the free fit is computed for comparison, and the value is correct.

## 2. Claim ledger (diff `+` lines, Description lines 12–49, and the heading ids)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L1 | Fits $y = b + ax$ to $n$ points $(x_k, y_k)$, minimizing the squared vertical residuals; $E(a,b) = \sum (b + a x_k - y_k)^2$ | confirmed | Matches the criterion the lslineaa.jl and lslineab.jl scripts implement. |
| L2 | Setting $\partial E/\partial a$ and $\partial E/\partial b$ to 0 gives the normal equations, with solution $a = (n\sum xy - \sum x\sum y)/(n\sum x^2 - (\sum x)^2)$ and $b = (\sum y - a\sum x)/n$ | confirmed | Identical to `fit_unconstrained` in lslineaa.jl. Sympy (n=5, symbolic) shows both formulas equal Mathews' gr_4 and gr_5 forms; the difference is 0. |
| L3 | The second normal equation means the line passes through the centroid and the residuals sum to zero | confirmed | Sympy: $\sum (b + a x_k - y_k)$ simplifies to 0. |
| L4 | "Mathews' power fit $y = a x^m$, with $m$ fixed … $a = \sum x_k^m y_k / \sum x_k^{2m}$" | confirmed | Matches the module's Power Fit theorem (gr_113, gr_114), and matches `fit_through_origin` (m=1) and `fit_kepler_a` (m=3/2). |
| L5 | $m = 1$ is a line through the origin (Case 3); $m = 3/2$ is Kepler's third law $T = a r^{3/2}$ (Case 4) | confirmed | Module remark "The case m = 1 is a line that passes through the origin". Kepler's third law $T^2 \propto r^3$ gives $T = a r^{3/2}$. The case headings match. |
| L6 | The formulas need at least two distinct $x_k$; the denominator equals $n\sum (x_k - \bar x)^2$ | confirmed | Sympy identity, difference 0. |
| L7 | The model treats the $x_k$ as exact and puts all the error in the $y_k$ | confirmed | Follows from the vertical-residual criterion. |
| L8 | Direct method with no convergence order; unique minimum when the $x_k$ are not all equal; the formulas give it exactly up to rounding | confirmed | $E$ is a convex quadratic, and its Hessian determinant is $4n\sum (x - \bar x)^2 > 0$. |
| L9 | Minimum $E = (1 - r^2)\sum (y_k - \bar y)^2$; for $y_k$ not all equal, the line passes through every point only when $\lvert r\rvert = 1$ | confirmed | Sympy identity, difference 0. Exact check on Case 1 for every k=2..8: $(1 - r^2)S_{yy}$ equals the RSS (for example 39/28 at k=7 and k=8). |
| L10 | Adding a point never lowers the minimum; in Case 1 it rises from 0 (two points) to $39/28 \approx 1.3929$ (seven), and the eighth point lands on that line | confirmed | Exact RSS for k=2..8: 0, 1/6, 3/10, 2/5, 74/105, 39/28, 39/28 (non-decreasing). The seven-point line at x=6 gives −1, the eighth point's y. The lslineaa frames print RSS = 0.0, 0.1667, 0.3, 0.4, 0.7048, 1.3929, 1.3929. The general claim holds because each $E_{k+1}(a,b) \ge E_k(a,b)$ pointwise. |
| L11 | Fitting $x$ as a function of $y$ minimizes horizontal residuals and gives a different line | confirmed | This is `fit_x_on_y` in lslineab.jl. Its rearranged slope is −1.6278, against −1.6071 for y on x, with all 8 points. |
| L12 | In general $ac = r^2$, so the lines coincide only for collinear points | confirmed | Sympy identity, difference 0. Coincidence needs $a = 1/c$, which means $r^2 = 1$. |
| L13 | "as in the first frame of [Case 2]" | confirmed | lslineab frame_001 (k=2) reads "k=2: both lines coincide". The green and dashed blue lines overlap through both points. Exact $ac = 1$ at k=2. |
| L14 | For all eight points $r^2 \approx 0.9873$ | confirmed | Exact value 2025/2051 = 0.98732. It agrees with the Case 2 Behavior slopes: −1.6071 / −1.6278 = 0.9873. |
| L15 | Case 3's free line is $y \approx 0.3571 + 1.4762x$ | confirmed | Exact: b = 5/14 = 0.357143, a = 31/21 = 1.476190. |
| L16 | Forcing the line through the origin raises the RSS from 0.4762 to 0.6863 | confirmed | Exact: 10/21 = 0.47619 and 35/51 = 0.68627. lslineac frame_008 prints "a = 1.53922, RSS = 0.6863". |
| L17 | In Case 4, $a$ is the average of the ratios $T_k/r_k^{3/2}$ weighted by $r_k^3$ | confirmed | Algebraic identity. Numerically the weighted average is 0.19976930, equal to `fit_kepler_a` = 0.19976930. The last lslinead frame shows a = 0.199769. |
| L18 | Mars carries 71% of the weight and Mercury about 1% | confirmed | Weights are 0.01149, 0.07599, 0.20123 and 0.71129 (Mercury, Venus, Earth, Mars). |
| L19 | Least Squares Polynomials fits higher-degree polynomials through a larger normal-equation system | confirmed | That page exists and states that its normal equations are $m+1$ linear equations. |
| L20 | Nonlinear Curve Fitting fits exponential and power curves with a least-squares line on the logarithms | confirmed | That page exists, and its Description describes data linearization for $c e^{ax}$ and $c x^a$. |
| L21 | Heading ids `{#case-1}` to `{#case-4}` on the four case headings; links `#case-1`, `#case-2`, `#case-3`, `#case-4` | confirmed | All four ids are present (lines 55, 63, 71, 79) and every Description link targets one of them. A grep found no other page linking into this page's old auto-generated anchors, so nothing breaks. |

## 3. Checks

**The six points of the standard:**
- **The problem:** present (lines 12–13).
- **The core formula:** present as display math in the scripts' notation ($a$, $b$, $x$, $y$; $T$ and $r$ for Case 4). These are the formulas the four scripts implement.
- **What it assumes:** present. It needs at least two distinct $x_k$, and it treats the $x_k$ as exact.
- **How accurate it is:** present. The method is direct and exact up to rounding. The minimum-$E$ formula holds generally and is tied to Case 1 by computed values.
- **When it fails or misleads:** present. Choice of dependent variable (Case 2), bias from a constraint (Case 3), and weighting dominated by the largest $r$ (Case 4), each backed by computed numbers.
- **Where it fits:** present (line 49), with two links to existing pages.
- There are no proofs or callout boxes, and no Mathematica or MATLAB procedures.

**Word count:** 395 by the manifest's rule. I got 410 raw tokens, of which 15 are stray punctuation tokens left after removing inline math, which gives the same 395. That is within the 150–400 limit, near its top.

**Links and anchors:** all resolve (L19–L21).

**Scope of the diff:**
- Only `index.qmd` changed; no script or GIF did, so the animations are not under review.
- Outside the Description, the only changes are the four heading ids, which the standard allows.
- The Animations introduction and the Behavior paragraphs are unchanged.
- The removed Description text (the x-on-y and constrained-model bullets) is replaced by L11–L16 and L4–L5, with no loss of meaning.

**Consistency with the rest of the page:**
- No contradictions. The new text agrees with the Case 1 Behavior (a = −45/28, b = 121/14, eighth point on the seven-point line) and the Case 2 Behavior (slopes −1.6071 and −1.6278, centroid).
- It agrees with the Case 3 Behavior (a = 157/102) and the Case 4 Behavior (a ≈ 0.19977, Mercury's ratio 0.2013).
- Frames checked: the lslineaa contact sheet (all 7 frames), lslineab frame_001, lslineac frame_008, and the lslinead contact sheet (4 frames).

**Fidelity:** the formulas for $a$ and $b$ are algebraically equal to Mathews' (sympy check), and the power-fit formula and the $m = 1$ remark match the module. No departures.
