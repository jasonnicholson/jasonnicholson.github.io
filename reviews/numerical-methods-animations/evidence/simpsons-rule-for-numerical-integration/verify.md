# Verification: simpsons-rule-for-numerical-integration
## A1 — confirmed
- What I checked: Whether composite Simpson on f(x)=e^{-x} sin(8x^{2/3})+1 over [0,2] (the integrand in simpsonsaa.jl and on the page) converges at fourth order, as index.qmd line 29 says. I computed a 40-digit reference integral with mpmath, using the substitution x=t^3 to remove the singularity (it agrees with direct adaptive quadrature: I = 2.0162797196170963...). Then I measured the errors of S_n for the animation's n values and under repeated doubling of n. As a control I ran the same code on the smooth integrand e^{-x} sin(8x)+1.
- Evidence: verify/order.py (`/usr/bin/python3 -I verify/order.py`).
  - Observed order log2(e_n/e_2n): 1.89, 1.71, 1.68, 1.671, 1.668, ..., 1.66667 for n = 32 ... 2^21. This converges to 5/3, not 4.
  - A log-log fit over n=256..2^20 gives slope -1.6668. Over the animation's own range, n=12..108, the slope is -1.80.
  - The smooth control gives orders 4.12, 4.03, 4.007, 4.002, so the code is correct and the low order comes from the integrand.
  - Cause: near x=0, f-1 ≈ 8x^{2/3}, so f' is unbounded at the endpoint. Simpson's O(h^4) bound needs f^(4) to be bounded, and for an x^α endpoint singularity the error is O(h^{1+α}) = O(h^{5/3}).
  - Absolute errors in the animation: n=20 gives 8.3e-3; n=108 gives 4.5e-4 (S_108 = 2.015834, while the true value is 2.016280). The displayed values match my S_n; for example the committed frame showing 97 sample points reads 2.015737 = S_96.
- Severity: Error is fair. "Fourth-order global accuracy" is a false statement about this animation's integrand: the measured order is 5/3. "Converges rapidly" is also an overstatement, since about 109 samples still give only about 3-4 correct digits. Line 18 says O(h^4) for smooth functions, which is true in general, but this integrand is not smooth at x=0, and line 29 applies the claim directly to it.
- Correction to the allegation: none needed on substance or location (line 29). If precision helps: the order is exactly 5/3 asymptotically, and about 1.8 effective over the animation's n range.
