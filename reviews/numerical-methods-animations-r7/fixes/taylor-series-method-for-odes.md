# Fix record: taylor-series-method-for-odes

Scratch folder (all scripts and outputs): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/taylor-series-method-for-odes/fix/`
- `core.py`: independent implementation. Derivatives come from sympy (total derivative in `t` and `c = y^(1/3)`), not from the scripts. The high-precision reference is an order-40 jet recursion for `(y, y^(1/3))` at 50 digits. `dPhi/dy` is symbolic. Mathews' rule: `Together` form, numerator and denominator multiplied by `c`, then `y^(k/3) -> Sign(y)|y|^(k/3)` for exactly the `k` listed in his images (d2: 1,2,4; d3: 1,2,4,5; d4: 1,2,4,5,8). Any other fractional power raises an error.
- `f1.py` → `f1.out`, `f23.py` → `f23.out`, `cause.py` → `cause.out` (superseded by `cause2.py` → `cause2.out`, which uses the exact band onset), `labels.py` → `labels_aa.png`, `labels_bb.png`.
- Run each with `/usr/bin/python3 <script> <scratch folder>`.

## Findings

### F1 — Misleading (fidelity) — fixed
- **Reproduced.** I viewed the archive's `TaylorDEMod_gr_228.gif` (Example 11, order 3) and `TaylorDEMod_gr_267.gif` (Example 12, order 4), at `arch/gr_228.png` and `arch/gr_267.png`.
  - Program: `d_k = Expand[Numerator[Dk] y^(1/3)] / Expand[Denominator[Dk] y^(1/3)]`, then the rules `y^(1/3), y^(2/3), y^(4/3) [, y^(5/3)] [, y^(8/3)] -> Sign[y] Abs[y]^(k/3)`.
  - Exponent check (`f1.out`): after multiplying by `c`, the only fractional powers left are exactly the ones his rules replace: d2 has {1,2,4}; d3 has {1,2,4,5}, with 3 = `y`; d4 has {1,2,4,5,8}, with 3 and 6 integer. The denominators become `3y`, `9y²` and `27y³`.
  - I read all 42 printed `y(5)` labels from the legacy GIFs (`labels_aa.png`, `labels_bb.png`). `f23.py` checks each against the rule run to the printed digits: order 3, rule 21/21 and real cube root 19/21 (misses m = 12, 14); order 4, rule 21/21 and real cube root 14/21 (misses m = 12–28).
  - Cause isolated: restoring the true real power for even k only gives back the real-cube-root run (largest relative difference in y(5) over the 42 runs is 8e-10, which is rounding from the different algebraic forms; `cause2.out`).
  - At t = 4.17, y = −0.03 (`cause2.out`):
    - true y'' = −32.74034, rule +3.94665;
    - true y''' = −1230.62, rule 26.80;
    - true y'''' = −126065.3, rule −1068.3;
    - y' is the same under both.
- **Change.** `index.qmd`:
  - **Case 1, last sentence.** Before: "…; how his program evaluated $y^{1/3}$ for negative $y$ has not been reproduced." After: "… because his program replaces each $y^{k/3}$ by $\operatorname{Sign}(y)\,|y|^{k/3}$, including even $k$. For $y<0$ that flips the sign of $y^{2/3}$ and $y^{4/3}$, so his higher derivatives are no longer those of the ODE. Applying his rule reproduces all 21 of his printed values; this page keeps the true real-cube-root derivatives."
  - **Case 2, last sentence.** Appended: "the same rule, here also applied to $y^{8/3}$, reproduces all 21 of his order-4 values."
- **Check.** `f1.out` and `f23.out` (lines "rule matches 21/21").

### F2 — Misleading (page match) — fixed (text only, per R7-D; band kept as drawn)
- **Reproduced** (`f23.out`), order 3, m = 80:
  - The band onset on the reference is t = 4.9577, and the last step starts at t = 4.93750.
  - The largest h·|f_y| at a step start is 2.4817, below 2.5127.
  - Every |dΦ/dy| < 1, with a maximum of 0.99937. A finite-difference check gives the same value.
  - The last four factors are −0.5084, −0.6180, −0.7410 and −0.8792.
  - Over the integers m = 12..300, the m with an amplifying step are exactly 12..77, a contiguous range. The largest m with a step start past the limit is 78.
  - In the sweep, m = 70 has 3 amplifying steps and m = 80 has 0.
- **Change.** `index.qmd`:
  - **Case 1.** Before: "Just above $h=0.0609$ the shading covers only the last steps ($m=80$: from $t\approx4.96$), and for …". After: "At $m=80$ the shaded region begins at $t\approx4.96$, inside the final step (which starts at $t=4.9375$), so no step is taken from inside it and every step still contracts errors; at least one step amplifies errors for each $m$ from $12$ to $77$. For …".
  - **"along the reference solution".** Inserted into the band sentence, because the band is computed on the reference curve, not at the nodes.
  - **Alt text.** "h·|∂f/∂y| along the reference curve exceeds 2.513 (at m = 80 only part of the final step)".
- **Check.** `f23.out` and `cause2.out`. Frame 17 of the committed `taylorderivativeaa.gif` shows a thin band from t ≈ 4.96, labelled "from t ≈ 4.96", with error −1.9e-09, consistent with the new text.

### F3 — Misleading (page match) — fixed (text only; corrected version from the independent check used)
- **Reproduced**, order 4, m = 70 (`f23.out`, `cause2.out`):
  - The band onset is 4.9082. One step starts inside it, at t = 4.92857, with z = 2.8206 > 2.7853 and R(−z) = 1.0545.
  - The actual factors of the last four steps are 0.5265, 0.6309, 0.7616 and 0.9234. The largest |dΦ/dy| over the run is 0.99918.
  - The integers m with an amplifying step are 12..68, a contiguous range up to m = 300 (`cause.out`).
  - Errors: e(4.8571) = 5.501e-10 and e(5) = 7.158e-10. The exact decomposition is a carried part of 3.868e-10 plus new truncation error of 3.290e-10, from local errors 1.84e-10 and 1.59e-10 of the same sign.
  - **Isolation test.** `cause2.py` caps every exact secant factor at 1 and bounds |e(5)| from the last node before the band.
    - For order 4, m = 12 to 60, the actual |e(5)| exceeds the cap, so amplification is necessary to explain it.
    - At m = 70 the actual error equals the cap (7.158e-10), so no amplification is involved.
- **Change.** `index.qmd`:
  - **Case 2.** Before: "The cause is again stability: … (the shaded region in those frames), and for all of these $m$ the error at $t=5$ is larger than at the last node before the shaded region. Just above $h=0.0675$ the shading covers only the last steps ($m=70$: from $t\approx4.91$), but at $m=12$ it starts at $t\approx3.10$." After: "Stability is again the cause for the coarse runs. For steps … along the reference solution exceeds … (the shaded region in those frames). For $m=12$ to $60$ each run has steps that genuinely amplify error, and the error at $t=5$ is larger than at the last node before the shaded region. At $m=70$ the shaded region, from $t\approx4.91$, contains one step start ($t\approx4.93$), but that step's actual error factor is $0.92$ and no step of the run amplifies error, so the small rise from $5.5\times10^{-10}$ at $t\approx4.86$ to $7.2\times10^{-10}$ at $t=5$ is new truncation error rather than amplification. At $m=12$ the shading starts at $t\approx3.10$."
  - **Alt text.** "along the reference curve" added.
- **Check.** Frame 16 of the committed `taylorderivativebb.gif` shows the band from t ≈ 4.91 and error +7.2e-10.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 1, band sentence | "along the reference solution" | scripts' `onset(h)` loops over `tref, yref` (lines 62-67) | yes |
| Case 1 | shaded region begins t ≈ 4.96 at m = 80 | `f23.py` → onset 4.9577 | yes |
| Case 1 | final step starts t = 4.9375 | 79·5/80 = 4.9375; `f23.out` "last step starts t=4.93750" | yes |
| Case 1 | no step taken from inside the band; every step contracts | `f23.out`: max z at step start 2.4817 < 2.5127; max \|dΦ/dy\| 0.99937 (FD 0.99937) | yes |
| Case 1 | at least one step amplifies for each m from 12 to 77 | `cause.py` (first block, `cause.out`) loop over m = 12..300 → order 3 amplifying m = 12..77, contiguous | yes |
| Case 1 (kept) | m = 52 to 80 error < 3.1e-9; m = 12 onset ≈ 3.07 | `f23.out`: largest 3.091e-9 (m = 56); 3.0663 | yes |
| Case 1, F1 | Sign(y)\|y\|^{k/3}, including even k | archive `gr_228.png`; exponent sets in `f1.out` | yes |
| Case 1, F1 | flips sign of y^{2/3} and y^{4/3} | order-3 even k present: 2, 4 (`f1.out`); Sign(y)\|y\|^{k/3} = −\|y\|^{k/3} vs real power +\|y\|^{k/3} for even k, y < 0 | yes |
| Case 1, F1 | higher derivatives no longer those of the ODE | `cause2.out`: y'' −32.74 vs +3.95; y''' −1230.6 vs 26.8 at t = 4.17, y = −0.03 | yes |
| Case 1, F1 | rule reproduces all 21 printed values | `f23.out` "order 3: rule matches 21/21" | yes |
| Case 1 alt | "along the reference curve … (at m = 80 only part of the final step)" | band [4.9577, 5] ⊂ final step [4.9375, 5] | yes |
| Case 2 | "Stability is again the cause for the coarse runs" | `cause2.out`: order 4, m = 12..60, \|e(5)\| exceeds the no-amplification cap | yes |
| Case 2 | "along the reference solution" | same `onset` code in `taylorderivativebb.jl` | yes |
| Case 2 | for m = 12 to 60 each run has genuinely amplifying steps | `f23.out` amp counts 3,2,2,4,4,5,6,6,6,6,6,5,4,4,3; order-4 amplifying m = 12..68 contiguous | yes |
| Case 2 (kept) | error at t = 5 larger than at last node before band, m = 12..60 | `f23.out`/`cause2.out` all True | yes |
| Case 2 | shaded region from t ≈ 4.91, one step start at t ≈ 4.93 | onset 4.9082; node 69·5/70 = 4.92857 is the only step start ≥ onset | yes |
| Case 2 | that step's factor 0.92; no step amplifies | 0.92336 (secant), 0.9234 (derivative and FD); max 0.99918 | yes |
| Case 2 | rise 5.5e-10 at t ≈ 4.86 → 7.2e-10 at t = 5 is new truncation error | e = 5.501e-10 at t = 4.8571, 7.158e-10 at 5; carried 3.868e-10 + new 3.290e-10 (`cause2.out`) | yes |
| Case 2, F1 | same rule, also y^{8/3}, reproduces all 21 order-4 values | `gr_267.png`; `f23.out` "order 4: rule matches 21/21" | yes |
| Case 2 alt | "along the reference curve" | as above | yes |

## Scripts and GIFs
- No script changed and no GIF regenerated (R7-D: text fixes, band kept as drawn).
- I extracted frames from the committed GIFs (`cur_aa/`, `cur_bb/`) and viewed aa frame 17 (m = 80) and bb frame 16 (m = 70) at full size. Band onsets 4.96 and 4.91, errors −1.9e-09 and +7.2e-10. Both agree with the text.
- `git status -- pages/numerical-methods/taylor-series-method-for-odes` shows only `M index.qmd`.

## Legacy archive
- **Consulted.** `n2003/taylorde` Example 11 and Example 12 program images (`TaylorDEMod_gr_228.gif`, `TaylorDEMod_gr_267.gif`), and `a2001/Animations/OrdinaryDE/Taylor1/Tayloraa.gif` and `Taylor2/Taylorbb.gif`. Each has 21 distinct sweep frames plus the opening frame. Their m sequences match the page's.
- **What it shows.** Mathews' program substitutes Sign[y]|y|^{k/3} for every fractional power, including even k. For y < 0 this does not give the derivatives of the ODE.
- **How the page differs.** The page keeps the mathematically correct real-cube-root derivatives. It now states why his values differ for the runs that go negative, and that his rule reproduces all 42 printed values.

## Notes
- **Checker follow-up (Minor, readability).** In the new Case 1 and Case 2 sentences, "the band" became "the shaded region", the term used in the rest of the text. In Case 2, "the run has steps" became "each run has steps". Wording only: every one of the 15 sweep runs m = 12..60 has at least 2 amplifying steps (`f23.out` counts 3,2,2,4,4,5,6,6,6,6,6,5,4,4,3), so "each" holds. No numbers changed.
- The page has no `## Description` section. No finding names this, so none was added (it is a pre-existing convention gap).
- **Isolation test limits.** At order 3, m = 48, the cap test does not show that amplification is necessary: |e(5)| = 4.66e-7 against a cap of 6.29e-7, although the run has 7 amplifying steps. Case 1's existing sentence for m = 12 to 48 states only the numerical comparison, not a cause for each m, so it was left as is.
- **Same-root siblings.** The other ODE pages (Euler, Runge-Kutta, ABM) compute their bands the same way; whether they show the same "band contains no step start" pattern was not checked here. They were not touched.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: Archive images `TaylorDEMod_gr_228.gif` (order 3) and `TaylorDEMod_gr_267.gif` (order 4) show the rule: multiply num/den by y^(1/3), Expand, then y^(k/3) -> Sign[y] Abs[y]^(k/3) for k = 1, 2, 4, 5 (and 8 at order 4). I implemented it independently (`check/mathews.py`, sympy with c = y^(1/3); the only non-integer exponents appearing are 1, 2, 4, 5, 8). Order 3: m=12 0.1766603, m=14 -3.4636068; order 4: 0.4929678, 0.2026955, -554.4454523, 0.0666066, 0.0711898, -39.0862197, -21.6802983. These match the legacy frames I read (`check/legA`, `check/legB`: -554.44545, -39.08622, -21.680298, ...). For runs that stay positive, the rule is identical to the real cube root, so those values coincide with the page's (spot-checked 18, 20, 28, 32, 40, 52, 70, 100 at order 3 and 32, 44, 56, 80, 120 at order 4 against the frames). The real-cube-root program gives the page's values (-4.4676549, -7665.8734, ...). The two programs differ only in the sign handling, so the "because" is isolated by this computation. The "unreproduced" clause is gone from Case 1, and Case 2 now says the same rule (also applied to y^(8/3)) reproduces all 21 order-4 values.

