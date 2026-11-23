# Fix record: the-tangent-parabola

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r6fix/the-tangent-parabola/fix/`

## Findings

### F1 — Minor — fixed

- **Reproduced:** extracted the committed GIF with `giftools.jl` (22 frames). Frames 18 to 22 share md5 `2bcb3a34…`. Full-size `committed/frame_022.png` shows two legend entries "Tangent parabola T₂(x)", one dashed and one dotted, and the two lines overlap as a dash-dot curve. The cause is in the script: `h = 0` set `P_vals = T2_vals`, and the dotted `T2_vals` overlay was always drawn as well.
- **Change:** `tangparabaa.jl`.
  - The dashed curve is drawn only when `h > 1e-6`, with a one-line comment saying why. Before: `plot!(x_plot, P_vals; …)`. After: `h > 1e-6 && plot!(x_plot, P_vals; …)`.
  - The three `else`-branch assignments that only fed that dashed draw (`P_vals`, `p_lbl`, `p_clr`) are removed.
  - The `anim = @animate for h in h_vals` loop and the `gif(anim, joinpath(@__DIR__, "tangparabaa.gif"); fps=4)` call are as committed.
- **Requirement applied:** the coordinator revised the brief's pixel requirement. The rendered source frames 1 to 17 must stay identical; re-dithering of the encoded GIF is acceptable.
- **Check:**
  - Scratch renders of the committed script and the fixed script (`pngcheck/orig`, `pngcheck/new`), hashing each rendered PNG in `anim.dir` with SHA-256: frames 1 to 17 are identical. Frames 18 to 22 differ from the original and share one new hash.
  - The scratch render of the committed script reproduces the committed GIF byte for byte, so the comparison baseline is the committed animation.
  - The encoded GIF's frames 1 to 17 are re-dithered: all 17 decoded-frame hashes differ from the committed GIF, because Plots builds one palette from all 22 frames and the hold frames changed. Their rendered frames are unchanged.
  - GIF size 700×500, 22 frames, 250 ms delay and loop 0 are unchanged.
  - Full-size frame 22 shows f, one dotted T₂ curve, one T₂ legend entry and x₀. Frames 1 and 17 still show the secant parabola, T₂ and the nodes.
  - sympy's degree-2 series of sin x at 1 agrees with the script's T₂ on [0, π] to 2.2e-16.

## Ledger of changed text

No sentence in `index.qmd` changed. The alt text ("green dotted", "followed by the tangent parabola alone") remains accurate for the new hold frames.

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Hold-frame legend (GIF frames 18–22) | One "Tangent parabola T₂(x)" entry, previously two | Viewed `page2/frame_022.png` → one entry, dotted | yes |
| `tangparabaa.jl` comment | "The hold frames (h = 0) have no secant parabola, so T₂ is drawn once, by the dotted line below" | `h_vals[18:22] = 0`; the guard skips the dashed draw; `page2/frame_022.png` shows one dotted T₂ and no nodes | yes |

## Scripts and GIFs

- Script changed: `tangparabaa.jl`. GIF regenerated in place from the page folder: `tangparabaa.gif` (145,202 → 145,477 bytes).
- Frames viewed at full size: 1, 17 and 22. Checked the curves, node markers, titles, legend entries and that the T₂ curve appears once in the hold frame.
- `git status --short -- pages/numerical-methods/the-tangent-parabola`:

```
 M pages/numerical-methods/the-tangent-parabola/tangparabaa.gif
 M pages/numerical-methods/the-tangent-parabola/tangparabaa.jl
```

## Legacy archive

Consulted `n2003/TangentParabolaMod.html` as text. It has Examples 1 to 5, with "Various Scenarios and Animations for the Tangent Parabola" heading the part that contains Example 4, and Example 5 covering degree-6 Newton polynomials. A filename search of `a2001/Animations/` for `*tang*` found nothing. The fix changes only how T₂ is drawn in the hold frames, so the archive did not affect it, and there is no difference from the archive to report.

## Notes

- The page has no `## Description` section. This is a pre-existing convention gap that no finding names, so it was not added.

