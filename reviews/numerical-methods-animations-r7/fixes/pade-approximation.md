# Fix record: pade-approximation

Scratch: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/pade-approximation/fix/` (`legacy/` holds the extracted legacy frames and the label strips `*_col.png`, `six.png`, `last6.png`).

## Findings

### F1 — Minor — deferred
- Owner decision R5-C, repeated by R7-A: the pole spikes in Cases 22–27 (and the other listed frames) are left as drawn. Not reproduced or changed this round. Jason would need to reverse R5-C for this to be fixed (the review's residue-based extra-sample suggestion is untested).

### F2 — Minor — fixed
- Reproduced:
  - Page: `index.qmd` line 86 says only "one Padé order per frame"; nothing about the departure from Mathews.
  - Script: `max_total` is 10 for Cases 01–11, 13–16, 18–21 and 8 for Cases 12, 17, 22–27 (grep of the case table, see ledger). `order_pairs(M)` yields every (m, n) with m+n ≤ M: 66 entries for M = 10, 45 for M = 8 (Julia check, ledger).
  - Archive: 11 legacy GIFs survive in `a2001/Animations/Interpolation/Pade/` (Pade01, 02, 03, 05, 06, 08, 11, 12, 16, 17, 18), with 20, 20, 20, 20, 20, 20, 18, 12, 18, 20, 17 frames (`giftools.jl`). All are titled "Pade Approximation / Convergence Intervals" and show a green "Tolerance ±0.001" or "±0.01" bar (viewed: `Padehh/sheet.png`, `Padell/sheet.png`, `last6.png`). Label strips of every frame (`*_col.png`, `six.png`) show the sequence S1,1, S2,2, …, each shown twice, ending S9,9 for Pade01, 02, 03, 05, 06, 08, 17; S8,8 for Pade16; S5,5 for Pade12 (sheet); and S2,1, S3,2, …, S9,8 for Pade11 and Pade18. So the surviving originals follow the diagonal or the next-to-diagonal, reaching total order 18 at most. The finding holds.
- Change: `index.qmd` line 86, appended one sentence to the Animations introduction (R7-B, R7-D: one sentence, no restored display):
  - before: "Each animation shows one Padé order per frame for a fixed center $x_0$, overlaid on the target function."
  - after: same, plus "Unlike Mathews' surviving original animations, which stepped along the diagonal (or next-to-diagonal) entries of the Padé table, up to total order 18, and marked a tolerance interval, these step through every entry $[m/n]$ with $m+n\le 10$ ($m+n\le 8$ in Cases 12, 17 and 22–27)."
  - "surviving" is used because the other 16 legacy GIFs are not in the archive, so their sequences cannot be determined; the sentence makes no claim about them.
- Check: ledger below. No script or GIF change, so nothing regenerated.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.86 | "Mathews' surviving original animations" | `find …/a2001/Animations -iname '*pade*'` → GIFs only in Pade01, 02, 03, 05, 06, 08, 11, 12, 16, 17, 18 (11 of 27) | yes |
| index.qmd l.86 | "stepped along the diagonal (or next-to-diagonal) entries" | label strips of every frame (`legacy/*_col.png`, `six.png`, `Padell/sheet.png`) → S_{k,k} in 9 GIFs, S_{k+1,k} in Pade11 and Pade18 | yes |
| index.qmd l.86 | "up to total order 18" | last frames: S9,9 (total 18) in Pade01, 02, 03, 05, 06, 08, 17; S9,8 (17) in 11, 18; S8,8 (16) in 16; S5,5 (10) in 12 → max 18 | yes |
| index.qmd l.86 | "marked a tolerance interval" | `last6.png`, `Padehh/sheet.png`, `Padell/sheet.png` → green bar labelled "Tolerance ±0.001" (sqrt cases) or "±0.01" (log, sin, tan, asin) | yes (describes the picture; the bar's extent was not recomputed) |
| index.qmd l.86 | "every entry $[m/n]$ with $m+n\le 10$" | `julia -e 'order_pairs(10)…'` → frames=66, maxsum=10, set equals all (m,n) with m+n≤10: true | yes |
| index.qmd l.86 | "$m+n\le 8$ in Cases 12, 17 and 22–27" | grep of case table → `max_total=8: 12 17 22 23 24 25 26 27`, `max_total=10:` all others; `order_pairs(8)` → 45 frames, set complete: true | yes |

## Scripts and GIFs
- No scripts changed; no GIFs regenerated (brief: no script or GIF changes on this page).
- `git status --short -- pages/numerical-methods/pade-approximation` → ` M pages/numerical-methods/pade-approximation/index.qmd` only.

## Legacy archive
- Consulted. `a2001/Animations/Interpolation/Pade/Pade.html` lists 27 cases (formulas are images; text gives only "Pade Approximation for … with center … over the interval"). 11 GIFs survive; their content is as described under F2. The page keeps its own fuller sweep of the Padé table (a valid view) and now states the difference, as R7-B directs; the tolerance overlay and higher orders were not restored.

## Notes
- No ambiguity in the decision: R7-B and the brief specify one sentence only.
- Nothing outside the page folder was touched apart from this record.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — deferred (owner decision)
- Evidence: `git status`/`git diff --stat HEAD` for the page folder show only `index.qmd` changed (1 line). `pade_animations_all.jl` and all 27 GIFs are unchanged, so pole drawing is untouched, as decisions R5-C / R7-A require.

### F2 — resolved
- Evidence: the Animations intro (index.qmd line 86) now adds one sentence stating that Mathews' surviving originals stepped along diagonal or next-to-diagonal entries up to total order 18 and marked a tolerance interval, while these step through every [m/n] with m+n<=10 (<=8 in Cases 12, 17, 22-27).
  - Legacy check: extracted all frames of the 11 surviving legacy GIFs (Padeaa, bb, cc, ee, ff, hh, kk, ll, pp, qq, rr) into scratch `check/legacy/*`. Titles read "Pade Approximation / Convergence Intervals". Every frame has a green "Tolerance ±0.01/±0.001" bar. The sequences are S1,1..S9,9 for sin (hh) and asin (qq), S2,1..S9,8 for cos (kk) and J0 (rr), S1,1..S8,8 for atan (pp) and S1,1..S5,5 for tan (ll). So the entries are diagonal or next-to-diagonal, and the maximum total order is 9+9 = 18. The sentence is true.
  - Script check: `order_pairs(max_total)` enumerates every (m, total-m) for total = 0..max_total. In the case table `max_total` = 8 for exactly cases 12, 17, 22, 23, 24, 25, 26, 27 and 10 for all others.
  - GIF check: the frame counts are 66 = sum_{t=0}^{10}(t+1) for the 19 cases with max_total 10, and 45 = sum_{t=0}^{8}(t+1) for the 8 cases with max_total 8. They match.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:86 | "Mathews' surviving original animations" | 11 of 27 legacy GIFs present in archive | correct |
| index.qmd:86 | "diagonal (or next-to-diagonal) entries" | legacy titles S_{k,k} (hh, pp, qq, ll) and S_{k+1,k} (kk, rr) | correct |
| index.qmd:86 | "up to total order 18" | max legacy entry S9,9 (hh, qq), 9+9=18 | correct |
| index.qmd:86 | "marked a tolerance interval" | green Tolerance ±0.01 bar in every legacy frame | correct |
| index.qmd:86 | "every entry [m/n] with m+n<=10" | order_pairs code; 66 frames per GIF | correct |
| index.qmd:86 | "m+n<=8 in Cases 12, 17 and 22–27" | max_total=8 for exactly these 8 cases; their GIFs have 45 frames | correct |

### New problems
None. This rests on the following: the diff is a single added sentence, and every claim in it was checked against the legacy frames, the script and the GIF frame counts. No script or GIF was changed.

### Reproducibility and conventions
- No script or GIF changed, so no regeneration is needed. The committed GIFs are the HEAD versions.
- Description comes before Animations. There are 27 embeds with alt text, 27 per-case "Julia source" links plus the all-cases link, and no code blocks (no ``` in index.qmd).
- No file outside the page folder is touched for this page. The other modified paths in the repo belong to other pages under review in this round, and the untracked review files are not part of this fix.

**Final status:** committed
