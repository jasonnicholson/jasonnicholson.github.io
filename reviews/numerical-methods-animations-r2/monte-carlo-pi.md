# Monte Carlo Pi — animation review (round 2)

Page: `pages/numerical-methods/monte-carlo-pi/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: archive Examples 2–7 of the Mathews module are not carried over, and the page does not say so

- **Location:** `index.qmd` line 38: "No archived animation GIF is available for this topic in the current snapshot, so this animation is reconstructed from the module examples." The page has a single case (Case 1), which is Mathews' Example 1.
- **What is there now:** The page has one case, the quarter-disk estimate of π. It says it was "reconstructed from the module examples" (plural).
- **What the archive has:** `montecarlopimod.html` has seven examples. Example 1 is the π estimate (solution in `MonteCarloPiMod_lnk_2.html`). Examples 2–5 use hit-or-miss Monte Carlo to approximate integrals under curves (`lnk_3`–`lnk_5`, `lnk_7`). A Question/Answer compares the accuracy of Examples 2–4 (`lnk_6`). Example 6 is the area of a cardioid (`lnk_8`) and Example 7 is the area of a region defined by inequalities (`lnk_9`). None of these appear on this page. The site's other Monte Carlo page, `pages/numerical-methods/monte-carlo-integration.qmd`, is a placeholder ("Worked Example (Planned)"), so they are not covered anywhere else on the site either.
- **How I know:** I stripped the solution pages to text with `sed 's/<[^>]*>//g' MonteCarloPiMod_lnk_N.html` for N=2..9 (the headings are quoted above), and ran `grep -n -i 'example' monte-carlo-integration.qmd`, which returned only the "Planned" heading.
- **Why only Minor:** The page title is "Monte Carlo Pi", and the dropped examples are area and integral applications of the same hit-or-miss idea. They arguably belong on the Monte Carlo integration page. The concrete problem is that the sentence on line 38 suggests the page draws on the module's examples generally, when in fact it reproduces only Example 1.
- **Suggested correction:** Change line 38 to name the source precisely, e.g. "…so this animation is reconstructed from Example 1 of the module (sample sizes $n=100,\dots,10000$). The module's Examples 2–7 (hit-or-miss areas under curves, a cardioid, and a region bounded by inequalities) are not animated here." Alternatively, add those cases here or to `monte-carlo-integration`.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `montecarlopiaa.jl` | 0 | 6.0 | montecarlopiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Each claim is quoted in the page's own words. Evidence: the instrumented run (`review/instr.jl`), an independent numpy recount from the dumped points (`review/pts.csv`), a numpy sampling-distribution simulation, a pixel classification of every frame (`review/pix.py`), and the archive images.

| # | Claim (page text) | Location | Verdict | Evidence |
|---|---|---|---|---|
| D1 | "samples random points uniformly in the unit square $[0,1]\times[0,1]$" | Description, l.12–13 | Confirmed | `xs = rand(max_n)`, `ys = rand(max_n)` (uniform on [0,1)). Dumped points range from 2.7e-6 to 0.99999 |
| D2 | "counts how many lie inside the quarter unit disk $x^2+y^2\le 1$" | l.13–14 | Confirmed | script l.15 `xs.^2 .+ ys.^2 .<= 1.0` (non-strict, as stated) |
| D3 | "$\hat\pi_n = 4\frac{m}{n}$" | l.16–18 | Confirmed | script l.42 `pi_hat = 4*m/n` |
| D4 | "stochastic error decreases on the order of $1/\sqrt{n}$" | l.20 | Confirmed | Simulated std of $\hat\pi_n$ over 4000 replications: 0.1637, 0.0818, 0.0405, 0.0206, 0.0165 for n=100, 400, 1600, 6400, 10000. That halves each time n is quadrupled and matches $1.642/\sqrt n$ |
| D5 | "slower than high-order deterministic quadrature but robust in higher-dimensional settings" | l.20 | Confirmed (qualitative, standard) | The rate does not depend on dimension. Not tested numerically |
| A1 | "Monte Carlo point-cloud estimator for $\pi$ in the quarter-disk geometry" | l.24–25 | Confirmed | frames show the point cloud in $[0,1]^2$ with the quarter arc |
| A2 | "Frames follow the worked-example sample sizes $n=100, 400, 1600, 6400, 10000$" | l.25–26 | Confirmed | script `n_seq = [100, 400, 1600, 6400, 10000]`. Frame annotations show these n in this order. Archive Solution 1 (`gr_33`) reads "n = 100, 400, 1600, 6400, and 10000" |
| A3 | "Julia source scripts that generated these animations are linked under each case" | l.28 | Confirmed | `[Julia source](montecarlopiaa.jl)` resolves. Regenerated GIF is byte-identical to the committed one |
| H1 | Heading: "Monte Carlo $\pi$ Estimation, Quarter Unit Disk in $[0,1]^2$" | l.30 | Confirmed | as D1/D2 |
| B1 | "After the opening frame (quarter circle only, no points)" | l.32 | Confirmed | frame_001 has the arc and box and no points (`n=0` branch skipped) |
| B2 | "each frame adds points" | l.32 | Confirmed | frame k plots `idx = 1:n`, a prefix of one fixed sequence, so each frame keeps the earlier points and adds new ones |
| B3 | "green inside $x^2+y^2\le 1$ and orange outside" | l.32 | Confirmed | Pixel check on frames 2–6: 0 green pixels with r>1.01 and 0 orange pixels with r<0.99 (green/orange pixel totals 577/216 … 56528/14688) |
| B4 | "prints the estimate $\hat\pi_n$" | l.32 | Confirmed | annotation `pi_hat = …` in frames 2–6 |
| B5 | "which fluctuates but trends toward $\pi$ as $n$ increases" | l.32 | Confirmed | $\hat\pi_n$ = 2.92, 3.06, 3.175, 3.155625, 3.162. $|\pi-\hat\pi_n|$ = 0.2216, 0.0816, 0.0334, 0.0140, 0.0204. The error falls overall but rises at the last step, which "fluctuates" covers |
| B6 | "Each of these five frames also prints the standard error" | l.32 | Confirmed | `std error = …` in frames 2–6, five frames after the opening one (6 frames in total) |
| B7 | "$4\sqrt{p(1-p)/n}$ with $p=\pi/4$" | l.32 | Confirmed | script l.51. This is the exact std of $4\,\mathrm{Bin}(n,p)/n$. Simulated std agrees (D4 row) |
| B8 | "(about $1.642/\sqrt{n}$)" | l.32 | Confirmed | $4\sqrt{(\pi/4)(1-\pi/4)} = 1.642183$ |
| B9 | "the standard deviation of $\hat\pi_n$" | l.32 | Confirmed | as B7 |
| B10 | "in this seeded run $\lvert\pi-\hat\pi_n\rvert$ is between 0.68 and 1.35 standard errors in each of them" | l.32 | Confirmed | ratios 1.3494, 0.9937, 0.8137, 0.6836, 1.2427. Min 0.684 and max 1.349 round to 0.68 and 1.35 |
| W1 | Source link `montecarlopiaa.jl` belongs to this case | l.34 | Confirmed | only script. It produces `montecarlopiaa.gif` |
| W2 | Embed `montecarlopiaa.gif` | l.36 | Confirmed | committed GIF is byte-identical to the scratch regeneration |
| I1 | Alt text: "Monte Carlo Pi animation in the unit square: random points are classified by quarter-circle membership while the running estimate approaches pi as sample size increases" | l.36 | Confirmed | as B3/B5. The overall trend is toward π, with the small rise at n=10000 noted in B5 |
| L1 | "No archived animation GIF is available for this topic in the current snapshot" | l.38 | Confirmed | `a2001/Animations/` (20 files) has no Monte Carlo GIF. The n2003 module has only static images |
| L2 | "this animation is reconstructed from the module examples" | l.38 | Confirmed in part, see F1 | The sample sizes and the inside/outside picture match Example 1 (`gr_33`–`gr_48`). Examples 2–7 are not reproduced |

Frame-content claims not stated on the page but prominent in the GIF were also checked against my recount. Frame annotations n / m / k / π̂ / |π−π̂| / std error:
- 100 / 73 / 27 / 2.92 / 0.221593 / 0.164218
- 400 / 306 / 94 / 3.06 / 0.081593 / 0.082109
- 1600 / 1270 / 330 / 3.175 / 0.033407 / 0.041055
- 6400 / 5049 / 1351 / 3.155625 / 0.014032 / 0.020527
- 10000 / 7905 / 2095 / 3.162 / 0.020407 / 0.016422

All match the numpy recount from the dumped points exactly. The title "Monte Carlo Estimation of pi" is consistent with the page.

---

### 3. Implementation checks: `montecarlopiaa.jl`

**It is the method claimed.** It is plain hit-or-miss Monte Carlo: n i.i.d. uniform points in $[0,1)^2$, the count m with $x^2+y^2\le1$, and $\hat\pi=4m/n$. That is the estimator in the Description and the one in Mathews' `MonteCarloPi` subroutine (`gr_30`: `If[d ≤ 1, Pin = …]`, `approx = ρ*4.0`). The nested sample sizes reuse one stream of 10000 points, so each frame is a prefix of the next. This is the "points are added" behaviour the page describes, and it is a legitimate presentation (Mathews drew fresh samples per n, which is not a mathematical difference).

**The numbers are right.**
- Instrumented copy `review/instr.jl` (Julia 1.12.2, `Random.seed!(12345)`, same `rand` calls as the script) printed the per-n values tabulated above and dumped all 10000 points to `review/pts.csv`.
- I recounted independently in numpy (`python3 -I`) from the dumped points: m = 73, 306, 1270, 5049, 7905, identical. π̂, |π−π̂| and the standard error agree to every printed digit.
- Property check of the standard-error formula: 4000 numpy replications per n (independent RNG) gave mean π̂ of 3.1397, 3.1432, 3.1416, 3.1410, 3.1414 (unbiased within noise). The sample std was 0.16371, 0.081781, 0.040463, 0.020567, 0.016499, against the formula's 0.164218, 0.082109, 0.041055, 0.020527, 0.016422.

**Reference values are right.** The only reference is Julia's `pi`, used both for |π−π̂| and inside the standard error ($p=\pi/4$). Using the true p for a theoretical standard deviation is correct and is what the page states. The constant 1.642 = $4\sqrt{(\pi/4)(1-\pi/4)}$ = 1.642183.

**The picture shows what was computed.**
- The arc is `(cos θ, sin θ)` for θ in [0, π/2], the unit quarter circle centred at the origin. Axes are fixed at [0,1]², `aspect_ratio=:equal`, and the box edges are drawn.
- I pixel-mapped the plot box from the empty opening frame (x: 50→606.5 px, y: 594.5→38 px). On every frame no green pixel lies outside r=1.01 and no orange pixel lies inside r=0.99, so the colours follow the disk test.
- There are 6 frames: n = 0, 100, 400, 1600, 6400, 10000, in that order, at fps=2. No clamping or masking is used.
- On frames 5–6 the black annotation text (no background box) sits on top of the dense point cloud. I could still read every value at full resolution (`committed/montecarlopiaa/frame_005.png`, `frame_006.png`). This is cosmetic and not a finding, but a white text background would help.

**Reproducibility note.** The quoted "seeded run" values depend on Julia's default RNG stream. The committed GIF and a fresh run on this machine (Julia 1.12.2) are byte-identical. A future Julia release that changes the default RNG would change the frames and could invalidate the "0.68 to 1.35 standard errors" sentence. This is not a current error.

