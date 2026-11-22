# Fix record: richardson-extrapolation

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/richardson-extrapolation/fix/` (`mod.txt` = stripped module HTML, `check_ex8_10.py`, `up.jl`, `arch/` = upscaled statement images).

## Findings

### F1 — Minor (Fidelity) — fixed (R2-A: one sentence, example not added)
- Reproduced:
  - `sed 's/<[^>]*>//g' n2003/RichardsonExtrapMod.html | sed '/^[[:space:]]*$/d'` (saved as `mod.txt`) gives the section heading "Various Scenarios and Animations for Richardson's Extrapolation and higher derivatives" and Examples 8, 9 and 10. All three say "find numerical approximations to the derivative …, using five points and the central difference formula".
  - The anchors in the module HTML match each example to its solution page: Example 8 → `lnk_9`, Example 9 → `lnk_10`, Example 10 → `lnk_11`. `grep HEIGHT=` on those pages lists six 288×178 graph frames for each example.
  - Statement images (upscaled 4×): gr_172, gr_193 and gr_214 each read `f[x] = e^-x Sin[x]`. gr_173 reads `f'[1.0]`, gr_194 reads `f''[1.0]` and gr_215 reads `f'''[1.0]`.
  - Code images: gr_174, gr_195 and gr_216 each set X = 1.0 and H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}, and each frame plots the stencil points X±H and X±2H.
    - Example 8 (gr_174): d1 = (f(X−2H) − 8f(X−H) + 8f(X+H) − f(X+2H))/(12H), drawn as the line f(X) + d1(x−X).
    - Example 9 (gr_195): d2 = (−f(X−2H) + 16f(X−H) − 30f(X) + 16f(X+H) − f(X+2H))/(12H²), drawn as a parabola.
    - Example 10 (gr_216): d3 = (−f(X−2H) + 2f(X−H) − 2f(X+H) + f(X+2H))/(2H³), drawn as a cubic.
  - Frame gr_175 was viewed: it shows the magenta f, the stencil dots and the blue line through (1, f(1)).
  - The page folder holds only `richexaa.jl/.gif` (D3 and D5 profile on [0, π]) and `richexab.jl/.gif` (log-log error at x0 = 1). No stencil or derivative-polynomial scenario is there, and before this fix nothing on the page mentioned Examples 8–10. The finding holds.
- Change: `index.qmd`. One new paragraph goes directly after the last embed (`richexab.gif`) and before `## Derivation Notes`:
  > The legacy module's Examples 8–10, which use five-point central-difference formulas to approximate the first, second and third derivatives of the same function at a single point for a decreasing sequence of step sizes, are not animated here.
- Check: `/usr/bin/python3 -I check_ex8_10.py` (sympy Taylor expansion, plus mpmath at 40 digits):
  - d1 = f′ − h⁴f⁽⁵⁾/30. d2 = f″ − h⁴f⁽⁶⁾/90. d3 = f‴ + h²f⁽⁵⁾/4 + … So the three formulas approximate the first, second and third derivatives.
  - d1 − (4·D3(h) − D3(2h))/3 = 0. Example 8's formula is therefore the Richardson combination.
  - At X = 1, the errors |d1 − f′|, |d2 − f″| and |d3 − f‴| fall from 6.7e-4, 1.18e-3 and 2.13e-2 at H = 0.5 to 1.5e-10, 1.8e-10 and 1.1e-5 at H = 0.01.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd, new paragraph after the Case 2 embed | "The legacy module's Examples 8–10" | Example headings in `mod.txt`, lines 171–190, and the anchors lnk_9/10/11 → Examples 8, 9 and 10 are the three examples in the "Various Scenarios and Animations" section | yes |
