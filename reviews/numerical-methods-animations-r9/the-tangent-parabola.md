# The Tangent Parabola — animation review (round 9)

Page: `pages/numerical-methods/the-tangent-parabola/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Counts: Error 0, Misleading 0, Minor 0.

Things considered and deliberately not reported:
- From h ≈ 0.178 (frame 7) onward the secant parabola and T₂ differ by at most 0.004 on [0, π] (about 1 px at this plot scale), so 11 of the 17 secant frames show the two curves overlapping and only the nodes visibly moving. This is the rapid graphical convergence Mathews himself describes ("graphical convergence, which is quite rapid"); the page claims nothing that this contradicts.
- Mathews' Examples 3–5 (Newton cubic / degree-6 polynomials for f(x) = e^{x/4} cos x at x₀ = 0) are not animated, but the page says so explicitly (line 16), so this is not a silent drop.
- Script header line 3 cites "Figures 1–3 and Table 1"; Table 1's h = 0.3, 0.03, 0.003, 0.001 are not frames, but the comment is a source citation, not a claim about the frames; the h = 1.0, 0.1, 0.01 rows of Table 1 are frames and match (see §3).



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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | l.12 | secant parabola is the "degree-2 Newton polynomial through x₀ − h, x₀, x₀ + h" | script l.22–31 builds Newton divided differences on exactly those nodes; node residual ≤ 1.1e-16 at all 17 h | confirmed |
| 2 | l.12 | converges to the tangent parabola (degree-2 Taylor polynomial at x₀) as h → 0 | sympy: lim_{h→0} interpolant − [sin a + cos a (x−a) − ½ sin a (x−a)²] = 0; numeric max\|P−T₂\| on [0,π] falls 0.1196 → 1.25e-5, ratio 100.0 between h=0.1 and h=0.01 (O(h²)) | confirmed |
| 3 | l.12 | f(x) = sin(x), x₀ = 1 | script l.11, l.15; title/legend "f(x) = sin(x)", vline at x = 1 in frames | confirmed |
| 4 | l.12 | "the running example of Mathews' module" | archive formula images: y = sin(x), x₀ = 1 for Figures 1–3 and Table 1 | confirmed |
| 5 | l.12 | "frames include its Figure 1 and Figure 2 step sizes h = 0.1 and h = 0.01" | archive: Fig. 1 h = 0.1, Fig. 2 h = 0.01; script frames 9 (h = 0.10000000000000002, title "h = 0.1") and 17 (h = 0.010000000000000004, title "h = 0.01") | confirmed |
| 6 | l.14 | Julia source linked under each case | l.22 links `tangparabaa.jl`, the only script | confirmed |
| 7 | l.16 | Mathews' Examples 3–5 extend to higher-degree Newton polynomials through equally spaced points starting at x₀, compared with the same-degree Taylor polynomial | archive: `Do[eqns[[k+1]] = y[x0+k*h] == f[x0+k*h], {k,0,n}]`, n = 3 (Ex. 3, 4), degree 6, k = 0..6 (Ex. 5); each compared with Taylor polynomial | confirmed |
| 8 | l.16 | tangent cubic in Examples 3 and 4, higher-degree tangent polynomial in Example 5 | archive: Ex. 3 "Newton cubic polynomials… compare with Taylor polynomial", Ex. 4 "sequence of Newton cubic polynomials", Ex. 5 "Newton polynomials of degree 6" | confirmed |
| 9 | l.16 | Examples 3–5 "are not animated here" | only one script/GIF, Case 1 = sin(x), degree 2 | confirmed |
| 10 | l.18 heading | Case 1: secant → tangent parabola as h → 0, f = sin(x), x₀ = 1 | script parameters; frames | confirmed |
| 11 | l.20 | "For large h the secant parabola is determined by three well-separated points" | frame 1: nodes at x = 0, 1, 2 (y = 0, 0.841, 0.909 = sin values) | confirmed |
| 12 | l.20 | "As h → 0 all three nodes collapse to x₀" | frames 1→17: node spread 2 → 0.02, centered on x = 1 | confirmed |
| 13 | l.20 | secant parabola approaches T₂(x) = f(x₀) + f′(x₀)(x−x₀) + ½f″(x₀)(x−x₀)² | coefficients (x−1 basis) at h = 0.01: 0.8414709848, 0.5402933009, −0.4207319863 vs T₂ 0.8414709848, 0.5403023059, −0.4207354924; formula is the correct Taylor polynomial; script T2 l.19 matches it | confirmed |
| 14 | l.20 | "the Taylor polynomial is the limiting position of the Newton interpolating parabola" | as #2 | confirmed |
| 15 | l.22 | [Julia source](tangparabaa.jl) is this case | file exists, produces `tangparabaa.gif` | confirmed |
| 16 | l.24 embed | `tangparabaa.gif` is this case | committed GIF byte-identical to regenerated output of `tangparabaa.jl` (manifest) | confirmed |
| 17 | l.24 alt | "Secant parabola (red dashed) through three nodes" | script: `:tomato`, `:dash`, scatter of 3 nodes in tomato | confirmed |
| 18 | l.24 alt | "tangent parabola (green dotted, Taylor degree-2)" | script: `:darkgreen`, `:dot`, T₂ | confirmed |
| 19 | l.24 alt | "as h shrinks from 1.0 to 0.01" | h = 10^(−k/8), k = 0..16: 1.0 … 0.01 (frames 1–17) | confirmed |
| 20 | l.24 alt | "followed by the tangent parabola alone" | frames 18–22: identical (one MD5 ×5), no secant/nodes, title "Tangent Parabola (T₂ — Taylor degree 2 at x₀)", f(x) still drawn for reference | confirmed |
| 21 | l.24 alt | "for sin(x) at x0=1" | as #3 | confirmed |

No Description section with formulas exists on the page (only Animations and a placeholder "Derivation Notes (Planned)", excluded per brief). Section index linkage: confirmed by manifest.

### 3. Implementation checks — `tangparabaa.jl`

**Method it claims to be.** Quadratic interpolant via Newton divided differences on nodes x₀−h, x₀, x₀+h (l.22–31): d01, d12, d012 = (d12−d01)/(x3−x1), P = y1 + d01(x−x1) + d012(x−x1)(x−x2). This is the Newton form; by uniqueness of the degree-2 interpolant it equals Mathews' formula (4), p(x) = f(x₀) + [f(x₀+h)−f(x₀−h)]/(2h)(x−x₀) + [f(x₀+h)−2f(x₀)+f(x₀−h)]/(2h²)(x−x₀)², which uses the same symmetric nodes (archive images confirm (x₀−h), (x₀), (x₀+h)). The coefficient comparison below confirms numerically. T₂ (l.19) is the correct degree-2 Taylor polynomial with f′ = cos, f″ = −sin (l.12–13).

**Numbers.** Instrumented copy (`review/tangparabaa_instr.jl`, output `instr.out`) printed (x−1)-basis coefficients and max|P−T₂| on the script's 500-point grid; independent mpmath (40 digits) Vandermonde solve on the same nodes (`indep.py`, `indep.out`):

| frame | h | script a1 | independent a1 | script a2 | independent a2 | script max\|P−T₂\| | indep. |
|---|---|---|---|---|---|---|---|
| 1 | 1.0 | 0.45464871341284085 | 0.4546487134128408 | −0.38682227139505565 | −0.3868222713950557 | 0.119567 | 0.119567 |
| 5 | 0.3162 | 0.5313421855750787 | 0.5313421855750788 | −0.41724102955094855 | −0.4172410295509483 | 0.0124546 | 0.0124546 |
| 9 | 0.1 | 0.5394022521697599 | 0.5394022521697598 | −0.4203849963437115 | −0.4203849963437142 | 0.00125055 | 0.00125055 |
| 13 | 0.03162 | 0.54021225998624 | 0.5402122599862404 | −0.42070043228156906 | −0.4207004322816034 | 1.25106e-4 | 1.25106e-4 |
| 17 | 0.01 | 0.540293300874733 | 0.5402933008747337 | −0.4207319862864485 | −0.420731986286532 | 1.25111e-5 | 1.25111e-5 |

All 17 frames agree to ≤ 1e-14 in a1 and ≤ 1e-13 in a2 (float64 cancellation in the second difference at small h, harmless). a0 = 0.8414709848078965 = sin 1 in every frame. Interpolation property: node residual ≤ 1.1e-16 at every h. Convergence order: max|P−T₂| ratio for each factor-10 in h ≈ 100 (0.119567 / 0.00125055 at h=1→0.1 is 95.6; 0.00125055 / 1.25111e-5 = 99.96), i.e. O(h²) as expected.

Independent check against Mathews' Table 1 (mpmath, 6 s.f.): h = 1.0 → 0.454649, −0.386822; h = 0.1 → 0.539402, −0.420385; h = 0.01 → 0.540293, −0.420732 — identical to the archive table and to the script.

**Reference values.** T₂ coefficients printed by the script: 0.8414709848078965, 0.5403023058681398, −0.42073549240394825; independent: sin 1, cos 1, −sin(1)/2 = 0.8414709848078965, 0.5403023058681397, −0.4207354924039483. Sympy symbolic limit of the 3-node interpolant as h → 0 minus T₂ simplifies to 0. f = sin is plotted exactly.

**Picture vs computation.** Frames 1, 9, 17, 18–22 and the contact sheet viewed. Nodes are drawn at (x₀±h, sin(x₀±h)) and (x₀, sin x₀) from the same h as the curve; frame 1 shows nodes at x = 0, 1, 2 on the blue sin curve. Title and legend h label = round(h, 3), matching the plotted h (1.0, 0.75, 0.562, …, 0.1, …, 0.013, 0.01). Axis window x ∈ [0, π] (Mathews' window, confirmed by archive Figures 1–3), y ∈ [−0.2, 1.15]; independent range of all plotted secant curves is [−0.11955, 1.01493] and T₂ ∈ [−0.11957, 1.0149], so nothing is clipped. No clamping or NaN masking. Legend at bottom sits over x ≈ 1–2.1, y ≈ −0.18–0.07, where no curve passes. Frame structure: 17 distinct secant frames + 5 identical hold frames (frame MD5s), 4 fps. Hold frames suppress the secant curve and nodes and draw T₂ once, as the alt text says.

**Run.** Scratch copy run per manifest: exit 0, 11.0 s; committed GIF byte-identical to regenerated output.

