# Review: Powell's Method (batch 3, round 1)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).** Calibration page: the reviewer worked on a scratch copy with two planted errors (both caught as Errors with its own computations; see the README). The planted findings are not reported; the committed page's versions of those two sentences were confirmed by the same reviewer's computations (ledger entries 24 and 33 below).

Legacy archive consulted: PowellMethodMod.html, all nine solution link pages, program and output images (gr_27, 35, 83, 99, 119, 124, 129, 160, 175, 178, 194–205, 216, 222, 227, 242, 248, 263, 272), the animation pages Powellaa.html and Powellbb.html (both "Under Construction"), and the textbook PDF PowellMethodProof.pdf (Example 8.7).

## Findings

### F1 — Page match — Minor (unverified)

- **Location:** `index.qmd`, Animations introduction: "The blue contour through the new point touches the dashed search line there … at the exact minimum $(3, 2)$ in the last frame of Case 2 that contour shrinks to a point and is not drawn."
- **Now:** names Case 2's last frame as the only frame without the tangent blue contour.
- **True instead:** in Case 3 the blue contour through the new point is drawn (`powellcc.jl` line 215) but is not visible in the right panel of frames 7, 10–13 and the hold frames 14–16, because f at those points is 5.8e-8, 2.4e-18, 1.2e-24, 5.5e-31 and 1.2e-46 and the contour is a sliver far below one pixel of the 300-point grid. It is visible in frames 2–6 and as a thin sliver in frames 8 and 9; in the left panel it disappears from frame 7 on.
- **Fix:** add a clause such as "In Case 3, from $\mathbf{X}_2$ on, $f$ at the new point is so small that this contour is too small to see."

## Inventory (Phase 1)

3 scripts, 3 GIFs; all scripts run; `powellaa.gif` (10 frames), `powellbb.gif` (10), `powellcc.gif` (16) are byte-identical to what their scripts produce; every page reference resolves; no unreferenced file; the section index links `powells-method/`.

## Claim ledger (whole page; reviewer's verdicts)

**Description.** (1) uses only values of f — confirmed; (2) line search / taxi-cab definition — confirmed; (3) update formulas match Mathews (gr_242) and the scripts — confirmed; (4) quadratic minimised exactly within two iterations (Example 3) — confirmed, X₂ = (3, 2) exactly; (5) Mathews' printed points differ by at most 6e-8 (max per example 3.32e-8, 4.6e-9, 5.69e-8, 3.61e-9, 2.4e-8, ~5e-9) — confirmed; (6) every line search goes to the first local minimum downhill from γ = 0 — confirmed by an independent nearest-downhill-root search.

**Animations introduction.** (7) one search per frame; 10, 10, 16 frames — confirmed; (8) left-panel elements — confirmed; (9) right-panel zoom and scaled offsets — confirmed (e.g. frame 2 of Case 1, −4.5 at ×10¹ = −0.45); (10) hollow circle / red dot — confirmed; (11) blue contour tangent at the new point, only exception Case 2's last frame — wrong in part (F1); (12) no blue contour at (3, 2) in Case 2's last frame — confirmed; (13) titles give γ and the point — confirmed; (14) Cases 1–2 exact rational vertex — confirmed; (15) Case 3 doubling then golden-ratio search in 256-bit — confirmed; (16) Mathews' Animations 1 and 2 pages show only "Under Construction" — confirmed; (17) same function, start, window, 24 cyan levels, seven points as Mathews — confirmed (gr_227/gr_263); (18) polygon vs drawn dog-leg — confirmed (gr_272); (19) not-animated list — confirmed.

**Case 1.** (20) heading — confirmed; (21) staircase, each search tangent — confirmed; (22) steps 13/40, 3/16, 3/32, 3/64, 3/128, 3/256 — confirmed; (23) factor 1/4 per sweep — confirmed; (24) distances 0.1398, 0.03494, 0.008735 — confirmed on the committed page (X₂ = (2.96875, 1.984375), distance 0.015625√5 = 0.03494); (25) X₃ and f + 7 = 4.578e-5 — confirmed; (26) zoom shrinks every search after the first — confirmed; (27)–(28) wiring and alt text — confirmed.

