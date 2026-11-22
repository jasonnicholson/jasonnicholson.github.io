# Fix record: lagrange-polynomial-interpolation-and-approximation

Scratch evidence (re-runnable): `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r4fix/lagrange-polynomial-interpolation-and-approximation/fix/`. In it, `lib_orig.jl` and `lib_new.jl` are the shared script without its render loop, before and after the change.

Shared script (WP-B): `lagnewt_animations_all.jl` is the same on this page and on `newton-interpolation-polynomial`. Both copies were changed identically; `cmp` reports no difference. The Newton page has its own record.

## Findings

### F1 — Minor — fixed
- **Reproduced.** `julia frames_equal.jl lib_new.jl` evaluates the script's own `barycentric_eval` on its 1000-point grid. For every case it prints max|P(k nodes) − P(next node count)| between consecutive frames. The 2-node vs 3-node difference is ~0 in exactly these cases:
  - Case 12: 2.0e-31 (already explained on the page);
  - Case 14: 7.1e-15 (new nodes; 5.6e-17 with the old ones, per the review);
  - Case 18: 4.4e-16;
  - Case 19: 8.9e-16;
  - Case 21: 2.6e-18;
  - Case 23: 3.3e-16.

  Every other case is ≥ 0.18 (Case 27 is the smallest).
  Independent check: `python3 -I midnode.py` (mpmath, 30 digits) tests whether f(centre) − (f(a)+f(b))/2 = 0 for each of the 29 node intervals. It is 0 only for Cases 12, 14, 18, 19, 21 and 23. The finding holds as stated.
- **Change.** `index.qmd`, Cases 14, 18, 19, 21 and 23. Each gets a one-line note before the embed, in the style of the Case 12/13 notes: "<f> is odd and the nodes are symmetric about 0, so the middle of three nodes, (0, 0), lies on the line through the two end nodes, and the frames titled degree 1 and 2 show the same line." Case 23 uses f(x) − ½ and (0, ½). Each of the five alt texts gains "; the frames at degrees 1 and 2 show the same straight line."
- **Check.**
  - `python3 -I odd_dd.py`: max|g(x)+g(−x)| over 50 random points is 0.0 for tan, arctan, arcsin and J₁, and 5.7e-42 for Φ − ½ (at 40 digits).
  - f(0) is 0 for Cases 14, 18, 19 and 21, and 0.5 for Case 23.
  - f[x₀,x₁,x₂] on (−b, 0, b) is 0 to 40 digits in all five.
  - In the frames, Case 14 frames 1 and 2 show the same blue line (`frames14/frame_001.png`, `frame_002.png`), with the extra node at (0, 0). GIFs 18, 19, 21 and 23 are unchanged and byte-identical to the committed ones, so the review's contact-sheet observation still applies.

### F2 — Minor — fixed (followed Mathews, per R2-A/R3-B)
- **Reproduced.** The legacy notebook `n2003/lagrangepoly/LagrangePolyMod.nb`, lines 4167–4230, has Example 11: "Find the Lagrange polynomial approximation for f[x] = Tan[x], on the interval [−1.45, 1.45]". The solution code sets `a0 = -1.45; b0 = 1.45`, nodes `aa + (bb−aa)/n k`, window `a = −π, b = π, c = −10, d = 10`. It is followed directly by the link "Animation 14" to `Lagrange14/Lagrangenn.html`. That page has no image in the archive, so its nodes cannot be read. The page's nodes were on [−3, 3], so the finding holds. The script comment argued against [−π, π], which Mathews did not use.
- **Change.** `lagnewt_animations_all.jl`, lines 45–47:
  - Before: `(-3.0, 3.0)` with the comment "Nodes on [-3, 3], not [-pi, pi]: …".
  - After: `(-1.45, 1.45)` with the comment "Nodes on [-1.45, 1.45], between the poles at +-pi/2, as in Mathews' static example linked to animation 14 (window [-pi, pi])".
  - Both copies were changed and `lagnewt14.gif` regenerated on both pages. In `index.qmd`, the Case 14 heading now reads `[-1.45, 1.45]` and the alt text says "nodes on [−1.45, 1.45], between the poles of f at x = ±π/2".

  R2-A says to follow Mathews when a parameter of an existing case departs. Following him here makes nothing wrong and contradicts no round-1 fix. Round 1 replaced the auto-span [−π, π] with an inset, and the inset with [−3, 3], only to keep the nodes off the poles. [−1.45, 1.45] also keeps them off the poles: the closest node is 0.1208 from ±π/2 for every node count (`julia ylim14.jl lib_new.jl`).
- **Check.**
  - `julia ylim14.jl lib_new.jl` gives span (−1.45, 1.45), ylims ±10.215 (tan 1.45 = 8.238), close to Mathews' ±10.
  - Viewed frames 1, 2, 5 and 10 of the new `lagnewt14.gif` at full size, and the whole contact sheet:
    - nodes are red, on the central branch;
    - f (magenta) is broken at ±π/2 and runs off the window;
    - beyond the nodes the interpolant leaves the window and is drawn along the top or bottom edge, as the page's line 25 says;
    - titles read degree 1…15.
  - Page line 21 lists Case 14 among those whose window is wider than [a, b]. That is still true ([−1.45, 1.45] ⊂ [−π, π]).

