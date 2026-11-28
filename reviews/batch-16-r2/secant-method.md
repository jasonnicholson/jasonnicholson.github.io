# Secant Method — batch 16 review, round 2 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

# Review: secant-method (light-pass batch 16, overview page)

Scope: `pages/numerical-methods/secant-method/index.qmd`. The diff (EV/diff.patch) adds a `## Description` (lines 10–54) and adds explicit ids `{#case-1}` … `{#case-6}` to the six case headings. It changes no script and no GIF, so the animations are not under review. I consulted the Mathews archive (`n2003/SecantMethodMod.html` and its theorem images gr_3–gr_13). I did not run MATLAB or quarto, did not read `reviews/`, and modified nothing in the repository. Scratch work is in `EV/reviewer/` (check.py, thm.png, thm2.png).

## 1. Findings

None.

These items looked like possible findings but are not:
- **Theorem wording vs Mathews.** Mathews says the iteration converges "for certain initial approximations p0, p1 ∈ [p−δ, p+δ]". The page says it converges "for starting values" in that interval, with no "certain". The page's version is the standard local-convergence theorem: with f ∈ C², f′(p) ≠ 0 and δ small enough, it holds for all distinct p0, p1 in the interval. So it is correct, and it is not a Fidelity departure that matters. The hypotheses (C²[a,b], p ∈ [a,b], f(p) = 0, f′(p) ≠ 0, δ > 0) match Mathews' images exactly.
- **Word count.** The manifest's convention (inline math = 1 word, display math and tables excluded) gives 398. I reproduced 398 with that convention. Counting stray punctuation tokens next to inline math as words would give 426, but those are not words, so the Description is within the 150–400 limit. It is near the cap, though.
- **Overview sentences left in the Animations introduction** (for example "Unlike Newton's method, no derivative is required…"). The standard allows these to be moved but does not require it. They do not contradict the Description.

