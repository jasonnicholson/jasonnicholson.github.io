# Muller's Method — animation review (round 5)

Page: `pages/numerical-methods/mullers-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Implementation (picture): Minor. Case 2's later frames show no visible parabola or step

- **Location:** `mullersbb.jl` lines 15–16 (`xlims = (-1.5, 2.5)`, `ylims = (-0.2, 2.2)`), which fix the window for all 9 frames. Committed frames `mullersbb/frame_005.png` to `frame_009.png`.
- **What is there now:** The window is fixed at 4 × 2.4 units. From frame 5 on, the three points lie within 0.04 of √2 (frame 5: 1.3223, 1.3689, 1.3971; frame 9: 1.41270, 1.41392, 1.41417). Their f-values are at most 0.016. In `frame_006.png` the dashed parabola lies under the magenta f curve, the gray and red dots overlap, and the axis crossing that gives the next iterate cannot be seen. From frame 6 to frame 9 the only visible change is the legend's p₂ value.
- **Why it matters:** The introduction says each frame shows the parabola through the triple and the next iterate "where the parabola crosses the x-axis". For about half of Case 2 that mechanism is not visible. The page's claim that the method converges is still correct, because the legend values approach 1.41421, so this is low-consequence.
- **Evidence:** `julia inst_bb.jl` gives the triples above. Visual check of `committed/mullersbb/sheet.png` and `frame_006.png`.
- **Suggested correction:** Zoom each frame to the current points, as `mullersaa.jl` already does: x-limits from min/max of (q0, q1, q2, q3) with a margin, y-limits from max |f(q)|. Alternatively, add an inset around the current triple.

No other findings. Every numerical, behavioural and wiring claim on the page checked out against independent computation (see the ledger).

Not counted as a finding: the page has no `## Description` section, although the authoring conventions (`.github/agents/animation-page.agent.md` line 12) require one. Under the review standard, content the page does not yet have is not a finding. I mention it only because, as a result, there is no Description text whose formulas could be checked.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `mullersaa.jl` | 0 | 10.1 | mullersaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullersbb.jl` | 0 | 6.8 | mullersbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `mullerscc.jl` | 0 | 6.9 | mullerscc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `mullersaa.gif` | 8 | byte-identical | mullersaa |
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

