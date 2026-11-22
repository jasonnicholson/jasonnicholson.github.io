# False Position or Regula Falsi Method — animation review (round 5)

Page: `pages/numerical-methods/false-position-or-regula-falsi-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**No findings.** Every checkable claim on the page and in the script headers agrees with my independent computation and with the frames. I found no errors in the implementation, the reference values or the drawing.

One observation that I am **not** counting as a finding: in `regulafalsibb.gif`, frames 6 to 11 (c_5 to c_10) look the same apart from the subscript. Every legend reads `c_k = 0.739085`, because the error is already below 5e-7 by c_5 (the error ratio is about 0.05). The labels are correct to the six decimals shown, and every frame is distinct (no duplicate frame hashes). It is a teaching-design choice and does not misstate anything.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `regulafalsiaa.jl` | 0 | 10.0 | regulafalsiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `regulafalsibb.jl` | 0 | 7.5 | regulafalsibb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `regulafalsiaa.gif` | 13 | byte-identical | regulafalsiaa |
| `regulafalsibb.gif` | 11 | byte-identical | regulafalsibb |

### Page references

- Scripts linked: `regulafalsiaa.jl`, `regulafalsibb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Source abbreviations: P = `index.qmd`, A = `regulafalsiaa.jl`, B = `regulafalsibb.jl`.

