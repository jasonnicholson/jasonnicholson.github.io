# Improved Newton Method — animation review (round 6)

Page: `pages/numerical-methods/improved-newton-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim in the page and every number shown in the GIFs agreed with my independent computation. Details are in the ledger and implementation checks below.

Observations I considered and decided are not findings:
- Case 5, final frame: the step x₅ → x₆ is not drawn because x₆ = 8.71 is outside the window [−4, 5]. The legend says `x₍₆₎ = 8.71 (out of range)`, so the viewer is told the true value and that it is off-screen. That is a legitimate display device, not a misleading one.
- Cases 2 and 4: after frame 2 the iterates cannot be told apart at plot scale, so frames 3–4 differ only in the legend label. The labels carry the information (1.000028 / 1.0, 1.000009 / 1.0), and this is what quadratic convergence looks like.
- Case 5 (arctan) is not in Mathews' Improved Newton module. The page says that Cases 1–4 follow Examples 1 and 2, and it presents Case 5 as an additional cautionary example. That is an addition, not a departure. Example 3 and the Method B/C runs are disclosed as not animated (index.qmd line 31).



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonimpaa.jl` | 0 | 9.0 | newtonimpaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpbb.jl` | 0 | 5.9 | newtonimpbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpcc.jl` | 0 | 6.9 | newtonimpcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpdd.jl` | 0 | 6.1 | newtonimpdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpee.jl` | 0 | 6.3 | newtonimpee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | l.12 | Newton converges quadratically at a simple root, only linearly at multiplicity m ≥ 2 | Standard theory (Mathews Thm 1); Cases 1/3 ratios → 1/2, 2/3 (below) | confirmed |
| D2 | l.15 | Method A: x_{n+1} = x_n − m f/f′ | Matches the archive's formula (8); scripts bb/dd line 31 | confirmed |
| D3 | l.16 | Method B formula x − f f′/(f′² − f f″) = Newton on u = f/f′ | indep.py: page formula and Newton-on-u give identical iterates on arctan (1.4, 0.631573, 0.171166, 0.00624689, 3.25005e-7, …) | confirmed |
| D4 | l.17 | Method C: start m = 1, increase m while \|f(x_{n,m+1})\| < \|f(x_{n,m})\|, take the last such point | Archive algorithm image gr_115 (While \|y₂\| < \|y₁\| … p₁ = p₂) is the same procedure; my implementation gives m = 2 / m = 3 at the double / triple roots | confirmed |
| D5 | l.19 | Close to a multiple root, A and B converge quadratically | Case 2 e_{n+1}/e_n² → 0.16666 (= 1/6); Case 4 → 0.11111 (= 1/9); Method B arctan e.g. 3.25e-7 → 4.58e-20 | confirmed |
| D6 | l.19 | Animations show standard Newton and Method A; Case 5 also discusses B and C | Scripts aa/cc/ee standard, bb/dd Method A | confirmed |
| A1 | l.23 | Cases 1–4 have a multiple root at x = 1; Case 5 arctan has a simple root at 0 | sympy factor: (x−1)²(x+2), (x−1)³(x+2) | confirmed |
| A2 | l.24 | Standard Newton: slanted line = tangent at x_n; Method A: line of slope f′(x_n)/m | Line runs (x_n, f_n) → (x_{n+1}, 0); slope = f_n/(m f_n/f′_n) = f′_n/m (code l.47/53/51/46) | confirmed |
| A3 | l.25 | Slanted line (x_n,f(x_n)) → (x_{n+1},0), then vertical (x_{n+1},0) → (x_{n+1},f(x_{n+1})) | Code in all 5 scripts; frames show it. Case 5's last step is not drawn because it is off-screen, and the legend says so (see §1) | confirmed |
| A4 | l.26 | Newton degrades to linear at multiple roots; Method A restores quadratic by multiplying the step by m | as D1/D5 | confirmed |
| A5 | l.28 | Julia source linked under each case | 5 links, each to the matching script | confirmed |
| A6 | l.30 | Cases 1–4 follow Examples 1 and 2 of Mathews' module | Archive gr_124–126: p₀ = 1.3, x³−3x+2; gr_165–167: p₀ = 1.3, x⁴−x³−3x²+5x−2; lnk_4/5 use m = 2 and m = 3 for Method A | confirmed |
| A7 | l.31 | Example 3 compares the methods at a quadruple root; B/C iterations and the caveats are not animated | lnk_6 text "quadruple root"; no B/C script exists | confirmed |
| A8 | l.31 | Example 1's caveat plots rounding noise in the expanded f near the double root | gr_158–159: Plot of f on [0.99999999, 1.00000001], "just multiples of Machine Epsilon" | confirmed |
| A9 | l.31 | Example 2's caveat runs Method A with m = 2 at the triple root, which converges only linearly | gr_186–188: `m = 2` instead of `m = 3`, `NewtonRaphsonAccelerate[1.3, 2, 20]`; the theory gives error factor 1 − 2/3 = 1/3, so the convergence is linear | confirmed |
| C1a | heading l.33 | Case 1: standard Newton, double root, f = x³−3x+2, x₀ = 1.3 | newtonimpaa.jl l.11, 15, 27 | confirmed |
| C1b | l.35 | f = (x−1)²(x+2), double root at 1 | sympy | confirmed |
| C1c | l.36 | f′(x*) = 0 at a multiple root | f′(1) = 3−3 = 0 | confirmed |
| C1d | l.37 | Each step only halves the error; creeps slowly over many steps | error ratios 0.5217, 0.5121, 0.5064, …, 0.50005; x₁₀ − 1 = 3.21e-4 after 10 steps | confirmed |
| C1e | alt l.41 | slow linear convergence from 1.3 toward the double root at 1 | frames 1–11, final label x₁₀ = 1.000321 (true 1.0003213617) | confirmed |
| C2a | heading l.43 | Case 2: Method A m = 2, same f, x₀ = 1.3 | newtonimpbb.jl l.14 (factored form, same function), l.18–20, 31 | confirmed |
| C2b | l.45 | uses x − m f/f′ with m = 2, the known multiplicity | code l.31; multiplicity 2 by sympy | confirmed |
| C2c | l.46–47 | restores quadratic convergence; rapid vs slow Case 1, same function and start | e_n: 0.3, 1.30e-2, 2.82e-5, 1.32e-10; e/e² → 1/6 | confirmed |
| C2d | alt l.51 | quadratic convergence to x = 1 "in just a few steps" | 3 steps to 1.3e-10; labels 1.3, 1.013043, 1.000028, 1.0 | confirmed |
| C3a | heading l.53 | Case 3: standard Newton, triple root, f = x⁴−x³−3x²+5x−2, x₀ = 1.3; even slower | newtonimpcc.jl l.11, 15 | confirmed |
| C3b | l.55 | f = (x−1)³(x+2), triple root at 1 | sympy | confirmed |
| C3c | l.56 | asymptotic error constant (m−1)/m for standard Newton | Mathews Thm 1 (7); computed ratios → 0.6668 at n = 12 | confirmed |
| C3d | l.57 | For a triple root 2/3: each iterate reduces the error by only 1/3, slower than the double root | ratios 0.676, 0.674, 0.671, …, 0.6668 (vs 0.5 in Case 1) | confirmed |
| C3e | alt l.61 | very slow linear convergence toward the triple root | final label x₁₂ = 1.002423 (true 1.0024225476) | confirmed |
| C4a | heading l.63 | Case 4: Method A m = 3, same quartic, x₀ = 1.3 | newtonimpdd.jl l.14 (factored, same function), 18–20 | confirmed |
| C4b | l.65 | m = 3 is the correct multiplicity; quadratic convergence restored | e/e² → 0.098, 0.1107, 0.11111 (= 1/9) | confirmed |
| C4c | l.66 | animated iterates 1.3, 1.008824, 1.000009, then x₃ within 1e-11 of the root, labelled 1.0 | mpmath: 1.0088235294, 1.0000086167, x₃ − 1 = 8.25e-12; frame labels 1.3 / 1.008824 / 1.000009 / 1.0 | confirmed |
| C4d | alt l.71 | quadratic convergence to the triple root | as C4b | confirmed |
| C5a | heading l.75 | Case 5: standard Newton diverges, f = arctan x, x₀ = 1.4 | newtonimpee.jl l.11, 15 | confirmed |
| C5b | l.77 | simple root at 0 | f′(0) = 1 ≠ 0 | confirmed |
| C5c | l.78 | converges only when \|x₀\| < x_c ≈ 1.3917 | root of 2x = (1+x²) arctan x: x_c = 1.391745200 | confirmed |
| C5d | l.78 | from 1.4 each tangent overshoots further; iterates escape toward ±∞ | \|x_n\|: 1.4, 1.4136, 1.4501, 1.5506, 1.8471, 2.8936, 8.7103 (strictly increasing, alternating sign) | confirmed |
| C5e | l.79 | Method A with m = 1 is standard Newton, so it does not fix this | identity | confirmed |
| C5f | l.80 | u = (1+x²) arctan x is increasing and convex for x > 0 | u′ = 2x arctan x + 1 > 0, u″ = 2 arctan x + 2x/(1+x²) > 0 for x > 0 | confirmed |
| C5g | l.80 | Method B iterates decrease monotonically: 0.6316, 0.1712, 0.00625, 3.25×10⁻⁷ | mpmath: 0.631573, 0.171166, 0.00624689, 3.25005e-7, 4.58e-20 | confirmed |
| C5h | l.81 | Method C: the m = 1 step always crosses 0 (x₁,₁ ≈ −1.41); m = 2 lands farther out (x₁,₂ ≈ −4.23, larger \|f\|) | x₁,₁ = −1.41362, f = −0.955118; x₁,₂ = −4.22724, f = −1.33851. "Always crosses": (1+x²) arctan x > x for x > 0 because d/dx[(1+x²) arctan x − x] = 2x arctan x > 0 | confirmed |
| C5i | l.81 | C keeps m = 1 at every step and diverges exactly as standard Newton | Method C run for 6 steps: m used [1,1,1,1,1,1], iterates identical to standard Newton | confirmed |
| C5j | l.82 | A and C do not repair this global-convergence failure | C5e, C5i | confirmed |
| C5k | alt l.86 | divergent oscillation from 1.4, just outside the critical radius | C5c, C5d; frames show alternating sides | confirmed |
| W1 | links/embeds | each case links and embeds its own script/GIF | aa↔Case 1, bb↔2, cc↔3, dd↔4, ee↔5; titles in the frames match the headings | confirmed |
| W2 | manifest | committed GIFs are reproduced by the scripts | manifest: all 5 byte-identical on regeneration | confirmed |

