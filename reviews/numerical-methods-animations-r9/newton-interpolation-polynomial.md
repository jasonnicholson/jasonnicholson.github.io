# Newton Interpolation Polynomial — animation review (round 9)

Page: `pages/numerical-methods/newton-interpolation-polynomial/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


None.

These were looked at and are not findings:

- **Cases 24–26 (Γ), pole at x = 0 inside the window.** f is clamped, not broken at its poles (the `poles` list is empty), so a vertical connector across x = 0 could appear. It does not. The 1000-point grid `range(-0.2, 5.2, length=1000)` contains exactly `0.0`, `gamma(0.0) = Inf`, and `safe_eval` turns that into NaN, so the curve breaks there. The display is correct, but only because of where the grid falls. If the grid length or the window ever changes, listing `poles=[0.0]` for these rows would keep it correct. This is a robustness remark, not a finding.
- **Case 28, frame titled degree 9: a vertical blue line at x ≈ 18.18.** It is real. The degree-9 interpolant of Y₀ on 10 nodes in [0.5, 10] dives to about −39 near x = 16 and comes back up through the window. In mpmath, P(17.9) = −24.71, P(18.18) = 0.39, and the root is at x = 18.17646. It is not a plotting artifact.
- **The Newton page draws Cases 01–29 with the barycentric (Lagrange) form.** The page says so (line 26), and the polynomial is the same one. Not a mismatch.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 37.8 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtpolyaa.jl` | 0 | 7.5 | newtpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `lagnewt01.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt02.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt03.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt04.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt05.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt06.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt07.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt08.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt09.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt10.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt11.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt12.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt13.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt14.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt15.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt16.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt17.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt18.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt19.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt20.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt21.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt22.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt23.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt24.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt25.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt26.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt27.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt28.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt29.gif` | 10 | byte-identical | lagnewt_animations_all |
| `newtpolyaa.gif` | 5 | byte-identical | newtpolyaa |

### Page references

