# Improved Newton Method — animation review (round 5)

Page: `pages/numerical-methods/improved-newton-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Counts: Error 0, Misleading 0, Minor 0.

Everything I checked passed. Three things I looked at and decided were not findings:

- **Cases 1 and 3 (newtonimpaa.gif, newtonimpcc.gif):** the axes never zoom, so after about frame 5 the new tangent and vertical segments are smaller than a pixel. Frames 6 to 11 of Case 1 look the same except for the legend. The legend gives the iterate to 6 decimals (Case 1 x₁₀ = 1.000321, Case 3 x₁₂ = 1.002423), and those numbers show the slow convergence the page talks about. Case 2 and Case 4 still look clearly different from Cases 1 and 3, so I did not count this as misleading.
- **Case 5, last frame:** x₆ = 8.7103 is outside xlims (−4, 5). The x₅→x₆ step is not drawn, and the legend reads "x₍6₎ = 8.71 (out of range)". It is labelled honestly, it does not clamp the point to the axis edge, and the value is correct.
- **Cases 2 and 4 use factored f, while Mathews used the expanded polynomial.** In Mathews' Example 2, Method A stalls at p₃ = 1.000000641877757 because of rounding in the expanded quartic (gr_174). The script's factored form gives the true iterate x₃ = 1 + 8.25e−12. The page departs from the archive here so that the result is mathematically right, which is correct. It is not a Fidelity finding.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonimpaa.jl` | 0 | 6.6 | newtonimpaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpbb.jl` | 0 | 5.7 | newtonimpbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpcc.jl` | 0 | 7.3 | newtonimpcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpdd.jl` | 0 | 6.1 | newtonimpdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpee.jl` | 0 | 6.4 | newtonimpee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

### Description

| # | Claim (page wording) | Evidence | Verdict |
|---|---|---|---|
| D1 | Newton "converges ... quadratically if the root is simple but only linearly if the root has multiplicity m ≥ 2" | Error ratios computed for Cases 1 and 3 tend to 1/2 and 2/3. Matches Mathews Theorem 1 (6), (7). | confirmed |
| D2 | Method A: x_{n+1} = x_n − m f/f' | Same as Mathews (8)/(9) and the code in bb/dd (line 31) | confirmed |
| D3 | Method B applies Newton to u = f/f' and equals x − f f'/(f'² − f f'') | Algebra u/u' = f f'/(f'² − f f''). Numerically, the page formula and Newton-on-u give the same iterates for arctan (1.4, 0.631573, 0.171166, 0.00624689, 3.25005e−7) | confirmed |
| D4 | Method C: x_{n,m} = x_n − m f/f', start at m = 1, increase m while \|f(x_{n,m+1})\| < \|f(x_{n,m})\|, take the last point | Matches Mathews' algorithm (gr_115: "While \|y₂\| < \|y₁\| Do p₁ = p₂ …") and his worked step (gr_137/138) | confirmed |
| D5 | "Started close enough to a multiple root, Methods A and B converge to it quadratically" | Method A, Case 2: e_{k+1}/e_k² → 0.16666 (= 1/6). Case 4: → 0.11111 (= 1/9). B: Mathews' table gr_145 | confirmed |
| D6 | "The animations show standard Newton and Method A; Case 5 also discusses Methods B and C" | Scripts aa, cc, ee run standard Newton; bb, dd run Method A | confirmed |