### F2 — resolved
- Evidence: The text-only option (R7-D) was taken; the script and GIF are unchanged (`git diff --quiet HEAD` on the .jl and .gif files). At order 3, m=80, the band onset along the 50000-step reference is t=4.9578 (≈4.96), and the final step starts at 4.9375. The largest h|f_y| at any step start is 2.4817 < 2.5127. Every step's dΦ/dy satisfies |dΦ/dy| ≤ 0.99937, and the last four are -0.508, -0.618, -0.741, -0.879. I checked every integer m from 12 to 90: each m in 12..77 has ≥1 amplifying step, and m ≥ 78 has none. The "only the last steps" sentence is gone. The alt text now says "along the reference curve" and "(at m = 80 only part of the final step)", which matches frame 17 (thin band at the right edge, "from t ≈ 4.96").

### F3 — resolved
- Evidence: At order 4, all sweep m from 12 to 60 have amplifying steps (counts 3, 2, 2, 4, 4, 5, 6, 6, 6, 6, 6, 5, 4, 4, 3), and |err(5)| > |err(last node before band)| for each. At m=70: onset 4.9083 (≈4.91), one step start at 4.9286 (≈4.93), dΦ/dy there 0.9234 (0.92), max |dΦ/dy| over the run 0.99918, so none amplify. Errors are +5.50e-10 at t=4.857 and +7.16e-10 at t=5. The carried error alone propagates to 3.87e-10, and local truncation adds 3.29e-10, which supports "new truncation error rather than amplification". The causal claim is now restricted to m ≤ 60. The largest m with an amplifying step is 68.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Case 1 | "along the reference solution" | `onset` in script scans tref/yref | true |
| Case 1 | shaded region begins t≈4.96 at m=80 | 4.9578 | true |
| Case 1 | final step starts t=4.9375 | 5 − 5/80 | true |
| Case 1 | no step taken from inside it; every step contracts | max z at node 2.4817 < 2.5127; max \|dΦ/dy\| 0.99937 | true |
| Case 1 | ≥1 amplifying step for each m 12..77 | all integer m checked; m=78..90 have 0 | true |
| Case 1 | m=52..80 \|err y(5)\| < 3.1e-9 | max 3.091e-9 (m=56) | true |
| Case 1 | Sign(y)\|y\|^(k/3) incl. even k; flips y^(2/3), y^(4/3) | archive gr_228; sign algebra | true |
| Case 1 | rule reproduces all 21 printed values | own implementation vs legacy frames | true |
| Case 1 alt | "along the reference curve", "(at m = 80 only part of the final step)" | frame 17; onset 4.958 inside [4.9375, 5] | true |
| Case 2 | band "along the reference solution", 2.785, h≈0.0675, m≤74 | zlim 2.78529; hcrit 0.067513 → m*=74.06 | true |
| Case 2 | "each run has steps" m=12..60 amplify; err(5) > err before band | counts and errors above | true |
| Case 2 | m=70 shaded region from t≈4.91, step start t≈4.93, factor 0.92, none amplify | 4.9083, 4.9286, 0.9234, max 0.9992 | true |
| Case 2 | rise 5.5e-10 at t≈4.86 → 7.2e-10 at t=5 is truncation, not amplification | carried 3.87e-10 + local 3.29e-10 | true, isolated |
| Case 2 | same rule incl. y^(8/3) reproduces all 21 order-4 values | archive gr_267; own implementation | true |
| Case 2 alt | "along the reference curve" | script | true |

