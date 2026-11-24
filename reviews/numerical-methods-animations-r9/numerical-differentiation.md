# Numerical Differentiation — animation review (round 9)

Page: `pages/numerical-methods/numerical-differentiation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, every number in the frames, and both scripts' computations agree with my independent computation (details in parts 2 and 3).

Observations deliberately not raised as findings (no effect on what a reader concludes):
- Case 2 plots on $[0,\pi]$ with steps 0.6 ... 0.001, whereas Mathews' Example 14 code uses the window $[0,2.1]$ with H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01} and the legacy animations use h = 1.0, 0.8, 0.6, 0.4, 0.2, 0.08, 0.04, 0.008, 0.001. The page does not claim the legacy step list or window for Case 2, and $[0,\pi]$ is the module's Project I interval, so the intro's "legacy interval settings from the source module" still holds. The geometry, $x_0=1$, function and drawn elements match the legacy exactly, and the page's slopes for h = 0.6 and 0.4 (-0.049354, -0.083592) equal those printed in the legacy animation frames.
- Case 1: from h = 0.1 onward $D_3$ and $f'$ are visually indistinguishable; the convergence is carried by the "max error" in the title, which is correct. The y-range $[-1,1.1]$ leaves the lower half empty. Cosmetic only.
- `numdiffab.jl` line 26 `continue` guard never fires (all $1\pm h\in[0,\pi]$); 12 frames are produced as expected.
- The Description's sentence that roundoff and cancellation eventually limit accuracy is true in general but not shown by the animation (smallest h = 0.001, roundoff ~1e-13); the page does not claim the animation shows it.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `numdiffaa.jl` | 0 | 7.4 | numdiffaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `numdiffab.jl` | 0 | 8.1 | numdiffab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `numdiffaa.gif` | 12 | byte-identical | numdiffaa |
| `numdiffab.gif` | 12 | byte-identical | numdiffab |

### Page references

- Scripts linked: `numdiffaa.jl`, `numdiffab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description ¶1 | "In the Mathews examples for this module, the test function is $f(x)=e^{-x}\sin(x)$ on $[0,\pi]$" | Archive gr_27 `f[x] = e^-x Sin[x]`; gr_49 `[0, π]` (Ex 2(c)); also Ex 11/14 gr_262, gr_325 | confirmed |
| 2 | Description ¶1 | "with representative steps $h=0.1,0.01,0.001$" | Archive gr_45/gr_47 `h = 0.1, 0.01, and 0.001` (Ex 2(a),(b)) | confirmed |
| 3 | Description | $D_3(x,h)=\frac{f(x+h)-f(x-h)}{2h}$ is the three-point central approximation | Archive gr_20; script line 12 `central3` identical | confirmed |
| 4 | Description | "truncation error $O(h^2)$ when $f$ is sufficiently smooth" | sympy: $D_3-f' = \frac{\sqrt2}{3}h^2e^{-x}\sin(x+\pi/4)+O(h^4)=\frac{h^2}{6}f'''(x)+\dots$; numerically err/h² at x=1 constant 0.16944 | confirmed |
| 5 | Description | "As $h$ decreases, truncation error improves, but eventually roundoff and cancellation can limit accuracy" | General fact; not depicted (not claimed to be) | confirmed (general statement) |
| 6 | Animations intro | Each animation shows finite-difference behaviour for $f(x)=e^{-x}\sin x$ | Both scripts line 9 `f(x) = exp(-x) * sin(x)`; frame titles/legends | confirmed |
| 7 | Animations intro | "on legacy interval settings from the source module" | Case 1 $[0,\pi]$ = Ex 2(c) interval; Case 2 also $[0,\pi]$ (Project I interval; Ex 14 itself used $[0,2.1]$) | confirmed (see observation) |
| 8 | Animations ¶2 | Case 1 extends Example 2(c), "the plot of $D_3(x,h)$ against $f'(x)$ on $[0,\pi]$" | Archive gr_85: `Plot[D1[x,0.01],{x,0,π}]` and `Plot[f'[x],{x,0,π}]`, D1 = central formula (gr_88) | confirmed |
| 9 | Animations ¶2 | "from the single step $h=0.01$ to a sequence of steps" | Ex 2(c) uses h=0.01 (gr_48); script hs includes 0.01 among 12 steps | confirmed |
| 10 | Animations ¶2 | Case 2 follows Examples 11 and 14, the central difference at $x_0=1$ | Ex 11 (gr_262/263) and Ex 14 (gr_325/326): $f'[1.0]$ by central difference (2-point and 3-point); script `x0 = 1.0` | confirmed |
| 11 | Animations ¶2 | Ex 1 = graph of $f'''$ used to bound the error | Module text + gr_29 `f^(3)[x]` | confirmed |
| 12 | Animations ¶2 | Ex 2(a), 2(b) = tables of approximations | Module text ("Compute numerical approximations ... using step sizes") | confirmed |
| 13 | Animations ¶2 | Ex 3 = plot of absolute error against the error bound | gr_94 `|f'[x] - D1[x,0.01]| ≤ EB1[0.01]` | confirmed |
| 14 | Animations ¶2 | Ex 4 = how the bound shrinks with $h$ | Module text "If the step size is reduced by a factor of [1/2] then the error bound is reduced by ..." | confirmed |
| 15 | Animations ¶2 | Ex 9, 10, 12, 13 = forward/backward first-derivative formulas | Module text (9 fwd 2-pt, 10 bwd 2-pt, 12 fwd 3-pt, 13 bwd 3-pt) | confirmed |
| 16 | Animations ¶2 | Second-derivative formulas: Project II, Ex 5-8, and Ex 15-17 | Module text | confirmed |
| 17 | Case 1 heading | "central derivative profile, $D_3(x,h)$ on $[0,\pi]$" | Script lines 12, 16, 21 | confirmed |
| 18 | Case 1 Behavior | "The numerical derivative curve approaches $f'(x)$ as $h$ shrinks" | Max error decreases monotonically 8.13e-2 → 3.33e-7 over the 12 frames (table in part 3) | confirmed |
| 19 | Case 1 Behavior | "consistent with second-order truncation error for the central stencil" | Max error 3.33e-3, 3.33e-5, 3.33e-7 at h = 0.1, 0.01, 0.001 (factor 100 per decade); equals $h^2/3 = h^2\max|f'''|/6$ for small h | confirmed |
| 20 | Case 1 link | `[Julia source](numdiffaa.jl)` | File exists, produces `numdiffaa.gif`, byte-identical on regen | confirmed |
| 21 | Case 1 embed/alt | "comparing the three-point central derivative approximation against the true derivative over 0 to pi as h decreases" | Frames: black $f'$, blue $D_3$, $[0,\pi]$, h 0.5 → 0.001 | confirmed |
| 22 | Case 2 heading | "secant to tangent at $x_0=1$, $h\to 0$" | `x0 = 1.0`; hs 0.6 → 0.001 | confirmed |
| 23 | Case 2 Behavior | "The slope from the symmetric secant $(f(x_0+h)-f(x_0-h))/(2h)$ converges to the tangent slope $f'(x_0)$ as the stencil contracts" | Slopes -0.049354 → -0.110794 monotonically, error/h² → 0.16944 (part 3); $f'(1)=-0.110793765$ | confirmed |
| 24 | Case 2 Behavior | "As in Example 14, each frame also draws the parabola through the three stencil points and the line through $(x_0,f(x_0))$ with the secant slope" | Archive gr_327 code: `g[x_] = f[X] + m(x-X)`, `q[x_] = Fit[{3 points},{1,x,x^2},x]`; script lines 41-43, 65-66; all 12 frames show both | confirmed |
| 25 | Case 2 Behavior | "that slope is the parabola's derivative at $x_0$" | sympy Lagrange interpolant: $p'(1)$ = D3 to 15 digits for h = 0.6 and 0.1 | confirmed |
| 26 | Case 2 Behavior | "so the line touches the parabola there and runs parallel to the chord" | Same slope msec for chord (line 38) and centre line (line 43); centre line passes $(x_0,y_0)$; tangent to parabola since $p'(x_0)$ = msec | confirmed |
| 27 | Case 2 link | `[Julia source](numdiffab.jl)` | File exists, produces `numdiffab.gif`, byte-identical on regen | confirmed |
| 28 | Case 2 alt | "central secant lines through the points at x0 minus h and x0 plus h, and parallel lines through the point at x0, collapsing to the tangent line at x0 equals 1 for f of x equals e to the minus x times sine x, with the parabola through the three stencil points drawn in each frame" | Frames 1-12: dashed blue chord through outer orange points, dotted purple line through centre point, green parabola, red tangent; lines merge into tangent by h ≈ 0.07 | confirmed |
| 29 | Derivation Notes | $f(x\pm h)=f\pm hf'+\frac{h^2}{2}f''\pm\frac{h^3}{6}f^{(3)}(\xi_\pm)$ | sympy: series of $f(x+h)$ through $h^3$ equals the polynomial part; Lagrange remainder form is standard | confirmed |
| 30 | Derivation Notes | "leads to the central three-point first-derivative rule with error proportional to $h^2$" | Subtracting gives error $\frac{h^2}{12}(f'''(\xi_+)+f'''(\xi_-))$; see #4 | confirmed |
| 31 | Frames (Case 1 titles) | "max error ≈ 8.13e-02, 2.97e-02, 1.33e-02, 3.33e-03, 1.63e-03, 8.33e-04, 3.00e-04, 1.33e-04, 3.33e-05, 8.33e-06, 1.33e-06, 3.33e-07" | Independent continuous max over $[0,\pi]$ (part 3) agrees to all 3 digits | confirmed |
| 32 | Frames (Case 2 titles) | secant slopes to 6 dp and "true = -0.110794" | Independent mpmath values agree to all 6 dp (part 3) | confirmed |

