# Review: Milne-Simpson's Method (batch 1, round 2)

**Result: 0 Error, 0 Misleading, 1 Minor** (unverified, as the review skill allows for Minor findings). This was a fresh, independent review; no earlier report was read.

Every number and behaviour claim on the whole page was checked independently: the Description, the Animations, the derivation, the theorems, the error estimate, the Algorithm, the weak-stability callout, Examples 1–4 and their tables, and the Implementation Notes. Both scripts run Mathews' unmodified PECE Milne-Simpson method with an RK4 start.

The legacy archive was consulted: the module text, the surviving images, the Mathematica subroutine (gr_41) and all 22 distinct frames of `Milneaa.gif`. No departure from it lacks a stated reason.

## Findings

### F1. Minor (page match, notation): computed values labelled as exact
- **Where:** lines 339–341, "All 51 computed values agree with the list printed in Mathews' notebook to its six significant digits ($y(0.5) \approx 5.58938$, $y(1) \approx 5.96763$, and $6.00000$ from $t = 2.7$ on)."
- **The notation:** line 234 defines $y(t_k)$ as the exact solution. The values 5.58938 and 5.96763 are the computed $y_5$ and $y_{10}$.
- **The exact values:** $y(0.5) = 6 - 5e^{-2.5} = 5.589575$ and $y(1) = 5.966310$. Read literally, the sentence gives the exact solution wrongly in the 4th and 3rd decimal places.
- **Fix:** write $y_5 \approx 5.58938$ and $y_{10} \approx 5.96763$.
- **Same pattern elsewhere:** line 303 has "$y(5) \approx 0.20924945$" for the computed $y_{50}$. The exact value is 0.20924948, so this is harmless at that precision, but it can be relabelled $y_{50}$ for consistency.

## Unresolved

None.

## Inventory (Phase 1)

- **Scripts:** `milneaa.jl`, `milnebb.jl`.
- **GIFs:** 23 frames decoded (21 distinct) and 58 frames decoded (50 distinct).
- Every file is referenced by the page and no reference is missing. The section index links the page.
- Both GIFs regenerate byte-identically.

## Claim ledger (whole page): about 120 entries

All are confirmed except F1. Highlights:

**Description and Animations introduction**
- The formulas match both scripts and gr_41.
- The local error is $O(h^5)$ and the global error $O(h^4)$ (`lte.py`).
- All 11 examples are accounted for. gr_169–189 are absent.

**Case 1**
- The reference 0.00811992046 agrees across DOP853, Radau and an mpmath Taylor solver. The drawn curve is within 3e-12 of it.
- Mathews' window, from pixel scale: about −0.20 to 1.73.
- The run minima for m = 12, 14 and 16 are −0.751, −0.652 and −0.757. The global range is −0.75713 to 1.92707.
- All 21 of Mathews' values match.
- Up to t = 2.5 the error is within 5e-4 (the worst is 4.90e-4).
- The first crossings of 0.01 fall between 3.214 and 4.911.
- The list of negative runs is exact.
- The non-monotone pairs are exact.
- The largest error for m = 40–56 is 0.08120.
- From m = 60 on, the error is at most 3.53e-3.
- At m = 60: −1.105e-5 and 3.530e-3 at 4.9167.
- The largest errors for m = 100, 120 and 150: 3.395e-6, 1.342e-6 and 4.41e-7.
- In the tail, every m ≤ 56 reverses direction 2–8 times.

**Case 2**
- The stability edges are −0.844270 and −0.300000, and ρ(−0.5) = 0.776.
- The h = 0.1 run: −3.298e-3 at t = 0.6, then 2.2454e-8 at t = 5.
- The h = 0.05 run:
  - alternates from k = 12;
  - grows from t = 1.65;
  - shrinks by the ratio −1.01823 each step, which equals the parasitic root −1.018231;
  - ends at −2.9671e-4;
  - is the larger error from t = 1.8 on.

**Derivation and stability**
- The weights; the truncation-error constants 14/45 and −1/90; (5).
- The characteristic polynomial matches, the principal root agrees with $e^z$ through $z^4$, and (7) is confirmed.
- At ζ = −1 the polynomial reduces to 20z² + 6z, which is zero at z = −0.3.
- The complex pair has modulus 1.0036 at z = −0.85.

**Example 1**
- Every intermediate value, all 11 table rows, the sign pattern, and the m = 50 values.
- The ratios: 27.44, 24.00, 20.86, 18.78, 17.50.

**Example 2**
- 0 mismatches against gr_91.
- The interval table.
- The ratio 13,214.
- The m = 50…800 table.
- The alternation onsets: 0.600, 0.600, 0.625, 0.725.

**Example 3**
- The Bessel solution: residual about 1e-18, $u^{(4)}(0) = -2$.
- y(0.5) and y(0.9) agree to 13 digits.
- $t^*$ = 0.9698106539.
- The table.
- The ratios 10.2 and 13.2.
- The shortfalls 17.5%, 4.59% and 0.62%.
- 1.66e203 at t = 0.99.

**Example 4**
- The peak 1.449767 at t = 0.8836.
- All 21 rows.
- 27.7%.
- $f_y(5)$ = −41.26.
- The crossings at 2.646 and 4.263.

## Implementation checks

**`milneaa.jl`**
- **Method:** unmodified PECE in the same order as gr_41, using `cbrt`.
- **Numbers:**

  | m | $y_m$ | $e_m$ | max $\|e\|$ |
  |---|---|---|---|
  | 12 | 1.9270743 | −1.919 | 1.919 (t = 5) |
  | 16 | −0.7571300 | 0.7652 | 1.314 (t = 4.6875) |
  | 60 | 0.0081310 | −1.105e-5 | 3.530e-3 |
  | 150 | — | 1.649e-11 (mpmath 1.64897e-11) | — |

  Script and reviewer agree.
- **Reference:** BigFloat RK4 with Richardson extrapolation, agreeing with DOP853, Radau and mpmath to about 1e-17.
- **Picture:** frames 001 and 015 were checked. The asserts confirm nothing is clamped.

**`milnebb.jl`**
- **Method:** the same routine.
- **Numbers:** e at t = 0.1, 0.6, 2 and 5 for m = 50, and at t = 0.6 and 5 for m = 100, all match. The minimum |e| is 6.903e-9.
- **Reference:** the exact solution, evaluated in BigFloat.
- **Picture:** frame 050 was checked. The markers follow the sign of $e_k$, and the window holds every value.

The reviewer's scratch work is in `$WORK/review-batch-1-r2/milne-simpsons-method/reviewer/` (session scratchpad): `ms_common.py`, `ex1.py`–`ex5_legacy.py`, `stab.py`, `lte.py`, `milne*_instr.jl`.
