# Muller's Method — animation review (round 4)

Page: `pages/numerical-methods/mullers-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1: Page match / picture. **Minor.** In Case 1, the window is too coarse to show the case's central claim from frame 3 onward.

- **Location:** `mullersaa.jl` lines 19–20 (`xlims = (-2.5, 2.5)`, `ylims = (-8.0, 7.0)`, fixed for all frames). Page text: "None of the parabolas reaches the x-axis … This animation takes the real part of that complex root instead, which is the parabola's vertex (open red circle)."
- **What is there now:** a fixed 15-unit-tall window, about 410 px of plot height, so roughly 0.036 units per pixel. The parabola's minimum height (the vertex marker's y) per frame, from `mullersaa_chk.jl` and confirmed by mpmath:

  | Frame | Vertex height |
  |---|---|
  | 1 | 0.800 |
  | 2 | 0.181 |
  | 3 | 0.0319 (under 1 px) |
  | 4 | 0.0022 |
  | 5 | 7.8e-5 |
  | 6 | 8.9e-7 |
  | 7 | 1.8e-9 |
  | 8 | 5.4e-13 |
  | 9 | 2e-16 |

  From frame 3 on, the open circle sits visually on the axis (see `committed/mullersaa/frame_003.png`). From frame 4 on it is hidden under the red p₂ dot. Frames 5–9 are visually indistinguishable.
- **What is true:** the parabola stays strictly above the axis at every step. Its discriminant is negative in all 9 frames, the leading coefficient is positive, and the vertex height is positive. A viewer cannot see this after frame 2. Frames 3–9 look like parabolas touching or crossing the axis, which is the opposite of what the text says.
- **Suggested correction:** zoom per frame around the current triple, for example x in [min(q)−δ, max(q)+δ] with a y-range scaled to max |f(q)|. Alternatively add a zoomed inset, or annotate the vertex height in the legend (e.g. "vertex height = 2.2e-3"). The number of frames could also be cut to the ones where the geometry is visible.

- **Independent check:** not run (Minor finding, unverified)

### F2: Fidelity. **Minor.** Case 1 reuses Mathews' Example 1 but replaces his complex-case rule without saying so.

- **Location:** `index.qmd`, Case 1 Behavior: "This animation takes the real part of that complex root instead, which is the parabola's vertex … The iterates 1.2873, 1.1581, 1.0552, 1.0100, 1.0017, … decrease to p = 1". Also `mullersaa.jl` lines 36–40.
- **What is there now:** the same function (x³ − 3x + 2) and the same starting triple (2.2, 2.1, 2.0) as Mathews' Example 1 (archive `ex1.png`: "Muller[2.2, 2.1, 2.0, 10]"). The page handles the complex case with a "real part / vertex" rule, giving a monotone sequence 1.2873, 1.1581, ….
- **What the source does:** Mathews' subroutine (`MullersMethodMod_gr_5.gif`) has two differences.
  - It sets `disc = 0` when b² < 4ac. The step is then Z = −2c/b, not the vertex −b/(2a).
  - It keeps the two old points nearest p₃ rather than dropping the oldest.

  His printed iterates are p₃..p₁₀ = 1.1091314031180390, 1.4944130474051970, 1.0557604296857690, 0.9964676201032940, 0.9981213458431420, 1.0000166310225440, 0.9999987979593480, 1.0000000056524160. They are non-monotone, overshoot below 1, and jump back up to 1.494.
- **How I know:** `python3 -I review/mathews_muller.py` reproduces Mathews' printed column (1.1091314031180384, 1.4944130474051827, 1.0557604296857677, 0.9964676201032902, …). That confirms the transcription. Under the same transcription, Cases 2 and 3 give exactly the script's sequences, so only Case 1 departs.
- **Why it matters:** the page's variant is legitimate, and the page says plainly that it uses the real part. But a reader who compares with the source (the page cites `@mathewsSite`) will find different iterates and different qualitative behaviour (monotone versus oscillating) for the same example, with no explanation.
- **Suggested correction:** add one sentence to Case 1. For example: "Mathews' own program handles the complex case differently (it drops the square root, giving p₃ = p₂ − 2f(p₂)/b) and its iterates 1.1091, 1.4944, 1.0558, 0.9965, … oscillate around 1." Alternatively, animate Mathews' rule.

No Error-level findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `mullersaa.jl` | 0 | 7.0 | mullersaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullersbb.jl` | 0 | 6.5 | mullersbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullerscc.jl` | 0 | 6.6 | mullerscc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `mullersaa.gif` | 9 | byte-identical | mullersaa |
| `mullersbb.gif` | 9 | byte-identical | mullersbb |
| `mullerscc.gif` | 9 | byte-identical | mullerscc |

### Page references

- Scripts linked: `mullersaa.jl`, `mullersbb.jl`, `mullerscc.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (quoted or paraphrased closely) | Evidence | Verdict |
|---|---|---|---|
| I1 | "fitting a parabola through three successive approximations" | `lagrange_parabola` reproduces f at all three nodes (node error 0.0 every frame); `muller_step` uses the same three points | confirmed |
| I2 | "The parabola (dashed blue) passes through the current triple (p₀,p₁,p₂)" | steelblue `ls=:dash`; node error 0.0; frames show the curve through the three dots | confirmed |
| I3 | "the next iterate is found where the parabola crosses the x-axis" (Cases 2, 3) | P(q3) ≈ 1e-16 or smaller in every frame (`*_chk.jl`); root nearest p₂ chosen; matches mpmath | confirmed |
| I4 | "(in Case 1 the parabola never reaches the axis; see that case)" | disc < 0 and a > 0 in all 9 frames (Julia and mpmath) | confirmed |
| I5 | "Each frame advances one iteration: the oldest point is dropped, and the new root estimate becomes p₂ (red dot)" | `history[i+1] = (q1, q2, q3)`; red marker at q2; legend shows p₂ | confirmed |
| I6 | "The gray dots are p₀ and p₁" | `scatter!([q0,q1] …; color=:gray)` | confirmed |
| I7 | "Julia source scripts … are linked under each case" | three links, each to the matching script; manifest wiring check | confirmed |
| C1-h | Case 1 heading: "Convergent, f(x) = x³ − 3x + 2, double root at p = 1" | script line 15; (x−1)²(x+2) expands to x³−3x+2; iterates → 1.00000003 | confirmed |
| C1-a | "f(x) = (x−1)²(x+2)" | hand expansion | confirmed |
| C1-b | "starting from p₂ = 2.0" | `p_init = [2.2, 2.1, 2.0]` | confirmed |
| C1-c | "None of the parabolas reaches the x-axis: at every step its roots are complex" | disc = −20.16, −3.909, −0.5667, −0.0302, −1.0e-3, −1.1e-5, −2.2e-8, −6.5e-12, −2.5e-15 (Julia); mpmath gives the same signs, and stays negative in a long run to error 1e-80 | confirmed (numerically). Not visible in frames 3–9, see F1 |
| C1-d | "the first would be p₃ ≈ 1.2873 + 0.3563i" | mpmath: 1.287301587 ± 0.3563447873i | confirmed |
| C1-e | "takes the real part of that complex root instead, which is the parabola's vertex" | Re[p₂ − 2f₂/(b ± i√(−disc))] = p₂ − 2f₂b/(b² − disc) = p₂ − b/(2d), which is line 39 | confirmed |
| C1-f | "(open red circle)" | white fill, red stroke marker at (q3, P(q3)); P(q3) = 0.800 in frame 1, matching the frame | confirmed |
| C1-g | "The iterates 1.2873, 1.1581, 1.0552, 1.0100, 1.0017, …" | script 1.2873016, 1.1580878, 1.0552042, 1.0099992, 1.0016846; mpmath identical | confirmed |
| C1-i | "decrease to p = 1" | all 8 iterates strictly decreasing, last 1.0000000312 | confirmed |
| C1-j | "superlinearly (order ≈ 1.32 asymptotically for this real-part variant)" | mpmath long run: local order estimates → 1.329, 1.315, 1.333, 1.321, 1.325, 1.326. Asymptotic analysis: vertex error ≈ e_{n−2}e_{n−1}/6, so p³ = p + 1, p = 1.3247. Late iterates check out: e₈ = 3.0e-6 vs e₅e₆/6 = 2.8e-6 | confirmed |
| C1-k | "faster than Newton's method, which converges only linearly at a double root" | standard (Newton error ratio → 1/2 at a double root) | confirmed |
| C1-alt | Alt text: parabolas never reach the axis, each new iterate is the vertex, converge to 1 | as C1-c, C1-e, C1-i | confirmed |
| C1-link | `mullersaa.jl` / `mullersaa.gif` | manifest: byte-identical regeneration; title in GIF "f(x) = x³ − 3x + 2" | confirmed |
| C2-h | Case 2 heading: "Convergent, f(x) = sin(x²−2)(x²−2), double root at p = √2" | script line 11; with u = x²−2, f = u sin u ≈ u² ≈ 8(x−√2)², so a double root; iterates → 1.41417 | confirmed |
| C2-a | "converges to the double root p = √2 ≈ 1.4142" | √2 = 1.414214; p₁₀ = 1.4141744 (error 3.9e-5); continued mpmath run converges | confirmed |
| C2-b | "starting from p₂ = 1.0" | `p_init = [0.8, 0.9, 1.0]` | confirmed |
| C2-c | "double root where x²−2 = 0 since both factors vanish simultaneously" | sin(0)·0 | confirmed |
| C2-d | "Muller's method locates it efficiently despite the flat tangent at the root" | Converges superlinearly: asymptotic order 1.234 from the mpmath run. After 8 steps the error is 3.9e-5, while Mathews' Newton 8th iterate error is 7.7e-4 (archive `ex2.png`). The claim is vague but not contradicted | confirmed (qualitative) |
| C2-alt | Alt text: converging to √2 from p₂ = 1.0 | as above | confirmed |
| C2-link | `mullersbb.jl` / `mullersbb.gif` | manifest byte-identical; GIF title matches f | confirmed |
| C3-h | Case 3 heading: "Convergent, f(x) = x⁶−7x⁴+15x²−9, double root at p = √3" | script line 12; (x²−1)(x²−3)² = x⁶−7x⁴+15x²−9 (hand expansion); iterates → 1.73199 | confirmed |
| C3-a | "factors as (x²−1)(x²−3)²" | hand expansion | confirmed |
| C3-b | "p = √3 ≈ 1.7321" | 1.7320508 | confirmed |
| C3-c | "Starting from p₂ = 1.5" | `p_init = [1.3, 1.4, 1.5]` | confirmed |
| C3-d | "Muller's method converges to the double root" | p₁₀ = 1.7319878 (error 6.3e-5); mpmath continues to 1e-80 | confirmed |
| C3-e | "Newton's method would converge linearly here" | double root | confirmed |
| C3-f | "converges superlinearly, with order ≈ 1.23 at this double root" | mpmath long run: local order → 1.229, 1.230, 1.233, 1.234, 1.234 … (also 1.234 for Case 2). The real root of 2p³ − p² − p − 1 = 0 is 1.2338 | confirmed |
| C3-g | "(below the ≈ 1.84 it achieves at a simple root)" | standard: the root of p³ = p² + p + 1 is 1.8393 | confirmed |
| C3-alt | Alt text: converging to √3 from p₂ = 1.5 | as above | confirmed |
| C3-link | `mullerscc.jl` / `mullerscc.gif` | manifest byte-identical; GIF title matches f | confirmed |
| CNT | (implicit) 8 iterations, 9 frames per GIF | `n_iters = 8`; 9 frames each; the page states no count | n/a (no claim) |