| same | "use five-point central-difference formulas" | Statement text: "using five points and the central difference formula". Code images gr_174, gr_195 and gr_216 use the stencil X±H, X±2H (for d3 the X weight is 0, as in the standard five-point stencil) | yes |
| same | "to approximate the first, second and third derivatives" | gr_173/194/215 read f′[1.0], f″[1.0] and f‴[1.0]. sympy: d1 → f′, d2 → f″, d3 → f‴ (see above) | yes |
| same | "of the same function" | gr_172/193/214 read e^{−x} sin x, the same as the page's Description f(x) = e^{−x} sin(x) | yes |
| same | "at a single point" | `X = 1.0` in gr_174, gr_195 and gr_216 | yes |
| same | "for a decreasing sequence of step sizes" | H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}, strictly decreasing, in all three code images | yes |
| same | "are not animated here" | `ls` page folder → only richexaa.* and richexab.*. Neither draws stencil points or a derivative polynomial (review I-1 and I-2) | yes |

There are no other changed sentences or numbers.

## Scripts and GIFs
- No scripts were changed and no GIFs were regenerated.
- `git status --short -- pages/numerical-methods/richardson-extrapolation` → ` M pages/numerical-methods/richardson-extrapolation/index.qmd` only.

## Legacy archive
- I consulted the archive: `n2003/RichardsonExtrapMod.html` and `n2003/richardsonextrap/RichardsonExtrapMod/{Images,Links}`.
- What it shows:
  - Examples 2(b)–4 correspond to the page's Cases 1 and 2.
  - Examples 8–10 are the module's only animations. They are frame sequences at X = 1 that show five-point estimates of f′, f″ and f‴ together with the stencil points and a local polynomial.
- Under R2-A these are whole examples left out, so the page gets one sentence and does not reproduce them.
- Two things in the archive's own code are recorded here and not put on the page, since the sentence avoids describing the polynomials:
  - Example 9's parabola uses the exact f′(X) with the numerical d2.
  - Example 10's cubic uses exact f′ and f″, and its cubic coefficient is d3/2 instead of the Taylor coefficient d3/6. So the drawn curve is not the Taylor cubic.

## Notes
- Placement follows the Monte Carlo R2-A pattern: the page has no closing legacy note, so the sentence goes right after the last embed. That means it renders under the Case 2 heading, just before "Derivation Notes". The finding's option (b) suggested the Animations introduction, but the pattern says not to put it there. The sentence starts with "The legacy module's" so that it reads as a note about the source.
- The sentence contains no numbers other than example numbers, as the pattern advises.
- The page has no closing source or legacy-note paragraph. I did not add one, since it is out of scope as a pre-existing convention gap.

## Round 2 after check

The checker raised two Minor problems with the F1 sentence. Both were reproduced and fixed. The round-1 sentence after the Case 2 embed has been removed.

### (1) Minor: "Examples 8–10 … are not animated" was false for Example 8's estimate — fixed
- Reproduced: `/usr/bin/python3 -I check_round2.py` (sympy, with f left symbolic):
  - `D5(x,2H) - d1(x,H) = 0` and `D5(x,h) - d1(x,h/2) = 0`. The page's D5, as defined in `richexab.jl` line 12, is Example 8's five-point f′ formula from gr_174, with spacing h/2.
  - Case 2 (`richexab.jl` line 14) uses x0 = 1.0, and Example 8 uses X = 1.0. So Case 2 animates Example 8's estimate.
  - Its stencil spacings h/2 are 0.25, 0.16, 0.1, 0.06, 0.04, 0.025, 0.015, 0.01, 0.005, 0.003, 0.0015 and 0.00075. Of Mathews' H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}, only H = 0.1 and 0.01 also occur, so the list of step sizes is different.
  - No case draws the stencil points or a line, parabola or cubic (review I-1 and I-2), and no case animates f″ or f‴.
- Change: the sentence is replaced by two sentences, as in (2) below.

### (2) Minor: placement read as part of Case 2 — fixed
- Change: the note now sits at the end of the Animations introduction in `index.qmd`, on two source lines directly after "Each animation below compares … interval." and before `### Case 1`, so all three lines render as one paragraph.

