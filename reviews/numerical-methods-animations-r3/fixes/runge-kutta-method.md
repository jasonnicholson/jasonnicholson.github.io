# Fix record: runge-kutta-method

Scratch: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r3fix/runge-kutta-method/fix/` (`f1check.py`, `f1cause.py`, `frames/`).

## Findings

### F1 — Minor — fixed
- **Reproduced:** `/usr/bin/python3 f1check.py`. This is an independent RK4, with the reference from DOP853 (rtol 1e-13), RK4's real-axis limit from brentq = 2.7852936, and the onset taken along the reference on a 1e-5 grid.
  - Along the reference: the onset for m = 12 is t = 3.1032, and h|f_y| reaches 17.190 at t = 5.
  - Along the plotted m = 12 run, the largest h|f_y| is 1.589, at 0 nodes above the limit.
  - The run's largest h|f_y| and its node count above 2.785, per m:

    | m | 12 | 14 | 16 | 18 | 20 | 24 | 28 | 52 |
    |---|---|---|---|---|---|---|---|---|
    | max h\|f_y\| on the run | 1.589 | 1.316 | 1.932 | 1.570 | 1.996 | 2.418 | 2.786 | 3.377 |
    | nodes > 2.785 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 5 |

  - The m = 12 error at the nodes t = 2.917 … 5 is 0.006, 0.168, 0.252, 0.442, 0.466, 0.580. The linear |R(h f_y)| along the reference at those nodes is 0.3, 9.3, 64.4, 270.7, 951.4, 2923.
  - So the finding holds. The shading and its onset are evaluated on the reference, which neither the legend nor the text said. For m = 12–24 the drawn run never itself exceeds the limit, and "errors are amplified instead of damped" overstates what the run does. That phrase is also one of the wordings D2 bans.
- **Change:**
  - `rungekuttaaa.jl`:
    - vspan label `h·|∂f/∂y| > 2.785` → `h·|∂f/∂y| > 2.785 on reference`;
    - annotation `h·|∂f/∂y| > 2.785 from t ≈ …` / `… < 2.785 up to t = 5` → `on reference: h·|∂f/∂y| > 2.785 from t ≈ …` / `on reference: h·|∂f/∂y| < 2.785 up to t = 5`;
    - a one-line comment added.
  - `index.qmd`, Case 1 Behavior: the stability sentence is rewritten in the D2 two-part form.
    - **The bound:** "along the reference solution", "evaluated along the reference solution", "linear stability limit", "along the reference stays below". The banned clause "and from then on errors are amplified instead of damped" is removed.
    - **One sentence added:** "This bound describes small departures from the reference, not the drawn run: for $m=12$ to $24$ the run's own $h\,|\partial f/\partial y|$ stays below $2.42$, and the consequence is what the runs show, the upturn and the error in $y(5)$ above."
  - Alt text: "a shaded region marks where h·|∂f/∂y|, evaluated along the reference solution, exceeds 2.785".
  - The GIF was regenerated.
- **Checker follow-up (causal claim):**
  - The checker noted that the retained opening "The cause is stability" is false for m = 12–18.
  - I reproduced this with `/usr/bin/python3 fix/f1cause.py`. For each m it finds the first upward step after t = 1.5 and compares that step's own truncation error, started from the reference, with the run's error after the step.
  - **m = 12–18:** the step starts before the onset (2.917 < 3.103, 2.857 < 3.162, 3.125 < 3.219, 3.056 < 3.278). Its own truncation error is 99.6%, 99.9%, 93.7% and 98.0% of the error after it (m = 12: 0.168 of 0.168).
  - **m = 20–56:** that error is ≤ 20% of the error after the step (m = 20: 0.200; m = 24–56: 0.003–0.034). The carried part (e_after − local)/e_before is 5.01, 6.93, 2.91, 5.66, 18.57, 3.57, 4.06, 4.24, 4.06, 3.65.
  - **m = 60, 70:** there is no upward step in the tail.
  - **Change:**
    - "The cause is stability:" → "The stability bound:".
    - "This bound describes" → "This bound concerns".
    - The clause "and the consequence is what the runs show, the upturn and the error in $y(5)$ above" is replaced by a per-range "What the runs do" passage, quoted in the ledger.
- **Check:**
  - I viewed the new frames 1 (m = 12), 13 (m = 52), 16 (m = 70) and 21 (m = 150) at full size, plus the contact sheet.
  - The legend reads "h·|∂f/∂y| > 2.785 on reference".
  - The annotation reads "on reference: h·|∂f/∂y| > 2.785 from t ≈ 3.10", and also 3.22, 3.34, 3.65, 3.95, 4.22, 4.45, 4.67 and 4.91 for m = 16, 20, 28, 36, 44, 52, 60 and 70. These match the Python onsets: 3.2190, 3.3416, 3.6515, 3.9537, 4.2179, 4.4532, 4.6663, 4.9082.
  - Frames for m ≥ 80 read "on reference: h·|∂f/∂y| < 2.785 up to t = 5".
  - The longest annotation ends just inside the right frame edge at x ≈ 623 px of 640. Nothing is clipped, and the annotation does not overlap the legend.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Behavior | "along the reference solution $\partial f/\partial y=-t/(3y^{2/3})$ reaches $-41.3$ at $t=5$" | f1check.py → fy(5) on ref = −41.2554 | yes |
| index.qmd Behavior | "steps longer than about $h=0.0675$ ($m\le74$; here $m=12$ to $70$)" (unchanged numbers) | 2.7852936/41.2554 = 0.067513; 5/74 = 0.06757 > h*, 5/75 = 0.0667 < h*; f1check onset exists for m = 12…70 and is none for 80…150 | yes |
| index.qmd Behavior | "$h\,|\partial f/\partial y|$ evaluated along the reference solution exceeds RK4's linear stability limit $2.785$" | brentq root of \|1+z+z²/2+z³/6+z⁴/24\| = 1 → −2.7852936; the script's `onset` loops over `tref, yref` | yes |
| index.qmd Behavior | "$m=70$: from $t\approx4.91$", "$m=12$ … $t\approx3.10$" (unchanged) | f1check → 4.9082, 3.1032 | yes |
| index.qmd Behavior | "For $m=80$ to $150$, $h\,|\partial f/\partial y|$ along the reference stays below $2.785$" | f1check: max h\|f_y\| on the reference is 2.578 (m = 80), and lower for larger m | yes |
| index.qmd Behavior | "for $m=12$ to $24$ the run's own $h\,|\partial f/\partial y|$ stays below $2.42$" | f1check run max: 1.589, 1.316, 1.932, 1.570, 1.996, 2.418 (all < 2.42); m = 28 reaches 2.786 > 2.785, hence the range ends at 24 | yes |
| index.qmd Behavior | "The stability bound:" replaces "The cause is stability:"; "This bound concerns small departures from the reference, not the drawn run" | No causal claim remains. The checker showed, and f1cause.py reproduces, that for m = 12–18 the upturn is not an amplified earlier error. | yes |
| index.qmd Behavior | "for $m=12$ to $18$ the upturn begins with one long step that starts before the shaded region ($t\approx2.92$ to $3.33$ for $m=12$)" | f1cause.py first tail rise: m = 12 [2.917, 3.333], m = 14 [2.857, 3.214], m = 16 [3.125, 3.438], m = 18 [3.056, 3.333]; every start is below the onset (3.103, 3.162, 3.219, 3.278) | yes |
| index.qmd Behavior | "$94$ to $100\%$ of the error just after it ($0.168$ for $m=12$) is that step's own truncation error, not an earlier error grown" | f1cause.py local/e_after = 0.996, 0.999, 0.937, 0.980; m = 12 local = 0.168, e_after = 0.168, e_before = 0.0058 | yes |
| index.qmd Behavior | "For $m=20$ to $56$ the error after the first upward step is mostly error carried from earlier steps" | f1cause.py local/e_after: 0.200 (m = 20), 0.015, 0.034, 0.016, 0.003, 0.030, 0.017, 0.012, 0.010, 0.010 (m = 24–56), so the carried share is ≥ 80% | yes |
| index.qmd Behavior | "which that step multiplies by $2.9$ to $18.6$" | f1cause.py (e_after − local)/e_before = 5.01, 6.93, 2.91, 5.66, 18.57, 3.57, 4.06, 4.24, 4.06, 3.65 → min 2.91, max 18.57 | yes |
| index.qmd Behavior | "For $m=60$ and $70$ the bound is crossed but the run does not turn upward" | onsets 4.666 and 4.908; f1cause.py "no tail rise" for m = 60 and 70 | yes |
| index.qmd alt text | "a shaded region marks where h·\|∂f/∂y\|, evaluated along the reference solution, exceeds 2.785" | script `onset(h)` uses `tref, yref`; shading appears in frames for m = 12–70 only (contact sheet) | yes |
| rungekuttaaa.jl legend | "h·\|∂f/∂y\| > 2.785 on reference" | frame_001.png | yes |
| rungekuttaaa.jl annotation | "on reference: h·\|∂f/∂y\| > 2.785 from t ≈ %.2f" / "… < 2.785 up to t = 5" | frames 1, 13, 16, 21 and sheet; onsets match f1check to 2 decimals | yes |

## Scripts and GIFs
- Script changed: `rungekuttaaa.jl` (the legend label and the annotation strings only; no computation changed). The GIF `rungekuttaaa.gif` was regenerated with `julia rungekuttaaa.jl`, giving 21 frames.
- I extracted the frames with giftools.jl to `fix/frames/`.
  - Viewed at full size: frames 1, 13, 16, 21. The contact sheet covers m = 12, 16, 20, 28, 36, 44, 52, 60, 80, 100, 150.
  - Unchanged in every frame: the y(5) values, the errors, the reference y(5) and the shading extent.
  - Changed in every frame: only the label text.
- `git status --short -- pages/numerical-methods/runge-kutta-method` →
  ```
   M index.qmd
   M rungekuttaaa.gif
   M rungekuttaaa.jl
  ```

## Legacy archive
- I did not consult it this round. F1 concerns a label and a sentence about the stability criterion that do not exist in Mathews' GIF.
- The round-3 review had already checked fidelity. The m list and all 21 printed y(5) values match, with no fidelity findings, and this fix changes neither.

## Notes
- The fix also removes the clause "from then on errors are amplified instead of damped". D2 in the current fix plan lists that clause as a banned wording. The same clause appears in the brief's quoted "pattern-setter" stability sentence, which predates the D2 rewrite. Fixers of other ODE pages should not copy that clause from the pattern.
- I first kept the opening "The cause is stability". The checker showed that it is false for m = 12–18, so it now reads "The stability bound:", and each range of m is described from its computed run (see the F1 follow-up).
- As before, the page has no `## Description` section. No finding names it, so it was not added.
- I did not render the page with Quarto.

