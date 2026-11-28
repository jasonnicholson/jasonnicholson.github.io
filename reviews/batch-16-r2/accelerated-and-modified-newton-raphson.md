# Accelerated and Modified Newton-Raphson — batch 16 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/accelerated-and-modified-newton-raphson/index.qmd`, light-pass batch 16, overview mode (action *extend*). The diff changes only `index.qmd`: the Description (lines 12–49) and three heading ids. No script or GIF changed, so the animations were not re-reviewed. I consulted the Mathews archive (`n2003/NewtonAccelerateMod.html`, read as text). I did not read `reviews/`, did not run MATLAB or quarto, and modified nothing in the repository. My scratch files are in `EV/reviewer/`: `check.py` (mpmath at 50 digits plus sympy) and `dp.jl` (double precision, using the scripts' own expressions).

## Part 1: Findings

**F1 (Page text, Minor).** Line 46 says: "Rounding also limits both methods, because near a double root $f(x_n) \approx 3e_n^2$ is small and computed with a large relative error."
- **What is wrong:** the coefficient 3 is $f''(x^*)/2$ for this particular cubic, since $f = e^2(e+3)$ with $e = x - 1$. It is not a general fact about double roots. Saying "a double root" makes it read as a general statement. For a general double root, $f(x_n) \approx \tfrac12 f''(x^*)\,e_n^2$.
- **Why it is only Minor:** for this page's $f$ the statement is true. The surrounding text is about the page's cubic, and the reasoning (f is small and suffers cancellation) holds in general. Reproducing it: with $x_2 = 1.0000061$ from Method A, Julia gives $f = 1.12 \times 10^{-10}$ against $3e^2 = 1.117 \times 10^{-10}$. At $x_3$, Julia's `f(x)` returns exactly 0.0.
- **Suggested fix:** change "near a double root" to "near the double root", or write $f(x_n) \approx \tfrac12 f''(x^*)\,e_n^2 = 3e_n^2$.

## Part 2: Claim ledger (diff `+` lines; no sentences were moved)

1. L12: these methods find a root of multiplicity $m \ge 2$, where standard Newton slows down. **Confirmed.**
2. L13: Mathews' definition of a root of order m ($f = \dots = f^{(m-1)} = 0$ at $x^*$, $f^{(m)} \ne 0$, with $f^{(m)}$ continuous near $x^*$). **Confirmed** against the archive. Mathews assumes f and its derivatives are continuous on an interval about p, which is equivalent.
3. L15: in general, standard Newton is quadratic at simple roots and linear at multiple roots, with $e_{n+1} \approx \tfrac{m-1}{m} e_n$. **Confirmed.** This matches Mathews' theorem. The signed form is valid because the fixed-point derivative $g'(x^*) = 1 - 1/m > 0$.
4. L20–21: Method A recovers the quadratic rate and needs m. **Confirmed.** Sympy gives $e_{n+1} = e_n^2/(3(e_n+2))$ for this f.
5. L28: Method B needs $f''$ at every step. **Confirmed** from the formula.
6. L28: Method B works at simple roots too, because $h$ has a simple root there. **Confirmed.** Sympy: $h'(-2) = 1$ and $h'(1) = 1/2$.
7. L30–31: under smoothness and a close enough $x_0$, both methods converge quadratically, $|e_{n+1}| \approx C|e_n|^2$. **Confirmed** as a general result, with the hypotheses stated.
8. L32: all three cases start from $x_0 = 1.2$ at the double root $x^* = 1$ of $(x-1)^2(x+2)$. **Confirmed** from the scripts: `x0 = 1.2`, and f is $x^3 - 3x + 2$.
9. L33: in Case 1, $e_n/e_{n-1}$ is 0.515, 0.508, 0.504, … and tends to 1/2. **Confirmed.** Computed ratios are 0.51515, 0.50817, 0.50425, …, 0.50001 at n = 12.
10. L34: $e_n/e_{n-1}^2$ tends to 1/6 for Method A. **Confirmed.** Computed values are 0.1515, 0.16616, 0.166666, and the sympy limit is 1/6.
11. L34: the same ratio tends to −1/6 for Method B. **Confirmed.** Computed values are −0.1462, −0.16732, −0.166667, and the sympy limit is −1/6.
12. L34: so Method B's first step lands left of the root. **Confirmed.** $x_1 = 0.9941520$. The exact map is $e_{n+1} = -e_n^2/(e_n^2 + 4e_n + 6)$, and the denominator is always positive, so every step lands left. Frame 2 of `accnewtoncc.gif` shows $x_1 = 0.994152$.
13. L35–42, table "in 50-digit arithmetic":
    - Standard: 2.00e-1, 1.03e-1, 5.24e-2, 2.64e-2.
    - Method A: 6.06e-3, 6.10e-6, 6.21e-12.
    - Method B: −5.85e-3, −5.72e-6, −5.46e-12.
    
    **All 12 entries confirmed** with mpmath at 50 digits: 0.1030303, 0.0523564, 0.0264008; 6.0606e-3, 6.1033e-6, 6.208e-12; −5.848e-3, −5.722e-6, −5.457e-12.
