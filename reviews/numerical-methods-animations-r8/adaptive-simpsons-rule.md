# Adaptive Simpson's Rule — animation review (round 8)

Page: `pages/numerical-methods/adaptive-simpsons-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, in the script's header/comments and in the frames was confirmed against independent computation (details below). I did not find an implementation error, a page/animation mismatch, or a fidelity departure from Mathews' Example 7.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adaptivesimpsonsaa.jl` | 0 | 9.8 | adaptivesimpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | $S(a,b)=\frac{b-a}{6}[f(a)+4f(m)+f(b)]$ | script line 15 identical; standard Simpson | confirmed |
| D2 | "refinement compares $S(a,b)$ against $S(a,m)+S(m,b)$" | script line 20 | confirmed |
| D3 | Acceptance test $\lvert S(a,m)+S(m,b)-S(a,b)\rvert<\varepsilon_{[a,b]}$ is "the acceptance test of Mathews' routine" | Mathews `gr_2.gif`: `If[Abs[Sab-Sac-Scb] < tol, Return[Sac+Scb], Return[Adapt[a,c,tol/2]+Adapt[c,b,tol/2]]]`; script line 20 uses strict `<` | confirmed |
| D4 | whole interval starts with ε, each half of a split interval gets half its tolerance | script lines 31, 42 (`t/2`); matches Mathews | confirmed |
| D5 | 15ε variant "accepts 9 subintervals (the finest is $[0,1/32]$) instead of 20 (the finest is $[0,1/2048]$)" | `indep.py` K=15: 9 panels, finest `[0,1/32]`,`[1/32,1/16]`; K=1: 20 panels, finest `[0,1/2048]`,`[1/2048,1/1024]` | confirmed |
| A1 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$, $\varepsilon=10^{-3}$ (intro and Case 1 heading) | script lines 9–12; Mathews `gr_182` `f[x]=1+e^-x Sin[8x^(2/3)]`, `Adapt[0,2,0.001]` | confirmed |
| A2 | "Starting from the single panel $[0,2]$, each frame splits the widest panel that fails the test (leftmost first, except that $[1/2,1]$ is split before $[0,1/2]$, as in Mathews' trace)" | split sequence (both `inst.jl` and `indep.py`): [0,2],[0,1],[1,2],[1/2,1],[0,1/2],[1,3/2],[0,1/4],[1/4,1/2],[1/2,3/4],[3/4,1],[0,1/8],[1/8,1/4],[0,1/16],…,[0,1/1024]; widths non-increasing, leftmost within width except the stated exception; all 20 node sets equal Mathews' Example 7 trace (`all node sets match Mathews: True`) | confirmed |
| A3 | "marks the two new sample points in blue" | script line 124 plots $(3p+q)/4,(p+3q)/4$ = midpoints of the new halves = the two new nodes; frames 6, 21 show blue at 0.625/0.875 and near 0 | confirmed |
| A4 | "Approximation" is the composite Simpson sum of $S(a,b)$ over the panels drawn | `simpson_nonuniform` (lines 68–78) sums $S$ over consecutive node triples = panels; values equal `indep.py` composite to 9 digits | confirmed |
| A5 | Julia source linked under each case | `[Julia source](adaptivesimpsonsaa.jl)`; GIF embed `adaptivesimpsonsaa.gif`; manifest: GIF byte-identical to script output | confirmed |
| B1 | "Refinement stops when all 20 panels pass the test." | 20 panels at termination, no failing panel | confirmed |
| B2 | "The 41 points drawn are the nodes of the composite rule" | final node set 41 points; last frame label "Sample Points = 41" | confirmed |
| B3 | "the test also evaluates each panel's two quarter-points, so reaching this partition samples $f$ at 81 distinct points" | `indep.py` set of every point evaluated by recursive `Adapt`: 81 distinct | confirmed |
| B4 | "$[1.5,2]$ is never split" | no split with left end ≥ 3/2; final panels include `[3/2,2]` | confirmed |
| B5 | "19 of the 41 nodes lie in $[0,1/8]$" | `indep.py`: 19 (closed interval) | confirmed |
| B6 | "The last seven frames split $[0,1/16],[0,1/32],\dots,[0,1/1024]$ in turn" | node sets 14–20 = GIF frames 15–21 split exactly these 7 | confirmed |
| B7 | "because $f'$ is unbounded at $x=0$ ($f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0)" | $f'=e^{-x}[\tfrac{16}{3}x^{-1/3}\cos(8x^{2/3})-\sin(8x^{2/3})]\to\tfrac{16}{3}x^{-1/3}$ | confirmed |
| B8 | "the panels split in the last five frames are at most $1/64$ wide (under 5 pixels at this scale), so the blue label names each one" | last five splits [0,1/64]…[0,1/1024]; axis spans pixel columns 39–618 in a 630 px frame → 289.5 px/unit → 1/64 = 4.5 px; label "Split [0, 1/64]" … "Split [0, 1/1024]" present (frames 17–21) | confirmed |
| B9 | "The final estimate $2.016252$" | script 2.016251761; `indep.py` 2.016251761; Mathews table `gr_204` 2.016252; last frame label 2.016252 | confirmed |
| B10 | "differs from the integral $2.016280$ by $-2.8\times10^{-5}$" | mpmath quad (split at 1/4096, 1/64, 1/8, 1/2, 1): 2.0162797196…; difference −2.796e−5 | confirmed |
| B11 | "summing $S(a,m)+S(m,b)$ over the same panels, as the recursive routine returns, gives $2.016273$" | recursive `Adapt` return: Julia 2.016272604, Python 2.016272604 | confirmed |
| T1 | Alt text: "one failing panel is split per frame, with sample points and panel boundaries drawn and the new points in blue" | frames 3–21 each one split, red nodes, red vertical boundaries at panel ends, blue new nodes | confirmed |
| T2 | Alt text: "the refinement ends with 41 points, 19 of them in [0, 1/8]" | B2, B5 | confirmed |
| T3 | Alt text: "the piecewise quadratic approximation and integral estimate update each frame" | pink filled quadratics per panel and "Approximation" label change every frame from frame 2 | confirmed |
| S1 | Script comment: following Mathews' order at one step "reproduces all 20 of his node sets" | parsed Mathews trace: 20 sets, all equal | confirmed |
| S2 | Script comment: "The final partition is the one the recursive routine accepts." | recursive DFS panel list (20 panels) and level-order final partition have identical nodes and identical composite sum 2.016251761 | confirmed |

