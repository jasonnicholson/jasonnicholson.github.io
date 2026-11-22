# The Tangent Parabola — animation review (round 3)

Page: `pages/numerical-methods/the-tangent-parabola/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no errors, nothing misleading and no minor issues that meet the review standard.

Two observations that are not findings (cosmetic, and they do not change what a viewer would conclude):
- In the five hold frames (18–22), `P_vals = T2_vals` is drawn dark-green dashed under the label "Tangent parabola T₂(x)". The dotted T₂ curve is drawn as well with the same label, so the legend lists "Tangent parabola T₂(x)" twice (`tangparabaa.jl` lines 48–51 and 62–64). Both entries are the same curve, so this is redundant but not wrong.
- From about h = 0.178 (frame 7) on, the secant parabola cannot be told apart from T₂ at plot resolution: max |P−T₂| is 3.95e-3 on a 1.35-unit y-range, about 1 px. Mathews himself calls the graphical convergence "quite rapid". The page makes no claim that this contradicts.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `tangparabaa.jl` | 0 | 11.8 | tangparabaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| 1 | l.12 | animation shows the **secant parabola** (degree-2 Newton polynomial through $x_0-h, x_0, x_0+h$) | script l.22–31 uses nodes `x0-h, x0, x0+h` and the Newton divided-difference form; it reproduces the data at the nodes (residual ≤ 1.1e-16 for all 17 h); it matches an independent sympy Lagrange interpolant on the same nodes (coefficients identical to 6 d.p.) | confirmed |
| 2 | l.12 | converging to the **tangent parabola** (degree-2 Taylor polynomial at $x_0$) | script l.19 `T2 = f(x0)+f'(x0)(x-x0)+½f''(x0)(x-x0)²` with `d2f = -sin`; sympy `series(sin x, x, 1, 3)` gives coefficients 0.841471, 0.540302, −0.420735, which match the script | confirmed |
| 3 | l.12 | as $h\to 0$ | sympy `limit(L - T2, h→0) = 0`; max\|P_h−T₂\| on [0,π] falls 1.196e-1 (h=1) → 1.251e-3 (h=0.1) → 1.251e-5 (h=0.01), an O(h²) decrease | confirmed |
| 4 | l.12 | $f(x)=\sin(x)$ centered at $x_0=1$ | script l.11, l.15; frame titles and legend show `f(x) = sin(x)` and the x₀ line at 1 | confirmed |
| 5 | l.12 | "the running example of Mathews' module" | archive Figures 1–3 captions (gr_34–46): y = sin(x), x₀ = 1; Table 1 header "p(x, x₀, h) where x₀ = 1" | confirmed |
| 6 | l.12 | "the frames include its Figure 1 and Figure 2 step sizes $h = 0.1$ and $h = 0.01$" | archive captions: Fig. 1 h = 0.1, Fig. 2 h = 0.01, Fig. 3 h → 0, n = 2. Script `h_vals_log[9] = 0.10000000000000002`, `[17] = 0.010000000000000004`. Frame 9 title "h = 0.1" with nodes at 0.9, 1.0, 1.1; frame 17 title "h = 0.01" | confirmed |
| 7 | l.14 | Julia source scripts are linked under each case | l.20 `[Julia source](tangparabaa.jl)` exists and is the generating script | confirmed |
| 8 | l.16 heading | Case 1: secant → tangent parabola as $h\to0$, $f=\sin x$, $x_0=1$ | same as 1–4 | confirmed |
| 9 | l.18 | "For large $h$ the secant parabola is determined by three well-separated points" | frame 1 (h = 1.0): nodes at x = 0, 1, 2, all inside the [0, π] window and visibly separated | confirmed |
| 10 | l.18 | "As $h\to0$ all three nodes collapse to $x_0$" | frames 1→17: node spread 2h falls from 2.0 to 0.02; at frame 17 the markers overlap at x = 1 | confirmed |
| 11 | l.18 | "the secant parabola approaches the Taylor polynomial $T_2(x)=f(x_0)+f'(x_0)(x-x_0)+\tfrac12 f''(x_0)(x-x_0)^2$" | formula correct; convergence as in 3. Coefficients for Mathews' Table 1 step sizes are reproduced exactly (see §3) | confirmed |
| 12 | l.18 | "the Taylor polynomial is the limiting position of the Newton interpolating parabola" | symbolic limit = 0 (sympy) | confirmed |
| 13 | l.20, l.22 | link `tangparabaa.jl` and embed `tangparabaa.gif` are this case | the GIF is the only output of the script; the regenerated GIF is byte-identical to the committed one (md5 78178a99d50f7397c19fbb756c49b380 for both); the regen script is identical to the repo script (`diff`) | confirmed |
| 14 | l.22 alt | "Secant parabola (red dashed)" | `color=:tomato, linestyle=:dash` (l.46, 62) | confirmed |
| 15 | l.22 alt | "through three nodes" | `scatter!` of the 3 nodes (l.66–70) | confirmed |
| 16 | l.22 alt | "tangent parabola (green dotted, Taylor degree-2)" | `color=:darkgreen, linestyle=:dot` (l.63) | confirmed |
| 17 | l.22 alt | "as h shrinks from 1.0 to 0.01" | 17 log-spaced values, 1.0 → 0.01 (titles h = 1.0 … 0.01) | confirmed |
| 18 | l.22 alt | "followed by the tangent parabola alone" | frames 18–22: title "Tangent Parabola (T₂ — Taylor degree 2 at x₀)", no secant parabola and no nodes; sin(x) is still drawn as the reference, which "alone" does not exclude in context | confirmed |
| 19 | l.22 alt | "for sin(x) at x0=1" | as 4 | confirmed |
| 20 | l.24 | Mathews' Examples 3–5 "extend the construction to Newton polynomials of higher degree through equally spaced points starting at $x_0$" | archive Mathematica code (gr_198–199): `eqns = y[x0 + k*h] == f[x0 + k*h], {k,0,n}`, i.e. forward nodes x₀ + kh, starting at x₀ | confirmed |
| 21 | l.24 | "compare them with the Taylor polynomial of the same degree (the tangent cubic in Examples 3 and 4, a higher-degree tangent polynomial in Example 5)" | lnk_9 (Ex. 3) and lnk_10 (Ex. 4): "Newton cubic polynomials", compared with T₃; lnk_11 (Ex. 5): "Newton polynomials of degree 6" | confirmed |
| 22 | l.24 | "are not animated here" | the page has one case only | confirmed |
| 23 | Section index | page is linked from the section index | `pages/numerical-methods/index.qmd` l.69 | confirmed |

