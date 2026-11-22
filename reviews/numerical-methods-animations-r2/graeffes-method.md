# Graeffe's Method — animation review (round 2)

Page: `pages/numerical-methods/graeffes-method/`. Reported findings: **0 Error, 1 Misleading, 1 Minor**.

## Findings

### F1. Page match (Description), Misleading: the sign or complex argument "is determined by evaluating p at the candidate magnitude"

- **Location:** `index.qmd` line 36: "The sign (or complex argument) of each root is determined by evaluating $p$ at the candidate magnitude."
- **What is there:** the page claims that evaluating $p$ at the candidate magnitude gives either the sign or the complex argument.
- **What is true:**
  - For a real root you test both $p(+|r_k|)$ and $p(-|r_k|)$ and keep the one that is (near) zero. That is what Mathews does: in Example 4 he computes `f0[+m1]` and `f0[-m1]`, and so on.
  - A complex argument cannot be found by evaluating $p$ at a real magnitude. In addition, a complex-conjugate pair has two roots of equal modulus, so the separated-root formula on lines 30–34 does not apply to it in the first place. The page itself says so two paragraphs later on line 44 ("complex conjugate root pairs ... require modified formulas").
  - The sentence is right for real roots and wrong for complex ones.
- **How I know:** this is a mathematical fact. $|r|$ is real, so $p(\pm|r|)$ carries no information about $\arg r$ when $r \notin \mathbb{R}$. The archive text ("the appropriate sign can be determined by evaluating ...") covers real roots only and says nothing about complex arguments.
- **Correction:** "For real roots, the sign of each root is chosen by checking which of $p(+|r_k|)$ and $p(-|r_k|)$ vanishes. Complex roots need the modified rules mentioned below."