Archive-based fidelity entries:

| # | Item | Verdict |
|---|---|---|
| A1 | Example 1: f = x³−3x+2, root 1, Muller start 2.2, 2.1, 2.0 | Page matches function and start. Complex-case rule differs: **F2** |
| A2 | Example 2: f = sin(x²−2)(x²−2), root √2, start 0.8, 0.9, 1.0 | Matches; the script's iterates equal Mathews' printed p₃..p₁₀ to all 16 printed digits |
| A3 | Example 3: f = x⁶−7x⁴+15x²−9, "multiple root near x = 2", starting value 1.5 | Function and p₂ = 1.5 match. The page correctly gives the root as √3 ≈ 1.7321, not "near 2". Mathews' Muller triple could not be determined because the output images gr_145 and later are absent from the archive; p₀ = 1.3, p₁ = 1.4 are unverified against the source |
| A4 | All three examples present | Yes, no case dropped |

---

### 3. Implementation checks

### Common `muller_step` (all three scripts)

- **Formulation:** d = f[p₀,p₁,p₂] and b = f[p₁,p₂] + (p₂−p₁)·f[p₀,p₁,p₂], so P(x) = f₂ + b(x−p₂) + d(x−p₂)². This is the Newton-form parabola. The step is p₂ − 2f₂/E, where E is whichever of b ± √disc has the larger modulus, so the root nearest p₂ is chosen. This is standard Muller (Burden–Faires / Mathews form).
- **Independent check:** I fit a·x² + b·x + c by solving the 3×3 Vandermonde system in mpmath at 400 digits. I solved it with the complex quadratic formula and chose the root nearest p₂.
- **Plotting helper:** `lagrange_parabola` is an independent construction of the same quadratic. Its node error is exactly 0.0 at all nodes in every frame.

