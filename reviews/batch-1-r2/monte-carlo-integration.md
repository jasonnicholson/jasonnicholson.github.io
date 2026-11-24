# Review: Monte Carlo Integration (batch 1, round 2)

**Result: 0 Error, 0 Misleading, 0 Minor.**

## How this page was reviewed

This was the round's calibration page. The reviewer worked on a scratch copy of the page folder that differed from the committed page in exactly two lines (38 and 48). There the director had planted:
- a value wrong in the third significant figure ("5.672 at n=10");
- a behaviour sentence the computation contradicts ("their errors fall more steeply").

The reviewer reported both as Error findings with computed evidence. The planted errors are not findings about this page and are omitted. The reviewer's own numbers confirm the committed text of both lines:
- the n = 10 estimate is 5.691709, which the page gives as 5.692;
- the midpoint errors fall less steeply than the Monte Carlo standard deviation, with local slopes −0.397 to −0.400 against −0.5, as the page says.

The scripts in the copy were identical to the committed scripts. The review was fresh and independent; no earlier report was read.

The legacy archive was consulted: the module page text and the images of Examples 1–3, 6 and 8–14. No fidelity departures were found.

## Findings

None.

## Inventory (Phase 1)

- **Scripts:** `montecarloaa.jl`, `montecarlobb.jl`.
- **GIFs:** 45 frames decoded (39 distinct) and 52 frames decoded (46 distinct).
- Every file is referenced by the page and no reference is missing. The section index links the page.
- Both GIFs regenerate byte-identically from scratch copies.

## Claim ledger (whole page): about 100 entries, all confirmed

The two planted lines are excluded; for both, the true value matches the committed text. Line numbers are those of the committed page. Highlights:

**Description**
- The seeded NumPy runs follow the stated layout literally: d consecutive numbers per point, in x, y, z, u, w order. Read that way, the description reproduces every single run on the page:
  - Example 3, seed 2026: the first ten points, the sum 13.453433, and all four table rows, with ratios 0.108, 1.049, 2.5154 and 2.12499.
  - Examples 4–7.
  - Examples 8–13: 2.959833, 2.995614, 2.563846, 1.708243, 1.535161, 1.188562, with every SE and error.
  - Example 14 with seeds 14 and 15.

**Repeat studies**
- Following the page's description of the streams reproduces the tables:
  - RMS 0.59299, 0.18732, 0.05985, 0.01911;
  - coverage 63.72, 68.23, 67.76, 67.07% within one SE and 90.53, 95.05, 95.33, 95.38% within two;
  - slope −0.49707;
  - Example 14: 88.71% and 90.91%;
  - normal theory: 87.941% and 90.651%.

**Animations**
- Case 1: 6.846379, 5.444411 ± 0.0575631 (1.9297 SE), and 5.342739 ± 0.018947 (0.4964 SE).
- At n = 2: SE 0.0396709 against SD 1.33333, error 38.14 SE.
- The largest SE deviation is 5.23% (at n = 690), and the largest error is 2.2336 SE (at n = 726).
- Case 2: the midpoint values 1.2006957746 … 1.1897660407, the ratios 0.887 → 1.677, the win pattern T, T, T, T, T, F, and 1.18770850 ± 5.840964e-4.
- The dips below the floor are real: Case 1's minimum is 1.63e-6 and Case 2's is 4.07e-7.

**Deterministic examples**
- Example 1: the roots, 20/9, and 20/(9π).
- Example 2: the midpoint table and ratios.
- Examples 4–7: the exact values and σ².
- Examples 8–13: the exact and Gauss–Legendre references.
- Example 14: the midpoint table, with ratios within 0.22% of (m/(m−1))², and the errors at m = 8–10.
- Every quoted Mathews number matches his images.

## Implementation checks

**`montecarloaa.jl`**
- **Method:** the sample-mean estimator with SE dividing by n, as in (4).
- **Numbers:** an independent Xoshiro(3) recomputation agrees at n = 2, 10, 100, 1000 and 10000.
- **References:** 16/3 and 4√2/3.
- **Picture:** frames 001, 009 and 045 were checked. The band is not clipped (4.66–7.25 within 3.33–7.33).

**`montecarlobb.jl`**
- **Method:** 5-D sample mean, plus the product midpoint rule.
- **Numbers:** the midpoint values match numpy to 10 digits, and the MC values match an independent Julia recomputation.
- **References:** GL I_ref = 1.188783291439, with numpy GL 12, 16 and 20 agreeing. mean f² = 4.616667. SD constant 0.0759605.
- **Picture:** the diamonds appear only once n ≥ m⁵, the title comparisons are correct, and nothing is clipped.

The reviewer's scratch work is in `$WORK/review-batch-1-r2/monte-carlo-integration/reviewer-calib/` (session scratchpad).
