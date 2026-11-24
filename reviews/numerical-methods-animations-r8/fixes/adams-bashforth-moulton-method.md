# Fix record: adams-bashforth-moulton-method

## Findings
### F1 — Minor — fixed
- Reproduced: independent Python ABM4 PECE (RK4 starters, AB4 predictor, one AM4 corrector), exact value from scipy DOP853 (rtol 1e-13, atol 1e-15). `/usr/bin/python3 -I check.py` in the scratch folder prints
  `exact=0.0081199205 y5=0.0214088 err=0.0132889 y5/exact=2.6366 err/exact=1.6366`.
  So y(5) at m=12 is 2.64 times the exact value and the error is 1.64 times it. The page's "that" refers to the error, so the sentence was wrong as written. (The review's error figure 0.0132905 is slightly off; the computed error is 0.0132889. The page's rounded "0.013" is right either way.)
- Change: `index.qmd` lines 41-42, "(though that is still 2.6 times the exact value)" → "(though $y(5)$ is still 2.6 times the exact value)". This is the review's first wording, the smaller change: it keeps the existing number and fixes what the number refers to.
- Check: y5/exact = 2.6366 → "2.6" is correct for y(5). No other text, alt text or GIF title has this ratio (`grep -n "2\.6"` over the page folder finds only line 42).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.41-42 | "(though $y(5)$ is still 2.6 times the exact value)" | `python3 -I check.py` → y5=0.0214088, exact=0.0081199205, y5/exact=2.6366 | yes |

## Scripts and GIFs
- No script changed and no GIF regenerated (text-only fix under R7-D/D7; the animation was not at fault).
- `git status --short -- pages/numerical-methods/adams-bashforth-moulton-method` → ` M pages/numerical-methods/adams-bashforth-moulton-method/index.qmd` only.

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/AdamsBashforthMod.html` contains Example 11 (the page's problem). The finding is a grammatical reference error in the page's own sentence and does not touch anything taken from the archive. The review had already matched all 21 m values and end values to Mathews' animation; nothing here changes them.

## Notes
- Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r8fix/adams-bashforth-moulton-method/fix/check.py` and `check.out`.
- No decision ambiguity.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: index.qmd line 41 now reads "(though $y(5)$ is still 2.6 times the exact value)", so the ratio is attached to y(5), not to the error. Independent Python ABM4 PECE (RK4 start) vs DOP853 reference (rtol 1e-13), check/indep.py: exact y(5)=0.00811992, m=12 y(5)=0.0214088, error=+0.013289, y(5)/exact=2.637 (-> "2.6", true), error/exact=1.64. Max run error 0.736 at t=4.1667 (page "0.74 at t≈4.17", unchanged and true).
### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.41-42 | "y(5)=0.0214" | indep ABM4 m=12: 0.0214088 | true |
| index.qmd l.41 | "off by only 0.013" | err 0.013289 | true |
| index.qmd l.41-42 | "$y(5)$ is still 2.6 times the exact value" | 0.0214088/0.00811992 = 2.637 | true |
### New problems
None. Rests on: the diff is a one-phrase text change on one line; all numbers in the changed sentence reproduced independently; no script or GIF changed.
### Reproducibility and conventions
- No script or GIF changed (git status of page folder shows only index.qmd), so no regeneration needed; GIF and alt text unchanged.
- Conventions intact: Description before Animations, Julia source link and one GIF embed with descriptive alt text, no code blocks.
- Outside the page folder, only reviews/numerical-methods-animations/fix-plan/README.md is modified, and it was already modified in the session-start snapshot (owner decisions file), not part of this fix.

**Final status:** committed
