# Fix record: broydens-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/broydens-method/fix/` (below: `$S`). Python is `/usr/bin/python3`. Pre-fix copies of the page's files are in `$S/committed/`.

## Findings

### F1 — Misleading — fixed
- **Reproduced.**
  - Pixel diffs of consecutive committed frames (`$S/committed/<gif>/frame_*.png`, PIL inline script). In Case A, frames 5→6 and 6→7 change 55 and 53 px, all inside bbox (437–444, 56–66), which is the legend's `X_k` index digit. In Case B, frames 6→7 and 7→8 change 53 and 59 px in the same bbox. So the last frames of each GIF are frozen apart from the index digit.
  - Legend saturation, from `$S/old_sys.py` (independent numpy Broyden on the old system, rounded to 4 decimals):
    - Case A reads (-0.0881, 0.8271) for X_3 to X_6.
    - Case B reads (2.8085, -1.6645) for X_4 to X_7.
    - The early Broyden steps do change the digits, as the independent check's correction says (A: X_1 to X_3; B: X_1 to X_4).
  - No error or residual was shown anywhere in the GIF.
- **Change.** I chose the review's option (a). F2 (below) moves the cases to Mathews' starting points. Those points are so close to the roots that even the first step moves only 5 px (A) or 13 px (B), so a picture-only fix could not show the Broyden steps.
  - Both scripts now draw two panels. Left: the zero curves and the iterate path; the panel title is `X_k = (x, y)` with `%.4f`. Right: ‖F(X_k)‖ on a log10 axis (1e-16 to 1e1) against k, with the title `||F(X_k)|| = %.2e`.
  - The overall title is `plot_title`. `using Printf` was added (standard library). The size went from 600×500 to 1000×480. The legend is removed, because its contour labels never rendered.
  - index.qmd, Animations paragraph (old l.68):
    - Before: "Each frame adds … so the path toward the root is visible."
    - After: the left panel adds each iterate; after the first (Newton) step the iterates are too close to the root to separate at this scale; the right panel plots ‖F(X^(k))‖ on a log scale, "which is where the Broyden steps show".
  - Case A Behavior and both alt texts rewritten with computed ‖F‖ values. They no longer claim that the motion shows the rate.
- **Check.**
  - New-frame pixel diffs of the left plot area (`$S/pixdiff.py`, crop 70–490 × 50–430):
    - Case A changes 220/77/32 px for frames 1→2/2→3/3→4, all in the marker bbox, then 0 px for 4→5, 5→6 and 6→7.
    - Case B changes 343/123/67/13/6 px, then 0, 0.
    - Step lengths at the measured scale (102.25 px/unit in x from frame-box columns 76–485, 137.5 px/unit in y from rows 50–428) are A: 5.30, 0.13, 0.00, … px and B: 13.04, 1.28, 0.10, 0.00, … px (`$S/cmp_mathews_jl2.py`).
    - So "only the first step large enough to see" and "too close to the root to separate" hold.
  - The right panel changes every frame. Frames viewed: A 1, 4, 7; B 2, 8. Each title reads the value printed by the instrumented copy (table below).

### F2 — Minor — fixed (R2-A: follow Mathews)
- **Reproduced.**
  - The archive module `BroydenMethodMod.html` was stripped to text. Images upscaled 4× with `$S/up.jl`, which runs the ffmpeg bundled with Plots.
  - `gr_14` (Ex 1), `gr_89` (Ex 3), `gr_213` (Ex 5) and `gr_660` (Ex 8) all show f1 = 1 − 4x + 2x² − 2y³, f2 = −4 + x⁴ + 4y + 4y⁴. The Example 8 solution output images `gr_673`/`gr_676`/`gr_679`/`gr_682` print F[{x,y}] with the same formula, so the formula is confirmed in solution code as well as in the statement.
  - The page used a different system (2y², x², y²). Confirmed.
  - Of Example 5's (lnk_7) 29 images, only `gr_213` is present.
  - Example 8 (lnk_12) is complete. Its solution starts from (0.1, 0.7) (`gr_671`, `gr_674`) and (1.5, −0.5) (`gr_677`, `gr_680`). It runs both `ImprovedBroyden` and the standard `Broyden[P0, 10^-10, 10]` (`gr_675`) and prints the iterates: `gr_676` from (0.1, 0.7), P1..P6; `gr_682` from (1.5, −0.5), P1..P7.
