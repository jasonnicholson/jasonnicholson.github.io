# Fixed Point Iteration — animation review (round 6)

Page: `pages/numerical-methods/fixed-point-iteration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.**

I found no error, misleading statement or minor defect in the implementation, in the match between page and animations, or in fidelity to the archive. Each item behind this result is in the ledger and the implementation checks below.

Three observations are not findings:
- **Swapped legacy file names for Cases 4 and 5.** Mathews' `Fixpointdd` is Example 7 ($x_0 = 2.03$, divergent) and his `Fixpointee` is Example 8 ($x_0 = 1.95$, converges to 0). On this page `fixpointdd` is $x_0 = 1.95$ and `fixpointee` is $x_0 = 2.03$, and the case order is swapped to match. Each script's header names the correct Mathews example, and the page never refers to the legacy file names. A reader is not affected.
- **Case 6 runs further than the archive.** Mathews' `Fixpointff` stops at $p_9 = 3.03803$ inside $[0,4]$ and calls the example "Divergence". The page instead widens the window to $[-4.5, 4.5]$, runs 32 iterations, and describes the bounded orbit settling onto a 4-cycle. I verified that this is mathematically correct (see the Case 6 checks). It is a departure made in order to be right.
- **Dead code.** The "off-scale" marker branch in `fixpointdd.jl`, `fixpointee.jl` and `fixpointff.jl` never runs, because every drawn iterate lies inside its window (`all_in_window=true` for all six scripts). It has no effect on the output.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `fixpointaa.jl` | 0 | 5.9 | fixpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointbb.jl` | 0 | 6.6 | fixpointbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointcc.jl` | 0 | 5.8 | fixpointcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointdd.jl` | 0 | 7.8 | fixpointdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointee.jl` | 0 | 5.8 | fixpointee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointff.jl` | 0 | 8.1 | fixpointff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `fixpointaa.gif` | 13 | byte-identical | fixpointaa |
| `fixpointbb.gif` | 13 | byte-identical | fixpointbb |
| `fixpointcc.gif` | 13 | byte-identical | fixpointcc |
| `fixpointdd.gif` | 17 | byte-identical | fixpointdd |
| `fixpointee.gif` | 10 | byte-identical | fixpointee |
| `fixpointff.gif` | 33 | byte-identical | fixpointff |

### Page references

