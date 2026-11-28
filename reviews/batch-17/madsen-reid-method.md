# Damped Newton with Acceleration (Madsen-Reid Method) — batch 17 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 2 Minor

Page: `pages/numerical-methods/madsen-reid-method/index.qmd`, light-pass batch 17, overview (check). The diff changes only `index.qmd`: no script or GIF, so the animations are not under review. I did not consult the Mathews archive, because the page has no Mathews module (it follows Madsen and Reid 1975 and Vestermark's `newton_real`). I did not run MATLAB or quarto and changed nothing in the repository. My scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-17/madsen-reid-method/reviewer/`: `mr_check.jl` (the scripts' own `newton_real_iterates` copied verbatim, with no plotting, run on Cases 1–3 and on the x₀ = −0.7 variant) and `wc.py` (word counts and the error constant).

## 1. Findings

**F1: Description over the word limit. Page text, Minor.**
- **Location:** `## Description`, lines 8–53.
- **What is there:** about 1167 words of prose (manifest count). The standard allows 150–400.
- **What the batch added:** about 205 words, counted with my own script: line 16 has 46, line 17 has 25, line 27 has 40, line 33 has 27 and line 52 has 67.
- **Correction:** none. The director decided not to trim previously reviewed text on check pages, so I suggest no cuts. Nothing about the length misleads.

**F2: Off-by-one wording in the sentence under the new core-formula display. Page text, Minor.**
- **Location:** line 33, "The first are the plain ($k = 1$) and lengthened steps, the second is the halved step and the third is the rotated step".
- **What is wrong:** the display on line 30 has four items:
  1. $\Delta z = f(z)/f'(z)$
  2. $z - k\Delta z$
  3. $z - \tfrac12\Delta z$
  4. $z - \tfrac{0.6+0.8i}{8}\Delta z$

  Counted literally, "the first" is the definition of Δz, "the second" is the lengthened set and "the third" is the halved step. The plural "are" points to the intended reading, so the effect is small.
- **A related looseness:** the display defines $\Delta z = f(z)/f'(z)$ exactly, while line 27 says Δz is "cut and rotated if it is longer than $r_0$". The text resolves this, and the cap never acts in the three cases (line 23, confirmed: cap=0 at every step of every run).
- **Suggested fix:** "The points $z - k\,\Delta z$ are the plain ($k = 1$) and lengthened steps, $z - \tfrac12\Delta z$ is the halved step and the last is the rotated step; Stage 2 takes only $k = 1$."

## 2. Claim ledger (text the batch added or changed)

**L1.** Line 16: "at a simple root ($f'(x^*) \neq 0$) the trial point $z - 2\Delta z$ lands about as far from the root as $z$, on the other side". **Confirmed** as a general asymptotic result. With $e = z - x^*$, the Newton step is $\Delta z = e - Ce^2 + O(e^3)$, so $z - 2\Delta z$ has error $-e + 2Ce^2$. The hypothesis "near the root" is stated.

**L2.** Line 16: "near the root the search keeps $k = 1$, no halving is needed, and the steps are plain Newton steps, which converge quadratically". **Confirmed.**
- In general, $|f(z-\Delta z)| = O(e^2) < |f(z)|$, so no halving happens. The trial $z - 2\Delta z$ gives $|f| \approx |f'|\,|e|$, which is larger than $|f(z-\Delta z)|$, so the search stops and keeps $k = 1$.
- In the script runs, every Stage-1 step near a simple root is kind `plain` with k=1 and halvings=0: Case 1 step 2, and Case 3 step 4. Every Stage-2 step is plain Newton.
- The $r_0$ cap does not interfere: cap=0 throughout.

**L3.** Line 17: "[Case 1](#case-1) shows it: from step 3 on, each error divided by the square of the one before is 0.67, 0.74 and 0.74". **Confirmed.** From the script's own routine, $e_k = |x_k - x^*|$ with $x^* = 1.8793852415718167$ (residual −8.9e−16):

