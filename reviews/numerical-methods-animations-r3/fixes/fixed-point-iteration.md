# Fix record: fixed-point-iteration

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/fixed-point-iteration/fix/`
- `check.py`: independent mpmath (50-digit) checks, run with `/usr/bin/python3 -I check.py`
- `instr.jl`: rebuilds the bb/cc iterate arrays exactly as the scripts do, run with `julia instr.jl`
- `eqs.jl`, `eqs.png`: Mathews' formula images for Examples 5 and 6, scaled up
- `legacy_bb/`, `legacy_cc/`: frames of the legacy `Fixpointbb.gif` and `Fixpointcc.gif`
- `new_bb/`, `new_cc/`: frames of the regenerated GIFs

## Findings

### F1 — Minor — fixed
- Reproduced: `python3 -I check.py` gives `ee g'(0) 0.5  g'(2) 1.5` and `ee x9,x10,x12,x14 ['3.753371', '5.3986339', '29.921011', '14373.031']`. So $x=0$ is a fixed point of the Case 5 function with $|g'(0)| = 1/2 < 1$, yet the orbit from 2.03 diverges. The unconditional sentence "Convergence occurs when $|g'(x^*)| < 1$" is false as a global statement. It also says nothing about $|g'(x^*)| > 1$, which Cases 4–6 illustrate.
- Change: `index.qmd` Animations introduction. Before: "Convergence occurs when $|g'(x^*)| < 1$." After: "For continuously differentiable $g$: if $|g'(x^*)| < 1$, the iteration converges to $x^*$ for every starting value close enough to $x^*$; if $|g'(x^*)| > 1$, iterates near $x^*$ (other than $x^*$ itself) move away from it." This is the review's suggested correction, labelled as a general statement with its hypothesis.
- Check: the analytic argument is in the ledger. On the page's own cases (`check.py`):
  - first clause: Cases 1–3 converge to $x^*=2$ with $|g'(2)|=1/2$; Case 4 converges to $x=0$ ($g'(0)=1/2$) from 1.95 but Case 5 does not from 2.03, so "close enough" is needed;
  - second clause: $|x_n-2|$ grows at each step near the repelling $x^*=2$: dd `0.05, 0.074375, 0.1102, 0.1622, 0.2368, 0.3411`; ee `0.03, 0.045225, 0.06835, 0.1037, 0.1582, 0.2436`; ff `0.03, 0.044775, 0.06766, 0.1004, 0.1530, 0.2237, 0.3481`.

### F2 — Minor — fixed
- Reproduced: archive formula images `FixedPointMod_gr_272.gif` and `_313.gif` (rendered in `eqs.png`) read "x = g[x] = √(2x), p₀ = 4.0" and "x = g[x] = 8/(x+2), p₀ = 4.0". The legacy `Fixpointbb.gif` frames show p₀ = 4.00000, p₁ = 2.82843, p₂ = 2.37841, … ; `Fixpointcc.gif` shows p₁ = 1.33333, p₂ = 2.40000, …, and its last frame (`legacy_cc/frame_033.png`) shows p₉ = 1.99707. mpmath from $x_0 = 4.0$ gives `cc x9 1.9970717`, and from $x_0=1.0$ gives `2.0023447`. The page used 3.8 and 1.0. Finding holds.
- Change (R2-A / R3-B: follow Mathews for a starting point):
  - `fixpointbb.jl`: header comment `x0 = 3.8` → `x0 = 4.0 (Mathews Example 5, p0 = 4.0)`; `x0 = 3.8` → `x0 = 4.0`; title `x₀ = 3.8` → `x₀ = 4.0`; `xlims`/`ylims` `(0.0, 4.0)` → `(0.0, 4.2)` with a comment.
  - `fixpointcc.jl`: the same, with `1.0` → `4.0` and "Example 6".
  - The window change: at [0, 4] the x₀ = 4.0 marker was a quarter-disc in the corner and the first vertical step ran along the frame edge, invisible (first test regeneration, frames `new_cc/frame_002.png` before widening). A 0.2 margin is the smallest change that shows them.
  - `index.qmd`: Case 2 heading and alt text `x₀ = 3.8` → `4.0`; Case 3 heading and alt text `x₀ = 1.0` → `4.0`.
- Check: `python3 -I check.py` from $x_0=4.0$:
  - bb: `strictly decreasing True all above 2 True`, x₁₂ = 2.0003385, error ratio 0.499958. So "starting above the fixed point" and "descends monotonically to $x^*=2$" still hold, and "confirming convergence from both sides" still holds with Case 1.
  - cc: `alternates True`, `|err| decreasing True`, x₁₂ = 2.0003662, error ratio −0.500092. So "iteration converges, but the staircase alternates sides of $x^*$ on each step" still holds; $g'(2) = -0.5$.
  - Frames: the legend values in the regenerated GIFs equal `instr.jl`'s rounded values (bb x_12 = 2.0003, cc x_12 = 2.0004).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `index.qmd` intro | "For continuously differentiable $g$: if $\lvert g'(x^*)\rvert<1$, the iteration converges to $x^*$ for every starting value close enough to $x^*$" | Analytic (general, labelled): by continuity, $\lvert g'\rvert\le L<1$ on some $[x^*-\delta,x^*+\delta]$; by the mean value theorem, $\lvert g(x)-x^*\rvert\le L\lvert x-x^*\rvert$, so iterates stay in the interval and the error is at most $L^n\lvert x_0-x^*\rvert\to0$. On the page: Case 4 reaches $x_{16}=0.0193$ toward 0, Case 5 from 2.03 diverges (`check.py` → `x14 14373.031`), so "close enough" is necessary | yes |
| `index.qmd` intro | "if $\lvert g'(x^*)\rvert>1$, iterates near $x^*$ (other than $x^*$ itself) move away from it" | Analytic: $\lvert g'\rvert\ge K>1$ on some neighbourhood, so by the mean value theorem $\lvert g(x)-x^*\rvert\ge K\lvert x-x^*\rvert>\lvert x-x^*\rvert$ for $x\ne x^*$ there. On the page (`check.py`): $\lvert x_n-2\rvert$ increases at every listed step for dd, ee and ff (values under F1); $g'(2)=1.5$ (dd/ee), $-1.5$ (ff) | yes |
| Case 2 heading | $x_0 = 4.0$ | `fixpointbb.jl` `x0 = 4.0`; archive `FixedPointMod_gr_272.gif` "p₀ = 4.0" | yes |
| Case 2 alt | "starting above the fixed point at x₀ = 4.0" | 4.0 > 2; frame `new_bb/frame_001.png` shows the marker at (4, 4), above (2, 2) | yes |
| Case 2 Behavior (unchanged, rechecked) | "starting above the fixed point", "descends monotonically to $x^*=2$" | `check.py` → bb `strictly decreasing True all above 2 True`, x₁₂ = 2.0003385 | yes |
| Case 3 heading | $x_0 = 4.0$ | `fixpointcc.jl` `x0 = 4.0`; archive `FixedPointMod_gr_313.gif` "p₀ = 4.0" | yes |
| Case 3 alt | "oscillating convergent … starting at x₀ = 4.0" | `check.py` → cc `alternates True`, `|err| decreasing True`; frames `new_cc/sheet.png` show a shrinking spiral | yes |
| Case 3 Behavior (unchanged, rechecked) | "converges", "alternates sides of $x^*$ on each step", $g'(2)=-\tfrac12$ | `check.py` → `alternates True`, x₁₂ = 2.0003662, `cc g'(2) -0.5` | yes |
| `fixpointbb.jl` title | "g(x) = √(2x), x₀ = 4.0" | matches `x0 = 4.0`; seen in `new_bb/frame_013.png` | yes |
| `fixpointcc.jl` title | "g(x) = 8/(x+2), x₀ = 4.0" | matches `x0 = 4.0`; seen in `new_cc/frame_013.png` | yes |
| GIF legends bb | x_0 = 4.0, x_1 = 2.8284, x_2 = 2.3784, x_4 = 2.0885, x_6 = 2.0218, x_8 = 2.0054, x_10 = 2.0014, x_12 = 2.0003 | `julia instr.jl` → `[4.0, 2.8284, 2.3784, 2.181, 2.0885, 2.0438, 2.0218, 2.0109, 2.0054, 2.0027, 2.0014, 2.0007, 2.0003]`; mpmath `2.8284271, 2.3784142, …, 2.0003385` | yes |
| GIF legends cc | x_0 = 4.0, x_2 = 2.4, x_4 = 2.0952, x_6 = 2.0235, x_8 = 2.0059, x_10 = 2.0015, x_12 = 2.0004 | `julia instr.jl` → `[4.0, 1.3333, 2.4, 1.8182, 2.0952, 1.9535, 2.0235, 1.9883, 2.0059, 1.9971, 2.0015, 1.9993, 2.0004]`; mpmath agrees | yes |
| Script header comments | "x0 = 4.0 (Mathews Example 5, p0 = 4.0)" / "(Mathews Example 6, p0 = 4.0)" | archive text: Example 5 "Monotone Decreasing" uses `_272.gif`; Example 6 "Spiral" uses `_313.gif` (lines 272–283 of `FixedPointMod.html`) | yes |
| Script window comment | margin so the x0 marker and first vertical step are not on the frame edge | `julia instr.jl` → `all in window [0,4.2]: true` for both; `new_bb/frame_002.png` shows the first vertical step at x = 4 inside the frame | yes |

