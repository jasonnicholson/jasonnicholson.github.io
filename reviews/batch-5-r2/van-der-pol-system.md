# Review: van der Pol System (batch 5, round 2)

**Findings: 0 Error, 0 Misleading, 2 Minor (unverified).**

This was a fresh, independent review: the reviewer read no earlier review or fix record and did not compare the page with any other copy. Legacy archive consulted: `VanDerPolMod.html`, Links lnk_1–lnk_7, images gr_2, gr_3, gr_18, gr_24–gr_28, gr_30, gr_40, gr_50, gr_61, gr_71; no van der Pol animation under `a2001/Animations`. Independent computations: Example 1 RK4 in 40-digit mpmath, limit cycles with DOP853 (rtol 1e−13) and Radau, maxima by DOP853 events, an order-30 Taylor integrator in 40-digit mpmath (maxima at μ = 1/4, 1/2, 1), an own RK4 against a long-double Richardson reference, the μ = 4 timings.

## Findings

### F1 — Page match — Minor (unverified): the Example 4 gap at the tenth maximum is not at rounding level

- **Location:** `index.qmd` line 287 (Example 4): "From the fourth maximum on each gap is $\rho = 0.0392$ times the one before, until the gap reaches rounding level ($3.8 \times 10^{-14}$ at the tenth maximum)."
- **True instead:** in 40-digit arithmetic the cycle's largest x is 2.0024879304471084; the run from (0, 3) has its tenth maximum at t = 58.916448 with gap **5.592e−14**, and the ninth gap is 1.427e−12, so the ratio at the tenth maximum is 0.03918 = ρ: the geometric decay continues and the gap never reaches rounding level for 0 ≤ t ≤ 60. 3.8e−14 is noise from a double-precision reference (the reviewer's DOP853 run gives 5.37e−14 with ratio 0.0376, also noise).
- **Severity (director's note):** the number is wrong at its two digits, but it sits in a clause that already presents it as rounding-level, and the claim the sentence teaches (geometric decay by ρ from the fourth maximum) is right. Kept Minor, following the treatment of rounding-noise values elsewhere in this batch (Pendulum F2, round 1).
- **Evidence:** `taylor.py 1 2`; `maxima.py`.
- **Fix:** "From the fourth maximum on each gap is $\rho = 0.0392$ times the one before, down to $5.6 \times 10^{-14}$ at the tenth maximum."

### F2 — Page match (wording) — Minor (unverified): "mirror image" for a point symmetry

- **Location:** line 48 (Case 3 Behavior): "The other half of the cycle is the mirror image."; line 301 (Example 6): "The other half of the cycle is the mirror image, since (2) is unchanged when $(x, y)$ is replaced by $(-x, -y)$."
- **True instead:** (x, y) → (−x, −y) is a point reflection (a half turn about the origin), not a mirror reflection; the μ = 4 cycle is symmetric about neither axis (largest |y| at (+0.98049, +6.344) and (−0.98049, −6.344); `vanderpolcc.gif` frame 301 shows an S-shaped loop). Example 6 gives the right reason, so only the word misleads there.
- **Evidence:** `cyc.py`; frame 301.
- **Fix:** "The other half of the cycle is the same half turned through 180° about the origin" (or "…is symmetric to it through the origin").

No Fidelity findings (every archive example animated; μ values and Example 1's set-up and end point match Mathews; the page says the intervals and starts of Examples 2–6 are lost).

## Inventory (Phase 1)

3 scripts, 3 GIFs (130, 276, 345 frames); all run; every GIF byte-identical to what its script produces; every reference resolves.

## Claim ledger (whole page; 119 entries; reviewer's verdicts)

- **Description (1–10), Animations introduction (11–19):** confirmed (energy sign, uniqueness of the cycle, RK4 form, Mathews' six examples; the 3 s hold in all three GIFs).
- **Case 1 (20–28):** confirmed: clockwise; end point (−9.31101e−7, 2.99999999987) as Mathews prints; error and radius shortfall never decrease, reaching 9.563e−9 and 1.252e−10.
- **Case 2 (29–42):** confirmed: inward and outward spirals; maxima monotone; ρ = 0.6751, 0.2053, 0.03918, 8.597e−4; tenth maxima; the seven-figure agreement from the sixth/seventh (μ = 1/2) and third/fourth (μ = 1) maxima; largest |y| 2.6784.
- **Case 3 (43–55):** confirmed except 52 (F2): first maximum 1.957 at 0.6541; on the cycle at the second maximum; 0.9736 ahead; 3.86 and 0.829; within 0.022 of y′ = 0; |y| = 6.344 at x = −0.9805.
- **The equation and limit cycle (56–78):** confirmed (eigenvalue table; Liénard hypotheses; the A = 2 integral; cycle table P, largest x, largest |y|, ρ for all five μ; e^{−π/8} = 0.6752). The author's solver process (order-8 adaptive RK at 1e−13) CND as process; the values confirmed by DOP853 and Radau.
- **Runge-Kutta, Example 1 (79–93):** confirmed (first-step k1–k4 and Z1; Z400; b short of 2π by 3.07e−7; verification table; per-step factor 1 − 1.04e−13; n-table ratio 16.0).
- **Examples 2–6 (94–110):** confirmed except 99's last clause (F1) and the word in 103 (F2): every maxima list and gap ratio; Example 5's last gap 6.8e−14 (6.881e−14, within the stated rounding); 76 % of the half period; |y| > 2 for 10.8 % of the time; inside starts.
- **Verification table (111–115):** confirmed (end points; largest errors; ratios 16.00, 15.98, 15.96, 15.94, 15.69; 1.3e−9). The order-8 solver's own 1.1e−11 and the 256-bit Richardson reference CND as process (an analogous long-double reference reproduces all five ratios).
- **Implementation notes (116–119):** confirmed.

## Implementation checks

- **vanderpolaa.jl:** classical RK4 as (5) and Mathews' Runge2D; h, Z400, largest error, radius shortfall identical to the 40-digit run; order 4 confirmed (ratio 16.0 per doubling); frames 1, 2, 101, 130 checked.
- **vanderpolbb.jl:** RK4 with bisection on one step for the maxima; P, largest x and ρ match DOP853 and Radau to every printed digit; every maximum within about 1e−9 of the reference; frames 1, 30, 241 checked; the ±3.7 window holds every path.
- **vanderpolcc.jl:** same RK4 and event finder; maxima, P, drift and fall times, peak |y| identical to the independent run; nullcline correct (the `ydraw` clamp affects only the nullcline's drawing outside the window); frames 35, 78, 301 checked.
