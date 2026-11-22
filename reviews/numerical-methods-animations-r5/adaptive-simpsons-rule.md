# Adaptive Simpson's Rule — animation review (round 5)

Page: `pages/numerical-methods/adaptive-simpsons-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my independent computation and with the frames.

These observations are not findings, and I record them only for completeness:
- **Frame order versus Mathews' trace.** The script orders the splits widest-first, leftmost-first. Mathews' Example 7 trace splits [1/2,1] before [0,1/2] at level 2, so his 11- and 13-point intermediate values (1.935128, then 2.003302 after both splits) differ from the page's frames 5–6 (2.008051, 2.001744). The two sequences agree from 15 points onward, and they end on the same partition and the same value, 2.016252. The page states its own ordering explicitly. Only the order of display differs, so this is not a fidelity finding.
- **"Each animation below …"** introduces a section that has a single animation. This is wording only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adaptivesimpsonsaa.jl` | 0 | 7.4 | adaptivesimpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `adaptivesimpsonsaa.gif` | 21 | byte-identical | adaptivesimpsonsaa |

### Page references

- Scripts linked: `adaptivesimpsonsaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | $S(a,b)=\frac{b-a}{6}[f(a)+4f(m)+f(b)]$ | script l.15 is identical. My test: S is exact for $x^3$ on [0,2] (4.0) and not for $x^4$ (6.6667 vs 6.4), so the degree is 3 as expected | confirmed |
| D2 | "refinement compares $S(a,b)$ against $S(a,m)+S(m,b)$" | script l.20 | confirmed |
| D3 | Accept when $\lvert S(a,m)+S(m,b)-S(a,b)\rvert<\varepsilon_{[a,b]}$ ("Mathews' routine") | script l.20 uses a strict `<`. Mathews' `Adapt` (gr_2): `If[Abs[Sab-Sac-Scb] < tol, Return[Sac+Scb], Return[Adapt[a,c,tol/2]+Adapt[c,b,tol/2]]]` | confirmed |
| D4 | The whole interval starts with $\varepsilon$, and each half gets half the tolerance | script l.28, l.37 (`t/2`) | confirmed |
| D5 | "refinement concentrates where curvature or oscillation is strongest" | Refinement goes to x→0, where $f'$ and $f''$ are unbounded (15 of the 20 panels lie in [0,1/2]) | confirmed (qualitative) |
| D6 | The 15ε variant "accepts 9 subintervals (the finest is [0,1/32])" | indep.py, factor 15: 9 panels, finest [0,1/32] | confirmed |
| D7 | "instead of 20 (the finest is [0,1/2048])" | indep.py, factor 1: 20 panels, finest [0,1/2048] | confirmed |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on [0,2], $\varepsilon=10^{-3}$ | script l.9–12. Same as Mathews Example 7 (gr_182, gr_183) | confirmed |
| A2 | "Starting from the single panel [0,2]" | instr.jl frame 1: 3 points, no split. GIF frame_002 shows one parabola on [0,2] | confirmed |
| A3 | "each frame splits the widest panel that fails the test (leftmost first)" | script l.32–34. The split sequence in instr.jl is level by level, left to right among the failing panels | confirmed |
| A4 | "marks the two new sample points in blue" | script l.119 draws the blue points at (3p+q)/4 and (p+3q)/4, the midpoints of the new halves. Frames 016 and 021 show them | confirmed |
| A5 | "Approximation" is the composite Simpson sum of $S(a,b)$ over the panels drawn | `simpson_nonuniform` takes the node triples (p,m,q) from `panel_nodes`, so it equals Σ S(p,q). Frame values match instr.jl, e.g. 3 pts 2.491261 and 41 pts 2.016252 | confirmed |
| A6 | Heading: f, [0,2], ε=1e-3 | script | confirmed |
| B1 | "all 20 panels (41 points) pass the test" | indep.py: 20 panels, 41 points. instr.jl: final set has 41 points | confirmed |
| B2 | "[1.5,2] is never split" | indep.py: (3/2,2) is an accepted panel. The final nodes include 3/2, 7/4, 2 and no others in between | confirmed |
| B3 | "19 of the 41 points lie in [0,1/8]" | indep.py and instr.jl both count 19 | confirmed |
| B4 | "The last seven frames split [0,1/16],[0,1/32],…,[0,1/1024] in turn" | instr.jl frames 14–20 split [0,1/16], [0,1/32], [0,1/64], [0,1/128], [0,1/256], [0,1/512], [0,1/1024]. These are GIF frames 015–021 | confirmed |
| B5 | "$f'$ is unbounded at 0 ($f'\approx\frac{16}{3}x^{-1/3}$)" | mpmath diff: f'(1e-3)=53.03 vs 53.33; f'(1e-6)=533.332 vs 533.333; f'(1e-9)=5333.333 vs 5333.333 | confirmed |
| B6 | "the panels split in the last five frames are at most 1/64 wide (under 5 pixels at this scale)" | The splits in the last five frames are [0,1/64] … [0,1/1024]. In frame_021 the axis runs 0→2 over about 578 px (x=0 at px≈40, x=2 at px≈618), so 1/64 ≈ 4.5 px | confirmed |
| B7 | "the blue label names each one" | The frames show "Split [0, 1/64]" … "Split [0, 1/1024]" in blue (sheet.png, frame_021) | confirmed |
| B8 | "final estimate 2.016252" | instr.jl gives 2.016252. indep.py gives Σ S(a,b) = 2.01625176. Mathews' table (gr_204) also gives 2.016252 | confirmed |
| B9 | "the integral 2.016280" | mpmath quad on split intervals gives 2.0162797196170963. With the substitution x=u³ (which removes the singularity) it gives the same value to 20 digits | confirmed |
| B10 | "differs … by −2.8×10⁻⁵" | 2.01625176 − 2.01627972 = −2.796e-5 | confirmed |
| B11 | "summing S(a,m)+S(m,b) over the same panels, as the recursive routine returns, gives 2.016273" | indep.py recursive return = 2.01627260 | confirmed |
| W1 | `[Julia source](adaptivesimpsonsaa.jl)` | The file exists and is the script that produces this GIF | confirmed |
| W2 | Embed `adaptivesimpsonsaa.gif` | The file exists and is byte-identical to a regenerated run | confirmed |
| T1 | Alt: "one failing panel is split per frame" | This holds for frames 2–20. Frame 0 shows only the curve and frame 1 shows the initial panel, which is unremarkable | confirmed |
| T2 | Alt: "sample points and panel boundaries drawn and the new points in blue" | script l.100–120, frames | confirmed |
| T3 | Alt: "ends with 41 points, 19 of them in [0, 1/8]" | as B1 and B3 | confirmed |
| T4 | Alt: "piecewise quadratic approximation and integral estimate update each frame" | The interpolating parabolas are drawn per panel (l.83–97) and the Approximation text changes every frame | confirmed |
| C1 | Frame count is implicit: 20 node sets plus a blank opening frame = 21 | instr.jl: 20 node sets, 21 frames. The GIF has 21 frames | confirmed (consistent) |
| F1 | Fidelity: the example matches Mathews Example 7 | f, interval and tol match. Mathews' trace has 20 node sets from 3 to 41 points, with finest node 0.000244141 = 1/4096, so the finest panel is [0,1/2048]. Final value 2.016252 in both | confirmed |

### 3. Implementation checks: `adaptivesimpsonsaa.jl`

**It is the method it claims to be.** The script runs Mathews' `Adapt` acceptance test: |S(a,m)+S(m,b)−S(a,b)| < t, with t halved for each child. It runs it iteratively, one split per frame, instead of recursively. Acceptance of a panel depends only on the panel and its depth-determined tolerance, so the order of splits cannot change the final partition. My recursive computation confirms this: indep.py, which uses exact rational endpoints and 40-digit arithmetic, produces the same 20 panels as the script's final node set (listed in instr.jl output). The variant is the plain-ε test without the 15× factor or Richardson correction, and the page names it correctly.

**The numbers are right.**

| Quantity | Script (instr.jl) | Independent (indep.py / numpy) |
|---|---|---|
| Panels / points at end | 20 / 41 | 20 / 41 |
| Finest panel | [0,1/2048] (nodes 0, 1/4096, 1/2048) | [0,1/2048] |
| Points in [0,1/8] | 19 | 19 |
| Final Σ S(a,b) | 2.016252 | 2.01625176116 |
| 3-point value | 2.491261 | 2.491261 (numpy). Mathews' animation also shows 2.491261 |
| 11-point value (script order) | 2.008051 | 2.008051 (numpy, nodes {0,1/8,1/4,3/8,1/2,3/4,1,…}) |
| Recursive return Σ(S(a,m)+S(m,b)) | (not displayed) | 2.01627260396 |
| 15ε variant | (not run) | 9 panels, finest [0,1/32] |

**Its reference values are right.** The script draws no reference value. The page's integral, 2.016280, was checked two ways in mpmath, and both agree to 20 digits on 2.0162797196.

**The picture shows what was computed.** I viewed sheet.png, frame_002, frame_016 and frame_021, and checked them against the plotting code:
- Each panel gets the parabola through its own three nodes (`poly_coeffs` on [x0,x1,x2]), filled to y=0.
- Red verticals are drawn at the panel endpoints (`xs[1:2:end]`).
- The blue points are the two new nodes, and the blue label gives the split panel as exact dyadic fractions.
- The "Sample Points" and "Approximation" text match instr.jl in every frame I sampled (3/2.491261, 5/1.611786, 9/1.941436, 13/2.001744, 17/2.012445, 21/2.012906, 25/2.015124, 29/2.015920, 31/2.016148, 33/2.016219, 37/2.016249, 41/2.016252).
- ylims (0, 2.1) contain f (max ≈ 1.92, min ≈ 0.36) and every parabola. Nothing is clamped or masked.
- The last splits are below pixel resolution, but the blue label covers that, and the page says so.