### Ledger (round 2)
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd, Animations intro, line 31 | "Case 2 plots the error of the estimate in the legacy module's Example 8" | `richexab.jl` lines 14 and 18: errs5 = \|d5(1,h) − f′(1)\| at x0 = 1.0. Example 8 is at X = 1.0 (gr_174). The formula identity is in the next row. | yes |
| same | "$D_5(x,h)$ is that example's five-point formula for $f'$ with spacing $h/2$" | check_round2.py → `D5(x,h) - d1(x,h/2) = 0` | yes |
| same | "evaluated here over a different list of step sizes" | check_round2.py → Case 2's spacings h/2 match Mathews' H at only 0.1 and 0.01, out of six values | yes |
| index.qmd, line 32 | "Examples 9–10, which use five-point central-difference formulas to approximate the second and third derivatives at the same point" | gr_194 and gr_215 read f″[1.0] and f‴[1.0]. gr_195 and gr_216 set X = 1.0 and use the stencil X±H, X±2H. check_ex8_10.py: d2 → f″ − h⁴f⁽⁶⁾/90 and d3 → f‴ + h²f⁽⁵⁾/4 | yes |
| same | "are not animated here" | Page folder: only richexaa.* (f′ profile) and richexab.* (f′ error). Neither shows f″ or f‴. | yes |
| same | "neither are the pictures that Examples 8–10 draw: the five stencil points with a line, parabola or cubic through the centre point" | gr_174, gr_195 and gr_216 plot points at X, X±H and X±2H (five points). Each g(x) is f(X) plus terms in (x−X), so g(X) = f(X), and the degrees are 1, 2 and 3. Frame gr_175 shows this for Example 8. Neither page script draws stencil points or such a curve. | yes |

- Scripts and GIFs: none changed. `git status --short -- pages/numerical-methods/richardson-extrapolation` → ` M …/index.qmd` only.
- Note: the round-1 placement rule (after the last embed) is superseded by the checker's instruction to put the note in the Animations introduction.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — partly resolved
- The fixer took option (b), as R2-A ("add one sentence when a whole Mathews example is left out") requires. One sentence was added at `index.qmd` line 48. No script or GIF changed (`git diff --quiet HEAD` on richexaa/ab .jl/.gif shows they are unchanged).
- I checked every claim in the sentence against the archive (`n2003/RichardsonExtrapMod.html`, `richardsonextrap/RichardsonExtrapMod/Links/RichardsonExtrapMod_lnk_9/10/11.html`, code images gr_174, gr_195, gr_216 and formula images gr_172/173, 193/194, 214/215):
  - "Examples 8–10": correct. They are the only examples under the heading "Various Scenarios and Animations for Richardson's Extrapolation and higher derivatives". Examples 1–7 are the profile and error material that Cases 1–2 cover.
  - "five-point central-difference formulas": correct. Each example's text says "using five points and the central difference formula". The code uses:
    - d1 = [f(X−2H) − 8f(X−H) + 8f(X+H) − f(X+2H)]/(12H)
    - d2 = [−f(X−2H) + 16f(X−H) − 30f(X) + 16f(X+H) − f(X+2H)]/(12H²)
    - d3 = [−f(X−2H) + 2f(X−H) − 2f(X+H) + f(X+2H)]/(2H³). This one has a zero centre weight but sits on the five-point stencil, and Mathews calls it five-point.
  - "first, second and third derivatives": correct. gr_173 = f′[1.0], gr_194 = f″[1.0], gr_215 = f‴[1.0].
  - "the same function": correct. gr_172/193/214 give f(x) = e^{−x} Sin[x], which is the page's f.
  - "at a single point": correct, X = 1.0.
  - "decreasing sequence of step sizes": correct, H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}.
  - Numerically (mpmath, `check/ident.py`), the three formulas at x = 1 converge to f′(1) = −0.1107937653, f″(1) = −0.3975322207 and f‴(1) = 1.016651972. The errors behave as expected: O(H⁴), O(H⁴) and O(H²).
