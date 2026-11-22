# False Position or Regula Falsi Method — animation review (round 4)

Page: `pages/numerical-methods/false-position-or-regula-falsi-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no Error, Misleading or Minor issue.

One observation that I do not count as a finding: in Case B, frames 6 to 11 (c_5 to c_10) look the same apart from the subscript. The legend shows `0.739085` in every one of them because the iterates agree to 6 decimals from c_5 on (true errors are 3.5e-7 down to 1.1e-13). This is correct, and the page makes no claim it contradicts.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `regulafalsiaa.jl` | 0 | 7.4 | regulafalsiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `regulafalsibb.jl` | 0 | 6.9 | regulafalsibb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Source | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | "a secant line is drawn through the two bracket endpoints (a, f(a)) and (b, f(b)); its x-intercept c becomes the new estimate" | Both scripts, line 32 / 29: `c = (a f(b) − b f(a)) / (f(b) − f(a))`, which is the x-intercept of that chord. The frames show the red diamond on the dashed line at y = 0. | confirmed |
| 2 | Intro | "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket" | aa.jl l.86–91, bb.jl l.83–87 use `as[frame], bs[frame]` (previous bracket). In frame 2 of aa the line passes through (−1, −7) and (2, 14). In frame 3 it passes through (0, −10) and (2, 14). | confirmed |
| 3 | Intro | "the shaded band shows the updated bracket, which has the new point c (red) as one endpoint" | The band uses `as[frame+1], bs[frame+1]`. In every frame its left edge is at the red c (aa frames 2 and 3, bb frame 2 inspected). | confirmed |
| 4 | Intro | "Regula Falsi weights the new point toward whichever endpoint has a smaller \|f\| value" | c = (\|f(b)\|·a + \|f(a)\|·b)/(\|f(a)\|+\|f(b)\|) when the signs are opposite, so the endpoint with the smaller \|f\| gets the larger weight. | confirmed |
| 5 | Intro | "one endpoint can remain fixed for many iterations" | b is fixed in both cases for every iteration (see 9 and 15). | confirmed |
| 6 | Intro | Julia scripts are linked under each case | Links `regulafalsiaa.jl` and `regulafalsibb.jl` are present. | confirmed |
| 7 | Case A heading | f(x) = x³ + 4x² − 10, [a,b] = [−1, 2], "Convergent" | aa.jl l.15–16 use the same function and interval. The iterates converge (#8). The plot title is "x³ + 4x² − 10". | confirmed |
| 8 | Case A | "converges to the real root x* ≈ 1.3652" | mpmath root 1.36523001341409685. Script c_12 = 1.36522935002777 (error 6.6e-7). It is the only real root: f has a local max at x=−8/3 with f = −0.52 < 0. | confirmed |
| 9 | Case A | "The right endpoint b = 2 stays fixed throughout" | Instrumented: b = 2.0 for all 12 iterations; final bracket [1.36522935, 2]. | confirmed |
| 10 | Case A | "f(−1) < 0 and every false-position point c also satisfies f(c) < 0" | f(−1) = −7. f(c_k) runs from −10, −6.64, −2.389, … to −1.0955e-5, all negative (instrumented script and mpmath agree). | confirmed |
| 11 | Case A | "(f is convex on the bracket)" | f'' = 6x + 8. Its minimum on [−1, 2] is 2 > 0 (indep.py). | confirmed |
| 12 | Case A | "a = −1, 0, 0.8333, 1.2088, …" | a_1..a_4 = −1, 0, 0.833333, 1.208791 (script and mpmath). | confirmed |
| 13 | Case A alt | "secant line … walks toward the root near x=1.37, with the right endpoint fixed and successive false-position points converging from the left" | Root 1.3652 is about 1.37. All c_k < x* and increasing. b fixed. Frames agree. | confirmed |
| 14 | Case B heading | f(x) = x − cos x, [a,b] = [0, 1], "Convergent (one-sided)" | bb.jl l.12–13 use the same function and interval. Title is "x − cos(x)". | confirmed |
| 15 | Case B | "converges to the 'Dottie number' x* ≈ 0.7391, the unique fixed point of cosine" | mpmath root 0.739085133215161. Script c_10 = 0.73908513321505 (error 1.1e-13). x − cos x is strictly increasing (derivative 1 + sin x ≥ 0, zero only at isolated points), so the root is unique. | confirmed |
| 16 | Case B | "b = 1 (where f(1) ≈ 0.4597) remains fixed throughout" | f(1) = 0.4596976941. b = 1.0 for all 10 iterations. | confirmed |
| 17 | Case B | "f is convex on [0, 1] and every false-position point satisfies f(c) < 0" | f'' = cos x ≥ 0.5403 on [0,1]. f(c_k) runs from −0.0893 to −1.85e-13, all negative. | confirmed |
| 18 | Case B | "c = 0.6851, 0.7363, 0.7389, …" | c_1..c_3 = 0.685073357, 0.736298998, 0.738945356. | confirmed |
| 19 | Case B | "the bracket shrinks only on the left side, yet the secant intercept homes in on the root accurately" | Only a moves. \|c_k − x*\| shrinks by about 0.0501 per step down to 1.1e-13. | confirmed |
| 20 | Case B alt | "converges to the Dottie number x*≈0.739, with the right endpoint fixed at 1 while the left endpoint steps in" | As in 15–18. | confirmed |
| 21 | Wiring | Case A links `regulafalsiaa.jl` and embeds `regulafalsiaa.gif`. Case B links and embeds the bb pair. | index.qmd. The GIFs are byte-identical to fresh runs of those scripts. | confirmed |
| 22 | aa.jl header | "Matches the legacy Mathews module example" | Archive Example 3 (`RegulaFalsiMod_gr_432/433/434.gif`) uses x³ + 4x² − 10 = 0 on [a,b] = [−1, 2]. | confirmed |
| 23 | aa.jl header | "convergence is only linear … error ratio … settles at about 0.251" | Measured ratios are 0.3896, 0.2941, 0.2627, …, 0.251271. Theoretical 1 − f'(x*)(b − x*)/f(b) = 0.25127071. | confirmed |
| 24 | aa.jl header | "True root ≈ 1.36523" | 1.3652300134 | confirmed |
| 25 | bb.jl header | "right endpoint stays fixed at 1", "c points converge from the left", "Root ≈ 0.7391" | As in 15–18. | confirmed |
| 26 | Frames | Legend labels `c_k = round(c_k, 6)` | They match the instrumented values for every k in both cases (for example aa: c_2 = 0.833333, c_4 = 1.324126, c_6 = 1.362597, c_8 = 1.365064, c_10 = 1.36522, c_12 = 1.365229; bb: c_1 = 0.685073, c_2 = 0.736299, c_3 = 0.738945, c_4 = 0.739078, c_5..c_10 = 0.739085). | confirmed |

The page has no separate Description section beyond the intro, so there are no further method-description claims.

### 3. Implementation checks

### `regulafalsiaa.jl`
- **Method.** This is classical regula falsi (false position) with no Illinois or Pegasus modification: c is the chord's x-intercept, and the sign test `f(a)f(c) < 0` keeps the bracket. It is the method the page names and the one the page describes.
- **Numbers.** The instrumented copy and the independent mpmath implementation agree to all printed digits for all 12 iterates. Examples (script / mpmath):
  - c_1 = 0.0 / 0.0
  - c_2 = 0.8333333333333334 / 0.833333333333
  - c_3 = 1.2087912087912087 / 1.20879120879
  - c_6 = 1.362596802578731 / 1.36259680258
  - c_12 = 1.36522935002777 / 1.36522935003

  The rate check: the error ratio tends to 0.251271, which equals the theoretical linear constant 1 − f'(x*)(b − x*)/f(b) = 0.2512707 for a fixed endpoint b = 2.
- **Reference values.** The comment's root 1.36523 is right (findroot gives 1.3652300134140968, with residual near zero at 40 digits). No reference curve is drawn.
- **Picture.** I inspected the contact sheet and frames 2 and 3 at full size.
  - The curve is the stated f.
  - The secant passes through the previous bracket endpoints (verified on frames 2 and 3).
  - The red diamond sits at c on the axis, with a dotted line down to (c, f(c)).
  - The band and blue markers show the new bracket, and earlier c values appear as grey diamonds.
  - Axes are [−1.5, 2.5] × [−14, 16]. The curve leaves the top of the plot only for x > about 2.07, past b = 2, so it does not matter. The root, the bracket and both endpoints are always visible.
  - There are 13 frames (initial plus 12 iterations).

### `regulafalsibb.jl`
- **Method.** This is the same classical regula falsi as aa.
- **Numbers.** The script and mpmath agree for all 10 iterates. Examples (script / mpmath):
  - c_1 = 0.6850733573260451 / 0.685073357326
  - c_2 = 0.736298997613654 / 0.736298997614
  - c_4 = 0.7390781308800257 / 0.73907813088
  - c_10 = 0.73908513321505 / 0.739085133215

  The error ratio tends to 0.0500926, which equals the theoretical 1 − f'(x*)(1 − x*)/f(1) = 0.05009256.
- **Reference values.** The Dottie number is 0.7390851332151606 (findroot), so the stated 0.7391 is right.
- **Picture.** I inspected the contact sheet of all 11 frames.
  - The title and curve show x − cos x.
  - The secant passes through the previous endpoints: frame 2's line goes through (0, −1) and (1, 0.4597).
  - The band's left edge is at c, and b = 1 is marked throughout.
  - Axes are [−0.2, 1.3] × [−1.2, 0.5]. f(1) = 0.4597 is inside the window, and the curve leaves the top only for x > about 1.03, past b.
  - Frames 6 to 11 are visually the same because the iterates agree to 6 decimals (see the observation under Findings). This is correct and not misleading.

### Legacy fidelity
- The archive's only animated scenario is Example 3: x³ + 4x² − 10 on [−1, 2]. Its 2001 animation index lists only `RegulaFalsiaa`, and the GIF itself is not in the archive. Case A reproduces Example 3 exactly.
- Examples 1 and 2 are non-animated runs of the same cubic on [1, 2], so the page drops no archive animation case.
- Case B (x − cos x on [0, 1]) is an addition. It does not depart from any archive case.

