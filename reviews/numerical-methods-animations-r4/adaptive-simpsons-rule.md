# Adaptive Simpson's Rule — animation review (round 4)

Page: `pages/numerical-methods/adaptive-simpsons-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my own computations and with the frames, and the script runs the method it names. Section 2 lists each claim and Section 3 gives the evidence.

Observations that I judged are not findings:
- The order of the intermediate frames differs from Mathews' animation in one place. Mathews' sequence (Example 7 printout) has 1.935128 after 1.941436, which is the result of splitting [1/2,1] before [0,1/2] (I reproduced 1.935128 that way). The page splits [0,1/2] first and shows 2.008051. The page states its ordering rule ("widest failing panel, leftmost first") and follows it. The ordering of splits is a display choice: the final partition is the same, and the other 18 values in Mathews' list match the page's frames exactly. Mathews' animation adds 4 points per frame and the page adds 2. Neither difference matters to a reader.
- The "Approximation" shown in the frames is $\sum S(a,b)$, not the $\sum [S(a,m)+S(m,b)]$ that the recursive routine returns. The page says so explicitly and gives both values correctly, so this is disclosed and not misleading.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adaptivesimpsonsaa.jl` | 0 | 13.1 | adaptivesimpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | $S(a,b)=\frac{b-a}{6}[f(a)+4f(m)+f(b)]$ | script line 15 is the same formula; degree-of-precision test (below) shows it is exact for degree ≤ 3 and not for degree 4 | confirmed |
| D2 | "refinement compares $S(a,b)$ against $S(a,m)+S(m,b)$" | script line 20 | confirmed |
| D3 | Acceptance test of Mathews' routine: accept when $\lvert S(a,m)+S(m,b)-S(a,b)\rvert<\varepsilon_{[a,b]}$ | Mathews' `Adapt` (archive image `gr_2.gif`): `If[Abs[Sab - Sac - Scb] < tol, Return[Sac+Scb], Return[Adapt[a,c,tol/2]+Adapt[c,b,tol/2]]]`; script line 20 uses the same strict `<` test | confirmed |
| D4 | "the whole interval starts with ε and each half of a split interval gets half its tolerance" | script lines 28 and 37 (`t/2`); Mathews `tol/2` | confirmed |
| D5 | "refinement concentrates where curvature or oscillation is strongest" | 19 of the 41 nodes lie in [0,1/8], where $f'$ and the local oscillation rate $\tfrac{16}{3}x^{-1/3}$ blow up; [1.5,2] is never split | confirmed (qualitative) |
| D6 | 15ε variant "accepts 9 subintervals (the finest is $[0,1/32]$)" | independent recursion (`indep.py`, factor 15): 9 panels, finest 1/32 | confirmed |
| D7 | "instead of 20 (the finest is $[0,1/2048]$)" | independent recursion (factor 1): 20 panels, finest 1/2048 | confirmed |
| A1 | Function $f(x)=1+e^{-x}\sin(8x^{2/3})$ | script line 9; Mathews Ex. 7 (`gr_182.gif`) is the same function | confirmed |
| A2 | Interval $[0,2]$ | script line 10; Mathews `gr_183.gif` | confirmed |
| A3 | Tolerance $\varepsilon=10^{-3}$ | script line 12; frame label "tol = 0.001"; it reproduces Mathews' printed 20-value sequence and his 41-point final frame | confirmed |
| A4 | "Starting from the single panel [0,2]" | GIF frame 2 shows 3 points with approximation 2.491261 = S(0,2) (frame 1 shows the curve only) | confirmed |
| A5 | "each frame splits the widest panel that fails the test (leftmost first)" | the instrumented split list matches my independent breadth-first Python implementation split for split (`bfs.out`) | confirmed |
| A6 | "marks the two new sample points in blue" | script lines 119–120 plot the quarter points $(3p+q)/4$, $(p+3q)/4$, which are the new midpoints; blue in frames 3–21 (checked frames 3, 6, 21 and the sheet) | confirmed |
| A7 | "Approximation" is the composite Simpson sum of $S(a,b)$ over the panels drawn | `simpson_nonuniform` takes the node triples (p, m, q) of each panel, which `panel_nodes` builds, with weight $h/3=(q-p)/6$; the per-frame values equal my independent $\sum S(a,b)$ (table in §3) | confirmed |
| A8 | Case heading: $f$, $[0,2]$, $\varepsilon=10^{-3}$ | as A1–A3 | confirmed |
| B1 | "Refinement stops when all 20 panels (41 points) pass the test" | independent recursion: 20 panels, 41 points; final frame "Sample Points = 41" | confirmed |
| B2 | "$[1.5,2]$ is never split" | final panel list contains (3/2, 2) | confirmed |
| B3 | "19 of the 41 points lie in $[0,1/8]$" | instrumented count `points <= 1/8: 19`; independent count 19 (inclusive of 1/8) | confirmed |
| B4 | "The last seven frames split $[0,1/16],[0,1/32],\dots,[0,1/1024]$ in turn" | GIF frames 15–21 split [0,1/16], [0,1/32], [0,1/64], [0,1/128], [0,1/256], [0,1/512], [0,1/1024] | confirmed |
| B5 | "$f'$ is unbounded at $x=0$ ($f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0)" | sympy: $\lim_{x\to0^+} f'(x)\,x^{1/3} = 16/3$ | confirmed |
| B6 | "the panels split in the last five frames are at most 1/64 wide (under 5 pixels at this scale)" | last five split [0,1/64] … [0,1/1024]; plot box spans pixel columns 39–618 (579 px for 2 units), so 1/64 ≈ 4.5 px | confirmed |
| B7 | "so the blue label names each one" | `Split [0, 1/64]` … `Split [0, 1/1024]` labels present (sheet; frame 21 shows `Split [0, 1/1024]`) | confirmed |
| B8 | "The final estimate 2.016252" | instrumented 2.016252; independent $\sum S(a,b)$ = 2.01625176116; final frame label 2.016252; Mathews' final 2.016252 | confirmed |
| B9 | "the integral 2.016280" | mpmath, split quadrature: 2.0162797196171; via substitution $x=u^3$: 2.0162797196171 | confirmed |
| B10 | "differs … by $-2.8\times10^{-5}$" | 2.01625176 − 2.01627972 = −2.796e−5 | confirmed |
| B11 | "summing $S(a,m)+S(m,b)$ over the same panels, as the recursive routine returns, gives 2.016273" | independent 2.01627260396; instrumented 2.0162726039590058; Mathews' `Return[Sac+Scb]` | confirmed |
| L1 | Alt text: "one failing panel is split per frame, with sample points and panel boundaries drawn and the new points in blue" | frames 3–21 each show one split; red panel-boundary lines at `xs[1:2:end]`; blue new points | confirmed |
| L2 | Alt text: "ends with 41 points, 19 of them in [0, 1/8]" | as B1, B3 | confirmed |
| L3 | Alt text: "the piecewise quadratic approximation and integral estimate update each frame" | pink parabola per panel through its 3 nodes (Vandermonde fit; parabola values stay in [0.349, 1.976], inside ylims [0, 2.1]); label updates each frame | confirmed |
| W1 | Link `[Julia source](adaptivesimpsonsaa.jl)` → the script for this case | file exists; it is the only script | confirmed |
| W2 | Embed `adaptivesimpsonsaa.gif` produced by that script | manifest: the regenerated GIF is byte-identical to the committed one | confirmed |
| F1 | Fidelity to Mathews Example 7 / animation (function, interval, final 41 points, 2.016252) | archive Ex. 7 printout and final frame of `AdaptQuadaa.gif`: "Sample Points = 41, Approximation = 2.016252" | confirmed (intermediate ordering differs in one frame; see §1, not a finding) |

