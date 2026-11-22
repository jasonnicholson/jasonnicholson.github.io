# Fix record: newton-interpolation-polynomial

Work package WP-B, the same fixer as the Lagrange page. The shared script `lagnewt_animations_all.jl` was fixed once and copied byte for byte into this folder (`cmp` silent). The full evidence for the script change is in `fixes/lagrange-polynomial-interpolation-and-approximation.md`.

Scratch folder: `/tmp/claude-1001/-home-jason-Desktop-jasonhnicholson-com/10200257-33f4-4137-89b7-8a70ee9e446f/scratchpad/work/lagrange-polynomial-interpolation-and-approximation/fix/` (the shared-script evidence). The newtpolyaa check is in its subfolder `newtpolyaa/`:

- `dump.jl` prints the script's coefficients, node residuals, errors and P range.
- `indep.py` builds 40-digit mpmath divided differences and sympy exact coefficients.
- `leave.py` checks where each P leaves the window and whether earlier coefficients stay the same.
- `frames/` holds the extracted frames.

## Findings

### F1 — Error — fixed
- Reproduced: `indep.py orig` (an independent 60-digit Newton divided-difference interpolant, compared after clamping) finds exactly three bad frames: ('04', 16, 450 points), ('29', 14, 44) and ('29', 16, 488). `rawrel.py orig`: every bad point has the wrong sign. The largest relative errors are 4.54e3, 129 and 40.6.
- Change: `lagnewt_animations_all.jl` `barycentric_eval` now uses the first barycentric form ℓ(x)·Σ wⱼyⱼ/(x−xⱼ). The script also has the node, span and y-limit changes made for Lagrange F4/F5. Both folders were regenerated.
- Check:
  - `indep.py new` gives a max clamped difference of 2.15e-09 of the y-range over all 290 frames and no bad frames.
  - `rawrel.py new` gives a largest relative error of 1.69e-07 and no wrong-sign points.
  - The evaluator change alone, on the old nodes (`origfirst`), gives 7.85e-10 and no bad frames.
  - New frames 04/010, 29/009 and 29/010 (viewed at full size) have no vertical bars.
  - This folder's 29 GIFs are byte-identical to the Lagrange folder's and to a scratch run.

### F2 — Error — fixed
- Reproduced: the script has `n_nodes_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]`. Each of the 29 GIFs has 10 frames, titled degree 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 (sheets 03, 19 and 24 viewed).
- Change: index.qmd:24 "Each animation increases polynomial degree one step at a time for a fixed function and interval." → "Each animation shows the interpolant on 2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 equally spaced nodes (degree 1 to 5, then 7, 9, 11, 13 and 15) for a fixed function and node interval, with nodes at both ends of the interval."
- Check: as above. "Nodes at both ends": `dump.jl new` shows inset (0.0, 0.0) in all 290 frames.

### F3 — Minor — fixed (text)
- Reproduced: the linked script has `barycentric_weights` and `barycentric_eval` and no divided-difference table or nested evaluation (whole file read, before and after the fix).
- Change: a new paragraph after index.qmd:24: "The shared script draws this same polynomial but evaluates it in the first barycentric (Lagrange) form, not by divided differences; a divided-difference example is to be added." index.qmd:20 now links the [Lagrange page](../lagrange-polynomial-interpolation-and-approximation/index.qmd) and says it gives each case's function and node interval.
- Check:
  - "Same polynomial": `ledger_checks.py` → first form − Lagrange form simplifies to 0. `indep.py new` → the plotted curves agree with a 60-digit Newton divided-difference interpolant to 2.15e-9 of the y-range.
  - "First barycentric form": the script's new `barycentric_eval`.
  - The Lagrange page's headings now give every case's function and node interval (Lagrange F3).

### F4 — Minor — deferred — handled by D3 (director)
- newtpolybb.jl/.gif is to be deleted under D3. It was not touched, and it is not embedded on the page.

## Ledger of changed text

