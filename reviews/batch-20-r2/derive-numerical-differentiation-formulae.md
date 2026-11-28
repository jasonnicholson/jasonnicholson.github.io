# Derive Numerical Differentiation Formulae — batch 20 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/derive-numerical-differentiation-formulae/index.qmd`, light-pass batch 20 (re-review), overview page, action *extend*. The diff (`EV/diff.patch`, and `git diff --stat main...HEAD`) touches only `index.qmd`. It changes Description lines 12–45 and adds `{#case-1}`, `{#case-2}` and `{#case-3}` to the three case headings. No script or GIF changed, so the animations were not re-reviewed in full.

**Mathews archive:** I consulted `n2003/NumericalDiffFormulaeMod.html`. I extracted its text and viewed formula images gr_12, 17, 47, 59–64, 95, 97 and 160–171, which I put together into a montage at `EV/reviewer/key.png`.

**Scratch files:** everything I made is in `EV/reviewer/`: `mathews.txt`, `key.png`, `sym.py` (symbolic derivation and error series), `peano.py` (Peano-kernel sign check), `num.jl` (case numbers in Float64 and BigFloat), `wc.py` (word count) and `frametext.png` (frame annotations).

**What I did not do:** I ran no MATLAB and no quarto, and changed nothing in the repository.

**Disclosure:** a repository-wide `grep` I ran to look for inbound links accidentally printed four lines from files under `reviews/batch-20/`. I did not open or read those files, and nothing in this report relies on them.

## 1. Findings

**F1 — Page text, Minor.**
- **Where:** Description line 43: "at $h=0.005$ the five-point second-derivative error, $5.5\times10^{-11}$, is almost all truncation error, but at $h=0.002$ the truncation error alone is $1.4\times10^{-12}$ while the computed error is $5.9\times10^{-11}$."
- **What is there now:** Case 3 plots error profiles over $x\in[2h,\pi-2h]$, not an error at one point. The quantities quoted are the **maxima** over that window, as the frames show ("max|error 5-point|"). The sentence says "the error" without saying which x.
- **What is true:** the numbers are correct as window maxima. Float64 maximum error is 5.52e-11 at h=0.005 (at x=0.0100) and 5.89e-11 at h=0.002 (at x=0.784). The BigFloat (256-bit) maximum truncation error on the same grid is 5.500e-11 at h=0.005 and 1.417e-12 at h=0.002.
- **Effect:** a reader is not misled about the conclusion, but cannot tell from the Description what "the error" is measured over.
- **Suggested fix:** "at $h=0.005$ the maximum five-point second-derivative error over $[2h,\pi-2h]$, …, but at $h=0.002$ the maximum truncation error alone is $1.4\times10^{-12}$ while the computed maximum error is $5.9\times10^{-11}$."

There are no other findings.

## 2. Claim ledger (diff `+` lines; no sentence was moved)

**L12–L13: the problem**

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | L12: the page derives central-difference formulas that approximate $f'(x_0)$ and $f''(x_0)$ from equally spaced samples symmetric about $x_0$ | confirmed | The displayed formulas are exactly that. |
| 2 | L13: the legacy module derives both derivatives' formulas together, in parallel | confirmed (attribution) | Mathews' text: "This new approach gives a parallel development of the formulas." |

**L14–L22: the derivation recipe**

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 3 | L14–18: each sample is replaced by its Taylor polynomial $\sum_{k=0}^{n+2}(jh)^k f^{(k)}(x_0)/k!$ | confirmed | This is Mathews' recipe: Normal[Series] up to degree "n". |
| 4 | L20: $j=\pm1$, $n=2$ for three points; $j=\pm1,\pm2$, $n=4$ for five points; expansion degree 4 or 6 "following Mathews" | confirmed | Mathews gr_12/gr_17 show n = 4 and gr_95/gr_97 show n = 6. The page's n is Mathews' degree minus 2, and the page says so explicitly. |
| 5 | L21: treating $f',\dots,f^{(n)}$ as the unknowns gives a small linear system, and one solve yields all the formulas | confirmed | `sym.py` solves the 2×2 and 4×4 systems and returns all 2 and all 4 formulas. |
| 6 | L22: two extra terms are needed because the first cancels from the $f''$ formulas | confirmed | In the sympy solutions the $f''$ formulas contain d4 or d6 only; d3 and d5 cancel. The f′ formulas keep d3 and d5. |
| 7 | L22: keep the lowest surviving term as the remainder, "as Mathews states them" | confirmed | Matches Mathews gr_59–64 and gr_160–165, with x₀→c (gr_47). |

