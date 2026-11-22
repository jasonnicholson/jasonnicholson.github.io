# Fix record: brents-method

## Findings
### F1 — Minor — fixed
- Reproduced: `grep -n -i "regula\|falsi" brentsbb.jl` → only line 3, the header comment. The plotting loop (lines 117–151) draws f, the shaded bracket [min(b,c), max(b,c)], the bracket lines, the point b and a "Step k: <method>" annotation. Its only data source is `steps = run_brents(...)`, and no regula falsi iterate is computed or drawn. Frame extraction of the committed GIF (`julia .../r3fix/tools/giftools.jl brentsbb.gif .../r3fix/brents-method/fix/committed_bb` → `11 frames`). The contact sheet shows steps 0–10 (Start, Secant, Bisection, Bisection, Secant, IQI, Secant, Secant, IQI, Secant, Min step) with no regula falsi element. The header's claim of a comparison is false.
- Change: `brentsbb.jl` line 3
  - before: `# Non-trivial root ≈ 1.1656. Illustrates fast convergence vs slow Regula Falsi.`
  - after: `# Non-trivial root ≈ 1.1656. Shows the bracket and best estimate b at each step, labelled with the step's method.`
- Check: the new wording matches the plotting code: the bracket shading and lines, the scatter of `st.b` labelled `b = ...`, and `annotate!(... "Step $(i-1): $meth")`. It also matches the 11 frames on the contact sheet. The root value is unchanged and was rechecked: `/usr/bin/python3 -c "from scipy.optimize import brentq; import numpy as np; print(brentq(lambda x: np.tan(x)-2*x, 0.5, 1.5, xtol=1e-15))"` → `1.1655611852072112` (≈ 1.1656). After regeneration the GIF is byte-identical, as expected for a comment-only change: md5 `2e65ee73ad60a3af540b23f1e34930ee` before and after.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `brentsbb.jl` line 3 | "Non-trivial root ≈ 1.1656" (unchanged number) | scipy `brentq` on tan(x) − 2x over [0.5, 1.5] → 1.1655611852072112 | yes |
| `brentsbb.jl` line 3 | "Shows the bracket and best estimate b at each step, labelled with the step's method." | Read the plot loop (bracket fill and vlines from `st.b`/`st.c`, scatter at `st.b`, annotation `Step k: meth`). Contact sheet of all 11 frames shows this on every frame. | yes |

`index.qmd` and `brentsaa.jl` are not changed.

## Scripts and GIFs
- Script changed: `brentsbb.jl` (comment only). Regenerated `brentsbb.gif` with `julia brentsbb.jl`. Its md5 is unchanged (`2e65ee73ad60a3af540b23f1e34930ee`), so the GIF is byte-identical to the committed one. `brentsaa.jl` is not touched and was not rerun.
- Frames viewed: the contact sheet of the committed `brentsbb.gif` (11 frames). The new GIF is byte-identical, so the frames are the same.
- `git status --short -- pages/numerical-methods/brents-method` → ` M brentsbb.jl` (only).

## Legacy archive
Consulted: `n2003/brentmethod/`. `BrentMethodMod.html` itself is absent; only `BrentMethodMod/Links/*.html` and `Images/` are present. Link 7 (Example 5) uses Brent's method on an equation over an interval. The equation and interval are rendered as images, and I did not view them. The example's text compares Brent's method with bisection ("about 50 iterations") and Regula Falsi ("about 243 iterations"). The comparison appears only in text, with no animation. This is probably where the old header wording came from. The page's own comparison numbers (165 regula falsi iterations to 10⁻¹⁰) were confirmed by the round-3 review (ledger C2-9). They are outside this finding and were not changed.

## Notes
- Comment-only fix: the GIF and page are unchanged.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `brentsbb.jl` line 3 no longer says "Illustrates fast convergence vs slow Regula Falsi". It now reads "Non-trivial root ≈ 1.1656. Shows the bracket and best estimate b at each step, labelled with the step's method." I checked this against the plotting code (lines 117–151). Each frame draws the shaded bracket [min(b,c), max(b,c)] with dashed vlines labelled "bracket" (lines 138–141). It draws a red dot at (b, f(b)) with legend "b = …" (lines 144–147). It adds the annotation "Step k: <method>" coloured by method (lines 149–150). Nothing computes or draws regula falsi.
- I looked at frames 1, 6 and 11 at full size. They show "Step 0: Start" with the bracket [0.5, 1.5] and b = 0.5, "Step 5: IQI" with a narrow bracket and b = 1.17666, and "Step 10: Min step" with a collapsed bracket and b = 1.165561. All agree with the new comment.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| brentsbb.jl:3 | "Non-trivial root ≈ 1.1656" (unchanged number on changed line) | mpmath findroot of tan(x)−2x at 30 digits gives 1.165561185207211…, which rounds to 1.1656 | True |
| brentsbb.jl:3 | "Shows the bracket … at each step" | Code lines 138–141 shade and outline [min(b,c), max(b,c)] in every frame. Frames 1, 6 and 11 confirm. | True |
| brentsbb.jl:3 | "best estimate b at each step" | Red dot at st.b (lines 144–147). b is the endpoint with smaller \|f\| (lines 47–50). At step 0, b = 0.5 is correct because \|f(0.5)\| ≈ 0.454 < \|f(1.5)\| ≈ 11.1. | True |
| brentsbb.jl:3 | "labelled with the step's method" | The annotation is "Step k: <method>" (IQI/Secant/Bisection/Min step). Step 0 is labelled "Start" because no method has been applied yet. | True (the initial frame is naturally "Start") |

### New problems
None. This rests on the following:
- The diff is a single comment line. Code, GIF and index.qmd are untouched in this page folder, so behaviour cannot have changed.
- The regenerated GIF is byte-identical to the committed one, and the committed GIF is identical to HEAD.
- Each claim in the new comment is checked against both the code and the frames.

### Reproducibility and conventions
- Reproducibility: I ran a scratch copy of `brentsbb.jl` with `julia brentsbb.jl`. Its output `brentsbb.gif` is byte-identical (`cmp`) to the page's `brentsbb.gif`, and `git diff HEAD` shows the GIF unchanged. There are 11 frames.
- Conventions: index.qmd is unchanged. Description comes before Animations, each case has a "[Julia source]" link and a GIF embed with descriptive alt text, and there are no code blocks.
- Files outside the page folder: `fix.diff` for this fix touches only `pages/numerical-methods/brents-method/brentsbb.jl`. The working tree has modifications in other page folders, but they belong to other pages' concurrent fixes and are not part of this page's diff.

**Final status:** committed
