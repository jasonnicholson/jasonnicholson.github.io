# Review: Circle of Curvature (batch 9, round 2)

**Findings: 0 Error, 0 Misleading, 1 Minor (unverified).** (The reviewer's second finding, that the section index links the deleted flat `circle-of-curvature.qmd`, is withdrawn: section-index links are changed in each page's "Add animations" commit.)

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: `CurvatureMod.html`, the 13 link pages and the surviving images (including Mathews' 19 Example 5 frames gr_194–212, compared with frames 1 and 22). Independent computations: sympy circumcircle and osculating-circle derivations, mpmath radii, window checks over every frame.

## Findings

### F1 — Page match — Minor (unverified): the off-window note applies to the right panel only

- **Location:** `index.qmd` line 34 (Case 1 Behavior): "In both panels the radius decreases with every smaller $h$ and stays above its limit. For $h \ge 0.7$ the right-hand point lies outside the window, and for $h \ge 0.8$ so does the center. The frame says so…"
- **True instead:** the window sentence follows "In both panels" but holds only for the right panel (x = ½). In the left panel (x = 0) the points (±h, h²) and the center (0, (1+h²)/2) stay inside [−1, 1] × [−0.5, 1.5] for every listed h (at h = 1 the points are on the edge). Frames 1–4 carry the notes on the right panel only.
- **Evidence:** `indep.py` window loop: the only off-window cases are x₀ = ½ with h = 1, 0.9, 0.8 (point and center) and h = 0.7 (point only); regen log NOTE lines for panel 2 only.
- **Fix:** "In the right-hand panel ($x = \tfrac12$), for $h \ge 0.7$ the right-hand point lies outside the window, and for $h \ge 0.8$ so does the center."

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (22, 53, 67 frames); all run; every GIF byte-identical to what its script produces; every reference in the page folder resolves.

## Claim ledger (whole page; 98 entries; reviewer's verdicts)

- **Description (1–8), Animations introduction (9–25):** confirmed.
- **Case 1 (26–46):** confirmed (item 36 is F1): collocation center and its straight-line approach; radii; faster convergence at x = ½ (1.8e−5 above √2 at h = 0.1); h² term vanishing at x = ±½; monotone radii in both panels; Mathews' h list and window.
- **Case 2 (47–64):** confirmed, including the round-1 wording now in place: the center lies inside the parabola only for |x| < 1/√2, the evolute crosses it at (±√2, 2), and for |x| > 1/√2 the center is outside.
- **Case 3 (65–85):** confirmed (D = 12(1 − cos t) > 0; r = (8/3)|sin(t/2)|; evolute −⅓p(t + π); Example 5's signed radius; widened window holds every circle).
- **Theory and Examples 1–5 (86–98):** confirmed.

## Implementation checks

- **curvatureaa.jl:** circumcircle in 256-bit; asserts agree with independently derived closed forms; limit circles confirmed; frames 1, 4, 22 checked.
- **curvaturebb.jl:** formulas (1)–(4) with exact centers; all 41 titles match to 4 s.f.; the tie-rounding comment (round-1 fix) is accurate; frames 1, 35, 53 checked.
- **curvaturecc.jl:** formulas (6)–(7) with correct derivatives; titles match; frames 1, 36, 56, 67 checked.
