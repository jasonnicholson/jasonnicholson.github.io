# B-Splines — animation review (round 2)

Page: `pages/numerical-methods/b-splines/`. Reported findings: **0 Error, 1 Misleading, 0 Minor**.

## Findings

### F1. Fidelity: Misleading. The page replaces Mathews' subject (cubic B-spline *interpolation*) with parametric clamped B-spline *curves* and drops both archive examples without saying so

- **Location:** `index.qmd` as a whole. Line 8 says "Source inspiration: [@mathewsSite]." The Description (lines 10–22) and both cases (lines 30–44) cover only CAGD-style parametric B-spline curves with a clamped knot vector.
- **What the archive is:** `B-SplinesMod.html` is titled "Cubic spline construction using the B-spline function." It builds an *interpolating* cubic spline on a uniform grid as $s(x)=\sum_{i=-1}^{n+1} c_i B\big((x-x_i)/h\big)$. Here $B$ is the unnormalised uniform cubic B-spline with peak $B(0)=4$, and the coefficients come from the tridiagonal system $c_{k-1}+4c_k+c_{k+1}=y_k$ plus two natural end conditions.
  - *Example 1* (lnk_2, images gr_133 and gr_151): the natural cubic spline through the 7 points $(0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1)$, with 9 equations and coefficients $c_{-1},\dots,c_7$.
  - *Example 2* (lnk_3, gr_158–gr_236): graphs of the 9 translated basis functions on $[-4,10]$, the weighted terms $c_iB_i$, and the partial sums that build up the spline. It also shows that the basis support extends past the data interval.
- **What the page does:** a parametric curve $C(t)=\sum P_iN_{i,4}(t)$ that approximates rather than interpolates. It uses 7 control points $(0,0),(1,2),(2,-1),(3,2),(4,-0.5),(5,1.5),(6,0)$ and clamped knots $(0,0,0,0,1,2,3,4,4,4,4)$. No data points, no linear system for coefficients and no natural end conditions appear anywhere on the page. Case 2 resembles Example 2 in spirit (basis functions added one at a time), but it uses normalised clamped Cox–de Boor functions, and its running sum is the partition of unity, not the partial sums of $c_iB_i$ forming an interpolant.
- **Why it matters:** a reader who follows the cited source finds a different method (interpolation of data by solving for B-spline coefficients) from the one the page teaches (shape control by control points). The interpolation use of B-splines, which is the archive's whole point, is never mentioned. Nothing on the page is mathematically wrong; the issue is the silent substitution of topic and examples.
- **Evidence:**
  - I read the archive text with `sed 's/<[^>]*>//g' … | sed '/^[[:space:]]*$/d'` on `B-SplinesMod.html` and on lnk_2/lnk_3, and viewed the graph images (`review/legacy/montage.png`, `gr_133.png`, `gr_151.png`).
  - I reproduced Example 1 independently in Python. Solving the 9×9 system with natural ends gives $c_{-1..7}=(0.36667, 0.16667, -0.03333, -0.03333, 0.16667, 0.36667, 0.36667, 0.16667, -0.03333)$.
  - The resulting spline reproduces the data at $x=0..6$ exactly: $[1,0,0,1,2,2,1]$. It has a minimum of $-0.15$ at $x=1.5$ and a maximum of $2.15$ at $x=4.5$, which matches the shape in gr_151.
  - So the archive example is well-defined and could have been animated.
- **Suggested correction:** either
  - (a) add a case, for example `bsplinecc.jl`, that animates Mathews Example 1: the uniform cubic B-spline interpolant with natural end conditions through the 7 points, building it up term by term as in Example 2; or
  - (b) at minimum, add one sentence to the Description or Animations intro. It should say that the cited Mathews module uses uniform cubic B-splines to construct an interpolating (natural) cubic spline through data, and that this page instead illustrates parametric B-spline curves with a clamped knot vector.

No other findings.

- **Independent check:** confirmed


## Reviewer's notes (not findings)



