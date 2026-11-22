# Fix record: numerical-differentiation

Scratch folder (all evidence scripts, outputs and frames): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/numerical-differentiation/fix/` (below: `$S`).
- `$S/labeltest.jl` → `$S/labeltest.png`: GR legend rendering of three label spellings.
- `$S/aa_instr.jl` → `$S/aa_instr.out`: Case 1 max error over the old window [h, π−h] and the new [0, π], with argmax and the range of D3 on [0, π].
- `$S/indep.py` → `$S/indep.out`: independent mpmath (40 digits) and sympy checks. It covers f′ and f‴, f′(1), the values in the archive animations, and the Case 1 max error on the script's 700-point grid over [0, π] and over [h, π−h].
- `$S/indep_cont.py` → `$S/indep_cont.out`: dense 200001-point check that the 700-point grid maximum is the continuous maximum to 3 significant figures.
- `$S/committed/`, `$S/new/`: frames, contact sheets and framemd5 of the committed and regenerated GIFs. `$S/legacy/`: frames of the six archive GIFs. `$S/archive/`: archive statement and code images, upscaled ×4 (`stack.png`, `stack2.png`, `stack3.png`, `g327.png`).

## Findings

### F1 — Minor — fixed
- Reproduced: in the committed `numdiffab.gif` frame 1 (`$S/committed/numdiffab/frame_001.png`) the black curve's legend entry reads only "f". In `julia $S/labeltest.jl`, the label `"f(x) = e^{-x} sin(x)"` renders as "f", while `"f(x) = e^(-x) sin(x)"` and `"f(x) = exp(-x) sin(x)"` render in full (`$S/labeltest.png`).
- Change: `numdiffab.jl` line 46, `label="f(x) = e^{-x} sin(x)"` → `label="f(x) = e^(-x) sin(x)"`.
- Check: the regenerated frames 1, 6 and 12 were viewed at full size. The legend reads "f(x) = e^(-x) sin(x)" in each and fits inside the legend box. All 12 frame md5s differ from the committed ones, as expected, because the legend is in every frame. Titles are unchanged (h = 0.6: secant −0.049354; h = 0.07: −0.109963; h = 0.001: −0.110794; true −0.110794). These match the review's mpmath table, and `indep.py` gives f′(1) = −0.110793765307.

### F2 — Minor — fixed
- Reproduced: `julia $S/aa_instr.jl`. On the old window [h, π−h] the maximum error is at the left end x = h for every h (h = 0.5: 6.81e-02 at x = 0.5000). On the full [0, π] grid it is 8.13e-02 at x = 0.0270. Committed frame 1 shows the blue D3 curve starting at x = 0.5 while the title says "on [0, pi]".
- Change: `numdiffaa.jl` lines 21–26 and 47. The `xint` window is removed, and D3 is evaluated and plotted on `xfull` (700 points on [0, π]). The max error is now taken against `ytrue` on the same grid. A one-line comment says that f is defined outside [0, π]. The title template is unchanged. Because f(x) = e^{−x} sin x is defined for all real x, the stencil points x ± h outside [0, π] are valid (for example f(−0.5) = −0.79043908 and f(π+0.5) = −0.012566015 from `indep.py`).
- Check: the per-frame title values, from the regenerated contact sheet `$S/new/numdiffaa/sheet.png` and frames 1 and 12 viewed at full size, compared with `indep.py` (mpmath, same 700-point grid over [0, π]):

  | h | title (new) | indep.py | continuous max (indep_cont.py) |
  |---|---|---|---|
  | 0.5 | 8.13e-02 | 8.13e-02 | 8.1277e-02 at x = 0.025 |
  | 0.3 | 2.97e-02 | 2.97e-02 | 2.9731e-02 |
  | 0.2 | 1.33e-02 | 1.33e-02 | 1.3280e-02 |
  | 0.1 | 3.33e-03 | 3.33e-03 | 3.3300e-03 |
  | 0.07 | 1.63e-03 | 1.63e-03 | 1.6325e-03 |
  | 0.05 | 8.33e-04 | 8.33e-04 | 8.3313e-04 |
  | 0.03 | 3.00e-04 | 3.00e-04 | 2.9997e-04 |
  | 0.02 | 1.33e-04 | 1.33e-04 | 1.3333e-04 |
  | 0.01 | 3.33e-05 | 3.33e-05 | 3.3333e-05 |
  | 0.005 | 8.33e-06 | 8.33e-06 | 8.3333e-06 |
  | 0.002 | 1.33e-06 | 1.33e-06 | 1.3333e-06 |
  | 0.001 | 3.33e-07 | 3.33e-07 | 3.3333e-07 |

  All 12 titles agree with both checks to the 3 significant figures shown. maxerr/h² = 0.325, 0.330, 0.332, 0.333, … → f‴(0)/6 = 1/3; sympy gives f‴ = 2√2 e^{−x} sin(x+π/4), so f‴(0) = 2. The blue curve spans the whole of [0, π] in every frame. D3 on [0, π] ranges over [−0.1915, 1.0812] at h = 0.5, inside ylims (−1, 1.1). There is no clipping.
- Note on the review's wording: the review says the maximum over [0, π] "is at x = 0". For h ≥ 0.2 it is just to the right of 0 (x ≈ 0.025 at h = 0.5), but the value at x = 0 agrees with it to 3 significant figures for every h (`indep_cont.out`). No location is written on the page, so this does not affect the fix.
- Page text: the Case 1 heading ("$D_3(x,h)$ on $[0,\pi]$"), Behavior and alt text ("over 0 to pi") were already worded for [0, π]. After the fix they match the animation, so they were not changed.

### F3 — Minor — fixed (R2-A one-sentence note)
- Reproduced: the page has two cases, both for the three-point central first-derivative formula (`numdiffaa.jl` `central3`, `numdiffab.jl` `msec = (yr-yl)/(2h)`). The archive has more:
  - `a2001/Animations/Derivative/` holds six GIFs, all for f(x) = e^{−x} sin x at x0 = 1: Forward O(h¹), Forward O(h²), Backward O(h¹), Backward O(h²), Central O(h²) with the interpolating parabola (`CentralD1faa.gif`), and Central O(h²) as a chord (`CentralDfaa.gif`).
  - The module `n2003/NumericalDiffMod.html` also has Project II (Examples 5–8) and Examples 9–17.
- Change: following R2-A ("add one sentence when a whole Mathews example or topic is left out … do not add the example"), the forward/backward cases were not added. One sentence was added to `index.qmd` directly after the last embed (Case 2), since the page has no legacy note. Before it is the Case 2 embed, after it `## Derivation Notes`:
  > The module's forward- and backward-difference formulas for the first derivative (Examples 9, 10, 12 and 13) and its formulas for the second derivative (Project II, Examples 5–8, and Examples 15–17) are not animated here.
