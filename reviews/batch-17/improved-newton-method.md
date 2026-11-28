# Improved Newton Method — batch 17 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Review of `pages/numerical-methods/improved-newton-method/index.qmd`, light-pass batch 17, overview mode, action *extend*. EV = /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-17/improved-newton-method. The diff touches only index.qmd (no script or GIF changes), so the animations were not re-reviewed beyond checking the frames the new text points to. My scratch work is in EV/reviewer/check.py (Python, float64 replicas of the five scripts plus 60-digit mpmath versions). I did not run MATLAB or quarto, and I changed nothing in the repository. I consulted the Mathews archive (n2003/NewtonImprovedMod.html, read as text). Its example solutions are Mathematica output images, so I did not use them for numbers.

## Part 1: Findings

None.

Things I looked at that are not findings:
- **Method C claim with the expanded quartic (line 32).** "Method C picks m = 2 and m = 3 at each step" holds in exact arithmetic, and in float64 with the factored forms the Case 2 and Case 4 scripts use, for all three animated steps. If you run it in float64 on the *expanded* quartic, step 3 picks m = 1 instead, because of rounding noise. That is the same cancellation the page already describes on line 51 and in the Case 4 script comment. It is not a flaw in the claim.
- **Reuse of m on line 34.** Line 12 defines m as the multiplicity; line 34 uses it for the multiplier and introduces M for the true multiplicity. The sentence defines M, so it reads correctly.
- **Method B poles (line 35).** The sentence states the poles of u but not what they do to the iteration. It is true and matches Mathews (citing Ralston and Rabinowitz). A side fact I found: at x = −1 the Method B step is zero, so x = −1 is a fixed point, but a repelling one. Saying more would be a teaching suggestion, not a correction.

## Part 2: Claim ledger (diff + lines; no sentences were moved)

