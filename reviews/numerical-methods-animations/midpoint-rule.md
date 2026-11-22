# Midpoint Rule — animation review

Page: [`pages/numerical-methods/midpoint-rule/index.qmd`](../../pages/numerical-methods/midpoint-rule/index.qmd) · Scripts: `midpointaa.jl` · GIFs: 1

**Result:** 0 error, 1 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — The O(Δx²) / "factor of 4" rate does not hold for the page's own integrand; the measured rate is Δx^(5/3) (factor about 3.17)

- **Location:** index.qmd:37 "For smooth $f$, midpoint rule has global error order $O(\Delta x^2)$, i.e. doubling the number of subintervals reduces error by roughly a factor of 4." The next section, index.qmd:41 (Worked Example), applies the rule to $f(x)=e^{-x}\sin(8x^{2/3})+1$ without saying that this $f$ is not smooth.
- **Now:** The only rate the page gives is the smooth-case factor of 4. The page's only example is not smooth on [0,2]: $f'(x) = -e^{-x}\sin(8x^{2/3}) + \tfrac{16}{3}x^{-1/3}e^{-x}\cos(8x^{2/3})$ becomes unbounded as $x\to0^+$, because near 0, $\sin(8x^{2/3})\approx 8x^{2/3}$.
- **True:** For this integrand the composite midpoint error goes down like $\Delta x^{5/3}$ ($= \Delta x^{1+2/3}$, from the $x^{2/3}$ term at the endpoint). When $n$ doubles, the error falls by about $2^{5/3}\approx 3.17$, not 4. Within the animation's own n-sequence the ratio is never 4: it is 2.64 (8→16), 3.05 (16→32) and 3.13 (32→64). From n=1 to n=8 there is no consistent ratio at all (ratios −0.91, 152, −4.77, −0.15).
- **Evidence:** `reviewer/indep.py` (mpmath, 40 digits) gives errors M_n − I with I = 2.016279719617096327887274. Halving ratios for n = 20, 40, …, 20480: 2.859, 3.092, 3.142, 3.157, 3.163, 3.167, 3.169, 3.171, 3.172, 3.1723, 3.1729. The observed order log2(ratio) is 1.5155 → 1.6658, approaching 5/3 = 1.6667. `reviewer/compare.py` gives the pair ratios within n_seq quoted above.
- **Suggested fix:** Keep the smooth-case statement and add a sentence such as: "The animated integrand is not smooth at $x=0$ (the $x^{2/3}$ term makes $f'$ unbounded there), so on this example the error falls only like $\Delta x^{5/3}$, about a factor of 3.2 per doubling of $n$." Alternatively, have the Worked Example report the measured error ratios.

- **Independent check:** confirmed with correction. Checker: asymptotic factor 3.17 (order 5/3); within the animation's n range the measured factor is only ≈1.4–3.1. Line 37 does say 'for smooth f', so it is narrowly true — Misleading, not Error.

### F2 — Minor — Page match — "the estimate stabilizes quickly" overstates what the animated sequence does

- **Location:** index.qmd:29 "**Behavior:** The midpoint sample in each subinterval tracks local curve height better than endpoint samples, so the estimate stabilizes quickly as density increases."
- **Now:** The page says the estimate stabilizes quickly.
- **True:** The displayed estimates first move away from the integral and then approach it slowly. At n=4 the estimate is 2.011118 (error −0.0052). The error then grows to +0.0430 at n=6 and is still +0.0267 at n=10. Afterwards the estimates fall monotonically but slowly: the third decimal is still changing at n=64 (2.017673), and the last frame (n=120, 2.016771) is still 4.9e-4 above I = 2.016280. The slowness comes from the reduced order in F1. The comparison part of the sentence is true but modest for this integrand. At n=120 the left and right sums have errors −1.49e-3 and −1.19e-3 against the midpoint's +4.9e-4, so the midpoint sum is about 2.5–3 times better. The endpoint sums also converge at the degraded rate here, because f(0)=1 and f(2)=1.018 are almost equal.
- **Evidence:** `reviewer/indep.py` (error table for every n in n_seq) and `reviewer/compare.py` (midpoint, left, right and trapezoid errors at n = 3…120).
- **Suggested fix:** Replace "stabilizes quickly" with something like "settles toward the integral (≈ 2.016280), although slowly, because the integrand's $x^{2/3}$ behaviour at 0 limits the convergence rate". Consider also stating the reference value.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `midpointaa.jl` | yes | 3.6 | midpointaa.gif |

