# Review: Frobenius Series Solution (batch 9, round 1)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).** Calibration page: the reviewer worked on a scratch copy with two planted errors in the Case 1 Behavior paragraph (x* = 7.319 written as 7.139, and "widens" written as "narrows") and reported both as Errors from its own computations (see the README). The planted findings are not reported; the committed page's versions were confirmed by the same reviewer (x* = 7.3189317 at N = 20 for y₁; x* rises monotonically with N for both solutions, and the green band visibly widens from frame 1 to frame 11).

Legacy archive consulted: `FrobeniusSeriesMod.html`, Links lnk_1–12, surviving images (gr_68, 145, 219, 330, 382, 479, 487, 498, 500, 523, 529, 530); the partial-sum and Example 9 graphs are lost; no animation for this module. Independent computations: sympy series of the closed forms, own implementation of recurrence (5), 40- and 120-digit mpmath x* scans with root refinement, mpmath/scipy Bessel zeros and extrema.

## Findings

### F1 — Page match — Minor (unverified): Case 2 quotes a rim value the animation never shows

- **Location:** `index.qmd` line 40: "Between $\lambda_1$ and $\lambda_2$ the rim value reaches $J_0(3.8317) = -0.40276$."
- **True instead:** correct for continuous λ, but the animation steps λ by 0.2, so its most negative rim value is at λ = 3.8: frame_027 is titled "J₀(λ) = −0.4026" (−0.40276 to 4 s.f. would be −0.4028).
- **Evidence:** `drum.py`: J₀(3.8317) = −0.4027594; minimum over the 0.2-step sweep between λ₁ and λ₂ is −0.402556.
- **Fix:** add "(the frame at λ = 3.8 shows −0.4026)", or "comes within 0.0002 of its minimum J₀(3.8317) = −0.40276".

### F2 — Page match — Minor (unverified): Case 3's "pink rises while cyan falls" holds only half the time

- **Location:** line 48: "Neighbouring regions between them move in opposite directions: pink rises while cyan falls."
- **True instead:** colour marks the sign of u = J₀(λₙr) cos φ; pink is rising only when sin φ cos φ < 0 (second and fourth quarters). In the first and third quarters pink falls and cyan rises; at t = 0 the pink centre starts moving down. Script and frames (1, 7, 13) are correct.
- **Fix:** "… move in opposite directions: when pink rises, cyan falls, and vice versa."

No implementation and no Fidelity findings.

## Inventory (Phase 1)

3 scripts, 3 GIFs (13, 110 and the Case 3 surface animation); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 112 entries; reviewer's verdicts)

- **Description (1–6):** confirmed (Frobenius form, indicial equation, root differences ½, 3/2, 1, 0, 2; J₀, 2J₁; J₀′ = −J₁); the 30/40-digit process claim CND, all resulting numbers confirmed.
- **Animations introduction (7–13):** confirmed (pink/cyan as Mathews' gr_530; no module animation; Newton from nπ in 256-bit, as Mathews' FindRoot gr_498).
- **Case 1 (14–28):** confirmed (both planted sentences excluded): x* for y₁ 0.1292 … 7.319 and y₂ 0.01587 … 6.939; increments ≈ 0.76 from N = 8; y₂'s x* smaller for every N; sign of S_N − y by N mod 4 (120-digit check); only S₀ for y₂ re-dips (6.213 < x < 6.354).
- **Case 2 (29–39):** confirmed except 36 (F1): pauses at 2.405 … 14.93; sign change at each zero; nodal radii in titles; windows.
- **Case 3 (40–49):** confirmed except 43 (F2): flat at T/4 and 3T/4, inverted at T/2; radii 0.4357, 0.2779, 0.6379; periods 2.613, 1.138, 0.7261; ratios 2.2954, 3.5985.
- **Background and method (50–59):** confirmed (definitions, recurrence (5) reproduced independently, Example 1's division by F(½) = 0, theorem, ρ = ∞, lost plots); attribution of Mathews' proof-page statement out of scope.
- **Examples 1–5 (60–92):** confirmed (all coefficients, closed forms by residual or 50-digit comparison, Bessel forms, 2γ/π = 0.36747, xY₁ → −2/π, every x* table).
- **Example 6 and the drum (93–112):** confirmed (J₀/J₁ series, turning points 3.8317 … 13.3237 with values, Y₀(0.01) = −3.0055, zeros table and Mathews' six-figure values, mode table, ratios, Example 9 extrema, radius 0.435651).

## Implementation checks

- **frobeniusaa.jl:** recurrence (6) in `Rational{BigInt}`, asserted against the closed forms; all 22 x* values match mpmath to every printed digit; frames 1, 5, 11 checked; ydraw clamping with true-value labels.
- **frobeniusbb.jl:** Newton x ← x + J₀/J₁ from kπ; zeros match mpmath `besseljzero` and scipy; 80 distinct frames plus 30 holds; λ = 3.8 label matches J₀(3.8) = −0.402556.
- **frobeniuscc.jl:** same zeros; periods and radii match; exact quarter-period phases; surface masked outside r ≤ 1.
