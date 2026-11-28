# False Position or Regula Falsi Method — batch 16 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/false-position-or-regula-falsi-method/index.qmd` (light-pass batch 16, overview page). Diff: one file, `index.qmd`. No script or GIF changed, so the animations were not re-reviewed beyond checking the cases the new text points to. I did not run MATLAB or quarto and changed nothing in the repository. My scratch files are in `/tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-16/false-position-or-regula-falsi-method/reviewer/` (`rf.py`, `x10.py`, `wc.py`, `thm.png`).

I read the Mathews archive: `n2003/RegulaFalsiMod.html`, plus the theorem images `n2003/regulafalsi/RegulaFalsiMod/Images/RegulaFalsiMod_gr_1..8.gif`, stitched together in `reviewer/thm.png`.

## 1. Findings

None.

Two observations that are not findings:
- The Description is at the top of its word limit. It has 398 words by the manifest's rule (inline math counts as one word). My raw token count was 413, but 15 of those tokens are punctuation left over when the inline math was removed. Excluding them gives 398, which is within 150–400.
- The x^10 − 1 example on [0, 1.3] has f''(0) = 0, so "f'' positive throughout [a, b]" holds only on (0, 1.3]. The page does not present this example as an instance of that hypothesis. The function is still strictly convex, and b = 1.3 stays fixed: I checked that the final b = 1.3 after 61 steps. So nothing on the page is false.

## 2. Claim ledger (the `+` lines of the diff and the moved sentence)

