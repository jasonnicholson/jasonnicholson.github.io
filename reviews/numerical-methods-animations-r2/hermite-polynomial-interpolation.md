# Hermite Polynomial Interpolation — animation review (round 2)

Page: `pages/numerical-methods/hermite-polynomial-interpolation/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1. Implementation, Minor: the "slope markers" in Case 1 do not show slope
- **Location:** `hermitepolyaa.jl` lines 62-69:
  ```julia
  # Show slope markers as short arrows at each node
  for i in eachindex(xs_nodes)
      dx_arrow = 0.15
      x0, y0 = xs_nodes[i], ys[i]
      slope = dys[i]
      annotate!(x0, y0, text("→", :center, :gray, 8))   # lightweight indicator
  end
  ```
  Also `hermitepolybb.jl` line 51 (`# Endpoint markers with slope arrows`), where no arrow is drawn, and line 30 (`# Frames: show basis functions one at a time, then cumulative sum`). In fact each frame draws only the running sum, never a basis function by itself.
- **What is there now:** `slope` and `dx_arrow` are computed but never used. The glyph is a horizontal gray "→" of fixed size centred on every node. Whatever f'(xᵢ) is, it points horizontally. At the node x = π the slope is −1, but the glyph is still horizontal. In the frames the glyph is almost completely hidden behind the black node dot (`review/crop_node_pi.png`). At x = 2π it sticks out past the right edge of the plot box as a small stray gray arrow (`review/crop_node_2pi.png`, frames 1-4).
- **What is true instead:** nothing in either animation draws the derivative data. The comments in the published source claim that it does.
- **How I know:** I read the code (the variables are unused) and zoomed into the committed frames with PIL crops of `committed/hermitepolyaa/frame_002.png` at the nodes x = π and x = 2π.
- **Why only Minor:** the page text never mentions slope arrows, and the glyph is practically invisible. So the animation is not misleading. The defect is a source comment that misdescribes the picture, plus the stray glyph at x = 2π.
- **Suggested correction:** either delete the loop and its comment in `hermitepolyaa.jl` and fix the two comments in `hermitepolybb.jl`, or draw real tangent segments. For example: `plot!([x0-dx_arrow, x0+dx_arrow], [y0-slope*dx_arrow, y0+slope*dx_arrow]; color=:gray, lw=2, label=(i==1 ? "slope f′(xᵢ)" : ""))`. Doing the same at the two endpoints in Case 2 would make the "matches the slope there" claim visible.

- **Independent check:** not run (Minor finding, unverified)

### F2. Fidelity, Minor: Mathews' only Hermite worked example is dropped without mention
- **Location:** the whole Animations section of `index.qmd` (lines 20-40). The two cases are sin(x) on [0, 2π] and eˣ on [0, 1].
- **What is there now:** neither case uses the archive's example. The page says nothing about where its examples come from, beyond "Source inspiration: [@mathewsSite]".
- **What the archive has:** `HermitePolyMod.html` has no animation. Its one Hermite example (Example 1, `lnk_2.html`, data image `gr_18.gif`) is the clamped cubic with p(1) = 2, p′(1) = 1, p(3) = 1, p′(3) = 2, graphed on [1, 3] in `gr_31.gif`. I solved it independently with sympy: p(x) = x³ − 23x²/4 + 19x/2 − 11/4. Examples 2 and 3 are the clamped and natural cubic splines. Those belong to the site's separate `cubic-splines` page, so leaving them out here is reasonable.
- **Why it matters a little:** the page conventions (`.github/agents/animation-page.agent.md` lines 13-14 and 71) say that when there is no legacy GIF, the parameters should come from the worked examples. Mathews' example is a compact case where the slopes clearly differ from those of the chord, and a reader comparing the page with its cited source will not find it. The page's own examples are mathematically sound, so this is a gap and not an error.
- **Suggested correction:** either add a case for Mathews' Example 1 (the cubic above, drawn with its endpoint tangent segments), or add one sentence saying the animations use sin x and eˣ in place of Mathews' worked example.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `hermitepolyaa.jl` | 0 | 5.3 | hermitepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `hermitepolybb.jl` | 0 | 5.9 | hermitepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `hermitepolyaa.gif` | 4 | byte-identical | hermitepolyaa |
| `hermitepolybb.gif` | 4 | byte-identical | hermitepolybb |

### Page references

