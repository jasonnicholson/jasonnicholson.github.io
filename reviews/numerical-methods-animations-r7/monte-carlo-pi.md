# Monte Carlo Pi — animation review (round 7)

Page: `pages/numerical-methods/monte-carlo-pi/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match, Minor: the alt text says the estimate "approaches pi", without the fluctuation the run shows

- **Location:** `index.qmd` line 39, image alt text: "...while the running estimate approaches pi as sample size increases".
- **What is there now:** an unqualified statement that the running estimate approaches $\pi$ as $n$ grows.
- **What is true:** the error falls over the first four sample sizes and then rises on the last step. The estimate moves away from $\pi$ between $n=6400$ and $n=10000$ (3.155625 to 3.162), and the error grows by a factor of 1.454.

  | n | 100 | 400 | 1600 | 6400 | 10000 |
  |---|---|---|---|---|---|
  | $\hat\pi_n$ | 2.92 | 3.06 | 3.175 | 3.155625 | 3.162 |
  | $\lvert\pi-\hat\pi_n\rvert$ | 0.221593 | 0.081593 | 0.033407 | 0.014032 | 0.020407 |

  The Behavior paragraph (line 35) gets this right ("fluctuates but trends toward $\pi$"). The alt text is the only description a screen-reader user receives, and it drops the qualification. The overall trend is real, so this is Minor.
- **How I know:** `julia inst.jl` and `/usr/bin/python3 indep.py` in the scratch folder (exact rational disk test on the exported points) agree on every value. `rate.py` prints the successive error ratios `[0.368, 0.409, 0.42, 1.454]`.
- **Suggested correction:** "...while the running estimate fluctuates but trends toward pi as sample size increases".

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `montecarlopiaa.jl` | 0 | 7.3 | montecarlopiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page text (line) | Evidence | Verdict |
|---|---|---|---|
| 1 | Samples "random points uniformly in the unit square $[0,1]\times[0,1]$" (12-13) | Lines 13-14 use `rand`. All 10000 points lie in the square. KS p: x 0.402, y 0.502. Correlation 0.0065. 10x10 chi-square p 0.756 | confirmed |
| 2 | Counts points in "the quarter unit disk $x^2+y^2\le 1$" (13-14) | Line 15. Exact rational test on all points disagrees with the float test 0 times (closest $\lvert r^2-1\rvert$ = 2.77e-5) | confirmed |
| 3 | $n$ sampled, $m$ satisfy the test (15) | Lines 35, 41: `m` counts inside points among the first `n` | confirmed |
| 4 | $\hat\pi_n = 4m/n$ (17) | Line 42; independent recount matches at all five $n$ | confirmed |
| 5 | Stochastic error "on the order of $1/\sqrt{n}$" (20) | Simulated SD log-log slope -0.508 over $n$=100..6400; binomial SD simulation agrees with $1.642/\sqrt n$ to within 0.4% | confirmed |
| 6 | "slower than high-order deterministic quadrature" (20) | Same integrand $4\sqrt{1-x^2}$ at $n$=10000: MC SE 1.64e-2, composite Simpson error 4.6e-7; Gauss-Legendre with 400 nodes 9.1e-9 | confirmed |
| 7 | "robust in higher-dimensional settings" (20) | SD slope stays near -1/2 for the orthant-ball test: -0.508 (d=2), -0.508 (d=6), -0.499 (d=10). The rate is dimension-independent. The constant is not: relative SE at $n$=10000 is 0.0052, 0.0337, 0.2001 for these d. The sentence is a general statement about the rate, so it stands | confirmed (rate) |
| 8 | "Monte Carlo point-cloud estimator" in "the quarter-disk geometry" (24-25) | Code and frames | confirmed |
| 9 | "Frames follow the worked-example sample sizes $n=100, 400, 1600, 6400, 10000$" (25-26) | Script line 9; frame annotations; archive `MonteCarloPiMod_gr_33.gif` reads "n = 100, 400, 1600, 6400, and 10000" | confirmed |
| 10 | Source scripts "linked under each case" (28) | Line 37 links `montecarlopiaa.jl`, which exists and generates the GIF | confirmed |
| 11 | "No archived animation GIF is available for this topic" (30) | 211 GIFs in the topic folder; only 2 are multi-frame, `constr00.gif` ("Under Construction" banner) and `constr01.gif` (decorative wheel icon). No Monte Carlo entry under `a2001/Animations` | confirmed |
| 12 | "reconstructed from Example 1 of Mathews' Monte Carlo Pi module" (30) | Archive `lnk_2` (Example 1): same quarter-disk test, same $n$ sequence, same n/m/k/approximation/error readout | confirmed |
| 13 | Examples 2-7 use "the same hit-or-miss method" (31) | Archive subroutines `gr_70` (`MonteCarloSimulation`) and `gr_158` (`MonteCarloArea`) both count points in the region and scale by the box area | confirmed |
| 14 | Examples 2-5 are "areas under curves" (31) | `gr_74`, `91`, `108`, `137`: definite integrals, run through `MonteCarloSimulation` | confirmed |
| 15 | Example 6 is "the area of a cardioid" (31) | `gr_159`, `gr_162`; the Example 6 heading names a cardioid | confirmed |
| 16 | Example 7 is "a region bounded by inequalities" (31) | `gr_180`, `gr_183` | confirmed |
| 17 | Examples 2-7 "are not animated here" (31) | One script, one GIF, one case | confirmed |
| 18 | Case 1 heading: quarter unit disk in $[0,1]^2$ (33) | Axes (0,1), arc from $\theta=0$ to $\pi/2$; arc pixels lie at radius 0.998-1.001 of the box | confirmed |
| 19 | "opening frame (quarter circle only, no points)" (35) | Frame 1 has 0 green and 0 orange pixels, and no annotation | confirmed |
| 20 | "each frame adds points" (35) | Prefix `1:n` of a fixed sample, so frames are nested. All marker centres of each frame are present in its expected colour | confirmed |
| 21 | "green inside $x^2+y^2\le 1$ and orange outside" (35) | Every expected point found in its colour at all five $n$ (e.g. 7905/7905 and 2095/2095). Every coloured pixel lies within 2.21 px of a point of its own class | confirmed |
| 22 | "prints the estimate $\hat\pi_n$" (35) | Frames read 2.92, 3.06, 3.175, 3.155625, 3.162, equal to the independent values | confirmed |
| 23 | Estimate "fluctuates but trends toward $\pi$ as $n$ increases" (35) | Error 0.2216, 0.0816, 0.0334, 0.0140, 0.0204: falls overall, non-monotone at the end | confirmed |
| 24 | "Each of these five frames also prints the standard error" (35) | Frames 2-6 show "std error" | confirmed |
| 25 | Standard error is $4\sqrt{p(1-p)/n}$, $p=\pi/4$ (35) | Line 51. Frame values 0.164218, 0.082109, 0.041055, 0.020527, 0.016422 equal the 30-digit mpmath values | confirmed |
| 26 | "about $1.642/\sqrt{n}$" (35) | $4\sqrt{p(1-p)} = 1.64218337$ | confirmed |
| 27 | That quantity is "the standard deviation of $\hat\pi_n$" (35) | $m\sim\text{Binomial}(n,p)$. Simulated SD 0.16369 vs 0.16422 at $n$=100; 0.016362 vs 0.016422 at $n$=10000 | confirmed |
| 28 | "$\lvert\pi-\hat\pi_n\rvert$ is between 0.68 and 1.35 standard errors in each of them" (35) | Ratios 1.34938, 0.99371, 0.81373, 0.68359, 1.24270. Range 0.684 to 1.349 | confirmed |
| 29 | "this seeded run" (35) | `Random.seed!(12345)` at line 12; regenerated GIF is byte-identical to the committed one | confirmed |
| 30 | Alt text: "random points are classified by quarter-circle membership" (39) | As entries 2 and 21 | confirmed |
| 31 | Alt text: "the running estimate approaches pi as sample size increases" (39) | Error rises from 0.014032 to 0.020407 on the last step | **wrong as stated, Minor (F1)** |
| 32 | Wiring: link and embed are this case (37, 39) | Both name `montecarlopiaa`. Manifest: 1 script, 1 GIF, byte-identical on regeneration. Section index line 108 links `monte-carlo-pi/` | confirmed |

Frame annotations against independent values:

| n | m (frame / indep) | k (frame / indep) | $\hat\pi$ (frame / indep) | error (frame / indep) | SE (frame / indep) |
|---|---|---|---|---|---|
| 100 | 73 / 73 | 27 / 27 | 2.92 / 2.92 | 0.221593 / 0.22159265 | 0.164218 / 0.16421834 |
| 400 | 306 / 306 | 94 / 94 | 3.06 / 3.06 | 0.081593 / 0.081592654 | 0.082109 / 0.082109168 |
| 1600 | 1270 / 1270 | 330 / 330 | 3.175 / 3.175 | 0.033407 / 0.033407346 | 0.041055 / 0.041054584 |
| 6400 | 5049 / 5049 | 1351 / 1351 | 3.155625 / 3.155625 | 0.014032 / 0.014032346 | 0.020527 / 0.020527292 |
| 10000 | 7905 / 7905 | 2095 / 2095 | 3.162 / 3.162 | 0.020407 / 0.020407346 | 0.016422 / 0.016421834 |

---

### 3. Implementation checks: `montecarlopiaa.jl`

**It is the method it claims to be.** Hit-or-miss Monte Carlo on the quarter disk: two independent uniform samples (lines 13-14), the disk test (line 15), $\hat\pi = 4m/n$ (line 42). The frames use nested prefixes of one sample, which matches Mathews' method. His examples draw a fresh sample for each $n$; using one running sample is a valid variant, and the page's "adds points" describes it correctly.

**The numbers are right.** `inst.jl` exported the 10000 points at full precision. `indep.py` reclassified them with exact rational arithmetic and recomputed $m$, $\hat\pi$, the error and the SE with mpmath. All values agree (table above). The test is not sensitive to floating-point rounding: 0 disagreements between exact and float classification. The realized counts are unremarkable for Binomial$(n,\pi/4)$: two-sided p-values 0.181, 0.330, 0.429, 0.503, 0.219.

**Its reference values are right.** The reference is Julia's `pi`. The SE formula uses the true $p=\pi/4$, as the page states. Its value and its role as the SD of $\hat\pi_n$ were checked against 30-digit evaluation and simulated binomial and geometric sampling.

**The picture shows what was computed.**
- Frame 1 has no markers; frames 2-6 show the expected sets.
- `pixelmap.py` mapped each exported point to pixels: every expected point appears in its class colour, in every frame, and no coloured pixel lies more than 2.21 px from a point of its own class (the marker radius).
- `framecheck.py`: the arc lies at radius 0.998-1.001 of the plot box. Green extends to at most 1.0032 and orange down to at least 0.9963, which is marker radius around the arc.
- Annotations were read from enlarged crops of frames 2-6 and match the table. The text overlaps the markers and the arc in the dense frames but stays legible, so this is not a finding.
- No clamping, masking or hidden range. Axes are exactly the unit square.

**Could not determine:** nothing material. Claim 7 was checked for the rate only, since "robust" is qualitative.

