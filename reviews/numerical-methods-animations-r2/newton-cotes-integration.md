# Newton-Cotes Integration — animation review (round 2)

Page: `pages/numerical-methods/newton-cotes-integration/`. Reported findings: **0 Error, 0 Misleading, 3 Minor**.

## Findings

### F1 — Fidelity / Page match — Minor — legacy note falsely says the archive lacks a Simpson's 3/8 GIF

- **Location:** `index.qmd` line 57: "Legacy note: the archive is incomplete for some quadrature assets (notably Simpson's 3/8 GIF), so the 3/8 case is reconstructed from method formulas and the available module examples."
- **What is there now:** a statement that the 3/8 GIF is missing from the archive and that the case was reconstructed.
- **What is true:** the archive has the GIF. `NewtonCotesMod.html` links `/a2001/Animations/Quadrature/Simpson38/Simpson.html`, and `/home/jason/Desktop/math-fullerton/baseline/mathews/a2001/Animations/Quadrature/Simpson38/Simpsonaa.gif` (630x480, 26 frames) exists. Its frames are titled "Simpson's 3/8 Rule" and use the same f(x)=e^{-x} sin(8x^{2/3})+1 on [0,2]. The page's 3/8 animation reproduces the legacy values exactly. Legacy shows 4 points 1.884214, 10 points 1.927234, 16 points 1.994094, 37 points 2.012595, 61 points 2.014767 and 85 points 2.015425. The script gives n=3 1.884214, n=9 1.927234, n=15 1.994094, n=36 2.012595, n=60 2.014767 and n=84 2.015425.
- **How I know:** `ls -la .../a2001/Animations/Quadrature/Simpson38/`; `md5sum` shows it differs from `Simpson/Simpsonaa.gif` (b8197c9b… vs c980340c…); I extracted the frames with `giftools.jl` to `review/legacy/Simpson38_Simpsonaa/` and viewed `sheet.png`. I compared those values with `inst/out_cc.txt`.
- **Borderline scope:** this note is close to the "legacy-inventory" material the standard excludes. I report it because it sits in the Animations section and states a checkable fact that is false.
- **Correction:** delete the line. If a note is wanted, write: "The 3/8 case follows the legacy Simpson's 3/8 animation."

- **Independent check:** not run (Minor finding, unverified)

### F2 — Page match / Fidelity — Minor — cases 2–4 draw no sample points or panel boundaries, so the panel structure the text describes is not visible

- **Location:** `newtoncotesbb.jl` lines 52–53, `newtoncotescc.jl` lines 53–54, `newtoncotesdd.jl` lines 63–64 (`plot!(xp, yp; fillrange=0.0, …)` only). Page text: "Pairs of subintervals are approximated by quadratics" (Case 2), "Triplets of subintervals are approximated by cubics" (Case 3) and "Blocks of four subintervals use quartic interpolation" (Case 4). Each frame also shows "Sample Points = N".
- **What is there now:** each panel is a filled area under the interpolant. There are no node markers and no vertical panel dividers. After the first two or three frames the picture is a uniform pink area under a curve that coincides with f. Examples are `committed/newtoncotescc/frame_005.png` (13 points, nothing marks them) and `committed/newtoncotesbb/frame_002.png`. A viewer cannot see the pairs, triplets or blocks of four, or the N sample points that the annotation counts. Case 1 does draw the panel edges.
- **What the legacy showed:** all four legacy GIFs draw a red dot at every sample point and a vertical red line at every panel boundary. The panel grouping and the node count can be read directly from those frames (`review/legacy/*/sheet.png`).
- **Why only Minor:** the computed areas are correct (see the implementation checks). The omission only stops the figure from showing the structure the Behavior text points to.
- **Correction:** in each of the three scripts, add `scatter!(nodes, f.(nodes); color=:red, ms=3)` for all n+1 nodes and a vertical segment `plot!([x0,x0],[0,f(x0)]; color=:red, lw=0.7)` at each panel start (and at b). This matches Case 1 and the legacy.

- **Independent check:** not run (Minor finding, unverified)

### F3 — Page match — Minor — the final frames put Simpson's 1/3 rule last in accuracy, the opposite of the page's comparison

