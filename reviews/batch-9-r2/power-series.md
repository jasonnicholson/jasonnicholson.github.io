# Review: Power Series (batch 9, round 2)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).** (The reviewer's other finding, that the section index links the deleted flat `power-series.qmd`, is withdrawn: section-index links are changed in each page's "Add animations" commit.)

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. There is no Mathews module for this topic (the page says so), so no archive and no Fidelity check. Independent computations: Python/mpmath and sympy at 50–200 digits, with the Airy coefficients from the derivative recursion y^(n+2)(0) = n·y^(n−1)(0) rather than the page's recurrence, exact Fractions for Examples 2 and 3, and double-precision summation variants.

## Findings

### F1 — Page match (direction word) — Minor (unverified): the shaded interval stops widening once it fills the window

- **Location:** `index.qmd` line 36 (Case 1 Behavior): "The shaded interval widens in every frame, from [−0.4667, 0.4661] at N = 3 to [−2.227, 2.210] at N = 12."
- **True instead:** the drawn interval is clipped to the window: its right end stays at x = 3 from N = 18, and from N = 90 to 120 it is the whole window, unchanged in all 11 frames (`powerseriesaa.jl` lines 99–107, 152–154; frames 30–43 read "error < 10⁻³ on the whole window"). The next sentences of the page say this, so the impact is small, but taken literally the direction word is false for the last quarter of the animation.
- **Evidence:** `ex1b.py` edges ("90 whole … 120 whole"); regen log "N = 90 … 120: err<1e-3 on [−10(edge), 3(edge)]".
- **Fix:** "The shaded interval widens in every frame until it fills the window at N = 90, from …".

Note, not a finding: the page's double-precision error of S₁₂₀(−10), 4.2 × 10⁻⁹, depends on how the sum is formed (variants give 1.3e−9 to 6.3e−9; correctly rounded coefficients with xⁿ give 4.16e−9); "about seven correct significant digits" holds for every variant.

## Inventory (Phase 1)

3 scripts, 3 GIFs (43, 22, 22 frames); all run; every GIF byte-identical to what its script produces; every reference in the page folder resolves.

## Claim ledger (whole page; 145 entries; reviewer's verdicts)

- **Description (1–5), Animations introduction (6–14):** confirmed (5's process claim CND).
- **Case 1 (15–34):** confirmed except 18 (F1), including the round-1 correction now in place: the left end moves 0.4424 between N = 15 and 18, down to 0.2372 between N = 84 and 87, by less in each frame.
- **Case 2 (35–48), Case 3 (49–64):** confirmed.
- **Theory and method (65–72):** confirmed (82's "checked symbolically" process claim CND; the identity is confirmed by hand).
- **Example 1 (73–92), Example 2 (93–108):** confirmed (every table entry).
- **Example 3 (109–136):** confirmed, including the round-1 correction now in place: at x = 1.5, from N = 6 on each partial sum is farther from the exact value than the one before.
- **Practical notes (137–143):** confirmed (139 implementation-dependent, reproducible).
- **Wiring (144):** confirmed.

## Implementation checks

- **powerseriesaa.jl:** recurrence (3) in exact rationals with Ai(0), Ai′(0); coefficients match the independent recursion; errors and all 40 interval ends match; frames 1, 8, 43 checked.
- **powerseriesbb.jl:** recurrence (4) asserted; x* for all 20 frames match; reference verified by sympy; frames 1 and 20 checked.
- **powerseriescc.jl:** recurrences (5) and (6) asserted; both interval sequences match; frames 1 and 20 checked.
