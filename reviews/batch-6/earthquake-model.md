# Review: Earthquake Model (batch 6, round 1)

**Findings: 0 Error, 0 Misleading, 3 Minor (unverified).**

Legacy archive consulted: the module text, Links lnk_2–lnk_4, images gr_4–gr_89 as listed in the reviewer's notes; `a2001/Animations` holds no earthquake material. Independent computations: the modal formula (6) with closed-form eigenpairs (a route separate from the scripts' direct solves), exact rational sympy solves, 40-digit mpmath eigenvalues, SciPy DOP853, Brent root-finding on fine scans.

## Findings

### F1 — Page match — Minor (unverified): the row-residual bound is stated too tightly

- **Location:** `index.qmd` line 296: "The rows agree with $-0.33075$ to within $8 \times 10^{-6}$".
- **True instead:** row 3 from the six-figure **v** is 8(−0.388417) − 11.59(−0.364495) + 8(−0.180990) = −0.33075895, which is 8.95e-6 from −0.33075; the page's own table prints −0.330759.
- **Evidence:** `chk2.py`: rows −0.330754, −0.330743, −0.330759, −0.330743, −0.330752, −0.330751; max deviation 8.95e-6.
- **Fix:** "to within $9 \times 10^{-6}$" (or $10^{-5}$).

### F2 — Page match — Minor (unverified): "every floor moves against the ground" at ω = 6 uses a different sense from Case 1

- **Location:** line 48 ("where the first floor moves most and every floor moves against the ground ($v_i/g$ between $-1$ and $-0.5004$)") and the alt text, line 52.
- **True instead:** every v_i < 0 (relative to the ground), and v/g lies in [−1, −0.50037]. But Case 1 uses "with/against the ground" in fixed coordinates (the sign of v_i + e). In that sense, at ω = 6, **v** + e = (−0.0375, +0.0187, −0.0093, +0.0045, −0.0021, +0.0006): floors 2, 4, 6 move *with* the ground and the building above floor 1 is nearly still, the **v** → −e**b** limit the same sentence invokes.
- **Fix:** e.g. "every floor moves opposite to the ground *relative to it* ($v_i<0$, $v_i/g$ between $-1$ and $-0.5004$); in fixed coordinates the floors above the first barely move", with the same change in the alt text.

### F3 — Implementation (script comment) — Minor (unverified): bisection brackets described wrongly

- **Location:** `earthquakecc.jl` lines 52–53: "bisection on g(p) = 0.3 between the natural period and the local minima of g on either side".
- **True instead:** lines 69–77 bracket at the halfway points between neighbouring natural periods (far ends 0.62 and 13.0), as the comment at lines 69–70 says. No effect on results (asserts hold; band edges match Brent).
- **Fix:** "between the natural period and the halfway points to its neighbours".

No Fidelity findings: all three Mathews examples reproduced with his parameters, windows, ranges, plot points and colours; the departure from his printed (ω²I − **a**) is explained and matches his code and numbers.

## Inventory (Phase 1)

4 scripts, 4 GIFs (101, 256, 223, 97 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; reviewer's verdicts)

- **Description (D1–D6):** confirmed (model, negative eigenvalues, forcing, (5), singular exactly at natural frequencies, Mathews' three examples).
- **Animations introduction (A1–A17):** confirmed (no Mathews animation; k/m = 8, e = 0.075; colours; automatic range replaced by [0.5, 6.5] holding every curve; **v** cos ωt from rest (DOP853 7.2e-13); frame counts; triangle at the top edge with true g; Case 3 windows; band shading; Case 4 scaling).
- **Case 1 (1a–1m):** confirmed (period 2.992, 3.342 cycles; signs relative and fixed; 0.3884, 0.06094, 0.3134 = 4.179e, 0.3029, 0.1060; crossings).
- **Case 2 (2a–2r):** confirmed except 2o and its alt text (F2): static shape (6, …, 21)/21; differences 0.0556, 0.00122 … 0.146; sign flip against each mode; nine frames above the window; sixth resonance narrowest; g(6) = 0.1125.
- **Case 3 (3a–3l):** confirmed (g at 0.65 and 0.6283; band widths 0.0145 … 0.408 and 2.955 (7.600–10.55); 2.992 inside the P₂ band; g(11) = 0.2198).
- **Case 4 (4a–4k):** confirmed (sign changes, ratios 2.942 … 8.055, sin(mπ/13)/sin(6π/13) entries, largest-entry floors 6, 2, 4, 1, 5, 3).
- **Model and Example 1 (M1–M15):** confirmed (all 18 table values and 36 mode entries to 40 digits; residual 1.42e-14).
- **Forcing and Example 2 (F-a–F-u):** confirmed except F-s (F1): Mathews' +**a** in code vs his text; 0.0736 with −**a**; modal coefficients; verification rows; residual 1.1e-16; RK8 7.2e-13.
- **Example 3 (E1–E23):** confirmed (single minimum between asymptotes; minima table; small-ω approximation; monotonicity; band table by Brent; g(10⁴) = 0.0750000).

## Implementation checks

- **earthquakeaa.jl:** direct solve with Mathews' +**a**; **v** agrees with an exact rational solve to 1.1e-16; frames 1, 16, 101 checked.
- **earthquakebb.jl:** g(ω), nearest-mode differences and above-window frames identical to the modal computation; NaN breaks at each ω_j; clamping only for drawing with the true g in the title.
- **earthquakecc.jl:** band edges match Brent to every printed digit; frames 1, 68, 208 checked; comment inaccurate (F3).
- **earthquakedd.jl:** closed-form modes, residual 1.42e-14; frames 1 and 97 checked.
