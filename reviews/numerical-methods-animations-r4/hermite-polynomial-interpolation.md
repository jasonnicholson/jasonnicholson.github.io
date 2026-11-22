# Hermite Polynomial Interpolation — animation review (round 4)

Page: `pages/numerical-methods/hermite-polynomial-interpolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding. Every checkable claim on the page agrees with independent computation and with the frames, and both scripts implement the method they name. The evidence is in sections 2 and 3.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `hermitepolyaa.jl` | 0 | 4.9 | hermitepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `hermitepolybb.jl` | 0 | 7.1 | hermitepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Hermite interpolation matches "both function values and first derivatives at interpolation nodes" | Basis table (case2.py): H00, H10, H01, H11 each equal 1 in exactly one of {value at 0, d/dt at 0, value at 1, d/dt at 1} and 0 in the other three. Case 1 node residual 0.0 and one-sided slopes = cos(x_k) to 5 dp | confirmed |
| D2 | Description | $H(x)=y_0H_{00}(t)+hy_0'H_{10}(t)+y_1H_{01}(t)+hy_1'H_{11}(t)$ with $h=x_1-x_0$, $t=(x-x_0)/h$ | Same formula in `hermitepolyaa.jl` L25–31 and `hermitepolybb.jl` L19–27. The factor h is correct because the basis derivatives are taken in t. I checked this with sympy: the derivative in x at x=1 and x=3 equals the prescribed 1 and 2 | confirmed |
| D3 | Description | "In piecewise form ... a smooth $C^1$ approximation" | `aa_instr.jl`: left and right finite-difference slopes at every interior node agree with cos(x_k) to 5 dp for n = 2, 4, 8 | confirmed |
| A1 | Animations intro | interpolates values **and** first derivatives at endpoint nodes; Lagrange uses only values | as D1 | confirmed |
| A2 | Animations intro | "Julia source scripts ... are linked under each case" | two links, one under each case | confirmed |
| A3 | Animations intro | "Mathews' Hermite polynomial module has no animation" | no animated GIF in the module, and no `*herm*` under `a2001/Animations/` | confirmed |
| A4 | Animations intro | Case 1 ($\sin x$ on $[0,2\pi]$) is the site's own example | the module's examples are Ex. 1 (Hermite cubic) and Ex. 2/3 (splines); there is no sin example | confirmed |
| A5 | Animations intro | Case 2 uses the endpoint data of the module's Example 1 | archive `gr_18`: p(1)=2, p'(1)=1, p(3)=1, p'(3)=2; script L16–18 match | confirmed |
| A6 | Animations intro | Examples 2 and 3 are a clamped and a natural cubic spline through given knots, not animated here | lnk_3 / lnk_4 text: "clamped cubic spline", "natural cubic spline". Disclosed omission, so not a fidelity finding | confirmed |
| C1-1 | Case 1 heading | piecewise cubic Hermite for $\sin(x)$, refining the mesh | `f(x)=sin(x)`, `df=cos`, n = 1, 2, 4, 8 on [0, 2π] (L36–43) | confirmed |
| C1-2 | Case 1 Behavior | $n$ subintervals, each a cubic matching $f$ and $f'$ at its two endpoints | L43–47 and D1/D3 checks | confirmed |
| C1-3 | Case 1 Behavior | max errors in the four frames are 0.425, 0.215, 0.0108, 0.000906 | script (600-pt grid): 0.4253746, 0.2146006, 0.0107905, 0.00090620. Independent (scipy `CubicHermiteSpline`, 600-pt grid): 0.425375, 0.214601, 0.0107905, 0.000906198. True continuous max (dense grid + bounded optimisation per subinterval): 0.425382, 0.214602, 0.0107907, 0.000906216 | confirmed |
| C1-4 | Case 1 Behavior | doublings divide error by about 2.0, 19.9, 11.9 | 1.982, 19.89, 11.91 | confirmed |
| C1-5 | Case 1 Behavior | error is $O(h^4)$ for smooth $f$ | standard result; the ratio tends to 16 (next line) | confirmed |
| C1-6 | Case 1 Behavior | ratio approaches 16 only on finer meshes: 15.0 (8→16), 15.7 (16→32), 15.9 (32→64) | 14.96, 15.74, 15.94 (true max: 14.96, 15.74, 15.93) | confirmed |
| C1-7 | Case 1 Behavior | these coarse meshes are not yet in the asymptotic range | ratios 1.98, 19.9, 11.9 against limit 16 | confirmed |
| C1-8 | Case 1 "four frames" | four frames | committed GIF has 4 frames; `n_intervals_list = [1,2,4,8]` | confirmed |
| C1-9 | Case 1 link/embed | `hermitepolyaa.jl` / `hermitepolyaa.gif` is this case | script produces this GIF; regenerated copy is byte-identical (manifest) | confirmed |
| C1-10 | Case 1 alt text | n=1,2,4,8; max error falls from 0.425 at n=1 to 0.000906 at n=8 | frame titles read 0.425, 0.215, 0.0108, 0.000906 | confirmed |
| C2-1 | Case 2 heading | basis functions building the cubic with p(1)=2, p'(1)=1, p(3)=1, p'(3)=2 | script L16–18, L24–34 | confirmed |
| C2-2 | Case 2 Behavior | each basis function carries one degree of freedom (a value or derivative at an endpoint) | basis table in D1 | confirmed |
| C2-3 | Case 2 Behavior | weighted combination takes the prescribed values and slopes at both endpoints | sympy on the full sum: value 2, slope 1 at x=1; value 1, slope 2 at x=3 | confirmed |
| C2-4 | Case 2 Behavior | $h=2$, slope weights $hy_0'=2$, $hy_1'=4$ | L19, L25, L27 | confirmed |
| C2-5 | Case 2 Behavior | result $H(x)=x^3-\tfrac{23}{4}x^2+\tfrac{19}{2}x-\tfrac{11}{4}$, the cubic of Mathews' solution | sympy, solving the 4×4 system directly: same polynomial. Archive `gr_28`: {a→1, b→−23/4, c→19/2, d→−11/4}. Script's final stage minus this closed form: max 7.1e-15 | confirmed |
| C2-6 | Case 2 Behavior | frames add the weighted terms one at a time and draw the running sum | `stages` L30–35 are cumulative and each frame plots one curve. Frames 1–4 show y₀H₀₀, then +H₁₀, +H₀₁, +H₁₁ | confirmed |
| C2-7 | Case 2 Behavior | prescribed tangent lines as short dotted segments | L38–40, L52–54: gray `:dot`, x ∈ [a±0.25] and [b±0.25] with slopes 1 and 2 through (1,2) and (3,1). Visible in every frame | confirmed |
| C2-8 | Case 2 Behavior | first two partial sums fall to 0 with zero slope at $x=3$, because $H_{00},H_{10}$ have zero value and slope there | sympy: partial 1 and partial 2 have value 0 and d/dx 0 at x=3. H00(1)=H00'(1)=H10(1)=H10'(1)=0. Frames 1–2 end flat at y=0, inside the y-limit −0.2 | confirmed |
| C2-9 | Case 2 link/embed | `hermitepolybb.jl` / `hermitepolybb.gif` is this case | byte-identical regeneration (manifest); frames match the parameters | confirmed |
| C2-10 | Case 2 alt text | running sum of four weighted terms, one per frame, ending in the complete cubic that meets the dotted tangent segments at both endpoints | frame 4: orange curve through (1,2) and (3,1), tangent to both dotted segments; 4 frames | confirmed |

---

### 3. Implementation checks

### `hermitepolyaa.jl` (Case 1)

- **Method.** This is piecewise cubic Hermite interpolation with the exact derivatives `cos` at uniform nodes. The basis polynomials (L10–13) are the standard ones; I verified their 16 endpoint value/derivative conditions in sympy. The interval search uses `searchsortedlast` clamped to [1, n], so the right endpoint 2π falls in the last interval with t = 1. This is correct.
- **Numbers.** Instrumented copy `review/aa_instr.jl` against independent scipy `CubicHermiteSpline` (`review/indep.py`):

  | n | script err (600 pts) | scipy err (600 pts) | true max (continuous) | script rounding in title |
  |---|---|---|---|---|
  | 1 | 0.42537459 | 0.425375 | 0.425382 | 0.425 |
  | 2 | 0.21460059 | 0.214601 | 0.214602 | 0.215 |
  | 4 | 0.01079052 | 0.0107905 | 0.0107907 | 0.0108 |
  | 8 | 0.00090620 | 0.000906198 | 0.000906216 | 0.000906 |

  The interpolant reproduces node values exactly (residual 0.0). Its one-sided slopes at every node equal cos(x_k) to 5 dp, which confirms both the derivative interpolation and C¹ continuity. The 600-point sampling underestimates the true maximum only in the 5th–6th significant figure, which does not affect any 3-s.f. number shown.
- **Reference.** The comparison curve is `sin` and the derivative data is `cos`, both exact.
- **Picture.** Frames 1–4 show sin (blue), H (red dashed) and the black nodes at the n+1 uniform points. The titles give the right n and error. For n=1 the interpolant leaves the origin along slope 1 and peaks near 0.6, which agrees with H = 2π(2t³−3t²+t). The axis limits (−1.4, 1.4) × [0, 2π] contain everything, and no clamping or masking is used.

### `hermitepolybb.jl` (Case 2)

- **Method.** This is the two-point cubic Hermite interpolant in the standard basis form, built up as a running sum.
- **Numbers.** Instrumented copy `review/bb_instr.jl` against `review/case2.py` (sympy):

  | stage | script value at x=1 / x=3 | script max on [1,3] | sympy partial sum | sympy max |
  |---|---|---|---|---|
  | 1: y₀H₀₀ | 2.0 / 0.0 | 2.0 | x³/2 − 3x² + 9x/2 | 2.0000 |
  | 2: +h y₀'H₁₀ | 2.0 / 0.0 | 2.10699 | 3x³/4 − 19x²/4 + 33x/4 − 9/4 | 2.1070 |
  | 3: +y₁H₀₁ | 2.0 / 1.0 | 2.15740 | x³/2 − 13x²/4 + 6x − 5/4 | 2.1574 |
  | 4: +h y₁'H₁₁ | 2.0 / 1.0 | 2.09805 (min 0.65427) | x³ − 23x²/4 + 19x/2 − 11/4 | 2.0980 (min 0.6543 at x≈2.629) |

  The final stage agrees with the closed form to within 7.1e-15.
- **Reference.** The target cubic is the unique solution of the four endpoint conditions. Solving the 4×4 linear system directly in sympy, which does not use the Hermite basis, gives the same polynomial. Mathews' solution (`gr_28`) and graph (`gr_31`, minimum ≈ 0.65 near x ≈ 2.6) agree with it.
- **Picture.** The tangent segments are built from the prescribed slopes: (0.75, 1.75)–(1.25, 2.25) and (2.75, 0.5)–(3.25, 1.5). Both segments and all partial sums (range 0 to 2.157) lie inside xlims (0.7, 3.3) and ylims (−0.2, 3.0). The frame titles name the term each frame adds, and the legends name the running sum.

### Fidelity

Case 2 reproduces Mathews' Example 1 exactly. Case 1 is new material, and the page says so. Examples 2–3, the splines, are omitted, and the page also says so. I have no fidelity finding.