## Ledger of changed text
| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Case 14 heading | nodes on $[-1.45, 1.45]$ | script row 47 `(-1.45, 1.45)`; `ylim14.jl` → span=(-1.45, 1.45) | yes |
| Case 14 alt | "between the poles of f at x = ±π/2" | 1.45 < π/2 = 1.5708; min node distance to ±π/2 = 0.1208 (`ylim14.jl`) | yes |
| Case 14 alt | "drawn with f on [−π, π] and broken at its poles" | xlims (−π, π), poles=[−π/2, π/2] unchanged; frames 1–10 show the break | yes |
| Cases 14/18/19/21 note | "<f> is odd" | `odd_dd.py` → max\|f(x)+f(−x)\| = 0.0 at 40 digits | yes |
| Case 23 note | "$f(x)-\tfrac12$ is odd" | `odd_dd.py` → 5.7e-42 | yes |
| all five notes | "nodes are symmetric about 0" | spans (−1.45,1.45), (−2.2,2.2), (−1,1), (−10.2,10.2), (−3,3) (`frames_equal.jl` output) | yes |
| notes | "middle of three nodes, (0, 0)" / "(0, ½)" | `odd_dd.py` → f(0) = 0 (14, 18, 19, 21), 0.5 (23) | yes |
| notes | "lies on the line through the two end nodes" | `midnode.py` → f(c) − (f(a)+f(b))/2 = 0.0 for 14, 18, 19, 21, 23 | yes |
| notes + alt | "frames titled degree 1 and 2 show the same line" | `frames_equal.jl` → max\|P₂−P₃\| ≤ 7.1e-15 on the plot grid; frames 1–2 of `lagnewt14` viewed | yes |
| script comment | "between the poles at +-pi/2, as in Mathews' static example linked to animation 14 (window [-pi, pi])" | `LagrangePolyMod.nb` lines 4167–4230 | yes |

## Scripts and GIFs
- **Scripts changed:** `lagnewt_animations_all.jl`, Case 14 node span and comment. The Newton page copy is byte-identical (`cmp`).
- **Regenerated:** `julia lagnewt_animations_all.jl` was run in both page folders.
- **Only `lagnewt14.gif` changed.** All other 28 GIFs are byte-identical to the committed ones. The 29 GIFs on the two pages are pairwise byte-identical.
- **Frames viewed:** `giftools.jl` was run on the new `lagnewt14.gif` (10 frames). The contact sheet and full-size frames 1, 2, 5 and 10 were checked for the elements listed under F2.
- **git status of the page folder:** `M index.qmd`, `M lagnewt14.gif`, `M lagnewt_animations_all.jl`.

## Legacy archive
Consulted.
- **Case 14:** `LagrangePolyMod.nb` Example 11 (tan x, nodes on [−1.45, 1.45], n = 3…6, window [−π, π] × [−10, 10]) is linked to Animation 14. The page now uses those nodes. The animation's own GIF (`a2001/Animations/Interpolation/Lagrange/Lagrange14/Lagrangenn.html`) has no image in the archive, so the animation's actual nodes are still unknown.
- **Degree sequence:** the page's degrees 1–15 differ from Example 11's n = 3…6. This is unchanged and was not a finding.
- **Shared index:** `Lagrange.html` (the shared animation index) gives no node interval for 14.

## Notes
- The per-case notes follow the existing Case 12/13 style, a plain sentence rather than a `**Behavior:**` paragraph. The page has no Behavior paragraphs, which is a pre-existing convention gap that no finding names, so none were added.
- The same symmetric-case notes were also added to the Newton page, because its GIFs are the same files and its F1 fix reuses these alt texts. See that record.
- The review notes that odd- and even-symmetric cases also lower the true degree of other frames, for example the even Cases 08, 13, 17, 20 and 22. Those frames differ from their neighbours, and "degree at most n" covers them, so nothing was added.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- Evidence: Cases 14, 18, 19, 21 and 23 now each have a one-line note (index.qmd lines 87, 105, 111, 121, 131). Each alt text now ends "the frames at degrees 1 and 2 show the same straight line". I ran the shipped case table (scratch copy of `lagnewt_animations_all.jl`, `ana/analyze.jl`) and measured max|P(2 nodes) − P(3 nodes)| over the 1000-point plot grid:
  - Case 14 (new nodes): 7.1e-15
  - Case 18: 4.4e-16
  - Case 19: 8.9e-16
  - Case 21: 2.6e-18
  - Case 23: 3.3e-16
