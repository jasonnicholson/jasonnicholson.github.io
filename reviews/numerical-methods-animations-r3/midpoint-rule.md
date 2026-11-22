# Midpoint Rule — animation review (round 3)

Page: `pages/numerical-methods/midpoint-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding. Every claim in the ledger below was checked against values I computed myself, and every one passed.

Things I looked at and decided were not findings:
- The frame label rounds to 6 decimals and prints without trailing zeros, so n=6, 10 and 60 show `2.05928`, `2.04303` and `2.01783`, with 5 digits shown. The values are correct, and the label does not misstate any digit.
- The new GIF has no function label inside the frame, and it opens with 1 blank frame where the legacy GIF opens with 3 title frames. The page heading states the function, so this is cosmetic.
- The Mathews module's Examples 1–7 (other integrands with m = 1…16 and 50…800) are not on the page. Under the brief that is content the page does not yet have, not an archive case the animation drops. The legacy *animation* is the one case, and it is reproduced faithfully.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `midpointaa.jl` | 0 | 7.9 | midpointaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description, l.12–16 | Composite midpoint rule $M_n=\Delta x\sum_{i=0}^{n-1} f(a+(i+\tfrac12)\Delta x)$, $\Delta x=(b-a)/n$ | Script l.19–22 implements exactly this formula. Its values match my independent mpmath sum to 1e-15 (see §3). | confirmed |
| D2 | l.12 | Evaluates $f$ at subinterval midpoints rather than endpoints | code `a + (i + 0.5)*dx`; red dots sit at the rectangle centres in frames 2, 4 and 21 | confirmed |
| D3 | l.18 | Each subinterval contributes a rectangle centred at its midpoint sample | plotting l.33–41: rectangle `[xl,xr]×[0,f(xm)]`, with `xm=(xl+xr)/2` | confirmed |
| D4 | l.18 | Often much more accurate than left/right sums at the same $n$ | General statement. For this integrand it holds for every n in 4…120 (checked all 117 values) | confirmed |
| A1 | l.22–23 | Function $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$ | script l.8–9 | confirmed |
| A2 | l.23 | Each frame increases sample-point density across the full interval and updates the estimate | frames 2–21 have n = 1,2,4,…,120 over [0,2], with the estimate updated each frame. Frame 1 is the bare curve, n=0, a lead-in. | confirmed |
| A3 | l.25 | Same function, interval and sample-count sequence (1 to 120) as Mathews' animation | Legacy frame headers read 1,2,4,6,8,10,12,14,16,20,24,28,32,40,50,60,70,80,100,120 (`legacy/textcrop.png`), identical to `n_seq` l.12–13. The legacy approximations (2.727929, 2.011118, 2.051517, 2.036937, 2.029606, 2.023254, 2.020644, 2.018375, 2.017481, 2.016945) match the script's values. | confirmed |
| A4 | l.25 | Each midpoint sample marked by a red dot | l.44 `scatter!` red, visible in all frames with n>0 | confirmed |
| A5 | l.27 | Case heading: Midpoint Rule, $y=e^{-x}\sin(8x^{2/3})+1$ | script l.8 | confirmed |
| B1 | l.29 | First few frames: estimate jumps above and below the integral | n=1: +0.7116; n=2: −0.7851; n=4: −0.00516; n=6: +0.0430 | confirmed |
| B2 | l.29 | From 6 sample points on it stays above the integral | errors at n=6…120 are all positive (0.0430 down to 0.000492) | confirmed |
| B3 | l.29 | …and decreases toward it in every frame | estimate strictly decreasing over n=6→8→…→120 (`indep.py`, "dec" on every row) | confirmed |
| B4 | l.29 | $\int_0^2 f\,dx\approx 2.016280$ | mpmath, two ways (substitution $x=t^3$, and 40-panel adaptive quad): 2.0162797196170963 | confirmed |
| B5 | l.29 | Last frame (120 sample points) gives 2.016771 | script 2.016771455496156, mine 2.016771455; frame 21 label "2.016771" | confirmed |
| B6 | l.29 | Still about 0.00049 high | 2.016771455 − 2.016279720 = 0.000491736 | confirmed |
| B7 | l.29 | From 4 sample points on, midpoint is closer than left or right sum with the same n | For n=4: \|M−I\|=0.00516 vs L 0.219, R 0.210. True for every n in 4…120, and false at n=1 and n=2 (0.712 vs L 0.0163; 0.785 vs L 0.348), so "from 4" is the exact threshold | confirmed |
| B8 | l.29 | $f'$ unbounded at 0, $f'(x)\approx\tfrac{16}{3}x^{-1/3}$ near 0 | mpmath `diff` at x=1e-6: 533.3318 vs 16/3·x^{-1/3}=533.3333 | confirmed |
| B9 | l.29 | Error shrinks like $O(\Delta x^{5/3})$, not $O(\Delta x^2)$ | Error ratios under halving: 12→24 2.962, 24→48 3.112, 48→96 3.147, …, 3072→6144 3.1718, tending to 2^{5/3}=3.1748 (not 4). This agrees with the generalized Euler–Maclaurin term $h^{1+\alpha}$ for an $x^{\alpha}$ singularity with α=2/3 | confirmed |
| B10 | l.29 | Halving Δx (24→48) divides the error by about 3.11 | 3.11248 | confirmed |
| B11 | l.29 | …tending to $2^{5/3}\approx3.17$ | 3.1748; the computed ratios approach it monotonically | confirmed |
| W1 | l.31 | Source link `midpointaa.jl` | file exists. It is the only script and produces this GIF (manifest: regenerated GIF byte-identical to the committed one) | confirmed |
| W2 | l.33 | Embed `midpointaa.gif` | file exists, 21 frames, the case shown | confirmed |
| W3 | l.33 alt | Over [0,2], each frame increases partition density, marks midpoints with red dots, recomputes the midpoint-rectangle area | frames 2–21; see A2 and A4 | confirmed |
| N1 | l.37 | For $f\in C^2$, global error $O(\Delta x^2)$; doubling n cuts the error by about 4 | Property check with the script's routine: exact for 1 and x (error 0.0), not exact for x² (error −0.6667 at n=1, −0.04167 at n=4, ratio 16 = 4² for a 4× smaller step); x³ ratio also 16 | confirmed |
| N2 | l.41 | Frame-by-frame approximation converges as n grows | B3, B6 | confirmed |
| N3 | l.45 | Axis limits fixed, so only density and approximation change; mirrors legacy | `xlims=(0,2)`, `ylims=(0,2.1)` constant (l.15–16). Max f = 1.9198 and min f = 0.3572, so the curve is never clipped. The legacy frames also use fixed axes. | confirmed |

### 3. Implementation checks: `midpointaa.jl`

**It is the method it claims to be.** The script computes the composite midpoint rule (l.19–22) on a uniform partition with samples at $a+(i+\tfrac12)\Delta x$. That is the standard composite midpoint rule, the same variant the Description states. No other method passes under the name.

**The numbers are right.** I ran the script's routine (`review/instr.jl`, an identical copy of l.8–22) and an independent mpmath sum at 30 digits (`review/indep.py`):

| n | script | independent | frame label |
|---|---|---|---|
| 1 | 2.7279291177723355 | 2.727929118 | (frame 2) 2.727929 |
| 2 | 1.2312160094741664 | 1.231216009 | 1.231216 |
| 4 | 2.011118372395021 | 2.011118372 | 2.011118 |
| 6 | 2.059279922009142 | 2.059279922 | 2.05928 |
| 10 | 2.043030305419586 | 2.043030305 | 2.04303 |
| 14 | 2.0326672908170367 | 2.032667291 | 2.032667 |
| 20 | 2.0256363340591093 | 2.025636334 | 2.025636 |
| 28 | 2.0217081526417586 | 2.021708153 | 2.021708 |
| 40 | 2.019305493019697 | 2.019305493 | 2.019305 |
| 60 | 2.017829886147683 | 2.017829886 | 2.01783 |
| 80 | 2.017242754852992 | 2.017242755 | 2.017243 |
| 120 | 2.016771455496156 | 2.016771455 | 2.016771 |

All 20 values agree. The other 8 (8, 12, 16, 24, 32, 50, 70, 100) also agree and are listed in the `indep.py` output. Property checks on the same routine (`review/dop.jl`): exact for constants and x, wrong for x², and the error falls 16× when the step is cut 4×, so the degree of precision is 1 and the order is 2 for smooth f. That is what the midpoint rule should give.

**Its reference values are right.** The script itself draws no reference value. The page's reference integral 2.016280 agrees with my mpmath value 2.0162797196 (two independent quadratures agree to 30 digits).

**The picture shows what was computed.** I checked frames 1, 2, 4 and 21 and the contact sheet (frames 1, 3, 5, …, 21). Rectangles span `[xl, xl+dx]` with height `f(xm)`. Red dots are at `(xm, f(xm))` and sit exactly on the top edge midpoint of each rectangle on the magenta curve. The labels "Sample Points = n" and "Approximation = …" show the same n and value as the routine (table above). The title "Midpoint Rule" is correct. The axes are fixed and never clip the curve or the rectangles (max height 1.92 < 2.1). The annotation text at y≈1.74–1.88 near x=1.15 is above the curve there (max f on [0.6,1.7] is 1.385), so nothing is hidden. There are 21 frames: 1 lead-in plus 20 sample counts. At fps=2 that is about 10.5 s. The GIF is reproducible: per the manifest, a scratch rerun is byte-identical to the committed GIF.

**Legacy fidelity.** The function, interval, sample-count sequence, red midpoint dots, magenta curve, pink rectangles and the approximation values all match Mathews' `Midpointaa.gif`. No fidelity departure that matters to a reader.

