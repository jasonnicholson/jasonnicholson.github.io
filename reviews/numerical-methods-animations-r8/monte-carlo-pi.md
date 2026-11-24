# Monte Carlo Pi — animation review (round 8)

Page: `pages/numerical-methods/monte-carlo-pi/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0.

Things I considered and decided were not findings:
- Mathews draws inside points red and outside points green; the page uses green inside and orange outside. That is a colour choice, and the page describes its own colours correctly.
- Mathews prints an "order of error" of π/√n. The page prints the actual standard deviation 4√(p(1−p)/n) with p = π/4, which is a correct and labelled alternative.
- Mathews runs an independent simulation for each n. The script uses nested prefixes of one seeded sample of 10000. The page says "each frame adds points", which describes the script accurately.
- The intro says "Each animation below" although there is only one animation. This is trivial wording.
- In the n = 6400 and n = 10000 frames, the annotation text sits over dense points. I checked frames 5 and 6 at full size and every value is still readable.



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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | samples points uniformly in $[0,1]\times[0,1]$ | script lines 13–14: `rand(max_n)` for x and y; sample extrema x∈[0.00019,0.99994], y∈[2.7e-6,0.99999] | confirmed |
| D2 | counts points in quarter disk $x^2+y^2\le 1$ | line 15 uses `<= 1.0` | confirmed |
| D3 | $\hat\pi_n = 4m/n$ | line 42 | confirmed |
| D4 | error decreases on order $1/\sqrt{n}$ | standard CLT result. The script's own SE is 1.6422/√n | confirmed |
| A1 | "Frames follow the worked-example sample sizes n=100, 400, 1600, 6400, 10000" | `n_seq` on line 9. Archive Example 1 output (gr_36…gr_48) uses exactly n = 100, 400, 1600, 6400, 10000 | confirmed |
| A2 | "No archived animation GIF is available for this topic" | `find …/mathews/a2001 -iname '*monte*'` returns nothing. The n2003 module has only static graphics | confirmed |
| A3 | reconstructed from Example 1 of Mathews' module | archive Example 1 = "Use Monte Carlo simulation to approximate the number π", quarter-disk in unit square | confirmed |
| A4 | Examples 2–5 are areas under curves, 6 is cardioid area, 7 is region bounded by inequalities, all hit-or-miss, not animated | lnk_3,4,5,7 are "approximate the integral" (Examples 2–5). lnk_8 is the cardioid (Ex 6). lnk_9 is "region defined by the constraints" (Ex 7). The module's "Area Under a Curve" section describes hit-or-miss in a bounding box | confirmed |
| C1 | Heading: quarter unit disk in $[0,1]^2$ | script geometry, frames | confirmed |
| C2 | opening frame: quarter circle only, no points | frame_001.png. The loop starts at `n = 0` with no scatter | confirmed |
| C3 | each frame adds points | `idx = 1:n` uses nested prefixes of one sample | confirmed |
| C4 | green inside $x^2+y^2\le1$, orange outside | lines 38–39 (`forestgreen`, `darkorange`). Pixel check on frames 2, 4 and 6: green pixels have r ≤ 1.0024 and orange pixels have r ≥ 0.9975, where the marker radius is about 0.005 in data units | confirmed |
| C5 | prints the estimate $\hat\pi_n$ | frames show pi_hat = 2.92, 3.06, 3.175, 3.155625, 3.162. These match the independent recount | confirmed |
| C6 | estimate fluctuates but trends toward π | \|π−π̂\| = 0.2216, 0.0816, 0.0334, 0.0140, 0.0204. The overall trend is down, with a rise at the last frame | confirmed |
| C7 | five frames print std error $4\sqrt{p(1-p)/n}$, p=π/4 | line 51. Frames show 0.164218, 0.082109, 0.041055, 0.020527, 0.016422 | confirmed |
| C8 | "about $1.642/\sqrt{n}$" | 4√(π/4·(1−π/4)) = 1.642183 (Python) | confirmed |
| C9 | it is the standard deviation of $\hat\pi_n$ | Var(4·Bin(n,p)/n) = 16p(1−p)/n | confirmed |
| C10 | \|π−π̂_n\| is between 0.68 and 1.35 standard errors in each frame | ratios 1.349, 0.994, 0.814, 0.684, 1.243 | confirmed |
| C11 | six frames total (opening + five) | manifest: 6 frames. `vcat(0, n_seq)` | confirmed |
| W1 | `[Julia source](montecarlopiaa.jl)` | the file exists and is the only script | confirmed |
| W2 | embed `montecarlopiaa.gif` | the file exists and the script writes this name | confirmed |
| W3 | alt text: points classified by quarter-circle membership, estimate fluctuates but trends toward π | same as C4 and C6 | confirmed |

### 3. Implementation checks: `montecarlopiaa.jl`

**Is it the method it claims to be?** Yes. It is the hit-or-miss Monte Carlo estimator for π on the quarter disk: uniform points in the unit square, an indicator for $x^2+y^2\le1$, and $\hat\pi = 4m/n$. It is the same variant as Mathews Example 1, except that the script uses nested sample prefixes where Mathews uses independent runs per n.

**Are the numbers right?** Yes. I instrumented a copy (`review/instr.jl`, output in `review/instr.out`) that also recounts with `hypot`. I then dumped the 10000 seeded samples to `review/pts.txt` and recounted them independently in Python/numpy:

| n | m (script) | m (Python) | k | π̂ | \|π−π̂\| | SE | ratio |
|---|---|---|---|---|---|---|---|
| 100 | 73 | 73 | 27 | 2.92 | 0.221593 | 0.164218 | 1.349 |
| 400 | 306 | 306 | 94 | 3.06 | 0.081593 | 0.082109 | 0.994 |
| 1600 | 1270 | 1270 | 330 | 3.175 | 0.033407 | 0.041055 | 0.814 |
| 6400 | 5049 | 5049 | 1351 | 3.155625 | 0.014032 | 0.020527 | 0.684 |
| 10000 | 7905 | 7905 | 2095 | 3.162 | 0.020407 | 0.016422 | 1.243 |

I could not reproduce the random stream itself in Python, because Julia uses Xoshiro. The Python check therefore verifies the classification and the arithmetic on the exact samples Julia drew.

**Are the reference values right?** The only reference value is π (Julia `pi`). The SE constant 1.642183 matches the closed form computed independently in Python.

**Does the picture show what was computed?** Yes.
- The text annotations in frames 2–6 match the table above digit for digit, read from `committed/montecarlopiaa/frame_00{2..6}.png`.
- The arc is drawn as $(\cos\theta,\sin\theta)$ for $\theta\in[0,\pi/2]$, which is the unit quarter circle.
- The axes are fixed at [0,1]², so no points are clipped.
- The pixel-level classification check (C4) shows no green points outside the arc and no orange points inside it, within the marker radius.
- There are 6 frames at 2 fps, and the opening frame is empty as the page says.

