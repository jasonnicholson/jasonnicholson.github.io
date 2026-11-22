# Fix record: brents-method

Scratch folder (all evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/brents-method/fix/`
- `instr_brentsaa.jl`, `instr_brentsbb.jl`: the scripts' parameters and `run_brents` (lines 1–106, Plots removed), plus a per-step printout of b, c, |c−b|, f(b) and the new legend string.
- `px.py`: measures px per x-unit from the dashed bracket lines in frame 1 of each new GIF.
- `new_brentsaa/`, `new_brentsbb/`: frames, contact sheets and framemd5 of the regenerated GIFs.

## Findings

### F1 — Minor — fixed
- Reproduced: `/usr/bin/python3 -I -c "import mpmath as mp; mp.mp.dps=50; f=lambda x: mp.tan(x)-2*x; print([mp.nstr(mp.findroot(f,x0),12) for x0 in (-1.16,1.16,4.6,7.79)])"` → `['-1.16556118521', '1.16556118521', '4.6042167772', '7.78988375114']`. So tan x = 2x has other non-trivial roots and "the non-trivial root" is wrong. Sign changes of tan x − 2x on a 200001-point grid over [0.5, 1.5]: 1. On a 400001-point grid over (0, π/2): 1. tan x is continuous on both, so 1.16556 is the only root in [0.5, 1.5] and the only one in (0, π/2). The next branch (π/2, 3π/2) holds 4.604, so 1.16556 is the smallest positive root.
- Change: `index.qmd` Case 2 Behavior: "The non-trivial root of $\tan(x) = 2x$ lies at …" → "The root of $\tan(x) = 2x$ in $[0.5, 1.5]$ (its smallest positive root) lies at $x^* \approx 1.1656$." `brentsbb.jl` line 3: "Non-trivial root ≈ 1.1656." → "Root in [0.5, 1.5] (the smallest positive root of tan(x) = 2x) ≈ 1.1656."
- Check: the commands above. The value 1.1656 is unchanged (mpmath 1.16556118521).

### F2 — Minor — fixed
- Reproduced: `julia instr_brentsaa.jl` and `julia instr_brentsbb.jl`. Old 6-decimal labels: Case 1 steps 7 and 8 both round to 0.328538 (b = 0.3285384613493639 and 0.3285384586114149). Case 2 steps 8, 9 and 10 all round to 1.165561 (b = 1.1655612050524227, 1.1655611852026313, 1.1655611852026313). Measured bracket widths in pixels (`/usr/bin/python3 -I px.py`): 191.0 px/unit in Case 1 and 474.5 px/unit in Case 2. Case 1 step 5 is 2.11 px wide and steps 6–8 are 0.063, 0.062 and 0.062 px. Case 2 step 7 is 5.3 px wide and steps 8–10 are 0.032, 9.4e-6 and 2.4e-8 px. The finding holds.
- Change (smallest fix, a label format, as D5 and the lessons ask): `brentsaa.jl` and `brentsbb.jl` add `using Printf` (standard library). The legend label `"b = $(round(b_best; digits=6))"` becomes `@sprintf("b = %.10f, |c−b| = %.1e", st.b, abs(st.c - st.b))`. The window, the drawn elements and the frame count are unchanged. `index.qmd` Animations introduction gains one sentence that describes the new legend (see the ledger).
- Check: new legends, read from full-size frames and matching the instrumented printout:
  - Case 1 steps 0–8: b = 1.0000000000, 0.8000000000, 0.4000000000, 0.4000000000, 0.3392878122, 0.3282147397, 0.3285439194, 0.3285384613, 0.3285384586; |c−b| = 1.0e+00, 8.0e-01, 4.0e-01, 1.7e-01, 1.1e-01, 1.1e-02, 3.3e-04, 3.2e-04, 3.2e-04.
  - Case 2 steps 0–10: b = 0.5000000000, 0.5392637731, 1.0196318866, 1.0196318866, 1.1182930273, 1.1766603295, 1.1637285835, 1.1654929603, 1.1655612051, 1.1655611852, 1.1655611852; |c−b| = 1.0e+00, 9.6e-01, 4.8e-01, 2.4e-01, 1.4e-01, 5.8e-02, 1.3e-02, 1.1e-02, 6.8e-05, 2.0e-08, 5.0e-11.
  - Every pair of consecutive frames now differs in at least one legend value. Case 1 steps 7 and 8 differ in b. Case 2 steps 9 and 10 differ in |c−b|.
  - In Case 1, |c−b| stays at 3.2e-4 from step 7 to step 8 because c does not move. The run stops at step 8 because f(b) = 0, which the Behavior text already says (instrumented f(b8) = 0.000e+00).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| `index.qmd` Case 2 Behavior, sentence 1 | "The root of tan(x) = 2x in [0.5, 1.5] (its smallest positive root) lies at x* ≈ 1.1656." | mpmath findroot → 1.16556118521. Roots at −1.1656, 4.604 and 7.790 exist, so the qualifier is needed. Grid sign-change count is 1 on [0.5, 1.5] and 1 on (0, π/2), and the next positive root is 4.604 (F1 commands) | yes |
| `brentsbb.jl` line 3 comment | "Root in [0.5, 1.5] (the smallest positive root of tan(x) = 2x) ≈ 1.1656." | same as above | yes |
| `index.qmd` Animations intro, new last sentence of paragraph 1 | "The legend gives b to 10 decimal places and the bracket width \|c − b\|, …" | script label `%.10f` and `%.1e` of `abs(st.c - st.b)`. Frames `new_brentsaa/frame_009.png` and `new_brentsbb/frame_010.png`, `frame_011.png` viewed: "b = 0.3285384586, \|c−b\| = 3.2e-04", "b = 1.1655611852, \|c−b\| = 2.0e-08", "b = 1.1655611852, \|c−b\| = 5.0e-11" | yes |
| same sentence | "… so the last steps can still be followed after the bracket has become narrower than one pixel" | consecutive frames all differ in b or \|c−b\| (lists under F2). `px.py`: bracket widths below 1 px from Case 1 step 6 (0.063 px) and Case 2 step 8 (0.032 px) | yes |
| same sentence | "(from step 6 in Case 1 and step 8 in Case 2)" | `px.py`: Case 1 step 5 = 2.11 px and step 6 = 0.063 px. Case 2 step 7 = 5.3 px and step 8 = 0.032 px. All later steps are below 1 px | yes |
| `brentsaa.jl`, `brentsbb.jl` legend label | `@sprintf("b = %.10f, \|c−b\| = %.1e", st.b, abs(st.c - st.b))` | the values in the frames equal the instrumented printout (F2 Check) | yes |

Unchanged text that depends on the picture was rechecked. There are still 9 and 11 frames, so the alt texts' "8 steps" and "10 steps" hold. The GIF titles are unchanged.

## Scripts and GIFs
- Scripts changed: `brentsaa.jl` (Printf import, legend label) and `brentsbb.jl` (Printf import, legend label, header comment).
- GIFs regenerated in place with `julia brentsaa.jl` and `julia brentsbb.jl` from the page folder: brentsaa.gif has 9 frames and brentsbb.gif has 11, the same counts as before.
- Frames viewed at full size: brentsaa frames 8 and 9, brentsbb frames 10 and 11. I also viewed both contact sheets, which cover all frames. Checks:
  - the legend text is legible and is not clipped;
  - the legend box (bottom right) does not cover the curve near any root or the bracket;
  - the step labels and colours are unchanged;
  - the bracket and the dot are unchanged.
- `git status --short -- pages/numerical-methods/brents-method` after regeneration: `M brentsaa.gif`, `M brentsaa.jl`, `M brentsbb.gif`, `M brentsbb.jl`, `M index.qmd`. These are the expected files. Both GIFs had to change because both labels changed.

## Legacy archive
Consulted `n2003/brentmethod/BrentMethodMod/Links/BrentMethodMod_lnk_7.html` (Example 5). It asks for "the solution to the equation … that lies in the interval …", which is the root in the given interval. That agrees with the F1 wording. Its equations are images. The round-4 review already matched the script's iterates to Mathews' Example 4 and 5 tables. I found no Brent GIF under `a2001/Animations/` (`find -iname "*brent*"` returned nothing). Nothing in the archive conflicts with these fixes.

## Notes
- For F2 I chose the label option from the review's list over an inset or a second panel. It is the smallest change, as D5 and the round-4 lessons ask. The window stays a whole-function view, so the bracket still becomes invisible from step 6 (Case 1) and step 8 (Case 2), and the page now says so.
- In `brentsaa.jl`, `b_best` is still clamped to the x-window before the dot is drawn. The clamp never takes effect (the review's I-4), and the label now reads `st.b` directly.
- Nothing outside the page folder was touched apart from this record.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `index.qmd` line 74 now reads "The root of $\tan(x) = 2x$ in $[0.5, 1.5]$ (its smallest positive root) lies at $x^* \approx 1.1656$." `brentsbb.jl` line 3 now reads "Root in [0.5, 1.5] (the smallest positive root of tan(x) = 2x) ≈ 1.1656." No "non-trivial" wording is left in the folder (grep -i "trivial" finds nothing).
- Truth check. f(x) = tan x − 2x has f(0) = 0 and f'(x) = sec²x − 2, which is zero only at π/4 in (0, π/2). So f falls on (0, π/4), where f < 0, then rises to +∞ on (π/4, π/2). That gives exactly one root in (0, π/2), and it is the smallest positive root. f(0.5) = −0.4537 and f(1.5) = 11.10, so that root is the only root in [0.5, 1.5]. mpmath (40 digits) gives 1.165561185207211…; other roots are −1.16556118521, 4.6042167772 and 7.78988375114. The new sentence is true.

### F2 — resolved
- Evidence: both scripts now label the red dot `@sprintf("b = %.10f, |c−b| = %.1e", st.b, abs(st.c - st.b))`. I ran the scripts' own `run_brents` from scratch copies and printed each label:
  - Case 1, steps 6, 7, 8: `b = 0.3285439194, |c−b| = 3.3e-04`, then `0.3285384613, 3.2e-04`, then `0.3285384586, 3.2e-04`. Each step now shows a different b. The mpmath root is 0.32853845861141489597, so the final label is correct to all 10 printed digits.
  - Case 2, steps 8, 9, 10: `b = 1.1655612051, |c−b| = 6.8e-05`, then `1.1655611852, 2.0e-08`, then `1.1655611852, 5.0e-11`. Steps 9 and 10 have the same b (b = 1.1655611852026313 at both: the minimum step lands on the far side of the root and becomes c). They differ in |c−b|, 2.0e-08 against 5.0e-11, so each of the three steps is now distinct.
- Frames. I extracted all frames of the committed GIFs and viewed at full size Case 1 frames 1 and 9, Case 2 frames 6, 8 and 11, and the Case 1 contact sheet. The legend text is legible and matches the computed labels exactly. The superlinear collapse can now be read from the legend: in Case 2, |c−b| goes 1.1e-02 → 6.8e-05 → 2.0e-08 → 5.0e-11; in Case 1, b's 10-digit value settles. The reviewer's other options (a zoom inset or a log-error panel) were not taken, but the finding accepted any one option.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd l.74 | "The root of tan(x)=2x in [0.5,1.5] (its smallest positive root)" | monotonicity argument above, mpmath roots | correct |
| index.qmd l.74 | x* ≈ 1.1656 (unchanged) | 1.1655611852072 | correct |
| brentsbb.jl l.3 | "Root in [0.5, 1.5] (the smallest positive root of tan(x) = 2x) ≈ 1.1656" | same | correct |
| index.qmd l.60 (added) | "The legend gives b to 10 decimal places and the bracket width \|c − b\|" | the format string is `%.10f` for st.b and `%.1e` for abs(st.c−st.b); the frames show this | correct |
| index.qmd l.60 | "narrower than one pixel (from step 6 in Case 1 …)" | Case 1 scale: x=0 at ≈96 px and x=1 at ≈287 px, so ≈191 px/unit. Step 5 width 0.0111 → ≈2.1 px; step 6 width 3.29e-4 → ≈0.06 px | correct |
| index.qmd l.60 | "… and step 8 in Case 2" | Case 2 scale: x=0.5 at ≈143 px and x=1.0 at ≈378 px, so ≈470 px/unit. Step 7 width 0.0112 → ≈5 px (two dashed lines visible in frame 8); step 8 width 6.8e-5 → ≈0.03 px | correct |
| brentsaa.gif legends | 9 labels, from `b = 1.0000000000, \|c−b\| = 1.0e+00` to `b = 0.3285384586, \|c−b\| = 3.2e-04` | they match the recomputed run; the root agrees to 10 digits | correct |
| brentsbb.gif legends | 11 labels, from `b = 0.5000000000, \|c−b\| = 1.0e+00` to `b = 1.1655611852, \|c−b\| = 5.0e-11` | they match the recomputed run. Final b − x* = −4.6e-12, and the page's "width 5×10⁻¹¹" and "b ≈ 1.1655611852" are consistent with it | correct |

### New problems
None. This rests on the following checks:
- The scripts' iteration code is unchanged; the diff touches only the label line, `using Printf` and the header comment.
- Every frame has the same layout as the pre-fix frame. The full-size old and new frame 11 of Case 2 differ only in the legend.
- The wider legend box (bottom right) does not cover the curve, the red dot or the bracket in any frame I viewed. In Case 2 the curve passes just above the box's top-left corner near x ≈ 1.03, y ≈ −0.4, without overlapping it.
- The label uses the unclamped st.b; the old label used the clamped b_best. b always lies inside xlims, so the two are the same.

Observation, not a defect: in Case 1, |c−b| stays at about 3.2e-4 from step 6 to step 8, because c stays fixed while b converges from one side. The legend shows this honestly, and the page's Behavior text speaks of the error in b, not the bracket width. That is consistent.

### Reproducibility and conventions
- I ran `brentsaa.jl` and `brentsbb.jl` from scratch copies (check/run/). Both outputs are byte-identical to the committed GIFs (`cmp` silent). The GIFs have 9 and 11 frames.
- Conventions hold:
  - Description comes before Animations.
  - Each case has a `[Julia source]` link and a GIF embed.
  - The alt texts are descriptive and unchanged. Case 2's "the root at x≈1.1656" is fine in context.
  - There are no code blocks (no ``` in index.qmd).
- Files changed: the page fix (fix.diff) touches only the 5 files in `pages/numerical-methods/brents-method/`. The working tree also has changes in other page folders, but those belong to the other pages' concurrent round-4 fixes, not to this one.

**Final status:** committed
