# Muller's Method — animation review (round 3)

Page: `pages/numerical-methods/mullers-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1: Implementation (picture). Minor. In Case 1, the feature the page describes can't be seen after frame 2

- **Location:** `mullersaa.jl` lines 19–20 (`xlims = (-2.5, 2.5)`, `ylims = (-8.0, 7.0)`) and `mullersaa.gif` frames 3–9. The related page text is in `index.qmd` line 18: "None of the parabolas reaches the x-axis: at every step its roots are complex … the parabola's vertex (open red circle)".
- **What is there now:** the window is fixed and spans 15 units of f on about 400 px, which is about 27 px per unit. The height of the vertex above the axis is −disc/(4A). It shrinks quickly:

  | frame | vertex x | vertex height | ≈ pixels |
  |---|---|---|---|
  | 1 | 1.2873016 | 0.8 | 21.6 |
  | 2 | 1.1580878 | 0.181 | 4.9 |
  | 3 | 1.0552042 | 0.0319 | 0.86 |
  | 4 | 1.0099992 | 0.00216 | 0.06 |
  | 5–9 | → 1 | ≤ 8e-5 | ≪ 1 |

  From frame 3 the dashed parabola looks as if it touches or crosses the axis. From about frame 5 the three dots and the open vertex circle all sit on one spot at (1, 0); the contact sheet `committed/mullersaa/sheet.png` shows this. So for 7 of the 9 frames, a viewer can't see the behaviour the Case 1 text is about: the parabola stays above the axis and the next iterate is its vertex.
- **What is true instead:** the parabola stays strictly above the axis at every step. My computation gives disc < 0 for all 9 frames, and for 26 steps at 3000 digits. That fact is only visible in frames 1–2.
- **How I know:** I ran `python3 -I review/vertex_height.py` to get the heights above. `julia review/chk_aa.jl` gave P(next) = 0.79998, 0.18139, 0.031872, 0.0021573, 7.8e-5, 8.9e-7, … with P′(next) ≈ 0, which confirms that the marker sits at the vertex and that the vertex is above the axis. I also viewed `committed/mullersaa/frame_001.png` (clear gap) and `frame_004.png` (no visible gap, points overlapping).
- **Suggested correction:** zoom the window around the current triple each frame, or add an inset around (1, 0). Either would keep the vertex-above-axis gap visible. A simpler alternative is to say on the page that the gap stops being visible after the second frame.

- **Independent check:** not run (Minor finding, unverified)

### F2: Fidelity. Minor. Case 1 handles complex roots with a different rule from Mathews' Example 1, and the page doesn't say so

- **Location:** `index.qmd` line 18 ("This animation takes the real part of that complex root instead … The iterates 1.2873, 1.1581, 1.0552, 1.0100, 1.0017, …") and `mullersaa.jl` lines 36–40.
- **What is there now:** when the discriminant is negative, the page and script take the real part of the complex Muller root, which is the parabola's vertex p₂ − b/(2a). They also always drop the oldest point. The resulting sequence decreases monotonically: 1.2873, 1.1581, 1.0552, 1.0100, 1.0017, 1.000108, 1.000003, …
- **What the archive does:** Mathews' `Muller` subroutine (archive image `MullersMethodMod_gr_5.gif`) has three differences:
  - It sets the square root to 0 when b² ≤ 4ac (`If[b b > 4 a c, disc = Sqrt[b b - 4 a c], disc = 0]`), so p₃ = p₂ − 2c/b.
  - It gives the root the sign of b.
  - It keeps the two old points closest to p₃ instead of dropping the oldest.

  His Example 1, from the same triple (2.2, 2.1, 2.0), prints p₃…p₁₀ = 1.1091314031180390, 1.4944130474051970, 1.0557604296857690, 0.9964676201032940, 0.9981213458431420, 1.0000166310225440, 0.9999987979593480, 1.0000000056524160 (archive images gr_43–50). That sequence is not monotone: it jumps back to 1.49 and overshoots below 1. The page's sequence matches neither these values nor that behaviour. The page cites Mathews as its source, and a reader comparing the two sees different numbers with no explanation.
- **How I know:** I transcribed Mathews' routine into `review/mathews_variant.py` and ran it with `python3 -I review/mathews_variant.py`. For `aa` it reproduces his printed values: 1.10913140311804, 1.494413047405228, 1.055760429685773, 0.996467620103292, 0.9981213458431432, 1.000016631022563, 0.9999987979646118, 1.000000005606389. For Cases 2 and 3 his routine gives exactly the iterates the scripts produce, so the departure exists only in Case 1.
- **Why this is Minor and not an error:** both rules are ad hoc real-arithmetic substitutes for a complex Muller step. The page's rule is valid, it is disclosed, and the page's numbers are correct for it.
- **Suggested correction:** add one sentence to Case 1, for example: "Mathews' program instead sets the square root to zero when the discriminant is negative (p₃ = p₂ − 2f₂/b) and keeps the two points nearest the new iterate. From the same start it gives the non-monotone sequence 1.1091, 1.4944, 1.0558, 0.9965, 0.9981, …, which also converges to 1." The other option is to switch the script to Mathews' rule and update the iterate list.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Observation, not a finding

`index.qmd` has no `## Description` section. The authoring conventions require one (`animation-page.agent.md` lines 12 and 205). Under the review standard this counts as missing content, not an error, so nothing in a Description could be checked. The page also gives only p₂ for each case. p₀ and p₁ appear only in the scripts: 2.2/2.1, 0.8/0.9 and 1.3/1.4.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `mullersaa.jl` | 0 | 6.6 | mullersaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullersbb.jl` | 0 | 6.6 | mullersbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullerscc.jl` | 0 | 6.3 | mullerscc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|---|
| 1 | Intro | "a parabola through three successive approximations of a root" | Confirmed | All 3 scripts: `lagrange_parabola` through (q0,q1,q2); `chk_*.jl` gives max\|P−f\| at nodes = 0.0 in every frame |
| 2 | Intro | "The parabola (dashed blue) passes through the current triple (p0,p1,p2)" | Confirmed | `ls=:dash`, `color=:steelblue`; frames show it through all 3 dots |
| 3 | Intro | "the next iterate is found where the parabola crosses the x-axis" (Cases 2, 3) | Confirmed | `chk_bb/cc.jl`: P(next) ≈ 0 (≤ 4.4e-16) in every frame |
| 4 | Intro | "in Case 1 the parabola never reaches the axis" | Confirmed | disc < 0 in all 9 Float64 frames (−20.16 … −2.5e-15); also 26 steps at 3000 digits (`order2.py`) |
| 5 | Intro | "the oldest point is dropped, and the new root estimate becomes p2 (red dot)" | Confirmed | `history[i+1] = (q1, q2, q3)`; red marker at q2 |
| 6 | Intro | "The gray dots are p0 and p1" | Confirmed | `scatter!([q0,q1]; color=:gray)`; frames |
| 7 | Intro | "Julia source scripts … linked under each case" | Confirmed | 3 links present, files exist |
| 8 | Case 1 heading | f(x) = x³ − 3x + 2, double root at p = 1 | Confirmed | sympy: (x−1)²(x+2); f(1)=f′(1)=0, f″(1)=6 |
| 9 | Case 1 heading | "Convergent" | Confirmed | p → 1, error 5.5e-11 at p₁₁ |
| 10 | Case 1 | f = (x−1)²(x+2) | Confirmed | sympy factor |
| 11 | Case 1 | "starting from p2 = 2.0" | Confirmed | `p_init = [2.2, 2.1, 2.0]` |
| 12 | Case 1 | "None of the parabolas reaches the x-axis: at every step its roots are complex" | Confirmed (but not visible after frame 2: F1) | discs −20.16, −3.909, −0.5667, −0.03021, −1.007e-3, −1.097e-5, −2.157e-8, −6.5e-12, <0 |
| 13 | Case 1 | "the first would be p3 ≈ 1.2873 + 0.3563i" | Confirmed | `indep.py` quadratic formula: 1.287301587 + 0.3563447873i |
| 14 | Case 1 | "takes the real part of that complex root instead, which is the parabola's vertex" | Confirmed | Algebra: Re[p₂ − 2c/(b ± i√−D)] = p₂ − 2cb/(4ac) = p₂ − b/(2a). Numerically, the real part of the complex root from `indep.py` equals the script's `p2 - b/(2d)` to all printed digits; P′(vertex) ≈ 0 (`chk_aa.jl`) |
| 15 | Case 1 | "(open red circle)" | Confirmed | `color=:white, markerstrokecolor=:red`; legend "vertex = next p₂"; frames 1–4 |
| 16 | Case 1 | iterates "1.2873, 1.1581, 1.0552, 1.0100, 1.0017, …" | Confirmed | Script: 1.2873015873016, 1.158087802003537, 1.0552041927906899, 1.0099991953537275, 1.0016845914908628; mpmath: 1.2873015873, 1.158087802, 1.05520419279, 1.00999919535, 1.00168459149 |
| 17 | Case 1 | "decrease to p = 1" | Confirmed | Strictly decreasing and > 1 through p₁₁ = 1.00000000005 |
| 18 | Case 1 | "superlinearly (order ≈ 1.32 asymptotically for this real-part variant)" | Confirmed | `order2.py` (3000 digits): log e₍k+1₎/log eₖ → 1.3282, 1.3270, …, 1.3251, 1.3250 |
| 19 | Case 1 | "faster than Newton's method, which converges only linearly at a double root" | Confirmed | Newton from 2.0 (`refs.py`): errors 0.556, 0.298, 0.155, … 0.00509, ratio → 1/2 (linear); vertex-Muller error 3.0e-6 after 7 steps |
| 20 | Case 1 alt text | "starting from p₂ = 2.0 … parabolas never reach the x-axis … vertex … converge to the double root at p = 1" | Confirmed | as 11, 12, 14, 17 |
| 21 | Case 1 link/embed | `mullersaa.jl` / `mullersaa.gif` | Confirmed | Script has the heading's f and start; GIF byte-identical to regen |
| 22 | Case 2 heading | f(x) = sin(x² − 2)(x² − 2), double root at p = √2 | Confirmed | sympy: f(√2)=0, f′(√2)=0, f″(√2)=16 |
| 23 | Case 2 heading | "Convergent" | Confirmed | p₁₁ = 1.41421024, error 3.3e-6 |
| 24 | Case 2 | "p = √2 ≈ 1.4142" | Confirmed | 1.41421356 |
| 25 | Case 2 | "starting from p2 = 1.0" | Confirmed | `p_init = [0.8, 0.9, 1.0]` |
| 26 | Case 2 | "double root where x² − 2 = 0 since both factors vanish simultaneously" | Confirmed | sin(u)·u = u² + O(u⁴); f′(√2) = 0, f″ ≠ 0 |
| 27 | Case 2 | "Muller's method locates it efficiently despite the flat tangent at the root" | Confirmed (qualitative) | Iterates 1.25432, 1.32230, 1.36890, 1.39706, 1.40841, 1.41270, 1.41392, 1.41417 (error 3.9e-5 after 8 steps); Newton from 1.0 has error 7.75e-4 after 8 steps (`refs.py`); asymptotic order 1.2338 (`order2.py`) |
| 28 | Case 2 alt text | "converging to the double root at p = sqrt(2) starting from p₂ = 1.0" | Confirmed | as above |
| 29 | Case 2 link/embed | `mullersbb.jl` / `mullersbb.gif` | Confirmed | GIF title "sin(x²-2)·(x²-2)" matches code; byte-identical to regen |
| 30 | Case 3 heading | f(x) = x⁶ − 7x⁴ + 15x² − 9, double root at p = √3 | Confirmed | sympy: f(√3)=f′(√3)=0, f″(√3)=48 |
| 31 | Case 3 heading | "Convergent" | Confirmed | p₁₁ = 1.732043003, error 7.8e-6 |
| 32 | Case 3 | "factors as (x²−1)(x²−3)²" | Confirmed | sympy: (x−1)(x+1)(x²−3)² |
| 33 | Case 3 | "p = √3 ≈ 1.7321" | Confirmed | 1.7320508 |
| 34 | Case 3 | "Starting from p2 = 1.5" | Confirmed | `p_init = [1.3, 1.4, 1.5]` |
| 35 | Case 3 | "Muller's method converges to the double root" | Confirmed | Iterates 1.62765, 1.67427, 1.70349, 1.72005, 1.72750, 1.73063, 1.73170, 1.73199 |
| 36 | Case 3 | "Newton's method would converge linearly here" | Confirmed | Newton from 1.5: errors 0.0535, 0.0249, 0.0121, … ratio → 1/2 |
| 37 | Case 3 | "superlinearly, with order ≈ 1.23 at this double root" | Confirmed | `order2.py`: q → 1.2332 … 1.2337 (Case 2 the same → 1.2338) |
| 38 | Case 3 | "(below the ≈ 1.84 it achieves at a simple root)" | Confirmed | `order_simple.py`, simple root x=1 of the same f: q → 1.8393 |
| 39 | Case 3 alt text | "converging to the double root at p = sqrt(3) starting from p₂ = 1.5" | Confirmed | as above |
| 40 | Case 3 link/embed | `mullerscc.jl` / `mullerscc.gif` | Confirmed | GIF title matches code; byte-identical to regen |
| 41 | GIF legends | "p₂ = value" in each frame | Confirmed | Labels = round(q2, 5): Case 1 2.0, 1.2873, 1.15809, 1.0552, 1.01, 1.00168, 1.00011, 1.0, 1.0. Case 2 1.0 … 1.41417. Case 3 1.5 … 1.73199. All match `inst_*.jl` output |
| 42 | Fidelity: Case 1 | function and triple from Mathews Ex. 1 | Confirmed (rule differs: F2) | gr_7 f = x³−3x+2; gr_39 `Muller[2.2, 2.1, 2.0, 10]` |
| 43 | Fidelity: Case 2 | function and triple from Mathews Ex. 2 | Confirmed | gr_75, gr_108 `Muller[0.8, 0.9, 1.0, 10]`; script iterates equal Mathews' gr_112–119 to 16 digits (1.2543159902744360 … 1.4141744432077470) |
| 44 | Fidelity: Case 3 | function from Mathews Ex. 3 | Confirmed function; starting triple could not be determined | gr_143 f = x⁶−7x⁴+15x²−9; gr_144 Newton p₀ = 1.5. The Muller-triple images (gr_172–174) are absent from the archive |
| 45 | Section index | page linked from `numerical-methods/index.qmd` | Confirmed | line 18 |

