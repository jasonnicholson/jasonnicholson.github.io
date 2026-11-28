# Taylor Series Method for ODE's — batch 22 review, round 3 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: pages/numerical-methods/taylor-series-method-for-odes/index.qmd (batch 22, light pass, overview mode). The diff changes only index.qmd. No script or GIF changed, so the animations were not re-reviewed. The diff in EV is identical to `git diff 147040f` for the page. Mathews archive consulted: n2003/TaylorDEMod.html, including the theorem images gr_11 to gr_20. I did not run MATLAB or quarto and modified nothing in the repository. All scratch work is in EV/reviewer/ (chk.py, chk2.py, prec.png).

## 1. Findings

None.

Observation, not a finding: the sentence moved out of the Animations introduction lost its trailing clause, "— giving local accuracy of $O(h^{p+1})$ for order $p$". The words it keeps are unchanged. The dropped content is restated more precisely in the Description's accuracy paragraph ("local truncation error is $O(h^{p+1})$"), so nothing is lost or contradicted.

## 2. Claim ledger (the + lines of the diff, plus the moved sentence)

Independent checks: sympy total derivatives of f = 1 − t·y^(1/3); my own numpy Taylor stepper of orders 3 and 4 using the real cube root; references from scipy DOP853 (rtol 1e-13) and mpmath odefun (30 digits). y(5) = 0.008119920464868 from both.

1. The method solves the IVP y' = f(t,y), y(t0) = y0 on [t0, b] at nodes t_n = t0 + nh. Confirmed (standard; matches the Mathews module).
2. Moved sentence: the method uses the ODE to compute higher derivatives analytically and then advances by a truncated Taylor series. Confirmed. The words are unchanged apart from the dropped clause noted above.
3. Display formula: order p keeps the terms through h^p, $y_{n+1} = y_n + h y'_n + \cdots + h^p/p!\, y^{(p)}_n$. Confirmed. It is the formula taylor3_step and taylor4_step implement.
4. $y' = f$, $y'' = f_t + f_y f$, with y^(k) evaluated at (t_n, y_n). Confirmed.
5. For this f, $y'' = -\sqrt[3]{y} - \tfrac{t}{3} y^{-2/3} y'$. Confirmed: the sympy difference is 0. It is also the script's yd2.
6. "Mathews assumes f continuous and Lipschitz in y". Confirmed against the Mathews theorem text: "Assume that f(t,y) is continuous and satisfies a Lipschits condition in the variable y".
7. The method needs the partial derivatives of f through order p−1. Confirmed (y^(p) involves partials up to order p−1).
8. f is smooth wherever y > 0. Confirmed.
9. The solution stays positive on [0,5], decreases after its peak, and y(5) ≈ 0.00812. Confirmed: minimum on [0,5] is y(5) = 0.0081199; strictly decreasing after the peak at t ≈ 0.8836 (checked on 100001 points).
10. General result: if f ∈ C^p near the solution (so y ∈ C^{p+1}[t0,b]), the local truncation error is O(h^{p+1}) and the global error |y(t_n) − y_n| is O(h^p), including at t = b. Confirmed. The hypotheses are correct, and it matches Mathews' Precision theorem (y ∈ C^{n+1}[t0,b], local O(h^{n+1}), global and final global error O(h^n)).
11. Halving h from 5/60 to 5/120 divides the largest node error by 8.8 (Case 1, p = 3) and 17.9 (Case 2, p = 4). Confirmed:
    - p = 3: 6.719e-5 → 7.640e-6, ratio 8.795.
    - p = 4: 6.723e-6 → 3.765e-7, ratio 17.855.
12. Those ratios are close to 2^3 = 8 and 2^4 = 16. Confirmed.
13. The error in y(5) printed in the frames falls by 4.0 (order 3) and 580 (order 4) over the same halving. Confirmed:
    - Order 3, errors against the script's own reference: −2.926e-9 → −7.280e-10, ratio 4.02.
    - Order 4: 8.235e-9 → 1.423e-11, ratio 578.8.
    - Frames aa/015 and bb/020 show −2.9e-09 and +1.4e-11, as do the corresponding frames.
