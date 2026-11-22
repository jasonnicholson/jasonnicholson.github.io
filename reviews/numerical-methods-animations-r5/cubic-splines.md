# Cubic Splines — animation review (round 5)

Page: `pages/numerical-methods/cubic-splines/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no error, nothing misleading and no fidelity departure that needs reporting. Every claim in the ledger below was confirmed against evidence I produced myself.

I looked at the following and decided they are not findings:
- **Title clipping.** In frames 4–6 the long title runs past the right edge, so the closing ")" is cut off or partly cut off. The max-error value is fully legible in every frame, so this is cosmetic.
- **3-node frame.** The nodes 0, π and 2π are all zeros of sin, so the spline is identically 0 and the title shows "max err ≈ 1.0". This is a correct computation of a degenerate case. The page never claims otherwise; the Behavior paragraph says only that the error shrinks as nodes are added, which is true.
- **600-point error grid.** The title's error is a maximum over a 600-point grid, not the true supremum. Against a 2,000,001-point grid the difference is at most 2e-7, and it does not change any displayed 3-significant-digit value (table below).
- **Separate legacy animation.** `a2001/Animations/Quadrature/Spline/` holds a cubic-spline *quadrature* animation. It belongs to the quadrature topic, not to the Cubic Splines module, so the page's statement that "Mathews' Cubic Splines module has no animation" stands. The module HTML contains no animation and no link to one (`grep -ci animat` gives 0).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `cubicsplineaa.jl` | 0 | 5.9 | cubicsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | "piecewise-cubic interpolant … each panel polynomial S_i(x) interpolates endpoint values" | The instrumented script's node residual is ≤ 2.2e-16 for every n. | confirmed |
| D2 | "enforces continuity of S, S′, S″ at interior knots" | Script's M-form: S and S″ are continuous by construction, and the system enforces S′. Finite-difference jumps of S′ and S″ across interior knots with ε=1e-7 are ≤ 2.4e-7, i.e. O(ε), so continuous. | confirmed |
| D3 | Natural BC "S″(x_0)=0, S″(x_n)=0" | Script sets `M[1]=M[end]=0` (lines 29–30); scipy `cs(xs,2)` at the ends gives 0. | confirmed |
| D4 | "unknown second derivatives are found from a tridiagonal linear system, then each cubic panel is reconstructed" | Lines 20–30 assemble the tridiagonal system (diag 2(h_j+h_{j+1}), off-diag h, rhs 6·Δslopes) and lines 42–44 apply the standard M-form panel formula. Script M matches scipy natural `CubicSpline` to ≤ 1.4e-15. | confirmed |
| D5 | "clamped … or not-a-knot end conditions, the maximum error scales like O(h⁴)" | cos on [0,2π], clamped: successive halving ratios 16.89, 16.23, 16.06, 16.01, 16.00. Not-a-knot: 11.86, 14.98, 15.75, 15.94, 15.98 (tending to 16). | confirmed |
| D6 | "With natural end conditions it is only O(h²) unless f″(a)=f″(b)=0" | cos (f″(0)=−1) natural: ratios 4.25, 4.06, 4.02, 4.00, 4.00, so O(h²). sin natural: ratios tend to 16. | confirmed |
| D7 | "that error sits near an end where f″≠0, and away from the ends the error is still O(h⁴)" | cos natural, maximum error restricted to [1, 2π−1]: ratios tend to 16.06, 16.01, 16.00, while the global ratios are 4. | confirmed |
| A1 | "natural cubic spline fitted to equally-spaced data from f(x)=sin(x) on [0,2π], with the number of nodes increasing" | Lines 47, 51, 54: `range(0,2π,length=nn)`, nn = 3,4,5,6,7,9. | confirmed |
| A2 | "The natural spline satisfies S″(a)=S″(b)=0" | Same as D3. | confirmed |
| A3 | "Julia source scripts … are linked under each case" | One case, with `[Julia source](cubicsplineaa.jl)`. | confirmed |
| A4 | "Mathews' Cubic Splines module has no animation" | The module HTML has no animation and no animation link. Only a quadrature-topic spline animation exists in a2001. | confirmed |
| A5 | "the sin(x) example in Case 1 is new … module's examples interpolate a table of data points with no underlying function" | Examples 1–3 use the points (0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1) (`gr_25.gif`), with no generating function given. | confirmed |
| A6 | "Examples 1–3 … natural (Examples 1 and 2, the second with Mathematica's SplineFit) and a clamped cubic spline (Example 3) through one shared set of data points, are not animated here" | lnk_2/3/4 text matches. The data images `gr_25`, `gr_34` and `gr_53` are byte-identical (md5 20be64a4…). | confirmed |
| C1 | Heading "Natural cubic spline convergence for sin(x)" | The script runs a natural spline on sin. | confirmed |
| C2 | "Adding nodes shrinks the maximum error rapidly" | Errors 1.0, 0.109, 0.0200, 0.00896, 0.00407, 0.00107: strictly decreasing, about 940× overall. | confirmed |
| C3 | "natural end conditions are exact, since sin″(0)=sin″(2π)=0, so the spline converges at O(h⁴)" | −sin(0) = −sin(2π) = 0. Halving ratios for n = 9→257: 16.89, 16.23, 16.06, 16.01, 16.00. | confirmed |
| C4 | "h is the maximum node spacing" | Uniform spacing 2π/(n−1), so the maximum spacing equals h. | confirmed |
| C5 | "for a smooth f with f″(a)≠0 or f″(b)≠0 the natural spline's maximum error falls only as O(h²)" | Same as D6 (cos test). | confirmed |
| C6 | "The 3 to 9 nodes shown are too few for this rate to show cleanly from frame to frame" | Local orders between frames: 5.47, 5.88, 3.60, 4.33, 4.66. These scatter around 4 rather than settling. | confirmed |
| C7 | "Each frame uses a fully recomputed spline (solving the tridiagonal second-derivative system)" | `natural_spline_M` is called inside the `@animate` loop for each nn. | confirmed |
| C8 | Alt text "n=3,4,5,6,7,9 nodes" | `n_node_list` and the frame titles match, and there are 6 frames. | confirmed |
| C9 | Alt text "the spline closely tracks the true curve as nodes increase" | Frames 3–6 show the red dashed curve visually on top of the blue one (error ≤ 0.02). Frames 1–2 show visible gaps, consistent with "as nodes increase". | confirmed |
| C10 | Wiring: the link and embed point at `cubicsplineaa.jl` / `cubicsplineaa.gif`, which is that case | The single script produces the single GIF, which is byte-identical on regeneration. | confirmed |
| C11 | Diagram legend: blue = f(x)=sin(x), red dashed = S(x), black dots = data nodes | Lines 67–70 match the legend in the frames, and the dots sit at the computed nodes. | confirmed |
| C12 | Frame titles report "n nodes (max err ≈ …)" correctly | See the table in §3. All six values agree with the independent dense-grid computation to the displayed digits. | confirmed |
| X1 | Section index link | `pages/numerical-methods/index.qmd:62` links to `cubic-splines/`. | confirmed |

### 3. Implementation checks: `cubicsplineaa.jl`

**It is the method claimed.** The script computes a natural cubic spline in the standard second-derivative (M) formulation. The tridiagonal system has rows h_j M_{j-1} + 2(h_j+h_{j+1}) M_j + h_{j+1} M_{j+1} = 6[(y_{j+1}−y_j)/h_{j+1} − (y_j−y_{j-1})/h_j], and the end values are M_0 = M_n = 0. Evaluation uses the usual M-form panel formula. The system is solved with dense `A \ b`, which still solves the same tridiagonal system. The page does not state a different variant.

**The numbers are right.** I instrumented a copy (`review/instr.jl`, which prints M, the error and the node residual and makes no `gif` call) and checked it against scipy `CubicSpline(bc_type='natural')`:

| n | max\|M_script − M_scipy\| | script err (600 pts) | scipy err (2,000,001 pts) | title shows |
|---|---|---|---|---|
| 3 | 0 (M ≡ 0) | 0.9999966 | 1.000000 | 1.0 |
| 4 | 2.2e-16 | 0.10877104 | 0.108771 | 0.109 |
| 5 | 4.4e-16 | 0.02001682 | 0.020017 | 0.02 (= 0.0200) |
| 6 | 8.9e-16 | 0.00896494 | 0.00896508 | 0.00896 |
| 7 | 1.4e-15 | 0.00407061 | 0.00407079 | 0.00407 |
| 9 | 9.1e-16 | 0.00106607 | 0.00106609 | 0.00107 |

For every n the node residual is ≤ 2.2e-16, so the spline interpolates its data. Running the script's own routine for n = 9…257 gives errors 1.066e-3, 6.31e-5, 3.89e-6, 2.42e-7, 1.51e-8, 9.45e-10, i.e. ratios tending to 16 (O(h⁴)). This matches scipy to all printed digits.

**Reference values are right.** The reference is the closed form `sin`, which is exact.

**The picture shows what was computed.** I looked at the contact sheet and at frames 4 and 6 at full size. The red dashed S and the blue sin curves are drawn from the same `x_plot` grid, and the black nodes sit on the curve at the equally spaced nodes (frame 6 has 9 nodes at multiples of π/4). The title's n and error come from the loop variable and the computed error. Axes are [0,2π]×[−1.4,1.4], so nothing is clipped. Frame 1's flat zero spline is the correct result for nodes at the zeros of sin. The 6 frames match `n_node_list`. The only display artifact is the clipped closing parenthesis on the long titles of frames 4–6, which is cosmetic (see §1).