---

### 3. Implementation checks

All three scripts use the same `muller_step`. It builds P(x) = f₂ + b(x−p₂) + d(x−p₂)², with d = f[p₀,p₁,p₂] and b = f[p₁,p₂] + h₁·d, which is the Newton form rewritten about p₂. It then takes the root nearest p₂ through the rationalised quadratic formula p₂ − 2f₂/(b ± √disc), choosing the larger-magnitude denominator. This is the standard real Muller step. `bb` and `cc` raise an error if disc < 0; that never fires. `aa` substitutes the vertex when disc < 0. The plotted parabola is built separately in Lagrange form and agrees with the step's parabola: it interpolates the three nodes exactly, P(next) ≈ 0 for `bb`/`cc`, and P′(next) ≈ 0 for `aa`.

My independent computation (`indep.py`, mpmath at 60 digits) builds the parabola by solving a 3×3 Vandermonde system in t = x − p₂. It takes the root of the complex quadratic formula nearest p₂, and in Case 1 its real part.

### `mullersaa.jl`
- **Method:** Muller's method with a real-part (vertex) substitution whenever the root would be complex. This is a named variant, and the page and script comment both describe it correctly. It differs from Mathews' rule (F2).
- **Numbers:**

  | k | script | independent |
  |---|---|---|
  | p₃ | 1.2873015873016 | 1.2873015873 |
  | p₄ | 1.158087802003537 | 1.158087802 |
  | p₅ | 1.0552041927906899 | 1.05520419279 |
  | p₆ | 1.0099991953537275 | 1.00999919535 |
  | p₇ | 1.0016845914908628 | 1.00168459149 |
  | p₈ | 1.000107900677376 | 1.00010790068 |
  | p₉ | 1.0000030057271563 | 1.00000300573 |
  | p₁₀ | 1.0000000311735213 | 1.00000003117 |
  | p₁₁ (frame-9 parabola only) | 1.0000000000789 | 1.00000000005 |

  The p₁₁ difference is Float64 cancellation near a double root, where attainable accuracy is about √eps. p₁₁ is not displayed. Its disc is −2.5e-15 in Float64 against −1.2e-16 exact, and the sign agrees.
