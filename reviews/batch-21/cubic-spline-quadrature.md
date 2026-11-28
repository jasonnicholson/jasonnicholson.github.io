# Cubic Spline Quadrature — batch 21 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 1 Minor

Overview review of `cubic-spline-quadrature`, light-pass batch 21 (action *extend*). File: /home/jason/Desktop/jasonhnicholson.com/pages/numerical-methods/cubic-spline-quadrature/index.qmd. The diff changes only index.qmd and touches no script or GIF, so the animation was not re-reviewed. I consulted the Mathews archive: SplineQuadMod.html, SplineQuadProof.html and SplineQuadProg.html. I did not run MATLAB or quarto and changed nothing in the repository. My scratch files are in /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-21/cubic-spline-quadrature/reviewer/ (check.py, general.py, clamped.py, mend.py, wc.py).

## 1. Findings

**F1 — Page text, Minor.** index.qmd line 42 reads: "In the frames below, each halving $h$, the error is positive only at $m = 3$, and on the last two halvings it shrinks by about 4, which looks like $O(h^2)$."
- **Problem:** the clause "each halving $h$" is ungrammatical; it seems to mean "in the frames that halve $h$". Also, "the frames" do not show the error. The GIF shows only "Approximation = Q_m", and the errors are in the table that follows.
- **The facts are right:** the signs and ratios are correct (see L17 and L18).
- **Suggested fix:** "In the frames that halve $h$ (the table below), the error is positive only at $m = 3$, and on the last two halvings it shrinks by about 4, which looks like $O(h^2)$."

No other findings.

## 2. Claim ledger (+ lines of the diff)

