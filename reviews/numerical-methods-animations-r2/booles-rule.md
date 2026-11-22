# Boole's Rule — animation review (round 2)

Page: `pages/numerical-methods/booles-rule/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1 — Fidelity (also affects the page match) — Minor — node markers and panel boundaries dropped, so the "panels" cannot be seen after the first few frames

- **Location:** `boolesaa.jl` lines 62–63 (each block is drawn only as a filled area under a thin red line; no node markers, no block-boundary lines). The page text it affects: "Piecewise quartic panels are rebuilt at increasing density" (Behavior) and the alt text "each frame updates piecewise quartic panels and the global approximation".
- **What is there now:** each 5-node block is drawn as `plot!(xp, yp; fillrange=0, fillcolor=:lightpink, linecolor=:red, lw=0.8)`. From about n = 16 onward (frame 5 on) the quartics lie on top of the magenta curve, and the frames show only a uniform pink area under f (see committed `frame_024.png`, and frames 4–24 in `sheet.png`). A viewer cannot see where the sample points are, how many blocks there are, or that the fill is piecewise.
- **What the legacy has:** the Mathews animation `Booleaa.gif` (same function, interval, sample counts and approximations, which I checked frame by frame, e.g. 5 → 1.553155, 9 → 1.963413, 121 → 2.015961) draws every sample point as a red dot and puts a vertical line at every block boundary x_{4k}. Its late frames therefore still show the 5-node structure (legacy `review/legacy/frame_024.png`, `frame_006.png`).
- **How I know:** I compared the committed frames with the extracted legacy frames (`julia giftools.jl .../Booleaa.gif review/legacy`). The plotting code has no `scatter!` or `vline!` call.
- **Why it is only Minor:** nothing drawn is wrong. The early frames (n = 4, 8, 12) do show distinct quartic panels, and the annotations report the correct counts and values. The loss is in what the diagram teaches, not in what it computes.
- **Suggested correction:** inside the `n > 0` branch, after drawing the blocks, add `scatter!(a .+ (0:n) .* dx, f.(a .+ (0:n) .* dx); color=:red, ms=3, msw=0)`, and draw a thin vertical line from 0 to f(x_{4k}) at each block boundary x_{4k}, k = 1..n/4−1, for example with `plot!([x,x],[0,f(x)]; color=:red, lw=0.6)`. After that change, the existing Behavior sentence and alt text describe what is visible.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `boolesaa.jl` | 0 | 6.5 | boolesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `boolesaa.gif` | 24 | byte-identical | boolesaa |

### Page references

- Scripts linked: `boolesaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (quoted or closely paraphrased) | Evidence | Verdict |
|---|---|---|---|
| D1 | "Composite Boole's rule applies a quartic interpolant on each block of four subintervals (five nodes)" | `instr.jl`: for every n in the sequence, the exact integral of the script's own Vandermonde quartics equals `boole_sum(n)` to ≤1.5e-14, and the interpolants hit the nodes to ≤5.5e-14 | confirmed |
| D2 | "spacing h=(b−a)/n with n divisible by 4" | script `dx=(b-a)/n`, n_seq all multiples of 4 | confirmed |
| D3 | $B_n=\frac{2h}{45}\sum(7f_{4k}+32f_{4k+1}+12f_{4k+2}+32f_{4k+3}+7f_{4k+4})$ | sympy moment solve on nodes 0..4 gives weights 14/45, 64/45, 8/15, 64/45, 14/45 (h=1), which is 2/45·(7,32,12,32,7); script line 35 uses the same | confirmed |
| D4 | "exact for polynomials up to degree 5" | `indep.py`: error on [0,2], n=4, is 0 for x^0…x^5, 0.0476 for x^6 and 0.333 for x^7 | confirmed |
| D5 | "for smooth f (C^6) has global error O(h^6)" | `smooth.py`: f=e^{-x}sin 8x+1, error ratios on halving h are 88.4, 69.3, 65.3, 64.3, tending to 64 | confirmed |
| D6 | "the highest-order closed Newton-Cotes rule in this set" | the section index lists trapezoidal, Simpson 1/3, Simpson 3/8 and Boole (orders 2, 4, 4, 6) | confirmed |
| A1 | "Each animation below shows the Boole's rule diagram for $f(x)=1+e^{-x}\sin(8x^{2/3})$ on [0,2]" | script line 8 `exp(-x)*sin(8*x^(2/3))+1`, a,b=0,2. There is only one animation, so "each" is just loose wording | confirmed |
| A2 | "Each frame recomputes the approximation over the full interval with a denser partition where n remains a multiple of 4" | frames 2–24: n = 4,8,…,64,72,…,120, each the full-interval sum. Frame 1 (n=0) is a title frame showing f only, which is harmless | confirmed (frames 2–24) |
| A3 | Case heading: "Composite Boole's Rule, $f(x)=1+e^{-x}\sin(8x^{2/3})$ on [0,2]" | script | confirmed |
| B1 | "Piecewise quartic panels are rebuilt at increasing density" | computation correct; visible as panels only in roughly frames 2–4 (see F1) | confirmed for the computation; visibility is F1 |
| B2 | "the approximation increases from frame to frame toward the true integral" | `indep.py` sequence 1.553155, 1.963413, 2.001295, …, 2.015922, 2.015961 is strictly increasing | confirmed |
| B3 | "staying below it" | every error B_n − I is negative (−0.463 … −3.19e-4) | confirmed |
| B4 | true integral "≈ 2.016280" | mpmath, two ways (substitution x=t³; split quad): I = 2.0162797196170963… | confirmed |
| B5 | "the last frame (121 sample points) gives 2.015961" | independent 2.015961179; script 2.0159611789; frame 24 shows "Sample Points = 121", "Approximation = 2.015961" | confirmed |
| B6 | "about 3.2×10⁻⁴ low" | error −3.185e-4 | confirmed |
| B7 | "$f'$ unbounded at x=0 ($f'(x)\approx\frac{16}{3}x^{-1/3}$ near 0)" | f' = −e^{-x}sin(8x^{2/3}) + e^{-x}cos(8x^{2/3})·(16/3)x^{-1/3}; the leading term as x→0⁺ is (16/3)x^{-1/3} | confirmed |
| B8 | "textbook error order … does not hold" / "measured error shrinks like $O(h^{5/3})$ rather than $O(h^6)$" | the halving ratios 3.182 (60→120), 3.1796, 3.1774, 3.1761, 3.1755, 3.1751 (up to n=3840) tend to 2^{5/3}=3.1748. This is consistent with the h^{1+2/3} error from the x^{2/3} term | confirmed |
| B9 | "halving h divides it by about 3.18 (from 60 to 120 subintervals)" | e60/e120 = 3.18196 | confirmed |
| B10 | "tending to $2^{5/3}\approx 3.17$, instead of $2^6=64$" | 2^{5/3}=3.1748; ratios above | confirmed |
| W1 | "[Julia source](boolesaa.jl)" | the file exists and is the only script; it writes boolesaa.gif | confirmed |
| W2 | embed `boolesaa.gif` | the committed GIF is byte-identical to the scratch regeneration of boolesaa.jl (manifest) | confirmed |
| W3 | Alt text: "…full-interval density refinement: each frame updates piecewise quartic panels and the global approximation" | true of the computation. Panels are not discernible late (F1), and frame 1 has no approximation | confirmed (see F1) |
| G1 | Frame annotations "Sample Points = n+1", "Approximation = …" | the displayed values for n=8,16,24,32,40,48,56,64,80,96,112,120 match the independent values to 6 d.p. (frame for n=64 prints "2.01537" because `round` drops the trailing zero of 2.015370; cosmetic) | confirmed |
| G2 | Frame count | 24 = 1 blank + 23 values of n; matches the legacy count of 24 | confirmed |