### 3. Implementation checks — `adaptivesimpsonsaa.jl`

**It is the method it claims to be.** The script runs adaptive Simpson with Mathews' acceptance test $\lvert S_{am}+S_{mb}-S_{ab}\rvert<t$ and halves the tolerance on each split, which is the archive's `Adapt` routine. It does not recurse. It processes the panels breadth-first (widest failing panel, leftmost first). Acceptance depends only on (p, q, t), and t is fixed by depth, so the final partition is the one the recursion accepts. My independent recursive implementation (`indep.py`, exact rational nodes, 40-digit mpmath) returns the same 20 panels: [0,1/2048], [1/2048,1/1024], …, [1/16,1/8], [1/8,3/16], [3/16,1/4], [1/4,3/8], [3/8,1/2], [1/2,5/8], [5/8,3/4], [3/4,7/8], [7/8,1], [1,5/4], [5/4,3/2], [3/2,2].

**The numbers are right.** Commands: `julia review/instr.jl` (a copy of script lines 1–73 with plotting removed, printing each frame) and an independent breadth-first Python implementation run with `/usr/bin/python3 -I` (output in `review/bfs.out`). The two sequences, along with Mathews' printed Example 7 sequence:

| GIF frame | split | points | script approx | independent | Mathews |
|---|---|---|---|---|---|
| 2 | – | 3 | 2.491261 | 2.491261 | 2.491261 |
| 3 | [0,2] | 5 | 1.611786 | 1.611786 | 1.611786 |
| 4 | [0,1] | 7 | 1.909633 | 1.909633 | 1.909633 |
| 5 | [1,2] | 9 | 1.941436 | 1.941436 | 1.941436 |
| 6 | [0,1/2] | 11 | 2.008051 | 2.008051 | (1.935128: splits [1/2,1] first) |
| 7 | [1/2,1] | 13 | 2.001744 | 2.001744 | 2.001744 |
| 8 | [1,3/2] | 15 | 2.003302 | 2.003302 | 2.003302 |
| 9 | [0,1/4] | 17 | 2.012445 | 2.012445 | 2.012445 |
| 10 | [1/4,1/2] | 19 | 2.013092 | 2.013092 | 2.013092 |
| 11 | [1/2,3/4] | 21 | 2.012906 | 2.012906 | 2.012906 |
| 12 | [3/4,1] | 23 | 2.012774 | 2.012774 | 2.012774 |
| 13 | [0,1/8] | 25 | 2.015124 | 2.015124 | 2.015124 |
| 14 | [1/8,1/4] | 27 | 2.015195 | 2.015195 | 2.015195 |
| 15 | [0,1/16] | 29 | 2.015920 | 2.015920 | 2.015920 |
| 16 | [0,1/32] | 31 | 2.016148 | 2.016148 | 2.016148 |
| 17 | [0,1/64] | 33 | 2.016219 | 2.016219 | 2.016219 |
| 18 | [0,1/128] | 35 | 2.016242 | 2.016242 | 2.016242 |
| 19 | [0,1/256] | 37 | 2.016249 | 2.016249 | 2.016249 |
| 20 | [0,1/512] | 39 | 2.016251 | 2.016251 | 2.016251 |
| 21 | [0,1/1024] | 41 | 2.016252 | 2.016252 | 2.016252 |

