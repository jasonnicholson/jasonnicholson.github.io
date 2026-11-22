# Halley's Method — animation review (round 3)

Page: `pages/numerical-methods/halleys-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Page match (Description, Trade-offs). Minor
- **Location:** `index.qmd` line 40: "for high-precision arithmetic (e.g., computing $\sqrt{2}$ to hundreds of digits), Halley's cubic rate makes it significantly faster overall."
- **What is there:** a flat claim that Halley is significantly faster overall in high precision, using √2 as the example.
- **What is true:** the sentence just before it sets the page's own cost model: three evaluations per Halley step against two per Newton step. Under that model the efficiency indices are 3^(1/3) ≈ 1.442 for Halley and 2^(1/2) ≈ 1.414 for Newton, a gain of about 2%, which is not "significantly faster". I timed √2 by the generic f, f′, f″ formulas in mpmath at fixed precision (`/usr/bin/python3 -I timing.py`):
  - 500 digits: Newton 10 iterations, 0.0002 s; Halley 6 iterations, 0.0002 s.
  - 20,000 digits: Newton 15 iterations, 0.047 s; Halley 10 iterations, 0.054 s.
  - 200,000 digits: Newton 18 iterations, 2.09 s; Halley 12 iterations, 2.39 s.

  Halley takes fewer iterations but is no faster, and is slightly slower in wall time. Whether Halley wins depends on the cost model, for example a specialised sqrt formula or precision doubling. The page states the conclusion without that qualification, and its own √2 example does not support it. Mathews claims only that Halley is "faster" in iteration count.
- **Suggested correction:** say that Halley needs about log 2 / log 3 ≈ 0.63 times as many iterations as Newton. Whether that saves time depends on how expensive f″ and the extra arithmetic are, and with three evaluations per step against two the efficiency index improves only from √2 ≈ 1.414 to ∛3 ≈ 1.442. Alternatively, drop "significantly faster overall".

No other findings.

**Checked and not a finding:**
- `halleysba.jl` line 64 clamps the tangent to `ylims`. The clamped parts run exactly along the plot-box border (bottom edge for x ∈ [−3, −2.45] in frame 1, top edge to the right). Enlarged crops `crop_bl.png` and `crop_top.png` show them merged with the frame line, so a viewer would not read them as part of the tangent.
- In Case 2, frames 3–6 look identical, and so do frames 3–7 of Case 1a and frames 3–5 of Case 1b, because the iterates have converged at plot scale. The page makes no claim about frame counts.
- The Case 1b final-frame alt text says "both next iterates marked". No markers appear on the last frame, by design.
- Fidelity: Mathews Example 2(a) is not animated. The page says so explicitly in lines 72–73, so this is not a silent drop.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `halleysaa.jl` | 0 | 9.1 | halleysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysab.jl` | 0 | 6.7 | halleysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysba.jl` | 0 | 7.2 | halleysba.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `halleysaa.gif` | 7 | byte-identical | halleysaa |
| `halleysab.gif` | 5 | byte-identical | halleysab |
| `halleysba.gif` | 6 | byte-identical | halleysba |

### Page references

- Scripts linked: `halleysaa.jl`, `halleysab.jl`, `halleysba.jl`
- GIFs embedded: 3
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Halley fits an osculating hyperbola $y=(a+b(x-x_n))/(1+c(x-x_n))$ that matches f, f′, f″ at x_n and takes its x-intercept as x_{n+1} | sympy derivation: c = −f″/(2f′), slope coefficient f′+fc, and the root equals the Halley formula. `hyp.jl` gives H = f, H′ ≈ f′, H″ ≈ f″ (finite differences to 1e-7) and root = Halley iterate exactly, at 6 iterates | confirmed |
| D2 | Description | Root of the Taylor parabola gives a different iteration, Halley's irrational method | Standard terminology; the parabola root involves a square root, so it differs from the rational formula | confirmed |
| D3 | Description | Cubic convergence at simple roots; digits roughly triple vs double for Newton | Case 1b digits 0.23 → 1.84 → 6.44 → 20.2 → 61.6; Newton 0.23 → 1.07 → 2.61 → 5.67 → 11.8 → 24.1 | confirmed |
| D4 | Iteration formula | $x_{n+1}=x_n-2ff'/(2f'^2-ff'')$ | Matches the scripts (lines 32) and Mathews' h(x) (gr_181 / Mod image) | confirmed |
| D5 | Iteration formula | Equivalent Newton-correction form $\frac{f}{f'}\cdot 1/(1-ff''/(2f'^2))$ | Algebra: multiply num/den by 2f′; identical to Mathews' `h[x_]` | confirmed |
| D6 | Iteration formula | Correction factor → 1 near a simple root | f → 0 while f′ ≠ 0 | confirmed |
| D7 | Convergence | $|e_{n+1}|\approx C|e_n|^3$, $C=|f'''/(6f') - f''^2/(4f'^2)|$ | sympy series of the Halley map: e_{n+1} = e³(f″²/4 − f′f‴/6)/f′² + O(e⁴); difference from page's C simplifies to 0 | confirmed |
| D8 | Convergence | At a multiple root of order m≥2 the method is linear | sympy: lim e_{n+1}/e_n = 1/3 (m=2), 1/2 (m=3) | confirmed |
| D9 | Trade-offs | Three evaluations (f, f′, f″) vs two for Newton | Definition | confirmed |
| D10 | Trade-offs | For high precision (√2 to hundreds of digits), Halley "significantly faster overall" | Efficiency index 1.442 vs 1.414; timing shows parity at 500 digits and Halley slower at 2e4 and 2e5 digits | wrong (overstated), F1 |
| A1 | Intro | Case 1a: Newton tangent construction alone, tangent blue dashed | `halleysaa.jl` l.52 steelblue `ls=:dash`; frames show only tangent | confirmed |
| A2 | Intro | Cases 1b/2: current iterate marked on curve | red dot at (x_n, f(x_n)) l.71 both scripts; frames | confirmed |
| A3 | Intro | Tangent blue dotted shows where Newton would jump | steelblue `ls=:dot`; tangent root = blue diamond = x_n − f/f′ | confirmed |
| A4 | Intro | Osculating hyperbola (orange dashed) crosses x-axis at Halley iterate x_{n+1} | darkorange `ls=:dash`; hyperbola root = xs[n+1] bit-exactly (`hyp.jl`); frame 1 of 1b and 2 show the curve through the orange diamond | confirmed |
| A5 | Intro | Julia scripts linked under each case | three `[Julia source]` links, each to the matching script | confirmed |
| 1a-1 | Heading | f(x)=x²−2, x₀=2 | `halleysaa.jl` l.10, 13; title in frames | confirmed |
| 1a-2 | Behavior | Tangent at each iterate intersects the x-axis to produce next iterate | code l.49–52; frames 1–2 | confirmed |
| 1a-3 | Behavior | Converges quadratically to √2 ≈ 1.41421, digits roughly double | errors 5.9e-1, 8.6e-2, 2.5e-3, 2.1e-6, 1.6e-12, 9.0e-25 | confirmed |
| 1a-4 | Behavior | x₁ = 1.5, x₂ ≈ 1.4167, x₃ ≈ 1.4142 | script: 1.5, 1.4166666666666667, 1.4142156862745099; mpmath identical | confirmed |
| 1a-5 | Alt | Each frame advances one tangent-line step | 7 frames = x₀…x₆, one tangent each | confirmed |
| 1b-1 | Heading | Halley, f=x²−2, x₀=2 | `halleysab.jl` l.10–14 | confirmed |
| 1b-2 | Behavior | Uses f′ and f″ to correct the Newton step | l.32 | confirmed |
| 1b-3 | Behavior | Orange diamond = Halley iterate; blue diamond = Newton landing | l.82–87; frame 1 orange at 1.428571, blue at 1.5 | confirmed |
| 1b-4 | Behavior | x₁ ≈ 1.42857 vs Newton x₁ = 1.5 | 2 − 16/28 = 1.4285714…; script 1.4285714285714286 | confirmed |
| 1b-5 | Behavior | Accurate digits ≈ 1.8, 6.4, 20 after steps 1–3 (extended precision) | mpmath (200 dps): 1.843, 6.438, 20.22 | confirmed |
| 1b-6 | Behavior | Error governed by \|g‴(x*)\|/3! rather than \|g″(x*)\|/2! | Halley map series has no e, e² terms; e³ coefficient = C = 0.125 for this f; observed e₂/e₁³ = 3.644e-7/(0.014358)³ = 0.123 | confirmed |
| 1b-7 | Alt | Frames show hyperbola, Newton tangent, both next iterates on x-axis | frames 1–4 (final frame has none, by design) | confirmed |
| 2-1 | Heading | f=x³−3x+2, x₀=−2.2 | `halleysba.jl` l.10, 14 | confirmed |
| 2-2 | Behavior | f=(x+2)(x−1)², simple root −2, double root 1 | expand: x³−3x+2 ✓; f′(−2)=9≠0, f(1)=f′(1)=0, f″(1)=6≠0 | confirmed |
| 2-3 | Behavior | Halley converges cubically from −2.2 | errors 0.2, 2.06e-3, 2.91e-9, 8.25e-27; e_{n+1}/e_n³ = 0.258, 0.333, 0.333 → C = 1/3 (formula gives 0.33333) | confirmed |
| 2-4 | Behavior | First Halley step x₁ ≈ −2.002; Newton x₁ ≈ −2.022 | −2.0020618556701, −2.0222222222 | confirmed |
| 2-5 | Behavior | Newton errors ≈ 2.2e-2, 3.2e-4, 6.9e-8, 3.2e-15 (steps 1–4) | mpmath: 2.2222e-2, 3.2206e-4, 6.9127e-8, 3.1857e-15 | confirmed |
| 2-6 | Behavior | Halley errors ≈ 2.1e-3, 2.9e-9, 8.2e-27 (steps 1–3) | 2.0619e-3, 2.9138e-9, 8.2463e-27 | confirmed |
| 2-7 | Behavior | Double precision: Newton first = −2 exactly at x₅, Halley at x₃ | Python floats: Newton x₄ = −2.000000000000003, x₅ = −2.0; Halley x₂ = −2.0000000029138016, x₃ = −2.0. Julia instrumented copy identical | confirmed |
| 2-8 | Behavior | Neither first step overshoots; both left of root; Halley within 0.0021 | −2.0222 < −2, −2.00206 < −2; \|e\| = 0.00206 | confirmed |
| 2-9 | Behavior | First-step markers about 0.02 apart, overlap; legend gives values | 0.02016 apart; frame 1 blue diamond hidden under orange; legend "−2.02222" / "−2.002062" | confirmed |
| 2-10 | Alt | Hyperbola and tangent each frame, Halley and Newton next iterates marked, cubic convergence to −2 | frames 1–5; final frame without markers | confirmed |
| W1 | Wiring | Case 1a → `halleysaa.jl` / `halleysaa.gif` etc. | link/embed names match scripts; GIF byte-identical to regen | confirmed |
| W2 | Closing | Cases 1a, 1b, 2 follow Mathews Examples 1(a), 1(b), 2(b) | archive: Ex1 f=x²−2, p₀=2, root √2 (Newton, Halley); Ex2 f=x³−3x+2, root −2, p₀=−2.2 (Newton 2(a), Halley 2(b)) | confirmed |
| W3 | Closing | Example 2(a) (Newton on Case 2 function) not animated; blue diamond is only Newton step from current Halley iterate | archive lnk_4 = 2(a) Newton; `halleysba.jl` l.78 `x_newton = x_cur - fv/fpv` | confirmed |

---

### 3. Implementation checks

### `halleysaa.jl` (Case 1a, Newton baseline)
- **Method:** plain Newton, `x - f/fp` (l.28). The page presents it as Newton, so this is correct.
- **Numbers:** an instrumented copy (`halleysaa_instr.jl`) prints x₀…x₆ as 2.0, 1.5, 1.4166666666666667, 1.4142156862745099, 1.4142135623746899, 1.4142135623730951 and 1.414213562373095. An independent Python float run gives the same values to the last bit, and mpmath at 200 digits agrees to double precision.
- **Reference:** √2. Frames use annotations rounded to 8 digits: x₃ = 1.41421569 is correct.
- **Picture:** the tangent is drawn at x_cur with slope 2x_cur (l.51). The orange diamond is at x_next with the legend label x_{frame+1}, so the indices are correct. The vertical drop and the red marker are at x_cur. All 7 frames were viewed; frames 1 and 2 show the construction, and frames 3–7 have converged at plot scale.

### `halleysab.jl` (Case 1b, Halley on x²−2)
- **Method:** the rational Halley formula (l.32), the same as Mathews' h(x). The hyperbola uses b₁ = −f″/(2f′) and a₁ = f′ + f·b₁ (l.55–56). These are derived by series in sympy, and `hyp.jl` confirms H matches f, f′ and f″ and that the root of H equals the Halley iterate exactly. The pole sits at x_n − 1/b₁ = 6.0, 4.29 and 4.24, outside the window [1, 2.6], so the `d > 0` mask removes nothing visible.
- **Numbers:** the script gives 2.0, 1.4285714285714286, 1.4142139267767408, 1.414213562373095 and 1.4142135623730951. Independent Python and mpmath give the same, with errors 5.86e-1, 1.44e-2, 3.64e-7, 6.0e-21 and 2.8e-62 at 200 digits. The Newton-from-iterate values in the legend are 1.5, 1.41429, 1.41421 and 1.41421, which are correct.
- **Reference:** √2. C = 1/8 from the page's formula agrees with the observed ratio 0.123.
- **Picture:** frame 1 shows the hyperbola hugging f and crossing the axis at the orange diamond (1.428571), and the dotted tangent crossing at the blue diamond (1.5). Titles and legends match the code. The legend uses a generic "xₙ₊₁" and the annotation gives an indexed x_n.

### `halleysba.jl` (Case 2, Halley on x³−3x+2)
- **Method:** the same rational Halley formula (l.32) and the same hyperbola construction. The pole is at −3.945, −3.505 and −3.500, left of xlim −3, so the plotted branch covers the whole window.
- **Numbers:** the script gives −2.2, −2.002061855670103, −2.0000000029138016, −2.0, −2.0 and −2.0. Independent Python floats give the same, and mpmath gives errors 2.06e-3, 2.91e-9, 8.25e-27 and 1.87e-79. Newton steps from the iterates in the legend: −2.02222 (true −2.0222222), then −2.0 (true −2.0000028; correct at 5 digits).
- **Reference:** the root −2 is exact, since f(−2) = −8 + 6 + 2 = 0. C from the formula is 1/3, and the observed ratios are 0.258, 0.333 and 0.333.
- **Picture:** frame 1 shows the hyperbola through (−2.2, −2.048), tangent to f, crossing at −2.00206. The tangent is clamped to ylims (l.64), and the clamped parts lie on the box border, as checked in `crop_bl.png` and `crop_top.png`. That is not misleading. The orange hyperbola leaves the top of the window near x ≈ −0.5 by ordinary clipping. The double root at x = 1 is visible in the window. All 6 frames were viewed.

### Legacy archive
Mathews' Example 1 (f = x² − 2, p₀ = 2, Newton for 1(a) and Halley for 1(b)) and Example 2 (f = x³ − 3x + 2, root −2, p₀ = −2.2, Newton for 2(a) and Halley for 2(b)) match the page's cases. The iteration formula h(x) = x − (f/f′)(1 − ff″/(2f′²))⁻¹ matches both the page and the scripts. The page discloses that 2(a) is omitted. There is no fidelity finding.

