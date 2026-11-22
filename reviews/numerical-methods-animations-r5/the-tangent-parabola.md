# The Tangent Parabola — animation review (round 5)

Page: `pages/numerical-methods/the-tangent-parabola/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** No Error, Misleading, Minor, or Fidelity findings.

Observations that I judged not to be findings (recorded so the owner can see they were considered):

- **Duplicate legend entry in the hold frames (18–22).** In the `h = 0` branch the script draws `P_vals = T2_vals` with label "Tangent parabola T₂(x)" (dark-green dashed, line 50/62) and then also the always-drawn dotted T₂ with the same label (lines 63–64). The legend therefore lists "Tangent parabola T₂(x)" twice. Both curves are the same function, so nothing false is shown; cosmetic only.
- **Script header mentions "Table 1".** `tangparabaa.jl` line 3 says the example is Mathews' running example of "Figures 1–3 and Table 1". That is true of the example (same f, x₀). The animation's h set (10^(−k/8), k = 0..16) contains Table 1's h = 1, 0.1, 0.01 but not 0.3, 0.03, 0.003, 0.001. The comment does not claim the frames reproduce Table 1, and the page text does not mention Table 1, so not a finding.
- **Visual convergence saturates early.** The max gap between the secant parabola and T₂ on [0, π] falls below ~2 px (7.0e−3 in y on a 1.35-unit, ~420 px axis) by h ≈ 0.24 (frame 6); from about frame 9 (h = 0.1) on, the curves are visually identical and only the node markers move. The page makes no claim this contradicts.
- **No `## Description` section.** The authoring conventions (`.github/agents/animation-page.agent.md` line 12/205) require one; the page has none. Under the review standard, absent content is not a finding; noted only because the "Method description" ledger category is therefore empty apart from the formulas in the Behavior paragraph.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `tangparabaa.jl` | 0 | 13.1 | tangparabaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `tangparabaa.gif` | 22 | byte-identical | tangparabaa |

### Page references

