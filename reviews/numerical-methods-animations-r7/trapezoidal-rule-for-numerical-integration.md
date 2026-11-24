# Trapezoidal Rule for Numerical Integration — animation review (round 7)

Page: `pages/numerical-methods/trapezoidal-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Errors 0, Misleading 0, Minor 0, Fidelity 0.

Considered and deliberately not reported, because none changes what a reader concludes:

- Frame labels at 19 and 49 sample points read `1.98554` and `2.01017`, because `round(...; digits=6)` drops a trailing zero (`trapezoidalaa.jl:46`). The values are right (1.985540 and 2.010170); only the display width differs.
- The partition sequence differs from Mathews'. Legacy sample points: 2, 3, 5, 7, 9, 11, 13, 15, 17, 21, 25, 29, 33, 41, 51, 61, 71, 81, 101, 121. The page adds 4, 6, 8, 19, 49, 57, 73, 97 and omits 51, 61, 71, 81, 101. Function, interval, first and last counts, and every shared value agree, and the page makes no claim about following Mathews' sequence.
- The legacy frames carry node dots and the function formula inside the plot. The new GIF has neither. The formula is in the page's case heading and the nodes are visible as the panel edges.
- Mathews' Examples 1 to 10 are worked examples on other integrals. Only Example 11 is tied to an animation (`grep -il animation` on the Links folder returns only `lnk_12`), and the archive lists exactly one trapezoidal animation. No animation case was dropped.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `trapezoidalaa.jl` | 0 | 9.3 | trapezoidalaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `trapezoidalaa.gif` | 24 | byte-identical | trapezoidalaa |

### Page references

- Scripts linked: `trapezoidalaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Reference: $I = 2.0162797196170963$ (see section 3).

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description | Replaces $f$ on each subinterval "with a line segment between neighboring nodes" | Polygon audit: every panel top joins $(x_i,f(x_i))$ to $(x_{i+1},f(x_{i+1}))$, max vertex deviation $6.7\times10^{-16}$ | confirmed |
| 2 | Description | $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1}f(x_i)+\tfrac12 f(x_n)]$, $h=(b-a)/n$ | `trapezoidalaa.jl:18-22` is this formula; independent NumPy sum agrees at all 23 $n$ to 6 decimals | confirmed |
| 3 | Description | For $C^2$ $f$, $T_n-I=O(h^2)$ | Script routine on $e^x$ over $[0,2]$: error ratios 3.9969, 3.9992, 3.9998, 3.99995 for $n=8,16,32,64$; on $x^2$, $T_4-I=0.083333=(b-a)h^2f''/12$ | confirmed |
| 4 | Description | "accuracy improves as node spacing is reduced across the full interval" (stated for smooth $f$) | Same runs as 3 | confirmed |
| 5 | Animations intro | Diagram over $[0,2]$ | `a, b = 0.0, 2.0`; `xlims=(0,2)`; frames | confirmed |
| 6 | Animations intro, Case 1 heading | $y=e^{-x}\sin(8x^{2/3})+1$ | `trapezoidalaa.jl:8`; plotted curve deviates from my own formula by 0.0 in all 24 frames; matches Mathews `gr_197` | confirmed |
| 7 | Animations intro | "Each new frame recomputes the approximation on the full interval with a denser partition" | 23 partitions, $n$ strictly increasing; panel count equals $n$ in every frame; panels span $[0,2]$ | confirmed |
| 8 | Animations intro | Source scripts "linked under each case" | `index.qmd:31` links `trapezoidalaa.jl`, which exists | confirmed |
| 9 | Case 1 | Case is the composite trapezoidal rule | Script sums $n$ equal-width trapezoids | confirmed |
| 10 | Behavior | Trapezoids "across the entire interval become narrower" | Width $2/n$, $n$ strictly increasing, uniform across $[0,2]$ | confirmed |
| 11 | Behavior | Converges toward the true integral | Error $-1.335\times10^{-3}$ at $n=120$, $-1.85\times10^{-10}$ at $n=1572864$ | confirmed |
| 12 | Behavior | $\int_0^2 f\,dx \approx 2.016280$ | $2.01627972$ by mpmath with $x=t^3$, by mpmath on direct panels, and by SciPy | confirmed |
| 13 | Behavior | Last frame has 121 sample points | Frame 24 label; `n=120` | confirmed |
| 14 | Behavior | Last frame gives 2.014944 | Script 2.0149444646; independent 2.014944; frame 24; Mathews `gr_220` | confirmed |
| 15 | Behavior | "about 0.0013 low" | $T_{120}-I=-0.001335$ | confirmed |
| 16 | Behavior | "The approach is not steady at first" | Errors: $+0.0016,+0.3566,-0.1172,-0.2142$ for $n=1,2,3,4$ | confirmed |
| 17 | Behavior | First partition frame has 2 sample points, 2.017925 | Frame 2 label; script 2.0179248; independent 2.017925 | confirmed |
| 18 | Behavior | Closeness is coincidence: areas above and below the chord "almost cancel" | Chord crossings at 0.2458, 0.6981, 1.2705. Area above chord 0.28027, below 0.28192, net $-0.001645=-(T_1-I)$ | confirmed |
| 19 | Behavior | With 2 subintervals the error is "about $+0.36$" | $T_2-I=+0.356647$ | confirmed |
| 20 | Behavior | "from 4 subintervals (5 sample points) on its size shrinks at every frame" | $\lvert E\rvert$ falls at each of the 19 steps from $n=4$ to $n=120$. It grew from $n=3$ to $n=4$ (0.1172 to 0.2142), so 4 is the correct start | confirmed |
| 21 | Behavior | $f'$ unbounded at 0, $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0 | Central difference at $x=10^{-6}$: 533.3318 against 533.3333 | confirmed |
| 22 | Behavior | Textbook order does not hold for this integrand | $E/h^2=-4.81,-12.20,-30.82,-77.72$ at $n=120,1920,30720,491520$, unbounded | confirmed |
| 23 | Behavior | Error shrinks like $O(h^{5/3})$ | $E/h^{5/3}=-1.2279,-1.2368,-1.2397,-1.2408$ at the same $n$, approaching $8\zeta(-2/3)=-1.24158$ | confirmed |
| 24 | Behavior | Halving $h$ divides the error by "about 3.14 (from 24 to 48 subintervals)" | $E_{24}/E_{48}=3.14152$ | confirmed |
| 25 | Behavior | "tending to $2^{5/3}\approx 3.17$, instead of 4" | Ratios 3.1583 (48 to 96), 3.1698 (384 to 768), 3.1745 (786432 to 1572864); $2^{5/3}=3.17480$ | confirmed |
| 26 | Alt text | Over $[0,2]$, full-interval refinement, "each frame uses a denser partition and updates the global approximation" | As 5 and 7. Frame 1 is the bare curve, before any partition | confirmed |
| 27 | Wiring | Link and embed are this case's script and GIF | `index.qmd:31,33`; scratch copy reproduces the GIF byte for byte (md5 `2118d48241e1b79dc20f5ed1f1d249e7`); linked from section index (`pages/numerical-methods/index.qmd:100`) | confirmed |