14. "partly because at m = 60 the last steps lie in the shaded region". Confirmed:
    - Shading: frame aa/015 shades from t ≈ 4.51. For order 4 the shaded runs are m ≤ 70, which includes 60. At m = 120 neither order is shaded.
    - At m = 60, 5 steps (order 3) and 4 steps (order 4) start with h|∂f/∂y| above the limit; at m = 120, none do.
    - Off-shade halvings give regular ratios. Order 3: 7.3 to 9.6 (90→180, 100→200, 120→240, 150→300, 200→400, 300→600). Order 4: 22 to 36.
    - So the m = 60 values are the outliers, and the hedge "partly" is accurate.
15. The method is explicit, so stability limits its step. Confirmed.
16. On y' = λy, one step multiplies y_n by the degree-p Taylor polynomial of hλ. That factor exceeds 1 in size once h|λ| passes 2.513 (p = 3) or 2.785 (p = 4). Confirmed: brentq gives 2.512745 and 2.785294.
17. ∂f/∂y = −t/(3y^{2/3}) reaches −41.3 at t = 5. Confirmed: −41.255.
18. Coarse steps pass the limit in the tail (the shaded regions). Confirmed (frames aa/003, bb/003, aa/015).
19. The runs with m = 12 to 36 (order 3) and m = 12 to 32 (order 4) leave the reference there. Confirmed: the largest node error is at least 0.029 for order 3 at m ≤ 36 and 2.5e-4 at m = 40; for order 4 it is 0.089 at m = 32 and 2.7e-3 at m = 36. This is consistent with both Behavior paragraphs.
20. At m = 16, the order-3 run ends at y(5) ≈ 0.156 and the order-4 run at ≈ −7666. Confirmed: 0.156316 and −7665.873. Frames aa/003 and bb/003 show 0.1563161 and −7665.8734003.
21. This page's y'''' has eight terms over 27y^{8/3}. Confirmed: sympy gives a numerator in c = y^{1/3} with 8 terms over 27c^8, identical to the script's yd4_f (difference 0).
22. Euler's method is the case p = 1. Confirmed.
23. Heun's method and the Runge-Kutta method reach orders 2 and 4 from values of f alone. Confirmed.
24. All three of those pages animate a step-refinement sweep on the same problem. Confirmed: the Euler, Heun and Runge-Kutta pages each have a sweep on y' = 1 − t∛y, y(0) = 1 on [0, 5].
25. Links ../eulers-method-for-odes/, ../heuns-method/, ../runge-kutta-method/, ../big-o-truncation-error/ and ../maclaurin-and-taylor-series/ all resolve. Confirmed: each folder exists with an index.qmd.
26. Anchor ids added: {#case-1} on the Case 1 heading and {#case-2} on the Case 2 heading. Confirmed. The links [Case 1](#case-1) and [Case 2](#case-2) match them.

## 3. Checks

**Six points of the overview standard:**
- Problem: present (line 12).
- Core formula: present, in display math, in the page's notation (y_n, h, t_n, m).
- Assumptions: present (continuity, Lipschitz, partials through p−1, y > 0 here).
- Accuracy: stated as a general result with its hypotheses, then checked on Case 1 and Case 2 by the error ratios.
- Failure modes: present (stability limit with the shaded regions and runs linked to the cases; derivative cost).
- Where it fits: present (Euler, Heun, Runge-Kutta, Big O, Maclaurin/Taylor).

No proofs or theorem boxes.

**Word count:** 400 by my independent count. I counted alphanumeric tokens in prose lines 12–37, with inline math as 1 word and display math excluded. That matches the manifest and is exactly at the upper limit, so within the 150–400 range.

**Consistency with the rest of the page:**
- Case 1's Behavior quotes a largest node error of 1.3e-5 at m = 100 (I get 1.327e-5) and a stability threshold of m ≤ 82.
- Case 2's Behavior quotes 8.0e-7 (I get 8.02e-7) and m ≤ 74.
- The visible-departure ranges (to m = 36 and to m = 32) agree with the Description.
- No contradiction found.

**Scope of the diff outside the Description:** the only changes are:
- the overview sentence moved out of the Animations introduction (trailing clause dropped; its content is restated in the Description, see the observation above);
- the {#case-1} and {#case-2} heading ids.

No other section changed. No script or GIF changed.

**Markup:** \sqrt[3]{}, \tfrac, y^{(k)}_n, y'''' and |…| inline are all valid KaTeX. The $$…$$ block is well-formed.
