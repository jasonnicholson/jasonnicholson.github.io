# Fix record: broydens-method

Scratch folder (all scripts re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/broydens-method/fix/`
(`checks.py`, `cost.py`, `work.py`, `qrupd.py`, `framesB/`, `mod.txt`).

## Findings

### F1 — Misleading — fixed
- Reproduced: `/usr/bin/python3 -u -W ignore cost.py` times one iteration on a dense problem with a cheap F and J (F = Ax + x³ − b, J = A + 3 diag(x²)). Newton iteration (F, J, dense solve) against the page's Broyden iteration (F, rank-1 update of B, dense solve) against Broyden with a Sherman–Morrison update of B⁻¹ (F, O(n²) update, mat-vec):

  | n | Newton (s) | Broyden as written (s) | Broyden, SM (s) | as written / Newton | SM / as written |
  |---|---|---|---|---|---|
  | 250 | 0.0040 | 0.0043 | 0.0004 | 1.07 | 0.105 |
  | 500 | 0.0327 | 0.0352 | 0.0018 | 1.08 | 0.050 |
  | 1000 | 0.2304 | 0.2533 | 0.0080 | 1.10 | 0.032 |
  | 2000 | 2.1089 | 2.0467 | 0.0346 | 0.97 | 0.017 |

  When the Jacobian is cheap, an iteration of the algorithm as written costs about the same as a Newton iteration (ratio 0.97–1.10), not "far" less, because the O(n³) dense solve dominates both. The Sherman–Morrison form is 10 to 60 times cheaper and the gap grows with n. This confirms the finding and the independent check's correction (the saving is only the Jacobian evaluation).
- Change: `index.qmd:60`. "In practice, because each iteration is far cheaper than a full Newton step, Broyden's method often reaches a given accuracy in less total work than Newton's method, especially in high dimensions." → "Each iteration after the first avoids the $n^2$ derivative evaluations, so when evaluating the Jacobian dominates the cost, Broyden's method can reach a given accuracy in less total work than Newton's method. As written, step 3 still solves a linear system, which costs $O(n^3)$ for a dense matrix, the same order as the solve in Newton's method; the arithmetic per iteration falls to $O(n^2)$ when $B_k^{-1}$ or a factorization of $B_k$ is updated instead, for example with the Sherman–Morrison formula."
  - This differs from the review's draft in two places. It says "can" instead of "often", because "often" is a frequency claim I cannot compute, while "can" is shown by the page's own runs (below). It drops "only" before "when", because "only" is a universal claim about all solvers (for example sparse or iterative ones), and I could not check it.
- Check:
  - `work.py`: to reach ‖F‖ < 1e-12, Broyden uses 1 Jacobian (6 steps for Case A, 7 for Case B) and Newton uses 4 Jacobians (4 steps for each case). When a Jacobian costs more than the other work, Broyden's total is lower, so "can reach … in less total work" holds.
  - `checks.py` §1: the Sherman–Morrison inverse update `H += (s − Hy)(sᵀH)/(sᵀHy)` gives the same iterates as the page's update for both cases (max coordinate difference 0.0). It uses only mat-vecs and an outer product, so it is O(n²), and its timing scales as such (`cost.py` above).
  - `qrupd.py`: a rank-1 QR update (`scipy.linalg.qr_update`) plus a triangular solve took 0.0048, 0.0125 and 0.0584 s at n = 500, 1000 and 2000. A fresh dense solve took 0.039, 0.416 and 2.66 s, and the two solutions agree to within 3e-12. So updating a factorization also avoids the O(n³) solve.
  - Archive (`mod.txt` l. 204–213): "Matrix inversion requires … calculations. Thus we seek a way to avoid this time consuming step … Sherman and Morrison … This is efficient when n is large." This is consistent with the new text.

### F2 — Minor — fixed
- Reproduced: `checks.py` §2 gives the following values of ‖F(X⁽⁷⁾)‖ for Case B:

  | Computation | ‖F(X⁽⁷⁾)‖ |
  |---|---|
  | Double precision, as the script computes it | 2.9557e-14 |
  | Script's double iterate, F evaluated exactly in rational arithmetic | 2.972e-14 |
  | 60-digit Broyden run | 3.172e-14 |
  | Double precision, F regrouped in a nested form | 2.979e-14 |

  The values agree on about 3e-14 and differ in the second figure, so the finding is reproduced.
- Change: `index.qmd:85`: "to $3.0\times10^{-14}$" → "to about $3\times10^{-14}$". `index.qmd:89` (alt text): "to 3.0e-14" → "to about 3e-14". The GIF is unchanged.
- Check: every value above lies in [2.9e-14, 3.2e-14], so "about 3e-14" holds. The GIF's last frame (`framesB/frame_008.png`, viewed) shows "||F(X_7)|| = 2.96e-14", which is consistent.

### F3 — Minor — fixed
- Reproduced: `checks.py` §3 lists the term magnitudes of F along Case B. The largest term is 6.0 at X⁽⁰⁾ and 6.2526 at X⁽¹⁾, and settles at 6.2244 from X⁽³⁾ on (|4x| = 6.224, x⁴ = 5.863, 2x² = 4.843). §4: for Case A the largest term is 4 at every iterate, so the comment is true in `broydenaa.jl`. 6.25·eps = 1.39e-15, well below the 1e-14 threshold, so the script's behaviour is unaffected.
- Change: `broydenbb.jl:82`: "terms of size up to 4" → "terms of size up to about 6". This is a comment only.
- Check: the maximum term over the run is 6.2526, which "about 6" describes. The regenerated GIF is byte-identical (git status shows no change to `broydenbb.gif`).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:60 | "Each iteration after the first avoids the $n^2$ derivative evaluations" | Algorithm step 0 uses J once and the loop uses only F; the script calls `Jac` only at line 43 (read) | yes |
| index.qmd:60 | "when evaluating the Jacobian dominates the cost, … can reach a given accuracy in less total work than Newton's method" | `work.py` → Broyden 1 Jacobian (6 or 7 steps), Newton 4 Jacobians (4 steps) on both cases | yes |
| index.qmd:60 | "step 3 still solves a linear system, which costs $O(n^3)$ for a dense matrix, the same order as the solve in Newton's method" | `cost.py` → as written / Newton per-iteration time 0.97–1.10 for n = 250 to 2000; both scale about 8× per doubling of n | yes |
| index.qmd:60 | "falls to $O(n^2)$ when $B_k^{-1}$ or a factorization of $B_k$ is updated instead, for example with the Sherman–Morrison formula" | `checks.py` §1 → identical iterates (diff 0.0); `cost.py` → SM 0.0004 to 0.0346 s, about 4× per doubling; `qrupd.py` → QR update 0.0048 to 0.0584 s against a dense solve of 0.039 to 2.66 s | yes |
| index.qmd:85 | "to about $3\times10^{-14}$ at $\mathbf{X}^{(7)}$" | `checks.py` §2 → 2.956e-14, 2.972e-14, 3.172e-14, 2.979e-14 | yes |
| index.qmd:89 | "from 7.3e-1 to about 3e-14 in seven steps" | same; ‖F(X⁽⁰⁾)‖ = 0.7315 (review); 8 frames, k = 0 to 7 (`giftools` → 8 frames) | yes |
| broydenbb.jl:82 | "terms of size up to about 6" | `checks.py` §3 → max 6.2526 | yes |

## Scripts and GIFs
- Script changed: `broydenbb.jl` (comment only). Regenerated with `julia broydenbb.jl`; `broydenbb.gif` came out byte-identical to the committed file.
- Frames: extracted `broydenbb.gif` (8 frames) to `framesB/` and viewed the last frame at full size. The title reads "||F(X_7)|| = 2.96e-14", the left title reads "X_7 = (1.5561, -0.5757)", and the residual plot falls at every step.
- `git status --short -- pages/numerical-methods/broydens-method` after regeneration:
  ```
   M pages/numerical-methods/broydens-method/broydenbb.jl
   M pages/numerical-methods/broydens-method/index.qmd
  ```

## Legacy archive
Consulted: `/home/jason/Desktop/math-fullerton/baseline/mathews/n2003/BroydenMethodMod.html`. The brief's path `broydenmethod/BroydenMethodMod.html` does not exist; that folder holds only `Images/` and `Links/`, and the HTML sits one level up. Under "Improving Broyden's Method", the module says that matrix inversion is time consuming at every iteration and that the Sherman–Morrison formula avoids any inverse or linear solve in the general step, "efficient when n is large". The new F1 text agrees with this. No difference between the archive and the fixed page.

## Notes
- F1 wording departs from the review's draft in two places ("can" for "often", and "only" dropped), as explained under F1. Both changes are there because the dropped words could not be computed.
- `broydenaa.jl` keeps "terms of size up to 4", which is true for Case A (`checks.py` §4).
- No other changes.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: index.qmd:60 no longer says "each iteration is far cheaper" or "especially in high dimensions". The new text limits the saving to the case where Jacobian evaluation dominates ("can reach"). It says step 3's dense solve is O(n^3), the same order as Newton's solve, and that the arithmetic falls to O(n^2) only when B_k^{-1} or a factorization is updated. Each claim was checked:
  - **Avoids the n^2 derivative evaluations after the first iteration.** True. Per the algorithm on lines 46-56 and the script, only F is evaluated after step 0.
  - **O(n^3) dense solve vs. O(n^2) update.** `sm.py` times a dense solve against a Sherman-Morrison inverse update plus a matvec:

    | n | dense solve (s) | update (s) |
    |---|---|---|
    | 500 | 0.061 | 0.0036 |
    | 1000 | 0.430 | 0.0106 |
    | 2000 | 2.23 | 0.027 |

    The solve grows about 8x per doubling and the update about 3x. The updated inverse satisfies H2·B2 = I to 1e-14.
  - **Line 73 is unchanged.** It names Mathews' Sherman-Morrison method as not animated, which is consistent with the new text.

### F2 — resolved
- Evidence: line 85 now reads "to about $3\times10^{-14}$ at $\mathbf{X}^{(7)}$" and the line 89 alt text reads "about 3e-14".
  - My double run gives 2.956e-14 (`chk.py`). A 60-digit mpmath Broyden run gives 3.172e-14. Both are "about 3e-14".
  - The GIF's last frame title still reads "||F(X_7)|| = 2.96e-14", which the finding allows. `resid_title` was not changed.

### F3 — resolved
- Evidence: broydenbb.jl:82 now says "terms of size up to about 6".
  - The largest term along the run is 6.0 at X0, 6.253 at X1 and 6.224 at X2 to X7 (`chk.py`), so "about 6" is accurate.
  - The 1e-14 threshold is still above 6.25·eps ≈ 1.4e-15.
  - Only the comment changed, so the behaviour is unaffected.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:60 | "Each iteration after the first avoids the n^2 derivative evaluations" | Algorithm and script: J used only at step 0 | True |
| index.qmd:60 | "when evaluating the Jacobian dominates the cost ... can reach ... less total work" | Conditional, hedged; consistent with F1's independent check | True |
| index.qmd:60 | "step 3 still solves a linear system, O(n^3) for a dense matrix, the same order as the solve in Newton's method" | Dense LU is about 2/3 n^3 in both methods; timing scales cubically | True |
| index.qmd:60 | "falls to O(n^2) when B_k^{-1} or a factorization of B_k is updated ... Sherman–Morrison" | SM inverse update timed and verified; QR/LU rank-1 updates are also O(n^2) | True |
| index.qmd:85 | "7.3e-1 at X0" | 0.73154 | True (unchanged) |
| index.qmd:85 | "about 3e-14 at X7" | 2.956e-14 (double), 3.172e-14 (60-digit) | True |
| index.qmd:85 | "factor of only about 5 from X3 to X4" (unchanged context) | 5.231e-5 / 1.056e-5 = 4.95 | True |
| index.qmd:85 | "more than 1000 times in each of the last two steps" (unchanged context) | 1.921e-7 / 1.603e-10 = 1198; 1.603e-10 / 2.956e-14 = 5424 | True |
| index.qmd:89 alt | "from 7.3e-1 to about 3e-14 in seven steps" | Same numbers; 7 steps (X0 to X7) | True |
| broydenbb.jl:82 | "terms of size up to about 6" | Max term 6.25 | True |

### New problems
None. This rests on the following checks:
- Every changed sentence was verified above.
- The GIF was not changed by the fix, and a scratch rerun reproduces it byte for byte.
- I looked at the last frame at full size. Its titles "X_7 = (1.5561, -0.5757)" and "||F(X_7)|| = 2.96e-14" are consistent with the new text.
- The residual curve matches the computed residuals for k = 0 to 7.

### Reproducibility and conventions
- **broydenbb.jl:** a scratch copy was run with `julia broydenbb.jl`. The output GIF is byte-identical (cmp) to the committed broydenbb.gif.
- **broydenaa.jl / broydenaa.gif:** not touched by the fix.
- **Conventions:** the page still has Description before Animations, a "[Julia source]" link and a GIF embed per case, descriptive alt text, and no code blocks.
- **Scope:** `git diff --stat HEAD` for the page folder shows only broydenbb.jl (one line) and index.qmd (three lines). The only changes outside numerical-methods page folders are untracked review files under `reviews/numerical-methods-animations-r7/`, which belong to the review workflow and not to this page. No tracked file outside the page folder was changed by this fix.

**Final status:** committed
