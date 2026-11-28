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

## Batch close-out (director)

### Pages built

All seven pages got an overview Description in Phase 1 (`content-page`, overview mode), each with a claim ledger; the director spot-checked numbers on every page (for example the Bisection Case 1 errors and bound, the False Position constant C, the Secant ratio 0.7933 and the Accelerated Newton limit 1/6) before committing. No script or GIF changed. Final prose counts: Bisection 398, False Position 398, Fixed Point 396, Secant 398, Muller's 397, Aitken–Steffensen 464, Accelerated/Modified Newton 399.

### Findings by round

| Round | Pages | Error | Misleading | Minor |
|---|---|---|---|---|
| 1 (this folder) | 7 | 2 | 0 | 7 |
| 2 (`reviews/batch-16-r2`) | 5 | 0 | 0 | 7 |

- Round 1: both Errors (Muller F1, Accelerated/Modified Newton F1) were confirmed by an independent checker given only the allegation, fixed by a fixer under the Accuracy standard with a ledger, and confirmed resolved by a different checker who saw only the findings and the diff. Two fixes (Bisection F1, Accelerated/Modified Newton F1) went back to their fixer once for a one-sentence wording refinement the checker asked for. All six reproduced Minor findings were fixed the same way; Aitken F3 (word count) was not acted on (see decisions).
- Round 2 (fresh reviewers, not shown round 1) found no Error or Misleading finding, which ends the review. Its six actionable Minor findings were fixed and confirmed by one checker covering the four pages; Aitken r2 F1 (word count) was again not acted on.
- Nothing is open apart from the word count below.

### Decisions taken for Jason to revisit

- **Check pages are not trimmed to 400 words.** The plan's *check* action is "add only what is missing", and these Descriptions were reviewed nine times before; trimming them would delete reviewed content. So Aitken–Steffensen stays at 464 words (294 before the batch). The same rule applies to the batch 17 check pages (Brent, Broyden, Graeffe, Nonlinear Systems, Madsen-Reid), which are further over. Jason may prefer to trim them; if so, it is a separate pass.
- **Round-2 calibration skipped.** The reviewer brief is unchanged from round 1, where it was calibrated with two planted errors (and passed again in the batch 17, 18 and 19 calibrations), so the five-page re-review was not separately calibrated.
- **Whole-section render deferred to the end of the stacked run.** Each changed page was rendered on its own before every commit; `quarto render pages/numerical-methods/` is run once after batch 22, when all the stacked branches' pages are in place.

### Notes

- The batch 16 reviewers confirmed Mathews' MATLAB `bisect` stops at an exact zero (`if yc==0`), while his Mathematica subroutine on the module page does not; the Description's attribution is to the former.
- Review reports were extracted verbatim from each reviewer's final message by a script (the reviewers cannot write report files), so the files are the reviewers' own words.

### Commits

- `77cb1e1`, `b59c079`, `671506f`, `f4cdb92`, `ef8aadc`, `460fe1a`, `d27aca3` overviews (Bisection, Muller's, False Position, Aitken–Steffensen, Fixed Point, Accelerated/Modified Newton, Secant)
- `113801e` batch 16 review
- `2193628`, `d44a46c`, `4092465`, `820da83`, `809a1cc` round 1 fixes (Muller's, Aitken–Steffensen, Secant, Accelerated/Modified Newton, Bisection)
- `c898e67` batch 16 review, round 2
- `5f7129b`, `dbc68e7`, `c50eee6`, `f9373e0` round 2 fixes (Bisection, Muller's, Aitken–Steffensen, Accelerated/Modified Newton)
- the close-out commit that adds this section and the plan status
