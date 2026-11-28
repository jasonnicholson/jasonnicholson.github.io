# Halley's Method — batch 17 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Review of `halleys-method` (light-pass batch 17, overview page, action *check*). Page: /home/jason/Desktop/jasonhnicholson.com/pages/numerical-methods/halleys-method/index.qmd. Evidence: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-17/halleys-method/ (diff.patch, manifest.md, frames/). My scratch work is in its reviewer/ folder: ratios.py, plus thm.png, which shows Mathews' theorem hypotheses. I did not run MATLAB or quarto, and I changed nothing in the repository.

Mathews archive: consulted. I read /home/jason/Desktop/math-fullerton/baseline/mathews/n2003/Halley'sMethodMod.html as text and looked at the theorem images Halley'sMethodMod_gr_40–53.gif under n2003/halleysmethod/Halley'sMethodMod/Images/.

## 1. Findings

None.

## 2. Claim ledger

The claims come from the diff's `+` lines: Description lines 36–37 and 45, and the two heading ids on lines 64 and 72. The diff moves no sentences.

L1. "Mathews' theorem gives the hypotheses: $f \in C^3[a,b]$" — **confirmed**. Image gr_40 reads "f ∈ C³[a, b]".

L2. "$f(x^*) = 0$ with $f'(x^*) \neq 0$" — **confirmed**. Images gr_42 and gr_43 read "f(p) = 0" and "f'(p) ≠ 0"; gr_41 is "p ∈ [a, b]".

L3. "$x_0$ close enough to $x^*$, so convergence is only local" — **confirmed**. Images gr_44 and gr_49 read "δ > 0" and "p₀ ∈ [p − δ, p + δ]". Mathews guarantees convergence only for starts within δ of p.

L4. "[Case 1b] … show[s] the cubic rate: in extended precision, $|e_{n+1}|/|e_n|^3$ settles at $C = 1/8$ … by the third step" — **confirmed**.
- Formula: for f = x² − 2 at √2, f' = 2√2, f'' = 2, f''' = 0, so C = |0 − 4/(4·8)| = 1/8.
- Computation (mpmath, 200 digits, `python3 ratios.py`). The ratios for steps 1 to 5 are 0.0714286, 0.1231156, 0.1249999517, 0.125, 0.125.
- The errors are 1.4358e-2, 3.644e-7, 6.0486e-21, ….
- The ratio is 0.1249999517 at step 3, so "settles by the third step" holds.

L5. "[Case 2] … settles at $C = 1/3$ by the third step" — **confirmed**.
- Formula: for f = x³ − 3x + 2 at x* = −2, f' = 9, f'' = −12, f''' = 6, so C = |6/54 − 144/324| = |1/9 − 4/9| = 1/3.
- Computation from x₀ = −2.2: the ratios for steps 1 to 4 are 0.2577, 0.3324185, 0.333333332, 0.3333333333.
- The errors are 2.0619e-3, 2.9138e-9, 8.2463e-27, which match the Case 2 Behavior paragraph's 2.1e-3, 2.9e-9, 8.2e-27.

L6. The cases embody the cubic rate — **confirmed**.
- Frames of halleysab.gif show x₁ = 1.4285714286 and x₂ = 1.4142139268. The error of x₂ is 3.64e-7, which matches my computation.
- Frames of halleysba.gif show x₁ = −2.0020618557 and x₂ = −2.0000000029, which also match.
- Both cases are simple roots, so the general result applies to them.
- The ratios themselves are not in the frames, but the sentence says plainly that they come from extended precision. No contradiction.

L7. "[Newton-Raphson](../newton-raphson-method/) is the method Halley's corrects" — **confirmed**. This agrees with line 24 of the page (Halley's step is a multiplicative correction to the Newton step) and with Mathews' "the term in brackets shows where Newton-Raphson iteration function is changed". The target page exists.

L8. "the [Secant Method](../secant-method/) needs no derivatives" — **confirmed**. The secant iteration uses only values of f, and the target page exists.

L9. "at multiple roots, where Halley's is only linear" — **confirmed**.
- Halley on (x+2)(x−1)² from x₀ = 1.2: successive error ratios are 0.3408, 0.3359, 0.3342, …, 0.33334.
- That is linear with rate (m−1)/(m+1) = 1/3 for m = 2.
- It agrees with the existing line 39 of the page.

L10. "[Accelerated and Modified Newton-Raphson](../accelerated-and-modified-newton-raphson/) … restore[s] quadratic convergence" — **confirmed**.
- That page states that Methods A and B restore quadratic convergence (its lines 16 and 31).
- Its Case 2 and Case 3 show e_n/e_{n−1}² → ±1/6.
- The target page exists.

L11. "the [Improved Newton Method](../improved-newton-method/) restore[s] quadratic convergence" — **confirmed**.
- That page's Description states that Method A converges at least quadratically, and so does Method B.
- Method C reproduces Method A's iterates on its examples.
- The target page exists, and it links back to Halley's Method.

L12. Heading id `{#case-1b}` on "### Case 1b — Halley's Method, $f(x) = x^2 - 2$, $x_0 = 2$" — **confirmed**. The link `[Case 1b](#case-1b)` matches it, and the heading is the Halley run on x² − 2 (halleysab.jl / halleysab.gif).

L13. Heading id `{#case-2}` on "### Case 2 — Halley's Method, $f(x) = x^3 - 3x + 2$, $x_0 = -2.2$" — **confirmed**. The link `[Case 2](#case-2)` matches it, and the heading is the halleysba case.

## 3. Checks

**The six points of the overview standard:**
1. *The problem* (line 12): a root-finding algorithm that extends Newton-Raphson. Present.
2. *The core formula*: display math on lines 18 and 22, in the iterate notation $x_n$ used by the animations. Present.
3. *What it assumes* (line 36, new): C³, a simple root, and a close start, matching Mathews' theorem. Present.
4. *How accurate it is* (lines 28–34, plus line 37, new): order 3 for a simple root, with the constant C. It points to Cases 1b and 2, and I checked both on their own iterates (L4, L5). Present.
5. *When it fails or misleads*: convergence is only local (line 36), and at multiple roots the rate drops to linear (lines 39 and 45). Both are concrete; the second I verified numerically (L9). No animation shows a failure, so there is no case to link. Adequate.
6. *Where it fits* (line 45, new): one sentence linking four related pages, all of which exist. Present.

**Content limits:**
- The Description has no proofs, theorem boxes, callouts, or MATLAB or Mathematica procedures.
- The existing Trade-offs paragraph has a 20,000-digit timing comparison. That is outside this batch's `+` lines, so I did not review it.

**Word count:**
- My independent count of Description prose (lines 11–46, display math removed, inline math counted as one word, headings excluded) is 400 words. This equals the manifest's figure and sits exactly at the 400-word upper limit, so it is not a breach.

**Links and anchors:**
- Both in-page anchors match the explicit heading ids (L12, L13).
- All four cross-page links are relative paths (`../<slug>/`) to existing folders: newton-raphson-method, secant-method, accelerated-and-modified-newton-raphson and improved-newton-method. This is the same style the Improved Newton Method page uses.

**Scope of the diff:**
- Only index.qmd changed: two Description additions, plus the two heading ids inside Animations, which the standard allows.
- No script or GIF changed, so the animations were not under review. I looked at the halleysab and halleysba contact sheets only to check the cases the new text points to.
- The new text contradicts nothing in the Animations sections or the other sections. Its error values agree with the Case 2 Behavior paragraph, and its digits-tripling claim agrees with Case 1b.
