# Adaptive Simpson's Rule — animation review (round 7)

Page: `pages/numerical-methods/adaptive-simpsons-rule/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Fidelity, Minor: the 11-point stage differs from Mathews' sequence

- **Location:** `index.qmd` line 27 ("each frame splits the widest panel that fails the test (leftmost first)"); `adaptivesimpsonsaa.jl` line 34; GIF frame 6.
- **What is there now:** At the 11-point stage the script splits $[0,1/2]$ and shows Approximation = 2.008051.
- **What the archive has:** Mathews splits $[1/2,1]$ first at this stage. His 11-point node set contains 0.625 and 0.875 rather than 0.125 and 0.375, and his table and animation show 1.935128.
- **How I know:** `indep2.py` parsed all 20 of Mathews' node sets from `AdaptiveQuadMod_lnk_8.html` and compared them with the script's, and compared the script's sums with the 20 table values read from `gr_185`-`gr_204`:

  ```
  differs at set 5: points 11, script 2.008051, Mathews 1.935128, same nodes False
    Mathews-only: [0.625, 0.875]  script-only: [0.125, 0.375]
  Simpson on Mathews 11-node set: 1.935128276117348
  ```

  The other 19 node sets and 19 values agree. Both orders are valid and reach the same final partition, because the test on a panel does not depend on the order of the splits. The page states its own order but does not say this differs from the source.
- **Suggested correction:** Either add to line 27: "(Mathews' trace splits $[1/2,1]$ before $[0,1/2]$, so his 11-point value is 1.935128; every other stage agrees)", or reproduce his order at that one step.

- **Independent check:** not run (Minor finding, unverified)

### F2. Page match, Minor: "41 points" is the drawn node count, not the number of points the test samples

- **Location:** `index.qmd` line 33 ("Refinement stops when all 20 panels (41 points) pass the test"); the alt text on line 37 ("ends with 41 points"); the GIF label "Sample Points = 41" (`adaptivesimpsonsaa.jl` line 113).
- **What is there now:** The sentence ties the test to 41 points.
- **What is true:** 41 is the number of nodes of the drawn composite rule, and it is the correct count for the displayed Approximation. The test on each panel also evaluates $f$ at that panel's two quarter-points, so reaching this partition takes **81 distinct evaluation points** ($4\cdot 20+1$). The value 2.016273 that the page quotes from the recursive routine uses all 81.
- **How I know:** `indep.py` recorded every point the recursive routine evaluates: `leaves 20 distinct f evaluation points by Adapt 81`. Mathews uses the same "sample points" label, so this is inherited, and the page makes no explicit claim about cost.
- **Suggested correction:** On line 33, write "when all 20 panels pass the test. The 41 points drawn are the nodes of the composite rule; the test also evaluates each panel's two quarter-points, so the routine samples $f$ at 81 points."

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `adaptivesimpsonsaa.jl` | 0 | 9.3 | adaptivesimpsonsaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Where | Evidence | Verdict |
|---|---|---|---|---|
| 1 | $S(a,b)=\frac{b-a}{6}[f(a)+4f(m)+f(b)]$ | l.14 | Script l.15. Exact on $x^3$, not on $x^4$; error ratio approaches 16 | Confirmed |
| 2 | "refinement compares $S(a,b)$ against $S(a,m)+S(m,b)$" | l.16 | Script l.20 | Confirmed |
| 3 | "the acceptance test of Mathews' routine": $\lvert S(a,m)+S(m,b)-S(a,b)\rvert<\varepsilon_{[a,b]}$ | l.18-20 | Mathews `gr_2`; script l.20, strict `<` in both | Confirmed |
| 4 | Whole interval starts with $\varepsilon$; each half gets half the tolerance | l.22 | `gr_2` (`tol/2`); script l.37 | Confirmed |
| 5 | "refinement concentrates where curvature or oscillation is strongest" | l.22 | Final widths run from 1/2048 near 0 (huge $\lvert f''\rvert$) to 1/2 on $[1.5,2]$ (max $\lvert f''\rvert$ 5.16) | Confirmed as a trend |
| 6 | With $15\varepsilon$: 9 subintervals | l.22 | `indep.py`: 9 panels | Confirmed |
| 7 | With $15\varepsilon$: finest is $[0,1/32]$ | l.22 | Partition 0, 1/32, 1/16, 1/8, 1/4, 1/2, 3/4, 1, 3/2, 2 ($[1/32,1/16]$ ties in width) | Confirmed |
| 8 | Without it: 20 subintervals, finest $[0,1/2048]$ | l.22 | `indep.py`: 20 panels ($[1/2048,1/1024]$ ties in width) | Confirmed |
| 9 | $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$, $\varepsilon=10^{-3}$ | l.27, l.31 | Script l.9-12; Mathews `gr_182`, `gr_183`, call `Adapt[0,2,0.001]` | Confirmed |
| 10 | "Starting from the single panel $[0,2]$" | l.27 | GIF frame 2: 3 points, 2.491261 (frame 1 is the curve alone) | Confirmed |
| 11 | "each frame splits the widest panel that fails the test (leftmost first)" | l.27 | Script l.32-34; independent simulation gives the same 19 splits | Confirmed (order differs from Mathews at one step, see F1) |
| 12 | "marks the two new sample points in blue" | l.27 | 38 of 38 expected blue markers found at the computed pixels, GIF frames 3-21 | Confirmed |
| 13 | "Approximation" is the composite Simpson sum of $S(a,b)$ over the panels drawn | l.27 | All 20 sums match the independent 40-digit computation | Confirmed |
| 14 | Julia source is linked under the case | l.29, l.35 | Link resolves to the script that produces the embedded GIF | Confirmed |
| 15 | "all 20 panels (41 points) pass the test" | l.33 | 20 panels, 41 nodes, largest test ratio $d/t=0.906$ | Numbers confirmed; wording see F2 |
| 16 | "$[1.5,2]$ is never split" | l.33 | Accepted whole; absent from all 19 splits | Confirmed |
| 17 | "19 of the 41 points lie in $[0,1/8]$" | l.33, l.37 | 19 counting the endpoint 1/8 | Confirmed |
| 18 | "The last seven frames split $[0,1/16],\dots,[0,1/1024]$ in turn" | l.33 | Labels of GIF frames 15-21 | Confirmed |
| 19 | "because $f'$ is unbounded at $x=0$" | l.33 | On $[0,h]$ the test quantity shrinks by 3.175 ($\approx 2^{5/3}$) per halving against 2 for the tolerance, so $d/t$ falls slowly: 14.56 at $h=1/32$, 0.906 at $h=1/2048$ | Confirmed |
| 20 | $f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0 | l.33 | Ratio 0.99960 at $10^{-4}$, 0.999997 at $10^{-6}$, 1.0000 at $10^{-9}$ | Confirmed |
| 21 | Panels split in the last five frames are at most 1/64 wide | l.33 | Frames 17-21 split $[0,1/64]$ to $[0,1/1024]$ | Confirmed |
| 22 | "under 5 pixels at this scale" | l.33 | Plot box 579 px over width 2, so 1/64 is 4.52 px | Confirmed |
| 23 | "the blue label names each one" | l.33 | Frames 17-21 read "Split [0, 1/64]" to "Split [0, 1/1024]" | Confirmed |
| 24 | Final estimate 2.016252 | l.33 | Script 2.0162517612; independent 2.01625176116 | Confirmed |
| 25 | Integral 2.016280 | l.33 | 2.0162797196170963 by two quadratures (direct, and $x=u^3$) | Confirmed |
| 26 | Difference $-2.8\times10^{-5}$ | l.33 | $-2.7958\times10^{-5}$ | Confirmed |
| 27 | $S(a,m)+S(m,b)$ over the same panels, "as the recursive routine returns", gives 2.016273 | l.33 | 2.01627260396; `gr_2` returns `Sac + Scb` | Confirmed |
| 28 | Alt text: one failing panel split per frame, points and boundaries drawn, new points in blue | l.37 | Frames 3-21 | Confirmed |
| 29 | Alt text: ends with 41 points, 19 in $[0,1/8]$ | l.37 | As #15, #17 | Confirmed (see F2) |
| 30 | Alt text: piecewise quadratic and estimate update each frame | l.37 | Drawn parabolas interpolate the nodes (residual $\le 10^{-15}$); label changes every frame from 3 on | Confirmed |
| 31 | Embed shows this case | l.37 | GIF is the script's output, byte-identical on regeneration | Confirmed |

---

### 3. Implementation checks: `adaptivesimpsonsaa.jl`

**It is the method it claims to be.** The test and tolerance halving match Mathews' `Adapt` (`gr_2`). The script runs them in level order instead of depth first, which changes only the order of the frames. An independent recursive implementation gives the same final partition as the script (`indep4.py`: `recursive partition == script final node set: True`, 20 panels). The variant is Mathews' test without the factor 15 and without Richardson correction, as the page says.

**The numbers are right.** Script against an independent 40-digit computation with exact dyadic nodes (`indep.py`): all 20 node sets, split labels and sums agree.

| Quantity | Script | Independent |
|---|---|---|
| Panels / nodes | 20 / 41 | 20 / 41 |
| Final $\sum S(a,b)$ | 2.0162517612 | 2.01625176116 |
| Final $\sum [S(a,m)+S(m,b)]$ | not computed by the script | 2.01627260396 |
| Largest $d/t$ among accepted panels | | 0.906 (not close to the threshold, so not sensitive to rounding) |

Property checks on the script's own routines:

| Check | Result |
|---|---|
| $x^3$ on $[0,2]$ | $S=4.0$, exact, 1 panel |
| $x^4$ on $[0,2]$ | $S(0,2)=6.6667$ against 6.4, so degree of precision is 3; adaptive result 6.401042 |
| $\sqrt{x}$ on $[0,2]$ | 13 panels, error $-1.33\times10^{-4}$, within tolerance |
| $e^x$ with panels doubled | error ratios 14.70, 15.65, 15.91, 15.98, approaching $2^4$ |

**Reference values are right.** The script draws no exact curve other than $f$ itself. The page's integral 2.016280 is confirmed by two high-precision quadratures agreeing to 20 digits, one of which removes the endpoint singularity with $x=u^3$.

**The picture shows what was computed** (`inst2.jl`, `indep4.py`, frames viewed).

- Each drawn parabola passes through its three nodes (maximum residual $1.0\times10^{-15}$), and its area equals $S$ for the panel (maximum difference $4.4\times10^{-16}$).
- Panel boundaries are the odd-indexed nodes; every set has the structure boundary, midpoint, boundary with $2k+1$ points.
- All drawn parabolas lie in $[0.349, 1.976]$ and $f$ peaks at 1.920, inside the axis limits $[0, 2.1]$. Nothing is clamped or masked.
- All 21 frame labels were read from a montage and match the computed values.
- All 38 blue markers are at the quarter-points of the panel named in the label.

**Archive.** The page's example is Mathews' Example 7, the only one with an animation. Function, interval and tolerance match, and 19 of his 20 stages are reproduced to the printed six decimals. Examples 1-6 are static worked examples with no animation, so leaving them out is not a dropped case. The one departure is F1.

