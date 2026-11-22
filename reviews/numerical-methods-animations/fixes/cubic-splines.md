# Fix record: cubic-splines

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/cubic-splines/fix/`

- `instr.jl`: cubicsplineaa.jl lines 1-51 (without Plots) plus dumps: per-frame max error on the script's 600-point grid, and asymptotic rates for sin on [0,2π] using the script's own `natural_spline_M` / `spline_eval_point` on 200001 points. Run `julia instr.jl`.
- `check.py`: independent check with sympy and scipy `CubicSpline` (natural, clamped with exact f', not-a-knot), max-error and middle-half error rates for six test functions, and the effective order between successive animation frames. Run `/usr/bin/python3 -I check.py`.
- `frames/`: extracted frames, contact sheet, frame md5s of the (unchanged) cubicsplineaa.gif.

## Findings

### F1 — Error — fixed
- Reproduced: `julia instr.jl` (script's own spline code, sin on [0,2π], 200001 points) → N = 8, 16, 32, 64, 128, 256 intervals: errors 1.0661e-3, 6.3121e-5, 3.8893e-6, 2.4221e-7, 1.5124e-8, 9.4506e-10, ratios 16.889, 16.229, 16.058, 16.014, 16.004 (rate 4.000). `check.py` (scipy natural) → max-error rates 2.0 (to two decimals, at N 32→512) for cos x on [0,2π], exp x on [0,2π] and [0,1], sin x on [0,π/2], 1/(1+x²) on [0,2]; their middle-half rates approach 4.0 (3.99-4.0 at N 256→512). sympy: sin''(0) = 0, sin''(2π) = 0. So the page's sentence "The natural cubic spline converges at O(h^4) for smooth functions" is false in general; it holds here because f'' vanishes at both ends. Checker's correction confirmed: O(h^2) is the global max error, located near an end with f'' ≠ 0 (e.g. cos: max at x = 0.0047; exp on [0,1]: x = 0.9993; sin on [0,π/2]: x = 1.5696, the end where f'' = -1, not x = 0 where f'' = 0), while the middle half stays O(h^4). Animation frames are pre-asymptotic: effective order log(e1/e2)/log(h1/h2) between successive frames is 5.47, 5.88, 3.60, 4.33, 4.66.
- Change: index.qmd Case 1 Behavior (line 31), "The natural cubic spline converges at $O(h^4)$ for smooth functions, where $h$ is the maximum node spacing." → "For this $f$ the natural end conditions are exact, since $\sin''(0)=\sin''(2\pi)=0$, so the spline converges at $O(h^4)$, where $h$ is the maximum node spacing; for a smooth $f$ with $f''(a)\neq 0$ or $f''(b)\neq 0$ the natural spline's maximum error falls only as $O(h^2)$. The 3 to 9 nodes shown are too few for this rate to show cleanly from frame to frame."
- Check: numbers above; see ledger.

### F2 — Misleading — fixed
- Reproduced: lines 15-19 define only the natural end conditions, then line 21 says "For smooth functions, spline interpolation error typically scales like $O(h^4)$". `check.py` → same functions: clamped (exact f') max-error rates 3.93-4.06 converging to 4.0, not-a-knot 3.7-4.97 converging to 4.0 (3.98-4.0 at N 256→512), natural 2.0 except sin on [0,2π] (4.0).
- Change: index.qmd Description (line 21), "For smooth functions, spline interpolation error typically scales like $O(h^4)$ with mesh spacing $h$." → "For smooth $f$ with clamped (exact $f'$ at the ends) or not-a-knot end conditions, the maximum error scales like $O(h^4)$ with mesh spacing $h$. With natural end conditions it is only $O(h^2)$ unless $f''(a)=f''(b)=0$; that error sits near an end where $f''\neq 0$, and away from the ends the error is still $O(h^4)$."
- Check: see ledger.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:21 | "clamped (exact f') or not-a-knot … maximum error scales like O(h^4)" | `check.py` → clamped last rates 4.0/4.0/4.0/3.99/4.0/4.0, not-a-knot last rates 4.0/4.0/3.98/4.0/4.0/4.0 for the six test functions (N 256→512) | yes |
| index.qmd:21 | "With natural end conditions it is only O(h^2) unless f''(a)=f''(b)=0" | `check.py` natural max-error rates 2.0 for cos [0,2π] (f'' = -1,-1), exp [0,2π] (1, 535), exp [0,1] (1, 2.72), sin [0,π/2] (0, -1: one zero end is not enough), 1/(1+x²) [0,2] (-2, 0.176); 4.0 for sin [0,2π] (0, 0) | yes |
| index.qmd:21 | "that error sits near an end where f'' ≠ 0" | `check.py` location of max error at N=512: cos x=0.0047; exp [0,2π] x=6.2785; exp [0,1] x=0.9993; sin [0,π/2] x=1.5696 (the f''=-1 end); 1/(1+x²) x=0.0015 (the f''=-2 end) | yes |
| index.qmd:21 | "away from the ends the error is still O(h^4)" | `check.py` natural middle-half rates at N 256→512: 4.0, 4.0, 3.99, 3.99, 4.0, 4.0 | yes |
| index.qmd:31 | "the natural end conditions are exact, since sin''(0)=sin''(2π)=0" | `check.py` sympy → `0 0` | yes |
| index.qmd:31 | "so the spline converges at O(h^4)" | `julia instr.jl` → ratios 16.889 … 16.004, rate 4.000 at N 128→256; scipy natural rates 4.02, 4.01, 4.0, 4.0, 4.0 | yes |
| index.qmd:31 | "for a smooth f with f''(a)≠0 or f''(b)≠0 the natural spline's maximum error falls only as O(h^2)" | as row 2 (includes the one-end case sin on [0,π/2], rate 2.0) | yes |
| index.qmd:31 | "The 3 to 9 nodes shown" | `n_node_list = [3, 4, 5, 6, 7, 9]` (cubicsplineaa.jl:51); frame titles 3, 4, 5, 6, 7, 9 nodes (frames/sheet.png) | yes |
| index.qmd:31 | "too few for this rate to show cleanly from frame to frame" | `check.py` effective order between successive frames 5.47, 5.88, 3.60, 4.33, 4.66 (vs 4.00 asymptotically) | yes |
| index.qmd:31 (unchanged) | "Adding nodes shrinks the maximum error rapidly" | `julia instr.jl` frame errors 1.000, 0.1088, 0.02002, 0.008965, 0.004071, 0.001066: strictly decreasing | yes |

## Scripts and GIFs
- Scripts changed: none. GIFs regenerated: none (text-only fix; the animation of sin on [0,2π] is correct).
- Frames viewed: contact sheet (6 frames) and frames 4 and 6 at full size; titles show 3, 4, 5, 6, 7, 9 nodes with max err 1.0, 0.109, 0.02, 0.00896, 0.00407, 0.00107, matching `instr.jl` (rounded to 3 significant figures).
- `git status --short -- pages/numerical-methods/cubic-splines`: `M pages/numerical-methods/cubic-splines/index.qmd` only.

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/CubicSplinesMod.html` and its four example links (text). Mathews defines the cubic spline, the natural ("free") and clamped splines, the minimum-curvature property of clamped splines, and gives three examples on small discrete point sets (natural, natural via SplineFit, clamped). It has no sin(x) convergence example and makes no convergence-order claim, so it did not bear on F1 or F2. The site's sin(x) node-refinement animation is an independent example; no fix was influenced by the archive.

