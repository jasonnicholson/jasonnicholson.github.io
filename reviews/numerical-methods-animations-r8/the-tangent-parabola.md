# The Tangent Parabola — animation review (round 8)

Page: `pages/numerical-methods/the-tangent-parabola/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** 0 Error, 0 Misleading, 0 Minor.

Items considered and rejected as findings:

- **Archive Examples 3–5 not animated.** These use f(x) = e^{x/4} cos x, x0 = 0, with Newton cubic and degree-6 polynomials, under the archive heading "Various Scenarios and Animations for the Tangent Parabola". The page says explicitly that they are not animated (index.qmd line 16), and it describes them correctly, so the drop is not silent. This is not a Fidelity finding.
- **Script header comment (line 3) cites "Figures 1–3 and Table 1".** That describes where the running example comes from, which is true. The comment does not claim that Table 1's step sizes (0.3, 0.03, 0.003, 0.001) are frames, and the page makes no such claim either.
- **Leftmost node at x = 0 when h = 1 sits on the frame edge (frame 1).** The marker is half clipped by the axis but still visible. This is cosmetic only.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `tangparabaa.jl` | 0 | 11.0 | tangparabaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| 1 | "secant parabola (degree-2 Newton polynomial through x0−h, x0, x0+h)" | Script lines 22–31 build the Newton divided-difference form on nodes x0−h, x0, x0+h. The node residual is ≤1.1e-16 for all 17 h, and the coefficients match an independent mpmath Vandermonde solve to 12 digits. | confirmed |
| 2 | "converging to the tangent parabola (degree-2 Taylor polynomial at x0) as h → 0" | max over [0,π] of abs(P−T2) goes from 0.1196 (h=1) to 1.25e-3 (h=0.1) to 1.25e-5 (h=0.01), so it falls like h². sympy gives lim_{h→0} P − T2 = 0 exactly. | confirmed |
| 3 | "f(x) = sin(x) centered at x0 = 1" | Script lines 11, 15; frame titles and legend. | confirmed |
| 4 | "the running example of Mathews' module" | Archive Figures 1–3 and Table 1 use y = sin x, x0 = 1 (images gr_33–44, gr_118–122). | confirmed |
| 5 | "the frames include its Figure 1 and Figure 2 step sizes h = 0.1 and h = 0.01" | h_vals[9] = 0.10000000000000002 (frame 9, title "h = 0.1"). h_vals[17] = 0.010000000000000004 (frame 17, title "h = 0.01"). Archive Figure 1 uses h = 0.1 and Figure 2 uses h = 0.01 (gr_36, gr_40). | confirmed |
| 6 | "Julia source scripts … are linked under each case" | One case, and `[Julia source](tangparabaa.jl)` is present. | confirmed |
| 7 | Examples 3–5 "extend the construction to Newton polynomials of higher degree through equally spaced points starting at x0 and compare them with the Taylor polynomial of the same degree (the tangent cubic in Examples 3 and 4, a higher-degree tangent polynomial in Example 5)" | The archive Mathematica code (gr_168–169) uses nodes x0 + k h, k = 0..n. Examples 3 and 4 are Newton cubics. Example 5 is degree 6 with k = 0..6. All are compared with the Taylor polynomial. | confirmed |
| 8 | "… are not animated here" | Only one script and one GIF exist. | confirmed |
| 9 | Case heading: "Secant parabola → tangent parabola as h → 0, f(x) = sin(x), x0 = 1" | Matches the script parameters and frames. | confirmed |
| 10 | Behavior: "For large h the secant parabola is determined by three well-separated points" | At h = 1 the nodes are 0, 1 and 2 (frame 1). | confirmed |
| 11 | "As h → 0 all three nodes collapse to x0" | The nodes are x0 ± h, and h falls to 0.01 (frame 17 shows the nodes merged at x = 1). | confirmed |
| 12 | "the secant parabola approaches T2(x) = f(x0) + f′(x0)(x−x0) + ½f″(x0)(x−x0)²" | The T2 formula is correct and the script's line 19 matches it. The coefficients (0.841471, 0.540302, −0.420735) were checked with mpmath. The secant coefficients approach them, for example a1 at h = 0.01 is 0.540293 and a2 is −0.420732. | confirmed |
| 13 | "the Taylor polynomial is the limiting position of the Newton interpolating parabola" | Same evidence as 2. | confirmed |
| 14 | Alt: "Secant parabola (red dashed)" | `:tomato`, `linestyle=:dash` (frames 1–17). | confirmed |
| 15 | Alt: "through three nodes" | `scatter!` of 3 nodes on f (frames 1–17). | confirmed |
| 16 | Alt: "tangent parabola (green dotted, Taylor degree-2)" | `:darkgreen`, `:dot`, T2. | confirmed |
| 17 | Alt: "as h shrinks from 1.0 to 0.01" | h_vals are 10^(−k/8) for k = 0..16, from 1.0 to 0.01, and the frame titles agree. | confirmed |
| 18 | Alt: "followed by the tangent parabola alone" | Frames 18–22 (identical hashes) show sin x, T2 and the x0 line, with no secant parabola. | confirmed |
| 19 | Alt: "for sin(x) at x0=1" | Script. | confirmed |
| 20 | Embed wiring: `![...](tangparabaa.gif)` shows case 1 | The GIF is produced by `tangparabaa.jl` and matches the regeneration byte for byte (manifest). | confirmed |

The page has no Description section stating formulas beyond those in the Animations section, so there was nothing further to check there.

### 3. Implementation checks: `tangparabaa.jl`

**Method.** This is the secant parabola: the unique quadratic interpolant at x0−h, x0, x0+h, built in Newton divided-difference form anchored at x0−h. Mathews writes the same polynomial expanded about x0 (formula (4): f(x0) + [f(x0+h)−f(x0−h)]/(2h)·(x−x0) + [f(x0+h)−2f(x0)+f(x0−h)]/(2h²)·(x−x0)²). Since the quadratic interpolant is unique, the two forms are the same polynomial. The tangent parabola T2 is the degree-2 Taylor polynomial with exact derivatives cos and −sin.

**Numbers.** `instr.jl` evaluates the script's own `newton_parabola` and recovers the coefficients in the (x−1) basis:

| h | script a0, a1, a2 | independent (mpmath, `indep.py`) | Mathews Table 1 |
|---|---|---|---|
| 1.0 | 0.8414709848, 0.4546487134, −0.3868222714 | 0.841470984808, 0.454648713413, −0.386822271395 | 0.841471, 0.454649, −0.386822 |
| 0.1 | 0.8414709848, 0.5394022522, −0.4203849963 | 0.841470984808, 0.53940225217, −0.420384996344 | 0.841471, 0.539402, −0.420385 |
| 0.01 | 0.8414709848, 0.5402933009, −0.4207319863 | 0.841470984808, 0.540293300875, −0.420731986287 | 0.841471, 0.540293, −0.420732 |

The script's function, run at all seven Table 1 step sizes (1.0, 0.3, 0.1, 0.03, 0.01, 0.003, 0.001), reproduces every Table 1 entry to all 6 printed digits. For example, h = 0.3 gives 0.532234 and −0.417589, and h = 0.001 gives 0.540302 and −0.420735. Property checks:

- The interpolant reproduces its data at the nodes, with residual ≤1.1e-16 for all 17 h.
- The central-difference error a1 − cos 1 falls by 4.00× per halving (−9.00e-4, −2.25e-4, −5.63e-5), as second order requires.
- max abs(P−T2) on [0,π] falls by about 100× per decade of h (0.120, then 1.25e-3, then 1.25e-5).

**Reference values.** T2 coefficients: f(1) = 0.841470984808, f′(1) = cos 1 = 0.540302305868, ½f″(1) = −0.420735492404. These match mpmath to 12 digits. sympy confirms lim_{h→0} (interpolant − T2) = 0 symbolically.

**Picture.** I viewed frames 1, 9 and 22 in full and the contact sheet (frames 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21).

- Nodes are plotted at (x0±h, sin(x0±h)) and (x0, sin x0) and lie on the blue curve.
- The dashed curve passes through the nodes. At h = 1 it visibly separates from both sin and T2. From h ≈ 0.1 on it lies on top of the green dotted T2, which is consistent with the max deviation of ≤1.3e-3, below pixel resolution.
- Title and legend h labels equal round(h, 3) of the h actually used.
- The axis limits [0,π]×[−0.2,1.15] contain everything: T2(0) = −0.1196, max T2 = 1.0149 at x = 1.642, and the secant parabola at h = 1 has range within [0, 0.98]. Nothing is clamped.
- The x0 reference line is at x = 1.
- Frames 18–22 are identical hold frames showing T2 alone, and their title correctly names T2.
- 22 frames = 17 h values + 5 holds.

