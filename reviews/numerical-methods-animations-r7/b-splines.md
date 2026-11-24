# B-Splines — animation review (round 7)

Page: `pages/numerical-methods/b-splines/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Implementation (picture), Minor: the legend hides the running sum where the partition of unity is being shown

- **Location:** `bsplinebb.jl` line 45 (`legend=:topright`) with line 42 (`ylims=(-0.05, 1.25)`); visible in `bsplinebb.gif` frames 6 and 7.
- **What is there now:** the opaque legend grows with each added function and sits on top of the dashed running sum.
  - Frame 7 is the payoff frame for the page's claim "Their sum equals 1 everywhere in the domain". The line $y=1$ is hidden for $t \in [2.589, 3.864]$, which is 32.0% of the domain.
  - Frame 6 hides the sum for $t \in [2.589, 3.479]$ (22.4% of the domain). That range contains $t=3$, the point where the six-function sum first drops below 1, so the viewer cannot see where it leaves 1. The sum re-emerges at about 0.890.
  - Frame 5 hides a small piece, $t \in [2.589, 2.653]$ (1.8%).
- **What is true instead:** the computed sum is 1 across the whole domain (range 0.9999999999999997 to 1.0000000000000002 on all 500 samples). The computation is right; the frame does not display it over a third of the domain.
- **How I know:** `python3 review/occl.py <evidence folder>` locates the legend box from the frame pixels (x 495 to 715 px, which is $t \in [2.582, 3.868]$; bottom edge at $N = 0.850$ in frame 7) and maps the script's computed running sum into pixel space:

  ```
  m=5 ... sum hidden t (2.589, 2.653) share of [0,4] 0.018 S there (0.9303, 0.9489)
  m=6 ... sum hidden t (2.589, 3.479) share of [0,4] 0.224 S there (0.8901, 1.0)
  m=7 ... sum hidden t (2.589, 3.864) share of [0,4] 0.32  S there (1.0, 1.0)
  ```

  Frames 6 and 7 were also inspected by eye.
- **Suggested correction:** in `bsplinebb.jl` line 45 use `legend=:outerright`, so the legend no longer overlaps the axes, and regenerate the GIF.

No other findings. Items examined and deliberately not reported are listed in section 2.3.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bsplineaa.jl` | 0 | 7.7 | bsplineaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bsplinebb.jl` | 0 | 5.8 | bsplinebb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### 2.1 Description

| # | Claim (page words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "A B-spline curve of order $k$ (degree $k-1$)" | Exact pieces on each span are cubic for $k=4$ (`indep.py`) | Confirmed |
| D2 | $C(t)=\sum_i P_i N_{i,k}(t)$ | `bsplineaa.jl` lines 27-30 implement this; matches SciPy to 8.9e-16 | Confirmed |
| D3 | "Cubic B-splines have order $k=4$, so their basis functions are written $N_{i,4}$" | `k = 4` in both scripts | Confirmed |
| D4 | "defined recursively by the Cox-de Boor relation over a knot vector" | Lines 11-21 of `bsplineaa.jl`; reproduces Bernstein basis (1.1e-16) and uniform cubic knot values 1/6, 4/6, 1/6 | Confirmed |
| D5 | "local support (moving one control point only affects a local region of the curve)" | Perturbing $P_1$ changes only $t<1$; $P_7$ only $t>3$. Holds as the general property. **Caveat:** on this page's short knot vector, $P_4$ has support on all four spans, so moving it changes the whole curve except its endpoints. The page says so itself ("only $N_{4,4}$ covers all 4"). | Confirmed |
| D6 | "smoothness controlled by degree and knot multiplicity" | Simple knots give $C^2$ with a nonzero third-derivative jump. A double knot at $t=2$ keeps $S'$ continuous (-3.742 / -3.743 either side) and makes $S''$ jump (-16.49 to 13.49) | Confirmed |
| D7 | "With a clamped knot vector, the curve interpolates the first and last control points" | Exact: $C(0)=(0,0)=P_1$, $C(4)=(6,0)=P_7$ | Confirmed |
| D8 | "while remaining inside the convex hull of the control polygon" | 0 of 4001 samples outside the hull; each span also lies in the hull of its 4 active points | Confirmed |

### 2.2 Animations

| # | Claim (page words) | Evidence | Verdict |
|---|---|---|---|
| A1 | "two complementary views of cubic B-splines: the smooth curve ... and the individual basis functions" | Case 1 and Case 2 GIFs | Confirmed |
| A2 | "basis functions $N_{i,4}(t)$ whose weighted sum defines the curve" | `bsplineaa.jl` lines 27-30 | Confirmed |
| A3 | "Julia source scripts ... are linked under each case" | Links at `index.qmd` lines 34 and 42 resolve | Confirmed |
| C1.1 | Heading: "Cubic B-spline curve traced from 7 control points" | `ctrl_pts` has 7 entries; 7 black markers in frames | Confirmed |
| C1.2 | "clamped knot vector" | Knots printed: `[0,0,0,0,1,2,3,4,4,4,4]` | Confirmed |
| C1.3 | "passes through the first and last control points" | Exact (D7). Drawn endpoints are within 6e-9 of $P_1$, $P_7$ (samples stop 1e-9 inside the domain) | Confirmed |
| C1.4 | "smoothly pulled toward the interior control points" | Curve stays in the hull and does not reach them: minimum distance to $P_2,\ldots,P_6$ is 0.976, 1.211, 0.912, 0.911, 0.680 | Confirmed |
| C1.5 | "$C^2$-continuous everywhere" | Exact jumps at $t=1,2,3$ in value, first and second derivative are all 0; third-derivative jumps are nonzero (y: -83/2, 24, -63/2). Minimum speed $\lvert C'\rvert = 1.0006$, so the curve is regular | Confirmed |
| C1.6 | "traces the curve parameter $t$ from start to end" | 31 frames, sample index 1 to 400, $t$ from 1e-9 to $4-10^{-9}$, monotone | Confirmed |
| C1.7 | Alt: "by summing Cox-de Boor basis functions" | Lines 27-30 | Confirmed |
| C1.8 | Alt: "passes through only the first and last control points" | Distances in C1.4 | Confirmed |
| C1.9 | Alt: "lies within the convex hull of the control polygon" | D8 | Confirmed |
| C1.10 | Embed and link are this case | `bsplineaa.jl` regenerates `bsplineaa.gif` byte-identically (`cmp`) | Confirmed |
| C2.1 | Heading: "Basis functions $N_{1,4},\ldots,N_{7,4}$" | 7 functions, 7 frames, all distinct | Confirmed |
| C2.2 | "non-negative" | Minimum over the grid is 0.0; exact pieces agree | Confirmed |
| C2.3 | "zero outside $[t_i, t_{i+4}]$" | Exact per-span table matches, using 1-based knot indices | Confirmed |
| C2.4 | "at most 4 knot spans" | Maximum non-zero spans is 4 | Confirmed |
| C2.5 | Knot vector "$(0,0,0,0,1,2,3,4,4,4,4)$" | Printed by both instrumented scripts | Confirmed |
| C2.6 | "1, 2, 3, 4, 3, 2 and 1 non-zero spans" | Exact: `[1, 2, 3, 4, 3, 2, 1]` | Confirmed |
| C2.7 | "only $N_{4,4}$ covers all 4" | Exact support table | Confirmed |
| C2.8 | "sum equals 1 everywhere in the domain" | Exact: the sum is the constant 1 on each of the 4 spans. The drawn line is partly hidden (F1) | Confirmed |
| C2.9 | "which is why the B-spline curve lies within the convex hull" | The argument needs non-negativity plus partition of unity; the same paragraph states both | Confirmed |
| C2.10 | Alt: "revealed one at a time" | Frame $m$ draws $N_1,\ldots,N_m$ | Confirmed |
| C2.11 | Alt: "running sum shown in black approaches 1 as all functions are added" | Sum is 1 up to $t = 1, 2, 3$ for $m = 4, 5, 6$, and on the whole domain at $m=7$ | Confirmed |
| C2.12 | Embed and link are this case | `bsplinebb.jl` regenerates `bsplinebb.gif` byte-identically (`cmp`) | Confirmed |
| L1 | Mathews "uses cubic B-splines for interpolation" | `B-SplinesMod.html` text | Confirmed |
| L2 | "Example 1 builds the natural cubic spline through equally spaced data points" | Archive: 7 points $(0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1)$ with $S''(0)=S''(6)=0$ | Confirmed |
| L3 | "weighted sum of translated copies of one cubic B-spline, with the weights found by solving a linear system" | My solve of the 9-unknown system reproduces SciPy's natural spline to 8.9e-16 and the data at the nodes (`legacy.py`) | Confirmed |
| L4 | "Example 2 graphs those translated B-splines, the weighted terms and their partial sums" | Archive images `gr_158` to `gr_174`, `gr_177`, `gr_189`, `gr_202` to `gr_236` | Confirmed |
| L5 | "neither example is animated here" | True of both scripts | Confirmed |
| L6 | "the weights are the given control points, so no linear system is solved" | `bsplineaa.jl` has no solve | Confirmed |

### 2.3 Examined and not reported

- **Fidelity.** The page does not reproduce Mathews' two examples, but its closing paragraph says so and explains why, and that description is accurate (L1 to L6). This is not a silent drop, so it is not a finding. The archive has no B-spline animation: nothing under `a2001/Animations` matches, and the module has exactly two examples.
- **D5 caveat.** The statement is correct as a general property, and the page itself reports that $N_{4,4}$ spans the whole domain, so I did not raise it. If the owner wants the example to demonstrate locality, more control points would be needed; that is a teaching choice.
- **Label typography.** The frames show `N_{i,4}(t)` literally on the y-axis and mix `N₁,₄` with `N_7,₄`. Readable, so cosmetic.

---

### 3. Implementation checks

### `bsplineaa.jl`

| Point | Established | Script | Independent |
|---|---|---|---|
| Is the method | Cox-de Boor recursion with the 0/0 = 0 convention, summed against control points; clamped uniform cubic B-spline | Bernstein on knots $0^4 1^4$, max error 1.1e-16; uniform knot values 0.1667, 0.6667, 0.1667 | Closed forms: same |
| Numbers | All 400 curve samples | `aa_curve.csv` | SciPy `BSpline`, max difference 8.9e-16 |
| Linear precision | Greville control values reproduce $x=t$ | max error 8.9e-16 | Greville abscissae 0, 1/3, 1, 2, 3, 11/3, 4 |
| Reference values | The script draws no separate reference. Endpoints are exact | $C(0)$, $C(4)$ sampled to 6e-9 | SymPy: $(0,0)$, $(6,0)$ |
| Picture | Red marker at the computed point in all 31 frames; blue curve on the computed samples | marker centroid within 0.64 px (x), 0.31 px (y) | Last frame: 392 of 392 tested curve samples land on blue pixels |
| Display devices | Samples stop 1e-9 inside the domain, which correctly avoids the half-open recursion returning 0 at exactly $t=4$ (confirmed: routine gives 0.0 there). Axis limits contain the whole curve and polygon | | |

### `bsplinebb.jl`

| Point | Established | Script | Independent |
|---|---|---|---|
| Is the method | Same recursion as `bsplineaa.jl` (identical modulo whitespace) | | |
| Numbers | All 7 basis functions on 500 samples | `bb_basis.csv` | SciPy `basis_element`, max difference per basis at most 1.1e-16 |
| Peaks (for reference) | | as drawn | Exact: $N_1, N_7$: 1; $N_2, N_6$: $18/49 + 8\sqrt2/49 = 0.59824$; $N_3, N_5$: $33/98 + 9\sqrt2/49 = 0.59649$; $N_4$: $2/3$ at $t=2$ |
| Reference values | The dashed sum is the actual running sum, and equals 1 at $m=7$ | 0.9999999999999997 to 1.0000000000000002 | Exact sum on each span: 1 |
| Picture | Frame $m$ draws $N_1..N_m$ and their true partial sum; titles carry the right $m$. Legend occlusion: see F1 | 7 distinct frames | `occl.py` |
| Display devices | Axis limits show all functions; the only display defect is F1 | | |

### Wiring and reproducibility

`cmp` confirms each committed GIF is byte-identical to the regenerated GIF, and the regen scripts are the same as the committed scripts. Decoded frames: `bsplineaa` 31 of 31 distinct, `bsplinebb` 7 of 7 distinct.

