# Rational Approximation — batch 19 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/rational-approximation/index.qmd` (light-pass batch 19, overview, action *extend*). The diff changes only `index.qmd`: 35 lines added and 5 removed. No script or GIF changed, so the animation is not under review. I consulted the Mathews archive, `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/RationalApproxMod.html` and its images `_gr_5`, `_gr_6` and `_gr_8`. I did not run MATLAB or quarto, and I changed nothing in the repository. Scratch scripts are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-19/rational-approximation/reviewer/` (`check.py`, `errform.py`).

## 1. Findings

**F1: Page text, Minor. The normalisation Q_n(0)=1 is used without saying it needs Q(0)≠0.**
- **Location:** index.qmd line 15, `R_{m,n}(x)=…=\frac{a_0+…}{1+b_1x+\cdots+b_nx^n}`, read together with line 12 ("on an interval $[a,b]$") and the general alternation theorem on line 45.
- **What is there now:** The page defines R_{m,n} on a general [a,b] with Q's constant term fixed at 1. It then states the existence, uniqueness and alternation theorem for "the best approximation" in that class.
- **What is true instead:** Fixing the constant term at 1 loses no generality only if the best denominator has Q(0)≠0.
  - That always holds when 0 ∈ [a,b], because Q cannot vanish on the interval. So it holds for every case on this page, all on [-1,1].
  - For an interval that excludes 0, for example [1,2], the full class contains quotients with Q(0)=0 that the normalised form cannot write, such as 1/x. The theorem is about the full class.
- **How I know:** By reasoning. Mathews uses the same normalisation (image `_gr_8`: 1+q₁x+…+q_mx^m), so this is not a fidelity departure. The effect is small: rescaling to [-1,1] is the usual practice, and nothing on the page uses an interval without 0.
- **Suggested correction:** Add a clause on line 19, for example "Fixing the constant term of $Q_n$ at 1 (possible whenever $Q_n(0)\neq0$, as on any interval containing 0) leaves…". Alternatively, say the interval is taken as [-1,1] after rescaling.

No other findings.

## 2. Claim ledger (the + lines of the diff)

1. **L12:** R represents f on [a,b] by a quotient of polynomials. Confirmed.
2. **L15:** R_{m,n}=P_m/Q_n=(a₀+…+a_mx^m)/(1+b₁x+…+b_nx^n), with Q_n≠0. Confirmed: it matches the script's [2/2] form (script lines 14–21) and Mathews' normalisation q₀=1. See F1 for its generality.
3. **L18:** "written [m/n] in the animation". Confirmed: every frame title reads "Rational [2/2] …".
4. **L19:** a normalised Q leaves m+n+1 coefficients. Confirmed: (m+1)+n.
5. **L21:** Mathews compares three constructions. Confirmed: this is the original sentence, unchanged and split from the MinMax sentence. Archive Example 1 parts (a), (b) and (c) match.
6. **L22:** interpolation takes m+n+1 nodes x₀…x_{m+n} and requires R(x_k)=f(x_k). Confirmed: the script uses 5 nodes for [2/2].
7. **L23–26:** multiplying by Q gives the linear system P_m(x_k)=f(x_k)Q_n(x_k). Confirmed: `fit_rational_interp` (lines 24–37) builds exactly this system.
8. **L29–32:** MinMax minimises the maximum relative error. Confirmed: this is the original text, and the script's Remez solves P = f(1 − s_iE)Q.
9. **L35:** the relative error needs f≠0 on [a,b]. Confirmed.
10. **L37–41:** if f∈C^{m+n+1} and Q_n(x)≠0, then fQ−P vanishes at the nodes and f−R = (fQ)^{(m+n+1)}(ξ)/((m+n+1)! Q(x)) · ∏(x−x_k). Confirmed.
    - Why it holds: P has degree m < m+n+1, so its derivative of that order is 0, and the zero polynomial interpolates g=fQ−P at the m+n+1 nodes.
    - Numerical check on the equal-node case (`errform.py`): at x = −0.9, −0.3, 0.25, 0.82 and 0.95, the implied (fQ)^{(5)}(ξ) was 0.105, 0.139, 0.184, 0.247 and 0.264. All lie inside the range of (fQ)^{(5)} on [-1,1], which is [−0.037, 1.443].
