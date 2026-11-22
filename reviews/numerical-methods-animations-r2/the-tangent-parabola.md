# The Tangent Parabola — animation review (round 2)

Page: `pages/numerical-methods/the-tangent-parabola/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Fidelity, Minor: the example function and centre differ from Mathews, and the page gives no reason

- **Location:** `index.qmd`, the Animations intro ("for $f(x) = \cos(x)$ centered at $x_0 = \pi/4$"), the Case 1 heading, and `tangparabaa.jl` lines 10–14 and 33.
- **What is there now:** $f(x)=\cos x$, $x_0=\pi/4$, with $h$ log-spaced over 18 values from 1.0 to 0.01, followed by 5 frames of $T_2$.
- **What the archive has:** the module's running example is $y=\sin(x)$, $x_0=1$. Figures 1–3 show $h=0.1$, $h=0.01$ and $h\to 0$, and Table 1 and Exploration 3 use the same $f$ and $x_0$. I read these from formula images gr_34–gr_41 (rendered in `review/formulas.png`: "y = sin(x) x₀ = 1", "h = 0.1", "h = 0.01", "h → 0") and the graphs gr_33/38/42 (`review/graphs.png`, plotted on $[0,\pi]$ with ticks at $1$ and $\pi/2$).
- **Why it matters:** this is a different example function, chosen without a stated reason. It is mathematically harmless ($\cos$ about $\pi/4$ is essentially $\sin$ about $\pi/4$), but a reader comparing with Mathews' article and Table 1 will not find the same numbers. The project's own conventions file (`.github/agents/animation-page.agent.md`, line 11, "NEVER guess animation parameters…"; line 14, "treat static example solution pages as ground truth for equations and numeric parameters") points to the archive values.
- **Suggested correction:** either change the script to $f=\sin x$, $x_0=1$ (and include $h=0.1$ and $h=0.01$ among the frames, so the Figure 1/2 states appear), or add one sentence to the page saying the example differs from Mathews' $\sin x$ at $x_0=1$, and why.

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: the archive's animated examples (tangent cubic and degree-6 tangent polynomial) are silently dropped

- **Location:** `index.qmd`, the Animations section, which has only Case 1 (the parabola).
- **What the archive has:** under "Various Scenarios and Animations for the Tangent Parabola", the module's only animation sequences are:
  - **Example 4** (`lnk_10`): $f(x)=e^{x/4}\cos x$, $x_0=0$. It shows the secant cubic $P(x,0,h)$ through the forward nodes $0,h,2h,3h$ converging to $T_3(x)=1+\tfrac{x}{4}-\tfrac{15x^2}{32}-\tfrac{47x^3}{384}$, with $h=(0.7)^i$ for $i=1..12$ (12 frames, gr_230–241), on $x\in[-4.7,3.5]$, $y\in[-3,1.2]$. The Mathematica code is in image gr_228; see `review/ex45code.png`, and the frames in `review/ex4frames.png`.
  - **Example 5** (`lnk_11`): the same $f$ and $x_0$, with degree 6 through nodes $0..6h$ and $h=(0.7)^i$, $i=1..12$ (frames gr_259–270), converging to $T_6$.
  - Example 3 (`lnk_9`) is the static cubic comparison.
- **What is there now:** the page has one parabola case, built from the static Figures 1–3 (with a different function, see F1). No case covers the higher-degree "tangent polynomial" sequences, and the page does not say they were omitted.
- **Why it matters:** these are the archive's animated cases for this topic. The conventions file says to treat legacy animation sequences as ground truth for motion and pacing. The omission does not make anything on the page false, so I rate it Minor, but it is the larger of the two fidelity gaps.
- **Suggested correction:** add Case 2 (secant cubic → $T_3$) and Case 3 (degree 6 → $T_6$) for $e^{x/4}\cos x$ at $x_0=0$ with $h=0.7^i$, $i=1..12$, using forward equally spaced nodes as Mathews does. Alternatively, state on the page that only the parabola case is animated.

No Implementation or Page-match findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `tangparabaa.jl` | 0 | 7.0 | tangparabaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `tangparabaa.gif` | 23 | byte-identical | tangparabaa |

### Page references

- Scripts linked: `tangparabaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

Claims are quoted in the page's own words. Evidence comes from `review/inst.out` (the script's own computed values), `review/indep.out` (independent computation) and the committed frames.

