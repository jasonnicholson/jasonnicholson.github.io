# Fix record: secant-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r5fix/secant-method/fix/` (`iter_cc.jl`, `indep.py`, `indep2.py`, `mech.jl`, `old/`, `old_frames/`, `new_frames/`, `legacy_cc/`).

## Findings

### F1 — Minor — fixed (decision R5-B)
- Reproduced: `julia iter_cc.jl` (instrumented copy of the `secantmethodcc.jl` loop) prints p2 −1.2213792056860207, p3 0.01803629819672592, p4 −0.006723294978554995, p5 4.5722058130987647e-7, p6 −6.8886493391088996e-12, p7 4.798293787661118e-25, **p8 = 0.0** (denominator 6.89e-12, guard not triggered). Then p9, p10, p11 = 0.0 are all written by the guard (`denom = -4.8e-25`, then `0.0`, `guard=true`), so they are not secant iterates. `atan(p)==p` is true for p6 and p7. Exact arithmetic (`indep.py`, mpmath 400 digits, starts 1.35 and 1.30): p8 = −7.59285e-48, p9 = 5.83175e-97, p10 = −1.12069e-191. With the exact Float64 starting values (`indep2.py`): p7 = 4.80018e-25, p8 = −7.59285e-48. Old GIF (rebuilt from the HEAD script, sha256 6d25cc6a… = the LFS oid): 10 frames; frame 7's legend reads "p8 = 0"; frames 8–10 have no secant and no new iterate, only the legends "p7, p8", "p8, p9", "p9, p10".
- Mechanism isolated (`julia mech.jl`): with the same Float64 p6 and p7, the secant formula gives 0.0 when atan is evaluated in Float64 and −7.5899e-48 when atan is evaluated in BigFloat (2000 bits). |atan(p6) − p6| = 1.09e-34, far below the spacing of p6 (8.1e-28). So the exact zero comes from atan rounding to the identity at p6 and p7.
- Change:
  - `secantmethodcc.jl`: `n_iters = 10` → `7`, which removes the three guard frames; the guard no longer fires in the run. `fmt_p` for an exact zero: `"0"` → `"0 (double-precision result)"`. Header comment `n=10` → `n=7`, plus a three-line comment saying why the run stops at p8.
  - `secantmethodcc.gif`: regenerated (7 frames).
  - `index.qmd` Case 3 Behavior: one sentence added, explaining the last frame's p8 = 0 and giving the exact value.
- Check: the new GIF has 7 frames. Frame 7 (viewed full size) draws the secant through p6 and p7, with the red diamond at the origin and the legend "p8 = 0 (double-precision result)", "p6", "p7". The legend is fully legible inside its box. Frames 1–6 have the same content as the old frames 1–6 (contact sheets compared: labels p2 = −1.22138, p3 = 0.01804, p4 = −0.00672, p5 = 4.57e-07, p6 = −6.89e-12, p7 = 4.80e-25). Their PSNR against the old frames is 57.4, 58.5, 58.1, 57.9, 57.8 and 57.9 dB, which is only a global GIF palette shift after the frames were dropped, so the frames are not byte-identical.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `secantmethodcc.jl` l.3 | `n=7` | matches `n_iters = 7`; GIF has 7 frames (`giftools.jl` → "7 frames") | yes |
| `secantmethodcc.jl` l.5–7 comment | run stops at p8; atan(x) rounds to x at p6, p7; secant hits origin; p8 = 0.0; exact p8 ≈ −7.6e-48; later denominators ~1e-25 | `iter_cc.jl` → `atan(p)==p: true` for p6, p7; p8 = 0.0; next denom −4.798e-25. `mech.jl` → Float64 0.0 vs BigFloat −7.59e-48. `indep2.py` → −7.59285e-48 | yes |
| `secantmethodcc.jl` l.18 | `n_iters = 7` | 7 frames, last one marks p8 | yes |
| `secantmethodcc.jl` l.39–40 | `"0 (double-precision result)"` label for an exact 0.0 | only p8 is exactly 0.0 in the 7-frame run (`iter_cc.jl`); frame 7 legend reads "p8 = 0 (double-precision result)" | yes |
| GIF frame 7 legend | "p8 = 0 (double-precision result)" | `new_frames/frame_007.png` viewed | yes |
| index.qmd Case 3 | "The animation ends at $p_8$" | GIF has 7 frames; frame 7 marks p8 | yes |
| index.qmd Case 3 | "which double precision returns as exactly 0" | `iter_cc.jl` → p8 = 0.0 | yes |
| index.qmd Case 3 | $p_6 \approx -6.9 \times 10^{-12}$ | script −6.8886e-12; mpmath −6.88865e-12 | yes |
| index.qmd Case 3 | $p_7 \approx 4.8 \times 10^{-25}$ | script 4.7983e-25; mpmath 4.80018e-25 (both 4.8 to 2 s.f.) | yes |
| index.qmd Case 3 | "the computed $\arctan(x)$ equals $x$" at p6, p7 | `iter_cc.jl` → `atan(p)==p: true` for p6 and p7 (false for p0–p5) | yes |
| index.qmd Case 3 | "so the secant through them passes through the origin" | with f(p6) = p6 and f(p7) = p7 the secant is y = x, so p8 = p7 − p7·1 = 0; `mech.jl` → Float64 0.0 and BigFloat atan −7.59e-48 for the same p6, p7 (cause isolated) | yes |
| index.qmd Case 3 | "In exact arithmetic $p_8 \approx -7.6 \times 10^{-48}$" | `indep.py` / `indep2.py` → −7.59285e-48 | yes |

