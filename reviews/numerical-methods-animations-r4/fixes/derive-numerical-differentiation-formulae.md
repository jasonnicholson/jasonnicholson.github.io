# Fix record: derive-numerical-differentiation-formulae

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/derive-numerical-differentiation-formulae/fix/` (`stencil.py`).

## Findings

### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I stencil.py` solves the Taylor moment system on offsets {-2,-1,0,1,2} with sympy and reports the first nonzero remainder moment:
  - f': weights [1/12, -2/3, 0, 2/3, -1/12], approx − f' = −1/30 h^4 f^(5) + … → order h^4
  - f'': weights [-1/12, 4/3, -5/2, 4/3, -1/12], approx − f'' = −1/90 h^4 f^(6) + … → order h^4
  - f''': weights [-1/2, 1, 0, -1, 1/2], approx − f''' = 1/4 h^2 f^(5) + … → order h^2
  - f'''': weights [1, -4, 6, -4, 1], approx − f'''' = 1/6 h^2 f^(6) + … → order h^2

  Numerical confirmation with mpmath (50 digits) on f = e^{-x} sin x at x = 1, h = 0.1, 0.05, 0.025: observed orders log2(err ratio) = 3.988, 3.997 (f'); 4.003, 4.001 (f''); 1.990, 1.998 (f'''); 2.003, 2.001 (f''''). The page's general sentence "five-point formulas with O(h^4)" is therefore wrong for f''' and f''''.
- Change: `index.qmd` line 60, "…yields five-point formulas with $O(h^4)$ truncation behavior for smooth $f$." → "…yields five-point formulas for $f'$ and $f''$ with $O(h^4)$ truncation error for smooth $f$ (the five-point formulas for $f'''$ and $f^{(4)}$ are only $O(h^2)$)." (the review's correction verbatim).
- Check: the sympy and mpmath output above; the leading coefficients for f''' and f'''' (1/4, 1/6) are nonzero, so those formulas are exactly second order, not better. The legacy module's output images agree (see Legacy archive).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.60 | five-point formulas for f' and f'' are O(h^4) for smooth f | `python3 -I stencil.py` → f' remainder −1/30 h^4 f^(5), f'' remainder −1/90 h^4 f^(6); mpmath observed orders 3.99–4.00 | yes |
| index.qmd l.60 | five-point formulas for f''' and f^(4) are only O(h^2) | `python3 -I stencil.py` → f''' remainder 1/4 h^2 f^(5), f'''' remainder 1/6 h^2 f^(6); mpmath observed orders 1.99–2.00 | yes |
| index.qmd l.60 | "truncation error" (was "truncation behavior") | wording only; the remainder terms above are truncation errors | yes |

## Scripts and GIFs
- No scripts changed; no GIFs regenerated (the finding is text-only; the review's regeneration was byte-identical for all three GIFs).
- `git status --short -- pages/numerical-methods/derive-numerical-differentiation-formulae` → ` M .../index.qmd` only.

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/NumericalDiffFormulaeMod.html` (text) and its images under `differentiationformulae/NumericalDiffFormulaeMod/Images/`. The text says the f' and f'' five-point formulas have one order and the f''' and f'''' formulas another, "one of the many surprises in the theory of numerical analysis". The output images `NumericalDiffFormulaeMod_gr_138.gif` and `_gr_139.gif` show f'''[x0] = (−f[x0−2h] + 2f[x0−h] − 2f[x0+h] + f[x0+2h])/(2h^3) − 1/4 h^2 f^(5)[c] and f^(4)[x0] = (6f[x0] + f[x0−2h] − 4f[x0−h] − 4f[x0+h] + f[x0+2h])/h^4 − 1/6 h^2 f^(6)[c], which agree with the sympy result (Mathews' remainder is exact − formula, hence the opposite sign). Note: the review cites "gr_198" for this; in this module `gr_198.gif` is the `ForwardDiff` code listing, and the f''' and f'''' outputs are in gr_138 and gr_139. The page now agrees with both the mathematics and the archive.

## Notes
- No decision ambiguity: F1 is a Minor text finding, fixed under D5 by one sentence change.
- Nothing outside the page folder was touched except this record.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- The old sentence (index.qmd line 60), which said five-point formulas are O(h^4) with no qualifier, is gone. The new line 60 reads: "Including $x\pm2h$ adds degrees of freedom and yields five-point formulas for $f'$ and $f''$ with $O(h^4)$ truncation error for smooth $f$ (the five-point formulas for $f'''$ and $f^{(4)}$ are only $O(h^2)$)."
- Independent check (`check/moments.py`): I solved the 5x5 Taylor moment system exactly with sympy for the offsets {-2,-1,0,1,2}. With 5 points the weights are unique for each derivative order.
  - f': [1/12,-2/3,0,2/3,-1/12], h^4, leading term -1/30 f^(5)
  - f'': [-1/12,4/3,-5/2,4/3,-1/12], h^4, leading term -1/90 f^(6)
  - f''': [-1/2,1,0,-1,1/2], h^2, leading term 1/4 f^(5)
  - f'''': [1,-4,6,-4,1], h^2, leading term 1/6 f^(6)
- Step-halving check at 60-digit precision on f = e^{-x} sin x at x = 1, h = 0.1 down to 0.00625. The observed orders log2(e_k/e_{k+1}) were:
  - f': 3.988, 3.997, 3.999, 4.000
  - f'': 4.003, 4.001, 4.000, 4.000
  - f''': 1.990, 1.998, 1.999, 2.000
  - f'''': 2.003, 2.001, 2.000, 2.000
- Because the weights are unique, "only O(h^2)" is exact: no other five-point formula on these offsets does better for f''' or f''''.
- The legacy NumericalDiffFormulaeMod.html line 357 has the "one of the many surprises" remark, which agrees.
- The finding has no script or GIF component, and none was changed.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.60 | "five-point formulas for $f'$ and $f''$ with $O(h^4)$ truncation error" | Exact moment solve gives h^4 for both. Measured orders are 4.00 and 4.00. | Correct |
| index.qmd l.60 | "smooth $f$" | The error terms need f^(5) for f' and f^(6) for f''. "Smooth" covers this. | Correct |
| index.qmd l.60 | "five-point formulas for $f'''$ and $f^{(4)}$ are only $O(h^2)$" | Exact moment solve gives h^2 for both, with unique weights. Measured orders are 2.00 and 2.00. | Correct |
| index.qmd l.60 | "$x\pm2h$", "degrees of freedom" | Unchanged wording, still accurate. | Correct |

### New problems
None. This rests on three things:
- The diff is a single line, and I checked every claim in it above.
- The surrounding Derivation Notes (Taylor expansion and the three-point formulas, lines 46-58) are unchanged and still correct.
- The notation mix f''' / f^{(4)} is consistent with the page's own f^{(3)} on line 49.

### Reproducibility and conventions
- **Reproducibility:** not applicable. `git status` of the page folder shows only `index.qmd` modified. No .jl or .gif in the folder changed, so there was nothing to rerun.
- **Conventions:** still kept.
  - `## Description` comes before `## Animations`.
  - Each of the 3 cases has a `[Julia source](...)` link and a GIF embed with descriptive alt text.
  - There are no code fences in index.qmd (0 occurrences of ```).
- **Files outside the page folder:** the per-page diff touches only `pages/numerical-methods/derive-numerical-differentiation-formulae/index.qmd`. The working tree does contain changes to other numerical-methods pages and new files under `reviews/numerical-methods-animations-r4/`. They belong to other pages' fix packages in this run and are not part of this page's fix.

**Final status:** committed
