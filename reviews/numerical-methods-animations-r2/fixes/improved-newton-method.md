# Fix record: improved-newton-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/improved-newton-method/fix/` (`f1.jl`, `up.jl`, `sheet.jl`, `arch/*.png`).

## Findings

### F1 — Minor — fixed
- Reproduced: `julia f1.jl` (computes the script's Method A iterates with the factored f and evaluates both forms):
  - `x3=1.000000000132272`
  - `1.00000000013 expanded=0.0 factored=5.0700008392070965e-20`
  - `1.000000000132272 expanded=0.0 factored=5.248762306108197e-20`
  - `1.0000000001300002 (nextfloat) expanded=0.0 factored=5.070018158702506e-20`
  - Independent: `/usr/bin/python3 -I` mpmath (40 digits), (x−1)²(x+2) at x = 1 + 1.3e-10 → `5.0700000002197e-20`.
  The expanded form gives exactly 0.0, not 2.2e-16. The comment's 5.1e-20 and its "loses all accuracy" conclusion are correct.
- Change: `newtonimpbb.jl` line 13, `= 2.2e-16 instead of 5.1e-20` → `= 0.0 instead of 5.1e-20`.
- Check: the comment now matches the output above. The script was regenerated, and `md5sum newtonimpbb.gif` gave `800fd63e2d1ddec3979088746f55bf6a` both before and after, so the GIF is byte-identical.

### F2 — Minor (Fidelity) — fixed (R2-A: one "not animated" sentence; the example was not added)
- Reproduced from the archive (`n2003/NewtonImprovedMod.html` and `newtonimproved/NewtonImprovedMod/Links/NewtonImprovedMod_lnk_{4,5,6}.html`, stripped to text):
  - The module has exactly three examples. `grep` of "Example" in the stripped text gives 1, 2 and 3, linked to lnk_4, lnk_5 and lnk_6.
  - Each statement reads "compare Methods A,B and C for finding the double / triple / quadruple root".
  - Each solution page has the "Using formula (11) Method B" and "Using formula (13) Method C" sections.
  - Statement images (upscaled 4×, `arch/stmts.png`, `arch/ex3a.png`):
    - Ex 1: p₀ = 1.3, p = 1, x³−3x+2.
    - Ex 2 (gr_165–167): p₀ = 1.3, p = 1, x⁴−x³−3x²+5x−2.
    - Ex 3 (gr_191–193): p₀ = 1.3, p = 1, x⁵−2x⁴−2x³+8x²−7x+2.
  - sympy `factor` gives (x−1)²(x+2), (x−1)³(x+2) and (x−1)⁴(x+2), so the roots are double, triple and quadruple at x = 1.
  - Standard Newton from 1.3 on the Ex 3 quintic gives p₁ = 1.226666666666667 (sympy), the same as Mathews' printed p₁ = 1.226666666666666 (gr_197).
- The page's coverage, from `grep 'xs\[i+1\] ='` on the scripts:
  - aa, cc and ee use `x - f/fp` (standard Newton); bb and dd use `x - m*f/fp` (Method A).
  - No script computes Method B or Method C, and none uses the quintic.
  - Scripts aa and bb use x³−3x+2 (bb in factored form) with x0 = 1.3, m = 2 for bb. Scripts cc and dd use x⁴−x³−3x²+5x−2 (dd factored) with x0 = 1.3, m = 3 for dd. Mathews' Ex 1 and Ex 2 solutions use standard Newton and Method A with m = 2 and m = 3 respectively.
- Change: `index.qmd`, a new paragraph at the end of the Animations intro, before "### Case 1". It was first placed after the Case 5 embed and moved here after the check; see "Round 2 after check". The text: "Cases 1–4 follow Examples 1 and 2 of Mathews' Improved Newton Method module; the module's Example 3, which compares the methods at a quadruple root, and the Method B and Method C iterations of all its examples are not animated here."
- Check: see the ledger. The examples are named by kind, not by formula, the sentence has no computed numbers, and it uses "are not animated here" as the pattern asks.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| newtonimpbb.jl l.13 | "f(1 + 1.3e-10) = 0.0" | `julia f1.jl` → `expanded=0.0` | yes |
| newtonimpbb.jl l.13 (unchanged) | "instead of 5.1e-20" | mpmath → 5.0700000002197e-20; Julia factored → 5.0700008392070965e-20 | yes |
| index.qmd, Animations intro | "Cases 1–4 follow Examples 1 and 2 of Mathews' Improved Newton Method module" | Archive statement images: Ex 1 is x³−3x+2, p₀ = 1.3; Ex 2 is x⁴−x³−3x²+5x−2, p₀ = 1.3. Script grep: aa/bb use that cubic and cc/dd that quartic, all with x0 = 1.3; Method A m = 2 / 3 as in lnk_4/lnk_5 | yes |
| index.qmd, Animations intro | "the module's Example 3, which compares the methods at a quadruple root" | lnk_6 statement says "compare Methods A,B and C for finding the quadruple root". sympy factor of gr_193's polynomial → (x−1)⁴(x+2) | yes |
| index.qmd, Animations intro | "the Method B and Method C iterations of all its examples are not animated here" | lnk_4/5/6 each contain the Method B (11) and Method C (13) sections. No page script computes B or C (grep of the update lines) | yes |

## Scripts and GIFs
- Script changed: `newtonimpbb.jl`, a comment only.
- GIF regenerated: `newtonimpbb.gif`, which came out byte-identical (md5 `800fd63e2d1ddec3979088746f55bf6a` before and after). No frames needed viewing because the pixels are unchanged.
- `git status --short -- pages/numerical-methods/improved-newton-method` after regeneration: ` M index.qmd`, ` M newtonimpbb.jl`.

## Legacy archive
- Consulted: `n2003/NewtonImprovedMod.html` and its `newtonimproved/NewtonImprovedMod/` Links and Images.
- What it showed: three examples (double, triple and quadruple root of (x−1)^m(x+2), all with p₀ = 1.3), each comparing standard Newton and Methods A, B and C.
- The module has no animation of its own. Its "Animations" link points to `a2001/Animations/RootFinding/NewtonMethod/NewtonMethod.html`, the general Newton's-method animation, so there is no legacy GIF to compare.
- Cases 1–4 match Examples 1–2. Case 5 (arctan) is not from this module.
- Archive inconsistencies, noted and not carried onto the page:
  - The Example 3 solution text says "Method A … with m=3" for a root of multiplicity 4.
  - Its code image (gr_194) prints "to find the double root".
  - The page sentence names Example 3 only by kind ("quadruple root"), which sympy confirms.

## Round 2 after check
- The checker found the F2 sentence correct but misplaced. Sitting after the Case 5 image, inside "### Case 5", it read as part of Case 5.
- Moved it, wording unchanged, to the end of the Animations section's introductory text. It is now its own paragraph after "Julia source scripts that generated these animations are linked under each case." and before the "### Case 1" heading.
- The page has no legacy/source note outside the case subsections, so this is the page-level spot.
- No script or GIF changed. The ledger entries for the sentence still apply as written.

## Notes
- The Description sentence "The animations show standard Newton and Method A; Case 5 also discusses Methods B and C." was left unchanged. It is still true.
- R2-A says to add a sentence, not the example, so no Example 3 animation and no B/C animation was added.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The comment in `newtonimpbb.jl` (lines 11–12) now reads "(Float64 gives f(1 + 1.3e-10) = 0.0 instead of 5.1e-20)".
- I recomputed this in Julia:
  - the expanded form `x^3-3x+2` at `1+1.3e-10` gives `0.0`, and the factored form gives `5.0700008392070965e-20`, which rounds to 5.1e-20;
  - at `nextfloat` the expanded form gives `0.0`;
  - at the actual x₃ = 1.000000000132272 the expanded form gives `0.0`, and the factored form gives 5.25e-20.
- The old value 2.2e-16 is what `prevfloat(1+1.3e-10)` gives, which explains the old error. The new statement is true.
- The change touches only a comment, so the code and the GIF are unaffected. The iterates are still 1.3, 1.01304, 1.0000282, 1.000000000132272.

### F2 — resolved
- The fixer chose the "one sentence" option, which round-2 decision R2-A prescribes ("Add one sentence when a whole Mathews example ... is left out ... Do not add the example"). The sentence added to `index.qmd` is: "Cases 1–4 follow Examples 1 and 2 of Mathews' Improved Newton Method module; the module's Example 3, which compares the methods at a quadruple root, and the Method B and Method C iterations of all its examples are not animated here."
- I checked it against the legacy `NewtonImprovedMod.html`, "Module for The Improved Newton Method":
  - **Example 1** is x³−3x+2 (gr_126) with a double root. That matches Cases 1–2.
  - **Example 2** is x⁴−x³−3x²+5x−2 (gr_167) with a triple root. That matches Cases 3–4.
  - **Example 3** is "compare Methods A,B and C for finding the quadruple root" of x⁵−2x⁴−2x³+8x²−7x+2 (gr_193). SymPy factors it as (x−1)⁴(x+2), so the root is quadruple.
  - All three examples say "compare Methods A,B and C".
  - None of the five scripts computes Method B or Method C, which I confirmed by reading the scripts the page links.
- Every part of the sentence is true. Together with the existing Description sentence ("The animations show standard Newton and Method A; Case 5 also discusses Methods B and C"), the omission is now disclosed.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| newtonimpbb.jl comment | expanded f(1+1.3e-10) = 0.0 in Float64 | Julia: `0.0` (also 0.0 at nextfloat and at x₃) | correct |
| newtonimpbb.jl comment | factored value 5.1e-20 | Julia: 5.0700008392070965e-20; exact (1.3e-10)²·(3+1.3e-10) = 5.07e-20 | correct |
| index.qmd, new sentence | "Cases 1–4 follow Examples 1 and 2" | Legacy gr_126 and gr_167 functions match the Case 1–4 functions. The starting point 1.3 was verified in round 1. | correct |
| index.qmd, new sentence | "Example 3 ... compares the methods at a quadruple root" | Legacy text: "compare Methods A,B and C for finding the quadruple root". SymPy factors the polynomial as (x−1)⁴(x+2). | correct |
| index.qmd, new sentence | "Method B and Method C iterations of all its examples are not animated" | No script implements B or C. Every legacy example compares A, B and C. | correct |
| index.qmd, new sentence | "Improved Newton Method module" | Legacy title is "Module for The Improved Newton Method" | correct |

### New problems
- **Minor (placement)**, `index.qmd`, after the Case 5 image. The new sentence describes the scope of Cases 1–4 and the Animations section as a whole, but it sits after Case 5's embed, inside the `### Case 5` subsection. In the rendered page it reads as part of Case 5. It would fit better in the Animations intro paragraph or the Description, next to "The animations show standard Newton and Method A ...". The content is true; only the position is awkward.

Apart from that, I found no new problems. That conclusion rests on these checks:
- the comment's numbers, recomputed;
- every claim in the new sentence, checked against the legacy module and SymPy;
- no GIF was changed;
- the regenerated `newtonimpbb.gif` is byte-identical to the committed one.

### Reproducibility and conventions
- **Reproducibility:**
  - No GIF in the page folder was changed; `git status` lists only `index.qmd` and `newtonimpbb.jl`.
  - I ran a scratch copy of `newtonimpbb.jl`. Its output `newtonimpbb.gif` is byte-identical (`cmp`) to the committed `newtonimpbb.gif`.
  - With no changed GIFs, there were no regenerated frames to inspect.
- **Conventions:**
  - Description comes before Animations.
  - Each of the 5 cases has a `[Julia source]` link and an embed with descriptive alt text.
  - The page has no code blocks.
- **Scope:** `git diff HEAD --stat` for the page folder shows only `index.qmd` (+2) and `newtonimpbb.jl` (+1/−1). The fix diff contains no file outside the page folder. Other modified files in the working tree belong to other pages' parallel fixes.

### Re-check
I checked the updated `fix.diff` against the working tree.

- **Reads as page-level: yes.** The sentence is now its own paragraph at `index.qmd` line 30. It is the last paragraph of the `## Animations` intro, after "Julia source scripts ... are linked under each case." and before `### Case 1`. It is no longer inside any case subsection. `grep` finds only one copy, so the old copy after the Case 5 image is gone. The diff against HEAD for `index.qmd` is now a single 2-line addition at that spot.
- **Wording unchanged and still true: yes.** The text is character-for-character the same as the version I checked above.
  - Each claim still holds: Examples 1 and 2 are the Case 1–4 functions; Example 3's root is quadruple, (x−1)⁴(x+2); no script implements Method B or Method C.
  - In the intro, "Cases 1–4" and "not animated here" now refer to the whole set of animations that follows, which is accurate.
  - It does not conflict with the Description sentence "The animations show standard Newton and Method A; Case 5 also discusses Methods B and C".
- **Nothing else changed: yes.**
  - The `newtonimpbb.jl` hunk is identical to the one I checked: the comment line only, and still correct (0.0 vs 5.07e-20).
  - The page folder status still lists only `index.qmd` and `newtonimpbb.jl`, with no GIF modified. The earlier byte-identical regeneration of `newtonimpbb.gif` still applies.
  - No file outside the page folder is in the fix diff.
- **Earlier Minor (placement) problem:** resolved.

Final verdicts: F1 resolved; F2 resolved. No new problems.

**Final status:** committed
