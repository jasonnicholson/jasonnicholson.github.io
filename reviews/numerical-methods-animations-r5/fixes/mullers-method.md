# Fix record: mullers-method

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r5fix/mullers-method/fix/`
- `inst_bb.jl`: instrumented copy of the original `mullersbb.jl` (iteration part only), prints each frame's triple, next iterate, max f and x-span.
- `indep_bb.py`, `roots_bb.py`, `checks_bb.py`: independent mpmath (50 digits) Muller runs with the parabola fitted by solving the 3×3 system, giving both parabola roots, vertex, step q3 − p2, step as a fraction of the zoomed window, and distance of the triple from √2.
- `committed_bb/`: frames of the committed (pre-fix) GIF; `new_bb/`: frames of the regenerated GIF.

## Findings

### F1 — Minor — fixed
- Reproduced: `julia inst_bb.jl` → frame 5 triple 1.322299, 1.368897, 1.397059 (max f 6.26e-2); frame 6 max f 1.586e-2; frame 9 triple 1.412696, 1.413924, 1.414174 (max f 1.841e-5). `committed_bb/frame_006.png` viewed: on the fixed [−1.5, 2.5] × [−0.2, 2.2] window the parabola lies on the f curve, the dots overlap and the axis crossing cannot be seen. mpmath (`indep_bb.py`) agrees with the script's iterates to all printed digits. One detail of the finding's wording is imprecise: "from frame 5 on, the three points lie within 0.04 of √2" holds from frame 7 on; the largest distance is 0.0919 in frame 5 and 0.0453 in frame 6 (`checks_bb.py`). The finding itself (mechanism invisible in the late frames) holds.
- Change (`mullersbb.jl`), following R5-A and Case 1's code:
  - removed the fixed `xlims`/`ylims` and the global backdrop range; each frame now sets x-limits to [min(q0..q3) − δ, max(q0..q3) + δ] with δ = 0.08·span and y-limits to (−0.08Y, 1.12Y), Y = max |f(q0,q1,q2)|, exactly as `mullersaa.jl`; f and the parabola are drawn across the zoomed window;
  - added an open red circle at (q3, 0), legend "axis crossing = next p₂" (Case 1 uses "vertex = next p₂");
  - added an inset (as Case 1's vertex inset) over x ∈ [q2 − 0.15s, q3 + 0.8s], s = q3 − q2, y ∈ [−0.25 f(q2), 1.15 f(q2)], showing f, the parabola, p₂ and the crossing; inset title `@sprintf("step to next p₂: %.2e", s)`;
  - legend moved :topleft → :bottomleft (the inset occupies the upper right); `using Printf` added; header and section comments updated.
  - Legend p₂ label format unchanged (5-decimal rounding, true values).
- Change (`index.qmd`): Case 2 Behavior gains one sentence describing the zoom and inset with the step sizes; Case 2 alt text extended likewise.
- Check: regenerated, frames extracted (`new_bb/`), frames 1, 5, 7, 9 viewed full size and all 9 on the sheet. In every frame the three points, the dashed parabola, and the open circle at its axis crossing are inside the main window, and the inset shows the step from the red p₂ dot down to the crossing. Inset titles read 2.54e-01, 6.80e-02, 4.66e-02, 2.82e-02, 1.14e-02, 4.28e-03, 1.23e-03, 2.51e-04, 3.58e-05, matching mpmath q3 − p2 (`checks_bb.py`). Legend p₂ values 1.0, 1.25432, 1.3223, 1.3689, 1.39706, 1.40841, 1.4127, 1.41392, 1.41417 unchanged and match mpmath. In frames 8–9 the parabola and f are indistinguishable even in the inset (the parabola's dip below the axis is −1.5e-8 and −9.8e-11, against f(p₂) = 6.7e-7 and 1.2e-8, i.e. 2.2% and 0.8% of the inset's scale; `roots_bb.py` and an mpmath one-liner for f(p₂)), which is the correct picture: the crossing lands 3.9e-5 and 3.3e-6 from √2.

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd Case 2 Behavior | "Each frame is zoomed to the current points" | Script: per-frame xlims from min/max(q0..q3) ± 8%, ylims from max f(q); frames viewed: axes change per frame (0.77–1.29 in frame 1 to 1.4126–1.4143 in frame 9) | yes |
| same | "the inset magnifies the step from $p_2$ to the parabola's axis crossing" | Inset x-width 0.95·s vs main width 1.16·span: s/window = 48.3%, 13.9%, 10.9%, 17.0%, 11.4%, 8.4%, 6.3%, 3.8%, 2.0% (`python3 -I checks_bb.py`), so the inset is narrower than the main window in every frame; inset y-range 1.4 f(p₂) < main 1.2·max f since f(p₂) < f(p₀) in every frame | yes |
| same | "(open red circle), which is the next iterate" | Script: `scatter!([q3],[0.0]; color=:white, markerstrokecolor=:red)`; q3 = `muller_step` = history next p₂ | yes |
| same | "the step shrinks from 0.25 to $3.6 \times 10^{-5}$" | `checks_bb.py`: steps 0.254, 0.068, 0.0466, 0.0282, 0.0114, 0.00428, 0.00123, 0.000251, 3.58e-5 — monotone decreasing; first rounds to 0.25, last to 3.6e-5 | yes |
| same | "over the nine frames" | `giftools.jl` → "9 frames"; n_iters = 8 → 9 frames | yes |
| index.qmd Case 2 alt text | "each frame is zoomed to the current points, and an inset magnifies the step from p₂ to the parabola's axis crossing, the next iterate" | As the Behavior rows above | yes |
| mullersbb.jl header comment | "close in on sqrt(2) (within 0.1 of it from frame 5 on)" | `checks_bb.py` max distance of triple from √2: frame 4 0.16, frame 5 0.0919, then 0.0453, 0.0172, 0.0058, 0.00152 | yes |
| mullersbb.jl header comment | "(from frame 7 on, under 7% of the main panel's width)" | `checks_bb.py` step/window: frame 6 8.4%, frame 7 6.3%, frame 8 3.8%, frame 9 2.0% | yes |
| GIF legend | "axis crossing = next p₂" | open circle at (q3, 0); q3 is the parabola root nearest p₂ (mpmath `roots_bb.py` q3 column equals script q3) | yes |
| GIF inset title | "step to next p₂: %.2e" values 2.54e-01 … 3.58e-05 | `checks_bb.py` step column; frames viewed | yes |

## Scripts and GIFs
- Script changed: `pages/numerical-methods/mullers-method/mullersbb.jl`. GIF regenerated: `mullersbb.gif` (md5 e065b5d6… → cdd680dc…).
- `mullersaa.gif` (f4240beb…) and `mullerscc.gif` (deac47d7…) untouched and byte-identical to the committed files; their scripts not changed.
- Frames viewed: new frames 1, 5, 7, 9 at full size and the 9-frame sheet; checked parabola through the three dots, open circle on the dashed curve's axis crossing, inset title values, legend p₂ values, no legend/inset overlap with the triple. The legend box (bottom left) covers a short stretch of the zero line at the left edge, where no data lie; cosmetic only.
- `git status --short -- pages/numerical-methods/mullers-method` after regeneration:
  ```
   M pages/numerical-methods/mullers-method/index.qmd
   M pages/numerical-methods/mullers-method/mullersbb.gif
   M pages/numerical-methods/mullers-method/mullersbb.jl
  ```

## Legacy archive
Consulted. `n2003/MullersMethodMod.html` and `mullersmethod/MullersMethodMod/Links/MullersMethodMod_lnk_*.html` read as text; Example 2 is a static Mathematica worked solution (Newton vs Muller for the multiple root), with its formulas and graphs as images. No Muller animation exists in `a2001/Animations/` (RootFinding has Bisection, FixedPoint, Newton, RegulaFalsi, Secant only), so there is no legacy window or pacing to follow. The round-5 review had already confirmed that the script's f and starting triple (0.8, 0.9, 1.0) and iterates match Mathews' Example 2 output; the fix changes only the plotting window, inset and marker, not the iteration.

## Notes
- The page still has no `## Description` section (convention gap noted by the review, not a finding); not added.
- The inset is an added plot element beyond pure limits; limits alone were tried first (`new_bb` before the inset) and did not make the step visible from frame 5 on, because the y-scale is set by p₀ while the step lands where f is 1e-3 to 1e-6 of that. The inset follows Case 1's existing pattern, as the brief asks.
- Nothing outside the page folder and this record was changed.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: `mullersbb.jl` no longer uses the fixed window `(-1.5, 2.5) x (-0.2, 2.2)`. Each frame now sets x-limits from min/max of (q0, q1, q2, q3) with an 8% margin and y-limits from max |f(q0,q1,q2)| (-0.08Y to 1.12Y). This is the same pattern as Case 1 (`mullersaa.jl`), as decision R5-A requires. An inset (subplot 2) shows the step from q2 to q3, with x from q2 - 0.15s to q3 + 0.8s and y from -0.25 f(q2) to 1.15 f(q2). It plots f, the same Lagrange parabola P, the red p₂ dot and an open red circle at (q3, 0). Since f(q2) > 0 and s = q3 - q2 > 0 in all 9 frames (checked independently), both inset limits are in increasing order.
- I extracted all 9 frames of the committed GIF and looked at each at full size, with crops of frames 1, 6 and 9 enlarged with nearest-neighbour scaling.
  - Main panel: in every frame the three points (two gray, one red), the dashed parabola, the f curve, the zero line and the open circle at the axis crossing are all inside the window. The red p₂ dot and the open circle are separate in every frame, including frame 9, where they are 1.41417 and 1.41421, about 10 px apart.
  - Inset: in every frame it shows the step from p₂ to the axis crossing at a readable size.
  - Frames 1–6: the parabola and f are clearly distinct in the inset.
  - Frames 7–9: they converge, which is mathematically correct. In frame 9 the parabola dips only 0.008·f(q2) below the axis, about 1 px. Blue dashes are still visible over the magenta curve in both panels, and the crossing point and the step are clear.
  - The old problem is gone: frames 6–9 no longer look the same apart from the legend.
