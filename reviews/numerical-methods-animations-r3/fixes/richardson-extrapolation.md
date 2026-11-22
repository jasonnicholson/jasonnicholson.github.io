# Fix record: richardson-extrapolation

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/richardson-extrapolation/fix/` (`inst_a.jl`, `full.py`, `new_a/` frames, `legacy/` images).

## Findings

### F1 — Minor — fixed
- **Reproduced:** `julia inst_a.jl` (a copy of the script's functions and h list) prints, for each h, the max errors on the script's old grid (700 points on [h, π−h]) and on an 800-point grid on [0, π]:

  | h | old D3 | old D5 | [0, π] D3 (argmax x) | [0, π] D5 (argmax x) | ratio D3/D5 on [0, π] |
  |---|---|---|---|---|---|
  | 0.5 | 6.81e-02 | 1.32e-04 | 8.13e-02 (0.024) | 5.29e-04 (0.000) | 154 |
  | 0.32 | 3.12e-02 | 4.08e-05 | 3.38e-02 (0.012) | 8.79e-05 (0.000) | 384 |
  | 0.2 | 1.28e-02 | 8.56e-06 | 1.33e-02 (0.004) | 1.34e-05 (0.000) | 994 |
  | 0.12 | 4.73e-03 | 1.34e-06 | 4.79e-03 | 1.73e-06 | 2771 |
  | 0.08 | 2.12e-03 | 2.89e-07 | 2.13e-03 | 3.41e-07 | 6244 |
  | 0.05 | 8.31e-04 | 4.70e-08 | 8.33e-04 | 5.21e-08 | 15994 |
  | 0.03 | 3.00e-04 | 6.35e-09 | 3.00e-04 | 6.75e-09 | 44438 |
  | 0.02 | 1.33e-04 | 1.28e-09 | 1.33e-04 | 1.33e-09 | 99994 |
  | 0.01 | 3.33e-05 | 8.17e-11 | 3.33e-05 | 8.33e-11 | 399993 |

  Missing fraction of the window at h = 0.5 is 2h/π = 0.318. Independent check: `/usr/bin/python3 -I full.py` (mpmath, 40 digits, same 800-point grid on [0, π]) gives 0.0812769 / 5.28527e-4 at h = 0.5 ... 3.3333e-5 / 8.33338e-11 at h = 0.01, agreeing with every row above to the printed digits. The finding holds as stated, including the review's table.
- **Change:** `richexaa.jl` — took the review's second option, which is also what Mathews does (see Legacy archive): D3 and D5 are now evaluated, drawn and maximised on the same 800-point grid over all of [0, π] (`xfull`) that f′ uses; the `xint = range(h, π−h)` grid is removed; a two-line comment says why. Title, legend and annotation strings unchanged. `index.qmd` unchanged: its title-matching alt text ("over 0 to pi") is now literally true.
- **Check:** regenerated `richexaa.gif` (9 frames). Frames 1, 2, 5, 9 viewed at full size: all three curves span x = 0 to π; annotations read 8.13e-02 / 5.29e-04 (h = 0.5), 3.38e-02 / 8.79e-05 (0.32), 2.13e-03 / 3.41e-07 (0.08), 3.33e-05 / 8.33e-11 (0.01), equal to the [0, π] column above. D3's largest value, 1.081 at h = 0.5 (`inst_a.jl` range3), is inside ylims (−1, 1.1) and visible at the top left of frame 1; the legend does not cover any curve.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `richexaa.jl` comment (lines 20–21) | "D3 and D5 are evaluated on all of [0, pi] (f is defined outside it), as in Mathews' Example 2(b)" | Code uses `xfull = range(0, π, 800)` for y3, y5, err3, err5 (git diff); Mathews' code image gr_89: `Plot[D_five[x, 0.01], {x, 0, π}]` | yes |
| GIF annotation, 9 frames (values changed, string unchanged) | 8.13e-02/5.29e-04, 3.38e-02/8.79e-05, 1.33e-02/1.34e-05, 4.79e-03/1.73e-06, 2.13e-03/3.41e-07, 8.33e-04/5.21e-08, 3.00e-04/6.75e-09, 1.33e-04/1.33e-09, 3.33e-05/8.33e-11 | `julia inst_a.jl` full column; `python3 -I full.py` agrees; frames 1, 2, 5, 9 read | yes |
| GIF title "Richardson Extrapolation on [0, pi]" (unchanged, now accurate) | all curves on [0, π] | frames 1, 2, 5, 9 | yes |
| `index.qmd` Case 1 Behavior (unchanged; rechecked against new picture) | "Both approximations converge as h shrinks"; "Richardson curve tracks f′ much more closely" | [0, π] max errors decrease at every step for both (8.13e-2 → 3.33e-5; 5.29e-4 → 8.33e-11); ratio D3/D5 154 → 4.0e5 (`inst_a.jl`) | yes |
| `index.qmd` alt text (unchanged) "...over 0 to pi for decreasing h" | D3, D5, f′ all over [0, π]; h 0.5 → 0.01 | frames 1 and 9 | yes |

## Scripts and GIFs
- Script changed: `richexaa.jl`. GIF regenerated: `richexaa.gif` (`cd pages/numerical-methods/richardson-extrapolation && julia richexaa.jl`). `richexab.jl` not touched or rerun.
- Frames extracted with `giftools.jl` into `fix/new_a/`; frames 1, 2, 5, 9 viewed full size (see F1 Check).
- `git status --short -- pages/numerical-methods/richardson-extrapolation` after regeneration: `M richexaa.gif`, `M richexaa.jl` only. `richexab.gif` hash-object equals HEAD (a694e198...).

## Legacy archive
Consulted: `n2003/RichardsonExtrapMod.html` and `richardsonextrap/RichardsonExtrapMod/Links/RichardsonExtrapMod_lnk_3.html`, `_lnk_4.html`. Example 2(b) plots D_five over the interval and compares with f′; its code image (gr_89) is `Plot[D_five[x, 0.01], {x, 0, π}, ...]` and `Plot[f'[x], {x, 0, π}, ...]`, and its graph (gr_90) spans x = 0 to π. Example 3 plots the absolute error over the interval and its Aside discusses the error at x = 0, noting that the error bound needs the derivative over the wider interval reached by the stencil. So Mathews evaluates the approximations on all of [0, π] with the stencil reaching outside; the fixed script now does the same. No difference between the fixed page and the archive on this point.

## Notes
- The review's first option (label the annotation as max over [h, π−h] and add a page sentence) was not taken: the full-interval option needs no new page text, matches the title and alt text, and follows Mathews (R2-A).
- No "not animated here" sentence move is needed (R3-D): it is already in the Animations introduction.
- No pre-existing convention gaps noted (page has Description, Animations, source links and alt text).

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- The fix takes the finding's second option. `richexaa.jl` now evaluates D3 and D5 on the same 800-point grid `xfull = range(0, pi, length=800)` as f'. It also computes `err3`/`err5` over that grid (lines 22-29) and draws both curves on it (lines 49-50). The `xint = [h, pi-h]` grid is gone. So the title "Richardson Extrapolation on [0, pi]" and the alt text "...over 0 to pi..." (`index.qmd` line 40), neither of which changed, are now literally true.
- Evaluating outside [0, pi] is legitimate: f(x) = e^{-x} sin x is entire, so stencil points x ± h and x ± h/2 that fall outside [0, pi] are well defined. Mathews' Example 2(b) (`RichardsonExtrapMod.html`, image `gr_59`/`gr_60`) also plots `D_five[x, 0.01]` over `[0, π]`.
- Independent computation (`check/chk.py`, mpmath at 40 digits) used both the script's 800-point grid and a 4001-point grid on [0, pi]:

  | h | D3 max err (800 / 4001 pts) | D5 max err (800 / 4001 pts) | GIF annotation |
  |---|---|---|---|
  | 0.5 | 8.13e-02 / 8.1277e-02 | 5.29e-04 / 5.2853e-04 | 8.13e-02, 5.29e-04 |
  | 0.32 | 3.38e-02 / 3.3786e-02 | 8.79e-05 / 8.7912e-05 | 3.38e-02, 8.79e-05 |
  | 0.2 | 1.33e-02 / 1.3280e-02 | 1.34e-05 / 1.3365e-05 | 1.33e-02, 1.34e-05 |
  | 0.12 | 4.79e-03 | 1.73e-06 | 4.79e-03, 1.73e-06 |
  | 0.08 | 2.13e-03 | 3.41e-07 | 2.13e-03, 3.41e-07 |
  | 0.05 | 8.33e-04 | 5.21e-08 | 8.33e-04, 5.21e-08 |
  | 0.03 | 3.00e-04 | 6.75e-09 | 3.00e-04, 6.75e-09 |
  | 0.02 | 1.33e-04 | 1.33e-09 | 1.33e-04, 1.33e-09 |
  | 0.01 | 3.33e-05 / 3.3333e-05 | 8.33e-11 / 8.3334e-11 | 3.33e-05, 8.33e-11 |

  All nine annotations match to the printed 3 significant figures. They also agree with the "[0, pi]" column of the original finding's table. The 800-point grid catches the true maximum, which sits at or next to x = 0, to 3 significant figures.
- Frames: in frame 1 (h = 0.5), both approximation curves now span all of [0, pi]. D3 starts at 1.081 at x = 0 (computed 1.081), which is under ylim 1.1, so nothing is clipped. All computed curve ranges stay inside [-1, 1.1]: D3 in [-0.192, 1.081] and D5 in [-0.208, 1.001].

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| richexaa.jl l.20-21 (comment) | "D3 and D5 are evaluated on all of [0, pi] (f is defined outside it), as in Mathews' Example 2(b), so the title's interval and the max errors agree." | Code does evaluate them on `range(0, pi, 800)`. f is entire. Mathews 2(b) plots D_five[x, 0.01] over [0, π] (legacy images gr_59, gr_60). The max errors are taken over the same grid as the title interval. | correct |
| GIF title (unchanged text, now true) | "Richardson Extrapolation on [0, pi] \| h = …" | Curves and maxima are now over [0, pi] | correct |
| GIF annotation, 9 frames | max\|error D3\|, max\|error D5\| values (table above) | mpmath recomputation on the 800-point grid and a 4001-point grid | all 18 numbers correct |
| index.qmd l.40 alt text (unchanged) | "...over 0 to pi for decreasing h" | Matches the new frames | correct |
| index.qmd l.36 Behavior (unchanged) | "Richardson curve tracks f'(x) much more closely" | D3/D5 max-error ratio is 154, 384, 994, 2771, 6244, ~1.6e4, ~4.4e4, ~1.0e5, ~4.0e5 | correct |

`index.qmd` was not changed. There are no new sentences on the page.

### New problems
None. This rests on the following checks:
- Full-size frames 1, 5 and 9 and the contact sheet of all 9 frames were viewed. I zoomed frame 1 near x = 0, where the black f' edge is still visible under the orange D5 curve.
- The recomputed annotations above all match.
- The curves stay inside the y-limits.
- The title, legend and axes are the same as the pre-fix GIF, which I extracted through `git lfs smudge` and compared at frame 1.
- The rest of the script is unchanged: the f, f', d3 and d5 definitions, and the hs list.
- `richexab.jl`/`.gif` are untouched.

### Reproducibility and conventions
- Reproducibility: I ran a scratch copy of `richexaa.jl` with `julia`. The output GIF is byte-identical (`cmp`) to the committed working-tree `richexaa.gif`. That file is real GIF data, 760x460 with 9 frames, not an LFS pointer.
- Conventions: in `index.qmd`, Description comes before Animations. Each case has a "[Julia source]" link and an embedded GIF, and both alt texts are descriptive. There are no code blocks.
- Scope: this page's diff touches only `pages/numerical-methods/richardson-extrapolation/richexaa.jl` and `richexaa.gif`. The working tree has other modified files (Lagrange, Newton interpolation, Laurent, Padé, Runge-Kutta, and untracked r3 fix records). They belong to other pages' concurrent fixes, not to this page's change.

**Final status:** committed
