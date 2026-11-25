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

---

# Batch 2: closing summary (2026-11-24)

## Pages built

| Page | Text (Phase 1) | Animations (Phase 2) |
|---|---|---|
| [Golden Ratio Search](../../pages/numerical-methods/golden-ratio-search/) | written from `GoldenRatioSearchMod`, all six module examples (Exercises 4 and 5 as Examples 4 and 5) | `goldenaa` rebuild of Mathews' lost Example 6 animation (from his surviving plotting program gr_222); `goldenbb` new, Example 1; `goldencc` new, Example 2's function on all of [−1, 1] (not unimodal) |
| [Quadratic Interpolative Search](../../pages/numerical-methods/quadratic-interpolative-search/) | written from `QuadraticSearchMod`, which covers quadratic and cubic search; all four examples | `quadraticaa` rebuild of Mathews' lost Quadratic animation (Example 3); `cubicaa` rebuild of his lost Cubic animation (Example 4) |
| [Newton's Search Method](../../pages/numerical-methods/newtons-search-method/) | written from `NewtonSearchMod`, which is two-variable Newton search (gradient and Hessian); all six examples | three new animations on contour maps (no Mathews original): Example 5 minima and saddles with the local quadratic model, Example 6 convergence vs divergence, Example 4 Rosenbrock |

Every GIF regenerates byte for byte from its committed script (checked by each builder, by the director, and in each review round's Phase 1). Golden Ratio Search was the pilot for Phase 2; it passed the pilot checks unchanged.

## Findings by round and severity

| Round | Folder | Error | Misleading | Minor | Calibration pilot (planted errors caught) |
|---|---|---|---|---|---|
| 1 | `reviews/batch-2` | 0 | 0 | 10 | Golden Ratio (2 of 2) |
| 2 | `reviews/batch-2-r2` | 1 | 0 | 4 | Quadratic search (2 of 2) |
| 3 | `reviews/batch-2-r3` | 0 | 0 | 6 | Newton's search (2 of 2) |

The only Error was round 2's: the Quadratic search page stated Mathews' case (ii) implication "then p₂ < p", which is false (only p₁ < p follows; the page's own Example 3 is a counterexample). An independent checker confirmed it from the allegation alone.

## What was fixed

Every finding in every round was reproduced by a fixer, fixed in the page text, and then judged by a different checker who saw only the original findings and the diff. No script or GIF changed after Phase 2. Two checkers found a further small problem in the changed or neighbouring text (a convergence-table range in round 1 on Newton's search; an over-strong "only for" in round 3 on Quadratic search); each went back to the same fixer and was re-checked. Fixers also corrected two errors the reviews had missed: a ratio (2.00 → 1.99) on Quadratic search and the unmeasurable eighth convergence ratio on Newton's search (now "first seven steps").

Main fixes: round 1, number and range corrections, a print-order description of Mathews' Example 3 listing, the G > 0 condition in the cubic root-choice callout, the conditions of the 400-digit experiment, the not-animated list and the 5-step note on Newton's search; round 2, the case (ii) Error, the Float64 differences in the Golden Ratio tables, the k = 11 threshold and the title-precision statement on Newton's search; round 3, outward-rounded bounds in Golden Ratio Example 5, the |h| cap and all-zero stopping rule of Mathews' quadratic subroutine, and two wording corrections.

## Open

Nothing. No finding was left unresolved after two fix rounds, and none was deferred.

## Decisions taken for Jason to revisit

1. **Newton's Search Method is two-dimensional.** The plan put it in the one-dimensional-search batch, but Mathews' module is two-variable Newton search, so the page and its animations are contour-map paths, not a 1-D bracket. The 1-D formula appears only as the n = 1 case.
2. **Quadratic Interpolative Search covers cubic search too,** because the module does; the cubic animation uses the prefix `cubic`.
3. **Newton round 1 M5:** Mathews runs 5 steps from the saddle start (1.0, 0.8); the page and animation keep 3 steps and say that steps 4 and 5 repeat P₃ to 12 decimals, rather than extending the run and regenerating the GIF.
4. **Newton round 2 M2:** Case 1 titles drop trailing zeros (`%.4g`) while Cases 2 and 3 keep them; the page text now says so, rather than changing the script and regenerating the GIF.
5. **Case 3 of Golden Ratio Search** (the run on all of [−1, 1], where f is not unimodal) is a new animation added to show why unimodality matters; it is not in Mathews.
6. `newtonsearchaa.gif` is 2.9 MB (25 frames at 1280×680 with dense contours), the largest GIF in the section.

## Process notes

- Subagents in this harness cannot write report files, so reviewers returned reports as text and the director wrote the per-page files.
- MATLAB was not run anywhere; quarto was run only by the director.

## Commits on `batch-2`

```
e027822 Record batch 2 archive paths in the plan
dd9d9cf Write Newton's Search Method page text (batch 2)
6596741 Write Golden Ratio Search page text (batch 2)
b0f416c Write Quadratic Interpolative Search page text (batch 2)
5b7f4fc Add Golden Ratio Search animations (batch 2)
2b72542 Add Quadratic Interpolative Search animations (batch 2)
ea7163f Add Newton's Search Method animations (batch 2)
f9a2662 Add batch 2 review
67b9d1d Fix Golden Ratio Search (batch 2 review)
3736ad5 Fix Quadratic Interpolative Search (batch 2 review)
4d95e77 Fix Newton's Search Method (batch 2 review)
f801d9d Add batch 2 review round 2
89de306 Fix Quadratic Interpolative Search (batch 2 review round 2)
1e881d9 Fix Golden Ratio Search (batch 2 review round 2)
f01ab41 Fix Newton's Search Method (batch 2 review round 2)
773b743 Add batch 2 review round 3
cc03886 Fix Golden Ratio Search (batch 2 review round 3)
a64b2a8 Fix Newton's Search Method (batch 2 review round 3)
f108555 Fix Quadratic Interpolative Search (batch 2 review round 3)
```
plus this closing commit. `quarto render pages/numerical-methods/` completed without errors after the last fix.
