# Hermite Polynomial Interpolation — animation review (round 5)

Page: `pages/numerical-methods/hermite-polynomial-interpolation/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.

Every checkable claim on the page agrees with independent computation and with the frames (ledger below). Both scripts implement standard cubic Hermite interpolation correctly.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `hermitepolyaa.jl` | 0 | 6.2 | hermitepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `hermitepolybb.jl` | 0 | 5.7 | hermitepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description | $H(x)=y_0H_{00}(t)+hy_0'H_{10}(t)+y_1H_{01}(t)+hy_1'H_{11}(t)$ with $h=x_1-x_0$, $t=(x-x_0)/h$ | Same formula in `hermitepolyaa.jl` l.26-31 and `hermitepolybb.jl` l.19-27; sympy: basis values/derivatives at t=0,1 are H00 [1,0,0,0], H10 [0,1,0,0], H01 [0,0,1,0], H11 [0,0,0,1] (order: value@0, d/dt@0, value@1, d/dt@1), so with chain rule factor 1/h the formula interpolates y and y' | confirmed |
| D2 | Description | piecewise form gives a $C^1$ approximation preserving value and slope at each node | Instrumented aa: node value error 0.0 for all n; one-sided slope error at nodes ≤ 6e-8 (finite-difference step 1e-7) for n=1..64 | confirmed |
| A1 | Intro | cubic Hermite interpolates function values and first derivatives at endpoint nodes | as D1/D2 | confirmed |
| A2 | Intro (fidelity) | Mathews' module has no animation | No herm/clamp/spline file in `a2001/Animations/`; module HTML has no animation | confirmed |
| A3 | Intro (fidelity) | Case 1 (sin on [0,2π]) is the site's own example | Module's only examples are 1 (Hermite), 2 (clamped spline), 3 (natural spline) | confirmed |
| A4 | Intro (fidelity) | Case 2 uses endpoint data of module's Example 1 | `gr_18.gif`: p(1)=2, p'(1)=1, p(3)=1, p'(3)=2; script l.16-18 same | confirmed |
| A5 | Intro (fidelity) | Examples 2 and 3 are a clamped and a natural cubic spline, not animated | Module text and `lnk_3`, `lnk_4` | confirmed |
| C1-1 | Case 1 heading | Piecewise cubic Hermite for sin(x), refining the mesh | script l.36-45: f=sin, f'=cos, n=1,2,4,8 on [0,2π] | confirmed |
| C1-2 | Behavior | n subintervals, each cubic matching f and f' at its endpoints | D2 | confirmed |
| C1-3 | Behavior | max errors in the four frames 0.425, 0.215, 0.0108, 0.000906 | Script (600-pt grid): 0.425375, 0.214601, 0.0107905, 0.000906198. Independent scipy `CubicHermiteSpline`: 600-pt grid same; true sup (refined) 0.425382, 0.214602, 0.0107907, 0.000906216. Frame titles show 0.425, 0.215, 0.0108, 0.000906 | confirmed |
| C1-4 | Behavior | doublings divide the error by about 2.0, 19.9, 11.9 | 1.982, 19.89, 11.91 | confirmed |
| C1-5 | Behavior | error is $O(h^4)$; coarse meshes not yet asymptotic | ratios 1.98, 19.9, 11.9 then 14.96, 15.74, 15.94, 16.02 (n=64→128) → 16 | confirmed |
| C1-6 | Behavior | finer-mesh ratios 15.0 (8→16), 15.7 (16→32), 15.9 (32→64) | 14.96, 15.74, 15.94 (sup: 14.96, 15.74, 15.93) | confirmed |
| C1-7 | Behavior | "the four frames" | GIF has 4 frames | confirmed |
| C1-8 | Alt text | n=1,2,4,8 intervals; max error 0.425 at n=1 to 0.000906 at n=8 | frames 1 and 4 titles; C1-3 | confirmed |
| C1-9 | Link/embed | `hermitepolyaa.jl` / `hermitepolyaa.gif` are Case 1 | script header and output name; frames show sin and n=1..8 | confirmed |
| C2-1 | Case 2 heading | cubic with p(1)=2, p'(1)=1, p(3)=1, p'(3)=2 | script l.16-18 | confirmed |
| C2-2 | Behavior | four basis functions each carry one degree of freedom | D1 sympy table | confirmed |
| C2-3 | Behavior | weighted combination takes prescribed values and slopes at both endpoints | sympy: final partial sum has value 2, slope 1 at x=1; value 1, slope 2 at x=3 | confirmed |
| C2-4 | Behavior | h=2, slope weights $hy_0'=2$, $hy_1'=4$ | script h=b-a=2; 2·1=2, 2·2=4 | confirmed |
| C2-5 | Behavior | result $x^3-\tfrac{23}{4}x^2+\tfrac{19}{2}x-\tfrac{11}{4}$, the cubic of Mathews' solution | sympy solve of the 4 conditions: same; script's final curve differs from it by ≤ 7.1e-15 on its grid; Mathews `gr_28`/`gr_32`: a=1, b=-23/4, c=19/2, d=-11/4 | confirmed |
| C2-6 | Behavior | frames add weighted terms one at a time and draw the running sum | script l.30-35, l.55; frames 1-4 show one curve each, titles "y₀·H₀₀(t)", "+ h·y₀'·H₁₀(t)", "+ y₁·H₀₁(t)", "+ h·y₁'·H₁₁(t) = H(x)" | confirmed |
| C2-7 | Behavior | prescribed tangent lines as short dotted segments | l.38-40, 52-54: segments x∈[0.75,1.25], y 1.75→2.25 (slope 1 through (1,2)); x∈[2.75,3.25], y 0.5→1.5 (slope 2 through (3,1)); dotted grey in frames | confirmed |
| C2-8 | Behavior | first two partial sums fall to 0 with zero slope at x=3 because H00, H10 have zero value and slope there | sympy: partial 1 and 2 value 0, slope 0 at x=3; frames 1-2 end flat at y=0 (inside ylims −0.2..3) | confirmed |
| C2-9 | Alt text | running sum of four weighted terms, one per frame, complete cubic meets dotted tangent segments at both endpoints | 4 frames; frame 4 curve tangent to both segments | confirmed |
| C2-10 | Link/embed | `hermitepolybb.jl` / `hermitepolybb.gif` are Case 2 | header, output name, frames | confirmed |
| C2-11 | Frame legend | "prescribed slopes y₀' = 1, y₁' = 2", "endpoints (1, 2), (3, 1)" | script data | confirmed |

### 3. Implementation checks

### `hermitepolyaa.jl`
- **Method:** piecewise cubic Hermite interpolation with the standard basis (l.10-13) scaled by local h for the derivative terms (l.28-31); interval lookup by `searchsortedlast` clamped to [1,n] so x=2π uses the last interval at t=1. This is the method named.
- **Numbers:** instrumented copy `review/aa_instr.jl` (functions copied verbatim, plotting removed) vs independent `review/indep.py` (scipy `CubicHermiteSpline`):

  | n | script err (600 pts) | scipy err (600 pts) | true sup |
  |---|---|---|---|
  | 1 | 0.4253746 | 0.425375 | 0.425382 |
  | 2 | 0.2146006 | 0.214601 | 0.214602 |
  | 4 | 0.0107905 | 0.0107905 | 0.0107907 |
  | 8 | 0.000906198 | 0.000906198 | 0.000906216 |
  | 16 | 6.0584e-5 | 6.0584e-5 | 6.05856e-5 |
  | 32 | 3.84861e-6 | 3.84861e-6 | 3.84958e-6 |
  | 64 | 2.41477e-7 | 2.41477e-7 | 2.41588e-7 |

  Interpolant reproduces node values exactly and node slopes to finite-difference precision. Grid sampling does not change any value at 3 significant figures.
- **Reference values:** reference is sin(x) itself, evaluated exactly; derivative cos(x) correct.
- **Picture:** frames 1-4 show blue sin, red dashed H, black nodes at n+1 equispaced points; titles carry the right n and error. ylims ±1.4 contain all curves (n=1 interpolant peaks ≈ 0.605). No clamping/masking.

### `hermitepolybb.jl`
- **Method:** single-interval cubic Hermite in the same basis on [1,3], built as cumulative weighted sums. Correct.
- **Numbers:** instrumented `review/bb_instr.jl`: final sum vs $x^3-\frac{23}{4}x^2+\frac{19}{2}x-\frac{11}{4}$ max diff 7.1e-15; partial-sum endpoints (start, end) = (2,0), (2,0), (2,1), (2,1); maxima 2.000, 2.107, 2.157, 2.098; final min 0.6543. Independent sympy partial sums: $\tfrac12x^3-3x^2+\tfrac92x$; $\tfrac34x^3-\tfrac{19}{4}x^2+\tfrac{33}{4}x-\tfrac94$; $\tfrac12x^3-\tfrac{13}{4}x^2+6x-\tfrac54$; final cubic, with min/max on [1,3] 0/2, 0/2.1070, 1/2.1574, 0.6543/2.0980, matching the script.
- **Reference values:** Mathews' Example 1 data and solution (archive `gr_18`, `gr_28`, `gr_32`) match the script data and the computed cubic.
- **Picture:** each frame draws only the running sum; tangent segments are built from the prescribed slopes through the endpoints; all curves inside xlims (0.7, 3.3) and ylims (−0.2, 3.0). Frame 4 matches the shape of Mathews' graph `gr_31` (max ≈ 2.1 near x≈1.2, min ≈ 0.65 near x≈2.6).

### Notes (not findings)
- The page's Case 1 error figures are measured on the script's 600-point plot grid, not the true supremum; the difference is below the stated precision for every value quoted.

