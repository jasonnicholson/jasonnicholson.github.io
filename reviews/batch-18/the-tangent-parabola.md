# The Tangent Parabola — batch 18 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Review of `the-tangent-parabola` (light-pass batch 18, overview page, action *write*). Page: /home/jason/Desktop/jasonhnicholson.com/pages/numerical-methods/the-tangent-parabola/index.qmd. Diff: EV/diff.patch (index.qmd only; no script or GIF changed, so the animation was not re-reviewed beyond checking what the new text cites). I did not run MATLAB or quarto, changed nothing in the repository, and ran no git commands. I consulted the Mathews archive (n2003/TangentParabolaMod.html, read as text, plus its formula images gr_171, gr_174, gr_177 and its Table 1 image gr_119). Scratch files are in EV/reviewer/: chk.py, wc.py, mathews.png and titles.png.

## 1. Findings

None.

I found no Error or Misleading issue in the added text, and no Minor breach of the standard. Every number on the page agrees with my own computation at the precision it is stated to. Every general result carries a hypothesis that is enough for it, and I confirmed it on Case 1's own values. The only change outside the Description is the heading id `{#case-1}`, which the standard allows.

## 2. Claim ledger (the + lines of the diff)

Description (lines 10–55):

1. "the parabola that matches a function f and its first two derivatives at a single point x0". **Confirmed.** By definition T2 matches f, f′ and f″ at x0.
2. "The secant line through two points … tends to the tangent line as the points merge". **Confirmed.** This is the standard result for differentiable f, and it is Mathews' Background section.
3. The secant parabola through x0−h, x0, x0+h is "the Newton interpolating polynomial of degree 2", and P_h(x) is the displayed centred formula. **Confirmed.** sympy shows that the script's divided-difference Newton form, with nodes in the order x0−h, x0, x0+h, minus the page's centred form is identically 0. The formula is also Mathews' formula (4), seen in image gr_78 and the next image.
4. "As h→0 the two difference quotients tend to f′(x0) and ½f″(x0)", and the limit is T2 as displayed. **Confirmed.** The sympy series give cos1 − h²cos1/6 + … and −sin1/2 + h²sin1/24 + …. T2 is the same formula as the script's `T2`.
5. "The limit needs only that f″(x0) exists." **Confirmed** as a general result. The first quotient needs only f′(x0). For the second, if f″(x0) exists then f′ exists near x0, and the Peano form of the remainder gives the second-difference limit f″(x0).
6. If f∈C³ on an interval containing x and the three nodes, "Mathews gives the interpolation remainder" (x−x0+h)(x−x0)(x−x0−h)/3!·f‴(c). **Confirmed.** This is the standard degree-2 Lagrange remainder, and it matches Mathews' image gr_171 exactly. The hypothesis is sufficient.
7. Letting h→0 gives the Taylor remainder f‴(c)(x−x0)³/3!, so the error of T2 is O(|x−x0|³) near x0. **Confirmed.** This is Mathews' gr_177. Under C³, f‴ is bounded near x0, so the O-claim holds.
8. If f∈C⁴, the coefficient errors are h²f‴(ξ)/6 and h²f⁽⁴⁾(η)/24, so the coefficients converge at rate O(h²). **Confirmed**, including signs. The series give −h²cos1/6 = h²f‴(1)/6 and +h²sin1/24 = h²f⁽⁴⁾(1)/24. The predicted values match the computed errors: h=0.1 gives −9.005e-4 and 3.506e-4, and h=0.01 gives −9.005e-6 and 3.506e-6. C⁴ is more than the first coefficient needs, which is harmless.
9. "[Case 1](#case-1), with f(x)=sin(x) and x0=1, shows this: each tenfold cut in h cuts both coefficient errors about a hundredfold." **Confirmed.** The first-coefficient errors fall from 8.565e-2 to 9.0005e-4 to 9.005e-6, ratios of 95 and 100. The second-coefficient errors fall from 3.391e-2 to 3.505e-4 to 3.506e-6, ratios of 97 and 100. Case 1 is sin(x) at x0=1 in the script.
10. Table row h=1: 0.454649, −8.57e-2, −0.386822, 3.39e-2. **Confirmed.** mpmath gives 0.45464871, −0.085653592, −0.38682227 and 0.033913221. Mathews' Table 1 gives the same coefficients.
11. Table row h=0.1: 0.539402, −9.00e-4, −0.420385, 3.50e-4. **Confirmed.** mpmath gives 0.53940225, −9.000537e-4, −0.4203850 and 3.5049606e-4; 3.50496 rounds to 3.50. Mathews' table agrees.
12. Table row h=0.01: 0.540293, −9.00e-6, −0.420732, 3.51e-6. **Confirmed.** mpmath gives 0.5402933, −9.0049934e-6, −0.42073199 and 3.5061174e-6. Mathews' table agrees.
13. Table row T2: 0.540302, −0.420735. **Confirmed.** cos1 = 0.5403023 and −sin1/2 = −0.4207355.
14. "Each error is the coefficient minus its value in the T2 row". **Confirmed.** The signs are consistent with that definition. "The first three rows are frames of Case 1" is also **confirmed**. The script's h = exp(range(log 1, log 0.01, length 17)) gives exactly 1, 0.1 and 0.01 at indices 1, 9 and 17. The titles of frames 1, 9 and 17 read h = 1.0, 0.1 and 0.01 (titles.png).
15. "within |x−1|≤0.3 its [T2's] error is at most 0.0027, about ten times smaller than the h=1 secant parabola's 0.026". **Confirmed.** On a 200001-point grid of [0, π], T2's maximum error there is 0.0027033 and P_1's is 0.026044, a ratio of 9.6.
16. "over the whole window [0, π] its error reaches 0.120 at x=0, against 0.072 for that secant parabola". **Confirmed.** T2's maximum error is 0.119567 at x=0. P_1's maximum error is 0.071567, at x≈2.81.
17. "as the first and last frames show". **Confirmed** by looking at the frames. Frame 1 shows the h=1 secant parabola passing through (0,0) while T2 starts at about −0.12. Frame 22 shows T2 alone, still at about −0.12 at x=0, and above sin x on the right. The window is [0, π] with y from −0.2 to 1.15, so nothing is clipped.
18. "for f(x)=|x| at x0=0 the coefficient of (x−x0)² is 1/h, which grows without bound". **Confirmed.** (|h| − 0 + |−h|)/(2h²) = 1/h for h>0.
19. "for Case 1 in double precision at h=10⁻⁸ that coefficient is off by about 0.13". **Confirmed.** numpy gives an error of −0.13438. Julia gives −0.1343760199086299, the same.
20. "The animation stops at h=0.01, far from this." **Confirmed.** The smallest h in the script is 0.01, before the hold frames at h=0. At that h the rounding error is about eps/h² ≈ 1e-12.
21. The "where it fits" sentence: the secant parabola is a Newton polynomial (equivalently a Lagrange one); its coefficients are the central-difference approximations from Numerical Differentiation; its limit is a Taylor polynomial; Hermite carries merged nodes further. **Confirmed.** The Lagrange equivalence is Mathews' "Lagrange Connection" section. numerical-differentiation/index.qmd lines 15 and 33–36 give the central first-derivative and second-derivative formulas. Hermite interpolation matches derivative data.