- **Change.** R2-A puts the function and the starting point under "follow Mathews". Following Mathews does not contradict any confirmed round-1 fix: round-1 F1 and F2 corrected numbers of the old system, and those numbers are replaced wholesale here.
  - Both scripts use Mathews' system and the exact Jacobian [−4+4x, −6y²; 4x³, 4+16y³].
  - The starting points are Mathews' Example 8 standard-Broyden starts: A (0.1, 0.7), B (1.5, −0.5).
  - The window is x∈[−1.75, 2.25], y∈[−1.5, 1.25], close to Mathews' graph `gr_669` (x≈[−1.6, 2], y≈[−1.25, 1]).
  - GIF titles changed to "solution near (0.062, 0.724)" and "(1.556, −0.576)".
  - index.qmd changes: the system formula, the solution-count sentence, both case headings and both Behavior paragraphs. A two-sentence source note was added after the last embed: the R2-A note on missing images and starting points, and the one-sentence note on left-out examples.
- **Check.**
  - The Jacobian equals the sympy Jacobian (`$S/realcount.py`).
  - The Julia iterates agree with Mathews' printed iterates to ≤ 6.0e-16 (A) and ≤ 1.0e-15 (B), with the same number of iterates: 6 and 7 (`$S/cmp_mathews_jl2.py`, Mathews' digits transcribed from `gr_676`/`gr_682`).
  - Julia agrees with an independent numpy implementation (`$S/indep.py`) to ≤ 4.6e-16 (`$S/cmp_jl_py.py`).

## Ledger of changed text

Instrumented copies `$S/instr_aa.jl` and `$S/instr_bb.jl` (the script truncated before plotting, printing iterates and labels) produced the following output:

| k | Case A X_k | ‖F‖ | Case B X_k | ‖F‖ |
|---|---|---|---|---|
| 0 | (0.100000000000000, 0.700000000000000) | 2.484276e-01 | (1.500000000000000, −0.500000000000000) | 7.315437e-01 |
| 1 | (0.061038616443267, 0.725258837008245) | 7.761601e-03 | (1.563144329896907, −0.582474226804124) | 1.050659e-01 |
| 2 | (0.061779159834426, 0.724459783671636) | 3.162050e-04 | (1.555352036863449, −0.575188105942452) | 1.109040e-02 |
| 3 | (0.061770589062488, 0.724491157041490) | 7.483279e-06 | (1.556095422856546, −0.575627127115621) | 5.231154e-05 |
| 4 | (0.061770109194288, 0.724490490187661) | 2.915405e-07 | (1.556096954909285, −0.575652970586295) | 1.056153e-05 |
| 5 | (0.061770126325456, 0.724490515327927) | 2.235353e-10 | (1.556097494140761, −0.575650731326978) | 1.921160e-07 |
| 6 | (0.061770126338607, 0.724490515347217) | 1.355200e-15 | (1.556097484313824, −0.575650769650469) | 1.603242e-10 |
| 7 | — | — | (1.556097484322055, −0.575650769618837) | 2.955723e-14 |

Reduction factors ‖F_k‖/‖F_{k+1}‖ (`$S/cmp_mathews_jl2.py`):
- A: 32, 24.5, 42.3, 25.7, 1.3e3, 1.65e5. Monotone decrease: True.
- B: 6.96, 9.47, 212, 4.95, 55, 1.2e3, 5.42e3. Monotone decrease: True.

