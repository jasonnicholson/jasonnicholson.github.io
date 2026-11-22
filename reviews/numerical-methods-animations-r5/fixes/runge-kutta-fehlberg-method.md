# Fix record: runge-kutta-fehlberg-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r5fix/runge-kutta-fehlberg-method/fix/` (`instr.jl`, `check.py`).

## Findings

### F1 — Minor — fixed
- **Reproduced:**
  - `julia instr.jl` runs an instrumented copy of the scripts' `rkf_integrate` (same stages, test and controller) that logs every attempt and every clamp. Output:
    - Case 1 (both modes): 259 points, 4 rejections, 0 `hmax` clamps, 0 `hmin` clamps, 0 forced accepts, 0 steps with err = 0. Largest accepted h = 0.136002, smallest 2.822e-05 (RKF45) / 2.823e-05 (RKF54).
    - Case 2 (both modes): 80 / 81 points, 3 rejections, **5 `hmax` clamps**, 0 `hmin` clamps, 0 forced accepts, 0 steps with err = 0. Capped after t = 0.1, 0.35, 0.6, 0.85, 1.1, with s·h = 0.3228, 0.3789, 0.3526, 0.3119, 0.2750 → 0.25. Smallest accepted h = 2.736e-02 (RKF45); 6.392e-04 for RKF54, which is the final landing step set by `h = tf - t`.
  - Independent check: `/usr/bin/python3 -I check.py`, a separate implementation from the exact-fraction Fehlberg tableau with the page's controller. It gives the same point counts (259/259, 80/81), the same five capped values [0.3228, 0.3789, 0.3526, 0.3119, 0.275], 0 `hmin` clamps and the same min/max steps. With the cap removed (`hmax = inf`), Case 2's first steps are 0.1, 0.3228, 0.403, 0.2736, 0.2772, 0.2419. So without the cap the hump steps would not be 0.25.
  - The finding holds as written. Only the h_max cap binds, and only in Case 2.
- **Change:** `index.qmd` Description, last sentence.
  - Before: "…the next step size is $h_{new} = s h$ with $s = 0.84\,(\varepsilon h/|y_5 - y_4|)^{1/4}$."
  - After: "…$h_{new} = s h$ with $s = 0.84\,(\varepsilon h/|y_5 - y_4|)^{1/4}$, clamped to at most $h_{max}=0.25$ (the scripts also impose a minimum $h_{min}=10^{-6}$, which neither case below reaches)."
- **Check:**
  - Script signatures: `hmin=1e-6, hmax=0.25` (`rungekuttafehlbergaa.jl:11`, `rungekuttafehlbergbb.jl:29`), applied by `h = clamp(s * h, hmin, hmax)` (lines 45 and 63).
  - "Neither case reaches h_min" covers all of these, in both cases and both modes: 0 `hmin` clamps, 0 forced accepts, and smallest accepted h ≥ 2.82e-05 > 1e-6.
  - The Case 2 Behavior's "maximum step h = 0.25" now refers to a limit the Description defines.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Description, last sentence | "clamped to at most $h_{max}=0.25$" | Script lines 29/45 and 11/63: `hmax=0.25`, `clamp(s*h, hmin, hmax)`. `julia instr.jl` → Case 2 has 5 clamps to 0.25; Case 1 has 0 (max h 0.136) | yes |
| Description, last sentence | "the scripts also impose a minimum $h_{min}=10^{-6}$" | Script signatures `hmin=1e-6` | yes |
| Description, last sentence | "which neither case below reaches" | `julia instr.jl` and `python3 -I check.py` → 0 `hmin` clamps and 0 forced accepts in both cases and modes; min accepted h = 2.82e-05 (Case 1), 6.39e-04 (Case 2) | yes |

## Scripts and GIFs
- No scripts were changed and no GIFs were regenerated; the finding was text only.
- `git status --short -- pages/numerical-methods/runge-kutta-fehlberg-method` → ` M pages/numerical-methods/runge-kutta-fehlberg-method/index.qmd` (only).

## Legacy archive
- Consulted. `n2003/rungekuttafehlberg/RungeKuttaFehlbergMod/` holds only `Images/` and `Links/`; there is no top-level module HTML.
- The module's RKF45 code image (`Images/RungeKuttaFehlbergMod_gr_15.gif`) shows the following:
  - limits `hmin = 0.001`, `hmax = 0.250`, `max1 = 200`, starting `h = 0.2500`;
  - acceptance `err < ε` or `h < 2 hmin`;
  - `s = (εh/(2 err))^0.25`, with s clamped to [0.1, 4] and then h clamped to [hmin, hmax].