- **Why not fully resolved.** The sentence describes what Examples 8–10 compute, not what they draw. That makes it partly self-contradictory for Example 8:
  - The page's own D5(x,h) = (4D3(x,h/2) − D3(x,h))/3 is exactly Mathews' Example 8 five-point formula with H = h/2. Sympy confirms the difference simplifies to 0.
  - Case 2 already animates that estimate of f′ at x0 = 1 over a decreasing h sequence, plotted as an error curve.
  - So "five-point … first derivative … at a single point for a decreasing sequence of step sizes … not animated here" is not true of Example 8's computation. What is actually missing is the per-frame picture: the five stencil points X, X ± H, X ± 2H on f, with the tangent line (Ex 8), osculating parabola (Ex 9) or cubic (Ex 10) built from the five-point estimate.
  - For Examples 9 and 10 the sentence is accurate.
- The sentence is also placed inside Case 2's subsection (see New problems).

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:48 | "The legacy module's Examples 8–10" | Module heading and example list (stripped HTML); lnk_9/10/11 are Examples 8, 9, 10 | correct |
| index.qmd:48 | "use five-point central-difference formulas" | Example text and code images gr_174/195/216 | correct |
| index.qmd:48 | "first, second and third derivatives" | gr_173 f′[1.0], gr_194 f″[1.0], gr_215 f‴[1.0] | correct |
| index.qmd:48 | "of the same function" | gr_172/193/214: f = e^{−x} sin x; page line 12 has the same f | correct |
| index.qmd:48 | "at a single point" | X = 1.0 in all three codes | correct |
| index.qmd:48 | "for a decreasing sequence of step sizes" | H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01} | correct |
| index.qmd:48 | "are not animated here" | True for Examples 9–10 and for Example 8's stencil and tangent-line picture. Example 8's five-point f′(1) estimate is the page's D5, which Case 2 animates (sympy identity D5(x,2H) − d1(x,H) = 0) | partly misleading (see N1) |

