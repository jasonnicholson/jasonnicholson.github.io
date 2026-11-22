# Fix record: false-position-or-regula-falsi-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/false-position-or-regula-falsi-method/fix/` (below: `$S`).

Evidence scripts:
- `$S/scripts/indep.py`: independent check of both cases in mpmath (50 digits). It computes the roots, convexity on the bracket, 40 regula falsi steps, error ratios, the asymptotic ratio 1 − f'(x*)(b − x*)/f(b), and bisection on the same bracket. Run with `/usr/bin/python3 -I $S/scripts/indep.py`. Output: `$S/indep_out.txt`.
- `$S/indep_B_precision.txt`: explains why the "all 40" checks in Case B print False. The first failure is at i = 40, where the error is 6.4e−52, below the 50-digit working precision.
- `$S/scripts/rfaa_print.jl`, `$S/scripts/rfbb_print.jl`: the committed scripts' own loops, printing a, b, c, f(c) and the legend label for each step. Output: `$S/rfaa_values.txt`, `$S/rfbb_values.txt`.
- `$S/scripts/rfaa_frames.jl`, `$S/scripts/rfbb_frames.jl`: for each frame, the shaded bracket and the points the secant is drawn through, taken from the scripts' own arrays. Output: `$S/rf*_frames.txt`.
- `$S/frames_before_aa/`, `$S/frames_before_bb/`: extracted frames, contact sheet and framemd5 of the committed GIFs. The regenerated GIFs are byte-identical to these, so the same frames serve as the after-frames.

## Findings

### F1 — Error — fixed
- **Reproduced.** In `indep.py`, mpmath `findroot` gives root = 1.3652300134141. `polyroots` shows the only real root is 1.36523001341; the other two are −2.68261500671 ± 0.358259359924i. f(1.3688) = 0.0590558, so 1.3688 is not a root. The script's own c₁₂ = 1.36522935002777 (`rfaa_values.txt`), and its legend label is `c_12 = 1.365229`. `frames_before_aa/frame_013.png` shows that label.
- **Change.**
  - index.qmd Case A Behavior: `x^* \approx 1.3688` → `x^* \approx 1.3652`.
  - regulafalsiaa.jl header comment: `True root ≈ 1.3688` → `True root ≈ 1.36523`.
- **Check.** 1.3652300134 rounds to 1.3652 (4 dp) and to 1.36523 (5 dp). `grep -rn 1.3688` on the page folder now finds nothing. The alt text "near x=1.37" was already correct and is unchanged.

### F2 — Error — fixed
- **Reproduced.** Both computations agree:
  - **Script loop.** `rfaa_values.txt` gives `b_next=2.0` and `a_next=c` at all 12 steps, with f(c) running from −10.0 to −1.0954759595e−5. The summary line reads `all f(c)<0: true  b fixed: true  c increasing: true`.
  - **mpmath.** `indep.py` gives the same sequence: all 40 f(c) < 0, b fixed, and c below the root. The minimum of f'' = 6x + 8 on [−1, 2] is 2.0 (> 0), so f is convex there.
  - **Frames.** In `frames_before_aa/frame_001.png` the shading is [−1, 2]; by frame_013 it is [1.365, 2], with the blue dot fixed at (2, 14).
- **Change.** index.qmd Case A Behavior.
  - Before: "The left endpoint $a = -1$ stays fixed throughout because $f(-1) < 0$ and all successive false-position points $c$ also satisfy $f(c) < 0$, so the algorithm keeps replacing $a$ with $c$ while $b = 2$ holds."
  - After: "The right endpoint $b = 2$ stays fixed throughout: $f(-1) < 0$ and every false-position point $c$ also satisfies $f(c) < 0$ ($f$ is convex on the bracket), so the algorithm keeps replacing $a$ with $c$ ($a = -1, 0, 0.8333, 1.2088, \dots$) while $b = 2$ holds."