## 2. Claim ledger (diff `+` lines)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | Solves f(x) = 0 without using f′ | confirmed | definition; scripts use only f |
| 2 | Secant line through (p_{n−1}, f(p_{n−1})) and (p_n, f(p_n)); its x-intercept is the next iterate | confirmed | matches all six scripts' update and the plotted secant (frames aa, dd, ee) |
| 3 | p_{n+1} = p_n − f(p_n)(p_n − p_{n−1}) / (f(p_n) − f(p_{n−1})), n = 1, 2, … | confirmed | identical to the scripts' `ps[i+1] = ps[i] - f(ps[i])*(ps[i]-ps[i-1])/denom`; same p notation as the case headings and GIF legends |
| 4 | Newton's step with f′ replaced by the secant slope; one new f value per step | confirmed | algebra; each step reuses f(p_{n−1}) |
| 5 | Same formula as False Position, but keeps the two most recent points, so it need not bracket | confirmed | matches Mathews' text; Case 1 iterates stay on one side (p0, p1, p2 > p) |
| 6 | Needs f(p_n) ≠ f(p_{n−1}), otherwise the secant is horizontal with no x-intercept | confirmed | algebra |
| 7 | Mathews' theorem: f ∈ C²[a,b], f(p) = 0, f′(p) ≠ 0 ⇒ ∃ δ > 0 such that iterates converge for p0, p1 ∈ [p−δ, p+δ] | confirmed (see the Findings note on "certain") | Mathews' images gr_3–gr_12 |
| 8 | For a simple root with f ∈ C² near it: e_{n+1} ≈ f″(p)/(2f′(p)) · e_n e_{n−1} for large n | confirmed (general result with correct hypotheses; sign checked) | Case 1 ratios tend to +0.793327, which equals f″(p)/(2f′(p)) = 0.7933267586 (mpmath, 200 digits) |
| 9 | When f″(p) ≠ 0 the order is (1+√5)/2 ≈ 1.618 | confirmed | standard; consistent with the Case 1 error sequence |
| 10 | Two secant steps cost about one Newton step when f′ costs as much as f; combined order 1.618² ≈ 2.618 > 2 | confirmed | 1.618034² = 2.618034 |
| 11 | Case 1 root p = 0.254850059029 | confirmed | mpmath findroot gives 0.25485005902885025531 |
| 12 | Case 1 ratio settles at f″(p)/(2f′(p)) ≈ 0.7933 | confirmed | 0.7933267586 |
| 13 | Table row n=3: p=0.320730532760, e=6.59e−2, ratio 0.5083 | confirmed | 0.320730532759922, 0.065880474, 0.508294 |
| 14 | n=4: 0.263760252635, 8.91e−3, 0.6732 | confirmed | 0.263760252635055, 0.0089101936, 0.673208 |
| 15 | n=5: 0.255293513424, 4.43e−4, 0.7554 | confirmed | 0.255293513424209, 4.434544e−4, 0.755449 |
| 16 | n=6: 0.254853174145, 3.12e−6, 0.7884 | confirmed | 0.254853174145246, 3.1151164e−6, 0.788385 |
| 17 | n=7: 0.254850060124, 1.10e−9, 0.7931 | confirmed | 0.254850060124434, 1.0955833e−9, 0.793089 |
| 18 | n=8: 0.254850059029, 2.71e−15, 0.7933 | confirmed | 0.254850059028853, 2.7075151e−15, 0.793325. The double-precision iterates from the script's loop agree to 12 digits, and the GIF legends (0.45575, 0.32073, 0.26376, 0.25529, 0.25485) agree with the table |
| 19 | When f″(p) = 0 the convergence is faster | confirmed (general) | the error relation's leading term vanishes; the next term is O(e_n e_{n−1}(e_n + e_{n−1})) |
| 20 | arctan at p = 0 (Cases 3 and 6): e_{n+1}/(e_n e_{n−1}²) → −1/3; order 2 | confirmed | derivation: f[x0,x1,0] ≈ −(x0+x1)/3, which gives r² = r + 2, so r = 2. Exact iterates: Case 3 ratios −0.333307, −0.333328, −0.333333; Case 6 ratios −0.33259, −0.33269, −0.333333. Case 6 double iterates (the GIF's run to p7 = −9.23e−17) give −0.3327 |
| 21 | At a multiple root (f′(p) = 0) convergence is only linear | confirmed (general) | standard; Case 2 below |
| 22 | Case 2: f = 25(x−0.2)², which equals the heading's 1 − 10x + 25x² | confirmed | expansion |
| 23 | Step reduces exactly to e_{n+1} = e_n e_{n−1}/(e_n + e_{n−1}) | confirmed | algebra; residual 4e−202 over 30 exact steps |
| 24 | e_{n+1}/e_n settles at (√5−1)/2 ≈ 0.618 | confirmed | fixed point of ρ = 1/(1+ρ). Exact ratios reach 0.618034; the script's double-precision run gives 0.6180 from step 9 through step 28 |
| 25 | Slower than Newton's 1/2 on the same double root | confirmed | Newton on a·e² gives e_{n+1} = e_n/2; 0.618 > 0.5 per step |
| 26 | Convergence is only local | confirmed | Case 5 |
| 27 | Case 5: xe^{−x}, p0 = 1.5 and p1 = 2 lie on the decreasing tail; secant lines are shallow; iterates run off to +∞ while f(p_n) → 0 | confirmed | f′ < 0 for x > 1. Iterates: 4.1138, 4.8125, …, 10.5746 (p10), 15.106 (p16), still increasing at p40. f(p_n) falls to 1.0e−6 by p18. Frames ee show the secant lines flattening |
| 28 | A stopping test on \|f(p_n)\| alone would eventually accept a point far from the root | confirmed | follows from #27 |
| 29 | Case 4: x³ − x + 3 from p0 = 2, p1 = 1 wanders as far as 3.16 and −3.03, then converges to the root near −1.672 | confirmed | iterates 0.5, −3.0, 0.1111, −0.2653, 3.1639 (p6), −0.6592, −1.1175, −3.0342 (p9), …, −1.6717. Real root −1.671699882. Frames dd show p6 = 3.1639 and p9 near −3.03 |
| 30 | Related-pages sentence: Newton-Raphson uses the tangent; False Position and Bisection keep a bracket; Muller fits a parabola through the last three iterates; Brent safeguards secant and IQI steps with bisection; Broyden extends the secant idea to systems | confirmed | standard descriptions; all six target folders exist with index.qmd |
| 31 | Heading ids {#case-1} … {#case-6}, and the Description links to #case-1 … #case-6 | confirmed | each id is on the correct heading (lines 61–101); each link resolves; the cases' parameters match the Description's references |

## 3. Checks

**Six points of the overview standard**
- Problem: present (line 12).
- Core formula: present, as display math in the animations' p_n notation.
- Assumptions: present (f(p_n) ≠ f(p_{n−1}); C², f′(p) ≠ 0; local δ).
- Accuracy: present (the error relation and order 1.618 with "simple root" and "f″(p) ≠ 0" hypotheses, the Case 1 table, the f″ = 0 case, the multiple-root case).
- Failure modes: present (Case 5 divergence and the stopping-test trap, Case 4 erratic path, double root linear), with links to the cases.
- Where it fits: present (one sentence with six links).
- Optional worked example: a six-row table on the page's own Case 1 problem. It adds digits the GIF does not show, and it agrees with the GIF legends.
- Nothing the standard leaves out: no callout boxes, no proofs.

**Word count:** 398 by the standard's convention (I reproduced it independently). That is within 150–400.

**Links and anchors:** all six relative page links exist. All six case anchors are defined once and used once. The heading text is unchanged apart from the appended ids.

**Scope of the diff:** only the new Description and six `{#case-n}` ids. No script, GIF, Animations text, or other section changed, and no sentence was moved.

**Consistency with the rest of the page:**
- The Case 1 Behavior errors (0.066, 0.0089, 4.4e−4, 3.1e−6) match the table.
- The Case 2 Behavior ratio 0.618 matches.
- The Case 6 Behavior "order is 2 rather than 1.618" matches the Description's −1/3 / order 2 claim.
- Case 5's p10 ≈ 10.57 and p16 ≈ 15.11 match my iterates.
- I found no contradictions.

**Frames inspected:** contact sheets for secantmethodaa, secantmethoddd and secantmethodee. Their legends and geometry agree with the computed iterates cited above.