**L24–L31: the four displayed formulas** (sympy output is in the same notation)

| # | Formula | Verdict | Evidence |
|---|---|---|---|
| 8 | $f'=\frac{f(x_0+h)-f(x_0-h)}{2h}-\frac{h^2}{6}f^{(3)}(c)$ | confirmed | sympy: F+1/(2h) − F−1/(2h) − d3·h²/6. Same as Mathews gr_60–61. |
| 9 | $f''=\frac{f(x_0+h)-2f(x_0)+f(x_0-h)}{h^2}-\frac{h^2}{12}f^{(4)}(c)$ | confirmed | sympy: −d4·h²/12. Same as gr_63–64. |
| 10 | $f'=\frac{f(x_0-2h)-8f(x_0-h)+8f(x_0+h)-f(x_0+2h)}{12h}+\frac{h^4}{30}f^{(5)}(c)$ | confirmed | sympy: +d5·h⁴/30. Same as gr_161–162. |
| 11 | $f''=\frac{-f(x_0-2h)+16f(x_0-h)-30f(x_0)+16f(x_0+h)-f(x_0+2h)}{12h^2}+\frac{h^4}{90}f^{(6)}(c)$ | confirmed | sympy: +d6·h⁴/90. Same as gr_164–165. |
| 12 | Notation and stencils agree with the scripts | confirmed | The scripts use x0 and h. `d1_3`, `d1_5`, `d2_3` and `d2_5` in diffformaa/ab/ac.jl have the same coefficients. |

**L33–L35: assumptions**

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 13 | L33: the formulas assume exact samples at equally spaced points | confirmed | — |
| 14 | L34: each equation holds for some c between its outermost points if the remainder derivative is continuous there, so $f\in C^3, C^4, C^5, C^6$ | confirmed | `peano.py`: all four Peano kernels have one sign on the stencil (3-pt f′ ≤ 0, 3-pt f″ ≤ 0, 5-pt f′ ≥ 0, 5-pt f″ ≥ 0). Their integrals are exactly −1/6, −1/12, 1/30 and 1/90, so the mean-value form holds. |
| 15 | L35: by symmetry, each remainder contains only even powers of h | confirmed | sympy error series up to a₁₁ (equivalently f⁽¹¹⁾) for all four formulas contain only h², h⁴, …, h¹⁰ (or h⁴, …). |

