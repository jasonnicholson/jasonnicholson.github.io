# Fix record: aitken-method-and-steffensen-acceleration

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/aitken-method-and-steffensen-acceleration/fix/` (`instr_cd.jl`, `newton_cd.jl`, `indep.py`, `frames_cd/`).

## Findings

### F1 — Minor — fixed (per R4-C)
- **Reproduced:** `julia instr_cd.jl` is the numerics of `aitkencd.jl` copied unchanged, plus BigFloat error printing. It prints
  `S 4 1.41421356237309448 err_vs_fl=6.6613e-16 err_vs_true=5.6946e-16 ulps_vs_fl=-3.000 log10_plotted=-15.1764`, with `n_done=4 stop=|f'(S_4)| < 1e-14`.
  `python3 -I indep.py` (mpmath, 300 bits) is independent and agrees:
  - |S₄ − √2| = 5.69461e-16;
  - |S₄ − fl(√2)| = 6.66134e-16, which is 3.0 ulps (2⁻⁵² each);
  - fl(√2) − √2 = 9.667e-17.

  The page's "about 6 × 10⁻¹⁶" fits neither reference to two significant figures. The finding holds. R4-C's two values (5.7e-16 against the true √2, 6.7e-16 against fl(√2)) are confirmed.
- **Change:** `index.qmd` only.
  - Case 2 Behavior, line 81: "its error reaches about $6 \times 10^{-16}$ … a few units in the last place of double precision" → "its error reaches $6.7 \times 10^{-16}$ … three units in the last place of double precision". After the Newton clause, one sentence is added: "These errors, like those in the bottom panel, are measured from the double-precision value of $\sqrt{2}$; from the exact $\sqrt{2}$ the final error is $5.7 \times 10^{-16}$."
  - Case 2 alt text, line 85: "reaches error about 6×10⁻¹⁶ (double-precision rounding level) after 4 steps" → "reaches error 6.7×10⁻¹⁶ from the double-precision √2 (5.7×10⁻¹⁶ from the exact √2) after 4 steps".
- **Frames:** no script change was needed.
  - I extracted `aitkencd.gif` with `giftools.jl` (23 frames) and viewed frame 23 at full size. The frames print no error value. The only values printed are "S_4=1.4142135624" and "Newton x_22 = 1.4142135151", and both agree with either reference.
  - The bottom panel plots log₁₀|x − `sqrt(2.0)`|, that is, against fl(√2). Its last point is at −15.18 (computed `log10_plotted=-15.1764`), consistent with the 6.7e-16 the text now names as the panel's reference.
- **Check:** the new numbers are re-read from the outputs above. `newton_cd.jl` prints `Newton x22=1.41421351510093896 err_fl=4.7272e-08 err_true=4.7272e-08`, so the Newton figure 4.7 × 10⁻⁸ that "These errors" also covers is the same under both references.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.81 | "$6.7 \times 10^{-16}$ after 4 steps (8 Newton steps)" | `julia instr_cd.jl` → `err_vs_fl=6.6613e-16`, `n_done=4`; `indep.py` → `\|S4-fl\| 6.66134e-16` | yes |
| index.qmd l.81 | "three units in the last place of double precision" | `instr_cd.jl` → `ulps_vs_fl=-3.000`; `indep.py` → `ulps 3.0` | yes |
| index.qmd l.81 | "These errors, like those in the bottom panel, are measured from the double-precision value of √2" | `aitkencd.jl`: `root = sqrt(2.0)`, and both `errN` and `errS` use `abs(x - root)`; frame 23 shows the last point at about −15.2 (computed −15.1764) | yes |
| index.qmd l.81 | "from the exact √2 the final error is $5.7 \times 10^{-16}$" | `instr_cd.jl` → `err_vs_true=5.6946e-16`; `indep.py` → `\|S4-sqrt2\| 5.69461e-16` | yes |
| index.qmd l.81 | Newton 4.7 × 10⁻⁸ (unchanged; now covered by "These errors") | `newton_cd.jl` → `err_fl=4.7272e-08 err_true=4.7272e-08` | yes |
| index.qmd l.85 (alt) | "reaches error 6.7×10⁻¹⁶ from the double-precision √2 (5.7×10⁻¹⁶ from the exact √2) after 4 steps" | same as the rows above | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated, because the frames print no error value (see F1).
- Frames viewed: `aitkencd.gif` frame 23 (final). Checked the legend ("Steffensen (4 steps; stopped: |f'(S_4)| < 1e-14)"), the annotation S_4=1.4142135624, and the position of the last red point in the bottom panel.
- `git status --short -- pages/numerical-methods/aitken-method-and-steffensen-acceleration` → ` M …/index.qmd` only.

## Legacy archive
- Consulted only briefly. `n2003/aitkensteffensen/AitkenSteffensenMod.html` is not at the path the brief gives. The folder holds `AitkenSteffensenProof.pdf` and `AitkenSteffensenMod/{Images,Links}`, but no module HTML.
- F1 concerns how a Float64 error is reported, so the archive has no bearing on it. The round-4 review already noted that Mathews' worked-solution images for Examples 2, 4 and 6 are missing.

