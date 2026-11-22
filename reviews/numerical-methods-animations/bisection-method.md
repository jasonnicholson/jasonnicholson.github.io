# Bisection Method — animation review

Page: [`pages/numerical-methods/bisection-method/index.qmd`](../../pages/numerical-methods/bisection-method/index.qmd) · Scripts: `bisectionaa.jl`, `bisectionbb.jl` · GIFs: 2

**Result:** 2 error, 0 misleading, 1 minor.

Errors and misleading findings were each re-checked by an independent subagent given only the allegation (not the reviewer's reasoning). Minor findings were not independently re-checked. Finding IDs (F1, F2, …) are the reviewer's and match the claim ledger below.

## Findings

### F1 — Error — Page match — Quoted root x* ≈ 1.3688 is wrong; the true root is 1.36523

- **Location:** index.qmd:21 "The true root is $x^* \approx 1.3688$."; index.qmd:25 alt text "bracket narrows around the root at x≈1.3688 over 12 steps"; also bisectionaa.jl:3 header comment "True root ≈ 1.3688."
- **Now:** The page, the alt text and the script header all give the root of x³ + 4x² − 10 as ≈ 1.3688.
- **True:** The only real root is x* = 1.365230013414097 (≈ 1.3652). The quoted value is wrong in the third decimal place: f(1.3688) = +0.0591, not ≈ 0. The script's own final bracket [1.364990234375, 1.365234375] (shown in the last frame) does **not** contain 1.3688, so the page contradicts its own animation.
- **Evidence:** `reviewer/indep.py` (run with `/usr/bin/python3 -I`): sympy `real_roots(x**3+4*x**2-10)` gives `[1.36523001341410]`; mpmath `findroot` gives `1.36523001341409684576…`; `f(1.3688) = 0.0590558`; exact-rational bisection final bracket `1.364990234375 1.365234375`, `contains root: True`, `contains 1.3688: False`. `reviewer/instr_aa.jl` (the script's own loop) gives the same final bracket.
- **Suggested fix:** Replace 1.3688 with 1.3652 (or 1.36523) at index.qmd:21, index.qmd:25 and bisectionaa.jl:3.

- **Independent check:** confirmed.

### F2 — Error — Page match — "the midpoints converge monotonically" is false

- **Location:** index.qmd:21 "The bracket halves each step and the midpoints converge monotonically."
- **Now:** Claims the midpoint sequence converges monotonically.
- **True:** The midpoints jump to either side of the root: c₁…c₁₂ = 1.5, 1.25, 1.375, 1.3125, 1.34375, 1.359375, 1.3671875, 1.36328125, 1.365234375, 1.3642578125, 1.36474609375, 1.364990234375. The sequence is neither increasing nor decreasing. Even the error |c_k − x*| is not monotone: it is 4.4e-6 at k = 9 and then 9.7e-4 at k = 10 (c₉ is closer to the root than c₁₂). What does decrease monotonically is the bracket width (and so the error bound (b₀ − a₀)/2^k).
- **Evidence:** `reviewer/indep.py`: `monotone increasing? False monotone decreasing? False`; `|c_k - r|: [0.1348, 0.1152, 0.00977, 0.0527, 0.0215, 0.00586, 0.00196, 0.00195, 4.36e-06, 0.000972, 0.000484, 0.000240]`. `reviewer/instr_aa.jl` prints the same midpoints from the script's code.
- **Suggested fix:** e.g. "The bracket halves each step, so the error bound |c_k − x*| ≤ (b₀ − a₀)/2^k shrinks monotonically, though the midpoints themselves jump to either side of the root."

- **Independent check:** confirmed.

### F3 — Minor — Implementation (picture) — The last half of each animation is visually static because the axes never zoom

- **Location:** bisectionaa.jl:14 (`xlims = (-1.0, 2.2)`) and bisectionbb.jl:15 (`xlims = (0.0, 2.2)`), with fixed limits in every frame.
- **Now:** The plot area is about 520 px wide, so the bracket width 2^-k is about 163·2^-k px in Case 1 and 237·2^-k px in Case 2. From step 6 or 7 on, the bracket is 1–3 px wide; after step 8 it is less than 1 px. Frames 8–13 of bisectionaa.gif look identical except for the legend value. In bisectionbb.gif the bracket lines also merge with the orange asymptote line from about frame 5. The page's "bracket narrows … over 12 steps" (line 25) and "The bracket halves each step" (line 21) can be seen for only about the first 6 steps. The final bracket's position relative to the root cannot be seen, which is also why the wrong root in F1 does not show up in the picture.
- **True / impact:** Nothing drawn is wrong, but about half the frames convey nothing visually. This is borderline cosmetic, and I report it as Minor only because the feature the page describes falls below pixel resolution.
- **Evidence:** Viewed committed/bisectionaa/frame_002, sheet.png (frames 1,3,5,7,9,11,13), frame_013; committed/bisectionbb/sheet.png, frame_005, frame_013. Widths from `reviewer/instr_*.jl` (`final bracket width 2.441e-04`).
- **Suggested fix (optional):** Add an inset or zoom the x-limits to the current bracket in later frames, or reduce n_iters to about 7.

- **Independent check:** not run (minor finding, unverified).

## Inventory (Phase 1)

Every script was copied to scratch and run with the global Julia environment (Plots 1.41.2, SpecialFunctions 2.9.2); each was also run alone to map scripts to GIFs.

| Script | Ran | Time (s) | GIFs produced |
|---|---|---|---|
| `bisectionaa.jl` | yes | 3.6 | bisectionaa.gif |
| `bisectionbb.jl` | yes | 3.5 | bisectionbb.gif |

Committed GIFs byte-identical to their regenerated output: **2 of 2**. Decoded frames were also compared; all match.

Inventory findings: none (every script runs, every GIF is produced by a script and embedded by the page, every page reference exists, and the section index links the page).

## Claim ledger

| # | index.qmd line | Claim (page's own words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | 12 | "Each animation below shows the **bracket-halving diagram** for the bisection method." | Both scripts run plain bisection; frames show bracket lines and shading | confirmed |
| 2 | 13 | "The shaded region marks the current bracket $[a, b]$" | aa.jl:68-71, bb.jl:86-89 shade [as[k+1], bs[k+1]]; visible in frames 1–6 | confirmed (shading becomes invisible later, see F3) |
| 3 | 13 | "…that is known to contain a root (by the Intermediate Value Theorem)" | True for Case 1 (continuous f; root 1.36523 is in every bracket). Case 2 explicitly qualifies this (line 30-31) | confirmed |
| 4 | 14 | "Each frame computes the midpoint $c = \tfrac{a+b}{2}$, evaluates $f(c)$, and narrows the bracket to the half that still contains the sign change." | aa/bb.jl:26-34: c=(a+b)/2, keep [a,c] if f(a)f(c)<0 else [c,b]. Frame k shows c_k and the narrowed bracket (c_k is on its edge). Frame 0 is the initial bracket only | confirmed |
| 5 | 16 | "Julia source scripts … are linked under each case." | lines 23, 33 | confirmed |
| 6 | 18 | Case 1 heading: "$f(x) = x^3 + 4x^2 - 10$, $[a_0, b_0] = [1, 2]$" | aa.jl:10-11; title in frames | confirmed |
| 7 | 18 | "Convergent" | final bracket [1.36499, 1.36523] contains root 1.365230 | confirmed |
| 8 | 20 | "$f(1) = -5 < 0$ and $f(2) = 14 > 0$" | sympy: f(1) = -5, f(2) = 14 | confirmed |
| 9 | 20 | "so the IVT guarantees a root in $[1, 2]$" | polynomial is continuous; root 1.36523 ∈ [1,2] | confirmed |
| 10 | 21 | "The true root is $x^* \approx 1.3688$." | true root 1.365230013 | **wrong (→ F1)** |
| 11 | 21 | "The bracket halves each step" | widths 1, 1/2, …, 2^-12 = 2.44e-4 | confirmed (visible only for about the first 6 steps, F3) |
| 12 | 21 | "the midpoints converge monotonically" | midpoints alternate around root; error not monotone | **wrong (→ F2)** |
| 13 | 23 | Link `bisectionaa.jl` is Case 1 | manifest: aa.jl produces bisectionaa.gif; f and interval match | confirmed |
| 14 | 25 | Embed `bisectionaa.gif` is Case 1 | manifest: byte-identical to aa.jl output; frame title shows x³+4x²−10 | confirmed |
| 15 | 25 | Alt: "bracket narrows around the root at x≈1.3688" | root is 1.36523; final bracket excludes 1.3688 | **wrong (→ F1)** |
| 16 | 25 | Alt: "over 12 steps" | n_iters = 12; 13 frames (initial + 12) | confirmed |
| 17 | 27 | Case 2 heading: "$f(x) = \tan(x)$, $[a_0, b_0] = [1, 2]$" | bb.jl:11-12; frame title | confirmed |
| 18 | 27 | "Spurious convergence (cautionary)" | bisection converges to π/2, which is not a root | confirmed |
| 19 | 29 | "$f(1) = \tan(1) > 0$ and $f(2) = \tan(2) < 0$" | mpmath: tan 1 = 1.5574, tan 2 = −2.1850 | confirmed |
| 20 | 29 | "so there is a sign change on $[1, 2]$" | as above | confirmed |
| 21 | 30 | "this sign change is caused by the vertical asymptote at $x = \tfrac{\pi}{2} \approx 1.5708$, not a true root" | zeros of tan are kπ, none in [1,2]; π/2 = 1.570796 | confirmed |
| 22 | 31 | "Bisection converges to the asymptote" | final bracket [1.570556640625, 1.57080078125] contains π/2; \|f(c_k)\| grows (e.g. 2.2e5 at k=11) | confirmed |
| 23 | 31 | "the IVT guarantee requires $f$ to be continuous on $[a, b]$" | standard hypothesis | confirmed |
| 24 | 33 | Link `bisectionbb.jl` is Case 2 | manifest; f, interval match | confirmed |
| 25 | 35 | Embed `bisectionbb.gif` is Case 2 | manifest byte-identical; frame title "f(x) = tan(x) [cautionary case]" | confirmed |
| 26 | 35 | Alt: "method converges to the asymptote at π/2, not a root" | as #22; orange asymptote line drawn at π/2 and the bracket closes onto it | confirmed |

## Implementation checks

### bisectionaa.jl
- **Method:** Standard bisection (lines 25-35): c = (a+b)/2, replace b if f(a)f(c) < 0, else replace a. There is no early stop and no tolerance test; it runs a fixed 12 steps. This is the textbook method named in the title.
- **Numbers:** `reviewer/instr_aa.jl` (the script's loop with printing) beside `reviewer/indep.py` (exact-rational `Fraction` bisection written independently) match exactly at every step: c = 1.5, 1.25, 1.375, 1.3125, 1.34375, 1.359375, 1.3671875, 1.36328125, 1.365234375, 1.3642578125, 1.36474609375, 1.364990234375; f(c) = 2.375, −1.796875, 0.162109, −0.848389, −0.350983, −0.096409, 0.032356, −0.032150, 7.20e-5, −0.016047, −0.007989, −0.003959 (identical in both). Final bracket [1.364990234375, 1.365234375] has width 2^-12. The legend values (`round(c; digits=6)`) agree, e.g. "c_12 = 1.36499" for 1.364990234.
- **Reference values:** The only reference value is the header and page root of 1.3688. It is wrong; the true root is 1.365230013414097 (sympy real_roots and mpmath findroot agree; see F1). The script does not draw it.
- **Picture:** Viewed sheet.png (frames 1,3,5,7,9,11,13), full-size frame_002 and frame_013. The magenta curve is f on [−1, 2.2]. The dashed lines and shading are at [as[k+1], bs[k+1]], the bracket after step k. The red dot is at (c_k, f(c_k)) on the curve, with a red diamond at (c_k, 0) and a dotted drop line. Gray dots are earlier midpoints, also on the curve. The legend index k matches the step. The function in the title matches the code. No clamping is needed, since all f(c) values lie in [−12, 16]. The bracket becomes sub-pixel after about step 7 (F3).

### bisectionbb.jl
- **Method:** Identical bisection loop (lines 26-36) applied to tan on [1, 2]. Same method, no variant.
- **Numbers:** `reviewer/instr_bb.jl` beside `reviewer/indep.py` (exact-rational midpoints with mpmath tan at 30 digits) match: c = 1.5, 1.75, 1.625, 1.5625, 1.59375, 1.578125, 1.5703125, 1.57421875, 1.572265625, 1.5712890625, 1.57080078125, 1.570556640625. The signs of f(c) agree at every step (+, −, −, +, −, −, +, −, −, −, −, +), and the magnitudes agree to the printed digits (e.g. 2066.855 and −224494.35). Final bracket [1.570556640625, 1.57080078125] contains π/2 = 1.5707963268.
- **Reference values:** The asymptote is drawn at `π/2` (exact). tan has no zero in [1, 2] (zeros at kπ). Correct.
- **Picture:** Viewed sheet.png and full-size frame_005 and frame_013. The curve is drawn in two pieces, excluding |x − π/2| < 0.02, with y clamped to [−15, 15]. Midpoint f-values are clamped to ±15 (lines 94, 99). From step 4 on, |f(c)| exceeds 15, so the red dot sits on the top or bottom frame edge. Clamping preserves the sign, which is the only thing bisection uses. The legend reports c_k, not f(c_k), so no clamped value is labelled as if it were real, and the dot at the edge reads as "off-scale". I judge this acceptable display practice, not a finding. The bracket lines coincide with the orange asymptote from about frame 5 and the bracket is sub-pixel after about step 8 (F3).

## Evidence

The reviewer's and checker's computation scripts are copied to [`evidence/bisection-method/`](evidence/bisection-method/) (`reviewer/` and `verify/`). They were run from a scratch directory; paths inside them point at that scratch area and will need adjusting to re-run.