- Check: each part of the sentence is verified in the ledger below.
- Not listed, and why:
  - **Examples 11 and 14** (central difference for f′(1)) use the same formula and point as Case 2. The Solution 14 code image (`gr_327`, `$S/archive/g327.png`) has `m = (f[X+H]-f[X-H])/(2H)`, X = 1.0, and draws the line through (X, f(X)) with slope m plus the fitted parabola. Solution 11's images are missing from the snapshot.
  - **Examples 1–4** (Project I, the error study of this same central formula: f‴ and its bound, D3 values, the error plot on [0, π], and the O(h²) error-bound table) are about the formula the page animates, and Case 1 reports the max error per h. I judged them not a left-out topic. See Notes.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `numdiffab.jl` legend | "f(x) = e^(-x) sin(x)" | Script `f(x) = exp(-x) * sin(x)`. `labeltest.png` and new frames 1, 6 and 12 show the full label | yes |
| `numdiffaa.jl` titles (12 frames) | max error ≈ 8.13e-02, 2.97e-02, 1.33e-02, 3.33e-03, 1.63e-03, 8.33e-04, 3.00e-04, 1.33e-04, 3.33e-05, 8.33e-06, 1.33e-06, 3.33e-07 | `python3 -I $S/indep.py` (mpmath, same grid) and `indep_cont.py` (dense grid) → same values to 3 s.f. (table in F2) | yes |
| `numdiffaa.jl` title "on [0, pi]" (unchanged text, now true) | D3 and the error are on [0, π] | `aa_instr.jl` evaluates on `xfull = range(0, pi, 700)`. Frame 1 shows the blue curve from x = 0 to π | yes |
| `numdiffaa.jl` comment | "f is defined outside [0, pi], so D3 can be evaluated on the whole interval" | f = e^{−x} sin x is entire; `indep.py` → f(−0.5) = −0.79043908, f(π+0.5) = −0.012566015 | yes |
| index.qmd new sentence | "forward- and backward-difference formulas for the first derivative (Examples 9, 10, 12 and 13)" | Module text (tags stripped): Ex 9 "two points and the forward difference formula", Ex 10 "… backward …", Ex 12 "three points and the forward …", Ex 13 "three points and the backward …". Statement images `gr_220/221` (Ex 9), `gr_241/242`, `gr_283/284`, `gr_304/305` show `f[x] = e^-x Sin[x]`, `f'[1.0]` (`$S/archive/stack.png`, `stack3.png`). The archive GIFs Forward/Backward O(h¹)/O(h²) print f′[1] values that `indep.py` reproduces with (f(1+h)−f(1))/h, (−3f(1)+4f(1+h)−f(1+2h))/(2h) and (3f(1)−4f(1−h)+f(1−2h))/(2h), e.g. −0.186500 (fwd O(h), h = 1), −0.113879 (fwd O(h²), h = 0.1), −0.234466 (bwd O(h²), h = 0.5) | yes |
| same | "its formulas for the second derivative (Project II, Examples 5–8, …)" | Project II formula image `gr_140/141` = (f(x+h) − 2f(x) + f(x−h))/h² (`stack2.png`). Ex 5 asks for the fourth derivative for its remainder. Ex 6 statement `gr_161` shows f″[0], f″[1], f″[2], f″[3]. Ex 7 `gr_175` shows \|f″[x] − D2[x, 0.01]\|. Ex 8's solution table is EB2[h], the second-derivative error bound | yes |
| same | "… and Examples 15–17" | Module text: "find numerical approximations to the second derivative … forward / backward / central difference formula". Statement images `gr_346/347`, `gr_367/368`, `gr_388/389` show `f''[1.0]` | yes |
| same | "are not animated here" | Page folder: two scripts, both central first-derivative (`central3`, `msec`). No second-derivative or one-sided formula appears in either script or GIF | yes |

