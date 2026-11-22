# Fix record: aitkens-and-nevilles-interpolation

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/aitkens-and-nevilles-interpolation/fix/`

## Findings

### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 fix/f1.py` (sympy `interpolate` on the exact nodes 0, π/4, π/2, 3π/4, π with y = cos x) prints the degree of the interpolant through the first k nodes: k=1 → 0, k=2 → 1, k=3 → 2, k=4 → 3, **k=5 → 3**. It also prints `P4-P3 simplify: 0` and the 5-node coefficients `[0.14249624500879038, -0.6714977347256207, 0.06657101107115126, 1.0]`. So the n = 5 interpolant has degree 3 = n−2, and "the unique degree-(n−1) polynomial" is contradicted by the page's own case. The general statement holds only as "degree at most n−1".
- Change: `index.qmd` line 12, "evaluates the unique degree-$(n-1)$ polynomial through data points" → "evaluates the unique polynomial of degree at most $n-1$ through data points" (the review's suggested wording).
- Check: the existence-and-uniqueness theorem gives a unique interpolant of degree ≤ n−1 through n points with distinct nodes. f1.py shows the bound is attained for k = 1..4 and not attained for k = 5, so "at most" is the correct quantifier. The new wording matches line 25 ("the interpolant of degree at most $j$") and the frame-5 title "degree 3 (5 nodes)".

### R3-D — placement of the "not animated here" sentence — fixed (moved, list completed)
- Before: the two sentences (no archived GIF, so the cos x example is the page's own; Examples 1–7 not animated) sat after the Case 1 embed, at the end of the page.
- Change: moved into the Animations introduction, directly after "Julia source scripts that generated these animations are linked under each case." and before the Case 1 heading. They are now one paragraph. Re-read in the new position: "the $\cos x$ example animated here" refers to the cos x example introduced in the paragraph just above, so it reads correctly before Case 1. No "above/below" wording needed changing.
- Content check (R2-A / R3-B rule: check the list against every example and exploration of the module):
  - `grep -n -o -E '(Example|Exploration)[^<]{0,20}|NevilleAlgorithmMod_lnk_[0-9]+' n2003/NevilleAlgorithmMod.html` lists Examples 1–7 (solution pages lnk_2…lnk_8; lnk_1 is the module title page). It also lists **two "Exploration" items** (Mod lines 92 and 695). Both link to `NevilleAlgorithmProof.html` ("Scroll down to this exploration"). The old sentence did not mention them.
  - Example statements, read as text and viewed as their statement images (`fix/stmts.png`, built from Mod gr_76–78, 201–204, 291–294, 336–339, 386–390, 495–498, 515–518):
    - Ex 1 constructs P_{0,1,2}[x] for e^x on {0, 1, 2} by recursion.
    - Ex 2 computes tableaux for e^x on 1 + i/4, i = 0..3, at x̂ = 1.6.
    - Ex 3 uses e^x on i = 0..5 at x̂ = 1.8.
    - Ex 4 uses BesselJ[0,x] on 0.5i at x̂ = 1.8.
    - Ex 5 uses e^x at x̂ = 1.8 with the rearranged nodes {1.75, 1.5, 2.0, 1.25, 2.25, 1.0}.
    - Ex 6 and Ex 7 use BesselJ[0,x] on 0.5i at x̂ = 1.8.

    Every one of Examples 2–7 asks to "compute the entries in Aitken's tableau and Neville's tableau for evaluating … at …", which is a single evaluation point. The existing description of Examples 1–7 is therefore correct. None uses cos x, and none is animated on the page: its only case is P_{0,j} curves for cos x.
  - The explorations they link to, on the Theory and Proof page (`NevilleAlgorithmProof.html`), read as text:
    - Proof lnk_5 holds "Exploration 1. Given the six nodes … Investigate …" and "Exploration 2. Given the ten nodes … Investigate …".
    - Proof lnk_9 works through "Nevill's Method" and "Aitken's Method" as chains of "Define … using … and …".

    The Proof page's images are not in the archive (`find … -name 'NevilleAlgorithmProof_gr_1*.gif'` returns nothing), so I could not read their exact functions or nodes. The added clause therefore names them only as "the explorations it links to on its Theory and Proof page", without describing them. Neither is animated on this page.
  - The "no archived animation GIF" claim: `find a2001/Animations -iname '*nev*' -o -iname '*aitk*'` and `grep -ril -E 'neville|aitken' a2001/Animations` both return nothing. `Interpolation/` holds Chebyshev, FourierSeries, gifs, Lagrange, Pade, series, Series.
- New text: "No archived animation GIF is available for this topic in the current snapshot, so the $\cos x$ example animated here is the page's own, not one of the examples in Mathews' module. The module's Examples 1–7, which build an interpolating polynomial by recursion (Example 1) and fill in Aitken's and Neville's tableaux at a single evaluation point (Examples 2–7), and the explorations it links to on its Theory and Proof page, are not animated here."

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.12 | "the unique polynomial of degree at most $n-1$" | `python3 fix/f1.py` → degrees 0,1,2,3,3 for k = 1..5 nodes; `P4-P3 simplify: 0` | yes |
| Animations intro (new l.29), sentence 1 | "No archived animation GIF is available for this topic in the current snapshot" | `find`/`grep -ril` over `a2001/Animations` for neville/aitken → no hits | yes |
| same | "the $\cos x$ example … is the page's own, not one of the examples in Mathews' module" | statement images `fix/stmts.png`: Examples 1–7 use e^x or BesselJ[0,x], never cos | yes |
| same, sentence 2 | "Examples 1–7 … by recursion (Example 1) … tableaux at a single evaluation point (Examples 2–7)" | Mod lnk_2 text "Use recursion to construct the polynomial"; lnk_3–lnk_8 text "compute the entries in Aitken's tableau and Neville's tableau for evaluating … at …"; statement images show one x̂ each (1.6, 1.8×5) | yes |
| same | "and the explorations it links to on its Theory and Proof page" | Mod.html lines 92 and 695: two "Exploration" links to `/n2003/NevilleAlgorithmProof.html`; Proof lnk_5 (Explorations 1, 2) and lnk_9 (Neville/Aitken exploration) | yes |
| same | "are not animated here" | page has one case (`nevilleaa.jl`: P_{0,j} for cos x, j = 0..4); none of the examples or explorations is animated | yes |
| Case 1 Behavior (l.33), checker follow-up | "builds the interpolating polynomial of degree at most $n$ by combining two polynomials of degree at most $n-1$" (was "the degree-$n$ … two polynomials of degree $n-1$") | `python3 fix/f1b.py` (sympy degree of every Neville tableau entry for these nodes) → nominal vs actual: P_{0,4} 4→3, P_{1,3} 2→1, P_{2,2} 0→zero polynomial (cos π/2 = 0); all others equal nominal. Both the result and the combined inputs can fall short of the nominal degree, so "at most" is needed in both places | yes |
| placement | paragraph now before `### Case 1` | `git diff -- index.qmd` shows it removed from the end of the page and inserted after the "Julia source scripts…" line | yes |

## Scripts and GIFs
- No script changed and no GIF regenerated. Both changes are page text only.
- The round-3 review records `nevilleaa.jl` reproducing the committed GIF byte for byte, and its frame titles ("degree 3 (5 nodes)" on frame 5) agree with the corrected Description.
- `git status --short -- pages/numerical-methods/aitkens-and-nevilles-interpolation` → ` M …/index.qmd` (only).

## Legacy archive
- Consulted: `n2003/NevilleAlgorithmMod.html`, `nevillealgorithm/NevilleAlgorithmMod/Links/*_lnk_1..8.html` and the module's statement images, plus `n2003/NevilleAlgorithmProof.html` and `nevillealgorithm/NevilleAlgorithmProof/Links/*_lnk_1,5,8,9.html` as text. `a2001/Animations/` was searched.
- What it showed:
  - Mathews has no animation for this topic.
  - Examples 1–7 are a recursive construction for e^x (Example 1) and single-point Aitken/Neville tableaux for e^x or J_0 (Examples 2–7).
  - The module also links two Explorations on the Theory and Proof page, whose images are missing from the snapshot.
- Difference from the page: the page animates its own cos x example and says so. That is a disclosed departure that no finding asks to change, so the case is kept.
- The Theory and Proof page states uniqueness for "a unique polynomial of degree [image]". The image is missing, so its exact degree wording could not be read. The page's corrected wording rests on f1.py, not on the archive.

## Notes
- The Behavior paragraph (l.33) used the same exact-degree wording that F1 corrected ("the degree-$n$ interpolating polynomial … two polynomials of degree $n-1$"). At the checker's request it now says "of degree at most" in both places; see the ledger row and `fix/f1b.py`.
- Proof lnk_1 also contains an "Exploration." heading, inside the existence proof (Lagrange/Newton subroutines). It is not linked from the Mod page, so the page sentence does not count it. Its images are also missing.

### Director note

The checker found the same exact-degree wording in the unchanged Case 1 Behavior sentence (pre-existing, Minor). Sent back to the fixer, who changed it to 'degree at most n' / 'degree at most n-1' with a sympy check (P_{0,4} has degree 3, P_{1,3} degree 1). The director confirmed the diff: only those words changed.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: Description line 12 now reads "evaluates the unique polynomial of degree at most $n-1$ through data points $(x_i,y_i)$", which is the wording the finding asked for. sympy `interpolate` on the exact nodes 0, pi/4, pi/2, 3pi/4, pi for cos x gives `degree(P_{0,4}) = 3` (x^3 coefficient 32(sqrt2-1)/(3 pi^3)), and `simplify(P_{0,4} - P_{0,3}) = 0`. So the 5-node interpolant has degree 3 < n-1 = 4. "At most n-1" is true and matches the case intro ("degree at most $j$"), the frame-5 title and the alt text. No script or GIF was touched (git status of the folder shows only index.qmd modified), so there was nothing to regenerate.
- Residual, not part of F1 and not introduced by the fix: the unchanged Behavior sentence "builds the degree-$n$ interpolating polynomial by combining two polynomials of degree $n-1$" still states an exact degree, and its $n$ means degree, while in the Description $n$ is the number of points. The same paragraph then says P_{0,4} = P_{0,3} is the cubic, so the effect is small. See New problems, N1.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Description, l.12 | "unique polynomial of degree at most $n-1$" | Uniqueness and the degree bound for n distinct nodes are standard. sympy: the page's own 5-node example has degree 3 | correct |
| Animations intro (moved from end of page, R3-D) | "No archived animation GIF is available for this topic in the current snapshot" | `find`/`grep -ril neville\|aitken` over `a2001/` (Animations and everything else): no hits | correct |
| same | "the $\cos x$ example animated here is the page's own, not one of the examples in Mathews' module" | Module examples use e^x with nodes {0,1,2} (Ex 1), e^x with nodes 1+i/4 (Ex 2, 3, 5), and J0(x) with nodes 0.5 i (Ex 4, 6, 7). None uses cos x (Mod images gr_76/77, 201/202, 291/292, 336/337, 386/387, 495/496, 515/516) | correct |
| same | "The module's Examples 1–7" | NevilleAlgorithmMod.html has exactly Examples 1 to 7, with Solution links lnk_2 to lnk_8 | correct |
| same | "build an interpolating polynomial by recursion (Example 1)" | Ex 1: "Use recursion to construct the polynomial P_{0,1,2}[x]" | correct |
| same | "fill in Aitken's and Neville's tableaux at a single evaluation point (Examples 2–7)" | Each of Ex 2 to 7: "compute the entries in Aitken's tableau and Neville's tableau for evaluating f[x] at x̂ = 1.6 (Ex 2) / 1.8 (Ex 3 to 7)" (images gr_204, 294, 339, 389, 498, 518) | correct |
| same (new in this round) | "and the explorations it links to on its Theory and Proof page" | The module has two "Exploration" links, both to /n2003/NevilleAlgorithmProof.html ("Scroll down to this exploration"), after the Selected Interpolation definition and after Table 2. On the Proof page these are lnk_5 (Explorations 1 and 2: investigating selected interpolants on six and ten nodes) and lnk_9 (the Neville/Aitken tableau exploration). The page animates neither | correct |
| Placement | sentence now in the Animations intro, before Case 1 | Matches R3-D and the Improved Newton pattern | correct |
| Removed text at end of page | the two old sentences | Their content is fully carried into the new intro paragraph. Nothing lost | correct |

### New problems
- N1 (Minor, pre-existing, not introduced by the fix): Case 1 Behavior, l.33: "builds the degree-$n$ interpolating polynomial by combining two polynomials of degree $n-1$". This is the same exact-degree wording as F1 in another sentence. Here $n$ is a degree, whereas in the Description $n$ is the number of points, and the page's own P_{0,4} has degree 3, not 4. A possible fix is "the interpolant of degree at most $n$ ... two interpolants of degree at most $n-1$".
- No new problems were introduced by the diff. This rests on the ledger above: every changed or added clause was checked against the archive module, the Theory and Proof page and its link targets, and sympy.

### Reproducibility and conventions
- No script or GIF changed (git status shows only index.qmd modified in the folder; `git diff --stat` shows 3 insertions and 4 deletions in index.qmd). So the reproducibility run is not applicable, and the committed nevilleaa.gif is the same as at HEAD.
- Conventions hold: Description before Animations, one case with a `[Julia source](nevilleaa.jl)` link and a GIF embed with descriptive alt text, no code blocks.
- Outside the page folder: the diff of this page touches only its own index.qmd. Other numerical-methods pages are modified in the working tree by the parallel round-3 fixes. Nothing outside `pages/numerical-methods/` is modified.

**Final status:** committed
