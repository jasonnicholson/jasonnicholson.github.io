# Fixed Point Iteration — animation review (round 2)

Page: `pages/numerical-methods/fixed-point-iteration/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Fidelity, Minor: Cases 4–6 start far from x* = 2, which weakens Mathews' "local divergence" demonstration and pushes Case 5 off-scale after 3 steps

- **Where:** `fixpointdd.jl:12` (`x0 = 1.5`), `fixpointee.jl:13` (`x0 = 2.5`), `fixpointff.jl:13` (`x0 = 1.5`). Page headings lines 46, 55 and 65. No reason for the change is given anywhere on the page.
- **What is there now:** Cases 4, 5 and 6 start at 1.5, 2.5 and 1.5, which are 0.5 away from the repelling fixed point x* = 2.
- **What the archive has:** Mathews' Examples 8, 7 and 9 (`FixedPointMod_gr_390.gif`, `_354.gif`, `_453.gif`) use the same three functions but start at p₀ = 1.95, 2.03 and 1.97, within 0.05 of x* = 2. His solution pages (`lnk_8`, `lnk_9`, `lnk_10`) frame these examples around Theorem (ii): "x* is a repelling fixed point and the iteration exhibits **local** divergence". Starting right next to x* is how the examples show that even a nearby start is pushed away. From p₀ = 2.03 the legacy animation stays inside the [0,4] window for 9 steps (p₉ = 3.75337; I recomputed 3.7533710).
- **Consequence on the page:** With x₀ = 2.5, Case 5 is in the window for only 3 steps. x₃ = 4.5544 already leaves it, so the last two of its five frames show no new geometry, only an off-scale triangle (`fixpointee/frame_004.png`, `frame_005.png`). The page needs a special note about off-scale markers that the legacy start would not need. The off-scale handling itself is honest: the true values are in the legend and the page text.
- **How I know:** I read the formula images (`review/legacy/formulas.png`) and the legacy last frames (`review/legacy/legacy_last_sheet.png`: titles show p₉ = 3.75337, p₁₆ = 0.01933, p₁₀ = 0.17357). My Python recomputation from the legacy starts gives p₉ = 3.7533710 (Example 7), p₁₆ = 0.0193322 (Example 8) and p₁₀ = 0.1735718 (Example 9), which match the legacy titles. From 1.97 the Example 9 orbit also ends on the same 4-cycle {4.24996, −2.64052, 3.57717, −0.98762}.
- **Suggested correction:** Either restore Mathews' starts (Case 4: x₀ = 1.95 with about 16 iterations; Case 5: x₀ = 2.03 with about 9 iterations, all in the window; Case 6: x₀ = 1.97, which needs more iterations to reach the 4-cycle) and update headings, alt text and Behavior numbers, or keep the current starts and add one sentence saying they were moved away from Mathews' near-x* values for visibility. If Case 5 changes, its "x₃ ≈ 4.554 … x₈ ≈ 9.27 × 10⁵" sentence has to be recomputed.
- Not part of this finding: Case 2 (3.8 instead of Mathews' 4.0) and Case 3 (1.0 instead of 4.0) also differ, but they show the same behaviour and nothing is lost. The page also lists Mathews' Examples 7 and 8 in swapped order (its `fixpointdd` is his `Fixpointee` and the reverse). A reader would not notice.

- **Independent check:** not run (Minor finding, unverified)

### F2. Page match, Minor: Case 3 derives g'(2) = −½ from "strictly decreasing", which does not follow

- **Where:** `index.qmd:39`: "The curve $g(x) = \tfrac{8}{x+2}$ is strictly decreasing, so $g'(2) = -\tfrac{1}{2}$."
- **What is there now:** The value is right, but the "so" presents it as a consequence of monotonicity. Monotonicity only gives the sign of g'(2), not its value.
- **What is true:** g'(x) = −8/(x+2)², so g'(2) = −8/16 = −½ (sympy: `g' at fixed points [−4, 2] = [−2, −1/2]`). Being decreasing is what makes the staircase alternate sides.
- **Suggested correction:** "The curve g(x) = 8/(x+2) is strictly decreasing, with g'(x) = −8/(x+2)², so g'(2) = −½."

No Error or Misleading findings. Every number stated on the page and in the frames agrees with my independent computation (ledger below).

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


