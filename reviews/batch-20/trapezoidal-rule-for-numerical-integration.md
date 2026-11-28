# Trapezoidal Rule for Numerical Integration — batch 20 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/trapezoidal-rule-for-numerical-integration/index.qmd` (light-pass batch 20, overview page, action *extend*). I reviewed the diff in EV/diff.patch: 29 added lines and 4 removed, all in index.qmd. The script and GIF are unchanged, so the animations were not under review. Mathews archive consulted: yes (`n2003/TrapezoidalRuleMod.html` and its formula images gr_11–gr_35). I did not run MATLAB or quarto, and I changed nothing in the repository. My scratch work is in EV/reviewer/ (chk.py, labels.png, mathews.png, mathews2.png).

## 1. Findings

**F1 — Page text — Minor.** Location: Description line 27: "Its sign follows $f''$: if $f''>0$ on $[a,b]$, every chord lies above the curve and $T_n$ overestimates the integral."
- **What is there now:** "Its" points back to the error the display just above defines, $\int_a^b f\,dx - T_n = -(b-a)f''(c)h^2/12$. That quantity has the **opposite** sign to $f''$, not the same sign. The rest of the sentence ("$T_n$ overestimates") is correct, and so is the table's $T_n-I$ convention. The only problem is that "its sign follows $f''$" contradicts the error the display defines. It also leaves out that the statement needs $f''$ to keep one sign on $[a,b]$.
- **How I know:** the display gives $\int - T_n = -(b-a)f''(c)h^2/12$. So $f''>0$ gives $\int - T_n<0$, which means $T_n - I > 0$.
- **Suggested fix:** "If $f''$ keeps one sign on $[a,b]$, then $T_n-I$ has that sign: if $f''>0$, every chord lies above the curve and $T_n$ overestimates the integral."

No other findings.

## 2. Claim ledger (+ lines of the diff)

1. The rule approximates $\int_a^b f$ from values of $f$ at equally spaced nodes. **Confirmed** (the script samples $a+i\,dx$).
2. $h=(b-a)/n$, $x_i=a+ih$, $i=0..n$, with $f$ replaced on each subinterval by the line segment between neighbouring nodes. **Confirmed.** Same notation as the script (`n`, `dx=(b-a)/n`). The frames draw these chords.
3. $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1} f(x_i)+\tfrac12 f(x_n)]$. **Confirmed.** It matches the script's `trapezoid_sum`, and my independent $T_n$ values match the GIF labels (see item 14).
4. The rule works for any $n\ge1$. **Confirmed.** The script itself uses $n=1$.
5. The rule is exact when $f$ is linear. **Confirmed** (a chord equals a linear $f$).
6. $T_n$ is the average of the left and right Riemann sums. **Confirmed** numerically: $(L+R)/2-T_7 = 0.0$ at 40 digits.
7. Hence $T_n$ converges to the integral for every continuous $f$. **Confirmed** (Riemann sums converge for continuous $f$).
8. The error formula needs $f\in C^2[a,b]$. **Confirmed.** This matches the Mathews corollary hypothesis (image gr_29).
9. "As Mathews states it": $\int_a^b f - T_n = -(b-a)f''(c)h^2/12$ for some $a<c<b$. **Confirmed** against Mathews gr_27/gr_28/gr_31 ($\int = T + E_T$, $E_T = -(b-a)f^{(2)}(c)h^2/12$, $a<c<b$). The sign convention is correct.
10. The error is $O(h^2)$, and halving $h$ typically divides it by about 4. **Confirmed** as a general result, hedged with "typically". It matches Mathews' Remark (step size reduced by 1/2, error by about 1/4).
11. "Its sign follows $f''$; if $f''>0$ every chord lies above the curve and $T_n$ overestimates." The second half is **confirmed**. The first half is worded against the displayed error convention (F1).
12. Case 1's integrand is $f(x)=e^{-x}\sin(8x^{2/3})+1$. **Confirmed**; it matches the script's `f` and the Case 1 heading.
13. $f'$ is unbounded at $x=0$, so $f\notin C^2[0,2]$. **Confirmed.** $f'(x)/(\tfrac{16}{3}x^{-1/3}) = 0.99999999747$ at $x=10^{-9}$.
14. The error shrinks only like $h^{5/3}$. **Confirmed.** Successive ratios are 2.728, 3.076, 3.142, 3.158, 3.165, 3.168, 3.170, 3.171, 3.172, 3.173 (n = 6 up to 6144). They rise toward $2^{5/3}=3.1748$.
15. "Halving $h$ divides it by 3.08, 3.14 and then 3.16." **Confirmed** (3.07626, 3.14152, 3.15833).
16. $2^{5/3}\approx 3.17$. **Confirmed** (3.17480).
17. The single trapezoid gives 2.017925. **Confirmed**: computed 2.0179248, and frame_002 reads "Approximation = 2.017925".
18. That is "only about 0.0016 above the integral". **Confirmed** (+0.0016451).
19. With two subintervals the error jumps to about +0.357. **Confirmed** (+0.356647; frame_003 shows 2.372927). The Behavior paragraph's "+0.36" agrees.
20. Table row n=6, h=1/3: $T_n$ = 1.855188, error −0.1611. **Confirmed**: 1.855187869 and −0.161092. Frame_007 reads 1.855188.
21. Row n=12, h=1/6: 1.957234, error −0.05905, ratio 2.73. **Confirmed**: 1.957233895, −0.0590458, 2.72825. Frame_011 reads 1.957234.
22. Row n=24, h=1/12: 1.997086, error −0.01919, ratio 3.08. **Confirmed**: 1.997085696, −0.019194, 3.07626. Frame_016 reads 1.997086.
23. Row n=48, h=1/24: 2.010170, error −0.006110, ratio 3.14. **Confirmed**: 2.010169926, −0.00610979, 3.14152. Frame_020 reads "2.01017"; `round` drops the trailing zero, so it is the same value.
24. Row n=96, h=1/48: 2.014345, error −0.001934, ratio 3.16. **Confirmed**: 2.014345221, −0.00193449889 (rounds to −0.001934), 3.15833. Frame_023 reads 2.014345.
25. "The rows are frames of Case 1, each halving $h$." **Confirmed.** n = 6, 12, 24, 48, 96 are all in the script's `n_seq` (frames 7, 11, 16, 20, 23).
26. $I=\int_0^2 f\approx 2.016280$. **Confirmed**: 2.0162797196. I computed it two ways with mpmath, once through the substitution $x=t^3$ that removes the singularity and once directly with breakpoints; both agree to 40 digits.
27. The ratio is the previous row's error divided by this row's. **Confirmed**; it is consistent with the values above.
28. The trapezoidal rule is the degree-1 member of the Newton-Cotes family. **Confirmed** (closed Newton-Cotes).
29. The Midpoint Rule has the same $O(h^2)$ order. **Confirmed** (standard result for $C^2$ functions).
30. One Richardson step $(4T_{2n}-T_n)/3$ gives Simpson's $S_{2n}$. **Confirmed** numerically: the difference is about $10^{-41}$ for n = 1, 3, 5. It is also consistent with the Simpson page's $S_n$ notation and its line 37.
31. Romberg Integration repeats that step on successive trapezoidal sums. **Confirmed**; consistent with the Romberg page line 36.
32. The heading id `{#case-1}` was added to the Case 1 heading. **Confirmed** as an allowed edit, and the `[Case 1](#case-1)` link resolves to it.

