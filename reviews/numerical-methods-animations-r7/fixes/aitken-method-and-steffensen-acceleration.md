# Fix record: aitken-method-and-steffensen-acceleration

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/aitken-method-and-steffensen-acceleration/fix/` (`checks.jl`, `f1.jl`, `exact.py`). Run as `julia checks.jl`, `julia f1.jl`, `/usr/bin/python3 -I exact.py` from that folder.

## Findings

### F1 — Misleading — fixed
- Reproduced: `julia f1.jl` runs the script's Steffensen iteration on both forms in Float64.
  - Expanded form: at S_3 = 0.99999999344396751, `f(S_3) = 0` (exact value 1.289e-16), `q1 == S_3`, `q2 == q1`, denominator 0, so the run stops after 3 steps.
  - Factored form `(x-1)^2(x+2)`: S_3 = 0.9999999934432543 with `f(S_3) = 1.290e-16`, denominator −1.639e-9, and S_4 == 1.0 exactly.
  - `julia checks.jl`: Newton on the expanded form gets `f == 0` at k = 28 with error 1.5211e-09. Factored-form Steffensen errors are 1, 5.7471e-2, 2.8049e-4, 6.5567e-9, 0.
  - So 6.6e-9 is a limit of this evaluation, not of double precision. Finding confirmed.
- Change: `index.qmd` Case 1 Behavior, last sentence. Before: "It cannot go further in double precision: at $S_3$ the expanded polynomial … evaluates to exactly 0, so the $\Delta^2$ denominator is 0 and the animation stops the Steffensen sequence there." After (the review's suggested text): "The sequence cannot continue from $S_3$: there the expanded polynomial $x^3 - 3x + 2$ rounds to exactly 0, so the $\Delta^2$ denominator is 0 and the animation stops. This is a limit of evaluating the expanded form, not of double precision: the factored form $(x-1)^2(x+2)$ takes a fourth step to the root."
- Check: the outputs above. The alt text ("stopping after 3 steps at error 6.6×10⁻⁹") and the GIF legend ("stopped: Δ² denominator = 0") stay consistent, and neither claims a precision limit.

### F2 — Minor — fixed
- Reproduced: `exact.py` (mpmath, 600 digits), Newton, 60 steps. In all three cases e60/e59 = 0.5 and the log-order estimate is 1.0. Order 1, ratio 1/2, confirmed.
  - Steffensen's e_{k+1}/e_k² converges to 0.0833333, 0.176777 and 0.57735, so its order is 2. "Superlinear (≈2)" is therefore not wrong and was left alone (R7-D, smallest change).
- Change: `index.qmd` Summary table, Newton/double row. Before: "Linear ($\tfrac{1}{2}$)". After: "Linear (order 1, ratio $\tfrac{1}{2}$)".
- Check: same `exact.py` output.

### F3 — Minor — fixed
- Reproduced: `julia checks.jl` (Float64, the scripts' iteration and guards) gives the factor (better Newton substep error) / (Steffensen error) for each step:
  - Case 1: 5.184, 50.48, 1.07e4.
  - Case 2: 1.359, 30.18, 4586, 6.30e6. The review's 7.4e6 for step 4 measures from the exact √2. Here the error is from fl(√2), 6.66e-16, against 5.7e-16 from the exact √2. This was not used in the text.
  - Case 3: 1.281, 21.45, 1980, **0.2113, 0.2969**, 1 (f(q1) = 0 at step 6).

  `exact.py` in exact arithmetic gives step-1 factors of 5.18, 1.36 and 1.28, then 21 to 50 at step 2, and growing without bound after that (up to 1e61 to 1e73 by step 7). So the claim fails at the first step (not close to the root) and at Case 3 steps 4–6 (rounding dominant). It holds otherwise. Confirmed.
- Change: `index.qmd` line 52. Before: "…but produces a correction that is far more accurate than either step alone." After: "…but, once the iterates are close to the root and rounding in $f$ does not dominate, produces a correction far more accurate than either step alone."
- Check: every step outside those two conditions has a factor of at least 21 (Float64 and exact), and the two exceptions are exactly the ones the new qualifiers exclude.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Description, Steffensen paragraph | "once the iterates are close to the root and rounding in $f$ does not dominate, produces a correction far more accurate than either step alone" | `julia checks.jl` → factors at step ≥2 before rounding: 50.48, 1.07e4; 30.18, 4586, 6.3e6; 21.45, 1980. Step 1: 1.28–5.18. Case 3 steps 4–5 (f(q1) ≈ 1e-14, rounding): 0.21, 0.30. `exact.py` → exact factors grow to ≥1e61 | yes |
| Summary table | "Linear (order 1, ratio ½)" | `exact.py` → e60/e59 = 0.5, log-order 1.0 (all three cases) | yes |
| Case 1 Behavior | "$x^3-3x+2$ rounds to exactly 0" at $S_3$ | `julia f1.jl` → f(S_3) = 0.000e+00 in Float64, exact 1.289e-16 | yes |
| Case 1 Behavior | "the $\Delta^2$ denominator is 0 and the animation stops" | `f1.jl` → q1==S, q2==q1, den = 0; script stops with n_done = 3 | yes |
| Case 1 Behavior | "a limit of evaluating the expanded form, not of double precision" | `f1.jl`/`checks.jl` → factored form in Float64 continues; expanded-form Newton reaches 1.52e-9 < 6.56e-9 | yes |
| Case 1 Behavior | "the factored form $(x-1)^2(x+2)$ takes a fourth step to the root" | `f1.jl` → factored S_4 == 1.0 (exact). `checks.jl` errors 1, 5.75e-2, 2.80e-4, 6.56e-9, 0 | yes |

## Scripts and GIFs
- No script changed and no GIF regenerated. All three findings concern text only (R7-D/D7). The review found the committed GIFs byte-identical to fresh regenerations.
- `git status --short pages/numerical-methods/aitken-method-and-steffensen-acceleration` → ` M index.qmd` only.

## Legacy archive
Consulted: `n2003/AitkenSteffensenMod.html` and `n2003/aitkensteffensen/AitkenSteffensenMod/Links/*_lnk_2..7.html`, as text. They hold the Examples 1–6 statements: Newton linear at the multiple root, then Aitken (odd examples) or Steffensen (even examples), "compare the number of iterations". The formulas and values are images that are missing locally. The archive says nothing about the sentences changed here (precision limit, order/ratio wording, per-step accuracy), so it neither supports nor contradicts the fixes.

## Notes
- The review's Case 2 step-4 factor (7.4e6) and mine (6.3e6) differ only in the reference value (exact √2 against fl(√2)). Neither number is on the page.
- Steffensen's table entry "Superlinear (≈2)" was kept. The order is exactly 2, so "≈2" is true, and changing it was optional under the finding.

## Resolution check (independent checker, not shown this record)

The fix changes text only: three lines of `index.qmd`. No script or GIF changed (fix.diff and `git status` of the page folder both show `index.qmd` as the only modified file).

### Original findings

### F1 — resolved
- Evidence: The claim "It cannot go further in double precision" is gone. The replacement says the stop comes from evaluating the expanded form, and that the factored form takes a fourth step to the root. My Julia checks are in `check/c1.jl` and `check/c2.jl`, which mirror `aitkenab.jl` and use the same 1e-15 guard.
  - Expanded `x^3-3x+2`: the Steffensen errors are 1, 5.747e-2, 2.805e-4, 6.556e-9. `f(S_3) = 0.0` exactly, so `q1 = q2 = S_3` and the denominator is 0, and the run stops. The page's wording "rounds to exactly 0 ... Δ² denominator is 0 ... the animation stops" is true.
  - Factored `(x-1)^2(x+2)`: the run takes a fourth step. With `f' = 3(x-1)(x+1)` the error is exactly 0. With the script's expanded `f' = 3x^2-3` it is 3.33e-16, which is 3 ulp below 1. So "to the root" holds to machine precision either way.
  - Plain Newton on the expanded form gets `f = 0` at k = 28, err 1.521e-9, which agrees with line 20. Its error after 22 steps is 3.115e-7, which agrees with the "3.1e-7" on the page.
  - The GIF label "stopped: Δ² denominator = 0" and the alt text ("stopping after 3 steps at error 6.6×10⁻⁹") are unchanged and still consistent.

### F2 — resolved
- Evidence: The row now reads "Linear (order 1, ratio ½)". Newton on the factored form from x0 = 2 gives tail ratios e[k+1]/e[k] of 0.500000, 0.500000, 0.500000, 0.499999, 0.500000 and 0.499997 (k = 30 to 35), so the order is 1 and the ratio is 1/2. The Steffensen row "Superlinear (≈2)" was not changed. It is not false: the order is 2, which is superlinear. The finding marked that change as optional.

### F3 — resolved
- Evidence: The new text adds the qualifier "once the iterates are close to the root and rounding in f does not dominate". I recomputed the outer-step factor (better Newton-substep error divided by Steffensen error):
  - Case 1: 5.18, 50.5, 1.07e4
  - Case 2: 1.36, 30.2, 4.59e3, 6.3e6
  - Case 3: 1.28, 21.4, 1.98e3, 0.211, 0.297, 1
  The places where the factor is small or below 1 fall outside the stated conditions. Step 1 starts far from the root, and Case 3 steps 4 to 6 are where rounding dominates, which the Case 3 text itself describes. Every step that meets the conditions has a factor between 21 and 6e6, so the statement is now true.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| l.52 | "once the iterates are close to the root and rounding in f does not dominate, produces a correction far more accurate than either step alone" | factor table above (c1.jl) | true |
| l.59 | "Linear (order 1, ratio ½)" | Newton tail ratios = 0.5000 | true |
| l.73 | "The sequence cannot continue from S_3" | the script stops after 3 steps; xS has 4 entries | true |
| l.73 | "the expanded polynomial x^3 − 3x + 2 rounds to exactly 0" (at S_3) | f(0.99999999344396751) = 0.0 in Float64 | true |
| l.73 | "so the Δ² denominator is 0 and the animation stops" | q1 = q2 = p, so denom = 0 and the 1e-15 guard fires | true |
| l.73 | "a limit of evaluating the expanded form, not of double precision" | factored Steffensen goes on to 0 or 3.3e-16; expanded Newton reaches 1.5e-9 | true |
| l.73 | "the factored form (x−1)^2(x+2) takes a fourth step to the root" | step-4 error 0 (factored f') or 3.33e-16 (expanded f') | true |

### New problems
None. This rests on recomputing every changed claim above in Float64 Julia, using the script's own iteration and guard. The unchanged numbers in the same sentence (1, 5.7e-2, 2.8e-4, 6.6e-9 and Newton's 3.1e-7) also reproduce.

### Reproducibility and conventions
- No script or GIF changed, so there was no regeneration to compare and no new frames to inspect.
- Conventions still hold: Description comes before Animations; each of the three cases has a `[Julia source]` link and a GIF embed with descriptive alt text; there are no code fences (count of ``` is 0).
- No tracked file outside page folders is modified. The only items outside page folders are untracked review files under `reviews/numerical-methods-animations-r7/`, which belong to the review process. The other changed `index.qmd` that mentions "Aitken" belongs to a different page (aitkens-and-nevilles-interpolation).
- The fix follows the finding's suggested corrections and does not conflict with the README decisions. The R4-C √2 reference wording for Case 2 is untouched and still present.

**Final status:** committed
