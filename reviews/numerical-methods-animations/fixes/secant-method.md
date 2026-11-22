# Fix record: secant-method

Scratch folder with all evidence scripts and frame extractions:
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/secant-method/fix/`
(`indep.py`, `atan_order.py`, `sym.py`, `ee_steps.py` run with `/usr/bin/python3 -I`; `print_aa.jl`, `print_dd.jl`, `print_ee.jl` are the scripts' iterate loops copied verbatim, with the plotting removed and the iterates printed; `committed/` and `new/` hold the extracted frames of the old and new GIFs.)

## Findings

### F1 — Error — fixed
- Reproduced: `python3 -I indep.py` (mpmath, 60 digits) gives root 0.25485005902885. f' = 3e^x + 4 sin x has minimum 3.0 on [0,1], and there is 1 sign change on [0,1], so this is the only root in the window. p2 = 0.455750754163146 (err 0.2009, f = 1.14), p3 err 0.06588, p4 err 0.00891, p5 err 4.435e-4, p6 err 3.115e-6, p7 err 1.096e-9. `julia print_aa.jl` agrees: p2 = 0.4557507541631453, p9 = 0.2548500590288503. So the page's "0.456" is p2, not the root. The archive (Example 3, Solution 3) also gives p9 = 0.2548500590288503.
- Change: index.qmd Case 1 Behavior. "converges quickly to the root near x ≈ 0.456 … so the secant line immediately produces a good approximation" → "root near x ≈ 0.2549 … The first secant step lands at p2 ≈ 0.456, still 0.20 from the root; after that the error falls rapidly (0.066 at p3, 0.0089 at p4, 4.4×10⁻⁴ at p5, 3.1×10⁻⁶ at p6), consistent with the secant method's order ≈ 1.618 at this simple root." Alt text: "near x=0.456" → "near x=0.2549".
- Check: the per-step order estimates log(e_{n+1}/e_n)/log(e_n/e_{n-1}) for n = 3…8 are 1.794, 1.500, 1.653, 1.604, 1.623, 1.616 (`indep.py`). f''(x) = 3e^x + 4cos x has minimum 7.0 on [0,1] (`sym.py`), so the root is simple with f'' ≠ 0 and the generic order 1.618 applies. I did not adopt the round-1 suggestion "each later step roughly squares the error", because squaring the error would mean order 2.

### F2 — Misleading — fixed
- Reproduced: `python3 -I atan_order.py` (3000 digits). For p0 = 1.60, p1 = 1.50 the order estimates are −14.29, 0.084, 29.56, 0.858, 3.33, 1.60, 2.25, 1.889, 2.059, 1.971, 2.014, 1.993, and e_{n+1}/(e_n e_{n−1}²) = 0.333333 from n = 7 on. Case 3 (1.35, 1.30) behaves the same way: the ratio is also 0.333333 and the estimates tend to 2. mpmath gives f''(0) = 0 and f'''(0) = −2 for arctan. The asymptotic order is therefore 2, not 1.618.
- Change: index.qmd Case 6 Behavior. ", illustrating that the secant method converges super-linearly (order ≈ 1.618) when the starting points are in the basin of convergence." → ". The convergence is super-linear, but because f''(0) = 0 for arctan its asymptotic order here is 2 rather than the generic ≈ 1.618."
- Check: as above. The kept phrase "larger first overshoot" was checked too: |p2| = 1.842 for Case 6 against 1.221 for Case 3.

### F3 — Minor — fixed
- Reproduced: `indep.py` gives error ratios e_n/e_{n−1} of 0.533 (p2), 0.652, 0.605, 0.623, 0.616, 0.619, 0.618, …, and 0.618034 from p15 to p30. The errors satisfy e_{n+1} = e_n e_{n−1}/(e_n + e_{n−1}) to 4e-57. `sym.py` (sympy) derives that recurrence exactly, gives f = 25(x − 1/5)² (expand difference 0), and gives the limit ratio t = 1/(t+1), so t = (√5 − 1)/2 = 0.6180339887. The page's "denominator shrinks, giving small steps" is the wrong mechanism.
- Change: index.qmd Case 2 Behavior. "converges, but slowly — the double root causes the denominator f(p_n) − f(p_{n−1}) to shrink, giving small steps that creep…" → "converges, but only linearly: here f(x) = 25(x−0.2)², and the ratio of successive errors settles at (√5−1)/2 ≈ 0.618, so each step removes only about 38% of the remaining error and the iterates creep toward the root over many iterations."
- Check: as above. 1 − 0.618 = 0.382, which gives the 38%. The alt text already said "linear convergence" and was left as it was.

### F4 — Minor — fixed
- Reproduced: `julia print_dd.jl` gives p3 = −3.0 with f = −21.0, and p9 = −3.034227576785138 with f = −21.900500838057607. With ylims (−5, 32) both points are drawn clamped at y = −5. Committed frames `committed/secantmethoddd/frame_003.png` and `frame_010.png` show the dot in the bottom-left corner, away from the secant line.
- Change: secantmethoddd.jl:17, `ylims = (-5.0, 32.0)` → `ylims = (-25.0, 32.0)`, with a comment. Nothing else in the script changed. The GIF was regenerated.
- Check: over p0…p17, x ranges over [−3.0342, 3.1639] and f over [−21.9005, 31.5077] (Julia one-liner in the session). Both lie inside xlims (−3.2, 3.5) and the new ylims (−25, 32), so no marker is clamped any more. In the new frames 3, 10 and 16 (`new/secantmethoddd/`), p3 sits at (−3, −21) and p9 at (−3.03, −21.9) on the curve, and the secant line passes through both. The legends read p4 = 0.1111, p11 = −1.4708 and p17 = −1.6717, which match `print_dd.jl`.

### F5 — Minor — fixed
- Reproduced: `julia print_ee.jl` gives p10 = 10.574639777228054 and p16 = 15.105971719963007. `ee_steps.py` (mpmath, 5000 steps): the iterates increase monotonically, every step from p3 to p5001 lies in [0.693347, 0.971559], and the step at p5000 is 0.6933467 (ln 2 = 0.693147). No iterate comes near the script's 1e6 threshold. The committed frame 9 has the legend "p10 → ∞" on a marker clamped to x = 10.1, and frames 10–16 show only "Method diverged" (`committed/secantmethodee/frame_009.png`, `frame_012.png`).
- Change (secantmethodee.jl):
  - `n_iters = 16` → `9`, so the last frame shows p10, the first off-window iterate. The header comment says n=9.
  - The off-chart marker is now a hollow red diamond at the edge, with the legend "p10 = 10.57 (off chart, marker at edge)" in place of "p10 → ∞".
  - The off-chart annotation now reads "p10 = 10.57 (off chart)" (was "p10 → 10.6 (off chart)") and has moved to (0.7·xmax, 0.5·ymax), so that it does not collide with the legend.
  - The legend moved to `:topright`; see Notes.
  - Two branches that this setup no longer reaches had misleading text: "(diverged)" → "(off chart)", and "Method diverged" → "Iterates off chart".
  - The GIF was regenerated with 9 frames.
- Text change (index.qmd Case 5): "falls far to the right" → "falls to the right", and new sentences: "The divergence is slow: after the first jump to p2 ≈ 4.11, each step moves right by less than 1 (the step tends to ln 2 ≈ 0.693). The animation stops at p10 ≈ 10.57, the first iterate past the right edge of the window; p16 ≈ 15.11." The alt text now reads "…steps progressively further right until p10≈10.57 leaves the window, illustrating slow divergence to infinity".
- Check: in the new frames (`new/secantmethodee/frame_001…009.png`, `sheet.png`), the legends read p2 = 4.114, p3 = 4.813, p4 = 5.784, p5 = 6.595, p6 = 7.428, p7 = 8.227, p8 = 9.02 and p9 = 9.801, which match `print_ee.jl`. Frame 9 shows the hollow edge marker, the legend "p10 = 10.57 (off chart, marker at edge)" and the annotation, with no overlap. `ee_steps.py` gives p9 = 9.8009866 < 10.1 < p10 = 10.57464, so p10 is the first iterate past the window.

### F6 — Minor — fixed
- Reproduced: `indep.py` gives root −1.67169988165716. sympy nroots gives the only real root as −1.67169988166, and `print_dd.jl` gives p17 = −1.67169988165716. The header's "−1.6724" is wrong; "−1.672" on the page is right.
- Change: secantmethoddd.jl:4, "x ≈ -1.6724" → "x ≈ -1.6717".
- Check: as above. Rounding −1.671699882 to 4 decimals gives −1.6717.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 1 Behavior | root near x ≈ 0.2549 | `indep.py` → root 0.25485005902885; `print_aa.jl` p9 = 0.2548500590288503 | yes |
| index.qmd Case 1 | "Both starting points are on the same side of the root" (kept) | p0 = 1.0, p1 = 0.9 > 0.2549 | yes |
| index.qmd Case 1 | p2 ≈ 0.456, still 0.20 from the root | `indep.py` → p2 = 0.455750754163146, err 0.2009 | yes |
| index.qmd Case 1 | 0.066 at p3, 0.0089 at p4, 4.4×10⁻⁴ at p5, 3.1×10⁻⁶ at p6 | `indep.py` → errors 0.06588, 0.00891, 4.435e-4, 3.115e-6 | yes |
| index.qmd Case 1 | "consistent with order ≈ 1.618 at this simple root" | `indep.py` order estimates 1.794, 1.500, 1.653, 1.604, 1.623, 1.616; `sym.py` f'' min 7.0 on [0,1]; f' min 3.0 | yes |
| index.qmd Case 1 alt | root near x=0.2549 | as above | yes |
| index.qmd Case 2 | converges only linearly | `indep.py` → ratios → 0.618034 constant from p15 to p30 | yes |
| index.qmd Case 2 | f(x) = 25(x−0.2)² | `sym.py` → expand(25(x−1/5)² − f) = 0 | yes |
| index.qmd Case 2 | ratio settles at (√5−1)/2 ≈ 0.618 | `sym.py` → t = −1/2 + √5/2 = 0.6180339887; `indep.py` ratios 0.616–0.623 from p5, 0.618034 from p15 | yes |
| index.qmd Case 2 | each step removes about 38% | 1 − 0.618 = 0.382 | yes |
| index.qmd Case 5 | x-intercept "falls to the right"; each step pushes further from root | `ee_steps.py` → all steps p1…p5001 positive (monotone increasing, verified also to p2000 in `indep.py`) | yes |
| index.qmd Case 5 | first jump to p2 ≈ 4.11 | `indep.py` → p2 = 4.11379887333 | yes |
| index.qmd Case 5 | each later step < 1 | `ee_steps.py` → steps p3…p5001 in [0.693347, 0.971559] | yes (checked to n = 5001; limit ln 2 < 1) |
| index.qmd Case 5 | step tends to ln 2 ≈ 0.693 | `ee_steps.py` step at p5000 = 0.6933467; `indep.py` 0.693645 at n = 2000; ln 2 = 0.69314718; fixed point of h = h/(e^h − 1) for large x gives e^h = 2 | yes |
| index.qmd Case 5 | animation stops at p10 ≈ 10.57, first iterate past right edge | `print_ee.jl` p10 = 10.574639777228054; `ee_steps.py` p9 = 9.80099 < 10.1; new GIF has 9 frames, frame 9 shows p10 | yes |
| index.qmd Case 5 | p16 ≈ 15.11 | `print_ee.jl` p16 = 15.105971719963007 | yes |
| index.qmd Case 5 alt | until p10≈10.57 leaves the window; slow divergence to infinity | as above | yes |
| index.qmd Case 6 | super-linear; f''(0)=0; asymptotic order 2 | `atan_order.py` → f''(0) = 0, order estimates → 1.993…2.014, e_{n+1}/(e_n e_{n−1}²) → 0.333333 | yes |
| index.qmd Case 6 | "larger first overshoot" (kept) | `atan_order.py` → p2 = −1.842 (Case 6) vs −1.221 (Case 3) | yes |
| secantmethoddd.jl:4 | x ≈ −1.6717 | `indep.py` root −1.67169988165716 | yes |
| secantmethoddd.jl:17 | ylims (−25, 32); comment f(p3) = −21, f(p9) ≈ −21.9 | `print_dd.jl` → f(p3) = −21.0, f(p9) = −21.9005; f range over the run [−21.90, 31.51] | yes |
| secantmethodee.jl header / n_iters | n=9; "frame 9 shows p10 ≈ 10.57, the first iterate past the window" | `print_ee.jl`, `ee_steps.py` as above; new GIF 9 frames | yes |
| secantmethodee.jl label | "p10 = 10.57 (off chart, marker at edge)" / "p10 = 10.57 (off chart)" | `julia -e 'round(10.574639777228054; digits=2)'` → 10.57; seen in new frame 9 | yes |
| secantmethodee.jl unreached branches | "(off chart)", "Iterates off chart" | branches not reached with n_iters = 9 (frame 9 has both p8, p9 in the window); text describes the condition the branch tests (iterate outside xlims) | yes |

## Scripts and GIFs
- Scripts changed: `secantmethoddd.jl`, `secantmethodee.jl`. GIFs regenerated by running each script from the page folder: `secantmethoddd.gif` (16 frames), `secantmethodee.gif` (9 frames, was 16).
- Frames viewed at full size:
  - dd: frames 3, 10 and 16, plus the contact sheet. Checked that p3 and p9 lie on the curve and on the secant line, that the legend values are right, and that the root −1.6717 is visible.
  - ee: frames 1 and 9, plus the contact sheet. In frame 1, p0 is now visible; it was hidden behind the top-left legend before. In frame 9, the edge marker, legend and annotation are legible and the true value is shown. The legend values for p2…p9 are right.
- `git status --short -- pages/numerical-methods/secant-method` after regeneration: M index.qmd, M secantmethoddd.gif, M secantmethoddd.jl, M secantmethodee.gif, M secantmethodee.jl. No other GIF changed.

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/SecantMethodMod.html` and `secantmethod/SecantMethodMod/Links/SecantMethodMod_lnk_4…9.html`. The formula and graph images were stacked into `archive/*.png` in the scratch folder.
- Example 3 (Case 1): same f, p0 = 1, p1 = 0.9. Mathews' p9 = 0.2548500590288503, which agrees with our root and confirms that the root, not 0.456, is the subject.
- Example 6 (Case 4): f = 3 − x + x³, p0 = 2, p1 = 1. The iterates p0…p13 match `print_dd.jl` to all shown digits, including p3 = −3 and p9 = −3.0342275767851330 with f = −21.9005. Mathews' own graph also uses a window of about −5 to 32 in y, so the clamping problem came from copying that window. The fixed page widens it to show those points, which is a deliberate difference from the archive.
- Example 7 (Case 5): f = e^{−x} x, p0 = 1.5, p1 = 2. The iterates p0…p13 match `print_ee.jl` (for example p10 = 10.5746397772280500 and p13 = 12.8590927989190900). Mathews' graph window is x ∈ [0, 10]. He listed iterates past the window but did not claim a blow-up. The fixed animation keeps his window and stops at the first off-window iterate, and the page gives the later value p16 ≈ 15.11.
- Examples 5 and 8 (the arctan Cases 3 and 6) and Example 4 (Case 2): I checked the titles only ("Convergence, Oscillation", "Convergence", "Slow Convergence"). The archive's Example 2(b) speaks of "linear convergence at the double root", which agrees with the corrected Case 2 text.