- Independent computation: I recomputed the iteration in mpmath at 50 digits. It uses a linear-solve parabola fit and the root nearest p₂, which is independent of the script's formula. Every triple, q3, legend p₂ value and inset step value matches (see ledger). The discriminant is positive in all 9 frames.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| index.qmd Case 2 Behavior | "Each frame is zoomed to the current points" | Script: per-frame limits from (q0,q1,q2,q3) and max \|f\|. Frames 1–9 viewed. | True |
| index.qmd Case 2 Behavior | "the inset magnifies the step from p₂ to the parabola's axis crossing (open red circle), which is the next iterate" | Inset draws q2 (red) and (q3,0) as an open red circle. q3 = next p₂ (history[i+1][3] = q3). | True |
| index.qmd Case 2 Behavior | "step shrinks from 0.25 to 3.6 × 10⁻⁵" | mpmath: s₁ = 0.254316, s₉ = 3.57993e-5 | True |
| index.qmd Case 2 Behavior | "over the nine frames" | n_iters + 1 = 9. GIF has 9 frames. | True |
| index.qmd Case 2 alt text | "...each frame is zoomed to the current points, and an inset magnifies the step from p₂ to the parabola's axis crossing, the next iterate" | As above | True |
| mullersbb.jl header comment | "within 0.1 of it [√2] from frame 5 on" | Max distance from √2 over the triple: frame 4 = 0.160, frame 5 = 0.0919, then decreasing | True |
| mullersbb.jl header comment | "from frame 7 on, under 7% of the main panel's width" | step / (1.16·span): frame 6 = 0.084, frame 7 = 0.063, frame 8 = 0.038, frame 9 = 0.020 | True |
| GIF legend label (main) | "axis crossing = next p₂" | The open circle is at (q3, 0), and q3 becomes the next p₂ | True |
| GIF legend p₂ values | 1.0, 1.25432, 1.3223, 1.3689, 1.39706, 1.40841, 1.4127, 1.41392, 1.41417 | mpmath p₂, rounded to 5 decimals: 1.0, 1.254316, 1.3222994, 1.3688966, 1.3970592, 1.408413, 1.4126957, 1.4139237, 1.4141744 | All true |
| GIF inset titles "step to next p₂" | 2.54e-01, 6.80e-02, 4.66e-02, 2.82e-02, 1.14e-02, 4.28e-03, 1.23e-03, 2.51e-04, 3.58e-05 | mpmath: 0.25431599, 0.067983376, 0.046597258, 0.028162532, 0.011353807, 0.0042827015, 0.0012280165, 0.00025076125, 3.5799318e-5 | All true |
| mullersbb.jl code | legend moved to :bottomleft; parabola drawn over the whole window | Viewed: the legend covers no point, curve or step in any frame | OK |

