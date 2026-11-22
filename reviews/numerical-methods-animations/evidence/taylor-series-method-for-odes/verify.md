# Verification: taylor-series-method-for-odes

Files in `verify/`: `aa_vals.jl`, `bb_vals.jl` (script copies with the plotting removed; they print ys → `aa_vals.txt`, `bb_vals.txt`), `check.py` → `check_out.txt`, `check2.py` → `check2_out.txt`.
Reference solution: mpmath `odefun` at 30 digits. Derivatives: sympy total derivatives of f = 1 − t·∛y, with d/dt applied along the solution. My Python Taylor steppers reproduce the Julia outputs (for example T3 at t=4.25 gives 1.216164 in both; T4 at t=4.5 gives −10.4513 in both).

## A1 — confirmed (it is the method's real behaviour, not a bug; severity is closer to Misleading)
- What I checked: I compared the script derivative formulas with sympy at 200 random (t,y) points. I computed the true solution and both Taylor runs at h=0.25, and computed h·∂f/∂y along the true solution against the real-axis stability limits of the Taylor stability polynomials. I re-ran with smaller h.
- Evidence:
  - The script's y′, y″, y‴ agree with sympy to a relative error of ≤5e-15, so the derivatives are coded correctly.
  - True y at t = 4, 4.25, 4.5, 5 is 0.01624, 0.01342, 0.01123, 0.00812, decaying smoothly and monotonically.
  - Order 3 at those times gives 0.0068, **1.2162**, 0.4529, 0.0895. The spike to 1.216 at t=4.25 can be seen in committed frame 21.
  - Order 4 gives 0.0142, −0.0465, **−10.45**, −5.27. The curve leaves the axes below t≈4.1, and the frame-21 annotation reads "y≈-5.2675".
  - ∂f/∂y = −t/(3y^{2/3}), and h·∂f/∂y along the true solution is −1.25 at t=3, −2.38 at 3.25, −3.38 at 3.5, −5.20 at 4 and −10.3 at 5. The real stability intervals are (−2.513, 0) for order 3 and (−2.785, 0) for order 4. Both methods therefore leave the stability region between t=3.25 and t=3.5.
  - After that the errors alternate in sign (from t≈3), grow, and then blow up. This is the classic behaviour of an explicit method on a problem that has become stiff, because the slow manifold y≈t⁻³ is strongly attracting.
  - With exact (sympy) y'''' the order-4 run blows up in the same way (−10.43 at t=4.5), so the finite difference is not the cause.
  - With n=40 (h=0.125) both runs stay stable: at t=5, T3 gives 0.00835, T4 gives 0.00949, and the true value is 0.00812. With n=50 both agree with the true value to 1e-6.
  - The page (lines 12, 16–30) calls these "the Taylor series solution trace" and never mentions the instability. Line 42 only promises stability notes for later.
- Severity: the substance is fair and the issue is serious, because readers see a spurious spike or a dive to −10 for an IVP whose solution decays smoothly. Strictly, though, nothing is computed wrongly. The GIFs show what the method really does, and the fault is that the page says nothing about it. Under the brief's definitions that makes it **Misleading** rather than Error, unless it is counted together with A2.
- Correction: none on the facts. Detail: the order-3 spike stays inside the plot box; only order 4 leaves the plot.

## A2 — confirmed
- What I checked: I computed the pointwise errors of both runs (h=0.25) against the reference.
- Evidence (check_out.txt), as errors e3 / e4:
  - t=0.25: 2.5e-4 / 2.3e-5 (11× smaller for order 4)
  - t=1: 6.6e-4 / 3.3e-5 (20×)
  - t=2: 9.3e-4 / 9.6e-6 (97×)
  - t=2.25: 9.7e-4 / 1.7e-6 (580×)
  - t=2.75: 6.4e-4 / 7.3e-5 (9×)
  - So on [0, 2.75] order 4 is about 10–600× more accurate.
  - Once instability sets in, order 4 is far worse:
    - t=4.5: 0.44 / 10.4
    - t=5: 0.081 / 5.28 (about 65× worse)
    - largest error over the interval: 1.20 for order 3, 10.45 for order 4.
- Severity: Error is fair. "Slightly better accuracy … with the same step size h=0.25" is false at every part of the run shown: much better early, much worse late.
- Correction: a small detail. At t=4.25 order 4 is still better (0.06 vs 1.20), so "far worse" holds from t=4.5 on. Early on, both curves are also visually indistinguishable in the GIFs (errors ≤1e-3).

## A3 — confirmed with correction
- What I checked: I measured global convergence order at the endpoint and the one-step (local) error order, for T3, T4 and RK4.
- Evidence:
  - Global error of T3 on [0,2] with n=40…320 is 7.2e-6 → 1.4e-8, with observed order **3.00**. On [0,5] the order is about 3.2. T4 is 4.07.
  - One-step error from t=1 with h=0.2…0.025: T3 slope **4.00** (local error O(h⁴)), T4 slope about 5.1, RK4 slope **5.02** (local error O(h⁵)).
- Severity: Error is fair for the phrase "matching RK4 in order". Order-3 Taylor is a third-order method, while RK4's local error is O(h⁵) and its global order is 4.
- Correction: the clause "local truncation error is O(h⁴)" on line 18 is itself **correct** for p=3 and is consistent with line 12's O(h^{p+1}). The only false part is the RK4 comparison. It equates T3's local order with RK4's global order; the like-for-like match is T4 with RK4.

## A4 — confirmed with correction (minor; numerically negligible where it matters)
- What I checked: I read taylorderivativebb.jl lines 23–24, compared the finite-difference y'''' with the exact sympy y'''' along the true solution, and compared whole trajectories and convergence orders with exact versus FD y''''.
- Evidence:
  - Lines 23–24 use `d4 = (yd3_f(t+ε, y+ε·d1) − d3)/ε` with ε = h·1e-5 = 2.5e-6. This is a forward difference of y‴ along the solution direction, not an analytic derivative.
  - Relative error of the FD y'''' is 1e-7 to 2e-5 for t ≤ 3.5, then grows to 2.8e-3 at t=4, 1.6e-2 at t=4.5 and 6e-2 at t=5 (where y is small and y^{-5/3} terms dominate).
  - The h=0.25 trajectories with exact and FD y'''' differ by at most **6.3e-7 through t=4**. That is far below the method error (up to 2e-3) and invisible in the GIF. After the blow-up they differ by at most 0.017 on values near −10 (about 0.16%).
  - Convergence on [0,2] is identical (order 4.07, same errors to 3 digits). On [0,5] at n=640 the FD version's error is 1.5e-14 against 8.6e-15, so the finite difference only begins to show at round-off level.
- Severity: Misleading is fair but low impact. Line 12 says the method computes higher derivatives "analytically", and the order-4 animation doesn't. A reader copying the approach wouldn't know about it, but the plotted result is unaffected.
- Correction: **line 18 is not contradicted.** It belongs to Case 1 (order 3), and taylorderivativeaa.jl does use fully analytic y″ and y‴. Only line 12, the general intro covering both animations, is at odds with taylorderivativebb.jl. Case 2's text (line 26) says nothing about how y'''' is obtained. The script's own comment ("one more derivative term") also hides the finite difference.