| # | Where | Claim (in the page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | P intro l.13 | "a secant line is drawn through the two bracket endpoints (a, f(a)) and (b, f(b)); its x-intercept c becomes the new estimate" | Code A l.32 / B l.29: `c = (a f(b) - b f(a))/(f(b)-f(a))`, the x-intercept of the chord. It matches my independent form to 1e-15. | confirmed |
| 2 | P intro | "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket" | Code uses `as[frame], bs[frame]` (previous bracket) for the secant. In A frame_002 the dashed line passes through (-1,-7), (2,14) and (0,0). In B frame_002 it passes through (0,-1) and (1,0.4597). | confirmed |
| 3 | P intro | "the shaded band shows the updated bracket, which has the new point c (red) as one endpoint" | Shading uses `as[frame+1], bs[frame+1]`. The instrumented run gives a_{k+1} = c_k in every step of both cases. In the frames, the band's left edge is at the red point. | confirmed |
| 4 | P intro | "Regula Falsi weights the new point toward whichever endpoint has a smaller \|f\| value" | c = (a\|f(b)\| + b\|f(a)\|)/(\|f(a)\|+\|f(b)\|) when the signs differ, so c lies nearer the endpoint with the smaller \|f\|. Case A step 1: \|f(-1)\|=7 < \|f(2)\|=14, and c=0 is nearer -1 than the midpoint 0.5 is. | confirmed |
| 5 | P intro | "often giving faster convergence — but one endpoint can remain fixed for many iterations" | Asymptotic error ratios are 0.2513 (A) and 0.0501 (B), against 0.5 for bisection. b stays fixed in all iterations of both cases. | confirmed |
| 6 | P intro | "Julia source scripts ... are linked under each case" | Links at l.21 and l.29 exist and point to the matching scripts | confirmed |
| 7 | P Case A heading | f(x) = x^3 + 4x^2 - 10, [a,b] = [-1, 2] | A l.15–16 | confirmed |
| 8 | P Case A heading | "Convergent" | 12 iterates converge monotonically. c_12 = 1.36522935, error 6.6e-7. | confirmed |
| 9 | P Case A | "converges to the real root x* ≈ 1.3652" | mp.findroot gives 1.36523001341410, f = 0 | confirmed |
| 10 | P Case A | "The right endpoint b = 2 stays fixed throughout" | Instrumented run: b = 2.0 for all 12 steps (and in 15 steps of the mpmath run) | confirmed |
| 11 | P Case A | "f(-1) < 0" | f(-1) = -7 | confirmed |
| 12 | P Case A | "every false-position point c also satisfies f(c) < 0" | f(c_k) runs from -10 up to -1.0955e-5, all negative | confirmed |
| 13 | P Case A | "(f is convex on the bracket)" | f'' = 6x+8 ≥ 2 > 0 on [-1,2] | confirmed |
| 14 | P Case A | "a = -1, 0, 0.8333, 1.2088, …" | The run gives a = -1, 0.0, 0.833333, 1.208791, … | confirmed |
| 15 | P Case A | "'one-sided' stagnation is characteristic of Regula Falsi" | A general statement. The fixed endpoint is confirmed here. | confirmed |
| 16 | P Case A alt | "secant line from bracket endpoints walks toward the root near x=1.37, with the right endpoint fixed and successive false-position points converging from the left" | Frames 2–13: c increases monotonically to 1.3652 (≈1.37) and b = 2 is fixed | confirmed |
| 17 | P l.21/23 wiring | Case A links `regulafalsiaa.jl` and embeds `regulafalsiaa.gif` | The manifest shows the regenerated GIF is byte-identical to the committed one. Its title and legend show x^3+4x^2-10. | confirmed |
| 18 | P Case B heading | f(x) = x - cos(x), [a,b] = [0,1] | B l.12–13 | confirmed |
| 19 | P Case B heading | "Convergent (one-sided)" | b = 1 is fixed and c increases monotonically to the root | confirmed |
| 20 | P Case B | "the 'Dottie number' x* ≈ 0.7391, the unique fixed point of cosine" | Root 0.739085133215161. cos x - x is strictly decreasing, so the real fixed point is unique. | confirmed |
| 21 | P Case B | "b = 1 (where f(1) ≈ 0.4597) remains fixed throughout" | f(1) = 0.45969769; b = 1.0 in all 10 steps | confirmed |
| 22 | P Case B | "f is convex on [0, 1]" | f'' = cos x > 0 on [0,1] | confirmed |
| 23 | P Case B | "every false-position point satisfies f(c) < 0" | f(c_k) runs from -0.0893 to -1.85e-13, all negative | confirmed |
| 24 | P Case B | "c = 0.6851, 0.7363, 0.7389, …" | 0.685073, 0.736299, 0.738945 | confirmed |
| 25 | P Case B | "the bracket shrinks only on the left side, yet the secant intercept homes in on the root accurately" | The bracket width tends to 1 - x* ≈ 0.261, not 0. c_10 has error 1.1e-13. | confirmed |
| 26 | P Case B alt | "converges to the Dottie number x*≈0.739, with the right endpoint fixed at 1 while the left endpoint steps in" | Frames 2–11 | confirmed |
| 27 | P l.29/31 wiring | Case B links `regulafalsibb.jl` and embeds `regulafalsibb.gif` | Byte-identical regeneration. Its title shows x − cos(x). | confirmed |
| 28 | A header l.3 | "Matches the legacy Mathews module example." | Mathews Example 3 uses the same f and the same [-1,2]. Mathews runs 15 iterations and the script runs 12, which does not matter. | confirmed |
| 29 | A header l.5–7 | "error ratio … settles at about 0.251 (bisection … 0.5)" | Computed ratios 0.3896, 0.2941, 0.2628, … → 0.25127. The theoretical value 1 - f'(x*)(2-x*)/f(2) = 0.251271. | confirmed |
| 30 | A header l.8 | "True root ≈ 1.36523" | 1.3652300134 | confirmed |
| 31 | B header l.3–5 | "right endpoint stays fixed at 1", "c points converge from the left", "x* ≈ 0.7391" | See 21, 24 and 20 | confirmed |
| 32 | GIF legends | `c_k = round(c_k, 6)` with the right index | A: c_1 = 0.0, c_3 = 1.208791, c_12 = 1.365229 (computed 1.36522935). B: c_1 = 0.685073, c_10 = 0.739085. These match the instrumented values for the frame's index. | confirmed |
| 33 | GIF frame 1 | "Initial bracket [-1.0, 2.0]" / "[0.0, 1.0]" | Matches a0 and b0 | confirmed |

The page has no Description section with formulas other than the intro paragraph (ledger items 1–5), so there is no separate method-description check.