- **Reference values:** the root 1 is exact, double (sympy). Asymptotic order of this variant ≈ 1.325 (3000-digit run).
- **Picture:** the parabola passes through the three dots. The open red circle is at (vertex, P(vertex)) with P′ ≈ 0 and P > 0. The legend reads "parabola (no real root)" in every frame, which is correct because disc < 0 in all frames. The title's function matches the code. Clamping the parabola to `ylims` only affects the part above y = 7 near x = 2.5 in frame 1, where it runs along the top border, so it does not mislead. The window problem is F1.

### `mullersbb.jl`
- **Method:** standard real Muller; disc > 0 in all 9 steps (14.39, 6.729, 1.459, 0.158, 0.0157, 9.07e-4, 2.86e-5, 4.69e-7, 3.13e-9).
- **Numbers:** the script and the independent computation agree to all digits shown: 1.2543159902744359 / 1.25431599027; 1.3222993665586782 / 1.32229936656; 1.3688966241528713 / 1.36889662415; 1.3970591565574766 / 1.39705915656; 1.408412963976924 / 1.40841296398; 1.4126956654374672 / 1.41269566544; 1.4139236819552305 / 1.41392368196; 1.4141744432077474 / 1.41417444321. Mathews' archive also matches to 16 digits.
- **Reference values:** √2, double root (sympy f′ = 0, f″ = 16). Order ≈ 1.2338.
- **Picture:** the parabola goes through the dots and crosses the axis at the next iterate. Labels are correct and the title matches the code. The window (−1.5, 2.5) × (−0.2, 2.2) also shows the double root at −√2 and the steep simple root at √(2+π) ≈ 2.27. The latter leaves through the bottom edge, which is harmless. Late frames collapse onto √2, which is normal for convergence.