The page has no Description section (only Animations and a planned Derivation Notes stub), so there are no Description formulas beyond those in the Behavior paragraph, which are covered above.

**Fidelity summary.** The example function, centre, symmetric node layout x₀−h, x₀, x₀+h, the [0, π] plot window, the Figure 1 and 2 step sizes and the Figure 3 limiting case all match the archive. Mathews' Table 1 step sizes 0.3, 0.03, 0.003 and 0.001 are not frames, but the page does not claim they are; h = 1, 0.1 and 0.01 are frames. Examples 3–5 (higher degree) are dropped, but the page says so explicitly on l.24, so the omission is not silent. No fidelity finding.

### 3. Implementation checks: `tangparabaa.jl`

**It is the method it claims to be.** `newton_parabola` (l.22–31) builds the divided differences `d01`, `d12` and `d012` over the nodes (x₀−h, x₀, x₀+h) and evaluates P(x) = y₁ + d01(x−x₁) + d012(x−x₁)(x−x₂). That is the degree-2 Newton interpolating polynomial. Mathews writes the same interpolant expanded about x₀ (his formula (4)); by uniqueness it is the same polynomial. `T2` (l.19) is the degree-2 Taylor polynomial with f'' = −sin. This is the construction the page names.

**The numbers are right.** I instrumented a copy that keeps script lines 1–38 verbatim (`review/instr.jl`, output `review/instr.out`). I set it beside an independent sympy/mpmath computation that uses the Lagrange form over the same nodes (`review/indep.py`, output `review/indep.out`), and beside Mathews' Table 1 (gr_119):

