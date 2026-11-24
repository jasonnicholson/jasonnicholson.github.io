# Improved Newton Method — animation review (round 8)

Page: `pages/numerical-methods/improved-newton-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Zero Error, zero Misleading, zero Minor.

Items considered and rejected as findings:
- Case 5 last frame: the step x5 to x6 = 8.71 is not drawn, because x6 lies outside xlims (-4, 5). The legend says `x₍6₎ = 8.71 (out of range)`, so nothing is clamped or misreported. A viewer gets the right idea.
- Cases 2 and 4 label x3 as `1.0` (rounded to 6 digits; true x3 = 1 + 1.32e-10 and 1 + 8.25e-12). This is honest rounding, and the page states it for Case 4.
- Cases 1 and 3 use the expanded polynomial. At the iterates reached (error ≥ 3.2e-4 and ≥ 2.4e-3), f ≥ 3e-7 and ≥ 4e-8, so cancellation is negligible. The iterates agree with 60-digit values to ≤ 3e-12.
- Case 5 (arctan) is not in Mathews' module. The page attributes only Cases 1-4 to Mathews (line 30), so this is an addition, not a departure. Example 3 (quadruple root) and the B/C iterations are omitted, and the page says so explicitly (line 31), so they are not silent drops.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonimpaa.jl` | 0 | 6.6 | newtonimpaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpbb.jl` | 0 | 6.7 | newtonimpbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpcc.jl` | 0 | 7.3 | newtonimpcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpdd.jl` | 0 | 7.0 | newtonimpdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpee.jl` | 0 | 6.6 | newtonimpee.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

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