## Scripts and GIFs
- Scripts changed: `fixpointbb.jl`, `fixpointcc.jl`. GIFs regenerated: `fixpointbb.gif`, `fixpointcc.gif` (13 frames each). The other four GIFs were not regenerated and are unchanged (`git diff --quiet` true for aa, dd, ee and ff).
- Frames viewed:
  - bb: contact sheet, plus frames 1, 2, 7 and 13 at full size (one set before and one after the window change).
  - cc: contact sheet, plus frames 2 and 13 at full size.
  - What I checked: the cobweb vertices lie on the curve and on the diagonal; the bb staircase descends; cc spirals inward and alternates sides; the legend values equal the computed values; titles show x₀ = 4.0; nothing is clipped after the window change.
  - Pre-existing and unchanged: in cc the top-left legend box covers the curve near (0, 4).
- `git status --short -- pages/numerical-methods/fixed-point-iteration` after regeneration:
  ```
   M fixpointbb.gif
   M fixpointbb.jl
   M fixpointcc.gif
   M fixpointcc.jl
   M index.qmd
  ```

## Legacy archive
Consulted:
- `n2003/FixedPointMod.html` (text and formula images 271, 272, 312, 313);
- `a2001/Animations/RootFinding/FixedPoint/Fixpointbb.gif` and `Fixpointcc.gif` (all frames).

