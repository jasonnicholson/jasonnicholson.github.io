# Midpoint Rule — animation review (round 8)

Page: `pages/numerical-methods/midpoint-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Error: 0, Misleading: 0, Minor: 0.

Observations that I judged not to be findings (cosmetic, do not change what a viewer concludes):
- `midpointaa.jl:48` uses `round(approx; digits=6)`, so frames for n = 6, 10, 60 show `2.05928`, `2.04303`, `2.01783` (trailing zero dropped) while the legacy shows `2.059280` etc. Values are correct.
- The plot title is "Midpoint Rule" only; the legacy frame also printed the formula `y = e^{-x} sin(8x^{2/3}) + 1`. The page heading states the function, and nothing in the frame contradicts it.
- The curve is drawn before the semi-transparent rectangles, so it looks faded inside them. Still clearly visible.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `midpointaa.jl` | 0 | 8.3 | midpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | $M_n = \Delta x \sum_{i=0}^{n-1} f(a+(i+\tfrac12)\Delta x)$, $\Delta x=(b-a)/n$ | `midpoint_sum` line 19-22 implements exactly this; mpmath `M(n)` gives the same values to 1e-15 | confirmed |
| D2 | "each subinterval contributes a rectangle centered at its midpoint sample" | lines 33-41: rectangle on [xl,xr] with height f((xl+xr)/2); frames 2, 4 show heights f(1)=1.3638, f(0.25), f(0.75)... at the dots | confirmed |
| D3 | "often much more accurate than left/right endpoint sums at the same n" | general statement; for this integrand true for n ≥ 4 (see B4) | confirmed |
| A1 | Function $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | line 8-9 `f(x)=exp(-x)*sin(8*x^(2/3))+1`, `a,b=0,2` | confirmed |
| A2 | "Each frame increases sample-point density across the full interval and updates the integral estimate" | n sequence strictly increasing, rectangles span [0,2]; frame 1 is a curve-only intro frame (n=0) | confirmed |
| A3 | "same function, interval and sequence of sample counts (1 to 120)" as Mathews | legacy frames: 1,1,2,4,6,8,10,12,14,16,20,24,28,32,40,50,60,70,80,100,120 (after 3 title frames); script `n_seq` = 1,2,4,...,100,120 — same set; legacy approximations match the script's to all 6 printed digits | confirmed |
| A4 | "each midpoint sample marked by a red dot" | line 43-44 scatter at midpoints, red; visible in frames | confirmed |
| H1 | Case heading: Midpoint Rule, $y=e^{-x}\sin(8x^{2/3})+1$ | matches script | confirmed |
| B1 | "Over the first few frames the estimate jumps above and below the integral" | errors n=1: +0.7116, n=2: −0.7851, n=4: −0.00516, n=6: +0.0430 | confirmed |
| B2 | "from 6 sample points on it stays above ∫ and decreases toward it in every frame" | errors positive and strictly decreasing for every n in {6,...,120} (check.py `dec=True`) | confirmed |
| B3 | "$\int_0^2 f\,dx \approx 2.016280$" | mpmath (substitution x=t^3, 30 digits): 2.0162797196170963; cross-check by direct split quad identical | confirmed |
| B4 | "last frame (120 sample points) gives 2.016771, still about 0.00049 high" | M_120 = 2.0167714555; error 0.000491736 | confirmed |
| B5 | "In every frame from 4 sample points on, the midpoint estimate is closer ... than the left- or right-endpoint sum" | check.py `closer=True` for all n ≥ 4; False for n=1,2 (so "from 4" is the right threshold) | confirmed |
| B6 | "$f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near 0" | mpmath $f'(10^{-9})\cdot x^{1/3} = 5.33333332$ vs 16/3 | confirmed |
| B7 | "error shrinks like $O(\Delta x^{5/3})$ rather than $O(\Delta x^2)$" | error ratios on halving: 2.962 (12→24), 3.112 (24→48), 3.147, 3.159, 3.165, 3.168, 3.170, 3.171, 3.172 → 2^{5/3}=3.1748 | confirmed |
| B8 | "halving Δx divides it by about 3.11 (from 24 to 48 subintervals), tending to $2^{5/3}\approx 3.17$, instead of 4" | 3.11248; 3.1748 | confirmed |
| L1 | `[Julia source](midpointaa.jl)` | file exists, is this case's script | confirmed |
| L2 | Embed `midpointaa.gif` | produced by `midpointaa.jl` (manifest: byte-identical on regen) | confirmed |
| L3 | Alt text: "each frame increases partition density, marks the midpoint samples with red dots and recomputes the midpoint-rectangle area" | as A2/A4; annotation recomputed per frame (line 46-48) | confirmed |
| N1 | Derivation Notes: for $f\in C^2$, global error $O(\Delta x^2)$, doubling n cuts error by ~4 | standard result; consistent with Mathews' corollary (error term $(b-a)f''(c)h^2/24$) | confirmed |
| N2 | Worked Example: "the frame-by-frame approximation ... converges as n grows" | errors → 0.00049 at n=120, monotone from n=6 | confirmed |
| N3 | Implementation Notes: "axis limits fixed so only density and approximation change ..., mirroring legacy animation behavior" | lines 15-16 fixed xlims (0,2), ylims (0,2.1); legacy frames also have fixed axes | confirmed |

Frame annotations vs computation (every frame): instrumented values for all 20 n match the frame text and the independent mpmath values (see section 3).

### 3. Implementation checks — `midpointaa.jl`

**Is the method it claims.** Composite midpoint rule on a uniform partition, n subintervals, sample at $a+(i+\tfrac12)\Delta x$. No variant issues.

**Numbers are right.** `julia review/inst.jl` (script's `f`, `n_seq`, `midpoint_sum` copied verbatim) vs `python3 -I review/check.py` (mpmath, 30 digits):

| n | script | mpmath | frame text |
|---|---|---|---|
| 1 | 2.7279291177723355 | 2.727929118 | 2.727929 |
| 2 | 1.2312160094741664 | 1.231216009 | 1.231216 |
| 4 | 2.011118372395021 | 2.011118372 | 2.011118 |
| 6 | 2.059279922009142 | 2.059279922 | 2.05928 |
| 10 | 2.043030305419586 | 2.043030305 | 2.04303 |
| 24 | 2.0232541562652457 | 2.023254156 | (not in sheet; = legacy 2.023254) |
| 60 | 2.017829886147683 | 2.017829886 | 2.01783 |
| 120 | 2.016771455496156 | 2.016771455 | 2.016771 |

All 20 n agree to ≥ 9 digits. Property check: the same midpoint formula with 4 panels integrates $3x+2$ on [0,2] exactly (10.0) and not $x^2$ (2.625 vs 8/3), as expected for degree of precision 1. Convergence-rate check (B7) also consistent with the theory for an $x^{2/3}$ singular-derivative term (midpoint error for $x^\alpha$ is $O(h^{1+\alpha})$).

**Reference values.** The script draws no reference value; the page's integral 2.016280 was verified independently (B3) by two quadrature strategies agreeing to 30 digits.

**Picture shows what was computed.** Frames 1 (curve only, n=0), 2 (n=1), 4 (n=4), and the contact sheet (n=2…120) inspected. Rectangle heights pass through the red dots on the curve at panel midpoints; panel edges at multiples of 2/n; annotation n and approximation match the frame's n. Curve maximum 1.9198 < ylim 2.1, so nothing is clipped. Fixed axes; 21 frames at 2 fps.

**Fidelity to legacy.** Same function, interval, axes range and sample-count sequence as Mathews' `Midpointaa.gif`; the legacy's 6-digit approximations equal the script's for every n. Mathews' n2003 module page contains no numbered example with a different function relevant to this animation. No fidelity departure.

