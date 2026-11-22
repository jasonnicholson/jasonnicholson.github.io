# Fixed Point Iteration — animation review (round 5)

Page: `pages/numerical-methods/fixed-point-iteration/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1: Fidelity, Minor. The file stems and case order for Mathews' Examples 7 and 8 are swapped relative to the archive

- **Location:** `fixpointdd.jl` (x0 = 1.95; its header line 2 says "Mathews' Example 8") and `fixpointee.jl` (x0 = 2.03; its header line 2 says "Mathews' Example 7"). Also `index.qmd` Case 4 (x0 = 1.95) and Case 5 (x0 = 2.03).
- **What is there now:** `fixpointdd` is the convergent run from 1.95 and `fixpointee` is the divergent run from 2.03. The page shows 1.95 first (Case 4) and 2.03 second (Case 5).
- **What the archive has:**
  - Example 7, "Divergence: Monotone Increasing", is g(x) = x²/4 + x/2 with p0 = 2.03. `FixedPointMod_lnk_8.html` links it to `Fixpointdd.html`, and the legacy `Fixpointdd.gif` frames show p0 = 2.03000, p1 = 2.04522, … p8 = 3.00169.
  - Example 8, "Convergence: Monotone Decreasing", has p0 = 1.95. `FixedPointMod_lnk_9.html` links it to `Fixpointee.html`.
  - So the archive's dd is 2.03 and its ee is 1.95, the reverse of this page.
- **Why this is only Minor:**
  - The scripts' header comments cite the correct example numbers.
  - The mathematics, the wiring and every claim on the page are correct.
  - The only effect is that anyone cross-referencing the legacy `Fixpointdd`/`Fixpointee` animations, or Mathews' example order, finds them reversed.
- **How I know:** I read `sed 's/<[^>]*>//g' FixedPointMod_lnk_8.html` and `FixedPointMod_lnk_9.html` together with their `href` targets, the formula images `FixedPointMod_gr_353–355.gif` (p0 = 2.03) and `_gr_389–391.gif` (p0 = 1.95), and the legacy `Fixpointdd.gif` frames.
- **Suggested correction:** Either:
  - swap the stems (`fixpointdd` ↔ `fixpointee`: the scripts, the GIFs and the `index.qmd` references) and the order of Cases 4 and 5, so that both follow Mathews' Example 7 then Example 8; or
  - leave it as it is and add a one-line comment in each script saying that the stem is deliberately swapped relative to the archive.

No other findings. In particular, I found no wrong number, no behaviour claim contradicted by the computed iterates, and no plotting element built from the wrong quantity.

Other departures from the archive that I checked and do not count as findings:
- Mathews titles Example 9 "Divergence: Spiral". The page says "does not converge … settles onto a stable 4-cycle". The page is mathematically right: the orbit is bounded and attracted to a 4-cycle (see below), so "Divergence" in the sense of growing without bound would be wrong.
- The page draws Case 6 in the window [−4.5, 4.5]², where Mathews uses x ∈ [0, 4.05]. The larger window is needed to show the cycle.
- Mathews' Examples 1–3 are Mathematica-subroutine demonstrations with no animation. The page reproduces all six animated examples, 4–9.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Summary: 0 Error, 0 Misleading, 1 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `fixpointaa.jl` | 0 | 7.8 | fixpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointbb.jl` | 0 | 6.6 | fixpointbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointcc.jl` | 0 | 7.9 | fixpointcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointdd.jl` | 0 | 6.2 | fixpointdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointee.jl` | 0 | 6.1 | fixpointee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointff.jl` | 0 | 8.2 | fixpointff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page text (quoted or paraphrased closely) | Evidence | Verdict |
|---|---|---|---|
| I1 | Diagram plots "the identity line y = x and the iteration function y = g(x)" | Every script plots `collect(xlims)` vs itself (green) and `g.(xplot)` (magenta); visible in all frames | confirmed |
| I2 | Staircase "from the current iterate x_n on the diagonal, vertical to the curve to get g(x_n) = x_{n+1}, then horizontal back to the diagonal" | Path built as (x_n, x_n) → (x_n, x_{n+1}) → (x_{n+1}, x_{n+1}) (e.g. `fixpointaa.jl:30-35`); frames show this | confirmed |
| I3 | "if \|g'(x*)\| < 1, the iteration converges to x* for every starting value close enough to x*" | Standard local convergence theorem (C¹ g, contraction on a neighbourhood) | confirmed |
| I4 | "if \|g'(x*)\| > 1, iterates near x* (other than x* itself) move away from it" | Mean value theorem: \|g(x) − x*\| ≥ q\|x − x*\| with q > 1 near x* | confirmed |
| I5 | "Julia source scripts … are linked under each case" | 6 links, one per case (manifest; index.qmd lines 24, 33, 42, 51, 61, 70) | confirmed |
| C1a | Case 1 heading: g(x) = √(2x), x0 = 0.1 | `fixpointaa.jl:10-11`; frame title and legend "x₀ = 0.1" | confirmed |
| C1b | "intersects y = x at x* = 2" | sympy: fixed points {0, 2} | confirmed (it also meets y = x at 0, but the page does not claim 2 is the only one) |
| C1c | "g'(2) = 1/2 < 1" | sympy: g'(2) = 1/2 | confirmed |
| C1d | "converges from below in a monotone staircase" | iterates 0.1, 0.447, 0.946, … 1.99854, strictly increasing and < 2; e12/e11 = 0.500 | confirmed |
| C1e | Alt text: "starting below the fixed point at x₀ = 0.1" | as above | confirmed |
| C1f | Link/embed are `fixpointaa.jl` / `fixpointaa.gif` | page lines 24 and 26; manifest byte-identical | confirmed |
| C2a | Case 2 heading: g(x) = √(2x), x0 = 4.0 | `fixpointbb.jl:10-11`; frame title | confirmed |
| C2b | "starting above the fixed point. The staircase descends monotonically to x* = 2" | 4.0, 2.828, 2.378, … 2.000339, strictly decreasing and > 2 | confirmed |
| C2c | "confirming convergence from both sides" | C1d and C2b | confirmed |
| C2d | Alt text and link/embed `fixpointbb.*` | page lines 33 and 35 | confirmed |
| C3a | Case 3 heading: g(x) = 8/(x+2), x0 = 4.0 | `fixpointcc.jl:11-12`; frame title | confirmed |
| C3b | "strictly decreasing, with g'(x) = −8/(x+2)², so g'(2) = −1/2" | sympy: fixed points {−4, 2}, g'(2) = −1/2; g' < 0 on x > −2 | confirmed |
| C3c | "\|g'(2)\| = 1/2 < 1, iteration converges" | x12 = 2.0003662; error ratio → −0.5 | confirmed |
| C3d | "the staircase alternates sides of x* on each step" | 4, 1.333, 2.4, 1.818, 2.095, 1.953, …: side alternates every step | confirmed |
| C3e | Heading "Oscillating convergent"; alt text; link/embed `fixpointcc.*` | as above | confirmed |
| C4a | Case 4 heading: g(x) = x²/4 + x/2, x0 = 1.95 | `fixpointdd.jl:11-12`; frame title | confirmed |
| C4b | "crosses y = x at x* = 2 (and again at x = 0)" | sympy: fixed points {0, 2} | confirmed |
| C4c | "it lies below the diagonal for 0 < x < 2" | g(x) − x = x(x − 2)/4 < 0 on (0, 2) | confirmed |
| C4d | "g'(2) = 3/2 > 1" | sympy | confirmed |
| C4e | "walks away from x* = 2 toward the left and converges monotonically to the other fixed point x = 0" | 1.95, 1.9256, 1.8898, … x16 = 0.019332, strictly decreasing and positive; x_{n+1}/x_n → 0.5095 at n = 15 | confirmed |
| C4f | "g'(0) = 1/2" | sympy | confirmed |
| C4g | Alt text: "starting at x₀ = 1.95 just below the repelling fixed point x* = 2; the staircase walks left and converges to the fixed point x = 0" | as above; final frame label "x_16 = 0.0193" | confirmed |
| C4h | Link/embed `fixpointdd.*` | page lines 51 and 53 | confirmed (see F1 for the stem relative to the archive) |
| C5a | Case 5 heading: same g, x0 = 2.03, "Divergent" | `fixpointee.jl:12-13`; frame title | confirmed |
| C5b | "moves monotonically rightward and diverges" | 2.03, 2.0452, … 3.7534, 5.3986, 9.9856, 29.92, 238.8, 1.437e4, 5.17e7, 6.67e14 | confirmed |
| C5c | "showing instability from both sides" | C4e and C5b | confirmed |
| C5d | "The animation stops at x9 ≈ 3.753, the last iterate inside the window" | n_iters = 9; x9 = 3.753371; x10 = 5.398634 > 4 = xlims[2]; last frame label "x_9 = 3.7534" | confirmed |
| C5e | "x12 ≈ 29.92" | mpmath: 29.921011 | confirmed |
| C5f | "x14 ≈ 1.437 × 10⁴" | mpmath: 14373.031 | confirmed |
| C5g | Alt text: "reaches x₉ ≈ 3.753 at the right of the window" | last frame | confirmed |
| C5h | Link/embed `fixpointee.*` | page lines 61 and 63 | confirmed (see F1) |
| C6a | Case 6 heading: g(x) = −x²/4 − x/2 + 4, x0 = 1.97 | `fixpointff.jl:12-13`; frame title | confirmed |
| C6b | "steeply decreasing at x* = 2"; "g'(2) = −3/2, \|g'(2)\| = 3/2 > 1" | sympy: fixed points {−8, 2}, g'(2) = −3/2 | confirmed |
| C6c | "does not converge to x*: the staircase moves away from x* = 2" | \|x_n − 2\|: 0.03, 0.045, 0.068, 0.10, 0.15, 0.22, 0.35, 0.49, 0.80, 1.04, 1.83, … | confirmed |
| C6d | "alternating sides at every step" | side pattern relative to 2 for x0…x32: `-+-+-+…-+-` (strict alternation). Reason: g(x) > 2 ⇔ −4 < x < 2, and every iterate lies in (−4, 4.5) | confirmed |
| C6e | "settles onto a stable 4-cycle (≈ 4.25, −2.64, 3.58, −0.99)" | after 2000 iterations the orbit cycles through 4.2499617, −2.6405244, 3.5771699, −0.98762106. Cycle multiplier ∏g'(c_i) = −0.0305, so it is stable. The 2-cycle {−2, 4} has multiplier −1.25 (unstable), so this is a genuine 4-cycle | confirmed |
| C6f | Heading "Oscillating, does not converge" | as above | confirmed |
| C6g | Alt text: "starting at x₀ = 1.97 just below x* = 2; … alternating sides, and settles onto a 4-cycle" | final frame (x_32 = −0.9909) shows the orbit packed onto the 4 cycle points; distance of x29…x32 to the cycle ≤ 0.0033 | confirmed |
| C6h | Link/embed `fixpointff.*` | page lines 70 and 72 | confirmed |
| K1 | Count: six cases, six animations | 6 scripts, 6 GIFs, 6 embeds (manifest) | confirmed |

