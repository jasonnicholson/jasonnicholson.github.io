# Monte Carlo Pi — animation review (round 4)

Page: `pages/numerical-methods/monte-carlo-pi/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Counts: Error 0, Misleading 0, Minor 0.

Observation (not a finding): at n = 1600, 6400 and 10000 the six annotation lines (drawn at x = 0.62, y = 0.70..0.95, no background box) sit on top of dense green/orange points near the arc. At native 630 px size all values remain legible (checked frames 5 and 6 at full size), so it does not meet the "unreadable" threshold. If the owner wants it cleaner, a white text background or moving the text block is a cosmetic option.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `montecarlopiaa.jl` | 0 | 7.4 | montecarlopiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `montecarlopiaa.gif` | 6 | byte-identical | montecarlopiaa |

### Page references

- Scripts linked: `montecarlopiaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (own words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "samples random points uniformly in the unit square [0,1]×[0,1]" | Script lines 12-14: `Random.seed!(12345); xs = rand(10000); ys = rand(10000)` (uniform on [0,1)). Dumped points: min 2.7e-6, max 0.99999 | confirmed |
| D2 | "counts how many lie inside the quarter unit disk x²+y²≤1" | line 15 `xs.^2 .+ ys.^2 .<= 1.0`; no points within 1e-12 of the boundary, so `<=` vs `<` is immaterial | confirmed |
| D3 | π̂_n = 4m/n | line 42 `pi_hat = 4*m/n` with m = count inside first n | confirmed |
| D4 | "stochastic error decreases on the order of 1/√n" | SD of π̂ = 4√(p(1-p)/n); Python simulation, 20000 replicates: n=100 SD 0.16502 vs formula 0.16422; n=10000 SD 0.016380 vs 0.016422 | confirmed |
| D5 | "slower than high-order deterministic quadrature but robust in higher-dimensional settings" | Standard property: MC rate n^{-1/2} independent of dimension; not numerically testable on this page | confirmed (standard fact) |
| A1 | "Each animation below shows the Monte Carlo point-cloud estimator for π in the quarter-disk geometry" | One animation; frames show quarter disk and point cloud | confirmed |
| A2 | "Frames follow the worked-example sample sizes n=100, 400, 1600, 6400, 10000" | Script line 9 `n_seq = [100, 400, 1600, 6400, 10000]`; archive image `MonteCarloPiMod_gr_33.gif` reads "n = 100, 400, 1600, 6400, and 10000"; frame annotations read n = 100, 400, 1600, 6400, 10000 | confirmed |
| A3 | "No archived animation GIF is available for this topic in the current snapshot" | `a2001/Animations/` has no Monte Carlo folder, `grep -ril 'monte carlo'` there returns nothing; the only multi-frame GIFs under `n2003/montecarlopi/` are `constr00.gif`/`constr01.gif` (288×40, 108×70 "under construction" banners shared across many pages) | confirmed |
| A4 | "reconstructed from Example 1 of Mathews' Monte Carlo Pi module" | lnk_2 = Example 1 "Use Monte Carlo simulation to approximate the number π", same n-sequence, same quarter-disk picture (gr_35) | confirmed |
| A5 | "Examples 2–7 ... hit-or-miss ... areas under curves (Examples 2–5), area of a cardioid (Example 6), region bounded by inequalities (Example 7), are not animated here" | Archive text: Examples 2-5 "approximate the integral", Ex 6 "area of the cardioid", Ex 7 "area of the region defined by the constraints"; method is ratio of points in A to box R. Drop is stated, not silent | confirmed |
| C1 | Heading: "Monte Carlo π Estimation, Quarter Unit Disk in [0,1]²" | Script geometry, axis limits (0,1)×(0,1) | confirmed |
| B1 | "After the opening frame (quarter circle only, no points)" | Loop over `vcat(0, n_seq)`; n=0 branch draws arc + square only; frame_001 shows that | confirmed |
| B2 | "each frame adds points" | `idx = 1:n` on a fixed sample, so frames are nested prefixes; cumulative | confirmed |
| B3 | "green inside x²+y²≤1 and orange outside" | lines 38-39 forestgreen/darkorange; frame_002 pixel blob count 72 green / 26 orange vs computed 73/27 (one overlap each with text/neighbour); three top-left points (0.018,0.957), (0.038,0.989), (0.033,0.955) appear green at the matching place | confirmed |
| B4 | "prints the estimate π̂_n" | annotation "pi_hat = …" in frames 2-6: 2.92, 3.06, 3.175, 3.155625, 3.162 (equal to independent Python values) | confirmed |
| B5 | "fluctuates but trends toward π as n increases" | |π−π̂|: 0.221593, 0.081593, 0.033407, 0.014032, 0.020407 — falls overall, rises at the last step | confirmed |
| B6 | "Each of these five frames also prints the standard error 4√(p(1−p)/n) with p=π/4" | line 51 and annotation "std error = …"; five frames with n>0 | confirmed |
| B7 | "(about 1.642/√n)" | 4√(π/4·(1−π/4)) = 1.6421834 | confirmed |
| B8 | "the standard deviation of π̂_n" | 4m/n with m ~ Binomial(n, π/4) has SD exactly 4√(p(1−p)/n); simulation in D4 agrees | confirmed |
| B9 | "in this seeded run |π−π̂_n| is between 0.68 and 1.35 standard errors in each of them" | ratios 1.3494, 0.9937, 0.8137, 0.6836, 1.2427 (Julia and Python agree) → range 0.684..1.349 | confirmed |
| W1 | Source link `montecarlopiaa.jl` | file exists, is the only script, produces the embedded GIF | confirmed |
| W2 | Embed `montecarlopiaa.gif` | byte-identical to regenerated output (manifest) | confirmed |
| W3 | Alt text: "random points are classified by quarter-circle membership while the running estimate approaches pi as sample size increases" | Classification confirmed (B3); estimate approaches π overall (B5; last step error 0.0204 > 0.0140 but the behaviour paragraph itself says it fluctuates) | confirmed |
| F1 | Frame title "Monte Carlo Estimation of pi"; annotations n, inside m, outside k = n−m, |pi − pi_hat|, std error | m/k: 73/27, 306/94, 1270/330, 5049/1351, 7905/2095 — match independent counts | confirmed |

### 3. Implementation checks — `montecarlopiaa.jl`

**Method.** Hit-or-miss Monte Carlo: n i.i.d. uniform points in [0,1)², m = #{x²+y²≤1}, π̂ = 4m/n. This is exactly the method in the Description and in Mathews' Example 1 (Mathews' Mathematica code `MonteCarloResults`, image gr_32, uses the same counts n, m, k and quarter circle). Frames reuse one seeded sample of 10000 points and take prefixes, which is the natural "growing n" variant; Mathews drew fresh samples per n, a difference that does not affect any page claim.

**Numbers.** Instrumented copy `review/inst.jl` printed, and an independent Python/numpy recount over the dumped points (`review/pts.txt`, written with Julia's round-trip float printing) reproduced exactly:

| n | m (Julia) | m (Python) | π̂ | |π−π̂| | SE | ratio |
|---|---|---|---|---|---|---|
| 100 | 73 | 73 | 2.92 | 0.221593 | 0.164218 | 1.349 |
| 400 | 306 | 306 | 3.06 | 0.081593 | 0.082109 | 0.994 |
| 1600 | 1270 | 1270 | 3.175 | 0.033407 | 0.041055 | 0.814 |
| 6400 | 5049 | 5049 | 3.155625 | 0.014032 | 0.020527 | 0.684 |
| 10000 | 7905 | 7905 | 3.162 | 0.020407 | 0.016422 | 1.243 |

All six annotation values in every frame match these to the printed 6 digits.

**Reference values.** "True" π is Julia's built-in `pi` (exact to Float64). The standard-error formula 4√(p(1−p)/n), p = π/4, is the exact SD of 4·Binomial(n,p)/n; a 20000-replicate numpy simulation gave SD 0.16502 (n=100) and 0.016380 (n=10000) against formula values 0.16422 and 0.016422.

**Picture.** Frames 1, 2, 5, 6 viewed at full size and all six on the contact sheet. Frame 1: quarter arc (θ ∈ [0, π/2], 400 points, radius 1) and unit-square border, no points. Frames 2-6: green/orange points at the dumped coordinates (spot-checked three points and pixel blob counts in frame 2), arc separates the colours correctly, title and annotations report the quantities computed for that n. Axis limits are exactly the sampling square, so nothing is clipped away; no clamping or masking is used. Frame count 6 = 1 opening + 5 sample sizes, as the page says. Only display concern is the text-over-points overlap noted above, which stays legible.

**Legacy fidelity.** Same example (Example 1), same sample sizes, same geometry and same quantities (n, m, k, approximation, error). Mathews printed "order of error π/√n" where the page prints the true standard error ≈1.642/√n — a correct refinement, not a departure that misleads. Mathews' colours (red inside, green outside) differ; colours are not a finding. Examples 2-7 are omitted and the page says so explicitly.

