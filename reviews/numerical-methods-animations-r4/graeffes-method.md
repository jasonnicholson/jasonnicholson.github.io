# Graeffe's Method — animation review (round 4)

Page: `pages/numerical-methods/graeffes-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### Finding 1: Page match, Minor. "Diagnostic signature of two roots of equal magnitude" claims more than is true

- **Location:** `index.qmd` line 62, Case 2 Behavior: *"This contrast in convergence rate is the diagnostic signature of two roots of equal magnitude (here a repeated root)."*
- **What is there now:** linear convergence of the two top estimates is presented as the signature of *any* two roots of equal magnitude.
- **What is true instead:**
  - The halving-error pattern appears when the equal-magnitude roots are real: a double root, or a pair ±r (which becomes a double root after one squaring).
  - When the two equal-magnitude roots are a complex-conjugate pair, the coefficient c_{n-1} of p_m contains 2|r|^N cos(Nθ). The two estimates then wander irregularly about |r| and their error does not halve each step.
  - The Description (line 44) itself lists complex pairs as a separate special case.
- **How I know:** `python3 -I review/complexpair.py` uses roots 3±4i, 2, 1. These have the same magnitudes {5, 5, 2, 1} as Case 2.
  - Top two estimates for m = 3…10: (4.896, 5.107), (5.080, 4.922), (4.835, 5.171), (5.050, 4.951), (5.017, 4.983), (4.982, 5.018), (5.006, 4.994), (5.002, 4.998).
  - The errors change sign and do not shrink monotonically: |error| goes 0.10, 0.08, 0.17, 0.05, 0.017, 0.018, …
  - For comparison, `review/pm5.py` uses Mathews Example 9 (roots 5, −5, 2, −1). From m = 1 on it reproduces Case 2's sequence exactly: 7.416, 5.966, 5.453, 5.221, … So the claim holds for real equal-magnitude roots.
- **Suggested correction:** "…is the diagnostic signature of a repeated real root (or, equivalently, a real pair ±r). A complex-conjugate pair, which also has two roots of equal magnitude, instead makes the estimates oscillate irregularly."

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Not a finding (noted for completeness): legacy examples not animated

Both page cases come from Mathews:
- Case 1 is the polynomial of Examples 2–4, (x−4)(x+3)(x−2)(x+1).
- Case 2 is Example 6, −50+45x+13x²−9x³+x⁴.

Mathews' other worked examples are not animated:
- Example 5 (degree 6)
- Example 7 (repeated root; its formula image is missing from the archive)
- Example 8 (degree 7)
- Example 9, x⁴−x³−27x²+25x+50 = (x−5)(x+5)(x−2)(x+1), "unequal real roots of equal magnitude"

The page does not claim to cover them, so I treat these as content the page does not have rather than a fidelity error. Example 9 would be the natural one to add if the owner wants the "equal magnitude" sentence illustrated.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `graeffesaa.jl` | 0 | 6.1 | graeffesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `graeffesab.jl` | 0 | 7.9 | graeffesab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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
| D1 | Description, Root Squaring | p_1(x) = (−1)^n p(√x) p(−√x) has roots r_k² | confirmed | Matches the script's E(t)² − t·O(t)² for n=4. My own expansion gives d3=2c4c2−c3², d2=c2²+2c4c0−2c3c1, d1=2c2c0−c1², d0=c0², identical to the code. p_1 for Case 1 = [1,−30,273,−820,576], which is the monic polynomial with roots 1,4,9,16 (e1=30, e2=273, e3=820, e4=576 by hand). |
| D2 | Description | m squarings give roots r_k^(2^m) | confirmed | The script's iterates equal my symmetric-function coefficients. All estimates agree to 12 digits for every m (tables in §3). |
| D3 | Description, Separated Root Theorem | \|r_k\|^(2^m) ≈ \|c_{n−k}/c_{n−k+1}\|, \|r_k\| ≈ (…)^(1/2^m) | confirmed | The script uses c[k+1]/c[k] in highest-first order, which is c_{n−k}/c_{n−k+1}. The estimates converge to the true magnitudes. |
| D4 | Description | Sign chosen by checking p(±\|r_k\|) | confirmed (as method description) | Standard procedure, also in Mathews. The scripts plot magnitudes only and the page does not claim they determine signs. |
| D5 | Description, Convergence | Distinct-magnitude real roots: error decreases quadratically, digits roughly double | confirmed | Case 1 errors, e.g. r₁: 4.98e−2, 2.50e−3, 1.26e−5, 6.31e−10, 3.18e−18 (about 1.3→2.6→4.9→9.2→17.5 digits). |
| D6 | Description | \|c_{n−k}/c_n\| ≈ (\|r_1\|⋯\|r_k\|)^(2^m) | confirmed | Vieta. For example, Case 1 log10 max\|coef p_8\| = 353.33 ≈ 256·log10 24. |
| D7 | Description | Double precision overflows after a handful of iterations | confirmed | The Float64 run of both scripts' recurrence is finite through m=7 and not finite at m=8. |
| A1 | Animations intro | Each animation shows Separated Root Theorem magnitude estimates over m = 0,1,2,… | confirmed | Plot code and frames: the x-axis is m and the y-axis is the estimate. |
| A2 | Intro | Dashed horizontal lines mark the true root magnitudes | confirmed | `hline!` at true_mags with ls=:dash, visible in all frames. Values 4,3,2,1 and 5,5,2,1 verified as the true roots. |
| A3 | Intro | Coloured traces converge toward (or slowly approach) the targets | confirmed | Final frames: Case 1 all on target; Case 2 r₁,r₂ at 5.0034 and 4.9966 at m=10. |
| A4 | Intro | Scripts use exact integer arithmetic | confirmed | `big.(...)`, `Vector{BigInt}`. Ratios are formed as BigFloat (256-bit). |
| A5 | Intro | Double precision overflows at m = 8 | confirmed | Instrumented Float64 run: `m=8 finite=false` in both cases, m≤7 finite. |
| A6 | Intro | Largest coeff of p_8 ≈ 2.2×10^353 (Case 1) | confirmed | Independent: 2.1581e353. Script: log10 = 353.334. |
| A7 | Intro | Largest coeff of p_8 ≈ 8.6×10^434 (Case 2) | confirmed | Independent: 8.6362e434. Script: log10 = 434.936. |
| C1-1 | Case 1 heading | f(x) = (x+1)(x−2)(x+3)(x−4) | confirmed | numpy `poly` of roots −1,2,−3,4 = [1,−2,−13,14,24] = script `c0`. Same function in the GIF title. |
| C1-2 | Case 1 heading | true \|r_k\| ∈ {1,2,3,4} | confirmed | Roots −1,2,−3,4. |
| C1-3 | Case 1 Behavior | All four estimates converge quadratically from m=3 on, digits roughly doubling | confirmed | Errors m=3…7: r₁ 4.98e−2, 2.50e−3, 1.26e−5, 6.31e−10, 3.18e−18; r₂ −2.12e−2, −1.58e−3, −9.2e−6, −4.73e−10, −2.39e−18; r₃ −9.5e−3, −1.9e−4, −1.45e−7, −1.68e−13, −4.5e−25; r₄ −5.1e−4, −9.6e−7, −7.3e−12, −8.5e−22, −2.3e−41. |
| C1-4 | Case 1 Behavior | because \|r_k/r_{k+1}\|^(2^m) → ∞ doubly exponentially | confirmed | Ratios 4/3, 3/2, 2 are all >1 (page's descending ordering). |
| C1-5 | Case 1 Behavior | First steps irregular; r₂ estimate is 3.017 at m=1 | confirmed | 3.0166206 (script and independent). |
| C1-6 | Case 1 Behavior | r₂ moves away to 2.941 at m=2 before converging | confirmed | 2.9409171, then 2.9788, 2.9984, … |
| C1-7 | Case 1 Behavior | \|r₁\|/\|r₂\| = 4/3; a few squarings separate them | confirmed | (4/3)^8 ≈ 10 at m=3; errors are below 5% by m=3. |
| C1-8 | Case 1 link | [Julia source](graeffesaa.jl) is this case | confirmed | Script polynomial and title match the heading. |
| C1-9 | Case 1 embed | graeffesaa.gif | confirmed | Produced by graeffesaa.jl (byte-identical regeneration). Title in the frames matches. |
| C1-10 | Case 1 alt | Four distinct real roots −3, −1, 2, 4 | confirmed | |
| C1-11 | Case 1 alt | Each trace moves from a poor initial approximation onto the dashed true-value line | confirmed | m=0 estimates 2.0, 6.5, 1.077, 1.714. The final frame has all traces on their lines (frame_009). |
| C2-1 | Case 2 heading | f(x) = (x−1)(x+2)(x−5)² | confirmed | numpy `poly` of 1,−2,5,5 = [1,−9,13,45,−50] = script `c0`. Same in the GIF title. |
| C2-2 | Case 2 heading | Repeated real root at x=5, true \|r_k\| ∈ {1,2,5,5} | confirmed | |
| C2-3 | Case 2 Behavior | Double-root estimates converge linearly, error halved each iteration | confirmed | r₁ errors 0.966, 0.453, 0.221, 0.109, 0.0544, 0.0271, 0.0136, 0.00677, 0.00339 (ratio about 0.49–0.50). r₂ is similar with opposite sign. Asymptotically est = 5·2^(±1/2^m). |
| C2-4 | Case 2 Behavior | Separated-root condition never satisfied when two roots share a magnitude | confirmed | \|r₁\|^N = \|r₂\|^N for all N. |
| C2-5 | Case 2 Behavior | Simple roots \|r\|=1, 2 converge quadratically as usual | confirmed | r₃ errors m=2…6: 5.3e−3, 6.5e−4, 1.8e−6, 1.45e−11, 1.7e−21. r₄: 1.6e−2, 4.9e−4, 9.5e−7, 7.3e−12, 8.5e−22. |
| C2-6 | Case 2 Behavior | This contrast is the diagnostic signature of two roots of equal magnitude (here a repeated root) | **wrong as a general statement** (Minor) | See Finding 1: it holds for a double root or ±r, not for a complex-conjugate pair. |
| C2-7 | Case 2 link | [Julia source](graeffesab.jl) is this case | confirmed | |
| C2-8 | Case 2 embed | graeffesab.gif | confirmed | Byte-identical regeneration. The title matches the heading. |
| C2-9 | Case 2 alt | Double root at x=5 and simple roots at x=1 and x=−2 | confirmed | |
| C2-10 | Case 2 alt | Two blue traces for the double root approach the dashed line at 5 slowly | confirmed | Both are `:steelblue` (circle and diamond markers), at 5.0034 and 4.9966 at m=10 (frame_011). |
| C2-11 | Case 2 alt | Crimson and orange traces for the simple roots converge rapidly | confirmed | r₃ is `:crimson` (\|r\|=2), r₄ is `:darkorange` (\|r\|=1). Both are visually on their lines from m=2. |

---

### 3. Implementation checks

### `graeffesaa.jl` (Case 1)

- **Method:** classical Graeffe (Dandelin–Lobachevsky–Graeffe) root squaring. Each step computes p_{m+1}(t) = E(t)² − t·O(t)², which equals p(√t)p(−√t) for n=4. The magnitude estimates are the separated-root ratios |c_{n−k}/c_{n−k+1}|^(1/2^m). This is the method the page describes. No variant or hybrid is involved.
- **Numbers:** the script's estimates (instrumented copy) and my independent estimates (coefficients from elementary symmetric functions of r^(2^m), exact integers, 60-digit mpmath for the roots) agree to all 12 printed digits at every m:

| m | script r₁, r₂, r₃, r₄ | independent |
|---|---|---|
| 0 | 2.000000000000, 6.500000000000, 1.076923076923, 1.714285714286 | 2.0, 6.5, 1.07692307692, 1.71428571429 |
| 1 | 5.477225575052, 3.016620625800, 1.733107903064, 0.838116354923 | 5.47722557505, 3.0166206258, 1.73310790306, 0.838116354923 |
| 2 | 4.337613136533, 2.940917081341, 1.917379336611, 0.981227256835 | 4.33761313653, 2.94091708134, 1.91737933661, 0.981227256835 |
| 3 | 4.049792933038, 2.978782575513, 1.990491511456, 0.999491923038 | 4.04979293304, 2.97878257551, 1.99049151146, 0.999491923038 |
| 4 | 4.002497732041, 2.998415805279, 1.999809851805, 0.999999044867 | 4.00249773204, 2.99841580528, 1.99980985181, 0.999999044867 |
| 5 | 4.000012555971, 2.999990800368, 1.999999855136, 0.999999999993 | 4.00001255597, 2.99999080037, 1.99999985514, 0.999999999993 |
| 6 | 4.000000000631, 2.999999999527, 2.0, 1.0 | 4.00000000063, 2.99999999953, 2.0, 1.0 |
| 7–8 | 4, 3, 2, 1 to 12 digits | same (errors ≤ 3e−18) |

- **Reference values:** true magnitudes {4,3,2,1}. The roots of the stated polynomial were verified by numpy `poly` and by hand expansion.
- **Picture:**
  - I viewed `sheet.png` (all 9 frames) and frame_009.
  - Frame k shows the estimates for m = 0..k, with markers at the computed values. For example, r₂ is at 6.5 at m=0 and r₁ peaks at 5.48 at m=1.
  - The dashed lines sit at 4, 3, 2, 1 in matching colours. The title "m = $frame" matches the last plotted point.
  - The y-limits [0,7] contain every value; the maximum is 6.5. Nothing is clamped or masked.
  - The legend labels match the magnitude ordering used in the Description.

### `graeffesab.jl` (Case 2)

- **Method:** the same squaring step and estimator as Case 1. Run for m = 0..10.
- **Numbers:** script and independent values agree to 12 digits at every m:

| m | script r₁, r₂, r₃, r₄ | independent |
|---|---|---|
| 0 | 9.0, 1.444444444444, 3.461538461538, 1.111111111111 | 9.0, 1.44444444444, 3.46153846154, 1.11111111111 |
| 1 | 7.416198487096, 3.997726626699, 1.944918410191, 0.867109969524 | 7.4161984871, 3.9977266267, 1.94491841019, 0.867109969524 |
| 2 | 5.966149802101, 4.246209541849, 2.005317621517, 0.984217898321 | 5.9661498021, 4.24620954185, 2.00531762152, 0.984217898321 |
| 3 | 5.452762839455, 4.585585395180, 2.000647295666, 0.999512151477 | 5.45276283945, 4.58558539518, 2.00064729567, 0.999512151477 |
| 4 | 5.221368982218, 4.788016596287, 2.000001799961, 0.999999046333 | 5.22136898222, 4.78801659629, 2.00000179996, 0.999999046333 |
| 5 | 5.109485743271, 4.892860310439, 2.000000000015, 0.999999999993 | 5.10948574327, 4.89286031044, 2.00000000001, 0.999999999993 |
| 6 | 5.054446430259, 4.946140065970, 2, 1 | 5.05444643026, 4.94614006597, 2.0, 1.0 |
| 7 | 5.027149505564, 4.972997117418 | 5.02714950556, 4.97299711742 |
| 8 | 5.013556375251, 4.986480280427 | 5.01355637525, 4.98648028043 |
| 9 | 5.006773599461, 4.993235564455 | 5.00677359946, 4.99323556445 |
| 10 | 5.003385653465, 4.996616637513 | 5.00338565347, 4.99661663751 |

  - Asymptotic check, independent of the code: for a double root, c_{n−1} ≈ −2·5^N, so est₁ ≈ 5·2^(1/N) and est₂ ≈ 5·2^(−1/N).
  - At m=10 (N=1024) this gives 5.00339 and 4.99662, which matches the computed values.
- **Reference values:** true magnitudes {5,5,2,1}, verified by expansion.
- **Picture:**
  - I viewed frame_011 and the contact sheet.
  - The traces run from 9.0 and 1.44 at m=0 toward the dashed line at 5. r₃ starts at 3.46 and r₄ at 1.11, then both settle on 2 and 1.
  - y-limits [0, 9.5] contain the maximum value, 9.0.
  - The final-frame annotation "r₁, r₂: linear convergence (double root) / r₃, r₄: quadratic convergence" agrees with the computed errors.
  - The x-axis ticks fall at 0, 2.5, 5, 7.5, 10 (non-integer m). This is cosmetic and not misleading.

### Legacy archive

- Mathews Example 6 is exactly Case 2's polynomial (−50+45x+13x²−9x³+x⁴). His text says the iteration "will proceed linearly for the repeated root and quadratically for the simple roots", which matches the page and my computation.
- Examples 2–4 use Case 1's polynomial.
- No function or parameter departs from the archive. On examples not animated, see the note under §1.
- The archive's Example 6 and 7 solution graph images are missing on disk, so I could not compare plots.

