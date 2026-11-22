# Accelerated & Modified Newton-Raphson — animation review

Page: [`pages/numerical-methods/accelerated-and-modified-newton-raphson/index.qmd`](../../pages/numerical-methods/accelerated-and-modified-newton-raphson/index.qmd) · Scripts: `accnewtonaa.jl`, `accnewtonbb.jl`, `accnewtoncc.jl` · GIFs: 3

**Result:** 0 error, 2 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — Case 2's orange lines are called tangent lines but have half the tangent slope

- **Location:** index.qmd:26, "Each animation below shows the **Newton tangent-line diagram** for three methods". Also index.qmd:44 alt text, "Accelerated Newton-Raphson (m=2) tangent-line animation". The lines are drawn at accnewtonbb.jl:49.
- **Now:** The page presents all three animations as tangent-line diagrams. accnewtonbb.jl draws the segment from (x_n, f(x_n)) to (x_{n+1}, 0), where x_{n+1} = x_n − 2 f/f′. The script's own comment (line 48) calls this the "Effective step".
- **True:** For Method A that segment has slope f′(x_n)/m = f′(x_n)/2, which is half the tangent slope. It is not tangent to f. In frame 2 of the GIF it is clearly a chord that lies above the curve between x ≈ 1.0 and 1.2. Cases 1 and 3 do draw true tangents.
- **Evidence:** `python3 -I reviewer/slopes.py` gives:
  - bb, k=0: drawn slope 0.66, tangent slope 1.32, ratio 0.500000.
  - bb, k=1: drawn slope 0.018237, tangent slope 0.036474, ratio 0.500000.
  - aa and cc: ratio 1.000000 at every step.
  - Visual check: committed/accnewtonbb/frame_002.png.
- **Suggested fix:** Change the page wording for Case 2, for example: "the orange line from (x_n, f(x_n)) has slope f′(x_n)/m, half the tangent slope, so it reaches the axis twice as far as the Newton tangent would". Change the alt text to "accelerated-step animation", or something similar, instead of "tangent-line animation". Optionally, also draw the true tangent in a lighter style so that the doubling of the step can be seen.

- **Independent check:** confirmed. Checker: drawn slope is exactly f′(xₙ)/2 at every step (0.66 vs 1.32 at x₀=1.2).

### F2 — Misleading — Page match — Case 1's explanation says the tangent "crosses zero far from x*", but the frames show it landing halfway to the root

- **Location:** index.qmd:32, "The tangent line at $x_n$ is nearly horizontal near the root, so it crosses zero far from $x^*$ — forcing many iterations to creep toward $x = 1$."
- **Now:** The page explains the slow convergence as the tangent overshooting to a point far from x*.
- **True:** At a double root, both f and f′ are small. The tangent at x_n crosses the axis at about x* + e_n/2, which is closer to the root than x_n and on the same side. Newton is slow here because each step covers only half of the remaining distance. Nothing overshoots or lands far away. The sentence just before this one ("each step only halves the error") is correct, and this sentence contradicts it.
- **Evidence:**
  - `reviewer/indep.py` gives the plain Newton error map e_{n+1} = e/2 + e²/12 + …
  - Script iterates (`julia reviewer/iter_aa.jl`): x0 = 1.2 → x1 = 1.10303 → x2 = 1.052356 → x3 = 1.026401. Every intercept falls between x_n and 1.
  - Ratios e_{n+1}/e_n run 0.515, 0.508, 0.504, … and reach 0.500009 at n = 12.
  - Frames committed/accnewtonaa/frame_002–013 show each blue tangent ending between the previous iterate and x = 1.
- **Suggested fix:** Replace the sentence with: "Near the root f(x) ≈ 3(x−1)², so the tangent at x_n meets the axis only halfway to x* (x_{n+1} − 1 ≈ (x_n − 1)/2). Each step covers half the remaining distance, so many iterations are needed to creep toward x = 1."

- **Independent check:** confirmed. Checker: error ratios 0.515→0.500 (1.2→1.103→1.052); arguably an Error since it contradicts the page's own 'halves the error'.

### F3 — Minor — Page match — Case 3 is said to converge "in just 2 steps", but the GIF shows x₂ = 0.999994 and is no faster than Case 2

