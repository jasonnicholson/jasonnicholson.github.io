# Midpoint Rule — animation review (round 5)

Page: `pages/numerical-methods/midpoint-rule/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page was confirmed against independent computation and the frames. No implementation, page-match or fidelity errors were found.

Observation, not a finding: the on-frame text uses `round(approx; digits=6)`, so three frames show five decimals because of a trailing zero (`2.05928`, `2.04303`, `2.01783`, where the exact values are 2.0592799…, 2.0430303…, 2.0178299…). The displayed values are correct. Mathews' frames print `2.059280` etc. This is cosmetic and does not mislead.



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

Independent values come from `/usr/bin/python3 -I indep.py` (mpmath, 40 digits). The reference integral was computed two ways that agree to 40 digits: substituting x = t^3 to remove the x^{2/3} singularity, and direct tanh-sinh on 40 subintervals. Both give I = 2.01627971961709632788…

| # | Page claim (page's words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "For a uniform partition of [a,b] into n pieces with Δx=(b−a)/n … M_n = Δx Σ_{i=0}^{n−1} f(a+(i+½)Δx)" | `midpoint_sum` (l.19–22) is exactly this. | confirmed |
| D2 | "each subinterval contributes a rectangle centered at its midpoint sample" | l.33–41: rectangle on [xl,xr] with height f(xm), xm=(xl+xr)/2. Frames 2 and 4 show it. | confirmed |
| D3 | "often much more accurate than left/right endpoint sums at the same n" | General statement. On this integrand it holds for n≥4 (see B4). | confirmed |
| A1 | Function y = e^{-x} sin(8x^{2/3}) + 1 | l.8 `exp(-x)*sin(8*x^(2/3))+1`. Legacy frame label is the same. | confirmed |
| A2 | Interval [0,2] | l.9 `a, b = 0.0, 2.0`; frames have x-axis 0–2. | confirmed |
| A3 | "Each frame increases sample-point density across the full interval and updates the integral estimate" | Frames 2–21 have n = 1,2,4,…,120 (strictly increasing), partitioning all of [0,2]. Frame 1 shows the bare curve (n=0). | confirmed |
| A4 | "same function, interval and sequence of sample counts (1 to 120)" as Mathews | Legacy captions: 1,(1),2,4,6,8,10,12,14,16,20,24,28,32,40,50,60,70,80,100,120. Script `n_seq` (l.12–13) is identical. The legacy approximations also match the script's to 6 decimals. | confirmed |
| A5 | "each midpoint sample marked by a red dot" | l.43–44 scatter at (xs, f(xs)), `markercolor=:red`; visible in the frames. | confirmed |
| A6 | Case heading "Midpoint Rule, y = e^{-x} sin(8x^{2/3})+1" | Matches the script and the frame title "Midpoint Rule". | confirmed |
| B1 | "Over the first few frames the estimate jumps above and below the integral" | M_1 = 2.727929 (above), M_2 = 1.231216 (below), M_4 = 2.011118 (below), M_6 = 2.059280 (above). | confirmed |
| B2 | "from 6 sample points on it stays above ∫_0^2 f ≈ 2.016280 and decreases toward it in every frame" | I = 2.0162797196 rounds to 2.016280. Errors for n=6…120 are all positive (0.0430 … 0.000492), and M_n < M_prev at every step from 6→8 through 100→120. | confirmed |
| B3 | "the last frame (120 sample points) gives 2.016771, still about 0.00049 high" | M_120 = 2.016771455; error 0.000491736. | confirmed |
| B4 | "From 4 sample points on, the midpoint estimate is closer to the integral than the left- or right-endpoint sum" | \|M−I\| < min(\|L−I\|, \|R−I\|) is True for every n in the sequence from 4 to 120. It is False for n=1 and n=2, consistent with "from 4". | confirmed |
| B5 | "f′ unbounded at x=0 (f′(x) ≈ (16/3) x^{-1/3} near 0)" | f′ = −e^{-x} sin(8x^{2/3}) + e^{-x} cos(8x^{2/3})·(16/3)x^{-1/3}, which tends to (16/3)x^{-1/3} as x→0. | confirmed |
| B6 | "measured error shrinks like O(Δx^{5/3}) … halving Δx divides it by about 3.11 (from 24 to 48 subintervals), tending to 2^{5/3}≈3.17" | Error ratios E_n/E_{2n}: 12→2.962, 24→3.112, 48→3.147, 96→3.159, …, 3072→3.172. 2^{5/3} = 3.1748. This is consistent with the x^{2/3} endpoint term giving h^{1+2/3}. | confirmed |
| G1 | Alt text: "each frame increases partition density, marks the midpoint samples with red dots and recomputes the midpoint-rectangle area" | As in A3/A5. The first frame is the bare curve, which is harmless. | confirmed |
| W1 | `[Julia source](midpointaa.jl)` and embed `midpointaa.gif` | Both files exist. The script writes `midpointaa.gif`, and the regenerated GIF is byte-identical to the committed one (manifest). | confirmed |
| N1 | Derivation Notes: for C^2 f, error O(Δx^2); doubling n cuts error by about 4 | Standard result (composite remainder −(b−a)h²f″(ξ)/24, as in Mathews' module). Not contradicted by this page, which explicitly says it fails for this integrand. | confirmed |
| N2 | Worked Example: "the frame-by-frame approximation … converges as n grows" | The errors decrease monotonically from n=6 to 4.9e-4 at n=120 (B2). | confirmed |
| N3 | Implementation Notes: "keeps axis limits fixed" | l.15–16 and l.25: xlims (0,2), ylims (0,2.1) on every frame. max f = 1.9198 and min f = 0.3572 (sampled on 200001 points), so nothing is clipped. | confirmed |
| F1 | Frame captions "Approximation = …" in all 20 nonblank frames | All agree with the independent M_n at 6 decimals (table in §3). | confirmed |

### 3. Implementation checks — `midpointaa.jl`

**Method.** `midpoint_sum(n)` is the composite midpoint rule with uniform Δx = (b−a)/n and samples a+(i+½)Δx, i=0…n−1. It is not a left/right sum or another neighbouring rule. The instrumented run asserts that the sample points are spaced exactly Δx apart.

**Numbers.** I ran `julia inst_run.jl`, which includes the script's definitions and prints `midpoint_sum(n)`. I compared that output with `python3 -I indep.py`, which is independent and uses 40-digit mpmath:

| n | script | independent | error vs I |
|---|---|---|---|
| 1 | 2.7279291177723355 | 2.727929118 | +0.711649 |
| 2 | 1.2312160094741664 | 1.231216009 | −0.785064 |
| 4 | 2.011118372395021 | 2.011118372 | −0.00516135 |
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

They agree to every digit compared. Mathews' legacy captions give the same 6-decimal values.

**Reference values.** The script draws no exact-integral reference. The page's I ≈ 2.016280 was verified two independent ways (substitution x=t³ and direct subdivided quadrature), which agree to 40 digits: 2.0162797196170963…

**Picture.** I viewed frames 2 (n=1), 4 (n=4) and the contact sheet (frames 1,3,5,…,21, including the last, n=120). The rectangles span [x_i, x_{i+1}] with height f(midpoint), and the red dots sit on the curve at the midpoints. The magenta curve is the same f as l.8. The captions report the current n and M_n. The title "Midpoint Rule" is correct. Fixed limits (0,2)×(0,2.1) contain the whole curve (range 0.357–1.920), so there is no clamping or masking. There are 21 frames (one bare curve plus 20 values of n) at fps=2. The caption at (1.15, 1.74–1.88) does not overlap the curve, whose second peak is ≈1.38 near x≈0.95.

