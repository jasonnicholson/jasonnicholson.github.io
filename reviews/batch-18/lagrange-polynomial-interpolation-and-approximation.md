# Lagrange Polynomial Interpolation and Approximation — batch 18 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Overview review of `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/index.qmd` (light-pass batch 18, action *extend*). The diff changes only `index.qmd`. No script or GIF changed, so the animations are not under review. I did not run MATLAB or quarto, and I modified nothing in the repository. Scratch work is in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-18/lagrange-polynomial-interpolation-and-approximation/reviewer/` (`chk.py`, `bary2.py`, `thm.png`, `thm2.png`).

I consulted the Mathews archive: `n2003/LagrangePolyMod.html` and its formula images `LagrangePolyMod_gr_10…27` and `gr_40…59`.

## 1. Findings

**F1 (Page text, Minor).** Line 36: "the error falls to $0.135$ at degree 7 and then grows, to $0.485$ in the frame titled degree 15".
- **What is wrong:** The sentence is careful at degree 15 ("the frame titled degree 15") but not at degree 7. Case 08 has an even f and symmetric nodes. As the Animations introduction itself says, its interpolants have only even powers, so the 8-node interpolant has actual degree 6, not 7. The value 0.135 is right (0.135063, maximum at x = ±0.898).
- **Evidence:** `chk.py`, which uses 60-digit mpmath Lagrange evaluation on a 2001-point grid over [−1, 1].
- **Suggested fix:** "falls to $0.135$ in the frame titled degree 7", or "at 8 nodes".

## 2. Claim ledger (the + lines of the diff, and the moved sentences)

