# Improved Newton Method — animation review (round 2)

Page: `pages/numerical-methods/improved-newton-method/`. Reported findings: **0 Error, 0 Misleading, 2 Minor**.

## Findings

### F1 (Implementation, Minor): wrong number in a script comment about cancellation
- **Where:** `newtonimpbb.jl` lines 12–13:
  `# Factored forms: the expanded x^3 - 3x + 2 loses all accuracy to cancellation near the double root (Float64 gives f(1 + 1.3e-10) = 2.2e-16 instead of 5.1e-20).`
- **What is there now:** the comment says the expanded form gives 2.2e-16 in Float64.
- **What is true:** in Float64 the expanded form gives exactly `0.0` at 1 + 1.3e-10. It also gives `0.0` at the actual x₃ = 1.000000000132272 and at the next float. The factored value 5.07e-20 is right, and so is the conclusion that all accuracy is lost.
- **How I know:** `julia -e 'g(x)=x^3-3x+2; println(g(1.000000000132272)); println(g(1+1.3e-10)); println(g(nextfloat(1.0+1.3e-10)))'` printed `0.0 0.0 0.0`. `inst_bb.jl` printed `expanded f(1+1.3e-10)=0.0 factored=5.0700008392070965e-20`. By contrast, the matching comment in `newtonimpdd.jl` (−8.9e-16 vs +7.9e-19) reproduces exactly: −8.881784197001252e-16 and 7.864321681674212e-19.
- **Fix:** change it to "(Float64 gives f(1 + 1.3e-10) = 0.0 instead of 5.1e-20)".

- **Independent check:** not run (Minor finding, unverified)

### F2 (Fidelity, Minor): Mathews' Example 3 and the B/C comparisons are not carried over
- **Where:** the whole Animations section, together with "The animations show standard Newton and Method A; Case 5 also discusses Methods B and C."
- **What is there now:** Cases 1–2 are Mathews Example 1 (x³−3x+2, p₀=1.3, m=2) and Cases 3–4 are Example 2 (x⁴−x³−3x²+5x−2, p₀=1.3, m=3). Both are faithful.
  - Mathews' **Example 3** is dropped without mention. It is the quadruple root of x⁵−2x⁴−2x³+8x²−7x+2 = (x−1)⁴(x+2), p₀ = 1.3 (images gr_191–193; I verified the factorisation by expansion).
  - Every Mathews example compares Methods A, B **and C**, and C (adaptive Newton) is the subject of the module. No script computes Method B or Method C.
  - Case 5 (arctan) is not from this module.
- **Why only Minor:** the page openly says the animations show only standard Newton and Method A. The B and C numbers it does quote in Case 5 are correct (see the ledger).
- **Fix:** either add an Example-3 pair (standard Newton vs Method A with m=4, and optionally Method C, which needs no m), or add one sentence saying the quadruple-root example and the B/C iterations are not animated.

No Error or Misleading findings.

---

- **Independent check:** not run (Minor finding, unverified)


## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonimpaa.jl` | 0 | 5.9 | newtonimpaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpbb.jl` | 0 | 5.8 | newtonimpbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpcc.jl` | 0 | 5.8 | newtonimpcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpdd.jl` | 0 | 5.3 | newtonimpdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpee.jl` | 0 | 5.5 | newtonimpee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `newtonimpaa.gif` | 11 | byte-identical | newtonimpaa |
| `newtonimpbb.gif` | 4 | byte-identical | newtonimpbb |
| `newtonimpcc.gif` | 13 | byte-identical | newtonimpcc |
| `newtonimpdd.gif` | 4 | byte-identical | newtonimpdd |
| `newtonimpee.gif` | 7 | byte-identical | newtonimpee |

### Page references

