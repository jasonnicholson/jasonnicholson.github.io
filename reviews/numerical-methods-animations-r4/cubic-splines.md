# Cubic Splines — animation review (round 4)

Page: `pages/numerical-methods/cubic-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed by computation or by the frames, and the script's computation agrees with an independent implementation to rounding level.

Observations that are not findings (recorded so the clean result can be trusted):

- The right edge of the title clips the closing parenthesis in frames 4–6 (for example "max err ≈ 0.00896" followed by a partly cut ")"). All digits remain readable, so a viewer would not draw a different conclusion. This is cosmetic only.
- Frame 1 (3 nodes) shows the spline as the zero line. That is correct. The data are sin(0), sin(π) and sin(2π), all 0 to within 1.2e-16, so M = [0,0,0] and S ≡ 0. The reported max error of 1.0 is the true value.
- The page leaves out Mathews' Examples 1–3, but it says so and gives the reason (lines 29–30). Because the omission is disclosed rather than silent, it is not a Fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `cubicsplineaa.jl` | 0 | 5.1 | cubicsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description l.12 | piecewise-cubic interpolant on nodes x0<…<xn; each panel polynomial S_i interpolates endpoint values | Script reproduces data at nodes (max node error ≤ 2.2e-16 for all n) | confirmed |
| D2 | l.12–13 | continuity of S, S′, S″ at interior knots | Script S matches scipy's C² natural spline to ≤4.4e-16 on 600 points for every frame. In scipy's piecewise coefficients the S′ and S″ jumps at interior knots are ≤1.2e-16 and ≤5e-14 | confirmed |
| D3 | l.15–19 | natural BC S″(x0)=S″(xn)=0 | Script sets M[1]=M[end]=0 (lines 29–30); scipy S″ at ends ≈ 1e-16 | confirmed |
| D4 | l.21 | unknown second derivatives from a tridiagonal system, then panels reconstructed | Script lines 11–32 (tridiagonal M-system), 35–45 (standard M-form panel formula). M vectors equal scipy's `cs(xs,2)` to 6 decimals (e.g. n=6: [0, −1.081379, −0.668329, 0.668329, 1.081379, 0]) | confirmed |
| D5 | l.21 | clamped (exact f′) or not-a-knot: max error O(h⁴) | exp on [0,1], h halved 9→129 nodes: clamped p = 3.98, 3.99, 4.00, 4.00; not-a-knot p = 3.91, 3.95, 3.98, 3.99 | confirmed |
| D6 | l.21 | natural: only O(h²) unless f″(a)=f″(b)=0 | cos on [0,2π]: p_max = 2.09, 2.02, 2.01, 2.00, 2.00; exp on [0,1]: p_max = 2.00 (×5); sin (f″=0 at both ends): p = 4.08, 4.02, 4.01, 4.00 | confirmed |
| D7 | l.21 | that error sits near an end where f″≠0; away from ends still O(h⁴) | location of the maximum error: cos x = 0.0093 to 0.15 or near 2π; exp x → 1. Middle-half max error order: cos 4.03, 4.01, 4.00, 4.00; exp 4.17, 3.99, 4.00 (the pre-asymptotic 5.8 and 8.8 come from a sign change of the interior error) | confirmed |
| A1 | Animations l.25 | natural cubic spline fitted to equally-spaced data from sin(x) on [0,2π] | script l.47, 54 `range(0, 2π, length=nn)`, `natural_spline_M` | confirmed |
| A2 | l.25 | number of nodes increasing | `n_node_list = [3,4,5,6,7,9]` | confirmed |
| A3 | l.25 | natural spline satisfies S″(a)=S″(b)=0 | see D3 | confirmed |
| A4 | l.27 | Julia source scripts linked under each case | one case, link `cubicsplineaa.jl` present; regenerated GIF byte-identical to committed (manifest + `cmp`) | confirmed |
| A5 | l.29 | Mathews' Cubic Splines module has no animation | `CubicSplinesMod.html` has 0 occurrences of "anim". The only spline animation in `a2001/Animations` is `Quadrature/Spline/Splineaa`, which Animations7.html links to `SplineQuadMod.html` (spline quadrature), not to this module | confirmed |
| A6 | l.29 | sin(x) example is new, not from the module; the module's examples interpolate a data table with no underlying function | The data images for Examples 1–3 (gr_25, gr_34, gr_53) all read (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1), with no generating function | confirmed |
| A7 | l.30 | Examples 1 and 2 natural (2nd uses SplineFit), Example 3 clamped, one shared set of data points; not animated here | Module text: Ex.1 "natural cubic spline", Ex.2 "natural … Use Mathematica's procedure SplineFit", Ex.3 "clamped cubic spline". All three use the same points (above), and Ex.3 has S′(0)=−0.2, S′(6)=−2.5 (gr_54) | confirmed |
| C1 | Case heading l.32 | natural cubic spline convergence for sin(x) | see A1 | confirmed |
| C2 | Behavior l.34 | adding nodes shrinks the maximum error rapidly | script/independent max err: 1.0, 0.109, 0.0200, 0.00896, 0.00407, 0.00107 (monotone, ~1000× over the run) | confirmed |
| C3 | l.34 | natural end conditions are exact since sin″(0)=sin″(2π)=0, so the spline converges at O(h⁴) | see D6 (sin p → 4.00) | confirmed |
| C4 | l.34 | h is the maximum node spacing | equal spacing, h = 2π/(n−1) | confirmed |
| C5 | l.34 | for smooth f with f″(a)≠0 or f″(b)≠0 natural spline falls only as O(h²) | see D6 | confirmed |
| C6 | l.34 | 3 to 9 nodes are too few for this rate to show cleanly frame to frame | observed local order between successive frames, log(e_k/e_{k+1})/log(h_k/h_{k+1}): 5.47, 5.88, 3.60, 4.33, 4.66 (scattered, not a clean 4) | confirmed |
| C7 | l.34 | each frame uses a fully recomputed spline solving the tridiagonal second-derivative system | script l.53–57: `natural_spline_M` called inside the loop for each nn | confirmed |
| C8 | Alt text l.38 | natural spline approximating sin(x) on [0,2π] with n=3,4,5,6,7,9 nodes | frame titles read 3,4,5,6,7,9 nodes; 6 frames | confirmed |
| C9 | Alt text | spline closely tracks the true curve as nodes increase | frames 3–6 show the dashed S overlapping sin. Errors as in C2 | confirmed |
| F1 | GIF titles | "max err ≈ 1.0 / 0.109 / 0.02 / 0.00896 / 0.00407 / 0.00107" | independent scipy on a 200001-point grid: 1.000000, 0.1087710, 0.02001701, 0.008965082, 0.004070786, 0.001066088. All agree at 3 significant figures | confirmed |
| F2 | GIF legend | blue f(x)=sin(x), red dashed S(x) cubic spline, black data nodes | plotting code l.67–70; frames show markers at the nodes on the curve | confirmed |
| W1 | Wiring | link and embed are this case's script and GIF | `[Julia source](cubicsplineaa.jl)`, `![…](cubicsplineaa.gif)`. The script writes `cubicsplineaa.gif`. Manifest: linked from section index | confirmed |

### 3. Implementation checks: `cubicsplineaa.jl`

**It is the method it claims to be.** It is a natural cubic spline in the standard second-derivative (M) formulation. Interior rows are `h_{j} M_{j} + 2(h_j+h_{j+1}) M_{j+1} + h_{j+1} M_{j+2} = 6[(y_{j+2}−y_{j+1})/h_{j+1} − (y_{j+1}−y_j)/h_j]` with M at both ends fixed to 0 (l.11–32). Evaluation uses the standard M-form piecewise cubic (l.35–45). The interval search clamps to [1,n], so x = 2π uses the last panel. The 3-node case gives a 1×1 system, which is handled correctly. This is not a neighbouring variant: the end conditions are natural, as the page says.

**The numbers are right.** Instrumented copy `review/inst.jl`, with the script's functions copied verbatim and the plotting removed:

| n | h | script err (600 pts) | script title | scipy natural err (600 pts) | scipy err (200001 pts) | script node residual |
|---|---|---|---|---|---|---|
| 3 | 3.141593 | 9.999966e-01 | 1.0 | 9.999966e-01 | 1.000000e+00 | 2.5e-32 |
| 4 | 2.094395 | 1.087710e-01 | 0.109 | 1.087710e-01 | 1.087710e-01 | 2.2e-16 |
| 5 | 1.570796 | 2.001682e-02 | 0.02 | 2.001682e-02 | 2.001701e-02 | 2.5e-32 |
| 6 | 1.256637 | 8.964935e-03 | 0.00896 | 8.964935e-03 | 8.965082e-03 | 1.1e-16 |
| 7 | 1.047198 | 4.070606e-03 | 0.00407 | 4.070606e-03 | 4.070786e-03 | 2.2e-16 |
| 9 | 0.785398 | 1.066075e-03 | 0.00107 | 1.066075e-03 | 1.066088e-03 | 1.1e-16 |

I also compared values directly (`dump.jl`, then Python): max |S_script − S_scipy(bc_type='natural')| on the 600-point grid is 7e-32, 4.4e-16, 4.2e-16, 4.4e-16, 3.3e-16 and 3.3e-16 for n = 3, 4, 5, 6, 7, 9. Property check with the script's own routine at more nodes: errors 1.07e-3 (9), 6.31e-5 (17), 3.89e-6 (33), 2.42e-7 (65), 1.51e-8 (129). The ratios per halving are 16.9, 16.2, 16.06, 16.0, so the order is 4 as the page states.

**Its reference values are right.** The reference is the closed-form sin(x), used directly. The 600-point error sampling agrees with a 200001-point grid at the 3 significant figures displayed in every frame (largest relative discrepancy 1.6e-5 at n = 6).

**The picture shows what was computed.** I viewed frames 1, 4 and 6 at full size and the contact sheet of all six. Each frame plots sin and the S computed for that frame's nodes, with markers at (xs, sin xs). Axis limits [0,2π] × [−1.4,1.4] contain everything; there is no clamping or masking. The title's node count and error come from the same loop variables. There are 6 frames at fps = 2. The regenerated GIF is byte-identical to the committed one. The only visual flaw is the clipped closing parenthesis in the titles of frames 4–6, which does not hide any number.

