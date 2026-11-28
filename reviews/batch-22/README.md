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

## Batch close-out (director)

- **Pages built:** five overview Descriptions with claim ledgers (two *write*, three *extend*). No script or GIF changed. Final prose counts: Euler 400, Taylor Series 400, Runge-Kutta 362, Runge-Kutta-Fehlberg 399, Adams-Bashforth-Moulton 398.
- **Findings by round:**

  | Round | Pages | Error | Misleading | Minor |
  |---|---|---|---|---|
  | 1 (this folder) | 5 | 3 | 0 | 7 |
  | 2 (`reviews/batch-22-r2`) | 5 | 0 | 1 | 3 |
  | 3 (`reviews/batch-22-r3`) | 3 | 0 | 0 | 2 |

  Every Error and Misleading finding was confirmed by an independent checker given only the allegation. Every finding was reproduced, fixed with a ledger, and confirmed by a separate checker who saw only the findings and the diff; two fixes (RKF and ABM in round 2) went back to their fixer once for a wording point the checker raised. Round 3 had no Error or Misleading finding, which ends the review.
- **Pattern across rounds:** round 2's Misleading finding (ABM: "on its frames stability, not truncation, sets the error") was written by a round 1 fix and passed that fix's check; a fresh reviewer caught it because it contradicted the page's own Animations section. Round 2's Taylor finding was the same class as round 1's Runge-Kutta Errors (an order result stated under smoothness of $y$ alone).
- **Decisions, for Jason to revisit:**
  - The Runge-Kutta, Runge-Kutta-Fehlberg and Taylor pages state their order results under smoothness of $f$ near the solution, not Mathews' $y \in C^{p+1}$; Mathews' hypothesis is kept as the consequence in parentheses. Mathews' Runge-Kutta precision theorem image may read $y \in C^2$; the page does not attribute its hypothesis to him. The ABM page keeps Mathews' $y \in C^5$, which suffices for a multistep method with $f$ Lipschitz.
  - The overview commits contain the reviewed text: it was saved before the round 1 fixes and committed from the saved copies.
- **Whole section:** `quarto render pages/numerical-methods/` completed without errors after the last fix, with all of batches 16–22 in place.
- **Commits:** `7368633`, `d690653`, `e7b1045`, `ca45dd2`, `5dcd460` overviews; `cb368d4` review; `c1a3c75`, `7928510`, `714b583`, `ed6964c`, `d265e0d` round 1 fixes; `75ad1c8` round 2 review; `fee1c53`, `0e9633b`, `c25aefa` round 2 fixes; `a582aff` round 3 review; `802b2eb` round 3 fix; the close-out commit (this section, the plan status, the plan's Finished section and the index status note).