- **Check.** See the ledger. The a-sequence −1, 0, 0.8333333…, 1.2087912… comes from `rfaa_values.txt` (a, then a_next for i = 1..3). The heading and alt text ("with the right endpoint fixed and successive false-position points converging from the left") were already consistent and are unchanged.

### F3 — Error — fixed
- **Reproduced.** Both computations agree:
  - **Script loop.** `rfbb_values.txt` gives `b_next=1.0` and `a_next=c` at all 10 steps. f(c) runs from −0.0893 to −1.85e−13, and c increases (0.685073, 0.736299, 0.738945, 0.739078, …). The summary line reads `all f(c)<0: true  b fixed: true  c increasing: true`.
  - **mpmath.** `indep.py` gives the root as 0.739085133215161 and f(1) = 0.45969769. The minimum of f'' = cos x on [0, 1] is 0.540302 (> 0), so f is convex there.
  - **Frames.** `frames_before_bb/frame_003.png` shows the shading as [0.736, 1] with the blue dot at (1, 0.46).
- **Change.**
  - **index.qmd Case B Behavior.**
    - Before: "The left endpoint $a = 0$ remains fixed at $f(0) = -1$ throughout, while successive false-position points advance from the right. … shrinks only on the right side"
    - After: "The right endpoint $b = 1$ (where $f(1) \approx 0.4597$) remains fixed throughout, because $f$ is convex on $[0, 1]$ and every false-position point satisfies $f(c) < 0$; the points advance from the left ($c = 0.6851, 0.7363, 0.7389, \dots$). … shrinks only on the left side"
  - **index.qmd Case B alt text.** "with the left endpoint fixed at 0 while the right endpoint steps in" → "with the right endpoint fixed at 1 while the left endpoint steps in".
  - **regulafalsibb.jl:3-4.** "left endpoint stays fixed at 0. / The successive c points converge from the right." → "right endpoint stays fixed at 1. / The successive c points converge from the left."
- **Check.** See the ledger.

### F4 — Minor — fixed
- **Reproduced.** In `indep.py`, the Case A error ratios |c_{k+1} − x*|/|c_k − x*| are 0.3896, 0.29412, 0.26275, 0.2542, 0.25201, 0.25146, 0.25132, 0.25128, 0.25127, 0.25127, 0.25127. The asymptotic ratio 1 − f'(x*)(2 − x*)/f(2) is 0.251271.
  - After 12 steps, the regula falsi error is 6.634e−7.
  - Bisection on [−1, 2] after 12 halvings has a half-width of 3.662e−4 and an actual midpoint error of 1.264e−4.
  - So on this problem regula falsi is not slower than bisection, and the comment "(slower than bisection)" is wrong.
- **Change.** regulafalsiaa.jl:5.
  - Before: "one endpoint tends to stay fixed as the other converges (slower than bisection)."
  - After: "one endpoint tends to stay fixed as the other converges, so convergence is only linear. / Here b = 2 stays fixed and the error ratio |c_{k+1} - x*| / |c_k - x*| settles at about 0.251 / (bisection halves its bracket each step, a factor of 0.5)."
- **Check.** The ratios above settle at 0.25127, and the limit is 0.251271. "Only linear" holds because the limit ratio is nonzero. This is a comment-only change: the regenerated GIF is byte-identical.

### F5 — Minor — fixed (text, per D7)
- **Reproduced.**
  - **Code.** regulafalsiaa.jl:48-49 and regulafalsibb.jl:45-46 shade `as[frame+1], bs[frame+1]`. Lines 86 and 83 draw the secant through `as[frame], bs[frame]`.
  - **Arrays.** `rf*_frames.txt` shows that in every frame (12 for Case A, 10 for Case B) the secant passes through the old a, which lies outside the shaded bracket. In every frame, c_k is an endpoint of the shaded bracket.
  - **Frames.** In `frames_before_aa/frame_003.png` (c₂), the shading is [0.8333, 2] while the dashed secant passes through (0, −10). That point is unmarked; the gray diamond at (0, 0) is c₁.
