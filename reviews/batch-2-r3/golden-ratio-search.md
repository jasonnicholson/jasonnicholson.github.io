# Golden Ratio Search: review, batch 2 round 3

**Result: 0 Error, 0 Misleading, 1 Minor (unverified).** No implementation or drawing errors. The reviewer's independent float64 and 50-digit runs match every script's iterates and every table row; the dashed minimiser line is green, RGB (2, 129, 2), in every frame of all three GIFs (a downscaled view can make it look grey; not a finding).

The reviewer consulted the archive (module HTML, lnk_2–lnk_7, program images gr_64, gr_139, gr_222, outputs and calls gr_114/115, gr_160/161/169, gr_186/195, gr_215/219/220, the textbook PDF §8.1 pp. 409–412, and `a2001/Animations/Optimization/GoldenRatio1/`).

## Findings

### M1. Minor (page match, Example 5 result), line 409

- **Now:** $\boxed{\,-83.4463 \le V(t) \le 118.3054 \quad \text{for all } t \ge 0\,}$.
- **True:** max V = V(arctan 9) = 118.3054332802, which is 3.3 × 10⁻⁵ above 118.3054; min V = V(arctan 9 + π) = −83.4463447534, which is 4.5 × 10⁻⁵ below −83.4463. Both bounds are rounded inward, so read literally both inequalities fail. Mathews prints the same line (gr_220), so the page copied his rounding. The conclusion |V| < 120 is unaffected. (`check2.py`; `check3.py` sampling of 4 × 10⁶ points on [0, 200] gives 118.3054332726 and −83.4463447376.)
- **Fix:** round outward, $-83.4464 \le V(t) \le 118.3055$, or give five decimals, $-83.44635 \le V(t) \le 118.30544$.

## Inventory (Phase 1)

Scripts and GIFs unchanged since round 1 (no `.jl` or `.gif` change since `f9a2662`); all three GIFs byte-identical to their scripts' output (12, 28, 34 frames). References resolve; no orphans; the index links the page.

## Claim ledger (summary; 125 claims)

All confirmed except claim 107 (M1). Could not determine: whether Mathews' lost Example 2 search used exactly [0, 1] (image missing; the page says so and claims nothing), and the frame count of Mathews' lost GIF (the page says it is not recorded). Highlights:
- **Description and introduction (1–20):** formulas (widths equal ρ^k to 1e−16 relative), panel elements and p line colour, bottom title and green bar, frame mapping (10 and 26 distinct frames), held last frame, labels gaining digits (7 and 8 significant figures at the end), BigFloat differences, sign agreement and 50-digit keep sequences, one Mathews animation linked from Example 6 (only `GoldenRatioaa.html` survives), ten lost Example 6 pictures (gr_226…gr_244), gr_222 window, colours, fill and ticks, not-animated list, tie rule (`If[Yc < Yd, …]`; the tie variant gives identical sequences), ρ² and return rule.
- **Cases 1–3 (21–49):** every number confirmed, e.g. a₉ 6.29092e−3 and midpoint 2.869e−4 from p; b₂₅ 1.354e−6, midpoint 1.627e−6; f(c₀) = 1.244516589, f(d₀) = 0.811470784; one sign change of f′ on [−0.2361, 1] (200k-point scan); a₃₁ 2.327e−7 from p; smallest |Δ| 4.715e−14 = 424.7 ulp.
- **Theory and algorithm (50–59):** derivation, constants, theorem, ln 10 / ln φ = 4.785, Mathews' programs (gr_64, gr_139).
- **Example 1 (60–78):** full table compared row by row; verification table (f(b) − f(p) = 2.232e−12, f′(b₂₅) = 3.297e−6); secant table (mpmath); gr_115 compared line by line; textbook row 23 reproduced exactly by a left-squeeze alternative; c₀ typo (PDF line 111); Fibonacci n = 21 with exact rationals.
- **Examples 2–4 (79–103):** all confirmed, including Mathews' reported values (gr_169, gr_195).
- **Example 5 (104–110):** all confirmed except the boxed bounds (M1); margin 1.6946.
- **Example 6 (111–120):** table, sides (Fibonacci n = 12), |Δ₇| = 1.1647e−4 and |Δ₈| below 0.72/6000, distance table (including b₉ 6.86e−3), continued tolerance run.
- **Comparison and implementation notes (121–125):** ratio 0.87118–0.87119 for n = 21, 12, 30, 44, limit 0.871184; tolerance step k = 14 (width 1.186e−3); precision limit (k = 36 is 5 ulp, k = 37…69 at most 2; first wrong comparison k = 42; p outside from k = 43, width 1.03e−9); √u.

## Implementation checks

The three scripts are one template (differences only in parameters, headers and the `step_note`/`extra_vline` entries).
- **`goldenaa.jl`:** golden-section search with Mathews' update, K = 9; printed iterates match the reviewer's float64 run to full precision (c₉ = 0.63118960624631981, d₉ = 0.63429522626146162); Δ₀…Δ₈ match its mpmath values; p = √10/5 exact; all 12 frames on the sheet and frames 1 and 10 at full size: titles, green bar, final title, Mathews' window and ticks, no clamping.
- **`goldenbb.jl`:** K = 25 (`GoldenSearch[0,1,25]`); all 26 rows and keeps match; b₂₅ = 0.4501849651, midpoint 0.4501819847 identical; p = 0.450183611294874 matches `findroot`; frame 26 at full size; top panel ylim (−0.3, 0.3) covers f.
- **`goldencc.jl`:** Mathews' tolerance stop (gr_139); all 32 rows match; K = 31, a₃₁ = 0.3770018229846242, 2ρ³¹ = 6.6437e−7; p and x_max match mpmath; frames 1 and 32: orange line at the local maximum, k = 0 note, ylim (0, 2) covers f, last title fits.
- **Robustness:** 1 − ρ computed either way and either tie rule give identical keep sequences; no exact ties in any of the seven runs.
