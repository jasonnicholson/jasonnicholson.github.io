# Cubic Splines — animation review (round 6)

Page: `pages/numerical-methods/cubic-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor findings.

One cosmetic observation does not count as a finding. In the 6-, 7- and 9-node frames, the right edge of the plot cuts off the title's closing parenthesis, for example "(max err ≈ 0.00896". All digits of the error value are still visible, so nothing a viewer reads is changed.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `cubicsplineaa.jl` | 0 | 5.5 | cubicsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description | "piecewise-cubic interpolant … each panel polynomial S_i(x) interpolates endpoint values" | The script's spline reproduces the data at the nodes to ≤2.2e-16 for every n (`instr.jl`, `nodeerr`). | confirmed |
| D2 | Description | "enforces continuity of S, S', S'' at interior knots" | `smooth.jl`: jump in S = 0, in S' ≤ 2.8e-9 and in S'' ≤ 1.1e-8 (finite-difference noise) for n=4, 6, 9. | confirmed |
| D3 | Description | Natural BC: S''(x0)=0, S''(xn)=0 | The script sets M[1]=M[end]=0. `smooth.jl` measures S''(ends) = (0.0, 0.0). | confirmed |
| D4 | Description | "unknown second derivatives are found from a tridiagonal linear system, then each cubic panel is reconstructed" | Script lines 19–31 build the (h_j, 2(h_j+h_{j+1}), h_{j+1}) system for M[2..n] and solve it with a dense `A\b`; lines 35–45 use the standard M-form panel formula. The M vectors match SciPy `CubicSpline(bc_type='natural')` to 6 decimals (table below). | confirmed |
| D5 | Description | Clamped or not-a-knot: max error O(h⁴) | `indep.py`, cos on [0,2π]: clamped ratios 16.2, 16.1, 16.0 and not-a-knot 15.0, 15.7, 15.9 per halving. exp on [0,1]: clamped 15.9, 16.0, 16.0 and not-a-knot 15.5, 15.7, 15.9. | confirmed |
| D6 | Description | Natural: "only O(h²) unless f''(a)=f''(b)=0; that error sits near an end where f''≠0" | cos on [0,2π]: max-error ratios 4.25, 4.06, 4.02, 4.00, 4.00, with the maximum at x=0.0093…0.15 or near 2π. exp on [0,1]: ratios 3.99–4.00, with the maximum at x≈0.95–0.9985 (f''(1)=e≠0, f''(0)=1≠0, and the error is larger at the right end). | confirmed |
| D7 | Description | "away from the ends the error is still O(h⁴)" | cos, interior [25%,75%]: ratios 16.36, 16.06, 16.01, 16.00. exp: settles to 18.05, 15.94, 15.96. | confirmed |
| A1 | Animations intro | Natural cubic spline, equally spaced data from sin(x) on [0,2π] | Script lines 47, 54 (`range(0, 2π, length=nn)`) and 56 (`natural_spline_M`). | confirmed |
| A2 | Animations intro | "with the number of nodes increasing" | `n_node_list = [3,4,5,6,7,9]` (line 51). The frame titles read 3, 4, 5, 6, 7, 9. | confirmed |
| A3 | Animations intro | "natural spline satisfies S''(a)=S''(b)=0" | See D3. | confirmed |
| A4 | Animations intro | "Julia source scripts … linked under each case" | One case, linked to `cubicsplineaa.jl`. | confirmed |
| A5 | Animations intro | "Mathews' Cubic Splines module has no animation" | The archive module has no animation reference, and no spline animation turned up under `a2001/Animations/`. | confirmed |
| A6 | Animations intro | sin(x) example is new; "module's examples interpolate a table of data points with no underlying function" | Archive data (`gr_25`) is (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1), with no function given. | confirmed |
| A7 | Animations intro | Examples 1–3: natural (Ex 1), natural with SplineFit (Ex 2), clamped (Ex 3), "through one shared set of data points", not animated | Archive text matches. The data-point images `gr_25`, `gr_34` and `gr_53` are byte-identical (md5 20be64a4…). | confirmed |
| C1 | Case 1 heading | "Natural cubic spline convergence for sin(x)" | See D4 and A1. | confirmed |
| C2 | Behavior | "Adding nodes shrinks the maximum error rapidly" | Max error 1.0, 0.1088, 0.02002, 0.008965, 0.004071, 0.001066, strictly decreasing by about 940× over the six frames. | confirmed |
| C3 | Behavior | "natural end conditions are exact, since sin''(0)=sin''(2π)=0" | True: −sin(0) = −sin(2π) = 0. | confirmed |
| C4 | Behavior | "converges at O(h⁴), where h is the maximum node spacing" | Script and SciPy, n=17→33→65→129→257: ratios 16.23, 16.06, 16.01, 16.00 per halving of h. | confirmed |
| C5 | Behavior | "for smooth f with f''(a)≠0 or f''(b)≠0 … only O(h²)" | See D6. | confirmed |
| C6 | Behavior | "The 3 to 9 nodes shown are too few for this rate to show cleanly from frame to frame" | Observed orders between consecutive frames are 5.88 (4→5), 3.60 (5→6), 4.33 (6→7) and 4.66 (7→9). The 5→9 step halves h and gives a ratio of 18.8 against 16. The scatter around 4 is visible, so the hedge is accurate. | confirmed |
| C7 | Behavior | "Each frame uses a fully recomputed spline (solving the tridiagonal second-derivative system)" | Lines 54–57 recompute xs, ys, M and S inside the loop for each nn. | confirmed |
| W1 | Source link | `[Julia source](cubicsplineaa.jl)` is this case | It is the only script, and it writes `cubicsplineaa.gif`. | confirmed |
| W2 | Embed | `cubicsplineaa.gif` is produced by that script | Per the manifest, the scratch regeneration is byte-identical to the committed GIF. | confirmed |
| W3 | Alt text | "Natural cubic spline approximating sin(x) on [0, 2pi] with n=3,4,5,6,7,9 nodes" | The frame titles show 3, 4, 5, 6, 7, 9 nodes. Interval and function match. | confirmed |
| W4 | Alt text | "the spline closely tracks the true curve as nodes increase" | In the frames, the 3-node spline is flat zero (all data are 0) and from 5 nodes onward it is visually on top of sin(x). The errors are given in C2. | confirmed |
| F1 | Frame titles | "max err ≈ 1.0 / 0.109 / 0.02 / 0.00896 / 0.00407 / 0.00107" | 600-point grid values: 0.9999966, 0.108771, 0.0200168, 0.0089649, 0.0040706, 0.0010661. A 200001-point grid gives 1.0, 0.108771, 0.0200170, 0.0089651, 0.0040708, 0.0010661. SciPy agrees. All six agree to 3 significant figures. | confirmed |
| F2 | Legend | blue = f(x)=sin(x), red dashed = S(x), black dots = data nodes | Script lines 67–70 match the frames. The dots sit at sin(x_i), verified visually in frames 1, 4 and 6. | confirmed |

The page states no other numerical claims.

### 3. Implementation checks: `cubicsplineaa.jl`

**It is the method it claims to be.** The script runs a natural cubic spline in second-derivative (M) form. The interior equations h_j M_j + 2(h_j+h_{j+1}) M_{j+1} + h_{j+1} M_{j+2} = 6[(y_{j+2}−y_{j+1})/h_{j+1} − (y_{j+1}−y_j)/h_j] have M_0 = M_n = 0. Evaluation uses the standard M-form panel formula. It solves the tridiagonal system with a dense solver, which is a valid implementation choice. It is not a clamped or not-a-knot spline, and it is not a simplification.

**The numbers are right.** I instrumented a scratch copy (`review/instr.jl`, plotting removed) and compared it with SciPy `CubicSpline(xs, sin(xs), bc_type='natural')` (`review/indep.py`).

| n | Script M (interior) | SciPy M (interior) | Script max err (fine grid) | SciPy max err |
|---|---|---|---|---|
| 3 | 0 | 0 | 1.0 | 1 |
| 4 | −1.184581, 1.184581 | −1.184581, 1.184581 | 0.10877104 | 0.108771 |
| 5 | −1.215854, 0, 1.215854 | same | 0.02001701 | 0.020017 |
| 6 | −1.081379, −0.668329, 0.668329, 1.081379 | same | 0.00896508 | 0.00896508 |
| 7 | −0.947665, −0.947665, 0, 0.947665, 0.947665 | same | 0.00407079 | 0.00407079 |
| 9 | −0.74415, −1.052387, −0.74415, 0, 0.74415, 1.052387, 0.74415 | same | 0.00106609 | 0.00106609 |
| 17/33/65/129 | — | — | 6.312e-5 / 3.889e-6 / 2.422e-7 / 1.512e-8 | 6.312e-5 / 3.889e-6 / 2.422e-7 / 1.512e-8 |

I also checked properties whose outcome does not depend on remembering a formula:
- The spline interpolates the data at every node to ≤2.2e-16.
- S, S' and S'' are continuous at the knots: jumps are 0, ≤2.8e-9 and ≤1.1e-8 (finite-difference noise).
- S''(ends) is 0.
- The error ratio per halving of h tends to 16.00, which is fourth order, as expected for natural BCs when f''(a)=f''(b)=0.

**Its reference values are right.** The reference is sin(x) itself, evaluated exactly. Measuring the maximum error on a 600-point grid instead of a 200001-point grid changes it by at most 2e-7 relative to the values, which is below the 3 significant figures displayed.

**The picture shows what was computed.**
- In the frames I viewed (1, 4 and 6, plus all six on the contact sheet), the blue curve is sin(x), the red dashed curve is S(x) evaluated from the computed M, and the black dots are at (x_i, sin x_i).
- The red curve passes through every dot.
- In the 3-node frame, every node value is 0 (sin 0, sin π ≈ 1.2e-16, sin 2π), so the spline is identically zero, as drawn. The title's error of 1.0 is the true maximum |sin x| = 1.
- The axis limits [0,2π] × [−1.4,1.4] contain everything. No clamping or NaN masking is used.
- There are 6 frames at 2 fps, matching `n_node_list`.
- The only display defect is the clipped closing parenthesis noted above, which is cosmetic.

**Legacy fidelity.**
- The archive module has three worked examples (natural, natural via SplineFit, clamped) on the data (0,1)…(6,1) and no animation.
- The page says this explicitly, gives its reason for using sin(x) (a closed form, so the error can be reported), and lists the unanimated examples accurately.
- Nothing is dropped silently, so I have no Fidelity finding.

