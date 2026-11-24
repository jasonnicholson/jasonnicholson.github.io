# Fix record: mullers-method

## Findings

### F1 — Minor — fixed
- Reproduced: read Mathews' program in the archive image `n2003/mullersmethod/MullersMethodMod/Images/MullersMethodMod_gr_5.gif`. After computing `p3` it runs `If[Abs[p3-p1] < Abs[p3-p0], swap p0,p1]; If[Abs[p3-p2] < Abs[p3-p1], swap p1,p2]; p2 = p3`. I transcribed it, with the same step and "drop the oldest point" as the comparison: `/usr/bin/python3 -I scratch/r7fix/mullers-method/fix/mathews_rules.py` (Float64 and mpmath at 50 digits, start 2.2, 2.1, 2.0).

  | | Mathews' rule | Oldest point dropped |
  |---|---|---|
  | p3 | 1.1091314031 | 1.1091314031 |
  | p4 | 1.4944130474 | 1.4944130474 |
  | p5 | 1.0557604297 | 1.0557604297 |
  | p6 | 0.9964676201 | 0.9964676201 |
  | p7 | **0.9981213458** | **0.9972479592** |
  | p8 | 1.0000166310 | 1.0000089091 |
  | p9 | 0.9999987980 | 0.9999980057 |
  | p10 | 1.0000000056 | 1.0000000050 |

  The archive's printed table (images gr_40 onward, stacked in `scratch/.../fix/archive_lines2.png`) reads p3…p9 = 1.109131403118030, 1.494413047405179, 1.055760429685716, 0.996467620103290, 0.998121345843148, 1.000016631022576, 0.999998797979359. These agree with the "Mathews' rule" column, so the finding holds. In both runs the discriminant is positive only at the step that produces p7 (`disc>0 steps: [7]`); every other step drops the square root.
- Change: `index.qmd`, Case 1 Behavior. The text "…where $b$ is the parabola's slope at $p_2$, and its iterates…" becomes "…where $b$ is the parabola's slope at $p_2$. His program also keeps the two points nearest the new iterate rather than the two most recent, and its iterates…".
- Check: `/usr/bin/python3 -I scratch/.../fix/swap_check.py`. Over 200 000 random quadruples, the two swaps followed by `p2 = p3` keep exactly the two points nearest p3 (mismatches: 0). In the Example 1 run, the point discarded is the oldest at every step except the step to p6. That step discards 1.4944130474, not the oldest point 1.1091314031, so the two rules first differ at p7. This agrees with the finding.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 1 Behavior | "His program also keeps the two points nearest the new iterate rather than the two most recent" | `swap_check.py` → 0 mismatches in 200 000 random cases. Example 1: the discarded point is not the oldest at the step to p6, so the sequences first differ at p7 | yes |
| same sentence (unchanged numbers, now attributed to the two-rule program) | 1.1091, 1.4944, 1.0558, 0.9965; rise to 1.4944, drop below 1, approach 1 from both sides | `mathews_rules.py` → 1.1091314031, 1.4944130474, 1.0557604297, 0.9964676201, then 0.9981, 1.0000166, 0.9999988, 1.0000000056. These are above and below 1, and match the archive table | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. This is a text-only fix under R7-D.
- `git status --short -- pages/numerical-methods/mullers-method` → ` M pages/numerical-methods/mullers-method/index.qmd` only.

## Legacy archive
Consulted: `n2003/mullersmethod/MullersMethodMod/Images/`. There is no top-level `MullersMethodMod.html` in this copy, so the images are the source. `gr_5` is the program, with the square root dropped when b² ≤ 4ac and the farthest of the three points discarded. `gr_40` onward is the Example 1 run `Muller[2.2, 2.1, 2.0, 10]`, which my transcription reproduces. The page still animates its own real-part variant with the oldest point dropped, as R4-B and R6-A decided. It now describes both ways in which Mathews' program differs.

## Notes
- The page's introduction ("the oldest point is dropped") describes the page's own scripts and stays correct.
- The page has no `## Description` section. This is a convention gap that pre-dates round 7 and that no finding names, so I left it alone.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: index.qmd line 18 now adds "His program also keeps the two points nearest the new iterate rather than the two most recent". Checked against the archive program (MullersMethodMod_gr_5.gif): the swap `If[|p3-p1|<|p3-p0|] swap p0,p1` leaves the farther of p0, p1 in slot p1. The second swap `If[|p3-p2|<|p3-p1|] swap p1,p2` then leaves the farthest of the three in slot p2, and `p2 = p3` overwrites it. So the farthest point is discarded and the two nearest are kept. The statement is true.
- Independent recomputation (mpmath, 40 digits, check/m.py), start 2.2, 2.1, 2.0, square root dropped when b^2 <= 4ac. Nearest-two rule: p3..p10 = 1.1091314031, 1.4944130474, 1.0557604297, 0.9964676201, 0.9981213458, 1.0000166310, 0.9999987980, 1.0000000056. This matches the finding's archive column. Oldest-dropped rule: p7 = 0.9972479592, so the rules diverge at p7 as the finding says (at step 6 the nearest rule discards the middle point, not the oldest). A reader now has both rules needed to reproduce Mathews' sequence.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.18 | "keeps the two points nearest the new iterate rather than the two most recent" | traced the swap logic in the archive program; simulated it | correct |
| index.qmd l.18 | iterates 1.1091, 1.4944, 1.0558, 0.9965 (unchanged, now attributed to the nearest-two rule) | mpmath recomputation with the nearest-two rule | correct |
| index.qmd l.18 | "rise to 1.4944, drop below 1, and then approach 1 from both sides" | 0.99647 < 1, then 0.99812, 1.0000166, 0.9999988, 1.0000000056 | correct |
| index.qmd l.18 | "p3 = p2 - 2f(p2)/b, b the parabola's slope at p2" (unchanged) | archive: Z = -2c/(b+disc), with disc = 0 when b^2 <= 4ac, c = f(p2), b the linear coefficient in (x-p2) | correct |

### New problems
None. This rests on the following: the only change is one added clause in one sentence; the sentence reads grammatically; its claim is verified above; and the intro's "oldest point is dropped" still describes the page's own animations correctly, now with Mathews' difference stated explicitly.

### Reproducibility and conventions
- No script or GIF changed (git status of the page folder shows only index.qmd, 1 line). There is nothing to regenerate, and the GIFs are byte-identical to HEAD.
- Description precedes the Animations; each case has a source link and an embed; the alt text is unchanged and descriptive; there are no code blocks (0 backtick fences).
- The fix diff touches nothing outside the page folder. Other modified paths in the working tree belong to other pages' parallel fixes, not to this diff.

**Final status:** committed
