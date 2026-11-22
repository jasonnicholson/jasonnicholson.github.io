# Hermite Polynomial Interpolation — animation review (round 3)

Page: `pages/numerical-methods/hermite-polynomial-interpolation/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1 — Page match, Minor — "giving a smoother fit"

- **Location:** `index.qmd` line 22: "Unlike ordinary polynomial interpolation, Hermite interpolation matches the slope at each node, giving a smoother fit."
- **What is there:** a comparison claiming Hermite interpolation is "smoother" than ordinary polynomial interpolation.
- **What is true:** The first half is right (slopes are matched; confirmed numerically below). "Smoother" is not right in the usual sense of the word: an ordinary (Lagrange) interpolating polynomial is infinitely differentiable, the single-interval Hermite cubic of Case 2 is equally so, and the piecewise Hermite interpolant of Case 1 is only C¹ (the page's own Description says so on line 18). What slope matching buys is closer agreement with the function's shape between nodes, not more smoothness. It would be smoother only by comparison with piecewise *linear* interpolation, which the sentence does not name.
- **How I know:** Finite-difference slopes of the script's own `hermite_eval` for n = 4 at interior nodes (aa_instr.jl): left/right slopes at x = π are −0.99999994 / −0.99999994 (cos π = −1), at π/2 and 3π/2 both ≈ ±5.8e−7 (cos = 0), so it is C¹. The second derivative jumps at x = π from −0.1148 to +0.1148 (scipy `CubicHermiteSpline(...).derivative(2)` evaluated at π ∓ 1e−9), so it is not C², consistent with line 18. (At π/2 and 3π/2 the jump happens to vanish by symmetry.)
- **Correction:** e.g. "Unlike ordinary (Lagrange) interpolation, which uses only values, Hermite interpolation also matches the slope at each node, so the interpolant follows the function's shape more closely between nodes." Or, if the intended contrast is with piecewise linear interpolation, say so.

- **Independent check:** not run (Minor finding, unverified)

### F2 — Fidelity, Minor — Mathews' Example 1 replaced by an unexplained example

- **Location:** `index.qmd` lines 34–43 (Case 2 heading, and "the two cases above are this site's own examples ... Examples 1–3 ... are not animated here.")
- **What is there:** Case 2 builds the cubic Hermite interpolant of eˣ on [0, 1]. The page discloses that Mathews' Examples 1–3 are not animated but gives no reason.
- **What the archive has:** No animation exists (confirmed: no Hermite entry in `a2001/Animations/`, no animation in the module). Example 1 (`HermitePolyMod_lnk_2.html`, formula image gr_18, graph gr_31) is exactly the subject of Case 2: find the cubic with p(1) = 2, p′(1) = 1, p(3) = 1, p′(3) = 2. Examples 2 and 3 are clamped/natural cubic splines (gr_38, gr_77), a different topic, so not animating them is reasonable.
- **Why it matters (slightly):** The departure is disclosed, so it is not silent; but Example 1 could be animated by Case 2's script with only data changed, and it would also make the h-scaling of the derivative terms visible (Case 2 uses h = 1, where h·y′ = y′). The site's conventions (`.github/agents/animation-page.agent.md` line 13) say to reconstruct parameters from the worked examples when no legacy GIF exists.
- **How I know:** Read the archive pages as text and viewed gr_18 (data) and gr_31 (graph: curve from (1,2) rising to a max ≈ 2.1 near x ≈ 1.2, dipping to ≈ 0.65 near x ≈ 2.6, ending at (3,1)). Independent sympy: 2H₀₀ + 2·1·H₁₀ + 1·H₀₁ + 2·2·H₁₁ with t = (x−1)/2 gives p(x) = x³ − 23x²/4 + 19x/2 − 11/4, with p(1)=2, p′(1)=1, p(3)=1, p′(3)=2, consistent with gr_31.
- **Correction:** Either switch Case 2 to Mathews' Example 1 data (a = 1, b = 3, y₀ = 2, y₀′ = 1, y₁ = 1, y₁′ = 2; no reference f, so drop the eˣ curve and show the endpoint tangent segments instead), or keep eˣ and add one sentence giving the reason for using it (e.g. a known f lets the reader see the interpolation error).

No other findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `hermitepolyaa.jl` | 0 | 5.3 | hermitepolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `hermitepolybb.jl` | 0 | 6.8 | hermitepolybb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Verdicts: C = confirmed, W = wrong, ? = could not determine.

### Description (formulas/algorithm)
| # | Claim (page words) | Evidence | Verdict |
|---|---|---|---|
| D1 | "matching both function values and first derivatives at interpolation nodes" | Script interpolant reproduces values at nodes (max residual 0.0) and slopes (FD check) | C |
| D2 | "$h=x_1-x_0$ and $t=(x-x_0)/h$" | Matches both scripts (aa lines 25–27; bb lines 20, 23) | C |
| D3 | $H(x)=y_0H_{00}(t)+hy_0'H_{10}(t)+y_1H_{01}(t)+hy_1'H_{11}(t)$ | Matches aa lines 28–31, bb lines 25–28; sympy confirms this reproduces y₀, y₀′, y₁, y₁′ | C |
| D4 | "$H_{00},H_{10},H_{01},H_{11}$ are the standard cubic Hermite basis functions" | Independent sympy derivation from the 4 endpoint conditions gives exactly 2t³−3t²+1, t³−2t²+t, −2t³+3t², t³−t² (the scripts' definitions) | C |
| D5 | "In piecewise form ... a smooth $C^1$ approximation that preserves both value and slope information at each node" | FD slopes equal from both sides at interior nodes, equal cos(xᵢ) | C |

### Animations introduction
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | "illustrate the cubic Hermite polynomial, which interpolates both function values and first derivatives at the endpoint nodes" | As D1 | C |
| I2 | "Unlike ordinary polynomial interpolation, Hermite interpolation matches the slope at each node" | Ordinary interpolation uses values only | C |
| I3 | "... giving a smoother fit" | See F1 | W (Minor, F1) |
| I4 | "Julia source scripts ... are linked under each case" | Two links, each under its case | C |

### Case 1
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| A1 | Heading: piecewise cubic Hermite for sin(x), refining the mesh | aa lines 36–45, n = 1,2,4,8 | C |
| A2 | "uses $n$ subintervals, each carrying a cubic ... matches $f$ and $f'$ at its two endpoints" | aa `hermite_eval`; node residual 0, slope FD check | C |
| A3 | Max errors 0.425, 0.215, 0.0108, 0.000906 | Script: 0.42537, 0.21460, 0.010791, 0.00090620; independent scipy CubicHermiteSpline on the same 600-point grid: 0.425375, 0.214601, 0.0107905, 0.000906198; on 2,000,001 points (true sup): 0.425382, 0.214602, 0.0107907, 0.000906216 | C |
| A4 | Ratios "about 2.0, 19.9 and 11.9" | 1.982, 19.89, 11.91 | C |
| A5 | "For smooth $f$ the error is $O(h^4)$" | Ratios tend to 16: 14.96, 15.74, 15.94, 16.02 (n=64→128) | C |
| A6 | "coarse meshes are not yet in the asymptotic range" | Ratios 2.0/19.9/11.9 far from 16 | C |
| A7 | "15.0 for $n = 8 \to 16$, 15.7 for $16 \to 32$, 15.9 for $32 \to 64$" | 14.96, 15.74, 15.94 (600-pt grid); 14.96, 15.74, 15.93 (dense) | C |
| A8 | Link `hermitepolyaa.jl`, embed `hermitepolyaa.gif` | Script writes that GIF; manifest: byte-identical on regeneration | C |
| A9 | Alt: "sin(x) on 0 to 2pi, showing n=1,2,4,8 intervals" | aa lines 39–43; frame titles n = 1,2,4,8 | C |
| A10 | Alt: "maximum error falls from 0.425 at n=1 to 0.000906 at n=8" | As A3; frame titles show 0.425 and 0.000906 | C |
| A11 | Frame count (implied 4 frames, "four frames") | 4 frames in committed GIF | C |

### Case 2
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| B1 | Heading: Hermite basis functions building the interpolant of $e^x$ on $[0,1]$ | bb lines 14–17 | C |
| B2 | "four ... basis functions ... each carry one degree of freedom (a value or derivative at an endpoint)" | sympy derivation (D4): each is 1 in exactly one of the four conditions | C |
| B3 | Weighted combination formula | bb lines 25–28 | C |
| B4 | "equals the true function at both endpoints and matches the slope there" | Full sum: values 1, e; slopes 1, e (sympy exact). Script's own sum: endpoints 1.0, 2.718281828459045; one-sided FD slopes 1.0011, 2.7151 (FD on 400-pt grid) | C |
| B5 | "frames add the weighted terms one at a time and draw the running sum" | bb `stages`; frames 1–4 show partial sums S₁..S₄ only | C |
| B6 | "first two partial sums fall to 0 with zero slope at $x = 1$" | S₁(1)=0, S₁′(1)=0; S₂(1)=0, S₂′(1)=0 (sympy); script FD end slopes −0.0075, −0.0100 (≈0 at grid resolution) | C |
| B7 | "because $H_{00}$ and $H_{10}$ have zero value and zero slope there" | H₀₀(1)=H₀₀′(1)=H₁₀(1)=H₁₀′(1)=0 | C |
| B8 | Link `hermitepolybb.jl`, embed `hermitepolybb.gif` | Script writes that GIF; byte-identical on regeneration | C |
| B9 | Alt: "Running sum of the four weighted Hermite basis terms ... one term per frame until it forms the complete cubic Hermite interpolant" | 4 frames; last frame title "... = H(x)", legend "H(x) complete" | C |

### Closing paragraph (legacy inventory; checked only for fidelity)
| # | Claim | Evidence | Verdict |
|---|---|---|---|
| L1 | "Mathews' Hermite polynomial module has no animation" | No animation in module; no Hermite entry in a2001/Animations | C |
| L2 | Example 1 = cubic Hermite ("clamped cubic") from endpoint values and slopes; Examples 2, 3 = clamped and natural cubic splines | Archive lnk_2..lnk_4 text and gr_18/38/77 | C (fidelity note F2) |

---

### 3. Implementation checks

### `hermitepolyaa.jl` (Case 1)
- **Is the method claimed:** Yes. Piecewise cubic Hermite interpolation with exact f and f′ at equispaced nodes on [0, 2π]; local parameter t, derivative terms scaled by h. Interval lookup `searchsortedlast` + `clamp(i,1,n)` puts x = 2π into the last interval correctly.
- **Numbers right:** Instrumented copy printed max errors 0.4253745914738841, 0.21460058715876607, 0.01079052009607473, 0.0009061984969647163. Independent scipy `CubicHermiteSpline` on the same grid: 0.425375, 0.214601, 0.0107905, 0.000906198 (agree to all shown digits). Property checks with the script's own routine: reproduces a cubic exactly (max error 8.5e−14 for n = 1 and n = 3) and does not reproduce x⁴ (errors 97.4, 1.20), so degree of exactness is exactly 3; node residual 0.0 for every frame; slopes continuous and equal to cos at interior nodes (FD check). Convergence ratio tends to 16 (O(h⁴)), see A5/A7.
- **Reference values:** f = sin, f′ = cos; exact.
- **Picture:** Frames 1–4 show n = 1, 2, 4, 8; dashed red H passes through the black node markers; title error matches computed value at 3 s.f.; y-limits ±1.4 contain everything; nothing clamped or masked. The n = 1 frame correctly shows H(x) = 2π·(H₁₀+H₁₁)(t) with zero values at both ends and slope 1 at both ends.

### `hermitepolybb.jl` (Case 2)
- **Is the method claimed:** Yes. Single-interval cubic Hermite in the H₀₀/H₁₀/H₀₁/H₁₁ form with h = 1 on [0, 1].
- **Numbers right:** Script partial sums: S₁ endpoints 1.0 → 0.0; S₂ 1.0 → 0.0 (max 1.0535 near x ≈ 0.11, sympy max 1.053498 matches); S₃ 1.0 → e with zero end slope (FD 0.0104 at grid step); S₄ 1.0 → 2.718281828459045. Sympy exact: S₄ values 1, e and slopes 1, e. Max |S₄ − eˣ| = 0.00437 ≤ the standard bound e/384 = 0.00708 (consistent; the page makes no claim about this error).
- **Reference values:** f = f′ = exp; exact.
- **Picture:** Four frames, titles name the term added, the legend labels the running sum; gray dotted eˣ for reference; endpoint markers at (0,1) and (1,e). y-limits (−0.2, 3.0) contain all partial sums (min 0, max e). The final orange curve overlies eˣ (error 0.0044 is sub-pixel), consistent with the page. The script's comment notes slopes are not drawn; the page does not claim they are.

### Not checked / limitations
- None material. All page numbers were reproduced both from the script and independently.

