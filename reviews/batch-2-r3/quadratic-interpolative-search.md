# Quadratic Interpolative Search: review, batch 2 round 3

**Result: 0 Error, 0 Misleading, 4 Minor (unverified).** No implementation or drawing errors and no fidelity departures. Both scripts are line-by-line transcriptions of Mathews' subroutines (gr_135, gr_175); the reviewer's independent implementations reproduce every iterate bit for bit; all 20 + 23 rows of the Example 1 and 3 tables match programmatically. Every general statement in the theory sections was checked by the reviewer's own proof (case (ii) ⇒ p₁ < p, case (iii) ⇒ the step jumped over p, the vertex bound, the root choice in (14), which is in fact always the local minimum when D > 0).

The reviewer consulted the archive (module, lnk_4 and lnk_5, subroutine images, graphs gr_209–231 and gr_238–253, the book PDF, the placeholder Quadratic1/Cubic1 pages).

## Findings

### F1. Minor (page match): the |h| cap in rule (7), lines 149–156 and 564

- **Now:** $h_{\text{new}} = \min\{|h_{\min}|, |h_{\min} - h|, |h_{\min} - 2h|\}$, with a note that the three numbers are the distances to p₀, p₁, p₂ only for a step to the right.
- **True:** the subroutine (gr_135: `h = Abs[h]; If[H0<h, h=H0]; If[H1<h, h=H1]; If[H2<h, h=H2]`) computes min(|h|, H0, H1, H2): the old |h| is a fourth candidate. For a bracketed step to the right H1 ≤ |h|/2, so the cap never binds and (7) is exact. For a step to the left (h_min = h(1 + r), r ∈ (−½, ½]) the subroutine gives min(|h|, |h_min|) while (7) gives |h_min|, which differs whenever r > 0. No example takes a leftward step.
- **Fix:** $h_{\text{new}} = \min\{|h|, |h_{\min}|, |h_{\min} - |h||, |h_{\min} - 2|h||\}$, or say "for a step to the right" and note the |h| cap.

### F2. Minor (page match): the all-zero stopping rule, line 158 and algorithm box step 4

- **Now:** "Err is the smallest nonzero e_i found so far, starting from Err = 1, and the search stops when Err ≤ ε".
- **True:** the subroutine also sets Err = 0, and so stops, when e₀ = e₁ = e₂ = 0 (`If[e0==0 && e1==0 && e2==0, Err=0]`); the script reproduces it (`quadraticaa.jl` line 91). Under the page's description such a step would leave Err unchanged.
- **Fix:** add "(or Err = 0 if all three e_i are zero)".

### F3. Minor (page match): Example 3 Step 2, line 282

- **Now:** "p₆ is farther from p (0.0302) than 0.66 is (0.0275)".
- **True:** |p₆ − p| = 0.0301477, which rounds to 0.0301 (0.66 − p = 0.0275445 is right). The page's summary table (3.01 × 10⁻²) and frame 6 (0.03015) agree (`misc.py`).
- **Fix:** 0.0302 → 0.0301.

### F4. Minor (page match): "in both panels", line 31

- **Now:** "whose minimiser is p = √10/5 ≈ 0.6325 (the dashed green line in both panels)".
- **True:** `quadraticaa.jl` line 209 draws the bottom-panel line only when p is inside the zoom window; in frame 3 (k = 1 triple 0.4467, 0.5, 0.5533; zoom about [0.438, 0.562]) the bottom panel has none. All `cubicaa` zoom panels include x − p = 0.
- **Fix:** "(the dashed green line, also in the bottom panel whenever p lies in its window)".

## Inventory (Phase 1)

Scripts and GIFs unchanged since round 1 (no `.jl` or `.gif` change since `f9a2662`); both GIFs byte-identical to their scripts' output (17 and 10 frames). References resolve; no orphans; the index links the page.

## Claim ledger (summary)

All claims confirmed except F1–F4. Highlights:
- **Description:** variant, direction, halve/double/stop rules, vertex formula, restart (F1), stop (F2), cubic formulas against gr_175 and the reviewer's algebra, pair update, p₁ outside [a, b], example pairing.
- **Animations introduction:** p; green line (F4); styling vs gr_209–231 and 238–253; BigFloat zoom; labels gaining digits (0.4467 → 0.63245496 → 0.6324555320336759); held last frames (17 = 15 + 2, 10 = 8 + 2); line-by-line subroutines; table agreement to 17 digits; animations linked from lnk_4 and lnk_5, only placeholder HTML survives; 12 and 8 graphs; new elements; not-animated list.
- **Cases 1 and 2:** every claim confirmed (15 events = 23 − 4 × 2; vertex frames 2, 6, 8, 15; width 1.77e−3; max |Q − f| 1.1086e−9 = 0.0266% of zoom height; 23 calls, Err 5.34e−8, p₁₂; cubic sides, errors, m = 7 α −2.933e−17 and α term 7.6e−6 of panel height, p₇ = float(√10/5), m = 8 F = 0 and −4.19e−28, γ = 1/3, p₈ 8.53e−15).
- **Theory:** unimodal section; bracketing cases (proofs; the Example 3 counterexample to Mathews' p₂ < p); (3)–(6), Q″, vertex bound with equality iff y₂ = y₁; ratios; failure callout; (8)–(14) and the "Which root" callout (including the G > 0 condition); discriminant and β > 0 at every step; book's missing h in G (PDF eq. 20 vs gr_96, gr_175).
- **Examples 1–4:** every step value and table cell, Mathews' listings (gr_158, gr_160, gr_193, gr_204, gr_210–232, gr_239–257), verification tables, thirteen decimals for p₈ — except F3.
- **Comparison and implementation notes:** 400-digit ratios and pass counts, 1.4–1.7 passes per digit, √(2ε/f″), 0/0 at p₉ in both cubic examples.

## Implementation checks

- **`quadraticaa.jl`:** Mathews' `QuadraticSearch` line for line, including the |h| cap and the all-zero Err rule; `check_quad.py` gives identical iterates to 17 digits (Example 3: p₁₂ = 0.6324549647975678, 23 calls, Err 5.343e−8; Example 1: p₉ = 0.4501836113, 20 calls). p exact; zoom in 256-bit arithmetic. Frames 2, 3, 6, 8, 14, 15: Lagrange parabola, vertex and blue point, labels p₃…p₁₂ and q₅,ⱼ/q₁₁,ⱼ, `ydraw` lets Q visibly leave the frame.
- **`cubicaa.jl`:** Mathews' `CubicSearch` line for line, max = 7; `check_cubic.py` reproduces every p_m, F, G, α, γ bit for bit (p₄ = 0.6323728412540951, p₈ = 0.63245553203366733; high-precision α at m = 7 −2.9327e−17). The BigFloat Hermite cubic has its local minimum within 3e−17 of p_m for m = 2…7. Frames 1, 2, 6, 7, 8: slopes use f′ at the red points, P hidden where the page says.
