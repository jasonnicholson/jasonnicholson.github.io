# Fix record: riemann-sums

Scratch folder (all evidence, re-runnable):
`/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/riemann-sums/fix/`
(below written as `$FIX`). Scripts are in `$FIX/scripts/`, outputs in `$FIX/*.txt`, frames in `$FIX/frames/`, archive extracts in `$FIX/archive/`.

Evidence commands:

- `cd $FIX/scripts && julia script_values.jl > ../repro_script_values.txt` (round-1 script, copies the old sum definitions verbatim)
- `/usr/bin/python3 -I $FIX/scripts/independent.py > $FIX/repro_independent.txt` (round-1 independent script, mpmath)
- `julia $FIX/scripts/inst_cc.jl > $FIX/inst_cc.txt`, `julia $FIX/scripts/inst_dd.jl > $FIX/inst_dd.txt`: instrumented copies of the **fixed** scripts (the repo scripts up to the `@animate` line, then printing every sum at full precision and the drawn-area check)
- `/usr/bin/python3 -I $FIX/scripts/indep_fix.py $FIX > $FIX/indep_fix.txt`: independent check of the fixed sums (sympy derivative, mpmath 30 digits, its own critical-point search, dense-grid cross-check); it reads the Julia values only to compare them
- `$FIX/refine_check.txt`, `$FIX/label_strings.txt`: partition-refinement check and six-decimal label check (commands in the Ledger)

Reference integral: $I = \int_0^2 \big(e^{-x}\sin(8x^{2/3})+1\big)\,dx = 2.0162797196170963279$ (mpmath, $x=t^3$ substitution; `indep_fix.txt`, and `repro_independent.txt` where a direct split gives the same 20 digits).

## Findings

### F1 — Error — fixed

- **Reproduced:** `repro_script_values.txt` reproduces the old GIF annotations: endpoint-min "Lower" n=1 2.0, n=2 2.017925, n=3 1.832477; endpoint-max "Upper" n=1 2.03585, n=3 1.965664. `repro_independent.txt` gives the true inf/sup sums: lower n=1 0.71440737, n=2 1.1527923; upper n=1 3.8395119, n=3 2.8814605. Old frames `$FIX/frames/old_riemanncc/frame_003.png` (bars at about 1.0 above the trough at 0.43) and `old_riemanndd/frame_004.png` (bars below both peaks) show it. The finding holds.
- **Archive:** Mathews' Examples 12/13 (`RiemannSumMod_lnk_17/18.html`) compute `LowerRiemann`/`UpperRiemann` with the remark "many minimums need to be approximated", and his recorded table (n=1: 0.714411 / 3.83949; n=16: 1.726233 / 2.240916) and his animations (`a2001/Animations/Quadrature/{Lower,Upper}Riemann/*.gif`) use the inf/sup on each subinterval. So the true inf/sup is both the mathematics and the intended example.
- **Change:** `riemanncc.jl`, `riemanndd.jl`.
  - Added `fp(x)` (analytic $f'$ for $x>0$), `critical_points()` (sign scan of $f'$ on 20 000 grid points in $(0,2]$, each sign change refined by 60 bisection steps) and `fmin(xl, xr)` / `fmax(xl, xr)` = min/max of $f$ over the endpoints and any critical point strictly inside $[x_l,x_r]$.
  - `lower_sum`/`upper_sum`: `min(f(a+(i-1)dx), f(a+i dx))` → `fmin(a+(i-1)dx, a+i dx)` (and `max` → `fmax`).
  - Drawing loop: `h = min(f(xl), f(xr))` → `h = fmin(xl, xr)` (and `fmax`). Bar heights and annotation come from the same function.
  - Also `"Approximation = $(round(approx; digits=6))"` → `"Approximation = " * @sprintf("%.6f", approx)` (`using Printf`, stdlib), because `round` drops trailing zeros: the new values 2.881460, 2.508600, 2.365760 and 1.953170 would have shown as 2.88146, 2.5086, 2.36576, 1.95317.
