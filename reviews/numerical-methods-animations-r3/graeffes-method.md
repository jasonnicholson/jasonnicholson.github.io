# Graeffe's Method — animation review (round 3)

Page: `pages/numerical-methods/graeffes-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Page match, Minor: "the error roughly squares at each step" fails for r₂ in the first steps of Case 1
- **Location:** `index.qmd`, Case 1 Behavior: "All four estimates converge **quadratically** — the error roughly squares at each step …"
- **What is there now:** The sentence says the error squares at every step, for all four estimates.
- **What is true:** The estimates do converge quadratically in the limit, and from m ≈ 3 on each error is roughly the square of the one before (within a factor of about 2–5). In the first steps, r₂ (|r₂| = 3) does the opposite. Its error **grows** from m = 1 to m = 2 and then falls by only a factor of 3:

  | m | r₂ estimate | error |
  |---|---|---|
  | 1 | 3.0166206257996712 | +0.0166 |
  | 2 | 2.9409170813408397 | −0.0591 |
  | 3 | 2.9787825755126738 | −0.0212 |
  | 4 | 2.9984158052786656 | −0.00158 |
  | 5 | 2.9999908003675412 | −9.2e−6 |

  The m = 1 value is accidentally close, because two correction terms of opposite sign cancel. The page sentence and the r₁ errors (1.48 → 0.338 → 0.0498) describe the asymptotic regime, not "each step". Case 2 shows the same early irregularity: the r₄ error goes 0.111 → 0.133 from m = 0 to 1, and the r₃ error goes 0.00532 → 0.000647 from m = 2 to 3, where squaring would give 2.8e−5. That sentence ("converge quadratically as usual") does not say "each step", so it is fine.
- **How I know:** I ran `julia review/graeffesaa_instr.jl` and `/usr/bin/python3 -I review/indep.py`. The two agree to all printed digits; the values above come from `indep.out`.
- **Suggested correction:** "All four estimates converge quadratically: once the roots are separated (from about m = 3 here), the error roughly squares at each step …". Or add: "(the r₂ estimate is accidentally close at m = 1 and briefly moves away before converging)."

- **Independent check:** not run (Minor finding, unverified)

### F2. Page match / display, Minor: in Case 2, the r₂ trace has the same dashed steelblue style as the true-value line at 5
- **Location:** `graeffesab.jl` lines 48–49 (`colors[2] = :steelblue`, `linestyles[2] = :dash`) and lines 63–65 (dashed steelblue `hline!` at 5). Page intro: "Dashed horizontal lines mark the true root magnitudes; colored traces show the estimates …"
- **What is there now:** The r₂ estimate trace is drawn dashed in steelblue, the same color and line style as the reference line at |r| = 5. From about m = 5 on (r₂ = 4.893, 4.946, …), the r₂ trace lies on that reference line and the two cannot be told apart. Only the diamond markers distinguish them (frames 6–11 of `committed/graeffesab/`).
- **What is true:** The plotted values are correct. But the page's stated key, "dashed = true value", is broken by one of the traces, and that trace merges with the reference exactly where the page asks the reader to watch the slow approach to 5.
- **How I know:** I read the plotting code and viewed `committed/graeffesab/frame_011.png` and `sheet.png`.
- **Suggested correction:** Draw r₂ as a solid line, or as a dotted line, or in a second blue shade, keeping the diamond markers. Alternatively, draw the reference at 5 in gray.

No other discrepancies found.

---

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


Summary: **0 Error, 0 Misleading, 2 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `graeffesaa.jl` | 0 | 6.7 | graeffesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `graeffesab.jl` | 0 | 6.6 | graeffesab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `graeffesaa.gif` | 9 | byte-identical | graeffesaa |
| `graeffesab.gif` | 11 | byte-identical | graeffesab |

### Page references

- Scripts linked: `graeffesaa.jl`, `graeffesab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description, Root Squaring | p₁(x) = (−1)ⁿ p(√x) p(−√x) has roots rₖ² | Algebra: p(√x)p(−√x) = a_n² ∏(r_i² − x) = (−1)ⁿ a_n² ∏(x − r_i²). Symbolic check in `indep.py` gives [1, −30, 273, −820, 576] and [1, −55, 879, −3325, 2500], identical to the script's p₁ | confirmed |
| D2 | Description | Applying it m times gives roots r^(2^m) | `indep.py` builds p_m from r^(2^m) directly; the coefficients equal the script's recurrence output (estimates agree to 17 digits at every m) | confirmed |
| D3 | Description, Separated Root Theorem | \|r_k\|^(2^m) ≈ \|c_{n−k}/c_{n−k+1}\|, c_j the coefficient of x^j | Vieta: c_{n−k}/c_n = ±e_k ≈ ±(r₁…r_k)^(2^m). The script's `c[k+1]/c[k]` (highest degree first) is exactly c_{n−k}/c_{n−k+1} | confirmed |
| D4 | Description | \|r_k\| ≈ \|c_{n−k}/c_{n−k+1}\|^(1/2^m) | Script line 37 / 34 | confirmed |
| D5 | Description | Sign chosen by checking which of p(±\|r_k\|) is nearly zero | Standard; Mathews gr_165 does the same. Not implemented in the scripts, and the page does not say it is | confirmed (as a description) |
| D6 | Convergence | For real roots of distinct magnitudes, error decreases quadratically; digits roughly double | Case 1 errors for r₁: 0.0498, 0.0025, 1.26e−5, 6.31e−10, 3.18e−18, 1.62e−34 | confirmed (asymptotically) |
| D7 | Convergence | Coefficients grow doubly exponentially; \|c_{n−k}/c_n\| ≈ (\|r₁\|…\|r_k\|)^(2^m) | max\|c\| Case 1: 1.11e11, 1.21e22, 1.47e44, 2.16e88, 4.65e176, 2.16e353 (log doubles each step) | confirmed |
| D8 | Convergence | "Most software cannot apply more than a handful of iterations before overflow" | Float64 overflows at m = 8 for both cases (`float64_overflow.py`) | confirmed for these examples |
| D9 | Convergence | Double roots, complex pairs and equal-magnitude roots need modified formulas | Case 2 shows a plain ratio converging only linearly for the double root; Mathews gives a modified formula | confirmed |
| A1 | Animations intro | Shows the separated-root estimates over m = 0, 1, 2, … | Frames: Case 1 has 9 frames (m = 0..8), Case 2 has 11 (m = 0..10); each frame adds one iteration | confirmed |
| A2 | Animations intro | Dashed horizontal lines mark true magnitudes; colored traces show estimates | True: hlines are dashed. However, the Case 2 r₂ trace is also dashed, in the same color (F2) | confirmed, see F2 |
| A3 | Animations intro | Scripts square coefficients in exact integer arithmetic | `big.(…)`, `Vector{BigInt}` | confirmed |
| A4 | Animations intro | In double precision they overflow at m = 8 | `float64_overflow.py`: first non-finite at m = 8 in both cases; max\|c\| of p₇ = 4.65e176 and 2.94e217 (< 1.8e308) | confirmed |
| A5 | Animations intro | Largest coefficient of p₈ ≈ 2.2 × 10^353 (Case 1) | Exact: 2.16e353 | confirmed |
| A6 | Animations intro | … and 8.6 × 10^434 (Case 2) | Exact: 8.64e434 | confirmed |
| C1-1 | Case 1 heading | f(x) = (x+1)(x−2)(x+3)(x−4) | sympy expansion = [1, −2, −13, 14, 24] = script `c0`; matches the GIF title | confirmed |
| C1-2 | Case 1 heading | True \|r_k\| ∈ {1, 2, 3, 4} | Roots −1, 2, −3, 4 | confirmed |
| C1-3 | Case 1 Behavior | All four estimates converge quadratically | Errors at m = 8: 1.6e−34, −1.2e−34, −6.5e−48, ~0; asymptotic error ratios ≈ e² | confirmed |
| C1-4 | Case 1 Behavior | "the error roughly squares at each step" | Holds from m ≈ 3; r₂ error grows from m = 1 to m = 2 (0.0166 → 0.0591) | wrong in early steps (F1, Minor) |
| C1-5 | Case 1 Behavior | because \|r_k/r_{k+1}\|^(2^m) → ∞ doubly exponentially | (4/3)^(2^m) = 1.78, 3.16, 9.99, 99.8, 9966 for m = 1..5 | confirmed |
| C1-6 | Case 1 Behavior | Roots initially close, \|r₁\|/\|r₂\| = 4/3 | 4/3 is the smallest adjacent ratio (3/2 and 2 are the others) | confirmed |
| C1-7 | Case 1 Behavior | A few squaring steps separate them | By m = 4 all estimates are within 2.5e−3; by m = 5 within 1.3e−5 | confirmed |
| C1-8 | Case 1 link/embed | `graeffesaa.jl` / `graeffesaa.gif` are Case 1 | Script polynomial and title match the heading; GIF is byte-identical to a regenerated run | confirmed |
| C1-9 | Case 1 alt text | Four distinct real roots −3, −1, 2, 4 | Roots of c0 | confirmed |
| C1-10 | Case 1 alt text | Each colored trace moves from its initial poor approximation onto the dashed true-value line | m = 0 estimates {2.0, 6.5, 1.077, 1.714} are far off; final frame shows all on the lines | confirmed |
| C2-1 | Case 2 heading | f(x) = (x−1)(x+2)(x−5)² | Expansion = [1, −9, 13, 45, −50] = script `c0`; matches the GIF title | confirmed |
| C2-2 | Case 2 heading | Repeated real root at x = 5; true \|r_k\| ∈ {1, 2, 5, 5} | Roots 1, −2, 5, 5 | confirmed |
| C2-3 | Case 2 Behavior | Two estimates for the double root converge linearly, error halved each iteration | r₁ errors 2.42, 0.966, 0.453, 0.221, 0.109, 0.0544, 0.0271, 0.0136, 0.00677, 0.00339 (ratios 0.40, 0.47, 0.49, 0.495, … → 0.5). r₂ errors −1.0, −0.754, −0.414, −0.212, −0.107, … (→ 0.5). Theory: estimates ≈ 5·2^(±1/2^m), error ≈ 5 ln2 / 2^m | confirmed |
| C2-4 | Case 2 Behavior | Reason: the separated-root condition is never satisfied for equal magnitudes | (5/5)^(2^m) = 1 for all m | confirmed |
| C2-5 | Case 2 Behavior | Simple roots \|r\| = 1, 2 converge quadratically | r₃ errors 6.5e−4, 1.8e−6, 1.45e−11, 1.7e−21; r₄ errors 4.9e−4, 9.5e−7, 7.3e−12, 8.5e−22 | confirmed (asymptotically) |
| C2-6 | Case 2 Behavior | The contrast in rate is the diagnostic signature of equal-magnitude roots | Consistent with computed rates and with Mathews Example 6 | confirmed |
| C2-7 | Case 2 link/embed | `graeffesab.jl` / `graeffesab.gif` are Case 2 | Script polynomial and title match the heading; GIF is byte-identical to a regenerated run | confirmed |
| C2-8 | Case 2 alt text | Double root at x = 5, simple roots at x = 1 and x = −2 | Roots | confirmed |
| C2-9 | Case 2 alt text | Two blue traces for the double root approach the dashed line at 5 slowly | Both steelblue; values above/below 5 shrinking by half per step (frames 1–11) | confirmed |
| C2-10 | Case 2 alt text | Crimson and orange traces for the simple roots converge rapidly | colors[3] = crimson (\|r\| = 2), colors[4] = darkorange (\|r\| = 1); both visually on target by m = 2 | confirmed |
| C2-11 | GIF annotation (last frame) | "r₁, r₂: linear convergence (double root) / r₃, r₄: quadratic convergence" | As C2-3 and C2-5 | confirmed |
| C2-12 | GIF legend | r₁, r₂ (\|r\| = 5, double), r₃ (\|r₃\| = 2), r₄ (\|r₄\| = 1) | Matches the descending order of the estimates (index k is the k-th largest) | confirmed |

