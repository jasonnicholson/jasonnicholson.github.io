# Bézier Curves — batch 19 review, round 1 (overview mode)

SUMMARY: 0 Error, 0 Misleading, 0 Minor

Page: `pages/numerical-methods/bezier-curves/index.qmd` (light-pass batch 19, overview page, action *extend*). Evidence folder: /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-19/bezier-curves. My scratch script is /tmp/claude-1001/-home-jason--claude-spares-spare-0ogoFf/f6c51b48-3d53-4b4d-8872-653429a6389a/scratchpad/work/review-19/bezier-curves/reviewer/check.py. I did not run MATLAB or quarto, and I changed nothing in the repository.

**Mathews archive:** I consulted it. I read `n2003/BezierCurveMod.html` as text and opened the theorem image `bezier/BezierCurveMod/Images/BezierCurveMod_gr_79.gif`, which reads `x[t] = x0 + 3t(x1-x0) + 3t^2(x0+x2-2x1) + t^3(x3-x0+3x1-3x2)`. That matches the page's display formula exactly.

## 1. Findings

None.

These points came close but are not findings:
- **No frame at exactly t = 1/2.** The Description's t = 1/2 example (line 33) has no matching frame in the Case 1 GIF. With 40 frames, t = k/39, so the nearest frames are t = 0.49 and t = 0.51. The text does not say a frame shows t = 1/2. Frame 20 (t = 0.49) shows the level points at about the stated values, and the standard allows a worked example that adds digits the GIF does not show.
- **Case 2 moves both handles, not one.** Line 45 says that moving one interior control point moves the whole curve. Case 2, cited on line 46, moves both interior points. Line 46 describes what Case 2 does accurately, and the global-control claim is true in general (checked below), so this does not mislead.

## 2. Claim ledger (diff `+` lines; no sentences were moved)

| # | Claim (page's words, abbreviated) | Line | Verdict |
|---|---|---|---|
| L1 | A Bézier curve is a design problem: a smooth curve between two endpoints, shaped by control points it does not in general pass through | 12 | Confirmed. The case curves miss P1 and P2 (L14). |
| L2 | Degree-n Bernstein form B(t)=Σ C(n,i)(1−t)^{n−i} t^i P_i, t∈[0,1] | 13–17 | Confirmed. The formula is standard, and the scripts' de Casteljau equals it (L5). |
| L3 | Mathews writes the cubic in powers of t: x(t)=x0+3t(x1−x0)+3t²(x0+x2−2x1)+t³(x3−x0+3x1−3x2), same for y | 19–25 | Confirmed. sympy expand(power − Bernstein) = 0 for x and y in both cases. It matches Mathews' theorem image gr_79. |
| L4 | The animations evaluate the curve by de Casteljau | 26 | Confirmed. In bezieraa.jl and bezierbb.jl, the levels L1, L2, L3 and `decasteljau_point` are repeated linear interpolation. |
| L5 | Recurrence P_i^{(0)}=P_i, P_i^{(k)}=(1−t)P_i^{(k−1)}+tP_{i+1}^{(k−1)}, B=P_0^{(n)} | 28–30 | Confirmed. The script code is `L_k[i]=(1-t).*L_{k-1}[i] .+ t.*L_{k-1}[i+1]`. |
| L6 | Orange = level 1, green = level 2, red = B(t) | 32 | Confirmed. The script colours match, and so do the legends in frame 20 of bezieraa and the bezierbb contact sheet. |
| L7 | At t=1/2 in Case 1: level 1 is (3/2,7/4), (9/4,3/4), (15/4,1/2); level 2 is (15/8,5/4), (3,5/8); B(1/2)=(39/16,15/16) | 33 | Confirmed by exact rational de Casteljau: identical values. |
| L8 | Needs only control points and t∈[0,1]; no smoothness hypothesis | 35 | Confirmed. The construction is purely algebraic. |
| L9 | Curve starts at P0, ends at Pn; B′(0)=n(P1−P0), B′(1)=n(Pn−Pn−1) (general) | 36 | Confirmed. This is the general result. Case 1: B′(0)=(−3,−3/2)=3(P1−P0), B′(1)=(3/2,3)=3(P3−P2). Case 2: (−6,−3) and (3,6). Both are correct. |
| L10 | Bernstein weights are nonnegative and sum to 1, so the curve lies in the convex hull | 37 | Confirmed (general result, true on [0,1]). |
| L11 | The green segment is tangent: B′(t)=n(P_1^{(n−1)}−P_0^{(n−1)}) | 37 | Confirmed. Symbolically, B′(t) − 3(L2[2]−L2[1]) = 0 for both cases. In the frames, the green segment touches the curve at the red point. |
| L12 | No truncation error, only rounding error | 39 | Confirmed. The curve is a polynomial, evaluated exactly in exact arithmetic. |
| L13 | Each de Casteljau step is a convex combination for 0≤t≤1; rounding error ≤ (multiple growing linearly in n)·u·size of the control points | 40 | Confirmed as a general result. It is the standard forward-error bound (Farouki–Rajan type, about γ_{3n}·max‖P_i‖). |
| L14 | The power form is cheaper with Horner, O(n) against O(n²) | 41 | Confirmed. de Casteljau uses n(n+1)/2 interpolations; Horner uses n multiply-adds per coordinate. |
| L15 | At high degree, power coefficients can grow far larger than the control points and cancel | 41 | Confirmed. a_k = C(n,k)Δ^kP_0; for example, alternating ±1 control points give a_n = ±2^n. |
| L16 | For the cubics on this page, both forms are accurate to about 1e−15 | 41 | Confirmed. Over 2001 values of t, compared with exact Fraction arithmetic, the maximum errors are: Case 1, de Casteljau 8.9e−16 and Horner power form 8.9e−16; Case 2, 8.9e−16 and 1.3e−15. |
| L17 | Case 1 passes no closer than 0.78 to P1 and 0.67 to P2 | 44 | Confirmed. Minimum distances are 0.78232 (t=0.1895) and 0.66841 (t=0.7837). |
| L18 | Every Bernstein weight is positive for 0<t<1, so moving one interior control point moves every point except the ends | 45 | Confirmed. The change is b_i(t)·δ with b_i(t)>0 on (0,1), and b_i(0)=b_i(1)=0 for interior i. |
| L19 | Case 2 doubles the handle lengths of Case 1 | 46 | Confirmed. P1−P0 goes from (−1,−0.5) to (−2,−1), and P2−P3 from (−0.5,−1) to (−1,−2). |
| L20 | The whole curve shifts; the leftmost point moves from x≈1.77 to x≈1.33 | 46 | Confirmed. ΔB = 3t(1−t)[(1−t)(−1,−0.5)+t(−0.5,−1)] ≠ 0 on (0,1). Leftmost x: Case 1 is 1.76615 (t=0.1640) and Case 2 is 1.32723 (t=0.2405). This agrees with the Case 2 Behavior paragraph (line 69) and the bezierbb frames. |
| L21 | A cubic Bézier is the Hermite clamped cubic with end values P0, P3 and end derivatives 3(P1−P0), 3(P3−P2) | 48 | Confirmed. The endpoint values and derivatives (L9) determine the cubic uniquely. |
| L22 | B-Splines join pieces with local control; Cubic Splines and Lagrange interpolate every given point | 48 | Confirmed. The b-splines page, line 32, describes local support. Interpolation is the defining property of the other two. |
| L23 | Heading ids `{#case-1}`, `{#case-2}` added to the Case 1 and Case 2 headings | 59, 67 | Confirmed. These are the only changes outside the Description, and they match the links on lines 33 and 46. |

