# Review: Projectile Motion (batch 6, round 2)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).**

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: the module HTML, all nine Links pages, the surviving input, plot and output images for Examples 2–6, Mathews' Runge2D and Runge4D listings; no projectile animation in `a2001/Animations`. Independent computations: closed forms, mpmath quadrature for model (iv), 30-digit mpmath step-halving, SciPy DOP853 and Radau with event location and brentq, an own RK4.

## Findings

### F1 — Fidelity / page match — Minor (unverified): Mathews has two comparison plots, not one

- **Location:** `index.qmd` line 33: "The left panel is Mathews' comparison plot: his window [0, 20] × [0, 1500], … and his colours, green for (i), blue for (ii), purple for (iv) and, for (iii), the red of his descent curve".
- **True instead:** Example 3 ends with `Show[{graph1, graph2, graph31, graph32}]` (gr_253/254), showing (i), (ii), (iii); Example 4 has `Show[{graph2, graph4, graph31, graph32}]` (gr_307/308), showing (ii), (iv), (iii). No plot of his shows all four. The page says so correctly elsewhere (line 281: "(i)–(iii)"; line 268: "the three curves"). Window, colours and h = 0.2 all match his.
- **Fix:** "The left panel combines Mathews' two comparison plots (Examples 3 and 4): his window …".

## Inventory (Phase 1)

3 scripts, 3 GIFs (119, 119, 89 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 81 entries; reviewer's verdicts)

- **Description (1–3), Animations introduction and case descriptions (4–12):** confirmed except "Mathews' comparison plot" in 6 (F1); the (iv) reference matches mpmath quadrature to every digit.
- **Case 1 (13–30):** confirmed (drags 43.95, 25.98, 12; tops in drag order; direction of velocity change; descents longer and landings slower; impact speeds short of terminal; heights at t = 20; error growth, sign changes and which is largest; halving ratios in 30-digit arithmetic).
- **Case 2 (31–37), Case 3 (38–48):** confirmed.
- **No-drag motion (49–53):** confirmed (44.83°, 31.8°, 2812.5, 2435.70).
- **Vertical motion with drag (54–57):** confirmed, including the round-1 wording now in place: Mathews cites Millikan's oil drops as square-law drag, but those drops are at Re ≈ 1e−6 to 1e−4, in the linear regime.
- **Runge–Kutta and Examples 1–4 (58–69):** confirmed (Example 1's FindRoot CND, images lost).
- **Baseball, Examples 5–8 (70–79):** confirmed, including the round-1 wording now in place for Example 7 (root finder's b gives the data point to four decimals; the rounded table values end within 0.01 ft).
- **Wiring (80–81):** confirmed.

## Implementation checks

- **projectileaa.jl:** classical RK4 (Runge2D); errors, heights and sign changes reproduced; references verified; frames 1 and 119 checked.
- **projectilebb.jl:** every quoted value reproduced; Mathews' printed Z equals Z to 40 digits; frames 73, 94, 119 checked.
- **projectilecc.jl:** Runge4D; every run reproduced by DOP853/Radau; frames 30, 68, 89 checked.
