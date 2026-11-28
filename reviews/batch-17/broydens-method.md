# Broyden's Method — batch 17 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 2 Minor

Review of `pages/numerical-methods/broydens-method/index.qmd`, light-pass batch 17, overview page, action *check*. I reviewed the working-tree diff at EV/diff.patch: 6 insertions and 3 deletions, in index.qmd only. No script or GIF changed, so the animations are not under review. I did not run MATLAB or quarto, and I changed nothing in the repository. My scratch script is at /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-17/broydens-method/reviewer/check.py.

I consulted the Mathews archive (`/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/BroydenMethodMod.html`). The module states the algorithm theorems for 2-D and n-D Broyden and the Sherman–Morrison formula. It gives no convergence-rate theorem and no hypotheses, so the new hypothesis sentence departs from nothing in the module. There is no Fidelity finding.

## Part 1: Findings

**F1: Minor, Page text (overview limits).** The Description is 539 words of prose (lines 10–64), more than the 400 the overview standard allows. This batch added about 85 words (new lines 61–62). The old text was already about 450 words, over the limit before this batch. The director has decided not to trim previously reviewed text on check pages, so I suggest no cut to old text. The new lines are compact, and each one serves the "what it assumes" and "how accurate it is" points.

**F2: Minor, Page text (wording).** Line 61 reads: "and $\mathbf{X}^{(0)}$ and $B_0$ close enough to $\mathbf{X}^*$ and $J(\mathbf{X}^*)$; with $B_0 = J(\mathbf{X}^{(0)})$, as here, the second follows from the first."
- **Intended meaning:** "$B_0$ close to $J(\mathbf{X}^*)$" follows from "$\mathbf{X}^{(0)}$ close to $\mathbf{X}^*$". That is true: J is Lipschitz near the root, so $\|J(\mathbf{X}^{(0)}) - J(\mathbf{X}^*)\| \le L\|\mathbf{X}^{(0)}-\mathbf{X}^*\|$.
- **Problem:** the sentence lists three hypotheses, so "the second … the first" can be read as hypothesis 2 following from hypothesis 1, i.e. "J nonsingular follows from F being $C^1$". That is false.
- **Suggested wording:** "with $B_0 = J(\mathbf{X}^{(0)})$, as here, $B_0$ is close to $J(\mathbf{X}^*)$ whenever $\mathbf{X}^{(0)}$ is close to $\mathbf{X}^*$."

## Part 2: Claim ledger (new and changed text only)

