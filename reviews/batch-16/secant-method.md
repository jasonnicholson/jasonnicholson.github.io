# Secant Method — batch 16 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Review of `pages/numerical-methods/secant-method/index.qmd` (light-pass batch 16, overview page). The diff changes only `index.qmd`. No script or GIF changed, so the animations are not under review. I consulted the Mathews archive (`n2003/SecantMethodMod.html` and its theorem images `SecantMethodMod_gr_3..12.gif`). I did not run MATLAB or quarto, and I modified nothing in the repository. My scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16/secant-method/reviewer/`: `chk.py`, `chk2.py` (mpmath at 200–300 digits plus double-precision reruns) and `thm.png` (the Mathews theorem images stacked).

## 1. Findings

**F1 — Page text, Minor.** The Case 1 table row n = 8 (`| 8 | 0.254850059029 | $2.71 \times 10^{-15}$ | 0.7933 |`) and the sentence "the ratio … settles at … ≈ 0.7933".
- **What is there:** the table gives exact-arithmetic values without saying so. I computed them independently in mpmath at 200 digits, and every entry is correct to the digits shown. Row 8 is the exact-arithmetic value: e₈ = 2.7075e-15, ratio 0.793325.
- **What the animation computes:** the animation's double-precision run (same formula, same p₀ and p₁, reproduced in Python floats) gives e₈ = 2.7200e-15 (rounds to 2.72e-15) and a ratio of 0.79700 at n = 8. That differs from the table in the third decimal. The cause is that p₈ is rounded at the level of double-precision spacing. Rows 3–7 agree between exact and double arithmetic to every digit shown. No frame displays e₈ or the ratio (the last frame shows only "p10 = 0.25485"), so nothing visible contradicts the table.
- **Why it matters:** a reader who reruns the page's own Julia script would get different last-row numbers.
- **Suggested fix:** add "(computed in extended precision)" to the lead-in sentence, or note that row 8 is at the limit of double precision. Alternatively, drop row 8: row 7 already shows 0.7931.

## 2. Claim ledger (diff `+` lines)

The only changes outside the Description are the six `{#case-N}` heading ids.

1. "solves a single equation f(x) = 0 without using the derivative f′": **confirmed.** The scripts use only f.
2. Each step draws the secant through (p_{n−1}, f(p_{n−1})) and (p_n, f(p_n)), and its x-intercept is the next approximation: **confirmed.** It matches the Animations intro and the frames.
3. The display formula p_{n+1} = p_n − f(p_n)(p_n − p_{n−1})/(f(p_n) − f(p_{n−1})), n = 1, 2, …: **confirmed.**
   - It is the same as `ps[i+1] = ps[i] - f(ps[i])*(ps[i]-ps[i-1])/denom` in all six scripts.
   - It is the same as Mathews' g(p_{k−1}, p_k).
   - The page's n = 1, 2, … is correct. Mathews' k = 0, 1, … would refer to p₋₁.
4. "Newton's step with f′(p_n) replaced by the slope of the secant line, so each step needs only one new value of f": **confirmed.** Mathews says the same.
5. "The formula is the one False Position uses, but … always keeps the two most recent points, so its iterates need not bracket the root": **confirmed.**
   - The False Position page's c = (a f(b) − b f(a))/(f(b) − f(a)) is algebraically identical to b − f(b)(b − a)/(f(b) − f(a)).
   - Case 4 shows iterates that do not bracket the root.