Property check on the script's Simpson formula (`julia review/dop.jl`, $\int_{0.3}^{1.7}x^k$): the error is 0 for k = 0, 1, 2, 4.4e−16 for k = 3, 0.0448 for k = 4 and 0.224 for k = 5. The degree of precision is 3, as it should be.

Fine-level sum $\sum[S(a,m)+S(m,b)]$: script 2.0162726039590058; independent 2.01627260396.

**Reference values are right.** The page's integral 2.016280 is not computed by the script; it appears only in the page text. I computed it independently two ways. mpmath `quad` with breakpoints at 1/1024, 1/64, 1/8, 0.5 and 1 gives 2.0162797196171. The substitution $x=u^3$, which removes the $x^{2/3}$ singularity, gives 2.0162797196171. These agree to 14 digits, so 2.016280 is correct to the 6 decimals stated.

**The picture shows what was computed.** I viewed frames 1, 2, 6 and 21 at full size and the contact sheet (frames 1, 3, 5, …, 21).
- Frame 1 shows the curve only. Frame 2 shows the single panel [0,2]: a parabola through (0,1), (1,1.364), (2,1.016) and the label 2.491261.
- Each pink region is the parabola through that panel's 3 nodes, filled to y = 0. The instrumented parabola range over all frames is [0.349, 1.976], inside ylims (0, 2.1), so nothing is clipped. max f = 1.920.
- Red vertical lines are drawn at panel endpoints only (`xs[1:2:end]`).
- The blue points are the two new nodes, and the blue "Split [p, q]" label names the panel split in that frame. In frames 17–21 the split panel is ≤ 4.5 px wide, so the blue points merge into a blob at x ≈ 0. The label is what makes those frames readable, as the page says.
- The labels "Sample Points", "Approximation" and "tol" match the computed values in the table above.
- The axis window is [0,2] × [0,2.1] and covers the whole function. There is no clamping or NaN masking.
- The title "Adaptive Simpson's Rule" carries no function, so it cannot contradict the code.

Nothing in the frames contradicts the page.

