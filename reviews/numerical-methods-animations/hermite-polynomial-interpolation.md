# Hermite Polynomial Interpolation — animation review

Page: [`pages/numerical-methods/hermite-polynomial-interpolation/index.qmd`](../../pages/numerical-methods/hermite-polynomial-interpolation/index.qmd) · Scripts: `hermitepolyaa.jl`, `hermitepolybb.jl` · GIFs: 2

**Result:** 0 error, 1 misleading, 2 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Misleading — Page match — The "doubling n cuts the error by ≈16" claim is contradicted by the frames shown

- **Location:** index.qmd:28, "Doubling $n$ decreases the maximum error by approximately $2^4 = 16$, consistent with the $O(h^4)$ convergence rate."
- **Now:** The page says each doubling of n divides the max error by about 16. The animation shows only n = 1, 2, 4, 8.
- **True:** The max errors the script computes for the frames shown are 0.4254 (n=1), 0.2146 (n=2), 0.01079 (n=4) and 0.000906 (n=8). The ratios are **1.98, 19.9 and 11.9**, so none of them is close to 16. The ratio reaches about 16 only past the frames shown: 15.0 for n=8→16, 15.7 for n=16→32 and 15.9 for n=32→64. O(h⁴) is the correct asymptotic rate, but at h = 2π, π, π/2 and π/4 the method is not yet in the asymptotic regime.
- **Evidence:** `cd reviewer && julia aa_instr.jl` printed:
  `n=1 err=4.253816e-01; n=2 err=2.146018e-01 ratio=1.982; n=4 err=1.079068e-02 ratio=19.888; n=8 err=9.062162e-04 ratio=11.907; n=16 ratio=14.958; n=32 ratio=15.738; n=64 ratio=15.934`.
  scipy `CubicHermiteSpline` on a 200001-point grid (`indep_check.py`) gives the same errors: 4.253816e-01, 2.146018e-01, 1.079068e-02, 9.062162e-04.
- **Suggested fix:** Change the sentence to say the ratio *tends to* 16 as n grows. Give the errors actually shown (0.425, 0.215, 0.0108, 0.000906, with ratios 2.0, 19.9, 11.9) and note that the coarse meshes are not yet in the asymptotic range. An alternative is to extend `n_intervals_list` to include 16 and 32, where the ratios are 15.0 and 15.7.

- **Independent check:** confirmed.

### F2 — Minor — Implementation — The Case 1 frame titles are cut off and hide the error value

- **Location:** hermitepolyaa.jl:50–53 (`size=(700, 500)` and the long `title=` string). Visible in committed/hermitepolyaa/frame_001…004.png.
- **Now:** The title runs past the right edge of the 700-px canvas, so the error value is truncated:
  - Frame 1 shows "max err ≈ 0.42".
  - Frame 2 shows "≈ 0.21".
  - Frame 3 shows "≈ 0.01".
  - Frame 4 shows "≈ 0.000", which reads as zero error. The closing parenthesis is cut off on every frame.
- **True:** The computed values are 0.425, 0.215, 0.0108 and 0.000906. These numbers are the only on-screen evidence for the convergence claim at index.qmd:28, and the reader cannot read them.
- **Evidence:** Viewed frame_001.png, frame_003.png and frame_004.png at full size. The script's own `round(err, sigdigits=3)` strings are 0.425, 0.215, 0.0108 and 0.000906 (`julia aa_instr.jl`, "title=" column).
- **Suggested fix:** Shorten the title, for example "Piecewise cubic Hermite, n = $n, max err = $(…)". Other options are a `titlefontsize` around 11, or moving the error into the legend or an annotation.

- **Independent check:** not run (minor finding, unverified).

### F3 — Minor — Implementation — Case 2 y-limits clip the first two stages, so the basis-function behaviour the page describes is hidden