- Scripts linked: `fixpointaa.jl`, `fixpointbb.jl`, `fixpointcc.jl`, `fixpointdd.jl`, `fixpointee.jl`, `fixpointff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

The page has no separate Description section. The only method statement is the introduction to the Animations section.

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| I1 | Intro | The diagram plots "the identity line $y=x$ and the iteration function $y=g(x)$" | Every script plots `collect(xlims)` against itself, plus `g.(xplot)`. Both lines appear in the legend of every frame. | confirmed |
| I2 | Intro | Path goes "from the current iterate $x_n$ on the diagonal, vertical to the curve to get $g(x_n)=x_{n+1}$, then horizontal back to the diagonal" | `instrument.out`: at the curve vertices max\|y−g(x)\| = 0.0, and at the diagonal vertices max\|y−x\| = 0.0, for all six scripts. Frame *k* draws points `1:(1+2k)`, so the path ends at $(x_k, x_k)$, which is where the red marker sits. | confirmed |
| I3 | Intro | For $C^1$ $g$, $\|g'(x^*)\|<1$ means convergence for every start close enough to $x^*$ | Standard local contraction theorem (mean value theorem plus continuity of $g'$). | confirmed |
| I4 | Intro | For $\|g'(x^*)\|>1$, "iterates near $x^*$ (other than $x^*$ itself) move away from it" | Mean value theorem: $\|g(x)-x^*\| = \|g'(\xi)\|\,\|x-x^*\| > \|x-x^*\|$ on a neighbourhood where $\|g'\|>1$. Observed in Cases 4–6, where the first steps grow in distance: Case 4 0.05→0.074→0.110; Case 5 0.03→0.045→0.068; Case 6 0.03→0.045→0.068→0.100. | confirmed |
| I5 | Intro | "Julia source scripts … are linked under each case" | Six links present, one per case. | confirmed |
| C1a | Case 1 heading | $g(x)=\sqrt{2x}$, $x_0=0.1$ | `fixpointaa.jl:10–11` | confirmed |
| C1b | Case 1 | Curve meets $y=x$ at $x^*=2$ | sympy: fixed points {0, 2} | confirmed |
| C1c | Case 1 | $g'(2)=\tfrac12<1$ | sympy: $g'(2)=1/2$ | confirmed |
| C1d | Case 1 | "converges from below in a monotone staircase" | Iterates 0.1, 0.4472, 0.9457, …, 1.99854 increase strictly toward 2. Frames 1–13 show a rising staircase. | confirmed |
| C1e | Case 1 | Heading "Convergent staircase" | as C1d | confirmed |
| C1f | Case 1 alt | "starting below the fixed point at x₀ = 0.1" | as above | confirmed |
| C1g | Case 1 wiring | Link `fixpointaa.jl`, embed `fixpointaa.gif` | The script has $g$ and $x_0$ as in the heading, and the GIF is byte-identical to its output. | confirmed |
| C2a | Case 2 heading | $g(x)=\sqrt{2x}$, $x_0=4.0$ | `fixpointbb.jl:10–11` | confirmed |
| C2b | Case 2 | "Same function as Case 1 but starting above the fixed point" | as above | confirmed |
| C2c | Case 2 | "descends monotonically to $x^*=2$" | Iterates 4, 2.8284, 2.3784, …, 2.000338 decrease strictly. Frames agree. | confirmed |
| C2d | Case 2 | "confirming convergence from both sides" | Cases 1 and 2 together show it. | confirmed |
| C2e | Case 2 alt / wiring | Matches `fixpointbb.jl` / `.gif` | as above | confirmed |
| C3a | Case 3 heading | $g(x)=\tfrac{8}{x+2}$, $x_0=4.0$ | `fixpointcc.jl:11–12` | confirmed |
| C3b | Case 3 | "strictly decreasing, with $g'(x)=-\tfrac{8}{(x+2)^2}$" | sympy derivative. Decreasing on the plotted domain $x>-2$. | confirmed |
| C3c | Case 3 | $g'(2)=-\tfrac12$, $\|g'(2)\|=\tfrac12<1$, converges | sympy $-1/2$. Iterates reach 2.000366 at $x_{12}$. | confirmed |
| C3d | Case 3 | "staircase alternates sides of $x^*$ on each step" | 4.0 (>2), 1.3333 (<2), 2.4, 1.8182, 2.0952, 1.9535, 2.0235, 1.9883, 2.0059, 1.9971, 2.0015, 1.9993, 2.0004 alternate at every step. The frames show the spiral (box) pattern. | confirmed |
| C3e | Case 3 heading | "Oscillating convergent" | as C3c–d | confirmed |
| C3f | Case 3 alt / wiring | Matches `fixpointcc` | as above | confirmed |
| C4a | Case 4 heading | $g(x)=\tfrac{x^2}{4}+\tfrac{x}{2}$, $x_0=1.95$ | `fixpointdd.jl:11–12` | confirmed |
| C4b | Case 4 heading | "Repelled from $x^*=2$, converges to $x=0$" | Iterates move away from 2 and decrease to 0.019332 at $x_{16}$. The limit is 0 because $g'(0)=1/2$ makes 0 attracting and the sequence is monotone and bounded below by 0. | confirmed |
| C4c | Case 4 | Crosses $y=x$ at $x^*=2$ and $x=0$ | sympy fixed points {0, 2} | confirmed |
| C4d | Case 4 | "lies below the diagonal for $0<x<2$" | $g(x)-x = x(x-2)/4 < 0$ on $(0,2)$ | confirmed |
| C4e | Case 4 | $g'(2)=\tfrac32>1$; $g'(0)=\tfrac12$ | sympy: 3/2, 1/2 | confirmed |
| C4f | Case 4 | "walks away from $x^*=2$ toward the left and converges monotonically to … $x=0$" | Strictly decreasing sequence 1.95 → 0.0193. Frames 1–17 show a leftward staircase ending near the origin. | confirmed |
| C4g | Case 4 alt | "starting at x₀ = 1.95 just below the repelling fixed point … walks left and converges to the fixed point x = 0" | as above | confirmed |
| C4h | Case 4 wiring | `fixpointdd.jl` / `.gif` | as above | confirmed |
| C5a | Case 5 heading | Same $g$, $x_0=2.03$, "Divergent" | `fixpointee.jl:12–13`. Iterates grow without bound: $x_{14}=14373$. Since $g(x)-x = x(x-2)/4 > 0$ for $x>2$ and grows, the sequence diverges to $+\infty$. | confirmed |
| C5b | Case 5 | "moves monotonically rightward and diverges" | Strictly increasing sequence 2.03, 2.0452, …, 3.7534, 5.3986, … | confirmed |
| C5c | Case 5 | "showing instability from both sides" | Together with Case 4. | confirmed |
| C5d | Case 5 | "The animation stops at $x_9 \approx 3.753$, the last iterate inside the window" | Script $x_9 = 3.753371$, mpmath 3.753371. $x_{10}=5.3986 > 4$. 10 frames, last label `x_9 = 3.7534`. | confirmed |
| C5e | Case 5 | "$x_{12}\approx 29.92$" | mpmath 29.921011 | confirmed |
| C5f | Case 5 | "$x_{14}\approx 1.437\times10^4$" | mpmath 14373.031 | confirmed |
| C5g | Case 5 alt | "climbs away from x* = 2 and reaches x₉ ≈ 3.753 at the right of the window" | The last frame shows the marker at (3.753, 3.753) near the right edge of $[0,4]$. | confirmed |
| C5h | Case 5 wiring | `fixpointee.jl` / `.gif` | as above | confirmed |
| C6a | Case 6 heading | $g(x)=-\tfrac{x^2}{4}-\tfrac{x}{2}+4$, $x_0=1.97$ | `fixpointff.jl:12–13` | confirmed |
| C6b | Case 6 | "steeply decreasing at $x^*=2$"; $g'(2)=-\tfrac32$, $\|g'(2)\|>1$ | sympy: fixed points {−8, 2}, $g'(2)=-3/2$ | confirmed |
| C6c | Case 6 | "does not converge to $x^*$: the staircase moves away from $x^*=2$" | $\|x_n-2\|$ goes 0.03, 0.045, 0.068, 0.100, 0.153, 0.224, 0.348, 0.49, 0.80, 1.04, 1.83, … | confirmed |
| C6d | Case 6 | "alternating sides at every step" | The signs of $x_n-2$ alternate for every $n$ from 0 to 32, including inside the 4-cycle (4.25 >2, −2.64 <2, 3.58 >2, −0.99 <2). | confirmed |
| C6e | Case 6 | "settles onto a stable 4-cycle (≈ 4.25, −2.64, 3.58, −0.99)" | The real period-4 points from sympy `nroots` of $g^{4}(x)-x$ are 4.249962, −2.640524, 3.577170, −0.987621, visited in that order. The cycle multiplier $\prod g'(p_i) = -0.0305$, so the cycle is attracting. The only other cycle of period ≤ 4, the 2-cycle {−2, 4}, is repelling (multiplier 1.5625). $x_{29..32}$ = 4.2493, −2.6388, 3.5786, −0.9909 are within 0.0033 of the cycle, and $x_{36..40}$ (mpmath) are within $10^{-3}$. | confirmed |
| C6f | Case 6 heading | "Oscillating, does not converge" | as above | confirmed |
| C6g | Case 6 alt | "starting at x₀ = 1.97 just below x* = 2; … alternating sides, and settles onto a 4-cycle" | as above. The last frame (33) shows the orbit wrapping the 4-cycle, with `x_32 = -0.9909`. | confirmed |
| C6h | Case 6 wiring | `fixpointff.jl` / `.gif` | as above | confirmed |
| K1 | Counts | Six cases, six scripts, six GIFs | Manifest: 6 scripts, 6 GIFs, all referenced. | confirmed |

### 3. Implementation checks

All six scripts run the same method, plain fixed-point iteration $x_{n+1}=g(x_n)$ (`xs[i+1] = g(xs[i])`). There is no safeguard and no acceleration, so this is exactly the method in the title. None of them draws a numerically computed reference: the fixed points shown are found analytically and stated in the text, and I confirmed them with sympy. Each script's cobweb is built as $(x_0,x_0)$ followed by $(x_n, x_{n+1})$ and $(x_{n+1}, x_{n+1})$. The vertex check in `instrument.out` gives a residual of exactly 0 on the curve and on the diagonal for every script. The legend labels in the frames come from the true `xs` values, and I compared them with the independent values below. Frame counts equal `n_iters+1`.

Columns: the script's `xs` from `instrument.out`, then mpmath at 40 digits from `indep.py`, rounded.

**fixpointaa.jl** ($\sqrt{2x}$, $x_0 = 0.1$, 12 iterations, window $[0,4]^2$)
- Script: 0.447214, 0.945742, 1.375312, 1.658501, 1.821264, 1.908541, 1.953735, 1.976732, 1.988332, 1.994158, 1.997077, 1.998538
- mpmath: 0.4472136, 0.94574161, 1.375312, 1.6585006, 1.8212636, 1.9085406, 1.9537352, 1.9767322, 1.9883321, 1.9941575, 1.9970766, 1.9985378. These agree with the script.
- Frame labels checked: x₀ = 0.1, x_2 = 0.9457, x_4 = 1.6585, x_6 = 1.9085, x_8 = 1.9767, x_10 = 1.9942, x_12 = 1.9985.
- Convergence rate: the error ratio $(2-x_{12})/(2-x_{11}) = 0.00146/0.00292 \approx 0.50$, which equals $g'(2)$.

**fixpointbb.jl** ($\sqrt{2x}$, $x_0 = 4.0$, 12 iterations, window $[0,4.2]^2$)
- Script: 2.828427, 2.378414, 2.181015, 2.088548, 2.043794, 2.021779, 2.01086, 2.005423, 2.002709, 2.001354, 2.000677, 2.000338
- mpmath: 2.8284271, 2.3784142, 2.1810155, 2.0885476, 2.0437943, 2.0217786, 2.0108598, 2.0054226, 2.0027094, 2.0013543, 2.000677, 2.0003385. These agree with the script.
- Frame labels checked for $x_0$ through $x_{12}$ (even frames), for example x_6 = 2.0218 and x_12 = 2.0003.

**fixpointcc.jl** ($8/(x+2)$, $x_0 = 4.0$, 12 iterations, window $[0,4.2]^2$)
- Script: 1.333333, 2.4, 1.818182, 2.095238, 1.953488, 2.023529, 1.988304, 2.005865, 1.997072, 2.001465, 1.999268, 2.000366
- mpmath: 1.3333333, 2.4, 1.8181818, 2.0952381, 1.9534884, 2.0235294, 1.9883041, 2.0058651, 1.9970717, 2.0014652, 1.9992677, 2.0003662. These agree with the script.
- Frame labels checked: x_2 = 2.4, x_4 = 2.0952, x_6 = 2.0235, x_8 = 2.0059, x_10 = 2.0015, x_12 = 2.0004.
- Convergence rate: the error ratio is −0.5 at every step, which equals $g'(2)$.

**fixpointdd.jl** ($x^2/4+x/2$, $x_0 = 1.95$, 16 iterations, window $[0,4]^2$)
- Script: 1.925625, 1.88982, 1.837766, 1.763228, 1.658858, 1.517381, 1.334302, 1.112241, 0.865391, 0.619921, 0.406036, 0.244234, 0.13703, 0.073209, 0.037944, 0.019332
- mpmath: these agree to 6 or more digits (for example $x_{16}$ = 0.01933216).
- The header comment "x_16 = 0.0193" is correct.
- Frame labels checked: x_2 = 1.8898, x_4 = 1.7632, x_6 = 1.5174, x_8 = 1.1122, x_10 = 0.6199, x_12 = 0.2442, x_14 = 0.0732, x_16 = 0.0193.
- Convergence rate near 0: the ratio $x_{16}/x_{15} = 0.509$, which approaches $g'(0) = 0.5$.

**fixpointee.jl** (same $g$, $x_0 = 2.03$, 9 iterations, window $[0,4]^2$)
- Script: 2.045225, 2.068349, 2.103691, 2.158225, 2.243596, 2.380228, 2.606486, 3.001685, 3.753371
- mpmath: 2.045225, 2.0683488, 2.1036911, 2.1582247, 2.2435957, 2.3802283, 2.6064859, 3.0016851, 3.753371. These agree with the script. The continuation is $x_{10}$ = 5.3986339, $x_{12}$ = 29.921011, $x_{14}$ = 14373.031.
- The header comments "x_9 = 3.7534" and "x_10 = 5.3986" are correct.
- All ten frame labels checked.

**fixpointff.jl** ($-x^2/4 - x/2 + 4$, $x_0 = 1.97$, 32 iterations, window $[-4.5,4.5]^2$)
- Script $x_1..x_{32}$ agree with mpmath to 6 or more digits, for example $x_9$ = 3.038033 / 3.0380333, $x_{30}$ = −2.638787 / −2.6387871, $x_{32}$ = −0.990881 / −0.99088119.
- Frame labels checked: x_3 = 2.1004, x_6 = 1.6519, x_9 = 3.038, x_12 = −1.7664, x_15 = 3.8528, x_18 = −2.3766, x_21 = 4.1987, x_24 = −1.2316, x_27 = 3.6056, x_30 = −2.6388, x_32 = −0.9909.
- Reference structure: see C6e for the period-4 orbit and its multiplier.
- The header claims are correct:
  - "within 0.004 of the 4-cycle by $x_{29..32}$": the maximum deviation is 0.0033.
  - "orbit stays in [−2.639, 4.250]": the drawn minimum is −2.6388 and the maximum 4.2493.
  - "min of g on the window is g(4.5) = −3.3125": correct, so the bottom-right legend hides no data.
- The title is not clipped (frame 33).

**Display devices.** No clamping, NaN masking or off-scale handling takes effect in any GIF, because every iterate lies inside its window. The windows show the whole feature each page describes:
- Case 5 stops at the last in-window iterate and states the later values in the text.
- Case 6's window contains the whole orbit and the parabola's maximum $g(-1) = 4.25$.

**Fidelity to Mathews.** Legacy examples 4–9 match Cases 1–6 in function and starting value: √2√x with p₀ = 0.1 and 4.0; 8/(x+2) with p₀ = 4.0; x²/4 + x/2 with p₀ = 2.03 and 1.95; −x²/4 − x/2 + 4 with p₀ = 1.97. The legacy frames' $p_n$ values agree with my computation, for example $p_8$ = 1.97673, $p_5$ = 1.95349 and $p_9$ = 3.03803. Examples 1–3 in the archive are Mathematica-command exercises with no animation, so leaving them out drops no animated case.