| # | Location | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|---|
| 1 | Intro | "fitting a parabola through three successive approximations" | Confirmed | All scripts build `lagrange_parabola` through (q0, q1, q2) and iterate on the latest triple. |
| 2 | Intro | "The parabola (dashed blue) passes through the current triple" | Confirmed | `color=:steelblue, ls=:dash`. In the frames the dashed curve passes through all three dots. |
| 3 | Intro | "the next iterate is found where the parabola crosses the x-axis (in Case 1 the parabola never reaches the axis; see that case)" | Confirmed | `muller_step` returns p2 − 2f2/E, the root of P nearest p2. In Cases 2 and 3 disc > 0 at all 9 steps (`indep.out`). In Case 1 disc < 0. |
| 4 | Intro | "the oldest point is dropped, and the new root estimate becomes p₂ (red dot)" | Confirmed | `history[i+1] = (q1, q2, q3)`. Red `scatter!` at q2. |
| 5 | Intro | "The gray dots are p₀ and p₁" | Confirmed | `scatter!([q0,q1]; color=:gray)`. |
| 6 | Intro | Source scripts linked under each case | Confirmed | Three links, one per case, to existing files. |
| 7 | Case 1 heading | f(x)=x³−3x+2, double root at p=1 | Confirmed | sympy: `(x - 1)**2*(x + 2)`. Script line 21 uses the same f. |
| 8 | Case 1 heading | "Convergent" | Confirmed (for the variant used) | Vertex iterates go 1.2873 → 1.00000003 in the animation. At high precision the errors keep shrinking (order ≈1.3247). |
| 9 | Case 1 | f = (x−1)²(x+2) | Confirmed | sympy factor. |
| 10 | Case 1 | "starting from p₂ = 2.0" | Confirmed | `p_init = [2.2, 2.1, 2.0]`. Frame 1 legend shows "p₂ = 2". |
| 11 | Case 1 | "None of the parabolas reaches the x-axis: at every step its roots are complex" | Confirmed | disc = −20.16, −3.909, −0.5667, −3.02e-2, −1.007e-3, −1.097e-5, −2.157e-8, −6.52e-12 in frames 1–8 (script and mpmath agree). At high precision disc stays negative through at least step 28. |
| 12 | Case 1 | "the first would be p₃ ≈ 1.2873 + 0.3563i" | Confirmed | mpmath complex Muller: 1.287301587 + 0.3563447873i. |
| 13 | Case 1 | "takes the real part of that complex root instead, which is the parabola's vertex" | Confirmed | Algebra: Re[p2 − 2f2/(b ± i√−disc)] = p2 − 2f2·b/(4f2·d) = p2 − b/(2d). Numerically, Re(complex Muller) equals the vertex to 16 digits at all 9 steps checked (`indep.out`). |
| 14 | Case 1 | vertex shown as "open red circle" | Confirmed | `color=:white, markerstrokecolor=:red`. Visible in all frames. |
| 15 | Case 1 | "Each frame is zoomed to the current points" | Confirmed | x-limits come from min/max of q0..q3 (lines 78–82). The frames show axes shrinking from [1.2, 2.27] to [0.9998, 1.0018]. |
| 16 | Case 1 | "the inset magnifies the vertex" | Confirmed | Inset centred on q3 with half-width 1.4√(2h/a), y in [−0.8h, 3h]. The vertex circle is visible in every frame. |
| 17 | Case 1 | vertex height "falls from 0.80 to 5.4×10⁻¹³ over the eight frames" | Confirmed | Script: 7.999841e-01 … 5.431920e-13. mpmath: 0.799984 … 5.43429e-13. There are 8 frames. |
| 18 | Case 1 | "The iterates 1.2873, 1.1581, 1.0552, 1.0100, 1.0017, … decrease to p = 1" | Confirmed | mpmath: 1.287301587, 1.158087802, 1.055204193, 1.009999195, 1.001684591, 1.000107901, 1.000003006, 1.000000031. Monotone decreasing, all > 1. |
| 19 | Case 1 | "superlinearly (order ≈ 1.32 asymptotically for this real-part variant)" | Confirmed | Successive-ratio order estimates at 3000 digits: 1.3244, 1.3246, 1.3249, 1.3245, 1.3248, 1.3247. The real root of t³ = t + 1 is 1.324718, the known order of successive parabolic interpolation, which this variant is. |
| 20 | Case 1 | "faster than Newton's method, which converges only linearly at a double root" | Confirmed | Newton from 2.0: error ratios 0.536 → 0.500 (linear, factor ½). After 7 steps Newton's error is 1.0e-2, against 3.0e-6 for the vertex variant. |
| 21 | Case 1 | Mathews' program "drops the square root, so the step is p₃ = p₂ − 2f(p₂)/b, where b is the parabola's slope at p₂" | Confirmed | `gr_5`: `If[b b > 4 a c, disc = √(b b − 4ac), disc = 0]; Z = −2c/(b+disc)` with P = a(x−p2)² + b(x−p2) + c, so b = P′(p2). Note: Mathews' program also keeps the two points nearest p3 rather than dropping the oldest. This changes the iterates from p₇ on (Mathews 0.99812, drop-oldest 0.99725), but the page quotes only p₃–p₆, and those agree. |
| 22 | Case 1 | Mathews' iterates "1.1091, 1.4944, 1.0558, 0.9965, …" | Confirmed | Archive `gr_38..`: 1.1091314, 1.4944130, 1.0557604, 0.9964676. My transcription of Mathews' program gives the same values. |
| 23 | Case 1 | they "rise to 1.4944, drop below 1, and then approach 1 from both sides" | Confirmed | Archive/transcription: 0.99647, 0.99812, 1.0000166, 0.9999988, 1.0000000057. |
| 24 | Case 1 | Link `mullersaa.jl` and embed `mullersaa.gif` are this case | Confirmed | Script f, starting values and output name match. GIF byte-identical to regeneration. |
| 25 | Case 1 alt | "parabolas never reach the x-axis … each new iterate is the parabola's vertex … converge to the double root … zoomed … inset magnifies the vertex just above the x-axis" | Confirmed | As in rows 11, 13, 15, 16 and 18. |
| 26 | Case 2 heading | f(x) = sin(x²−2)(x²−2), double root at p = √2 | Confirmed | Taylor at √2: f = 0, f′ = 0, f″/2 = 8, so multiplicity 2. Script line 11 uses the same f. |
| 27 | Case 2 | "converges to the double root p = √2 ≈ 1.4142" | Confirmed | Iterates 1.25432, 1.32230, 1.36890, 1.39706, 1.40841, 1.41270, 1.41392, 1.41417 (last shown p₂, error 3.9e-5), then 1.414210 (error 3.3e-6). Script and mpmath agree to ≤1e-15. They also equal Mathews' archive output p₃–p₁₀ digit for digit. |
| 28 | Case 2 | "starting from p₂ = 1.0" | Confirmed | `p_init = [0.8, 0.9, 1.0]`, the same as the archive. |
| 29 | Case 2 | "double root where x²−2 = 0 since both factors vanish simultaneously" | Confirmed | sin(u)·u ~ u² as u → 0. See row 26. |
| 30 | Case 2 | "locates it efficiently despite the flat tangent at the root" | Confirmed (qualitative) | f′(√2) = 0. Order estimates converge to 1.2338, which is superlinear. After 8 steps Muller's error is 3.9e-5, against 7.75e-4 for Newton from 1.0. |
| 31 | Case 2 | Link and embed are this case | Confirmed | `mullersbb.jl`/`.gif`. Byte-identical regeneration. |
| 32 | Case 2 alt | "converging to the double root at p = sqrt(2) starting from p₂ = 1.0" | Confirmed | Rows 27–28. Readability caveat in F1. |
| 33 | Case 3 heading | f(x) = x⁶−7x⁴+15x²−9, double root at p = √3 | Confirmed | sympy: `(x - 1)*(x + 1)*(x**2 - 3)**2`. Taylor at √3: f = f′ = 0, f″/2 = 24. |
| 34 | Case 3 | "factors as (x²−1)(x²−3)²" | Confirmed | sympy. |
| 35 | Case 3 | "√3 ≈ 1.7321" | Confirmed | 1.7320508. |
| 36 | Case 3 | "Starting from p₂ = 1.5, Muller's method converges to the double root" | Confirmed | `p_init = [1.3, 1.4, 1.5]`. Iterates 1.62765, 1.67427, 1.70349, 1.72005, 1.72750, 1.73063, 1.73170, 1.73199, then 1.732043. Error 7.8e-6 after 9 steps, still decreasing. |
| 37 | Case 3 | "Newton's method would converge linearly here" | Confirmed | Newton from 1.5: error ratios 0.465 → 0.500. |
| 38 | Case 3 | "order ≈ 1.23 at this double root" | Confirmed | Order estimates at 3000 digits: 1.2338 (Cases 2 and 3). The real root of 2t³ = t² + t + 1 is 1.2337519. |
| 39 | Case 3 | "below the ≈ 1.84 it achieves at a simple root" | Confirmed | The real root of t³ = t² + t + 1 is 1.8392868. |
| 40 | Case 3 | Link and embed are this case | Confirmed | `mullerscc.jl`/`.gif`. Byte-identical regeneration. |
| 41 | Case 3 alt | "converging to the double root at p = sqrt(3) starting from p₂ = 1.5" | Confirmed | Rows 33 and 36. |
| 42 | Frames | Titles name the function in code | Confirmed | The title strings in aa, bb and cc match each `f(x)` definition. |
| 43 | Frames | Legend p₂ values | Confirmed | aa uses `%.10g` (2, 1.287301587, … 1.000003006). bb and cc use 5-decimal rounding. All match the computed iterates. |