## Notes
- The legend moved to `:topright` in `secantmethodee.jl`. This was not one of the findings. In the committed frame 1, the top-left legend box covered the p0 marker at (1.5, 0.335), so the secant line visibly passed through only one marked point; the frame 9 annotation also overlapped the longer legend. Moving the legend is a cheap layout-only change, and I confirmed it visually in frames 1 and 9.
- The header comment in `secantmethodff.jl` says "method converges directly", but the iterates alternate in sign (p2 = −1.84, p3 = −0.097, p4 = 0.076, p5 = −5.2e-5). No finding names it and it is not page text, so I left it.
- The page has no `## Description` section (convention gap). No finding names it, so I did not add one.
- Case 3 text ("the iterates oscillate — jumping to the opposite side of the root each step"): `atan_order.py` gives p2 = −1.22, p3 = +0.018, p4 = −0.0067, p5 = +4.6e-7, p6 = −6.9e-12, so the iterates do alternate in sign from p2 on. I left the text unchanged.

### Director note

The resolution checker noted that this page has no `## Description` section before `## Animations` (conventions require one). That predates the run and was not a round-1 finding; adding one is new content, left for Jason / the round-2 review.

## Resolution check (independent checker, not shown this record)

Work files: `check/calc.py` (mpmath, 60 digits; 3000 digits for arctan), `check/run/` (scratch copies of the changed scripts and their output), `check/new_dd/`, `check/new_ee/` (frames of the working-tree GIFs). I could not extract the pre-fix GIFs: `git show HEAD:` returns LFS pointer text. I looked only at the new frames, which is enough to judge the fix.

