# Riemann Sums — batch 20 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

# Review: riemann-sums (light-pass batch 20, overview page, action *extend*)

Evidence folder: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-20/riemann-sums
Reviewer scratch: EV/reviewer/ (check.py is the independent computation; labels.png holds the annotation crops of the GIF frames I compared)
Mathews archive consulted: yes, /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/RiemannSumMod.html, read as text.
MATLAB not run. Quarto not run. Nothing in the repository was modified.

## 1. Findings

None.

Two points I looked at closely and did not count as findings:
- Line 26: "Every Riemann sum lies between the lower and upper sums, so lower ≤ I ≤ upper". Read alone, the "so" looks like a gap, because I is not obviously a Riemann sum for the same partition. Under the stated continuity hypothesis it is one: by the mean value theorem for integrals, I = Σ f(c_i)Δx with c_i in each subinterval. The inference is therefore valid, and the claim is true.
- Lines 28–32: the C¹ first-order result is stated for C¹ functions. The page then says the integrand is not C¹, and explains why Cases 1 and 2 do not show the first-order rate by pointing to f(a) ≈ f(b). This is consistent. Here T_n − I = O(h^{5/3}) = o(h), so L_n − I = −(h/2)(f(b) − f(a)) + o(h) still holds, and the first-order term is just tiny. My computation shows the L and R ratios drifting toward 2 for large n: L ratio 2.68 and R ratio 6.25 from n = 1000 to 2000, against T ratio 3.171.

## 2. Claim ledger (+ lines of the diff)

