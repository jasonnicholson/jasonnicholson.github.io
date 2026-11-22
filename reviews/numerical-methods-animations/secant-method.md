# Secant Method — animation review

Page: [`pages/numerical-methods/secant-method/index.qmd`](../../pages/numerical-methods/secant-method/index.qmd) · Scripts: `secantmethodaa.jl`, `secantmethodbb.jl`, `secantmethodcc.jl`, `secantmethoddd.jl`, `secantmethodee.jl`, `secantmethodff.jl` · GIFs: 6

**Result:** 1 error, 1 misleading, 4 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Case 1 gives the wrong root (0.456 is the first iterate p2, not the root)

- **Location:** index.qmd:18, "The secant method converges quickly to the root near $x \approx 0.456$. … so the secant line immediately produces a good approximation." Also the alt text at index.qmd:22, "x-intercept converges rapidly to the root near x=0.456".
- **Now:** The page puts the root of $3e^x-4\cos x$ near 0.456.
- **True:** The root is x = 0.254850059 (f(0.254850059) = 0, and the function is strictly increasing on [0,1] because f' = 3e^x + 4 sin x > 0, so this is the only root in the plotted window). The value 0.45575 is p2, the x-intercept of the first secant line. At that point f(0.45575) = 1.140, which is not near zero. The GIF's own legend shows "p2 = 0.45575" in frame 1 and "p10 = 0.25485" in frame 9, and the magenta curve visibly crosses the axis at about 0.25. The phrase "immediately produces a good approximation" comes from the same confusion: the first step leaves an error of 0.20 (79% of the root's value), and the iterates first come within 0.01 of the root at p4.
- **Evidence:** `indep.py` gives root = 0.25485005902885, p2 = 0.45575075416314564 (err 0.2009), p3 = 0.3207 (err 0.066), p4 = 0.26376 (err 0.0089), p5 = 0.255294, p8 = 0.25485005902885. `print_aa.jl` matches to the last digit: p2 = 0.45575075416314531, p9 = 0.25485005902885027.
- **Suggested fix:** Line 18: "…converges quickly to the root near $x \approx 0.2549$… The first secant step lands at $p_2 \approx 0.456$, and each later step roughly squares the error (order ≈ 1.618)." Line 22 alt text: replace "near x=0.456" with "near x=0.2549".

- **Independent check:** confirmed.

### F2 — Misleading — Page match — Case 6 says it illustrates order ≈ 1.618, but for arctan at its root the order is 2

- **Location:** index.qmd:58, "illustrating that the secant method converges super-linearly (order $\approx 1.618$) when the starting points are in the basin of convergence."
- **Now:** The page presents this case as an illustration of the golden-ratio order.
- **True:** The order 1.618 applies to a simple root with f''(r) ≠ 0. For arctan, f''(0) = 0. The error recurrence then becomes e_{n+1} ≈ C e_n e_{n-1}(e_n + e_{n-1}), and the asymptotic order is 2. The convergence is still super-linear, so that part of the sentence is right, but this case does not show 1.618. Across the six frames the per-step order estimates are erratic (0.08, 29.6, 0.86, 3.33) and show neither rate. Case 3 uses the same function and behaves the same way.
- **Evidence:** `order_atan.py` (p0 = 1.60, p1 = 1.50, 3000 digits) gives these successive order estimates: 0.084, 29.56, 0.858, 3.33, 1.60, 2.25, 1.889, 2.059, 1.971, 2.014, 1.993, 2.004. log10|e_n| runs −4.28, −7.00, −16.0, −30.5, −63.1, −124.5, −251.1, −500.7, −1003, −2005, so the exponent roughly doubles at each step.
- **Suggested fix:** Either drop the number ("…illustrating the secant method's super-linear convergence once the iterates are near the root") or state it correctly ("…super-linearly; because $f''(0)=0$ for arctan, the order here is actually 2 rather than the generic ≈ 1.618").

- **Independent check:** confirmed. Checker: e_{n+1}/(e_n·e_{n−1}²) settles at exactly 1/3 and order estimates head to 2; the frame labels round to 0.0 by p6–p7 so no rate is visible.

### F3 — Minor — Page match — Case 2 gives a backwards reason for the slow convergence

- **Location:** index.qmd:26, "the double root causes the denominator $f(p_n) - f(p_{n-1})$ to shrink, giving small steps that creep toward the root over many iterations."
- **Now:** The page attributes the small steps to the shrinking denominator.
- **True:** Taken alone, a smaller denominator makes the step *larger*. The denominator also shrinks near a simple root. The real cause is that f ≈ 25e² near the double root. For this exact quadratic the secant update reduces to e_{n+1} = e_n e_{n-1}/(e_n + e_{n-1}). That recurrence converges only linearly, with ratio e_{n+1}/e_n → (√5−1)/2 ≈ 0.618, so each step removes only about 38% of the remaining error. The claims that the convergence is slow and creeping, and the "linear convergence" in the alt text, are correct.
- **Evidence:** `indep.py` gives the Case 2 error ratios e_n/e_{n-1} for n = 2 … 8 of 0.533, 0.652, 0.605, 0.623, 0.616, 0.619, 0.618, … then 0.61803 constant from p12 to p30, with order estimates of 1.000. `print_bb.jl` matches (p29 = 0.20000088348568937 vs mpmath 0.20000088348853019; the difference is float rounding on a near-double root, about 3e-12).
- **Suggested fix:** "…converges, but only linearly: near a double root $f$ behaves like $c(x-0.2)^2$, and each secant step cuts the error by a factor of only about $0.618$, so the iterates creep toward the root over many iterations."

- **Independent check:** not run (minor finding, unverified).

### F4 — Minor — Implementation — Case 4 draws p3 and p9 at a clamped y = −5, off the secant line that is supposed to pass through them

- **Location:** secantmethoddd.jl:68-70 (gray history) and 97-100 (current points), where `clamp(fa/fb, ylims...)` is applied with `ylims = (-5.0, 32.0)` (line 17).
- **Now:** f(p3) = f(−3) = −21 and f(p9) = f(−3.0342) = −21.90, but both points are drawn at y = −5 in the bottom-left corner. In frames 3, 4, 9 and 10 the dark-blue or blue dot labelled p3 or p9 sits at (−3, −5), while the secant line through it (computed correctly from the true values) leaves the bottom of the box at x ≈ −0.63 (frame 3) or x ≈ −1.72 (frame 9). On screen, the line visibly misses one of the two points it is said to pass through. After that the gray history dots keep showing the two points at y = −5, off the curve.
- **True:** The secant lines are computed correctly. Only the marker positions are clamped, so the picture contradicts the construction the page describes at index.qmd:12.
- **Evidence:** `print_dd.jl` gives p3 = −3 (f = −21) and p9 = −3.0342275767851379 (f = −21.9005). Frames `committed/secantmethoddd/frame_003.png` and `frame_010.png` show the dot at the corner with the secant line elsewhere. `line_dd.jl` confirms that the true line passes through (p_k, f(p_k)) to a relative residual of 4e-16.
- **Suggested fix:** Widen the y-range to include −22, for example `ylims = (-25.0, 32.0)`. Alternatively, skip the markers for points that are off-chart and mark them with an edge arrow instead of a clamped dot.

- **Independent check:** not run (minor finding, unverified).

### F5 — Minor — Implementation — Case 5 labels p10 as "→ ∞" and shows six empty "Method diverged" frames, although the iterates only creep right by about 0.75 per step

- **Location:** secantmethodee.jl:107-111 (frame 9 legend "p10 → ∞" on a red diamond clamped to x = 10.1), 116-120 (frame 10, "p10 = 10.6 (diverged)") and 121-123 (frames 11–16, "Method diverged" only). Also `xlims = (0.0, 10.1)` at line 16 and `n_iters = 16` at line 14.
- **Now:** p10 = 10.57 is drawn at the clamped position x = 10.1 with the legend "p10 → ∞". The last 6 of the 16 frames show only the curve and the text "Method diverged". A viewer would conclude that the iteration blew up at p10.
- **True:** p10 = 10.5746 is finite. The off-chart text "p10 → 10.6" in the same frame is right, but the legend is not. The sequence diverges slowly and monotonically: p16 = 15.106, and the step size tends to ln 2 ≈ 0.693 (p2000 = 1394.87). The divergence to infinity that the page states is therefore correct, but the animation's last frames suggest a sudden escape. Nothing in the computation hit the script's 1e6 "diverged" threshold.
- **Evidence:** `print_ee.jl` gives p10 = 10.574639777228054 and p16 = 15.105971719963007. `ee_long.py` gives a step of 0.7737 at n = 10, 0.7457 at n = 16, 0.7026 at n = 100 and 0.6936 at n = 2000, with ln 2 = 0.693147. See frames `committed/secantmethodee/frame_009.png` and `frame_011.png` to `frame_016.png`.
- **Suggested fix:** Label the clamped diamond "p10 = 10.57 (off chart)", not "p10 → ∞". Either stop at `n_iters = 9`, or widen `xlims` to about (0, 16) so that all 16 frames show real secant steps (f stays plottable: f(16) ≈ 1.8e-6).

- **Independent check:** not run (minor finding, unverified).

### F6 — Minor — Implementation — Case 4 script header gives the root as −1.6724

- **Location:** secantmethoddd.jl:4, "# Real root near x ≈ -1.6724"
- **Now:** The header gives −1.6724.
- **True:** The root is −1.671699882 (−1.6717 to 4 decimals). The page's "≈ −1.672" at index.qmd:42 is correct, and the GIF prints computed values (p16 = −1.6717), so only the comment is wrong.
- **Evidence:** `indep.py` gives root = −1.67169988165716 and f(root) = 0. `print_dd.jl` gives p17 = −1.67169988165716.
- **Suggested fix:** Change the comment to "x ≈ -1.6717".

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `secantmethodaa.jl` | yes | 3.1 | secantmethodaa.gif |
| `secantmethodbb.jl` | yes | 3.8 | secantmethodbb.gif |
| `secantmethodcc.jl` | yes | 3.2 | secantmethodcc.gif |
| `secantmethoddd.jl` | yes | 3.5 | secantmethoddd.gif |
| `secantmethodee.jl` | yes | 3.5 | secantmethodee.gif |
| `secantmethodff.jl` | yes | 3.0 | secantmethodff.gif |

Committed GIFs byte-identical to their regenerated output: **6 of 6**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "a secant line is drawn through the two most recent iterates $(p_{n-1}, f(p_{n-1}))$ and $(p_n, f(p_n))$" | All 6 scripts build the line from (ps[k], f) with slope (f(ps[k+1]) − f(ps[k]))/(ps[k+1] − ps[k]). `line_*.jl` gives a residual at the second point ≤ 4.5e-16. Frames agree, except for the markers clamped in Case 4 (F4) | confirmed |
| 2 | 12 | "its x-intercept becomes $p_{n+1}$" | `line_*.jl` gives max relative difference between intercept and next iterate ≤ 1.7e-16 in all 6 cases. The red diamond sits at that intercept in the frames | confirmed |
| 3 | 12 | "no derivative is required — the slope is approximated from two function evaluations" | Code uses only f. The update always uses the two most recent iterates, never a retained bracket (not regula falsi). Iterates match the independent secant computation | confirmed |
| 4 | 12 | "can converge quickly, converge slowly near repeated roots, oscillate while converging, or diverge entirely" | Cases 1 / 2 / 3 / 5 respectively, verified below | confirmed |
| 5 | 14 | Julia source linked under each case | Lines 20, 28, 36, 44, 52, 60 link aa…ff, and each script produces the GIF embedded under it (manifest) | confirmed |
| 6 | 16 | Case 1: "Fast Convergence, $f(x) = 3e^x - 4\cos(x)$, $p_0 = 1.0$, $p_1 = 0.9$" | secantmethodaa.jl:10-12. Order estimates 1.60–1.65, err 2.7e-15 at p8 | confirmed |
| 7 | 18 | "converges quickly to the root near $x \approx 0.456$" | root 0.254850. 0.456 is p2 | wrong (→ F1) |
| 8 | 18 | "Both starting points are on the same side of the root" | 1.0 and 0.9 > 0.2549, f > 0 at both | confirmed |
| 9 | 18 | "the function is well-behaved, so the secant line immediately produces a good approximation" | p2 error 0.20 (vs root 0.255). Within 0.01 only at p4 | wrong (→ F1) |
| 10 | 20, 22 | aa.jl link and aa.gif embed are Case 1 | manifest: aa.jl → aa.gif, byte-identical. Title in frames matches f | confirmed |
| 11 | 22 | alt: "secant line drawn through two iterates, x-intercept converges rapidly to the root near x=0.456" | Rapid convergence is right. Root is 0.2549 | wrong (→ F1) |
| 12 | 24 | Case 2: "Slow Convergence (Double Root), $f(x) = 1 - 10x + 25x^2$, $p_0 = 1.0$, $p_1 = 0.9$" | secantmethodbb.jl:11-13 | confirmed |
| 13 | 26 | "The function $(1-5x)^2$ has a double root at $x = 0.2$ where $f'(0.2) = 0$" | (1−5x)² = 1 − 10x + 25x². f' = −10 + 50x = 0 at 0.2 | confirmed |
| 14 | 26 | "The secant method converges, but slowly" | Linear, ratio 0.61803. err 8.8e-7 after 29 iterates | confirmed |
| 15 | 26 | "the double root causes the denominator … to shrink, giving small steps" | Reasoning is backwards. Cause is f ≈ c e², e_{n+1} = e_n e_{n-1}/(e_n + e_{n-1}) | wrong (→ F3) |
| 16 | 26 | "creep toward the root over many iterations" | 28 frames. Legend goes 0.57333 → 0.2918 → 0.22162 → 0.2051 → 0.20121 → 0.20028 → 0.20007 → 0.20002 → 0.2 | confirmed |
| 17 | 28, 30 | bb.jl link and bb.gif embed are Case 2 | manifest | confirmed |
| 18 | 30 | alt: "iterates slowly approach the double root at x=0.2, demonstrating linear convergence behavior" | ratio → 0.61803, order estimate 1.000 | confirmed |
| 19 | 32 | Case 3: "$f(x) = \arctan(x)$, $p_0 = 1.35$, $p_1 = 1.30$" | secantmethodcc.jl:11-13 | confirmed |
| 20 | 34 | "converges to the root at $x = 0$" | p7 = 4.8e-25, then exactly 0 in floating point | confirmed |
| 21 | 34 | "the iterates oscillate — jumping to the opposite side of the root each step before settling" | Signs from p1: +, −, +, −, +, −, + (p1 … p7) | confirmed |
| 22 | 34 | "relatively flat slope of $\arctan$ near the starting points causes the secant line to overshoot to negative $x$ on the first step" | First secant slope 0.363. p2 = −1.22138 | confirmed |
| 23 | 36, 38 | cc.jl link and cc.gif embed are Case 3 | manifest | confirmed |
| 24 | 38 | alt: "iterates oscillate across x=0 with decreasing amplitude before converging" | \|p\|: 1.30, 1.22, 0.018, 0.0067, 4.6e-7, 6.9e-12, … | confirmed |
| 25 | 40 | Case 4: "Convergence (Oscillating Path to Distant Root), $f(x) = x^3 - x + 3$, $p_0 = 2.0$, $p_1 = 1.0$" | secantmethoddd.jl:11-13. Converges (p17 err 1e-15) | confirmed |
| 26 | 42 | "has a real root near $x \approx -1.672$" | −1.671700 (only real root: discriminant 4 − 243 < 0) | confirmed |
| 27 | 42 | "Starting from positive values far from the root, the secant iterates wander — including a large positive excursion — before eventually converging" | p2 … p9 = 0.5, −3.0, 0.111, −0.265, 3.164, −0.659, −1.118, −3.034, then converges | confirmed |
| 28 | 42 | "convergence can occur even when the path is non-monotone and the starting points are far from the root" | as above | confirmed |
| 29 | 44, 46 | dd.jl link and dd.gif embed are Case 4 | manifest | confirmed |
| 30 | 46 | alt: "iterates wander through positive and negative values before converging to the root near x=-1.672" | as above. Last legend p16 = −1.6717 | confirmed |
| 31 | 48 | Case 5: "NON Convergence (Diverging to Infinity), $f(x) = x e^{-x}$, $p_0 = 1.5$, $p_1 = 2.0$" | secantmethodee.jl:11-13. Monotone increase, step → ln 2, p2000 = 1394.9 | confirmed |
| 32 | 50 | "has a root at $x = 0$, the secant method diverges with these starting points" | as above | confirmed |
| 33 | 50 | "secant line through points on the decaying tail has a shallow negative slope whose x-intercept falls far to the right — each step pushes the estimate further from the root" | Both starts > 1 (past the maximum). First slope −0.128 → p2 = 4.114. p_n strictly increasing | confirmed (display caveat F5) |
| 34 | 52, 54 | ee.jl link and ee.gif embed are Case 5 | manifest | confirmed |
| 35 | 54 | alt: "the secant line's x-intercept steps progressively further right, demonstrating divergence to infinity" | p2 … p9 = 4.11, 4.81, 5.78, 6.59, 7.43, 8.23, 9.02, 9.80 in frames 1–8 | confirmed |
| 36 | 56 | Case 6: "Convergence, $f(x) = \arctan(x)$, $p_0 = 1.60$, $p_1 = 1.50$" | secantmethodff.jl:11-13 | confirmed |
| 37 | 58 | "With slightly larger starting values than Case 3, the method again converges to $x = 0$" | p7 = −9.2e-17 | confirmed |
| 38 | 58 | "Despite a larger first overshoot, subsequent steps quickly close in on the root" | p2 = −1.842 vs Case 3's −1.221. p5 = −5.2e-5 | confirmed |
| 39 | 58 | "illustrating that the secant method converges super-linearly (order $\approx 1.618$)" | Super-linear: yes. Order for arctan at 0 is 2 | wrong (→ F2) |
| 40 | 60, 62 | ff.jl link and ff.gif embed are Case 6 | manifest | confirmed |
| 41 | 62 | alt: "iterates converge to x=0 after initial overshoot, showing super-linear convergence" | as above | confirmed |
| 42 | 16–62 | Six cases | 6 headings, 6 scripts, 6 GIFs | confirmed |

The page has no Description section, so there are no method formulas to check beyond line 12.

## Implementation checks

All six scripts use the same update, `ps[i+1] = ps[i] - f(ps[i])*(ps[i]-ps[i-1])/(f(ps[i]) - f(ps[i-1]))`, applied always to the two most recent iterates. This is the plain secant method. It is not regula falsi: no bracket is kept, and in Case 3/6 the iterates p2 and p3 can lie on the same side of the root with both used next. The fallback for a denominator below 1e-14 copies the last iterate. In Case 1 it triggers only after convergence (p9/p10) and in Case 3 after the iterate is exactly 0 (frames 9–10, where no secant is drawn). In Case 5 it never triggers. Across all six scripts `line_*.jl` gives a residual of the drawn line at (p_k, f(p_k)) of ≤ 4.5e-16 and an intercept-vs-next-iterate error of ≤ 1.7e-16. The legend indices are correct: frame k labels ps[k] as p_{k−1}, ps[k+1] as p_k and ps[k+2] as p_{k+1}.

### secantmethodaa.jl
- Method: plain secant, f = 3e^x − 4cos x, p0 = 1.0, p1 = 0.9, 9 frames.
- Numbers (script / independent mpmath): p2 0.45575075416314531 / 0.45575075416314564. p3 0.32073053275992147 / 0.32073053275992162. p4 0.26376025263505531 / 0.26376025263505522. p5 0.25529351342420903 / …906. p6 0.25485317414524578 / …574. p7 0.25485006012443362 / …356. p8 0.25485005902885299 / …296. p10 0.25485005902885027 / root 0.25485005902885026. Order estimates 1.79, 1.50, 1.65, 1.60, 1.62.
- Reference values: no reference drawn. The root in the page text is wrong (F1).
- Picture: contact sheet plus frame 1 at full size. The secant passes through the two blue points, the red diamond is at the intercept with a dashed line up to the curve, and the legend reads "p2 = 0.45575" → "p10 = 0.25485". p0 = (1, 5.994) sits in the top-right corner but is inside the limits. No clamping in this script.

### secantmethodbb.jl
- Method: plain secant, f = 1 − 10x + 25x², p0 = 1.0, p1 = 0.9, 28 frames.
- Numbers: p2 0.57333333333333347 / 0.57333…333. p7 0.235 / 0.235. p12 0.20315492957746412 / 0.20315492957746479. p20 0.20006715675103587 / 0.20006715675105232. p29 0.20000088348568937 / 0.20000088348853019. The differences are float rounding near the double root (f ~ 1e-11) and are not visible at the 5 digits shown. Error ratio → 0.61803 = (√5−1)/2.
- Reference values: the double root 0.2 is exact.
- Picture: contact sheet plus frame 28. Secant lines and intercepts are correct. From about frame 13 onward the picture barely changes at this scale, and progress shows only in the legend value. The legend reads "p26 = 0.2" onward because of 5-digit rounding (true error 3.7e-6), which is ordinary rounding. Clamping is present in the code but never triggers (all points are in [0.2, 1] × [0, 16]).

### secantmethodcc.jl
- Method: plain secant, f = arctan, p0 = 1.35, p1 = 1.30, 10 frames.
- Numbers: p2 −1.2213792056860207 / −1.2213792056860117. p3 0.018036298196725919 / 0.018036298196728075. p4 −0.0067232949785549952 / …557019. p5 4.5722058130987647e-7 / 4.572205813098165e-7. p6 −6.8886493391e-12 / −6.8886493391e-12. p7 4.798e-25 / 4.800e-25. p8 is 0 in floating point (atan(x) = x exactly for tiny x makes the update return 0) vs −7.6e-48. This is harmless.
- Reference values: root 0 (exact).
- Picture: full contact sheet. The overshoot to −1.22 and the alternating sides show clearly. In frames 9–10 no secant is drawn because both points are 0. Legends show "p5 = 0.0" and "p6 = −0.0", which is ordinary rounding. All points fall inside ylims (|atan| ≤ 0.93), so clamping never triggers.

### secantmethoddd.jl
- Method: plain secant, f = x³ − x + 3, p0 = 2, p1 = 1, 16 frames. The early-exit `break` (line 33) would leave `ps` entries undefined, but it fires only at i = 17, the last loop index, so every entry is filled. Verified by printing all 18 values.
- Numbers: p3 −3 / −3. p6 3.1639049160972332 / 3.1639049160972343. p9 −3.0342275767851379 / −3.0342275767851387. p12 −1.7346585404889323 / …322. p15 −1.6717022768625058 / …059. p17 −1.67169988165716 / root −1.67169988165716. Asymptotic order estimates 1.66, 1.65, 1.60, 1.63.
- Reference values: none drawn. The header comment gives the root as −1.6724, which is wrong (F6).
- Picture: contact sheet plus frames 3 and 10. The secant lines and intercepts are correct. The markers for p3 and p9 are clamped to y = −5 and visibly lie off their secant lines (F4). The red-diamond x clamp never triggers, because all iterates are within [−3.2, 3.5].

### secantmethodee.jl
- Method: plain secant, f = x e^{−x}, p0 = 1.5, p1 = 2, 16 frames. The divergence guard (|p| > 1e6) never triggers.
- Numbers: p2 4.113798873326397 / 4.1137988733263955. p5 6.5948675617902737 / …2727. p9 9.8009866463165842 / …5816. p10 10.574639777228054 / …228051. p17 15.848820264001759 / …001755. Strictly increasing, step → ln 2 (`ee_long.py`).
- Reference values: root 0 (exact). It is never approached.
- Picture: contact sheet plus frame 9. Frames 1–8 show correct secants through visible points with intercepts. Frame 9 labels the clamped diamond at x = 10.1 as "p10 → ∞" and frames 11–16 show only "Method diverged" (F5). The gray history drops off-chart points rather than clamping them, which is fine.

### secantmethodff.jl
- Method: plain secant, f = arctan, p0 = 1.60, p1 = 1.50, 6 frames.
- Numbers: p2 −1.8424619601336367 / −1.8424619601336275. p3 −0.097483386474739309 / …736599. p4 0.076193229514677968 / …675137. p5 −5.2368150304113e-5 / −5.236815030410591e-5. p6 1.011134093196e-7 / 1.0111340931957673e-7. p7 −9.2253442e-17 / −9.2253449e-17. Asymptotic order 2 (`order_atan.py`), not 1.618 (F2).
- Reference values: root 0 (exact).
- Picture: full contact sheet. The first overshoot to −1.84 lies inside xlims, and f(−1.84) = −1.07 lies inside ylims, so nothing is clamped. Secants pass through both points. Legends show "p6 = 0.0" and "p7 = −0.0", which is ordinary rounding.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/secant-method/`](evidence/secant-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
