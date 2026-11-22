# Newton-Raphson Method — animation review

Page: [`pages/numerical-methods/newton-raphson-method/index.qmd`](../../pages/numerical-methods/newton-raphson-method/index.qmd) · Scripts: `newtonaa.jl`, `newtonbb.jl`, `newtoncc.jl`, `newtondd.jl`, `newtonee.jl`, `newtonff.jl` · GIFs: 6

**Result:** 5 error, 1 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Case 1 root quoted as 0.2910; the true root is 0.25485

- **Location:** index.qmd:20 "A single real root exists near $x^* \approx 0.2910$." and index.qmd:25 alt text "...to the root at x≈0.291".
- **Now:** x* ≈ 0.2910.
- **True:** x* = 0.254850059028850… The value 0.2910 is wrong in the second decimal, and f(0.2910) = 0.181, not 0. The GIF's own final legend reads "x₍5₎ = 0.25485", so the page contradicts its own animation.
- **Evidence:** `python3 reviewer/indep.py` gives "root aa: 0.254850059028850255…". `python3 -I reviewer/roots_aa.py` gives the positive root 0.254850059 and "f(0.2910)= 0.18146". The script's x5 is 0.25485005902898933 (`julia reviewer/instr.jl`), and the last frame (committed/newtonaa/frame_006.png) shows "x₍5₎ = 0.25485".
- **Suggested fix:** On line 20, replace 0.2910 with 0.2549 (or 0.25485). On line 25, replace "x≈0.291" with "x≈0.2549".

- **Independent check:** confirmed.

### F2 — Error — Page match — Case 1 says "A single real root exists"; 3eˣ − 4cos x has infinitely many real roots

- **Location:** index.qmd:20 "A single real root exists near …"
- **Now:** The page says there is one real root.
- **True:** There is exactly one positive root, 0.25485, and infinitely many negative roots, where 3e^x is small and cos x ≈ 0: −1.3812061, −4.7190816, −7.8536904, −10.9955869, −14.1371664, −17.2787596, … The plotted window [0, 1.5] contains only the positive root.
- **Evidence:** `python3 -I reviewer/roots_aa.py` finds sign-change roots ['-17.27875962', '-14.1371664', '-10.99558687', '-7.853690397', '-4.719081558', '-1.3812061', '0.254850059'] on [-20, 3]. f(-1) = -1.06 < 0 and f(-2) = 2.07 > 0, so the root near -1.38 is beyond doubt.
- **Suggested fix:** "The function has a single positive root, at $x^* \approx 0.2549$ (it also has infinitely many negative roots, near the zeros of $\cos x$)." Alternatively: "Newton converges to the root $x^* \approx 0.2549$ …"

- **Independent check:** confirmed. Checker: true, though low impact since the plotted window [0,1.5] contains only the one positive root.

### F3 — Error — Page match — Case 1 iterates do not "overshoot then undershoot"; they decrease monotonically onto the root

- **Location:** index.qmd:21 "each tangent line rapidly overshoots then undershoots before converging"
- **Now:** The page describes alternating overshoot and undershoot.
- **True:** Every iterate lies to the right of the root, and the errors are all positive and decreasing: x = 1, 0.47975, 0.28574, 0.25558, 0.254850478, 0.254850059. This is the textbook monotone case. f is convex on [x*, 1] (f'' = 3e^x + 4cos x > 0) and f(x0) > 0, so each tangent lands between the root and the previous iterate. The frames show the same thing: every tangent foot is to the right of the root.
- **Evidence:** `python3 -I reviewer/roots_aa.py` gives errors ['0.74515', '0.2249', '0.030888', '0.00072684', '4.1871e-7', '1.3908e-13'], all positive. committed/newtonaa/sheet.png and frame_006.png show this.
- **Suggested fix:** "Starting at $x_0 = 1.0$ on the convex side of the root, each tangent line lands between the root and the previous iterate, so the iterates decrease monotonically to $x^*$; the number of correct digits roughly doubles each step (quadratic convergence)."

- **Independent check:** confirmed.

### F4 — Error — Page match — Case 4 says x³ − x + 3 has no real roots; it has one, at x ≈ −1.6717

