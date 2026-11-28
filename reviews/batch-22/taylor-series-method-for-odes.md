# Taylor Series Method for ODE's — batch 22 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 3 Minor

Page: `pages/numerical-methods/taylor-series-method-for-odes/index.qmd`. This is an overview page in light-pass batch 22, action *write*. The diff touches only index.qmd: no scripts and no GIFs.
I consulted the Mathews archive: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/TaylorDEMod.html`, read as text.
My scratch work is in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-22/taylor-series-method-for-odes/reviewer/`:
- `check.py`: sympy derivatives, an independent real-cube-root Taylor solver, and a DOP853 reference at rtol 1e-13.
- `wc.py`: word count.
- `taylorderivative{aa,bb}_3_15_20.png`: frames for m = 16, 60 and 120.

## 1. Findings

**F1 (Page text, Minor).** Description paragraph 1, sentence 2 (this is the sentence moved from the Animations intro): "The Taylor method uses the ODE … — giving local accuracy of $O(h^{p+1})$ for order $p$."
- **The problem:** It uses $p$ before the next sentence defines it ("The method of order $p$ keeps the terms through $h^p$"). It states the general accuracy result with no hypothesis. It also shows the truncated series inline just before the full display formula. Paragraph 4 restates the same result properly, with $y\in C^{p+1}$.
- **Status:** Nothing is false, and the move kept the words unchanged as the rules require. The result is redundancy, and an accuracy claim placed before its hypotheses.
- **Suggested correction:** Place the moved sentence after the display formula. Or, if the director allows it, drop its trailing clause "— giving local accuracy …", because paragraph 4 already covers it.

**F2 (Page text, Minor).** Description, last paragraph: "[Euler's method] is the case $p = 1$, and [Heun's method] and the [Runge-Kutta method] … ; all three animate the same sweep on the same problem."
- **The problem:** The problem is the same on all three pages: $y'=1-t\sqrt[3]{y}$, $y(0)=1$ on $[0,5]$. The sweep is not. The forward-Euler case (the $p=1$ method the sentence names, `eulersmethodaa.jl` line 16) uses `ms = [10, 15, 20, …, 150]`, which is 20 values starting at 10. Only Euler Case 2 (modified Euler), Heun Case 1 and RK4 use this page's 21-value list `[12, 14, …, 150]`. I confirmed this by grepping `ms =` in the three pages' scripts.
- **Suggested correction:** "…; all three animate a step-refinement sweep on the same problem."

**F3 (Page text, Minor).** Description paragraph 4: "…the global error … is $O(h^p)$, including at $t = b$." It is followed by: "The error in $y(5)$ printed in the frames falls less regularly: over the same halving, by $4.0$ for order 3 and by $580$ for order 4."
- **The numbers are right.** From the printed frame values: −2.9e-9 / −7.3e-10 ≈ 3.97, and 8.2e-9 / 1.4e-11 ≈ 586. From unrounded values: 4.019 and 578.8.
- **The problem:** No reason is given, and the ratio 4.0 (below $2^3$) sits right after "including at $t=b$". A reader may take it as evidence against the $O(h^3)$ endpoint result.
- **Why the ratios are irregular:** $m=60$ still lies inside the shaded, amplifying regime for both orders. The frames show shading from t ≈ 4.51 for order 3 and t ≈ 4.67 for order 4, and the Animations text says amplifying steps occur for m = 12–77 (order 3) and m = 12–60 (order 4). Halvings that start further out behave more regularly:
  - Order 3: 100→200 gives 8.07, 120→240 gives 9.0, 150→300 gives 9.5.
  - Order 4: 100→200 gives 30.3, 150→300 gives 22.4. These are still pre-asymptotic.
- **Status:** The sentence is hedged ("less regularly"), so it is not false.
- **Suggested correction:** Add a clause such as "because at $m=60$ the last steps still lie in the shaded region".

## 2. Claim ledger (+ lines and the moved sentence)