- Scripts linked: `tangparabaa.jl`
- GIFs embedded: 1
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | Intro | "the **secant parabola** (degree-2 Newton polynomial through $x_0 - h$, $x_0$, $x_0 + h$)" | Script lines 22–31: nodes `x0-h, x0, x0+h`, divided differences, Newton form `y1 + d01(x-x1) + d012(x-x1)(x-x2)`. Node residuals 0 to 1.1e−16 for all 17 h (`nodes.jl`). | confirmed |
| 2 | Intro | "converging to the **tangent parabola** (degree-2 Taylor polynomial at $x_0$) as $h \to 0$" | Max |P−T₂| on [0,π]: 1.196e−1 (h=1) → 1.251e−5 (h=0.01); successive ratio → 0.5623 = (h-ratio)² = 10^(−1/4), i.e. O(h²) convergence (`indep.py`, script values identical in `instr.jl`). | confirmed |
| 3 | Intro | "for $f(x) = \sin(x)$ centered at $x_0 = 1$" | Script lines 11, 15. | confirmed |
| 4 | Intro | "the running example of Mathews' module" | Archive `gr_34` "y = sin(x)", `gr_35` "x0 = 1"; Table 1 caption `gr_119` "x0 = 1"; Figures 1–3 plot window [0, π]. | confirmed |
| 5 | Intro | "the frames include its Figure 1 and Figure 2 step sizes $h = 0.1$ and $h = 0.01$" | Archive `gr_36` "h = 0.1" (Fig. 1), `gr_41` "h = 0.01" (Fig. 2). Script h list: frame 9 h = 0.10000000000000002 (label "0.1"), frame 17 h = 0.010000000000000004 (label "0.01"); seen in `frame_009.png`, `frame_017.png` titles. | confirmed |
| 6 | Intro | "Julia source scripts that generated these animations are linked under each case." | `[Julia source](tangparabaa.jl)` under Case 1; regenerated GIF byte-identical to committed. | confirmed |
| 7 | Intro | Mathews' "Examples 3–5 … extend the construction to Newton polynomials of higher degree through equally spaced points starting at $x_0$" | Archive: nodes $(x_k, f(x_k))$, Mathematica `y[X] = Σ a_j Π_{i<j}(X − x0 − i h)` (`gr_186`, `gr_192`) → nodes x₀ + i h, i = 0..n. | confirmed |
| 8 | Intro | "…and compare them with the Taylor polynomial of the same degree (the tangent cubic in Examples 3 and 4, a higher-degree tangent polynomial in Example 5)" | Archive text: Ex. 3 "Newton cubic polynomials … compare them with the Taylor polynomial"; Ex. 4 "sequence of Newton cubic polynomials converging to the Taylor polynomial"; Ex. 5 "Newton polynomials of degree 6 converging to the Taylor polynomial". | confirmed |
| 9 | Intro | Examples 3–5 "are not animated here" | Only one script/GIF on the page. | confirmed |
| 10 | Case 1 heading | "Secant parabola $\to$ tangent parabola as $h \to 0$, $f(x) = \sin(x)$, $x_0 = 1$" | Script parameters; see #2, #3. | confirmed |
| 11 | Behavior | "For large $h$ the secant parabola is determined by three well-separated points." | Frame 1 (h = 1): nodes at x = 0, 1, 2, values 0, 0.8415, 0.9093, drawn as markers at those positions. | confirmed |
| 12 | Behavior | "As $h \to 0$ all three nodes collapse to $x_0$" | Node markers in frames 1→17 move from {0,1,2} to {0.99,1,1.01} (frame 17 shows a single cluster at x = 1). | confirmed |
| 13 | Behavior | "the secant parabola approaches the Taylor polynomial $T_2(x) = f(x_0) + f'(x_0)(x-x_0) + \tfrac{1}{2}f''(x_0)(x-x_0)^2$" | Formula is the correct degree-2 Taylor polynomial; script line 19 implements it with f' = cos, f'' = −sin. Secant coefficients in powers of (x−1): h=1 (0.841471, 0.454649, −0.386822) → h=0.01 (0.841471, 0.540293, −0.420732); limit (sin 1, cos 1, −sin 1/2) = (0.841471, 0.540302, −0.420735). | confirmed |
| 14 | Behavior | "This shows that the Taylor polynomial is the limiting position of the Newton interpolating parabola." | Follows from #2/#13 (the limit of the symmetric second difference is f''); illustrated, not proved, by the frames — wording "shows" is the usual sense for an animation. | confirmed |
| 15 | Wiring | Source link `tangparabaa.jl` and embed `tangparabaa.gif` are this case | Script writes `tangparabaa.gif` (line 74); manifest: byte-identical regeneration, linked from section index. | confirmed |
| 16 | Alt text | "Secant parabola (red dashed) through three nodes" | `color=:tomato, linestyle=:dash`; scatter of 3 nodes. Frames 1–17. | confirmed |
| 17 | Alt text | "converging to the tangent parabola (green dotted, Taylor degree-2)" | `color=:darkgreen, linestyle=:dot`, T₂. | confirmed |
| 18 | Alt text | "as h shrinks from 1.0 to 0.01" | h list 1.0 … 0.01 (17 log-spaced values); titles frame 1 "h = 1.0", frame 17 "h = 0.01". | confirmed |
| 19 | Alt text | "followed by the tangent parabola alone" | Frames 18–22 (h = 0): secant curve and nodes removed; T₂ shown (with f and x₀ line still present, as in all frames). | confirmed |
| 20 | Alt text | "for sin(x) at x0=1" | Script. | confirmed |

Fidelity (archive): example function, centre, plot window [0, π] and Figure 1/2/3 step sizes match Mathews. Examples 1–2 (coefficient computations for h = 0.1, 0.01) are the computations behind Figures 1–2, which appear as frames 9 and 17; Examples 3–5 are explicitly declared not animated. No silent drop and no unexplained departure.