- **Change.** Under D7 (the animation is correct, so describe it), one sentence was added to the index.qmd intro after "…becomes the new estimate.": "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket, while the shaded band shows the updated bracket, which has the new point $c$ (red) as one endpoint." No script change and no new plot elements.
- **Check.** `rf*_frames.txt` prints "c_k is endpoint of shaded: true" for every frame of both cases. Frame 0 (`frame_001.png`) has no secant, which is why the sentence says "after the first". I avoided saying "the blue markers show the updated bracket", because the blue marker at the new endpoint c is drawn under the red dot.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd intro | "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket" | code: secant uses `as[frame], bs[frame]` (aa.jl:86, bb.jl:83); frame 0 branch has no secant (`if frame > 0`); `julia $S/scripts/rf*_frames.jl` → "secant through x=(prev a, b)" every frame | yes |
| index.qmd intro | "the shaded band shows the updated bracket, which has the new point $c$ (red) as one endpoint" | shading uses `as[frame+1], bs[frame+1]`; `rf*_frames.txt` → "c_k is endpoint of shaded: true" for all 12 + 10 frames; c drawn red (`color=:red`) | yes |
| index.qmd Case A | $x^* \approx 1.3652$ | `indep.py` → root = 1.3652300134141 (only real root, polyroots) → 4 dp 1.3652 | yes |
| index.qmd Case A | "The right endpoint $b = 2$ stays fixed throughout" | `rfaa_values.txt` → b_next=2.0 at i=1..12; `indep.py` → b fixed (40 steps): True | yes |
| index.qmd Case A | "$f(-1) < 0$" | `indep.py` → f(a0) = −7.0 | yes |
| index.qmd Case A | "every false-position point $c$ also satisfies $f(c) < 0$" | `rfaa_values.txt` → all f(c)<0: true (12, last −1.095e−5); `indep.py` → all 40 f(c)<0: True; holds for all c by convexity, since the secant lies above f on [a, b] | yes |
| index.qmd Case A | "($f$ is convex on the bracket)" | `indep.py` → min f'' on [−1, 2] = 2.0 > 0 (f'' = 6x+8) | yes |
| index.qmd Case A | "keeps replacing $a$ with $c$" | `rfaa_values.txt` → a_next = c at every step | yes |
| index.qmd Case A | $a = -1, 0, 0.8333, 1.2088, \dots$ | `rfaa_values.txt` → a = −1.0, 0.0, 0.8333333333333334, 1.2087912087912087 (i=1..4) → 4 dp | yes |
| index.qmd Case B | "The right endpoint $b = 1$ … remains fixed throughout" | `rfbb_values.txt` → b_next=1.0 at i=1..10; b fixed: true | yes |
| index.qmd Case B | $f(1) \approx 0.4597$ | `indep.py` → f(b0) = 0.45969769 | yes |
| index.qmd Case B | "$f$ is convex on $[0, 1]$" | `indep.py` → min f'' = cos x on [0,1] = 0.540302 > 0 | yes |
| index.qmd Case B | "every false-position point satisfies $f(c) < 0$" | `rfbb_values.txt` → all f(c)<0: true (10 steps, last −1.85e−13); mpmath: first non-negative only at i=40, error 6.4e−52, which is below working precision (`indep_B_precision.txt`); exact arithmetic: convexity | yes |
| index.qmd Case B | "the points advance from the left" | `rfbb_values.txt` → c increasing: true; `indep.py` → c strictly increasing and below the root for all 10 animated steps | yes |
| index.qmd Case B | $c = 0.6851, 0.7363, 0.7389, \dots$ | `rfbb_values.txt` → 0.6850733573, 0.7362989976, 0.7389453560 → 4 dp | yes |
| index.qmd Case B | "the bracket shrinks only on the left side" | b fixed at 1.0 and a = c increasing (`rfbb_values.txt`) | yes |
| index.qmd Case B alt | "with the right endpoint fixed at 1 while the left endpoint steps in" | same as the two rows above | yes |
| regulafalsiaa.jl:5-7 | "convergence is only linear"; "b = 2 stays fixed"; "error ratio … settles at about 0.251"; "(bisection halves its bracket each step, a factor of 0.5)" | `indep.py` → ratios → 0.25127, asymptotic 0.251271 (nonzero ⇒ linear); b fixed True; halving is bisection's definition | yes |
| regulafalsiaa.jl:8 | True root ≈ 1.36523 | `indep.py` → 1.3652300134141 | yes |
| regulafalsibb.jl:3-4 | "right endpoint stays fixed at 1"; "The successive c points converge from the left" | `rfbb_values.txt` → b fixed: true, c increasing: true, all c < x* (`indep.py`) | yes |