### `mullerscc.jl`
- **Method:** standard real Muller; disc > 0 in all steps (45.12, 19.97, 4.894, 0.753, 0.0967, 8.03e-3, 4.09e-4, 1.19e-5, 1.65e-7).
- **Numbers:** the script and the independent computation agree: 1.627646913608958 / 1.62764691361; 1.6742682889831824 / 1.67426828898; 1.7034875047036455 / 1.7034875047; 1.7200472229337476 / 1.72004722293; 1.72750110119843 / 1.7275011012; 1.7306305638858632 / 1.73063056389; 1.7317042934610234 / 1.73170429346; 1.7319877986383865 / 1.73198779864. Mathews' routine from the same triple gives identical values.
- **Reference values:** √3 double root; factorisation (x−1)(x+1)(x²−3)² verified with sympy. Order at the double root ≈ 1.2337; at the simple root x = 1 it is ≈ 1.8393.
- **Picture:** the parabola goes through the dots and crosses the axis at the next iterate. In frames 3–4 the second real root of the parabola is also visible near x ≈ 1.9, which is correct and not misleading. Labels are correct and the title matches the code. The axes clip f and the parabola, as the comment says, which is harmless.

### What could not be determined
- Mathews' Muller starting triple and printed iterates for Example 3, because those archive images are missing.

