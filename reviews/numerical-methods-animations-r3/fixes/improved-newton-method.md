# Fix record: improved-newton-method

## Findings
### F1 — Minor (Fidelity) — fixed
- **Reproduced:**
  - Archive. Solution 2 (`n2003/newtonimproved/NewtonImprovedMod/Links/NewtonImprovedMod_lnk_5.html`) has a "Caveat" that says Method A with the wrong choice of m converges linearly. Its code image gr_188 is `NewtonRaphsonAccelerate[1.3, 2, 20]`, which is m = 2 at the triple root. Its tables gr_189/gr_190 give p1 = 1.105882352941176, p2 = 1.036087243886316, p3 = 1.012124024389068, … The page's omission sentence (old line 30) did not mention this caveat.
  - My own computation (`/usr/bin/python3 checks.py` in the scratch folder, mpmath at 40 digits, factored f = (x−1)³(x+2), f′ = (x−1)²(4x+5), x0 = 1.3, step x − 2f/f′) gives x1 = 1.105882352941176, x2 = 1.036087243886319, x3 = 1.012124024389059, …, x20 = 1.000000000094261.
  - The error ratios e_{n+1}/e_n are 0.352941, 0.340824, 0.335964, …, 0.333333. They decrease towards 1/3 at every step. Meanwhile e_{n+1}/e_n² grows without bound: 1.176, 3.219, 9.31, …, 1.18e9. So the convergence is linear, not quadratic, over the whole run.
  - Mathews' expanded-form Float64 table goes below 1 at p13 to p20 (for example p14 = 0.998806538090115). That is an artifact of cancellation. It does not change the conclusion.
- **Change:** `index.qmd`, Animations intro (old line 30 → new lines 30–31).
  - Before: "Cases 1–4 follow Examples 1 and 2 of Mathews' Improved Newton Method module; the module's Example 3, which compares the methods at a quadruple root, and the Method B and Method C iterations of all its examples are not animated here."
  - After: "Cases 1–4 follow Examples 1 and 2 of Mathews' Improved Newton Method module. The module's Example 3, which compares the methods at a quadruple root, the Method B and Method C iterations of all its examples, and the caveats in Examples 1 and 2 are not animated here; Example 1's caveat plots the rounding noise in the expanded $f$ near the double root, and Example 2's runs Method A with the wrong multiplicity ($m = 2$ at the triple root), which converges only linearly."
  - Following R2-A, I added an omission sentence and did not add a case. Under R3-B the list was re-checked against every part of the module (see Legacy archive). That check also found Example 1's caveat missing from the list, so the new sentence names it as well.
- **Check:**
  - Ratios → 1/3 and e/e² unbounded (above): this supports "converges only linearly".
  - Example 1's caveat images: gr_151/gr_154 plot (x−1)²(x+2) − f[x] on [0.5, 1.5]; gr_158–gr_160 plot the expanded f on [0.99999999, 1.00000001], with the message "the graph is just multiples of Machine Epsilon".
  - My Float64 check (`/usr/bin/python3 ex1caveat.py`): max |factored − expanded| on [0.5, 1.5] is 6.66e-16, and 3598 of 4001 sample points are nonzero. From `checks.py`: on [1−1e-8, 1+1e-8] the true |f| is at most 3.0e-16, but the expanded Float64 f is exactly 0 at 1296 of 2001 points. This supports "rounding noise in the expanded f near the double root".
  - R3-D placement: the sentence was already in the Animations intro, after "Julia source scripts … linked under each case." and before Case 1. It stays there.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd l.30 | "Cases 1–4 follow Examples 1 and 2 of Mathews' … module." | Archive statements: Ex 1 is a double root, p0 = 1.3 (lnk_4); Ex 2 is a triple root, p0 = 1.3 (lnk_5). Cases 1–2 use x³−3x+2 and Cases 3–4 the quartic, all at x0 = 1.3 (round-3 ledger rows 13–27, unchanged) | yes |
