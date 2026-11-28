# Fixed Point Iteration — batch 16 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/fixed-point-iteration/index.qmd` (overview page, light-pass batch 16). Reviewer scratch: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16/fixed-point-iteration/reviewer/ (check.py, wc.py, mathews_thm.png). I did not run MATLAB or quarto and did not modify the repository. I consulted the Mathews archive: FixedPointMod.html text, plus its equation images from `n2003/fixedpoint/FixedPointMod/Images/` (gr_46–49, 51, 56, 69).

## 1. Findings

None.

I looked at these possible issues and decided none of them is a finding:
- **The theorem's x0 ∈ (a, b) (line 22).** It matches Mathews' Second Fixed Point Theorem exactly. The images show hypothesis (b) g, g' ∈ C[a,b], (d) p0 ∈ (a,b), (e) g(x) ∈ [a,b], conclusion (i) |g'(x)| ≤ K < 1, and the Corollary |P − p_n| ≤ K^n |P − p0|. The page combines this with the First theorem's uniqueness, which is legitimate.
- **Case 6, "they alternate sides ... settle onto a 4-cycle" (line 49).** It is stated generally for the iterates near 2, so I checked it generally. All 60 starts I tried in [1.5, 1.999] ∪ [2.001, 2.5] reach the same 4-cycle. The cycle's multiplier is −0.0305, so it is stable. The only 2-cycle, {−2, 4}, has multiplier −1.25, so it is unstable and attracts nothing.
- **The table headed e_n/e_{n−1} skips rows (n = 4, 8, 12).** The ratio uses the unshown x_{n−1}. The heading makes that clear, so this is not a finding.

## 2. Claim ledger (the + lines of the diff and the moved sentence)

