# Review round 3: Faddeev-Leverrier Method (batch 10, text-only)

Page: `pages/numerical-methods/faddeev-leverrier-method.qmd` (after the round-2 fix). Module: `n2003/FaddeevLeverrierMod.html`. The reviewer consulted the archive (module, the 4 link pages, formula images gr_9, 18–37, example matrices and the Example 1 and 2 solution images; Example 3's are missing) and did not read earlier rounds' reports. The claim ledger covers the whole page, including the rewritten floating-point section.

**Calibration page.** This was the round's only page and its pilot, reviewed on a scratch copy with two planted errors (Example 2's boxed $\lambda_2$ wrong in the second decimal; a false sentence that every $B_k$ of Example 3 is tridiagonal). The reviewer found both, and they were its only findings. They are removed. The copy had the same line count as the page.

**Findings: 0 Error, 0 Misleading, 0 Minor.**

## Inventory (mechanical checks, rerun after the fix)

No control characters, no leftover "(Planned)" / "Animation Focus" / legacy stub, no `localhost` link, no code block, no link to a missing target.

## Claim ledger (condensed; 120 entries)

Confirmed, apart from the two planted claims: everything in rounds 1 and 2's ledgers (definitions, recursion, theorem and proof, Newton's identities, conventions, Examples 1–3 in full, practical notes), the floating-point table (every entry inside the reviewer's 10-seed spread; exact values depend on the seed), the matching definition, and the rewritten $n = 20$ decomposition. The reviewer reproduced it over 320 seeds: 120-digit coefficients with high-precision roots give 5.3×10⁻¹⁵ to 2.8×10⁻¹⁴; rounded coefficients with high-precision roots 2.4×10⁻⁴ to 3.5×10⁻²; the recursion's coefficients (relative error 1.3×10⁻¹⁰ to 5×10⁻⁸) with high-precision roots 0.0021 to 0.28, median ratio to rounding alone 6.5; the root finder's own shift 0.0024 to 0.51; and with a double root finder, 0.0033 to 0.51 for rounded coefficients and 0.0095 to 0.55 for the recursion's. All are within the page's "about" ranges.

Note (not a finding): the table note "up to n = 20 every root is real" describes the table's own draws (true there). In the reviewer's 320-seed batch at n = 20, 5 seeds gave one complex pair.

## Checks

`ex.py`, `ex2.py` (sympy exact: the recursion as written on all three examples, Newton's identities, the adjugate, the singular case, Wilkinson's coefficients), `fp.py` (the table, 10 seeds per n), `fp20.py` (the $n = 20$ decomposition, 320 seeds).
