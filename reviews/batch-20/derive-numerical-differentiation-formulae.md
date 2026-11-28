# Derive Numerical Differentiation Formulae — batch 20 review, round 1 (overview mode)

SUMMARY: 0 Error, 1 Misleading, 1 Minor

Page: `pages/numerical-methods/derive-numerical-differentiation-formulae/index.qmd`, light-pass batch 20, overview page (extend). The diff changes only `index.qmd`: Description lines 12–45, plus `{#case-1}`, `{#case-2}` and `{#case-3}` added to the three case headings. No script or GIF changed, so the animations were not reviewed in full. I consulted the Mathews archive, `n2003/NumericalDiffFormulaeMod.html` and its formula images gr_12–23, gr_95–105 and gr_59–64/160–171, which I rendered to `reviewer/mathews_setup.png` and `reviewer/mathews_formulas.png`. Everything I made is in `EV/reviewer/`: `sym.py`, `peano.py`, `num.jl`, `wc.py`, `frame_text.png` and the two montages. I ran no MATLAB and no quarto, and changed nothing in the repository.

## 1. Findings

**F1 — Page text / Fidelity — Misleading.** Lines 14–22: "Each sample is replaced by its Taylor polynomial about $x_0$ ... with $j=\pm1$ and $n=2$ for three points, or $j=\pm1,\pm2$ and $n=4$ for five points. ... Keeping the next Taylor term as the remainder, the solutions for the first two derivatives are, as Mathews states them, [four formulas]".
- *What is there now.* The recipe uses a Taylor polynomial of degree n, with n = 2 or 4, and keeps one more term, degree n+1. That recipe produces the two $f'$ remainders correctly. It produces no remainder at all for the two $f''$ formulas. In the symmetric combination that gives $f''$, the degree-(n+1) term cancels. The $-\frac{h^2}{12}f^{(4)}$ and $+\frac{h^4}{90}f^{(6)}$ remainders on the page come from the degree-(n+2) term.
- *Evidence.* `sym.py` solves the linear system for the unknowns $f',\dots,f^{(n)}$, with the Taylor expansion kept to the given degree:
  - Three points, Taylor degree 3 (n+1): d1 remainder $= -d_3h^2/6$, d2 remainder $= 0$.
  - Three points, Taylor degree 4: d2 remainder $= -d_4h^2/12$.
  - Five points, Taylor degree 5: d1 $= d_5h^4/30$, d2 remainder $= 0$, d4 remainder $= 0$.
  - Five points, Taylor degree 6: d2 $= d_6h^4/90$ and d4 $= -d_6h^2/6$.
- *Mathews.* His module expands to degree n = 4 for three points (gr_12/13: `n = 4; s[h_] = Series[f[x0+h],{h,0,n}]`) and n = 6 for five points (gr_97/99: `k = 2; n = 2k+2`). That is two terms beyond the unknowns, precisely so that both remainders appear. So the page's "n=2 / n=4" plus "the next Taylor term" is not what Mathews does, even though the text attributes the formulas to him.
- *Effect.* The displayed formulas are correct. A reader who follows the recipe as written gets no remainder for $f''$.
- *Suggested fix.* Either keep n but say "Keeping the Taylor terms through degree $n+2$ (the degree-$(n+1)$ term cancels from the $f''$ formulas) ...", or follow Mathews: the Taylor polynomial of degree $n+2$ (n = 4 and 6), with unknowns $f'$ to $f^{(n)}$.

