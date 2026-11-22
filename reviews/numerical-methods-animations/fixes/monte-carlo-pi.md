# Fix record: monte-carlo-pi

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/monte-carlo-pi/fix/`
(written below as `$FIX`). Scripts in `$FIX/scripts/`, outputs in `$FIX/*.txt`, frames in `$FIX/frames/{old,new}/`.

Evidence commands:

- `cd $FIX && julia scripts/values.jl > repro_values.txt` (round-1 script: same seed and RNG as `montecarlopiaa.jl`, no plotting; also writes `pts.txt`)
- `cd $FIX && /usr/bin/python3 -I scripts/indep.py > repro_indep.txt` (round-1 numpy recount from `pts.txt`)
- `cd $FIX/scripts && /usr/bin/python3 -I indep_se.py $FIX/pts.txt > $FIX/indep_se.txt` (new: mpmath standard error, exact binomial pmf-sum check at n=100, 200 000-replicate empirical SD per n, and z = err/se)
- `julia $FIX/scripts/pixdiff.jl $FIX` (pixel diff of the n=0 frame, old vs new)
- `$FIX/text_checks.txt`: the constant and z range quoted on the page (command in the Ledger)

## Findings

### F1 — Minor — fixed

- **Reproduced:** `repro_values.txt` and `repro_indep.txt` agree: for n = 100/400/1600/6400/10000, m = 73/306/1270/5049/7905, err = 0.221593/0.081593/0.033407/0.014032/0.020407 against the printed `1/sqrt(n)` = 0.1/0.05/0.025/0.0125/0.01. The error exceeds the printed value in all five frames (2.0x at n=10000). The old final frame `$FIX/frames/old/frame_006.png` shows "|pi - pi_hat| = 0.020407" above "1/sqrt(n) = 0.01". The finding holds.
- **Change:** `montecarlopiaa.jl:50`: `text("1/sqrt(n) = $(round(1 / sqrt(n); digits=6))")` → a one-line comment, `se = 4 * sqrt((pi / 4) * (1 - pi / 4) / n)` and `text("std error = $(round(se; digits=6))")`. `index.qmd` Case 1 Behavior: added one sentence that says what the new line is and how the error compares with it. GIF regenerated.
- **Check:** `indep_se.txt`: constant $4\sqrt{p(1-p)}$ = 1.64218336774. At n=100 the exact binomial pmf sum gives mean 3.14159265358979 and SD 0.164218336773632, the same as the formula. Empirical SD over 200 000 replicates: 0.163599/0.082206/0.040985/0.020531/0.016423, against formula 0.164218/0.082109/0.041055/0.020527/0.016422. z = 1.3494/0.9937/0.8137/0.6836/1.2427. The new frames show "std error = 0.164218" (frame_002, n=100) and "std error = 0.016422" (frame_006, n=10000). The contact sheet shows 0.082109, 0.041055 and 0.020527 for the middle frames.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| montecarlopiaa.jl comment | "standard error of pi_hat = 4m/n: 4*sqrt(p(1-p)/n) with p = pi/4 (about 1.642/sqrt(n))" | m ~ Binomial(n, π/4), so Var(4m/n) = 16p(1−p)/n. `indep_se.py`: pmf-sum SD at n=100 = 0.164218336773632, same as the formula; constant 1.64218336774 → 1.642 | yes |
| GIF label (frames 2–6) | "std error = 0.164218 / 0.082109 / 0.041055 / 0.020527 / 0.016422" | `indep_se.txt` "round6" column: 0.164218, 0.082109, 0.041055, 0.020527, 0.016422. None ends in 0, so `round(...; digits=6)` loses no digit. Seen in new frames 002 and 006 at full size, and on the sheet | yes |
| index.qmd:32 | "Each frame also prints the standard error $4\sqrt{p(1-p)/n}$ with $p=\pi/4$" | the script prints `se` = this formula (diff) | yes |
| index.qmd:32 | "(about $1.642/\sqrt{n}$)" | `text_checks.txt`: c = 1.642183367736324 → 1.642 | yes |
| index.qmd:32 | "the standard deviation of $\hat\pi_n$" | pmf-sum SD = formula (n=100). Empirical SDs within 0.4% of the formula for all five n (`indep_se.txt`) | yes |
| index.qmd:32 | "in this seeded run $\lvert\pi-\hat\pi_n\rvert$ is between 0.68 and 1.35 standard errors in every frame" | z over all five annotated frames = 1.3494, 0.9937, 0.8137, 0.6836, 1.2427. min 0.6836 → 0.68, max 1.3494 → 1.35 (`text_checks.txt`, `indep_se.txt`). The n=0 frame has no estimate | yes |

## Scripts and GIFs

- Script changed: `montecarlopiaa.jl` (one label line replaced by a comment, the `se` assignment and the new label). Regenerated with `cd pages/numerical-methods/monte-carlo-pi && julia montecarlopiaa.jl`.
- Frames: `julia giftools.jl <gif> $FIX/frames/new` gives 6 frames, the same count as before (n=0, then the five sample sizes). Viewed at full size: frame_002 (n=100) and frame_006 (n=10000). Viewed on the contact sheet: all frames. The points, counts, pi_hat and error are unchanged. Only the sixth text line differs, and its values are as in the Ledger.
- The decoded md5 changes for every frame, including the n=0 frame, which has no text. `pixdiff.jl`: 2942 of 1 190 700 bytes differ, max |diff| = 7/255. This is consistent with GIF palette quantization shifting when a frame's content changes. Nothing drawn in the n=0 frame changed.
- `git status --short -- pages/numerical-methods/monte-carlo-pi` after regeneration:
  ```
   M pages/numerical-methods/monte-carlo-pi/index.qmd
   M pages/numerical-methods/monte-carlo-pi/montecarlopiaa.gif
   M pages/numerical-methods/monte-carlo-pi/montecarlopiaa.jl
  ```

## Legacy archive

Consulted: `montecarlopimod.html` and its Example 1 solution `montecarlopi/MonteCarloPiMod/Links/MonteCarloPiMod_lnk_2.html`, with images `MonteCarloPiMod_gr_32.gif` (code) and gr_36/39/42/45/48 (printed results).

- Mathews' Example 1 uses the same sample sizes n = 100, 400, 1600, 6400, 10000, which matches the page's "worked-example sample sizes".
- His `MonteCarloResults` prints "Order of error π/√n" next to |π − approx|. His own unseeded run gave errors 0.0984/0.0316/0.0284/0.00659/0.00359 against π/√n = 0.314/0.157/0.0785/0.0393/0.0314. In his run the error stayed below the printed scale, which uses the constant π. This site's run printed 1/√n, which drops the constant. The constant matters: the true standard deviation is $1.642/\sqrt n$.
- π/√n is about 1.9 standard deviations (π/1.642 = 1.913). It is still a scale and not a bound. The page now prints the standard error itself, which is the mathematically meaningful quantity. It does not copy Mathews' π/√n.
- The module's text, "values converge very slowly of the order O(n^{-1/2}) ... a consequence of the Central Limit Theorem", agrees with the page's Description, which was left unchanged.

## Notes

- Pre-existing and not a finding, left unchanged: at n=6400 and n=10000 the annotation text sits over dense points, so it is harder to read on the contact sheet. It is legible at full size.
- Not changed: the alt text says "the running estimate approaches pi as sample size increases". The error falls overall, from 0.2216 to 0.0204, but not monotonically: it rises from 0.0140 at n=6400 to 0.0204 at n=10000. The Behavior paragraph already says "fluctuates but trends toward". No finding names the alt text, so it was left as is. If Jason wants exactness, "approaches pi overall" would be accurate.
- The page says "No archived animation GIF is available for this topic in the current snapshot". The archive has static result images for Example 1 but no animation GIF. That legacy-inventory stub was not touched.

## Round 2 after check

- **Problem (from the resolution check, Minor):** the Case 1 Behavior sentence "Each frame also prints …" was not true for the opening n = 0 frame, which has no annotations. The check also asked for a Behavior paragraph of 1–2 sentences, which the template requires. The round-1 paragraph had three.
- **Change:** `index.qmd:32`, Behavior rewritten as two sentences. No checked fact was dropped. Ledger rows for index.qmd:32 above still apply: formula, 1.642, standard deviation, 0.68–1.35. Their quantifier is now "each of them" (the five annotated frames), not "every frame".
  - Before: "Green points fall inside … and orange points fall outside. The estimate $\hat\pi_n$ fluctuates but trends toward $\pi$ as $n$ increases. Each frame also prints the standard error … in every frame."
  - After: "After the opening frame (quarter circle only, no points), each frame adds points, green inside $x^2+y^2\le 1$ and orange outside, and prints the estimate $\hat\pi_n$, which fluctuates but trends toward $\pi$ as $n$ increases. Each of these five frames also prints the standard error $4\sqrt{p(1-p)/n}$ with $p=\pi/4$ (about $1.642/\sqrt{n}$), the standard deviation of $\hat\pi_n$; in this seeded run $|\pi-\hat\pi_n|$ is between 0.68 and 1.35 standard errors in each of them."
- No script or GIF change in this round.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:32 | "After the opening frame (quarter circle only, no points)" | `$FIX/round2_checks.txt`: the loop is `for n in vcat(0, n_seq)` and everything else is inside `if n > 0`. 6 frames extracted. `$FIX/frames/new/sheet.png` first tile: arc and box, no points, no text | yes |
| index.qmd:32 | "each frame adds points … and prints the estimate $\hat\pi_n$" | frames 2–6 show cumulative points `1:n` and the "pi_hat = …" line (sheet; full-size frame_002, frame_006) | yes |
| index.qmd:32 | "fluctuates but trends toward $\pi$" | `text_checks.txt`: pi_hat 2.92, 3.06, 3.175, 3.155625, 3.162. err 0.2216 → 0.0816 → 0.0334 → 0.0140 → 0.0204: falls overall, rises at the last step | yes |
| index.qmd:32 | "Each of these five frames" | n_seq has 5 entries (`round2_checks.txt`, line 9) | yes |
| index.qmd:32 | "between 0.68 and 1.35 standard errors in each of them" | z over the five annotated frames = 1.3494, 0.9937, 0.8137, 0.6836, 1.2427 (`indep_se.txt`) | yes |

- `git status --short -- pages/numerical-methods/monte-carlo-pi`: ` M index.qmd`, ` M montecarlopiaa.gif`, ` M montecarlopiaa.jl` (unchanged from round 1).

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `montecarlopiaa.jl` line 50 (`1/sqrt(n) = ...`) is replaced by `se = 4*sqrt((pi/4)*(1-pi/4)/n)` printed as `std error = ...`. That is the exact standard deviation of `pi_hat = 4m/n` with m ~ Binomial(n, pi/4). I checked it two ways. (a) The constant `4*sqrt(p(1-p))` with p = pi/4 is 1.6421834 (mpmath, 30 digits). (b) A simulation gave an empirical SD of 0.16446 at n = 100 (20000 runs of real point clouds) against a formula value of 0.16422, and 0.016417 at n = 10000 (200000 binomial draws) against 0.016422.
- I recounted independently. The Julia seed-12345 points were dumped to `check/pts.txt` and counted in numpy with mpmath arithmetic:

  | n | m | k | pi_hat | err | std err | z |
  |---|---|---|---|---|---|---|
  | 100 | 73 | 27 | 2.92 | 0.221593 | 0.164218 | 1.349 |
  | 400 | 306 | 94 | 3.06 | 0.081593 | 0.082109 | 0.994 |
  | 1600 | 1270 | 330 | 3.175 | 0.033407 | 0.041055 | 0.814 |
  | 6400 | 5049 | 1351 | 3.155625 | 0.014032 | 0.020527 | 0.684 |
  | 10000 | 7905 | 2095 | 3.162 | 0.020407 | 0.016422 | 1.243 |

- GIF: I read frames 2–6 at full size or in enlarged crops. Every printed n, m, k, pi_hat, |pi - pi_hat| and std error matches the table above to 6 digits. The second annotation line now reads as a standard error and no longer looks like a bound that is always broken.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| jl:50 comment | "standard error of pi_hat = 4m/n: 4*sqrt(p(1-p)/n) with p = pi/4 (about 1.642/sqrt(n))" | Binomial variance; constant 1.64218; simulation agrees | correct |
| jl:51 | `se = 4 * sqrt((pi / 4) * (1 - pi / 4) / n)` | Same formula; values match the mpmath computation | correct |
| jl:52 / GIF label | "std error = 0.164218 / 0.082109 / 0.041055 / 0.020527 / 0.016422" | Independent computation (table above) | correct |
| index.qmd Behavior | "prints the standard error $4\sqrt{p(1-p)/n}$ with $p=\pi/4$" | Matches the script and the frames | correct |
| index.qmd Behavior | "about $1.642/\sqrt{n}$" | 1.6421834 | correct |
| index.qmd Behavior | "the standard deviation of $\hat\pi_n$" | SD of 4·Binomial(n,p)/n = 4√(p(1−p)/n); simulation agrees | correct |
| index.qmd Behavior | "between 0.68 and 1.35 standard errors in every frame" | z ranges from 0.6836 (n=6400) to 1.3494 (n=100); rounded, these are 0.68 and 1.35 | correct |
| index.qmd Behavior | "Each frame also prints..." | Frame 1 (n = 0) is an empty square with no annotations. The claim holds for every frame that has samples. | acceptable (slight overstatement, see below) |

### New problems
- Minor (convention), `index.qmd` Case 1 **Behavior**: the paragraph is now three sentences, and the new one is long. The template in `.github/agents/animation-page.agent.md:194` asks for 1–2 sentences. The content is correct. A small related imprecision: "Each frame also prints..." does not apply to the opening n = 0 frame, which has no annotations.
- No mathematical or visual regressions. I compared the old GIF (LFS smudge of HEAD) with the new GIF pixel by pixel. Differences larger than 60 levels fall only in rows 199–213 (the changed label line) of frames 2–6, plus one palette-quantization pixel at (334, 543) in frames 5–6. Frame 1 differs by at most 7 levels, which is palette requantization. Points, arc, title and the other labels are unchanged. Label legibility over dense points in frames 5–6 is the same as before; the label sits at the same position as the old line.

### Reproducibility and conventions
- I ran `montecarlopiaa.jl` from a scratch copy (`check/run/`). Its output is byte-identical to the committed GIF (sha256 76e9e6d8…1821, which matches the new LFS oid in the diff).
- The page keeps the conventions: Description comes before Animations, the Julia source link and the GIF embed are present, the alt text is descriptive and unchanged, and there are no code blocks. The fix diff touches only `pages/numerical-methods/monte-carlo-pi/` (index.qmd, montecarlopiaa.jl, montecarlopiaa.gif). The other modified files in the working tree belong to other pages' fixes or are untracked review files, not this fix.

### Re-check
Updated diff: only `index.qmd` changed since the first check. The `.jl` file is identical to my scratch copy, and the committed GIF still has sha256 76e9e6d8…1821, which is byte-identical to my regenerated output.

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Behavior, sentence 1 | "After the opening frame (quarter circle only, no points)" | Frame 1 at full size shows the unit-square box, the quarter-circle arc and the title. It has no points and no annotations (the script's `n = 0` branch). | correct |
| Behavior, sentence 1 | "each frame adds points, green inside ... orange outside" | The script plots the prefix `1:n` of one fixed sample, so each frame keeps the earlier points and adds new ones. Colors are forestgreen inside and darkorange outside, as seen in frames 2–6. | correct |
| Behavior, sentence 1 | "prints the estimate $\hat\pi_n$, which fluctuates but trends toward $\pi$" | Printed values are 2.92, 3.06, 3.175, 3.155625, 3.162. Errors are 0.222, 0.082, 0.033, 0.014, 0.020: the overall trend is down, with a rise in the last frame. | correct |
| Behavior, sentence 2 | "Each of these five frames" | The GIF has 6 frames: the opening frame plus 5 annotated ones (n = 100, 400, 1600, 6400, 10000). | correct |
| Behavior, sentence 2 | std error formula, "about 1.642/√n", "standard deviation of π̂_n", "between 0.68 and 1.35 standard errors" | Unchanged from the first check: the constant is 1.6421834 and z ranges from 0.6836 to 1.3494. | correct |
| Convention | Behavior paragraph length | Now two sentences, which meets the 1–2 sentence template. | resolved |

- F1: still resolved. The script, GIF and numbers are unchanged from the first check.
- Earlier Minor (paragraph length and the n = 0 overstatement): resolved.
- New problems: none. Description still comes before Animations; the source link, the embed and the unchanged alt text are present; there are no code blocks. The diff stays inside the page folder.

**Final status:** committed
