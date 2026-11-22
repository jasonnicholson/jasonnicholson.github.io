# Improved Newton Method — animation review (round 3)

Page: `pages/numerical-methods/improved-newton-method/`. Reported findings: **0 Error, 0 Misleading, 1 Minor**.

## Findings

### F1. Fidelity, Minor: Mathews' "wrong m" caveat in Example 2 is dropped without mention
- **Location:** `index.qmd` line 30: "Cases 1–4 follow Examples 1 and 2 of Mathews' Improved Newton Method module; the module's Example 3, which compares the methods at a quadruple root, and the Method B and Method C iterations of all its examples are not animated here."
- **What is there now:** Line 30 lists what the page omits from the archive. It does not list the Caveat in Mathews' Solution 2 (`Links/NewtonImprovedMod_lnk_5.html`), where Method A is run on the triple root with the wrong multiplicity m = 2 instead of 3. That run shows convergence falling back to linear. This is the module's main warning about Method A, and the page gives no hint that it exists.
- **What is true:** The archive's caveat table (gr_189) gives p1 = 1.105882352941176, p2 = 1.036087243886316, p3 = 1.012124024389068, … My independent run (`/usr/bin/python3 wrongm.py`, mpmath at 40 digits, factored f) gives 1.10588235294118, 1.03608724388632, 1.01212402438906, … with error ratios 0.353, 0.341, 0.336, … → 1/3. That is linear convergence, as Mathews says.
- **Suggested correction:** Either add "and Example 2's caveat showing Method A with the wrong multiplicity (m = 2 at the triple root), which converges only linearly" to the omissions in line 30, or add a Method A, m = 2 case on the quartic. Use the factored form of f so that cancellation does not corrupt the late iterates the way it does in Mathews' Float64 table (p13 to p15 there drift below 1).

No other findings. Every numerical claim, behaviour claim, formula and wiring item below checked out against my own computation and the frames.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)