| # | Claim (page's words, line) | Verdict | Evidence |
|---|---|---|---|
| L1 | Solves x = g(x); a fixed point is where y = g(x) meets y = x (12–13) | confirmed | definition; matches Mathews |
| L2 | f(x) = 0 can be rewritten as x = g(x) in many ways, and the choice of g decides whether the method works (14) | confirmed | standard; Cases 1–3 vs 4–6 illustrate it |
| L3 | x_{n+1} = g(x_n), n = 0, 1, 2, … (17–19) | confirmed | all six scripts do `xs[i+1] = g(xs[i])` |
| L4 | If g is continuous and the iterates converge, the limit is a fixed point (21) | confirmed | matches Mathews' "Theorem (For a converging sequence)" |
| L5 | g, g' ∈ C[a,b], g([a,b]) ⊂ [a,b], \|g'\| ≤ K < 1 ⇒ unique fixed point, convergence from every x0 ∈ (a,b), \|x* − x_n\| ≤ K^n \|x* − x0\| (22) | confirmed | matches the Mathews images (First theorem (ii), Second theorem (i), Corollary); standard contraction result |
| L6 | The conditions are sufficient, not necessary; Case 1 x0 = 0.1, g'(x0) ≈ 2.24, still converges to 2 (23) | confirmed | g'(0.1) = 1/√0.2 = 2.23607; x_40 = 1.99999999999455, increasing monotonically. No interval with 0.1 inside meets \|g'\| < 1 |
| L7 | Moved sentence: g ∈ C¹, \|g'(x*)\| < 1 ⇒ local convergence; \|g'(x*)\| > 1 ⇒ nearby iterates move away (24) | confirmed | true as a general result. Moved word for word from the old Animations introduction (the diff shows the removed text is identical) |
| L8 | e_n = x_n − x*; with g ∈ C¹ and convergence without reaching x*, the mean value theorem gives e_{n+1} = g'(c_n) e_n, so e_{n+1}/e_n → g'(x*) (26–31) | confirmed | standard; hypotheses stated; c_n → x* and g' is continuous |
| L9 | Linear when 0 < \|g'(x*)\| < 1; error is multiplied by about \|g'(x*)\| each step; slower as it nears 1 (33) | confirmed | follows from L8 |
| L10 | g'(x*) > 0 ⇒ the iterates eventually stay on one side; g'(x*) < 0 ⇒ they eventually alternate (34) | confirmed | sign of g'(c_n) is eventually that of g'(x*) |
| L11 | g'(x*) = 0 ⇒ faster than linear (35) | confirmed | e_{n+1}/e_n → 0 under the L8 hypotheses |
| L12 | Case 2 has g'(2) = 1/2, Case 3 has g'(2) = −1/2, and they show the monotone and oscillating patterns (36) | confirmed | g' = 1/√(2x) gives 1/2; g' = −8/(x+2)² gives −1/2. Computed: Case 2 decreases monotonically to 2; Case 3 sides of 2 alternate every step. Final frames: fixpointbb x_12 = 2.0003 one-sided staircase; fixpointcc x_12 = 2.0004 spiral |
| L13 | Table, Case 2 x_n: 4, 2.828427, 2.378414, 2.088548, 2.005423, 2.000338 (40–45) | confirmed | mpmath: 4, 2.828427125, 2.37841423, 2.088547565, 2.00542255, 2.000338479 |
| L14 | Table, Case 2 ratios: 0.4142, 0.4568, 0.4892, 0.4993, 0.5000 | confirmed | 0.41421356, 0.45678638, 0.48917127, 0.4993231, 0.49995769 |
| L15 | Table, Case 3 x_n: 4, 1.333333, 2.400000, 2.095238, 2.005865, 2.000366 | confirmed | 4, 1.333333333, 2.4, 2.095238095, 2.005865103, 2.000366233 |
| L16 | Table, Case 3 ratios: −0.3333, −0.6000, −0.5238, −0.5015, −0.5001 | confirmed | −0.33333333, −0.6, −0.52380952, −0.50146628, −0.50009156 |
| L17 | Table uses the page's own animated problems, with numbers that agree with the GIFs | confirmed | fixpointbb.jl and fixpointcc.jl have x0 = 4.0 and n_iters = 12; frame_013 legends show 2.0003 and 2.0004 |
| L18 | \|g'(x*)\| > 1 ⇒ repels; where the iterates go depends on the rest of g (47) | confirmed | general; Cases 4–6 show three different outcomes |
| L19 | g = x²/4 + x/2 has g'(2) = 3/2; starts just below 2 converge to 0 (Case 4) (48) | confirmed | on (0, 2), 0 < g(x) < x. From 1.95: decreases monotonically, x_60 = 1.1e−15 |
| L20 | The same g: starts just above 2 grow without bound (Case 5) (48) | confirmed | g(x) − x = x(x−2)/4 > 0 and increasing for x > 2. From 2.03: x_9 = 3.75337, x_12 = 29.921, x_14 = 14373 |
| L21 | g = −x²/4 − x/2 + 4 has g'(2) = −3/2; the iterates alternate sides of 2 and settle onto a 4-cycle (Case 6) (49) | confirmed | g'(2) = −1 − 1/2 = −3/2. From 1.97 the side pattern is −+−+… for 40 steps; the tail cycle is 4.24996, −2.64052, 3.57717, −0.987621; multiplier −0.0305 (stable); every near-2 start tested reaches it. fixpointff sheet: x_30 = −2.6388, matches |
| L22 | Newton-Raphson is fixed point iteration with g = x − f/f'; g'(x*) = 0 at a simple root if f is twice differentiable (51) | confirmed | g' = f f''/f'², which is 0 when f(x*) = 0 and f'(x*) ≠ 0 |
| L23 | Aitken/Steffensen speed up linearly convergent sequences; Nonlinear Systems and Jacobi/Gauss-Seidel apply the idea to systems; Picard to differential equations (51) | confirmed | standard; all target pages exist (see checks) |
| L24 | Heading ids {#case-1} … {#case-6} added to the case headings (62–109) | confirmed | diff shows only the ` {#case-N}` suffix added; heading text unchanged |

## 3. Checks

**Scope of the diff.** Only index.qmd changed (`git diff --stat 147040f -- .` shows 1 file, +50/−7). No script or GIF changed, so the animations are not under review. Outside the Description there are two kinds of change. (a) One sentence moved from the Animations introduction to line 24, word for word. (b) Six explicit heading ids. Both are allowed.

**Six points of the standard:**
1. The problem: lines 12–14.
2. The core formula: display math at lines 17–19, in the scripts' notation.
3. What it assumes: lines 21–24 (continuity, the contraction hypotheses, the local C¹ condition, the choice of g).
4. How accurate it is: lines 26–45 (linear rate with its hypotheses, the e_{n+1}/e_n → g'(x*) limit, and the error-ratio table checked against Cases 2 and 3).
5. When it fails: lines 47–49 (repelling fixed point, with three outcomes linked to Cases 4–6).
6. Where it fits: line 51.

All present and in order. There are no callout or theorem boxes and no proofs; the MVT line is a one-line intuition. The worked example is a 6-row table that adds digits and ratios the GIFs do not show.

**Word count.** I counted 396 words of prose independently (inline math as 1 word, display math and table rows excluded), the same as the manifest. That is within 150–400, close to the upper limit.

**Links and anchors.**
- `#case-1` … `#case-6` each match an explicit `{#case-N}` id on its heading.
- These targets all exist:
  - `../newton-raphson-method/index.qmd`
  - `../aitken-method-and-steffensen-acceleration/index.qmd`
  - `../nonlinear-systems/index.qmd`
  - `../jacobi-and-gauss-seidel-iteration/index.qmd`
  - `../picard-iteration/index.qmd`

**Consistency with the rest of the page.** The new text agrees with every Behavior paragraph:
- Case 1: g'(x) > 1 for x < 1/2, and the error is roughly halved near 2.
- Case 3: g'(2) = −1/2.
- Case 4: monotone convergence to 0.
- Case 5: x_9 ≈ 3.753, x_12 ≈ 29.92, x_14 ≈ 1.437×10⁴. My computed values are 3.75337, 29.921, 14373.
- Case 6: 4-cycle ≈ 4.25, −2.64, 3.58, −0.99.

I found no contradictions.

**Fidelity.** The theorem statement, hypotheses and error bound match Mathews' Second Fixed Point Theorem and its Corollary as shown in the module's equation images. I found no unexplained departure.