**F2 — Page text — Minor.** Line 37: "As a general result, the three-point formulas are $O(h^2)$ and the five-point formulas $O(h^4)$, so halving $h$ divides their truncation errors by about 4 and 16."
- The O-orders are right, given the $C^3$–$C^6$ hypotheses on line 34.
- The "divides by about 4 and 16" part holds only as $h\to0$ and only when the leading derivative in the remainder is nonzero at $x_0$. Counterexample: $f(x)=x+x^5$ at $x_0=0$ has $f'''(0)=0$. Its three-point slope is $1+h^4$, so halving $h$ divides that error by 16, not 4.
- The case evidence on lines 38–39 is correct for this page's function.
- *Suggested fix.* Add "when the derivative in the remainder is nonzero at $x_0$", or write "typically".

## 2. Claim ledger (diff `+` lines; no sentences were moved)

1. L12: the page concerns central-difference formulas for $f'(x_0)$ and $f''(x_0)$ from equally spaced points symmetric about $x_0$. **Confirmed**: it matches the formulas and the scripts.
2. L13: the legacy module derives both derivatives together, in parallel. This is history and attribution, so it is not checked as a claim. Mathews' text does say "parallel development", consistent.
3. L16–18: Taylor polynomial $f(x_0+jh)\approx\sum_{k=0}^n (jh)^k f^{(k)}(x_0)/k!$. **Confirmed** as a formula.
4. L20: $j=\pm1$ with n=2 for three points, $j=\pm1,\pm2$ with n=4 for five points. **Confirmed** that this gives square systems: 2×2 in $f',f''$ and 4×4 in $f'..f^{(4)}$. It differs from Mathews' expansion degree; see F1.
5. L21: the unknowns $f'..f^{(n)}$ form a small linear system, and one solve yields all the formulas. **Confirmed** (`sym.py`).
6. L22: "Keeping the next Taylor term as the remainder" yields the displayed remainders. **Wrong** for the two $f''$ formulas (F1).
7. L26: $f'=\frac{f(x_0+h)-f(x_0-h)}{2h}-\frac{h^2}{6}f^{(3)}(c)$. **Confirmed**: the stencil is exact through $x^2$, its $x^3$ defect gives $-1/6$, and it matches Mathews gr_59–61.
8. L27: $f''=\frac{f(x_0+h)-2f(x_0)+f(x_0-h)}{h^2}-\frac{h^2}{12}f^{(4)}(c)$. **Confirmed**: coefficient $-1/12$, matches Mathews gr_62–64.
9. L28: five-point $f'$, weights $(1,-8,0,8,-1)/12h$, remainder $+\frac{h^4}{30}f^{(5)}(c)$. **Confirmed**: coefficient $1/30$, matches Mathews.
10. L29: five-point $f''$, weights $(-1,16,-30,16,-1)/12h^2$, remainder $+\frac{h^4}{90}f^{(6)}(c)$. **Confirmed**: coefficient $1/90$, matches Mathews.
11. L28–29 formulas are the ones the scripts implement. **Confirmed**: `d1_3` and `d1_5` in diffformab.jl, `d2_3` and `d2_5` in diffformac.jl, with the same weights.
12. "as Mathews states them". **Confirmed** for all four formulas and their signs.
13. L33: the formulas assume exact samples at equally spaced points. **Confirmed**.
14. L34: each equation holds for some $c$ between the outermost points if the derivative in the remainder is continuous, so $f\in C^3, C^4, C^5, C^6$. **Confirmed**. `peano.py` shows all four Peano kernels have one sign on the stencil interval: d1_3 in [−0.25, 0], d2_3 in [−0.167, 0], d1_5 in [0, 0.0278], d2_5 in [0, 0.0111]. Their integrals are −1/6, −1/12, 1/30 and 1/90. So the mean-value form with a single $c$ in $[x_0-kh, x_0+kh]$ is valid.
15. L35: by symmetry each remainder contains only even powers of $h$. **Confirmed**: the weights are odd or even, and the sympy remainders are $h^2$ and $h^4$ only.
16. L37: three-point formulas are $O(h^2)$ and five-point formulas $O(h^4)$ (general). **Confirmed**.
17. L37: halving $h$ divides the truncation errors by about 4 and 16. **Confirmed only when the leading derivative is nonzero** (F2).
18. L38: in Case 1, (f'(1) − three-point slope)/$h^2$ stays between −0.171 and −0.169. **Confirmed**: over Case 1's h-values 0.6 … 0.001 it runs from −0.170667 (h=0.6) to −0.169442.
19. L38: it approaches $-f^{(3)}(1)/6\approx-0.1694$. **Confirmed**: $f'''=2e^{-x}(\sin x+\cos x)$ (checked numerically), and $-f'''(1)/6=-0.169442$.
20. L39: in Case 2, from h=0.02 to h=0.01 the three-point and five-point errors fall by factors 4.00 and 15.99. **Confirmed**: 4.0000 and 15.9949 in Float64 (15.9948 truncation-only). Both h-values are frames of Case 2. The frames print |err3| 6.78e-05 → 1.69e-05 and |err5| 2.36e-09 → 1.48e-10 (`frame_text.png`), consistent.
21. L41: the five-point system also yields $f'''$ and $f^{(4)}$ formulas, which are only $O(h^2)$. **Confirmed**: sympy gives $-h^2f^{(5)}/4$ and $-h^2f^{(6)}/6$, matching Mathews gr_166–171 and the page's Derivation Notes line 91.
22. L42: each sample carries a rounding error of about $\varepsilon|f|$ with $\varepsilon\approx2.2\times10^{-16}$; the $f'$ and $f''$ formulas divide it by $h$ and $h^2$; for small $h$ it outweighs truncation. **Confirmed** as a general statement, and consistent with the Numerical Differentiation page line 66.
23. L43: Case 3 at h=0.005 has five-point $f''$ max error 5.5e-11, almost all truncation. **Confirmed**: computed 5.516e-11, truncation-only (256-bit) 5.500e-11, both at x=0.0100. The frame prints 5.52e-11.
24. L43: Case 3 at h=0.002 has truncation alone 1.4e-12 while the computed error is 5.9e-11. **Confirmed**: truncation-only max 1.417e-12 (at x=0.004); computed max 5.892e-11 (at x=0.784). The frame prints 5.89e-11.
25. L45: Numerical Differentiation adds one-sided formulas and studies roundoff further. **Confirmed**: that page has forward and backward $D_2^\pm, D_3^\pm$ (lines 22, 94–124) and a roundoff discussion (lines 65–66).
26. L45: Richardson Extrapolation reaches the five-point $f'$ formula as $(4D(h)-D(2h))/3$. **Confirmed**: the algebra gives $[f(x-2h)-8f(x-h)+8f(x+h)-f(x+2h)]/12h$. That page gives the equivalent $(4D_3(h/2)-D_3(h))/3$ (line 25) and names this form (line 58).
27. L45: Big "O" Truncation Error explains the order notation. **Confirmed**: its Description defines O(h).
28. L45: Maclaurin and Taylor Series covers the expansions. **Confirmed**: the page exists.
29. Heading ids `{#case-1}`, `{#case-2}`, `{#case-3}`, and the links `#case-1/2/3` on lines 38, 39 and 43. **Confirmed**: each id is on the right case and each link resolves.

