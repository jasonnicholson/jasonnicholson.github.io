# Secant Method — animation review (round 6)

Page: `pages/numerical-methods/secant-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, every script's iterates, and every frame I inspected agree with the independent computation. Details are in the ledger and the implementation checks below.

Non-findings noted for the owner (not errors, no action needed):
- `secantmethoddd.jl` lines 32-36: the early `break` would leave entries of `ps` (allocated `undef`) uninitialised if it fired before the last loop index, and the frames would then plot garbage. With the current parameters it fires only at `i = 17 = n_iters+1`, the last iteration (|p17 - p16| = 6.2e-10 < 1e-8; |p16 - p15| = 2.4e-6 does not trigger it), so all 18 entries are set and the GIF is correct. A latent fragility only if `n_iters` is raised. `n_iters_actual` is unused.
- `secantmethodee.jl` emits a soft-scope warning for `n_valid`; the variable is unused for plotting, output unaffected.
- `secantmethodaa.jl` frame 9: the secant through p8 and p9 (which differ by 2.7e-15 in double precision) is drawn only because |f(p9) - f(p8)| = 1.33e-14 just exceeds the 1e-14 guard. The drawn slope (about 4.9) agrees with f'(root) = 3e^r + 4 sin r = 4.88, so the picture is right.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `secantmethodaa.jl` | 0 | 8.4 | secantmethodaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodbb.jl` | 0 | 9.6 | secantmethodbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodcc.jl` | 0 | 5.6 | secantmethodcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethoddd.jl` | 0 | 6.7 | secantmethoddd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodee.jl` | 0 | 4.6 | secantmethodee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `secantmethodff.jl` | 0 | 4.3 | secantmethodff.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `secantmethodaa.gif` | 9 | byte-identical | secantmethodaa |
| `secantmethodbb.gif` | 28 | byte-identical | secantmethodbb |
| `secantmethodcc.gif` | 7 | byte-identical | secantmethodcc |
| `secantmethoddd.gif` | 16 | byte-identical | secantmethoddd |
| `secantmethodee.gif` | 9 | byte-identical | secantmethodee |
| `secantmethodff.gif` | 6 | byte-identical | secantmethodff |

### Page references

- Scripts linked: `secantmethodaa.jl`, `secantmethodbb.jl`, `secantmethodcc.jl`, `secantmethoddd.jl`, `secantmethodee.jl`, `secantmethodff.jl`
- GIFs embedded: 6
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Page: `index.qmd`. The page has no Description section; the Animations section is the whole body.

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| I1 | Intro | secant line drawn through the two most recent iterates (p_{n-1}, f(p_{n-1})) and (p_n, f(p_n)); its x-intercept becomes p_{n+1} | All six scripts: `pa=ps[frame]`=p_{frame-1}, `pb=ps[frame+1]`=p_frame, secant slope (fb-fa)/(pb-pa), diamond at `ps[frame+2]`=p_{frame+1}; frames show the line crossing the axis at the diamond (e.g. aa f1 at 0.45575, dd f5 at 3.1639) | confirmed |
| I2 | Intro | no derivative is required; slope from two function evaluations | Update formula in all scripts uses only f values | confirmed |
| I3 | Intro | can converge quickly, converge slowly near repeated roots, oscillate while converging, or diverge | Cases 1, 2, 3/6, 5 respectively (see below) | confirmed |
| I4 | Intro | Julia source scripts linked under each case | six links, aa..ff, each under its case | confirmed |
| C1.1 | Case 1 heading | f(x)=3e^x-4cos x, p0=1.0, p1=0.9 | `secantmethodaa.jl` l.10-12; GIF title | confirmed |
| C1.2 | Case 1 | converges quickly to the root near x ≈ 0.2549 | root 0.254850059028850 (mpmath findroot); script p10 = 0.2548500590288503 | confirmed |
| C1.3 | Case 1 | both starting points on the same side of the root; function well-behaved | 1.0, 0.9 > 0.2549; f'>0, f''>0 on [0,1] | confirmed |
| C1.4 | Case 1 | first secant step lands at p2 ≈ 0.456, still 0.20 from root | p2 = 0.455750754, error 0.2009 (script and mpmath agree) | confirmed |
| C1.5 | Case 1 | errors 0.066 at p3, 0.0089 at p4, 4.4e-4 at p5, 3.1e-6 at p6 | mpmath: 0.06588, 0.00891, 4.435e-4, 3.115e-6 | confirmed |
| C1.6 | Case 1 | consistent with order ≈ 1.618 at this simple root | ln e_{n+1}/ln e_n for n=4..7: 1.64, 1.64, 1.63, 1.63; f'(r)=4.88≠0, f''(r)≠0 | confirmed |
| C1.7 | Case 1 alt | secant line through two iterates, x-intercept converges rapidly to root near x=0.2549 | frames 1-9 | confirmed |
| C1.8 | Case 1 wiring | link `secantmethodaa.jl`, embed `secantmethodaa.gif` | committed GIF byte-identical to scratch regeneration (manifest); title matches | confirmed |
| C2.1 | Case 2 heading | f=1-10x+25x², p0=1.0, p1=0.9 | `secantmethodbb.jl` l.12-14 | confirmed |
| C2.2 | Case 2 | (1-5x)² has a double root at 0.2 where f'(0.2)=0 | algebra; f'(x)=50x-10 | confirmed |
| C2.3 | Case 2 | converges, but only linearly | error ratio sequence 0.533, 0.652, 0.605, 0.623, ... → 0.61803 | confirmed |
| C2.4 | Case 2 | f(x)=25(x-0.2)² | expand: 25x²-10x+1 | confirmed |
| C2.5 | Case 2 | ratio of successive errors settles at (√5-1)/2 ≈ 0.618 | mpmath ratio 0.61803 from p12 on; also analytically e_{n+1}=e_n e_{n-1}/(e_n+e_{n-1}) ⇒ r=1/(1+r) | confirmed |
| C2.6 | Case 2 | each step removes only about 38% of the remaining error; iterates creep over many iterations | 1-0.618=0.382; after 28 frames p29 = 0.20000088 (error 8.8e-7) | confirmed |
| C2.7 | Case 2 alt | iterates slowly approach the double root at x=0.2, linear convergence | frames 1-28; last legend p29 = 0.20000088 (mpmath 0.2000008835) | confirmed |
| C2.8 | Case 2 wiring | bb script / bb GIF | byte-identical regen; title "1 − 10x + 25x² (double root)" | confirmed |
| C3.1 | Case 3 heading | f=arctan x, p0=1.35, p1=1.30 | `secantmethodcc.jl` l.15-17 | confirmed |
| C3.2 | Case 3 | converges to root at x=0 | iterates → 0 | confirmed |
| C3.3 | Case 3 | iterates oscillate, jumping to the opposite side of the root each step before settling | signs p2..p8 (exact): -, +, -, +, -, +, -; alternate on every step to convergence ("before settling" read as "while converging") | confirmed |
| C3.4 | Case 3 | flat slope near the starting points makes the first secant overshoot to negative x | p2 = -1.22138 | confirmed |
| C3.5 | Case 3 | animation ends at p8 | n_iters=7 ⇒ frame 7 shows p8; GIF has 7 frames, last legend "p8 = 0 (double-precision result)" | confirmed |
| C3.6 | Case 3 | p8 returned by double precision as exactly 0 | instrumented script: p8 = 0.0 | confirmed |
| C3.7 | Case 3 | p6 ≈ -6.9e-12, p7 ≈ 4.8e-25 | script -6.88865e-12, 4.79829e-25; mpmath -6.88865e-12, 4.80018e-25 | confirmed |
| C3.8 | Case 3 | at p6 and p7 computed arctan(x) equals x, so the secant through them passes through the origin | `julia -e` check: atan(p6)==p6 true, atan(p7)==p7 true; line through (p6,p6),(p7,p7) is y=x | confirmed |
| C3.9 | Case 3 | in exact arithmetic p8 ≈ -7.6e-48 | mpmath -7.5928e-48 | confirmed |
| C3.10 | Case 3 alt | iterates oscillate across x=0 with decreasing amplitude before converging | |p2..p7| = 1.22, 0.018, 0.0067, 4.6e-7, 6.9e-12, 4.8e-25 | confirmed |
| C3.11 | Case 3 wiring | cc script / cc GIF | byte-identical regen | confirmed |
| C4.1 | Case 4 heading | f=x³-x+3, p0=2.0, p1=1.0 | `secantmethoddd.jl` l.11-13 | confirmed |
| C4.2 | Case 4 | real root near x ≈ -1.672 | mpmath -1.67169988; cubic discriminant 4-243<0 so it is the only real root | confirmed |
| C4.3 | Case 4 | iterates wander, including a large positive excursion, before converging | p3=-3.0, p6=+3.1639, p9=-3.0342, then p10..p17 converge to -1.6717 | confirmed |
| C4.4 | Case 4 | convergence can occur although the path is non-monotone and starts far from the root | as above; start errors 3.67, 2.67 | confirmed |
| C4.5 | Case 4 alt | iterates wander through positive and negative values before converging to root near x=-1.672 | frames 1-16; last legend p17 = -1.6717 | confirmed |
| C4.6 | Case 4 wiring | dd script / dd GIF | byte-identical regen | confirmed |
| C5.1 | Case 5 heading | f=x e^{-x}, p0=1.5, p1=2.0 | `secantmethodee.jl` l.11-13 | confirmed |
| C5.2 | Case 5 | f has a root at 0 but the method diverges | iterates increase without bound (p3000 ≈ 2088 in mpmath) | confirmed |
| C5.3 | Case 5 | secant through points on the decaying tail has a shallow negative slope whose x-intercept falls to the right | all iterates > 1 (past the maximum at x=1); each p_{n+1} > p_n | confirmed |
| C5.4 | Case 5 | first jump to p2 ≈ 4.11 | 4.11380 | confirmed |
| C5.5 | Case 5 | each later step moves right by less than 1 | steps p3..p18: 0.699, 0.972, 0.811, 0.833, 0.799, 0.793, 0.781, 0.774, ... 0.740 | confirmed |
| C5.6 | Case 5 | the step tends to ln 2 ≈ 0.693 | mpmath steps: 0.7115 (n=50), 0.6941 (n=1000), 0.69348 (n=3000) → 0.693147; heuristic d* = ln2 + ln(1+d/x) | confirmed |
| C5.7 | Case 5 | animation stops at p10 ≈ 10.57, the first iterate past the right edge | xlim 10.1; p9 = 9.801 inside, p10 = 10.5746 outside; 9 frames, last frame "p10 = 10.57 (off chart, marker at edge)" | confirmed |
| C5.8 | Case 5 | p16 ≈ 15.11 | 15.10597 | confirmed |
| C5.9 | Case 5 alt | x-intercept steps further right until p10≈10.57 leaves the window | frames 1-9 | confirmed |
| C5.10 | Case 5 wiring | ee script / ee GIF | byte-identical regen | confirmed |
| C6.1 | Case 6 heading | f=arctan x, p0=1.60, p1=1.50 | `secantmethodff.jl` l.12-14 | confirmed |
| C6.2 | Case 6 | slightly larger starting values than Case 3; again converges to 0 | 1.6/1.5 vs 1.35/1.3; iterates → 0 | confirmed |
| C6.3 | Case 6 | larger first overshoot | |p2| = 1.842 vs 1.221 in Case 3 | confirmed |
| C6.4 | Case 6 | subsequent steps quickly close in | p3..p7: -0.0975, 0.0762, -5.24e-5, 1.01e-7, -9.23e-17 | confirmed |
| C6.5 | Case 6 | super-linear, asymptotic order 2 rather than 1.618 because f''(0)=0 | ln e_{n+1}/ln e_n for p6→p10 (mpmath): 2.29, 1.90, 2.07, 1.97; theory e_{n+1} ≈ (f'''/6f') e_n e_{n-1}(e_n+e_{n-1}) ⇒ p²=p+2 ⇒ p=2; Case 3 data likewise 1.76, 2.18, 1.94, 2.05, 1.98 | confirmed |
| C6.6 | Case 6 alt | converge to x=0 after initial overshoot, super-linear | frames 1-6 | confirmed |
| C6.7 | Case 6 wiring | ff script / ff GIF | byte-identical regen | confirmed |

### 3. Implementation checks

Common to all six scripts: the update is `ps[i+1] = ps[i] - f(ps[i])*(ps[i]-ps[i-1])/(f(ps[i])-f(ps[i-1]))`, the standard two-point secant method (not regula falsi: no bracketing, always the two most recent iterates). `ps[k]` holds p_{k-1}; frame k draws the secant through p_{k-1}, p_k and the diamond at p_{k+1}, and the legend indices follow that mapping. The `|denom| < 1e-14` guard never fires in any script (the instrumented iterates differ from the 120-digit mpmath iterates only by rounding). Each committed GIF is byte-identical to a scratch regeneration (manifest).

Script vs independent iterates (script value from `inst/` run; mpmath from `indep.py`):

**secantmethodaa.jl** (3e^x-4cos x, 1.0, 0.9, 9 frames → p2..p10)
| n | script | mpmath |
|---|---|---|
| 2 | 0.4557507541631453 | 0.45575075416314564 |
| 3 | 0.32073053275992147 | 0.32073053275992162 |
| 4 | 0.2637602526350553 | 0.26376025263505523 |
| 5 | 0.25529351342420903 | 0.25529351342420906 |
| 6 | 0.2548531741452458 | 0.25485317414524574 |
| 7 | 0.2548500601244336 | 0.25485006012443356 |
| 8..10 | 0.254850059028853 / ...8503 | root 0.25485005902885026 |
Method: correct. Numbers: agree to double precision. Reference: none drawn; page root 0.2549 verified. Picture: secant through correct points, diamond labels match (p2 = 0.45575, p3 = 0.32073, p4 = 0.26376, p5 = 0.25529, later 0.25485); no clamping needed (f(1.0)=5.994 < ylim 6).

**secantmethodbb.jl** ((1-5x)², 1.0, 0.9, 28 frames → p2..p29)
Script p2 0.5733333333333335, p7 0.23500000000000001, p14 0.20120507854529351, p29 0.20000088348568937; mpmath 0.57333333333333334, 0.235, 0.20120507854529804, 0.20000088348853019. Drift ≤ 3e-12 from cancellation in the expanded quadratic, invisible at the 8 displayed decimals (legend p29 = 0.20000088). Error-ratio limit 0.61803 matches (√5-1)/2. Method correct; picture correct; clamping inert (all points in [0,1]×[0,16]).

**secantmethodcc.jl** (arctan, 1.35, 1.30, 7 frames → p2..p8)
Script: -1.2213792056860207, 0.01803629819672592, -0.006723294978554995, 4.5722058130987647e-7, -6.8886493391088996e-12, 4.798293787661118e-25, 0.0. mpmath: -1.2213792056860119, 0.018036298196728049, -0.006723294978555694, 4.572205813098146e-7, -6.8886493390955489e-12, 4.8001833131674089e-25, -7.5928e-48. The double p8 = 0 is a genuine floating-point outcome (atan(p6)==p6 and atan(p7)==p7 verified), and both the legend ("p8 = 0 (double-precision result)") and the page state this honestly. Picture: secants and diamonds at the right points; legend uses scientific notation for small values.

**secantmethoddd.jl** (x³-x+3, 2.0, 1.0, 16 frames → p2..p17)
Script: 0.5, -3.0, 0.11111111111111116, -0.26527331189710607, 3.1639049160972332, -0.6592136556106953, -1.1175187511612497, -3.034227576785138, -1.3294031486283302, -1.4707505238207963, -1.7346585404889323, -1.6625225638487549, -1.6713173841323061, -1.6717022768625058, -1.6716998810347838, -1.67169988165716. mpmath identical to 15+ digits; root -1.671699881657161. All iterates and f-values fit the window (x ∈ [-3.034, 3.164] ⊂ [-3.2, 3.5]; f ∈ [-21.9, 31.5] ⊂ [-25, 32]), so the clamping and the always-drawn diamond never misplace anything. Early-break note above.

**secantmethodee.jl** (x e^{-x}, 1.5, 2.0, 9 frames → p2..p10)
Script: 4.113798873326397, 4.8125063367527, 5.7840655807283134, 6.594867561790274, 7.4280641347491585, 8.227217596978685, 9.020294500885157, 9.800986646316584, 10.574639777228054. mpmath agrees to ~15 digits. Divergence guard (|p|>1e6) never fires. Frame 9 places p10 as a hollow marker at the right edge, labelled "(off chart, marker at edge)" with its true value 10.57 - an honest display device.

**secantmethodff.jl** (arctan, 1.60, 1.50, 6 frames → p2..p7)
Script: -1.8424619601336367, -0.09748338647473931, 0.07619322951467797, -5.236815030411346e-5, 1.0111340931960545e-7, -9.225344201478945e-17. mpmath: -1.8424619601336277, -0.097483386474736638, 0.076193229514675179, -5.2368150304105955e-5, 1.0111340931957692e-7, -9.2253449358627527e-17. Header claim "p2 ≈ -1.842, then from p3 on the iterates alternate sides" verified (p2, p3 both negative; p3..p7 alternate). Legends: -1.84246, -0.09748, 0.07619, -5.24e-05, 1.01e-07, -9.23e-17, all match.

### Fidelity to the legacy archive

The six a2001 animations (Secantaa..ff) use the same functions, starting values and order as the page (read from frame text: aa p1 = 0.9, p2 = 0.455750754163146; bb 25x²-10x+1, p1 = 0.9; cc tan⁻¹x, p1 = 1.3, p5 = 4.57221e-7; dd x³-x+3, p1 = 1.0, p13 = -1.66252; ee e^{-x}x, p1 = 2.0, p9 = 9.80099; ff tan⁻¹x, p1 = 1.5, p6 = 1.01113e-7). All match the recomputed values. n2003 example titles (Fast Convergence, Slow Convergence, Convergence/Oscillation, Convergence, NON Convergence Diverging to Infinity, Convergence) match the page's case headings. The page runs some cases a few steps further (dd to p17, ee to p10, ff to p7) and adds explanations, which is no loss of fidelity. No case dropped, no function changed. No fidelity findings.

