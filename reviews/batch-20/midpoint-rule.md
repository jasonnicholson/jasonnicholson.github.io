# Midpoint Rule — batch 20 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/midpoint-rule/index.qmd` (light-pass batch 20, overview, action *extend*). Diff: `EV/diff.patch`. The diff changes only `index.qmd`: Description lines 12–51, plus `{#case-1}` on the Case 1 heading (line 60). It changes no script and no GIF, so the animations were not re-reviewed beyond checking the frames the new text points to. I consulted the Mathews archive: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/MidpointRuleMod.html` and its formula images `MidpointRuleMod_gr_28.gif`, `_gr_29.gif` and `_gr_31.gif`. I did not run MATLAB or quarto, and I changed nothing in the repository. My scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-20/midpoint-rule/reviewer/` (`check.py`, `extra.py`, `wc.py`).

## 1. Findings

**F1 — Page text, Minor.**
- **Location:** `index.qmd` line 32. The sentence reads "…so for smooth $f$ the midpoint error is about half the trapezoidal error and of opposite sign."
- **What is wrong:** the conclusion does not follow from the two error formulas alone, because each formula has its own $c$. The ratio of −1/2 holds asymptotically only when $\int_a^b f''=f'(b)-f'(a)\neq0$. When $f'(a)=f'(b)$, both $\Delta x^2$ terms vanish and the ratio is different, even for very smooth $f$.
- **Evidence (`extra.py`):**
  - For $g=x^2(1-x)^2$ on $[0,1]$, $E_M/E_T=-0.8750$ at n = 10, 20 and 40.
  - For the periodic function $e^{\cos 2\pi x}$ on $[0,1]$, $E_M/E_T=-0.998$, −0.99993 and −0.999998 at n = 3, 4 and 5.
- **Why only Minor:** "about" and "for smooth $f$" hedge the sentence, and it is the usual textbook comparison. The exception needs the special case $f'(a)=f'(b)$, where both errors are higher order anyway. The page's own case is not affected. The neighbouring claim "halving $\Delta x$ typically divides it by about 4" carries the same exception, but "typically" already covers it.
- **Suggested correction:** "…so for smooth $f$ with $f'(a)\ne f'(b)$ the midpoint error is, for small $\Delta x$, about half the trapezoidal error and of opposite sign."

No other findings. The Description agrees with the Animations Behavior paragraph, the Derivation Notes, the linked Trapezoidal and Riemann-sum pages, and Mathews' corollary.

## 2. Claim ledger (the + lines of the diff)

The reference integral is $I=\int_0^2 f=2.016279719617\ldots$. I computed it with mpmath at 30 digits in two ways that agree: the substitution $x=t^3$, and a 40-panel split.

