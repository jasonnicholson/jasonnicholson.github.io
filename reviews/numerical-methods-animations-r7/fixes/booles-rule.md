# Fix record: booles-rule

Scratch folder (re-runnable evidence): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/booles-rule/fix/` (`dop.py`, `order.py`).

## Findings

### F1 — Minor — fixed
- **Reproduced:** `index.qmd` line 17 ended "making it the highest-order closed Newton-Cotes rule in this set." The page names no set. `dop.py` solves the moment equations exactly (sympy, rational arithmetic) for the closed Newton-Cotes rule with m subintervals per panel (m + 1 nodes) and finds its degree of precision:

  | m (subintervals) | 1 | 2 | 3 | 4 (Boole) | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
  |---|---|---|---|---|---|---|---|---|---|---|---|---|
  | degree | 1 | 3 | 3 | 5 | 5 | 7 | 7 | 9 | 9 | 11 | 11 | 13 |

  Boole weights come out as 14/45, 64/45, 8/15, 64/45, 14/45 = (2/45)(7, 32, 12, 32, 7). So Boole is the highest of m = 1 to 4. It is not the highest closed rule overall: m = 6 (seven nodes) reaches degree 7. This confirms the finding.
- **Change:** `index.qmd` line 17. Before: "…making it the highest-order closed Newton-Cotes rule in this set." After: "…making it the highest-order of the four closed Newton-Cotes rules on this site (trapezoidal, Simpson's 1/3, Simpson's 3/8 and Boole). Closed rules with seven or more nodes per panel are exact to higher degree (the seven-node rule to degree 7)."
  - I did not use the review's second sentence, "Closed rules with more nodes reach higher degree", word for word. Its quantifier fails at six nodes: m = 5 has degree 5, the same as Boole. The new sentence names the threshold where the degree actually rises (seven nodes), and the table confirms that every m ≥ 6 gives degree ≥ 7.
- **Check:** `/usr/bin/python3 -I dop.py` gives the table above. `/usr/bin/python3 -I order.py` measures composite orders on e^x over [0,2] (n = 8m to 16m, mpmath 40 digits): trapezoidal 1.9989, Simpson 1/3 3.9980, Simpson 3/8 3.9982, Boole 5.9978. So for smooth f Boole also has the highest global order of the four (6, against 2, 4 and 4). The four-rule set: `pages/numerical-methods/index.qmd` lines 100–103 list Trapezoidal, Simpson's, Simpson's 3/8 and Boole's rule pages. `newton-cotes-integration/index.qmd` has exactly these four cases (headings at lines 25, 33, 41 and 49), and grep finds no other Newton-Cotes or Weddle page.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.17 | "highest-order of the four closed Newton-Cotes rules on this site" | `dop.py` → degrees 1, 3, 3, 5 for m = 1..4. `order.py` → orders 2.00, 4.00, 4.00, 6.00 | yes |
| index.qmd l.17 | "(trapezoidal, Simpson's 1/3, Simpson's 3/8 and Boole)" | index.qmd l.100–103. newton-cotes Cases 1–4. grep for other Newton-Cotes pages finds only these | yes |
| index.qmd l.17 | "seven or more nodes per panel are exact to higher degree" | `dop.py` → m = 6..12 have degrees 7, 7, 9, 9, 11, 11, 13 (all > 5). m = 5 (six nodes) has degree 5 (not higher) | yes |
| index.qmd l.17 | "the seven-node rule to degree 7" | `dop.py` → m = 6: degree 7 | yes |

## Scripts and GIFs
- No scripts changed, and no GIFs were regenerated. The finding is text-only, and R7-D says to leave the animation alone.
- `git status --short -- pages/numerical-methods/booles-rule` → ` M pages/numerical-methods/booles-rule/index.qmd` only.

## Legacy archive
I consulted `n2003/BooleRuleMod.html` (read as stripped text). It states Boole's rule, its remainder term and the composite rule. It makes no claim that Boole's rule is the highest-order rule, so the archive has nothing to say on this finding. The round-7 review already compared the animation with Mathews' Example 11 and `Booleaa.gif` and found no fidelity differences. I did not repeat that comparison, because nothing in the animation changed.

## Notes
- The page lacks no section that the conventions require and that a finding names. Nothing else was touched.
- The review notes two cosmetic labels that drop a trailing zero (2.01268 at n = 28, 2.01537 at n = 64). The review does not count them as a finding, so I left them alone.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The diff replaces "highest-order closed Newton-Cotes rule in this set" (index.qmd line 17) with "highest-order of the four closed Newton-Cotes rules on this site (trapezoidal, Simpson's 1/3, Simpson's 3/8 and Boole). Closed rules with seven or more nodes per panel are exact to higher degree (the seven-node rule to degree 7)." The phrase "this set" is gone. The set is now named, and it matches the four rules listed at `newton-cotes-integration/index.qmd` line 13. Checks I ran myself (`check/dop.py`):
  - I solved the moment equations exactly with sympy for closed rules with 2 to 13 nodes. The degrees of precision are 1, 3, 3, 5, 5, 7, 7, 9, 9, 11, 11, 13. Boole (5 nodes) has degree 5, and the 6-node rule also has degree 5. Seven nodes is therefore the exact point where higher degree begins: the seven-node rule has degree 7 and every larger rule has at least 7.
  - The Boole weights come out as 14/45, 64/45, 24/45, 64/45, 14/45, which is (2/45)·(7, 32, 12, 32, 7). This matches the formula on the page.
  - I measured the composite orders by halving h (n from 96 to 192) on the smooth function e^x sin 3x over [0,2]. The results are trapezoidal 2.000, Simpson 1/3 3.999, Simpson 3/8 3.999 and Boole 6.006. So Boole has the highest order of the four.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.17 | "highest-order of the four closed Newton-Cotes rules on this site" | Observed orders 2, 4, 4, 6 by step halving; degrees of precision 1, 3, 3, 5 | True |
| index.qmd l.17 | "(trapezoidal, Simpson's 1/3, Simpson's 3/8 and Boole)" | Same list as newton-cotes-integration l.13; no other closed Newton-Cotes page among the site's pages (Midpoint is open; Romberg and cubic spline are not Newton-Cotes) | True |
| index.qmd l.17 | "Closed rules with seven or more nodes per panel are exact to higher degree" | Exact degree table: 6 nodes gives 5, and 7 or more nodes gives at least 7 | True (the threshold is exact) |
| index.qmd l.17 | "the seven-node rule to degree 7" | Exact moment solve: 7 nodes (6 subintervals) gives degree 7 | True |

### New problems
None. This rests on the following:
- The diff changes only one sentence on line 17, and I checked every claim in it above.
- The script and GIF are unchanged, so no frames needed checking (verified with `git diff HEAD --quiet` on boolesaa.gif and boolesaa.jl).

### Reproducibility and conventions
- Reproducibility: Not applicable. No script or GIF changed, so there was nothing to re-run.
- Conventions: These still hold. The Description section comes before Animations. The case has one source link ([Julia source](boolesaa.jl)) and one embed, with descriptive alt text. The page has no code blocks (0 fences).
- Scope: The git status of the page folder shows only index.qmd changed. The fix diff covers only this page folder. Other modified pages in the working tree belong to other fixes, and nothing in this fix touches them.

**Final status:** committed
