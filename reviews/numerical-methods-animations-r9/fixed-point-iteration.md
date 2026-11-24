# Fixed Point Iteration — animation review (round 9)

Page: `pages/numerical-methods/fixed-point-iteration/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0.

Every checkable claim on the page, in the script headers, and in the frames agrees with my own computation (details below). Items I looked at and judged not to be findings:

- `fixpointaa.jl` title has no `x₀` while the other five titles do; the legend writes `x₀` in aa and `x_0` in the others. Cosmetic; does not mislead.
- The off-scale marker branch in `fixpointdd/ee/ff.jl` is never taken (all plotted iterates are inside the window). Dead code, not a display issue.
- In `fixpointff` the magenta curve leaves the right edge at y = g(4.5) = −3.3125, touching the top-right corner of the bottom-right legend; nothing of the cobweb (min y = −2.6405) is covered.
- Mathews' Examples 1–3 (g = 1 + x − x²/3, 1 + x − x²/4; Mathematica subroutine exercises) are not on the page. They are not part of Mathews' "Various Scenarios and Animations" set (Examples 4–9), which the page reproduces in full, so this is not a dropped animation case.
- Mathews labels Example 9 "Divergence: Spiral". The page instead says the orbit settles onto a stable 4-cycle. That is a departure in order to be correct (verified below), so not a fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `fixpointaa.jl` | 0 | 12.1 | fixpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointbb.jl` | 0 | 6.3 | fixpointbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointcc.jl` | 0 | 8.8 | fixpointcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointdd.jl` | 0 | 6.9 | fixpointdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointee.jl` | 0 | 6.5 | fixpointee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointff.jl` | 0 | 8.5 | fixpointff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| I1 | Intro | Diagram plots y = x and y = g(x), path from x_n on diagonal, vertical to curve to get g(x_n) = x_{n+1}, then horizontal back to diagonal | Code builds (x_n,x_n)→(x_n,x_{n+1})→(x_{n+1},x_{n+1}); instrumented cobweb_x/cobweb_y print exactly this; frames show it | confirmed |
| I2 | Intro | For C¹ g, \|g'(x*)\|<1 ⇒ convergence for x_0 close enough | Standard local contraction theorem (MVT + continuity of g') | confirmed |
| I3 | Intro | \|g'(x*)\|>1 ⇒ iterates near x* (≠ x*) move away | By continuity \|g'\|>1 on a neighbourhood, MVT gives \|g(x)−x*\|>\|x−x*\| there | confirmed |
| I4 | Intro | Julia scripts linked under each case | 6 links, 6 embeds, each to the matching stem | confirmed |
| C1a | Case 1 heading | g(x)=√(2x), x_0=0.1 | fixpointaa.jl L10–11; Mathews Ex. 4 (p0=0.1) | confirmed |
| C1b | Case 1 | Meets y=x at 0 and x*=2 | √(2x)=x ⇒ x∈{0,2} | confirmed |
| C1c | Case 1 | On (0,2) increasing, between y=x and y=2 | √(2x)>x ⇔ x<2; √(2x)<2 ⇔ x<2 | confirmed |
| C1d | Case 1 | Iterates climb monotonically to 2 | x_0..x_12 = 0.1, 0.4472, 0.9457, …, 1.99854, strictly increasing (mpmath and script agree) | confirmed |
| C1e | Case 1 | g'(x)>1 for 0<x<½, includes x_0=0.1 | g'=1/√(2x); g'(½)=1; g'(0.1)=2.236 | confirmed |
| C1f | Case 1 | g'(2)=½; error roughly halved near x* | sympy g'(2)=1/2; e_12/e_11 = 0.001462/0.002923 = 0.500 | confirmed |
| C1g | Case 1 alt | starts below fixed point at x₀=0.1 | frame 1 marker at 0.1 | confirmed |
| C2a | Case 2 heading | same g, x_0=4.0 | fixpointbb.jl L10–11; Mathews Ex. 5 (p0=4.0) | confirmed |
| C2b | Case 2 | Descends monotonically to 2 | 4, 2.8284, 2.3784, 2.1810, …, 2.000338, strictly decreasing | confirmed |
| C2c | Case 2 alt | starts above at x₀=4.0 | frame 1 | confirmed |
| C3a | Case 3 heading | g=8/(x+2), x_0=4.0, oscillating convergent | fixpointcc.jl L11–12; Mathews Ex. 6 (p0=4.0) | confirmed |
| C3b | Case 3 | strictly decreasing, g'=−8/(x+2)², g'(2)=−½ | sympy | confirmed |
| C3c | Case 3 | converges, alternating sides of x* each step | x_n−2 = +2, −0.667, +0.4, −0.182, +0.095, …, +0.000366: sign alternates every step, \|e\| shrinks by ~½ | confirmed |
| C4a | Case 4 heading | g=x²/4+x/2, x_0=1.95; repelled from 2, converges to 0 | fixpointdd.jl L11–12; Mathews Ex. 8 (p0=1.95) | confirmed |
| C4b | Case 4 | crosses y=x at 2 and 0; below diagonal on (0,2) | g−x = x(x−2)/4 (sympy factor) | confirmed |
| C4c | Case 4 | g'(2)=3/2>1, g'(0)=½ | sympy | confirmed |
| C4d | Case 4 | walks left, converges monotonically to 0 | 1.95, 1.9256, 1.8898, …, 0.0379, 0.0193 strictly decreasing; tends to 0 with ratio → ½ (0.0193/0.0379 = 0.509) | confirmed |
| C4e | Case 4 alt | as above | frames 1–17 | confirmed |
| C5a | Case 5 heading | same g, x_0=2.03, divergent | fixpointee.jl L12–13; Mathews Ex. 7 (p0=2.03) | confirmed |
| C5b | Case 5 | moves monotonically rightward and diverges | 2.03, 2.0452, …, 3.7534, 5.3986, 9.9856, 29.92, 238.8, 1.437e4, 5.17e7 | confirmed |
| C5c | Case 5 | animation stops at x_9≈3.753, last iterate inside window | n_iters=9; x_9=3.75337; x_10=5.3986>4 | confirmed |
| C5d | Case 5 | x_12≈29.92, x_14≈1.437×10⁴ | mpmath: 29.9210, 14373.03 | confirmed |
| C5e | Case 5 alt | reaches x₉≈3.753 at right of window | frame 10 marker at 3.753, legend "x_9 = 3.7534" | confirmed |
| C6a | Case 6 heading | g=−x²/4−x/2+4, x_0=1.97, oscillating, does not converge | fixpointff.jl L12–13; Mathews Ex. 9 (p0=1.97) | confirmed |
| C6b | Case 6 | g'(2)=−3/2, \|g'(2)\|>1 | g'=−x/2−½ ⇒ −1.5 | confirmed |
| C6c | Case 6 | moves away from 2, alternating sides at every step | x_n−2 signs alternate for n=0..60; \|x_n−2\| grows 0.03→0.045→0.068→…→1.83 by n=10 | confirmed |
| C6d | Case 6 | settles onto a stable 4-cycle ≈ 4.25, −2.64, 3.58, −0.99 | findroot of g⁴(x)=x from 4.25: {4.249962, −2.640524, 3.577170, −0.987621}; multiplier ∏g'(c_i) = −0.0305 (stable); orbit at n=57–60 equals the cycle to 10 digits | confirmed |
| C6e | Case 6 alt | as above | frame 33 shows the accumulating 4-cycle box; legend "x_32 = -0.9909" | confirmed |
| F1 | frames | frame counts 13/13/13/17/10/33 = n_iters+1 | manifest; scripts | confirmed |
| F2 | frames | legend label x_k matches the marker and the path end at each frame | Marker at xs[frame+1], path to point 1+2·frame = (x_k,x_k); labels match instrumented iterates (e.g. aa x_12=1.9985, dd x_16=0.0193, ff x_32=−0.9909) | confirmed |
| F3 | frames | title function = code function in every script | read all six titles vs g definitions | confirmed |