- Scripts linked: `lagnewt_animations_all.jl`, `newtpolyaa.jl`
- GIFs embedded: 30
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words, abridged) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Description l.14–18 | $P_n(x)=a_0+a_1(x-x_0)+\dots+a_n\prod_{j<n}(x-x_j)$, $a_k=f[x_0..x_k]$ | Standard. `newtpolyaa.jl` builds exactly this (in-place divided-difference table, Horner nested evaluation); coefficients match mine (row 40) | confirmed |
| 2 | l.18 | Newton and Lagrange forms give the same polynomial | Uniqueness. Numerically, barycentric output matches my mpmath Newton form to ≤ 6e-9 of the y-span (§3) | confirmed |
| 3 | l.20 | Cases 01–29 reuse the Lagrange page's cases, in Mathews' order; each heading gives f and the node interval | Shared script is identical on both pages. All 29 f and window pairs match the legacy index images one for one (`legacy_cases.png`) | confirmed |
| 4 | l.24 | Each case shows 2,3,4,5,6,8,10,12,14,16 equally spaced nodes (degree 1–5, 7, 9, 11, 13, 15) | `n_nodes_seq` in the script; 10 frames per GIF (manifest); titles read degree 1…15 on every contact sheet | confirmed |
| 5 | l.24 | Nodes at both ends of the interval | Instrumented `equal_nodes`: `trimmed=false` for all 29 cases × 10 node counts (`review/caseinfo.txt`) | confirmed |
| 6 | l.24 | Title degree = nodes − 1, the most the interpolant can have | Code `degree $(n_nodes - 1)` | confirmed |
| 7 | l.24 | Even cases are 08, 13, 17, 20, 22 | Symmetric spans with even f: 08 [−1,1], 13 [−3π,3π], 17 [−4,4], 20 [−10,10], 22 [−3,3]. No other even f has a symmetric span | confirmed |
| 8 | l.24 | In even cases the frame titled degree 1 is a horizontal line | mpmath slope a₁ = 0 for all five; horizontal in all five contact sheets | confirmed |
| 9 | l.24 | …and the frame titled degree 15 has degree 14 | mpmath, 16 nodes: x¹⁵ coeff a₁₅ ≈ 0 (≤ 2e-57, rounding at 60 digits); x¹⁴ coeff = −371.1 (08), −3.65e-12 (13), 1.40e-11 (17), −7.20e-13 (20), −1.27e-7 (22), all nonzero | confirmed |
| 10 | l.24 | Only Mathews' animations for Cases 01 and 04 survive | `Lagrange01/Lagrangeaa.gif` and `Lagrange04/Lagrangedd.gif` are GIFs. `Lagrange09/Lagrangeii.gif` is an HTML file (`file` reports HTML). No other copies in the archive | confirmed |
| 11 | l.24 | They went to degree 25 (Case 01) and 20 (Case 04) | Last legacy frames labelled S₂₅[x] and S₂₀[x] (`legacy01_labels2.png`, `legacy04_labels.png`). S₂ has 3 nodes, so the subscript is the degree | confirmed |
| 12 | l.24 | Yellow bar on the x-axis, "Tolerance ±0.05", over an interval where the interpolant is within 0.05 of f | Present in both legacy GIFs. Spot check on Case 04, S₂ (nodes 0, 1, 2): \|√x − P₂\| < 0.05 on about [0.79, 1.45], which matches the bar's extent in the frame | confirmed |
| 13 | l.24 | These frames stop at degree 15 and have no such bar | Contact sheets | confirmed |
| 14 | l.26 | Shared script evaluates in the first barycentric form, not by divided differences | `barycentric_eval`: `l(x)·Σ w_j y_j/(x−x_j)` | confirmed |
| 15 | l.26 | The last case has its own script, built from divided differences | `newtpolyaa.jl` `divided_diff` and `newton_eval` | confirmed |
| 16 | l.28, l.164 | Source links | Both files exist beside the page and are the scripts that produce the embedded GIFs (byte-identical regeneration, manifest) | confirmed |
| 17 | Case 01 heading and alt | f = 1/(1−x), nodes [−1.5, 0.9], window [−1.6, 1.5], pole at x = 1 inside; beyond the pole f ≤ −2, below the window | Script row; legacy animation nodes run from −1.5 to 0.9 (green line). For x ∈ (1, 1.5], f ≤ −2 < ylim −1.646 | confirmed |
| 18 | Case 02 heading and alt | 1/(1+x), nodes [−0.9, 1.5], window [−1.5, 1.6], pole at −1; beyond it f ≤ −2, below the window | Script; ylim −1.646 | confirmed |
| 19 | Case 03 | 1/(1−x)², [−1.5, 0.9], window [−1.6, 1.5], pole at 1 | Script; frames | confirmed |
| 20 | Cases 04–06 | √x on [0,2], [0,8], [0,10]; f drawn on [0, 10.5] | Script; legacy index ("equally spaced nodes in [0,2] / [0,8] / [0,10]", window 0 ≤ x ≤ 10.5) | confirmed |
| 21 | Case 07 | 1/√(1−x), [−1.5, 0.95], window [−1.6, 1.5], f drawn for x < 1 | Script; √(negative) throws, so NaN; legacy static example (Animation 7) uses [−1.5, 0.95] | confirmed |
| 22 | Case 08 | 1/(1+10x²), [−1, 1], f on [−1.5, 1.5] | Script; legacy index | confirmed |
| 23 | Cases 09–10 | ln x on [0.02, 2], [0.02, 4]; window [−0.5, 4.1]; f drawn for x > 0 | Script; legacy index; log of a non-positive number gives NaN | confirmed |
| 24 | Case 11 | ln(1+x), [−0.98, 1], window [−1.5, 1.5], f for x > −1 | Script; legacy index | confirmed |
| 25 | Case 12 heading | sin x, nodes [−3π, 3π] | `auto_span` gives the whole window (f finite throughout); span = (−9.42478, 9.42478). Legacy Example 9 (Animation 12) uses a = −3π, b = 3π | confirmed |
| 26 | Case 12 text and alt | With 2, 3, 4 nodes every node is a multiple of π, every divided difference is 0, so frames titled degree 1, 2, 3 show y = 0 | Nodes ±3π; −3π, 0, 3π; ±3π, ±π. mpmath a_k ≈ 1e-61 or smaller (rounding). Frames 1–3 flat at 0 | confirmed |
| 27 | Case 13 text and alt | With 2 and 4 nodes every node is an odd multiple of π, a₀ = −1, later differences 0, so degrees 1 and 3 show y = −1 | mpmath a = [−1, 0] and [−1, 0, 0, 0]; frames 1 and 3 flat at −1; frame 2 (node at 0) is not | confirmed |
| 28 | Case 14 | tan x, nodes [−1.45, 1.45] between poles ±π/2; f on [−π, π], broken at poles; degrees 1 and 2 the same line, f[x₀,x₁,x₂] = 0 | mpmath a₂ = 0 exactly (a₁ = 5.681); frames 1 and 2 show the same line; legacy Example 11 uses [−1.45, 1.45] | confirmed |
| 29 | Case 15 | eˣ on [−2, 3], f on the same interval | Script; legacy Example 12 code: a = −2, b = 3 | confirmed |
| 30 | Case 16 | e⁻ˣ cos x on [−2, 4] | Script; legacy index | confirmed |
| 31 | Case 17 | cosh x on [−4, 4] | Script; legacy index | confirmed |
| 32 | Case 18 | arctan, nodes [−2, 2], f on [−2.2, 2.2]; degrees 1 and 2 same line | Script; mpmath a₂ = 0; frames; legacy Example 13 uses [−2, 2] | confirmed |
| 33 | Case 19 | arcsin, nodes [−1, 1], window [−1.5, 1.5], f drawn on [−1, 1]; degrees 1 and 2 same line | Script; asin(\|x\| > 1) gives NaN; mpmath a₂ = 0; frames | confirmed |
| 34 | Case 20 | J₀, nodes [−10, 10], f on [−10.2, 10.2] | Script; legacy Example 15 uses [−10, 10] | confirmed |
| 35 | Case 21 | J₁, nodes [−10.2, 10.2]; degrees 1 and 2 same line | `auto_span` gives the full window; mpmath a₂ = 0 (a₁ = −6.5e-4); frames | confirmed |
| 36 | Case 22 | standard normal density on [−3, 3] | Script; legacy index and Example 16 | confirmed |
| 37 | Case 23 | ½(1+erf(x/√2)) on [−3, 3]; middle node (0, ½) on the chord; degrees 1 and 2 same line | mpmath a₂ = 0; frames | confirmed |
| 38 | Cases 24–26 | Γ on [0.05, 2], [0.05, 4], [0.5, 5]; f on [−0.2, 5.2] | Script; legacy index; pole at 0 rendered as a break (§1) | confirmed |
| 39 | Cases 27–29 | Y₀ on [0.5, 20], [0.5, 10], [0.5, 4]; f on [0, 22] | Script; legacy index. Y₀(0) = −∞ is NaN at the single point x = 0 | confirmed |
| 40 | Divided-differences heading | cos x, nodes x_k = k/5 on [0, 1]; Mathews' Example 1 | Legacy lnk_2…6 and gr_191: `XY = Table[{k/5, f[k/5]}, {k,0,5}]`, f = Cos | confirmed |
| 41 | Behaviour | Each frame adds node n/5 and one Newton term; earlier coefficients unchanged | Script recomputes the table each frame; leading entries are invariant by construction; frame titles show successive a_n | confirmed |
| 42 | Behaviour | a₀…a₅ = 1, −0.0996671, −0.488402, 0.0490076, 0.0381225, −0.00396205 | mpmath: 1.0, −0.0996671, −0.488402, 0.0490076, 0.0381225, −0.00396205 | confirmed |
| 43 | Behaviour and alt | Max error on [x₀, xₙ]: 4.97e-3 (deg 1), 1.16e-4 (deg 2), 1.35e-6 (deg 5) | mpmath (20001 samples): 4.971e-3, 1.165e-4, 1.350e-6. Frame titles agree | confirmed |
| 44 | Behaviour | So there the curves coincide in the frames | At most 0.005 on a 1.7-unit, ~420 px axis, about 1 px; frames show them coincident | confirmed |
| 45 | Behaviour | Frames drawn on [−0.5, 2.1], as in Mathews' graphs | Script xlims; Mathews' PlotRange x ∈ {−0.5, 2.1} (gr_206). Mathews' y-range [−0.5, 1.05] differs from the script's [−0.6, 1.1], but the page claims only the x-range | confirmed |
| 46 | Behaviour and alt | Error at x = 2.1: 1.30, 0.65, 0.32, 0.067, 0.015 | mpmath: 1.296, −0.6532, −0.3208, 0.06712, 0.01471 | confirmed |
| 47 | Behaviour | Degree-2 and degree-3 polynomials leave the bottom of the plot near x = 1.81 and 1.95 | mpmath P₂ = −0.6 at 1.8079, P₃ = −0.6 at 1.9488 (ylim −0.6); P₁, P₄, P₅ stay within [−0.6, 1.1] (min 0.79, −0.44, −0.49; max 1.05) | confirmed |
| 48 | Alt (newtpolyaa) | Degree 1 (2 nodes) to 5 (6 nodes), [x₀, xₙ] shaded, dashed polynomial through every node | 5 frames; `vspan!`; dashed red; nodes on the curve | confirmed |

