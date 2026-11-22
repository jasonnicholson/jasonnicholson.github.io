# Halley's Method — animation review (round 5)

Page: `pages/numerical-methods/halleys-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim in the ledger below was confirmed by my own computation or by the frames. I found no implementation error, no mismatch between page and animation, and no fidelity departure that matters to a reader.

Observations that I judged **not** to be findings:
- `halleysba.jl:65` clamps the tangent to `ylims`. This draws flat segments along y=−5 (x≈−3 to −2.45) and y=8 in frame 1. In the frames they sit on the plot border and cannot be seen (checked on 3× crops `review/ba1_top.png`, `review/ba1_bot.png`). They do not affect what a viewer concludes.
- Some trailing frames look the same once the iterate has converged in double precision: `halleysaa` frames 5–7, `halleysab` frames 4–5, `halleysba` frames 4–6. The page makes no claim about frame counts, and the annotations stay correct.
- In `halleysba` frame 1 the blue Newton diamond (−2.02222) is hidden under the orange Halley diamond (−2.002062). The page says so explicitly ("they overlap at this scale; the legend gives their values"), and the legend values are correct.

---



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `halleysaa.jl` | 0 | 6.8 | halleysaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysab.jl` | 0 | 6.8 | halleysab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `halleysba.jl` | 0 | 8.2 | halleysba.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description ¶1 | Halley fits an osculating hyperbola y=(a+b(x−xₙ))/(1+c(x−xₙ)) that matches f, f′, f″ at xₙ and takes its x-intercept as xₙ₊₁ | Algebra: with c=−f″/(2f′) and b=f′+fc, H(0)=f, H′(0)=b−fc=f′, H″(0)/2=c(fc−b)=−cf′=f″/2. The root is t=−f/b=−2ff′/(2f′²−ff″), which is the Halley step. Numerically (instrumented copies): H−f=0, H′−f′≈4e−8, H″−f″≈3e−7 (finite-difference noise), H(xₙ₊₁)≈1e−16 in every frame | confirmed |
| D2 | Description ¶1 | Root of the Taylor parabola gives a different iteration, Halley's irrational method | Standard nomenclature. The parabola root involves a square root and differs from D1's step | confirmed |
| D3 | Description ¶1 | Cubic convergence at simple roots; digits roughly triple vs double for Newton | Halley ratios eₙ₊₁/eₙ³ → 0.125 (Case 1) and → 0.33333 (Case 2). Digit counts 1.84 → 6.44 → 20.2 → 61.6 (Halley) vs 1.07 → 2.61 → 5.67 → 11.8 → 24.05 (Newton) | confirmed |
| D4 | Iteration formula | xₙ₊₁ = xₙ − 2ff′/(2f′² − ff″) | Agrees with D1 and with Mathews' formula (2) (archive h[x] for Ex. 2 simplifies to (2+4x+2x²+x³)/(3+4x+2x²), which equals this formula for f=x³−3x+2) | confirmed |
| D5 | Rewritten form | xₙ₊₁ = xₙ − (f/f′)·1/(1 − ff″/(2f′²)) | (f/f′)·2f′²/(2f′²−ff″) = 2ff′/(2f′²−ff″) | confirmed |
| D6 | ¶ after formula | The factor tends to 1 near a simple root, so the Halley step nearly coincides with the Newton step | f→0 while f′≠0. Newton-from-Halley-iterate vs Halley next: 1.4142857 vs 1.4142139 at x₁ (Case 1) | confirmed |
| D7 | Convergence | C = \|f‴/(6f′) − f″²/(4f′²)\| | Formula gives 0.125 (Case 1) and 1/3 (Case 2). Observed ratios: 0.07143, 0.12312, 0.1249999517, 0.125 (Case 1) and 0.25773, 0.33242, 0.333333332 (Case 2) | confirmed |
| D8 | Convergence | At a multiple root (m≥2), linear convergence | Halley on (x+2)(x−1)² from 1.5 toward x=1: ratio eₙ₊₁/eₙ → 0.33333 (=(m−1)/(m+1)); Newton → 0.5 | confirmed |
| D9 | Trade-offs | 3 evaluations vs 2 | f, f′, f″ vs f, f′ | confirmed |
| D10 | Trade-offs | log2/log3 ≈ 0.63; 3^{1/3} ≈ 1.442; 2^{1/2} ≈ 1.414 | 0.6309, 1.44225, 1.41421 | confirmed |
| D11 | Trade-offs | √2 from x₀=2 to 20,000 digits at fixed precision: Halley 10 iterations vs Newton 15, about as long or slightly longer | `digits20k.py` (mpmath, dps 20050, stop when relative error <1e−20000): Newton 15, Halley 10. Time with error check: 0.077/0.076, 0.078/0.074, 0.072/0.071 s. Pure iteration: Newton 0.050 s, Halley 0.056 s. Timing depends on implementation, but the claim holds here | confirmed |
| A1 | Animations intro | Case 1a: Newton tangent-line construction alone, tangent blue dashed | `halleysaa.jl:52` steelblue `ls=:dash`. No hyperbola. Frames show this | confirmed |
| A2 | Animations intro | Cases 1b, 2: current iterate xₙ marked on the curve, tangent blue dotted, osculating hyperbola orange dashed crossing the x-axis at xₙ₊₁ | `halleysab.jl:59–65`, `halleysba.jl:60–66` (darkorange dash, steelblue dot), red dot at (xₙ,f(xₙ)). H(xₙ₊₁)≈1e−16 (instrumented). Frames show it | confirmed |
| A3 | Animations intro | Cubic rather than quadratic convergence at simple roots | See D3 | confirmed |
| A4 | Intro | Julia scripts linked under each case | `[Julia source](halleysaa.jl)` etc. All three exist | confirmed |
| A5 | Intro | Cases 1a, 1b, 2 follow Mathews' Examples 1(a), 1(b), 2(b) | Archive: Ex. 1 f=x²−2, p₀=2 (Newton/Halley). Ex. 2(b) f=x³−3x+2, p₀=−2.2, Halley | confirmed |
| A6 | Intro | Example 2(a) applies Newton to the Case 2 function from the same starting value, not animated. Case 2's blue diamond is only the Newton step from the current Halley iterate | Archive `_lnk_4`: Newton, p[0]=N[−11/5,100]. `halleysba.jl:79` computes `x_cur − fv/fpv` from the Halley iterate | confirmed |
| 1a-H | Case 1a heading | Newton-Raphson, f=x²−2, x₀=2 | `halleysaa.jl:10–13`, title in frames | confirmed |
| 1a-B1 | Case 1a | Tangent at each iterate intersects the x-axis at the next iterate | tangent(xₙ₊₁) ≤ 2.2e−16 in all frames (instrumented) | confirmed |
| 1a-B2 | Case 1a | Converges quadratically to √2 ≈ 1.41421, roughly doubling digits | √2=1.41421356…. Digits 0.23, 1.07, 2.61, 5.67, 11.8, 24.05 | confirmed |
| 1a-B3 | Case 1a | x₁=1.5, x₂≈1.4167, x₃≈1.4142 | 1.5, 1.41666667, 1.41421569 (script and mpmath agree) | confirmed |
| 1a-Alt | alt text | Each frame advances one tangent-line step, converging quadratically to √2 | 7 frames for x₀…x₆, one tangent per frame | confirmed |
| 1b-H | Case 1b heading | Halley, f=x²−2, x₀=2 | `halleysab.jl:10–14` | confirmed |
| 1b-B1 | Case 1b | Orange diamond is the Halley iterate, blue diamond where Newton would land | `halleysab.jl:82–87`. Frame 1 legend: Newton 1.5, Halley 1.428571 | confirmed |
| 1b-B2 | Case 1b | x₁ ≈ 1.42857 (vs Newton's 1.5) | 1.4285714286 (= 10/7) | confirmed |
| 1b-B3 | Case 1b | Accurate digits about 1.8, 6.4, 20 after steps 1–3 (extended precision) | −log₁₀\|eₙ\| = 1.843, 6.438, 20.22 (mpmath, 200 digits). Matches Mathews' tripling | confirmed |
| 1b-B4 | Case 1b | \|g‴(x*)\|/3! governs instead of \|g″(x*)\|/2! | Numerical derivatives of the Halley map at √2: g′=0, g″=0, g‴=0.75, so g‴/6=0.125 = observed constant. Newton's \|g″\|/2 = 0.35355 | confirmed |
| 1b-Alt | alt text | Hyperbola whose x-intercept is the Halley iterate, alongside the Newton tangent, both next iterates on the x-axis | Frames 1–4 show both diamonds. The last frame has no "next" markers, as expected | confirmed |
| 2-H | Case 2 heading | Halley, f=x³−3x+2, x₀=−2.2 | `halleysba.jl:11–15` | confirmed |
| 2-B1 | Case 2 | f=(x+2)(x−1)², simple root −2, double root 1 | Expansion gives x³−3x+2 | confirmed |
| 2-B2 | Case 2 | Halley converges cubically | Ratios → 1/3 (see D7) | confirmed |
| 2-B3 | Case 2 | First Halley step x₁ ≈ −2.002. Newton x₁ ≈ −2.022 | −2.0020618557, −2.0222222222 | confirmed |
| 2-B4 | Case 2 | Newton errors ≈ 2.2e−2, 3.2e−4, 6.9e−8, 3.2e−15 (steps 1–4, extended precision) | 2.2222e−2, 3.2206e−4, 6.9127e−8, 3.1857e−15 | confirmed |
| 2-B5 | Case 2 | Halley errors ≈ 2.1e−3, 2.9e−9, 8.2e−27 (steps 1–3) | 2.0619e−3, 2.9138e−9, 8.2463e−27 (agrees with Mathews' table) | confirmed |
| 2-B6 | Case 2 | In double precision, Newton first reaches −2 exactly at x₅, Halley at x₃ | Double Newton: x₄=−2.000000000000003, x₅=−2.0. Double Halley: x₂=−2.0000000029138016, x₃=−2.0 | confirmed |
| 2-B7 | Case 2 | Neither first step overshoots. Both stay left of the root. Halley's lands within 0.0021 | −2.0222 < −2 and −2.00206 < −2. Error 0.00206 < 0.0021 | confirmed |
| 2-B8 | Case 2 | First-step markers ≈0.02 apart, overlap at this scale, legend gives values | Separation 0.0202 ≈ 2–3 px at this plot scale. Frame 1 shows the blue diamond under the orange one. Legend: −2.02222 / −2.002062 | confirmed |
| 2-Alt | alt text | Hyperbola, tangent, Halley and Newton next iterates on the x-axis, converging to the simple root −2 | Frames 1–6. Annotations x₁=−2.0020618557, x₂=−2.0000000029, x₃=−2.0000000000 | confirmed |
| W1 | Wiring | Case 1a → halleysaa.jl / .gif; 1b → halleysab; 2 → halleysba | `index.qmd:55,57,63,65,71,73`. Each script writes the GIF of the same name, and its parameters match the heading | confirmed |

---

### 3. Implementation checks

### `halleysaa.jl` (Newton baseline, f=x²−2, x₀=2, 6 iterations)
- **Method:** plain Newton step `xs[i] − f/fp` (line 28). The page labels it Newton-Raphson, so the method matches.
- **Numbers:** Script iterates `[2.0, 1.5, 1.4166666666666667, 1.4142156862745099, 1.4142135623746899, 1.4142135623730951, 1.414213562373095]`. Independent mpmath iterates are 2, 1.5, 1.41666666666666666667, 1.41421568627450980392, 1.41421356237468991063, √2, √2. They agree to the last double digit. x₅ and x₆ differ only by a 1-ulp flip in double precision.
- **Reference:** √2 = 1.4142135623730950488. The page states 1.41421, which is correct.
- **Picture:** tangent(xₙ₊₁) ≤ 2.2e−16 in every frame, so the tangent drawn at xₙ hits the axis at the orange diamond. Legend labels "x₁ ≈ 1.5", "x₂ ≈ 1.416667", "x₃ ≈ 1.414216" and annotations "x₂ = 1.41666667", "x₃ = 1.41421569" are correctly indexed and correctly rounded. The title matches the code. Axes 1.0–2.6 × −2.5–4.5 contain everything relevant.

### `halleysab.jl` (Halley, f=x²−2, x₀=2, 4 iterations)
- **Method:** `x − 2ff′/(2f′² − ff″)` (line 32), which is Halley's rational method as described on the page.
- **Numbers:** Script `[2.0, 1.4285714285714286, 1.4142139267767408, 1.414213562373095, 1.4142135623730951]`. mpmath gives 2, 1.42857142857142857143, 1.41421392677674084710, then √2 to 20 digits (error 6.05e−21). They agree.
- **Picture:** The hyperbola uses b₁=−f″/(2f′) and a₁=f′+f b₁. Instrumented finite differences give H−f=0, H′−f′≈3e−9, H″−f″≈2e−9, H(xₙ₊₁) ≤ 2.5e−16 in every frame. The hyperbola's pole is at xₙ − 1/b₁ = 3xₙ (x=6 for x₀=2, and about 4.24 at the root), outside the window, so the NaN mask only drops the far branch. Newton marker values 1.5, 1.41429 (=1.4142857 from x₁), 1.41421 are correct. Annotations "x₁ = 1.4285714286", "x₂ = 1.4142139268", "x₃ = 1.4142135624" are correct.

### `halleysba.jl` (Halley, f=x³−3x+2, x₀=−2.2, 5 iterations)
- **Method:** same Halley update (line 33), with f′=3x²−3 and f″=6x, which are correct derivatives.
- **Numbers:** Script `[−2.2, −2.002061855670103, −2.0000000029138016, −2.0, −2.0, −2.0]`. mpmath gives −2.2, −2.002061855670103092783505, −2.000000002913801774269263, then −2 to within 8.2e−27. They agree. The errors also agree with Mathews' archive table (2.0619e−3, 2.9138e−9, 8.2463e−27).
- **Reference:** root −2 is exact (factorisation checked).
- **Picture:** Instrumented: H−f=0, H′−f′≈4e−8, H″−f″≈3e−7 (finite-difference noise at h=1e−4), H(xₙ₊₁) ≤ 4e−16. The pole is at x₀−1/b₁ ≈ −3.95, left of the window, so the drawn branch is the one through xₙ. The tangent is clamped to the y-limits, but the clamped parts lie on the frame border and are invisible (see Findings, non-findings). Newton-from-current-Halley-iterate values are −2.022222 (shown −2.02222), −2.0000028 (shown −2.0) and −2.0. These are correct at the 5-decimal rounding used. The x₀ annotation "−2.2000000000" and later annotations are correct. The window −3 to 2.5 shows both roots and the region where the iteration acts.

### Regeneration
The manifest reports that all three scratch regenerations are byte-identical to the committed GIFs. My instrumented copies (output redirected to `inst_*.gif` in the scratch folder) ran without error and produced the same iterates.

