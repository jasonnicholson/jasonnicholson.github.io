# Hermite Polynomial Interpolation — animation review (round 9)

Page: `pages/numerical-methods/hermite-polynomial-interpolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None. Every checkable claim on the page was confirmed against independent computation (Python/scipy/sympy) and instrumented scratch copies of the scripts; frames match the plotting code and the page text.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `hermitepolyaa.jl` | 0 | 5.8 | hermitepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `hermitepolybb.jl` | 0 | 5.8 | hermitepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `hermitepolyaa.gif` | 4 | byte-identical | hermitepolyaa |
| `hermitepolybb.gif` | 4 | byte-identical | hermitepolybb |

### Page references

- Scripts linked: `hermitepolyaa.jl`, `hermitepolybb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Claim (page's words, abbreviated) | Location | Verdict | Evidence |
|---|---|---|---|---|
| D1 | Cubic Hermite interpolant `H(x)=y0 H00(t)+h y0' H10(t)+y1 H01(t)+h y1' H11(t)`, `h=x1-x0`, `t=(x-x0)/h` | Description | Confirmed | Same formula in both scripts (aa l.28-31, bb l.24-27); sympy: H00,H10,H01,H11 have (value,slope) at t=0,1 of (1,0;0,0), (0,1;0,0), (0,0;1,0), (0,0;0,1) |
| D2 | Piecewise form gives a C^1 approximation matching value and slope at each node | Description | Confirmed | aa_inst: node value error 0 for n=1..64; central-difference slope at nodes matches cos within <=3.2e-7 (FD error) |
| A1 | Hermite interpolation matches values and first derivatives at endpoint nodes | Animations intro | Confirmed | as D1/D2 |
| A2 | Julia sources linked under each case | intro | Confirmed | links at l.32, l.40 |
| A3 | Mathews' Hermite module has no animation | intro | Confirmed | HermitePolyMod.html has no animation link; no Hermite GIF in a2001/Animations |
| A4 | Case 1 (sin x on [0,2pi]) is the site's own example | intro | Confirmed | Archive examples are 1 (clamped cubic), 2 (clamped spline), 3 (natural spline); none uses sin |
| A5 | Case 2 uses endpoint data of Mathews' Example 1 | intro | Confirmed | gr_18: p(1)=2, p'(1)=1, p(3)=1, p'(3)=2; script l.16-18 identical |
| A6 | Examples 2 and 3 are clamped and natural cubic splines, not animated | intro | Confirmed | lnk_3, lnk_4 text |
| C1-1 | Heading: piecewise cubic Hermite for sin(x), refining the mesh | Case 1 | Confirmed | f=sin, df=cos; n=1,2,4,8 |
| C1-2 | n subintervals, each cubic matching f and f' at both ends | Case 1 Behavior | Confirmed | D2 |
| C1-3 | Max errors in four frames 0.425, 0.215, 0.0108, 0.000906 | Case 1 Behavior | Confirmed | script (600-pt grid): 0.425375, 0.214601, 0.0107905, 0.000906198; scipy CubicHermiteSpline on 2,000,001-pt grid: 0.4253816, 0.21460184, 0.010790682, 0.00090621625; frame titles show 0.425, 0.215, 0.0108, 0.000906 |
| C1-4 | Doublings divide error by about 2.0, 19.9, 11.9 | Case 1 Behavior | Confirmed | 1.982, 19.89, 11.91 (both grids) |
| C1-5 | Error is O(h^4); ratio approaches 16 on finer meshes: 15.0 (8->16), 15.7 (16->32), 15.9 (32->64) | Case 1 Behavior | Confirmed | fine grid: 14.96, 15.74, 15.93; 64->128: 15.98 |
| C1-6 | Four frames | Case 1 | Confirmed | 4 frames in committed GIF |
| C1-7 | Alt text: n=1,2,4,8 intervals; error falls from 0.425 at n=1 to 0.000906 at n=8 | alt | Confirmed | as C1-3 |
| C1-8 | Wiring: link and embed are hermitepolyaa.jl/.gif | Case 1 | Confirmed | l.32, l.34; manifest byte-identical regen |
| C2-1 | Heading data p(1)=2, p'(1)=1, p(3)=1, p'(3)=2 | Case 2 | Confirmed | script l.16-18 |
| C2-2 | Each basis function carries one degree of freedom (a value or derivative at an endpoint) | Case 2 | Confirmed | D1 basis table |
| C2-3 | Weighted combination takes prescribed values and slopes at both ends | Case 2 | Confirmed | sympy: final sum p(3)=1, p'(3)=2, p(1)=2, p'(1)=1 |
| C2-4 | h=2, slope weights h y0'=2, h y1'=4 | Case 2 | Confirmed | script l.19, 25, 27 |
| C2-5 | Result H(x)=x^3-23/4 x^2+19/2 x-11/4, Mathews' cubic | Case 2 | Confirmed | sympy solve of the 4 conditions gives exactly this; Mathews gr_32 gives -11/4+19x/2-23x^2/4+x^3; script curve vs closed form max diff 7.1e-15 |
| C2-6 | Frames add weighted terms one at a time and draw the running sum | Case 2 | Confirmed | stages l.30-35; frames 1-4 show partial sums only |
| C2-7 | Prescribed tangent lines drawn as short dotted segments | Case 2 | Confirmed | [0.75,1.25]->[1.75,2.25] slope 1; [2.75,3.25]->[0.5,1.5] slope 2; dotted gray in frames |
| C2-8 | First two partial sums fall to 0 with zero slope at x=3 | Case 2 | Confirmed | sympy: s1(3)=0,s1'(3)=0; s2(3)=0,s2'(3)=0; frames 1-2 end at y=0 (in view, ylims -0.2) |
| C2-9 | Alt text: running sum of four weighted terms, one per frame, final cubic meets dotted tangents at both ends | alt | Confirmed | frame_004 |
| C2-10 | Wiring: hermitepolybb.jl/.gif | Case 2 | Confirmed | l.40, l.42; byte-identical regen |

### 3. Implementation checks

### hermitepolyaa.jl
- Method: genuine piecewise cubic Hermite interpolation with exact f=sin, f'=cos at equally spaced nodes; interval lookup via `searchsortedlast` clamped to [1,n] (handles x=2pi correctly). Standard basis on t in [0,1] with derivative terms scaled by h.
- Numbers: instrumented copy (`review/aa_inst.jl`) printed errors 0.425375, 0.214601, 0.0107905, 0.000906198, 6.0584e-5, 3.84861e-6, 2.41477e-7 for n=1..64; independent scipy `CubicHermiteSpline` on the same 600-pt grid gave the identical values (0.425375, 0.214601, 0.0107905, 0.000906198, 6.0584e-05, 3.84861e-06, 2.41477e-07). Interpolant reproduces node values exactly and node slopes to FD accuracy. 600-point-grid max agrees with a 2e6-point max to 3+ sig figs for n<=8.
- Reference values: sin/cos exact.
- Picture: frames show sin (blue), Hermite (red dashed), nodes (black) at the right abscissae; titles show n and the rounded error matching the computation; n=1 curve is the cubic 2pi*t(2t-1)(t-1) (peak ~0.6), consistent with frame 1. Axis limits contain everything; no clamping.

### hermitepolybb.jl
- Method: two-point cubic Hermite in basis form, built term by term; same basis and h-scaling as Description.
- Numbers: partial sums (sympy) x^3/2-3x^2+9x/2; 3x^3/4-19x^2/4+33x/4-9/4; x^3/2-13x^2/4+6x-5/4; x^3-23x^2/4+19x/2-11/4. Script arrays: start/end values 2/0, 2/0, 2/1, 2/1; maxima 2.0, 2.107, 2.157, 2.098; final min 0.6543 — all match sympy (min 0.6543, max 2.0980 on [1,3]). Final curve vs closed form max diff 7.1e-15.
- Reference: no underlying f; the data is Mathews' Example 1, verified against archive image gr_18 and solution gr_32; archive plot gr_31 has the same shape (max ~2.1 near 1.2, min ~0.65 near 2.6).
- Picture: tangent segments built from the prescribed slopes at the right points; endpoints marked; ylims (-0.2,3) keep partial sums that end at 0 visible; legend does not cover any curve.

