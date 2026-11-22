# Trapezoidal Rule for Numerical Integration — animation review

Page: [`pages/numerical-methods/trapezoidal-rule-for-numerical-integration/index.qmd`](../../pages/numerical-methods/trapezoidal-rule-for-numerical-integration/index.qmd) · Scripts: `trapezoidalaa.jl` · GIFs: 1

**Result:** 1 error, 0 misleading, 0 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Stated $O(h^2)$ convergence is false for this integrand; the measured order is $5/3$

- **Location:** `index.qmd:29`: "the approximation converges toward the true integral with $O(h^2)$ global error." (The general statement at `index.qmd:18`, "For smooth functions, the global truncation error is second order", is correct as written, but the page's only example is not a smooth function.)
- **Now:** The Behavior paragraph says this case has $O(h^2)$ global error.
- **True:** $f(x)=e^{-x}\sin(8x^{2/3})+1$ behaves like $1+8x^{2/3}$ near $x=0$, so $f'(x)\sim \tfrac{16}{3}x^{-1/3}$ is unbounded at the left endpoint. The trapezoid error for an $x^{\alpha}$ endpoint singularity is $O(h^{1+\alpha})$, here $O(h^{5/3})$. Halving $h$ divides the error by $2^{5/3}\approx 3.175$, not by 4.
- **Evidence:** `reviewer/independent.py` (run with `/usr/bin/python3 -I independent.py`, mpmath at 40 digits, trapezoid sums computed independently of the script) gives these values of $E(n)/E(2n)$ and the observed order $p=\log_2$ of that ratio: n=16: 2.947 (p=1.559); 32: 3.115 (1.639); 64: 3.151 (1.656); 128: 3.162 (1.661); 1024: 3.170 (1.665); 8192: 3.1728 (p=1.6658, approaching 5/3=1.6667). Over the frames actually shown: 24→48 ratio 3.142, 48→96 3.158, 60→120 3.161 (p≈1.66). As a control, the script's own `trapezoid_sum` applied to the smooth $e^x$ on [0,2] (`reviewer/exactness.jl`) gives ratios 3.997, 3.9992, 3.9998, 3.99995, so the routine is second order whenever the integrand is smooth. The shortfall comes from the integrand, not the code.
- **Suggested fix:** Change line 29 to something like: "…the approximation converges toward the true integral. Because $x^{2/3}$ gives $f$ an infinite slope at $x=0$, the error here decreases like $O(h^{5/3})$ (halving $h$ cuts the error by about 3.2), not the $O(h^2)$ rate the trapezoidal rule achieves for smooth integrands." Optionally add the same caveat to line 18.

- **Independent check:** confirmed. Checker: line 29 is the Behavior line for this integrand; measured order → 5/3 (1.666 at n=16384; slope 1.64 over the animation's n=8..120). Line 18's general 'for smooth functions' statement is correct.

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `trapezoidalaa.jl` | yes | 3.5 | trapezoidalaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12–13 | "replacing $f$ on each subinterval with a line segment between neighboring nodes" | Script lines 32–41 join $(x_i,f(x_i))$ to $(x_{i+1},f(x_{i+1}))$ and fill the region down to 0. Frames 2, 4, 13 and 24 show the chords meeting the curve at the nodes | confirmed |
| 2 | 14–16 | $T_n = h[\tfrac12 f(x_0)+\sum_{i=1}^{n-1}f(x_i)+\tfrac12 f(x_n)]$, $h=(b-a)/n$ | Script lines 18–22 implement exactly this. It is exact for $3x+1$ (8.0), and on $x^2$ the error is 1.3333 (n=1) and 0.08333 (n=4), equal to $(b-a)h^2 f''/12$ (`exactness.jl`) | confirmed |
| 3 | 18 | "For smooth functions, the global truncation error is second order: $T_n - I = O(h^2)$" | Script routine on $e^x$: halving ratios → 4.000 | confirmed (general statement). See F1 for this integrand |
| 4 | 18 | "accuracy improves as node spacing is reduced across the full interval" | Errors vs mpmath reference fall from 0.0372 (n=16) to 0.00134 (n=120), and to 1.2e-6 at n=8192 | confirmed (not monotone for n≤4, see #9) |
| 5 | 22–23 | Diagram over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | Script lines 8–9: `f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1`, `a, b = 0.0, 2.0`, xlims (0,2) | confirmed |
| 6 | 23 | "Each new frame recomputes the approximation on the full interval with a denser partition" | Frames 2–24 use n = 1,2,3,4,5,6,7,8,10,…,96,120, strictly increasing, uniform over [0,2]. Frame 1 is the bare curve with no partition | confirmed |
| 7 | 27 | Case heading: Composite Trapezoidal Rule, same $f$ on $[0,2]$ | Same as #2 and #5 | confirmed |
| 8 | 29 | "As the number of sample points increases, trapezoids across the entire interval become narrower" | Width $2/n$ with n increasing. Frames 13 and 24 show this | confirmed |
| 9 | 29 | "the approximation converges toward the true integral" | Reference $I=2.016279719617096327887274$. Frame values 2.017925, 2.372927, 1.899071, 1.802071, 1.821893, …, 2.014345, 2.014944. Errors from n=4 on: −0.214, −0.194, −0.161, …, −0.00193, −0.00134, shrinking toward 0. Note: the n=1 frame (2.017925, error 0.0016) is closer to $I$ than every later frame except the last, by coincidence, and the GIF never shows $I$. This is not a false statement | confirmed |
| 10 | 29 | "…with $O(h^2)$ global error" | Measured order 1.66 → 5/3 | wrong (→ F1) |
| 11 | 31 | Link `trapezoidalaa.jl` is this case's source | The manifest shows the script produces the committed GIF byte-identically | confirmed |
| 12 | 33 | Embed `trapezoidalaa.gif`. Alt text: "over [0,2] with full-interval density refinement: each frame uses a denser partition and updates the global approximation" | Same as #6. The annotation "Approximation = …" changes every frame from frame 2 onward | confirmed |
| 13 | 25 / 29 (implicit) | "Sample Points" shown in frames | Annotation is `n+1` (script line 45), which equals the number of nodes $x_0,\dots,x_n$. Frame 2: n=1 → "Sample Points = 2", frame 24: n=120 → 121 | confirmed |

## Implementation checks

### trapezoidalaa.jl
- **Method:** It is the composite trapezoidal rule on uniform nodes $x_i=a+ih$, $h=(b-a)/n$, with half weights at both endpoints (lines 18–22). No other variant is involved. On the script's own routine, `reviewer/exactness.jl` shows it is exact for linear functions and not for $x^2$, with an error matching the $h^2 f''(b-a)/12$ term, and second order on smooth $e^x$ (halving ratio 3.99995).
- **Numbers:** The script's values come from `reviewer/print_values.jl` (lines 8–22 copied, no plotting). The independent values come from `reviewer/independent.py` (mpmath at 40 digits, sum written separately). They agree to every printed digit:

  | n | script | independent | error vs $I$ |
  |---|---|---|---|
  | 1 | 2.017924816215668 | 2.01792481622 | +0.00165 |
  | 2 | 2.372926966994002 | 2.37292696699 | +0.357 |
  | 3 | 1.899070845729605 | 1.89907084573 | −0.117 |
  | 4 | 1.8020714882340843 | 1.80207148823 | −0.214 |
  | 8 | 1.9065949303145524 | 1.90659493031 | −0.110 |
  | 16 | 1.97905585678816 | 1.97905585679 | −0.0372 |
  | 32 | 2.0043311120844143 | 2.00433111208 | −0.0119 |
  | 56 | 2.0115474483164135 | 2.01154744832 | −0.00473 |
  | 96 | 2.0143452207227672 | 2.01434522072 | −0.00193 |
  | 120 | 2.0149444646203434 | 2.01494446462 | −0.00134 |

  All 23 n values match (full list in the output of both scripts). The frames display these values rounded to 6 digits. Julia's `round` drops trailing zeros, so n=18 shows 1.98554 and n=48 shows 2.01017. That is cosmetic and the values are correct.
- **Reference values:** The script draws and prints no "true" integral. I computed $I=\int_0^2 f\,dx = 2.016279719617096327887274$ two ways, both with mpmath: the substitution $x=t^3$, which removes the singular slope at 0, and direct quadrature on 40 subintervals. Both agree to all 25 digits shown. Convergence order: halving ratios approach $2^{5/3}=3.175$ (3.1728 at n=8192), so the order is 5/3, not 2 (F1).
- **Picture:** I viewed the contact sheet and the full-size frames 1 (curve only, n=0), 2 (n=1), 4 (n=3), 13 (n=16) and 24 (n=120). Each trapezoid is the shape $(x_l,0),(x_r,0),(x_r,f(x_r)),(x_l,f(x_l))$, and its top chord meets the magenta curve exactly at the nodes. For example, in frame 4 the chords meet the curve at x=0, 2/3, 4/3 and 2, and in frame 13 at multiples of 0.125. The curve is the same $f$ as the summed one (line 49). The y-limits [0, 2.1] contain the whole curve (max ≈ 1.92, min ≈ 0.36), and nothing is clamped or masked. The annotations show n+1 nodes and $T_n$ for that frame's n. The title has no function or parameter text that could disagree with the code. 24 frames = 1 blank plus 23 partitions, at 2 fps.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/trapezoidal-rule-for-numerical-integration/`](evidence/trapezoidal-rule-for-numerical-integration/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
