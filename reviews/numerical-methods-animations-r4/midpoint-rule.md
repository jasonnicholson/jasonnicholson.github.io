# Midpoint Rule — animation review (round 4)

Page: `pages/numerical-methods/midpoint-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and every value the script computes agreed with independent computation at the precision stated.

Observations considered and deliberately not reported as findings:
- The frame annotation uses `round(approx; digits=6)`, which drops trailing zeros: frames show `2.05928` (n=6) and `2.01783` (n=60) where the legacy GIF shows `2.059280` and `2.017830`. The values are correct; this is cosmetic.
- The legacy GIF prints the function formula inside each frame; the new GIF's title is only "Midpoint Rule". The formula is stated in the page heading and in the code; nothing contradicts it. Not misleading.
- The legacy GIF shows the n=1 frame twice (3 intro-ish frames + 21 numeric frames = 24); the new GIF shows one bare-curve frame then n=1..120 once each (21 frames). The sample-count sequence is the same.
- The legacy module's worked examples (lnk_2 to lnk_12: other integrands with m = 1,2,4,8,16 and 50..800) are text examples, not animations, so the Animations section does not drop an animated case.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `midpointaa.jl` | 0 | 8.0 | midpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `midpointaa.gif` | 21 | byte-identical | midpointaa |

### Page references

- Scripts linked: `midpointaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (location) | Evidence | Verdict |
|---|---|---|---|
| D1 | "$M_n = \Delta x \sum_{i=0}^{n-1} f(a + (i+\tfrac12)\Delta x)$", $\Delta x=(b-a)/n$ (Description, l.12-16) | `midpoint_sum` (l.19-22) is exactly this formula | confirmed |
| D2 | "each subinterval contributes a rectangle centered at its midpoint sample" (l.18) | l.33-41: rectangle on $[x_l,x_r]$, height $f(x_m)$ | confirmed |
| D3 | "often much more accurate than left/right endpoint sums at the same $n$" (l.18) | general statement; for this integrand confirmed for every n=4..120 (`lr.py`) | confirmed |
| D4 | For $C^2$ f, global error $O(\Delta x^2)$; doubling n reduces error by about 4 (Derivation Notes, l.37) | standard result; degree-of-precision check: composite rule (n=3) on [0,2] exact for $x^0,x^1$ (2.0, 2.0), not for $x^2$ (2.5926 vs 2.6667) - degree 1, consistent with $O(h^2)$ | confirmed |
| A1 | Function $y = e^{-x}\sin(8x^{2/3})+1$ (intro l.23, heading l.27, Worked Example l.41) | script l.8 `exp(-x)*sin(8*x^(2/3))+1` | confirmed |
| A2 | Interval $[0,2]$ | script l.9 `a, b = 0.0, 2.0`; frame x-axis 0-2 | confirmed |
| A3 | "Each frame increases sample-point density across the full interval and updates the integral estimate" (l.23) | frames: bare curve, then n = 1,2,4,...,120, each spanning [0,2], annotation updated | confirmed |
| A4 | "same function, interval and sequence of sample counts (1 to 120)" as Mathews (l.25) | legacy frames (`review/legacy_labels.png`): formula label $e^{-x}\sin(8x^{2/3})+1$, x-axis 0-2, counts 1,(1),2,4,6,8,10,12,14,16,20,24,28,32,40,50,60,70,80,100,120 - identical to `n_seq` | confirmed |
| A5 | "each midpoint sample marked by a red dot" (l.25) | l.43-44 scatter at midpoints, red; visible in frames 2, 21 | confirmed |
| A6 | "Over the first few frames the estimate jumps above and below the integral" (l.29) | M1=2.727929 (+0.7116), M2=1.231216 (-0.7851), M4=2.011118 (-0.0052), M6=2.059280 (+0.0430) | confirmed |
| A7 | "from 6 sample points on it stays above $\int_0^2 f \approx 2.016280$" | I = 2.0162797196170963 (mpmath, substitution $x=t^3$, and split-interval quad agree to 30 digits); M_n > I for every n = 6..120 (`lr.py`) | confirmed |
| A8 | "... and decreases toward it in every frame" (from 6 on) | M strictly decreasing over 6,8,...,120 (all 15 steps), and over every integer n 6..120 | confirmed |
| A9 | "the last frame (120 sample points) gives 2.016771" | script 2.016771455496156; independent 2.016771455; frame 21 shows 2.016771 | confirmed |
| A10 | "still about 0.00049 high" | error = 0.000491736 | confirmed |
| A11 | "From 4 sample points on, the midpoint estimate is closer to the integral than the left- or right-endpoint sum with the same number of subintervals" | holds for every n in the sequence and every integer n 4..120; fails at n=1,2 (consistent with "from 4") | confirmed |
| A12 | "$f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near 0", $f'$ unbounded at 0 | $f'(10^{-9})\cdot 10^{-3} = 5.33333$ (mpmath diff) = 16/3 | confirmed |
| A13 | "measured error shrinks like $O(\Delta x^{5/3})$ rather than $O(\Delta x^2)$" | error ratios on halving: 12->24 2.962, 24->48 3.112, 48->96 3.147, ... 3072->6144 3.1718, approaching $2^{5/3}=3.1748$; consistent with $x^{2/3}$ endpoint singularity (error $\sim h^{1+2/3}$) | confirmed |
| A14 | "halving $\Delta x$ divides it by about 3.11 (from 24 to 48 subintervals)" | 0.0069744 / 0.0022408 = 3.11248 | confirmed |
| A15 | "tending to $2^{5/3}\approx 3.17$, instead of 4" | $2^{5/3}=3.1748$; ratios trend up to 3.1718 at n=3072 | confirmed |
| A16 | Alt text: "each frame increases partition density, marks the midpoint samples with red dots and recomputes the midpoint-rectangle area" | frames + code | confirmed |
| A17 | Wiring: `[Julia source](midpointaa.jl)` and embed `midpointaa.gif` | both files exist in the page folder; the script writes `midpointaa.gif`; committed GIF byte-identical to regeneration | confirmed |
| A18 | Counts: one case, one animation | one script, one GIF, one case heading | confirmed |
| I1 | "The script keeps axis limits fixed" (Implementation Notes, l.45) | l.15-16 `xlims=(0,2)`, `ylims=(0,2.1)` applied every frame; max f on [0,2] = 1.9198 < 2.1, min 0.357 > 0, so nothing is clipped | confirmed |