### Original findings

### F1 — resolved
- The text no longer says 0.456 is the root. Line 18 now gives the root as ≈ 0.2549 (mpmath: 0.2548500590288503). Line 18 says p2 ≈ 0.456 is "still 0.20 from the root" (true: 0.45575, error 0.2009). The alt text at line 22 now says "near x=0.2549".
- The errors quoted for later iterates match mpmath: p3 0.06588, p4 0.00891, p5 4.435e-4, p6 3.115e-6.
- "Both starting points are on the same side of the root" is true: 1.0 and 0.9 are both above 0.2549.
- "Order ≈ 1.618 at this simple root" holds. f'(r) = 4.88 ≠ 0 and f''(r) = 7.74 ≠ 0. The measured order estimates are 1.79, 1.50, 1.65, 1.60.
- The script and GIF for Case 1 did not change and did not need to. The original finding said the legend already printed the correct values.

### F2 — resolved
- Line 58 now says the convergence is super-linear, with asymptotic order 2 because f''(0) = 0 for arctan. Checked with mpmath at 3000 digits. The order estimates run 1.60, 2.25, 1.889, 2.059, 1.971, 2.014, 1.993, 2.004. log10|e| roughly doubles each step (−63, −124.5, −251, −500.7, −1003, −2005). f''(0) = 0 and f'''(0) = −2.
- The sentence that was kept, "Despite a larger first overshoot", is also true. Case 6 p2 = −1.8425, Case 3 p2 = −1.2214.

### F3 — resolved
- The backwards denominator explanation has been removed from line 26.
- The new text says f = 25(x−0.2)²: the residual against (1−5x)² is 0 to 60 digits.
- It says the error ratio settles at (√5−1)/2 ≈ 0.618. mpmath gives ratios 0.533, 0.652, 0.605, 0.623, 0.616, 0.619, … and 0.618034 from about n = 15 to n = 30.
- It says each step removes about 38% of the remaining error. 1 − 0.618 = 0.382, so this is true.
- "Only linearly" is correct.

### F4 — resolved
- `ylims` changed from (−5, 32) to (−25, 32).
- Every iterate drawn now lies inside the box, so the clamps no longer change anything:
  - x runs from −3.034 to 3.164, inside (−3.2, 3.5).
  - f(p) runs from −21.90 (p9) and −21 (p3) up to 31.51 (p6), inside (−25, 32).
- In frame 3, p3 is drawn at (−3, −21) and the secant line passes through it.
- In frame 9, p9 is drawn at (−3.03, −21.9) on the secant line.
- Both gray history dots lie on the curve in every later frame (checked frame 16).
- The clamp code is still in the script, but with these limits it has no effect.

### F5 — resolved
- `n_iters` is now 9, so the GIF has 9 frames. Frame 9 is the first frame where the next iterate leaves the window (p9 = 9.801 < 10.1 < p10 = 10.575).
- The "p10 → ∞" legend is gone. The legend now reads "p10 = 10.57 (off chart, marker at edge)", and the annotation reads "p10 = 10.57 (off chart)". Both values are correct.
- The six "Method diverged" frames are gone.
- The page text now describes slow divergence. The checks are in the ledger below.
- The old "diverged" and "Method diverged" branches were reworded to "off chart". With n_iters = 9 neither branch can run: in every frame both pa and pb are inside the window.

### F6 — resolved
- The header comment now says −1.6717. mpmath gives −1.67169988165716, which is −1.6717 to 4 decimals.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:18 | root ≈ 0.2549 | mpmath root 0.25485006 | correct |
| index.qmd:18 | both starting points on the same side | 1.0, 0.9 > 0.2549 | correct |
| index.qmd:18 | p2 ≈ 0.456, still 0.20 from the root | 0.455751, error 0.2009 | correct |
| index.qmd:18 | errors 0.066 / 0.0089 / 4.4e-4 / 3.1e-6 at p3–p6 | 0.06588 / 0.00891 / 4.435e-4 / 3.115e-6 | correct |
| index.qmd:18 | order ≈ 1.618, simple root | f'(r) = 4.88; measured orders 1.79, 1.50, 1.65, 1.60 | correct |
| index.qmd:22 alt | root near x=0.2549 | as above | correct |
| index.qmd:26 | converges only linearly | ratio tends to a constant 0.618; order estimate 1 | correct |
| index.qmd:26 | f = 25(x−0.2)² | symbolic identity, residual 0 | correct |
| index.qmd:26 | ratio settles at (√5−1)/2 ≈ 0.618 | 0.618034 from n ≈ 15 on | correct |
| index.qmd:26 | about 38% removed per step | 1 − 0.618 = 0.382 | correct |
| index.qmd:50 | x-intercept falls to the right | every p_{n+1} > p_n | correct |
| index.qmd:50 | first jump to p2 ≈ 4.11 | 4.113799 | correct |
| index.qmd:50 | each later step moves right by less than 1 | steps from p3 on lie between 0.6936 and 0.9716 | correct |
| index.qmd:50 | step tends to ln 2 ≈ 0.693 | step 0.7027 at n = 100, 0.69365 at n = 2000; fixed point h = h/(e^h − 1) gives h = ln 2 | correct |
| index.qmd:50 | stops at p10 ≈ 10.57, the first iterate past the right edge | p9 = 9.801, p10 = 10.5746, xlim = 10.1; the GIF has 9 frames | correct |
| index.qmd:50 | p16 ≈ 15.11 | 15.10597 | correct |
| index.qmd:54 alt | steps right until p10 ≈ 10.57 leaves the window; slow divergence to infinity | as above | correct |
| index.qmd:58 | super-linear; f''(0) = 0; order 2, not 1.618 | 3000-digit orders → 2.004; f''(0) = 0 | correct |
| secantmethoddd.jl:4 | root ≈ −1.6717 | −1.6716998817 | correct |
| secantmethoddd.jl:17 | ylims (−25, 32); f(p3) = −21, f(p9) ≈ −21.9 | f(p3) = −21, f(p9) = −21.9005; max f(p6) = 31.51 < 32 | correct |
| secantmethodee.jl:3 | n = 9 | matches n_iters | correct |
| secantmethodee.jl:14 | frame 9 shows p10 ≈ 10.57, the first iterate past the window | as above | correct |
| secantmethodee.jl:109,112 | "p10 = 10.57 (off chart …)" legend and annotation | round(10.5746, digits=2) = 10.57 | correct |
| secantmethodee.jl:121,124 | "(off chart)" and "Iterates off chart" | not reachable with n_iters = 9 | harmless |
| secantmethodee.jl:69 | legend moved to the top right | frames 1–9: the legend covers only the region where f ≈ 0 and hides no data | fine |

### New problems
None introduced by the fix. This rests on three checks:
- the ledger above;
- full-size views of dd frames 3, 9 and 16, and of ee frame 9;
- contact sheets of all dd and ee frames.

All labels are legible, and the legend values match the computed iterates: dd shows p4 = 0.1111, p10 = −1.3294 and p17 = −1.6717; ee shows p2 = 4.114 through p9 = 9.801.

Cosmetic notes, not problems:
- In ee frame 9 the hollow "edge" marker at (10.1, 0) is cut by the plot frame, so only a small red sliver shows. The red annotation "p10 = 10.57 (off chart)" carries the information.
- In ee frames 6–9 the current iterates sit at y ≈ 0.001–0.003, practically on the axis. This comes from the function itself and was already the case before the fix.

Pre-existing convention gap, not caused by the fix and not among the findings:
- **Minor.** index.qmd has no `## Description` section before `## Animations`, which `.github/agents/animation-page.agent.md` lines 12 and 205 require. The method overview is the first paragraph under `## Animations` (line 12). The HEAD version has the same structure.

### Reproducibility and conventions
- **Reproducibility.** I ran `secantmethoddd.jl` and `secantmethodee.jl` from scratch copies. Both GIFs are byte-identical to the working-tree GIFs:
  - dd sha256 4ea92c08…5c7c (16 frames);
  - ee sha256 53730afa…a763 (9 frames).
  - The decoded frame md5s also match.
- **Harmless warning.** `secantmethodee.jl` prints a pre-existing soft-scope warning for `n_valid`.
- **Conventions.**
  - Each of the 6 cases still has a source link and a GIF embed.
  - The alt text is descriptive and there are no code blocks.
  - The missing Description section predates the fix (see above).
- **Files changed.** In the secant-method folder, only index.qmd, secantmethoddd.jl/.gif and secantmethodee.jl/.gif changed. Outside `pages/numerical-methods/` there are only untracked `reviews/numerical-methods-animations/fixes/*.md` reports. The other pages' changes under `pages/numerical-methods/` belong to other pages' fixes, not this one.

**Final status:** committed