Two findings: 0 Error, 0 Misleading, 2 Minor.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `fixpointaa.jl` | 0 | 5.6 | fixpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointbb.jl` | 0 | 6.3 | fixpointbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointcc.jl` | 0 | 5.9 | fixpointcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointdd.jl` | 0 | 5.2 | fixpointdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointee.jl` | 0 | 6.0 | fixpointee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `fixpointff.jl` | 0 | 5.8 | fixpointff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `fixpointaa.gif` | 13 | byte-identical | fixpointaa |
| `fixpointbb.gif` | 13 | byte-identical | fixpointbb |
| `fixpointcc.gif` | 13 | byte-identical | fixpointcc |
| `fixpointdd.gif` | 9 | byte-identical | fixpointdd |
| `fixpointee.gif` | 5 | byte-identical | fixpointee |
| `fixpointff.gif` | 17 | byte-identical | fixpointff |

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
| 1 | Intro, l.12–15 | Each animation shows a cobweb: identity line y = x and y = g(x) | All six sheets show green y = x and magenta y = g(x) | confirmed |
| 2 | Intro | "from the current iterate xₙ on the diagonal, vertical to the curve to get g(xₙ) = xₙ₊₁, then horizontal back to the diagonal" | Cobweb vertices printed by instrumented copies, e.g. aa: (0.1,0.1)→(0.1,0.44721)→(0.44721,0.44721)→(0.44721,0.94574)…; same pattern in all six | confirmed |
| 3 | Intro | "Convergence occurs when \|g'(x*)\| < 1" | True as the standard local (sufficient) condition. All four fixed points with \|g'\| < 1 used on the page (x* = 2 in Cases 1–3, x = 0 in Case 4) attract | confirmed (as a local criterion) |
| 4 | Intro l.17 | Julia sources linked under each case | Six links, each to an existing script | confirmed |
| 5 | Case 1 heading | g(x) = √(2x), x₀ = 0.1, convergent staircase | `fixpointaa.jl:10–11`; iterates rise to x₁₂ = 1.99854 | confirmed |
| 6 | Case 1 | intersects y = x at x* = 2 | sympy fixed points [0, 2] | confirmed |
| 7 | Case 1 | g'(2) = ½ < 1 | g'(x) = 1/√(2x), so g'(2) = ½ (sympy) | confirmed |
| 8 | Case 1 | converges from below in a monotone staircase | 0.1, 0.44721, 0.94574, 1.37531, 1.65850, 1.82126, 1.90854, 1.95374, 1.97673, 1.98833, 1.99416, 1.99708, 1.99854: strictly increasing, all < 2 | confirmed |
| 9 | Case 1 alt | starting below the fixed point at x₀ = 0.1 | Frame 1 marker at (0.1, 0.1), legend "x₀ = 0.1" | confirmed |
| 10 | Case 1 wiring | link `fixpointaa.jl`, embed `fixpointaa.gif` | Both match the case. Committed GIF is byte-identical to a fresh run (manifest) | confirmed |
| 11 | Case 2 heading | g(x) = √(2x), x₀ = 3.8 | `fixpointbb.jl:10–11`; title of every frame "x₀ = 3.8" | confirmed |
| 12 | Case 2 | starting above the fixed point; descends monotonically to x* = 2 | 3.8, 2.75681, 2.34811, 2.16708, 2.08186, 2.04052, 2.02016, 2.01005, 2.00502, 2.00251, 2.00125, 2.00063, 2.00031: strictly decreasing, all > 2 | confirmed |
| 13 | Case 2 | "confirming convergence from both sides" | Case 1 converges from below and Case 2 from above | confirmed |
| 14 | Case 2 wiring | `fixpointbb.jl` / `fixpointbb.gif` | match | confirmed |
| 15 | Case 3 heading | g(x) = 8/(x+2), x₀ = 1.0, oscillating convergent | `fixpointcc.jl:11–12`; x₁₂ = 1.99971 | confirmed |
| 16 | Case 3 | strictly decreasing | g'(x) = −8/(x+2)² < 0 | confirmed |
| 17 | Case 3 | "…so g'(2) = −½" | Value correct (sympy −1/2), but it does not follow from "decreasing" | value confirmed; reasoning wrong (F2) |
| 18 | Case 3 | \|g'(2)\| = ½ < 1, iteration converges | x₁₂ = 1.9997070; error ratios tend to −0.5 | confirmed |
| 19 | Case 3 | staircase alternates sides of x* on each step | 1.0, 2.667, 1.714, 2.154, 1.926, 2.038, 1.981, 2.009, 1.995, 2.002, 1.9988, 2.0006, 1.9997: alternates at every step | confirmed |
| 20 | Case 3 alt / wiring | oscillating convergent, x₀ = 1.0; `fixpointcc.*` | Sheet shows a shrinking rectangular spiral; files match | confirmed |
| 21 | Case 4 heading | g(x) = x²/4 + x/2, x₀ = 1.5; repelled from x* = 2, converges to x = 0 | `fixpointdd.jl:11–12`; iterates fall to x₈ = 0.068368 | confirmed |
| 22 | Case 4 | crosses y = x at x* = 2 and again at x = 0 | sympy fixed points [0, 2] | confirmed |
| 23 | Case 4 | lies below the diagonal for 0 < x < 2 | g(x) − x = x(x−2)/4 < 0 on (0,2) | confirmed |
| 24 | Case 4 | g'(2) = 3/2 > 1 | g'(x) = x/2 + ½, so g'(2) = 3/2 | confirmed |
| 25 | Case 4 | walks away from x* = 2 toward the left, converges monotonically to x = 0 | 1.5, 1.3125, 1.08691, 0.83880, 0.59530, 0.38624, 0.23042, 0.12848, 0.06837: strictly decreasing toward 0 | confirmed |
| 26 | Case 4 | g'(0) = ½ | sympy 1/2; ratios x₈/x₇ = 0.532, tending to 0.5 | confirmed |
| 27 | Case 4 alt | starting at x₀ = 1.5 below the repelling x* = 2; walks left; converges to x = 0 | sheet frames 1–9 | confirmed |
| 28 | Case 4 wiring | `fixpointdd.*` | match. Script comment "x_8 = 0.0684" also correct | confirmed |
| 29 | Case 5 heading | divergent, g(x) = x²/4 + x/2, x₀ = 2.5 | `fixpointee.jl:12–13` | confirmed |
| 30 | Case 5 | same function as Case 4 but starting above the fixed point | x₀ = 2.5 > 2 | confirmed |
| 31 | Case 5 | moves monotonically rightward and diverges | 2.5, 2.8125, 3.38379, 4.55440, 7.46284, 17.655, 86.752, 1924.8, 927212: increasing without bound | confirmed |
| 32 | Case 5 | "showing instability from both sides" | Case 4 leaves x* leftward, Case 5 rightward | confirmed |
| 33 | Case 5 | x₃ ≈ 4.554 already leaves the window | x₃ = 4.5544016 > 4 = xmax | confirmed |
| 34 | Case 5 | x₃ and x₄ ≈ 7.463 marked off-scale at the window edge with their true values | x₄ = 7.4628444. Frames 4–5: hollow red triangle at (3.88, 3.88) with "off-scale ↑", legend "x_3 = 4.5544 (off-scale, marker at edge)" and "x_4 = 7.4628 (…)" | confirmed |
| 35 | Case 5 | the sequence keeps growing (x₈ ≈ 9.27 × 10⁵) | x₈ = 927212.28 | confirmed |
| 36 | Case 5 alt / wiring | "from x₃ on the iterates leave the window and are marked off-scale at its edge"; `fixpointee.*` | frames 4, 5; files match | confirmed |
| 37 | Case 6 heading | oscillating, does not converge, g(x) = −x²/4 − x/2 + 4, x₀ = 1.5 | `fixpointff.jl:12–13` | confirmed |
| 38 | Case 6 | steeply decreasing at x* = 2; g'(2) = −3/2, \|g'(2)\| = 3/2 > 1 | g'(x) = −x/2 − ½, so g'(2) = −3/2; x* = 2 is a fixed point (sympy [−8, 2]) | confirmed |
| 39 | Case 6 | does not converge to x*; moves away from x* = 2 | \|xₙ − 2\| = 0.5, 0.69, 1.15, 1.39, 2.58, 2.21, 4.52, …: moves away overall (not strictly monotone) | confirmed |
| 40 | Case 6 | alternating sides at every step | 1.5, 2.69, 0.85, 3.39, −0.58, 4.21, −2.52, 3.67, −1.20, 4.24, −2.61, 3.60, −1.04, 4.25, −2.64, 3.58, −0.99: alternates < 2 / > 2 throughout | confirmed |
| 41 | Case 6 | settles onto a stable 4-cycle (≈ 4.25, −2.64, 3.58, −0.99) | Real roots of g⁴(x) = x that are not fixed points or the 2-cycle {−2, 4}: 4.2499617, −2.6405244, 3.5771699, −0.9876211. Cycle multiplier ∏g' = −0.0305 (\|·\| < 1, stable). The 2-cycle {−2, 4} has multiplier −1.25 and repels. Orbit: x₁₆ = −0.98914, x₄₀ = −0.98762106 | confirmed |
| 42 | Case 6 alt / wiring | moves away from x* = 2, alternating sides, settles onto a 4-cycle; `fixpointff.*` | last frame shows the nested rectangles converging onto the outer 4-cycle box; files match | confirmed |
| 43 | Counts | 6 cases / 6 scripts / 6 GIFs | manifest; frame counts 13, 13, 13, 9, 5, 17 = n_iters + 1 for each script | confirmed |
| 44 | Frames, all | legend iterate values | aa x₂…x₁₂ = 0.9457, 1.6585, 1.9085, 1.9767, 1.9942, 1.9985; bb 2.3481, 2.0819, 2.0202, 2.005, 2.0013, 2.0003; cc 1.7143, 1.9259, 1.9813, 1.9953, 1.9988, 1.9997; dd 1.3125 … 0.0684; ff 0.8506, −0.5764, −2.5234, −1.2018, −2.6139, −1.0373, −2.6397, −0.9891. All agree with `indep.py` to 4 decimals | confirmed |
| 45 | Frames, all | titles name the function and x₀ in the code | aa "g(x) = √(2x)"; bb/cc/dd/ee/ff titles match `g` and `x0` in each script | confirmed |

