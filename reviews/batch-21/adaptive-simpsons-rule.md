# Adaptive Simpson's Rule — batch 21 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: pages/numerical-methods/adaptive-simpsons-rule/index.qmd (light-pass batch 21, overview, action extend). EV = /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-21/adaptive-simpsons-rule. Scratch work: EV/reviewer/check.py. I ran Python only: no MATLAB, no quarto, no Julia, and no script runs. Nothing in the repository was modified.

Mathews archive consulted: yes. I read n2003/AdaptiveQuadMod.html as text and the subroutine image adaptivequad/AdaptiveQuadMod/Images/AdaptiveQuadMod_gr_2.gif. That image shows `Adapt[a,b,tol]`: c=(a+b)/2; if Abs[Sab-Sac-Scb] < tol return Sac+Scb, otherwise return Adapt[a,c,tol/2]+Adapt[c,b,tol/2]. The module text says "There is no brake available" and warns about infinite recursion.

## 1. Findings

None.

Two observations that are not findings:
- The paragraph explaining the /15 rule (the error term, the factor of 16, the /15 formula, and the tolerances summing to ε) is about three sentences. That is at the edge of "a one-line intuition", but it is not a proof and has no theorem box. I judge it within the standard.
- The Description quotes the routine's value 2.016273, while the GIF's "Approximation" reads 2.016252 (the composite S(a,b)). The two numbers do not contradict each other. The Description says "the routine's value", and the Case 1 Behavior paragraph already explains the difference.

## 2. Claim ledger (the + lines of the diff)

1. "approximates ∫_a^b f dx to a requested tolerance ε by recursively halving intervals until a local error estimate passes, so small subintervals appear only where f needs them." Confirmed. It matches Mathews' Adapt and the script.
2. S(a,b) = (b−a)/6 [f(a)+4f(m)+f(b)]. Confirmed. This is the script's `simpson(p,q)`.
3. "refinement compares S(a,b) against S(a,m)+S(m,b), which needs only two new values of f, at the quarter-points". Confirmed. The script draws exactly these two new points, (3p+q)/4 and (p+3q)/4, in blue.
4. "An accepted interval contributes S(a,m)+S(m,b) to the result." Confirmed. Mathews' code has Return[Sac+Scb].
5. The variant sentence (split off from an existing line, words unchanged): with 15ε it accepts 9 subintervals, the finest [0,1/32], instead of 20 with the finest [0,1/2048]. Confirmed: my recursion gives k=1: n=20, finest (0, 0.00048828125); k=15: n=9, finest (0, 0.03125).
6. "The test rests on a general result that needs f∈C⁴ on each interval." Confirmed. The hypothesis is the right one for Simpson's error term.
7. Simpson's error on width w is −w⁵/2880 f⁽⁴⁾(c). Confirmed: with h=w/2, −h⁵/90 f⁽⁴⁾ = −w⁵/2880 f⁽⁴⁾.
8. "halving the interval divides the error by about 16". Confirmed, given f⁽⁴⁾ nearly constant: 2·(w/2)⁵ = w⁵/16. The page states that condition in the same sentence.
9. ∫ − [S(a,m)+S(m,b)] ≈ (S(a,m)+S(m,b) − S(a,b))/15 if f⁽⁴⁾ is nearly constant. Confirmed: from E₂ = E₁/16, S₂ − S₁ = 15E₂.
10. "each accepted interval's error is below about ε_[a,b]/15". Confirmed under the stated assumption, since |S₂−S₁| < ε_[a,b].
11. "the accepted tolerances add up to exactly ε". Confirmed: the sum of accepted tolerances in Case 1 is 0.001 exactly, from dyadic halving.
12. "the total error is then at most about ε/15, an estimate rather than a guaranteed bound". Confirmed, and correctly labelled. In Case 1, total error / (ε/15) = −0.107.
13. "In Case 1 the routine's value 2.016273 is within 7.1×10⁻⁶ of the integral". Confirmed: recursive result R = 2.016272604; mpmath integral I = 2.0162797196; R − I = −7.116e−6.
14. "well inside ε=10⁻³". Confirmed.
15. "f is not C⁴ at x=0". Confirmed: f contains x^{2/3}.
16. "the error on [0,w] shrinks only like w^{5/3}". Confirmed. Errors of S(0,w/2)+S(w/2,w) for w = 2⁻⁴ … 2⁻¹³ have successive ratios 3.1806, 3.1778, …, 3.17483, which converge to 2^{5/3} = 3.17480.
17. "on [0,1/2048] it is about 7 times the estimate, yet under its tolerance". Confirmed: error 1.024e−7, estimate (S₂−S₁)/15 = 1.474e−8, ratio 6.95; tolerance 2.441e−7.
18. "The test sees only five values of f per interval and can be fooled." Confirmed: a, a+w/4, m, a+3w/4, b.
19. For sin²(4πx) on [0,1], all five samples are 0. Confirmed: in floating point they are ≤ 2.4e−31.
20. "the first test passes (at ε=10⁻³ or 10⁻⁶) and the routine returns 0 for an integral of 1/2". Confirmed: it accepts 1 interval at both tolerances and returns 8.0e−32; ∫₀¹ sin²(4πx) dx = 1/2.
21. "Mathews' routine also has no limit on the depth of recursion." Confirmed by the archive code and its "no brake" remark.
22. Step function (0 on [0,1/3), 1 on [1/3,1]): "the interval holding the jump fails the test at every level, since |S(a,m)+S(m,b)−S(a,b)| and the tolerance both shrink in proportion to its width". Confirmed analytically. With the jump at relative position 1/3 or 2/3 (1/3 is 0.0101… in binary, so it alternates between these), |S₂−S₁| = w/4 in both cases, while the tolerance is ε·w. The test fails for every ε < 1/4.
23. "the recursion stops at depth 54 only when a floating-point midpoint rounds onto an endpoint". Confirmed by simulation in IEEE doubles: max depth 54 (counting [0,1] as depth 0), and the result is 0.6666666666666667. The deepest accepted interval near 1/3 is (0.33333333333333326, 0.3333333333333333), one ulp (2⁻⁵⁴) wide. There c rounds to a, so Sac = 0, Scb = Sab, the difference is 0, and the test passes.
24. "Simpson's Rule applies the same formula with one fixed step size". Confirmed.
25. "adding the error estimate to S(a,m)+S(m,b) is one Richardson Extrapolation step and gives Boole's Rule on the interval, as in Romberg Integration". Confirmed with sympy: S₂ + (S₂−S₁)/15 − (2h/45)(7,32,12,32,7)·y with h=w/4 simplifies to 0. This is also Romberg's second column.
26. Heading id `{#case-1}` and link `[Case 1](#case-1)`. Confirmed: the explicit id matches the link.
27. The links ../simpsons-rule-for-numerical-integration/, ../richardson-extrapolation/, ../booles-rule/ and ../romberg-integration/ resolve. Confirmed: all four folders exist under pages/numerical-methods/.