## Notes
- R4-C allowed quoting either reference, or both. I gave both: 6.7e-16 against fl(√2) leads, because it is the reference the bottom panel plots, which keeps the text consistent with the frames. 5.7e-16 against the exact √2 is given beside it.
- I did not add the exact-arithmetic S₄ error (5.0e-17, `indep.py` → `exact S4 … err 4.973e-17`) to the page, since no finding asks for it.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: The diff replaces "about 6 × 10⁻¹⁶" in the Case 2 Behavior text (line 81) and in the Case 2 alt text (line 85). Following R4-C, the page now names the reference: 6.7 × 10⁻¹⁶ (three units in the last place) measured from the double fl(√2), which is what the script and the bottom panel use (`root = sqrt(2.0)`), and 5.7 × 10⁻¹⁶ measured from the exact √2.
- A scratch copy of aitkencd.jl, with print statements appended, gives S₄ = 1.41421356237309448, |S₄ − fl(√2)| = 6.6613e-16, (S₄ − fl(√2))/eps = −3.000 exactly, Newton x₂₂ error 4.7272e-08, f'(S₄) = −8.793e-15 (stop reason "|f'(S_4)| < 1e-14").
- In mpmath at 50 digits: fl(√2) − √2 = 9.6673e-17, so |S₄ − √2| = 5.69461e-16, which rounds to 5.7 × 10⁻¹⁶ (2.56 ulp). |S₄ − fl(√2)| = 3 · 2⁻⁵² = 6.66134e-16, which rounds to 6.7 × 10⁻¹⁶.
- The GIF prints no error value. The last frame shows S_4=1.4142135624 and Newton x_22 = 1.4142135151, and the last Steffensen point in the bottom panel sits at log10 = −15.18, which matches the fl(√2) reference (the exact √2 would give −15.24). Text, alt text and frames agree.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.81 | "its error reaches $6.7 \times 10^{-16}$ after 4 steps (8 Newton steps)" | Julia: \|S₄−fl(√2)\| = 6.6613e-16; 4 Steffensen steps × 2 Newton steps = 8 | correct |
| index.qmd l.81 | "three units in the last place of double precision" | (S₄−fl(√2))/eps(fl(√2)) = −3.000; ulp in [1,2) = 2⁻⁵² = 2.22e-16 | correct |
| index.qmd l.81 | "plain Newton is still at $4.7 \times 10^{-8}$ after 22" (unchanged, re-verified) | Julia: 4.7272e-08 | correct |
| index.qmd l.81 | "These errors, like those in the bottom panel, are measured from the double-precision value of √2" | script: `root = sqrt(2.0)`; errS/errN use `abs(x - root)`; plotted point at −15.18 = log10(6.66e-16) | correct |
| index.qmd l.81 | "from the exact √2 the final error is $5.7 \times 10^{-16}$" | mpmath: \|S₄ − √2\| = 5.69461e-16 | correct |
| index.qmd l.81 | "stops at S₄ because \|f'(S₄)\| is below the 10⁻¹⁴ cutoff" (unchanged) | f'(S₄) = −8.79e-15; stop_reason = "\|f'(S_4)\| < 1e-14" | correct |
| index.qmd l.85 alt | "reaches error 6.7×10⁻¹⁶ from the double-precision √2 (5.7×10⁻¹⁶ from the exact √2) after 4 steps" | same numbers as above | correct |

### New problems
None. This rests on the following: only index.qmd changed in the page folder (git diff --stat shows 2 insertions and 2 deletions); every changed number was recomputed independently in Julia (Float64) and in mpmath; the new reference sentence matches what the script actually computes; and the unchanged GIF prints no error value that could contradict the text. One cosmetic point, not a defect: the bottom-panel y-label reads "log₁₀ |xₖ − √2|" although the script subtracts fl(√2). The page text now states this explicitly, and the difference (9.7e-17) only matters at the last Steffensen point.

### Reproducibility and conventions
- No script or GIF in the page folder changed. Even so, a scratch copy of aitkencd.jl was run, and its output GIF is byte-identical to the committed aitkencd.gif (`cmp` reports no difference; the appended prints do not affect the plotting). Frames were extracted (23) and the last frame was viewed at full size.
- Conventions kept: Description comes before Animations; each case has a Julia source link and a GIF embed; the alt text is descriptive; there are no code blocks.
- Outside the page folder, the working tree has changes in other numerical-methods pages (brents, cubic-spline-quadrature, derive-numerical-differentiation-formulae, gauss-legendre, graeffes, halleys, improved-newton, mullers, pade, runge-kutta), plus the r4 fix-plan and fixes folders. These belong to other pages' fixes in this round. The diff for this page touches only its own index.qmd.

**Final status:** committed
