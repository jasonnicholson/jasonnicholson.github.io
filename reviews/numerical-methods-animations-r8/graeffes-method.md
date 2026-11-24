# Graeffe's Method — animation review (round 8)

Page: `pages/numerical-methods/graeffes-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every claim in the ledger below was checked against my own computations and came out confirmed. Both scripts implement the Graeffe root-squaring method correctly, and their values match an independent exact computation to all printed digits.

Things I looked at and decided were not findings:
- In Case 2 the x-axis ticks are 0, 2.5, 5.0, 7.5, 10.0, which are non-integer labels for an integer iteration index. This is cosmetic and does not mislead.
- Fidelity: Mathews' module has nine worked examples. Case 1 is his Examples 2/3/4, f0 = 24+14x-13x^2-2x^3+x^4. Case 2 is his Example 6, f0 = -50+45x+13x^2-9x^3+x^4. Both were read from formula images gr_128, gr_156, gr_263 and gr_48. The page does not animate Examples 5 (degree 6), 7 (a second repeated-root polynomial; its statement image gr_434 is missing from the archive), 8 (degree 7) and 9 (unequal real roots of equal magnitude; image gr_534 is missing). The archive contains no animations for this topic (`find a2001/Animations -iname '*graef*'` found nothing), so there is no animated archive case being dropped. The Example 9 situation (±r) is covered correctly in the Case 2 text. I judged this not to be a reader-relevant departure.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `graeffesaa.jl` | 0 | 7.9 | graeffesaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `graeffesab.jl` | 0 | 7.3 | graeffesab.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

Evidence scripts:
- `review/indep.py` is an independent Graeffe step built from the product p(x)p(-x) with exact Python integers. It computes estimates with mpmath at 60 digits and also checks the complex case.
- `review/graeffesa{a,b}_instr.jl` are copies of the scripts that print the estimates and the log10 of the maximum coefficient.
- `review/ovf.py` runs the Float64 overflow test.
- `review/pm.py` runs the ±r case.

| # | Claim (page wording) | Verdict | Evidence |
|---|---|---|---|
| D1 | p1(x) = (-1)^n p(√x) p(-√x) has roots r_k^2 | confirmed | Algebra: (√x-r)(-√x-r) = -(x-r^2), so the product is a_n^2 (-1)^n ∏(x-r^2). The independent p(x)p(-x) construction also gives zero odd coefficients and equals the script's d4..d0 for 10 steps on all three test polynomials (assert passed, "step formula ok"). |
| D2 | m applications give roots r^(2^m) | confirmed | Follows from D1 |
| D3 | \|r_k\|^(2^m) ≈ \|c_{n-k}/c_{n-k+1}\|, \|r_k\| ≈ that ratio^(1/2^m) | confirmed | Vieta. The script uses c[k+1]/c[k] in highest-first order, which is the same thing. |
| D4 | Sign is chosen by testing p(±\|r_k\|) | confirmed (statement only; the animation shows magnitudes) | none needed |
| D5 | For real roots of distinct magnitude the error decreases quadratically and digits roughly double | confirmed | Case 1 \|r1\| errors 0.0498, 2.5e-3, 1.26e-5, 6.3e-10, 3.2e-18, 1.6e-34 (m=3..8), which is 1.3, 2.6, 4.9, 9.2, 17.5, 33.8 digits |
| D6 | For separated roots \|c_{n-k}/c_n\| ≈ (\|r1\|…\|rk\|)^(2^m), growing doubly exponentially | confirmed | log10 max coefficient (Case 1): 1.38, 2.91, 5.55, 11.04, 22.08, 44.17, 88.33, 176.67, 353.33, which doubles each step |
| A1 | Animations show the SRT estimates for m = 0,1,2,…; dashed lines are the true magnitudes; coloured traces are the estimates | confirmed | Plot code (hline! dashed at true_mags; plot! traces of `estimates`) and frames |
| A2 | Scripts use exact integer arithmetic for the squaring | confirmed | `big.([...])` and BigInt arithmetic in graeffe_step. The ratios are BigFloat (256-bit). |
| A3 | In double precision the coefficients overflow at m = 8 | confirmed | `ovf.py`: Float64 is finite at m=7 (max 4.6e176 and 2.9e217) and Inf/NaN at m=8 in both cases |
| A4 | Largest coefficient of p8 ≈ 2.2e353 (Case 1) | confirmed | log10 = 353.334, giving 2.158e353 (this is c1, which is about 24^256) |
| A5 | Largest coefficient of p8 ≈ 8.6e434 (Case 2) | confirmed | log10 = 434.936, giving 8.636e434 |
| C1a | Case 1: f(x) = (x+1)(x-2)(x+3)(x-4) | confirmed | The expansion x^4-2x^3-13x^2+14x+24 equals script `c0`. numpy roots: 4, -3, 2, -1. |
| C1b | true \|r_k\| ∈ {1,2,3,4} | confirmed | same as C1a |
| C1c | All four estimates converge quadratically, digits roughly doubling from m=3 on | confirmed | Errors m=3..8: r1 as in D5. r2 0.0212, 1.58e-3, 9.2e-6, 4.7e-10, 2.4e-18, 1.2e-34. r3 9.5e-3, 1.9e-4, 1.45e-7, 1.7e-13, 4.5e-25. r4 5.1e-4, 9.6e-7, 7.3e-12, 8.5e-22, 2.3e-41. |
| C1d | r2 estimate accidentally close at m=1 (3.017) and moves away to 2.941 at m=2 before converging | confirmed | script 3.0166206258 then 2.9409170813, then 2.9788 at m=3; independent values agree |
| C1e | Roots initially close, \|r1\|/\|r2\| = 4/3 | confirmed | 4/3 |
| C1f | Link `graeffesaa.jl` and embed `graeffesaa.gif` are Case 1 | confirmed | The script header, title and coefficients match Case 1. The GIF is byte-identical to the regeneration. |
| C1g | Alt text: degree 4, roots −3, −1, 2, 4; each trace moves from an initial poor approximation onto its dashed line | confirmed | Frames 1 and 9: m=0 estimates are 2.0, 6.5, 1.08, 1.71, and they finish on 4, 3, 2, 1 |
| C2a | Case 2: f(x) = (x-1)(x+2)(x-5)^2 | confirmed | The expansion x^4-9x^3+13x^2+45x-50 equals script `c0` |
| C2b | true \|r_k\| ∈ {1,2,5,5} | confirmed | same as C2a |
| C2c | The double-root estimates converge linearly; from m=2 on the error is roughly halved each iteration | confirmed | r1 errors m=2..10: 0.966, 0.453, 0.221, 0.109, 0.0544, 0.0271, 0.0136, 0.00677, 0.00339. r2: 0.754, 0.414, 0.212, 0.107, 0.0539, 0.0270, 0.0135, 0.00676, 0.00338. Analytically the estimates are 5·2^(±1/2^m) for large m, for example 5·2^(1/1024) = 5.003386 against the script's 5.003385653. |
| C2d | The two simple roots converge quadratically | confirmed | r3 errors 0.0551, 5.3e-3, 6.5e-4, 1.8e-6, 1.45e-11, 1.7e-21, 4.6e-41 |
| C2e | A real pair ±r behaves the same because one squaring turns it into a double root | confirmed | `pm.py` with roots 5, −5, 2, 1: from m=1 on the estimates are identical to Case 2 (7.4162, 3.9977, 1.9449, 0.8671; …) |
| C2f | For roots 3±4i, 2, 1 the top two estimates cross back and forth over 5 and the error does not halve each step | confirmed | `indep.py` on x^4-9x^3+45x^2-87x+50 gives top pair (m=2..8): (5.675, 4.354), (4.896, 5.107), (5.080, 4.922), (4.835, 5.171), (5.050, 4.951), (5.017, 4.983), (4.982, 5.018) |
| C2g | The error grows from m=4 to m=5 and from m=7 to m=8 | confirmed | r1 error 0.0797 to 0.165, and 0.0171 to 0.0183 |
| C2h | Link `graeffesab.jl` and embed `graeffesab.gif` are Case 2 | confirmed | header, title and coefficients; byte-identical GIF |
| C2i | Alt text: double root at 5, simple roots at 1 and −2; two blue traces approach 5 slowly, crimson and orange simple-root traces converge rapidly | confirmed | colors = steelblue ×2, crimson (r3, \|r\|=2), darkorange (r4, \|r\|=1); frames 1–11 |

### 3. Implementation checks

### graeffesaa.jl (Case 1)
- **Method:** this is the standard Graeffe (Dandelin–Lobachevsky) root squaring, written as q(t) = E(t)^2 − t·O(t)^2 for degree 4 with no sign factor, since (−1)^4 = 1. The step formula matches an independent p(x)p(−x) construction exactly for 10 steps. The estimates come from the separated-root ratios |c_{n−k}/c_{n−k+1}|^(1/2^m).
- **Numbers:** the script and an independent mpmath computation at 60 digits agree to every printed digit:

  | m | script | independent |
  |---|---|---|
  | 0 | 2.0, 6.5, 1.076923, 1.714286 | 2.0, 6.5, 1.07692307692, 1.71428571429 |
  | 1 | 5.477226, 3.016621, 1.733108, 0.838116 | 5.47722557505, 3.0166206258, 1.73310790306, 0.838116354923 |
  | 2 | 4.337613, 2.940917, 1.917379, 0.981227 | 4.33761313653, 2.94091708134, 1.91737933661, 0.981227256835 |
  | 3 | 4.049793, 2.978783, 1.990492, 0.999492 | 4.04979293304, 2.97878257551, 1.99049151146, 0.999491923038 |
  | 4 | 4.002498, 2.998416, 1.999810, 0.9999990 | 4.00249773204, 2.99841580528, 1.99980985181, 0.999999044867 |
  | 8 | 4.0, 3.0, 2.0, 1.0 | errors ≤ 1.6e-34 |

- **Reference values:** the true magnitudes 4, 3, 2, 1 come from the factored form and were confirmed with `np.roots` on the coefficients.
- **Picture:** there are 9 frames (m=0..8). Every trace is the estimate sequence up to the current m, and the dashed lines are at the true magnitudes. Legend labels map estimate k to the k-th largest magnitude, which is correct. With ylims (0, 7) all values are visible (the maximum is 6.5 at m=0). There is no clamping or masking. The title function matches the code.

### graeffesab.jl (Case 2)
- **Method:** same step and estimator as Case 1, verified the same way.
- **Numbers:** the script and the independent computation agree:

  | m | script | independent |
  |---|---|---|
  | 0 | 9.0, 1.444444, 3.461538, 1.111111 | 9.0, 1.44444444444, 3.46153846154, 1.11111111111 |
  | 1 | 7.416198, 3.997727, 1.944918, 0.867110 | 7.4161984871, 3.9977266267, 1.94491841019, 0.867109969524 |
  | 2 | 5.966150, 4.246210, 2.005318, 0.984218 | 5.9661498021, 4.24620954185, 2.00531762152, 0.984217898321 |
  | 5 | 5.109486, 4.892860, 2.0000000, 1.0000000 | 5.10948574327, 4.89286031044, 2.00000000001, 0.999999999993 |
  | 10 | 5.003386, 4.996617, 2.0, 1.0 | 5.00338565347, 4.99661663751, 2.0, 1.0 |

- **Reference values:** the true magnitudes 5, 5, 2, 1 come from the factored form. `np.roots` gives 5±1.2e-7i, which is ordinary perturbation of a double root in floating point, plus −2 and 1.
- **Picture:** there are 11 frames (m=0..10). The two double-root traces are both steelblue, told apart by circle and diamond markers, with a duplicate dashed line at 5 that is harmless. With ylims (0, 9.5) all values are visible (the maximum is 9.0 at m=0). The last-frame annotation, "r₁, r₂: linear … r₃, r₄: quadratic", matches the computed rates (C2c, C2d) and does not cover any trace. The title function matches the code.

### Could not determine
Nothing material. The legacy statements of Examples 7 and 9 could not be read because their formula images are missing from the archive. This affects only the fidelity note above.