- **Location:** index.qmd:44 heading "No real root (cycling / divergence)". index.qmd:46 "$f(x) = x^3 - x + 3$ has no real roots (its minimum value is above zero)." index.qmd:47 "…the tangent lines chase an intercept that does not exist … showing Newton-Raphson can fail completely when no root exists." index.qmd:51 alt text "divergent cycling behavior when no real root exists".
- **Now:** The page says there are no real roots and that the failure happens because no root exists.
- **True:** Every real cubic has a real root. This one has x* = −1.67169988 (the other two roots are complex, 0.83585 ± 1.04687i). The cubic has no minimum value: f → −∞ as x → −∞. The value 2.615 > 0 is only the *local* minimum at x = 1/√3. Newton fails from x0 = 0 because the iterates fall into an attracting 4-cycle, not because there is no root. The plot window [−0.5, 3.5] cuts off the real root and the part of the curve that crosses the axis, so the frames appear to support the false claim.
- **Evidence:** `python3 reviewer/indep.py` gives "root dd real: [-1.67169988165716, 0.83584994082858 - 1.04686931884998*I, …]" and "dd local min at 1/sqrt3: 0.57735 2.615099821". Directly, f(−2) = −3 < 0 < f(0) = 3.
- **Suggested fix:** Change the heading to "Cycling (non-convergence), $f(x) = x^3 - x + 3$, $x_0 = 0.0$". For the Behavior text: "$f$ has one real root, $x^* \approx -1.6717$, but it lies to the left of the local minimum at $x = 1/\sqrt{3}$. Starting at $x_0 = 0$, the iterates are trapped to the right of the local extrema and settle into an attracting 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475 → …, never approaching the root — Newton-Raphson can fail even when a root exists." Fix the alt text to match. Consider widening xlims to show x* ≈ −1.67, or saying in the text that the root is outside the window.

- **Independent check:** confirmed.

### F5 — Error — Page match — Case 5 says Newton converges to 0 with leftward jumps; it diverges to +∞ with rightward jumps

- **Location:** index.qmd:53 heading "Convergence with vanishing derivative". index.qmd:55 "…so early tangent lines produce large jumps leftward." index.qmd:56 "Convergence is eventual but the steeply angled early tangent lines…". index.qmd:60 alt text "large initial steps from x₀=2.0 before converging to the root at x=0".
- **Now:** The page says the iterates jump left and eventually converge to x* = 0.
- **True:** For x > 1 the Newton map is x_{n+1} = x_n²/(x_n − 1) > x_n, so the iterates increase without bound: 2, 4, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188, … Each step is to the right and tends to a size of +1. The tangent lines are shallow (slopes −0.135, −0.055, −0.021, …), not steep. The script's own header (newtonee.jl:2, :4) says "NON Convergence — Diverging to Infinity … Newton iterates diverge to +infinity from x0 > 1", and every frame of the GIF shows the red point moving right along the tail. The page states the opposite of its own animation.
- **Evidence:** `python3 reviewer/indep.py` gives ee: x0..x6 = 2.0, 4.0, 5.3333, 6.5641, 7.7438, 8.8921, 10.0188. `julia reviewer/instr.jl` gives identical script values. See also committed/newtonee/sheet.png.
- **Suggested fix:** Change the heading to "Divergence to infinity, $f(x) = xe^{-x}$, $x_0 = 2.0$". For the Behavior text: "The only root is $x^* = 0$, but $x_0 = 2$ lies beyond the maximum at $x = 1$. There $f > 0$ and $f'(x) = (1-x)e^{-x} < 0$, so each tangent line meets the axis to the right: $x_{n+1} = x_n^2/(x_n - 1) > x_n$. The iterates run off to $+\infty$ (2, 4, 5.33, 6.56, …) while $f(x_n) \to 0$, a reminder that a small residual does not mean a root is near." Fix the alt text to match.

- **Independent check:** confirmed. Checker: for any x0>1 the Newton step is x + x/(x−1) > x, so the iterates run to +∞; the heading 'Convergence with vanishing derivative' (line 53) is also wrong.