Leftovers that are not findings: the page has no `## Description` section (missing content). The labels read literally "x_3" while frame 1 of aa reads "x₀" (cosmetic). In `fixpointdd.jl` and `fixpointff.jl` the off-scale branch never runs (harmless dead code).

---

### 3. Implementation checks

All six scripts run the same plain loop, `xs[i+1] = g(xs[i])`. That is fixed-point iteration xₙ₊₁ = g(xₙ), with no safeguards or variants. The cobweb path is (x₀,x₀), then for each n the points (xₙ, xₙ₊₁) and (xₙ₊₁, xₙ₊₁): a vertical step to the curve, then a horizontal step to the diagonal. No script uses a reference "true" value except as page text. The reference fixed points and cycles I checked are listed below.

| Script | Method | Script's numbers vs independent (mpmath, 40 digits) | Reference values | Picture |
|---|---|---|---|---|
| `fixpointaa.jl` | FPI, g = √(2x), x₀ = 0.1, 12 iterations | x₁₂: script 1.9985377748870492, independent 1.99853777489. All 13 iterates agree to ≥ 11 digits | x* = 2, g'(2) = ½ (sympy). Error ratio x₁₂ − 2 / x₁₁ − 2 = 0.5005, consistent with linear rate ½ | Path on the curve and diagonal. Marker at (xₙ, xₙ) with the correct label. Window [0,4]² holds everything. Correct |
| `fixpointbb.jl` | FPI, √(2x), x₀ = 3.8, 12 iterations | x₁₂: 2.000313429774848 vs 2.00031342977 | same as aa | Correct; x₀ = 3.8 visible inside the window |
| `fixpointcc.jl` | FPI, 8/(x+2), x₀ = 1.0, 12 iterations | x₁₂: 1.9997070455544164 vs 1.99970704555 | x* = 2 (other root −4, outside the domain shown), g'(2) = −½ | Spiral of rectangles. Correct |
| `fixpointdd.jl` | FPI, x²/4 + x/2, x₀ = 1.5, 8 iterations | x₈: 0.06836812960908217 vs 0.0683681296091 | fixed points 0 (g' = ½) and 2 (g' = 3/2) | All iterates in the window; off-scale branch unused. Correct |
| `fixpointee.jl` | FPI, x²/4 + x/2, x₀ = 2.5, 4 iterations | x₃ = 4.554401636123657 vs 4.55440163612; x₄ = 7.46284438384329 vs 7.46284438384; x₈ (page only) 927212.28 | as dd | Off-scale display: only the marker is clamped (to (3.88, 3.88) on y = x) and drawn as a hollow triangle. The legend keeps the true values. The path segment to x₃ is clipped at the top edge, and the x₃ → x₄ segment lies wholly outside the window, so frames 4 and 5 differ only in the legend. Honest, and disclosed on the page. See F1 for why so few steps are visible |
| `fixpointff.jl` | FPI, −x²/4 − x/2 + 4, x₀ = 1.5, 16 iterations | x₁₆: −0.9891425065252717 vs −0.989142506525. All 17 iterates agree | fixed points 2 (g' = −3/2) and −8 (g' = 7/2). Repelling 2-cycle {−2, 4}. Attracting 4-cycle {4.24996, −2.64052, 3.57717, −0.98762}, multiplier −0.0305 | Window [−4.5, 4.5]² contains the whole orbit (min −2.640548 at x₁₈, max 4.249971), as the script comment claims. The bottom-right legend covers nothing (frame 17 checked). Correct |

Regeneration: according to the manifest, every committed GIF is byte-identical to a fresh scratch run of its script.