14. L44: with a multiplier $\mu \ne m$ the method is at best linear, $e_{n+1} \approx (1 - \mu/m)e_n$, and converges linearly only for $0 < \mu < 2m$; standard Newton is $\mu = 1$. **Confirmed.** Since $f/f' \approx e/m$, $g'(x^*) = 1 - \mu/m$, and $|g'| < 1$ exactly when $0 < \mu < 2m$. The improved-newton-method page states the same result.
15. L45: with $\mu = 2$ at the simple root −2 the ratio is the borderline −1. **Confirmed:** $1 - 2/1 = -1$.
16. L45: from $x_0 = -2.2$ the iterates alternate sides (−1.844444, −2.193762, …). **Confirmed:** −1.8444444, −2.1937622, −1.8481711, ….
17. L45: they creep in sublinearly, still 0.17 away after ten steps. **Confirmed.** $x_{10} = -2.1735577$, so the error is 0.1736. The errors after 100, 1000, 10⁴ and 10⁵ steps are 0.096, 0.034, 0.011 and 0.0034, which is convergent but sublinear.
18. L46: f is small near the root and computed with a large relative error. **Confirmed for this f** (see F1 on the generality).
19. L47: in double precision the third iterates are $e_3 = 3.6 \times 10^{-12}$ (A) and $8.4 \times 10^{-12}$ (B). **Confirmed.** Julia gives 3.6071146e-12 and +8.3733e-12. Note that B's value is positive in double precision, unlike the table's negative value. The page gives both without a sign, which is correct.
20. L47: at those iterates f evaluates to exactly 0, so later steps change nothing. **Confirmed.** `f(x3) = 0.0`, and $x_4 = x_5 = x_3$ for A and $x_4 = x_3$ for B.
21. L49: both methods modify Newton-Raphson. **Confirmed.**
22. L49: the Improved Newton page adds an adaptive method that needs no m. **Confirmed** (its Method C).
23. L49: the Aitken/Steffensen page speeds up the linear Newton sequence. **Confirmed.** That page applies Aitken's process to Newton iterates at multiple roots.
24. L49: Halley's method uses $f''$ to converge cubically at simple roots. **Confirmed**, and consistent with the Halley page.
25. L60, L68, L76: heading ids `{#case-1}`, `{#case-2}`, `{#case-3}` added. **Confirmed.** They are the only changes outside the Description, and the links on L33–34 match them.

Consistency with the rest of the page:
- Case 1's Behavior ("asymptotic error constant (m−1)/m = 1/2", iterates 1.2, 1.10303, 1.052356, 1.026401, $x_{12} = 1.000052$) agrees with my computation and with the Description.
- Case 2 ($x_1 = 1.006061$, $x_2 = 1.000006$, $x_3 = 1$ to six decimals) and Case 3 ($x_1 = 0.994152$, $x_2 = 0.999994$) also agree.
- The frames I inspected agree: the `accnewtonaa` contact sheet, frame 4 of `accnewtonbb` (legend "x₃ = 1.0") and frame 2 of `accnewtoncc` ($x_1 = 0.994152$).
- I found no contradiction.

## Part 3: Checks

**The six points of the overview standard:**
1. The problem: covered on L12.
2. The core formula: covered, with display formulas for A and B in the same notation as Cases 2 and 3 and as `accnewtonbb.jl` and `accnewtoncc.jl`. The B formula is identical to `modified_newton_step`.
3. What it assumes: covered on L13, L21 and L30 (multiplicity definition, known m for A, smoothness, a close enough $x_0$).
4. How accurate it is: covered on L15 and L31, with general results and hypotheses, checked against the cases' computed ratios on L33–34.
5. When it fails or misleads: covered on L44–47 (wrong m, and rounding near a double root). Neither failure is animated, so there is no case link, which is acceptable.
6. Where it fits: covered on L49.

The worked-example table has four rows, uses the page's own problem, and adds digits the GIFs do not show. There are no proofs, callout boxes or MATLAB/Mathematica procedures.

**Word count:** 399 under the manifest's convention, which I reproduced by counting each inline math expression as one word and ignoring tokens with no letters or digits. That is within 150–400, but right at the upper limit. Counting stray punctuation tokens such as "…" gives 423, so any further addition would breach the limit.

**Links and anchors:**
- `#case-1`, `#case-2` and `#case-3` match explicit ids on L60, L68 and L76.
- `../newton-raphson-method/`, `../improved-newton-method/`, `../aitken-method-and-steffensen-acceleration/` and `../halleys-method/` all exist as folders with an `index.qmd`.
- Judged from the source, the math markup looks sound: `\tfrac`, `\cdots`, math inside the table cells, and attributes after the heading math.

**Scope of the diff:** inside the Description, the existing sentences were split onto one line each with unchanged words, and new text was added. Outside it, the only changes are the three heading ids. There are no script or GIF changes, so Question 1 does not apply. The scripts were read only to confirm that $x_0$, f, the method formulas and $n_\text{iters}$ match the Description.

**Fidelity to Mathews:** the definition of root order, the linear rate (m−1)/m, the accelerated formula with known m, and $h = f/f'$ having a simple root with the modified formula all match the module. I found no fidelity departure in the new text.
