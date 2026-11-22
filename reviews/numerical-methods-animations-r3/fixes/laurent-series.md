# Fix record: laurent-series

Scratch folder (all scripts and outputs, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/laurent-series/fix/`

- `lib.jl`: the page script with its final render loop removed (`sed '/^for case in cases$/,$d'`), so its own `cases`, `series_coeffs`, `safe_eval`, `poly_eval_asc` can be called without writing GIFs.
- `beyond_script.jl`, `mono_script.jl`, `pts_script.jl`: instrumented checks that use the script's coefficients on its 900-point grid.
- `closed.py`, `stretch.py`, `left06.py`: independent checks (sympy series / closed-form coefficients, mpmath at 40 digits).
- `committed/laurentNN/`: frames and contact sheets of the committed GIFs 03, 06, 12, 23, 24 and 25. `committed/laurent06b/` holds the full-size case-06 frames, of which frames 8–10 were viewed.

## Findings

### F1 — Misleading — fixed
- **Reproduced:**
  - `python3 -I closed.py` uses exact sympy series coefficients. At x = 10.5 in case 03 (sqrt, x0 = 5), the error for N = 1..10 is 0.2255, 0.1127, 0.0733, 0.0545, 0.0439, 0.0373, 0.0329, 0.0298, 0.0277, 0.0261. It decreases strictly for N = 1..15, is smallest at N = 15 (0.0232), increases strictly for N = 15..80, and is 0.942 at N = 80.
  - At x = 4.1 in case 06 (log, x0 = 2), the error for N = 1..10 is 0.3322, 0.2191, 0.1668, 0.1371, 0.1182, 0.1052, 0.0958, 0.0889, 0.0835, 0.0794. It decreases strictly for N = 1..20, is smallest at N = 20 (0.0663), increases strictly for N = 20..80, and is 0.315 at N = 80.
  - `python3 -I stretch.py` checks every grid point beyond R. Case 03: 43 points, x ∈ [10.0095, 10.5], and the error falls strictly from each frame to the next (N = 1..10) at all 43. Case 06: 118 points beyond R. Of these, 98 are at x ∈ [−0.5, −0.0037], where log is not real. The other 20 are at x ∈ [4.0028, 4.1], and the error falls strictly at all 20.
  - The instrumented script check (`julia mono_script.jl`) uses the script's own coefficients and gives the same counts: 03 43/43 and 06 20/20. It also finds that no other non-entire case has this property at all of its beyond-R points where f is defined. Counts of strictly falling points: 01 14/728, 02 57/215, 04 15/150, 05 21/411, 07 31/150, and 0 for 12, 16, 22–27. Case 17 has no beyond-R point where asin is real.
  - Frames: in `committed/laurent06/sheet.png` and `committed/laurent03/` the blue and magenta curves converge at the right edge as N rises.
- **Change:** in `index.qmd`, Animations paragraph (line 30), the sentence "…diverges beyond it, and every such plotted interval reaches past that distance." is kept, and four sentences follow it. These were revised after the checker's resolution report (`scratchpad/r3fix/laurent-series/check/resolution.md`, new problem 1). My first version said "Cases 03 and 06 do not show that divergence within their ten frames", which overstated case 06: on its x < 0 strip the partial sums do run off. Final text:
  > Case 03's window passes that distance only on $10<x\le 10.5$, and case 06's on $4<x\le 4.1$ and $-0.5\le x<0$. On $10<x\le 10.5$ (case 03) and $4<x\le 4.1$ (case 06) the ten frames do not show the divergence: the error falls from each frame to the next. At $x=10.5$ in case 03 the error keeps falling until $N=15$, and at $x=4.1$ in case 06 until $N=20$; after that it grows with every further term (checked to $N=80$). In case 06 the divergence shows only for $x<0$, where $\log x$ is not real and no $f$ curve is drawn: there every term after the constant is negative, so the blue curve sinks with each frame and drops below the bottom of the window ($y=-6$) at the left edge in frames 9 and 10 (at $x=-0.5$ the partial sum is $-6.10$ for $N=9$ and $-7.03$ for $N=10$).
- **Check:** each claim is in the ledger below. No script or GIF changed (D7: the animation is correct, so the text is fixed).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.30 | case 03 window passes the distance only on $10<x\le10.5$ | Window [0, 10.5], x0 = 5, R = 5 (branch point at 0). \|x−5\| > 5 ⇔ x > 10 or x < 0, and x < 0 is outside the window (x = 0 lies on the circle). `stretch.py` → all 43 beyond-R grid points are in [10.0095, 10.5], none with x ≤ 0 | yes |
| index.qmd l.30 | case 06 window passes it on $4<x\le4.1$ and $-0.5\le x<0$ | Window [−0.5, 4.1], x0 = 2, R = 2, so \|x−2\| > 2 ⇔ x > 4 or x < 0. `stretch.py` → 20 points in [4.0028, 4.1] and 98 points in [−0.5, −0.0037] | yes |
| index.qmd l.30 | "the ten frames do not show the divergence: the error falls from each frame to the next" (scoped to (10, 10.5] in 03 and (4, 4.1] in 06) | Script rows 03 and 06 have `max_order = 10`, and `giftools.jl` reports 10 frames each. `stretch.py` → the error decreases strictly for N = 1..10 at 43/43 (03) and 20/20 (06) grid points. `mono_script.jl` (script coefficients) → same | yes |
| index.qmd l.30 | case 06: "the divergence shows only for x<0, where log x is not real and no f curve is drawn" | Right side (4, 4.1]: the error falls in every frame (row above). Inside the disc (0 ≤ x ≤ 4) the series converges, so it does not diverge there. For x < 0, script `safe_eval` gives NaN (DomainError), and `mono_script.jl` finds f defined at only 20 of the 118 beyond-R points. Full-size frames 8–10 (`committed/laurent06b/frame_00{8,9}.png`, `frame_010.png`) show no magenta left of 0 | yes |
| index.qmd l.30 | "every term after the constant is negative" (x < 0) | a_k = (−1)^{k−1}/(k·2^k) and (x−2)^k = (−1)^k\|x−2\|^k, so each term is −\|x−2\|^k/(k·2^k) < 0 for k ≥ 1, while a_0 = log 2 > 0. `left06.py` → all terms k = 1..10 are negative at all 98 grid points with x < 0: True | yes |
| index.qmd l.30 | "the blue curve sinks with each frame" | `left06.py` → T_N strictly decreasing for N = 1..10 at all 98 grid points with x < 0: True | yes |
| index.qmd l.30 | "drops below the bottom of the window (y = −6) at the left edge in frames 9 and 10" | Frame n draws N = n. `left06.py` → the number of grid points with T_N < −6 is 0 for N ≤ 8, 2 for N = 9 (x ∈ [−0.5, −0.4949]) and 14 for N = 10 (x ∈ [−0.5, −0.4335]). Full-size frames: frame 8 ends at about −5.3 at x = −0.5, frame 9 meets the bottom edge at the left corner, frame 10 leaves the bottom at x ≈ −0.43 | yes |
| index.qmd l.30 | T_N(−0.5) = −6.10 (N = 9), −7.03 (N = 10) | `left06.py` → T_N(−0.5) for N = 1..10 = −0.56, −1.34, −1.99, −2.60, −3.21, −3.85, −4.53, −5.27, −6.10, −7.03. These match the checker's values | yes |
| index.qmd l.30 | case 03, x = 10.5: falls until N = 15 | `closed.py` → strictly decreasing N = 1..15: True; minimum at N = 15 (0.0232) | yes |
| index.qmd l.30 | case 06, x = 4.1: falls until N = 20 | `closed.py` → strictly decreasing N = 1..20: True; minimum at N = 20 (0.0663) | yes |
| index.qmd l.30 | "grows with every further term (checked to N = 80)" | `closed.py` → strictly increasing N = 15..80 (03) and N = 20..80 (06): True. Values at N = 80: 0.942 and 0.315 | yes |

## Scripts and GIFs
- Scripts changed: none. GIFs regenerated: none (text-only fix).
- Frames viewed (committed GIFs): contact sheets for 03 and 06, which confirm F1, and for 12, 23, 24 and 25. Those four were checked to decide whether any other case shares F1's problem: none has an error that falls in every frame at every beyond-R point. Case 23 at x = 5.2: the error is 30.2 at N = 1 and 9.67 at N = 8, but it is not monotone (3.66 at N = 6, then 13.5), and on [−0.2, 0) it grows. Case 24 on [−0.2, 0) swings between 0.17 and 20 with no trend (`pts_script.jl`). The page makes no claim about these cases beyond the original sentence.
- `git status --short -- pages/numerical-methods/laurent-series` → ` M pages/numerical-methods/laurent-series/index.qmd` only.

## Legacy archive
Consulted. The archive has no Laurent-series module: `grep -il laurent` over `n2003/*.html` matches only `FrobeniusSeriesMod.html` and `FrobeniusSeriesProof.html`, which mention a "generalized Laurent series" in passing, plus some bibliography link pages. The fix does not depend on the archive.

## Notes
- The reviewer suggested two other fixes: dropping the "every such plotted interval" clause, or pointing to the cases where divergence is visible. I did neither. A list of "visible" cases would need a definition of visible, and cases 17, 24 and 25 are borderline. In case 17 asin is not real beyond R. In case 24 the error swings with no trend. In case 25 the polynomials leave the window before reaching R. The added sentences claim only what was computed for cases 03 and 06.
- The reviewer's note about the vertical magenta segments at poles (cases 12 and 22–24) is not a finding, so it was not touched.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: the sentence "every such plotted interval reaches past that distance" is kept (still true) but is now followed by a qualifier naming cases 03 and 06 as not showing the divergence within their ten frames, giving the stretches beyond R and the N at which the error turns. Recomputed with mpmath (60 digits, exact Taylor coefficients of sqrt about 5 and log about 2; `check/chk.py`):
  - Case 03, x=10.5: |T_N - f| for N=1..10 = 0.2255, 0.1127, 0.0733, 0.0545, 0.0439, 0.0373, 0.0329, 0.0298, 0.0277, 0.0261; strictly decreasing for N=1..15, minimum at N=15 (0.02319), strictly increasing for every N from 15 to 80 (0.942 at N=80).
  - Case 06, x=4.1: N=1..10 = 0.3322 ... 0.0794; strictly decreasing to N=20 (minimum 0.06629), strictly increasing every step 20..80 (0.315 at N=80).
  - Error decreasing from each frame to the next (N=1..10) holds at every point of (10, 10.5] and (4, 4.1], both on the script's 900-point plot grid (43 and 20 points in those stretches) and on a 400-point fine grid.
  - Frames (`check/f03`, `check/f06`): case 03 frame 10 shows blue and magenta overlapping at x=10.5, case 06 frames show convergence at x=4.1. The text now matches this.
  - Script and GIFs are unchanged (git diff HEAD empty for *.gif and *.jl in the folder); the finding was text-only, so no regeneration was needed.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.30 | "Cases 03 and 06 do not show that divergence within their ten frames." | Script: max_order 10, frames N=1..10; giftools reports 10 frames each. For the right-hand stretches, true (error falls). For case 06's x<0 strip, see New problem 1. | true for 03; mostly true for 06 (Minor) |
| l.30 | "windows pass that distance only on 10<x≤10.5 and 4<x≤4.1" | Case 03: window [0,10.5], R=5, |x-5|>5 within window only for x>10 (x=0 is exactly on the circle). Case 06: window [-0.5,4.1], R=2, |x-2|>2 for x>4 or x<0. | true |
| l.30 | "(and, in case 06, for x<0, where log x is not real and no f curve is drawn)" | safe_eval returns NaN for log of negative (DomainError) so no magenta there; frames confirm. | true |
| l.30 | "on those stretches the error falls from each frame to the next" | Strict decrease N=1..10 at every grid point of (10,10.5] and (4,4.1]. | true |
| l.30 | "At x=10.5 in case 03 the error keeps falling until N=15" | Strictly decreasing N=1..15, argmin 15 (0.023191; N=16 is 0.0232 but larger). | true |
| l.30 | "at x=4.1 in case 06 until N=20" | Strictly decreasing to N=20, argmin 20 (0.066293). | true |
| l.30 | "after that it grows with every further term (checked to N=80)" | Strictly increasing at every step N=15→80 (03) and 20→80 (06); e80 = 0.942 and 0.315. | true |

### New problems
1. **Minor** — index.qmd l.30, "Cases 03 and 06 do not show that divergence within their ten frames." For case 06 this is overstated on the x<0 strip. There every term a_k(x-2)^k = -|(x-2)/2|^k/k is negative, so the partial sums diverge to -infinity, and the frames show it: T_N(-0.5) = -0.56, -1.34, -1.99, -2.60, -3.21, -3.85, -4.53, -5.27, -6.10, -7.03 for N=1..10. The steps grow after N=4, and the blue curve leaves the bottom of the window (ylim -6) in frames 9-10 (see `check/f06/sheet.png`). A viewer has no f curve to compare against, but the runaway partial sums are the divergence itself. Also, "on those stretches" could be read as including x<0, where the error against the complex log does not fall (|T_N - log x| at x=-0.5 rises from 3.145 to 7.074). Suggested wording: "...do not show that divergence where f is drawn", or a clause noting that in case 06 the blue curve left of x=0 sinks further each frame, which is the series diverging there.
- Nothing else new. This rests on recomputing every number and claim in the changed sentence and looking at the case 03 and 06 frames.

### Reproducibility and conventions
- No script or GIF changed (git diff HEAD on the folder shows only index.qmd), so there was nothing to regenerate. The committed GIFs for 03 and 06 decode to 10 frames.
- Conventions: Description precedes Animations; one Julia source link; 27 case headings and 27 image embeds, each with alt text; no code fences. The alt text is generic ("Laurent-series truncation animation for case NN."), but it is unchanged and was not part of this round's findings.
- Files outside the page folder: fix.diff touches only pages/numerical-methods/laurent-series/index.qmd. The other modified files in the working tree (Lagrange, Newton interpolation, Padé, Richardson, Runge-Kutta, review fix records) belong to other pages' fixes and contain no Laurent changes (the Padé diff only corrects "rationale" and rewords the derivative-matching sentence).

### Re-check (revised diff, index.qmd 7b4f5c0 blob)

### F1 — resolved
- The revised sentences keep every claim verified above, now scoped to the stretches where they hold, and add a sentence on case 06's x<0 strip. The new problem I raised before is gone.

### Ledger of the revised text
| Text / number | Check | Verdict |
|---|---|---|
| "Case 03's window passes that distance only on 10<x≤10.5" | window [0,10.5], R=5; x=0 lies exactly on the circle | true |
| "case 06's on 4<x≤4.1 and -0.5≤x<0" | window [-0.5,4.1], R=2 | true |
| "On 10<x≤10.5 (case 03) and 4<x≤4.1 (case 06) the ten frames do not show the divergence: the error falls from each frame to the next" | strictly decreasing for N=1..10 at every point of both stretches (plot grid and a fine grid) | true |
| "until N=15" / "until N=20"; "grows with every further term (checked to N=80)" | argmin 15 (0.02319) and 20 (0.06629); strictly increasing at each step to N=80 | true |
| "In case 06 the divergence shows only for x<0, where log x is not real and no f curve is drawn" | f is NaN for x<0 (no magenta); the right-hand stretch does not show it | true |
| "every term after the constant is negative" | a_k(x-2)^k = -\|x-2\|^k/(k 2^k) < 0 for k≥1 and x<2; checked for k=1..10 on all 98 grid points with x<0 | true |
| "the blue curve sinks with each frame" | follows from the terms being negative: T_N decreases in N at every x<0 | true |
| "drops below the bottom of the window (y=-6) at the left edge in frames 9 and 10" | ylims (-6,2). The minimum over x<0 for N=1..8 is ≥ -5.272, so the curve stays inside. N=9: 2 grid points below -6 (x ≤ -0.4949); N=10: 14 points (x ≤ -0.4335). Full-size frames 9 and 10 (`check/f06/frame_009.png`, `frame_010.png`) agree: in frame 9 the curve meets the bottom edge right at the lower-left corner, and in frame 10 it exits at about x = -0.43. | true (in frame 9 the crossing is only just visible, at the corner) |
| "-6.10 for N=9 and -7.03 for N=10" at x=-0.5 | mpmath: -6.0997, -7.0310 | true |

### New problems (re-check)
None. This rests on recomputing every claim and number in the revised sentences (`check/chk.py`, `check/chk2.py`) and on reading frames 9 and 10 of case 06 at full size, plus the earlier frames for cases 03 and 06.

### Reproducibility and conventions (re-check)
- Only index.qmd changed in the folder. The script and GIFs are identical to HEAD.
- There are still 27 embeds, one source link and no code fences. No other Laurent file changed.

**Final status:** committed
