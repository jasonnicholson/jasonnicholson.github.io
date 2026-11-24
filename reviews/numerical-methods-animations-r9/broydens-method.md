# Broyden's Method — animation review (round 9)

Page: `pages/numerical-methods/broydens-method/`. Reported findings: **0 Error, 0 Misleading, 0 Minor**.

## Findings

None.

## Reviewer's notes (not findings)


**None.** Every checkable claim on the page, in the script headers and in the frames agrees with independent computation (details below).

Observations that I judged NOT to be findings (recorded so the owner can see they were considered):
- The current-iterate marker is red, the same colour as the `f2 = 0` curve, and the page does not describe the marker. It never sits anywhere that could be mistaken for a curve feature and the frame title gives its coordinates; colour choice, not misleading.
- Mathews' Example 5 also says "Compare with the Newton-Raphson method" in both cases; the archived images for that comparison are missing, the page explicitly says Newton examples are not animated, and both Example 5 cases (i) and (ii) are present. Not a dropped case.
- The page plots `||F||` (Euclidean) rather than the error; it never claims otherwise.



## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `broydenaa.jl` | 0 | 19.7 | broydenaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `broydenbb.jl` | 0 | 21.4 | broydenbb.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `broydenaa.gif` | 7 | byte-identical | broydenaa |
| `broydenbb.gif` | 8 | byte-identical | broydenbb |

### Page references

- Scripts linked: `broydenaa.jl`, `broydenbb.jl`
- GIFs embedded: 2
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

