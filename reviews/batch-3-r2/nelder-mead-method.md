# Review: Nelder Mead Method (batch 3, round 2)

**Findings: 0 Error, 0 Misleading, 0 Minor.** Calibration page: the reviewer worked on a scratch copy with two planted errors (both caught as Errors with its own computations; see the README). The planted findings are not reported; the committed page's versions of those two sentences were confirmed by the same reviewer's computations (ledger entries 59/70 and 45/81 below).

Legacy archive consulted: the module HTML, its five solution pages, the `Nelder2D` code images (both versions), the Example 1, Exercise 3 and Example 4 outputs and pictures, `NelderMeadProof.pdf` (Table 8.5, Table 8.6, Example 8.6), and the animation pages `Nelder.html` and `Nelderaa.html`. Independent computations: an exact-Fraction implementation of both rule sets and the ε loop; a parser that compares every table cell on the page with that run under the page's stated rounding rule (tested by planting a corrupted cell, which it caught); per-example checks including a resultant for Exercise 3's stationary points.

## Findings

None. One observation below the threshold of a finding: the Animations introduction's description of the drawing (every triangle outlined, current one cyan, red vertex dots) fits Cases 1 and 2 exactly; in Case 3 the top panel outlines in the search colours without red dots, while the zoom panels have them.

## Inventory (Phase 1)

3 scripts, 3 GIFs; all run; `nelderaa.gif` (19 frames), `nelderbb.gif` (84), `neldercc.gif` (27) byte-identical to what their scripts produce; every reference resolves; no unreferenced file; the section index links the page.

## Claim ledger (whole page; 85 entries; reviewer's verdicts)

- **Description and method (1–15):** all confirmed, including the 50-step diameter ratio 123,035, the formulas against the code images and PDF pp. 431–434, case (ii) as printed, the three rule differences, the stopping loop `While[Or[And[Fw>Fb+ε, k<100], k<2]]`, and the tie conventions (ties at k = 4, 5 and the step-6 f(R) = f(W) tie).
- **Example 1 (16–28):** all confirmed: the textbook table k = 0…9 cell by cell and against Table 8.6 rows 1–10, the tie order in Mathews' table, (2.7, 2.0) with f = −6.91 for the alternative, the step-5 ties, the 50-step run (3 E, 10 R, 37 C₁), f(B) = −6.999999999991546835, distance 3.9017e−6, f(B)+7 = 8.4532e−12, spread 4.370e−11, Mathews' mirror point (gr_135).
- **Example 2 (29–42):** all confirmed: Hessian eigenvalues 0.39936 and 1001.6006, lost images gr_144–163, 77 steps (23 E, 16 R, 38 C₁), both tables cell by cell, x > 0 at step 29, |y − x²| ≤ 0.07560, distance 0.004444, the ε = 1e−10 run (94 steps, 7.56e−5), identical move sequences in double precision.
- **Exercise 3 (43–53):** all confirmed: Mathews' window and starting triangles (gr_174, 177, 184, 193), the five stationary points to the digits shown, the global minimum near (−2, 1.5), the results table, agreement with gr_180/188/196, move counts, FindMinimum gaps 5.6e−9, 1.95e−7, 2.04e−7 within the stated 2.1e−7, the three full tables cell by cell.
- **Example 4 (54–60):** all confirmed: 16 pictures (gr_206–237), the 16-row table, steps 3, 4 and 6, the k + 1 = k correspondence for k = 3…9, distance 0.0231 and f(B) = −6.999678, Mathews' printouts through k = 5 and the mirror relation for k = 6…50 (gr_214, 216, 218, 220, 238).
- **Animations (61–85):** all confirmed except the planted sentences of the copy, whose committed versions are correct: Case 1's "0.0231 from (3, 2)" (distance 0.023130497923) and Case 3's "Only search (iii) finds the global minimum" (f = −1.846283 at (−2.181752, 1.606977), reached by search (iii); search (ii) ends at the local minimum with f = −0.763680). Also confirmed: right-panel conventions (code lines 249–294, frames 7 and 16), Case 2's aspect ratios 2.000, 9.618, 102.59 and angle ≤ 25.82°, Case 3's vertex distances 0.2025/0.2632/0.3014 and saddle clearance 1.014, containment at the last frame, wiring and frame counts 19, 84, 27.

## Implementation checks

- **nelderaa.jl / nelderbb.jl:** `improve` is Mathews' `Nelder2D` Improve step line for line (E, R, C₁, C₂ with strict tests, else shrink), the ε loop is the archive's `While` condition, and (f, x, y) sorting reproduces Mathematica's `Sort` on ties. Logs match the independent Fraction run (Example 4 step 6: E (5.4, 3.6) −2.52, R (4.2, 2.8) −5.88, C₁ (2.4, 1.6) −6.72; Rosenbrock step 77: B = (0.9980467, 0.9960081), f = 4.60948e−6). Frames 7, 16 (aa) and 78 (bb) checked; a minimum marker sometimes partly under a label (cosmetic).
- **neldercc.jl:** same rule; (i) 17 steps, B = (−0.02538833, 0.001531836); (ii) 22 steps, (2.148987, 1.58797); (iii) 20 steps, (−2.182565, 1.607639), identical to the independent run and Mathews' output; stationary points match the resultant computation. Frames 1 and 27 checked.