## Notes
- Not a finding, not touched: the GIF title's closing ")" is clipped at the right edge in frames 4-6 (e.g. "max err ≈ 0.00896" then cut); the digits are all visible. The 5-node title shows "0.02" for 0.020017 (3 significant figures with trailing zeros dropped), which is not false. Cosmetic; left for Jason.
- Pre-existing: the Description says "mesh spacing h" and the Behavior paragraph says "maximum node spacing" for h; the nodes are equally spaced so both mean the same here. Left as is.

### Director note

Pre-existing Minor noted by the checker, not caused by the fix and not changed: in the GIF's last frame (9 nodes) the title '(max err ≈ 0.00107)' is clipped at the right edge, losing the closing parenthesis. The value shown is correct. Left for the round-2 review.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The false sentence ("The natural cubic spline converges at O(h^4) for smooth functions") is gone from index.qmd:31. It now says: for sin on [0,2π] the natural end conditions are exact because sin''(0)=sin''(2π)=0, so the order is O(h^4), and a smooth f with f''(a)≠0 or f''(b)≠0 gives only O(h^2).
- I checked this myself with `check/chk.py` (scipy CubicSpline, max error on 400001 points over [0,2π], nn = 17…513):
  - sin, natural: observed orders 4.02, 4.01, 4.00, 4.00, 4.00, so O(h^4).
  - cos, natural: 2.02, 2.01, 2.00, 2.00, 2.00. exp, natural: 1.98…2.00. 1/(1+(x−3)^2), natural: settles at 2.00. All are O(h^2).
