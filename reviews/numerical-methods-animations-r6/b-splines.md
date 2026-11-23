# B-Splines — animation review (round 6)

Page: `pages/numerical-methods/b-splines/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: the page replaces Mathews' only examples (B-spline interpolation) with a different topic (parametric clamped B-spline curves)

- **Location:** `index.qmd` lines 30–44 (both cases) and line 46 (the disclosure paragraph).
- **What is there now:** Both animations show a parametric cubic B-spline curve with a clamped knot vector $(0,0,0,0,1,2,3,4,4,4,4)$ and 7 control points, plus that curve's basis functions. These are geometric-modelling examples.
- **What the archive has:** The Mathews B-Splines module is about *cubic spline interpolation* built from translated copies of one uniform cubic B-spline $B(x)$.
  - Example 1 builds the natural cubic spline through the 7 equally spaced points $(0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1)$ (image `gr_111`). It does so by solving a 9-equation system for the coefficients (lnk_2: "Solve the system of equations for the coefficients", "there are 9 terms in the sum").
  - Example 2 graphs the basic functions, the weighted terms and the partial sums (lnk_3).
  - Neither example appears on the page.
- **Mitigation:** Line 46 discloses this accurately. I checked its description of Examples 1 and 2 against the archive text and images, and it is correct. So the drop is not silent. However, the page gives no reason for the switch, and the Description never mentions the interpolation use, which is the numerical-analysis use of B-splines and the point of the source module.
- **Why it matters:** A reader who arrives from the numerical-methods index expecting "spline interpolation via B-splines", as the source module teaches it, finds only CAGD-style curves. The disclosure softens this, which is why I rate it Minor rather than Misleading.
- **Suggested correction:** Do either of the following.
  - (a) Add a Case 3 animating Mathews Example 1: the natural cubic spline through the 7 points above, built as $\sum_{i=-1}^{7} c_i B_i(x)$, adding the weighted terms one at a time as in Example 2.
  - (b) Keep the page as is, but add one sentence to the line-46 paragraph giving the reason (for example, that the page focuses on the basis-function properties shared by both uses).

No implementation errors and no page-match errors were found. Everything else checked is listed in the ledger and in the implementation checks below.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bsplineaa.jl` | 0 | 7.1 | bsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bsplinebb.jl` | 0 | 5.6 | bsplinebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `bsplineaa.gif` | 31 | byte-identical | bsplineaa |
| `bsplinebb.gif` | 7 | byte-identical | bsplinebb |

### Page references

- Scripts linked: `bsplineaa.jl`, `bsplinebb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Checked against my own computations (`inst_aa.jl`, `inst_bb.jl`, `indep.py`) and against the frames.

### Description

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | "A B-spline curve of order $k$ (degree $k-1$) is expressed as … $C(t)=\sum_i P_i N_{i,k}(t)$" | confirmed | `bsplineaa.jl` lines 24–32 compute exactly $\sum_i P_i N_{i,k}(t)$. The values match scipy `BSpline(t, P, 3)` to all printed digits (see I-A). |
| D2 | "Cubic B-splines have order $k=4$, so their basis functions are written $N_{i,4}$" | confirmed | Both scripts use `k = 4` with the Cox–de Boor recursion of order k, giving degree-3 pieces (third-derivative jumps are non-zero, see D5 and C1c). |
| D3 | "defined recursively by the Cox–de Boor relation over a knot vector" | confirmed | Script lines 11–21 (aa) and 10–20 (bb) are the standard recursion: denominators $t_{i+k-1}-t_i$ and $t_{i+k}-t_{i+1}$, with 0/0 taken as 0 and half-open order-1 indicators. The basis agrees with scipy to 1.3e-15 and with sympy `bspline_basis_set`. |
| D4 | "local support (moving one control point only affects a local region of the curve)" | confirmed (general property) | Each $N_{i,4}$ is zero outside $[t_i,t_{i+4}]$ (C2b). For this particular 7-point example, $N_{4,4}$ spans the whole domain $[0,4]$, so moving $P_4$ affects the entire curve. The page itself says $N_{4,4}$ "covers all 4" spans, so this is not contradicted, just worth knowing. |
| D5 | "smoothness controlled by degree and knot multiplicity" | confirmed | With simple interior knots, the derivative jumps at t = 1, 2, 3 are 0 for orders 0–2 and non-zero for order 3 (`indep.py`). Degree 3 minus multiplicity 1 gives C². |
| D6 | "With a clamped knot vector, the curve interpolates the first and last control points" | confirmed | C(0) = (0,0) = P1 and C(4) = (6,0) = P7 (scipy). In the script's sampled curve, the distance to P1 and P7 is about 6e-9 (because of the 1e-9 parameter offset). |
| D7 | "… while remaining inside the convex hull of the control polygon" | confirmed | All 400 sampled curve points lie inside the hull: scipy `Delaunay(P).find_simplex(pts) >= 0` is True for all of them. |

