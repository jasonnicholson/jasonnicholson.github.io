# Cubic Splines — animation review (round 9)

Page: `pages/numerical-methods/cubic-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Zero Error, zero Misleading, zero Minor.

Observations that I checked and judged not to be findings under the review standard:

- **Title clipping (cosmetic).** In frames 4, 5 and 6 (n = 6, 7, 9) the closing parenthesis of the title `(max err ≈ …)` is cut off at the right edge of the 700 px canvas. The full number stays visible (e.g. "0.00896", "0.00407", "0.00107"), so nothing is unreadable or misleading. If the owner wants it tidy anyway, shorten the title (e.g. `"Natural spline, sin(x): $nn nodes, max err ≈ …"`) or set `titlefontsize=11`.
- **Last-digit rounding of the n = 6 title.** The title shows 0.00896, which is the maximum over the 600-point plot grid (0.0089649). On a 200 001-point grid the true maximum is 0.0089651, which rounds to 0.00897. That is a last-digit rounding difference and is within the tolerance the standard allows. The other five titles agree with the fine-grid maximum to all three shown digits.
- **n = 3 frame is degenerate.** With nodes 0, π, 2π all data values are 0, so the natural spline is identically zero and the error is 1.0. That is the correct natural spline. The page does not comment on it, but it says nothing that this contradicts.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `cubicsplineaa.jl` | 0 | 11.8 | cubicsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.12–13 | Piecewise cubic, each panel interpolates endpoint values, S, S′, S″ continuous at interior knots | Script uses the standard second-derivative (M) form, which is C² by construction; node reproduction error ≤ 2.2e-16 for every n (instr.jl); scipy's natural spline gives the same M vectors | confirmed |
| 2 | Description l.15–19 | Natural BC S″(x₀)=S″(xₙ)=0 | Script sets M[1]=M[end]=0 (l.29–30); scipy S″(0)=5.8e-16, S″(2π)=2.2e-16 for n=9 | confirmed |
| 3 | Description l.21 | Unknown second derivatives come from a tridiagonal system, then each panel is rebuilt | Script l.20–30 assembles a tridiagonal (h_j, 2(h_j+h_{j+1}), h_{j+1}) system and evaluates with the M-form panel formula l.42–44 | confirmed |
| 4 | Description l.21 | Clamped or not-a-knot: max error O(h⁴) | bc.py, f=eʸ on [0,2]; ratios as h is halved: clamped 15.6, 15.8, 15.9, 16.0; not-a-knot 14.1, 15.0, 15.5, 15.7 | confirmed |
| 5 | Description l.21 | Natural: only O(h²) unless f″(a)=f″(b)=0 | bc.py natural on eˣ: ratios 3.98, 3.99, 4.00, 4.00; indep.py natural on cos on [0,2π]: ratios 4.25, 4.06, 4.02, 4.00 | confirmed |
| 6 | Description l.21 | That error sits near an end; away from the ends it is still O(h⁴) | indep.py, cos, error on [1, 2π−1]: ratios 16.06, 16.01, 16.00 (n=33→65→129→257; the 17→33 ratio of 133 is the boundary layer leaving the window) | confirmed |
| 7 | Animations l.25 | Natural cubic spline, equally spaced data from sin(x) on [0, 2π] | Script l.47, 54: `range(0, 2π, length=nn)`, `f(x)=sin(x)`, natural M solver | confirmed |
| 8 | Animations l.25 | Number of nodes increases | `n_node_list = [3,4,5,6,7,9]`; frame titles read 3, 4, 5, 6, 7, 9 nodes | confirmed |
| 9 | Animations l.25 | Natural spline satisfies S″(a)=S″(b)=0 | as #2 | confirmed |
| 10 | l.29 | Mathews' Cubic Splines module has no animation | n2003 module HTML: no animation link or text (links are lnk_1–4, Prog, Proof, Bib, .nb, MathWorld). The only a2001 spline animation is "Natural Cubic Spline Quadrature", which belongs to a different topic (the site has a separate `cubic-spline-quadrature` page) | confirmed |
| 11 | l.29 | The sin(x) example is new, not from the module | Module examples use the data table only | confirmed |
| 12 | l.29 | Each frame can report the maximum error because sin has a closed form | Titles report max error computed against sin(x) (script l.58) | confirmed |
| 13 | l.29 | The module's examples interpolate a table of points with no underlying function | gr_27: `XY = {{0,1},{1,0},{2,0},{3,1},{4,2},{5,2},{6,1}}` | confirmed |
| 14 | l.30 | Examples 1 and 2 natural (Example 2 uses SplineFit), Example 3 clamped, one shared data set | lnk_2/3/4 text; gr_28 (Ex 1/2) and gr_56 (Ex 3) plot the same 7 points; lnk_3 says "the same curve that was obtained in Example 1" | confirmed |
| 15 | l.30 | These are not animated here | Page has one case only | confirmed |
| 16 | Case 1 heading | Natural cubic spline convergence for sin(x) | Script as above | confirmed |
| 17 | Behavior l.34 | Adding nodes shrinks the maximum error rapidly | Max errors 1.0, 0.109, 0.0200, 0.00896, 0.00407, 0.00107; strictly decreasing, about 1000× overall | confirmed |
| 18 | Behavior l.34 | sin″(0)=sin″(2π)=0, so natural end conditions are exact and the rate is O(h⁴) | Exact; ratios as n doubles (h halves): 16.89, 16.23, 16.06, 16.01 (indep.py), the same in the script's own routine (instr.jl: 6.31e-5, 3.89e-6, 2.42e-7, 1.51e-8, 9.37e-10) | confirmed |
| 19 | Behavior l.34 | h is the maximum node spacing | Uniform nodes, h = 2π/(n−1) | confirmed (consistent) |
| 20 | Behavior l.34 | For smooth f with f″(a)≠0 or f″(b)≠0 the natural spline falls only as O(h²) | as #5 | confirmed |
| 21 | Behavior l.34 | 3 to 9 nodes are too few for the rate to show cleanly frame to frame | Observed orders log(e_k/e_{k+1})/log(h_k/h_{k+1}) for 4→5, 5→6, 6→7, 7→9: 5.88, 3.60, 4.33, 4.66 (3→4 is meaningless because S≡0 at n=3). They scatter around 4, so "not cleanly" is fair | confirmed |
| 22 | Behavior l.34 | Each frame is a fully recomputed spline that solves the tridiagonal system | Script l.53–57 calls `natural_spline_M` for each nn | confirmed |
| 23 | l.36 | Julia source link → `cubicsplineaa.jl` | File exists and is the script for this case; manifest: linked | confirmed |
| 24 | l.38 alt | Spline for sin(x) on [0, 2π] with n=3,4,5,6,7,9 nodes | Frames 1–6 titles | confirmed |
| 25 | l.38 alt | The spline tracks the true curve more closely as nodes increase | Frames: visible gap at n=3, 4; indistinguishable from n=6 on | confirmed |
| 26 | Frames (legend) | Blue solid = sin(x), red dashed = spline, black dots = data nodes | Script l.67–70 and frames | confirmed |
| 27 | Frame titles | max err ≈ 1.0, 0.109, 0.02, 0.00896, 0.00407, 0.00107 | Fine-grid true maxima 1.0, 0.108771, 0.0200170, 0.0089651, 0.0040708, 0.0010661. All match at the digits shown except n=6, where the true value rounds to 0.00897 (last-digit rounding; see observations) | confirmed |
| 28 | Section index | Page linked from the section index | Manifest: yes | confirmed |

### 3. Implementation checks: `cubicsplineaa.jl`

**It is the method it claims to be.** It is the natural cubic spline in the classical second-derivative (moment) formulation: the interior equations h_{j}M_{j−1} + 2(h_j+h_{j+1})M_j + h_{j+1}M_{j+1} = 6(Δ_{j+1} − Δ_j), with M₀=Mₙ=0, and the panel formula S = M_i(x_{i+1}−x)³/(6h) + M_{i+1}(x−x_i)³/(6h) + (y_i/h − M_i h/6)(x_{i+1}−x) + (y_{i+1}/h − M_{i+1}h/6)(x−x_i). I checked the sub- and super-diagonal indices: row j (interior node j+1) gets h[j] on the subdiagonal and h[j+1] on the superdiagonal, which is correct for nonuniform spacing as well. The interval search uses `searchsortedlast` clamped to [1, n], so the right endpoint is handled.

**The numbers are right.** I instrumented a copy (`review/instr.jl`) and compared it with scipy `CubicSpline(bc_type='natural')` (`review/indep.py`):

| n | script M (interior) | scipy S″ at nodes | script max err (600 grid) | scipy max err (600 grid) | scipy max err (200 001 grid) |
|---|---|---|---|---|---|
| 3 | [−7.4e-17] | [0] | 0.9999966 | 0.9999966 | 1.0 |
| 4 | [−1.1845807, 1.1845807] | same | 0.10877104 | 0.10877104 | 0.10877104 |
| 5 | [−1.2158542, ~0, 1.2158542] | same | 0.02001682 | 0.02001682 | 0.02001701 |
| 6 | [−1.0813794, −0.6683292, 0.6683292, 1.0813794] | same | 0.00896494 | 0.00896494 | 0.00896508 |
| 7 | [−0.9476646, −0.9476646, 0, 0.9476646, 0.9476646] | same | 0.00407061 | 0.00407061 | 0.00407079 |
| 9 | [−0.7441499, −1.0523869, −0.7441499, 0, …] | same | 0.00106607 | 0.00106607 | 0.00106609 |

The two agree to all digits printed. Property checks: node reproduction ≤ 2.2e-16 for every n; error ratio when h is halved, using the script's own routine at n = 17, 33, 65, 129, 257: 16.2, 16.1, 16.0, 16.1, the O(h⁴) rate expected for sin with natural ends. For a function with f″(a)≠0 (cos) the scipy natural spline shows 4.0 globally and 16.0 in the interior, which confirms the page's Description of the end-condition effect.

**Reference values are right.** The reference curve is `sin(x)` evaluated directly, so it is exact. The maximum error is taken on the 600-point plot grid. It agrees with a 200 001-point grid to within 2e-7 absolute, which is enough for the three significant figures shown. The one consequence is the last-digit difference at n=6 noted above.

**The picture shows what was computed.** I viewed frames 1, 2, 4 and 6 in full and all six on the contact sheet. The blue curve is sin(x), the red dashed curve is the computed S, and the black markers sit at the equally spaced nodes with the right count (3, 4, 5, 6, 7, 9). At n=3 the spline is flat at 0 through (0,0), (π,0), (2π,0), which is correct. At n=4 the visible undershoot at the peaks matches max err 0.109 (located at x ≈ 0.986). Axis limits [0, 2π] × [−1.4, 1.4] contain everything, and nothing is clamped or masked. The title's function, node count and error value match the code. The only display defect is that the closing parenthesis of the title is clipped in frames 4–6 (see observations), which is cosmetic.