| # | Claim (page words) | Verdict | Evidence |
|---|---|---|---|
| L1 | The method solves f(x)=0 for a real root inside [a, b] on which f changes sign (l.12) | confirmed | Matches the method and Mathews' "Remember" note. |
| L2 | It keeps a sign-change bracket [a_n, b_n], starting from [a_1, b_1] = [a, b] (l.13) | confirmed | The scripts start with `as[1]=a0, bs[1]=b0`. The c_k index in the GIF legends matches (Case A c_2 = 0.833333). |
| L3 | c_n = (a_n f(b_n) − b_n f(a_n)) / (f(b_n) − f(a_n)), the x-intercept of the secant line (l.15–17) | confirmed | Same formula as both scripts and as Mathews' gr_5. Algebraically it is the zero of the chord. |
| L4 | If f(a_n) and f(c_n) have opposite signs, the next bracket is [a_n, c_n]; otherwise [c_n, b_n] (l.19) | confirmed | Same as the scripts' `if f(a)*f(c) < 0` branch. |
| L5 | The moved sentence: "Unlike bisection … weights the new point toward whichever endpoint has a smaller \|f\| value, often giving faster convergence — but one endpoint can remain fixed for many iterations." (l.20) | confirmed; moved verbatim | The diff removes it from the Animations intro (old l.13) word for word. c = (a\|f(b)\| + b\|f(a)\|)/(\|f(a)\|+\|f(b)\|) lies closer to the endpoint with the smaller \|f\|. "Often" is consistent with the slower x^10 example. |
| L6 | The method needs only f continuous on [a, b] with f(a) and f(b) of opposite signs (l.22) | confirmed | Mathews' hypotheses are f ∈ C[a,b], a zero r exists, and f(a), f(b) have opposite signs. The intermediate value theorem supplies r, so the two statements agree. |
| L7 | Mathews' theorem guarantees c_n converges to a zero x* in [a, b] (l.23) | confirmed | Mathews gr_6–gr_8 state lim c_n = r. This is the classical result. |
| L8 | With several zeros it finds one; a sign change across a discontinuity need not enclose a zero (l.24) | confirmed | Mathews lists both as "Limitations". Mathematically true. |
| L9 | If f'' > 0 throughout or f'' < 0 throughout, the same endpoint stays in the bracket at every step (l.27) | confirmed (general) | For convex f, the chord lies above the graph, so f(c) has the sign of the negative endpoint and that endpoint is the one replaced. For concave f the same holds with signs reversed. I checked all four sign/curvature combinations. |
| L10 | Convergence is then only linear: e_{n+1} ≈ C e_n with C = 1 − f'(x*)(b − x*)/f(b), 0 < C < 1, for b fixed; with a in place of b when a is fixed (l.28–34) | confirmed (general) | g(a) = (a f(b) − b f(a))/(f(b) − f(a)) gives g'(x*) = 1 − f'(x*)(b − x*)/f(b). Strict convexity gives f(b) > f'(x*)(b − x*) > 0, so 0 < C < 1. I also checked the concave case and the a-fixed variant. f'(x*) ≠ 0 follows from convexity plus the sign change. |
| L11 | Both animations have f convex and b fixed (l.35) | confirmed | Case A: f'' = 6x + 8 > 0 on [−1, 2]. Case B: f'' = cos x > 0 on [0, 1]. Computed b_n is 2.0 and 1.0 at every step. The frames show the right blue endpoint fixed in all 13 and 11 frames. |
| L12 | Case A error ratios settle at 0.2513, matching C (l.36) | confirmed | mpmath ratios: 0.3896, 0.2941, 0.2627, 0.2542, 0.2520, 0.25146, 0.25132, 0.25128, then 0.251271. C = 0.25127071. Float64 (the script's algorithm) gives 0.25127. |
| L13 | Case B ratios settle at 0.0501, matching C (l.36) | confirmed | Ratios: 0.05158, 0.05017, 0.05010, then 0.0500926. C = 0.05009256. Float64 gives 0.05009, with 0.05012 at the last step from rounding noise. |
| L14 | Both beat bisection's factor 1/2 (l.36) | confirmed | 0.2513 < 0.5 and 0.0501 < 0.5. |
| L15 | [Case A](#case-a) and [Case B](#case-b) links (l.36) | confirmed | Explicit ids `{#case-a}` and `{#case-b}` were added to the headings (l.50, l.58). |
| L16 | The bracket width does not go to zero; in Case A it stays above 2 − x* ≈ 0.6348 (l.39) | confirmed | x* = 1.365230013, so 2 − x* = 0.634770. All a_n < x* (errors negative), so the width 2 − a_n > 0.6348. |
| L17 | A stopping test must use \|c_n − c_{n−1}\| or \|f(c_n)\|, not the width (l.39) | confirmed | Follows from L16. |
| L18 | For x^10 − 1 on [0, 1.3], C ≈ 0.765 (l.40) | confirmed | C = 1 − 10(0.3)/12.7858 = 0.765366. Computed tail ratios are 0.765366. |
| L19 | Regula falsi needs 61 steps to get \|c_n − 1\| < 1e-6; bisection needs 20 (l.40) | confirmed | mpmath: RF reaches the target at step 61 (\|c_60 − 1\| = 1.13e-6, \|c_61 − 1\| = 8.7e-7). Bisection midpoint first reaches it at step 20 (9.5e-8), which is also the guaranteed half-width bound ⌈log2(1.3/2e-6)⌉ = 20. |
| L20 | Bisection keeps the same bracket but halves it; Secant uses the same formula on the two most recent iterates without a sign change, order about 1.618 at a simple root, no guarantee; Newton uses the tangent; Brent combines a bracket with interpolation and falls back on bisection (l.42) | confirmed | Standard results, correctly qualified ("at a simple root", "about"). |
| L21 | Links ../bisection-method/, ../secant-method/, ../newton-raphson-method/, ../brents-method/ (l.42) | confirmed | Each target `index.qmd` exists. The relative form matches the approved Newton-Raphson pilot. |
| L22 | The heading id additions `{#case-a}` and `{#case-b}` (diff lines in Animations) | confirmed | Allowed cross-reference edits; the heading text is unchanged. |

Consistency with the rest of the page: no contradictions. The Case A Behavior text ("b = 2 stays fixed", a = −1, 0, 0.8333, 1.2088, f convex) and the Case B Behavior text (b = 1 fixed, c = 0.6851, 0.7363, 0.7389, f convex, the bracket shrinks only on the left) agree with the Description and with my iterates. The c_n notation agrees with the GIF legends (c_k).

Fidelity: the formula, hypotheses and theorem agree with Mathews' RegulaFalsiMod. The Description adds the linear-rate result and the stopping-test caution, both correct. There is no departure that matters to a reader.

## 3. Checks

**The six points of the standard.**
1. The problem is stated (l.12).
2. The core formula is display math in the page's notation, a_n, b_n, c_n (l.15–17).
3. The assumptions are there: continuity and a sign change, with the caveats about multiple zeros and discontinuities (l.22–24).
4. Accuracy is stated as a general linear rate with its hypothesis (f'' of constant sign) and its constant C. It is checked against both cases, with links to them (l.26–36).
5. Two failure modes are given: the width does not shrink, which matters for the stopping test (shown in Case A), and C near 1 for strongly curved f (x^10 − 1) (l.38–40).
6. Where it fits: one sentence linking Bisection, Secant, Newton-Raphson and Brent (l.42).

All six are present and in order. The Description has no proofs, theorem boxes or callouts (`grep callout` returns 0).

**Word count.** 398 by the manifest's convention, within 150–400 (see the reconciliation in section 1).

**Links and anchors.** All four sibling pages exist. `#case-a` and `#case-b` are defined explicitly on the case headings.

**Scope of the diff.** It adds the Description (l.10–42), moves the one overview sentence verbatim out of the Animations intro, and adds the two heading ids. Nothing else changed. No scripts or GIFs changed (`git diff --stat 147040f` shows only index.qmd, 36+/3−).

**Independent computation.** I ran regula falsi in mpmath at 60 digits and in Float64 (the scripts' exact update rule) for Case A ([−1, 2], 12–13 iterates) and Case B ([0, 1], 10–11 iterates). I also ran regula falsi and bisection to 1e-6 for x^10 − 1 on [0, 1.3]. All numbers are listed in the ledger.

**Frames.** I viewed both contact sheets. In every frame the right endpoint is fixed at b = 2 (Case A) and b = 1 (Case B). The legend values match my iterates: Case A c_2 = 0.833333, c_4 = 1.324126, c_6 = 1.362597, c_8 = 1.365064, c_12 = 1.365229; Case B c_1 = 0.685073, c_2 = 0.736299, c_3 = 0.738945, c_4 = 0.739078, c_10 = 0.739085.