### New problems
- **N1 (Minor).** The sentence at index.qmd:48 says Example 8 is not animated, but Case 2 animates its quantity.
  - The sentence defines Examples 8–10 by their computation. For Example 8 that computation is the five-point f′ estimate at one point over decreasing step sizes, and it is identical to the page's D5 (D5(x,2H) ≡ Mathews' d1(x,H)). Case 2 animates exactly that at x0 = 1.
  - A reader who knows D5 is the five-point rule (Mathews' module says Richardson "relates the five point rule and the three point rule") will find the sentence inconsistent with Case 2.
  - Suggested wording: say what is not reproduced, namely the stencil-point pictures with the tangent line, osculating parabola and cubic built from the five-point estimates of f′, f″ and f‴ at x = 1. Optionally note that Case 2's D5 is the same five-point estimate of f′(1).
- **N2 (Minor, placement).** The page-level note sits inside Case 2's subsection.
  - Line 48 comes after Case 2's GIF (line 46) and before `## Derivation Notes` (line 50), with no heading in between, so it belongs to `### Case 2 - pointwise convergence at $x_0=1$ on log-log axes`. It reads as a remark about Case 2.
  - It belongs in the Animations introduction (line 30), which is where finding option (b) put it.
  - The same after-last-case placement appears on other pages this round (Hermite line 43, Numerical Differentiation line 42, Cubic Splines, Tangent Parabola, Catenary). The director may want to treat it consistently.
- The intro sentence at line 30 is pre-existing and unchanged: "Each animation below compares … for the legacy test function and interval". Case 2 is at the single point x0 = 1, not over the interval. It was not in the original findings and is not introduced by this fix; I note it only for completeness.

### Reproducibility and conventions
- No script or GIF changed, so there was nothing to regenerate. Both .jl and .gif files are byte-unchanged versus HEAD.
- Conventions are intact:
  - Description (line 10) comes before Animations (line 28).
  - Each case has a `[Julia source]` link and a GIF embed with descriptive alt text.
  - There are no code fences (`grep -c '```'` = 0).
  - Animations sits above Derivation Notes.
- Only `index.qmd` changed in this page folder. Other modified files in the working tree belong to other pages being fixed in parallel, plus untracked r2 fix records; none are attributable to this page's diff.
- No repository files were modified by this check. Scratch: `check/mod.txt`, `check/ident.py`.

### Re-check

The fixer replaced the line-48 note with two sentences at index.qmd lines 31–32. They sit right after the Animations introduction (line 30) and before `### Case 1` (line 34). Only `index.qmd` changed; the scripts and GIFs are still byte-unchanged from HEAD.

### Claims, recomputed
| Claim | Check | Verdict |
|---|---|---|
| "Case 2 plots the error of the estimate in the legacy module's Example 8" | richexab.jl plots \|D5(1,h) − f′(1)\| (alongside the D3 error) at x0 = 1. Example 8 estimates f′[1.0] (gr_173) | correct |
| "D5(x,h) is that example's five-point formula for f′ with spacing h/2" | Sympy: (4D3(x,H) − D3(x,2H))/3 − [f(x−2H) − 8f(x−H) + 8f(x+H) − f(x+2H)]/(12H) simplifies to 0. So D5(x,h) = d1(x, h/2), and gr_174's d1 is that formula | correct |
| "evaluated here over a different list of step sizes" | See the comparison below | correct |
| "Examples 9–10 … five-point central-difference formulas … second and third derivatives" | gr_194 f″[1.0] and gr_215 f‴[1.0]. The d2 and d3 formulas in gr_195/216 use the stencil X, X ± H, X ± 2H; d3 has a zero centre weight, and Mathews calls it five points | correct |
| "at the same point" | Examples 8, 9 and 10 all use X = 1.0, which is also Case 2's x0 | correct (see observation) |
| "are not animated here" (Examples 9–10) | No case on the page computes f″ or f‴ | correct |
| "pictures that Examples 8–10 draw: the five stencil points with a line, parabola or cubic through the centre point" | Code and frames (gr_174/175, gr_195/196, gr_216/217) show five dots, with the centre in magenta. They show g = f(X) + d1(x−X) (Ex 8), g = f(X) + f′(X)(x−X) + d2/2 (x−X)² (Ex 9) and g = … + d3/2 (x−X)³ (Ex 10). Each g passes through (X, f(X)), as the frames show. Neither case on the page draws this | correct |

### Step-size comparison (`check/overlap.py`)
- Mathews uses H = {0.5, 0.2, 0.1, 0.05, 0.02, 0.01}, 6 values.
- Case 2 uses h = {0.5, 0.32, 0.2, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01, 0.006, 0.003, 0.0015}, 12 values. Its stencil spacings h/2 are {0.25, 0.16, 0.1, 0.06, 0.04, 0.025, 0.015, 0.01, 0.005, 0.003, 0.0015, 0.00075}.
- Comparing like with like (Mathews' H against Case 2's spacing h/2): only H = 0.1 (h = 0.2) and H = 0.01 (h = 0.02) appear. H = 0.5, 0.2, 0.05 and 0.02 do not.
- Comparing the numbers nominally (Mathews' H against Case 2's h), 0.5, 0.2, 0.05, 0.02 and 0.01 all appear. But in those cases the spacing is half of Mathews', so these are different stencils.
- Under either reading the lists differ, so "a different list of step sizes" is true.

### Placement
- The two sentences have no blank line between them and line 30, so they render as one paragraph with the Animations introduction.
- That paragraph comes before any `###` case heading. It reads as page-level, and Case 2 is referred to by name.

### Verdicts
- **F1: resolved.** The page now says what the legacy animated scenarios are, which part Case 2 covers, and what is left out. Every claim checks against the archive and computation.
- **N1: resolved.** The note no longer says Example 8 is unanimated. It identifies D5 as Example 8's estimate and separately names what is missing: Examples 9–10 and the stencil pictures.
- **N2: resolved.** The note is now in the Animations introduction, before Case 1.

### New problems
None. This rests on:
- the claim-by-claim table above;
- the sympy identity;
- the step-size comparison;
- viewing gr_175, gr_196 and gr_217;
- the page structure (headings at lines 28, 34 and 42 for Case 2, and 50 for Derivation Notes).

Observation, not a defect: "at the same point" takes its antecedent from Example 8, and x = 1 is first named in Case 2's heading below. It is accurate (X = 1.0 throughout), and the fixer may optionally write "at x = 1". The pre-existing line-30 phrase "and interval" (Case 2 is pointwise) is unchanged and is not part of this fix.

**Final status:** committed
