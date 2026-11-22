# Cubic Splines — animation review

Page: [`pages/numerical-methods/cubic-splines/index.qmd`](../../pages/numerical-methods/cubic-splines/index.qmd) · Scripts: `cubicsplineaa.jl` · GIFs: 1

**Result:** 1 error, 1 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — "Natural cubic spline converges at O(h^4) for smooth functions" is false in general

- **Location:** index.qmd:31, "The natural cubic spline converges at $O(h^4)$ for smooth functions, where $h$ is the maximum node spacing."
- **Now:** The page says the natural spline is fourth-order for any smooth function.
- **True:** A natural spline imposes $S''(a)=S''(b)=0$. When the true $f''(a)$ or $f''(b)$ is nonzero, that end condition is wrong by $O(1)$, and the max-norm error falls only as $O(h^2)$. It is $O(h^4)$ only when $f''(a)=f''(b)=0$. The test function happens to meet that condition: $\sin''(0)=\sin''(2\pi)=0$. That is why the animation's case converges at fourth order, and the page does not say so. A reader will take away that natural splines are always $O(h^4)$.
- **Evidence:** `/usr/bin/python3 -I reviewer/scipy_check.py` uses scipy `CubicSpline(bc_type='natural')` and measures max error on 200001 points over $[0,2\pi]$:
  - sin(x): errors at nn = 9, 17, 33, 65, 129 nodes are 1.066e-3, 6.312e-5, 3.889e-6, 2.422e-7, 1.512e-8. Each halving of h divides the error by 16.89, 16.23, 16.06, 16.01, so O(h^4) holds for this case.
  - cos(x), whose f'' is -1 at both ends: errors at nn = 17 → 257 are 7.72e-3, 1.90e-3, 4.74e-4, 1.18e-4, 2.96e-5. The ratios are 4.25, 4.06, 4.02, 4.00, 4.00, so the order is O(h^2). With not-a-knot end conditions the same data gives ratios of about 16.
  - exp(x) with a natural spline: ratios 3.81, 3.95, 3.99, 4.00, 4.00, again O(h^2).
- **Suggested fix:** Replace the sentence with: "For sin(x) on [0, 2π] the natural end conditions happen to be exact, since sin''(0) = sin''(2π) = 0, so the spline converges at O(h^4). For a general smooth f with f''(a) ≠ 0 or f''(b) ≠ 0, the natural spline converges only at O(h^2), with the error concentrated near the ends. Clamped or not-a-knot end conditions restore O(h^4)."

- **Independent check:** confirmed with correction. Checker: cos x, exp x, 1/(1+x²), x³ and sin x on [0,π/2] all measure max-error rate 2.00 for the natural spline. Correction: the error stays O(h⁴) away from the ends and drops to O(h²) only near ends where f''≠0; the animation's 3–9 node frames are too coarse to show a clean rate either way.

### F2 — Misleading — Page match — Description gives O(h^4) right after defining only the natural spline

