# Catenary — batch 19 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Review of `catenary` (light-pass batch 19, overview page). Page: /home/jason/Desktop/jasonhnicholson.com/pages/numerical-methods/catenary/index.qmd. Evidence folder: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-19/catenary. My checks are in /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-19/catenary/reviewer/chk.py, which uses sympy and mpmath. I did not run MATLAB, quarto or the page's script, and I did not modify the repository.

I consulted the Mathews archive: n2003/CatenaryMod.html, its Links pages lnk_2 to lnk_5, and the equation images gr_2 and gr_78.

## 1. Findings

None. Every claim in the new text checks out against my own computation, the frames, the script and the Mathews module.

Outside the scope of this diff, I noticed nothing to report. The Animations introduction says Exploration 2 is "Approximated by a parabola" and Exploration 3 is arc length. That matches the module's linked sub-pages (lnk_3 and lnk_4), even though the main module page numbers its sections differently.

## 2. Claim ledger (text added by the diff, Description lines 10–54, plus the heading id)

1. "A catenary is the curve of a flexible cable of uniform weight hanging from two supports." **Confirmed.** It matches the Mathews Background ("flexible cable of uniform density hanging from two points").
2. "Mathews writes it as y = c cosh(x/c) − c, c > 0" with its lowest point at the origin. **Confirmed.** Mathews image gr_2 reads "y = f(x) = c cosh(x/c) − c where c > 0". This is also script line 13.
3. "c is the ratio of the cable's horizontal tension to its weight per unit length." **Confirmed.** This is the standard H/w. It agrees with the Animations introduction.
4. The numerical questions are the parabola approximation, the cable's length and the fit for c. **Confirmed.** These are the module's three Explorations and Examples.
5. "The curve is even, and its Maclaurin series has only even powers." **Confirmed.**
6. The series x²/(2c) + x⁴/(24c³) + x⁶/(720c⁵) + ⋯ = Σ_{n≥1} x^{2n}/((2n)! c^{2n−1}). **Confirmed.** sympy's series to O(x⁹) gives x²/(2c) + x⁴/(24c³) + x⁶/(720c⁵) + x⁸/(40320c⁷). The general term matches this for n = 1 to 4.
7. "Its first term x²/(2c) is the parabola in the animation." **Confirmed.** This is script line 14, `y_par = x .^ 2 ./ (2c)`, and the legend in the frames.
8. "Since 1 + sinh²u = cosh²u, the arc length over [0, a] has a closed form", L = ∫₀ᵃ cosh(x/c) dx = c sinh(a/c). **Confirmed.** sympy gives 1 + (y′)² − cosh²(x/c) = 0, and ∫₀ˣ cosh(t/c) dt = c sinh(x/c).
9. The catenary through (±a, b) satisfies c cosh(a/c) − c = b. **Confirmed.** It follows from the form of the curve and matches Mathews image gr_78, "c Cosh[a/c] − c = b".
10. "The model assumes a perfectly flexible cable, uniform in weight per unit length, loaded only by gravity and its supports." **Confirmed.** These are the standard hypotheses.
11. "Balancing forces … gives y″ = √(1 + (y′)²)/c, and the catenary is its solution with y(0) = y′(0) = 0." **Confirmed.** sympy gives y″ − √(1 + y′²)/c = 0 identically for y = c cosh(x/c) − c, and y(0) = y′(0) = 0 holds.
12. "Because the fourth derivative of cosh is cosh, Taylor's theorem bounds the gap for every x ≠ 0": x⁴/(24c³) ≤ gap ≤ x⁴/(24c³)·cosh(x/c). **Confirmed** as a general result. The x³ coefficient is zero, so the Lagrange remainder of the cubic Taylor polynomial is cosh(ξ/c)·x⁴/(24c³) with ξ between 0 and x. Since 1 ≤ cosh(ξ/c) ≤ cosh(x/c), both bounds hold for either sign of x by evenness. The numeric check at x = 4, 2, 1 with c = 4 is in item 16.
13. "So the catenary lies above the parabola." **Confirmed.** The lower bound is positive for x ≠ 0. This agrees with the Behavior paragraph.
14. The gap is "O(x⁴) as x → 0", and relative to the parabola it is "about x²/(12c²), which depends only on x/c". **Confirmed.** (x⁴/(24c³))/(x²/(2c)) = x²/(12c²) = (x/c)²/12. Numerically, the relative gap at x = 1, c = 4 is 0.005219, against 0.005208 from the formula.
15. "The parabola is good where |x| is small compared with c: a taut cable, or a slack one near its lowest point." **Confirmed.** This follows from item 14 and is consistent with the Behavior paragraph.
16. In the last frame of Case 1 (c = 4), "the gap at the window's edge x = 4 is 0.172, between the bounds 0.167 and 0.257; halving x to 2 and then 1 divides it by 16.4 and 16.1, the x⁴ rate." **Confirmed.**
    - The last frame's title reads c = 4.0, which matches `c_values` ending at 4.0, and xlims are ±4.
    - mpmath gives gap(4) = 0.172323, with bounds 0.166667 and 0.257180.
    - gap(2) = 0.0105039 and gap(1) = 0.000652400.
    - The ratios are 16.4056 and 16.1004.
    - In frame_025 the catenary visibly ends about 0.17 above the parabola at x = ±4.