| # | Claim (page words, line) | Evidence | Verdict |
|---|---|---|---|
| L1 | Multiplicity m ≥ 2 means f = (x−x*)^m h with h(x*) ≠ 0, so f′(x*) = 0 (l.12) | For m ≥ 2, f′(x*) = lim (x−x*)^{m−1} h(x) = 0 when h is continuous. Matches Mathews' Definition 2. | confirmed |
| L2 | Standard Newton still converges from a close enough start, but only linearly, \|e_{n+1}\| ≈ (m−1)/m \|e_n\| (l.13) | e_{n+1} = e − e·h/(mh + e·h′) → (1 − 1/m)e when h is C¹. Matches Mathews Thm 1(7). | confirmed |
| L3 | Case 1 shows ratio 1/2; e_n/e_{n−1} reaches 0.50005 at the last frame (l.14) | Script replica (expanded f, float64): e10/e9 = 0.5000535; mpmath gives 0.50005354. Last frame is x₁₀ = 1.000321 (frame_011). | confirmed |
| L4 | Case 3 shows ratio 2/3; reaches 0.66680 at the last frame (l.14) | e12/e11 = 0.6668010 (float64 and mpmath). Last frame is x₁₂ = 1.002423 (frame_013). | confirmed |
| L5 | Method A multiplies the Newton step by the known m; display formula A (l.17, 20) | Same as newtonimpbb.jl / newtonimpdd.jl: `xs[i] - m*f/fp`. Matches Mathews eq. (8). | confirmed |
| L6 | Method B is Newton on u = f/f′, which has a simple root at x*; display formula B (l.17, 22) | u′ = (f′² − f f″)/f′², so x − u/u′ gives formula B. u = e·h/(mh + e·h′) and u′(x*) = 1/m ≠ 0, so the root is simple. Matches Mathews eq. (10). | confirmed |
| L7 | Method C definition: x_{n,m} = x_n − m f/f′ starting at m = 1, increase m while \|f(x_{n,m+1})\| < \|f(x_{n,m})\|, take the last such point (l.26) | Matches Mathews' adaptive line search (eqs. 13 and 21). | confirmed |
| L8 | All three need f′; B also needs f″; only A needs m in advance (l.27) | Read from the formulas. | confirmed |
| L9 | If h is C¹ near x* and x₀ is close enough, A converges at least quadratically, with e_{n+1}/e_n² → h′(x*)/(m h(x*)) (l.29) | Derived: e_{n+1} = e²h′/(mh + e·h′). The hypotheses are sufficient. "At least" covers h′(x*) = 0. | confirmed |
| L10 | B converges at least quadratically for smooth enough f (l.30) | Newton at a simple root of u. Mathews says the same. | confirmed |
| L11 | Cases 2 and 4: h(x) = x + 2 (l.31) | f = (x−1)²(x+2) and (x−1)³(x+2). | confirmed |
| L12 | e_n/e_{n−1}² reaches 0.16666 (Case 2) and 0.11111 (Case 4) at the last frame, against limits 1/6 and 1/9 (l.31) | Float64 replicas: 0.1666644 and 0.1111120; mpmath: 0.16666432 and 0.11111069. Limits are 1/(2·3) and 1/(3·3). The last frames are x₃ (4 frames each). | confirmed |
| L13 | On both functions Method C picks m = 2 and m = 3 at each step, reproducing A's iterates (l.32) | m = 2,2,2 and m = 3,3,3 on the 3 animated steps. Iterates match A to all digits: 1.0130434782608697, 1.0000281716593107, 1.000000000132272 and 1.0088235294117647, 1.0000086167279412, 1.0000000000082498. Same result in mpmath with expanded or factored f. Only caveat: float64 on the expanded quartic gives m = 1 at step 3 (rounding). | confirmed |
| L14 | Wrong multiplicity: A is at best linear, e_{n+1} ≈ (1 − m/M)e_n; m = 2 at the triple root gives 1/3; m > M overshoots to the other side (l.34) | Derived the limit. Computed m = 2 at the triple root: ratios 0.3529 … 0.333333. m = 3 at M = 2 and m = 4 at M = 3: error signs alternate. Matches Mathews ("shoot to the wrong side of p"). | confirmed |
| L15 | B's u has poles where f′ vanishes away from a root of f, e.g. x = −1 for Cases 1–2 (l.35) | f′(−1) = 0 and f(−1) = 4. Matches Mathews' Limitations section. | confirmed |
| L16 | On arctan x (simple root), A and C reduce to standard Newton and diverge from x₀ = 1.4, just past x_c ≈ 1.3917 (Case 5) (l.36) | x_c = 1.3917452 (root of 2x = (1+x²)arctan x). Method C keeps m = 1 on all 6 steps computed, with iterates −1.4136, 1.4501, −1.5506, 1.8471, −2.8936, 8.7103, identical to the standard Newton replica. Frames show the same divergence (labels −1.4136 … "8.71 (out of range)"). Consistent with Case 5 text (l.100–103). | confirmed |
| L17 | The animations show standard Newton and Method A; Case 5 also discusses B and C (l.37, kept) | Scripts aa, cc and ee are standard Newton; bb and dd are Method A; Case 5 text discusses B and C. | confirmed |
| L18 | Newton-Raphson page covers the standard iteration and its linear rate at multiple roots (l.39) | newton-raphson-method/index.qmd line 31 and Case 2. | confirmed |
| L19 | Accelerated and Modified Newton-Raphson treats Methods A and B on their own (l.39) | Its Description covers exactly A and B. | confirmed |
| L20 | Halley's Method also uses f″ and converges cubically at simple roots (l.39) | True. halleys-method/index.qmd says so. | confirmed |
| L21 | Heading ids {#case-1} … {#case-5} added (l.53, 63, 73, 83, 96) | Ledgered. Each Description link (#case-1 to #case-5) resolves to one of them. | confirmed |

## Part 3: Checks

**Six points of the standard**
1. Problem: line 12.
2. Core formula: display A and B (l.19–23), Method C's formula inline (l.26), all in the scripts' notation (x_n, m, f, f′).
3. Assumptions: the multiplicity definition, h C¹, a close enough x₀, needing f′ and f″, needing to know m.
4. Accuracy: linear (m−1)/m for standard Newton and the quadratic limit for A as general results with hypotheses, each pointed at cases whose computed ratios I confirmed (L3, L4, L12); B quadratic.
5. Failures: wrong multiplicity, B's poles, and the arctan poor start linked to Case 5.
6. Where it fits: line 39.

No theorem boxes, proofs or Mathematica procedures. All six points are present.

**Word count.** I recounted with the manifest's rule (inline math = 1 word, display math excluded): 54 inline math + 335 words = 389. That is inside 150–400, near the top.

**Links and anchors.** `#case-1` to `#case-5` match the explicit heading ids. `../newton-raphson-method/`, `../accelerated-and-modified-newton-raphson/` and `../halleys-method/` all exist with an index.qmd. No broken markup in the new LaTeX (`\tfrac`, `\bigl(…\bigr)`, `\text{A:}`; display math is in `$$`).

**Diff scope.** Outside the Description the only changes are the five `{#case-n}` heading ids, which the standard allows. No Behavior text, alt text, embeds or other sections changed. The old Description bullets were rewritten inside the Description; nothing moved out of the Animations introduction. The new Description contradicts nothing in the Animations intro (l.43–51), the Case 1–5 Behavior paragraphs, or line 51's statement that Method A with m = 2 at the triple root "converges only linearly" (consistent with the 1/3 ratio).

**Frames.** I viewed the last frames of newtonimpaa (x₁₀ = 1.000321) and newtonimpcc (x₁₂ = 1.002423), and the contact sheets of newtonimpdd (x₃ labelled 1.0) and newtonimpee (6 divergent steps). Every label agrees with my float64 replica of its script. Frame counts are 11, 4, 13, 4 and 7, which matches n_iters + 1 in each script.

**Fidelity.** Methods A, B and C, the poles caveat, the wrong-side overshoot and the order-of-root definition all match Mathews' module. The page's added C¹ hypothesis on h (Mathews only requires continuity) is what the stated limit constant needs.