- **Location:** index.qmd:50, "shows the tangent lines converging to $x = 1$ in just 2 steps". The alt text at index.qmd:54 says "...to x=1 (double root of f) in 2 steps".
- **Now:** Case 3 is credited with converging in 2 steps. Case 2 (line 40) is described as converging "in just a few steps".
- **True:** After 2 steps of Method B, x₂ = 0.99999427796 (e = −5.7e-6), and the GIF legend shows "x₍2₎ = 0.999994". The 6-digit label first reads 1.0 at x₃ (e ≈ 1e-11). Method A in Case 2 behaves the same way: e₂ = 6.1e-6 and x₃ shows 1.0. Both methods have |C| = 1/6. Visually, both reach the root after 1 to 2 steps. The page's wording therefore suggests that Method B is faster than Method A, and it is not.
- **Evidence:**
  - `julia reviewer/iter_cc.jl` gives x1 = 0.99415204678, x2 = 0.99999427797, x3 = 1.0000000000084 (label 1.0).
  - `julia reviewer/iter_bb.jl` gives x1 = 1.00606060606, x2 = 1.00000610333, x3 = 1.0000000000036.
  - `indep.py` error series: Method A gives e_{n+1} = e²/6 and Method B gives e_{n+1} = −e²/6.
  - Frame committed/accnewtoncc/frame_003.png legend: "x₍2₎ = 0.999994".
- **Suggested fix:** Use the same wording for Cases 2 and 3, for example "reaches x = 1 to six decimals in 3 steps (x₂ = 0.999994)", or say "in a few steps" for both. Optionally, note that Method B approaches the root from below (x₁ = 0.994), while Method A approaches it from above.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `accnewtonaa.jl` | yes | 3.5 | accnewtonaa.gif |
| `accnewtonbb.jl` | yes | 2.9 | accnewtonbb.gif |
| `accnewtoncc.jl` | yes | 3.0 | accnewtoncc.gif |