| h | script c1, c2 (in powers of x−1) | independent (sympy Lagrange) | Mathews Table 1 | script max\|P−T₂\| on [0,π] | independent |
|---|---|---|---|---|---|
| 1.0 | 0.454649, −0.386822 | 0.454649, −0.386822 | 0.454649, −0.386822 | 1.196e-1 | 1.1957e-1 |
| 0.3 | 0.532234, −0.417589 | 0.532234, −0.417589 | 0.532234, −0.417589 | 1.121e-2 | 1.1214e-2 |
| 0.1 | 0.539402, −0.420385 | 0.539402, −0.420385 | 0.539402, −0.420385 | 1.251e-3 | 1.2505e-3 |
| 0.03 | 0.540221, −0.420704 | 0.540221, −0.420704 | 0.540221, −0.420704 | 1.126e-4 | 1.1260e-4 |
| 0.01 | 0.540293, −0.420732 | 0.540293, −0.420732 | 0.540293, −0.420732 | 1.251e-5 | 1.2511e-5 |
| 0.003 | 0.540301, −0.420735 | 0.540301, −0.420735 | 0.540301, −0.420735 | 1.126e-6 | 1.1260e-6 |
| 0.001 | 0.540302, −0.420735 | 0.540302, −0.420735 | 0.540302, −0.420735 | 1.251e-7 | 1.2521e-7 |

c0 = 0.841471 in every row. Property checks:
- **Interpolation at the nodes.** The residual is ≤ 1.1e-16 for all 17 animated h.
- **Order of convergence.** The error ratio is exactly 100 for h 0.1 → 0.01, consistent with O(h²) for centred differences.
- **Limit.** The symbolic limit of (L − T₂) as h → 0 is 0.

**Its reference values are right.** T₂ coefficients (sin 1, cos 1, −sin 1 / 2) = (0.841471, 0.540302, −0.420735), from both the script and a sympy Taylor series. These are also Mathews' limiting Table 1 row. T₂ on [0, π] ranges from −0.1196 (at x = 0) to 1.0149, and T₂(π) = 0.0689. Both T₂ and sin x stay inside `ylims = (-0.2, 1.15)`, so nothing is clipped.

**The picture shows what was computed.**
- The `h_vals_log` grid is 10^(−k/8) for k = 0..16, matching the comment on l.33. Rounded to 3 places the labels are 1.0, 0.75, 0.562, 0.422, 0.316, 0.237, 0.178, 0.133, 0.1, 0.075, 0.056, 0.042, 0.032, 0.024, 0.018, 0.013 and 0.01 (checked independently in Python). They are followed by 5 hold frames, for 22 in all, which matches the committed GIF's 22 frames.
- I viewed the contact sheet (frames 1, 3, …, 17 and two hold frames) and frames 1, 9 and 22 at full size. The h titles appear on the expected odd frames. Nodes are at (0, 1, 2) in frame 1 and (0.9, 1.0, 1.1) in frame 9. The secant parabola passes through the nodes. The x₀ line is at 1, and the window is [0, π] as in Mathews' figures.
- The hold frames show T₂ only, with the title naming T₂.
- No clamping or NaN masking is used, and nothing relevant falls outside the window.
- Regeneration: the scratch run exits 0, and its GIF is byte-identical to the committed GIF (md5 above).
- Only issue seen: the duplicate T₂ legend entry in the hold frames (cosmetic; see §1).

