# Richardson Extrapolation — batch 20 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/richardson-extrapolation/index.qmd`, light-pass batch 20, overview (action *extend*). I reviewed EV/diff.patch against the working tree. Scratch work is in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-20/richardson-extrapolation/reviewer/` (check.py, mathews_formulas.png, zoom.png). I did not run MATLAB or quarto, and I changed nothing in the repository.

I consulted the Mathews archive: I read `n2003/RichardsonExtrapMod.html` as text and rendered its formula images gr_4 to gr_16 into reviewer/mathews_formulas.png.

## 1. Findings

None.

Two things I looked at and decided were not findings:
- **Rounding sentence (line 45).** It says "Both formulas … rounding errors grow as h shrinks." Case 2's D3 points show no visible rounding effect, because the slope stays at 2.0000 down to h = 0.0015. That is consistent: the rounding error there is about eps/h ≈ 1e-13, far below the truncation error of 3.8e-7. The sentence states a general mechanism and claims a visible departure only for D5, so the page does not contradict itself.
- **Word count.** The manifest gives 367 words. My own tokenization of lines 10–50 gives 384. Both are within the 150–400 limit.

## 2. Claim ledger

The ledger covers the + lines of the diff, page lines 12–49 plus the two heading ids. Each entry gives the page's words, then the verdict and the evidence.