### 3. Implementation checks — `adaptivesimpsonsaa.jl`

**Method is what it claims.** Adaptive Simpson quadrature in Mathews' variant: acceptance `|S(a,m)+S(m,b)−S(a,b)| < t`, tolerance halved on each split, no factor 15, no Richardson correction; the displayed estimate is the composite $\sum S(a,b)$ over the accepted partition, while Mathews' recursive routine returns $\sum[S(a,m)+S(m,b)]$. Both points are stated on the page (D3, D5, A4, B11). The split order is a breadth-first (widest-first) replay of the recursion rather than depth-first recursion; since each panel's accept/reject decision depends only on the panel and its depth-determined tolerance, the final partition is identical (S2), and the replay matches Mathews' own published trace (A2).

**Numbers are right.** Script (instrumented copy `inst.jl`) vs independent `indep.py` vs Mathews:

| set | pts | script | independent | Mathews | split |
|---|---|---|---|---|---|
| 1 | 3 | 2.491261017 | 2.491261 | 2.491261 | – |
| 2 | 5 | 1.611786329 | 1.611786 | 1.611786 | [0,2] |
| 3 | 7 | 1.909633195 | 1.909633 | 1.909633 (legacy GIF) | [0,1] |
| 5 | 11 | 1.935128276 | 1.935128 | 1.935128 (legacy GIF) | [1/2,1] |
| 7 | 15 | 2.003302106 | 2.003302 | 2.003302 (legacy GIF) | [1,3/2] |
| 9 | 19 | 2.013092144 | 2.013092 | 2.013092 (legacy GIF) | [1/4,1/2] |
| 11 | 23 | 2.012773693 | 2.012774 | 2.012774 (legacy GIF) | [3/4,1] |
| 12 | 25 | 2.015124346 | 2.015124 | 2.015124 (`gr_196`) | [0,1/8] |
| 13 | 27 | 2.015195262 | 2.015195 | 2.015195 (legacy GIF) | [1/8,1/4] |
| 15 | 31 | 2.016147759 | 2.016148 | 2.016148 (legacy GIF) | [0,1/32] |
| 17 | 35 | 2.016241748 | 2.016242 | 2.016242 (legacy GIF) | [0,1/128] |
| 19 | 39 | 2.016251059 | 2.016251 | 2.016251 (legacy GIF) | [0,1/512] |
| 20 | 41 | 2.016251761 | 2.016251761 | 2.016252 (`gr_204`) | [0,1/1024] |

All 20 rows agree (full table in `indep.py`/`inst.jl` output). Recursive return 2.016272604 in both implementations.

**Reference values.** The page's integral 2.016280 checked with mpmath at 30 digits: 2.01627971961709632…; it is not drawn in the GIF. $f'$ asymptotic (B7) verified analytically.

**Picture shows what was computed.** Frames 1, 2, 6, 21 viewed at full size and the contact sheet (frames 1–21 sampled). Frame 1 is the bare curve; frame 2 the single panel [0,2] (3 points, 2.491261, no split label); frames 3–21 each add one split with the blue label naming $[p,q]$ and blue markers at the two new nodes, which are the quarter-points $(3p+q)/4,(p+3q)/4$ of the split panel. Pink regions are the interpolating quadratic through each panel's three nodes (Vandermonde solve, exact for 3 points; the smallest panel [0,1/2048] is well within double-precision conditioning), filled to $y=0$, so their area equals the displayed $S$. Panel boundaries are `xs[1:2:end]`, the panel endpoints. The curve in the plot is the same `f` as the heading. Axis window $[0,2]\times[0,2.1]$ contains the curve (max ≈ 1.93) and every drawn quadratic. No clamping or masking. Labels show the correct counts and sums per frame (checked against the table above for frames 2, 4, 6, 8, 11, 13, 15, 17, 19, 21).

**Fidelity to the archive.** Function, interval, tolerance, acceptance test, split order, all 20 node sets and the approximation sequence match Mathews' Example 7 and his animation `AdaptQuadaa.gif` (24 frames, beginning with two title frames; the approximation values on the sampled frames, listed in the table above, match the script's). Mathews' Examples 1–6 are non-animated worked examples and his only animation is this case, so the page drops no animated case.

