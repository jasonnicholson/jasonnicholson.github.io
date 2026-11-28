# Hermite Polynomial Interpolation — batch 18 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Page: `pages/numerical-methods/hermite-polynomial-interpolation/index.qmd` (light-pass batch 18, overview, action *extend*). The diff changes no script or GIF, so the animations were not reviewed. I did consult the Mathews archive: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/HermitePolyMod.html`, read as text, plus its formula images gr_1 to gr_18. My scratch files are in `EV/reviewer/`: `check.py`, `wc.py` and `mathews_thm.png`.

## 1. Findings

**F1 — Minor, Page text (the archive says the same thing).**
- **Where:** line 47, "The cubic Hermite polynomial generalizes both the [Taylor polynomial](...), which uses derivatives at one node, and the [Lagrange polynomial](...), which uses values at several nodes".
- **What is wrong:** read literally, this is false for the *cubic*. The two-point cubic Hermite uses values and first derivatives at two nodes. It does not include the cubic Taylor polynomial as a special case, because that needs f″ and f‴ at one node. It does not include the cubic Lagrange polynomial either, because that needs values at four nodes. Hermite (osculating) interpolation in general, which matches derivatives of any order at any number of nodes, is what generalizes both.
- **Source and severity:** Mathews' own Remark says nearly the same words ("The cubic Hermite polynomial is a generalization of both the Taylor polynomial and Lagrange polynomial"). He follows it straight away with the generalization to more nodes and higher derivatives, which the page leaves out. It is of little consequence for a "where it fits" sentence, so I rated it Minor.
- **Suggested fix:** "Hermite interpolation in general, which matches derivatives up to any order at any number of nodes, generalizes both the Taylor polynomial (one node) and the Lagrange polynomial (values only); …"

There are no other findings.

## 2. Claim ledger

This covers the + lines of the diff. Nothing was moved.

| # | Claim (page's words, abridged) | Verdict | Evidence |
|---|---|---|---|
| L1 | Builds a polynomial matching values and first derivatives at the nodes (l.12) | confirmed | definition; scripts use y and f′ at the nodes |
| L2 | One interval: data y0, y1, y0′, y1′; interpolant is a cubic; Mathews calls it a "clamped cubic" because the endpoint slopes are fixed (l.13) | confirmed | archive text: "referred to as a 'clamped cubic,' where 'clamped' refers to the slope at the endpoints being fixed" |
| L3 | h = x1−x0, t = (x−x0)/h, H = y0H00 + h y0′H10 + y1H01 + h y1′H11 (l.14–18) | confirmed | same as `hermite_eval` in hermitepolyaa.jl and the `term1..4` lines in hermitepolybb.jl |
| L4 | H00 = 2t³−3t²+1, H10 = t³−2t²+t, H01 = −2t³+3t², H11 = t³−t² (l.23) | confirmed | identical to both scripts; check.py gives [value at 0, value at 1, slope at 0, slope at 1] = H00 [1,0,0,0], H10 [0,0,1,0], H01 [0,1,0,0], H11 [0,0,0,1] |
| L5 | Each basis function has value or slope 1 for one condition and 0 for the other three; h converts a slope in x into a slope in t (l.26) | confirmed | table above; dy/dt = h·dy/dx |
| L6 | Case 2 adds the four terms one at a time (l.27) | confirmed | hermitepolybb frames 1–4 show the running sum, one term added per frame |
| L7 | Needs x0 ≠ x1 and the derivatives at the nodes (l.29) | confirmed | t is undefined if h = 0 |
| L8 | Mathews' theorem: exactly one cubic satisfies the four conditions (l.30) | confirmed | archive theorem: "there exists a unique cubic polynomial p(x) = ax³+bx²+cx+d such that …"; uniqueness also follows from the basis in L4 |
| L9 | Piecewise: pieces join with matching value and slope, so C¹ but in general not C² (l.31) | confirmed | standard; see L10 |
| L10 | Case 1, n = 2: H″ jumps from −2/π to 2/π at x = π (l.31) | confirmed | sympy pieces are x(π−x)/π (H″ = −2/π) and x²/π − 3x + 2π (H″ = 2/π); H′(π) = −1 on both sides |
| L11 | Mathews' module does not state the error result (l.33) | confirmed | no error term anywhere in the module text or images; the Proof page is empty |
| L12 | If f ∈ C⁴[x0,x1], then for each x there is ξ ∈ (x0,x1) with f−H = f⁽⁴⁾(ξ)/4!·(x−x0)²(x−x1)² (l.33–37) | confirmed | standard result with the right hypothesis; check.py: for f = x⁴ the error equals (x−x0)²(x−x1)² exactly, which matches 4!/4! = 1 |
| L13 | Hence \|f−H\| ≤ M4 h⁴/384 (l.39) | confirmed | max of (x−x0)²(x−x1)² is h⁴/16 at the midpoint; divided by 24 gives h⁴/384 |
| L14 | Piecewise error is O(h⁴) (l.40) | confirmed | follows from L13; observed ratios tend to 16 (15.0, 15.7, 15.9) |
| L15 | Every cubic is reproduced exactly (l.40) | confirmed | sympy: P − f = 0 for a general cubic |
| L16 | Case 1: f = sin x, M4 = 1, and every frame's max error is below h⁴/384: 0.425 vs 4.06 (n = 1), 0.000906 vs 0.000991 (n = 8) (l.41) | confirmed | errors on 600 points (the script's grid) are 0.425375, 0.214601, 0.0107905, 0.000906198. Bounds are 4.05871, 0.25367, 0.0158543, 0.000990897. All four frames are below their bounds, and a 200001-point grid gives the same values to 3 s.f. |
| L17 | Coarse meshes mislead: the doublings divide the max error by 2.0, 19.9, 11.9, not 16 (l.43) | confirmed | ratios 1.982, 19.888, 11.907; agrees with Case 1 Behavior |
| L18 | Case 2: H rises to 2.098 near x = 1.205 and dips to 0.654 near x = 2.629, above the larger endpoint value and below the smaller (l.44) | confirmed | H = x³ − 23x²/4 + 19x/2 − 11/4; its critical points are 1.2046664 (H = 2.0980466) and 2.6286670 (H = 0.6542682); endpoint values are 2 and 1; the dip is visible in frame 4 |
| L19 | When derivatives are estimated, their errors enter H (l.45) | confirmed | H is linear in y0′ and y1′ |
| L20 | Cubic Hermite generalizes the Taylor and Lagrange polynomials (l.47) | wrong as stated for the cubic | see F1 |
| L21 | Cubic splines need only knot values and two end conditions and are C² (l.47) | confirmed | standard; agrees with the archive's spline sections |
| L22 | Bézier curves describe the same cubics through control points (l.47) | confirmed | bezier-curves/index.qmd l.48 states the same equivalence (end derivatives 3(P1−P0), 3(P3−P2)) |
| L23 | Heading ids `{#case-1}`, `{#case-2}` (l.57, l.65) | confirmed | ids are present and the Description's links match them |

