# Aitken's Method and Steffensen's Acceleration — batch 16 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 4 Minor

Page: `pages/numerical-methods/aitken-method-and-steffensen-acceleration/index.qmd`, light-pass batch 16, overview page. The batch action was *check*: it added to a Description that had already been reviewed. I did not run MATLAB or quarto and did not modify the repository. All scratch work is in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16/aitken-method-and-steffensen-acceleration/reviewer/`:
- `steff.jl`: independent Julia recomputation of the Steffensen and Newton iterates for all three cases.
- `steff.py`: Python float64 run, plus 80-digit mpmath runs in exact arithmetic.
- `wc.py`: word count.

I consulted the Mathews archive (`n2003/AitkenSteffensenMod.html`). It gives Aitken's theorem and the Steffensen algorithm, but no convergence order or hypotheses for Steffensen. So the new general claim has nothing in the module to depart from, and there is no Fidelity finding.

## 1. Findings

**F1: Minor (Page text).** Line 55: "[Case 2](#case-2) shows this rate: the errors of its first four Steffensen steps have exponents −2, −4, −8 and −16, doubling at each step."
- **What is there now:** the four exponents are right for the computed iterates: 3.802e-2, 3.077e-4, 1.677e-8 and 6.661e-16 (from `julia steff.jl`).
- **What is true instead:** the fourth error is the rounding floor, not the quadratic rate. The Case 2 Behavior paragraph itself calls it "three units in the last place".
  - In exact arithmetic (mpmath) the errors are 3.802e-2, 3.077e-4, 1.677e-8, 4.973e-17, 4.372e-34.
  - The quadratic constant e_{k+1}/e_k² settles at 0.177 (0.2216, 0.2129, 0.1771, 0.1768, 0.1768). That predicts about 5.0e-17 at step 4, which is exponent −17.
  - The float64 step-4 ratio is 6.661e-16/(1.677e-8)² = 2.37, more than ten times the true constant.
- **Effect:** the conclusion (quadratic convergence) is correct, and steps 1–3 show it cleanly. The −16 matching the doubling pattern is a near-coincidence of the rounding floor.
- **Suggested fix:** "the errors of its first three Steffensen steps have exponents −2, −4 and −8, doubling at each step, and the fourth reaches the rounding level of double precision ($6.7 \times 10^{-16}$)."

**F2: Minor (Page text).** Line 59: "In [Case 3](#case-3) the error stops falling after three steps, at a few times $10^{-8}$."
- **What is true instead:** the errors after step 3 (2.759e-8) are 5.442e-8, 2.148e-8 and 1.458e-8 (`julia steff.jl`, matching the Case 3 Behavior text and the GIF's last frame). The error keeps changing; steps 5 and 6 are below step 3, and step 6 is about half of it. It stalls in rounding noise rather than stopping.
- **Evidence that this is noise:** the noise depends on how $x^6$ is evaluated. Python's `**` (C pow) gives 5.27e-8, 3.50e-9 and 2.24e-8 for the same steps.
- **Suggested fix:** "In [Case 3](#case-3) the error stalls after three steps, wandering between about $1.5$ and $5.4 \times 10^{-8}$."

**F3: Minor (Page text, limits).** The Description is longer than the 150–400-word limit.
- **Counts:** the manifest gives 461 words for lines 10–70. My rougher count, `python3 -I wc.py`, gives 477 now and 310 before the batch. The batch's additions pushed it over.
- **Suggested fix:** trim about 60–80 words. Candidates:
  - The bold "Theorem (Aitken Acceleration)" statement, lines 30–42. It is a theorem statement, which the overview standard leaves out, although it is not a callout box. Its hypotheses already appear in line 24.
  - The second half of line 20, which repeats what lines 57–59 now say about rounding.

**F4: Minor (Page text, standard point 2, notation; this text predates the batch).** The Steffensen algorithm on lines 48–50 is written with $p_0, q_1, q_2, p_1$. The animations use $x_k$ for Newton iterates and $S_k$ for Steffensen iterates (legends, annotations and the Behavior paragraphs: "$S_3$", "$S_4$"). The added text avoids symbols ("third Steffensen iterate"), so nothing contradicts. Still, the core formula is not in the animations' notation, as the standard asks.
- **Suggested fix:** write the steps with $S_k$, e.g. $q_1 = S_k - f(S_k)/f'(S_k)$, … , $S_{k+1} = S_k - (q_1-S_k)^2/(q_2-2q_1+S_k)$. Alternatively, add "(the $S_k$ of the animations)".

## 2. Claim ledger (added text, the `+` lines)

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| L1 | "at a root $p$ of multiplicity $m$ the Newton map $g(x)=x-f(x)/f'(x)$ has $g'(p)=(m-1)/m \neq 1$" | confirmed | With $f=(x-p)^m h$ and $h(p)\neq0$: $g(x)=x-(x-p)h/(mh+(x-p)h')$, so $g'(p)=1-1/m$. This is never 1 for finite $m\ge1$. |
| L2 | "if $g$ is smooth enough near $p$, Steffensen's iteration converges quadratically from starting values close enough to $p$" | confirmed (general result, hypotheses adequate) | Standard local theorem: Steffensen on $g$ with $g'(p)\neq1$ and $g\in C^2$ converges at least quadratically. The order is higher when $g'(p)=0$, which is still "quadratically" in the at-least sense. Checked on all three cases in exact arithmetic: e_{k+1}/e_k² → 0.083 (Case 1), 0.177 (Case 2), about 0.58 (Case 3). |
| L3 | "[Case 2] shows this rate" | confirmed | Exact-arithmetic and float64 ratios 0.22, 0.21, 0.18 over steps 1–3. |
| L4 | Case 2 first four step errors have exponents −2, −4, −8, −16, "doubling at each step" | confirmed as numbers (3.8e-2, 3.1e-4, 1.7e-8, 6.7e-16); see F1 on the fourth | `julia steff.jl`; GIF last frame shows the Steffensen curve at about −15.2. |
| L5 | "Rounding limits both methods near a double root, where $f$ is tiny and is computed with a large relative error" | confirmed | Newton: $f$ evaluates to exactly 0 after 28 steps (Case 1, error 1.521e-9) and 25 steps (Case 3, error 2.554e-10). Steffensen: Cases 1 and 3, below. |
| L6 | "In [Case 1] the expanded cubic rounds to exactly 0 at the third Steffensen iterate" | confirmed | S_3 = 0.99999999344396751, f(S_3) = 0.0 in Julia and in Python. |
| L7 | "so both Newton steps from it return the same point and the $\Delta^2$ denominator is 0" | confirmed | q1 == S_3, q2 == q1, denominator = 0.0. The script's stop reason "Δ² denominator = 0" appears in the last frame's legend. |
| L8 | "In [Case 3] the error stops falling after three steps" | wrong in the literal sense, right in spirit (F2) | Errors 2.76e-8, 5.44e-8, 2.15e-8, 1.46e-8. |
| L9 | "... at a few times $10^{-8}$" | confirmed | 1.5–5.4e-8; the GIF bottom panel sits at about −7.5 to −7.8. |
| L10 | "Steffensen's method is Aitken's process applied to a fixed-point iteration, here the Newton-Raphson map" | confirmed | Agrees with lines 48–50, with Mathews ("combined with the fixed point iteration in Newton's method"), and with the scripts. |
| L11 | Accelerated and Modified Newton-Raphson "restore[s] quadratic convergence at multiple roots in other ways" | confirmed | That page (lines 16–31) presents Methods A and B as restoring the quadratic rate. |
| L12 | Improved Newton Method restores quadratic convergence at multiple roots in other ways | confirmed | `improved-newton-method/index.qmd` lines 12 and 29–30: methods for roots of multiplicity m ≥ 2, at least quadratic. |
| L13 | "the [Power Method] applies Aitken's process to its eigenvalue estimates" | confirmed | `power-method/index.qmd` lines 119–126 and 220. |
| L14 | Links `../fixed-point-iteration/`, `../newton-raphson-method/`, `../accelerated-and-modified-newton-raphson/`, `../improved-newton-method/`, `../power-method/` resolve | confirmed | Each is a folder with `index.qmd`. |
| L15 | Heading ids `{#case-1}`, `{#case-2}`, `{#case-3}` added to the Case headings; links `#case-1/2/3` | confirmed | Explicit ids, unique on the page, match the links. |
| L16 | Case 2 Behavior and the GIF agree with the new text (stop at S_4 by the f′ cutoff) | confirmed | f′(S_4) = −8.79e-15 < 1e-14; the legend says "stopped: \|f'(S_4)\| < 1e-14". |

Pre-existing numbers I also recomputed in passing, all confirmed:
- Line 20: Newton reaches f = 0 at 28 and 25 steps, with errors 1.5e-9 and 2.6e-10.
- Newton errors at step 22: 3.1e-7, 4.7e-8 and 2.4e-8.
- Case 1 and Case 3 Steffensen error sequences.

## 3. Checks

**Six points of the overview standard:**
1. Problem: present (lines 12–20).
2. Core formula: present as display math (Aitken, line 27) and the Steffensen steps (lines 48–50). The notation differs from the animations (F4).
3. Assumptions: present. Aitken: $x_k\neq p$, error ratio → A with \|A\|<1. Steffensen: $g'(p)\neq1$, g smooth, start close.
4. Accuracy: present and general, with hypotheses. Pointed to Case 2 and verified (F1 on the fourth exponent).
5. Failure modes: present (rounding), linked to Cases 1 and 3 and verified (F2 on wording).
6. Where it fits: present (line 69), all links resolve and the claims check out.

**Limits:** 461 words (manifest), above 400 (F3). There is a bold-labelled theorem statement (lines 30–42), pre-existing and not a callout box (noted under F3). There is no proof and no derivation beyond a line. The summary table predates the batch and says "Superlinear (≈2)", which is consistent with the new "quadratically".

**Scope of the diff:**
- `git diff --stat 147040f` shows only `index.qmd` changed (+12/−3), with no working-tree changes in the folder. No script or GIF changed, so the animations were not re-reviewed.
- Outside the Description, the only changes are the three `{#case-n}` heading ids, which the standard allows. The Animations introduction and Behavior paragraphs are unchanged, and no sentences were moved.

**Frames viewed:** the last frame of each GIF (`aitkenab`, `aitkencd`, `aitkenef` frame_023). Legends, S_k annotations, stop reasons and the levels of the bottom panels match the recomputed values above.
