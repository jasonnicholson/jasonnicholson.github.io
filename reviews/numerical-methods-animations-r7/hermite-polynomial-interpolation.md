# Hermite Polynomial Interpolation — animation review (round 7)

Page: `pages/numerical-methods/hermite-polynomial-interpolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Errors: 0. Misleading: 0. Minor: 0. Fidelity: 0.

Three observations were examined and deliberately not raised as findings:

- **The n = 2 pieces in Case 1 are quadratics.** The page says each subinterval carries "a cubic polynomial". For n = 2 the $t^3$ coefficient cancels: SymPy gives $H=\pi t(1-t)$ on $[0,\pi]$ and $H=\pi t^2-\pi t$ on $[\pi,2\pi]$. This is the correct cubic Hermite interpolant of that data, with a zero leading coefficient, and "cubic" in this setting means degree at most 3.
- **Case 2 never draws a basis function alone after frame 1.** The heading is "Hermite basis functions building the cubic", and the frames show running sums. The page says so directly ("draw the running sum"), and the legends mark the accumulation with a leading "…+".
- **Case 1 is not a Mathews example, and Examples 2 and 3 are not animated.** The page discloses both, so neither is a silent departure.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `hermitepolyaa.jl` | 0 | 6.9 | hermitepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `hermitepolybb.jl` | 0 | 6.5 | hermitepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Hermite interpolation matches "both function values and first derivatives at interpolation nodes" | Value residual at nodes is 0.0 for all n; one-sided slopes match cos to at most 5.8e-7 (the finite-difference size) | confirmed |
| D2 | $h=x_1-x_0$, $t=(x-x_0)/h$, $H(x)=y_0H_{00}(t)+hy_0'H_{10}(t)+y_1H_{01}(t)+hy_1'H_{11}(t)$ | Both scripts implement this form. With it, Case 2 equals the cubic from a separate linear solve | confirmed |
| D3 | $H_{00},H_{10},H_{01},H_{11}$ are "the standard cubic Hermite basis functions" | SymPy: each has the defining (value at 0, slope at 0, value at 1, slope at 1) of (1,0,0,0), (0,1,0,0), (0,0,1,0), (0,0,0,1) | confirmed |
| D4 | Piecewise form gives "a smooth $C^1$ approximation" preserving value and slope at each node | Largest slope jump across interior nodes: 0, 1.4e-10, 1.2e-6, 1.0e-6 for n = 1, 2, 4, 8, at finite-difference noise for step 1e-6 | confirmed |

### Animations introduction

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | The animations illustrate the cubic Hermite polynomial, interpolating values and first derivatives at endpoint nodes | Both scripts; D1 to D3 | confirmed |
| I2 | Lagrange interpolation uses only values; Hermite also matches the slope at each node | Definition; D1 | confirmed |
| I3 | Julia sources are linked under each case | Links at both cases resolve to the two scripts in the folder | confirmed |
| I4 | "Mathews' Hermite polynomial module has no animation" | All 77 module GIFs are single-frame. The only multi-frame GIFs under `hermitepoly/` are two "Under Construction" banners on `HermitePolyProg.html`. No Hermite content in `a2001/Animations/` by filename or text search | confirmed |
| I5 | Case 1 "is this site's own example" | The module's three examples are polynomial or spline data with no sine function | confirmed |
| I6 | Case 2 "uses the endpoint data of the module's Example 1" | Archive image `gr_18`: p(1)=2, p'(1)=1, p(3)=1, p'(3)=2 | confirmed |
| I7 | Examples 2 and 3 are "a clamped and a natural cubic spline through given knots", not animated here | Module text; `gr_38` and `gr_77` show the two-piece conditions; no spline in either script | confirmed |

### Case 1

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Heading: piecewise cubic Hermite for $\sin(x)$, refining the mesh | `hermitepolyaa.jl` lines 36, 40, 43 | confirmed |
| A2 | Interval $[0,2\pi]$ | Lines 39 and 43 | confirmed |
| A3 | $n$ subintervals, each with a cubic matching $f$ and $f'$ at its two endpoints | `hermite_eval`; D1; see the n = 2 observation above | confirmed |
| A4 | Four frames | n = 1, 2, 4, 8; 4 frames in the GIF | confirmed |
| A5 | Maximum errors 0.425, 0.215, 0.0108, 0.000906 | Table in section 3 | confirmed |
| A6 | Doublings divide the error by about 2.0, 19.9, 11.9 | True-maximum ratios 1.9822, 19.8877, 11.9074 | confirmed |
| A7 | Error is $O(h^4)$ for smooth $f$ | Ratios tend to 16; the error stays within $h^4/384\cdot\max\lvert f^{(4)}\rvert$ for all four meshes | confirmed |
| A8 | These coarse meshes are not yet in the asymptotic range | Ratios 1.98, 19.89, 11.91 are far from 16 | confirmed |
| A9 | Finer-mesh ratios 15.0, 15.7, 15.9 for 8→16, 16→32, 32→64 | 14.9576, 15.7382, 15.9345 (true maximum); 14.9577, 15.7418, 15.9378 (script's 600-point grid) | confirmed |
| A10 | Alt text: n = 1, 2, 4, 8; error falls from 0.425 to 0.000906 | Frame titles and A5 | confirmed |
| A11 | Link and embed are this case | `hermitepolyaa.jl`, `hermitepolyaa.gif`; regenerated GIF is byte-identical | confirmed |
| A12 | Frame titles report n and the error | Frames read 0.425, 0.215, 0.0108, 0.000906 for n = 1, 2, 4, 8 | confirmed |

### Case 2

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| B1 | Heading: $p(1)=2$, $p'(1)=1$, $p(3)=1$, $p'(3)=2$ | `hermitepolybb.jl` lines 16 to 18; archive `gr_18` | confirmed |
| B2 | Each basis function carries one degree of freedom | D3 | confirmed |
| B3 | The weighted combination takes the prescribed values and slopes | SymPy: S(1)=2, S'(1)=1, S(3)=1, S'(3)=2 | confirmed |
| B4 | $h=2$, slope weights $hy_0'=2$ and $hy_1'=4$ | Lines 16 to 19 and 25, 27 | confirmed |
| B5 | $H(x)=x^3-\tfrac{23}{4}x^2+\tfrac{19}{2}x-\tfrac{11}{4}$ | Separate SymPy linear solve gives this. Script differs from it by at most 7.1e-15 | confirmed |
| B6 | This is "the cubic of Mathews' solution" | Archive `gr_28`: a=1, b=-23/4, c=19/2, d=-11/4 | confirmed |
| B7 | Frames add the weighted terms one at a time and draw the running sum | Lines 30 to 35 and 55; four frames | confirmed |
| B8 | Prescribed tangent lines are short dotted segments | (0.75, 1.75) to (1.25, 2.25), slope 1; (2.75, 0.5) to (3.25, 1.5), slope 2; dotted in all frames | confirmed |
| B9 | First two partial sums fall to 0 with zero slope at $x=3$ | SymPy: S1(3)=0, S1'(3)=0, S2(3)=0, S2'(3)=0 | confirmed |
| B10 | ...because $H_{00}$ and $H_{10}$ have zero value and zero slope there | D3 | confirmed |
| B11 | Alt text: one term per frame until the complete cubic, which meets the tangent segments at both endpoints | Frame 4; B3 | confirmed |
| B12 | Link and embed are this case | `hermitepolybb.jl`, `hermitepolybb.gif`; regenerated GIF is byte-identical | confirmed |
| B13 | Legends: slopes 1 and 2; endpoints (1, 2), (3, 1); frame titles name the added term | Frames 1 to 4 against lines 31 to 34, 53, 57 | confirmed |

No entry was left as "could not determine".

One archive gap does not affect any claim: `HermitePolyMod_lnk_4.html` references solution images above `gr_77` (for example `gr_82`, `gr_96`) that are not among the 77 GIFs in the Images folder. The page's only statement about Example 3 is confirmed from the module text and `gr_77`.

### 3. Implementation checks

### `hermitepolyaa.jl`

**It is the method it claims to be.** It runs piecewise cubic Hermite interpolation on a uniform mesh, using exact $f$ and $f'$ at the nodes. The interval lookup clamps the last point correctly. On a nonuniform mesh the script's routine reproduces an arbitrary cubic to 8.5e-14 and does not reproduce $x^4$ (error 0.522), so its degree of precision is exactly 3.

**The numbers are right.** Script values against an independent SciPy `CubicHermiteSpline` with per-cell refinement of the maximum:

| n | Script (600-point grid) | Independent true maximum | Bound $h^4/384$ | Title |
|---|---|---|---|---|
| 1 | 0.42537459 | 0.42538160 | 4.0587 | 0.425 |
| 2 | 0.21460059 | 0.21460184 | 0.25367 | 0.215 |
| 4 | 0.01079052 | 0.01079068 | 0.015854 | 0.0108 |
| 8 | 0.00090620 | 0.00090622 | 0.00099090 | 0.000906 |

The 600-point grid changes no reported digit. Closed forms agree: for n = 2 the error is $1-\pi/4=0.2146018$, and for n = 1, $H=2\pi(2t^3-3t^2+t)$ gives 0.4253816.

Finer meshes (true maximum): n = 16, 6.0586e-5; n = 32, 3.8496e-6; n = 64, 2.4159e-7; n = 128, 1.5115e-8. The 64→128 ratio is 15.98.

**Its reference values are right.** The reference is Julia's `sin`, and `cos` is its derivative.

**The picture shows what was computed.** The committed GIF is byte-identical to a scratch regeneration. Frames show the right n, nodes and error. Measured from frame 1, the red curve peaks at y = 0.600 near x = 1.32 (exact 0.6046 at 1.3278) and bottoms at -0.600 (exact -0.6046). No clamping or masking; all values lie well inside the ±1.4 limits.

### `hermitepolybb.jl`

**It is the method it claims to be.** It evaluates the four weighted Hermite basis terms on $[1,3]$ with $h=2$ and accumulates them.

**The numbers are right.** Script against exact SymPy, per partial sum:

| Partial sum | S(1) script / exact | S(3) script / exact | Range on [1,3], script | Range, exact | Exact S'(1), S'(3) |
|---|---|---|---|---|---|
| 1 | 2.0 / 2 | 0.0 / 0 | [0, 2] | [0, 2] | 0, 0 |
| 2 | 2.0 / 2 | 0.0 / 0 | [0, 2.10699] | [0, 2.10700] | 1, 0 |
| 3 | 2.0 / 2 | 1.0 / 1 | [1, 2.15740] | [1, 2.15741] | 1, 0 |
| 4 | 2.0 / 2 | 1.0 / 1 | [0.654269, 2.098045] | [0.654268, 2.098047] | 1, 2 |

The final sum agrees with a separate solve of the four-condition linear system, with Mathews' printed coefficients, and with the page's cubic.

**Its reference values are right.** The reference is the prescribed data, which matches archive `gr_18`. The tangent endpoints are correct.

**The picture shows what was computed.** The committed GIF is byte-identical to a scratch regeneration. Calibrating on the two endpoint markers in frame 4, the orange curve differs from the exact cubic by at most 0.0059 over 470 pixel columns, under one pixel (0.0076). Its measured minimum is 0.652 (exact 0.6543). All partial sums and tangent segments are inside the window $[0.7,3.3]\times[-0.2,3]$, so nothing is clipped. Frame 3 correctly reaches (3, 1) with zero slope, and only frame 4 takes the prescribed slope 2.