- So the page's h_max = 0.25 is the same cap Mathews uses. The page's intro already describes the other controller differences (h0, h_min, acceptance test), and this fix does not touch them.

## Notes
- The scripts also set s = 2 when the error estimate is exactly 0. That never happens in either case (`err==0: 0` in `instr.jl`), so the page does not mention it.
- I noticed nothing outside this page.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The Description (index.qmd lines 21–23) now says the update $h_{new}=sh$ is "clamped to at most $h_{max}=0.25$ (the scripts also impose a minimum $h_{min}=10^{-6}$, which neither case below reaches)". Both scripts use `hmin=1e-6, hmax=0.25` and `h = clamp(s * h, hmin, hmax)` (aa.jl:11,45; bb.jl:29,63), so the stated cap and minimum match the code.
- I ran an instrumented Julia copy of the integrator (check/instr.jl), using the same arithmetic as the scripts. It logs every attempted step:
  - Case 2: the upper clamp binds 5 times in both modes, with unclamped $sh$ = 0.3228, 0.3789, 0.3526, 0.3119 and 0.2750. The steps that start at t = 0.1, 0.35, 0.6, 0.85 and 1.1 are exactly 0.25, so they end at 1.35. This agrees with the Case 2 Behavior text, which now follows from the Description.
  - $h_{min}$ is never reached:
    - Case 1: the smallest unclamped $sh$ is $4.8\times10^{-5}$, and the smallest attempted $h$ is $2.82\times10^{-5}$ (the truncated final step).
    - Case 2: the smallest unclamped $sh$ is 0.0274, and the smallest attempted $h$ is $6.4\times10^{-4}$ (RKF54's truncated final step).
    - The lower clamp count is 0 and the forced-accept count is 0 in all four runs. "Neither case below reaches" is therefore true, including the end-of-interval truncation.
- No script or GIF needed changing for this finding: it was a Description omission, and the animations already showed the capped steps.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.21 | "clamped to at most" | Code: `clamp(s*h, hmin, hmax)`. The upper bound binds 5× in Case 2 (instrumented run) | True |
| index.qmd l.22 | $h_{max}=0.25$ | Signatures aa.jl:11 and bb.jl:29. Accepted steps of exactly 0.25 on [0.1, 1.35] in Case 2 | True |
| index.qmd l.22 | "the scripts also impose a minimum" | Same clamp, lower bound `hmin` | True |
| index.qmd l.22 | $h_{min}=10^{-6}$ | Signatures aa.jl:11 and bb.jl:29 | True |
| index.qmd l.22–23 | "which neither case below reaches" | Min attempted h is 2.82e-5 (Case 1) and 6.4e-4 (Case 2, final truncated step). Min unclamped sh is 4.8e-5 and 0.027. Lower-clamp count 0, forced accepts 0 | True |

### New problems
None. This rests on three things:
- The diff touches only these 3 lines of index.qmd.
- Every claim in those lines was checked against an instrumented run of the exact integrator.
- The new sentence agrees with the unchanged text: Case 2 "maximum step $h=0.25$", Case 1 "start from $h=0.1$", and the step ranges 0.136 to $5\times10^{-5}$ and 0.027 to 0.25.

The page still does not mention two details, but neither is a defect:
- $s=2$ when the error estimate is exactly 0. This never happens: the zero-error count is 0 in all runs.
- The forced acceptance at $h\le h_{min}$. This never triggers.

The finding's suggested correction did not ask for either.

### Reproducibility and conventions
- No script or GIF in the page folder changed. `git diff --stat HEAD` on the folder shows only index.qmd (3+/1−), so both committed GIFs are the HEAD versions and there is nothing to regenerate or compare.
- The working tree also has modifications in other numerical-methods page folders (broyden, laurent, maclaurin, muller, nonlinear-systems, secant). Those belong to other pages' fixes in this round. The fix.diff for this page covers only this folder, and none of those files relate to it.
- Conventions still hold:
  - Description comes before Animations.
  - Each case has a `[Julia source]` link and an embed, with descriptive alt text.
  - There are no code fences.
  - The new inline math uses the same `$...$` style as the surrounding text.
- I made no changes to the repository.

**Final status:** committed
