# Fix record: lagrange-polynomial-interpolation-and-approximation

One fixer owned this page and `newton-interpolation-polynomial` (decision R7-C). The two pages share `lagnewt_animations_all.jl`, and the two copies are still byte-identical (`cmp` prints nothing). See also `fixes/newton-interpolation-polynomial.md`.

Scratch folder (evidence, re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/lagrange-polynomial-interpolation-and-approximation/fix/` (written `$S` below). `lib_before.jl` / `lib_after.jl` are the committed and fixed scripts without their final render loop. The audits `include` them, so they run the script's own routines.

## Findings

### F3 — Misleading — fixed
- **Reproduced:** `julia $S/audit_before.jl` runs the committed routines without the clamp, on the script's 1000-point grid. Of 290 frames, 166 have clamped interpolant values. Thirteen of these have a clamped stretch strictly inside the node interval: Case 12 degree 5/7/9, Case 13 degree 7/9, Case 20 degree 4/9, Case 21 degree 5/7/9 and Case 27 degree 5/7/9. The true ranges match the review exactly. For example, Case 12 degree 7 is `[-5.15, 5.15]` against the y-window `[-1.6053, 1.6044]`, and Case 20 degree 4 is `[-0.822, 1]` against `[-0.8187, 1.3954]`. The committed Case 12 frame 6 shows flat tops at about ±1.60 (viewed: `$S/view/old_12_f06.png`). The f-clamp at line 194 also hits Cases 07, 09–11 and 24–29 (2 to 18 grid points per case).
- **Change:** `lagnewt_animations_all.jl`, in both copies:
  - Before: `ytrue_clip = [isfinite(y) ? clamp(y, ylims[1], ylims[2]) : NaN ...]` and `yinterp = clamp.(yinterp, ylims[1], ylims[2])`.
  - After: a local `offscale(y)` clamps to `[ylims[1] - yspan, ylims[2] + yspan]` (NaN stays NaN), as `pade_animations_all.jl` does. It is applied to `ytrue` and `yinterp`.
  - The pole-case comment no longer mentions "along the window edge".
  - `index.qmd` line 25: the sentence "drawn along the window's top or bottom edge, except f in Cases 01–03 and 14 …" is replaced by "A curve that goes off-scale leaves the plot window, and $f$ is broken at each of its poles (Cases 01–03, 14 and 24–26)."
- **Check:**
  - `/usr/bin/python3 -I $S/cmp2.py` measures, on the raw GIF pixels, the longest blue run within ±4 rows of the top or bottom frame line. Before the fix it was up to 529 px (Case 04 frame 10), with 70 px in Case 12 frame 5 and 78 px in Case 12 frame 6. After the fix it is at most 9 px in every frame of all 29 GIFs. That 9 px is a line crossing the border at a shallow angle.
  - New frames viewed at full size: Case 12 frame 6, Case 13 frame 7, Case 20 frame 7, Case 01, 18, 24 and 29 frame 10, and Case 28 frame 7. Contact sheets were viewed for Cases 18, 20, 21 and 27. In each, the curves leave the window and re-enter cleanly, with no flat segment.
  - **No new vertical line.** A blue column covering at least 90% of the plot height appears in exactly one frame, Case 28 frame 7, both before and after the fix (`cmp.py`). It is real. `/usr/bin/python3 -I $S/case28.py` (mpmath, 50 digits) finds that the degree-9 interpolant has a simple zero at x = 18.17646 with slope 109.8. It therefore crosses the whole window in 0.012 x-units, under one grid step (0.022) and about 0.4 px. P(18.168168) = −0.9048 and P(18.190190) = 1.5223.
  - **Γ pole in Cases 24–26.** The grid point at x = 0 gives Γ = NaN, so f is broken there (`audit2.jl`: x = −0.0054 gives Γ = −185.6, x = 0 gives NaN, x = 0.0054 gives Γ = 184.4). Case 24 frame 10 shows the gap.

### F1 — Minor — fixed (text)
- **Reproduced:** `/usr/bin/python3 -I $S/degree.py` solves the Vandermonde system at 120 digits on ideal symmetric nodes, for every symmetric case and frame. The output matches the finding's table exactly:
  - 08, 17, 20, 22: titled 1→0, 3→2, …, 15→14;
  - 13: titled 1→0, 3→0, 5→4, …, 15→14;
  - 14, 18, 19, 21, 23: titled 2→1, 4→3;
  - 12: titled 1, 2, 3 → zero polynomial, 4→3.

  In total, 54 frames have an exact degree below the title. The same holds on the new Case 18 and 20 intervals, which give the same lines as "18old" and "20old".
- **Change:** `index.qmd` line 25, after the node list, now reads: "The degree in each title is the number of nodes minus one, the most the interpolant can have; its actual degree can be lower. With nodes symmetric about 0, the interpolant of an even $f$ has only even powers of $x$ and that of an odd $f$ only odd powers, so in the even cases (08, 13, 17, 20 and 22) the frame titled degree 1 is a horizontal line and the frame titled degree 15 has degree 14." The Newton page uses the identical wording.
- **Check:** see the ledger. In Float64, the two nodes of each even case have exactly equal values (`julia $S/nodes_after.jl`), so the degree-1 frame is drawn as an exact horizontal line.

### F2 — Minor — fixed
- **Reproduced:**
  - Archive `n2003/lagrangepoly/LagrangePolyMod.nb`, Solution 13: `f[x_] = ArcTan[x]`, with `aa = -2.0; bb = 2.0` building the nodes. The plot window is a = −2, b = 2.
  - Solution 15: `f[x_] = BesselJ[0, x]`, with the window a = −10.2, b = 10.2 and the nodes `aa = -10; bb = 10`.
  - `LagrangePolyMod_lnk_25.html` and `_lnk_27.html` link Solution 13 to Animation 18 and Solution 15 to Animation 20.
  - `a2001/Animations/Interpolation/Lagrange/Lagrange18` and `Lagrange20` each hold only an HTML stub, with no GIF.
  - The committed script used `auto_span`, so its nodes ran over the whole window, [−2.2, 2.2] and [−10.2, 10.2].
- **Change:**
  - Script: `with_span("18", …, (-2.2, 2.2), (-2.0, 2.0))` and `with_span("20", …, (-10.2, 10.2), (-10.0, 10.0))`, with a comment citing the static examples.
  - `index.qmd`: the Case 18 and 20 headings now give nodes on $[-2, 2]$ and $[-10, 10]$. Their alt texts say "nodes on [−2, 2] … drawn with f on [−2.2, 2.2]" and "nodes on [−10, 10] … drawn with f on [−10.2, 10.2]". The window list on line 21 now reads "Cases 01–11, 14, 18–20 and 24–29".
- **Check:**
  - **No node on a singularity.** atan and J₀ are finite on the reals. `nodes_after.jl` confirms the nodes were untrimmed and finite for all 10 node counts, with ends exactly ±2 and ±10.
  - **y-window unchanged.** `audit_after.jl` gives Case 18 `[-1.8071, 1.8063]` and Case 20 `[-0.8187, 1.3954]`, the same as before.
  - **Case 18 note still true.** The three nodes are (−2, −1.10715), (0, 0) and (2, 1.10715), so the middle node lies on the chord. `degree.py` gives titled 2 → degree 1.
  - **Frames.** The Case 18 and 20 contact sheets show nodes at ±2 and ±10 inside the window. Case 20 degree 9 still overshoots between the nodes, P on the node span `[-1.113, 0.9577]`, and now visibly leaves the window.
  - **Case 21 is unchanged.** Its interval could not be determined from the archive, as the review says, so it keeps nodes on [−10.2, 10.2].

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| l.21 | "Cases 01–11, 14, 18–20 and 24–29" have a window wider than [a, b] | script: 18 window ±2.2 vs nodes ±2; 20 window ±10.2 vs nodes ±10; auto_span cases 12, 13, 15–17, 21–23 fill the window (`resolved_span` = `finite_support`) | yes |
| l.25 | degree in title = nodes − 1, "the most the interpolant can have"; "actual degree can be lower" | degree of an interpolant on n+1 nodes ≤ n; `degree.py` → 54 frames lower | yes |
| l.25 | symmetric nodes: even f → only even powers, odd f → only odd powers | uniqueness: P(−x) interpolates f(−x) = ±f(x) on the same nodes; `degree.py` shows this in every frame of 08, 12–14, 17–22 | yes |
| l.25 | even cases are 08, 13, 17, 20 and 22 | 1/(1+10x²), cos, cosh, J₀, normal pdf are even with nodes ±b; no other case has even f and symmetric nodes | yes |
| l.25 | "frame titled degree 1 is a horizontal line" in those cases | `degree.py` 1→0 for all five; `nodes_after.jl`: Float64 node values equal (e.g. J₀(±10) = −0.2459357644513483) | yes |
| l.25 | "frame titled degree 15 has degree 14" in those cases | `degree.py` 15→14 for 08, 13, 17, 20, 22 | yes |
| l.25 | off-scale curve leaves the plot window | `cmp2.py`: edge runs ≤ 9 px in all 290 new frames (max 529 px before); frames viewed | yes |
| l.25 | f broken at each of its poles (Cases 01–03, 14 and 24–26) | 01–03, 14: NaN at listed poles (unchanged code); 24–26: Γ(0) → NaN on the grid (`audit2.jl`); no other window contains a pole of f | yes |
| Case 18 heading, alt | nodes on [−2, 2], f drawn on [−2.2, 2.2]; degrees 1 and 2 the same line | script `with_span`; `nodes_after.jl`; `degree.py` 2→1 | yes |
| Case 20 heading, alt | nodes on [−10, 10], f drawn on [−10.2, 10.2] | script `with_span`; `nodes_after.jl` | yes |
| script comments | "Limit off-scale values to one y-span beyond the axes …"; "Cases 18 and 20: nodes as in Mathews' static examples …" | code as written; archive Solutions 13 and 15 | yes |

## Scripts and GIFs
- **Script changed:** `lagnewt_animations_all.jl`, kept identical in both page folders.
- **Regenerated:** `julia lagnewt_animations_all.jl` was run in each folder. The GIFs are byte-identical across the two folders (`diff` of sha256 lists). Of the 29 GIFs, 23 changed. Cases 06, 15, 16, 17, 22 and 23 are byte-identical; the audit shows none of them had any clamped value.
- **Changed frames.** Every frame of a changed GIF differs slightly, because the GIF palette is built over the whole animation. Frames with a significant change (more than 20 pixels with an RGB difference above 60) are exactly the frames predicted to change (`predict.jl`): the frames with a clamped P or f, plus all frames of Cases 18 and 20. There were 196 significant frames and 0 unpredicted.
- **Titles.** No title strip changed in any frame (`titles.py`: 0). Legend labels are unchanged in the code. Changes near the legend corners are curve pixels.
- **Frames viewed:** listed under F3 and F2.
- **git status after regeneration:** 23 GIFs, the `.jl` and `index.qmd` are modified in this folder, and the same in the Newton folder. `newtpolyaa.jl` and `newtpolyaa.gif` are unchanged.

## Legacy archive
- **Consulted:** `n2003/lagrangepoly/LagrangePolyMod.nb`, Solutions 13 and 15 (nodes on [−2, 2] and [−10, 10]), the link pages `_lnk_25` and `_lnk_27`, and `a2001/Animations/Interpolation/Lagrange/Lagrange18` and `Lagrange20`, which are stubs with no GIF.
- **Followed:** the page now follows the worked examples' node intervals for Cases 18 and 20.
- **Plot windows:** the window stays the animation's [−2.2, 2.2] for Case 18, where Mathews' Example 13 plots on [−2, 2], and [−10.2, 10.2] for Case 20, which is the same as his.
- **Case 21:** no worked example exists, so it is unchanged.

## Notes
- **Clamp.** R7-C names the Padé approach, so the clamp sits one y-span beyond the axes, rather than the review's "delete line 211".
- **Case 28 frame 7.** Its near-vertical blue line is the interpolant's real zero at x ≈ 18.176. It was in the committed frame too.
- **Case 20 still overshoots.** The interpolant still overshoots between the nodes in Case 20 at degrees 4 and 9 (`audit_after.jl`: `[-0.8618, 1]` and `[-1.113, 0.9577]`). It is now drawn leaving the window. The page makes no claim about it.
- **Not changed.** The alt texts' "degree rising from 1 to 15" is left alone. The new intro sentence says what the titled degree means.

## Resolution check (independent checker, not shown this record)

Scratch evidence: `check/run/` (fresh script run), `check/ana/analyze.txt` (per-frame drawn-vs-true measurements), `check/ana/cross.jl`, `check/ana/c28.jl`, `check/py/deg.py` (exact degrees, 80 digits), `check/frames/new*/` and `check/frames/old*/` (new and HEAD frames for Cases 04, 08, 12, 13, 18, 20, 21, 24, 27, 29).

### Original findings

### Lagrange F3 (= Newton F1): clamped flat tops between the nodes — resolved
- Evidence: `clamp.(yinterp, ylims...)` is replaced by `offscale`, which clamps to one y-span beyond the axes (Padé approach, R7-C). The same `offscale` now also applies to f (the old line 194 clamp).
- I re-ran the script's own routines (`ana/analyze.jl`) for all 29 cases x 10 frames. The 13 frames with in-span overshoot are still the same 13 (12 deg 5/7/9, 13 deg 7/9, 20 deg 4/9, 21 deg 5/7/9, 27 deg 5/7/9). In every frame of every case:
  - no drawn interpolant vertex lies on the window edge (`new_drawn_on_edge=0`);
  - the maximum visible deviation between the drawn polyline and the unclamped polyline is 0.000 px. No single grid step jumps from inside the window to beyond one span, so the offscale clamp never touches a visible segment.
- Frames:
  - Case 12 frame 6 (degree 7): the outer lobes now leave the top and bottom of the frame. In HEAD they ran flat along y = 1.60 from x ≈ 6.8 to 9.2.
  - Case 13 deg 7/9, Case 21 deg 5/7/9, Case 27 deg 7 and Case 20 deg 4/9: each curve exits and re-enters the window cleanly.
- Case 20 frame 4 now uses nodes on [-10, 10]. P reaches -0.8618 against a window bottom of -0.8187, about 8.5 px, so the dip visibly leaves the window.

### Lagrange F1 (= Newton F3): nominal vs actual degree — resolved
- Evidence: both pages add the same sentence, saying the title is the bound (nodes − 1), that the actual degree can be lower, and that symmetric nodes give an even/odd interpolant for even/odd f. It also says that in Cases 08, 13, 17, 20 and 22 the degree-1 frame is horizontal and the degree-15 frame has degree 14.
- `py/deg.py` gives exact degrees at 80 digits with ideal nodes, including the new Case 18 [-2,2] and Case 20 [-10,10] nodes:
  - 08, 17, 20, 22: 1→0, 3→2, …, 15→14.
  - 13: 1→0, 3→0, 5→4, …, 15→14.
  - 14, 18, 19, 21, 23: 2→1, 4→3.
  - 12: 1, 2, 3 → zero polynomial; 4→3.
- Every claim in the sentence holds, and the general parity statement covers the odd cases and Case 12.
- The even-f list (08, 13, 17, 20, 22) is complete: these are the only even f with symmetric nodes.

### Lagrange F2 (= Newton F4): Cases 18 and 20 node intervals — resolved
- Evidence: the script now uses `with_span("18", …, (-2.2, 2.2), (-2.0, 2.0))` and `with_span("20", …, (-10.2, 10.2), (-10.0, 10.0))`.
- Archive:
  - `LagrangePolyMod.nb` Solution 13 sets `aa = -2.0; bb = 2.0` (Example 13: ArcTan on [-2, 2]).
  - Solution 15 sets `aa = -10; bb = 10`, with plot `a = -10.2; b = 10.2`.
  - Newton module images `NewtonPolyMod_gr_525` read "[-2, 2]" and `gr_551` reads "[-10, 10]".
- Analysis confirms the nodes are at [-2, 2] and [-10, 10]. The frames show end nodes at ±2 and ±10 inside windows of ±2.2 and ±10.2.
- Headings, alt text and the Lagrange line-21 list ("14, 18–20") were updated on both pages. The degree 1 = degree 2 note for Case 18 remains true (2→1 above).
- Case 21 is unchanged; the finding said its interval could not be determined.

### Newton F2: interpolant runs along the frame edge outside the nodes — resolved
- Evidence: the same `offscale` change. Before the fix, 167 frames had interpolant values outside the window; that is 166 in the finding, and the one extra is from the Case 20 interval change. All of those values were drawn on the edge. Now 0 vertices are on the edge in all 290 frames.
- Case 04 frame 10 and Case 29 frame 10: the interpolant leaves the top of the window just past the last node, with no run along the border.
- f values beyond the window (Cases 07, 24–29 near their singularities) also go beyond the window, not along the edge.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Lagrange l.21 | window wider than [a,b] in "Cases 01–11, 14, 18–20 and 24–29" | script spans vs xlims for all 29 cases; 12, 13, 15–17, 21–23 are auto_span | true |
| Lagrange l.25 / Newton l.24 | "degree in each title is nodes − 1, the most the interpolant can have; actual degree can be lower" | deg.py | true |
| same | "with nodes symmetric about 0, even f → only even powers, odd f → only odd powers" | uniqueness and deg.py | true |
| same | "even cases (08, 13, 17, 20 and 22): frame titled degree 1 is horizontal; degree 15 has degree 14" | deg.py: 1→0 and 15→14 for all five | true |
| Lagrange l.25 | "A curve that goes off-scale leaves the plot window" | analyze: 0 edge vertices, 0 px deviation, all 290 frames | true |
| Lagrange l.25 | "f is broken at each of its poles (Cases 01–03, 14 and 24–26)" | cross.jl: NaN at x = 1 (01, 03), −1 (02), ±π/2 (14) and x = 0.0 exactly (24–26, a grid point); Γ has no other pole in [−0.2, 5.2] | true |
| Case 18 heading (both pages) | nodes on [−2, 2] | script, archive | true |
| Case 18 alt (both) | nodes on [−2, 2], f drawn on [−2.2, 2.2], degree 1 and 2 frames are the same line | script xlims; deg.py 2→1; frames 1–2 | true |
| Case 20 heading (both) | nodes on [−10, 10] | script, archive | true |
| Case 20 alt (both) | nodes on [−10, 10], f drawn on [−10.2, 10.2] | script xlims; frames | true |
| script comment l.51–52 | Cases 18/20 nodes as in Mathews' static examples, inside the wider window | archive | true |
| script comment l.196–197 | off-scale values limited to one y-span beyond the axes | code | true |
| script comment l.203 | "instead of drawing a segment across the pole" | pole cases keep a NaN at each pole | true |

### New problems
None. This rests on the following:
- **No new full-height vertical line.** I counted single-step segments crossing the whole window for f and the interpolant in all 290 frames. There is exactly one: Case 28, degree 9, at x ≈ 18.18, a real root of P (bisection gives 18.1765). There P goes from −0.905 to 1.522 across one 0.67 px grid step, so the line is a true crossing, not an artefact. Neither endpoint is offscale-clamped, so the drawn chord is the true chord.
- **No vertical line in Cases 24–26.** Γ is broken by the NaN at x = 0: f leaves the bottom for x < 0 and enters from the top for x > 0 (Case 24 frame 10 checked).
- **Robustness note, not a defect.** The break at x = 0 in 24–26 relies on the 1000-point grid hitting 0 exactly (−0.2 + 37·5.4/999). It does.
- **Frames looked at:**
  - full size: 12/6 (HEAD and new), 18/1, 18/10, 20/4, 20/7, 20/10, 24/10, 27/6, 04/10, 29/10;
  - contact sheets: 08, 13, 20, 21.

  Titles and legends are legible and correct, and nodes are drawn whole.

### Reproducibility and conventions
- **Fresh run.** A fresh run of a scratch copy of the script (`check/run/`, 34 s) gives 29 GIFs, all byte-identical to the committed GIFs. That includes 06, 15, 16, 17, 22 and 23, which are unchanged from HEAD.
- **The two copies agree.** The two copies of `lagnewt_animations_all.jl` are byte-identical (cmp). All 29 `lagnewt*.gif` files are byte-identical between the two folders.
- **`newtpolyaa.gif` and `newtpolyaa.jl`** are unchanged from HEAD.
- **Conventions are kept on both pages.**
  - Description comes before Animations.
  - There are no code fences.
  - Lagrange has 29 headings and 29 embeds with descriptive alt text.
  - Newton has 30 headings and 30 embeds.
  - Source links are present: one on Lagrange, two on Newton.
- **Scope of the diff.** The fix diff touches only the two page folders. Other modified paths in the working tree belong to other pages' work and are not part of this diff.

**Final status:** committed