No page claim was wrong. There is no separate Description section with method formulas; the method statement is the introduction (I1–I4).

### 3. Implementation checks

All six scripts run the same method: plain fixed-point iteration `xs[i+1] = g(xs[i])` (for example `fixpointaa.jl:20-22`). It has no safeguard or variant, and it is the method named in the title. Each cobweb path is built as (x_n, x_n) → (x_n, x_{n+1}) → (x_{n+1}, x_{n+1}), and frame k draws points 1 to 1 + 2k with the marker at (x_k, x_k). That is the correct staircase.

**Script iterates against the independent computation.** I compared the script's `xs` (from `instr/out.txt`, printed to 8 significant digits) with my mpmath 40-digit iteration (`indep.py`). They agree to all 8 printed digits for every iterate of every case. Representative values:

| Script | Script value | Independent value |
|---|---|---|
| aa | x12 = 1.9985378 | 1.9985378 |
| bb | x12 = 2.0003385 | 2.0003385 |
| cc | x12 = 2.0003662 | 2.0003662 |
| dd | x16 = 0.01933216 | 0.01933216 |
| ee | x9 = 3.753371 | 3.753371 |
| ff | x32 = −0.99088119 | −0.99088119 |

**Reference values.** The scripts do not plot a numeric reference value. The fixed points and derivative values quoted in their comments match the sympy calculation:

