# Fix record: monte-carlo-pi

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/monte-carlo-pi/fix/`
(`scripts/archive_examples.py` with its output in `archive_examples.out`, `scripts/upscale.jl`, and the archive images converted to PNG in `archive/`).

## Findings

### F1 — Minor (Fidelity) — fixed

- **Reproduced.**
  - `grep -n -E 'Example [0-9]' n2003/montecarlopimod.html` finds exactly seven examples, Example 1 to Example 7.
  - The solution links are `lnk_2` (Ex 1), `lnk_3`–`lnk_5` (Ex 2–4), `lnk_6` (the Question/Answer, which is not an example), `lnk_7` (Ex 5), `lnk_8` (Ex 6) and `lnk_9` (Ex 7). I stripped each to text with `sed 's/<[^>]*>//g' | sed '/^[[:space:]]*$/d'`.
  - Example 1 is the π estimate. Examples 2–5 ask to "approximate the integral" (statement images `gr_74`, `gr_91`, `gr_108`, `gr_137`). Example 6 asks for "the area of the cardioid defined by the constraint" (`gr_159`). Example 7 asks for "the area of the region defined by the constraints" (`gr_180`).
  - The page has one case, which is Example 1. Line 38 said "reconstructed from the module examples" (plural), so the finding holds.
- **Change.** `pages/numerical-methods/monte-carlo-pi/index.qmd`, the closing legacy note (was line 38; now lines 38–39).
  - Before: "…so this animation is reconstructed from the module examples."
  - After: "…so this animation is reconstructed from Example 1 of Mathews' Monte Carlo Pi module.
    The module's Examples 2–7, which use the same hit-or-miss method of counting the random points that land in the region to estimate areas under curves (Examples 2–5), the area of a cardioid (Example 6) and the area of a region bounded by inequalities (Example 7), are not animated here."
  - Under R2-A, the examples were not added. The reviewer's alternative of adding them was not taken.
- **Check.** Each archive statement in the new text is verified in the ledger below. `git diff` shows only this one-line change, as a replaced line plus one added line. No script or GIF changed.

## Ledger of changed text

Archive paths are relative to `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/`, and the images are in `montecarlopi/MonteCarloPiMod/Images/`. "Script" means `scripts/archive_examples.py` in the scratch folder, run as `/usr/bin/python3 -I`.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.38 | "No archived animation GIF is available for this topic in the current snapshot" (kept unchanged) | `find a2001/Animations -iname '*.gif'` → 404 GIFs. None has monte/carlo/pi/random in its path, and `grep -ril -E 'monte\|carlo' a2001/Animations` returns nothing. In `n2003/montecarlopi/`, a PIL `n_frames` scan finds only two multi-frame GIFs (`MonteCarloPiProg/Images/constr00.gif`, `constr01.gif`). I extracted the frames of `constr00`: it is an "Under Construction" banner, not a topic animation | yes |
| index.qmd l.38 | "reconstructed from Example 1" | `lnk_2.html` text: "Example 1. Use Monte Carlo simulation to approximate the number [π]" (`gr_31` viewed: "π."). `gr_32` (viewed) draws `Circle[{0,0},1,{0,π/2}]` with the box lines, which is the page's quarter-disk picture. `gr_33` (viewed): "n = 100, 400, 1600, 6400, and 10000", matching the page's sample sizes (l.25–26) and the script's `n_seq` | yes |
| index.qmd l.38 | "Mathews' Monte Carlo Pi module" | `montecarlopimod.html` title "Monte Carlo Pi", heading "Module for Monte Carlo Pi"; `lnk_1.html` reads "(c) John H. Mathews and Kurtis Fink, 2005" and the main page footer reads "(c) John H. Mathews 2005". The page already cites `[@mathewsSite]` | yes |
| index.qmd l.39 | "Examples 2–7" (six examples, numbered 2 to 7) | `grep -n 'Example [0-9]' montecarlopimod.html` → "Example 1." … "Example 7." only. The Question/Answer (`lnk_6`) is not numbered as an example and is not included in the range | yes |
| index.qmd l.39 | "use the same hit-or-miss method of counting the random points that land in the region" (reworded after the independent check: the earlier "same count of random points in an enclosing box" could be read as the same number of points, which is false, since Example 1 uses n = 100, 400, 1600, 6400, 10000 (`gr_33`) and Examples 2 and 6 use n = 100, 1000, 10000 (`gr_78`, `gr_166`, viewed)) | Ex 2–5 subroutine `gr_70` (viewed): `X = a+(b−a) Random[]`, `Y = d*Random[]`, a point counts if `Y ≤ f[X]`, `ρ = m/n`, `Area = ρ*BoxArea`, with `BoxArea = (b−a)*d`. Ex 6–7 subroutine `gr_158` (viewed): `X = a+(b−a)Random[]`, `Y = c+(d−c)Random[]`, a point counts if the constraints hold, `Area = ρ*BoxArea`. This is the same hit-or-miss count as Example 1 (`gr_30`: point counted if d ≤ 1, then `ρ*4`), done in a box enclosing the region | yes |
| index.qmd l.39 | "areas under curves (Examples 2–5)" | Statement images (viewed at 4×): Ex 2 `gr_74` ∫₀² √(4−x²) dx; Ex 3 `gr_91` ∫₀² 4/(1+x²) dx (but the solution code `gr_92` uses b = 1; see Legacy archive); Ex 4 `gr_108` ∫₀¹ 6/√(4−x²) dx; Ex 5 `gr_137` ∫₋₃³ (1/√(2π)) e^{−x²/2} dx. Each integrand is ≥ 0 on its interval, so each integral is an area under a curve. Script: minimum on a 2001-point grid of 0.0, 2.0, 3.0, 0.00443. The values are π, π (on [0,1]), π and erf(3/√2) = 0.997300 | yes |
| index.qmd l.39 | "the area of a cardioid (Example 6)" | `lnk_8` text: "approximate the area of the cardioid". Solution code `gr_160` (viewed): `(x²+y²−2x)² ≤ 4(x²+y²)`. Script: points on r = 2(1+cos θ) satisfy it with equality (max residual 7.1e−15), so it is the cardioid r = 2(1+cos θ). Its polar area is 18.84955592 = 6π, and a 4000² grid count gives 18.8495. Mathews' `gr_179` prints "Area = 6π = 18.8496". Plot `gr_161` (viewed) is a cardioid with its cusp at the origin, reaching x = 4. The statement image `gr_159` has a typo; see Legacy archive | yes (cardioid per the solution's constraint and plot) |
| index.qmd l.39 | "the area of a region bounded by inequalities (Example 7)" | `lnk_9` text: "approximate the area of the region defined by the constraints". `gr_180`/`gr_181` (viewed): −5/4 − 3/(3+x²) ≤ y ≤ 5/4 + 3/(3+x²) and −1/3 − 5y²/6 + y⁴/6 ≤ x ≤ 11/3 − (2/3)√2 \|y\|^{3/2}. Script: the region is bounded; a grid count in [−3,4]×[−3,3] gives area 14.672 and the region does not touch the box edge. The area is for the record only and is not on the page | yes |
| index.qmd l.39 | "are not animated here" | The page has one case (Case 1) and one GIF (`montecarlopiaa.gif`, 6 frames n = 0, 100, …, 10000, per the r2 inventory). No other script is in the page folder (`ls`: index.qmd, montecarlopiaa.gif, montecarlopiaa.jl) | yes |

No numbers were added to the page. The page's existing numbers (sample sizes, 1.642, 0.68–1.35) were not touched.

## Scripts and GIFs

- No scripts changed and no GIFs regenerated. The finding was text-only, so no frames needed viewing for the fix. I viewed archive images (listed in the ledger) and the frames of the `constr00.gif` banner.
- `git status --short -- pages/numerical-methods/monte-carlo-pi` → ` M pages/numerical-methods/monte-carlo-pi/index.qmd` only.

## Legacy archive

Consulted: `n2003/montecarlopimod.html`, `n2003/montecarlopi/MonteCarloPiMod/Links/MonteCarloPiMod_lnk_1..9.html`, the statement, code and result images named above, `n2003/MonteCarloPiProg.html`, and `a2001/Animations/` (searched for any Monte Carlo GIF; none found).

What it showed:
- Example 1 is the page's case: the quarter disk in the unit square, with n = 100, 400, 1600, 6400, 10000.
- Mathews colours inside points red and outside points green (`gr_32`: `DOTSin` Red, `DOTSout` Green). The page uses green inside and orange outside. No finding raises this, so the colours were left alone.
- Examples 2–7 are hit-or-miss areas. Examples 2–4 are three integrals equal to π, and the Question/Answer compares their accuracy. Example 5 is the standard normal on [−3,3], Example 6 the cardioid, Example 7 a region bounded by inequalities.

Inconsistencies inside the archive, found while checking. None of them reaches the page, because the new sentence names no integrand or constraint.
1. **Example 3.** The statement image `gr_91` reads ∫₀² 4/(1+x²) dx, and an 8× crop confirms the upper-limit glyph is the same "2" glyph as in x². The solution code `gr_92` sets `b = 1`, and the analytic aside `gr_107` gives ∫₀¹ = π. ∫₀² would be 4 arctan 2 = 4.42859 (script). The Question/Answer's ρ₂ = π/4 (`gr_126`) fits b = 1, so the statement's upper limit looks like a typo.
2. **Example 6.** The statement image `gr_159` reads (x²+y²−2x)² ≤ 4(x²+**4**y²); an 8× crop confirms the "4" before y². The solution code `gr_160` uses 4(x²+y²), which is the true cardioid with area 6π. The statement form is not a cardioid: its grid area in [−1,4]×[−3,3] is 28.68 and it spills to the box edge. The statement is a typo, and the page's word "cardioid" follows the solution.
3. **Question/Answer text.** It says "the results of examples 1, 2, and 3" where Examples 2, 3, 4 are meant (cosmetic, archive only).

## Notes

- Nothing outside the page folder and this record was touched.
- The site's `pages/numerical-methods/monte-carlo-integration.qmd` is still a placeholder: `grep -n -i example` → only "## Worked Example (Planned)". Mathews' own module points the hit-or-miss integral idea to a separate "Monte Carlo integration" module (`n2003/MonteCarloMod.html`, linked from the caveat in `montecarlopimod.html`). If Jason later wants Examples 2–5 animated, that page is the natural home. Per R2-A they were not added.

### R2-A note pattern for other pages

**Exact sentence used** (with the reworded sentence before it that names what the page *does* reproduce):

> No archived animation GIF is available for this topic in the current snapshot, so this animation is reconstructed from Example 1 of Mathews' Monte Carlo Pi module.
> The module's Examples 2–7, which use the same hit-or-miss method of counting the random points that land in the region to estimate areas under curves (Examples 2–5), the area of a cardioid (Example 6) and the area of a region bounded by inequalities (Example 7), are not animated here.

The general form is: "The module's Examples A–B, which <what they do, in the page's own vocabulary> (Examples …), … , are not animated here."

**Where it goes.** At the very end of `index.qmd`, in the existing legacy/source note paragraph after the last case's embed. It goes on its own source line directly after the sentence that says where the animation comes from, so the two read as one paragraph in the rendered page. It does not go in the Description, the Animations intro or a case's Behavior: it is a statement about the source, not about the method or the animation. Where a page has no legacy note, the same place is right after the last embed. If a page's legacy note is itself stale (an R2-A "legacy GIF missing" correction), fix that sentence first and add this one after it.

**How each named example was verified against the archive.** The details and outputs are in the ledger above.
1. *That the example exists and how it is numbered:* `grep -n -E 'Example [0-9]' <module>.html`, which gives the full list. Then strip each solution link (`Links/*_lnk_N.html`) to text, so that each example number is matched to its own solution page. Unnumbered items, here the Question/Answer, are excluded from the range.
2. *What each example is about:* read the stripped statement text ("approximate the integral", "area of the cardioid", "area of the region defined by the constraints"). Then view the statement image (`gr_N.gif`, small equation images upscaled 4× with ffmpeg via Plots), *and* the solution's code image, because these can disagree (two typos here, Example 3 and Example 6).
3. *That the descriptive word is mathematically true:* compute it independently rather than trusting the archive's word.
   - "areas under curves": each integrand is ≥ 0 on its interval.
   - "cardioid": the solution's constraint is satisfied with equality on r = 2(1+cos θ), and the area is 6π by polar quadrature and by a grid count.
   - "region bounded by inequalities": the region is bounded inside the solution's box, by a grid count.
4. *That the shared mechanism phrase ("same hit-or-miss method of counting the random points that land in the region") is true:* view the archive's subroutine images (`gr_70` for Examples 2–5, `gr_158` for Examples 6–7, `gr_30` for Example 1) and confirm that each draws uniform points in a box and estimates ρ·BoxArea.
5. *That the page really omits them:* list the page's cases, scripts and GIFs.

**Advice for other fixers using the pattern.**
- Name the left-out examples by kind, not by formula, unless you have checked the formula in both the statement image and the solution code. This archive has typos in its statement images.
- Do not put numbers in the sentence.
- Word a shared-mechanism phrase so it names the method, not a quantity. "The same count of random points" was read as "the same number of points", which is false here because the sample sizes differ between examples.
- Say "are not animated here". Do not point to another page unless that page actually has them; `monte-carlo-integration` is still a placeholder.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The old line 38 ("reconstructed from the module examples") is gone. It now reads "...reconstructed from Example 1 of Mathews' Monte Carlo Pi module." A new line 39 names Examples 2–7 and says they are not animated. This is what decision R2-A asks for: one sentence on what was left out, without adding the example.
- I checked against the archive myself:
  - I stripped `n2003/montecarlopimod.html` and `MonteCarloPiMod_lnk_2..9.html` of their tags and read them.
  - I also read the rendered solution images, stacked into `check/ex1.png`, `ex2.png` and `ex6.png`.
  - **Example 1 (lnk_2):** this is the page's case. It uses the unit square, the quarter circle `Circle[{0,0},1,{0,π/2}]`, inside points marked red and outside green, and n = 100, 400, 1600, 6400 and 10000. That matches the page's single case and the sample sizes on its line 26.
  - **Examples 2–7:** the module has exactly seven examples, plus a Question/Answer (lnk_6) about Examples 2–4.
- The script and GIF are unchanged. The finding was about text only, so they need no change.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.38 | "No archived animation GIF is available for this topic in the current snapshot" (sentence kept, now part of a changed line) | I counted frames with PIL in every GIF under `n2003/montecarlopi/` and `n2003/montecarlo/` (439 files). Only two have more than one frame: `MonteCarloPiProg/Images/constr00.gif` (4 frames) and `constr01.gif` (2 frames). I viewed both: they are "Under Construction" decorative icons. I also counted frames in all 452 GIFs under `a2001/Animations/`. The animated ones sit in Derivative, Interpolation, Optimization, OrdinaryDE, Quadrature, Riemann and RootFinding folders, and none is Monte Carlo. `find -iname '*monte*\|*carlo*\|*random*'` and a grep for monte/carlo under `a2001/Animations` both found nothing. `montecarlopimod.html` links to no animation. | True |
| index.qmd l.38 | "reconstructed from Example 1 of Mathews' Monte Carlo Pi module" | lnk_2: Example 1 is "Use Monte Carlo simulation to approximate the number π". It uses the quarter disk in [0,1]², n = 100…10000, the same geometry and sample sizes as the page. | True |
| index.qmd l.39 | "The module's Examples 2–7" | The module has Examples 1–7 (headings in montecarlopimod.html). | True |
| index.qmd l.39 | "use the same count of random points in an enclosing box" | Solutions 2–7 each say "Set up the rectangular box enclosing the area". Each counts the points that fall in the region and uses ρ·BoxArea; for example, Ex 2 gives 7855/10000·4 = 3.142 and Ex 6 gives 0.8043·27√3/2 = 18.8067. The method is right. The wording is ambiguous; see New problems. | True as a description of the method; wording ambiguous |
| index.qmd l.39 | "areas under curves (Examples 2–5)" | The module heading "Area Under a Curve" covers Examples 2–5, each an integral done by the box method. Ex 2 is ∫₀²√(4−x²)dx over the box [0,2]×[0,2]. Ex 5 is the standard normal density. | True |
| index.qmd l.39 | "the area of a cardioid (Example 6)" | Example 6 is the cardioid (x²+y²−2x)² ≤ 4(x²+y²) in the box [−1/2,4]×[−3√3/2,3√3/2]. Exact area 6π ≈ 18.85. | True |
| index.qmd l.39 | "the area of a region bounded by inequalities (Example 7)" | Example 7 is "the area of the region defined by the constraints" (lnk_9), under the section "Area of a region defined by inequalities". | True |
| index.qmd l.39 | "are not animated here" | The page has only Case 1. | True |

### New problems
- **Minor**, index.qmd line 39: "which use the same count of random points in an enclosing box". The phrase "the same count of random points" can be read as "the same number of random points". Read that way it is false.
  - Example 1 uses n = 100, 400, 1600, 6400 and 10000.
  - Examples 2 and 6 (archive images gr_74–90 and gr_159–179) use n = 100, 1000 and 10000.
  - The intended meaning, the same counting of random points in an enclosing box, is correct.
  - Suggested wording: "which use the same hit-or-miss count (the fraction of random points in an enclosing box that land in the region)".

No other new problems. This rests on the ledger above and on the diff: the only change is these two lines of text. No script or GIF changed, and the quarter-disk wording is unaffected.

### Reproducibility and conventions
- The page folder's diff is `index.qmd` only (2 insertions, 1 deletion). `montecarlopiaa.jl` and `montecarlopiaa.gif` are unchanged against HEAD, so there was nothing to regenerate. The no-GIF claim was checked against the archive directly (ledger row 1).
- Conventions are still met:
  - Description (l.10) comes before Animations (l.22).
  - Case 1 has a Julia source link (l.34) and a GIF embed (l.36).
  - The alt text is descriptive.
  - There are no code blocks.
- Files outside the page folder: the working tree also has changes in the bisection-method, runge-kutta-method and simpsons-rule pages. These are other pages' fixes from the same parallel run, and nothing in them relates to monte-carlo-pi. No file outside `pages/numerical-methods/monte-carlo-pi/` carries a Monte Carlo change.

### Re-check
- **Updated diff:** the page folder still differs from HEAD only in `index.qmd`. Line 38 is unchanged from the version checked above. Line 39 now reads "...which use the same hit-or-miss method of counting the random points that land in the region to estimate areas under curves (Examples 2–5), the area of a cardioid (Example 6) and the area of a region bounded by inequalities (Example 7), are not animated here."
- **New wording vs archive: true.**
  - In Solutions 2–7 (lnk_3–5, lnk_7–9; images gr_74–90 and gr_159–179), each example places random points in a rectangular box around the region. It counts the points that land in the region: "Points under curve m" for Examples 2–5 and "Points inside the area m" for Examples 6–7. It then estimates the area as (m/n)·BoxArea.
  - Example 1 (lnk_2) does the same thing: it counts the "Inside Points m" in the quarter disk. So "the same hit-or-miss method" is correct.
  - The phrase no longer mentions a sample size, so the reading that Examples 2–7 use the same number of points is gone. That reading was false: Example 1 uses n=100, 400, 1600, 6400, 10000, while Examples 2 and 6 use n=100, 1000, 10000.
  - The wording no longer says "enclosing box". That is an omission, not an error.
- **Rest of line 39:** unchanged from the ledger above, and still true:
  - "Examples 2–7";
  - "areas under curves (Examples 2–5)";
  - "the area of a cardioid (Example 6)";
  - "region bounded by inequalities (Example 7)";
  - "not animated here".
- **F1:** still resolved.
- **Earlier Minor ("same count" ambiguity):** resolved.
- **New problems:** none.
- **Conventions:** unchanged; no script or GIF changed.

**Final status:** committed
