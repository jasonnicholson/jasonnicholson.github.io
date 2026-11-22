# Fix record: graeffes-method

Scratch folder (all checks re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/graeffes-method/fix/`

## Findings

### F1 — Minor — fixed

- **Reproduced:**
  - Independent check `/usr/bin/python3 -I eqmag.py`. It builds the coefficients of p_m exactly, as the elementary symmetric functions of r^(2^m) (sympy), and forms the estimates |c_{n−k}/c_{n−k+1}|^(1/2^m) in 60-digit mpmath. It covers three root sets: Case 2 {5, 5, −2, 1}, Mathews Ex. 9 {5, −5, 2, −1}, and the complex pair {3±4i, 2, 1}.
  - **Case 2:** the top-estimate errors are e₁ = +4.00, +2.42, +0.966, +0.453, +0.221, +0.110, +0.0545, +0.0272, +0.0136, +0.00677, +0.00339 for m = 0…10. The ratio |e₁(m)|/|e₁(m−1)| is 0.469–0.500 from m = 3 on, and e₂ has the opposite sign. This matches the script's table.
  - **±5 pair (Ex. 9):** the m = 0 estimates differ (1.0, 27.0, 0.926, 2.0). From m = 1 to m = 10 they are identical to Case 2 at every printed digit (7.416198/3.997727, 5.966150/4.246210, …, 5.003386/4.996617). The reason is (±5)² = 25, so p₁ is the same polynomial.
  - **3±4i pair:** the top two estimates for m = 2…10 are (5.674723, 4.354135), (4.895551, 5.107032), (5.079660, 4.921589), (4.834991, 5.170640), (5.049699, 4.950791), (5.017064, 4.982994), (4.981748, 5.018319), (5.005991, 4.994016), (5.001673, 4.998327).
    - The sign of e₁ for m = 2…10 runs + − + − + + − + +.
    - |e₁| runs 0.675, 0.104, 0.0797, 0.165, 0.0497, 0.0171, 0.0183, 0.00599, 0.00167. Successive ratios are 0.337, 0.155, 0.763, 2.071, 0.301, 0.343, 1.070, 0.328, 0.279.
    - |e₂| also grows from m = 4 (0.0784) to m = 5 (0.1706) and from m = 7 (0.0170) to m = 8 (0.0183).
    - The finding holds: the halving pattern belongs to real equal-magnitude roots, not to a complex-conjugate pair.
  - **Cross-check with the page's own recurrence:** `julia complex_instr.jl` is a copy of `graeffesab.jl` with c0 = [1, −9, 45, −87, 50] = (x²−6x+25)(x−2)(x−1) and the animation removed. Its output agrees with the Python values to 6 decimals at every m. The coefficients were checked with numpy: `np.poly([3+4j,3-4j,2,1])` → [1, −9, 45, −87, 50], and |3+4i| = 5.
- **Change:** `index.qmd` line 62, last sentence of Case 2 Behavior.
  - Before: "…the diagnostic signature of two roots of equal magnitude (here a repeated root)."
  - After: "…the signature of two real roots of equal magnitude: here a repeated root, and a real pair ±r behaves the same way because one squaring turns it into a double root. A complex-conjugate pair also has two roots of equal magnitude but does not give this pattern: for roots 3 ± 4i, 2 and 1 (magnitudes 5, 5, 2, 1, as here), the top two estimates cross back and forth over 5 and their error does not halve each step; it grows from m = 4 to m = 5 and from m = 7 to m = 8."
- **Check:** every claim in the new text is in the ledger below. No script or GIF changed.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd L62 | "signature of two real roots of equal magnitude: here a repeated root" | `eqmag.py` Case 2: error ratio 0.469–0.500 for m ≥ 3, simple roots quadratic. This is unchanged from the reviewed claim C2-3/C2-5. | yes |
| index.qmd L62 | "a real pair ±r behaves the same way because one squaring turns it into a double root" | (±r)² = r², so p₁ has the double root r². `eqmag.py` Ex. 9 {5, −5, 2, −1}: estimates from m = 1…10 are identical to Case 2's. | yes |
| index.qmd L62 | "A complex-conjugate pair also has two roots of equal magnitude" | \|3+4i\| = \|3−4i\| = 5 (numpy). | yes |
| index.qmd L62 | "roots 3 ± 4i, 2 and 1 (magnitudes 5, 5, 2, 1, as here)" | `np.poly` → [1, −9, 45, −87, 50]; the magnitudes match Case 2's {5, 5, 2, 1}. | yes |
| index.qmd L62 | "the top two estimates cross back and forth over 5" | `eqmag.py` 3±4i: the sign of e₁ for m = 2…10 is + − + − + + − + +, and e₂ has the opposite sign each time. | yes |
| index.qmd L62 | "their error does not halve each step" | Ratios \|e₁(m)\|/\|e₁(m−1)\| = 0.337, 0.155, 0.763, 2.071, 0.301, 0.343, 1.070, 0.328, 0.279 (m = 2…10). | yes |
| index.qmd L62 | "it grows from m = 4 to m = 5 and from m = 7 to m = 8" | \|e₁\|: 0.0797 → 0.165 and 0.01706 → 0.01825. \|e₂\|: 0.0784 → 0.1706 and 0.01701 → 0.01832. `complex_instr.jl` gives the same values (5.07966/4.921589 → 4.834991/5.17064; 5.017064/4.982994 → 4.981748/5.018319). These are the only increases of \|e₁\| for m = 2…10. | yes |

## Scripts and GIFs

- No script changed and no GIF regenerated. The finding is text-only and the animation is correct; the reviewer confirmed byte-identical regeneration.
- `git status --short -- pages/numerical-methods/graeffes-method` after the fix: ` M pages/numerical-methods/graeffes-method/index.qmd` only.

## Legacy archive

- Consulted `n2003/graeffemethod/GraeffeMethodMod/Links/` (the HTML is under `Links/`, not at the path named in the brief).
- Example 9, "Unequal Real Roots of Equal Magnitude", is (x−5)(x+5)(x−2)(x+1). Mathews diagnoses it by the failure of the sign test ("we suspect that there are two roots with the same magnitude"). His caveat says he did not attempt complex roots ("leave these further investigations to the reader"). The archive therefore makes no claim about the complex-pair pattern. The new sentence on it rests only on the computation above.
- Examples 7 and 8 (the lnk_7 and lnk_8 pages) state "linearly for the repeated root and quadratically for the simple roots". This agrees with Case 2. Nothing on the page departs from the archive.

## Notes

- I added no new example or animation. The ±r and complex-pair statements are one sentence each in Case 2's Behavior, as the finding suggested. Example 9 is not animated, which the reviewer noted is not a finding.
- The brief's archive path `graeffemethod/GraeffeMethodMod.html` does not exist. The pages are `graeffemethod/GraeffeMethodMod/Links/GraeffeMethodMod_lnk_*.html`.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: The overclaim "diagnostic signature of two roots of equal magnitude" has been removed. The new text says the pattern is the signature of two *real* roots of equal magnitude: a repeated root, or a real pair ±r, which becomes a double root after one squaring. It also says a complex-conjugate pair does not give the pattern. I checked this with exact-integer Graeffe squaring in `check/cp.py`, evaluating the estimates with mpmath at 60 digits for m = 0..10:
  - Case 2 (5, 5, −2, 1): the top-two error ratio per step is 0.604, 0.400, 0.469, 0.489, 0.495, 0.497, 0.4986, 0.4993, 0.4997, 0.4998, which tends to 1/2. So the halving claim is right.
  - Real pair (5, −5, 2, −1): from m = 1 on, the estimates are identical to Case 2's to every printed digit. p_1 has the same roots {25, 25, 4, 1}, so the "one squaring turns it into a double root" reason is right.
  - Complex pair (3±4i, 2, 1, coefficients [1, −9, 45, −87, 50]): the magnitudes are {5, 5, 2, 1}. The error of the top-two estimates changes sign irregularly, with signs from m = 2 of +, −, +, −, +, +, −, +, +. Max |error| runs 0.675, 0.107, 0.0797, 0.171, 0.0497, 0.0171, 0.0183, 0.00599, 0.00167, so the ratios are 0.16, 0.74, 2.14, 0.29, 0.34, 1.07, 0.33, 0.28. It does not halve.
  - Script and GIF: no change was needed, and none was made.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 2 Behavior | "signature of two real roots of equal magnitude: here a repeated root" | Case 2 error ratio tends to 0.5 (above) | True |
| same | "a real pair ±r behaves the same way because one squaring turns it into a double root" | (5, −5, 2, −1) matches Case 2 exactly from m = 1, and p_1 has roots {25, 25, 4, 1} | True |
| same | "A complex-conjugate pair also has two roots of equal magnitude but does not give this pattern" | 3±4i: ratios are irregular (above) | True |
| same | "roots 3±4i, 2 and 1 (magnitudes 5, 5, 2, 1, as here)" | \|3±4i\| = 5 | True |
| same | "the top two estimates cross back and forth over 5" | Estimates: (4.896, 5.107) at m = 3, (5.080, 4.922) at m = 4, (4.835, 5.171) at m = 5, (5.050, 4.951) at m = 6, …, (4.982, 5.018) at m = 8, (5.006, 4.994) at m = 9 | True |
| same | "their error does not halve each step" | Ratios 0.16, 0.74, 2.14, 0.29, 0.34, 1.07, … | True |
| same | "it grows from m = 4 to m = 5" | 0.0797 → 0.171; per estimate, 0.0797 → 0.165 and 0.0784 → 0.171 | True |
| same | "and from m = 7 to m = 8" | 0.01706 → 0.01832; per estimate, 0.01706 → 0.01825 and 0.01701 → 0.01832 | True |

### New problems
None. This rests on three things:
- Every claim in the changed sentence was recomputed exactly (above).
- The diff touches only this one paragraph, and no script or GIF changed.
- The rest of the page is unchanged from the previously reviewed state.

One observation, not a defect: on m = 0..10 the max-error measure grows only at m = 4→5 and m = 7→8, so the two listed instances are complete. Per estimate, the second estimate also "grows" from m = 0 to m = 1, but only because it is 45/9 = 5 exactly at m = 0, which is a coincidence.

### Reproducibility and conventions
- Changed scripts and GIFs: none. `git status` and `git diff --stat HEAD` for the page folder show only `index.qmd` (1 line). There was nothing to regenerate, and the committed GIFs are untouched.
- Conventions kept: Description comes before Animations. Each case has a Julia source link and a GIF embed with descriptive alt text. There are no code blocks (no ``` in index.qmd).
- Outside the page folder: the fix diff covers only this folder. Other modified files in the working tree belong to other pages' fixes or are untracked review folders. None of them is attributable to this fix.

**Final status:** committed
