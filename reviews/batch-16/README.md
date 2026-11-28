# Batch 16 review — round 1

Scope: `batch=16` of `plans/numerical-methods-light-pass-plan.md` (root finding I), overview mode. Branch `batch-16`, reviewed at commit `d27aca3`. Newton-Raphson, the pilot page, was done and approved before this batch and is not in scope.

**7 pages reviewed, none skipped. Findings: 2 Error, 0 Misleading, 7 Minor.** Both Errors were confirmed by an independent checker who was given only the allegation. Minor findings are reported unverified, as the skill allows; the fixer reproduced each one before changing anything.

| Page | Action | Mode | Scripts / GIFs changed | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|---|
| [Bisection Method](bisection-method.md) | write | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [False Position or Regula Falsi Method](false-position-or-regula-falsi-method.md) | write | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Fixed Point Iteration](fixed-point-iteration.md) | write | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Secant Method](secant-method.md) | write | overview | 0 / 0 | 0 | 0 | 1 | reviewed |
| [Muller's Method](mullers-method.md) | write | overview | 0 / 0 | 1 | 0 | 0 | reviewed; F1 confirmed |
| [Aitken's Method and Steffensen's Acceleration](aitken-method-and-steffensen-acceleration.md) | check | overview | 0 / 0 | 0 | 0 | 4 | reviewed |
| [Accelerated and Modified Newton-Raphson](accelerated-and-modified-newton-raphson.md) | extend | overview | 0 / 0 | 1 | 0 | 0 | reviewed; F1 confirmed |

## The findings that matter most

- **Muller F1 (Error):** "the order is about 1.84" was stated for any $C^3$ simple root; it needs $f'''(p) \ne 0$ (on $x + x^2 + x^4$ the order is 2.00).
- **Accelerated and Modified Newton F1 (Error):** "a multiplier $\mu \ne m$ gives only linear convergence" holds only for $0 < \mu < 2m$; the page's own example ($\mu = 2$ at a simple root) is the borderline case, where convergence is sublinear.

## The Minor findings

- **Bisection F1:** the Description said the displayed rule "moves on past" an exact zero; in fact it then leaves the root, and the guarantee and bound assume no $f(c_k) = 0$.
- **Secant F1:** the Case 1 table's last row is an extended-precision value; double precision differs in the third digit.
- **Aitken F1:** the fourth Steffensen error in Case 2 is the rounding floor, not the quadratic rate. **F2:** Case 3's error stalls in rounding noise rather than "stops falling". **F3:** the Description is 461 words (see decisions). **F4:** the Steffensen steps (pre-existing text) used $p_0, p_1$ where the animations use $S_k$.

## Pattern

Both Errors are general convergence results stated without a hypothesis they need — exactly the class the overview standard warns about. Every number on all seven pages matched the reviewers' independent computations.

## Evidence and method

- Archive found at `/home/jason/Desktop/math-fullerton/baseline/mathews/` and used by every reviewer.
- GIFs are real image data (not LFS pointers). No script or GIF changed in this batch, so no regeneration was needed; frames of every embedded GIF were extracted for the reviewers.
- Calibration: one reviewer got a scratch copy of the Bisection page with two planted errors in the new Description (an error value wrong in the third significant digit, 2.47e-4 for 2.40e-4; and a claim that Case 1's error falls by half at every step, which its computed errors contradict). It found both, with independent numbers. That report was discarded and the real page reviewed afresh. (The calibration reviewer also raised the exact-zero point that the real reviewer reported as Bisection F1.)
- Reviewers returned their reports as text; the director saved them unchanged into these files.
- Mechanical checks (control characters, leftovers, localhost links, code fences, links and case anchors, unreferenced GIFs, word counts) found nothing beyond the Aitken word count.