- It also says the 3 to 9 nodes shown are too few for the rate to show cleanly. That is true. With the script's 600-point grid, the errors at nn = 3,4,5,6,7,9 are 1.0, 0.109, 0.0200, 0.00896, 0.00407, 0.00107. The local orders between frames are 5.47, 5.88, 3.60, 4.33, 4.66, so they are erratic.
- The script and GIF did not change and did not need to. The script is a correct natural spline: the tridiagonal system for the interior M has M[1]=M[end]=0, and its errors match scipy's natural spline.

### F2 — resolved
- index.qmd:21 now gives O(h^4) only for clamped (exact f') or not-a-knot end conditions, and O(h^2) for natural end conditions unless f''(a)=f''(b)=0.
- Measured: clamped orders reach 4.00 for sin, cos, exp and the Runge-type function. Not-a-knot reaches 4.00, 4.00, 3.98, 4.00. Natural reaches 2.00 whenever f''≠0 at an end.
- The added clause also holds: "that error sits near an end where f''≠0, and away from the ends the error is still O(h^4)".
  - For cos with 129 nodes, the max error is at x≈0.019, next to the left end.
  - The max error restricted to [1, 2π−1] converges at 4.01, 4.00, 4.00, 4.00 for cos and 3.95, 4.02, 3.97 for exp, once h is small. The end disturbance decays geometrically, by about (2−√3) per node.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:21 | "clamped (exact f′ at the ends) … maximum error scales like O(h^4)" | Clamped orders reach 4.00 for sin, cos, exp and the Runge-type function | True |
| index.qmd:21 | "or not-a-knot … O(h^4)" | Not-a-knot orders reach 4.00, 4.00, 3.98, 4.00 | True |
| index.qmd:21 | "With natural end conditions it is only O(h^2) unless f''(a)=f''(b)=0" | Natural: cos, exp and Runge-type give 2.00; sin (f''=0 at both ends) gives 4.00 | True |
| index.qmd:21 | "that error sits near an end where f''≠0" | argmax of the error is at x≈0.019 (cos) and x≈6.265 (exp, where f'' is larger at b) | True |
| index.qmd:21 | "away from the ends the error is still O(h^4)" | Interior [1, 2π−1] max error: orders 4.00 (cos) and about 4.0 (exp) | True |
| index.qmd:31 | "natural end conditions are exact, since sin''(0)=sin''(2π)=0" | sin''=−sin, which is 0 at 0 and at 2π | True |
| index.qmd:31 | "so the spline converges at O(h^4)" | Natural orders for sin: 4.02 → 4.00 | True |
| index.qmd:31 | "h is the maximum node spacing" | Nodes are equally spaced (`range(0,2π,length=nn)`) | True |
| index.qmd:31 | "f''(a)≠0 or f''(b)≠0 … falls only as O(h^2)" | cos, exp and Runge-type: 2.00 | True |
| index.qmd:31 | "The 3 to 9 nodes shown" | Script uses `n_node_list = [3,4,5,6,7,9]`, and the GIF titles show 3 and 9 | True |
| index.qmd:31 | "too few for this rate to show cleanly from frame to frame" | Local orders between frames: 5.47, 5.88, 3.60, 4.33, 4.66 | True |

### New problems
None introduced by the fix. This rests on:
- every changed sentence and number checked above;
- the script and GIF being unchanged (`git diff --quiet HEAD` is clean for both);
- the unchanged alt text still matching the frames.

One pre-existing issue, not raised in the original findings and not caused by the fix: **Minor**. In the last frame (9 nodes), the title "…(max err ≈ 0.00107)" is clipped at the right edge, so the closing parenthesis is cut off. The location is the `title=` line in cubicsplineaa.jl at size (700,500). The value itself is correct: I computed 0.00107.

### Reproducibility and conventions
- I ran cubicsplineaa.jl from a scratch copy. Its output is byte-identical to the committed cubicsplineaa.gif. The GIF has 6 frames, and I looked at frames 1, 3 and 6 at full size. They show the 3-node spline ≡ 0 with error 1.0, the 5-node spline with error 0.02, and the 9-node spline with error 0.00107. The labels are legible apart from the clipped parenthesis noted above.
- Conventions are kept:
  - Description comes before Animations.
  - There is one source link, `[Julia source](cubicsplineaa.jl)`, and one GIF embed with descriptive alt text.
  - There are no code blocks.
- In the page folder, only index.qmd changed. The working tree also has modifications under other pages' folders and untracked notes in reviews/numerical-methods-animations/fixes/ (including cubic-splines.md). These belong to the wider fix run and are not part of this page's diff. Nothing outside the page folder is attributable to this page's fix.

**Final status:** committed