Step lengths:
- A: 0.0464, 0.00109, 3.25e-5, …
- B: 0.104, 0.0107, 8.63e-4, …

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| l.66 system | f1 = 1 − 4x + 2x² − 2y³, f2 = −4 + x⁴ + 4y + 4y⁴ | Archive images gr_14/89/213/660 and solution outputs gr_673/676; scripts' `F` | yes |
| l.68 | "exactly two real solutions" | `$S/realcount.py`, `$S/realcount2.py`: `sympy.real_roots` of the resultant in y (deg 12) gives exactly 2 real roots. For each, the two x roots of f1 (quadratic) give f2 = −5.8 / ~1e-15 and ~1e-21 / 14.1, so exactly one real solution per y | yes |
| l.68 | near (0.062, 0.724) and (1.556, −0.576) | mpmath findroot (`$S/roots.py`): (0.061770126338607, 0.724490515347217), (1.556097484322053, −0.575650769618843) | yes |
| l.68 | both inside the plotted window | window x∈[−1.75, 2.25], y∈[−1.5, 1.25] (script) | yes |
| l.68 | left panel adds each iterate, joined by a line; after the first (Newton) step the iterates are too close to the root to separate at this scale | Script draws `iterates[1:frame+1]` with a line. Step px A 5.30 then ≤0.13; B 13.04 then ≤1.28. Left-panel pixel diff 0 px for the last 3 (A) / 2 (B) transitions; earlier changes are confined to the marker bbox | yes |
| l.68 | right panel plots ‖F(X^(k))‖ on a log scale, where the Broyden steps show | Script `p2`, `yscale=:log10`. Frames A1/4/7 and B2/8 viewed: one new point per frame | yes |
| l.72 Case A heading | X0 = (0.1, 0.7), root ≈ (0.062, 0.724) | Script `x0, y0 = 0.1, 0.7`; final iterate (0.0617701263386, 0.7244905153472) | yes |
| l.74 | "close to the upper intersection" | Start is 0.0454 from root A (`$S/mathews_cmp.py` err at k=0), and root A has larger y than root B | yes |
| l.74 | Newton step "moves the iterate by about 0.05" | step length 0.0464 | yes |
| l.74 | ‖F‖ from 2.5×10⁻¹ to 7.8×10⁻³ | 2.484276e-01, 7.761601e-03 | yes |
| l.74 | rank-1 update, no new derivative evaluations | Script `Jac` is called only at step 0; update `B + (y − Bs)sᵀ/(sᵀs)` | yes |
| l.74 | ‖F‖ down to 1.4×10⁻¹⁵ at X^(6) | 1.355200e-15 at k = 6 (last iterate) | yes |
| l.74 | from X^(0) to X^(4), between 24 and 43 times per step | factors 32, 24.5, 42.3, 25.7 | yes |
| l.74 | over each of the last two steps more than 1000 times | 1.3e3, 1.65e5 | yes |
| l.74 | "consistent with the superlinear convergence described above" | The factors rise from ≤43 to >1000. Error ratios e_{k+1}/e_k against the 40-digit root are 0.0234, 0.0302, 0.0247, 0.0385, 7.7e-4, 5.9e-6 (`$S/mathews_cmp.py`). Described as "consistent with", not as proof | yes |
| l.78 alt A | start (0.1, 0.7); root near (0.062, 0.724); only the first step large enough to see | as above (5.30 px, then ≤0.13 px) | yes |
| l.78 alt A | ‖F‖ on a log scale falling from 2.5e-1 to 1.4e-15 in six steps | k = 0…6, values above | yes |
| l.80 Case B heading | X0 = (1.5, −0.5), root ≈ (1.556, −0.576) | Script `x0, y0 = 1.5, -0.5`; final iterate (1.556097484322, −0.575650769619) | yes |
| l.82 | "close to the lower-right intersection … converges to that lower-right solution" | Start 0.0942 from root B; root B has larger x and smaller y than root A; final err 6.3e-15 | yes |
| l.82 | ‖F‖ falls at every step, 7.3×10⁻¹ at X^(0) to 3.0×10⁻¹⁴ at X^(7) | monotone True; 7.315437e-01, 2.955723e-14 | yes |
| l.82 | "by a factor of only about 5 from X^(3) to X^(4)" | 5.231154e-05 / 1.056153e-05 = 4.95 | yes |
| l.82 | "more than 1000 times in each of the last two steps" | 1.2e3 (1198), 5.42e3 | yes |
| l.82 | starting-point dependent; different start finds different root (unchanged sentence) | A → root A, B → root B | yes |
| l.86 alt B | start (1.5, −0.5); root near (1.556, −0.576); only the first step large enough to see; falls at every step from 7.3e-1 to 3.0e-14 in seven steps | step px 13.04 then ≤1.28; k = 0…7; monotone True | yes |
| l.88 source note | Example 5 poses this system for Broyden's method | lnk_7 text "Use the Broyden's method to solve the nonlinear system" + gr_213 | yes |
| l.88 | archived copy missing the starting-point, result and graph images | lnk_7 references gr_213–gr_241; only gr_213 exists in `Images/` (`ls` loop) | yes |
| l.88 | starting points are those of the standard Broyden runs in Example 8, whose printed iterates these animations reproduce | gr_675 `Broyden[P0={0.1,0.7}, 10^-10, 10]`; gr_676 / gr_682 "The Broyden's solution" from (0.1, 0.7) and (1.5, −0.5). Julia vs Mathews ≤ 6.0e-16 / 1.0e-15, same iterate counts 6 / 7 | yes |
| l.89 left-out note | Newton's-method and pseudo-Newton examples (Examples 1 and 3) | Module text: "Example 1. Use Newton's method …", "Example 3. Use the Pseudo-Newton's method …" | yes |
| l.89 | improved Broyden method based on the Sherman–Morrison formula (Example 8) | Module text: "Example 8. Use the improved Broyden's method …"; the n-dimensional theorem's Step 3 is "using the Sherman-Morrison formula" | yes |
| l.89 | exercises in three and four dimensions | Module text: Exercises 2, 4, 6, 9 "in 3D space"; 7, 10 "in 4D space" | yes |
| l.89 | "are not animated here" | The page has only cases A, B (Broyden on the 2D system) | yes |
| GIF titles | "Broyden's Method: solution near (0.062, 0.724)" / "(1.556, -0.576)" | roots above rounded to 3 dp | yes |
| GIF panel titles | `X_k = (%.4f, %.4f)`, `||F(X_k)|| = %.2e` | Instrumented output, e.g. A k=3 "X_3 = (0.0618, 0.7245) ‖F(X_3)‖ = 7.48e-06" and B k=7 "(1.5561, -0.5757) 2.96e-14"; the same strings were read in the viewed frames | yes |
| Script comments | "upper solution near (0.062, 0.724)", "lower-right solution near (1.556, -0.576)", system, "Starting point … as in Mathews' Example 8 comparison run" | as above | yes |

