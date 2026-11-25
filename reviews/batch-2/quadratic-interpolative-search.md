# Quadratic Interpolative Search: review, batch 2 round 1

**Result: 0 Error, 0 Misleading, 3 Minor (unverified by an independent checker; F2 checked by the director).** No implementation or drawing errors. Both scripts are line-by-line transcriptions of Mathews' subroutines (gr_135, gr_175), and every number in every table, worked example, Behavior paragraph and alt text matches the reviewer's independent recomputation.

The reviewer consulted the archive: the module HTML, the four solution pages and their images (gr_136–gr_258), the proof PDF (book §8.1), and the `Quadratic1/` and `Cubic1/` animation HTML pages.

## Findings

### F1. Minor (page match: what Mathews' Example 3 solution shows), line 272

- **Now:** "His solution prints the points in the order of the table below and interleaves the printed lines with graphs of f that mark the current points."
- **True:** Mathews' printed listing (gr_210–gr_233) prints, for each outer step, the trial points of the bracketing loop and then the bracketed triple: p₀, p₁, p₂ = 0, 0.5, 1; q₅,₀ = 0.66, q₅,₁ = 0.87333333; p₃, p₄, p₅ = 0.44666667, 0.66, 0.87333333; p₆, p₇, p₈; q₁₁,₀ … q₁₁,₄; p₉, p₁₀, p₁₁; p₁₂. He never prints the pre-bracketing points 0.5 and 0.5533 (k = 1) or 0.66 and 0.6882830056 (k = 3), and does not print the vertex before the trial points. (His Example 3 listing also differs in order from his own subroutine image gr_135; his Example 1 listing follows gr_135.) The next claim, that every printed point and value agrees with this run (line 327), is correct (all 19 printed lines checked).
- **Fix:** "His solution prints, for each outer step, the trial points of the bracketing loop and then the bracketed triple p₃ₖ, p₃ₖ₊₁, p₃ₖ₊₂ (it does not print the triple before bracketing), and interleaves the lines with graphs of f."

### F2. Minor (page match: general claim in the "Which root (general)" callout), line 408

- **Now:** "Form (14) is the root that stays finite as α → 0. In that limit P is a quadratic and γ = −h f′(p₀)/G …"
- **True:** as α → 0 the denominator of (14) tends to G + |G|. For G > 0, (14) tends to −h f′(p₀)/G as stated; for G < 0 the denominator tends to 0 and (14) diverges, and the finite root is the other one (the maximum of a concave quadratic). Reviewer: (11)–(13) verified with sympy (residuals 0); (14) with G = −1, h = 1, f′(p₀) = 1 gives γ = 33.3, 3333, 333333 for α = 10⁻², 10⁻⁴, 10⁻⁶ (`reviewer/sym.py`). That (14) picks the local minimum (β > 0) holds at every step of both examples (β = 0.123, 0.719, 1.8e−8, 1.46e−13 and 0.341, 1.12, 0.189, 0.042, 1.81e−8, 9.55e−12, 8.4e−28; discriminant positive throughout).
- **Fix:** "When G > 0, form (14) is the root that stays finite as α → 0 …"

### F3. Minor (page match: conditions of the 400-digit experiment), line 557

- **Now:** "… need more and more halvings or doublings: 2, 6, 19, 34, 76, 156 in Example 1 and 2, 0, 5, 8, 13, 39, 82, 164 in Example 3."
- **True:** line 158 limits each bracketing loop to 50 passes, and the examples use δ = ε = 10⁻⁶; under those settings the subroutine cannot make 76, 82, 156 or 164 passes and would stop at Err ≤ 10⁻⁶ long before. The reviewer reproduced every count exactly, but only with no pass limit, δ = 0 and no ε stop (`reviewer/rates.py`).
- **Fix:** add "(with δ, ε and the 50-pass limit removed)" to the 400-digit sentence.

## Inventory (Phase 1)