Consistency with the rest of the page: confirmed.
- The Description's 2.016273 and its 20 subintervals with the finest [0,1/2048] agree with the Case 1 Behavior paragraph.
- The last frame (frame_021) shows Sample Points = 41, Approximation = 2.016252 and "Split [0, 1/1024]", which produces [0,1/2048].
- My recursive routine accepts the same 20 panels; their composite S(a,b) is 2.016252, matching the GIF.
- No contradiction with the Animations introduction or the Behavior paragraph.

## 3. Checks

**The six points:**
- Problem: the first sentence.
- Core formula: display math for S(a,b) and the acceptance test, in the script's notation.
- Assumptions: f ∈ C⁴ on each interval, and f⁽⁴⁾ nearly constant for the /15 estimate.
- Accuracy: error term, ε/15 estimate labelled as an estimate, and a pointer to Case 1 with checked numbers. The page also says honestly that the hypothesis fails at 0.
- Failure modes: sin²(4πx) fooling the test, and the step function with unbounded recursion. Neither is animated, which is acceptable; the standard only prefers animated cases.
- Where it fits: the last paragraph, with four links.

All six are present. No theorem boxes, no proofs, no Mathematica code.

**Word count:** 400 by my own count (inline math = 1 word, display math excluded, link text kept). That is at the upper limit and within 150–400.

**Links and anchors:** checked (ledger 26–27). Mechanical checks in the manifest: none found.

**Scope of the diff:** outside the Description, the only change is adding `{#case-1}` to the Case 1 heading, which is allowed. The variant sentence was split onto its own line with its words unchanged. No script or GIF changed, so the animations were not re-reviewed. I only viewed frame_021 to confirm the values the Description points to.

**Implementation checks:** not applicable (no script changed). My recursive implementation of Mathews' Adapt reproduces the script's final partition: 20 panels and 41 nodes.
