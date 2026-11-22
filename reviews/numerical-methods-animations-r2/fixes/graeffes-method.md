# Fix record: graeffes-method

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r2fix/graeffes-method/fix/` (`check.py`, output in `check.out`, rendered page `render.html`). Re-run with `/usr/bin/python3 -I check.py`.

## Findings

### F1 — Misleading — fixed
- Reproduced: `check.py` (sympy). Every real root of both cases is identified by the sign test: Case 1 p(+1)=24, p(−1)=0; p(+2)=0, p(−2)=−24; p(+3)=−24, p(−3)=0; p(+4)=0, p(−4)=144. Case 2 p(+1)=0, p(−1)=−72; p(+2)=36, p(−2)=0; p(+5)=0, p(−5)=1800. For a complex pair the test fails: p = (x²+1)(x−2)(x+3) = x⁴+x³−5x²+x−6 has roots ±i, 2, −3; at |±i| = 1, p(+1) = −8 and p(−1) = −12, neither zero, and a real evaluation carries no information about arg r. So the sentence is right for real roots and wrong for complex ones.
- Change: `index.qmd` line 36. "The sign (or complex argument) of each root is determined by evaluating $p$ at the candidate magnitude." → "For real roots, the sign of each root is chosen by checking which of $p(+|r_k|)$ and $p(-|r_k|)$ is (nearly) zero. Complex roots need the modified formulas mentioned below." ("(nearly)" added to the reviewer's wording because |r_k| is only an estimate; "modified formulas" matches the wording of line 44, which the sentence points to.)
- Check: sign-test values above; line 44 still lists "complex conjugate root pairs" among the cases needing modified formulas. Math renders (`quarto pandoc index.qmd -t html --mathjax`, inline math `\(p(+|r_k|)\)` parsed).

### F2 — Minor — fixed
- Reproduced: `check.py` builds p_m independently ((−1)^n p(s)p(−s), s² → x, exact integers). log10 of the largest coefficient, m = 0…8, Case 1: 1.38, 2.91, 5.55, 11.04, 22.08, 44.17, 88.33, 176.67, 353.33 (successive ratios 2.109, 1.907, 1.989, then 2.000), so the growth is doubly exponential. The largest coefficient of Case 1 p₈ is 2.1581e353 = 24^256, while |r₁|^256 = 4^256 = 1.3408e154 (inside Float64). Case 2 p₈ largest = 8.6362e434 = 50^256. Line 42's "$|r_k|^{2^m}$" is therefore wrong, and "exponentially" understates it.
- Change: `index.qmd` line 42: "grow exponentially as $|r_k|^{2^m}$," → "grow doubly exponentially in $m$ (for separated roots, $|c_{n-k}/c_n| \approx (|r_1| \cdots |r_k|)^{2^m}$),". Line 54: "$\to \infty$ exponentially" → "$\to \infty$ doubly exponentially".
- Check: in `check.out`, log10|c_{n−k}/c_n| − 2^m·log10(|r₁|⋯|r_k|) for Case 1 is 0.0043, 0.0007, 0.0, 0.0 at m = 4 and 0.0 to 4 decimals for all k at m ≥ 5. The qualifier "for separated roots" is needed: in Case 2 (double root at 5) the k = 1 term stays off by 0.301 = log10 2 for m ≥ 4 (c_{n−1}/c_n ≈ 2·5^{2^m}), while k = 2, 3, 4 match. Line 54: (4/3)^{2^m}, (3/2)^{2^m}, 2^{2^m} at m = 8 are 9.645e31, 1.201e45, 1.158e77. These are doubly exponential by form.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| l.36 | "For real roots, the sign … is chosen by checking which of p(+\|r_k\|) and p(−\|r_k\|) is (nearly) zero" | `check.py` F1 block → for each real root exactly one of p(±\|r\|) is 0 in both cases (values listed under F1) | yes |
| l.36 | "Complex roots need the modified formulas mentioned below" | `check.py` → (x²+1)(x−2)(x+3): p(±1) = −8, −12, neither 0. Line 44 lists complex pairs under "modified formulas". Archive lnk_10: Mathews does not treat complex roots | yes |
| l.42 | "grow doubly exponentially in m" | `check.py` → log10 max\|c\| doubles per step (ratios → 2.000 from m = 3, both cases) | yes |
| l.42 | "for separated roots, \|c_{n−k}/c_n\| ≈ (\|r_1\|⋯\|r_k\|)^{2^m}" | `check.py` → log deviation 0.0 (4 d.p.) for m ≥ 5 in Case 1. Case 2 k = 1 is off by log10 2 (not separated), hence the qualifier. Case 1 p₈: 24^256 = 2.1581e353 = actual max | yes |
| l.54 | "doubly exponentially" | (r_k/r_{k+1})^{2^m} is doubly exponential in m by form. Numbers at m = 8: 9.645e31, 1.201e45, 1.158e77 | yes |

No other text, numbers, alt text or GIF titles were changed.

## Scripts and GIFs
- No scripts were changed and no GIFs were regenerated. Both findings are text-only, and the round-2 review found both GIFs byte-identical on regeneration.
- `git status --short -- pages/numerical-methods/graeffes-method` → ` M index.qmd` only.

## Legacy archive
Consulted: `n2003/graeffemethod/GraeffeMethodMod/Links/*.html`, read as stripped text.
- Each example says "calculate … to see which sign to use", testing ±magnitude for real roots only.
- lnk_10 notes a case where "neither sign choice computes to be close to zero" and says "We have not attempted a solution for complex roots". This is consistent with the F1 fix.
- lnk_7 and lnk_8 say "the size of the coefficients grows exponentially". The page now says "doubly exponentially", following the computation (the exponent doubles each squaring) rather than Mathews' looser word.

## Notes
- The "(nearly)" in the F1 sentence departs slightly from the reviewer's suggested wording, because the magnitudes are approximations.
- Nothing outside the page folder and this record was touched.

## Resolution check (independent checker, not shown this record)

The fix only changes text: three lines of `index.qmd` (36, 42, 54). No script or GIF changed. The script is unchanged and builds every coefficient in exact BigInt arithmetic.

Independent check: `check/chk.py` (sympy exact arithmetic plus mpmath). It applies the page's transformation p_{m+1}(x) = (-1)^n p_m(√x) p_m(−√x) for m = 0…8 to both cases. For each m it prints log10|c_{n-k}/c_n|, the prediction 2^m·log10(|r_1|⋯|r_k|), the Separated-Root estimates, and p(±|r|) for every true magnitude.

### Original findings

### F1 — resolved
- The old sentence on line 36, "The sign (or complex argument) ... evaluating p at the candidate magnitude", is gone.
- The new line 36 reads "For real roots, the sign of each root is chosen by checking which of p(+|r_k|) and p(−|r_k|) is (nearly) zero. Complex roots need the modified formulas mentioned below."
- This is true. For every real root, exactly one of p(±|r|) is zero:
  - Case 1: p(1)=24, p(−1)=0; p(2)=0, p(−2)=−24; p(3)=−24, p(−3)=0; p(4)=0, p(−4)=144. This picks −1, 2, −3, 4, the true roots.
  - Case 2: p(1)=0; p(2)=36, p(−2)=0; p(5)=0, p(−5)=1800. This picks 1, −2, 5, the true roots.
- The sentence makes no claim about complex arguments any more.
- "Mentioned below" points to line 44 ("complex conjugate root pairs ... require modified formulas"). That reference is present and consistent.
- The new sentence matches Mathews' Example 4 procedure (testing f at +m and −m).

### F2 — resolved
- Line 42 now says the coefficients "grow doubly exponentially in m (for separated roots, |c_{n-k}/c_n| ≈ (|r_1|⋯|r_k|)^{2^m})".
- Case 1, exact log10|c_{n-k}/c_n| against the prediction 2^m·log10(∏_{i≤k}|r_i|):

  | m | k=1 actual / predicted | k=2 actual / predicted | k=4 actual / predicted |
  |---|---|---|---|
  | 4 | 9.637 / 9.633 | 17.268 / 17.267 | 22.083 / 22.083 |
  | 8 | 154.127 / 154.127 | 276.270 / 276.270 | 353.334 / 353.334 |

- The k=3 and k=4 values agree with the prediction from m = 2 on.
- The exponent doubles each step: max log10 is 1.38, 2.91, 5.55, 11.04, 22.08, 44.17, 88.33, 176.67, 353.33. That is doubly exponential growth.
- c_n = 1 at every m, so the normalisation by c_n is harmless.
- In Case 2, the k=1 coefficient is 2·5^{2^m}, which is off by log10 2 = 0.301. That case does not have separated roots, and the sentence's qualifier "for separated roots" covers it.
- Line 50 stays consistent with the new line 42:
  - Case 1: (4·3·2)^256 = 10^353.33 ≈ 2.2e353.
  - Case 2: (5·5·2·1)^256 = 10^434.94 ≈ 8.6e434.
- Line 54 now says "doubly exponentially". With |r_k| > |r_{k+1}|, log|r_k/r_{k+1}|^{2^m} = 2^m·log|r_k/r_{k+1}|, which is doubly exponential in m. This is correct.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.36 | "For real roots, the sign ... which of p(+\|r_k\|) and p(−\|r_k\|) is (nearly) zero" | p(±\|r\|) evaluated for all roots of both cases; exactly one is zero each time and it gives the true root | True |
| l.36 | "Complex roots need the modified formulas mentioned below" | l.44 lists complex conjugate pairs under "modified formulas" | True, consistent |
| l.42 | "grow doubly exponentially in m" | max log10 coefficient doubles each m (1.38 → 353.33) | True |
| l.42 | "for separated roots, \|c_{n-k}/c_n\| ≈ (\|r_1\|⋯\|r_k\|)^{2^m}" | Case 1 exact log10 ratios match 2^m·log10 ∏ (table above); Vieta with dominant term | True |
| l.54 | "\|r_k/r_{k+1}\|^{2^m} → ∞ doubly exponentially" | the log of it equals 2^m·log(ratio), ratio > 1 | True |

### New problems
None.

This rests on two things:
- All three changed sentences were checked against exact Graeffe iterates and direct evaluation of p.
- No script or GIF changed, so no picture can have broken.

The unchanged surrounding text also still holds:
- "error roughly squares": the Case 1 |r_1| errors are 2.5e-3, 1.26e-5 and 6.3e-10 at m = 4, 5, 6, so err_{m+1}/err_m² ≈ 2.
- Line 50's overflow figures agree with the new line 42.

### Reproducibility and conventions
- **Scripts and GIFs:** no script or GIF in the page folder changed, so there was nothing to regenerate. `git diff HEAD` shows only `index.qmd` in this folder.
- **Page conventions:** all still kept.
  - Description comes before Animations.
  - Each case has a `[Julia source]` link and a GIF embed.
  - The alt text is descriptive and unchanged.
  - There are no code blocks (0 occurrences of ```).
- **Files outside the page folder:**
  - `git diff HEAD` also lists `pages/numerical-methods/bisection-method/bisectionaa.{gif,jl}` and `bisectionbb.{gif,jl}`. These are outside this page and most likely belong to a parallel Bisection fix. They are not part of this page's diff (fix.diff covers only the Graeffe folder), and I did not judge them.
  - The untracked files `reviews/numerical-methods-animations-r2/fix-plan/worklist.md` and `reviews/numerical-methods-animations-r2/fixes/graeffes-method.md` are fix records, not page content.

**Final status:** committed