| # | Claim (page text) | Evidence | Verdict |
|---|---|---|---|
| 1 | "the **secant parabola** (degree-2 Newton polynomial through $x_0-h$, $x_0$, $x_0+h$)" | Script lines 21–30: Newton divided-difference form on nodes `x0-h, x0, x0+h`. Interpolation residual at the 3 nodes is ≤1.2e-16 in every frame (inst.out `nodeerr`). The independent `numpy.polyfit` through the same 3 nodes gives the same curve: max deviation on the 500-pt grid agrees with the script to all 7 printed digits in all 18 frames. | confirmed |
| 2 | "converging to the **tangent parabola** (degree-2 Taylor polynomial at $x_0$) as $h\to 0$" | max over plot grid of $\lvert P_h-T_2\rvert$ falls from 2.3227e-1 (h=1) to 2.4307e-5 (h=0.01). The ratio err/$h^2$ tends to 0.2431, so convergence is $O(h^2)$ and monotone across all 18 frames. Sympy: `limit(interpolate(...), h, 0) - series(cos x, π/4, 3)` simplifies to 0. | confirmed |
| 3 | "$f(x)=\cos(x)$" | Script line 10 `f(x)=cos(x)`, line 59 legend "f(x) = cos(x)"; blue curve in frames peaks at (0,1). | confirmed |
| 4 | "centered at $x_0=\pi/4$" | Script line 14 `x0 = π/4`; gray vline in frames at x≈0.785; middle node at (0.785, 0.707). | confirmed |
| 5 | Case heading: "Secant parabola $\to$ tangent parabola as $h\to 0$, $f(x)=\cos(x)$, $x_0=\pi/4$" | Same as 2–4. Frame titles read "Secant Parabola → Tangent Parabola (h = …)" for frames 1–18 and "Tangent Parabola (T₂ — Taylor degree 2 at x₀)" for 19–23. | confirmed |
| 6 | "For large $h$ the secant parabola is determined by three well-separated points." | Frame 1 (h=1.0): nodes at x=−0.215, 0.785, 1.785, all visible on the curve and the red dashed curve passes through them. | confirmed |
| 7 | "As $h\to0$ all three nodes collapse to $x_0$" | Frames 1→18: the node spread is 2h, shrinking to 0.02 at frame 18 (the three dots overlap at x₀ in frame_018.png). | confirmed |
| 8 | "the secant parabola approaches the Taylor polynomial $T_2(x)=f(x_0)+f'(x_0)(x-x_0)+\tfrac12 f''(x_0)(x-x_0)^2$" | Formula matches script line 18 (with `df=-sin`, `d2f=-cos`). Coefficients about $x_0$ from the script at h=0.01: a0=0.707106781186548, a1=−0.707094996132451, a2=−0.353550444325279. Exact $T_2$ (mpmath): 0.7071067811865475, −0.7071067811865475, −0.3535533905932738. Closed forms $a_1=-\sin x_0\,\sin h/h$ and $a_2=\cos x_0(\cos h-1)/h^2$ agree with the script's a1 and a2 to ≤2.2e-15 and ≤4.4e-13 respectively over all 18 h. | confirmed |
| 9 | "the Taylor polynomial is the limiting position of the Newton interpolating parabola" | Same as 2 (symbolic limit = $T_2$). | confirmed |
| 10 | "Julia source scripts that generated these animations are linked under each case." / `[Julia source](tangparabaa.jl)` | Link points to the only script, which writes `tangparabaa.gif`. The manifest shows the scratch rerun is byte-identical to the committed GIF. | confirmed |
| 11 | Embed `![…](tangparabaa.gif)` | It is the GIF that this script produces (byte-identical). | confirmed |
| 12 | Alt: "Secant parabola (red dashed) through three nodes" | Script line 44/60: `:tomato`, `linestyle=:dash`; scatter of 3 nodes, also tomato. Frames show red-orange dashed curve through 3 dots. | confirmed |
| 13 | Alt: "converging to the tangent parabola (green dotted, Taylor degree-2)" | Script line 61: `:darkgreen`, `:dot`, label "Tangent parabola T₂(x)", drawn in every frame. | confirmed |
| 14 | Alt: "as h shrinks from 1.0 to near 0" | h runs 1.0 → 0.01 (18 log-spaced values; the labels 1.0, 0.763, 0.582, …, 0.013, 0.01 match `round(h,3)` of my independently generated sequence), then 5 hold frames of $T_2$. Frame hashes show frames 19–23 identical. | confirmed |
| 15 | Alt: "for cos(x) at x0=pi/4" | As 3, 4. | confirmed |
| 16 | Count implied by "The animation below" / "Case 1" (one case) | 1 script, 1 GIF. | confirmed |

