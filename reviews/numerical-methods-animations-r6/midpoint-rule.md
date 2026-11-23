# Midpoint Rule — animation review (round 6)

Page: `pages/numerical-methods/midpoint-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None. Every checkable claim on the page was confirmed against independent computation and the frames (ledger below). I found nothing false, misleading or of minor consequence that rises to a finding under the review standard.

(Non-findings noted for completeness: the first GIF frame is a curve-only title frame with no rectangles, as in Mathews' animation; the on-frame approximation drops trailing zeros, e.g. "2.05928" for 2.059280. Neither misleads.)



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `midpointaa.jl` | 0 | 8.4 | midpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Page text (quoted / located) | Evidence | Verdict |
|---|---|---|---|
| 1 | Description: "$M_n = \Delta x \sum_{i=0}^{n-1} f(a + (i+\tfrac12)\Delta x)$", $\Delta x=(b-a)/n$ | Script line 20-21: `dx=(b-a)/n; dx*sum(f(a+(i+0.5)*dx) for i in 0:n-1)` - identical | confirmed |
| 2 | "evaluates $f$ at subinterval midpoints instead of endpoints"; "each subinterval contributes a rectangle centered at its midpoint sample" | Script lines 34-41: rectangle on [xl,xr] with height f((xl+xr)/2); frames 2, 4, 21 show rectangles meeting the curve at their centre dots | confirmed |
| 3 | "often much more accurate than left/right endpoint sums at the same $n$" | General statement; for this integrand true at every frame n>=4 (see #12) | confirmed |
| 4 | Function "$y = e^{-x}\sin(8x^{2/3})+1$" on "$[0,2]$" (intro and Case 1 heading) | Script line 8 `exp(-x)*sin(8*x^(2/3))+1`, line 9 `a,b=0.0,2.0` | confirmed |
| 5 | "Each frame increases sample-point density across the full interval and updates the integral estimate" | Frames 2-21: n = 1,2,4,...,120 strictly increasing, partition always covers [0,2], annotation updates each frame (frame 1 is the n=0 title frame) | confirmed |
| 6 | "same function, interval and sequence of sample counts (1 to 120)" as Mathews | Legacy `labels.png`: 1,2,4,6,8,10,12,14,16,20,24,28,32,40,50,60,70,80,100,120 = script `n_seq` exactly; legacy function label $e^{-x}\sin(8x^{2/3})+1$, x axis 0-2; legacy approximations (2.727929, 2.011118, 2.051517, 2.036937, 2.029606, 2.023254, 2.020644, 2.018375, 2.017481, 2.016945) equal the script's to 6 dp | confirmed |
| 7 | "each midpoint sample marked by a red dot" | Script line 44 red scatter at xs = midpoints; frames show it | confirmed |
| 8 | "Over the first few frames the estimate jumps above and below the integral" | M_1=2.727929 (+0.7116), M_2=1.231216 (-0.7851), M_4=2.011118 (-0.00516), M_6=2.059280 (+0.0430) | confirmed |
| 9 | "from 6 sample points on it stays above ... and decreases toward it in every frame" | Errors n=6..120 all positive; M decreases at every step 2.059280 -> 2.051517 -> ... -> 2.016771 (check.py "dec" flag on every row from n=8) | confirmed |
| 10 | "$\int_0^2 f(x)\,dx \approx 2.016280$" | mpmath 30-digit: 2.0162797196170963 (two independent quadratures, one via x=t^3 which removes the singularity, agree to all digits) | confirmed |
| 11 | "the last frame (120 sample points) gives 2.016771, still about 0.00049 high" | Script prints 2.016771455496156; mpmath M_120 = 2.016771455; error 0.000491736; frame 21 shows "Approximation = 2.016771" | confirmed |
| 12 | "From 4 sample points on, the midpoint estimate is closer to the integral than the left- or right-endpoint sum with the same number of subintervals" | n=4: |M-I|=0.00516 vs L -0.2187, R -0.2097; every n>=4 in the sequence "closer"; n=1,2 not (consistent with "from 4") | confirmed |
| 13 | "$f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near 0", $f'$ unbounded at 0 | d/dx[e^{-x}sin(8x^{2/3})] = -e^{-x}sin(...) + e^{-x}cos(8x^{2/3})(16/3)x^{-1/3}; leading term (16/3)x^{-1/3} | confirmed |
| 14 | "The measured error shrinks like $O(\Delta x^{5/3})$ rather than $O(\Delta x^2)$" | Error ratios on halving: 12->24 2.962, 24->48 3.112, 48->96 3.147, 96->192 3.159, ..., 3072->6144 3.1718, tending to 2^{5/3}=3.1748; consistent with the x^{2/3} endpoint term giving local error ~h^{1+2/3} | confirmed |
| 15 | "halving $\Delta x$ divides it by about 3.11 (from 24 to 48 subintervals), tending to $2^{5/3}\approx 3.17$, instead of 4" | 3.11248; 2^{5/3}=3.17480 | confirmed |
| 16 | "[Julia source](midpointaa.jl)" and embed `midpointaa.gif` | Files exist; regenerated GIF from scratch copy is byte-identical to committed (manifest); content is Case 1 | confirmed |
| 17 | Alt text: "each frame increases partition density, marks the midpoint samples with red dots and recomputes the midpoint-rectangle area" | As #5, #7; annotation = midpoint_sum(n) | confirmed |
| 18 | Derivation Notes: smooth f gives $O(\Delta x^2)$, "doubling the number of subintervals reduces error by roughly a factor of 4" | exact.jl with the script's routine: x^2 errors -0.6667, -0.1667, -0.04167, -0.01042 (ratio 4.000); x^3 -2, -0.5, -0.125, -0.03125 (ratio 4) | confirmed |
| 19 | Worked Example: "the frame-by-frame approximation in the animation converges as $n$ grows" | Error 0.0430 at n=6 down to 0.00049 at n=120, monotone from n=6 | confirmed |
| 20 | Implementation Notes: "keeps axis limits fixed so only density and approximation change between frames" | Lines 15-16 constant xlims (0,2), ylims (0,2.1); frames confirm | confirmed |
| 21 | Count: one case, one animation | One script, one GIF, one case heading | confirmed |

### 3. Implementation checks - `midpointaa.jl`

**Is the method it claims.** Composite midpoint rule with uniform subintervals, n = number of subintervals = number of sample points (lines 19-22). Not a left/right Riemann sum or a trapezoid variant.

**Numbers right.** Instrumented copy (`inst.jl`) versus independent mpmath (`check.py`):

| n | script | mpmath | error vs I |
|---|---|---|---|
| 1 | 2.7279291177723355 | 2.727929118 | +0.711649 |
| 2 | 1.2312160094741664 | 1.231216009 | -0.785064 |
| 4 | 2.011118372395021 | 2.011118372 | -0.00516135 |
| 6 | 2.059279922009142 | 2.059279922 | +0.0430002 |
| 8 | 2.051516783261768 | 2.051516783 | +0.0352371 |
| 10 | 2.043030305419586 | 2.043030305 | +0.0267506 |
| 12 | 2.036937496401836 | 2.036937496 | +0.0206578 |
| 14 | 2.0326672908170367 | 2.032667291 | +0.0163876 |
| 16 | 2.0296063673806675 | 2.029606367 | +0.0133266 |
| 20 | 2.0256363340591093 | 2.025636334 | +0.00935661 |
| 24 | 2.0232541562652457 | 2.023254156 | +0.00697444 |
| 28 | 2.0217081526417586 | 2.021708153 | +0.00542843 |
| 32 | 2.0206439591428174 | 2.020643959 | +0.00436424 |
| 40 | 2.019305493019697 | 2.019305493 | +0.00302577 |
| 50 | 2.018374580019836 | 2.01837458 | +0.00209486 |
| 60 | 2.017829886147683 | 2.017829886 | +0.00155017 |
| 70 | 2.017481017197507 | 2.017481017 | +0.0012013 |
| 80 | 2.017242754852992 | 2.017242755 | +0.000963035 |
| 100 | 2.0169450742923565 | 2.016945074 | +0.000665355 |
| 120 | 2.016771455496156 | 2.016771455 | +0.000491736 |

Property check independent of formula memory (`exact.jl`, script's own routine): exact (error 0.0) for 1 and x at n=1,2,4,8; not exact for x^2 (error -2/3 at n=1, i.e. -(b-a)^3/24 * f'' = -8/24*2), so degree of precision 1, as expected; error ratio 4 on halving for smooth integrands.

**Reference values.** The script draws no reference; the page's reference 2.016280 was checked (claim #10) by two 30-digit quadratures.

**Picture shows what was computed.** Rectangles span [xl, xr] with height f(xm) (lines 35-39); red dots at (xm, f(xm)) lie on the top-centre of each rectangle (frames 2, 4, 21). Annotation "Sample Points = n" and "Approximation = round(midpoint_sum(n), 6)" match the instrumented output on every frame read (frames 2-21 via contact sheet and individual frames). Function curve is the f in the code; max f on [0,2] is about 1.92, inside ylims (0, 2.1), so nothing is clipped; annotations sit at y 1.74-1.88 over x 0.8-1.5 where the curve is below 1.4, so no overlap. 21 frames = 1 title frame + 20 sample counts. No clamping or NaN masking.

### Legacy fidelity

Mathews' Midpointaa.gif (24 frames, of which 21 distinct: 3 repeats of the title frame and 2 of n=1) uses the same function, interval [0,2], the same 20 sample counts and gives the same 6-dp approximations. The page reproduces it; no dropped case and no change of example. The module's Examples 1-11 are worked text examples, not animations, and are outside the Animations section under review.