## Scripts and GIFs
- Scripts changed: `numdiffaa.jl` (F2) and `numdiffab.jl` (F1). Both were regenerated with `julia <script>.jl` from the page folder.
- GIFs regenerated: `numdiffaa.gif` and `numdiffab.gif`, 12 frames each, as before. All frame md5s changed in both: in aa the D3 curve now spans [0, π] and the titles changed; in ab the legend label changed.
- Frames viewed:
  - numdiffaa: frames 1 and 12 at full size, plus the full contact sheet. Checked: titles legible and matching the table; the blue curve starts at x = 0; at h = 0.5 it lies visibly above f′ near x = 0 (D3(0, 0.5) ≈ 1.08 against f′(0) = 1).
  - numdiffab: frames 1, 6 and 12 at full size. Checked: the legend shows the full label; the secant passes through the outer stencil points; the titles are unchanged.
- `git status --short -- pages/numerical-methods/numerical-differentiation` after regeneration shows `M index.qmd`, `M numdiffaa.gif`, `M numdiffaa.jl`, `M numdiffab.gif`, `M numdiffab.jl`, all expected.

## Legacy archive
Consulted:
- `n2003/NumericalDiffMod.html` (the main page is at `n2003/`, not under `differentiation/`; its images and solution links are under `n2003/differentiation/NumericalDiffMod/`)
- `a2001/Animations/Derivative/`, all six GIFs, frames extracted to `$S/legacy/`

What it showed:
- The chord animation `CentralDfaa.gif` uses f = e^{−x} sin x at x0 = 1 with h = 1.0, 0.8, 0.6, 0.4, 0.2, 0.08, 0.04, 0.008, 0.001. Its printed values (0.061530, −0.001050, −0.049354, −0.083592, −0.104010, −0.109709, −0.110523, −0.110783, −0.110794) are all reproduced by `indep.py`.
- Case 2 matches this animation at the shared steps (h = 0.6, 0.4 and 0.001) and draws the same chord. Its step list differs (it starts at 0.6 and adds more steps), but every step is valid. Nothing in the Case 2 picture is missing relative to that GIF; the parabola-and-tangent drawing belongs to the other central GIF (Example 14 / Animation 5).
- Case 1 corresponds to Example 2(c) (D3 against f′ on [0, π]; Mathews plots only h = 0.01) and to the error studies of Examples 3–4.
- The archive confirms the function, the point x0 = 1, the interval [0, π] and the steps 0.1, 0.01, 0.001 quoted in the Description.
- Solution 11's images (`gr_264`–`gr_282`) are missing from this snapshot.