Fidelity: Case A is Mathews' Example 3 and the archive's only animation case, and the page keeps it with the same function and interval. Case B is an addition that the archive does not have. The page does not attribute Case B to Mathews, so it is not a fidelity issue. No archive case is dropped. (Examples 1–2 in the archive use the same cubic for program demonstrations, not for animations.)

---

### 3. Implementation checks

### `regulafalsiaa.jl`

- **Method:** it is classic Regula Falsi. The new point is the chord x-intercept and the bracket is updated by a sign test (`f(a)f(c) < 0`, then b ← c, else a ← c). It has no Illinois or Pegasus modification and no bisection fallback, so it is the plain false-position method the page names.
- **Numbers:** the script's values (from `review/regulafalsiaa_instr.jl`) and my independent mpmath values (from `review/indep.py`, using the other algebraic form of the update):

  | k | script c_k | independent c_k | f(c_k) |
  |---|---|---|---|
  | 1 | 0.0 | 0.0 | -10 |
  | 2 | 0.8333333333333334 | 0.833333333333 | -6.6435 |
  | 3 | 1.2087912087912087 | 1.20879120879 | -2.3890 |
  | 4 | 1.32412611057995 | 1.32412611058 | -0.66516 |
  | 6 | 1.362596802578731 | 1.36259680258 | -0.043427 |
  | 9 | 1.3651881982101728 | 1.36518819821 | -6.905e-4 |
  | 12 | 1.36522935002777 | 1.36522935003 | -1.0955e-5 |

  They agree to every printed digit. The error ratios converge to 0.25127, which matches the theoretical linear rate 1 - f'(x*)(b - x*)/f(b) = 0.251271 for a fixed b.
- **Reference values:** the script draws no reference curve, and the "True root ≈ 1.36523" in the comment is confirmed (1.36523001341).
- **Picture:** I looked at frames 1, 2, 4 and 13 and the contact sheet. The secant uses the previous bracket and passes through the right points. Frame 2 shows the chord from (-1,-7) to (2,14) crossing the axis at 0. The shaded band is [c_k, 2]. The red diamond is at (c_k, 0) and the red dot at (c_k, f(c_k)) on the curve. Earlier intercepts are grey diamonds. The title and legend name the function in the code. The axis limits (-1.5..2.5, -14..16) contain f(-1) = -7, f(2) = 14, the minimum f(0) = -10 and the root, and nothing is clamped. There are 13 frames (the initial frame plus 12 iterations), and the GIF is byte-identical on regeneration.

### `regulafalsibb.jl`

- **Method:** the same plain Regula Falsi as in `regulafalsiaa.jl`.
- **Numbers:**

  | k | script c_k | independent c_k | f(c_k) |
  |---|---|---|---|
  | 1 | 0.6850733573260451 | 0.685073357326 | -0.089299 |
  | 2 | 0.736298997613654 | 0.736298997614 | -0.0046600 |
  | 3 | 0.7389453559657132 | 0.738945355966 | -2.339e-4 |
  | 5 | 0.7390847824489231 | 0.739084782449 | -5.870e-7 |
  | 10 | 0.73908513321505 | 0.739085133215 | -1.852e-13 |

  They agree. The error ratios settle at 0.050093, and the theoretical value 1 - (1 + sin x*)(1 - x*)/f(1) = 0.0500926. In Float64, f(c) is still well above rounding level at k = 10 (1.85e-13), so the sign test is reliable for all 10 steps.
- **Reference values:** the Dottie number 0.7391 is confirmed (0.739085133215161).
- **Picture:** I looked at frames 2 and 11 and the contact sheet. The secant in frame 2 goes from (0,-1) to (1,0.4597). The band is [c_k, 1], the markers are correct, and the bottom-right legend does not hide the curve, the root or the bracket. The axis limits (-0.2..1.3, -1.2..0.5) contain f(0) = -1 and f(1) = 0.4597. There are 11 frames, and the GIF is byte-identical on regeneration. All frames are distinct, though frames 6–11 differ visually only in the legend subscript (see the observation in section 1).