### 3. Implementation checks: `midpointaa.jl`

**Is it the method claimed?** Yes. Composite midpoint rule on a uniform partition: `dx*sum(f(a+(i+0.5)dx), i=0..n-1)`. No variant.

**Are the numbers right?** Instrumented copy (`review/instr.jl`) vs independent mpmath (`review/indep.py`, 30 digits):

| n | script | independent | displayed in frame |
|---|---|---|---|
| 1 | 2.7279291177723355 | 2.727929118 | 2.727929 |
| 2 | 1.2312160094741664 | 1.231216009 | 1.231216 |
| 4 | 2.011118372395021 | 2.011118372 | (not in sheet; legacy 2.011118) |
| 6 | 2.059279922009142 | 2.059279922 | 2.05928 |
| 10 | 2.043030305419586 | 2.043030305 | 2.04303 |
| 24 | 2.0232541562652457 | 2.023254156 | (legacy 2.023254) |
| 40 | 2.019305493019697 | 2.019305493 | 2.019305 |
| 60 | 2.017829886147683 | 2.017829886 | 2.01783 |
| 80 | 2.017242754852992 | 2.017242755 | 2.017243 |
| 120 | 2.016771455496156 | 2.016771455 | 2.016771 |

All 20 values agree to at least 9 digits, and every rounded value equals the legacy Mathematica GIF's value. Property check: the rule integrates $1, x$ exactly and not $x^2$ (degree of precision 1).

**Reference values.** The script draws no reference; the page's $\int_0^2 f \approx 2.016280$ was checked independently: 2.01627971961709632788727442192 by two different mpmath quadratures (substitution $x=t^3$ removing the singularity, and a split-interval quad), which agree to all 30 digits.

**Does the picture show what was computed?** Each rectangle spans $[x_l, x_l+\Delta x]$ with height $f(x_m)$ (l.35-41), red dots at $(x_m, f(x_m))$ (l.43-44), curve evaluated at 800 points. Frame 2 (n=1): one rectangle of height about 1.364 = f(1), area 2.7279, matching the annotation. Frame 21 (n=120): 120 rectangles, dots on the curve, annotation 2.016771. Sample-count annotation equals the n used to build the rectangles. Axis limits contain the whole curve; no clamping or masking. 21 frames = one bare-curve frame + 20 sample counts.

