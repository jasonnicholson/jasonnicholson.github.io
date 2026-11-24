# Improved Newton Method — animation review (round 9)

Page: `pages/numerical-methods/improved-newton-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every claim in the ledger below was checked against my own computation or against the frames, and every one was confirmed.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonimpaa.jl` | 0 | 6.6 | newtonimpaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpbb.jl` | 0 | 6.5 | newtonimpbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpcc.jl` | 0 | 6.9 | newtonimpcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpdd.jl` | 0 | 6.7 | newtonimpdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| D1 | l.12 | Newton converges at least quadratically at a simple root and only linearly at multiplicity m ≥ 2 | Standard theory; the numerics below show linear ratios of 1/2 and 2/3 for m = 2 and 3 | confirmed |
| D2 | l.15 | Method A: x_{n+1} = x_n − m f/f' | Matches Mathews (8)/(9), and bb.jl:31 and dd.jl:31 implement it | confirmed |
| D3 | l.16 | Method B is Newton on u = f/f', which gives x − f f'/(f'^2 − f f'') | u' = (f'^2 − f f'')/f'^2, so u/u' = f f'/(f'^2 − f f''). Matches Mathews (10) | confirmed |
| D4 | l.17 | Method C starts at m = 1, increases m while \|f(x_{n,m+1})\| < \|f(x_{n,m})\| and takes the last such point | Matches Mathews' algorithm (gr_115) and the subroutine (gr_123), apart from Mathews' mmax = 8 cap | confirmed |
| D5 | l.19 | Started close enough, Methods A and B converge at least quadratically | Theory. For A see C2 and C4 (e_{n+1}/e_n^2 → 1/6 and 1/9). For B, the Case 5 Method B run converges quadratically to a simple root | confirmed |
| D6 | l.19 | The animations show standard Newton and Method A | aa, cc and ee run standard Newton. bb and dd run Method A | confirmed |
| I1 | l.23 | Cases 1–4 have a multiple root at x = 1. Case 5 is arctan with a simple root at 0 | sympy: x³−3x+2 = (x−1)²(x+2) and x⁴−x³−3x²+5x−2 = (x−1)³(x+2) | confirmed |
| I2 | l.24 | Standard-Newton cases draw the tangent. Method A cases draw a line of slope f'(x_n)/m | The drawn segment runs from (x_n, f_n) to (x_{n+1}, 0), so its slope is f_n/(m f_n/f'_n) = f'_n/m | confirmed |
| I3 | l.25 | Slanted line from (x_n, f(x_n)) to (x_{n+1}, 0), then a vertical line to (x_{n+1}, f(x_{n+1})) | Plotting code (aa:47–50 and the same lines in the other scripts) and the frames | confirmed (Case 5 omits a step that leaves the window, the frames show x₍6₎ = 8.71 labelled "out of range"; see the newtonimpee.jl row of Section 3) |
| I4 | l.26 | Standard Newton degrades to linear convergence. Method A with m restores at least quadratic convergence | C1, C3, C2, C4 | confirmed |
| I5 | l.30 | Cases 1–4 follow Mathews' Examples 1 and 2 | Archive gr_126: x³−3x+2 = 0. gr_167: x⁴−x³−3x²+5x−2 = 0. p0 = 1.3 in the tables gr_130 and gr_171. Method A m = 2 table (gr_133) and m = 3 table (gr_174) agree with the scripts to ~1e-8 before Mathews hits rounding noise | confirmed |
| I6 | l.31 | Example 3 compares the methods at a quadruple root | gr_193: x⁵−2x⁴−2x³+8x²−7x+2 = (x−1)⁴(x+2), checked by hand expansion | confirmed |
| I7 | l.31 | Example 1's caveat plots rounding noise in the expanded f. Example 2's caveat runs Method A with m = 2 at the triple root, which converges only linearly | lnk_4 caveat text ("graph their difference") and lnk_5 caveat text plus gr_186 (m = 2) and "convergence will be linear" | confirmed |
| C1a | Case 1 heading | f = x³−3x+2, x0 = 1.3, standard Newton | aa.jl:11, 15, 27 | confirmed |
| C1b | l.35 | (x−1)²(x+2), double root at 1 | sympy | confirmed |
| C1c | l.37 | Each step only halves the error and creeps slowly over many steps | Error ratios 0.5217, 0.5121, 0.5064, …, 0.50005. x10 − 1 = 3.21e-4 | confirmed |
| C1d | alt | Slow linear convergence from 1.3 toward 1 | Frames 1–11. Legend labels match the instrumented values (1.156522, 1.080154, …, 1.000321) | confirmed |
| C2a | Case 2 heading | Method A with m = 2, same f and x0, quadratic | bb.jl:18–31 | confirmed |
| C2b | l.46–47 | Restores quadratic convergence, and is much faster than Case 1 | Iterates 1.0130435, 1.0000282, 1+1.32e-10. e_{n+1}/e_n² = 0.145, 0.166, 0.1667 | confirmed |
| C2c | alt | Converges to x = 1 in a few steps | 3 steps, final label 1.0 | confirmed |
| C3a | Case 3 heading | Quartic, x0 = 1.3, standard Newton | cc.jl | confirmed |
| C3b | l.55 | (x−1)³(x+2), triple root | sympy | confirmed |
| C3c | l.56–57 | Asymptotic constant (m−1)/m = 2/3, so each step reduces the error by 1/3, slower than Case 1 | Ratios 0.6765, 0.6736, …, 0.66680. x12 − 1 = 2.42e-3 against Case 1's 3.2e-4 after 10 steps | confirmed |
| C4a | Case 4 heading | Method A with m = 3, x0 = 1.3, quadratic | dd.jl | confirmed |
| C4b | l.66 | Iterates 1.3, 1.008824, 1.000009, then x3 within 1e-11 of the root, labelled 1.0 | mpmath: 1.00882352941, 1.0000086167, 1 + 8.25e-12. Julia legend labels: 1.3, 1.008824, 1.000009, 1.0 | confirmed |
| C4c | l.65–67 | Quadratic convergence restored | e_{n+1}/e_n² = 0.098, 0.1107, 0.1111 | confirmed |
| C5a | Case 5 heading | arctan, x0 = 1.4, standard Newton | ee.jl | confirmed |
| C5b | l.79 | Converges only for \|x0\| < x_c ≈ 1.3917 | Root of 2x = (1+x²) atan x gives 1.39174520027 | confirmed |
| C5c | l.79 | Each tangent overshoots further and the iterates escape toward ±∞ | 1.4, −1.41362, 1.45013, −1.55063, 1.84705, −2.89356, 8.71033, −103.25. \|x\| increases strictly and the signs alternate | confirmed |
| C5d | l.80 | Method A with m = 1 is standard Newton and does not fix this case | Identity | confirmed |
| C5e | l.81 | u = (1+x²) atan x is increasing and convex for x > 0 | u' = 2x atan x + 1 > 0. u'' = 2(x + (1+x²) atan x)/(1+x²) > 0 for x > 0 | confirmed |
| C5f | l.81 | Method B iterates 0.6316, 0.1712, 0.00625, 3.25e-7, decreasing monotonically | 0.631573, 0.171166, 0.00624689, 3.25005e-7, 4.6e-20 | confirmed |
| C5g | l.82 | The m = 1 step always crosses 0. x_{0,1} ≈ −1.41 and x_{0,2} ≈ −4.23 with larger \|f\| | −1.41362 and −4.22724. \|f\| = 0.955 and 1.339. "Always crosses": the step length d = (1+x²) atan x exceeds x for x > 0, because d' = 1 + 2x atan x > 1 | confirmed |
| C5h | l.82 | C keeps m = 1 at every step and diverges exactly like Newton | Proof: x−2d < x−d < 0, so \|atan(x−2d)\| > \|atan(x−d)\|. My Method C run gives m = 1 on all 6 steps and the same iterates as Newton | confirmed |
| C5i | alt | Divergent oscillation from 1.4, just outside the critical radius | C5b, C5c and the frames | confirmed |
| W1 | links/embeds | Each case links its own .jl and embeds its own .gif | Lines 39/41, 49/51, 59/61, 70/72 and 85/87 point to aa, bb, cc, dd and ee respectively. The manifest shows all five GIFs regenerate byte-identically | confirmed |
| W2 | GIF titles | Titles name the function, method and root type of each case | Frames checked for all five GIFs | confirmed |
### 3. Implementation checks

**Shared.** Each script precomputes `xs` with the stated update and then draws the segments (x_k, f(x_k)) → (x_{k+1}, 0) → (x_{k+1}, f(x_{k+1})) for k ≤ frame. The red marker sits at (x_frame, f(x_frame)) and its legend label is `round(x, digits=6)` (4 digits for Case 5). All five scripts regenerate the committed GIFs byte-identically (manifest).

| Script | Method claimed and implemented | Script values (Float64) vs. independent (mpmath, 50 digits) | Reference values | Picture |
|---|---|---|---|---|
| newtonimpaa.jl | Standard Newton. aa:27 is x − f/f'. f' = 3x²−3 is correct | x1..x10 = 1.1565217391, 1.0801542777, 1.0405919010, 1.0204305277, 1.0102496960, 1.0051335580, 1.0025689695, 1.0012850340, 1.0006426545, 1.0003213617. These agree with mpmath to all 10+ digits printed. They also agree with Mathews' table gr_130 to 15 digits | Root 1 (factorisation) | Checked 11 frames. Labels match. Window [0.6, 1.8] × [−0.1, 1.3] contains every element |
| newtonimpbb.jl | Method A with m = 2 (bb:31). The factored f and f' = 3(x−1)(x+1) are correct (sympy factor) | 1.0130434783, 1.0000281717, 1.000000000132272. mpmath gives 1.01304347826087, 1.00002817165931, 1.00000000013227. The next step gives exactly 1.0, which supports the comment's "0/0" | Header comment values f(1+1.3e-10) ≈ 5.1e-20 = 3·(1.3e-10)² and "within 1.4e-10" (actual 1.32e-10) are right | Frames 1–4. The orange line is the line of slope f'/2 |
| newtonimpcc.jl | Standard Newton. f' = 4x³−3x²−6x+5 is correct | x1..x12 = 1.2029411765, …, 1.0024225476. These agree with mpmath to all printed digits and with Mathews gr_171 | Root 1 | Checked 13 frames. Window [0.5, 1.6] × [−0.05, 0.5] |
| newtonimpdd.jl | Method A with m = 3. The factored f and f' = (x−1)²(4x+5) are correct (sympy) | 1.0088235294, 1.0000086167, 1 + 8.25e-12. These agree with mpmath. The next step gives exactly 1.0 | Comment values: f(1+6.4e-7) true value 3·(6.4e-7)³ = 7.9e-19. "within 1e-11" holds (8.25e-12) | Frames 1–4 |
| newtonimpee.jl | Standard Newton on atan with f' = 1/(1+x²) | 1.4, −1.413618649, 1.450129315, −1.550625976, 1.847054084, −2.893562393, 8.710325847. All digits agree with mpmath | x_c = 1.3917452003 (mpmath findroot) | Frames 1–7. The step to x6 = 8.71 lies outside [−4, 5]. It is not drawn, and the legend reads "x₍6₎ = 8.71 (out of range)". This is honest and not misleading |

**Rate checks (property-based).**
- Case 1 error ratio → 0.5000 = (m−1)/m with m = 2.
- Case 3 error ratio → 0.6668 → 2/3.
- Case 2 e_{n+1}/e_n² → 0.16667.
- Case 4 e_{n+1}/e_n² → 0.11111.

These are linear and quadratic rates as the page states.

**Cancellation note.** Cases 1 and 3 use the expanded polynomial. At the errors reached (≥ 3e-4 and ≥ 2.4e-3), the expanded and factored forms agree to all printed digits, so this has no effect on what the animation shows.

**Archive fidelity.**
- Functions, x0 and the methods for Cases 1–4 match Mathews' Examples 1 and 2.
- The omissions (Example 3, the Method B and C runs, and the caveats) are stated explicitly on l.31, so nothing is silently dropped.
- Case 5 (arctan) is an addition the page does not attribute to this module. It is not a departure.
- I noticed that the archive's own Example 3 text says "Method A … with m = 3" for a quadruple root. That is an archive issue and does not affect this page.