---

### 3. Implementation checks

### `graeffesaa.jl` (Case 1)
- **Method:** This is the classical Graeffe root-squaring method (Dandelin–Lobachevsky–Graeffe) followed by separated-root coefficient ratios. The step computes q(t) = E(t)² − t·O(t)², with E and O the even and odd parts. I expanded this by hand: d4 = c4², d3 = 2c4c2 − c3², d2 = c2² + 2c4c0 − 2c3c1, d1 = 2c2c0 − c1², d0 = c0². This is exactly (−1)⁴ p(√t) p(−√t), the page's definition. The variant keeps the alternating signs (monic ∏(x − r_i^(2^m))) rather than Mathews' sign-normalised tableau; magnitudes are identical. Only the magnitudes are animated; no sign determination is done, and the page does not claim it is.
- **Numbers:** The script and the independent computation agree to all 16–17 printed digits at every m = 0..8. Selected values:

  | m | script r₁..r₄ | independent (mpmath) |
  |---|---|---|
  | 0 | 2.0, 6.5, 1.0769230769230769, 1.7142857142857142 | 2.0, 6.5, 1.0769230769230769, 1.7142857142857143 |
  | 1 | 5.477225575051661, 3.0166206257996713, 1.7331079030640313, 0.8381163549234938 | 5.4772255750516611, 3.0166206257996712, 1.7331079030640313, 0.83811635492349384 |
  | 3 | 4.049792933038036, 2.978782575512674, 1.9904915114555508, 0.9994919230375753 | 4.0497929330380366, 2.9787825755126738, 1.9904915114555507, 0.99949192303757528 |
  | 6 | 4.000000000630668, 2.9999999995272506, 1.9999999999998321, 1.0 | 4.0000000006306681, 2.9999999995272507, 1.9999999999998321, 1.0 |
  | 8 | 4.0, 3.0, 2.0, 1.0 | errors 1.6e−34, −1.2e−34, −6.5e−48, 0 |

  The m = 6 values also match Mathews' published output to every digit shown. BigInt/BigInt division gives a 256-bit BigFloat, so there is no precision loss in the ratios.