### F6 — Misleading — Page match — Case 4 says the iterates "cycle or diverge"; they never diverge

- **Location:** index.qmd:44 heading "(cycling / divergence)". index.qmd:47 "the iterates cycle or diverge". index.qmd:51 alt text "divergent cycling behavior".
- **Now:** The page hedges between cycling and divergence.
- **True:** The iterates stay bounded in [0, 3.0005] and converge to an attracting 4-cycle {0.0074461, 3.0005, 1.9619, 1.1475}. Over 60 iterations the cycle values settle to 6 digits. Nothing diverges.
- **Evidence:** The "dd long:" line of `python3 reviewer/indep.py` reads '3.0', '1.96154', '1.14718', '0.00657937', '3.00039', … and ends '3.0005', '1.9619', '1.1475', '0.00744608' repeating.
- **Suggested fix:** Drop "divergence" and "diverge". Say "the iterates are drawn into a stable 4-cycle (≈ 0.0074, 3.0005, 1.9619, 1.1475)". This rewrite is covered by the F4 fix.

- **Independent check:** confirmed.

### F7 — Minor — Implementation — newtondd.jl header calls the 4-cycle a cycle "between ~0 and ~3"

- **Location:** newtondd.jl:4 "# Newton iterates cycle between ~0 and ~3 indefinitely"
- **Now:** The comment describes a 2-cycle between about 0 and about 3.
- **True:** It is a 4-cycle, 0.0074 → 3.0005 → 1.9619 → 1.1475 → … The code itself is correct. Only the comment, which readers see through the "Julia source" link, is wrong.
- **Evidence:** As for F6, and from `julia reviewer/instr.jl` (newtondd x0..x10).
- **Suggested fix:** "# Newton iterates are attracted to a 4-cycle ≈ 0.0074 → 3.0005 → 1.9619 → 1.1475".

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `newtonaa.jl` | yes | 2.9 | newtonaa.gif |
| `newtonbb.jl` | yes | 3.3 | newtonbb.gif |
| `newtoncc.jl` | yes | 3.1 | newtoncc.gif |
| `newtondd.jl` | yes | 3.2 | newtondd.gif |
| `newtonee.jl` | yes | 3.0 | newtonee.gif |
| `newtonff.jl` | yes | 3.0 | newtonff.gif |