No entry was left at "could not determine".

### 3. Implementation checks: `trapezoidalaa.jl`

**It is the method it claims to be.** Lines 18-22 are the composite trapezoidal rule on a uniform grid. With $n=1$ the empty interior is handled and it reduces to the single-panel rule. Run unchanged on known integrals by extracting those lines into a scratch module (`review/routine.jl`):

- Exact on degree 0 and 1: errors $0$ on $1$ and at most $1.1\times10^{-15}$ on $3x-1$.
- Not exact on degree 2: on $x^2$ over $[0,2]$, $n=4$, error $0.08333333$, equal to the predicted $h^2/3$.
- Order 2 on $e^x$ (ratios in ledger entry 3).

**The numbers are right.** Script (instrumented copy `review/trapezoidalaa_instr.jl`) against independent NumPy sum (`review/indep.py`), with error against $I$:

| $n$ | Points | Script | Independent | $T_n-I$ |
|---:|---:|---:|---:|---:|
| 1 | 2 | 2.017925 | 2.017925 | +0.001645 |
| 2 | 3 | 2.372927 | 2.372927 | +0.356647 |
| 3 | 4 | 1.899071 | 1.899071 | -0.117209 |
| 4 | 5 | 1.802071 | 1.802071 | -0.214208 |
| 5 | 6 | 1.821893 | 1.821893 | -0.194387 |
| 6 | 7 | 1.855188 | 1.855188 | -0.161092 |
| 7 | 8 | 1.883982 | 1.883982 | -0.132297 |
| 8 | 9 | 1.906595 | 1.906595 | -0.109685 |
| 10 | 11 | 1.937765 | 1.937765 | -0.078515 |
| 12 | 13 | 1.957234 | 1.957234 | -0.059046 |
| 14 | 15 | 1.970106 | 1.970106 | -0.046174 |
| 16 | 17 | 1.979056 | 1.979056 | -0.037224 |
| 18 | 19 | 1.985540 | 1.985540 | -0.030740 |
| 20 | 21 | 1.990397 | 1.990397 | -0.025882 |
| 24 | 25 | 1.997086 | 1.997086 | -0.019194 |
| 28 | 29 | 2.001387 | 2.001387 | -0.014893 |
| 32 | 33 | 2.004331 | 2.004331 | -0.011949 |
| 40 | 41 | 2.008017 | 2.008017 | -0.008263 |
| 48 | 49 | 2.010170 | 2.010170 | -0.006110 |
| 56 | 57 | 2.011547 | 2.011547 | -0.004732 |
| 72 | 73 | 2.013161 | 2.013161 | -0.003119 |
| 96 | 97 | 2.014345 | 2.014345 | -0.001934 |
| 120 | 121 | 2.014944 | 2.014944 | -0.001335 |