1. L12: "improves an approximation that depends on a step size h by combining its values at two step sizes so that the leading term of its error cancels." **Confirmed** (definition, consistent with the general statement on L30).
2. L13: "Mathews applies it to numerical differentiation, where it turns the three-point central difference … into a five-point formula; this page animates that step for f(x)=e^{-x}sin(x) over [0,π]." **Confirmed.** The module's theorems match, and both scripts use f = exp(-x)sin(x). Case 1 covers [0,π]; Case 2 uses x = 1, which lies in [0,π].
3. L18: D3(x,h) = (f(x+h) − f(x−h))/(2h). **Confirmed.** It equals `d3` in both scripts and Mathews' D_three.
4. L21: D3 = f' + f'''h²/6 + f⁽⁵⁾h⁴/120 + …, with only even powers. **Confirmed.** The sympy series of D3 minus that expression is 0 through O(h⁵).
5. L22: "Halving h divides the h² term by 4." **Confirmed** (trivial).
6. L25: (4D3(x,h/2) − D3(x,h))/3 = (f(x−h) − 8f(x−h/2) + 8f(x+h/2) − f(x+h))/(6h). **Confirmed.** sympy simplifies the difference to 0. The left side is `d5` in both scripts.
7. L28: the combination "removes" the h² term. **Confirmed.** The series of f' − D5 starts at h⁴.
8. L29: "This is Mathews' five-point central difference with spacing h/2." **Confirmed.** Mathews' D_five(x,k) = (f(x−2k) − 8f(x−k) + 8f(x+k) − f(x+2k))/(12k), and with k = h/2 it equals D5 (sympy difference 0).
9. L30: if A(h) = A + c·hᵖ + O(h^q) with q > p, then (2ᵖA(h/2) − A(h))/(2ᵖ − 1) = A + O(h^q). **Confirmed** by algebra: the cᵖ terms cancel and the O(h^q) terms stay O(h^q).
10. L32: the method assumes p is known and that the leading term dominates, which needs f smooth enough. **Confirmed** as a hypothesis statement.
11. L33: if f ∈ C³[x−h, x+h], then f'(x) − D3(x,h) = −f'''(c)h²/6. **Confirmed.** It matches Mathews' R_three = −f⁽³⁾(c)h²/6, with the sign convention f' = D + R.
12. L36: if f ∈ C⁵[x−h, x+h], then f'(x) − D5(x,h) = f⁽⁵⁾(c)h⁴/480. **Confirmed.** The sympy series of f' − D5 minus f⁽⁵⁾h⁴/480 is O(h⁵), so the sign and the constant are right. All of D5's nodes x±h and x±h/2 lie in [x−h, x+h].
13. L39: this "is Mathews' five-point remainder f⁽⁵⁾(c)k⁴/30 with k = h/2." **Confirmed.** Mathews' R_five = f⁽⁵⁾(c)h⁴/30, and (h/2)⁴/30 = h⁴/480.
14. L40: halving h divides the error of D3 by about 4 and the error of D5 by about 16. **Confirmed** as an asymptotic result. Case 1, h 0.02→0.01: D3 ratio 4.00, D5 ratio 16.0.
15. L41: in Case 1, from h = 0.02 to h = 0.01, the max error of D3 goes 1.33e-4 → 3.33e-5 and that of D5 goes 1.33e-9 → 8.33e-11. **Confirmed.** On the script's 800-point grid I computed D3 1.333e-04 → 3.333e-05 and D5 1.333e-09 → 8.333e-11. Frames 8 and 9 of richexaa annotate the same values (1.33e-04 / 1.33e-09 and 3.33e-05 / 8.33e-11), and their titles read h = 0.02 and h = 0.01.
16. L42: in Case 2 at x = 1, from h = 0.5 down to h = 0.006, the log-log slopes are 2.000 to 2.007 for D3 and 3.905 to 4.005 for D5. **Confirmed.** For D3 the slopes run from a minimum of 2.0000 to a maximum of 2.0066. For D5 they run from 3.9049 (0.5→0.32) to 4.0048 (0.01→0.006).
17. L44–45: "Rounding error eventually wins"; both formulas subtract nearly equal values and divide by h, so rounding error grows as h shrinks while D5's truncation error falls like h⁴. **Confirmed.** This is the general mechanism, and it shows in Case 2's D5 at the two smallest h.
18. L46: "The last two points of Case 2 leave the h⁴ line." **Confirmed.** The D5 slopes are 4.709 (0.006→0.003) and 1.822 (0.003→0.0015). In frame_012 of richexab, the h = 0.003 point sits below the dotted O(h⁴) guide and the h = 0.0015 point sits above it (reviewer/zoom.png).
19. L46: at h = 0.0015, the computed D5 error is 1.29e-14, about 2.8 times the truncation error 4.67e-15 found in 50-digit arithmetic. **Confirmed.** In float64 the error is 1.2920e-14. In mpmath at 50 digits the truncation error is 4.674e-15 (and f⁽⁵⁾(1)h⁴/480 = 4.674e-15). The ratio is 2.764.
20. L47: the one-sided A(h) = (f(x+h) − f(x))/h has an error starting with an h term; the weights 4 and −1 leave an O(h) error; the right combination is 2A(h/2) − A(h). **Confirmed** at x = 1 with sympy. (4A(h/2) − A(h))/3 − f' = −h·e⁻¹cos(1)/3 + O(h³), and 2A(h/2) − A(h) − f' = O(h²).
21. L49: the links ../numerical-differentiation/, ../derive-numerical-differentiation-formulae/, ../big-o-truncation-error/, ../romberg-integration/ and ../aitken-method-and-steffensen-acceleration/ resolve. **Confirmed.** All five folders have an index.qmd. The pages' titles match the link text: Big "O" Truncation Error, Romberg Integration, and Aitken's Method & Steffensen's Acceleration.
22. L49: "Romberg Integration applies the same step repeatedly to the trapezoidal rule"; "Aitken's Method accelerates a sequence without a step size." **Confirmed** (standard descriptions of the linked methods).
23. L60 and L68: the heading ids {#case-1} and {#case-2}, which L41 and L42 link to as #case-1 and #case-2. **Confirmed.** The ids are explicit and match the links. These id additions are the diff's only changes outside the Description.

Consistency with the rest of the page:
- The L54 intro ("D5(x,h) is that example's five-point formula … with spacing h/2") agrees with L29.
- The L57 claim that D5(1,0.02) equals the five-point value at spacing 0.01 agrees with entry 8.
- The Derivation Notes (L78–85) agree with L22–28.
- The Case 1 and Case 2 Behavior lines agree with entries 14–18.

No contradictions.

## 3. Checks

**Six points of the overview standard.** All are present, in order:
1. **The problem:** L12–13.
2. **The core formula:** display math at L18 and L25, in the scripts' D3/D5 notation, plus the general form at L30.
3. **What it assumes:** L32, plus the C³ and C⁵ hypotheses on L33.
4. **How accurate it is:** L33–40 state the results as general, with hypotheses. L41–42 tie them to Case 1 and Case 2, and I checked both against the cases' own computed values (entries 15 and 16).
5. **When it fails or misleads:** L44–47. Rounding error is linked to Case 2's last points, and wrong weights are shown with the one-sided example.
6. **Where it fits:** L49.

There are no proofs, theorem boxes or MATLAB/Mathematica procedures. The derivation is one line of Taylor expansion, which is allowed.

**Word count.** The manifest gives 367; my count is 384. Both are within 150–400.

**Links and anchors.** Five relative page links resolve, and the two case anchors match explicit heading ids. The manifest's mechanical checks found nothing.

**Scope of the diff.** It touches only index.qmd (31 insertions, 8 deletions):
- Inside the Description: rewrite and extension.
- Outside the Description: only the {#case-1} and {#case-2} heading ids.

No scripts or GIFs changed, so I did no Question 1 review of the scripts. I did re-derive every number the new text cites independently in Python (numpy, sympy, mpmath at 50 digits) from the scripts' own f, step-size lists and grid. I also checked frames 8 and 9 of richexaa and frame 12 of richexab against those numbers.

**Fidelity.** The page's D3, its remainder −f'''(c)h²/6, the five-point formula and its remainder f⁽⁵⁾(c)k⁴/30 all match Mathews' module (gr_4 to gr_16) once the spacing is converted with k = h/2. That conversion is stated explicitly on L29 and L39, so there is no unexplained departure.