Committed GIFs byte-identical to their regenerated output: **3 of 3**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | Standard NR "converges quadratically at simple roots but degrades to linear convergence at multiple roots, because f′(x*) = 0" | aa: p_est → 1.0000, e ratio → 0.5 (indep.py); f′(1) = 0 (sympy) | confirmed |
| 2 | 14–15 | Method A: x_{n+1} = x_n − m·f/f′ | accnewtonbb.jl:29 is exactly this with m = 2 | confirmed |
| 3 | 16 | "recovers the quadratic rate. It requires knowing m in advance" | bb: p_est 1.97, 2.00, 2.00; e_{n+1}/e_n² → 0.166667; m is hard-coded | confirmed |
| 4 | 18 | multiplicity-m root of f ⇒ h = f/f′ has a simple root at x* | for this f: h = (x−1)(x+2)/(3(x+1)), h′(1) = 1/2 ≠ 0 (sympy) | confirmed |
| 5 | 19 | Method B formula x − f f′/(f′² − f f″) | sympy: x − h/h′ − (page formula) simplifies to 0; accnewtoncc.jl:22–28 implements it | confirmed |
| 6 | 20 | "also converges quadratically, without knowing m" | cc: p_est 1.96, 2.00, 2.00; e_{n+1}/e_n² → −0.166667; no m in code | confirmed |
| 7 | 22 | requires f smooth and x0 close enough | standard local-convergence hypothesis; consistent with the runs (not specific to them) | confirmed |
| 8 | 26 | "shows the Newton tangent-line diagram for three methods" | Case 2 lines have exactly half the tangent slope (slopes.py) | wrong (→ F1) |
| 9 | 26 | "applied to the same double root" | all three use f = x³−3x+2 at x* = 1, x0 = 1.2 | confirmed |
| 10 | 26 | "the line from (x_n, f(x_n)) to the x-axis intercept traces the next approximation x_{n+1}" | aa:47, bb:49, cc:63 (with h) draw exactly this segment | confirmed |
| 11 | 26 | "Cases 1 and 2 both plot f(x); Case 3 plots h(x) = f(x)/f′(x)" | aa:40, bb:42 plot f; cc:56 plots h_plot; frames agree | confirmed |
| 12 | 26 | h "has a simple root where f has a double root" | h′(1) = 1/2 | confirmed |
| 13 | 28 | Julia sources linked under each case | lines 34, 42, 52 | confirmed |
| 14 | 30 | Case 1: Standard NR, linear convergence, f = x³−3x+2, x0 = 1.2 | aa:11, 15, 27; p → 1 | confirmed |
| 15 | 32 | f = (x−1)²(x+2), double root at x* = 1 | sympy factor; roots {1: 2, −2: 1} | confirmed |
| 16 | 32 | "asymptotic error constant is (m−1)/m = 1/2, meaning each step only halves the error" | ratios 0.515152 → 0.500009 (n = 12); series e/2 + e²/12 | confirmed |
| 17 | 32 | "tangent line … nearly horizontal near the root, so it crosses zero far from x*" | intercept at ≈ x* + e_n/2, between x_n and x* | wrong (→ F2) |
| 18 | 32 | "forcing many iterations to creep toward x = 1" | after 12 iterations e = 5.2e-5 | confirmed |
| 19 | 34, 36 | Case 1 link → accnewtonaa.jl, embed → accnewtonaa.gif | manifest: GIF byte-identical to the script's output; parameters match the heading | confirmed |
| 20 | 36 | alt: "Standard Newton-Raphson tangent-line animation on f(x)=x³−3x+2: slow linear convergence from x₀=1.2 toward the double root at x=1 over 12 iterations" | n_iters = 12, 13 frames, true tangents (slope ratio 1.000000), last label x₍12₎ = 1.000052 | confirmed |
| 21 | 38 | Case 2: Accelerated (Method A, m = 2), quadratic, same f, x0 = 1.2 | bb:12, 16, 18, 29 | confirmed |
| 22 | 40 | "with m = 2 enlarges each Newton step by the known multiplicity" | drawn step = 2 × Newton step (slope ratio 0.5 exactly) | confirmed |
| 23 | 40 | "restores quadratic convergence: \|e_{n+1}\| ≈ C\|e_n\|²" | e_{n+1}/e_n² = 0.1515, 0.1662, 0.166666 → C = 1/6 (series e²/6) | confirmed |
| 24 | 40 | "The same function and starting point as Case 1 now converges in just a few steps" | x3 = 1 + 3.6e-12 (Float64); label 1.0 from frame x₍3₎ | confirmed |
| 25 | 40 | "Requires knowing m in advance" | m = 2 hard-coded at bb:18 | confirmed |
| 26 | 42, 44 | Case 2 link → accnewtonbb.jl, embed → accnewtonbb.gif | manifest identical; parameters match | confirmed |
| 27 | 44 | alt: "…tangent-line animation…" | the lines are not tangent | wrong (→ F1) |
| 28 | 44 | alt: "quadratic convergence from x₀=1.2 to the double root at x=1 in a few steps" | as in #23–24 | confirmed |
| 29 | 46 | Case 3: Modified NR (Method B), quadratic, f = x³−3x+2, x0 = 1.2 | cc:14–16, 31, 43 | confirmed |
| 30 | 48 | "At a double root of f, h has a simple root — so standard Newton on h gives quadratic convergence" | h′(1) = 1/2; p_est → 2 | confirmed |
| 31 | 49–50 | formula "implements Newton on h(x) using f, f′, and f″ directly" | cc:22–28; sympy equality with x − h/h′ | confirmed |
| 32 | 50 | "The animation plots h(x) = (x−1)(x+2)/(3(x+1))" | cc:19; sympy: equals f/f′ | confirmed |
| 33 | 50 | "shows the tangent lines converging to x = 1" | drawn slope / h′(x_n) = 1.000000 at k = 0, 1 | confirmed |
| 34 | 50 | "in just 2 steps" | x₂ = 0.999994 (legend); same rate as Case 2 | wrong (→ F3) |
| 35 | 50 | "Does not require knowing m" | no m in accnewtoncc.jl | confirmed |
| 36 | 52, 54 | Case 3 link → accnewtoncc.jl, embed → accnewtoncc.gif | manifest identical; parameters match | confirmed |
| 37 | 54 | alt: "Modified Newton-Raphson (Method B) tangent-line animation on h(x)=f(x)/f'(x): quadratic convergence from x₀=1.2 to x=1 … without knowing the multiplicity" | as above | confirmed |
| 38 | 54 | alt: "in 2 steps" | x₂ = 0.999994 | wrong (→ F3) |

## Implementation checks