Outside the Description:

22. Heading id `{#case-1}` added to line 65. **Confirmed** as an allowed cross-reference change, recorded here. The heading text is otherwise unchanged.
23. No overview sentence was moved, and the Animations introduction, Behavior paragraph, alt text and links are unchanged. **Confirmed** from the diff.

## 3. Checks

**Six points of the overview standard.** All six are present.
- **The problem:** line 12.
- **The core formula:** P_h and T2 as display math, lines 16–24, in the script's notation (x0, h, the nodes x0∓h, T2).
- **What it assumes:** lines 26–29 and 37: f″(x0) exists for the limit, C³ for the remainder, C⁴ for the O(h²) coefficient rate.
- **How accurate it is:** lines 29–38. These are general results with hypotheses, checked against Case 1 (ledger 8–9) and linked to Case 1.
- **When it fails or misleads:** lines 49–53. The failure modes are poor accuracy far from x0 (shown in the frames), a non-smooth f (|x|) and floating-point cancellation, each computed.
- **Where it fits:** line 55.

The page has no callout boxes, proofs or theorem boxes. The table has 4 rows, within the optional example limit of about six, and it uses the animated problem.

**Consistency with the rest of the page.** The new text does not contradict the Animations introduction (line 59), the Behavior paragraph (line 67) or the alt text (line 71). The T2 formula is identical to the one in the Behavior paragraph and in the script.

**Word count.** My independent count is 376 words for lines 12–55. Inline math counts as one word, display math and table rows are excluded, and link targets are stripped. This matches the manifest and is within 150–400.

**Links and anchors.**
- `#case-1` resolves to the explicit id on line 65; it is the only id on the page.
- `../newton-interpolation-polynomial/`, `../lagrange-polynomial-interpolation-and-approximation/`, `../numerical-differentiation/`, `../maclaurin-and-taylor-series/` and `../hermite-polynomial-interpolation/` all exist as `<slug>/index.qmd`.

**Scope of the diff.** It changes only index.qmd: the new Description block and the heading id. No script, GIF or other section changed.

**Fidelity.** The text agrees with Mathews' module:
- the same formula (4);
- the same remainder R(x, x0, h) and its limit;
- the same coefficients in Table 1 for h = 1, 0.1 and 0.01;
- the same Lagrange equivalence.

The failure modes and the O(h²) coefficient rate are additions not in the module. All are correct.

**Animation (not under review).** I confirmed only what the new text cites. The GIF has 22 frames, matching the script's 17 + 5 h values. The titles of frames 1, 9 and 17 match the table rows. Frames 1 and 22 show the stated behaviour at x=0.
