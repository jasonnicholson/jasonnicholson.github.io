# Fix record: laurent-series

Scratch folder (all evidence scripts and outputs):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/laurent-series/fix/` (below: `$S`).

## Findings

### F1 — Minor — fixed
- **Reproduced:**
  - `$S/defs.jl` is the script's lines 1–325 (definitions only). `$S/clampfrac.jl` includes it and counts, for every case and every N, the 900-point grid samples where T_N lies outside `ylims`. These are exactly the samples the old line 346 moved onto the frame edge. Command: `julia $S/clampfrac.jl`. Output per case is in `$S/clampfrac.tsv`. Per-case range over N = 1…max:
    - 01: 38.4–73.7 %
    - 02: 0–6.3 %
    - 03: 0 %
    - 04: 0–16.2 %
    - 05: 0–43.6 %
    - 06: 0–1.6 %
    - 07: 0–17.2 %
    - 08: 84.0 → 42.9 %
    - 09: 0–76.2 %
    - 10: 12.2–66.3 %
    - 11: 10.0–72.4 %
    - 12: 0–42.2 %
    - 13: 0 %
    - 14: 0–24.1 %
    - 15: 0 %
    - 16: 0–32.0 %
    - 17: 0–17.1 %
    - 18: 0–69.1 %
    - 19: 40.9–70.7 %
    - 20: 0–50.0 %
    - 21: 0–50.0 %
    - 22: 0–49.6 %
    - 23: 0–2.0 %
    - 24: 0–0.7 %
    - 25: 27.1–62.0 %
    - 26: 25.3–66.2 %
    - 27: 27.7–76.6 %
  - The same line 330 clamp applied to f moved 0–6.4 % of samples onto the edge (case 12: 6.4 %; 22–24: about 2.4 %; 04: 1.0 %).
  - The review's "01: 43–74 %" is slightly off. The minimum is 38.4 % at N = 2, and 42.9 % is N = 1. The finding itself holds.
  - Independent check: `/usr/bin/python3 -I $S/indep_frac.py` takes mpmath Taylor coefficients (40 digits) from the function definitions for cases 01, 08, 12, 22 and 27, and it gives the same percentages for every N. For example, case 01 gives 42.9 38.4 59.2 62.2 66.9 68.8 70.6 71.9 72.7 73.7.
  - Visual: the old `laurent01.gif` frame 2 shows the blue N = 2 parabola lying on y = 0 from x ≈ 6.5 to 10.5. The old `laurent08.gif` frame 1 shows y = x running along y = ±1.5 (`$S/old_frames/01/frame_002.png`, `$S/old_frames/08/frame_001.png`).
- **Change:** in `laurent_animations_all.jl`, removed both clamps: `ytrue = [... clamp(...) ...]` (old line 330) and `ylaur = [... clamp(...) ...]` (old line 346). A two-line comment was added: values are not clamped and the plot clips at the axis limits. Non-finite f values are still `NaN` through `safe_eval`.
- **Check:**
  - Regenerated with `julia laurent_animations_all.jl`. 24 GIFs changed. `laurent03`, `laurent13` and `laurent15` are byte-identical to the committed ones (md5 compared against `$S/old_md5.txt`). These are exactly the three cases where neither T_N nor f leaves the window for any N (0 % in the table above), which is the expected set.
  - New frames viewed:
    - `01/frame_002`: the parabola now exits through the bottom at x ≈ 6.5.
    - `08/frame_001`: y = x exits at the top and bottom corners.
    - `12/frame_008`
    - `22/frame_008`
    - `27/frame_002`
    - `21/frame_001`
    - `05/frame_010`
    - contact sheets for 04 and 19.
  - In each of these, curves leave the window instead of running along the edge.
  - The vertical magenta strokes at the poles of tan (±π/2) and Γ (x = 0) are still drawn: the segment joining the large opposite-sign samples is clipped by the plot. They read as asymptotes, as the reviewer noted.
  - Every GIF still has all frames distinct: 10/10 or 8/8 unique decoded-frame md5 values.

### F2 — Minor — fixed
- **Reproduced:**
  - `/usr/bin/python3 -I $S/laurent_annulus.py` computes Laurent coefficients a_k = (1/2πi)∮ f(z)(z−x0)^(−k−1) dz on circles about x0.
  - Γ about 1:
    - ρ = 0.5 (inside the disc): a_−1, a_−2, a_−3 = 0, 0, 0.
    - ρ = 1.5 (annulus 1 < |z−1| < 2): 1.0, −1.0, 1.0.
  - Γ about 2: ρ = 2.5 gives 1, −2, 4.
  - Γ about 3: ρ = 3.5 gives 1, −3, 9.
  - tan about 0: ρ = 3 (annulus π/2 < |z| < 3π/2) gives a_−1 = −2.0, a_−3 = −4.9348022 (= −π²/2).
  - So "analytic at x0 ⇒ principal part zero" is false for the annulus expansions, which the page's own line 30 mentions. The finding holds.
- **Change:** `index.qmd`, three edits:
  - Line 12: "The Laurent series of a function around a center $x_0$ is" → "A Laurent series of a function around a center $x_0$, valid in an annulus $r<|x-x_0|<R$ of the complex plane on which $f$ is analytic, is"
  - Line 18: "When $f$ is analytic at $x_0$, as it is in every case below, the principal part is zero and, on the largest disc about $x_0$ where $f$ is analytic, the Laurent series is the ordinary Taylor series." → "When $f$ is analytic at $x_0$, as it is in every case below, its Laurent series on the largest disc $|x-x_0|<R$ on which $f$ is analytic has zero principal part and is the ordinary Taylor series."
  - Line 24: "All 27 functions are analytic at $x_0$, so $a_k=0$ for every $k<0$, and …" → "All 27 functions are analytic at $x_0$, so on the largest disc about $x_0$ on which $f$ is analytic, $a_k=0$ for every $k<0$, and …"
- **Check:**
  - `/usr/bin/python3 -I $S/disc_negcoeffs.py` computes, for all 27 cases, |a_−1|, |a_−2| and |a_−3| on a circle inside the disc of analyticity: ρ = min(1, R/2), with R the distance to the nearest singularity.
  - The largest of these over all cases is 1.25e-21 at 20-digit working precision, which is zero to quadrature accuracy.
  - a_0 agrees with f(x0) to ≤ 2.1e-22 in every case.
  - Together with the annulus values above, this confirms the new wording: the disc expansion has zero principal part, and an annulus expansion need not. The edited text is now consistent with line 30.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.12 | "A Laurent series … valid in an annulus $r<\|x-x_0\|<R$ of the complex plane on which $f$ is analytic" | Laurent's theorem: an expansion exists for each annulus of analyticity, so it is not unique. Demonstrated by `laurent_annulus.py`: Γ about 1 has different coefficients on ρ = 0.5 (a_−k = 0) and on ρ = 1.5 (a_−1 = 1, a_−2 = −1, a_−3 = 1) | yes |
| index.qmd l.18 | "its Laurent series on the largest disc $\|x-x_0\|<R$ on which $f$ is analytic has zero principal part and is the ordinary Taylor series" | `disc_negcoeffs.py` → max \|a_k\| for k = −1…−3 over all 27 cases = 1.25e-21 (zero), and a_0 = f(x0) to ≤ 2.1e-22. The non-negative coefficients equal the Taylor coefficients: the review's section 3 matched the script's coefficients to mpmath.taylor; this is standard theory (Cauchy's formula) | yes |
| index.qmd l.18 | "as it is in every case below" (kept) | `disc_negcoeffs.py` evaluates every f on a circle of positive radius about x0 with finite results and a zero principal part, so each f is analytic on a disc about x0 | yes |
| index.qmd l.24 | "so on the largest disc about $x_0$ on which $f$ is analytic, $a_k=0$ for every $k<0$" | same as the l.18 row | yes |
| laurent_animations_all.jl l.329–330 | comment: "Values are not clamped to ylims: the plot clips at the axis limits, so a curve that leaves the window is drawn leaving it, not running along the frame edge." | new frames 01/2, 08/1, 12/8, 22/8, 27/2, 21/1 and 05/10 show the curves exiting the window; no edge segments | yes |

No numbers were added to the page.

## Scripts and GIFs
- Script changed: `pages/numerical-methods/laurent-series/laurent_animations_all.jl` (two clamp lines removed, comment added).
- GIFs regenerated in place (`julia laurent_animations_all.jl`, 26 s): 24 changed (01, 02, 04–12, 14, 16–27). 03, 13 and 15 are byte-identical, as expected.
- Frames extracted for all 27 GIFs into `$S/new_frames/NN/`; the old frames for 01, 08 and 12 are in `$S/old_frames/`.
  - Viewed at full size: 01/2, 08/1, 12/8, 22/8, 27/2, 21/1, 05/10.
  - Contact sheets: 04, 19.
  - Checked in each:
    - the curves leave the window rather than running along the edge;
    - the titles and legend "Laurent = Taylor, N = n" are legible and unchanged, with the right N;
    - the red dot is at (x0, f(x0));
    - the pole strokes are still drawn for tan and Γ.
- `git status --short -- pages/numerical-methods/laurent-series` after regeneration shows 24 GIFs modified, plus `index.qmd` and `laurent_animations_all.jl`. Nothing else.

## Legacy archive
- Consulted. `grep -ril laurent` over `n2003/` and `a2001/` finds only `FrobeniusSeriesMod.html` and `FrobeniusSeriesProof.html` ("generalized Laurent series", unrelated) and some bibliography link pages.
- There is no Laurent module or animation. The brief's nearest topic (`taylorpoly/`) covers Taylor polynomials only.
- This agrees with the review: the page is a site-original construction on the Padé case set, and there is no archive example to follow or to note as left out. No R2-A action is needed.

## Notes
- The fix removes the clamp on f as well as on T_N (the review's first suggestion). The pole strokes survive without the clamp because the plot clips the joining segment.
- The Padé page uses the same case table and may have the same clamping pattern. It is outside this page and was not touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Script: both clamp lines are removed (`ytrue` and `ylaur`). No `clamp` call remains in `laurent_animations_all.jl`; the only match for "clamp" is the new comment. Out-of-window values are now passed to Plots unchanged, and GR clips them at `ylims`.
- I checked the pixels of all 27 regenerated GIFs, every frame (`check/edge.py`). For each frame it counts steelblue (70,130,180) pixel columns within ±3 px of the top and bottom axis borders:
  - **Before:** `laurent01` had 244–464 columns on the even-N frames. `laurent08` had 138–269 per frame, `laurent12` up to 137 and `laurent22` up to 310. These are the edge-running segments.
  - **After:** at most 10 columns per frame in every case, except `laurent13` frame 1 (21). Each count is a curve crossing the border. In `laurent13` frame 1 the crossing is shallow: 1+x reaches y = −1 = ylims[1] exactly at x = −2. That GIF is unchanged from HEAD, so it was never clamped.
- Full-size frames viewed:
  - 01 f2 and f10 (old f2 too, which shows the blue line along y = 0 from x ≈ 6.5);
  - 08 f1 (y = x now leaves through the top and bottom, no levelling at ±1.5);
  - 12 f4 (old and new);
  - 05 f5, 17 f5, 19 f10, 21 f10, 22 f4, 24 f8, 27 f8;
  - the contact sheet for 25.

  In all of them the polynomial leaves the window instead of running along it.
- The plotted values match an independent mpmath Taylor sum. Each pair below is a plotted value, then the position in the frame where the curve shows it.
  - **c01 N = 10:** 1.449 at x = 2.3 (the visible peak); −0.33 at x = 2.8 (the curve crosses 0 near 2.75).
  - **c12 N = 4:** 12.0 at x = 3 (leaves the top near 2.85); −9.68 at x = −2.75.
  - **c19 N = 10:** −0.159 at x = 4.6 (the local minimum); 1.397 at x = 6 (near the top).
  - **c22 N = 4:** 35.10 at x = 3.6 (leaves the top there); 6.72 at x = −0.2 (the left edge value).
  - **c24 N = 8:** 9.25 at x = −0.2.
- Unclamping `f` also fixes the true curve: log, Y₀ and Γ now run off the window at their singularities instead of flattening at the limit.

### F2 — resolved
- **Line 12** now reads "A Laurent series … valid in an annulus $r<|x-x_0|<R$ … on which $f$ is analytic". The indefinite article and the annulus qualifier remove the implied uniqueness. This is true: the expansion is unique for each annulus.
- **Line 18** now reads "its Laurent series on the largest disc $|x-x_0|<R$ on which $f$ is analytic has zero principal part and is the ordinary Taylor series". The disc qualifier now governs the zero-principal-part claim, and the claim is true: on a disc the coefficients with k < 0 are ∮ f (z−x0)^{−k−1} dz with an analytic integrand, so they are 0.
- **Line 24** now reads "so on the largest disc about $x_0$ on which $f$ is analytic, $a_k=0$ for every $k<0$". This is true.
- Line 30 (unchanged) says the annulus series for tan and Γ is different. Lines 18 and 24 no longer contradict it.
- I also checked the line-30 annuli:
  - tan about 0: the poles are at ±π/2 and the next ones at ±3π/2.
  - Γ about 1, 2 and 3: the nearest pole is 0, at distance 1, 2 and 3; the next pole is −1, at distance 2, 3 and 4.

  So there is an annulus in each case, as stated.
- "Analytic at x0, as it is in every case below" holds for all 27 cases. The singularities (√ and log branch points, the poles of tan and Γ, the log singularity of Y₀ at 0) are all away from the chosen centres.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.12 | "A Laurent series … around a center $x_0$, valid in an annulus $r<\|x-x_0\|<R$ of the complex plane on which $f$ is analytic, is" | The Laurent theorem gives a unique expansion for each annulus of analyticity, and r = 0 (punctured disc) is allowed | True |
| index.qmd l.18 | "When $f$ is analytic at $x_0$, as it is in every case below, its Laurent series on the largest disc $\|x-x_0\|<R$ on which $f$ is analytic has zero principal part and is the ordinary Taylor series." | Cauchy: the negative-k coefficients vanish on a disc of analyticity. I checked analyticity at x0 for all 27 cases. | True |
| index.qmd l.24 | "All 27 functions are analytic at $x_0$, so on the largest disc about $x_0$ on which $f$ is analytic, $a_k=0$ for every $k<0$" | Same as l.18 | True |
| laurent_animations_all.jl l.329–330 | Comment: "Values are not clamped to ylims: the plot clips at the axis limits…" | Matches the code (no clamp) and the frames (pixel check above) | True |
| GIF titles / legends (24 regenerated) | "Laurent Case NN: f(x) = …, x0 = …", "Laurent = Taylor, N = n" | Unchanged strings. Legible at full size in the frames viewed. N runs 1…max_order (10, or 8 for 12, 17 and 22–27): the frame counts are 10 or 8 to match. | True |

### New problems
None.

This rests on the following checks:
- All 27 GIFs regenerate byte-identically from the committed script.
- The three GIFs where no value had ever been clamped (03, 13, 15) are byte-identical to HEAD, so the change touched only out-of-window rendering.
- No frame has an edge-running segment (pixel scan of all frames).
- Five plotted values agree with an mpmath Taylor reference.
- None of the full-size frames I viewed has a broken label or a missing element.

Pre-existing behaviour, not a new problem: the tan and Γ curves still show a near-vertical magenta connector at each pole (x = ±π/2, and x = 0 for Γ), where consecutive grid points straddle the pole. HEAD has the same connector, and the finding allowed for it.

### Reproducibility and conventions
- I ran a scratch copy of `laurent_animations_all.jl` with plain `julia` (about 29 s). All 27 output GIFs are byte-identical (sha256) to the working-tree GIFs, the 24 changed ones included.
- Compared with HEAD (decoded through `git lfs smudge`), 24 GIFs changed, which matches the diff. 03, 13 and 15 are unchanged.
- **Conventions:**
  - `## Description` (l.10) comes before `## Animations` (l.20).
  - There is a Julia source link.
  - There are 27 case headings, each with one embed (27 `![` lines).
  - There are no code fences.
  - The alt text ("Laurent-series truncation animation for case NN.") is unchanged and generic but acceptable. It was not touched by this fix.
- **Scope:** the fix diff touches only files inside `pages/numerical-methods/laurent-series/` (index.qmd, the script, 24 GIFs). Other modified paths in the working tree belong to other pages' fixes in this round, plus untracked fix records under `reviews/`.

**Final status:** committed