### Animations: introduction

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "two complementary views of cubic B-splines: the smooth curve traced from control points, and the individual basis functions $N_{i,4}(t)$ whose weighted sum defines the curve" | confirmed | Both scripts build the same knot vector $(0,0,0,0,1,2,3,4,4,4,4)$ with n = 7, k = 4, so the bb basis functions are exactly the weights of the aa curve. |
| A2 | "Julia source scripts … are linked under each case" | confirmed | `[Julia source](bsplineaa.jl)` sits under Case 1 and `[Julia source](bsplinebb.jl)` under Case 2. Both files exist. |

### Case 1: `bsplineaa`

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1a | Heading: "Cubic B-spline curve traced from 7 control points" | confirmed | `ctrl_pts` has 7 entries and k = 4. The frame title reads "Cubic B-Spline Curve (7 control points)". |
| C1b | "A cubic B-spline curve with a clamped knot vector passes through the first and last control points" | confirmed | Knots are `[0,0,0,0,1,2,3,4,4,4,4]` (printed). The endpoints are as in D6. The first frame shows the red marker at (0,0) and the last frame shows it at (6,0). |
| C1c | "… and is smoothly pulled toward the interior control points" | confirmed | The minimum distances from the curve to P2–P6 are 0.976, 1.211, 0.912, 0.911 and 0.680 (script and scipy agree to about 1e-4 on the sampled grid). The curve bends toward each interior point without reaching it: y range [0, 1.089], local maxima near P2, P4 and P6, minima near P3 and P5 (frame 31). |
| C1d | "The curve is $C^2$-continuous everywhere" | confirmed | The jumps in derivatives 0, 1 and 2 at knots 1, 2 and 3 are all 0. The third-derivative jumps are (−2, −41.5), (0, 24) and (2, −31.5) (`indep.py`), so the curve is exactly C² and not C³, as expected. |
| C1e | "The animation traces the curve parameter $t$ from start to end" | confirmed | Frames 0–30 map to sample indices 1, 13, 27, …, 400, i.e. t = 0, 0.12, …, 4.0, evenly spaced in t (printed by `inst_aa.jl`). The last frame shows the complete curve. |
| C1f | Alt: "traced from 7 control points by summing Cox–de Boor basis functions" | confirmed | Same as D1. |
| C1g | Alt: "it passes through only the first and last control points" | confirmed | Same as C1c: the minimum distance to every interior point is at least 0.68. |
| C1h | Alt: "lies within the convex hull of the control polygon" | confirmed | Same as D7. |
| C1i | Wiring: the embed `bsplineaa.gif` is this case and is produced by `bsplineaa.jl` | confirmed | Script line 95 writes `bsplineaa.gif`. The manifest shows the committed GIF is byte-identical to the regenerated one. |