| index.qmd l.31 | "Example 3, which compares the methods at a quadruple root" | lnk_6 statement says "quadruple root". Code gr_194 has f = x⁵−2x⁴−2x³+8x²−7x+2; expanding (x−1)⁴(x+2) by hand gives the same polynomial | yes |
| index.qmd l.31 | "the Method B and Method C iterations of all its examples … are not animated" | Scripts aa, cc and ee are standard Newton; bb and dd are Method A (m = 2, m = 3). No B or C script exists | yes |
| index.qmd l.31 | "the caveats in Examples 1 and 2" | lnk_4 has a "Caveat." section and lnk_5 has a "Caveat." section. lnk_6 has none (grep for Caveat/Reminder/Summary). No page case shows either caveat | yes |
| index.qmd l.31 | "Example 1's caveat plots the rounding noise in the expanded f near the double root" | Images gr_151–gr_160 (see F1 Check). `ex1caveat.py` → max difference 6.66e-16. `checks.py` → expanded f = 0 at 1296/2001 points where true f ≤ 3.0e-16 | yes |
| index.qmd l.31 | "Example 2's runs Method A with the wrong multiplicity (m = 2 at the triple root)" | gr_188 `NewtonRaphsonAccelerate[1.3, 2, 20]`. lnk_5 text: "Suppose that one chose [m = 2] instead of [m = 3]" | yes |
| index.qmd l.31 | "which converges only linearly" | `checks.py` → e_{n+1}/e_n = 0.353, 0.341, 0.336, …, 0.333333 (→ 1/3 = 1 − 2/3); e/e² = 1.18 → 1.18e9 | yes |

## Scripts and GIFs
- No scripts changed and no GIFs regenerated. The finding is text only.
- `git status --short -- pages/numerical-methods/improved-newton-method` → ` M pages/numerical-methods/improved-newton-method/index.qmd` (only).

## Legacy archive
- **Consulted:** `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/NewtonImprovedMod.html` (main module) and `n2003/newtonimproved/NewtonImprovedMod/Links/lnk_1`–`lnk_6`.
- **Module contents:** an exposition (Definitions 1–2, Theorem 1, Methods A, B and C, Figures 1–2 of the Method C linear search, "Behavior at a Triple Root"); Examples 1–3, with Solutions in lnk_4, lnk_5 and lnk_6; and a "Related Material" link to the separate Newton's-method animations. lnk_1–lnk_3 are cover and derivation pages. There are no Explorations.
- **Example 1** (double root, p0 = 1.3). The page animates its standard Newton and Method A (m = 2) runs. Not animated: its B and C runs, and its Caveat on rounding noise. The Caveat was not listed before this fix.
- **Example 2** (triple root, p0 = 1.3). The page animates its standard Newton and Method A (m = 3) runs. Not animated: its B and C runs, and its Caveat with m = 2. The Caveat was not listed before this fix (F1).
- **Example 3** (quadruple root (x−1)⁴(x+2), p0 = 1.3). Not animated. Its Method A run uses m = 3 (lnk_6 text and gr_199 `NewtonRaphsonAccelerate[1.3, 3, 6]`), which is not the root's multiplicity of 4. My mpmath run gives ratios 0.267, 0.255, 0.251, …, 0.25002, so it is linear with constant 1/4. Its code comment also calls the root a "double root" (a typo). Neither point is on the page, because Example 3 is only named as omitted.
- **Figures 1 and 2** illustrate the Method C linear search. They are covered by "the Method B and Method C iterations … are not animated".
- **Differences between the archive and the page:** none that needed a change. The page follows the mathematics. The archive's late Float64 iterates in the m = 2 caveat (p13–p20 below 1) come from cancellation in the expanded quartic. The page gives no numbers for that run.

