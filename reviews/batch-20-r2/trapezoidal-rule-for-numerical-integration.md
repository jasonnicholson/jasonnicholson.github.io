# Trapezoidal Rule for Numerical Integration — batch 20 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/trapezoidal-rule-for-numerical-integration/index.qmd` (light-pass batch 20, overview mode, action extend). Independent review. I did not read `reviews/`, did not run MATLAB or quarto, and modified nothing in the repository. My scratch work is in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-20r2/trapezoidal-rule-for-numerical-integration/reviewer/` (chk.py, chk2.py, wc.py, annots.png, mathews_corollary.png).

I consulted the Mathews archive: `n2003/TrapezoidalRuleMod.html`. Its formulas are images, so I read the corollary images gr_27 to gr_36 (combined in mathews_corollary.png).

## Part 1: Findings

None. Every line the diff adds checks out against my own high-precision computation (mpmath, 40 digits), against the committed GIF frames and the script, and against Mathews' corollary. It contradicts nothing in the Animations section or on the linked pages.

## Part 2: Claim ledger (diff `+` lines; no sentences were moved)

The reference integral is I = 2.0162797196170963…. I computed it with the substitution x = t³, which removes the x^{2/3} singularity, and cross-checked it with a split adaptive quadrature. Both agree to 40 digits.

