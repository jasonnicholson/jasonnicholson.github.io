# Fix record: newton-cotes-integration

Scratch folder (all evidence, re-runnable): `$F = /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/newton-cotes-integration/fix/`

- `$F/indep.py` → `$F/indep_out.txt`: true integral (mpmath, x=t³ substitution, cross-checked by split quadrature), Newton-Cotes weights from the moment equations (sympy), all four composite rules in mpmath, every legacy frame value compared with the rule, final-frame errors, errors at 41 points.
- `$F/instr.jl` → `$F/inst_bb.txt`, `inst_cc.txt`, `inst_dd.txt`: instrumented copies of the modified scripts (plain loop in place of `@animate`, per-frame inspection of `Plots.current().series_list`).
- `$F/aa_labels.jl` → `$F/inst_aa.txt`: Case 1 frame labels (unchanged script, same functions).
- `$F/cmp_labels.py` → `$F/cmp_labels_out.txt`: page frame labels compared with legacy frame labels.
- `$F/pixelcheck.py` → `$F/pix_bb.txt`, `pix_cc.txt`, `pix_dd.txt`: independent pixel check of dots and dividers in the regenerated frames.
- Frames: `$F/legacy/*` (four legacy GIFs, plus `sheet_odd.png` covering the frames the default contact sheet skips), `$F/committed/*` (before), `$F/new/*` (after).

## Findings