## Scripts and GIFs
- **Scripts changed.** `broydenaa.jl` was rewritten as described. `broydenbb.jl` was generated from it with `sed`. `diff` shows the two differ only in header comments, `x0, y0`, `title_str` and the output name.
- **GIFs regenerated in place** with `julia broydenaa.jl` and `julia broydenbb.jl`. A has 7 frames and B has 8, both 1000×480. Frames were extracted with `giftools.jl` to `$S/new/<gif>/`.
- **Frames viewed at full size.** A frames 1, 4 and 7; B frames 2 and 8. In each I checked:
  - the blue f1 = 0 curve (open, y = ∛((1−4x+2x²)/2)) and the red closed f2 = 0 curve match Mathews' graph gr_669, with the colours swapped;
  - the start, path and red current marker sit at the root intersections;
  - the panel titles show the correct k and values;
  - the log panel adds one point per frame and ends at 1.36e-15 (A) or 2.96e-14 (B);
  - no clipping. The overall title sits above both subplot titles without overlap.
- **`git status --short -- pages/numerical-methods/broydens-method`:** `M broydenaa.gif`, `M broydenaa.jl`, `M broydenbb.gif`, `M broydenbb.jl`, `M index.qmd`. Nothing else.

## Legacy archive
Consulted: `n2003/BroydenMethodMod.html` and `broydenmethod/BroydenMethodMod/{Links,Images}`. There is no Broyden GIF under `a2001/Animations/`.
- **The system.** Examples 1, 3, 5 and 8 all use f1 = 1 − 4x + 2x² − 2y³, f2 = −4 + x⁴ + 4y + 4y⁴. The page now uses this system.
- **Example 5's solution images.** All are missing except the system image, so Example 5's own starting points are unknown.
- **Example 8.** It is complete. It runs the standard Broyden method (as well as the improved one) from (0.1, 0.7) and (1.5, −0.5) and prints the iterates. The page uses those starts, and the scripts reproduce the printed iterates to ≤1e-15.
- **Mathews' graph gr_669.** It draws f1 = 0 in red and f2 = 0 in blue. The page keeps its own colours (f1 blue, f2 red), and the text states them.
- **Starting points and the picture.** With Mathews' starting points, the left panel barely moves: 5 px (A) and 13 px (B) for the first step. That is why the F1 fix adds the residual panel instead of relying on the path.