6. "The step needs f(p_n) ≠ f(p_{n−1}); otherwise the secant line is horizontal": **confirmed.**
7. Mathews' secant theorem (f ∈ C²[a, b], f(p) = 0, p ∈ [a, b], f′(p) ≠ 0 ⇒ there is a δ > 0 such that the iterates converge for p₀, p₁ ∈ [p − δ, p + δ]): **confirmed** against the archive images. The hypotheses match Mathews. The page states "for starting values" where Mathews says "for certain initial approximations"; the page's wording is the standard correct form, so this is not a fidelity issue.
8. e_{n+1} ≈ f″(p)/(2f′(p)) e_n e_{n−1} for large n, at a simple root with f ∈ C² near it, where e_n = p_n − p: **confirmed.** The sign and constant are verified numerically in Case 1, where the ratio tends to 0.793327 (items 12–13).
9. Order (1 + √5)/2 ≈ 1.618 when f″(p) ≠ 0: **confirmed.** The Case 1 order estimates are 1.794, 1.500, 1.653, 1.604, 1.623, 1.616.
10. "Two secant steps cost about as much as one Newton step when f′ costs as much as f … order 1.618² ≈ 2.618, better than Newton's 2": **confirmed.** 1.618² = 2.618.
11. Case 1: f = 3eˣ − 4cos x with root p = 0.254850059029: **confirmed.** mpmath gives 0.25485005902885025531.
12. The ratio settles at f″(p)/(2f′(p)) ≈ 0.7933: **confirmed.** The computed value is 0.7933267586.
13. Table rows n = 3…8:
    - p_n values (0.320730532760, 0.263760252635, 0.255293513424, 0.254853174145, 0.254850060124, 0.254850059029): **confirmed.** Exact values are 0.320730532759922, 0.263760252635055, 0.255293513424209, 0.254853174145246, 0.254850060124434 and 0.254850059028853.
    - e_n values (6.59e-2, 8.91e-3, 4.43e-4, 3.12e-6, 1.10e-9, 2.71e-15): **confirmed.** Exact values are 0.065880, 0.0089102, 4.4345e-4, 3.1151e-6, 1.0956e-9 and 2.7075e-15.
    - Ratios (0.5083, 0.6732, 0.7554, 0.7884, 0.7931, 0.7933): **confirmed.** Exact values are 0.508294, 0.673208, 0.755449, 0.788385, 0.793089 and 0.793325.
    - Caveat: row 8 is exact-arithmetic only (F1).
14. "When f″(p) = 0 the convergence is faster: for arctan at p = 0 (Case 3, Case 6), e_{n+1}/(e_n e_{n−1}²) → −1/3 and the order is 2": **confirmed.**
    - Analytically, f[a, b, 0] = −(a + b)/3 for x − x³/3, so e_{n+1} ≈ −(1/3) e_n e_{n−1}².
    - Case 3 in mpmath: the ratios are −0.333307, −0.333328, −0.333333, and the order estimates are 2.15, 1.93, 2.04.
    - Case 6 in mpmath: the ratios are −0.33259, −0.33269, −0.333333, and the order estimates are 2.25, 1.89, 2.06.
    - The double-precision runs show the same ratios (−0.33331 and −0.33320 for Case 3) before underflow.
15. "At a multiple root, where f′(p) = 0, the convergence is only linear": **confirmed** as a general statement and in Case 2.
16. Case 2, f = 25(x − 0.2)²: the step reduces exactly to e_{n+1} = e_n e_{n−1}/(e_n + e_{n−1}): **confirmed.**
    - Algebraically, f(p_n) − f(p_{n−1}) = 25(e_n − e_{n−1})(e_n + e_{n−1}).
    - Numerically, the residual is below 1e-295 at 300 digits.
17. e_{n+1}/e_n settles at (√5 − 1)/2 ≈ 0.618: **confirmed.** The ratio is 0.6179941 at n = 10 and 0.61803399 from n = 20 on. The double-precision ratios over the script's 28 iterations are 0.618.
18. "slower than Newton's 1/2 on the same double root": **confirmed.** Newton on (1 − 5x)² has error ratio exactly 0.5 per step. The Newton-Raphson page's Case 2 uses the same function.
19. Case 5, f = xe^{−x}, p₀ = 1.5, p₁ = 2 "on the decreasing tail": **confirmed.** f′ < 0 for x > 1.
20. "the iterates run off to +∞ while f(p_n) → 0": **confirmed.**
    - The iterates are p₂ = 4.114, p₁₀ = 10.575, p₂₀ = 18.06, p₄₀ = 32.53.
    - The corresponding f values are 2.7e-4 at p₁₀ and 2.4e-13 at p₄₀.
    - The last frame shows p10 = 10.57 off the chart.