### Case 2: `bsplinebb`

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C2a | Heading: "Basis functions $N_{1,4},\ldots,N_{7,4}$ and the partition of unity" | confirmed | `for m in 1:n_ctrl` with n_ctrl = 7 gives 7 frames, adding $N_{m,4}$ in frame m together with the running sum. |
| C2b | "Each … $N_{i,4}(t)$ is non-negative and is zero outside $[t_i,t_{i+4}]$, which is at most 4 knot spans" | confirmed | The minimum basis value on the 500-point grid is 0.0 (Julia and scipy). The sympy piecewise basis is non-zero only on the spans listed in C2d, each inside $[t_i,t_{i+4}]$. |
| C2c | "With the clamped knot vector $(0,0,0,0,1,2,3,4,4,4,4)$" | confirmed | Printed `t_knots` matches. |
| C2d | "the repeated end knots shrink $N_{1,4},\ldots,N_{7,4}$ to 1, 2, 3, 4, 3, 2 and 1 non-zero spans" | confirmed | Sympy spans (span j = [j, j+1]): N1 {0}, N2 {0,1}, N3 {0,1,2}, N4 {0,1,2,3}, N5 {1,2,3}, N6 {2,3}, N7 {3}, giving counts 1, 2, 3, 4, 3, 2, 1. Frame 7 shows the same supports. |
| C2e | "only $N_{4,4}$ covers all 4" | confirmed | Same as C2d. |
| C2f | "Their sum equals 1 everywhere in the domain (partition of unity)" | confirmed | Julia sum range on the grid is [0.9999999999999997, 1.0000000000000002]. Sympy `simplify(sum(B))` is 1 on [0,4]. Frame 7 shows the dashed sum flat at 1. |
| C2g | "which is why the B-spline curve lies within the convex hull" | confirmed | Partition of unity together with the non-negativity stated in the same paragraph is the standard convex-combination argument. The hull containment itself is verified in D7. |
| C2h | Alt: "Seven cubic B-spline basis functions $N_{i,4}$ revealed one at a time" | confirmed | 7 frames, one function added per frame (contact sheet and frames 1 and 7 viewed). |
| C2i | Alt: "running sum shown in black approaches 1 as all functions are added" | confirmed | The running sum is drawn black and dashed. For partial sum m it equals 1 on $[0, t_{m+1}]$ and decays after that, so the region where it equals 1 grows frame by frame until it is 1 everywhere at m = 7. The maximum is 1 in every frame and the minimum is 1 only at m = 7 (`indep.py`). |
| C2j | Wiring: the embed `bsplinebb.gif` is this case and is produced by `bsplinebb.jl` | confirmed | Script line 60 writes `bsplinebb.gif`. The manifest shows it is byte-identical to the regenerated GIF. |

### Archive paragraph (line 46)

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| L1 | Mathews "Example 1 builds the natural cubic spline through equally spaced data points as a weighted sum of translated copies of one cubic B-spline, with the weights found by solving a linear system" | confirmed | lnk_2 text and `gr_111`: the points (0,1)…(6,1) at x = 0..6, natural end conditions, a 9-equation system, and a sum over i = −1..7. |
| L2 | "its Example 2 graphs those translated B-splines, the weighted terms and their partial sums" | confirmed | lnk_3: "Graphs of the basic functions…", "Graphs of the terms…", "The next loop finds the partial sums". |
| L3 | "neither example is animated here" | confirmed | That is true, and it is the subject of F1. |

---

### 3. Implementation checks

### I-A. `bsplineaa.jl` (curve traced from 7 control points)

1. **It is the method it claims to be.** Yes. This is the standard clamped (open-uniform) cubic B-spline curve: Cox–de Boor recursion of order 4 on the knots `[0,0,0,0,1,2,3,4,4,4,4]` (n + k = 11 knots, printed), with $C(t)=\sum_{i=1}^7 P_i N_{i,4}(t)$.