### Animations intro

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| I1 | Cases 1–4 have a multiple root at x = 1; Case 5 is arctan with a simple root at 0 | sympy: expand((x−1)²(x+2)) = x³−3x+2, expand((x−1)³(x+2)) = x⁴−x³−3x²+5x−2 | confirmed |
| I2 | Standard-Newton cases (1, 3, 5) draw the tangent at x_n | Line from (x_n, f(x_n)) to (x_{n+1}, 0) has slope f(x_n)/(x_n−x_{n+1}) = f'(x_n) by construction | confirmed |
| I3 | Method A cases (2, 4) draw the line of slope f'(x_n)/m | Case 2: drawn slope 0.297/(1.3−1.013043) = 1.0350, f'(1.3)/2 = 1.0350. Case 4: 0.306 = 0.918/3 | confirmed |
| I4 | Slanted line (x_n, f(x_n)) → (x_{n+1}, 0), then vertical (x_{n+1}, 0) → (x_{n+1}, f(x_{n+1})) | Code lines 47/50 (aa), 53/56 (bb), 46/48 (cc), 51/53 (dd), 47/49 (ee). Frames show this | confirmed |
| I5 | Newton degrades to linear at multiple roots; Method A restores quadratic | See D1 and D5 | confirmed |
| I6 | Cases 1–4 follow Examples 1 and 2 of Mathews' module | Archive Ex. 1: x³−3x+2, p₀ = 1.3 (gr_124/126). Ex. 2: x⁴−x³−3x²+5x−2, p₀ = 1.3 (gr_165/167). Method A m = 2 and m = 3. The script's Case 1 iterates match Mathews' gr_130 digit for digit | confirmed |
| I7 | Example 3 compares the methods at a quadruple root | gr_193: x⁵−2x⁴−2x³+8x²−7x+2 = (x−1)⁴(x+2) (checked by expansion) | confirmed |
| I8 | Example 1 caveat plots rounding noise in the expanded f near the double root | gr_154: Plot[(x−1)²(x+2) − f[x], {x, 0.5, 1.5}] | confirmed |
| I9 | Example 2 caveat runs Method A with m = 2 at the triple root, which converges only linearly | gr_188: NewtonRaphsonAccelerate[1.3, 2, 20]. My ratios: 0.353, 0.341, 0.336, … → 1/3 | confirmed |
| I10 | Julia source linked under each case | Five links, one per case, each to the matching script | confirmed |

### Case 1 (newtonimpaa)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 1a | Heading: standard Newton, f = x³−3x+2, x₀ = 1.3, double root | Script lines 11, 15, 27 | confirmed |
| 1b | f = (x−1)²(x+2), double root at 1 | sympy | confirmed |
| 1c | f'(x*) = 0 at a multiple root | f'(1) = 3·0·2 = 0 | confirmed |
| 1d | "Each step only halves the error rather than squaring it" | Error ratios 0.5217, 0.5121, 0.5064, …, 0.50005 | confirmed |
| 1e | "creeps slowly toward x = 1 over many steps" | After 10 steps the error is still 3.21e−4 | confirmed |
| 1f | Alt: slow linear convergence from x₀ = 1.3 toward the double root | Frames 1–11. Legend values match the computed iterates to 6 decimals | confirmed |
| 1g | Link and embed are Case 1 | newtonimpaa.jl / newtonimpaa.gif. The regenerated GIF is byte-identical to the committed one | confirmed |

### Case 2 (newtonimpbb)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 2a | Heading: Method A, m = 2, quadratic, same f, x₀ = 1.3 | Lines 14–20, 31. The factored f is the same function | confirmed |
| 2b | Formula x − m f/f' with m = 2 | Line 31 | confirmed |
| 2c | Restores quadratic convergence | Errors 0.3, 1.304e−2, 2.817e−5, 1.323e−10. e/e² = 0.145, 0.1656, 0.16666 | confirmed |
| 2d | "same function, same starting point, completely different speed" than Case 1 | x₃ error 1.3e−10 vs Case 1 x₃ error 4.1e−2 | confirmed |
| 2e | Alt: quadratic convergence to the double root "in just a few steps" | 4 frames. Labels 1.3, 1.013043, 1.000028, 1.0 | confirmed |
| 2f | Link and embed | byte-identical regen | confirmed |

### Case 3 (newtonimpcc)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 3a | Heading: standard Newton, f = x⁴−x³−3x²+5x−2, x₀ = 1.3, triple root, even slower | Lines 11–16. Ratios → 0.6668 against 0.5000 for Case 1 | confirmed |
| 3b | f = (x−1)³(x+2) | sympy | confirmed |
| 3c | Asymptotic error constant (m−1)/m | Matches Mathews Theorem 1 (7). Computed ratios match for m = 2 and m = 3 | confirmed |
| 3d | "2/3, meaning each iterate only reduces the error by 1/3" | Ratios 0.6765, 0.6736, …, 0.66680 | confirmed |
| 3e | Alt: very slow linear convergence toward the triple root | 13 frames. x₁₂ = 1.002423 (independent value 1.0024225476) | confirmed |
| 3f | Link and embed | byte-identical regen | confirmed |