### New problems
None. In the first pass I flagged a Minor readability point: "the band" was used as an unannounced synonym for "the shaded region", and Case 2 said "the run has steps". The refreshed diff fixes both. The word "band" no longer appears in index.qmd. The sentences now read "At m=80 the shaded region begins at t≈4.96 ...", "For m=12 to 60 each run has steps that genuinely amplify error ..." and "At m=70 the shaded region, from t≈4.91, contains one step start ...". Every number in these sentences is unchanged and was re-verified against my computation (onsets 4.9578 and 4.9083; step starts 4.9375 and 4.9286; factor 0.9234; amplifying steps for every m in 12..77 at order 3 and every sweep m in 12..60 at order 4; errors 5.50e-10 and 7.16e-10, with 3.87e-10 carried and 3.29e-10 local). The sentences are grammatical and use the same term as the alt text and the rest of the page.

### Reproducibility and conventions
- Only `index.qmd` changed in the page folder, and the .jl and .gif files are byte-identical to HEAD, so no regeneration was needed. Frames 17 (Case 1) and 16 (Case 2) of the committed GIFs agree with the new text.
- The page keeps its structure: a source link and an embed per case, descriptive alt text, and no code blocks. The page has no separate Description section, but that predates this fix and the diff does not touch it. No file outside the page folder changed as part of this fix.

**Final status:** committed
