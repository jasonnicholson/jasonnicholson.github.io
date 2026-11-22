# Fix record: 2d-trapezoidal-and-simpson-rules

Scratch folder (evidence scripts and outputs):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/2d-trapezoidal-and-simpson-rules/fix/`
(`check.py` → `check.out`, `ex7.py`, `upscale.jl`, `arch/gr_*.png`).

## Findings

### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I check.py` applies the page's Simpson formula exactly as written (weights a_0=a_m=1, odd i → 4, other i → 2; factor hk/9) to f ≡ 1 on [0,1]² with exact rational arithmetic:
  m=n=3 → weights [1,4,2,1], I_S = 0.7901; m=n=5 → 0.8711; m=n=7 → 0.9070; m=n=4 and 6 → 1.0000 (exact 1). With m=3, n=4: 0.8889. So the formula is only Simpson's rule for even m and n; the page also never defined h, k, m, n, x_i, y_j or the j-weights. Finding holds.
- Change: `index.qmd` Description.
  - Simpson weight line: `a_i=2 (even i)` → `a_i=2 (even i, 0<i<m)` (also put `i` in math mode inside `\text{}`).
  - New paragraph after the Simpson formula: "Here the rectangle $[a,b]\times[c,d]$ is divided into $m$ panels of width $h=(b-a)/m$ in $x$ and $n$ panels of width $k=(d-c)/n$ in $y$, with nodes $x_i=a+ih$ and $y_j=c+jk$; the weights $w_j$ and $a_j$ are defined in the same way with $n$ in place of $m$. For Simpson's rule $m$ and $n$ must be even."
- Check (`check.out`):
  - With these definitions on a non-square rectangle and unequal even counts (m=4, n=6 on [−1,2]×[1,3]), I_S of x³y³ = 75 = exact 75; trapezoid with m=3, n=5 on the same rectangle gives I_T(xy) = 6 = exact 6. So the definitions (h=(b−a)/m, k=(d−c)/n, x_i=a+ih, y_j=c+jk, j-weights with n for m) give the correct rules.
  - The definitions reproduce the scripts' values on [0,1]² with m=n: n=2 I_T 4.749087736005, I_S 5.106262624448; n=10 I_T 5.036083763603, I_S 5.047644586076; n=20 I_T 5.044698421647, I_S 5.047571483116 — identical to the round-2 review's script tables.
  - Scripts: `simpson2daa.jl` uses `n_seq = [2,4,6,8,10,12,16,20]` (all even) with m = n, so the animations already satisfy the stated condition; no script change.

### F2 — Minor — fixed
- Reproduced from the archive (`n2003/simpsonsrule2dmod.html` and `simpsons2Drule/SimpsonsRule2DMod/`):
  - `grep -n -E 'Example [0-9]'` lists Examples 1–7 only. Statement images gr_43 (Ex 1), gr_67 (Ex 2), gr_87 (Ex 3), gr_108 (Ex 4), gr_132 (Ex 5), gr_153 (Ex 6), upscaled 4× and viewed, all show ∫₀¹∫₀¹ 8e^{−x²−y⁴} dy dx.
  - Example 7 (statement gr_193, solution `Links/SimpsonsRule2DMod_lnk_8.html`) shows ∫₀² ∫_{x²}^{√(8x)} e^{−x√y} dy dx. Its code image gr_196 sets `c[x_] = x^2; d[x_] = Sqrt[8x]` (agrees with the statement image), and the subroutines gr_191 (`F[x]`, Simpson in y between c[x] and d[x]) and gr_192 (`Simp2D`, Simpson in x applied to F) are composite Simpson's rule with inner limits that are functions of x. The module text above it says "the limits of integration on the inside integral are functions of x".
  - The page has only two cases (trapezoidal2daa, simpson2daa), both on the rectangle [0,1]²; Example 7 is not animated. Finding holds.
- Change: `index.qmd` Description.
  - "The archived module examples use" → "Examples 1–6 of the archived module use".
  - Added to the existing source-note paragraph, directly after "…reconstructed from the available formula and checkpoint assets.": "The module's Example 7, which applies the composite Simpson's rule to a double integral whose inner limits of integration are functions of $x$ (a non-rectangular region), is not animated here."