### Case 4 (newtonimpdd)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 4a | Heading: Method A, m = 3, quadratic, same f, x₀ = 1.3 | Lines 14–20, 31 | confirmed |
| 4b | Restores quadratic convergence | e/e² = 0.098, 0.1107, 0.11111 | confirmed |
| 4c | Animated iterates are 1.3, 1.008824, 1.000009, then x₃ | Independent: 1.0088235294, 1.0000086167, 1.0000000000082497. Frame labels show the same values | confirmed |
| 4d | x₃ within 10⁻¹¹ of the root, labelled 1.0 | Error 8.25e−12. round(x₃, 6) = 1.0, visible in frame 4 | confirmed |
| 4e | Knowing m gives quadratic convergence regardless of root order | Holds for m = 2 and m = 3 here. It is the standard result, and Mathews says the same | confirmed |
| 4f | Alt and link/embed | 4 frames, byte-identical regen | confirmed |

### Case 5 (newtonimpee)

| # | Claim | Evidence | Verdict |
|---|---|---|---|
| 5a | Heading: standard Newton diverges, f = arctan x, x₀ = 1.4 | Lines 11–16, 27 | confirmed |
| 5b | Simple root at x* = 0 | f'(0) = 1 ≠ 0 | confirmed |
| 5c | Converges only for \|x₀\| < x_c ≈ 1.3917 | x_c is the root of 2x = (1+x²)·atan x: 1.39174520027. Newton map is odd and \|N(x)\| > \|x\| iff \|x\| > x_c | confirmed |
| 5d | x₀ = 1.4 is just outside the radius | 1.4 > 1.39175 | confirmed |
| 5e | Each tangent overshoots further, and the iterates escape toward ±∞ with alternating sign | Independent: 1.4, −1.41362, 1.45013, −1.55063, 1.84705, −2.89356, 8.71033. Script matches to ≤4e−14 | confirmed |
| 5f | Method A with m = 1 is standard Newton and does not fix it | Identical formula | confirmed |
| 5g | u = f/f' = (1+x²)·atan x | f/f' = atan x · (1+x²) | confirmed |
| 5h | u is increasing and convex for x > 0 | u' = 2x·atan x + 1 > 0. u'' = 2·atan x + 2x/(1+x²) > 0 for x > 0. Sampled u'' = 0.040, 1.73, 2.57, 2.85, 3.10 at x = 0.01, 0.5, 1, 1.4, 3 | confirmed |
| 5i | Method B iterates decrease monotonically: 0.6316, 0.1712, 0.00625, 3.25×10⁻⁷ | Independent: 0.631573, 0.171166, 0.00624689, 3.25005e−7, 4.6e−20 | confirmed |
| 5j | Method C: x_{1,1} ≈ −1.41, x_{1,2} ≈ −4.23 with larger \|f\| | −1.41362 (\|f\| 0.95512), −4.22724 (\|f\| 1.33851) | confirmed |
| 5k | C keeps m = 1 at every step and diverges exactly like standard Newton | My Method C over 6 steps: m = [1, 1, 1, 1, 1, 1], same iterates as Newton | confirmed |
| 5l | Alt: "divergent oscillation from x₀ = 1.4, just outside the critical convergence radius" | 7 frames show iterates alternating sides with growing magnitude. Last frame labels x₆ = 8.71 as out of range | confirmed |
| 5m | Link and embed | byte-identical regen | confirmed |

Not checked (excluded by the brief): the "Source inspiration" citation, and the Planned/placeholder sections. The bib key `mathewsSite` exists in references.bib, and the section index links the page.

### 3. Implementation checks

Every regenerated GIF is byte-identical to the committed GIF, and every regen script is identical to the repository script (cmp/diff). So the committed frames are the output of the code reviewed below.