- **Location:** hermitepolybb.jl:40 (`ylims=(0.8, 3.0)`), and index.qmd:36, "each carry one degree of freedom (a value or derivative at an endpoint)".
- **Now:**
  - Frame 1 (y₀·H₀₀) leaves the window at x ≈ 0.288, so 71% of the curve is not drawn.
  - Frame 2 (y₀·H₀₀ + h·y₀'·H₁₀) leaves at x ≈ 0.396, so 60% is hidden.
  - Both curves actually descend to 0 at x = 1 with zero slope. That is exactly the "carries no value or slope at the other endpoint" property the Behavior paragraph describes, and the viewer never sees it.
  - The animation also draws only cumulative partial sums. H₁₀, H₀₁ and H₁₁ are never shown individually, although the alt text says the "Four Hermite basis function contributions" are "revealed one at a time".
- **True:** For y₀·H₀₀ the minimum is 0.000, at x = 1. For the sum of the first two terms the maximum is 1.0535 and the minimum is 0.000, at x = 1. Frames 3 and 4 stay inside the window, with a minimum of 1.000.
- **Evidence:** `julia bb_instr.jl`: `term1 min=0.00000 (at x=1.0000) ... frac of pts below 0.8: 0.713 first x below 0.8: 0.288`; `t1+t2 min=0.00000 ... frac below 0.8: 0.605 first x below 0.8: 0.396`. Viewed committed/hermitepolybb/frame_001.png: the blue curve exits the bottom edge at x ≈ 0.29.
- **Suggested fix:** Set `ylims=(-0.2, 3.0)` or similar so every partial sum is fully visible. Optionally, overlay each new weighted basis term on its own (thin line) beside the running sum, so that the alt text's "revealed one at a time" holds literally.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `hermitepolyaa.jl` | yes | 2.8 | hermitepolyaa.gif |
| `hermitepolybb.jl` | yes | 2.9 | hermitepolybb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Hermite polynomial interpolation extends ordinary node-value interpolation by matching both function values and first derivatives at interpolation nodes" | General definition. The sympy and Krogh checks below confirm both scripts enforce f and f′ at the nodes. | confirmed |
| 2 | 12–16 | Two endpoints, h = x₁−x₀, t = (x−x₀)/h, H(x)=y₀H₀₀(t)+hy₀′H₁₀(t)+y₁H₀₁(t)+hy₁′H₁₁(t) | Matches hermitepolyaa.jl:25–31 and hermitepolybb.jl:20–28 term for term. Script output equals scipy Krogh (repeated nodes) to ≤1.6e-15. | confirmed |
| 3 | 18 | "$H_{00},H_{10},H_{01},H_{11}$ are the standard cubic Hermite basis functions" | sympy: [H(0),H′(0),H(1),H′(1)] = H00 [1,0,0,0], H10 [0,1,0,0], H01 [0,0,1,0], H11 [0,0,0,1]. All have degree 3. | confirmed |
| 4 | 18 | "In piecewise form over many subintervals, this gives a smooth $C^1$ approximation that preserves both value and slope information at each node" | sympy, n=4: every piece matches sin and cos exactly at both of its ends, so values and first derivatives agree at interior nodes (C¹). | confirmed |
| 5 | 22 | "These animations illustrate the cubic Hermite polynomial, which interpolates both function values and first derivatives at the endpoint nodes" | Both scripts use the two-node cubic: piecewise in Case 1, a single interval in Case 2. Neither shows the global Hermite polynomial of degree 2n+1 through n+1 nodes, and the page does not claim to. | confirmed |
| 6 | 22 | "Unlike ordinary polynomial interpolation, Hermite interpolation matches the slope at each node, giving a smoother fit." | Slope matching is confirmed. "Smoother" has no stated basis of comparison: the piecewise cubic in Case 1 is only C¹, while an ordinary interpolating polynomial is C^∞. Read as "a closer, slope-consistent fit" it holds. It is too vague to call wrong. | confirmed (slope part); "smoother" not checkable as stated |
| 7 | 24 | "Julia source scripts ... are linked under each case." | Lines 30 and 38 link the scripts (manifest). | confirmed |
| 8 | 26 | Heading: "Piecewise cubic Hermite for $\sin(x)$, refining the mesh" | hermitepolyaa.jl:36–45: f = sin, nodes are equally spaced on [0,2π], n = 1,2,4,8. Output matches scipy `CubicHermiteSpline` to ≤3.5e-15. It differs from the global Hermite polynomial by 0.25, 0.011 and 9e-4 for n = 2, 4, 8, so it is piecewise, not global. | confirmed |
| 9 | 28 | "uses $n$ subintervals, each carrying a cubic polynomial that matches $f$ and $f'$ at its two endpoints" | sympy, n=4: every piece has degree 3 and zero residuals in f and f′ at both ends. Krogh per-piece reproduction is within 5e-16. | confirmed |
| 10 | 28 | "Doubling $n$ decreases the maximum error by approximately $2^4 = 16$" | Ratios over the frames shown are 1.98, 19.9 and 11.9. They approach 16 only at n ≥ 16 (15.0, 15.7, 15.9). | wrong (→ F1) |
| 11 | 28 | "consistent with the $O(h^4)$ convergence rate" | Asymptotic ratio → 15.93 at n=32→64. | confirmed (asymptotically) |
| 12 | 30 | Case 1 link `hermitepolyaa.jl` | Manifest: the script produces hermitepolyaa.gif, byte-identical to the committed file. | confirmed |
| 13 | 32 | Alt text: "Piecewise cubic Hermite interpolation of sin(x) on 0 to 2pi, showing n=1,2,4,8 intervals" | Script lines 39–40 and the 4 frames whose titles read 1, 2, 4, 8 intervals. | confirmed |
| 14 | 32 | Alt text: "the error shrinks rapidly as the mesh is refined" | 0.425 → 0.215 → 0.0108 → 0.000906. The frames show the value only in truncated form (→ F2). | confirmed |
| 15 | 32 | Embed `hermitepolyaa.gif` is Case 1 | Manifest; frames show sin(x) with n = 1…8. | confirmed |
| 16 | 34 | Heading: "Hermite basis functions building the interpolant of $e^x$ on $[0,1]$" | hermitepolybb.jl:14–17: f = f′ = eˣ, a=0, b=1. | confirmed |
| 17 | 36 | "The four cubic Hermite basis functions ... each carry one degree of freedom (a value or derivative at an endpoint)" | sympy basis table (claim 3) confirms it. The animation does not let the viewer see it, because frames 1–2 are clipped (→ F3). | confirmed (math); display issue → F3 |
| 18 | 36 | "Their weighted combination $H(x) = y_0 H_{00} + h y_0' H_{10} + y_1 H_{01} + h y_1' H_{11}$" | Matches hermitepolybb.jl:25–35. Script's sum equals Krogh([0,0,1,1]) to 8.9e-16. | confirmed |
| 19 | 36 | "equals the true function at both endpoints and matches the slope there" | sympy: H(0)−1 = H′(0)−1 = H(1)−e = H′(1)−e = 0. Script: H(0)=1.000000000000000 and H(1)=2.718281828459045 = e. | confirmed |
| 20 | 38 | Case 2 link `hermitepolybb.jl` | Manifest. | confirmed |
| 21 | 40 | Alt text: "Four Hermite basis function contributions for e^x on [0,1] revealed one at a time and summed to form the complete cubic Hermite interpolant" | 4 frames of cumulative partial sums, ending in the complete H(x) (orange), which overlays eˣ (max error 4.37e-3). The terms are revealed only as running sums, never one by one, and the first two sums are mostly off-screen. | confirmed in substance; see F3 |
| 22 | 40 | Embed `hermitepolybb.gif` is Case 2 | Manifest; the frames show eˣ on [0,1]. | confirmed |

## Implementation checks

### hermitepolyaa.jl
- **Method:** This is piecewise cubic Hermite interpolation: the C¹ cubic Hermite spline using exact derivatives f′ = cos at the nodes. It is not the global Hermite polynomial of degree 2n+1, and the page correctly calls it "piecewise" (heading and line 28).
  - `searchsortedlast` with `clamp(i,1,n)` puts x = 2π in the last interval, which is correct.
  - For n = 1 the result coincides with the global Hermite cubic, since there is one interval.
- **Numbers (script beside independent):**
  - Curve agreement: max |script − scipy CubicHermiteSpline| is 3.5e-15, 8.6e-16, 4.4e-16 and 2.4e-16 for n = 1, 2, 4, 8. Max |script − per-piece KroghInterpolator on [xᵢ,xᵢ,xᵢ₊₁,xᵢ₊₁]| is ≤1.6e-15.
  - Max error: the script gives 0.4253746, 0.2146006, 0.01079052 and 0.0009061985 on its 600-point grid. The 200001-point grid gives 0.4253816, 0.2146018, 0.01079068 and 0.0009062162. The 600-point grid underestimates only in the 5th–6th significant digit, so the 3-significant-digit title values are correct.
  - sympy (n=4, exact): each piece has degree 3 (= 2·2−1) with zero residuals in f and f′ at both ends.
  - Global Hermite polynomial for comparison (Krogh on doubled nodes): max error 0.039 (n=2), 6.4e-5 (n=4), 6.8e-12 (n=8). Its maximum deviation from the script's curve is 0.25, 0.011 and 9.1e-4. This confirms the script is piecewise.
- **Reference values:** The reference curve is sin(x) with derivative cos(x), both exact.
- **Picture:** I looked at the contact sheet and at frames 1, 3 and 4 at full size.
  - The red dashed H passes through the black node markers.
  - n=1 has a peak of about 0.605 near x ≈ 1.33, consistent with 2π(2t³−3t²+t) at t = 0.211.
  - n=8 overlays sin visually.
  - The ylims of ±1.4 contain every curve.
  - The title's error value is truncated (F2).
  - Code at lines 61–68 says it draws "slope markers as short arrows". It actually draws a horizontal gray "→" glyph at every node regardless of slope. The glyph is almost entirely hidden under the black markers; only a speck shows at x = 2π. The page does not mention it, so it misleads no one, and I record no finding.

### hermitepolybb.jl
- **Method:** A single-interval cubic Hermite interpolant on [0,1] for eˣ, built as y₀H₀₀ + h y₀′H₁₀ + y₁H₀₁ + h y₁′H₁₁ with h = 1. With two nodes, the piecewise and global Hermite interpolants coincide; the result has degree 3 = 2·2−1.
- **Numbers (script beside independent):**
  - The script's summed H matches `KroghInterpolator([0,0,1,1],[1,1,e,e])` to 8.9e-16.
  - sympy gives H(x) = (3−e)x³ + (2e−5)x² + x + 1, with degree 3 and all four endpoint conditions exactly 0.
  - Script endpoint values: H(0)=1.0 and H(1)=2.718281828459045.
  - Max |H − eˣ| = 4.37e-3 near x ≈ 0.51. The page does not claim this number.
- **Reference values:** The reference curve is eˣ with f′ = eˣ, both exact.
- **Picture:** I looked at the contact sheet and at frame 1 at full size.
  - Frame titles and legends correctly label each stage as a running sum.
  - The final orange curve overlays the dotted eˣ, and the endpoint markers sit at (0,1) and (1,e).
  - Frames 1–2 are clipped by ylims (0.8, 3.0) (F3).
  - The comment at line 50, "Endpoint markers with slope arrows", promises arrows that the script never draws. The page does not claim arrows, so this is not a finding.

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/hermite-polynomial-interpolation/`](evidence/hermite-polynomial-interpolation/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
