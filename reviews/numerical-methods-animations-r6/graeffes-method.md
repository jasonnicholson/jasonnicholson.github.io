# Graeffe's Method — animation review (round 6)

Page: `pages/numerical-methods/graeffes-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** I found no errors, nothing misleading and no minor issues of substance. Section 2 shows every claim I checked and section 3 shows the evidence.

These points were considered and deliberately not raised:
- **Mathews examples not animated (Fidelity, not raised).** The archive has 9 examples. Example 1 is the separated-root theorem alone, Example 2 explores root squaring, Examples 3 and 4 use the same polynomial as Case 1, Example 5 is degree 6, Examples 6 and 7 have repeated roots (Example 6 uses the same polynomial as Case 2), Example 8 is degree 7, and Example 9 has a real pair ±5. The archive has no animated GIF for this topic (nothing under `a2001/Animations/`). The page's two cases reproduce Mathews' Example 3/4 polynomial `24+14x−13x²−2x³+x⁴` and Example 6 polynomial `−50+45x+13x²−9x³+x⁴` exactly. The page also covers Example 9's behaviour (±r) in words, and the numbers support those words (section 2, claim B6). The other examples are content the page does not have, so I did not count them as departures. I could not read Example 7's polynomial because its image `GraeffeMethodMod_gr_434.gif` is missing from the local archive.
- **The Case 2 GIF draws the double-root traces visually on the line from about m = 7.** At m = 7 the error is 0.027, which is about 1 px at this scale. The contrast with the simple roots, which are on their lines by m ≈ 2, is still plainly visible, and the page's "linear" claim is about the numbers, which bear it out. This is a presentation choice and does not mislead.
- **Case 2's x-axis ticks are 0, 2.5, 5, 7.5, 10 for an integer iteration index.** This is cosmetic.
- **"Quadratic" convergence, strictly speaking.** The relative error is about ρ^(2^m)/2^m, so e_{m+1}/e_m² grows like 2^m. For Case 1's r₁ the ratio is 1.0, 2.0, 4.0, 8.0, 16 for m = 3→4 through 7→8. The page's operational statement, that the number of correct digits roughly doubles, is true (the order is 2 in the log sense), so this is not a finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `graeffesaa.jl` | 0 | 6.2 | graeffesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `graeffesab.jl` | 0 | 9.5 | graeffesab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description (method formulas and algorithm)
| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | $p_1(x) = (-1)^n p(\sqrt x)\,p(-\sqrt x)$ has roots $r_k^2$ | confirmed | $p(\sqrt x)p(-\sqrt x)=a_n^2\prod(\sqrt x-r)(-\sqrt x-r)=a_n^2(-1)^n\prod(x-r^2)$. The script's $E(t)^2-tO(t)^2$ is this product for n = 4. The script's p₁ for Case 1, `[1,-30,273,-820,576]`, equals the polynomial with roots {1,4,9,16} built independently from the roots (`indep.out`). |
| D2 | Applying it m times gives roots $r_k^{2^m}$ | confirmed | The script's p₂ for Case 1 is `[1,-354,26481,-357904,331776]`, and the independent product of (x−r^{4}) gives the same. Every estimate from m = 0 to 8 (Case 1) and m = 0 to 10 (Case 2) matches to all 12 printed digits. |
| D3 | $\lvert r_k\rvert^{2^m}\approx\lvert c_{n-k}/c_{n-k+1}\rvert$, with $c_j$ the coefficient of $x^j$ and k = 1…n in descending magnitude | confirmed | This is Vieta's formula $e_k/e_{k-1}\to r_1\cdots r_k/(r_1\cdots r_{k-1})$. The script indexes it the same way: `c[2]/c[1]` is c₃/c₄ (k = 1), …, `c[5]/c[4]` is c₀/c₁ (k = 4). |
| D4 | $\lvert r_k\rvert\approx\lvert c_{n-k}/c_{n-k+1}\rvert^{1/2^m}$ | confirmed | Script line 37 / line 34 (`ratios .^ (1.0/2^m)`), and the estimates converge to the true magnitudes (section 3). |
| D5 | Sign chosen by testing $p(\pm\lvert r_k\rvert)$ | confirmed (method statement) | This is the standard rule and matches Mathews. The scripts show only magnitudes, and the page says so. |
| D6 | For distinct-magnitude real roots the error decreases quadratically and the number of digits roughly doubles per step | confirmed | Case 1 correct digits (−log₁₀ of relative error) at m = 3…8: r₁ 1.9, 3.2, 5.5, 9.8, 18.1, 34.4; r₄ 3.3, 6.0, 11.1, 21.1, 40.6 (`indep.out`). |
| D7 | Coefficients grow doubly exponentially, $\lvert c_{n-k}/c_n\rvert\approx(\lvert r_1\rvert\cdots\lvert r_k\rvert)^{2^m}$ | confirmed | log₁₀ of the largest coefficient for m = 0…8 in Case 1 is 1.38, 2.91, 5.55, 11.0, 22.1, 44.2, 88.3, 176.7, 353.3, which doubles each step. At m = 8, c₀ = 24^256 exactly. |
| D8 | "Most software cannot apply more than a handful of iterations before overflow" | confirmed | In IEEE double, both cases first produce Inf at m = 8 (`f64.py`). |

### Animations section
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| A1 | Each animation shows the separated-root estimates over m = 0, 1, 2, …; dashed lines are true magnitudes; coloured traces are estimates | confirmed | Plotting code (`hline!` with `ls=:dash`; traces solid with markers) and the frames: committed `graeffesaa/frame_001.png`, `frame_009.png` and `graeffesab/frame_011.png`, and both contact sheets. |
| A2 | Scripts use exact integer arithmetic | confirmed | `c0 = big.([...])`, `Vector{Vector{BigInt}}`, and the step function uses only `*` and `-`. |
| A3 | In double precision they overflow at m = 8 | confirmed | In `f64.py`, Case 1 has max 4.6e176 at m = 7 and Inf at m = 8; Case 2 has max 2.9e217 at m = 7 and Inf at m = 8. |
| A4 | Largest coefficient of p₈ is about 2.2×10^353 (Case 1) | confirmed | The BigInt run gives 2.158×10^353 (the coefficient c₁). 24^256 = 2.158×10^353. |
| A5 | Largest coefficient of p₈ is about 8.6×10^434 (Case 2) | confirmed | The BigInt run gives 8.636×10^434 (c₁). 50^256 = 8.636×10^434. |

### Case 1
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| C1 | f(x) = (x+1)(x−2)(x+3)(x−4), and the script's coefficients [1,−2,−13,14,24] | confirmed | sympy expansion gives x⁴−2x³−13x²+14x+24. This matches the script's line 13 and Mathews Examples 3 and 4. |
| C2 | True \|r_k\| ∈ {1,2,3,4} | confirmed | Roots −1, 2, −3, 4. |
| C3 | All four estimates converge quadratically | confirmed | Errors at m = 8: 1.6e−34, −1.2e−34, −6.5e−48, and below 1e−60. |
| C4 | From m = 3 on, the correct digits in each estimate roughly double at every step | confirmed (roughly) | Digit ratios from step to step from m = 3: r₁ ×1.68, 1.72, 1.78, 1.85, 1.90; r₂ ×1.52, 1.68, 1.78, 1.85, 1.90; r₃ ×1.73, 1.78, 1.83, 1.88, 1.93; r₄ ×1.83, 1.85, 1.89, 1.93. Only r₂'s first step (×1.5) is loose, and "roughly" covers it. |
| C5 | Reason: $\lvert r_k/r_{k+1}\rvert^{2^m}\to\infty$ doubly exponentially | confirmed | This is the standard mechanism. |
| C6 | First steps are irregular; the r₂ estimate is 3.017 at m = 1 and moves away to 2.941 at m = 2 before converging | confirmed | The script and the independent computation both give 3.0166206258 at m = 1 and 2.940917081341 at m = 2 (the error grows from 0.0166 to 0.0591), then 2.9788 and 2.99842. |
| C7 | \|r₁\|/\|r₂\| = 4/3 initially; a few squaring steps separate them | confirmed | (4/3)^16 ≈ 99.8 at m = 4. |
| C8 | Link `graeffesaa.jl` and embed `graeffesaa.gif` are Case 1 | confirmed | The script header and title match the heading. The committed GIF is byte-identical to the regenerated one (manifest). |
| C9 | Alt text: roots −3, −1, 2, 4; each trace moves from a poor initial approximation onto its dashed line | confirmed | At m = 0 the estimates are 2.0, 6.5, 1.077, 1.714 (frame_001). In frame_009 every trace lies on its line. |
| C10 | Frame count (implicit, m = 0…8) | confirmed | 9 frames. The titles read m = 0 … m = 8. |

### Case 2
| # | Claim | Verdict | Evidence |
|---|---|---|---|
| B1 | f(x) = (x−1)(x+2)(x−5)², and the script's coefficients [1,−9,13,45,−50] | confirmed | sympy expansion. This matches Mathews Example 6. |
| B2 | True \|r_k\| ∈ {1,2,5,5} | confirmed | |
| B3 | The double-root estimates converge linearly and the error halves each iteration | confirmed | Errors for r₁ at m = 3…10: 0.453, 0.221, 0.110, 0.0545, 0.0272, 0.0136, 0.00677, 0.00339, a ratio of 0.49 to 0.50. The estimates equal 5·2^{±1/2^m} to 12 digits (for example 5.003385653465 and 4.996616637513 at m = 10). |
| B4 | Reason: the separated-root condition fails for equal magnitudes | confirmed | c₃/c₄ ≈ 2·5^{2^m} and c₂/c₃ ≈ 5^{2^m}/2, which gives the factor 2^{±1/2^m}. |
| B5 | The simple roots (\|r\| = 1, 2) converge quadratically | confirmed | Correct digits for r₃ at m = 2…7: 2.6, 3.5, 6.0, 11.1, 21.1, 40.6. For r₄: 1.8, 3.3, 6.0, 11.1, 21.1, 40.6. |
| B6 | A real pair ±r behaves the same way, because one squaring turns it into a double root | confirmed | For roots {5,−5,2,−1} (Mathews Example 9), the estimates for m ≥ 1 are identical to Case 2's (`indep.out`, "pm5" block). |
| B7 | For roots 3±4i, 2, 1, the top two estimates cross back and forth over 5 and their error does not halve. It grows from m = 4 to 5 and from m = 7 to 8 | confirmed | The r₁ estimate for m = 2…10 is 5.675, 4.896, 5.080, 4.835, 5.050, 5.017, 4.982, 5.006, 5.0017, so it crosses 5 repeatedly. \|err\| goes from 0.0797 to 0.165 (m = 4→5) and from 0.01706 to 0.01825 (m = 7→8). r₂ shows the same pattern (0.0784→0.171 and 0.0170→0.0183). The successive error ratios are 0.76, 2.07, 0.30, 0.34, 1.07, 0.33 and 0.28, so the error does not halve. r₂'s error also grows from m = 0 to 1 (from exactly 0 to 2.88, because m = 0 happens to give 45/9 = 5). The page does not claim its list is exhaustive. |
| B8 | Link `graeffesab.jl` and embed `graeffesab.gif` are Case 2 | confirmed | The script and title match the heading. The GIF is byte-identical to the regenerated one. |
| B9 | Alt text: two blue traces for the double root approach 5 slowly; crimson and orange traces for the simple roots converge rapidly; simple roots at x = 1 and x = −2 | confirmed | `colors = [:steelblue, :steelblue, :crimson, :darkorange]`, with r₃ (\|r\| = 2) crimson and r₄ (\|r\| = 1) orange. Frames 1 to 11 bear this out. |
| B10 | Last-frame annotation "r₁, r₂: linear convergence (double root); r₃, r₄: quadratic convergence" | confirmed | Same evidence as B3 and B5. |
| B11 | Frame count (m = 0…10) | confirmed | 11 frames. The titles read m = 0 … m = 10. |

### 3. Implementation checks

### `graeffesaa.jl` (Case 1)
- **The method it claims to be:** yes. It is Graeffe root squaring: the step `q(t) = E(t)² − t·O(t)²` (lines 22 to 30), checked symbolically against D1, followed by the separated-root ratio estimates $\lvert c_{n-k}/c_{n-k+1}\rvert^{1/2^m}$ (lines 35 to 38). The variant is the plain Graeffe/Dandelin coefficient recurrence with no Mathews-style corrections for special cases, and the page describes the same variant.
- **The numbers are right.** The instrumented copy and the independent computation from the roots agree to all 12 printed digits:

| m | script r₁, r₂, r₃, r₄ | independent |
|---|---|---|
| 0 | 2.0, 6.5, 1.076923076923, 1.714285714286 | 2.0, 6.5, 1.076923076923, 1.714285714286 |
| 1 | 5.477225575052, 3.0166206258, 1.733107903064, 0.838116354923 | 5.477225575052, 3.0166206258, 1.733107903064, 0.8381163549235 |
| 2 | 4.337613136533, 2.940917081341, 1.917379336611, 0.981227256835 | identical |
| 3 | 4.049792933038, 2.978782575513, 1.990491511456, 0.999491923038 | identical |
| 4 | 4.002497732041, 2.998415805279, 1.999809851805, 0.999999044867 | identical |
| 5 | 4.000012555971, 2.999990800368, 1.999999855136, 0.999999999993 | identical |
| 6 | 4.000000000631, 2.999999999527, 2.0, 1.0 | 4.000000000631, 2.999999999527, 2.0 (err 1.7e−13), 1.0 (err 8.5e−22) |
| 7–8 | 4.0, 3.0, 2.0, 1.0 | errors ≤ 3.2e−18 |

  BigFloat (256-bit) ratios of exact BigInts introduce no meaningful error.
- **Reference values:** `true_mags = [4,3,2,1]` are the magnitudes of the roots of the expanded polynomial, checked by sympy factorisation.
- **The picture shows what was computed.** In frame_001 (m = 0) the markers sit at 2.0, 6.5, 1.08 and 1.71. In frame_002 (m = 1) they sit at 5.48, 3.02, 1.73 and 0.84. In frame_009 all traces lie on their dashed lines. The legend labels match the colours of the dashed lines. The title function matches the code, and the title's m matches the frame. The ylim of (0, 7) contains every value (maximum 6.5), so nothing is clamped.

### `graeffesab.jl` (Case 2)
- **The method it claims to be:** yes. The step and estimator are identical to Case 1's.
- **The numbers are right:**

| m | script r₁, r₂, r₃, r₄ | independent |
|---|---|---|
| 0 | 9.0, 1.444444444444, 3.461538461538, 1.111111111111 | identical |
| 1 | 7.416198487096, 3.997726626699, 1.944918410191, 0.867109969524 | identical |
| 2 | 5.966149802101, 4.246209541849, 2.005317621517, 0.984217898321 | identical |
| 4 | 5.221368982218, 4.788016596287, 2.000001799961, 0.999999046333 | identical |
| 6 | 5.054446430259, 4.94614006597, 2.0, 1.0 | identical (closed form 5·2^{±1/64} = 5.0544464303, 4.9461400660) |
| 8 | 5.013556375251, 4.986480280427, 2.0, 1.0 | identical (closed form 5.0135563753, 4.9864802804) |
| 10 | 5.003385653465, 4.996616637513, 2.0, 1.0 | identical (closed form 5.0033856535, 4.9966166375) |

- **Reference values:** `true_mags = [5,5,2,1]` is correct. Two dashed lines are drawn at 5, and they coincide.
- **The picture shows what was computed.** The sheet shows m = 0…10. At m = 0 the markers sit at 9, 1.44 (diamond), 3.46 and 1.11. The two blue traces bracket 5 from above and below, as 5·2^{±1/2^m} predicts. The last-frame annotation is correct. The ylim of (0, 9.5) contains the maximum, 9.0.

### Other checks
- Both committed GIFs are byte-identical to fresh scratch runs (manifest), so the frames reflect the current scripts.
- The overflow and largest-coefficient claims are checked by `f64.py` and the BigInt runs (A3 to A5).
- I found nothing I could not determine for the page's own claims. The only gap is Mathews Example 7's polynomial, whose formula image is missing from the local archive, so I could not compare it.