### `mullersaa.jl` (Case 1)

- **Method:** Muller with a disclosed variant. When disc < 0 it takes the real part of the complex Muller root, which is the parabola's vertex. disc < 0 in every frame, so every step uses the variant. The page discloses this. Mathews' source uses a different variant (disc → 0); see F2.
- **Numbers (script vs mpmath, same variant):**

  | Step | Script | mpmath |
  |---|---|---|
  | p₃ | 1.2873015873016 | 1.2873015873015873 |
  | p₄ | 1.158087802003537 | 1.1580878020035357 |
  | p₅ | 1.0552041927906899 | 1.055204192790688 |
  | p₆ | 1.0099991953537275 | 1.0099991953537275 |
  | p₇ | 1.0016845914908628 | 1.0016845914908629 |
  | p₈ | 1.000107900677376 | 1.00010790067738 |
  | p₉ | 1.0000030057271563 | 1.0000030057271222 |
  | p₁₀ | 1.0000000311735213 | 1.0000000311740599 |

  The last-digit differences come from Float64 cancellation in f near the double root. The 5-digit legend labels are unaffected.

  Discriminants match in sign and magnitude (e.g. −20.1596, −3.90889, −0.566726). The true complex Muller p₃ is 1.287301587 ± 0.356344787i. Full complex-arithmetic Muller also converges to 1 via complex iterates (23 steps to |f| < 1e-150). That run is not shown on the page.