- Check: "non-rectangular" computed in `check.py`: on [0,2], hi−lo = √(8x) − x² is 0 at x=0 and x=2 (both limits 0 at x=0, both 4 at x=2) and positive between (max 1.890 at x≈0.794), so the region is bounded by two curves meeting at its ends, not a rectangle. No numbers in the new sentence other than example labels.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Description l.13 | "Examples 1–6 of the archived module use" ∫₀¹∫₀¹ 8e^{−x²−y⁴} | archive grep lists Examples 1–7; gr_43, gr_67, gr_87, gr_108, gr_132, gr_153 viewed (upscale.jl) → all this integral; gr_193 (Ex 7) is different | yes |
| Simpson weights | `a_i=2 (even i, 0<i<m)` | `check.py` simp_w: interior even nodes get 2, ends 1; matches `simpson2daa.jl` lines 25–31 | yes |
| New para | $h=(b-a)/m$, $k=(d-c)/n$, $x_i=a+ih$, $y_j=c+jk$, j-weights with n for m | `check.py`: x³y³ on [−1,2]×[1,3], m=4,n=6 → 75 = exact; xy trapezoid m=3,n=5 → 6 = exact; script values reproduced at n=2,10,20 | yes |
| New para | "For Simpson's rule $m$ and $n$ must be even." | `check.py`: f≡1, m=n=3,5,7 → 0.7901, 0.8711, 0.9070; m=3,n=4 → 0.8889; even m → 1.0000 | yes |
| Source note | Example 7 "applies the composite Simpson's rule" | gr_191/gr_192 code: k/3(f_0+f_end+2Σeven+4Σodd) in y, h/3(…) in x | yes |
| Source note | "inner limits of integration are functions of $x$" | gr_196: c[x]=x², d[x]=√(8x); gr_193 agrees; module text says the same | yes |
| Source note | "(a non-rectangular region)" | `check.py`: √(8x)−x² = 0 at x=0,2, max 1.890 at x≈0.794 | yes |
| Source note | "is not animated here" | page cases: trapezoidal2daa, simpson2daa only, both on [0,1]² | yes |

## Scripts and GIFs
- No scripts changed; no GIFs regenerated (both findings are Description text only).
- `git status --short -- pages/numerical-methods/2d-trapezoidal-and-simpson-rules` → ` M .../index.qmd` only.

## Legacy archive
Consulted: `n2003/simpsonsrule2dmod.html`, its `Links/SimpsonsRule2DMod_lnk_2..8.html`, and images gr_43, 67, 87, 108, 132, 153, 191, 192, 193, 196. Examples 1–6 all use 8e^{−x²−y⁴} on [0,1]² (Example 1 uses the Trapezoidal2D subroutine at m=n=10 and 20 although its statement says "Simpson's rule"; Example 4 uses Simpson2D at m=n=5, i.e. 10 panels, and finer). Example 7 is Simpson's rule with variable inner limits, now named as not animated. Mathews' Simpson theorem counts 2m subintervals (m = number of panel pairs); the page counts m panels, which is why it states "m even" rather than using 2m — same rule, different index convention.

Side note, not on the page: the round-2 review quotes the archive's Example 7 value as ≈ 1.01516369587. scipy `dblquad` gives the integral as 1.0160694078 (est. error 1.5e-8), and my port of the archive's code (`ex7.py`, n=20, m=5 → 40 x-panels, 10 y-panels) gives 1.0135196009. I did not reproduce 1.01516369587 and did not view the result image; since no Example 7 number goes on the page, I did not look further.

## Notes
- Placement of the R2-A sentence: the pattern says to put it in the existing legacy/source note paragraph, directly after the sentence about where the animations come from. On this page that note (l.38–39, "The archived snapshot is incomplete … reconstructed from …") is inside the Description, not after the last embed, so the new sentence joins that paragraph there rather than going after the last embed. The director may move both sentences together if the "not in the Description" rule should take precedence.
- Not changed: pre-existing text and scripts that the round-2 review confirmed.

## Resolution check (independent checker, not shown this record)

The fix changes only text, in `index.qmd`. `git diff HEAD` shows `simpson2daa.jl`, `trapezoidal2daa.jl`, `simpson2daa.gif` and `trapezoidal2daa.gif` unchanged.

### Original findings

