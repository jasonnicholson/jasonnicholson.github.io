# The Tangent Parabola — animation review (round 6)

Page: `pages/numerical-methods/the-tangent-parabola/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Implementation (picture), Minor: the hold frames list "Tangent parabola T₂(x)" twice in the legend

- **Location:** `tangparabaa.jl` lines 47 to 51 (`P_vals = T2_vals`, `p_lbl = "Tangent parabola T₂(x)"`, `p_clr = :darkgreen`) together with lines 62 to 64, which always overlay `T2_vals` dotted with the same label. Affects frames 18 to 22 (5 identical hold frames, md5 `2bcb3a34…`).
- **What is there now:** in the final frames, T2 is drawn twice, once dark-green dashed and once dark-green dotted, and both carry the label "Tangent parabola T₂(x)". The two lines lie exactly on top of each other and read as a dash-dot curve (see `committed/tangparabaa/frame_022.png`).
- **What is true instead:** only one curve, T2, is shown. A legend with two identically named entries in different line styles suggests two different curves.
- **How I know:** from the code path (`h = 0` goes to the `else` branch, and line 63 still plots `T2_vals`) and from viewing frame_022.png.
- **Suggested correction:** in the `h == 0` branch, skip the dashed plot or give it `label=""`. Alternatively, in the hold frames draw T2 once, solid and dark green, and skip the dotted overlay.

No other findings. Every numerical, parameter, behaviour, wiring and fidelity claim checked out (see the ledger).

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**1 finding: 0 Error, 0 Misleading, 1 Minor.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `tangparabaa.jl` | 0 | 10.6 | tangparabaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| 1 | Secant parabola is the "degree-2 Newton polynomial through $x_0-h$, $x_0$, $x_0+h$" | confirmed | Script lines 22 to 31 use nodes `x0-h, x0, x0+h` and the divided-difference Newton form. The residual at all three nodes is ≤1.1e-16 in every frame (instr.jl). |
| 2 | Tangent parabola is the "degree-2 Taylor polynomial at $x_0$" | confirmed | Script line 19. The coefficients 0.841471, 0.540302, −0.420735 match mpmath's derivatives/k!: 0.8414709848, 0.5403023059, −0.4207354924. |
| 3 | $f(x)=\sin(x)$ | confirmed | Script line 11 and the legend in every frame. |
| 4 | Centered at $x_0 = 1$ | confirmed | Script line 15. The gray x₀ line is at x=1 in the frames. |
| 5 | "the running example of Mathews' module" | confirmed | Archive captions gr_34/35 read "y = sin(x)" and "x₀ = 1" for Figures 1 to 3, and Table 1 is "where x₀ = 1". |
| 6 | "the frames include its Figure 1 and Figure 2 step sizes $h=0.1$ and $h=0.01$" | confirmed | Archive gr_36 reads "h = 0.1" (Figure 1) and gr_41 reads "h = 0.01" (Figure 2). In the script, h_vals[9] = 0.1000000000 and h_vals[17] = 0.0100000000. Frame titles read "h = 0.1" (frame 9) and "h = 0.01" (frame 17). |
| 7 | (Intro) secant parabola converges to tangent parabola as $h\to0$ | confirmed | The maximum deviation on [0,π] drops from 0.1196 (h=1) to 1.251e-5 (h=0.01). The ratio between frames tends to 1.7783 = 10^(2/8), so the error is O(h²). Script and mpmath agree to all printed digits (table in section 3). |
| 8 | Examples 3–5 use "Newton polynomials of higher degree through equally spaced points starting at $x_0$" | confirmed | Archive gr_192/194 (`y[X] = Σ a_j Π(X − x0 − i h)`, equations at `x0 + k h`, k = 0..n) and gr_247 (nodes x0 … x0+6h). |
| 9 | "the tangent cubic in Examples 3 and 4" | confirmed | lnk_9 and lnk_10 say "Newton cubic polynomials", and gr_192 sets n = 3. |
| 10 | "a higher-degree tangent polynomial in Example 5" | confirmed | lnk_11 says "Newton polynomials of degree 6". |
| 11 | Examples 3–5 "are not animated here" | confirmed | There is only one script and one GIF. The omission is disclosed, so it is not a silent drop. |
| 12 | "Julia source scripts … are linked under each case" | confirmed | Case 1 links `tangparabaa.jl`, which exists and generates the embedded GIF. |
| 13 | Heading: secant → tangent parabola as $h\to0$, $f=\sin x$, $x_0=1$ | confirmed | Same as claims 3, 4 and 7. |
| 14 | "For large $h$ the secant parabola is determined by three well-separated points" | confirmed | At h=1 the nodes are 0, 1 and 2 (frame 1). |
| 15 | "As $h\to0$ all three nodes collapse to $x_0$" | confirmed | Node markers at 1±h. They are visibly merged at x=1 by frame 17. |
| 16 | "the secant parabola approaches $T_2(x)=f(x_0)+f'(x_0)(x-x_0)+\tfrac12 f''(x_0)(x-x_0)^2$" | confirmed | The formula is the correct Taylor polynomial. The coefficient errors c1 and c2 go to 0 as O(h²) (c1err 9.0e-6, c2err −3.5e-6 at h=0.01). |
| 17 | "This shows that the Taylor polynomial is the limiting position of the Newton interpolating parabola" | confirmed | Same as claim 7. |
| 18 | Embed `tangparabaa.gif` is this case | confirmed | Committed GIF is byte-identical to the regenerated output of `tangparabaa.jl`. |
| 19 | Alt text: "Secant parabola (red dashed) through three nodes" | confirmed | `:tomato`, `linestyle=:dash`, with three node markers. |
| 20 | Alt text: "tangent parabola (green dotted, Taylor degree-2)" | confirmed | `:darkgreen`, `:dot` (lines 63 and 64). |
| 21 | Alt text: "as h shrinks from 1.0 to 0.01" | confirmed | 17 log-spaced values, 1.0 down to 0.01 (frames 1 to 17). |
| 22 | Alt text: "followed by the tangent parabola alone" | confirmed | Frames 18 to 22 drop the secant parabola and nodes. sin(x) and the x₀ line remain, which is reasonable for "alone" meaning without the secant. The duplicated legend entry is F1. |
| 23 | Alt text: "for sin(x) at x0=1" | confirmed | Same as claims 3 and 4. |
| 24 | Page linked from the section index | confirmed | `pages/numerical-methods/index.qmd:69`. |

The page has no Description section with formulas beyond the T2 formula in the Behavior paragraph (claim 16).

### 3. Implementation checks: `tangparabaa.jl`

**Is it the method it claims to be?** Yes. It builds the quadratic Newton divided-difference interpolant through x0−h, x0 and x0+h (first differences d01 and d12, second difference d012, then Newton form in the (x−x1) basis). This is the centred, symmetric-node construction Mathews uses. Table 1 in the archive (gr_119) has h=1 coefficient 0.454649 = (sin 2 − sin 0)/2, which matches symmetric nodes. T2 uses the exact derivatives cos and −sin.

**Are the numbers right?** Yes. Below are the script's values (instr.jl, coefficients of the secant parabola about x0) beside the independent mpmath solve (indep.py):

| frame | h | script c0, c1, c2 | mpmath c0, c1, c2 | max dev from T2 on [0,π] (script / mpmath) |
|---|---|---|---|---|
| 1 | 1.0 | 0.841471, 0.454649, −0.386822 | 0.841471, 0.4546487, −0.3868223 | 1.196e-1 / 0.1196 |
| 5 | 0.316228 | 0.841471, 0.531342, −0.417241 | 0.841471, 0.5313422, −0.417241 | 1.245e-2 / 0.01245 |
| 9 | 0.1 | 0.841471, 0.539402, −0.420385 | 0.841471, 0.5394023, −0.420385 | 1.251e-3 / 0.001251 |
| 13 | 0.031623 | 0.841471, 0.540212, −0.420700 | 0.841471, 0.5402123, −0.4207004 | 1.251e-4 / 0.0001251 |
| 17 | 0.01 | 0.841471, 0.540293, −0.420732 | 0.841471, 0.5402933, −0.420732 | 1.251e-5 / 1.251e-5 |

All 17 secant frames agree to every printed digit (rerun with `cd review && julia instr.jl` and `/usr/bin/python3 review/indep.py`).

Three property checks also pass:
- The interpolant reproduces sin at all three nodes (residual ≤1.1e-16).
- The deviation from T2 shrinks by a factor tending to 1.7783 = (10^(1/8))² per frame, which is O(h²), as expected.
- At h = 1, 0.1 and 0.01 the script reproduces Mathews' Table 1 to all six printed digits (0.454649/−0.386822, 0.539402/−0.420385, 0.540293/−0.420732).

The comment on lines 33 and 34 ("17 values = 10^(-k/8), k = 0..16") is right: `exp.(range(0, log(0.01), length=17))` equals 10^(−k/8).

**Are its reference values right?** The only reference is T2. Its coefficients sin 1 = 0.8414709848, cos 1 = 0.5403023059 and −sin 1/2 = −0.4207354924 match mpmath numerical differentiation.

**Does the picture show what was computed?** Yes, apart from F1.
- Frames 1, 9, 17 and 22 were viewed at full resolution, and the contact sheet covers the rest.
- Node markers sit at (x0±h, sin(x0±h)) and (x0, sin x0) on the blue sin curve.
- The dashed secant curve passes through them.
- Titles and legend entries report the frame's h, rounded to 3 digits (e.g. 0.562, 0.1, 0.01). These match h_vals.
- The axis window [0,π] × [−0.2, 1.15] is Mathews' plot window. Every curve lies inside it, so nothing is clipped. mpmath confirms the secant range for all h, and T2 runs from −0.1196 to 1.0149.
- There are 22 frames: 17 secant frames plus 5 identical hold frames (frames.md5 confirms 5 identical hashes at the end). They play at 4 fps.

Observation, not a finding: from about frame 5 (h≈0.32, deviation ≈0.012, about 4 px) the secant and tangent parabolas are visually indistinguishable at this scale. In the later frames only the node markers move. This reflects the true O(h²) convergence, and Mathews' Figures 1 and 2 look the same.

**Fidelity to the archive:** the function, centre, node arrangement, plot window and Figure 1 and 2 step sizes all match Mathews. Examples 1 and 2 (h = 0.1 and 0.01) correspond to frames 9 and 17. Examples 3 to 5 (cubic and degree-6 Newton polynomials on one-sided nodes x0 + k h) are not animated, and the page says so. No fidelity finding.

