# Fix record: b-splines

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r6fix/b-splines/fix/check_mathews_b.py`

## Findings

### F1 — Minor (Fidelity) — fixed

- **Reproduced:** Yes.
  - Both cases draw the clamped parametric curve and its basis, on knots $(0,0,0,0,1,2,3,4,4,4,4)$ with 7 control points (`bsplineaa.jl`, `bsplinebb.jl`).
  - The archive module (`n2003/B-SplinesMod.html`, Links `lnk_2`, `lnk_3`) is about interpolation with translates of one $B(x)$. Its Example 1 data are $(0,1),(1,0),(2,0),(3,1),(4,2),(5,2),(6,1)$ (`gr_111`).
  - The line-46 paragraph disclosed the difference but gave no reason for it.
- **Change (R6-E, option b):** `index.qmd` line 46. One sentence appended after "neither example is animated here.":
  > On this page the weights are the given control points, so no linear system is solved and the two animations concentrate on the curve and the basis functions that form it.
- **Wording deliberately not used:** the review's example reason, "the basis-function properties shared by both uses", would be false if read to include this page's headline property, the partition of unity. Mathews' $B$ has peak 4 (`gr_23`), and his nine translates sum to **6** on $[0,6]$, not 1. The new sentence therefore makes no claim about shared properties.
- **Check:** see the ledger. No script or GIF changed.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `index.qmd` l.46 | "the weights are the given control points" | `bsplineaa.jl` line 29: `pt .+= b .* ctrl_pts[i]`, with `ctrl_pts` a literal list of 7 points | yes |
| `index.qmd` l.46 | "no linear system is solved" | `grep -nE '\\\\|solve|lu\(|inv\(|LinearAlgebra' bsplineaa.jl bsplinebb.jl` → no matches | yes |
| `index.qmd` l.46 | "the two animations" | Page embeds 2 GIFs (`bsplineaa.gif`, `bsplinebb.gif`) | yes |
| `index.qmd` l.46 | "concentrate on the curve and the basis functions that form it" | Case 1 traces $C(t)=\sum_i P_i N_{i,4}(t)$; Case 2 draws the $N_{i,4}$ on the same knots (identical knot construction in both scripts) | yes |

Supporting computation for the rejected wording (`/usr/bin/python3 check_mathews_b.py`):

- $B(-2..2)$ piece endpoints: 0, 1, 1, 4, 4, 1, 1, 0, so the peak is $B(0)=4$ and $B(\pm1)=1$, matching the 1-4-1 system (`gr_5`).
- Jumps at $x=-1,0,1$ in derivatives 0, 1, 2 are all 0; derivative-3 jumps are −24, 36, −24.
- Sum of the 9 translates $B(x-i)$, $i=-1..7$, on $[0,6]$: min 5.999999999999998, max 6.000000000000002. The translates are $b_i(x)=B((x-X_i)/h)$ with $h=1$, $X_i=i$ (`gr_60`, `gr_117`).
- This page's clamped basis sum on $[0,4)$: min 0.9999999999999997, max 1.0000000000000002.

## Scripts and GIFs

- Scripts changed: none. GIFs regenerated: none (R6-E: no script or GIF changes). No frames needed viewing for this text-only change.
- Page folder after the edit: only `index.qmd` modified.

## Legacy archive

Consulted: `n2003/B-SplinesMod.html`, `bsplines/B-SplinesMod/Links/B-SplinesMod_lnk_2.html` and `lnk_3.html`, and images `gr_2`, `gr_5`, `gr_23`, `gr_25`, `gr_60`, `gr_61`, `gr_63`, `gr_111`, `gr_117`, `gr_147`.

It shows cubic spline interpolation on a uniform grid with $s(x)=\sum_{i=-1}^{n+1} c_i\,b_i(x)$ and a 1-4-1 system. The page keeps its clamped-curve cases under R6-E. The existing description of Examples 1 and 2 on line 46 agrees with the archive.

## Notes

- **Placement, for the director:** R3-D says a "not animated here" sentence goes in the Animations introduction, before Case 1, but its explicit move list does not include B-Splines. The R6-E brief names the line-46 paragraph, so the paragraph stays where it is.
- Cosmetic GR underscore rendering in `bsplinebb.gif` labels was recorded by the reviewer as not a finding and is untouched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved

- Evidence: the owner chose option (b) (R6-E: add the reason to the disclosure sentence, no new case). The diff adds exactly one sentence to the line-46 paragraph and adds no case: "On this page the weights are the given control points, so no linear system is solved and the two animations concentrate on the curve and the basis functions that form it."
- The sentence supplies the missing reason for the difference from Mathews, and each part of it is true (ledger below).
- The existing description of Mathews' Examples 1 and 2 still matches the archive. The module has exactly two examples (`B-SplinesMod.html`, lnk_2, lnk_3), so "neither example is animated here" covers all of them. No B-spline animation was found under `a2001/Animations/` (the only filename match for "spline" is the unrelated `Quadrature/Spline`).

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| `index.qmd` line 46 | "the weights are the given control points" | `bsplineaa.jl` hard-codes 7 control points and sums `b .* ctrl_pts[i]`. The script's curve equals `scipy.interpolate.BSpline(K, P, 3)` with coefficients exactly P: max difference 8.9e-16 over 400 points. | True |
| `index.qmd` line 46 | "so no linear system is solved" | Neither script contains a solve, backslash, inverse or factorization (read in full and searched). The contrast with Mathews holds: his Example 1 as a 9x9 system (7 interpolation rows, 2 natural end rows) gives c = (2.2, 1, -0.2, -0.2, 1, 2.2, 2.2, 1, -0.2), and that sum matches SciPy's natural cubic spline through his 7 points to 8.9e-16. | True |
| `index.qmd` line 46 | "the two animations concentrate on the curve and the basis functions that form it" | Case 1 draws the curve and Case 2 the basis functions. Both scripts use the knot vector (0,0,0,0,1,2,3,4,4,4,4). Case 2's basis matches SciPy to 1.1e-16; applying Case 1's control points to it reproduces the curve to 1.8e-15; the basis sums to 1 within 3.3e-16. Case 2 itself draws the basis unweighted, which does not contradict the sentence. | True |

No heading, alt text, title, label or other number changed.

### New problems

None. This rests on the one-sentence diff, the ledger above, and the unchanged scripts and GIFs.

Pre-existing, not introduced by this fix (for the director to decide):

- Minor, `index.qmd` line 46: the "not animated here" paragraph sits after Case 2, while R3-D says that on every page with such a sentence it goes in the Animations introduction before Case 1. B-Splines is not in R3-D's named move list, and the paragraph was already at line 46 at HEAD. R6-E and F1 both direct the addition to this paragraph, so the fix is correct where it is.
- Minor, `bsplinebb.gif`: subscript notation is mixed or unrendered in the labels. The title reads "N₁,₄ … N_4,₄", the legend "N_1,₄", and the y-axis shows literal "N_{i,4}(t)". All remain readable and correct in meaning.

### Reproducibility and conventions

- Scripts: both were run from scratch copies. `bsplineaa.gif` (31 frames) and `bsplinebb.gif` (7 frames) are byte-identical to the committed files, and their decoded frame hashes also match.
- GIFs unchanged by the fix: the SHA-256 of each file on disk equals the Git LFS oid at HEAD (`0d09c98e...` and `192a1bfd...`).
- Frames viewed at full size: first, middle and last of each GIF. Case 1 traces the curve from the first to the last control point; Case 2 reveals N₁ to N₇, and the running sum reaches 1 on the last frame.
- Conventions: Description precedes Animations, each case has a source link and GIF embed, alt text is descriptive, and there are no code blocks.
- Scope: within this page folder only `index.qmd` differs from HEAD, and `fix.diff` lists no other file. The working tree has other modified pages from this run; this check cannot attribute those, and the diff for this page does not touch them.
- Process note: an initial combined shell command was denied by the permission system. The same brief-named files were then read individually. No fix records or other review files were read.

**Final status:** committed
