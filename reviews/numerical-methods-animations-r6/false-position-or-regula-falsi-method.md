# False Position or Regula Falsi Method — animation review (round 6)

Page: `pages/numerical-methods/false-position-or-regula-falsi-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page and in the script headers agrees with my independent computation and the frames. No Error, Misleading or Minor findings.

Observations considered and judged not to be findings:

- Case B frames 6–11 (c_5 … c_10) look the same except for the legend index, and all of them show `c_k = 0.739085`. That is because the iterates agree to 6 decimals from c_5 on (|c_5 − x*| = 3.5e-7). It is a true picture of converged iterates, and each frame is a distinct image (the frame hashes differ). It does not mislead.
- Frame 1 of Case A: the "Initial bracket [-1.0, 2.0]" annotation runs slightly into the legend box but is still readable. This is cosmetic.
- Case A uses 12 iterations, where Mathews' Example 3 calls `RegulaFalsi[a, b, 15]`. That is a choice of frame count, the method and problem are the same, and the page states no iteration count. It is not a fidelity issue.
- Case B (x − cos x on [0,1]) is not in the Mathews module, which has a single animated example. It is an addition, not a replacement or a dropped case, and the page does not attribute it to Mathews.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `regulafalsiaa.jl` | 0 | 6.9 | regulafalsiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

Sources: `index.qmd` lines 13–31 (the page has no Description section with formulas, only the Animations section). Evidence for the numbers is from `review/indep.py` (mpmath, 40 digits) and the instrumented scripts.

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | l.13 | "a secant line is drawn through the two bracket endpoints (a, f(a)) and (b, f(b)); its x-intercept c becomes the new estimate" | Code l.32/29: `c = (a f(b) − b f(a))/(f(b) − f(a))`, the x-intercept of that chord. Frames A-2 and B-2 show the dashed line through (−1,−7),(2,14) and through (0,−1),(1,0.4597) | confirmed |
| 2 | l.13 | "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket" | Code: secant built from `as[frame], bs[frame]` (previous bracket). Frames confirm it | confirmed |
| 3 | l.13 | "the shaded band shows the updated bracket, which has the new point c (red) as one endpoint" | Shading uses `as[frame+1], bs[frame+1]`. Updated a = c_k in every step (see the tables in section 3). Frames show the band's left edge at the red diamond | confirmed |
| 4 | l.13 | "Regula Falsi weights the new point toward whichever endpoint has a smaller \|f\| value" | c = (a\|f(b)\| + b\|f(a)\|)/(\|f(a)\|+\|f(b)\|) for opposite signs, so the weight on each endpoint is the other endpoint's \|f\| and c lies nearer the endpoint with smaller \|f\| | confirmed |
| 5 | l.13 | "often giving faster convergence" than bisection, "but one endpoint can remain fixed for many iterations" | Both cases: the error ratio is 0.2513 (A) and 0.0501 (B), against 0.5 for bisection. b is fixed for all iterations in both cases | confirmed |
| 6 | l.15 | Julia source scripts linked under each case | l.21 → regulafalsiaa.jl, l.29 → regulafalsibb.jl. Both exist | confirmed |
| 7 | l.17 | Case A heading: f(x)=x³+4x²−10, [a,b]=[−1,2], "Convergent" | Script l.15–16 have the same f and a0,b0. It converges to 1.365229 after 12 steps (error 6.6e-7) | confirmed |
| 8 | l.19 | "converges to the real root x* ≈ 1.3652" | mpmath root 1.36523001341410. numpy roots: the other two are −2.6826 ± 0.3583i, so it is the only real root | confirmed |
| 9 | l.19 | "The right endpoint b = 2 stays fixed throughout" | b = 2.0 in all 12 steps, final bracket [1.36522935, 2.0] | confirmed |
| 10 | l.19 | "f(−1) < 0 and every false-position point c also satisfies f(c) < 0" | f(−1) = −7. f(c_k) = −10, −6.64, −2.39, −0.665, …, −1.10e-5, all negative | confirmed |
| 11 | l.19 | "(f is convex on the bracket)" | f'' = 6x+8 ≥ 2 on [−1,2] | confirmed |
| 12 | l.19 | "a = −1, 0, 0.8333, 1.2088, …" | a_1..a_4 = −1, 0, 0.833333, 1.208791 | confirmed |
| 13 | l.19 | One-sided stagnation "distinguishes it from the symmetric bracketing of bisection" | Qualitative and consistent with claim 9 | confirmed |
| 14 | l.21/23 | Case A link and embed are Case A | regulafalsiaa.jl has f = x³+4x²−10 on [−1,2]. regulafalsiaa.gif is byte-identical to the regenerated output (manifest) and its title reads "f(x) = x³ + 4x² − 10" | confirmed |
| 15 | l.23 alt | "secant line from bracket endpoints walks toward the root near x=1.37, with the right endpoint fixed and successive false-position points converging from the left" | Root 1.36523 ≈ 1.37. b fixed. c_k increasing from below the root | confirmed |
| 16 | l.25 | Case B heading: f(x)=x−cos x, [a,b]=[0,1], "Convergent (one-sided)" | Script l.12–13 match. Converges, with b fixed | confirmed |
| 17 | l.27 | "Dottie number x* ≈ 0.7391, the unique fixed point of cosine" | Root 0.739085133215. f' = 1+sin x ≥ 0 and is zero only at isolated points, so f is strictly increasing and the root is unique | confirmed |
| 18 | l.27 | "The right endpoint b = 1 (where f(1) ≈ 0.4597) remains fixed throughout" | f(1) = 0.459698. b = 1.0 in all 10 steps | confirmed |
| 19 | l.27 | "f is convex on [0,1] and every false-position point satisfies f(c) < 0" | f'' = cos x ≥ cos 1 = 0.540 > 0. f(c_k) = −0.0893, −0.00466, …, −1.85e-13, all negative | confirmed |
| 20 | l.27 | "c = 0.6851, 0.7363, 0.7389, …" | c_1..c_3 = 0.685073, 0.736299, 0.738945 | confirmed |
| 21 | l.27 | "the bracket shrinks only on the left side, yet the secant intercept homes in on the root accurately" | Only a moves. The final c_10 is within 1.1e-13 of x* | confirmed |
| 22 | l.29/31 | Case B link and embed are Case B | regulafalsibb.jl has f = x − cos x on [0,1]. The GIF is byte-identical to the regenerated output and its title reads "f(x) = x − cos(x)" | confirmed |
| 23 | l.31 alt | "converges to the Dottie number x*≈0.739, with the right endpoint fixed at 1 while the left endpoint steps in" | As claims 17–21 | confirmed |
| 24 | regulafalsiaa.jl l.3 | "Matches the legacy Mathews module example" | Mathews Example 3 (lnk_4, images gr_432–434): x³+4x²−10 = 0, [a,b] = [−1,2] | confirmed |
| 25 | regulafalsiaa.jl l.6 | "error ratio … settles at about 0.251" | Ratios 0.3896, 0.2941, 0.2627, … → 0.251271. Asymptotic 1 − f'(x*)(b−x*)/f(b) = 0.251271 | confirmed |
| 26 | regulafalsiaa.jl l.8 | "True root ≈ 1.36523" | 1.365230013 | confirmed |
| 27 | regulafalsibb.jl l.3–5 | "right endpoint stays fixed at 1", "c points converge from the left", "x* ≈ 0.7391" | As claims 17–21 | confirmed |
| 28 | GIF legends | `c_k = round(c_k, 6)` with the correct index (frame k shows c_k) | Instrumented values match the legends in frames A-2 (c_1 = 0.0), A-13 (c_12 = 1.365229), B-2 (c_1 = 0.685073) and B-11 (c_10 = 0.739085) | confirmed |
| 29 | Counts | (implicit) frames = iterations + 1 | A: 13 frames = 0..12. B: 11 frames = 0..10 | confirmed |

### 3. Implementation checks

### `regulafalsiaa.jl`
- **Method:** the standard (unmodified) Regula Falsi: c is the chord x-intercept, and the endpoint whose sign matches f(c) is replaced (l.32–40). This is the same as Mathews' `RegulaFalsi` subroutine (gr_9/gr_430). Mathews tests `Sign[f[b]] == Sign[f[c]]` and the script tests `f(a)f(c) < 0`. These differ only when f(c) is exactly 0, which never happens here. It is not the Illinois or Pegasus modification, and the page does not claim one.
- **Numbers:** Instrumented copy (`julia review/inst_regulafalsiaa.jl`) against mpmath (`python3 -I review/indep.py`):

  | k | script c_k | independent c_k | f(c_k) |
  |---|---|---|---|
  | 1 | 0.0 | 0.0 | −10 |
  | 2 | 0.8333333333333334 | 0.8333333333 | −6.6435 |
  | 3 | 1.2087912087912087 | 1.208791209 | −2.3890 |
  | 4 | 1.32412611057995 | 1.324126111 | −0.66516 |
  | 6 | 1.362596802578731 | 1.362596803 | −0.043427 |
  | 9 | 1.3651881982101728 | 1.365188198 | −6.905e-4 |
  | 12 | 1.36522935002777 | 1.36522935003 | −1.0955e-5 |

  They agree to every digit shown. The error ratio converges to 0.251271, which matches the theoretical linear rate 1 − f'(x*)(b − x*)/f(b) = 0.251271.
- **Reference values:** The root 1.36523 in the comment is correct (mpmath 1.3652300134). The script draws no separate reference curve.
- **Picture:** The secant is drawn through the previous bracket endpoints (l.86–91). The red diamond is at (c_k, 0), and a dotted drop line goes to (c_k, f(c_k)). The band and the blue markers show the updated bracket. Earlier c's are shown as grey diamonds. I checked frames 1, 2, the contact sheet (frames 1,3,5,7,9,11,13) and frame 13. In frame 2 the secant passes through (−1,−7) and (2,14) and crosses the axis at 0. Frame 13's legend reads c_12 = 1.365229. Axis limits (−1.5, 2.5) × (−14, 16) clip the curve only for x ≳ 2.1, which is outside the bracket. Nothing is clamped or misrepresented.

### `regulafalsibb.jl`
- **Method:** the same standard Regula Falsi code as Case A (l.29–37).
- **Numbers:** Instrumented copy against mpmath:

  | k | script c_k | independent c_k | f(c_k) |
  |---|---|---|---|
  | 1 | 0.6850733573260451 | 0.6850733573 | −0.089299 |
  | 2 | 0.736298997613654 | 0.7362989976 | −0.0046600 |
  | 3 | 0.7389453559657132 | 0.738945356 | −2.339e-4 |
  | 4 | 0.7390781308800257 | 0.7390781309 | −1.172e-5 |
  | 10 | 0.73908513321505 | 0.7390851332 | −1.85e-13 |

  They agree. The error ratio converges to 0.0500926, which matches the theoretical 1 − f'(x*)(1 − x*)/f(1) = 0.0500926.
- **Reference values:** x* = 0.7391 (mpmath 0.739085133215) and f(1) = 0.4597 are both correct.
- **Picture:** Frame 2 shows the secant through (0,−1) and (1,0.4597), with its intercept at 0.685 and the red point at f(c_1) = −0.089. The band is [0.685, 1]. Frame 11's legend reads c_10 = 0.739085. Axis limits (−0.2, 1.3) × (−1.2, 0.5) keep f(0) = −1 and f(1) = 0.46 inside and clip the curve only for x > ~1.03. The frame hashes are all distinct. Later frames look alike because the iterates have converged (see Findings).

### Regeneration
According to the manifest, both scratch copies reproduce the committed GIFs byte for byte (13 and 11 frames), so the frames I inspected are what the scripts produce.