- **Reference values:** The true magnitudes [4, 3, 2, 1] follow from the factored form; the sympy expansion equals `c0`.
- **Picture:** Frames 1, 3, 5 and 9 show the traces at exactly the printed values (e.g. 5.48 and 4.34 for r₁ at m = 1, 2; the r₂ dip to 2.94 at m = 2). The dashed lines are at 4, 3, 2, 1 in the matching colours. The title function and m index agree with the code and the frame. The y-range [0, 7] contains every value (max 6.5); there is no clamping or masking.

### `graeffesab.jl` (Case 2)
- **Method:** The squaring step is identical to Case 1 (verified as above) and so are the estimates.
- **Numbers:** The script and the independent computation agree at every m = 0..10. Examples: m = 0: 9.0, 1.4444…, 3.4615…, 1.1111…; m = 2: 5.966149802101467 vs 5.9661498021014669, 4.2462095418485495 vs …499, 2.0053176215168587 vs …586; m = 10: 5.003385653465331 / 4.996616637513254 vs 5.0033856534653318 / 4.9966166375132538. The double-root estimates follow 5·2^(1/2^m) and 5·2^(−1/2^m) asymptotically (e.g. m = 10: 5·2^(1/1024) = 5.003386, 5·2^(−1/1024) = 4.996618).
- **Reference values:** The true magnitudes [5, 5, 2, 1] are correct for (x−1)(x+2)(x−5)²; the expansion equals `c0`.
- **Picture:** The traces match the printed values. The y-range [0, 9.5] contains the maximum of 9.0, and there is no clamping. The annotation appears only on the last frame, as coded, and does not overlap the legend or the traces. The x-axis ticks are labelled 0, 2.5, 5.0, 7.5, 10.0 for an integer iteration count; this is cosmetic and not reported. The r₂ trace has the same style as the reference line (F2).

### Script comments
- `graeffesaa.jl` l.11–12: "largest coefficient of p₈ is ≈ (4·3·2)^256 ≈ 2.2e353 … Float64 would give Inf/NaN at m = 8". Confirmed (2.16e353; first non-finite at m = 8).
- `graeffesab.jl` l.12–13: "≈ (5·5·2)^256 ≈ 8.6e434 … Inf/NaN from m = 8 on". Confirmed (8.64e434; first non-finite at m = 8).
- `graeffesab.jl` l.5: "double root at x = 5 causes linear convergence; simple roots converge quadratically". Confirmed.