Fidelity to the archive:
- **Example 1:** Same f, the same starting triple (2.2, 2.1, 2.0) and the same multiple root. The page departs from Mathews' iterates because it uses the vertex (the real part of the complex root) where Mathews uses disc := 0. The page states this explicitly and quotes Mathews' sequence correctly, so this is not a finding.
- **Example 2:** Same f and starting triple (0.8, 0.9, 1.0). The script's iterates reproduce Mathews' printed output exactly (p₃ = 1.2543159902744 … p₁₀ = 1.4141744432077).
- **Example 3:** Same f and p₀ = 1.5. The archive's Muller starting triple could not be determined, because its images (`gr_145`+) are missing from the archive copy. The script's (1.3, 1.4, 1.5) is consistent with the pattern of the other examples. The archive says the root is "near x = 2". The page gives √3 ≈ 1.7321, which is correct (f(2) = 3 ≠ 0). All three archive examples are present.

---

### 3. Implementation checks

### `mullersaa.jl` (Case 1)
- **Method:** The script fits a Muller parabola, P(x) = f2 + b(x−p2) + d(x−p2)², by divided differences and keeps the root with the larger |b ± √disc| denominator. When disc < 0 it returns the vertex p2 − b/(2d) instead of a complex root. That branch is taken at every step here, so the animation runs the **real-part / vertex variant of Muller's method**. This is the same as successive parabolic interpolation. The page and the header comment both name the variant explicitly, so this is not a mismatch.
- **Numbers:** The script and independent mpmath (Mathews' a,b,c form, 3000 digits) agree:

  | step | script next iterate | mpmath vertex | script h | mpmath h |
  |---|---|---|---|---|
  | 1 | 1.2873015873016 | 1.287301587301587 | 7.999841e-01 | 0.799984 |
  | 2 | 1.158087802003537 | 1.158087802003536 | 1.813936e-01 | 0.181394 |
  | 4 | 1.009999195353728 | 1.009999195353728 | 2.157309e-03 | 2.15731e-3 |
  | 6 | 1.000107900677376 | 1.00010790067738 | 8.941839e-07 | 8.94184e-7 |
  | 8 | 1.000000031173521 | 1.00000003117406 | 5.431920e-13 | 5.43429e-13 |

  At frame 8, double-precision rounding near the double root causes a 0.04% error in h and a 5e-13 shift in x. Neither is visible.
- **Reference values:** The root p = 1 is exact (sympy factor). The header comment's "8th step … vertex height about 1e-17" is confirmed: the mpmath step-9 height is 1.01e-17, and the script would compute 2.1e-16, which is rounding noise, as the comment says.
- **Picture:** The parabola is drawn through (q0, q1, q2). The open circle is at (q3, P(q3)), the vertex. `a = (P(q3+1)+P(q3−1))/2 − h` is exactly the leading coefficient for a quadratic, and it gives 6.3 at frame 1, matching mpmath. The inset window contains the vertex and f's minimum at x = 1, and in all 8 frames the gap between the vertex circle and the axis is visible. The legend's "vertex = next p₂" and the inset title's "height %.2e" report the right quantities. The title matches f.

### `mullersbb.jl` (Case 2)
- **Method:** Standard Muller (Burden–Faires form), the real root nearest p2, dropping the oldest point. disc > 0 at all 8 computed steps, from 14.39 down to 4.69e-7, so the error branch is never reached.
- **Numbers:** The script's iterates 1.254315990274436, 1.322299366558678, …, 1.414174443207747, 1.414210242525887 equal the mpmath values to all printed digits. They also equal Mathews' archive output. Asymptotic order estimate 1.2338.
- **Reference:** √2 is a double root (Taylor coefficients 0, 0, 8).
- **Picture:** The parabola, the dots and the axis crossing are drawn from the right quantities. The legend p₂ values are correct. The fixed wide window hides the mechanism in frames 5–9 (F1).

### `mullerscc.jl` (Case 3)
- **Method:** The same standard Muller as bb. disc > 0 at all steps (45.1 down to 1.65e-7).
- **Numbers:** The script's iterates 1.627646913608958, 1.674268288983182, …, 1.731987798638386, 1.732043002751156 agree with mpmath to ≤1e-12. That is double-precision noise from cancellation in f near the double root, and invisible at the 5-decimal legend precision. Asymptotic order estimate 1.2338.
- **Reference:** √3 is a double root ((x²−1)(x²−3)², Taylor 0, 0, 24).
- **Picture:** The window [0.9, 2.1] × [−0.5, 1.5] contains the root, all iterates and the parabola crossings. The parabolas pass through the dots. In frames 4–9 the parabola's two real roots are close together near √3, which is correctly shown as a nearly tangent crossing. The title, legend and colours are correct.

