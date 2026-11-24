# Fix record: halleys-method

Scratch folder: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/halleys-method/fix/` (`timing.jl`, `timing.py`).

## Findings

### F1 — Minor — fixed
- Reproduced: independent timing scripts, written from the page's formulas (not the reviewer's scripts). Both compute √2 from x₀ = 2 with f = x² − 2 and stop at |x − √2| < 10⁻²⁰⁰⁰⁰.
  - `julia timing.jl` (MPFR, 66,503 bits, 200 shuffled repetitions per method, median), run twice:
    - iterations: Newton 15, Halley line-18 form 10, Halley line-22 form 10
    - run 1: Newton 4.969 ms (1.000), line 18 5.295 ms (1.066), line 22 10.944 ms (2.202)
    - run 2: Newton 7.317 ms (1.000), line 18 7.154 ms (0.978), line 22 15.485 ms (2.116)
  - `/usr/bin/python3 -I timing.py` (mpmath 20,020 digits, backend `python`, 60 shuffled repetitions, median): iterations 15 / 10 / 10; Newton 59.35 ms (1.000), line 18 67.94 ms (1.145), line 22 126.4 ms (2.13).
  - So the iteration counts hold for both forms. "About as long or slightly longer" holds for the line-18 form (0.98 to 1.15 here, 1.00 to 1.02 in the review). The line-22 form as written takes 2.1 to 2.2 times as long in my runs and 1.78 to 1.91 in the review's. The finding holds. The review's optional wording "nearly twice as long" is contradicted by my runs, which come out above 2, so the page says "about twice as long" instead, which covers 1.8 to 2.2.
  - Division count: line 18 has one division (2ff′ / (2f′² − ff″)). Line 22 as written has three: f/f′, ff″/(2f′²) and 1/(1 − …). That makes two more, and both scripts code it exactly that way.
- Change: `index.qmd` line 40. "with the formulas above" → "with the first formula above". Appended "(the second form, evaluated as written, does two more divisions per step and takes about twice as long as Newton)".
- Check: the timing runs above. `git diff` shows only that sentence changed.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.40 | "with the first formula above" … Halley 10 iterations, Newton 15 | `julia timing.jl` → iterations h18 10, newton 15; `timing.py` → same | yes |
| index.qmd l.40 | "about as long or slightly longer" (now tied to the first formula) | ratios 1.066, 0.978 (Julia), 1.145 (mpmath) | yes |
| index.qmd l.40 | "the second form, evaluated as written, does two more divisions per step" | count by inspection: 3 against 1, coded that way in `h22`/`h18` | yes |
| index.qmd l.40 | "takes about twice as long as Newton" | ratios 2.202, 2.116 (Julia), 2.13 (mpmath); review 1.78 to 1.91 | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. The finding is text-only (R7-D).
- `git status --short -- pages/numerical-methods/halleys-method` → ` M pages/numerical-methods/halleys-method/index.qmd` only.

## Legacy archive
I consulted `n2003/halleysmethod/Halley'sMethodMod/Links/*.html` as text. The module compares Newton and Halley by accurate digits per step at 100-digit precision ("doubling" against "tripling") and concludes "Halley's method is faster than Newton's" in that sense. It makes no wall-clock timing claim, so it has no bearing on F1.

## Notes
- Absolute times depend on the machine and the big-number library. The page states ratios only loosely ("about as long", "about twice"), and both MPFR and mpmath support that wording.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: line 40 now says "with the first formula above" (the line 18 one-division form, which is the first displayed formula; Newton's formula is not displayed) and adds "(the second form, evaluated as written, does two more divisions per step and takes about twice as long as Newton)".
- Independent timing, with each formula evaluated literally from f, f', f'' and shuffled interleaved repetitions, on a loaded 12-core machine (load average about 5):
  - Julia MPFR at 66,503 bits, 200 reps per method, 3 seeds. Median ratio to Newton: H1 (line 18) 1.004 / 1.000 / 1.007, H2 (line 22) 2.169 / 2.147 / 2.140. Ratios of the minima were similar (H1 0.992 to 1.018, H2 2.146 to 2.189).
  - mpmath at 20,020 dps (Python backend), 60 reps per method, 2 seeds. H1 1.022 / 1.021, H2 1.977 / 2.005.
  - Combined with the review's 1.78 to 1.91, the line 22 ratio spans about 1.8 to 2.2 across implementations and runs. "About twice" holds up on all of them; "nearly twice" would not have fit my Julia runs, which were above 2. The line 18 ratio spans 1.00 to 1.02 on every run, so "about as long or slightly longer" holds.
- Iteration counts: 15 (Newton) and 10 (both Halley forms) to reach 20,000 digits; one iteration fewer gives 12,542 and 15,068 digits respectively. Unchanged and correct.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.40 | "with the first formula above" | The first displayed formula is line 18. Timing ratio 1.00 to 1.02 | True |
| index.qmd l.40 | "Halley needs 10 iterations against Newton's 15" (unchanged) | MPFR and mpmath: 10/15 to ≥20,000 digits; 9/14 fall short | True |
| index.qmd l.40 | "about as long or slightly longer" (now scoped to first form) | 1.000 to 1.022 over 5 runs in 2 implementations | True |
| index.qmd l.40 | "the second form, evaluated as written, does two more divisions per step" | Line 22: f/f', f f''/(2f'^2), 1/(1-…) = 3 divisions vs 1 in line 18 | True |
| index.qmd l.40 | "takes about twice as long as Newton" | 1.98 to 2.17 (mine), 1.78 to 1.91 (review) | True (robust across runs and implementations) |

### New problems
None. This rests on: the diff is a single sentence edit, every claim in it was checked above, and the rest of the page is untouched.

### Reproducibility and conventions
- No script or GIF changed (fix.diff and `git status` of the page folder show only index.qmd), so there was nothing to regenerate.
- The page still has Description before Animations, a Julia source link and an embed with descriptive alt text for each of the 3 cases, and no code blocks.
- Nothing else in the page folder changed. Other modified paths in the repo belong to other pages or to untracked review files, not to this fix.

**Final status:** committed