| Location | New text / number | Check (command → result) | Confirmed |
|---|---|---|---|
| index.qmd:20 | link to the Lagrange page; "the Lagrange page gives each case's function and node interval" | Lagrange index.qmd headings "Case NN: f, nodes on [a, b]" for all 29 cases. gen_cases.py → "all intervals match script: True" | yes |
| index.qmd:24 | "2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 equally spaced nodes" | script `n_nodes_seq`. dump.jl → 10 FRAME lines per case | yes |
| index.qmd:24 | "degree 1 to 5, then 7, 9, 11, 13 and 15" | title "degree $(n_nodes - 1)". Sheets 03, 19, 24 and the last-frame montage show degree 15 | yes |
| index.qmd:24 | "for a fixed function and node interval, with nodes at both ends of the interval" | dump.jl new → one span per case, inset (0.0, 0.0) in all 290 frames | yes |
| index.qmd:26 | "draws this same polynomial" | ledger_checks.py → symbolic difference 0. indep.py new → 2.15e-9 of y-range against Newton divided differences | yes |
| index.qmd:26 | "evaluates it in the first barycentric (Lagrange) form, not by divided differences" | script `barycentric_eval` (first form). No divided-difference code in the file | yes |
| index.qmd:26 | "a divided-difference example is to be added" | statement of intent, as the brief allows (D3: newtpolyaa) | n/a |

## Scripts and GIFs
- Script changed: `lagnewt_animations_all.jl`, identical to the Lagrange copy (`cmp` silent). See the Lagrange record for the full diff and its checks.
- GIFs regenerated: `lagnewt01.gif` … `lagnewt29.gif`, by running `julia lagnewt_animations_all.jl` in this folder. All 29 are byte-identical to the Lagrange folder's copies and to the scratch run. `newtpolyaa.gif` and `newtpolybb.gif` were not regenerated or touched.
- Frames viewed: see the Lagrange record. These are the same files.
- `git status --short` for this folder: ` M index.qmd`, ` M lagnewt_animations_all.jl`, and ` M lagnewt01.gif` … `lagnewt29.gif`. Nothing else changed.