| Step | Error | Error / previous error² |
|---|---|---|
| 2 | 9.7829e−2 | — |
| 3 | 6.3969e−3 | 0.668392 |
| 4 | 3.0154e−5 | 0.736902 |
| 5 | 6.7487e−10 | 0.742202 |

Step 6 is at rounding level, 2.2e−16, and is correctly excluded. All errors are positive, so the iterates approach from the right.

**L4.** Line 17: "approaching $P''(x^*)/(2P'(x^*)) \approx 0.742$". **Confirmed.** For this polynomial the expression simplifies to $x^*/(x^{*2}-1) = 0.742227$, and its sign agrees with the positive error ratios.

**L5.** Line 27: "Away from the saddle-point and rounding-error branches …, every step moves from $z$ to one of these points … $\Delta z$ is the Newton step, cut and rotated if it is longer than $r_0$". **Confirmed** against the Stage-1 loop of the scripts (madsreidaa.jl lines 114–158; the algorithm block is identical in all three scripts, which I checked by diff). The possible outcomes:
- Lengthening gives $z_0 - (i+1)\,dz$.
- One helpful halving gives $z_0 - dz/2$.
- If the first halving does not help, the script keeps $z_0 - dz$ (the `:plain_increase` case), which is the k = 1 point.
- Two helpful halvings lead to `alterdirection` on $dz/4$.
- Stage 2 gives $z_0 - dz$.

No other point is reachable outside the true-saddle (u == 0) and rounding branches.

**L6.** Line 30: $z - k\Delta z$ with $k = 1, 2, \dots, n+1$. **Confirmed.** The loop `for i in 1:n` with `wz -= dz` tries $z_0 - (i+1)\,dz$, and the kept k = i + 1 can reach n + 1.

**L7.** Line 30: halved step $z - \tfrac12\Delta z$. **Confirmed.** It is the only halved point that can be accepted, because a second helpful halving triggers the rotation instead. Case 3 step 1 lands at z₁ = −0.25 = 1 − 2.5/2.

**L8.** Line 30: rotated step $z - \tfrac{0.6+0.8i}{8}\Delta z$. **Confirmed.** The code applies `alterdirection(dz/4, 0.5)`, which is $dz\,(0.6+0.8i)/8$. In Case 3 at z₁ = −0.25, Δz = 4.0625/(−0.5) = −8.125. Then −0.25 + 8.125(0.6+0.8i)/8 = 0.359375 + 0.8125i, which equals the script's z₂.

**L9.** Line 33: "the first are the plain and lengthened steps, the second … halved, the third … rotated". **Confirmed** in substance; the ordinal wording is off by one (F2).

**L10.** Line 33: "Stage 2 takes only $k = 1$". **Confirmed.** The Stage-2 branch sets z = z0 − dz with no trials.

**L11.** Line 52: "[Newton-Raphson](../newton-raphson-method/) is the step every stage starts from". **Confirmed.** Every branch starts from dz = P/P′, and the page exists.

**L12.** Line 52: "[Accelerated and Modified Newton-Raphson](../accelerated-and-modified-newton-raphson/) restores quadratic convergence at a multiple root, in one of its two forms by multiplying the step by a known multiplicity $m$ that the lengthening search here finds for itself". **Confirmed.**
- That page's Method A is $x - m f/f'$ with m known; Method B needs no m.
- Here the search picks k = 2 = m at the double root: Case 2 steps 2–5, and the x₀ = −0.7 run's steps 3–5.
- This holds while the run is in Stage 1, which line 14 already qualifies.

**L13.** Line 52: "[Halley's Method](../halleys-method/) uses $f''$ to converge cubically at simple roots". **Confirmed** as a standard result. It agrees with the Halley page (line 12) and the page exists.

**L14.** Line 52: "the [Lin-Bairstow Method](../lin-bairstow-method/) and [Graeffe's Method](../graeffes-method/) also find all the roots of a polynomial". **Confirmed.** The Graeffe page says it finds all roots simultaneously. The Lin-Bairstow page finds the roots two at a time through quadratic factors, real and complex pairs alike. Both pages exist.