1. "solves an initial value problem $y'=f(t,y)$, $y(t_0)=y_0$ on $[t_0,b]$ at the nodes $t_n=t_0+nh$": **confirmed**. This matches the scripts (`ts = t0 + i*h`).
2. The moved sentence, "uses the ODE to compute higher derivatives analytically, then advances via a truncated Taylor series … local accuracy $O(h^{p+1})$ for order $p$": **confirmed** as a general result. Its placement is F1. The words are unchanged from the removed Animations-intro sentence (diff checked).
3. Display formula $y_{n+1}=y_n+hy'_n+\dots+\frac{h^p}{p!}y^{(p)}_n$: **confirmed**. It matches `taylor3_step` (h, h²/2, h³/6) and `taylor4_step` (… h⁴/24).
4. "$y'=f$, $y''=f_t+f_y f$": **confirmed**. This is the chain rule.
5. "For this page's $f$, $y''=-\sqrt[3]{y}-\tfrac t3 y^{-2/3}y'$": **confirmed**. The sympy difference from the true total derivative is 0, and it matches `yd2` in both scripts.
6. "Mathews assumes that $f$ is continuous and satisfies a Lipschitz condition in $y$": **confirmed**. The TaylorDEMod.html theorem says: "Assume that f(t,y) is continuous and satisfies a Lipschits condition in the variable y."
7. "the method also needs the partial derivatives of $f$ through order $p-1$": **confirmed**, since $y^{(p)}$ involves partials of $f$ through order $p-1$.
8. "Here $f$ is smooth wherever $y>0$": **confirmed** as stated. It is also smooth for $y<0$ with the real cube root; it is only non-smooth at $y=0$.
9. "the solution stays positive on $[0,5]$": **confirmed**. The minimum of the DOP853 reference on [0,5] is 0.0081199 at t = 5.
10. "decreasing after its peak": **confirmed**. The peak is 1.44977 at t ≈ 0.8836, and the reference is strictly decreasing after it on a 500001-point grid.
11. "to $y(5)\approx0.00812$": **confirmed** (0.0081199205).
12. "if $y\in C^{p+1}[t_0,b]$, local truncation error $O(h^{p+1})$, global error $O(h^p)$, including at $t=b$": **confirmed**. It matches Mathews' "Precision of Taylor Series Method of Order n" theorem, and the Lipschitz assumption is stated in the paragraph before.
13. "halving $h$ from $5/60$ to $5/120$ divides the largest error at the nodes by $8.8$ (order 3)": **confirmed** (6.719e-5 / 7.640e-6 = 8.795). The maximum is at t ≈ 3.17 and 3.12, outside the shaded region, so the ratio is not polluted by amplification. Other halvings agree: 50→100 gives 8.66, 100→200 gives 8.41, 150→300 gives 8.30.
14. The same claim for order 4, "by $17.9$": **confirmed** (6.723e-6 / 3.765e-7 = 17.86). The maximum is at t ≈ 3.33 and 3.29. Other halvings: 50→100 gives 21.1, 100→200 gives 17.5, 150→300 gives 17.2.
15. "close to $2^3=8$ and $2^4=16$": **confirmed**.
16. "error in $y(5)$ printed in the frames falls … by $4.0$ for order 3 and by $580$ for order 4": **confirmed** (frames: −2.9e-9 → −7.3e-10; +8.2e-9 → +1.4e-11). The missing reason is F3.
17. "The method is explicit, so stability limits its step": **confirmed**.
18. "one step multiplies $y_n$ by $1+h\lambda+\dots+(h\lambda)^p/p!$": **confirmed**. This is the Taylor polynomial of $e^{h\lambda}$.
19. "exceeds 1 in size once $h|\lambda|$ passes $2.513$ for $p=3$ or $2.785$ for $p=4$": **confirmed**. mpmath roots are −2.512745 and −2.785294; R₃ = −1 there and R₄ = +1. The scripts give the same values (comments 2.5127 and 2.7853).
20. "$\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$": **confirmed** (−41.255).
21. "coarse steps pass the limit in the tail (the shaded regions)": **confirmed**. Shading in the frames starts at t ≈ 3.17 (order 3, m=16), 3.22 (order 4, m=16), 4.51 (order 3, m=60) and 4.67 (order 4, m=60).
22. "the runs with $m=12$ to $36$ for order 3 (Case 1) … leave the reference there": **confirmed**. It is consistent with the Case 1 Behavior text, which was reviewed before.
23. "and $m=12$ to $32$ for order 4 (Case 2) leave the reference there": **confirmed**, consistent with Case 2.
24. "at $m=16$ the order-3 run ends at $y(5)\approx0.156$": **confirmed** (0.1563161 computed and in frame 3).
25. "and the order-4 run at $y(5)\approx-7666$": **confirmed** (−7665.873 computed and in frame 3).
26. "this page's $y''''$ has eight terms over $27y^{8/3}$": **confirmed**. The sympy numerator in $c=y^{1/3}$ has 8 terms over $27c^8$ and equals `yd4_f` (difference 0).
27. "[Euler's method] is the case $p=1$": **confirmed**.
28. "[Heun's method] and the [Runge-Kutta method] reach orders 2 and 4 from values of $f$ alone": **confirmed**.
29. "all three animate the same sweep on the same problem": the problem is **confirmed**; the sweep is **wrong** for forward Euler (F2).
30. The [Big "O" Truncation Error] and [Maclaurin and Taylor Series] links: **confirmed**. Both target pages exist, and their descriptions are not checked here.
31. The heading ids `{#case-1}` and `{#case-2}`, and the links `#case-1` and `#case-2`: **confirmed**. They are the ids added in the diff and used in four links.

## 3. Checks

**Six points of the standard:**

| Point | Present? | Where |
|---|---|---|
| 1. Problem | Yes | Paragraph 1 |
| 2. Core formula | Yes | Display math, in the scripts' notation |
| 3. Assumptions | Yes | Paragraph 3: continuous, Lipschitz, partials through p−1 |
| 4. Accuracy | Yes | General statement with C^{p+1}, pointing to Case 1 and Case 2 with computed ratios |
| 5. Failure modes | Yes | Stability limit and derivative cost, with links to cases |
| 6. Where it fits | Yes | Euler, Heun, RK, Big-O, Taylor series |

The order is slightly disturbed by the moved sentence (F1). There are no proofs and no callout boxes.

**Word count:** 399 prose words, counting inline math as 1 word, excluding display math and punctuation-only tokens. My own count agrees with the manifest. This is within 150–400, at the upper edge.

**Links and anchors:** All five relative page links resolve to existing `index.qmd` folders. `#case-1` and `#case-2` match the explicit ids added to the two case headings.

**Scope of the diff:** Outside the Description there are only two changes:
- The removal of one sentence from the Animations intro, which is moved verbatim into Description paragraph 1.
- `{#case-1}` and `{#case-2}` added to the case headings.

Nothing else changed. No scripts or GIFs changed, so Questions 1 and 2 on the animations do not apply.

**Independent computation:**
- **Derivatives:** sympy total derivatives of $f$ for $y''$ and $y''''$ match the script expressions exactly. The script's `yd3` is consistent with the y''' comment.
- **Taylor runs:** I wrote my own Taylor solver with the real cube root, for p = 3 and 4.
- **Reference:** scipy DOP853 at rtol 1e-13 gives y(5) = 0.0081199205.
- **Results:** m = 16 / 60 / 120, y(5), node maximum errors and their ratios as listed in the ledger. They match the printed frame values.

I did not run MATLAB, quarto or any repository script.