2. **The numbers are right.** The script's routine (instrumented, `inst_aa.jl`) agrees with an independent scipy evaluation:

   | t | script C(t) | scipy `BSpline(t,P,3)` |
   |---|---|---|
   | 0 | (0.0, 0.0) | (0, 0) |
   | 0.5 | (1.1770833, 0.9687500) | (1.17708333, 0.96875) |
   | 1 | (1.9166667, 0.25) | (1.91666667, 0.25) |
   | 1.5 | (2.4895833, 0.5416667) | (2.48958333, 0.54166667) |
   | 2 | (3.0, 1.0833333) | (3.0, 1.08333333) |
   | 2.5 | (3.5104167, 0.75) | (3.51041667, 0.75) |
   | 3 | (4.0833333, 0.4166667) | (4.08333333, 0.41666667) |
   | 3.5 | (4.8229167, 0.8020833) | (4.82291667, 0.80208333) |
   | 4 − 1e-12 | (6.0, 4.5e-12) | C(4) = (6, 0) |

   Property checks: endpoint interpolation holds, the curve stays inside the convex hull (all 400 points), it is C² but not C³ at the interior knots, and the sampled y range is [4.5e-9, 1.0892] in both implementations.

   One latent quirk with no effect on the output: because the order-1 indicator is half-open, the script's routine returns (0,0) at exactly t = 4.0. The script avoids this by sampling $[t_{min}+10^{-9}, t_{max}-10^{-9}]$, so the drawn curve ends at (5.999999997, 4.5e-9). This is not a finding.

3. **Reference values.** None. The script draws no "exact" comparison curve. The control points and polygon are input data.

4. **The picture shows what was computed.** I viewed the contact sheet (frames 1, 4, 7, …, 31) and frame 31 at full size.
   - The control polygon (gray dashed) and control points (black) are drawn from `ctrl_pts`.
   - The blue curve is `cx[1:idx_end], cy[1:idx_end]`, and the red marker is at the current sample.
   - Frame 1 shows only the marker at P1. Frame 31 shows the complete curve ending at P7.
   - Axis limits x ∈ [−0.2, 6.2] and y ∈ [−1.8, 2.5] contain every control point and the whole curve. There is no clamping or masking.
   - The title "Cubic B-Spline Curve (7 control points)" is correct.
   - fps 5 with 31 frames gives about 6 s.

### I-B. `bsplinebb.jl` (basis functions and partition of unity)

1. **It is the method it claims to be.** Yes. It uses the same Cox–de Boor recursion and the same clamped knot vector, and plots $N_{i,4}$ for i = 1..7 with the running sum $\sum_{i\le m} N_{i,4}$.

2. **The numbers are right.** All 7 × 500 basis values from the script (written to `julia_basis.txt`) were compared with scipy `BSpline.basis_element(t[i:i+5])` on the same grid. The maximum absolute difference is **1.27e-15**.
   - Peak values (scipy and sympy): N1 = 1.0 at t = 0; N2 = 0.598; N3 = 0.596; N4 = 2/3 at t = 2; N5 = 0.596; N6 = 0.598; N7 → 1 at t = 4.
   - These agree with the frames, for example the orange N4 peaking at 0.667 at t = 2 in frame 7.
   - Partition of unity holds to within 3e-16. Non-negativity holds, with minimum 0.0. Span counts are 1, 2, 3, 4, 3, 2, 1 (sympy).

3. **Reference values.** The only reference is the implied line y = 1 for the full sum. Sympy confirms the full sum is exactly 1 on [0, 4].

4. **The picture shows what was computed.** I viewed the contact sheet (all 7 frames) and frames 1 and 7 at full size.
   - Each frame m adds $N_{m,4}$ in its own colour, and the dashed black curve is the partial sum. In frame 1 it overlaps N1; in frame 7 it is flat at 1.
   - The y-range [−0.05, 1.25] and x-range [0, 4] show the full supports and the sum line.
   - The frame titles "… N₁,₄ … N_m,₄" carry the correct index in every frame (printed strings for m = 1..7).
   - Cosmetic only, not a finding: GR renders `N_$i,₄` and the y-label `N_{i,4}(t)` with a literal underscore (for example "N_1,₄", "N_{i,4}(t)"), and frame 1's title reads "N₁,₄ … N_1,₄". Both are readable and the indices are correct.