- Scripts linked: `newtonimpaa.jl`, `newtonimpbb.jl`, `newtonimpcc.jl`, `newtonimpdd.jl`, `newtonimpee.jl`
- GIFs embedded: 5
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | Description | Newton converges "quadratically if the root is simple but only linearly if the root has multiplicity m ≥ 2" | Case 1 ratio e_{n+1}/e_n → 0.5001, Case 3 → 0.6668; Mathews Thm 1 | confirmed |
| D2 | Description | Method A: x_{n+1} = x_n − m f/f′ | Matches line 31 in bb/dd and Mathews (8) | confirmed |
| D3 | Description | Method B formula = Newton on u = f/f′ | sympy: u/u′ − f f′/(f′² − f f″) = 0 | confirmed |
| D4 | Description | Method C: start at m=1, increase m while \|f(x_{n,m+1})\| < \|f(x_{n,m})\|, take the last such point | Matches Mathews' algorithm (image gr_115: "While \|y₂\|<\|y₁\| …") and his Example 2 trail (gr_179: m=1..4, stops when f changes sign and grows) | confirmed |
| D5 | Description | "Started close enough to a multiple root, Methods A and B converge … quadratically" | A: e/e² → 1/6 (Case 2), 1/9 (Case 4). B on Ex. 1: 0.98765432, 0.99997439, 0.99999999989 (matches Mathews' table gr_145). B on Ex. 2: 0.99176, 0.9999924, 0.9999999999936 | confirmed |
| D6 | Description | "The animations show standard Newton and Method A; Case 5 also discusses Methods B and C" | Scripts aa/cc/ee use plain Newton; bb/dd use Method A | confirmed |
| I1 | Intro | Cases 1–4 have a multiple root at x=1; Case 5 arctan has a simple root at 0 | sympy factorisations; arctan′(0)=1 | confirmed |
| I2 | Intro | Standard Newton cases: each drawn line is the tangent at x_n | The segment (x_n,f(x_n))→(x_{n+1},0) has slope f/(x_n−x_{n+1}) = f′(x_n) | confirmed |
| I3 | Intro | Method A cases: the line has slope f′(x_n)/m | Same segment has slope f/(m f/f′) = f′/m | confirmed |
| I4 | Intro | The line from (x_n,f(x_n)) to the next x-intercept traces the path | Plot code lines 47/53/46/51/47; frames | confirmed |
| I5 | Intro | Method A restores quadratic convergence by multiplying the step by m | See D5 | confirmed |
| C1a | Case 1 heading | Standard Newton, f = x³−3x+2, x₀ = 1.3, linear convergence, double root | Script lines 11, 15, 27; frame titles | confirmed |
| C1b | Case 1 | f = (x−1)²(x+2), double root at x*=1 | sympy expand | confirmed |
| C1c | Case 1 | f′(x*) = 0 at a multiple root | f′ = 3(x−1)(x+1), so f′(1)=0 | confirmed |
| C1d | Case 1 | "Each step only halves the error rather than squaring it" | Ratios 0.5217, 0.5121, 0.5064, … 0.50005 | confirmed |
| C1e | Case 1 | "creeps slowly toward x=1 over many steps" | 10 steps, final error 3.21e-4; x₁₀ = 1.000321 (frame 11 label) | confirmed |
| C1f | Case 1 alt | "slow linear convergence from x₀=1.3 toward the double root at x=1" | as above | confirmed |
| C2a | Case 2 heading | Method A, m=2, same f, x₀=1.3, quadratic | Script lines 14, 18, 20, 31 | confirmed |
| C2b | Case 2 | Formula with m=2 | Line 31 | confirmed |
| C2c | Case 2 | "restoring quadratic convergence"; "rapid … completely different speed" vs Case 1 | Iterates 1.3, 1.0130435, 1.0000282, 1.000000000132 (errors 1.3e-2, 2.8e-5, 1.3e-10; e/e² → 0.1667) | confirmed |
| C2d | Case 2 alt | "quadratic convergence … in just a few steps" | 3 steps to 1.3e-10 | confirmed |
| C3a | Case 3 heading | Standard Newton, f = x⁴−x³−3x²+5x−2, x₀=1.3, triple root, "even slower" | Script lines 11, 15; ratio 0.667 > 0.5 | confirmed |
| C3b | Case 3 | f = (x−1)³(x+2) | sympy expand | confirmed |
| C3c | Case 3 | Asymptotic error constant (m−1)/m | Case 1 → 0.50005 (m=2); Case 3 → 0.66680 (m=3) | confirmed |
| C3d | Case 3 | "2/3 … each iterate only reduces the error by 1/3" | ratio sequence 0.6765 … 0.6668 | confirmed |
| C3e | Case 3 alt | "very slow linear convergence from x₀=1.3" | 12 steps, final error 2.42e-3 | confirmed |
| C4a | Case 4 heading | Method A, m=3, quartic, x₀=1.3, quadratic | Script lines 14–20, 31 | confirmed |
| C4b | Case 4 | Iterates 1.3, 1.008824, 1.000009 | mpmath 1.0088235294, 1.0000086167; frame labels 1.008824, 1.000009 | confirmed |
| C4c | Case 4 | x₃ within 10⁻¹¹ of the root, "labelled 1.0" | x₃ − 1 = 8.2497e-12; frame 4 label "x₍3₎ = 1.0" | confirmed |
| C4d | Case 4 | "knowing m unlocks quadratic convergence regardless of root order" | e/e² → 0.1111 (m=3), 0.1667 (m=2) | confirmed |
| C5a | Case 5 heading | Standard Newton diverges, f = arctan x, x₀ = 1.4 | Script lines 11, 15; iterates grow | confirmed |
| C5b | Case 5 | Simple root at x*=0 | f′(0)=1 | confirmed |
| C5c | Case 5 | Converges only when \|x₀\| < x_c ≈ 1.3917 | x_c from 2x = (1+x²)atan x: 1.39174520027 | confirmed |
| C5d | Case 5 | "each tangent line overshoots further than the previous iterate", iterates escape toward ±∞ | \|x_n\|: 1.4, 1.4136, 1.4501, 1.5506, 1.8471, 2.8936, 8.7103, 103.25, 16540.6 with alternating signs | confirmed |
| C5e | Case 5 | Method A with m=1 is standard Newton and does not fix it | Identity | confirmed |
| C5f | Case 5 | u = f/f′ = (1+x²) arctan x | f/f′ = atan x · (1+x²) | confirmed |
| C5g | Case 5 | u increasing and convex for x > 0 | u′ = 2x atan x + 1 > 0; u″ = 2(x + (1+x²)atan x)/(1+x²) > 0 for x>0 (sympy) | confirmed |
| C5h | Case 5 | Method B iterates decrease monotonically: 0.6316, 0.1712, 0.00625, 3.25×10⁻⁷ | mpmath: 0.631573205, 0.171165545, 0.00624689128, 3.25004898e-7, 4.6e-20. The page's B formula and Newton-on-u agree to all digits | confirmed |
| C5i | Case 5 | Method C: x_{1,1} ≈ −1.41, x_{1,2} ≈ −4.23 with larger \|f\| | −1.413619 (\|f\| 0.95512), −4.22724 (\|f\| 1.33851) | confirmed |
| C5j | Case 5 | C keeps m=1 at every step and diverges like standard Newton | Steps 1–7 all pick m=1, and the C sequence is identical to Newton's. In general, for x>0 the step s = (1+x²)atan x > x, so x−s < 0 and x−2s < x−s < 0, giving \|atan(x−2s)\| > \|atan(x−s)\| (symmetric for x<0) | confirmed |
| C5k | Case 5 | "the m=1 step always crosses to the other side of 0" | (1+x²)atan x − x is 0 at 0 and has derivative 2x atan x ≥ 0, so s > x for x>0 | confirmed |
| C5l | Case 5 alt | "divergent oscillation from x₀=1.4, just outside the critical convergence radius" | as C5c/C5d | confirmed |
| W1 | Wiring | Case 1 → newtonimpaa.jl/.gif … Case 5 → newtonimpee.jl/.gif, parameters in headings | Script parameters and GIF titles match each heading; the manifest shows all GIFs byte-identical to regenerated output | confirmed |
| N1 | Counts | (implicit) frames: Case 1 shows x₀..x₁₀, Case 3 x₀..x₁₂, Cases 2/4 x₀..x₃, Case 5 x₀..x₆ | 11/13/4/4/7 frames | confirmed (no numeric frame-count claim on the page) |

---

### 3. Implementation checks

All five scripts were instrumented (`inst_*.jl`) to print every iterate and legend label. Each was compared with the 50-digit mpmath recomputation in `indep.py`.

### newtonimpaa.jl (Case 1)
- **Method:** plain Newton, x − f/f′. f′ = 3x²−3 is correct (sympy).
- **Numbers:**

  | k | script | mpmath |
  |---|---|---|
  | 1 | 1.1565217391304348 | 1.1565217391304348 |
  | 5 | 1.0102496959724938 | 1.0102496959724945 |
  | 10 | 1.0003213616712867 | 1.0003213616712 |

  The expanded form loses about 1e-13 to cancellation near the root, which has no visible effect.
- **Reference values:** root x=1 is exact.
- **Picture:** each segment runs from (x_n,f(x_n)) to (x_{n+1},0) and has tangent slope, followed by a vertical drop to the curve. Legend labels equal the iterates rounded to 6 digits (frame 11: x₍10₎ = 1.000321). Clipping the curve above y = 1.3 for x > 1.6 is harmless. After about frame 6 the motion is sub-pixel, but the labels keep changing correctly.

### newtonimpbb.jl (Case 2)
- **Method:** Method A, m=2, using the factored f and f′ = 3(x−1)(x+1). Both are correct.
- **Numbers:**

  | k | script | mpmath |
  |---|---|---|
  | 1 | 1.0130434782608697 | 1.0130434782608696 |
  | 2 | 1.0000281716593107 | 1.0000281716593107 |
  | 3 | 1.000000000132272 | 1.0000000001322719 |

  These match Mathews' Method A column (1.0130434782608700, 1.0000281716593167, 1.0000000001359235) to within his rounding/cancellation. Mathews used the expanded form, so his x₃ differs at 1e-11.
- **Script comments:** "x3 within 1.4e-10" is confirmed (1.32e-10). "4th step lands on 1 exactly, then 0/0" is confirmed (x4=1.0, then NaN). The "2.2e-16" comment is wrong (F1).
- **Picture:** the orange segment has slope f′/2 by construction, and the labels are correct (x₍3₎ = 1.0).

### newtonimpcc.jl (Case 3)
- **Method:** plain Newton. f′ = 4x³−3x²−6x+5 is correct (sympy).
- **Numbers:**

  | k | script | mpmath |
  |---|---|---|
  | 1 | 1.2029411764705882 | 1.2029411764705882 |
  | 6 | 1.0274800683263425 | 1.0274800683263394 |
  | 12 | 1.0024225476442639 | 1.0024225476413147 |

  The k=1 value matches Mathews gr_179 (p₁ = 1.202941176470588).
- **Picture:** tangent segments and labels are correct. The curve leaves the window for x < 0.75, which is harmless.

### newtonimpdd.jl (Case 4)
- **Method:** Method A, m=3, using the factored f and f′ = (x−1)²(4x+5). Both are correct (sympy).
- **Numbers:**

  | k | script | mpmath |
  |---|---|---|
  | 1 | 1.0088235294117647 | 1.0088235294117647 |
  | 2 | 1.0000086167279412 | 1.0000086167279412 |
  | 3 | 1.0000000000082498 | 1.0000000000082497 |

  The k=1 value matches Mathews gr_179 p₃ (the m=3 trial point, 1.008823529411764).
- **Script comments:** "within 1e-11" is confirmed (8.25e-12). "4th step → 1 then 0/0" is confirmed. The cancellation comment is confirmed (−8.88e-16 vs 7.86e-19).
- **Picture:** labels are 1.3, 1.008824, 1.000009, 1.0, as the page says.

### newtonimpee.jl (Case 5)
- **Method:** plain Newton on atan with f′ = 1/(1+x²). Correct.
- **Numbers:** the script and mpmath agree to all printed digits:
  - x₁ = −1.4136186488
  - x₂ = 1.4501293146
  - x₃ = −1.5506259756
  - x₄ = 1.8470540842
  - x₅ = −2.8935623931
  - x₆ = 8.7103258470
- **Reference values:** x_c = 1.39174520027 (mpmath findroot on 2x = (1+x²)atan x).
- **Picture:** segments are drawn only when both ends are inside [−4, 5]. The last step, x₅ → x₆ = 8.71, therefore has no segment. Frame 7's legend reads "x₍6₎ = 8.71 (out of range)", and that is the true value, not a clamped one. Divergence is clear from frames 1–6, so this display device is acceptable and not a finding.
- **Methods B and C:** no script implements them. I computed them independently in `indep.py` (ledger C5h–C5k) and every number on the page is correct.