Contradiction check against the rest of the page: I found none. The Behavior paragraph's +0.36, "shrinks at every frame from 4 subintervals", 3.14 (24→48), $2^{5/3}\approx3.17$, $I\approx2.016280$ and the 2.017925 coincidence all agree with the new Description.

## 3. Checks

**Six points of the overview standard:**
1. Problem: present (line 12).
2. Core formula: present as display math, in the script's notation (lines 15–17).
3. What it assumes: present. It states equally spaced nodes, any $n\ge1$, continuity for convergence, and $f\in C^2$ for the error formula.
4. How accurate it is: present, as a general result with its hypothesis (the Mathews error term, $O(h^2)$, ratio about 4).
5. When it fails or misleads: present, with two concrete failure modes linked to Case 1. One is the non-$C^2$ integrand giving $h^{5/3}$, verified by computed ratios. The other is the lucky single trapezoid, verified.
6. Where it fits: present (line 43, linking Newton-Cotes, Midpoint, Richardson, Simpson and Romberg).

The optional worked example is a 5-row table on the page's own animated problem. It adds digits the GIF does not show, and every row agrees with the frames. There are no proofs and no callout boxes.

**Word count:** 289 by the manifest, inside 150–400. I did not recount it independently, but the prose length is consistent with that figure.

**Links and anchors:**
- These relative links all point at existing pages (index.qmd verified for each): `../riemann-sums/`, `../newton-cotes-integration/`, `../midpoint-rule/`, `../richardson-extrapolation/`, `../simpsons-rule-for-numerical-integration/`, `../romberg-integration/`.
- `#case-1` matches the explicit id on the Case 1 heading.

**Scope of the diff:**
- The only file changed is index.qmd; `git diff --stat 147040f` shows just that file.
- The only change outside the Description is the `{#case-1}` id on the Case 1 heading, which is an allowed cross-reference edit.
- The Behavior paragraph, the Animations intro, the source link and the embed are unchanged.
- The removed sentence ("Geometrically, accuracy improves as node spacing is reduced…") was inside the Description, so removing it is within scope.
- No script or GIF changed (trapezoidalaa.gif md5 2118d482…). The script was not re-run; its $T_n$ values were checked by independent recomputation against the frame labels, as listed in the ledger.

**Fidelity:**
- Mathews uses $m$ subintervals and $T(f,h)$; the page uses $n$ and $T_n$, matching the script. This is a notation choice, not a finding.
- The error term, its hypothesis, $a<c<b$, and the halving remark all match the Mathews module.
- Mathews' composite-rule image gr_17 writes the interior sum as $\sum_{k=1}^{m}$. That looks like an archive typo (it should be $m-1$). The page's $\sum_{i=1}^{n-1}$ is correct, so this is not a finding.