## Resolution check (independent checker, not shown this record)

### Original findings
### F1 — resolved
- Evidence: Every place the criterion appears now says it is evaluated on the reference: page sentence ("along the reference solution ... evaluated along the reference solution exceeds RK4's linear stability limit 2.785"), alt text ("h·|∂f/∂y|, evaluated along the reference solution, exceeds 2.785"), legend (`h·|∂f/∂y| > 2.785 on reference`), annotation (`on reference: h·|∂f/∂y| > 2.785 from t ≈ 3.10` / `on reference: h·|∂f/∂y| < 2.785 up to t = 5`). Frames 1 (m=12), 11 (m=44), 16 (m=70), 21 (m=150) viewed at full size; the new legend and annotation are legible and fit inside the plot box (the longest annotation ends ~5 px left of the right frame edge). The script still computes the onset with `onset(h)` over `tref, yref`, so the label now matches the computation. The banned D2 phrase "from then on errors are amplified instead of damped" is gone (grep for amplif/damped/flatten: no hits in page or script). The optional addition was made: "This bound describes small departures from the reference, not the drawn run: for m=12 to 24 the run's own h|∂f/∂y| stays below 2.42" — true at the run's nodes (my maxima: 1.589, 1.316, 1.932, 1.570, 1.996, 2.418 for m=12,14,16,18,20,24).

