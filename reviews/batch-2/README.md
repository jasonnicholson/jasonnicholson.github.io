# Batch 2 review, round 1

**Pages reviewed: 3 of 3** (Golden Ratio Search, Quadratic Interpolative Search, Newton's Search Method). None skipped.

**Findings: 0 Error, 0 Misleading, 10 Minor.** No implementation or drawing errors on any page: every script runs the method its page names, every iterate matches an independent implementation, and every committed GIF is byte-identical to what its script produces. All findings are in the page text (8 page match, 2 fidelity). Because no finding was Error or Misleading, Phase 3 (independent checking) had nothing to check; the Minor findings are reported unverified, and the director reproduced three of them (Golden F1, Newton M1, Quadratic F2).

Because the page text was written in this batch, each reviewer's claim ledger covered the whole page (worked examples, tables, theorems, implementation notes), not only the Animations section and Description.

The legacy Mathews archive was found at `/home/jason/Desktop/math-fullerton/baseline/mathews/` and every reviewer consulted it.

## Calibration

Golden Ratio Search was the pilot. Its reviewer worked on a scratch copy with two planted errors in the Case 1 Behavior paragraph (a distance wrong in the third significant digit, and a false "alternately" behaviour sentence) and reported both as Errors with its own computations. The brief was not changed. The planted findings are not in this report; the real page's versions of those two sentences were confirmed by the same reviewer's runs.

One process note: subagents in this harness cannot write report files, so reviewers returned their reports as text and the director wrote the page files.

## The findings worth reading first

All are Minor. The ones that state something false:
- **Quadratic F2:** the "Which root" callout says formula (14) stays finite as α → 0; that holds only when G > 0.
- **Quadratic F3:** the 400-digit pass counts (76, 156, 82, 164) exceed the 50-pass limit the page states; the experiment lifted the limits without saying so.
- **Newton M3:** the double-precision rerun value 2.7 × 10⁻²⁹ for Example 4 depends on how the gradient is coded and could not be reproduced.
- **Newton M5 and M6 (fidelity):** the saddle run from (1.0, 0.8) is shortened from Mathews' 5 steps to 3 without saying so, and the "not animated" sentence omits Mathews' other `FindMinimum` comparisons and his vector-field plots.

## Per page

| Page | Scripts | GIFs | Error | Misleading | Minor | Status |
|---|---|---|---|---|---|---|
| [golden-ratio-search](golden-ratio-search.md) | 3 | 3 | 0 | 0 | 1 | reviewed (calibration pilot) |
| [quadratic-interpolative-search](quadratic-interpolative-search.md) | 2 | 2 | 0 | 0 | 3 | reviewed |
| [newtons-search-method](newtons-search-method.md) | 3 | 3 | 0 | 0 | 6 | reviewed |

## Fidelity findings (for Jason to decide as a group)

- Newton M5: Mathews runs the saddle point from (1.0, 0.8) for 5 iterations; the page and animation show 3 (iterates 3–5 agree to 12 decimals).
- Newton M6: the not-animated sentence should also name Mathews' `FindMinimum` comparisons in Examples 3–6 and his gradient vector-field plots in Examples 5 and 6.

## Patterns

- **Ranges and limits quoted from a slightly different run than the one described.** Newton M1 (a range from seven ratios described as eight), Newton M2 (1.05 vs 1.06 for the same five-step run), Quadratic F3 (counts from an unlimited run next to a stated 50-pass limit). The numbers were computed; the stated conditions drifted from the computation.
- **Descriptions of what Mathews' archive shows** were the weakest claims: Quadratic F1 (print order), Newton M6 (not-animated list). Statements about the archive need the same item-by-item check as numbers.
- **General statements without their condition:** Quadratic F2.

## Phase 1 inventory

All 8 scripts ran from scratch copies against the global Julia environment (Plots 1.41.2) and reproduced all 8 committed GIFs byte for byte. Every page reference resolves, no file on disk is unreferenced, and the section index links all three pages. No uncommitted changes were present when the run started.
