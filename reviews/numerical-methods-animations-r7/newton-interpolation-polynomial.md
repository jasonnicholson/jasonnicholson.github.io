# Newton Interpolation Polynomial — animation review (round 7)

Page: `pages/numerical-methods/newton-interpolation-polynomial/`. Reported findings: **0 Error, 1 Misleading, 3 Minor**.

## Findings

### F1. Implementation, **Misleading**: clamping draws false flat tops on the interpolant between the nodes

- **Location:** `lagnewt_animations_all.jl:211`, `yinterp = clamp.(yinterp, ylims[1], ylims[2])`. Visible in 13 frames of Cases 12, 13, 20, 21 and 27.
- **What is there now:** where the polynomial overshoots the y-window *inside the node interval*, its value is replaced by the window limit, so the curve is drawn as a horizontal segment. A polynomial of degree 5 to 9 cannot have a flat stretch. Example: Case 12, degree 7 (`committed/lagnewt12/frame_006.png`) shows lobes with flat tops at y = ±1.60.
- **What is true:** the polynomial carries on to its real extreme. Measured on the script's 1000-point plot grid, within the node interval:

| Case | Title degree | Share of in-span grid clamped | True P range on span | y-window |
|---|---|---|---|---|
| 12 sin | 5 | 21% | [-2.116, 2.116] | [-1.605, 1.604] |
| 12 sin | 7 | 29% | **[-5.15, 5.15]** | [-1.605, 1.604] |
| 12 sin | 9 | 7% | [-2.126, 2.126] | [-1.605, 1.604] |
| 13 cos | 7 | 7% | [-1, 1.686] | [-1.605, 1.604] |
| 13 cos | 9 | 13% | [-3.022, 1.45] | [-1.605, 1.604] |
| 20 J0 | 4 | 3% | [-0.822, 1] | [-0.8187, 1.395] |
| 20 J0 | 9 | 11% | [-1.243, 0.9513] | [-0.8187, 1.395] |
| 21 J1 | 5 | 18% | [-1.138, 1.138] | [-0.9078, 0.9065] |
| 21 J1 | 7 | 20% | [-2.121, 2.121] | [-0.9078, 0.9065] |
| 21 J1 | 9 | 6% | [-1.095, 1.095] | [-0.9078, 0.9065] |
| 27 Y0 | 5 | 9% | [-0.7045, 0.4467] | [-0.5951, 0.7481] |
| 27 Y0 | 7 | 20% | [-1.352, 1.514] | [-0.5951, 0.7481] |
| 27 Y0 | 9 | 3% | [-0.5652, 0.8669] | [-0.5951, 0.7481] |

- **Why it matters:** the endpoint oscillation of equally spaced interpolation is the main thing these frames show. The flat tops understate it (by more than 3 times in Case 12, degree 7) and give the polynomial a shape it does not have.
- **How I know:** `review/dump.jl` runs the script's own routines without the clamp and writes `dump.txt`; `review/clamp.py` produces the table.
- **Correction:** delete line 211. Plots then clips the line at the axes. Tested in `review/fix2/` on Cases 12 and 29 (values up to 4e13): the curve leaves and re-enters the window cleanly and no flat segment remains (`review/fix2/compare.png`, `review/fix2/f29/f_09.png`).

- **Independent check:** confirmed with correction. The affected degrees are 4, 5, 7 and 9. Thirteen frames have a clamped stretch strictly inside the node interval (Cases 12, 13, 20, 21, 27), but 12 are visibly misleading: in Case 20 frame 4 the overshoot is 0.66 pixel. In the other 12 the true curve runs 9 to 489 pixels beyond the window. Removing line 211 alone would leave the same clamp on f at line 194.

### F2. Implementation, **Minor**: outside the nodes the clamped interpolant runs along the plot border

- **Location:** same line, `lagnewt_animations_all.jl:211`. In all, 166 of 290 frames in 21 cases contain clamped interpolant values; 153 of them are clamped only outside the node interval.
- **What is there now:** beyond the last node the polynomial is drawn as a blue line along the top or bottom frame edge, for up to 80% of the plot width (Case 29, degree 2; 79% at degree 15, and 78% in Case 04, degree 15).
- **What is true:** the polynomial has left the window and keeps growing. In Case 04, degree 15, |P| reaches 4.91e14; in Case 29, degree 15, it reaches 4.2e13. The script's own comment at lines 197-198 names this artefact ("a segment along the window edge") and avoids it for f in the pole cases, but not for the interpolant.
- **Why only Minor:** the line sits on the frame, so most readers will read it as off-scale, and the conclusion that the polynomial diverges survives.
- **Correction:** the F1 fix removes this too. Line 194 applies the same clamp to f in non-pole cases, over at most 1.8% of the width (Cases 07, 09-11, 24-29). That is negligible; I did not test changing it.

