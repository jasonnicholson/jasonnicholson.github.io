# Fix record: least-squares-polynomials

Scratch folder: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/least-squares-polynomials/fix/` (`check.py`, `recheck.py`).

## Findings

### F1 — Minor — fixed
- **Reproduced:** `/usr/bin/python3 check.py` solves the normal equations exactly in sympy rationals for m = 2..5 and evaluates the printed coefficient forms exactly at the six nodes.
  - p5 as printed (5 d.p.): RMS **0.00285778**. Values at the nodes are 0.694196, 2.29897, 3.79998, 4.99999, 5.50027, 5.60377, so the largest miss is **0.005804**, at x = −4.5. The exact quintic has residuals [0, 0, 0, 0, 0, 0]. All printed coefficients are correct 5-d.p. roundings (`round-correct: True`).
  - p4 as printed: RMS **0.00735292**, which rounds to 0.00735 and not the stated 0.00734. The exact fit's RMS is 0.0073399680.
  - p2 and p3 as printed: RMS 0.0524515 and 0.0276737. These still round to the stated 0.05245 and 0.02767, so neither line needs a change.
- **Change:** `index.qmd` lines 67 and 77 (display equations only).
  - p4: `4.62863 + 0.49669x - 0.05823x^2 + 0.00201x^3 - 0.00080x^4` → `4.62863 + 0.496687x - 0.0582343x^2 + 0.00201395x^3 - 0.000801378x^4`. The RMS ≈ 0.00734 is unchanged.
  - p5: `4.63232 + 0.50885x - 0.06063x^2 - 0.00074x^3 - 0.00065x^4 + 0.00012x^5` → `4.63232 + 0.508854x - 0.0606259x^2 - 0.000737810x^3 - 0.000650515x^4 + 0.000116670x^5`. The label `(exact interpolation)` becomes `(exact interpolation; coefficients rounded to six significant figures)`, because even the six-figure form misses the data by up to 5.3e-6.
- **Check:** `/usr/bin/python3 recheck.py` parses the p_m lines from the edited `index.qmd` and evaluates them exactly.
  - m = 4: the printed coefficients equal the six-significant-figure rounding of the exact solution (`True`). The printed form's RMS is 0.00733997, which rounds to 0.00734.
  - m = 5: the printed coefficients equal the six-significant-figure rounding of the exact solution (`True`). The printed form's RMS is 3.83860e-6, and its largest |residual| is 5.309e-6.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:67 | p4 coefficients 4.62863, 0.496687, −0.0582343, 0.00201395, −0.000801378 | `recheck.py` → equals the 6-s.f. rounding of the exact solution (exact: 4.628628162, 0.4966872293, −0.05823430107, 0.002013949218, −0.0008013781535) | yes |
| index.qmd:67 | RMS ≈ 0.00734 (unchanged) beside the new form | `recheck.py` → printed-form RMS 0.00733997, exact 0.0073399680 | yes |
| index.qmd:77 | p5 coefficients 4.63232, 0.508854, −0.0606259, −0.000737810, −0.000650515, 0.000116670 | `recheck.py` → equals the 6-s.f. rounding of the exact solution (exact: 4.632323750, 0.5088535405, −0.06062594254, −0.0007378096658, −0.0006505146090, 0.0001166698791) | yes |
| index.qmd:77 | "RMS = 0 (exact interpolation; coefficients rounded to six significant figures)" | `check.py` → exact p5 residuals all 0; every coefficient has six significant figures (the leading 4.63232 included); the rounded form misses by at most 5.309e-6 | yes |

## Scripts and GIFs
- No script was changed and no GIF was regenerated. The finding is in the page text only, and the animations print only RMS values, which the review confirmed.
- `git status --short -- pages/numerical-methods/least-squares-polynomials` → ` M index.qmd` only.

## Legacy archive
- Consulted: `n2003/leastsquarespoly/LeastSqPolyMod/` (Links lnk_3–lnk_5 as text; images gr_62 and gr_70 viewed).
- gr_62 shows Mathews' p4 as `4.62863 + 0.496687x - 0.0582343x^2 + 0.00201395x^3 - 0.000801378x^4`, identical to the new page line.
- gr_70 shows p5 as `4.63232 + 0.508854x - 0.0606259x^2 - 0.00073781x^3 - 0.000650515x^4 + 0.00011667x^5`. This is Mathematica's six-significant-figure display with the trailing zeros dropped. The page writes `0.000737810` and `0.000116670`, so that six figures are visible. The values are the same, and both were computed (the exact digits are in the ledger).

## Notes
- The review offered two options: six-significant-figure coefficients, or ≈ with a rounding note. I took the six-figure option, which is the one the review suggests and matches the archive, and added a short rounding note to the p5 label, because "RMS = 0" is still not true of the rounded form (5.3e-6 miss).
- p2 and p3 keep their 5-d.p. coefficients. Their printed forms reproduce the stated RMS to the printed precision, so the four lines now differ in precision; nothing else was changed.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: exact rational normal-equation solve (sympy, `check/chk.py`) for the six data points gives
  p4 = 4.628628162, 0.4966872293, -0.05823430107, 0.002013949218, -0.0008013781535 (RMS 0.0073399680) and
  p5 = 4.632323750, 0.5088535405, -0.06062594254, -0.0007378096658, -0.0006505146090, 0.0001166698791 (RMS 0 exactly, 3.9e-31 at 30-digit evaluation).
- Every new printed coefficient on lines 67 and 77 is the correct six-significant-figure rounding of the exact value.
- Printed p5 now has RMS 3.84e-6, largest residual 5.3e-6 (at x = -4.5), versus 0.00286 / 0.0058 before. The "RMS = 0" claim is now qualified with "coefficients rounded to six significant figures", so the reader is told the printed form is rounded and why it misses by about 5e-6.
- Printed p4 now has RMS 0.00733997, which rounds to the stated 0.00734 (before, 0.007353).
- No script or GIF was involved in the finding, and none changed.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:67 | 4.62863, 0.496687, -0.0582343, 0.00201395, -0.000801378 | exact solve, 6 s.f. rounding | correct |
| index.qmd:67 | RMS ≈ 0.00734 (unchanged) | true 0.0073400; printed-coefficient 0.0073400 | correct |
| index.qmd:77 | 4.63232, 0.508854, -0.0606259, -0.000737810, -0.000650515, 0.000116670 | exact solve, 6 s.f. rounding | correct |
| index.qmd:77 | "RMS = 0 (exact interpolation; coefficients rounded to six significant figures)" | true RMS exactly 0; printed form RMS 3.8e-6, so the qualifier is needed and accurate | correct |

### New problems
None. Rests on: the exact recomputation above; the diff touches only two display-math lines; p2 and p3 (unchanged) at their printed 5-decimal precision give RMS 0.05245 and 0.02767, matching the stated values.

### Reproducibility and conventions
- No script or GIF in the page folder changed (git status shows only index.qmd), so there is nothing to regenerate.
- Description precedes Animations; each case keeps its source link and embed; alt text unchanged and descriptive; no code blocks.
- No file outside the page folder is attributable to this fix (the diff and `git diff --stat` cover only index.qmd; other modified files in the working tree belong to other pages' fixes).

**Final status:** committed
