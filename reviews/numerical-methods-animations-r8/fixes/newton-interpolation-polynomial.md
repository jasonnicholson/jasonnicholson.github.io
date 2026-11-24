# Fix record: newton-interpolation-polynomial

Covers both pages that share `lagnewt_animations_all.jl` (WP-B): Newton Interpolation Polynomial and Lagrange Polynomial Interpolation and Approximation. Decision applied: R8-B. A text-only change, with scripts and GIFs unchanged.

Scratch evidence: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/r8fix/newton-interpolation-polynomial/fix/` (`count_dots.py`, `dots_x.py`, `titles.py`, `band.py`, `band2.py`, `stub.py`, legacy frame folders, `titles_aa.png`, `titles_dd.png`).

## Findings

### F1 — Minor — fixed

- **Reproduced.**
  - `lagnewt_animations_all.jl` line 169 is `n_nodes_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]`, so the highest degree is 15.
  - `grep -n "0\.05\|vspan\|hspan\|tol"` on the script finds no tolerance band (the only hits are the Γ node spans).
  - The legacy GIFs were extracted with `giftools.jl`: `Lagrangeaa.gif` has 34 frames and `Lagrangedd.gif` has 29.
- **Settling the open questions (degree range, and what S_n counts).**
  - `titles.py` builds montages of the title crops (`titles_aa.png`, `titles_dd.png`). Frames 1–3 show f only.
    - `Lagrangeaa` (Case 01) runs S₂, S₂, S₃, S₃, S₄, S₄, S₅, S₅, S₆, S₆, S₇, S₇, S₈, S₈, then S₉ through S₂₅ one per frame. The last frame, 34, is **S₂₅**.
    - `Lagrangedd` (Case 04) follows the same pattern, from S₂ up to **S₂₀** in frame 29. So the Lagrange reviewer's "S₂…S₁₉" is wrong, and the Newton reviewer's S₂₀ is right.
  - The subscript is the **degree**. `dots_x.py` counted the red node markers:
    - Case 01, S₂ (frame 4, viewed): 3 nodes, at −1.5, −0.3 and 0.9.
    - Case 01, S₂₅ (frame 34): 26 markers, 19.5 px apart, from px 19.7 to 507.7. That is (0.9 + 1.5)/25 = 0.096 apart.
    - Case 04, S₂ (frame 4, viewed): 3 nodes, at 0, 1 and 2.
    - Case 04, S₂₀ (frame 29): 21 markers, 6 px = 0.1 apart (60 px per unit) on [0, 2].
  - Which GIF is which case:
    - `Lagrangeaa.gif` sits in `a2001/Animations/Interpolation/Lagrange/Lagrange01/`. Its title is y = 1/(1−x), with green verticals at −1.5 and 0.9, so it is page Case 01.
    - `Lagrangedd.gif` sits in `.../Lagrange04/`. Its title is y = √x, with the node interval [0, 2], so it is page Case 04.
  - Survival: the only other `.gif` in the 29 case folders, `Lagrange09/Lagrangeii.gif`, is an HTML page and not a GIF. `file` reports "HTML document", and giftools fails on it. So only Cases 01 and 04 survive.
- **What the band marks.** It is a yellow bar on the x-axis, labelled "Tolerance ±0.05" in every frame (frames 4 and 34 of aa and 4 and 29 of dd viewed at full size).
  - `band2.py` compares the bar's pixel extent in every frame with an independent 60-digit mpmath Lagrange interpolant on the same equally spaced nodes, taking the set where |P_n − f| < 0.05. Selected rows:
    - Case 01, S₆: bar x ∈ (−1.189, 0.193); computed run (−1.192, 0.199).
    - Case 01, S₂₅: bar (−1.538, 0.897); computed (−1.553, 0.908). The bar is cut at the left edge of the plot.
    - Case 04, S₃: bar (0.46, 2.16); computed (0.452, 2.184).
    - Case 04, S₂₀: bar (0.043, 2.027); computed (0, 2.079). The left end is hidden under the node marker at 0.
  - So the bar marks one interval (the run containing x = 0 in Case 01, and x = 1 in Case 04) on which the interpolant is within 0.05 of f, to within a few pixels. It does not mark the other small runs near the nodes.
  - In Case 01 S₂–S₄ the bar is only a 4-px stub at x = 0, where the error is 1.246, 0.247 and 0.253 (`stub.py`). It becomes a real interval from S₅ on (error at 0 is 0.0392). The page sentence therefore says "an interval on which…" and does not claim to give its extent.
- **Change.** One sentence was appended to the Animations introduction on each page (R8-B):
  - `pages/numerical-methods/newton-interpolation-polynomial/index.qmd` line 24, at the end of the paragraph;
  - `pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/index.qmd` line 25, at the end of the paragraph.

  The sentence is identical on both pages: "Mathews' own animations, of which only those for Cases 01 and 04 survive in the archive, went further, to degree 25 and degree 20 respectively, and drew a yellow bar on the $x$-axis, labelled "Tolerance ±0.05", over an interval on which the interpolant is within $0.05$ of $f$; these frames stop at degree 15 and have no such bar."
- **Check.** Each number in the sentence was compared with the frames and with computation; see the ledger. `cmp` of the two script copies reports them identical, and `git status` shows only the two `index.qmd` files modified.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| Newton index.qmd l.24; Lagrange index.qmd l.25 | "only those for Cases 01 and 04 survive in the archive" | `find a2001/Animations/Interpolation/Lagrange -iname '*.gif'` → Lagrange01/Lagrangeaa.gif, Lagrange04/Lagrangedd.gif, Lagrange09/Lagrangeii.gif. `file Lagrangeii.gif` → "HTML document". The `gifs/` folder is empty | yes |
| same | Cases 01 and 04 (GIF ↔ case) | Folder names Lagrange01 and Lagrange04. Frame titles 1/(1−x) and √x. Green node-interval lines at −1.5 and 0.9, and at 0 and 2, matching the page headings | yes |
| same | "degree 25" (Case 01) | `titles_aa.png`: the last title is S₂₅. `dots_x.py frame_034` → 26 node markers. S₂ has 3 nodes, so the subscript is the degree | yes |
| same | "degree 20" (Case 04) | `titles_dd.png`: the last title is S₂₀. `dots_x.py frame_029` → 21 markers, 0.1 apart on [0, 2] | yes |
| same | "yellow bar on the x-axis, labelled "Tolerance ±0.05"" | Frames aa 4 and 34 and dd 4 and 29 viewed: the bar lies along the x-axis, and the text reads "Tolerance ±0.05" | yes |
| same | "over an interval on which the interpolant is within 0.05 of f" | `band2.py`: in every frame from Case 01 S₅ and Case 04 S₂ on, the bar extent matches a computed run of \|P_n − f\| < 0.05 within ≈3 px. In Case 01 S₂–S₄ the bar is a 4-px stub at x = 0 (`stub.py`: errors 1.246, 0.247, 0.253) | yes (stub frames noted) |
| same | "these frames stop at degree 15 and have no such bar" | Script line 169: max 16 nodes → degree 15. A grep finds no band or tolerance drawing | yes |

## Scripts and GIFs

- No script was changed and no GIF was regenerated (R8-B: text option). The two copies of `lagnewt_animations_all.jl` are byte-identical (`cmp` → identical).
- Legacy frames were viewed in full: aa 1, 4 and 34, and dd 4 and 29, plus title montages of all frames of both.
- `git status --short` of both page folders shows only:
  - `M pages/numerical-methods/lagrange-polynomial-interpolation-and-approximation/index.qmd`
  - `M pages/numerical-methods/newton-interpolation-polynomial/index.qmd`

## Legacy archive

- **Consulted.** `a2001/Animations/Interpolation/Lagrange/` holds `Lagrange.html`, with the 29-case index, and the folders Lagrange01–29. Only 01 and 04 contain real GIFs, `Lagrangeaa.gif` with 34 frames and `Lagrangedd.gif` with 29.
- **What they show.** Each GIF is titled "Lagrange Newton Polynomial / Convergence Regions". It draws f in magenta and S_n in blue, with red nodes and green verticals at the node-interval ends. The degree n runs from 2 up to 25 (Case 01) or 20 (Case 04), and a yellow "Tolerance ±0.05" bar marks the run of |S_n − f| < 0.05 around x = 0 (Case 01) or x = 1 (Case 04).
- **What the text says.** The per-case HTML pages hold only navigation text, and neither the HTML nor `n2003/LagrangePolyMod.html` / `NewtonPolyMod.html` mentions a tolerance.
- **Difference from the pages.** The pages keep degrees 1–15 and draw no band. Under R8-B this is disclosed in one sentence rather than reproduced.

## Notes

- **Lagrange page change (WP-B).** The same sentence was added to the Lagrange page's Animations introduction, as the brief directs under R8-B. The Lagrange round-8 review had no findings, and its reviewer's note gave Case 04's range as S₂…S₁₉. The frames show S₂₀, so the page uses degree 20.
- The bar's extents in the legacy frames are a few pixels off the exact runs (for example, Case 04 S₂₀ ends at 2.027 against a computed 2.079), presumably from Mathews' sampling. The page therefore gives no extents.

## Resolution check (independent checker, not shown this record)

### Original findings

### F1 — resolved
- The fixer took the text option. Owner decision R8-B prescribes it: one sentence, no script or GIF change, and the same sentence on the Lagrange page. The diff is exactly one appended sentence in the Animations intro of each index.qmd. No script or GIF changed.
- The new sentence names the silent departure. It says Mathews' animations went to higher degree and drew a ±0.05 tolerance bar, and that these frames stop at degree 15 with no bar. Every claim in it checks out against the legacy frames (ledger below).
- The script is still `n_nodes_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]` (line 169), so the maximum titled degree is 15. The script has no tolerance band code (no fill/span/0.05 band; the only `0.05` hits are the Case 24/25 node spans). So "stop at degree 15 and have no such bar" is true of the GIFs.

### Changed-text ledger
| Location | Text / number | Check | Verdict |
|---|---|---|---|
| Both pages, Animations intro | "only those for Cases 01 and 04 survive in the archive" | The legacy folder `a2001/Animations/Interpolation/Lagrange/Lagrange01..29` contains `.gif` files only in 01 (`Lagrangeaa.gif`, 34 frames), 04 (`Lagrangedd.gif`, 29 frames) and 09 (`Lagrangeii.gif`). `Lagrangeii.gif` is an HTML error page, not a GIF (`file` reports HTML; ffmpeg cannot open it). The other folders hold only .html. No other copies exist under math-fullerton. | True |
| Same | Cases 01 and 04 are the same cases as on this page | The legacy frames show f = 1/(1−x) with nodes −1.5…0.9 (Case 01) and f = √x with nodes 0…2 and an x-window to about 10.5 (Case 04). These match script lines 32 and 35 and the page headings. | True |
| Same | "to degree 25 and degree 20 respectively" | The last frames are titled S₂₅[x] and S₂₀[x]. Convention: the S₂ frame has 3 node markers (−1.5, −0.3, 0.9), so S_n has n+1 nodes and degree n. The Case 01 last frame has 26 red markers at spacing 0.096 = 2.4/25 from −1.5 to 0.9. The Case 04 last frame has markers at 0, 0.1, …, 2.0 (21 nodes; 1.0 and 2.0 are hidden under vertical lines). No later frame has a higher S. | True |
| Same | "drew a yellow bar on the x-axis" | Yellow pixels form a bar along y≈0 in every frame from S₂ on. | True |
| Same | labelled "Tolerance ±0.05" | That text appears in every frame with S_n, read at full size. | True |
| Same | "over an interval on which the interpolant is within 0.05 of f" | I computed the true set {x : \|S_n−f\|<0.05} on the node interval in mpmath (60 digits) and compared it with the bar's pixel extents (Case 01: 204 px/unit, x=0 at px 325; Case 04: 60 px/unit, x=0 at px 12). Case 01 S₅ bar (−0.16, 0.005) vs true (−0.164, 0.015). S₆ bar (−1.19, 0.19) vs true (−1.192, 0.200). S₂₅ bar is the full [−1.5, 0.9], true is the full interval. Case 04 S₂ bar (0.85, 1.33) vs true (0.791, 1.354). S₂₀ bar (0.05, 2.0), true is all of [0, 2]. The bar is one sub-interval of the tolerance set, grown about a centre point (x=0 in Case 01, x=1 in Case 04), which matches the sentence's "an interval". Caveat: in the Case 01 S₂ and S₃ frames the bar shrinks to a 5-px speck at x=0, where \|S_n−f\|≈1.2. That is a degenerate drawing in Mathews' own GIF, not a misstatement on the page. | True (in substance) |
| Same | "these frames stop at degree 15 and have no such bar" | `n_nodes_seq` ends at 16 nodes, so the last title is degree 15. The script has no band. | True |
| Newton page | Placement after the even-case sentence, before "The shared script draws…" | Reads coherently. | OK |
| Lagrange page | Placement after "…poles (Cases 01–03, 14 and 24–26)." | Reads coherently, and is consistent with "1, 2, 3, 4, 5, 7, 9, 11, 13 and 15" earlier in the same paragraph. | OK |

### New problems
None. This rests on the following:
- The diff is two identical sentences.
- Every factual claim in them was verified from the legacy GIF frames: titles read at full size, node markers counted by pixel analysis, and bar extents compared with a high-precision computation of \|S_n − f\| < 0.05.
- No script or GIF changed.

### Reproducibility and conventions
- No script or GIF changed (`git diff HEAD --stat` lists only the two index.qmd files), so there was nothing to regenerate.
- The two copies of `lagnewt_animations_all.jl` are byte-identical (`cmp`).
- Conventions are kept on both pages: `## Description` comes before `## Animations`, there are no code fences, and the embeds are unchanged (Newton 30, Lagrange 29) along with their source links.
- No file outside the two page folders was changed by this fix. The untracked `pages/numerical-methods/numerical-differentiation/index_files/` predates it: its timestamps are 2026-11-23 22:45–23:00, against 02:48 on 11-24 for the fix's edits.

**Final status:** committed