### Changed-text ledger
Independent reference: scipy solve_ivp rtol 1e-13 (check/chk.py); zlim from mpmath root of R(z)=1.

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Behavior | "along the reference solution ∂f/∂y=−t/(3y^{2/3}) reaches −41.3 at t=5" | y(5)=0.0081199205, f_y(5)=−41.2554 | correct |
| index.qmd Behavior | h ≈ 0.0675, m ≤ 74, "here m=12 to 70" | h* = 2.785294/41.2554 = 0.067513, m* = 74.06; sweep values ≤74 are 12…70 | correct |
| index.qmd Behavior | "linear stability limit 2.785" | |R(z)|=1 root on negative axis z = −2.785294 | correct |
| index.qmd Behavior | "exceeds ... before t=5 (the shaded region in those frames)" | onset exists for all m=12…70 (3.103 … 4.908), none for m≥80; frames show shading only for m≤70 | correct |
| index.qmd Behavior | m=70 from t≈4.91; m=12 from t≈3.10 | 4.908, 3.103 | correct |
| index.qmd Behavior | "For m=80 to 150, h|∂f/∂y| along the reference stays below 2.785" | max on reference 2.58, 2.29, 2.06, 1.72, 1.38 | correct |
| index.qmd Behavior | "This bound describes small departures from the reference, not the drawn run" | standard linearisation statement; consistent with run-vs-reference values below | correct |
| index.qmd Behavior | "for m=12 to 24 the run's own h|∂f/∂y| stays below 2.42" | node maxima 1.589/1.316/1.932/1.570/1.996/2.418; m=28 reaches 2.786. (At RK stage values y goes negative, e.g. −1.15 at m=12, so the bound is about the nodes; that is the natural reading.) | correct |
| index.qmd Behavior | "the consequence is what the runs show, the upturn and the error in y(5) above" | refers to the run-computed numbers already on the page (0.588, 0.289, 0.0377, errors 3.4e-4 … 1.8e-7: recomputed 0.5883471, 0.2891074, 0.0376958, 3.43e-4, 2.76e-5, 6.80e-6, 1.76e-7) | correct; D2 two-part structure satisfied |
| alt text | "a shaded region marks where h·|∂f/∂y|, evaluated along the reference solution, exceeds 2.785" for m=12 to 70 | as above | correct |
| rungekuttaaa.jl legend | `h·|∂f/∂y| > 2.785 on reference` | matches onset computation on tref,yref | correct |
| rungekuttaaa.jl annotation | `on reference: h·|∂f/∂y| > %.3f from t ≈ %.2f` / `< 2.785 up to t = 5` | onset values above; frames show 3.10, 4.22 (m=44: computed 4.218), 4.91 | correct |
| rungekuttaaa.jl comment | "The criterion is evaluated along the reference solution, not along the plotted run" | true of `onset` | correct |

