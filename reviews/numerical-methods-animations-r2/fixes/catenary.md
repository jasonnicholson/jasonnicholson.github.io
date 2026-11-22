# Fix record: catenary

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/catenary/fix/`
- `check.py`: independent checks (`/usr/bin/python3 -I check.py`)
- `upscale.jl`, `stack.jl`, `archive/*.png`: archive equation and graph images, upscaled 3x and stacked for reading

## Findings

### F1 — Minor — fixed
- Reproduced: in $y=c\cosh(x/c)$, $c=H/w$. sympy: $y=(H/w)\cosh(wx/H)$ satisfies the cable equilibrium equation $H y''=w\sqrt{1+y'^2}$ (residual simplifies to 0). As $c$ rises the curve gets flatter, not saggier. The rise above the lowest point is $R(x,c)=c(\cosh(x/c)-1)$, and $\partial R/\partial c = g(u)=\cosh u-1-u\sinh u$ with $u=x/c$ (sympy difference 0). $g(0)=0$ and $g'(u)=-u\cosh u<0$ for $u>0$; $g$ is even, so $\partial R/\partial c<0$ for every $x\ne0$. Numerically, on the script's grid (25 c values, 500 x values) the rise falls strictly from frame to frame at every $x\ne0$: `True`. Sag over half-span 4: 744.74 at $c=0.5$ and 2.1723 at $c=4$. This confirms the review's corrected figures (744.7 and 2.17). Its "745.24 → 6.17" are $y_{cat}(4)$ values, not sag. So calling $c$ the "sag parameter" while it increases gives the wrong idea.
- Change: `index.qmd` line 12, "as the sag parameter $c$ increases" → "as the catenary parameter $c$ (the ratio of horizontal tension to weight per unit length; larger $c$ means a tauter, flatter cable) increases". This is the review's suggested wording.
- Check: `check.py` output lines 1–5 (ODE residual 0; dR/dc identity; g' = −u cosh u; grid monotonicity True). The Behavior paragraph already says large c = "nearly taut", small c = "slack", which is consistent.

### F2 — Minor — fixed (R2-A one-sentence note)
- Reproduced: the archive `CatenaryMod.html` (text stripped) has Explorations 1 "Approximated by a parabola", 2 "Arc Length" and 3 "Catenary Fit", plus Examples 1–2 with solution pages `Links/CatenaryMod_lnk_5.html` and `_lnk_6.html`. The page has one script (`catenaryaa.jl`), one GIF and one case: the parabola sweep. None of Explorations 2–3 or Examples 1–2 is on it.
- Change: under R2-A (add one sentence, do not add the example), two source lines go after the last embed, since the page has no legacy note. The first names what the page reproduces, because the page had no antecedent for "the module". The second is the pattern sentence: "The module's arc-length and catenary-fit explorations (Explorations 2–3) and its Examples 1–2, which solve numerically for the $c$ of the catenary through the origin and two points at equal height on either side of the $y$-axis, compute its arc length with Simpson's rule, and compare the catenary with the parabola through the same three points, are not animated here."
- Check: see ledger. Each phrase was matched to archive images, and the numbers behind them were recomputed independently (no numbers go on the page).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| l.12 | "catenary parameter $c$" | archive gr_2 / main.png: Mathews writes $y=c\cosh(x/c)-c$, $c>0$; he gives c no other name | yes |
| l.12 | "the ratio of horizontal tension to weight per unit length" | `check.py`: $H y''-w\sqrt{1+y'^2}$ with $y=(H/w)\cosh(wx/H)$ → `0`, so $c=H/w$ | yes |
| l.12 | "larger $c$ means a tauter, flatter cable" | tauter: larger $c=H/w$ means more horizontal tension per unit weight (definition above). Flatter: $\partial R/\partial c=\cosh u-1-u\sinh u<0$ for all $x\ne0$ (sympy: $g(0)=0$, $g'=-u\cosh u$); grid check over all 25 frames → `True`; vertex curvature $1/c$ goes from 2 to 0.25 | yes |
| l.12 | "0.5 to 4" (unchanged numbers) | script `range(0.5, 4.0, length=25)` | yes |
| l.24 | "based on Exploration 1 ("Approximated by a parabola") of Mathews' Catenary module" | `sed` text of CatenaryMod.html: "Exploration 1. Approximated by a parabola"; main.png: $f=c\cosh(x/c)-c\approx x^2/(2!c)$. The page's pair $c\cosh(x/c)$, $x^2/(2c)+c$ is the same pair moved up by $c$ (the review's sympy check that the parabola is the series truncation also holds). Mathews has no sweep over $c$ ("based on", not "reproduces") | yes |
| l.25 | "arc-length and catenary-fit explorations (Explorations 2–3)" | CatenaryMod.html text: "Exploration 2. Arc Length", "Exploration 3. Catenary Fit". Images gr_47–49: arc length $=c\sinh(a/c)$ on [0,a]. gr_72–90: fit through (1,1) by FindRoot, c→0.618759. `check.py`: anderson root → 0.6187592277742557 | yes |
| l.25 | "Examples 1–2" | `grep -n 'Example [0-9]' CatenaryMod.html` → Example 1 (l.134), Example 2 (l.142), only these two | yes |
| l.25 | "solve numerically for the $c$ of the catenary through the origin and two points at equal height on either side of the $y$-axis" | lnk_5 text "goes through the origin and also passes through the two points … a = 10 and b = 6". gr_91: `pts = {{-a, b}, {0, 0}, {a, b}}`. ex1.png: "Using Newton's method Obtain c = 9.18894", FindRoot. `check.py`: findroot → 9.188941402221273; Newton from 10 → 10.0, 9.09955, 9.18785, 9.18894 (matches archive gr_99) | yes |
| l.25 | "compute its arc length with Simpson's rule" | lnk_5 text "The length of the catenary can be approximated numerically by using Simpson's rule"; ex1b.png shows the `Simpson[a0_, b0_, m0_]` code. Correct value (`check.py`): $2c\sinh(10/c)$ = 24.1882 on [−10,10] | yes |
| l.25 | "compare the catenary with the parabola through the same three points" | lnk_6 text "Find the equation of the parabola that goes through the origin and the point … Compare the parabola solution with the catenary solution". ex2a.png: d = 3/50; plot passes through (−10,6), (0,0), (10,6). ex2b/ex2c: lengths and maximum height difference. `check.py`: parabola length 24.08694 (closed form agrees); max \|cat−par\| 0.142418 at x = 7.10530, = 1.70902 in. (archive: 0.142418, 7.1053, 1.70902) | yes |
| l.25 | "are not animated here" | `ls pages/numerical-methods/catenary` → catenaryaa.jl, catenaryaa.gif, index.qmd only; the one case is the parabola sweep | yes |

## Scripts and GIFs
- No script changed and no GIF regenerated. Both findings are text-only. The GIF matches the text: the review found the committed GIF byte-identical to a regeneration, and F1 only renames $c$.
- `git status --short -- pages/numerical-methods/catenary` → ` M pages/numerical-methods/catenary/index.qmd`

## Legacy archive
- Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/CatenaryMod.html` and `catenary/CatenaryMod/Links/*_lnk_1..6.html` (text), plus images gr_1–2, 25–29, 47–49, 72–110, 129–175 (upscaled in scratch).
- What it shows:
  - Mathews uses $y=c\cosh(x/c)-c$ (lowest point at the origin). His Exploration 1 says the first Maclaurin term is $x^2/(2c)$. He has no animation and no sweep over $c$ for this topic.
  - Exploration 2 gives the arc length $c\sinh(a/c)$. Exploration 3 fits c through (1,1): 0.618759.
  - Example 1 solves for c through (0,0) and (±10,6) by Newton's method and FindRoot: 9.18894. It then gets the length by Simpson's rule.
  - Example 2 fits the parabola $3x^2/50$ and compares lengths and the maximum height difference (0.142418 ft ≈ 1.709 in. at x ≈ 7.105).
- Differences from the page:
  - The page's curves are Mathews' pair moved up by $c$ (lowest point at $(0,c)$). This is equivalent and correct, so it is kept.
  - Archive error, not carried onto the page: ex2b.png prints "The length of the catenary is 24.0869", the same as the parabola. The `clength` variable was overwritten by the parabola's Simpson result. The catenary's true length on [−10,10] is $2c\sinh(10/c)=24.1882$ (`check.py`). The page has no numbers from these examples.
  - In Example 2 the catenary lies *below* the fitted parabola on (0,10) (`check.py`: f−p from −0.1424 to −5.6e−7). That parabola differs from the page's Maclaurin parabola, so this does not conflict with the page's "never lies below the parabola" claim, which is about $x^2/(2c)+c$ (review ledger #16–17).

## Notes
- R2-A says "add one sentence". I added two lines: the pattern sentence, plus a short sentence before it naming what the page reproduces. Without that, "the module's" would have no antecedent, since the page only has a generic "Source inspiration" line. The pattern (Monte Carlo record) does the same with its reworded sentence before the note.
- The page has no `## Description` section (pre-existing convention gap noted by the reviewer). Not added, as out of scope.
- No other files touched.

### Director note

Checker's note (pre-existing, not a finding): the page has no `## Description` section.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: line 12 no longer says "sag parameter". It now reads "the catenary parameter $c$ (the ratio of horizontal tension to weight per unit length; larger $c$ means a tauter, flatter cable)".
- I checked each claim independently with sympy (`check/chk.py`):
  - $c = H/w$: $y=(H/w)\cosh(xw/H)$ satisfies the hanging-cable equation $H y'' = w\sqrt{1+y'^2}$ exactly (residual 0).
  - "Flatter": the vertex curvature of $c\cosh(x/c)$ is $1/c$, so it decreases as $c$ grows.
  - "Tauter / less sag": the sag on the fixed half-span 4 is $c\cosh(4/c)-c$. It is 744.74, 26.31, 5.52 and 2.17 at c = 0.5, 1, 2 and 4. In general $d(\text{sag})/dc = \cosh u - u\sinh u - 1$ with $u=a/c$. That expression is 0 at $u=0$ and has derivative $-u\cosh u<0$, so the sag strictly decreases in $c$.
- The GIF is unchanged. I extracted all 25 frames and viewed the contact sheet. They show the curve flattening from c=0.5 to c=4.0, which matches the new wording and the Behavior paragraph's "nearly taut" (large c) and "slack" (small c).

### F2 — resolved
- Evidence: two sentences were added after the Case 1 embed (lines 24–25). They name Exploration 1 as the basis and say that Explorations 2–3 and Examples 1–2 are not animated. This is the "add one sentence" option that decision R2-A requires for Catenary. Not adding the example therefore follows the owner's decision and is not a defect.
- I checked every content claim against the archive:
  - In `CatenaryMod.html`, Exploration 1 is "Approximated by a parabola", Exploration 2 is "Arc Length" and Exploration 3 is "Catenary Fit". "Arc-length and catenary-fit explorations (Explorations 2–3)" is correct.
  - `Links/CatenaryMod_lnk_5.html` (Example 1) finds "the catenary that goes through the origin and also passes through the two points" with a=10 and b=6. `gr_91.gif` shows `pts = {{-a,b},{0,0},{a,b}}` and `gr_92.gif` plots (−10,6), (0,0), (10,6). So "two points at equal height on either side of the $y$-axis" is correct.
  - The archive says c must be found numerically ("we must resort to using a numerical approximation for c"). My mpmath findroot gives c = 9.18894140222.
  - Example 1 says "The length of the catenary can be approximated numerically by using Simpson's rule". My Simpson's rule with n=100 gives 12.0941017380, against the exact $c\sinh(10/c)$ = 12.0941017371. "Compute its arc length with Simpson's rule" is correct.
  - Example 2 (`lnk_6`) finds the parabola through the origin and (a,b), which is even and so also passes through (−a,b). It then compares lengths and heights. The maximum height difference I get is 0.14242 ft = 1.709 in at x = 7.105, matching the archive's "1.7 inches". "Compare the catenary with the parabola through the same three points" is correct.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.12 | "catenary parameter $c$" | Standard name for c in $c\cosh(x/c)$ | OK |
| index.qmd l.12 | "ratio of horizontal tension to weight per unit length" | sympy: $c=H/w$ makes the ODE residual 0 | OK |
| index.qmd l.12 | "larger $c$ means a tauter, flatter cable" | Vertex curvature is 1/c; sag $c\cosh(a/c)-c$ is strictly decreasing in c (sign proof plus values 744.74 → 2.17) | OK |
| index.qmd l.12 | "increases from 0.5 to 4" (unchanged number) | Script: `range(0.5, 4.0, length=25)`; GIF titles run from c = 0.5 to c = 4.0 | OK |
| index.qmd l.24 | "based on Exploration 1 ("Approximated by a parabola")" | Archive heading text | OK |
| index.qmd l.25 | "arc-length and catenary-fit explorations (Explorations 2–3)" | Archive headings "Exploration 2. Arc Length", "Exploration 3. Catenary Fit" | OK |
| index.qmd l.25 | "Examples 1–2 … solve numerically for the $c$ … through the origin and two points at equal height on either side of the $y$-axis" | lnk_5, gr_91, gr_92; c = 9.18894 by findroot | OK |
| index.qmd l.25 | "compute its arc length with Simpson's rule" | lnk_5 text; Simpson's rule gives 12.09410 | OK |
| index.qmd l.25 | "compare the catenary with the parabola through the same three points" | lnk_6; maximum difference 1.709 in, matching the archive's 1.7 | OK |

### New problems
None. This rests on three things:
- I checked every changed sentence above against both the mathematics and the archive.
- The diff touches only `index.qmd`. `catenaryaa.jl` and `catenaryaa.gif` are byte-identical to HEAD (`git diff --quiet HEAD` passes).
- No heading, alt text, embed or source link was altered.

The new paragraph's catenary "through the origin" is Mathews' shifted form $c\cosh(x/c)-c$, while the page's animated curve $c\cosh(x/c)$ has its vertex at (0,c). The sentence does not claim they are the same curve, so it is not misleading.

### Reproducibility and conventions
- Reproducibility: no script or GIF changed in this fix, so there is nothing to regenerate. The committed GIF is unchanged vs HEAD, and I decoded its 25 frames to view the contact sheet.
- Conventions:
  - Each case still has a source link (`[Julia source](catenaryaa.jl)`) and an embed with descriptive alt text.
  - The page has no code blocks.
  - Only `index.qmd` in the page folder is modified. The working tree has changes in other page folders, but those are not part of this page's diff.
- Pre-existing (not introduced by this fix): the page has no `## Description` section before `## Animations`, which the conventions file requires. HEAD also lacks it. It was not among this round's findings.

**Final status:** committed