- Scripts linked: `hermitepolyaa.jl`, `hermitepolybb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Page text (location) | Check | Verdict |
|---|---|---|---|
| D1 | "For two endpoints x₀,x₁ with h=x₁−x₀ and t=(x−x₀)/h, the cubic Hermite interpolant is H(x)=y₀H₀₀(t)+hy₀′H₁₀(t)+y₁H₀₁(t)+hy₁′H₁₁(t)" (Description) | It is the formula in both scripts (aa lines 25-31, bb lines 20-28). The sympy table shows H₀₀,H₁₀,H₀₁,H₁₁ are the cardinal basis for (value at 0, slope at 0, value at 1, slope at 1). The chain-rule factor h on the derivative terms is correct. | confirmed |
| D2 | "where H₀₀,…,H₁₁ are the standard cubic Hermite basis functions" | Script definitions 2t³−3t²+1, t³−2t²+t, −2t³+3t², t³−t². Cardinal property verified (table in §3). | confirmed |
| D3 | "In piecewise form … gives a smooth C¹ approximation that preserves both value and slope information at each node" | Neighbouring pieces share yᵢ and yᵢ′ at each node by the cardinal property, so the result is C¹. The script reproduces nodal values exactly (max deviation 0.0). The script agrees with scipy `CubicHermiteSpline` (C¹ by construction) in max error to 7+ significant figures. | confirmed |
| A1 | "These animations illustrate the cubic Hermite polynomial, which interpolates both function values and first derivatives at the endpoint nodes." | Both scripts. | confirmed |
| A2 | "Unlike ordinary polynomial interpolation, Hermite interpolation matches the slope at each node, giving a smoother fit." | It matches slopes (verified). "Smoother fit" is qualitative and is true of the C¹ piecewise form. | confirmed |
| A3 | "Julia source scripts … are linked under each case." | Two links, one under each case. | confirmed |
| C1-H | Case 1 heading: "Piecewise cubic Hermite for sin(x), refining the mesh" | aa: f = sin, f′ = cos, uniform nodes, n = 1, 2, 4, 8. | confirmed |
| C1-1 | "uses n subintervals, each carrying a cubic polynomial that matches f and f′ at its two endpoints" | `hermite_eval` (aa lines 18-34) with nodes `range(0,2π,length=n+1)`. | confirmed |
| C1-2 | "The maximum errors in the four frames are 0.425, 0.215, 0.0108 and 0.000906" | Script (instrumented): 0.42537, 0.21460, 0.010791, 0.00090620. Independent scipy on the same 600-point grid: 0.425375, 0.214601, 0.0107905, 0.000906198. On a dense 2,000,001-point grid: 0.425382, 0.214602, 0.0107907, 0.000906216. The frame titles show the same four values. | confirmed |
| C1-3 | "the doublings shown divide the error by about 2.0, 19.9 and 11.9" | Independent: 1.982, 19.89, 11.91 (both grids). | confirmed |
| C1-4 | "For smooth f the error is O(h⁴)" | Standard result. The ratios computed below tend to 16. | confirmed |
| C1-5 | "these coarse meshes are not yet in the asymptotic range; the ratio approaches 2⁴ = 16 only on finer meshes (15.0 for n = 8→16, 15.7 for 16→32, 15.9 for 32→64)" | Independent: 14.96, 15.74, 15.94 (600-point grid); 14.96, 15.74, 15.93 (dense). | confirmed |
| C1-alt | "Piecewise cubic Hermite interpolation of sin(x) on 0 to 2pi, showing n=1,2,4,8 intervals; the maximum error falls from 0.425 at n=1 to 0.000906 at n=8" | Script parameters, frames 1 and 4 titles, and the numbers above. | confirmed |
| C1-link | `[Julia source](hermitepolyaa.jl)`, embed `hermitepolyaa.gif` | The file exists. The GIF is byte-identical to a scratch regeneration of this script (manifest). It has 4 frames, n = 1, 2, 4, 8. | confirmed |
| C2-H | Case 2 heading: "Hermite basis functions building the interpolant of eˣ on [0,1]" | bb: f = f′ = exp, a = 0, b = 1. | confirmed |
| C2-1 | "The four … basis functions each carry one degree of freedom (a value or derivative at an endpoint)." | sympy cardinal table (§3). | confirmed |
| C2-2 | "Their weighted combination H(x)=y₀H₀₀+hy₀′H₁₀+y₁H₀₁+hy₁′H₁₁ equals the true function at both endpoints and matches the slope there." | sympy on the full sum: H(0) = 1, H′(0) = 1, H(1) = e, H′(1) = e. Script finite differences: slope ≈ 1.0011 at 0 and ≈ 2.7151 at 1 (one-sided, step 1/399). Max interpolation error 0.004371 (script 0.0043710, independent 0.0043710). | confirmed |
| C2-3 | "The frames add the weighted terms one at a time and draw the running sum" | `stages` (bb lines 31-36) plots term1, term1+term2, …, all four. The 4 frames show these, with titles "y₀·H₀₀(t)", "+ h·y₀′·H₁₀(t)", "+ y₁·H₀₁(t)", "+ h·y₁′·H₁₁(t) = H(x)". | confirmed |
| C2-4 | "the first two partial sums fall to 0 with zero slope at x = 1, because H₀₀ and H₁₀ have zero value and zero slope there" | sympy: S₁(1) = 0, S₁′(1) = 0; S₂(1) = 0, S₂′(1) = 0. H₀₀ and H₁₀ both have value 0 and slope 0 at t = 1. Frames 1-2 show the curves meeting y = 0 tangentially at x = 1, inside ylims (−0.2, 3). | confirmed |
| C2-alt | "Running sum of the four weighted Hermite basis terms for e^x on [0,1], adding one term per frame until it forms the complete cubic Hermite interpolant" | As in C2-3. Frame 4 is visually on top of eˣ (error 0.0044 is less than one pixel at 3.2/≈400 px). | confirmed |
| C2-link | `[Julia source](hermitepolybb.jl)`, embed `hermitepolybb.gif` | The file exists. The GIF is byte-identical to the regeneration and has 4 frames. | confirmed |
| W | Counts: two cases, four frames each | Manifest frame counts 4 and 4. The contact sheets agree. | confirmed |

---

### 3. Implementation checks

### `hermitepolyaa.jl` (Case 1)
- **Method:** this is piecewise cubic Hermite interpolation (local, C¹, with exact derivatives cos xᵢ), the method the page names. It is not a spline (no C² coupling) and not a monotone or estimated-slope variant such as PCHIP. Interval lookup uses `searchsortedlast` clamped to [1, n], so x = 2π is evaluated on the last piece with t = 1, which is correct.
- **Numbers:** I made an instrumented copy (`review/inst_aa.jl`, which prints the error and the nodal reproduction and writes `inst_aa.gif`) and compared it with an independent scipy `CubicHermiteSpline` (`review/indep.py`):

  | n | script max err (600 pts) | scipy, same grid | scipy, 2,000,001 pts | nodal reproduction |
  |---|---|---|---|---|
  | 1 | 0.4253745914738841 | 0.425375 | 0.425382 | 0.0 |
  | 2 | 0.21460058715876607 | 0.214601 | 0.214602 | 0.0 |
  | 4 | 0.01079052009607473 | 0.0107905 | 0.0107907 | 0.0 |
  | 8 | 0.0009061984969647163 | 0.000906198 | 0.000906216 | 0.0 |

  Further meshes (scipy): n = 16, 6.0584e-5; n = 32, 3.8486e-6; n = 64, 2.4148e-7. The ratios 14.96, 15.74, 15.94 tend to 16, which confirms order h⁴. The sampling grid does not affect any value at 3 significant figures.
- **Reference values:** the reference curve is sin(x) itself, and its derivative is cos(x). Both are exact.
- **Picture:** frames 1-4 show sin (blue), H (red dashed) and the nodes (black). The node count is n + 1 in each frame. Titles report the right n and the error rounded to 3 significant figures. ylims (−1.4, 1.4) contain everything: for n = 1 the minimum of H is about −0.60, which I read from the frame and which is consistent with the error 0.425 near the trough. No clamping and no masking. The only defect is the non-functional "→" slope glyph (F1).

### `hermitepolybb.jl` (Case 2)
- **Method:** a single-interval cubic Hermite interpolant in the standard basis form, the form the Description and Case 2 text give.
- **Numbers:** the instrumented copy (`review/inst_bb.jl`) prints each partial sum's endpoint values, extrema and one-sided slopes:

  | stage | S(0) | S(1) | min | max | slope at 0 (FD) | slope at 1 (FD) |
  |---|---|---|---|---|---|---|
  | y₀H₀₀ | 1.0 | 0.0 | 0.0 | 1.0 | −0.0075 (true 0) | −0.0075 (true 0) |
  | +hy₀′H₁₀ | 1.0 | 0.0 | 0.0 | 1.0535 | 0.9875 (true 1) | −0.0100 (true 0) |
  | +y₁H₀₁ | 1.0 | e | 1.0 | e | 1.0079 (true 1) | 0.0104 (true 0) |
  | +hy₁′H₁₁ | 1.0 | e | 1.0 | e | 1.0011 (true 1) | 2.7151 (true e) |

  The "true" values come from the independent sympy computation (S(0), S′(0), S(1), S′(1) for each partial sum, and the maximum of S₂ is 1.053493 on a 401-point grid). The finite-difference slopes differ only by the O(Δx) error of a one-sided difference. Max |H − eˣ| is 0.0043710 in the script and 0.0043710 independently.
- **Basis (sympy, values [H(0), H′(0), H(1), H′(1)]):** H₀₀ [1,0,0,0]; H₁₀ [0,1,0,0]; H₀₁ [0,0,1,0]; H₁₁ [0,0,0,1].
- **Reference:** eˣ, exact.
- **Picture:** the four frames match the stage list. Titles and legend entries name the term just added. The curve is the running sum. ylims (−0.2, 3.0) keep the zero-touching partial sums and e ≈ 2.718 in view. The endpoint markers sit at (0, 1) and (1, e). There are no slope arrows, in spite of the comment on line 51, and the line-30 comment says basis functions are shown individually when they are not (F1).

### Regeneration
Both scripts reproduce the committed GIFs byte-for-byte (per the manifest). My instrumented copies ran cleanly and wrote only into the scratch folder.

