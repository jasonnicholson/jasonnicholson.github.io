# Batch 17 review — round 1

Scope: `batch=17` of `plans/numerical-methods-light-pass-plan.md` (root finding II), overview mode. Branch `batch-17` (stacked on `batch-16`). The reviewers worked on the pages' working-tree text before it was committed; the overview commits `17b09ab`…`7693ee6` contain exactly that text (no page changed between review and commit).

**7 pages reviewed, none skipped. Findings: 0 Error, 0 Misleading, 10 Minor.** No finding needed the independent check (it applies to Error and Misleading findings). Five of the Minor findings are the word count of *check* pages over 400, which is not acted on (see the batch 16 README, "Decisions"); the other five were reproduced by the fixer before any change.

| Page | Action | Mode | Scripts / GIFs changed | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|---|
| [Improved Newton Method](improved-newton-method.md) | extend | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Halley's Method](halleys-method.md) | check | overview | 0 / 0 | 0 | 0 | 0 | reviewed |
| [Brent's Method](brents-method.md) | check | overview | 0 / 0 | 0 | 0 | 2 | reviewed |
| [Graeffe's Method](graeffes-method.md) | check | overview | 0 / 0 | 0 | 0 | 2 | reviewed |
| [Nonlinear Systems](nonlinear-systems.md) | check | overview | 0 / 0 | 0 | 0 | 2 | reviewed |
| [Broyden's Method](broydens-method.md) | check | overview | 0 / 0 | 0 | 0 | 2 | reviewed |
| [Damped Newton with Acceleration (Madsen-Reid Method)](madsen-reid-method.md) | check | overview | 0 / 0 | 0 | 0 | 2 | reviewed |

## The Minor findings

- **Word count over 400 (F1 on Brent 502, Graeffe 417, Nonlinear Systems 441, Broyden 539, Madsen-Reid 1167):** all five are *check* pages whose Descriptions were already long (Broyden 459 and Madsen-Reid 962 before the batch); the batch only added missing points. Not acted on; for Jason.
- **Brent F2:** "False Position … can slow to linear" — its order is 1; it converges only linearly.
- **Graeffe F2:** Madsen-Reid described as "damped Newton steps"; that page's method also lengthens steps.
- **Nonlinear Systems F2:** the quadratic-rate statement omits the smoothness hypothesis on **F**.
- **Broyden F2:** "the second follows from the first" is ambiguous among three listed hypotheses.
- **Madsen-Reid F2:** "the first … the second … the third" is off by one against the four-item display.

## Pattern

The *check* action adds text to Descriptions that are already near or over 400 words, so every *check* page in this batch except Halley's ends over the limit. The substantive Minor findings are all wording precision in cross-references or hypotheses; every number on all seven pages matched the reviewers' independent computations.

## Evidence and method

- Archive found and used (Madsen-Reid has no Mathews module; it follows Madsen and Reid 1975 and Vestermark).
- No script or GIF changed; frames of every embedded GIF were extracted for the reviewers.
- Calibration: one reviewer got a scratch copy of the Halley's Method page with two planted errors in the new text (Case 1b's error after two steps given as 3.67e-7 for 3.64e-7; and a claim that Case 2 needs nine steps to reach 1e-15, as many as Newton, when it needs three). It found both, with independent numbers. That report was discarded and the real page reviewed afresh.
- Reviewers returned their reports as text; the director saved them unchanged.
- Mechanical checks found nothing beyond the word counts.

## Batch close-out (director)

- **Pages built:** seven overview Descriptions (one *extend*, six *check*) with claim ledgers; the director spot-checked Broyden's Case A error ratios (0.023–0.039, then 7.7e-4), Halley's constants (1/8 and 1/3 from the standard error constant), and others before committing. No script or GIF changed. Final prose counts: Improved Newton 389, Halley 400, Brent 500, Graeffe 417, Nonlinear Systems 441, Broyden 539, Madsen-Reid 1167.
- **Findings:** round 1 only (0 Error, 0 Misleading, 10 Minor). The five substantive Minor findings (Brent F2, Graeffe F2, Nonlinear Systems F2, Broyden F2, Madsen-Reid F2) were reproduced, fixed word-neutrally with a ledger, and confirmed resolved by one checker covering the five pages who saw only the findings and the diffs. Round 1 had no Error or Misleading finding, so no round 2 was run.
- **Open, for Jason:** the five F1 word counts (see the batch 16 README's decision on *check* pages). Madsen-Reid at 1167 words is the extreme case; Graeffe's fixer also noted that the Madsen-Reid page's own title still says "Damped Newton", which is accurate for its halving branch only.
- **Commits:** `17b09ab`, `1d42cb7`, `5a2d4cf`, `22d447b`, `f1d7b17`, `7feba65`, `7693ee6` overviews; `fc38a61` review; `d452458`, `524cbc1`, `efa437f`, `ee33899`, `efdb5db` fixes; the close-out commit.
