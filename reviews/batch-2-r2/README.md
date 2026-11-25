# Batch 2 review, round 2

**Pages reviewed: 3 of 3** (all three pages changed in the round 1 fixes). None skipped. This was a fresh, independent review: neither the director's briefs nor the reviewers drew on round 1's reports or fix records before these findings were final.

**Findings: 1 Error (independently confirmed), 0 Misleading, 4 Minor (unverified).** No implementation or drawing errors on any page. Scripts and GIFs did not change after round 1 (the fixes were text-only), so round 1's regeneration result stands: all 8 GIFs byte-identical to their scripts' output.

As in round 1, each reviewer's claim ledger covered the whole page.

## Calibration

Quadratic Interpolative Search was the pilot. Its reviewer worked on a scratch copy with two planted errors in the Case 2 Behavior paragraph (a false "same side" behaviour sentence and an error value wrong in the third significant figure) and reported both as Errors with its own computations and frame evidence. The planted findings are omitted from the report.

## The finding to read first

- **Quadratic F1 (Error, confirmed):** the case (ii) statement of the bracketing loop says "then p₂ < p". Only p₁ < p follows. The page's own Example 3 contradicts it: the triple (0.4467, 0.5533, 0.66) is doubled although 0.66 > p, and frame 4 of `quadraticaa.gif` shows this. The statement is Mathews' (module image gr_30), carried over unchecked. An independent checker given only the allegation confirmed it by its own proof and run.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [golden-ratio-search](golden-ratio-search.md) | 3 | 3 | 0 | 0 | 1 | reviewed |
| [quadratic-interpolative-search](quadratic-interpolative-search.md) | 2 | 2 | 1 | 0 | 1 | reviewed (calibration pilot) |
| [newtons-search-method](newtons-search-method.md) | 3 | 3 | 0 | 0 | 2 | reviewed |

Minor findings: Golden F1 (Float64 instead of true differences in six table entries); Quadratic F2 ("fourteen decimals" should be thirteen); Newton M1 (the factor reaches 1.5000 by k = 11, not k = 20); Newton M2 (Case 1 titles drop trailing zeros while the introduction says "four significant figures shown").

## Fidelity findings

None this round.

## Patterns, and comparison with round 1

- **Statements carried over from Mathews unchecked.** Quadratic F1 repeats Mathews' own false implication. Round 1 found the same pattern in descriptions of what the archive shows. The archive's prose needs the same checking as its numbers.
- **Precision stated more confidently than computed.** Golden F1 (Float64 differences in a column that elsewhere holds true values), Quadratic F2 (decimal agreement overstated by one), Newton M2 (titles that look shorter than "four figures"). Round 1's ranges-from-a-different-run pattern did not recur.
- **No round 1 finding came back.** Round 1's Observation on the Golden Ratio Example 2–5 difference columns was judged not a finding then; this round's reviewer showed that the column is inconsistent with the Example 1 table and the titles, and reported it as Minor.

## Phase 1 inventory

Every page reference resolves, no file on disk is unreferenced, and the section index links all three pages. No uncommitted changes were present when the run started.
