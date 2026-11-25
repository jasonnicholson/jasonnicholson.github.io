# Quadratic Interpolative Search: review, batch 2 round 2

**Result: 1 Error (independently confirmed), 0 Misleading, 1 Minor (unverified).** No implementation or drawing errors.

This page was the round 2 calibration pilot. The reviewer worked on a scratch copy with two planted errors in the Case 2 Behavior paragraph (line 47: "p₂ and p₃ lie on the same side of p", true: opposite sides; and an error of 1.97 × 10⁻⁶, true: 1.94 × 10⁻⁶). It reported both as Errors with its own computations and frame evidence, so the brief was not changed. Those planted findings are omitted below; the real page's sentences say "opposite sides" and 1.94 × 10⁻⁶, which the reviewer's independent run confirms (signs of p_m − p for m = 2…8: −, +, −, +, −, +, −; |p₅ − p| = 1.9427 × 10⁻⁶). Line numbers are the real page's, which match the copy.

The reviewer consulted the archive (module HTML, Links pages, subroutine listings gr_135 and gr_175, Example 1–4 listings and graphs, the book PDF, the animation HTML stubs).

## Findings

### F1. Error (method description; inherited from Mathews), line 88 — independently confirmed

- **Now:** "**Case (ii):** if $f(p_0) > f(p_1)$ and $f(p_1) > f(p_2)$, then $p_2 < p$ and the points must reach farther right."
- **True:** for unimodal f and h > 0, f(p₁) > f(p₂) implies only p₁ < p (if p₁ ≥ p, f would be non-decreasing on [p₁, p₂]). Nothing forces p₂ < p. Simple counterexample: f = (x − 0.5)², p₀ = 0, h = 0.3 gives values 0.25, 0.04, 0.01 with p₂ = 0.6 > p.
- **The page's own counterexample:** Example 3, outer step k = 1, second doubling pass on the triple (0.4466667, 0.5533333, 0.66): f = 0.160446 > 0.109205 > 0.0972333, so case (ii) applies and h is doubled, yet p₂ = 0.66 > p = 0.6325. Line 282 describes this pass; frame 4 of `quadraticaa.gif` shows "case (ii), double h" with the blue point at 0.66 right of the green p line.
- **Archive:** the statement is Mathews' (module image gr_30 reads "p₂ < p"); the archive is not ground truth.
- **Independent check:** a fresh checker given only the allegation reproduced it by its own proof and run (`verify/case2_check.py`): confirmed, Error is the right severity (a false mathematical implication contradicted by the page's own example and animation; the doubling action itself is still sound).
- **Fix:** "then $p_1 < p$: the minimum lies to the right of $p_1$, so the points must reach farther right." Optionally: "(Mathews writes $p_2 < p$, which need not hold: in Example 3 the triple $(0.4467, 0.5533, 0.66)$ is doubled although $0.66 > p$.)"

### F2. Minor (page match, unverified), line 531

- **Now:** "$p_8$ still agrees with $p$ to fourteen decimals".
- **True:** p₈ = 0.63245553203366733, p = 0.632455532033675866…; |p₈ − p| = 8.53 × 10⁻¹⁵ > 0.5 × 10⁻¹⁴. Rounded to 14 decimals they are 0.63245553203367 and 0.63245553203368, so they agree to 13.
- **Fix:** "agrees with $p$ to thirteen decimals (error $8.5 \times 10^{-15}$)".

## Inventory (Phase 1)

Scripts and GIFs unchanged since round 1 (`git diff f9a2662 HEAD` shows no `.jl` or `.gif` change); round 1 regeneration stands: both GIFs byte-identical to what their scripts produce (17 and 10 frames). References resolve; no orphans; the index links the page.

## Claim ledger (summary; ✓ confirmed by the reviewer's own computation or frames)

- **Description (lines 12–27):** Mathews' variant, vertex formula (re-derived; script line 78 identical), restart and stop rule (equivalent to Err as running minimum; right-step qualification at line 156), cubic γ, F, G, α (gr_175, module images, script lines 64–70), pair update and p₁ outside [a, b] (−0.317, −0.5), example pairing: ✓.
- **Animations introduction (lines 31–35):** function and p, dashed green line (absent from quadratic frame 3's zoom only because p lies outside that window), panel styling vs Mathews' graphs (gr_209/219/231/238/247/253), BigFloat zoom, labels gain digits, held last frame (17 = 15 + 2, 10 = 8 + 2), bitwise agreement with the tables, both GIFs lost, 12 and 8 Mathews graphs, Examples 1 and 2 and the secant comparison not animated: ✓.
- **Case 1:** every claim ✓ (15 events = 4 triples + 2 doublings + 5 halvings + 4 vertices = 23 table rows; vertex frames 2, 6, 8, 15; triple width 1.7677e−3; max |Q − f| 1.11e−9 = 0.027% of panel; 23 calls, Err 5.34e−8, p₁₂ = 0.63245496, 5.67e−7 from p; wiring and alt text).
- **Case 2:** every claim ✓ on the real page (frames m = 1…8; P with local minimum within 3.4e−16 of p_m, P″ > 0; sides; errors 8.27e−5, 1.94e−6, 1.29e−14; m = 7 α 6.695557e−17 vs −2.9327e−17, α term 6.3e−6 of panel; p₇ the nearest double, p₇ − p = 1.6e−17 < half ulp 5.55e−17; m = 8 F = 0, high-precision −4.1855e−28, p₈ 8.53e−15 from p; alt text and wiring).
- **Unimodal section:** ✓.
- **Quadratic theory (lines 71–173):** all ✓ except case (ii) "p₂ < p" **✗ (F1)**; equations (1)–(7) re-derived; vertex-property callout; ratios at line 140; failure callout; Err and limits; algorithm box; labelling.
- **Example 1:** steps 1–6, 20-row table, summary, 20 calls, Mathews' listing notes (gr_158), verification, FindMinimum (gr_160): ✓.
- **Example 3:** print order at line 272 (gr_210–232), steps 1–4, 23-row and 4-row tables, agreement with Mathews, verification, 8.14e−13 estimate: ✓.
- **Cubic theory (lines 345–434):** (8)–(14) re-derived, book's missing h in G (PDF eq. 20), "Which root" callout including the G > 0 condition, discriminant and β > 0 at every step, algorithm box, p₁ = b in Mathews' statement (gr_166): ✓.
- **Example 2:** all values and table, other root γ = 14.2218 at x = −4.5092 with P″ = −2.44, sides, Mathews' listing (gr_193), secant table (gr_204): ✓.
- **Example 4:** steps and table ✓; "fourteen decimals" **✗ (F2)**; Mathews' p₀–p₈ (gr_239–254) and verification ✓.
- **Comparison and implementation notes:** comparison table, cubic ratios 2.10/1.98/2.02 and 2.09/1.95/2.02, secant 1.62, quadratic ratios (including 1.99), pass counts with limits lifted, 1.4–1.7 passes per digit, stopping notes, 0/0 at p₉ in both cubic examples: ✓.
- **Could not determine:** whether Mathematica's machine evaluation of f agrees bitwise with Julia's at the last-rounding level (Example 4 p₇, p₈); agreement with every printed Mathews value is confirmed.

## Implementation checks

- **`quadraticaa.jl`:** line-by-line `QuadraticSearch` (gr_135) as the page describes; the reviewer's independent `indep.py` gives bitwise-identical events (p₁₂ = 0.6324549647975678, 23 calls, Err 5.343e−8, all 15 events = `regen/quadraticaa.out`), also matching Mathews' printout. p = √10/5 exact; f − f(p) in BigFloat. Frames 1, 2, 4, 6, 14, 15 and the sheet: span, Lagrange parabola, vertex and blue point, labels, test strings, `ydraw` only on parabola tails, zoom keeps the triple visible.
- **`cubicaa.jl`:** line-by-line `CubicSearch` (gr_175), m_max = 7; bitwise identical to the independent run for every p_m, F, G, α, γ and discriminant (p₈ = 0.63245553203366733), matching Mathews' gr_239–254. High-precision F and α recomputed independently. The Hermite cubic is P of (9), minimum at p_m within 3.4e−16; slope segments use f′; noise flags switch P off correctly; titles report the right indices and values.
