# Batch 16 review — round 2

Scope: the five batch 16 pages changed by the round 1 fixes (Bisection, Secant, Muller's, Aitken–Steffensen, Accelerated and Modified Newton-Raphson), overview mode, reviewed at commit `809a1cc`. Each reviewer was fresh, was told not to read `reviews/`, and reviewed the page's whole batch diff against `main`, not just the fixes.

**5 pages reviewed. Findings: 0 Error, 0 Misleading, 7 Minor.** This round meets the batch's stopping condition (no Error or Misleading finding), so there is no round 3. The Minor findings were reproduced and fixed, each fix confirmed by a separate checker (see the batch 16 README's close-out).

| Page | Error | Misleading | Minor |
|---|---|---|---|
| [Bisection Method](bisection-method.md) | 0 | 0 | 2 |
| [Secant Method](secant-method.md) | 0 | 0 | 0 |
| [Muller's Method](mullers-method.md) | 0 | 0 | 1 |
| [Aitken's Method and Steffensen's Acceleration](aitken-method-and-steffensen-acceleration.md) | 0 | 0 | 3 |
| [Accelerated and Modified Newton-Raphson](accelerated-and-modified-newton-raphson.md) | 0 | 0 | 1 |

## The Minor findings

- **Bisection F1:** "after an exact hit it always takes the right half" overstates; only the hit and the next step are forced (round 1's follow-up wording introduced this). **F2:** "takes $k \ge \log_2(\cdot)$ steps" is the guaranteed count, not the needed one.
- **Muller F1:** with a negative discriminant the two roots of $P$ are a conjugate pair equally near $p_2$, so "nearest" is a tie, broken by the sign rule.
- **Aitken F1:** over 400 words (460; see the batch decisions). **F2:** "first three Steffensen errors" is ambiguous about the index ($S_1$–$S_3$). **F3:** "converges quadratically" also covers $m = 1$, where the order is 3; "at least quadratically".
- **Accelerated/Modified Newton F1:** "$f(x_n) \approx 3e_n^2$ near a double root" is specific to this cubic.

## Comparison with round 1

Neither round 1 Error came back. Bisection F1 is a refinement of round 1's Bisection F1, introduced by the wording of its fix.

## Method

The reviewer brief was the one calibrated in round 1 (and in the batch 17–19 runs, each with two planted errors found); it is unchanged, so this re-review was not separately calibrated. Frames, manifests and mechanical checks were prepared as in round 1. Reviewers returned their reports as text; the director saved them unchanged.