- **Location:** `newtoncotesbb.jl` line 11–12 (`n_seq` stops at 40), versus `n_seq` reaching 120 in the other three scripts. The page (line 23) says "at equal h the higher-degree rules gain only a constant factor over the trapezoidal rule". Line 43 says the 3/8 rule's error is "about 1.25 times Simpson's 1/3 error".
- **What is there now:** the last frame of each GIF shows trapezoid 121 points 2.014944, Simpson 1/3 41 points 2.01389, Simpson 3/8 121 points 2.01581 and Boole 121 points 2.015961. The true integral is 2.01627971961709633. The final-frame errors are therefore 1.34e-3 (trapezoid), 2.39e-3 (Simpson 1/3), 4.7e-4 (3/8) and 3.2e-4 (Boole). Every sequence rises toward about 2.016, so a reader comparing final frames sees Simpson 1/3 finish furthest from the limit, worse than the trapezoid and about 5 times worse than 3/8. That is the reverse of what the page says at equal h. At equal n the script values agree with the page: at n=48, trapezoid −6.11e-3, Simpson −1.75e-3, 3/8 −2.22e-3, Boole −1.47e-3.
- **How I know:** `indep.py` (I = 2.0162797196170963279 by mpmath with the substitution x=t^3, checked by a direct split quadrature); final-frame values from `inst/out_*.txt` and the committed last frames.
- **Context:** the legacy Simpson GIF also stopped at 39 points, so this follows the legacy. It is still the only cross-case comparison the frames offer, and it points the wrong way.
- **Correction:** extend `n_seq` in `newtoncotesbb.jl` to the same final n=120 as the others, for example `[2,4,…,40, 48, 56, 64, 72, 80, 96, 108, 120]`. Alternatively, add one sentence noting that the Simpson 1/3 animation stops at 41 points.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtoncotesaa.jl` | 0 | 6.9 | newtoncotesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesbb.jl` | 0 | 6.7 | newtoncotesbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotescc.jl` | 0 | 6.8 | newtoncotescc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtoncotesdd.jl` | 0 | 7.3 | newtoncotesdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtoncotesaa.gif` | 25 | byte-identical | newtoncotesaa |
| `newtoncotesbb.gif` | 21 | byte-identical | newtoncotesbb |
| `newtoncotescc.gif` | 25 | byte-identical | newtoncotescc |
| `newtoncotesdd.gif` | 25 | byte-identical | newtoncotesdd |

### Page references

- Scripts linked: `newtoncotesaa.jl`, `newtoncotesbb.jl`, `newtoncotescc.jl`, `newtoncotesdd.jl`
- GIFs embedded: 4
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (quoted) | Check | Verdict |
|---|---|---|---|
| D1 | "approximate ∫_a^b f(x)dx by interpolating f on equally spaced nodes and integrating the interpolating polynomial on each panel" | Scripts bb/cc/dd: the drawn interpolant on each panel integrates exactly to the rule sum (diff ≤ 1.5e-14 for every n); aa uses linear segments | confirmed |
| D2 | "trapezoidal (degree 1), Simpson's 1/3 (degree 2), Simpson's 3/8 (degree 3), and Boole's rule (degree 4)" | Interpolant degree per panel in code: 1, 2, 3, 4 | confirmed |
| D3 | T_n = h[½f(x0)+Σ_{i=1}^{n-1} f(x_i)+½f(x_n)] | Matches `trapezoid_sum`; sympy NC weights m=1: [1/2,1/2] | confirmed |
| D4 | S_n = h/3[f(x0)+f(x_n)+4Σf(x_{2k-1})+2Σf(x_{2k})] | Matches `simpson_sum` (odd i: 1:2:n-1, even interior: 2:2:n-2); sympy m=2 weights [1/3,4/3,1/3] | confirmed |
| D5 | "animations … follow the legacy style by increasing point density over the full interval between frames" | All `n_seq` strictly increasing; whole [0,2] covered each frame; legacy GIFs do the same | confirmed |
| A1 | "Each case uses f(x)=e^{-x} sin(8x^{2/3})+1 on [0,2]" | All four scripts lines 8–9; xlims (0,2) | confirmed |
| A2 | "shows a different closed Newton-Cotes construction while sample density increases frame by frame" | Trapezoid, 1/3, 3/8 and Boole; endpoints included; n increases each frame after the blank first frame | confirmed |
| A3 | "x^{2/3} term makes f′ unbounded at x=0 (f′(x)≈16/3 x^{-1/3} near 0)" | f′ = e^{-x}[cos(8x^{2/3})·(16/3)x^{-1/3} − sin(8x^{2/3})] → (16/3)x^{-1/3} | confirmed |
| A4 | "measured error of all four rules shrinks like O(h^{5/3})" | Successive error ratios tend to 3.172–3.175 for all four (n up to 3072) | confirmed |
| A5 | "halving h (from 24 to 48 subintervals) divides it by about 3.14, 3.38, 3.55 and 3.15" | Computed: 3.14152, 3.38032, 3.54990, 3.15132 | confirmed |
| A6 | "tending to 2^{5/3}≈3.17 for each" | 2^{5/3}=3.1748; ratios at n=768→1536: 3.1720, 3.1754, 3.1755, 3.1752 | confirmed |
| A7 | "instead of 4, 16, 16 and 64" | On smooth f=e^x sin 3x the scripts' own routines give ratios 4.00, 15.87, 15.73, 68.2 (→64) | confirmed |
| A8 | "at equal h the higher-degree rules gain only a constant factor over the trapezoidal rule here" | Error ratios to trapezoid are steady as n grows (all decay at the same rate, A4) | confirmed (but see F3: the final frames show the opposite ordering for Simpson 1/3) |
| C1-h | "Case 1 — Composite Trapezoidal Rule" | `newtoncotesaa.jl` runs the composite trapezoid; GIF title "Trapezoidal Rule" | confirmed |
| C1-b | "Linear segments connect adjacent sample points, creating trapezoids that refine as nodes get denser" | Frames show trapezoids with edges; segment endpoints at f(x_i) (code lines 35–41) | confirmed |
| C1-w | link `newtoncotesaa.jl`, embed `newtoncotesaa.gif`, alt "full-interval point density increases each frame and trapezoid approximation updates" | File exists; the GIF is that script's output (byte-identical regen) | confirmed |
| C2-h | "Case 2 — Composite Simpson's Rule (1/3)" | `simpson_sum` is the composite 1/3 rule; the quadratic is fitted through 3 nodes per pair | confirmed |
| C2-b | "Pairs of subintervals are approximated by quadratics, producing a visibly smoother top boundary than trapezoids" | Computation confirmed; the boundary is smoother in the frames. The pairs themselves are not visible (F2) | confirmed (F2 on visibility) |
| C2-w | link/embed `newtoncotesbb.*`, alt "piecewise quadratic area approximation updates" | Matches | confirmed |
| C3-h | "Case 3 — Composite Simpson's 3/8 Rule" | `simpson38_sum` weights 3h/8[1,3,3,2,…,3,3,1]; sympy m=3: [3/8,9/8,9/8,3/8] | confirmed |
| C3-b1 | "Triplets of subintervals are approximated by cubics" | Code: cubic through 4 nodes per triplet. Triplets not visible in the frames (F2) | confirmed (F2 on visibility) |
| C3-b2 | "not a higher-order rule: both have degree of precision 3" | The scripts' own routines with f=x^k, n=12: exact through k=3, error at k=4 for both | confirmed |
| C3-b3 | "its error at the same h is larger, about 1.25 times Simpson's 1/3 error as h shrinks" | E38/E13 at n=48, 96, 192, 768, 3072: 1.270, 1.258, 1.255, 1.2544, 1.2542 | confirmed |
| C3-w | link/embed `newtoncotescc.*`, alt "piecewise cubic area updates" | Matches | confirmed |
| C4-h | "Case 4 — Composite Boole's Rule" | `boole_sum` 2h/45[7,32,12,32,7]; sympy m=4: [14/45,64/45,8/15,64/45,14/45] = 2/45·[7,32,12,32,7] | confirmed |
| C4-b | "Blocks of four subintervals use quartic interpolation. As density rises, the piecewise quartic envelope tracks oscillations closely" | Quartic through 5 nodes per block; from 25 points on, the frames show the interpolant indistinguishable from f | confirmed (F2 on visibility of the blocks) |
| C4-w | link/embed `newtoncotesdd.*`, alt "increasing point density with piecewise quartic area updates" | Matches | confirmed |
| L1 | "the archive is incomplete … (notably Simpson's 3/8 GIF), so the 3/8 case is reconstructed" | The archive has `a2001/Animations/Quadrature/Simpson38/Simpsonaa.gif` | **wrong** (F1) |
| N1 | "fit interpolants of degree 1, 2, 3 and 4 per panel, but their degrees of precision are 1, 3, 3 and 5" | sympy moment test, and the scripts' routines on x^k: first inexact k = 2, 4, 4, 6 | confirmed |
| N2 | "rules with an even number of subintervals per panel (Simpson's 1/3, Boole) are exact for one degree more than their interpolant" | 2 and 4 subintervals → DOP = m+1; 1 and 3 → DOP = m | confirmed |
| N3 | "For smooth f (C², C⁴, C⁴, C⁶) the composite errors are O(h²), O(h⁴), O(h⁴), O(h⁶)" | Smooth-f halving ratios 4.00, 15.9, 15.7, 68→64 | confirmed |
| N4 | "|E| = 1/80 (b−a)h⁴|f⁽⁴⁾(ξ)| against 1/180 (b−a)h⁴|f⁽⁴⁾(ξ)|" | For f=x⁴ (f⁽⁴⁾=24) on [0,2], n=12, h=1/6: 1/180·2·24/1296 = 2.058e-4, and the script gives 2.06e-4. 1/80·2·24/1296 = 4.63e-4, and the script gives 4.63e-4 | confirmed |
| N5 | "Rules of very high degree on wide panels can become less robust" | General fact: closed NC weights turn negative from 9 points | confirmed (general; not exercised by the page) |
| G1 | Frame annotation "Sample Points = n+1" | n subintervals → n+1 nodes | confirmed |
| G2 | Frame annotation "Approximation = …" (all frames, all four GIFs) | Every annotated value equals the independent mpmath composite-rule value to 6 decimals (trailing zeros dropped by `round`, e.g. "2.01017" for 2.0101699) | confirmed |
| G3 | GIF titles "Trapezoidal Rule", "Simpson's Rule", "Simpson's 3/8 Rule", "Boole's Rule" | Match the cases | confirmed |

---

### 3. Implementation checks

Independent reference: I = ∫₀² (e^{-x} sin(8x^{2/3})+1) dx = **2.0162797196170963279**. I computed it with mpmath at 40 digits using the substitution x=t³, which removes the singularity, and cross-checked it with a direct split-interval quadrature (agreement to 20 digits). No script draws a reference value, so there is nothing of that kind to verify.

Independent rule weights: sympy solved the moment equations for 2, 3, 4 and 5 equally spaced nodes on [0,m] exactly. The weights are m=1 [1/2,1/2], m=2 [1/3,4/3,1/3], m=3 [3/8,9/8,9/8,3/8] and m=4 [14/45,64/45,8/15,64/45,14/45]. These come from the definition, not from memory. The composite values below use those weights in mpmath.

### `newtoncotesaa.jl` (composite trapezoidal)
- **Method:** `trapezoid_sum` = h[½f(a)+Σf(x_i)+½f(b)], the composite trapezoidal rule. Degree-of-precision test on its own routine (f=x^k, n=12): exact for k=0,1; error 0.00926 at k=2. Smooth-f halving ratios 4.005, 4.001.
- **Numbers:** script vs independent, sample: n=3 1.8990708457 / 1.899070846; n=16 1.9790558568 / 1.979055857; n=48 2.0101699261 / 2.010169926; n=120 2.0149444646 / 2.014944465. All 24 values agree to 10 digits (`inst/out_aa.txt` vs `indep.py`).
- **Reference values:** none drawn.
- **Picture:** each trapezoid is the polygon (xl,0),(xr,0),(xr,f(xr)),(xl,f(xl)), with the top segment between f(xl) and f(xr). Frames 1, 5, 13 and 25 viewed. Annotations match. ylims [0,2.1] contain f (max ≈ 1.92). 25 frames = blank + 24 values of n.

### `newtoncotesbb.jl` (composite Simpson 1/3)
- **Method:** `simpson_sum` = h/3[f0+fn+4Σodd+2Σeven interior], the composite Simpson 1/3 rule. Its own routine on x^k: exact through k=3, error 2.06e-4 at k=4. Smooth-f ratios 15.4, 15.9.
- **Numbers:** n=2 2.4912610173 / 2.491261017; n=4 1.6117863286 / 1.611786329; n=24 2.0103696294 / 2.010369629; n=40 2.0138900411 / 2.013890041. All 20 agree.
- **Picture:** the quadratic is fitted through (x0,x1,x2) for each pair by a Vandermonde solve. Maximum node residual over all frames is 2.0e-15. The exact integral of the drawn quadratics equals `simpson_sum` (|diff| ≤ 6.7e-16), so the shaded area is the annotated value. The drawn range is [0.349, 1.976], inside ylims. Frames 2, 3, 6, 11 and 21 viewed: the overshoot above f near x≈0.08 is the genuine interpolant. No nodes or panel boundaries are drawn (F2). 21 frames; stops at n=40 (F3).

### `newtoncotescc.jl` (composite Simpson 3/8)
- **Method:** `simpson38_sum` = 3h/8[f0+fn+3Σ(i mod 3≠0)+2Σ(i≡0 mod 3, interior)], the composite 3/8 rule. Own routine on x^k: exact through k=3, error 4.63e-4 at k=4, which is (1/80)/(1/180)=2.25 times Simpson's, as expected. Smooth-f ratios 14.7, 15.7.
- **Numbers:** n=3 1.8842140994 / 1.884214099; n=6 1.7904704813 / 1.790470481; n=36 2.0125952389 / 2.012595239; n=120 2.0158104109 / 2.015810411. All 24 agree. They also match the legacy Mathews 3/8 GIF wherever the two share a node count (F1).
- **Picture:** a cubic through 4 nodes per triplet. Node residual ≤ 1.3e-14. Drawn area equals the rule sum (|diff| ≤ 2.7e-15). Drawn range [0.201, 1.940]. Frames 2, 5 and 25 viewed. Same marker omission (F2).

### `newtoncotesdd.jl` (composite Boole)
- **Method:** `boole_sum` = Σ 2h/45[7,32,12,32,7] over blocks of 4, the composite Boole rule. Own routine on x^k: exact through k=5 (errors ≤ 1.8e-15), error 6.53e-5 at k=6. Smooth-f ratios 82, 68, approaching 64.
- **Numbers:** n=4 1.5531546827 / 1.553154683; n=12 2.0012951727 / 2.001295173; n=64 2.0153696865 / 2.015369687; n=120 2.0159611789 / 2.015961179. All 24 agree, and they match the legacy Boole GIF (5 points 1.553155, 13 points 2.001295, 113 points 2.015922).
- **Picture:** a quartic through 5 nodes per block. Node residual ≤ 5.5e-14 (the monomial Vandermonde is well enough conditioned at degree 4 on [0,2]). Drawn area equals the rule sum (|diff| ≤ 1.5e-14). Drawn range [0.124, 1.931]. Frames 2, 3 and 25 viewed. Same marker omission (F2).

### Asymptotic behaviour (supports A4–A8, C3-b3)
Errors (rule − I) at n=24 / n=48 and their ratio. Trapezoid −0.019194 / −0.00610979 (3.1415). Simpson 1/3 −0.00591009 / −0.00174838 (3.3803). Simpson 3/8 −0.00788268 / −0.00222053 (3.5499). Boole −0.0046354 / −0.00147094 (3.1513).
The halving ratios continue to 3.1720, 3.1754, 3.1755 and 3.1752 at n=1536→3072, against 2^{5/3} = 3.1748.

### Could not determine
Nothing material. Two claims rest on visual judgement: Case 2's "visibly smoother" and Case 4's "tracks oscillations closely". I checked both against the frames and they hold.