### New problems
1. Minor (pre-existing wording retained inside the rewritten sentence, not introduced by the fix) — index.qmd Behavior, "The cause is stability: ...". For the coarsest runs the upturn does not come from amplification of an earlier error. Locating the first tail rise and stepping once from the reference value (check/chk3.py):
   - m=12: the rise is on step [2.917, 3.333], starting where h|f_y|(ref)=1.64 (< 2.785, left of the shaded region that begins at 3.10, which is visible in frame 1); error before the step 5.8e-3; local error of that single step started on the reference 0.168; error after 0.168. m=14: 1.19 at start, local 0.114 of 0.114. m=16: 0.103 of 0.110. m=18: 0.076 of 0.078.
   - From m≈20–24 upward the picture is the linear one: the rise starts inside the shaded region and the error after the step is mostly propagated (m=24: local 8.7e-4, total 5.8e-2; m=52: local 2.4e-5, total 2.4e-3; one-step derivative dStep/dy along the reference 2–4 there).
   So for m=12–18 the upturn is the truncation error of one large step that crosses the onset, not growth of a small departure. This is a D2-style causal inference from the bound. The fix's new sentence ("the consequence is what the runs show") softens it. Suggested remedy: limit the causal claim to m ≳ 20, or say that for m ≤ 18 the upturn is the error of the single step that crosses into the shaded region.
