# Monte Carlo Pi — animation review (round 5)

Page: `pages/numerical-methods/monte-carlo-pi/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page agrees with the script's computed values, my independent recount of them, the frames and the legacy Example 1.

These were considered and are **not findings**:
- *Annotation legibility.* In frames 5 and 6 (n = 6400, 10000) the six annotation lines are drawn with no background box over dense orange and green points (crops in `review/annots.png`). Every number can still be read, so the animation is cluttered but neither unreadable nor misleading.
- *Plural boilerplate.* "Each animation below…" and "linked under each case" describe a page that has only one case. This is style.
- *Departure from Mathews' error measure.* Mathews prints "Order of error π/√n" (e.g. 0.314159 at n=100). The page and GIF use the true standard error 4√(p(1−p)/n) ≈ 1.642/√n. This departure makes the page more correct, so it is not a Fidelity finding.
- *Mathews' Examples 2–7 not animated.* The page says so explicitly and describes them accurately (checked against the archive), so they are not dropped silently.
- *Colours.* Mathews uses red for inside and green for outside, and the page uses green for inside and orange for outside. Colour choice is excluded.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `montecarlopiaa.jl` | 0 | 6.9 | montecarlopiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | "samples random points uniformly in the unit square [0,1]×[0,1]" | `xs = rand(max_n)`, `ys = rand(max_n)` (lines 13–14), uniform on [0,1); dumped range x∈[0.000186, 0.99994], y∈[2.7e-6, 0.99999] | confirmed |
| D2 | "counts how many lie inside the quarter unit disk x²+y²≤1" | line 15 `xs.^2 .+ ys.^2 .<= 1.0`; independent Python recount gives the same m (below) | confirmed |
| D3 | "π̂_n = 4 m/n" | line 42 `pi_hat = 4 * m / n` | confirmed |
| D4 | "stochastic error decreases on the order of 1/√n" | simulated SD·√n = 1.6439 (n=100, 200k reps) and 1.6456 (n=10000, 20k reps): constant, so SD ∝ 1/√n | confirmed |
| D5 | "slower than high-order deterministic quadrature but robust in higher-dimensional settings" | a general, standard statement (the rate does not depend on dimension); nothing in the animation tests it | confirmed (general fact, not animation-specific) |
| A1 | "Monte Carlo point-cloud estimator for π in the quarter-disk geometry" | frames show the point cloud in [0,1]² with the quarter arc | confirmed |
| A2 | "Frames follow the worked-example sample sizes n=100, 400, 1600, 6400, 10000" | `n_seq` line 9; Mathews Example 1 (`gr_33.gif`) reads "n = 100, 400, 1600, 6400, and 10000"; frames 2–6 show these n | confirmed |
| A3 | "reconstructed from Example 1 of Mathews' Monte Carlo Pi module" | archive Example 1 = "Use Monte Carlo simulation to approximate the number π", the same square/quarter-disk geometry (`gr_35.gif`) and the same n list | confirmed |
| A4 | "No archived animation GIF is available for this topic in the current snapshot" | no Monte Carlo files under `a2001/Animations/`; the module links no animation | confirmed |
| A5 | "Examples 2–7 … hit-or-miss … areas under curves (Examples 2–5), the area of a cardioid (Example 6) and the area of a region bounded by inequalities (Example 7), are not animated here" | archive: Ex 2–5 are integrals done with a "rectangular box enclosing the area", Ex 6 is the cardioid, Ex 7 is a "region defined by the constraints"; the page has no such animations | confirmed |
| C1 | Heading "Monte Carlo π Estimation, Quarter Unit Disk in [0,1]²" | script geometry and limits `xlims=(0,1), ylims=(0,1)` | confirmed |
| C2 | "After the opening frame (quarter circle only, no points)" | loop over `vcat(0, n_seq)`, with points only when `n > 0`; frame_001 shows only the arc, box and title | confirmed |
| C3 | "each frame adds points" | each frame plots the prefix `1:n` of one fixed sample, so the point sets are nested | confirmed |
| C4 | "green inside x²+y²≤1 and orange outside" | code lines 38–39; pixel check: in frame 6 the green pixels reach at most r = 1.0031 (none beyond 1.01) and the orange pixels at least r = 0.9981 (none inside 0.99); frame 2 gives 0.9952 and 1.0007. The differences are the size of one marker. | confirmed |
| C5 | "prints the estimate π̂_n" | frames show pi_hat = 2.92, 3.06, 3.175, 3.155625, 3.162, which match the computed values | confirmed |
| C6 | "which fluctuates but trends toward π as n increases" | errors 0.22159, 0.08159, 0.03341, 0.01403, 0.02041: the error rises at the last step, so the estimate fluctuates, while the overall trend is down | confirmed |
| C7 | "Each of these five frames also prints the standard error 4√(p(1−p)/n) with p=π/4" | line 51; frames show 0.164218, 0.082109, 0.041055, 0.020527, 0.016422 | confirmed |
| C8 | "(about 1.642/√n)" | 4√(π/4·(1−π/4)) = 1.64218336773632 (mpmath) | confirmed |
| C9 | "the standard deviation of π̂_n" | 4m/n with m ~ Bin(n, π/4) has SD 4√(p(1−p)/n); simulated SD 0.16439 against formula 0.16422 at n=100 | confirmed |
| C10 | "in this seeded run \|π−π̂_n\| is between 0.68 and 1.35 standard errors in each of them" | ratios 1.3494, 0.9937, 0.8137, 0.6836, 1.2427, so min 0.6836 → 0.68 and max 1.3494 → 1.35 | confirmed |
| W1 | `[Julia source](montecarlopiaa.jl)` | the file exists and is the only script | confirmed |
| W2 | embed `montecarlopiaa.gif` | the committed GIF is byte-identical to the scratch regeneration (md5 be33ae8e…) | confirmed |
| W3 | Alt text: "random points are classified by quarter-circle membership while the running estimate approaches pi as sample size increases" | classification is confirmed (C4); "running" is accurate because the frames use nested prefixes; "approaches" is accurate in trend (C6) | confirmed |
| W4 | 6 frames (opening + five) | `length(anim.frames)` = 6; manifest frame count 6 | confirmed |
| W5 | Page linked from section index | `pages/numerical-methods/index.qmd:108` | confirmed |

### 3. Implementation checks: `montecarlopiaa.jl`

**Method.** The script runs plain hit-or-miss Monte Carlo: uniform points in [0,1]², the indicator x²+y²≤1, and π̂ = 4m/n. It is the method named in the title and matches the Description's formula. Each frame uses the first n points of one seeded sample of 10000 (`Random.seed!(12345)`). It is therefore a running estimate along a single sequence rather than independent samples per n. The page's "each frame adds points" describes exactly this.

**Numbers.** I instrumented a scratch copy (`review/inst.jl`, GIF output disabled) and separately dumped the 10000 seeded points to `review/pts.txt` (`review/dump.jl`). I then recounted the points in Python (`/usr/bin/python3 -I review/indep.py review/pts.txt`), using mpmath π:

| n | script m / k | Python m / k | π̂ (both) | \|π−π̂\| | SE | ratio |
|---|---|---|---|---|---|---|
| 100 | 73 / 27 | 73 / 27 | 2.92 | 0.2215927 | 0.1642183 | 1.3494 |
| 400 | 306 / 94 | 306 / 94 | 3.06 | 0.0815927 | 0.0821092 | 0.9937 |
| 1600 | 1270 / 330 | 1270 / 330 | 3.175 | 0.0334073 | 0.0410546 | 0.8137 |
| 6400 | 5049 / 1351 | 5049 / 1351 | 3.155625 | 0.0140323 | 0.0205273 | 0.6836 |
| 10000 | 7905 / 2095 | 7905 / 2095 | 3.162 | 0.0204073 | 0.0164218 | 1.2427 |

The smallest |x²+y²−1| over all points is 2.8e-5, so no point is close enough to the boundary for rounding to change its classification.

**Reference values.** The only reference values are π (Julia's `pi`, exact to double precision) and the standard error. I checked the SE formula without relying on memory by simulation: the SD of 4m/n came out as 0.164386 at n=100 (200k reps) and 0.0164563 at n=10000 (20k reps). The formula gives 0.164218 and 0.0164218, which agree to Monte Carlo precision.

**Picture.** I viewed frames 1, 2, 4 and 6, plus annotation crops of frames 3, 5 and 6.
- Frame 1 shows only the arc, the box and the title.
- In frames 2–6, n, m, k, π̂, |π−π̂| and the SE all equal the table above to the 6 digits displayed.
- The arc is drawn from `cos θ, sin θ` for θ∈[0, π/2].
- The axes run exactly over [0,1]² with equal aspect, so nothing is clamped.
- The pixel test (`review/pix.py`) confirms that the plotted colour agrees with the disk test, to within one marker radius.
- The committed GIF is byte-identical to a fresh scratch run of the unchanged script.

The annotations overlap the points at large n but stay legible (see §1).