| # | Claim (page words) | Verdict | Evidence |
|---|---|---|---|
| 1 | The midpoint rule approximates $\int_a^b f$ by rectangles, like a Riemann sum, with each height taken at the midpoint | confirmed | Definition; the script's `midpoint_sum` |
| 2 | $M_n=\Delta x\sum_{i=0}^{n-1} f(a+(i+\tfrac12)\Delta x)$, $\Delta x=(b-a)/n$ | confirmed | Same as the script (`(b-a)/n`, `i+0.5`) and Mathews `_gr_27` |
| 3 | Each rectangle is centred at its midpoint sample, the red dots in the animation | confirmed | Frames 3 and 4 and the contact sheet; the script's `scatter!` uses red markers |
| 4 | $M_n$ converge to the integral for every Riemann-integrable $f$ | confirmed | Midpoint sums are tagged Riemann sums with mesh going to 0 |
| 5 | The error formula needs $f\in C^2[a,b]$ | confirmed | Mathews `_gr_29`: "f(x) ∈ C²[a,b]" |
| 6 | Each rectangle has the same area as the region under the tangent line at its midpoint, so the rule is exact for linear $f$ | confirmed | $\int (f(m)+f'(m)(x-m))\,dx=f(m)h$; for $3x+1$ on [0,2] with n = 3, error = 0 |
| 7 | The first term it misses involves $f''$ | confirmed | Follows from claim 6 (Taylor expansion) |
| 8 | Mathews: if $f\in C^2$, there is a $c\in(a,b)$ with $\int f-M_n=(b-a)f''(c)\Delta x^2/24$ | confirmed | Mathews `_gr_28` ($\int=M+E_M$) and `_gr_31` ($E_M=(b-a)f''(c)h^2/24$), same sign convention |
| 9 | Error is $O(\Delta x^2)$; halving typically divides it by about 4 | confirmed | Follows from claim 8; "typically" covers $f'(a)=f'(b)$ |
| 10 | The trapezoidal error is $-(b-a)f''(c)\Delta x^2/12$, with its own $c$ | confirmed | Standard result; matches line 24 of the Trapezoidal page |
| 11 | For smooth $f$ the midpoint error is about half the trapezoidal error, of opposite sign | confirmed with a missing hypothesis (F1) | Needs $f'(a)\neq f'(b)$: counterexample ratios −0.875 and about −1 |
| 12 | Left- and right-endpoint sums are in general only first order | confirmed | Standard; "in general" |
| 13 | Case 1 shows what happens when the hypothesis fails | confirmed | See claims 14–16 |
| 14 | Case 1 integrand $e^{-x}\sin(8x^{2/3})+1$ | confirmed | `f(x)` in `midpointaa.jl` line 7; the Case 1 heading |
| 15 | $f'$ is unbounded at 0, so $f\notin C^2[0,2]$ | confirmed | $f'\sim\tfrac{16}{3}x^{-1/3}$ |
| 16 | The error shrinks only like $\Delta x^{5/3}$ | confirmed | Halving ratios 2.859, 3.092, 3.142, 3.157, 3.164, 3.167, 3.169, 3.171 (n = 10 to 1280), approaching $2^{5/3}=3.1748$; consistent with the $x^{2/3}$ singularity |
| 17 | Ratios 2.86, 3.09, then 3.14 | confirmed | 2.859, 3.0923, 3.1419 |
| 18 | $2^{5/3}\approx3.17$, not 4 | confirmed | 3.1748 |
| 19 | For n from 40 to 120 the midpoint error is about −0.37 times the trapezoidal error, not −1/2 | confirmed | $E_M/E_T$ is −0.3662 (n = 40), −0.3669, −0.3673, −0.3676, −0.3678, −0.3681 and −0.3683 (n = 120) |
| 20 | Table row n = 10, Δx = 1/5: $M$ = 2.043030, error 0.02675 | confirmed | 2.0430303, 0.0267506; frame shows 2.04303 |
| 21 | Row n = 20, Δx = 1/10: 2.025636, 0.009357, ratio 2.86 | confirmed | 2.0256363, 0.0093566; frame shows 2.025636 |
| 22 | Row n = 40, Δx = 1/20: 2.019305, 0.003026, ratio 3.09 | confirmed | 2.0193055, 0.0030258; frame shows 2.019305 |
| 23 | Row n = 80, Δx = 1/40: 2.017243, 0.0009630, ratio 3.14 | confirmed | 2.0172428, 0.00096304; frame shows 2.017243 |
| 24 | The rows are frames of Case 1, each halving Δx; $I\approx2.016280$; ratio = previous error / this error | confirmed | 10, 20, 40 and 80 are all in `n_seq`; $I$ = 2.0162797 |
| 25 | A coarse partition can miss the shape of $f$; a single estimate says nothing about its own error | confirmed | General remark, supported by claims 26–27 |
| 26 | With two subintervals the samples at $x$ = 0.5 and 1.5 fall near the two dips; $M_2\approx1.231$, 0.79 below $I$ | confirmed | The dips (minima) are at 0.432 (f = 0.357) and 1.564 (f = 0.796); f(0.5) = 0.426 and f(1.5) = 0.806; $M_2$ = 1.231216, error −0.78506; frame 3 shows 1.231216 and both dots on the troughs |
| 27 | $M_4\approx2.0111$ is closer to $I$ than every frame from 6 to 28 sample points | confirmed | $|E_4|$ = 0.005161; the errors at 6, 8, 10, 12, 14, 16, 20, 24 and 28 are 0.0430 down to 0.005428, all larger; at 32 it is 0.004364, which is smaller, so "28" is the correct cut-off; frame 4 shows 2.011118 |
| 28 | The midpoint rule is the one-point Gauss-Legendre rule on each subinterval | confirmed | 1-point G-L: node 0, weight 2 |
| 29 | The midpoint rule is the simplest open Newton-Cotes formula | confirmed | Standard (n = 0 open formula) |
| 30 | $S_{2n}=(2M_n+T_n)/3$ is Simpson's Rule on $2n$ subintervals | confirmed | Identity checked numerically: differences of 4e-31 and 0 for n = 4 and n = 10 |
| 31 | In that combination the two leading errors cancel for smooth $f$ | confirmed | $2E_M+E_T$: the $h^2$ terms cancel |
| 32 | (Moved or edited outside the Description) Case 1 heading id `{#case-1}` | confirmed | Allowed cross-reference; `[Case 1](#case-1)` on line 35 resolves to it |

The removed sentences of the old Description ("Riemann-style…", "often much more accurate than left/right endpoint sums") were replaced inside the Description, not moved anywhere. No sentence was moved out of the Animations introduction.

## 3. Checks

**The six points of the overview standard.** All six are present, in order:
1. The problem: line 12.
2. The core formula as display math, in the script's notation (`n`, `dx`): lines 15–17.
3. What it assumes (Riemann-integrable $f$ for convergence, $C^2$ for the error formula): lines 21–22.
4. How accurate it is (the general error term with its hypothesis, the order, and the trapezoidal comparison): lines 24–33.
5. When it fails or misleads, linked to Case 1 and checked on the case's own values (the $\Delta x^{5/3}$ rate and the luck of coarse partitions): lines 35–49.
6. Where it fits (Gauss-Legendre, Newton-Cotes, Simpson, plus Riemann sums and Trapezoidal earlier on): line 51.

The worked-example table has 4 rows (at most about 6 allowed) and uses the page's own problem. Its numbers match the GIF frames. There are no proofs and no callout boxes. Line 24 is a one-line intuition.

**Word count.** I counted 398 words of prose under the manifest's rules (inline math = 1 word; display math and table rows excluded; punctuation-only tokens dropped), using `reviewer/wc.py`. This matches the manifest, and is within 150–400, though at the upper edge.

**Links and anchors.** All targets exist:
- `../riemann-sums/`
- `../trapezoidal-rule-for-numerical-integration/`
- `../gauss-legendre-quadrature/`
- `../newton-cotes-integration/`
- `../simpsons-rule-for-numerical-integration/`
- `#case-1`, which matches the explicit id on line 60.

**Consistency with the rest of the page.**
- The Behavior paragraph says "from 6 sample points on it stays above": this agrees with claim 27, since $M_4$ is below $I$ and $M_6$ onward are above.
- The Behavior paragraph's "3.11 from 24 to 48": I computed 3.1125, which agrees with the table's ratios.
- The Behavior paragraph's "midpoint closer than left/right from 4 sample points on": I recomputed it as true for every frame n ≥ 4.
- The Derivation Notes' "$O(\Delta x^2)$, factor of 4 for smooth $f$" agrees with the Description.
- The Trapezoidal page states the same error formula and the same $I$.
- No contradictions found.

**Fidelity.** The error term, its hypothesis $f\in C^2[a,b]$, its sign convention ($\int=M+E_M$) and the denominator 24 all match Mathews' corollary. The example function and interval are Mathews' animation problem. No fidelity findings.

**Scope of the diff.** Only `index.qmd` changed. Outside the Description, the only change is the `{#case-1}` heading id, which the standard allows. No script or GIF changed, so the animations are out of scope. I checked frames 3 (n = 2), 4 (n = 4) and the contact sheet only to confirm the values and features the new text cites.