- **Location:** index.qmd:21, "For smooth functions, spline interpolation error typically scales like $O(h^4)$ with mesh spacing $h$." It follows lines 15–19, which present the natural boundary conditions as the spline's boundary conditions.
- **Now:** The only end condition the page defines is the natural one, and the next sentence says the error is "typically" O(h^4).
- **True:** O(h^4) holds for clamped spline conditions (exact f') and for not-a-knot conditions. A natural spline on generic smooth data is O(h^2), as the F1 evidence shows (cos and exp ratios → 4.00). Read in context, the sentence attributes O(h^4) to the natural spline.
- **Evidence:** Same as F1 (`reviewer/scipy_check.py`).
- **Suggested fix:** Change it to: "For smooth f with clamped (or not-a-knot) end conditions, the error scales like O(h^4); with natural end conditions it is only O(h^2) unless f''(a) = f''(b) = 0."

- **Independent check:** confirmed. Checker: clamped 4.00, not-a-knot 3.99, natural 2.00 on the same function.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `cubicsplineaa.jl` | yes | 2.7 | cubicsplineaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "piecewise-cubic interpolant built on nodes $x_0<\cdots<x_n$ so that each panel polynomial $S_i(x)$ interpolates endpoint values" | instr.jl: max \|S(x_i) − y_i\| ≤ 2.2e-16 for every frame | confirmed |
| 2 | 12–13 | "enforces continuity of $S$, $S'$, and $S''$ at interior knots" | instr.jl: max jump in S' at interior knots ≤ 3.3e-16, jump in S'' = 0, for every frame. S is continuous by construction (the formula gives y_i at both sides) | confirmed |
| 3 | 15–19 | Natural spline: $S''(x_0)=0,\ S''(x_n)=0$ | Script sets M[1]=M[end]=0 (lines 29–31). instr.jl prints S''(a)=S''(b)=0.0 in every frame | confirmed |
| 4 | 21 | "unknown second derivatives are found from a tridiagonal linear system, then each cubic panel is reconstructed" | Script lines 19–30 build the standard tridiagonal M-system (solved with dense `\`) and evaluate with the standard M-form panel formula (lines 42–44). M values match scipy natural `cs(xs,2)` to 12 digits | confirmed |
| 5 | 21 | "For smooth functions, spline interpolation error typically scales like $O(h^4)$" | True for clamped and not-a-knot. For natural on generic f the order is O(h^2) (cos ratios → 4.00) | wrong (→ F2) |
| 6 | 25 | "natural cubic spline fitted to equally-spaced data from $f(x)=\sin(x)$ on $[0,2\pi]$" | Script lines 47, 54: `range(0.0, 2π, length=nn)`, f = sin, natural M | confirmed |
| 7 | 25 | "with the number of nodes increasing" | n_node_list = [3,4,5,6,7,9]. Frames show 3,4,5,6,7,9 nodes in that order | confirmed |
| 8 | 25 | "The natural spline satisfies $S''(a)=S''(b)=0$ at the endpoints" | instr.jl: S''(a)=S''(b)=0.0 | confirmed |
| 9 | 29 | Heading: "Natural cubic spline convergence for $\sin(x)$" | Matches the script and frame titles | confirmed |
| 10 | 31 | "Adding nodes shrinks the maximum error rapidly" | Frame max errors 1.0, 0.109, 0.0200, 0.00896, 0.00407, 0.00107: monotone decreasing, about 1000× over the animation | confirmed |
| 11 | 31 | "The natural cubic spline converges at $O(h^4)$ for smooth functions" | True for sin on [0,2π] (ratios 16.9→16.0) only because sin'' vanishes at both ends. False in general (cos, exp: ratio 4) | wrong (→ F1) |
| 12 | 31 | "where $h$ is the maximum node spacing" | Nodes are equally spaced, h = 2π/(n−1). Definition is consistent | confirmed |
| 13 | 31 | "Each frame uses a fully recomputed spline (solving the tridiagonal second-derivative system) for the new set of nodes" | Script lines 53–57 call natural_spline_M afresh inside the loop for each nn | confirmed |
| 14 | 33 | "[Julia source](cubicsplineaa.jl)" | File exists. Manifest shows it produces cubicsplineaa.gif byte-identically | confirmed |
| 15 | 35 | Embed `cubicsplineaa.gif` | Committed GIF is the one this script produces (manifest: bytes_identical) | confirmed |
| 16 | 35 | Alt: "Natural cubic spline approximating sin(x) on [0, 2pi] with n=3,4,5,6,7,9 nodes" | 6 frames with node counts 3,4,5,6,7,9 (frames 001–006) | confirmed |
| 17 | 35 | Alt: "the spline closely tracks the true curve as nodes increase" | Frames 003–006 show visually overlapping curves. Errors fall to 1.07e-3 | confirmed |

## Implementation checks

### cubicsplineaa.jl
- **Method:** A natural cubic spline in the standard second-derivative (M) formulation. Interior equations are h_j M_j + 2(h_j+h_{j+1}) M_{j+1} + h_{j+1} M_{j+2} = 6[(y_{j+2}−y_{j+1})/h_{j+1} − (y_{j+1}−y_j)/h_j], with M_0 = M_n = 0. Evaluation uses the standard M-form cubic on each interval, with the interval found by `searchsortedlast` and clamped to [1, n] so that x = 2π is handled. The end condition is **natural** throughout, and the page also says natural everywhere. The system is solved with a dense `A \ b` rather than a Thomas solver. That is the same tridiagonal system and is not an error.
- **Numbers:** Script values from instrumented copy `reviewer/instr.jl`, run as `cd reviewer && julia instr.jl`, set beside scipy `CubicSpline(xs, sin(xs), bc_type='natural')` from `reviewer/scipy_check.py`. Both use the same 600-point plot grid:

  | nodes | script max err | scipy max err | title shows |
  |---|---|---|---|
  | 3 | 0.99999656160 | 0.9999965616 | 1.0 |
  | 4 | 0.10877103798 | 0.108771038 | 0.109 |
  | 5 | 0.02001682308 | 0.02001682308 | 0.02 |
  | 6 | 0.00896493527 | 0.008964935268 | 0.00896 |
  | 7 | 0.00407060570 | 0.0040706057 | 0.00407 |
  | 9 | 0.00106607471 | 0.001066074706 | 0.00107 |

  The second-derivative vectors M agree with scipy's `cs(xs, 2)` to the 12 digits printed. For example, at 9 nodes M = [0, −0.74414989, −1.05238686, −0.74414989, 0, 0.74414989, 1.05238686, 0.74414989, 0] in both. The 600-point grid slightly underestimates the true maximum (for 7 nodes: 0.0040706 on 600 points against 0.0040708 on 200001 points), which makes no difference at the 3 significant figures shown. The properties hold in every frame: interpolation residual ≤ 2.2e-16, S' jump at interior knots ≤ 3.3e-16, S'' jump = 0, and S''(a) = S''(b) = 0.
  The 3-node frame has data (0, 0), (π, ~1.2e-16), (2π, ~0), so the spline is identically about zero and the error is max|sin| = 1.0. That is correct, not a bug.
- **Reference values:** The reference curve is f(x) = sin(x), evaluated directly. Nothing else is used as a reference.
- **Picture:** I read the contact sheet and full-size frames 001, 004 and 006. The blue line is sin(x), the red dashed line is S(x) computed on the same x_plot, and the black markers sit at (x_i, sin x_i). Node counts in the titles match the visible markers (3, 4, 5, 6, 7, 9), and the max-error values in the titles match the table above. Axis limits [0, 2π] × [−1.4, 1.4] show the whole function and spline. Nothing is clamped or masked. In frames 004–006 the long title runs into the right edge and the closing parenthesis is clipped. The numbers stay fully legible, so this is cosmetic and not a finding.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/cubic-splines/`](evidence/cubic-splines/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
