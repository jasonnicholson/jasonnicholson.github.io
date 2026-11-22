# Fix record: taylor-series-method-for-odes

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/taylor-series-method-for-odes/fix/`

## Findings

### F1 — Minor — fixed
- **Reproduced:** `/usr/bin/python3 signrule.py`. This is my own implementation. The derivatives are derived with sympy as total derivatives in t and c = y^{1/3}, then expanded into monomials t^a c^b. I evaluated each c^b two ways: by the stated rule sign(y)|y|^{b/3}, and in the script's nested form with the sign rule applied to the c^{-2} and c^{-5} factors. Neither reproduces Mathews' printed values:

  | case | Mathews (legacy frame) | sign rule, expanded | sign rule, nested | real cbrt (page) |
  |---|---|---|---|---|
  | order 3, m=12 | 0.1766603 | −0.3486485 | 0.2110644 | −4.4676549 |
  | order 3, m=14 | −3.4636068 | −3.2165052 | −97.3489870 | −109.0749263 |
  | order 4, m=20 | 0.0711898 | −0.0284155 | — | −5.2535013 |
  | order 4, m=16 | −554.44545 | 509.0015055 | — | −7665.8734003 |

  My "expanded" values are not the reviewer's (−0.0155424, 0.0337018, 509.613), because the result depends on how the powers are grouped before the rule is applied. The nested values agree with the reviewer's exactly. In every form, none matches Mathews. The page's sign(y)|y|^{k/3} explanation is therefore unsupported, so the finding holds.
- **Change:** `index.qmd`, text only, with no script or GIF change.
  - Case 1 Behavior, last sentence. Before: "…whose runs go negative before $t=5$, where Mathews' derivative formulas replace each $y^{k/3}$ by $\operatorname{sign}(y)\,|y|^{k/3}$, which for even $k$ and $y<0$ has the opposite sign to $(\sqrt[3]{y})^k$, so his frames show different values (for example $y(5)=0.1766603$ at $m=12$)." After: "…whose runs go negative before $t=5$. There Mathews' frames show different values (for example $y(5)=0.1766603$ at $m=12$); how his program evaluated $y^{1/3}$ for negative $y$ has not been reproduced."
  - Case 2 Behavior, last sentence. Before: "…the runs go negative before $t=5$, where his derivative formulas (as in Case 1) differ from the real cube root, so his frames show different values (for example $y(5)=0.0711898$ at $m=20$)." After: "…the runs go negative before $t=5$, and there, as in Case 1, his frames show different values (for example $y(5)=0.0711898$ at $m=20$)."
- **Check:**
  - `/usr/bin/python3 allm.py` lists y(5) and the negative nodes for all 21 m, for both orders.
  - I read the legacy labels from crops of the legacy frames: `julia crop.jl legacy_aa aa_labels.png 4 6 … 18` and the same for `legacy_bb`.
  - The results confirm every retained statement (see the ledger). `grep -n -i "sign\|derivative formulas" index.qmd *.jl` finds nothing, so no other copy of the mechanism remains.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 1, last sentence | "m = 12 and 14, whose runs go negative before t = 5" (retained) | `allm.py` → order 3, m=12 has negative nodes at t = 4.1667, 4.5833, 5.0; m=14 at 4.6429, 5.0. m=24 and m=28 are negative only at t = 5.0 (no step is taken from a negative value), and all other m have none | yes |
| Case 1 | "There Mathews' frames show different values" | Legacy order-3 frames: m=12 shows 0.1766603 against −4.4676549 here, m=14 shows −3.4636068 against −109.0749263. Frames m=16–32 match `allm.py` to every printed digit (0.1563161, 0.1341734, 0.0895215, −0.0401212, −0.0212395, 0.0127828) | yes |
| Case 1 | "y(5) = 0.1766603 at m = 12" | `aa_labels.png`, row m=12: "y(5) = 0.1766603" | yes |
| Case 1 | "how his program evaluated y^{1/3} for negative y has not been reproduced" | `signrule.py`: the sign rule in expanded and nested forms gives no match (table above). The review's further variants (\|y\|^{k/3}, principal complex power, complex arithmetic) also gave no match. y′ through y'''' are rational in t and y^{1/3} (sympy in `signrule.py`), so for the same nodes the formulas differ only through how y^{1/3} is taken when y < 0 | yes (states only that no reproduction was found) |
| Case 2, last sentence | "for m = 12 to 28 the runs go negative before t = 5" (retained) | `allm.py` → the first negative nodes are at 4.1667, 3.9286, 3.75, 4.4444, 4.25, 4.5833 and 4.8214. For m=32 the only negative node is at t = 5.0 | yes |
| Case 2 | "as in Case 1, his frames show different values" | `bb_labels.png` against `allm.py` for m=12, 14, 16, 18, 20, 24, 28: 0.4929678/−0.5365789, 0.2026955/0.1879762, −554.44545/−7665.8734, 0.0666066/−16.06871, 0.0711898/−5.2535013, −39.08622/−1492.834, −21.680298/−951.447. All seven differ; m=32 matches (−0.080651) | yes |
| Case 2 | "y(5) = 0.0711898 at m = 20" | `bb_labels.png`, row m=20: "y(5) = 0.0711898" | yes |

## Scripts and GIFs
- No script was changed and no GIF was regenerated: the fix is text only. The review's manifest records the committed GIFs as byte-identical to the scripts' output.
- `git status --short -- pages/numerical-methods/taylor-series-method-for-odes` → ` M pages/numerical-methods/taylor-series-method-for-odes/index.qmd` (only).
- The frames I viewed were the legacy GIFs' contact sheets and label crops, used for Mathews' printed values (`legacy_aa/`, `legacy_bb/`, `aa_labels.png`, `bb_labels.png`).

## Legacy archive
- **Consulted.** `n2003/taylorde/` has no `TaylorDEMod.html` (only `TaylorDEMod/Images`, `Links`, `TaylorDEProof.pdf`), so I could not read the module text. The animation HTMLs `a2001/Animations/OrdinaryDE/Taylor1/Tayloraa.html` and `Taylor2/Taylorbb.html` contain only navigation text.
- **What the GIFs show.** `Tayloraa.gif` (order 3) and `Taylorbb.gif` (order 4) show the same IVP and the same m sequence as the page. Their y(5) labels match the page's real-cube-root runs wherever no step is taken from a negative y, and differ where one is (order 3: m=12 and 14; order 4: m=12–28).
- **Difference from the page.** The page keeps the real cube root, which is mathematically correct for y′ = 1 − t·∛y with real y. It notes Mathews' different values without claiming a mechanism.

## Notes
- **Stability sentence (not a finding, left unchanged).** Both Behavior paragraphs still say "The cause is stability". The round-4 review confirmed the surrounding numbers (ledger #20–28, #47–50), and no finding names that sentence.
- **Missing Description section (not a finding, not added).** The page has no `## Description` section; the conventions expect one. Under the lessons rule, a convention gap that no finding names is not added.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the unsupported mechanism ("replace each y^{k/3} by sign(y)|y|^{k/3}, which for even k ... has the opposite sign") is gone from both cases. `grep -i sign` on the page folder finds nothing. Case 1 now says the exceptions m = 12 and 14 "go negative before t=5. There Mathews' frames show different values (for example y(5)=0.1766603 at m=12); how his program evaluated y^{1/3} for negative y has not been reproduced." Case 2 says "for m=12 to 28 the runs go negative before t=5, and there, as in Case 1, his frames show different values (for example y(5)=0.0711898 at m=20)."
- I checked every remaining claim independently (`check/run.py`, a Python reimplementation of both scripts' steps with the real cube root, and the legacy y(5) labels from all frames of Tayloraa.gif and Taylorbb.gif in `check/aa_labels.png` and `check/bb_labels.png`). All of them hold; see the ledger.
- Attributing the difference to how y^{1/3} is evaluated for negative y is well supported. In both orders the runs that differ from Mathews are exactly those with a negative iterate at a node before t = 5. Runs whose only negative value is the final node at t = 5 match Mathews to every printed digit: order 3 m = 24 (−0.0401212) and m = 28 (−0.0212395), and order 4 m = 32 (−0.080651). So the sentence says only what the evidence supports. The script and GIFs were not touched; none were implicated by F1.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.18 (Case 1) | "reproduced to every printed digit for 19 of the 21 values of m" | Computed y(5), order 3, all 21 m, compared with legacy labels. 19 match (m = 44 legacy "0.00816" = 0.0081600). Only m = 12 and 14 differ. | Correct |
| l.18 | "exceptions are m=12 and 14, whose runs go negative before t=5" | Order 3 m = 12: first negative node t = 4.1667 (3 negative nodes). m = 14: t = 4.6429 (2). No other m has a negative node before t = 5; m = 24 and 28 are negative only at t = 5. | Correct |
| l.18 | "Mathews' frames show different values (for example y(5)=0.1766603 at m=12)" | Legacy Tayloraa.gif m = 12 frame reads y(5) = 0.1766603. Real cbrt gives −4.4676549. | Correct |
| l.18 | "how his program evaluated y^{1/3} for negative y has not been reproduced" | A statement of status, consistent with F1 (no variant tried reproduces 0.1766603). Attribution supported by the negative-before-t=5 pattern above. | Correct |
| l.26 (Case 2) | "reproduced to every printed digit for m=32 to 150" (unchanged clause, rechecked) | Order 4 computed vs legacy: m = 32 −0.0806510 / −0.080651; m = 36…150 all match (m = 56 legacy "0.00812" = 0.0081200). | Correct |
| l.26 | "for m=12 to 28 the runs go negative before t=5" | First negative node: m = 12 t = 4.17; 14: 3.93; 16: 3.75; 18: 4.44; 20: 4.25; 24: 4.58; 28: 4.82. m = 32 is negative only at t = 5. | Correct |
| l.26 | "as in Case 1, his frames show different values (for example y(5)=0.0711898 at m=20)" | Legacy Taylorbb.gif m = 20 reads 0.0711898. Computed −5.2535013. Every m = 12…28 differs (e.g. 14: legacy 0.2026955 vs 0.1879762; 16: −554.44545 vs −7665.8734). | Correct |

### New problems
None. This rests on the following:
- The diff changes only the final sentence of each Behavior paragraph.
- Every claim and number in those sentences was recomputed and checked against the legacy frames.
- No other text, script or GIF changed, and nothing on the page still asserts the old mechanism.

### Reproducibility and conventions
- Scripts and GIFs: unchanged. `git status` and `git diff --stat HEAD` for the page folder show only `index.qmd` (2 lines). No regeneration was needed, and committed GIFs remain those produced by the unchanged scripts.
- Files outside the page folder: fix.diff covers only this folder. Other `pages/numerical-methods/*` folders show modifications in the working tree, but they belong to other pages' parallel fixes and are not part of this diff.
- Conventions: each case keeps its source link and GIF embed with descriptive alt text (unchanged), and there are no code blocks. One gap predates this fix: the page has no `## Description` section before `## Animations`, and neither did HEAD. The fix did not introduce it, and adding one is outside F1's scope.

**Final status:** committed
