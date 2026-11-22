# Trapezoidal Rule for Numerical Integration — animation review (round 2)

Page: `pages/numerical-methods/trapezoidal-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Page match — Minor — Behavior paragraph implies steady improvement; frame 2 is almost as accurate as the last frame

- **Location:** `index.qmd` line 29: "As the number of sample points increases, trapezoids across the entire interval become narrower, and the approximation converges toward the true integral $\int_0^2 f(x)\,dx \approx 2.016280$; the last frame (121 sample points) gives 2.014944, about 0.0013 low."
- **What is there now:** The sentence is true asymptotically, but the frames are not a steady approach. The first non-empty frame (2 sample points, one trapezoid) shows `Approximation = 2.017925`, error +0.00165, which is essentially as close as the final frame (error -0.00134). The next frame (3 points) jumps to 2.372927 (error +0.357), and the errors then shrink monotonically only from 5 sample points on. A viewer comparing the first shown value with the last, against the page's "about 0.0013 low", can easily conclude that refining from 1 to 120 subintervals bought almost nothing, or be puzzled by the 2-point frame, with nothing on the page explaining it.
- **What is true:** T_1 = 2.017925 is a coincidental near-cancellation (the one chord from f(0)=1 to f(2)=1.0177 happens to enclose nearly the right area). Errors by n: 1: +0.00165, 2: +0.357, 3: -0.117, 4: -0.214, 5: -0.194, 6: -0.161, ... 120: -0.00134 (monotone decreasing in magnitude from n=4).
- **Evidence:** `/usr/bin/python3 -I review/indep.py` (mpmath, 30 digits; table in section 3) and `julia review/instr.jl` (script's own `trapezoid_sum`), both giving the values above; frame_002.png shows "Sample Points = 2 / Approximation = 2.017925".
- **Suggested correction:** Add one sentence to the Behavior paragraph, e.g. "The single-trapezoid value in the first frame (2.017925) is close to the integral only by coincidence: the chord from $f(0)$ to $f(2)$ happens to balance the area above and below it; with 2 subintervals the error jumps to 0.36, and from 4 subintervals on it decreases steadily."

No other findings.

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `trapezoidalaa.jl` | 0 | 6.3 | trapezoidalaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Location | Verdict | Evidence |
|---|---|---|---|---|
| 1 | Composite trapezoidal rule replaces f on each subinterval with a line segment between neighbouring nodes | Description l.12-13 | Confirmed | Script lines 32-41 draw/compute linear segments between nodes a+i·dx |
| 2 | $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1} f(x_i)+\tfrac12 f(x_n)]$, $h=(b-a)/n$ | l.15 | Confirmed | Matches `trapezoid_sum` (l.18-22) exactly; formula itself confirmed by exactness checks (sec. 3) |
| 3 | For $f\in C^2[a,b]$, $T_n - I = O(h^2)$ | l.18 | Confirmed | Standard result; numerically, for $x^2$ on [0,2] error = $(b-a)h^2 f''/12$ exactly at n=1,3,7 (1.3333, 0.148148, 0.027211) |
| 4 | Diagram over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | l.22-23 | Confirmed | Script l.8-9; xlims (0,2); curve in frames matches (f(0)=1, max 1.9198 at x≈0.080, min 0.3572 at x≈0.432, f(2)=1.0177) |
| 5 | "Each new frame recomputes the approximation on the full interval with a denser partition" | l.23 | Confirmed | n sequence 1,2,3,4,5,6,7,8,10,...,96,120 strictly increasing, uniform partition of [0,2]; frame 1 is the curve only (n=0), each later frame a full-interval partition |
| 6 | Julia source linked under each case | l.25, l.31 | Confirmed | `[Julia source](trapezoidalaa.jl)` resolves to the script that produces the embedded GIF (manifest: byte-identical regeneration) |
| 7 | Case 1 heading: Composite Trapezoidal Rule, f on [0,2] | l.27 | Confirmed | Script l.8-9, l.18-22 |
| 8 | Trapezoids across the entire interval become narrower as sample points increase | l.29 | Confirmed | dx=(b-a)/n uniform, n increasing; visible in frames 2-24 |
| 9 | Approximation converges toward the true integral | l.29 | Confirmed (asymptotically); see F1 for non-monotone early frames | Errors in sec. 3 |
| 10 | True integral $\approx 2.016280$ | l.29 | Confirmed | mpmath with substitution x=t³: 2.0162797196170963; plain adaptive quad with breakpoints agrees to 30 digits |
| 11 | Last frame has 121 sample points | l.29 | Confirmed | n=120 → label "Sample Points = 121" (frame_024.png); 121 nodes is correct for 120 subintervals |
| 12 | Last frame gives 2.014944 | l.29 | Confirmed | Script: 2.0149444646; independent: 2.014944465; frame_024 label "Approximation = 2.014944" |
| 13 | About 0.0013 low | l.29 | Confirmed | 2.0149444646 − 2.0162797196 = −0.0013353 |
| 14 | $x^{2/3}$ term makes $f'$ unbounded at $x=0$ | l.29 | Confirmed | $f'(x) = -e^{-x}\sin(8x^{2/3}) + e^{-x}\cos(8x^{2/3})\cdot\tfrac{16}{3}x^{-1/3}$ |
| 15 | $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0 | l.29 | Confirmed | mpmath: f'(1e-9)=5333.3333198 vs (16/3)(1e-9)^{-1/3}=5333.3333333 |
| 16 | Textbook error order (smooth f) does not hold | l.29 | Confirmed | Halving ratios 3.08–3.17, not 4 |
| 17 | Error shrinks like $O(h^{5/3})$ | l.29 | Confirmed | Ratios e(n)/e(2n): 3.0763 (12), 3.1415 (24), 3.1583 (48), 3.1647 (96), 3.1679 (192), 3.1698 (384), 3.1711 (768), 3.1720 (1536), 3.1726 (3072) → 2^{5/3}=3.17480; consistent with the generalized Euler–Maclaurin (Navot) term $h^{1+\beta}$ for the leading $x^{2/3}$ singular term ($f = 1 + 8x^{2/3} - 8x^{5/3}+\dots$) |
| 18 | Halving h divides error by about 3.14 from 24 to 48 subintervals | l.29 | Confirmed | 0.0191940 / 0.00610979 = 3.14152 |
| 19 | Ratio tends to $2^{5/3}\approx 3.17$ | l.29 | Confirmed | 2^{5/3}=3.1748; sequence in #17 approaches it |
| 20 | Alt text: trapezoidal rule over [0,2], full-interval density refinement, each frame a denser partition, updates the global approximation | l.33 | Confirmed | As #5; approximation label updated every partition frame |
| 21 | Embed points at trapezoidalaa.gif, which is Case 1 | l.33 | Confirmed | Manifest: committed GIF = output of `trapezoidalaa.jl` |
| 22 | Frame labels "Sample Points = n+1" and "Approximation = ..." (prominent frame content) | GIF | Confirmed | All 23 values in sec. 3 match independent computation to the 6 decimals shown (frames 2,3,5,7,9,13,17,21,29,41,57,97,121 points inspected in the contact sheet; frame 2 and 24 individually) |
| 23 | Frame title "Trapezoidal Rule / Numerical Quadrature" | GIF | Confirmed | Matches method |

Placeholder sections (Derivation Notes, Worked Example, Implementation Notes — all "Planned") and the source-attribution line were excluded per the standard.

### 3. Implementation checks: `trapezoidalaa.jl`

**Method is what it claims.** `trapezoid_sum(n)` (l.18-22) computes `dx*(0.5 f(a) + Σ_{i=1}^{n-1} f(a+i dx) + 0.5 f(b))`, the composite trapezoidal rule on n uniform subintervals; n=1 correctly reduces to the simple rule (`interior=0`). Not a neighbouring method (no midpoint or Simpson weighting).

**Numbers are right.** Property checks (run on the script's own formula structure in `review/instr.jl`): integrates `3x+1` on [0,2] exactly for n=1,3,7 (errors 0, 0, -1.8e-15); does not integrate `x^2` exactly, with error = $(b-a)h^2 f''/12$ to machine precision (1.33333, 0.148148, 0.0272109) — degree of precision 1, as expected.
Script values (instrumented, `julia review/instr.jl`) beside the independent mpmath computation (`/usr/bin/python3 -I review/indep.py`, 30 digits):

| n | points | script T_n | independent T_n | error T_n − I |
|---|---|---|---|---|
| 1 | 2 | 2.017924816 | 2.017924816 | +0.0016451 |
| 2 | 3 | 2.372926967 | 2.372926967 | +0.356647 |
| 3 | 4 | 1.899070846 | 1.899070846 | −0.117209 |
| 4 | 5 | 1.802071488 | 1.802071488 | −0.214208 |
| 5 | 6 | 1.821892903 | 1.821892903 | −0.194387 |
| 6 | 7 | 1.855187869 | 1.855187869 | −0.161092 |
| 7 | 8 | 1.883982369 | 1.883982369 | −0.132297 |
| 8 | 9 | 1.906594930 | 1.906594930 | −0.109685 |
| 10 | 11 | 1.937764605 | 1.937764605 | −0.0785151 |
| 12 | 13 | 1.957233895 | 1.957233895 | −0.0590458 |
| 14 | 15 | 1.970106197 | 1.970106197 | −0.0461735 |
| 16 | 17 | 1.979055857 | 1.979055857 | −0.0372239 |
| 18 | 19 | 1.985539815 | 1.985539815 | −0.0307399 |
| 20 | 21 | 1.990397455 | 1.990397455 | −0.0258823 |
| 24 | 25 | 1.997085696 | 1.997085696 | −0.0191940 |
| 28 | 29 | 2.001386744 | 2.001386744 | −0.0148930 |
| 32 | 33 | 2.004331112 | 2.004331112 | −0.0119486 |
| 40 | 41 | 2.008016895 | 2.008016895 | −0.00826282 |
| 48 | 49 | 2.010169926 | 2.010169926 | −0.00610979 |
| 56 | 57 | 2.011547448 | 2.011547448 | −0.00473227 |
| 72 | 73 | 2.013160750 | 2.013160750 | −0.00311897 |
| 96 | 97 | 2.014345221 | 2.014345221 | −0.00193450 |
| 120 | 121 | 2.014944465 | 2.014944465 | −0.00133525 |

(The on-frame label uses `round(...; digits=6)`, so trailing zeros drop, e.g. "2.01017" for n=48 and "1.98554" for n=18; this is display only.)

**Reference values.** The script draws no reference value. The page's reference I ≈ 2.016280 was verified independently: mpmath `quad` after the substitution x=t³ (removes the x^{2/3} singularity; integrand becomes smooth) gives 2.01627971961709632788727442192, and a direct `quad` on breakpoints [0,0.001,0.1,0.5,1,2] agrees to all 30 digits. The page's rate claims were verified by extending the independent computation to n=3072 (ratios in ledger #17).

**Picture shows what was computed.** Each trapezoid (l.38-41) is the polygon (xl,0),(xr,0),(xr,f(xr)),(xl,f(xl)) with the top chord between the endpoint function values — the correct geometric element for the rule, with heights at the nodes. Spot checks against frames: n=1 chord from 1.000 to 1.0177 (frame_002); n=2 node at x=1 at f(1)=1.3643 (frame 3); n=4 node at x=0.5 at f(0.5)=0.426 (frame 5) — all match the drawn vertices. The label "Sample Points = n+1" correctly counts nodes; "Approximation" is `trapezoid_sum(n)` of the same n that is drawn. The magenta curve uses 800 points and is the same `f`. Axis limits x∈[0,2], y∈[0,2.1] contain the whole graph (f range 0.357–1.920); no clamping or masking. Annotations at (1.15, 1.88/1.74) never overlap the curve (f<1.4 for x>0.5). 24 frames = 1 curve-only frame + 23 partitions, at 2 fps. Committed GIF is byte-identical to a fresh scratch run (manifest).

### Legacy archive (fidelity)

- `TrapezoidalRuleMod.html` lists one animation (a2001 `Quadrature/Trapezoidal/Trapezoidalaa.gif`) and two worked examples (m=1,2,4,8,16 and m=50..800); the worked examples correspond to the page's "Worked Example (Planned)" placeholder and are excluded.
- The legacy animation uses the same function $e^{-x}\sin(8x^{2/3})+1$ on [0,2], the same "Sample Points / Approximation" labels, a full-interval uniform refinement, and ends at 121 sample points with 2.014944 — the same as the page. Its intermediate values visible in the contact sheet (2.017925 at 2 points, 1.802071 at 5, 1.906595 at 9, 1.957234 at 13, 1.979056 at 17, 1.997086 at 25, 2.004331 at 33) equal the independent values above. The legacy schedule differs slightly (it includes 51, 71, 101 points and has two title-only frames; the page's version includes 3, 7, 21, 29, 41, 49, 57, 73, 97), which does not matter to a reader. The legacy plot prints the function formula inside the frame and marks nodes with dots; the new frames do not, but the page text names the function, so this is not a finding.
- No fidelity findings.