## Legacy archive
Consulted:
- `n2003/NewtonPolyMod.html`. Its Animations link is the same `/a2001/Animations/Interpolation/Lagrange/Lagrange.html` page as the Lagrange module, titled "Animations for Lagrange & Newton Polynomials". That is why the two site pages share the 29 cases.
- For what that list and its animations show (node intervals, endpoints included in Mathews' frames), see the Lagrange record.
- The archive was not used for newtpolyaa (cos x on [0, 2π]). No matching animation was looked for, and the proposal below rests only on computation.

## Notes

### D3: proposed newtpolyaa case

**Verdict: correct.** The script computes the Newton form correctly and the GIF shows it correctly. No correction is needed. One optional cosmetic point is listed at the end.

Evidence:
- `julia newtpolyaa.jl` in scratch regenerates a GIF byte-identical to the committed `newtpolyaa.gif`.
- **Nodes.** The nodes are `range(0, 2π, length=7)`, so xₖ = kπ/3, k = 0…6. Frame n uses the first n+1 of them, for n = 0…6, which gives 7 frames.
- **Coefficients.** The script gives a = [1.0, −0.47746482927568595, −0.22797266319526005, 0.1451319049493977, −0.017323845054779807, −0.0033086106885915536, 0.0010531634917120504]. The independent 40-digit mpmath divided differences agree to every printed digit (12 significant). sympy gives the exact values aₖ = 1, −3/(2π), −9/(4π²), 9/(2π³), −27/(16π⁴), −81/(80π⁵), 81/(80π⁶).
- **Prefix property.** For every n, the first n coefficients are the same as in frame n−1 (`leave.py`: "earlier coefficients unchanged: True").
- **Fit.** The node residual is at most 4.2e-15. The degree-6 maximum of |P₆ − cos| on [0, 2π] is 0.00711631, at x ≈ 0.3131 (mpmath, 6001-point grid). The script's own value is 0.007116186.
- **Frames viewed.** The contact sheet and frame 6 at full size. The titles read "Newton Polynomial for cos(x) — degree n (n+1 nodes)" and are correct for n = 0…6. The dashed P passes through the black nodes.
- **Window.** For degrees 1 to 4 the polynomial leaves the window (ylims ±1.6), always to the right of the newest node: on x ∈ [5.45, 2π], [2.89, 2π], [4.78, 2π] and [5.56, 2π] respectively. In each case the newest node is at 1.047, 2.094, 3.142 or 4.189 (`leave.py`). At degrees 0, 5 and 6 it stays inside.
- **Optional cosmetic.** The legend prints the literal text "P_5(x)", because GR shows the underscore as is. Changing `label="P_$n(x)"` to a Unicode subscript, for example `label="P" * join(Char(0x2080 + d) for d in reverse(digits(n))) * "(x)"`, would fix it without a new dependency. This is not required for correctness.

Proposed case block for the Newton page, placed after the source link line and before "### Case 01". It uses the page's existing style and adds a Behavior paragraph:

```markdown
### Divided differences: $f(x)=\cos x$, nodes $x_k = k\pi/3$ on $[0, 2\pi]$

**Behavior:** Each frame adds the next node and one more Newton term $a_n\prod_{j<n}(x-x_j)$; the coefficients already found do not change. The divided differences are $a_0,\ldots,a_6 = 1,\ -\tfrac{3}{2\pi},\ -\tfrac{9}{4\pi^2},\ \tfrac{9}{2\pi^3},\ -\tfrac{27}{16\pi^4},\ -\tfrac{81}{80\pi^5},\ \tfrac{81}{80\pi^6}$. For degrees 1 to 4 the polynomial leaves the plot to the right of the newest node; with all seven nodes (degree 6) the largest error on $[0, 2\pi]$ is 0.0071.

[Julia source](newtpolyaa.jl)

![Newton interpolation of cos x on [0, 2π], adding one node x_k = kπ/3 per frame from degree 0 (1 node) to degree 6 (7 nodes); the dashed polynomial passes through every node and matches cos x within 0.0071 at degree 6.](newtpolyaa.gif)
```

Ledger for the proposed block:

| Text / number | Check (command → result) | Confirmed |
|---|---|---|
| nodes $x_k = k\pi/3$ on $[0, 2\pi]$, 1 to 7 nodes, degree 0 to 6 | newtpolyaa.jl: `range(0.0, 2π, length=7)`, `for n in 0:6`. dump.jl XS = [0, 1.0472, …, 6.2832]. 7 frames | yes |
| "adds the next node and one more Newton term $a_n\prod_{j<n}(x-x_j)$" | script: `xs_n = all_xs[1:n+1]`. `newton_eval` is Horner on that form | yes |
| "the coefficients already found do not change" | leave.py → "earlier coefficients unchanged: True" for n = 1…6 | yes |
| $a_0..a_6$ exact values | indep.py (sympy) → [1, −3/(2π), −9/(4π²), 9/(2π³), −27/(16π⁴), −81/(80π⁵), 81/(80π⁶)]. Numerically equal to the script's coefficients (dump.jl) to 12 digits | yes |
| "for degrees 1 to 4 the polynomial leaves the plot to the right of the newest node" | leave.py → outside \|y\| > 1.6 on [5.4465, 6.2832], [2.8945, 6.2832], [4.7794, 6.2832], [5.5596, 6.2832] for n = 1…4, all right of the newest node (1.0472, 2.0944, 3.1416, 4.1888). None for n = 0, 5, 6 | yes |
| "largest error on $[0, 2\pi]$ is 0.0071" (degree 6) | indep.py → 0.00711631 at x = 0.313112. dump.jl → 0.007116186 | yes |
| alt "dashed polynomial passes through every node" | dump.jl node residual ≤ 4.2e-15. Sheet viewed | yes |

### Other notes
- The alt texts on this page still read "Newton interpolation animation for case NN from the legacy function-and-interval list". After this fix, index.qmd:20 points to the Lagrange page, which now gives that list. Round 1 did not raise these alt texts as a finding here, so they were left as they are. The director may want to mirror the Lagrange headings here.
- The Planned section and the orphan files (`newtpolyaa.*`, `newtpolybb.*`) were not touched.

## Round 2 after check

The independent check found Newton F1–F3 resolved. F4 is handled by D3. The two new Minor items it raised concern the shared GIFs, so they apply to this page too. The full evidence and ledger are in `fixes/lagrange-polynomial-interpolation-and-approximation.md`, under "Round 2 after check".

- **R2-1 (Cases 12 and 13: constant interpolants in early frames) — fixed (text, on the Lagrange page).**
  - With 2, 3 and 4 nodes on [−3π, 3π] every node is a multiple of π, so sin gives the line y = 0. With 2 and 4 nodes every node is an odd multiple of π, so cos gives y = −1 (`round2/sincos_out.txt`).
  - The explanation was added to the Lagrange page's Case 12 and 13 text and alt texts. This page names no case functions and refers readers to the Lagrange page for each case's function and node interval (index.qmd:20), so this page's text was not changed.
- **R2-2 (half-markers at the window edge) — fixed (script).**
  - A 2% x-margin was added to the axis in the shared script. The plotted values are unchanged (`dump.txt` byte-identical before and after).
  - The script was copied byte for byte (`cmp` silent), and this folder's 29 GIFs were regenerated. They are byte-identical to the Lagrange folder's.
  - This page's sentences remain true. "Equally spaced nodes … with nodes at both ends of the interval" is unaffected, because nodes are unchanged.
- **D3 proposal re-checked.** The round-2 change touches only `lagnewt_animations_all.jl`. `newtpolyaa.jl` and `newtpolyaa.gif` are unchanged (`git status` shows them unmodified). The proposed case block and its ledger (coefficients, error 0.0071, degrees 1–4 leaving the window) still hold as written. The insertion point, after the source link line (now after the new paragraph at index.qmd:26) and before "### Case 01", is still valid.
- `git status --short` for this folder: ` M index.qmd`, ` M lagnewt_animations_all.jl`, and ` M lagnewt01.gif` … `lagnewt29.gif`. Nothing else changed.

### Director note

The checker noted a pre-existing issue that is not a round-1 finding and was left unchanged: the alt texts on this page still read "…from the legacy function-and-interval list", and Cases 12 and 13 here lack the note on flat low-degree frames that the Lagrange page now has. Flagged for the round-2 review. F4 (newtpolybb) is handled by the separate D3 commit.

## Resolution check (independent checker, not shown this record)

Scratch work: `check/run/` (regenerated GIFs), `check/instr.jl` + `check/instr_out.txt` (290-frame audit against a 512-bit Newton divided-difference reference on the same Float64 data), `check/sign2.jl` (second-form sign check on the new nodes), `check/frames/lagnewtNN/` (all 29 current GIFs, every frame + sheet), `check/old/` (pre-fix 04, 08, 14, 19, 29 from the local LFS object store).

### Original findings

### Lagrange F1: resolved
- Old line 25 is gone. The new sentence says the degree goes 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 on 2, 3, 4, 5, 6, 8, 10, 12, 14, 16 nodes. That matches `n_nodes_seq` (script line 158). All 29 GIFs have 10 frames, and the frame titles read degree 1…5, 7, 9, 11, 13, 15 (sheets for 01, 04, 09, 12, 13, 14, 19, 24, 27, 29).

### Lagrange F2: resolved
- `barycentric_eval` now uses the first form `l(x)·Σ w_j y_j/(x−x_j)` (lines 120–129).
- Audit of all 290 (case, degree) frames against a 512-bit divided-difference reference, both clamped to the frame's ylims: the worst difference is 8.7e-10 of the y-range (case 29, n=16), there are 0 points off by more than 1e-6, and the worst unclamped relative error is 6.6e-8. The first form gives 0 wrong-sign points in 04 (n=14, 16) and in 29 (n=14, 16).
- Frames: in lagnewt04 frame 10 and lagnewt29 frame 10 the interpolant rises once and runs along the top edge, with no vertical bars. Pre-fix lagnewt04 frame 10 had bars at x≈5.7 and 9.6–10.4.
- The old line 12 claim ("numerically stable") is replaced. See the ledger for the new claim about the second form.

### Lagrange F3: resolved
- Each heading now gives the function and the node interval, and each alt text names the function, the interval, the degree range and the plot window. Every interval and window matches the script table and `resolved_span` (printed spans in `instr_out.txt`). Line 21 now states the node placement.

### Lagrange F4: resolved
- `equal_nodes` now uses trim = 0 on the first attempt, so nodes run from a to b with both endpoints included. The retry never fires: in all 290 frames `xs[1]==a` and `xs[end]==b`, with second differences ≤ 4.4e-16.
- √x now has a node at x = 0 (frame 10 of case 04: the red node sits at (0, 0)).
- Case 08 nodes are on [−1, 1]. Frame 10 shows Runge spikes to ≈0.58 near x = ±0.97, where f ≈ 0.096, an error of ≈0.485, as expected.
- `resolved_span` now uses the listed span as given.

### Lagrange F5: resolved
- ynode now gathers node values from every frame (line 172).
- Case 14 moved to nodes on [−3, 3]. ylims are (−27.79, 27.79). The largest node value is ±22.41 (n=14). nodesOut = 0 in all 290 frames.
- lagnewt14 frame 9 (degree 13) shows all 14 nodes, including (−1.615, 22.4) and (1.615, −22.4). Pre-fix frame 9 showed 12.
- The optional suggestion (say on the page what tan is meant to show) was not done. That is acceptable for a Minor finding.

### Newton F1: resolved
- The fix is the same as Lagrange F2 (byte-identical script and GIFs), with the same evidence. The bars are gone in lagnewt04 frame 10 and lagnewt29 frames 9 and 10.

### Newton F2: resolved
- New line 24: "2, 3, 4, 5, 6, 8, 10, 12, 14 and 16 equally spaced nodes (degree 1 to 5, then 7, 9, 11, 13 and 15) … with nodes at both ends of the interval". This is true. All 290 frames have both endpoints as nodes.

### Newton F3: resolved
- New line 26 says the shared script evaluates the same polynomial in the first barycentric (Lagrange) form, not by divided differences. That is true of the script. "Same polynomial" is verified: it agrees with the divided-difference reference to ≤8.7e-10 of the y-range. "A divided-difference example is to be added" is a promise, not a claim.

### Newton F4: not resolved (out of scope: D3)
- The diff does not touch `newtpolybb.jl` or `newtpolybb.gif`, and both are still on disk.

### Changed-text ledger

| Location | Text / number | Check | Verdict |
|---|---|---|---|
| L index:12 | first form P_n = ℓ(x)Σ w_i y_i/(x−x_i), ℓ = Π(x−x_j), w_i = 1/Π_{j≠i}(x_i−x_j) | Matches the script lines 101–129 and the standard identity. Agrees with the 512-bit reference in all frames. | true |
| L index:12 | "stays accurate far outside the nodes" | Worst relative error 6.6e-8 over all frames, including case 29 out to x = 22 | true |
| L index:12 | second form "gives values of the wrong sign in Cases 04 and 29" | With the current nodes, the second form gives the wrong sign at 4 and 1 points (case 04, n=14 and 16, x ≈ 9.5–10.4) and at 2 and 151 points (case 29, n=14 and 16, x ≈ 11.7–20). No other case fails (`instr_out.txt`, `sign2.jl`). | true |
| L index:21 | nodes equally spaced from a to b, endpoints included | All 290 frames | true |
| L index:21 | window wider than [a,b] in Cases 04–06, 08–11, 14, 19, 24–29 | Compared xlims with span for all 29. The list is exact; the other cases have the window equal to the span. | true |
| L index:25 | degrees 1, 2, 3, 4, 5, 7, 9, 11, 13, 15 / nodes 2 … 16 | Script line 158 and frame titles | true |
| L index:25 | off-window curve drawn along the top or bottom edge | `clamp` on both curves (lines 182, 189). Seen in 04, 24 and 29 frames. | true |
| L headings 01–29 | function and interval, e.g. 01 1/(1−x) [−1.6,0.9]; 04 √x [0,2]; 05 [0,8]; 06 [0,10]; 08 [−1,1]; 09 ln x [0.02,2]; 10 [0.02,4]; 11 ln(1+x) [−0.98,1]; 12/13 [−3π,3π]; 14 tan [−3,3]; 15 eˣ [−2,3]; 16 e⁻ˣcos x [−2,4]; 17 cosh [−4,4]; 18 arctan [−2.2,2.2]; 19 arcsin [−1,1]; 20/21 J₀/J₁ [−10.2,10.2]; 22 normal pdf [−3,3]; 23 ½(1+erf(x/√2)) [−3,3]; 24–26 Γ [0.05,2], [0.05,4], [0.5,5]; 27–29 Y₀ [0.5,20], [0.5,10], [0.5,4] | Each compared with the script lambdas and with `resolved_span` as printed by the audit | all true |
| L alt texts 01–29 | "degree rising from 1 to 15", window "[0,10.5]", "[−1.5,1.5]", "[−0.5,4.1]", "[−π,π]", "[−0.2,5.2]", "[0,22]", "the same interval" | Compared with xlims for every case. f is drawn where finite (log, asin and Γ are not drawn outside their domains). | true |
| N index:20 | Lagrange page gives each case's function and node interval; link `../lagrange-…/index.qmd` | It does. The link style matches another page (`../nonlinear-systems/index.qmd`). | true |
| N index:24 | node counts, degrees, nodes at both ends | As above | true |
| N index:26 | first barycentric (Lagrange) form, not divided differences | Script lines 120–129 | true |
| script:36–38 | 5 equally spaced nodes on [−π,π] land on ±π/2 | −π + kπ/2, k = 0…4, includes ±π/2 | true |
| script:76–79, 86–88 | span used as given; trim only if f is non-finite at a node | The code does this; the retry never fires | true |

### New problems

1. **Minor.** Cases 12 and 13 now open with degenerate frames that the page does not explain.
   - Location: lagnewt12.gif frames 1–3 and lagnewt13.gif frames 1 and 3.
   - Cause: with endpoints included, the 2-, 3- and 4-node sets on [−3π, 3π] fall on multiples of π.
     - sin is 0 at every one of those nodes, so the "degree 1, 2, 3" frames of case 12 all show the same flat line y = 0.
     - cos is −1 at the 2- and 4-node sets, so the "degree 1" and "degree 3" frames of case 13 show y = −1.
   - The mathematics is correct (the page says "degree at most n"). But the first three frames of case 12 are identical and labelled degree 1/2/3. The pre-fix inset nodes avoided this.
   - A sentence in the case text, or a different span, would fix it.
2. **Minor (cosmetic).** In the cases where the node interval equals the plot window (01–03, 07, 12, 13, 15–18, 20–23), the two end nodes now sit on the plot frame and are drawn as half-markers. Example: lagnewt01 node at (0.9, 10). They are still visible.

Pre-existing and not introduced by this fix: the Newton page's 29 alt texts still read "Newton interpolation animation for case NN from the legacy function-and-interval list". These are not descriptive by the convention at animation-page.agent.md:203. Line 20 now points to the Lagrange page for the list, which softens this. The orphan files `lagrangeaa.jl`, `newtpolyaa.*` and `newtpolybb.*` remain from the inventory.

Nothing else found. This rests on:
- the 290-frame clamped comparison against the high-precision reference;
- the endpoint and node-visibility audit;
- full-size views of frames 9 and 10 of 04, 08, 14, 19 and 29, and the pre-fix 04 and 14;
- contact sheets of 01, 04, 09, 12, 13, 14, 19, 24, 27 and 29.

### Reproducibility and conventions

- Both script copies are byte-identical (`cmp`).
- A scratch run (22 s) reproduces all 29 GIFs byte for byte against both the Lagrange folder (29/29) and the Newton folder (29/29). The two folders' GIFs are also identical to each other.
- Both pages keep the conventions: Description, then Animations, then Derivation Notes; one source link; 29 embeds of 29 distinct GIFs; no code fences. The Lagrange alt texts are now descriptive.
- Files outside the two page folders: the working tree has modifications in other pages (pade, romberg, monte-carlo-pi and others), but none of them appears in this fix's diff. They belong to other pages' fixes. The diff itself touches only the two folders.

### Re-check

This re-check covers the fixer's second pass: Case 12/13 sentences and alt text, a 2% x-margin, and one reworded intro line. Scratch work for it is in `check/run2/`, `check/frames2/`, `check/flat.jl` and `check/instr_out2.txt`.

### New problem 1 (flat low-degree frames in Cases 12/13): resolved
- **Case 12 sentence and alt text: true.** I computed the nodes myself (`flat.jl`):
  - the 2-, 3- and 4-node sets are {±3π}, {−3π, 0, 3π} and {±3π, ±π};
  - all of these are multiples of π;
  - the interpolant satisfies max|P| = 3.7e-16 over the window in each of those frames, so it is the line y = 0 to rounding;
  - with 5 nodes (±1.5π added), max|P| = 1.03, so the flat frames stop exactly at degree 3.
- **Case 13 sentence and alt text: true.**
  - With 2 and 4 nodes, every node is an odd multiple of π and cos = −1 there; max|P+1| is 2.2e-16 and 5.6e-16.
  - The 3-node set includes 0, where cos = 1, so the degree-2 frame is a parabola. That matches the sentence, which does not claim degree 2.
- **Frames.** Viewed at full size: lagnewt12 frames 1 and 3, a flat blue line at y = 0 through 2 and 4 red nodes. Contact sheet of lagnewt13: frames 1 and 3 are flat at −1, frame 2 is a parabola through (0, 1).
- **Node interval.** Kept at [−3π, 3π]. The heading still matches `resolved_span`.

### New problem 2 (half-drawn end markers): resolved
- **What changed.** The script now sets `xlims = case.xlims ± 0.02·width` (lines 183–185, 195). Only the axis changed: xplot, the nodes, ylims and every plotted value are unchanged.
  - The 290-frame audit gives output identical to the first check, apart from the secondForm column, which I did not compare: all nodes at both endpoints, nodesOut = 0, and the worst clamped difference from the 512-bit reference is 8.7e-10 of the y-range.
- **Frames.** Viewed at full size: lagnewt01 frame 10 (end nodes at x = −1.6 and 0.9), lagnewt20 frame 5 (±10.2), lagnewt12 frames 1 and 3 (±3π) and lagnewt04 frame 10 (node at x = 0). All end markers are drawn whole.
- **Side effect.** The curves stop at the case window and leave a thin blank strip at each side. In 04 and 29 the clamped top-edge segment stops at x = 10.5 and x = 22. Harmless.

### Reworded intro line: true
- New wording (L index:21): "Where $f$ is drawn on a wider interval than $[a, b]$ (Cases 04–06, 08–11, 14, 19 and 24–29)".
- f is drawn on xplot = case.xlims. For exactly these cases, xlims strictly contains the span, as in the earlier ledger check. The wording is now independent of the padded axis, so it stays accurate.

### Previous verdicts still hold
- Lagrange F1–F5 resolved; Newton F1–F3 resolved; Newton F4 not resolved (out of scope: D3).
- I checked again:
  - lagnewt04 frame 10 and lagnewt29 frame 10: no bars, the curve runs along the top edge;
  - lagnewt14 frame 9: all 14 nodes visible;
  - headings, ledger rows and the Newton text: unchanged apart from the items above.

### Reproducibility and conventions
- Both script copies are byte-identical.
- A scratch run of the current script reproduces 29/29 GIFs byte for byte in the Lagrange folder and 29/29 in the Newton folder.
- Both pages: Description, then Animations; one source link; 29 embeds; no code fences.
- The new case sentences are prose between the heading and the embed, which is fine.
- The diff touches only the two page folders.

### New problems
- None.
- What this rests on:
  - the node and interpolant computation for 12/13;
  - the unchanged 290-frame audit;
  - full-size views of 01, 04, 12 (frames 1 and 3), 14, 20 and 29;
  - the 13 contact sheet.
- Still pre-existing and outside this fix: the Newton page's alt texts read "…from the legacy function-and-interval list", including Cases 12 and 13, which carry no note there. The Newton page points readers to the Lagrange page for the case details.

**Final status:** committed

## D3 (orphan files), applied by the director

- Deleted `newtpolybb.jl`/`.gif` (resolves F4) and, on the Lagrange page, the unlinked `lagrangeaa.jl`.
- Added the verified `newtpolyaa` case after Case 29, using the block proposed above unchanged. Scoped the page's counts to Cases 01–29: "Cases 01–29 below intentionally reuse…", "Cases 01–29 each show…", and "[Julia source for Cases 01–29]". Replaced "a divided-difference example is to be added" with a pointer to the new last case.
- Independent check (`d3/check/resolution.md`): F4 resolved; orphan inventory resolved; newtpolyaa.jl really builds the divided-difference table and its GIF reproduces byte for byte; all seven coefficients match sympy exactly; 'degrees 1 to 4 leave the plot' holds; degree-6 max error is 0.007116. A stale '29 animations' count was found and fixed, then re-checked. The checker's optional nit about the source-link label was also applied.

**F4 final status:** fixed (D3)