| Script(s) | Comment values | sympy |
|---|---|---|
| aa, bb | x* = 2, g'(2) = 1/2 | ✓ |
| cc | g'(2) = −1/2 | ✓ |
| dd, ee | g'(2) = 3/2, g'(0) = 1/2 | ✓ |
| ff | g'(2) = −3/2; 4-cycle ≈ {4.25, −2.64, 3.58, −0.99} | ✓ |

**Rate checks.** Each converging or diverging case moves at the rate set by g'(fixed point):
- aa: e12/e11 = 0.00146/0.00292 ≈ 0.500 = g'(2).
- cc: the ratio of successive errors tends to −0.5.
- dd: x16/x15 = 0.5095, tending to g'(0) = 0.5.
- ee: e1/e0 = 0.045225/0.03 = 1.5075 ≈ g'(2) = 1.5.

**Script comments checked.**

| Script | Comment | Computed | Result |
|---|---|---|---|
| `fixpointdd.jl:13` | "x_16 = 0.0193, all inside the window" | 0.019332 | ✓ |
| `fixpointee.jl:5,14` | "x_9 = 3.7534 … x_10 = 5.3986 would leave it" | 3.75337, 5.39863 | ✓ |
| `fixpointff.jl:14` | "by x_29 … x_32 the orbit is within 0.004 of the 4-cycle" | max distance 0.00326 (x32) | ✓ |
| `fixpointff.jl:16-19` | "min of g on the window is g(4.5) = −3.3125" | −3.3125 | ✓ |
| `fixpointff.jl:16-19` | orbit stays in [−2.639, 4.250], so the legend can go bottom right | drawn orbit x0…x32 lies in [−2.6388, 4.2493] | ✓; the limit-cycle point −2.6405 later falls slightly below −2.639, but it is never drawn and the legend-placement reasoning still holds (not a finding) |

