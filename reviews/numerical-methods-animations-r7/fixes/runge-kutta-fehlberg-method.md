# Fix record: runge-kutta-fehlberg-method

Scratch folder (all check scripts): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/runge-kutta-fehlberg-method/fix/`

## Findings

### F1 — Minor — fixed

- **Reproduced:** I wrote my own transcription of Mathews' `RKF45` and `RKF54` subroutines (`legacy.py`), working from the archive images `RungeKuttaFehlbergMod_gr_15.gif` and `_gr_26.gif`, which I viewed. Both subroutines test `If[Or[err < ε, h < 2 hmin], …]`, with `hmin = 0.001`, `h = 0.25` at the start and `err = |Σ r_i k_i| = |y_5 - y_4|`. I ran it as `/usr/bin/python3 legacy.py` in double precision and in 50-digit mpmath for $y'=1+y^2$, $y(0)=0.5$, $[0,1.1]$, $\varepsilon=10^{-6}$. Both precisions and both subroutines give:
  - 120 points and 119 steps;
  - the first step with $h=h_{min}$ starts at $t=1.05524$;
  - 8 steps are accepted with `err ≥ ε`, which means only by `h < 2 hmin`. They start at $t$ = 1.0922, 1.0932, …, 1.0992. These are the last 8 steps, and no step from $t \ge 1.0922$ on passes `err < ε`. Their estimates are $1.175\times10^{-6}$ to $2.692\times10^{-5}$.
  - The transcription reproduces the archive. My $T$ list ends …, 1.09124, 1.09224, …, 1.09924, 1.1, which is identical to the printed list in `_gr_71` (viewed). The maximum errors are $7.0410211\times10^{-2}$ (RKF45) and $6.4500468\times10^{-2}$ (RKF54); the archive prints 0.0704102 and 0.0645005.
  - The finding holds as stated.
- **Change:** `index.qmd` lines 31–36 (Animations introduction).
  - **Before:** "accept a step when $|y_5-y_4|<\varepsilon$, start from $h=0.25$ (here $0.1$) and have a minimum step size $h_{min}=0.001$, which the run reaches at $t\approx1.055$, so at the same $\varepsilon=10^{-6}$ they take 120 points and end with errors of …"
  - **After:** "accept a step when $|y_5-y_4|<\varepsilon$ or $h<2h_{min}$, start from $h=0.25$ (here $0.1$) and have a minimum step size $h_{min}=0.001$. At the same $\varepsilon=10^{-6}$ they take 120 points; the step reaches $h_{min}$ at $t\approx1.055$, and the last 8 of the 119 steps, from $t\approx1.092$ on, are accepted only by the $h<2h_{min}$ condition. They end with errors of …"
  - This is the review's suggested wording, rearranged so that the counts sit after the tolerance they depend on. I said "the last 8" because that is checked; the review's "all after $t\approx1.092$" undersold it.
- **Check:** `/usr/bin/python3 legacy_check.py`:
  - for both subroutines, the steps from $t\ge1.0922$ number 8 and all are only-via;
  - the first step ($h=0.25$) has estimate $1.673\times10^{-7}$ and passes `err < ε`, so the next sentence on the page ("passes either acceptance test") is still true;
  - no other number on the page changed.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| qmd 32 | module accepts when $\lvert y_5-y_4\rvert<\varepsilon$ **or** $h<2h_{min}$ | Archive `_gr_15`, `_gr_26` viewed: `If[Or[err < ε, h < 2 hmin], …]` in both | Yes |
| qmd 33 | 120 points (unchanged number) | `legacy.py` → points 120, both subroutines, double and 50-digit | Yes |
| qmd 34 | step reaches $h_{min}$ at $t\approx1.055$ (number unchanged, moved) | `legacy.py` → first step with $h=0.001$ starts $t=1.05524$; any attempt at $h_{min}$ is accepted because $h_{min}<2h_{min}$, so this is also the first attempt at $h_{min}$ | Yes |
| qmd 34 | "the last 8 of the 119 steps" | `legacy.py` → steps 119, only-via 8, and none passes `err<ε` after the first of them; `legacy_check.py` → steps from $t\ge1.0922$: count 8, all only-via (RKF45 and RKF54) | Yes |
| qmd 34 | "from $t\approx1.092$ on" | `legacy.py` → first only-via step starts $t=1.0922$ (archive `_gr_71` shows the point 1.09224) | Yes |
| qmd 35 | "accepted only by the $h<2h_{min}$ condition" | `legacy.py` → their estimates are $1.175\times10^{-6}$ to $2.692\times10^{-5}$, all $\ge\varepsilon$ | Yes |
| qmd 35–36 | errors $7.0\times10^{-2}$, $6.5\times10^{-2}$ (unchanged, rewrapped) | `legacy.py` → $7.0410\times10^{-2}$, $6.4500\times10^{-2}$ | Yes |
| qmd 37 (unchanged, re-checked) | first-step estimate $1.7\times10^{-7}$ passes either test | `legacy_check.py` → $1.673\times10^{-7}$, `err<ε` True | Yes |

## Scripts and GIFs

- No script changed and no GIF was regenerated, because the finding is text only (R7-D, D7).
- `git status --short -- pages/numerical-methods/runge-kutta-fehlberg-method` → ` M pages/numerical-methods/runge-kutta-fehlberg-method/index.qmd` only.

## Legacy archive

I consulted the archive (`n2003/rungekuttafehlberg/RungeKuttaFehlbergMod/Images/`):
- `_gr_15` and `_gr_26` (the RKF45 and RKF54 subroutines) were viewed and transcribed independently.
- `_gr_71` (the printed $T$ list for Example 1) was viewed, and my transcription reproduces it to every printed digit.

The page now states the module's acceptance test in full. The page's own controller is unchanged and is still disclosed as different from the module's.

## Notes

- The independent-check line marked this Minor finding "not run". I reproduced it from my own transcription and did not use the reviewer's `c5.py`.
- I noticed nothing outside the page.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: The sentence now reads "accept a step when $|y_5 - y_4| < \varepsilon$ or $h < 2h_{min}$", matching `If[Or[err < ε, h < 2 hmin], ...]` in both archive subroutine images (gr_15 RKF45, gr_26 RKF54), which I read directly. I transcribed both subroutines independently (check/mod.py: same coefficients, err = |r·k|, s = (εh/(2err))^0.25 clamped to [0.1,4], h clamped to [hmin,hmax], end clipping at br = b0 − 1e-5|b0|). Both give 120 points / 119 steps. The steps accepted with err ≥ ε are indices 111–118, i.e. exactly the last 8 of the 119, starting at t0 = 1.09224 (err 1.18e-6, up to 2.69e-5 at t0 = 1.09824). The first accepted step with h = hmin starts at t = 1.05524. Final errors at t = 1.1: 7.04e-2 (RKF45) and 6.45e-2 (RKF54). First-step estimate 1.67e-7, true error 5.74e-6 / 5.57e-6. Every number in the new text is correct.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.31 | accept when \|y5−y4\| < ε or h < 2h_min | archive gr_15, gr_26 | correct |
| l.31–32 | start h = 0.25 (here 0.1), h_min = 0.001 | archive images; unchanged values | correct |
| l.32 | ε = 1e-6, 120 points | transcription: 120 points both | correct |
| l.33 | reaches h_min at t ≈ 1.055 | first h = 0.001 step starts at t = 1.05524 | correct |
| l.33 | last 8 of the 119 steps | bad indices 111–118 of 0–118, consecutive and final | correct |
| l.33 | from t ≈ 1.092 on | first such step starts at t = 1.09224 | correct |
| l.34 | accepted only by h < 2h_min | all 8 have err ≥ 1.17e-6 > ε, h ≤ 0.001 < 0.002 | correct |
| l.35 | 7.0e-2 (RKF45), 6.5e-2 (RKF54) at t = 1.1 | 7.041e-2, 6.450e-2 | correct |
| l.35 | 4.5e-3, 3.2e-3 here | unchanged text, not part of fix | n/a |

### New problems
None. The diff touches only one sentence in index.qmd; all its numbers reproduce. (Style nit, not a defect: "They end with errors…" follows a clause whose subject is "the last 8 … steps", but RKF45/RKF54 in the same sentence make the antecedent clear.)

### Reproducibility and conventions
- No script or GIF changed (git status for the folder: only index.qmd modified), so there is nothing to regenerate. The GIFs are byte-identical to HEAD.
- Conventions still hold: Description before Animations, one Julia source link and one GIF embed with descriptive alt text per case, no code blocks.
- The fix diff covers only this page folder. Other modified files in the working tree belong to other pages' fixes in this batch.

**Final status:** committed