- **Independent check:** not run (Minor finding, unverified)

### F3. Page match, **Minor**: 54 of 290 frames are titled with a degree above the polynomial's exact degree

- **Location:** frame titles (`lagnewt_animations_all.jl:216`, `degree $(n_nodes - 1)`); `index.qmd:24`, "(degree 1 to 5, then 7, 9, 11, 13 and 15)"; the alt texts' "degree rising from 1 to 15".
- **What is there now:** every frame is titled with degree n-1 for n nodes.
- **What is true:** with symmetric nodes, an even f gives an even polynomial and an odd f gives an odd one, so the leading coefficient vanishes on half the frames:
  - Even f, Cases 08, 17, 20, 22: titles 1, 3, 5, ..., 15 are exactly degree 0, 2, 4, ..., 14. Each "degree 1" frame is a horizontal line and the "degree 15" frame has degree 14.
  - Case 13 (cos): titles 1 and 3 are degree 0 (the page says so); titles 5 to 15 are degree 4 to 14 (the page does not say so).
  - Odd f (or f - 1/2), Cases 14, 18, 19, 21, 23: title 2 is degree 1 (the page says so); title 4 is degree 3 (not stated).
  - Case 12 (sin): titles 1, 2, 3 are the zero polynomial (the page says so); title 4 is degree 3 (not stated).
- **How I know:** `review/deg2.py` expands each interpolant to monomial form at 60 digits and reads off the exact degree. Output: "frames whose exact degree is below the title: 54 of 290".
- **Why only Minor:** "degree n" for "degree at most n" is common usage for interpolants. The page already explains some of these frames, which makes the unexplained ones look like a different thing.
- **Correction:** add one sentence after `index.qmd:24`: "The degree in each title is the degree bound $n$ for $n+1$ nodes. With symmetric nodes the interpolant of an even function has only even powers and that of an odd function only odd powers, so the true degree can be one lower." Or title frames "degree ≤ n".

- **Independent check:** not run (Minor finding, unverified)

### F4. Fidelity, **Minor**: Case 18 uses nodes on [-2.2, 2.2]; Mathews' linked example uses [-2, 2]

- **Location:** `lagnewt_animations_all.jl:51` (`auto_span`, so nodes fill the plot window); `index.qmd:104` and `:108`.
- **What is there now:** nodes on [-2.2, 2.2], with no reason given.
- **What the archive shows:** Newton Example 13, the static page linked to Animation 18 (`NewtonPolyMod_lnk_27.html`), states `f[x] = ArcTan[x], [-2, 2]` (`gr_524`, `gr_525`). Its code sets `aa = -2.0; bb = 2.0` and builds its nodes from them (`gr_526`), and its graph has end nodes at ±2 (`gr_527`). The animation index gives only the plot window, -2.2 ≤ x ≤ 2.2. Animation 18's GIF is absent, so its own nodes cannot be read. The script comments treat the static example as the authority for Cases 07 and 14 but do not follow it here.
- **Effect:** at degree 15 the largest error on the node interval is 1.88e-2 on [-2.2, 2.2] and 8.51e-3 on [-2, 2] (`review/edge.py`). The page's own heading is accurate about what is drawn, so this is a departure and not a false statement.
- **Correction:** `with_span("18", "atan(x)", x -> atan(x), (-2.2, 2.2), (-2.0, 2.0))`, and change the heading and alt text to "nodes on $[-2, 2]$ ... drawn with f on [-2.2, 2.2]". The degree 1 = degree 2 statement remains true. The Lagrange page's Case 18 text would need the same change.

- **Independent check:** not run (Minor finding, unverified)


## Reviewer's notes (not findings)



#### Looked at, not counted as findings

- **Legacy animations are richer.** Mathews' surviving GIFs are titled "Convergence Regions", mark a ±0.05 tolerance band, and run to S25 (Animation 1) and S20 (Animation 4). The page stops at degree 15 without the band and says what it shows. This is content the page does not have, not an error.
- **Γ pole at x = 0 (Cases 24-26).** The pole is not listed in `poles`, but x = 0.0 lands exactly on the plot grid and `safe_eval` returns NaN there, so the curve breaks correctly and no false vertical line appears. This is fortunate rather than designed: a different grid length would draw a connector.

