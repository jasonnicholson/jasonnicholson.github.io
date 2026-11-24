# Fix record: brents-method

Scratch folder: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/brents-method/fix/` (`inst.jl`, `indep.py`, `frames_aa/`).

## Findings

### F1 — Minor — fixed
- Reproduced: `julia inst.jl` (instrumented copy of `run_brents` from `brentsaa.jl`, plotting removed) prints the step trace. Step 8: `IQI b=0.3285384586114149 c=0.32821473974562487 width=3.237189e-04 f(b)=0.000e+00`. Stop line: `|xm|=1.619e-04 tol1=5.000e-11 fb=0.000e+00 width/tol=6.474e+06`. The stop test is `abs(xm) <= tol1 || fb == 0 || it == n_iters` with n_iters = 14, so at step 8 only `fb == 0` holds. The bracket widths at steps 6–8 are 3.291797e-4, 3.237216e-4, 3.237189e-4. Independent check `python3 -I indep.py` (mpmath, 50 digits): root 0.328538458611414895972…, f(b) in double = 0.0 (exact f(b) = 3.10e-18), final width 3.2371886579e-4, c < root < b is True; scipy `brentq(f,0,1,xtol=1e-10)` returns 0.3285384586114149.
- Change: `index.qmd`
  - Case 1 alt text: "bracket narrows from [0,1] to the root at x≈0.3285 in 8 steps" → "b converges to the root at x≈0.3285 in 8 steps while the bracket narrows from [0,1] to width 3.2×10⁻⁴".
  - Case 1 Behavior: added after "…$f(b)$ evaluates to exactly 0.": "The run stops there because $f(b) = 0$, with the bracket still $3.2\times10^{-4}$ wide."
- Check: numbers above; last frame of `brentsaa.gif` (frame_009.png, viewed at full size) shows "Step 8: IQI" and legend "b = 0.3285384586, |c−b| = 3.2e-04", consistent with the new text. The GIF is unchanged.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 1 alt | "b converges to the root at x≈0.3285 in 8 steps" | `julia inst.jl` → step 8 b = 0.3285384586114149; `indep.py` → root 0.32853845861…, error 4.0e-19 (review table; b is the nearest double) | yes |
| Case 1 alt | "bracket narrows from [0,1] to width 3.2×10⁻⁴" | `inst.jl` → step 0 c=0, b=1; step 8 width 3.237189e-04 | yes |
| Case 1 Behavior | "The run stops there because $f(b)=0$" | `inst.jl` stop line → \|xm\| 1.619e-4 > tol1 5.000e-11, it = 8 < n_iters = 14, fb = 0.0 | yes |
| Case 1 Behavior | "bracket still $3.2\times10^{-4}$ wide" | `inst.jl` → 3.237189e-04; `indep.py` → 3.23718866e-4 | yes |

## Scripts and GIFs
- No scripts changed; no GIFs regenerated (text-only fix, R7-D / D7).
- Frames of `brentsaa.gif` extracted to `frames_aa/` (9 frames); last frame viewed to confirm the legend width 3.2e-04 and step label.
- `git status --short -- pages/numerical-methods/brents-method` → ` M pages/numerical-methods/brents-method/index.qmd` only.

## Legacy archive
Consulted. `n2003/brentmethod/` has no top-level `BrentMethodMod.html`; the module text is under `BrentMethodMod/Links/` (`BrentMethodMod_lnk_6.html` is Example 4: "Use Brent's Method to find the three roots of the cubic", root (i) etc.; the formula images are not text). It agrees with the review: Case 1 is Mathews' Example 4 root (i). Mathews quotes a tighter accuracy (his regula falsi/bisection counts 36 and 50) than the page's 10⁻¹⁰; the page attributes none of its counts to him, so nothing changes. The finding concerns the stopping reason, which the archive does not address.

## Notes
- The added Behavior sentence was the review's optional addition; it was included because it is one computed sentence and it explains the `|c−b| = 3.2e-04` the last frame shows.
- The 3.2×10⁻⁴ final width equals the step-5 error in b to two figures (3.237e-4) because c at step 8 is the step-5 iterate; both statements on the page are separately computed and correct.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The alt text on line 70 now reads "b converges to the root at x≈0.3285 in 8 steps while the bracket narrows from [0,1] to width 3.2×10⁻⁴". The Case 1 Behavior paragraph adds "The run stops there because $f(b) = 0$, with the bracket still $3.2\times10^{-4}$ wide." I re-implemented ZEROIN in Python (check/chk.py) and compared it against a 50-digit mpmath root (0.328538458611414896). The run has 8 steps (S, B, IQI, S, IQI, S, S, IQI). Final b = 0.3285384586114149, which is the nearest double to the root, with error 3.98e-19. Final c = 0.3282147397456249, so |c−b| = 3.2372e-4. The stop test gives |xm| = 1.62e-4 > tol1 = 5.0e-11, and fb == 0 is True. So the run stops because f(b) = 0, not because of the width test. The last GIF frame (frame_009) shows "Step 8: IQI" and the legend "b = 0.3285384586, |c−b| = 3.2e-04", which matches the new text. The GIF and script are unchanged and no change was needed.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd L66 (Behavior, added sentence) | "run stops there because f(b)=0" | stop test: fb==0 True, abs(xm)<=tol1 False | correct |
| index.qmd L66 | "bracket still 3.2×10⁻⁴ wide" | abs(c−b) = 3.2372e-4 | correct |
| index.qmd L70 alt | "b converges to the root at x≈0.3285" | root 0.32853845861 (mpmath); b equals the nearest double | correct |
| index.qmd L70 alt | "in 8 steps" | 8 steps after init (9 frames) | correct |
| index.qmd L70 alt | "bracket narrows from [0,1] to width 3.2×10⁻⁴" | initial bracket [0,1]; final width 3.2372e-4 | correct |
| index.qmd L70 alt | "step labels showing bisection, secant, and IQI" | all three occur (steps 2; 1,4,6,7; 3,5,8) | correct |

### New problems
None. This rests on: only index.qmd changed (2 lines; git diff --stat HEAD on the page folder). Every new claim agrees with an independent re-run of the algorithm against a high-precision root. The unchanged GIF's last frame agrees with the new wording.

### Reproducibility and conventions
- No script or GIF changed, so a regeneration was not needed. The committed brentsaa.gif decodes to 9 frames, and its last frame matches the text.
- Conventions are kept: Description comes before Animations, each case has a source link and an embed, the alt text is descriptive, and there are no code blocks. In the page folder only index.qmd is modified. The repository-wide working tree has edits in many other pages, which belong to other pages' fixes and are outside this page's diff.

**Final status:** committed