## Notes
- I chose the omission sentence over a new Method A (m = 2) case. R2-A says to add one sentence and not the example. The review offered either option.
- The new sentence is longer than the old one. To keep it readable, I split it into two sentences.
- Pre-existing convention gaps: none noticed that a finding names. The "(Planned)" stubs were not touched.
- Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/improved-newton-method/fix/checks.py` and `ex1caveat.py`.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: The diff rewrites the omissions sentence in the Animations intro (index.qmd lines 30–31). It now lists "the caveats in Examples 1 and 2" as not animated and says what each one does. Example 2's caveat "runs Method A with the wrong multiplicity (m = 2 at the triple root), which converges only linearly". This follows the finding's first suggested correction and R2-A/R3-B (add one sentence, do not add the example). It sits in the Animations intro before Case 1, as R3-D requires.
- Archive check: `Links/NewtonImprovedMod_lnk_5.html` (Solution 2, quartic x^4 − x^3 − 3x^2 + 5x − 2 = 0, gr_167). Its Caveat sets m = 2 (gr_186) instead of m = 3 (gr_187), and the table (gr_189) gives p1 = 1.105882352941176, p2 = 1.036087243886316, p3 = 1.012124024389068, … It ends: "If the wrong choice for m is made then convergence will be linear (or slow)."
- Independent computation (`check/verify.py`, mpmath at 40 digits, factored f = (x−1)^3(x+2), x0 = 1.3, step x − 2 f/f′): the iterates are 1.105882352941176, 1.036087243886319, 1.012124024389059, … The error ratios are 0.3529, 0.3408, 0.3360, 0.3342, … → 0.333333, which matches the theory value 1 − m/M = 1 − 2/3 = 1/3. The convergence is linear, so the statement is true.
- R3-B asks that the sentence be checked against every example in the module. The module (NewtonImprovedMod.html) has exactly Examples 1, 2 and 3 (lnk_4, lnk_5, lnk_6). Only Examples 1 and 2 have a Caveat; Example 3 (lnk_6, "quadruple root") has none. The sentence now covers all of them. lnk_1 to lnk_3 are the title and derivation links, not examples.
- No script or GIF was changed. None was needed, because the fix took the "say it is omitted" option.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.30 | "Cases 1–4 follow Examples 1 and 2 of Mathews' Improved Newton Method module." | Unchanged in substance (sentence split only). Examples 1 and 2 are the double root of x^3−3x+2 and the triple root of x^4−x^3−3x^2+5x−2 (lnk_4, lnk_5), matching Cases 1–4. | Correct |
| l.31 | "Example 3, which compares the methods at a quadruple root" | lnk_6: "compare Methods A,B and C for finding the quadruple root". | Correct |
| l.31 | "the Method B and Method C iterations of all its examples … are not animated here" | Unchanged claim. The page's GIFs show only standard Newton and Method A (Case 5 is standard Newton). | Correct |
| l.31 | "and the caveats in Examples 1 and 2 are not animated here" | lnk_4 and lnk_5 each contain one "Caveat." section; Example 3 has none. No GIF on the page shows either caveat. | Correct |
| l.31 | "Example 1's caveat plots the rounding noise in the expanded f near the double root" | lnk_4 Caveat: plots f, then (x−1)^2(x+2) − f[x] with f = 2 − 3x + x^3 (gr_150, gr_154; result gr_155 is noise of ±6×10⁻¹⁶). It then zooms to [0.99999999, 1.00000001] (gr_158 to gr_160: "The graph is just multiples of 'Machine Epsilon' … The computer will compute f[x] = 0 at many locations."). My Float64 run on that zoom interval: the expanded f takes only the values {−1, −0.5, 0, 0.5, 1, 1.5, 2}·eps and is exactly 0 at 40% of the points. The largest difference from the factored form on [0.5, 1.5] is 6.7×10⁻¹⁶. | Correct |
| l.31 | "Example 2's runs Method A with the wrong multiplicity (m = 2 at the triple root)" | gr_186 is "m = 2" and gr_187 is "m = 3". The root of (x−1)^3(x+2) at x = 1 is triple. | Correct |
| l.31 | "which converges only linearly" | mpmath run: the error ratio tends to 1/3. This agrees with the theory value 1 − m/M and with Mathews' "linear (or slow)". | Correct |
| l.31 | numbers "2", "3" (m = 2, triple) | As above. | Correct |

### New problems
None. This rests on the following:
- Every clause of the new sentence was checked against the archive pages and images (lnk_4, lnk_5, lnk_6, gr_148 to gr_160, gr_167, gr_186, gr_187, gr_189).
- Both mathematical claims were computed independently: the linear rate 1/3 for m = 2 at the triple root, and the eps-level noise of the expanded cubic near x = 1.
- The sentence is in the R3-D position, and no other line of the page changed.
- The sentence is long, with a semicolon-joined explanation, but it is grammatical and accurate. That is a style point, not a defect.

### Reproducibility and conventions
- Scripts and GIFs: none changed. `git status` shows only `index.qmd` modified in the page folder (diff stat: 2 insertions, 1 deletion). No regeneration or byte comparison was needed.
- Conventions: Description comes before Animations. Each of Cases 1–5 still has a `[Julia source]` link and a GIF embed with descriptive alt text. There are no code blocks (0 triple-backtick fences).
- Outside the page folder: this fix's diff touches only `pages/numerical-methods/improved-newton-method/index.qmd`. The working tree also has other numerical-methods pages modified, which are other pages' round-3 work. It also has untracked fix records under `reviews/numerical-methods-animations-r3/fixes/`, including `improved-newton-method.md`. That file is the process record, which I did not read. No file outside the page folder belongs to this page's fix.

**Final status:** committed
