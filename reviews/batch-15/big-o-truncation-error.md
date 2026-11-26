# Big "O" Truncation Error — batch 15 review (round 1)

Page: `pages/numerical-methods/big-o-truncation-error/` (new page; concept page with the adapted overview standard). Mode: full review of the one animation case; the Description (all new text) checked in overview mode.

**Result: 0 Error, 0 Misleading, 2 Minor.** Both Minor findings were spot-checked by the director (not by an independent checker; Minor findings are reported unverified by the skill's rule).

Archive consulted: `n2003/BigOMod.html`, all its formula images (gr_4–gr_176), solution pages lnk_2, 3, 6, 7, 8, 9, the textbook extract `bigoh/BigOProof.pdf` (Mathews and Fink, §1.3), and `a2001/Animations/Interpolation/Series/`.

## Findings

### F1. Minor — Page text (Description): a claim about another page is wrong

- **Location:** last paragraph of the Description: "a degree-$n$ Taylor polynomial on [Maclaurin and Taylor Series](../maclaurin-and-taylor-series/) leaves a remainder $O(h^{n+1})$ when $f \in C^{n+1}$, …"
- **What is there:** the sentence says the Maclaurin and Taylor Series page states the Taylor remainder as $O(h^{n+1})$ under $f \in C^{n+1}$.
- **What is true:** that page never states it. Its Description gives $T_n(x)$ and speaks generally of "order of accuracy"; it has no remainder term, no $O(\cdot)$ and no $C^{n+1}$ hypothesis. The mathematics of the sentence is right (Taylor's theorem; Mathews' Theorem 1.16).
- **How we know:** `grep -n -i -E 'O\(|remainder|C\^' pages/numerical-methods/maclaurin-and-taylor-series/index.qmd` finds nothing of the kind (director re-ran it). The other four pointers are accurate: Trapezoidal states $O(h^2)$ for $f \in C^2$ (line 18), Simpson's $O(h^4)$ for $f \in C^4$ (lines 17–23), Euler global error $O(h)$ (lines 20–21), Numerical Differentiation uses $D_3$ with $O(h^2)$ (lines 15–21).
- **Correction:** do not attribute the statement to that page, e.g. "Taylor's theorem gives a degree-$n$ Taylor polynomial (see [Maclaurin and Taylor Series](…)) a remainder $O(h^{n+1})$ when $f \in C^{n+1}$; …"

### F2. Minor — Page text / Fidelity (Description): the claim against Mathews' quotient condition is unshown and depends on its reading

- **Location:** combination-rules paragraph: "(Mathews' condition, $g(h) \ne 0$ and $q(h) \ne 0$, is not enough.)"
- **What is there:** a flat statement that the textbook's hypothesis is insufficient, with no counterexample.
- **What is true:** it holds when Mathews' condition is read as "$g(h)\neq0$ and $q(h)\neq0$ for small $h\neq0$". Counterexample: $f=p=1$, $q(h)=h$, $g(h)=h+h^2$; then $g=q+O(h^2)$, both nonzero for $0<|h|<1$, but $p/q-f/g = 1/(1+h)\to1$, which is not $O(h^r)$ for any $r\ge1$. The page's replacement condition $q(0)\neq0$ is sufficient: $g\to q(0)\neq0$, so $gq$ is bounded away from 0 and $f/g-p/q = [(f-p)q-p(g-q)]/(gq) = O(h^{\min(m,n)})$. If Mathews' condition is read as holding on a neighbourhood including $h=0$ (his Definition 1 uses $0\le|h|\le\delta$), it already implies $q(0)\neq0$ and is enough; the textbook extract (Theorem 1.15) does not settle which reading is meant.
- **How we know:** sympy `limit(1/h - 1/(h+h**2), h, 0)` = 1 (reviewer, and director re-ran it).
- **Correction:** add the reading and the counterexample in a few words, e.g. "(Mathews' condition, $g(h)\ne0$ and $q(h)\ne0$, is not enough if it is required only for $h\ne0$: with $f=p=1$, $q=h$, $g=h+h^2$, $p/q-f/g\to1$.)"

## Unresolved

None.

## Inventory (director's Phase 1)

- Scripts: `bigoaa.jl` → `bigoaa.gif` (13 frames). Ran in scratch; GIF byte-identical to the committed file.
- No control characters, leftover placeholder sections, localhost links or code blocks; every page link and case anchor resolves; every `.jl`/`.gif` in the folder is referenced; the section index links the page (Fundamentals section).
- Description prose: 374 words (director's count; reviewer counted 379, the difference being the callout heading). Within 150–400.

## Claim ledger (reviewer)

### Description

| # | Claim | Verdict |
|---|---|---|
| D1 | Problem: error vanishes as $h\to0$ or $n\to\infty$; Big O compares it with $h^p$ or $1/n$ | Confirmed |
| D2 | Def. 1 (functions): $C>0$, $\delta>0$, $\lvert f(h)\rvert\le C\lvert g(h)\rvert$ for $0\le\lvert h\rvert\le\delta$ | Confirmed; matches gr_6–gr_10 |
| D3 | Def. 2 (sequences): $C>0$, $N$, $\lvert x_n\rvert\le C\lvert y_n\rvert$ for $n\ge N$ | Confirmed; matches gr_36–gr_39 |
| D4 | Def. 3: $\lvert f-p\rvert\le M\lvert h\rvert^n$ for small $h$ means $f=p+O(h^n)$ | Confirmed; equivalent to gr_52–54 (page omits "M>0, n a positive integer", immaterial) |
| D5 | Only the limit matters; constants not part of the notation | Confirmed |
| D6 | Ex. 1: $\lvert h^4+2h^5\rvert\le3\lvert h\rvert^3$ for $\lvert h\rvert\le1$, $C=3$, $\delta=1$ | Confirmed (grid max of ratio 3.0 at $h=1$); matches gr_18–20 |
| D7 | Ex. 2: $(n^2-1)/n^3\le1/n$ for all $n\ge1$, $C=1$, $N=1$ | Confirmed (algebra; $n<10^5$); matches gr_43/45 |
| D8 | Rules $O(h^p)+O(h^p)=O(h^p)$; $O(h^p)+O(h^q)=O(h^{\min})$; $O(h^p)O(h^q)=O(h^{p+q})$ | Confirmed; matches gr_122–126 |
| D9 | $c\,O(h^p)=O(h^p)$ | Confirmed (not among Mathews' listed rules) |
| D10 | $p+q$, $pq$ approximate $f+g$, $fg$ with order $O(h^{\min(m,n)})$ (polynomials) | Confirmed by proof |
| D11 | $p/q$ approximates $f/g$ with the same order if $q(0)\ne0$ | Confirmed by proof |
| D12 | Mathews' condition is not enough | Confirmed under the "$h\ne0$" reading; unshown and reading-dependent (F2) |
| D13 | $e^h$, $\cos h$ expansions | Confirmed (sympy); matches gr_132 |
| D14 | $e^h+\cos h=2+h+h^3/6+O(h^4)$ | Confirmed; remainder $h^4/12+\dots$; gr_134 |
| D15 | $e^h\cos h=1+h-h^3/3+O(h^4)$ | Confirmed; gr_136 |
| D16 | $e^h/\cos h=1+h+h^2+2h^3/3+O(h^4)$ | Confirmed; gr_138/142 |
| D17 | General: $E=Kh^p+O(h^{p+1})$, $K\ne0$ ⇒ $\lvert E\rvert/h^p\to\lvert K\rvert$, halving divides by about $2^p$ | Confirmed |
| D18 | Case 1 shows both for the Taylor polynomials of $e^h$ | Confirmed |
| D19 | Leading term of the sum's error is $h^4/12$ | Confirmed |
| D20–D23 | Table rows $h=0.1, 0.05, 0.025, 0.0125$ | Confirmed (8.41669e-6/0.0841669; 5.23438e-7/0.08375/16.0796; 3.26335e-8/0.0835417/16.0399; 2.03705e-9/0.0834375/16.0200) |
| D24 | Big O says nothing about a fixed $h$ | Confirmed |
| D25 | Ex. 3: $P_3$, $P_5$ of $\sin h$, errors $O(h^5)$, $O(h^7)$ | Confirmed; gr_101–104 |
| D26 | At $h=7$: $P_5$ error 89.2, $P_3$ 50.8 | Confirmed (89.2347, 50.8237) |
| D27 | Central difference at 0: $1.7\times10^{-9}$ at $h=10^{-4}$, about $6\times10^{-9}$ at $h=10^{-8}$ | Confirmed in Python and Julia |
| D28 | Maclaurin and Taylor page states remainder $O(h^{n+1})$ for $f\in C^{n+1}$ | Wrong (F1) |
| D29–D31 | Trapezoidal/Simpson/Euler/Numerical Differentiation pointers | Confirmed against those pages |
| D32 | Limits: 150–400 words; one `callout-important` | Confirmed |
| D33 | Concept-page points all present (problem, definitions, rules, where it fits, module examples 1–4) | Confirmed |
| D34 | `[Case 1](#case-1)` and page links resolve | Confirmed |

### Animations section

| # | Claim | Verdict |
|---|---|---|
| A1 | New, no Mathews original | Confirmed (module's Animations link is the Series folder) |
| A2 | 30 surviving Series GIFs, none plotting error against $h$ | Legacy inventory; count confirmed, contents not individually checked |
| A3–A4 | $E_n=e^h-P_n$ for $P_1..P_3$; orders $O(h^2..h^4)$; $P_3$ is Example 4's expansion | Confirmed |
| A5 | $h$ halves from 1 to $2^{-10}$ | Confirmed |
| A6 | Each frame adds a point; newest is the large marker; last frame held | Confirmed (13 frames; frames 11–13 identical) |
| A7–A9 | Panels, dashed/dotted lines, labels | Confirmed (frames 1, 6, 13) |
| A10 | 256-bit BigFloat ≈ 77 digits | Confirmed |
| A11 | Double precision gives $3.775\times10^{-14}$, not $3.790\times10^{-14}$, for $P_3$ at $2^{-10}$ | Confirmed (3.774758e-14 vs 3.790302e-14) |
| A12 | "Not animated" sentence | Confirmed against gr_96–118, 127–130, 143–146, 169–176 |
| A13 | Heading, link, embed | Confirmed |
| B1 | Ratio shrinks steadily with $h$ | Confirmed (strictly monotone on the 201-point grid, $n=1,2,3$) |
| B2–B3 | Ratios 0.7183/0.2183/0.05162 at $h=1$; 0.5002/0.1667/0.04167 at $2^{-10}$; above the limits | Confirmed |
| B4 | $\lvert E_n\rvert\le h^{n+1}$ on $(0,1]$ | Confirmed (max ratio 0.71828) |
| B5 | For $-1\le h<0$, $\lvert E_n\rvert\le\lvert h\rvert^{n+1}/(n+1)!$ | Confirmed (max 0.49983) |
| B6–B8 | Halving factors 4.830/9.202/17.873 → 4.001/8.002/16.003, decreasing, above $2^p$ | Confirmed |
| ALT | Alt text | Confirmed |

## Implementation check: `bigoaa.jl`

- **Method:** $P_n(h)=\sum_{j\le n}h^j/j!$; $E_n=\exp(h)-P_n(h)$ in 256-bit BigFloat, rounded to Float64; reference lines $h^{n+1}$; limits $1/(n+1)!$. Correct.
- **Numbers:** an instrumented scratch copy was compared with an independent 60-digit mpmath tail sum $\sum_{j>n}h^j/j!$ (free of the cancellation in $e^h-P_n$). Every printed digit agrees at all 11 values of $h$; e.g. $k=10$: $E_1$ 4.770e-7, factor 4.001, $R_1$ 0.5002; $E_3$ 3.790e-14, factor 16.003, $R_3$ 0.04167; $E_2$ 1.553e-10, 8.002, 0.1667.
- **Reference values:** limits and slopes correct; BigFloat far more than enough.
- **Picture:** frames 1, 6, 13 viewed; titles, legend, labels, markers correct; axis limits contain every value (nothing clamped); legend covers no data; regenerated GIF byte-identical.
