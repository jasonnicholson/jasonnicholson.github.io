# Review: QR Method (batch 8, round 1)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).** (The reviewer's note on the section-index link to the deleted flat file is not a finding: section-index links are changed in each page's "Add animations" commit.)

Legacy archive consulted: the module HTML, all nine Solution pages as images, the QRmethod, Hessenberg and QRshift program images, the proof PDF; Example 2(a)'s images (gr_43–gr_62) are missing, so that part was checked by computation only. Independent computations: sympy exact factorizations; an own 80-digit QR step built on classical Gram–Schmidt with reorthogonalization (sharing no code with the scripts' Householder `qr`); cell-by-cell table checks.

## Findings

### F1 — Page match (Case 1 alt text) — Minor (unverified): two diagonal entries overshoot, not one

- **Location:** `index.qmd` line 34 (alt text of `qraa.gif`): "the diagonal entries, one of them overshooting, settle on the eigenvalues …".
- **True instead:** d₂ goes 2 → −0.310169 → … → 4.904309 at step 4, above λ₂ = 4.372281, and comes back; d₄ passes λ₄ = −1.372281 at step 1 (−1.386555), falls to −1.581690 at step 2, then rises back (visible in `committed/qraa/frame_044.png`). d₁ only increases; d₃ only decreases from step 1.
- **Evidence:** `ex3.py`: d₄ = 1.000000, −1.386555, −1.581690, −1.472049, …; d₄ decreases only at steps 0 and 1.
- **Fix:** "two of them (d₂ and d₄) overshooting"; optionally add d₄'s dip to the Case 1 Behavior paragraph (the Example 3 bullet on d₄ is already correct).

### F2 — Page match (Case 3 Behavior) — Minor (unverified): not every frame is a step or a deflation

- **Location:** line 46: "Each frame is one shifted step or one deflation."
- **True instead:** the 12 frames are an opening frame (A₁ = H, σ = 0), 5 shifted steps, 2 deflations and a closing "All four eigenvalues found" frame held 3 more times (`qrcc.jl` lines 72–101: :start, :step×5, :deflate×2, :final; contact sheet).
- **Fix:** "After an opening frame showing H, each frame is one shifted step or one deflation; the last frame shows the four stored eigenvalues."

No Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (44, 62, 12 frames); all run; every GIF byte-identical to what its script produces; every reference in the page folder resolves.

## Claim ledger (whole page; 113 entries; reviewer's verdicts)

- **Description (1–6):** confirmed (similarity; ordering by decreasing |λ|; rate |λⱼ₊₁/λⱼ| measured to 6 digits; 5 shifted vs 53 unshifted steps); the 50-digit process claim CND, every value agrees with the 80-digit run.
- **Animations introduction (7–16):** confirmed (one step per frame; log₁₀ colouring; slopes through the last value; 256 bits ≈ 77 digits; positive diag(R); off-band < 1e-60).
- **Case 1 (17–27):** confirmed except the alt text in 27 (F1): d₂ drops to −0.310169 then climbs past λ₂ to 4.904309; d₃ jumps to 4.996724 then falls; |e₂| grows to 3.834 at step 2; ratios within 1 % of 0.6876, 0.5395, 0.5817 from step 10; 3.568e-6 at step 39; diagonal error ratio → 0.4728, 6.410e-12.
- **Case 2 (28–37):** confirmed: Householder frames; every dⱼ monotone and every |eⱼ| decreasing; within 1 % from step 6; 0.5486, 0.4514 to 4.740e-14, 3.397e-18; 0.8229 to 4.334e-6 at step 53 (5.267e-6 at 52); largest diagonal error from d₃ from step 4, ratio → 0.6771, 6.444e-11.
- **Case 3 (38–50):** confirmed except 39 (F2): shifts √2, −0.06023531, 0.0002704376, 0.2915027, −5.291503; |e₃| 0.2 → 0.03406 → 3.195e-5 → 8.279e-17 (0.77, 3.03, 11.59 digits); deflations; the exact zero drawn as a triangle.
- **QR decomposition, Examples 1–2 (51–61):** confirmed (Gram–Schmidt steps; Q, R exact and decimal; Mathews' radical forms simplify to the page's); 50-digit residual claim CND (exact residuals 0).
- **QR method, Example 3 (62–83):** confirmed (algorithm; theorem; the [[0,1],[1,0]] case; all 126 table cells; Mathews' A₄₀; directions of every dⱼ and eⱼ; verification 2.7e-6).
- **Householder, Example 4 (84–94):** confirmed (exact P₁, A₁, P₂, H; ratios; all table cells; directions).
- **Shifts, Example 5 (95–104):** confirmed (Wilkinson shift; Mathews' program; table; digits gained 0.8, 3, 11.6 vs 0.085; λ₃ error 6.4e-8 and its recovery; textbook Ex 11.9 comparison).
- **Least squares, Examples 6–7 (105–112):** confirmed (power sums; c = (−14/5, 138/35, −4/7); ranks 3 and 4; R and QᵀB; residuals; Mᵀd = 0).
- **Links (113):** confirmed.

## Implementation checks

- **qraa.jl:** plain unshifted QR with positive diag(R); e, derr and final ratios identical to the independent run; frames 2 and 44 checked; colour range clips nothing.
- **qrbb.jl:** Householder with α = −sign(x₁)‖x‖ as in Mathews, then unshifted QR; H asserted exact; values at step 53 identical; frames 3, 5, 62 checked.
- **qrcc.jl:** faithful transcription of Mathews' QRshift; shifts, running sums, subdiagonal history and eigenvalue errors identical; frames 4, 6–9 checked.
