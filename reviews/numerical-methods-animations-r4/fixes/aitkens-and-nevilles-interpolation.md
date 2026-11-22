# Fix record: aitkens-and-nevilles-interpolation

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/aitkens-and-nevilles-interpolation/fix/` (`archive_plots.py`, `degrees.py`).

## Findings

### F1 — Minor (Fidelity) — fixed

- **Reproduced.** I read `n2003/NevilleAlgorithmMod.html` as text and mapped each solution link to its example: lnk_2 = Ex 1, lnk_3 = Ex 2, lnk_4 = Ex 3, lnk_5 = Ex 4, lnk_6 = Ex 5, lnk_7 = Ex 6, lnk_8 = Ex 7. lnk_1 is the title page. I listed every image with HEIGHT ≥ 100 in each solution page. The Mathematica plots are the 288×178 images.
  - **Ex 3** (lnk_4): $e^x$, nodes $1+i/4$, $\hat x=1.8$ (gr_295). gr_306/gr_307 plot f, P0, P01, P012 and P0123 on [1, 2.25]. gr_318/gr_319 plot the Aitken Q's.
  - **Ex 4** (lnk_5): $J_0$, nodes $0.5i$ (gr_340). gr_351/gr_352 plot f and P0 … P01234 on [0, 3.5]. gr_363/gr_364 plot the Aitken Q's.
  - **Ex 5** (lnk_6): $e^x$, nodes {1.75, 2, 1.5, 2.25, 1.25, 1} (gr_391). gr_405/gr_406 plot f, P0, P01 and P012. gr_420/gr_421 plot the Q's.
  - **Ex 2, 6, 7:** no plot images (only tableaux and code).
  - **The review's description is incomplete in two ways.**
    - Example 1 (lnk_2: $e^x$ at nodes {0, 1, 2}, gr_76/gr_77) also plots. gr_83 shows f. gr_91, gr_97 and gr_103 show f with P01, P02 and P12. gr_109, gr_115 and gr_121 show f with the quadratic built three ways, together with the two lines it combines.
    - The top degree plotted differs by example: Ex 3 reaches degree 3, Ex 4 degree 4 and Ex 5 degree 2. The review gave $P_{0,1,2,3}$ for all three.
  - **My reading of the plots matches computed values.** `archive_plots.py` evaluates the interpolants at the right-hand edge of each window:
    - Ex 3 at x = 2.25: P01 = 6.579, P012 = 8.771, P0123 = 9.394. The curves in gr_307 end at about 6.6, 8.8 and 9.4.
    - Ex 4 at x = 3.5: P0 = 1, P01 = 0.569, P01234 = −0.184, and f = −0.380, matching gr_352.
    - Ex 5: P0 = 5.755 (horizontal line), P01(1) = 0.851, P012(1) = 3.020, matching gr_406.
  - **So the finding holds.** The old sentence described Examples 2–7 only as tableau work and did not mention any of the plots.
- **Change.** `index.qmd`, Animations intro (line 29; the paragraph stays where R3-D puts it).
  - Before: "The module's Examples 1–7, which build an interpolating polynomial by recursion (Example 1) and fill in Aitken's and Neville's tableaux at a single evaluation point (Examples 2–7), and the explorations … are not animated here."
  - After: "The module's Examples 1–7 are not animated here. Example 1 builds a quadratic through three nodes by recursion and plots the function with each linear interpolant and the quadratic. Examples 2–7 fill in Aitken's and Neville's tableaux at a single evaluation point, and Examples 3–5 also plot the function with the successive interpolants through the first one, two, three, … of their nodes (up to degree 3, 4 and 2 respectively), the kind of picture this animation builds frame by frame, drawn there as one static plot. The explorations the module links to on its Theory and Proof page are not animated here either."
  - The first sentence of the paragraph ("No archived animation GIF … the page's own …") is unchanged; see the archive section for why it still holds.
  - I added no case. R2-A says to add a sentence for a left-out example and not to add the example itself.
- **Check.** The archive images listed above, the `archive_plots.py` output, and `degrees.py`, which confirms each top plotted interpolant has exactly the stated degree (nonzero leading coefficient). `git diff` shows only this paragraph changed.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.29 | "Examples 1–7 are not animated here" | The page has a single case, cos x at nodes 0..π (nevilleaa.jl). The module's examples use e^x and J0 (gr_77, gr_291/295, gr_340, gr_391, gr_205, gr_519). | yes |
| index.qmd l.29 | Ex 1 "builds a quadratic through three nodes by recursion" | gr_76 gives {x0=0, x1=1, x2=2}. lnk_2 text: "Use recursion to construct the polynomial". `degrees.py` → leading coefficient 1.4762462 = (e−1)²/2 ≠ 0, so the polynomial is a true quadratic. | yes |
| index.qmd l.29 | Ex 1 "plots the function with each linear interpolant and the quadratic" | gr_90/91 show P01, gr_96/97 P02 and gr_102/103 P12. gr_108/109, gr_114/115 and gr_120/121 show the quadratic (three constructions). | yes |
| index.qmd l.29 | "Examples 2–7 fill in Aitken's and Neville's tableaux at a single evaluation point" | Each of the six statements in NevilleAlgorithmMod.html reads "compute the entries in Aitken's tableau and Neville's tableau for evaluating … at x̂". | yes |
| index.qmd l.29 | "Examples 3–5 also plot … successive interpolants through the first one, two, three, … of their nodes" | gr_306 (P0..P0123), gr_351 (P0..P01234) and gr_405 (P0..P012) are the Plot commands. Ex 2, 6 and 7 have no 288×178 plot images (HEIGHT ≥ 100 listing). | yes |
| index.qmd l.29 | "up to degree 3, 4 and 2 respectively" | Node counts in the Plot commands are 4, 5 and 3. `degrees.py` → leading coefficients 0.66434676, 0.0092579884 and 2.8923185, all nonzero. | yes |
| index.qmd l.29 | "the kind of picture this animation builds frame by frame, drawn there as one static plot" | The animation's frames show f, P_{0,j} and the nodes used (review claim A3/G3). The archive plots overlay f and P0…P0..k in one static image. | yes |
| index.qmd l.29 | "explorations the module links to on its Theory and Proof page" | The module's two "Exploration" links point to /n2003/NevilleAlgorithmProof.html. That page is titled "Theory and Proof" and has Exploration sections at stripped-text lines 48 and 185. | yes |

## Scripts and GIFs

- No script changed and no GIF regenerated. The finding is about text only.
- `git status --short -- pages/numerical-methods/aitkens-and-nevilles-interpolation` → ` M .../index.qmd` only.

## Legacy archive

- **Consulted:** `n2003/NevilleAlgorithmMod.html` and all eight solution pages, `NevilleAlgorithmProof.html`, and `a2001/Animations/`.
- **No animation exists for this topic.** `find` for neville/aitken outside n2003 found nothing. `a2001/Animations/Interpolation/` holds only Chebyshev, FourierSeries, Lagrange, Pade and series. So the page's "no archived animation GIF" statement still holds.
- **What the module has instead.** Examples 1 and 3–5 have static Mathematica plots of successive interpolants (details under F1). The page keeps its own cos x example, says so, and now describes those plots accurately.
- **Archive oddities, not on the page:**
  - Ex 4's Aitken plot (gr_363) uses $Q_{0,1,2,3,5}$, not $Q_{0,1,2,3,4}$.
  - Ex 3's node markers show only x0–x2, although P0123 is plotted.

## Notes

- **The review missed Example 1's plots.** It listed only Examples 3–5, and the corrected sentence covers Example 1 too (per R3-B: check against every example).
- **The review's suggested wording was not used as written.** It said "$P_0,\dots,P_{0,1,2,3}$" for all three examples, which is wrong for Ex 4 (degree 4) and Ex 5 (degree 2).
- **Legend subscripts left alone.** The review's "observed but not counted" note (literal `P_{0,2}` in the GR legend) is not a finding, so it was not touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the old sentence ("fill in Aitken's and Neville's tableaux at a single evaluation point (Examples 2–7)", with nothing about plots) is gone. The new sentence says Example 1 plots the function with each linear interpolant and the quadratic, and that Examples 3–5 also plot the function with the successive interpolants (degrees up to 3, 4 and 2). I checked it against all seven example pages of the archive module (`NevilleAlgorithmMod_lnk_2.html` … `_lnk_8.html`; `_lnk_1` is only a title page with no images). I read the HTML as text with image positions inline, converted every plot-sized image (288x178) and every plot-command cell to PNG, and looked at them.
  - Example 1 (lnk_2): $f=e^x$, nodes $\{0,1,2\}$ (gr_76/77). Plots: $f$ alone (gr_83); $f$ with $P_{0,1}$, $P_{0,2}$ and $P_{1,2}$, each on its own plot (gr_90/91, gr_96/97, gr_102/103); and the quadratic built by recursion three ways, 1(a)–(c), each plotted with $f$ and its two linear parents (gr_108/109, gr_114/115, gr_120/121). The new sentence is true.
  - Example 2 (lnk_3): $e^x$, nodes $1+i/4$ ($i=0..3$), $\hat x=1.6$ (gr_205). Both tableaux are given in full detail. There are no plot images; gr_290 is a text table comparing $P$ and $Q$. The sentence is true, and it correctly leaves Example 2 out of the plotting group.
  - Example 3 (lnk_4): $e^x$, nodes $1+i/4$ ($i=0..5$), $\hat x=1.8$. The Neville plot gr_306/307 shows $f,P_0,P_{0,1},P_{0,1,2},P_{0,1,2,3}$ on $[1,2.25]$. The Aitken plot gr_318/319 shows $f,Q_0,\dots,Q_{0,1,2,3}$. Maximum degree 3. True.
  - Example 4 (lnk_5): $J_0$, nodes $0.5i$ ($i=0..5$), $\hat x=1.8$ (gr_340). The Neville plot gr_351/352 shows $P_0,\dots,P_{0,1,2,3,4}$, maximum degree 4. True.
  - Example 5 (lnk_6): $e^x$, nodes reordered to $\{1.75,2.0,1.5,2.25,1.25,1.0\}$, $\hat x=1.8$ (gr_391). Plots gr_405/406 ($P$) and gr_420/421 ($Q$) go up to $P_{0,1,2}$ and $Q_{0,1,2}$, maximum degree 2. These are the first three nodes in the module's own (reordered) node list. True.
  - Examples 6 and 7 (lnk_7, lnk_8): both tableaux only, with no plot images in the HTML. Example 7 is $J_0$ at 1.8 (gr_521/522 tableau). Example 6's images gr_499–504 are missing from the snapshot, but its HTML has only the input cell and two tableau cells, sized like Example 7's (769x279/649x245). True.
  - The animation itself is unchanged and still shows one $P_{0,j}$ per frame for $\cos x$. "The kind of picture this animation builds frame by frame, drawn there as one static plot" is a fair comparison: the archive overlays the same successive interpolants in one figure.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.29 | "No archived animation GIF is available for this topic in the current snapshot" (kept) | `find a2001/Animations -iname '*nev*' -o -iname '*aitk*'`, plus a grep for neville/aitken in Animations*.html and Interpolation/: nothing | correct |
| l.29 | "The module's Examples 1–7 are not animated here" | 7 examples (lnk_2..8), and the page animates only $\cos x$ | correct |
| l.29 | "Example 1 builds a quadratic through three nodes by recursion" | gr_76: nodes $x_0=0,x_1=1,x_2=2$; the quadratic is built by recursion in 1(a)–(c) | correct |
| l.29 | "plots the function with each linear interpolant and the quadratic" | gr_91/97/103 ($f$ with $P_{0,1}$, $P_{0,2}$, $P_{1,2}$); gr_109/115/121 ($f$ with the quadratic) | correct |
| l.29 | "Examples 2–7 fill in Aitken's and Neville's tableaux at a single evaluation point" | every example statement says "compute the entries in Aitken's tableau and Neville's tableau for evaluating at $\hat x$"; $\hat x$ = 1.6 (Ex2) and 1.8 (Ex3, 4, 5, 7) | correct |
| l.29 | "Examples 3–5 also plot … successive interpolants through the first one, two, three, … of their nodes" | gr_306/318 (Ex3), gr_351/363 (Ex4), gr_405/420 (Ex5); Examples 2, 6 and 7 have no such plot | correct (see the observation on Ex4's Aitken plot) |
| l.29 | "up to degree 3, 4 and 2 respectively" | Ex3 $P_{0,1,2,3}$ (3); Ex4 $P_{0,\dots,4}$ (4); Ex5 $P_{0,1,2}$ (2) | correct |
| l.29 | "the kind of picture this animation builds frame by frame, drawn there as one static plot" | frames 1–5 of nevilleaa.gif show $P_{0,0}$…$P_{0,4}$; the archive overlays them in one figure | correct |
| l.29 | "The explorations the module links to on its Theory and Proof page are not animated here either" | Mod page "Exploration … Scroll down to this exploration" links to NevilleAlgorithmProof.html, whose explorations are lnk_1/5/8/9 | correct |

### New problems
None counted. This rests on checking each clause of the rewritten sentence against all seven archive examples (above).

Observation, not counted: Example 4's second (Aitken) plot, gr_363/364, draws $Q_{0,1,2,3,5}$ as its degree-4 curve, not $Q_{0,1,2,3,4}$. The surrounding archive text names $Q_{0,1,2,3,4}$, so this looks like a slip in Mathews' code. I confirmed it numerically. The x pixels are calibrated from the node dots (32.5 px at 0, 70 px per unit) and the y pixels from the axis and the $y=1$ dot. At $x\approx3.08$ and $3.36$, gr_364's last blue curve reads −0.243 and −0.265. The interpolant on $\{0,.5,1,1.5,2.5\}$ gives −0.248 and −0.265; the one on $\{0,\dots,2\}$ gives −0.216 and −0.213, which is what gr_352 reads (−0.217). So one of Example 4's two plots ends with a curve that is not through the "first five" nodes. The page's sentence still holds for each example, since each has a plot (the Neville one) that matches it exactly. "Drawn there as one static plot" is also loose wording: Examples 3–5 each draw the sequence twice, once for $P$ and once for $Q$, each time as one static figure. A reader is not misled by either point.

### Reproducibility and conventions
- The fix changes only index.qmd (one paragraph). nevilleaa.jl and nevilleaa.gif are unchanged from HEAD (`git diff --quiet HEAD` on both), so there was nothing to regenerate. I extracted the existing GIF's 5 frames: titles $P_{0,0}$…$P_{0,4}=P_{0,3}$, which agree with the page.
- Conventions kept: Description comes before Animations; Case 1 has a Julia source link and the GIF embed with descriptive alt text; there are no code blocks.
- Outside the page folder: the fix diff covers only this page folder. The other modified paths in the working tree (other numerical-methods pages and reviews/) belong to other pages' fixes in this round, not to this one.

**Final status:** committed
