# Simpson's 3/8 Rule for Numerical Integration — animation review (round 2)

Page: `pages/numerical-methods/simpsons-3-8-rule-for-numerical-integration/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1 — Fidelity — Minor — the legacy note says the archived GIF is missing, but it is present

- **Location:** `index.qmd` line 34: "Legacy note: the archived animation HTML exists, but the referenced `Simpsonaa.gif` is missing in the snapshot; this reconstruction follows the module formulas and visual conventions."
- **What is there now:** the note says the original animation is unavailable.
- **What is true instead:** `/home/jason/Desktop/math-fullerton/baseline/mathews/a2001/Animations/Quadrature/Simpson38/Simpsonaa.gif` exists (228,701 bytes, 24 frames). It shows the same example as the page: $y=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$, refined up to 121 sample points, with a final approximation of 2.015810.
- **How I know:** `ls -la .../a2001/Animations/Quadrature/Simpson38/` lists `Simpsonaa.gif`, `Simpsonaa.html` and `Simpson.html`. I extracted the frames with `julia .../tools/giftools.jl Simpsonaa.gif review/legacy/frames` ("24 frames") and read the labels from a crop sheet (`review/legacy/frames/labels.png`). The legacy sequence is: three title frames, then Sample Points = 4, 4, 7, 10, 13, 16, 19, 25, 31, 37, 43, 49, 55, 61, 67, 73, 79, 85, 91, 106, 121. The approximations shown are 1.884214, 1.790470, 1.927234, 1.976629, 1.994094, 2.001834, 2.008397, 2.011141, 2.012595, 2.013477, 2.014059, 2.014468, 2.014767, 2.014994, 2.015170, 2.015311, 2.015425, 2.015519, 2.015692, 2.015810. Every one of these agrees with my independent mpmath values; for n = 78, 84 and 105 those are 2.015310723, 2.015424723 and 2.015692482. The reconstruction is therefore numerically faithful to the original. Only the note is wrong.
- **Scope note:** this line could be read as legacy inventory, which the standard excludes. I report it because it sits inside the Animations section and states a checkable fact that is false.
- **Suggested correction:** replace the note with something like: "Reconstruction of the archived Mathews animation `Simpsonaa.gif` (same integrand, interval and final 121-point approximation 2.015810), with a slightly different sequence of n." Alternatively, delete the note.

- **Independent check:** not run (Minor finding, unverified)

### F2 — Fidelity / page match — Minor — the frames never show the sample points or the boundaries between the three-subinterval panels

- **Location:** `simpson38aa.jl` lines 40–55 draw only filled cubic pieces (`fillalpha=0.65`, red line `lw=0.8`), with no node markers and no panel dividers. Line 62 then draws the magenta curve of $f$ on top, at `lw=2`. Page text affected: `index.qmd` line 28, "Piecewise cubic panels over triplets of subintervals are rebuilt at increasing density". The frame label also reads "Sample Points = …".
- **What is there now:** the triplet structure is visible only in frames 2–4 (n = 3, 6, 9), where the cubic visibly departs from $f$ and adjacent cubics meet at a kink, for example at x = 1 in frame 3. From about frame 6 (n = 15) onward, the red cubics are hidden under the thicker magenta curve. The only remaining trace of the panels is faint alpha-overlap seams in the fill (see `committed/simpson38aa/frame_010.png`, n = 27, and `frame_024.png`, n = 120). The viewer cannot see which points are sampled, or that each cubic spans three subintervals. Those are exactly the things the label and the Behavior sentence point to.
- **What the archive shows:** every legacy frame marks each sample point with a red dot and draws a red vertical line at every third node, which is the panel boundary (`review/legacy/frames/frame_024.png`).
- **Why it matters:** the method's defining structure, cubics over triplets of subintervals with weights 1, 3, 3, 2, …, is invisible for 19 of the 23 data frames. It is a departure from the source animation that a reader would notice.
- **Suggested correction:** inside the `if n > 0` block, add `scatter!(a .+ (0:n) .* dx, f.(a .+ (0:n) .* dx); color=:red, ms=2.5, msw=0)`. Also add `vline!` segments, or `plot!([x, x], [0, f(x)])` lines, at the panel boundaries `a + i*dx` for `i in 0:3:n`. Place both after the magenta curve, or draw the curve thinner, so that they stay visible.

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `simpson38aa.jl` | 0 | 6.7 | simpson38aa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `simpson38aa.gif` | 24 | byte-identical | simpson38aa |

### Page references

- Scripts linked: `simpson38aa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Verdicts are based on evidence I produced myself: the independent mpmath computation (`review/indep.py`), the instrumented script (`review/inst.jl`), the monomial tests (`review/poly.jl`), and the committed frames.

