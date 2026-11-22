# Fix record: newton-interpolation-polynomial

Scratch folder (all scripts and outputs, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/newton-interpolation-polynomial/fix/`

- `defs.jl`: the shared script with its final render loop removed.
- `repro_f1.jl`: node values and interpolant range of Cases 12 and 13 for 2, 3 and 4 nodes, from the script's own functions.
- `check_flat.py`: independent check. It computes exact sympy divided differences for 2–4 nodes, and 50-digit mpmath divided differences and interpolant ranges for all ten node counts.
- `g12/`, `g13/`: frames and contact sheets of `lagnewt12.gif` and `lagnewt13.gif` (unchanged by this run).
- `md5_before.txt` / `md5_after.txt`: GIF checksums around the regeneration of the shared script (see the Lagrange record for that fix).

This page shares `lagnewt_animations_all.jl` with `lagrange-polynomial-interpolation-and-approximation` (WP-B). The script was changed for that page's F1 (Case 14, tan broken at its poles). The change was copied here byte-identically (`cmp` → no output) and regenerated in place.

## Findings

### F1 — Minor — fixed
- **Reproduced:**
  - `julia repro_f1.jl`:
    - Case 12, n = 2, 3, 4: nodes/π = [−3, 3], [−3, 0, 3], [−3, −1, 1, 3]; node y values are all within ±3.67e-16; interpolant range (−3.67e-16, 3.67e-16).
    - Case 13, n = 2 and 4: node y = −1 at every node; interpolant range (−1.0000000000000002, −0.9999999999999998) and (−1.0000000000000004, −0.9999999999999994).
    - Case 13, n = 3: node y = [−1, 1, −1]; range (−1, 0.999998), so not flat.
  - `python3 -I check_flat.py`, exact sympy:
    - Case 12, n = 2, 3, 4: y = 0 at every node, so all divided differences are 0 (a = [0, 0], [0, 0, 0], [0, 0, 0, 0]).
    - Case 13, n = 2: a = [−1, 0]. n = 4: a = [−1, 0, 0, 0]. n = 3: a = [−1, 2/(3π), −2/(9π²)].
  - `check_flat.py`, mpmath: no other frame of either case is flat.
    - Case 12, n ≥ 5: max |a_k| (k ≥ 1) ≥ 0.156; the interpolant ranges at least to ±1.0000.
    - Case 13, n = 3 and n ≥ 5: max |a_k| ≥ 0.212.
  - Contact sheets `g12/sheet.png` and `g13/sheet.png`:
    - Case 12: the frames titled degree 1, 2 and 3 show a horizontal line at y = 0.
    - Case 13: the frames titled degree 1 and 3 show a horizontal line at y = −1.
    - Neither page sentence existed under the Newton headings.
- **Change:** `index.qmd`
  - Under `### Case 12` added: "With 2, 3 and 4 nodes every node is a multiple of $\pi$, where $\sin x = 0$, so every divided difference is zero and the frames titled degree 1, 2 and 3 all show the line $y = 0$."
  - Under `### Case 13` added: "With 2 and 4 nodes every node is an odd multiple of $\pi$, where $\cos x = -1$, so $a_0 = -1$, every later divided difference is zero, and the frames titled degree 1 and 3 show the line $y = -1$."
  - No script change was needed for this finding (D7: the animation is correct).
- **Check:** see the ledger. `lagnewt12.gif` and `lagnewt13.gif` are byte-identical after regeneration (md5 unchanged), so the frames cited are current.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 12 | "With 2, 3 and 4 nodes every node is a multiple of π" | `check_flat.py` → nodes/π = [−3, 3], [−3, 0, 3], [−3, −1, 1, 3]; `repro_f1.jl` (script nodes) → same | yes |
| Case 12 | "where sin x = 0, so every divided difference is zero" | sympy → a = [0,0], [0,0,0], [0,0,0,0]. In the script's Float64 data sin(±3π) = ±3.67e-16, so the drawn line is y = 0 to within 3.7e-16 | yes |
| Case 12 | "the frames titled degree 1, 2 and 3 all show the line y = 0" | Script titles use degree = n − 1 → 1, 2, 3 for n = 2, 3, 4; `repro_f1.jl` interpolant range ±3.67e-16; `g12/sheet.png` frames 1–3 flat at 0. The word "all" covers exactly these three; no other frame is flat (mpmath: n ≥ 5 range ≥ ±1.0000) | yes |
| Case 13 | "With 2 and 4 nodes every node is an odd multiple of π" | nodes/π = [−3, 3] and [−3, −1, 1, 3] | yes |
| Case 13 | "where cos x = −1, so a₀ = −1, every later divided difference is zero" | sympy → a = [−1, 0] (n = 2), [−1, 0, 0, 0] (n = 4) | yes |
| Case 13 | "the frames titled degree 1 and 3 show the line y = −1" | `repro_f1.jl` → ranges −1 ± 2.2e-16 and −1 ± 5.6e-16; `g13/sheet.png` frames 1 and 3 flat at −1; frame 2 (n = 3) is a parabola, range (−1, 0.999998) | yes |

## Scripts and GIFs
- Script changed: `lagnewt_animations_all.jl`, made byte-identical to the Lagrange copy for the Lagrange page's F1. It is not part of this page's finding.
- Regenerated in place with `julia lagnewt_animations_all.jl`.
  - Only `lagnewt14.gif` changed (md5 10a68184… → 2e665fca…).
  - All 29 `lagnewtNN.gif` are byte-identical to the Lagrange page's copies.
  - `newtpolyaa.gif` was not touched.
- Frames viewed: contact sheets of `lagnewt12.gif` and `lagnewt13.gif` for this finding. The new Case 14 frames are viewed and recorded in the Lagrange record: tan is broken at ±π/2, and the vertical connectors are gone.
- `git status --short -- pages/numerical-methods/newton-interpolation-polynomial` →
  ` M …/index.qmd`, ` M …/lagnewt14.gif`, ` M …/lagnewt_animations_all.jl`.

## Legacy archive
Consulted:
- `n2003/newtonpoly/NewtonPolyMod` and the `a2001/Animations/Interpolation/Lagrange/` case pages.
- The legacy pages for Cases 12, 13 and 14 (`Lagrangell.html`, `Lagrangemm.html`, `Lagrangenn.html`) reference GIFs that are not in the archive. So it cannot be seen whether Mathews' node counts also produced flat frames.
- The added sentences are about this page's animation and were computed from it. They do not depend on the archive.

## Notes
- I did not make the optional change of "degree 1 to 5" to "degree at most 1 to 5" on l.24.
  - The reviewer judged the titles correct when read as "degree at most".
  - The Lagrange page uses the same nominal wording, and changing only one page would make the two pages disagree.
  - The milder general effect the reviewer mentions is left undescribed: even f, an even number of symmetric nodes, so the "degree 1" frames of Cases 08, 13, 17, 20 and 22 are horizontal. Describing it would be extra teaching content beyond the finding.
- Alt text for Cases 01–29 is still generic (the reviewer's note, not a finding). I did not touch it, so the alt text of Cases 12 and 13 does not mention the flat frames. It makes no claim that conflicts with them.
- The reviewer's note that the Case 14 vertical segment "reads as an asymptote" is superseded by the Lagrange F1 fix: the segment is gone on both pages.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence (text): `### Case 12` and `### Case 13` now each have an explanatory sentence (index.qmd l.76, l.82) that names the frames titled degree 1–3 (Case 12) and degree 1 and 3 (Case 13). It also gives the cause in Newton-form terms (the divided differences).
- Evidence (computation): the node span for Cases 12 and 13 is exactly [−3π, 3π], because `finite_support` returns the window ends and sin and cos are finite everywhere.
  - Nodes for n = 2, 3 and 4 are {±3π}, {−3π, 0, 3π} and {−3π, −π, π, 3π}.
  - Exact sympy divided differences:
    - sin, n = 2, 3, 4: all a_k = 0.
    - cos, n = 2: [−1, 0].
    - cos, n = 4: [−1, 0, 0, 0].
    - cos, n = 3: [−1, 2/(3π), −2/(9π²)]. This frame is not flat, and the page does not claim it is.
  - In Float64 (`dd_check.jl`, Newton nested evaluation on 1000 points):
    - the sin interpolants for n = 2, 3, 4 lie within ±3.7e-16;
    - the cos interpolants for n = 2 and 4 are exactly −1;
    - the cos interpolant for n = 3 spans [−1, 0.999998].
- Evidence (GIF): I viewed the contact sheets of `lagnewt12.gif` and `lagnewt13.gif`. These GIFs are unchanged and byte-identical to the Lagrange copies.
  - Case 12: the frames titled degree 1, 2 and 3 show the interpolant on y = 0, with nodes at multiples of π.
  - Case 13: the frames titled degree 1 and 3 show y = −1; the degree-2 frame shows a parabola through (0, 1).
- The optional change on line 24 ("degree at most") was not made. As the finding itself notes, the titles are correct when read as "degree at most", so I do not count this against resolution.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.76 (Case 12) | "With 2, 3 and 4 nodes every node is a multiple of $\pi$" | Nodes ±3π; −3π, 0, 3π; ±π, ±3π, all integer multiples of π (computed). | correct |
| l.76 | "where $\sin x = 0$, so every divided difference is zero" | Exact sympy divided differences are all 0, including a_0 = 0. In Float64 they are ≤ 3.7e-16. | correct |
| l.76 | "the frames titled degree 1, 2 and 3 all show the line $y = 0$" | GIF titles for n = 2, 3, 4 read "degree 1/2/3". The frames show a flat line at 0. | correct |
| index.qmd l.82 (Case 13) | "With 2 and 4 nodes every node is an odd multiple of $\pi$" | ±3π and ±π, ±3π are odd multiples of π. | correct |
| l.82 | "where $\cos x = -1$, so $a_0 = -1$, every later divided difference is zero" | Exact: [−1, 0] and [−1, 0, 0, 0]. | correct |
| l.82 | "the frames titled degree 1 and 3 show the line $y = -1$" | Viewed: frames 1 and 3 are flat at −1. Computed: the interpolant is ≡ −1. | correct |

### New problems
None. This rests on:
- the exact and Float64 divided-difference computations above;
- the frames viewed;
- the shared-script change (the Case 14 pole break, checked in full in the Lagrange resolution).

The new `lagnewt14.gif` embedded here no longer draws vertical segments through tan's poles. This page makes no claim about how curves leave the window, so no page text needed updating for it.

Pre-existing and not touched by this fix: the alt text on this page is generic ("Newton interpolation animation for case NN from the legacy function-and-interval list."). It was not changed and is not a new problem.

### Reproducibility and conventions
- The shared script `lagnewt_animations_all.jl` is byte-identical (`cmp`) to the Lagrange copy. I ran a scratch copy: all 29 output GIFs are byte-identical to the GIFs in both folders. All 29 `lagnewt*.gif` files match pairwise across the two folders (sha256).
- Only `lagnewt14.gif` changed in this folder vs HEAD (git status), and it is identical to the Lagrange folder's `lagnewt14.gif` (sha256 96244afb…). `newtpolyaa.jl` and `newtpolyaa.gif` are unchanged.
- Conventions:
  - Description precedes Animations.
  - There is a source link for Cases 01–29 and a separate one for the divided-difference case.
  - There are 29 `### Case` headings, each with an embed.
  - There are no code blocks.
- Files changed in this folder: index.qmd, lagnewt14.gif and lagnewt_animations_all.jl. The only related change outside it is the Lagrange twin (WP-B). Other modified files in the working tree belong to other pages' fixes.

**Final status:** committed
