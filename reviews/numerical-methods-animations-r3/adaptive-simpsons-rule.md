# Adaptive Simpson's Rule — animation review (round 3)

Page: `pages/numerical-methods/adaptive-simpsons-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no error, nothing misleading and no fidelity departure. Every checkable claim on the page agrees with an independent computation or with the frames (see the ledger). The items below were considered and judged not to be findings:

- The introduction says "Each animation below shows ..." although there is only one animation. This is template wording and does not mislead.
- GIF frame 1 shows only the curve, and frame 2 shows the initial single panel with no split. The phrase "Starting from the single panel $[0,2]$, each frame splits ..." accounts for this. Frames 3 to 21 each split exactly one panel.
- The GIF runs at 2 fps with no hold on the last frame, and the last frame still carries the "Split [0, 1/1024]" label and blue points, so the finished state is not marked separately. This is cosmetic. The numbers on that frame are the final ones and the page states them.
- The order of splits is widest-first, not Mathews' recursive trace order (his trace splits $[1/2,1]$ before $[0,1/2]$). The final partition is the same, both mathematically and against his traced node list (see Implementation checks), and the page describes the order the script really uses.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adaptivesimpsonsaa.jl` | 0 | 9.1 | adaptivesimpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | $S(a,b)=\frac{b-a}{6}[f(a)+4f(m)+f(b)]$ | confirmed | Script line 15 matches. The rule is exact for $x^0$ to $x^3$ and not for $x^4$ (0.208333 vs 0.2) in `indep.py`. |
| D2 | "refinement compares $S(a,b)$ against $S(a,m)+S(m,b)$" | confirmed | Script line 20 |
| D3 | "the acceptance test of Mathews' routine: $[a,b]$ is accepted when $\lvert S(a,m)+S(m,b)-S(a,b)\rvert<\varepsilon_{[a,b]}$" | confirmed | Archive `Adapt` (gr_2): `If[Abs[Sab-Sac-Scb] < tol, Return[Sac+Scb], Return[Adapt[a,c,tol/2]+Adapt[c,b,tol/2]]]`. Script line 20 implements the same test. |
| D4 | "the whole interval starts with $\varepsilon$ and each half of a split interval gets half its tolerance" | confirmed | Script lines 28 and 37: `(p, m, t/2), (m, q, t/2)` |
| D5 | "so refinement concentrates where curvature or oscillation is strongest" | confirmed (qualitative) | The refinement concentrates at $x=0$, where $f''$ is unbounded, and in the steep oscillation on $[0,1]$. $[1,2]$ gets only 3 panels. |
| D6 | "A common variant uses $15\,\varepsilon_{[a,b]}$ ... accepts 9 subintervals (the finest is $[0,1/32]$)" | confirmed | `indep.py` with factor 15 gives 9 panels; the finest is $[0, 1/32]$. |
| D7 | "... instead of 20 (the finest is $[0,1/2048]$)" | confirmed | `indep.py` with factor 1 gives 20 panels; the finest is $[0,1/2048]$. |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$, $\varepsilon=10^{-3}$ (intro and Case 1 heading) | confirmed | Script lines 9, 10 and 12. The archive's Example 7 has the same $f$ and interval and calls `Adapt[0,2,0.001]`. |
| A2 | "each frame splits the widest panel that fails the test (leftmost first)" | confirmed | Script line 34 sorts by (−width, left end). The instrumented split sequence is $[0,2],[0,1],[1,2],[0,\tfrac12],[\tfrac12,1],[1,\tfrac32],[0,\tfrac14],[\tfrac14,\tfrac12],[\tfrac12,\tfrac34],[\tfrac34,1],[0,\tfrac18],[\tfrac18,\tfrac14],[0,\tfrac1{16}],\dots,[0,\tfrac1{1024}]$, which is non-increasing in width and leftmost first within each width. |
| A3 | "marks the two new sample points in blue" | confirmed | Script lines 119–120 place the points at $(3p+q)/4$ and $(p+3q)/4$, the midpoints of the new halves. Frames 3, 5, 7, 9 and 11 show two blue points at those positions (for example 0.5 and 1.5 after splitting $[0,2]$). |
| A4 | "'Approximation' is the composite Simpson sum of $S(a,b)$ over the panels drawn" | confirmed | `simpson_nonuniform` uses $h=(x_2-x_0)/2$ and $(h/3)(\dots)$, which equals $S(x_0,x_2)$ per panel. The frame values match my independent sums (for example frame 2: 2.491261, the same as the archive's first frame). |
| A5 | "Julia source scripts ... are linked under each case" | confirmed | `[Julia source](adaptivesimpsonsaa.jl)` exists |
| C1 | "Refinement stops when all 20 panels (41 points) pass the test" | confirmed | Instrumented run: the last node set has 41 points. The independent recursion has 20 accepted panels. In `margins.py` every leaf has ratio below 1 and every internal panel ratio at least 1. |
| C2 | "$[1.5,2]$ is never split" | confirmed | `margins.py`: $[1.5,2]$ has ratio 0.370 and is accepted. |
| C3 | "19 of the 41 points lie in $[0,1/8]$" | confirmed | Instrumented run gives 19, and so does `indep.py`. |
| C4 | "The last seven frames split $[0,1/16],[0,1/32],\dots,[0,1/1024]$ in turn" | confirmed | GIF frames 15–21 have those splits in order (the instrumented printout matches the frame labels in `sheet.png` and `frame_021.png`). |
| C5 | "$f'$ is unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0)" | confirmed | mpmath gives $f'(10^{-9})=5333.33332$, against $\tfrac{16}{3}\cdot10^{3}=5333.33333$. |
| C6 | "the panels split in the last five frames are at most $1/64$ wide" | confirmed | Frames 17–21 split $[0,1/64]$ through $[0,1/1024]$. |
| C7 | "(under 5 pixels at this scale)" | confirmed | The plot area spans about 578 px for 2 units in the 640 px frame, so $1/64$ is about 4.5 px. |
| C8 | "the blue label names each one" | confirmed | Frames 17–21 carry the blue labels "Split [0, 1/64]" through "Split [0, 1/1024]". |
| C9 | "The final estimate $2.016252$" | confirmed | Script final value 2.016251761. My composite sum over the 20 panels is 2.016251761. Last frame of the GIF and of the archive animation both show 2.016252. |
| C10 | "the integral $2.016280$" | confirmed | mpmath with the substitution $x=t^3$ gives 2.0162797196171; scipy `quad` gives 2.0162797196174. |
| C11 | "differs ... by $-2.8\times10^{-5}$" | confirmed | $2.016251761-2.016279720=-2.796\times10^{-5}$ |
| C12 | "summing $S(a,m)+S(m,b)$ over the same panels, as the recursive routine returns, gives $2.016273$" | confirmed | The independent recursive `Adapt`, returning $S_{ac}+S_{cb}$, gives 2.016272604. |
| I1 | Alt text: "one failing panel is split per frame" | confirmed | Frames 3–21 each split one panel. Frames 1 and 2 are the blank curve and the initial panel. |
| I2 | Alt text: "sample points and panel boundaries drawn and the new points in blue" | confirmed | Frames show red points, red vertical lines at panel endpoints `xs[1:2:end]`, and blue new points. |
| I3 | Alt text: "the refinement ends with 41 points, 19 of them in $[0,1/8]$" | confirmed | As C1 and C3 |
| I4 | Alt text: "the piecewise quadratic approximation and integral estimate update each frame" | confirmed | Each panel's parabola is the quadratic interpolant through its three nodes (interpolation residual 0 on $[0,1/2048]$ and $4\times10^{-16}$ on $[1.5,2]$). The "Approximation" text changes on every frame from 2 to 21. |
| W1 | Embed `adaptivesimpsonsaa.gif` and link `adaptivesimpsonsaa.jl` belong to Case 1 | confirmed | There is only one script, and it produces this GIF. The regenerated GIF is byte-identical to the committed one. |
| W2 | Counts: one case, 21 GIF frames (1 blank + 20 node sets) | confirmed | `length(node_sets)=20`, so the loop `0:20` gives 21 frames. The extracted committed GIF has 21 frames. |

### 3. Implementation checks: `adaptivesimpsonsaa.jl`

**It is the method it claims to be.** The script runs adaptive Simpson quadrature with Mathews' acceptance test. A panel with tolerance $t$ is accepted if $\lvert S(p,m)+S(m,q)-S(p,q)\rvert<t$; otherwise it is halved and each half gets $t/2$. This is exactly the archive's `Adapt` (gr_2), without the factor 15 and without Richardson correction, and the page names it as such.

The refinement runs breadth-first (widest failing panel first) instead of recursively. Whether a panel is accepted depends only on the panel and on its tolerance, which is fixed by its depth as $\varepsilon/2^{\text{depth}}$. The set of accepted leaves is therefore independent of the visiting order, so the final partition is the one the recursive routine returns. I confirmed this numerically:

- The 20 panels from my recursive `indep.py` equal the script's final panels.
- The script's 41 final nodes match the last row of Mathews' traced node list in `lnk_8.html` to the 6 printed digits (maximum relative difference $4\times10^{-6}$, which is print rounding).

**The numbers are right.** Script values from the instrumented copy, set beside my independent values:

| Quantity | Script | Independent |
|---|---|---|
| Frame 2 (3 points) | 2.491261017 | archive frame: 2.491261 |
| Final composite $\sum S(a,b)$, 41 points | 2.016251761 | 2.016251761 (`indep.py`) |
| Recursive value $\sum[S(a,m)+S(m,b)]$ | (not computed by the script; quoted on the page as 2.016273) | 2.016272604 |
| Number of panels / points | 20 / 41 | 20 / 41 |
| Finest panel | $[0,1/2048]$ | $[0,1/2048]$ |
| 15ε variant | (not in the script) | 9 panels, finest $[0,1/32]$ |

The Simpson rule has degree of precision 3, confirmed by exact results for $x^0$ to $x^3$ and failure for $x^4$ and $x^5$.

The acceptance decisions are not near the floating-point threshold. The ratio $\lvert\Delta\rvert/t$ closest to 1 is 1.0599 on $[3/4,1]$ (split), and the next is 0.906 on $[0,1/2048]$ (accepted), so the partition is robust to rounding.

**Its reference values are right.** The script draws no reference value. The page quotes the integral as 2.016280. Two independent computations give 2.01627971962: mpmath with the smoothing substitution $x=t^3$, and scipy `quad` with an error estimate of $2.4\times10^{-9}$.

**The picture shows what was computed.** I viewed frames 1, 2, 21 and the contact sheet (frames 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21). Each pink region is the quadratic interpolant through a panel's three nodes, filled down to 0. The vertical red lines sit at panel endpoints only, the red dots are all nodes, and the blue dots are the two new midpoints of the split panel. The labels "Sample Points", "Approximation", "tol" and "Split [p, q]" match the instrumented printout frame by frame (for example frame 3: 5 points, 1.611786, Split [0, 2]; frame 21: 41 points, 2.016252, Split [0, 1/1024]).

The y-limits $(0,2.1)$ contain the whole curve: the maximum of $f$ is about 1.92 and the minimum about 0.36. Nothing is clamped or masked, and the function in the code is the function on the page.