### 3. Implementation checks — `tangparabaa.jl`

**Is the method it claims to be.** Yes. `newton_parabola` is the degree-2 Newton divided-difference interpolant on nodes x₀−h, x₀, x₀+h (lines 22–31); Mathews' formula (4) writes the same unique interpolant in symmetric form about x₀. `T2` is the degree-2 Taylor polynomial at x₀ = 1 with correct derivatives (cos, −sin). The h → 0 tail is handled by drawing T₂ directly (h = 0 branch), which is the stated limit, not a computed secant at tiny h — appropriate and labelled as T₂.

**Numbers are right.** Independent computation (`indep.py`: Vandermonde solve in t = x − x₀, numpy) vs script (`instr.jl`, `nodes.jl`):

| h | Script coeffs (c0, c1, c2) | Independent | Mathews Table 1 | Script P(0) / P(π) | Independent P(0) / P(π) |
|---|---|---|---|---|---|
| 1.0 | 0.841471, 0.454649, −0.386822 | 0.841471, 0.454649, −0.386822 | 0.841471, 0.454649, −0.386822 | 0.000000 / 0.041014 | 0.000000 / 0.041014 |
| 0.3162 | 0.841471, 0.531342, −0.417241 | (P values match) | — | −0.107112 / 0.065747 | −0.107112 / 0.065747 |
| 0.1 | 0.841471, 0.539402, −0.420385 | 0.841471, 0.539402, −0.420385 | 0.841471, 0.539402, −0.420385 | −0.118316 / 0.068589 | −0.118316 / 0.068589 |
| 0.01 | 0.841471, 0.540293, −0.420732 | 0.841471, 0.540293, −0.420732 | 0.841471, 0.540293, −0.420732 | −0.119554 / 0.068906 | −0.119554 / 0.068906 |

All 17 h values agree for P(0), P(π) and max|P − T₂| to the printed 6 digits. Property checks: interpolant reproduces f at the three nodes (residual ≤ 1.1e−16 for every h); error vs T₂ shrinks by 0.5623 per frame, equal to (h-ratio)² = 10^(−1/4) = 0.56234, the expected O(h²) rate. The h list `exp.(range(log 1, log 0.01, 17))` equals 10^(−k/8), k = 0..16, as the comment on line 33 says (checked element-wise to 4 decimals; frames 9 and 17 are 0.1 and 0.01 up to 1 ulp).

**Reference values are right.** T₂(x) = sin 1 + cos 1 (x−1) − ½ sin 1 (x−1)²: coefficients 0.841471, 0.540302, −0.420735, which are the h → 0 limits of the secant coefficients above and the last row (h = 0.001) of Mathews' Table 1. T₂(0) = −0.119567, T₂(π) = 0.068909.

**Picture shows what was computed.** Frames 1, 9, 17, 22 inspected against the plotting code. Frame 1: red dashed curve passes through markers at (0, 0), (1, 0.8415), (2, 0.9093) and ends at ≈ 0.04 at x = π, matching computed P(π) = 0.0410; green dotted T₂ starts at ≈ −0.12 at x = 0, matching −0.1196. Frames 9/17: titles and legend report h = 0.1 / 0.01; nodes at x₀ ± h. Frame 22: secant and nodes gone, T₂ shown, title "Tangent Parabola (T₂ — Taylor degree 2 at x₀)". Axis limits x ∈ [0, π] (Mathews' window), y ∈ [−0.2, 1.15]: all plotted values lie in [−0.1196, 1.0149] for every frame, so nothing is clipped; no NaN masking. Vertical dashed line at x₀ = 1 correct. Frame count 22 = 17 secant frames + 5 hold frames, consistent with the code. Only cosmetic issue: the duplicate T₂ legend entry in frames 18–22 (see Observations).

