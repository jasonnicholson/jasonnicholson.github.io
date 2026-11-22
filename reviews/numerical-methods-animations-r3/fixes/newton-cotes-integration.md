# Fix record: newton-cotes-integration

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/newton-cotes-integration/fix/`

## Findings

### F1 — Minor — fixed
- Reproduced: `index.qmd` line 17 had `4\sum f(x_{2k-1})+2\sum f(x_{2k})` with no limits. `/usr/bin/python3 -I f1_check.py` (sympy, exact rationals, [0,2]) evaluates the formula for f = x^0..x^3 with two readings of the even sum:
  - limits k=1..n/2-1 (odd sum k=1..n/2): n=2 gives 2, 2, 8/3, 4; n=6 gives 2, 2, 8/3, 4 — equal to the exact integrals 2, 2, 8/3, 4;
  - natural range k=0..n/2: n=2 gives 10/3, 10/3, 16/3, 28/3; n=6 gives 22/9, 22/9, 32/9, 52/9 — wrong, because the endpoints are counted again with weight 2.

  So the unbounded formula is ambiguous and its natural reading is wrong; the finding holds. The script is correct: `julia f1_script.jl` compares `simpson_sum(n)` copied from `newtoncotesbb.jl` (ranges `1:2:n-1`, `2:2:n-2`) with the page formula with the new limits on the page integrand: n=2: 2.4912610172534464 vs 2.4912610172534464; n=4: 1.611786328647445 vs same; n=10: 1.9763885057788257 vs same; n=40: 2.0138900411352303 vs same (bit-identical).
- Change: `index.qmd` line 17, before → after:
  - `$S_n = \tfrac{h}{3}[f(x_0)+f(x_n)+4\sum f(x_{2k-1})+2\sum f(x_{2k})]$.`
  - `$S_n = \tfrac{h}{3}\big[f(x_0)+f(x_n)+4\sum_{k=1}^{n/2}f(x_{2k-1})+2\sum_{k=1}^{n/2-1}f(x_{2k})\big]$ for even $n$.`
- Check: the same two computations above with exactly these limits (sympy exact for degree ≤ 3 at n=2 and n=6; Julia bit-identical to the script at n=2,4,10,40). "for even n" matches the script, whose `n_seq` is 2, 4, …, 40 (all even). At n=2 the even sum is empty (k=1..0), which the script also handles (`n > 2 ? … : 0.0`), and sympy gives the exact values there.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `index.qmd` l.17 | odd-node sum limits `\sum_{k=1}^{n/2}` | `python3 -I f1_check.py` → exact 2, 2, 8/3, 4 for x^0..x^3 at n=2, 6; `julia f1_script.jl` → equals script's `1:2:n-1` sum bit for bit at n=2,4,10,40 | yes |
| `index.qmd` l.17 | even-node sum limits `\sum_{k=1}^{n/2-1}` | same; natural range k=0..n/2 gives 10/3, 22/9, … (wrong), confirming the limits are needed | yes |
| `index.qmd` l.17 | "for even $n$" | `newtoncotesbb.jl` `n_seq` = 2:2:40; formula pairs subintervals, so requires n even | yes |
| `index.qmd` l.17 | `\big[ … \big]` brackets | typographic only, matches the trapezoidal line above | n/a |

## Scripts and GIFs
- No scripts changed; no GIFs regenerated (text-only fix).
- `git status --short -- pages/numerical-methods/newton-cotes-integration` → ` M pages/numerical-methods/newton-cotes-integration/index.qmd` only; `git diff --stat` → 1 insertion, 1 deletion.

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/NewtonCotesMod.html`. Its composite Simpson rule (eq. 13) is an image; the nearby image `NewtonCotesMod_gr_138.gif` shows the written-out case ∫_{x0}^{x4} f dx ≈ (h/3)(f0 + 4f1 + 2f2 + 4f3 + f4), which agrees with the corrected formula at n=4 (odd nodes 1, 3 weight 4; interior even node 2 weight 2; endpoints weight 1). No difference from the fixed page.

## Notes
- The review's non-findings (six-decimal rounding of frame labels, no dots on the trapezoidal GIF, integrand not printed in frames, different sample-count sequences) were not acted on.
- The page was not rendered with Quarto (rendering writes outside the page folder); the change uses only standard MathJax/LaTeX (`\big[`, `\sum_{}^{}`), as already used on line 16.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: `index.qmd` line 17 now reads `S_n = h/3 [f(x_0)+f(x_n)+4 sum_{k=1}^{n/2} f(x_{2k-1}) + 2 sum_{k=1}^{n/2-1} f(x_{2k})]` for even n. Independently checked (check/verify.py, exact rational arithmetic with sympy): for n = 2, 4, 6, 8, 10, 40 on [0,2] the page formula equals the sum of basic Simpson panels h/3[f(x_i)+4f(x_{i+1})+f(x_{i+2})], i = 0,2,...,n-2, for x^0..x^4, and is exact for x^0..x^3. For n = 2 the even sum is empty (k = 1..0), which is correct. The old unlimited reading (k = 0..n/2 for the even sum) gives 22/9 instead of 2 for f = 1 on [0,2], n = 6, confirming the original defect and that the new limits remove it. The ranges match the script (`newtoncotesbb.jl` lines 27-28: `1:2:n-1`, `2:2:n-2`). A 30-digit evaluation of the page formula for the page's integrand at n = 40 gives 2.013890041, matching the GIF's last-frame label "Approximation = 2.01389" at "Sample Points = 41" (viewed full size). Script and GIF are unchanged and were already correct; the finding was text-only.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.17 | `4\sum_{k=1}^{n/2} f(x_{2k-1})` | odd interior nodes x_1..x_{n-1}; equality with panel sum and exactness for degree <= 3 (sympy, exact) | correct |
| index.qmd l.17 | `2\sum_{k=1}^{n/2-1} f(x_{2k})` | even interior nodes x_2..x_{n-2}, endpoints excluded; same checks; n = 2 gives empty sum correctly | correct |
| index.qmd l.17 | `\tfrac{h}{3}`, `f(x_0)+f(x_n)` | unchanged weights; part of the verified identity | correct |
| index.qmd l.17 | "for even $n$" | composite Simpson 1/3 needs an even number of subintervals; script n_seq is all even | correct |
| index.qmd l.17 | `\big[ ... \big]` | typographic only, matches T_n line above | fine |

### New problems
None. Rests on: the diff touches one line of `index.qmd` only (`git diff --stat HEAD` on the page folder: 1 file, 1+/1-); the new formula is verified by exact arithmetic above; notation (n subintervals, x_0..x_n, spacing h) is consistent with the T_n line directly above it and with the scripts' "Sample Points = n+1" labels.

### Reproducibility and conventions
- No script or GIF in the page folder changed (`git diff --quiet HEAD` on `*.jl`, `*.gif` succeeds), so there is nothing to regenerate; reproducibility is unaffected by this fix. Frames of `newtoncotesbb.gif` extracted (21 frames) to confirm the label used above.
- Conventions: Description precedes Animations; each of the four cases has a `[Julia source]` link and a GIF embed with descriptive alt text; no code blocks (zero ``` fences). Unchanged by this fix.
- Files outside the page folder: the working tree has many other modified files under other `pages/numerical-methods/*` folders and untracked `reviews/numerical-methods-animations-r3/fixes/*.md`; these belong to other pages' parallel fixes and to fix records, not to this page's diff. Nothing outside `pages/numerical-methods/newton-cotes-integration/` appears in this page's fix diff.

**Final status:** committed
