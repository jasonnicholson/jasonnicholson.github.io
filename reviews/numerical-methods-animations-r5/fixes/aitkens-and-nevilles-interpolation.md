# Fix record: aitkens-and-nevilles-interpolation

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r5fix/aitkens-and-nevilles-interpolation/fix/` (`indep.py`, `inst_bb.jl`, `gap.py`, `frames_bb/`, `nevilleaa.orig.gif`).

## Findings

### F1 — Minor (Fidelity) — fixed (per decision R5-D)
- Reproduced: the page animated only its own cos x example and gave "no archived GIF" as the reason. The archive module `NevilleAlgorithmMod` has Example 3 (`Links/NevilleAlgorithmMod_lnk_4.html`). Images `gr_292` and `gr_295` give f(x) = e^x, nodes x_i = 1 + i/4 for i = 0..5, and x̂ = 1.8. Its Neville tableau (`gr_298`) ends at 6.049643, against the true value 6.049647. Its diagonal sequence and errors (`gr_303`) are {2.71828, 5.18888, 5.96076, 6.04845, 6.0497, 6.04964} and {3.33137, 0.86077, 0.0888869, 0.00119311, −0.0000522557, 4.3387e-6}. Its static plot (`gr_306`/`gr_307`) shows f, P_0, P_01, P_012 and P_0123 on [1, 2.25]. All 518 GIFs under `n2003/nevillealgorithm/` have one frame each (PIL `n_frames` check). `a2001/Animations/Interpolation/` holds only Chebyshev, FourierSeries, Lagrange, Pade and Series. So the "no archived GIF" statement holds, but it does not explain why no worked example was used, which confirms the finding.
- Change (R5-D: keep the cos x case, add Example 3 as a new case):
  - New `nevillebb.jl` reuses `nevilleaa.jl`'s `neville_table` and `interp_degree` unchanged and keeps the same style (700×500, fps 1, `@__DIR__`).
    - It plots e^x on [0.95, 2.30], with x-ticks at the nodes, for j = 0..5.
    - It draws the x̂ = 1.8 line and marks P_{0,j}(1.8) with a green diamond. The legend shows P_{0,j}(1.8) to 6 decimals and f(1.8) − P_{0,j}(1.8) to 3 significant figures (`%.3g`).
    - It adds `using Printf` (standard library).
  - New `nevillebb.gif` has 6 frames.
  - `index.qmd`:
    - Description: "The animation below uses" → "The animations below use".
    - The Animations intro sentence now describes both cases.
    - The archive paragraph is rewritten. It now says that no archived GIF exists and the module has only static examples, that Case 2 animates Example 3, that Case 1 is the page's own example and why it was chosen, and that Examples 1, 2 and 4–7 are not animated. The existing descriptions of Examples 1–7 are kept.
    - Added the Case 2 heading, Behavior paragraph, source link, alt text and embed.
- Check:
  - The script's Neville tableau at 1.8 (`inst_bb.jl`) reproduces Mathews' printed tableau `gr_298` entry by entry to his 6 significant figures.
  - An independent 40-digit mpmath Lagrange evaluation (`indep.py`) gives the same P_{0,j}(1.8) values and errors to at least 10 digits.
  - The leading coefficients f[x_0..x_j] are nonzero for all j, so the degree is exactly j. For j = 5 the coefficient is 0.0428745, which equals Mathews' 0.8 × 0.0535931 (`gr_335`).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Description, last sentence | "The animations below use Neville's scheme." | Both scripts call `neville_table` (the D3 recurrence) | yes |
| Animations intro | Case 1: cos x at 5 nodes, j=0..4; Case 2: e^x at 6 nodes x_i = 1+i/4, j=0..5 | `nevilleaa.jl` loop `0:4`; `nevillebb.jl` `xs = [1.0 + i/4 for i in 0:5]`, loop `0:5`; 6 frames (giftools → "6 frames") | yes |
| Archive paragraph | "No archived animation GIF … ; Mathews' module has only static examples." | PIL: 518 GIFs in `n2003/nevillealgorithm`, 0 multi-frame; no Neville/Aitken in `a2001/Animations` | yes |
| Archive paragraph | "Case 2 animates the module's Example 3: e^x at x_i = 1 + i/4, i=0..5, evaluated at x̂ = 1.8" | lnk_4 images `gr_292`, `gr_295` | yes |
| Archive paragraph | Case 1 "chosen to show that adding a node can increase the error and that symmetric nodes can make P_{0,4}=P_{0,3}" | r5 review A7/A10 (max error 0.90→1.66 from j=1 to 2) and A15 (sympy P4−P3 = 0); these are the Case 1 Behavior's own verified claims | yes |
| Archive paragraph | "The module's other examples, 1, 2 and 4–7, are not animated here"; Examples 3–5 plot successive interpolants "up to degree 3, 4 and 2" | Module has Examples 1–7 (lnk_2..lnk_8). Plot code: Ex 3 `gr_306` plots P_0..P_{0,1,2,3}; Ex 4 `gr_351` up to P_{0,1,2,3,4}; Ex 5 `gr_405` up to P_{0,1,2} | yes |
| Archive paragraph | "Case 2 carries Example 3's picture on to degree 5" | `gr_306` stops at degree 3; nevillebb frames 1–6 go to P_{0,5} | yes |
| Case 2 heading | "Mathews' Example 3: P_{0,0} through P_{0,5} for e^x at x̂ = 1.8" | as above | yes |
| Behavior | nodes 1, 1.25, …, 2.25 | 1 + i/4, i = 0..5 | yes |
| Behavior | P_{0,j}(1.8) = 2.718282, 5.188877, 5.960761, 6.048454, 6.049700, 6.049643 | `julia inst_bb.jl` → 2.7182818285, 5.1888774413, 5.9607605845, 6.0484543571, 6.0496997201, 6.0496431257; `indep.py` (mpmath) the same | yes |
| Behavior | "match the diagonal of Mathews' Neville tableau" | `gr_303`: 2.71828, 5.18888, 5.96076, 6.04845, 6.0497, 6.04964, equal to the values above rounded to 6 significant figures; final 6.049643 = `gr_298` | yes |
| Behavior | e^{1.8} = 6.049647 | mpmath 6.04964746441 | yes |
| Behavior | errors 3.33, 0.861, 0.0889, 1.19e-3, −5.23e-5, 4.34e-6; magnitude falls at each step; negative only at j=4 | `indep.py`: 3.3313656, 0.86077002, 0.08888688, 0.0011931074, −5.2255661e-5, 4.3386992e-6 (strictly decreasing magnitude; sign + + + + − +) | yes |
| Behavior | largest error on [1, 2.25] falls at each step, 6.77 at j=0 to 3.2e-5 at j=5 | `indep.py` (scipy barycentric, 200001 pts): 6.7695, 2.9091, 0.71630, 0.093473, 5.0244e-3, 3.1820e-5; `inst_bb.jl` the same | yes |
| Behavior | From j=4 on, indistinguishable at plot scale; at j=3 they part only toward the right edge | `gap.py`: max gap on [0.95, 2.3] is ≤ 7.8e-3 for j=4 and ≤ 7.1e-5 for j=5. The frame scale is about 50 px per y unit (y = 2 to 10 over pixels 453 to 55), so the gap is under 0.4 px. For j=3 the gap is ≤ 0.018 (under 1 px) on [0.95, 2.0] and rises to 0.038, 0.071 and 0.12 (up to about 6 px) on [2.0, 2.1], [2.1, 2.2] and [2.2, 2.3]. Frame 4 viewed: the curves visibly part only near x ≳ 2.1 | yes |
| Alt text Case 2 | nodes 1…2.25, degree 0 to P_{0,5}, marker at 1.8 approaching 6.049647, ending at 6.049643 | frames 1–6 viewed; values as above | yes |
| GIF title (frames) | "Neville's Algorithm for e^x — P_{0,j}, degree j (j+1 nodes)" | degree exactly j: leading coefficients 2.71828, 3.08824, 1.75428, 0.664347, 0.188691, 0.0428745 (nonzero) | yes |
| GIF legend | "f(x) = e^x,  f(1.8) = 6.049647"; "P_{0,j}(1.8) = …, f(1.8) − P_{0,j}(1.8) = …" | frames show 2.718282/3.33, 5.188877/0.861, 5.960761/0.0889, 6.048454/0.00119, 6.049700/−5.23e-05, 6.049643/4.34e-06, matching `indep.py` | yes |

## Scripts and GIFs
- Scripts: `nevillebb.jl` is new. `nevilleaa.jl` is unchanged.
- GIFs: `nevillebb.gif` is new (6 frames). `nevilleaa.gif` was not regenerated; its md5 is `e3cf6917…` both before and after.
- Frames viewed at full size: 1, 3, 4, 5 and 6, plus the contact sheet of all 6. Checks:
  - The red dashed P_{0,j} passes through the black nodes used.
  - The green diamond sits on the x̂ = 1.8 line at P_{0,j}(1.8).
  - The legend numbers match the computations.
  - The plotted P_{0,j} stays within [2.5639, 9.9741], inside ylims (2, 10.5), so nothing is clipped.
  - The title degree is correct.
- `git status --short -- pages/numerical-methods/aitkens-and-nevilles-interpolation`:
  ```
   M index.qmd
  ?? nevillebb.gif
  ?? nevillebb.jl
  ```

## Legacy archive
Consulted: `n2003/nevillealgorithm/NevilleAlgorithmMod/` (Links lnk_1–lnk_8, Images).
- Example 3 is e^x at nodes 1 + i/4 (i = 0..5) with x̂ = 1.8. Mathews computes Neville's and Aitken's tableaux, both ending at 6.049643 against 6.049647. His static plot shows P_0 through P_{0,1,2,3} on [1, 2.25]; it marks only x_0, x_1 and x_2.
- The new case reproduces his tableau values exactly. It differs from his plot in three ways:
  - it goes to degree 5, the last entry of his tableau, instead of stopping at degree 3;
  - it marks all the nodes used in each frame;
  - it marks x̂ and the value there.
- No step in Mathews' example contradicts the computation.
- No animated GIF exists for this topic: all 518 module GIFs are single-frame, and `a2001/Animations` has no Neville or Aitken material.

## Notes
- R5-D was followed as written: the cos x case was kept and Example 3 added as Case 2 with its own script, GIF, heading, Behavior, alt text, source link and embed.
- The Example 5 reordering, which the review lists as optional, was not animated. Example 5 stays in the "not animated" list.
- The page has no pre-existing convention gaps that need action.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: Following R5-D, the cos x case is kept unchanged and a new Case 2 animates Mathews' Example 3. I read Example 3 in the archive myself (`n2003/nevillealgorithm/NevilleAlgorithmMod/Links/NevilleAlgorithmMod_lnk_4.html`; images gr_295, gr_298, gr_306–308, gr_310). It uses f[x] = e^x, x_i = 1.0 + i/4 for i = 0..5, and x̂ = 1.8. Neville's tableau (gr_298) has diagonal 2.71828, 5.18888, 5.96076, 6.04845, 6.0497, 6.04964, then "f[1.8] ≈ 6.049643, true 6.049647". The plot (gr_307) shows P_0 to P_{0,1,2,3} on [1, 2.25]. Aitken's tableau (gr_310) ends at the same 6.04964.
- The script `nevillebb.jl` uses exactly these function, nodes and evaluation point, and reuses Case 1's `neville_table` and `interp_degree` routines unchanged. I recomputed every value at 40 digits with mpmath, using the Lagrange form so the check does not depend on Neville's recursion. P_{0,j}(1.8) = 2.71828183, 5.18887744, 5.96076058, 6.04845436, 6.04969972, 6.04964313. Every entry of my full 6×6 tableau agrees with Mathews' gr_298 to the digits he prints, for example 5.6713, 6.00919, 6.04297, 6.05001, 6.05257, 6.08149, 5.71011, 6.04436, 6.04928 and 6.04961.
- The archive sentence was rewritten. "No archived animation GIF" is still true: nothing named Neville or Aitken exists under `a2001/Animations`, including `Interpolation/`. The new sentence names Example 3 as animated and 1, 2 and 4–7 as not. The module has exactly Examples 1–7. It no longer presents the missing GIF as the reason for the cos example, and the stated reason (an added node can raise the error, and symmetric nodes give P_{0,4} = P_{0,3}) is true (see ledger).
- `nevilleaa.jl` is unchanged from HEAD. `nevilleaa.gif` is unchanged: its sha256 77517911… equals the oid in the HEAD LFS pointer, and `git hash-object` equals the HEAD blob.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Description, last sentence | "The animations below use Neville's scheme" | Both scripts call `neville_table` with the Neville recursion | OK |
| Animations intro | Case 1: cos x, 5 nodes 0..π, j = 0..4; Case 2: e^x, 6 nodes x_i = 1 + i/4, j = 0..5 | Matches nevilleaa.jl and nevillebb.jl (`xs = [1.0 + i/4 for i in 0:5]`, `deg in 0:5`) | OK |
| Archive paragraph | "No archived animation GIF … only static examples" | No Neville or Aitken GIF in a2001/Animations; the module's examples are static Mathematica output | OK |
| Archive paragraph | Example 3 = e^x, x_i = 1 + i/4, i = 0..5, x̂ = 1.8 | gr_295 | OK |
| Archive paragraph | Case 1 "chosen to show adding a node can increase the error and symmetric nodes can make P_{0,4} = P_{0,3}" | Max error on [0, π] by j: 2.00, 0.899, 1.657, 8.07e-3, 8.07e-3, so the error rises at j = 2. P_{0,3}(π) = −1.000000. Antisymmetric data on symmetric nodes give an interpolant odd about π/2, so its degree is at most 3 | OK |
| Archive paragraph | "other examples, 1, 2 and 4–7, are not animated" | The module has Examples 1–7 | OK |
| Archive paragraph | "Case 2 carries Example 3's picture on to degree 5" | gr_306/307 stop at P_{0,1,2,3}; the GIF goes to P_{0,5} | OK |
| Case 2 heading | "Mathews' Example 3: P_{0,0} through P_{0,5} for e^x at x̂ = 1.8" | Six frames, deg 0..5 | OK |
| Behavior | nodes 1, 1.25, …, 2.25 | 1 + i/4 for i = 0..5 | OK |
| Behavior | "each frame marks P_{0,j}(1.8), the top-row entry of Neville's tableau" | Green diamond at (1.8, P[1, deg+1]). With the page's P_{i,j} indexing, i = 0 is the top row. In Mathews' layout the same entry sits on the diagonal, and the sentence says so | OK |
| Behavior | 2.718282, 5.188877, 5.960761, 6.048454, 6.049700, 6.049643 | mpmath: 2.71828183, 5.18887744, 5.96076058, 6.04845436, 6.04969972, 6.04964313 | OK |
| Behavior | "match the diagonal of Mathews' Neville tableau" | gr_298: 2.71828, 5.18888, 5.96076, 6.04845, 6.0497, 6.04964 / 6.049643 | OK |
| Behavior | e^{1.8} = 6.049647 | 6.04964746 | OK |
| Behavior | errors 3.33, 0.861, 0.0889, 1.19×10⁻³, −5.23×10⁻⁵, 4.34×10⁻⁶; size falls each step; negative only at j = 4 | 3.33137, 0.860770, 0.0888869, 1.19311e-3, −5.22557e-5, 4.3387e-6 | OK |
| Behavior | max error on [1, 2.25] falls each step, 6.77 at j = 0 to 3.2×10⁻⁵ at j = 5 | Over 20001 points: 6.769, 2.909, 0.7163, 0.09347, 5.024e-3, 3.182e-5 (j = 5 maximum at x ≈ 2.167) | OK |
| Behavior | "From j = 4 on, indistinguishable at plot scale; at j = 3 they part only toward the right edge" | Max error is 0.005 at j = 4 and 0.093 at j = 3, with y range 8.5 over about 400 px, so about 0.2 px and 4 px. Frames 5–6 show the curves overlapping; frame 4 separates only for x ≳ 2.1 | OK |
| Source link | `[Julia source](nevillebb.jl)` | File exists, and the link precedes the embed as in Case 1 | OK |
| Alt text | nodes 1…2.25 (Example 3), degree 0 to 5, marker at x = 1.8, approaches e^1.8 = 6.049647, ends at 6.049643 | All as computed. "Approaches" holds because the error shrinks in size at every step | OK |
| GIF title | "Neville's Algorithm for e^x — P_{0,j}, degree j (j+1 nodes)" | Exact degree j for e^x (the leading divided differences are positive) | OK |
| GIF legend | f(1.8) = 6.049647; P_{0,j}(1.8) values; f(1.8) − P_{0,j}(1.8) = 3.33, 0.861, 0.0889, 0.00119, −5.23e−05, 4.34e−06 | Same as computed | OK |

### New problems
None. This rests on:
- the full-precision recomputation above;
- all 6 frames of nevillebb.gif viewed at full size (700×500). Titles and legends are legible. The red dashed P_{0,j} passes through the black nodes used. The green diamond sits on the dotted x̂ = 1.8 line at the computed height. The blue e^x curve is correct (e^2.25 = 9.49 at the right node). The y range 2–10.5 holds every curve, including P_{0,0} = 2.718 and P_{0,1} at x = 2.30;
- the unchanged Case 1 script and GIF.

Cosmetic only, not a defect: the GIF prints the j = 4 error as "-5.23e-05" with an ASCII hyphen, while the page writes −5.23×10⁻⁵. The title shows "e^x" and "P_{0,j}" as literal text, the same style as Case 1.

### Reproducibility and conventions
- Reproducibility: I ran a scratch copy of `nevillebb.jl` (identical to the repo file) with `julia nevillebb.jl`. The output sha256 is e21df2f6d3bceb80785ecfaae26ec4e79d5573aa697d0b298e280316d7733899, identical to the page's nevillebb.gif (`cmp` reports no difference). The GIF has 6 frames.
- Conventions: Description comes before Animations. Each case has a heading, a Behavior paragraph, a `[Julia source]` link and an image embed with descriptive alt text. Case 2 is placed after Case 1. There are no code blocks. The new files follow the page's naming (nevilleaa → nevillebb). `.gitattributes` puts the new GIF under the LFS filter, like the existing one.
- Files outside the page folder: within the page folder, the diff touches only index.qmd (modified) and nevillebb.jl and nevillebb.gif (new). Outside it, git status shows the fix record `reviews/numerical-methods-animations-r5/fixes/aitkens-and-nevilles-interpolation.md` (a process file, which I did not read), the round's worklist, and other pages' in-progress fixes (laurent-series, mullers-method). None of these belongs to this page's fix content.

**Final status:** committed