**Count: Error 0, Misleading 0, Minor 1.**



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `newtonimpaa.jl` | 0 | 7.2 | newtonimpaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpbb.jl` | 0 | 6.0 | newtonimpbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpcc.jl` | 0 | 6.9 | newtonimpcc.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtonimpdd.jl` | 0 | 6.4 | newtonimpdd.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
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

| # | Page text (location) | Check | Verdict |
|---|---|---|---|
| 1 | Description l.12: when Newton converges, it is quadratic at a simple root and linear at a root of multiplicity m ≥ 2 | Computed ratios: Case 1 e_{n+1}/e_n → 0.5000, Case 3 → 0.6668, while e_{n+1}/e_n² blows up (778 and 184 at the last step), so convergence is linear | confirmed |
| 2 | l.13 "Mathews compares three improvements" | Archive Examples 1–3 each say "compare Methods A, B and C" | confirmed |
| 3 | l.15 Method A: x_{n+1} = x_n − m f/f′ | Archive formula (8)/(9). Scripts bb and dd use exactly this (line 31) | confirmed |
| 4 | l.16 Method B: Newton on u = f/f′, formula f f′/(f′² − f f″) | Arctan check: the page's formula and Newton on u = (1+x²)atan x give identical iterates (0.63157321, 0.17116554, 0.0062468913, 3.250049e-7) | confirmed |
| 5 | l.17 Method C: start at m = 1, increase m while \|f(x_{n,m+1})\| < \|f(x_{n,m})\|, take the last such point | Matches archive algorithm gr_115 (Δx = f/f′; p1 = p0 − Δx, p2 = p0 − 2Δx; while \|y2\| < \|y1\| advance j) | confirmed |
| 6 | l.19 Started close enough to a multiple root, A and B converge quadratically | A: e/e² → 0.16666 (Case 2) and 0.11111 (Case 4) | confirmed (A computed; B is standard theory and is not animated) |
| 7 | l.19 "The animations show standard Newton and Method A; Case 5 also discusses Methods B and C" | Scripts: aa, cc, ee are standard Newton (m = 1); bb, dd are Method A | confirmed |
| 8 | l.23 Cases 1–4 have a multiple root at x = 1; Case 5 is arctan with a simple root at 0 | (x−1)²(x+2) and (x−1)³(x+2); the expansions were checked symbolically against the scripts' expanded forms | confirmed |
| 9 | l.24 standard-Newton line is the tangent at x_n; Method A line has slope f′(x_n)/m | Drawn segment slope f(x_n)/(x_n − x_{n+1}) vs f′/m: Case 2 1.035 / 1.035, 0.0393856 / 0.0393856, 8.4516e-5 / 8.4516e-5; Case 4 0.306 / 0.306 etc. For standard Newton the slope equals f′(x_n) by construction. (The vertical return segments are not tangents, but no reader would take them for tangents.) | confirmed |
| 10 | l.25 line from (x_n, f(x_n)) to the next iterate's x-intercept | Plot code line 47/53/46/51/47 draws [x_n, x_{n+1}] × [f(x_n), 0] | confirmed |
| 11 | l.26 Standard Newton is linear at multiple roots; Method A restores quadratic convergence | See 1 and 6 | confirmed |
| 12 | l.28 source scripts linked under each case | 5 links present; the manifest confirms they resolve | confirmed |
| 13 | l.30 Cases 1–4 follow Examples 1 and 2; Example 3 and the B/C iterations are not animated | Archive Example 1: x³ − 3x + 2, p0 = 1.3 (gr_126, gr_124). Example 2: x⁴ − x³ − 3x² + 5x − 2, p0 = 1.3 (gr_167, gr_165). The omission list leaves out the wrong-m caveat (F1) | confirmed, with F1 |
| 14 | Case 1 heading: standard Newton, linear, double root, f = x³ − 3x + 2, x0 = 1.3 | newtonimpaa.jl lines 11, 15. GIF title matches | confirmed |
| 15 | Case 1: f = (x−1)²(x+2), double root at 1 | expansion | confirmed |
| 16 | Case 1: f′(x*) = 0 at a multiple root, so the standard proof breaks down | f′(1) = 3 − 3 = 0 | confirmed |
| 17 | Case 1: "Each step only halves the error"; creeps over many steps | Ratios 0.5217, 0.5121, 0.5064 … 0.50005. After 10 steps the error is still 3.21e-4 | confirmed |
| 18 | Case 1 alt: slow linear convergence from x0 = 1.3 to the double root | frames 1–11, legend x(10) = 1.000321 | confirmed |
| 19 | Case 2 heading: Method A, m = 2, quadratic, same f, x0 = 1.3 | newtonimpbb.jl lines 14–20, 31 | confirmed |
| 20 | Case 2: formula with m = 2 restores quadratic convergence | Iterates 1.0130434782608697, 1.0000281716593107, 1.000000000132272. e/e² = 0.1449, 0.1656, 0.16666 | confirmed |
| 21 | Case 2: same function and start as Case 1, much faster | 3 steps reach error 1.3e-10, against 3.2e-4 after 10 steps in Case 1 | confirmed |
| 22 | Case 2 alt: quadratic convergence "in just a few steps" | 4 frames, legend 1.3, 1.013043, 1.000028, 1.0 | confirmed |
| 23 | Case 3 heading: standard Newton, triple root, quartic, x0 = 1.3 | newtonimpcc.jl lines 11–15 | confirmed |
| 24 | Case 3: f = (x−1)³(x+2) | expansion matches the script's quartic | confirmed |
| 25 | Case 3: asymptotic constant (m−1)/m; 2/3 for a triple root; error reduced by 1/3 per step; slower than the double root | Ratios 0.6765 → 0.66680 at step 12, vs 0.5 in Case 1 | confirmed |
| 26 | Case 3 alt: very slow linear convergence | legend x(12) = 1.002423 (true 1.0024225476) | confirmed |
| 27 | Case 4 heading: Method A, m = 3, quartic, x0 = 1.3 | newtonimpdd.jl lines 14–20, 31 | confirmed |
| 28 | Case 4: iterates 1.3, 1.008824, 1.000009, then x3 within 1e-11 of the root, labelled 1.0 | mpmath: 1.00882352941176, 1.00000861672794, 1.00000000000825 (error 8.25e-12). Float64 script: identical to the shown digits. Frame 4 legend "x(3) = 1.0" | confirmed |
| 29 | Case 4: m = 3 restores quadratic convergence | e/e² = 0.0980, 0.1107, 0.11111 | confirmed |
| 30 | Case 4 alt | 4 frames, orange Method A lines | confirmed |
| 31 | Case 5 heading: standard Newton diverges, arctan, x0 = 1.4 | newtonimpee.jl lines 11–16 | confirmed |
| 32 | Case 5: converges only when \|x0\| < x_c ≈ 1.3917 | Root of (1+x²)atan x = 2x: x_c = 1.39174520027 | confirmed |
| 33 | Case 5: each tangent overshoots further; iterates escape toward ±∞ | 1.4, −1.41362, 1.45013, −1.55063, 1.84705, −2.89356, 8.71033 (\|x\| strictly increasing, alternating sign) | confirmed |
| 34 | Case 5: Method A with m = 1 is standard Newton and does not fix it | identity | confirmed |
| 35 | Case 5: Method B on u = (1+x²)atan x fixes it; u increasing and convex for x > 0; monotone 0.6316, 0.1712, 0.00625, 3.25e-7 | u′ = 1 + 2x atan x > 0; u″ = 2 atan x + 2x/(1+x²) > 0 for x > 0. Iterates 0.63157, 0.17117, 0.0062469, 3.2500e-7, 4.6e-20 | confirmed |
| 36 | Case 5: Method C: m = 1 step crosses 0 (x_{1,1} ≈ −1.41), m = 2 gives ≈ −4.23 with larger \|f\|, C keeps m = 1 and diverges like Newton | Step 1: x_{1,1} = −1.4136 (\|f\| 0.955), x_{1,2} = −4.2272 (\|f\| 1.3385). Steps 2–6 likewise reject m = 2. In general (1+x²)atan x > \|x\| means m = 1 always crosses, and m = 2 lands farther out on the same side, so \|f\| is larger | confirmed |
| 37 | Case 5: A and C do not repair a global-convergence failure | follows from 34 and 36 | confirmed |
| 38 | Case 5 alt: divergent oscillation from x0 = 1.4, just outside the radius | frames 1–7 | confirmed |
| 39 | Wiring: Case k → script/GIF aa, bb, cc, dd, ee | Each GIF's title and parameters match its heading | confirmed |
| 40 | Counts: frames 11/4/13/4/7 = n_iters + 1 | manifest frame counts | confirmed |

### 3. Implementation checks

All scripts use the scheme of a precomputed iterate vector followed by one staircase step per frame. The red marker's legend shows x_frame.

### newtonimpaa.jl (Case 1)
- **Method:** standard Newton, `xs[i+1] = xs[i] - f/fp` (l.27). fp = 3x² − 3 is the correct derivative.
- **Numbers:** Float64 vs mpmath, x1 to x10: 1.1565217391304348 / 1.15652173913043, 1.0801542776998598 / 1.08015427769986, … 1.0003213616712867 / 1.0003213616712. Archive table gr_130 agrees (p1 = 1.156521739130435, p10 = 1.000321361671179). The expanded form causes no visible cancellation at this depth (f(x10) ≈ 3.1e-7).
- **Reference:** the root x = 1 is exact.
- **Picture:** Frames 1, 2, 4, 11 inspected. The tangent runs from (x_n, f(x_n)) to (x_{n+1}, 0) and the vertical from there goes back to the curve. Legend values match the computed iterates at 6 decimals. After about frame 5 the steps are too small to see at this zoom, but the legend carries the numbers, so this is not misleading.

### newtonimpbb.jl (Case 2)
- **Method:** Method A, m = 2 (l.31), on the factored form (x−1)²(x+2) with fp = 3(x−1)(x+1). Both are correct.
- **Numbers:** 1.0130434782608697, 1.0000281716593107, 1.000000000132272, against mpmath 1.01304347826087, 1.00002817165931, 1.00000000013227. Archive gr_133: 1.013043478260870, 1.000028171659317, 1.000000000135923 (Mathews used the expanded f, whose cancellation shifts p3 at the 1e-12 level). Comment checks: expanded f(1 + 1.3e-10) = 0.0 vs factored 5.07e-20 (confirmed). The 4th step gives exactly 1.0 (confirmed), so stopping at n_iters = 3 is justified.
- **Picture:** orange segment slope equals f′/m to about 1e-12 relative (see ledger 9). Legend 1.3, 1.013043, 1.000028, 1.0 matches.

### newtonimpcc.jl (Case 3)
- **Method:** standard Newton on the expanded quartic. fp = 4x³ − 3x² − 6x + 5 is correct.
- **Numbers:** Float64 x12 = 1.0024225476442639 vs mpmath 1.00242254764131. All 12 agree to at least 1e-11, and cancellation is harmless at f ≈ 4e-8.
- **Picture:** frames 1, 3, 5, 7, 9, 11, 13 on the sheet. Legend values match (1.136693, 1.061487, 1.02748, 1.012244, 1.005448, 1.002423).

### newtonimpdd.jl (Case 4)
- **Method:** Method A, m = 3, on the factored (x−1)³(x+2) with fp = (x−1)²(4x+5). Both are correct.
- **Numbers:** 1.0088235294117647, 1.0000086167279412, 1.0000000000082498, against mpmath 1.00882352941176, 1.00000861672794, 1.00000000000825. Comment checks: expanded f(1 + 6.4e-7) = −8.88e-16 vs factored 7.86e-19 (confirmed). The 4th step gives exactly 1.0 (confirmed).
- **Picture:** slope check passes. Legend 1.3, 1.008824, 1.000009, 1.0 matches.

### newtonimpee.jl (Case 5)
- **Method:** standard Newton with f = atan, fp = 1/(1+x²). Correct.
- **Numbers:** Float64 iterates agree with mpmath to 12 digits (ledger 33).
- **Picture:** x6 = 8.71 lies outside xlims (−4, 5), so the last step's tangent is not drawn and the marker is suppressed. The legend reads "x(6) = 8.71 (out of range)" with the true value and no clamping, so this is not misleading. All other segments are correct, and the legend shows x1 to x5 at 4 decimals: −1.4136, 1.4501, −1.5506, 1.8471, −2.8936.

### Not determined
Nothing material. I did not run Method B on the multiple-root cases, because the page makes no numerical claim about them.

