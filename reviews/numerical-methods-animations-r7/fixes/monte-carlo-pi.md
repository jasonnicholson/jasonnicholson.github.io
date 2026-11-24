# Fix record: monte-carlo-pi

## Findings
### F1 — Minor — fixed
- Reproduced: scratch `fix/inst.jl` (same seed 12345, same `rand` draws as `montecarlopiaa.jl`) exported the 10000 points; `fix/indep.py` (`/usr/bin/python3 -I`, exact `Fraction` disk test, mpmath 30 digits) recomputed:

  | n | m | pi_hat | abs(pi - pi_hat) | ratio to previous error |
  |---|---|---|---|---|
  | 100 | 73 | 2.92 | 0.22159265 | |
  | 400 | 306 | 3.06 | 0.081592654 | 0.3682 |
  | 1600 | 1270 | 3.175 | 0.033407346 | 0.4094 |
  | 6400 | 5049 | 3.155625 | 0.014032346 | 0.42 |
  | 10000 | 7905 | 3.162 | 0.020407346 | 1.454 |

  Julia and Python agree on every value. The error is not monotone: it rises on the last step, from 0.014032 to 0.020407. So "approaches pi" as an unqualified statement does not hold.
- Change: `index.qmd` line 39, alt text: "...while the running estimate approaches pi as sample size increases" → "...while the running estimate fluctuates but trends toward pi as sample size increases". This is the review's suggested wording and matches the Behavior paragraph (line 35).
- Check: "fluctuates": the estimate is below pi at n = 100 and 400 and above at 1600, 6400 and 10000, and the error rises at the last step (ratio 1.454). "trends toward pi": the error falls from 0.2216 at n = 100 to 0.0204 at n = 10000, a factor of about 10.9, and falls in 3 of the 4 steps. `git diff` shows only this one alt-text change.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `index.qmd` line 39 alt text | "the running estimate fluctuates but trends toward pi as sample size increases" | `julia inst.jl` and `python3 -I indep.py` → errors 0.2216, 0.0816, 0.0334, 0.0140, 0.0204. Not monotone (last ratio 1.454), and the error falls overall from 0.2216 to 0.0204. Estimates 2.92 and 3.06 lie below pi; 3.175, 3.155625 and 3.162 lie above | yes |

## Scripts and GIFs
- No script changed and no GIF regenerated. This was a text-only fix (R7-D, D7).
- `git status --short -- pages/numerical-methods/monte-carlo-pi` → ` M pages/numerical-methods/monte-carlo-pi/index.qmd` only.

## Legacy archive
- Consulted: `n2003/montecarlopi/MonteCarloPiMod/Links/MonteCarloPiMod_lnk_2.html` (Example 1, Monte Carlo approximation of pi), the example this case reconstructs. It has no bearing on the alt-text wording. The archive was not needed to settle this finding, and the page is not changed relative to it.

## Notes
- No decision ambiguity. No other issues touched.
- Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/monte-carlo-pi/fix/` (`inst.jl`, `indep.py`, `pts.txt`).

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the diff changes only the alt text in `index.qmd` line 39, from "approaches pi" to "fluctuates but trends toward pi as sample size increases" (the suggested wording, and it matches the Behavior paragraph).
- Recomputed independently (`check/run/nums.jl`, seed 12345, the same 10000 points): m = 73, 306, 1270, 5049, 7905; pi_hat = 2.92, 3.06, 3.175, 3.155625, 3.162; |pi - pi_hat| = 0.221593, 0.081593, 0.033407, 0.014032, 0.020407; successive error ratios 0.368, 0.409, 0.42, 1.454. The error falls over the first four sizes and rises on the last step, so the estimate does fluctuate. The overall trend toward pi is real (the error falls from 0.2216 to 0.0204), so "fluctuates but trends toward pi" is true.
- The GIF and script are unchanged. The last frame (n = 10000, pi_hat = 3.162, |pi - pi_hat| = 0.020407, std error = 0.016422) agrees with the new alt text. The rest of the alt text is unchanged and still correct: green points are inside the quarter circle, orange points are outside, and the plot is the unit square.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.39 alt text | "running estimate fluctuates but trends toward pi as sample size increases" | Recomputed the errors at the five sample sizes: they are not monotone (ratio 1.454 on the last step), and the overall decrease is about 10.9x | True |
| index.qmd l.39 alt text | unchanged remainder: "random points are classified by quarter-circle membership", "in the unit square" | Looked at frame 6 at full size: green is inside, orange is outside, axes run over [0,1]^2 | True |

The diff adds no numbers. While checking, I also confirmed the existing Behavior claim "between 0.68 and 1.35 standard errors": the ratios err/se are 1.349, 0.994, 0.814, 0.684 and 1.243, so it holds.

### New problems
None. This rests on three things: the diff is a one-line alt-text change, the new wording agrees with my own recomputation, and no other file in the page folder changed (`git status` shows only `index.qmd` modified).

### Reproducibility and conventions
- I ran the scratch copy of `montecarlopiaa.jl`. The GIF it writes is byte-identical to the committed `montecarlopiaa.gif` (`cmp` passes). The GIF has 6 frames: the opening frame plus n = 100, 400, 1600, 6400, 10000.
- Conventions still hold: Description comes before Animations, there is a Julia source link and an embed for Case 1, the alt text is descriptive, and the page has no code blocks. The fix diff touches nothing outside the page folder. Other modified files in the working tree belong to other pages' fixes and are not part of this diff.

**Final status:** committed