#### Observed and judged not to be findings
- Plot text renders literally in `bsplinebb.gif`. The title reads "N₁,₄ … N_7,₄", legend entries read "N_1,₄" etc., and the y-label reads "N_{i,4}(t)" with visible underscore and braces (GR does not parse these). This is cosmetic, still unambiguous, and not misleading.
- Both scripts sample $t\in[10^{-9},\,4-10^{-9}]$. The half-open $k=1$ indicator in `bspline_basis` would give all-zero basis values at exactly $t=4$, but that point is never evaluated, so nothing displayed is affected.
- The red current-position marker in `bsplineaa.gif` has no legend entry. Its meaning is evident, and the page makes no claim about it.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bsplineaa.jl` | 0 | 6.9 | bsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bsplinebb.jl` | 0 | 5.5 | bsplinebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Descr. l.12 | "B-spline curve of order $k$ (degree $k-1$) … $C(t)=\sum_i P_i N_{i,k}(t)$" | `bspline_curve_point` sums `b .* ctrl_pts[i]` with order `k=4`. The curve equals scipy `BSpline(T,P,3)` to 8.9e-16 | confirmed |
| 2 | Descr. l.18 | "Cubic B-splines have order $k=4$ … $N_{i,4}$" | Both scripts use `k = 4` | confirmed |
| 3 | Descr. l.20 | "defined recursively by the Cox-de Boor relation over a knot vector" | Lines 11–21 / 10–20 implement $N_{i,k}=\frac{x-t_i}{t_{i+k-1}-t_i}N_{i,k-1}+\frac{t_{i+k}-x}{t_{i+k}-t_{i+1}}N_{i+1,k-1}$ with 0/0 := 0. Basis values match scipy `BSpline.basis_element` to 1.1e-16 | confirmed |
| 4 | Descr. l.20 | local support; "smoothness controlled by degree and knot multiplicity" | General properties. Support checked in #17, smoothness in #9 | confirmed |
| 5 | Descr. l.22 | "With a clamped knot vector, the curve interpolates the first and last control points while remaining inside the convex hull of the control polygon" | $S(0)=(0,0)=P_1$, $S(4)=(6,0)=P_7$. Every one of 200 000 curve samples lies in the hull of the 7 points (Delaunay test) | confirmed |
| 6 | Anim. intro l.26 | "two complementary views … the smooth curve traced from control points, and the individual basis functions $N_{i,4}(t)$ whose weighted sum defines the curve" | Both scripts build the identical knot vector `[0,0,0,0,1,2,3,4,4,4,4]` and 7 functions, so Case 2 shows exactly the basis that Case 1 weights | confirmed |
| 7 | Case 1 heading | "Cubic B-spline curve traced from 7 control points" | `k=4`, `n_ctrl = 7`. Frames show 7 black points | confirmed |
| 8 | Case 1 Behavior | "clamped knot vector passes through the first and last control points" | See #5. Final frame marker at (6.0000, 0.0000), first frame at (0,0) | confirmed |
| 9 | Case 1 Behavior | "smoothly pulled toward the interior control points" | Curve bends toward each interior point. Minimum distances to $P_2..P_6$ are 0.976, 1.211, 0.912, 0.911, 0.680, so it passes through none of them | confirmed |
| 10 | Case 1 Behavior | "The curve is $C^2$-continuous everywhere" | One-sided derivatives at knots 1, 2, 3: jumps in $C, C', C''$ are ≤ 1.6e-9 (finite-difference noise), and $C'''$ jumps by 41.5, 24.0 and 31.5 (as expected for simple knots). Polynomial within spans | confirmed |
| 11 | Case 1 Behavior | "traces the curve parameter $t$ from start to end" | 31 frames. The marker moves from t=0 (frame 0) to t=4 (frame 30) monotonically: t = 0.12, 0.66, 1.32, 2.00, 2.67, 3.33, 4.00 at frames 1, 5, 10, 15, 20, 25, 30 | confirmed |
| 12 | Case 1 link | `[Julia source](bsplineaa.jl)` | File exists and is the curve script | confirmed |
| 13 | Case 1 embed | `bsplineaa.gif` | Committed GIF is byte-identical to the regenerated one (md5 51909b96…) and shows the curve case | confirmed |
| 14 | Case 1 alt | "traced from 7 control points by summing Cox–de Boor basis functions" | Code path as in #1, #3 | confirmed |
| 15 | Case 1 alt | "passes through only the first and last control points" | See #8, #9 | confirmed |
| 16 | Case 1 alt | "lies within the convex hull of the control polygon" | Global hull test true. The stronger local test (span j inside the hull of $P_{j+1..j+4}$) is also true | confirmed |
| 17 | Case 2 heading | "Basis functions $N_{1,4},\ldots,N_{7,4}$ and the partition of unity" | 7 frames add $N_{1,4}..N_{7,4}$. Final frame sum = 1 | confirmed |
| 18 | Case 2 Behavior | "$N_{i,4}(t)$ is non-negative" | Minimum basis value over 500 × 7 samples = 0.0 | confirmed |
| 19 | Case 2 Behavior | "zero outside $[t_i,t_{i+4}]$, which is at most 4 knot spans" | Measured supports: N1 [0,1], N2 [0,2], N3 [0,3], N4 [0,4], N5 [1,4], N6 [2,4], N7 [3,4]. These equal $[t_i,t_{i+4}]$ with 1-based knots | confirmed |
| 20 | Case 2 Behavior | knot vector "$(0,0,0,0,1,2,3,4,4,4,4)$" | Dump of `t_knots` = `[0,0,0,0,1,2,3,4,4,4,4]` in both scripts | confirmed |
| 21 | Case 2 Behavior | "shrink $N_{1,4},\ldots,N_{7,4}$ to 1, 2, 3, 4, 3, 2 and 1 non-zero spans; only $N_{4,4}$ covers all 4" | Span counts measured: 1, 2, 3, 4, 3, 2, 1 | confirmed |
| 22 | Case 2 Behavior | "Their sum equals 1 everywhere in the domain (partition of unity)" | max \|Σ N − 1\| = 3.3e-16 on the 500-point grid over [1e-9, 4−1e-9] | confirmed |
| 23 | Case 2 Behavior | "which is why the B-spline curve lies within the convex hull" | Correct reasoning (non-negativity plus partition of unity give convex combinations). See #16 | confirmed |
| 24 | Case 2 link | `[Julia source](bsplinebb.jl)` | File exists and is the basis script | confirmed |
| 25 | Case 2 embed | `bsplinebb.gif` | Byte-identical to the regenerated one (md5 114574b7…), 7 frames | confirmed |
| 26 | Case 2 alt | "Seven cubic B-spline basis functions N_{i,4} revealed one at a time" | 7 frames, frame m shows $N_1..N_m$ | confirmed |
| 27 | Case 2 alt | "running sum shown in black approaches 1 as all functions are added" | Running sum is black dashed. It equals 1 on $[0, m-3]$ for m ≥ 4 (measured: t ≤ 0.99, 2.00, 3.00, 4.00 for m = 4..7) and is identically 1 at m = 7 | confirmed |
| 28 | Source line l.8 | Mathews as source inspiration | Archive teaches uniform B-spline *interpolation*. See F1 | departure (F1) |
| 29 | Index wiring | page linked from section index | `pages/numerical-methods/index.qmd:63` `- [B-Splines](b-splines/)` | confirmed |

