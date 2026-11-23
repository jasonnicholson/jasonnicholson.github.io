# Fix record: accelerated-and-modified-newton-raphson

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r6fix/accelerated-and-modified-newton-raphson/fix/` (`inst/` instrumented script copies, `indep.py` independent check, `frames_aa`, `frames_bb`, `frames_cc`).

## Findings

### F1 — Minor — deferred
- Owner decision R6-C: the contrast from Case 1 to Case 2 is the point and tells the story well. Case 1's window, script, GIF and text were left alone.
- Jason has already decided this; nothing further is needed unless he reopens it.

### F2 — Minor — fixed
- Reproduced:
  - Each script has one iteration rule: `accnewtonaa.jl` l.27 `x - f/fp`; `accnewtonbb.jl` l.29 `x - m*f/fp` with m = 2; `accnewtoncc.jl` l.43 `modified_newton_step`.
  - The contact sheets of all three GIFs (`frames_*/sheet.png`) each show one method, with one title and one set of step lines.
  - So "Each animation below shows ... for three methods" is false when read literally.
- Change: `index.qmd` l.26, first sentence.
  - Before: "Each animation below shows a Newton-style line diagram for three methods applied to the same double root."
  - After: "The three animations below show a Newton-style line diagram for three methods, one per animation, applied to the same double root."
- Check: see the ledger. `git diff` shows this one line changed in the page folder.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.26 | "The three animations" | `grep -cE '^!\[.*\]\(accnewton(aa\|bb\|cc)\.gif\)$' index.qmd` → 3 | yes |
| index.qmd l.26 | "three methods, one per animation" | Rule lines above. Instrumented copies (`inst/accnewton{aa,bb,cc}.jl`, printing `xs`) give three different sequences: standard 1.2, 1.1030303, 1.0523564, ...; accelerated 1.2, 1.0060606, 1.0000061, ...; modified 1.2, 0.9941520, 0.9999943, .... `indep.py` (mpmath, 40 digits) applies the three rules separately and agrees: 1.103030303, 1.052356417; 1.006060606, 1.000006103; 0.9941520468, 0.999994278. Each GIF's title names one method (contact sheets). | yes |
| index.qmd l.26 | "applied to the same double root" | All three scripts define f = x³ − 3x + 2 and x0 = 1.2. sympy: `factor` → (x − 1)²(x + 2), f(1) = 0, f'(1) = 0, f''(1) = 6, so x = 1 is a root of multiplicity exactly 2. All three sequences approach 1: x12 = 1.0000520 (standard); x3 = 1.0000000000036 (accelerated); x3 = 1.0000000000084 (modified). | yes |

The sentence adds no new number. "Newton-style line diagram" is unchanged, and the following sentences of the paragraph already say that Case 2's line is not the tangent and that Case 3 plots h.

## Scripts and GIFs
- Scripts changed: none. GIFs regenerated in place: none (R6-C and the brief: no script or GIF changes on this page).
- Instrumented copies run in the scratch folder produced GIFs byte-identical to the committed ones (`cmp`, all three).
- Frames: contact sheets of all three GIFs viewed, to confirm one method per GIF.
- `git status --short -- pages/numerical-methods/accelerated-and-modified-newton-raphson`: ` M index.qmd` only.

## Legacy archive
Consulted, with a limit.
- The brief's `newtonaccelerate/NewtonAccelerateMod.html` is not at that path. The folder holds `NewtonAccelerateMod/Links/NewtonAccelerateMod_lnk_1..10.html` and `Images/`.
- The stripped link pages carry the example headings: Example 1 (lnk_2, lnk_3), 2 (lnk_4), 3 (lnk_5), 4 (lnk_6), 5 (lnk_7), 6 (lnk_8 to lnk_10). Their formulas are images, which I did not view.
- F2 concerns only how the page describes its own three GIFs, so the changed sentence does not rely on the archive. The page's sentence about Mathews' examples was not changed.

## Notes
- No decision ambiguity. R6-C fixes F2 as reported, and the review's suggested wording was used verbatim.
- No `quarto` and no state-changing git commands were run.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — out of scope (deferred by the owner, decision R6-C)
- Not assessed. The diff leaves Case 1's window and text unchanged, as R6-C requires.

### F2 — resolved
- Evidence: index.qmd line 26 now reads "The three animations below show a Newton-style line diagram for three methods, one per animation, applied to the same double root." The false reading (each GIF shows all three methods) is gone; a search of the page for "each animation", "each gif" and "three methods" finds only the corrected sentence.
- The replacement is true. Each script has a single iteration rule: accnewtonaa.jl standard Newton, accnewtonbb.jl x - 2f/f', accnewtoncc.jl x - f f'/(f'^2 - f f''). The final full-size frames carry one method's title each ("Standard Newton", "Accelerated Newton (m=2)", "Modified Newton (Method B)").
- All three use f = x^3 - 3x + 2, which sympy factors as (x-1)^2 (x+2), so x = 1 is the same double root in all three.
- The wording is the finding's suggested correction, verbatim.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:26 | "three animations" | 3 GIF embeds and 3 source links on the page | True |
| index.qmd:26 | "Newton-style line diagram" | Scripts draw the line from the curve at x_n to (x_{n+1}, 0) plus a vertical back to the curve; final frames show it | True |
| index.qmd:26 | "three methods, one per animation" | One iteration rule per script; one method in each GIF title | True |
| index.qmd:26 | "the same double root" | sympy: f = (x-1)^2 (x+2); all three scripts use this f and x0 = 1.2 | True |

The diff changes only this one sentence (1 insertion, 1 deletion). Independent iterates from x0 = 6/5 also agree with the unchanged page text: standard 1.103030, 1.052356, 1.026401, ..., x12 = 1.000052; accelerated 1.006061, 1.000006, 1.000000; modified 0.994152, 0.999994, 1.000000.

### New problems

None. This rests on the one-sentence diff, the ledger above, and the unchanged scripts and GIFs.

### Reproducibility and conventions

- No script or GIF changed in this fix (git diff against HEAD is empty for all six files).
- Scratch-copy runs of all three scripts reproduced the committed GIFs byte for byte (cmp).
- Frames extracted: aa 13, bb 6, cc 5. Final frames viewed at full size; titles, legends and marks are legible and correct. First and middle frames were not viewed, because no GIF changed.
- Conventions: Description (line 10) precedes Animations (line 24); 3 source links; 3 embeds with descriptive alt text; 0 code fences.
- Within this page folder only index.qmd is modified. The working tree also has changes in the mullers-method and pade-approximation folders and an untracked reviews/numerical-methods-animations-r6/fixes/ folder. These are not part of this page's diff.

**Final status:** committed