---

## Inventory (Phase 1)

### Regeneration (each script run alone from a scratch copy)

| Script | Exit | Seconds | GIFs produced | stderr (last line) |
|---|---|---|---|---|
| `lagnewt_animations_all.jl` | 0 | 35.5 | 29 GIFs (lagnewt01.gif … lagnewt29.gif) | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |
| `newtpolyaa.jl` | 0 | 7.3 | newtpolyaa.gif | [ Info: Saved animation to /tmp/claude-1001/-home-jason-Desktop-jasonhnicholson- |

### Committed GIFs vs regenerated output

| GIF | Frames | Comparison | Produced by |
|---|---|---|---|
| `lagnewt01.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt02.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt03.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt04.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt05.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt06.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt07.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt08.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt09.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt10.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt11.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt12.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt13.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt14.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt15.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt16.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt17.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt18.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt19.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt20.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt21.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt22.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt23.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt24.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt25.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt26.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt27.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt28.gif` | 10 | byte-identical | lagnewt_animations_all |
| `lagnewt29.gif` | 10 | byte-identical | lagnewt_animations_all |
| `newtpolyaa.gif` | 5 | byte-identical | newtpolyaa |

### Page references

- Scripts linked: `lagnewt_animations_all.jl`, `newtpolyaa.jl`
- GIFs embedded: 30
- Linked from the section index: yes

### Inventory findings (mechanical)

- None.


## Reviewer's supporting detail

### 2. Claim ledger

### Description and introduction

| # | Claim (page's words) | Verdict | Evidence |
|---|---|---|---|
| 1 | $P_n(x)=a_0+a_1(x-x_0)+\cdots+a_n\prod_{j<n}(x-x_j)$ | confirmed | used in `indep.py` and `aa.py`; reproduces the data |
| 2 | $a_k=f[x_0,\ldots,x_k]$ | confirmed | `divided_diff` agrees with independent table |
| 3 | Newton and Lagrange forms give the same polynomial | confirmed | barycentric vs Newton at 60 digits: max relative difference 5.9e-9, all 290 |
| 4 | Cases 01-29 reuse the Lagrange page's cases | confirmed | scripts identical |
| 5 | "matching the legacy Mathews case ordering" | confirmed | all 29 functions and windows match the index, in order |
| 6 | "each case heading gives the function and the node interval" | confirmed | all 29 headings compared with the case table and the computed nodes |
| 7 | 2, 3, 4, 5, 6, 8, 10, 12, 14, 16 nodes | confirmed | `n_nodes_seq`; 10 frames per GIF |
| 8 | "(degree 1 to 5, then 7, 9, 11, 13 and 15)" | confirmed as degree bound; see **F3** | 54 frames have lower exact degree |
| 9 | Equally spaced, "with nodes at both ends of the interval" | confirmed | all 290 node sets asserted equal to a + (b-a)k/(n-1); the trimming branch never fires |
| 10 | Shared script evaluates in first barycentric form, not divided differences | confirmed | lines 122-139 |
| 11 | "The last case ... has its own script, which builds the Newton form from divided differences" | confirmed | `newtpolyaa.jl:13-34` |
| 12 | Source links and Lagrange-page link | confirmed | files exist |

### Cases 01-29

Each row covers the heading's function and node interval, the alt text's window, the GIF title (read at full size in first and last frames), and the embed. "Wiring" (heading NN embeds `lagnewtNN.gif`) was checked by script for all 29. The archive column gives the source for the node interval.

| Case | f, nodes, window | Verdict | Archive support for the nodes |
|---|---|---|---|
| 01 | 1/(1-x), [-1.5, 0.9], [-1.6, 1.5]; beyond pole f ≤ -2, below window (y-min -1.646) | confirmed | legacy GIF |
| 02 | 1/(1+x), [-0.9, 1.5], [-1.5, 1.6]; beyond pole f ≤ -2, below window | confirmed | window only; nodes could not be determined |
| 03 | 1/(1-x)², [-1.5, 0.9], [-1.6, 1.5], pole at 1 | confirmed | window only; nodes could not be determined |
| 04 | √x, [0, 2], [0, 10.5] | confirmed | index text, legacy GIF |
| 05 | √x, [0, 8], [0, 10.5] | confirmed | index text |
| 06 | √x, [0, 10], [0, 10.5] | confirmed | index text |
| 07 | 1/√(1-x), [-1.5, 0.95], [-1.6, 1.5], f for x < 1 | confirmed | Example 6 header |
| 08 | 1/(1+10x²), [-1, 1], [-1.5, 1.5] | confirmed | index text, Example code |
| 09 | ln x, [0.02, 2], [-0.5, 4.1], f for x > 0 | confirmed | index text |
| 10 | ln x, [0.02, 4], same window | confirmed | index text |
| 11 | ln(1+x), [-0.98, 1], [-1.5, 1.5], f for x > -1 | confirmed | index text |
| 12 | sin x, [-3π, 3π] | confirmed; see **F1** | Example 9 code (its header says [-10, 10], its code uses ±3π) |
| 12b | 2, 3, 4 nodes are multiples of π; all divided differences zero; line y = 0 | confirmed | exact coefficients 0; script's max\|P\| = 3.7e-16 |
| 13 | cos x, [-3π, 3π] | confirmed; see **F1** | could not determine (Example 10 header says [-10, 10], its code is absent) |
| 13b | 2 and 4 nodes odd multiples of π; a₀ = -1, rest zero; y = -1 | confirmed | exact; max\|P+1\| = 5.6e-16 |
| 14 | tan x, [-1.45, 1.45], [-π, π], broken at poles | confirmed | Example 11 header and code |
| 14b | f[x₀,x₁,x₂] = 0; degree 1 and 2 frames same line | confirmed | a₂ = 0; max difference 7.1e-15 |
| 15 | eˣ, [-2, 3] | confirmed | Example 12 code |
| 16 | e⁻ˣ cos x, [-2, 4] | confirmed | window only; nodes could not be determined |
| 17 | cosh x, [-4, 4] | confirmed | window only; nodes could not be determined |
| 18 | arctan x, [-2.2, 2.2] | stated values confirmed; departs from archive, see **F4** | Example 13: [-2, 2] |
| 18b | f[x₀,x₁,x₂] = 0; degree 1 and 2 same line | confirmed | a₂ = 0; max difference 4.4e-16 |
| 19 | arcsin x, [-1, 1], [-1.5, 1.5], f on its domain | confirmed | Example 14 header |
| 19b | degree 1 and 2 same line | confirmed | a₂ = 0; max difference 8.9e-16 |
| 20 | J₀, [-10.2, 10.2] | confirmed; see **F1** | could not determine (Example 15 header says [-10, 10], code absent; the sibling Example 9 has a ±10 header over different code nodes) |
| 21 | J₁, [-10.2, 10.2] | confirmed; see **F1** | window only; nodes could not be determined |
| 21b | degree 1 and 2 same line | confirmed | a₂ = 0; max difference 2.6e-18 |
| 22 | normal density, [-3, 3] | confirmed | Example 16 header |
| 23 | ½(1 + erf(x/√2)), [-3, 3] | confirmed | Example 17 code |
| 23b | middle node (0, ½) on the chord; degree 1 and 2 same line | confirmed | a₂ = 0; max difference 3.3e-16 |
| 24 | Γ, [0.05, 2], [-0.2, 5.2] | confirmed | index text |
| 25 | Γ, [0.05, 4], same window | confirmed | index text |
| 26 | Γ, [0.5, 5], same window | confirmed | index text |
| 27 | Y₀, [0.5, 20], [0, 22] | confirmed; see **F1** | index text |
| 28 | Y₀, [0.5, 10], [0, 22] | confirmed | index text |
| 29 | Y₀, [0.5, 4], [0, 22] | confirmed | index text |

### Divided-differences case (`newtpolyaa`)

| # | Claim | Verdict | Stated | Independent (`aa.py`, 40 digits) | Script (`aa_inst.jl`) |
|---|---|---|---|---|---|
| A1 | f = cos x, nodes x_k = k/5 on [0, 1]; "Mathews' Example 1" | confirmed | | archive `gr_109`-`gr_111` | |
| A2 | a₀ | confirmed | 1 | 1.0 | 1 |
| A3 | a₁ | confirmed | -0.0996671 | -0.09966711 | -0.09966711 |
| A4 | a₂ | confirmed | -0.488402 | -0.488402 | -0.488402 |
| A5 | a₃ | confirmed | 0.0490076 | 0.04900763 | 0.04900763 |
| A6 | a₄ | confirmed | 0.0381225 | 0.03812246 | 0.03812246 |
| A7 | a₅ | confirmed | -0.00396205 | -0.003962047 | -0.003962047 |
| A8 | max error, degree 1 | confirmed | 4.97e-3 | 4.9709e-3 at x = 0.0998 | 4.970890e-3 |
| A9 | max error, degree 2 | confirmed | 1.16e-4 | 1.1647e-4 at x = 0.3201 | 1.164690e-4 |
| A10 | max error, degree 5 | confirmed | 1.35e-6 | 1.35e-6 at x = 0.0671 | 1.349993e-6 |
| A11 | error at 2.1, degree 1 | confirmed | 1.30 | 1.2955 | 1.295545 |
| A12 | degree 2 | confirmed | 0.65 | 0.65318 | 0.653179 |
| A13 | degree 3 | confirmed | 0.32 | 0.32076 | 0.320760 |
| A14 | degree 4 | confirmed | 0.067 | 0.067117 | 0.067117 |
| A15 | degree 5 | confirmed | 0.015 | 0.014711 | 0.014711 |
| A16 | degree 2 leaves plot bottom near 1.81 | confirmed | 1.81 | P₂ = -0.6 at 1.8079 | frame 2 |
| A17 | degree 3 leaves plot bottom near 1.95 | confirmed | 1.95 | P₃ = -0.6 at 1.9488 | frame 3 |
| A18 | Each frame adds next node and one Newton term; earlier coefficients do not change | confirmed | | coefficient lists are nested | same |
| A19 | Curves coincide on the shaded interval | confirmed | | largest error 4.97e-3 is about 1 pixel on the 1.7-unit y-axis | frames 1-5 |
| A20 | Drawn on [-0.5, 2.1], "as in Mathews' graphs" | confirmed to reading precision | | `gr_141`, `gr_207` run from -0.5 to just past 2; exact limit not printed | line 42 |
| A21 | Alt: degree 1 (2 nodes) to degree 5 (6 nodes); passes through every node; shaded [x₀, xₙ]; error 4.97e-3 to 1.35e-6; gap 1.30 to 0.015 | confirmed | | node residual ≤ 1.1e-16 | frames |
| A22 | Source link and embed | confirmed | | | |

---

### 3. Implementation checks

### `lagnewt_animations_all.jl`

**It is the method claimed.** It computes the unique interpolating polynomial through equally spaced nodes, evaluated in the first barycentric form (`barycentric_weights`, `barycentric_eval`). It does not build the Newton form; the page says so at line 26.

**The numbers are right.** `review/indep.py` recomputes, for each of 29 cases and 10 node counts, f at the nodes with mpmath and the Newton form by divided differences at 60 digits, then evaluates it at all 1000 plot points and compares with the script's unclamped values.

| Quantity, across all 290 interpolants | Worst result |
|---|---|
| Script node x vs a + (b-a)k/(n-1) | within 1e-12 (asserted) |
| Script node y vs exact f | 2.7e-16 relative |
| Script f vs exact f, every 7th plot-grid point | 3.5e-16 relative |
| Script P vs 60-digit Newton P, all 1000 points (error divided by max(1, \|P\|)) | **5.9e-9** (Case 29, 16 nodes) |
| All other cases | ≤ 2.4e-10 |

Node intervals in the script were asserted equal to the page's headings for all 29 cases.

**Reference values.** f is drawn from Julia's `SpecialFunctions` and Base. It matches mpmath to 3.5e-16 at every 7th grid point and at every node, including Γ, J₀, J₁, Y₀ and erf.

**The picture.** Elements are built from the right quantities: magenta f, blue interpolant, red nodes at the true (x, f(x)). Titles carry the right case, function and n-1. Poles are broken correctly in Cases 01-03 and 14. Frames viewed: first and last of all 29, plus degree 7 or 11 of Cases 12, 13, 21 and 27. The display issues are F1 and F2.

### `newtpolyaa.jl`

**It is the method claimed.** The in-place divided-difference table (lines 13-24) and nested Horner evaluation of the Newton form (lines 27-34) are correct.

**The numbers are right.** See rows A2-A17, where script and independent values agree to all printed digits. The script's error maximum uses a 4001-point grid; a refined search gives the same values to the digits shown. Node residual is ≤ 1.1e-16 in every frame.

**Reference values.** cos x, exact.

**The picture.** All 5 frames viewed. Shading covers [x₀, xₙ], the dashed P_n passes through the n+1 nodes, and the title's a_n and maximum error are the computed ones. P₂ and P₃ leave the fixed window near x = 1.81 and 1.95, as the page says. No clamping is used.

### Regeneration

Per the manifest, scratch copies of both scripts reproduce all 30 committed GIFs byte for byte, so the checks above on the code apply to the published GIFs.

