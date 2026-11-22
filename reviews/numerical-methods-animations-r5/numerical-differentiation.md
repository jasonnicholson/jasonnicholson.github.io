# Numerical Differentiation — animation review (round 5)

Page: `pages/numerical-methods/numerical-differentiation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, every number in the GIF titles, and every reference value was confirmed against an independent computation (sympy for the derivative, 50-digit mpmath for the difference quotients). Both committed GIFs are byte-identical to fresh scratch regenerations (`cmp` on both).

Observations that I judged are *not* findings (recorded so the owner can disagree):

- Case 1 (`numdiffaa.gif`): from h = 0.1 onward (frames 4–12) the blue D3 curve and the black f' curve cannot be told apart at the drawn line widths (max error ≤ 3.3e-3 against a y-range of 2.1). From then on, the only visible sign of convergence is the "max error" number in the title. The page's Behavior claim ("approaches f'(x) as h shrinks") is still true, and the title carries the evidence, so this is a presentation choice, not a misleading picture.
- Case 2 differs in how it draws Mathews' Example 14. Mathews draws the line of slope D through the centre point (x0, f(x0)) and adds the interpolating parabola through the three points, using H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01} on a window of [0, 2.1]. The page draws the chord through (x0 ± h, f(x0 ± h)), with no parabola, using 12 steps from 0.6 to 0.001 on [0, π]. The chord has the same slope and is a valid depiction, so I did not count it as a fidelity finding. Cross-check: Mathews' printed value at h = 0.01 is −0.110777, and the script gives −0.110777 (−0.11077682107).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `numdiffaa.jl` | 0 | 8.2 | numdiffaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `numdiffab.jl` | 0 | 7.7 | numdiffab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description ¶1 | "In the Mathews examples for this module, the test function is f(x)=e^{-x}sin(x)" | Legacy gr_27/262/325: f[x] = e^{-x} Sin[x]; both scripts line 9 `f(x)=exp(-x)*sin(x)` | confirmed |
| D2 | Description ¶1 | "on [0,π]" | Legacy gr_49/51: [0, π] (Ex 2(c)); script aa `xlims=(0.0, pi)` | confirmed |
| D3 | Description ¶1 | "representative steps h=0.1,0.01,0.001" | Legacy gr_45/47: h = 0.1, 0.01, 0.001 | confirmed |
| D4 | Description | D3(x,h) = (f(x+h) − f(x−h))/(2h) | Legacy gr_20 is the same formula; aa line 12 and ab line 34 implement it | confirmed |
| D5 | Description | "truncation error O(h^2) when f is sufficiently smooth" | Independent: max error / (h²/3) → 1.000 as h → 0 (Case 1); error / (h²/6·f'''(1)) → 1.000 (Case 2) | confirmed |
| D6 | Description | "eventually roundoff and cancellation can limit accuracy" | General statement, not tied to the animations. Within h ≥ 0.001 the roundoff is ≈1e-13, invisible, and the page does not claim the GIFs show it | confirmed (as a general statement) |
| D7 | Derivation Notes | f(x±h) = f ± h f' + h²/2 f'' ± h³/6 f'''(ξ±) | Taylor with Lagrange remainder of order 3; the signs are correct | confirmed |
| D8 | Derivation Notes | leads to the central rule "with error proportional to h^2" | Subtracting gives error −h²/12·(f'''(ξ+)+f'''(ξ−)); numerically err = (h²/6) f'''(1) to 6 digits at small h | confirmed |
| A1 | Animations intro | each animation is for f(x)=e^{-x}sin(x) | Both scripts line 9; GIF legend of Case 2 "f(x) = e^(-x) sin(x)" | confirmed |
| A2 | Animations intro | "on legacy interval settings from the source module" | Case 1 [0,π] = Ex 2(c). Case 2 point x0=1 = Ex 11/14 (gr_263/326 "f'[1.0]"); its plot window [0,π] is the module's Ex 2 interval (Mathews' own Ex 14 window was [0,2.1]) | confirmed |
| A3 | Animations ¶2 | Case 1 extends Ex 2(c), "the plot of D3(x,h) against f'(x) on [0,π]" | Legacy lnk_5: Plot D1[x,0.01] and f'[x] over {x,0,π} | confirmed |
| A4 | Animations ¶2 | "from the single step h=0.01 to a sequence of steps" | Legacy gr_48 "D1[x, 0.01]"; aa `hs` contains 0.01 among 12 steps | confirmed |
| A5 | Animations ¶2 | "Case 2 follows Examples 11 and 14, the central difference at x0=1" | Legacy Ex 11 (two-point central) and Ex 14 (three-point central), both f'[1.0]; ab `x0 = 1.0`. The Ex 11 solution images (gr_264–282) are missing from the archive, so its exact code was not viewed; Ex 14 code (gr_327) uses m = (f[X+H]−f[X−H])/(2H), the same formula | confirmed (Ex 11 code not viewable) |
| A6 | Animations ¶2 | Not animated: Ex 1 (graph of f''' for the error bound) | Legacy Ex 1 text | confirmed |
| A7 | Animations ¶2 | Not animated: Ex 2(a), 2(b) tables | Legacy Ex 2(a) f'[0], 2(b) f'[0..3] with h values | confirmed |
| A8 | Animations ¶2 | Not animated: Ex 3 (absolute error against the bound) and Ex 4 (how the bound shrinks with h) | Legacy Ex 3, Ex 4 text | confirmed |
| A9 | Animations ¶2 | Not animated: forward/backward first-derivative formulas, Ex 9, 10, 12, 13 | Legacy: 9 two-point forward, 10 two-point backward, 12 three-point forward, 13 three-point backward | confirmed |
| A10 | Animations ¶2 | Not animated: second-derivative formulas, Project II Ex 5–8 and Ex 15–17 | Legacy Project II = Ex 5–8; Ex 15–17 are second-derivative forward/backward/central | confirmed |
| A11 | Animations ¶2 (implicit) | the list accounts for every module example | Module examples are 1, 2(a–c), 3, 4, 5–8, 9–17; all are covered by A3/A5–A10 | confirmed |
| C1-1 | Case 1 heading | "central derivative profile, D3(x,h) on [0,π]" | aa line 12 is the central quotient; xlims (0, π); frame titles "Three-Point Central Difference on [0, pi]" | confirmed |
| C1-2 | Case 1 Behavior | "numerical derivative curve approaches f'(x) as h shrinks" | Max error decreases monotonically over the 12 frames, 8.13e-2 → 3.33e-7 (script and mpmath agree) | confirmed |
| C1-3 | Case 1 Behavior | "consistent with second-order truncation error" | maxerr/(h²/3) = 0.975, 0.991, 0.996, 0.999, … , 1.000; halving 0.01 → 0.005 gives a ratio of 4.000 | confirmed |
| C1-4 | Case 1 link | `[Julia source](numdiffaa.jl)` is Case 1 | the script computes D3 over [0,π] for varying h | confirmed |
| C1-5 | Case 1 embed | `numdiffaa.gif` is Case 1 | frames show D3 vs f' on [0,π]; byte-identical to the regenerated GIF | confirmed |
| C1-6 | Case 1 alt text | "three-point central derivative approximation against the true derivative over 0 to pi as h decreases" | frames 1, 6, 12 and the contact sheet; h goes 0.5 → 0.001 | confirmed |
| C2-1 | Case 2 heading | "secant to tangent at x0=1, h→0" | ab `x0 = 1.0`; h goes 0.6 → 0.001; frame 12 shows the chord on top of the tangent | confirmed |
| C2-2 | Case 2 Behavior | "slope from the symmetric secant (f(x0+h)−f(x0−h))/(2h)" | ab line 34 `msec = (yr - yl) / (2h)` with yl = f(x0−h), yr = f(x0+h) | confirmed |
| C2-3 | Case 2 Behavior | "converges to the tangent slope f'(x0) as the stencil contracts" | the error decreases monotonically, 6.14e-2 → 1.69e-7, with D = −0.0493537 → −0.1107936 against f'(1) = −0.1107937653 | confirmed |
| C2-4 | Case 2 link | `numdiffab.jl` is Case 2 | yes | confirmed |
| C2-5 | Case 2 embed | `numdiffab.gif` is Case 2 | frames show x0 = 1 with the secant and tangent; byte-identical to the regenerated GIF | confirmed |
| C2-6 | Case 2 alt text | "central secant lines through the points at x0 minus h and x0 plus h collapsing to the tangent line at x0 equals 1 for f of x equals e to the minus x times sine x" | ab line 38 builds the chord through (xl, yl) with slope msec, so it passes through (xr, yr); frames 1, 5, 12 | confirmed |
| G1 | Case 1 GIF titles | "max error ≈ …" for each h | see the table in §3; all 12 agree with mpmath to the 3 significant digits printed | confirmed |
| G2 | Case 2 GIF titles | "secant slope ≈ …, true = −0.110794" | see the table in §3; all 12 slopes agree to 6 decimals; f'(1) = −0.110793765 rounds to −0.110794 | confirmed |
| G3 | Counts | 12 frames per GIF | the manifest frame counts are 12 and 12; the `continue` in ab line 26 never fires (the largest h = 0.6 gives 0.4 ≥ 0 and 1.6 ≤ π) | confirmed |

### 3. Implementation checks

### `numdiffaa.jl` (Case 1)

1. **Method.** Line 12 `central3(x,h) = (f(x+h) - f(x-h))/(2h)` is the three-point central difference for f'. It is the method the page names. Line 10 `fp` equals the exact derivative: sympy gives `simplify(diff(f) - exp(-x)*(cos x - sin x)) = 0`.
2. **Numbers.** I instrumented the copy (`aa_instr.jl`) to print the max error per frame and set it beside a 50-digit mpmath computation on the same 700-point grid (`indep.py`):

| h | script max err | mpmath max err | location | h²/3 |
|---|---|---|---|---|
| 0.5 | 0.0812767083 | 0.081276708 | x≈0.027 | 0.0833 |
| 0.3 | 0.0297312685 | 0.029731268 | x≈0.009 | 0.0300 |
| 0.2 | 0.0132801083 | 0.013280108 | x≈0.0045 | 0.01333 |
| 0.1 | 0.0033299984 | 0.0033299984 | x=0 | 0.003333 |
| 0.07 | 0.0016325328 | 0.0016325328 | x=0 | 0.0016333 |
| 0.05 | 8.3312498e-4 | 8.3312498e-4 | x=0 | 8.3333e-4 |
| 0.03 | 2.99973e-4 | 2.99973e-4 | x=0 | 3.0e-4 |
| 0.02 | 1.333280e-4 | 1.33328e-4 | x=0 | 1.33333e-4 |
| 0.01 | 3.33330e-5 | 3.3333e-5 | x=0 | 3.33333e-5 |
| 0.005 | 8.333313e-6 | 8.3333125e-6 | x=0 | 8.33333e-6 |
| 0.002 | 1.3333328e-6 | 1.3333328e-6 | x=0 | 1.33333e-6 |
| 0.001 | 3.3333330e-7 | 3.333333e-7 | x=0 | 3.33333e-7 |

   Property check, independent of any remembered coefficient: f''' = 2√2 e^{−x} sin(x+π/4) (sympy) gives f'''(0) = 2. The leading error is therefore (h²/6)·2 = h²/3 at x = 0, where the error is largest, and the ratio is 1.0000 to 5 digits at small h. Halving h multiplies the error by 1/4, as second order requires. Mathews' Ex 3(b) also places the maximum error at x = 0, which agrees.
3. **Reference values.** The reference is the analytic f'(x) = e^{−x}(cos x − sin x), which sympy verified. The minimum of f' on [0,π] is −0.2078796 at x = π/2, and the script's grid minimum is −0.2078785, which is consistent.
4. **Picture.** Black is f', blue is D3, as the legend says. The title prints h and the max error correctly (the table above). The y-limits (−1, 1.1) contain both curves in every frame: max D3 = 1.0812 at h = 0.5, min D3 = −0.2079. There is no clamping or masking. D3 is evaluated at x = 0 using f(−h), which is legitimate because f is defined there (comment, line 23). Frames 1, 6 and 12 and the contact sheet were viewed.

### `numdiffab.jl` (Case 2)

1. **Method.** Line 34 `msec = (yr - yl)/(2h)` with yl = f(x0−h) and yr = f(x0+h) is the central difference at x0 = 1. Line 35 `mtan = fp(x0)` is the exact derivative.
2. **Numbers.** Instrumented copy (`ab_instr.jl`) against mpmath (`indep.py`):

| h | script D | mpmath D | error | (h²/6) f'''(1) |
|---|---|---|---|---|
| 0.6 | −0.0493537427 | −0.049353742675 | 0.06144 | 0.06100 |
| 0.4 | −0.0835918101 | −0.0835918101248 | 0.027202 | 0.027111 |
| 0.25 | −0.1001894114 | −0.10018941139 | 0.010604 | 0.010590 |
| 0.15 | −0.1069794600 | −0.106979459959 | 0.0038143 | 0.0038124 |
| 0.1 | −0.1090989768 | −0.109098976848 | 0.0016948 | 0.0016944 |
| 0.07 | −0.1099634110 | −0.109963410953 | 8.3035e-4 | 8.3027e-4 |
| 0.05 | −0.1103701372 | −0.110370137249 | 4.2363e-4 | 4.2361e-4 |
| 0.03 | −0.1106412645 | −0.11064126452 | 1.5250e-4 | 1.5250e-4 |
| 0.02 | −0.1107259879 | −0.110725987918 | 6.7777e-5 | 6.7777e-5 |
| 0.01 | −0.1107768211 | −0.11077682107 | 1.69442e-5 | 1.69442e-5 |
| 0.005 | −0.1107895293 | −0.110789529255 | 4.23605e-6 | 4.23605e-6 |
| 0.001 | −0.1107935959 | −0.110793595865 | 1.69442e-7 | 1.69442e-7 |

   Property check: the error matches the leading term (h²/6) f'''(1), with f'''(1) = 1.016652, to 5–6 digits at small h, which confirms order 2. The legacy cross-check also agrees: Mathews' Ex 14 printout gives −0.110777 at h = 0.01 and the script gives −0.11077682.
3. **Reference values.** f(1) = 0.309559875653 and f'(1) = −0.110793765307 (mpmath, matching the script). The title's "true = −0.110794" is correct to 6 decimals.
4. **Picture.** The dashed blue line (line 38) passes through (xl, yl) with slope msec, so it also passes through (xr, yr): it is the chord, as the legend says. The red tangent goes through (x0, f(x0)) with slope f'(x0). The orange stencil markers sit at x0−h, x0 and x0+h. The y-limits (−0.1, 0.55) contain the curve (max f = 0.3224 at π/4), both lines (secant y in [0.187, 0.409]) and all points. The `continue` guard on line 26 is never triggered, so all 12 frames are drawn. Frames 1, 5 and 12 were viewed: at h = 0.6 the chord is visibly flatter than the tangent, and by h = 0.001 the two coincide.