- **Check:**
  - sympy: `simplify(diff(f) - fp_script) = 0` (`indep_fix.txt`).
  - Script critical points `[0.08038354937224365, 0.43198195723294985, 0.9392052471495191, 1.5644755011307958]` (`inst_cc.txt`) match the independent mpmath search on 400 000 + log-spaced points `0.0803835493722437, 0.43198195723295, 0.939205247149519, 1.5644755011308` (four simple roots, $f''$ = −145.2, 33.13, −11.93, 4.562). $f' > 0$ on all scan points below the first critical point (min 0.000515), so no critical point is missed near $x=0$.
  - Fixed sums vs mpmath for all 24 n: max |Julia − mpmath| = 8.98e-16 (`indep_fix.txt`). Drawn-area (sum of bar heights × dx) equals the annotated sum to ≤ 1.1e-15 (`inst_cc.txt`, `inst_dd.txt` last column).
  - Dense-grid cross-check (2001 points per subinterval) for n=1,3,7,16 agrees to the grid's resolution and lies on the expected side (n=1 lower 0.71440738 vs 0.71440737; upper 3.8394905 vs 3.8395119).
  - New values agree with Mathews' recorded table to his precision where n coincides (e.g. n=10 lower 1.629124, n=16 lower 1.726233, n=120 lower 1.978951 / upper 2.050951). His n=1 values 0.714411 / 3.83949 differ in the 6th digit from the exact 0.714407 / 3.839512 because he approximated the extrema on a 1200-point grid (his code, `RiemannSumMod_gr_229.gif`); a grid min can only be ≥ the true min and a grid max ≤ the true max, which is the direction of his difference.

### F2 — Error — fixed

- **Reproduced:** `repro_independent.txt` columns `endptmin<=I?` False at n=2 (2.0179248 > I) and `endptmax>=I?` False at n=3 (1.9656644 < I). Old frames `old_riemanncc/frame_003.png` reads "Approximation = 2.017925" and `old_riemanndd/frame_004.png` reads "1.965664". The finding holds.
- **Change:** after F1 the sums are true lower/upper sums. `index.qmd` Case 3 Behavior: "Each rectangle uses the **minimum endpoint value** on each subinterval. For nonnegative $f$, this gives a lower bound…" → "Each rectangle uses the **minimum of $f$ on its subinterval**, so every frame's sum is a lower bound for the integral $I \approx 2.016280$. …". Case 4: "**maximum endpoint value** … giving an upper bound" → "**maximum of $f$ on its subinterval**, so every frame's sum is an upper bound for the integral." "For nonnegative $f$" removed.
- **Check:** `indep_fix.txt`: "all frames lower<=I: True  all upper>=I: True" over all 24 n, and the per-n column `lower<=I<=upper` is True for every row.

### F3 — Misleading — fixed (text, per D7)

