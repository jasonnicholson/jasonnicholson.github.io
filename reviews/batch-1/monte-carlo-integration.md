# Review: Monte Carlo Integration (batch 1, round 1)

**Result: 0 Error, 0 Misleading, 5 Minor** (unverified, as the review skill allows for Minor findings).

Both scripts are correct sample-mean Monte Carlo with correct references, and nearly every number on the page reproduces exactly:
- all the seeded NumPy runs (`default_rng`, NumPy 1.26.4 via `/usr/bin/python3`), with d-dimensional points drawn as `random((n,d))`;
- the Example 3 repeat study;
- the exact and reference values and the midpoint tables;
- every number in both Behavior paragraphs and in the GIF titles.

The legacy archive was consulted: `MonteCarloMod.html` and the solution images for Examples 1, 2, 3, 6 and 8–14. No fidelity departures were found, and every quoted Mathews number matches his images.

## Findings

### F1. Minor (page match): the m = 7 midpoint error is rounded wrongly
- **Where:** line 346, the table row `| 7 | 16807 | 1.1897660 | $+9.828\times10^{-4}$ | 1.361 | 1.361 |`.
- **What is true:** M(7) = 1.1897660407 and I_ref = 1.188783291439, so the error is +9.827493×10⁻⁴, which is 9.827×10⁻⁴ to four significant figures. "9.828" looks like double rounding.
- **Consistency:** line 50 (+0.0009827) and line 355 (+9.83×10⁻⁴) agree with the true value.
- **How the reviewer knows:** `ex14.py` gives `err=+9.8275e-04`, and the instrumented script gives `e_mid=+9.827493e-04`.
- **Fix:** $+9.827\times10^{-4}$.

### F2. Minor (page match): the normal-theory probabilities are rounded wrongly
- **Where:** line 359, "close to the normal-theory probabilities 88.0% and 90.6%".
- **What is true:** the probability is 2Φ(e_mid/SD) − 1.
  - At n = 7776, z = 1.55229, which gives 0.879408.
  - At n = 16807, z = 1.67726, which gives 0.906508.
  - So the figures are 87.9% and 90.7%. With Mathews' reference value they are 87.93% and 90.64%. The director confirmed z = 1.552 independently.
- **Fix:** "87.9% and 90.7%". The conclusion is unchanged.

### F3. Minor (reproducibility): the Example 14 repeat study cannot be reproduced from the stated seed alone
- **Where:** line 359, "Repeating the Monte Carlo estimate 10,000 times (seed 20261124), |MC error| was smaller … in 88.7% of runs at n=7776 and in 90.9% at n=16807", with line 23 ("the repeat studies give their seeds too") and line 51 ("9.1%").
- **What is true:**
  - The figures reproduce (88.71% and 90.91%) only if the generator continues from the Example 3 repeat study after its draws, using `rng.random((runs, n, 5))`.
  - A fresh `default_rng(20261124)` gives 87.94% and 90.80%. Other plausible draw orders give 87.37–87.94% and 90.52–90.96%.
  - The page also never says that each d-dimensional point takes d consecutive uniforms (`rng.random((n,d))`). That is the order that reproduces Examples 6–14.
  - No conclusion changes. Line 51's "9.1%" would be 9.2% with a fresh generator.
- **Evidence:** `rep14.py`, variants `after3` and `uniformw`.
- **Fix:** either say that the Example 14 study continues the Example 3 study's generator, or rerun it from a fresh seed and update the 88.7, 11.3, 90.9 and 9.1 figures. Also state the point layout.

### F4. Minor (page match): "his largest error" is not his largest error
- **Where:** line 211, "his largest error, at $n=1000$, is 1.79 estimated standard errors."
- **What is true:**
  - Mathews' errors (gr_84, 87, 90, 93) are 0.172166 (n = 10), 0.16161, 0.105151 and 0.00919347. The largest is at n = 10.
  - n = 1000 has the largest error *relative to its estimate*, 1.789. The other ratios are 0.246, 0.875 and 0.488.
- **Fix:** "his largest error relative to its estimate, at n=1000, is 1.79 estimated standard errors".

### F5. Minor (page match): "a little over two estimated standard errors" understates 2.52
- **Where:** line 200, "the actual error at $n=1000$ and $n=10000$ is a little over two estimated standard errors, something that happens in about 5% of runs".
- **What is true:**
  - The ratios are 2.52 and 2.12.
  - "About 5%" is right for errors beyond two: the repeat study gives 4.67% and 4.62%.
  - 2.52 is not "a little over" two. P(|Z| > 2.52) is about 1.2%.
- **Fix:** "2.52 and 2.12 estimated standard errors; an error beyond two estimated standard errors happens in about 5% of runs…".

## Unresolved

None.

## Inventory (Phase 1)

- **Scripts:** `montecarloaa.jl`, `montecarlobb.jl`.
- **GIFs:** 45 frames decoded (39 distinct) and 52 frames decoded (46 distinct). Each has a held last frame.
- Every file is referenced by the page and no reference is missing. The section index links `monte-carlo-integration/`.
- Both GIFs regenerate byte-identically. The reviewer's own run of Case 2 did too.

## Claim ledger (whole page): 100 entries

95 confirmed, 2 wrong (F1, F2), and 3 confirmed with a caveat (F3, F4, F5). History entries (the Metropolis/Ulam naming) were excluded.

Selected evidence (C = confirmed):

