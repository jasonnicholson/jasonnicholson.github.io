# Batch 22 review — round 1

Scope: `batch=22` of `plans/numerical-methods-light-pass-plan.md` (ODEs), overview mode. Branch `batch-22` (stacked on `batch-21`). The reviewers worked on the pages' working-tree text before it was committed; the overview commits on this branch contain exactly that text (saved before any fix and committed from the saved copies).

**5 pages reviewed, none skipped. Findings: 3 Error, 0 Misleading, 7 Minor.** All three Errors were confirmed by an independent checker given only the allegations.

| Page | Action | Mode | Scripts / GIFs changed | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|---|
| [Euler's Method for ODE's](eulers-method-for-odes.md) | extend | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [Taylor Series Method for ODE's](taylor-series-method-for-odes.md) | write | overview | 0 / 0 | 0 | 0 | 3 | reviewed |
| [Runge-Kutta Method](runge-kutta-method.md) | write | overview | 0 / 0 | 1 | 0 | 0 | reviewed; F1 confirmed |
| [Runge-Kutta-Fehlberg Method](runge-kutta-fehlberg-method.md) | extend | overview | 0 / 0 | 2 | 0 | 1 | reviewed; F1, F2 confirmed |
| [Adams-Bashforth-Moulton Method](adams-bashforth-moulton-method.md) | extend | overview | 0 / 0 | 0 | 0 | 1 | reviewed |

## The findings that matter most

- **Runge-Kutta F1 and RKF F1 (Errors, the same mistake):** the order results were stated under smoothness of the *solution* ($y \in C^5$, $y \in C^6$). Runge-Kutta stages evaluate $f$ off the solution curve, so the result needs $f$ smooth near the solution. Counterexample: $f = \cos t + |y - \sin t|$ is Lipschitz with solution $\sin t$, yet RK4 is only second order on it. The page's own cases are unaffected (their $f$ is smooth near the solution). Mathews' precision theorem states the hypothesis on $y$, so the error copies a common textbook shortcut.
- **RKF F2 (Error):** a halving ratio quoted as 65.4 is a float64 artifact; it is 65.6.

## The Minor findings

- **RKF F3:** "halving the first step" named a test step, not Case 1's first step (0.1).
- **Euler F1:** "each step multiplies the error by $1+z$" — only the inherited error; each step adds its own local error.
- **Taylor F1:** the sentence moved from the Animations introduction used $p$ before it was defined and stated the accuracy result without its hypothesis. **F2:** "all three animate the same sweep" — Euler's sweep is a different list of $m$. **F3:** the irregular $y(5)$ ratios (4.0, 580) were given without their cause (shaded steps at $m = 60$).
- **ABM F1:** the $O(h^4)$ result also needs starting values accurate to $O(h^4)$; a low-order starter caps the order.

## Pattern

The two Errors on hypotheses are the same class batch 16 found (a general convergence result stated without a hypothesis it needs), here on Runge-Kutta methods. Every number on all five pages matched the reviewers' computations except the RKF 65.4.

## Evidence and method

- Archive found and used. No script or GIF changed; frames of every embedded GIF were extracted.
- Calibration: one reviewer got a scratch copy of the Runge-Kutta page with two planted errors in the new text (an observed order 4.37 for 4.07; and a claim that the frames already show the $h^4$ factor at each refinement, which their own error labels contradict). It found both. That report was discarded and the real page reviewed afresh.
- Reviewers returned their reports as text; the director saved them unchanged.
- Mechanical checks found nothing (the RKF `#animations` link resolves to Quarto's automatic heading id).
