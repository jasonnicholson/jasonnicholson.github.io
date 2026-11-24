# Fix record: romberg-integration

## Findings

### F1 — Minor — fixed
- Reproduced: `julia scratchpad/r7fix/tools/giftools.jl pages/numerical-methods/romberg-integration/rombergaa.gif scratchpad/r7fix/romberg-integration/fix/frames` → "9 frames", 9 distinct frame md5s. `frame_001.png` (full size) shows only the magenta curve f in the graph panel (no trapezoids, no "Sample Points"/"R[k,k]" labels) and the table panel with its header and `I = 2.016280` but no rows. `frame_002.png` shows the first row (`1 2 2.017925 2.017925 +1.6e-03`); `frame_009.png` shows rows 1–8. The contact sheet shows one row added per frame from frame 2 to frame 9. Script: `for frame in 0:n_levels` (n_levels = 8), rows drawn by `for k in 1:frame`, empty at frame = 0. So 9 frames, 8 rows; the claim "each frame adds one row" is false for frame 1.
- Change: `index.qmd` only (text; D7/R7-D, the picture does not mislead).
  - Line 33 Behavior: "Each frame adds one Romberg row …" → "After an opening frame that shows $f$ alone with an empty table, each frame adds one Romberg row …".
  - Line 37 alt text: "the Romberg table adds one row per frame, listing …" → "the Romberg table adds one row per frame after an opening frame that shows f alone, listing …".
- Check: the new wording matches frame_001 (f only, table without rows) and frames 2–9 (one row each, 8 rows total), as viewed above. No script or GIF change, so nothing to regenerate.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.33 Behavior | "After an opening frame that shows $f$ alone with an empty table" | giftools on committed GIF → frame_001.png: curve only, table header + I line, no rows | yes |
| index.qmd l.33 Behavior | "each frame adds one Romberg row" (now after the opening frame) | sheet.png / frame_002, frame_009: rows 1..k appear in frame k+1, k = 1..8 | yes |
| index.qmd l.37 alt text | "adds one row per frame after an opening frame that shows f alone" | same frames as above; 9 frames total ("9 frames" from giftools) | yes |

No numbers were added or changed.

## Scripts and GIFs
- Scripts changed: none. GIFs regenerated: none (text-only fix).
- Frames viewed (committed GIF): frame_001, frame_002, frame_009 at full size, and the contact sheet of all 9.
- `git status --short -- pages/numerical-methods/romberg-integration` → ` M pages/numerical-methods/romberg-integration/index.qmd` only.

## Legacy archive
Consulted. `n2003/rombergquad/RombergMod/Links/RombergMod_lnk_7.html` (Example 6, tol = 0.001, sample points 2, 3, 5, …, 129, Animation 1) and `a2001/Animations/Quadrature/Rombeg/Rombergaa.gif` (9 frames). Mathews' GIF also opens on f alone (its first two frames show only the curve and a "Romberg Rules For Numerical Quadrature" title; the shaded frames start at 3 sample points, so his GIF has no m = 2 frame). The page's script draws an m = 2 frame, which matches his Example 6 table; this difference is not a finding and was not changed.

## Notes
- No decision ambiguity: R7-D/D7 text fix as the review suggested, worded slightly differently ("with an empty table") to describe the opening frame's table panel accurately (it shows the header and I but no rows).

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: Frames extracted from the committed `rombergaa.gif` (unchanged by the fix): 9 frames. Frame 1 at full size shows only the magenta curve f, no trapezoid panels, no "Sample Points"/"R[k,k]" annotations, and a table panel with only the column header and the `I = 2.016280` footer, with no rows. Frame 2 shows one panel (m=2) and row 1. Frame 9 shows 128 panels and rows 1 to 8. The script matches: `for frame in 0:n_levels`, panels only `if frame > 0`, rows `for k in 1:frame`. The new line 33 text ("After an opening frame that shows $f$ alone with an empty table, each frame adds one Romberg row ...") and the new alt text ("adds one row per frame after an opening frame that shows f alone") are both true. Calling the table "empty" is fair, since it has no data rows; the header and the I footer are labels.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.33 | "After an opening frame that shows $f$ alone with an empty table" | frame_001.png full size; script lines 36, 42, 70 | true |
| index.qmd l.33 | "each frame adds one Romberg row" (now frames 2 to 9) | frames 2 to 9 add rows 1 to 8 | true |
| index.qmd l.33 (unchanged numbers on the same diff line) | errors 1.6e-3, 0.47, 0.46, 0.046, 8.1e-3, 2.8e-3, 8.7e-4, 2.7e-4; R88 = 2.016007; I ≈ 2.016280; ratio 3.18; 2^{5/3} ≈ 3.17; factor 4.4 | Independent Python Romberg table; I from mpmath quad after substituting x = t^3 (2.0162797196170963...): errors +1.65e-3, +4.75e-1, -4.63e-1, -4.64e-2, -8.11e-3, -2.76e-3, -8.69e-4, -2.73e-4; ratio 3.183; 2^{5/3} = 3.175; T/R88 error ratio 4.39 | true |
| index.qmd l.33 (unchanged) | diagonal least accurate in its row at m=3 and m=5, most accurate from m=9 on | per-column errors from the same table | true |
| index.qmd l.37 alt | "adds one row per frame after an opening frame that shows f alone" | frames as above | true |

### New problems
None. This rests on the diff touching only two sentences in index.qmd, both checked against the full-size frames and the script, and on the unchanged numbers in the same diff line all reproducing independently.

### Reproducibility and conventions
- Neither the script nor the GIF was changed (`git status --porcelain` of the page folder shows only `index.qmd`), so there was nothing to regenerate. The committed GIF matches the script logic frame by frame.
- Conventions kept: Description comes before Animations, the case has a source link and a GIF embed, the alt text is descriptive, and there are no code blocks. The fix diff touches only the page folder. Other modified files in the working tree belong to other pages' in-progress fixes and are not part of this diff.

**Final status:** committed