### 3. Implementation checks

### `numdiffaa.jl` (Case 1)

*Method.* Line 12 is exactly the central difference $(f(x+h)-f(x-h))/(2h)$ named on the page and in Mathews (gr_20). Evaluated at 700 points on $[0,\pi]$; $f$ is entire so evaluating at $x\pm h$ outside the interval is legitimate (comment line 23 is correct).

*Reference values.* `fp(x) = exp(-x)*(cos(x)-sin(x))`; sympy `diff(exp(-x)*sin(x))` minus this simplifies to 0.

*Numbers.* Instrumented copy `review/aa_instr.jl` (prints max error, its location, $D_3(0)$); independent `review/indep.py` (mpmath, 40 digits, 20001-point scan + local refine over continuous $[0,\pi]$).

| h | script maxerr (700 pts) | independent maxerr | at x | $h^2/3$ |
|---|---|---|---|---|
| 0.5 | 8.127671e-02 | 8.1277022e-02 | 0.025 | 8.33e-02 |
| 0.3 | 2.973127e-02 | 2.9731268e-02 | 0.009 | 3.00e-02 |
| 0.2 | 1.328011e-02 | 1.3280112e-02 | 0.004 | 1.33e-02 |
| 0.1 | 3.329998e-03 | 3.3300017e-03 | 0.001 | 3.33e-03 |
| 0.07 | 1.632533e-03 | 1.6325332e-03 | 0.0005 | 1.63e-03 |
| 0.05 | 8.331250e-04 | 8.3312503e-04 | 0.00025 | 8.33e-04 |
| 0.03 | 2.999730e-04 | 2.99973e-04 | ~0 | 3.00e-04 |
| 0.02 | 1.333280e-04 | 1.33328e-04 | 0 | 1.33e-04 |
| 0.01 | 3.333300e-05 | 3.3333e-05 | 0 | 3.33e-05 |
| 0.005 | 8.333313e-06 | 8.3333125e-06 | 0 | 8.33e-06 |
| 0.002 | 1.333333e-06 | 1.3333328e-06 | 0 | 1.33e-06 |
| 0.001 | 3.333333e-07 | 3.333333e-07 | 0 | 3.33e-07 |

