# False Position or Regula Falsi Method — animation review (round 8)

Page: `pages/numerical-methods/false-position-or-regula-falsi-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** 0 Error, 0 Misleading, 0 Minor.

Observations that I judged not to be findings (per the review standard):
- The page has no `## Description` section (the authoring conventions require one). This is missing content, not an error in content present.
- In Case B the frames for c_5 to c_10 are visually indistinguishable (the 6-digit legend label stays at 0.739085 from c_5 on, since the error is below 4e-7). The page makes no claim that contradicts this; it is a teaching-design matter.
- In Case A frame 0 the "Initial bracket [-1.0, 2.0]" annotation sits beside the legend box but remains legible.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `regulafalsiaa.jl` | 0 | 10.3 | regulafalsiaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `regulafalsibb.jl` | 0 | 7.8 | regulafalsibb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | Intro | "a secant line is drawn through the two bracket endpoints (a, f(a)) and (b, f(b)); its x-intercept c becomes the new estimate" | Both scripts: `c = (a*f(b) - b*f(a))/(f(b)-f(a))` (aa l.32, bb l.29), which is the x-intercept of that chord; secant drawn from `f(a_prev) + slope*(x-a_prev)` with slope from the same two points (aa l.88-90, bb l.84-86) | confirmed |
| 2 | Intro | "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket" | Secant uses `as[frame], bs[frame]` = bracket before update; frame for c_2 in aa shows secant through (0,-10) and (2,14) | confirmed |
| 3 | Intro | "the shaded band shows the updated bracket, which has the new point c (red) as one endpoint" | Shading uses `as[frame+1], bs[frame+1]`; in every iteration a_{k+1} = c_k (instrumented output); frames show red diamond at the left edge of the band | confirmed |
| 4 | Intro | "Regula Falsi weights the new point toward whichever endpoint has a smaller \|f\| value" | c = a·\|f(b)\|/(\|f(a)\|+\|f(b)\|) + b·\|f(a)\|/(\|f(a)\|+\|f(b)\|) when signs differ, so c lies nearer the endpoint with smaller \|f\| | confirmed |
| 5 | Intro | "often giving faster convergence [than bisection] — but one endpoint can remain fixed for many iterations" | Case A asymptotic error ratio 0.2513, Case B 0.0501 (vs bisection 0.5); b fixed in all iterations of both cases | confirmed |
| 6 | Intro | "Julia source scripts ... are linked under each case" | Two links present, each to the existing script | confirmed |
| 7 | Case A heading | "Convergent, f(x) = x^3 + 4x^2 - 10, [a, b] = [-1, 2]" | aa l.15-16: `f(x) = x^3 + 4x^2 - 10`, `a0, b0 = -1.0, 2.0`; iterates converge (err 6.6e-7 at k=12) | confirmed |
| 8 | Case A | "converges to the real root x* ≈ 1.3652" | mpmath root 1.365230013414097; c_12 = 1.36522935002777 | confirmed |
| 9 | Case A | "The right endpoint b = 2 stays fixed throughout" | Instrumented: b = 2.0 at every iteration 1..12, final bracket [1.36522935, 2.0] | confirmed |
| 10 | Case A | "f(-1) < 0 and every false-position point c also satisfies f(c) < 0" | f(-1) = -7; f(c_k) from -10 (k=1) to -1.0955e-5 (k=12), all negative (Float64 and mpmath agree) | confirmed |
| 11 | Case A | "(f is convex on the bracket)" | f'' = 6x + 8, min on [-1,2] = 2 > 0 | confirmed |
| 12 | Case A | "a = -1, 0, 0.8333, 1.2088, ..." | a_1..a_4 = -1, 0, 0.833333, 1.208791 (script and mpmath) | confirmed |
| 13 | Case A | "'one-sided' stagnation is characteristic of Regula Falsi" | b never moves; bracket width stays ≥ 2 - x* = 0.635 | confirmed |
| 14 | Case A link/embed | `regulafalsiaa.jl` / `regulafalsiaa.gif` | Script parameters match heading; GIF regenerates byte-identically from that script | confirmed |
| 15 | Case A alt | "secant line from bracket endpoints walks toward the root near x=1.37, with the right endpoint fixed and successive false-position points converging from the left" | x* = 1.36523 → 1.37 to 2 d.p.; all c_k < x*, increasing; b fixed; frames show this | confirmed |
| 16 | Case B heading | "Convergent (one-sided), f(x) = x - cos(x), [a, b] = [0, 1]" | bb l.12-13; b fixed, converges (err 1.1e-13 at k=10) | confirmed |
| 17 | Case B | "converges to the 'Dottie number' x* ≈ 0.7391, the unique fixed point of cosine" | mpmath root 0.7390851332151607; root of x - cos x is cos's fixed point, unique since x - cos x is strictly increasing | confirmed |
| 18 | Case B | "b = 1 (where f(1) ≈ 0.4597) remains fixed throughout" | f(1) = 0.459698; b = 1.0 at every iteration | confirmed |
| 19 | Case B | "f is convex on [0, 1]" | f'' = cos x, min on [0,1] = 0.5403 > 0 | confirmed |
| 20 | Case B | "every false-position point satisfies f(c) < 0" | f(c_k) from -0.0893 to -1.85e-13, all negative | confirmed |
| 21 | Case B | "c = 0.6851, 0.7363, 0.7389, ..." | c_1..c_3 = 0.685073, 0.736299, 0.738945 | confirmed |
| 22 | Case B | "the bracket shrinks only on the left side, yet the secant intercept homes in on the root accurately" | a increases each step, b fixed; error ratio ≈ 0.0501, err 1.1e-13 at k=10 | confirmed |
| 23 | Case B link/embed | `regulafalsibb.jl` / `regulafalsibb.gif` | Parameters match heading; byte-identical regeneration | confirmed |
| 24 | Case B alt | "converges to the Dottie number x*≈0.739, with the right endpoint fixed at 1 while the left endpoint steps in" | As above; frames show it | confirmed |
| 25 | Counts (implicit) | Two cases | Two scripts, two GIFs, two embeds | confirmed |

