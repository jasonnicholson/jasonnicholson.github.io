# Fix record: catenary

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/catenary/fix/` (`check.py`, `check2.py`, `conv.jl`, `arch/*.png`).

## Findings

### F1 — Minor — fixed
- Reproduced: the page called "Approximated by a parabola" Exploration 1, and called arc length and catenary fit Explorations 2–3. In `CatenaryMod.html`, the anchors on lines 34/53/68 link to `lnk_2`/`lnk_3`/`lnk_4`. Stripping each linked page with `sed 's/<[^>]*>//g'` gives:
  - `lnk_2` = "Background … Exploration 1. Do the above four catenaries look similar? Are they the same?";
  - `lnk_3` = "Approximated by a parabola … Exploration 2. Find the Maclaurin series for …";
  - `lnk_4` = "Arc Length … Exploration 3.";
  - `lnk_5`/`lnk_6` = Examples 1/2.

  The "Catenary Fit" section on the main page (lines 61–106) has no exploration link of its own. So the parabola material is Exploration 2, arc length is Exploration 3, and catenary fit is an unnumbered section. The finding holds.
- Change: `index.qmd`, the old lines 24–25 after the embed were removed and replaced in the Animations introduction (see R3-D):
  - "This animation is based on Exploration 1 ("Approximated by a parabola")…" → "Case 1 follows Exploration 2 ("Approximated by a parabola") of Mathews' Catenary module, which finds the Maclaurin series of the catenary."
  - "arc-length and catenary-fit explorations (Explorations 2–3)" → "its arc-length Exploration 3, its catenary-fit section".
- Check: the archive text above. Exploration 2's own text is "Find the Maclaurin series for … The general term in the series is … Summing the first six terms". The function image `gr_30` is missing from the archive, but the section's lead-in (`gr_25`, f(x) = c cosh(x/c), and `gr_29`, f ≈ x²/(2! c)) shows that the function is the catenary. sympy `series(c*cosh(x/c)-c, x, 0, 10)` → `x**2/(2*c) + x**4/(24*c**3) + x**6/(720*c**5) + x**8/(40320*c**7)`, which is consistent.

### F2 — Minor — fixed
- Reproduced: the old not-animated list named arc length, catenary fit and Examples 1–2, and omitted Exploration 1. `lnk_2` and images `gr_3` (code) and `gr_12`/`gr_13` (code and graph) were viewed. They plot `F[x_,c_] = c Cosh[x/c] - c` for c = d/2, d, 2d, 3d with d = 0.618759, on windows x ∈ [−ka, ka] with a dot at (±k, F(±k, kd)), all on one graph. The text concludes that the shape "is preserved … the curve is merely magnified … or reduced by the scale factor". The finding holds.
- Change:
  1. `index.qmd` intro: the list now begins "The module's Exploration 1 (catenaries with different $c$ are scaled copies of one shape), …".
  2. Behavior paragraph: one sentence appended (the finding's optional suggestion): "Every frame shows the same pair of shapes: the curves for parameter $c$ are the $c=1$ curves $y=\cosh x$ and $y=x^2/2+1$ scaled by the factor $c$ about the origin, so the flattening as $c$ grows comes from viewing ever larger copies through a fixed window."
- Check:
  - `/usr/bin/python3 -I check.py`:
    - `F(kx,kc)-kF(x,c) = 0` (Mathews' form);
    - scaling (X, cosh X) → (cX, c cosh X) lies on y = c cosh(x/c): residual `0`;
    - scaling (X, X²/2+1) → (cX, c(X²/2+1)) lies on y = x²/(2c)+c: residual `0`;
    - d = 0.618759227774256 solves c cosh(1/c) − c = 1, so Mathews' constant is the catenary through the origin and (1,1).
  - `check2.py`:
    - the script's c values strictly increase, 0.5 → 4.0 (`True`), which supports "ever larger copies";
    - apex y'' = 1/c for both curves, so they flatten as c grows;
    - numeric residual of the scaled c = 1 curves over all 25 script c values: 5.5e-12.

### R3-D — placement move — done
- Change: the source sentence pair moved from after the Case 1 embed to the Animations introduction, after "Julia source scripts … linked under each case." and before the Case 1 heading. "This animation is based on" became "Case 1 follows", so that it reads correctly before Case 1. The content changes are those of F1/F2 above.
- Check: `sed -n '14,22p' index.qmd` shows the intro paragraph, then the two-sentence source paragraph, then `### Case 1`. Nothing remains after the embed except the "(Planned)" stub.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| intro, line 16 | "Case 1 follows Exploration 2 ("Approximated by a parabola") of Mathews' Catenary module" | `sed` strip of `Links/CatenaryMod_lnk_3.html` → "Approximated by a parabola … Exploration 2." | yes |
| intro, line 16 | "which finds the Maclaurin series of the catenary" | lnk_3 text "Find the Maclaurin series for …; the general term …; summing the first six terms". The function image gr_30 is missing. The lead-in gr_25 is f(x) = c cosh(x/c). sympy series is consistent | yes |
| intro, line 17 | "Exploration 1 (catenaries with different $c$ are scaled copies of one shape)" | lnk_2 text and gr_3/gr_12/gr_13. sympy `F(kx,kc)-kF(x,c)` → 0 | yes |
| intro, line 17 | "its arc-length Exploration 3" | lnk_4 → "Arc Length … Exploration 3." | yes |
| intro, line 17 | "its catenary-fit section" (no number) | main page lines 61–106: section "Catenary Fit", with no `lnk_` anchor after it (the anchors are only lines 16/34/53/68/137/146) | yes |
| intro, line 17 | "Examples 1–2 (which solve numerically for the c of the catenary through the origin and two points at equal height on either side of the y-axis, compute its arc length with Simpson's rule, and compare the catenary with the parabola through the same three points)" | text unchanged, only moved. Re-checked: gr_91 `pts = {{-a,b},{0,0},{a,b}}` with a = 10, b = 6 (gr_92 plot). lnk_5: "length … approximated numerically by using Simpson's rule". lnk_6: parabola through the origin and (10,6) (gr_129). It is even, so it also passes through (−10,6). "Compare the parabola solution with the catenary solution" | yes |
| intro, line 17 | "are not animated here" | the page has one case (the catenary against its two-term Maclaurin parabola). It has no scaled-family plot, no arc length, no fit and no Example 1–2 points. `CatenaryProof.html` and `CatenaryProg.html` are empty stubs (title only), and the Conclusion is history | yes |
| Behavior, line 21 | "the curves for parameter c are the c=1 curves y=cosh x and y=x²/2+1 scaled by the factor c about the origin" | check.py symbolic residuals 0, 0. check2.py numeric max residual over the script's 25 c values: 5.5e-12 | yes |
| Behavior, line 21 | "the flattening as c grows" | check2.py: apex y'' = 1/c for both curves, decreasing in c | yes |
| Behavior, line 21 | "ever larger copies" | check2.py: `np.diff(c_values) > 0` for all, 0.5 → 4.0 | yes |
| Behavior, line 21 | "through a fixed window" | script `xlims=(-4.0, 4.0), ylims=(0.0, 12.0)` in every frame | yes |

No numbers were added. The existing Behavior numbers (0.73, 1.94, 3.39) were not touched. The round-3 review confirmed them (claim ledger rows 10–12).

## Scripts and GIFs
- Scripts changed: none. GIFs regenerated: none. Only page text changed, so the committed `catenaryaa.gif` stands. The round-3 inventory found it regenerates byte-identically.
- Frames: not re-extracted, since the GIF is unchanged. The new Behavior sentence describes the curve formulas and window, which are checked against the script source above.
- `git status --short -- pages/numerical-methods/catenary` → ` M pages/numerical-methods/catenary/index.qmd`.

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/CatenaryMod.html`, `catenary/CatenaryMod/Links/CatenaryMod_lnk_1..6.html`, `CatenaryProof.html`, `CatenaryProg.html`. The images viewed were gr_3, gr_12, gr_13, gr_25, gr_29, gr_91, gr_92 and gr_129.

The archive shows:
- Background with Exploration 1 (the family c = d/2, d, 2d, 3d are scaled copies);
- "Approximated by a parabola" with Exploration 2 (the Maclaurin series);
- "Arc Length" with Exploration 3;
- an unnumbered "Catenary Fit" section;
- Examples 1 and 2 (the catenary and the parabola through (±10, 6) and the origin, with their lengths);
- a historical Conclusion.

Images gr_30, gr_31, gr_36, gr_37 and gr_41 (the Exploration 2 function, series and plots) are missing from the archive. Mathews writes the curves with the lowest point at the origin (c cosh(x/c) − c and x²/(2c)). The page shifts both up by c, which leaves their difference unchanged. That equivalent formulation was kept, as the review said it is not a finding.

## Notes
- The page has no `## Description` section, which the conventions require. No finding names this, so it was not added (pre-existing convention gap).
- The Behavior sentence for F2 was the finding's optional suggestion. It was added because it is short, fully checked, and addresses the point F2 raises about this animation.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The wrong numbering is gone. The page (index.qmd line 16) now says: "Case 1 follows Exploration 2 ("Approximated by a parabola") of Mathews' Catenary module, which finds the Maclaurin series of the catenary." Line 17 calls arc length "Exploration 3" and the fit a "catenary-fit section".
- Checked against the archive, `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/CatenaryMod.html`:
  - The main-page anchors at lines 34, 53 and 68 ("Exploration 1/2/3") link to `CatenaryMod_lnk_2/3/4.html`.
  - lnk_2 is "Background … Exploration 1. Do the above four catenaries look similar? … the curve is merely magnified by the scale factor".
  - lnk_3 is "Approximated by a parabola … Exploration 2. Find the Maclaurin series".
  - lnk_4 is "Arc Length … Exploration 3."
  - The "Catenary Fit" section (line 73) has no exploration link. Examples 1–2 (lines 134 and 142) link to lnk_5 and lnk_6.
- So the new numbering is correct. The script draws the catenary and its two-term Maclaurin parabola, which is the "Approximated by a parabola" section, so "follows Exploration 2" is accurate.

### F2 — resolved
- Exploration 1 is now in the not-animated list: "Exploration 1 (catenaries with different $c$ are scaled copies of one shape)". That matches lnk_2's conclusion (the shape is preserved; the curve is magnified or reduced by a scale factor).
- The optional Behavior sentence was also added, and it is true (see the ledger).

### R3-D placement — done
- The sentence was removed from below the Case 1 embed (old lines 24–25).
- It now sits in the Animations introduction (lines 16–17), after the "Julia source scripts…" line and before `### Case 1`.
- It is phrased as a statement about the source ("Case 1 follows … The module's … are not animated here."), the same form as on Improved Newton (line 30) and Richardson (lines 31–32).
- R3-B (check against every example in the module): the module has exactly two Examples (1 and 2), and the sentence names both.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.16 | "Case 1 follows Exploration 2 ("Approximated by a parabola")" | Main-page anchor l.53 leads to lnk_3, headed "Approximated by a parabola … Exploration 2" | correct |
| l.16 | "which finds the Maclaurin series of the catenary" | lnk_3: "Exploration 2. Find the Maclaurin series … general term … summing the first six terms" | correct |
| l.17 | "Exploration 1 (catenaries with different $c$ are scaled copies of one shape)" | lnk_2: "Do the above four catenaries look similar? … the curve is merely magnified by the scale factor … or reduced" | correct |
| l.17 | "its arc-length Exploration 3" | lnk_4: "Arc Length … Exploration 3." | correct |
| l.17 | "its catenary-fit section" | Main page l.73, "Catenary Fit", has no exploration link of its own | correct |
| l.17 | Examples 1–2: "solve numerically for the $c$ of the catenary through the origin and two points at equal height on either side of the $y$-axis" | gr_91: `pts = {{-a,b},{0,0},{a,b}}`, a=10, b=6. gr_94: f[x] = c Cosh[x/c] − c, Newton / FindRoot on f[a]==b | correct |
| l.17 | "compute its arc length with Simpson's rule" | lnk_5: "The length of the catenary can be approximated numerically by using Simpson's rule." | correct |
| l.17 | "compare the catenary with the parabola through the same three points" | lnk_6: "Find the equation of the parabola that goes through the origin and the point … Compare the parabola solution with the catenary solution" (it also compares lengths and the maximum height difference) | correct (a fair summary) |
| l.17 | "are not animated here" | Script `catenaryaa.jl` draws only the c-sweep of catenary vs Maclaurin parabola | correct |
| l.21 (new sentence) | "the curves for parameter $c$ are the $c=1$ curves $y=\cosh x$ and $y=x^2/2+1$ scaled by the factor $c$ about the origin" | sympy: the image of Y=cosh X under (X,Y)→(cX,cY) is y=c·cosh(x/c), difference 0. The image of Y=X²/2+1 is y=x²/(2c)+c, difference 0. The point (0,1) maps to (0,c) | correct |
| l.21 | "Every frame shows the same pair of shapes … flattening as $c$ grows comes from viewing ever larger copies through a fixed window" | The script fixes xlims (−4,4) and ylims (0,12) in every frame. The 25-frame contact sheet shows the fixed window and the curves flattening from c=0.5 to 4.0 | correct |
| l.21 (unchanged clauses in the edited line) | gap passes 0.1 at \|x\|≈0.73 (c=0.5) | mpmath root of 0.5cosh(2x) − x² − 0.5 = 0.1 gives 0.72712 | correct |
| l.21 | catenary leaves the top at \|x\|≈1.94 | acosh(24)/2 = 1.93538 | correct |
| l.21 | parabola leaves the top at \|x\|≈3.39 | √11.5 = 3.39116 | correct |
| l.21 | difference $x^4/(24c^3)+x^6/(720c^5)+\cdots$, positive for x≠0 | sympy series of c·cosh(x/c) − x²/(2c) − c. Every term x^{2n}/((2n)! c^{2n−1}) with n≥2 is positive | correct |

### New problems
None. This rests on the following:
- Every added clause was checked against the archive pages (lnk_2 to lnk_6 and the main page) or by symbolic and high-precision computation, as in the ledger.
- The diff removes only the old misnumbered sentence, so no other content was lost.
- The GIF and script are unchanged, so no picture could have been broken.

One gap predates this fix and is outside its scope: the page has no `## Description` section, which `animation-page.agent.md` (lines 12 and 205) requires. The HEAD version has none either.

### Reproducibility and conventions
- Changed files: only `pages/numerical-methods/catenary/index.qmd` (+4/−4 lines).
  - `catenaryaa.jl` and `catenaryaa.gif` are identical to HEAD (`git diff --quiet` passed), so there was no script to re-run and no byte comparison to make.
  - Frames were still extracted (25 frames, contact sheet viewed) to check the new Behavior sentence against the picture.
- The page keeps one `[Julia source](catenaryaa.jl)` link, one embed with descriptive alt text, and no code blocks.
- The "not animated" sentence is in the Animations intro, per R3-D.
- The Description-before-Animations convention is not met, but that was already the case at HEAD (see above).
- Files outside the page folder:
  - This page's diff touches nothing else.
  - The working tree has other modified pages, which belong to the other round-3 fixers working in parallel. I cannot attribute them to this fix, and the catenary fix diff lists none of them.

**Final status:** committed
