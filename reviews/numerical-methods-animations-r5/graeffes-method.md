# Graeffe's Method — animation review (round 5)

Page: `pages/numerical-methods/graeffes-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, in the script headers and in the frames agrees with independent computation. The cosmetic notes below are not findings.

Observations that are not findings, recorded so the clean result can be audited:
- `graeffesab.jl` x-axis ticks fall at 2.5, 5.0, 7.5 and 10.0, so non-integer values of m are labelled. This is cosmetic and does not mislead.
- `graeffesab.jl` lines 62–65 draw the dashed line at 5 twice (once in the loop for k=1, then again explicitly). The second line is invisible and harmless.
- On the linear 0–9.5 axis, the double-root traces sit within about 1 px of the line at 5 from m≈7 on (error 0.027 at m=7). The linear-versus-quadratic contrast the page describes is clearly visible over m=1…6, so the picture supports the text.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `graeffesaa.jl` | 0 | 6.0 | graeffesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description, Root Squaring | p_1(x) = (−1)^n p(√x) p(−√x) has roots r_k² | indep.py builds p_1 exactly this way. sympy roots of p_1 for Case 1 are {16,9,4,1} and for Case 2 {25,25,4,1}. The result equals the script's `graeffe_step` output (p_1 = [1,−30,273,−820,576] for Case 1, which also matches Mathews' f₁ image gr_160) | confirmed |
| D2 | Description | m applications give roots r_k^{2^m} | sympy roots of p_2: {256,81,16,1} (Case 1), {625,625,16,1} (Case 2) | confirmed |
| D3 | Description, Separated Root Theorem | \|r_k\|^{2^m} ≈ \|c_{n−k}/c_{n−k+1}\|, with c_j the coefficient of x^j, and \|r_k\| ≈ (…)^{1/2^m} | This is the estimator both scripts use (`c[k+1]/c[k]` in descending order = c_{n−k}/c_{n−k+1}). Case 1 estimates converge to 4,3,2,1 (errors 1.6e−34 … 3.4e−80 at m=8) | confirmed |
| D4 | Description | Sign chosen by checking p(+\|r_k\|) vs p(−\|r_k\|) | Method statement only, consistent with Mathews (gr_165). The animations show magnitudes only and make no sign claim | confirmed (not exercised by scripts) |
| D5 | Description, Convergence | For real roots of distinct magnitudes the error decreases quadratically and the digits roughly double per iteration | Case 1 digits m=3→8: r₁ 1.3, 2.6, 4.9, 9.2, 17.5, 33.8 (successive ratios 1.88–2.0). r₂–r₄ give ratios 1.67–1.96 | confirmed |
| D6 | Description | Coefficients grow doubly exponentially; \|c_{n−k}/c_n\| ≈ (\|r_1\|⋯\|r_k\|)^{2^m} | max\|c\| of p_m for Case 1: 24, 820, 3.6e5, 1.1e11, 1.2e22, 1.5e44, 2.2e88, 4.6e176, 2.2e353. Each is ≈ 24^{2^m} = (4·3·2·1)^{2^m} | confirmed |
| D7 | Description | Most software overflows after a handful of iterations | Float64 overflows at m=8 for both cases (indep2.out) | confirmed |
| A1 | Animations intro | Traces show the Separated Root Theorem magnitude estimates for m = 0,1,2,… | Script `mag_estimates`, plotted per m (frames) | confirmed |
| A2 | Animations intro | Dashed horizontal lines mark the true root magnitudes | `hline!` at true_mags (4,3,2,1 / 5,5,2,1), visible in frames | confirmed |
| A3 | Animations intro | Scripts square the coefficients in exact integer arithmetic | `big.(…)`, `Vector{BigInt}`; instr.out prints `BigInt[…]` | confirmed |
| A4 | Animations intro | In double precision they overflow at m = 8 | indep2.out: Float64 finite through m=7 (max 4.65e176 and 2.94e217), Inf/NaN at m=8 in both cases | confirmed |
| A5 | Animations intro | Largest coefficient of p_8 ≈ 2.2×10^353 (Case 1) | 2.16e353 (indep.out) | confirmed |
| A6 | Animations intro | Largest coefficient of p_8 ≈ 8.6×10^434 (Case 2) | 8.64e434 (indep.out) | confirmed |
| C1-1 | Case 1 heading | f(x) = (x+1)(x−2)(x+3)(x−4) | sympy expansion = x⁴−2x³−13x²+14x+24 = script `c0`. Title in frames matches | confirmed |
| C1-2 | Case 1 heading | true \|r_k\| ∈ {1,2,3,4} | sympy roots {4,2,−1,−3} | confirmed |
| C1-3 | Case 1 Behavior | All four estimates converge quadratically | see D5. All four errors are below 1e−33 at m=8 | confirmed |
| C1-4 | Case 1 Behavior | From m = 3 on, the correct digits roughly double at every step | digit ratios 1.67–2.0 for m=3→8 (all four roots) | confirmed |
| C1-5 | Case 1 Behavior | \|r_k/r_{k+1}\|^{2^m} → ∞ doubly exponentially | follows from distinct magnitudes. Coefficient ratios confirm | confirmed |
| C1-6 | Case 1 Behavior | The first steps are irregular | r₁: 2.0 → 5.48 → 4.34. r₄: 1.71 → 0.838 → 0.981 | confirmed |
| C1-7 | Case 1 Behavior | r₂ estimate is 3.017 at m = 1 | 3.01662062580 (script and independent) | confirmed |
| C1-8 | Case 1 Behavior | r₂ moves away to 2.941 at m = 2 before converging | 2.94091708134 (error grows 0.0166 → 0.0591, then shrinks) | confirmed |
| C1-9 | Case 1 Behavior | \|r_1\|/\|r_2\| = 4/3; a few squarings separate them | 4/3 is exact. r₁ error 0.0025 by m=4 | confirmed |
| C1-10 | Case 1 link/embed | `graeffesaa.jl` / `graeffesaa.gif` is this case | script polynomial and title match. The GIF is byte-identical to a regenerated scratch run (manifest) | confirmed |
| C1-11 | Case 1 alt text | Roots −3, −1, 2, 4. Each trace moves from a poor initial approximation onto its dashed line | m=0 estimates 2.0, 6.5, 1.077, 1.714 (all far off). The last frame shows all on their lines | confirmed |
| C1-12 | Frames, Case 1 | Title "f(x) = (x+1)(x−2)(x+3)(x−4), m = k". Legend r₁(\|r₁\|=4) … r₄(\|r₄\|=1) | frames 001–009 show m=0…8, and the plotted points match instr.out | confirmed |
| C2-1 | Case 2 heading | f(x) = (x−1)(x+2)(x−5)² | sympy expansion = x⁴−9x³+13x²+45x−50 = script `c0`. Title matches | confirmed |
| C2-2 | Case 2 heading | true \|r_k\| ∈ {1,2,5,5} | sympy roots {1, −2, 5 (mult. 2)} | confirmed |
| C2-3 | Case 2 Behavior | Both double-root estimates converge linearly; the error is halved each iteration | errors (r₁ / r₂) m=3…10: 0.453/−0.414, 0.221/−0.212, 0.109/−0.107, 0.0544/−0.0539, 0.0271/−0.0270, 0.0136/−0.0135, 0.00677/−0.00676, 0.00339/−0.00338. Ratios 0.47–0.55 from m=3, tending to 0.500 (0.4998/0.5002 at m=10). The early ratios (m=1→2: 0.40 and 0.75) are irregular, so the statement holds asymptotically. Theory: estimates ≈ 5·2^{±1/2^m}, so the error ≈ 5 ln2/2^m | confirmed |
| C2-4 | Case 2 Behavior | The separated-root condition is never satisfied for equal magnitudes | (5/5)^{2^m} = 1 for every m | confirmed |
| C2-5 | Case 2 Behavior | Simple roots \|r\|=1, 2 converge quadratically | r₃ error 6.5e−4, 1.8e−6, 1.45e−11, 1.7e−21, 4.6e−41 (m=3…7). r₄ similar | confirmed |
| C2-6 | Case 2 Behavior | A real pair ±r behaves the same way because one squaring turns it into a double root | Mathews Ex. 9, (x−5)(x+5)(x+1)(x−2): from m=1 on its estimates are identical to Case 2's (both p_1 have roots 25, 25, 4, 1). Errors 0.2214/−0.212 at m=4 etc. (indep2.out) | confirmed |
| C2-7 | Case 2 Behavior | For roots 3±4i, 2, 1 the top two estimates cross back and forth over 5 | polynomial x⁴−9x³+45x²−87x+50. The sign of (estimate₁ − 5) at m=2…10 is +, −, +, −, +, +, −, +, + (indep.out), so they cross repeatedly | confirmed |
| C2-8 | Case 2 Behavior | The complex pair's error does not halve each step | max error at m=2…10: 0.675, 0.107, 0.0797, 0.171, 0.0497, 0.0171, 0.0183, 0.00599, 0.00167 | confirmed |
| C2-9 | Case 2 Behavior | The complex pair's error grows from m = 4 to m = 5 and from m = 7 to m = 8 | 0.0797 → 0.171 and 0.0171 → 0.0183 | confirmed |
| C2-10 | Case 2 Behavior | Magnitudes 5, 5, 2, 1 "as here" | \|3±4i\| = 5 | confirmed |
| C2-11 | Case 2 link/embed | `graeffesab.jl` / `graeffesab.gif` is this case | polynomial and title match. The GIF is byte-identical to the regenerated run | confirmed |
| C2-12 | Case 2 alt text | Double root at x=5, simple roots at x=1 and x=−2. Two blue traces approach 5 slowly, crimson and orange traces converge rapidly | colours `[:steelblue, :steelblue, :crimson, :darkorange]`. Frames show this | confirmed |
| C2-13 | Frames, Case 2 | Legend r₁ and r₂ (\|r\| = 5, double), r₃ (2), r₄ (1). Last-frame annotation "r₁, r₂: linear convergence (double root) / r₃, r₄: quadratic convergence" | frame_011, consistent with C2-3 and C2-5. The plotted points match instr.out (m=0: 9, 1.444, 3.462, 1.111) | confirmed |
| W1 | Page | Two cases, each with one source link and one GIF | 2 scripts, 2 GIFs, manifest wiring OK | confirmed |

### 3. Implementation checks

### `graeffesaa.jl` (Case 1)
- **Method.** This is Graeffe root squaring. `graeffe_step` gives q(t) = E(t)² − t·O(t)² with E = c₄t²+c₂t+c₀ and O = c₃t+c₁. That equals (−1)^4 p(√t)p(−√t), and I expanded it by hand to get the d₄…d₀ the code uses. The magnitude estimates are the separated-root ratios \|c_{n−k}/c_{n−k+1}\|^{1/2^m}. The page's Description states the same variant. No sign determination is done, and the page does not claim the animation shows one.
- **Numbers.** Script and independent values agree to all 12 printed decimals:

  | m | script (instr.out) | independent (indep.out) |
  |---|---|---|
  | 0 | 2.000000000000 6.500000000000 1.076923076923 1.714285714286 | 2.0 6.5 1.07692307692 1.71428571429 |
  | 1 | 5.477225575052 3.016620625800 1.733107903064 0.838116354923 | 5.47722557505 3.0166206258 1.73310790306 0.838116354923 |
  | 2 | 4.337613136533 2.940917081341 1.917379336611 0.981227256835 | 4.33761313653 2.94091708134 1.91737933661 0.981227256835 |
  | 3 | 4.049792933038 2.978782575513 1.990491511456 0.999491923038 | 4.04979293304 2.97878257551 1.99049151146 0.999491923038 |
  | 4 | 4.002497732041 2.998415805279 1.999809851805 0.999999044867 | 4.00249773204 2.99841580528 1.99980985181 0.999999044867 |
  | 6 | 4.000000000631 2.999999999527 2.0 1.0 | 4.00000000063 2.99999999953 2.0 1.0 |
  | 8 | 4.0 3.0 2.0 1.0 | errors 1.6e−34, −1.2e−34, −6.5e−48, −3.4e−80 |

  p_1 = [1, −30, 273, −820, 576] is the same in the script, in my computation and in Mathews' gr_160. The BigInt ratio is promoted to 256-bit BigFloat before the 1/2^m root, so the plotted Float64 values are accurate.
- **Reference values.** The true magnitudes {4,3,2,1} are the sympy roots of the stated polynomial.
- **Picture.** Frames 001 (m=0), 002–005 and 009 (m=8) checked. The plotted points match the printed estimates (for example the m=1 peak at 5.48 and the m=0 value 6.5 for r₂). The ylims (0, 7) contain every value (max 6.5). There is no clamping or masking. Title, function and m index are correct. 9 frames for m = 0…8.

### `graeffesab.jl` (Case 2)
- **Method.** The same Graeffe step (identical code) and the same estimator.
- **Numbers.** Script and independent values agree to 12 decimals at every m = 0…10. For example m=10 gives 5.003385653465 / 4.996616637513 in the script and 5.00338565347 / 4.99661663751 independently, and m=1 gives 7.416198487096 3.997726626699 1.944918410191 0.867109969524 in both. p_1 = [1, −55, 879, −3325, 2500], and its roots are {25, 25, 4, 1} (sympy). The header comment "(5·5·2)^256 ≈ 8.6e434" and "Inf/NaN from m = 8 on" are confirmed by indep.out (8.64e434) and indep2.out (Float64 overflow at m=8).
- **Reference values.** {5,5,2,1} are the sympy roots (5 has multiplicity 2).
- **Picture.** Frames 001, 004, 006, 008 and 011 checked. The points match the printed estimates. ylims (0, 9.5) contain the largest value (9.0 at m=0). There is no clamping. The legend distinguishes r₁ (circle) from r₂ (diamond), both blue as the alt text says. The last-frame annotation is consistent with the computed rates. 11 frames for m = 0…10.

### Legacy fidelity
- Mathews' archive has no Graeffe animations: there are none under `a2001/Animations/`, which has only a `RootFinding` folder with no Graeffe files. The page's two cases are Mathews' own worked examples:
  - Case 1 = Examples 3/4, f₀ = 24+14x−13x²−2x³+x⁴ (gr_128, gr_156). Mathews' magnitudes {4.000000000630668, 2.999999999527251, 1.999999999999832, 1.} after 6 squarings match my m=6 values.
  - Case 2 = Example 6, f₀ = −50+45x+13x²−9x³+x⁴ (gr_263). Mathews says it converges "linearly for the repeated root and quadratically for the simple roots", which the page reproduces.
- Mathews' Example 9 (the ±5 real pair) is covered in the page's prose and confirmed (C2-6).
- Mathews' Examples 5 and 8 (degree 6 and 7) and Example 7 are not animated. Example 7's polynomial image gr_434 is missing from the archive, so I could not determine it. The legacy page has no animations, so choosing two representative examples does not silently drop an animated case. No Fidelity finding.

