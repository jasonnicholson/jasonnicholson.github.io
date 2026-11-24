# False Position or Regula Falsi Method — animation review (round 9)

Page: `pages/numerical-methods/false-position-or-regula-falsi-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Counts: 0 Error, 0 Misleading, 0 Minor.

Observed and judged not to be a finding: in frame 1 of `regulafalsiaa.gif`, the annotation "Initial bracket [-1.0, 2.0]" begins under the right edge of the top-left legend box. The text is still fully legible, so this is cosmetic.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `regulafalsiaa.jl` | 0 | 14.6 | regulafalsiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `regulafalsibb.jl` | 0 | 8.0 | regulafalsibb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | "a secant line is drawn through the two bracket endpoints (a, f(a)) and (b, f(b)); its x-intercept c becomes the new estimate" | Both scripts use `c = (a f(b) − b f(a))/(f(b) − f(a))`, which is the x-intercept of that secant. The update replaces the endpoint whose f has the same sign as f(c). | confirmed |
| 2 | Intro | "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket" | In frame k the code draws the secant through `as[k], bs[k]` (the previous bracket). Frame 2 of A shows the secant through (−1,−7) and (2,14), with intercept 0. | confirmed |
| 3 | Intro | "the shaded band shows the updated bracket, which has the new point c (red) as one endpoint" | The shading uses `as[k+1], bs[k+1]`. In every iteration of both cases `as[k+1] = c_k` (instrumented output). | confirmed |
| 4 | Intro | "Regula Falsi weights the new point toward whichever endpoint has a smaller \|f\|" | c = b − f(b)(b−a)/(f(b)−f(a)), so c divides [a,b] in the ratio \|f(a)\| : \|f(b)\| measured from a. It therefore lies nearer the endpoint with smaller \|f\|. | confirmed |
| 5 | Intro | "often giving faster convergence — but one endpoint can remain fixed for many iterations" | Both cases have an error ratio below 0.5 (A 0.2513, B 0.0501), and a fixed endpoint in every iteration. | confirmed |
| 6 | Intro | "Julia source scripts ... are linked under each case" | Both links are present. | confirmed |
| 7 | Case A heading | f(x) = x³ + 4x² − 10, [a,b] = [−1, 2], "Convergent" | Script lines 15–16 match. c_12 = 1.36522935, error 6.6e-7. | confirmed |
| 8 | Case A | "converges to the real root x* ≈ 1.3652" | mpmath root 1.36523001341410 | confirmed |
| 9 | Case A | "The right endpoint b = 2 stays fixed throughout" | bs = 2.0 at all 13 states (instrumented) | confirmed |
| 10 | Case A | "f(−1) < 0" | f(−1) = −7 | confirmed |
| 11 | Case A | "every false-position point c also satisfies f(c) < 0" | f(c_k) runs from −10 at k=1 to −1.095e-5 at k=12, all negative | confirmed |
| 12 | Case A | "(f is convex on the bracket)" | f'' = 6x + 8 ≥ 2 > 0 on [−1, 2] (sympy) | confirmed |
| 13 | Case A | "a = −1, 0, 0.8333, 1.2088, …" | as = −1, 0, 0.833333, 1.208791 (script and mpmath agree) | confirmed |
| 14 | Case A | "one-sided" behaviour, unlike bisection | Bracket [c_k, 2]. Its width tends to 2 − x* ≈ 0.635, not to 0. | confirmed |
| 15 | Case A alt | "secant line ... walks toward the root near x=1.37, with the right endpoint fixed and successive false-position points converging from the left" | Root 1.3652 rounds to 1.37. All c_k < x*, increasing. Frames agree. | confirmed |
| 16 | Case A wiring | link `regulafalsiaa.jl`, embed `regulafalsiaa.gif` | The script writes that GIF, and its title and function are Case A's. | confirmed |
| 17 | Case B heading | f(x) = x − cos x, [a,b] = [0, 1], "Convergent (one-sided)" | Script lines 12–13 match. Converges (c_10 error 1.1e-13). b stays fixed. | confirmed |
| 18 | Case B | "Dottie number x* ≈ 0.7391, the unique fixed point of cosine" | Root 0.739085133215161. f' = 1 + sin x ≥ 0 with only isolated zeros, so f is strictly increasing and the real root is unique. | confirmed |
| 19 | Case B | "b = 1 (where f(1) ≈ 0.4597) remains fixed throughout" | f(1) = 0.4596976941. bs = 1.0 at all 11 states. | confirmed |
| 20 | Case B | "f is convex on [0, 1]" | f'' = cos x ≥ cos 1 = 0.5403 > 0 | confirmed |
| 21 | Case B | "every false-position point satisfies f(c) < 0" | f(c_k) runs from −0.0893 to −1.85e-13, all negative | confirmed |
| 22 | Case B | "c = 0.6851, 0.7363, 0.7389, …" | c = 0.685073, 0.736299, 0.738945 (script and mpmath agree) | confirmed |
| 23 | Case B | "the bracket shrinks only on the left side, yet the secant intercept homes in on the root accurately" | a increases and b = 1. Error ratio 0.0501, and error 1.1e-13 after 10 steps. | confirmed |
| 24 | Case B alt | "converges to the Dottie number x*≈0.739, with the right endpoint fixed at 1 while the left endpoint steps in" | as above | confirmed |
| 25 | Case B wiring | link `regulafalsibb.jl`, embed `regulafalsibb.gif` | The script writes that GIF, and its title and function are Case B's. | confirmed |
| 26 | Frames | The title function equals the code function, and the legend `c_k` index and value equal the computed c_k | A: legends c_1 = 0.0 … c_12 = 1.365229. B: c_1 = 0.685073 … c_10 = 0.739085. All match the instrumented values rounded to 6 digits. | confirmed |

The page has no separate Description section. The method statement in the intro (rows 1–4) is the only method description.

### 3. Implementation checks

### `regulafalsiaa.jl`
- **The method it claims to be.** This is plain Regula Falsi (classical false position, with no Illinois or Pegasus modification). c is the secant x-intercept, and the sign test `f(a)·f(c) < 0` selects the subinterval. It is equivalent to Mathews' `RegulaFalsi` Mathematica routine (`Sign[f[b]]==Sign[f[c]]` sets b = c, otherwise a = c). The script runs 12 iterations and has no stopping test; f(c) is never exactly 0, so that does not matter here.
- **The numbers.** The script's values (instrumented) and the independent mpmath values (40 digits) agree to every printed digit:

| k | script c_k | mpmath c_k | f(c_k) | \|c_k − x*\| | ratio |
|---|---|---|---|---|---|
| 1 | 0.0 | 0.0 | −10 | 1.365 | |
| 2 | 0.8333333333333334 | 0.833333333333 | −6.6435 | 0.532 | 0.3896 |
| 3 | 1.2087912087912087 | 1.20879120879 | −2.3890 | 0.156 | 0.2941 |
| 4 | 1.32412611057995 | 1.32412611058 | −0.66516 | 0.0411 | 0.2627 |
| 6 | 1.362596802578731 | 1.36259680258 | −0.043427 | 2.63e-3 | 0.2520 |
| 9 | 1.3651881982101728 | 1.36518819821 | −6.905e-4 | 4.18e-5 | 0.25128 |
| 12 | 1.36522935002777 | 1.36522935003 | −1.0955e-5 | 6.63e-7 | 0.25127 |

  The asymptotic ratio 1 − f'(x*)(b − x*)/f(b) evaluates to 0.25127071. The ratios converge to this value, which matches header line 6 ("settles at about 0.251").
- **Reference values.** Header line 8 gives "True root ≈ 1.36523". mpmath gives 1.3652300134141. Confirmed.
- **The picture.** The secant goes through the previous bracket's endpoints, with the correct slope (frame 2: slope 7 through (−1,−7) and (2,14), x-intercept 0). The red diamond is at (c_k, 0), the dotted vertical runs to (c_k, f(c_k)), and the shading is the updated bracket. Earlier intercepts are shown as grey diamonds. The axes (−1.5, 2.5) × (−14, 16) contain the bracket, the root and f(−1) = −7; the curve leaves the top only above y = 16, near x ≈ 2.05, which is outside the bracket. There is no clamping or masking. 13 frames correspond to frame 0 plus 12 iterations. Frames 1, 2, 4, 6, 8, 10 and 12 were inspected through `sheet.png`, and frames 1 and 2 at full size.

### `regulafalsibb.jl`
- **The method it claims to be.** The same classical Regula Falsi code, run for 10 iterations.
- **The numbers.** Script and mpmath agree:

| k | script c_k | mpmath c_k | f(c_k) | ratio |
|---|---|---|---|---|
| 1 | 0.6850733573260451 | 0.685073357326 | −0.089299 | |
| 2 | 0.736298997613654 | 0.736298997614 | −0.0046600 | 0.0516 |
| 3 | 0.7389453559657132 | 0.738945355966 | −2.339e-4 | 0.0502 |
| 5 | 0.7390847824489231 | 0.739084782449 | −5.870e-7 | 0.05009 |
| 10 | 0.73908513321505 | 0.739085133215 | −1.85e-13 | 0.05009 |

  The asymptotic ratio 1 − f'(x*)(1 − x*)/f(1) evaluates to 0.05009256, consistent with the computed ratios.
- **Reference values.** Header line 5 gives "x* ≈ 0.7391". mpmath gives 0.739085133215161. Confirmed.
- **The picture.** It is built the same way as Case A. The axes (−0.2, 1.3) × (−1.2, 0.5) contain f(0) = −1, f(1) = 0.4597 and the root. The legend sits at the bottom right, clear of the curve. 11 frames correspond to frame 0 plus 10 iterations. Every frame was inspected through `sheet.png`. The legend shows c_k to 6 digits, so it reads 0.739085 from k = 5 onward, which is correct rounding.

### 4. Legacy archive

Consulted the following:
- `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/RegulaFalsiMod.html` and its links `_lnk_1` to `_lnk_4`
- the formula images `gr_10`, `gr_256`, `gr_432`, `gr_433`
- the code images `gr_431` and `gr_434`
- `a2001/Animations/RootFinding/RegulaFalsi/RegulaFalsi.html` and `RegulaFalsiaa.html`

The archive's `RegulaFalsiaa.gif` is not present in the archive.

What the archive contains:
- Example 1 and Example 2 are non-animated runs on x³ + 4x² − 10 over [1, 2].
- Example 3 ("Convergence") is the only animated example: x³ + 4x² − 10 on [a,b] = [−1, 2], with `RegulaFalsi[a, b, 15]`.
- The "Limitations" bullets (a discontinuity, distinct roots, a large interval) are open exercises, not worked examples.

How the page compares:
- Case A reproduces Example 3's function and interval. The script stops after 12 iterations instead of Mathews' 15, which has no effect on what a reader learns.
- Case B (x − cos x) is an added example, not a replacement.
- No archive animation case is dropped.

No fidelity findings.

### 5. Could not determine
Nothing on the page fell outside what could be checked.