**L37–L39: accuracy, with the cases**

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 16 | L37: general result: three-point formulas are O(h²) and five-point O(h⁴); halving h divides truncation error by about 4 and 16 when the remainder derivative ≠ 0 at x₀ | confirmed | Follows from #8–11 and #14, and holds in the case checks below. "Five-point" refers to the displayed f′/f″ formulas; L41 qualifies the f‴ and f⁗ formulas. |
| 17 | L38: in Case 1, $(f'(1)-D_3)/h^2$ stays between −0.171 and −0.169 | confirmed | `num.jl` over all 12 frame h values: −0.170667 (h=0.6) … −0.169442 (h=0.001). Float64 and BigFloat agree to 6 digits. |
| 18 | L38: … approaching $-f^{(3)}(1)/6\approx-0.1694$ | confirmed | −f‴(1)/6 = −0.169442, approached monotonically. |
| 19 | L39: Case 2, h=0.02→0.01: three-point and five-point errors fall by factors 4.00 and 15.99 | confirmed | Float64 4.0000 and 15.9949; BigFloat 4.0000 and 15.9948. The frames print \|err3\| 6.78e-05→1.69e-05 and \|err5\| 2.36e-09→1.48e-10, which match `num.jl`. |

**L41–L43: failure modes**

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 20 | L41: the five-point system also gives f‴ and f⁗ formulas, and these are only O(h²) | confirmed | sympy: −d5·h²/4 and −d6·h²/6, matching Mathews gr_166–171. |
| 21 | L42: each sample carries rounding error of about ε\|f\| with ε≈2.2e-16; the f′ and f″ formulas divide it by h and h², so for small h it outweighs truncation | confirmed (general) | Same convention as the Numerical Differentiation page. Estimate at h=0.002: about 2.2e-16·0.32·(64/12)/h² ≈ 9e-11, the same size as the observed 5.9e-11. |
| 22 | L43: Case 3 at h=0.005: five-point f″ error 5.5e-11, almost all truncation | confirmed (see F1 on "maximum") | Float64 maximum 5.52e-11; BigFloat truncation maximum 5.500e-11, both at x=0.0100. The frame prints 5.52e-11. |
| 23 | L43: at h=0.002, truncation alone is 1.4e-12 and the computed error is 5.9e-11 | confirmed (see F1) | BigFloat truncation maximum 1.417e-12; Float64 maximum 5.89e-11 (at x=0.784). The frame prints 5.89e-11. |

**L45: where it fits**

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 24 | Numerical Differentiation adds one-sided formulas and studies roundoff further | confirmed | That page has forward and backward $D_2^\pm$, $D_3^\pm$ (Cases 3–6) and a roundoff paragraph (its lines 62–66). |
| 25 | Richardson Extrapolation reaches the five-point f′ formula as $(4D(h)-D(2h))/3$ | confirmed | Algebra: $[8(f_{+1}-f_{-1})-(f_{+2}-f_{-2})]/(12h)$. The Richardson page gives $(4D_3(x,h/2)-D_3(x,h))/3$ and also cites $(4D_3(x,h)-D_3(x,2h))/3$. |
| 26 | Big "O" Truncation Error explains order notation; Maclaurin and Taylor Series covers the expansions | confirmed | Both pages exist with those subjects. |

**Links and heading ids**

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 27 | Links `#case-1`, `#case-2`, `#case-3` | confirmed | They match the explicit ids added to the case headings. |
| 28 | Heading ids `{#case-1}`, `{#case-2}`, `{#case-3}` (the only edits outside the Description) | confirmed allowed | No inbound links in any .qmd used the old auto-generated anchors. |

## 3. Checks

**The six points of the overview standard:**
1. Problem: L12. Present.
2. Core formula: displayed recipe plus the four formulas, in the scripts' notation (x₀, h). Present.
3. Assumptions: L33–34 (exact equally spaced samples, $C^k$). Present.
4. Accuracy: L35–39, a general result with hypotheses, checked on Cases 1 and 2. Present.
5. Failure modes: L41–43 (f‴/f⁗ only O(h²); rounding, shown in Case 3 and linked). Present.
6. Where it fits: L45. Present.

There are no proofs, theorem boxes or callouts. The derivation recipe is the page's subject, so describing it is within the standard.

**Word count:** 398 by my own count (`wc.py`: display math removed, inline math counted as 1 word, punctuation-only tokens ignored). This agrees with the manifest and is within the 150–400 limit, though at its edge.

**Contradictions with the rest of the page:** none.
- The Derivation Notes (L91: f′/f″ O(h⁴), f‴/f⁗ O(h²)) agree.
- Case 1 Behavior ("second-order") agrees.
- Case 3 Behavior (5.5e-11→5.9e-11, rounding) agrees.
- The formulas in the case headings are identical to the Description's.

**Scope of the diff:** `index.qmd` only.
- Outside the Description, the only changes are the three heading ids.
- The Animations introduction is unchanged.
- The old Description text was replaced, not moved.
- No script or GIF changed, so I did no Question 1 review.
- I compared the scripts' stencils with the Description (ledger #12), and the frame annotations at h = 0.02/0.01 (diffformab), h = 0.005/0.002 (diffformac) and h = 0.6/0.001 (diffformaa) with my recomputed values. All agree.

**Links:** all four relative page links resolve to existing folders with `index.qmd`, and all three case anchors resolve.

**Fidelity:** the formulas, remainder signs and constants, expansion degrees, and the f‴/f⁗ O(h²) "surprise" all match Mathews' module. The page redefines n (its n is Mathews' degree minus 2), but it states the degree explicitly, so this is not a departure.