| # | Page claim (page's words) | Location | Verdict | Evidence |
|---|---|---|---|---|
| 1 | "Composite Simpson's 3/8 rule applies cubic interpolation on blocks of three subintervals." | l.12 | confirmed | The script fits an interpolating cubic on each block `[x_i, x_{i+3}]`, i = 0, 3, …. For every n, the sum of the exact cubic integrals equals `simpson38_sum(n)` to within 1e-14 (`inst.jl` "diff" column). |
| 2 | "$h=(b-a)/n$ and $n$ divisible by 3" | l.12 | confirmed | `dx = (b-a)/n`, and every entry of `n_seq` is a multiple of 3. |
| 3 | Formula $\frac{3h}{8}[f(x_0)+f(x_n)+3\sum_{i\not\equiv0}f(x_i)+2\sum_{i\equiv0,0<i<n}f(x_i)]$ | l.14 | confirmed | This is the correct composite 3/8 rule. The script implements exactly this weighting (l.27–29). My independent implementation in `indep.py` uses the same weights and gives the same values (see section 3). It is exact for $x^0$ to $x^3$ and not for $x^4$, and its error on $x^4$ falls by a factor of 81 = 3^4 when n goes from 3 to 9 (`poly.jl`). That rules out a wrong weight pattern. |
| 4 | "For smooth $f$ (four times continuously differentiable on [a,b]), the global truncation error is fourth order: $O(h^4)$" | l.17 | confirmed | Standard result, with error $-(b-a)h^4f^{(4)}(\xi)/80$. Numerically: the $x^4$ error is 0.118519 at n = 3 and 0.0014632 at n = 9, a ratio of 81.0 = 3^4. |
| 5 | "higher-order refinement of trapezoidal geometry using piecewise cubic panels" | l.17 | not checkable (descriptive) | The "piecewise cubic panels" part is confirmed, as in #1. |
| 6 | Animation shows the rule over $[0,2]$ for $y=e^{-x}\sin(8x^{2/3})+1$ | l.21–22, l.26 | confirmed | Script l.8–9: `f(x) = exp(-x)*sin(8*x^(2/3))+1`, `a, b = 0.0, 2.0`. The frames' x-axis runs from 0 to 2, and the plotted curve matches f (peak about 1.92 near x ≈ 0.087, minimum about 0.357 near x ≈ 0.43; grid extrema 0.35720 and 1.91976). |
| 7 | "Each frame recomputes the approximation across the full interval with a denser partition where n remains a multiple of 3." | l.22 | confirmed, with a trivial exception | Frames 2–24 use n = 3, 6, …, 120, which is strictly increasing and always a multiple of 3, and the panels cover all of [0,2]. Frame 1 (n = 0) is a title frame showing only the curve, so it does not recompute anything. That has no effect on a reader and is not a finding. |
| 8 | "Julia source scripts … are linked under each case." / `[Julia source](simpson38aa.jl)` | l.24, l.30 | confirmed | The link resolves to `simpson38aa.jl`, which writes `simpson38aa.gif` (l.65). The manifest reports regeneration is byte-identical. |
| 9 | Case heading: "Composite Simpson's 3/8 Rule, $f(x)=e^{-x}\sin(8x^{2/3})+1$ on $[0,2]$" | l.26 | confirmed | Same evidence as #6. |
| 10 | "Piecewise cubic panels over triplets of subintervals are rebuilt at increasing density." | l.28 | confirmed (computation); poorly visible (see F2) | The panels are computed and drawn correctly: cubic node residuals are ≤ 1.3e-14. They are visibly distinguishable only for n ≤ 9. |
| 11 | "Every approximation shown lies below the true integral" | l.28 | confirmed | All 23 errors are negative, from −0.2258 at n = 6 to −0.000469 at n = 120 (`indep.py`). |
| 12 | "$\int_0^2 f(x)\,dx \approx 2.016280$" | l.28 | confirmed | mpmath, substituting $x=t^3$ to remove the singularity, gives 2.01627971961709632788727442192. Plain `mp.quad` with breakpoints gives the identical value. Rounded to 6 decimals this is 2.016280. |
| 13 | "The error grows from 4 to 7 sample points" | l.28 | confirmed | \|err\| = 0.132066 at n = 3 (4 points) and 0.225809 at n = 6 (7 points). |
| 14 | "then shrinks at every later frame" | l.28 | confirmed | \|err\| for n = 9, …, 120 is 0.08905, 0.03965, 0.02219, 0.01445, 0.01035, 0.00788, 0.00627, 0.00514, 0.00431, 0.00368, 0.00280, 0.00222, 0.00181, 0.00151, 0.00129, 0.00111, 0.000909, 0.000761, 0.000648, 0.000560, 0.000469, which decreases strictly. |
| 15 | "the last frame (121 sample points)" | l.28 | confirmed | The last element of `n_seq` is 120, and frame 24 reads "Sample Points = 121". |
| 16 | "gives 2.01581" | l.28 | confirmed | Script 2.015810410863725, mpmath 2.015810411, frame label "Approximation = 2.01581". |
| 17 | "about 0.00047 low" | l.28 | confirmed | 2.015810411 − 2.016279720 = −0.000469309. |
| 18 | "$f'$ unbounded at $x=0$ ($f'(x)\approx \tfrac{16}{3}x^{-1/3}$ near 0)" | l.28 | confirmed | Analytically $f'=e^{-x}[\tfrac{16}{3}x^{-1/3}\cos(8x^{2/3})-\sin(8x^{2/3})]\sim\tfrac{16}{3}x^{-1/3}$. Finite differences (`poly.jl`) give 53.03, 533.33 and 5333.33 against 53.33, 533.33 and 5333.33 at x = 1e-3, 1e-6 and 1e-9. |
| 19 | "the textbook error order, which assumes smooth f, does not hold for this integrand" | l.28 | confirmed | The measured rate is about 5/3, not 4 (#20). |
| 20 | "The measured error shrinks like $O(h^{5/3})$ rather than $O(h^4)$" | l.28 | confirmed | Error ratios on halving h: 30→60: 3.396; 60→120: 3.224; 120→240: 3.189; 240→480: 3.180; 480→960: 3.177; 960→1920: 3.1759; 1920→3840: 3.1754. These converge to $2^{5/3}=3.1748$. This is consistent with theory: near 0, $f-1\approx 8x^{2/3}$, and a $x^{\alpha}$ endpoint singularity gives an $h^{1+\alpha}$ leading error term. |
| 21 | "halving h divides it by about 3.22 (from 60 to 120 subintervals)" | l.28 | confirmed | 3.22384. |
| 22 | "tending to $2^{5/3}\approx 3.17$, instead of 16" | l.28 | confirmed | $2^{5/3}=3.17480$, and the ratios approach it from above (#20). |
| 23 | Alt text: "Simpson's 3/8 Rule animation over [0,2] with full-interval density refinement: each frame updates piecewise cubic panels and the global approximation" | l.32 | confirmed (frame 1 excepted, as in #7) | Frames 2–24 each redraw the panels and the label. |
| 24 | Embed `simpson38aa.gif` is this case | l.32 | confirmed | It is produced by `simpson38aa.jl` (manifest: byte-identical regeneration). Its title, function curve and labels match the script. |
| 25 | Legacy note: "`Simpsonaa.gif` is missing in the snapshot; this reconstruction follows the module formulas and visual conventions" | l.34 | **wrong** (F1) | The GIF is present in the archive. Its visual conventions (sample-point dots and panel dividers) are only partly followed (F2). |

Counts: there is one case, one script and one GIF of 24 frames (1 title frame and 23 data frames). The page states no frame count. There is one embed and one link, both correctly wired.

Prominent frame content checked against the page: the title "Simpson's 3/8 Rule / Numerical Quadrature" is a generic method name and contradicts nothing. The label "Sample Points = n+1" is the correct count of nodes, n + 1. The label "Approximation = round(S, 6)" is correct in all 23 data frames; I compared the `inst.jl` label column with `indep.py`. Some labels drop trailing zeros (for example 1.79047 and 2.01517), which is harmless. There is no legend.

---

### 3. Implementation checks — `simpson38aa.jl`

**It is the method it claims to be.** `simpson38_sum` (l.25–30) is the standard composite Simpson's 3/8 rule. It gives weight 3 to nodes with i mod 3 ≠ 0 (l.27), weight 2 to interior nodes with i mod 3 = 0 (l.28, `3:3:n-3`, which is empty when n = 3 and guarded), and weight 1 to the endpoints, all scaled by 3h/8. It is not a mixture with the 1/3 rule and has no end correction. Every n in `n_seq` is a multiple of 3, so no remainder handling is needed.

**The numbers are right.**
- Property check, using the script's routine verbatim on $x^k$ over [0,2] (`poly.jl`): the error is ≤ 9e-16 for k = 0 to 3 at n = 3 and n = 9. It is 0.11852 (n = 3) and 0.0014632 (n = 9) for k = 4, a ratio of 81 = 3^4. So the degree of precision is 3 and the order is 4, as the rule requires.
- Values: script against independent mpmath (30 digits, my own weight loop):

| n | points | script `simpson38_sum` | mpmath | error vs I |
|---|---|---|---|---|
| 3 | 4 | 1.8842140994188474 | 1.884214099 | −0.132066 |
| 6 | 7 | 1.790470481304736 | 1.790470481 | −0.225809 |
| 9 | 10 | 1.9272339711446245 | 1.927233971 | −0.0890457 |
| 12 | 13 | 1.976629196190375 | 1.976629196 | −0.0396505 |
| 15 | 16 | 1.9940944247919974 | 1.994094425 | −0.0221853 |
| 18 | 19 | 2.001833808071699 | 2.001833808 | −0.0144459 |
| 21 | 22 | 2.005934192958429 | 2.005934193 | −0.0103455 |
| 24 | 25 | 2.008397041546531 | 2.008397042 | −0.00788268 |
| 27 | 28 | 2.0100124027891093 | 2.010012403 | −0.00626732 |
| 30 | 31 | 2.0111411216067023 | 2.011141122 | −0.0051386 |
| 33 | 34 | 2.0119677265662554 | 2.011967727 | −0.00431199 |
| 36 | 37 | 2.0125952389214476 | 2.012595239 | −0.00368448 |
| 42 | 43 | 2.0134768107053778 | 2.013476811 | −0.00280291 |
| 48 | 49 | 2.014059184718606 | 2.014059185 | −0.00222053 |
| 54 | 55 | 2.0144675377251207 | 2.014467538 | −0.00181218 |
| 60 | 61 | 2.0147667415686947 | 2.014766742 | −0.00151298 |
| 66 | 67 | 2.0149935291633914 | 2.014993529 | −0.00128619 |
| 72 | 73 | 2.015170132082283 | 2.015170132 | −0.00110959 |
| 81 | 82 | 2.0153705880411943 | 2.015370588 | −0.000909132 |
| 90 | 91 | 2.015518613868462 | 2.015518614 | −0.000761106 |
| 99 | 100 | 2.0156314275265914 | 2.015631428 | −0.000648292 |
| 108 | 109 | 2.0157196260763444 | 2.015719626 | −0.000560094 |
| 120 | 121 | 2.015810410863725 | 2.015810411 | −0.000469309 |

All values agree to the 10 digits printed. The archived Mathews GIF shows the same 6-decimal values for every n the two sequences share.

**Its reference values are right.** The script draws no exact value. The page's reference value, $I\approx2.016280$, was checked independently by two quadratures: one with the substitution $x=t^3$, which makes the integrand smooth, and one with breakpoints near 0. Both give 2.016279719617096. That is accurate far beyond the 6 decimals the comparison needs.

**The picture shows what was computed.**
- Panels: each cubic is the interpolant through the four block nodes (`poly_coeffs`, a 4×4 Vandermonde solve). Node residuals are ≤ 1.3e-14 for every n. Over all n, each cubic's exact integral summed over the panels equals `simpson38_sum(n)` to within 1e-14. So the shaded area is exactly the area the label reports.
- In frame 2 (n = 3), the single cubic crosses f at x = 0, 2/3, 4/3 and 2, which is correct. In frame 3 (n = 6), the two cubics meet at x = 1 with a visible kink, as expected for a C0 join.
- Axis limits: y ∈ [0, 2.1]. The cubics' range over all frames is [0.2010, 1.9396] (the lowest is the dip at n = 12, visible in frame 5). The range of f is [0.3572, 1.9198]. Nothing is clipped, and `fillrange=0` is at or below every cubic.
- Frame count: 24 = 1 title frame (n = 0) + 23 data frames, matching `vcat(0, n_seq)` and the committed GIF.
- Labels: the sample-point count is n + 1 and the approximation is `round(simpson38_sum(n), digits=6)`, both correct (above).
- Display limitation: see F2. With the magenta curve at lw 2 drawn on top, and no node markers or panel dividers, the panel structure is essentially invisible for n ≥ 15. This does not make any number wrong, but it hides the structure the page describes.