| # | Claim (page's words, condensed) | Verdict | Evidence |
|---|---|---|---|
| L1 | Approximates ∫ from samples y_i=f(x_i) at m=n+1 nodes a=x_0<…<x_n=b | confirmed | script: xs=range(a,b,length=m) |
| L2 | Fits the natural cubic spline S(x) and integrates it exactly | confirmed | script natural_spline_M plus spline_integral; equals scipy CubicSpline(natural).integrate to 6 dp for all m=3..41 |
| L3 | Each panel is a cubic S_i; neighbouring cubics match value, S′ and S″ at the knots | confirmed | standard definition; Mathews properties II–V |
| L4 | h_i=x_{i+1}−x_i, M_i=S″(x_i), natural spline sets M_0=M_n=0 | confirmed | script returns vcat(0, M_inner, 0) |
| L5 | Tridiagonal system h_{i−1}M_{i−1}+2(h_{i−1}+h_i)M_i+h_iM_{i+1}=6(Δ_i−Δ_{i−1}), i=1..n−1 | confirmed | matches script lines 24–28 index by index. My dense solve of the page formula (Qmine) equals scipy for all m |
| L6 | Q_m=Σ[h_i/2(y_i+y_{i+1}) − h_i³/24(M_i+M_{i+1})] | confirmed | script line 64 is identical; Qmine=scipy |
| L7 | The sum is the trapezoidal rule plus a curvature correction | confirmed | the first term is the trapezoidal rule |
| L8 | Needs only sampled values at distinct nodes; Mathews notes the natural spline exists and is unique | confirmed | SplineQuadMod.html: "There exists a unique cubic spline with the free boundary conditions" |
| L9 | The animation uses m equally spaced nodes, h=(b−a)/(m−1) | confirmed | script line 76 |
| L10 | Mathews' module gives no error term | confirmed | no error term in SplineQuadMod.html; SplineQuadProof.html is empty apart from the header; "error" does not appear in any SplineQuad*.html |
| L11 | If f∈C⁴ and nodes are equally spaced, Q_m−I ≈ (f″(a)+f″(b))/(24√3)·h³ | confirmed | general.py, err/pred at n=256: e^x on [0,1] 0.99989; sin on [0,2] 1.00071; cos on [0,1] 1.00012; x⁴ on [0,1] 0.99954. The sign is right in every case. Theory: e_0=−f″(a), e_i=e_0·λⁱ with λ=√3−2, and Σ gives (1+λ)/(1−λ)=1/√3 |
| L12 | O(h³); halving h divides the error by about 8 | confirmed | ratios 7.979→7.999 (exp), 8.123→8.006 (sin) |
| L13 | M_0=M_n=0 is wrong unless f″(a)=f″(b)=0, and the error near each end does not shrink with h | confirmed | mend.py, e^x M-errors at i=0..3: −1.0000, +0.2679, −0.0718, +0.0192 for every n from 32 to 512, while the midpoint error shrinks as h² |
| L14 | If f″(a)=f″(b)=0, or the spline is clamped to the true end slopes, the error is O(h⁴), as for Simpson's rule | confirmed | sin(πx) on [0,1] natural: ratios 16.67→16.00. x³(x−1)³: 22.6→17.0, tending to 16. Clamped e^x: 16.00; clamped sin on [0,2]: 16.00 |
| L15 | f′(x)≈(16/3)x^{−1/3} near 0, unbounded, so f∉C¹[0,2] | confirmed | f′=−e^{−x}sin(8x^{2/3})+e^{−x}cos(8x^{2/3})·(16/3)x^{−1/3} |
| L16 | Case 1 shows neither rate | confirmed | ratios below (L18, L19) |
| L17 | In the halving frames (m=3,5,9,17,33) the error is positive only at m=3 | confirmed | errors: +0.4454, −0.2831, −0.1088, −0.0250, −0.00621. It is also negative for every other m from 5 to 41 |
| L18 | On the last two halvings the error shrinks by about 4 | confirmed | 4.352 and 4.028 |
| L19 | Halving from m=41 gives ratios 3.50, 3.31, 3.23, approaching 2^{5/3}≈3.17, i.e. h^{5/3} | confirmed | m=41→81→161→321: 3.4959, 3.3142, 3.2342. Continuing: 3.2001, 3.1856, 3.1795, 3.1769, 3.1757, 3.1752 (to m=20481). 2^{5/3}=3.17480 |
| L20 | The trapezoidal rule on the same samples has the same rate | confirmed | trapezoidal ratios from m=41: 3.1555, 3.1634, …, 3.1734, tending to 3.1748 |
| L21 | Spline error is about half the trapezoidal error at m=41 | confirmed | \|S\|/\|T\| = 0.493 |
| L22 | Spline error is larger than the trapezoidal error for m≤7 | confirmed | ratio 1.249 (m=3), 1.322 (m=5), 1.157 (m=7); 0.992 at m=9; below 1 for every larger m |
| L23 | Table Q_m: 2.461678, 1.733199, 1.907477, 1.991279, 2.010073 | confirmed | matches my computation and the frame annotations (frame_002 "2.461678"; the contact sheet shows m=5, 9, 17, 33 with the same values) |
| L24 | Table errors +0.4454, −0.2831, −0.1088, −0.02500, −0.006207 | confirmed | +0.445398, −0.28308, −0.108803, −0.0250003, −0.00620705 |
| L25 | Table ratios −1.57, 2.60, 4.35, 4.03, defined as previous error / this error | confirmed | −1.5734, 2.6018, 4.3521, 4.0277 |
| L26 | Table h values 1, 1/2, 1/4, 1/8, 1/16 | confirmed | h=2/(m−1) |
| L27 | I=∫_0^2 f ≈ 2.016280 | confirmed | mpmath with x=t³ substitution (removes the singularity), 30 digits: 2.0162797196… |
| L28 | Related-pages sentence; Romberg and Gauss-Legendre reach high order on smooth integrands | confirmed | qualitative and true; all linked pages exist (see checks) |
| L29 | New heading id {#case-1} on Case 1 | confirmed | line 66; link `[Case 1](#case-1)` at line 41 resolves |

## 3. Checks

**Six points of the overview standard**
1. The problem: present (line 12).
2. The core formula: present as display math (lines 17–25), in the script's notation and formulas.
3. What it assumes: present. Distinct nodes and sampled values only (line 28); equal spacing and C⁴ for the error term (lines 29 and 31).
4. How accurate it is: present (lines 31–39). Stated as a general result with its hypotheses, and checked numerically (L11–L14).
5. When it fails or misleads: present. The natural end condition costs one order; the non-smooth integrand of Case 1 converges at h^{5/3}, and its first halvings look like O(h²). Linked to Case 1 and backed by computation.
6. Where it fits: present (line 56).

The optional worked-example table has 5 rows and uses the page's own animated problem; it is within the allowed size. There are no proofs, theorem boxes or MATLAB/Mathematica procedures.

**Word count.** 368 words by my independent count (wc.py), which agrees with the manifest. This is within 150–400.

**Consistency with the rest of the page.**
- The Animations intro (odd m from 3 to 41, an opening frame of f alone) agrees with the script and the frames.
- The Case 1 Behavior paragraph says f has an infinite slope at x=0 from the x^{2/3} term. That agrees with L15.
- I found no contradictions.

**Links and anchors.**
- `#case-1` matches the explicit id on line 66.
- These targets exist as folders with index.qmd: ../cubic-splines/, ../trapezoidal-rule-for-numerical-integration/, ../simpsons-rule-for-numerical-integration/, ../romberg-integration/ and ../gauss-legendre-quadrature/.

**Scope of the diff.**
- The diff is identical to the current `git diff` of the page.
- Outside the Description, the only change is the `{#case-1}` id added to the Case 1 heading, which is allowed.
- The old Description sentences were replaced rather than moved; their content (natural spline, exact integration, C² matching) is kept in the new text. Nothing was moved out of the Animations intro.
- No script or GIF was changed.

**Fidelity.**
- The page follows Mathews' module: natural "free" boundary conditions, integration of the spline, and existence and uniqueness credited to Mathews.
- The error term is correctly labelled as not from Mathews.
- No fidelity findings.

**Not findings.**
- The "halving from m=41" sequence is not the table's halving sequence (from m=33, the next ratio is 3.59, at m=65). The page labels it clearly, so it is not misleading.
- The O(h³) statement implicitly assumes f″(a)+f″(b)≠0. The page covers the main exception (both are zero), so I did not raise it.