Script header claims (also checked):
- aa l.6: "error ratio |c_{k+1} - x*| / |c_k - x*| settles at about 0.251" — measured ratios 0.2512710 at k=11,12; theoretical 1 - f'(x*)(2 - x*)/f(2) = 0.25127. Confirmed.
- aa l.8: "True root ≈ 1.36523" — 1.3652300. Confirmed.
- aa l.3: "Matches the legacy Mathews module example" — Example 3: x^3 + 4x^2 - 10 = 0, [a,b] = [-1,2] (images gr_432, gr_433, gr_434). Confirmed.
- bb l.3-5: right endpoint fixed at 1, c converges from the left, x* ≈ 0.7391. Confirmed.

### 3. Implementation checks

### `regulafalsiaa.jl`
- **Method:** Classic (unmodified) regula falsi: c is the chord x-intercept; keep the subinterval with a sign change (`f(a)*f(c) < 0` → b = c, else a = c). No Illinois/Pegasus modification, which is what the page describes. Correct.
- **Numbers:** script vs independent mpmath:

  | k | script c_k | mpmath c_k | script f(c_k) | mpmath f(c_k) |
  |---|---|---|---|---|
  | 1 | 0.0 | 0.0 | -10.0 | -10.0 |
  | 2 | 0.8333333333 | 0.8333333333 | -6.643519 | -6.64352 |
  | 3 | 1.2087912088 | 1.208791209 | -2.389038 | -2.38904 |
  | 4 | 1.3241261106 | 1.324126111 | -0.665157 | -0.665157 |
  | 6 | 1.3625968026 | 1.362596803 | -0.0434271 | -0.0434271 |
  | 12 | 1.3652293500 | 1.36522935 | -1.09548e-5 | -1.09548e-5 |

  Mathews' table (gr_453) gives f(c) = -2.3890383255519425 at the third step, matching. Error ratios approach the theoretical 0.251271.
- **Reference values:** No reference curve is drawn; the comment's root 1.36523 is right (mpmath 1.36523001341).
- **Picture:** Frames 1, 3, 5, 7, 9, 11, 13 inspected (contact sheet). Secant goes through the previous bracket's endpoints; red diamond at c_k on the axis with dotted drop to (c_k, f(c_k)); band spans the updated bracket; grey diamonds are earlier c's. Legend labels (c_2 = 0.833333, c_4 = 1.324126, c_6 = 1.362597, c_8 = 1.365064, c_10 = 1.36522, c_12 = 1.365229) equal the instrumented `round(c; digits=6)`. Title function matches code. ylims (-14, 16) clip f beyond x ≈ 2.06 only, which is outside the bracket; b = (2, 14) is visible. No misleading clamping.

### `regulafalsibb.jl`
- **Method:** Same classic regula falsi loop. Correct.
- **Numbers:**

  | k | script c_k | mpmath c_k | script f(c_k) | mpmath f(c_k) |
  |---|---|---|---|---|
  | 1 | 0.6850733573 | 0.6850733573 | -0.0892993 | -0.0892993 |
  | 2 | 0.7362989976 | 0.7362989976 | -0.00466004 | -0.00466004 |
  | 3 | 0.7389453560 | 0.738945356 | -2.33926e-4 | -2.33926e-4 |
  | 5 | 0.7390847824 | 0.7390847824 | -5.87047e-7 | -5.87047e-7 |
  | 10 | 0.7390851332150 | 0.7390851332 | -1.85185e-13 | -1.85156e-13 |

  (The last f(c) differs in the 4th digit only through Float64 cancellation at 1e-13; it does not affect any branch or display.) Error ratio 0.0500926 equals the theoretical 1 - f'(x*)(1 - x*)/f(1).
- **Reference values:** None drawn; comment's 0.7391 is right.
- **Picture:** Contact sheet (all 11 frames) inspected. Same construction as Case A; legend labels match instrumented values (0.685073, 0.736299, 0.738945, 0.739078, 0.739085 ×6). ylims (-1.2, 0.5) contain f on [0, 1] (f(0) = -1, f(1) = 0.46). Faithful.

### Legacy fidelity
The archive has a single animation (a2001 `RegulaFalsiaa`, the GIF file itself is not in the archive) attached to Example 3, x^3 + 4x^2 - 10 on [-1, 2] (Mathews ran 15 iterations; the page shows 12, which is immaterial). Case A reproduces it. Examples 1 and 2 use the same cubic on [1, 2] and are not animation scenarios. Case B (x - cos x on [0,1]) is an addition with no archive counterpart. No archive case is dropped. No fidelity finding.