| # | Location | Claim (page's words) | Evidence | Verdict |
|---|---|---|---|---|
| 1 | l.12 | Newton needs all n^2 partials of J each iteration; Broyden needs no further derivative/finite-difference evaluations after the first iteration | Script: `Jac` called once (l.43); updates use F only | confirmed |
| 2 | l.18 | Newton step `J dX = -F`, `X+ = X + dX` | standard | confirmed |
| 3 | l.20 | Newton quadratic near simple root | standard | confirmed |
| 4 | l.26 | central-difference `M_ij = (F_i(X+h e_j) - F_i(X-h e_j))/(2h)` | matches Mathews gr_72 (central differences, 2h) | confirmed |
| 5 | l.28 | "2n^2 additional function evaluations per iteration" | 2n vector evals = 2n^2 component evals; Mathews gr_73 says 2n^2 | confirmed |
| 6 | l.34-36 | secant condition `B_{k+1} s_k = y_k`, definitions of s_k, y_k; scalar analogue | standard; script uses same s, y | confirmed |
| 7 | l.38-40 | rank-1 update is the Frobenius-closest matrix to B_k satisfying the secant condition | `checks.py`: secant residual 1.4e-16; min over 20000 random feasible B of `||B-B_k||_F` = 1.890349 >= Broyden's 1.890302 | confirmed |
| 8 | l.42 | rank-1 correction, O(n^2) update, no extra F evaluations | standard | confirmed |
| 9 | l.46-56 | Algorithm: Step 0 exact Jacobian + Newton step; then update B_k from s_{k-1}, F(X_k)-F(X_{k-1}); solve; update | script l.43-63 is exactly this (`B = B + (y_vec - B*s)*s'/denom`, `X_next = X_curr - B\F_curr`); matches Mathews gr_207-210 | confirmed |
| 10 | l.60 | superlinear near a simple root, slower than quadratic | error ratios e_{k+1}/e_k (50-digit run): A 0.023, 0.030, 0.025, 0.039, 7.7e-4, 7.5e-6, ...; B 0.10, 0.089, 0.027, 0.095, 0.018, 8.3e-4, 2.0e-4, ... -> 0 | confirmed |
| 11 | l.60 | solve is O(n^3); O(n^2) with Sherman–Morrison update of inverse | standard; matches Mathews "Improving Broyden's Method" | confirmed |
| 12 | l.66 | system f1 = 1-4x+2x^2-2y^3, f2 = -4+x^4+4y+4y^4 | script l.16-17, contour arrays l.78-79; Mathews gr_213/gr_660 (identical files) | confirmed |
| 13 | l.68 | blue curve is f1 = 0, red curve is f2 = 0 | script l.98-99 (Z1 blue, Z2 red); frames: blue is the cube-root graph y = cbrt((2x^2-4x+1)/2), red the closed loop | confirmed |
| 14 | l.68 | "exactly two real solutions, near (0.062, 0.724) and (1.556, -0.576)" | sympy resultant in y (deg 12) has exactly 2 real roots, each with one real x satisfying both: (0.0617701263386074, 0.7244905153472166), (1.5560974843220530, -0.5756507696188434) | confirmed |
| 15 | l.68 | both inside plotted window | xlims (-1.75, 2.25), ylims (-1.5, 1.25) | confirmed |
| 16 | l.68 | each frame adds next iterate, connected by a line | script l.90-104; frames | confirmed |
| 17 | l.68 | after the first (Newton) step iterates too close to root to separate | |X2-X1| = 7.4e-4 (A), 1.07e-2 (B) vs ~97 px/unit, i.e. <= ~1 px; frames confirm | confirmed |
| 18 | l.68 | right panel is `||F(X_k)||` on log scale | script l.70, l.108 | confirmed |
| 19 | l.72 | Example 5 poses this system for Broyden; archived copy missing start-point, result and graph images | `_lnk_7`: gr_213 present (= system), gr_214-241 all missing | confirmed |
| 20 | l.72 | start points are those of the standard Broyden runs in Example 8, whose printed iterates these animations reproduce | Mathews gr_671/674 = (0.1,0.7), gr_677/680 = (1.5,-0.5); gr_676 and gr_682 (standard Broyden) list P0..P6 and P0..P7 agreeing with the script's iterates to all 16 printed digits (last digit differs by 1 in B's P2 y only) | confirmed |
| 21 | l.73 | Examples 1, 3, improved Broyden (Ex. 8), 3-D/4-D exercises not animated | module index: Ex 1 Newton, Ex 3 Pseudo-Newton, Ex 8 improved Broyden, Exercises 2,4,6,9 (3-D) and 7,10 (4-D) | confirmed |
| 22 | l.75 | Case A heading: X0 = (0.1, 0.7), root ~ (0.062, 0.724) | script l.26; root 0.061770, 0.724491 | confirmed |
| 23 | l.77 | initial Newton step moves iterate by about 0.05 | |X1-X0| = 0.04643 | confirmed |
| 24 | l.77 | reduces `||F||` from 2.5e-1 to 7.8e-3 | 2.4843e-1 -> 7.7616e-3 (Julia and Python agree) | confirmed |
| 25 | l.77 | `||F||` ~ 1e-15 (machine precision) at X6 | float 1.3552e-15; exact-arithmetic Broyden X6 residual 1.68e-15, error 1.76e-16 (~ulp of root) | confirmed |
| 26 | l.77 | X0->X4 shrinks by between 24 and 43 times per step | ratios 32.01, 24.55, 42.25, 25.67 | confirmed |
| 27 | l.77 | last two steps each > 1000 times | 1304, 164946 | confirmed |
| 28 | l.79, l.81 | link `broydenaa.jl`, embed `broydenaa.gif` are case A | script start (0.1,0.7), writes broydenaa.gif; regen byte-identical (manifest) | confirmed |
| 29 | l.81 alt | iterates close on (0.062, 0.724), only first step visible, `||F||` from 2.5e-1 to ~1e-15 (machine precision) in six steps | 7 frames X0..X6; frames 1-7 viewed | confirmed |
| 30 | l.83 | Case B heading: X0 = (1.5, -0.5), root ~ (1.556, -0.576) | script l.26; root 1.556097, -0.575651 | confirmed |
| 31 | l.85 | converges to lower-right solution | X7 = (1.5560974843220545, -0.5756507696188373) | confirmed |
| 32 | l.85 | `||F||` falls at every step from 7.3e-1 at X0 to ~3e-14 at X7 | 7.3154e-1, 1.0507e-1, 1.1090e-2, 5.2312e-5, 1.0562e-5, 1.9212e-7, 1.6032e-10, 2.9557e-14: monotone | confirmed |
| 33 | l.85 | factor only about 5 from X3 to X4 | 4.95 | confirmed |
| 34 | l.85 | > 1000 times in each of last two steps | 1198, 5424 | confirmed |
| 35 | l.85 | starting-point dependence: different guess, different root | A -> upper root, B -> lower-right root | confirmed |
| 36 | l.87, l.89 | link `broydenbb.jl`, embed `broydenbb.gif` are case B | script start (1.5,-0.5); regen byte-identical | confirmed |
| 37 | l.89 alt | only first step visible; falling every step 7.3e-1 to ~3e-14 in seven steps | 8 frames X0..X7; frames viewed | confirmed |
| 38 | frames | titles: "solution near (0.062, 0.724)/(1.556, -0.576)", "X_k = (...)" to 4 dp, `||F(X_k)||` values | instrumented copies printed every title; match independent values (e.g. B X_7 title 2.96e-14 vs 2.9557e-14) | confirmed |
| 39 | l.20 | link to Nonlinear Systems page | `../nonlinear-systems/index.qmd` exists | confirmed |