### 3. Implementation checks

### `lagnewt_animations_all.jl` (shared with the Lagrange page; identical there)

- **Is it the method it claims to be?** It is polynomial interpolation on equally spaced nodes, evaluated in the first (modified-Lagrange) barycentric form. The page names this form at l.26. The comment at l.131–133 about the second form losing accuracy far outside the nodes is correct: the second form's denominator Σ w_j/(x−x_j) cancels to O(x⁻ⁿ) in extrapolation.
- **Are the numbers right?** I instrumented a copy (`review/lagnewt_defs.jl` plus `review/dump.jl`, run with `julia dump.jl`) that writes every interpolant value the frames draw: 29 cases × 10 degrees × 1000 x-points, in `review/dump.tsv`. Separately, `review/indep.py` (mpmath, 60 digits) builds the Newton divided-difference form on independently constructed nodes and evaluates it at the same x. For each (case, degree) I took the largest discrepancy over points inside the script's ±1-span display band, divided by the y-span. The worst value is **5.6e-9** (Case 29, degree 15); all others are ≤ 3e-10, and most are around 1e-15. The table is in the run output. Every node lies at the interval ends as stated (`caseinfo.txt`: no trimming anywhere).
- **Reference values.** f is evaluated directly (Base and SpecialFunctions), and the mpmath functions agree. Pole handling: the lower y-limits for Cases 01 and 02 are −1.646, so the claim that f beyond the pole is below the window holds.
- **Does the picture show what was computed?** I viewed all 29 contact sheets. Titles carry the right case id, function label and degree. Nodes sit on f, and the interpolant passes through them. Clamping is one y-span beyond the axes, so curves leave the frame rather than running along its edge. Pole breaks are correct for Cases 01–03 and 14. Γ breaks at 0 through an exact grid hit (§1). Case 28's vertical line at x ≈ 18.18 is a genuine zero crossing (§1).

