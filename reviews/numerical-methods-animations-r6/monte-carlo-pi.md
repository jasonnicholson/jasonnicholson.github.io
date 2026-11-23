# Monte Carlo Pi — animation review (round 6)

Page: `pages/numerical-methods/monte-carlo-pi/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.

I found nothing false, misleading or of minor consequence that meets the review standard. The notes below are not findings:
- In frames 5 and 6 (n = 6400 and 10000), the text annotations sit on top of the dense point cloud. Every value is still legible (I read all six lines in both frames), so this is cosmetic.
- The intro says "Each animation below" in the plural, but the page has only one animation. This is wording only.
- The colours differ from Mathews' (he used red inside and green outside; the page uses green inside and orange outside). The page also prints the true standard error 4√(p(1−p)/n) where Mathews printed an "order of error π/√n". This departure is mathematically better and is not a fidelity problem.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `montecarlopiaa.jl` | 0 | 7.2 | montecarlopiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "samples random points uniformly in the unit square [0,1]×[0,1]" | Script lines 12–14: `xs = rand(max_n)`, `ys = rand(max_n)` (Julia `rand` is U[0,1)). KS test on the 10000 dumped points: p = 0.40 (x) and 0.50 (y); corr(x,y) = 0.0065. Ranges: x ∈ [0.000186, 0.999938], y ∈ [2.7e-6, 0.999988] | confirmed |
| D2 | "counts how many lie inside the quarter unit disk x²+y²≤1" | Line 15: `inside = xs.^2 .+ ys.^2 .<= 1.0`. Recomputed independently in Python from the dumped points: same m for every n | confirmed |
| D3 | "π̂_n = 4 m/n" | Line 42: `pi_hat = 4*m/n` | confirmed |
| D4 | "stochastic error decreases on the order of 1/√n" | Simulation (`sim.py`, 2000 geometric replications per n): sd·√n = 1.641, 1.629, 1.666, 1.614, 1.616 for n = 100…10000. Theory gives 1.6422 | confirmed |
| D5 | "slower than high-order deterministic quadrature but robust in higher-dimensional settings" | A general, standard statement (the MC rate does not depend on dimension). I did not compute it for this page | confirmed (standard theory; not computed) |
| A1 | "Frames follow the worked-example sample sizes n=100, 400, 1600, 6400, 10000" | Line 9 `n_seq`. Archive gr_33.gif reads "n = 100, 400, 1600, 6400, and 10000". The frames show exactly these n | confirmed |
| A2 | "Julia source scripts … linked under each case" | One case, linked to `montecarlopiaa.jl`, which exists | confirmed |
| A3 | "No archived animation GIF is available for this topic in the current snapshot" | `find a2001/Animations -iname '*monte*' -o -iname '*carlo*'`: nothing. The n2003 module has static graphics only | confirmed |
| A4 | "reconstructed from Example 1 of Mathews' Monte Carlo Pi module" | Archive Example 1 / Solution 1 (lnk_2): the same quarter-disk hit-or-miss test with the same five n | confirmed |
| A5 | "Examples 2–7 … areas under curves (Examples 2–5), the area of a cardioid (Example 6) and the area of a region bounded by inequalities (Example 7), are not animated here" | Archive module text: Ex 2–5 are "approximate the integral", Ex 6 is "area of the cardioid", Ex 7 is "area of the region defined by the constraints"; the method is the box-and-count method | confirmed (an omission the page discloses, not a silent drop) |
| C1 | Heading "Monte Carlo π Estimation, Quarter Unit Disk in [0,1]²" | Script geometry and axes are xlims/ylims (0,1) | confirmed |
| C2 | "opening frame (quarter circle only, no points)" | frame_001: arc and square box, no points (the loop starts at n = 0 and the `if n > 0` branch is skipped) | confirmed |
| C3 | "each frame adds points" | The points are the prefixes 1:n of a single fixed sample, so they are nested and cumulative. Pixel counts of orange/green grow: 215/525, 718/2204, 2509/9007, 9663/34474, 14592/52293 | confirmed |
| C4 | "green inside x²+y²≤1 and orange outside" | Lines 38–39. Pixel check (`pix.py`, axes mapped from frame 1: x 0→col 50, 1→col 606; y 1→row 38, 0→row 594): green pixels have radius ≤ 1.0031, orange pixels have radius ≥ 0.9981, in every frame. Both are within one marker radius of the arc | confirmed |
| C5 | "prints the estimate π̂_n" | Frames print `pi_hat` = 2.92, 3.06, 3.175, 3.155625, 3.162. Independent recomputation gives the same values | confirmed |
| C6 | "fluctuates but trends toward π as n increases" | π̂ = 2.92, 3.06, 3.175, 3.155625, 3.162. \|err\| = 0.2216, 0.0816, 0.0334, 0.0140, 0.0204. The estimate overshoots after n = 1600 and the error is not monotone (it rises at n = 10000), but the overall trend is toward π | confirmed |
| C7 | "Each of these five frames also prints the standard error 4√(p(1−p)/n) with p=π/4" | Line 51, and the frames print 0.164218, 0.082109, 0.041055, 0.020527, 0.016422. Python gives the same | confirmed |
| C8 | "(about 1.642/√n)" | 4√(p(1−p)) = 1.642183 | confirmed |
| C9 | "the standard deviation of π̂_n" | m ~ Binomial(n, π/4), so sd(4m/n) = 4√(p(1−p)/n). Simulation sd matches (D4) | confirmed |
| C10 | "\|π−π̂_n\| is between 0.68 and 1.35 standard errors in each of them" | z = 1.3494, 0.9937, 0.8137, 0.6836, 1.2427. Min 0.684 rounds to 0.68; max 1.349 rounds to 1.35 | confirmed |
| C11 | Alt text: "random points are classified by quarter-circle membership while the running estimate approaches pi as sample size increases" | As C4 and C6 | confirmed |
| W1 | `[Julia source](montecarlopiaa.jl)` and embed `montecarlopiaa.gif` | Both files exist. The GIF is that script's output (byte-identical regeneration, 6 frames) | confirmed |
| F1 | Frame text: n, inside m, outside k, pi_hat, \|pi − pi_hat\|, std error | Read from the sheet and frames 5–6 and compared with the `instr.jl` output. All 30 values match (table in §3) | confirmed |
| F2 | Frame count: opening frame + 5 sample sizes = 6 | The GIF has 6 frames | confirmed |

### 3. Implementation checks: `montecarlopiaa.jl`

**It is the method it claims to be.** It is hit-or-miss Monte Carlo: uniform points in [0,1]², the indicator x²+y² ≤ 1, and π̂ = 4m/n. This is exactly Mathews' Example 1 method. Each frame takes the first n points of a single seeded sample of 10000 (seed 12345), so the estimates for successive n are nested running estimates, not independent samples. The page's wording "each frame adds points" describes this correctly.

**The numbers are right.** I instrumented a copy (`review/instr.jl`) that dumps all 10000 points with `repr` precision and prints the per-frame statistics. An independent Python recount from the dumped coordinates (`review/indep.py`) agrees:

| n | m (script) | m (Python) | k | π̂ | \|π−π̂\| | std err (script) | std err (Python) | z |
|---|---|---|---|---|---|---|---|---|
| 100 | 73 | 73 | 27 | 2.92 | 0.221593 | 0.164218 | 0.1642183 | 1.349 |
| 400 | 306 | 306 | 94 | 3.06 | 0.081593 | 0.082109 | 0.0821092 | 0.994 |
| 1600 | 1270 | 1270 | 330 | 3.175 | 0.033407 | 0.041055 | 0.0410546 | 0.814 |
| 6400 | 5049 | 5049 | 1351 | 3.155625 | 0.014032 | 0.020527 | 0.0205273 | 0.684 |
| 10000 | 7905 | 7905 | 2095 | 3.162 | 0.020407 | 0.016422 | 0.0164218 | 1.243 |

The standard-error formula was checked against the distribution rather than from memory. In 2000 geometric replications per n (`sim.py`), the empirical sd of π̂ is 0.1641, 0.0815, 0.0416, 0.0202, 0.0162, against the formula's 0.1642, 0.0821, 0.0411, 0.0205, 0.0164.

**Its reference values are right.** The only reference value is Julia's built-in `pi`, which is exact to double precision.

**The picture shows what was computed.**
- The arc is (cos θ, sin θ) for θ ∈ [0, π/2] (lines 17–19), drawn with the unit square box.
- The pixel check (C4) shows the classification colours split exactly at the drawn arc.
- The annotations print m, k, π̂, \|π−π̂\| and the standard error with the correct index n and match the recomputation.
- The axes are fixed at [0,1]², which is exactly the sampling domain. No clamping or masking is used.
- The six frames are: an empty opening frame, then the five sample sizes.

