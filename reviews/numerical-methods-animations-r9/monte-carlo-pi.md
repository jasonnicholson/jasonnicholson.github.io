# Monte Carlo Pi — animation review (round 9)

Page: `pages/numerical-methods/monte-carlo-pi/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** 0 Error, 0 Misleading, 0 Minor.

Considered and not reported:
- In frames 5 and 6 (n = 6400, 10000) the annotation block sits over the arc and the orange points. The text is still fully legible in the full-size frame (`committed/montecarlopiaa/frame_006.png`), so this is cosmetic, not misleading.
- The script draws nested samples (frame n uses the first n points of one seeded stream), whereas Mathews ran a separate simulation for each n. The page says "each frame adds points", which matches what the script does; this is a valid formulation, not a fidelity departure.
- Mathews prints an "order of error" π/√n; the page and script print the binomial standard error 4√(p(1−p)/n). Both are valid; the page states correctly which one it uses.
- Mathews Examples 2 to 7 are not animated, but the page says so explicitly and describes them correctly, so the omission is not silent.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `montecarlopiaa.jl` | 0 | 7.1 | montecarlopiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | samples random points uniformly in the unit square $[0,1]\times[0,1]$ | script l.13-14 `rand(max_n)` for x and y, uniform on [0,1); sample means 0.4967, 0.4981, corr 0.006 | confirmed |
| D2 | counts how many lie inside the quarter unit disk $x^2+y^2\le 1$ | script l.15 `xs.^2 .+ ys.^2 .<= 1.0` | confirmed |
| D3 | $\hat\pi_n = 4m/n$ | script l.42 `pi_hat = 4*m/n` | confirmed |
| D4 | stochastic error decreases on the order of $1/\sqrt n$ | SD of 4m/n is 4√(p(1−p)/n); simulation (200000 binomial draws): SD 0.16395 at n=100 vs formula 0.16422; 0.016435 at n=10000 vs 0.016422 | confirmed |
| D5 | slower than high-order deterministic quadrature but robust in higher dimensions | general statement, consistent with D4 | confirmed (general) |
| A1 | shows the Monte Carlo point-cloud estimator in the quarter-disk geometry | frames: quarter arc in unit square, point cloud | confirmed |
| A2 | Frames follow the worked-example sample sizes $n=100,400,1600,6400,10000$ | script l.9; archive gr_33 reads "n = 100, 400, 1600, 6400, and 10000" | confirmed |
| A3 | Julia source scripts linked under each case | `[Julia source](montecarlopiaa.jl)` under Case 1; file exists | confirmed |
| A4 | No archived animation GIF is available for this topic | `a2001/Animations/` has 20 entries, none Monte Carlo; n2003 module has only static graphics | confirmed |
| A5 | reconstructed from Example 1 of Mathews' Monte Carlo Pi module | Example 1 = "approximate π"; same n list, same quarter-disk picture (gr_35...gr_47) | confirmed |
| A6 | Examples 2–5 areas under curves, Example 6 cardioid, Example 7 region bounded by inequalities, same hit-or-miss method | archive module text: Ex 2-5 "approximate the integral", Ex 6 "area of the cardioid", Ex 7 "area of the region defined by the constraints", all under the hit-or-miss subroutine | confirmed |
| C1 | Heading: quarter unit disk in $[0,1]^2$ | xlims/ylims (0,1), arc θ∈[0,π/2] | confirmed |
| C2 | opening frame: quarter circle only, no points | frame_001: arc and box, no points (`n=0` branch skipped) | confirmed |
| C3 | each frame adds points | prefix `1:n` of one stream, n increasing; frames 2-6 | confirmed |
| C4 | green inside, orange outside | l.38-39 forestgreen = inside, darkorange = outside; frames show green under arc, orange above | confirmed |
| C5 | prints the estimate $\hat\pi_n$ | frames show pi_hat = 2.92, 3.06, 3.175, 3.155625, 3.162; independent Python on the same points gives m = 73, 306, 1270, 5049, 7905, hence the same values | confirmed |
| C6 | fluctuates but trends toward π as n increases | |π−π̂|: 0.2216, 0.0816, 0.0334, 0.0140, 0.0204 (decreasing overall, last one up) | confirmed |
| C7 | each of these five frames also prints the standard error | frames 2-6 show std error 0.164218, 0.082109, 0.041055, 0.020527, 0.016422 | confirmed |
| C8 | standard error $4\sqrt{p(1-p)/n}$, $p=\pi/4$ | script l.51 | confirmed |
| C9 | about $1.642/\sqrt n$ | 4√(π/4·(1−π/4)) = 1.642183 | confirmed |
| C10 | the standard deviation of $\hat\pi_n$ | binomial variance; simulation in D4 | confirmed |
| C11 | $|\pi-\hat\pi_n|$ between 0.68 and 1.35 standard errors in each frame | ratios 1.3494, 0.9937, 0.8137, 0.6836, 1.2427; min 0.68, max 1.35 | confirmed |
| C12 | "these five frames" / opening + five | GIF has 6 frames (manifest, frames dir) | confirmed |
| W1 | link and embed point at `montecarlopiaa.jl` / `montecarlopiaa.gif` | files exist; script writes that GIF; committed = regenerated byte-identical | confirmed |
| W2 | page linked from section index | `pages/numerical-methods/index.qmd` l.108 | confirmed |
| Alt | random points classified by quarter-circle membership; estimate fluctuates but trends toward π as sample size increases | as C4, C5, C6 | confirmed |

### 3. Implementation checks: `montecarlopiaa.jl`

- **Method.** Hit-or-miss Monte Carlo on the quarter disk: uniform points in [0,1)², indicator x²+y²≤1, π̂ = 4m/n. This is the method named in the title and Description, and the one Mathews' Example 1 uses.
- **Numbers.** `inst.jl` (same seed 12345, same `rand` calls) printed per n: m = 73, 306, 1270, 5049, 7905; k = 27, 94, 330, 1351, 2095; π̂ = 2.92, 3.06, 3.175, 3.155625, 3.162; |π−π̂| = 0.221593, 0.081593, 0.033407, 0.014032, 0.020407; SE = 0.164218, 0.082109, 0.041055, 0.020527, 0.016422. An independent numpy computation on the dumped points (`pts.csv`) gave identical m, π̂, errors, SE and ratios. Every value matches the annotations in frames 2-6 to the printed 6 decimals.
- **Reference values.** π is Julia's `pi`. The SE formula was checked by simulating the binomial estimator: 0.16395 against 0.16422 at n=100 and 0.016435 against 0.016422 at n=10000.
- **Picture.** The arc is (cos θ, sin θ), θ∈[0,π/2], which is the boundary of the test region. Scatter colours come from the same `inside` mask used for m. Axis limits [0,1]² contain all points, so nothing is clamped or hidden. The title "Monte Carlo Estimation of pi" is correct. The annotations report n, m, k=n−m, π̂, |π−π̂| and SE for the current n. Frames are 0, 100, 400, 1600, 6400, 10000 points. Annotation text overlaps points in the last two frames but stays legible.

