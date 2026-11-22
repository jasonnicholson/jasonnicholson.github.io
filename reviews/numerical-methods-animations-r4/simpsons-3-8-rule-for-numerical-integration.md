# Simpson's 3/8 Rule for Numerical Integration — animation review (round 4)

Page: `pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with my independent computation and with the frames, and I found no error in the implementation or the drawing.

These are observations that I do not count as findings, because they do not mislead:
- The frame annotation uses `round(approx; digits=6)` printed with Julia's shortest representation, so trailing zeros drop. Four frames show five decimals (`1.79047`, `2.01517`, `2.01572`, `2.01581`) and the rest show six. The values are correct (1.790470, 2.015170, 2.015720, 2.015810). The page's "2.01581" and "2.015810" are both consistent with this. If the owner wants a uniform display, the fix is `@sprintf("%.6f", approx)` at `simpson38aa.jl:65`, but this is cosmetic.
- The Animations intro says "Each frame recomputes the approximation…". Frame 1 shows only $f$ and has no approximation. The alt text discloses this ("after an opening frame showing only f"), and the legacy GIF opens the same way.
- The Description says the method "can be viewed as a higher-order refinement of trapezoidal geometry using piecewise cubic panels". This is loose phrasing, not a checkable claim, and it is not false.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson38aa.jl` | 0 | 12.4 | simpson38aa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpson38aa.gif` | 24 | byte-identical | simpson38aa |

### Page references

- Scripts linked: `simpson38aa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | "applies cubic interpolation on blocks of three subintervals" | Script lines 40–55 fit a cubic through the 4 nodes of each block of 3 subintervals; the area of each plotted cubic equals that block's 3/8 contribution (`instr.jl`: cubicArea−approx ≤ 2.7e-15 for every n) | confirmed |
| D2 | Description | $h=(b-a)/n$, $n$ divisible by 3 | Script line 26 `dx=(b-a)/n`; all n_seq entries are multiples of 3 | confirmed |
| D3 | Description | Formula $\frac{3h}{8}[f_0+f_n+3\sum_{i\not\equiv0}f_i+2\sum_{i\equiv0,0<i<n}f_i]$ | Script lines 27–29 implement exactly this. The weights are equivalent to summing per panel $\frac{3h}{8}(f_0+3f_1+3f_2+f_3)$ (my `indep.py` form), and the two agree to ≥ 9 digits for all 23 n | confirmed |
| D4 | Description | For smooth $f$ ($C^4$) the global error is $O(h^4)$ | Script routine on $e^x\cos 3x$ over [0,2]: error ratios 16.79, 16.19, 16.05, 16.01 for n=12→24→48→96→192. The routine is exact for $x^0..x^3$ (errors ≤ 4.4e-16) and not for $x^4$ (err 0.11852 at n=3, which equals $\tfrac{3}{80}h^5 f^{(4)}$ with h=2/3, f⁽⁴⁾=24) | confirmed |
| A1 | Animations intro | Interval $[0,2]$, $y=e^{-x}\sin(8x^{2/3})+1$ | Script lines 8–9 | confirmed |
| A2 | Animations intro | "Each frame recomputes the approximation across the full interval with a denser partition where n remains a multiple of 3" | n_seq = 3,6,…,120, strictly increasing, all multiples of 3; each frame calls `simpson38_sum(n)` on [0,2]. The exception is frame 1, which shows only f (disclosed in the alt text) | confirmed |
| A3 | Animations intro | "Red dots mark the sample points $x_i$" | Lines 72–73: scatter of $x_i=a+i\,dx$, i=0..n, red; frames show n+1 dots | confirmed |
| A4 | Animations intro | "vertical red lines mark the panel boundaries $x_{3k}$" | Lines 58–61: lines at i=0:3:n from 0 to f(x_i). In the frames, n=6 shows lines at x=0,1,2 and n=12 at 0,0.5,1,1.5,2 | confirmed |
| A5 | Case 1 heading | Composite Simpson's 3/8, same f, [0,2] | Script | confirmed |
| B1 | Behavior | "Piecewise cubic panels over triplets of subintervals are rebuilt at increasing density" | Lines 40–55, frames 2–24 | confirmed |
| B2 | Behavior | True $\int_0^2 f\,dx \approx 2.016280$ | mpmath quad split at 1e-6, 0.01, …: 2.0162797196170963279. Substitution x=t³ (smooth integrand) gives the same value to 20 digits. Rounds to 2.016280 | confirmed |
| B3 | Behavior | "Every approximation shown lies below the true integral" | All 23 errors are negative, from −0.2258 (n=6) to −0.000469 (n=120) | confirmed |
| B4 | Behavior | "The error grows from 4 to 7 sample points, then shrinks at every later frame" | \|err\|: 0.132066 (4 pts), 0.225809 (7), then 0.0890457, 0.0396505, … 0.000469309, strictly decreasing over all 21 later frames | confirmed |
| B5 | Behavior | Last frame "(121 sample points) gives 2.01581, about 0.00047 low" | n=120: 2.015810411 (script and mpmath agree); error −0.000469309 | confirmed |
| B6 | Behavior | $f'$ unbounded at 0, $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0 | $f'=-e^{-x}\sin(8x^{2/3})+e^{-x}\cos(8x^{2/3})\cdot\tfrac{16}{3}x^{-1/3}$, whose leading term as x→0 is $\tfrac{16}{3}x^{-1/3}$ | confirmed |
| B7 | Behavior | Textbook order does not hold; error shrinks like $O(h^{5/3})$ | Ratios err(n)/err(2n): 3.2238 (60), 3.1890 (120), 3.1801, 3.1772, 3.1759, 3.1754, 3.1751 (3840). $2^{5/3}=3.17480$. This matches the endpoint singularity $x^{2/3}$, which gives $O(h^{1+2/3})$ | confirmed |
| B8 | Behavior | Halving h "divides it by about 3.22 (from 60 to 120 subintervals), tending to $2^{5/3}\approx3.17$, instead of 16" | 3.2238; the limit is as above | confirmed |
| L1 | Link | `[Julia source](simpson38aa.jl)` is the script for this case | File exists and is the only script; it generates `simpson38aa.gif` | confirmed |
| L2 | Embed | `simpson38aa.gif` is this case's GIF | The manifest shows regeneration is byte-identical to the committed GIF | confirmed |
| L3 | Alt text | Opening frame shows only f; then sample points as red dots, panel boundaries as vertical red lines, piecewise cubic panels, the global approximation | Frame 1: magenta f only. Frames 2–24: pink cubic panels, red boundary lines, red dots, "Approximation = …" label | confirmed |
| G1 | Legacy note | Reconstructs Mathews' `Simpsonaa.gif`, with the same integrand and interval | The legacy frames are labelled `y = e^{-x} sin(8 x^{2/3}) + 1` and the x-axis runs 0–2 | confirmed |
| G2 | Legacy note | Ends at the same 121-point approximation, 2.015810 | The last legacy frame reads "Sample Points = 121, Approximation = 2.015810"; mine is 2.015810411 | confirmed |
| G3 | Legacy note | Steps through a different sequence of intermediate n | Legacy n: 3,3,6,9,12,15,18,24,30,36,42,48,54,60,66,72,78,84,90,105,120 (after 3 blank frames). Page n: 3,…,36 by 3, then 42,48,54,60,66,72,81,90,99,108,120. Every legacy approximation value I could read (e.g. 1.884214, 1.790470, 1.927234, 1.976629, 1.994094, 2.001834, 2.008397, 2.011141, 2.012595, 2.013477, 2.014059, 2.014468, 2.014767, 2.014994, 2.015170, 2.015311, 2.015425, 2.015519, 2.015692, 2.015810) agrees with my 3/8 sums at the corresponding n | confirmed |

