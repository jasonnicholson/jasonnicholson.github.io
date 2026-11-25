# Review: Linear Programming and the Simplex Method (batch 9, round 1)

**Findings: 0 Error, 0 Misleading, 3 Minor (unverified).**

Legacy archive consulted: the module page, all 10 solution pages and their surviving images. Independent computations: an exact `Fraction` simplex with selectable tie rules, vertex enumeration over all constraint triples, a face/edge/Euler count, SciPy `linprog` cross-checks, an independent recomputation of all 63 level-line cuts in the `simplexaa` log.

## Findings

### F1 — Page match — Minor (unverified): the colour key holds only for Cases 2 and 3

- **Location:** `index.qmd` line 30 (Animations introduction): "In every picture the region is pale green with a green edge, the cyan lines are level lines of $f$, the blue line is the level line through the current point (in Case 1, the line through the maximum), and the orange line is the path of the simplex method from the origin."
- **True instead:** in Case 1 (`simplexaa.jl` lines 123–132) orange is the part of the level line f = c inside R plus the touching-vertex marker; there is no simplex path (e.g. frame_019, panel (a)). In Case 4 (`simplexdd.jl` lines 159–175; frames 001, 008, 013, 024) there are no cyan level lines and no blue line. Case 1's Behavior paragraph does say the segment is orange.
- **Fix:** "In Cases 2 and 3 … the orange line is the simplex path; in Case 1 orange marks the part of f = c inside R, and Case 4 has no level lines."

### F2 — Fidelity — Minor (unverified): Example 6's degenerate pivot holds for the solution-page data, not for Mathews' statement

- **Location:** line 32: "Its second pivot is degenerate: the minimum ratio is $0$, so the point stays at $(0, 100, 0, 0)$ for one pivot before the method reaches the optimum $(96, 44, 44, 16)$, where $f = 1324$."
- **True instead:** true for the data of Mathews' solution page, where the second constraint is $3x_2+2x_3+5x_4 \le 300$ (gr_441, gr_442, gr_447). His statement (gr_440) has $\le 500$; then no ratio ties, no pivot is degenerate, and the path (0,0,0,0) → (0,100,0,0) → (0,100,50,0) → (0,1500/17,1000/17,400/17) → (40,60,60,40) ends at f = 1460. The page flags the same kind of discrepancy for Examples 1 and 3(b) but not here.
- **Evidence:** `check.py`: with 300, pivot 1 ties (100, 100) and pivot 2 is degenerate under both tie rules, ending at (96, 44, 44, 16), f = 1324 (SciPy agrees); with 500, f = 1460 (SciPy 1459.99999…).
- **Fix:** add "(using the data of Mathews' solution page, where the second constraint is ≤ 300; his statement has ≤ 500, for which no pivot is degenerate and the maximum is 1460 at (40, 60, 60, 40))".

### F3 — Implementation (script comment) — Minor (unverified): `simplexbb.jl` miscounts frames per pivot

- **Location:** `simplexbb.jl` line 9: "Each pivot takes three frames (choose the pivot, move along the edge, the new tableau)".
- **True instead:** each pivot takes 5 frames (lines 175–200: the tableau at the vertex, the pivot choice, and `n_move = 3` moving frames); with 4 held final frames that gives the 14 frames in the manifest.
- **Fix:** "Each pivot takes five frames: the tableau at the vertex, the pivot choice, and three points along the edge."

## Inventory (Phase 1)

4 scripts, 4 GIFs (28, 14, 20, 24 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D11):** confirmed (level lines move along ∇f; optimal vertex; tableau semantics; Dantzig's rule and ratio test; f grows by (−z_e)b_r/a_re ≥ 0, checked on Examples 2 and 5; degenerate pivots; optimality test).
- **Animations introduction (A1–A12):** confirmed except A3 (F1) and A11 (F2): exact rationals; no archive animation; Mathews' colours from gr_32, gr_214, gr_328, gr_437; Example 1's origin infeasible; Examples 2(b), 4, 6 as stated.
- **Case 1 (C1.1–C1.11):** confirmed: first contact at (16, 8) with 376, 392, 384; 63 cuts with 0 mismatches; maxima 644 at (18, 22), 648 at (24, 16); (c)'s whole edge at 640; Mathews' window and levels.
- **Case 2 (C2.1–C2.9):** confirmed: ratios 30, 16, 55/3 then 8, 64, 4; (0, 16) at 320, (4, 15) at 340; tableaux equal Steps 1–3 entry by entry.
- **Case 3 (C3.1–C3.12):** confirmed: tie in (a) resolved as Mathews (gr_307); path to (17, 17) at 340 in four pivots; s6, s5 re-enter; mirror path; (b) to (12, 20) at 620 in three pivots; Mathews' 3(b) solves 10x + 15y (425).
- **Case 4 (C4.1–C4.9):** confirmed: 8 vertices, 12 edges, 6 faces; three pivots to (15/2, 3, 9/2), f = 141 (SciPy); Mathews' iterations; azimuth sway 25°–45°.
- **Background and worked examples (B1–B5, E1.1–E3.5):** confirmed (Example 1's word statement vs his Mathematica input, 646 at (17, 23) under the word constraints; all tables, tableaux and verifications).

## Implementation checks

- **simplexaa.jl:** level-line sweep with exact rational cuts; vertex values and all 63 cuts match; frames 3, 19, 23, 28 checked.
- **simplexbb.jl:** Dantzig's rule, exact rationals, no ties; every tableau entry matches and the final row equals Mathews' gr_195; frames 2, 8, 14 checked; header comment wrong (F3).
- **simplexcc.jl:** first column on ties as Mathews; both paths and ratios match his printed iterations; frames 2, 11, 20 checked.
- **simplexdd.jl:** polyhedron from triple-plane intersections; path, ratios, counts match the independent enumeration and SciPy; frames 1, 8, 13, 24 checked.