### newtonimpaa.jl (standard Newton, double root)
- **Method:** plain Newton, x − f/f'. f' = 3x²−3 is the correct derivative (sympy: 3(x−1)(x+1)).
- **Numbers:** script against independent 60-digit computation, for x₁…x₁₀:
  1.1565217391304348 / 1.1565217391304348; 1.0801542776998598 / …597; 1.0405919010082358 / …356; 1.0204305276682764 / …769; 1.0102496959724938 / …945; 1.0051335580375170 / …192; 1.002568969514414 / …4184; 1.001285034018734 / …7216; 1.0006426545304097 / …3703; 1.0003213616712867 / …2000.
  The expanded f causes differences of at most 4e−14, which do not show at the 6-decimal labels. Mathews' table gr_130 agrees to all printed digits.
- **References:** the root x = 1 is exact.
- **Picture:** the tangent from (x_n, f(x_n)) to (x_{n+1}, 0) and the vertical line back to the curve are correct. The legend index equals the frame number, and each value is round(x_frame, 6). The title function matches the code. 11 frames, one for each of x₀…x₁₀.

### newtonimpbb.jl (Method A, m = 2)
- **Method:** Method A with m = 2, using the factored f and f' = 3(x−1)(x+1). Both verified by sympy.
- **Numbers:** script x₁…x₃ = 1.0130434782608697, 1.0000281716593107, 1.000000000132272. Independent: 1.0130434782608696, 1.0000281716593107, 1.0000000001322719. Mathews (expanded f) gives 1.0000000001359 for x₃, which carries rounding error. The script's value is the accurate one.
- **Script comments verified:** expanded f(1+1.3e−10) = 0.0 against factored 5.07e−20. A 4th step gives x₄ = 1.0 exactly, then NaN.
- **Picture:** the drawn line has slope f'(x_n)/2 (1.0350 = 2.07/2). Labels 1.3, 1.013043, 1.000028, 1.0. 4 frames.

### newtonimpcc.jl (standard Newton, triple root)
- **Method:** plain Newton. f' = 4x³−3x²−6x+5 = (x−1)²(4x+5) (sympy).
- **Numbers:** script x₁, x₂, x₁₂ = 1.2029411764705882, 1.136693292424884, 1.0024225476442639. Independent: 1.2029411764705882, 1.1366932924248836, 1.0024225476413147, so rounding drift is about 3e−12. All 13 six-decimal labels agree with the independent values: 1.3, 1.202941, 1.136693, 1.091781, 1.061487, 1.041128, 1.02748, 1.018348, 1.012244, 1.008168, 1.005448, 1.003633, 1.002423. Mathews gr_185 is Method C, not this table. Mathews' own Newton table for Example 2 was not inspected.
- **Picture:** correct construction, 13 frames. Steps after about frame 6 are sub-pixel. The labels carry the information (see Findings, notes).

### newtonimpdd.jl (Method A, m = 3)
- **Method:** Method A with m = 3, using factored f and f' = (x−1)²(4x+5).
- **Numbers:** script 1.0088235294117647, 1.0000086167279412, 1.0000000000082498. Independent: 1.0088235294117647, 1.0000086167279412, 1.0000000000082497. Mathews gr_174 gives p₁ = 1.008823529411764 and p₂ = 1.000008616730388, the latter carrying rounding error.
- **Script comments verified:** expanded f(1+6.4e−7) = −8.88e−16 against factored 7.86e−19. x₄ = 1.0 exactly, then NaN.
- **Picture:** drawn slope 0.306 = f'(1.3)/3. Labels 1.3, 1.008824, 1.000009, 1.0. 4 frames.

### newtonimpee.jl (standard Newton, arctan)
- **Method:** plain Newton, f = atan, f' = 1/(1+x²).
- **Numbers:** script −1.4136186488037423, 1.4501293146283372, −1.5506259756377534, 1.84705408415019, −2.8935623931424104, 8.710325846983183. Independent: −1.4136186488037424, 1.450129314628338, −1.5506259756377557, 1.8470540841501973, −2.8935623931424393, 8.710325846983391.
- **References:** x_c = 1.39174520027 (mpmath findroot of 2x = (1+x²)·atan x). Methods B and C were computed independently (see 5h–5k).
- **Picture:** steps are drawn only when both endpoints lie inside xlims. Only the x₅→x₆ step is skipped, and the legend reports x₆ = 8.71 "(out of range)". ylims ±1.8 contain the whole range of atan. 7 frames.