Frame labels vs independent values: `committed_labels.png` shows all 23 labelled frames. Sample points 4,7,10,…,121 and approximations 1.884214, 1.79047, 1.927234, 1.976629, 1.994094, 2.001834, 2.005934, 2.008397, 2.010012, 2.011141, 2.011968, 2.012595, 2.013477, 2.014059, 2.014468, 2.014767, 2.014994, 2.01517, 2.015371, 2.015519, 2.015631, 2.01572, 2.01581 each match `indep.py` rounded to 6 decimals.

Fidelity: the page keeps the legacy integrand, the interval, the visual vocabulary (pink cubic panels, red boundary lines, red dots, magenta f) and the endpoint. The only departure is the intermediate n sequence, and the page discloses it. The legacy module's worked examples correspond to the page's "(Planned)" placeholder sections, which are out of scope. No fidelity finding.

### 3. Implementation checks: `simpson38aa.jl`

**It is the method it claims to be.** `simpson38_sum` (lines 25–30) is the composite Simpson's 3/8 rule with weights 1,3,3,2,3,3,2,…,3,3,1 times 3h/8. The plotted panels (lines 40–55) are the cubic interpolants through each block's four nodes, and their exact areas, computed from the plotted coefficients, equal the rule's sum to ≤ 2.7e-15 at every n. The drawing and the number therefore describe the same object. This is the standard method, not a variant.