---

### 3. Implementation checks — `boolesaa.jl`

**It is the method claimed.** `boole_sum` (lines 26–38) is composite closed Boole's rule with weights (2h/45)(7,32,12,32,7) over blocks i=0,4,…,n−4. It is not a neighbouring rule: it is exact to degree 5 and not to degree 6, and its order is 6 on a smooth function (D4, D5). The drawing routine fits the degree-4 interpolant through the 5 nodes of each block, and the integral of that interpolant equals the Boole sum to rounding error. The rule shown and the rule computed are therefore the same.

**The numbers are right.** Script (instrumented copy `instr.jl`) beside the independent mpmath computation (`indep.py`, 30 digits):

| n | pts | script | independent |
|---|---|---|---|
| 4 | 5 | 1.5531546827 | 1.553154683 |
| 8 | 9 | 1.9634127276 | 1.963412728 |
| 12 | 13 | 2.0012951727 | 2.001295173 |
| 20 | 21 | 2.0100452875 | 2.010045288 |
| 60 | 61 | 2.0152661372 | 2.015266137 |
| 64 | 65 | 2.0153696865 | 2.015369687 |
| 120 | 121 | 2.0159611789 | 2.015961179 |

All 23 values agree to 9–10 digits. They also match the approximations printed in the legacy Mathews GIF (1.553155, 2.001295, 2.010045, 2.012680, 2.013905, 2.014809, 2.015370, 2.015653, 2.015817, 2.015922, 2.015961).

**Reference values.** The script draws no exact integral. The page's I ≈ 2.016280 was checked by two independent quadratures, one of them after the substitution x=t³ that removes the singularity: 2.01627971961709632788…

**The picture shows what was computed.** I viewed frames 1, 2, 6 and 24 and the contact sheet. Each pink block is the quartic through f at the 5 block nodes (node residual ≤5.5e-14), filled down to 0. The magenta curve is f on 800 points. On ylims [0, 2.1] nothing is clipped: interpolant range 0.124…1.864 and f range 0.357…1.920. The annotations never overlap the curves: the text sits at y ≥ 1.74, while near x≈0.8–1.5 the content stays below 1.61. The annotations report n+1 points and the computed sum rounded to 6 decimals. The title is generic and states no function, so there is nothing to contradict. The only issue is the missing node and boundary marks (F1).

**Run:** the scratch copy exits 0 in 6.5 s and its output is byte-identical to the committed GIF (manifest). The instrumented copy reused lines 1–38 of the script unchanged.