What it showed:
- Example 5 (Convergence: Monotone Decreasing) is g = √(2x) with p₀ = 4.0. Example 6 (Convergence: Spiral) is g = 8/(x+2) with p₀ = 4.0.
- Both legacy animations use a [0, 4] window, and their printed iterates match mpmath from 4.0 (for example p₉ = 1.99707 against 1.9970717).

Differences from the page:
- The page now uses Mathews' starting values.
- The only departure is the window, [0, 4.2] instead of [0, 4]. It does not change the mathematics. Mathews draws the x = 4 line explicitly, which the site's style does not; the wider window lets the first step show instead.

## Notes
- The page has no `## Description` section, which the conventions require. No finding names this, so it was not added (pre-existing convention gap).
- The Case 1 and Case 3 Behavior sentences ("Since $|g'(2)| = \tfrac12 < 1$, iteration converges") infer convergence of the specific orbit from the local criterion. The computed orbits do converge (Case 1 x₁₂ = 1.99854; Case 3 x₁₂ = 2.0003662). These sentences are not part of a finding, so I left them unchanged.
- No ambiguity in the decisions: R2-A/R3-B name starting points as parameters to follow, and following Mathews contradicts nothing confirmed in round 1.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: the unconditional "Convergence occurs when $|g'(x^*)| < 1$" is gone. It has been replaced by: "For continuously differentiable $g$: if $|g'(x^*)| < 1$, the iteration converges to $x^*$ for every starting value close enough to $x^*$; if $|g'(x^*)| > 1$, iterates near $x^*$ (other than $x^*$ itself) move away from it."
- Both clauses are true. If $|g'(x^*)| = L < 1$ and $g'$ is continuous, then by the mean value theorem $|g(x)-x^*| \le q|x-x^*|$ with $q<1$ on some interval around $x^*$, which is the local contraction. If $|g'(x^*)| > 1$, then $|g(x)-x^*| > |x-x^*|$ on a punctured neighbourhood.
- Numerical spot checks (`check/indep.py`):
  - $g=\sqrt{2x}$ at $2\pm0.1$: the distance to $x^*$ shrinks.
  - $x^2/4+x/2$ and $-x^2/4-x/2+4$ at $2\pm10^{-3}$ and $2\pm10^{-2}$: the distance grows in all 8 tests.
- The statement now covers the $>1$ cases (4, 5 and 6) and no longer conflicts with Case 5.

