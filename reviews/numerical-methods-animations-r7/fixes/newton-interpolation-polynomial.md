# Fix record: newton-interpolation-polynomial

One fixer owned this page and `lagrange-polynomial-interpolation-and-approximation` (decision R7-C). Cases 01–29 come from the shared `lagnewt_animations_all.jl`, and the copy in this folder is byte-identical to the Lagrange one (`cmp` prints nothing). The scratch evidence and the full description of the audits are in `fixes/lagrange-polynomial-interpolation-and-approximation.md`. `$S` below is the same scratch folder: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r7fix/lagrange-polynomial-interpolation-and-approximation/fix/`. `newtpolyaa.jl` and `newtpolyaa.gif` are untouched (`git status` shows them unmodified).

## Findings

### F1 — Misleading — fixed
- **Reproduced:** `julia $S/audit_before.jl` runs the committed routines without the clamp. Thirteen frames have a clamped stretch strictly inside the node interval: Case 12 degree 5/7/9, Case 13 degree 7/9, Case 20 degree 4/9, Case 21 degree 5/7/9 and Case 27 degree 5/7/9. Every true range in the review's table is reproduced to the digits given. For example, Case 12 degree 7 is `[-5.15, 5.15]` and Case 27 degree 7 is `[-1.352, 1.514]`. The committed Case 12 frame 6 shows flat tops at about ±1.60.
- **Change:** in both script copies, `yinterp = clamp.(yinterp, ylims[1], ylims[2])` becomes `yinterp = offscale.(yinterp)`. `offscale` clamps to one y-span beyond the axes (the Padé approach, R7-C), and the same function now replaces the f clamp (`ytrue_clip`). The independent check notes that removing only line 211 would leave the f clamp; the f clamp is handled here too.
- **Check:**
  - `/usr/bin/python3 -I $S/cmp2.py` measures, on raw GIF pixels, the longest blue run beside the top or bottom frame line. It falls from 70/78/25 px to 3/4/3 px in Case 12 frames 5/6/7, and to at most 9 px in every new frame (a shallow crossing of the border).
  - Frames viewed: Case 12 frame 6, Case 13 frame 7, Case 20 frame 7, Case 21 and 27 contact sheets. The curves leave and re-enter the window, with no flat tops.
  - No new full-height line: the only one is in Case 28 frame 7, before and after the fix, and it is the interpolant's real zero at x = 18.17646 with slope 109.8 (`/usr/bin/python3 -I $S/case28.py`).

### F2 — Minor — fixed
- **Reproduced:** `audit_before.jl` reports 166 of 290 frames with clamped interpolant values, 13 of them inside the node interval and so 153 clamped only outside it. The edge runs in the committed frames reach 529 px (Case 04 frame 10) and 513 px (Case 29 frame 2), out of a plot width of about 680 px.
- **Change:** the same change as F1.
- **Check:** `cmp2.py` gives edge runs of at most 9 px in all 290 new frames. Case 04 frame 10 drops from 529 to 2 px, and Case 29 frame 10 from 502 to 2 px; Case 29 frame 10 was viewed. The f clamp (line 194 before) also no longer runs along the edge: Case 07 drops from 118 to 2 px, and Case 24 from 371 to 2 px (these runs include the interpolant).

### F3 — Minor — fixed (text)
- **Reproduced:** `/usr/bin/python3 -I $S/degree.py` (120-digit Vandermonde solve on ideal symmetric nodes) finds 54 frames whose exact degree is below the title, with the same per-case pattern as the finding. The count is unchanged on the new Case 18 and 20 intervals.
- **Change:** `index.qmd` line 24 now ends with the same two sentences as the Lagrange page: "The degree in each title is the number of nodes minus one, the most the interpolant can have; its actual degree can be lower. With nodes symmetric about 0, the interpolant of an even $f$ has only even powers of $x$ and that of an odd $f$ only odd powers, so in the even cases (08, 13, 17, 20 and 22) the frame titled degree 1 is a horizontal line and the frame titled degree 15 has degree 14."
- **Check:** see the ledger.

### F4 — Minor — fixed
- **Reproduced:**
  - Archive `LagrangePolyMod.nb`, Solution 13 (linked to Animation 18 in `LagrangePolyMod_lnk_25.html`), has `f[x_] = ArcTan[x]` and builds its nodes from `aa = -2.0; bb = 2.0`.
  - `NewtonPolyMod_lnk_27.html` links Example 13 / Solution 13 to Animation 18. Its formula and interval are images, which were not read.
  - The committed script had `auto_span`, so its nodes were on [−2.2, 2.2].
  - The review's effect numbers are reproduced by `julia $S/nodes_after.jl`: the largest degree-15 error on the node interval is 1.883e-2 on [−2.2, 2.2] and 8.514e-3 on [−2, 2]. These numbers are not on the page.
- **Change:**
  - Script: `with_span("18", "atan(x)", …, (-2.2, 2.2), (-2.0, 2.0))`.
  - Under R7-B, Case 20 also moves to [−10, 10], following `LagrangePolyMod.nb` Solution 15 (`aa = -10; bb = 10`, plot window ±10.2; linked to Animation 20) and `NewtonPolyMod_lnk_29.html` (Example/Solution 15 linked to Animation 20).
  - `index.qmd`: the headings give nodes on $[-2, 2]$ and $[-10, 10]$. The alt texts say "nodes on [−2, 2] … drawn with f on [−2.2, 2.2]" and "nodes on [−10, 10] … drawn with f on [−10.2, 10.2]".
- **Check:**
  - All nodes are finite and untrimmed, with ends exactly ±2 and ±10 (`nodes_after.jl`).
  - The y-windows are unchanged (`audit_after.jl`).
  - The Case 18 note still holds: the three nodes are (−2, −1.10715), (0, 0) and (2, 1.10715), so f[x₀, x₁, x₂] = 0, and `degree.py` gives titled 2 → degree 1.
  - The Case 18 and 20 contact sheets were viewed.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| l.24 | degree in title = nodes − 1, the most it can have; actual degree can be lower | degree of an interpolant on n+1 nodes ≤ n; `degree.py` → 54 frames lower | yes |
| l.24 | symmetric nodes: even f → even powers only, odd f → odd powers only | uniqueness of the interpolant applied to P(−x); `degree.py` pattern in 08, 12–14, 17–22 | yes |
| l.24 | even cases 08, 13, 17, 20, 22; degree-1 frame horizontal; degree-15 frame has degree 14 | `degree.py`: 1→0 and 15→14 in all five; `nodes_after.jl`: equal Float64 node values for 2 nodes | yes |
| Case 18 heading, alt | nodes on [−2, 2], f on [−2.2, 2.2]; degrees 1 and 2 the same line | script; `nodes_after.jl`; `degree.py` | yes |
| Case 20 heading, alt | nodes on [−10, 10], f on [−10.2, 10.2] | script; `nodes_after.jl` | yes |
| script comments | the off-scale clamp comment; the Cases 18/20 source comment | code; archive Solutions 13 and 15 | yes |

## Scripts and GIFs
- **Script:** `lagnewt_animations_all.jl`, edited in the Lagrange folder and copied here (`cmp` identical). It was regenerated with `julia lagnewt_animations_all.jl` in this folder.
- **GIFs:** this folder's `lagnewt*.gif` match the Lagrange folder's by sha256. 23 GIFs changed. Cases 06, 15, 16, 17, 22 and 23 are byte-identical because they had no clamped value.
- **Frames:** the frames with a significant pixel change are exactly the predicted ones (196 frames, 0 unpredicted). No title strip changed (`titles.py`).
- **git status (page folder):** `index.qmd`, `lagnewt_animations_all.jl` and 23 `lagnewt*.gif` are modified. `newtpolyaa.*` is unchanged.

## Legacy archive
- **Consulted:** `n2003/lagrangepoly/LagrangePolyMod.nb` (Solutions 13 and 15), the Lagrange link pages `_lnk_25` and `_lnk_27`, and the Newton link pages `NewtonPolyMod_lnk_27` and `_lnk_29`, which link Examples 13 and 15 to Animations 18 and 20.
- **Not read:** the Newton pages' formula images.
- **Missing:** the animation folders `a2001/Animations/Interpolation/Lagrange/Lagrange18` and `Lagrange20` contain only HTML stubs, and there is no Newton animation folder.
- **Followed:** the page now follows the worked examples' node intervals for Cases 18 and 20. Case 21 has no worked example and is unchanged.

## Notes
- **Clamp.** R7-C overrides the review's "delete line 211" with the one-y-span clamp.
- **Unchanged text.** The Newton page made no statement about off-scale drawing, so only the degree sentence and the Case 18 and 20 text changed. The page's alt texts keep "degree rising from 1 to 15".

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