Unchanged text was re-checked against the 7-frame GIF. The alt text ("oscillate across x=0 with decreasing amplitude before converging") still holds: p1…p7 alternate in sign with decreasing magnitude. The heading and GIF title are unchanged.

## Scripts and GIFs
- Script changed: `secantmethodcc.jl`. GIF regenerated: `secantmethodcc.gif` (`cd pages/numerical-methods/secant-method && julia secantmethodcc.jl`). The other five scripts and GIFs were not touched.
- Frames viewed: the new contact sheet (all 7 frames) and frame 7 at full size; the old contact sheet (10 frames), for comparison.
- `git status --short -- pages/numerical-methods/secant-method`:
  ```
   M pages/numerical-methods/secant-method/index.qmd
   M pages/numerical-methods/secant-method/secantmethodcc.gif
   M pages/numerical-methods/secant-method/secantmethodcc.jl
  ```

## Legacy archive
Consulted. `n2003/SecantMethodMod.html` Example 5 is "Convergence, Oscillation" (the arctan case). The legacy animation `a2001/Animations/RootFinding/SecantMethod/Secantcc.gif` has 15 frames (tan⁻¹(x), starts 1.35 and 1.30). It ends at p5 = 4.57221×10⁻⁷, so Mathews never shows the double-precision zero. Its values p2 = −1.22138, p3 = 0.01804, p4 = −0.00672 and p5 = 4.57221e-7 agree with the script. The page goes three steps further than Mathews, to p8. That is kept, because the label and the Behavior sentence now say what the last step is.

