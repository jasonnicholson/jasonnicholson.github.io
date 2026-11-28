# Maclaurin and Taylor Series — batch 18 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Review of `pages/numerical-methods/maclaurin-and-taylor-series/index.qmd`, light-pass batch 18, overview page (action: check). The text under review is the `+` lines of EV/diff.patch. The diff changes no script or GIF, so the animations were not re-reviewed. I did not run MATLAB or quarto, and I modified nothing in the repository. My scratch work is in EV/reviewer/: chk.py and thm.png, a montage of Mathews' theorem images.

I consulted the Mathews archive: n2003/TaylorPolyMod.html and its formula images TaylorPolyMod_gr_1..11.gif.

## 1. Findings

None.

Observation, not a finding: the Description puts its radius-of-convergence paragraph (the failure mode) before the problem and the T_n formula. That paragraph was already there, and the standard allows another order where the page reads better, so I left it as is.

## 2. Claim ledger (text added or changed by the diff)

L1. Line 12: "$\arctan(x)$ ([M13](#case-m13))", meaning M13 shows arctan with R=1 about 0.
- Verdict: confirmed.
- The `{#case-m13}` id is on the M13 heading (line 151).
- In the M13 frames (orders 0–12 on [-2,2]), the polynomials track atan inside |x|<1 and swing to the ±2 clamp beyond about |x|=1.2–1.6.
- From the coefficients, |a_k|^(-1/k) is 1.095 at k=41. It tends to 1 slowly, consistent with R=1.

L2. Line 12: "$1/(1+x^2)$ ([M05](#case-m05))", meaning R=1 about 0.
- Verdict: confirmed.
- The `{#case-m05}` id is on line 119.
- In the M05 frames (orders 0–12 on [-1.5,1.5]), the polynomials match f in |x|<~0.8 and blow up past |x|≈1.
- |a_k|^(-1/k) = 1.0 exactly.

L3. Line 12: "$\log(x)$ about 1 ([T04](#case-t04)) has $R=1$ because of the singularity at $x=0$."
- Verdict: confirmed.
- The `{#case-t04}` id is on line 189.
- In the T04 frames (orders 0–10 on [-0.5,4.1]), convergence holds on (0,2) and the polynomial pulls away at x≈2, alternating up and down with odd and even order.
- |a_40|^(-1/40) = 1.097, which tends to 1.

L4. Line 12: "The normal CDF ([M18](#case-m18) below)". This is a link added to an unchanged sentence, so I re-checked the sentence's numbers.
- Verdict: confirmed.
- The `{#case-m18}` id is on line 171.
- T10(3) = 2.00058, which rounds to 2.0006. T40(3) = 0.9986499866, and |T40(3) − Φ(3)| = 1.15e-7, which is below 2e-7. Φ(3) = 0.998650, which rounds to 0.99865.
- The difference T10 − Φ is 7e-4 at 1.5, 0.015 at 2, 0.041 at 2.2 and 0.154 at 2.5. That matches "pulls away beyond about |x|=2", as does the order-10 frame.

L5. Line 23: Taylor's theorem holds if f has n+1 continuous derivatives on an interval containing x0 and x.
- Verdict: confirmed. This hypothesis is sufficient for the Lagrange remainder.
- It matches Mathews' hypothesis f ∈ C^{n+1}[x0−R, x0+R] (gr_2) in substance.

L6. Line 26: f = T_n + E_n, with E_n = f^{(n+1)}(c)/(n+1)! (x−x0)^{n+1}.
- Verdict: confirmed.
- It matches Mathews' R_n formula (gr_8) and his P_n sum. The page's T_n/E_n notation is consistent with the existing T_n display on line 18.

L7. Line 29: "for some $c$ between $x_0$ and $x$; this is the Lagrange form of the remainder, as Mathews states it."
- Verdict: confirmed. The module text reads "Lagrange form of the remainder" and has "c lies between ... x0".

L8. Line 30: "The error is therefore $O((x-x_0)^{n+1})$ as $x\to x_0$."
- Verdict: confirmed.
- It follows from L5: a continuous f^{(n+1)} is bounded near x0.
- Numerical check with exp, n=3: E/h^4 = 0.04251, 0.04209, 0.04188 for h = 0.1, 0.05, 0.025, which tends to 1/24 = 0.041667.

L9. Line 30: link to `../big-o-truncation-error/`, text 'Big "O" Truncation Error'.
- Verdict: confirmed. The page exists and its title matches.

L10. Line 32: link to `../trapezoidal-rule-for-numerical-integration/`.
- Verdict: confirmed. The page exists. The sentence around it is unchanged.

L11. Line 34: "[Laurent Series](../laurent-series/) and [Padé Approximation](../pade-approximation/) have their own pages".
- Verdict: confirmed. Both pages exist and their titles match.
- This replaces the old "may be discussed on other ... pages", which is now accurate.

L12. Line 34: "Taylor polynomials drive the [Taylor Series Method for ODEs](../taylor-series-method-for-odes/)".
- Verdict: confirmed. The page exists. Its title is "Taylor Series Method for ODE's"; the link text differs only in the apostrophe.

L13. Heading ids `case-m05`, `case-m13`, `case-m18`, `case-t04`.
- Verdict: confirmed. Each is added as `{#case-...}` at the end of its heading line, and each is unique and matches the link that uses it.

## 3. Checks

**Six points of the overview standard: all present.**
1. Problem: line 15 says the polynomials approximate a smooth function locally by truncating a power series.
2. Core formula: T_n display, lines 17–19.
3. Assumptions: C^{n+1} on an interval containing x0 and x (line 23), plus smoothness or no nearby singularity (lines 12 and 21).
4. Accuracy: Lagrange remainder and O((x−x0)^{n+1}), stated as general results with their hypothesis (lines 23–30).
5. Failure mode: the radius of convergence is set by complex singularities, linked to M13, M05 and T04 (line 12).
6. Where it fits: Big-O, trapezoidal rule, Laurent, Padé and Taylor ODE method (lines 30–34).

No proofs or theorem boxes were added.

**Word count:** my count is 399 prose words, against the manifest's 400 (inline math counted as one word, display math excluded). Either way it is within 150–400, at the upper limit.

**Links and anchors:** all 5 relative page links resolve to existing `index.qmd` files. The 4 in-page anchors match the ids added to their headings. The `../slug/` link style matches other pages on the site.

**Scope of the diff:** outside the Description, the diff only adds 4 explicit heading ids. Each is a cross-reference, which the standard allows. There are no other edits to the Animations sections or other sections, and no script or GIF changes.

**Implementation:** not under review, because no script changed. I looked at the frames of the four linked cases (M05, M13, T04, M18): their titles, function, x0 and interval agree with the case headings and with the text that points to them.