**The picture shows what was computed.** I viewed the contact sheets for all six GIFs and full frames `fixpointaa/frame_013.png` and `fixpointff/frame_033.png`:
- **Titles and labels:** every title names the scripted g and x0.
- **Legend values:** each "x_k = …" legend value equals the computed iterate rounded to 4 decimals. Checks:
  - aa: x_2 0.9457, x_12 1.9985
  - bb: x_4 2.0885
  - cc: x_8 2.0059, x_12 2.0004
  - dd: x_10 0.6199, x_16 0.0193
  - ee: x_5 2.2436, x_9 3.7534
  - ff: x_12 −1.7664, x_30 −2.6388, x_32 −0.9909
- **Geometry:** staircase vertices visibly lie on y = x and on y = g(x). The Case 3 path spirals and the Case 6 path spirals out onto a 4-cycle box pattern, as computed.
- **Frame counts:** n_iters + 1 in each case (13, 13, 13, 17, 10, 33).
- **Display devices:**
  - The scripts contain an off-scale clamping branch (dd, ee, ff), but my instrumented runs show that every drawn iterate lies inside its window (`in-window: true` for all six), so that branch never runs and nothing is drawn clamped.
  - No NaN masking is used.
  - The Case 4 and Case 5 axes, [0, 4]², contain the whole computed path.
  - In Case 6 the window [−4.5, 4.5]² contains the whole drawn orbit, and the bottom-right legend overlaps no curve or path. In frame 33 the parabola at x = 4.5 is at y = −3.31, above the legend box.
- **Cosmetic only (not a finding):** Case 1 frame 0 labels "x₀" with a Unicode subscript, while every other label renders "x_k" with a literal underscore.

**Per-script verdicts.** All six scripts (aa, bb, cc, dd, ee, ff):
- implement plain fixed-point iteration, the method named in the title;
- produce numbers that match the independent computation;
- quote correct reference values in their comments;
- draw pictures faithful to the computation.