### F2 — resolved
- Evidence: both scripts now use `x0 = 4.0`. This follows R2-A/R3-B ("follow Mathews" for starting points).
- Archive confirmation: `FixedPointMod_gr_271.gif` is $g=\sqrt{2x}$ and `_gr_272.gif` is $p_0 = 4.0$ (Example 5, Monotone Decreasing). `_gr_312.gif` is $8/(x+2)$ and `_gr_313.gif` is $p_0 = 4.0$ (Example 6, Spiral). The script comments "Mathews Example 5/6, p0 = 4.0" are correct.
- Recomputed with mpmath at 30 digits from $x_0 = 4$:
  - $\sqrt{2x}$: 4, 2.82843, 2.37841, 2.18102, …, $x_{12}$ = 2.00034. Strictly decreasing and always above 2.
  - $8/(x+2)$: 4, 1.33333, 2.4, 1.81818, 2.09524, …, $x_9$ = 1.997072, $x_{12}$ = 2.00037. It alternates sides of 2 at every step.
- $x_9$ = 1.99707 matches the legacy `Fixpointcc.gif` value "p9 = 1.99707".
- Both orbits lie in [1.333, 4.0], inside the new [0, 4.2] window.
- The headings, alt text, GIF titles and legends all say 4.0.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Intro | "For continuously differentiable g: if \|g'(x*)\|<1 … converges … close enough; if \|g'(x*)\|>1, iterates near x* (other than x*) move away" | MVT argument plus 10 numerical neighbourhood tests (indep.py) | True |
| Case 2 heading | $x_0 = 4.0$ | script `x0 = 4.0`; archive gr_272 | Correct |
| Case 2 Behavior (unchanged text, new x0) | "starting above … descends monotonically to $x^*=2$" | orbit from 4 strictly decreasing, all > 2 | True |
| Case 2 alt text | "starting above the fixed point at x₀ = 4.0" | 4 > 2 | True |
| Case 3 heading | $x_0 = 4.0$ | script; archive gr_313 | Correct |
| Case 3 Behavior (unchanged, new x0) | "converges … alternates sides of $x^*$ on each step", $g'(2)=-1/2$ | sign of $(x_i-2)(x_{i+1}-2)<0$ for all 12 steps; mpmath diff gives g'(2) = −0.5 | True |
| Case 3 alt text | "starting at x₀ = 4.0" | script | Correct |
| fixpointbb.jl title | "g(x) = √(2x), x₀ = 4.0" | script parameters | Correct |
| fixpointcc.jl title | "g(x) = 8/(x+2), x₀ = 4.0" | script parameters | Correct |
| bb legend frames 0/6/12 | x_0 = 4.0, x_6 = 2.0218, x_12 = 2.0003 | mpmath rounded to 4 dp: 4.0, 2.0218, 2.0003 | Correct |
| cc legend frames 0/6/12 | x_0 = 4.0, x_6 = 2.0235, x_12 = 2.0004 | mpmath: 4.0, 2.0235, 2.0004 | Correct |
| xlims/ylims | (0, 4.2) | contains the whole orbit, [1.333, 4] | Fine |

### New problems
None. This rests on the following checks:
- I viewed full-size frames 1, 7 and 13 of both regenerated GIFs.
  - The cobweb steps run vertically from the diagonal to the curve and horizontally back to the diagonal.
  - The first vertical step at x = 4 is clear of the frame edge.
  - Titles and legends are legible and match the computed values.
  - The Case 3 spiral starts above $x^*$ and closes onto (2, 2).
- I compared these with the pre-fix GIFs (from `git lfs smudge`). Nothing that was right before is broken. In Case 3, the magenta curve near (0, 4) runs under the top-left legend, as it did before the fix, so this is not new.
- Pre-existing and not introduced by this fix: the page has no `## Description` section, which the conventions file requires. It was also absent at HEAD.

### Reproducibility and conventions
- I copied `fixpointbb.jl` and `fixpointcc.jl` to scratch and ran them with `julia`. Both outputs are byte-identical to the committed GIFs:
  - `fixpointbb.gif`: sha256 ddb130d3…37b5
  - `fixpointcc.gif`: sha256 02f25a0a…c28d
  - These are the same oids as in the LFS pointers in the diff.
- Each case keeps its source link and embed, the alt text is descriptive, and the page has no code blocks.
- The Description section is missing (pre-existing, see above).
- This fix changed files only inside the page folder: the diff lists only the page's 5 files. The other modified files in the tree belong to other pages' concurrent fixes and their fix records.

**Final status:** committed