Committed GIFs byte-identical to their regenerated output: **1 of 1**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "evaluates $f$ at subinterval midpoints instead of endpoints" | midpointaa.jl:20, 36–37 use a+(i+½)Δx | confirmed |
| 2 | 12–15 | $M_n = \Delta x \sum_{i=0}^{n-1} f(a+(i+\tfrac12)\Delta x)$, $\Delta x=(b-a)/n$ | identical to midpoint_sum (line 18–21); script values match my mpmath M_n to all 6 displayed decimals for all 24 n | confirmed |
| 3 | 18 | "each subinterval contributes a rectangle centered at its midpoint sample" | lines 33–41 draw [xl,xr]×[0,f(xm)]; n=3 frame heights ≈0.536, 1.364, 0.817 = f(1/3), f(1), f(5/3) | confirmed |
| 4 | 18 | "often much more accurate than left/right endpoint sums at the same n" | general statement. On this integrand the midpoint error is about 2.5–3 times smaller than the left/right sums for n ≥ 10 (compare.py). At n=3 the midpoint sum is worse (−0.205 vs −0.123/−0.111) | confirmed (as a general "often"; the gain is modest on this example, see F2) |
| 5 | 22–23 | function $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | script lines 8–9 | confirmed |
| 6 | 23 | "Each frame increases sample-point density across the full interval and updates the integral estimate" | n = 0 (blank curve), then 1,2,…,120 strictly increasing; rectangles span [0,2]; annotation updated each frame | confirmed |
| 7 | 25 | reconstruction "uses the same function, interval, and density-increase pacing seen in the available quadrature GIFs" | legacy fidelity is out of scope; archive not available | could not determine (out of scope) |
| 8 | 27 | Case heading: Midpoint Rule, same function | script title "Midpoint Rule", f matches | confirmed |
| 9 | 29 | "midpoint sample … tracks local curve height better than endpoint samples" | errors vs left/right sums (compare.py), n ≥ 4 | confirmed (modest margin) |
| 10 | 29 | "the estimate stabilizes quickly as density increases" | error −0.005 (n=4) → +0.043 (n=6) → 4.9e-4 (n=120); slow drift | wrong (overstated) (→ F2) |
| 11 | 31 | link `midpointaa.jl` | file exists; manifest: produces midpointaa.gif | confirmed |
| 12 | 33 | embed `midpointaa.gif`; alt text "Midpoint Rule animation over [0,2]: each frame increases partition density and recomputes midpoint-rectangle area" | GIF is byte-identical to the script output; 25 frames, increasing n, area annotation per frame | confirmed |
| 13 | 37 | "For smooth $f$, … $O(\Delta x^2)$ … doubling … reduces error by roughly a factor of 4" | true as stated for smooth f, but the page's integrand is not smooth; measured ratio → 3.17, order 5/3 | confirmed for smooth f; misleading in context (→ F1) |
| 14 | 41 | "the frame-by-frame approximation in the animation converges as $n$ grows" | errors decrease monotonically from n=6 to n=120, 0.043 → 4.9e-4; M_n → I as n → 20480 (error 9.5e-8) | confirmed (not monotone for n ≤ 6) |
| 15 | 45 | "The script keeps axis limits fixed so only density and approximation change between frames" | xlims=(0,2), ylims=(0,2.1) set once (lines 14–15, 24); max f = 1.91976 at x=0.0804, min f on the plotting grid = 0.357, so the curve is fully visible | confirmed |

## Implementation checks

### midpointaa.jl
- **Method:** This is the composite midpoint rule. It samples once at the centre of each of n equal subintervals and multiplies the sum by Δx (lines 18–21). It is not a left, right or trapezoid variant. The displayed "Sample Points = n" correctly counts the n midpoint evaluations.
- **Numbers:** Script (instrumented copy `reviewer/instr.jl`) beside independent mpmath (`reviewer/indep.py`):
  - n=1: 2.727929 / 2.727929118
  - n=3: 1.811305 / 1.811304891
  - n=4: 2.011118 / 2.011118372
  - n=6: 2.05928 / 2.059279922
  - n=10: 2.04303 / 2.043030305
  - n=16: 2.029606 / 2.029606367
  - n=28: 2.021708 / 2.021708153
  - n=48: 2.018521 / 2.018520515
  - n=72: 2.017426 / 2.017426294
  - n=120: 2.016771 / 2.016771455

  All 24 values agree to the 6 decimals displayed. Halving the step on this integrand gives an error ratio approaching 3.17 (order 5/3), not 4 (see F1). This is consistent with the $x^{2/3}$ endpoint singularity in f′ and is not an implementation fault.
- **Reference values:** The script draws or prints no exact integral. My reference I = 2.016279719617096327887274 was computed two ways with mpmath at 40 digits: (a) adaptive quadrature over 40 subintervals, and (b) the substitution x=t³, which removes the singularity. The two agree to all 25 printed digits.
- **Picture:** I read the contact sheet (frames 1, 4, 7, 10, 13, 16, 19, 22, 25), and full-size frames 4 (n=3) and 25 (n=120).
  - Frame 1 is the curve alone (n=0).
  - The rectangle heights in frame 4 match f at the midpoints 1/3, 1, 5/3 (0.536, 1.364, 0.817), and the code sets h=f(xm).
  - The annotations show the correct n and approximation in every frame read.
  - The curve stays inside the fixed axes, and the annotation box (y 1.74–1.88, x≈0.8–1.5) does not hide any curve feature.
  - There is no clamping or masking. The midpoint sample points are not marked, which is cosmetic and not a finding.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/midpoint-rule/`](evidence/midpoint-rule/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
