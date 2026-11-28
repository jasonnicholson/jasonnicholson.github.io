# Batch 22 review — round 2

Scope: the five batch 22 pages, all changed by the round 1 fixes (Euler's Method, Taylor Series Method, Runge-Kutta Method, Runge-Kutta-Fehlberg Method, Adams-Bashforth-Moulton Method), overview mode, reviewed at commit `d265e0d`. Each reviewer was fresh, was told not to read `reviews/`, and reviewed the page's whole batch diff against `main`.

**5 pages reviewed. Findings: 0 Error, 1 Misleading, 3 Minor.** The Misleading finding was confirmed by an independent checker given only the allegation, so the review continues to a round 3 on the pages these findings change.

| Page | Error | Misleading | Minor |
|---|---|---|---|
| [Euler's Method for ODE's](eulers-method-for-odes.md) | 0 | 0 | 0 |
| [Taylor Series Method for ODE's](taylor-series-method-for-odes.md) | 0 | 0 | 1 |
| [Runge-Kutta Method](runge-kutta-method.md) | 0 | 0 | 0 |
| [Runge-Kutta-Fehlberg Method](runge-kutta-fehlberg-method.md) | 0 | 0 | 1 |
| [Adams-Bashforth-Moulton Method](adams-bashforth-moulton-method.md) | 0 | 1 | 1 |

- **ABM F1 (Misleading, confirmed):** "on its frames stability, not truncation, sets the error" holds for $m = 12$ to 70 but not for $m = 100$, 120, 150, where the error does not grow after the shaded onset and the run's largest error is the pre-onset truncation error; it also contradicts the page's own Animations section. This sentence was written by the round 1 fix and passed that fix's check.
- **ABM F2 (Minor):** "off by only 0.013" understates an error that is 1.64 times the exact $y(5)$.
- **RKF F1 (Minor):** the Case 1 global-error explanation omits that the error estimate itself is too small at the step $t = 0.1$, $h = 0.136$ (estimate 1.72e-8 against a true local error of 1.81e-7).
- **Taylor F1 (Minor):** the global $O(h^p)$ result is stated under $y \in C^{p+1}$ and partials of $f$ through order $p-1$ (Mathews' precision theorem word for word); the standard proof needs the increment function Lipschitz, so $f$ smooth through order $p$ near the solution. No counterexample was found.
- Round 1's three Errors (the Runge-Kutta hypothesis on both RK pages and the RKF ratio 65.4) did not come back; both RK reviewers confirmed the new hypotheses.

## Method

The reviewer brief is unchanged from round 1 (calibrated in each of batches 16–22), so this re-review was not separately calibrated. Reviewers returned their reports as text; the director saved them unchanged, and appended the independent check to the ABM report.
