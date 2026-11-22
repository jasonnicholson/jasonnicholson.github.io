# Monte Carlo Pi — animation review (round 3)

Page: `pages/numerical-methods/monte-carlo-pi/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0.

Every checkable claim on the page was confirmed against computation I ran myself (see ledger). One observation that I judged *not* to be a finding: in the n = 6400 and n = 10000 frames the six-line annotation block (x = 0.62, y = 0.70–0.95) sits on top of the dense point cloud and the arc. I viewed `frame_005.png` and `frame_006.png` at full size and every value is still legible, so per the review standard this is cosmetic and not reported.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `montecarlopiaa.jl` | 0 | 7.0 | montecarlopiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.12–13 | samples random points uniformly in the unit square $[0,1]\times[0,1]$ | script l.13–14 `rand(max_n)` for x and y (uniform on [0,1)); extrema x ∈ (0.000186, 0.99994), y ∈ (2.7e-6, 0.99999) | confirmed |
| 2 | Description l.13–14 | counts how many lie inside the quarter unit disk $x^2+y^2\le 1$ | script l.15 `xs.^2 .+ ys.^2 .<= 1.0`; nearest point to the boundary has $|x^2+y^2-1| = 2.8\times10^{-5}$, so ≤ vs < is immaterial | confirmed |
| 3 | Description l.15–18 | $\hat\pi_n = 4m/n$ | script l.42 `pi_hat = 4 * m / n` | confirmed |
| 4 | Description l.20 | stochastic error decreases on the order of $1/\sqrt n$ | standard result (binomial variance $p(1-p)/n$); script's own std error scales exactly as $1/\sqrt n$ (0.1642, 0.0821, 0.0411, 0.0205, 0.0164 for n×4 → ÷2) | confirmed |
| 5 | Description l.20 | slower than high-order deterministic quadrature but robust in higher dimensions | general, qualitative, standard; not contradicted by anything on the page | confirmed (general statement) |
| 6 | Animations intro l.24–25 | shows the Monte Carlo point-cloud estimator for $\pi$ in the quarter-disk geometry | frames show unit square, quarter arc, classified points, $\hat\pi$ readout | confirmed |
| 7 | Animations intro l.25–26 | Frames follow the worked-example sample sizes $n=100, 400, 1600, 6400, 10000$ | script l.9 `n_seq`; frame readouts n = 100/400/1600/6400/10000; archive Solution 1 (gr_33) reads "n = 100, 400, 1600, 6400, and 10000" | confirmed |
| 8 | l.28 | Julia source scripts linked under each case | l.34 `[Julia source](montecarlopiaa.jl)` exists in folder | confirmed |
| 9 | Case 1 heading l.30 | Monte Carlo $\pi$ estimation, quarter unit disk in $[0,1]^2$ | xlims/ylims (0,1), arc θ∈[0,π/2] radius 1 (l.17–19, 22) | confirmed |
| 10 | Behavior l.32 | opening frame: quarter circle only, no points | `vcat(0, n_seq)` with `if n > 0` guard; frame_001.png shows only box + arc | confirmed |
| 11 | Behavior l.32 | each frame adds points | points are prefixes `1:n` of one fixed 10000-point stream, so each frame is a superset of the previous | confirmed |
| 12 | Behavior l.32 | green inside $x^2+y^2\le1$, orange outside | l.38–39 forestgreen/darkorange; pixel test on frames 2–6 (axis box 50–606 px × 38–594 px): 0 orange pixels with r < 0.985 (of 208/699/2452/9407/14187) and 0 green pixels with r > 1.015 (of 577/2403/9734/36996/55886) | confirmed |
| 13 | Behavior l.32 | prints the estimate $\hat\pi_n$ | readout `pi_hat = ` 2.92, 3.06, 3.175, 3.155625, 3.162 in frames 2–6 | confirmed |
| 14 | Behavior l.32 | $\hat\pi_n$ fluctuates but trends toward $\pi$ as $n$ increases | $|\pi-\hat\pi_n|$ = 0.221593, 0.081593, 0.033407, 0.014032, 0.020407: decreasing trend, with a fluctuation up at n = 10000; estimate crosses from below to above $\pi$ between n = 400 and 1600 | confirmed |
| 15 | Behavior l.32 | each of these five frames also prints the standard error | l.51–52; "std error = …" visible in frames 2–6 | confirmed |
| 16 | Behavior l.32 | standard error $4\sqrt{p(1-p)/n}$ with $p=\pi/4$ | l.51 `4*sqrt((pi/4)*(1-pi/4)/n)` | confirmed |
| 17 | Behavior l.32 | about $1.642/\sqrt n$ | mpmath: $4\sqrt{p(1-p)} = 1.64218336773632$ | confirmed |
| 18 | Behavior l.32 | the standard deviation of $\hat\pi_n$ | $m\sim\text{Bin}(n,\pi/4)$ ⇒ $\operatorname{sd}(4m/n)=4\sqrt{p(1-p)/n}$; values printed match mpmath to 6 d.p. (0.164218, 0.082109, 0.041055, 0.020527, 0.016422) | confirmed |
| 19 | Behavior l.32 | in this seeded run $|\pi-\hat\pi_n|$ is between 0.68 and 1.35 standard errors in each of them | err/se = 1.3494, 0.9937, 0.8137, 0.6836, 1.2427; min 0.6836 → 0.68, max 1.3494 → 1.35 | confirmed |
| 20 | Link l.34 | Julia source → `montecarlopiaa.jl` | file present, is the script that produces the embedded GIF | confirmed |
| 21 | Embed l.36 | GIF `montecarlopiaa.gif` is this case | produced by `montecarlopiaa.jl`; byte-identical on regeneration | confirmed |
| 22 | Alt text l.36 | random points are classified by quarter-circle membership while the running estimate approaches pi as sample size increases | see #12, #14 (nested samples, so "running" is apt) | confirmed |
| 23 | l.38 | No archived animation GIF is available for this topic | only animated GIFs in `n2003/montecarlopi/**` are `constr00.gif` (288×40, 4 frames) and `constr01.gif` (108×70, 2 frames), "under construction" banners used by `MonteCarloPiProg.html`; nothing for Monte Carlo in `a2001/Animations/` | confirmed |
| 24 | l.38 | reconstructed from Example 1 of Mathews' module | Example 1 = "Use Monte Carlo simulation to approximate the number π", Solution 1 (lnk_2) uses the same n sequence, quarter arc in the unit square, inside/outside colouring | confirmed |
| 25 | l.39 | Examples 2–7 use the same hit-or-miss counting method: areas under curves (2–5), cardioid area (6), region bounded by inequalities (7); not animated | module text: "Area Under a Curve" section (Examples 2–5, ratio of points in the box that lie under the curve), Example 6 "area of the cardioid", Example 7 "area of the region defined by the constraints"; page has only Case 1 | confirmed |
| 26 | Section index | page linked from numerical-methods index | `pages/numerical-methods/index.qmd` l.108 `[Monte Carlo Pi](monte-carlo-pi/)` | confirmed |

Counts: 1 case, 1 script, 1 GIF, 6 frames (1 opening + 5 sample sizes): consistent with "these five frames".

### 3. Implementation checks: `montecarlopiaa.jl`

**It is the method it claims to be.** Plain hit-or-miss Monte Carlo on the quarter disk: n uniform points in [0,1)², count m with $x^2+y^2\le1$, $\hat\pi=4m/n$. Variant note: the five sample sizes are nested prefixes of one 10000-point seeded stream (`Random.seed!(12345)`), not independent draws per n as in Mathews' `MonteCarloResults[n]` (each call draws fresh points). The page describes it as cumulative ("each frame adds points"), so the page matches the variant actually run.

**The numbers are right.** Instrumented copy (`review/instr.jl`) and an independent recount: the 10000 points were dumped by a separate Julia script (`review/dump.jl` → `review/pts.txt`) and the hits were counted in Python/numpy.

| n | script m | numpy m | script k | numpy k | script π̂ | numpy π̂ | script \|π−π̂\| | numpy \|π−π̂\| |
|---|---|---|---|---|---|---|---|---|
| 100 | 73 | 73 | 27 | 27 | 2.92 | 2.92 | 0.221593 | 0.2215927 |
| 400 | 306 | 306 | 94 | 94 | 3.06 | 3.06 | 0.081593 | 0.0815927 |
| 1600 | 1270 | 1270 | 330 | 330 | 3.175 | 3.175 | 0.033407 | 0.0334073 |
| 6400 | 5049 | 5049 | 1351 | 1351 | 3.155625 | 3.155625 | 0.014032 | 0.0140323 |
| 10000 | 7905 | 7905 | 2095 | 2095 | 3.162 | 3.162 | 0.020407 | 0.0204073 |

The GIF readouts (frames 2–6) show exactly the script values above. Limitation: the random stream itself is Julia's (Xoshiro, Julia 1.12.2); I did not reproduce the RNG outside Julia, but the counting, the estimator and the error are independently verified, and the committed GIF regenerates byte-identically on this machine.

**Its reference values are right.** The only reference value is $\pi$ (Julia `pi`, exact to Float64) and the standard error $4\sqrt{p(1-p)/n}$, $p=\pi/4$. mpmath gives 0.164218336773632, 0.0821091683868162, 0.0410545841934081, 0.0205272920967041, 0.0164218336773632 for the five n; the script prints 0.164218, 0.082109, 0.041055, 0.020527, 0.016422. This is the exact standard deviation of the binomial estimator. (Mathews instead prints "order of error $\pi/\sqrt n$", a cruder scale; the page's departure is to a correct, sharper quantity and is explained on the page, so it is not a fidelity finding.)

**The picture shows what was computed.** Viewed frames 1, 2, 6 at full size and all six on the contact sheet. Frame 1: unit-square box and quarter arc from (1,0) to (0,1), no points, no annotations. Frames 2–6: points drawn from `xs[1:n], ys[1:n]`, split by the same `inside` mask used for m; pixel test shows no orange marker centred inside the arc and no green outside it (table entry #12). Annotations report n, m, k = n − m, π̂, |π − π̂| and std error with the right values for that n. Axis limits [0,1]² show the whole sample domain; no clamping or masking. Title "Monte Carlo Estimation of pi" is accurate. `aspect_ratio=:equal` makes the arc circular. Readout text overlaps the point cloud in the last two frames but remains legible (not a finding).

### Fidelity to the legacy archive

Example 1 of the archive (Solution 1): same problem, same five sample sizes, same geometry (quarter arc in the unit square, inside/outside points in two colours). Differences: nested rather than independent samples (described correctly on the page), different colours (not a finding), and a true standard error instead of Mathews' "order of error π/√n" (a correct improvement). Examples 2–7 are not animated and the page says so explicitly and describes them accurately. No fidelity findings.