- **Independent check:** confirmed (independent check: evaluating p at ±|r| can fix the sign of a real root but cannot determine a complex root's argument)

### F2. Page match (Description), Minor: coefficient growth described as "exponentially as $|r_k|^{2^m}$"

- **Location:** `index.qmd` line 42: "the coefficients of $p_m$ grow exponentially as $|r_k|^{2^m}$". A related phrase appears on line 54 (Case 1): "$|r_k/r_{k+1}|^{2^m} \to \infty$ exponentially".
- **What is there:** the page says each coefficient grows like a single root magnitude raised to $2^m$, and calls the growth "exponential".
- **What is true:**
  - By Vieta, $c_{n-k}$ of $p_m$ is about $\prod_{i\le k}|r_i|^{2^m}$. It is a product of the $k$ largest magnitudes, not $|r_k|^{2^m}$. Only the ratio of consecutive coefficients behaves like $|r_k|^{2^m}$.
  - The growth is doubly exponential in $m$: the exponent itself doubles at every step.
  - The page's own overflow figures in line 50 depend on the product. For Case 1 the largest coefficient of $p_8$ is $(4\cdot3\cdot2)^{256} = 2.16\times10^{353}$. By contrast $|r_1|^{256} = 4^{256} = 1.34\times10^{154}$, which would *not* overflow Float64. A reader who takes line 42 literally cannot reproduce the overflow claim on line 50.
- **How I know:** `review/graeffesaa_instr.jl` (`instr.out`) prints $\log_{10}$ of the largest coefficient for m = 0…8: 1.38, 2.91, 5.55, 11.04, 22.08, 44.17, 88.33, 176.67, 353.33. The exponent doubles each step. `indep.py` gives $4^{256}=1.341\times10^{154}$, $24^{256}=2.158\times10^{353}$, $5^{256}=8.636\times10^{178}$ and $50^{256}=8.636\times10^{434}$.
- **Correction:** "the coefficients of $p_m$ grow doubly exponentially in $m$: $|c_{n-k}| \approx (|r_1|\cdots|r_k|)^{2^m}$." On line 54, "exponentially" could become "doubly exponentially", or the word can simply be dropped.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Considered and not reported

- **Case 2 trace style.** In Case 2 the r₂ trace is drawn with a dashed line, which is also the page's convention for the true-value lines. The trace is sloped, has diamond markers and its own legend entry, so it is not mistaken for the horizontal reference line. Not misleading.
- **Fidelity (archive examples not animated).** Archive Examples 3/4 (the same polynomial) and Example 6 are reproduced faithfully as Case 1 and Case 2. Example 5 (degree 6), Example 7 (another repeated root), Example 8 (Graeffe2 with decimal coefficients) and Example 9 (unequal real roots of equal magnitude) are not animated. The archive has no animations for this topic, so these are content the page does not yet have rather than a silent departure. Not reported.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `graeffesaa.jl` | 0 | 6.0 | graeffesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `graeffesab.jl` | 0 | 6.1 | graeffesab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `graeffesaa.gif` | 9 | byte-identical | graeffesaa |
| `graeffesab.gif` | 11 | byte-identical | graeffesab |

### Page references

- Scripts linked: `graeffesaa.jl`, `graeffesab.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|---|
| D1 | l.20–22 | $p_1(x) = (-1)^n p(\sqrt x)p(-\sqrt x)$ has roots $r_k^2$ | Confirmed | Algebra: $p(\sqrt x)p(-\sqrt x)=a_n^2\prod(r_k^2-x)=(-1)^n a_n^2\prod(x-r_k^2)$, so $(-1)^n p(\sqrt x)p(-\sqrt x)=a_n^2\prod(x-r_k^2)$. sympy factors p₁ of Case 1 as (x−16)(x−9)(x−4)(x−1) and p₁ of Case 2 as (x−25)²(x−4)(x−1). |
| D2 | l.24 | $p_m$ has roots $r_k^{2^m}$ | Confirmed | Follows from D1 by induction. Estimates converge to the true magnitudes (below). |
| D3 | l.28–34 | $\lvert r_k\rvert^{2^m}\approx\lvert c_{n-k}/c_{n-k+1}\rvert$, with $r_1$ the largest | Confirmed | Vieta. The code's `c[2]/c[1]` = c₃/c₄ is k = 1, the largest root. Estimates converge to 4, 3, 2, 1. |
| D4 | l.36 | Sign or complex argument determined by evaluating p at the candidate magnitude | Wrong (complex part) | F1 |
| D5 | l.40 | Real roots of distinct magnitudes: error decreases quadratically, digits roughly double | Confirmed | Case 1 r₁ error: 0.338, 0.0498, 2.5e-3, 1.26e-5, 6.3e-10, 3.2e-18. r₄: 1.9e-2, 5.1e-4, 9.6e-7, 7.3e-12, 8.5e-22. |
| D6 | l.42 | Coefficients grow "exponentially as $\lvert r_k\rvert^{2^m}$" | Wrong (imprecise) | F2 |
| D7 | l.42 | Most software cannot do more than a handful of iterations before overflow | Confirmed | Float64 run gives Inf/NaN at m = 8 for both polynomials, and m ≤ 7 stays finite. |
| D8 | l.44 | Double roots, complex pairs and equal-magnitude roots need modified formulas | Confirmed | Case 2 shows the unmodified formula converging only linearly (5·2^{±1/2^m}). |
| A1 | l.48 | Animations show Separated Root Theorem estimates over m = 0, 1, 2, … | Confirmed | Code `mag_estimates`; frames m = 0…8 and m = 0…10. |
| A2 | l.48 | Dashed horizontal lines mark the true magnitudes; coloured traces show the estimates | Confirmed | `hline!` with `ls=:dash` at the true magnitudes; frames. |
| A3 | l.50 | Scripts square the coefficients in exact integer arithmetic | Confirmed | `big.(...)`, `Vector{BigInt}`. Ratios are taken in 256-bit BigFloat. |
| A4 | l.50 | In double precision they overflow at m = 8 | Confirmed | Float64 replay: Case 1 m = 8 gives `[1, -1.34e154, 1.86e276, NaN, Inf]`; Case 2 m = 8 gives `[1, -1.73e179, Inf, NaN, Inf]`. m = 7 is finite for both. |
| A5 | l.50 | Largest coefficient of p₈ ≈ 2.2×10³⁵³ (Case 1) | Confirmed | 2.158e353 (sympy, exact) |
| A6 | l.50 | Largest coefficient of p₈ ≈ 8.6×10⁴³⁴ (Case 2) | Confirmed | 8.636e434 (sympy, exact) |
| C1-1 | l.52 | Case 1: f = (x+1)(x−2)(x+3)(x−4) | Confirmed | Expands to x⁴−2x³−13x²+14x+24, which is `c0` in the script. Also matches archive Examples 3/4. |
| C1-2 | l.52 | True \|r_k\| ∈ {1,2,3,4} | Confirmed | sympy roots {4, 2, −1, −3} |
| C1-3 | l.54 | All four estimates converge quadratically; error roughly squares each step | Confirmed (asymptotically) | Relative error of r₁: 0.084 → 0.0124 → 6.2e-4 → 3.1e-6 → 1.6e-10. r₂ is not monotone early (err 0.017 at m = 1, then 0.059 at m = 2), but "roughly" covers that. |
| C1-4 | l.54 | "because \|r_k/r_{k+1}\|^{2^m} → ∞ exponentially" | Confirmed in substance; the word is imprecise (doubly exponential) | F2 (secondary) |
| C1-5 | l.54 | \|r₁\|/\|r₂\| = 4/3, the closest pair | Confirmed | Ratios 4/3, 3/2, 2 |
| C1-6 | l.54 | A few squaring steps are enough to separate them | Confirmed | m = 4 gives all four magnitudes to ≥ 3 digits. m = 6 gives ≥ 9 digits. |
| C1-7 | l.56 | Link `graeffesaa.jl` is Case 1 | Confirmed | Script header and polynomial |
| C1-8 | l.58 | Alt: roots −3, −1, 2, 4 | Confirmed | sympy |
| C1-9 | l.58 | Alt: each trace moves from a poor initial estimate onto the dashed true line | Confirmed | Frames 1–9. m = 0 estimates are 2, 6.5, 1.08, 1.71, and all land on their lines by m ≈ 4. |
| C1-10 | l.58 | Embed `graeffesaa.gif` is Case 1 | Confirmed | Frame title "Distinct Roots, f(x) = (x+1)(x−2)(x+3)(x−4)". Byte-identical to the regenerated GIF (manifest). |
| C2-1 | l.60 | Case 2: f = (x−1)(x+2)(x−5)² | Confirmed | Expands to x⁴−9x³+13x²+45x−50, which is `c0` in the script and archive Example 6. |
| C2-2 | l.60 | True \|r_k\| ∈ {1,2,5,5} | Confirmed | sympy roots {1, −2, 5 (double)} |
| C2-3 | l.62 | The two double-root estimates converge linearly; error halved each iteration | Confirmed | r₁ err: 0.453, 0.221, 0.109, 0.0544, 0.0271, 0.0136, 0.0068, 0.0034. r₂: −0.414, −0.212, −0.107, −0.0539, … The ratio is ≈ 0.49–0.50, and the values equal 5·2^{±1/2^m} − 5 exactly. |
| C2-4 | l.62 | Both target \|r\| = 5 | Confirmed | Limits are 5·2^{±1/2^m} → 5 |
| C2-5 | l.62 | Reason: the separated condition fails for equal magnitudes | Confirmed | c₃/c₄ ≈ 2·5^{2^m}, which gives the factor 2^{1/2^m}. |
| C2-6 | l.62 | Simple roots converge quadratically | Confirmed | r₃ err: 6.5e-4, 1.8e-6, 1.45e-11, 1.7e-21, 4.6e-41. r₄: 4.9e-4, 9.5e-7, 7.3e-12, 8.5e-22. |
| C2-7 | l.62 | The contrast in rate is the signature of two roots of equal magnitude | Confirmed | Shown by C2-3 and C2-6. Roots ±r give the same picture after one squaring. |
| C2-8 | l.64 | Link `graeffesab.jl` is Case 2 | Confirmed | Script header |
| C2-9 | l.66 | Alt: double root at 5, simple roots at 1 and −2 | Confirmed | sympy |
| C2-10 | l.66 | Alt: two blue traces approach the dashed line at 5 slowly; crimson and orange (simple roots) converge rapidly | Confirmed | Frame 11: both double-root traces steelblue (r₁ solid with circles, r₂ dashed with diamonds), r₃ crimson, r₄ dark orange. The blue traces reach the line visually only at m ≈ 6–7; crimson and orange are flat from m = 2. |
| C2-11 | l.66 | Embed `graeffesab.gif` is Case 2 | Confirmed | Frame title "Repeated Root at x = 5, f(x) = (x−1)(x+2)(x−5)²". Byte-identical to the regenerated GIF. |
| G1 | GIF ab, last frame | Annotation "r₁, r₂: linear convergence (double root) / r₃, r₄: quadratic convergence" | Confirmed | C2-3 and C2-6 |
| G2 | GIF legends | r₁ = 4, r₂ = 3, r₃ = 2, r₄ = 1 (Case 1); r₁ = r₂ = 5 double, r₃ = 2, r₄ = 1 (Case 2) | Confirmed | Each trace k plots `estimates[·][k]`, and its limit equals the labelled magnitude. |

---

### 3. Implementation checks

### `graeffesaa.jl` (Case 1)

1. **Method.** This is the classical Graeffe root-squaring step written with even and odd parts: $q(t) = E(t)^2 - tO(t)^2 = p(\sqrt t)\,p(-\sqrt t)$. For even n this equals the page's $(-1)^n$ form, so the variant matches. The estimates come from the separated-root theorem using consecutive coefficient ratios to the power $1/2^m$. No sign recovery is done, and the page and GIF talk only about magnitudes, which is consistent.
   - Step coefficients checked by hand: d₃ = 2c₄c₂ − c₃², d₂ = c₂² + 2c₄c₀ − 2c₃c₁, d₁ = 2c₂c₀ − c₁², d₀ = c₀².
   - p₁ = [1, −30, 273, −820, 576]. This matches Mathews' f₁ (archive image gr_160: "576 − 820x + 273x² − 30x³ + x⁴") and my sympy construction from the page's formula. Its roots are 1, 4, 9, 16.
2. **Numbers.**
   - Method: an instrumented copy (`review/graeffesaa_instr.jl`, with the plotting removed and print statements added) compared against `review/indep.py`. That script builds pₘ independently by expanding $(-1)^n p(s)p(-s)$ in sympy and mapping $s^2\to x$, then computes the ratios in 60-digit mpmath.
   - Script vs independent, r₁ … r₄:
     - m = 0: 2.0, 6.5, 1.076923…, 1.714285… vs the same.
     - m = 1: 5.477225575051661, 3.0166206257996713, 1.7331079030640313, 0.8381163549234938 vs 5.4772255750516611, 3.0166206257996712, 1.7331079030640313, 0.83811635492349384.
     - m = 4: 4.002497732041316, 2.9984158052786656, 1.9998098518052791, 0.9999990448669753 vs identical to 16 digits.
     - m = 6: 4.000000000630668, 2.9999999995272506, 1.9999999999998321, 1.0 vs 4.0000000006306681, 2.9999999995272507, 1.9999999999998321, 1.0. Mathews' Example 4 output (gr_165) gives {4.000000000630668, 2.999999999527251, 1.999999999999832, 1.}.
     - m = 7, 8: 4, 3, 2, 1 to Float64 precision. The true errors are ≤ 3e-18.
   - Precision: BigInt/BigInt is converted to 256-bit BigFloat, and the exponent 1/2^m is an exact power of two, so no precision is lost before the final Float64 conversion.
3. **Reference values.** The true magnitudes [4, 3, 2, 1] are the roots of the stated polynomial (sympy). The coefficient vector [1, −2, −13, 14, 24] is the expansion of the factored form.
4. **Picture.**
   - Frames 1, 2, 3, 5 and 9 are consistent with the plotting code, and the plotted points match the printed estimates: the m = 1 points at 5.48, 3.02, 1.73 and 0.84 appear at those heights.
   - ylims (0, 7) contain every estimate (maximum 6.5 at m = 0). There is no clamping or masking.
   - The title polynomial matches the code, and the legend labels match the limit of each trace.
   - There are 9 frames (m = 0…8).

### `graeffesab.jl` (Case 2)

1. **Method.** Same Graeffe step and estimator as Case 1, unmodified; the double-root formula is not used. The page presents this deliberately to show the linear convergence.
   - p₁ = [1, −55, 879, −3325, 2500] in both the script and sympy. Its roots are 1, 4, 25, 25.
2. **Numbers.** Script vs independent:
   - m = 0: 9, 1.4444, 3.4615, 1.1111 vs the same.
   - m = 3: 5.452762839454685, 4.585585395180367, 2.000647295666256, 0.9995121514767479 vs 5.4527628394546856, 4.5855853951803669, 2.0006472956662562, 0.99951215147674789.
   - m = 10: 5.003385653465331, 4.996616637513254, 2.0, 1.0 vs 5.0033856534653318, 4.9966166375132538, 2.0, 1.0.
   - Property check: the double-root estimates equal $5\cdot2^{\pm1/2^m}$ to the printed precision at m = 6…10. For example, at m = 10 the errors are +0.00338565 and −0.00338336, which are exactly 5·2^{1/1024} − 5 and 5·2^{−1/1024} − 5. This is the analytic prediction from c₃/c₄ ≈ 2R and c₂/c₃ ≈ R/2 with R = 5^{2^m}.
3. **Reference values.** [5, 5, 2, 1] are correct (sympy roots 5 (×2), 1, −2). The coefficient vector [1, −9, 13, 45, −50] matches the factored form and archive Example 6 (image gr_263).
4. **Picture.**
   - Frames 1, 4, 7 and 11 are consistent with the code. ylims (0, 9.5) contain the maximum estimate of 9.0 at m = 0. No clamping.
   - The r₂ trace is drawn dashed with diamonds and the r₁ trace solid with circles, both steelblue. The dashed reference line at 5 is drawn twice, which is harmless.
   - The annotation appears on the last frame only, and its content is confirmed (G1).
   - There are 11 frames (m = 0…10).

### Overflow claim (both scripts)

I replayed `graeffe_step` in Float64 from the same starting coefficients (`instr.out`):
- **Case 1:** finite through m = 7 (largest coefficient 4.6e176). At m = 8 the result is `[1, -1.34e154, 1.86e276, NaN, Inf]`.
- **Case 2:** finite through m = 7 (largest 2.9e217). At m = 8 the result is `[1, -1.73e179, Inf, NaN, Inf]`.

This confirms page line 50 and the script comments (aa l.11–12, ab l.12–13).

### Regeneration

The manifest reports that both scratch runs exit with status 0 and produce GIFs byte-identical to the committed ones. I did not rerun the full plotting scripts. My instrumented copies use the scripts' own computational code, unchanged up to the `# --- Animation` marker.