The page has no `## Description` section, so there are no method-description claims to check beyond the $T_2$ formula in the Behavior paragraph (row 8). Missing content is out of scope as a finding; I note it only because the conventions file says the section is required.

---

### 3. Implementation checks: `tangparabaa.jl`

**It is the method it claims to be.** It builds the degree-2 Newton interpolating polynomial on the equally spaced nodes $x_0-h, x_0, x_0+h$, using divided differences in Newton form based at $x_0-h$ (lines 21–30). This is the same polynomial as Mathews' centred formula (4); Newton form is a valid formulation. The "tangent parabola" is the explicit degree-2 Taylor polynomial (line 18) with the correct derivatives of cos (lines 11–12).

**The numbers are right.** I instrumented a copy (`review/inst.jl`, the script body with plotting removed plus prints) and checked it against an independent computation (`review/indep.py`: mpmath closed forms for the centred-difference coefficients, `numpy.polyfit` for the interpolant, and a sympy symbolic limit).

| h (label) | script max\|P−T₂\| | independent max\|P−T₂\| | err/h² | script a1 | script a2 |
|---|---|---|---|---|---|
| 1.0 | 2.322660e-01 | 2.322660e-01 | 0.2323 | −0.595009839529386 | −0.325055356816458 |
| 0.582 | 8.099520e-02 | 8.099520e-02 | 0.2394 | −0.667896980853299 | −0.343695389060921 |
| 0.197 | 9.401521e-03 | 9.401521e-03 | 0.2426 | −0.702549271166979 | −0.352413276894696 |
| 0.067 | 1.078199e-03 | 1.078199e-03 | 0.2430 | −0.706584028548234 | −0.353422692769381 |
| 0.023 | 1.234810e-04 | 1.234810e-04 | 0.2431 | −0.707046911763469 | −0.353538423110803 |
| 0.01 | 2.430668e-05 | 2.430668e-05 | 0.2431 | −0.707094996132451 | −0.353550444325279 |
| limit (exact $T_2$) | | | | −0.7071067811865475 | −0.3535533905932738 |

All 18 frames agree; the full table is in `review/indep.out`. The property checks also pass: the interpolant reproduces its 3 data points to ≤1.2e-16, and the error shrinks like $h^2$ (err/h² → 0.2431, constant). Rounding error in the second divided difference at h=0.01 is about 4e-13, which is negligible.

**Its reference values are right.** The reference curve is $T_2$ at $\pi/4$. Its coefficients (0.70710678…, −0.70710678…, −0.35355339…) match the exact values from mpmath, and sympy confirms $T_2$ is both the Taylor series to order 2 and the $h\to0$ limit of the interpolant.

**The picture shows what was computed.** I viewed `sheet.png` and frames 001, 018 and 023 at full size. The following all check out:
- The red dashed curve passes through the three dots, and the dots sit on the blue cos curve at $x_0\pm h$ and $x_0$.
- The green dotted $T_2$ is the same in every frame.
- The gray vline is at $\pi/4$.
- The titles and legend show `round(h,3)`, which matches the h actually used.
- Frames 19–23 substitute $T_2$ for the secant curve, honestly labelled "Tangent parabola T₂(x)" and titled as such, with no nodes drawn.
- The axis limits $[x_0-1.5,x_0+1.5]\times[-0.5,1.3]$ clip the lower tails of the curves only, away from $x_0$, and hide nothing the page discusses.

Observations that are not findings:
- From about h≈0.15 (frame 8, error 5.5e-3, about 1 pixel at this scale) onward, the secant and tangent curves are visually indistinguishable. Only the shrinking node spread changes. This is consistent with "approaches", but it means the last ~10 secant frames look alike.
- In frames 19–23 the legend lists "Tangent parabola T₂(x)" twice (dashed and dotted) for the same curve. This is cosmetic and does not mislead.