The unchanged text was reread; it still holds:
- Case B "x* ≈ 0.7391": the root is 0.739085133215161.
- Case B "homes in on the root accurately": c₁₀ has error 1.106e−13.
- Case A alt text "near x=1.37": 1.36523 rounds to 1.37.

## Scripts and GIFs
- **Scripts changed.** regulafalsiaa.jl and regulafalsibb.jl changed in header comments only. No code changed.
- **GIFs regenerated.** Both GIFs were regenerated with `julia regulafalsiaa.jl` and `julia regulafalsibb.jl`, run from the page folder. Both came out byte-identical to the committed files:
  - md5 before and after: d9e7eca9… (aa) and f462f3aa… (bb).
  - sha256 matches the LFS pointer oids: 372688a7… for aa and dfc0e4dc… for bb.
- **Frames viewed.** Viewed at full size from the committed (= regenerated) GIFs:
  - aa frame_001: initial bracket [−1, 2], no secant.
  - aa frame_003: c₂ = 0.833333; shading [0.833, 2]; the secant passes through (0, −10).
  - aa frame_013: legend `c_12 = 1.365229`; shading [1.365, 2]; blue dot at (2, 14).
  - bb frame_003: `c_2 = 0.736299`; shading [0.736, 1]; blue dot at (1, 0.46).
- **git status after regeneration.** `git status --short -- pages/numerical-methods/false-position-or-regula-falsi-method` shows only:
  - ` M .../index.qmd`
  - ` M .../regulafalsiaa.jl`
  - ` M .../regulafalsibb.jl`

## Legacy archive
- **Consulted.** `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/RegulaFalsiMod.html` and `regulafalsi/RegulaFalsiMod/Links/RegulaFalsiMod_lnk_2..4.html`. The formula images gr_432 and gr_433, the code images gr_431 and gr_434, and the table and result images gr_515, gr_517, gr_519 and gr_521 were viewed.
- **Example 3 ("Convergence").** Example 3 is x³ + 4x² − 10 = 0 on [a, b] = [−1, 2], with `RegulaFalsi[a, b, 15]`.
  - Its table's last row has c = 1.365230002889821 and b_k = 2.
  - It reports c = 1.365230010769655.
  - This agrees with the fixed page: the root is 1.3652 and b = 2 stays fixed. Mathews ran 15 iterations and the script runs 12; that difference is not a correctness issue.
  - The archive animation itself (`/a2001/Animations/RootFinding/RegulaFalsi/RegulaFalsiaa.html`) is an external link and is not in the archive.
- **Examples 1 and 2.** Both use the same cubic, on [1, 2].
- **Case B.** The module has no x − cos x example, so Case B has no archive counterpart.
- **Differences.** The archive does not disagree with the fixed page anywhere.

## Notes
- **D7 choice for F5.** F5 offered a script change (hollow marker at the old endpoint) or a text change. I took the text change under D7, because the animation's geometry is correct. If Jason prefers the picture to carry it, the change is one extra `scatter!` of `(as[frame], f(as[frame]))` per frame, and the GIFs would need regenerating.
- **Cosmetic issue, not a finding, not touched.** In frame 0 of both GIFs, the "Initial bracket [−1.0, 2.0]" annotation overlaps the legend box (aa frame_001).
- **Cosmetic issue, not a finding, not touched.** The Case A legend at frame 10 reads `c_10 = 1.36522`, because `round` drops the trailing zero of 1.365220. The value is correct.
- **Pre-existing convention gap, not added.** The page has no `## Description` section; the Animations section follows directly after the source line. No finding names it, so it is left alone.

