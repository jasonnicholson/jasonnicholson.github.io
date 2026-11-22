# Fix record: runge-kutta-fehlberg-method

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/runge-kutta-fehlberg-method/fix/`
- `controllers.py`: an independent Python transcription of Mathews' RKF45/RKF54 subroutines (archive gr_15, gr_26) and of the page's controller (`rungekuttafehlbergaa.jl`)
- `variants.py`, `firststep.py`: change one controller parameter at a time
- `amplify.py`: carries a perturbation at t = 0.25 exactly to t = 1.1 (mpmath)
- `coeffs.py`: sympy check that Mathews' error weights r equal the y5 − y4 weights
- `page_h0.jl`: an instrumented copy of the page's `rkf_integrate`, with the plotting removed

## Findings

### F1 — Minor — fixed (with a corrected explanation)
- **Reproduced.** `python3 -I controllers.py` transcribes Mathews' subroutine from gr_15/gr_26:
  - accept if `err < ε` or `h < 2 hmin`;
  - s = (εh/(2 err))^{1/4}, clamped to [0.1, 4];
  - h clamped to [0.001, 0.25], h0 = 0.25, at most 200 points;
  - final-step snapping via `br`.

  At ε = 1e-6 it gives:

  | Run | Points | Final error |
  |---|---|---|
  | Mathews RKF45 | 120 | +7.0410e-2 |
  | Mathews RKF54 | 120 | +6.4500e-2 |
  | Page RKF45 | 259 | +4.5168e-3 |
  | Page RKF54 | 259 | +3.1542e-3 |

  - Mathews' runs match gr_78 (0.0704102) and gr_93 (0.0645005). His first-step error, 5.737e-6, matches the second entry of gr_78 (−5.73703e-6, true − approx). His t-list matches gr_71 (0, 0.25, 0.327661, 0.434978, 0.50781, … 1.09924, 1.1).
  - The page's runs match the review and the Julia script.

  The finding holds: the page says it "reconstructs" Example 1, its numbers differ from Mathews' by a factor of 15-20, and it does not say so.
- **Correction to the review's explanation.** The review attributes the gap to the acceptance test (absolute versus per unit step). Isolating each parameter shows that the acceptance test is not the cause (`python3 -I variants.py`, `python3 -I firststep.py`, `julia page_h0.jl`). Final errors at ε = 1e-6, RKF45 / RKF54:

  | Run | RKF45 | RKF54 |
  |---|---|---|
  | Mathews as published | 7.04e-2 | 6.45e-2 |
  | Mathews with the per-unit-step acceptance test | 6.66e-2 | 6.29e-2 |
  | Mathews with hmin = 1e-6 (257 points) | 7.03e-2 | 6.45e-2 |
  | Mathews with h0 = 0.1 | 9.37e-3 | 5.27e-3 |
  | Page with h0 = 0.25 (Julia and Python agree) | 6.6418e-2 | 6.2847e-2 |
  | Page with hmin = 0.001 (122 points) | 4.66e-3 | 3.155e-3 |

  - **The starting step causes the error gap.** From h = 0.25 the first step's error estimate is 1.673e-7. That passes the absolute test (< 1e-6) and also the per-unit-step test (≤ 2.5e-7). The true errors at t = 0.25 are +5.737e-6 for y4 and +5.570e-6 for y5. The problem magnifies an error at t = 0.25 by a factor of 11188 by t = 1.1: the exact solution through the perturbed point is off by 0.0642 (y4) and 0.0623 (y5) at t = 1.1 (`amplify.py`). The linear factor (1+y(1.1)²)/(1+y(0.25)²) is 11183.
  - **The minimum step causes the point-count gap** (120 against 259). Mathews' hmin = 0.001 is first reached at t = 1.05524, and the last 44 steps before the final truncated one are exactly 0.001.
  - So the review's suggested sentence would have attached a wrong mechanism. The page states the computed one instead.
- **Change.** `index.qmd`, Animations introduction, after the exact-solution sentence (old line 28). Added one short paragraph of text (two sentences). It says:
  - the controller is not the module's;
  - Mathews' acceptance test, h0 (0.1 here) and hmin, and where hmin is reached;
  - his 120 points and final errors, against the page's;
  - that most of the difference is the first step of 0.25, with its estimate, its true error, the amplification factor, and the page controller's errors when started from 0.25.

  No script or GIF changed.
- **Check.** Every number is in the ledger below. `git status` shows only `index.qmd` modified in the page folder.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Animations intro | "The step controller is not the module's" | Page: `err <= tol*h`, h0 = 0.1, hmin = 1e-6 (aa.jl lines 11, 37, 56). Mathews: `err < ε`, h0 = 0.25, hmin = 0.001 (gr_15, gr_26) | yes |
| same | "its RKF45 and RKF54 subroutines accept a step when \|y5 − y4\| < ε" | gr_15/gr_26 `If[Or[err < ε, h < 2 hmin], …]`; `coeffs.py` → "Mathews r == y5 - y4 weights: True". The "accept when" wording is not exclusive; the forced accept below 2·hmin is not mentioned | yes |
| same | "start from h = 0.25 (here 0.1)" | gr_15 `h = 0.2500`; aa.jl line 56 `h0=0.1` | yes |
| same | "minimum step size h_min = 0.001, which the run reaches at t ≈ 1.055" | gr_15 `hmin = 0.001`; `variants.py` → "t where h first == hmin: 1.0552429552095535"; gr_71 shows 0.001 spacing from 1.05524 | yes |
| same | "so … they take 120 points" | `controllers.py` → pts = 120 for both modes. With hmin = 1e-6 → 257 points, and the page with hmin = 0.001 → 122 points, so hmin sets the count | yes |
| same | errors 7.0e-2 (RKF45), 6.5e-2 (RKF54) at t = 1.1 | `controllers.py` → +7.0410e-2, +6.4500e-2. The archive's gr_78 gives 0.0704102 and gr_93 gives 0.0645005 (6.45005 rounds to 6.5) | yes |
| same | "against 4.5e-3 and 3.2e-3 here (Case 1)" | `controllers.py` and `page_h0.jl` → +4.5168e-3, +3.1542e-3. Matches Case 1's existing text | yes |
| same | "Most of that difference is the first step of 0.25" | Page with h0 = 0.25 → 6.64e-2 / 6.28e-2. Mathews with h0 = 0.1 → 9.37e-3 / 5.27e-3. The first-step error alone, propagated exactly, gives 6.42e-2 / 6.23e-2 of the 7.04e-2 / 6.45e-2 | yes |
| same | "its error estimate, 1.7e-7, passes either acceptance test" | `firststep.py` → err est = 1.673e-07 < 1e-6, and err/h = 6.693e-07 ≤ 1e-6 | yes |
| same | "its true error is 5.6–5.7e-6" | `firststep.py` → y4 +5.737e-06, y5 +5.570e-06 (mpmath exact) | yes |
| same | "magnifies about 1.1e4 times by t = 1.1" | `amplify.py` → ratio 11188.0 (exact propagation); linear factor 11183.3 | yes |
| same | "started from h = 0.25, the controller used here ends with errors of 6.6e-2 and 6.3e-2" | `julia page_h0.jl` → h0 = 0.25: rkf45 +6.6418e-02, rkf54 +6.2847e-02 (258 points); Python `firststep.py` gives the same | yes |

## Scripts and GIFs
- No scripts changed, and no GIFs were regenerated: this is a text-only fix. The page's numbers are correct for its own controller (review ledger C1.2–C1.13).
- `git status --short -- pages/numerical-methods/runge-kutta-fehlberg-method` → ` M .../index.qmd` only.

## Legacy archive
- **Consulted:** `n2003/RungeKuttaFehlbergMod.html` (text) and these images:
  - gr_5: the s formula, 0.840896 = 2^{-1/4};
  - gr_15 and gr_26: the RKF45 and RKF54 subroutines;
  - gr_71: Example 4's abscissas;
  - gr_78 and gr_93: the Example 4 and 5 signed errors.
- **Missing:** images gr_30–gr_43 (the Example 1 solution printout) are not in the archive.
- **No RKF animated GIF:** there is none under `a2001/Animations` (`grep -ril fehlberg` found nothing, and `OrdinaryDE/` has no RKF folder). The page's existing note about this stays correct.
- **What the archive showed:** Mathews' Example 1 at ε = 1e-6 ends with errors of 7.04e-2 and 6.45e-2. I reproduced both exactly.
- **What differs, and why the page keeps its controller:** the page uses a different but legitimate controller. Mathews' larger errors come mostly from an accepted first step whose error estimate (1.7e-7) understates its true error (5.7e-6) by a factor of about 34. Following the module's controller would reproduce that, so the page now states the difference rather than copying it.

## Notes
- **The review's mechanism was not used.** Its suggested sentence ("acceptance test → 15-20x") does not hold up, as computed above. The page states the computed mechanism (the starting step) instead. The review's numbers (120 points, 7.041e-2, 6.450e-2) are confirmed; the page rounds 6.450e-2 as 6.5e-2, where the review's draft had 6.4e-2.
- **Two controller details left out:** the s clamp [0.1, 4] and the forced accept below 2·hmin. Neither is needed to explain the numbers:
  - the 8 forced accepts are part of the hmin effect. Lowering hmin to 1e-6 changes Mathews' final errors by under 0.2% (7.0410e-2 → 7.0278e-2; RKF54 unchanged at 6.4500e-2);
  - the s clamp was not isolated.
- **Pre-existing:** the "Because the recovered archive did not include legacy RKF animated GIF portals…" paragraph is unchanged. It remains accurate.

## Resolution check (independent checker, not shown this record)

Scripts: `check/rkf.py` (independent re-implementation of Mathews' RKF45/RKF54 subroutines from archive images gr_15/gr_26, and of the page's `rkf_integrate`, each with switchable parameters), `check/run1.py`, `check/run2.py` (one-parameter-at-a-time runs), `check/run3.py` (first step and magnification, with an mpmath reference). Exact solution evaluated with mpmath at 40 digits.

### Original findings

### F1 — resolved
- Evidence: Lines 29-37 now state that the controller is not the module's. They give the module's acceptance test, its h0 and hmin, its point count and final errors, and the main cause of the difference. Every number checks (ledger below).
- My re-implementation of Mathews' subroutine reproduces his published values exactly at ε = 1e-6: final |error| 0.0704102 (RKF45) and 0.0645005 (RKF54), the same as gr_78 and gr_93. The first-step errors are 5.73703e-6 and 5.56972e-6, also the same as gr_78 and gr_93. Each run has 120 points.
- Causal claims, tested by changing one parameter at a time:
  - **The first step is the main cause.**
    - Page controller, h0 changed from 0.1 to 0.25 only: 4.517e-3 / 3.154e-3 becomes 6.642e-2 / 6.285e-2, against Mathews' 7.04e-2 / 6.45e-2.
    - Conversely, Mathews' controller with h0 = 0.25 changed to 0.1 only: 7.04e-2 / 6.45e-2 drops to 9.37e-3 / 5.27e-3.
    - The other one-at-a-time changes have much smaller effects:
      - acceptance test (absolute instead of per unit step) on the page controller: 9.20e-3 / 5.25e-3;
      - hmin = 0.001: 4.66e-3 / 3.155e-3;
      - s clamp to [0.1, 4]: no change;
      - safety factor 2^(-1/4) instead of 0.84: 4.54e-3.
    - The claim "most of that difference is the first step of 0.25" is confirmed in both directions. The rest comes mainly from the acceptance test, which the page does not claim otherwise.
  - **hmin causes the 120 points.** The text links "120 points" to hmin = 0.001 with "so".
    - Page controller with only hmin set to 0.001: 259 points become 122.
    - Mathews' controller with hmin set to 1e-6 (and the 200-point cap lifted): 120 points become 257. With the cap left at 200, the run stops at t = 1.0961.
    - The claim is confirmed.
  - **The first-step error is magnified by the problem.**
    - Linear sensitivity: (1+y(1.1)²)/(1+y(0.25)²) = 11183.
    - Nonlinear check: the exact solution through (0.25, y(0.25)+5.737e-6) is off by 6.419e-2 at t = 1.1, a ratio of 11188.
    - The first step alone therefore accounts for 6.4e-2 / 6.2e-2 of the 6.6e-2 / 6.3e-2 seen with the page controller at h0 = 0.25.
- The script and GIF were not changed (the finding asked for text only). The page's own numbers, 259 points and 4.5e-3 / 3.2e-3, still match the script: 259, 4.517e-3, 3.154e-3.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.29 | "The step controller is not the module's" | gr_15/gr_26 accept on `err < ε` (or `h < 2hmin`). The script accepts on `err <= tol*h`. | True |
| l.29-30 | module accepts when $\|y_5-y_4\|<\varepsilon$ | gr_15/gr_26: `If[Or[err<ε, h<2hmin], ...]`. The forced acceptance at h < 2hmin is omitted. It affects 8 steps after t = 1.092 and has a negligible effect on the error. | True (slightly simplified) |
| l.30 | starts from h = 0.25 (here 0.1) | gr_15 `h = 0.2500`; script `h0=0.1` | True |
| l.30 | h_min = 0.001 | gr_15 `hmin = 0.001` | True |
| l.31 | "the run reaches [h_min] at t ≈ 1.055" | The first accepted step with h = 0.001 starts at t = 1.05524 (RKF45) and t = 1.05524 (RKF54). From there on, 44 steps of 0.001 and a last step of 7.6e-4. | True |
| l.31 | same ε = 1e-6 | Reproduces gr_78/gr_93 exactly | True |
| l.31 | 120 points | 120 (both) | True |
| l.32 | 7.0e-2 (RKF45), 6.5e-2 (RKF54) at t = 1.1 | 7.0410e-2, 6.4500e-2 (6.45005e-2 rounds to 6.5e-2) | True |
| l.33 | 4.5e-3 and 3.2e-3 here (Case 1) | 4.517e-3, 3.154e-3 from the page's controller (matches the script) | True |
| l.33-34 | "Most of that difference is the first step of 0.25" | One-at-a-time: page h0 → 0.25 gives 6.64e-2 / 6.28e-2. Mathews h0 → 0.1 gives 9.37e-3 / 5.27e-3. The other single changes are at most about 2x the page's error. | True |
| l.34 | its error estimate 1.7e-7 | 1.6731e-7 | True |
| l.34-35 | passes either acceptance test | 1.673e-7 < 1e-6, and 1.673e-7 ≤ 1e-6·0.25 = 2.5e-7. The page controller with h0 = 0.25 does accept t = 0.25 first. | True |
| l.35 | true error 5.6–5.7e-6 | 5.7370e-6 (y4), 5.5697e-6 (y5). Mathews' gr_78/gr_93 list 5.73703e-6 and 5.56972e-6. | True |
| l.36 | magnified about 1.1e4 times by t = 1.1 | Linear 11183, nonlinear 11188 | True |
| l.36-37 | from h = 0.25 the page controller ends with 6.6e-2 and 6.3e-2 | 6.642e-2, 6.285e-2 | True |

### New problems
None.

This rests on the following:
- Every number and causal statement above was reproduced by independent computation.
- Each causal claim was tested by changing only the parameter named, in both controllers where that applies.
- No script or GIF changed.

Wording that is simplified but not wrong:
- The paragraph is dense, and it omits Mathews' forced acceptance when h < 2hmin and his s-clamp. I tested both: the clamp has no effect, and the forced acceptance changes only the hmin-related point count, which the text already ties to hmin.

### Reproducibility and conventions
- Only `index.qmd` changed in the page folder (`git status` and `git diff --stat` of the folder). The fix.diff lists no GIFs. The scripts and GIFs are untouched, so no regeneration is needed and none is affected.
- Other modified files in the working tree belong to other pages' parallel fixes. The fix.diff for this page touches only this page's folder.
- Conventions are kept:
  - Description precedes Animations.
  - Each case has a `[Julia source]` link and a GIF embed.
  - The alt texts are unchanged and descriptive.
  - There are no code blocks.

**Final status:** committed