- **Reproduced:** old "Lower" sequence falls 2.0179248 → 1.8324772 → 1.231216 (n=2,3,4) and 1.6249834 → 1.6211672 (n=7→8); old "Upper" rises 2.0358496 → 2.7279291 (n=1→2) and at n=7→8 (2.1429814 → 2.1920227) (`repro_script_values.txt`). As the independent check said, the true sums are not monotone along this n-sequence either. After the F1 fix, `indep_fix.txt`: "lower decreases at: [(3, 4, '1.374576', '1.192004')]" and "upper increases at: [(7, 8, '2.418035', '2.427098')]". These are the only non-monotone steps in each. The finding holds.
- **Change:** chose the reword over nested partitions (D7: the animation, after F1, is correct; Mathews' own sequence 1, 2, 4, 6, 8, 10, … is not nested either). Case 3: "…a lower bound that rises toward the integral as density increases" → "The sums approach $I$ as $n$ grows, but not monotonically: the lower sum falls from 1.374576 at $n=3$ to 1.192004 at $n=4$, which can happen because the $n=4$ partition is not a refinement of the $n=3$ one." Case 4: "Lower and upper sums squeeze the exact value as $n \to \infty$." kept, extended with "(at $n=120$, $1.978951 \le I \le 2.050951$), but not monotonically along this sequence of $n$: the upper sum rises from 2.418035 at $n=7$ to 2.427098 at $n=8$."
- **Check:** values above from `inst_cc.txt`/`inst_dd.txt` and `indep_fix.txt`; refinement from `refine_check.txt` ("3 4 not a refinement [2/3, 4/3]", "7 8 not a refinement"). New frames show the cited numbers: `new_riemanncc/frame_004.png` (n=3) "1.374576" (contact sheet), `new_riemanncc/frame_005.png` (n=4) "1.192004", `new_riemanndd/frame_008.png` (n=7) "2.418035", `new_riemanndd/frame_009.png` (n=8) "2.427098", last frames "1.978951" and "2.050951".

### F4 — Minor — fixed

- **Reproduced:** old `riemanncc.jl`/`riemanndd.jl` line 43 print `"Sample Points = $n"` where n is the number of subintervals; old code evaluated f at the n+1 nodes; the fixed code also evaluates f at interior critical points, so it is not a sample-point rule at all. Left/Right (`riemannaa.jl`, `riemannbb.jl`) sample exactly n points (`0:n-1` and `1:n`), so their label is correct. The finding holds for cc/dd only.
- **Change:** `"Sample Points = $n"` → `"Subintervals = $n"` in `riemanncc.jl` and `riemanndd.jl`. Left/Right left unchanged (correct, and changing them would only churn their GIFs). The Animations intro in `index.qmd` said "the number of sample points increases" for all four cases; → "the number of subintervals $n$ increases", which is true for all four (for Left/Right, subintervals = sample points). Alt text for Cases 3/4 now says "increases the number of subintervals".
- **Check:** new frames show "Subintervals = 1 … 120" (`new_riemanncc/sheet.png`, `new_riemanndd/sheet.png`, full-size frames 002, 003, 005, 008, 009, 025).

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:22 | "the number of subintervals $n$ increases across the full interval" | all four scripts loop over `n_seq` (1…120, increasing) with `dx=(b-a)/n` over [0,2] (read in scripts); Left/Right sample n points | yes |
| index.qmd:44 | "minimum of $f$ on its subinterval" | `fmin` = min over endpoints + interior critical points; sympy `fp` check = 0; critical points match mpmath (`indep_fix.txt`) | yes |
| index.qmd:44 | "every frame's sum is a lower bound for the integral" | `indep_fix.py` → "all frames lower<=I: True" (24 of 24) | yes |
| index.qmd:44 | $I \approx 2.016280$ | mpmath I = 2.0162797196170963279 → `round(…,6)` = 2.01628 (`refine_check.txt`) | yes |
| index.qmd:44 | "approach $I$ as $n$ grows, but not monotonically" | lower 0.714407 → 1.978951 at n=120; one decrease only, at 3→4 (`indep_fix.txt`); limit holds for continuous f (Riemann integrable) | yes |
| index.qmd:44 | 1.374576 at $n=3$, 1.192004 at $n=4$ | `inst_cc.txt` 1.3745762078373442, 1.1920041539710546; mpmath 1.374576208, 1.192004154 | yes |
| index.qmd:44 | "$n=4$ partition is not a refinement of the $n=3$ one" | `refine_check.txt`: "3 4 not a refinement [2/3, 4/3]" | yes |
| index.qmd:48 (alt) | "increases the number of subintervals and uses the minimum of f on each subinterval" | same as F1/F4 checks; frames show "Subintervals = n" | yes |
| index.qmd:52 | "maximum of $f$ on its subinterval", "every frame's sum is an upper bound" | `fmax`; "all upper>=I: True" (24 of 24) | yes |
| index.qmd:52 | "(at $n=120$, $1.978951 \le I \le 2.050951$)" | `inst_cc.txt` 1.9789510236705385, `inst_dd.txt` 2.0509510464124627; I = 2.0162797 | yes |
| index.qmd:52 | "not monotonically … rises from 2.418035 at $n=7$ to 2.427098 at $n=8$" | `inst_dd.txt` 2.4180348322293406, 2.427098011520269; only increase in the sequence (`indep_fix.txt`); 7→8 not a refinement (`refine_check.txt`) | yes |
| index.qmd:56 (alt) | "…uses the maximum of f on each subinterval" | as above | yes |
| riemanncc.jl:68 / riemanndd.jl:68 | label "Subintervals = $n" | n = number of subintervals (`dx=(b-a)/n`, `for i in 1:n`) | yes |
| riemanncc.jl:69 / riemanndd.jl:69 | label "Approximation = %.6f" | `label_strings.txt`: all 48 strings; smallest distance of 1e6·value from a rounding boundary 2.9e-9, far above the 9e-16 error, so every printed 6th digit is correct | yes |
| riemanncc.jl / riemanndd.jl comments | "f'(x) for x > 0 (f' grows without bound as x -> 0+)" | sympy series in Trapezoidal record: $f' = \tfrac{16}{3}x^{-1/3}+O(1)$; `fp` = diff(f) | yes |
| riemanncc.jl / riemanndd.jl comments | "Minimum/Maximum of f on [xl, xr]: attained at an endpoint or at an interior critical point" | f continuous on [0,2], differentiable on (0,2]; extreme value theorem + Fermat; dense-grid cross-check agrees (`indep_fix.txt`) | yes |
| GIF titles | "Lower Riemann Sum" / "Upper Riemann Sum" (unchanged) | now true: bars are inf/sup heights | yes |

## Scripts and GIFs

- Scripts changed: `riemanncc.jl`, `riemanndd.jl`. Regenerated with `cd pages/numerical-methods/riemann-sums && julia riemanncc.jl && julia riemanndd.jl`. `riemannaa.jl`/`riemannbb.jl` not changed and not re-run.
- Frames extracted with `giftools.jl` into `$FIX/frames/new_riemanncc/` and `new_riemanndd/` (25 frames each: one blank n=0 frame + 24 n values). Viewed: both contact sheets; full size lower frame_003 (n=2, bars at the trough 0.357 and the dip 0.796, below the curve, 1.152792), frame_005 (n=4, 1.192004), frame_025 (n=120, 1.978951); upper frame_002 (n=1, one bar at the global max 1.920, 3.839512), frame_008 (n=7, 2.418035), frame_009 (n=8, 2.427098). In every viewed frame the lower bars stay under the curve and touch it at their lowest point, and the upper bars stay above it and touch it at their highest point; title, "Subintervals = n" and the six-decimal value are legible. In upper frame_002 the bar top (y = 1.92) runs just above the "Subintervals = 1" text; the text stays legible (cosmetic, left as is).
- `git status --short -- pages/numerical-methods/riemann-sums` after regeneration:
  ```
   M pages/numerical-methods/riemann-sums/index.qmd
   M pages/numerical-methods/riemann-sums/riemanncc.gif
   M pages/numerical-methods/riemann-sums/riemanncc.jl
   M pages/numerical-methods/riemann-sums/riemanndd.gif
   M pages/numerical-methods/riemann-sums/riemanndd.jl
  ```
  Only the expected files changed; `riemannaa.gif`/`riemannbb.gif` untouched.

## Legacy archive

Consulted. `n2003/RiemannSumMod.html` Examples 12 and 13 (`riemannsum/RiemannSumMod/Links/RiemannSumMod_lnk_17.html`, `_lnk_18.html`) and the linked animations `a2001/Animations/Quadrature/LowerRiemann/LowerRiemannaa.gif` and `UpperRiemann/UpperRiemannaa.gif` (frames in `$FIX/archive/Lower/`, `$FIX/archive/Upper/`).

- Function and interval: $f(x)=1+e^{-x}\sin(8x^{2/3})$ on $[0,2]$ (code image `RiemannSumMod_gr_229.gif`), the same as the page. The small formula image `RiemannSumMod_gr_227.gif` in the example heading shows $1+e^{-x}\sin(\tfrac92 x)$, which disagrees with Mathews' own code and plot; the code and plot are what the animations use.
- Method: true lower/upper sums ("many minimums need to be approximated"), approximated on a 1200-point grid. His animation bars visibly sit under (Lower) / over (Upper) the curve. This is what the fixed scripts now compute, exactly (critical points instead of a grid).
- n-sequence: Mathews used 1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 50, 60, 70, 80, 100, 120; the page keeps its own 1–8, 10, …, 120 (not a finding; unchanged). His sequence is not nested either.
- His animation labels also say "Sample Points = n"; the page follows F4 ("Subintervals").
- His tabulated values agree with the fixed page where n coincides, up to his grid approximation in the 6th digit at n=1 (0.714411 vs exact 0.714407, 3.83949 vs 3.839512, in the direction a grid approximation must err; see F1 Check).

## Notes

- Description line 15 ("bounds from interval minima/maxima") was left unchanged: after the F1 fix it is accurate.
- Cases 1–2 (Left/Right) were not touched; no finding names them. Their annotations use `round(approx; digits=6)`, so the n=1 Left frame label reads "Approximation = 2.0" for 2.000000 (`julia -e` with the same `round` call prints "Approximation = 2.0"). The value is correct, just shown with fewer digits; not changed here to avoid touching unflagged GIFs. Jason may want the same `@sprintf("%.6f")` change in `riemannaa.jl`/`riemannbb.jl` for consistency.
- D1 (measured order) was not applied: the page states no convergence order for any case, and no finding asks for one.
- The page has no other convention gaps noted by the findings; nothing outside the page folder was touched.

## Resolution check (independent checker, not shown this record)

Scratch work: `check/indep.py` (independent Python, mpmath + dense grid + bounded local refinement), `check/vals.jl` (loads the committed scripts' functions and prints their values, plus a grid check of each bar height), `check/run/` (scratch-copy regeneration), `check/cc/` and `check/dd/` (frames and contact sheets).

Reference integral: I = 2.01627971962 (mpmath quad split at the extrema), and 2.0162797196171 (scipy quad after the substitution x = t^3, which removes the x^(2/3) cusp). Rounded: 2.016280.

### Original findings

### F1 — resolved
- Evidence: riemanncc.jl and riemanndd.jl now compute the bar height and the sum from `fmin`/`fmax`, the min/max of f over the endpoints plus any interior critical point. The script's critical points (0.08038354937, 0.43198195723, 0.93920524715, 1.56447550113) agree with mpmath `findroot` on f′ to 11 digits. f′ > 0 near 0 (the (16/3)x^(-1/3) term dominates), so starting the grid at 1e-4 misses nothing.
- Script values match my independent inf/sup sums (dense grid, geometric refinement near the left end, bounded local minimisation) at 6 decimals for all 24 n in both GIFs. For example, lower: n=1 0.714407, n=2 1.152792, n=3 1.374576, n=120 1.978951; upper: n=1 3.839512, n=3 2.881460, n=16 2.240918, n=120 2.050951. (The original table gave the n=3 true upper as 2.881461. The exact value is 2.88146049494, so 2.881460 is correct.)
- On a 2001-point grid in every subinterval, for every n, no lower bar is above the curve and no upper bar is below it (max violation 0.00e+00).
- Frames: riemanncc frame 3 (n=2) has bars at 0.36 (trough) and 0.80 (dip near 1.56), both under the curve. riemanndd frame 4 (n=3) has bars at 1.92 and 1.38, touching the peaks. riemanndd n=16 has its first bar at 1.92. Titles "Lower/Upper Riemann Sum" are now accurate, and Description line 15 ("bounds from interval minima/maxima") now agrees with the scripts.

### F2 — resolved
- Evidence: "minimum/maximum endpoint value" and "For nonnegative f" are gone. The new text says each rectangle uses the min (max) of f on its subinterval, so every frame's sum is a lower (upper) bound. This holds for all 24 frames of each GIF (independent L ≤ I ≤ U at every n). It is also true in general for bounded f.

### F3 — resolved
- Evidence: "rises toward the integral" is replaced by "approach I as n grows, but not monotonically", with concrete counterexamples that I verified: lower 1.374576 (n=3) → 1.192004 (n=4); upper 2.418035 (n=7) → 2.427098 (n=8). These are the only non-monotone steps in each sequence. The explanation (n=4 does not refine n=3) is correct: refinement would force L to be non-decreasing, so non-nesting is necessary for the drop. "Squeeze … as n → ∞" is kept and is true (f is continuous on [0,2]), and it is now qualified with "not monotonically along this sequence of n".

### F4 — resolved
- Evidence: the Lower/Upper GIF label now reads "Subintervals = n" (seen in the full-size frames). The Left/Right GIFs keep "Sample Points = n", which is accurate there (n sample points), so it was correctly left alone. The Animations intro (line 22) now says "number of subintervals n", which is true for all four cases.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd:22 | "the number of subintervals $n$ increases across the full interval" | All four scripts use n_seq = 1…120 equal-width subintervals of [0,2] | correct |
| index.qmd:44 | "minimum of $f$ on its subinterval" | vals.jl grid check (no bar above the curve); matches independent inf at 6 dp | correct |
| index.qmd:44 | "every frame's sum is a lower bound" | Independent L_n ≤ I for all 24 n | correct |
| index.qmd:44 | $I \approx 2.016280$ | mpmath 2.01627971962; scipy (x=t³) 2.0162797196171 | correct |
| index.qmd:44 | "approach $I$ as $n$ grows, but not monotonically" | L_n → 1.978951 at n=120; one drop at n=4 | correct |
| index.qmd:44 | 1.374576 at n=3, 1.192004 at n=4 | Independent: 1.374576, 1.192004; script 1.3745762078, 1.1920041540 | correct |
| index.qmd:44 | "n=4 partition is not a refinement of the n=3 one" | Nodes {k/3·2} ⊄ {k/4·2}; a refinement would force L non-decreasing | correct |
| index.qmd:48 | alt: "increases the number of subintervals and uses the minimum of f on each subinterval" | Matches script and frames | correct |
| index.qmd:52 | "maximum of $f$ on its subinterval" | Grid check (no bar below the curve); matches independent sup | correct |
| index.qmd:52 | "every frame's sum is an upper bound" | Independent U_n ≥ I for all 24 n | correct |
| index.qmd:52 | "squeeze the exact value as $n\to\infty$" | f continuous, so U−L → 0; 0.072 at n=120 and falling | correct |
| index.qmd:52 | $1.978951 \le I \le 2.050951$ at n=120 | Independent 1.978951 / 2.050951; script 1.97895102 / 2.05095105 | correct |
| index.qmd:52 | "not monotonically … rises from 2.418035 at $n=7$ to 2.427098 at $n=8$" | Independent 2.418035, 2.427098 | correct |
| index.qmd:56 | alt: "… uses the maximum of f on each subinterval" | Matches script and frames | correct |
| riemanncc/dd.jl:20 | f′(x) = e^{-x}((16/3)x^{-1/3}cos(8x^{2/3}) − sin(8x^{2/3})) | Differentiated by hand; roots agree with mpmath diff/findroot | correct |
| riemanncc/dd.jl:41 | fmin/fmax over endpoints + interior critical points | Extreme value theorem for differentiable f on (xl,xr); f is differentiable on (0,2] | correct |
| riemanncc/dd.jl:68 | "Subintervals = $n" | Matches n | correct |
| riemanncc/dd.jl:69 | "Approximation = %.6f" | All 24×2 frame values match independent sums at 6 dp; fixed width replaces round() (e.g. 2.508600) | correct |

### New problems
None. This rests on: independent agreement at all 48 annotated values; the grid check of every bar against the curve; full-size frames 2, 3, 13 and 25 (cc) and 2, 4, 12 and 25 (dd), plus both contact sheets; and a re-read of every changed sentence.

Cosmetic observations, not counted as problems:
- In riemanndd at n=1 and n=2, the first bar's top edge (y = 1.92) runs just above the "Subintervals = n" annotation at y = 1.88. The text is drawn on top and remains legible. This happens because the bar now correctly reaches the peak.
- In riemanndd the curve is drawn before the semi-transparent bars, so it looks washed out wherever bars cover it. The draw order is unchanged from before the fix, so this is pre-existing.

### Reproducibility and conventions
- riemanncc.jl and riemanndd.jl were run from scratch copies (`check/run/`). Both outputs are byte-identical to the committed GIFs (sha256 4c7f070e… and f0c9ccf5…, which equal the LFS oids in the diff). The unchanged riemannaa/bb GIFs were not touched.
- Conventions: Description comes before Animations. Each of the 4 cases has a `[Julia source]` link and a GIF embed. Alt texts are descriptive. There are no code blocks (0 fences).
- Files changed in the page folder: index.qmd, riemanncc.jl/.gif, riemanndd.jl/.gif only. Nothing outside `pages/numerical-methods/` is modified except untracked review notes under `reviews/numerical-methods-animations/fixes/`, including `riemann-sums.md`, which appears to be the fixer's report. Other pages' folders and `pages/numerical-methods/index.qmd` are also modified in the working tree. Those diffs do not mention riemann-sums and belong to other pages' fixes.

**Final status:** committed