## Notes
- **R2-A on F2.** It names the function and the starting point as "parameters" to follow. I applied it, so the whole example changed rather than a one-sentence note being added. Jason may want to know that this replaces the round-1-corrected numbers of the old system: the four-root sentence and the Case B root (2.808, −1.664).
- **F1 option (a).** This added a second panel, which is more drawing code than the "smallest change" lesson prefers for Minor findings. F1 is Misleading, and with Mathews' starting points the text-only alternative would have left an animation with almost no visible content.
- **Stopping rule.** The scripts' rule (‖F‖ < 1e-12) differs from Mathews' (`Broyden[P0, 10^-10, 10]`), but both stop after the same number of iterates here (6 and 7).
- **Not touched.** The Nonlinear Systems page may still use the page's former system; I did not check or touch it. The Description section (unchanged) still describes the pseudo-Newton cost and the general convergence statements, which the review confirmed.
- **Not rendered.** The page was not rendered with Quarto (left to the director's full-section render). The only new markup is inline `$\|\mathbf{F}\|$`, `\times10^{-k}` and plain Markdown.

## Resolution check (independent checker, not shown this record)

Scratch evidence: `check/indep.py`, `check/roots2.py` (independent Python), `check/run/` (scratch copies of both scripts plus `*_num.jl` printers), `check/frames/<gif>/` (all frames, contact sheets, md5), `check/arch/` (upscaled archive images gr_213, gr_660–682).

### Original findings

### F1 — resolved
- The page no longer claims the plot shows the Broyden path. Line 68 now says "after the first (Newton) step the iterates are too close to the root to separate at this scale", and the alt texts say "with only the first step large enough to see". Superlinear convergence is now shown in a new right-hand panel that plots ‖F(X_k)‖ on a log axis, so the alt texts' convergence claims are things the frames actually show.
- Script: `residuals = [norm(F(p...))]` is the 2-norm of F at each iterate. It is plotted on log10 axes with fixed limits 1e-16..1e1, and the current value is in the panel title (`%.2e`). I printed the Julia values from scratch copies: Case A 2.4843e-1, 7.7616e-3, 3.1620e-4, 7.4833e-6, 2.9154e-7, 2.2354e-10, 1.3552e-15. Case B 7.3154e-1, 1.0507e-1, 1.1090e-2, 5.2312e-5, 1.0562e-5, 1.9212e-7, 1.6032e-10, 2.9557e-14. These match my independent numpy Broyden run to every printed digit.
- Frames (viewed at full size 1000×480: frames 1, 2, 4 and 7 of A; frames 1, 5 and 8 of B): the right-panel titles read 2.48e-01 → 1.36e-15 (A) and 7.32e-01 → 2.96e-14 (B). The markers sit at those values on the log axis. B shows the visible kink at k=3→4. Every frame is different: framemd5 gives 7 of 7 unique in A and 8 of 8 in B, so nothing is frozen any more. The left-panel title coordinates (4 decimals) still stop changing after X_3 (A) and X_4 (B), but nothing on the page now claims they change.
- Visibility of the first step: in Case B, X0→X1 is 0.104 units (about 10 px) and clearly visible. In Case A it is 0.046 units (about 4–5 px). Zoomed (`frames/zoom_broydenaa.png`), the red marker visibly jumps, and the blue X0 marker shows as a sliver behind it. So "only the first step large enough to see" is true, though only just for A. The second steps are 1.1e-3 (A) and 1.07e-2 (B) units, about 0.1 and 1 px, so "too close to separate" is right.

### F2 — resolved
- The system is now Mathews' system: f1 = 1 − 4x + 2x² − 2y³, f2 = −4 + x⁴ + 4y + 4y⁴. I checked the archive images gr_213 (Example 5) and gr_660 (Example 8), both upscaled, and they show exactly this system. The script `F` and the formula on the page match it. The Jacobian is correct: [−4+4x, −6y²; 4x³, 4+16y³].
- The starting points (0.1, 0.7) and (1.5, −0.5) are Mathews' Example 8 "Compare with the standard Broyden's method" runs (gr_674/675 and gr_680/681: `Broyden[P0, 10^-10, 10]`). The printed iterates in gr_676 and gr_682 match the script's and my independent iterates to all 16 printed digits. The only differences are 1 ulp in the last digit of P2.y and P7.y for B, a matter of print representation. The final residual norms are Mathews' F[P] = (−7.77e-16, 1.11e-15), norm 1.355e-15, and (−8.49e-15, 2.83e-14), norm 2.956e-14. Both are equal to the page's.
- The required note is present (last paragraph). Example 5's archived solution is missing gr_214–gr_241, which include the "near" points gr_224 and gr_237; the Images folder jumps from 213 to 242. This follows R2-A ("follow Mathews" for function and starting point; one sentence for what is left out).

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.66 formula | f1 = 1−4x+2x²−2y³, f2 = −4+x⁴+4y+4y⁴ | archive gr_213, gr_660; script F | correct |
| l.68 | "exactly two real solutions" | sympy resultants in x and in y (deg 12) each have exactly 2 real roots; back-substitution gives exactly 2 real pairs | correct |
| l.68 | near (0.062, 0.724) and (1.556, −0.576) | 40-digit: (0.0617701263386, 0.7244905153472), (1.5560974843221, −0.5756507696188) | correct |
| l.68 | "both lie inside the plotted window" | window x∈[−1.75, 2.25], y∈[−1.5, 1.25] | correct |
| l.68 | left panel adds iterates joined by a line; after the Newton step they are too close to separate; right panel shows ‖F‖ on a log scale | script; frames; step sizes 1.1e-3/1.07e-2 units ≈ 0.1/1 px | correct |
| Case A heading | X0 = (0.1, 0.7), root ≈ (0.062, 0.724) | as above; Mathews gr_674 | correct |
| Case A | Newton step "moves the iterate by about 0.05" | ‖X1−X0‖ = 0.0464 | correct (1 s.f.) |
| Case A | ‖F‖ 2.5e-1 → 7.8e-3 | 2.484e-1, 7.762e-3 | correct |
| Case A | 1.4e-15 at X6 | 1.355e-15 (Julia, numpy, Mathews) | correct |
| Case A | X0→X4 shrinks "between 24 and 43 times per step" | ratios 32.0, 24.6, 42.3, 25.7 | correct |
| Case A | last two steps "more than 1000 times" | 1304, 1.65e5 | correct |
| Case A | "consistent with superlinear" | error ratios e_{k+1}/e_k: 0.023, 0.030, 0.025, 0.039, 7.7e-4, (5.9e-6, roundoff-limited); falls toward 0 | acceptable |
| Case A alt | starts at (0.1, 0.7); root near (0.062, 0.724); only first step visible; 2.5e-1 → 1.4e-15 in six steps | above; 6 steps X0→X6 | correct |
| Case B heading | X0 = (1.5, −0.5), root ≈ (1.556, −0.576) | above; Mathews gr_680 | correct |
| Case B | ‖F‖ falls at every step, 7.3e-1 → 3.0e-14 at X7 | 7.315e-1 … 2.956e-14, monotone | correct |
| Case B | "factor of only about 5 from X3 to X4" | 4.95 | correct |
| Case B | "then by more than 1000 times in each of the last two steps" | X5→X6 1198, X6→X7 5424 (X4→X5 is 55; "then" skips it, but the claim is about the last two steps) | correct |
| Case B alt | 7.3e-1 → 3.0e-14 in seven steps; only first step visible | 7 steps; frames | correct |
| closing para 1 | Example 5 poses this system; archived copy missing start/result/graph images; starts from Example 8 standard-Broyden runs, whose iterates are reproduced | lnk_7 references gr_214–241, absent from Images; lnk_12 + gr_674–682; iterates match to 16 digits | correct |
| closing para 2 | Examples 1, 3, 8 (Sherman–Morrison), 3D/4D exercises not animated | BroydenMethodMod.html: Ex 1 Newton, Ex 3 pseudo-Newton, Ex 8 improved Broyden (Sherman–Morrison), Ex 2/4/6/9 3D, Ex 7/10 4D | correct |
| scripts header | system, start points "as in Mathews' Example 8 comparison run", panel description | as above | correct |
| GIF A title / panels | "solution near (0.062, 0.724)"; "X_k = (…)" 4 d.p.; "‖F(X_k)‖ = %.2e" | frames vs computed values | correct |
| GIF B title / panels | "solution near (1.556, −0.576)"; same labels | frames vs computed values | correct |

### New problems
None. This rests on: the independent root count and iterates (Python/sympy and numpy), an exact match with Mathews' printed Example 8 runs, full-size inspection of the first, middle and last frames of both GIFs, and the byte-identical regeneration.

Observations, not defects:
- (a) In Case A the visible first step is only about 4–5 px, mostly hidden under the 7-pt marker.
- (b) Mathews draws f1 in red and f2 in blue (`PlotStyle -> {Red, Blue}`, gr_668/669). The page uses the opposite colours, but it states its own colours and the frames agree with them: blue is the open curve f1, red is the closed curve f2.

### Reproducibility and conventions
- I ran both scripts from scratch copies (`check/run/`). The SHA-256 of each output is identical to the committed GIF: aa 96124750…6a28, bb 8611dc18…54bd6. Both are 1000×480; A has 7 frames, B has 8.
- Conventions: Description comes before Animations. Each case has a source link and a GIF embed. The alt texts are descriptive. There are no code blocks (0 ``` fences). The missing-archive note is present.
- Files outside the page folder: the only other entry attributable to this page is the untracked fix record `reviews/numerical-methods-animations-r2/fixes/broydens-method.md`, which is expected; I did not read it. The section index line `pages/numerical-methods/index.qmd:27` is a bare link and is unaffected.

**Final status:** committed
