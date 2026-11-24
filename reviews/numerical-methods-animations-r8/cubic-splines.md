# Cubic Splines — animation review (round 8)

Page: `pages/numerical-methods/cubic-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Errors: 0, Misleading: 0, Minor: 0.

Observations that I judged not to be findings:
- The frame title is slightly clipped on the right in frames 4-6 (the closing parenthesis after the error value is cut); every digit of the error value remains readable, so nothing a viewer concludes changes.
- The page does not animate Mathews' Examples 1-3 and uses sin(x) instead, but it says so explicitly and gives a reason (index.qmd lines 29-30), so this is not a silent departure. The disclosure is accurate (see ledger).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `cubicsplineaa.jl` | 0 | 6.7 | cubicsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `cubicsplineaa.gif` | 6 | byte-identical | cubicsplineaa |

### Page references

- Scripts linked: `cubicsplineaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page wording) | Source | Verdict | Evidence |
|---|---|---|---|---|
| 1 | Spline enforces continuity of S, S', S'' at interior knots | Description l.12-13 | confirmed | The M-system in `natural_spline_M` is the standard C2 continuity system; spline reproduces nodes (residual <= 2.2e-16) and matches scipy `CubicSpline(bc_type='natural')` to all printed digits |
| 2 | Natural BC: S''(x0)=S''(xn)=0 | l.15-19 | confirmed | Script sets M[1]=M[end]=0 (l.29-30); printed M vectors start/end with 0.0 |
| 3 | Second derivatives from a tridiagonal system, then panels reconstructed | l.21 | confirmed | Script l.20-30 (tridiagonal A with diag 2(h_j+h_{j+1}), off-diag h), l.35-45 (M-form panel evaluation) |
| 4 | Clamped or not-a-knot: max error O(h^4) | l.21 | confirmed | check2.py, f=exp on [0,1]: not-a-knot max err 1.65e-5, 1.10e-6, 7.09e-8, 4.51e-9, 2.84e-10 (ratio ~16); clamped 1.69e-6, 1.07e-7, 6.72e-9, 4.21e-10, 2.63e-11 (ratio ~16) |
| 5 | Natural: only O(h^2) unless f''(a)=f''(b)=0; error near the ends, interior still O(h^4) | l.21 | confirmed | check2.py natural, exp: max err 2.08e-3, 5.21e-4, 1.30e-4, 3.26e-5, 8.15e-6 (ratio 4.0 = O(h^2)); max on [0.25,0.75]: 1.48e-4, 2.62e-6, 5.89e-9, 3.26e-10, 2.05e-11 (ratio ~16 once asymptotic, equal to clamped interior) |
| 6 | Natural spline on equally spaced data from sin(x) on [0, 2pi] | Animations intro l.25 | confirmed | Script l.47, l.54 `range(0, 2pi, length=nn)` |
| 7 | Number of nodes increasing | l.25 | confirmed | `n_node_list = [3,4,5,6,7,9]`; frames show 3,4,5,6,7,9 dots |
| 8 | Natural spline satisfies S''(a)=S''(b)=0 | l.25 | confirmed | as #2 |
| 9 | Mathews' Cubic Splines module has no animation | l.29 | confirmed | No animation link in CubicSplinesMod.html (hrefs: Links 1-4, Bib, Prog, Proof, .nb, MathWorld); a2001/Animations has only Quadrature/Spline (spline quadrature, a different module) |
| 10 | sin(x) example is new, not from the module | l.29 | confirmed | Module examples use data points only |
| 11 | Each frame reports the spline's maximum error | l.29 | confirmed | Title includes `max err ≈ ...`, computed as max |S-f| on 600 points |
| 12 | Module's examples interpolate a table of data points with no underlying function | l.29 | confirmed | gr_25 = (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1); no function named |
| 13 | Examples 1, 2 natural (2 using SplineFit), Example 3 clamped, one shared data set | l.30 | confirmed | Module text; gr_25, gr_34, gr_53 identical md5 (20be64a4...); Ex.3 end conditions S'(0)=-0.2, S'(6)=-2.5 (gr_54) |
| 14 | Case 1 heading: natural cubic spline convergence for sin(x) | l.32 | confirmed | as #6 |
| 15 | Adding nodes shrinks the maximum error rapidly | Behavior l.34 | confirmed | Script/scipy: 1.00, 0.109, 0.0200, 0.00896, 0.00407, 0.00107 (strictly decreasing) |
| 16 | Natural end conditions exact since sin''(0)=sin''(2pi)=0, so converges at O(h^4) | l.34 | confirmed | sin''=-sin vanishes at 0, 2pi; check.py dense-grid max err for 9,17,33,65,129,257 nodes: 1.066e-3, 6.31e-5, 3.89e-6, 2.42e-7, 1.51e-8, 9.45e-10 (ratios 16.9, 16.2, 16.1, 16.0, 16.0) |
| 17 | For f''(a) or f''(b) != 0 natural spline only O(h^2) | l.34 | confirmed | as #5 |
| 18 | 3 to 9 nodes too few for the rate to show cleanly frame to frame | l.34 | confirmed | Local orders ln(e_k/e_{k+1})/ln(h_k/h_{k+1}) between consecutive frames: 5.47, 5.88, 3.60, 4.33, 4.66 - scattered, not a clean 4 |
| 19 | Each frame uses a fully recomputed spline (tridiagonal solve) | l.34 | confirmed | `natural_spline_M` called inside the `@animate` loop (l.56) |
| 20 | Source link `cubicsplineaa.jl` | l.36 | confirmed | File exists; the script produces exactly cubicsplineaa.gif (manifest: byte-identical regeneration) |
| 21 | Embed `cubicsplineaa.gif` is this case | l.38 | confirmed | Frames match the case |
| 22 | Alt text: n=3,4,5,6,7,9 nodes on [0,2pi]; spline closely tracks true curve as nodes increase | l.38 | confirmed | Frames 1-6 titles show 3,4,5,6,7,9 nodes; by frame 3 the curves overlap visually |
| 23 | Script header: n = 3,4,5,6,7,9; each frame recomputes the full spline | jl l.1-4 | confirmed | l.51, l.56 |
| 24 | Frame titles' max-error values | GIF | confirmed | Titles 1.0, 0.109, 0.02, 0.00896, 0.00407, 0.00107 = script values rounded to 3 s.f.; dense-grid (200001 pts) values agree to 3 s.f. (e.g. 6 nodes 0.00896494 vs 0.00896508) |
| 25 | Legend: blue f(x)=sin(x), red dashed S(x), black dots data nodes | GIF | confirmed | Plot code l.67-70 and frames |
| 26 | Count: 6 frames | GIF | confirmed | Manifest: 6 frames; frame_001..006 |