2. Minor (pre-existing convention gap, not introduced) — the page has no `## Description` section before `## Animations` (HEAD has none either); the method overview sits in the Animations intro.

No other new problems: the script diff changes only label strings and a comment; computed quantities, shading and runs are unchanged.

### Reproducibility and conventions
- Ran a scratch copy of rungekuttaaa.jl (check/run/): output GIF is byte-identical to the committed rungekuttaaa.gif (cmp). 21 frames, 640×480. All 21 decoded frames differ from the HEAD GIF (obtained via `git show | git lfs smudge`), as expected: every frame's annotation and the shaded frames' legend text changed.
- Source link and GIF embed present for Case 1; alt text descriptive; no code blocks (0 backtick fences).
- The page's diff touches only pages/numerical-methods/runge-kutta-method/ (index.qmd, rungekuttaaa.jl, rungekuttaaa.gif). Other modified files in the working tree belong to other pages (lagrange, newton, laurent, pade, richardson) and to review fix records, not to this fix.

### Re-check (after the fixer's second edit)
What changed: index.qmd Behavior only. The script and GIF are unchanged since the first check: both are byte-identical to my scratch copy and its regenerated output. "The cause is stability:" became "The stability bound:", followed by a separate "What the runs do:" statement. Independent computation: check/chk4.py. It uses a scipy reference (rtol 1e-13). For each m it finds the first upward step after the peak. It splits the error just after that step into two parts:
- local: one step started on the reference, minus the reference;
- carried: step(y_run) − step(y_ref).
The multiplier is carried / (error before the step).

| Claim | My computation | Verdict |
|---|---|---|
| "The stability bound: ... (m≤74; here m=12 to 70) ... 2.785 ... t≈4.91 / t≈3.10 ... m=80 to 150 below" | unchanged from first check (h*=0.067513, m*=74.06, onsets 4.908 / 3.103) | correct |
| "for m=12 to 24 the run's own h|∂f/∂y| stays below 2.42" | node maxima ≤ 2.418 | correct |
| m=12–18: upturn begins with one long step that starts before the shaded region | first upward steps [2.917,3.333], [2.857,3.214], [3.125,3.438], [3.056,3.333]; onsets 3.103, 3.162, 3.219, 3.278. Every one starts before its onset. | correct |
| "t≈2.92 to 3.33 for m=12" | [2.9167, 3.3333] | correct |
| "94 to 100% of the error just after it is that step's own truncation error" | 99.6, 99.9, 93.7, 98.0 % | correct (93.7 rounds to 94) |
| "(0.168 for m=12)" | 1.681e-1 | correct |
| m=20–56: "mostly error carried from earlier steps" | carried share 80.0 % (m=20), 96.6–99.7 % (m=24–56) | correct |
| "which that step multiplies by 2.9 to 18.6" | multipliers 5.01, 6.93, 2.91, 5.66, 18.57, 3.57, 4.06, 4.24, 4.06, 3.65 for m=20,24,…,56; the range is 2.91–18.57 | correct |
| "For m=60 and 70 the bound is crossed but the run does not turn upward" | onsets 4.666 and 4.908; no step with Δy>0 after the peak | correct |

D2 compliance:
- The bound and the consequence are now in separate, labelled statements.
- The consequence is taken from the runs; it is not inferred from the bound.
- The sentence says explicitly that the bound concerns small departures from the reference, and that m=60 and 70 cross the bound without an upturn.
- A grep for amplif/damped/flatten/cause finds nothing on the page or in the script.

Original finding F1 is still resolved. New problem 1 from the first check ("The cause is stability" for m=12–18) is now resolved: the replacement text states exactly what my computation shows. New problem 2 (no `## Description` section; Minor, there before the fix and not introduced by it) is unchanged. Conventions still hold:
- source link and embed are present;
- the alt text is unchanged from the first check and correct;
- there are no code fences;
- the diff touches only the page folder.

**Final status:** committed