### F1 — Minor — fixed
- **Reproduced.** The archive has the GIF: `/home/jason/Desktop/math-fullerton/baseline/mathews/a2001/Animations/Quadrature/Simpson38/Simpsonaa.gif` (md5 b8197c9b…, which differs from `Simpson/Simpsonaa.gif` c980340c…). `NewtonCotesMod.html` links `/a2001/Animations/Quadrature/Simpson38/Simpson.html`. I extracted it with `giftools.jl` (24 decoded frames; ffmpeg merges a duplicate frame, so the review's count of 26 is not material). Its frames are titled "Simpson's 3/8 Rule" and labelled y = e^{-x} sin(8x^{2/3}) + 1 on 0…2. The page's claim that the GIF is missing is false.
  - Beyond the finding: I read **all** 20 data frames of each of the four legacy GIFs (Trapezoidal, Simpson, Simpson38, Boole), 80 values in all, from both contact sheets. `indep.py` shows each legacy value equals the independent composite rule to 6 decimals (`mismatches=0` for all four). `cmp_labels.py` shows that wherever a page frame and a legacy frame have the same number of sample points, the labels agree: 15 shared counts for the trapezoid, 20 for Simpson 1/3, 17 for 3/8 and 20 for Boole, with no mismatches.
- **Change.** `index.qmd`, the legacy note at the end of Animations. Before: "the archive is incomplete … (notably Simpson's 3/8 GIF), so the 3/8 case is reconstructed …". After: "Legacy note: each case uses the same rule, integrand and interval as Mathews' animation of that rule, and at every number of sample points the two share, the approximations agree to six decimals." This is the R2-A "correct every stale legacy-GIF-missing note". I wrote it for all four cases rather than only 3/8, because once the false premise is removed a 3/8-only note reads oddly, and the four-case statement is verified.
- **Check.** See ledger rows L1–L3.

### F2 — Minor — fixed (R2-A: follow Mathews for missing picture elements)
- **Reproduced.** `committed/newtoncotesbb/frame_003.png` and `committed/newtoncotescc/frame_005.png` have no node markers and no panel dividers. All three scripts plot only `plot!(xp, yp; fillrange=0.0, …)` per panel. The legacy Simpson, Simpson38 and Boole frames draw a red dot at every sample point and a red vertical line at every panel boundary, endpoints included (e.g. `legacy/Simpson38_Simpsonaa/frame_005.png`, and the sheets).
- **Change.** In `newtoncotesbb.jl`, `newtoncotescc.jl` and `newtoncotesdd.jl` I applied the Simpson-page pattern verbatim, changing only the divider stride.
  - `xlims = (0.0, 2.0)` → `(-0.03, 2.03)`.
  - Dividers `for i in 0:m:n; xk = a + i*dx; plot!([xk,xk],[0,f(xk)]; color=:red, lw=0.8)`, with m = 2, 3 and 4. They are drawn after the fills and before the curve.
  - After the magenta curve: `scatter!([a + i*dx for i in 0:n], f.(…); color=:red, markersize=3, markerstrokewidth=0)`.
  - The `n_seq`, rules, fills, annotations and titles are unchanged.
  - Alt text of Cases 2–4 now says red dots mark the sample points and vertical red lines the panel boundaries (and mentions the opening curve-only frame).
- **Check.**
  - `instr.jl`, every frame of all three GIFs: one scatter with n+1 points, x bit-equal (`===`) to `a+i*dx` and y == f.
  - Exactly n/m+1 two-point dividers at `a+i*dx`, `i in 0:m:n`, each with y = [0, f(x)].
  - Series order fills → dividers → curve → scatter (`PDCS`). The n=0 frame contains only the curve.
  - Output: `ALL OK` ×3.
  - `pixelcheck.py` on the regenerated frames: a red pixel within ±1 px of every predicted dot, and at 20/50/80 % of every divider's height. As a control, there is no red at nodes that are not panel boundaries.
  - Results: bb 20/20 frames, cc 24/24, dd 24/24 `OK`, `ALL OK`.

### F3 — Minor — fixed (text, per R2-A/D7; animation kept as Mathews made it)
- **Reproduced.** `indep.py` gives I = 2.01627971961709632788727442192, and the last-frame errors are:

  | Rule | Last frame | Error |
  |---|---|---|
  | trapezoid | n=120 | −1.335e-3 |
  | Simpson 1/3 | n=40 | −2.39e-3 |
  | 3/8 | n=120 | −4.693e-4 |
  | Boole | n=120 | −3.185e-4 |

  So the Simpson 1/3 last frame is the least accurate of the four last frames, as the finding says.
- **Choice.** The finding offers two fixes: extend `n_seq` to 120, or add a sentence. I added the sentence. Mathews' own Simpson animation stops at exactly the same place: its last frame is "Sample Points = 41, Approximation = 2.013890" (`legacy/Simpson_Simpsonaa/frame_024.png`). The page's `n_seq = 2:2:40` reproduces all 20 legacy frames, with the same counts and values (`cmp_labels`: 20 shared, 0 mismatches). R2-A says to follow Mathews for case parameters, and D7 says to change the text when both are defensible. Nothing on the page is mathematically wrong: the page's comparison is stated "at equal h".
  - Note: the review's context line says the legacy Simpson GIF "stopped at 39 points". The last legacy frame actually shows 41 points, so the page already matches it.
- **Change.** In the Case 2 Behavior I appended: "This animation stops at 41 sample points, as Mathews' Simpson's rule animation does, so its last frame is less accurate than the 121-point last frames of the other cases; at 41 points its error ($2.4\times10^{-3}$) is smaller than the trapezoidal rule's ($8.3\times10^{-3}$)."
- **Check.** Ledger rows B1–B4.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| L1 legacy note | "each case uses the same rule … as Mathews' animation of that rule" | Legacy GIF titles "Trapezoidal Rule", "Simpson's Rule", "Simpson's 3/8 Rule", "Boole's Rule" (sheets in `$F/legacy/*`), which match Cases 1–4. The legacy values equal the independent rule of that name: `indep.py` → `mismatches=0` for trap/simp13/simp38/boole | yes |
| L2 legacy note | "integrand and interval" the same | Every legacy frame is labelled `y = e^{-x} sin(8x^{2/3}) + 1` with x axis 0…2 (sheets). The 80 legacy values match rules computed on f on [0,2] (`indep.py`) | yes |
| L3 legacy note | "at every number of sample points the two share, the approximations agree to six decimals" | `cmp_labels.py` → shared counts 15/20/17/20, label mismatches `[]` for all four | yes |
| B1 Case 2 Behavior | "stops at 41 sample points" | `inst_bb.txt` last line `n=40 pts=41`; new `frame_021.png` shows "Sample Points = 41" | yes |
| B2 Case 2 Behavior | "as Mathews' Simpson's rule animation does" | `legacy/Simpson_Simpsonaa/frame_024.png` (last frame) shows "Sample Points = 41" | yes |
| B3 Case 2 Behavior | "its last frame is less accurate than the 121-point last frames of the other cases" | `indep.py` gives \|err\|: Simpson n=40 2.39e-3 > trap n=120 1.335e-3, 3/8 n=120 4.693e-4, Boole n=120 3.185e-4. The last frames of aa, cc and dd are n=120 (121 points): `inst_aa.txt`, `inst_cc.txt`, `inst_dd.txt` | yes |
| B4 Case 2 Behavior | "at 41 points its error (2.4×10⁻³) is smaller than the trapezoidal rule's (8.3×10⁻³)" | `indep.py`: simp13 n=40 err −0.00239; trap n=40 err −0.008263. The trapezoid GIF has a 41-point frame (n=40 is in its `n_seq`) | yes |
| A2 alt Case 2 | "after an opening frame showing only f" | `inst_bb.txt` n=0 `order=C` (curve only); new frame_001 viewed | yes |
| A2 alt Case 2 | "density increases each frame up to 41 sample points" | `n_seq` 2:2:40 strictly increasing; last pts=41 | yes |
| A2 alt Case 2 | "red dots mark the sample points, vertical red lines mark the boundaries of the pairs of subintervals" | `instr.jl` (n+1 dots; dividers at i in 0:2:n) and `pixelcheck.py` → ALL OK | yes |
| A3 alt Case 3 | "opening frame only f", "up to 121 sample points", dots / boundaries of the triplets | `inst_cc.txt` n=0 `order=C`, last `pts=121`, n_seq strictly increasing; dividers at 0:3:n; pixelcheck ALL OK | yes |
| A4 alt Case 4 | "opening frame only f", "up to 121 sample points", dots / boundaries of the blocks of four | `inst_dd.txt` n=0 `order=C`, last `pts=121`, n_seq strictly increasing (…,104,112,116,120); dividers at 0:4:n; pixelcheck ALL OK | yes |
| A2–A4 alt | "piecewise quadratic/cubic/quartic area approximation updates" | Unchanged substance; the review confirmed the interpolant degree per panel (C2-w, C3-w, C4-w) | yes |
| GIF labels (unchanged code) | "Sample Points = n+1", "Approximation = …" in the new GIFs | `inst_*.txt` labels equal the independent rule to 10 digits (`indep.py` composite values). Rendered labels are viewed in frames bb 3/21, cc 5/25, dd 3/25 | yes |

## Scripts and GIFs
- **Scripts changed:** `newtoncotesbb.jl`, `newtoncotescc.jl`, `newtoncotesdd.jl` (each +12 lines and the xlims line). `newtoncotesaa.jl` is unchanged and was not regenerated.
- **GIFs regenerated:** `newtoncotesbb.gif` (21 frames), `newtoncotescc.gif` (25) and `newtoncotesdd.gif` (25), by `julia <script>.jl` in the page folder.
- **Frames viewed at full size:**
  - bb frames 3 (5 points) and 21 (41 points, last);
  - cc frame 5 (13 points);
  - dd frames 3 (9 points) and 25 (121 points, last);
  - contact sheets of all three (first frame curve-only, middle frames).
- **Checked in those frames:**
  - a dot at every node, including the end dots at x=0 and x=2, which are whole and not clipped;
  - dividers only at panel boundaries, endpoints included: in bb frame 3 they are at 0, 1, 2; in dd frame 3 at 0, 1, 2; in cc frame 5 at 0, 0.5, 1, 1.5, 2;
  - labels legible and correct;
  - the overshoot of the interpolant near x≈0.1 is still visible.
- **Dot density.** At 121 points (about 4.7 px spacing: plot box 578.5 px / 2.06 × 2/120) neighbouring dots touch on the steep rise near x≈0.1 but remain distinguishable. This matches the density of the legacy 121-point frames.
- **`git status --short -- pages/numerical-methods/newton-cotes-integration` after regeneration:** `M index.qmd`, `M newtoncotesbb.gif`, `M newtoncotesbb.jl`, `M newtoncotescc.gif`, `M newtoncotescc.jl`, `M newtoncotesdd.gif`, `M newtoncotesdd.jl`. These are the expected files only.
- **Render.** `quarto render pages/numerical-methods/newton-cotes-integration/index.qmd --output-dir $F/render` exited 0 with no warnings. The new Behavior math and the three alt texts appear in the HTML. The render created an untracked `_freeze/site_libs/bootstrap/` in the repo (timestamp identical to the render), and I removed it.

## Legacy archive
- **Consulted:** yes. I read `n2003/NewtonCotesMod.html` as text and extracted the four GIFs it links (`a2001/Animations/Quadrature/{Trapezoidal,Simpson,Simpson38,Boole}`).
- **What it shows:**
  - All four GIFs use f(x)=e^{-x} sin(8x^{2/3})+1 on [0,2].
  - Each draws a pink fill, a red dot at every sample point, red vertical lines at panel boundaries and a magenta curve.
  - Sample-point sequences:
    - Trapezoidal: 2, 3, 5, 7, …, 101, 121.
    - Simpson: 3, 5, …, 41.
    - Simpson 3/8: 4, 7, …, 91, 106, 121.
    - Boole: 5, 9, …, 113, 121.
  - All 80 printed values are correct (`indep.py`).
- **Differences from the page:**
  - The page's Trapezoidal, 3/8 and Boole sequences differ from Mathews' at some counts. The values agree wherever the counts coincide.
  - The page keeps the plain Plots.jl styling.
  - The page has no on-frame formula label. Mathews shows "y = e^{-x}…" in the corner.
  - None of these is a finding.
- **Module examples.** The module's Examples 1–7 are worked computations and degree-of-precision proofs, not animations. The page animates the module's four linked animations, so I added no R2-A "left out" sentence (see Notes).

## Notes
- **Case 1 has no dots (not a finding, not changed).** Case 1 (`newtoncotesaa.jl`) draws no sample-point dots, while Mathews' trapezoid GIF does. Its node positions are visible as trapezoid corners and vertical edges, and F2 named only Cases 2–4, so I left it. If Jason wants all four cases to look the same, add the same `scatter!` block after the curve, plus the x-margin. That would regenerate `newtoncotesaa.gif`.
- **R2-A "left out" sentence not added.** NewtonCotesMod has Examples 1–7: numerical comparisons on a five-node example, and degree-of-precision proofs. They were never animations, and no finding names them. If the director wants the R2-A "left out" sentence anyway, it would go after the legacy note.
- **Review count corrections.** The legacy Simpson GIF ends at 41 points, not 39 as the F3 context line says. The legacy 3/8 GIF decodes to 24 frames here, not 26. Neither affects any fix.
- **Description line unchanged.** The Description line "follow the legacy style by increasing point density" remains true: every `n_seq` is strictly increasing over the full interval, as in the legacy GIFs.

## Resolution check (independent checker, not shown this record)

All work is in `.../r2fix/newton-cotes-integration/check/`. The independent computation is `indep.py`, with output in `indep.out`. It uses mpmath at 30 digits and builds every composite rule from its own panel weights, without using the page scripts. Reference: I = 2.01627971961709632788727 (x = t^3 substitution), which agrees with a direct split quadrature to 29 digits. Frames are in `frames/{aa,bb,cc,dd}/` and legacy frames in `legacy/{Trapezoidal,Simpson,Simpson38,Boole}/`. Each of those folders also has `text.png`, a tile of the annotations from every frame.

### Original findings

### F1 — resolved
- Evidence: the false line "archive is incomplete ... (notably Simpson's 3/8 GIF) ... reconstructed" is gone. A grep for missing/reconstruct/incomplete in `index.qmd` finds nothing.
- The new line 57 reads: "each case uses the same rule, integrand and interval as Mathews' animation of that rule, and at every number of sample points the two share, the approximations agree to six decimals."
- I checked it as follows:
  - I transcribed all 20 approximation values from each of the four legacy GIFs: `a2001/Animations/Quadrature/{Trapezoidal/Trapezoidalaa, Simpson/Simpsonaa, Simpson38/Simpsonaa, Boole/Booleaa}.gif`.
  - My independent mpmath values reproduce every one of the 80 to 6 decimals, with 0 mismatches. So each legacy GIF uses f = e^{-x} sin(8x^{2/3}) + 1 on [0,2] with the named rule.
  - Shared sample-point counts: Trapezoid 15, Simpson 1/3 20, Simpson 3/8 17, Boole 20. In every case the value shown in the page GIF frame equals the legacy value. Trailing zeros are dropped in the page frames, e.g. 1.79047 = 1.790470 and 2.01389 = 2.013890.
- The statement is true.

### F2 — resolved
- Evidence: all three scripts now draw vertical red dividers at every panel boundary x_{mk}, k = 0..n/m (m = 2, 3, 4), including a and b. They also scatter red dots at all n+1 nodes, drawn last.
- Full-size frames viewed:
  - bb frames 002, 011 and 021: 3/21/41 points; dividers at the even nodes, e.g. 11 dividers for 21 points.
  - cc frames 001, 004, 013 and 025: f only; 10 points with dividers at 0, 2/3, 4/3, 2; 37 points; 121 points.
  - dd frames 003, 013 and 025: 9 points with dividers at 0, 1, 2; 49 points with 13 dividers; 121 points.
- Dot counts match "Sample Points = N" in the frames I counted (3, 10, 9). Pairs, triplets and blocks of four can be read directly, as in the legacy frames.
- The area computations are untouched in the diff, and the displayed approximations are unchanged and correct.

### F3 — resolved (via the finding's stated alternative)
- Evidence: `n_seq` in `newtoncotesbb.jl` is unchanged and still stops at n = 40. The fixer added one sentence to Case 2 instead, which the finding allows. Each claim in it checks:
  - The legacy Simpson GIF does stop at 41 points: its last frame (`legacy/Simpson/frame_024.png`) reads "Sample Points = 41, Approximation = 2.013890". The finding's "39 points" was a slip.
  - Last-frame errors: Simpson 1/3 at 41 points is 2.390e-3. The other cases at 121 points are trapezoid 1.335e-3, 3/8 4.69e-4 and Boole 3.19e-4. So "less accurate than the 121-point last frames of the other cases" is true.
  - At 41 points: Simpson error 2.3897e-3, which rounds to 2.4e-3. Trapezoid error 8.2628e-3, which rounds to 8.3e-3. The trapezoid GIF has a 41-point frame, showing 2.008017, so a reader can make this comparison.
- The final-frame comparison no longer points the wrong way without warning.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Case 2 Behavior | "stops at 41 sample points" | bb n_seq ends at 40; last frame shows 41 | correct |
| Case 2 Behavior | "as Mathews' Simpson's rule animation does" | legacy Simpson frame_024: 41 points | correct |
| Case 2 Behavior | "last frame is less accurate than the 121-point last frames of the other cases" | errors 2.39e-3 vs 1.34e-3, 4.7e-4, 3.2e-4; aa, cc and dd all end at 121 points | correct |
| Case 2 Behavior | Simpson error at 41 points 2.4e-3 | I − S_40 = 2.38968e-3 | correct |
| Case 2 Behavior | trapezoid error at 41 points 8.3e-3 | I − T_40 = 8.26282e-3 | correct |
| Case 2 alt text | opening frame shows only f; density rises to 41 points; dots at sample points; red lines at pair boundaries; quadratic area | frames bb/001 (f only), 002, 011, 021; code | correct |
| Case 3 alt text | opening f-only frame; rises to 121 points; dots; triplet boundaries; cubic area | frames cc/001, 004, 013, 025 | correct |
| Case 4 alt text | opening f-only frame; rises to 121 points; dots; boundaries of blocks of four; quartic area | frames dd/003, 013, 025; n = 0 branch draws only f, same code as bb/cc | correct |
| Legacy note (line 57) | same rule, integrand and interval as Mathews | 80/80 legacy values reproduced independently | correct |
| Legacy note (line 57) | agree to six decimals at every shared point count | 72 shared counts (15 + 20 + 17 + 20); all equal | correct |
| scripts | `xlims = (-0.03, 2.03)` | the end markers at x = 0 and x = 2 are visible, not clipped (frames) | fine |

### New problems
None. This rests on the following:
- each changed sentence and number was recomputed independently, as in the ledger;
- the full-size first, middle and last frames of all three regenerated GIFs were viewed;
- the computations in the scripts are unchanged.

There are two cosmetic notes, neither of them a defect:
- Case 1 (`newtoncotesaa.jl`, untouched) keeps `xlims = (0, 2)`, while cases 2–4 now use (−0.03, 2.03).
- `round(approx; digits=6)` drops trailing zeros in the labels (e.g. "2.01389", "2.01581"). This predates the fix.

### Reproducibility and conventions
- Ran scratch copies of `newtoncotesbb.jl`, `newtoncotescc.jl` and `newtoncotesdd.jl`. All three output GIFs are byte-identical (sha256) to the working-tree GIFs:
  - bb 0ae9b9f3…
  - cc f15971d3…
  - dd d71a8d80…

  These match the LFS oids in the diff.
- Conventions hold:
  - Description comes before Animations.
  - Each of the four cases has a "[Julia source]" link and a GIF embed.
  - The alt text is descriptive.
  - There are no code blocks (grep for ``` finds none).
- Every changed path containing "newton-cotes" is inside the page folder. The working tree also has many other pages modified, from parallel fixers. None of those changes touch this page, and the section index diff does not mention Newton-Cotes.

**Final status:** committed
