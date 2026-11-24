# Midpoint Rule — animation review (round 9)

Page: `pages/numerical-methods/midpoint-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, every value the script draws, and the correspondence with the legacy animation was verified. No Error, Misleading or Minor findings.

Observations that are not findings (cosmetic, not misleading):
- The on-plot "Approximation" uses `round(approx; digits=6)`, which drops a trailing zero, so some frames show 5 decimals (`2.05928`, `2.04303`, `2.01783`) where the legacy GIF shows `2.059280`. The digits shown are correct.
- Frame 1 is the curve alone (n = 0) with no estimate; the legacy GIF also opens with curve-only intro frames.
- The plot title is "Midpoint Rule" without the function; the legacy plot printed the formula. The page states the function in the heading.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `midpointaa.jl` | 0 | 8.2 | midpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Location | Verdict | Evidence |
|---|---|---|---|---|
| D1 | $M_n = \Delta x \sum_{i=0}^{n-1} f(a+(i+\tfrac12)\Delta x)$, $\Delta x=(b-a)/n$ | Description, l.12-16 | Confirmed | Script l.19-22 implements exactly this |
| D2 | "each subinterval contributes a rectangle centered at its midpoint sample" | l.18 | Confirmed | Script l.33-41: rectangle on [xl,xr] with height f((xl+xr)/2) |
| D3 | "often much more accurate than left/right endpoint sums at the same n" | l.18 | Confirmed (for this example from n=4) | See B5 |
| A1 | Function $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | l.22-23, heading l.27 | Confirmed | Script l.8-9 |
| A2 | "Each frame increases sample-point density across the full interval and updates the integral estimate" | l.23 | Confirmed | n = 0,1,2,4,...,120 strictly increasing; estimate annotated each frame from n=1 (frame 1 is the n=0 curve-only frame) |
| A3 | "the same function, interval and sequence of sample counts (1 to 120)" as Mathews | l.25 | Confirmed | Legacy Example 11 (lnk_12) lists m = 1,2,4,6,8,10,12,14,16,20,24,28,32,40,50,60,70,80,100,120; legacy GIF hashes show 3 intro + 2 (n=1) + 19 distinct frames; frames viewed for n=1,2,4,6,8,12,16,24,32,40,50,70,100,120 match. Script `n_seq` is identical. Function shown in legacy plot label matches. |
| A4 | "each midpoint sample marked by a red dot" | l.25, alt text | Confirmed | Script l.43-44; frames 2, 21 and contact sheet |
| B1 | "Over the first few frames the estimate jumps above and below the integral" | l.29 | Confirmed | Errors: n=1 +0.7116, n=2 -0.7851, n=4 -0.00516, n=6 +0.0430 |
| B2 | "from 6 sample points on it stays above $\int_0^2 f$ and decreases toward it in every frame" | l.29 | Confirmed | Error positive and strictly decreasing for all 15 frames n=6..120 (0.0430 → 0.000492) |
| B3 | $\int_0^2 f\,dx \approx 2.016280$ | l.29 | Confirmed | mpmath (x=t^3 substitution) 2.0162797196170963279; mpmath split quad agrees to 20 digits; scipy quad 2.016279719617096 |
| B4 | "the last frame (120 sample points) gives 2.016771, still about 0.00049 high" | l.29 | Confirmed | M_120 = 2.016771455 (Julia and mpmath); error 0.000491736 |
| B5 | "In every frame from 4 sample points on, the midpoint estimate is closer to the integral than the left- or right-endpoint sum" | l.29 | Confirmed | n=4: mid 0.00516 vs L 0.2187, R 0.2097; holds for every n in the sequence ≥4 (n=120: 0.00049 vs 0.00148, 0.00119). Fails at n=1 (L closer) and n=2, so "from 4" is the right threshold |
| B6 | "$f'$ unbounded at $x=0$ ($f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near 0)" | l.29 | Confirmed | $f'=-e^{-x}\sin(8x^{2/3})+e^{-x}\cos(8x^{2/3})\cdot\tfrac{16}{3}x^{-1/3}$; leading term as stated |
| B7 | "error shrinks like $O(\Delta x^{5/3})$ rather than $O(\Delta x^2)$" | l.29 | Confirmed | Log-log slopes of error for n=6..6144: 1.06, 1.57, 1.64, 1.654, 1.660, 1.662, 1.663, 1.664, 1.665, 1.665 → 5/3 |
| B8 | "halving $\Delta x$ divides it by about 3.11 (from 24 to 48 subintervals), tending to $2^{5/3}\approx3.17$, instead of 4" | l.29 | Confirmed | Ratio 24→48 = 3.11248; ratios 3.147, 3.159, 3.165, 3.168, 3.170, 3.171, 3.172 up to 3072→6144; 2^(5/3)=3.17480 |
| L1 | Source link `midpointaa.jl`, embed `midpointaa.gif` | l.31, l.33 | Confirmed | Both files exist in page folder; GIF is byte-identical to scratch regeneration of the script |
| L2 | Alt text: "each frame increases partition density, marks the midpoint samples with red dots and recomputes the midpoint-rectangle area" | l.33 | Confirmed | As A2, A4; annotated value equals `midpoint_sum(n)` |
| N1 | "For smooth f (twice continuously differentiable), the midpoint rule has global error order $O(\Delta x^2)$, i.e. doubling the number of subintervals reduces error by roughly a factor of 4" | Derivation Notes l.37 | Confirmed | Script routine on $e^x$ over [0,2]: halving ratios 3.978, 3.9945, 3.9986, 3.9997 |
| N2 | "the frame-by-frame approximation in the animation converges as n grows" | Worked Example l.41 | Confirmed | Monotone decrease to 2.016280 from n=6 (B2) |
| N3 | "The script keeps axis limits fixed" | Implementation Notes l.45 | Confirmed | `xlims=(0,2)`, `ylims=(0,2.1)` constant; all frames show identical axes |

Counts: the page states no frame count. GIF has 21 frames = 1 (n=0) + 20 sample counts.

### 3. Implementation checks: `midpointaa.jl`

**Is the method it claims to be.** Composite midpoint rule on a uniform partition: `dx*(sum f(a+(i+0.5)dx), i=0..n-1)`. Not a left/right Riemann sum, not trapezoid. Property check with the script's routine (`props.jl`, n=4 on [0,2]): exact for $1$ and $x$ (err 0.0, 0.0), not for $x^2$ (err -0.041667 = $-(b-a)h^2 f''/24$ with h=0.5) or $x^3$ (err -0.125). Degree of precision 1, as for the midpoint rule. Order 2 on smooth $e^x$ (ratios → 4.000).

**Numbers are right.** Script values (`instr.jl`) beside independent mpmath values (`indep.py`):

| n | script | mpmath | displayed |
|---|---|---|---|
| 1 | 2.7279291177723355 | 2.727929118 | 2.727929 |
| 2 | 1.2312160094741664 | 1.231216009 | 1.231216 |
| 4 | 2.011118372395021 | 2.011118372 | 2.011118 |
| 6 | 2.059279922009142 | 2.059279922 | 2.05928 |
| 8 | 2.051516783261768 | 2.051516783 | 2.051517 |
| 10 | 2.043030305419586 | 2.043030305 | 2.04303 |
| 12 | 2.036937496401836 | 2.036937496 | 2.036937 |
| 16 | 2.0296063673806675 | 2.029606367 | 2.029606 |
| 24 | 2.0232541562652457 | 2.023254156 | 2.023254 |
| 32 | 2.0206439591428174 | 2.020643959 | 2.020644 |
| 40 | 2.019305493019697 | 2.019305493 | 2.019305 |
| 50 | 2.018374580019836 | 2.01837458 | 2.018375 |
| 60 | 2.017829886147683 | 2.017829886 | 2.01783 |
| 80 | 2.017242754852992 | 2.017242755 | 2.017243 |
| 100 | 2.0169450742923565 | 2.016945074 | 2.016945 |
| 120 | 2.016771455496156 | 2.016771455 | 2.016771 |

All 20 agree to all printed digits (remaining n also checked: 14, 20, 28, 70). The legacy GIF's printed approximations (2.727929, 1.231216, 2.011118, 2.059280, 2.051517, 2.036937, 2.029606, 2.023254, 2.020644, 2.019305, 2.018375, 2.017481, 2.016945, 2.016771) agree as well.

**Reference values.** The script draws no reference value. The page's reference integral 2.016280 was verified three ways (mpmath with substitution x=t³ removing the singularity, mpmath with a split interval, scipy quad), all 2.0162797196…

**Picture shows what was computed.** Frames 1, 2, 21 and the 12-frame contact sheet viewed. Each rectangle spans [xl, xr] with height f(midpoint); red dots sit at (midpoint, f(midpoint)) on the magenta curve; "Sample Points = n" equals the number of subintervals; "Approximation" equals `midpoint_sum(n)`. Axis limits (0..2, 0..2.1) contain the whole curve (grid max 1.9198, min 0.3572) and every rectangle (max height 1.9191), so nothing is clipped. Annotations at y=1.88/1.74, x=1.15 do not overlap the curve (f≈1.2 there). No clamping or masking used. 21 frames at fps=2.

### Could not determine

Nothing material. Legacy frames for n=10, 14, 20, 28, 60, 80 were not viewed individually; their presence is inferred from the frame-hash count together with the m-list printed in legacy Example 11 (lnk_12), which matches the script exactly.