**The numbers are right.**
- Degree of precision: the script's own routine applied to $x^p$ on [0,2] is exact for p=0..3 (|err| ≤ 4.4e-16 at n=3 and n=6). It is not exact for p=4 (0.118519 at n=3, 0.0074074 at n=6, a ratio of 16) or for p=5. This is the expected degree 3.
- Order on a smooth function: on $e^x\cos3x$ the error ratios are 16.79, 16.19, 16.05, 16.01.
- On the page's integrand the script's values agree with my independent panel-by-panel mpmath sum at every n. The two are shown side by side below. The script's values are the full-precision output of `instr.jl`; the independent column is from `indep.py`.

| n | pts | script `simpson38_sum` | independent (mpmath) | error vs I |
|---|---|---|---|---|
| 3 | 4 | 1.8842140994188474 | 1.884214099 | −0.132066 |
| 6 | 7 | 1.790470481304736 | 1.790470481 | −0.225809 |
| 9 | 10 | 1.9272339711446245 | 1.927233971 | −0.0890457 |
| 12 | 13 | 1.976629196190375 | 1.976629196 | −0.0396505 |
| 15 | 16 | 1.9940944247919974 | 1.994094425 | −0.0221853 |
| 18 | 19 | 2.001833808071699 | 2.001833808 | −0.0144459 |
| 21 | 22 | 2.005934192958429 | 2.005934193 | −0.0103455 |
| 24 | 25 | 2.008397041546531 | 2.008397042 | −0.00788268 |
| 27 | 28 | 2.0100124027891093 | 2.010012403 | −0.00626732 |
| 30 | 31 | 2.0111411216067023 | 2.011141122 | −0.0051386 |
| 33 | 34 | 2.0119677265662554 | 2.011967727 | −0.00431199 |
| 36 | 37 | 2.0125952389214476 | 2.012595239 | −0.00368448 |
| 42 | 43 | 2.0134768107053778 | 2.013476811 | −0.00280291 |
| 48 | 49 | 2.014059184718606 | 2.014059185 | −0.00222053 |
| 54 | 55 | 2.0144675377251207 | 2.014467538 | −0.00181218 |
| 60 | 61 | 2.0147667415686947 | 2.014766742 | −0.00151298 |
| 66 | 67 | 2.0149935291633914 | 2.014993529 | −0.00128619 |
| 72 | 73 | 2.015170132082283 | 2.015170132 | −0.00110959 |
| 81 | 82 | 2.0153705880411943 | 2.015370588 | −0.000909132 |
| 90 | 91 | 2.015518613868462 | 2.015518614 | −0.000761106 |
| 99 | 100 | 2.0156314275265914 | 2.015631428 | −0.000648292 |
| 108 | 109 | 2.0157196260763444 | 2.015719626 | −0.000560094 |
| 120 | 121 | 2.015810410863725 | 2.015810411 | −0.000469309 |

**Reference values are right.** The script draws no reference value. The page's reference integral 2.016280 is confirmed by two independent mpmath evaluations: a direct integral split near the singular endpoint, and the substitution x=t³, which makes the integrand smooth. Both give 2.0162797196170963279.

**The picture shows what was computed.**
- Cubic panels: the monomial-Vandermonde coefficients (lines 18–23) reproduce the data at the nodes to ≤ 1.3e-14. They agree with an independent Lagrange evaluation on the 90-point plot grid to ≤ 2.0e-14 for every n, so the ill-conditioning of the monomial basis has no visible effect.
- Boundary lines: drawn at $x_{3k}$ from 0 to $f(x_{3k})$.
- Dots: at all $x_i$, on top of the curve.
- Magenta curve: f on [0,2] (line 68). The function in the code is the function in the page text.
- Labels: "Sample Points = n+1" and "Approximation = round(S,6)" match the independent values (above).
- Axis limits: x ∈ [−0.03, 2.03] and y ∈ [0, 2.1] contain the whole curve (max f ≈ 1.92) and every cubic (the lowest fill reaches about 0.2 at n=12 near x≈0.45; nothing goes below 0). There is no clamping or masking.
- Frames: 24, consisting of 1 opening frame and 23 values of n.
- Frames inspected directly: 1, 2, 24 and the contact sheet (frames 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23), plus the label crop of all 24.