**Description**
- The estimator and the error formula match both scripts. **C**
- The O(1/√n) and O(n^{−2/d}) rates. **C**
- Hit-or-miss is on the Monte Carlo Pi page. **C**

**Animations introduction**
- Both animations are new, and Mathews' Animations link points at the Midpoint Rule. **C**
- The Xoshiro seeds. **C**
- Frame n values: 39 and 46 distinct. **C**
- The panels. **C**
- Dips below the log floor at sign changes: 31 n in Case 1 and 36 in Case 2. **C**
- The not-animated list covers every other example. Example 13 is the same integral as Example 14 (gr_275, gr_286). **C**

**Case 1**
- 6.8463789; 5.6917090; 5.4444112 ± 0.05756307 with error +0.1110778 (1.9297 SE); 5.3427388 ± 0.01894701 with error +0.009405471 (0.4964 SE). **C**
- At n = 2: points at x = 2.978 and 2.882, SE 0.03967 against SD 1.333, error 38.14 SE. **C**
- From n = 100 on, the largest SE deviation is 5.23% (at n = 690). **C**
- From n = 10 on, the largest error is 2.2336 SE (at n = 726), checked at every n. **C**

**Case 2**
- The midpoint values 1.2006957746 … 1.1897660407, all above I_ref. **C**
- Local slopes −0.397 to −0.400. **C**
- At n = 32, SD 0.01343 against midpoint error 0.01191. **C**
- The ratio of midpoint error to SD runs from 1.0934 to 1.6773. **C**
- The win/loss pattern. **C**
- At n = 16807: 1.18770850, SE 5.840964e-4, error −1.074794e-3, 1.840 SE. **C**

**Example 1**
- 20/9 and 20/(9π) = 0.7073553026. **C**
- The four roots, 0.40569499 … 2.73589767. **C**
- Mathews' c = 1.36432 (gr_16). **C**

**Example 2**
- The midpoint table, with ratios 29.2, 30.9 and 31.4, tending to 10^1.5. **C**
- Mathews' gr_66. **C**
- f″ is unbounded, so the error falls like h^1.5. **C**

**Example 3**
- μ = 4/3, σ² = 2/9, SD = 1.885618/√n. **C**
- The seed-2026 run and its table, every digit. **C**
- se/SD = 0.748, 0.894, 0.974, 0.989. **C**
- Mathews' table, within 18% (the largest gap is 17.25%). **C**

**Repeat study**
- RMS 0.59299, 0.18732, 0.05985, 0.01911. **C**
- Coverage 63.7/68.2/67.8/67.1% within one SE and 90.5/95.1/95.3/95.4% within two. **C**
- Slope −0.497. **C**

**Examples 4 and 5**
- 2π+4 and 7/6. **C**
- σ² = 0.413581 and 0.074012. **C**
- The seeded runs. **C**

**Examples 6 and 7**
- 1775/384, 71/24, 125/288. **C**
- Seed 6 values. **C**
- Mathews' gr_177. **C**
- Example 7 closed form 2.669054, σ² = 0.040404, the seed 7 run. **C**

**Examples 8–13**
- Every table row (`ex8_13.py`). **C**
- The GL reference is stable to about 1e-15. **C**
- All errors below 2 SE (largest 1.60). **C**
- Mathews' Example 10. **C**

**Example 14**
- GL 1.188783291, against Mathews' value 2.986e-7 higher. **C**
- Rows m = 4–6. **C**
- (m/(m−1))² within 0.23%. **C**
- Seeds 14 and 15. **C**
- Mathews' runs. **C**

**Practical notes**
- 35556 points. **C**
- 63.7%. **C**
- 0.0137 against 0.593. **C**
- √(n/(n−1)). **C**

## Implementation checks

**`montecarloaa.jl`**
- **Method:** plain sample-mean Monte Carlo, `xs = 4 rand(Xoshiro(3), N)`. It uses cumulative sums, and the variance divides by n, as in formula (4).
- **Numbers:** recomputed by direct sums from the same stream (`indep_julia.jl`), with agreement at every quoted n.
- **Reference:** 16/3 and 4√2/3 = 1.885618.
- **Picture:** frames 1, 19, 29 and 39 were checked. The rectangle height is f̄, and the red points are the newest batch (2057 = 10000 − 7943). Nothing is clamped: the band 4.658–7.250 lies inside the y-limits 3.333–7.333.

**`montecarlobb.jl`**
- **Method:** a 5-D uniform sample, plus a true product midpoint rule with nodes wⱼ(i−½)/m.
- **Numbers:** the midpoint values are identical to a numpy meshgrid computation, and the MC values match direct sums.
- **Reference:** Golub–Welsch GL gives 1.188783291439 at 12, 16 and 20 nodes, against 1.188783291438694 from numpy `leggauss`. The SD constant is 0.07596050287 (exact E f² = 4.6166667).
- **Picture:** frames 14 and 46 were checked. The diamonds appear only once n ≥ m⁵, and the title comparison matches the computation. In the final frame the red marker almost covers the n = 16807 diamond, which is cosmetic.

The reviewer's scratch work is in `$WORK/review-batch-1/monte-carlo-integration/reviewer/` (session scratchpad): `ex1_2.py`, `ex3.py`, `rep3.py`, `rep3b.py`, `ex4_7.py`, `ex8_13.py`, `ex14.py`, `rep14.py`, `aa_instr*.jl`, `bb_instr.jl`, `indep_julia.jl`.