1. "approximates a definite integral … from values of f at equally spaced nodes": **confirmed** (the script samples a+i·dx).
2. "n subintervals of width h=(b-a)/n, nodes x_i=a+ih, i=0..n; on each subinterval replaces f by the line segment between neighboring nodes": **confirmed** (script lines 18–22 and 31–41).
3. Composite formula T_n = h[½f(x0)+Σ_{i=1}^{n-1}f(x_i)+½f(x_n)]: **confirmed**. It is the formula `trapezoid_sum` implements, and it matches Mathews' T(f,h).
4. "works for any n≥1": **confirmed** (the script's n_seq starts at 1).
5. "exact when f is a linear function": **confirmed**. For 3x+1 on [0,2] with n=3, the error is 0.0.
6. "T_n is the average of the left and right Riemann sums": **confirmed**. At n=7, (L+R)/2 − T_7 = −2e−41.
7. "converges to the integral for every continuous f": **confirmed**. It follows from claim 6, since Riemann sums converge for continuous f.
8. "the error formula below needs more, namely f∈C²[a,b]": **confirmed**. Mathews' corollary states the hypothesis as f ∈ C²[a,b].
9. Error formula ∫f − T_n = −(b−a)f''(c)h²/12 with a<c<b, "as Mathews states it": **confirmed**. It matches Mathews' E_T(f,h) image character for character. As a check with exp on [0,2], the implied c is 1.0986 for n=1 and 1.1573 for n=4, both inside (0,2).
10. "The error is therefore O(h²)": **confirmed**. f'' is bounded on [a,b] when f ∈ C².
11. "halving h typically divides it by about 4": **confirmed**, and "typically" is the right hedge. For f ∈ C², E_n/h² tends to −(f'(b)−f'(a))/12, so the ratio tends to 4 whenever f'(a) ≠ f'(b). Mathews' remark gives (½)² = 0.25.
12. "If f'' keeps one sign on [a,b], then T_n − ∫f has that sign": **confirmed**. It follows from claim 9: T_n − ∫f = (b−a)f''(c)h²/12.
13. "if f''>0, every chord lies above the curve and T_n overestimates": **confirmed**. f is convex. For exp, T_n > I (E = −2.0 at n=1, −0.1326 at n=4).
14. "[Case 1](#case-1) shows what happens when the hypothesis fails": **confirmed**. The heading now carries `{#case-1}`.
15. Case 1 integrand f(x)=e^{−x}sin(8x^{2/3})+1: **confirmed**. It matches script line 8 and the Case 1 heading.
16. "f' unbounded at x=0, so it is not in C²[0,2]": **confirmed**. f'(x) ~ (16/3)x^{−1/3}, and f''(0.01) ≈ −1027.
17. "error shrinks only like h^{5/3}": **confirmed**. Successive halving ratios are 3.0763, 3.1415, 3.1583, 3.1647, 3.1679, 3.1698, 3.1711 (n=24…1536). E/h^{5/3} at n=768 and n=1536 is −1.235 and −1.236, close to the leading singular constant 8ζ(−2/3) = −1.2416.
18. "halving h divides it by 3.08, 3.14 and then 3.16": **confirmed** (3.0763, 3.1415, 3.1583).
19. "approaching 2^{5/3}≈3.17, not 4": **confirmed** (3.1748).
20. "the single trapezoid gives 2.017925": **confirmed**. T_1 = 2.017924816, and frame 2 shows "Sample Points = 2, Approximation = 2.017925".
21. "only about 0.0016 above the integral": **confirmed** (+0.0016451).
22. "with two subintervals the error jumps to about +0.357": **confirmed**. T_2 = 2.372927, error +0.356647, and frame 3 shows 2.372927. This is consistent with "+0.36" in the Behavior paragraph.
23. Table row n=6, h=1/3: **confirmed**. T_6 = 1.855187869 (1.855188) and error −0.161092 (−0.1611). Frame 7 shows "Sample Points = 7, 1.855188".
24. Row n=12, h=1/6: **confirmed**. T_12 = 1.957233895, error −0.0590458 (−0.05905), ratio 2.7283 (2.73). Frame 11 shows "13, 1.957234".
25. Row n=24, h=1/12: **confirmed**. T_24 = 1.997085696, error −0.0191940 (−0.01919), ratio 3.0763 (3.08). Frame 16 shows "25, 1.997086".
26. Row n=48, h=1/24: **confirmed**. T_48 = 2.010169926, error −0.00610979 (−0.006110), ratio 3.1415 (3.14). Frame 20 shows "49, 2.01017", which is the same value with Julia's `round` dropping the trailing 0.
27. Row n=96, h=1/48: **confirmed**. T_96 = 2.014345221, error −0.0019344989 (−0.001934), ratio 3.1583 (3.16). Frame 23 shows "97, 2.014345".
28. "The rows are frames of Case 1, each halving h": **confirmed**. 6, 12, 24, 48 and 96 are all in the script's n_seq, and each row doubles n.
29. "I = ∫_0^2 f(x)dx ≈ 2.016280": **confirmed** (2.0162797196).
30. "the ratio is the previous row's error divided by this row's": **confirmed**. It is the convention the numbers in claims 24–27 follow.
31. "degree-1 member of the Newton-Cotes family": **confirmed**. It is the closed linear rule, and the Newton-Cotes page lists it that way.
32. "the Midpoint Rule has the same O(h²) order": **confirmed**. The midpoint page states O(Δx²) for f ∈ C².
33. "one Richardson step (4T_{2n}−T_n)/3 gives Simpson's Rule S_{2n}": **confirmed**. For cos(3x)+x⁵ on [0,2] with n=5, (4T_10−T_5)/3 − S_10 = 0.0. The Simpson page uses S_n for n subintervals and states the same identity.
34. "Romberg Integration repeats that step on successive trapezoidal sums": **confirmed**. The Romberg page builds R_{k,1} = T_{2^{k−1}} and extrapolates with 4^{j−1}−1.
35. Links `../riemann-sums/`, `../newton-cotes-integration/`, `../midpoint-rule/`, `../richardson-extrapolation/`, `../simpsons-rule-for-numerical-integration/`, `../romberg-integration/`: **confirmed**. Each folder exists with an index.qmd.
36. Heading id `{#case-1}` and link `[Case 1](#case-1)`: **confirmed**. The explicit id matches the link.

Consistency with the rest of the page: the Behavior paragraph (I ≈ 2.016280, single trapezoid 2.017925, jump to +0.36, O(h^{5/3}), 3.14 from 24 to 48, tending to 3.17) agrees with the new Description on every shared number. The Animations intro is unchanged. The Description's numbers also agree with what the Riemann-sums and Midpoint pages say about the trapezoidal rule on this integrand: the Riemann-sums page cites 2^{5/3} ≈ 3.17 for the trapezoidal rule, and the Newton-Cotes page gives 3.14 from 24 to 48.

## Part 3: Checks (overview mode; the diff changes no script or GIF)

**Six points of the standard**, all present and in order:
1. The problem: line 12.
2. The core formula, as display math in the script's notation: lines 14–17.
3. What it assumes: n ≥ 1 and continuity for convergence; C² for the error term (lines 19–20).
4. How accuracy behaves: the general result with the C² hypothesis, O(h²), the ratio of about 4, and the sign rule (lines 22–27).
5. When it fails or misleads: Case 1, where C² fails and the order is h^{5/3}, and the lucky single trapezoid. Both are linked to the case and computed (lines 29–41).
6. Where it fits: line 43.

The optional worked example is a five-row table drawn from the animated problem. It adds errors and ratios that the GIF does not show. There are no proofs and no theorem boxes.

**Word count:** the manifest gives 295. My own rough recount gives 311; the counting rules differ slightly, for example in how they tokenise inline math and links. Both are within 150–400.

**Links and anchors:** all six relative page links resolve. The `#case-1` anchor matches the explicit id on the Case 1 heading.

**Scope of the diff:** only one file changes. Apart from the Description, the only edit is the `{#case-1}` id on the Case 1 heading, which is an allowed cross-reference. No sentence was moved out of the Animations introduction, and Behavior, alt text, source link and embed are untouched. The diff changes no script or GIF, so the animation is not under review. I still checked that the frame annotations I cite (frames 2, 3, 7, 11, 16, 20, 23) show the values the table and text quote.

**Fidelity:** the error formula, its C² hypothesis, the O(h²) statement and the "about 4" remark all match Mathews' corollary and remark. The Case 1 integrand is the existing animated example. This batch introduces no departure from the module.