**Case 2.** (29)–(32) heading, first searches, U₂, γ = 706/511 — confirmed; (33) dog-leg "carries it past P₂" — confirmed on the committed page (γ = 1.3816 > 1; frame 4); (34) X₁ — confirmed; (35) 0.009104 vs 0.06988 — confirmed; (36) 0.001094 and 7.126e-5 — confirmed; (37) indistinguishable in left panel — confirmed; (38) conjugate direction — confirmed (exact product 0); (39) γ = 511/507 lands on (3, 2) — confirmed; (40)–(41) wiring, alt text — confirmed.

**Case 3.** (42)–(55): window, valley floor, 0.01498, y − x² = 2.475e-5, four points within 5.6e-5 (max 5.513e-5), 0.01117 → 0.01111, 0.095° (0.0947°), 1.226e-5 short (γ = 0.99918), |U₂| = 2.752e-5 and slope 2.0149, γ = 402.7 and 0.011084, 5.871e-5, 3.467e-9, 2.607e-24, wiring and alt text — all confirmed.

**Line searches, formula (1), taxi-cab, Examples 1–2.** (56)–(78): all confirmed, including formula (2) algebraically, the closed forms X_k = (3 − 2^−(2k+1), 2 − 2^−(2k+2)) and f(X_k) = −7 + 3·2^−(4k+4) for k = 1..10, all Example 1 and 2 table rows exactly (Example 2 row 4 P₁ 0.4887695313 for exact 0.48876953125, acceptable rounding), per-iteration factors 0.476, 0.298, 0.367, 0.427, 0.404, Mathews within 4.56e-9.

**Powell's method, theorem, Example 3.** (79)–(93): all confirmed, including the conjugacy theorem and its proof, φ = 511/6400·γ² − 353/1600·γ − 2739/400, X₁ = (3065/1022, 8213/4088), f(X₁) = −228925/32704, X₂ = (3, 2) exactly. (83) Powell's 1964 result: standard, not computed.

**Example 4.** (94)–(101): all confirmed by an independent polynomial-root line search (every table digit), Mathews within 1.217e-12 then 3.609e-9, Hessian eigenvalues 0.39936 and 1001.60.

**Example 5.** (102)–(111): all confirmed, including the three 7-row tables, distances 8.8e-17, 1.43e-9, 3.81e-9, five real critical points (degree-9 resultant), minima and saddles. (112) "computed in 50-digit arithmetic" — process claim, could not determine; results confirmed.

**Example 6.** (113)–(122): all confirmed, including the textbook's γ = 0.9816697 and the true line minimum γ = 1.00000240 with f = −1.99999999999448, against the textbook's printed X₁ with f = −1.9978294.

**Enhanced method, graphical runs, implementation notes.** (123)–(133): all confirmed (Mathews gr_192–204, gr_227, gr_240, gr_242, gr_263, gr_272; 10.67° in Example 4; taxi-cab 0.0087346 after 3 iterations).

## Implementation checks

- **powellaa.jl** (taxi-cab, Example 7): runs the taxi-cab method (two coordinate searches per iteration, no direction update), as Mathews' TaxiCab[P0, 3]. γ values 13/40, 3/16, 3/32, 3/64, 3/128, 3/256 and every point identical to an independent exact-fraction run; f + 7 = 4.578e-5 = 3·2⁻¹⁶. The vertex construction is exact for a quadratic. Reference minimum (3, 2), f = −7 confirmed. Frames 1, 2, 3, 7 checked: segments, dashed lines, tangent contours, offsets (frame 7 start (−7.8125, −15.625)×10⁻³), titles, Mathews' window and levels; no clamping.
- **powellbb.jl** (Powell, Example 8): basic Powell method (U ← [U₂, P₂ − P₀], search from P₀), as Mathews' program gr_242. γ values 13/40, 3/16, 706/511, −39/4088, 780/261121, 511/507 and f + 7 = 9.173e-5, 7.181e-7, 5.621e-9, 0 identical to the independent run; conjugacy exactly 0. Frames 4, 5, 7 checked.
- **powellcc.jl** (Powell on Rosenbrock, new): basic Powell, 4 iterations; line search by a descent-sign probe, doubling march and 300-step golden section in 256-bit BigFloat. Agrees with an independent exact nearest-root line search on all 12 searches (e.g. γ = 0.01497524692, 0.9991809849, 402.7455889, 1.000000478; X₂ = (1.000035383584, 1.000046843962); f(X₄) = 1.154e-46; distance 2.607e-24). The cancellation-free form f_rel(u, v) = 100(v − 2u − u²)² + u² equals f(1 + u, 1 + v). Frames 2, 4–13 checked; display limitation recorded as F1.