| # | Claim (page's words, abridged) | Verdict | Evidence |
|---|---|---|---|
| 1 | I = ∫_a^b f dx; partition into n subintervals, rectangles | confirmed | definition |
| 2 | Δx = (b−a)/n, x_i = a + iΔx, S_n = Σ_{i=1}^n f(t_i)Δx, t_i ∈ [x_{i−1}, x_i] | confirmed | standard; matches the script indexing |
| 3 | L_n = Δx Σ_{i=0}^{n−1} f(x_i), R_n = Δx Σ_{i=1}^n f(x_i) | confirmed | riemannaa.jl `for i in 0:n-1`; riemannbb.jl `for i in 1:n` |
| 4 | Lower and upper sums = Δx Σ m_i and Δx Σ M_i, with min and max on [x_{i−1}, x_i] | confirmed | riemanncc.jl and riemanndd.jl fmin/fmax over the endpoints plus the interior critical points; the two scripts differ only in min/max (diffed) |
| 5 | Mathews' definition assumes f continuous on [a,b] | confirmed | RiemannSumMod.html: "Let f be continuous over the interval [a,b]" |
| 6 | Then every such sum converges to I whatever the t_i | confirmed | continuous ⇒ Riemann integrable |
| 7 | Every Riemann sum lies between the lower and upper sums, so lower ≤ I ≤ upper | confirmed | true (see note in Findings). Numerically lo(n) ≤ I ≤ up(n) for all 24 n in n_seq |
| 8 | The scripts for Cases 3 and 4 find the extrema from the zeros of f′ | confirmed | riemanncc/dd.jl `critical_points()`: sign changes of fp on a grid, then bisection. My critical points 0.080383549, 0.43198196, 0.93920525, 1.5644755 reproduce the page and frame values |
| 9 | For f ∈ C¹: L_n − I ≈ (Δx/2)(f(a)−f(b)), R_n − I ≈ (Δx/2)(f(b)−f(a)); halving Δx roughly halves the error unless f(a) = f(b) | confirmed | T_n = L_n + (Δx/2)(f(b)−f(a)) exactly, and T_n − I = o(Δx) for C¹ |
| 10 | If f has total variation V, then upper − lower ≤ VΔx, so the width is O(Δx) | confirmed | Σ(M_i − m_i) ≤ V. Checked for all n in n_seq |
| 11 | The integrand is not in C¹[0,2]; f′ is unbounded at 0 | confirmed | f′ contains (16/3)x^{−1/3}cos(8x^{2/3})e^{−x} → +∞ |
| 12 | V ≈ 4.3209 | confirmed | V = 4.320872 (sum of \|Δf\| over the critical points) |
| 13 | Width at n = 24: 0.359366; at n = 48: 0.179723 (halves) | confirmed | 0.359365637, 0.179722713. Frames 15/19 of cc/dd: 2.176725 − 1.817359 and 2.099989 − 1.920267 |
| 14 | Width at n = 120: 0.072000 vs VΔx ≈ 0.072015 | confirmed | 0.0720000227; V/60 = 0.0720145 |
| 15 | Cases 3 and 4 show the first-order rate | confirmed | rows 13–14 |
| 16 | f(0) = 1, f(2) ≈ 1.0179 | confirmed | f(2) = 1.017924816 |
| 17 | R_n − L_n = Δx(f(b) − f(a)), 0.0003 at n = 120 | confirmed | identity; 0.000298747 |
| 18 | From n = 24 to 48 the errors fall by 3.08 (L) and 3.22 (R) | confirmed | 3.0758 and 3.2158 |
| 19 | Close to the trapezoidal rule's 2^{5/3} ≈ 3.17 on this integrand | confirmed | 2^{5/3} = 3.1748. T ratios: 3.1415 (24→48), 3.1583, 3.1647, 3.1714 (1000→2000), which tend to 3.17 (x^{2/3} endpoint singularity ⇒ h^{5/3}) |
| 20 | Cases 1 and 2 do not show the first-order rate | confirmed | rows 17–19 |
| 21 | L_1 = 2, within 0.017 of I ≈ 2.016280 | confirmed | I = 2.0162797196 (mpmath, two methods agree to 30 digits); \|L_1 − I\| = 0.01628. Frame aa/002 shows "Approximation = 2.0" |
| 22 | L_2 ≈ 2.363965, off by 0.348 | confirmed | 2.36396456; error 0.347685. Frame aa/003 shows 2.363965 |
| 23 | So the error need not shrink as n grows | confirmed | rows 21–22 |
| 24 | For a non-monotone f, L_n and R_n are not bounds: both exceed I at n = 2, both fall below at n = 3 | confirmed | n = 2: L 2.36396, R 2.38189 > I. n = 3: L 1.89310, R 1.90505 < I (frame bb/004 shows 1.905046). Across n_seq, both exceed I only at n = 2 and both fall below I at every n ≥ 3 |
| 25 | Midpoint takes t_i at the midpoint; Trapezoidal averages L_n and R_n; both second order for f ∈ C² | confirmed | standard; matches Mathews' module text ("Trapezoidal Rule is the average of the left … and the right Riemann sum") |
| 26 | Simpson's and the other Newton-Cotes formulas go further | confirmed | general |
| 27 | Heading ids {#case-1}…{#case-4}, links [Case 1–4](#case-N) | confirmed | ids present on lines 49, 57, 65, 73; every link target exists |
| 28 | Links ../midpoint-rule/, ../trapezoidal-rule-for-numerical-integration/, ../simpsons-rule-for-numerical-integration/, ../newton-cotes-integration/ | confirmed | each directory exists with an index.qmd; the link style matches the other pages |

Cross-check against the unchanged Animations text: I ≈ 2.016280, lower sums 1.374576 (n = 3) and 1.192004 (n = 4), upper sums 2.418035 (n = 7) and 2.427098 (n = 8), and the n = 120 bracket 1.978951 ≤ I ≤ 2.050951 all agree with my values. Nothing in the new Description contradicts them.

## 3. Checks

**The six points of the standard**
1. Problem: line 12. Present.
2. Core formula: display math on lines 15–23. Present, and in the scripts' notation and indexing.
3. Assumptions: continuity (line 25), C¹ for the rate (line 28), finite variation for the bracket (line 29). Present.
4. Accuracy: first order for L/R under C¹, and bracket width ≤ VΔx. Stated as general results with hypotheses, then checked on the page's own integrand: the width halves in Cases 3 and 4; Cases 1 and 2 are explained honestly. Present.
5. Failure modes: a coarse sum that is accurate by chance (Case 1, L_1 vs L_2); L/R are not bounds for a non-monotone f; the cost of locating extrema. Present and linked to cases.
6. Where it fits: line 38, links to Midpoint, Trapezoidal, Simpson's and Newton-Cotes. Present.

No proofs, theorem boxes or Mathematica/MATLAB code. No worked-example table.

**Word count:** the manifest gives 380. My own rough count of lines 12–40 gives 399, and that includes the unchanged legacy sentence on line 40 (about 18 words); without it the count is about 381. Either way it is within 150–400, near the upper limit.

**Markup:** KaTeX constructs used (`\underline`, `\overline`, `\tfrac`, `\bigl`/`\bigr`, `\,`) are all supported. The `$$` blocks are balanced and sit on their own lines. Inline `$...$` pairs are balanced.

**Scope of the diff:** only pages/numerical-methods/riemann-sums/index.qmd changed. The Description was rewritten and extended, which the *extend* action allows. Outside the Description, the only changes are the four explicit heading ids. No script or GIF changed, so the animations are not under review.

**Fidelity:** Mathews states the definition for continuous f with mesh → 0 on a general partition. The page specializes to equal widths and keeps the continuity hypothesis. This is not a departure that matters.

**Frames inspected:** riemannaa 002/003; riemannbb 003/004; riemanncc and riemanndd 015/019/025 (n = 24, 48, 120). Every annotation matches my computed values to 6 decimals.