### 3. Implementation checks

Both scripts share one routine; only `(x0, y0)` and labels differ (`diff` of the two files).

**Method.** Standard ("good") Broyden: exact Jacobian at X0, one Newton step, then rank-1 update `B += (y - B s) s^T / (s^T s)` with `s = X_k - X_{k-1}`, `y = F(X_k) - F(X_{k-1})`, and a linear solve `B dX = -F`. This is the variant described in the page's Algorithm section and in Mathews' theorem (not the Sherman–Morrison inverse-update variant, which the page correctly says is not animated). Jacobian checked symbolically with sympy: `[[4x-4, -6y^2],[4x^3, 16y^3+4]]` = script l.21-22. Stopping: `||F|| < 1e-12` or `s^T s < 1e-20`, max 10 Broyden steps; actual stops at X6 (A) and X7 (B), same as Mathews' (tol 1e-10, 10 iterations).

**Numbers.** Instrumented copies (`review/broyden??_instr.jl`) vs independent Python float64 and 50-digit mpmath implementations (`review/indep.py`):

| Case A | Julia X_k | Python float64 | `||F||` Julia | Python |
|---|---|---|---|---|
| 1 | (0.0610386164432668, 0.7252588370082448) | identical | 7.7616e-3 | 7.7616e-3 |
| 3 | (0.0617705890624876, 0.7244911570414898) | identical | 7.4833e-6 | 7.4833e-6 |
| 6 | (0.0617701263386075, 0.7244905153472168) | identical | 1.3552e-15 | 1.3552e-15 (mp: 1.68e-15) |

| Case B | Julia X_k | Python float64 | `||F||` Julia | Python |
|---|---|---|---|---|
| 1 | (1.5631443298969072, -0.5824742268041238) | identical | 1.0507e-1 | 1.0507e-1 |
| 4 | (1.5560969549092851, -0.5756529705862952) | identical | 1.0562e-5 | 1.0562e-5 |
| 7 | (1.5560974843220545, -0.5756507696188373) | identical | 2.9557e-14 | 2.9557e-14 (mp: 3.17e-14) |

All intermediate iterates also agree to all printed digits, and with Mathews' printed Broyden output (gr_676, gr_682).

**Reference values.** Roots by sympy resultant (exact polynomial, `real_roots`) and 50-digit Newton refinement: (0.061770126338607374, 0.72449051534721662) and (1.5560974843220530, -0.57565076961884345), residual < 1e-49. Exactly two real solutions. Titles' "(0.062, 0.724)" and "(1.556, -0.576)" are correct 3-dp roundings.

**Picture.** Viewed both contact sheets and the final frames. Contours use Z1 = f1 (blue), Z2 = f2 (red) on the full window, both roots visible; iterate path and markers built from `iterates`; right panel plots `residuals[1:frame+1]` with the current one in red; y-limits 1e-16..1e1 contain all residuals (min 1.36e-15), so nothing is clamped. Title "(machine precision)" only appears when r < 1e-14 (A's X6 only), which is justified (exact-arithmetic X6 error 1.8e-16). Frame counts 7 and 8 = X0..X6 and X0..X7. Committed GIFs are byte-identical to fresh runs (manifest).

**Archive fidelity.** Same system as Mathews' Examples 5 and 8; same two starting points as Example 8's standard Broyden runs; Example 5's (lost) output tables gr_234 (405x257) and gr_239 (398x277) have exactly the pixel sizes of Example 8's standard-Broyden tables gr_673/676 and gr_679/682, which supports (but cannot prove) that Example 5 used the same starts. Both Example 5 cases present. Mathews colours f1 red and f2 blue; the page swaps them but states its own colours correctly.