### 3. Implementation checks

All five scripts compute the iterates first, then animate them. I cut each script before `# --- Animation ---` and printed `xs` (inst_*.jl). For the independent check I used mpmath at 60 digits with the expanded polynomials (indep.py).

### newtonimpaa.jl (standard Newton, x³−3x+2, x₀ = 1.3, 10 steps)
- Method: plain Newton, x − f/f′ (l.27). f′ = 3x²−3 is correct.
- Numbers, script vs independent: x₁ 1.1565217391304348 / 1.1565217391304348; x₅ 1.0102496959724938 / 1.0102496959724945; x₁₀ 1.0003213616712867 / 1.0003213616712000. They agree to about 1e-14; every 6-decimal label matches.
- Reference: root x = 1 by factorisation, with no numeric reference involved.
- Picture: tangent segments run from (x_n, f(x_n)) to (x_{n+1}, 0), followed by verticals. The title function matches the code. Frames 1, 2, 6 and 11 inspected, and the legend index matches the frame (x₍k₎ on frame k+1).

### newtonimpbb.jl (Method A, m = 2, same f, 3 steps)
- Method: x − 2 f/f′ (l.31) is Method A. Factored f and f′ = 3(x−1)(x+1) agree with sympy's diff.
- Numbers: 1.0130434782608697 / 1.0130434782608696; 1.0000281716593107 / same; 1.000000000132272 / 1.0000000001322719. e_{n+1}/e_n² → 0.16666, so the convergence is quadratic.
- Comment claims (l.13, l.19): expanded f(1+1.3e-10) evaluates to 0.0 and factored to 5.07e-20. A 4th step gives exactly 1.0 and a 5th gives NaN (c4.jl). Both confirmed.
- Picture: the line from (x_n, f_n) to (x_{n+1}, 0) has slope f′/m, as the comment says. Labels are 1.3, 1.013043, 1.000028, 1.0.