Committed GIFs byte-identical to their regenerated output: **6 of 6**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Each animation below shows the tangent-line diagram for the Newton-Raphson method." | All six scripts draw the tangent segment from (x_k, f(x_k)) to (x_{k+1}, 0), then a vertical segment to the curve (instr.jl, frames). | confirmed |
| 2 | 13 | "At each iterate $x_n$, a tangent line to $f(x)$ is drawn; its x-intercept gives $x_{n+1} = x_n - f(x_n)/f'(x_n)$" | Every script runs exactly this update with an analytic f' that matches sympy. The drawn segment's slope equals f'(x_k) to 8 digits in every case (instr.out). | confirmed |
| 3 | 14 | "The sequence of tangent lines traces the convergence (or divergence) toward a root." | Generic. True for Cases 1–3, 6 (diverges), 5 (diverges). Case 4 cycles. | confirmed (generic) |
| 4 | 16 | "Julia source scripts … are linked under each case." | Links at lines 23, 31, 40, 49, 58, 67 point to the six scripts. manifest: each script produces exactly its embedded GIF, byte-identical. | confirmed |
| 5 | 18 | Case 1 heading: "Quadratic convergence, $f(x) = 3e^x - 4\cos(x)$, $x_0 = 1.0$" | newtonaa.jl:10, 14 match. e_{n+1}/e_n² = 0.405, 0.611, 0.762, 0.793, approaching f''/(2f') = 0.7933. | confirmed |
| 6 | 20 | "A single real root exists" | Infinitely many negative real roots (−1.3812, −4.7191, …) | wrong (→ F2) |
| 7 | 20 | "near $x^* \approx 0.2910$" | x* = 0.2548501 | wrong (→ F1) |
| 8 | 21 | "each tangent line rapidly overshoots then undershoots before converging" | Iterates decrease monotonically from the right. All errors are positive. | wrong (→ F3) |
| 9 | 21 | "illustrating the quadratic convergence rate typical of Newton-Raphson near a simple root" | See #5. f'(x*) = 4.879 ≠ 0, so the root is simple. | confirmed |
| 10 | 23/25 | Case 1 link newtonaa.jl, embed newtonaa.gif | manifest | confirmed |
| 11 | 25 | alt: "rapid convergence from x₀=1.0 to the root at x≈0.291" | "rapid convergence from 1.0" is true. The root is 0.2549. | wrong (→ F1) |
| 12 | 27 | Case 2 heading: "Linear convergence (double root), $f(x) = (1-5x)^2$, $x_0 = 1.0$" | newtonbb.jl:11, 15 match. The errors 0.8, 0.4, 0.2, … halve exactly. | confirmed |
| 13 | 29 | "A double root at $x^* = 0.2$." | f = 25(x − 0.2)² | confirmed |
| 14 | 29 | "Because $f'(x^*) = 0$, the standard convergence proof breaks down and Newton-Raphson degrades to linear convergence" | f'(0.2) = 0. The iteration reduces to x_{n+1} − 0.2 = (x_n − 0.2)/2. | confirmed |
| 15 | 29 | "each step roughly halves the error rather than squaring it" | Exactly halves: x12 − 0.2 = 0.8/2¹² = 1.953e-4 (script 0.2001953125). | confirmed |
| 16 | 31/33 | Case 2 link and embed | manifest | confirmed |
| 17 | 33 | alt: "slow linear convergence to the double root at x=0.2" | as above | confirmed |
| 18 | 35 | Case 3 heading: "Convergent near inflection point, $f(x) = \arctan(x)$, $x_0 = 1.35$" | newtoncc.jl:11, 15 match. The sequence converges to 0 (x8 = 2.5e-51 in mpmath). arctan's inflection point is at 0, the root. | confirmed |
| 19 | 37 | "The only root is $x^* = 0$." | arctan is strictly increasing with arctan(0) = 0. | confirmed |
| 20 | 37 | "converges only when $\|x_0\| < x_c \approx 1.3917$" | x_c solves 2x = (1+x²)arctan x: 1.39174520027… An mpmath scan converges at 1.39174 and diverges at 1.39175. | confirmed |
| 21 | 38 | "Starting at $x_0 = 1.35$ (just inside the convergence radius), the method converges" | 1.35 < 1.39175. The sequence converges. | confirmed |
| 22 | 38 | "requires several oscillating steps before settling in" | Signs alternate: 1.35, −1.284, 1.124, −0.786, 0.292, −0.0163, 2.9e-6, … | confirmed |
| 23 | 40/42 | Case 3 link and embed | manifest | confirmed |
| 24 | 42 | alt: "convergent case starting just inside the critical radius at x₀=1.35" | as above | confirmed |
| 25 | 44 | Case 4 heading: "No real root (cycling / divergence), $f(x) = x^3 - x + 3$, $x_0 = 0.0$" | Function and x0 match newtondd.jl:11, 15. There is a real root at −1.6717. The iterates cycle and do not diverge. | wrong (→ F4, F6) |
| 26 | 46 | "has no real roots (its minimum value is above zero)" | Real root −1.67170. Only the local minimum (2.615) is positive. f → −∞. | wrong (→ F4) |
| 27 | 47 | "the tangent lines chase an intercept that does not exist" | A root exists. The iterates are trapped in a 4-cycle. | wrong (→ F4) |
| 28 | 47 | "the iterates cycle or diverge" | Attracting 4-cycle, bounded, no divergence | wrong (→ F6) |
| 29 | 47 | "Newton-Raphson can fail completely when no root exists" | The premise is false for this function. Newton fails here even though a root exists. | wrong (→ F4) |
| 30 | 49/51 | Case 4 link and embed | manifest | confirmed |
| 31 | 51 | alt: "divergent cycling behavior when no real root exists, starting at x₀=0" | as #25–28 | wrong (→ F4, F6) |
| 32 | 53 | Case 5 heading: "Convergence with vanishing derivative, $f(x) = xe^{-x}$, $x_0 = 2.0$" | Function and x0 match newtonee.jl:11, 15. The iterates diverge to +∞. | wrong (→ F5) |
| 33 | 55 | "The only root is $x^* = 0$." | x e^{-x} = 0 only at x = 0. | confirmed |
| 34 | 55 | "For large $x$, $f'(x) = (1-x)e^{-x}$ is small and negative" | Formula matches sympy. f'(2) = −0.135, f'(10) = −4e-4. | confirmed |
| 35 | 55 | "so early tangent lines produce large jumps leftward" | All steps go right: +2, +1.33, +1.23, +1.18, +1.15, +1.13. | wrong (→ F5) |
| 36 | 56 | "Convergence is eventual" | x6 = 10.019 and the sequence is increasing without bound (x_{n+1} = x_n²/(x_n − 1)). | wrong (→ F5) |
| 37 | 56 | "the steeply angled early tangent lines demonstrate the effect of a nearly-flat curve far from the root" | The tangents are shallow (slopes from −0.135 down to −0.001). The flat tail does push iterates away, but away from the root, not toward it. | wrong (→ F5) |
| 38 | 58/60 | Case 5 link and embed | manifest | confirmed |
| 39 | 60 | alt: "large initial steps from x₀=2.0 before converging to the root at x=0" | diverges to +∞ | wrong (→ F5) |
| 40 | 62 | Case 6 heading: "Divergent, $f(x) = \arctan(x)$, $x_0 = 1.4$" | newtonff.jl:11, 15 match. \|x_n\| = 1.4, 1.414, 1.450, 1.551, 1.847, 2.894, 8.710 | confirmed |
| 41 | 64 | "Same function as Case 3 but starting at $x_0 = 1.4$ — just outside the critical convergence radius $x_c \approx 1.3917$" | 1.4 > 1.39175 | confirmed |
| 42 | 65 | "The iterates do not converge to the root; they escape toward larger $\|x\|$" | see #40 | confirmed |
| 43 | 65 | "illustrating the sensitivity of Newton-Raphson to the choice of starting point" | 1.35 converges and 1.4 diverges (and 1.39174 vs 1.39175 in the scan). | confirmed |
| 44 | 67/69 | Case 6 link and embed | manifest | confirmed |
| 45 | 69 | alt: "divergent case starting just outside the critical radius at x₀=1.4" | as above | confirmed |
| 46 | — | Counts: each GIF shows x0..x_N, one new tangent per frame | Frames = n_iters + 1: 6/13/9/11/7/7, matching manifest n_frames. | confirmed |

## Implementation checks

All derivatives were compared with sympy (`indep.py`) and with a central finite difference of the script's own `f` (`instr.jl`). All six `fp` functions are correct. The script iterates agree with the 50-digit mpmath iterates to about 1e-15 relative in every case. The page has no separate Description section, so the only method statement is the update formula on line 13, which every script implements.

### newtonaa.jl
- Method: plain Newton, x_{k+1} = x_k − f/f' (line 26), with f' = 3e^x + 4 sin x (correct).
- Numbers (script beside mpmath): x1 0.47975201560571856 / 0.4797520156057186; x2 0.28573835913112816 / 0.28573835913112816; x3 0.2555769004716556 / 0.2555769004716557; x4 0.25485047773432778 / 0.25485047773432775; x5 0.25485005902898933 / 0.25485005902898934.
- Reference values: none are drawn. The true root is 0.254850059028850 (mpmath findroot). The page value 0.2910 is wrong (F1).
- Picture: Viewed sheet.png and frame_006.png. Each segment's slope equals f'(x_k): 11.5207, 6.6933, 5.1197, 4.8848, 4.8792 (instr.out). The legend labels x₍k₎ match the values to 5 decimals. No clamping is needed (f(1) = 5.99 is inside ylims [-2, 10]).

### newtonbb.jl
- Method: plain Newton with f' = −10(1 − 5x) (correct).
- Numbers: x1..x12 = 0.6, 0.4, 0.3, 0.25, 0.225, 0.2125, 0.20625, 0.203125, 0.2015625, 0.20078125, 0.200390625, 0.2001953125, identical in the script and in mpmath (exact halving of the error).
- Reference values: none drawn. Double root 0.2 confirmed.
- Picture: Viewed sheet.png (frames 1, 3, 5, …, 13). The segment slopes 40, 20, 10, … equal f'(x_k). The legend values match. Everything is inside the axis limits (f(1) = 16 < 18).

### newtoncc.jl
- Method: plain Newton, f' = 1/(1+x²) (correct).
- Numbers: x1 −1.2840911496321357 / −1.2840911496321356; x2 1.1241231064736947 / 1.124123106473695; x3 −0.7858718810026537 / −0.78587188100265425; x4 0.29155397739397171 / 0.29155397739397222; x5 −0.016251001443270185 / −0.016251001443270304; x6 2.8610548941897e-6 / 2.8610548941902e-6; x7 −1.56e-17 / −1.56e-17; x8 0 (underflow) / 2.5e-51. The last digits differ only because the iteration amplifies round-off.
- Reference values: x_c = 1.3917452002707 (mpmath findroot of 2x = (1+x²)arctan x), confirmed by a convergence scan.
- Picture: Viewed the whole sheet.png (all 9 frames). All iterates are within xlims [−3, 2.5], so no segment is suppressed and no clamping occurs. The slopes equal f'(x_k). The legends "x₍6₎ = 0.0" and "x₍7₎ = -0.0" are rounding of 2.9e-6 and −1.6e-17, which is acceptable.

### newtondd.jl
- Method: plain Newton, f' = 3x² − 1 (correct).
- Numbers: x1..x10 = 3, 1.9615384615384615, 1.1471759614035466, 0.0065793714807121, 3.0003890740712329, 1.961818175666325, 1.1474302284816, 0.007256247552424, 3.0004731887732, 1.9618786463602, the same in the script and in mpmath. A long run (60 iterations) converges to the 4-cycle 0.00744608 / 3.0005 / 1.9619 / 1.1475.
- Reference values: none drawn. The real root −1.67169988 lies outside the window (F4).
- Picture: Viewed the whole sheet.png (11 frames). The y-clamp at line 47/50/57 never activates, because the largest f(x_k) is 27.012, below ylims[2] = 30, and the smallest is 2.99, above −3 (instr.out: all in_y=true). No clamped value is drawn or labelled. The slopes equal f'(x_k) (−1, 26, 10.54, 2.948, …). The legends match to 4 decimals. The comment on line 4 is inaccurate (F7).

### newtonee.jl
- Method: plain Newton, f' = (1 − x)e^{−x} (correct).
- Numbers: x1..x6 = 4, 5.333333333333333, 6.5641025641025639, 7.7438260664067116, 8.8921098433239933, 10.018818672756456, matching mpmath to all printed digits.
- Reference values: none.
- Picture: Viewed the whole sheet.png (7 frames). Every iterate is inside xlims [0, 11], so the "→ ∞" legend branch (line 59) is never used and nothing is suppressed or clamped. The slopes equal f'(x_k) (−0.1353, −0.0549, …). The frames correctly show monotone rightward divergence, which contradicts the page (F5).

### newtonff.jl
- Method: plain Newton, f' = 1/(1+x²) (correct).
- Numbers: x1..x6 = −1.4136186488037423, 1.4501293146283372, −1.5506259756377534, 1.8470540841501899, −2.8935623931424104, 8.7103258469831832, against mpmath −1.41361864880374, 1.45012931462834, −1.55062597563775, 1.84705408415019, −2.89356239314242, 8.71032584698323.
- Reference values: x_c as above.
- Picture: Viewed sheet.png and frame_007.png. x6 = 8.71 is outside xlims [−4, 5]. The script does not draw the final tangent from x5 to x6 and labels the point with its true value, "x₍6₎ = 8.71 (out of range)". It is not clamped or presented as if it were inside the window, so this is acceptable. The other slopes equal f'(x_k) (0.3378, 0.3335, 0.3223, 0.2937, 0.2267, 0.1067).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/newton-raphson-method/`](evidence/newton-raphson-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