### 3. Implementation checks

All six scripts implement plain fixed-point iteration x_{n+1}=g(x_n) (no relaxation, no acceleration) and draw the standard cobweb path. Reference values are the fixed points 0, 2 (and −4, −8 off-window), verified by solving g(x)=x symbolically.

Script output (Julia, instrumented copy in `review/inst/`) vs independent mpmath (40 digits, `review/indep.py`), selected iterates; all 13/13/13/17/10/33 values agree to every printed Float64 digit (differences at ~1e-16):

| Script | g, x_0 | Script | Independent |
|---|---|---|---|
| aa | √(2x), 0.1 | x_1 0.4472135954999579, x_12 1.9985377748870492 | 0.4472135955, 1.99853777489 |
| bb | √(2x), 4.0 | x_1 2.8284271247461903, x_12 2.0003384794106043 | 2.82842712475, 2.00033847941 |
| cc | 8/(x+2), 4.0 | x_2 2.4000000000000004, x_12 2.000366233290606 | 2.4, 2.00036623329 |
| dd | x²/4+x/2, 1.95 | x_8 1.1122411037173416, x_16 0.019332159933648924 | 1.11224110372, 0.0193321599336 |
| ee | x²/4+x/2, 2.03 | x_9 3.7533709825454316 | 3.75337098255 (x_10 5.39863, x_12 29.9210, x_14 14373.03) |
| ff | −x²/4−x/2+4, 1.97 | x_10 0.17357176936742214, x_29 4.249299810488342, x_32 −0.9908811883812021 | 0.173571769367, 4.24929981049, −0.990881188381 |

Script header claims checked: aa/bb/cc "g'(2)" values ✓; dd "x_16 = 0.0193" ✓; ee "x_9 = 3.7534 … x_10 = 5.3986" ✓; ff "orbit stays in [−2.641, 4.250]" ✓ (min −2.64052, max 4.2493 over x_0..x_32), "min of g on window is g(4.5) = −3.3125" ✓ (vertex at x=−1 is the max 4.25; g(−4.5)=1.1875), "by x_29…x_32 within 0.004 of the 4-cycle" ✓ (deviations 0.00066, 0.0017, 0.0014, 0.0033). Mathews example numbers in headers (Ex. 5–9) match the archive formula images.

Picture: first, middle and last frames of every GIF viewed (contact sheets plus aa frame 13, ff frame 33). Each vertical segment runs from (x_n,x_n) to (x_n,g(x_n)) on the magenta curve, each horizontal back to the green diagonal; the red marker sits on the diagonal at the labelled iterate. All plotted iterates lie inside the axis windows (aa/dd/ee [0,4], bb/cc [0,4.2], ff [−4.5,4.5]), so no clamping is involved; the clamping branch is unused. The feature each Behavior paragraph discusses (convergence to 2, convergence to 0, exit toward the right edge, the 4-cycle) is visible in the window.

Regeneration: all six scratch runs exit 0 with no warnings; committed GIFs byte-identical to regenerated ones (manifest).