### accnewtonaa.jl
- **Method:** Plain Newton, x − f/f′ (line 27), with f′ = 3x² − 3, which is correct. This is the "standard" method the heading names.
- **Multiplicity:** sympy gives f = (x−1)²(x+2), f(1) = f′(1) = 0, f″(1) = 6 ≠ 0. So x = 1 is a double root and x = −2 is a simple root.
- **Numbers (script Float64 vs mpmath 60 digits):**

  | n | script | mpmath |
  |---|---|---|
  | 1 | 1.1030303030303028 | 1.103030303030303 |
  | 2 | 1.0523564171979161 | 1.0523564171979158 |
  | 6 | 1.0033253746264617 | 1.0033253746264589 |
  | 12 | 1.0000520156500807 | 1.0000520156497739 |

  They agree to about 1e-15 throughout.
- **Empirical order:** p_est = 1.0206, 1.0114, …, 1.0000. e_{n+1}/e_n → 0.500009, which matches the series e/2 + e²/12.
- **Reference values:** The title's "double root at x=1" is confirmed.
- **Picture:** I looked at frames 1, 2, 3, 13 (and the sheet). The blue segment (xn, f(xn)) → (xn+1, 0) is the true tangent (slope ratio 1.000000). The vertical drop to f(x_{n+1}) is correct, and the legend index and value match the iterate. The title matches the code.
- **Observation (not a finding):** With ylims (−0.05, 1.0), the iterates after about x₅ (e < 0.007, under 3 px) cannot be told apart in the picture. Frames 7–13 differ only in the legend value, so the slow "creep" can be read only from the legend.

### accnewtonbb.jl
- **Method:** Accelerated Newton, x − m f/f′ with m = 2 (line 29). This matches Method A.
- **Numbers (script vs mpmath):**

  | n | script | mpmath |
  |---|---|---|
  | 1 | 1.0060606060606054 | 1.0060606060606061 |
  | 2 | 1.0000061033293672 | 1.0000061033293662 |
  | 3 | 1 + 3.607e-12 | 1 + 6.208e-12 |

  After x₃ the script stalls (x4 = x5 = x3). The difference at x₃ is the expected Float64 floor for a double root: f = x³ − 3x + 2 cancels to about 1e-16 absolute near x = 1, and dividing by f′ ≈ 4e-5 gives an x error of about 1e-11. It is invisible at the 6-digit legend precision (label 1.0).
- **Empirical order:** p_est = 1.97, 2.00, 2.00. e_{n+1}/e_n² → 0.166667 = 1/6, which matches the sympy series e²/6.
- **Reference values:** x* = 1 is confirmed.
- **Picture:** I looked at frame 2 at full size and frames 1–6 on the sheet. The orange segment is the effective step, with slope exactly f′/2. It is not a tangent (→ F1). The legend values match the iterates, and the title matches the code.

### accnewtoncc.jl
- **Method:** Newton applied to h = f/f′, written as x − f f′/(f′² − f f″) (lines 22–28). f″ = 6x is correct. sympy confirms that this equals x − h/h′, so it is Method B.
- **Numbers (script vs mpmath):**

  | n | script | mpmath |
  |---|---|---|
  | 1 | 0.99415204678362468 | 0.99415204678362573 |
  | 2 | 0.99999427796503726 | 0.99999427796501548 |
  | 3 | 1 + 8.37e-12 | 1 − 5.46e-12 |

  At x₃ the script and the exact value differ in sign. This is the same Float64 cancellation floor (about 1e-11) and is invisible at 6 digits. After that, x4 = x3.
- **Empirical order:** p_est = 1.96, 2.00, 2.00. e_{n+1}/e_n² → −0.166667, which matches the series −e²/6. The first step overshoots below the root (x1 = 0.994).
- **Reference values:** The plotted h_plot = (x−1)(x+2)/(3(x+1)) is identical to f/f′ (sympy). Its pole at x = −1 lies outside xlims (0.5, 2.0), and h′(1) = 1/2.
- **Picture:** I looked at frame 3 at full size and frames 1–5 on the sheet. The segment (xn, h(xn)) → (xn+1, 0) is the true tangent to h (slope ratio 1.000000). Because h is nearly linear on [0.99, 1.2], the steelblue tangents lie almost on top of the green curve and are hard to see. That is correct geometry, not an error. The legend reads x₍2₎ = 0.999994 and x₍3₎ = 1.0 (→ F3). The title matches the code.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/accelerated-and-modified-newton-raphson/`](evidence/accelerated-and-modified-newton-raphson/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