### newtonimpcc.jl (standard Newton, quartic, 12 steps)
- Method: plain Newton. f′ = 4x³−3x²−6x+5 is correct.
- Numbers: x₁ 1.2029411764705882 / same; x₆ 1.0274800683263425 / 1.0274800683263394; x₁₂ 1.0024225476442639 / 1.0024225476413147. Expanded-form cancellation gives about 3e-12 of drift, which is far below the 6-decimal labels. The error ratio → 0.6668.
- Picture: the final frame shows the label x₁₂ = 1.002423 and the curve negative for x < 1, which is right for an odd-multiplicity root with x + 2 > 0.

### newtonimpdd.jl (Method A, m = 3, quartic, 3 steps)
- Method: x − 3 f/f′ with factored f and f′ = (x−1)²(4x+5), which agrees with sympy.
- Numbers: 1.0088235294117647 / same; 1.0000086167279412 / same; 1.0000000000082498 / 1.0000000000082497. e/e² → 1/9.
- Comment claims: expanded quartic f(1+6.4e-7) = −8.88e-16 and factored = 7.86e-19. The 4th step gives 1.0 and the 5th NaN. Both confirmed.
- Picture: labels 1.3, 1.008824, 1.000009, 1.0, which match the page.

### newtonimpee.jl (standard Newton, arctan, x₀ = 1.4, 6 steps)
- Method: plain Newton with f′ = 1/(1+x²).
- Numbers: −1.4136186488037423 / −1.4136186488037424; 1.4501293146283372 / same; −1.5506259756377534 / −1.5506259756377557; 1.84705408415019 / 1.8470540841501973; −2.8935623931424104 / −2.8935623931424393; 8.710325846983183 / 8.710325846983391. Labels (4 decimals in range, 2 when out of range) match.
- Reference: the critical radius quoted only in the comment and on the page is x_c = 1.3917452 (mpmath findroot).
- Picture: a segment is drawn only if both endpoints lie in [−4, 5]. That skips only the step x₅ → x₆, and the last frame's legend says "8.71 (out of range)". All 7 frames inspected on the contact sheet.

### Method B / Method C (page text only, no script)
These are computed independently in indep.py. Method B on arctan converges monotonically: 1.4 → 0.631573 → 0.171166 → 0.00624689 → 3.25e-7. Method C, implemented as Mathews' algorithm in gr_115, keeps m = 1 on arctan and reproduces the divergent Newton sequence. As a sanity check, it picks m = 2 and m = 3 on Examples 1 and 2 and reaches 1.000028172 and 1.000008617 in two steps.