21. "a stopping test on |f(p_n)| alone would eventually accept a point far from the root": **confirmed.** This follows from item 20.
22. Case 4, f = x³ − x + 3, p₀ = 2, p₁ = 1: "the iterates wander as far as 3.16 and −3.03 before they converge to the root near −1.672": **confirmed.**
    - The iterates are 0.5, −3.0, 0.111, −0.265, 3.1639, −0.659, −1.1175, −3.0342, −1.329, …, converging to −1.67170.
    - The maximum is 3.1639 and the minimum is −3.0342. The root is −1.67169988166.
    - The frames show p6 = 3.1639, and p9 at the lower left near −3.03.
23. "Convergence is only local": **confirmed.** Item 7 and Case 5 support it.
24. Related-pages sentence:
    - Muller's method "fits a parabola through the last three iterates": **confirmed** as a general description.
    - Brent's method "safeguards secant and inverse quadratic interpolation steps with bisection": **confirmed.** This matches `brents-method/index.qmd` lines 16–18.
    - Broyden's method "carries the secant idea to systems": **confirmed** as a general description.
    - Bisection and False Position "keep a sign-change bracket": **confirmed.**
25. Links `../newton-raphson-method/`, `../false-position-or-regula-falsi-method/`, `../bisection-method/`, `../mullers-method/`, `../brents-method/` and `../broydens-method/`: **confirmed.** Each folder exists with an `index.qmd`.
26. Anchors `#case-1` … `#case-6`: **confirmed.** Explicit ids were added to all six case headings (lines 61, 69, 77, 85, 93, 101), and each link targets the case it describes.
27. Heading-id additions: **confirmed** to be the only change outside the Description. The heading text is unchanged and each heading only gains `{#case-N}`.

## 3. Checks

**Six points of the overview standard: all present.**
1. **The problem:** first sentence.
2. **The core formula:** display math, in the scripts' notation p_n.
3. **What it assumes:** f(p_n) ≠ f(p_{n−1}), f ∈ C², a simple root, and starting values near the root.
4. **How accurate it is:** the error relation and the order 1.618 under stated conditions, with the f″ = 0 and multiple-root variants, checked against Cases 1, 2, 3 and 6.
5. **When it fails or misleads:** divergence in Case 5, the erratic path in Case 4, and slow convergence at a multiple root in Case 2. All are linked.
6. **Where it fits:** the final sentence, with six valid links.

The optional worked example is a six-row table on the page's own Case 1. There are no callout boxes, no proofs and no code. The theorem is stated in prose, not in a box.

**Word count:** I recounted 394 words, matching the manifest (inline math counted as one word, display math and table rows excluded). That is inside the 150–400 limit, near the top.

**Consistency with the rest of the page:** no contradictions with the Animations intro or with the Case 1–6 Behavior paragraphs. The Case 1 errors 0.066, 0.0089, 4.4e-4 and 3.1e-6 match the table. Cases 2 and 6 give the same ratio 0.618 and order 2 as the Description. The Case 3 Behavior notes that p₈ = 0 in double precision, which does not conflict with the −1/3 limit because the limit is visible at n = 6 and 7. The frames I inspected (Case 1 frame 9, the Case 4 contact sheet, Case 5 frame 9) agree with every value cited.

**Fidelity to Mathews:** the formula and the theorem's hypotheses match the module. The six cases correspond to Mathews' Examples 3–8. No fidelity issue.

**Diff scope:** only the Description and the six heading ids changed. No script or GIF changed, so Question 1 does not apply.

**Mechanical checks:** the manifest reports none. My own checks of links and anchors are under items 25–26.