- In every other case the smallest difference between consecutive frames is at least 0.024, apart from frames that have converged at high degree (Cases 15–17, degree 13 vs 15). So no unannotated "degree goes up, picture unchanged" pair is left at low degree.
- The 3-node middle node is exactly x = 0 in all five cases, with f(0) = 0 (and ½ for Case 23). In floating point f[x0,x1,x2] = 0 exactly for all five.
- The contact sheet `sym/sym.png` shows frames 1 and 2 of 18, 19, 21 and 23 identical apart from the title and the added middle node. Full-size frames 1 and 2 of the new lagnewt14 match in the same way.

### F2 — resolved
- Evidence: the fixer took the review's first option, which agrees with R2-A ("follow Mathews" for an interval parameter):
  - script line 47 now has node span (−1.45, 1.45), window (−π, π) and poles ±π/2;
  - the heading reads "nodes on $[-1.45, 1.45]$".
- I viewed `LagrangePolyMod_gr_444.gif`, the code linked from `LagrangePolyMod_lnk_23.html` (link target `Lagrange14/Lagrangenn.html`). It has `aa = -1.45; bb = 1.45`, a = −π, b = π, c = −10, d = 10.
- The equal_nodes run gives nodes exactly from −1.45 to 1.45 for every frame (no trimming). |1.45| < π/2 = 1.5708 and tan(1.45) = 8.238. The computed y-limits are ±10.215, close to Mathews' [−10, 10].
- The new GIF (full-size frames 1, 2, 5, 10) shows the nodes on the central branch between the poles, f broken at ±π/2, and the interpolant converging between the nodes and clamped to the window edge beyond them.
- The Chebyshev page already uses [−1.45, 1.45] for tan, so the two pages now agree.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Case 14 heading | $f(x)=\tan x$, nodes on $[-1.45, 1.45]$ | script line 47 span; equal_nodes endpoints exactly ±1.45 for all 10 frames; GIF title "f(x) = tan(x)" | correct |
| Case 14 note | tan odd, nodes symmetric, middle of three nodes (0,0) on the end-node line, frames titled degree 1 and 2 show the same line | 3-node mid = (0.0, 0.0); f[x0,x1,x2] = 0; max frame difference 7.1e-15; frames 1 and 2 viewed | correct |
| Case 14 alt | nodes on [−1.45, 1.45], between the poles at ±π/2 | 1.45 < 1.5708 | correct |
| Case 14 alt | degree 1 to 15 | n_nodes 2…16; titles "degree 1" … "degree 15" (frames 1 and 10 viewed) | correct |
| Case 14 alt | f drawn on [−π, π], broken at its poles | xlims (−π, π); NaN inserted at ±π/2; frames show breaks | correct |
| Case 14 alt | degrees 1 and 2 show the same straight line | as above | correct |
| Case 18 note and alt | arctan odd; middle node (0,0); deg 1 and 2 same line | mid (0.0, 0.0); diff 4.4e-16; sheet viewed | correct |
| Case 19 note and alt | arcsin odd; middle node (0,0); deg 1 and 2 same line | mid (0.0, 0.0); diff 8.9e-16; sheet viewed | correct |
| Case 21 note and alt | J₁ odd; middle node (0,0); deg 1 and 2 same line | J1(0) = 0; diff 2.6e-18; sheet viewed | correct |
| Case 23 note and alt | f − ½ odd; middle node (0, ½); deg 1 and 2 same line | f(0) = 0.5; f[x0,x1,x2] = 0; diff 3.3e-16; sheet viewed | correct |
| Script comment lines 45–46 | nodes [−1.45, 1.45] between poles, as in Mathews' static example linked to animation 14 (window [−π, π]) | gr_444 viewed | correct |
| Unchanged context, line 21 | "plot window wider than [a, b] (Cases 01–11, 14, 19, 24–29)" | Case 14 window [−π, π] ⊃ [−1.45, 1.45] | still true |
| Unchanged context, line 25 | f in Cases 01–03 and 14 runs off the window and breaks at poles; other curves along the edge | new frames: f breaks at ±π/2, interpolant clamped to y = ±10.215 | still true |

### New problems
None. This rests on:
- the computed frame differences for all 29 cases;
- full-size frames 1, 2, 5 and 10 of the new lagnewt14;
- frames 1 and 2 of Cases 18, 19, 21 and 23;
- the archive code image gr_444;
- a repository-wide search showing no remaining "[−3, 3]" reference for Case 14.

### Reproducibility and conventions
- I ran a scratch copy of `lagnewt_animations_all.jl` (`check/run/`). All 29 GIFs are byte-identical to the committed ones, including the new lagnewt14.gif (sha256 8630171a…).
- The script is byte-identical to the Newton page's copy (cmp).
- Only lagnewt14.gif changed among the GIFs. It is byte-identical to the Newton folder's lagnewt14.gif, and all 29 lagnewt GIFs agree across the two folders.
- Conventions:
  - Description (line 10) comes before Animations (line 23);
  - one shared source link and 29 GIF embeds, each with descriptive alt text;
  - no code blocks.
- Files changed: only the page folder, plus the Newton page folder (WP-B shared script). The only other working-tree items are the untracked fix records under `reviews/numerical-methods-animations-r4/fixes/`, which I did not read.

**Final status:** committed
