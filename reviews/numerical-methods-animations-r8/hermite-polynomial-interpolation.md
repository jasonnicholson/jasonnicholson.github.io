# Hermite Polynomial Interpolation — animation review (round 8)

Page: `pages/numerical-methods/hermite-polynomial-interpolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Zero Error, zero Misleading, zero Minor.

Every checkable claim on the page agrees with an independent computation, and both animations draw what the scripts compute.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `hermitepolyaa.jl` | 0 | 6.2 | hermitepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `hermitepolybb.jl` | 0 | 6.6 | hermitepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|---|
| D1 | Description | Cubic Hermite matches function values and first derivatives at the nodes | confirmed | sympy: H00,H10,H01,H11 have [value, slope] at t=0 and t=1 equal to unit vectors [1,0,0,0], [0,1,0,0], [0,0,1,0], [0,0,0,1]; instrumented aa reproduces node values exactly (nodecheck = 0.0 for every n) |
| D2 | Description | $t=(x-x_0)/h$, $H(x)=y_0H_{00}+hy_0'H_{10}+y_1H_{01}+hy_1'H_{11}$ | confirmed | Same formula as `hermitepolyaa.jl` lines 26-31 and `hermitepolybb.jl` lines 24-27; the h factor on the slope terms is correct (dH/dx = (1/h) dH/dt) |
| D3 | Description | Piecewise form gives a $C^1$ approximation | confirmed | Adjacent pieces share the node value and node slope by D1 |
| A1 | Intro | Animations illustrate cubic Hermite matching values and first derivatives | confirmed | Both scripts use the basis above |
| A2 | Intro | Mathews' module has no animation | confirmed | No GIF animation referenced in HermitePolyMod.html; no Hermite file in a2001/Animations |
| A3 | Intro | Case 1 ($\sin x$ on $[0,2\pi]$) is the site's own example | confirmed | Archive has no such example |
| A4 | Intro | Case 2 uses the endpoint data of the module's Example 1 | confirmed | Archive gr_18: p(1)=2, p'(1)=1, p(3)=1, p'(3)=2 |
| A5 | Intro | Examples 2 and 3 are a clamped and a natural cubic spline, not animated | confirmed | lnk_3 "clamped cubic spline", lnk_4 "natural cubic spline" |
| C1a | Case 1 heading | Piecewise cubic Hermite for sin(x), refining the mesh | confirmed | aa: f=sin, df=cos, n = 1,2,4,8 |
| C1b | Case 1 behavior | Each subinterval carries a cubic matching f and f' at its two endpoints | confirmed | D1 plus aa line 43-47 (nodes = equispaced, ys=sin, dys=cos) |
| C1c | Case 1 behavior | Max errors 0.425, 0.215, 0.0108, 0.000906 | confirmed | Script: 0.425375, 0.214601, 0.0107905, 0.000906198. Independent scipy on same 600-pt grid: identical; on 200001-pt grid: 0.425382, 0.214602, 0.0107907, 0.000906216 (same at 3 s.f.) |
| C1d | Case 1 behavior | Doublings divide error by about 2.0, 19.9, 11.9 | confirmed | 1.982, 19.888, 11.907 |
| C1e | Case 1 behavior | Error is $O(h^4)$; ratio approaches 16 only on finer meshes: 15.0 (8→16), 15.7 (16→32), 15.9 (32→64) | confirmed | Fine-grid ratios 14.958, 15.738, 15.934; continuing 64→128 gives 15.98 |
| C1f | Case 1 alt text | n=1,2,4,8; max error falls from 0.425 at n=1 to 0.000906 at n=8 | confirmed | As C1c; frame titles show these values |
| C1g | Case 1 wiring | Link `hermitepolyaa.jl`, embed `hermitepolyaa.gif` | confirmed | Manifest: GIF is byte-identical to the regenerated output of that script |
| C2a | Case 2 heading | p(1)=2, p'(1)=1, p(3)=1, p'(3)=2 | confirmed | bb lines 16-18 |
| C2b | Case 2 behavior | Each basis function carries one degree of freedom | confirmed | D1 |
| C2c | Case 2 behavior | h=2; slope weights $hy_0'=2$, $hy_1'=4$ | confirmed | h=b-a=2; 2*1=2, 2*2=4 |
| C2d | Case 2 behavior | Result $H(x)=x^3-\tfrac{23}{4}x^2+\tfrac{19}{2}x-\tfrac{11}{4}$, the cubic of Mathews' solution | confirmed | sympy solve of the 4 conditions: `x**3 - 23*x**2/4 + 19*x/2 - 11/4`; sum of the four weighted terms expands to the same; archive gr_28/gr_32 give a=1, b=-23/4, c=19/2, d=-11/4 |
| C2e | Case 2 behavior | Frames add weighted terms one at a time and draw the running sum | confirmed | bb lines 30-35, 55; 4 frames |
| C2f | Case 2 behavior | Prescribed tangent lines drawn as short dotted segments | confirmed | Instrumented: tan0 y=[1.75, 2.25] on x=[0.75,1.25] (slope 1 through (1,2)); tan1 y=[0.5,1.5] on x=[2.75,3.25] (slope 2 through (3,1)); dotted gray in frames |
| C2g | Case 2 behavior | First two partial sums fall to 0 with zero slope at x=3, because $H_{00}$ and $H_{10}$ have zero value and slope there | confirmed | sympy: partial 1 at x=3 value 0 slope 0; partial 2 value 0 slope 0; script end values 0.0, 0.0 |
| C2h | Case 2 alt text | Running sum, one term per frame, final cubic meets dotted tangent segments at both endpoints | confirmed | Final partial: value 2 slope 1 at x=1, value 1 slope 2 at x=3; frame 4 shows curve tangent to both segments |
| C2i | Case 2 wiring | Link `hermitepolybb.jl`, embed `hermitepolybb.gif` | confirmed | Manifest byte-identical |

### 3. Implementation checks

### `hermitepolyaa.jl`
- **Method:** piecewise cubic Hermite interpolation with exact node values and derivatives (sin, cos) on equispaced nodes. Interval lookup by `searchsortedlast` clamped to [1, n] handles x = 2π correctly. This is the method named.
- **Numbers:** script's max errors (instrumented) vs independent scipy `CubicHermiteSpline` on the same grid agree to all printed digits (0.4253746 / 0.425375, 0.2146006 / 0.214601, 0.01079052 / 0.0107905, 0.000906198 / 0.000906198). The 600-point sampling understates the true sup norm only in the 5th significant figure. Interpolant reproduces nodes exactly (max node residual 0.0 for all n).
- **Reference values:** f = sin(x), f' = cos(x); correct.
- **Picture:** 4 frames, n = 1, 2, 4, 8; blue sin, red dashed H, black nodes at equispaced points (frame 4 shows 9 nodes). n=1 curve peaks near 0.60, consistent with 2π(2t³-3t²+t) max ≈ 0.605. Titles report n and error to 3 s.f., matching computed values. ylims (-1.4,1.4) contain everything; no clamping.

### `hermitepolybb.jl`
- **Method:** single-interval cubic Hermite via the standard basis on [1, 3]; the method named.
- **Numbers:** running sums (instrumented) start/end/min/max: 2→0 (0..2.0); 2→0 (max 2.1070); 2→1 (max 2.1574); 2→1 (min 0.65427, max 2.09805). Independent sympy expansions give the same extrema (2.1070, 2.1574, 0.6543/2.0980) and the final cubic equals the direct 4×4 solve and Mathews' published answer.
- **Reference values:** no underlying f; endpoint data matches Mathews Example 1 (gr_18).
- **Picture:** 4 frames; titles name the term added; legend names the running sum. Tangent segments have correct slopes in x units. ylims (-0.2, 3.0) keep the partial sums that reach 0 at x=3 visible; xlims (0.7, 3.3) show both tangent segments in full. Frame 4 matches the shape of Mathews' graph (gr_31): local max near x≈1.2, min ≈0.65 near x≈2.6.