### New problems
None.

This rests on:
- the full-size views of all 9 frames;
- the independent recomputation of every label and inset value;
- the check that the inset limits stay in increasing order (s > 0, f(q2) > 0 in every frame).

One cosmetic observation that I do not count as a problem: in frame 1 the inset's lower-left corner covers about 15 px of the f and parabola curves near x ≈ 1.04–1.055. No point, crossing or step is hidden.

### Reproducibility and conventions
- Reproducibility: I ran a scratch copy of `mullersbb.jl`. Its output GIF is byte-identical to the committed one (sha256 21188d1b…a3d6). The decoded frame md5s also match.
- Unchanged files: `mullersaa.gif` (sha256 2a7cd90a…970d) and `mullerscc.gif` (f66203eb…aa65) match the HEAD LFS oids. `mullersaa.jl` and `mullerscc.jl` have no diff.
- Page conventions:
  - Case 2 still has one source link and one embed.
  - The alt text is descriptive.
  - There are no code blocks.
  - The headings are unchanged.
  - The `## Description` section is still absent. This was already so before the fix, and the original report did not count it as a finding.
- Scope: the page-folder diff touches only `index.qmd`, `mullersbb.jl` and `mullersbb.gif`. Other modified files in the working tree are in other page folders (broydens-method, laurent-series, secant-method, aitkens-and-nevilles-interpolation) and come from separate fixes. They are not part of this page's diff.

**Final status:** committed