## 3. Checks

**Six points of the overview standard.**
1. Problem: line 12. Present.
2. Core formula: display math on lines 24–31, in the animations' notation ($x_0$, $h$). Present.
3. Assumptions: lines 33–34. Present.
4. Accuracy: lines 37–39, with case pointers. Present; the hypothesis is incomplete (F2).
5. Failure modes: line 41 (higher derivatives only $O(h^2)$) and lines 42–43 (rounding, linked to Case 3). Present.
6. Where it fits: line 45, four links. Present.

No proofs and no callout boxes.

**Word count.** The manifest gives 365. My own count (`wc.py`, inline math = 1 word, display math removed) gives 383. Both are within 150–400.

**Links and anchors.** All four relative links point at existing `index.qmd` folders. The three case anchors match the explicit ids.

**Scope of the diff.** `git diff` matches `EV/diff.patch`, and only `index.qmd` changed. Outside the Description, the only changes are the three heading ids, which are allowed. No GIFs or scripts changed.

**Consistency with the rest of the page.** The Description agrees with:
- the Animations introduction;
- the Case 2 and Case 3 Behavior paragraphs (Case 3's 5.5e-11 → 5.9e-11 matches);
- the Derivation Notes ($O(h^2)$ and $O(h^4)$; $f'''$ and $f^{(4)}$ only $O(h^2)$).

No contradictions found.

**Numbers recomputed.** I recomputed every number independently in Julia (`num.jl`), reusing the scripts' formulas and h-lists, with BigFloat for the truncation-only errors. The values are in ledger entries 18–24.


## Independent check of F1 (a separate checker given only the allegation)

**F1: confirmed. Misleading is the right severity.**

**The page's recipe.** Lines 16–22 say to use Taylor polynomials of degree n, with n=2 for three points and n=4 for five points, solve for f'(x0)…f^(n)(x0), and keep "the next Taylor term" as the remainder.

**What that recipe actually gives (sympy).** I ran a symbolic check in /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-20/derive-numerical-differentiation-formulae/checker/chk.py. It expands each sample through degree n+1, then through n+2, and solves the linear system for the derivatives.
- **Three points, n=2, kept through degree 3:**
  - f' = (F1−F−1)/(2h) − h²/6·f'''. This matches the page.
  - f'' = (F1−2F0+F−1)/h² with **no remainder at all**. The degree-3 term cancels by symmetry. The −h²/12·f⁽⁴⁾ term only appears when degree 4 is kept.
- **Five points, n=4, kept through degree 5:**
  - f' gets +h⁴/30·f⁽⁵⁾. This matches the page.
  - f'' again gets **no remainder**. The +h⁴/90·f⁽⁶⁾ term only appears when degree 6 is kept.

So the stated recipe reproduces the two f' remainders but not the two f'' remainders. A reader who follows it gets a "formula" for f'' with no truncation term.

**What Mathews does.** I read the module's formula images (enlarged copies are in .../checker/img/):
- The three-point section says to use degree "n = 4" (gr_12.gif, line 64), and the Taylor polynomial is formed by Normal at "n = 4" (gr_17.gif, line 77).
- The five-point section uses "n = 6" (gr_95.gif, line 250; gr_97.gif, line 254).
- The module says "Terms must be included so that the remainder term is included", then keeps the first term of the remainder series for each derivative, either f''' or f⁽⁴⁾, and evaluates that lowest-order derivative at c instead of x0 (ReplaceAll).

So Mathews expands to degree n+2: 4 for three points and 6 for five. The page's n=2 and n=4 are not his degrees, yet the page attributes the result to him ("as Mathews states them").

**Why Misleading and not Error.** The four displayed formulas and their remainders are correct. What is wrong is the recipe the page describes and its attribution to Mathews. A reader would believe a degree-n expansion with one extra term yields the f'' remainders, which it does not. One could argue for Error, because the recipe taken literally gives a different result for f''. But the visible results are right, so Misleading fits best.

**Possible fix.** Expand to degree 4 (three points) or 6 (five points), as Mathews does. Then solve for f' and f'' and keep the lowest-order surviving term in each as the remainder.