- Scripts `quadraticaa.jl`, `cubicaa.jl`; each ran from a scratch copy and produced a GIF byte-identical to the committed one (17 and 10 frames).
- The page links and embeds exactly these; no orphan files; the section index links the page.
- Packages: Plots, Printf.

## Claim ledger

C = confirmed, W = wrong (minor).

**Description:** Mathews' variant (equally spaced p₀, p₀ + h, p₀ + 2h from p₀ = a, h = (b − a)/2; direction from the sign of f′(p₀); halve while f(p₀) ≤ f(p₁), double while f(p₂) < f(p₁), stop at f(p₀) > f(p₁) ≤ f(p₂)) C (gr_135); vertex formula h_min = h(4y₁ − 3y₀ − y₂)/(2(2y₁ − y₀ − y₂)) C (also derived independently); restart and stopping rule C; cubic γ, F, G, α and pair update C (gr_175); p₁ outside [a, b] in both cubic examples (−0.3171, −0.5) C; example pairing C.

**Animations introduction:** f, p = √10/5 ≈ 0.6325, dashed green line in both panels C (absent in quadratic frame 3's zoom because the zoom does not contain p; inherent, not a finding); styling C; bottom panel in high precision C; labels gain digits (4 → 8 quadratic, up to 16 cubic), last frame held, 17 and 10 frames C; scripts run the subroutines line by line, agree with the Example 3 and 4 tables C; two animations, GIFs lost, 12 and 8 graphs in Mathews' solutions C; Examples 1 and 2 and the secant comparison not animated C.

**Case 1:** heading C; 15 events = 23 table rows with triples grouped (4 + 7 + 4) C; pink span and bottom-title test C (frames 1–15); vertex frames (2, 6, 8, 15) C; k = 0, 2 bracket at once, k = 1 doubles to 0.66 and 0.8733, k = 3 halves five times to h = 8.838e−4 C; triple width 1.77e−3 C; last frame max |Q − f| = 1.11e−9 = 0.0266% of panel height C; 4 vertex steps, 23 calls, Err = 5.34e−8, p₁₂ = 0.63245496, error 5.67e−7 C; wiring and alt text C.

**Case 2:** `CubicSearch[0, 1, 7]` C; frame 1 p₀ = 0, p₁ = −0.5 (h₀ = −0.49999999999999989 in double) C; frames m = 2–8 C; slope segments C; P with its local minimum at p_m for m = 2–6 (within 4e−16) C; window and x − p axis C; p₂, p₃ on opposite sides C; alternation from p₄, errors 8.27e−5, 1.94e−6, 1.29e−14 C; m = 7 α = 6.6956e−17 in double, −2.9327e−17 in high precision, P in zoom only at 6.3e−6 of panel height, p₇ the double nearest p C; m = 8 F = 0 in double, −4.19e−28 in high precision, γ = 1/3, no cubic, p₈ error 8.53e−15 C; alt text and wiring C.

**Unimodality section:** f″ = 2 + sin x ≥ 2, f′(0) = −1, f′(1) = 1.4597, p = 0.4501836113, f(p) = −0.2324655752; f″ = 20x³, f′(0) = −0.8, f′(1) = 4.2, p = (4/25)^¼ = 0.6324555320, f(p) = 0.0952284595: C.

**Quadratic search section:** cases (i)–(iii), evaluations, ties, δ stop C; text h = 1 or ½ vs subroutine (b − a)/2 C (book p. 417, gr_26–28); equations (3)–(6) C; vertex property and bound C; ratios 0.128, 0.105, 0.418 and 0.107, 0.270, 0.490, 0.165 C; failure callout C; rule (7), fallback, |h| caveat, all outer steps go right C; Err definition, 50/50 limits, f′ used for its sign only C; algorithm callout and labelling C.

**Example 1:** steps 1–6, every value C; 20 event rows (0 mismatches) C; summary table C; 20 calls C; remarks on Mathews' listing (stale f(p₀) = −0.2322143232) C (gr_157, gr_135); verification (2.0e−11, 4.9e−22, f′ = −4.9e−11, all triples contain p) C; `FindMinimum` result C.

**Example 3:** steps 1–4, every value (including p₆ farther from p than 0.66, Err unchanged at k = 2) C; 23 event rows (0 mismatches) C; summary table and 23 calls C; print-order sentence **W (F1)**; "every point and value printed agrees" C; verification and ½f″(p) = 2.53 C.

**Cubic search section:** starting step (8), h₀ < 0 C; (9), (11)–(14) symbolically C; book omits h in G C (PDF eq. 20); P″(p₂) = 2β/h² and the two critical points C; "(14) stays finite as α → 0" **W (F2)**; discriminant and β > 0 at every step C; algorithm callout and "p₁ = b" in the module statement C.

**Example 2:** step 1 and step 2 values (discriminant 0.0602863403, root 0.2455327682, γ = −1.4202625104, p₂ = 0.4503056342) C; other root γ = 14.22 at x = −4.509 a local maximum C; next h C; table m = 0–5 C; sides C; rounding remark (400-digit p₄ error 7.8e−17 vs 1.13e−15 in double) C; Mathews' listing (gr_158) C; f′(p₅) C; secant table (also gr_200) C; secant 1e−13 at p₆ vs cubic 1e−15 at p₄ C.

**Example 4:** steps 1–3 (G < 0 from concavity, G − 3α = 0.125, discriminant 0.465625) C; table m = 0–8 including noise rows (bit-for-bit with the reviewer's Python run) C; error 1.3e−14 at p₆, F = 0 at p₈, fourteen decimals at p₈ C; Mathews' printed values (gr_239–gr_254) C; verification C.

**Comparison and Implementation Notes:** comparison table C; cubic ratios 2.103/1.979/2.025 and 2.094/1.953/2.023 C; secant ratios to 1.62 C; quadratic ratios C; pass counts C only with limits lifted (**F3**); 1.4–1.7 passes per digit C; notes on direction, step rule, bracketing check, √(2ε/f″) estimate, start outside [a, b], concave region C; 0/0 at p₉ in both examples when continued C.

## Implementation checks

- **`quadraticaa.jl`:** line-by-line `QuadraticSearch` (gr_135): f′ sign test, halving when Y₀ ≤ Y₁ else doubling when Y₂ < Y₁, H_min, the H₀/H₁/H₂ rule after h = |h| with the h = 0 fallback, Err as minimum nonzero e_i, Kmax = Jmax = 50; f = 0.5 + x⁵ − 0.8x. Independent `qs.py` gives the same 15 events bit for bit (p₆ = 0.60230784492522105, p₁₂ = 0.6324549647975678, Err = 5.343e−8, 23 calls). p = √10/5 exact in BigFloat. Frames 1–17: Q is the Lagrange parabola through the triple, open circle at (p_min, Q(p_min)), blue dot at (p_min, f(p_min)), span fill correct, `ydraw` only lets Q visibly leave the top panel, zoom always contains the triple.
- **`cubicaa.jl`:** line-by-line `CubicSearch` (gr_175) with h₀ = 2(f(b) − f(a))/f′(a). Script output matches the reviewer's for p₂–p₈ and F, G, α, γ at every step, including the noise steps (p₈ = 0.63245553203366733, α at m = 8 = −8.378689e−28 in both; high-precision α at m = 7 −2.932658e−17 vs −2.9327e−17, F at m = 8 −4.185517e−28 vs −4.1855e−28). The Hermite cubic in BigFloat has its local minimum at p_m (offsets ≤ 4e−16, P″ > 0); slopes use true f′; the m = 7/8 noise logic matches the relative errors. Frames 1, 2, 6, 7, 8 as described; green reference line (#027F02) present in all zoom panels.
