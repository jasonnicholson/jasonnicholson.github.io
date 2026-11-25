# Review: Earthquake Model (batch 6, round 2)

**Findings: 0 Error, 0 Misleading, 0 Minor.** Calibration page for this round: the reviewer worked on a scratch copy with two planted errors in the Case 1 Behavior paragraph (the second floor's amplitude 0.3884 ft changed to 0.3844, and "moves with floors 5 and 6 and against floors 1 to 4" swapped) and reported both as Errors from its own computations (v₂ = −0.38841678; v + e = (−0.165, −0.313, −0.290, −0.106, +0.136, +0.303), confirmed in frame 16). It found nothing else on the page, so that review stands as the Earthquake round-2 review, with the planted findings removed.

This was a fresh, independent review: the reviewer read no earlier review or fix record. Legacy archive consulted (module, lnk_3, lnk_4, images gr_12 … gr_89); no earthquake animation in the archive. Independent computations: numpy and 40-digit mpmath eigensolves, direct and modal solves, brentq band edges, SciPy DOP853, grid scans.

## Findings

None. (Cosmetic notes, not findings: the P₅ and P₆ shaded bands in Case 3 are only 2–4 px wide and almost hidden under the curve; in Case 2 the frame just below ω₄ shows floor 3 moving most, while the page's "floor 1 as ω → ω₄" is a limit statement.)

## Inventory (Phase 1)

4 scripts, 4 GIFs (111, 256, 223, 97 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 135 entries; reviewer's verdicts)

- **Description (1–6), Animations introduction (7–29):** confirmed.
- **Case 1 (30–42):** confirmed apart from the two planted sentences: period 2.992, 3.342 oscillations; relative signs; fifth floor least 0.06094; crossings; |v₂ + e| = 0.3134 = 4.179e; ordering 0.3134 > 0.3029 > …; fourth floor least 0.1060; alt text.
- **Case 2 (43–58):** confirmed, including the round-1 wording now in place: at ω = 6 all vᵢ < 0 with vᵢ/g in [−1, −0.5004], and in fixed coordinates every floor moves less than half as far as the ground, 0.4998e down to 0.0078e.
- **Case 3 (59–69), Case 4 (70–76):** confirmed.
- **Model and Example 1 (77–91), forcing (92–99), Example 2 (100–114, including the row residuals within 9 × 10⁻⁶), Example 3 (115–135):** confirmed.

## Implementation checks

- **earthquakeaa.jl:** direct solve; v identical to own solve and to Mathews' gr_56; RK8 reproduces v cos 2.1t to 7e−13; frames 16 and 101 checked.
- **earthquakebb.jl:** above-window frames, differences, g values identical; drawing clamp honest; frames 28, 29, 241 checked.
- **earthquakecc.jl:** band edges identical to brentq; frame 208 checked.
- **earthquakedd.jl:** closed-form modes, residual 1.42e−14; frame 1 checked.
