# Bisection Method — animation review (round 3)

Page: `pages/numerical-methods/bisection-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor finding. Every claim in the ledger below was checked against values I computed myself, and both scripts reproduce the independent computation exactly.

The following are noted for completeness but are **not findings**:
- Mathews ran his examples longer: `Bisection[a, b, 30]` for Example 3 and `Bisection[a, b, 15]` for Example 4, and his 2001 animations show about 20 and 18 iterations. The page stops after 12 steps in both cases. Its claims are all stated for 12 steps and are true for 12 steps, so this does not mislead.
- Mathews Examples 1–2 (all real roots of a cubic; `Bisection[0,1,30]`) are worked solutions, not animation cases. The page's two cases are exactly Mathews' two animation examples (3 and 4).
- Legend labels round with Julia's half-even `round(x; digits=6)`. For example, `c_8 = 1.5703125` is shown as `1.570312`. This is ordinary rounding of the last digit.
- In the top panel of Case 2, midpoint markers whose |tan c| > 15 are drawn at the clamped value ±15. The legend labels these midpoints by their x-value only, not by f(c), and the zoom panel below draws f(c) at its true value (for example +2.07e3 at step 8 and −2.24e5 at step 12, matching the computation). The clamping keeps the plot readable and does not change what a viewer would conclude.
- The page has no Description section, so there are no method formulas to check against the code.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `bisectionaa.jl` | 0 | 9.1 | bisectionaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `bisectionbb.jl` | 0 | 10.7 | bisectionbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `bisectionaa.gif` | 13 | byte-identical | bisectionaa |
| `bisectionbb.gif` | 13 | byte-identical | bisectionbb |

### Page references

- Scripts linked: `bisectionaa.jl`, `bisectionbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (own words) | Check | Verdict |
|---|---|---|---|
| 1 | "The shaded region marks the current bracket [a, b]" | Code shades `as[frame+1]..bs[frame+1]` (the bracket after the step) in both panels; frames show this | confirmed |
| 2 | "when f is continuous on [a, b] and f(a), f(b) have opposite signs, the IVT guarantees that it contains a root" | Standard theorem; correctly stated | confirmed |
| 3 | "Each frame computes the midpoint c = (a+b)/2, evaluates f(c), and narrows the bracket to the half that still contains the sign change" | Code lines 30–40: `c=(a+b)/2`; `f(a)f(c)<0 → [a,c]` else `[c,b]`. Frames 1–12 each show one step; frame 0 shows the initial bracket | confirmed |
| 4 | "The bottom panel zooms in on the bracket from before the current step" | `a_prev = as[max(frame,1)]` = the bracket before step `frame`, padded by 10 %. Zoom titles read "step k halves [a, b] of width w_prev", with w_prev = 3.0, 1.5, …, 0.00146484375 (aa) and 2.0, …, 0.0009765625 (bb), equal to my widths | confirmed |
| 5 | "…after the bracket becomes narrower than a pixel in the full view (from step 9 on)" | Measured the top-panel plot area in `frame_001.png`: its box border columns are at x = 115 and 588, so 473 px. aa: 3.4/473 = 0.00719 per px; width after step 8 = 0.01172 (1.63 px), after step 9 = 0.00586 (0.81 px). bb: 2.4/473 = 0.00507 per px; after step 8 = 0.0078 (1.54 px), after step 9 = 0.0039 (0.77 px) | confirmed |
| 6 | "Julia source scripts … are linked under each case" | Case 1 → `bisectionaa.jl`, Case 2 → `bisectionbb.jl`; both exist and match their headings | confirmed |
| 7 | Case 1 heading: f(x) = x³ + 4x² − 10, [a₀, b₀] = [−1, 2] | Script lines 15–16 | confirmed |
| 8 | Case 1 "Convergent" | Final bracket [1.364990234375, 1.36572265625] contains x* = 1.3652300134 | confirmed |
| 9 | f(−1) = −7 < 0, f(2) = 14 > 0 | Exact: −7, 14 | confirmed |
| 10 | "the IVT guarantees a root in [−1, 2]" | Polynomial is continuous and the signs are opposite | confirmed |
| 11 | "True root x* ≈ 1.3652" | sympy `real_roots`: one real root, 1.3652300134140968 | confirmed |
| 12 | "The bracket width halves each step" | Widths 3·2⁻ᵏ exactly (dyadic, exact in floating point) | confirmed |
| 13 | "error bound \|c_k − x*\| ≤ (b₀ − a₀)/2^k shrinks monotonically" | Bound is valid for c₁ = first midpoint. Errors k = 1..12: 8.65e-1, 1.15e-1, 2.60e-1, 7.23e-2, 2.15e-2, 2.54e-2, 1.96e-3, 9.76e-3, 3.90e-3, 9.72e-4, 4.93e-4, 2.40e-4. Each is ≤ 3/2^k (1.5 … 7.32e-4) | confirmed |
| 14 | "the midpoints themselves are not monotone and fall on both sides of the root" | Side of x* per step: − − + + − + + − − − + −. Midpoints 0.5, 1.25, 1.625, 1.4375, … are not monotone | confirmed |
| 15 | Alt text Case 1: "bracket narrows around the root at x≈1.3652 over 12 steps, with a lower panel zoomed on each halving" | `n_iters = 12`, 13 frames; final bracket contains 1.36523; zoom panel present in every frame | confirmed |
| 16 | Case 2 heading: f(x) = tan(x), [a₀, b₀] = [0, 2], "Spurious convergence (cautionary)" | Script lines 18–19 | confirmed |
| 17 | f(0) = tan(0) = 0, a genuine root at the left end | Exact | confirmed |
| 18 | "The first midpoint is c₁ = 1" | Script prints c=1.0 | confirmed |
| 19 | "since f(0) f(1) = 0 is not negative, bisection keeps [1, 2] and walks away from that root" | Code `else` branch → [1.0, 2.0] (printed). Frame 2 shows the bracket [1, 2] | confirmed |
| 20 | f(1) = tan 1 > 0, f(2) = tan 2 < 0 | 1.5574, −2.1850 | confirmed |
| 21 | Sign change caused by the asymptote at π/2 ≈ 1.5708; tan has no zero in [1, 2] | π/2 = 1.5707963; the zeros of tan are kπ, and 0 < 1 < 2 < π | confirmed |
| 22 | "Bisection converges to the asymptote" | Brackets shrink onto π/2: final [1.5703125, 1.57080078125] contains 1.5707963; \|c₁₂ − π/2\| = 4.45e-6; \|tan c₁₂\| = 2.24e5 (it grows instead of tending to 0) | confirmed |
| 23 | "illustrating that the IVT guarantee requires f to be continuous on [a, b]" | Correct reading of the example | confirmed |
| 24 | Alt text Case 2: "the first step leaves the root at x=0, then the method converges to the asymptote at π/2, not a root… with a lower panel zoomed on each halving" | As in rows 19 and 22; frames 2 and 13 viewed | confirmed |
| 25 | Embeds: `bisectionaa.gif` under Case 1, `bisectionbb.gif` under Case 2 | Titles in the frames: "f(x) = x³ + 4x² − 10" and "f(x) = tan(x) [cautionary case]" | confirmed |
| 26 | Fidelity: Case 1 = Mathews Example 3 (x³+4x²−10, [−1, 2]); Case 2 = Mathews Example 4 (Tan[x], [0, 2]) | Archive images `gr_647/648/649`, `gr_813/814/815` and the 2001 animations show the same functions, intervals and midpoint sequence (Mathews indexes from p₀, so his p₁ = 1.25 is the page's c₂) | confirmed |

### 3. Implementation checks

### `bisectionaa.jl`
- **Method:** plain bisection. The midpoint is `(a+b)/2` and the bracket is updated by the sign of `f(a)f(c)`. There is no safeguard or hybrid step. When f(c) = 0 exactly the code goes to [c, b], the standard convention; this case does not occur here.
- **Numbers:** the instrumented copy (`review/inst_aa.jl`) agrees exactly with the independent exact-rational computation (`review/indep.py`) for all 12 steps. Script vs independent:
  - c₁…c₁₂ = 0.5, 1.25, 1.625, 1.4375, 1.34375, 1.390625, 1.3671875, 1.35546875, 1.361328125, 1.3642578125, 1.36572265625, 1.364990234375, identical in both.
  - f(c) also agrees, for example f(c₁₂) = −0.0039591 in both.
  - The brackets after each step are identical in both.
- **Reference:** x* ≈ 1.3652 in the header, page and alt text; sympy gives 1.36523001341. The script draws no separate "true root" marker.
- **Picture:** I viewed frames 1, 2 and 13 and the contact sheet (frames 1, 3, 5, 7, 9, 11, 13).
  - The red dot sits at (c_k, f(c_k)), with a dotted drop line to a diamond at (c_k, 0).
  - Gray dots mark the earlier midpoints.
  - The blue dashed lines and shading mark the bracket after the step. In the zoom panel, gray dashed lines mark the bracket before the step.
  - The legend labels `c_k` use the right index and value.
  - The title function matches the code.
  - Axis limits (−1.2..2.2, −12..16) keep the root and both bracket ends visible. The curve leaves the top of the plot only for x > ~2.06, outside the bracket.

### `bisectionbb.jl`
- **Method:** the same plain bisection loop as `bisectionaa.jl`.
- **Numbers:** the instrumented copy (`review/inst_bb.jl`) agrees with the independent bisection, which uses exact dyadic midpoints and mpmath tan at 50 digits. Script vs independent:
  - c₁…c₁₂ = 1, 1.5, 1.75, 1.625, 1.5625, 1.59375, 1.578125, 1.5703125, 1.57421875, 1.572265625, 1.5712890625, 1.57080078125, identical in both.
  - The signs of tan(c) are identical in both. Values agree to ~10 significant digits, for example tan(c₁₂) = −224494.3493 in the script against −224494 independently.
  - The brackets are identical in both.
  - Step 1 takes the `else` branch because f(0)f(1) = 0.
- **Reference:** the asymptote line is drawn at `π/2` (Julia `π`), which is exact to double precision. The script shows no root reference, which is correct because none exists in [1, 2].
- **Picture:** I viewed frames 2, 6 and 13 and the contact sheet.
  - The curve is split at π/2 with gap 0.02 in the full view and 0.002·w_prev in the zoom, so no false vertical connector is drawn.
  - In the full view, y is clamped to ±15 (see the note under Findings). In the zoom, the y-range is ±1.1·max|f| at the window ends and the midpoint, so the midpoint appears at its true value. Frame 6 (step 5): +1.205e2. Frame 13 (step 12): −2.24e5.
  - The orange asymptote line lies inside the final bracket.
  - Labels and title are correct.

### Could not determine
Nothing material. I did not inspect pixel by pixel every one of the 26 frames, but I viewed the first frame, several middle frames and the last frame of each GIF. The drawing code is the same for every frame, and the values it draws were verified for all 12 steps.

