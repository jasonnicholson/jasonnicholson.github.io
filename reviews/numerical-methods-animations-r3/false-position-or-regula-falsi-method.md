# False Position or Regula Falsi Method — animation review (round 3)

Page: `pages/numerical-methods/false-position-or-regula-falsi-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**There are no findings.** I checked every claim in the ledger below against my own computation or against the extracted frames, and none failed.

Some things I looked at and decided were not findings:
- In `regulafalsibb.gif`, frames 6 to 11 look identical apart from the legend index. From c_5 on, every iterate rounds to 0.739085 at the 6 digits the legend shows. This is a true picture of fast convergence, not a misleading one. The same happens in `regulafalsiaa.gif` from about c_7 on, but there the legend values keep changing.
- The archive's Example 3 runs 15 iterations (gr_434: `RegulaFalsi[a, b, 15]`). Case A runs 12. The page does not state an iteration count, so this is not a departure that matters.
- Case B (x − cos x on [0, 1]) does not come from the archive. It is an added case, and the script makes no claim that it comes from the archive. No archive animation scenario was dropped: the archive's "Various Scenarios and Animations" section has only Example 3, which is Case A. Examples 1 and 2 are subroutine printouts, not animation scenarios.
- In frame 1 of `regulafalsiaa.gif`, the "Initial bracket [-1.0, 2.0]" annotation sits right next to the legend box. It is still readable.
- The page has no Description section. Missing content is out of scope.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `regulafalsiaa.jl` | 0 | 9.9 | regulafalsiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `regulafalsibb.jl` | 0 | 8.2 | regulafalsibb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | "a secant line is drawn through the two bracket endpoints (a, f(a)) and (b, f(b)); its x-intercept c becomes the new estimate" | Both scripts compute c = (a f(b) − b f(a))/(f(b) − f(a)), which is the x-intercept of that secant (line 32 in aa, line 29 in bb). This matches the independent form a − f(a)(b−a)/(f(b)−f(a)) to every printed digit. | confirmed |
| 2 | Intro | "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket" | The code draws the secant from `as[frame], bs[frame]`, the bracket before the update (aa lines 86–91, bb lines 83–87). In frame 2 of A, the dashed line is y = 7x, which passes through (−1, −7) and (2, 14). | confirmed |
| 3 | Intro | "the shaded band shows the updated bracket, which has the new point c (red) as one endpoint" | The shading uses `as[frame+1], bs[frame+1]`. In every iteration of both cases, the new a equals c (instrumented output). In the frames, the band's left edge sits on the red diamond. | confirmed |
| 4 | Intro | "Regula Falsi weights the new point toward whichever endpoint has a smaller \|f\| value" | c = a + (b−a)\|f(a)\|/(\|f(a)\|+\|f(b)\|) when the signs are opposite, so c is closer to the endpoint with the smaller \|f\|. Example: A step 1 gives \|f(−1)\| = 7 and \|f(2)\| = 14, so c = 0, which is closer to −1. | confirmed |
| 5 | Intro | "often giving faster convergence — but one endpoint can remain fixed for many iterations" | Case A error ratio is 0.2513 and Case B is 0.0501, against 0.5 for bisection. In both cases b stays fixed for every iteration. | confirmed |
| 6 | Intro | "Julia source scripts that generated these animations are linked under each case." | Both cases have links. The manifest shows each regenerated GIF is byte-identical to the committed one. | confirmed |
| 7 | A heading | f(x) = x³ + 4x² − 10, [a, b] = [−1, 2] | aa lines 15–16. Title and legend show the same function. | confirmed |
| 8 | A heading | "Convergent" | The iterates approach 1.3652300134 with error 6.6e−7 at c_12. | confirmed |
| 9 | A Behavior | "converges to the real root x* ≈ 1.3652" | mpmath root 1.36523001341410. The other two roots are complex (−2.6826 ± 0.3583i), so this is the only real root. | confirmed |
| 10 | A Behavior | "The right endpoint b = 2 stays fixed throughout" | Instrumented: b_next = 2.0 for i = 1..12. | confirmed |
| 11 | A Behavior | "f(−1) < 0" | f(−1) = −7. | confirmed |
| 12 | A Behavior | "every false-position point c also satisfies f(c) < 0" | f(c_k) runs from −10, −6.6435 … to −1.0955e−5. All 12 values are negative. | confirmed |
| 13 | A Behavior | "(f is convex on the bracket)" | f'' = 6x + 8 ≥ 2 > 0 on [−1, 2]. | confirmed |
| 14 | A Behavior | "keeps replacing a with c (a = −1, 0, 0.8333, 1.2088, …)" | Script: −1, 0, 0.833333, 1.2087912. Independent: same. | confirmed |
| 15 | A Behavior | "This 'one-sided' stagnation is characteristic of Regula Falsi" | The bracket width never drops below 2 − 1.36523 = 0.635. | confirmed |
| 16 | A link/embed | `regulafalsiaa.jl` / `regulafalsiaa.gif` | The script writes `regulafalsiaa.gif` with the Case A function and interval, and the frames show Case A. | confirmed |
| 17 | A alt text | "secant line from bracket endpoints walks toward the root near x=1.37" | The root is 1.3652, which rounds to 1.37. The frames show the intercepts moving toward it. | confirmed |
| 18 | A alt text | "right endpoint fixed and successive false-position points converging from the left" | b = 2 in every frame. All c_k < x*, and they increase. | confirmed |
| 19 | B heading | f(x) = x − cos(x), [a, b] = [0, 1]; "Convergent (one-sided)" | bb lines 12–13. The iterates converge to 0.7390851332 and b stays fixed. | confirmed |
| 20 | B Behavior | "converges to the 'Dottie number' x* ≈ 0.7391, the unique fixed point of cosine" | mpmath root 0.739085133215161. f' = 1 + sin x ≥ 0, so f is monotone and the real root is unique. | confirmed |
| 21 | B Behavior | "The right endpoint b = 1 (where f(1) ≈ 0.4597) remains fixed throughout" | f(1) = 0.4596976941. b_next = 1.0 for i = 1..10. | confirmed |
| 22 | B Behavior | "f is convex on [0, 1]" | f'' = cos x ≥ cos 1 = 0.5403 > 0. | confirmed |
| 23 | B Behavior | "every false-position point satisfies f(c) < 0" | f(c_k) runs from −0.0893 to −1.85e−13. All 10 values are negative. | confirmed |
| 24 | B Behavior | "points advance from the left (c = 0.6851, 0.7363, 0.7389, …)" | Script: 0.68507336, 0.73629900, 0.73894536. Independent: same. The sequence is increasing and stays below x*. | confirmed |
| 25 | B Behavior | "the bracket shrinks only on the left side, yet the secant intercept homes in on the root accurately" | Error falls from 5.4e−2 to 1.1e−13 in 10 steps. The right edge stays at 1. | confirmed |
| 26 | B link/embed | `regulafalsibb.jl` / `regulafalsibb.gif` | The script writes `regulafalsibb.gif` with the Case B parameters, and the frames show Case B. | confirmed |
| 27 | B alt text | "converges to the Dottie number x*≈0.739, with the right endpoint fixed at 1 while the left endpoint steps in" | As in rows 20, 21 and 24. | confirmed |
| 28 | Script aa comments | "Matches the legacy Mathews module example" | Archive Example 3 (gr_432 and gr_433) uses x³ + 4x² − 10 = 0 on [−1, 2]. Archive table row k=1 has b = 2 and f(c) = −6.64351851851852, which matches the script's f(c_2) = −6.643518518518518. | confirmed |
| 29 | Script aa comments | "error ratio … settles at about 0.251"; "True root ≈ 1.36523" | Observed ratio 0.251271. Theoretical ratio 1 − f'(x*)(2 − x*)/f(2) = 0.25127071. The root is 1.3652300. | confirmed |
| 30 | Script bb comments | "right endpoint stays fixed at 1"; "Root: x* ≈ 0.7391" | As in rows 20 and 21. | confirmed |
| 31 | Frames (both) | Legend "c_k = …" values | Frame k+1 shows `cs[k]` rounded to 6 digits. A: c_1 = 0.0, c_2 = 0.833333, c_4 = 1.324126, c_6 = 1.362597, c_8 = 1.365064, c_10 = 1.36522, c_12 = 1.365229. B: c_1 = 0.685073, c_2 = 0.736299, c_3 = 0.738945, c_4 = 0.739078, c_5..c_10 = 0.739085. Each matches the instrumented value rounded to 6 digits. | confirmed |
| 32 | Fidelity | Archive animation cases are reproduced | The archive has one animation scenario (Example 3), and it appears as Case A. Case B is an added case. | confirmed (no departure) |

### 3. Implementation checks

### `regulafalsiaa.jl`
- **Is it the method it claims to be?** Yes. This is the standard false position (Regula Falsi) method with no Illinois or Pegasus modification. The update is c = (a f(b) − b f(a))/(f(b) − f(a)). If f(a) f(c) < 0, then b ← c; otherwise a ← c. It runs a fixed 12 iterations. If f(c) were exactly 0, the code would set a ← c, which keeps c as a valid endpoint. That case never happens here.
- **Are the numbers right?** Yes. Script values (Float64) beside the independent mpmath values:

| k | script c_k | mpmath c_k | f(c_k) | error | ratio |
|---|---|---|---|---|---|
| 1 | 0.0 | 0.0 | −10 | 1.365 | |
| 2 | 0.8333333333333334 | 0.833333333333 | −6.64352 | 0.532 | 0.3896 |
| 3 | 1.2087912087912087 | 1.20879120879 | −2.38904 | 0.156 | 0.2941 |
| 4 | 1.32412611057995 | 1.32412611058 | −0.665157 | 4.11e−2 | 0.2627 |
| 6 | 1.362596802578731 | 1.36259680258 | −0.0434271 | 2.63e−3 | 0.2520 |
| 8 | 1.365063606246616 | 1.36506360625 | −2.74772e−3 | 1.66e−4 | 0.25132 |
| 10 | 1.365219506354675 | 1.36521950635 | −1.73506e−4 | 1.05e−5 | 0.251274 |
| 12 | 1.36522935002777 | 1.36522935003 | −1.09548e−5 | 6.63e−7 | 0.251271 |

  The error ratio converges to the predicted linear constant for a fixed endpoint, 0.25127071.
- **Are the reference values right?** The script draws no reference curve or root marker. Its comment "True root ≈ 1.36523" matches mpmath 1.36523001341.
- **Does the picture show what was computed?** Yes. I viewed frames 1 and 2, and frames 1, 2, 4, 6, 8, 10, 12 and 13 on the contact sheet. In frame 1, the bracket [−1, 2] is shaded, with dots at (−1, −7) and (2, 14). In frame 2, the secant y = 7x is drawn through the previous endpoints. The red diamond is at c_1 = 0, with a dotted drop to (0, −10). The band is [0, 2]. Gray diamonds mark the earlier c values. Legend indices and values match the computed c_k. The axis limits (−1.5, 2.5) × (−14, 16) contain the curve's minimum (−10 at x = 0), the root and both endpoints. Nothing is clamped or masked. There are 13 frames: the initial bracket plus 12 iterations.

### `regulafalsibb.jl`
- **Is it the method it claims to be?** Yes. The code is the same as `regulafalsiaa.jl`, with f(x) = x − cos x on [0, 1] and 10 iterations.
- **Are the numbers right?** Yes. Script values beside mpmath:

| k | script c_k | mpmath c_k | f(c_k) | error | ratio |
|---|---|---|---|---|---|
| 1 | 0.6850733573260451 | 0.685073357326 | −0.0892993 | 5.40e−2 | |
| 2 | 0.736298997613654 | 0.736298997614 | −4.66004e−3 | 2.79e−3 | 0.05158 |
| 3 | 0.7389453559657132 | 0.738945355966 | −2.33926e−4 | 1.40e−4 | 0.05017 |
| 4 | 0.7390781308800257 | 0.73907813088 | −1.17192e−5 | 7.00e−6 | 0.050096 |
| 6 | 0.7390851156443783 | 0.739085115644 | −2.94067e−8 | 1.76e−8 | 0.0500926 |
| 10 | 0.73908513321505 | 0.739085133215 | −1.85e−13 | 1.1e−13 | 0.0500926 |

  The theoretical ratio for a fixed endpoint is 0.05009256, and the observed ratio matches it.
- **Are the reference values right?** No reference is drawn. The comment "x* ≈ 0.7391" is correct (0.739085133215).
- **Does the picture show what was computed?** Yes. I viewed frames 2 and 11 and the full contact sheet (frames 1–11). In frame 2, the secant runs through (0, −1) and (1, 0.4597), the red diamond is at 0.685073, and the band is [0.685, 1]. In frame 11 the band is [0.739, 1] and the legend reads c_10 = 0.739085. The axis limits (−0.2, 1.3) × (−1.2, 0.5) include (0, −1), (1, 0.4597) and the root. The curve leaves the top edge only for x > about 1.03, outside the bracket. There are 11 frames: the initial bracket plus 10 iterations.

### Regeneration
According to the manifest, both scratch copies ran with exit code 0 and reproduced the committed GIFs byte-for-byte. I did not run the full plotting scripts again. The instrumented copies contain only the computation section, unchanged.