### F1 — resolved
- The new paragraph (index.qmd lines 38–41) defines the rectangle [a,b]×[c,d], m and n, h=(b−a)/m, k=(d−c)/n, x_i=a+ih and y_j=c+jk. It says w_j and a_j are defined the same way with n in place of m, and states "For Simpson's rule m and n must be even". The Simpson weight line now reads "a_i=2 (even i, 0<i<m)". All of the suggested correction is applied.
- Independent check (`check/chk.py`, page formulas implemented literally with separate m and n):
  - Simpson with m=4, n=6 on [0.5,2]×[−1,3] for x³y³+x²y gives 90.187500000 (exact 90.1875). It is exact for bicubics, so the general-rectangle, m≠n reading is right.
  - Trapezoid with m=3, n=5 on [0,2]×[1,4] for 2+3x−y+5xy gives 90.000000 (exact 90). It is exact for bilinears, so odd counts are fine for trapezoid, as the page implies.
  - Simpson with f≡1 and m=n=3 gives 0.790123. With m=4, n=2 it gives 1.000000. This confirms the evenness condition is needed and is now stated.
  - Convergence on 8e^{−x²−y⁴}, against the reference I = 5.04756680716754 (mpmath):
    - Trapezoid errors for m=n=2,4,8,16: −0.2985, −0.0722, −0.01795, −0.004483. The ratio tends to 4, so the method is second order.
    - Simpson errors: 0.0587, 0.00424, 1.96e−4, 1.15e−5. The ratio tends to 16, so the method is fourth order.
    - Simpson with m≠n, (m,n) = (4,8), (8,16), (16,32): errors 3.94e−4, 2.41e−5, 1.50e−6, ratio ≈16.
- The scripts were not affected (n_seq is all even) and are unchanged.

### F2 — resolved
- Line 13 now reads "Examples 1–6 of the archived module use I = ∫₀¹∫₀¹ 8e^{−x²−y⁴} dy dx". Lines 45–47 add one sentence saying that the module's Example 7 (composite Simpson with inner limits that are functions of x, a non-rectangular region) is not animated. This follows R2-A: one sentence, the example not added.
- Archive check:
  - The module has exactly seven examples: `SimpsonsRule2DMod_lnk_2..8.html` hold Examples 1–7, and `lnk_1` has none.
  - Examples 1, 2, 3, 4, 5 and 6 show the integral images gr_43, gr_67, gr_87, gr_108, gr_132 and gr_153. I viewed all six. Each is ∫₀¹∫₀¹ 8e^{−x²−y⁴} dy dx.
  - Example 7's image gr_193 is ∫₀² ∫_{x²}^{√(8x)} e^{−x√y} dy dx. Its region plot gr_197 shows a curved region between y=x² and y=√(8x) with vertical slices. So the inner limits are functions of x and the region is non-rectangular, as the page says.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.13 | "Examples 1–6 of the archived module use" (the 8e^{−x²−y⁴} integral on [0,1]²) | viewed gr_43/67/87/108/132/153; the module has 7 examples | true |
| l.35 | a_i=4 (odd i), a_i=2 (even i, 0<i<m), a_0=a_m=1 | weight vector [1,4,2,…,4,1] for even m; the Simpson rule is exact for bicubics (90.1875) | true |
| l.38 | rectangle [a,b]×[c,d], m panels of width h=(b−a)/m in x | consistent with the formula; numerical check on [0.5,2]×[−1,3] | true |
| l.39 | n panels of width k=(d−c)/n in y; x_i=a+ih | same check | true |
| l.40 | y_j=c+jk; w_j and a_j defined in the same way with n in place of m | m≠n Simpson and trapezoid exact on test polynomials | true |
| l.41 | "For Simpson's rule m and n must be even." | f≡1 with m=3 gives 0.7901, m=4 gives 1.0000 | true |
| l.45–47 | Example 7: composite Simpson on a double integral whose inner limits are functions of x (non-rectangular region), not animated here | gr_193 limits x² to √(8x); gr_197 region plot; no Example 7 case on the page | true |

The rendered math is fine: `quarto pandoc` to HTML gives 29 math spans with no errors. The `<` signs inside the display math come out as `&lt;`, which MathJax reads correctly.

### New problems
None. This rests on:
- every changed sentence and formula checked above, numerically and against the archive images;
- no script or GIF changed, so no picture could regress;
- the rendered math checked.

One observation that is not a defect: `a` is both the interval endpoint (x_i=a+ih) and the letter for the Simpson weights a_i. This follows Mathews' and the suggested correction's notation, and the subscript tells them apart.

### Reproducibility and conventions
- **Reproducibility:** no script or GIF changed (`git diff --quiet HEAD` on `*.jl` and `*.gif` in the page folder). Nothing to regenerate.
- **Conventions:** kept.
  - Description comes before Animations.
  - Each of the two cases has a `[Julia source]` link and a GIF embed with descriptive alt text.
  - There are no code fences (0 found).
- **Scope:**
  - In this page folder, only `index.qmd` changed.
  - The working tree has other modified pages and untracked `reviews/...-r2/fixes/*.md`. These come from parallel fixers working on other pages, and I cannot attribute them to this fix; `fix.diff` for this folder contains only `index.qmd`.
  - `references.bib`, `_quarto.yml` and the section index are unchanged.

**Final status:** committed
