# Chebyshev Approximation Polynomial — animation review (round 6)

Page: `pages/numerical-methods/chebyshev-approximation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. The approximation interval is not marked in the frames, so extrapolation blow-up just past the interval looks like a failure of the method (page match / fidelity; Minor)

- **Location:** `chebyshev_animations_all.jl` lines 245–254 (the plot contains only `f(x)`, the interpolant and the nodes), together with every case whose plotting window is wider than its approximation interval (01–07, 09–11, 14, 19, 24–29).
- **What is there now:** Each frame plots the interpolant across the whole plotting window `xlims`. The approximation interval appears only as numbers in the title. Nothing in the picture shows where the interval ends and extrapolation begins. Just past the right end of the interval the polynomial leaves the window almost immediately, while $f$ continues smoothly beside it:
  - case 04, n = 16, interval [0, 2]: P(2.10) = 1.516 against f = 1.450; P(2.21) = 2.695 against f = 1.486; P(2.50) = 213.5 against f = 1.582.
  - case 24, n = 16, interval [0.05, 2]: P(2.10) = −3.15 against f = 1.048; P(2.20) = −64.9 against f = 1.102.
  - case 29, n = 16, interval [0.5, 4]: P(5.02) = 1.03 against f = −0.312.

  The Description presents Chebyshev nodes as "a standard remedy for Runge-type endpoint blow-up". The frames of 04, 05, 09, 11, 24, 25, 28 and 29 show a curve blowing up right next to the outermost node, and the reader has to work out from the title alone that this happens outside the interval.
- **What is true instead:** Inside the approximation interval the interpolant converges in every case (largest error at n = 16 is 0.65, in case 25, and it shrinks with n; see section 3). The blow-up is purely extrapolation.
- **Fidelity:** The Mathews animations draw the interval endpoints as vertical green lines. This is visible in the extracted legacy frames `review/legacy/Chebyshevbb/sheet.png` (case 02, lines at about −0.9 and 1.5), `Chebyshevcc` (case 03, line at 0.8), `Chebyshevll` (case 12, ±3π), `Chebyshevoo` (case 15, −2 and 3) and `Chebyshevxx` (case 24, 0.05 and 2). The port dropped these lines.
- **How I know:** `review/instrument.jl` dumps the script's own interpolant on its 1000-point plotting grid. Values above are read from `review/dump/c04_n16.tsv`, `c24_n16.tsv` and `c29_n16.tsv`, and the frames are in `committed/cheby04`, `cheby24` and `cheby29`.
- **Suggested correction:** Draw the interval endpoints in every frame, for example `vline!(pplot, collect(span); color=:green, ls=:dash, label="interval")`, as the legacy animations did. Alternatively, or as well, add one sentence to the Animations introduction saying that the curve outside the stated interval is extrapolation and is expected to diverge.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `chebyshev_animations_all.jl` | 0 | 43.4 | 29 GIFs (cheby01.gif … cheby29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `cheby01.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby02.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby03.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby04.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby05.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby06.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby07.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby08.gif` | 14 | byte-identical | chebyshev_animations_all |
| `cheby09.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby10.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby11.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby12.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby13.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby14.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby15.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby16.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby17.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby18.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby19.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby20.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby21.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby22.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby23.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby24.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby25.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby26.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby27.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby28.gif` | 10 | byte-identical | chebyshev_animations_all |
| `cheby29.gif` | 10 | byte-identical | chebyshev_animations_all |

### Page references

- Scripts linked: `chebyshev_animations_all.jl`
- GIFs embedded: 29
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| D1 | Page title "Chebyshev Approximation Polynomial" for what the page calls Chebyshev-node interpolation | Confirmed | Mathews' Chebyshev approximation polynomial is $P(x)=\sum_{j=0}^{n-1} c_j T_j(t)$ with $c_j=\frac{2}{n}\sum_k f(x_k)\cos(j\theta_k)$ ($c_0$ halved). Built independently in `review/indep.py`, it equals the script's barycentric interpolant to a relative 3.7e-14 inside the interval and 2.6e-10 outside, over all 29 cases × all n × 1000 grid points. The n2003 module also defines it as interpolation at the roots of $T_n$. |
| D2 | "uses clustered nodes near interval endpoints" | Confirmed | Cosine nodes, code line 97. Frames show the clustering, for example `cheby08/frame_014.png`. |
| D3 | "to reduce oscillation compared with equally spaced interpolation at the same degree" | Confirmed as a general statement | On case 08's Runge-type $f$ on [-1,1], max error equispaced vs Chebyshev is: n=10, 0.173 vs 0.089; n=16, 0.485 vs 0.0138; n=32, 14.0 vs 9.5e-5. At n=6 equispaced is slightly smaller (0.203 vs 0.302), which the general statement does not exclude. Source: `review/extra.out`. |
| D4 | "standard remedy for Runge-type endpoint blow-up" | Confirmed | Same numbers as D3. |
| D5 | $x_k=\frac{a+b}{2}+\frac{b-a}{2}\cos\frac{(2k-1)\pi}{2n}$, $k=1..n$ | Confirmed | Identical to code line 97. My independently computed nodes match the script's nodes to 3.6e-15 for every case and n. |

### Animations introduction and wiring

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | "steps through 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 Chebyshev nodes" | Confirmed | `node_count_sequence(15)` returns exactly this list (`review/dump_summary.tsv`). Every GIF other than 08 has 10 frames (manifest), and the titles show the n per frame (checked n=2, 8, 16 in frames 1, 6 and 10). |
| A2 | "(case 08 continues to 20, 24, 28 and 32)" | Confirmed | `node_count_sequence(31)` returns […, 16, 20, 24, 28, 32]. cheby08 has 14 frames, and its last title reads n = 32. |
| A3 | "for a fixed function and approximation interval" | Confirmed | The span is constant per case. The node-trimming fallback (code lines 89–104) is never triggered: the attempt index is 0 for every case and every n (`dump_summary.tsv`, column `attempts`). |
| A4 | "With n nodes the interpolant has degree at most n−1" | Confirmed | Each n distinct nodes give a unique interpolant of degree ≤ n−1. The GIF titles say "degree ≤ n−1". |
| A5 | "for an even function on a symmetric interval and even n it is at most n−2" | Confirmed | For the even cases 08, 13, 17, 20 and 22 at every even n, the computed $c_{n-1}$ is at round-off level (largest 3.2e-14, cosh case with values near 27). Examples: the n=2 frames of 13, 17, 20 and 22 show a constant line. |
| A6 | "[Julia source for all cases](chebyshev_animations_all.jl)" | Confirmed | The file exists, is the only script, and writes `cheby$(id).gif` for ids 01–29 (line 259). |
| A7 | 29 embeds `cheby01.gif` … `cheby29.gif` under headings Case 01 … Case 29 | Confirmed | Each embed's file is the one written for that case id, and each GIF's title shows the same case number (`review/titles_last_1_15.png`, `titles_last_16_29.png`). |

### Per-case captions (function, interval) against the script row and the GIF title

In every row the caption, the script row (line 28–56) and the GIF title agree. "Window" is the script's plotting `xlims`, which is not stated on the page; it is listed because I checked it against the archive. Every row's verdict is **Confirmed**.

| Case | Caption | Script function / node interval | GIF title | Window | Archive (function, window, interval) |
|---|---|---|---|---|---|
| 01 | 1/(1-x), [-1.6, 0.9] | `1/(1-x)`, (-1.6, 0.9) | same | (-1.6, 1.5) | f and window match. The archive does not state the node interval and has no legacy GIF, so the interval could not be checked. |
| 02 | 1/(1+x), [-0.9, 1.5] | same | same | (-1.5, 1.6) | match; legacy GIF interval lines ≈ −0.9, 1.5 |
| 03 | 1/(1-x)^2, [-1.5, 0.8] | same | same | (-1.6, 1.5) | match; legacy GIF interval line at 0.8 |
| 04 | sqrt(x), [0, 2] | same | same | (0, 10.5) | match ("[0, 2]" listed) |
| 05 | sqrt(x), [0, 8] | same | same | (0, 10.5) | match |
| 06 | sqrt(x), [0, 10] | same | same | (0, 10.5) | match |
| 07 | 1/sqrt(1-x), [-1.5, 0.95] | same | same | (-1.6, 1.5) | f and window match. The archive does not state the node interval and has no legacy GIF, so the interval could not be checked. |
| 08 | 1/(1+10x^2), [-1, 1], up to 32 nodes | same, max_order 31 | same, n up to 32 | (-1.5, 1.5) | match ("[-1, 1]") |
| 09 | log(x), [0.02, 2] | same | same | (-0.5, 4.1) | match |
| 10 | log(x), [0.02, 4] | same | same | (-0.5, 4.1) | match |
| 11 | log(1+x), [-0.98, 1] | same | same | (-1.5, 1.5) | match |
| 12 | sin(x), [-3pi, 3pi] | `sin`, auto span = window = ±3π | [-9.425, 9.425] (= ±3π) | ±3π | match; legacy GIF interval lines at ±3π |
| 13 | cos(x), [-3pi, 3pi] | `cos`, auto span ±3π | [-9.425, 9.425] | ±3π | match |
| 14 | tan(x), approximation interval [-1.45, 1.45] inside singularities | same, poles ±π/2 | same | (-π, π) | f and window match. ±1.45 lies inside ±π/2 = ±1.5708. The archive does not state the node interval. |
| 15 | exp(x), [-2, 3] | auto span | same | (-2, 3) | match; legacy GIF interval lines at −2, 3 |
| 16 | cos(x)*exp(-x), [-2, 4] | auto span | same | (-2, 4) | match |
| 17 | cosh(x), [-4, 4] | auto span | same | (-4, 4) | match |
| 18 | atan(x), [-2.2, 2.2] | auto span | same | (-2.2, 2.2) | match |
| 19 | asin(x), [-1, 1] | same | same | (-1.5, 1.5) | f and window match. [-1, 1] is asin's whole domain; the archive does not state it. |
| 20 | besselj(0,x), [-10.2, 10.2] | auto span | same | ±10.2 | match |
| 21 | besselj(1,x), [-10.2, 10.2] | auto span | same | ±10.2 | match |
| 22 | normal_pdf(x), [-3, 3] | exp(-x²/2)/√(2π) | same | (-3, 3) | match; formula equals the archive's $\frac{1}{\sqrt{2\pi}}e^{-x^2/2}$ |
| 23 | normal_cdf(x), [-3, 3] | ½+½ erf(x/√2) | same | (-3, 3) | match; formula equals the archive's |
| 24 | gamma(x), [0.05, 2] | same | same | (-0.2, 5.2) | match; legacy GIF interval lines at 0.05, 2 |
| 25 | gamma(x), [0.05, 4] | same | same | (-0.2, 5.2) | match |
| 26 | gamma(x), [0.5, 5] | same | same | (-0.2, 5.2) | match |
| 27 | bessely(0,x), [0.5, 20] | same | same | (0, 22) | match |
| 28 | bessely(0,x), [0.5, 10] | same | same | (0, 22) | match |
| 29 | bessely(0,x), [0.5, 4] | same | same | (0, 22) | match |

The page makes no per-case behaviour claims, such as a convergence rate or a final error, so none needed checking.

---

### 3. Implementation checks: `chebyshev_animations_all.jl`

**It is the method it claims to be.** Yes. The script interpolates $f$ at the n first-kind Chebyshev nodes mapped to [a,b], which are the roots of $T_n$, and evaluates the interpolant with the barycentric formula. Inside the node range it uses the second (true) form with weights $w_j = 1/\prod_{k\ne j}(x_j-x_k)$. Outside the node range it uses the first form $\ell(x)\sum_j w_j y_j/(x-x_j)$. This is the same polynomial as Mathews' Chebyshev approximation polynomial $\sum c_j T_j$ with coefficients from discrete orthogonality; it is only a different evaluation route, and I verified the equivalence numerically below. The weights are computed by explicit products, not the closed form for Chebyshev nodes. That is valid, and at n ≤ 32 it neither overflows nor loses accuracy (see the agreement figures).

**The numbers are right.**

- `review/instrument.jl` includes the script's own functions (lines 1–200, with the Plots calls removed) and dumps, for every case and every n, the nodes, the node values, and the interpolant and f on the 1000-point plotting grid (`review/dump/`).
- `review/indep.py` (scipy/numpy) independently recomputes:
  - **Nodes.** From the formula: max difference from the script's nodes is 3.6e-15.
  - **Node values f(x_k).** From scipy (`j0`, `j1`, `y0`, `gamma`, `ndtr`, `log1p`, …): max relative difference is 7.7e-16.
  - **The interpolant.** As $\sum_{j<n} c_j T_j(t)$ with Mathews' coefficient formula. Agreement with the script's `barycentric_eval` over 29 cases × all n × 1000 points is a relative 3.7e-14 inside [a,b] and 2.6e-10 outside (extrapolation, where values reach about 1e6).
  - **Interpolation at the nodes.** Exact, which is trivially true because of the early return at line 122. The D1 agreement shows that the formula is also correct between nodes.
  - **Convergence inside the interval** (max |P − f| on grid points inside [a,b], n = 2 → n = 16):

    | Cases | n = 2 → n = 16 |
    |---|---|
    | 01–03 | 7.3 → 0.028; 7.2 → 0.025; 20.5 → 0.022 |
    | 04–06 | 0.38 → 0.044; 0.77 → 0.088; 0.86 → 0.099 |
    | 07–08 | 2.6 → 0.023; 0.83 → 0.0138 (case 08 at n = 32: 9.5e-5) |
    | 09–11 | 2.4 → 0.037; 3.0 → 0.13; 2.3 → 0.025 |
    | 12–14 | 1.27 → 8.1e-4; 1.93 → 1.7e-3; 5.9 → 0.023 |
    | 15–17 | 8.5 → 7.1e-12; 4.7 → 6.0e-9; 18.8 → 8.1e-9 |
    | 18–20 | 0.27 → 1.2e-4; 0.41 → 0.019; 0.71 → 1.05e-3 |
    | 21–23 | 0.57 → 5.0e-4; 0.36 → 7.9e-6; 0.18 → 1.1e-6 |
    | 24–26 | 15.0 → 0.18; 16.9 → 0.65; 12.9 → 1.0e-4 |
    | 27–29 | 0.76 → 2.1e-3; 0.98 → 1.9e-4; 0.51 → 1.4e-6 |

    These numbers support the frames: every case visibly converges inside its interval.
- **Property check of the even-function claim:** see A5 above.

**Reference values are right.** The "true" curve is $f$ itself, evaluated with Base/SpecialFunctions. Against scipy on every grid point the max relative difference is 1e-15. The finite/NaN pattern is identical: 0 mismatches, including log at x ≤ 0, sqrt at x < 0, asin at |x| > 1, gamma at x = 0 and Y0 at x = 0. The formulas behind the normal_pdf and normal_cdf labels are the correct ones.

**The picture shows what was computed.** I viewed frames 1, middle and last of all 29 GIFs (`review/grid_*.png`) and the titles of all 29 last frames at full size (`review/titles_last_*.png`). For every case:
- the magenta curve is f;
- the blue curve is the interpolant through the red nodes;
- the nodes lie on f;
- the title reports the case id, f, the interval, n and degree ≤ n−1, all correctly.

Display devices:
- **Y-window.** All 2424 plotted nodes lie inside the y-window (`review/extra.out`). `window_ylims` widens the window to cover f over the whole interval, as its comment says.
- **Clamping.** The interpolant and the non-pole f are clamped to a band one window-height beyond the limits. They therefore leave the frame instead of riding along its edge, which is acceptable.
- **Poles.** Cases 01, 02 and 14 insert a NaN at each pole, so there is no connecting line.
  - Case 03 (a double pole at x = 1, no `poles` entry): both sides clamp to the band top, 54.6, above ylim 26.3, so no visible connector.
  - Cases 24–26 (gamma, pole at 0, no `poles` entry): the 1000-point grid hits x = 0.0 exactly (grid index 40), where gamma(0) = Inf becomes NaN, so the branches are not joined. The frames confirm there is no vertical line. This depends on the grid happening to contain 0; adding `poles=[0.0]` would make it robust. It is not a defect in the current output.
- **Approximation interval.** It is not drawn in the frames; see F1.

**Other observations, not findings:**
- `xs_lo/ys_lo/y_lo` and `xs_hi/ys_hi/y_hi` (lines 211–217) are computed and never used. They have no effect on the output.
- The legacy animations also showed a tolerance band (±0.05, ±0.001, ±0.01 by case) and shaded "convergence regions", and used larger, case-specific maximum degrees (for example S₂₅ for gamma on [0.05, 2]). The page omits these; I count that as content the page does not have, not as an error.
- Legacy labels its frames by degree, Sₖ; the page labels them by n nodes with degree ≤ n−1. Both are consistent with their own frames.

**Could not determine:** the node intervals Mathews used for cases 01, 07, 14 and 19. The archive index gives no interval for them and no legacy GIF exists. Case 01's [-1.6, 0.9] is not the mirror image of case 02's [-0.9, 1.5]; the mirror image would be [-1.5, 0.9]. Without the source I cannot say whether that departs from Mathews.