**L15.** Line 14: "[Case 2](#case-2) stays in Stage 1 throughout". This is a link added to existing text, with the words unchanged. **Confirmed:** all five steps of Case 2 are stage1/lengthened.

**L16.** Line 37: "can only be shown in [Case 3](#case-3)". Link added, words unchanged. **Confirmed:** only Case 3 leaves the real axis (step 2 is rotated).

**L17.** Heading ids `{#case-1}`, `{#case-2}`, `{#case-3}` (lines 60, 68, 76). **Confirmed.** Each id is on the right case heading, and every `#case-n` link resolves to it.

The text on line 14 that the diff carries unchanged (the x₀ = −0.7 numbers) was not under review, but my run reproduced it as a by-product: x₁ = 1.7556, x₂ = 1.4123, errors 0.76 → 0.41, then 2.35e−2, 9.09e−5 and 1.38e−9, |P|² = 0, 5 steps. No contradiction.

## 3. Checks

**Six points of the overview standard**
1. **Problem:** present (line 10): all roots of a real-coefficient polynomial.
2. **Core formula:** present, now as display math (lines 29–31), in the animations' notation (z, Δz, z − kΔz). The formulas match the scripts (L5–L8).
3. **Assumptions:** present. Line 10 says a real-coefficient polynomial. Lines 38 and 50 cover the Kantorovich-style switch condition, which parts need only f and f′, and the need to evaluate f off the real axis for the rotation.
4. **Accuracy:** present.
   - Simple root: quadratic (new lines 16–17), with the hypothesis $f'(x^*) \neq 0$, checked on Case 1's own error ratios (L3, L4).
   - Multiple root: quadratic while the run stays in Stage 1 (line 14), shown by Case 2.
5. **Failure modes:** present. Stage 2 is linear at a multiple root, with the x₀ = −0.7 run as the example (line 14). Line 42 says the method does not guarantee descent.
6. **Where it fits:** present (new line 52). All five links resolve.

**Limits:** 1167 words, over 400 (F1). There are no theorem or definition callouts, proofs or MATLAB procedures. The "Note on generalization" blockquote is older text and not a callout box.

**General results:** the simple-root quadratic claim carries its hypothesis and was confirmed on Case 1. The multiplicity-search claim in the where-it-fits sentence matches the Case 2 runs.

**Agreement with the rest of the page:** no contradictions.
- The new display and the line-33 sentence agree with line 37's Stage-1 description: halving kept only while it helps, and two helpful halvings lead to rotation by 0.5(0.6+0.8i).
- They agree with Case 3's Behavior text: −0.25, 7.875, 3.8125, 1.78125, then 0.359375 + 0.8125i.
- The new simple-root paragraph agrees with Case 1's Behavior text and frames. The contact sheet shows step 1 green (lengthened) and steps 2–6 blue (plain), with Stage 1 at x₁ and x₂ and Stage 2 from x₃ on.

**Links and anchors:**
- `#case-1`, `#case-2` and `#case-3` match the explicit heading ids.
- `../newton-raphson-method/`, `../accelerated-and-modified-newton-raphson/`, `../halleys-method/`, `../lin-bairstow-method/` and `../graeffes-method/` all exist as page folders.
- The KaTeX in the new text (`\tfrac`, `\bigl…\bigr`, `\ \ `) is valid, and the display uses separate `$$` lines.

**Scope of the diff:** only `index.qmd` changed. The changes are:
- two new Description paragraphs (lines 16–17 and line 52);
- the new core-formula display with its two sentences (lines 27–33);
- link additions inside existing sentences (line 14 "[Case 2]", line 37 "[Case 3]"), with the other words unchanged;
- `{#case-n}` ids on the three case headings.

Nothing in the Animations Behavior text, alt text, embeds or any other section changed. All of these edits are allowed.