**Reference value.** The script draws no reference; the page quotes 2.016280. Three computations agree: mpmath with $x=t^3$ (which removes the $x^{2/3}$ singularity) gives $2.0162797196170963$, mpmath on direct graded panels gives $2.0162797196171$, and SciPy on the substituted integrand gives $2.0162797196170965$ (estimated error $8\times10^{-14}$). The asymptotic constant in ledger entry 23 is a further check: the errors against this $I$ follow the theoretical $8\zeta(-2/3)h^{5/3}$ term.

**The picture shows what was computed.** `review/audit.jl` reads the series actually placed in each of the 24 plots:

- Polygon count equals $n$ in every frame.
- Every polygon's vertices are $(x_l,0),(x_r,0),(x_r,f(x_r)),(x_l,f(x_l))$, with max deviation $6.7\times10^{-16}$.
- The shoelace area of the drawn polygons equals the labelled $T_n$, with max difference $4.9\times10^{-15}$.
- The drawn curve equals $f$ exactly at all 800 points.
- The audit copy produces the same GIF (same md5) as the committed file.

All 24 frame labels were read from a montage (`review/labels.png`) and match the table. Frames 2, 4, 13 and 24 were viewed in full, with the contact sheet for the rest.

Display devices: no clamping or NaN masking. Limits $[0,2]\times[0,2.1]$ contain the whole curve (range 0.3572 to 1.9198), and the y-axis starts at 0, so shaded area is shown faithfully.

**Legacy fidelity.** Example 11 in Mathews is $f[x]=1+e^{-x}\sin[8x^{2/3}]$ on $[0,2]$ (`gr_197`, `gr_198`, `gr_199`), the page's function and interval. Every legacy value read (2.017925, 1.802071, 1.906595, 1.957234, 1.979056, 1.997086, 2.004331, 2.010570, 2.013011, 2.014472, 2.014944) matches my computation at the corresponding $n$.