### Director note

The resolution checker noted two pre-existing items that are not round-1 findings and were left alone: the page has no `## Description` section before `## Animations` (conventions require one), and in regulafalsiaa frame 1 the 'Initial bracket' annotation runs into the legend box (still readable). Left for Jason / the round-2 review.

## Resolution check (independent checker, not shown this record)

Independent computation: `check/indep.py` (mpmath, 40 digits), which reruns both cases of regula falsi from scratch and finds the roots with findroot. The scripts were rerun from scratch copies in `check/run/`. Frames were extracted to `check/frames_regulafalsiaa/` (13 frames) and `check/frames_regulafalsibb/` (11 frames). I looked at aa frames 001, 002 and 013 and bb frames 003 and 011 at full size.

### Original findings

### F1 — resolved
- Evidence: index.qmd:19 now reads $x^* \approx 1.3652$ and regulafalsiaa.jl:8 reads "True root ≈ 1.36523". The independent root is 1.3652300134141, so both roundings are correct. f(1.3652) = −4.96e−4, versus 0.059 for the old 1.3688. The value agrees with the GIF's last legend, `c_12 = 1.365229` (frame_013).

### F2 — resolved
- Evidence: index.qmd:19 now says the right endpoint b = 2 stays fixed and that a is replaced by c, with a = −1, 0, 0.8333, 1.2088, …. The independent a-sequence is −1, 0, 0.833333, 1.20879, 1.32413, …, and b = 2 at all 13 entries. Every f(c_k) < 0. The convexity reason holds: f'' = 6x + 8 ≥ 2 > 0 on [−1, 2]. A strictly convex f lies below its chord, so f(c) < 0. f(−1) = −7 < 0. The sentence no longer contradicts itself. In the frames, the shading's left edge moves right (frame 002 starts at 0; frame 013 starts at ≈1.365) while the blue dot stays at (2, 14).

### F3 — resolved
- Evidence: index.qmd:27 now says the right endpoint b = 1 stays fixed, f(1) ≈ 0.4597, the points advance from the left (c = 0.6851, 0.7363, 0.7389, …) and the bracket shrinks only on the left. Independent results: f(1) = 0.45969769, b = 1 throughout, every f(c) < 0, and c = 0.68507336, 0.736299, 0.73894536 increasing toward 0.739085133215. Convexity holds since f'' = cos x > 0 on [0, 1]. The alt text at line 31 now reads "right endpoint fixed at 1 while the left endpoint steps in". The comments at regulafalsibb.jl:3-4 now read "right endpoint stays fixed at 1" and "converge from the left". Frames 003 and 011 show the blue dot fixed at (1, 0.46) and the shading's left edge at c_k.

### F4 — resolved
- Evidence: the "slower than bisection" claim is gone. regulafalsiaa.jl:5-7 now says convergence is only linear, b = 2 stays fixed, and the error ratio settles at about 0.251 against bisection's 0.5. I measured the ratios 0.3896, 0.2941, 0.2628, 0.2542, …, 0.25127. The analytic limit 1 − f'(x*)(b − x*)/f(b) = 0.251271. Bisection halving its bracket each step is a factor of 0.5. The comment no longer contradicts line 13 of the page.

### F5 — resolved (by the suggested page-text alternative)
- Evidence: the scripts are unchanged in drawing. The secant still uses `as[frame], bs[frame]`; the shading and markers still use `as[frame+1], bs[frame+1]`. index.qmd:13 adds a sentence: "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket, while the shaded band shows the updated bracket, which has the new point c (red) as one endpoint." I checked this against the frames:
  - Frame 001 (frame 0) has no secant, so "after the first" is accurate.
  - aa frame 002: the secant runs through (−1, −7) and (2, 14). The shading is [0, 2], with the red c₁ = 0 at its left edge.
  - aa frame 013 and bb frames 003 and 011: the shading's left edge is at the red c_k.

  The old endpoint is still unmarked, but the page now explains it, so a reader is no longer misled.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:13 | "In each frame after the first, the dashed secant passes through the endpoints of the previous bracket" | Code lines aa:79-91 and bb:76-87; frame 001 has no secant; aa frame 002 secant through (−1, −7), (2, 14) | True |