## 3. Checks

**The six points of the standard**
1. **The problem:** present (line 12).
2. **The core formula:** present. It gives the Bernstein form, Mathews' power form and the de Casteljau recurrence as display math, in the notation of the scripts and the Animations text (levels, P_i, t).
3. **What it assumes:** present (line 35).
4. **How accuracy behaves:** present (lines 39–41). It is stated as a general result, then checked on the page's own cubics (L16). No case is cited as showing accuracy, which is appropriate.
5. **When it fails or misleads:** present (lines 43–46). It gives two concrete failure modes, links Case 1 and Case 2, and the numbers are verified.
6. **Where it fits:** present (line 48). It links Hermite, B-Splines, Cubic Splines, Lagrange and Horner.

**Optional worked example:** the t = 1/2 level values form a single five-value step. It is within the allowance and uses the page's own Case 1.

**Nothing excluded:** no proofs, theorem or definition boxes, or MATLAB/Mathematica code.

**Word count:** the manifest gives 398. My own count, with inline math as one word, display math excluded and punctuation-only tokens dropped, is 396. Either way it is within 150–400, but close to the ceiling.

**Links and anchors:**
- `#case-1` and `#case-2` match the explicit heading ids.
- `../horners-method.qmd` resolves to the existing flat page `pages/numerical-methods/horners-method.qmd`. The same link form is used in lin-bairstow-method.
- `../hermite-polynomial-interpolation/`, `../b-splines/`, `../cubic-splines/` and `../lagrange-polynomial-interpolation-and-approximation/` all exist as folders with an index.qmd.

**Markup:** `\bigl(…\bigr)`, `\,` and `\binom` are valid KaTeX. Every `$$` block is closed.

**Scope of the diff:**
- I regenerated the diff against 147040f; it is identical to `EV/diff.patch`.
- Only `index.qmd` changed: no scripts and no GIFs, so the animations were not re-reviewed.
- Outside the Description, the only changes are the two heading ids, which the standard allows.
- The replaced sentence (start/end points and convex hull) was inside the Description and is restated correctly at lines 36–37.

**Consistency with the rest of the page:**
- The Animations introduction (line 52, three levels of linear interpolation) agrees with the Description.
- The Case 1 Behavior paragraph, "bends one way without an inflection", agrees: the curvature cross-product B′×B″ has only complex roots for both cases.
- Case 2's x≈1.33 versus x≈1.77 agrees with the Description.
- I found no contradictions.

**Frames inspected:** bezieraa frame_020 (t=0.49) and the bezierbb contact sheet (t=0 to 0.92). Point colours, the green tangent segment, the curve's leftmost reach (about 1.33) and the titles agree with the text.