| # | Location | Claim (page words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | l.12 | Newton converges at least quadratically at a simple root, only linearly at multiplicity m≥2 | Standard theory; ratios below (0.50 and 0.667 limits) | confirmed |
| 2 | l.15 | Method A: x_{n+1} = x_n − m f/f' | matches archive (8)/(9); scripts bb/dd line 31 | confirmed |
| 3 | l.16 | Method B = Newton on u=f/f', formula x − f f'/(f'^2 − f f'') | indep.py: Newton on u and explicit formula give identical iterates (0.631573, 0.171166, …) | confirmed |
| 4 | l.17 | Method C: x_{n,m} = x_n − m f/f' from m=1, increase m while abs(f) decreases, take last such point | archive gr_115 algorithm (p1=p0−Δx, p2=p0−2Δx, While abs(y2)<abs(y1) …) | confirmed |
| 5 | l.19 | Started close enough, A and B converge at least quadratically | Case 2: e/e² → 0.16667 (=1/6); Case 4: → 0.11111 (=1/9); B on f1: 0.98765, 0.99997, 1−1e-10 | confirmed |
| 6 | l.19 | Animations show standard Newton and Method A; Case 5 also discusses B and C | scripts aa/cc/ee standard, bb/dd Method A | confirmed |
| 7 | l.23 | Cases 1-4 have a multiple root at x=1; arctan has a simple root at 0 | factorisations checked: expansions minus factored forms = 1e-61 at x=0.7 | confirmed |
| 8 | l.24 | Standard Newton (Cases 1,3,5): slanted line is the tangent at x_n; Method A (2,4): slope f'(x_n)/m | segment (x_n,f_n)→(x_n − m f_n/f'_n, 0) has slope f'_n/m; e.g. Case 2 frame 2: slope 0.297/0.287 = 1.035 = f'(1.3)/2 | confirmed |
| 9 | l.25 | Slanted line from (x_n,f(x_n)) to (x_{n+1},0), vertical line back to the curve | plotting code lines 47/50 etc.; frames aa/011, cc/013, ee/006 | confirmed (Case 5's out-of-window final step is omitted and labelled "out of range") |
| 10 | l.26 | Standard degrades to linear; Method A restores at least quadratic by multiplying the step by m | as 1, 5 | confirmed |
| 11 | l.30 | Cases 1-4 follow Mathews Examples 1 and 2 | archive gr_124/126: p0=1.3, x³−3x+2=0; gr_165/167: p0=1.3, x⁴−x³−3x²+5x−2=0; archive Newton table gr_130 matches script aa iterates (1.156521739, 1.080154278, …) | confirmed |
| 12 | l.31 | Example 3 compares methods at a quadruple root | lnk_6 text "quadruple root" | confirmed |
| 13 | l.31 | Example 1's caveat plots rounding noise of expanded f near the double root | lnk_4 caveat text ("graph their difference") | confirmed |
| 14 | l.31 | Example 2's caveat runs Method A with m=2 at the triple root, converging only linearly | archive caveat.png: `NewtonRaphsonAccelerate[1.3, 2, 20]`; table gr_189 shows linear progress; theory ratio → 1/3 | confirmed |
| 15 | l.33 heading | Case 1: standard Newton, linear, f=x³−3x+2, x0=1.3 | newtonimpaa.jl l.11, 15, 27 | confirmed |
| 16 | l.35 | f = (x−1)²(x+2), double root at 1 | algebra and mpmath | confirmed |
| 17 | l.36 | f'(x*) = 0 at a multiple root, so the standard proof breaks down | f'(1) = 0 | confirmed |
| 18 | l.37 | Each step only halves the error; creeps over many steps | error ratios 0.5217, 0.5121, 0.5064, … 0.50005; x10 = 1.000321 | confirmed |
| 19 | l.39/41 | Link/embed newtonimpaa; alt text "slow linear convergence from x₀=1.3 toward the double root" | manifest wiring; frames | confirmed |
| 20 | l.43 heading | Case 2: Method A m=2, quadratic, same f, x0=1.3 | newtonimpbb.jl l.14, 18, 20, 31 | confirmed |
| 21 | l.45-47 | m=2 restores quadratic convergence; much faster than Case 1 from same start | iterates 1.3, 1.013043, 1.0000282, 1+1.32e-10; e/e² → 1/6 | confirmed |
| 22 | l.49/51 | Link/embed newtonimpbb; alt "quadratic convergence … in just a few steps" | manifest; 4 frames | confirmed |
| 23 | l.53 heading | Case 3: standard Newton, triple root, f=x⁴−x³−3x²+5x−2, x0=1.3 | newtonimpcc.jl l.11, 15 | confirmed |
| 24 | l.55 | f = (x−1)³(x+2), triple root at 1 | mpmath expansion check | confirmed |
| 25 | l.56-57 | Asymptotic constant (m−1)/m = 2/3; each step reduces error by 1/3; slower than the double root | ratios 0.6765, 0.6736, … 0.6668 | confirmed |
| 26 | l.59/61 | Link/embed newtonimpcc; alt "very slow linear convergence" | manifest; frame 13 x12 = 1.002423 | confirmed |
| 27 | l.63 heading | Case 4: Method A m=3, quadratic, same quartic, x0=1.3 | newtonimpdd.jl l.14, 18, 20 | confirmed |
| 28 | l.65 | m=3 restores quadratic convergence | e/e² → 0.11111 | confirmed |
| 29 | l.66 | Iterates 1.3, 1.008824, 1.000009, then x3 within 1e-11 of the root, labelled 1.0 | script: 1.0088235294, 1.0000086167, 1.0000000000082498; mpmath x3−1 = 8.2497e-12; frame 4 legend "x₍3₎ = 1.0" | confirmed |
| 30 | l.67-68 | Known m gives at least quadratic convergence from a close start; B and C do not need m | theory / archive | confirmed |
| 31 | l.70/72 | Link/embed newtonimpdd; alt text | manifest; frames | confirmed |
| 32 | l.76 heading | Case 5: standard Newton diverges, f=arctan x, x0=1.4 | newtonimpee.jl l.11, 15 | confirmed |
| 33 | l.79 | Converges only when abs(x0) < x_c ≈ 1.3917 | mpmath root of 2x = (1+x²)atan x: 1.3917452003 | confirmed |
| 34 | l.79 | From 1.4 each step overshoots further; iterates escape to ±∞ | iterates 1.4, −1.41362, 1.45013, −1.55063, 1.84705, −2.89356, 8.71033 (script and mpmath agree) | confirmed |
| 35 | l.80 | Method A with m=1 is standard Newton, so it does not fix this | identity | confirmed |
| 36 | l.81 | u=(1+x²)atan x is increasing and convex for x>0; B iterates decrease monotonically: 0.6316, 0.1712, 0.00625, 3.25e-7 | u' = 1 + 2x atan x > 0, u'' = 2 atan x + 2x/(1+x²) > 0; mpmath: 0.631573, 0.171166, 0.00624689, 3.25005e-7 | confirmed |
| 37 | l.82 | Method C: x_{0,1} ≈ −1.41, x_{0,2} ≈ −4.23 with larger abs(f); C keeps m=1 every step and diverges like Newton | mpmath per Mathews' algorithm: step 0 abs(f) 0.9551 vs 1.3385 at −4.2272; m=1 kept at all 6 steps checked; in general x−(1+x²)atan x crosses zero, so x_{n,2} lies farther out on the same side | confirmed |
| 38 | l.83 | A and C do not repair a global-convergence failure | 35, 37 | confirmed |
| 39 | l.85/87 | Link/embed newtonimpee; alt "divergent oscillation from x₀=1.4, just outside the critical convergence radius" | manifest; frames 6-7 | confirmed |
| 40 | counts | Case frames: 11, 4, 13, 4, 7 (n_iters+1) | manifest frame counts | confirmed |

### 3. Implementation checks

### newtonimpaa.jl (standard Newton, double root)
- *Method:* plain Newton, l.27. Correct.
- *Numbers:* script x1..x10 = 1.15652174, 1.08015428, 1.04059190, 1.02043053, 1.01024970, 1.00513356, 1.00256897, 1.00128503, 1.00064265, 1.00032136. mpmath gives the same to ≤ 4e-14. Archive table gr_130 agrees to all printed digits.
- *Reference:* root x=1 (exact factorisation).
- *Picture:* frames 1-11 show the point at x_n with the matching legend label, blue tangent segments and vertical returns. Title function = code function.

### newtonimpbb.jl (Method A, m=2)
- *Method:* x − 2f/f' with factored f and f' = 3(x−1)(x+1) (correct derivative). Correct.
- *Numbers:* script 1.0130434783, 1.0000281717, 1.000000000132272; mpmath 1.0130434783, 1.0000281717, 1.0000000001322719. e_{n+1}/e_n² → 1/6, which matches the theory e²/(3(e+2)).
- *Comments:* "f(1+1.3e-10) = 0.0 instead of 5.1e-20" confirmed (0.0 vs 5.07e-20); "4th step lands on 1 then 0/0" confirmed (x4 = 1.0, x5 = NaN).
- *Picture:* the orange segment slope equals f'(x0)/2 (1.035). The final legend reads 1.0 (rounded).

### newtonimpcc.jl (standard Newton, triple root)
- *Method:* plain Newton; f' = 4x³−3x²−6x+5 is the correct derivative. Correct.
- *Numbers:* script x12 = 1.0024225476442639; mpmath 1.0024225476413147 (difference 3e-12 from expanded-form rounding, invisible at 6 digits). Ratios → 0.6668.
- *Picture:* frame 13 legend 1.002423 matches.

### newtonimpdd.jl (Method A, m=3)
- *Method:* x − 3f/f', with f' = (x−1)²(4x+5) (correct). Correct.
- *Numbers:* script 1.0088235294, 1.0000086167, 1.0000000000082498; mpmath identical. e/e² → 1/9.
- *Comments:* "f(1+6.4e-7) = −8.9e-16 instead of +7.9e-19" confirmed; 4th step x4 = 1.0, then NaN, confirmed.
- *Picture:* frame 4 shows an orange segment from (1.3, 0.0891) to about (1.0088, 0). Legend x₍3₎ = 1.0.

### newtonimpee.jl (standard Newton, arctan)
- *Method:* plain Newton, f' = 1/(1+x²). Correct.
- *Numbers:* script and mpmath agree to ≥ 13 digits for all 7 iterates (listed in ledger 34).
- *Reference:* root 0; x_c = 1.39174520 (mpmath).
- *Picture:* segments are drawn only when both endpoints lie in [−4, 5]. Frames 1-6 show every step. Frame 7 omits the x5→x6 step and labels x6 = 8.71 "(out of range)", which is truthful and not clamped.

