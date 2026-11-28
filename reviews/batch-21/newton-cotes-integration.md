# Newton-Cotes Integration — batch 21 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Review of `pages/numerical-methods/newton-cotes-integration/index.qmd`, light-pass batch 21, overview mode (action *extend*). The diff touches only `index.qmd`. No script or GIF changed, so the animations were not under review. I did not run MATLAB, quarto or any state-changing git command, and I modified nothing in the repository. My scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-21/newton-cotes-integration/reviewer/` (chk.py, err.py, wc.py).

I consulted the Mathews archive: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/NewtonCotesMod.html`, read as text. Its formulas are images that I did not open. The page's four panel formulas and error terms are the standard closed Newton-Cotes theorem, and I verified each one symbolically (see L5–L8). I found no fidelity departure.

## 1. Findings

**F1 — Page text, Minor.** index.qmd line 35: "Nearly all of that error comes from the panel at $x=0$: at 121 sample points it contributes over 99% of the error of Simpson's $3/8$ and Boole's rules".
- **What is wrong:** "that error" follows two sentences about the error of all four rules, so a reader can take "nearly all" to cover the trapezoidal rule too. It does not.
- **Evidence (chk.py, mpmath at 40 digits; reference I = 2.0162797196170963 from the substitution x = t³, agreeing with a direct 40-segment quad):** at n = 120, the share of the total error that comes from the first panel is:

| Rule | Share from first panel |
|---|---|
| Trapezoidal (panel width h) | 71.2% |
| Simpson 1/3 | 99.18% |
| Simpson 3/8 | 99.25% |
| Boole | 99.98% |

- **Which claims hold:** the stated claims (over 99% for Simpson 3/8 and Boole) are correct. Only the lead-in "Nearly all of that error" overreaches when read as covering all four rules.
- **Suggested fix:** "Nearly all of the higher-degree rules' error comes from the panel at $x=0$: …". Alternatively, add "(about 71% for the trapezoidal rule)".

## 2. Claim ledger

The ledger covers the `+` lines of the diff. Sentences that moved are marked [moved].

- **L1.** "Newton-Cotes formulas approximate $\int_a^b f$ from values of $f$ at equally spaced nodes." **Confirmed.**
- **L2.** On a panel of M subintervals of width h, nodes $x_k=x_0+kh$, they integrate the degree-M polynomial through the M+1 nodes; the closed rules include both endpoints. **Confirmed** (standard; matches the Mathews text).
- **L3.** Trapezoidal: $\frac h2(f_0+f_1)-\frac{h^3}{12}f''(c)$. **Confirmed.** sympy, with f = x²: E/(h³f'') = −1/12.
- **L4.** Simpson 1/3: $\frac h3(f_0+4f_1+f_2)-\frac{h^5}{90}f^{(4)}(c)$. **Confirmed.** With f = x⁴: −1/90.
- **L5.** Simpson 3/8: $\frac{3h}{8}(f_0+3f_1+3f_2+f_3)-\frac{3h^5}{80}f^{(4)}(c)$. **Confirmed.** −3/80.
- **L6.** Boole: $\frac{2h}{45}(7,32,12,32,7)-\frac{8h^7}{945}f^{(6)}(c)$. **Confirmed.** With f = x⁶: −8/945.
- **L7.** The panel formulas are the formulas the scripts implement. **Confirmed.**
  - aa: trapezoid sum with dx·(½f(a) + Σ + ½f(b)).
  - bb: (dx/3)(ends + 4·odd + 2·even).
  - cc: (3dx/8)(ends + 3·non-multiples of 3 + 2·multiples of 3).
  - dd: Boole panel weights 7, 32, 12, 32, 7 with factor 2dx/45.
  - These are exactly the composites of L3–L6.
- **L8.** "Mathews states the first four with their error terms" (attribution). This matches the archive text (Theorem, eqs. (4)–(7), and the Corollary, eqs. (8)–(11)). **Confirmed** as far as the text shows.
- **L9.** Composite: $h=(b-a)/n$, n/M panels, n a multiple of M. **Confirmed.**
- **L10.** Cases 1 to 4 use M = 1, 2, 3, 4. **Confirmed** from the scripts: the n_seq values are all multiples of 1, 2, 3 and 4 respectively, and the panel loops step by 1, 2, 3 and 4.
- **L11.** The error terms need f ∈ C² (trapezoidal), C⁴ (both Simpson rules) and C⁶ (Boole) on the panel. **Confirmed.**
- **L12.** Degrees of precision are 1, 3, 3, 5. **Confirmed** (sympy: the first inexact monomials are degrees 2, 4, 4, 6).
- **L13.** "For even M the symmetric panel gains one degree." **Confirmed** (general result; consistent with L12).
- **L14.** With those continuous derivatives on [a, b], the composite errors are O(h²), O(h⁴), O(h⁴), O(h⁶). **Confirmed.** It is stated as a general result with its hypothesis.
- **L15.** The animations do not show these orders. Every case uses $f=e^{-x}\sin(8x^{2/3})+1$ on [0, 2], which is not smooth at 0. **Confirmed.** All four scripts use this f, with a, b = 0, 2.
- **L16.** [moved] f′ is unbounded at 0, with $f'(x)\approx\frac{16}{3}x^{-1/3}$, so the textbook order does not hold. **Confirmed.** sympy: lim x^{1/3}f′(x) = 16/3.
- **L17.** [moved] The error shrinks like O(h^{5/3}). Going from 24 to 48 subintervals divides it by about 3.14, 3.38, 3.55, 3.15, tending to 2^{5/3} ≈ 3.17 for each. **Confirmed.**
  - Computed ratios: 3.1415, 3.3803, 3.5499, 3.1513.
  - At n = 768→1536 the ratios are 3.1720, 3.1754, 3.1755, 3.1752.
  - 2^{5/3} = 3.1748.
- **L18.** [moved] At equal h the higher-degree rules gain only a constant factor over the trapezoidal rule. **Confirmed.** Error relative to the trapezoidal rule:

| n | Simpson 1/3 | Simpson 3/8 | Boole |
|---|---|---|---|
| 24 | 0.308 | 0.411 | 0.242 |
| 120 | 0.280 | 0.352 | 0.239 |

  The ratios are essentially constant.
- **L19.** The moved sentences (L16–L18) have their words unchanged compared with the removed Animations-introduction text. **Confirmed** by diffing the removed and added lines.
- **L20.** "Nearly all of that error comes from the panel at x = 0." **Partly wrong in scope.** Correct for the higher-degree rules (99.2–99.98%) but 71% for the trapezoidal rule. See F1.
- **L21.** At 121 sample points the first panel contributes over 99% of the error of Simpson 3/8 and Boole (links to Case 3 and Case 4). **Confirmed:** 99.25% and 99.98%. Cases 3 and 4 do end at 121 points; the last frames read 2.01581 and 2.015961, matching my 2.0158104 and 2.0159612.
- **L22.** Adaptive Simpson's rule refines only panels whose error estimate is large. **Confirmed** (general description; the page exists).
- **L23.** The closed rule on nine nodes (M = 8) already has negative weights, which can amplify rounding errors. **Confirmed.**
  - sympy, M = 8 weights (×1/14175): 3956, 23552, −3712, 41984, −18160, … The two negative weights are −3712/14175 and −3632/2835.
  - M = 6 and M = 7 have all positive weights, so "already" (first at M = 8) is correct.
- **L24.** Romberg recovers Simpson's and Boole's rules from trapezoidal sums. **Confirmed.** This is standard, and the Romberg page (line 26) says the same.
- **L25.** Gauss-Legendre drops equal spacing and has degree of precision 2N−1 with N nodes. **Confirmed.**
- **L26.** The panel polynomials are Lagrange interpolants. **Confirmed.**
- **L27.** Heading ids {#case-1} to {#case-4} were added to the Case 1–4 headings. **Confirmed** (allowed change).

## 3. Checks

**The six points.** All six are present, and none of the excluded content (proofs, theorem boxes, the module's full set of examples, MATLAB procedures) appears.

| Point | Where on the page |
|---|---|
| Problem | Line 12 |
| Core formula | Display at lines 16–23, in page notation $h$, $f_k$, $M$ |
| Assumptions | Lines 25 and 27: n a multiple of M; $C^2/C^4/C^4/C^6$ smoothness |
| Accuracy | Lines 28–29: degree of precision and composite orders, as general results with hypotheses |
| Failure | Lines 31–37: non-smooth integrand linked to Cases 3 and 4, and negative weights at high M |
| Where it fits | Line 39 |

**Word count.**
- My script (wc.py, inline math = 1 word, display math removed) gives 399 tokens that contain letters or digits, matching the manifest's 399.
- Counting stray punctuation tokens as words gives 422.
- The text is within 150–400 under the manifest's convention, but at the ceiling.

**Consistency with the rest of the page.**
- The Description does not contradict the Derivation Notes: same degrees of precision and orders, and the "less robust at high degree" line is consistent with L23.
- It does not contradict the Case 3 Behavior: 1.25× Simpson 1/3; I computed 1.254–1.255 asymptotically.
- It does not contradict the Case 2 Behavior. Its errors at 41 points are 2.39e-3 and 8.26e-3, which agree with the stated 2.4e-3 and 8.3e-3.
- It does not contradict the Animations introduction.

**Links and anchors.**
- `#case-1`, `#case-3` and `#case-4` resolve to the explicit ids added at lines 45, 61 and 69.
- These sibling pages all exist with an `index.qmd`:
  - `../adaptive-simpsons-rule/`
  - `../trapezoidal-rule-for-numerical-integration/`
  - `../simpsons-rule-for-numerical-integration/`
  - `../simpsons-3-8-rule-for-numerical-integration/`
  - `../booles-rule/`
  - `../lagrange-polynomial-interpolation-and-approximation/`
  - `../romberg-integration/`
  - `../gauss-legendre-quadrature/`

**Scope of the diff.** Outside the Description, the only changes are:
- removing the three overview sentences from the Animations introduction, moved verbatim into the Description at lines 32–34;
- splitting the remaining introduction sentence onto its own line, with the same words;
- adding `{#case-N}` ids to the four case headings.

All of these are allowed. Legacy note, Derivation Notes, scripts and GIFs are unchanged.

**Frames.** I viewed the last frames of newtoncotescc and newtoncotesdd (121 sample points; values 2.01581 and 2.015961), which agree with my independent composite sums. The first-panel error is not visible at frame resolution; the page cites the cases only for the 121-point setting, which they show.
