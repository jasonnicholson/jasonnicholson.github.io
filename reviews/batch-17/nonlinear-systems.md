# Nonlinear Systems — batch 17 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 2 Minor

Page: `pages/numerical-methods/nonlinear-systems/index.qmd`, light-pass batch 17, overview page (action *check*). Evidence folder: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-17/nonlinear-systems. My scratch script: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-17/nonlinear-systems/reviewer/ratios.py. I did not run MATLAB or quarto and changed nothing in the repository. I consulted the Mathews archive (`n2003/NewtonSystemMod.html`, read as text).

## 1. Findings

**F1 — Page text, Minor — the Description is over the word limit.**
- Where: the Description, lines 10–71.
- What is there: 441 words of prose. The manifest gives 441, and my own rough count (display math, table rows and headings left out; inline math counted as one word) also gives 441. The standard's limit is 400.
- The batch added about 70 words (lines 58 and 70). The rest is text that was reviewed before.
- As the director instructed, I am not suggesting cuts to the old text. The breach does not mislead anyone.

**F2 — Page text, Minor — point 3 ("what it assumes") leaves out smoothness for Newton's quadratic rate.**
- Where: line 57, which is old text that the new line 58 builds on: "Newton's method converges **quadratically** near a non-singular solution (one where $\det J(\mathbf{X}^*) \neq 0$)".
- The general result also needs F to be smooth enough: twice continuously differentiable, or with a Lipschitz-continuous Jacobian, near X*.
- The other conditions are already there. "Near" covers the need to start close enough, and the table says "Requires good starting guess".
- For this page's own system the gap does no harm. F is a polynomial, and det J ≠ 0 at both solutions (I computed −37.84 and 32.08). So the new line 58 is correct where it applies the result to the cases.
- The neighbouring Lin-Bairstow page states the hypothesis ("for a smooth system").
- Suggested fix, which adds words and cuts none: "near a non-singular solution of a smooth $\mathbf{F}$ (one where …)".

No Fidelity findings. Mathews' module gives the four-step algorithm and the row-sum condition. It states no convergence rate for Newton's method, so the new text departs from nothing in it.

## 2. Claim ledger (the text the batch added or changed)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L1 | "[Case 1](#case-1) and [Case 2](#case-2) show this rate" (quadratic) | confirmed | Over steps 3–5 the ratio e_k/e_{k−1}² stays roughly constant in both cases (L2, L3), which is the sign of quadratic convergence. |
| L2 | Case 1: "at steps 3 to 5, each error divided by the square of the previous one is between 0.51 and 0.54" | confirmed | Float64 iterates, the same as the script's: 0.5188, 0.5346, 0.5192. Exact iterates at 60 digits: 0.5188, 0.5346, 0.5349. Errors are Euclidean distances to the 60-digit root (0.0617701263386, 0.724490515347). |
| L3 | Case 2: "between 0.92 and 0.97" | confirmed | Float64: 0.9275, 0.9573, 0.9603. Exact: 0.9275, 0.9573, 0.9604. Root is (1.55609748432, −0.575650769619). The upper end of the bracket is a little loose (the largest value is 0.960), but the bracket is still correct. |
| L4 | "steps 3 to 5", with steps meaning iterates x^(k) | confirmed | Frame 4 of newtonsysab shows x^(3) = (1.5571, −0.5756). Its distance to the root is 1.05e−3, which matches the 1.1×10⁻³ in the Behavior paragraph. |
| L5 | Choosing steps 3–5 is fair | confirmed | Steps 1–2 are not yet in the asymptotic regime (ratios 1.20 and 0.42 in Case 1, 0.57 and 0.73 in Case 2). Step 6 is at round-off (errors around 1e−17), so its float ratio means nothing. The sentence states the window it uses. |
| L6 | "[Newton-Raphson](../newton-raphson-method/) … [is] the one-equation version" | confirmed | Its Description says it "solves a single equation $f(x) = 0$". |
| L7 | "[Fixed Point Iteration](../fixed-point-iteration/) … [is] the one-equation version" | confirmed | Its Description says it "solves an equation written in the form $x = g(x)$". |
| L8 | "[Broyden's Method](../broydens-method/) replaces the Jacobian by an approximation updated from the change in $\mathbf{F}$" | confirmed | The Broyden page's rank-1 secant update uses ΔF (and ΔX), with no new derivative evaluations. |
| L9 | "the [Lin-Bairstow Method](../lin-bairstow-method/) is Newton's method in two variables" | confirmed | Lin-Bairstow page, line 30: "Newton's method on these two equations in $r$ and $s$". |
| L10 | Heading id `{#case-1}` added to "Case 1 — Solution 1, starting at $(0.5,\; 0.8)$" | confirmed | The heading text is otherwise unchanged, the id is unique on the page, and the link `#case-1` matches it. |
| L11 | Heading id `{#case-2}` added to "Case 2 — Solution 2, starting at $(2,\; -1)$" | confirmed | Same as L10. |

## 3. Checks

**Scope of the diff.**
- The diff changes only index.qmd. No script or GIF changed, so the animations are not under review.
- Inside the Description, it adds two lines (58 and 70).
- Outside the Description, it only adds the explicit ids {#case-1} and {#case-2} to the case headings. These are allowed cross-reference edits.
- No sentence was moved. No other section changed.

**Consistency with the rest of the page.**
- Line 58 agrees with the Behavior paragraphs (lines 86 and 94). My float64 errors are 4.447e−1, 2.367e−1, 2.374e−2, 2.923e−4, 4.569e−8, 1.084e−15 (Case 1) and 6.141e−1, 2.142e−1, 3.367e−2, 1.051e−3, 1.058e−6, 1.076e−12 (Case 2). Both lists match the page.
- Line 58 also agrees with the Animations intro, which calls quadratic convergence local. Ratios that only settle from step 3 on are consistent with that.
- Line 70 contradicts nothing on the page.

**Six points of the standard.**
1. The problem: present (line 12).
2. The core formula: present (line 48, $J\,\Delta\mathbf{X}^{(k)} = -\mathbf{F}$, $\mathbf{X}^{(k+1)} = \mathbf{X}^{(k)} + \Delta\mathbf{X}^{(k)}$). This is the notation of the Animations intro and what the scripts run (`pts[k] - Jv \ F(pts[k])`). The system on line 14 is written as f, g, while the animations use f₁, f₂. That is in old text and harmless, so I am not reporting it as a finding.
3. What it assumes: det J ≠ 0, a good starting guess, and the row-sum condition for fixed-point iteration are all present. Smoothness is missing (F2).
4. How accurate it is: quadratic, now linked to both cases with checked ratios.
5. When it fails or misleads: a singular Jacobian at the solution loses the quadratic rate (line 57), the table notes starting-guess sensitivity, and the row-sum condition can fail for fixed-point iteration. Neither case shows a failure, so there is nothing to link. I count this point as met.
6. Where it fits: present (line 70).

There are no proofs or theorem boxes.

**Word count:** 441, over the 400 limit (F1).

**Links and anchors.**
- The four relative links point to folders that exist, each with an index.qmd: newton-raphson-method, fixed-point-iteration, broydens-method and lin-bairstow-method. The `../slug/` form is the one other pages already use for these links.
- `#case-1` and `#case-2` match the new explicit ids.
- No other .qmd in the repo links to the old automatic anchors of these headings (I searched for `nonlinear-systems/#` and found none).

**Markup.**
- Line 58 has no blank line before it, so it renders as part of the line-57 paragraph. The same holds for line 70 and line 69. Both render fine.
- The inline math is well formed.