## 3. Checks (overview mode)

**Six points of the standard:**
- The problem: present (l.12–13).
- The core formula: display math in the scripts' notation (l.16–24).
- What it assumes: x0 ≠ x1, known derivatives, C⁴ for the error (l.29, l.33).
- How accuracy: general error term with its hypothesis, the h⁴/384 bound, O(h⁴), checked against Case 1 (l.33–41).
- When it fails or misleads: pre-asymptotic ratios linked to Case 1, overshoot from prescribed slopes in Case 2, estimated derivatives (l.43–45).
- Where it fits: l.47 (but see F1).

There are no proofs, theorem boxes or MATLAB procedures. The error-term display is a formula, not a derivation.

**Word count:** 394. My own count from `wc.py` (inline math counted as 1 word, display math dropped, link targets stripped) agrees with the manifest, and it is within 150–400.

**Links and anchors:**
- `#case-1` and `#case-2` match the explicit ids added to the Case 1 and Case 2 headings.
- `../maclaurin-and-taylor-series/`, `../lagrange-polynomial-interpolation-and-approximation/`, `../cubic-splines/` and `../bezier-curves/` each exist as folders with an index.qmd.

**Scope of the diff:**
- Outside the Description, the only changes are the two `{#case-N}` heading ids, which the rules allow.
- No script, GIF or other section changed.
- The new text contradicts nothing in the Animations sections. Case 1 Behavior's ratios (2.0, 19.9, 11.9; 15.0, 15.7, 15.9) and the Case 2 cubic agree with my computation.

**Frames:**
- hermitepolyaa frame titles read max err ≈ 0.425, 0.215, 0.0108 and 0.000906, matching L16.
- The n = 2 frame shows the two parabolic arcs (peak π/4 ≈ 0.785), consistent with L10.
- hermitepolybb frames 1–2 fall to 0 at x = 3, and frame 4 shows the overshoot above 2 near x ≈ 1.2 and the dip below 1 near x ≈ 2.6.

No MATLAB or quarto was run, and nothing in the repository was modified.