### Director note

The checker could not run git status. The director confirmed that only tangparabaa.jl and tangparabaa.gif changed in the page folder. The page has no Description section; this predates the fix and no finding covers it, so it is left for Jason.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence (script): the dashed plot is now guarded by `h > 1e-6`, so in the hold frames (h = 0) T2 is plotted once, by the dotted line with label "Tangent parabola T₂(x)". The assignments to `P_vals`, `p_lbl` and `p_clr` were removed from the `else` branch; their only remaining use is behind the same guard, and the script runs to completion.
- Evidence (picture): full-size frames 18 and 22 of the regenerated GIF show three legend entries: f(x) = sin(x), Tangent parabola T₂(x) (once, dotted), x₀. The pre-fix frame 22, rendered from the reverse-applied diff, shows the duplicated entry and the dash-dot overlay described in the finding.
- Evidence (scope): the 22 frames were rendered to PNG from the pre-fix and post-fix scripts. PNGs 1–17 are byte-identical, so the re-dithering of encoded frames 1–17 is palette only. PNGs 18–22 differ, as intended. The five post-fix hold frames are identical to each other (PNG md5 `faac6385…`, and one decoded GIF frame hash across frames 18–22).
- Follows owner decision R6-E (Tangent Parabola F1, duplicate legend entry, fixed as reported) and the finding's first suggested correction.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| `tangparabaa.jl` line 59 (comment) | "The hold frames (h = 0) have no secant parabola" | `h_vals` ends in 5 zeros; the secant branch needs `h > 1e-6`; frames 18–22 show no secant curve and no nodes | True |
| `tangparabaa.jl` line 59 (comment) | "so T₂ is drawn once, by the dotted line below" | Code path; frames 18 and 22 show one dotted T2 and one legend entry | True |
| `tangparabaa.jl` line 60 | guarded dashed secant plot | Frames 1, 11 and 17 still draw the secant parabola with the h label; PNGs 1–17 byte-identical to pre-fix | Correct |
| GIF, frames 18–22 | Legend "Tangent parabola T₂(x)" | Curve is T2 = sin 1 + cos 1 (x−1) − ½ sin 1 (x−1)²; unchanged code | Correct |

No page text (`index.qmd`) changed. Supporting check of the unchanged claim the picture rests on: sup-norm error of the secant parabola against T2 on [0, π] for h = 0.08, 0.04, 0.02, 0.01 is 8.005e-4, 2.002e-4, 5.004e-5, 1.251e-5 (halving ratios 3.999, 4.000, 4.000, so O(h²)). The log-spaced sequence contains h = 0.1 (frame 9) and h = 0.01 (frame 17), as the page says. The existing alt text (red dashed secant, green dotted tangent, then the tangent parabola without the secant) matches the new frames.

### New problems

None introduced by the fix. This rests on the PNG comparison of all 22 frames, full-size views of frames 1, 11, 17, 18 and 22, and the byte-identical regeneration.

Pre-existing, not caused by this fix: `index.qmd` has no `## Description` section before `## Animations`, which the page conventions require (Minor). The file is not in the fix diff.

### Reproducibility and conventions

- Reproducibility: a scratch copy of `tangparabaa.jl` regenerates `tangparabaa.gif` byte-identical to the page GIF (sha256 `c6edc7ac…92d8ed`, matching the LFS pointer in the diff).
- Conventions: source link, GIF embed, descriptive alt text and no code blocks are all present. The `## Description` section is missing (pre-existing, see above).
- Files changed: `fix.diff` lists only `tangparabaa.gif` and `tangparabaa.jl` in the page folder.
- Not verified: that no file outside the page folder changed. My read-only shell command that included `git status` was denied by the permission system, so I did not check the repository-wide state. The pre-fix script was rebuilt by reverse-applying `fix.diff` in scratch rather than with `git show`.

**Final status:** committed