11. **L43:** on [-1,1], Chebyshev nodes minimise the maximum of the product, to 2^{-(m+n)}. Confirmed: the monic T₅/2⁴ gives 1/16 = 0.0625, and the computed maximum was 0.0625000.
12. **L44:** in Case 1, the product's maximum is 0.113 for equal nodes. Confirmed: 0.113482, at x≈±0.822.
13. **L44:** the product's maximum is 0.0625 for Chebyshev nodes. Confirmed.
14. **L44:** the maximum relative error falls "by a similar factor", from 1.59e-4 to 8.94e-5. Confirmed: the errors are 1.59366e-4 (at x=0.8244) and 8.94192e-5 (at x=−1). Their ratio is 1.782, against 1.816 for the products.
15. **L44:** the link `[Case 1](#case-1)`. Confirmed: the heading on line 63 carries `{#case-1}`.
16. **L45:** the alternation theorem, part 1. For positive continuous f, the best relative-error approximation exists and is unique. Confirmed as the standard result (Achieser/Rice) for weighted Chebyshev rational approximation with continuous positive weight 1/f, for the full class (see F1).
17. **L45:** the alternation theorem, part 2. When P/Q is in lowest terms and P or Q has full degree, the error alternates at no fewer than m+n+2 points. Confirmed: defect d = min(m−∂P, n−∂Q) = 0, so there are m+n+2−d = m+n+2 points.
18. **L46:** the Remez exchange algorithm finds the best approximation. Confirmed: the script's `remez_minimax` performs a Remez exchange (lines 57–131).
19. **L46:** the last frame shows six equal peaks for [2/2]. Confirmed: frame_003 shows six peaks of |relative error| at the same height, about 8.7e-5. In my independent mpmath Remez, E = 8.67979e-5 and the signs alternate, −, +, −, +, −, +.
20. **L46:** the peaks are at x = −1, ±0.812, ±0.312, 1. Confirmed: −1, −0.812304, −0.312415, 0.312415, 0.812304, 1.
21. **L48–49:** the linear system can be singular, and an interpolant need not exist. Confirmed.
22. **L49:** no R_{1,1} matches x² at −1, 0, 1, because a₀=0, a₁=1+b₁ and a₁=b₁−1 conflict. Confirmed. I redid the algebra, and also checked the unnormalised Q=b₁x, which makes R constant, so the conclusion holds with no normalisation at all.
23. **L50:** nothing keeps Q from vanishing in [a,b], and a zero there gives a pole, so Q must be checked. Confirmed.
24. **L50:** in Case 1, Q₂(x) ≥ 0.58 on [-1,1] for all three approximants. Confirmed: the minima, all at x=1, are 0.581781 (equal nodes), 0.581814 (Chebyshev) and 0.581807 (minimax).
25. **L52:** Padé builds R from the Maclaurin series, so its error grows away from 0. Confirmed: this agrees with Mathews' background text, and the relative error is 0 at x=0, with its maximum at the endpoint x=−1.
26. **L52:** the [2/2] Padé approximant of e^x, (1+x/2+x²/12)/(1−x/2+x²/12), has maximum relative error 1.47e-3 on [-1,1]. Confirmed: 1.47225e-3.
27. **L52:** that is "about 17 times the MinMax value". Confirmed: 1.47225e-3 / 8.67979e-5 = 16.96.
28. **L52:** the links ../pade-approximation/, ../maclaurin-and-taylor-series/, ../lagrange-polynomial-interpolation-and-approximation/ and ../chebyshev-approximation-polynomial/. Confirmed: each folder has an index.qmd.
29. **L63:** the only change outside the Description is the `{#case-1}` id on the Case 1 heading. Confirmed: this edit is allowed.

The Behavior paragraph (line 65) is unchanged. It is consistent with the new text: 1.59e-4, 8.94e-5, 8.68e-5, the six points, and the maximum near ±0.82, where I computed 0.8244.

## 3. Checks

**The six points of the overview standard:**
1. The problem (L12): present.
2. The core formula (L15, L26, L32): present, in the script's notation.
3. What it assumes (Q≠0, f≠0, f∈C^{m+n+1}, positive continuous f): present.
4. How accurate it is (the general interpolation error formula, Chebyshev node optimality, and the alternation theorem, all checked on Case 1): present.
5. When it fails (the singular or inconsistent system with a concrete example, and poles from Q): present. The Case 1 animation shows no failure, so the absence of a link to a case is correct.
6. Where it fits (Padé, Maclaurin, Lagrange, Chebyshev): present.

**Word count and limits:**
- The manifest reports 370 words. My rough count, with links reduced to their text, is about 387 because I tokenised numbers differently. Both are within 150–400.
- There are no proofs or callout boxes. The one-line justification of the error formula is within the allowed "one-line intuition".

**Links and anchors:** `#case-1` resolves to the explicit id on line 63, and all four cross-page links resolve to existing pages.

**Scope of the diff:**
- The only change outside the Description is the heading id, which is allowed.
- The sentence "Mathews compares three constructions…" is unchanged and only split from the MinMax sentence, which also keeps its wording.
- No script or GIF is changed.

**Independent computation:**
- In mpmath at 30 digits, I solved the 5×5 interpolation systems for equal nodes and for Chebyshev nodes cos((2k−1)π/10).
- I ran my own Remez, solving the reference system with findroot and finding extrema by locating where the derivative is zero.
- I evaluated on a grid of 20001 points.
- All the numbers are listed in the ledger above. I did not run the page's script, since its outputs were not under review.