17. "For a slack cable the parabola misleads: in the first frame of Case 1, c = 0.5, the catenary is already 38% above it at x = 1 (1.381 against 1)." **Confirmed.**
    - frame_001's title reads c = 0.5.
    - The catenary is 1.381098 and the parabola is 1.0 at x = 1, a ratio of 1.3811, which is 38% above.
    - The frame shows a large separation at |x| = 1.
18. "A cable carrying weight uniform per horizontal distance satisfies y″ = 1/c and hangs exactly in y = x²/(2c)." **Confirmed.** With c = H/w and w per horizontal length, the force balance gives H y″ = w. Integrating twice with y(0) = y′(0) = 0 gives x²/(2c).
19. "Mathematica cannot solve the fit equation for c analytically, Mathews notes, so c is found numerically." **Confirmed** against the module's Exploration 3 (Catenary Fit) text. The analytical-solvability part is a quote of Mathews, which I did not independently test.
20. "Its left side falls strictly from ∞ to 0 as c grows, so it has exactly one root for every a, b > 0, which a bracketing method can find." **Confirmed** as a general result.
    - With t = a/c, the derivative d/dc[c cosh(a/c) − c] equals cosh t − 1 − t sinh t. This is 0 at t = 0, and its t-derivative is −t cosh t < 0, so it is negative for every c > 0.
    - The left side tends to ∞ as c → 0⁺ and behaves like a²/(2c) → 0 as c → ∞.
    - Numerically, with a = 1, the left side goes from 1.3e41 at c = 0.01 to 5.0e−5 at c = 1e4, and the derivative is negative throughout.
21. The series is the Maclaurin and Taylor Series applied to cosh; Bisection or Newton-Raphson solves the fit equation; Simpson's Rule approximates the arc length integral "as in Mathews' Example 1, with c sinh(a/c) as a check". **Confirmed.**
    - Mathews lnk_5 (Example 1, a = 10, b = 6) says the length "can be approximated numerically by using Simpson's rule", then remarks that it can be computed analytically.
    - All four linked pages exist: ../maclaurin-and-taylor-series/, ../bisection-method/, ../newton-raphson-method/ and ../simpsons-rule-for-numerical-integration/ each have an index.qmd.
22. The heading id `{#case-1}` was added to "### Case 1 — Catenary vs parabola approximation as $c$ varies", and the link `[Case 1](#case-1)` is on line 46. **Confirmed.** The id and the link match, and the syntax is the same as the approved Newton-Raphson pilot page (`{#case-1}` on a heading containing math).

## 3. Checks

**Six points of the overview standard.** All present, in order:
1. The problem: lines 12–20.
2. The core formula as display math, in the script's notation `c*cosh(x/c) - c` and `x^2/(2c)`: lines 15–33.
3. What it assumes: lines 35–36. The parabola's validity condition, |x| ≪ c, is on line 45.
4. How accurate it is: lines 38–46. This is a general Taylor bound with its condition, pointed at Case 1 and checked on the case's own values (item 16).
5. When it fails or misleads: lines 48–51. These cover the slack cable in the first frame of Case 1, the different load model, and the need for a numerical solution of the fit.
6. Where it fits: line 53.

There are no proofs, theorem or definition callouts, or Mathematica or MATLAB procedures. The force balance on line 36 is a one-line intuition, which the standard allows.

**Word count.** I recounted lines 12–53 with display math removed, inline math counted as one word and link text kept: 392 words. This agrees with the manifest and is within the 150–400 range.

**Consistency with the rest of the page.**
- The Animations introduction gives the same meaning of c and the same "first nonzero Maclaurin term" as the Description.
- The Behavior paragraph says "never lies below the parabola" and "taut/slack", which agrees with items 13 and 15. Its figure of a gap of 0.1 at |x| ≈ 0.73 for c = 0.5 is compatible with a gap of 0.381 at x = 1.
- I found no contradictions.

**Links and anchors.** The four relative page links resolve to existing pages, and `#case-1` matches the explicit heading id (item 22). The manifest's mechanical checks found nothing.

**Scope of the diff.**
- Only index.qmd changed. The diff adds the `## Description` section (lines 10–54) and the `{#case-1}` heading id. Both are allowed.
- No script or GIF changed, so the animation was not re-reviewed.
- As spot checks for the claims above, I confirmed from script lines 9–14 that c runs over range(0.5, 4.0, length=25), x over ±4, and the plotted parabola is x²/(2c). I viewed the first frame (c = 0.5) and the last frame (c = 4.0); 25 frames were extracted, matching length=25.
- The Animations introduction still holds the sentence "The catenary is the curve formed by … first nonzero term of its Maclaurin series", which overlaps the Description. The standard allows moving it but does not require it, so this is not a finding.