---

### 3. Implementation checks

### `bsplineaa.jl` (cubic B-spline curve)
- **Is the method it claims to be:** yes. It uses the standard Cox–de Boor recursion for normalised B-splines of order k=4 (half-open $[t_i,t_{i+1})$ indicator at k=1, 0/0 treated as 0) and a clamped knot vector with uniform interior knots. The curve is the control-point-weighted sum. Variant: clamped (open-uniform) knots, $t\in[0,4]$.
- **Numbers are right:** an instrumented copy (`review/aa_inst.jl`, with the `gif` line replaced by a data dump) wrote all 400 sampled curve points. The independent scipy `BSpline([0,0,0,0,1,2,3,4,4,4,4], P, 3)` evaluated at the same t gives a maximum difference of **8.9e-16**. Spot values:
  - script/scipy at knot 1: (1.91667, 0.25);
  - at knot 2: (3, 1.08333);
  - at knot 3: (4.08333, 0.41667).
  - Hand check at t=2: weights $N_{3,4}=N_{5,4}=1/6$, $N_{4,4}=2/3$, giving $x=(2+12+4)/6=3$ and $y=(-1+8-0.5)/6=1.0833$.
- **Reference values:** none (no "exact" overlay). The endpoint-interpolation and convex-hull properties were verified independently (ledger #5, #16).
- **Picture shows what was computed:** frames 1, 2, 6, 16, 31 and the contact sheet were inspected.
  - The control polygon and points sit at the 7 coded points.
  - The traced curve is `cx[1:idx_end]`, and the red marker sits at its end.
  - The final frame shows the full curve from (0,0) to (6,0), with peaks of about 1.02, 1.09 and 0.82 and troughs of about 0.21 and 0.41. These match scipy: the y range is [0, 1.089].
  - The axis window x∈[−0.2,6.2], y∈[−1.8,2.5] contains the whole curve and all control points.
  - The title "Cubic B-Spline Curve (7 control points)" is accurate.
  - Frame count is 31 (frames 0..30), at 5 fps.

### `bsplinebb.jl` (basis functions and partition of unity)
- **Is the method it claims to be:** yes. It uses the same Cox–de Boor routine and the same knot vector as `bsplineaa.jl`, and evaluates $N_{i,4}$ for i=1..7.
- **Numbers are right:** an instrumented copy (`review/bb_inst.jl`) dumped all 7×500 basis values. Against scipy `BSpline.basis_element(T[i:i+5])` the maximum difference is **1.1e-16**.
  - Peaks (script grid): N1 = 1 at t=0; N2 0.5982 at 0.457; N3 0.5965 at 1.106; N4 0.6667 at 1.996 (exact 2/3 at t=2); N5 0.5965 at 2.894; N6 0.5982 at 3.543; N7 = 1 at t=4.
  - The functions are symmetric as expected: $N_{i}(t)=N_{8-i}(4-t)$.
  - Sum − 1 ≤ 3.3e-16 and minimum value 0.
- **Reference values:** the dashed line is the running sum. It is not a reference; it is checked as above.
- **Picture shows what was computed:** all 7 frames were inspected (contact sheet plus frame 7 full size).
  - Frame m shows $N_1..N_m$ in distinct colours plus the dashed black running sum.
  - The sum is flat at 1 on [0, m−3] and falls off to the right. By frame 7 it is flat at 1 across [0,4].
  - ylims (−0.05, 1.25) contain everything.
  - The title index m matches the number of functions drawn.
  - Label rendering is literal (see "not findings"). This is cosmetic only.

### Regeneration
Scratch copies of both unchanged scripts reproduce the committed GIFs byte for byte (manifest, confirmed by md5). My instrumented copies did not write any GIF.