Differences from the fixed page: the forward/backward and second-derivative material is not animated, and the added sentence says so (R2-A). The page follows the mathematics everywhere else; there was no conflict.

## Notes
- R2-A scope judgment. Examples 1–4 (Project I) study the error of the same central formula the page animates. Example 1 (graph of f‴ and the bound M3) and Example 3 (plot of the absolute error) are not drawn as such. Case 1's titles report the maximum error per h, which is the quantity Examples 3–4 study. I did not list them in the "not animated" sentence. If Jason wants them named too, a clause such as "and the error-bound plots of Examples 1 and 3" could be added after checking those images.
- The reviewer's phrase "the maximum of |D3 − f′| over [0, π] is at x = 0" is very slightly off for h ≥ 0.2 (the argmax is at x ≈ 0.025 for h = 0.5). The values agree to 3 significant figures, and no location was written on the page.
- No other text on the page was changed. The Case 1 heading and alt text already said [0, π] and are now accurate.

### Director note

The checker's N1 (the R2-A note sits after the Case 2 GIF and reads as part of Case 2) is the same placement point raised on several pages. The end-of-page placement was the round-2 pattern from the Monte Carlo page; it is left as is here and listed for Jason in fixes/README.md as a cross-page presentation choice.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `numdiffab.jl` line 46 now reads `label="f(x) = e^(-x) sin(x)"`. I looked at regenerated frames 1, 6 and 12 at full size (`check/committed/numdiffab/frame_001.png`, `frame_006.png`, `frame_012.png`). The legend now reads "f(x) = e^(-x) sin(x)" in full. Nothing else in the script changed. The titles are unchanged and still correct: secant slopes −0.049354 (h=0.6), −0.109963 (h=0.07) and −0.110794 (h=0.001), and true value −0.110794. I checked these with mpmath at 40 digits, which gives −0.049353743, −0.10996341, −0.1107936 and f′(1) = −0.11079377.

### F2 — resolved
- Evidence: `numdiffaa.jl` now evaluates D3 on `xfull` = 700 points on [0, π], and `maxerr` is taken over that same grid. I recomputed the error two ways in mpmath at 40 digits: on the script's 700-point grid, and on a continuous scan of [0, π] with 2001 points. Both give the same 3-significant-figure titles for all 12 h values:

  | h | 0.5 | 0.3 | 0.2 | 0.1 | 0.07 | 0.05 | 0.03 | 0.02 | 0.01 | 0.005 | 0.002 | 0.001 |
  |---|---|---|---|---|---|---|---|---|---|---|---|---|
  | true max on [0, π] | 8.13e-02 | 2.97e-02 | 1.33e-02 | 3.33e-03 | 1.63e-03 | 8.33e-04 | 3.00e-04 | 1.33e-04 | 3.33e-05 | 8.33e-06 | 1.33e-06 | 3.33e-07 |

  - The maximum sits at or next to x = 0, as Mathews' Example 3(b) says. For h = 0.5 the continuous maximum is at x ≈ 0.025 (8.128e-02), which still rounds to 8.13e-02.
  - The values follow the h²/3 law: 8.33e-02 at h = 0.5, then agreement to 3 significant figures from h = 0.07 down.
  - The titles in frames 1–4, 6 and 12 match exactly: 8.13e-02, 2.97e-02, 1.33e-02, 3.33e-03, 8.33e-04 and 3.33e-07.
  - The blue D3 curve now spans the whole of [0, π]. At h = 0.5 it starts at D3(0) ≈ 1.08, inside ylims 1.1, so it is not clipped.

