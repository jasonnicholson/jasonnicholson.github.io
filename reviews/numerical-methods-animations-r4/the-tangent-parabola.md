# The Tangent Parabola — animation review (round 4)

Page: `pages/numerical-methods/the-tangent-parabola/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no error, nothing misleading and no fidelity departure that matters to a reader.

Observations that I checked and judged not to be findings:
- In the last five frames (h = 0), `P_vals = T2_vals` is drawn dashed with the label "Tangent parabola T₂(x)", and the dotted T₂ is drawn again with the same label. The legend therefore lists "Tangent parabola T₂(x)" twice (frame_022.png). This is cosmetic. The two curves really are the same function, so nothing false is shown.
- The alt text says "followed by the tangent parabola alone". sin(x) and the x₀ line are still drawn in those frames. Read as "without the secant parabola", the phrase is accurate.
- Mathews' Table 1 uses h = 1.0, 0.3, 0.1, 0.03, 0.01, 0.003, 0.001. The animation uses 17 log-spaced values 10^(−k/8) from 1 to 0.01. The page claims only that h = 0.1 and h = 0.01 (Figures 1 and 2) appear as frames, which is true. Mathews' Examples 3 to 5 (f(x) = e^{x/4} cos x at x₀ = 0, cubic and degree-6 Newton polynomials) are not animated, and the page says so openly. This is not a silent drop.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `tangparabaa.jl` | 0 | 10.3 | tangparabaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page's words) | Location | Evidence | Verdict |
|---|---|---|---|---|
| 1 | "secant parabola (degree-2 Newton polynomial through $x_0 - h$, $x_0$, $x_0 + h$)" | index.qmd:12 | script l.22–31 uses nodes x0−h, x0, x0+h with Newton divided differences. The node residual is ≤1.1e−16 at every frame (instr.out). Coefficients agree with an independent Vandermonde solve to ≤1.1e−13 at every frame (indep.out) | confirmed |
| 2 | "converging to the tangent parabola (degree-2 Taylor polynomial at $x_0$) as $h \to 0$" | index.qmd:12 | max over [0,π] of \|P−T2\| falls monotonically: 0.1196 (h=1), 0.01245 (h=0.316), 0.001251 (h=0.1), 1.251e−4 (h=0.0316), 1.251e−5 (h=0.01). That is a factor of 100 per decade of h, so O(h²) convergence. At h=0.01 the coefficients are a1 = 0.5402933 and a2 = −0.4207320, against the limit cos 1 = 0.5403023 and −sin(1)/2 = −0.4207355 | confirmed |
| 3 | "for $f(x) = \sin(x)$ centered at $x_0 = 1$" | index.qmd:12, 18 | script l.11, l.15. The frame legend shows "f(x) = sin(x)" and the x₀ line is drawn at x=1 (frame_001, frame_009) | confirmed |
| 4 | "the running example of Mathews' module" | index.qmd:12 | archive gr_34/35, gr_81/82: y = sin(x), x₀ = 1. Plot window [0,π] matches Figures 1 to 3 (gr_33/38/42) | confirmed |
| 5 | "the frames include its Figure 1 and Figure 2 step sizes $h = 0.1$ and $h = 0.01$" | index.qmd:12 | archive gr_36 (h = 0.1, Fig 1) and gr_41 (h = 0.01, Fig 2). Script frame 9 has h = 0.10000000000000002 (title "h = 0.1", nodes at 0.9/1.0/1.1 in frame_009.png). Frame 17 has h = 0.010000000000000004 (title "h = 0.01") | confirmed |
| 6 | "Julia source scripts that generated these animations are linked under each case." | index.qmd:14 | l.22 links `tangparabaa.jl`, which exists. The manifest shows the regenerated GIF is byte-identical to the committed one | confirmed |
| 7 | "Examples 3–5 … extend the construction to Newton polynomials of higher degree through equally spaced points starting at $x_0$" | index.qmd:16 | archive gr_186/187 (points (x_k, f(x_k))) and gr_192 (Mathematica: ∏(X − x0 − h i), i = 0..j−1, so the nodes are x0 + i h, i ≥ 0) | confirmed |
| 8 | "the tangent cubic in Examples 3 and 4" | index.qmd:16 | archive text: "draw the graphs of Newton cubic polynomials" (Ex 3) and "plot a sequence of Newton cubic polynomials" (Ex 4), compared with T₃ (gr_188/204) | confirmed |
| 9 | "a higher-degree tangent polynomial in Example 5" | index.qmd:16 | archive Ex 5: "Newton polynomials of degree 6 converging to the Taylor polynomial" | confirmed |
| 10 | "are not animated here" | index.qmd:16 | there is only one script and one GIF (manifest) | confirmed |
| 11 | Heading "Secant parabola $\to$ tangent parabola as $h \to 0$, $f(x) = \sin(x)$, $x_0 = 1$" | index.qmd:18 | same as 2 and 3. The case's link and embed point at tangparabaa.jl and tangparabaa.gif, which is that case | confirmed |
| 12 | "For large $h$ the secant parabola is determined by three well-separated points." | index.qmd:20 | frame 1 (h = 1): the nodes are at x = 0, 1, 2 (frame_001.png) | confirmed |
| 13 | "As $h \to 0$ all three nodes collapse to $x_0$" | index.qmd:20 | the node markers close up on x=1 (sheet.png). At h = 0.01 they overlap at x₀ | confirmed |
| 14 | "the secant parabola approaches … $T_2(x) = f(x_0) + f'(x_0)(x-x_0) + \tfrac{1}{2}f''(x_0)(x-x_0)^2$" | index.qmd:20 | the formula is the degree-2 Taylor polynomial. Script l.19 implements exactly this with df = cos and d2f = −sin. The script's T2 coefficients are 0.8414709848, 0.5403023059, −0.4207354924, and mpmath gives sin 1, cos 1 and −sin(1)/2 identically | confirmed |
| 15 | "the Taylor polynomial is the limiting position of the Newton interpolating parabola" | index.qmd:20 | follows from 2 and 14. Mathematically, the central first difference tends to f′(x0) and (f(x0+h) − 2f(x0) + f(x0−h))/(2h²) tends to f″(x0)/2 | confirmed |
| 16 | Link "[Julia source](tangparabaa.jl)" | index.qmd:22 | the file exists and is this case's script | confirmed |
| 17 | Alt: "Secant parabola (red dashed)" | index.qmd:24 | script l.46 and l.62: color `:tomato`, linestyle `:dash`. Frames show a red-orange dashed curve | confirmed |
| 18 | Alt: "through three nodes" | index.qmd:24 | script l.66–70 scatter at (x0∓h, f), (x0, f). Frames show 3 markers on the curve | confirmed |
| 19 | Alt: "tangent parabola (green dotted, Taylor degree-2)" | index.qmd:24 | script l.63: `:darkgreen`, `:dot`, drawn on every frame | confirmed |
| 20 | Alt: "as h shrinks from 1.0 to 0.01" | index.qmd:24 | h_vals[1] = 1.0 and h_vals[17] = 0.01, strictly decreasing. Titles read "h = 1.0" in frame 1 and "h = 0.01" in frame 17 | confirmed |
| 21 | Alt: "followed by the tangent parabola alone" | index.qmd:24 | frames 18 to 22 have no secant curve and no nodes, and the title is "Tangent Parabola (T₂ — Taylor degree 2 at x₀)". sin(x) and the x₀ line remain (see the observations above) | confirmed |
| 22 | Alt: "for sin(x) at x0=1" | index.qmd:24 | as 3 | confirmed |
| 23 | Embed `tangparabaa.gif` | index.qmd:24 | it is the output of tangparabaa.jl (regenerated byte-identical, 22 frames) | confirmed |

The page has no separate Description or formula section beyond the text above. Claims 1 and 14 are its method statements.

### 3. Implementation checks: `tangparabaa.jl`

**It is the method it claims to be.** `newton_parabola` (l.22–31) builds the degree-2 Newton divided-difference interpolant on the nodes x0−h, x0, x0+h, taking x0−h as the base node. Mathews' formula (4) writes the same polynomial centred at x0, as f(x0) + δ1(x−x0) + δ2(x−x0)². The interpolant is unique, so the two are the same polynomial. My independent Vandermonde solve in the (x−x0) basis reproduces the script's coefficients to ≤1.1e−13 (below). `T2` (l.19) is the degree-2 Taylor polynomial of sin at x0 = 1.

**The numbers are right.** The coefficients below were recovered from the script's own routine (instr.out) and compared with the independent solve (indep.out):

| frame | h | script a1 | indep a1 | script a2 | indep a2 | max \|diff\| |
|---|---|---|---|---|---|---|
| 1 | 1.0 | 0.45464871341284 | 0.454648713413 | −0.38682227139506 | −0.386822271395 | 1.0e−16 |
| 5 | 0.316228 | 0.53134218557508 | 0.531342185575 | −0.41724102955095 | −0.417241029551 | 5.0e−16 |
| 9 | 0.1 | 0.53940225216976 | 0.53940225217 | −0.42038499634371 | −0.420384996344 | 2.6e−15 |
| 13 | 0.0316228 | 0.54021225998624 | 0.540212259986 | −0.42070043228157 | −0.420700432282 | 3.4e−14 |
| 17 | 0.01 | 0.54029330087473 | 0.540293300875 | −0.42073198628645 | −0.420731986287 | 8.3e−14 |

All 17 secant frames agree to ≤1.1e−13. That is the size of the cancellation error expected in a second difference at h ≥ 0.01, and it is invisible at plot resolution. a0 = sin 1 = 0.8414709848 in every frame. Property checks:
- The interpolant reproduces the data at the nodes, with residual ≤1.1e−16 in every frame.
- max|P−T2| on [0,π] scales as h². It falls by a factor of exactly 100 for each factor of 10 in h (0.12457 → 0.0012505 → 1.2511e−5 at h = 0.316, 0.1, 0.01), which is the expected O(h²) error of central differences.
- As a cross-check on the archive, my independent coefficients for Mathews' Table 1 h values match his Table 1 (gr_119) to his 6 decimals in every row. For example, h = 0.3 gives 0.532234 and −0.417589, and h = 0.001 gives 0.540302 and −0.420735.

**Its reference values are right.** The reference curve is T₂ with coefficients sin 1 = 0.8414709848, cos 1 = 0.5403023059 and −sin(1)/2 = −0.4207354924, which agree with mpmath to all printed digits. I also checked the script's derivative functions analytically: df = cos and d2f = −sin. The h grid is `exp.(range(log(1), log(0.01), length=17))`, which equals 10^(−k/8) for k = 0..16 to within 1 ulp, as the comment on l.33 says. Entries 9 and 17 are 0.1 and 0.01 to 2e−17 and 4e−18.

**The picture shows what was computed.**
- The regenerated GIF is byte-identical to the committed one (manifest), so the frames come from this exact code.
- Frame 1 (h=1): the nodes are drawn at (0,0), (1,0.841) and (2,0.909). The secant peak is about 0.975, which matches the computed Pmax of 0.97506. T2 starts at −0.12 at x=0 (computed −0.11957).
- Frame 9 (h=0.1): the nodes are at 0.9, 1.0 and 1.1, as in Mathews' Figure 1 (gr_33).
- Frame 17 (h=0.01): the nodes coincide visually at x₀.
- Frames 18 to 22: T₂ only, with the title changed accordingly.
- Axis window: the window is x ∈ [0,π], y ∈ [−0.2,1.15]. Every drawn curve lies inside it. Secant curves range over [−0.1196, 1.0149], T2 over [−0.11957, 1.01493] (T2(π) = 0.0689, and its maximum is 1.01493 at x = 1.642), and sin over [0,1]. So nothing is clipped, and the h=1 nodes at x = 0 and 2 are inside the window.
- Titles and legend labels report h rounded to 3 decimals, which is consistent with h_vals. Examples: 0.562 for 0.56234 and 0.032 for 0.031623.
- The frame count is 17 + 5 = 22, which matches the GIF.
- The only display oddity is the duplicated T₂ legend entry in frames 18 to 22. It is not misleading.