1. L12: the problem is n+1 points with distinct nodes and a polynomial of degree ≤ n through them. **Confirmed.**
2. L13: that polynomial exists and is unique, and is used to approximate f when y_i = f(x_i). **Confirmed** (standard; matches Mathews' theorem).
3. L21: each L_i is 1 at x_i and 0 at the other nodes, so P_n(x_j) = y_j. **Confirmed** from the L_i formula.
4. L22: the animations evaluate P_n in the first barycentric form ℓ(x)Σ w_i y_i/(x−x_i), with the stated ℓ and w_i. **Confirmed** against script lines 120–149 (`barycentric_weights`, `barycentric_eval`: s += w*y/(x−x_j), l *= (x−x_j), return l*s). The words are unchanged from the old Description; it is a move inside the Description.
5. L23 (moved, unchanged): the first form stays accurate far outside the nodes, and the second form gives wrong-sign values in Cases 04 and 29. **Confirmed** with `bary2.py` on the script's 1000-point plot grid, compared with mpmath exact values:
   - Case 04: the second form gives wrong-sign values at 103 points (degree 13) and 93 points (degree 15).
   - Case 29: it gives wrong-sign values at 34 points (degree 13) and 341 points (degree 15).
   - The first form gives no wrong-sign values in either case. Its worst relative error is 7.1e-11 (Case 04) and 6.1e-8 (Case 29).
6. L25: building P_n needs only distinct nodes; bounding its error needs a smooth f. **Confirmed.**
7. L26–30: Mathews' theorem — if f ∈ C^{n+1}[a,b] and the nodes lie in [a,b], then for each x ∈ [a,b] there is c ∈ [a,b] with error f^{(n+1)}(c)/(n+1)! · Π(x−x_i). **Confirmed.** It matches the Mathews module images gr_10, 11, 13 and 23–25 (f ∈ C^{n+1}[a,b], x_k ∈ [a,b], R_n with c = c(x) in [a,b]). The hypotheses are complete; distinctness is stated in L12.
8. L32: for fixed n and equally spaced nodes, the error on [x_0, x_n] is O(h^{n+1}). **Confirmed** as a general result: it follows from the theorem under its C^{n+1} hypothesis ("therefore"). Numerical check on e^x: halving h gives error ratios 4.10 (n = 1), 8.47 (n = 2) and 17.45 (n = 3), tending to 2^{n+1}.
9. L32: for n = 1 the error is at most h² max|f''|/8. **Confirmed.** It matches Mathews' equally-spaced theorem (i), M₂h²/8 (gr_45–47), and holds numerically, for example 8.71e-4 ≤ 8.93e-4 at h = 0.05.
10. L33: raising n on a fixed interval need not help. **Confirmed** by Case 08 (item 13).
11. L34: Case 15 is e^x on [−2, 3]. **Confirmed** against script line 51: auto_span over xlims (−2, 3), with f finite throughout, so the nodes span [−2, 3].
12. L34: the largest error on the node interval falls from 9.65 at degree 1 to 3.05e-10 at degree 15. **Confirmed.**
    - Computed values: 9.6468 at degree 1 and 3.05228e-10 at degree 15. The fall is monotone across all 10 frames.
    - Float64 rounding (about 20·eps ≈ 4e-15) is negligible at this size.
    - In the frames (sheet.png), the degree-1 chord sits well above eˣ; from degree 5 on the two curves are indistinguishable.
13. L36: Case 08 is 1/(1+10x²) on [−1, 1], smooth on the whole real line. **Confirmed.** Its poles are at ±i/√10, which is non-real.
14. L36: the error falls to 0.135 at degree 7 and grows to 0.485 in the frame titled degree 15. **Confirmed.**
    - Errors by frame: 0.909, 0.488, 0.478, 0.315, 0.203, **0.135** (degree 7), 0.173, 0.236, 0.334, **0.4849** (titled degree 15).
    - In frame_010 the interpolant peaks near 0.58 at x ≈ ±0.96, where f ≈ 0.097.
    - Caveat: "degree 7" is the frame title; see F1.
15. L36: the oscillations are next to the end nodes (Runge's phenomenon). **Confirmed.** The largest error is at x = ±0.963, and frame_006 and frame_010 show it. This is genuine Runge divergence: the poles at ±0.316i lie inside the equispaced convergence contour (which crosses the imaginary axis at about ±0.526i).
16. L37: in Case 04, √x is not in C¹[0, 2]. **Confirmed**: f′ is unbounded at 0.
17. L37: the largest error on [0, 2] falls only to 0.0485 at degree 15, next to x = 0. **Confirmed.**
    - The errors fall monotonically: 0.354, 0.201, 0.148, 0.119, 0.102, 0.081, 0.068, 0.059, 0.053, 0.0485.
    - At degree 15 the maximum is at x = 0.011.
18. L38: outside [a, b] the theorem says nothing. **Confirmed** as a statement about the theorem as quoted, whose x is in [a, b].
19. L38: in Case 04 at degree 15 the interpolant is about 64.5 at x = 2.5, while √2.5 ≈ 1.58. **Confirmed**: P(2.5) = 64.5416 and √2.5 = 1.58114. In frame_010 of lagnewt04 the curve visibly leaves the window (y up to 4) just past x = 2. The number itself is off-scale, which is consistent with the Animations introduction.
20. L40: Newton builds the same polynomial from divided differences, Neville evaluates it at a point, Hermite also matches slopes, Chebyshev nodes avoid Runge's phenomenon, and cubic splines use cubic pieces. **Confirmed.**
    - All five target folders exist.
    - The Neville page (line 12) and the Chebyshev page (line 14, "remedy for Runge-type endpoint blow-up") agree with the descriptions.
21. Heading ids `{#case-4}`, `{#case-8}`, `{#case-15}` (L62, L78, L112). **Confirmed.** These are the only changes inside the Animations sections, and the links `#case-4`, `#case-8` and `#case-15` match them.

## 3. Checks

**The six points of the overview standard:**
1. The problem: L12–13. **Present.**
2. The core formula: the display at L16–19, plus the barycentric form the script uses (L22). **Present.**
3. What it assumes: distinct nodes, and C^{n+1} for the error bound (L12, L25–26). **Present.**
4. How accurate it is: the error theorem, the general O(h^{n+1}) result, the n = 1 bound, and Case 15 pointed to with computed values. **Present.**
5. When it fails or misleads: Runge (Case 08), a non-smooth f (Case 04) and extrapolation (Case 04), each linked. **Present.**
6. Where it fits: L40. **Present.**

**Limits:**
- Word count: I get 397 prose words over L10–43, counting inline math as one word and leaving out standalone punctuation tokens. This matches the manifest and is at the top of the 150–400 range. Without the pre-existing case-ordering paragraph (L42) it is 343.
- There are no callout or theorem boxes and no proofs. The theorem is quoted in a single line with display math, which the standard allows.

**Links and anchors:**
- All 5 relative page links resolve to existing folders.
- All 3 case anchors match explicit heading ids.
- The manifest's mechanical checks found nothing.

**Scope of the diff:**
- Inside the Description: the old first sentence ("builds a unique polynomial of degree at most n through n+1 data points") was replaced by L12–13 with the same content. The two barycentric sentences moved down with their words unchanged.
- Outside the Description: only the three `{#case-N}` heading ids changed. This is allowed.
- No script or GIF changed.

**Consistency with the rest of the page:** I found no contradiction with the Animations introduction or the case notes. The Animations introduction's note that symmetric even cases have lower actual degree is the convention behind F1.

**Fidelity:** The theorem hypotheses and the n = 1 bound match the Mathews module. The page departs from the module nowhere.