| index.qmd:13 | "shaded band shows the updated bracket, which has the new point c (red) as one endpoint" | Shading uses as/bs[frame+1]; the update gives a ← c in every step of both cases; the frames show the left edge at the red point | True |
| index.qmd:19 | x* ≈ 1.3652 | Root 1.36523001341 | True |
| index.qmd:19 | right endpoint b = 2 stays fixed | b = 2 at all 13 entries | True |
| index.qmd:19 | f(−1) < 0 | f(−1) = −7 | True |
| index.qmd:19 | every c has f(c) < 0 | All 12 values negative (−10 … −1.1e−5) | True |
| index.qmd:19 | f convex on the bracket | f'' = 6x + 8 ≥ 2 on [−1, 2] | True |
| index.qmd:19 | a = −1, 0, 0.8333, 1.2088, … | −1, 0, 0.833333, 1.208791 | True |
| index.qmd:27 | b = 1 remains fixed | b = 1 at all 11 entries | True |
| index.qmd:27 | f(1) ≈ 0.4597 | 0.45969769 | True |
| index.qmd:27 | f convex on [0, 1]; every f(c) < 0 | f'' = cos x ≥ 0.54; all 10 f(c) < 0 | True |
| index.qmd:27 | c = 0.6851, 0.7363, 0.7389, … from the left | 0.685073, 0.736299, 0.738945, increasing, below 0.739085 | True |
| index.qmd:27 | bracket shrinks only on the left side | a moves, b fixed | True |
| index.qmd:31 (alt) | right endpoint fixed at 1, left endpoint steps in; x* ≈ 0.739 | As above; frames 003 and 011 | True |
| regulafalsiaa.jl:5 | one endpoint fixed, convergence only linear | Constant error ratio 0.2513 (linear) | True |
| regulafalsiaa.jl:6 | b = 2 fixed; ratio settles at about 0.251 | 0.251271 | True |
| regulafalsiaa.jl:7 | bisection factor 0.5 | Definition of bisection | True |
| regulafalsiaa.jl:8 | True root ≈ 1.36523 | 1.3652300 | True |
| regulafalsibb.jl:3-4 | right endpoint fixed at 1; c converge from the left | As above | True |

### New problems

None introduced by the fix. This rests on three things: every changed line in the ledger checks out; the GIFs are unchanged (both byte-identical to HEAD and to fresh regeneration); and the only script changes are comments.

The fix did not cause either of the following, and neither was an original finding:
- **Pre-existing, Minor (conventions):** the page has no `## Description` section before `## Animations`. The HEAD version lacks one as well. animation-page.agent.md:12 and :205 require it.
- **Pre-existing, Minor (visual):** in regulafalsiaa frame 001, the "Initial bracket [-1.0, 2.0]" annotation runs into the right edge of the legend box. It is still readable.

### Reproducibility and conventions

- Both scripts were run from scratch copies (`check/run/`). `regulafalsiaa.gif` and `regulafalsibb.gif` are byte-identical (cmp) to the committed files. `git diff --stat HEAD` for the page folder lists only index.qmd and the two .jl files, so the GIFs did not change.
- Each case still has a source link and a GIF embed. The alt text is descriptive and now correct. There are no code blocks. The Description section is missing, as it was before the fix (see above).
- Outside the page folder: the working tree has many changed files on other numerical-methods pages and untracked fixer notes under `reviews/numerical-methods-animations/fixes/`, including `false-position-or-regula-falsi-method.md`. Those belong to other pages' fixes and the workflow's own notes. Nothing outside this page folder is tied to this page's fix except its notes file.

**Final status:** committed