### `newtpolyaa.jl`

- **Method:** a genuine Newton divided-difference table, built in place, with the top diagonal pushed as coefficients. Evaluation is Horner nested Newton form. This is the method named.
- **Numbers:** the script's a₁…a₅ (frame titles) and mine agree to all 6 printed digits. Max errors from the titles against mine: 4.97e-3 / 4.971e-3, 1.16e-4 / 1.165e-4, 6.42e-5 / 6.425e-5, 4.23e-6 / 4.231e-6, 1.35e-6 / 1.350e-6.
- **Reference:** cos is exact. The title's "on [0, n/5]" interval matches the shading.
- **Picture:** I checked frames 1, 2 and 5 at full size. The dashed P_n passes through the black nodes, the shaded band is [0, n/5], P₂ exits the bottom near 1.81, and the legend does not hide anything relevant.

### Shared-script drift

`diff pages/numerical-methods/newton-interpolation-polynomial/lagnewt_animations_all.jl pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/lagnewt_animations_all.jl` printed nothing: **identical, no drift**.

### Fidelity to the archive

- All 29 functions and windows match Mathews' animation index in the same order.
- Node intervals match wherever the archive gives one: the index for 04–06, 08–11 and 24–29; the static examples linked to animations 7, 8, 9/10, 12 (a = −3π, b = 3π), 14, 15 (a = −2, b = 3), 18, 19, 20 and 22; the surviving animation for 01.
- For 12, 13 and 15 the static examples' auxiliary `a0, b0` (±10, ±5) are only the positions of green marker lines, not the node interval.
- The divided-difference case reproduces Example 1.
- The departures from Mathews' animations (degree 15 instead of 20 or 25, no tolerance bar) are stated on the page. No undisclosed departure.