- **Reference values:** the root p = 1 is exact, from the factorization.
- **Picture:** the title function matches the code. The red dot is at (p₂, f(p₂)) and the gray dots at p₀, p₁. The open circle is at (vertex x, P(vertex)), with P = 0.800 in frame 1, matching the image. Legend labels are correct; "p₂ = 1.0" in frames 8–9 is round(1.000003…, 5).
  - `clamp.` on the parabola (line 86) only flattens the part above y = 7 in frame 1, along the top border. It is invisible and harmless.
  - The fixed window hides the geometry from frame 3 on: **F1**.

### `mullersbb.jl` (Case 2)

- **Method:** standard real Muller. disc > 0 in every frame: Julia did not hit the `error` branch for any of the 9 frames, and mpmath gives discriminants 14.39, 6.729, 1.459, 0.158, 0.0157, 9.1e-4, 2.9e-5, 4.7e-7, 3.1e-9.
- **Numbers (script = mpmath = Mathews' printed table, all digits shown):**
  - p₃ = 1.2543159902744359
  - p₄ = 1.3222993665586782
  - p₅ = 1.3688966241528713
  - p₆ = 1.3970591565574766
  - p₇ = 1.408412963976924
  - p₈ = 1.4126956654374672
  - p₉ = 1.4139236819552305
  - p₁₀ = 1.4141744432077474

  P(p_next) is at most 7e-17 in every frame.
- **Reference:** √2 is exact; f(√2) = sin(0)·0 = 0. The double root was confirmed by expansion.
- **Picture:** f, the parabola, and the points are drawn from the right quantities. The parabola's axis crossing coincides with the next frame's red dot (frames 1–4 inspected). The title matches the code. The window (−1.5..2.5, −0.2..2.2) shows the root and the whole approach.

### `mullerscc.jl` (Case 3)

- **Method:** standard real Muller. disc > 0 in all frames (mpmath: 45.12, 19.97, 4.894, 0.753, 0.0967, 8.0e-3, 4.1e-4, 1.2e-5, 1.7e-7).
- **Numbers (script vs mpmath):**

  | Step | Script | mpmath |
  |---|---|---|
  | p₃ | 1.627646913608958 | 1.6276469136089565 |
  | p₄ | 1.6742682889831824 | 1.6742682889831808 |
  | p₅ | 1.7034875047036455 | 1.7034875047036412 |
  | p₆ | 1.7200472229337476 | 1.7200472229337408 |
  | p₇ | 1.72750110119843 | 1.7275011011984546 |
  | p₈ | 1.7306305638858632 | 1.7306305638856946 |
  | p₉ | 1.7317042934610234 | 1.7317042934613555 |
  | p₁₀ | 1.7319877986383865 | 1.7319877986375479 |

  The agreement is within Float64 cancellation error near the double root. Mathews' algorithm (transcribed) gives the same sequence.
- **Reference:** √3 is exact from the factorization (x²−1)(x²−3)².
- **Picture:** the parabola crosses the axis at the next red dot. P(q3) is at most 4e-16, and the crossing is visible inside the window (−0.5..1.5) in frames 1–4. The title matches the code. The clipping is only at the axis limits and changes no conclusion.

### Order-of-convergence evidence (mpmath, 400 digits, iterated to error < 1e-80)

| Case | Local order estimates (last several) | Page claim |
|---|---|---|
| 1 (vertex variant) | 1.338, 1.329, 1.315, 1.333, 1.321, 1.325, 1.326 | ≈ 1.32 ✓ |
| 2 (standard) | … 1.233, 1.234, 1.234, 1.234 | none stated |
| 3 (standard) | … 1.233, 1.234, 1.234, 1.234 | ≈ 1.23 ✓ |

