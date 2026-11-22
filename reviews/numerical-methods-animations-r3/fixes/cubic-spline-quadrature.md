# Fix record: cubic-spline-quadrature

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/cubic-spline-quadrature/fix/`
- `supgap.py`: independent SciPy natural `CubicSpline` on [0,2], 400 001 points, sup gap, its location, L1 gap and integral for m = 3, 5, ..., 41.
- `inst.jl`: instrumented copy of the script's own routines (`natural_spline_M`, `spline_eval`, `spline_integral`, lines 8-67 of `splinequadaa.jl`) with the animation loop replaced by the same measurements, plus the gap at the peak of f.
- `l1quad.py`: L1 gap by adaptive `scipy.integrate.quad` over 400 subintervals (cross-check of the grid L1).
- `frames/`: frames of the committed GIF.

## Findings

### F-1 — Minor — fixed
- **Reproduced:** yes. `/usr/bin/python3 -I supgap.py` and `julia inst.jl` agree to 4 digits on every row:

  | m | sup gap | at x | f there | S there | L1 gap |
  |---|---|---|---|---|---|
  | 3 | 0.8773 | 0.0768 | 1.9188 | 1.0415 | 0.7100 |
  | 5 | 1.1108 | 0.0965 | 1.9023 | 0.7915 | 0.3767 |
  | 7 | 1.0899 | 0.0945 | 1.9063 | 0.8164 | 0.2922 |
  | 9 | 0.8605 | 0.0765 | 1.9186 | 1.0582 | 0.1835 |
  | 11 | 0.6736 | 0.0616 | 1.8917 | 1.2180 | 0.1143 |
  | 21 | 0.3048 | 0.0284 | 1.6584 | 1.3536 | 0.0247 |
  | 41 | 0.1569 | 0.0129 | 1.4195 | 1.2626 | 0.0061 |

  Step-by-step flags from `supgap.py`: L1 decreases at all 19 steps; the sup gap rises only at m = 3 → 5 (`supdec=False`) and decreases at every step from m = 5 → 7 onward. Max of f on the grid is 1.91976 at x = 0.080385. `l1quad.py` gives L1 = 0.70999 (m=3), 0.3767 (m=5), 0.29221 (m=7), 0.00614 (m=41), confirming the grid values. Frames 2 (m=3) and 3 (m=5) of the committed GIF viewed: at m=5 the red spline dips to about 1.0 at x=0 and runs under the magenta peak much lower than the m=3 arch, as the numbers say.
- **One correction to the reviewer's suggested wording:** "It [the peak] is the last feature to be resolved" is false. `inst.jl` prints the gap at the peak x = 0.080385: 0.876, 1.094, 1.077 (m=3,5,7), then 0.0113 at m=25 and 0.0241 at m=41. The sup location moves left from m=11 on (x = 0.062, 0.051, ... 0.013), so from roughly m=13 on the largest gap is on the steep rise from x=0 (where f′ is unbounded), not at the peak. I did not use that sentence. The reviewer's "share of [0,2] where gap > 0.5" column is double mine (47.2% vs 23.6% at m=3), apparently a length not divided by the interval length of 2; that column is not used on the page.
- **Change:** `index.qmd` line 32, Case 1 Behavior. Before: "The filled spline area tracks the curve more tightly as $m$ increases." After: "The filled spline area tracks the curve more tightly as $m$ increases: the area between spline and curve shrinks at every step, from 0.71 at $m=3$ to 0.0061 at $m=41$. The largest pointwise gap does not shrink at first: it sits under the narrow peak near $x\approx0.08$, which the spline undershoots by more at $m=5$ (1.11) and $m=7$ (1.09) than at $m=3$ (0.88). From $m=5$ on it falls at every step, to 0.16 at $m=41$." Description line 20 left as is (general statement; the review says it needs no change on its own account). Script and GIF unchanged (D7: the animation is right, the text was incomplete).
- **Check:** every number in the new text is in the ledger below, against `supgap.py` / `inst.jl` output.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 1 Behavior | "area between spline and curve shrinks at every step" | `supgap.py` → `L1dec=True` on all 19 steps m=3→5 … 39→41; `inst.jl` same L1 column | yes |
| Case 1 Behavior | 0.71 at m=3 | `supgap.py` L1=0.7100; `l1quad.py` 0.70999 | yes |
| Case 1 Behavior | 0.0061 at m=41 | `supgap.py` L1=0.0061; `inst.jl` 0.0061; `l1quad.py` 0.00614 | yes |
| Case 1 Behavior | "largest pointwise gap does not shrink at first" | `supgap.py` sup 0.8773 (m=3) → 1.1108 (m=5), `supdec=False` | yes |
| Case 1 Behavior | "sits under the narrow peak near x≈0.08" (at first) | sup location x = 0.0768, 0.0965, 0.0945 (m=3,5,7), f there 1.92/1.90/1.91; f max 1.91976 at x = 0.0804 | yes |
| Case 1 Behavior | "undershoots" | S at sup point 1.0415 / 0.7915 / 0.8164 < f 1.9188 / 1.9023 / 1.9063 (m=3,5,7) | yes |
| Case 1 Behavior | 1.11 at m=5, 1.09 at m=7, 0.88 at m=3 | sup = 1.1108, 1.0899, 0.8773 (both scripts) | yes |
| Case 1 Behavior | "From m=5 on it falls at every step" | `supgap.py` `supdec=True` for every step from 5→7 through 39→41 | yes |
| Case 1 Behavior | 0.16 at m=41 | sup = 0.1569 (both scripts) | yes |

No heading, alt text, GIF title or label changed. The alt text ("each frame increases sample points, rebuilds the spline, and updates the integral estimate") remains accurate.

## Scripts and GIFs
- No script changed; no GIF regenerated. Committed GIF frames extracted with `giftools.jl` (21 frames); frames 2 and 3 viewed to confirm the m=3 → m=5 peak undershoot the text now describes.
- `git status --short -- pages/numerical-methods/cubic-spline-quadrature` after the fix: ` M pages/numerical-methods/cubic-spline-quadrature/index.qmd` only.

## Legacy archive
Consulted. `n2003/SplineQuadMod.html` (text stripped) lists Examples 1–5 (integrals with given node counts or tolerances, static solutions) and Example 6, the "Scenarios and Animations" example, whose animation is `a2001/Animations/Quadrature/Spline/Splineaa.gif` ("Natural Cubic Spline for Numerical Quadrature"). The round-3 review established that the page reproduces Example 6 (same f, interval, m = 3..41, natural end conditions, same approximation values); I did not repeat that comparison since no finding concerns it. The archive has no statement about pointwise error that bears on F-1.

## Notes
- R3-D lists "Cubic Splines", which is a different page (`cubic-splines`); this page has no "not animated here" sentence and none was added, as the round-3 review raised no fidelity finding. Examples 1–5 of the Mathews module are not animated here and the page does not mention them; if R2-A's "add one sentence when a whole Mathews example is left out" is meant to apply to static examples too, that would be a separate decision for Jason.
- Pre-existing: the page states no convergence rate. The review's note N2 (integral error about O(h²) from m=21 to 41 because of the x^{2/3} term) is not a finding and was not acted on.

## Resolution check (independent checker, not shown this record)

### Original findings
### F-1 — resolved
- The unqualified Case 1 Behavior claim now says which measure shrinks at every step (the area between spline and curve) and that the largest pointwise gap does not shrink at first.
- Independent computation in `check/gap.py`: my own natural-spline solve (full tridiagonal system), cross-checked against SciPy `CubicSpline(bc_type='natural')` to 1e-12 on 400 001 points. The sup is refined by bounded maximisation, and the L1 norm by `quad` split at the knots and at the sign changes of S-f.
  - L1 gap: 0.709995 (m=3), 0.376697, 0.292206, 0.183535, ..., 0.006145 (m=41). It falls at all 19 steps.
  - Sup gap: 0.87730 at x=0.0768 (m=3), 1.11084 at x=0.0965 (m=5), 1.08995 at x=0.0945 (m=7), 0.86046 (m=9), ..., 0.15688 at x=0.0129 (m=41). It rises only from m=3 to m=5 and falls at every step after that.
  - At m=3, 5 and 7 the spline is below f at the sup location (S=1.04, 0.79, 0.82 against f≈1.92, 1.90, 1.91), so it undershoots. The peak of f is at x=0.0804 (f=1.9198).
- Frames: frame_002 (m=3) and frame_003 (m=5) show the spline lower under the magenta peak at m=5 than at m=3, as the text says. frame_021 (m=41) shows near-coincidence.
- The Description sentence (line 20) is unchanged. The finding said it needs no change.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 1 Behavior | "area between spline and curve shrinks at every step" | L1 falls at all 19 steps from m=3 to m=41 | correct |
| same | "0.71 at m=3" | 0.709995 | correct |
| same | "0.0061 at m=41" | 0.006145 | correct |
| same | "largest pointwise gap does not shrink at first" | sup 0.8773 to 1.1108 from m=3 to m=5 | correct |
| same | "sits under the narrow peak near x≈0.08" | sup at x=0.077/0.097/0.095 for m=3/5/7; f peak at x=0.0804 | correct (for the early m it describes) |
| same | "undershoots" | S<f at the sup point for m=3, 5, 7 | correct |
| same | "m=5 (1.11)" | 1.11084 | correct |
| same | "m=7 (1.09)" | 1.08995 | correct |
| same | "m=3 (0.88)" | 0.87730 | correct |
| same | "From m=5 on it falls at every step" | sup strictly decreasing from m=5 to m=41 | correct |
| same | "to 0.16 at m=41" | 0.15688 | correct |

### New problems
None. This rests on the full recomputation above and on the unchanged script and GIF.

Observation, not a defect: as m grows, the point of largest gap drifts from under the peak (x≈0.08 for m≤9) towards the steep x^{2/3} rise at the left end (x=0.0129 at m=41, where f=1.42). The sentence attaches "sits under the narrow peak" to the early refinements, so "0.16 at m=41" is not claimed to be under the peak. It would be slightly clearer if the text said so, but it is not wrong.

### Reproducibility and conventions
- The only file changed in the page folder is index.qmd. `splinequadaa.jl` and `splinequadaa.gif` are identical to HEAD (`git diff --quiet` passes), so nothing needed regenerating. The committed GIF has 21 frames: a blank frame, then m=3..41.
- Conventions are kept: Description before Animations, a "Julia source" link and a GIF embed for Case 1, descriptive alt text, and no code blocks.
- Outside the page folder, git status shows modified files only under other pages in pages/numerical-methods/ (parallel fixes), plus untracked fix records under reviews/numerical-methods-animations-r3/fixes/. This page's diff touches nothing outside its folder.

**Final status:** committed