## Notes
- R5-B asks to remove the false frames and to label the zero as a double-precision result. Both are done. The Behavior sentence was added so the page explains the label and gives the exact value. It is one sentence, and every part of it is computed above.
- The committed GIFs are Git LFS pointers, so `git show HEAD:<gif>` returns the pointer. The old GIF was rebuilt from the HEAD script in scratch, and its sha256 matches the LFS oid.
- Pre-existing gap, not touched: the page has no `## Description` section.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `n_iters` is now 7, so the GIF has 7 frames. Before the fix it had 10 (`giftools.jl`: 7 frames now; the pre-fix GIF from the LFS object 6d25cc6a… has 10). The last frame, frame 7, draws the secant through (p6, f(p6)) and (p7, f(p7)) and labels its intercept "p8 = 0 (double-precision result)". I read the label in the full-size frame and it is legible. The three dead frames, which showed copies of p8 made by the guard as p9 and p10, are gone. This follows decision R5-B: remove the false frames and labels, and say that the zero is a double-precision result.
- My Julia rerun of the iteration (`check/iter.jl`) gives p2 = −1.22138, p3 = 0.0180363, p4 = −0.00672329, p5 = 4.5722e-7, p6 = −6.8886e-12 and p7 = 4.7983e-25. `atan(p) == p` holds for p6 and p7, and p8 comes out as exactly 0.0. The mpmath reference at 600 digits (`check/exact.py`) gives p6 = −6.88865e-12, p7 = 4.80018e-25 and p8 = −7.59285e-48. The double-precision values agree with it through p7 at the precision shown on the frames: frame 6 shows "p7 = 4.80e-25" and frame 4 shows "p5 = 4.57e-07".
- No new iterate or secant line in the animation depends on the 1e-14 guard any more. Every denominator used is at least 6.9e-12, so the guard never fires.
- Frame and step counts for Case 3: the page states no frame count anywhere. The only count-like statement is "The animation ends at p₈", and it matches frame 7. The script header's "n=7" matches `n_iters = 7`. The alt text says the iterates "oscillate across x=0 with decreasing amplitude before converging", and the 7 frames still show that.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 3 Behavior | "The animation ends at p₈" | Frame 7 is the last frame, and its red diamond is p8 | correct |
| index.qmd | "which double precision returns as exactly 0" | Julia gives p8 = 0.0 exactly | correct |
| index.qmd | p₆ ≈ −6.9×10⁻¹² | double −6.8886e-12, exact −6.88865e-12 | correct |
| index.qmd | p₇ ≈ 4.8×10⁻²⁵ | double 4.7983e-25, exact 4.80018e-25 | correct |
| index.qmd | "the computed arctan(x) equals x" at p6 and p7 | `atan(p6)==p6` and `atan(p7)==p7` are both true in Julia. The relative cubic term is x²/3 ≤ 1.6e-23, far below machine epsilon | correct |
| index.qmd | "so the secant through them passes through the origin" | With slope 1 and f(p7) = p7, the intercept is p7 − p7·1 = 0. Confirmed numerically | correct |
| index.qmd | "In exact arithmetic p₈ ≈ −7.6×10⁻⁴⁸" | mpmath gives −7.59285e-48 | correct |
| secantmethodcc.jl header | "n=7" | `n_iters = 7`, and the GIF has 7 frames | correct |
| secantmethodcc.jl header | the run stops at p8, atan rounds to x, p8 = 0.0, exact p8 about −7.6e-48 | same checks as the page text above | correct |
| secantmethodcc.jl header | "Later steps would divide by f(p8)-f(p7) ~ 1e-25" | The value is −4.8e-25. "~1e-25" is right as an order of magnitude | correct (loose) |
| secantmethodcc.jl `n_iters` | 10 → 7 | gives 7 frames, the last one at p8 | correct |
| secantmethodcc.jl `fmt_p` | label for an exact 0 is "0 (double-precision result)" | Only p8 triggers it, in frame 7, and it renders fully inside the legend box | correct |
| secantmethodcc.jl comment | "An iterate that is exactly 0.0 is a double-precision result…" | true for this run | correct |

### New problems
None. This rests on:
- every changed sentence and number checked against the independent iteration and the 600-digit mpmath reference;
- frames 1, 4, 6 and 7 inspected at full size;
- a pixel diff of frames 1–6 between the old and new GIFs, which finds only 9–14 pixels changed per frame (palette quantisation). Frame 7 differs only in the wider legend box.

The labels and the history points are unchanged. I found no other statement on the page that depended on the 10-frame GIF.

### Reproducibility and conventions
- I ran a scratch copy of `secantmethodcc.jl`. Its output is byte-identical to the committed GIF (sha256 c6060998…fd4a3, which also matches the LFS pointer in the diff).
- Conventions are unchanged by the fix: an introductory description precedes the case list under "## Animations", each case has a source link and an embed, the alt text is descriptive, and the page has no code blocks.
- The diff touches only files in `pages/numerical-methods/secant-method/`: index.qmd, secantmethodcc.jl and secantmethodcc.gif. Other modified files in the working tree, such as broyden, laurent, muller, nonlinear-systems and the reviews/…/fixes notes, belong to other pages' fixes, not this one.

**Final status:** committed