| # | Claim (page's words) | Location | Verdict | Evidence |
|---|---|---|---|---|
| L1 | Link "[secant equation](../secant-method/)" | line 36 | confirmed | `pages/numerical-methods/secant-method/index.qmd` exists. The `../slug/` form is the site convention (e.g. `../bisection-method/` is used 5 times). |
| L2 | Superlinear convergence "as a general result … needs $\mathbf{F}$ continuously differentiable with a Lipschitz-continuous Jacobian near the root" | line 61 | confirmed | Matches the standard local theorem of Broyden, Dennis and Moré (1973): F differentiable on a convex neighbourhood, J Lipschitz at the root. |
| L3 | "$J(\mathbf{X}^*)$ nonsingular (a simple root)" | line 61 | confirmed | It is a hypothesis of the theorem. On the page's system: det J = −37.84 at the Case A root and +32.08 at the Case B root, so the hypothesis holds for both cases. |
| L4 | "$\mathbf{X}^{(0)}$ and $B_0$ close enough to $\mathbf{X}^*$ and $J(\mathbf{X}^*)$" | line 61 | confirmed | The theorem requires both $\|\mathbf{X}^{(0)}-\mathbf{X}^*\|<\varepsilon$ and $\|B_0-J(\mathbf{X}^*)\|<\delta$. |
| L5 | "with $B_0 = J(\mathbf{X}^{(0)})$, as here, the second follows from the first" | line 61 | confirmed (wording: F2) | Both scripts set `B = Jac(x0, y0)` at step 0, as the Algorithm's Step 0 says. The implication holds by the Lipschitz bound in F2. |
| L6 | "The ratio of successive errors $\|\mathbf{X}^{(k+1)}-\mathbf{X}^*\|/\|\mathbf{X}^{(k)}-\mathbf{X}^*\|$ then tends to zero" (definition of q-superlinear) | line 62 | confirmed | This is the standard definition. Computed in Case A: the ratio goes 0.023 → … → 7.7e-4 → 6.9e-6. |
| L7 | "in Case A it is between 0.02 and 0.04 for each of the first four steps" | line 62 | confirmed | 2-norm ratios: 0.02337, 0.03019, 0.02470, 0.03848. ∞-norm ratios: 0.0201, 0.0400, 0.0209, 0.0392. Within range in either norm. |
| L8 | "about $8\times10^{-4}$ for the fifth" | line 62 | confirmed | 2-norm 7.668e-4; ∞-norm 7.667e-4. |
| L9 | "where the log-scale residual plot steepens" | line 62 | confirmed | Residual ratios per step: 32.0, 24.5, 42.3, 25.7, then 1304 for X4→X5. In frame_007.png of broydenaa the k=4→5 segment is visibly steeper than the earlier ones. |
| L10 | Link "[Case A](#case-a)" and new heading id `{#case-a}` | lines 62, 78 | confirmed | The anchor exists and matches. The heading is the Case A case: script broydenaa.jl, X0 = (0.1, 0.7). |
| L11 | Lines 60 and 63 kept their words; only line breaks changed (L63 is the old paragraph's remainder) | lines 60, 63 | confirmed | Diff: the old single paragraph was split at the first sentence and the new lines inserted between. The old words are unchanged. |
| L12 | Consistency with Case A Behavior ("shrinks by between 24 and 43 times per step … last two steps by more than 1000 times") | line 80 vs 62 | confirmed, no contradiction | The residual ratios 24.5–42.3 for steps 2–4, step 1 at 32.0, and 1304 and 1.6e5 for the last two all agree with the new error-ratio sentence. |

Independent computation:
- I found both roots with mpmath at 50 digits: (0.0617701263386074, 0.7244905153472166) and (1.5560974843220530, −0.5756507696188434).
- I re-ran Broyden in numpy from the algorithm as stated, and computed errors against the mpmath roots.
- Case A iterate errors (2-norm): 4.54e-2, 1.06e-3, 3.20e-5, 7.91e-7, 3.04e-8, 2.33e-11, 1.60e-16.
- Case A residuals: 2.484e-1, 7.762e-3, 3.162e-4, 7.483e-6, 2.915e-7, 2.235e-10, 1.355e-15. These match the page's 2.5e-1, 7.8e-3 and ~1e-15.

## Part 3: Checks

**Six points of the overview standard:**
1. Problem: present (line 12).
2. Core formula: present. The rank-1 update is shown in display math (line 40, and in the Algorithm at line 54) with the scripts' notation B, s, y. The script line `B = B + (y_vec - B*s)*s'/denom` implements it exactly.
3. Assumptions: now present (line 61, new). Before this batch the Description had none apart from "near a simple root". This is the gap the batch filled.
4. Accuracy: present. Superlinear convergence is labelled as a general result, its hypotheses are stated, and it points to Case A with the case's own error ratios, which I verified (L7–L9).
5. Failure modes: present (line 63, old text): a start far from the root, or an ill-conditioned approximate Jacobian. Both animated cases converge, so there is no failure case to link to. This is acceptable.
6. Where it fits: present. It links to Nonlinear Systems (line 20) and Secant Method (line 36, new link).

**Limits:**
- No callout boxes, proofs or MATLAB/Mathematica procedures were added.
- Word count is 539, over the 400 limit (F1). The finite-difference subsection and the Algorithm are older text and outside this check's scope.

**Links and anchors:**
- `../secant-method/` resolves (the page exists).
- `#case-a` matches the new explicit id on the Case A heading.
- The existing link `../nonlinear-systems/index.qmd` was not changed; its target exists.

**Scope of the diff:**
- Only index.qmd changed. No script or GIF was touched (`git diff 147040f --stat` shows 1 file, +6/−3).
- The only change outside the Description is the `{#case-a}` id on the Case A heading, which the rules allow.
- No sentence was moved out of the Animations introduction.
- Other sections are unchanged.
