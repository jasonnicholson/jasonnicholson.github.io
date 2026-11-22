# Fix record: broydens-method

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r5fix/broydens-method/fix/`
- `repro_aa.jl`: the page's Broyden algorithm for Case A and Case B. It prints the Float64 ‖F‖, the exact ‖F‖ at the Float64 iterate (BigFloat, 256 bits), the rounding scale of evaluating F (eps · max over components of Σ|terms|), and the step ratios.
- `indep.py`: an independent 50-digit mpmath Broyden from the same starts. It also gives the Float64 numpy value of F at the script's X6.
- `old/`: the HEAD script, regenerated in scratch for the before/after frame comparison. `frames_old/` and `frames_new/` hold the extracted frames.

## Findings

### F1 — Minor — fixed
- **Reproduced:** `julia repro_aa.jl` → `A k=6 x=0.061770126338607456 y=0.72449051534721676 float||F||=1.3552e-15 exact@iter=1.5709e-15 evalscale=1.78e-15 ratio=1.649e+05`. `/usr/bin/python3 -I indep.py` → `A 6 … 1.6828e-15` (exact-arithmetic iterate), `float64 F at script X6 [-7.77156117e-16 1.11022302e-15] 1.355199909595506e-15`, `exact at script X6 1.5709e-15`. So the quoted 1.4e-15 / 1.36e-15 is a Float64 evaluation value. The exact residual at the same iterate is 1.57e-15, and the rounding scale of evaluating F there is 1.78e-15, the same size. Only the order of magnitude carries information. Even one significant figure is unstable: `%.0e` gives 1e-15 for the Float64 value and 2e-15 for both exact values (`indep.py` output).
- **Change:**
  - `index.qmd` Case A Behavior: "down to $1.4\times10^{-15}$ at $\mathbf{X}^{(6)}$" → "down to about $10^{-15}$ (machine precision) at $\mathbf{X}^{(6)}$".
  - `index.qmd` Case A alt text: "falling from 2.5e-1 to 1.4e-15 in six steps" → "falling from 2.5e-1 to about 1e-15 (machine precision) in six steps".
  - `broydenaa.jl` and `broydenbb.jl`: the right-panel title now comes from a new `resid_title(k, r)`. For r < 1e-14 it prints "||F(X_k)|| ≈ 1e<round(log10 r)> (machine precision)". Otherwise it keeps the old "%.2e" format. A two-line comment gives the reason. Both scripts were changed so they stay identical apart from their parameters. In Case B no residual is below 1e-14, so its GIF does not change.
  - `broydenaa.gif` regenerated. Frame 7 title "||F(X_6)|| = 1.36e-15" → "||F(X_6)|| ≈ 1e-15 (machine precision)".
- **Check:** `round(log10(v))` = −15 for all three candidate values: 1.3552e-15 → −14.868, 1.5709e-15 → −14.804, 1.6828e-15 → −14.774. So "about 1e-15" holds under every definition. In Case A only k=6 is below the 1e-14 threshold, and in Case B no k is (python one-liner in the ledger). The frames were viewed (see below). The "more than 1000 times over each of the last two steps" claim still holds: 1304 and 1.65e5 (Float64), 1304.2 and 1.33e5 (exact arithmetic).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case A Behavior | "about $10^{-15}$" at X^(6) | `julia repro_aa.jl` → Float64 1.3552e-15, exact at iterate 1.5709e-15; `python3 -I indep.py` → exact arithmetic 1.6828e-15; log10 → −14.87, −14.80, −14.77, all round to −15 | yes |
| index.qmd Case A Behavior | "(machine precision)" | `repro_aa.jl` evalscale at X6 = eps·max Σ\|terms\| = 1.78e-15, the same size as the residual; Float64 F(X6) = (−7.77e-16, 1.11e-15) = (−3.5, 5) ulp of 1 | yes |
| index.qmd Case A alt text | "to about 1e-15 (machine precision) in six steps" | same as above; six steps X0→X6 (7 frames, `giftools.jl` → "7 frames") | yes |
| broydenaa.gif frame 7 title | "\|\|F(X_6)\|\| ≈ 1e-15 (machine precision)" | `resid_title` with r = 1.3552e-15 → round(log10 r) = −15; frame_007.png viewed, legible, ≈ renders | yes |
| broydenaa.gif frames 1–6 titles | unchanged text (2.48e-01 … 2.24e-10) | residuals for k=0..5 are all ≥ 2.2e-10 > 1e-14, so they use the old format; frame_001 shows "2.48e-01" and frame_006 "2.24e-10" | yes |
| broydenaa.jl / broydenbb.jl comment | "terms of size up to 4, eps ≈ 2.2e-16" | largest term in F is the constant 4 in f2; `indep.py` prints eps 2.220446049250313e-16 | yes |
| broydenbb.gif | unchanged | md5 c8f0075d660b99cd1052d36bf3302a67 before and after regeneration; all residuals ≥ 2.9557e-14 > 1e-14 | yes |

## Scripts and GIFs
- **Scripts changed:** `broydenaa.jl` and `broydenbb.jl`, with the same edit (a `resid_title` helper; the right-panel title uses it).
- **Regenerated:** both, from the page folder with `julia broydenaa.jl` and `julia broydenbb.jl`.
  - `broydenaa.gif`: 0b31ab08… → 5ba7979d….
  - `broydenbb.gif`: byte-identical (c8f0075d…).
- **Frames viewed:** full-size frames 1, 6 and 7 of the new `broydenaa.gif`.
  - Frame 1: title "||F(X_0)|| = 2.48e-01".
  - Frame 6: title "||F(X_5)|| = 2.24e-10".
  - Frame 7: title "||F(X_6)|| ≈ 1e-15 (machine precision)". It fits within the right panel, the ≈ glyph renders, and the red point is at about 1.4e-15 on the axis.
  - The left panels are unchanged in content.
  - The framemd5 of every frame differs from the old GIF's. The GIF palette is shared across frames, so a change in one frame's title can alter the encoding of all of them; the visible content of frames 1–6 is unchanged.
- **git status of the page folder:** `M broydenaa.gif`, `M broydenaa.jl`, `M broydenbb.jl`, `M index.qmd`.

## Legacy archive
Consulted: `n2003/broydenmethod/BroydenMethodMod/Links/BroydenMethodMod_lnk_12.html` (Example 8) and image `BroydenMethodMod_gr_676.gif`. Mathews' standard-Broyden run from (0.1, 0.7) prints P0–P6, and they match the script's iterates. His final F[P] is (−7.771561172376096×10⁻¹⁶, 1.110223024625157×10⁻¹⁵), which is the same Float64 rounding-level value (norm 1.36e-15) that the page used to quote to two digits. The page now gives only the order of magnitude, which the mathematics supports. The archive's displayed digits are not a property of the iterate.

## Notes
- The Case B final value, 3.0e-14 on the page and 2.96e-14 in the GIF, was left alone. The review confirmed it: Float64 2.9557e-14, exact at the iterate 2.9722e-14 (`repro_aa.jl`). Its third digit differs from the exact-arithmetic value, 3.1723e-14 (`indep.py`), but no finding names it, and it sits above the 1e-14 threshold.
- The threshold of 1e-14 is the one the review suggested. At X6 the rounding scale of evaluating F is about 1.8e-15 (Case A) and 2.8e-15 (Case B).

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence:
  - The page text no longer says 1.4e-15. The Case A Behavior paragraph now says "down to about $10^{-15}$ (machine precision) at $\mathbf{X}^{(6)}$", and the alt text now says "falling from 2.5e-1 to about 1e-15 (machine precision) in six steps".
  - I reproduced the algorithm independently in Python (`check/indep.py`) and got Case A k=6 as follows. Float64-evaluated ‖F‖ is 1.3552e-15. Exactly evaluated at my Float64 iterate (Fractions), it is 1.5588e-15. In Broyden at 60-digit mpmath, it is 1.6828e-15. All three are "about 1e-15": log10 runs from -14.87 to -14.77, and each rounds to -15. The rounding scale is eps·|terms| ≈ 2.2e-16·4 ≈ 9e-16, so calling it machine precision is fair.
  - In the script, a new `resid_title(k, r)` prints `||F(X_k)|| ≈ 1e<round(log10 r)> (machine precision)` when r < 1e-14 and keeps `%.2e` otherwise. For Case A, only k=6 is below 1e-14. The next lowest is 2.24e-10. For Case B, every residual is above 1e-14 (the smallest is 2.956e-14).
  - The GIF matches. Frame 7 of the new `broydenaa.gif`, viewed full size, has the title "||F(X_6)|| ≈ 1e-15 (machine precision)". It is legible, fits above the panel, and is correct.
  - Old and new frames were compared pixel by pixel. Frames 1–6 differ by at most 43/255, which is only GIF palette re-quantization: there are no pixels above 40 except a single one at (117,257). In frame 7 the only real change is the region rows 26–46 × cols 587–979, which is the right-panel title.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case A Behavior | "down to about $10^{-15}$ (machine precision) at $\mathbf{X}^{(6)}$" | k=6 residual is 1.36e-15 (Float64 eval), 1.56e-15 (exact at the Float64 iterate) and 1.68e-15 (mpmath Broyden). The rounding floor is ≈ 9e-16. The iterate count is 6 in both Float64 and mpmath. | True |
| index.qmd Case A alt text | "from 2.5e-1 to about 1e-15 (machine precision) in six steps" | ‖F(X0)‖ = 0.24843, which is 2.5e-1. The final value is as above. Six steps, consistent with the 7 frames, k = 0..6. | True |
| index.qmd Case A Behavior (unchanged neighbours, rechecked) | "24 and 43 times per step" for X0→X4; "more than 1000 times" over the last two steps | The ratios are 32.0, 24.5, 42.3 and 25.7. The last two are 1304 and 1.6e5 (1.4e5 exact at the iterate, 1.3e5 in mpmath). | True |
| broydenaa.jl comment | "terms of size up to 4, eps ≈ 2.2e-16" | f2 has the constant −4. Near the root the terms are ≤ 4 in magnitude, and eps = 2.22e-16. | True |
| broydenaa.jl / broydenbb.jl `resid_title` | threshold r < 1e-14; `round(Int, log10(r))` | For A, k=6: round(-14.87) = -15, which gives "1e-15". For B, no residual is below 1e-14, so every title keeps the `%.2e` form. | Correct |
| broydenaa.gif frame 7 title | "||F(X_6)|| ≈ 1e-15 (machine precision)" | Read at full size. | Correct, legible |

### New problems
None. This rests on the following:
- My independent recomputation of every residual in both cases.
- A full-size inspection of the first, middle and last frames of the new `broydenaa.gif` (frames 1, 4 and 7) and the last frame of `broydenbb.gif`.
- A pixel diff against the pre-fix GIF (taken from HEAD through `git lfs smudge`). It shows the only change is the frame-7 right-panel title.

The `broydenbb.jl` edit does nothing for the current data, because the Case B minimum is 2.96e-14, which is above the threshold. Its GIF is unchanged and reproduces exactly. The Case B text "3.0e-14" is unchanged. It is stable at the stated precision: 2.956e-14 in Float64, 2.972e-14 exactly at the iterate, and 3.17e-14 in mpmath, all of which round to 3.0e-14 at 2 significant figures. It is not a new problem.

### Reproducibility and conventions
- I ran `broydenaa.jl` and `broydenbb.jl` from scratch copies (`check/run/`). The SHA-256 hashes of the outputs match the working-tree GIFs byte for byte: aa is 2c58ece5…847141, which also matches the new LFS oid, and bb is 8611dc18…c54bd6.
- Conventions are kept. Description comes before Animations. Each case has a `[Julia source]` link and a GIF embed with descriptive alt text. There are no code fences in index.qmd (zero occurrences of ```).
- Files outside the page folder: the fix diff touches only `pages/numerical-methods/broydens-method/` (broydenaa.gif, broydenaa.jl, broydenbb.jl, index.qmd). The working tree also has modifications under laurent-series, mullers-method, nonlinear-systems and secant-method, plus untracked review fix records. Those belong to other pages being fixed in parallel this round. They are not part of this page's diff, and I did not evaluate them.

**Final status:** committed