### F3 — resolved (but see new problem N1 on placement)
- Evidence: the fix adds one sentence, which is what decision R2-A asks for. I checked each of its claims against the archive file `n2003/NumericalDiffMod.html` and its solution pages `Links/NumericalDiffMod_lnk_13…21.html`:
  - Ex 9: two-point forward, f′. Correct.
  - Ex 10: two-point backward, f′. Correct.
  - Ex 12: three-point forward, f′. Correct.
  - Ex 13: three-point backward, f′. Correct.
  - Project II: the central second-derivative formula, the "second divided difference". Correct.
  - Ex 5–8 belong to Project II and concern f⁽⁴⁾, f″ approximations, the error plot and O(h²) behaviour. Correct.
  - Ex 15, 16, 17: second derivative by three-point forward, backward and central formulas. Correct.
  - Nothing the sentence lists is in fact animated on the page, and nothing it omits is left unmentioned except as noted below.
  - Ex 11 (two-point central, Animation 6, the chord) is what Case 2 animates.
  - Ex 14 (three-point central, Animation 5, the parabola and tangent picture) uses the same formula, (f(x0+h) − f(x0−h))/(2h). Its formula is therefore covered, and only Mathews' parabola picture is not reproduced. The sentence's wording, "formulas … are not animated", stays true. I do not count this as a defect.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| numdiffaa.jl l.23 | comment "f is defined outside [0, pi], so D3 can be evaluated on the whole interval" | f = e^{-x} sin x is entire | true |
| numdiffaa.gif titles, 12 frames | 8.13e-02 … 3.33e-07 (table above) | mpmath, 700-pt grid and continuous scan of [0, π] | all correct |
| numdiffaa.gif title text | "on [0, pi]" | curve and max now cover [0, π] | now true |
| numdiffab.jl l.46 / GIF legend | "f(x) = e^(-x) sin(x)" | matches f in script and page; renders in full | correct |
| index.qmd l.42 | "forward- and backward-difference formulas for the first derivative (Examples 9, 10, 12 and 13)" | archive Ex 9/10 two-point fwd/bwd, Ex 12/13 three-point fwd/bwd | correct |
| index.qmd l.42 | "formulas for the second derivative (Project II, Examples 5–8, and Examples 15–17)" | archive Project II = central f″; Ex 5–8 under it; Ex 15–17 f″ fwd/bwd/central | correct |
| index.qmd l.42 | "are not animated here" | page has only central f′ cases | true |
| index.qmd l.32 alt text (unchanged) | "…over 0 to pi…" | now literally true, since the curve spans [0, π] | fine |

### New problems

### N1 — Minor — page-level note placed inside Case 2's subsection
- Location: `index.qmd` line 42.
- Evidence: the sentence comes right after the Case 2 GIF (line 40). It has no heading or separator of its own, and the next heading is `## Derivation Notes` (line 44). In the rendered page it therefore sits inside "### Case 2 - secant to tangent at $x_0=1$". A reader can take it as a remark about Case 2, when it is about the page as a whole. The opening words "The module's …" soften this but do not remove it.
- Fix: move the sentence to the end of the Animations intro paragraph (after line 24), before `### Case 1`.
- Context: other round-2 pages use the same end-of-last-case placement, for example cubic-splines l.38, bezier-curves l.43, aitkens-and-nevilles l.38 and broydens-method l.89. So this is a pattern across pages, not a one-off.

No other new problems. That rests on the following:
- the recomputed titles;
- full-size frames 1, 2, 3, 4, 6 and 12 of numdiffaa and frames 1, 6 and 12 of numdiffab;
- byte-identical regeneration of both GIFs;
- the script diff, which touches only the evaluation grid, the max-error grid, the D3 plot grid and one legend label.

### Reproducibility and conventions
- I ran scratch copies of `numdiffaa.jl` and `numdiffab.jl` (`check/run/`). Both outputs are byte-identical (`cmp`) to the GIFs in the working tree, and their decoded frame MD5s match. There are 12 frames each.
- The pre-fix GIFs (via `git show HEAD:… | git lfs smudge`) were extracted to `check/old/` for comparison.
- Description comes before Animations. Each case has a `[Julia source]` link and a GIF embed with descriptive alt text. There are no code blocks. The Animations section sits above Derivation Notes.
- The fix diff touches only the five files in `pages/numerical-methods/numerical-differentiation/`. Other modified files in the working tree belong to other pages' fixers and are not part of this diff.
- Repository not modified. No state-changing git commands were run, and quarto was not run.

**Final status:** committed
