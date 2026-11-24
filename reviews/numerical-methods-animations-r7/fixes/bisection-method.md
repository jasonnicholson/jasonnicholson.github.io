# Fix record: bisection-method

## Findings
### F1 — Minor — fixed
- Reproduced: `bisectionbb.jl` line 36 (and `bisectionaa.jl` line 33) use `if f(as[i]) * f(c) < 0` → `b = c`, else `a = c`. Independent exact-rational run of three update rules, 12 steps (`/usr/bin/python3 -I variants.py` in the scratch folder `r7fix/bisection-method/fix/`):
  - tan, strict `f(a)f(c) < 0 → b = c`: c1..c3 = 1, 1.5, 1.75; final [1.5703125, 1.57080078125]
  - tan, non-strict `f(a)f(c) <= 0 → b = c`: c1..c3 = 1, 0.5, 0.25; final [0, 0.00048828125]
  - tan, Mathews `sign f(b) == sign f(c) → b = c`: same as strict
  - poly (Case 1): all three rules identical, final [1.364990234375, 1.36572265625]
  - Julia double precision: `tan(0.0)*tan(1.0)` = `0.0`, `< 0` is `false`, so the script keeps [1, 2].
  The page sentence credited the step to "bisection" in general; it is a property of the strict test. Finding holds.
- Change: `index.qmd` line 31. Before: "The first midpoint is $c_1 = 1$; since $f(0)\,f(1) = 0$ is not negative, bisection keeps $[1, 2]$ and walks away from that root." After: "The first midpoint is $c_1 = 1$. This implementation moves $b$ only when $f(a)\,f(c) < 0$; since $f(0)\,f(1) = 0$ is not negative, it keeps $[1, 2]$ and walks away from that root. (A variant testing $f(a)\,f(c) \le 0$ would keep $[0, 1]$ and converge to the root at 0.)" (the review's suggested text). No script or GIF change (D7/R7-D: text only; the animation is right).
- Check: variants.py output above. Under the non-strict rule, after step 1 the bracket is [0, 1] and every later midpoint satisfies f(0)f(c) = 0 ≤ 0, so b = c each step and c_k = 2^(1−k) → 0 (c12 = 0.00048828125).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.31 | "$c_1 = 1$" | variants.py → tan strict c1 = 1.0 | yes |
| index.qmd l.31 | "moves $b$ only when $f(a)\,f(c) < 0$" | `bisectionbb.jl` l.36–42: `< 0` → `bs[i+1] = c`, else `as[i+1] = c` | yes |
| index.qmd l.31 | "$f(0)\,f(1) = 0$ is not negative, it keeps $[1, 2]$" | `julia -e 'println(tan(0.0)*tan(1.0), " ", tan(0.0)*tan(1.0) < 0)'` → `0.0 false`; variants.py strict c2 = 1.5 | yes |
| index.qmd l.31 | "variant testing $f(a)\,f(c) \le 0$ would keep $[0, 1]$ and converge to the root at 0" | variants.py non-strict → c1..c3 = 1, 0.5, 0.25; final [0, 0.00048828125] | yes |

## Scripts and GIFs
- No scripts changed; no GIFs regenerated (the round-7 review found both regenerate byte-identical).
- `git status --short -- pages/numerical-methods/bisection-method` → ` M pages/numerical-methods/bisection-method/index.qmd` only.

## Legacy archive
Consulted: `n2003/BisectionMod.html` (text) and the subroutine images `bisection/BisectionMod/Images/BisectionMod_gr_11.gif` and `_640.gif`. Mathews' rule is `If[Sign[f[b]] == Sign[f[c]], b = c, a = c]`, which on tan x, [0, 2] gives the same steps as the script (variants.py). The page now names the script's strict test; it is faithful to Mathews, so no change to the animation.

## Notes
- The page has no `## Description` section (pre-existing convention gap, not named by a finding; not added).
- Not touched: the intro's "narrows the bracket to the half that still contains the sign change" remains true for both cases (kept endpoints have strictly opposite signs at every step, per the review's claim 5).

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `index.qmd` line 31 now attributes the step to "this implementation", states the strict test `f(a)f(c) < 0` that moves `b`, and adds the `<= 0` variant. The text matches `bisectionbb.jl` lines 36-42 (strict `< 0` sets `b = c`, otherwise `a = c`). My own Float64 run of both rules on tan, [0, 2], 12 steps gave: strict rule midpoints 1, 1.5, 1.75, 1.625, final bracket [1.5703125, 1.57080078125], which contains π/2 = 1.5707963. The `<=` rule gave 1, 0.5, 0.25, 0.125, final bracket [0, 0.00048828125], which contains the root 0. tan(0) = 0.0 exactly in Float64, so f(0)f(1) = 0 and the strict test fails as the page says. The script and GIF are unchanged and still agree with the page. The script header comment (lines 4-5) is consistent with the new text.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd L31 | "first midpoint is $c_1 = 1$" | (0+2)/2 = 1 | correct |
| index.qmd L31 | "moves $b$ only when $f(a)f(c) < 0$" | script L36-38 | correct |
| index.qmd L31 | "$f(0)f(1) = 0$ is not negative" | tan(0) = 0 exactly, so the product is 0 | correct |
| index.qmd L31 | "keeps $[1, 2]$ and walks away from that root" | else branch: a = 1, b = 2; the strict run ends at [1.5703125, 1.5708008] | correct |
| index.qmd L31 | "variant testing $f(a)f(c) \le 0$ would keep $[0, 1]$ and converge to the root at 0" | `<=` run: b = c every step, so the bracket is [0, 2^(1-k)]; after 12 steps it is [0, 0.00048828125] | correct |

### New problems
None. This rests on: the only change is one sentence of `index.qmd` (the diff has no script or GIF changes), and every claim in that sentence was checked above by direct computation against the script's rule.

### Reproducibility and conventions
- No script or GIF changed in this fix, so there was nothing to regenerate. The committed `bisectionbb.gif` and `bisectionaa.gif` are untouched.
- The page folder diff contains only `index.qmd`. The repo-wide working tree has changes on other pages too, but none of them are in this page's diff.
- Each case has a source link and a GIF embed, the alt text is descriptive, and the page has no code blocks.
- Pre-existing deviation, not introduced by this fix: the page has no `## Description` section before `## Animations`, which the conventions call for. HEAD has the same structure.

**Final status:** committed
