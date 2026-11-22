# Fix record: aitkens-and-nevilles-interpolation

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/aitkens-and-nevilles-interpolation/fix/`
- `inst.jl` / `inst.out`: instrumented copy of the script's Neville computation (no plotting); plot-range y extremes, max error on [0, π] (200001-point grid), P_{0,j}(π), max |P04 − P03|.
- `sym.py`, `deg.py` / `deg.out`: sympy exact interpolants, exact degree and leading coefficient of each P_{0,j}.
- `archive_check.py` / `archive_check.out`: checks of the archive's examples (Example 1 constructions; Examples 2–7 Aitken vs Neville tableaux at x̂).
- `montage.py`, `archive/stmts.png`: upscaled montage of the archive's example statement images.
- `frames_new/`: frames, contact sheet and framemd5 of the regenerated `nevilleaa.gif`.

## Findings

### F1 — Minor — fixed
- Reproduced: frame 5's title of the committed GIF read "degree 4 (5 nodes)". `julia inst.jl` → `max |P04-P03| on plot grid = 6.661338147750939e-16`. `python3 -I sym.py` → `deg P04: 3`, `P04-P03 simplify: 0`. `python3 -I deg.py` → exact degrees 0, 1, 2, 3, 3 for j = 0..4, leading coefficients 1, −0.37292, −0.33575, 0.14250, 0.14250 (all nonzero), so P_{0,j} has exact degree j for j ≤ 3, and P_{0,4} has degree 3.
- Change: `nevilleaa.jl` title: `"Neville's Algorithm for cos(x) — degree $deg  ($(deg+1) node…)"` → for j ≤ 3 `"Neville's Algorithm for cos(x) — P_{0,$deg}, degree $deg ($(deg+1) node(s))"`, for j = 4 `"Neville's Algorithm for cos(x) — P_{0,4} = P_{0,3}, degree 3 (5 nodes)"`; `titlefontsize=12` added so the longer frame-5 title fits (at the default size it ran off the right edge, seen in a first regeneration). Header comment updated to match.
- Check: regenerated; frames 1–5 viewed full size / on the contact sheet. Titles read "P_{0,0}, degree 0 (1 node)", "P_{0,1}, degree 1 (2 nodes)", "P_{0,2}, degree 2 (3 nodes)", "P_{0,3}, degree 3 (4 nodes)", "P_{0,4} = P_{0,3}, degree 3 (5 nodes)", all fully inside the frame. The literal `P_{0,j}` notation matches the existing legend's literal "P_{0,j}(x)".

### F2 — Minor — fixed
- Reproduced: `inst.out` → `deg=2 plot-range y in [-2.8820916416764812, 1.0075651798052252] argmin x=3.241592653589793  maxerr[0,pi]=1.6568542494923797 at x=3.141592653589793  P(pi)=-2.6568542494923797`; with ylims (−1.4, 1.4) the quadratic left the axes. sympy: P_{0,2}(π) = 3 − 4√2 = −2.65685424949238, error at π 1.65685424949238.
- Change: `nevilleaa.jl` `ylims=(-1.4, 1.4)` → `ylims=(-3.0, 1.4)` (all frames, keeping one scale). index.qmd Behavior: "rises to 1.66 at $j=2$" → "rises to 1.66 at $j=2$ (at $x=\pi$, where the quadratic reaches $-2.66$)".
- Check: all plotted values lie in the new window: `inst.out` y ranges j=0 [1, 1]; j=1 [−0.209, 1.037]; j=2 [−2.882, 1.008]; j=3,4 [−1.0017, 1.0017]; cos in [−1, 1]. Frame 3 viewed full size: the dashed quadratic stays inside the axes to x = π + 0.1 (bottom at −2.88, above the −3 limit), and at x ≈ 3.14 it sits near −2.66 while cos is at −1, so the 1.66 gap is readable. Legend (top right) does not cover any curve in frames 1–5.

### F3 — Minor (fidelity) — fixed (R2-A: one sentence about what is left out)
- Reproduced: archive `n2003/NevilleAlgorithmMod.html` lists Examples 1–7 (solution links lnk_2…lnk_8; lnk_6–lnk_8 are missing from the snapshot). Statement images (montage `archive/stmts.png`, gr_76–78, 201–204, 291–294, 336–339, 386–390, 495–498, 515–518): Ex 1 e^x on {0, 1, 2}, construct P_{0,1,2}[x]; Ex 2 e^x on {1 + i/4}, i = 0..3, x̂ = 1.6; Ex 3 e^x on {1 + i/4}, i = 0..5, x̂ = 1.8; Ex 4, 6, 7 BesselJ[0, x] on {0.5 i}, i = 0..5, x̂ = 1.8; Ex 5 e^x on the same nodes rearranged {1.75, 1.5, 2.0, 1.25, 2.25, 1.0}, x̂ = 1.8. No cos x example. No animation for this topic: the module HTML references no GIF other than its formula images and two navigation icons (`/gifs/brul.gif`, `/gifs/brur.gif`); `ls -R a2001/Animations | grep -ci 'nevil|aitken'` → 0, and no `a2001/Animations/*.html` mentions Neville or Aitken.
- Change: index.qmd, after the Case 1 embed (the page has no legacy note, so this is the place the R2-A pattern names), two source lines forming one paragraph:
  "No archived animation GIF is available for this topic in the current snapshot, so the $\cos x$ example animated here is the page's own, not one of the examples in Mathews' module.
  The module's Examples 1–7, which build an interpolating polynomial by recursion (Example 1) and fill in Aitken's and Neville's tableaux at a single evaluation point (Examples 2–7), are not animated here."
  The example is kept (cos x is mathematically sound and the round-2 review found no error in it); no example added (R2-A).
- Check: see ledger rows 4–7. Wording follows the Monte Carlo pattern: kinds not formulas, no numbers other than example numbers, "are not animated here".

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| 1. index.qmd Behavior | "rises to 1.66 at $j=2$ (at $x=\pi$ …" — max error of P_{0,2} on [0, π] is at x = π | `julia inst.jl` → `maxerr[0,pi]=1.6568542494923797 at x=3.141592653589793`; sympy error at π = 1.65685424949238 | yes |
| 2. index.qmd Behavior | "where the quadratic reaches $-2.66$" | `inst.out` `P(pi)=-2.6568542494923797`; sympy `P02(pi) = 3 - 4*sqrt(2)` = −2.65685424949238 → −2.66 | yes |
| 3. index.qmd Behavior (unchanged, rechecked) | "the last two frames show the same curve" | `max |P04-P03| = 6.66e-16`; frames 4 and 5 viewed: same dashed curve, frame 5 adds the node at (π, −1) and its own title | yes |
| 4. index.qmd note | "No archived animation GIF is available for this topic in the current snapshot" | grep of module HTML for non-formula GIFs → only `/gifs/brul.gif`, `/gifs/brur.gif` (navigation); `ls -R a2001/Animations \| grep -ci 'nevil\|aitken'` → 0; `grep -il 'nevil\|aitken' a2001/Animations/*.html` → none | yes |
| 5. index.qmd note | "the $\cos x$ example … is the page's own, not one of the examples in Mathews' module" | statement images of Examples 1–7 (`archive/stmts.png`) use only e^x and BesselJ[0, x] | yes |
| 6. index.qmd note | "Examples 1–7" and "build an interpolating polynomial by recursion (Example 1)" | module text: "Example 1 … Use recursion to construct the polynomial P_{0,1,2}[x]" (gr_76–78); lnk_2 solution text builds it three ways and concludes they are equivalent. `python3 -I archive_check.py` → Aitken-, Neville- and third-arrangement constructions of P_{0,1,2} for e^x on {0,1,2} minus Lagrange = `[0, 0, 0]`; node residuals `[0, 0, 0]`. Highest example number in the module is 7 (`grep Example` on stripped text) | yes |
| 7. index.qmd note | "fill in Aitken's and Neville's tableaux at a single evaluation point (Examples 2–7)" | module text for each of Examples 2–7: "compute the entries in Aitken's tableau and Neville's tableau for evaluating f[x] at x̂"; statement images give one x̂ each (1.6, 1.8, 1.8, 1.8, 1.8, 1.8). `archive_check.out`: both tableaux computed at x̂ end on the same value for every example set (Ex2 4.95357859297075, Ex3 and Ex5 6.04964312571372, Ex4/6/7 0.339997100453031; differences ≤ 8e-31 at 30 digits) | yes |
| 8. nevilleaa.jl title, j = 0..3 | "P_{0,j}, degree j (j+1 nodes)" | `deg.out`: exact degrees 0, 1, 2, 3; leading coefficients 1, −0.37292, −0.33575, 0.14250 (nonzero) | yes |
| 9. nevilleaa.jl title, j = 4 | "P_{0,4} = P_{0,3}, degree 3 (5 nodes)" | sympy `simplify(P04 − P03) = 0`, `degree(P04) = 3`; floating point max diff 6.66e-16 | yes |
| 10. nevilleaa.jl comment | "ylims include the quadratic's minimum (≈ -2.88 at x = π + 0.1)" | `inst.out` deg=2 min −2.8820916416764812 at x = 3.241592653589793 = π + 0.1; sympy P_{0,2}(π + 1/10) = −2.88209164167648, derivative zero at −0.163 (outside the plot range, a maximum since the leading coefficient is negative) | yes |
| 11. nevilleaa.jl header comment | "one frame per added node, P_{0,j} for j = 0→4"; "P_{0,4} = P_{0,3} … frame 5 is titled degree 3" | `for deg in 0:4` → 5 frames (giftools: "5 frames"); row 9 | yes |
| 12. nevilleaa.jl | `ylims=(-3.0, 1.4)` | all series inside: `inst.out` overall min −2.882, max 1.037 | yes |

Unchanged text that remains consistent with the new GIF: the Animations intro ("degree at most j"), the Case heading, the alt text ("P_{0,4}, which is the same cubic as P_{0,3}").

## Scripts and GIFs
- Script changed: `nevilleaa.jl` (title, `titlefontsize=12`, `ylims`, comments). Computation unchanged.
- GIF regenerated: `nevilleaa.gif` (5 frames, fps 1), via `cd pages/numerical-methods/aitkens-and-nevilles-interpolation && julia nevilleaa.jl`.
- Frames viewed: full size 1, 3, 5; all five on the contact sheet. Checked: titles fully inside the frame and correct per frame (ledger 8, 9); legend entries P_{0,j}(x) match the title index; frame 3 shows the quadratic to x = π + 0.1 inside the axes; frames 4 and 5 show the same curve; frame 5 has 5 nodes. An earlier regeneration at the default title size clipped frame 5's title ("…(5 no"), which led to `titlefontsize=12`.
- `git status --short -- pages/numerical-methods/aitkens-and-nevilles-interpolation` after regeneration:
  ```
   M pages/numerical-methods/aitkens-and-nevilles-interpolation/index.qmd
   M pages/numerical-methods/aitkens-and-nevilles-interpolation/nevilleaa.gif
   M pages/numerical-methods/aitkens-and-nevilles-interpolation/nevilleaa.jl
  ```
  (single-case page; no unchanged cases to compare byte-for-byte.)

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/NevilleAlgorithmMod.html` (stripped text), its statement images, and `nevillealgorithm/NevilleAlgorithmMod/Links/NevilleAlgorithmMod_lnk_2.html` and `_lnk_3.html` (stripped text); `a2001/Animations/` searched. The module has seven examples (above) using e^x and the Bessel function J₀, all worked as tableaux at a point except Example 1, which builds the quadratic interpolant by recursion. Solution pages for Examples 5–7 (lnk_6–lnk_8) are missing from the snapshot. There is no animation for this topic. The page keeps its own cos x example (the review found it mathematically sound; R2-A says to add one sentence for left-out examples, not to add them) and now says so.

## Notes
- The Description's "the unique degree-$(n-1)$ polynomial" and the Behavior's "builds the degree-$n$ interpolating polynomial" use the nominal degree (the review's claim ledger rows 1 and 13 rated these as confirmed loose wording, not findings); left unchanged.
- Quarto render of the page was not run by this fixer (it writes outside the page folder); the added text is plain Markdown with inline `$…$` math like the rest of the page.
- Nothing outside the page folder was touched except this record.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The script (`nevilleaa.jl` lines 48–51) now titles frames 1–4 "P_{0,j}, degree j (j+1 nodes)". Frame 5 is titled "P_{0,4} = P_{0,3}, degree 3 (5 nodes)". I read this in full-size frame_005.png of the committed GIF.
- Sympy (`check/verify.py`) gives the exact degrees of P_{0,j}: 0, 1, 2, 3, 3. It also gives `simplify(P04 - P03) = 0`. So "degree 3" and "P_{0,4} = P_{0,3}" are true.
- The title now agrees with index.qmd line 31 ("P_{0,4}=P_{0,3} … same curve") and with the alt text ("the same cubic as P_{0,3}").

### F2 — resolved
- The fixer widened `ylims` from (-1.4, 1.4) to (-3.0, 1.4) for all frames.
- On the plot range [-0.1, π+0.1], the minimum of P_{0,2} is -2.8820916 at x = π+0.1 (mpmath, 30 digits). That is inside -3.0, so the whole quadratic is shown. In full-size frame_003.png the dashed curve reaches about -2.66 at x ≈ 3.14 and ends near -2.88 at the right edge.
- The text also adds "(at x=π, where the quadratic reaches -2.66)".
  - P_{0,2}(π) = 3 − 4√2 = −2.6568542 exactly, so −2.66 is correct.
  - The maximum error on [0, π] is 1.656854249, at x = π.

### F3 — resolved
- The fixer added two sentences after the embed (index.qmd lines 37–38). They say the cos x example is the page's own, and name the module's Examples 1–7 that are not animated. This is what R2-A calls for ("Add one sentence when a whole Mathews example … is left out").
- I checked both claims against the archive:
  - `find …/mathews -iname '*nevil*'` and a grep for "neville" over `a2001/Animations/*.html` and `Interpolation/` turn up no Neville animation GIF.
  - The stripped text of `NevilleAlgorithmMod.html` has exactly Examples 1–7. Example 1 reads "Use recursion to construct the polynomial". Examples 2–7 each read "compute the entries in Aitken's tableau and Neville's tableau for evaluating … at …".

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.31 | "(at x=π, where the quadratic reaches −2.66)" | sympy: P02(π) = 3−4√2 = −2.656854; max error 1.656854 at x = π (20001-point mpmath grid) | correct |
| index.qmd l.31 (unchanged context) | 2.00, 0.90, 1.66, 8.1e-3; P04 = P03 | mpmath maximum errors: 2.0, 0.8988047, 1.6568542, 0.0080677, 0.0080677; P04−P03 ≡ 0 | correct |
| index.qmd l.37 | "No archived animation GIF is available for this topic … the cos x example … is the page's own" | archive search (above) | correct |
| index.qmd l.38 | "Examples 1–7 … recursion (Example 1) … Aitken's and Neville's tableaux at a single evaluation point (Examples 2–7)" | archive example text (above) | correct |
| nevilleaa.jl l.3–4 | header comment "one frame per added node, P_{0,j} for j = 0→4"; "P_{0,4} = P_{0,3} … frame 5 is titled degree 3" | sympy degrees; 5 frames in GIF | correct |
| nevilleaa.jl l.48 | "deg for deg ≤ 3; P_{0,4} = P_{0,3} has degree 3" | sympy | correct |
| nevilleaa.jl l.50–51 | frame titles (degree j, j+1 node(s); frame 5 "P_{0,4} = P_{0,3}, degree 3 (5 nodes)") | sympy degrees; read all 5 frames | correct |
| nevilleaa.jl l.53 | "quadratic's minimum (≈ −2.88 at x = π + 0.1)" | P02(π+0.1) = −2.8820916. P02 is concave down, so this is the minimum over the plot range (its right end), not a stationary minimum. | correct as a plot-range minimum; loose wording in a comment only (nit) |
| nevilleaa.jl l.55 | ylims = (−3.0, 1.4) | covers −2.882 | correct |

### New problems
None.

This rests on:
- the computations above;
- reading full-size frames 1, 3 and 5 and the contact sheet of all 5 frames. Every title is legible and correct, the nodes and curves are right, and the dashed curve is no longer clipped.

Observations I did not count as problems:
- The title now shows the literal string "P_{0,4} = P_{0,3}", braces included. The pre-existing legend label already did this ("P_{0,4}(x)"), so the style is consistent.
- The wider y-range (−3 to 1.4) compresses the frames where the error is small. Their error was invisible before as well, and nothing that was visible before is lost.
- The comment on l.53 says "minimum" for the quadratic's lowest value on the plot range.

### Reproducibility and conventions
- **Reproducibility.** I ran a scratch copy of `nevilleaa.jl` with plain `julia`. Its output is byte-identical to the committed `nevilleaa.gif` (sha256 7751791171…2b3d, `cmp` identical). The committed file is real GIF data (700×500, 5 frames), not an LFS pointer.
- **Pre-fix GIF.** Smudged from LFS. All 5 decoded frame hashes differ from the new ones, as expected from the title and ylims change.
- **Conventions.** All kept:
  - Description comes before Animations.
  - The one case has a `[Julia source](nevilleaa.jl)` link and a GIF embed with descriptive alt text.
  - There are no code blocks (zero ``` in index.qmd).
- **Scope of the fix.** `git diff --stat HEAD` for the page folder touches only index.qmd, nevilleaa.gif and nevilleaa.jl. Other modified files in the working tree belong to other pages' folders (parallel fixes) and are not part of this page's diff.

**Final status:** committed
