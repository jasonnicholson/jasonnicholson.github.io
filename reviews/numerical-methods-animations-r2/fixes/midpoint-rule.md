# Fix record: midpoint-rule

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/midpoint-rule/fix/`
(`check.py` = independent mpmath check; `legacy/` = frames of Mathews' GIF; `new/` = frames of the regenerated GIF; `old.gif` = committed GIF before the fix).

## Findings

### F1 — Minor (Fidelity) — fixed
- Reproduced: `ls /home/jason/Desktop/math-fullerton/baseline/mathews/a2001/Animations/Quadrature/Midpoint/` → `Midpointaa.gif`, `Midpointaa.html`. Frame tool on the GIF → 24 frames. A label crop of every frame (`croptile.jl` → `legacy/labels.png`) reads: 2 title frames, then Sample Points = 1, 1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 50, 60, 70, 80, 100, 120. The contact sheet (`legacy/out/sheet.png`) shows the function $y=e^{-x}\sin(8x^{2/3})+1$ printed in the frame, x axis 0 to 2, a red dot at each midpoint sample. So the page's sentence "Legacy midpoint animation assets are partially missing from the archive" is false. Finding confirmed.
- Under R2-A (follow Mathews for case parameters and missing picture elements, and correct the stale "legacy GIF missing" note), two departures named in the finding were also brought into line:
  - the sample-count sequence (page had 1,2,3,4,5,6,7,8,10,…,48,56,64,72,88,104,120; Mathews has the sequence above);
  - the sample-point markers (red dots), which the new GIF lacked.
- Change:
  - `midpointaa.jl`: `n_seq` → `[1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 50, 60, 70, 80, 100, 120]` (Mathews' distinct values; his duplicated n=1 frame is a pause and is not copied); added `scatter!` of $(x_m, f(x_m))$ at $x_m=a+(i+\tfrac12)\Delta x$, red, size 3.
  - `index.qmd` l.25: "Legacy midpoint animation assets are partially missing … available quadrature GIFs." → "This follows Mathews' midpoint animation: the same function, interval and sequence of sample counts (1 to 120), with each midpoint sample marked by a red dot."
  - `index.qmd` alt text: "… increases partition density and recomputes midpoint-rectangle area" → "… increases partition density, marks the midpoint samples with red dots and recomputes the midpoint-rectangle area".
- Check: regenerated GIF has 21 frames (n=0 curve-only intro + 20 values), all 21 frame hashes distinct; label crops (`new/labels.png`, `new/approx.png`) show Sample Points 1,2,4,…,100,120 and approximations that equal mpmath $M_n$ rounded to 6 decimals for every frame (table below). The Behavior paragraph was rechecked against the new sequence and still holds unchanged (ledger).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.25 | "follows Mathews' midpoint animation" | Legacy `Midpointaa.gif` exists, 24 frames (frame tool) | yes |
| index.qmd l.25 | "the same function" | Legacy frame prints $y=e^{-x}\sin(8x^{2/3})+1$ (`legacy/out/sheet.png`); script `f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1`. Legacy approximations 2.727929 (n=1), 2.011118 (4), 2.051517 (8), 2.036937 (12), 2.029606 (16), 2.023254 (24), 2.020644 (32), 2.018375 (50), 2.017481 (70), 2.016945 (100) equal mpmath $M_n$ for this f (`python3 -I check.py`: 2.727929118, 2.011118372, 2.051516783, 2.036937496, 2.029606367, 2.023254156, 2.020643959, 2.01837458, 2.017481017, 2.016945074) | yes |
| index.qmd l.25 | "interval" ([0,2]) | Legacy x axis ticks 0.5,1,1.5,2 with curve from 0 to 2 (sheet); script `a, b = 0.0, 2.0` | yes |
| index.qmd l.25 | "sequence of sample counts (1 to 120)" | Legacy labels (`legacy/labels.png`): 1,1,2,4,6,8,10,12,14,16,20,24,28,32,40,50,60,70,80,100,120; new labels (`new/labels.png`): 1,2,4,6,8,10,12,14,16,20,24,28,32,40,50,60,70,80,100,120 — same distinct values, legacy repeats n=1 once | yes |
| index.qmd l.25 | "each midpoint sample marked by a red dot" | Legacy sheet: red dot at each rectangle top on the curve; new frame_003 (n=2): dots at x=0.5, 1.5 on the curve; frame_021 (n=120): 120 dots on the curve | yes |
| index.qmd alt text | "marks the midpoint samples with red dots" | as above; dots drawn from `xs = a + (i+0.5)dx`, the same points as `midpoint_sum` | yes |
| index.qmd l.23 (unchanged, rechecked) | "Each frame increases sample-point density" | new frames n = 0,1,2,4,…,120 strictly increasing, 21 distinct frame hashes | yes |
| Behavior (unchanged, rechecked for new sequence) | "first few frames jumps above and below the integral" | errors n=1 +0.7116, n=2 −0.7851, n=4 −0.00516, n=6 +0.0430 (`check.py`) | yes |
| Behavior (unchanged) | "from 6 sample points on it stays above … and decreases toward it in every frame" | errors positive for every n ≥ 6 in sequence; $M_n$ strictly decreasing on each consecutive pair 6→8→…→120 (`check.py` "dec" column) | yes |
| Behavior (unchanged) | $\int_0^2 f \approx 2.016280$ | mpmath (x=t³): 2.0162797196170963279 | yes |
| Behavior (unchanged) | "last frame (120 sample points) gives 2.016771, still about 0.00049 high" | $M_{120}$=2.016771455, error 0.000491736; frame_021 label "Approximation = 2.016771" | yes |
| Behavior (unchanged) | "From 4 sample points on … closer than the left- or right-endpoint sum" | `check.py`: closer_than_LR True for every n ≥ 4 in the new sequence, False at n=1,2 | yes |
| Behavior (unchanged) | "divides it by about 3.11 (from 24 to 48 subintervals), tending to $2^{5/3}\approx 3.17$" | `check.py`: ratio 3.11248; $2^{5/3}$=3.1748 (not frame-dependent) | yes |
| GIF frame labels | Approximation values, all 20 frames | `new/approx.png` vs `check.py`: 2.727929, 1.231216, 2.011118, 2.05928 (=2.059280), 2.051517, 2.04303 (=2.043030), 2.036937, 2.032667, 2.029606, 2.025636, 2.023254, 2.021708, 2.020644, 2.019305, 2.018375, 2.01783 (=2.017830), 2.017481, 2.017243, 2.016945, 2.016771 — all equal $M_n$ rounded to 6 decimals | yes |

## Scripts and GIFs
- Script changed: `pages/numerical-methods/midpoint-rule/midpointaa.jl` (n_seq; midpoint dots).
- GIF regenerated: `midpointaa.gif` (`cd pages/numerical-methods/midpoint-rule && julia midpointaa.jl`), 21 frames (was 25).
- Frames viewed: label/approximation crops of all 21 frames; full-size frame_003 (n=2: two rectangles, heights 0.4257 and 0.8055, dots at the midpoints on the curve) and frame_021 (n=120: dots follow the curve, nothing clipped, labels legible, no overlap of labels with curve/rectangles).
- `git status --short -- pages/numerical-methods/midpoint-rule` after regeneration:
  ```
   M pages/numerical-methods/midpoint-rule/index.qmd
   M pages/numerical-methods/midpoint-rule/midpointaa.gif
   M pages/numerical-methods/midpoint-rule/midpointaa.jl
  ```

## Legacy archive
Consulted. `n2003/midpointrule/` does not contain the module page; `n2003/MidpointRuleMod.html` sits one level up (as the reviewer said). The animation is `a2001/Animations/Quadrature/Midpoint/Midpointaa.gif` (wrapper `Midpointaa.html`, text only: "Midpoint Rule for Numerical Quadrature", "24 frames"). It shows the same function on [0,2], sample counts 1,1,2,4,…,100,120, a red dot per midpoint sample, and 6-decimal approximations that match the page's computation exactly. The page now follows it in function, interval, sample counts and markers. Remaining differences, left as is: the legacy GIF has two title frames and a repeated n=1 frame (the new GIF has one curve-only intro frame), and prints the function inside the frame (the page heading and Animations intro name it instead).

## Notes
- The new GIF's approximation labels use Julia `round(...; digits=6)`, which drops trailing zeros (n=6 "2.05928", n=10 "2.04303", n=60 "2.01783"). The values are correct; this is cosmetic, not a finding, and was not changed.
- No independent-check line was given (Minor, unverified); the finding was reproduced directly as above.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The false sentence "Legacy midpoint animation assets are partially missing from the archive..." (index.qmd old line 25) is gone. It now reads: "This follows Mathews' midpoint animation: the same function, interval and sequence of sample counts (1 to 120), with each midpoint sample marked by a red dot." Every part of the new sentence is true:
  - **Archive GIF.** I extracted all 24 frames of `/home/jason/Desktop/math-fullerton/baseline/mathews/a2001/Animations/Quadrature/Midpoint/Midpointaa.gif`. Decoded frame hashes show frames 1–3 identical (title), frames 4–5 identical (n = 1 held for two frames), then 19 distinct frames. I cropped the label rows of every frame (`check/legacy_labels.png`, `check/legacy_approx.png`). The distinct sample counts are 1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 50, 60, 70, 80, 100, 120.
  - **Correction to the finding.** The finding listed "2 title frames, then 1, 1, 2, …", which counts only 23 frames. The archive actually has 3 title frames and n = 1 held twice. The distinct sequence is the same either way.
  - **Script sequence.** The new `n_seq` in `midpointaa.jl` is exactly those 20 values in the same order. The script draws one title frame (n = 0) and shows n = 1 once. That is a pacing difference only; the sentence claims the same sequence of counts, which holds.
  - **Approximations.** All 20 legacy approximations match my mpmath midpoint sums to 6 decimals: 2.727929, 1.231216, 2.011118, 2.059280, 2.051517, 2.043030, 2.036937, 2.032667, 2.029606, 2.025636, 2.023254, 2.021708, 2.020644, 2.019305, 2.018375, 2.017830, 2.017481, 2.017243, 2.016945, 2.016771. The new GIF prints the same values.
  - **Red dots.** The red dots are present. In full-size frames 2, 12 and 21 (n = 1, 24, 120), one red dot sits at each (midpoint, f(midpoint)), on the top centre of each rectangle. The script builds them from `xs = a + (i+0.5)dx` and `f.(xs)`.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.25 | "follows Mathews' midpoint animation" | Legacy GIF frames read and compared: same function label e^{-x}sin(8x^{2/3})+1, x-range [0,2], same counts and same approximations | true |
| index.qmd l.25 | "same function, interval" | Script `f(x)=exp(-x)*sin(8x^(2/3))+1`, a,b = 0,2; legacy frame label and axis 0–2 | true |
| index.qmd l.25 | "sequence of sample counts (1 to 120)" | Legacy distinct counts 1…120 (20 values, listed above) equal `n_seq` exactly | true |
| index.qmd l.25 | "each midpoint sample marked by a red dot" | Full-size frames 2/12/21: one red dot per rectangle at the midpoint on the curve; count equals n (visually for n = 1, 24) | true |
| index.qmd l.33 alt | "each frame increases partition density, marks the midpoint samples with red dots and recomputes the midpoint-rectangle area" | Frames 2–21 have n strictly increasing, red dots, and an updated approximation label. Frame 1 is a title frame with the curve only; that is the same as before the fix and the same convention as the legacy GIF. | true |
| midpointaa.jl comment | "Sample counts as in Mathews' legacy Midpointaa.gif" | as above | true |
| Re-verified unchanged Behavior (l.29) vs new sequence | "first few frames jump above and below" | errors: n=1 +0.712, n=2 −0.785, n=4 −0.0052 | true |
| " | "from 6 sample points on it stays above … and decreases in every frame" | n = 6…120 (all 15 frames): error > 0, M strictly decreasing frame to frame | true |
| " | ∫ ≈ 2.016280 | mpmath quad, split at 0: 2.01627971962 | true |
| " | last frame 120 → 2.016771, ≈0.00049 high | M120 = 2.016771455, error 4.917e-4 | true |
| " | "From 4 sample points on, midpoint closer than left/right sums" | Checked every n from 4 to 120, not only the frames: holds for all. Fails at n = 3. In the new sequence, n = 1 and n = 2 fail and n = 4 holds. | true |
| " | f'≈(16/3)x^{-1/3} near 0 | d/dx sin(8x^{2/3}) = (16/3)x^{-1/3}cos(·); e^{-x}cos(·)→1 | true |
| " | ratio 3.11 from 24→48, tending to 2^{5/3}≈3.17 | ratios 3.1125 (24→48), 3.1592, 3.1676, 3.1709, 3.1725; 2^{5/3} = 3.1748 | true (48 is not a frame, and the sentence doesn't claim it is) |
| GIF labels | "Sample Points = n" / "Approximation = …" for all 20 frames | Label crops (`check/new_labels.png`) vs computed M_n | correct. One display quirk predates the fix: `round(x; digits=6)` drops a trailing zero, so n = 6, 10 and 60 show 2.05928, 2.04303 and 2.01783 instead of 2.059280, 2.043030 and 2.017830. The values are numerically right, and the code is unchanged by this fix (old sequence also had 6 and 10). |

### New problems
None. This rests on three checks:
- I read the archive frames myself and confirmed the 20 sample counts and all 20 approximations.
- I re-verified every Behavior claim against the new sequence by independent mpmath computation, including the monotonic-decrease claim, which is sensitive to which frames exist.
- I inspected full-size first, middle and last frames.

### Reproducibility and conventions
- **Reproducibility.** I copied `midpointaa.jl` to scratch and ran `julia midpointaa.jl`. The output GIF is byte-identical to the committed one (sha256 674bfc8b…586a, the same oid as the LFS pointer in the diff), and decoded frame md5s are identical (21 frames). I did not decode the pre-fix GIF: the HEAD blob is an LFS pointer and I ran no LFS command.
- **Conventions.** These still hold:
  - Description comes before Animations.
  - The case has a heading, a `[Julia source](midpointaa.jl)` link and the GIF embed.
  - The alt text is descriptive.
  - There are no code blocks.
- **Files outside the page folder.** Within the page folder, only `index.qmd`, `midpointaa.gif` and `midpointaa.jl` changed, matching fix.diff. The working tree also has many other modified pages, but those belong to other pages' work on this branch. Nothing in this fix's diff touches a file outside the folder.

**Final status:** committed