### 3. Implementation checks: `cubicsplineaa.jl`

- **It is the method claimed.** Natural cubic spline in second-derivative (M) form: interior equations h_j M_{j-1} + 2(h_j+h_{j+1}) M_j + h_{j+1} M_{j+1} = 6[(y_{j+1}-y_j)/h_{j+1} - (y_j-y_{j-1})/h_j], M_0=M_n=0; evaluation by the standard M-form panel formula. Not a neighbouring method.
- **The numbers are right.** Instrumented copy `review/inst.jl` printed M vectors, max errors and node residuals. Hand check for 5 nodes (h=pi/2, y=0,1,0,-1,0): by symmetry M_2=0, so 4h M_1 = 6(-2)/h, M_1 = -3/h^2 = -12/pi^2 = -1.21585; script M_1 = -1.215854. Node residuals <= 2.2e-16 for every frame. Independent scipy `CubicSpline(..., bc_type='natural')` max errors on the same 600-point grid: 0.999997, 0.108771, 0.0200168, 0.00896494, 0.00407061, 0.00106607; script: 0.9999966, 0.1087710, 0.0200168, 0.0089649, 0.0040706, 0.0010661 - identical. Order check (property, no formula memory needed): error ratio ~16 per halving of h (claim #16).
- **Reference values.** The reference is sin(x) evaluated directly; exact. The 600-point error grid is accurate to 3 s.f. against a 200001-point grid for every frame shown.
- **The picture shows what was computed.** Frames 1, 3, 4, 6 and the contact sheet inspected. The red dashed curve is S evaluated at x_plot, the blue curve is sin, dots are (xs, sin xs) at the correct equally spaced positions (e.g. 3 nodes at 0, pi, 2pi, giving the identically zero spline of frame 1 with max err 1.0). ylims (-1.4,1.4) and xlims (0,2pi) clip nothing. Titles report the correct node count and error. Only cosmetic issue: right edge of the long title slightly clipped in frames 4-6 (closing parenthesis), digits intact.
- Regeneration: manifest reports the scratch copy reproduces the committed GIF byte-identically.

