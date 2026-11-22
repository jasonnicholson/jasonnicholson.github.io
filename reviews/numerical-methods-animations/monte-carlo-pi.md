# Monte Carlo Pi — animation review

Page: [`pages/numerical-methods/monte-carlo-pi/index.qmd`](../../pages/numerical-methods/monte-carlo-pi/index.qmd) · Scripts: `montecarlopiaa.jl` · GIFs: 1

**Result:** 0 error, 0 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Minor — Implementation — The `1/sqrt(n)` annotation is smaller than the error in every frame, so it reads as a bound that is always broken

- **Location:** `montecarlopiaa.jl:50` (`annotate!(0.62, 0.70, text("1/sqrt(n) = ..."))`), shown in frames 2–6 directly under `|pi - pi_hat|`.
- **Now:** Each frame prints `|pi - pi_hat|` with `1/sqrt(n)` on the line below it, which invites a direct comparison. The error is larger than `1/sqrt(n)` in all five frames: 0.2216 vs 0.1, 0.0816 vs 0.05, 0.0334 vs 0.025, 0.0140 vs 0.0125, 0.0204 vs 0.01. At the final frame (n = 10000) the error is about twice the printed value.
- **True:** The standard error of $\hat\pi_n = 4m/n$ is $4\sqrt{p(1-p)/n}$ with $p=\pi/4$, which is about $1.642/\sqrt{n}$. Measured against that, the errors are 1.35, 0.99, 0.81, 0.68 and 1.24 standard errors, which is ordinary for a seeded run. The run is statistically fine. The trouble is that the printed scale leaves out the constant 1.64. A viewer comparing the two lines could conclude that the estimator falls short of its $O(1/\sqrt n)$ accuracy, or that the error grew past its expected size in the last frame.
- **Evidence:** `reviewer/values.jl` (the script's RNG and counts, without plotting) and `reviewer/indep.py` (an independent recount in numpy from the dumped points) both give, for n = 100/400/1600/6400/10000: m = 73/306/1270/5049/7905, err = 0.221593/0.081593/0.033407/0.014032/0.020407, $1.642/\sqrt n$ = 0.1642/0.0821/0.0411/0.0205/0.0164, z = 1.349/0.994/0.814/0.684/1.243.
- **Suggested fix:** Replace line 50 with the standard error, e.g. `text("std err ≈ $(round(4*sqrt((pi/4)*(1-pi/4)/n); digits=6))", ...)`, or label the existing value as a scale rather than a bound (e.g. "scale 1/sqrt(n)"). Then regenerate the GIF.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `montecarlopiaa.jl` | yes | 3.0 | montecarlopiaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12–13 | "samples random points uniformly in the unit square $[0,1]\times[0,1]$" | Script lines 13–14 `rand(max_n)` give uniform values on [0,1). The dumped points have min ≥ 0 and max < 1 in both coordinates. | confirmed |
| 2 | 13–14 | "counts how many lie inside the quarter unit disk $x^2+y^2\le 1$" | Script line 15 `xs.^2 .+ ys.^2 .<= 1.0`, the same test including the boundary. | confirmed |
| 3 | 15–18 | "$\hat\pi_n = 4\frac{m}{n}$" | Script line 42 `pi_hat = 4 * m / n`. The quarter disk has area π/4 in a unit square, so 4m/n is unbiased for π. | confirmed |
| 4 | 20 | "The stochastic error decreases on the order of $1/\sqrt{n}$" | The standard error is $1.642/\sqrt n$. In the run, err·√n = 2.22, 1.63, 1.34, 1.12, 2.04, which stays bounded and matches the constant 1.64. (The frame annotation of this rate is F1.) | confirmed |
| 5 | 20 | "slower than high-order deterministic quadrature but robust in higher-dimensional settings" | This is a general textbook fact: the MC rate does not depend on dimension, while deterministic rules are faster in low dimension. Nothing on the page contradicts it. | confirmed (general fact, not tied to the GIF) |
| 6 | 24–25 | "Monte Carlo point-cloud estimator for $\pi$ in the quarter-disk geometry" | Frames show points in [0,1]² with the quarter arc drawn (frames 1–6). | confirmed |
| 7 | 25–26 | "Frames follow the worked-example sample sizes $n=100, 400, 1600, 6400, 10000$" | Script line 9 `n_seq`. The frames print n = 100, 400, 1600, 6400, 10000 after a blank frame with n = 0 (6 frames in total, matching `nframes`). The "worked-example" origin is provenance and was not checked (archive unavailable). | confirmed (sizes); provenance not checked |
| 8 | 30 | Heading "Quarter Unit Disk in $[0,1]^2$" | Axes are 0–1 on both, the arc is cos/sin on θ∈[0,π/2], and the square is outlined. | confirmed |
| 9 | 32 | "Green points fall inside $x^2+y^2\le 1$ and orange points fall outside" | Script lines 38–39 draw `forestgreen` for the inside index and `darkorange` for the outside index. In frames 2 and 6, every green point is inside the arc and every orange point is outside it. | confirmed |
| 10 | 32 | "The estimate $\hat\pi_n$ fluctuates but trends toward $\pi$ as $n$ increases" | $\hat\pi$ = 2.92, 3.06, 3.175, 3.155625, 3.162 and the errors are 0.2216, 0.0816, 0.0334, 0.0140, 0.0204. The estimate overshoots after n = 400 and the error rises again at the last frame, but the overall trend is toward π. | confirmed |
| 11 | 34 | "[Julia source](montecarlopiaa.jl)" | The file exists, and the manifest shows it produces this GIF byte-identically. | confirmed |
| 12 | 36 | Embed `montecarlopiaa.gif` | Committed GIF = script output (manifest: bytes_identical, frames_identical). | confirmed |
| 13 | 36 | Alt text: "random points are classified by quarter-circle membership while the running estimate approaches pi as sample size increases" | The classification is confirmed (#9). The samples are nested (the first n of one 10000-point stream), so "running estimate" is accurate. The approach to π holds overall (error 0.22 → 0.02) but is not monotone (0.0140 at n = 6400, then 0.0204 at n = 10000). Read as a trend, the claim is acceptable. | confirmed (trend; not monotone) |

## Implementation checks

### montecarlopiaa.jl
- **Method:** Hit-or-miss Monte Carlo on the quarter unit disk. The script draws 10000 seeded pairs (Random.seed!(12345), Julia 1.12 default Xoshiro), uses the first n pairs for each frame (nested samples), counts m with x²+y² ≤ 1, and sets $\hat\pi = 4m/n$. This matches the Description exactly.
- **Numbers (script values / independent numpy recount from the same points):**

  | n | m | k = n−m | π̂ | \|π−π̂\| | 1/√n | true std err 1.642/√n | z |
  |---|---|---|---|---|---|---|---|
  | 100 | 73 / 73 | 27 / 27 | 2.92 / 2.92 | 0.221593 / 0.221593 | 0.1 | 0.1642 | 1.35 |
  | 400 | 306 / 306 | 94 / 94 | 3.06 / 3.06 | 0.081593 / 0.081593 | 0.05 | 0.0821 | 0.99 |
  | 1600 | 1270 / 1270 | 330 / 330 | 3.175 / 3.175 | 0.033407 / 0.033407 | 0.025 | 0.0411 | 0.81 |
  | 6400 | 5049 / 5049 | 1351 / 1351 | 3.155625 / 3.155625 | 0.014032 / 0.014032 | 0.0125 | 0.0205 | 0.68 |
  | 10000 | 7905 / 7905 | 2095 / 2095 | 3.162 / 3.162 | 0.020407 / 0.020407 | 0.01 | 0.0164 | 1.24 |

  All values printed in the frames (read from full-size frames 2 and 6, and from the contact sheet for the rest) match these. Every |z| < 1.4, so the run is statistically typical. Commands: `cd reviewer && julia values.jl` (it also writes `pts.txt`), then `/usr/bin/python3 -I indep.py`.
- **Reference values:** The only reference is Julia's `pi`, which is exact to double precision. The 1/√n annotation is correctly computed but is a scale without the 1.64 constant (F1).
- **Picture:** I looked at the contact sheet and full-size frames 2 (n = 100) and 6 (n = 10000). The arc is the correct quarter circle (cos/sin on [0,π/2]), the square is outlined, and the colours split exactly at the arc. The title is generic ("Monte Carlo Estimation of pi"). Frame 1 is blank with n = 0 and no annotation. No clamping or masking is used. The annotation block at (0.62, 0.70–0.95) sits over the orange/green boundary and is crowded by points at n ≥ 6400, but it is still readable at full size, so it is not a finding.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/monte-carlo-pi/`](evidence/monte-carlo-pi/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