Property check: $f''''=-4e^{-x}\sin x\le 0$ on $[0,\pi]$, so $f'''=2\sqrt2 e^{-x}\sin(x+\pi/4)$ is decreasing and $\max|f'''|=f'''(0)=2$; the leading error $h^2f'''/6$ is largest at $x=0$ and equals $h^2/3$, which the numbers reproduce. Halving/decade ratios: 100× per factor-10 in h → order 2.

*Picture.* Frames 1, 4, 6, 9, 12 viewed (all 12 on the contact sheet). Black = `fp`, blue = `central3`, legend labels correct; title h and max error match the table. $D_3(0)$ at h = 0.5 is 1.0812, inside ylims (1.1), so nothing is clipped. Regenerated GIF byte-identical to committed.

### `numdiffab.jl` (Case 2)

*Method.* Line 34 `msec = (yr - yl)/(2h)` is the central difference at $x_0=1$. Line 38 chord through $(x_0-h, f(x_0-h))$ with that slope (passes through $(x_0+h,f(x_0+h))$ by construction). Lines 41-42: parabola $y_0+m(x-x_0)+c_2(x-x_0)^2$ with $c_2=(y_r-2y_0+y_l)/(2h^2)$; it reproduces all three stencil values exactly (algebra: $p(x_0\pm h)=y_0\pm\frac{y_r-y_l}{2}+\frac{y_r-2y_0+y_l}{2}$ gives $y_r$, $y_l$), and sympy's Lagrange interpolant gives the same $p'(1)$ and $p''/2$ (h=0.6: $c_2=-0.217047778096$ both; h=0.1: $-0.199281822498$ both). Line 43 line through $(x_0,y_0)$ with slope msec. Line 39 tangent with `fp(x0)`.

*Reference value.* $f'(1)=e^{-1}(\cos1-\sin1)=-0.110793765306699$ (mpmath); script `mtan=-0.110793765307`.

*Numbers.* Instrumented `review/ab_instr.jl` vs `review/indep.py`:

| h | script msec | independent | title (6 dp) | err/h² |
|---|---|---|---|---|
| 0.6 | -0.049353742675 | -0.049353742675 | -0.049354 | 0.17067 |
| 0.4 | -0.083591810125 | -0.0835918101248 | -0.083592 | 0.17001 |
| 0.25 | -0.100189411390 | -0.10018941139 | -0.100189 | 0.16967 |
| 0.15 | -0.106979459959 | -0.106979459959 | -0.106979 | 0.16953 |
| 0.1 | -0.109098976848 | -0.109098976848 | -0.109099 | 0.16948 |
| 0.07 | -0.109963410953 | -0.109963410953 | -0.109963 | 0.16946 |
| 0.05 | -0.110370137249 | -0.110370137249 | -0.110370 | 0.16945 |
| 0.03 | -0.110641264520 | -0.11064126452 | -0.110641 | 0.16945 |
| 0.02 | -0.110725987918 | -0.110725987918 | -0.110726 | 0.16944 |
| 0.01 | -0.110776821070 | -0.11077682107 | -0.110777 | 0.16944 |
| 0.005 | -0.110789529255 | -0.110789529255 | -0.110790 | 0.16944 |
| 0.001 | -0.110793595865 | -0.110793595865 | -0.110794 | 0.16944 |

err/h² → $f'''(1)/6 = 0.169442$ (constant), confirming second order. Legacy animation frames print -0.049354 (h=0.6), -0.083592 (h=0.4), -0.104010 (h=0.2), -0.109709 (h=0.08), -0.110523 (h=0.04), -0.110783 (h=0.008), -0.110794 (h=0.001); the shared values agree with the script.

*Picture.* Frames 1 (full size) and all 12 on the contact sheet viewed. Orange stencil points at $x_0-h, x_0, x_0+h$ on the black curve; dashed blue chord passes through the outer two; dotted purple line through the centre point is parallel to the chord and tangent to the green parabola, which passes through all three points; red tangent has slope $f'(1)$. All elements lie within ylims $[-0.1,0.55]$ (lowest drawn value: parabola at x=1.9, h=0.6, ≈0.089). Legend entries match the plotted quantities; title h, slope and true value match the table. Regenerated GIF byte-identical to committed.

### Could not determine
- Example 11's own solution graphs (archive gr_264-282) are missing from the archive; I relied on the linked legacy Animation 6 (`CentralD2.2f/CentralDfaa.gif`) for what Ex 11 draws (the chord through $x_0\pm h$), which the page's Case 2 includes.

